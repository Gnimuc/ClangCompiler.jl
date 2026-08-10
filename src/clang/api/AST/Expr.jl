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

# The character bytes as clang stores them, whatever the width. Every character of a
# wide/UTF-16/UTF-32 literal carries interior NULs, so the length has to come from
# `getByteLength` rather than from a terminator — and the returned `String` holds those
# NULs. Borrowed from the AST arena: valid only while the owning `ASTContext` is.
function getBytes(x::AbstractStringLiteral)
    @check_ptrs x
    return unsafe_string(clang_StringLiteral_getBytes(x), getByteLength(x))
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

Upstream asserts the bound and that assertion is compiled into the release library, so an
out-of-range index aborts the process rather than returning null.
"""
function getArg(x::AbstractCallExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumArgs(x) "call argument index $i out of range"
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

# `clang::AbstractConditionalOperator` declares these, and is not mirrored -- see the note in
# core/AST/Expr.jl. Each is written out for both spellings clang actually builds, which is what
# keeps every receiver at a class that exists rather than at a looser one.
function getCond(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getCond(x))
end

function getCond(x::AbstractBinaryConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getCond(x))
end

function getTrueExpr(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getTrueExpr(x))
end

function getTrueExpr(x::AbstractBinaryConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getTrueExpr(x))
end

function getFalseExpr(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_AbstractConditionalOperator_getFalseExpr(x))
end

function getFalseExpr(x::AbstractBinaryConditionalOperator)
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
    @assert 0 <= i < getNumInits(x) "initializer index $i out of range"
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
# Upstream asserts the character width, and that assertion is compiled into the release
# library — a wide, UTF-16 or UTF-32 literal aborts the process here. `getBytes` is the
# accessor that reads those, and returns the same bytes for the literals this one accepts.
# A narrow literal may still carry an interior NUL, so the length comes from `getByteLength`.
function getString(x::AbstractStringLiteral)
    @check_ptrs x
    @assert isUnevaluated(x) || getCharByteWidth(x) == 1 "getString requires a narrow (char) string literal; use getBytes"
    return unsafe_string(clang_StringLiteral_getString(x), getByteLength(x))
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

function CStyleCastExpr(ctx::ASTContext, ty::QualType, vk::CXExprValueKind, k::CXCastKind, op::AbstractExpr)
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
    ty = expr_type_ptr(x)
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

function isNullPointerConstant(x::AbstractExpr, ctx::ASTContext, npc::CXExpr_NullPointerConstantValueDependence)
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
function EvaluateAsConstantExpr(x::AbstractExpr, ctx::ASTContext, kind::CXExpr_ConstantExprKind=CXExpr_ConstantExprKind_Normal)
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

function isNullPointerArithmeticExtension(ctx::ASTContext, opc::CXBinaryOperatorKind, lhs::AbstractExpr, rhs::AbstractExpr)
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
    # both before the gate: it reads `union_ty` with `getTypePtr`, which asserts on a null
    # QualType, and clang's own body then reads `op_ty` the same way
    @check_ptrs union_ty op_ty
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

# the conditional-operator locations, on both spellings -- see getCond above
function getQuestionLoc(x::AbstractConditionalOperator)
    @check_ptrs x
    return SourceLocation(clang_AbstractConditionalOperator_getQuestionLoc(x))
end

function getQuestionLoc(x::AbstractBinaryConditionalOperator)
    @check_ptrs x
    return SourceLocation(clang_AbstractConditionalOperator_getQuestionLoc(x))
end

function getColonLoc(x::AbstractConditionalOperator)
    @check_ptrs x
    return SourceLocation(clang_AbstractConditionalOperator_getColonLoc(x))
end

function getColonLoc(x::AbstractBinaryConditionalOperator)
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
"""
    OpaqueValueExpr(ctx::AbstractASTContext, loc::SourceLocation, ty::QualType,
                    vk::CXExprValueKind, ok::CXExprObjectKind=LibClangEx.CXExprObjectKind_OK_Ordinary) -> OpaqueValueExpr
Build a placeholder expression of type `ty` and value category `vk`, standing in for a value
no expression exists for.

This is what drives overload resolution from outside the parser: one of these per argument
type feeds [`AddOverloadCandidate`](@ref), whose viability check reads only the operand
types. The node is allocated in `ctx`'s arena, so it lives as long as the context and there
is nothing to `dispose`.
"""
function OpaqueValueExpr(ctx::AbstractASTContext, loc::SourceLocation, ty::QualType,
                         vk::CXExprValueKind,
                         ok::CXExprObjectKind=LibClangEx.CXExprObjectKind_OK_Ordinary)
    @check_ptrs ctx ty
    return OpaqueValueExpr(clang_OpaqueValueExpr_create(ctx, loc, ty, vk, ok))
end

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

# ConditionalOperator. getLHS/getRHS are declared on this class, not on the base both
# spellings share, so the receiver is its own abstract — `BinaryConditionalOperator` is a
# sibling and dispatch rejects it.
function getLHS(x::AbstractConditionalOperator)
    @check_ptrs x
    return Expr_(clang_ConditionalOperator_getLHS(x))
end

function getRHS(x::AbstractConditionalOperator)
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
    @assert isBlockPointerType(expr_type_ptr(x)) "a block literal must have block-pointer type"
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
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
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
function getLocationOfByte(x::AbstractStringLiteral, byteno::Integer, sm::SourceManager, features::LangOptions, target::TargetInfo)
    @check_ptrs x sm features target
    @assert isOrdinary(x) || isUTF8(x) || isUnevaluated(x) "only narrow string literals are supported"
    @assert 0 <= byteno < getByteLength(x) "byte index $byteno out of range"
    return SourceLocation(clang_StringLiteral_getLocationOfByte(x, byteno, sm, features, target))
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
    @assert isConstantArrayType(expr_type_ptr(x)) "the loop's type must be a constant array"
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

# UnaryOperator
"""
    isFPContractableWithinStatement(x::AbstractUnaryOperator, lo::LangOptions) -> Bool
Return whether floating-point contraction is allowed within the statement containing `x`,
given the operator's own stored FP features as overridden by `lo`.

Only meaningful for operations on floating-point types.
"""
function isFPContractableWithinStatement(x::AbstractUnaryOperator, lo::LangOptions)
    @check_ptrs x lo
    return clang_UnaryOperator_isFPContractableWithinStatement(x, lo)
end

"""
    isFEnvAccessOn(x::AbstractUnaryOperator, lo::LangOptions) -> Bool
Return the `FENV_ACCESS` status in effect for `x`, given the operator's own stored FP
features as overridden by `lo`.

Only meaningful for operations on floating-point types.
"""
function isFEnvAccessOn(x::AbstractUnaryOperator, lo::LangOptions)
    @check_ptrs x lo
    return clang_UnaryOperator_isFEnvAccessOn(x, lo)
end

# UnaryExprOrTypeTraitExpr
function setOperatorLoc(x::AbstractUnaryExprOrTypeTraitExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_UnaryExprOrTypeTraitExpr_setOperatorLoc(x, loc)
end

function setRParenLoc(x::AbstractUnaryExprOrTypeTraitExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_UnaryExprOrTypeTraitExpr_setRParenLoc(x, loc)
end

# BinaryOperator
"""
    isFPContractableWithinStatement(x::AbstractBinaryOperator, lo::LangOptions) -> Bool
Return whether floating-point contraction is allowed within the statement containing `x`,
given the operator's own stored FP features as overridden by `lo`.

Only meaningful for operations on floating-point types.
"""
function isFPContractableWithinStatement(x::AbstractBinaryOperator, lo::LangOptions)
    @check_ptrs x lo
    return clang_BinaryOperator_isFPContractableWithinStatement(x, lo)
end

"""
    isFEnvAccessOn(x::AbstractBinaryOperator, lo::LangOptions) -> Bool
Return the `FENV_ACCESS` status in effect for `x`, given the operator's own stored FP
features as overridden by `lo`.

Only meaningful for operations on floating-point types.
"""
function isFEnvAccessOn(x::AbstractBinaryOperator, lo::LangOptions)
    @check_ptrs x lo
    return clang_BinaryOperator_isFEnvAccessOn(x, lo)
end

# StmtExpr
"""
    setSubStmt(x::AbstractStmtExpr, sub::AbstractCompoundStmt)
Make `sub` the compound statement `x` wraps.

`getSubStmt` casts the slot to `CompoundStmt` unchecked, so the receiver type of `sub` is
the precondition; the statement expression's dependence bits and template depth are not
recomputed.
"""
function setSubStmt(x::AbstractStmtExpr, sub::AbstractCompoundStmt)
    @check_ptrs x sub
    return clang_StmtExpr_setSubStmt(x, sub)
end

function setLParenLoc(x::AbstractStmtExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_StmtExpr_setLParenLoc(x, loc)
end

function setRParenLoc(x::AbstractStmtExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_StmtExpr_setRParenLoc(x, loc)
end

# ChooseExpr
"""
    setIsConditionTrue(x::AbstractChooseExpr, istrue::Bool)
Overwrite the cached "the condition is non-zero" flag of `x`.

The condition is not re-evaluated, so a value inconsistent with `getCond(x)` makes
`getChosenSubExpr(x)` report the other arm. Upstream asserts the flag is only meaningful
when the condition is not dependent; that precondition is restated here.
"""
function setIsConditionTrue(x::AbstractChooseExpr, istrue::Bool)
    @check_ptrs x
    @assert !isConditionDependent(x) "a dependent condition is neither true nor false"
    return clang_ChooseExpr_setIsConditionTrue(x, istrue)
end

"""
    setCond(x::AbstractChooseExpr, cond::AbstractExpr)
Write the controlling expression of `x`.

Upstream leaves the choose expression's dependence bits stale afterwards; recomputing them
is the caller's job.
"""
function setCond(x::AbstractChooseExpr, cond::AbstractExpr)
    @check_ptrs x cond
    return clang_ChooseExpr_setCond(x, cond)
end

"""
    setLHS(x::AbstractChooseExpr, val::AbstractExpr)
Write the arm of `x` chosen when the condition is true.

Upstream leaves the choose expression's dependence bits stale afterwards.
"""
function setLHS(x::AbstractChooseExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ChooseExpr_setLHS(x, val)
end

"""
    setRHS(x::AbstractChooseExpr, val::AbstractExpr)
Write the arm of `x` chosen when the condition is false.

Upstream leaves the choose expression's dependence bits stale afterwards.
"""
function setRHS(x::AbstractChooseExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ChooseExpr_setRHS(x, val)
end

function setBuiltinLoc(x::AbstractChooseExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ChooseExpr_setBuiltinLoc(x, loc)
end

function setRParenLoc(x::AbstractChooseExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ChooseExpr_setRParenLoc(x, loc)
end

# VAArgExpr
"""
    setSubExpr(x::AbstractVAArgExpr, val::AbstractExpr)
Write the `va_list` operand of `x`.

The dependence bits are not recomputed.
"""
function setSubExpr(x::AbstractVAArgExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_VAArgExpr_setSubExpr(x, val)
end

function setIsMicrosoftABI(x::AbstractVAArgExpr, isms::Bool)
    @check_ptrs x
    return clang_VAArgExpr_setIsMicrosoftABI(x, isms)
end

"""
    setWrittenTypeInfo(x::AbstractVAArgExpr, tsi::TypeSourceInfo)
Write the type argument of `x` as it was spelled in the source.

Only the pointer half of the packed field is written; the Microsoft-ABI flag that shares
the word is left untouched.
"""
function setWrittenTypeInfo(x::AbstractVAArgExpr, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_VAArgExpr_setWrittenTypeInfo(x, tsi)
end

function setBuiltinLoc(x::AbstractVAArgExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_VAArgExpr_setBuiltinLoc(x, loc)
end

function setRParenLoc(x::AbstractVAArgExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_VAArgExpr_setRParenLoc(x, loc)
end

# OpaqueValueExpr
"""
    setIsUnique(x::AbstractOpaqueValueExpr, v::Bool)
Mark `x` as a unique opaque value.

Clang asserts that a unique opaque value has a source expression, so `v` may only be `true`
when `getSourceExpr(x)` is non-NULL.
"""
function setIsUnique(x::AbstractOpaqueValueExpr, v::Bool)
    @check_ptrs x
    @assert !v || getSourceExpr(x).ptr != C_NULL "a unique opaque value needs a source expression"
    return clang_OpaqueValueExpr_setIsUnique(x, v)
end

# PredefinedExpr
function setLocation(x::AbstractPredefinedExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_PredefinedExpr_setLocation(x, loc)
end

# CompoundLiteralExpr
"""
    setInitializer(x::AbstractCompoundLiteralExpr, val::AbstractExpr)
Write the initializer of the compound literal `x`.

`getInitializer` casts the slot to an `Expr`, so `val` must be non-NULL. The literal's
dependence bits are not recomputed.
"""
function setInitializer(x::AbstractCompoundLiteralExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_CompoundLiteralExpr_setInitializer(x, val)
end

function setFileScope(x::AbstractCompoundLiteralExpr, fs::Bool)
    @check_ptrs x
    return clang_CompoundLiteralExpr_setFileScope(x, fs)
end

function setLParenLoc(x::AbstractCompoundLiteralExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_CompoundLiteralExpr_setLParenLoc(x, loc)
end

"""
    setTypeSourceInfo(x::AbstractCompoundLiteralExpr, tsi::TypeSourceInfo)
Write the type of `x` as it was spelled in the source.

Only the pointer half of the packed field is written; the file-scope flag that shares the
word is left untouched.
"""
function setTypeSourceInfo(x::AbstractCompoundLiteralExpr, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_CompoundLiteralExpr_setTypeSourceInfo(x, tsi)
end

# CompoundAssignOperator
function setComputationLHSType(x::AbstractCompoundAssignOperator, ty::QualType)
    @check_ptrs x
    return clang_CompoundAssignOperator_setComputationLHSType(x, ty)
end

function setComputationResultType(x::AbstractCompoundAssignOperator, ty::QualType)
    @check_ptrs x
    return clang_CompoundAssignOperator_setComputationResultType(x, ty)
end

# AddrLabelExpr
function setAmpAmpLoc(x::AbstractAddrLabelExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_AddrLabelExpr_setAmpAmpLoc(x, loc)
end

function setLabelLoc(x::AbstractAddrLabelExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_AddrLabelExpr_setLabelLoc(x, loc)
end

"""
    setLabel(x::AbstractAddrLabelExpr, d::AbstractLabelDecl)
Write the label whose address `x` takes.
"""
function setLabel(x::AbstractAddrLabelExpr, d::AbstractLabelDecl)
    @check_ptrs x d
    return clang_AddrLabelExpr_setLabel(x, d)
end

# ConvertVectorExpr
function setTypeSourceInfo(x::AbstractConvertVectorExpr, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_ConvertVectorExpr_setTypeSourceInfo(x, tsi)
end

# GNUNullExpr
function setTokenLocation(x::AbstractGNUNullExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_GNUNullExpr_setTokenLocation(x, loc)
end

# DesignatedInitUpdateExpr
"""
    getBase(x::AbstractDesignatedInitUpdateExpr) -> Expr_
Return the expression `x` starts from, before the designated update is applied.
"""
function getBase(x::AbstractDesignatedInitUpdateExpr)
    @check_ptrs x
    return Expr_(clang_DesignatedInitUpdateExpr_getBase(x))
end

"""
    setBase(x::AbstractDesignatedInitUpdateExpr, val::AbstractExpr)
Write the base expression of `x`.

`getBase` casts the slot to an `Expr`, so `val` must be non-NULL.
"""
function setBase(x::AbstractDesignatedInitUpdateExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_DesignatedInitUpdateExpr_setBase(x, val)
end

"""
    getUpdater(x::AbstractDesignatedInitUpdateExpr) -> InitListExpr
Return the initializer list that overwrites part of `getBase(x)`.
"""
function getUpdater(x::AbstractDesignatedInitUpdateExpr)
    @check_ptrs x
    return InitListExpr(clang_DesignatedInitUpdateExpr_getUpdater(x))
end

"""
    setUpdater(x::AbstractDesignatedInitUpdateExpr, val::AbstractInitListExpr)
Write the initializer list that overwrites part of `getBase(x)`.

Upstream types the parameter as `Expr *`, but `getUpdater` casts the slot to an
`InitListExpr`, so only an initializer list may be stored.
"""
function setUpdater(x::AbstractDesignatedInitUpdateExpr, val::AbstractInitListExpr)
    @check_ptrs x val
    return clang_DesignatedInitUpdateExpr_setUpdater(x, val)
end

# ExtVectorElementExpr
"""
    setBase(x::AbstractExtVectorElementExpr, val::AbstractExpr)
Write the vector operand of `x`.

`getBase` casts the slot to an `Expr`, so `val` must be non-NULL. The dependence bits are
not recomputed.
"""
function setBase(x::AbstractExtVectorElementExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_ExtVectorElementExpr_setBase(x, val)
end

"""
    setAccessor(x::AbstractExtVectorElementExpr, ii::AbstractIdentifierInfo)
Write the component-selection accessor of `x`.

`getAccessor` dereferences the slot, so `ii` must be non-NULL.
"""
function setAccessor(x::AbstractExtVectorElementExpr, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_ExtVectorElementExpr_setAccessor(x, ii)
end

function setAccessorLoc(x::AbstractExtVectorElementExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_ExtVectorElementExpr_setAccessorLoc(x, loc)
end

# Expr
"""
    Classify(x::AbstractExpr, ctx::ASTContext) -> Classification
Classify `x` under the C++11 value-category taxonomy: lvalues, xvalues and prvalues, with
glvalue = lvalue ∪ xvalue and rvalue = xvalue ∪ prvalue.

The result carries no modifiability verdict — `getModifiable`/`isModifiable` need a
classification from `ClassifyModifiable` or `makeSimpleLValue`. This function allocates and
one should call `dispose` to release the resources after using this object.
"""
function Classify(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return Classification(clang_Expr_Classify(x, ctx))
end

"""
    ClassifyModifiable(x::AbstractExpr, ctx::ASTContext) -> (Classification, SourceLocation)
Classify `x` under the C++11 value-category taxonomy and additionally test whether it may
appear on the left of an assignment (C99 6.3.2.1).

The second element is the location that makes `x` non-modifiable, and is invalid when `x`
is modifiable. This function allocates and one should call `dispose` to release the
resources after using this object.
"""
function ClassifyModifiable(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    loc = Ref{CXSourceLocation_}(C_NULL)
    cl = clang_Expr_ClassifyModifiable(x, ctx, loc)
    return Classification(cl), SourceLocation(loc[])
end

"""
    isOBJCGCCandidate(x::AbstractExpr, ctx::ASTContext) -> Bool
Return whether `x` may be used in an Objective-C read/write garbage-collection barrier.
"""
function isOBJCGCCandidate(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_isOBJCGCCandidate(x, ctx)
end

# Expr::Classification
"""
    makeSimpleLValue() -> Classification
Build the classification of a simple, modifiable lvalue.

`clang::Expr::Classification::makeSimpleLValue` is static and takes no receiver. This
function allocates and one should call `dispose` to release the resources after using this
object.
"""
function makeSimpleLValue()
    return Classification(clang_Classification_makeSimpleLValue())
end

# Release an owned Classification — one produced by `Classify`, `ClassifyModifiable` or
# `makeSimpleLValue`.
function dispose(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_dispose(x)
end

"""
    getKind(x::AbstractClassification) -> CXClassification_Kinds
Return the value category `x` records, down to the reason a prvalue is not an lvalue.
"""
function getKind(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_getKind(x)
end

"""
    isModifiableTested(x::AbstractClassification) -> Bool
Return whether `x` carries a modifiability verdict: `true` for a classification from
`ClassifyModifiable` or `makeSimpleLValue`, `false` for one from `Classify`.

`clang::Expr::Classification` keeps that state in a private member, so libclangex records it
alongside the boxed value; it is the gate `getModifiable` and `isModifiable` assert on.
"""
function isModifiableTested(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isModifiableTested(x)
end

"""
    getModifiable(x::AbstractClassification) -> CXClassification_ModifiableType
Return why `x` is or is not modifiable; `CXClassification_CM_Modifiable` means it is.

`clang::Expr::Classification::getModifiable` asserts that modifiability was tested, so the
precondition is restated here.
"""
function getModifiable(x::AbstractClassification)
    @check_ptrs x
    @assert isModifiableTested(x) "classification carries no modifiability verdict"
    return clang_Classification_getModifiable(x)
end

function isLValue(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isLValue(x)
end

function isXValue(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isXValue(x)
end

function isGLValue(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isGLValue(x)
end

function isPRValue(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isPRValue(x)
end

function isRValue(x::AbstractClassification)
    @check_ptrs x
    return clang_Classification_isRValue(x)
end

"""
    isModifiable(x::AbstractClassification) -> Bool
Return whether `x` records a modifiable lvalue.

`clang::Expr::Classification::isModifiable` goes through `getModifiable` and inherits its
assert that modifiability was tested, so the precondition is restated here.
"""
function isModifiable(x::AbstractClassification)
    @check_ptrs x
    @assert isModifiableTested(x) "classification carries no modifiability verdict"
    return clang_Classification_isModifiable(x)
end

# BinaryOperator
"""
    getFPFeatures(x::AbstractBinaryOperator) -> UInt64
Return the floating-point options `x` overrides, as the opaque integer encoding of
`clang::FPOptionsOverride` — the `FPOptions` bits in the high half, the override mask in the
low half.

An operator with no trailing slot yields the default-constructed (zero) encoding, so this
accessor is total.
"""
function getFPFeatures(x::AbstractBinaryOperator)
    @check_ptrs x
    return clang_BinaryOperator_getFPFeatures(x)
end

"""
    getStoredFPFeatures(x::AbstractBinaryOperator) -> UInt64
Return the trailing `clang::FPOptionsOverride` slot's opaque integer encoding.

Only an operator allocated with the slot carries one:
`clang::BinaryOperator::getStoredFPFeatures` asserts `hasStoredFPFeatures()`, so the
precondition is restated here.
"""
function getStoredFPFeatures(x::AbstractBinaryOperator)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "binary operator carries no stored FP features"
    return clang_BinaryOperator_getStoredFPFeatures(x)
end

# CallExpr
"""
    getFPFeatures(x::AbstractCallExpr) -> UInt64
Return the floating-point options `x` overrides, as the opaque integer encoding of
`clang::FPOptionsOverride`. A call with no trailing slot yields the default-constructed
(zero) encoding, so this accessor is total.
"""
function getFPFeatures(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_getFPFeatures(x)
end

"""
    getStoredFPFeatures(x::AbstractCallExpr) -> UInt64
Return the trailing `clang::FPOptionsOverride` slot's opaque integer encoding.
`clang::CallExpr::getStoredFPFeatures` asserts `hasStoredFPFeatures()`, so the precondition
is restated here.
"""
function getStoredFPFeatures(x::AbstractCallExpr)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "call expression carries no stored FP features"
    return clang_CallExpr_getStoredFPFeatures(x)
end

# UnaryOperator
"""
    getFPOptionsOverride(x::AbstractUnaryOperator) -> UInt64
Return the floating-point options `x` overrides, as the opaque integer encoding of
`clang::FPOptionsOverride`. An operator with no trailing slot yields the
default-constructed (zero) encoding, so this accessor is total — it is `UnaryOperator`'s
spelling of the `getFPFeatures` the other operator classes carry.
"""
function getFPOptionsOverride(x::AbstractUnaryOperator)
    @check_ptrs x
    return clang_UnaryOperator_getFPOptionsOverride(x)
end

"""
    getStoredFPFeatures(x::AbstractUnaryOperator) -> UInt64
Return the trailing `clang::FPOptionsOverride` slot's opaque integer encoding.
`clang::UnaryOperator::getStoredFPFeatures` reads the slot through
`getTrailingFPFeatures()`, which asserts `hasStoredFPFeatures()`, so the precondition is
restated here.
"""
function getStoredFPFeatures(x::AbstractUnaryOperator)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "unary operator carries no stored FP features"
    return clang_UnaryOperator_getStoredFPFeatures(x)
end

# Expr
"""
    ClassifyLValue(x::AbstractExpr, ctx::ASTContext) -> CXExpr_LValueClassification
Return why `x` is, or is not, an l-value.

`CXExpr_LV_Valid` means `x` is an l-value; every other enumerator names the reason it is
not. This is the coarse view of the taxonomy `Classify` reports in full.
"""
function ClassifyLValue(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Expr_ClassifyLValue(x, ctx)
end

"""
    getFPFeaturesInEffect(x::AbstractExpr, lang_opts::LangOptions) -> UInt32
Return the floating-point settings that apply to `x`, as the opaque integer encoding of
`clang::FPOptions`.

Where `getFPFeatures` reports only what a node overrides, this folds `lang_opts`' defaults
in, so it is defined for every expression — an expression with no trailing override slot
reads the defaults. Only operations on floating-point values act on the result.
"""
function getFPFeaturesInEffect(x::AbstractExpr, lang_opts::LangOptions)
    @check_ptrs x lang_opts
    return clang_Expr_getFPFeaturesInEffect(x, lang_opts)
end

"""
    isPotentialConstantExprUnevaluated(x::AbstractExpr, fd::AbstractFunctionDecl) -> Bool
Return whether `x` might be usable in a constant expression in an unevaluated context, if
it sat inside `fd` and `fd` were marked `constexpr`.

`Expr::isPotentialConstantExprUnevaluated` is static: `x` is the queried expression and
`fd` the hypothetical enclosing function, neither is a receiver. The constant evaluator
asserts that `x` is not value-dependent, so that precondition is restated here. The
diagnostics explaining a `false` answer are not exposed.
"""
function isPotentialConstantExprUnevaluated(x::AbstractExpr, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    @assert !isValueDependent(x) "expression must not be value-dependent"
    return clang_Expr_isPotentialConstantExprUnevaluated(x, fd)
end

"""
    EvaluateAsInitializer(x::AbstractExpr, ctx::ASTContext, vd::AbstractVarDecl,
                          is_constant_init::Bool) -> APValue
Fold `x` as if it were `vd`'s initializer.

The returned `APValue` wraps `C_NULL` when `x` does not fold (check `.ptr`); a non-null
result is owned — `dispose` it after use. The constant evaluator asserts that `x` is not
value-dependent, so that precondition is restated here. The notes explaining a failure are
not exposed.
"""
function EvaluateAsInitializer(x::AbstractExpr, ctx::ASTContext, vd::AbstractVarDecl, is_constant_init::Bool)
    @check_ptrs x ctx vd
    @assert !isValueDependent(x) "expression must not be value-dependent"
    return APValue(clang_Expr_EvaluateAsInitializer(x, ctx, vd, is_constant_init))
end

"""
    EvaluateWithSubstitution(x::AbstractExpr, ctx::ASTContext,
                             callee::AbstractFunctionDecl, args, this=nothing) -> APValue
Fold `x` as if evaluated from inside a call to `callee` with `args`, in an unevaluated
context.

`args` is matched positionally against `callee`'s parameters, so supplying more than
`callee` declares is rejected here; supplying fewer simply leaves the remaining parameters
unbound and the fold fails. `this` is the object argument of a member call, or `nothing`.
The returned `APValue` wraps `C_NULL` when `x` does not fold (check `.ptr`); a non-null
result is owned — `dispose` it after use. The constant evaluator asserts that `x` is not
value-dependent, so that precondition is restated here.
"""
function EvaluateWithSubstitution(x::AbstractExpr, ctx::ASTContext, callee::AbstractFunctionDecl, args::AbstractVector{<:AbstractExpr}, this::Union{Nothing,AbstractExpr}=nothing)
    @check_ptrs x ctx callee
    @assert !isValueDependent(x) "expression must not be value-dependent"
    @assert all(e -> e.ptr != C_NULL, args) "every substituted argument must be non-NULL"
    @assert length(args) <= getNumParams(callee) "more arguments than callee has parameters"
    ptrs = CXExpr[Base.unsafe_convert(CXExpr, e) for e in args]
    this_ptr = this === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, this)
    return APValue(clang_Expr_EvaluateWithSubstitution(x, ctx, callee, ptrs, length(ptrs), this_ptr))
end

# CallExpr
"""
    setADLCallKind(x::AbstractCallExpr, uses_adl::Bool)
Record whether `x`'s callee was found by argument-dependent lookup.

`clang::CallExpr::ADLCallKind` has exactly two states, so it crosses as a `Bool`;
`usesADL` reads the flag back.
"""
function setADLCallKind(x::AbstractCallExpr, uses_adl::Bool)
    @check_ptrs x
    return clang_CallExpr_setADLCallKind(x, uses_adl)
end

# CastExpr
"""
    getFPFeatures(x::AbstractCastExpr) -> UInt64
Return the floating-point options `x` overrides, as the opaque integer encoding of
`clang::FPOptionsOverride` — the `FPOptions` bits in the high half, the override mask in
the low half.

A cast with no trailing slot yields the default-constructed (zero) encoding, so this
accessor is total.
"""
function getFPFeatures(x::AbstractCastExpr)
    @check_ptrs x
    return clang_CastExpr_getFPFeatures(x)
end

"""
    getStoredFPFeatures(x::AbstractCastExpr) -> UInt64
Return the trailing `clang::FPOptionsOverride` slot's opaque integer encoding.

Only a cast allocated with the slot carries one: `clang::CastExpr::getStoredFPFeatures`
asserts `hasStoredFPFeatures()`, so the precondition is restated here.
"""
function getStoredFPFeatures(x::AbstractCastExpr)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "cast carries no stored FP features"
    return clang_CastExpr_getStoredFPFeatures(x)
end

# OffsetOfExpr
function setOperatorLoc(x::AbstractOffsetOfExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_OffsetOfExpr_setOperatorLoc(x, loc)
end

function setRParenLoc(x::AbstractOffsetOfExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_OffsetOfExpr_setRParenLoc(x, loc)
end

"""
    setTypeSourceInfo(x::AbstractOffsetOfExpr, tsi::TypeSourceInfo)
Store the written record type `x` takes an offset into.

The slot is stored unchecked and `getTypeSourceInfo` hands it straight back, so `tsi` must
be non-NULL for later readers to stay well defined.
"""
function setTypeSourceInfo(x::AbstractOffsetOfExpr, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_OffsetOfExpr_setTypeSourceInfo(x, tsi)
end

"""
    setIndexExpr(x::AbstractOffsetOfExpr, i::Integer, val::AbstractExpr)
Store `val` as the `i`-th array-index expression of `x` (0-based).

The index-expression array holds `getNumExpressions(x)` slots, which is what is asserted
here; upstream's own assert compares against `getNumComponents(x)`, the larger of the two,
and so does not bound the write.
"""
function setIndexExpr(x::AbstractOffsetOfExpr, i::Integer, val::AbstractExpr)
    @check_ptrs x val
    @assert 0 <= i < getNumExpressions(x) "offsetof index-expression index $i out of range"
    return clang_OffsetOfExpr_setIndexExpr(x, i, val)
end

# InitListExpr
"""
    reserveInits(x::AbstractInitListExpr, ctx::ASTContext, n::Integer)
Grow `x`'s backing storage to hold at least `n` initializers.

Only the capacity changes — `getNumInits` is unaffected, and a request below the current
size is a no-op.
"""
function reserveInits(x::AbstractInitListExpr, ctx::ASTContext, n::Integer)
    @check_ptrs x ctx
    @assert n >= 0 "initializer count must be non-negative"
    return clang_InitListExpr_reserveInits(x, ctx, n)
end

"""
    updateInit(x::AbstractInitListExpr, ctx::ASTContext, i::Integer,
               val::AbstractExpr) -> Expr_
Replace the `i`-th initializer of `x` (0-based) with `val` and return the one it displaced.

An `i` past the end extends the list with null entries first, in which case the returned
carrier wraps `C_NULL` (check `.ptr`).
"""
function updateInit(x::AbstractInitListExpr, ctx::ASTContext, i::Integer, val::AbstractExpr)
    @check_ptrs x ctx val
    @assert i >= 0 "initializer index must be non-negative"
    return Expr_(clang_InitListExpr_updateInit(x, ctx, i, val))
end

"""
    markError(x::AbstractInitListExpr)
Mark `x` as containing an error, the way Sema does when analysis of the list fails.

`clang::InitListExpr::markError` asserts `isSemanticForm()`, so the precondition is
restated here. `containsErrors` reads the bit back.
"""
function markError(x::AbstractInitListExpr)
    @check_ptrs x
    @assert isSemanticForm(x) "markError applies to the semantic form of an initializer list"
    return clang_InitListExpr_markError(x)
end

# DesignatedInitExpr
function setEqualOrColonLoc(x::AbstractDesignatedInitExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_DesignatedInitExpr_setEqualOrColonLoc(x, loc)
end

"""
    setGNUSyntax(x::AbstractDesignatedInitExpr, gnu::Bool)
Record whether `x` was written with the deprecated GNU designated-initializer syntax.

`usesGNUSyntax` reads the flag back.
"""
function setGNUSyntax(x::AbstractDesignatedInitExpr, gnu::Bool)
    @check_ptrs x
    return clang_DesignatedInitExpr_setGNUSyntax(x, gnu)
end

"""
    setInit(x::AbstractDesignatedInitExpr, val::AbstractExpr)
Store `val` as the initializer value `x`'s designators apply to.

The slot is stored unchecked and `getInit` `cast<Expr>`s it, so `val` must be non-NULL.
"""
function setInit(x::AbstractDesignatedInitExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_DesignatedInitExpr_setInit(x, val)
end

"""
    setSubExpr(x::AbstractDesignatedInitExpr, i::Integer, val::AbstractExpr)
Store `val` as the `i`-th subexpression of `x` (0-based).

`clang::DesignatedInitExpr::setSubExpr` asserts `i < getNumSubExprs(x)`, so the
precondition is restated here.
"""
function setSubExpr(x::AbstractDesignatedInitExpr, i::Integer, val::AbstractExpr)
    @check_ptrs x val
    @assert 0 <= i < getNumSubExprs(x) "subexpression index $i out of range"
    return clang_DesignatedInitExpr_setSubExpr(x, i, val)
end

# SourceLocExpr
"""
    EvaluateInContext(x::AbstractSourceLocExpr, ctx::ASTContext, default=nothing) -> APValue
Evaluate `x` in the context of the default argument or default initializer `default`.

Pass `nothing` to evaluate at `x`'s own location and parent context instead of a use site.
The result is always produced — `__builtin_LINE`/`__builtin_COLUMN` fold to integers,
`__builtin_FILE`/`__builtin_FUNCTION` to the address of a string literal. This function
allocates and one should call `dispose` to release the resources after using this object.
"""
function EvaluateInContext(x::AbstractSourceLocExpr, ctx::ASTContext, default::Union{Nothing,AbstractExpr}=nothing)
    @check_ptrs x ctx
    default_ptr = default === nothing ? CXExpr(C_NULL) : Base.unsafe_convert(CXExpr, default)
    return APValue(clang_SourceLocExpr_EvaluateInContext(x, ctx, default_ptr))
end

# CallExpr — dependence maintenance and the argument-count shrink
"""
    computeDependence(x::AbstractCallExpr)
Recompute `x`'s dependence bits from its callee and its arguments.

`setArg` deliberately leaves them stale; this is the recomputation it defers to the caller.
"""
function computeDependence(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_computeDependence(x)
end

"""
    markDependentForPostponedNameLookup(x::AbstractCallExpr)
Mark `x` type-, value- and instantiation-dependent for MSVC-compatible delayed name lookup.

The bits are OR-ed in and never cleared; `computeDependence` is the way back.
"""
function markDependentForPostponedNameLookup(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_markDependentForPostponedNameLookup(x)
end

"""
    shrinkNumArgs(x::AbstractCallExpr, n::Integer)
Drop `x`'s trailing arguments so that `getNumArgs(x) == n`.

`clang::CallExpr::shrinkNumArgs` asserts `n <= getNumArgs(x)` — the arguments live in
trailing storage that can never be grown back — so the precondition is restated here.
"""
function shrinkNumArgs(x::AbstractCallExpr, n::Integer)
    @check_ptrs x
    @assert 0 <= n <= getNumArgs(x) "a call's argument array can only shrink"
    return clang_CallExpr_shrinkNumArgs(x, n)
end

# InitListExpr
"""
    resizeInits(x::AbstractInitListExpr, ctx::ASTContext, n::Integer)
Make `getNumInits(x)` exactly `n`.

Growing appends null slots; shrinking truncates the tail and leaves the surviving entries
untouched.
"""
function resizeInits(x::AbstractInitListExpr, ctx::ASTContext, n::Integer)
    @check_ptrs x ctx
    return clang_InitListExpr_resizeInits(x, ctx, n)
end

# DeclRefExpr
"""
    setIsImmediateEscalating(x::AbstractDeclRefExpr, flag::Bool)
Record whether `x` names an immediate-escalating function (C++23 `consteval` propagation).
"""
function setIsImmediateEscalating(x::AbstractDeclRefExpr, flag::Bool)
    @check_ptrs x
    return clang_DeclRefExpr_setIsImmediateEscalating(x, flag)
end

# FloatingLiteral
"""
    setExact(x::AbstractFloatingLiteral, exact::Bool)
Record whether `x`'s spelling converts exactly to the `APFloat` value it stores.
"""
function setExact(x::AbstractFloatingLiteral, exact::Bool)
    @check_ptrs x
    return clang_FloatingLiteral_setExact(x, exact)
end

# BinaryOperator — the static compound-assignment gate and the two factories
"""
    isCompoundAssignmentOp(opc::CXBinaryOperatorKind) -> Bool
Return whether `opc` is one of the compound assignments (`+=`, `-=`, `<<=`, …).

This is the static `clang::BinaryOperator::isCompoundAssignmentOp(Opcode)` overload: `opc`
is the queried opcode, not a receiver. It is the gate the `BinaryOperator` and
`CompoundAssignOperator` factories below assert on.
"""
function isCompoundAssignmentOp(opc::CXBinaryOperatorKind)
    return clang_BinaryOperator_isCompoundAssignmentOpKind(opc)
end

"""
    BinaryOperator(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr,
                   opc::CXBinaryOperatorKind, res_ty::QualType, vk::CXExprValueKind,
                   ok::CXExprObjectKind, op_loc::SourceLocation,
                   fp_features::Integer) -> BinaryOperator
Build the binary expression `lhs opc rhs` of type `res_ty`.

`fp_features` is the `clang::FPOptionsOverride` opaque encoding `getFPFeatures` reads back:
pass `0` for "no override", the only value that leaves `hasStoredFPFeatures` false. clang's
constructor asserts the opcode is not a compound assignment — those go through the
`CompoundAssignOperator` factory — so the precondition is restated here.
"""
function BinaryOperator(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr, opc::CXBinaryOperatorKind, res_ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind, op_loc::SourceLocation, fp_features::Integer)
    @check_ptrs ctx lhs rhs
    @assert !isCompoundAssignmentOp(opc) "a compound assignment needs CompoundAssignOperator"
    return BinaryOperator(clang_BinaryOperator_Create(ctx, lhs, rhs, opc, res_ty, vk, ok, op_loc, fp_features))
end

"""
    BinaryOperator(ctx::ASTContext, has_fp_features::Bool) -> BinaryOperator
Build the empty `BinaryOperator` shell clang deserializes into.

The opcode starts at `BO_Comma` and the type is null, but both operand slots are left
uninitialized: call `setLHS` and `setRHS` before any reader (`getLHS`, `getRHS`,
`getBeginLoc`, `getEndLoc`) touches them.
"""
function BinaryOperator(ctx::ASTContext, has_fp_features::Bool)
    @check_ptrs ctx
    return BinaryOperator(clang_BinaryOperator_CreateEmpty(ctx, has_fp_features))
end

# CompoundAssignOperator
"""
    CompoundAssignOperator(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr,
                           opc::CXBinaryOperatorKind, res_ty::QualType,
                           vk::CXExprValueKind, ok::CXExprObjectKind,
                           op_loc::SourceLocation, fp_features::Integer,
                           comp_lhs_ty::QualType,
                           comp_result_ty::QualType) -> CompoundAssignOperator
Build the compound assignment `lhs opc rhs`.

`comp_lhs_ty` is the type the left operand is converted to for the computation and
`comp_result_ty` the type of that computation's result. clang's constructor asserts `opc`
is a compound assignment, so the precondition is restated here.
"""
function CompoundAssignOperator(ctx::ASTContext, lhs::AbstractExpr, rhs::AbstractExpr, opc::CXBinaryOperatorKind, res_ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind, op_loc::SourceLocation, fp_features::Integer, comp_lhs_ty::QualType, comp_result_ty::QualType)
    @check_ptrs ctx lhs rhs
    @assert isCompoundAssignmentOp(opc) "CompoundAssignOperator needs a compound-assignment opcode"
    return CompoundAssignOperator(clang_CompoundAssignOperator_Create(ctx, lhs, rhs, opc, res_ty, vk, ok, op_loc, fp_features, comp_lhs_ty, comp_result_ty))
end

# UnaryOperator
"""
    UnaryOperator(ctx::ASTContext, input::AbstractExpr, opc::CXUnaryOperatorKind,
                  ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind,
                  loc::SourceLocation, can_overflow::Bool,
                  fp_features::Integer) -> UnaryOperator
Build the unary expression `opc input` of type `ty`, with `loc` the operator's location.

`can_overflow` records whether the operation may signed-overflow. `fp_features` is the
`clang::FPOptionsOverride` opaque encoding: pass `0` for "no override".
"""
function UnaryOperator(ctx::ASTContext, input::AbstractExpr, opc::CXUnaryOperatorKind, ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind, loc::SourceLocation, can_overflow::Bool, fp_features::Integer)
    @check_ptrs ctx input
    return UnaryOperator(clang_UnaryOperator_Create(ctx, input, opc, ty, vk, ok, loc, can_overflow, fp_features))
end

# ImplicitCastExpr
"""
    ImplicitCastExpr(ctx::ASTContext, ty::QualType, kind::CXCastKind, op::AbstractExpr,
                     vk::CXExprValueKind, fp_features::Integer) -> ImplicitCastExpr
Build the implicit conversion `kind` taking `op` to `ty`.

The inheritance path is always empty — `clang::ImplicitCastExpr::Create`'s optional
`CXXCastPath` is not exposed — so a base-class conversion built this way carries no path.
`fp_features` is the `clang::FPOptionsOverride` opaque encoding: pass `0` for "no override".
"""
function ImplicitCastExpr(ctx::ASTContext, ty::QualType, kind::CXCastKind, op::AbstractExpr, vk::CXExprValueKind, fp_features::Integer)
    @check_ptrs ctx op
    return ImplicitCastExpr(clang_ImplicitCastExpr_Create(ctx, ty, kind, op, vk, fp_features))
end

"""
    ImplicitCastExpr(ctx::ASTContext, path_size::Integer,
                     has_fp_features::Bool) -> ImplicitCastExpr
Build the empty `ImplicitCastExpr` shell clang deserializes into, with room for a
`path_size`-long inheritance path.

The operand slot and the cast kind are left uninitialized: call `setSubExpr` and
`setCastKind` before any reader touches them.
"""
function ImplicitCastExpr(ctx::ASTContext, path_size::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return ImplicitCastExpr(clang_ImplicitCastExpr_CreateEmpty(ctx, path_size, has_fp_features))
end

# MemberExpr
"""
    MemberExpr(ctx::ASTContext, base::AbstractExpr, is_arrow::Bool,
               member::AbstractValueDecl, ty::QualType, vk::CXExprValueKind,
               ok::CXExprObjectKind) -> MemberExpr
Build the implicit member access `base.member` (or `base->member` when `is_arrow`).

`clang::MemberExpr::CreateImplicit` reads `member`'s access specifier, so `member` must be
non-NULL. The access it builds carries no nested-name qualifier, no explicit template
arguments and no written source locations.
"""
function MemberExpr(ctx::ASTContext, base::AbstractExpr, is_arrow::Bool, member::AbstractValueDecl, ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind)
    @check_ptrs ctx base member
    return MemberExpr(clang_MemberExpr_CreateImplicit(ctx, base, is_arrow, member, ty, vk, ok))
end

# PredefinedExpr
"""
    PredefinedExpr(ctx::ASTContext, loc::SourceLocation, fn_ty::QualType,
                   kind::CXPredefinedIdentKind, is_transparent::Bool,
                   sl=nothing) -> PredefinedExpr
Build the predefined identifier `kind` (`__func__`, `__PRETTY_FUNCTION__`, …) at `loc`.

Pass `nothing` for `sl` to build an expression with no function-name literal, in which case
`getFunctionName` reports a NULL carrier.
"""
function PredefinedExpr(ctx::ASTContext, loc::SourceLocation, fn_ty::QualType, kind::CXPredefinedIdentKind, is_transparent::Bool, sl::Union{Nothing,AbstractStringLiteral}=nothing)
    @check_ptrs ctx
    sl_ptr = sl === nothing ? CXStringLiteral(C_NULL) : Base.unsafe_convert(CXStringLiteral, sl)
    return PredefinedExpr(clang_PredefinedExpr_Create(ctx, loc, fn_ty, kind, is_transparent, sl_ptr))
end

# ParenListExpr
"""
    ParenListExpr(ctx::ASTContext, lparen_loc::SourceLocation,
                  exprs::Vector{<:AbstractExpr},
                  rparen_loc::SourceLocation) -> ParenListExpr
Build the parenthesised list `(exprs...)`.

The expressions are copied into the node's trailing storage, so `exprs` need not outlive
the call and may be empty. No slot may be NULL, which this restates.
"""
function ParenListExpr(ctx::ASTContext, lparen_loc::SourceLocation, exprs::Vector{<:AbstractExpr}, rparen_loc::SourceLocation)
    @check_ptrs ctx
    @assert all(e -> e.ptr != C_NULL, exprs) "a paren list holds no null slot"
    buf = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
    return ParenListExpr(clang_ParenListExpr_Create(ctx, lparen_loc, buf, length(buf), rparen_loc))
end

# ConstantExpr
"""
    ConstantExpr(ctx::ASTContext, e::AbstractExpr, result::APValue) -> ConstantExpr
Wrap `e` in a `ConstantExpr` caching the already-folded `result`.

The trailing result storage is sized from `getStorageKind(result)`, so a small integer lands
in the `Int64` storage rather than the full `APValue` one. `result` is copied; the caller
still owns it and must `dispose` it.
"""
function ConstantExpr(ctx::ASTContext, e::AbstractExpr, result::APValue)
    @check_ptrs ctx e result
    return ConstantExpr(clang_ConstantExpr_Create(ctx, e, result))
end

"""
    ConstantExpr(ctx::ASTContext, storage_kind::CXConstantResultStorageKind) -> ConstantExpr
Build the empty `ConstantExpr` shell clang deserializes into, with trailing room for a
`storage_kind` result.

`clang::FullExpr`'s empty-shell constructor leaves the wrapped subexpression uninitialized:
call `setSubExpr` before any reader (`getSubExpr`, `getBeginLoc`, `getEndLoc`) touches it.
Only `getResultStorageKind` and `hasAPValueResult` are safe beforehand.
"""
function ConstantExpr(ctx::ASTContext, storage_kind::CXConstantResultStorageKind)
    @check_ptrs ctx
    return ConstantExpr(clang_ConstantExpr_CreateEmpty(ctx, storage_kind))
end

# RecoveryExpr
"""
    RecoveryExpr(ctx::ASTContext, ty::QualType, begin_loc::SourceLocation,
                 end_loc::SourceLocation,
                 sub_exprs::Vector{<:AbstractExpr}) -> RecoveryExpr
Build the placeholder clang substitutes for an expression it failed to build.

The subexpressions are copied into the node's trailing storage, so `sub_exprs` need not
outlive the call and may be empty. clang's constructor dereferences `ty` and asserts both
that it is non-NULL and that no subexpression slot is NULL, so both are restated here.
"""
function RecoveryExpr(ctx::ASTContext, ty::QualType, begin_loc::SourceLocation, end_loc::SourceLocation, sub_exprs::Vector{<:AbstractExpr})
    @check_ptrs ctx
    @assert ty.ptr != C_NULL "a RecoveryExpr needs a non-NULL type"
    @assert all(e -> e.ptr != C_NULL, sub_exprs) "a RecoveryExpr holds no null subexpression"
    buf = CXExpr[Base.unsafe_convert(CXExpr, e) for e in sub_exprs]
    return RecoveryExpr(clang_RecoveryExpr_Create(ctx, ty, begin_loc, end_loc, buf, length(buf)))
end

"""
    getNumSubExpressions(x::AbstractRecoveryExpr) -> UInt32
Return how many subexpressions `x` salvaged. The count is exact and no slot is NULL.
"""
function getNumSubExpressions(x::AbstractRecoveryExpr)
    @check_ptrs x
    return clang_RecoveryExpr_getNumSubExpressions(x)
end

"""
    getSubExpression(x::AbstractRecoveryExpr, i::Integer) -> Expr_
Return the `i`-th salvaged subexpression of `x` (0-based, `i < getNumSubExpressions(x)`).
"""
function getSubExpression(x::AbstractRecoveryExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSubExpressions(x) "subexpression index $i out of range"
    return Expr_(clang_RecoveryExpr_getSubExpression(x, i))
end

# Expr
"""
    EvaluateAsFixedPoint(x::AbstractExpr, ctx::ASTContext) -> APValue
Fold `x` to a fixed-point constant, returning an owned `APValue` on success and one wrapping
`C_NULL` when `x` is not a fixed-point constant.

The evaluator rejects every expression whose type is not a fixed-point type before it folds
anything, so a translation unit built without `-ffixed-point` never succeeds here.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function EvaluateAsFixedPoint(x::AbstractExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return APValue(clang_Expr_EvaluateAsFixedPoint(x, ctx))
end

# ConstantExpr
"""
    SetResult(x::AbstractConstantExpr, v::APValue, ctx::ASTContext)
Cache `v` as the folded result of `x`.

`clang::ConstantExpr::MoveIntoResult` asserts that `v` fits the trailing storage `x` was
allocated with (`getStorageKind(v) <= getResultStorageKind(x)`), and its `Int64` branch then
reads `v`'s integer outright, so an `x` storing an `Int64` result additionally needs an
integral `v`. Both preconditions are restated here. `v` is copied; the caller still owns it.
"""
function SetResult(x::AbstractConstantExpr, v::APValue, ctx::ASTContext)
    @check_ptrs x v ctx
    kind = getResultStorageKind(x)
    @assert Integer(getStorageKind(v)) <= Integer(kind) "the APValue does not fit this result storage"
    @assert kind != CXConstantResultStorageKind_Int64 || isInt(v) "Int64 storage needs an integral APValue"
    return clang_ConstantExpr_SetResult(x, v, ctx)
end

# FloatingLiteral
"""
    getRawSemantics(x::AbstractFloatingLiteral) -> UInt32
Return the raw `llvm::APFloatBase::Semantics` enumerator naming `x`'s float format (32-bit
IEEE, x87, ...).

It crosses as a plain integer rather than as a mirrored enum because the enumeration is
LLVM's, not Clang's.
"""
function getRawSemantics(x::AbstractFloatingLiteral)
    @check_ptrs x
    return clang_FloatingLiteral_getRawSemantics(x)
end

"""
    setRawSemantics(x::AbstractFloatingLiteral, sem::Integer)
Record `sem` — a raw `llvm::APFloatBase::Semantics` enumerator — as `x`'s float format.

The stored bit pattern is reinterpreted under the new format instead of being converted, so a
`sem` inconsistent with what `getValue(x)` returns changes the value read back.
"""
function setRawSemantics(x::AbstractFloatingLiteral, sem::Integer)
    @check_ptrs x
    return clang_FloatingLiteral_setRawSemantics(x, sem)
end

"""
    setValue(x::AbstractFloatingLiteral, ctx::ASTContext, bits::LibClangEx.LLVMGenericValueRef)
Store `bits` as `x`'s value.

`bits` is the bit pattern an `APFloat` of `x`'s own semantics bitcasts to — exactly what
`getValue(x)` returns — because the shim rebuilds the `APFloat` with `x`'s `getSemantics()` to
satisfy `clang::FloatingLiteral::setValue`'s "Inconsistent semantics" assert. A pattern whose
width does not match those semantics is undefined. The `LLVMGenericValueRef` stays the
caller's to release.
"""
function setValue(x::AbstractFloatingLiteral, ctx::ASTContext, bits::LibClangEx.LLVMGenericValueRef)
    @check_ptrs x ctx
    @assert bits != C_NULL "setValue needs a non-NULL LLVMGenericValueRef"
    return clang_FloatingLiteral_setValue(x, ctx, bits)
end

# ImaginaryLiteral
"""
    setSubExpr(x::AbstractImaginaryLiteral, val::AbstractExpr)
Replace the real-valued operand `x` scales by `i`.

Upstream stores `val` unchecked and `getSubExpr` then `cast<Expr>`s the slot, so `val` must be
non-NULL. The literal's dependence bits are not recomputed.
"""
function setSubExpr(x::AbstractImaginaryLiteral, val::AbstractExpr)
    @check_ptrs x val
    return clang_ImaginaryLiteral_setSubExpr(x, val)
end

# MatrixSubscriptExpr
"""
    setBase(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
Replace the matrix operand of `x`. `getBase` `cast<Expr>`s the slot, so `val` must be non-NULL.
"""
function setBase(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_MatrixSubscriptExpr_setBase(x, val)
end

"""
    setRowIdx(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
Replace the row index of `x`. `getRowIdx` `cast<Expr>`s the slot, so `val` must be non-NULL.
"""
function setRowIdx(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_MatrixSubscriptExpr_setRowIdx(x, val)
end

"""
    setColumnIdx(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
Replace the column index of `x`.

The column slot is the one clang leaves NULL for the incomplete subscript an unfinished `m[i]`
carries; this wrapper only ever writes a real operand, so clearing the slot is not exposed.
"""
function setColumnIdx(x::AbstractMatrixSubscriptExpr, val::AbstractExpr)
    @check_ptrs x val
    return clang_MatrixSubscriptExpr_setColumnIdx(x, val)
end

"""
    setRBracketLoc(x::AbstractMatrixSubscriptExpr, loc::SourceLocation)
Record `loc` as the location of `x`'s closing bracket.
"""
function setRBracketLoc(x::AbstractMatrixSubscriptExpr, loc::SourceLocation)
    @check_ptrs x
    return clang_MatrixSubscriptExpr_setRBracketLoc(x, loc)
end

# CallExpr
"""
    getNumRawSubExprs(x::AbstractCallExpr) -> UInt32
Return how many slots `clang::CallExpr::getRawSubExprs()` spans — the callee, the pre-args and
the arguments in one flat view, which is why the count exceeds `getNumArgs(x)`.
"""
function getNumRawSubExprs(x::AbstractCallExpr)
    @check_ptrs x
    return clang_CallExpr_getNumRawSubExprs(x)
end

"""
    getRawSubExpr(x::AbstractCallExpr, i::Integer) -> Stmt
Return the `i`-th raw subexpression slot of `x` (0-based, `i < getNumRawSubExprs(x)`). Slot 0
is always the callee. A slot of a still-building call may wrap `C_NULL`.
"""
function getRawSubExpr(x::AbstractCallExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumRawSubExprs(x) "raw subexpression index $i out of range"
    return Stmt(clang_CallExpr_getRawSubExpr(x, i))
end

"""
    setStoredFPFeatures(x::AbstractCallExpr, f::Integer)
Write `f` — the opaque integer encoding of `clang::FPOptionsOverride` — into `x`'s trailing
slot.

`clang::CallExpr::setStoredFPFeatures` asserts `hasStoredFPFeatures()`, so the precondition is
restated here.
"""
function setStoredFPFeatures(x::AbstractCallExpr, f::Integer)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "call expression carries no stored FP features"
    return clang_CallExpr_setStoredFPFeatures(x, f)
end

# BinaryOperator
"""
    setStoredFPFeatures(x::AbstractBinaryOperator, f::Integer)
Write `f` — the opaque integer encoding of `clang::FPOptionsOverride` — into `x`'s trailing
slot.

`clang::BinaryOperator::setStoredFPFeatures` asserts the `HasFPFeatures` bit, so the
precondition is restated here.
"""
function setStoredFPFeatures(x::AbstractBinaryOperator, f::Integer)
    @check_ptrs x
    @assert hasStoredFPFeatures(x) "binary operator carries no stored FP features"
    return clang_BinaryOperator_setStoredFPFeatures(x, f)
end

# ShuffleVectorExpr
"""
    setExprs(x::AbstractShuffleVectorExpr, ctx::ASTContext, exprs::Vector{<:AbstractExpr})
Replace the operand array of `x`.

The operands are copied into freshly allocated `ctx` storage and the previous array is
deallocated, so `exprs` need not outlive the call. Upstream casts every slot to `Expr` and
constant-folds slots 2 and up, so no slot may be NULL, the first two entries must be the vector
operands and the rest integer constant expressions — the non-NULL and arity halves are
restated here.
"""
function setExprs(x::AbstractShuffleVectorExpr, ctx::ASTContext, exprs::Vector{<:AbstractExpr})
    @check_ptrs x ctx
    @assert all(e -> e.ptr != C_NULL, exprs) "a ShuffleVectorExpr holds no null operand"
    @assert length(exprs) >= 2 "a ShuffleVectorExpr keeps its two vector operands"
    buf = CXExpr[Base.unsafe_convert(CXExpr, e) for e in exprs]
    return clang_ShuffleVectorExpr_setExprs(x, ctx, buf, length(buf))
end

# DesignatedInitExpr::Designator
"""
    setFieldDecl(x::AbstractDesignator, fd::AbstractFieldDecl)
Resolve `x` to the field `fd`, replacing whatever the field slot held — including a
still-unresolved identifier.

`clang::DesignatedInitExpr::Designator::setFieldDecl` asserts `isFieldDesignator()`, so the
precondition is restated here.
"""
function setFieldDecl(x::AbstractDesignator, fd::AbstractFieldDecl)
    @check_ptrs x fd
    @assert isFieldDesignator(x) "setFieldDecl on a non-field designator"
    return clang_Designator_setFieldDecl(x, fd)
end

# BlockExpr
"""
    setBlockDecl(x::AbstractBlockExpr, bd::AbstractBlockDecl)
Point `x` at the block declaration `bd`.

Upstream stores `bd` unchecked while `getCaretLocation`, `getBody` and `getFunctionType` all
reach through the slot, so `bd` must be non-NULL.
"""
function setBlockDecl(x::AbstractBlockExpr, bd::AbstractBlockDecl)
    @check_ptrs x bd
    return clang_BlockExpr_setBlockDecl(x, bd)
end

# Expr (cont.)
"""
    getDependence(x::AbstractExpr) -> UInt32
Return the whole `clang::ExprDependence` bitmask `x` carries, in one read.

The bits are `1` unexpanded pack, `2` instantiation, `4` type, `8` value and `16` error; `0` means the
expression depends on nothing. This is a different numbering from `getDependence(::AbstractType)` —
the two masks must never be compared.
"""
function getDependence(x::AbstractExpr)
    @check_ptrs x
    return clang_Expr_getDependence(x)
end

"""
    isFlexibleArrayMemberLike(x::AbstractExpr, ctx::ASTContext, level::CXStrictFlexArraysLevelKind,
                              ignore_template_or_macro_substitution::Bool=false) -> Bool
Return whether `x` designates a trailing array member that behaves as a flexible array member under
the `-fstrict-flex-arrays` rule `level`.

`level` selects the rule to apply instead of being read out of `ctx`, so the answer does not depend on
how the interpreter was configured. Total: an expression that is not a member, declaration or ivar
reference, or whose type is neither a constant nor an incomplete array, answers `false`.
"""
function isFlexibleArrayMemberLike(x::AbstractExpr, ctx::ASTContext, level::CXStrictFlexArraysLevelKind, ignore_template_or_macro_substitution::Bool=false)
    @check_ptrs x ctx
    return clang_Expr_isFlexibleArrayMemberLike(x, ctx, level, ignore_template_or_macro_substitution)
end

# StringLiteral (cont.)
"""
    StringLiteral(ctx::ASTContext, str::AbstractString, kind::CXStringLiteralKind, pascal::Bool,
                  ty::QualType, locs::Vector{SourceLocation}) -> StringLiteral
Build the string literal holding the bytes of `str`, of type `ty`, in `ctx`'s arena.

`locs` gives the start location of each concatenated token and must name at least one. The bytes are
copied into the arena, so `str` need not outlive the call. Except for the `Unevaluated` kind clang
asserts that `ty` is a constant array type, and that the byte count is a whole multiple of the kind's
character width — so a wide, UTF-16 or UTF-32 `kind` needs `str` sized accordingly. The node is
arena-allocated: there is no `dispose`.
"""
function StringLiteral(ctx::ASTContext, str::AbstractString, kind::CXStringLiteralKind, pascal::Bool, ty::QualType, locs::Vector{SourceLocation})
    @check_ptrs ctx ty
    @assert !isempty(locs) "a string literal spans at least one token"
    @assert (kind == CXStringLiteralKind_Unevaluated || isConstantArrayType(getTypePtr(ty))) "an evaluated string literal's type must be a constant array type"
    s = String(str)
    buf = CXSourceLocation_[Base.unsafe_convert(CXSourceLocation_, l) for l in locs]
    return StringLiteral(clang_StringLiteral_Create(ctx, s, ncodeunits(s), kind, pascal, ty, buf, length(buf)))
end

"""
    StringLiteral(ctx::ASTContext, num_concatenated::Integer, len::Integer,
                  char_byte_width::Integer) -> StringLiteral
Build the empty string-literal shell clang deserializes into.

`num_concatenated`, `len` and `char_byte_width` are stored and read back through
`getNumConcatenated`, `getLength` and `getCharByteWidth`; the character bytes, the token locations
and the expression's type are left uninitialized, so nothing else may be read straight away.
"""
function StringLiteral(ctx::ASTContext, num_concatenated::Integer, len::Integer, char_byte_width::Integer)
    @check_ptrs ctx
    return StringLiteral(clang_StringLiteral_CreateEmpty(ctx, num_concatenated, len, char_byte_width))
end

# PredefinedExpr (cont.)
"""
    PredefinedExpr(ctx::ASTContext, has_function_name::Bool) -> PredefinedExpr
Build the empty `__func__`-family shell clang deserializes into. The identifier kind, the source
location and the `has_function_name` string-literal slot are left uninitialized, so only the node's
statement class may be read straight away.
"""
function PredefinedExpr(ctx::ASTContext, has_function_name::Bool)
    @check_ptrs ctx
    return PredefinedExpr(clang_PredefinedExpr_CreateEmpty(ctx, has_function_name))
end

# UnaryOperator (cont.)
"""
    UnaryOperator(ctx::ASTContext, has_fp_features::Bool) -> UnaryOperator
Build the empty unary-operator shell clang deserializes into. The operand, the opcode, the operator
location and the `has_fp_features` trailing `FPOptionsOverride` are left uninitialized, so only the
node's statement class may be read straight away.
"""
function UnaryOperator(ctx::ASTContext, has_fp_features::Bool)
    @check_ptrs ctx
    return UnaryOperator(clang_UnaryOperator_CreateEmpty(ctx, has_fp_features))
end

# OffsetOfExpr (cont.)
"""
    OffsetOfExpr(ctx::ASTContext, num_comps::Integer, num_exprs::Integer) -> OffsetOfExpr
Build the empty `__builtin_offsetof` shell clang deserializes into. The two counts are stored, but
the component slots, the index-expression slots, the type and the source locations behind them are
left uninitialized, so only the node's statement class may be read straight away.
"""
function OffsetOfExpr(ctx::ASTContext, num_comps::Integer, num_exprs::Integer)
    @check_ptrs ctx
    return OffsetOfExpr(clang_OffsetOfExpr_CreateEmpty(ctx, num_comps, num_exprs))
end

# CallExpr (cont.)
"""
    CallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool) -> CallExpr
Build the empty call shell clang deserializes into. `num_args` is stored and reads back through
`getNumArgs`, but the callee slot, the argument slots and the `has_fp_features` trailing
`FPOptionsOverride` are left uninitialized.
"""
function CallExpr(ctx::ASTContext, num_args::Integer, has_fp_features::Bool)
    @check_ptrs ctx
    return CallExpr(clang_CallExpr_CreateEmpty(ctx, num_args, has_fp_features))
end

# MemberExpr (cont.)
"""
    MemberExpr(ctx::ASTContext, has_qualifier::Bool, has_found_decl::Bool,
               has_template_kw_and_args_info::Bool, num_template_args::Integer) -> MemberExpr
Build the empty member-access shell clang deserializes into. The base, the member declaration and
every trailing slot the four shape flags reserve are left uninitialized, so only the node's statement
class may be read straight away.
"""
function MemberExpr(ctx::ASTContext, has_qualifier::Bool, has_found_decl::Bool, has_template_kw_and_args_info::Bool, num_template_args::Integer)
    @check_ptrs ctx
    return MemberExpr(clang_MemberExpr_CreateEmpty(ctx, has_qualifier, has_found_decl, has_template_kw_and_args_info, num_template_args))
end

# CompoundAssignOperator (cont.)
"""
    CompoundAssignOperator(ctx::ASTContext, has_fp_features::Bool) -> CompoundAssignOperator
Build the empty compound-assignment shell clang deserializes into. The operands, the opcode, the
computation types and the `has_fp_features` trailing `FPOptionsOverride` are left uninitialized, so
only the node's statement class may be read straight away.
"""
function CompoundAssignOperator(ctx::ASTContext, has_fp_features::Bool)
    @check_ptrs ctx
    return CompoundAssignOperator(clang_CompoundAssignOperator_CreateEmpty(ctx, has_fp_features))
end

# DesignatedInitExpr::Designator (cont.)
"""
    CreateFieldDesignator(name::IdentifierInfo, dot_loc::SourceLocation,
                          field_loc::SourceLocation) -> Designator
Build the `.name` designator of a designated initializer.

`clang::DesignatedInitExpr::Designator` is a by-value tagged union with no pointer form, so this
function allocates and one should call `dispose` to release the resources after using this object.
The designator `getDesignator` hands back is a borrowed interior pointer and must never be disposed.
"""
function CreateFieldDesignator(name::IdentifierInfo, dot_loc::SourceLocation, field_loc::SourceLocation)
    @check_ptrs name
    return Designator(clang_Designator_CreateFieldDesignator(name, dot_loc, field_loc))
end

"""
    CreateArrayDesignator(index::Integer, lbracket_loc::SourceLocation,
                          rbracket_loc::SourceLocation) -> Designator
Build the `[e]` designator of a designated initializer. `index` is the position of the index
expression in the owning `DesignatedInitExpr`'s subexpression array, not the value of the subscript.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateArrayDesignator(index::Integer, lbracket_loc::SourceLocation, rbracket_loc::SourceLocation)
    return Designator(clang_Designator_CreateArrayDesignator(index, lbracket_loc, rbracket_loc))
end

"""
    CreateArrayRangeDesignator(index::Integer, lbracket_loc::SourceLocation,
                               ellipsis_loc::SourceLocation,
                               rbracket_loc::SourceLocation) -> Designator
Build the GNU `[first ... last]` designator of a designated initializer. `index` names the first of
the two index expressions in the owning `DesignatedInitExpr`'s subexpression array.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateArrayRangeDesignator(index::Integer, lbracket_loc::SourceLocation, ellipsis_loc::SourceLocation, rbracket_loc::SourceLocation)
    return Designator(clang_Designator_CreateArrayRangeDesignator(index, lbracket_loc, ellipsis_loc, rbracket_loc))
end

# Release a Designator produced by `CreateFieldDesignator`, `CreateArrayDesignator` or
# `CreateArrayRangeDesignator`. The designator `getDesignator` hands back is a borrowed interior
# pointer into its DesignatedInitExpr and must never be passed here.
function dispose(x::AbstractDesignator)
    @check_ptrs x
    return clang_Designator_dispose(x)
end

# DesignatedInitExpr (cont.)
"""
    DesignatedInitExpr(ctx::ASTContext, num_index_exprs::Integer) -> DesignatedInitExpr
Build the empty designated-initializer shell clang deserializes into.

The designator list starts out empty — `size` reads `0` and `setDesignators` is how it gets filled —
and the `num_index_exprs` subexpression slots are reserved but uninitialized.
"""
function DesignatedInitExpr(ctx::ASTContext, num_index_exprs::Integer)
    @check_ptrs ctx
    return DesignatedInitExpr(clang_DesignatedInitExpr_CreateEmpty(ctx, num_index_exprs))
end

"""
    setDesignators(x::AbstractDesignatedInitExpr, ctx::ASTContext, designators::Vector{Designator})
Replace `x`'s whole designator list with copies of `designators`, allocated in `ctx`'s arena.

The designators are copied, so neither `designators` nor the objects it names need outlive the call,
and an owned one stays the caller's to `dispose`. This does not touch `x`'s index-expression slots,
whose count was fixed when the node was built.
"""
function setDesignators(x::AbstractDesignatedInitExpr, ctx::ASTContext, designators::Vector{Designator})
    @check_ptrs x ctx
    @assert all(d -> d.ptr != C_NULL, designators) "a designator list holds no null slot"
    buf = CXDesignator[Base.unsafe_convert(CXDesignator, d) for d in designators]
    return clang_DesignatedInitExpr_setDesignators(x, ctx, buf, length(buf))
end

# ParenListExpr (cont.)
"""
    ParenListExpr(ctx::ASTContext, num_exprs::Integer) -> ParenListExpr
Build the empty paren-list shell clang deserializes into. `num_exprs` is stored and reads back
through `getNumExprs`, but the operand slots and both parenthesis locations are left uninitialized.
"""
function ParenListExpr(ctx::ASTContext, num_exprs::Integer)
    @check_ptrs ctx
    return ParenListExpr(clang_ParenListExpr_CreateEmpty(ctx, num_exprs))
end

# GenericSelectionExpr (cont.)
"""
    GenericSelectionExpr(ctx::ASTContext, num_assocs::Integer) -> GenericSelectionExpr
Build the empty `_Generic` shell clang deserializes into. The controlling expression, the
`num_assocs` association expressions and their type-source-info slots, and the result index are left
uninitialized, so only the node's statement class may be read straight away.
"""
function GenericSelectionExpr(ctx::ASTContext, num_assocs::Integer)
    @check_ptrs ctx
    return GenericSelectionExpr(clang_GenericSelectionExpr_CreateEmpty(ctx, num_assocs))
end

# RecoveryExpr (cont.)
"""
    RecoveryExpr(ctx::ASTContext, num_sub_exprs::Integer) -> RecoveryExpr
Build the empty recovery shell clang deserializes into. The `num_sub_exprs` operand slots and the
source range are left uninitialized, so only the node's statement class may be read straight away.
"""
function RecoveryExpr(ctx::ASTContext, num_sub_exprs::Integer)
    @check_ptrs ctx
    return RecoveryExpr(clang_RecoveryExpr_CreateEmpty(ctx, num_sub_exprs))
end

# CallExpr (cont.)
"""
    CallExpr(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr}, ty::QualType,
             vk::CXExprValueKind, rparen_loc::SourceLocation, fp_features::Integer,
             min_num_args::Integer, uses_adl::Bool) -> CallExpr
Build the call expression `fn(args...)` of type `ty`.

The callee and the arguments are copied into the node's trailing storage, so `args` need not
outlive the call and may be empty. `fp_features` is the `clang::FPOptionsOverride` opaque
encoding `getFPFeatures` reads back: pass `0` for "no override", the only value that leaves
`hasStoredFPFeatures` false. `min_num_args` reserves default-argument slots past `args` — pass
`0` unless the caller fills them with `setArg`. `uses_adl` is the two-state
`clang::CallExpr::ADLCallKind` that `usesADL` reads back. Neither `fn` nor any argument slot
may be NULL, which this restates.
"""
function CallExpr(ctx::ASTContext, fn::AbstractExpr, args::Vector{<:AbstractExpr}, ty::QualType, vk::CXExprValueKind, rparen_loc::SourceLocation, fp_features::Integer, min_num_args::Integer, uses_adl::Bool)
    @check_ptrs ctx fn
    @assert all(a -> a.ptr != C_NULL, args) "a call expression holds no null argument slot"
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return CallExpr(clang_CallExpr_Create(ctx, fn, buf, length(buf), ty, vk, rparen_loc, fp_features, min_num_args, uses_adl))
end

# DeclRefExpr (cont.)
"""
    setCapturedByCopyInLambdaWithExplicitObjectParameter(x::AbstractDeclRefExpr, set::Bool,
                                                         ctx::ASTContext)
Record whether `x` names an entity captured by copy in a lambda with an explicit object
parameter, the bit `isCapturedByCopyInLambdaWithExplicitObjectParameter` reads back.

Setting it also recomputes the node's dependence bits, which is why the `ASTContext` is
required.
"""
function setCapturedByCopyInLambdaWithExplicitObjectParameter(x::AbstractDeclRefExpr, set::Bool, ctx::ASTContext)
    @check_ptrs x ctx
    clang_DeclRefExpr_setCapturedByCopyInLambdaWithExplicitObjectParameter(x, set, ctx)
    return nothing
end

# FixedPointLiteral
"""
    FixedPointLiteral(ctx::ASTContext) -> FixedPointLiteral
Build the empty fixed-point literal shell clang deserializes into.

Only the node's statement class is initialized. The type, the stored value and the scale carry
no default initializer, so `setScale` and `setLocation` must run before `getScale`,
`getLocation` or `getBeginLoc` read them. The class publishes no flag recording which slots
have been written, so that precondition is documented here and cannot be asserted.
"""
function FixedPointLiteral(ctx::ASTContext)
    @check_ptrs ctx
    return FixedPointLiteral(clang_FixedPointLiteral_Create(ctx))
end

"""
    getLocation(x::AbstractFixedPointLiteral) -> SourceLocation
Return the location of the literal token.

The member has no default initializer: this is defined only once clang has parsed `x` or
`setLocation` has run on a shell built by `FixedPointLiteral(ctx)`.
"""
function getLocation(x::AbstractFixedPointLiteral)
    @check_ptrs x
    return SourceLocation(clang_FixedPointLiteral_getLocation(x))
end

"""
    setLocation(x::AbstractFixedPointLiteral, loc::SourceLocation)
Set the location of the literal token, the value `getLocation` reads back.
"""
function setLocation(x::AbstractFixedPointLiteral, loc::SourceLocation)
    @check_ptrs x
    clang_FixedPointLiteral_setLocation(x, loc)
    return nothing
end

"""
    getScale(x::AbstractFixedPointLiteral) -> UInt32
Return the number of fractional bits the literal's stored integer is scaled by.

The member has no default initializer: this is defined only once clang has parsed `x` or
`setScale` has run on a shell built by `FixedPointLiteral(ctx)`.
"""
function getScale(x::AbstractFixedPointLiteral)
    @check_ptrs x
    return clang_FixedPointLiteral_getScale(x)
end

"""
    setScale(x::AbstractFixedPointLiteral, scale::Integer)
Set the number of fractional bits, the value `getScale` reads back.
"""
function setScale(x::AbstractFixedPointLiteral, scale::Integer)
    @check_ptrs x
    clang_FixedPointLiteral_setScale(x, scale)
    return nothing
end

# SYCLUniqueStableNameExpr
"""
    getTypeSourceInfo(x::AbstractSYCLUniqueStableNameExpr) -> TypeSourceInfo
Return the type-source-info of the type whose stable name `x` denotes.
"""
function getTypeSourceInfo(x::AbstractSYCLUniqueStableNameExpr)
    @check_ptrs x
    return TypeSourceInfo(clang_SYCLUniqueStableNameExpr_getTypeSourceInfo(x))
end

"""
    SYCLUniqueStableNameExpr(ctx::ASTContext, op_loc::SourceLocation,
                             lparen::SourceLocation, rparen::SourceLocation,
                             tsi::TypeSourceInfo) -> SYCLUniqueStableNameExpr
Build a `__builtin_sycl_unique_stable_name(T)` node over the type `tsi` describes.

clang fixes the node's type to `const char *`. `tsi` may not be NULL — clang's constructor
asserts on it — which `@check_ptrs` restates.
"""
function SYCLUniqueStableNameExpr(ctx::ASTContext, op_loc::SourceLocation, lparen::SourceLocation, rparen::SourceLocation, tsi::TypeSourceInfo)
    @check_ptrs ctx tsi
    return SYCLUniqueStableNameExpr(clang_SYCLUniqueStableNameExpr_Create(ctx, op_loc, lparen, rparen, tsi))
end

"""
    getLocation(x::AbstractSYCLUniqueStableNameExpr) -> SourceLocation
Return the location of the `__builtin_sycl_unique_stable_name` token.
"""
function getLocation(x::AbstractSYCLUniqueStableNameExpr)
    @check_ptrs x
    return SourceLocation(clang_SYCLUniqueStableNameExpr_getLocation(x))
end

"""
    getLParenLocation(x::AbstractSYCLUniqueStableNameExpr) -> SourceLocation
Return the location of the opening parenthesis.
"""
function getLParenLocation(x::AbstractSYCLUniqueStableNameExpr)
    @check_ptrs x
    return SourceLocation(clang_SYCLUniqueStableNameExpr_getLParenLocation(x))
end

"""
    getRParenLocation(x::AbstractSYCLUniqueStableNameExpr) -> SourceLocation
Return the location of the closing parenthesis.
"""
function getRParenLocation(x::AbstractSYCLUniqueStableNameExpr)
    @check_ptrs x
    return SourceLocation(clang_SYCLUniqueStableNameExpr_getRParenLocation(x))
end

"""
    ComputeName(x::AbstractSYCLUniqueStableNameExpr, ctx::ASTContext) -> String
Return the stable name clang generates for the stored type.

The name is an Itanium mangling produced by a mangler this call creates, so it does not follow
the target's C++ ABI. clang dereferences the stored type-source-info without checking it, so
this is defined only on a node clang parsed or `SYCLUniqueStableNameExpr(ctx, ...)` built.
"""
function ComputeName(x::AbstractSYCLUniqueStableNameExpr, ctx::ASTContext)
    @check_ptrs x ctx
    return get_string(clang_SYCLUniqueStableNameExpr_ComputeName(x, ctx))
end

# DeclRefExpr
"""
    getQualifierRange(x::AbstractDeclRefExpr) -> SourceRange
Return the source extent of the nested-name-specifier written before the referenced name.

`NestedNameSpecifierLoc` has no carrier of its own: the qualifier itself comes back from
`getQualifier`, its extent from here. The range is invalid when the reference is
unqualified.
"""
function getQualifierRange(x::AbstractDeclRefExpr)
    @check_ptrs x
    r = clang_DeclRefExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    copyTemplateArgumentsInto(x::AbstractDeclRefExpr, list::TemplateArgumentListInfo)
Append the template arguments written on `x`, and the angle-bracket locations, to `list`.

A reference carrying no explicit argument list leaves `list` untouched. `list` stays owned
by the caller and must be disposed.
"""
function copyTemplateArgumentsInto(x::AbstractDeclRefExpr, list::TemplateArgumentListInfo)
    @check_ptrs x list
    clang_DeclRefExpr_copyTemplateArgumentsInto(x, list)
    return nothing
end

# FixedPointLiteral
"""
    FixedPointLiteral(ctx::ASTContext, value::Integer, bit_width::Integer, ty::QualType,
                      loc::SourceLocation, scale::Integer) -> FixedPointLiteral
Build a fixed-point literal over the raw two's-complement `value` of `bit_width` bits,
scaled by `2^-scale`.

The value is rebuilt into an `llvm::APInt` inside the shim, so it crosses as a plain
integer rather than through the `GenericValue` bridge. Unlike the `FixedPointLiteral(ctx)`
deserialization shell, every slot this node reads is written here. The node is
ASTContext-arena memory; there is no `dispose`.
"""
function FixedPointLiteral(ctx::ASTContext, value::Integer, bit_width::Integer, ty::QualType, loc::SourceLocation, scale::Integer)
    @check_ptrs ctx
    @assert bit_width > 0 "a fixed-point literal needs a non-zero bit width"
    @assert ty.ptr != C_NULL "a fixed-point literal needs a non-NULL type"
    return FixedPointLiteral(clang_FixedPointLiteral_CreateFromRawInt(ctx, value, bit_width, ty, loc, scale))
end

"""
    getValueAsString(x::AbstractFixedPointLiteral, radix::Integer) -> String
Return the stored value rendered as a fixed-point fraction in `radix`.

Reads the stored value and the scale, neither of which carries a default initializer, so
the result is undefined on a shell built by `FixedPointLiteral(ctx)` whose slots have
never been written.
"""
function getValueAsString(x::AbstractFixedPointLiteral, radix::Integer)
    @check_ptrs x
    return get_string(clang_FixedPointLiteral_getValueAsString(x, radix))
end

# OffsetOfExpr
"""
    setComponent(x::AbstractOffsetOfExpr, i::Integer, n::AbstractOffsetOfNode)
Overwrite the `i`-th component of `x` (0-based, `i < getNumComponents(x)`) with a copy of
`n`.

The node is copied by value, so `n` stays owned by whatever produced it.
"""
function setComponent(x::AbstractOffsetOfExpr, i::Integer, n::AbstractOffsetOfNode)
    @check_ptrs x n
    @assert 0 <= i < getNumComponents(x) "component index $i out of range"
    clang_OffsetOfExpr_setComponent(x, i, n)
    return nothing
end

# MemberExpr
"""
    getQualifierRange(x::AbstractMemberExpr) -> SourceRange
Return the source extent of the nested-name-specifier written before the member name.

The qualifier itself comes back from `getQualifier`; the range is invalid when the member
access is unqualified.
"""
function getQualifierRange(x::AbstractMemberExpr)
    @check_ptrs x
    r = clang_MemberExpr_getQualifierRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    copyTemplateArgumentsInto(x::AbstractMemberExpr, list::TemplateArgumentListInfo)
Append the template arguments written on `x`, and the angle-bracket locations, to `list`.

A member reference carrying no explicit argument list leaves `list` untouched. `list` stays
owned by the caller and must be disposed.
"""
function copyTemplateArgumentsInto(x::AbstractMemberExpr, list::TemplateArgumentListInfo)
    @check_ptrs x list
    clang_MemberExpr_copyTemplateArgumentsInto(x, list)
    return nothing
end

# BinaryOperator
"""
    setHasStoredFPFeatures(x::AbstractBinaryOperator, b::Bool)
Record whether `x` carries a trailing `FPOptionsOverride` slot.

This only flips the bit; it does not allocate the slot. Setting it on an operator clang
built without one makes `getStoredFPFeatures` read past the node, and `BinaryOperator`
publishes no record of how it was allocated other than this same bit — so the
precondition, pass only the value the node was built with, is documented here rather than
asserted.
"""
function setHasStoredFPFeatures(x::AbstractBinaryOperator, b::Bool)
    @check_ptrs x
    clang_BinaryOperator_setHasStoredFPFeatures(x, b)
    return nothing
end

# DesignatedInitExpr
"""
    ExpandDesignator(x::AbstractDesignatedInitExpr, ctx::ASTContext, i::Integer,
                     ds::Vector{<:AbstractDesignator})
Replace the `i`-th designator of `x` (0-based, `i < size(x)`) with copies of the
designators in `ds`, growing the designator array in `ctx`'s arena.

Unless `length(ds) == 1` the array is reallocated, which dangles every `Designator`
previously obtained from `x`.
"""
function ExpandDesignator(x::AbstractDesignatedInitExpr, ctx::ASTContext, i::Integer, ds::Vector{<:AbstractDesignator})
    @check_ptrs x ctx
    @assert 0 <= i < size(x) "designator index $i out of range"
    @assert all(d -> d.ptr != C_NULL, ds) "a designator list holds no null slot"
    buf = CXDesignator[Base.unsafe_convert(CXDesignator, d) for d in ds]
    clang_DesignatedInitExpr_ExpandDesignator(x, ctx, i, buf, length(buf))
    return nothing
end

# GenericSelectionExpr
"""
    getAssocType(x::AbstractGenericSelectionExpr, i::Integer) -> QualType
Return the type written on the `i`-th association (0-based, `i < getNumAssocs(x)`).

This is the `getType()` field of `clang::GenericSelectionExpr::Association`; a `default:`
arm carries no written type, so its slot is the null `QualType`.
"""
function getAssocType(x::AbstractGenericSelectionExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAssocs(x) "association index $i out of range"
    return QualType(clang_GenericSelectionExpr_getAssocType(x, i))
end

"""
    isAssocSelected(x::AbstractGenericSelectionExpr, i::Integer) -> Bool
Return whether the `i`-th association (0-based, `i < getNumAssocs(x)`) is the one this
`_Generic` selects.

Every arm reports `false` while the selection is still result-dependent.
"""
function isAssocSelected(x::AbstractGenericSelectionExpr, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAssocs(x) "association index $i out of range"
    return clang_GenericSelectionExpr_isAssocSelected(x, i)
end

# AsTypeExpr
"""
    AsTypeExpr(ctx::ASTContext, src::AbstractExpr, ty::QualType, vk::CXExprValueKind,
               ok::CXExprObjectKind, builtin_loc::SourceLocation,
               rparen_loc::SourceLocation) -> AsTypeExpr
Build an `__builtin_astype` reinterpretation of `src` as `ty`.

`__builtin_astype` is spelled only in OpenCL, so a C++ parse never produces an
`AsTypeExpr`; this is the way to obtain one. The node is ASTContext-arena memory; there is
no `dispose`.
"""
function AsTypeExpr(ctx::ASTContext, src::AbstractExpr, ty::QualType, vk::CXExprValueKind, ok::CXExprObjectKind, builtin_loc::SourceLocation, rparen_loc::SourceLocation)
    @check_ptrs ctx src
    @assert ty.ptr != C_NULL "an AsTypeExpr needs a non-NULL destination type"
    return AsTypeExpr(clang_AsTypeExpr_Create(ctx, src, ty, vk, ok, builtin_loc, rparen_loc))
end

"""
    getSrcExpr(x::AbstractAsTypeExpr) -> Expr_
Return the expression `x` reinterprets.
"""
function getSrcExpr(x::AbstractAsTypeExpr)
    @check_ptrs x
    return Expr_(clang_AsTypeExpr_getSrcExpr(x))
end

"""
    getBuiltinLoc(x::AbstractAsTypeExpr) -> SourceLocation
Return the location of the `__builtin_astype` token.
"""
function getBuiltinLoc(x::AbstractAsTypeExpr)
    @check_ptrs x
    return SourceLocation(clang_AsTypeExpr_getBuiltinLoc(x))
end

"""
    getRParenLoc(x::AbstractAsTypeExpr) -> SourceLocation
Return the location of the closing parenthesis.
"""
function getRParenLoc(x::AbstractAsTypeExpr)
    @check_ptrs x
    return SourceLocation(clang_AsTypeExpr_getRParenLoc(x))
end

# Expr::EvalStatus / Expr::EvalResult
"""
    EvalResult() -> EvalResult
Build an empty constant-evaluation result: the value an expression folds to, together with the
status of the fold.

The result holds no value until `EvaluateAsRValue`, `EvaluateAsLValue` or
`EvaluateCharRangeAsString` fills it, and clang never clears the status flags between
evaluations into the same result, so use a fresh result per evaluation whenever the flags
matter. This function allocates and one should call `dispose` to release the resources after
using this object.
"""
function EvalResult()
    return EvalResult(clang_EvalResult_create())
end

# Release an owned EvalResult — one produced by `EvalResult()`.
function dispose(x::AbstractEvalResult)
    @check_ptrs x
    return clang_EvalResult_dispose(x)
end

"""
    getVal(x::AbstractEvalResult) -> APValue
Return the value the evaluated expression folded to.

The `APValue` is interior to `x` and borrowed: it must not be disposed and it dies with `x`.
Its kind is `CXAPValueKind_None` until an evaluator has filled `x`.
"""
function getVal(x::AbstractEvalResult)
    @check_ptrs x
    return APValue(clang_EvalResult_getVal(x))
end

"""
    hasSideEffects(x::AbstractEvalStatus) -> Bool
Return whether the evaluated expression has side effects; `f() && 0` folds to `0` and still
has them.
"""
function hasSideEffects(x::AbstractEvalStatus)
    @check_ptrs x
    return clang_EvalStatus_hasSideEffects(x)
end

"""
    hasUndefinedBehavior(x::AbstractEvalStatus) -> Bool
Return whether the evaluation hit undefined behaviour; `INT_MAX + 1` folds to `INT_MIN` and
still has it.
"""
function hasUndefinedBehavior(x::AbstractEvalStatus)
    @check_ptrs x
    return clang_EvalStatus_hasUndefinedBehavior(x)
end

"""
    isGlobalLValue(x::AbstractEvalResult) -> Bool
Return whether the lvalue `x` holds designates an object with a link-time known address.

`clang::Expr::EvalResult::isGlobalLValue` asserts that the folded value is an lvalue, so the
precondition is restated here: fill `x` with `EvaluateAsLValue` and only then read this.
"""
function isGlobalLValue(x::AbstractEvalResult)
    @check_ptrs x
    @assert isLValue(getVal(x)) "the evaluation result must hold an lvalue"
    return clang_EvalResult_isGlobalLValue(x)
end

# Expr (cont.)
"""
    EvaluateAsRValue(x::AbstractExpr, ctx::ASTContext, result::AbstractEvalResult,
                     in_constant_context::Bool) -> Bool
Fold `x` to an rvalue into `result` and return whether the fold succeeded.

This is the status-reporting form of the two-argument `EvaluateAsRValue`: the folded value
lands in `result` (`getVal`) next to the `hasSideEffects` and `hasUndefinedBehavior` flags,
which the two-argument form discards. `result` holds whatever a failed fold left behind.
"""
function EvaluateAsRValue(x::AbstractExpr, ctx::ASTContext, result::AbstractEvalResult, in_constant_context::Bool)
    @check_ptrs x ctx result
    return clang_Expr_EvaluateAsRValueIntoResult(x, ctx, in_constant_context, result)
end

"""
    EvaluateAsLValue(x::AbstractExpr, ctx::ASTContext, result::AbstractEvalResult,
                     in_constant_context::Bool) -> Bool
Fold `x` to an lvalue with a link-time known address into `result` and return whether the fold
succeeded.

This is the only evaluator that leaves an lvalue in `result`, so it is the one that makes
`isGlobalLValue` callable.
"""
function EvaluateAsLValue(x::AbstractExpr, ctx::ASTContext, result::AbstractEvalResult, in_constant_context::Bool)
    @check_ptrs x ctx result
    return clang_Expr_EvaluateAsLValueIntoResult(x, ctx, in_constant_context, result)
end

"""
    EvaluateCharRangeAsString(x::AbstractExpr, size_expr::AbstractExpr,
                              ptr_expr::AbstractExpr, ctx::ASTContext,
                              status::AbstractEvalResult) -> (Bool, String)
Fold `size_expr` to a count and `ptr_expr` to a character pointer, read that many code units,
and return whether the read succeeded together with the text it produced.

The string is empty when the first element is `false`. `x` only scopes the evaluation — it
need not be related to either operand — and `status` collects the evaluation's flags.
"""
function EvaluateCharRangeAsString(x::AbstractExpr, size_expr::AbstractExpr, ptr_expr::AbstractExpr, ctx::ASTContext, status::AbstractEvalResult)
    @check_ptrs x size_expr ptr_expr ctx status
    ok = Ref{Bool}(false)
    cxs = clang_Expr_EvaluateCharRangeAsString(x, size_expr, ptr_expr, ctx, status, ok)
    return ok[], get_string(cxs)
end

# DeclRefExpr (cont.)
"""
    DeclRefExpr(ctx::ASTContext, has_qualifier::Bool, has_found_decl::Bool,
                has_template_kw_and_args_info::Bool, num_template_args::Integer) -> DeclRefExpr
Build the empty declaration-reference shell clang deserializes into.

The four arguments size the node's trailing storage; the referenced decl, the name info, the
qualifier and the flag bits themselves are left uninitialized, so only the node's statement
class may be read straight away. `clang::DeclRefExpr::CreateEmpty` asserts that template
arguments come with the template-keyword info.
"""
function DeclRefExpr(ctx::ASTContext, has_qualifier::Bool, has_found_decl::Bool, has_template_kw_and_args_info::Bool, num_template_args::Integer)
    @check_ptrs ctx
    @assert num_template_args == 0 || has_template_kw_and_args_info "template arguments need the template-keyword info"
    return DeclRefExpr(clang_DeclRefExpr_CreateEmpty(ctx, has_qualifier, has_found_decl, has_template_kw_and_args_info, num_template_args))
end

# FloatingLiteral (cont.)
"""
    FloatingLiteral(ctx::ASTContext) -> FloatingLiteral
Build the empty floating-literal shell clang deserializes into.

Only the node's statement class may be read straight away: write the raw semantics, the
exactness flag, the value and the location with `setRawSemantics`, `setExact`, `setValue` and
`setLocation` before reading them back.
"""
function FloatingLiteral(ctx::ASTContext)
    @check_ptrs ctx
    return FloatingLiteral(clang_FloatingLiteral_CreateEmpty(ctx))
end

# SYCLUniqueStableNameExpr (cont.)
"""
    SYCLUniqueStableNameExpr(ctx::ASTContext) -> SYCLUniqueStableNameExpr
Build the empty `__builtin_sycl_unique_stable_name` shell clang deserializes into.

The type-source-info and all three locations are left uninitialized, so only the node's
statement class may be read straight away.
"""
function SYCLUniqueStableNameExpr(ctx::ASTContext)
    @check_ptrs ctx
    return SYCLUniqueStableNameExpr(clang_SYCLUniqueStableNameExpr_CreateEmpty(ctx))
end

# CallExpr (cont.)
"""
    setNumArgsUnsafe(x::AbstractCallExpr, n::Integer)
Set `x`'s argument count to `n` with no checking whatsoever.

`clang::CallExpr::setNumArgsUnsafe` writes the count straight into the node. The argument
slots live in trailing storage sized once at construction, so `n` must not exceed the count
`x` was built with; the C++ API reports that capacity nowhere, so this precondition is
documented rather than asserted. `shrinkNumArgs` is the checked way down.
"""
function setNumArgsUnsafe(x::AbstractCallExpr, n::Integer)
    @check_ptrs x
    return clang_CallExpr_setNumArgsUnsafe(x, n)
end

# BlockVarCopyInit
"""
    BlockVarCopyInit(copy_expr::AbstractExpr, can_throw::Bool) -> BlockVarCopyInit
Build the copy-initialization record of a `__block` variable: the expression that copies the
variable into its block, plus whether that copy can throw.

This function allocates and one should call `dispose` to release the resources after using
this object; the boxed expression is AST-owned and outlives the box.
"""
function BlockVarCopyInit(copy_expr::AbstractExpr, can_throw::Bool)
    @check_ptrs copy_expr
    return BlockVarCopyInit(clang_BlockVarCopyInit_create(copy_expr, can_throw))
end

# Release an owned BlockVarCopyInit — one produced by `BlockVarCopyInit`.
function dispose(x::AbstractBlockVarCopyInit)
    @check_ptrs x
    return clang_BlockVarCopyInit_dispose(x)
end

"""
    getCopyExpr(x::AbstractBlockVarCopyInit) -> Expr_
Return the expression that copies the `__block` variable into its block.
"""
function getCopyExpr(x::AbstractBlockVarCopyInit)
    @check_ptrs x
    return Expr_(clang_BlockVarCopyInit_getCopyExpr(x))
end

"""
    canThrow(x::AbstractBlockVarCopyInit) -> Bool
Return whether the copy initialization can throw.
"""
function canThrow(x::AbstractBlockVarCopyInit)
    @check_ptrs x
    return clang_BlockVarCopyInit_canThrow(x)
end

"""
    setExprAndFlag(x::AbstractBlockVarCopyInit, copy_expr::AbstractExpr, can_throw::Bool)
Replace both halves of `x`: the copy expression and the can-throw flag.
"""
function setExprAndFlag(x::AbstractBlockVarCopyInit, copy_expr::AbstractExpr, can_throw::Bool)
    @check_ptrs x copy_expr
    return clang_BlockVarCopyInit_setExprAndFlag(x, copy_expr, can_throw)
end

# PseudoObjectExpr (cont.)
"""
    PseudoObjectExpr(ctx::ASTContext, num_semantic_exprs::Integer) -> PseudoObjectExpr
Build the empty pseudo-object shell clang deserializes into.

`num_semantic_exprs` is stored and reads back through `getNumSemanticExprs`, but the syntactic
slot, the semantic slots and the result index are left uninitialized.
"""
function PseudoObjectExpr(ctx::ASTContext, num_semantic_exprs::Integer)
    @check_ptrs ctx
    return PseudoObjectExpr(clang_PseudoObjectExpr_CreateEmpty(ctx, num_semantic_exprs))
end

"""
    setArgumentTypeInfo(x::AbstractUnaryExprOrTypeTraitExpr, tinfo::TypeSourceInfo)
Replace the operand of `x` with the type `tinfo` denotes, making it a type operand.

`tinfo` must be non-NULL: once the is-type bit is set,
[`getArgumentType`](@ref) dereferences the stored `TypeSourceInfo` without checking.
"""
function setArgumentTypeInfo(x::AbstractUnaryExprOrTypeTraitExpr, tinfo::TypeSourceInfo)
    @check_ptrs x tinfo
    return clang_UnaryExprOrTypeTraitExpr_setArgumentTypeInfo(x, tinfo)
end
