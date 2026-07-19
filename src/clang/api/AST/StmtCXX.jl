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
