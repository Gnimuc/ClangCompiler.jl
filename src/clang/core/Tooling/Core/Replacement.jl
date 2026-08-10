"""
    abstract type AbstractReplacement <: Any
Supertype for `Replacement`s.
"""
abstract type AbstractReplacement end

"""
    struct Replacement <: AbstractReplacement
Hold a pointer to a `clang::tooling::Replacement` object.

A `clang::tooling::Replacement` is a value, so the object behind this handle is a heap-boxed
copy owned by the caller: release it with `dispose`.
"""
struct Replacement <: AbstractReplacement
    ptr::CXReplacement
end

"""
    abstract type AbstractReplacements <: Any
Supertype for `Replacements`.
"""
abstract type AbstractReplacements end

"""
    struct Replacements <: AbstractReplacements
Hold a pointer to a `clang::tooling::Replacements` object.

The set is a value too, and likewise heap-boxed and caller-owned: release it with `dispose`.
"""
struct Replacements <: AbstractReplacements
    ptr::CXReplacements
end
