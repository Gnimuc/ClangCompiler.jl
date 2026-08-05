"""
    struct ToolChain <: AbstractToolChain
Hold a pointer to a `clang::driver::ToolChain` object.
"""
struct ToolChain <: AbstractToolChain
    ptr::CXToolChain
end

Base.unsafe_convert(::Type{CXToolChain}, x::ToolChain) = x.ptr
Base.cconvert(::Type{CXToolChain}, x::ToolChain) = x
