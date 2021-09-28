"""
    struct TargetInfo <: Any
Hold a pointer to a `clang::TargetInfo` object.
"""
struct TargetInfo
    ptr::CXTargetInfo_
end

Base.unsafe_convert(::Type{CXTargetInfo_}, x::TargetInfo) = x.ptr
Base.cconvert(::Type{CXTargetInfo_}, x::TargetInfo) = x
