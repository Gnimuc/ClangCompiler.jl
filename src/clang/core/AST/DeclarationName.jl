"""
    struct DeclarationName <: Any
Represent a declaration name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::DeclarationName` object.
Instead, it's the opaque pointer representation of the `clang::DeclarationName` itself.
"""
struct DeclarationName
    ptr::CXDeclarationName
end

Base.unsafe_convert(::Type{CXDeclarationName}, x::DeclarationName) = x.ptr
Base.cconvert(::Type{CXDeclarationName}, x::DeclarationName) = x
