"""
    abstract type AbstractCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractCompiler end

"""
    struct IRGenerator <: Any
LLVM IR Generator via Clang's `LLVMOnlyAction`.
"""
struct IRGenerator
    ts_ctx::ThreadSafeContext
    instance::CompilerInstance
    act::LLVMOnlyAction
end

function generate_llvmir(src::String, args::Vector{String}; diag_show_colors=true)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    set_opt_show_presumed_loc(instance, true)
    set_opt_show_colors(instance, diag_show_colors)
    create_diagnostics(instance)
    diag = get_diagnostics(instance)
    # invocation
    # do not emit `__dso_handle` etc.
    insert!(args, length(args), "-fno-use-cxa-atexit")
    invok = create_compiler_invocation_from_cmd(src, args, diag)
    set_invocation(instance, invok)
    # codegen action
    act = LLVMOnlyAction(ctx)
    execute_action(instance, act)
    return IRGenerator(ts_ctx, instance, act)
end

get_module(x::IRGenerator) = take_module(x.act)
get_context(x::IRGenerator) = x.ts_ctx

function destroy(x::IRGenerator)
    destroy(x.instance)
    destroy(x.act)
    dispose(x.ts_ctx)
end

"""
    struct CxxCompiler <: AbstractCompiler
[`IRGenerator`](@ref) + [`LLJIT`](@ref).
"""
struct CxxCompiler <: AbstractCompiler
    irgen::IRGenerator
    jit::LLJIT
end

get_module(x::CxxCompiler) = get_module(x.irgen)
get_context(x::CxxCompiler) = get_context(x.irgen)
get_dylib(x::CxxCompiler) = JITDylib(x.jit)
get_jit(x::CxxCompiler) = x.jit
get_codegen(x::CxxCompiler) = x.irgen

function link_process_symbols(cc::CxxCompiler)
    jd = get_dylib(cc)
    jit = get_jit(cc)
    prefix = LLVM.get_prefix(jit)
    dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(prefix)
    add!(jd, dg)
end

function compile(cc::CxxCompiler)
    ts_mod = ThreadSafeModule(get_module(cc); ctx=get_context(cc))
    jd = get_dylib(cc)
    jit = get_jit(cc)
    add!(jit, jd, ts_mod)
end

function destroy(x::CxxCompiler)
    destroy(x.irgen)
    dispose(x.jit)
end

"""
    struct IncrementalCompiler <: AbstractCompiler
"""
struct IncrementalCompiler <: AbstractCompiler
    ts_ctx::ThreadSafeContext
    instance::CompilerInstance
    parser::Parser
    modules::Vector{LLVM.Module}
    current_module::Int
end

function create_incremental_compiler(src::String, args::Vector{String}; diag_show_colors=true)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    set_opt_show_presumed_loc(instance, true)
    set_opt_show_colors(instance, diag_show_colors)
    create_diagnostics(instance)
    diag = get_diagnostics(instance)
    # invocation
    # do not emit `__dso_handle` etc.
    insert!(args, length(args), "-fno-use-cxa-atexit")
    invok = create_compiler_invocation_from_cmd(src, args, diag)
    set_invocation(instance, invok)
    set_target(instance)
    # source
    create_file_manager(instance)
    create_source_manager(instance)
    set_main_file(instance, src)
    # preprocessor & AST & sema
    create_preprocessor(instance, CXTU_Prefix)
    create_ast_context(instance)
    codegen = create_llvm_codegen(instance, ctx, "JLCC_Incremental_1")
    set_ast_consumer(instance, codegen)
    create_sema(instance, CXTU_Prefix)
    # parser
    preprocessor = get_preprocessor(instance)
    enable_incremental(preprocessor)
    sema = get_sema(instance)
    parser = Parser(preprocessor, sema)
    # parse
    diag_csr = get_diagnostic_client(instance)
    begin_source_file(diag_csr, get_lang_options(instance), preprocessor)

    initialize_builtins(preprocessor)
    enter_main_file(preprocessor)

    initialize(parser)

    sema = get_sema(instance)
    ast_ctx = get_ast_context(instance)

    if try_parse_and_skip_invalid_or_parsed_decl(parser, codegen)
        process_weak_toplevel_decls(sema, codegen)
        handle_translation_unit(codegen, ast_ctx)
    end

    end_source_file(diag_csr)

    m_cur = release_llvm_module(codegen)
    m_cur.ref == C_NULL && error("failed to generate IR.")

    m_next = start_llvm_module(codegen, context(m_cur), "JLCC_Incremental_2")

    return IncrementalCompiler(ts_ctx, instance, parser, [m_cur, m_next], 2)
end

function destroy(x::IncrementalCompiler)
    destroy(x.parser)
    destroy(x.instance)
    pop!(x.modules)  # we don't have the ownership of the latest module
    dispose.(x.modules)
    dispose(x.ts_ctx)
end
