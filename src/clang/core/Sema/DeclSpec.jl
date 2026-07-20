"""
    struct CXXScopeSpec <: AbstractCXXScopeSpec
Hold a pointer to a `clang::CXXScopeSpec` object.
"""
struct CXXScopeSpec <: AbstractCXXScopeSpec
    ptr::CXCXXScopeSpec
end

Base.unsafe_convert(::Type{CXCXXScopeSpec}, x::CXXScopeSpec) = x.ptr
Base.cconvert(::Type{CXCXXScopeSpec}, x::CXXScopeSpec) = x
