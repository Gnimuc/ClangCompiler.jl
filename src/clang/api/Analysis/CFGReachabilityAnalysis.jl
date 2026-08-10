# CFGReverseBlockReachabilityAnalysis — cached block-to-block reachability over one CFG
# (clang/Analysis/Analyses/CFGReachabilityAnalysis.h).
"""
    CFGReverseBlockReachabilityAnalysis(g::AbstractCFG) -> CFGReverseBlockReachabilityAnalysis
Build a reachability oracle over `g`. Queries are answered by a reverse search from the
destination block, cached per destination.

This function allocates and one should call `dispose` to release the resources after using
this object. The same analysis is also available BORROWED, and must not be disposed, as
[`getCFGReachablityAnalysis`](@ref) of an `AnalysisDeclContext`.
"""
function CFGReverseBlockReachabilityAnalysis(g::AbstractCFG)
    @check_ptrs g
    return CFGReverseBlockReachabilityAnalysis(clang_CFGReverseBlockReachabilityAnalysis_create(g))
end

dispose(x::CFGReverseBlockReachabilityAnalysis) = clang_CFGReverseBlockReachabilityAnalysis_dispose(x)

"""
    isReachable(x::AbstractCFGReverseBlockReachabilityAnalysis, src::AbstractCFGBlock, dst::AbstractCFGBlock) -> Bool
Whether `dst` can be reached from `src`.

Both blocks have to belong to the graph `x` was built over: clang indexes two bit vectors
sized from that graph with `src`'s and `dst`'s block IDs and bounds-checks neither. Sharing a
parent graph is as much of that as is checkable from here — the analysis object does not
record which graph it came from — so the assertion below catches the common mistake of
mixing two functions' blocks, not the rarer one of querying a graph the analysis never saw.
"""
function isReachable(x::AbstractCFGReverseBlockReachabilityAnalysis, src::AbstractCFGBlock,
                     dst::AbstractCFGBlock)
    @check_ptrs x src dst
    @assert getParent(src).ptr == getParent(dst).ptr "src and dst belong to different CFGs"
    return clang_CFGReverseBlockReachabilityAnalysis_isReachable(x, src, dst)
end
