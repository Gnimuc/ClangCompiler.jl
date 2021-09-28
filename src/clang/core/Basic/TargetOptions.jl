"""
    struct TargetOptions <: Any
Hold a pointer to a `clang::TargetOptions` object.
"""
struct TargetOptions
    ptr::CXTargetOptions
end

Base.unsafe_convert(::Type{CXTargetOptions}, x::TargetOptions) = x.ptr
Base.cconvert(::Type{CXTargetOptions}, x::TargetOptions) = x
