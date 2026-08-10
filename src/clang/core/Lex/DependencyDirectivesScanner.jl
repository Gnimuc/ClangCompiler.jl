"""
    abstract type AbstractDependencyDirectivesScan <: Any
Supertype for dependency-directive scans.
"""
abstract type AbstractDependencyDirectivesScan end

"""
    struct DependencyDirectivesScan <: AbstractDependencyDirectivesScan
Hold a pointer to the result of one `clang::scanSourceForDependencyDirectives` run.

There is no `clang::` class behind this: the shim boxes the scanned input, the flat token
vector and the directive vector together, because each directive's token range is a view
into that vector.
"""
struct DependencyDirectivesScan <: AbstractDependencyDirectivesScan
    ptr::CXDependencyDirectivesScan
end
