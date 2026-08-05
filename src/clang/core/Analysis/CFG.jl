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

"""
    struct CFGBlock <: AbstractCFGBlock
Hold a pointer to a `clang::CFGBlock` object.

The pointee is owned by its parent `CFG` — there is no `dispose`.
"""
struct CFGBlock <: AbstractCFGBlock
    ptr::CXCFGBlock
end

abstract type AbstractCFGBuildOptions end

"""
    struct CFGBuildOptions <: AbstractCFGBuildOptions
Hold a pointer to a `clang::CFG::BuildOptions` object.

The pointee is caller-owned (`CFGBuildOptions()` heap-allocates it) — call `dispose` after
use. It carries only the stateful part of the C++ class, the per-`Stmt`-class `alwaysAdd`
mask; the option booleans stay flattened into `buildCFG` / `buildCFGWithOptions`. It has to
outlive nothing but the `buildCFGWithOptions` call that reads it — the resulting `CFG` keeps
no reference to it.
"""
struct CFGBuildOptions <: AbstractCFGBuildOptions
    ptr::CXCFGBuildOptions
end

