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
    CC.setShowPresumedLoc(instance, true)
    CC.setShowColors(instance, diag_show_colors)
    CC.createDiagnostics(instance)
    diag = CC.getDiagnostics(instance)
    # invocation
    # do not emit `__dso_handle` etc.
    insert!(args, length(args), "-fno-use-cxa-atexit")
    invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
    CC.setInvocation(instance, invok)
    CC.setTargetAndLangOpts(instance)
    # source
    CC.createFileManager(instance)
    CC.createSourceManager(instance)
    CC.setMainFileID(instance, src)
    # preprocessor & AST & sema
    CC.createPreprocessor(instance)
    CC.createASTContext(instance)
    CC.setASTConsumer(instance, CC.CreateLLVMCodeGen(instance, ctx))
    CC.createSema(instance)
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
