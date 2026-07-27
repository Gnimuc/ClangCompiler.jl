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

function getNumCaptures(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_getNumCaptures(x)
end

"""
    getCapture(x::AbstractLambdaExpr, i)
Return the `i`-th capture (0-based, following the C++ API). The wrapped pointer
borrows into the lambda's capture list; do not dispose it.
"""
function getCapture(x::AbstractLambdaExpr, i::Integer)
    @check_ptrs x
    return LambdaCapture(clang_LambdaExpr_getCapture(x, i))
end

function isGenericLambda(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_isGenericLambda(x)
end

# LambdaCapture
function getCaptureKind(x::LambdaCapture)
    @check_ptrs x
    return clang_LambdaCapture_getCaptureKind(x)
end

function capturesThis(x::LambdaCapture)
    @check_ptrs x
    return clang_LambdaCapture_capturesThis(x)
end

function capturesVariable(x::LambdaCapture)
    @check_ptrs x
    return clang_LambdaCapture_capturesVariable(x)
end

function capturesVLAType(x::LambdaCapture)
    @check_ptrs x
    return clang_LambdaCapture_capturesVLAType(x)
end

"""
    getCapturedVar(x::LambdaCapture)
Retrieve the captured variable (a `clang::ValueDecl`). Valid only when
`capturesVariable(x)` is `true`.
"""
function getCapturedVar(x::LambdaCapture)
    @check_ptrs x
    @assert capturesVariable(x) "LambdaCapture does not capture a variable."
    return ValueDecl(clang_LambdaCapture_getCapturedVar(x))
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

function getAllocatedTypeSourceInfo(x::AbstractCXXNewExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXNewExpr_getAllocatedTypeSourceInfo(x))
end

function getConstructExpr(x::AbstractCXXNewExpr)
    @check_ptrs x
    return CXXConstructExpr(clang_CXXNewExpr_getConstructExpr(x))
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

function getConversionFunction(x::AbstractCastExpr)
    @check_ptrs x
    return NamedDecl(clang_CastExpr_getConversionFunction(x))
end

function getTargetUnionField(x::AbstractCastExpr)
    @check_ptrs x
    return FieldDecl(clang_CastExpr_getTargetUnionField(x))
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

function getExtendingDecl(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    return ValueDecl(clang_MaterializeTemporaryExpr_getExtendingDecl(x))
end

function getSubExpr(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    return Expr_(clang_MaterializeTemporaryExpr_getSubExpr(x))
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



# LambdaExpr
function getCaptureDefault(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_getCaptureDefault(x)
end

function getCaptureDefaultLoc(x::AbstractLambdaExpr)
    @check_ptrs x
    return SourceLocation(clang_LambdaExpr_getCaptureDefaultLoc(x))
end

function getIntroducerRange(x::AbstractLambdaExpr)
    @check_ptrs x
    r = clang_LambdaExpr_getIntroducerRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getCaptureInit(x::AbstractLambdaExpr, i)
Return the initialization expression of the `i`-th capture (0-based, following the C++ API).
The C++ accessor is an unchecked pointer bump, so `i` must be less than `getNumCaptures(x)`.
The returned carrier wraps NULL when the capture has no initializer (VLA-type captures).
"""
function getCaptureInit(x::AbstractLambdaExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCaptures(x) "capture index out of range"
    return Expr_(clang_LambdaExpr_getCaptureInit(x, i))
end

"""
    isInitCapture(x::AbstractLambdaExpr, c::LambdaCapture)
Determine whether `c` is an init-capture of `x`. `c` must be one of `x`'s own captures
(obtained from `getCapture(x, i)`); Clang indexes `x`'s capture list with that pointer.
"""
function isInitCapture(x::AbstractLambdaExpr, c::LambdaCapture)
    @check_ptrs x c
    return clang_LambdaExpr_isInitCapture(x, c)
end

function hasExplicitParameters(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_hasExplicitParameters(x)
end

function hasExplicitResultType(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_hasExplicitResultType(x)
end

"""
    getCompoundStmtBody(x::AbstractLambdaExpr)
Retrieve the `CompoundStmt` representing the body of the lambda. Clang unwraps the body
with an asserting `cast<CompoundStmt>`, so the body must be a `CompoundStmt` or a
`CoroutineBodyStmt` wrapping one.
"""
function getCompoundStmtBody(x::AbstractLambdaExpr)
    @check_ptrs x
    body = getBody(x)
    @assert isCompoundStmt(body) || isCoroutineBodyStmt(body) "lambda body must be a CompoundStmt or a \
                                                              CoroutineBodyStmt"
    return CompoundStmt(clang_LambdaExpr_getCompoundStmtBody(x))
end

"""
    getDependentCallOperator(x::AbstractLambdaExpr)
Retrieve the function template that describes the call operator of a generic lambda.
The returned carrier wraps NULL when the lambda is not generic.
"""
function getDependentCallOperator(x::AbstractLambdaExpr)
    @check_ptrs x
    return FunctionTemplateDecl(clang_LambdaExpr_getDependentCallOperator(x))
end

"""
    getTemplateParameterList(x::AbstractLambdaExpr)
Retrieve the template parameter list of a generic lambda. The returned carrier wraps NULL
when the lambda is not generic.
"""
function getTemplateParameterList(x::AbstractLambdaExpr)
    @check_ptrs x
    return TemplateParameterList(clang_LambdaExpr_getTemplateParameterList(x))
end

"""
    getTrailingRequiresClause(x::AbstractLambdaExpr)
Retrieve the trailing requires-clause of the lambda's call operator. The returned carrier
wraps NULL when there is none.
"""
function getTrailingRequiresClause(x::AbstractLambdaExpr)
    @check_ptrs x
    return Expr_(clang_LambdaExpr_getTrailingRequiresClause(x))
end

# CXXConstructExpr
function getParenOrBraceRange(x::AbstractCXXConstructExpr)
    @check_ptrs x
    r = clang_CXXConstructExpr_getParenOrBraceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# CXXTemporaryObjectExpr
function getTypeSourceInfo(x::AbstractCXXTemporaryObjectExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXTemporaryObjectExpr_getTypeSourceInfo(x))
end

# CXXNewExpr
"""
    getPlacementArg(x::AbstractCXXNewExpr, i)
Return the `i`-th placement argument (0-based, following the C++ API). Clang asserts
`i < getNumPlacementArgs(x)`.
"""
function getPlacementArg(x::AbstractCXXNewExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumPlacementArgs(x) "placement argument index out of range"
    return Expr_(clang_CXXNewExpr_getPlacementArg(x, i))
end

function getDirectInitRange(x::AbstractCXXNewExpr)
    @check_ptrs x
    r = clang_CXXNewExpr_getDirectInitRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    getTypeIdParens(x::AbstractCXXNewExpr)
Return the parenthesised type-id range. The range is invalid unless `isParenTypeId(x)`.
"""
function getTypeIdParens(x::AbstractCXXNewExpr)
    @check_ptrs x
    r = clang_CXXNewExpr_getTypeIdParens(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end


"""
    getCastName(x::AbstractCXXNamedCastExpr) -> String
Return the spelling of the cast keyword, e.g. `"static_cast"`.
"""
function getCastName(x::AbstractCXXNamedCastExpr)
    @check_ptrs x
    return unsafe_string(clang_CXXNamedCastExpr_getCastName(x))
end

function getAngleBrackets(x::AbstractCXXNamedCastExpr)
    @check_ptrs x
    r = clang_CXXNamedCastExpr_getAngleBrackets(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# CXXThrowExpr
"""
    getSubExpr(x::AbstractCXXThrowExpr) -> Expr_
Return the thrown operand. The carrier holds NULL for a re-throw (`throw;`).
"""
function getSubExpr(x::AbstractCXXThrowExpr)
    @check_ptrs x
    return Expr_(clang_CXXThrowExpr_getSubExpr(x))
end

function getThrowLoc(x::AbstractCXXThrowExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXThrowExpr_getThrowLoc(x))
end

# CXXTypeidExpr
function isTypeOperand(x::AbstractCXXTypeidExpr)
    @check_ptrs x
    return clang_CXXTypeidExpr_isTypeOperand(x)
end

"""
    getTypeOperandSourceInfo(x::AbstractCXXTypeidExpr) -> TypeSourceInfo
Return the type operand of a `typeid(type)` expression. Valid only when
[`isTypeOperand`](@ref) is `true`: Clang reads the operand union unchecked.
"""
function getTypeOperandSourceInfo(x::AbstractCXXTypeidExpr)
    @check_ptrs x
    @assert isTypeOperand(x) "typeid expression must have a type operand"
    return TypeSourceInfo(clang_CXXTypeidExpr_getTypeOperandSourceInfo(x))
end

"""
    getExprOperand(x::AbstractCXXTypeidExpr) -> Expr_
Return the expression operand of a `typeid(expr)` expression. Valid only when
[`isTypeOperand`](@ref) is `false`: Clang reads the operand union unchecked.
"""
function getExprOperand(x::AbstractCXXTypeidExpr)
    @check_ptrs x
    @assert !isTypeOperand(x) "typeid expression must have an expression operand"
    return Expr_(clang_CXXTypeidExpr_getExprOperand(x))
end

# CXXDefaultArgExpr
function getParam(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    return ParmVarDecl(clang_CXXDefaultArgExpr_getParam(x))
end

"""
    getExpr(x::AbstractCXXDefaultArgExpr) -> Expr_
Return the default-argument expression. Valid only once the parameter's default
argument has been instantiated (`ParmVarDecl::getDefaultArg` asserts on it).
"""
function getExpr(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    @assert !hasUninstantiatedDefaultArg(getParam(x)) "default argument must be instantiated"
    return Expr_(clang_CXXDefaultArgExpr_getExpr(x))
end

# CXXDefaultInitExpr
function getField(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    return FieldDecl(clang_CXXDefaultInitExpr_getField(x))
end

"""
    getExpr(x::AbstractCXXDefaultInitExpr) -> Expr_
Return the in-class initializer used for the field. Valid only when the field
carries an in-class initializer, which Clang asserts on.
"""
function getExpr(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    @assert hasInClassInitializer(getField(x)) "field must have an in-class initializer"
    return Expr_(clang_CXXDefaultInitExpr_getExpr(x))
end

# CXXBindTemporaryExpr
function getSubExpr(x::AbstractCXXBindTemporaryExpr)
    @check_ptrs x
    return Expr_(clang_CXXBindTemporaryExpr_getSubExpr(x))
end

# ExprWithCleanups
function getNumObjects(x::AbstractExprWithCleanups)
    @check_ptrs x
    return clang_ExprWithCleanups_getNumObjects(x)
end

function cleanupsHaveSideEffects(x::AbstractExprWithCleanups)
    @check_ptrs x
    return clang_ExprWithCleanups_cleanupsHaveSideEffects(x)
end

# TypeTraitExpr
"""
    getValue(x::AbstractTypeTraitExpr) -> Bool
Return the value the type trait evaluated to. Valid only when the expression is
not value-dependent, which Clang asserts on.
"""
function getValue(x::AbstractTypeTraitExpr)
    @check_ptrs x
    @assert !isValueDependent(x) "type trait expression must not be value-dependent"
    return clang_TypeTraitExpr_getValue(x)
end

function getNumArgs(x::AbstractTypeTraitExpr)
    @check_ptrs x
    return clang_TypeTraitExpr_getNumArgs(x)
end

"""
    getArg(x::AbstractTypeTraitExpr, i::Integer) -> TypeSourceInfo
Return the `i`-th type argument (0-based, following the C++ API). Clang asserts
the index is in range and then indexes the trailing array unchecked.
"""
function getArg(x::AbstractTypeTraitExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "type trait argument index out of range"
    return TypeSourceInfo(clang_TypeTraitExpr_getArg(x, i))
end

# SizeOfPackExpr
function getPack(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    return NamedDecl(clang_SizeOfPackExpr_getPack(x))
end

function isPartiallySubstituted(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    return clang_SizeOfPackExpr_isPartiallySubstituted(x)
end

# CXXFoldExpr
"""
    getPattern(x::AbstractCXXFoldExpr) -> Expr_
Return the operand that contains the unexpanded parameter pack.
"""
function getPattern(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return Expr_(clang_CXXFoldExpr_getPattern(x))
end


# UserDefinedLiteral
"""
    getLiteralOperatorKind(x::AbstractUserDefinedLiteral) -> CXUserDefinedLiteral_LiteralOperatorKind
Return which literal-operator form this user-defined literal invokes (raw,
templated, or one of the cooked forms).
"""
function getLiteralOperatorKind(x::AbstractUserDefinedLiteral)
    @check_ptrs x
    return clang_UserDefinedLiteral_getLiteralOperatorKind(x)
end

"""
    getCookedLiteral(x::AbstractUserDefinedLiteral) -> Expr_
Return the underlying cooked literal, i.e. the literal with its ud-suffix removed.
Clang asserts that the literal operator is neither raw nor templated and then
returns the first call argument unchecked.
"""
function getCookedLiteral(x::AbstractUserDefinedLiteral)
    @check_ptrs x
    k = getLiteralOperatorKind(x)
    @assert k != CXUserDefinedLiteral_LOK_Raw "user-defined literal must be cooked"
    @assert k != CXUserDefinedLiteral_LOK_Template "user-defined literal must be cooked"
    return Expr_(clang_UserDefinedLiteral_getCookedLiteral(x))
end

"""
    getUDSuffix(x::AbstractUserDefinedLiteral) -> IdentifierInfo
Return the ud-suffix identifier written for this literal. For a string literal
with several identical suffixes this is the first one.
"""
function getUDSuffix(x::AbstractUserDefinedLiteral)
    @check_ptrs x
    return IdentifierInfo(clang_UserDefinedLiteral_getUDSuffix(x))
end

# CXXRewrittenBinaryOperator
"""
    getSemanticForm(x::AbstractCXXRewrittenBinaryOperator) -> Expr_
Return the expression the comparison was rewritten into (the form that is
actually evaluated).
"""
function getSemanticForm(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return Expr_(clang_CXXRewrittenBinaryOperator_getSemanticForm(x))
end

"""
    getOpcode(x::AbstractCXXRewrittenBinaryOperator) -> CXBinaryOperatorKind
Return the opcode as written, recovered from the rewritten semantic form.
"""
function getOpcode(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return clang_CXXRewrittenBinaryOperator_getOpcode(x)
end

"""
    getLHS(x::AbstractCXXRewrittenBinaryOperator) -> Expr_
Return the left-hand operand as written, recovered from the semantic form.
"""
function getLHS(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return Expr_(clang_CXXRewrittenBinaryOperator_getLHS(x))
end

"""
    getRHS(x::AbstractCXXRewrittenBinaryOperator) -> Expr_
Return the right-hand operand as written, recovered from the semantic form.
"""
function getRHS(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return Expr_(clang_CXXRewrittenBinaryOperator_getRHS(x))
end

function isReversed(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return clang_CXXRewrittenBinaryOperator_isReversed(x)
end

# CXXStdInitializerListExpr
"""
    getSubExpr(x::AbstractCXXStdInitializerListExpr) -> Expr_
Return the initializer list array whose address the `std::initializer_list`
object is built from.
"""
function getSubExpr(x::AbstractCXXStdInitializerListExpr)
    @check_ptrs x
    return Expr_(clang_CXXStdInitializerListExpr_getSubExpr(x))
end

# CXXScalarValueInitExpr
function getTypeSourceInfo(x::AbstractCXXScalarValueInitExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXScalarValueInitExpr_getTypeSourceInfo(x))
end

function getRParenLoc(x::AbstractCXXScalarValueInitExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXScalarValueInitExpr_getRParenLoc(x))
end

# CXXNullPtrLiteralExpr
function getLocation(x::AbstractCXXNullPtrLiteralExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXNullPtrLiteralExpr_getLocation(x))
end

# CXXInheritedCtorInitExpr
"""
    getConstructor(x::AbstractCXXInheritedCtorInitExpr) -> CXXConstructorDecl
Return the inherited constructor this expression forwards to.
"""
function getConstructor(x::AbstractCXXInheritedCtorInitExpr)
    @check_ptrs x
    return CXXConstructorDecl(clang_CXXInheritedCtorInitExpr_getConstructor(x))
end

"""
    constructsVBase(x::AbstractCXXInheritedCtorInitExpr) -> Bool
Return true when the call constructs a base class subobject rather than a
complete object.
"""
function constructsVBase(x::AbstractCXXInheritedCtorInitExpr)
    @check_ptrs x
    return clang_CXXInheritedCtorInitExpr_constructsVBase(x)
end

# CoroutineSuspendExpr
"""
    getCommonExpr(x::AbstractCoroutineSuspendExpr) -> Expr_
Return the common sub-expression the awaiter is materialized from.
"""
function getCommonExpr(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return Expr_(clang_CoroutineSuspendExpr_getCommonExpr(x))
end

"""
    getReadyExpr(x::AbstractCoroutineSuspendExpr) -> Expr_
Return the `await_ready()` call of this suspend point.
"""
function getReadyExpr(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return Expr_(clang_CoroutineSuspendExpr_getReadyExpr(x))
end

"""
    getSuspendExpr(x::AbstractCoroutineSuspendExpr) -> Expr_
Return the `await_suspend()` call of this suspend point.
"""
function getSuspendExpr(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return Expr_(clang_CoroutineSuspendExpr_getSuspendExpr(x))
end

"""
    getResumeExpr(x::AbstractCoroutineSuspendExpr) -> Expr_
Return the `await_resume()` call of this suspend point.
"""
function getResumeExpr(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return Expr_(clang_CoroutineSuspendExpr_getResumeExpr(x))
end

"""
    getOperand(x::AbstractCoroutineSuspendExpr) -> Expr_
Return the operand written in the source, i.e. the `X` of `co_await X`.
"""
function getOperand(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return Expr_(clang_CoroutineSuspendExpr_getOperand(x))
end

function getKeywordLoc(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return SourceLocation(clang_CoroutineSuspendExpr_getKeywordLoc(x))
end


# CXXNoexceptExpr
"""
    getOperand(x::AbstractCXXNoexceptExpr) -> Expr_
Return the operand expression of the `noexcept(expr)` operator.
"""
function getOperand(x::AbstractCXXNoexceptExpr)
    @check_ptrs x
    return Expr_(clang_CXXNoexceptExpr_getOperand(x))
end

"""
    getValue(x::AbstractCXXNoexceptExpr) -> Bool
Return the compile-time result of the `noexcept(expr)` operator.
"""
function getValue(x::AbstractCXXNoexceptExpr)
    @check_ptrs x
    return clang_CXXNoexceptExpr_getValue(x)
end

# CXXPseudoDestructorExpr
"""
    getBase(x::AbstractCXXPseudoDestructorExpr) -> Expr_
Return the base object expression of the pseudo-destructor call.
"""
function getBase(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return Expr_(clang_CXXPseudoDestructorExpr_getBase(x))
end

function hasQualifier(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return clang_CXXPseudoDestructorExpr_hasQualifier(x)
end

function isArrow(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return clang_CXXPseudoDestructorExpr_isArrow(x)
end

function getOperatorLoc(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXPseudoDestructorExpr_getOperatorLoc(x))
end

function getTildeLoc(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXPseudoDestructorExpr_getTildeLoc(x))
end

"""
    getDestroyedType(x::AbstractCXXPseudoDestructorExpr) -> QualType
Return the type being destroyed; a null `QualType` for a dependent destructor name.
"""
function getDestroyedType(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return QualType(clang_CXXPseudoDestructorExpr_getDestroyedType(x))
end

# CXXUnresolvedConstructExpr
"""
    getTypeAsWritten(x::AbstractCXXUnresolvedConstructExpr) -> QualType
Return the type being constructed, as written in the source.
"""
function getTypeAsWritten(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return QualType(clang_CXXUnresolvedConstructExpr_getTypeAsWritten(x))
end

function getLParenLoc(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXUnresolvedConstructExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXUnresolvedConstructExpr_getRParenLoc(x))
end

function isListInitialization(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return clang_CXXUnresolvedConstructExpr_isListInitialization(x)
end

function getNumArgs(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return clang_CXXUnresolvedConstructExpr_getNumArgs(x)
end

"""
    getArg(x::AbstractCXXUnresolvedConstructExpr, i::Integer) -> Expr_
Return the `i`-th argument (0-based). Clang asserts the index is in range and then
indexes the trailing argument array unchecked.
"""
function getArg(x::AbstractCXXUnresolvedConstructExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "unresolved-construct argument index out of range"
    return Expr_(clang_CXXUnresolvedConstructExpr_getArg(x, i))
end

# PackExpansionExpr
"""
    getPattern(x::AbstractPackExpansionExpr) -> Expr_
Return the pattern expression repeated by the pack expansion.
"""
function getPattern(x::AbstractPackExpansionExpr)
    @check_ptrs x
    return Expr_(clang_PackExpansionExpr_getPattern(x))
end

function getEllipsisLoc(x::AbstractPackExpansionExpr)
    @check_ptrs x
    return SourceLocation(clang_PackExpansionExpr_getEllipsisLoc(x))
end

# DependentScopeDeclRefExpr
function getLocation(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DependentScopeDeclRefExpr_getLocation(x))
end

function hasTemplateKeyword(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return clang_DependentScopeDeclRefExpr_hasTemplateKeyword(x)
end

function hasExplicitTemplateArgs(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return clang_DependentScopeDeclRefExpr_hasExplicitTemplateArgs(x)
end

function getNumTemplateArgs(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return clang_DependentScopeDeclRefExpr_getNumTemplateArgs(x)
end


# OverloadExpr (base of UnresolvedLookupExpr and UnresolvedMemberExpr)
function getNamingClass(x::AbstractOverloadExpr)
    @check_ptrs x
    return CXXRecordDecl(clang_OverloadExpr_getNamingClass(x))
end

function getNumDecls(x::AbstractOverloadExpr)
    @check_ptrs x
    return clang_OverloadExpr_getNumDecls(x)
end

function getName(x::AbstractOverloadExpr)
    @check_ptrs x
    return DeclarationName(clang_OverloadExpr_getName(x))
end

function getNameLoc(x::AbstractOverloadExpr)
    @check_ptrs x
    return SourceLocation(clang_OverloadExpr_getNameLoc(x))
end

function getQualifier(x::AbstractOverloadExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_OverloadExpr_getQualifier(x))
end

function getTemplateKeywordLoc(x::AbstractOverloadExpr)
    @check_ptrs x
    return SourceLocation(clang_OverloadExpr_getTemplateKeywordLoc(x))
end

function getLAngleLoc(x::AbstractOverloadExpr)
    @check_ptrs x
    return SourceLocation(clang_OverloadExpr_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractOverloadExpr)
    @check_ptrs x
    return SourceLocation(clang_OverloadExpr_getRAngleLoc(x))
end

function hasTemplateKeyword(x::AbstractOverloadExpr)
    @check_ptrs x
    return clang_OverloadExpr_hasTemplateKeyword(x)
end

function hasExplicitTemplateArgs(x::AbstractOverloadExpr)
    @check_ptrs x
    return clang_OverloadExpr_hasExplicitTemplateArgs(x)
end

function getNumTemplateArgs(x::AbstractOverloadExpr)
    @check_ptrs x
    return clang_OverloadExpr_getNumTemplateArgs(x)
end

# UnresolvedLookupExpr
function requiresADL(x::AbstractUnresolvedLookupExpr)
    @check_ptrs x
    return clang_UnresolvedLookupExpr_requiresADL(x)
end

function isOverloaded(x::AbstractUnresolvedLookupExpr)
    @check_ptrs x
    return clang_UnresolvedLookupExpr_isOverloaded(x)
end

# UnresolvedMemberExpr
function isImplicitAccess(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return clang_UnresolvedMemberExpr_isImplicitAccess(x)
end

function getBase(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    @assert !isImplicitAccess(x) "getBase requires an explicit access; this is an implicit member access"
    return Expr_(clang_UnresolvedMemberExpr_getBase(x))
end

function getBaseType(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return QualType(clang_UnresolvedMemberExpr_getBaseType(x))
end

function hasUnresolvedUsing(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return clang_UnresolvedMemberExpr_hasUnresolvedUsing(x)
end

function isArrow(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return clang_UnresolvedMemberExpr_isArrow(x)
end

function getOperatorLoc(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedMemberExpr_getOperatorLoc(x))
end

# CXXOperatorCallExpr (classification predicates)
function isAssignmentOp(x::AbstractCXXOperatorCallExpr)
    @check_ptrs x
    return clang_CXXOperatorCallExpr_isAssignmentOp(x)
end

function isComparisonOp(x::AbstractCXXOperatorCallExpr)
    @check_ptrs x
    return clang_CXXOperatorCallExpr_isComparisonOp(x)
end

# CXXMemberCallExpr (object type)
function getObjectType(x::AbstractCXXMemberCallExpr)
    @check_ptrs x
    @assert getImplicitObjectArgument(x).ptr != C_NULL "getObjectType requires an implicit object argument"
    return QualType(clang_CXXMemberCallExpr_getObjectType(x))
end

# CXXThrowExpr
function isThrownVariableInScope(x::AbstractCXXThrowExpr)
    @check_ptrs x
    return clang_CXXThrowExpr_isThrownVariableInScope(x)
end

# SizeOfPackExpr
function getOperatorLoc(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    return SourceLocation(clang_SizeOfPackExpr_getOperatorLoc(x))
end

function getPackLoc(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    return SourceLocation(clang_SizeOfPackExpr_getPackLoc(x))
end

function getRParenLoc(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    return SourceLocation(clang_SizeOfPackExpr_getRParenLoc(x))
end

function getPackLength(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    @assert !isValueDependent(x) "getPackLength requires a non-value-dependent pack size expression"
    return clang_SizeOfPackExpr_getPackLength(x)
end

# CXXFoldExpr
function getCallee(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return UnresolvedLookupExpr(clang_CXXFoldExpr_getCallee(x))
end

function getLHS(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return Expr_(clang_CXXFoldExpr_getLHS(x))
end

function getRHS(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return Expr_(clang_CXXFoldExpr_getRHS(x))
end

function isLeftFold(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return clang_CXXFoldExpr_isLeftFold(x)
end

function isRightFold(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return clang_CXXFoldExpr_isRightFold(x)
end

function getInit(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return Expr_(clang_CXXFoldExpr_getInit(x))
end

function getLParenLoc(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXFoldExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXFoldExpr_getRParenLoc(x))
end

function getEllipsisLoc(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXFoldExpr_getEllipsisLoc(x))
end

function getOperator(x::AbstractCXXFoldExpr)
    @check_ptrs x
    return clang_CXXFoldExpr_getOperator(x)
end

# CXXDynamicCastExpr
function isAlwaysNull(x::AbstractCXXDynamicCastExpr)
    @check_ptrs x
    return clang_CXXDynamicCastExpr_isAlwaysNull(x)
end

# CXXDefaultArgExpr
function hasRewrittenInit(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    return clang_CXXDefaultArgExpr_hasRewrittenInit(x)
end

"""
    getRewrittenExpr(x::AbstractCXXDefaultArgExpr)
Retrieve the rewritten default argument, i.e. the initializer with its immediate
(`consteval`) calls already evaluated. The returned carrier wraps NULL when
`hasRewrittenInit(x)` is false.
"""
function getRewrittenExpr(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    return Expr_(clang_CXXDefaultArgExpr_getRewrittenExpr(x))
end

function getUsedContext(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    return DeclContext(clang_CXXDefaultArgExpr_getUsedContext(x))
end

# CXXDefaultInitExpr
function hasRewrittenInit(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    return clang_CXXDefaultInitExpr_hasRewrittenInit(x)
end

"""
    getRewrittenExpr(x::AbstractCXXDefaultInitExpr)
Retrieve the default member initializer with its immediate (`consteval`) calls
already evaluated. `hasRewrittenInit(x)` must hold: Clang asserts it and then
dereferences the trailing storage unchecked.
"""
function getRewrittenExpr(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    @assert hasRewrittenInit(x) "the default initializer has no rewritten form"
    return Expr_(clang_CXXDefaultInitExpr_getRewrittenExpr(x))
end

function getUsedContext(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    return DeclContext(clang_CXXDefaultInitExpr_getUsedContext(x))
end

# CXXBindTemporaryExpr
function getTemporary(x::AbstractCXXBindTemporaryExpr)
    @check_ptrs x
    return CXXTemporary(clang_CXXBindTemporaryExpr_getTemporary(x))
end

# CXXTemporary
function getDestructor(x::AbstractCXXTemporary)
    @check_ptrs x
    return CXXDestructorDecl(clang_CXXTemporary_getDestructor(x))
end

# CXXFunctionalCastExpr
"""
    getLParenLoc(x::AbstractCXXFunctionalCastExpr)
Retrieve the location of the opening paren. The location is invalid when the cast
models list-initialization (`T{...}`), which writes no parentheses.
"""
function getLParenLoc(x::AbstractCXXFunctionalCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXFunctionalCastExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractCXXFunctionalCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXFunctionalCastExpr_getRParenLoc(x))
end

function isListInitialization(x::AbstractCXXFunctionalCastExpr)
    @check_ptrs x
    return clang_CXXFunctionalCastExpr_isListInitialization(x)
end

# MaterializeTemporaryExpr
function getStorageDuration(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    return clang_MaterializeTemporaryExpr_getStorageDuration(x)
end

# ArrayTypeTraitExpr
function getTrait(x::AbstractArrayTypeTraitExpr)
    @check_ptrs x
    return clang_ArrayTypeTraitExpr_getTrait(x)
end

function getQueriedType(x::AbstractArrayTypeTraitExpr)
    @check_ptrs x
    return QualType(clang_ArrayTypeTraitExpr_getQueriedType(x))
end

"""
    getValue(x::AbstractArrayTypeTraitExpr)
Retrieve the computed value of the array type trait. The expression must not be
type-dependent: Clang asserts that, and the stored value is unspecified while the
queried type is still dependent.
"""
function getValue(x::AbstractArrayTypeTraitExpr)
    @check_ptrs x
    @assert !isTypeDependent(x) "array type trait value is unspecified while type-dependent"
    return clang_ArrayTypeTraitExpr_getValue(x)
end

"""
    getDimensionExpression(x::AbstractArrayTypeTraitExpr)
Retrieve the dimension operand of the trait. The returned carrier wraps NULL for a
trait that takes no dimension (`__array_rank`).
"""
function getDimensionExpression(x::AbstractArrayTypeTraitExpr)
    @check_ptrs x
    return Expr_(clang_ArrayTypeTraitExpr_getDimensionExpression(x))
end

# ExpressionTraitExpr
function getTrait(x::AbstractExpressionTraitExpr)
    @check_ptrs x
    return clang_ExpressionTraitExpr_getTrait(x)
end

function getQueriedExpression(x::AbstractExpressionTraitExpr)
    @check_ptrs x
    return Expr_(clang_ExpressionTraitExpr_getQueriedExpression(x))
end

function getValue(x::AbstractExpressionTraitExpr)
    @check_ptrs x
    return clang_ExpressionTraitExpr_getValue(x)
end


# CXXTypeidExpr (cont.)
"""
    isPotentiallyEvaluated(x::AbstractCXXTypeidExpr) -> Bool
Determine whether this `typeid` has a type operand that is potentially evaluated,
per C++11 [expr.typeid]p3.
"""
function isPotentiallyEvaluated(x::AbstractCXXTypeidExpr)
    @check_ptrs x
    return clang_CXXTypeidExpr_isPotentiallyEvaluated(x)
end

"""
    isMostDerived(x::AbstractCXXTypeidExpr, ctx::ASTContext) -> Bool
Best-effort check of whether the expression operand designates a most-derived
object; this is not a strong guarantee. Valid only when [`isTypeOperand`](@ref) is
`false`: Clang reads the expression arm of the operand union unchecked.
"""
function isMostDerived(x::AbstractCXXTypeidExpr, ctx::ASTContext)
    @check_ptrs x ctx
    @assert !isTypeOperand(x) "typeid expression must have an expression operand"
    return clang_CXXTypeidExpr_isMostDerived(x, ctx)
end

"""
    getTypeOperand(x::AbstractCXXTypeidExpr, ctx::ASTContext) -> QualType
Return the type operand of a `typeid(type)` expression after the adjustments the
standard requires (reference types and cv-qualifiers removed). Valid only when
[`isTypeOperand`](@ref) is `true`: Clang asserts that and then reads the type arm
of the operand union unchecked.
"""
function getTypeOperand(x::AbstractCXXTypeidExpr, ctx::ASTContext)
    @check_ptrs x ctx
    @assert isTypeOperand(x) "typeid expression must have a type operand"
    return QualType(clang_CXXTypeidExpr_getTypeOperand(x, ctx))
end

# CXXInheritedCtorInitExpr (cont.)
"""
    getConstructionKind(x::AbstractCXXInheritedCtorInitExpr) -> CXCXXConstructionKind
Return the kind of construction this inherited constructor performs: `VirtualBase`
when [`constructsVBase`](@ref) holds, `NonVirtualBase` otherwise.
"""
function getConstructionKind(x::AbstractCXXInheritedCtorInitExpr)
    @check_ptrs x
    return clang_CXXInheritedCtorInitExpr_getConstructionKind(x)
end

"""
    inheritedFromVBase(x::AbstractCXXInheritedCtorInitExpr) -> Bool
Whether the inherited constructor comes from a virtual base of the object being
constructed. If so the complete-object constructor performs the call, and this
expression passes no arguments.
"""
function inheritedFromVBase(x::AbstractCXXInheritedCtorInitExpr)
    @check_ptrs x
    return clang_CXXInheritedCtorInitExpr_inheritedFromVBase(x)
end

function getLocation(x::AbstractCXXInheritedCtorInitExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXInheritedCtorInitExpr_getLocation(x))
end

# CXXPseudoDestructorExpr (cont.)
"""
    getQualifier(x::AbstractCXXPseudoDestructorExpr) -> NestedNameSpecifier
Return the nested-name-specifier that qualifies the destructor name. The returned
carrier wraps NULL when [`hasQualifier`](@ref) is `false`.
"""
function getQualifier(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_CXXPseudoDestructorExpr_getQualifier(x))
end

"""
    getScopeTypeInfo(x::AbstractCXXPseudoDestructorExpr) -> TypeSourceInfo
Return the extra qualification of a `p->T::~T()` form. A scalar `T` cannot be part
of a nested-name-specifier, so it is stored as the expression's "scope type"
instead. The returned carrier wraps NULL when no such qualification was written.
"""
function getScopeTypeInfo(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXPseudoDestructorExpr_getScopeTypeInfo(x))
end

function getColonColonLoc(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXPseudoDestructorExpr_getColonColonLoc(x))
end

"""
    getDestroyedTypeInfo(x::AbstractCXXPseudoDestructorExpr) -> TypeSourceInfo
Return the source information for the type being destroyed. The storage is a union
of this and [`getDestroyedTypeIdentifier`](@ref), so at most one of the two is
non-NULL: a resolved destructor name yields this one, an unresolved dependent name
the identifier.
"""
function getDestroyedTypeInfo(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXPseudoDestructorExpr_getDestroyedTypeInfo(x))
end

"""
    getDestroyedTypeIdentifier(x::AbstractCXXPseudoDestructorExpr) -> IdentifierInfo
Return the written name of a dependent destroyed type that could not be resolved.
The returned carrier wraps NULL once the type resolved — see
[`getDestroyedTypeInfo`](@ref).
"""
function getDestroyedTypeIdentifier(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return IdentifierInfo(clang_CXXPseudoDestructorExpr_getDestroyedTypeIdentifier(x))
end

function getDestroyedTypeLoc(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXPseudoDestructorExpr_getDestroyedTypeLoc(x))
end

# SubstNonTypeTemplateParmExpr
function getNameLoc(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return SourceLocation(clang_SubstNonTypeTemplateParmExpr_getNameLoc(x))
end

"""
    getReplacement(x::AbstractSubstNonTypeTemplateParmExpr) -> Expr_
Return the expression the non-type template parameter was replaced with.
"""
function getReplacement(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return Expr_(clang_SubstNonTypeTemplateParmExpr_getReplacement(x))
end

"""
    getAssociatedDecl(x::AbstractSubstNonTypeTemplateParmExpr) -> Decl
Return the template-like entity that owns the whole substituted pattern, and hence
the template parameter list [`getIndex`](@ref) indexes into. Never NULL. Wrapped at
the `Decl` base — `resolve` or an explicit `castTo*` refines it.
"""
function getAssociatedDecl(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return Decl(clang_SubstNonTypeTemplateParmExpr_getAssociatedDecl(x))
end

"""
    getIndex(x::AbstractSubstNonTypeTemplateParmExpr) -> UInt32
Return the index of the replaced parameter within [`getAssociatedDecl`](@ref)'s
template parameter list.
"""
function getIndex(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return clang_SubstNonTypeTemplateParmExpr_getIndex(x)
end

"""
    getPackIndex(x::AbstractSubstNonTypeTemplateParmExpr) -> Union{UInt32,Nothing}
Return the position of this substitution inside the substituted argument pack, or
`nothing` when the replaced parameter was not a pack (the C++ optional is
disengaged).
"""
function getPackIndex(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    i = Ref{Cuint}(0)
    return clang_SubstNonTypeTemplateParmExpr_getPackIndex(x, i) ? i[] : nothing
end

"""
    getParameter(x::AbstractSubstNonTypeTemplateParmExpr) -> NonTypeTemplateParmDecl
Return the non-type template parameter that was replaced. Clang reaches it by
indexing [`getAssociatedDecl`](@ref)'s replaced parameter list with
[`getIndex`](@ref), which holds for every node the parser or the template
instantiator built.
"""
function getParameter(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return NonTypeTemplateParmDecl(clang_SubstNonTypeTemplateParmExpr_getParameter(x))
end

"""
    isReferenceParameter(x::AbstractSubstNonTypeTemplateParmExpr) -> Bool
Whether the replaced parameter was a reference parameter. For a class-typed
non-type parameter the value category alone cannot tell, so the flag is stored.
"""
function isReferenceParameter(x::AbstractSubstNonTypeTemplateParmExpr)
    @check_ptrs x
    return clang_SubstNonTypeTemplateParmExpr_isReferenceParameter(x)
end

"""
    getParameterType(x::AbstractSubstNonTypeTemplateParmExpr, ctx::ASTContext) -> QualType
Return the substituted type of the replaced template parameter: an lvalue reference
to the expression type when [`isReferenceParameter`](@ref) holds, otherwise the
unqualified expression type.
"""
function getParameterType(x::AbstractSubstNonTypeTemplateParmExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return QualType(clang_SubstNonTypeTemplateParmExpr_getParameterType(x, ctx))
end


# CXXOperatorCallExpr
"""
    isInfixBinaryOp(x::AbstractCXXOperatorCallExpr) -> Bool
Whether the call was written as an infix binary operator (`a + b`) rather than in
call, subscript or unary form.
"""
function isInfixBinaryOp(x::AbstractCXXOperatorCallExpr)
    @check_ptrs x
    return clang_CXXOperatorCallExpr_isInfixBinaryOp(x)
end

# CXXRewrittenBinaryOperator
"""
    isComparisonOp(x::AbstractCXXRewrittenBinaryOperator) -> Bool
Constant `true` on this class: a rewritten binary operator is always a comparison.
"""
function isComparisonOp(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return clang_CXXRewrittenBinaryOperator_isComparisonOp(x)
end

"""
    isAssignmentOp(x::AbstractCXXRewrittenBinaryOperator) -> Bool
Constant `false` on this class: a rewritten binary operator is never an assignment.
"""
function isAssignmentOp(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return clang_CXXRewrittenBinaryOperator_isAssignmentOp(x)
end

"""
    getOperatorLoc(x::AbstractCXXRewrittenBinaryOperator) -> SourceLocation
The location of the inner `==` / `<=>` operator the rewrite was built from,
reached through the decomposed form.
"""
function getOperatorLoc(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return SourceLocation(clang_CXXRewrittenBinaryOperator_getOperatorLoc(x))
end

# UserDefinedLiteral
"""
    getUDSuffixLoc(x::AbstractUserDefinedLiteral) -> SourceLocation
The location of the ud-suffix. A string literal may carry several identical
suffixes; this is the first.
"""
function getUDSuffixLoc(x::AbstractUserDefinedLiteral)
    @check_ptrs x
    return SourceLocation(clang_UserDefinedLiteral_getUDSuffixLoc(x))
end

# CXXDefaultArgExpr
"""
    getAdjustedRewrittenExpr(x::AbstractCXXDefaultArgExpr) -> Expr_
Return the rewritten default argument with its top-level `FullExpr` /
`ConstantExpr` wrapper stripped off. `hasRewrittenInit(x)` must hold — only a
default argument containing immediate (`consteval`) calls has a rewritten form.
"""
function getAdjustedRewrittenExpr(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    @assert hasRewrittenInit(x) "the default argument has no rewritten form"
    return Expr_(clang_CXXDefaultArgExpr_getAdjustedRewrittenExpr(x))
end

"""
    getUsedLocation(x::AbstractCXXDefaultArgExpr) -> SourceLocation
The location the default argument was used at (the call site). The node itself has
an empty source range, so this is the only location it carries.
"""
function getUsedLocation(x::AbstractCXXDefaultArgExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDefaultArgExpr_getUsedLocation(x))
end

# CXXDefaultInitExpr
"""
    getUsedLocation(x::AbstractCXXDefaultInitExpr) -> SourceLocation
The location the default member initializer was used at.
"""
function getUsedLocation(x::AbstractCXXDefaultInitExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDefaultInitExpr_getUsedLocation(x))
end

# ArrayTypeTraitExpr
"""
    getQueriedTypeSourceInfo(x::AbstractArrayTypeTraitExpr) -> TypeSourceInfo
The source information of the type the array trait was applied to.
"""
function getQueriedTypeSourceInfo(x::AbstractArrayTypeTraitExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_ArrayTypeTraitExpr_getQueriedTypeSourceInfo(x))
end

# CXXUnresolvedConstructExpr
"""
    getTypeSourceInfo(x::AbstractCXXUnresolvedConstructExpr) -> TypeSourceInfo
The source information of the type being constructed, as written.
"""
function getTypeSourceInfo(x::AbstractCXXUnresolvedConstructExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CXXUnresolvedConstructExpr_getTypeSourceInfo(x))
end

# PackExpansionExpr
"""
    getNumExpansions(x::AbstractPackExpansionExpr) -> Union{UInt32,Nothing}
Return the number of expansions this pack expansion will produce, or `nothing`
when the count is not known yet (the C++ optional is disengaged).
"""
function getNumExpansions(x::AbstractPackExpansionExpr)
    @check_ptrs x
    n = Ref{Cuint}(0)
    return clang_PackExpansionExpr_getNumExpansions(x, n) ? n[] : nothing
end

# MaterializeTemporaryExpr
"""
    getLifetimeExtendedTemporaryDecl(x::AbstractMaterializeTemporaryExpr) -> LifetimeExtendedTemporaryDecl
The declaration holding the extended temporary's state. The carrier wraps NULL
unless the temporary was lifetime-extended.
"""
function getLifetimeExtendedTemporaryDecl(x::AbstractMaterializeTemporaryExpr)
    @check_ptrs x
    ptr = clang_MaterializeTemporaryExpr_getLifetimeExtendedTemporaryDecl(x)
    return LifetimeExtendedTemporaryDecl(ptr)
end

"""
    getOrCreateValue(x::AbstractMaterializeTemporaryExpr, may_create::Bool) -> APValue
Return the storage holding the temporary's constant value, creating it when
`may_create` is true. [`getLifetimeExtendedTemporaryDecl`](@ref) must be non-NULL:
Clang asserts that the state holds the extended-temporary decl and then reads it
unchecked. The result is borrowed (owned by that decl) — never `dispose` it; the
carrier wraps NULL when `may_create` is false and no value has been cached yet.
"""
function getOrCreateValue(x::AbstractMaterializeTemporaryExpr, may_create::Bool)
    @check_ptrs x
    @assert getLifetimeExtendedTemporaryDecl(x).ptr != C_NULL "the temporary was not lifetime extended"
    return APValue(clang_MaterializeTemporaryExpr_getOrCreateValue(x, may_create))
end

"""
    isUsableInConstantExpressions(x::AbstractMaterializeTemporaryExpr, ctx::ASTContext) -> Bool
Whether the materialized temporary is usable in constant expressions, as specified
in C++20 [expr.const]p4.
"""
function isUsableInConstantExpressions(x::AbstractMaterializeTemporaryExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_MaterializeTemporaryExpr_isUsableInConstantExpressions(x, ctx)
end

# CXXFoldExpr
"""
    getNumExpansions(x::AbstractCXXFoldExpr) -> Union{UInt32,Nothing}
Return the number of expansions the fold will produce, or `nothing` when the count
is not known yet (the C++ optional is disengaged).
"""
function getNumExpansions(x::AbstractCXXFoldExpr)
    @check_ptrs x
    n = Ref{Cuint}(0)
    return clang_CXXFoldExpr_getNumExpansions(x, n) ? n[] : nothing
end

# CoroutineSuspendExpr
"""
    getOpaqueValue(x::AbstractCoroutineSuspendExpr) -> OpaqueValueExpr
The placeholder standing for the awaited operand inside the ready/suspend/resume
sub-expressions. The carrier wraps NULL for a dependent (uninstantiated) node.
"""
function getOpaqueValue(x::AbstractCoroutineSuspendExpr)
    @check_ptrs x
    return OpaqueValueExpr(clang_CoroutineSuspendExpr_getOpaqueValue(x))
end

# CoawaitExpr
"""
    isImplicit(x::AbstractCoawaitExpr) -> Bool
Whether the `co_await` was inserted by the compiler (a coroutine's initial and
final suspend points) rather than written in the source.
"""
function isImplicit(x::AbstractCoawaitExpr)
    @check_ptrs x
    return clang_CoawaitExpr_isImplicit(x)
end

# DependentCoawaitExpr
"""
    getOperand(x::AbstractDependentCoawaitExpr) -> Expr_
The awaited operand as written.
"""
function getOperand(x::AbstractDependentCoawaitExpr)
    @check_ptrs x
    return Expr_(clang_DependentCoawaitExpr_getOperand(x))
end

"""
    getOperatorCoawaitLookup(x::AbstractDependentCoawaitExpr) -> UnresolvedLookupExpr
The `operator co_await` overload set carried next to the operand until the
coroutine's promise type is known.
"""
function getOperatorCoawaitLookup(x::AbstractDependentCoawaitExpr)
    @check_ptrs x
    return UnresolvedLookupExpr(clang_DependentCoawaitExpr_getOperatorCoawaitLookup(x))
end

function getKeywordLoc(x::AbstractDependentCoawaitExpr)
    @check_ptrs x
    return SourceLocation(clang_DependentCoawaitExpr_getKeywordLoc(x))
end


# CXXDependentScopeMemberExpr
"""
    isImplicitAccess(x::AbstractCXXDependentScopeMemberExpr) -> Bool
Whether the member was accessed without a base object written in the source; the
operator location is invalid in that case.
"""
function isImplicitAccess(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return clang_CXXDependentScopeMemberExpr_isImplicitAccess(x)
end

"""
    getBase(x::AbstractCXXDependentScopeMemberExpr) -> Expr_
The base object of the member access, e.g. the `x` of `x.m`. Only an explicit
access has one: Clang asserts `!isImplicitAccess()` and then casts unchecked.
"""
function getBase(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    @assert !isImplicitAccess(x) "getBase requires an explicit access; this is an implicit member access"
    return Expr_(clang_CXXDependentScopeMemberExpr_getBase(x))
end

"""
    getBaseType(x::AbstractCXXDependentScopeMemberExpr) -> QualType
The type of the base object. It is present even for an implicit access.
"""
function getBaseType(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return QualType(clang_CXXDependentScopeMemberExpr_getBaseType(x))
end

function isArrow(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return clang_CXXDependentScopeMemberExpr_isArrow(x)
end

function getOperatorLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDependentScopeMemberExpr_getOperatorLoc(x))
end

"""
    getQualifier(x::AbstractCXXDependentScopeMemberExpr) -> NestedNameSpecifier
The nested-name-specifier qualifying the member name. The carrier wraps NULL when
the name carried no qualifier.
"""
function getQualifier(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_CXXDependentScopeMemberExpr_getQualifier(x))
end

"""
    getFirstQualifierFoundInScope(x::AbstractCXXDependentScopeMemberExpr) -> NamedDecl
What unqualified lookup found for the first component of the qualifier of an
`x.Base::f` access. The carrier wraps NULL when the node stores no such
declaration.
"""
function getFirstQualifierFoundInScope(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return NamedDecl(clang_CXXDependentScopeMemberExpr_getFirstQualifierFoundInScope(x))
end

function getMember(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return DeclarationName(clang_CXXDependentScopeMemberExpr_getMember(x))
end

function getMemberLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDependentScopeMemberExpr_getMemberLoc(x))
end

function getTemplateKeywordLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDependentScopeMemberExpr_getTemplateKeywordLoc(x))
end

function getLAngleLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDependentScopeMemberExpr_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXDependentScopeMemberExpr_getRAngleLoc(x))
end

function hasTemplateKeyword(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return clang_CXXDependentScopeMemberExpr_hasTemplateKeyword(x)
end

function hasExplicitTemplateArgs(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return clang_CXXDependentScopeMemberExpr_hasExplicitTemplateArgs(x)
end

function getNumTemplateArgs(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return clang_CXXDependentScopeMemberExpr_getNumTemplateArgs(x)
end

# DependentScopeDeclRefExpr
function getDeclName(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return DeclarationName(clang_DependentScopeDeclRefExpr_getDeclName(x))
end

"""
    getQualifier(x::AbstractDependentScopeDeclRefExpr) -> NestedNameSpecifier
The nested-name-specifier qualifying the name. It is always present: a
`DependentScopeDeclRefExpr` only exists for a qualified name.
"""
function getQualifier(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_DependentScopeDeclRefExpr_getQualifier(x))
end

function getTemplateKeywordLoc(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DependentScopeDeclRefExpr_getTemplateKeywordLoc(x))
end

function getLAngleLoc(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DependentScopeDeclRefExpr_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DependentScopeDeclRefExpr_getRAngleLoc(x))
end


# CXXConstructExpr
function setLocation(x::AbstractCXXConstructExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXConstructExpr_setLocation(x, loc)
end

function setElidable(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setElidable(x, v)
end

function setHadMultipleCandidates(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setHadMultipleCandidates(x, v)
end

function setListInitialization(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setListInitialization(x, v)
end

function setStdInitListInitialization(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setStdInitListInitialization(x, v)
end

function setRequiresZeroInitialization(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setRequiresZeroInitialization(x, v)
end

function setConstructionKind(x::AbstractCXXConstructExpr, kind::CXCXXConstructionKind)
    @check_ptrs x
    return clang_CXXConstructExpr_setConstructionKind(x, kind)
end

"""
    setArg(x::AbstractCXXConstructExpr, i, arg::AbstractExpr)
Overwrite the `i`-th constructor argument (0-based). `i` must be smaller than
`getNumArgs(x)`: Clang asserts that and then writes the trailing argument array
unchecked.
"""
function setArg(x::AbstractCXXConstructExpr, i::Integer, arg::AbstractExpr)
    @check_ptrs x arg
    @assert 0 <= i < getNumArgs(x) "constructor argument index $i out of range"
    return clang_CXXConstructExpr_setArg(x, i, arg)
end

function setIsImmediateEscalating(x::AbstractCXXConstructExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXConstructExpr_setIsImmediateEscalating(x, v)
end

function setParenOrBraceRange(x::AbstractCXXConstructExpr, r::SourceRange)
    @check_ptrs x
    return clang_CXXConstructExpr_setParenOrBraceRange(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
end

# CXXThisExpr
function setLocation(x::AbstractCXXThisExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXThisExpr_setLocation(x, loc)
end

function setImplicit(x::AbstractCXXThisExpr, v::Bool=true)
    @check_ptrs x
    return clang_CXXThisExpr_setImplicit(x, v)
end

# CXXBoolLiteralExpr
function setValue(x::AbstractCXXBoolLiteralExpr, v::Bool)
    @check_ptrs x
    return clang_CXXBoolLiteralExpr_setValue(x, v)
end

function setLocation(x::AbstractCXXBoolLiteralExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXBoolLiteralExpr_setLocation(x, loc)
end

# CXXNullPtrLiteralExpr
function setLocation(x::AbstractCXXNullPtrLiteralExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXNullPtrLiteralExpr_setLocation(x, loc)
end

# OverloadExpr
"""
    getDecl(x::AbstractOverloadExpr, i) -> NamedDecl
Return the `i`-th declaration of the unresolved lookup set (0-based). `i` must be
smaller than `getNumDecls(x)` - the C shim indexes the trailing result array with no
bounds check.
"""
function getDecl(x::AbstractOverloadExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumDecls(x) "lookup result index $i out of range"
    return NamedDecl(clang_OverloadExpr_getDecl(x, i))
end

"""
    getDeclAccess(x::AbstractOverloadExpr, i) -> CXAccessSpecifier
Return the access the `i`-th lookup result was found with (`AS_none` for a
namespace-scope overload set). Same bounds precondition as `getDecl`.
"""
function getDeclAccess(x::AbstractOverloadExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumDecls(x) "lookup result index $i out of range"
    return clang_OverloadExpr_getDeclAccess(x, i)
end

"""
    getTemplateArg(x::AbstractOverloadExpr, i) -> TemplateArgumentLoc
Return the `i`-th explicit template argument (0-based, `i < getNumTemplateArgs(x)`).
The carrier borrows AST-owned storage and is never disposed. When the name carried no
explicit template argument list the underlying array is NULL, which the index assert
rules out.
"""
function getTemplateArg(x::AbstractOverloadExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index $i out of range"
    return TemplateArgumentLoc(clang_OverloadExpr_getTemplateArg(x, i))
end

# CXXDependentScopeMemberExpr
"""
    getTemplateArg(x::AbstractCXXDependentScopeMemberExpr, i) -> TemplateArgumentLoc
Return the `i`-th explicit template argument (0-based, `i < getNumTemplateArgs(x)`).
The carrier borrows AST-owned storage and is never disposed.
"""
function getTemplateArg(x::AbstractCXXDependentScopeMemberExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index $i out of range"
    return TemplateArgumentLoc(clang_CXXDependentScopeMemberExpr_getTemplateArg(x, i))
end

# DependentScopeDeclRefExpr
"""
    getTemplateArg(x::AbstractDependentScopeDeclRefExpr, i) -> TemplateArgumentLoc
Return the `i`-th explicit template argument (0-based, `i < getNumTemplateArgs(x)`).
The carrier borrows AST-owned storage and is never disposed.
"""
function getTemplateArg(x::AbstractDependentScopeDeclRefExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index $i out of range"
    return TemplateArgumentLoc(clang_DependentScopeDeclRefExpr_getTemplateArg(x, i))
end
