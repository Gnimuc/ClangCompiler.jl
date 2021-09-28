"""
    struct DeclContext <: Any
Hold a pointer to a `clang::DeclContext` object.
"""
struct DeclContext
    ptr::CXDeclContext
end

Base.unsafe_convert(::Type{CXDeclContext}, x::DeclContext) = x.ptr
Base.cconvert(::Type{CXDeclContext}, x::DeclContext) = x
