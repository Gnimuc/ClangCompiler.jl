# runUninitializedVariablesAnalysis — the -Wuninitialized dataflow, as structured records
# rather than diagnostics (clang/Analysis/Analyses/UninitializedValues.h). clang reports
# through a virtual handler and hands out `UninitUse` temporaries; the shim runs the analysis
# behind one fixed handler subclass and keeps every report, so what crosses is a buffer.
"""
    UninitVariablesResult(adc::AbstractAnalysisDeclContext) -> UninitVariablesResult
    UninitVariablesResult(dc::AnyDeclContext, g::AbstractCFG, adc::AbstractAnalysisDeclContext) -> UninitVariablesResult

Run the uninitialized-variables analysis and collect its reports. The one-argument form is
the call clang's own `-Wuninitialized` makes: `dc` is `adc`'s declaration seen as a
`DeclContext` (the variables to analyse) and `g` is `getCFG(adc)`.

`g` must be `adc`'s own graph — the analysis walks it under `adc`'s post-order view and
indexes it by that view's block IDs. `adc` therefore needs a CFG at all, which is why the
one-argument form asserts one exists.

This function allocates and one should call `dispose` to release the resources after using
this object. The result holds borrowed AST pointers and stays meaningful exactly as long as
the translation unit does.

!!! note "The CFG has to carry the variable references"
    The analysis reads variable references out of the CFG's block-level elements. Under
    clang's default build options a CFG carries whole statements and no sub-expressions, and
    the analysis then reports *no uses at all* — not a smaller set, an empty one — however
    uninitialised the source is. Configure the options before the CFG is built, as clang's
    own `-Wuninitialized` path does:

    ```julia
    adc = AnalysisDeclContext(fd)
    setAllAlwaysAdd(getCFGBuildOptions(adc))   # BEFORE the CFG is built
    r = UninitVariablesResult(adc)
    ```
"""
function UninitVariablesResult(adc::AbstractAnalysisDeclContext)
    @check_ptrs adc
    g = getCFG(adc)
    @assert !is_null_handle(g) "this AnalysisDeclContext has no CFG to analyse"
    return UninitVariablesResult(castToDeclContext(getDecl(adc)), g, adc)
end

function UninitVariablesResult(dc::AnyDeclContext, g::AbstractCFG,
                               adc::AbstractAnalysisDeclContext)
    @check_ptrs dc g adc
    @assert getCFG(adc).ptr == g.ptr "the CFG must be the one this AnalysisDeclContext built"
    return UninitVariablesResult(clang_UninitVariablesResult_create(dc, g, adc))
end

dispose(x::UninitVariablesResult) = clang_UninitVariablesResult_dispose(x)

"""
    getNumVariablesAnalyzed(x::AbstractUninitVariablesResult) -> UInt32
`clang::UninitVariablesAnalysisStats::NumVariablesAnalyzed` for the run that produced `x`.
"""
function getNumVariablesAnalyzed(x::AbstractUninitVariablesResult)
    @check_ptrs x
    return clang_UninitVariablesResult_getNumVariablesAnalyzed(x)
end

"""
    getNumBlockVisits(x::AbstractUninitVariablesResult) -> UInt32
`clang::UninitVariablesAnalysisStats::NumBlockVisits` for the run that produced `x` — how
many block transfers the fixpoint took.
"""
function getNumBlockVisits(x::AbstractUninitVariablesResult)
    @check_ptrs x
    return clang_UninitVariablesResult_getNumBlockVisits(x)
end

"""
    getNumUses(x::AbstractUninitVariablesResult) -> UInt32
How many possibly-uninitialized uses the run reported. Every indexed accessor below takes a
0-based index below this.
"""
function getNumUses(x::AbstractUninitVariablesResult)
    @check_ptrs x
    return clang_UninitVariablesResult_getNumUses(x)
end

"""
    getVarDecl(x::AbstractUninitVariablesResult, i::Integer) -> VarDecl
The variable used uninitialized in the `i`-th report.
"""
function getVarDecl(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    return VarDecl(clang_UninitVariablesResult_getVarDecl(x, i))
end

"""
    getUser(x::AbstractUninitVariablesResult, i::Integer) -> Expr_
The expression that reads the variable in the `i`-th report —
`clang::UninitUse::getUser`.
"""
function getUser(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    return Expr_(clang_UninitVariablesResult_getUser(x, i))
end

"""
    getKind(x::AbstractUninitVariablesResult, i::Integer) -> CXUninitUseKind
How certain the `i`-th report is — `clang::UninitUse::getKind`, from `Maybe` through
`Sometimes`, `AfterDecl` and `AfterCall` to `Always`.
"""
function getKind(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    return clang_UninitVariablesResult_getKind(x, i)
end

"""
    isConstRefUse(x::AbstractUninitVariablesResult, i::Integer) -> Bool
Whether the `i`-th report came through `handleConstRefUseOfUninitVariable` — the variable
was passed as a const reference — rather than through `handleUseOfUninitVariable`.
"""
function isConstRefUse(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    return clang_UninitVariablesResult_isConstRefUse(x, i)
end

"""
    getNumBranches(x::AbstractUninitVariablesResult, i::Integer) -> UInt32
How many guilty branches the `i`-th report carries. Non-zero exactly for the `Sometimes`
kind.
"""
function getNumBranches(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    return clang_UninitVariablesResult_getNumBranches(x, i)
end

"""
    getBranchTerminator(x::AbstractUninitVariablesResult, i::Integer, j::Integer) -> Stmt
The terminator of the `j`-th guilty branch of the `i`-th report — the branch after which the
use is inevitably uninitialized.
"""
function getBranchTerminator(x::AbstractUninitVariablesResult, i::Integer, j::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    @assert 0 <= j < getNumBranches(x, i) "branch index $j out of range"
    return Stmt(clang_UninitVariablesResult_getBranchTerminator(x, i, j))
end

"""
    getBranchOutput(x::AbstractUninitVariablesResult, i::Integer, j::Integer) -> UInt32
Which successor of that terminator is the guilty one — `clang::UninitUse::Branch::Output`.
"""
function getBranchOutput(x::AbstractUninitVariablesResult, i::Integer, j::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUses(x) "use index $i out of range"
    @assert 0 <= j < getNumBranches(x, i) "branch index $j out of range"
    return clang_UninitVariablesResult_getBranchOutput(x, i, j)
end

"""
    getNumSelfInits(x::AbstractUninitVariablesResult) -> UInt32
How many `int x = x` self-initializations the run reported. These are a separate list: the
`handleSelfInit` callback carries no `UninitUse`.
"""
function getNumSelfInits(x::AbstractUninitVariablesResult)
    @check_ptrs x
    return clang_UninitVariablesResult_getNumSelfInits(x)
end

"""
    getSelfInit(x::AbstractUninitVariablesResult, i::Integer) -> VarDecl
The `i`-th self-initialized variable.
"""
function getSelfInit(x::AbstractUninitVariablesResult, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSelfInits(x) "self-init index $i out of range"
    return VarDecl(clang_UninitVariablesResult_getSelfInit(x, i))
end
