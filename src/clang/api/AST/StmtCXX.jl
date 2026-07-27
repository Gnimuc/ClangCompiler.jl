# CXXCatchStmt
function getExceptionDecl(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return VarDecl(clang_CXXCatchStmt_getExceptionDecl(x))
end

function getCaughtType(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return QualType(clang_CXXCatchStmt_getCaughtType(x))
end

function getHandlerBlock(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return Stmt(clang_CXXCatchStmt_getHandlerBlock(x))
end

function getCatchLoc(x::AbstractCXXCatchStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXCatchStmt_getCatchLoc(x))
end

# CXXTryStmt
function getTryBlock(x::AbstractCXXTryStmt)
    @check_ptrs x
    return CompoundStmt(clang_CXXTryStmt_getTryBlock(x))
end

function getNumHandlers(x::AbstractCXXTryStmt)
    @check_ptrs x
    return clang_CXXTryStmt_getNumHandlers(x)
end

"""
    getHandler(x::AbstractCXXTryStmt, i)
Return the `i`-th handler (0-based, following the C++ API).
"""
function getHandler(x::AbstractCXXTryStmt, i::Integer)
    @check_ptrs x
    return CXXCatchStmt(clang_CXXTryStmt_getHandler(x, i))
end

function getTryLoc(x::AbstractCXXTryStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXTryStmt_getTryLoc(x))
end

# CXXForRangeStmt
function getLoopVariable(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return VarDecl(clang_CXXForRangeStmt_getLoopVariable(x))
end

function getRangeInit(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getRangeInit(x))
end

function getBody(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Stmt(clang_CXXForRangeStmt_getBody(x))
end

function getBeginStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getBeginStmt(x))
end

function getEndStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getEndStmt(x))
end

function getForLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getForLoc(x))
end

function getCoawaitLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getCoawaitLoc(x))
end

function getColonLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getColonLoc(x))
end

function getRParenLoc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return SourceLocation(clang_CXXForRangeStmt_getRParenLoc(x))
end



# CXXForRangeStmt
function getInit(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Stmt(clang_CXXForRangeStmt_getInit(x))
end

function getRangeStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getRangeStmt(x))
end

function getCond(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getCond(x))
end

function getInc(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return Expr_(clang_CXXForRangeStmt_getInc(x))
end

function getLoopVarStmt(x::AbstractCXXForRangeStmt)
    @check_ptrs x
    return DeclStmt(clang_CXXForRangeStmt_getLoopVarStmt(x))
end

# CoroutineBodyStmt
function hasDependentPromiseType(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return clang_CoroutineBodyStmt_hasDependentPromiseType(x)
end

"""
    getBody(x::AbstractCoroutineBodyStmt)
Return the body of the coroutine as written (a `CompoundStmt`).
"""
function getBody(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return CompoundStmt(clang_CoroutineBodyStmt_getBody(x))
end

"""
    getPromiseDecl(x::AbstractCoroutineBodyStmt)
Return the `VarDecl` of the coroutine promise object.
"""
function getPromiseDecl(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return VarDecl(clang_CoroutineBodyStmt_getPromiseDecl(x))
end

function getInitSuspendStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getInitSuspendStmt(x))
end

function getFinalSuspendStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getFinalSuspendStmt(x))
end

function getExceptionHandler(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getExceptionHandler(x))
end

function getAllocate(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getAllocate(x))
end

function getDeallocate(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Expr_(clang_CoroutineBodyStmt_getDeallocate(x))
end

function getReturnStmt(x::AbstractCoroutineBodyStmt)
    @check_ptrs x
    return Stmt(clang_CoroutineBodyStmt_getReturnStmt(x))
end

# CoreturnStmt
function getKeywordLoc(x::AbstractCoreturnStmt)
    @check_ptrs x
    return SourceLocation(clang_CoreturnStmt_getKeywordLoc(x))
end

function getOperand(x::AbstractCoreturnStmt)
    @check_ptrs x
    return Expr_(clang_CoreturnStmt_getOperand(x))
end

function getPromiseCall(x::AbstractCoreturnStmt)
    @check_ptrs x
    return Expr_(clang_CoreturnStmt_getPromiseCall(x))
end

function isImplicit(x::AbstractCoreturnStmt)
    @check_ptrs x
    return clang_CoreturnStmt_isImplicit(x)
end
