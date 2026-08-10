"""
    abstract type AbstractDynTypedNode <: Any
Supertype for `clang::DynTypedNode`s.
"""
abstract type AbstractDynTypedNode end

"""
    struct DynTypedNode <: AbstractDynTypedNode
Hold a pointer to a heap-boxed `clang::DynTypedNode` object.

`clang::DynTypedNode` is a small copyable value whose by-value node kinds live inside its own
storage, so it crosses the boundary as an owned heap copy: every `DynTypedNode` is caller-owned
and must be released with `dispose`.
"""
struct DynTypedNode <: AbstractDynTypedNode
    ptr::CXDynTypedNode
end
