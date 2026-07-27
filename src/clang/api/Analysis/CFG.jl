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
