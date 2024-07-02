"""
    abstract type AbstractClangCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractClangCompiler end

# """
#     struct CxxCompiler <: AbstractClangCompiler
# [`IRGenerator`](@ref) + [`LLJIT`](@ref).
# """
# struct CxxCompiler <: AbstractClangCompiler
#     irgen::IRGenerator
#     jit::LLJIT
# end

# get_instance(x::CxxCompiler) = get_instance(x.irgen)
# get_context(x::CxxCompiler) = get_context(x.irgen)
# take_module(x::CxxCompiler) = take_module(x.irgen)

# get_jit(x::CxxCompiler) = x.jit
# get_codegen(x::CxxCompiler) = x.irgen
# get_dylib(x::CxxCompiler) = JITDylib(x.jit)

# function link_process_symbols(cc::CxxCompiler)
#     jd = get_dylib(cc)
#     jit = get_jit(cc)
#     prefix = LLVM.get_prefix(jit)
#     dg = LLVM.CreateDynamicLibrarySearchGeneratorForProcess(prefix)
#     add!(jd, dg)
# end

# function compile(cc::CxxCompiler)
#     ts_mod = ThreadSafeModule(take_module(cc); ctx=get_context(cc))
#     jd = get_dylib(cc)
#     jit = get_jit(cc)
#     add!(jit, jd, ts_mod)
# end

# function dispose(x::CxxCompiler)
#     dispose(x.irgen)
#     dispose(x.jit)
# end
