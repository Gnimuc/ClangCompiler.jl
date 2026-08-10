"""
    abstract type AbstractSyntaxToken <: Any
Supertype for `SyntaxToken`s.
"""
abstract type AbstractSyntaxToken end

"""
    struct SyntaxToken <: AbstractSyntaxToken
Hold a pointer to a `clang::syntax::Token` object.

A different class from `clang::Token` (which `Token` carries): just enough to place a token
in the source — a location, a length and a kind — and able to stand for either a spelled or
an expanded token. Every `SyntaxToken` this API hands out is *borrowed* from the
`SyntaxTokenList` or `TokenBuffer` it came out of, so none of them is disposed.
"""
struct SyntaxToken <: AbstractSyntaxToken
    ptr::CXSyntaxToken
end

"""
    abstract type AbstractSyntaxTokenList <: Any
Supertype for `SyntaxTokenList`s.
"""
abstract type AbstractSyntaxTokenList end

"""
    struct SyntaxTokenList <: AbstractSyntaxTokenList
Hold a pointer to a shim-owned `std::vector<clang::syntax::Token>`.

Clang has no such class. It exists because every token sequence in `Tokens.h` is either
returned by value or is a view into storage whose lifetime does not cross the C boundary, so
the shim copies the tokens into a container the caller owns: release it with `dispose`.
"""
struct SyntaxTokenList <: AbstractSyntaxTokenList
    ptr::CXSyntaxTokenList
end

"""
    abstract type AbstractTokenBuffer <: Any
Supertype for `TokenBuffer`s.
"""
abstract type AbstractTokenBuffer end

"""
    struct TokenBuffer <: AbstractTokenBuffer
Hold a pointer to a `clang::syntax::TokenBuffer` object.

Both token streams of a translation unit and the mapping between them: the *expanded*
tokens the parser consumed (which AST source locations point at) and the *spelled* tokens
each file was written with. `consume(::TokenCollector)` is the only thing that produces one.
Caller-owned: release it with `dispose`.
"""
struct TokenBuffer <: AbstractTokenBuffer
    ptr::CXTokenBuffer
end

"""
    abstract type AbstractTokenCollector <: Any
Supertype for `TokenCollector`s.
"""
abstract type AbstractTokenCollector end

"""
    struct TokenCollector <: AbstractTokenCollector
Hold a pointer to a `clang::syntax::TokenCollector` object.

It installs its own hooks on the `Preprocessor` when it is created, so it has to exist
before preprocessing starts and must not outlive that preprocessor. Caller-owned: `consume`
it exactly once when the frontend action has finished, then `dispose` it.
"""
struct TokenCollector <: AbstractTokenCollector
    ptr::CXTokenCollector
end
