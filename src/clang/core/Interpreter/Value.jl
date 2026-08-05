"""
    struct Value <: AbstractValue
A Clang value.
"""
struct Value <: AbstractValue
    ptr::CXValue
end

