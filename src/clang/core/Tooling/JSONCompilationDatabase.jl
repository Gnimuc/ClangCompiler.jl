"""
    abstract type AbstractJSONCompilationDatabase <: AbstractCompilationDatabase
Supertype for `JSONCompilationDatabase`s.
"""
abstract type AbstractJSONCompilationDatabase <: AbstractCompilationDatabase end

"""
    struct JSONCompilationDatabase <: AbstractJSONCompilationDatabase
Hold a pointer to a `clang::tooling::JSONCompilationDatabase` object.
"""
struct JSONCompilationDatabase <: AbstractJSONCompilationDatabase
    ptr::CXJSONCompilationDatabase
end
