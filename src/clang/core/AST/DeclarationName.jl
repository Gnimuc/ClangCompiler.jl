"""
    struct DeclarationName <: AbstractDeclarationName
Represent a declaration name.

Note that, the underlying pointer is NOT a *pointer* to a `clang::DeclarationName` object.
Instead, it's the opaque pointer representation of the `clang::DeclarationName` itself.
"""
struct DeclarationName <: AbstractDeclarationName
    ptr::CXDeclarationName
end

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

# DeclarationNameTable
"""
    abstract type AbstractDeclarationNameTable <: Any
Supertype for `DeclarationNameTable`s.
"""
abstract type AbstractDeclarationNameTable end

"""
    struct DeclarationNameTable <: AbstractDeclarationNameTable
Hold a pointer to a `clang::DeclarationNameTable` object.

The table is the `DeclarationNames` member of an `ASTContext`, so it is borrowed:
it is neither created nor disposed here, and it lives as long as its context.
"""
struct DeclarationNameTable <: AbstractDeclarationNameTable
    ptr::CXDeclarationNameTable
end

