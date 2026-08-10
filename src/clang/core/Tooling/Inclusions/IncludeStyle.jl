"""
    abstract type AbstractIncludeStyle <: Any
Supertype for `IncludeStyle`s.
"""
abstract type AbstractIncludeStyle end

"""
    struct IncludeStyle <: AbstractIncludeStyle
Hold a pointer to a `clang::tooling::IncludeStyle` object.

The settings struct that decides how `#include` directives are grouped and ordered. It is a
value, heap-boxed and caller-owned: release it with `dispose`. Everything that consumes one
copies it, so it may be disposed as soon as the consumer exists.
"""
struct IncludeStyle <: AbstractIncludeStyle
    ptr::CXIncludeStyle
end
