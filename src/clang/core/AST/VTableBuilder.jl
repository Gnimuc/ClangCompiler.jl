"""
    abstract type AbstractVTableComponent <: Any
Supertype for `clang::VTableComponent`s.
"""
abstract type AbstractVTableComponent end

"""
    struct VTableComponent <: AbstractVTableComponent
Hold a pointer to a `clang::VTableComponent` object.

Borrowed: the component is one element of the array a [`VTableLayout`](@ref) owns, so it
lives exactly as long as that layout and has no `dispose`.
"""
struct VTableComponent <: AbstractVTableComponent
    ptr::CXVTableComponent
end

"""
    abstract type AbstractVTableLayout <: Any
Supertype for `clang::VTableLayout`s.
"""
abstract type AbstractVTableLayout end

"""
    struct VTableLayout <: AbstractVTableLayout
Hold a pointer to a `clang::VTableLayout` object.
"""
struct VTableLayout <: AbstractVTableLayout
    ptr::CXVTableLayout
end

"""
    abstract type AbstractVTableContextBase <: Any
Supertype for `clang::VTableContextBase`s.
"""
abstract type AbstractVTableContextBase end

"""
    struct VTableContextBase <: AbstractVTableContextBase
Hold a pointer to a `clang::VTableContextBase` object.
"""
struct VTableContextBase <: AbstractVTableContextBase
    ptr::CXVTableContextBase
end

"""
    abstract type AbstractItaniumVTableContext <: AbstractVTableContextBase
Supertype for `clang::ItaniumVTableContext`s.
"""
abstract type AbstractItaniumVTableContext <: AbstractVTableContextBase end

"""
    struct ItaniumVTableContext <: AbstractItaniumVTableContext
Hold a pointer to a `clang::ItaniumVTableContext` object.
"""
struct ItaniumVTableContext <: AbstractItaniumVTableContext
    ptr::CXItaniumVTableContext
end
