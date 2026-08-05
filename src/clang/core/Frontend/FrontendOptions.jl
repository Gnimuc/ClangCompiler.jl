"""
    struct FrontendOptions <: AbstractFrontendOptions
Hold a pointer to a `clang::FrontendOptions` object.
"""
struct FrontendOptions <: AbstractFrontendOptions
    ptr::CXFrontendOptions
end
