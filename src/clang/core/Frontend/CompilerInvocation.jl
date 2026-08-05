"""
    struct CompilerInvocation <: AbstractCompilerInvocation
Hold a pointer to a `clang::CompilerInvocation` object.
"""
struct CompilerInvocation <: AbstractCompilerInvocation
    ptr::CXCompilerInvocation
end

Base.unsafe_convert(::Type{CXCompilerInvocation}, x::CompilerInvocation) = x.ptr
Base.cconvert(::Type{CXCompilerInvocation}, x::CompilerInvocation) = x


"""
    abstract type AbstractCowCompilerInvocation <: Any
Supertype for `clang::CowCompilerInvocation`.
"""
abstract type AbstractCowCompilerInvocation end

"""
    struct CowCompilerInvocation <: AbstractCowCompilerInvocation
Hold a pointer to a `clang::CowCompilerInvocation` object.

A copy-on-write sibling of `CompilerInvocation`: both derive from
`clang::CompilerInvocationBase`, but neither derives from the other, so this carrier is
deliberately outside the `AbstractCompilerInvocation` hierarchy and only the
`clang_CowCompilerInvocation_*` wrappers accept it.
"""
struct CowCompilerInvocation <: AbstractCowCompilerInvocation
    ptr::CXCowCompilerInvocation
end

Base.unsafe_convert(::Type{CXCowCompilerInvocation}, x::CowCompilerInvocation) = x.ptr
Base.cconvert(::Type{CXCowCompilerInvocation}, x::CowCompilerInvocation) = x
