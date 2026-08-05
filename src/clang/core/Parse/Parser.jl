"""
    struct Parser <: AbstractParser
Hold a pointer to a `clang::Parser` object.
"""
struct Parser <: AbstractParser
    ptr::CXParser
end

