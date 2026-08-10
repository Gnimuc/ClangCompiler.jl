"""
    abstract type AbstractNumericLiteralParser <: Any
Supertype for `clang::NumericLiteralParser`s.
"""
abstract type AbstractNumericLiteralParser end

"""
    struct NumericLiteralParser <: AbstractNumericLiteralParser
Hold a pointer to a `clang::NumericLiteralParser` object.

The parser keeps markers into the spelling it was built from, so the shim boxes the
spelling next to it: the pointer is to that box, and one call to `dispose` releases both.
"""
struct NumericLiteralParser <: AbstractNumericLiteralParser
    ptr::CXNumericLiteralParser
end

"""
    abstract type AbstractCharLiteralParser <: Any
Supertype for `clang::CharLiteralParser`s.
"""
abstract type AbstractCharLiteralParser end

"""
    struct CharLiteralParser <: AbstractCharLiteralParser
Hold a pointer to a `clang::CharLiteralParser` object.
"""
struct CharLiteralParser <: AbstractCharLiteralParser
    ptr::CXCharLiteralParser
end

"""
    abstract type AbstractStringLiteralParser <: Any
Supertype for `clang::StringLiteralParser`s.
"""
abstract type AbstractStringLiteralParser end

"""
    struct StringLiteralParser <: AbstractStringLiteralParser
Hold a pointer to a `clang::StringLiteralParser` object.
"""
struct StringLiteralParser <: AbstractStringLiteralParser
    ptr::CXStringLiteralParser
end
