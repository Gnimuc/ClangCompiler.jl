abstract type AbstractPPCallbacks end

"""
    struct PPCallbacks <: AbstractPPCallbacks
Hold a pointer to a `clang::PPCallbacks` object.
"""
struct PPCallbacks <: AbstractPPCallbacks
    ptr::CXPPCallbacks
end

Base.unsafe_convert(::Type{CXPPCallbacks}, x::PPCallbacks) = x.ptr
Base.cconvert(::Type{CXPPCallbacks}, x::PPCallbacks) = x
