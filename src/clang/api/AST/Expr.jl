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

