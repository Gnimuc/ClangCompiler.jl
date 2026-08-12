# PostOrderCFGView — the canonical block order for a forward fixed-point analysis
# (clang/Analysis/Analyses/PostOrderCFGView.h). The view object holds nothing but the
# ordering, so it never crosses: it is built, drained and destroyed inside the one call.
"""
    getBlocksInReversePostOrder(g::AbstractCFG) -> Vector{CFGBlock}
The blocks of `g` in reverse post order — a `clang::PostOrderCFGView` walked front to back.
Every block is visited after all of its predecessors except across back edges, which is what
makes a forward dataflow over this order converge in one pass per loop nesting level.

Only the blocks reachable from the entry appear, so the result can be shorter than
[`getNumBlocks`](@ref) and is never longer.
"""
function getBlocksInReversePostOrder(g::AbstractCFG)
    @check_ptrs g
    n = Int(getNumBlocks(g))
    buf = Vector{CXCFGBlock}(undef, n)
    m = Int(clang_PostOrderCFGView_getBlocksInReversePostOrder(g, buf, n))
    return CFGBlock[CFGBlock(buf[i]) for i = 1:min(m, n)]
end
