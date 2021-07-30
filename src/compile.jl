"""
    abstract type AbstractCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractCompiler end

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
