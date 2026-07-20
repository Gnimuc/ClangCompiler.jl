"""
    struct DeclarationName <: AbstractDeclarationName
Represent a declaration name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::DeclarationName` object.
Instead, it's the opaque pointer representation of the `clang::DeclarationName` itself.
"""
struct DeclarationName <: AbstractDeclarationName
    ptr::CXDeclarationName
end

Base.unsafe_convert(::Type{CXDeclarationName}, x::DeclarationName) = x.ptr
Base.cconvert(::Type{CXDeclarationName}, x::DeclarationName) = x

"""
    struct DeclarationNameInfo <: AbstractDeclarationNameInfo
Hold a pointer to a `clang::DeclarationNameInfo` object.

Note that the underlying pointer IS a heap-boxed `clang::DeclarationNameInfo`
(the value type has no opaque pointer form). One should call `dispose` to release
the resources after using this object.
"""
struct DeclarationNameInfo <: AbstractDeclarationNameInfo
    ptr::CXDeclarationNameInfo
end

Base.unsafe_convert(::Type{CXDeclarationNameInfo}, x::DeclarationNameInfo) = x.ptr
Base.cconvert(::Type{CXDeclarationNameInfo}, x::DeclarationNameInfo) = x
