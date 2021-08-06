"""
    struct DeclContext <: Any
Holds a pointer to a `clang::DeclContext` object.
"""
struct DeclContext
    ptr::CXDeclContext
end
