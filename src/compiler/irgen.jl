"""
    abstract type AbstractIRGenerator <: AbstractClangCompiler
Supertype for LLVM IR generators.
"""
abstract type AbstractIRGenerator <: AbstractClangCompiler end

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

take_module(x::IRGenerator) = takeModule(x.act)

function IRGenerator(src::String, args::Vector{String}; diag_show_colors=true)
    ts_ctx = ThreadSafeContext()
    ctx = context(ts_ctx)
    instance = CompilerInstance()
    # diagnostics
    setShowPresumedLoc(instance, true)
    setShowColors(instance, diag_show_colors)
    createDiagnostics(instance)
    diag = getDiagnostics(instance)
    # invocation
    # if Sys.isapple()
    #     # FIXME: Duplicate definition of symbol '___cxa_atexit'
    #     # icxxabi_inc = joinpath(@__DIR__, "..", "..", "abi") |> normpath
    #     # insert!(args, length(args), "-isystem$icxxabi_inc")
    #     # insert!(args, length(args), "-includeicxxabi.h")
    # elseif Sys.islinux()
    #     hack_inc = joinpath(@__DIR__, "..", "..", "hack") |> normpath
    #     insert!(args, length(args), "-isystem$hack_inc")
    #     insert!(args, length(args), "-include"*"hack_linux.h")
    # end
    # invok = create_compiler_invocation_from_cmd(src, args, diag)
    # setInvocation(instance, invok)
    # codegen action
    act = LLVMOnlyAction(ctx)
    ExecuteAction(instance, act)
    return IRGenerator(ts_ctx, instance, act)
end

function dispose(x::IRGenerator)
    dispose(x.instance)
    dispose(x.act)
    dispose(x.ts_ctx)
end
