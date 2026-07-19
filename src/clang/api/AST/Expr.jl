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

"""
    getValue(x::AbstractIntegerLiteral)
Return the value as an `LLVMGenericValueRef`. This function allocates and one
should call `dispose` to release the resources after using this object.
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

