"""
    struct DependencyCollector <: AbstractDependencyCollector
Hold a pointer to a `clang::DependencyCollector` object.

Records every file a translation unit reads once attached to a preprocessor — the
header-dependency list a caller needs to know when a cached translation unit has gone stale.
"""
struct DependencyCollector <: AbstractDependencyCollector
    ptr::CXDependencyCollector
end

"""
    struct DependencyFileGenerator <: AbstractDependencyFileGenerator
Hold a pointer to a `clang::DependencyFileGenerator` object.

The same collector, writing a make-style `.d` file when the main file finishes instead of
only holding the list in memory.
"""
struct DependencyFileGenerator <: AbstractDependencyFileGenerator
    ptr::CXDependencyCollector
end
