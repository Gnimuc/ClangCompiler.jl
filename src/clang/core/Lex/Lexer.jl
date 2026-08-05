"""
    struct Lexer <: AbstractLexer
Hold a pointer to a `clang::Lexer` object.
"""
struct Lexer <: AbstractLexer
    ptr::CXLexer
end

