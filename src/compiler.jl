"""
    abstract type AbstractCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractCompiler end

"""
    abstract type AbstractIRGenerator <: AbstractCompiler
Supertype for LLVM IR generators.
"""
abstract type AbstractIRGenerator <: AbstractCompiler end

# interface
get_instance(x::AbstractIRGenerator) = x.instance
get_context(x::AbstractIRGenerator) = x.ts_ctx

"""
    struct IRGenerator <: AbstractIRGenerator
LLVM IR Generator via Clang's `LLVMOnlyAction`.
"""
struct IRGenerator <: AbstractIRGenerator
    ts_ctx::ThreadSafeContext
    instance::CompilerInstance
    act::LLVMOnlyAction
end

get_module(x::IRGenerator) = take_module(x.act)

function IRGenerator(src::String, args::Vector{String}; diag_show_colors=true, no_use_cxa_atexit=false)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    set_opt_show_presumed_loc(instance, true)
    set_opt_show_colors(instance, diag_show_colors)
    create_diagnostics(instance)
    diag = get_diagnostics(instance)
    # invocation
    if no_use_cxa_atexit
        # do not emit `__dso_handle` etc.
        insert!(args, length(args), "-fno-use-cxa-atexit")
    else
        icxxabi_inc = joinpath(@__DIR__, "..", "abi") |> normpath
        insert!(args, length(args), "-isystem$icxxabi_inc")
        insert!(args, length(args), "-includeicxxabi.h")
    end
    invok = create_compiler_invocation_from_cmd(src, args, diag)
    set_invocation(instance, invok)
    # codegen action
    act = LLVMOnlyAction(ctx)
    execute_action(instance, act)
    return IRGenerator(ts_ctx, instance, act)
end

function dispose(x::IRGenerator)
    dispose(x.instance)
    dispose(x.act)
    dispose(x.ts_ctx)
end

"""
    struct CXCompiler <: AbstractCompiler
[`IRGenerator`](@ref) + [`LLJIT`](@ref).
"""
struct CXCompiler <: AbstractCompiler
    irgen::IRGenerator
    jit::LLJIT
end

get_instance(x::CXCompiler) = get_instance(irgen)
get_context(x::CXCompiler) = get_context(x.irgen)
get_module(x::CXCompiler) = get_module(x.irgen)
get_jit(x::CXCompiler) = x.jit
get_dylib(x::CXCompiler) = JITDylib(x.jit)
get_codegen(x::CXCompiler) = x.irgen

function link_process_symbols(cc::CXCompiler)
    jd = get_dylib(cc)
    jit = get_jit(cc)
    prefix = LLVM.get_prefix(jit)
    dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(prefix)
    add!(jd, dg)
end

function compile(cc::CXCompiler)
    ts_mod = ThreadSafeModule(get_module(cc); ctx=get_context(cc))
    jd = get_dylib(cc)
    jit = get_jit(cc)
    add!(jit, jd, ts_mod)
end

function dispose(x::CXCompiler)
    dispose(x.irgen)
    dispose(x.jit)
end

"""
    mutable struct IncrementalIRGenerator <: AbstractIRGenerator
Incremental LLVM IR Generator.
"""
mutable struct IncrementalIRGenerator <: AbstractIRGenerator
    ts_ctx::ThreadSafeContext
    instance::CompilerInstance
    parser::Parser
    modules::Vector{LLVM.Module}
    current_module::Int
    src_counter::Int
end

get_parser(x::IncrementalIRGenerator) = x.parser
get_modules(x::IncrementalIRGenerator) = x.modules
get_current_module(x::IncrementalIRGenerator) = x.modules[x.current_module]

function IncrementalIRGenerator(src::String, args::Vector{String}; diag_show_colors=true, no_use_cxa_atexit=false)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    set_opt_show_presumed_loc(instance, true)
    set_opt_show_colors(instance, diag_show_colors)
    create_diagnostics(instance)
    diag = get_diagnostics(instance)
    # invocation
    if no_use_cxa_atexit
        # do not emit `__dso_handle` etc.
        insert!(args, length(args), "-fno-use-cxa-atexit")
    else
        icxxabi_inc = joinpath(@__DIR__, "..", "abi") |> normpath
        insert!(args, length(args), "-isystem$icxxabi_inc")
        insert!(args, length(args), "-includeicxxabi.h")
    end
    invok = create_compiler_invocation_from_cmd(src, args, diag)
    set_invocation(instance, invok)
    set_target(instance)
    # source
    create_file_manager(instance)
    create_source_manager(instance)
    set_main_file(instance, src)
    # preprocessor & AST & sema
    create_preprocessor(instance, CXTranslationUnitKind_TU_Prefix)
    create_ast_context(instance)
    codegen = create_llvm_codegen(instance, ctx, "JLCC_Incremental_1")
    set_ast_consumer(instance, codegen)
    create_sema(instance, CXTranslationUnitKind_TU_Prefix)
    # parser
    preprocessor = get_preprocessor(instance)
    enable_incremental(preprocessor)
    sema = get_sema(instance)
    parser = Parser(preprocessor, sema)
    begin_diag(instance)
    try
        initialize_builtins(preprocessor)
        enter_main_file(preprocessor)
        initialize(parser)

        ast_ctx = get_ast_context(instance)

        if try_parse_and_skip_invalid_or_parsed_decl(parser, codegen)
            process_weak_toplevel_decls(sema, codegen)
            handle_translation_unit(codegen, ast_ctx)
        end
    finally
        end_diag(instance)
    end

    # generate llvm modules
    m_cur = release_llvm_module(codegen)
    m_cur.ref == C_NULL && error("failed to generate IR.")

    m_next = start_llvm_module(codegen, context(m_cur), "JLCC_Incremental_2")

    return IncrementalIRGenerator(ts_ctx, instance, parser, [m_cur, m_next], 2, 1)
end

function incremental_parse(irgen::IncrementalIRGenerator, code::String)
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    pp = get_preprocessor(ci)
    src_mgr = get_source_manager(ci)
    codegen = get_ast_consumer(ci)
    buffer = get_buffer(code)
    fid = FileID(src_mgr, buffer)
    begin_diag(ci)
    loc = get_loc_with_offset(get_loc_for_start_of_main_file(src_mgr), irgen.src_counter)
    enter_file(pp, fid, loc)
    try
        if try_parse_and_skip_invalid_or_parsed_decl(parser, codegen)
            process_weak_toplevel_decls(get_sema(ci), codegen)
            handle_translation_unit(codegen, get_ast_context(ci))
        end
    finally
        dispose(fid)
        end_file(pp)
        end_diag(ci)
        irgen.src_counter += 1
    end
    # generate llvm modules
    m_cur = release_llvm_module(codegen)
    m_cur.ref == C_NULL && error("failed to generate IR.")
    irgen.current_module += 1
    m_next = start_llvm_module(codegen, context(m_cur), "JLCC_Incremental_$(irgen.current_module)")
    push!(irgen.modules, m_next)

    return m_cur
end

function dispose(x::IncrementalIRGenerator)
    dispose(x.parser)
    dispose(x.instance)
    pop!(x.modules)  # we don't have the ownership of the latest module
    dispose.(x.modules)
    dispose(x.ts_ctx)
end

function parse_cxx_scope_spec(irgen::IncrementalIRGenerator, str::String, spec::CXXScopeSpec)
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    parse_cxx_scope_spec(ci, parser, str, spec)
end

function (x::DeclFinder)(irgen::IncrementalIRGenerator, decl::String, scope::String="")
    ci = get_instance(irgen)
    parser = get_parser(irgen)
    return x(ci, parser, decl, scope)
end
