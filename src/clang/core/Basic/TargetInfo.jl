"""
    struct TargetInfo <: AbstractTargetInfo
Hold a pointer to a `clang::TargetInfo` object.
"""
struct TargetInfo <: AbstractTargetInfo
    ptr::CXTargetInfo_
end

Base.unsafe_convert(::Type{CXTargetInfo_}, x::TargetInfo) = x.ptr
Base.cconvert(::Type{CXTargetInfo_}, x::TargetInfo) = x


abstract type AbstractConstraintInfo end

"""
    struct ConstraintInfo <: AbstractConstraintInfo
Hold a pointer to a `clang::TargetInfo::ConstraintInfo` object.
"""
struct ConstraintInfo <: AbstractConstraintInfo
    ptr::CXConstraintInfo
end

Base.unsafe_convert(::Type{CXConstraintInfo}, x::ConstraintInfo) = x.ptr
Base.cconvert(::Type{CXConstraintInfo}, x::ConstraintInfo) = x
