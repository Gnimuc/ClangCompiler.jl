"""
    abstract type AbstractAnalyzerOptions <: Any
Supertype for `clang::AnalyzerOptions`.
"""
abstract type AbstractAnalyzerOptions end

"""
    struct AnalyzerOptions <: AbstractAnalyzerOptions
Hold a pointer to a `clang::AnalyzerOptions` object.
"""
struct AnalyzerOptions <: AbstractAnalyzerOptions
    ptr::CXAnalyzerOptions
end
