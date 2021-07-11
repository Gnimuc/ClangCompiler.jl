"""
    abstract type AbstractCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractCompiler end

struct CXXCompiler <: AbstractCompiler
    instance::CompilerInstance
    codegen::CodeGenerator
    parser::Parser
end

function create_compiler(src::String, args::Vector{String}; diag_show_colors=true)
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
    codegen = create_llvm_codegen(instance, LLVMGetGlobalContext())
    set_code_generator(instance, codegen)
    create_sema(instance)
    # parser
    preprocessor = get_preprocessor(instance)
    sema = get_sema(instance)
    parser = Parser(preprocessor, sema)
    return CXXCompiler(instance, codegen, parser)
end

function destroy(x::CXXCompiler)
    destroy(x.instance)
    destroy(x.parser)
end

function compile(x::CXXCompiler)
    parse(x.instance, x.codegen, x.parser) && "failed to compile!"
    m = get_llvm_module(x.codegen)
    mod = LLVM.Module(convert(Ptr{LLVM.API.LLVMOpaqueModule}, m))
end

function lookup_function(mod::Module, func_name::String)
    LLVM.Function(LLVM.API.LLVMGetNamedFunction(mod, func_name))
end
