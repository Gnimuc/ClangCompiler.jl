"""
    struct TargetInfo <: AbstractTargetInfo
Hold a pointer to a `clang::TargetInfo` object.
"""
struct TargetInfo <: AbstractTargetInfo
    ptr::CXTargetInfo_
end

abstract type AbstractConstraintInfo end

"""
    struct ConstraintInfo <: AbstractConstraintInfo
Hold a pointer to a `clang::TargetInfo::ConstraintInfo` object.
"""
struct ConstraintInfo <: AbstractConstraintInfo
    ptr::CXConstraintInfo
end

