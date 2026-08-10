# CloneDetection — turn-key duplicate-code search over parsed function bodies
# (clang/Analysis/CloneDetection.h). Feed bodies in with `analyzeCodeBody`, run
# `findClones`, then read the groups back with `getCloneGroups`.
#
# `clang::CloneDetector::findClones` is a variadic template over constraint objects, so the
# pipeline cannot cross the C boundary as data. Exactly one is offered — clang's standard
# type-II chain, hash-partition then complexity, group size, exact verification and
# largest-only — with its two numeric knobs as keyword arguments. The detector stores
# statement sequences pointing into the ASTs it analysed, so it must not outlive them.

"""
    CloneDetector() -> CloneDetector
Return an empty clone detector.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
CloneDetector() = CloneDetector(clang_CloneDetector_create())

dispose(x::CloneDetector) = clang_CloneDetector_dispose(x)

"""
    analyzeCodeBody(x::AbstractCloneDetector, decl::AbstractDecl)
Collect search data for every statement in `decl`'s body. `decl` must have a body, which
clang asserts. Call it once per declaration; the detector accumulates, and clones are only
ever found between bodies that have both been analysed.
"""
function analyzeCodeBody(x::AbstractCloneDetector, decl::AbstractDecl)
    @check_ptrs x decl
    @assert hasBody(decl) "the declaration must have a body"
    return clang_CloneDetector_analyzeCodeBody(x, decl)
end

"""
    findClones(x::AbstractCloneDetector; min_complexity::Integer=50,
               min_group_size::Integer=2)
Search everything analysed so far for type-II clones — code fragments that differ only in
the identifiers and literals they use — and store the resulting groups on the detector,
replacing any previous result.

`min_complexity` is the smallest statement complexity (total child count) a clone may have;
50 is the value clang's own clone checker defaults to, and lowering it reports much smaller
fragments. `min_group_size` is the smallest number of clones a group may hold.
"""
function findClones(x::AbstractCloneDetector; min_complexity::Integer=50, min_group_size::Integer=2)
    @check_ptrs x
    @assert min_complexity >= 0 "complexity is a count, so it cannot be negative"
    @assert min_group_size >= 1 "a clone group holds at least one clone"
    return clang_CloneDetector_findClones(x, min_complexity, min_group_size)
end

"""
    getNumCloneGroups(x::AbstractCloneDetector) -> Cuint
Return how many clone groups the last [`findClones`](@ref) produced; zero before the first
call.
"""
function getNumCloneGroups(x::AbstractCloneDetector)
    @check_ptrs x
    return clang_CloneDetector_getNumCloneGroups(x)
end

"""
    getCloneGroupSize(x::AbstractCloneDetector, g::Integer) -> Cuint
Return how many clones group `g` holds (0-based, `g < getNumCloneGroups(x)`).
"""
function getCloneGroupSize(x::AbstractCloneDetector, g::Integer)
    @check_ptrs x
    @assert 0 <= g < getNumCloneGroups(x) "clone group index $g out of range"
    return clang_CloneDetector_getCloneGroupSize(x, g)
end

"""
    getCloneContainingDecl(x::AbstractCloneDetector, g::Integer, i::Integer) -> Decl
Return the declaration whose body the `i`-th clone of group `g` lives in.
"""
function getCloneContainingDecl(x::AbstractCloneDetector, g::Integer, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getCloneGroupSize(x, g) "clone index $i out of range"
    return Decl(clang_CloneDetector_getCloneContainingDecl(x, g, i))
end

"""
    getCloneNumStmts(x::AbstractCloneDetector, g::Integer, i::Integer) -> Cuint
Return how many top-level statements the `i`-th clone of group `g` spans.
"""
function getCloneNumStmts(x::AbstractCloneDetector, g::Integer, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getCloneGroupSize(x, g) "clone index $i out of range"
    return clang_CloneDetector_getCloneNumStmts(x, g, i)
end

"""
    cloneHoldsSequence(x::AbstractCloneDetector, g::Integer, i::Integer) -> Bool
Return whether the `i`-th clone of group `g` is a run of children of a compound statement
rather than one standalone statement.
"""
function cloneHoldsSequence(x::AbstractCloneDetector, g::Integer, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getCloneGroupSize(x, g) "clone index $i out of range"
    return clang_CloneDetector_cloneHoldsSequence(x, g, i)
end

"""
    getCloneStmt(x::AbstractCloneDetector, g::Integer, i::Integer, j::Integer) -> Stmt
Return the `j`-th top-level statement of the `i`-th clone of group `g` (0-based,
`j < getCloneNumStmts(x, g, i)`). `resolve` it to refine the statement class.
"""
function getCloneStmt(x::AbstractCloneDetector, g::Integer, i::Integer, j::Integer)
    @check_ptrs x
    @assert 0 <= j < getCloneNumStmts(x, g, i) "statement index $j out of range"
    return Stmt(clang_CloneDetector_getCloneStmt(x, g, i, j))
end

"""
    getCloneSourceRange(x::AbstractCloneDetector, g::Integer, i::Integer) -> SourceRange
Return the source range of the `i`-th clone of group `g`, from the start of its first
statement to the end of its last. Both locations are invalid for an empty clone, which
clang's own accessors assert against and the shim answers instead.
"""
function getCloneSourceRange(x::AbstractCloneDetector, g::Integer, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getCloneGroupSize(x, g) "clone index $i out of range"
    r = clang_CloneDetector_getCloneSourceRange(x, g, i)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    cloneContains(x::AbstractCloneDetector, g::Integer, i::Integer, other_g::Integer,
                  other_i::Integer) -> Bool
Return whether the source range of clone `(g, i)` contains that of clone
`(other_g, other_i)`. `false` when either clone is empty — the case clang's own accessor
asserts against.
"""
function cloneContains(x::AbstractCloneDetector, g::Integer, i::Integer, other_g::Integer, other_i::Integer)
    @check_ptrs x
    @assert 0 <= i < getCloneGroupSize(x, g) "clone index $i out of range"
    @assert 0 <= other_i < getCloneGroupSize(x, other_g) "clone index $other_i out of range"
    return clang_CloneDetector_cloneContains(x, g, i, other_g, other_i)
end

"""
    getCloneGroup(x::AbstractCloneDetector, g::Integer) -> Vector{CloneSequence}
Return group `g` as a vector of records, each carrying the containing declaration, the
statements the clone spans, whether it is a compound-statement window, and its source
range.
"""
function getCloneGroup(x::AbstractCloneDetector, g::Integer)
    @check_ptrs x
    n = Int(getCloneGroupSize(x, g))
    out = Vector{CloneSequence}(undef, n)
    for i = 0:(n - 1)
        m = Int(getCloneNumStmts(x, g, i))
        stmts = Vector{Stmt}(undef, m)
        for j = 0:(m - 1)
            stmts[j + 1] = getCloneStmt(x, g, i, j)
        end
        out[i + 1] = CloneSequence(getCloneContainingDecl(x, g, i), stmts,
                                   cloneHoldsSequence(x, g, i), getCloneSourceRange(x, g, i))
    end
    return out
end

"""
    getCloneGroups(x::AbstractCloneDetector) -> Vector{Vector{CloneSequence}}
Return every clone group the last [`findClones`](@ref) produced.
"""
function getCloneGroups(x::AbstractCloneDetector)
    @check_ptrs x
    return [getCloneGroup(x, g) for g = 0:(Int(getNumCloneGroups(x)) - 1)]
end
