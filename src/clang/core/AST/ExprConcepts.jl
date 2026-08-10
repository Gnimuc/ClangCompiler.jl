"""
    abstract type AbstractConceptReference <: Any
Supertype for `clang::ConceptReference`s.
"""
abstract type AbstractConceptReference end

"""
    struct ConceptReference <: AbstractConceptReference
Hold a pointer to a `clang::ConceptReference` object.
"""
struct ConceptReference <: AbstractConceptReference
    ptr::CXConceptReference
end

"""
    abstract type AbstractRequirement <: Any
Supertype for `clang::concepts::Requirement`s.
"""
abstract type AbstractRequirement end

"""
    struct Requirement <: AbstractRequirement
Hold a pointer to a `clang::concepts::Requirement` object.
"""
struct Requirement <: AbstractRequirement
    ptr::CXRequirement
end

"""
    abstract type AbstractTypeRequirement <: AbstractRequirement
Supertype for `clang::concepts::TypeRequirement`s.
"""
abstract type AbstractTypeRequirement <: AbstractRequirement end

"""
    struct TypeRequirement <: AbstractTypeRequirement
Hold a pointer to a `clang::concepts::TypeRequirement` object.
"""
struct TypeRequirement <: AbstractTypeRequirement
    ptr::CXTypeRequirement
end

"""
    abstract type AbstractExprRequirement <: AbstractRequirement
Supertype for `clang::concepts::ExprRequirement`s.
"""
abstract type AbstractExprRequirement <: AbstractRequirement end

"""
    struct ExprRequirement <: AbstractExprRequirement
Hold a pointer to a `clang::concepts::ExprRequirement` object.
"""
struct ExprRequirement <: AbstractExprRequirement
    ptr::CXExprRequirement
end

"""
    abstract type AbstractNestedRequirement <: AbstractRequirement
Supertype for `clang::concepts::NestedRequirement`s.
"""
abstract type AbstractNestedRequirement <: AbstractRequirement end

"""
    struct NestedRequirement <: AbstractNestedRequirement
Hold a pointer to a `clang::concepts::NestedRequirement` object.
"""
struct NestedRequirement <: AbstractNestedRequirement
    ptr::CXNestedRequirement
end
