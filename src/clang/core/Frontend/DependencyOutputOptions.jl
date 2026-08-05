"""
    abstract type AbstractDependencyOutputOptions <: Any
Supertype for `clang::DependencyOutputOptions`.
"""
abstract type AbstractDependencyOutputOptions end

"""
    struct DependencyOutputOptions <: AbstractDependencyOutputOptions
Hold a pointer to a `clang::DependencyOutputOptions` object.
"""
struct DependencyOutputOptions <: AbstractDependencyOutputOptions
    ptr::CXDependencyOutputOptions
end

Base.unsafe_convert(::Type{CXDependencyOutputOptions}, x::DependencyOutputOptions) = x.ptr
Base.cconvert(::Type{CXDependencyOutputOptions}, x::DependencyOutputOptions) = x
