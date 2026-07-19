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

function getLocation(x::AbstractCXXBoolLiteralExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXBoolLiteralExpr_getLocation(x))
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

function getLocation(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXConstructExpr_getLocation(x))
end

function hadMultipleCandidates(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_hadMultipleCandidates(x)
end

function isListInitialization(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_isListInitialization(x)
end

function isStdInitListInitialization(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_isStdInitListInitialization(x)
end

function requiresZeroInitialization(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_requiresZeroInitialization(x)
end

function isImmediateEscalating(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_isImmediateEscalating(x)
end

function getConstructionKind(x::AbstractCXXConstructExpr)
    @check_ptrs x
    return clang_CXXConstructExpr_getConstructionKind(x)
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

function shouldNullCheckAllocation(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_shouldNullCheckAllocation(x)
end

function getNumPlacementArgs(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_getNumPlacementArgs(x)
end

function isParenTypeId(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_isParenTypeId(x)
end

function isGlobalNew(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_isGlobalNew(x)
end

function passAlignment(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_passAlignment(x)
end

function doesUsualArrayDeleteWantSize(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_doesUsualArrayDeleteWantSize(x)
end

function getInitializationStyle(x::AbstractCXXNewExpr)
    @check_ptrs x
    return clang_CXXNewExpr_getInitializationStyle(x)
end

function getOperatorDelete(x::AbstractCXXNewExpr)
    @check_ptrs x
    return FunctionDecl(clang_CXXNewExpr_getOperatorDelete(x))
end

function getOperatorNew(x::AbstractCXXNewExpr)
    @check_ptrs x
    return FunctionDecl(clang_CXXNewExpr_getOperatorNew(x))
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

function isGlobalDelete(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return clang_CXXDeleteExpr_isGlobalDelete(x)
end

function isArrayFormAsWritten(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return clang_CXXDeleteExpr_isArrayFormAsWritten(x)
end

function doesUsualArrayDeleteWantSize(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return clang_CXXDeleteExpr_doesUsualArrayDeleteWantSize(x)
end

function getDestroyedType(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return QualType(clang_CXXDeleteExpr_getDestroyedType(x))
end

function getOperatorDelete(x::AbstractCXXDeleteExpr)
    @check_ptrs x
    return FunctionDecl(clang_CXXDeleteExpr_getOperatorDelete(x))
end

# CastExpr
function path_empty(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_path_empty(x)
end

function path_size(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_path_size(x)
end

function hasStoredFPFeatures(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_hasStoredFPFeatures(x)
end

function changesVolatileQualification(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_changesVolatileQualification(x)
end

# CXXThisExpr
function getLocation(x::AbstractCXXThisExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXThisExpr_getLocation(x))
end

function isImplicit(x::AbstractCXXThisExpr)
    @check_ptrs x
    return clang_CXXThisExpr_isImplicit(x)
end

# MaterializeTemporaryExpr
function getManglingNumber(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    return clang_MaterializeTemporaryExpr_getManglingNumber(x)
end

function isBoundToLvalueReference(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    return clang_MaterializeTemporaryExpr_isBoundToLvalueReference(x)
end

# CXXNamedCastExpr
function getOperatorLoc(x::AbstractCXXNamedCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXNamedCastExpr_getOperatorLoc(x))
end

function getRParenLoc(x::AbstractCXXNamedCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXNamedCastExpr_getRParenLoc(x))
end

