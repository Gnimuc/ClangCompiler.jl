# getIntervalWTO — a weak topological ordering of a CFG's blocks
# (clang/Analysis/Analyses/IntervalPartition.h).
"""
    getIntervalWTO(g::AbstractCFG) -> Union{Vector{CFGBlock},Nothing}
A Bourdoncle weak topological ordering of `g`'s blocks: loop heads are grouped with their
bodies and the groups are ordered topologically, which bounds how often a widening fixpoint
has to revisit a node. Better than the plain reverse post order of
[`getBlocksInReversePostOrder`](@ref) for exactly that reason.

`nothing` when `g` is irreducible — clang builds the ordering from the limit flow graph of
the interval partition and there is none in that case (its `std::optional` is empty). The
ordering covers a subset of `g`'s blocks, so the result is never longer than
[`getNumBlocks`](@ref).
"""
function getIntervalWTO(g::AbstractCFG)
    @check_ptrs g
    n = Int(getNumBlocks(g))
    buf = Vector{CXCFGBlock}(undef, n)
    found = Ref{Bool}(false)
    m = Int(clang_getIntervalWTO(g, buf, n, found))
    found[] || return nothing
    return CFGBlock[CFGBlock(buf[i]) for i = 1:min(m, n)]
end
