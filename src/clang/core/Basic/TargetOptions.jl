"""
    struct TargetOptions <: AbstractTargetOptions
Hold a pointer to a `clang::TargetOptions` object.
"""
struct TargetOptions <: AbstractTargetOptions
    ptr::CXTargetOptions
end

