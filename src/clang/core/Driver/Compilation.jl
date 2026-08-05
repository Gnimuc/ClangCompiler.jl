"""
    struct Compilation <: AbstractCompilation
Hold a pointer to a `clang::driver::Compilation` object.
"""
struct Compilation <: AbstractCompilation
    ptr::CXCompilation
end

Base.unsafe_convert(::Type{CXCompilation}, x::Compilation) = x.ptr
Base.cconvert(::Type{CXCompilation}, x::Compilation) = x
