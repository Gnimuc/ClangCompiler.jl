using ..ClangCompiler: libclangex
using ..ClangCompiler: CXString, CXStringSet
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef, LLVMGenericValueRef
using LLVM.API: LLVMTypeRef, LLVMOrcLLJITRef
using LLVM.API: LLVMOrcExecutorAddress

"""
    abstract type AbstractCXImpl end

Supertype of every `CX<Class>Impl` phantom, the type behind a `CX<Class>` handle.

It exists so one method can speak about *any* two handles of this package at once. `Ptr` is
Base's and `convert` between two `Ptr`s bitcasts, so without a common supertype there is no
way to say "these two handles name different classes" -- and that conversion is the one the
whole layer has to refuse. A `Union` over the 1,050 phantoms says the same thing, but
`T <: Union{...}` is a linear scan run during method lookup: measured at ~1,100x the cost of
a supertype check, and 9x the load time.

The post-pass in gen/generator.jl attaches this to every phantom it emits.
"""
abstract type AbstractCXImpl end
# the generator's auto-export covers only the `CX`/`clang` prefixes, so say this one outright
export AbstractCXImpl

const time_t = Clong
