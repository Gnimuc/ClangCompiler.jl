"""
    struct ToolChain <: AbstractToolChain
Hold a pointer to a `clang::driver::ToolChain` object.
"""
struct ToolChain <: AbstractToolChain
    ptr::CXToolChain
end

