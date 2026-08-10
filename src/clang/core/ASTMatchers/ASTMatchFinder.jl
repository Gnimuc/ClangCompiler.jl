"""
    abstract type AbstractMatchFinder <: Any
Supertype for `MatchFinder`s.
"""
abstract type AbstractMatchFinder end

"""
    struct MatchFinder <: AbstractMatchFinder
Hold a pointer to a `clang::ast_matchers::MatchFinder` object paired with the shim's
result-collecting `MatchCallback`.

The callback is the reason the handle is not a bare `MatchFinder`: upstream reports matches
by calling a virtual, and the shim allocates the finder together with one fixed subclass that
pushes every match onto a list this package then reads by index.
"""
struct MatchFinder <: AbstractMatchFinder
    ptr::CXMatchFinder
end
