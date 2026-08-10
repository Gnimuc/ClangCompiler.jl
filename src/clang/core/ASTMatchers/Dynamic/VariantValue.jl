"""
    abstract type AbstractVariantValue <: Any
Supertype for `VariantValue`s.
"""
abstract type AbstractVariantValue end

"""
    struct VariantValue <: AbstractVariantValue
Hold a pointer to a `clang::ast_matchers::dynamic::VariantValue` object.

The tagged union the matcher grammar's literals and named values evaluate to: nothing, a
`Bool`, a `Float64`, a `UInt32`, a `String`, or a matcher.
"""
struct VariantValue <: AbstractVariantValue
    ptr::CXVariantValue
end

"""
    abstract type AbstractNamedValueMap <: Any
Supertype for `NamedValueMap`s.
"""
abstract type AbstractNamedValueMap end

"""
    struct NamedValueMap <: AbstractNamedValueMap
Hold a pointer to a `clang::ast_matchers::dynamic::Parser::NamedValueMap` object, i.e. an
`llvm::StringMap<VariantValue>`.

The dictionary a matcher expression's bare identifiers resolve against — clang-query's
`let name = matcher`.
"""
struct NamedValueMap <: AbstractNamedValueMap
    ptr::CXNamedValueMap
end
