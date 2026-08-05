"""
    struct IdentifierTable <: AbstractIdentifierTable
Hold a pointer to a `clang::IdentifierTable` object.
"""
struct IdentifierTable <: AbstractIdentifierTable
    ptr::CXIdentifierTable
end

"""
    struct IdentifierInfo <: AbstractIdentifierInfo
Hold a pointer to a `clang::IdentifierInfo` object.
"""
struct IdentifierInfo <: AbstractIdentifierInfo
    ptr::CXIdentifierInfo
end

"""
    struct SelectorTable <: AbstractSelectorTable
Hold a pointer to a `clang::SelectorTable` object.
"""
struct SelectorTable <: AbstractSelectorTable
    ptr::CXSelectorTable
end

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
