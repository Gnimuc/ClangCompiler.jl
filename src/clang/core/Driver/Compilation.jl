"""
    struct Compilation <: AbstractCompilation
Hold a pointer to a `clang::driver::Compilation` object.
"""
struct Compilation <: AbstractCompilation
    ptr::CXCompilation
end

