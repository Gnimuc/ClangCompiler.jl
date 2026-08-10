# Local abstract types: the two dominator trees are the aliases
# clang/Analysis/Analyses/Dominators.h gives `clang::CFGDominatorTreeImpl<false>` and
# `<true>`, and `clang::ControlDependencyCalculator` is a standalone class beside them.
# All three derive from `clang::ManagedAnalysis`, which has no other wrapped subclass and
# no accessor of its own, so they are not part of core/abstract.jl.
abstract type AbstractCFGDomTree end
abstract type AbstractCFGPostDomTree end
abstract type AbstractControlDependencyCalculator end

"""
    struct CFGDomTree <: AbstractCFGDomTree
Hold a pointer to a `clang::CFGDomTree` (`clang::CFGDominatorTreeImpl<false>`) object.

The pointee is caller-owned (`CFGDomTree(::CFG)` heap-allocates it) — call `dispose` after
use. It holds a bare pointer to the `CFG` it was built from and keys its nodes on that
graph's `CFGBlock`s, so it must not outlive the graph: `dispose(::CFG)` invalidates it.
"""
struct CFGDomTree <: AbstractCFGDomTree
    ptr::CXCFGDomTree
end

"""
    struct CFGPostDomTree <: AbstractCFGPostDomTree
Hold a pointer to a `clang::CFGPostDomTree` (`clang::CFGDominatorTreeImpl<true>`) object.

The same tree computed on the reversed graph: `A` post-dominates `B` when every path from
`B` to the exit block goes through `A`. Ownership and lifetime are as for `CFGDomTree`,
except when the carrier came from `getCFGPostDomTree` — that one is owned by the
`ControlDependencyCalculator` and must not be disposed.
"""
struct CFGPostDomTree <: AbstractCFGPostDomTree
    ptr::CXCFGPostDomTree
end

"""
    struct ControlDependencyCalculator <: AbstractControlDependencyCalculator
Hold a pointer to a `clang::ControlDependencyCalculator` object.

A post-dominator tree plus llvm's iterated-dominance-frontier calculator over it: `B` is a
control dependency of `A` when `B`'s branch decides whether `A` runs. The pointee is
caller-owned — call `dispose` after use — and, like the trees, must not outlive the `CFG`
it was built from.
"""
struct ControlDependencyCalculator <: AbstractControlDependencyCalculator
    ptr::CXControlDependencyCalculator
end
