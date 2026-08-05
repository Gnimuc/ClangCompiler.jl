"""
    struct Driver <: AbstractDriver
Hold a pointer to a `clang::driver::Driver` object.
"""
struct Driver <: AbstractDriver
    ptr::CXDriver
end
