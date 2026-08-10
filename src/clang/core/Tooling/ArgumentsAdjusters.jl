"""
    abstract type AbstractArgumentsAdjuster <: Any
Supertype for `ArgumentsAdjuster`s.
"""
abstract type AbstractArgumentsAdjuster end

"""
    struct ArgumentsAdjuster <: AbstractArgumentsAdjuster
Hold a pointer to a `clang::tooling::ArgumentsAdjuster` object.

`clang::tooling::ArgumentsAdjuster` is a `std::function` typedef rather than a class, so the
handle points at a heap-boxed copy of the closure itself.
"""
struct ArgumentsAdjuster <: AbstractArgumentsAdjuster
    ptr::CXArgumentsAdjuster
end
