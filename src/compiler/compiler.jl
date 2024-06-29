"""
    abstract type AbstractClangCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractClangCompiler end

include("irgen.jl")

"""
    struct CXCompiler <: AbstractClangCompiler
[`IRGenerator`](@ref) + [`LLJIT`](@ref).
"""
struct CXCompiler <: AbstractClangCompiler
    irgen::IRGenerator
    jit::LLJIT
end

get_instance(x::CXCompiler) = get_instance(x.irgen)
get_context(x::CXCompiler) = get_context(x.irgen)
take_module(x::CXCompiler) = take_module(x.irgen)

get_jit(x::CXCompiler) = x.jit
get_codegen(x::CXCompiler) = x.irgen
get_dylib(x::CXCompiler) = JITDylib(x.jit)

function link_process_symbols(cc::CXCompiler)
    jd = get_dylib(cc)
    jit = get_jit(cc)
    prefix = LLVM.get_prefix(jit)
    dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(prefix)
    add!(jd, dg)
end

function compile(cc::CXCompiler)
    ts_mod = ThreadSafeModule(take_module(cc); ctx=get_context(cc))
    jd = get_dylib(cc)
    jit = get_jit(cc)
    add!(jit, jd, ts_mod)
end

function dispose(x::CXCompiler)
    dispose(x.irgen)
    dispose(x.jit)
end
