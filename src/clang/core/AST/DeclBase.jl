"""
    struct Decl <: AbstractDecl
Hold a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

"""
    struct DeclContext <: AbstractDeclContext
Hold a pointer to a `clang::DeclContext` object.
"""
struct DeclContext <: AbstractDeclContext
    ptr::CXDeclContext
end
