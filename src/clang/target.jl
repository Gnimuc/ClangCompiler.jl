"""
    mutable struct TargetOptions <: Any
Holds a pointer to a `clang::TargetOptions` object.
"""
mutable struct TargetOptions
    ptr::CXTargetOptions
end

"""
    mutable struct TargetInfo <: Any
Holds a pointer to a `clang::TargetInfo` object.
"""
mutable struct TargetInfo
    ptr::CXTargetInfo
end
