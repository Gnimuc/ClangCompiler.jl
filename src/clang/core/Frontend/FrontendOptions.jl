"""
    struct FrontendOptions <: AbstractFrontendOptions
Hold a pointer to a `clang::FrontendOptions` object.
"""
struct FrontendOptions <: AbstractFrontendOptions
    ptr::CXFrontendOptions
end

Base.unsafe_convert(::Type{CXFrontendOptions}, x::FrontendOptions) = x.ptr
Base.cconvert(::Type{CXFrontendOptions}, x::FrontendOptions) = x
