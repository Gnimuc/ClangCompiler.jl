"""
    abstract type AbstractAPINotesOptions <: Any
Supertype for `clang::APINotesOptions`.
"""
abstract type AbstractAPINotesOptions end

"""
    struct APINotesOptions <: AbstractAPINotesOptions
Hold a pointer to a `clang::APINotesOptions` object.
"""
struct APINotesOptions <: AbstractAPINotesOptions
    ptr::CXAPINotesOptions
end
