"""
    abstract type AbstractTokenConcatenation <: Any
Supertype for `clang::TokenConcatenation`s.
"""
abstract type AbstractTokenConcatenation end

"""
    struct TokenConcatenation <: AbstractTokenConcatenation
Hold a pointer to a `clang::TokenConcatenation` object.
"""
struct TokenConcatenation <: AbstractTokenConcatenation
    ptr::CXTokenConcatenation
end
