"""
    abstract type AbstractStructuralEquivalenceContext <: Any
Supertype for `clang::StructuralEquivalenceContext`s.
"""
abstract type AbstractStructuralEquivalenceContext end

"""
    struct StructuralEquivalenceContext <: AbstractStructuralEquivalenceContext
Hold a pointer to a `clang::StructuralEquivalenceContext` object.
"""
struct StructuralEquivalenceContext <: AbstractStructuralEquivalenceContext
    ptr::CXStructuralEquivalenceContext
end
