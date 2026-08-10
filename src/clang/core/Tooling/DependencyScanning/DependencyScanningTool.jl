"""
    abstract type AbstractDependencyScanningTool <: Any
Supertype for `DependencyScanningTool`s.
"""
abstract type AbstractDependencyScanningTool end

"""
    struct DependencyScanningTool <: AbstractDependencyScanningTool
Hold a pointer to a `clang::tooling::dependencies::DependencyScanningTool` object.

One scanning worker over a `DependencyScanningService`. It holds a reference to the
service's shared cache, so dispose the tool *before* the service.
"""
struct DependencyScanningTool <: AbstractDependencyScanningTool
    ptr::CXDependencyScanningTool
end
