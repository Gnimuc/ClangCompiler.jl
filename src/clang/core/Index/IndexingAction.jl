"""
    abstract type AbstractIndexDataCollector <: Any
Supertype for the C shim's concrete `clang::index::IndexDataConsumer` subclass.
"""
abstract type AbstractIndexDataCollector end

"""
    struct IndexDataCollector <: AbstractIndexDataCollector
Hold a pointer to the C shim's one concrete `clang::index::IndexDataConsumer` subclass.

`IndexDataConsumer` is an abstract class with five virtuals and there is no way to route a
virtual call back into Julia, so the shim compiles in a single subclass that appends every
occurrence a walk reports to a buffer. The buffer is then read by index, which is what
[`getNumOccurrences`](@ref) and its companions do.
"""
struct IndexDataCollector <: AbstractIndexDataCollector
    ptr::CXIndexDataCollector
end
