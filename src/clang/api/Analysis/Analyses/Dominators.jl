# Dominators — dominance, post-dominance and control dependence over a `CFG`
# (clang/Analysis/Analyses/Dominators.h). Build a `CFG` first; every tree here keys its
# nodes on that graph's blocks and holds a bare pointer to the graph itself, so
# `dispose(::CFG)` invalidates the tree and the tree must be disposed first.
#
# `clang::CFGDominatorTreeImpl` is a class template, but the header names the only two
# instantiations that exist and exports an anchor for each, so the two aliases —
# `CFGDomTree` and `CFGPostDomTree` — are what the wrappers speak about. The method sets
# are identical except for `isReachableFromEntry`, which llvm asserts against on a
# post-dominator tree and which therefore has no post-dominator wrapper.
#
# `compare` is missing from both on purpose: `clang::CFGDominatorTreeImpl::compare` is
# declared `const` but calls the non-`const` `getRootNode()`, so in clang 18 the template
# body does not compile once anything instantiates it.

"""
    CFGDomTree(cfg::AbstractCFG) -> CFGDomTree
Return the dominator tree of `cfg`: `A` dominates `B` when every path from the entry block
to `B` goes through `A`.

The default-constructed tree clang also offers is deliberately unreachable from Julia — it
leaves the class's `CFG` member uninitialized, so every later query would read garbage.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CFGDomTree(cfg::AbstractCFG)
    @check_ptrs cfg
    return CFGDomTree(clang_CFGDomTree_create(cfg))
end

dispose(x::CFGDomTree) = clang_CFGDomTree_dispose(x)

"""
    getCFG(x::AbstractCFGDomTree) -> CFG
Return the graph the tree was last built for. The carrier is borrowed — it is the same
graph the caller owns, and must not be disposed twice.
"""
function getCFG(x::AbstractCFGDomTree)
    @check_ptrs x
    return CFG(clang_CFGDomTree_getCFG(x))
end

"""
    getNumRoots(x::AbstractCFGDomTree) -> Cuint
Return the number of roots the tree has. It is the gate for [`getRoot`](@ref), which llvm
implements with an assertion that there is exactly one; a forward dominator tree of a
built graph always has one, the entry block.
"""
function getNumRoots(x::AbstractCFGDomTree)
    @check_ptrs x
    return clang_CFGDomTree_getNumRoots(x)
end

"""
    getRoot(x::AbstractCFGDomTree) -> CFGBlock
Return the root of the tree — the graph's entry block.
"""
function getRoot(x::AbstractCFGDomTree)
    @check_ptrs x
    @assert getNumRoots(x) == 1 "the dominator tree must have exactly one root"
    return CFGBlock(clang_CFGDomTree_getRoot(x))
end

"""
    hasNode(x::AbstractCFGDomTree, b::AbstractCFGBlock) -> Bool
Return whether `b` has a node in the tree. A block the dominator-tree builder never reached
— unreachable code the graph still carries — has none, and the accessors that llvm
implements by dereferencing a block's node are gated on this.
"""
function hasNode(x::AbstractCFGDomTree, b::AbstractCFGBlock)
    @check_ptrs x b
    # LLVM 20's getNode asserts Parent == block->getParent(). After
    # releaseMemory that Parent is null, and a block from another CFG
    # never matches. Both cases mean the block has no node.
    getNumRoots(x) == 0 && return false
    getCFG(x).ptr == getParent(b).ptr || return false
    return clang_CFGDomTree_hasNode(x, b)
end

"""
    buildDominatorTree(x::AbstractCFGDomTree, cfg::AbstractCFG)
Recompute the tree for `cfg`, which becomes the tree's graph.
"""
function buildDominatorTree(x::AbstractCFGDomTree, cfg::AbstractCFG)
    @check_ptrs x cfg
    return clang_CFGDomTree_buildDominatorTree(x, cfg)
end

"""
    dump(x::AbstractCFGDomTree)
Write one `(block id, immediate dominator id)` line per block to `stderr`.

clang's own `dump` dereferences the tree node of every block of the graph with no null
check, so this asserts first that every block has one.
"""
function dump(x::AbstractCFGDomTree)
    @check_ptrs x
    cfg = getCFG(x)
    for i = 0:(Int(getNumBlocks(cfg)) - 1)
        @assert hasNode(x, getBlock(cfg, i)) "block $i has no dominator-tree node; dump would dereference it"
    end
    return clang_CFGDomTree_dump(x)
end

"""
    dominates(x::AbstractCFGDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock) -> Bool
Return whether `a` dominates `b`. A block dominates itself, an unreachable block is
dominated by everything, and an unreachable block dominates nothing.
"""
function dominates(x::AbstractCFGDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    # llvm's getNode asserts the block's parent is the tree's own graph, and both
    # `dominates` and `properlyDominates` reach it. A released tree holds no graph and a
    # block from another CFG never matches, so both abort inside clang.
    @assert getNumRoots(x) != 0 "the tree holds no graph; build it before querying"
    @assert getCFG(x).ptr == getParent(a).ptr == getParent(b).ptr "the blocks belong to a different CFG"
    return clang_CFGDomTree_dominates(x, a, b)
end

"""
    properlyDominates(x::AbstractCFGDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock) -> Bool
Return [`dominates`](@ref) with the reflexive case removed: `false` when `a === b`.
"""
function properlyDominates(x::AbstractCFGDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getNumRoots(x) != 0 "the tree holds no graph; build it before querying"
    @assert getCFG(x).ptr == getParent(a).ptr == getParent(b).ptr "the blocks belong to a different CFG"
    return clang_CFGDomTree_properlyDominates(x, a, b)
end

"""
    findNearestCommonDominator(x::AbstractCFGDomTree, a::AbstractCFGBlock,
                               b::AbstractCFGBlock) -> CFGBlock
Return the nearest block that dominates both `a` and `b`.

llvm asserts that the two blocks belong to the same graph and that both have a tree node,
so both are checked here.

!!! warning "Wrong when either block is the CFG's exit"
    `llvm::DominatorTreeBase::findNearestCommonDominator` opens with a shortcut —
    `NodeT &Entry = A->getParent()->front(); if (A == &Entry || B == &Entry) return &Entry;`
    — which assumes the parent container's first element is the entry node. clang's `CFG`
    puts the **exit** block at `front()` (it is built first and carries ID 0), so for any
    pair involving the exit the shortcut fires and returns the exit.

    The answer is then not a dominator of its arguments at all. Measured over a
    six-block graph: 26 pairs sound, and the 10 unsound ones exactly those naming block 0.
    Away from the exit block the result is a genuine common dominator, so guard with
    `getBlockID(b) != 0` (or `b.ptr != getExit(cfg).ptr`) when either operand could be it.
"""
function findNearestCommonDominator(x::AbstractCFGDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getParent(a).ptr == getParent(b).ptr "the two blocks belong to different CFGs"
    @assert hasNode(x, a) && hasNode(x, b) "both blocks must have a dominator-tree node"
    return CFGBlock(clang_CFGDomTree_findNearestCommonDominator(x, a, b))
end

"""
    changeImmediateDominator(x::AbstractCFGDomTree, n::AbstractCFGBlock,
                             new_idom::AbstractCFGBlock)
Re-parent `n` under `new_idom` in the tree. Both blocks must have a tree node, which llvm
asserts. Only the tree changes — the graph is untouched, and a later
[`buildDominatorTree`](@ref) discards the edit.
"""
function changeImmediateDominator(x::AbstractCFGDomTree, n::AbstractCFGBlock, new_idom::AbstractCFGBlock)
    @check_ptrs x n new_idom
    @assert hasNode(x, n) && hasNode(x, new_idom) "both blocks must have a dominator-tree node"
    return clang_CFGDomTree_changeImmediateDominator(x, n, new_idom)
end

"""
    isReachableFromEntry(x::AbstractCFGDomTree, a::AbstractCFGBlock) -> Bool
Return whether `a` is reachable from the graph's entry block. There is no post-dominator
counterpart: llvm's accessor opens with an assertion that the tree is not a post-dominator
tree.
"""
function isReachableFromEntry(x::AbstractCFGDomTree, a::AbstractCFGBlock)
    @check_ptrs x a
    @assert getNumRoots(x) != 0 "the tree holds no graph; build it before querying"
    @assert getCFG(x).ptr == getParent(a).ptr "the block belongs to a different CFG"
    return clang_CFGDomTree_isReachableFromEntry(x, a)
end

"""
    releaseMemory(x::AbstractCFGDomTree)
Drop the computed tree. The graph pointer survives, so [`buildDominatorTree`](@ref) can
rebuild it; until then every block reads back as having no node.
"""
function releaseMemory(x::AbstractCFGDomTree)
    @check_ptrs x
    return clang_CFGDomTree_releaseMemory(x)
end

function printAsString(x::AbstractCFGDomTree)
    @check_ptrs x
    return get_string(clang_CFGDomTree_printAsString(x))
end

# CFGPostDomTree — the same tree on the reversed graph: `a` post-dominates `b` when every
# path from `b` to the exit block goes through `a`.

"""
    CFGPostDomTree(cfg::AbstractCFG) -> CFGPostDomTree
Return the post-dominator tree of `cfg`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CFGPostDomTree(cfg::AbstractCFG)
    @check_ptrs cfg
    return CFGPostDomTree(clang_CFGPostDomTree_create(cfg))
end

dispose(x::CFGPostDomTree) = clang_CFGPostDomTree_dispose(x)

"""
    getCFG(x::AbstractCFGPostDomTree) -> CFG
Return the graph the tree was last built for; the carrier is borrowed.
"""
function getCFG(x::AbstractCFGPostDomTree)
    @check_ptrs x
    return CFG(clang_CFGPostDomTree_getCFG(x))
end

"""
    getNumRoots(x::AbstractCFGPostDomTree) -> Cuint
Return the number of roots the tree has — the gate for [`getRoot`](@ref). Unlike the
forward tree this is genuinely variable: a graph whose exit is unreachable, or that leaves
by several routes, gives a count other than one.
"""
function getNumRoots(x::AbstractCFGPostDomTree)
    @check_ptrs x
    return clang_CFGPostDomTree_getNumRoots(x)
end

"""
    getRoot(x::AbstractCFGPostDomTree) -> CFGBlock
Return the root of the post-dominator tree — normally the graph's exit block.
"""
function getRoot(x::AbstractCFGPostDomTree)
    @check_ptrs x
    @assert getNumRoots(x) == 1 "the post-dominator tree must have exactly one root"
    return CFGBlock(clang_CFGPostDomTree_getRoot(x))
end

"""
    hasNode(x::AbstractCFGPostDomTree, b::AbstractCFGBlock) -> Bool
Return whether `b` has a node in the post-dominator tree.
"""
function hasNode(x::AbstractCFGPostDomTree, b::AbstractCFGBlock)
    @check_ptrs x b
    getNumRoots(x) == 0 && return false
    getCFG(x).ptr == getParent(b).ptr || return false
    return clang_CFGPostDomTree_hasNode(x, b)
end

"""
    buildDominatorTree(x::AbstractCFGPostDomTree, cfg::AbstractCFG)
Recompute the post-dominator tree for `cfg`.
"""
function buildDominatorTree(x::AbstractCFGPostDomTree, cfg::AbstractCFG)
    @check_ptrs x cfg
    return clang_CFGPostDomTree_buildDominatorTree(x, cfg)
end

"""
    dump(x::AbstractCFGPostDomTree)
Write one `(block id, immediate post-dominator id)` line per block to `stderr`. As for the
forward tree, every block must have a node.
"""
function dump(x::AbstractCFGPostDomTree)
    @check_ptrs x
    cfg = getCFG(x)
    for i = 0:(Int(getNumBlocks(cfg)) - 1)
        @assert hasNode(x, getBlock(cfg, i)) "block $i has no post-dominator-tree node; dump would dereference it"
    end
    return clang_CFGPostDomTree_dump(x)
end

"""
    dominates(x::AbstractCFGPostDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock) -> Bool
Return whether `a` post-dominates `b`.
"""
function dominates(x::AbstractCFGPostDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getNumRoots(x) != 0 "the tree holds no graph; build it before querying"
    @assert getCFG(x).ptr == getParent(a).ptr == getParent(b).ptr "the blocks belong to a different CFG"
    return clang_CFGPostDomTree_dominates(x, a, b)
end

"""
    properlyDominates(x::AbstractCFGPostDomTree, a::AbstractCFGBlock,
                      b::AbstractCFGBlock) -> Bool
Return [`dominates`](@ref) with the reflexive case removed.
"""
function properlyDominates(x::AbstractCFGPostDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getNumRoots(x) != 0 "the tree holds no graph; build it before querying"
    @assert getCFG(x).ptr == getParent(a).ptr == getParent(b).ptr "the blocks belong to a different CFG"
    return clang_CFGPostDomTree_properlyDominates(x, a, b)
end

"""
    findNearestCommonDominator(x::AbstractCFGPostDomTree, a::AbstractCFGBlock,
                               b::AbstractCFGBlock) -> CFGBlock
Return the nearest block that post-dominates both `a` and `b`.
"""
function findNearestCommonDominator(x::AbstractCFGPostDomTree, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getParent(a).ptr == getParent(b).ptr "the two blocks belong to different CFGs"
    @assert hasNode(x, a) && hasNode(x, b) "both blocks must have a post-dominator-tree node"
    return CFGBlock(clang_CFGPostDomTree_findNearestCommonDominator(x, a, b))
end

"""
    changeImmediateDominator(x::AbstractCFGPostDomTree, n::AbstractCFGBlock,
                             new_idom::AbstractCFGBlock)
Re-parent `n` under `new_idom` in the post-dominator tree.
"""
function changeImmediateDominator(x::AbstractCFGPostDomTree, n::AbstractCFGBlock, new_idom::AbstractCFGBlock)
    @check_ptrs x n new_idom
    @assert hasNode(x, n) && hasNode(x, new_idom) "both blocks must have a post-dominator-tree node"
    return clang_CFGPostDomTree_changeImmediateDominator(x, n, new_idom)
end

"""
    releaseMemory(x::AbstractCFGPostDomTree)
Drop the computed post-dominator tree.
"""
function releaseMemory(x::AbstractCFGPostDomTree)
    @check_ptrs x
    return clang_CFGPostDomTree_releaseMemory(x)
end

function printAsString(x::AbstractCFGPostDomTree)
    @check_ptrs x
    return get_string(clang_CFGPostDomTree_printAsString(x))
end

# ControlDependencyCalculator — the iterated dominance frontier of the post-dominator
# tree: `b` is a control dependency of `a` when `b`'s branch is what decides whether `a`
# runs.

"""
    ControlDependencyCalculator(cfg::AbstractCFG) -> ControlDependencyCalculator
Return a control-dependence calculator over `cfg`. It builds its own post-dominator tree
and answers each query lazily, memoizing the result.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ControlDependencyCalculator(cfg::AbstractCFG)
    @check_ptrs cfg
    return ControlDependencyCalculator(clang_ControlDependencyCalculator_create(cfg))
end

dispose(x::ControlDependencyCalculator) = clang_ControlDependencyCalculator_dispose(x)

"""
    getCFGPostDomTree(x::AbstractControlDependencyCalculator) -> CFGPostDomTree
Return the post-dominator tree the calculator works over. The carrier is BORROWED — the
tree is a member of the calculator, so it must not be disposed.
"""
function getCFGPostDomTree(x::AbstractControlDependencyCalculator)
    @check_ptrs x
    return CFGPostDomTree(clang_ControlDependencyCalculator_getCFGPostDomTree(x))
end

"""
    getNumControlDependencies(x::AbstractControlDependencyCalculator,
                              a::AbstractCFGBlock) -> Cuint
Return how many blocks `a` is control dependent on. Computing this is what populates the
calculator's cache, so the paired [`getControlDependencies`](@ref) call sees the same set.
"""
function getNumControlDependencies(x::AbstractControlDependencyCalculator, a::AbstractCFGBlock)
    @check_ptrs x a
    @assert getParent(a).ptr == getCFG(getCFGPostDomTree(x)).ptr "the block belongs to a different CFG"
    return clang_ControlDependencyCalculator_getNumControlDependencies(x, a)
end

"""
    getControlDependencies(x::AbstractControlDependencyCalculator,
                           a::AbstractCFGBlock) -> Vector{CFGBlock}
Return the blocks `a` is control dependent on: those whose branch decides whether `a` runs.
`a` must be a block of the graph the calculator was built from.
"""
function getControlDependencies(x::AbstractControlDependencyCalculator, a::AbstractCFGBlock)
    @check_ptrs x a
    n = Int(getNumControlDependencies(x, a))
    buf = Vector{CXCFGBlock}(undef, n)
    n > 0 && clang_ControlDependencyCalculator_getControlDependencies(x, a, buf, n)
    return [CFGBlock(p) for p in buf]
end

"""
    isControlDependent(x::AbstractControlDependencyCalculator, a::AbstractCFGBlock,
                       b::AbstractCFGBlock) -> Bool
Return whether `b` is one of `a`'s control dependencies. Both blocks must belong to the
calculator's graph.
"""
function isControlDependent(x::AbstractControlDependencyCalculator, a::AbstractCFGBlock, b::AbstractCFGBlock)
    @check_ptrs x a b
    @assert getParent(a).ptr == getParent(b).ptr "the two blocks belong to different CFGs"
    @assert getParent(a).ptr == getCFG(getCFGPostDomTree(x)).ptr "the blocks belong to a different CFG"
    return clang_ControlDependencyCalculator_isControlDependent(x, a, b)
end

"""
    dump(x::AbstractControlDependencyCalculator)
Write one `(block id, dependency id)` line per control dependency to `stderr`.
"""
function dump(x::AbstractControlDependencyCalculator)
    @check_ptrs x
    return clang_ControlDependencyCalculator_dump(x)
end
