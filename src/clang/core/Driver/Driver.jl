"""
    struct Driver <: AbstractDriver
Hold a pointer to a `clang::driver::Driver` object.
"""
struct Driver <: AbstractDriver
    ptr::CXDriver
end

Base.unsafe_convert(::Type{CXDriver}, x::Driver) = x.ptr
Base.cconvert(::Type{CXDriver}, x::Driver) = x
