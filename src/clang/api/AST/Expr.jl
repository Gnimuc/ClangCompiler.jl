# Expr
function getType(x::AbstractExpr)
    @check_ptrs x
    return QualType(clang_Expr_getType(x))
end

function getValueKind(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_getValueKind(x)
end

function isLValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isLValue(x)
end

function isPRValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isPRValue(x)
end

function isXValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isXValue(x)
end

function isGLValue(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isGLValue(x)
end

function IgnoreImpCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreImpCasts(x))
end

function IgnoreCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreCasts(x))
end

function IgnoreParens(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParens(x))
end

function IgnoreParenCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenCasts(x))
end

function IgnoreParenImpCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenImpCasts(x))
end

function getDecl(x::AbstractDeclRefExpr)
    @check_ptrs x
    return ValueDecl(clang_DeclRefExpr_getDecl(x))
end

function getFoundDecl(x::AbstractDeclRefExpr)
    @check_ptrs x
    return NamedDecl(clang_DeclRefExpr_getFoundDecl(x))
end

function hasQualifier(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_hasQualifier(x)
end

function getLocation(x::AbstractDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DeclRefExpr_getLocation(x))
end

function getNameInfo(x::AbstractDeclRefExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_DeclRefExpr_getNameInfo(x))
end

"""
    getValue(x::AbstractIntegerLiteral)
Return the value as a caller-owned `LLVMGenericValueRef` (release via LLVM-C's
`LLVMDisposeGenericValue`; no Julia `dispose` method exists for it).
"""
function getValue(x::AbstractIntegerLiteral)
    @check_ptrs x
    return clang_IntegerLiteral_getValue(x)
end

function getValue(x::AbstractCharacterLiteral)
    @check_ptrs x
    return clang_CharacterLiteral_getValue(x)
end

function getKind(x::AbstractCharacterLiteral)
    @check_ptrs x
    return clang_CharacterLiteral_getKind(x)
end

function getValueAsApproximateDouble(x::AbstractFloatingLiteral)
    @check_ptrs x
    return clang_FloatingLiteral_getValueAsApproximateDouble(x)
end

function getBytes(x::AbstractStringLiteral)
    @check_ptrs x
    return get_string(clang_StringLiteral_getBytes(x))
end

function getByteLength(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_getByteLength(x)
end

function getLength(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_getLength(x)
end

function getCharByteWidth(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_getCharByteWidth(x)
end

function getSubExpr(x::AbstractParenExpr)
    @check_ptrs x
    return Expr_(clang_ParenExpr_getSubExpr(x))
end

function getOpcode(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_getOpcode(x)
end

function getSubExpr(x::AbstractUnaryOperator)
    @check_ptrs x
    return Expr_(clang_UnaryOperator_getSubExpr(x))
end

function getOperatorLoc(x::AbstractUnaryOperator)
    @check_ptrs x
    return SourceLocation(clang_UnaryOperator_getOperatorLoc(x))
end

function isPrefix(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isPrefix(x)
end

function isPostfix(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isPostfix(x)
end

function isIncrementOp(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isIncrementOp(x)
end

function isDecrementOp(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isDecrementOp(x)
end

function getLHS(x::AbstractArraySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_ArraySubscriptExpr_getLHS(x))
end

function getRHS(x::AbstractArraySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_ArraySubscriptExpr_getRHS(x))
end

function getBase(x::AbstractArraySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_ArraySubscriptExpr_getBase(x))
end

function getIdx(x::AbstractArraySubscriptExpr)
    @check_ptrs x
    return Expr_(clang_ArraySubscriptExpr_getIdx(x))
end

function getCallee(x::AbstractCallExpr)
    @check_ptrs x
    return Expr_(clang_CallExpr_getCallee(x))
end

function getCalleeDecl(x::AbstractCallExpr)
    @check_ptrs x
    return Decl(clang_CallExpr_getCalleeDecl(x))
end

function getDirectCallee(x::AbstractCallExpr)
    @check_ptrs x
    return FunctionDecl(clang_CallExpr_getDirectCallee(x))
end

function getNumArgs(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_getNumArgs(x)
end

"""
    getArg(x::AbstractCallExpr, i)
Return the `i`-th argument (0-based, following the C++ API).
"""
function getArg(x::AbstractCallExpr, i::Integer)
    @check_ptrs x
    return Expr_(clang_CallExpr_getArg(x, i))
end

function getRParenLoc(x::AbstractCallExpr)
    @check_ptrs x
    return SourceLocation(clang_CallExpr_getRParenLoc(x))
end

function getBase(x::AbstractMemberExpr)
    @check_ptrs x
    return Expr_(clang_MemberExpr_getBase(x))
end

function getMemberDecl(x::AbstractMemberExpr)
    @check_ptrs x
    return ValueDecl(clang_MemberExpr_getMemberDecl(x))
end

function isArrow(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_isArrow(x)
end

function getMemberLoc(x::AbstractMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_MemberExpr_getMemberLoc(x))
end

function isImplicitAccess(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_isImplicitAccess(x)
end

function getMemberNameInfo(x::AbstractMemberExpr)
    @check_ptrs x
    return DeclarationNameInfo(clang_MemberExpr_getMemberNameInfo(x))
end

function getCastKind(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_getCastKind(x)
end

function getCastKindName(x::AbstractCastExpr)
    @check_ptrs x
    return unsafe_string(clang_CastExpr_getCastKindName(x))
end

function getSubExpr(x::AbstractCastExpr)
    @check_ptrs x
    return Expr_(clang_CastExpr_getSubExpr(x))
end

function getSubExprAsWritten(x::AbstractCastExpr)
    @check_ptrs x
    return Expr_(clang_CastExpr_getSubExprAsWritten(x))
end

function isPartOfExplicitCast(x::AbstractImplicitCastExpr)
    @check_ptrs x
    return clang_ImplicitCastExpr_isPartOfExplicitCast(x)
end

function getTypeAsWritten(x::AbstractExplicitCastExpr)
    @check_ptrs x
    return QualType(clang_ExplicitCastExpr_getTypeAsWritten(x))
end

function getOpcode(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_getOpcode(x)
end

function getLHS(x::AbstractBinaryOperator)
    @check_ptrs x
    return Expr_(clang_BinaryOperator_getLHS(x))
end

function getRHS(x::AbstractBinaryOperator)
    @check_ptrs x
    return Expr_(clang_BinaryOperator_getRHS(x))
end

function getOperatorLoc(x::AbstractBinaryOperator)
    @check_ptrs x
    return SourceLocation(clang_BinaryOperator_getOperatorLoc(x))
end

function getOpcodeStr(x::AbstractBinaryOperator)
    @check_ptrs x
    return unsafe_string(clang_BinaryOperator_getOpcodeStr(x))
end

function isAssignmentOp(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_isAssignmentOp(x)
end

function isCompoundAssignmentOp(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_isCompoundAssignmentOp(x)
end

function isComparisonOp(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_isComparisonOp(x)
end

function getComputationLHSType(x::AbstractCompoundAssignOperator)
    @check_ptrs x
    return QualType(clang_CompoundAssignOperator_getComputationLHSType(x))
end

function getComputationResultType(x::AbstractCompoundAssignOperator)
    @check_ptrs x
    return QualType(clang_CompoundAssignOperator_getComputationResultType(x))
end

function getCond(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getCond(x))
end

function getTrueExpr(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getTrueExpr(x))
end

function getFalseExpr(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getFalseExpr(x))
end

function getNumInits(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_getNumInits(x)
end

"""
    getInit(x::AbstractInitListExpr, i)
Return the `i`-th initializer (0-based, following the C++ API).
"""
function getInit(x::AbstractInitListExpr, i::Integer)
    @check_ptrs x
    return Expr_(clang_InitListExpr_getInit(x, i))
end

function isSemanticForm(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_isSemanticForm(x)
end

function getSyntacticForm(x::AbstractInitListExpr)
    @check_ptrs x
    return InitListExpr(clang_InitListExpr_getSyntacticForm(x))
end

function containsErrors(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_containsErrors(x)
end

function containsUnexpandedParameterPack(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_containsUnexpandedParameterPack(x)
end

function hasPlaceholderType(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_hasPlaceholderType(x)
end

function isDefaultArgument(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isDefaultArgument(x)
end

function isImplicitCXXThis(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isImplicitCXXThis(x)
end

function isInstantiationDependent(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isInstantiationDependent(x)
end

function isObjCSelfExpr(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isObjCSelfExpr(x)
end

function isOrdinaryOrBitFieldObject(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isOrdinaryOrBitFieldObject(x)
end

function isTypeDependent(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isTypeDependent(x)
end

function isValueDependent(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isValueDependent(x)
end

function refersToBitField(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_refersToBitField(x)
end

function refersToGlobalRegisterVar(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_refersToGlobalRegisterVar(x)
end

function refersToMatrixElement(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_refersToMatrixElement(x)
end

function refersToVectorElement(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_refersToVectorElement(x)
end

function getExprLoc(x::AbstractExpr)
    @check_ptrs x
    return SourceLocation(clang_Expr_getExprLoc(x))
end

# Fold `x` to a compile-time constant. The returned `APValue` wraps `C_NULL`
# when `x` is not a constant expression (check `.ptr`); a non-null result is
# owned — `dispose` it after use.
function EvaluateAsRValue(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return APValue(clang_Expr_EvaluateAsRValue(x, ctx))
end

function isEvaluatable(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isEvaluatable(x, ctx)
end

function isIntegerConstantExpr(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isIntegerConstantExpr(x, ctx)
end

function isCXX11ConstantExpr(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isCXX11ConstantExpr(x, ctx)
end

# 1/0 for a true/false constant condition, -1 when `x` is not a constant condition.
function EvaluateAsBooleanCondition(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_EvaluateAsBooleanCondition(x, ctx)
end

# Owned APValue (dispose) when `x` folds to an integer constant, else wraps C_NULL.
function EvaluateAsInt(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return APValue(clang_Expr_EvaluateAsInt(x, ctx))
end

# Folded float bits as a caller-owned LLVMGenericValueRef (release via LLVM-C),
# or C_NULL when `x` is not a floating constant.
function EvaluateAsFloat(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_EvaluateAsFloat(x, ctx)
end

# IntegerLiteral
function getBeginLoc(x::IntegerLiteral)
    @check_ptrs x
    return SourceLocation(clang_IntegerLiteral_getBeginLoc(x))
end

function getEndLoc(x::IntegerLiteral)
    @check_ptrs x
    return SourceLocation(clang_IntegerLiteral_getEndLoc(x))
end

function getLocation(x::IntegerLiteral)
    @check_ptrs x
    return SourceLocation(clang_IntegerLiteral_getLocation(x))
end


# UnaryExprOrTypeTraitExpr
function isArgumentType(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return clang_UnaryExprOrTypeTraitExpr_isArgumentType(x)
end

function getArgumentType(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return QualType(clang_UnaryExprOrTypeTraitExpr_getArgumentType(x))
end

function getTypeOfArgument(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return QualType(clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(x))
end

function getOperatorLoc(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return SourceLocation(clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(x))
end

function getRParenLoc(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return SourceLocation(clang_UnaryExprOrTypeTraitExpr_getRParenLoc(x))
end

function getArgumentExpr(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return Expr_(clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(x))
end

function getArgumentTypeInfo(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(x))
end

# StringLiteral
function isOrdinary(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isOrdinary(x)
end

function isWide(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isWide(x)
end

function isUTF8(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isUTF8(x)
end

function isUTF16(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isUTF16(x)
end

function isUTF32(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isUTF32(x)
end

function isUnevaluated(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isUnevaluated(x)
end

function isPascal(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_isPascal(x)
end

function containsNonAscii(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_containsNonAscii(x)
end

function containsNonAsciiOrNull(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_containsNonAsciiOrNull(x)
end

function getNumConcatenated(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_getNumConcatenated(x)
end

# CharacterLiteral
function getLocation(x::AbstractCharacterLiteral)
    @check_ptrs x
    return SourceLocation(clang_CharacterLiteral_getLocation(x))
end

# UnaryOperator
function canOverflow(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_canOverflow(x)
end

function isIncrementDecrementOp(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isIncrementDecrementOp(x)
end

function isArithmeticOp(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_isArithmeticOp(x)
end

function hasStoredFPFeatures(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_hasStoredFPFeatures(x)
end

# CallExpr
function usesADL(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_usesADL(x)
end

function hasStoredFPFeatures(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_hasStoredFPFeatures(x)
end

function getBuiltinCallee(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_getBuiltinCallee(x)
end

function isCallToStdMove(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_isCallToStdMove(x)
end

# MemberExpr
function hasQualifier(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_hasQualifier(x)
end

function getTemplateKeywordLoc(x::AbstractMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_MemberExpr_getTemplateKeywordLoc(x))
end

function getLAngleLoc(x::AbstractMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_MemberExpr_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_MemberExpr_getRAngleLoc(x))
end

function hasTemplateKeyword(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_hasTemplateKeyword(x)
end

function hasExplicitTemplateArgs(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_hasExplicitTemplateArgs(x)
end

function getNumTemplateArgs(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_getNumTemplateArgs(x)
end

function getOperatorLoc(x::AbstractMemberExpr)
    @check_ptrs x
    return SourceLocation(clang_MemberExpr_getOperatorLoc(x))
end

function hadMultipleCandidates(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_hadMultipleCandidates(x)
end

function getQualifier(x::AbstractMemberExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_MemberExpr_getQualifier(x))
end

# InitListExpr
function hasArrayFiller(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_hasArrayFiller(x)
end

function hasDesignatedInit(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_hasDesignatedInit(x)
end

function isExplicit(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_isExplicit(x)
end

function isStringLiteralInit(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_isStringLiteralInit(x)
end

function isTransparent(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_isTransparent(x)
end

function getLBraceLoc(x::AbstractInitListExpr)
    @check_ptrs x
    return SourceLocation(clang_InitListExpr_getLBraceLoc(x))
end

function getRBraceLoc(x::AbstractInitListExpr)
    @check_ptrs x
    return SourceLocation(clang_InitListExpr_getRBraceLoc(x))
end

function isSyntacticForm(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_isSyntacticForm(x)
end

function hadArrayRangeDesignator(x::AbstractInitListExpr)
    @check_ptrs x
    return clang_InitListExpr_hadArrayRangeDesignator(x)
end

function getArrayFiller(x::AbstractInitListExpr)
    @check_ptrs x
    return Expr_(clang_InitListExpr_getArrayFiller(x))
end

function getInitializedFieldInUnion(x::AbstractInitListExpr)
    @check_ptrs x
    return FieldDecl(clang_InitListExpr_getInitializedFieldInUnion(x))
end

function getSemanticForm(x::AbstractInitListExpr)
    @check_ptrs x
    return InitListExpr(clang_InitListExpr_getSemanticForm(x))
end

# ParenExpr
function getLParen(x::AbstractParenExpr)
    @check_ptrs x
    return SourceLocation(clang_ParenExpr_getLParen(x))
end

function getRParen(x::AbstractParenExpr)
    @check_ptrs x
    return SourceLocation(clang_ParenExpr_getRParen(x))
end

# ArraySubscriptExpr
function getRBracketLoc(x::AbstractArraySubscriptExpr)
    @check_ptrs x
    return SourceLocation(clang_ArraySubscriptExpr_getRBracketLoc(x))
end

# DeclRefExpr
function hasTemplateKWAndArgsInfo(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_hasTemplateKWAndArgsInfo(x)
end

function getTemplateKeywordLoc(x::AbstractDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DeclRefExpr_getTemplateKeywordLoc(x))
end

function getLAngleLoc(x::AbstractDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DeclRefExpr_getLAngleLoc(x))
end

function getRAngleLoc(x::AbstractDeclRefExpr)
    @check_ptrs x
    return SourceLocation(clang_DeclRefExpr_getRAngleLoc(x))
end

function hasTemplateKeyword(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_hasTemplateKeyword(x)
end

function hasExplicitTemplateArgs(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_hasExplicitTemplateArgs(x)
end

function getNumTemplateArgs(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_getNumTemplateArgs(x)
end

function hadMultipleCandidates(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_hadMultipleCandidates(x)
end

function refersToEnclosingVariableOrCapture(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_refersToEnclosingVariableOrCapture(x)
end

function isImmediateEscalating(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_isImmediateEscalating(x)
end

function isCapturedByCopyInLambdaWithExplicitObjectParameter(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(x)
end

function getQualifier(x::AbstractDeclRefExpr)
    @check_ptrs x
    return NestedNameSpecifier(clang_DeclRefExpr_getQualifier(x))
end

# ConstantExpr
function isImmediateInvocation(x::AbstractConstantExpr)
    @check_ptrs x
    return clang_ConstantExpr_isImmediateInvocation(x)
end

function hasAPValueResult(x::AbstractConstantExpr)
    @check_ptrs x
    return clang_ConstantExpr_hasAPValueResult(x)
end

# StmtExpr
function getLParenLoc(x::AbstractStmtExpr)
    @check_ptrs x
    return SourceLocation(clang_StmtExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractStmtExpr)
    @check_ptrs x
    return SourceLocation(clang_StmtExpr_getRParenLoc(x))
end

function getTemplateDepth(x::AbstractStmtExpr)
    @check_ptrs x
    return clang_StmtExpr_getTemplateDepth(x)
end

function getSubStmt(x::AbstractStmtExpr)
    @check_ptrs x
    return CompoundStmt(clang_StmtExpr_getSubStmt(x))
end

# CompoundLiteralExpr
function isFileScope(x::AbstractCompoundLiteralExpr)
    @check_ptrs x
    return clang_CompoundLiteralExpr_isFileScope(x)
end

function getLParenLoc(x::AbstractCompoundLiteralExpr)
    @check_ptrs x
    return SourceLocation(clang_CompoundLiteralExpr_getLParenLoc(x))
end

function getInitializer(x::AbstractCompoundLiteralExpr)
    @check_ptrs x
    return Expr_(clang_CompoundLiteralExpr_getInitializer(x))
end

function getTypeSourceInfo(x::AbstractCompoundLiteralExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_CompoundLiteralExpr_getTypeSourceInfo(x))
end

# StringLiteral
function getString(x::AbstractStringLiteral)
    @check_ptrs x
    return get_string(clang_StringLiteral_getString(x))
end

function getKind(x::AbstractStringLiteral)
    @check_ptrs x
    return clang_StringLiteral_getKind(x)
end

function getBeginLoc(x::AbstractStringLiteral)
    @check_ptrs x
    return SourceLocation(clang_StringLiteral_getBeginLoc(x))
end

function getEndLoc(x::AbstractStringLiteral)
    @check_ptrs x
    return SourceLocation(clang_StringLiteral_getEndLoc(x))
end

# UnaryExprOrTypeTraitExpr
function getKind(x::AbstractUnaryExprOrTypeTraitExpr)
    @check_ptrs x
    return clang_UnaryExprOrTypeTraitExpr_getKind(x)
end

# PredefinedExpr
function getIdentKind(x::AbstractPredefinedExpr)
    @check_ptrs x
    return clang_PredefinedExpr_getIdentKind(x)
end

function getFunctionName(x::AbstractPredefinedExpr)
    @check_ptrs x
    return StringLiteral(clang_PredefinedExpr_getFunctionName(x))
end

function getIdentKindName(x::AbstractPredefinedExpr)
    @check_ptrs x
    return get_string(clang_PredefinedExpr_getIdentKindName(x))
end

# CastExpr
"""
    getPathElement(x::AbstractCastExpr, i)
Return the `i`-th inheritance-path base specifier (0-based, `i < path_size()`).
"""
function getPathElement(x::AbstractCastExpr, i::Integer)
    @check_ptrs x
    return CXXBaseSpecifier(clang_CastExpr_getPathElement(x, i))
end


# CStyleCastExpr — the parenthesized cast's own paren locations and its
# class-declared begin/end locations.
function getLParenLoc(x::CStyleCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CStyleCastExpr_getLParenLoc(x))
end

function getRParenLoc(x::CStyleCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CStyleCastExpr_getRParenLoc(x))
end

function getBeginLoc(x::AbstractCStyleCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CStyleCastExpr_getBeginLoc(x))
end

function getEndLoc(x::AbstractCStyleCastExpr)
    @check_ptrs x
    return SourceLocation(clang_CStyleCastExpr_getEndLoc(x))
end
# IntegerLiteral — factory and location setter
function IntegerLiteral(ctx::ASTContext, val, ty::QualType, loc::SourceLocation)
    @check_ptrs ctx
    return IntegerLiteral(clang_IntegerLiteral_Create(ctx, val, ty, loc))
end

function setLocation(x::IntegerLiteral, loc::SourceLocation)
    @check_ptrs x
    return clang_IntegerLiteral_setLocation(x, loc)
end

# CStyleCastExpr — factories and paren-location setters
function CStyleCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CStyleCastExpr(clang_CStyleCastExpr_CreateEmpty(ctx, path_size, has_fp_features))
end

function CStyleCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind,
                        op::AbstractExpr)
    @check_ptrs ctx op
    return CStyleCastExpr(clang_CStyleCastExpr_CreateWithNoTypeInfo(ctx, ty, vk, k, op))
end

function setLParenLoc(x::CStyleCastExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CStyleCastExpr_setLParenLoc(x, loc)
end

function setRParenLoc(x::CStyleCastExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CStyleCastExpr_setRParenLoc(x, loc)
end


# Expr — the ASTContext-taking classification/evaluation tail
function getObjectKind(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_getObjectKind(x)
end

function getSourceBitField(x::AbstractExpr)
    @check_ptrs x
    return FieldDecl(clang_Expr_getSourceBitField(x))
end

function getReferencedDeclOfCallee(x::AbstractExpr)
    @check_ptrs x
    return Decl(clang_Expr_getReferencedDeclOfCallee(x))
end

"""
    getBestDynamicClassType(x::AbstractExpr) -> CXXRecordDecl
Return the best-known dynamic class of the object `x` designates.

`x` must have class type, or pointer-to-class type: clang reaches the record
through an unchecked `castAs<RecordType>`, so any other type is undefined
behaviour rather than a null result.
"""
function getBestDynamicClassType(x::AbstractExpr)
    @check_ptrs x
    ty = getTypePtr(getType(x))
    isPointerType(ty) && (ty = getTypePtr(getPointeeType(ty)))
    @assert isRecordType(ty) "expression must designate an object of class type"
    return CXXRecordDecl(clang_Expr_getBestDynamicClassType(x))
end

function isKnownToHaveBooleanValue(x::AbstractExpr, semantic::Bool=true)
    @check_ptrs x
    return clang_Expr_isKnownToHaveBooleanValue(x, semantic)
end

function IgnoreImplicit(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreImplicit(x))
end

function IgnoreImplicitAsWritten(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreImplicitAsWritten(x))
end

function IgnoreParenBaseCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenBaseCasts(x))
end

function IgnoreParenLValueCasts(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreParenLValueCasts(x))
end

function IgnoreUnlessSpelledInSource(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreUnlessSpelledInSource(x))
end

function IgnoreParenNoopCasts(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return Expr_(clang_Expr_IgnoreParenNoopCasts(x, ctx))
end

function isCXX98IntegralConstantExpr(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isCXX98IntegralConstantExpr(x, ctx)
end

function isConstantInitializer(x::AbstractExpr, ctx::ASTContext, for_ref::Bool)
    @check_ptrs x ctx
    return clang_Expr_isConstantInitializer(x, ctx, for_ref)
end

function getAsBuiltinConstantDeclRef(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return ValueDecl(clang_Expr_getAsBuiltinConstantDeclRef(x, ctx))
end

function HasSideEffects(x::AbstractExpr, ctx::ASTContext, include_possible::Bool=true)
    @check_ptrs x ctx
    return clang_Expr_HasSideEffects(x, ctx, include_possible)
end

function hasNonTrivialCall(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_hasNonTrivialCall(x, ctx)
end

function isBoundMemberFunction(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isBoundMemberFunction(x, ctx)
end

# `Expr::findBoundMemberType` is static; `x` is the operand, not a receiver.
function findBoundMemberType(x::AbstractExpr)
    @check_ptrs x
    return QualType(clang_Expr_findBoundMemberType(x))
end

# `Expr::isSameComparisonOperand` is static; both arguments are operands.
function isSameComparisonOperand(x::AbstractExpr, y::AbstractExpr)
    @check_ptrs x y
    return clang_Expr_isSameComparisonOperand(x, y)
end

function isTemporaryObject(x::AbstractExpr, ctx::ASTContext, temp_ty::AbstractCXXRecordDecl)
    @check_ptrs x ctx temp_ty
    return clang_Expr_isTemporaryObject(x, ctx, temp_ty)
end

# `Expr::getValueKindForType` is static; `ty` is the queried type.
getValueKindForType(ty::QualType) = clang_Expr_getValueKindForType(ty)

function isNullPointerConstant(x::AbstractExpr, ctx::ASTContext,
                               npc::CXExpr_NullPointerConstantValueDependence)
    @check_ptrs x ctx
    return clang_Expr_isNullPointerConstant(x, ctx, npc)
end

"""
    getIntegerConstantExpr(x::AbstractExpr, ctx::ASTContext)
Fold `x` to an integer constant expression, returning the value as a caller-owned
`LLVMGenericValueRef` (release via LLVM-C's `LLVMDisposeGenericValue`), or `C_NULL`
when `x` is not an integer constant expression.
"""
function getIntegerConstantExpr(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_getIntegerConstantExpr(x, ctx)
end

"""
    EvaluateKnownConstInt(x::AbstractExpr, ctx::ASTContext)
Return the folded integer as a caller-owned `LLVMGenericValueRef` (release via LLVM-C).
`x` must already be known to fold to an integer — check with
[`isIntegerConstantExpr`](@ref) first.
"""
function EvaluateKnownConstInt(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    @assert isIntegerConstantExpr(x, ctx) "EvaluateKnownConstInt on a non-constant expression"
    return clang_Expr_EvaluateKnownConstInt(x, ctx)
end

function EvaluateKnownConstIntCheckOverflow(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    @assert isIntegerConstantExpr(x, ctx) "EvaluateKnownConstIntCheckOverflow on a non-constant expression"
    return clang_Expr_EvaluateKnownConstIntCheckOverflow(x, ctx)
end

# Owned APValue (dispose) when `x` folds to a constant lvalue, else wraps C_NULL.
function EvaluateAsLValue(x::AbstractExpr, ctx::ASTContext, in_constant_context::Bool=false)
    @check_ptrs x ctx
    return APValue(clang_Expr_EvaluateAsLValue(x, ctx, in_constant_context))
end

# Owned APValue (dispose) when `x` is a constant expression, else wraps C_NULL.
function EvaluateAsConstantExpr(x::AbstractExpr, ctx::ASTContext,
                                kind::CXExpr_ConstantExprKind=CXExpr_ConstantExprKind_Normal)
    @check_ptrs x ctx
    return APValue(clang_Expr_EvaluateAsConstantExpr(x, ctx, kind))
end

"""
    tryEvaluateObjectSize(x::AbstractExpr, ctx::ASTContext, type::Integer) -> (Bool, UInt64)
Statically evaluate `__builtin_object_size(x, type)`. The size is meaningful only when
the first element of the returned pair is `true`.
"""
function tryEvaluateObjectSize(x::AbstractExpr, ctx::ASTContext, type::Integer)
    @check_ptrs x ctx
    out = Ref{UInt64}(0)
    ok = clang_Expr_tryEvaluateObjectSize(x, ctx, type, out)
    return ok, out[]
end

"""
    tryEvaluateStrLen(x::AbstractExpr, ctx::ASTContext) -> (Bool, UInt64)
Statically evaluate the `strlen` of the string `x` points at. The length is meaningful
only when the first element of the returned pair is `true`.
"""
function tryEvaluateStrLen(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    out = Ref{UInt64}(0)
    ok = clang_Expr_tryEvaluateStrLen(x, ctx, out)
    return ok, out[]
end

# BinaryOperator — the static opcode queries take an opcode, not a receiver.
getOverloadedOpcode(oo::CXOverloadedOperatorKind) = clang_BinaryOperator_getOverloadedOpcode(oo)

getOverloadedOperator(opc::CXBinaryOperatorKind) = clang_BinaryOperator_getOverloadedOperator(opc)

isPtrMemOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isPtrMemOp(opc)

isMultiplicativeOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isMultiplicativeOp(opc)

isAdditiveOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isAdditiveOp(opc)

isShiftOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isShiftOp(opc)

isBitwiseOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isBitwiseOp(opc)

isRelationalOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isRelationalOp(opc)

isEqualityOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isEqualityOp(opc)

isCommaOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isCommaOp(opc)

isLogicalOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isLogicalOp(opc)

isShiftAssignOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_isShiftAssignOp(opc)

negateComparisonOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_negateComparisonOp(opc)

reverseComparisonOp(opc::CXBinaryOperatorKind) = clang_BinaryOperator_reverseComparisonOp(opc)

function getOpForCompoundAssignment(opc::CXBinaryOperatorKind)
    return clang_BinaryOperator_getOpForCompoundAssignment(opc)
end

function isNullPointerArithmeticExtension(ctx::ASTContext, opc::CXBinaryOperatorKind,
                                          lhs::AbstractExpr, rhs::AbstractExpr)
    @check_ptrs ctx lhs rhs
    return clang_BinaryOperator_isNullPointerArithmeticExtension(ctx, opc, lhs, rhs)
end

function hasStoredFPFeatures(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_hasStoredFPFeatures(x)
end

# UnaryOperator — the static opcode queries take an opcode, not a receiver.
getOpcodeStr(op::CXUnaryOperatorKind) = unsafe_string(clang_UnaryOperator_getOpcodeStr(op))

function getOverloadedOpcode(oo::CXOverloadedOperatorKind, postfix::Bool)
    return clang_UnaryOperator_getOverloadedOpcode(oo, postfix)
end

getOverloadedOperator(opc::CXUnaryOperatorKind) = clang_UnaryOperator_getOverloadedOperator(opc)

function setOperatorLoc(x::AbstractUnaryOperator, loc::SourceLocation)
    @check_ptrs x
    return clang_UnaryOperator_setOperatorLoc(x, loc)
end

# CallExpr
function getCallReturnType(x::AbstractCallExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return QualType(clang_CallExpr_getCallReturnType(x, ctx))
end

# Wraps C_NULL when the callee carries no `warn_unused_result` attribute.
function getUnusedResultAttr(x::AbstractCallExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return Attr(clang_CallExpr_getUnusedResultAttr(x, ctx))
end

function hasUnusedResultAttr(x::AbstractCallExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_CallExpr_hasUnusedResultAttr(x, ctx)
end

function isUnevaluatedBuiltinCall(x::AbstractCallExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_CallExpr_isUnevaluatedBuiltinCall(x, ctx)
end

function isBuiltinAssumeFalse(x::AbstractCallExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_CallExpr_isBuiltinAssumeFalse(x, ctx)
end

function setRParenLoc(x::AbstractCallExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CallExpr_setRParenLoc(x, loc)
end

# MemberExpr
function getFoundDecl(x::AbstractMemberExpr)
    @check_ptrs x
    return NamedDecl(clang_MemberExpr_getFoundDecl(x))
end

# The access half of `MemberExpr::getFoundDecl()`'s DeclAccessPair.
function getFoundDeclAccess(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_getFoundDeclAccess(x)
end

"""
    getTemplateArg(x::AbstractMemberExpr, i)
Return the `i`-th explicit template argument (0-based, `i < getNumTemplateArgs()`).
"""
function getTemplateArg(x::AbstractMemberExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index $i out of range"
    return TemplateArgumentLoc(clang_MemberExpr_getTemplateArg(x, i))
end

function isNonOdrUse(x::AbstractMemberExpr)
    @check_ptrs x
    return clang_MemberExpr_isNonOdrUse(x)
end

function performsVirtualDispatch(x::AbstractMemberExpr, lang_opts::LangOptions)
    @check_ptrs x lang_opts
    return clang_MemberExpr_performsVirtualDispatch(x, lang_opts)
end

function setMemberLoc(x::AbstractMemberExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_MemberExpr_setMemberLoc(x, loc)
end

# DeclRefExpr
"""
    getTemplateArg(x::AbstractDeclRefExpr, i)
Return the `i`-th explicit template argument (0-based, `i < getNumTemplateArgs()`).
"""
function getTemplateArg(x::AbstractDeclRefExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumTemplateArgs(x) "template argument index $i out of range"
    return TemplateArgumentLoc(clang_DeclRefExpr_getTemplateArg(x, i))
end

function isNonOdrUse(x::AbstractDeclRefExpr)
    @check_ptrs x
    return clang_DeclRefExpr_isNonOdrUse(x)
end

function setLocation(x::AbstractDeclRefExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_DeclRefExpr_setLocation(x, loc)
end

"""
    getTargetFieldForToUnionCast(union_ty::QualType, op_ty::QualType) -> FieldDecl
Return the union member a `CK_ToUnion` cast initializes. `union_ty` must be a
union type: clang dereferences its record decl unconditionally, so a
non-union argument crashes rather than returning null.
"""
function getTargetFieldForToUnionCast(union_ty::QualType, op_ty::QualType)
    @assert isUnionType(getTypePtr(union_ty)) "union_ty must be a union type"
    return FieldDecl(clang_CastExpr_getTargetFieldForToUnionCast(union_ty, op_ty))
end

# ExplicitCastExpr
function getTypeInfoAsWritten(x::AbstractExplicitCastExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_ExplicitCastExpr_getTypeInfoAsWritten(x))
end

# InitListExpr
function isIdiomaticZeroInitializer(x::AbstractInitListExpr, lang_opts::LangOptions)
    @check_ptrs x lang_opts
    return clang_InitListExpr_isIdiomaticZeroInitializer(x, lang_opts)
end

function setLBraceLoc(x::AbstractInitListExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_InitListExpr_setLBraceLoc(x, loc)
end

function setRBraceLoc(x::AbstractInitListExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_InitListExpr_setRBraceLoc(x, loc)
end

# AbstractConditionalOperator
function getQuestionLoc(x::AbstractConditionalOperator)
    @check_ptrs x
    return SourceLocation(clang_AbstractConditionalOperator_getQuestionLoc(x))
end

function getColonLoc(x::AbstractConditionalOperator)
    @check_ptrs x
    return SourceLocation(clang_AbstractConditionalOperator_getColonLoc(x))
end

# ParenListExpr
function getNumExprs(x::AbstractParenListExpr)
    @check_ptrs x
    return clang_ParenListExpr_getNumExprs(x)
end

"""
    getExpr(x::AbstractParenListExpr, i)
Return the `i`-th parenthesized expression (0-based, `i < getNumExprs()`).
"""
function getExpr(x::AbstractParenListExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumExprs(x) "expression index $i out of range"
    return Expr_(clang_ParenListExpr_getExpr(x, i))
end

function getLParenLoc(x::AbstractParenListExpr)
    @check_ptrs x
    return SourceLocation(clang_ParenListExpr_getLParenLoc(x))
end

function getRParenLoc(x::AbstractParenListExpr)
    @check_ptrs x
    return SourceLocation(clang_ParenListExpr_getRParenLoc(x))
end

# ConstantExpr
"""
    getResultAsAPSInt(x::AbstractConstantExpr)
Return the stored integral result as a caller-owned `LLVMGenericValueRef` (release via
LLVM-C's `LLVMDisposeGenericValue`). Requires an integral stored result.
"""
function getResultAsAPSInt(x::AbstractConstantExpr)
    @check_ptrs x
    @assert hasAPValueResult(x) "getResultAsAPSInt on a ConstantExpr with no stored result"
    return clang_ConstantExpr_getResultAsAPSInt(x)
end

"""
    getAPValueResult(x::AbstractConstantExpr)
Return an owned copy of the stored result.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function getAPValueResult(x::AbstractConstantExpr)
    @check_ptrs x
    return APValue(clang_ConstantExpr_getAPValueResult(x))
end

# FloatingLiteral
"""
    getValue(x::AbstractFloatingLiteral)
Return the exact value's bit pattern (`APFloat::bitcastToAPInt`) as a caller-owned
`LLVMGenericValueRef` (release via LLVM-C's `LLVMDisposeGenericValue`).
"""
function getValue(x::AbstractFloatingLiteral)
    @check_ptrs x
    return clang_FloatingLiteral_getValue(x)
end

function isExact(x::AbstractFloatingLiteral)
    @check_ptrs x
    return clang_FloatingLiteral_isExact(x)
end

function getLocation(x::AbstractFloatingLiteral)
    @check_ptrs x
    return SourceLocation(clang_FloatingLiteral_getLocation(x))
end

function setLocation(x::AbstractFloatingLiteral, loc::SourceLocation)
    @check_ptrs x
    return clang_FloatingLiteral_setLocation(x, loc)
end

# StringLiteral
"""
    getCodeUnit(x::AbstractStringLiteral, i)
Return the `i`-th code unit (0-based, `i < getLength()`).
"""
function getCodeUnit(x::AbstractStringLiteral, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getLength(x) "code unit index $i out of range"
    return clang_StringLiteral_getCodeUnit(x, i)
end

"""
    getStrTokenLoc(x::AbstractStringLiteral, i)
Return the location of the `i`-th concatenated token (0-based,
`i < getNumConcatenated()`).
"""
function getStrTokenLoc(x::AbstractStringLiteral, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumConcatenated(x) "token index $i out of range"
    return SourceLocation(clang_StringLiteral_getStrTokenLoc(x, i))
end

# DesignatedInitExpr
function Base.size(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return clang_DesignatedInitExpr_size(x)
end

"""
    getDesignator(x::AbstractDesignatedInitExpr, i)
Return the `i`-th designator (0-based, `i < size(x)`). The `Designator` is interior to
`x` and must not outlive it.
"""
function getDesignator(x::AbstractDesignatedInitExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "designator index $i out of range"
    return Designator(clang_DesignatedInitExpr_getDesignator(x, i))
end

function getArrayIndex(x::AbstractDesignatedInitExpr, d::AbstractDesignator)
    @check_ptrs x d
    return Expr_(clang_DesignatedInitExpr_getArrayIndex(x, d))
end

function getArrayRangeStart(x::AbstractDesignatedInitExpr, d::AbstractDesignator)
    @check_ptrs x d
    return Expr_(clang_DesignatedInitExpr_getArrayRangeStart(x, d))
end

function getArrayRangeEnd(x::AbstractDesignatedInitExpr, d::AbstractDesignator)
    @check_ptrs x d
    return Expr_(clang_DesignatedInitExpr_getArrayRangeEnd(x, d))
end

function getDesignatorsSourceRange(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    r = clang_DesignatedInitExpr_getDesignatorsSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getEqualOrColonLoc(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return SourceLocation(clang_DesignatedInitExpr_getEqualOrColonLoc(x))
end

function isDirectInit(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return clang_DesignatedInitExpr_isDirectInit(x)
end

function usesGNUSyntax(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return clang_DesignatedInitExpr_usesGNUSyntax(x)
end

function getInit(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return Expr_(clang_DesignatedInitExpr_getInit(x))
end

function getNumSubExprs(x::AbstractDesignatedInitExpr)
    @check_ptrs x
    return clang_DesignatedInitExpr_getNumSubExprs(x)
end

"""
    getSubExpr(x::AbstractDesignatedInitExpr, i)
Return the `i`-th subexpression (0-based, `i < getNumSubExprs()`); slot 0 is the
initializer and the rest are the array-designator index expressions.
"""
function getSubExpr(x::AbstractDesignatedInitExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSubExprs(x) "subexpression index $i out of range"
    return Expr_(clang_DesignatedInitExpr_getSubExpr(x, i))
end

# DesignatedInitExpr::Designator
function isFieldDesignator(x::AbstractDesignator)
    @check_ptrs x
    return clang_Designator_isFieldDesignator(x)
end

function isArrayDesignator(x::AbstractDesignator)
    @check_ptrs x
    return clang_Designator_isArrayDesignator(x)
end

function isArrayRangeDesignator(x::AbstractDesignator)
    @check_ptrs x
    return clang_Designator_isArrayRangeDesignator(x)
end

function getFieldName(x::AbstractDesignator)
    @check_ptrs x
    @assert isFieldDesignator(x) "getFieldName on a non-field designator"
    return IdentifierInfo(clang_Designator_getFieldName(x))
end

# Wraps C_NULL until Sema resolves the designated name to a field.
function getFieldDecl(x::AbstractDesignator)
    @check_ptrs x
    @assert isFieldDesignator(x) "getFieldDecl on a non-field designator"
    return FieldDecl(clang_Designator_getFieldDecl(x))
end

function getDotLoc(x::AbstractDesignator)
    @check_ptrs x
    @assert isFieldDesignator(x) "getDotLoc on a non-field designator"
    return SourceLocation(clang_Designator_getDotLoc(x))
end

function getFieldLoc(x::AbstractDesignator)
    @check_ptrs x
    @assert isFieldDesignator(x) "getFieldLoc on a non-field designator"
    return SourceLocation(clang_Designator_getFieldLoc(x))
end

function getArrayIndex(x::AbstractDesignator)
    @check_ptrs x
    @assert isArrayDesignator(x) || isArrayRangeDesignator(x) "getArrayIndex on a non-array designator"
    return clang_Designator_getArrayIndex(x)
end

function getLBracketLoc(x::AbstractDesignator)
    @check_ptrs x
    @assert isArrayDesignator(x) || isArrayRangeDesignator(x) "getLBracketLoc on a non-array designator"
    return SourceLocation(clang_Designator_getLBracketLoc(x))
end

function getEllipsisLoc(x::AbstractDesignator)
    @check_ptrs x
    @assert isArrayRangeDesignator(x) "getEllipsisLoc on a non-array-range designator"
    return SourceLocation(clang_Designator_getEllipsisLoc(x))
end

function getRBracketLoc(x::AbstractDesignator)
    @check_ptrs x
    @assert isArrayDesignator(x) || isArrayRangeDesignator(x) "getRBracketLoc on a non-array designator"
    return SourceLocation(clang_Designator_getRBracketLoc(x))
end

function getBeginLoc(x::AbstractDesignator)
    @check_ptrs x
    return SourceLocation(clang_Designator_getBeginLoc(x))
end

function getEndLoc(x::AbstractDesignator)
    @check_ptrs x
    return SourceLocation(clang_Designator_getEndLoc(x))
end


# AtomicExpr
function getOp(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_getOp(x)
end

function getOpAsString(x::AbstractAtomicExpr)
    @check_ptrs x
    return get_string(clang_AtomicExpr_getOpAsString(x))
end

function getNumSubExprs(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_getNumSubExprs(x)
end

function getSubExpr(x::AbstractAtomicExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSubExprs(x) "atomic sub-expression index out of range"
    return Expr_(clang_AtomicExpr_getSubExpr(x, i))
end

function isCmpXChg(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_isCmpXChg(x)
end

# GenericSelectionExpr
function getNumAssocs(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return clang_GenericSelectionExpr_getNumAssocs(x)
end

function isResultDependent(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return clang_GenericSelectionExpr_isResultDependent(x)
end

function getResultIndex(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    @assert !isResultDependent(x) "getResultIndex on a result-dependent generic selection"
    return clang_GenericSelectionExpr_getResultIndex(x)
end

function isExprPredicate(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return clang_GenericSelectionExpr_isExprPredicate(x)
end

function getControllingExpr(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    @assert isExprPredicate(x) "getControllingExpr on a type-predicated generic selection"
    return Expr_(clang_GenericSelectionExpr_getControllingExpr(x))
end

function getAssocExpr(x::AbstractGenericSelectionExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAssocs(x) "association index out of range"
    return Expr_(clang_GenericSelectionExpr_getAssocExpr(x, i))
end

# ChooseExpr
function getCond(x::AbstractChooseExpr)
    @check_ptrs x
    return Expr_(clang_ChooseExpr_getCond(x))
end

function getLHS(x::AbstractChooseExpr)
    @check_ptrs x
    return Expr_(clang_ChooseExpr_getLHS(x))
end

function getRHS(x::AbstractChooseExpr)
    @check_ptrs x
    return Expr_(clang_ChooseExpr_getRHS(x))
end

function isConditionDependent(x::AbstractChooseExpr)
    @check_ptrs x
    return clang_ChooseExpr_isConditionDependent(x)
end

function isConditionTrue(x::AbstractChooseExpr)
    @check_ptrs x
    @assert !isConditionDependent(x) "isConditionTrue on a dependent __builtin_choose_expr condition"
    return clang_ChooseExpr_isConditionTrue(x)
end

# ShuffleVectorExpr
function getNumSubExprs(x::AbstractShuffleVectorExpr)
    @check_ptrs x
    return clang_ShuffleVectorExpr_getNumSubExprs(x)
end

function getExpr(x::AbstractShuffleVectorExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSubExprs(x) "shuffle operand index out of range"
    return Expr_(clang_ShuffleVectorExpr_getExpr(x, i))
end

# ExtVectorElementExpr
function getBase(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return Expr_(clang_ExtVectorElementExpr_getBase(x))
end

function getNumElements(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return clang_ExtVectorElementExpr_getNumElements(x)
end


# OpaqueValueExpr
function getLocation(x::AbstractOpaqueValueExpr)
    @check_ptrs x
    return SourceLocation(clang_OpaqueValueExpr_getLocation(x))
end

# The source expression may be null (an OpaqueValueExpr synthesised without one).
function getSourceExpr(x::AbstractOpaqueValueExpr)
    @check_ptrs x
    return Expr_(clang_OpaqueValueExpr_getSourceExpr(x))
end

function isUnique(x::AbstractOpaqueValueExpr)
    @check_ptrs x
    return clang_OpaqueValueExpr_isUnique(x)
end

# ConditionalOperator (getLHS/getRHS are declared on the concrete class; the
# abstract base is shared with BinaryConditionalOperator, so the receiver is the
# concrete carrier to keep dispatch from accepting a BinaryConditionalOperator).
function getLHS(x::ConditionalOperator)
    @check_ptrs x
    return Expr_(clang_ConditionalOperator_getLHS(x))
end

function getRHS(x::ConditionalOperator)
    @check_ptrs x
    return Expr_(clang_ConditionalOperator_getRHS(x))
end

# BinaryConditionalOperator
function getCommon(x::AbstractBinaryConditionalOperator)
    @check_ptrs x
    return Expr_(clang_BinaryConditionalOperator_getCommon(x))
end

function getOpaqueValue(x::AbstractBinaryConditionalOperator)
    @check_ptrs x
    return OpaqueValueExpr(clang_BinaryConditionalOperator_getOpaqueValue(x))
end

# AddrLabelExpr
function getAmpAmpLoc(x::AbstractAddrLabelExpr)
    @check_ptrs x
    return SourceLocation(clang_AddrLabelExpr_getAmpAmpLoc(x))
end

function getLabelLoc(x::AbstractAddrLabelExpr)
    @check_ptrs x
    return SourceLocation(clang_AddrLabelExpr_getLabelLoc(x))
end

function getLabel(x::AbstractAddrLabelExpr)
    @check_ptrs x
    return LabelDecl(clang_AddrLabelExpr_getLabel(x))
end

# GNUNullExpr
function getTokenLocation(x::AbstractGNUNullExpr)
    @check_ptrs x
    return SourceLocation(clang_GNUNullExpr_getTokenLocation(x))
end

# VAArgExpr
function getSubExpr(x::AbstractVAArgExpr)
    @check_ptrs x
    return Expr_(clang_VAArgExpr_getSubExpr(x))
end

function isMicrosoftABI(x::AbstractVAArgExpr)
    @check_ptrs x
    return clang_VAArgExpr_isMicrosoftABI(x)
end

function getWrittenTypeInfo(x::AbstractVAArgExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_VAArgExpr_getWrittenTypeInfo(x))
end

function getBuiltinLoc(x::AbstractVAArgExpr)
    @check_ptrs x
    return SourceLocation(clang_VAArgExpr_getBuiltinLoc(x))
end

function getRParenLoc(x::AbstractVAArgExpr)
    @check_ptrs x
    return SourceLocation(clang_VAArgExpr_getRParenLoc(x))
end


# ImaginaryLiteral
function getSubExpr(x::AbstractImaginaryLiteral)
    @check_ptrs x
    return Expr_(clang_ImaginaryLiteral_getSubExpr(x))
end

# MatrixSubscriptExpr
function isIncomplete(x::AbstractMatrixSubscriptExpr)
    @check_ptrs x
    return clang_MatrixSubscriptExpr_isIncomplete(x)
end

function getBase(x::AbstractMatrixSubscriptExpr)
    @check_ptrs x
    return Expr_(clang_MatrixSubscriptExpr_getBase(x))
end

function getRowIdx(x::AbstractMatrixSubscriptExpr)
    @check_ptrs x
    return Expr_(clang_MatrixSubscriptExpr_getRowIdx(x))
end

# getColumnIdx wraps a null carrier for an incomplete subscript.
function getColumnIdx(x::AbstractMatrixSubscriptExpr)
    @check_ptrs x
    return Expr_(clang_MatrixSubscriptExpr_getColumnIdx(x))
end

function getRBracketLoc(x::AbstractMatrixSubscriptExpr)
    @check_ptrs x
    return SourceLocation(clang_MatrixSubscriptExpr_getRBracketLoc(x))
end

# ConvertVectorExpr
function getSrcExpr(x::AbstractConvertVectorExpr)
    @check_ptrs x
    return Expr_(clang_ConvertVectorExpr_getSrcExpr(x))
end

function getTypeSourceInfo(x::AbstractConvertVectorExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_ConvertVectorExpr_getTypeSourceInfo(x))
end

function getBuiltinLoc(x::AbstractConvertVectorExpr)
    @check_ptrs x
    return SourceLocation(clang_ConvertVectorExpr_getBuiltinLoc(x))
end

function getRParenLoc(x::AbstractConvertVectorExpr)
    @check_ptrs x
    return SourceLocation(clang_ConvertVectorExpr_getRParenLoc(x))
end

# ChooseExpr
function getChosenSubExpr(x::AbstractChooseExpr)
    @check_ptrs x
    @assert !isConditionDependent(x) "condition must not be value/type dependent"
    return Expr_(clang_ChooseExpr_getChosenSubExpr(x))
end

function getBuiltinLoc(x::AbstractChooseExpr)
    @check_ptrs x
    return SourceLocation(clang_ChooseExpr_getBuiltinLoc(x))
end

function getRParenLoc(x::AbstractChooseExpr)
    @check_ptrs x
    return SourceLocation(clang_ChooseExpr_getRParenLoc(x))
end

# SourceLocExpr
function getBuiltinStr(x::AbstractSourceLocExpr)
    @check_ptrs x
    return get_string(clang_SourceLocExpr_getBuiltinStr(x))
end

function isIntType(x::AbstractSourceLocExpr)
    @check_ptrs x
    return clang_SourceLocExpr_isIntType(x)
end

function getParentContext(x::AbstractSourceLocExpr)
    @check_ptrs x
    return DeclContext(clang_SourceLocExpr_getParentContext(x))
end

function getLocation(x::AbstractSourceLocExpr)
    @check_ptrs x
    return SourceLocation(clang_SourceLocExpr_getLocation(x))
end

# BlockExpr
function getBlockDecl(x::AbstractBlockExpr)
    @check_ptrs x
    return BlockDecl(clang_BlockExpr_getBlockDecl(x))
end

function getCaretLocation(x::AbstractBlockExpr)
    @check_ptrs x
    return SourceLocation(clang_BlockExpr_getCaretLocation(x))
end

function getBody(x::AbstractBlockExpr)
    @check_ptrs x
    return Stmt(clang_BlockExpr_getBody(x))
end


# AtomicExpr
function getPtr(x::AbstractAtomicExpr)
    @check_ptrs x
    return Expr_(clang_AtomicExpr_getPtr(x))
end

function getOrder(x::AbstractAtomicExpr)
    @check_ptrs x
    return Expr_(clang_AtomicExpr_getOrder(x))
end

function getValueType(x::AbstractAtomicExpr)
    @check_ptrs x
    return QualType(clang_AtomicExpr_getValueType(x))
end

function isVolatile(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_isVolatile(x)
end

function isOpenCL(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_isOpenCL(x)
end

function getBuiltinLoc(x::AbstractAtomicExpr)
    @check_ptrs x
    return SourceLocation(clang_AtomicExpr_getBuiltinLoc(x))
end

function getRParenLoc(x::AbstractAtomicExpr)
    @check_ptrs x
    return SourceLocation(clang_AtomicExpr_getRParenLoc(x))
end

# GenericSelectionExpr
function isTypePredicate(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return clang_GenericSelectionExpr_isTypePredicate(x)
end

function getResultExpr(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    @assert !isResultDependent(x) "getResultExpr on a result-dependent generic selection"
    return Expr_(clang_GenericSelectionExpr_getResultExpr(x))
end

function getGenericLoc(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return SourceLocation(clang_GenericSelectionExpr_getGenericLoc(x))
end

function getDefaultLoc(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return SourceLocation(clang_GenericSelectionExpr_getDefaultLoc(x))
end

function getRParenLoc(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    return SourceLocation(clang_GenericSelectionExpr_getRParenLoc(x))
end

# ArrayInitLoopExpr
function getCommonExpr(x::AbstractArrayInitLoopExpr)
    @check_ptrs x
    return OpaqueValueExpr(clang_ArrayInitLoopExpr_getCommonExpr(x))
end

function getSubExpr(x::AbstractArrayInitLoopExpr)
    @check_ptrs x
    return Expr_(clang_ArrayInitLoopExpr_getSubExpr(x))
end

# PseudoObjectExpr
function getSyntacticForm(x::AbstractPseudoObjectExpr)
    @check_ptrs x
    return Expr_(clang_PseudoObjectExpr_getSyntacticForm(x))
end

function getResultExprIndex(x::AbstractPseudoObjectExpr)
    @check_ptrs x
    return clang_PseudoObjectExpr_getResultExprIndex(x)
end

function getResultExpr(x::AbstractPseudoObjectExpr)
    @check_ptrs x
    return Expr_(clang_PseudoObjectExpr_getResultExpr(x))
end

function getNumSemanticExprs(x::AbstractPseudoObjectExpr)
    @check_ptrs x
    return clang_PseudoObjectExpr_getNumSemanticExprs(x)
end

function getSemanticExpr(x::AbstractPseudoObjectExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSemanticExprs(x) "semantic expression index out of range"
    return Expr_(clang_PseudoObjectExpr_getSemanticExpr(x, i))
end


# OffsetOfNode
function getKind(x::AbstractOffsetOfNode)
    @check_ptrs x
    return clang_OffsetOfNode_getKind(x)
end

"""
    getArrayExprIndex(x::AbstractOffsetOfNode) -> UInt32
Return the index, into the owning `OffsetOfExpr`'s operand list, of the subscript
expression this component designates (see `getIndexExpr`).

`x` must be an array component: clang asserts `getKind(x) == CXOffsetOfNode_Kind_Array`
and otherwise reads an unrelated pointer payload as a shifted index.
"""
function getArrayExprIndex(x::AbstractOffsetOfNode)
    @check_ptrs x
    @assert getKind(x) == CXOffsetOfNode_Kind_Array "component is not an array subscript"
    return clang_OffsetOfNode_getArrayExprIndex(x)
end

"""
    getField(x::AbstractOffsetOfNode) -> FieldDecl
Return the field this component designates.

`x` must be a field component: clang asserts `getKind(x) == CXOffsetOfNode_Kind_Field` and
otherwise reinterprets an unrelated payload as a `FieldDecl *`.
"""
function getField(x::AbstractOffsetOfNode)
    @check_ptrs x
    @assert getKind(x) == CXOffsetOfNode_Kind_Field "component does not designate a field"
    return FieldDecl(clang_OffsetOfNode_getField(x))
end

"""
    getFieldName(x::AbstractOffsetOfNode) -> IdentifierInfo
Return the name of the field this component designates.

`x` must be a field or identifier component (clang asserts the kind). The returned carrier
holds NULL when the field is unnamed.
"""
function getFieldName(x::AbstractOffsetOfNode)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXOffsetOfNode_Kind_Field || k == CXOffsetOfNode_Kind_Identifier "names no field"
    return IdentifierInfo(clang_OffsetOfNode_getFieldName(x))
end

"""
    getBase(x::AbstractOffsetOfNode) -> CXXBaseSpecifier
Return the base-class specifier this component steps through.

`x` must be a base component: clang asserts `getKind(x) == CXOffsetOfNode_Kind_Base` and
otherwise reinterprets an unrelated payload as a `CXXBaseSpecifier *`.
"""
function getBase(x::AbstractOffsetOfNode)
    @check_ptrs x
    @assert getKind(x) == CXOffsetOfNode_Kind_Base "component is not a base-class step"
    return CXXBaseSpecifier(clang_OffsetOfNode_getBase(x))
end

"""
    getSourceRange(x::AbstractOffsetOfNode) -> SourceRange
Return the source range covering this component.

A base component is synthesised from a base-class path and has no written range, so both
of its locations are invalid.
"""
function getSourceRange(x::AbstractOffsetOfNode)
    @check_ptrs x
    r = clang_OffsetOfNode_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getBeginLoc(x::AbstractOffsetOfNode)
    @check_ptrs x
    return SourceLocation(clang_OffsetOfNode_getBeginLoc(x))
end

function getEndLoc(x::AbstractOffsetOfNode)
    @check_ptrs x
    return SourceLocation(clang_OffsetOfNode_getEndLoc(x))
end

# OffsetOfExpr
function getOperatorLoc(x::AbstractOffsetOfExpr)
    @check_ptrs x
    return SourceLocation(clang_OffsetOfExpr_getOperatorLoc(x))
end

function getRParenLoc(x::AbstractOffsetOfExpr)
    @check_ptrs x
    return SourceLocation(clang_OffsetOfExpr_getRParenLoc(x))
end

function getTypeSourceInfo(x::AbstractOffsetOfExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_OffsetOfExpr_getTypeSourceInfo(x))
end

"""
    getComponent(x::AbstractOffsetOfExpr, i) -> OffsetOfNode
Return the `i`-th member-designator component (0-based, `i < getNumComponents(x)`).

The node is interior to `x`'s trailing storage (AST-arena memory): it is borrowed and must
not be disposed.
"""
function getComponent(x::AbstractOffsetOfExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumComponents(x) "offsetof component index out of range"
    return OffsetOfNode(clang_OffsetOfExpr_getComponent(x, i))
end

function getNumComponents(x::AbstractOffsetOfExpr)
    @check_ptrs x
    return clang_OffsetOfExpr_getNumComponents(x)
end

"""
    getIndexExpr(x::AbstractOffsetOfExpr, i) -> Expr_
Return the `i`-th array-subscript operand (0-based, `i < getNumExpressions(x)`) — the one an
array component selects with `getArrayExprIndex`.
"""
function getIndexExpr(x::AbstractOffsetOfExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumExpressions(x) "offsetof index-expression index out of range"
    return Expr_(clang_OffsetOfExpr_getIndexExpr(x, i))
end

function getNumExpressions(x::AbstractOffsetOfExpr)
    @check_ptrs x
    return clang_OffsetOfExpr_getNumExpressions(x)
end

# ExtVectorElementExpr
function getAccessor(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return IdentifierInfo(clang_ExtVectorElementExpr_getAccessor(x))
end

function getAccessorLoc(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return SourceLocation(clang_ExtVectorElementExpr_getAccessorLoc(x))
end

function containsDuplicateElements(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return clang_ExtVectorElementExpr_containsDuplicateElements(x)
end

function isArrow(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    return clang_ExtVectorElementExpr_isArrow(x)
end

# Expr
"""
    IgnoreConversionOperatorSingleStep(x::AbstractExpr) -> Expr_
Return the implicit object argument when `x` is a call to a conversion operator, and `x`
itself otherwise. This is a single step, not a fixed point.
"""
function IgnoreConversionOperatorSingleStep(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_IgnoreConversionOperatorSingleStep(x))
end


# Expr
"""
    setType(x::AbstractExpr, ty::QualType)
Set the type `x` produces.

`Expr::setType` asserts the new type is not a reference type — C++ [expr]p6 adjusts every
expression's type so a reference never survives — and this wrapper restates that. It also
requires a non-null `ty`, where upstream additionally accepts a null `QualType`.
"""
function setType(x::AbstractExpr, ty::QualType)
    @check_ptrs x ty
    @assert !isReferenceType(getTypePtr(ty)) "an expression cannot have reference type"
    return clang_Expr_setType(x, ty)
end

function isReadIfDiscardedInCPlusPlus11(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_isReadIfDiscardedInCPlusPlus11(x)
end

function setValueKind(x::AbstractExpr, kind::CXExprValueKind)
    @check_ptrs x
    return clang_Expr_setValueKind(x, kind)
end

function setObjectKind(x::AbstractExpr, kind::CXExprObjectKind)
    @check_ptrs x
    return clang_Expr_setObjectKind(x, kind)
end

"""
    getBestDynamicClassTypeExpr(x::AbstractExpr) -> Expr_
Return the inner expression that determines `x`'s best dynamic class.

This is the `Expr`-returning half of `getBestDynamicClassType`: it steps out through
paren/base casts, comma right operands and materialized temporaries, and returns `x` itself
when none of those apply. Unlike `getBestDynamicClassType` it needs no class type — it is
total.
"""
function getBestDynamicClassTypeExpr(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_getBestDynamicClassTypeExpr(x))
end

"""
    skipRValueSubobjectAdjustments(x::AbstractExpr) -> Expr_
Walk outwards from `x` to the expression whose lifetime a bound reference would extend.

This wraps the no-argument overload: the comma left operands and the subobject adjustments
recorded along the way stay inside the C shim. `x` itself comes back when the walk finds
nothing to skip.
"""
function skipRValueSubobjectAdjustments(x::AbstractExpr)
    @check_ptrs x
    return Expr_(clang_Expr_skipRValueSubobjectAdjustments(x))
end

# FullExpr
function getSubExpr(x::AbstractFullExpr)
    @check_ptrs x
    return Expr_(clang_FullExpr_getSubExpr(x))
end

# ConstantExpr
function getResultStorageKind(x::AbstractConstantExpr)
    @check_ptrs x
    return clang_ConstantExpr_getResultStorageKind(x)
end

"""
    getResultAPValueKind(x::AbstractConstantExpr) -> CXAPValueKind
Return the kind of the folded result cached in `x`.

`CXAPValueKind_None` means no result is cached — the same condition `hasAPValueResult`
reports.
"""
function getResultAPValueKind(x::AbstractConstantExpr)
    @check_ptrs x
    return clang_ConstantExpr_getResultAPValueKind(x)
end

# ShuffleVectorExpr
function getBuiltinLoc(x::AbstractShuffleVectorExpr)
    @check_ptrs x
    return SourceLocation(clang_ShuffleVectorExpr_getBuiltinLoc(x))
end

function setBuiltinLoc(x::AbstractShuffleVectorExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ShuffleVectorExpr_setBuiltinLoc(x, loc)
end

function getRParenLoc(x::AbstractShuffleVectorExpr)
    @check_ptrs x
    return SourceLocation(clang_ShuffleVectorExpr_getRParenLoc(x))
end

function setRParenLoc(x::AbstractShuffleVectorExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ShuffleVectorExpr_setRParenLoc(x, loc)
end

# SourceLocExpr
function getIdentKind(x::AbstractSourceLocExpr)
    @check_ptrs x
    return clang_SourceLocExpr_getIdentKind(x)
end

"""
    MayBeDependent(kind::CXSourceLocIdentKind) -> Bool
Return whether a `SourceLocExpr` of `kind` can be value-dependent.

`SourceLocExpr::MayBeDependent` is static: `kind` is the queried kind, not a receiver.
"""
MayBeDependent(kind::CXSourceLocIdentKind) = clang_SourceLocExpr_MayBeDependent(kind)

# BlockExpr
"""
    getFunctionType(x::AbstractBlockExpr) -> FunctionProtoType
Return the prototyped function type underlying the block literal `x`.

Upstream reaches it through an unchecked
`cast<BlockPointerType>(getType())->getPointeeType()->castAs<FunctionProtoType>()`; the
block-pointer half of that precondition is restated here.
"""
function getFunctionType(x::AbstractBlockExpr)
    @check_ptrs x
    @assert isBlockPointerType(getTypePtr(getType(x))) "a block literal must have block-pointer type"
    return FunctionProtoType(clang_BlockExpr_getFunctionType(x))
end

# AtomicExpr
"""
    getVal1(x::AbstractAtomicExpr) -> Expr_
Return the first value operand of the atomic builtin `x`.

Upstream asserts `getNumSubExprs(x) > 2` on the general path, which this wrapper restates.
The two initialisation builtins (`__c11_atomic_init`, `__opencl_atomic_init`) instead read
operand slot 1 and carry only two operands; reach that one with `getSubExpr(x, 1)`.
"""
function getVal1(x::AbstractAtomicExpr)
    @check_ptrs x
    @assert getNumSubExprs(x) > 2 "this atomic builtin has no VAL1 operand slot"
    return Expr_(clang_AtomicExpr_getVal1(x))
end

function getOrderFail(x::AbstractAtomicExpr)
    @check_ptrs x
    @assert getNumSubExprs(x) > 3 "this atomic builtin has no ORDER_FAIL operand slot"
    return Expr_(clang_AtomicExpr_getOrderFail(x))
end

"""
    getVal2(x::AbstractAtomicExpr) -> Expr_
Return the second value operand of the atomic builtin `x`.

Upstream asserts `getNumSubExprs(x) > 4` on the general path, which this wrapper restates.
The two exchange builtins (`__atomic_exchange`, `__scoped_atomic_exchange`) instead read
operand slot 3 and carry only four operands; reach that one with `getSubExpr(x, 3)`.
"""
function getVal2(x::AbstractAtomicExpr)
    @check_ptrs x
    @assert getNumSubExprs(x) > 4 "this atomic builtin has no VAL2 operand slot"
    return Expr_(clang_AtomicExpr_getVal2(x))
end

function getWeak(x::AbstractAtomicExpr)
    @check_ptrs x
    @assert getNumSubExprs(x) > 5 "this atomic builtin has no WEAK operand slot"
    return Expr_(clang_AtomicExpr_getWeak(x))
end


# Expr
"""
    isModifiableLvalue(x::AbstractExpr, ctx::ASTContext) -> CXExpr_isModifiableLvalueResult
Return why `x` is or is not a modifiable lvalue (C99 6.3.2.1); `CXExpr_MLV_Valid` means it is
one.

The optional `SourceLocation` out-param — the location that makes the lvalue
non-modifiable — is not exposed.
"""
function isModifiableLvalue(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isModifiableLvalue(x, ctx)
end

"""
    EvaluateForOverflow(x::AbstractExpr, ctx::ASTContext)
Fold `x` purely for the side effect of diagnosing signed integer overflow. A non-constant
`x` is ignored and nothing is returned.
"""
function EvaluateForOverflow(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_EvaluateForOverflow(x, ctx)
end

"""
    isPotentialConstantExpr(fd::AbstractFunctionDecl) -> Bool
Return whether `fd`'s definition could be used in a constant expression if it were marked
`constexpr`.

`Expr::isPotentialConstantExpr` is static: `fd` is the queried function, not a receiver. It
hands `fd`'s body straight to the constant evaluator, so `fd` must have a definition. The
diagnostics explaining a `false` answer are not exposed.
"""
function isPotentialConstantExpr(fd::AbstractFunctionDecl)
    @check_ptrs fd
    @assert hasBody(fd) "isPotentialConstantExpr needs a function definition"
    return clang_Expr_isPotentialConstantExpr(fd)
end

"""
    hasAnyTypeDependentArguments(exprs) -> Bool
Return whether any expression in `exprs` is type-dependent.

`Expr::hasAnyTypeDependentArguments` is static: `exprs` is the queried array, not a
receiver. An empty collection answers `false`.
"""
function hasAnyTypeDependentArguments(exprs::AbstractVector{<:AbstractExpr})
    @assert all(e -> e.ptr != C_NULL, exprs) "every queried expression must be non-NULL"
    ptrs = CXExpr[e.ptr for e in exprs]
    return clang_Expr_hasAnyTypeDependentArguments(ptrs, length(ptrs))
end

"""
    isUnusedResultAWarning(x::AbstractExpr, ctx::ASTContext) -> Bool
Return whether discarding `x`'s result deserves a warning.

The subexpression to warn on, its location and the two highlight ranges upstream fills in
are not exposed.
"""
function isUnusedResultAWarning(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isUnusedResultAWarning(x, ctx)
end

# StringLiteral
"""
    outputString(x::AbstractStringLiteral) -> String
Return `x` re-spelled the way it would appear in source: encoding prefix, quotes, and
escapes for the characters that need them.
"""
function outputString(x::AbstractStringLiteral)
    @check_ptrs x
    return get_string(clang_StringLiteral_outputString(x))
end

"""
    getLocationOfByte(x::AbstractStringLiteral, byteno, sm::SourceManager,
                      features::LangOptions, target::TargetInfo) -> SourceLocation
Return the source location of byte `byteno` of the (possibly concatenated, possibly
escaped) string literal `x`.

Upstream handles only narrow literals and walks the concatenated tokens asserting that
`byteno` lands inside one of them; both preconditions are restated here. The two optional
out-params — the index of the token holding the byte and the byte's offset inside that
token — are not exposed.
"""
function getLocationOfByte(x::AbstractStringLiteral, byteno::Integer, sm::SourceManager,
                           features::LangOptions, target::TargetInfo)
    @check_ptrs x sm features target
    @assert isOrdinary(x) || isUTF8(x) || isUnevaluated(x) "only narrow string literals are supported"
    @assert 0 <= byteno < getByteLength(x) "byte index $byteno out of range"
    return SourceLocation(clang_StringLiteral_getLocationOfByte(x, byteno, sm, features,
                                                                target))
end

# PredefinedExpr
function isTransparent(x::AbstractPredefinedExpr)
    @check_ptrs x
    return clang_PredefinedExpr_isTransparent(x)
end

function getLocation(x::AbstractPredefinedExpr)
    @check_ptrs x
    return SourceLocation(clang_PredefinedExpr_getLocation(x))
end

"""
    ComputeName(kind::CXPredefinedIdentKind, d::AbstractDecl) -> String
Return the text a `PredefinedExpr` of `kind` expands to inside `d`.

`PredefinedExpr::ComputeName` is static: `kind` is the queried kind and `d` the declaration
being named, not a receiver.
"""
function ComputeName(kind::CXPredefinedIdentKind, d::AbstractDecl)
    @check_ptrs d
    return get_string(clang_PredefinedExpr_ComputeName(kind, d))
end

# ConstantExpr
"""
    getStorageKind(v::APValue) -> CXConstantResultStorageKind
Return the tail-allocated storage a `ConstantExpr` would need to cache `v`.

`ConstantExpr::getStorageKind` is static: `v` is the queried value, not a receiver.
"""
function getStorageKind(v::APValue)
    @check_ptrs v
    return clang_ConstantExpr_getStorageKind(v)
end

"""
    getStorageKindForType(t::AbstractType, ctx::ASTContext) -> CXConstantResultStorageKind
Return the tail-allocated storage a `ConstantExpr` of type `t` would need.

This is the `(const Type *, const ASTContext &)` overload of the static
`ConstantExpr::getStorageKind`. It measures an integral or enumeration `t` with
`getTypeInfo`, so `t` must be complete.
"""
function getStorageKindForType(t::AbstractType, ctx::ASTContext)
    @check_ptrs t ctx
    @assert !isIncompleteType(t) "getStorageKindForType needs a complete type"
    return clang_ConstantExpr_getStorageKindForType(t, ctx)
end

# ShuffleVectorExpr
"""
    getShuffleMaskIdx(x::AbstractShuffleVectorExpr, ctx::ASTContext, n) -> LLVMGenericValueRef
Return mask entry `n` of the shuffle `x` as a caller-owned `LLVMGenericValueRef` (an
`APSInt` in `GV->IntVal`, released via LLVM-C's `LLVMDisposeGenericValue`).

The mask starts after the two vector operands, so `n` must be below
`getNumSubExprs(x) - 2`; upstream asserts that bound.
"""
function getShuffleMaskIdx(x::AbstractShuffleVectorExpr, ctx::ASTContext, n::Integer)
    @check_ptrs x ctx
    @assert 0 <= n < getNumSubExprs(x) - 2 "shuffle mask index $n out of range"
    return clang_ShuffleVectorExpr_getShuffleMaskIdx(x, ctx, n)
end

# ExtVectorElementExpr
"""
    getEncodedElementAccess(x::AbstractExtVectorElementExpr) -> Vector{UInt32}
Return the vector element indices `x`'s accessor selects, one per element of the access
(`getNumElements(x)` of them).
"""
function getEncodedElementAccess(x::AbstractExtVectorElementExpr)
    @check_ptrs x
    n = getNumElements(x)
    buf = Vector{UInt32}(undef, n)
    n > 0 && clang_ExtVectorElementExpr_getEncodedElementAccess(x, buf)
    return buf
end

# GenericSelectionExpr
"""
    getAssocTypeSourceInfo(x::AbstractGenericSelectionExpr, i) -> TypeSourceInfo
Return the written type of association `i` (0-based, `i < getNumAssocs(x)`).

The carrier holds a NULL pointer for the `default` association, which has no written type.
"""
function getAssocTypeSourceInfo(x::AbstractGenericSelectionExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAssocs(x) "association index $i out of range"
    return TypeSourceInfo(clang_GenericSelectionExpr_getAssocTypeSourceInfo(x, i))
end

# ArrayInitLoopExpr
"""
    getArraySize(x::AbstractArrayInitLoopExpr) -> LLVMGenericValueRef
Return the number of elements the loop initializes, as a caller-owned
`LLVMGenericValueRef` (an `APInt` in `GV->IntVal`, released via LLVM-C's
`LLVMDisposeGenericValue`).

Upstream reaches the extent through an unchecked
`cast<ConstantArrayType>(getType()->castAsArrayTypeUnsafe())`; that precondition is
restated here.
"""
function getArraySize(x::AbstractArrayInitLoopExpr)
    @check_ptrs x
    @assert isConstantArrayType(getTypePtr(getType(x))) "the loop's type must be a constant array"
    return clang_ArrayInitLoopExpr_getArraySize(x)
end

# DesignatedInitExpr::Designator
function getSourceRange(x::AbstractDesignator)
    @check_ptrs x
    r = clang_Designator_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end



# ParenExpr
function setSubExpr(x::AbstractParenExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ParenExpr_setSubExpr(x, val)
end

function setLParen(x::AbstractParenExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ParenExpr_setLParen(x, loc)
end

function setRParen(x::AbstractParenExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ParenExpr_setRParen(x, loc)
end

# UnaryOperator
function setOpcode(x::AbstractUnaryOperator, opc::CXUnaryOperatorKind)
    @check_ptrs x
    return clang_UnaryOperator_setOpcode(x, opc)
end

function setSubExpr(x::AbstractUnaryOperator, val::AbstractExpr)
    @check_ptrs x val
    return clang_UnaryOperator_setSubExpr(x, val)
end

function setCanOverflow(x::AbstractUnaryOperator, can::Bool)
    @check_ptrs x
    return clang_UnaryOperator_setCanOverflow(x, can)
end

# ArraySubscriptExpr
"""
    setLHS(x::AbstractArraySubscriptExpr, val::AbstractExpr)
Write the syntactic left operand of `x`.

This is the spelled-first operand, which for the reversed spelling `4[A]` is the index
rather than the base.
"""
function setLHS(x::AbstractArraySubscriptExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ArraySubscriptExpr_setLHS(x, val)
end

"""
    setRHS(x::AbstractArraySubscriptExpr, val::AbstractExpr)
Write the syntactic right operand of `x`.

This is the spelled-second operand, which for the reversed spelling `4[A]` is the base
rather than the index.
"""
function setRHS(x::AbstractArraySubscriptExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ArraySubscriptExpr_setRHS(x, val)
end

function setRBracketLoc(x::AbstractArraySubscriptExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ArraySubscriptExpr_setRBracketLoc(x, loc)
end

# BinaryOperator
function setOpcode(x::AbstractBinaryOperator, opc::CXBinaryOperatorKind)
    @check_ptrs x
    return clang_BinaryOperator_setOpcode(x, opc)
end

function setLHS(x::AbstractBinaryOperator, val::AbstractExpr)
    @check_ptrs x val
    return clang_BinaryOperator_setLHS(x, val)
end

function setRHS(x::AbstractBinaryOperator, val::AbstractExpr)
    @check_ptrs x val
    return clang_BinaryOperator_setRHS(x, val)
end

function setOperatorLoc(x::AbstractBinaryOperator, loc::SourceLocation)
    @check_ptrs x
    return clang_BinaryOperator_setOperatorLoc(x, loc)
end

# CharacterLiteral
function setValue(x::AbstractCharacterLiteral, val::Integer)
    @check_ptrs x
    return clang_CharacterLiteral_setValue(x, val)
end

function setKind(x::AbstractCharacterLiteral, kind::CXCharacterLiteralKind)
    @check_ptrs x
    return clang_CharacterLiteral_setKind(x, kind)
end

function setLocation(x::AbstractCharacterLiteral, loc::SourceLocation)
    @check_ptrs x
    return clang_CharacterLiteral_setLocation(x, loc)
end

"""
    print(val::Integer, kind::CXCharacterLiteralKind) -> String
Return the character literal with code point `val` and kind `kind` re-spelled as source:
encoding prefix, quotes and escapes included (`print(0x61, ...Ascii)` gives `"'a'"`).

`print` is static: `(val, kind)` is the queried literal, not a receiver.
"""
function print(val::Integer, kind::CXCharacterLiteralKind)
    return get_string(clang_CharacterLiteral_print(val, kind))
end

# GenericSelectionExpr
"""
    getControllingType(x::AbstractGenericSelectionExpr) -> TypeSourceInfo
Return the written type `x` selects on.

Upstream asserts `isTypePredicate(x)` while computing the trailing-object index; that
precondition is restated here.
"""
function getControllingType(x::AbstractGenericSelectionExpr)
    @check_ptrs x
    @assert isTypePredicate(x) "getControllingType on an expression-predicated generic selection"
    return TypeSourceInfo(clang_GenericSelectionExpr_getControllingType(x))
end

# AtomicExpr
"""
    hasScopeModel(x::AbstractAtomicExpr) -> Bool
Return whether `x` carries a synchronisation-scope operand.

Only the OpenCL, HIP and `__scoped_atomic_*` builtin families do; this is the gate
`getScope` asserts on.
"""
function hasScopeModel(x::AbstractAtomicExpr)
    @check_ptrs x
    return clang_AtomicExpr_hasScopeModel(x)
end

"""
    getScope(x::AbstractAtomicExpr) -> Expr_
Return the synchronisation-scope operand of `x`.

Upstream asserts the operation has a scope model; that precondition is restated here
through `hasScopeModel`.
"""
function getScope(x::AbstractAtomicExpr)
    @check_ptrs x
    @assert hasScopeModel(x) "the atomic operation carries no scope operand"
    return Expr_(clang_AtomicExpr_getScope(x))
end


# FullExpr
"""
    setSubExpr(x::AbstractFullExpr, val::AbstractExpr)
Write the subexpression `x` wraps.
"""
function setSubExpr(x::AbstractFullExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_FullExpr_setSubExpr(x, val)
end

# DeclRefExpr
"""
    setDecl(x::AbstractDeclRefExpr, d::AbstractValueDecl)
Point `x` at the declaration `d`, recomputing the reference's dependence bits.

Upstream reads `d`'s type and its `ASTContext`, so `d` must be non-null.
"""
function setDecl(x::AbstractDeclRefExpr, d::AbstractValueDecl)
    @check_ptrs x d
    return clang_DeclRefExpr_setDecl(x, d)
end

function setHadMultipleCandidates(x::AbstractDeclRefExpr, v::Bool)
    @check_ptrs x
    return clang_DeclRefExpr_setHadMultipleCandidates(x, v)
end

# UnaryExprOrTypeTraitExpr
function setKind(x::AbstractUnaryExprOrTypeTraitExpr, kind::CXUnaryExprOrTypeTrait)
    @check_ptrs x
    return clang_UnaryExprOrTypeTraitExpr_setKind(x, kind)
end

"""
    setArgumentExpr(x::AbstractUnaryExprOrTypeTraitExpr, val::AbstractExpr)
Make the operand of `x` the expression `val`, so that `isArgumentType(x)` becomes false.

This is the `setArgument(Expr *)` overload; the `TypeSourceInfo *` one is not exposed.
"""
function setArgumentExpr(x::AbstractUnaryExprOrTypeTraitExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_UnaryExprOrTypeTraitExpr_setArgumentExpr(x, val)
end

# CallExpr
function setCallee(x::AbstractCallExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_CallExpr_setCallee(x, val)
end

"""
    setArg(x::AbstractCallExpr, i, val::AbstractExpr)
Write the `i`-th argument of `x` (0-based, following the C++ API).

Upstream asserts `i < getNumArgs(x)`; that precondition is restated here. The call's
dependence bits are stale afterwards — recompute them if they matter.
"""
function setArg(x::AbstractCallExpr, i::Integer, val::AbstractExpr)
    @check_ptrs x val
    @assert 0 <= i < getNumArgs(x) "argument index $i out of range"
    return clang_CallExpr_setArg(x, i, val)
end

# MemberExpr
function setBase(x::AbstractMemberExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_MemberExpr_setBase(x, val)
end

"""
    setMemberDecl(x::AbstractMemberExpr, d::AbstractValueDecl)
Point `x` at the member declaration `d`, recomputing the access's dependence bits.

Upstream reads `d`'s type, so `d` must be non-null.
"""
function setMemberDecl(x::AbstractMemberExpr, d::AbstractValueDecl)
    @check_ptrs x d
    return clang_MemberExpr_setMemberDecl(x, d)
end

function setArrow(x::AbstractMemberExpr, arrow::Bool)
    @check_ptrs x
    return clang_MemberExpr_setArrow(x, arrow)
end

function setHadMultipleCandidates(x::AbstractMemberExpr, v::Bool)
    @check_ptrs x
    return clang_MemberExpr_setHadMultipleCandidates(x, v)
end

# CastExpr
function setCastKind(x::AbstractCastExpr, kind::CXCastKind)
    @check_ptrs x
    return clang_CastExpr_setCastKind(x, kind)
end

function setSubExpr(x::AbstractCastExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_CastExpr_setSubExpr(x, val)
end

# ImplicitCastExpr
function setIsPartOfExplicitCast(x::AbstractImplicitCastExpr, part::Bool)
    @check_ptrs x
    return clang_ImplicitCastExpr_setIsPartOfExplicitCast(x, part)
end

# ExplicitCastExpr
function setTypeInfoAsWritten(x::AbstractExplicitCastExpr, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_ExplicitCastExpr_setTypeInfoAsWritten(x, tsi)
end

# InitListExpr
"""
    setInit(x::AbstractInitListExpr, i, val::AbstractExpr)
Write the `i`-th initializer of `x` (0-based, following the C++ API).

Upstream asserts `i < getNumInits(x)`; that precondition is restated here.
"""
function setInit(x::AbstractInitListExpr, i::Integer, val::AbstractExpr)
    @check_ptrs x val
    @assert 0 <= i < getNumInits(x) "initializer index $i out of range"
    return clang_InitListExpr_setInit(x, i, val)
end

"""
    setArrayFiller(x::AbstractInitListExpr, filler::AbstractExpr)
Set the expression that value-initializes the array elements `x` does not initialize
explicitly, and write it into every still-empty slot of the list.

Upstream asserts the filler is not already set; that precondition is restated here.
"""
function setArrayFiller(x::AbstractInitListExpr, filler::AbstractExpr)
    @check_ptrs x filler
    @assert !hasArrayFiller(x) "the initializer list already has an array filler"
    return clang_InitListExpr_setArrayFiller(x, filler)
end

"""
    setInitializedFieldInUnion(x::AbstractInitListExpr, fd::AbstractFieldDecl)
Record `fd` as the union member `x` initializes.

Upstream asserts that no *other* field is recorded yet (only one member of a union may
be initialized); that precondition is restated here.
"""
function setInitializedFieldInUnion(x::AbstractInitListExpr, fd::AbstractFieldDecl)
    @check_ptrs x fd
    cur = getInitializedFieldInUnion(x)
    @assert cur.ptr == C_NULL || cur.ptr == fd.ptr "another union field is already initialized"
    return clang_InitListExpr_setInitializedFieldInUnion(x, fd)
end

"""
    setSyntacticForm(x::AbstractInitListExpr, init::AbstractInitListExpr)
Make `init` the syntactic form of `x` and `x` the semantic form of `init`.

Both lists are written, so `init` must be non-null.
"""
function setSyntacticForm(x::AbstractInitListExpr, init::AbstractInitListExpr)
    @check_ptrs x init
    return clang_InitListExpr_setSyntacticForm(x, init)
end

function sawArrayRangeDesignator(x::AbstractInitListExpr, ard::Bool)
    @check_ptrs x
    return clang_InitListExpr_sawArrayRangeDesignator(x, ard)
end
