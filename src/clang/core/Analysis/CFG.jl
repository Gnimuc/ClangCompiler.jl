# Local abstract types: the Analysis hierarchy is not part of core/abstract.jl
# (CFG and CFGBlock are standalone classes with no Clang inheritance).
abstract type AbstractCFG end
abstract type AbstractCFGBlock end

"""
    struct CFG <: AbstractCFG
Hold a pointer to a `clang::CFG` object.

The pointee is caller-owned (`buildCFG` heap-allocates it) — call `dispose`
after use. Every `CFGBlock` of this graph is interior to the `CFG` and is
invalidated by the dispose.
"""
struct CFG <: AbstractCFG
    ptr::CXCFG
end

Base.unsafe_convert(::Type{CXCFG}, x::CFG) = x.ptr
Base.cconvert(::Type{CXCFG}, x::CFG) = x

"""
    struct CFGBlock <: AbstractCFGBlock
Hold a pointer to a `clang::CFGBlock` object.

The pointee is owned by its parent `CFG` — there is no `dispose`.
"""
struct CFGBlock <: AbstractCFGBlock
    ptr::CXCFGBlock
end

Base.unsafe_convert(::Type{CXCFGBlock}, x::CFGBlock) = x.ptr
Base.cconvert(::Type{CXCFGBlock}, x::CFGBlock) = x
