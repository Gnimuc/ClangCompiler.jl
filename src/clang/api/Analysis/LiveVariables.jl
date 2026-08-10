# LiveVariables — the backwards liveness dataflow over an AnalysisDeclContext's CFG
# (clang/Analysis/Analyses/LiveVariables.h). Poll-only: the three `isLive` overloads are the
# whole read surface, and `runOnAllBlocks` is not wrapped because its `Observer` is a virtual
# interface.
"""
    computeLiveness(adc::AbstractAnalysisDeclContext, kill_at_assign::Bool=true) -> LiveVariables
Compute liveness over `adc`'s CFG. `kill_at_assign` true is `clang::LiveVariables::create`,
the flavour the static analyzer uses, where assigning to a variable kills the value it held;
false is `clang::RelaxedLiveVariables::create`, which keeps it live. The wrapped pointer is
NULL when `adc` has no CFG.

`adc` has to outlive the result — the analysis keeps a reference to it. This function
allocates and one should call `dispose` to release the resources after using this object.

!!! note "The CFG has to carry the variable references"
    Liveness is computed from the CFG's block-level elements, so a variable only ever reads
    as live if the `DeclRefExpr` that reads it is one of them. Under clang's default build
    options a CFG carries whole statements and no sub-expressions, and every `isLive` query
    then answers `false` for every variable, however plainly the source reads one. clang's
    own `-Wuninitialized`/`-Wunused` path avoids that by configuring the options first, and
    so must a caller here:

    ```julia
    adc = AnalysisDeclContext(fd)
    setAllAlwaysAdd(getCFGBuildOptions(adc))   # BEFORE the CFG is built
    lv = computeLiveness(adc)
    ```

    The options are only consulted while the CFG is built, and `getCFG` caches it, so this
    has to happen before the first call that builds one.
"""
function computeLiveness(adc::AbstractAnalysisDeclContext, kill_at_assign::Bool=true)
    @check_ptrs adc
    return LiveVariables(clang_LiveVariables_computeLiveness(adc, kill_at_assign))
end

dispose(x::LiveVariables) = clang_LiveVariables_dispose(x)

"""
    isLive(x::AbstractLiveVariables, b::AbstractCFGBlock, d::AbstractVarDecl) -> Bool
Whether `d` is live at the *end* of `b`. `b` has to be a block of the CFG the analysis was
computed over; clang looks it up in a map keyed on the block pointer, so a block of any
other graph reads back as not live rather than failing.
"""
function isLive(x::AbstractLiveVariables, b::AbstractCFGBlock, d::AbstractVarDecl)
    @check_ptrs x b d
    return clang_LiveVariables_isLive(x, b, d)
end

"""
    isLive(x::AbstractLiveVariables, s::AbstractStmt, d::AbstractVarDecl) -> Bool
Whether `d` is live at the beginning of `s`. Statement-level liveness is only recorded for
block-level expressions, and clang's lookup is a default-constructing probe, so a statement
the analysis never recorded reads back as not live.
"""
function isLive(x::AbstractLiveVariables, s::AbstractStmt, d::AbstractVarDecl)
    @check_ptrs x s d
    return clang_LiveVariables_isLiveAtStmt(x, s, d)
end

"""
    isLive(x::AbstractLiveVariables, loc::AbstractStmt, val::AbstractExpr) -> Bool
Whether the value of the block-level expression `val` is live before `loc`. Same
default-constructing lookup as the `VarDecl` overload above.
"""
function isLive(x::AbstractLiveVariables, loc::AbstractStmt, val::AbstractExpr)
    @check_ptrs x loc val
    return clang_LiveVariables_isExprLiveAtStmt(x, loc, val)
end

"""
    dumpBlockLiveness(x::AbstractLiveVariables, sm::AbstractSourceManager)
Print the per-block liveness sets to stderr.
"""
function dumpBlockLiveness(x::AbstractLiveVariables, sm::AbstractSourceManager)
    @check_ptrs x sm
    return clang_LiveVariables_dumpBlockLiveness(x, sm)
end

"""
    dumpExprLiveness(x::AbstractLiveVariables, sm::AbstractSourceManager)
Print the per-block live expression sets to stderr.
"""
function dumpExprLiveness(x::AbstractLiveVariables, sm::AbstractSourceManager)
    @check_ptrs x sm
    return clang_LiveVariables_dumpExprLiveness(x, sm)
end
