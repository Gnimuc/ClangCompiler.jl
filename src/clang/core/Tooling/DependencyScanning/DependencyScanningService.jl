"""
    abstract type AbstractDependencyScanningService <: Any
Supertype for `DependencyScanningService`s.
"""
abstract type AbstractDependencyScanningService end

"""
    struct DependencyScanningService <: AbstractDependencyScanningService
Hold a pointer to a `clang::tooling::dependencies::DependencyScanningService` object.

The configuration plus the shared filesystem cache every scanning worker runs against. One
service is meant to be shared by a whole build. Caller-owned: release it with `dispose`, and
only after every `DependencyScanningTool` built from it is gone.
"""
struct DependencyScanningService <: AbstractDependencyScanningService
    ptr::CXDependencyScanningService
end
