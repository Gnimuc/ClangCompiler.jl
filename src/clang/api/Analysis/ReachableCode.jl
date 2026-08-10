# reachable_code — block reachability and the -Wunreachable-code dead-code analysis, as
# structured records rather than diagnostics (clang/Analysis/Analyses/ReachableCode.h).
"""
    ScanReachableFromBlock(start::AbstractCFGBlock) -> Vector{CFGBlock}
Every block of `start`'s graph reachable from `start`, in [`getBlock`](@ref) order and
including `start` itself. clang marks them in a bit vector indexed by block ID; the shim
sizes that vector from the graph and turns the marks back into blocks, so nothing about the
bit vector shows here.

Note that this is clang's dead-code notion of reachability, not the plain successor walk: a
few sink blocks have all their successors treated as reachable.
"""
function ScanReachableFromBlock(start::AbstractCFGBlock)
    @check_ptrs start
    n = Int(getNumBlocks(getParent(start)))
    buf = Vector{CXCFGBlock}(undef, n)
    m = Int(clang_reachable_code_ScanReachableFromBlock(start, buf, n))
    return CFGBlock[CFGBlock(buf[i]) for i in 1:min(m, n)]
end

"""
    UnreachableCodeResult(adc::AbstractAnalysisDeclContext, pp::AbstractPreprocessor) -> UnreachableCodeResult
Run `clang::reachable_code::FindUnreachableCode` over `adc`'s CFG and collect what it
reports — the structured form of `-Wunreachable-code`. `pp` is the preprocessor whose macro
expansion history the analysis consults to stay quiet inside configuration macros, and has
to be the one that produced `adc`'s translation unit.

An `adc` with no CFG produces an empty result rather than an error. This function allocates
and one should call `dispose` to release the resources after using this object.
"""
function UnreachableCodeResult(adc::AbstractAnalysisDeclContext, pp::AbstractPreprocessor)
    @check_ptrs adc pp
    return UnreachableCodeResult(clang_UnreachableCodeResult_create(adc, pp))
end

dispose(x::UnreachableCodeResult) = clang_UnreachableCodeResult_dispose(x)

"""
    getNumUnreachable(x::AbstractUnreachableCodeResult) -> UInt32
How many dead regions the run reported. Every indexed accessor below takes a 0-based index
below this.
"""
function getNumUnreachable(x::AbstractUnreachableCodeResult)
    @check_ptrs x
    return clang_UnreachableCodeResult_getNumUnreachable(x)
end

"""
    getKind(x::AbstractUnreachableCodeResult, i::Integer) -> CXUnreachableKind
What kind of statement the `i`-th dead region starts with — `UK_Return`, `UK_Break`,
`UK_Loop_Increment` or `UK_Other`.
"""
function getKind(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    return clang_UnreachableCodeResult_getKind(x, i)
end

"""
    getLocation(x::AbstractUnreachableCodeResult, i::Integer) -> SourceLocation
Where the `i`-th dead region starts.
"""
function getLocation(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    return SourceLocation(clang_UnreachableCodeResult_getLocation(x, i))
end

"""
    getConditionValRange(x::AbstractUnreachableCodeResult, i::Integer) -> SourceRange
The condition that made the `i`-th region dead. Both endpoints are invalid locations when
clang identified no such condition.
"""
function getConditionValRange(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    r = clang_UnreachableCodeResult_getConditionValRange(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getR1(x::AbstractUnreachableCodeResult, i::Integer) -> SourceRange
The first range clang would underline for the `i`-th region; may be invalid.
"""
function getR1(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    r = clang_UnreachableCodeResult_getR1(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getR2(x::AbstractUnreachableCodeResult, i::Integer) -> SourceRange
The second range clang would underline for the `i`-th region; may be invalid.
"""
function getR2(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    r = clang_UnreachableCodeResult_getR2(x, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getHasFallThroughAttr(x::AbstractUnreachableCodeResult, i::Integer) -> Bool
Whether the `i`-th dead region carries `[[fallthrough]]`.
"""
function getHasFallThroughAttr(x::AbstractUnreachableCodeResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUnreachable(x) "unreachable-region index $i out of range"
    return clang_UnreachableCodeResult_getHasFallThroughAttr(x, i)
end
