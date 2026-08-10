"""
    abstract type AbstractIncludeCategoryManager <: Any
Supertype for `IncludeCategoryManager`s.
"""
abstract type AbstractIncludeCategoryManager end

"""
    struct IncludeCategoryManager <: AbstractIncludeCategoryManager
Hold a pointer to a `clang::tooling::IncludeCategoryManager` object.

Answers which category — and so which priority — an include name falls in, for one file
name and one style. Caller-owned: release it with `dispose`.
"""
struct IncludeCategoryManager <: AbstractIncludeCategoryManager
    ptr::CXIncludeCategoryManager
end

"""
    abstract type AbstractHeaderIncludes <: Any
Supertype for `HeaderIncludes`.
"""
abstract type AbstractHeaderIncludes end

"""
    struct HeaderIncludes <: AbstractHeaderIncludes
Hold a pointer to a `clang::tooling::HeaderIncludes` object.

Built once over a buffer, it records where each existing `#include`/`#import` lives and then
computes the `Replacement`s that add or delete one. Caller-owned: release it with `dispose`.
"""
struct HeaderIncludes <: AbstractHeaderIncludes
    ptr::CXHeaderIncludes
end
