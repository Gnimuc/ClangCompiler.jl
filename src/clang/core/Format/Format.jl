"""
    abstract type AbstractFormatStyle <: Any
Supertype for `FormatStyle`s.
"""
abstract type AbstractFormatStyle end

"""
    struct FormatStyle <: AbstractFormatStyle
Hold a pointer to a `clang::format::FormatStyle` object.

`clang::format::FormatStyle` is a plain value struct upstream; this carrier points at a
heap copy owned by the caller, so every function that hands one back allocates and the
result must be released with `dispose`.
"""
struct FormatStyle <: AbstractFormatStyle
    ptr::CXFormatStyle
end
