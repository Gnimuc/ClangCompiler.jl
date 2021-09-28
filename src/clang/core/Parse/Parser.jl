"""
    struct Parser <: Any
Hold a pointer to a `clang::Parser` object.
"""
struct Parser
    ptr::CXParser
end

Base.unsafe_convert(::Type{CXParser}, x::Parser) = x.ptr
Base.cconvert(::Type{CXParser}, x::Parser) = x
