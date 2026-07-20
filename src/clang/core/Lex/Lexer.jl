"""
    struct Lexer <: AbstractLexer
Hold a pointer to a `clang::Lexer` object.
"""
struct Lexer <: AbstractLexer
    ptr::CXLexer
end

Base.unsafe_convert(::Type{CXLexer}, x::Lexer) = x.ptr
Base.cconvert(::Type{CXLexer}, x::Lexer) = x
