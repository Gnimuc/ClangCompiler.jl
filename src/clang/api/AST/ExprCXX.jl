# CXXOperatorCallExpr
function getOperator(x::AbstractCXXOperatorCallExpr)
    @check_ptrs x
    return clang_CXXOperatorCallExpr_getOperator(x)
end

function getOperatorLoc(x::AbstractCXXOperatorCallExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXOperatorCallExpr_getOperatorLoc(x))
end

# CXXMemberCallExpr
function getImplicitObjectArgument(x::AbstractCXXMemberCallExpr)
    @check_ptrs x
    return Expr_(clang_CXXMemberCallExpr_getImplicitObjectArgument(x))
end

function getMethodDecl(x::AbstractCXXMemberCallExpr)
    @check_ptrs x
    return CXXMethodDecl(clang_CXXMemberCallExpr_getMethodDecl(x))
end

function getRecordDecl(x::AbstractCXXMemberCallExpr)
    @check_ptrs x
    return CXXRecordDecl(clang_CXXMemberCallExpr_getRecordDecl(x))
end

# CXXBoolLiteralExpr
function getValue(x::AbstractCXXBoolLiteralExpr)
    @check_ptrs x
    return clang_CXXBoolLiteralExpr_getValue(x)
end

# CXXConstructExpr
function getConstructor(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return CXXConstructorDecl(clang_CXXConstructExpr_getConstructor(x))
end

function getNumArgs(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_getNumArgs(x)
end

"""
    getArg(x::AbstractCXXConstructExpr, i)
Return the `i`-th argument (0-based, following the C++ API).
"""
function getArg(x::AbstractCXXConstructExpr, i::Integer)
    @check_ptrs x
    return Expr_(clang_CXXConstructExpr_getArg(x, i))
end

function isElidable(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_isElidable(x)
end

# LambdaExpr
function getCallOperator(x::AbstractLambdaExpr)
    @check_ptrs x
    return CXXMethodDecl(clang_LambdaExpr_getCallOperator(x))
end

function getLambdaClass(x::AbstractLambdaExpr)
    @check_ptrs x
    return CXXRecordDecl(clang_LambdaExpr_getLambdaClass(x))
end

function getBody(x::AbstractLambdaExpr)
    @check_ptrs x
    return Stmt(clang_LambdaExpr_getBody(x))
end

function isMutable(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_isMutable(x)
end

# CXXNewExpr
function getAllocatedType(x::AbstractCXXNewExpr)
    @check_ptrs x
    return QualType(clang_CXXNewExpr_getAllocatedType(x))
end

function isArray(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_isArray(x)
end

"""
    getArraySize(x::AbstractCXXNewExpr)
The wrapped pointer is NULL when the new-expression has no array size.
"""
function getArraySize(x::AbstractCXXNewExpr)
    @check_ptrs x
    return Expr_(clang_CXXNewExpr_getArraySize(x))
end

function hasInitializer(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_hasInitializer(x)
end

function getInitializer(x::AbstractCXXNewExpr)
    @check_ptrs x
    return Expr_(clang_CXXNewExpr_getInitializer(x))
end

# CXXDeleteExpr
function getArgument(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return Expr_(clang_CXXDeleteExpr_getArgument(x))
end

function isArrayForm(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return clang_CXXDeleteExpr_isArrayForm(x)
end
