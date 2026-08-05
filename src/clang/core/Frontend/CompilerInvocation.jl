"""
    struct CompilerInvocation <: AbstractCompilerInvocation
Hold a pointer to a `clang::CompilerInvocation` object.
"""
struct CompilerInvocation <: AbstractCompilerInvocation
    ptr::CXCompilerInvocation
end

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

