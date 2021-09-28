"""
    struct CXXScopeSpec <: Any
Hold a pointer to a `clang::CXXScopeSpec` object.
"""
struct CXXScopeSpec
    ptr::CXCXXScopeSpec
end

Base.unsafe_convert(::Type{CXCXXScopeSpec}, x::CXXScopeSpec) = x.ptr
Base.cconvert(::Type{CXCXXScopeSpec}, x::CXXScopeSpec) = x
