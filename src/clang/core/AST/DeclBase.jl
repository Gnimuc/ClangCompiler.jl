"""
    struct Decl <: AbstractDecl
Hold a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

Base.unsafe_convert(::Type{CXDecl}, x::Decl) = x.ptr
Base.cconvert(::Type{CXDecl}, x::Decl) = x

"""
    struct DeclContext <: Any
Hold a pointer to a `clang::DeclContext` object.
"""
struct DeclContext
    ptr::CXDeclContext
end

Base.unsafe_convert(::Type{CXDeclContext}, x::DeclContext) = x.ptr
Base.cconvert(::Type{CXDeclContext}, x::DeclContext) = x
