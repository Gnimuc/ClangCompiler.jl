"""
    abstract type AbstractCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractCompiler end

struct SimpleCompiler <: AbstractCompiler
    ctx::Context
    instance::CompilerInstance
    codegen::CodeGenerator
    parser::Parser
end

function create_compiler(src::String, args::Vector{String}; diag_show_colors=true)
    ctx = Context()
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
    create_preprocessor(instance)
    create_ast_context(instance)
    codegen = create_llvm_codegen(instance, ctx)
    set_code_generator(instance, codegen)
    create_sema(instance)
    # parser
    preprocessor = get_preprocessor(instance)
    sema = get_sema(instance)
    parser = Parser(preprocessor, sema)
    return SimpleCompiler(ctx, instance, codegen, parser)
end

function destroy(x::SimpleCompiler)
    destroy(x.parser)
    destroy(x.instance)
    dispose(x.ctx)
end

function compile(x::SimpleCompiler)
    parse(x.instance, x.codegen, x.parser) || error("failed to parse the source code.")
    m = get_llvm_module(x.codegen)
    m == C_NULL && error("failed to generate IR.")
    return LLVM.Module(m)
end
