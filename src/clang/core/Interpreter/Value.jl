"""
    abstract type AbstractValue <: Any
Supertype for `clang::Value`s.
"""
abstract type AbstractValue end

"""
    struct Value <: AbstractValue
A Clang value.
"""
struct Value <: AbstractValue
    ptr::CXValue
end

Base.unsafe_convert(::Type{CXValue}, x::Value) = x.ptr
Base.cconvert(::Type{CXValue}, x::Value) = x
