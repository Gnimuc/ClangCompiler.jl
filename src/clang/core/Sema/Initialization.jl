"""
    abstract type AbstractInitializedEntity <: Any
Supertype for `clang::InitializedEntity`s.
"""
abstract type AbstractInitializedEntity end

"""
    struct InitializedEntity <: AbstractInitializedEntity
Hold a pointer to a `clang::InitializedEntity` object.
"""
struct InitializedEntity <: AbstractInitializedEntity
    ptr::CXInitializedEntity
end

"""
    abstract type AbstractInitializationKind <: Any
Supertype for `clang::InitializationKind`s.
"""
abstract type AbstractInitializationKind end

"""
    struct InitializationKind <: AbstractInitializationKind
Hold a pointer to a `clang::InitializationKind` object.
"""
struct InitializationKind <: AbstractInitializationKind
    ptr::CXInitializationKind
end

"""
    abstract type AbstractInitializationSequence <: Any
Supertype for `clang::InitializationSequence`s.
"""
abstract type AbstractInitializationSequence end

"""
    struct InitializationSequence <: AbstractInitializationSequence
Hold a pointer to a `clang::InitializationSequence` object.
"""
struct InitializationSequence <: AbstractInitializationSequence
    ptr::CXInitializationSequence
end
