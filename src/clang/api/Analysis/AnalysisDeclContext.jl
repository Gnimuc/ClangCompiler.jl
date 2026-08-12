# AnalysisDeclContext — the per-Decl analysis hub (clang/Analysis/AnalysisDeclContext.h).
# Everything it caches is built lazily and owned by the context, so every getter below
# returns a BORROWED carrier: never `dispose` a `CFG`, `CFGStmtMap`, `ParentMap` or
# `CFGReverseBlockReachabilityAnalysis` that came out of one of them.

"""
    AnalysisDeclContext(d::AnalyzableDecl) -> AnalysisDeclContext
    AnalysisDeclContext(mgr::AbstractAnalysisDeclContextManager, d::AnalyzableDecl) -> AnalysisDeclContext
    AnalysisDeclContext(d::AnalyzableDecl, opts::AbstractCFGBuildOptions) -> AnalysisDeclContext
    AnalysisDeclContext(mgr::AbstractAnalysisDeclContextManager, d::AnalyzableDecl, opts::AbstractCFGBuildOptions) -> AnalysisDeclContext

Build a standalone analysis context for `d`. Without `mgr` the context belongs to no
manager, which only costs it the body-synthesis policy; with one it is still caller-owned —
only [`getContext`](@ref) hands out manager-owned contexts. `opts` is copied into the
context as the `CFG::BuildOptions` it will build its graph from; without it the context
starts from clang's defaults, which [`getCFGBuildOptions`](@ref) can still edit until the
graph is built.

`d`'s type is the precondition of the whole class: `clang::AnalysisDeclContext::getBody`
switches on the declaration kind and ends in `llvm_unreachable`, so anything but a function,
Objective-C method, block or function template is undefined here rather than empty.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function AnalysisDeclContext(d::AnalyzableDecl)
    @check_ptrs d
    return AnalysisDeclContext(clang_AnalysisDeclContext_create(CXAnalysisDeclContextManager(C_NULL), d))
end

function AnalysisDeclContext(mgr::AbstractAnalysisDeclContextManager, d::AnalyzableDecl)
    @check_ptrs mgr d
    return AnalysisDeclContext(clang_AnalysisDeclContext_create(mgr, d))
end

function AnalysisDeclContext(d::AnalyzableDecl, opts::AbstractCFGBuildOptions)
    @check_ptrs d opts
    return AnalysisDeclContext(clang_AnalysisDeclContext_createWithOptions(CXAnalysisDeclContextManager(C_NULL), d, opts))
end

function AnalysisDeclContext(mgr::AbstractAnalysisDeclContextManager, d::AnalyzableDecl, opts::AbstractCFGBuildOptions)
    @check_ptrs mgr d opts
    return AnalysisDeclContext(clang_AnalysisDeclContext_createWithOptions(mgr, d, opts))
end

dispose(x::AnalysisDeclContext) = clang_AnalysisDeclContext_dispose(x)

function getASTContext(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return ASTContext(clang_AnalysisDeclContext_getASTContext(x))
end

function getDecl(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return Decl(clang_AnalysisDeclContext_getDecl(x))
end

"""
    getManager(x::AbstractAnalysisDeclContext) -> AnalysisDeclContextManager
The manager that owns `x`. The wrapped pointer is NULL for a standalone context.
"""
function getManager(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return AnalysisDeclContextManager(clang_AnalysisDeclContext_getManager(x))
end

"""
    getCFGBuildOptions(x::AbstractAnalysisDeclContext) -> CFGBuildOptions
The options `x` builds its graph from. BORROWED — a member of `x`, so never `dispose` it.
Editing it after [`isCFGBuilt`](@ref) is true changes nothing: the graph is cached.
"""
function getCFGBuildOptions(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return CFGBuildOptions(clang_AnalysisDeclContext_getCFGBuildOptions(x))
end

function getAddEHEdges(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_getAddEHEdges(x)
end

function getUseUnoptimizedCFG(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_getUseUnoptimizedCFG(x)
end

function getAddImplicitDtors(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_getAddImplicitDtors(x)
end

function getAddInitializers(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_getAddInitializers(x)
end

"""
    registerForcedBlockExpression(x::AbstractAnalysisDeclContext, s::AbstractStmt)
Ask the CFG builder to give `s` a block of its own. Only has an effect before the graph is
built; afterwards find the block with [`getBlock`](@ref) on [`getCFGStmtMap`](@ref).
"""
function registerForcedBlockExpression(x::AbstractAnalysisDeclContext, s::AbstractStmt)
    @check_ptrs x s
    return clang_AnalysisDeclContext_registerForcedBlockExpression(x, s)
end

"""
    getBody(x::AbstractAnalysisDeclContext) -> Stmt
The body clang will analyse — the declaration's own, or one the `BodyFarm` synthesized when
the context's manager has body synthesis on. The wrapped pointer is NULL when the
declaration has no body at all.
"""
function getBody(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return Stmt(clang_AnalysisDeclContext_getBody(x, Ptr{Bool}(C_NULL)))
end

"""
    getBodyWithAutosynthesized(x::AbstractAnalysisDeclContext) -> Tuple{Stmt,Bool}
[`getBody`](@ref) plus the `bool &` out-parameter of clang's second overload: whether the
body came from the `BodyFarm` rather than from source.
"""
function getBodyWithAutosynthesized(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    autosynthesized = Ref{Bool}(false)
    body = clang_AnalysisDeclContext_getBody(x, autosynthesized)
    return Stmt(body), autosynthesized[]
end

function isBodyAutosynthesized(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_isBodyAutosynthesized(x)
end

function isBodyAutosynthesizedFromModelFile(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_isBodyAutosynthesizedFromModelFile(x)
end

"""
    getCFG(x::AbstractAnalysisDeclContext) -> CFG
The declaration's control-flow graph, built on the first call from
[`getCFGBuildOptions`](@ref) and cached. BORROWED — owned by `x`, so never `dispose` it. The
wrapped pointer is NULL when the declaration has no body or clang cannot build a graph for
it.
"""
function getCFG(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return CFG(clang_AnalysisDeclContext_getCFG(x))
end

"""
    getCFGStmtMap(x::AbstractAnalysisDeclContext) -> CFGStmtMap
The `Stmt` -> `CFGBlock` map over [`getCFG`](@ref). BORROWED; the wrapped pointer is NULL
exactly when `getCFG`'s is.
"""
function getCFGStmtMap(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return CFGStmtMap(clang_AnalysisDeclContext_getCFGStmtMap(x))
end

"""
    getCFGReachablityAnalysis(x::AbstractAnalysisDeclContext) -> CFGReverseBlockReachabilityAnalysis
Block-to-block reachability over [`getCFG`](@ref). BORROWED — owned by `x`, so never
`dispose` it, unlike one built by
[`CFGReverseBlockReachabilityAnalysis`](@ref). The wrapped pointer is NULL exactly when
`getCFG`'s is.
"""
function getCFGReachablityAnalysis(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return CFGReverseBlockReachabilityAnalysis(clang_AnalysisDeclContext_getCFGReachablityAnalysis(x))
end

"""
    getUnoptimizedCFG(x::AbstractAnalysisDeclContext) -> CFG
A second graph of the same body with `PruneTriviallyFalseEdges` off, so the never-taken arm
of a constant-conditioned branch survives. Cached separately from [`getCFG`](@ref)'s and
BORROWED just like it.
"""
function getUnoptimizedCFG(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return CFG(clang_AnalysisDeclContext_getUnoptimizedCFG(x))
end

"""
    dumpCFG(x::AbstractAnalysisDeclContext, show_colors::Bool=false)
Print [`getCFG`](@ref) to stderr. `clang::AnalysisDeclContext::dumpCFG` dereferences that
graph with no null check, so the graph has to exist.
"""
function dumpCFG(x::AbstractAnalysisDeclContext, show_colors::Bool=false)
    @check_ptrs x
    @assert !is_null_handle(getCFG(x)) "this AnalysisDeclContext has no CFG to dump"
    return clang_AnalysisDeclContext_dumpCFG(x, show_colors)
end

"""
    isCFGBuilt(x::AbstractAnalysisDeclContext) -> Bool
Whether building the CFG has been *attempted*, which is not the same as whether
[`getCFG`](@ref) is non-NULL.
"""
function isCFGBuilt(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_isCFGBuilt(x)
end

"""
    getParentMap(x::AbstractAnalysisDeclContext) -> ParentMap
The parent map of [`getBody`](@ref), built on the first call and cached. BORROWED — owned by
`x`, so never `dispose` it. A `clang::ParentMap` built over a null body holds a null map that
every one of its accessors dereferences, so a body is required here.
"""
function getParentMap(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    @assert !is_null_handle(getBody(x)) "this AnalysisDeclContext has no body to map"
    return ParentMap(clang_AnalysisDeclContext_getParentMap(x))
end

function getNumReferencedBlockVars(x::AbstractAnalysisDeclContext, bd::AbstractBlockDecl)
    @check_ptrs x bd
    return clang_AnalysisDeclContext_getNumReferencedBlockVars(x, bd)
end

"""
    getReferencedBlockVars(x::AbstractAnalysisDeclContext, bd::AbstractBlockDecl) -> Vector{VarDecl}
The enclosing-scope variables the block `bd` refers to, computed and cached by `x`.
"""
function getReferencedBlockVars(x::AbstractAnalysisDeclContext, bd::AbstractBlockDecl)
    @check_ptrs x bd
    n = Int(getNumReferencedBlockVars(x, bd))
    buf = Vector{CXVarDecl}(undef, n)
    n > 0 && clang_AnalysisDeclContext_getReferencedBlockVars(x, bd, buf, n)
    return VarDecl[VarDecl(p) for p in buf]
end

"""
    getSelfDecl(x::AbstractAnalysisDeclContext) -> ImplicitParamDecl
The `self` parameter of an Objective-C method, or the captured `self` of a block. The
wrapped pointer is NULL for anything else.
"""
function getSelfDecl(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return ImplicitParamDecl(clang_AnalysisDeclContext_getSelfDecl(x))
end

"""
    isInStdNamespace(x::AbstractAnalysisDeclContext) -> Bool
Whether the *root* namespace of `x`'s declaration is `std` — clang's static
`AnalysisDeclContext::isInStdNamespace`, which walks out through nested namespaces and so
answers true for `std::__1::f` where [`isInStdNamespace(::AbstractDecl)`](@ref) (which is
`clang::Decl::isInStdNamespace`, a single check of the immediate context) answers false.
The static takes a bare `Decl`, but that spelling is already the other predicate's, so the
context carries the dispatch here and its own declaration is what is tested.
"""
function isInStdNamespace(x::AbstractAnalysisDeclContext)
    @check_ptrs x
    return clang_AnalysisDeclContext_isInStdNamespace(getDecl(x))
end

"""
    getFunctionName(x::AbstractDecl) -> String
The qualified, parameterized name clang's analysis diagnostics print for `x` — the static
`AnalysisDeclContext::getFunctionName`. Empty for a declaration that names no function.
"""
function getFunctionName(x::AbstractDecl)
    @check_ptrs x
    return get_string(clang_AnalysisDeclContext_getFunctionName(x))
end

# AnalysisDeclContextManager
"""
    AnalysisDeclContextManager(ctx::AbstractASTContext, synthesize_bodies::Bool=false) -> AnalysisDeclContextManager
A cache of one [`AnalysisDeclContext`](@ref) per declaration. The thirteen CFG-building
flags of clang's constructor are not arguments: every one of them lands in the manager's own
`CFG::BuildOptions`, which [`getCFGBuildOptions`](@ref) hands back mutable, so the manager
starts from clang's defaults (`PruneTriviallyFalseEdges`, `AddCXXNewAllocator`,
`AddRichCXXConstructors`, `MarkElidedCXXConstructors` and `AddVirtualBaseBranches` on, the
rest off) and is tuned through that object before the first [`getContext`](@ref).
`synthesize_bodies` is the one constructor argument that is not a build option and clang
offers no setter for.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function AnalysisDeclContextManager(ctx::AbstractASTContext, synthesize_bodies::Bool=false)
    @check_ptrs ctx
    return AnalysisDeclContextManager(clang_AnalysisDeclContextManager_create(ctx, synthesize_bodies))
end

"""
    dispose(x::AnalysisDeclContextManager)
Release the manager and, with it, every [`AnalysisDeclContext`](@ref) [`getContext`](@ref)
handed out.
"""
dispose(x::AnalysisDeclContextManager) = clang_AnalysisDeclContextManager_dispose(x)

"""
    getContext(x::AbstractAnalysisDeclContextManager, d::AnalyzableDecl) -> AnalysisDeclContext
The context for `d`, created on first request from the manager's build options and cached.
BORROWED — owned by `x`, so never `dispose` it. Two declarations of one function share a
context: clang first redirects to the redeclaration that carries the body.
"""
function getContext(x::AbstractAnalysisDeclContextManager, d::AnalyzableDecl)
    @check_ptrs x d
    return AnalysisDeclContext(clang_AnalysisDeclContextManager_getContext(x, d))
end

function getUseUnoptimizedCFG(x::AbstractAnalysisDeclContextManager)
    @check_ptrs x
    return clang_AnalysisDeclContextManager_getUseUnoptimizedCFG(x)
end

"""
    getCFGBuildOptions(x::AbstractAnalysisDeclContextManager) -> CFGBuildOptions
The options every context this manager creates starts from. BORROWED — a member of `x`, so
never `dispose` it. Contexts already handed out keep the copy they were created with.
"""
function getCFGBuildOptions(x::AbstractAnalysisDeclContextManager)
    @check_ptrs x
    return CFGBuildOptions(clang_AnalysisDeclContextManager_getCFGBuildOptions(x))
end

function synthesizeBodies(x::AbstractAnalysisDeclContextManager)
    @check_ptrs x
    return clang_AnalysisDeclContextManager_synthesizeBodies(x)
end

"""
    clear(x::AbstractAnalysisDeclContextManager)
Discard every cached context. Each [`AnalysisDeclContext`](@ref) [`getContext`](@ref)
returned is dangling afterwards.
"""
function clear(x::AbstractAnalysisDeclContextManager)
    @check_ptrs x
    return clang_AnalysisDeclContextManager_clear(x)
end

# CFGStmtMap
"""
    getBlock(x::AbstractCFGStmtMap, s::AbstractStmt) -> CFGBlock
The block `s` appears in, walking up the parent map when `s` itself is not a block-level
statement. A terminator maps to the block it terminates rather than to the block it is a
block-level expression of, and a `CaseStmt` or `LabelStmt` maps to the block it labels. The
wrapped pointer is NULL when no ancestor of `s` is in the graph.
"""
function getBlock(x::AbstractCFGStmtMap, s::AbstractStmt)
    @check_ptrs x s
    return CFGBlock(clang_CFGStmtMap_getBlock(x, s))
end

# ParentMap
"""
    getParent(x::AbstractParentMap, s::AbstractStmt) -> Stmt
The immediate parent of `s` in the body `x` was built over. The wrapped pointer is NULL for
the root and for any statement the map never saw.
"""
function getParent(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ParentMap_getParent(x, s))
end

"""
    getParentIgnoreParens(x::AbstractParentMap, s::AbstractStmt) -> Stmt
[`getParent`](@ref), skipping over parentheses.
"""
function getParentIgnoreParens(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ParentMap_getParentIgnoreParens(x, s))
end

"""
    getParentIgnoreParenCasts(x::AbstractParentMap, s::AbstractStmt) -> Stmt
[`getParent`](@ref), skipping over parentheses and casts.
"""
function getParentIgnoreParenCasts(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ParentMap_getParentIgnoreParenCasts(x, s))
end

"""
    getParentIgnoreParenImpCasts(x::AbstractParentMap, s::AbstractStmt) -> Stmt
[`getParent`](@ref), skipping over parentheses and implicit casts.
"""
function getParentIgnoreParenImpCasts(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ParentMap_getParentIgnoreParenImpCasts(x, s))
end

"""
    getOuterParenParent(x::AbstractParentMap, s::AbstractStmt) -> Stmt
The outermost `ParenExpr` of the parenthesis chain `s` sits in. The wrapped pointer is NULL
when no parentheses enclose `s`.
"""
function getOuterParenParent(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ParentMap_getOuterParenParent(x, s))
end

function hasParent(x::AbstractParentMap, s::AbstractStmt)
    @check_ptrs x s
    return clang_ParentMap_hasParent(x, s)
end

"""
    isConsumedExpr(x::AbstractParentMap, e::AbstractExpr) -> Bool
Whether `e`'s value is used by its parent rather than discarded.
"""
function isConsumedExpr(x::AbstractParentMap, e::AbstractExpr)
    @check_ptrs x e
    return clang_ParentMap_isConsumedExpr(x, e)
end
