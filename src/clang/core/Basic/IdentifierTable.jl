"""
    struct IdentifierTable <: AbstractIdentifierTable
Hold a pointer to a `clang::IdentifierTable` object.
"""
struct IdentifierTable <: AbstractIdentifierTable
    ptr::CXIdentifierTable
end

Base.unsafe_convert(::Type{CXIdentifierTable}, x::IdentifierTable) = x.ptr
Base.cconvert(::Type{CXIdentifierTable}, x::IdentifierTable) = x

"""
    struct IdentifierInfo <: AbstractIdentifierInfo
Hold a pointer to a `clang::IdentifierInfo` object.
"""
struct IdentifierInfo <: AbstractIdentifierInfo
    ptr::CXIdentifierInfo
end

Base.unsafe_convert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x.ptr
Base.cconvert(::Type{CXIdentifierInfo}, x::IdentifierInfo) = x


"""
    struct SelectorTable <: AbstractSelectorTable
Hold a pointer to a `clang::SelectorTable` object.
"""
struct SelectorTable <: AbstractSelectorTable
    ptr::CXSelectorTable
end

Base.unsafe_convert(::Type{CXSelectorTable}, x::SelectorTable) = x.ptr
Base.cconvert(::Type{CXSelectorTable}, x::SelectorTable) = x


"""
    struct Selector <: AbstractSelector
Represent an Objective-C method name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::Selector` object.
Instead, it's the opaque pointer representation of the `clang::Selector` itself, so a NULL
pointer is the null selector rather than an invalid handle.
"""
struct Selector <: AbstractSelector
    ptr::CXSelector
end

Base.unsafe_convert(::Type{CXSelector}, x::Selector) = x.ptr
Base.cconvert(::Type{CXSelector}, x::Selector) = x
