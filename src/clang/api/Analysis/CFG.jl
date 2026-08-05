# CFG — source-level control-flow graphs (clang/Analysis/CFG.h).
# The CFG returned by `buildCFG` is caller-owned; every `CFGBlock` handle is
# interior to its parent `CFG` and is invalidated when the CFG is disposed.
"""
    buildCFG(decl::AbstractDecl, stmt::AbstractStmt, ctx::ASTContext,
             AddInitializers=false, AddImplicitDtors=false, AddLifetime=false,
             AddLoopExit=false, AddTemporaryDtors=false, AddScopes=false,
             AddCXXNewAllocator=false) -> CFG
Build the source-level control-flow graph of `stmt` (normally the body of `decl`).
The booleans map 1:1 onto the same-named `clang::CFG::BuildOptions` fields; every
other option keeps its default (`PruneTriviallyFalseEdges` stays on). The wrapped
pointer is NULL when clang cannot build a CFG for the input. This function
allocates and one should call `dispose` to release the resources after using this
object.
"""
function buildCFG(decl::AbstractDecl, stmt::AbstractStmt, ctx::ASTContext,
                  AddInitializers::Bool=false, AddImplicitDtors::Bool=false,
                  AddLifetime::Bool=false, AddLoopExit::Bool=false,
                  AddTemporaryDtors::Bool=false, AddScopes::Bool=false,
                  AddCXXNewAllocator::Bool=false)
    @check_ptrs decl stmt ctx
    return CFG(clang_CFG_buildCFG(decl, stmt, ctx, AddInitializers, AddImplicitDtors,
                                  AddLifetime, AddLoopExit, AddTemporaryDtors,
                                  AddScopes, AddCXXNewAllocator))
end

dispose(x::CFG) = clang_CFG_dispose(x)

function getNumBlocks(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumBlocks(x)
end

"""
    getBlock(x::AbstractCFG, i::Integer) -> CFGBlock
Return the `i`-th block of the graph (0-based, `i < getNumBlocks(x)`).
"""
function getBlock(x::AbstractCFG, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumBlocks(x) "block index $i out of range"
    return CFGBlock(clang_CFG_getBlock(x, i))
end

function getEntry(x::AbstractCFG)
    @check_ptrs x
    return CFGBlock(clang_CFG_getEntry(x))
end

function getExit(x::AbstractCFG)
    @check_ptrs x
    return CFGBlock(clang_CFG_getExit(x))
end

# The wrapped pointer is NULL when the function contains no indirect goto.
function getIndirectGotoBlock(x::AbstractCFG)
    @check_ptrs x
    return CFGBlock(clang_CFG_getIndirectGotoBlock(x))
end

function getNumBlockIDs(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumBlockIDs(x)
end

function isLinear(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_isLinear(x)
end

function printAsString(x::AbstractCFG, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_CFG_printAsString(x, ctx))
end

# CFGBlock
function getIndexInCFG(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_getIndexInCFG(x)
end

# Number of `CFGElement`s in the block.
function Base.size(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_size(x)
end

# Indexed CFGElement access (0-based, in execution order). The element is a
# two-word value type decomposed into the kind below plus per-kind payload
# accessors; a payload accessor returns a NULL-pointer carrier unless the
# element is of the kind(s) it names.
function getElementKind(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return clang_CFGBlock_getElementKind(x, i)
end

"""
    getElementStmt(x::AbstractCFGBlock, i::Integer) -> Stmt
Return the top-level statement of the `i`-th element. The wrapped pointer is NULL
unless the element kind is in the statement family (`Statement`, `Constructor`,
`CXXRecordTypedCall`); `resolve` the base `Stmt` to refine it.
"""
function getElementStmt(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return Stmt(clang_CFGBlock_getElementStmt(x, i))
end

# Initializer elements — the wrapped pointer is NULL for any other kind.
function getElementInitializer(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXCtorInitializer(clang_CFGBlock_getElementInitializer(x, i))
end

# ScopeBegin/ScopeEnd/LifetimeEnds/AutomaticObjectDtor/CleanupFunction elements —
# the wrapped pointer is NULL for any other kind.
function getElementVarDecl(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return VarDecl(clang_CFGBlock_getElementVarDecl(x, i))
end

# ScopeBegin/ScopeEnd/LifetimeEnds/AutomaticObjectDtor elements — the wrapped
# pointer is NULL for any other kind.
function getElementTriggerStmt(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return Stmt(clang_CFGBlock_getElementTriggerStmt(x, i))
end

# LoopExit elements — the wrapped pointer is NULL for any other kind.
function getElementLoopStmt(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return Stmt(clang_CFGBlock_getElementLoopStmt(x, i))
end

# TemporaryDtor elements — the wrapped pointer is NULL for any other kind.
function getElementBindTemporaryExpr(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXBindTemporaryExpr(clang_CFGBlock_getElementBindTemporaryExpr(x, i))
end

# BaseDtor elements — the wrapped pointer is NULL for any other kind.
function getElementBaseSpecifier(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXBaseSpecifier(clang_CFGBlock_getElementBaseSpecifier(x, i))
end

# MemberDtor elements — the wrapped pointer is NULL for any other kind.
function getElementFieldDecl(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return FieldDecl(clang_CFGBlock_getElementFieldDecl(x, i))
end

# NewAllocator elements — the wrapped pointer is NULL for any other kind.
function getElementAllocatorExpr(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXNewExpr(clang_CFGBlock_getElementAllocatorExpr(x, i))
end

function printElementAsString(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return get_string(clang_CFGBlock_printElementAsString(x, i))
end

function succ_size(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_succ_size(x)
end

"""
    getSucc(x::AbstractCFGBlock, i::Integer) -> CFGBlock
Return the `i`-th successor (0-based; successor order is terminator-specific).
The wrapped pointer is NULL for an optimized-out/unreachable edge — see
`isSuccReachable` and `getSuccPossiblyUnreachableBlock`.
"""
function getSucc(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < succ_size(x) "successor index $i out of range"
    return CFGBlock(clang_CFGBlock_getSucc(x, i))
end

function isSuccReachable(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < succ_size(x) "successor index $i out of range"
    return clang_CFGBlock_isSuccReachable(x, i)
end

# The alternate (possibly unreachable) block of the `i`-th successor edge; the
# wrapped pointer is NULL for a plain reachable edge.
function getSuccPossiblyUnreachableBlock(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < succ_size(x) "successor index $i out of range"
    return CFGBlock(clang_CFGBlock_getSuccPossiblyUnreachableBlock(x, i))
end

function pred_size(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_pred_size(x)
end

# The `i`-th predecessor (0-based; order is arbitrary); the wrapped pointer is
# NULL for an unreachable edge.
function getPred(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < pred_size(x) "predecessor index $i out of range"
    return CFGBlock(clang_CFGBlock_getPred(x, i))
end

function isInevitablySinking(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_isInevitablySinking(x)
end

# The CFGTerminator value type is decomposed into `hasTerminator`,
# `getTerminatorKind`, and `getTerminatorStmt`.
function hasTerminator(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_hasTerminator(x)
end

function getTerminatorKind(x::AbstractCFGBlock)
    @check_ptrs x
    @assert hasTerminator(x) "block has no terminator"
    return clang_CFGBlock_getTerminatorKind(x)
end

# The wrapped pointer is NULL when the block has no terminator.
function getTerminatorStmt(x::AbstractCFGBlock)
    @check_ptrs x
    return Stmt(clang_CFGBlock_getTerminatorStmt(x))
end

# The wrapped pointer is NULL when the block has no branch condition.
function getLastCondition(x::AbstractCFGBlock)
    @check_ptrs x
    return Expr_(clang_CFGBlock_getLastCondition(x))
end

# The wrapped pointer is NULL when the block has no terminator condition.
function getTerminatorCondition(x::AbstractCFGBlock, strip_parens::Bool=true)
    @check_ptrs x
    return Stmt(clang_CFGBlock_getTerminatorCondition(x, strip_parens))
end

# The wrapped pointer is NULL unless the block is a loop-edge block.
function getLoopTarget(x::AbstractCFGBlock)
    @check_ptrs x
    return Stmt(clang_CFGBlock_getLoopTarget(x))
end

# The wrapped pointer is NULL when the block has no label.
function getLabel(x::AbstractCFGBlock)
    @check_ptrs x
    return Stmt(clang_CFGBlock_getLabel(x))
end

function hasNoReturnElement(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_hasNoReturnElement(x)
end

function getBlockID(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_getBlockID(x)
end

"""
    getParent(x::AbstractCFGBlock) -> CFG
Return the `CFG` that owns this block. The result is BORROWED — never `dispose`
it.
"""
function getParent(x::AbstractCFGBlock)
    @check_ptrs x
    return CFG(clang_CFGBlock_getParent(x))
end

function printAsString(x::AbstractCFGBlock, cfg::AbstractCFG, ctx::ASTContext)
    @check_ptrs x cfg ctx
    return get_string(clang_CFGBlock_printAsString(x, cfg, ctx))
end


# Try-dispatch blocks (count+index; the list is a random-access vector).
function getNumTryBlocks(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumTryBlocks(x)
end

"""
    getTryBlock(x::AbstractCFG, i::Integer) -> CFGBlock
Return the `i`-th try-dispatch block (0-based, `i < getNumTryBlocks(x)`).
"""
function getTryBlock(x::AbstractCFG, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTryBlocks(x) "try-block index $i out of range"
    return CFGBlock(clang_CFG_getTryBlock(x, i))
end

# Synthetic-DeclStmt map. `clang::CFG` stores it in a `DenseMap`, whose iteration
# order is not stable, so it is exposed as a size plus a by-key lookup instead of
# an index accessor.
function getNumSyntheticDeclStmts(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumSyntheticDeclStmts(x)
end

"""
    getSyntheticDeclStmtSource(x::AbstractCFG, synthetic::AbstractDeclStmt) -> DeclStmt
Return the source `DeclStmt` that `synthetic` was synthesized from. The wrapped
pointer is NULL when `synthetic` is not a synthetic statement of this graph.
"""
function getSyntheticDeclStmtSource(x::AbstractCFG, synthetic::AbstractDeclStmt)
    @check_ptrs x synthetic
    return DeclStmt(clang_CFG_getSyntheticDeclStmtSource(x, synthetic))
end

# Whether the block holds no `CFGElement`s.
function Base.isempty(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_empty(x)
end

# DeleteDtor elements — the wrapped pointer is NULL for any other kind.
function getElementDeleteExpr(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXDeleteExpr(clang_CFGBlock_getElementDeleteExpr(x, i))
end

# DeleteDtor elements — the destroyed record; NULL for any other kind.
function getElementCXXRecordDecl(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXRecordDecl(clang_CFGBlock_getElementCXXRecordDecl(x, i))
end

# CleanupFunction elements — the function named by the variable's `cleanup`
# attribute; NULL for any other kind. `clang::CFGCleanupFunction::getFunctionDecl`
# dereferences that attribute unchecked, but the element kind is the precondition
# and the C shim tests it before calling, so this wrapper is total.
function getElementCleanupFunctionDecl(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return FunctionDecl(clang_CFGBlock_getElementCleanupFunctionDecl(x, i))
end

"""
    getElementDestructorDecl(x::AbstractCFGBlock, i::Integer, ctx::ASTContext) -> CXXDestructorDecl
Return the destructor run by the `i`-th element. `clang::CFGImplicitDtor::getDestructorDecl`
is defined only for the dtor-family kinds (`AutomaticObjectDtor`, `DeleteDtor`,
`BaseDtor`, `MemberDtor`, `TemporaryDtor`) — the C shim tests the kind first, so the
wrapped pointer is NULL for every other kind (and for a type with no declared
destructor).
"""
function getElementDestructorDecl(x::AbstractCFGBlock, i::Integer, ctx::ASTContext)
    @check_ptrs x ctx
    @assert 0 <= i < size(x) "element index $i out of range"
    return CXXDestructorDecl(clang_CFGBlock_getElementDestructorDecl(x, i, ctx))
end

function succ_empty(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_succ_empty(x)
end

function pred_empty(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_pred_empty(x)
end

function isPredReachable(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < pred_size(x) "predecessor index $i out of range"
    return clang_CFGBlock_isPredReachable(x, i)
end

# The alternate (possibly unreachable) block of the `i`-th predecessor edge; the
# wrapped pointer is NULL for a plain reachable edge.
function getPredPossiblyUnreachableBlock(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < pred_size(x) "predecessor index $i out of range"
    return CFGBlock(clang_CFGBlock_getPredPossiblyUnreachableBlock(x, i))
end

"""
    FilterEdge(src::AbstractCFGBlock, dst::AbstractCFGBlock, IgnoreNullPredecessors=true,
               IgnoreDefaultsWithCoveredEnums=false) -> Bool
Whether the static `clang::CFGBlock::FilterEdge` would drop the `src` -> `dst` edge.
The two booleans are the fields of `clang::CFGBlock::FilterOptions`; the defaults are
Clang's.
"""
function FilterEdge(src::AbstractCFGBlock, dst::AbstractCFGBlock,
                    IgnoreNullPredecessors::Bool=true,
                    IgnoreDefaultsWithCoveredEnums::Bool=false)
    @check_ptrs src dst
    return clang_CFGBlock_FilterEdge(IgnoreNullPredecessors,
                                     IgnoreDefaultsWithCoveredEnums, src, dst)
end

function printTerminatorAsString(x::AbstractCFGBlock, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_CFGBlock_printTerminatorAsString(x, ctx))
end

function printTerminatorJsonAsString(x::AbstractCFGBlock, ctx::ASTContext,
                                     AddQuotes::Bool=false)
    @check_ptrs x ctx
    return get_string(clang_CFGBlock_printTerminatorJsonAsString(x, ctx, AddQuotes))
end


# Mutation of a block's contents. Every `clang::CFGBlock` append/`addSuccessor`
# method takes the owning CFG's `BumpVectorContext` — elements and edges are
# allocated from the CFG's arena — and the C shim reads it from the block's parent
# instead of taking it as a parameter, so a block can never be grown out of a
# foreign arena. The element list is stored in reverse, so an appended element
# becomes index 0 and every element already in the block shifts up by one.

"""
    setTerminator(x::AbstractCFGBlock, s::AbstractStmt, kind=CXCFGTerminatorKind_StmtBranch)
Set the block's terminator. `clang::CFGTerminator` is a value type; it is flattened into
its two constructor arguments, the branch statement and its kind.
"""
function setTerminator(x::AbstractCFGBlock, s::AbstractStmt,
                       kind::CXCFGTerminatorKind=CXCFGTerminatorKind_StmtBranch)
    @check_ptrs x s
    return clang_CFGBlock_setTerminator(x, s, kind)
end

"""
    setLabel(x::AbstractCFGBlock, s::AbstractStmt)
Set the label that prefixes the block's executable statements. Clang expects a
`LabelStmt`, `SwitchCase` or `CXXCatchStmt` here; nothing checks it.
"""
function setLabel(x::AbstractCFGBlock, s::AbstractStmt)
    @check_ptrs x s
    return clang_CFGBlock_setLabel(x, s)
end

function setLoopTarget(x::AbstractCFGBlock, s::AbstractStmt)
    @check_ptrs x s
    return clang_CFGBlock_setLoopTarget(x, s)
end

function setHasNoReturnElement(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_setHasNoReturnElement(x)
end

"""
    addSuccessor(x::AbstractCFGBlock, succ::AbstractCFGBlock, IsReachable::Bool=true)
Add `succ` as a successor of `x`, and `x` as a predecessor of `succ`.
`clang::CFGBlock::AdjacentBlock` is a value type; it is flattened into the block plus its
reachability flag. An unreachable edge reads back through
`getSuccPossiblyUnreachableBlock`, with a NULL `getSucc`.
"""
function addSuccessor(x::AbstractCFGBlock, succ::AbstractCFGBlock, IsReachable::Bool=true)
    @check_ptrs x succ
    return clang_CFGBlock_addSuccessor(x, succ, IsReachable)
end

function appendStmt(x::AbstractCFGBlock, s::AbstractStmt)
    @check_ptrs x s
    return clang_CFGBlock_appendStmt(x, s)
end

function appendInitializer(x::AbstractCFGBlock, init::AbstractCXXCtorInitializer)
    @check_ptrs x init
    return clang_CFGBlock_appendInitializer(x, init)
end

function appendScopeBegin(x::AbstractCFGBlock, vd::AbstractVarDecl, s::AbstractStmt)
    @check_ptrs x vd s
    return clang_CFGBlock_appendScopeBegin(x, vd, s)
end

function appendScopeEnd(x::AbstractCFGBlock, vd::AbstractVarDecl, s::AbstractStmt)
    @check_ptrs x vd s
    return clang_CFGBlock_appendScopeEnd(x, vd, s)
end

function appendBaseDtor(x::AbstractCFGBlock, bs::AbstractCXXBaseSpecifier)
    @check_ptrs x bs
    return clang_CFGBlock_appendBaseDtor(x, bs)
end

function appendMemberDtor(x::AbstractCFGBlock, fd::AbstractFieldDecl)
    @check_ptrs x fd
    return clang_CFGBlock_appendMemberDtor(x, fd)
end

function appendTemporaryDtor(x::AbstractCFGBlock, e::AbstractCXXBindTemporaryExpr)
    @check_ptrs x e
    return clang_CFGBlock_appendTemporaryDtor(x, e)
end

function appendAutomaticObjDtor(x::AbstractCFGBlock, vd::AbstractVarDecl, s::AbstractStmt)
    @check_ptrs x vd s
    return clang_CFGBlock_appendAutomaticObjDtor(x, vd, s)
end

function appendLifetimeEnds(x::AbstractCFGBlock, vd::AbstractVarDecl, s::AbstractStmt)
    @check_ptrs x vd s
    return clang_CFGBlock_appendLifetimeEnds(x, vd, s)
end

function appendLoopExit(x::AbstractCFGBlock, loop_stmt::AbstractStmt)
    @check_ptrs x loop_stmt
    return clang_CFGBlock_appendLoopExit(x, loop_stmt)
end

"""
    createBlock(x::AbstractCFG) -> CFGBlock
Create a new empty block owned by `x`. The block is interior to the graph — it is
released when the CFG is disposed and is never disposed on its own.
"""
function createBlock(x::AbstractCFG)
    @check_ptrs x
    return CFGBlock(clang_CFG_createBlock(x))
end

function setEntry(x::AbstractCFG, b::AbstractCFGBlock)
    @check_ptrs x b
    return clang_CFG_setEntry(x, b)
end

function setIndirectGotoBlock(x::AbstractCFG, b::AbstractCFGBlock)
    @check_ptrs x b
    return clang_CFG_setIndirectGotoBlock(x, b)
end

function addTryDispatchBlock(x::AbstractCFG, b::AbstractCFGBlock)
    @check_ptrs x b
    return clang_CFG_addTryDispatchBlock(x, b)
end

"""
    addSyntheticDeclStmt(x::AbstractCFG, synthetic::AbstractDeclStmt, source::AbstractDeclStmt)
Record `synthetic` as a synthesized single-declaration `DeclStmt` split out of `source`.
`clang::CFG::addSyntheticDeclStmt` asserts all three preconditions restated below
(Invariant 3); the mapping reads back through `getSyntheticDeclStmtSource`.
"""
function addSyntheticDeclStmt(x::AbstractCFG, synthetic::AbstractDeclStmt,
                              source::AbstractDeclStmt)
    @check_ptrs x synthetic source
    @assert isSingleDecl(synthetic) "the synthetic DeclStmt must hold a single decl"
    @assert synthetic.ptr != source.ptr "the synthetic and source DeclStmts must differ"
    @assert getSyntheticDeclStmtSource(x, synthetic).ptr == C_NULL "already recorded"
    return clang_CFG_addSyntheticDeclStmt(x, synthetic, source)
end


function appendNewAllocator(x::AbstractCFGBlock, ne::AbstractCXXNewExpr)
    @check_ptrs x ne
    return clang_CFGBlock_appendNewAllocator(x, ne)
end

function appendDeleteDtor(x::AbstractCFGBlock, rd::AbstractCXXRecordDecl, de::AbstractCXXDeleteExpr)
    @check_ptrs x rd de
    return clang_CFGBlock_appendDeleteDtor(x, rd, de)
end


"""
    isCXXRecordTypedCall(x::AbstractExpr) -> Bool
Whether a `CFG` models the call `x` as a `CXXRecordTypedCall` element instead of a plain
`Statement` element — true exactly when the call is a prvalue of class type. PARTIAL:
`clang::CFGCXXRecordTypedCall::isCXXRecordTypedCall` asserts its argument is a `CallExpr`
or an `ObjCMessageExpr` (Invariant 3), so `resolve` the expression before calling.
"""
function isCXXRecordTypedCall(x::AbstractExpr)
    @check_ptrs x
    @assert x isa AbstractCallExpr || x isa AbstractObjCMessageExpr "expression must be a CallExpr or ObjCMessageExpr"
    return clang_CFGCXXRecordTypedCall_isCXXRecordTypedCall(x)
end

"""
    isTerminatorStmtBranch(x::AbstractCFGBlock) -> Bool
`clang::CFGTerminator::isStmtBranch` for the block's terminator. The absent terminator is
an empty `PointerIntPair` whose kind reads back as `StmtBranch`, so this is also true when
`hasTerminator` is false — pair the two.
"""
function isTerminatorStmtBranch(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_isTerminatorStmtBranch(x)
end

function isTerminatorTemporaryDtorsBranch(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_isTerminatorTemporaryDtorsBranch(x)
end

function isTerminatorVirtualBaseBranch(x::AbstractCFGBlock)
    @check_ptrs x
    return clang_CFGBlock_isTerminatorVirtualBaseBranch(x)
end

"""
    printAsOperandAsString(x::AbstractCFGBlock) -> String
`clang::CFGBlock::printAsOperand` rendered into a `String`: the LLVM-style operand label
`"BB#<block id>"`.
"""
function printAsOperandAsString(x::AbstractCFGBlock)
    @check_ptrs x
    return get_string(clang_CFGBlock_printAsOperandAsString(x))
end

"""
    appendCleanupFunction(x::AbstractCFGBlock, vd::AbstractVarDecl)
Append a `CleanupFunction` element for `vd` to `x`. PARTIAL: `clang::CFGCleanupFunction`'s
constructor asserts `vd` carries a `cleanup` attribute, and
`getElementCleanupFunctionDecl` then dereferences that attribute with no null check; the
assertion below restates the precondition.
"""
function appendCleanupFunction(x::AbstractCFGBlock, vd::AbstractVarDecl)
    @check_ptrs x vd
    @assert hasAttrOfKind(vd, CXAttrKind_Cleanup) "the variable must carry a cleanup attribute"
    return clang_CFGBlock_appendCleanupFunction(x, vd)
end


# CFG::BuildOptions — the stateful half of clang::CFG::BuildOptions. The option booleans
# stay flattened into `buildCFGWithOptions` (identical to `buildCFG`'s); this object carries
# only the per-Stmt-class `alwaysAdd` mask, which is a bitset and cannot be flattened.
CFGBuildOptions() = CFGBuildOptions(create_cfg_build_options())

"""
    create_cfg_build_options() -> CXCFGBuildOptions
Return a pointer to a `clang::CFG::BuildOptions` object.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function create_cfg_build_options()
    opts = clang_CFGBuildOptions_create()
    @assert opts != C_NULL "Failed to create CFG::BuildOptions"
    return opts
end

dispose(x::CFGBuildOptions) = clang_CFGBuildOptions_dispose(x)

"""
    alwaysAdd(x::AbstractCFGBuildOptions, s::AbstractStmt) -> Bool
Whether `s`'s statement class is set in the options' `alwaysAdd` mask — i.e. whether a graph
built with `x` is forced to give statements of that class a CFG element of their own.
"""
function alwaysAdd(x::AbstractCFGBuildOptions, s::AbstractStmt)
    @check_ptrs x s
    return clang_CFGBuildOptions_alwaysAdd(x, s)
end

"""
    setAlwaysAdd(x::AbstractCFGBuildOptions, sc::CXStmtClass, val::Bool=true)
Set or clear one statement class in the options' `alwaysAdd` mask. `sc` is typed as the
mirrored enum on purpose: clang indexes an exactly-sized `std::bitset` with it, so an
out-of-range value is undefined behaviour and dispatch is what rules it out.
"""
function setAlwaysAdd(x::AbstractCFGBuildOptions, sc::CXStmtClass, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAlwaysAdd(x, sc, val)
end

"""
    setAllAlwaysAdd(x::AbstractCFGBuildOptions)
Set every statement class in the options' `alwaysAdd` mask.
"""
function setAllAlwaysAdd(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_setAllAlwaysAdd(x)
end

"""
    buildCFGWithOptions(decl::AbstractDecl, stmt::AbstractStmt, ctx::ASTContext,
                        opts::AbstractCFGBuildOptions, AddInitializers=false, ...) -> CFG
`buildCFG` with the `alwaysAdd` mask of `opts` applied on top; the leading arguments and the
trailing booleans mean exactly what they do there. `opts` is only read during the call — the
returned graph keeps no reference to it. The wrapped pointer is NULL when clang cannot build
a CFG for the input. This function allocates and one should call `dispose` to release the
resources after using this object.
"""
function buildCFGWithOptions(decl::AbstractDecl, stmt::AbstractStmt, ctx::ASTContext,
                             opts::AbstractCFGBuildOptions, AddInitializers::Bool=false,
                             AddImplicitDtors::Bool=false, AddLifetime::Bool=false,
                             AddLoopExit::Bool=false, AddTemporaryDtors::Bool=false,
                             AddScopes::Bool=false, AddCXXNewAllocator::Bool=false)
    @check_ptrs decl stmt ctx opts
    return CFG(clang_CFG_buildCFGWithOptions(decl, stmt, ctx, opts, AddInitializers,
                                             AddImplicitDtors, AddLifetime, AddLoopExit,
                                             AddTemporaryDtors, AddScopes,
                                             AddCXXNewAllocator))
end

"""
    front(x::AbstractCFG) -> CFGBlock
Return the first entry of the graph's block list — the same block as `getBlock(x, 0)`.
PARTIAL: `clang::CFG::front` dereferences that entry with no emptiness check, so the
assertion below restates the precondition.
"""
function front(x::AbstractCFG)
    @check_ptrs x
    @assert getNumBlocks(x) > 0 "the graph must contain at least one block"
    return CFGBlock(clang_CFG_front(x))
end

"""
    back(x::AbstractCFG) -> CFGBlock
Return the last entry of the graph's block list — the same block as
`getBlock(x, getNumBlocks(x) - 1)`. PARTIAL: `clang::CFG::back` dereferences that entry with
no emptiness check, so the assertion below restates the precondition.
"""
function back(x::AbstractCFG)
    @check_ptrs x
    @assert getNumBlocks(x) > 0 "the graph must contain at least one block"
    return CFGBlock(clang_CFG_back(x))
end

"""
    getNumFilteredSuccs(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                        IgnoreDefaultsWithCoveredEnums::Bool=false) -> Cuint
Number of successor edges of `x` that survive `clang::CFGBlock::FilterEdge`. The two
booleans are `clang::CFGBlock::FilterOptions` flattened, and default to the values clang's
own `FilterOptions` constructor installs.
"""
function getNumFilteredSuccs(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                             IgnoreDefaultsWithCoveredEnums::Bool=false)
    @check_ptrs x
    return clang_CFGBlock_getNumFilteredSuccs(x, IgnoreNullPredecessors,
                                              IgnoreDefaultsWithCoveredEnums)
end

"""
    getFilteredSuccs(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                     IgnoreDefaultsWithCoveredEnums::Bool=false) -> Vector{CFGBlock}
The successors of `x` that survive `clang::CFGBlock::FilterEdge`, in successor order — the
`clang::CFGBlock::filtered_succ_start_end` walk. A carrier is NULL-pointered when the
surviving edge has no reachable block.
"""
function getFilteredSuccs(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                          IgnoreDefaultsWithCoveredEnums::Bool=false)
    @check_ptrs x
    n = getNumFilteredSuccs(x, IgnoreNullPredecessors, IgnoreDefaultsWithCoveredEnums)
    buf = Vector{CXCFGBlock}(undef, n)
    n > 0 && clang_CFGBlock_getFilteredSuccs(x, IgnoreNullPredecessors,
                                             IgnoreDefaultsWithCoveredEnums, buf, n)
    return [CFGBlock(p) for p in buf]
end

"""
    getNumFilteredPreds(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                        IgnoreDefaultsWithCoveredEnums::Bool=false) -> Cuint
Number of predecessor edges of `x` that survive `clang::CFGBlock::FilterEdge`. The two
booleans are `clang::CFGBlock::FilterOptions` flattened, and default to the values clang's
own `FilterOptions` constructor installs — with `IgnoreNullPredecessors` on, an edge whose
predecessor has no reachable block is dropped.
"""
function getNumFilteredPreds(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                             IgnoreDefaultsWithCoveredEnums::Bool=false)
    @check_ptrs x
    return clang_CFGBlock_getNumFilteredPreds(x, IgnoreNullPredecessors,
                                              IgnoreDefaultsWithCoveredEnums)
end

"""
    getFilteredPreds(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                     IgnoreDefaultsWithCoveredEnums::Bool=false) -> Vector{CFGBlock}
The predecessors of `x` that survive `clang::CFGBlock::FilterEdge`, in predecessor order —
the `clang::CFGBlock::filtered_pred_start_end` walk. A carrier is NULL-pointered when the
surviving edge has no reachable block.
"""
function getFilteredPreds(x::AbstractCFGBlock, IgnoreNullPredecessors::Bool=true,
                          IgnoreDefaultsWithCoveredEnums::Bool=false)
    @check_ptrs x
    n = getNumFilteredPreds(x, IgnoreNullPredecessors, IgnoreDefaultsWithCoveredEnums)
    buf = Vector{CXCFGBlock}(undef, n)
    n > 0 && clang_CFGBlock_getFilteredPreds(x, IgnoreNullPredecessors,
                                             IgnoreDefaultsWithCoveredEnums, buf, n)
    return [CFGBlock(p) for p in buf]
end


"""
    getElementConstructionContext(x::AbstractCFGBlock, i::Integer) -> ConstructionContext
Return the construction context of the `i`-th element — where the object it builds is
going to live. The wrapped pointer is NULL unless the element kind is `Constructor` or
`CXXRecordTypedCall`, and clang's builder emits those two kinds only for a graph built
through `buildCFGWithOptions` with `setAddRichCXXConstructors(opts)` applied. The
context is borrowed from the graph's arena and dies with it.
"""
function getElementConstructionContext(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return ConstructionContext(clang_CFGBlock_getElementConstructionContext(x, i))
end

"""
    appendConstructor(x::AbstractCFGBlock, ce::AbstractCXXConstructExpr,
                      cc::AbstractConstructionContext)
Append a `Constructor` element to the block. The `BumpVectorContext` is taken from the
block's parent graph, so an element can never be allocated out of a foreign arena. The
element list is stored in reverse: the appended element becomes index 0 and everything
already in the block shifts up by one.
"""
function appendConstructor(x::AbstractCFGBlock, ce::AbstractCXXConstructExpr,
                           cc::AbstractConstructionContext)
    @check_ptrs x ce cc
    return clang_CFGBlock_appendConstructor(x, ce, cc)
end

"""
    appendCXXRecordTypedCall(x::AbstractCFGBlock, e::AbstractExpr,
                             cc::AbstractConstructionContext)
Append a `CXXRecordTypedCall` element to the block. PARTIAL: clang's
`CFGCXXRecordTypedCall` constructor asserts that `e` is a call the CFG models as such
(`isCXXRecordTypedCall`) and that `cc` is of any kind other than
`NewAllocatedObjectKind` (Invariant 3); both are restated here. As with
`appendConstructor`, the appended element becomes index 0.
"""
function appendCXXRecordTypedCall(x::AbstractCFGBlock, e::AbstractExpr,
                                  cc::AbstractConstructionContext)
    @check_ptrs x e cc
    @assert isCXXRecordTypedCall(e) "expression must be a call the CFG models as a CXXRecordTypedCall"
    k = getKind(cc)
    @assert k != CXConstructionContextKind_NewAllocatedObjectKind "context kind must not be NewAllocatedObject"
    return clang_CFGBlock_appendCXXRecordTypedCall(x, e, cc)
end

"""
    setAddRichCXXConstructors(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddRichCXXConstructors` build option (clang's default is `false`). It is what
makes the builder emit `Constructor` / `CXXRecordTypedCall` elements with a
construction context attached, so `getElementConstructionContext` is only ever non-NULL
on a graph built with it on.
"""
function setAddRichCXXConstructors(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddRichCXXConstructors(x, val)
end

"""
    setMarkElidedCXXConstructors(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `MarkElidedCXXConstructors` build option (clang's default is `false`), which
makes the builder record the elided-copy flavour of a construction context
(`CXX17ElidedCopy*Kind`, `ElidedTemporaryObjectKind`) instead of the plain one.
"""
function setMarkElidedCXXConstructors(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setMarkElidedCXXConstructors(x, val)
end


"""
    getSyntheticDeclStmts(x::AbstractCFG) -> Vector{Pair{DeclStmt,DeclStmt}}
The whole synthetic-`DeclStmt` map of the graph as `synthetic => source` pairs — the
`clang::CFG::synthetic_stmts` range. The map is an `llvm::DenseMap`, so the order of the
returned pairs is unspecified and must not be relied on; only the pairing itself is
meaningful. `getSyntheticDeclStmtSource` stays the path for looking one key up.
"""
function getSyntheticDeclStmts(x::AbstractCFG)
    @check_ptrs x
    n = Int(getNumSyntheticDeclStmts(x))
    synthetic = Vector{CXDeclStmt}(undef, n)
    source = Vector{CXDeclStmt}(undef, n)
    n > 0 && clang_CFG_getSyntheticDeclStmts(x, synthetic, source, n)
    out = Vector{Pair{DeclStmt,DeclStmt}}(undef, n)
    for i in 1:n
        out[i] = DeclStmt(synthetic[i]) => DeclStmt(source[i])
    end
    return out
end

"""
    getPruneTriviallyFalseEdges(x::AbstractCFGBuildOptions) -> Bool
Read back the `PruneTriviallyFalseEdges` build option (clang's default is `true`), which
drops the edges of a branch whose condition is a compile-time constant.
"""
function getPruneTriviallyFalseEdges(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getPruneTriviallyFalseEdges(x)
end

"""
    setPruneTriviallyFalseEdges(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `PruneTriviallyFalseEdges` build option (clang's default is `true`). Clearing it
keeps the never-taken arm of a constant-conditioned branch in the graph.
"""
function setPruneTriviallyFalseEdges(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setPruneTriviallyFalseEdges(x, val)
end

"""
    getAddEHEdges(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddEHEdges` build option (clang's default is `false`).
"""
function getAddEHEdges(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddEHEdges(x)
end

"""
    setAddEHEdges(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddEHEdges` build option (clang's default is `false`), which makes the builder add
exceptional edges out of the statements that can throw.
"""
function setAddEHEdges(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddEHEdges(x, val)
end

"""
    getAddStaticInitBranches(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddStaticInitBranches` build option (clang's default is `false`).
"""
function getAddStaticInitBranches(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddStaticInitBranches(x)
end

"""
    setAddStaticInitBranches(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddStaticInitBranches` build option (clang's default is `false`), which makes the
builder model the guarded-once initialization of a function-local static as a branch.
"""
function setAddStaticInitBranches(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddStaticInitBranches(x, val)
end

"""
    getAddCXXDefaultInitExprInCtors(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddCXXDefaultInitExprInCtors` build option (clang's default is `false`).
"""
function getAddCXXDefaultInitExprInCtors(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddCXXDefaultInitExprInCtors(x)
end

"""
    setAddCXXDefaultInitExprInCtors(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddCXXDefaultInitExprInCtors` build option (clang's default is `false`), which
makes a constructor's graph carry the default member initializers it runs.
"""
function setAddCXXDefaultInitExprInCtors(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddCXXDefaultInitExprInCtors(x, val)
end

"""
    getAddCXXDefaultInitExprInAggregates(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddCXXDefaultInitExprInAggregates` build option (clang's default is
`false`).
"""
function getAddCXXDefaultInitExprInAggregates(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddCXXDefaultInitExprInAggregates(x)
end

"""
    setAddCXXDefaultInitExprInAggregates(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddCXXDefaultInitExprInAggregates` build option (clang's default is `false`),
which makes an aggregate initialization carry the default member initializers it runs.
"""
function setAddCXXDefaultInitExprInAggregates(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddCXXDefaultInitExprInAggregates(x, val)
end

"""
    getAddRichCXXConstructors(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddRichCXXConstructors` build option (clang's default is `false`) that
`setAddRichCXXConstructors` writes.
"""
function getAddRichCXXConstructors(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddRichCXXConstructors(x)
end

"""
    getMarkElidedCXXConstructors(x::AbstractCFGBuildOptions) -> Bool
Read back the `MarkElidedCXXConstructors` build option (clang's default is `false`) that
`setMarkElidedCXXConstructors` writes.
"""
function getMarkElidedCXXConstructors(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getMarkElidedCXXConstructors(x)
end

"""
    getAddVirtualBaseBranches(x::AbstractCFGBuildOptions) -> Bool
Read back the `AddVirtualBaseBranches` build option (clang's default is `false`).
"""
function getAddVirtualBaseBranches(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getAddVirtualBaseBranches(x)
end

"""
    setAddVirtualBaseBranches(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `AddVirtualBaseBranches` build option (clang's default is `false`), which makes a
constructor's graph branch on whether it is the one responsible for the virtual bases —
the branches whose terminator kind is `CXCFGTerminatorKind_VirtualBaseBranch`.
"""
function setAddVirtualBaseBranches(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setAddVirtualBaseBranches(x, val)
end

"""
    getOmitImplicitValueInitializers(x::AbstractCFGBuildOptions) -> Bool
Read back the `OmitImplicitValueInitializers` build option (clang's default is `false`).
"""
function getOmitImplicitValueInitializers(x::AbstractCFGBuildOptions)
    @check_ptrs x
    return clang_CFGBuildOptions_getOmitImplicitValueInitializers(x)
end

"""
    setOmitImplicitValueInitializers(x::AbstractCFGBuildOptions, val::Bool=true)
Set the `OmitImplicitValueInitializers` build option (clang's default is `false`), which
keeps implicit value initializations out of the graph's element lists.
"""
function setOmitImplicitValueInitializers(x::AbstractCFGBuildOptions, val::Bool=true)
    @check_ptrs x
    return clang_CFGBuildOptions_setOmitImplicitValueInitializers(x, val)
end


"""
    dumpElement(x::AbstractCFGBlock, i::Integer)
Write the `i`-th element of the block to `stderr` — `clang::CFGElement::dump`, the same
rendering `printElementAsString` returns as a string. `i` is 0-based and must be smaller
than `size(x)`.
"""
function dumpElement(x::AbstractCFGBlock, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "element index $i out of range"
    return clang_CFGBlock_dumpElement(x, i)
end

"""
    dump(x::AbstractCFGBlock, cfg::AbstractCFG, ctx::ASTContext, show_colors::Bool=false)
Write the block to `stderr` — `clang::CFGBlock::dump`, the same rendering `printAsString`
returns as a string, with clang's terminal coloring when `show_colors` is set. `cfg` is
what labels the block's edges: pass the block's own `getParent` graph for a faithful
listing.
"""
function dump(x::AbstractCFGBlock, cfg::AbstractCFG, ctx::ASTContext, show_colors::Bool=false)
    @check_ptrs x cfg ctx
    return clang_CFGBlock_dump(x, cfg, ctx, show_colors)
end

"""
    dump(x::AbstractCFG, ctx::ASTContext, show_colors::Bool=false)
Write the whole graph to `stderr` — `clang::CFG::dump`, the same rendering `printAsString`
returns as a string, with clang's terminal coloring when `show_colors` is set.
"""
function dump(x::AbstractCFG, ctx::ASTContext, show_colors::Bool=false)
    @check_ptrs x ctx
    return clang_CFG_dump(x, ctx, show_colors)
end


"""
    getNumBlockStmts(x::AbstractCFG) -> Integer
Return how many statement-family `CFGElement`s (`Statement`, `Constructor`,
`CXXRecordTypedCall`) the graph holds across all of its blocks — the exact length of the
vector `getBlockStmts` returns.
"""
function getNumBlockStmts(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumBlockStmts(x)
end

"""
    getBlockStmts(x::AbstractCFG) -> Vector{Stmt}
Return every statement the graph's blocks carry, in block order and then element order —
`clang::CFG::VisitBlockStmts` with the whole walk run on the C side, which is what
`MARSHALLING.md` §10 asks for instead of a callback crossing the boundary. The result is
the same sequence a `getBlock` / `getElementStmt` double loop produces over the
statement-family element kinds. Statements come back at the base `Stmt` type; `resolve`
one to refine it. A statement appears more than once when two blocks carry it.
"""
function getBlockStmts(x::AbstractCFG)
    @check_ptrs x
    n = Int(getNumBlockStmts(x))
    buf = Vector{CXStmt}(undef, n)
    n > 0 && clang_CFG_getBlockStmts(x, buf, n)
    return Stmt[Stmt(p) for p in buf]
end

"""
    size(x::AbstractCFG) -> Integer
Return the number of blocks in the graph, matching `Base.size(::AbstractCFGBlock)`. This is
`clang::CFG::size`, which is a pure renaming of `getNumBlockIDs`, so only the latter is
bound on the C side.
"""
function Base.size(x::AbstractCFG)
    @check_ptrs x
    return clang_CFG_getNumBlockIDs(x)
end
