"""
    abstract type AbstractDynTypedMatcher <: Any
Supertype for `DynTypedMatcher`s.
"""
abstract type AbstractDynTypedMatcher end

"""
    struct DynTypedMatcher <: AbstractDynTypedMatcher
Hold a pointer to a `clang::ast_matchers::internal::DynTypedMatcher` object.

The type-erased matcher the whole dynamic pipeline speaks in. There is no constructor: the
C++ constructors take a `MatcherInterface<T>` produced by the template DSL, so the only
source of one is [`parseMatcherExpression`](@ref).
"""
struct DynTypedMatcher <: AbstractDynTypedMatcher
    ptr::CXDynTypedMatcher
end
