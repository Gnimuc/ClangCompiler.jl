"""
    abstract type AbstractEditedSource <: Any
Supertype for `EditedSource`s.
"""
abstract type AbstractEditedSource end

"""
    struct EditedSource <: AbstractEditedSource
Hold a pointer to a `clang::edit::EditedSource` object.
"""
struct EditedSource <: AbstractEditedSource
    ptr::CXEditedSource
end
