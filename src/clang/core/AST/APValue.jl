"""
    struct APValue <: AbstractAPValue
Hold a pointer to a `clang::APValue` object.
"""
struct APValue <: AbstractAPValue
    ptr::CXAPValue
end
