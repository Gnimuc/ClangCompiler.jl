abstract type AbstractCFGReverseBlockReachabilityAnalysis end

"""
    struct CFGReverseBlockReachabilityAnalysis <: AbstractCFGReverseBlockReachabilityAnalysis
Hold a pointer to a `clang::CFGReverseBlockReachabilityAnalysis` object.

Two provenances, one carrier: the pointee is caller-owned when it came from
[`CFGReverseBlockReachabilityAnalysis`](@ref) — call `dispose` after use — and owned by the
`AnalysisDeclContext` when it came from [`getCFGReachablityAnalysis`](@ref), in which case
disposing it is a double free.
"""
struct CFGReverseBlockReachabilityAnalysis <: AbstractCFGReverseBlockReachabilityAnalysis
    ptr::CXCFGReverseBlockReachabilityAnalysis
end
