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


# CXXRewrittenBinaryOperator
"""
    getOpcodeStr(x::AbstractCXXRewrittenBinaryOperator) -> String
Return the spelling of the operator as *written* (`"!="` for an `a != b` that C++20
rewrote into `!(a == b)`), not the spelling of the rewritten semantic form.
"""
function getOpcodeStr(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return unsafe_string(clang_CXXRewrittenBinaryOperator_getOpcodeStr(x))
end

# CXXUnresolvedConstructExpr
"""
    setLParenLoc(x::AbstractCXXUnresolvedConstructExpr, loc::SourceLocation)
Set the location of the left parenthesis that precedes the argument list.
"""
function setLParenLoc(x::AbstractCXXUnresolvedConstructExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXUnresolvedConstructExpr_setLParenLoc(x, loc)
end

"""
    setRParenLoc(x::AbstractCXXUnresolvedConstructExpr, loc::SourceLocation)
Set the location of the right parenthesis that follows the argument list.
"""
function setRParenLoc(x::AbstractCXXUnresolvedConstructExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXUnresolvedConstructExpr_setRParenLoc(x, loc)
end

"""
    setArg(x::AbstractCXXUnresolvedConstructExpr, i, arg::AbstractExpr)
Overwrite the `i`-th argument (0-based, `i < getNumArgs(x)`). Clang asserts that bound
and then writes into the trailing argument array unchecked.
"""
function setArg(x::AbstractCXXUnresolvedConstructExpr, i::Integer, arg::AbstractExpr)
    @check_ptrs x arg
    @assert 0 <= i < getNumArgs(x) "unresolved-construct argument index $i out of range"
    return clang_CXXUnresolvedConstructExpr_setArg(x, i, arg)
end

# MSPropertyRefExpr
"""
    isImplicitAccess(x::AbstractMSPropertyRefExpr) -> Bool
Return whether the `__declspec(property)` member is named with no written object
expression, i.e. the base is an implicit `this`.
"""
function isImplicitAccess(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return clang_MSPropertyRefExpr_isImplicitAccess(x)
end

"""
    getBaseExpr(x::AbstractMSPropertyRefExpr) -> Expr_
Return the object expression the property is named on. The carrier holds NULL when the
reference carries no base expression at all.
"""
function getBaseExpr(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return Expr_(clang_MSPropertyRefExpr_getBaseExpr(x))
end

"""
    getPropertyDecl(x::AbstractMSPropertyRefExpr) -> MSPropertyDecl
Return the `__declspec(property)` declaration this expression refers to.
"""
function getPropertyDecl(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return MSPropertyDecl(clang_MSPropertyRefExpr_getPropertyDecl(x))
end

"""
    isArrow(x::AbstractMSPropertyRefExpr) -> Bool
Return whether the property was accessed with `->` rather than `.`.
"""
function isArrow(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return clang_MSPropertyRefExpr_isArrow(x)
end

"""
    getMemberLoc(x::AbstractMSPropertyRefExpr) -> SourceLocation
Return the location of the property name.
"""
function getMemberLoc(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return SourceLocation(clang_MSPropertyRefExpr_getMemberLoc(x))
end

# MSPropertySubscriptExpr
"""
    getBase(x::AbstractMSPropertySubscriptExpr) -> Expr_
Return the subscripted expression: an `MSPropertyRefExpr`, or a nested
`MSPropertySubscriptExpr` for a multi-dimensional property.
"""
function getBase(x::AbstractMSPropertySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_MSPropertySubscriptExpr_getBase(x))
end

"""
    getIdx(x::AbstractMSPropertySubscriptExpr) -> Expr_
Return the index expression.
"""
function getIdx(x::AbstractMSPropertySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_MSPropertySubscriptExpr_getIdx(x))
end

"""
    getRBracketLoc(x::AbstractMSPropertySubscriptExpr) -> SourceLocation
Return the location of the closing bracket.
"""
function getRBracketLoc(x::AbstractMSPropertySubscriptExpr)
    @check_ptrs x
    return SourceLocation(clang_MSPropertySubscriptExpr_getRBracketLoc(x))
end

"""
    setRBracketLoc(x::AbstractMSPropertySubscriptExpr, loc::SourceLocation)
Set the location of the closing bracket.
"""
function setRBracketLoc(x::AbstractMSPropertySubscriptExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_MSPropertySubscriptExpr_setRBracketLoc(x, loc)
end

# CXXParenListInitExpr
"""
    getNumInitExprs(x::AbstractCXXParenListInitExpr) -> UInt32
Return the number of initializer expressions, counting the ones the compiler filled in
from default member initializers.
"""
function getNumInitExprs(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return clang_CXXParenListInitExpr_getNumInitExprs(x)
end

"""
    getInitExpr(x::AbstractCXXParenListInitExpr, i) -> Expr_
Return the `i`-th initializer expression (0-based, `i < getNumInitExprs(x)`).
"""
function getInitExpr(x::AbstractCXXParenListInitExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumInitExprs(x) "paren-list initializer index $i out of range"
    return Expr_(clang_CXXParenListInitExpr_getInitExpr(x, i))
end

"""
    getNumUserSpecifiedInitExprs(x::AbstractCXXParenListInitExpr) -> UInt32
Return the number of initializers actually written in the parenthesized list; never
greater than `getNumInitExprs(x)`.
"""
function getNumUserSpecifiedInitExprs(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return clang_CXXParenListInitExpr_getNumUserSpecifiedInitExprs(x)
end

"""
    getUserSpecifiedInitExpr(x::AbstractCXXParenListInitExpr, i) -> Expr_
Return the `i`-th written initializer (0-based, `i < getNumUserSpecifiedInitExprs(x)`).
"""
function getUserSpecifiedInitExpr(x::AbstractCXXParenListInitExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumUserSpecifiedInitExprs(x) "written initializer index $i out of range"
    return Expr_(clang_CXXParenListInitExpr_getUserSpecifiedInitExpr(x, i))
end

"""
    getInitLoc(x::AbstractCXXParenListInitExpr) -> SourceLocation
Return the location of the initialized entity.
"""
function getInitLoc(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return SourceLocation(clang_CXXParenListInitExpr_getInitLoc(x))
end

"""
    getArrayFiller(x::AbstractCXXParenListInitExpr) -> Expr_
Return the expression initializing the array elements past the written ones. The
carrier holds NULL unless that arm of the array-filler/union-field union is engaged.
"""
function getArrayFiller(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return Expr_(clang_CXXParenListInitExpr_getArrayFiller(x))
end

"""
    getInitializedFieldInUnion(x::AbstractCXXParenListInitExpr) -> FieldDecl
Return the union member this expression initializes. The carrier holds NULL unless that
arm of the array-filler/union-field union is engaged.
"""
function getInitializedFieldInUnion(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return FieldDecl(clang_CXXParenListInitExpr_getInitializedFieldInUnion(x))
end


# CXXTypeidExpr (cont.)
"""
    setSourceRange(x::AbstractCXXTypeidExpr, r::SourceRange)
Set the source range the `typeid` expression reports. This is the whole of its location
information: `getBeginLoc`/`getEndLoc` read the two ends of this range.
"""
function setSourceRange(x::AbstractCXXTypeidExpr, r::SourceRange)
    @check_ptrs x
    return clang_CXXTypeidExpr_setSourceRange(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
end

# CXXUuidofExpr
"""
    isTypeOperand(x::AbstractCXXUuidofExpr) -> Bool
Return whether this `__uuidof` expression was written with a type operand rather than an
expression operand. Discriminates the operand union the accessors below read.
"""
function isTypeOperand(x::AbstractCXXUuidofExpr)
    @check_ptrs x
    return clang_CXXUuidofExpr_isTypeOperand(x)
end

"""
    getTypeOperand(x::AbstractCXXUuidofExpr, ctx::ASTContext) -> QualType
Return the type operand of a `__uuidof(type)` expression after the adjustments Clang
applies (reference types and cv-qualifiers removed). Valid only when [`isTypeOperand`](@ref)
is `true`: Clang asserts that and then reads the type arm of the operand union unchecked.
"""
function getTypeOperand(x::AbstractCXXUuidofExpr, ctx::ASTContext)
    @check_ptrs x ctx
    @assert isTypeOperand(x) "__uuidof expression must have a type operand"
    return QualType(clang_CXXUuidofExpr_getTypeOperand(x, ctx))
end

"""
    getTypeOperandSourceInfo(x::AbstractCXXUuidofExpr) -> TypeSourceInfo
Return the written type operand of a `__uuidof(type)` expression. Valid only when
[`isTypeOperand`](@ref) is `true`: Clang reads the operand union unchecked.
"""
function getTypeOperandSourceInfo(x::AbstractCXXUuidofExpr)
    @check_ptrs x
    @assert isTypeOperand(x) "__uuidof expression must have a type operand"
    return TypeSourceInfo(clang_CXXUuidofExpr_getTypeOperandSourceInfo(x))
end

"""
    getExprOperand(x::AbstractCXXUuidofExpr) -> Expr_
Return the expression operand of a `__uuidof(expr)` expression. Valid only when
[`isTypeOperand`](@ref) is `false`: Clang reads the operand union unchecked.
"""
function getExprOperand(x::AbstractCXXUuidofExpr)
    @check_ptrs x
    @assert !isTypeOperand(x) "__uuidof expression must have an expression operand"
    return Expr_(clang_CXXUuidofExpr_getExprOperand(x))
end

"""
    getGuidDecl(x::AbstractCXXUuidofExpr) -> MSGuidDecl
Return the GUID declaration the operand's `__declspec(uuid(...))` attribute resolved to.
The carrier holds NULL when the operand type carried no uuid attribute.
"""
function getGuidDecl(x::AbstractCXXUuidofExpr)
    @check_ptrs x
    return MSGuidDecl(clang_CXXUuidofExpr_getGuidDecl(x))
end

"""
    setSourceRange(x::AbstractCXXUuidofExpr, r::SourceRange)
Set the source range the `__uuidof` expression reports. This is the whole of its location
information: `getBeginLoc`/`getEndLoc` read the two ends of this range.
"""
function setSourceRange(x::AbstractCXXUuidofExpr, r::SourceRange)
    @check_ptrs x
    return clang_CXXUuidofExpr_setSourceRange(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
end

# CXXThisExpr (cont.)
"""
    CXXThisExpr(ctx::ASTContext, loc::SourceLocation, ty::QualType, is_implicit::Bool) -> CXXThisExpr
Build a new `this` expression of type `ty` in `ctx`'s arena. The node is arena-allocated:
there is no `dispose`.
"""
function CXXThisExpr(ctx::ASTContext, loc::SourceLocation, ty::QualType, is_implicit::Bool)
    @check_ptrs ctx ty
    return CXXThisExpr(clang_CXXThisExpr_Create(ctx, loc, ty, is_implicit))
end

"""
    CXXThisExpr(ctx::ASTContext) -> CXXThisExpr
Build an empty `this` expression shell in `ctx`'s arena, for a deserializer to fill in.
Every payload accessor (`getLocation`, `isImplicit`, `getType`) reads uninitialized storage
until it does. The node is arena-allocated: there is no `dispose`.
"""
function CXXThisExpr(ctx::ASTContext)
    @check_ptrs ctx
    return CXXThisExpr(clang_CXXThisExpr_CreateEmpty(ctx))
end

# CXXTemporary (cont.)
"""
    CXXTemporary(ctx::ASTContext, dtor::AbstractCXXDestructorDecl) -> CXXTemporary
Build a temporary-binding record naming `dtor` as the destructor to run, in `ctx`'s arena.
The record is arena-allocated: there is no `dispose`.
"""
function CXXTemporary(ctx::ASTContext, dtor::AbstractCXXDestructorDecl)
    @check_ptrs ctx dtor
    return CXXTemporary(clang_CXXTemporary_Create(ctx, dtor))
end

"""
    setDestructor(x::AbstractCXXTemporary, dtor::AbstractCXXDestructorDecl)
Set the destructor to run on the bound temporary.
"""
function setDestructor(x::AbstractCXXTemporary, dtor::AbstractCXXDestructorDecl)
    @check_ptrs x dtor
    return clang_CXXTemporary_setDestructor(x, dtor)
end

# CXXBindTemporaryExpr (cont.)
"""
    setTemporary(x::AbstractCXXBindTemporaryExpr, t::AbstractCXXTemporary)
Set the temporary-binding record this expression carries.
"""
function setTemporary(x::AbstractCXXBindTemporaryExpr, t::AbstractCXXTemporary)
    @check_ptrs x t
    return clang_CXXBindTemporaryExpr_setTemporary(x, t)
end

"""
    setSubExpr(x::AbstractCXXBindTemporaryExpr, val::AbstractExpr)
Set the expression whose result is bound to the temporary.
"""
function setSubExpr(x::AbstractCXXBindTemporaryExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_CXXBindTemporaryExpr_setSubExpr(x, val)
end

# CXXFunctionalCastExpr (cont.)
"""
    setLParenLoc(x::AbstractCXXFunctionalCastExpr, loc::SourceLocation)
Set the location of the `(` preceding the cast operand. [`isListInitialization`](@ref) is
defined as this location being invalid, so this setter also decides how the cast reports
its initialization form.
"""
function setLParenLoc(x::AbstractCXXFunctionalCastExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXFunctionalCastExpr_setLParenLoc(x, loc)
end

"""
    setRParenLoc(x::AbstractCXXFunctionalCastExpr, loc::SourceLocation)
Set the location of the `)` following the cast operand.
"""
function setRParenLoc(x::AbstractCXXFunctionalCastExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXFunctionalCastExpr_setRParenLoc(x, loc)
end

# CXXNewExpr (cont.)
"""
    setOperatorNew(x::AbstractCXXNewExpr, fd::AbstractFunctionDecl)
Set the allocation function this `new` expression calls.
"""
function setOperatorNew(x::AbstractCXXNewExpr, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_CXXNewExpr_setOperatorNew(x, fd)
end

"""
    setOperatorDelete(x::AbstractCXXNewExpr, fd::AbstractFunctionDecl)
Set the deallocation function this `new` expression calls if the initialization throws.
"""
function setOperatorDelete(x::AbstractCXXNewExpr, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_CXXNewExpr_setOperatorDelete(x, fd)
end

# CXXParenListInitExpr (cont.)
"""
    setArrayFiller(x::AbstractCXXParenListInitExpr, filler::AbstractExpr)
Set the expression initializing the array elements past the written ones. This engages the
array-filler arm of the array-filler/union-field union, so
[`getInitializedFieldInUnion`](@ref) reads NULL afterwards.
"""
function setArrayFiller(x::AbstractCXXParenListInitExpr, filler::AbstractExpr)
    @check_ptrs x filler
    return clang_CXXParenListInitExpr_setArrayFiller(x, filler)
end

"""
    setInitializedFieldInUnion(x::AbstractCXXParenListInitExpr, fd::AbstractFieldDecl)
Set the union member this expression initializes. This engages the union-field arm of the
array-filler/union-field union, so [`getArrayFiller`](@ref) reads NULL afterwards.
"""
function setInitializedFieldInUnion(x::AbstractCXXParenListInitExpr, fd::AbstractFieldDecl)
    @check_ptrs x fd
    return clang_CXXParenListInitExpr_setInitializedFieldInUnion(x, fd)
end


# --- ExprCXX-l sweep: the name-info / qualifier-extent tail of the dependent-name
# expressions, plus the node-synthesis factories ---

# CXXRewrittenBinaryOperator (cont.)
"""
    getInnerBinOp(x::AbstractCXXRewrittenBinaryOperator) -> Expr_
Return the inner `==` or `<=>` operator expression the rewritten operator decomposes into.
The `DecomposedForm` aggregate crosses as its parts: the original opcode through `getOpcode`,
the original operands through `getLHS`/`getRHS`, and the inner operator here.
"""
function getInnerBinOp(x::AbstractCXXRewrittenBinaryOperator)
    @check_ptrs x
    return Expr_(clang_CXXRewrittenBinaryOperator_getInnerBinOp(x))
end

# CXXConstCastExpr (cont.)
"""
    CXXConstCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, op::AbstractExpr,
                     written_ty::TypeSourceInfo, loc::SourceLocation, rparen::SourceLocation,
                     angles::SourceRange) -> CXXConstCastExpr
Build a `const_cast<T>(op)` node of type `ty` and value kind `vk` in `ctx`'s arena, with the
written destination type `written_ty` and the `<...>` extent `angles`. The node is
arena-allocated: there is no `dispose`.
"""
function CXXConstCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, op::AbstractExpr,
                          written_ty::TypeSourceInfo, loc::SourceLocation, rparen::SourceLocation,
                          angles::SourceRange)
    @check_ptrs ctx ty op written_ty
    r = CXSourceRange_(angles.begin_loc.ptr, angles.end_loc.ptr)
    return CXXConstCastExpr(clang_CXXConstCastExpr_Create(ctx, ty, vk, op, written_ty, loc,
                                                          rparen, r))
end

# CXXBoolLiteralExpr (cont.)
"""
    CXXBoolLiteralExpr(ctx::ASTContext, val::Bool, ty::QualType, loc::SourceLocation)
Build a `true`/`false` literal of type `ty` at `loc` in `ctx`'s arena. The node is
arena-allocated: there is no `dispose`.
"""
function CXXBoolLiteralExpr(ctx::ASTContext, val::Bool, ty::QualType, loc::SourceLocation)
    @check_ptrs ctx ty
    return CXXBoolLiteralExpr(clang_CXXBoolLiteralExpr_Create(ctx, val, ty, loc))
end

# MSPropertyRefExpr (cont.)
"""
    getQualifierRange(x::AbstractMSPropertyRefExpr) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the property name.
`NestedNameSpecifierLoc` has no handle of its own, so it crosses as its source range; this
class exposes no separate qualifier accessor. Invalid when the name was written unqualified.
"""
function getQualifierRange(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    r = clang_MSPropertyRefExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# CXXDefaultArgExpr (cont.)
"""
    CXXDefaultArgExpr(ctx::ASTContext, loc::SourceLocation, param::AbstractParmVarDecl,
                      rewritten::Union{Nothing,AbstractExpr}, used_ctx::DeclContext)
Build a use of `param`'s default argument at `loc`, in `ctx`'s arena, as used from
`used_ctx`. A non-`nothing` `rewritten` becomes the rewritten initializer and sets
`hasRewrittenInit`. `param` must carry a parsed default argument: Clang's constructor reads
`getDefaultArg()`'s type, value kind and object kind unchecked (Invariant 3). The node is
arena-allocated: there is no `dispose`.
"""
function CXXDefaultArgExpr(ctx::ASTContext, loc::SourceLocation, param::AbstractParmVarDecl,
                           rewritten::Union{Nothing,AbstractExpr}, used_ctx::DeclContext)
    @check_ptrs ctx param used_ctx
    @assert hasDefaultArg(param) "parameter must carry a parsed default argument"
    rw = rewritten === nothing ? C_NULL : rewritten
    return CXXDefaultArgExpr(clang_CXXDefaultArgExpr_Create(ctx, loc, param, rw, used_ctx))
end

# CXXDefaultInitExpr (cont.)
"""
    CXXDefaultInitExpr(ctx::ASTContext, loc::SourceLocation, field::AbstractFieldDecl,
                       used_ctx::DeclContext, rewritten::Union{Nothing,AbstractExpr})
Build a use of `field`'s in-class initializer at `loc`, in `ctx`'s arena, as used from
`used_ctx`. A non-`nothing` `rewritten` becomes the rewritten initializer and sets
`hasRewrittenInit`. `field` must carry an in-class initializer: Clang asserts it in the
constructor and `getExpr` reaches through it unchecked (Invariant 3). The node is
arena-allocated: there is no `dispose`.
"""
function CXXDefaultInitExpr(ctx::ASTContext, loc::SourceLocation, field::AbstractFieldDecl,
                            used_ctx::DeclContext, rewritten::Union{Nothing,AbstractExpr})
    @check_ptrs ctx field used_ctx
    @assert hasInClassInitializer(field) "field must carry an in-class initializer"
    rw = rewritten === nothing ? C_NULL : rewritten
    return CXXDefaultInitExpr(clang_CXXDefaultInitExpr_Create(ctx, loc, field, used_ctx, rw))
end

# CXXBindTemporaryExpr (cont.)
"""
    CXXBindTemporaryExpr(ctx::ASTContext, temp::AbstractCXXTemporary, sub::AbstractExpr)
Bind `sub` to the temporary record `temp` — the node that runs `temp`'s destructor at the end
of the full expression — in `ctx`'s arena. The node is arena-allocated: there is no `dispose`.
"""
function CXXBindTemporaryExpr(ctx::ASTContext, temp::AbstractCXXTemporary, sub::AbstractExpr)
    @check_ptrs ctx temp sub
    return CXXBindTemporaryExpr(clang_CXXBindTemporaryExpr_Create(ctx, temp, sub))
end

# LambdaExpr (cont.)
"""
    getNumExplicitTemplateParameters(x::AbstractLambdaExpr) -> Unsigned
Return how many template parameters the lambda spells out in a `[]<...>` list. Zero for a
non-generic lambda, and zero for a generic lambda whose parameters were all invented by
`auto`.
"""
function getNumExplicitTemplateParameters(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_getNumExplicitTemplateParameters(x)
end

"""
    getExplicitTemplateParameter(x::AbstractLambdaExpr, i) -> NamedDecl
Return the `i`-th explicitly written template parameter (0-based, following the C++ API). The
shim indexes the array unchecked, so `i < getNumExplicitTemplateParameters(x)`.
"""
function getExplicitTemplateParameter(x::AbstractLambdaExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumExplicitTemplateParameters(x) "template parameter index out of range"
    return NamedDecl(clang_LambdaExpr_getExplicitTemplateParameter(x, i))
end

# CXXPseudoDestructorExpr (cont.)
"""
    getQualifierRange(x::AbstractCXXPseudoDestructorExpr) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the destructor name — the
source-range companion of `getQualifier`. Invalid when `hasQualifier(x)` is false; note that
a scalar destroyed type keeps its written qualification in the scope type instead.
"""
function getQualifierRange(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    r = clang_CXXPseudoDestructorExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# OverloadExpr (cont.)
"""
    getNameInfo(x::AbstractOverloadExpr) -> DeclarationNameInfo
Return the full name-plus-location of the name that was looked up — the aggregate whose parts
`getName` and `getNameLoc` expose separately. The result is an owned heap box: call `dispose`
on it after use.
"""
function getNameInfo(x::AbstractOverloadExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_OverloadExpr_getNameInfo(x))
end

"""
    getQualifierRange(x::AbstractOverloadExpr) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the looked-up name — the
source-range companion of `getQualifier`. Invalid when the name was written unqualified.
"""
function getQualifierRange(x::AbstractOverloadExpr)
    @check_ptrs x
    r = clang_OverloadExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# DependentScopeDeclRefExpr (cont.)
"""
    getNameInfo(x::AbstractDependentScopeDeclRefExpr) -> DeclarationNameInfo
Return the full name-plus-location of the referenced name — the aggregate whose parts
`getDeclName` and `getLocation` expose separately. The result is an owned heap box: call
`dispose` on it after use.
"""
function getNameInfo(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_DependentScopeDeclRefExpr_getNameInfo(x))
end

"""
    getQualifierRange(x::AbstractDependentScopeDeclRefExpr) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the name — the source-range
companion of `getQualifier`. The `T::` of a dependent reference is always written, so this
range is valid.
"""
function getQualifierRange(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    r = clang_DependentScopeDeclRefExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# CXXDependentScopeMemberExpr (cont.)
"""
    getMemberNameInfo(x::AbstractCXXDependentScopeMemberExpr) -> DeclarationNameInfo
Return the full name-plus-location of the member being accessed — the aggregate whose parts
`getMember` and `getMemberLoc` expose separately. The result is an owned heap box: call
`dispose` on it after use.
"""
function getMemberNameInfo(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_CXXDependentScopeMemberExpr_getMemberNameInfo(x))
end

"""
    getQualifierRange(x::AbstractCXXDependentScopeMemberExpr) -> SourceRange
Return the extent of the nested-name-specifier that qualifies the member name — the
source-range companion of `getQualifier`. Invalid when the member name was written
unqualified.
"""
function getQualifierRange(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    r = clang_CXXDependentScopeMemberExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end


# --- Named-cast factories (clang/AST/ExprCXX.h) ---
# Every node built below lives in the ASTContext arena, so none of them is disposed. The
# `CreateEmpty` shells leave the operand, the written type, the base-specifier slots and the
# trailing FPOptionsOverride uninitialized (clang fills them from the serialized AST), so
# only the node's statement class may be read straight away.

# CXXStaticCastExpr
"""
    CXXStaticCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                      op::AbstractExpr, written_ty::TypeSourceInfo, fp_features::Integer,
                      loc::SourceLocation, rparen::SourceLocation, angles::SourceRange)
Build a `static_cast<T>(op)` node of type `ty` and value kind `vk` in `ctx`'s arena, with the written
destination type `written_ty` and the `<...>` extent `angles`. `fp_features` is the `FPOptionsOverride`
opaque encoding: pass `0` for "no override", the only value that leaves `hasStoredFPFeatures` false.
The factory passes no inheritance path, so `k` must not be one of the base-path cast kinds
(`CK_DerivedToBase` and friends), which clang asserts on. The node is arena-allocated: there is no
`dispose`.
"""
function CXXStaticCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                           op::AbstractExpr, written_ty::TypeSourceInfo, fp_features::Integer,
                           loc::SourceLocation, rparen::SourceLocation, angles::SourceRange)
    @check_ptrs ctx ty op written_ty
    r = CXSourceRange_(angles.begin_loc.ptr, angles.end_loc.ptr)
    return CXXStaticCastExpr(clang_CXXStaticCastExpr_Create(ctx, ty, vk, k, op, written_ty,
                                                            fp_features, loc, rparen, r))
end

"""
    CXXStaticCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
Build the empty `static_cast` shell clang deserializes into. The operand, the written type, the
`path_size` base-specifier slots and the trailing `FPOptionsOverride` are left uninitialized, so only
the node's statement class may be read straight away.
"""
function CXXStaticCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CXXStaticCastExpr(clang_CXXStaticCastExpr_CreateEmpty(ctx, path_size, has_fp_features))
end

# CXXDynamicCastExpr
"""
    CXXDynamicCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                       op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                       rparen::SourceLocation, angles::SourceRange)
Build a `dynamic_cast<T>(op)` node in `ctx`'s arena — the same shape as the `static_cast` factory
minus the `FPOptionsOverride`, which this node has no storage for. Same empty-path precondition on
`k`. The node is arena-allocated: there is no `dispose`.
"""
function CXXDynamicCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                            op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                            rparen::SourceLocation, angles::SourceRange)
    @check_ptrs ctx ty op written_ty
    r = CXSourceRange_(angles.begin_loc.ptr, angles.end_loc.ptr)
    return CXXDynamicCastExpr(clang_CXXDynamicCastExpr_Create(ctx, ty, vk, k, op, written_ty, loc,
                                                              rparen, r))
end

"""
    CXXDynamicCastExpr(ctx::ASTContext, path_size::Integer)
Build the empty `dynamic_cast` shell clang deserializes into; the same uninitialized payload as the
`static_cast` shell, without the FP-features slot.
"""
function CXXDynamicCastExpr(ctx::ASTContext, path_size::Integer)
    @check_ptrs ctx
    return CXXDynamicCastExpr(clang_CXXDynamicCastExpr_CreateEmpty(ctx, path_size))
end

# CXXReinterpretCastExpr
"""
    CXXReinterpretCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                           op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                           rparen::SourceLocation, angles::SourceRange)
Build a `reinterpret_cast<T>(op)` node in `ctx`'s arena; same shape and same empty-path precondition
on `k` as the `dynamic_cast` factory. The node is arena-allocated: there is no `dispose`.
"""
function CXXReinterpretCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                                op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                                rparen::SourceLocation, angles::SourceRange)
    @check_ptrs ctx ty op written_ty
    r = CXSourceRange_(angles.begin_loc.ptr, angles.end_loc.ptr)
    return CXXReinterpretCastExpr(clang_CXXReinterpretCastExpr_Create(ctx, ty, vk, k, op, written_ty,
                                                                      loc, rparen, r))
end

"""
    CXXReinterpretCastExpr(ctx::ASTContext, path_size::Integer)
Build the empty `reinterpret_cast` shell clang deserializes into; the same uninitialized payload as
the `dynamic_cast` shell.
"""
function CXXReinterpretCastExpr(ctx::ASTContext, path_size::Integer)
    @check_ptrs ctx
    return CXXReinterpretCastExpr(clang_CXXReinterpretCastExpr_CreateEmpty(ctx, path_size))
end

# CXXConstCastExpr (cont.)
"""
    CXXConstCastExpr(ctx::ASTContext)
Build the empty `const_cast` shell clang deserializes into. A `const_cast` carries neither a base path
nor FP features, so the shell takes no size arguments; the operand and the written type are left
uninitialized, so only the node's statement class may be read straight away.
"""
function CXXConstCastExpr(ctx::ASTContext)
    @check_ptrs ctx
    return CXXConstCastExpr(clang_CXXConstCastExpr_CreateEmpty(ctx))
end

# CXXAddrspaceCastExpr
"""
    CXXAddrspaceCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                         op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                         rparen::SourceLocation, angles::SourceRange)
Build an `addrspace_cast<T>(op)` node in `ctx`'s arena. This cast never carries an inheritance path,
so clang's factory takes none. The node is arena-allocated: there is no `dispose`.
"""
function CXXAddrspaceCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                              op::AbstractExpr, written_ty::TypeSourceInfo, loc::SourceLocation,
                              rparen::SourceLocation, angles::SourceRange)
    @check_ptrs ctx ty op written_ty
    r = CXSourceRange_(angles.begin_loc.ptr, angles.end_loc.ptr)
    return CXXAddrspaceCastExpr(clang_CXXAddrspaceCastExpr_Create(ctx, ty, vk, k, op, written_ty,
                                                                  loc, rparen, r))
end

"""
    CXXAddrspaceCastExpr(ctx::ASTContext)
Build the empty `addrspace_cast` shell clang deserializes into; no base path and no FP features, so no
size arguments, and the same uninitialized payload as the `const_cast` shell.
"""
function CXXAddrspaceCastExpr(ctx::ASTContext)
    @check_ptrs ctx
    return CXXAddrspaceCastExpr(clang_CXXAddrspaceCastExpr_CreateEmpty(ctx))
end

# CXXFunctionalCastExpr (cont.)
"""
    CXXFunctionalCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind,
                          written_ty::TypeSourceInfo, k::CXCastKind, op::AbstractExpr,
                          fp_features::Integer, lparen::SourceLocation, rparen::SourceLocation)
Build the functional-notation cast `T(op)` in `ctx`'s arena. `written_ty` is the destination type as
spelled and `fp_features` the `FPOptionsOverride` opaque encoding (`0` for "no override"). A valid
`lparen` is what tells `T(x)` apart from list-initialization `T{x}`: `isListInitialization` reads
`lparen.isInvalid()`. Same empty-path precondition on `k` as the named-cast factories. The node is
arena-allocated: there is no `dispose`.
"""
function CXXFunctionalCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind,
                               written_ty::TypeSourceInfo, k::CXCastKind, op::AbstractExpr,
                               fp_features::Integer, lparen::SourceLocation,
                               rparen::SourceLocation)
    @check_ptrs ctx ty written_ty op
    return CXXFunctionalCastExpr(clang_CXXFunctionalCastExpr_Create(ctx, ty, vk, written_ty, k, op,
                                                                    fp_features, lparen, rparen))
end

"""
    CXXFunctionalCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
Build the empty functional-cast shell clang deserializes into; the same uninitialized payload as the
`static_cast` shell.
"""
function CXXFunctionalCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CXXFunctionalCastExpr(clang_CXXFunctionalCastExpr_CreateEmpty(ctx, path_size,
                                                                         has_fp_features))
end

# FunctionParmPackExpr
"""
    FunctionParmPackExpr(ctx::ASTContext, ty::QualType, param_pack::AbstractVarDecl,
                         name_loc::SourceLocation, params::Vector{<:AbstractVarDecl})
Build the reference to `param_pack` — a function parameter pack or init-capture pack that has been
substituted but not yet expanded — of type `ty` at `name_loc`, in `ctx`'s arena. The handles in
`params` are copied into the node's trailing storage, so `params` need not outlive the call and may be
empty. The node is arena-allocated: there is no `dispose`.
"""
function FunctionParmPackExpr(ctx::ASTContext, ty::QualType, param_pack::AbstractVarDecl,
                              name_loc::SourceLocation, params::Vector{<:AbstractVarDecl})
    @check_ptrs ctx ty param_pack
    @assert all(p -> p.ptr != C_NULL, params) "a parameter pack expansion holds no null slot"
    buf = CXVarDecl[p.ptr for p in params]
    return FunctionParmPackExpr(clang_FunctionParmPackExpr_Create(ctx, ty, param_pack, name_loc, buf,
                                                                  length(buf)))
end

"""
    getParameterPack(x::AbstractFunctionParmPackExpr) -> VarDecl
The parameter pack this expression refers to.
"""
function getParameterPack(x::AbstractFunctionParmPackExpr)
    @check_ptrs x
    return VarDecl(clang_FunctionParmPackExpr_getParameterPack(x))
end

"""
    getParameterPackLocation(x::AbstractFunctionParmPackExpr) -> SourceLocation
The location at which the parameter pack was named.
"""
function getParameterPackLocation(x::AbstractFunctionParmPackExpr)
    @check_ptrs x
    return SourceLocation(clang_FunctionParmPackExpr_getParameterPackLocation(x))
end

"""
    getNumExpansions(x::AbstractFunctionParmPackExpr) -> Int
The number of parameters the pack expanded into — the count half of the count + index pair with
`getExpansion`. The count is exact and no slot is null.
"""
function getNumExpansions(x::AbstractFunctionParmPackExpr)
    @check_ptrs x
    return Int(clang_FunctionParmPackExpr_getNumExpansions(x))
end

"""
    getExpansion(x::AbstractFunctionParmPackExpr, i::Integer) -> VarDecl
Return the `i`-th parameter the pack expanded into (0-based, following the C++ API). The shim indexes
the trailing array unchecked, so `i < getNumExpansions(x)`.
"""
function getExpansion(x::AbstractFunctionParmPackExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumExpansions(x) "parameter pack expansion index out of range"
    return VarDecl(clang_FunctionParmPackExpr_getExpansion(x, i))
end


# SubstNonTypeTemplateParmPackExpr
"""
    SubstNonTypeTemplateParmPackExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind,
                                     name_loc::SourceLocation, args::Vector{TemplateArgument},
                                     assoc::AbstractDecl, index::Integer)
Build the reference to a non-type template parameter pack that has been substituted with the
argument pack `args` but not yet expanded, of type `ty` and value kind `vk`, at `name_loc`, in `ctx`'s
arena. `assoc` is the template-like entity that owns the pattern being substituted and `index` the
position of the replaced parameter in its parameter list. The handles in `args` are copied into `ctx`
with `TemplateArgument::CreatePackCopy`, so `args` keeps its own boxes and may be empty. The node is
arena-allocated: there is no `dispose`.
"""
function SubstNonTypeTemplateParmPackExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind,
                                          name_loc::SourceLocation, args::Vector{TemplateArgument},
                                          assoc::AbstractDecl, index::Integer)
    @check_ptrs ctx ty assoc
    @assert all(a -> a.ptr != C_NULL, args) "a substituted argument pack holds no null slot"
    buf = CXTemplateArgument[a.ptr for a in args]
    p = clang_SubstNonTypeTemplateParmPackExpr_Create(ctx, ty, vk, name_loc, buf, length(buf), assoc,
                                                      index)
    return SubstNonTypeTemplateParmPackExpr(p)
end

"""
    getAssociatedDecl(x::AbstractSubstNonTypeTemplateParmPackExpr) -> Decl
The template-like entity that owns the whole pattern being substituted; never NULL, since clang's
constructor asserts it.
"""
function getAssociatedDecl(x::AbstractSubstNonTypeTemplateParmPackExpr)
    @check_ptrs x
    return Decl(clang_SubstNonTypeTemplateParmPackExpr_getAssociatedDecl(x))
end

"""
    getIndex(x::AbstractSubstNonTypeTemplateParmPackExpr) -> UInt32
The index of the replaced parameter in `getAssociatedDecl(x)`'s parameter list. It matches
`getIndex(getParameterPack(x))`.
"""
function getIndex(x::AbstractSubstNonTypeTemplateParmPackExpr)
    @check_ptrs x
    return clang_SubstNonTypeTemplateParmPackExpr_getIndex(x)
end

"""
    getParameterPack(x::AbstractSubstNonTypeTemplateParmPackExpr) -> NonTypeTemplateParmDecl
The non-type template parameter pack being substituted. The accessor walks
`getAssociatedDecl(x)`'s replaced parameter list and `cast<>`s the entry at `getIndex(x)`, both
unchecked: the associated declaration must be a template-like entity holding a
`NonTypeTemplateParmDecl` at that index. Every node the template instantiator builds satisfies that;
a hand-built one only does when it was given a matching associated declaration and index, which no
accessor makes observable, so this precondition is documented and not asserted.
"""
function getParameterPack(x::AbstractSubstNonTypeTemplateParmPackExpr)
    @check_ptrs x
    @assert getAssociatedDecl(x).ptr != C_NULL "the substituted pack must carry its associated decl"
    return NonTypeTemplateParmDecl(clang_SubstNonTypeTemplateParmPackExpr_getParameterPack(x))
end

"""
    getParameterPackLocation(x::AbstractSubstNonTypeTemplateParmPackExpr) -> SourceLocation
The location at which the parameter pack was named.
"""
function getParameterPackLocation(x::AbstractSubstNonTypeTemplateParmPackExpr)
    @check_ptrs x
    return SourceLocation(clang_SubstNonTypeTemplateParmPackExpr_getParameterPackLocation(x))
end

"""
    getArgumentPack(x::AbstractSubstNonTypeTemplateParmPackExpr) -> TemplateArgument
The template argument pack holding the substituted arguments. This function allocates and one should
call `dispose` to release the resources after using this object. The box views the node's
arena-allocated pack elements, so it must not outlive the `ASTContext`.
"""
function getArgumentPack(x::AbstractSubstNonTypeTemplateParmPackExpr)
    @check_ptrs x
    return TemplateArgument(clang_SubstNonTypeTemplateParmPackExpr_getArgumentPack(x))
end

# CXXParenListInitExpr (cont.)
"""
    CXXParenListInitExpr(ctx::ASTContext, args::Vector{<:AbstractExpr}, ty::QualType,
                         num_user_specified::Integer, init_loc::SourceLocation,
                         lparen::SourceLocation, rparen::SourceLocation)
Build the parenthesized aggregate initialization `T(a, b, ...)` of type `ty` in `ctx`'s arena. `args`
holds every initializer, the leading `num_user_specified` of which were written in the source and the
rest filled in from default member initializers; clang asserts `num_user_specified <= length(args)`.
The handles are copied into the node's trailing storage, so `args` need not outlive the call. The
node is arena-allocated: there is no `dispose`.
"""
function CXXParenListInitExpr(ctx::ASTContext, args::Vector{<:AbstractExpr}, ty::QualType,
                              num_user_specified::Integer, init_loc::SourceLocation,
                              lparen::SourceLocation, rparen::SourceLocation)
    @check_ptrs ctx ty
    @assert all(a -> a.ptr != C_NULL, args) "a paren-list initializer holds no null slot"
    @assert 0 <= num_user_specified <= length(args) "written initializers outnumber the initializers"
    buf = CXExpr[a.ptr for a in args]
    return CXXParenListInitExpr(clang_CXXParenListInitExpr_Create(ctx, buf, length(buf), ty,
                                                                  num_user_specified, init_loc,
                                                                  lparen, rparen))
end

"""
    CXXParenListInitExpr(ctx::ASTContext, num_exprs::Integer)
Build the empty paren-list-initialization shell clang deserializes into. The `num_exprs` initializer
slots are reserved but left uninitialized, so only the node's statement class may be read straight
away.
"""
function CXXParenListInitExpr(ctx::ASTContext, num_exprs::Integer)
    @check_ptrs ctx
    return CXXParenListInitExpr(clang_CXXParenListInitExpr_CreateEmpty(ctx, num_exprs))
end

# CXXUnresolvedConstructExpr (cont.)
"""
    CXXUnresolvedConstructExpr(ctx::ASTContext, ty::QualType, tsi::TypeSourceInfo,
                               lparen::SourceLocation, args::Vector{<:AbstractExpr},
                               rparen::SourceLocation, is_list_init::Bool)
Build the unresolved construction `T(a, b, ...)` of type `ty` in `ctx`'s arena, with `tsi` the type as
written and `is_list_init` recording a `T{...}` spelling. The handles in `args` are copied into the
node's trailing storage, so `args` need not outlive the call. The node is arena-allocated: there is
no `dispose`.
"""
function CXXUnresolvedConstructExpr(ctx::ASTContext, ty::QualType, tsi::TypeSourceInfo,
                                    lparen::SourceLocation, args::Vector{<:AbstractExpr},
                                    rparen::SourceLocation, is_list_init::Bool)
    @check_ptrs ctx ty tsi
    @assert all(a -> a.ptr != C_NULL, args) "an unresolved-construct argument holds no null slot"
    buf = CXExpr[a.ptr for a in args]
    return CXXUnresolvedConstructExpr(clang_CXXUnresolvedConstructExpr_Create(ctx, ty, tsi, lparen,
                                                                              buf, length(buf),
                                                                              rparen, is_list_init))
end

"""
    CXXUnresolvedConstructExpr(ctx::ASTContext, num_args::Integer)
Build the empty unresolved-construction shell clang deserializes into. The `num_args` argument slots
and the written type are left uninitialized, so only the node's statement class may be read straight
away.
"""
function CXXUnresolvedConstructExpr(ctx::ASTContext, num_args::Integer)
    @check_ptrs ctx
    return CXXUnresolvedConstructExpr(clang_CXXUnresolvedConstructExpr_CreateEmpty(ctx, num_args))
end

# CXXConstructExpr (cont.)
"""
    CXXConstructExpr(ctx::ASTContext, num_args::Integer)
Build the empty construction shell clang deserializes into. The `num_args` argument slots are
reserved, and the constructor, the construction kind and the source ranges behind them are
uninitialized, so only the node's statement class may be read straight away.
"""
function CXXConstructExpr(ctx::ASTContext, num_args::Integer)
    @check_ptrs ctx
    return CXXConstructExpr(clang_CXXConstructExpr_CreateEmpty(ctx, num_args))
end

# CXXTemporaryObjectExpr (cont.)
"""
    CXXTemporaryObjectExpr(ctx::ASTContext, num_args::Integer)
Build the empty temporary-object shell clang deserializes into; the `CXXConstructExpr` payload plus
the written type are left uninitialized.
"""
function CXXTemporaryObjectExpr(ctx::ASTContext, num_args::Integer)
    @check_ptrs ctx
    return CXXTemporaryObjectExpr(clang_CXXTemporaryObjectExpr_CreateEmpty(ctx, num_args))
end

# CXXNewExpr (cont.)
"""
    CXXNewExpr(ctx::ASTContext, is_array::Bool, has_init::Bool, num_placement_args::Integer,
               is_paren_type_id::Bool)
Build the empty new-expression shell clang deserializes into. The flags size the trailing storage —
an array-size slot, an initializer slot, `num_placement_args` placement-argument slots and a
parenthesized-type-id source range — and the payload behind them is uninitialized, so only the node's
statement class may be read straight away.
"""
function CXXNewExpr(ctx::ASTContext, is_array::Bool, has_init::Bool, num_placement_args::Integer,
                    is_paren_type_id::Bool)
    @check_ptrs ctx
    return CXXNewExpr(clang_CXXNewExpr_CreateEmpty(ctx, is_array, has_init, num_placement_args,
                                                   is_paren_type_id))
end

# CXXDefaultArgExpr (cont.)
"""
    CXXDefaultArgExpr(ctx::ASTContext, has_rewritten_init::Bool)
Build the empty default-argument shell clang deserializes into; `has_rewritten_init` reserves the
trailing rewritten-initializer slot. The parameter and the use context are left uninitialized, so
only the node's statement class may be read straight away.
"""
function CXXDefaultArgExpr(ctx::ASTContext, has_rewritten_init::Bool)
    @check_ptrs ctx
    return CXXDefaultArgExpr(clang_CXXDefaultArgExpr_CreateEmpty(ctx, has_rewritten_init))
end

# CXXDefaultInitExpr (cont.)
"""
    CXXDefaultInitExpr(ctx::ASTContext, has_rewritten_init::Bool)
Build the empty default-member-initializer shell clang deserializes into; the same shape as the
default-argument shell, with the field and the use context left uninitialized.
"""
function CXXDefaultInitExpr(ctx::ASTContext, has_rewritten_init::Bool)
    @check_ptrs ctx
    return CXXDefaultInitExpr(clang_CXXDefaultInitExpr_CreateEmpty(ctx, has_rewritten_init))
end

# UserDefinedLiteral (cont.)
"""
    UserDefinedLiteral(ctx::ASTContext, num_args::Integer, has_fp_options::Bool)
Build the empty user-defined-literal shell clang deserializes into. The `num_args` argument slots
plus, when `has_fp_options` is set, an `FPOptionsOverride` slot are reserved, and the callee and the
ud-suffix location behind them are uninitialized.
"""
function UserDefinedLiteral(ctx::ASTContext, num_args::Integer, has_fp_options::Bool)
    @check_ptrs ctx
    return UserDefinedLiteral(clang_UserDefinedLiteral_CreateEmpty(ctx, num_args, has_fp_options))
end

# CXXOperatorCallExpr (cont.)
"""
    CXXOperatorCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
Build the empty operator-call shell clang deserializes into; the same shape as the
user-defined-literal shell, with the overloaded operator kind left uninitialized.
"""
function CXXOperatorCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CXXOperatorCallExpr(clang_CXXOperatorCallExpr_CreateEmpty(ctx, num_args,
                                                                     has_fp_features))
end

# CXXMemberCallExpr (cont.)
"""
    CXXMemberCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
Build the empty member-call shell clang deserializes into; the callee and the `num_args` argument
slots are left uninitialized.
"""
function CXXMemberCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CXXMemberCallExpr(clang_CXXMemberCallExpr_CreateEmpty(ctx, num_args, has_fp_features))
end

# UnresolvedLookupExpr (cont.)
"""
    UnresolvedLookupExpr(ctx::ASTContext, num_results::Integer, has_template_kw_and_args::Bool,
                         num_template_args::Integer)
Build the empty unresolved-lookup shell clang deserializes into. The `num_results` lookup-result
slots and, when `has_template_kw_and_args` is set, `num_template_args` explicit template-argument
slots are reserved; everything behind them is uninitialized.
"""
function UnresolvedLookupExpr(ctx::ASTContext, num_results::Integer,
                              has_template_kw_and_args::Bool, num_template_args::Integer)
    @check_ptrs ctx
    return UnresolvedLookupExpr(clang_UnresolvedLookupExpr_CreateEmpty(ctx, num_results,
                                                                       has_template_kw_and_args,
                                                                       num_template_args))
end

# FunctionParmPackExpr (cont.)
"""
    FunctionParmPackExpr(ctx::ASTContext, num_params::Integer)
Build the empty function-parameter-pack shell clang deserializes into; the `num_params` parameter
slots are reserved and the referenced pack and its name location are left uninitialized.
"""
function FunctionParmPackExpr(ctx::ASTContext, num_params::Integer)
    @check_ptrs ctx
    return FunctionParmPackExpr(clang_FunctionParmPackExpr_CreateEmpty(ctx, num_params))
end


# LambdaExpr (cont.)
"""
    getNumExplicitCaptures(x::AbstractLambdaExpr) -> Integer
Return how many of `getNumCaptures(x)` captures were written in the lambda-introducer. The
remaining ones are the implicit captures a capture-default (`[=]`/`[&]`) introduced.
"""
function getNumExplicitCaptures(x::AbstractLambdaExpr)
    @check_ptrs x
    return clang_LambdaExpr_getNumExplicitCaptures(x)
end

# TypeTraitExpr (cont.)
"""
    getTrait(x::AbstractTypeTraitExpr) -> CXTypeTrait
Return which type trait this expression spells — the `__is_trivial`/`__is_base_of`/… selector
whose operands `getNumArgs` and `getArg` expose.
"""
function getTrait(x::AbstractTypeTraitExpr)
    @check_ptrs x
    return clang_TypeTraitExpr_getTrait(x)
end

# SizeOfPackExpr (cont.)
"""
    getNumPartialArguments(x::AbstractSizeOfPackExpr) -> Integer
Return how many template arguments the pack has already been substituted with. Only a
partially-substituted `sizeof...` has any: on every other node clang reads trailing storage
that was never allocated, so `isPartiallySubstituted(x)` is asserted first.
"""
function getNumPartialArguments(x::AbstractSizeOfPackExpr)
    @check_ptrs x
    @assert isPartiallySubstituted(x) "sizeof... pack must be partially substituted"
    return clang_SizeOfPackExpr_getNumPartialArguments(x)
end

"""
    getPartialArgument(x::AbstractSizeOfPackExpr, i::Integer) -> TemplateArgument
Return the `i`-th template argument the pack has already been substituted with. This function
allocates and one should call `dispose` to release the resources after using this object. The
box views the node's arena-allocated storage, so it must not outlive the `ASTContext`.
"""
function getPartialArgument(x::AbstractSizeOfPackExpr, i::Integer)
    @check_ptrs x
    @assert isPartiallySubstituted(x) "sizeof... pack must be partially substituted"
    @assert 0 <= i < getNumPartialArguments(x) "partial argument index out of range"
    return TemplateArgument(clang_SizeOfPackExpr_getPartialArgument(x, i))
end

# ExprWithCleanups (cont.)
"""
    ExprWithCleanups(ctx::ASTContext, num_objects::Integer)
Build the empty cleanup-expression shell clang deserializes into; the `num_objects`
cleanup-object slots are reserved but left uninitialized, so only the node's statement class
and `getNumObjects` may be read straight away.
"""
function ExprWithCleanups(ctx::ASTContext, num_objects::Integer)
    @check_ptrs ctx
    return ExprWithCleanups(clang_ExprWithCleanups_Create(ctx, num_objects))
end

"""
    objectIsBlockDecl(x::AbstractExprWithCleanups, i::Integer) -> Bool
Return whether the `i`-th object this full-expression cleans up is a block declaration; when it
is `false` the object is a block-scoped compound literal. This is the discriminator `getObject`
dispatches on.
"""
function objectIsBlockDecl(x::AbstractExprWithCleanups, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumObjects(x) "cleanup object index out of range"
    return clang_ExprWithCleanups_objectIsBlockDecl(x, i)
end

"""
    getObject(x::AbstractExprWithCleanups, i::Integer) -> Union{BlockDecl,CompoundLiteralExpr}
Return the `i`-th object whose destruction this full-expression runs — a `BlockDecl` or a
block-scoped `CompoundLiteralExpr`, selected by `objectIsBlockDecl(x, i)`.
"""
function getObject(x::AbstractExprWithCleanups, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumObjects(x) "cleanup object index out of range"
    if clang_ExprWithCleanups_objectIsBlockDecl(x, i)
        return BlockDecl(clang_ExprWithCleanups_getObjectAsBlockDecl(x, i))
    end
    return CompoundLiteralExpr(clang_ExprWithCleanups_getObjectAsCompoundLiteral(x, i))
end

# UnresolvedMemberExpr (cont.)
"""
    getMemberName(x::AbstractUnresolvedMemberExpr) -> DeclarationName
Return the name of the member the access refers to — the looked-up `OverloadExpr` name seen as
the member name.
"""
function getMemberName(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return DeclarationName(clang_UnresolvedMemberExpr_getMemberName(x))
end

"""
    getMemberNameInfo(x::AbstractUnresolvedMemberExpr) -> DeclarationNameInfo
Return the full name-plus-location of the member — the aggregate whose parts `getMemberName`
and `getMemberLoc` expose separately. The result is an owned heap box: call `dispose` on it
after use.
"""
function getMemberNameInfo(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_UnresolvedMemberExpr_getMemberNameInfo(x))
end

"""
    getMemberLoc(x::AbstractUnresolvedMemberExpr) -> SourceLocation
Return where the member name was written.
"""
function getMemberLoc(x::AbstractUnresolvedMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_UnresolvedMemberExpr_getMemberLoc(x))
end

# CXXPseudoDestructorExpr (cont.)
"""
    setDestroyedType(x::AbstractCXXPseudoDestructorExpr, ii::AbstractIdentifierInfo,
                     loc::SourceLocation)
Name the destroyed type of a dependent pseudo-destructor expression by identifier. This
replaces the node's whole destroyed-type storage: `getDestroyedTypeInfo` reads NULL afterwards
and `getDestroyedType` a null `QualType`, while `getDestroyedTypeIdentifier` and
`getDestroyedTypeLoc` read back `ii` and `loc`.
"""
function setDestroyedType(x::AbstractCXXPseudoDestructorExpr, ii::AbstractIdentifierInfo,
                          loc::SourceLocation)
    @check_ptrs x ii
    return clang_CXXPseudoDestructorExpr_setDestroyedType(x, ii, loc)
end

# MaterializeTemporaryExpr (cont.)
"""
    setExtendingDecl(x::AbstractMaterializeTemporaryExpr, d::AbstractValueDecl,
                     mangling_number::Integer)
Record the declaration that lifetime-extends this temporary together with the mangling number
the ABI assigns it; both read back through `getExtendingDecl` and `getManglingNumber`. On a
node that still holds only its subexpression this allocates the `LifetimeExtendedTemporaryDecl`
carrying them, in the `ASTContext`.
"""
function setExtendingDecl(x::AbstractMaterializeTemporaryExpr, d::AbstractValueDecl,
                          mangling_number::Integer)
    @check_ptrs x d
    return clang_MaterializeTemporaryExpr_setExtendingDecl(x, d, mangling_number)
end

# CoawaitExpr (cont.)
"""
    setIsImplicit(x::AbstractCoawaitExpr, value::Bool=true)
Mark the `co_await` as compiler-introduced — the initial and final suspend points a coroutine
body is wrapped in — rather than written in the source; `isImplicit` reads the flag back.
"""
function setIsImplicit(x::AbstractCoawaitExpr, value::Bool=true)
    @check_ptrs x
    return clang_CoawaitExpr_setIsImplicit(x, value)
end


# CXXOperatorCallExpr (cont.)
"""
    CXXOperatorCallExpr(ctx::ASTContext, op_kind::CXOverloadedOperatorKind, fn::AbstractExpr,
                        args::Vector{<:AbstractExpr}, ty::QualType, vk::CXExprValueKind,
                        operator_loc::SourceLocation, fp_features::Integer, uses_adl::Bool)
Build the overloaded-operator call `fn(args...)` of type `ty` and value kind `vk` in `ctx`'s arena,
with `op_kind` naming the operator and `operator_loc` its written location. `fp_features` is the
opaque `FPOptionsOverride` encoding — 0 means "no override" and is the only value that leaves
`hasStoredFPFeatures` false — and `uses_adl` records a callee found through argument-dependent
lookup. The handles in `args` are copied into the node's trailing storage, so `args` need not
outlive the call. The node is arena-allocated: there is no `dispose`.
"""
function CXXOperatorCallExpr(ctx::ASTContext, op_kind::CXOverloadedOperatorKind, fn::AbstractExpr,
                             args::Vector{<:AbstractExpr}, ty::QualType, vk::CXExprValueKind,
                             operator_loc::SourceLocation, fp_features::Integer, uses_adl::Bool)
    @check_ptrs ctx fn ty
    @assert all(a -> a.ptr != C_NULL, args) "an operator call holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    return CXXOperatorCallExpr(clang_CXXOperatorCallExpr_Create(ctx, op_kind, fn, buf, length(buf),
                                                                ty, vk, operator_loc, fp_features,
                                                                uses_adl))
end

# CXXMemberCallExpr (cont.)
"""
    CXXMemberCallExpr(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr},
                      ty::QualType, vk::CXExprValueKind, rparen::SourceLocation,
                      fp_features::Integer, min_num_args::Integer)
Build the member call `fn(args...)` of type `ty` and value kind `vk` in `ctx`'s arena, with `rparen`
the closing parenthesis. `min_num_args` pads the trailing argument storage out to the callee's
parameter count when the call was written with fewer arguments; 0 reserves exactly `length(args)`
slots. `fp_features` is the same opaque `FPOptionsOverride` encoding as elsewhere. The handles in
`args` are copied into the node's trailing storage. The node is arena-allocated: there is no
`dispose`.
"""
function CXXMemberCallExpr(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr},
                           ty::QualType, vk::CXExprValueKind, rparen::SourceLocation,
                           fp_features::Integer, min_num_args::Integer)
    @check_ptrs ctx fn ty
    @assert all(a -> a.ptr != C_NULL, args) "a member call holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    return CXXMemberCallExpr(clang_CXXMemberCallExpr_Create(ctx, fn, buf, length(buf), ty, vk,
                                                            rparen, fp_features, min_num_args))
end

# CUDAKernelCallExpr
"""
    CUDAKernelCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
Build the empty CUDA kernel-call shell clang deserializes into. A kernel-configuration slot and
`num_args` argument slots, plus an `FPOptionsOverride` slot when `has_fp_features` is set, are
reserved, and everything behind them is uninitialized, so only the node's statement class may be
read straight away.
"""
function CUDAKernelCallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CUDAKernelCallExpr(clang_CUDAKernelCallExpr_CreateEmpty(ctx, num_args, has_fp_features))
end

# UserDefinedLiteral (cont.)
"""
    UserDefinedLiteral(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr},
                       ty::QualType, vk::CXExprValueKind, lit_end_loc::SourceLocation,
                       suffix_loc::SourceLocation, fp_features::Integer)
Build the user-defined-literal call `fn(args...)` of type `ty` and value kind `vk` in `ctx`'s arena,
with `lit_end_loc` the end of the literal token and `suffix_loc` the ud-suffix. `fp_features` is the
same opaque `FPOptionsOverride` encoding as elsewhere and the handles in `args` are copied into the
node's trailing storage. `getUDSuffix` and `getLiteralOperatorKind` reach through
`cast<FunctionDecl>(getCalleeDecl())`, so a node built with an `fn` that is not a reference to a
literal operator must not be asked for them. The node is arena-allocated: there is no `dispose`.
"""
function UserDefinedLiteral(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr},
                            ty::QualType, vk::CXExprValueKind, lit_end_loc::SourceLocation,
                            suffix_loc::SourceLocation, fp_features::Integer)
    @check_ptrs ctx fn ty
    @assert all(a -> a.ptr != C_NULL, args) "a user-defined literal holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    return UserDefinedLiteral(clang_UserDefinedLiteral_Create(ctx, fn, buf, length(buf), ty, vk,
                                                              lit_end_loc, suffix_loc, fp_features))
end

# CXXConstructExpr (cont.)
"""
    CXXConstructExpr(ctx::ASTContext, ty::QualType, loc::SourceLocation,
                     ctor::AbstractCXXConstructorDecl, elidable::Bool,
                     args::Vector{<:AbstractExpr}, had_multiple_candidates::Bool,
                     list_initialization::Bool, std_init_list_initialization::Bool,
                     zero_initialization::Bool, kind::CXCXXConstructionKind,
                     paren_or_brace::SourceRange)
Build the construction `T(args...)` of type `ty` at `loc` in `ctx`'s arena, calling `ctor`. The flags
read back through `isElidable`, `hadMultipleCandidates`, `isListInitialization`,
`isStdInitListInitialization` and `requiresZeroInitialization`, `kind` is the construction kind and
`paren_or_brace` the written argument list. The handles in `args` are copied into the node's trailing
storage, so `args` need not outlive the call. The node is arena-allocated: there is no `dispose`.
"""
function CXXConstructExpr(ctx::ASTContext, ty::QualType, loc::SourceLocation,
                          ctor::AbstractCXXConstructorDecl, elidable::Bool,
                          args::Vector{<:AbstractExpr}, had_multiple_candidates::Bool,
                          list_initialization::Bool, std_init_list_initialization::Bool,
                          zero_initialization::Bool, kind::CXCXXConstructionKind,
                          paren_or_brace::SourceRange)
    @check_ptrs ctx ty ctor
    @assert all(a -> a.ptr != C_NULL, args) "a construction holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    pb = CXSourceRange_(paren_or_brace.begin_loc.ptr, paren_or_brace.end_loc.ptr)
    return CXXConstructExpr(clang_CXXConstructExpr_Create(ctx, ty, loc, ctor, elidable, buf,
                                                          length(buf), had_multiple_candidates,
                                                          list_initialization,
                                                          std_init_list_initialization,
                                                          zero_initialization, kind, pb))
end

# CXXTemporaryObjectExpr (cont.)
"""
    CXXTemporaryObjectExpr(ctx::ASTContext, cons::AbstractCXXConstructorDecl, ty::QualType,
                           tsi::TypeSourceInfo, args::Vector{<:AbstractExpr},
                           paren_or_brace::SourceRange, had_multiple_candidates::Bool,
                           list_initialization::Bool, std_init_list_initialization::Bool,
                           zero_initialization::Bool)
Build the functional-notation construction `T(args...)` of type `ty` in `ctx`'s arena, calling
`cons`, with `tsi` the type as written and the flags the `CXXConstructExpr` ones. `tsi` must be
non-NULL: clang's constructor takes the node's location from `tsi`'s `TypeLoc` unchecked. The handles
in `args` are copied into the node's trailing storage. The node is arena-allocated: there is no
`dispose`.
"""
function CXXTemporaryObjectExpr(ctx::ASTContext, cons::AbstractCXXConstructorDecl, ty::QualType,
                                tsi::TypeSourceInfo, args::Vector{<:AbstractExpr},
                                paren_or_brace::SourceRange, had_multiple_candidates::Bool,
                                list_initialization::Bool, std_init_list_initialization::Bool,
                                zero_initialization::Bool)
    @check_ptrs ctx cons ty tsi
    @assert all(a -> a.ptr != C_NULL, args) "a temporary object holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    pb = CXSourceRange_(paren_or_brace.begin_loc.ptr, paren_or_brace.end_loc.ptr)
    return CXXTemporaryObjectExpr(clang_CXXTemporaryObjectExpr_Create(ctx, cons, ty, tsi, buf,
                                                                      length(buf), pb,
                                                                      had_multiple_candidates,
                                                                      list_initialization,
                                                                      std_init_list_initialization,
                                                                      zero_initialization))
end

# CXXNewExpr (cont.)
"""
    CXXNewExpr(ctx::ASTContext, is_global_new::Bool,
               operator_new::Union{Nothing,AbstractFunctionDecl},
               operator_delete::Union{Nothing,AbstractFunctionDecl}, should_pass_alignment::Bool,
               usual_array_delete_wants_size::Bool, placement_args::Vector{<:AbstractExpr},
               type_id_parens::SourceRange, array_size::Union{Nothing,AbstractExpr},
               init_style::CXCXXNewInitializationStyle,
               initializer::Union{Nothing,AbstractExpr}, ty::QualType,
               allocated_type_info::TypeSourceInfo, range::SourceRange,
               direct_init_range::SourceRange)
Build the new-expression `new (placement_args...) T initializer` of type `ty` in `ctx`'s arena.
`operator_new` and `operator_delete` are the resolved allocation and deallocation functions and may
be `nothing`. A `nothing` `array_size` is the non-array form and an expression the array form; the
array form whose extent was not written (`new int[]{1, 2}`) is reachable only from C, since a carrier
is never NULL here. `init_style` records the initializer's spelling, and clang asserts that a style
other than `CXCXXNewInitializationStyle_None` carries an initializer. The handles in
`placement_args` are copied into the node's trailing storage. The node is arena-allocated: there is
no `dispose`.
"""
function CXXNewExpr(ctx::ASTContext, is_global_new::Bool,
                    operator_new::Union{Nothing,AbstractFunctionDecl},
                    operator_delete::Union{Nothing,AbstractFunctionDecl},
                    should_pass_alignment::Bool, usual_array_delete_wants_size::Bool,
                    placement_args::Vector{<:AbstractExpr}, type_id_parens::SourceRange,
                    array_size::Union{Nothing,AbstractExpr},
                    init_style::CXCXXNewInitializationStyle,
                    initializer::Union{Nothing,AbstractExpr}, ty::QualType,
                    allocated_type_info::TypeSourceInfo, range::SourceRange,
                    direct_init_range::SourceRange)
    @check_ptrs ctx ty allocated_type_info
    @assert all(a -> a.ptr != C_NULL, placement_args) "a new-expression holds no null placement slot"
    has_init = initializer !== nothing
    @assert has_init || init_style == CXCXXNewInitializationStyle_None "a styled new-expression needs an initializer"
    on = operator_new === nothing ? C_NULL : operator_new
    od = operator_delete === nothing ? C_NULL : operator_delete
    sz = array_size === nothing ? C_NULL : array_size
    init = has_init ? initializer : C_NULL
    buf = CXExpr[a.ptr for a in placement_args]
    tip = CXSourceRange_(type_id_parens.begin_loc.ptr, type_id_parens.end_loc.ptr)
    rng = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    dir = CXSourceRange_(direct_init_range.begin_loc.ptr, direct_init_range.end_loc.ptr)
    return CXXNewExpr(clang_CXXNewExpr_Create(ctx, is_global_new, on, od, should_pass_alignment,
                                              usual_array_delete_wants_size, buf, length(buf),
                                              tip, array_size !== nothing, sz,
                                              init_style, init, ty, allocated_type_info, rng,
                                              dir))
end

# LambdaExpr (cont.)
"""
    LambdaExpr(ctx::ASTContext, num_captures::Integer)
Build the empty lambda shell clang deserializes into. The `num_captures` capture-initializer slots
are reserved and the closure class, the introducer range and the capture default behind them are left
uninitialized, so only the node's statement class may be read straight away.
"""
function LambdaExpr(ctx::ASTContext, num_captures::Integer)
    @check_ptrs ctx
    return LambdaExpr(clang_LambdaExpr_CreateDeserialized(ctx, num_captures))
end

# TypeTraitExpr (cont.)
"""
    TypeTraitExpr(ctx::ASTContext, ty::QualType, loc::SourceLocation, kind::CXTypeTrait,
                  args::Vector{<:AbstractTypeSourceInfo}, rparen::SourceLocation, value::Bool)
Build the type-trait expression `kind(args...)` of type `ty` at `loc` in `ctx`'s arena, with `rparen`
the closing parenthesis and `value` the already-evaluated result. The handles in `args` are copied
into the node's trailing storage, so `args` need not outlive the call. Only a node built from
non-dependent arguments answers `getValue`, which asserts `!isValueDependent()`. The node is
arena-allocated: there is no `dispose`.
"""
function TypeTraitExpr(ctx::ASTContext, ty::QualType, loc::SourceLocation, kind::CXTypeTrait,
                       args::Vector{<:AbstractTypeSourceInfo}, rparen::SourceLocation, value::Bool)
    @check_ptrs ctx ty
    @assert all(a -> a.ptr != C_NULL, args) "a type-trait expression holds no null argument slot"
    buf = CXTypeSourceInfo[a.ptr for a in args]
    return TypeTraitExpr(clang_TypeTraitExpr_Create(ctx, ty, loc, kind, buf, length(buf), rparen,
                                                    value))
end

"""
    TypeTraitExpr(ctx::ASTContext, num_args::Integer)
Build the empty type-trait shell clang deserializes into; the `num_args` argument slots and the trait
kind behind them are left uninitialized.
"""
function TypeTraitExpr(ctx::ASTContext, num_args::Integer)
    @check_ptrs ctx
    return TypeTraitExpr(clang_TypeTraitExpr_CreateDeserialized(ctx, num_args))
end

# SizeOfPackExpr (cont.)
"""
    SizeOfPackExpr(ctx::ASTContext, operator_loc::SourceLocation, pack::AbstractNamedDecl,
                   pack_loc::SourceLocation, rparen::SourceLocation,
                   pack_length::Union{Nothing,Integer},
                   partial_args::Vector{TemplateArgument}=TemplateArgument[])
Build the `sizeof...(pack)` expression in `ctx`'s arena, with `operator_loc`, `pack_loc` and `rparen`
the written locations. A non-`nothing` `pack_length` is the already-known pack size and makes the
node non-dependent; `nothing` leaves it value-dependent with `length(partial_args)` as its length.
The boxes in `partial_args` are dereferenced and copied into the node's trailing storage, so they
need not outlive the call. Clang asserts that a non-dependent `sizeof...` carries no
partially-substituted arguments. The node is arena-allocated: there is no `dispose`.
"""
function SizeOfPackExpr(ctx::ASTContext, operator_loc::SourceLocation, pack::AbstractNamedDecl,
                        pack_loc::SourceLocation, rparen::SourceLocation,
                        pack_length::Union{Nothing,Integer},
                        partial_args::Vector{TemplateArgument}=TemplateArgument[])
    @check_ptrs ctx pack
    @assert all(a -> a.ptr != C_NULL, partial_args) "a substituted pack holds no null slot"
    @assert pack_length === nothing || isempty(partial_args) "a known pack length admits no partial arguments"
    buf = CXTemplateArgument[a.ptr for a in partial_args]
    len = pack_length === nothing ? 0 : pack_length
    return SizeOfPackExpr(clang_SizeOfPackExpr_Create(ctx, operator_loc, pack, pack_loc, rparen,
                                                      pack_length !== nothing, len, buf,
                                                      length(buf)))
end

"""
    SizeOfPackExpr(ctx::ASTContext, num_partial_args::Integer)
Build the empty `sizeof...` shell clang deserializes into; the `num_partial_args`
partially-substituted argument slots are reserved and the pack and its locations are left
uninitialized.
"""
function SizeOfPackExpr(ctx::ASTContext, num_partial_args::Integer)
    @check_ptrs ctx
    return SizeOfPackExpr(clang_SizeOfPackExpr_CreateDeserialized(ctx, num_partial_args))
end

# DependentScopeDeclRefExpr (cont.)
"""
    DependentScopeDeclRefExpr(ctx::ASTContext, has_template_kw_and_args::Bool,
                              num_template_args::Integer)
Build the empty dependent declaration-reference shell clang deserializes into. When
`has_template_kw_and_args` is set, `num_template_args` explicit template-argument slots are reserved;
the qualifier and the name behind them are left uninitialized.
"""
function DependentScopeDeclRefExpr(ctx::ASTContext, has_template_kw_and_args::Bool,
                                   num_template_args::Integer)
    @check_ptrs ctx
    return DependentScopeDeclRefExpr(clang_DependentScopeDeclRefExpr_CreateEmpty(ctx,
                                                                                 has_template_kw_and_args,
                                                                                 num_template_args))
end

# CXXDependentScopeMemberExpr (cont.)
"""
    CXXDependentScopeMemberExpr(ctx::ASTContext, has_template_kw_and_args::Bool,
                                num_template_args::Integer, has_first_qualifier_found::Bool)
Build the empty dependent member-reference shell clang deserializes into: the same
template-argument storage as the dependent declaration-reference shell, plus a
first-qualifier-found-in-scope slot when `has_first_qualifier_found` is set. The base and the member
name are left uninitialized.
"""
function CXXDependentScopeMemberExpr(ctx::ASTContext, has_template_kw_and_args::Bool,
                                     num_template_args::Integer, has_first_qualifier_found::Bool)
    @check_ptrs ctx
    p = clang_CXXDependentScopeMemberExpr_CreateEmpty(ctx, has_template_kw_and_args,
                                                      num_template_args, has_first_qualifier_found)
    return CXXDependentScopeMemberExpr(p)
end

# UnresolvedMemberExpr (cont.)
"""
    UnresolvedMemberExpr(ctx::ASTContext, num_results::Integer, has_template_kw_and_args::Bool,
                         num_template_args::Integer)
Build the empty unresolved member-reference shell clang deserializes into. The `num_results`
lookup-result slots and, when `has_template_kw_and_args` is set, `num_template_args` explicit
template-argument slots are reserved; everything behind them is uninitialized.
"""
function UnresolvedMemberExpr(ctx::ASTContext, num_results::Integer,
                              has_template_kw_and_args::Bool, num_template_args::Integer)
    @check_ptrs ctx
    return UnresolvedMemberExpr(clang_UnresolvedMemberExpr_CreateEmpty(ctx, num_results,
                                                                       has_template_kw_and_args,
                                                                       num_template_args))
end


# LambdaExpr (cont.)
"""
    LambdaExpr(ctx::ASTContext, cls::AbstractCXXRecordDecl, introducer::SourceRange,
               capture_default::CXLambdaCaptureDefault, capture_default_loc::SourceLocation,
               explicit_params::Bool, explicit_result_type::Bool,
               capture_inits::Vector{<:AbstractExpr}, closing_brace::SourceLocation,
               contains_unexpanded_pack::Bool)
Build the lambda expression whose closure type is `cls` in `ctx`'s arena. `introducer` is the written
`[...]` extent, `capture_default` and `capture_default_loc` the capture default and where it was
written, `explicit_params` and `explicit_result_type` mirror the accessors of the same name,
`closing_brace` closes the body and `contains_unexpanded_pack` seeds the node's dependence bits. The
body is copied straight out of `cls`'s call operator, which must already carry one. The handles in
`capture_inits` are copied into the node's trailing storage, so `capture_inits` need not outlive the
call; a slot may wrap NULL, which is how a VLA-typed capture is spelled. The node is arena-allocated:
there is no `dispose`.
"""
function LambdaExpr(ctx::ASTContext, cls::AbstractCXXRecordDecl, introducer::SourceRange,
                    capture_default::CXLambdaCaptureDefault, capture_default_loc::SourceLocation,
                    explicit_params::Bool, explicit_result_type::Bool,
                    capture_inits::Vector{<:AbstractExpr}, closing_brace::SourceLocation,
                    contains_unexpanded_pack::Bool)
    @check_ptrs ctx cls
    @assert isLambda(cls) "the closure type must be a lambda closure type"
    @assert length(capture_inits) == capture_size(cls) "capture initializers must match the closure"
    @assert capture_default == getLambdaCaptureDefault(cls) "capture default must match the closure"
    buf = CXExpr[c.ptr for c in capture_inits]
    ir = CXSourceRange_(introducer.begin_loc.ptr, introducer.end_loc.ptr)
    return LambdaExpr(clang_LambdaExpr_Create(ctx, cls, ir, capture_default, capture_default_loc,
                                              explicit_params, explicit_result_type, buf,
                                              length(buf), closing_brace, contains_unexpanded_pack))
end

# CUDAKernelCallExpr (cont.)
"""
    CUDAKernelCallExpr(ctx::ASTContext, fn::AbstractExpr, config::AbstractCallExpr,
                       args::Vector{<:AbstractExpr}, ty::QualType, vk::CXExprValueKind,
                       rparen::SourceLocation, fp_features::Integer, min_num_args::Integer)
Build the kernel launch `fn<<<...>>>(args...)` of type `ty` and value kind `vk` in `ctx`'s arena,
with `config` the `<<<...>>>` configuration call and `rparen` the closing parenthesis. `min_num_args`
pads the trailing argument storage out to the callee's parameter count when the call was written with
fewer arguments; 0 reserves exactly `length(args)` slots. `fp_features` is the opaque
`FPOptionsOverride` encoding — 0 means "no override". The handles in `args` are copied into the
node's trailing storage, so `args` need not outlive the call. The node is arena-allocated: there is
no `dispose`.
"""
function CUDAKernelCallExpr(ctx::ASTContext, fn::AbstractExpr, config::AbstractCallExpr,
                            args::Vector{<:AbstractExpr}, ty::QualType, vk::CXExprValueKind,
                            rparen::SourceLocation, fp_features::Integer, min_num_args::Integer)
    @check_ptrs ctx fn config ty
    @assert all(a -> a.ptr != C_NULL, args) "a kernel launch holds no null argument slot"
    buf = CXExpr[a.ptr for a in args]
    return CUDAKernelCallExpr(clang_CUDAKernelCallExpr_Create(ctx, fn, config, buf, length(buf), ty,
                                                              vk, rparen, fp_features, min_num_args))
end

"""
    getConfig(x::AbstractCUDAKernelCallExpr) -> CallExpr
Return the `<<<...>>>` configuration call of the kernel launch. The returned carrier wraps NULL when
the launch carries no configuration. Reading it from a node built by the deserialization shell
constructor is undefined: that shell leaves the configuration slot uninitialized.
"""
function getConfig(x::AbstractCUDAKernelCallExpr)
    @check_ptrs x
    return CallExpr(clang_CUDAKernelCallExpr_getConfig(x))
end

# OverloadExpr (cont.)
"""
    find(x::AbstractExpr) -> (expr, is_address_of_operand, has_form_of_member_pointer)
Find the overload set `x` names, looking through parentheses and a leading `&`. `expr` is the
overload expression itself, carried at the `Expr_` base — `resolve` it to reach the
`UnresolvedLookupExpr` or `UnresolvedMemberExpr` underneath. `is_address_of_operand` records whether
it appeared as the operand of an `&`, and `has_form_of_member_pointer` whether that `&` applied to a
qualified name and so forms a pointer to member. `x` must carry clang's overload placeholder type;
clang asserts it and every cast below it is unchecked.
"""
function find(x::AbstractExpr)
    @check_ptrs x
    ty = getTypePtr(getType(x))
    is_overload = isPlaceholderType(ty) && !isNonOverloadPlaceholderType(ty)
    @assert is_overload "the expression must carry clang's overload placeholder type"
    address_of = Ref{Bool}(false)
    member_pointer = Ref{Bool}(false)
    p = clang_OverloadExpr_find(x, address_of, member_pointer)
    return Expr_(p), address_of[], member_pointer[]
end

# CXXParenListInitExpr (cont.)
"""
    updateDependence(x::AbstractCXXParenListInitExpr)
Recompute the node's dependence bits from its current initializer list. The setters that replace an
initializer leave them stale, so this is the refresh they pair with.
"""
function updateDependence(x::AbstractCXXParenListInitExpr)
    @check_ptrs x
    return clang_CXXParenListInitExpr_updateDependence(x)
end


# The getQualifierLoc family. `getQualifierRange` flattens the qualifier to its outer
# extent; these return the whole `NestedNameSpecifierLoc`, which is the only way to reach
# the per-component locations, the prefix chain and the qualifier's `TypeLoc`. Every result
# is an owned box, and an unqualified name yields an empty location rather than a NULL one.

# MSPropertyRefExpr (cont.)
"""
    getQualifierLoc(x::AbstractMSPropertyRefExpr) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the property name, together with the source
location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractMSPropertyRefExpr)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_MSPropertyRefExpr_getQualifierLoc(x))
end

# CXXPseudoDestructorExpr (cont.)
"""
    getQualifierLoc(x::AbstractCXXPseudoDestructorExpr) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the destructor name, together with the
source location of every component that was written. `hasQualifier(x)` reports the same
emptiness this location does; note that a scalar destroyed type keeps its written
qualification in the scope type instead.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractCXXPseudoDestructorExpr)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_CXXPseudoDestructorExpr_getQualifierLoc(x))
end

# OverloadExpr (cont.)
"""
    getQualifierLoc(x::AbstractOverloadExpr) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the looked-up name, together with the source
location of every component that was written.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractOverloadExpr)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_OverloadExpr_getQualifierLoc(x))
end

# DependentScopeDeclRefExpr (cont.)
"""
    getQualifierLoc(x::AbstractDependentScopeDeclRefExpr) -> NestedNameSpecifierLoc
Return the nested-name-specifier that qualifies the name, together with the source location
of every component that was written. The `T::` of a dependent reference is always written,
so this location is never empty.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractDependentScopeDeclRefExpr)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_DependentScopeDeclRefExpr_getQualifierLoc(x))
end

# CXXDependentScopeMemberExpr (cont.)
"""
    getQualifierLoc(x::AbstractCXXDependentScopeMemberExpr) -> NestedNameSpecifierLoc
Return the nested-name-specifier that precedes the member name, together with the source
location of every component that was written. An unqualified member access yields an empty
location.
This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getQualifierLoc(x::AbstractCXXDependentScopeMemberExpr)
    @check_ptrs x
    return NestedNameSpecifierLoc(clang_CXXDependentScopeMemberExpr_getQualifierLoc(x))
end


# OverloadExpr (cont.)
"""
    copyTemplateArgumentsInto(x::AbstractOverloadExpr, list::TemplateArgumentListInfo)
Append the template arguments written on `x`, and the angle-bracket locations, to `list`.

A lookup carrying no explicit argument list leaves `list` untouched. `list` stays owned by the
caller and must be disposed.
"""
function copyTemplateArgumentsInto(x::AbstractOverloadExpr, list::TemplateArgumentListInfo)
    @check_ptrs x list
    clang_OverloadExpr_copyTemplateArgumentsInto(x, list)
    return nothing
end

# DependentScopeDeclRefExpr (cont.)
"""
    copyTemplateArgumentsInto(x::AbstractDependentScopeDeclRefExpr, list::TemplateArgumentListInfo)
Append the template arguments written on `x`, and the angle-bracket locations, to `list`.

A reference carrying no explicit argument list leaves `list` untouched. `list` stays owned by the
caller and must be disposed.
"""
function copyTemplateArgumentsInto(x::AbstractDependentScopeDeclRefExpr,
                                   list::TemplateArgumentListInfo)
    @check_ptrs x list
    clang_DependentScopeDeclRefExpr_copyTemplateArgumentsInto(x, list)
    return nothing
end

# CXXDependentScopeMemberExpr (cont.)
"""
    copyTemplateArgumentsInto(x::AbstractCXXDependentScopeMemberExpr, list::TemplateArgumentListInfo)
Append the template arguments written on `x`, and the angle-bracket locations, to `list`.

A member access carrying no explicit argument list leaves `list` untouched. `list` stays owned by
the caller and must be disposed.
"""
function copyTemplateArgumentsInto(x::AbstractCXXDependentScopeMemberExpr,
                                   list::TemplateArgumentListInfo)
    @check_ptrs x list
    clang_CXXDependentScopeMemberExpr_copyTemplateArgumentsInto(x, list)
    return nothing
end

# DependentScopeDeclRefExpr (cont.)
"""
    DependentScopeDeclRefExpr(ctx::ASTContext, qualifier_loc::NestedNameSpecifierLoc,
                              template_kw_loc::SourceLocation, name_info::DeclarationNameInfo,
                              template_args::Union{TemplateArgumentListInfo,Nothing}=nothing)
Build the dependent qualified reference `T::name` in `ctx`'s arena. `qualifier_loc` is the `T::` as
written, `template_kw_loc` the `template` keyword of `T::template f<...>` (an invalid location when
there is none) and `name_info` the name with its location. Pass `nothing` for `template_args` when
no explicit `<...>` was written. The node is arena-allocated: there is no `dispose`.
"""
function DependentScopeDeclRefExpr(ctx::ASTContext, qualifier_loc::NestedNameSpecifierLoc,
                                   template_kw_loc::SourceLocation,
                                   name_info::DeclarationNameInfo,
                                   template_args::Union{TemplateArgumentListInfo,Nothing}=nothing)
    @check_ptrs ctx qualifier_loc name_info
    @assert hasQualifier(qualifier_loc) "a dependent scope reference must carry a qualifier"
    args = template_args === nothing ? C_NULL : template_args.ptr
    p = clang_DependentScopeDeclRefExpr_Create(ctx, qualifier_loc, template_kw_loc, name_info, args)
    return DependentScopeDeclRefExpr(p)
end

# CXXDependentScopeMemberExpr (cont.)
"""
    CXXDependentScopeMemberExpr(ctx::ASTContext, base, base_type::QualType, is_arrow::Bool,
                                operator_loc::SourceLocation,
                                qualifier_loc::NestedNameSpecifierLoc,
                                template_kw_loc::SourceLocation, first_qualifier,
                                member_name_info::DeclarationNameInfo, template_args=nothing)
Build the dependent member access `base.member` / `base->member` in `ctx`'s arena. Pass `nothing`
for `base` to build an implicit access (a bare `member` inside a dependent class), `nothing` for
`first_qualifier` when the written qualification named nothing at parse time, and `nothing` for
`template_args` when no explicit `<...>` was written. The node is arena-allocated: there is no
`dispose`.
"""
function CXXDependentScopeMemberExpr(ctx::ASTContext, base::Union{AbstractExpr,Nothing},
                                     base_type::QualType, is_arrow::Bool,
                                     operator_loc::SourceLocation,
                                     qualifier_loc::NestedNameSpecifierLoc,
                                     template_kw_loc::SourceLocation,
                                     first_qualifier::Union{AbstractNamedDecl,Nothing},
                                     member_name_info::DeclarationNameInfo,
                                     template_args::Union{TemplateArgumentListInfo,Nothing}=nothing)
    @check_ptrs ctx base_type qualifier_loc member_name_info
    b = base === nothing ? C_NULL : base.ptr
    fq = first_qualifier === nothing ? C_NULL : first_qualifier.ptr
    args = template_args === nothing ? C_NULL : template_args.ptr
    p = clang_CXXDependentScopeMemberExpr_Create(ctx, b, base_type, is_arrow, operator_loc,
                                                 qualifier_loc, template_kw_loc, fq,
                                                 member_name_info, args)
    return CXXDependentScopeMemberExpr(p)
end

# UnresolvedLookupExpr (cont.)
"""
    UnresolvedLookupExpr(ctx::ASTContext, naming_class, qualifier_loc::NestedNameSpecifierLoc,
                         name_info::DeclarationNameInfo, requires_adl::Bool, overloaded::Bool,
                         decls, accesses) -> UnresolvedLookupExpr
Build the unresolved lookup of an overload set in `ctx`'s arena. `naming_class` is the class the
lookup ran in — pass `nothing` for a namespace-scope set — `requires_adl` records that
argument-dependent lookup still has to run and `overloaded` that the name resolved to more than one
declaration. `decls` and `accesses` are the lookup results, read in lockstep and copied into the
node's trailing storage, so neither need outlive the call. The node is arena-allocated: there is no
`dispose`.
"""
function UnresolvedLookupExpr(ctx::ASTContext,
                              naming_class::Union{AbstractCXXRecordDecl,Nothing},
                              qualifier_loc::NestedNameSpecifierLoc,
                              name_info::DeclarationNameInfo, requires_adl::Bool,
                              overloaded::Bool, decls::AbstractVector{<:AbstractNamedDecl},
                              accesses::AbstractVector{CXAccessSpecifier})
    @check_ptrs ctx qualifier_loc name_info
    @assert length(decls) == length(accesses) "decls and accesses must have the same length"
    @assert !isempty(decls) "an unresolved lookup must name at least one declaration"
    @assert all(d -> d.ptr != C_NULL, decls) "a lookup result holds no null slot"
    nc = naming_class === nothing ? C_NULL : naming_class.ptr
    dbuf = CXNamedDecl[d.ptr for d in decls]
    abuf = collect(accesses)
    p = clang_UnresolvedLookupExpr_Create(ctx, nc, qualifier_loc, name_info, requires_adl,
                                          overloaded, dbuf, abuf, length(dbuf))
    return UnresolvedLookupExpr(p)
end

"""
    UnresolvedLookupExpr(ctx::ASTContext, naming_class, qualifier_loc::NestedNameSpecifierLoc,
                         template_kw_loc::SourceLocation, name_info::DeclarationNameInfo,
                         requires_adl::Bool, template_args, decls, accesses,
                         known_dependent::Bool) -> UnresolvedLookupExpr
Build the same overload set written with an explicit template argument list, e.g. `f<int>`.
`template_kw_loc` is the `template` keyword, `template_args` the written `<...>` (pass `nothing`
when the keyword appears without one) and `known_dependent` whether any canonicalized argument is
dependent, which selects the node's type. `decls`, `accesses` and the ownership rules are those of
the non-templated form.
"""
function UnresolvedLookupExpr(ctx::ASTContext,
                              naming_class::Union{AbstractCXXRecordDecl,Nothing},
                              qualifier_loc::NestedNameSpecifierLoc,
                              template_kw_loc::SourceLocation,
                              name_info::DeclarationNameInfo, requires_adl::Bool,
                              template_args::Union{TemplateArgumentListInfo,Nothing},
                              decls::AbstractVector{<:AbstractNamedDecl},
                              accesses::AbstractVector{CXAccessSpecifier},
                              known_dependent::Bool)
    @check_ptrs ctx qualifier_loc name_info
    @assert length(decls) == length(accesses) "decls and accesses must have the same length"
    @assert !isempty(decls) "an unresolved lookup must name at least one declaration"
    @assert all(d -> d.ptr != C_NULL, decls) "a lookup result holds no null slot"
    nc = naming_class === nothing ? C_NULL : naming_class.ptr
    args = template_args === nothing ? C_NULL : template_args.ptr
    dbuf = CXNamedDecl[d.ptr for d in decls]
    abuf = collect(accesses)
    p = clang_UnresolvedLookupExpr_CreateWithTemplateArgs(ctx, nc, qualifier_loc,
                                                          template_kw_loc, name_info,
                                                          requires_adl, args, dbuf, abuf,
                                                          length(dbuf), known_dependent)
    return UnresolvedLookupExpr(p)
end

# UnresolvedMemberExpr (cont.)
"""
    UnresolvedMemberExpr(ctx::ASTContext, has_unresolved_using::Bool, base,
                         base_type::QualType, is_arrow::Bool, operator_loc::SourceLocation,
                         qualifier_loc::NestedNameSpecifierLoc,
                         template_kw_loc::SourceLocation,
                         member_name_info::DeclarationNameInfo, template_args, decls,
                         accesses) -> UnresolvedMemberExpr
Build the unresolved member access `base.m` / `base->m` in `ctx`'s arena, where `m` named an
overload set. `has_unresolved_using` records that the set holds an `UnresolvedUsingValueDecl`; pass
`nothing` for `base` to build an implicit access and `nothing` for `template_args` when no explicit
`<...>` was written. `decls` and `accesses` are the lookup results, read in lockstep and copied into
the node's trailing storage. The node is arena-allocated: there is no `dispose`.
"""
function UnresolvedMemberExpr(ctx::ASTContext, has_unresolved_using::Bool,
                              base::Union{AbstractExpr,Nothing}, base_type::QualType,
                              is_arrow::Bool, operator_loc::SourceLocation,
                              qualifier_loc::NestedNameSpecifierLoc,
                              template_kw_loc::SourceLocation,
                              member_name_info::DeclarationNameInfo,
                              template_args::Union{TemplateArgumentListInfo,Nothing},
                              decls::AbstractVector{<:AbstractNamedDecl},
                              accesses::AbstractVector{CXAccessSpecifier})
    @check_ptrs ctx base_type qualifier_loc member_name_info
    @assert length(decls) == length(accesses) "decls and accesses must have the same length"
    @assert !isempty(decls) "an unresolved member access must name at least one declaration"
    @assert all(d -> d.ptr != C_NULL, decls) "a lookup result holds no null slot"
    b = base === nothing ? C_NULL : base.ptr
    args = template_args === nothing ? C_NULL : template_args.ptr
    dbuf = CXNamedDecl[d.ptr for d in decls]
    abuf = collect(accesses)
    p = clang_UnresolvedMemberExpr_Create(ctx, has_unresolved_using, b, base_type, is_arrow,
                                          operator_loc, qualifier_loc, template_kw_loc,
                                          member_name_info, args, dbuf, abuf, length(dbuf))
    return UnresolvedMemberExpr(p)
end

# LambdaExpr (cont.)
"""
    capture_size(x::AbstractLambdaExpr) -> Integer
How many captures the closure type carries, explicit and implicit together. This is clang's
range-interface spelling of `getNumCaptures(x)` and calls the same binding.
"""
capture_size(x::AbstractLambdaExpr) = getNumCaptures(x)

"""
    captures(x::AbstractLambdaExpr) -> Vector{LambdaCapture}
Every capture in the closure type's capture list, the explicit ones first. Each carrier borrows an
interior pointer into the lambda; none of them is disposed.
"""
function captures(x::AbstractLambdaExpr)
    n = Int(getNumCaptures(x))
    return LambdaCapture[getCapture(x, i) for i = 0:(n - 1)]
end

"""
    explicit_captures(x::AbstractLambdaExpr) -> Vector{LambdaCapture}
The leading `getNumExplicitCaptures(x)` entries of `captures(x)` — the ones written in the
lambda-introducer.
"""
function explicit_captures(x::AbstractLambdaExpr)
    n = Int(getNumExplicitCaptures(x))
    return LambdaCapture[getCapture(x, i) for i = 0:(n - 1)]
end

"""
    implicit_captures(x::AbstractLambdaExpr) -> Vector{LambdaCapture}
The trailing entries of `captures(x)` — the ones a capture-default (`[=]`/`[&]`) introduced.
"""
function implicit_captures(x::AbstractLambdaExpr)
    first_implicit = Int(getNumExplicitCaptures(x))
    n = Int(getNumCaptures(x))
    return LambdaCapture[getCapture(x, i) for i = first_implicit:(n - 1)]
end
