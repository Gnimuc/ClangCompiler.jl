# A simple compiler implementation
using ClangCompiler

const CC = ClangCompiler

struct SimpleCompiler
    ctx::CC.Context
    instance::CC.CompilerInstance
end

function create_simple_compiler(src::String, args::Vector{String}; diag_show_colors=true)
    ctx = CC.Context()
    instance = CC.CompilerInstance()
    # diagnostics
    CC.set_opt_show_presumed_loc(instance, true)
    CC.set_opt_show_colors(instance, diag_show_colors)
    CC.create_diagnostics(instance)
    diag = CC.get_diagnostics(instance)
    # invocation
    # do not emit `__dso_handle` etc.
    insert!(args, length(args), "-fno-use-cxa-atexit")
    invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
    CC.set_invocation(instance, invok)
    CC.set_target(instance)
    # source
    CC.create_file_manager(instance)
    CC.create_source_manager(instance)
    CC.set_main_file(instance, src)
    # preprocessor & AST & sema
    CC.create_preprocessor(instance)
    CC.create_ast_context(instance)
    CC.set_ast_consumer(instance, CC.create_llvm_codegen(instance, ctx))
    CC.create_sema(instance)
    return SimpleCompiler(ctx, instance)
end

function dispose(x::SimpleCompiler)
    CC.dispose(x.instance)
    CC.dispose(x.ctx)
end

function compile(x::SimpleCompiler)
    CC.parse(x.instance) || error("failed to parse the source code.")
    m = CC.get_llvm_module(x.instance)
    m.ref == C_NULL && error("failed to generate IR.")
    return m
end

# run
src = joinpath(@__DIR__, "..", "sample.cpp")
args = get_compiler_args()
cc = create_simple_compiler(src, args)
m = compile(cc)
dispose(cc)
