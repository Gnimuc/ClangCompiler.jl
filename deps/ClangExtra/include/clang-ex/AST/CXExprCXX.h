#ifndef LLVM_CLANG_C_EXTRA_CXEXPRCXX_H
#define LLVM_CLANG_C_EXTRA_CXEXPRCXX_H

#include "clang-ex/AST/CXOperationKinds.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXExpressionTraits.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXTypeTraits.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CXXNamedCastExpr
// The written destination type and the operand are reached through the base
// classes: clang_ExplicitCastExpr_getTypeAsWritten / clang_CastExpr_getSubExpr.
const char *clang_CXXNamedCastExpr_getCastName(CXCXXNamedCastExpr E);

CXSourceRange_ clang_CXXNamedCastExpr_getAngleBrackets(CXCXXNamedCastExpr E);

// CXXThrowExpr
// NULL for a re-throw (`throw;`), which carries no operand.
CXExpr clang_CXXThrowExpr_getSubExpr(CXCXXThrowExpr E);

CXSourceLocation_ clang_CXXThrowExpr_getThrowLoc(CXCXXThrowExpr E);

bool clang_CXXThrowExpr_isThrownVariableInScope(CXCXXThrowExpr E);

// CXXTypeidExpr
bool clang_CXXTypeidExpr_isPotentiallyEvaluated(CXCXXTypeidExpr E);

// PRECONDITION: !isTypeOperand() - reads the expression arm of the operand
// PointerUnion; the Julia wrapper restates this as an @assert.
bool clang_CXXTypeidExpr_isMostDerived(CXCXXTypeidExpr E, CXASTContext Ctx);
bool clang_CXXTypeidExpr_isTypeOperand(CXCXXTypeidExpr E);

// PRECONDITION: isTypeOperand() - Clang asserts and then reads the type arm of
// the operand PointerUnion; the Julia wrapper restates this as an @assert.
CXQualType clang_CXXTypeidExpr_getTypeOperand(CXCXXTypeidExpr E, CXASTContext Ctx);

// PRECONDITION: isTypeOperand() - Clang asserts and then reads the operand
// PointerUnion unchecked; the Julia wrapper restates this as an @assert.
CXTypeSourceInfo clang_CXXTypeidExpr_getTypeOperandSourceInfo(CXCXXTypeidExpr E);

// PRECONDITION: !isTypeOperand() - same unchecked PointerUnion read.
CXExpr clang_CXXTypeidExpr_getExprOperand(CXCXXTypeidExpr E);

// CXXDefaultArgExpr
CXParmVarDecl clang_CXXDefaultArgExpr_getParam(CXCXXDefaultArgExpr E);

// PRECONDITION: the parameter's default argument is already instantiated -
// getExpr() forwards to ParmVarDecl::getDefaultArg(), which asserts
// !hasUninstantiatedDefaultArg().
CXExpr clang_CXXDefaultArgExpr_getExpr(CXCXXDefaultArgExpr E);

// CXXDefaultInitExpr
CXFieldDecl clang_CXXDefaultInitExpr_getField(CXCXXDefaultInitExpr E);

// PRECONDITION: the field carries an in-class initializer - getExpr() asserts on
// the rewritten-init / in-class-initializer pair.
CXExpr clang_CXXDefaultInitExpr_getExpr(CXCXXDefaultInitExpr E);

// CXXBindTemporaryExpr
CXExpr clang_CXXBindTemporaryExpr_getSubExpr(CXCXXBindTemporaryExpr E);

// ExprWithCleanups
unsigned clang_ExprWithCleanups_getNumObjects(CXExprWithCleanups E);

bool clang_ExprWithCleanups_cleanupsHaveSideEffects(CXExprWithCleanups E);

// TypeTraitExpr
// PRECONDITION: !isValueDependent() - Clang asserts.
bool clang_TypeTraitExpr_getValue(CXTypeTraitExpr E);

unsigned clang_TypeTraitExpr_getNumArgs(CXTypeTraitExpr E);

// PRECONDITION: I < getNumArgs() - Clang asserts, then indexes the trailing
// TypeSourceInfo* array unchecked.
CXTypeSourceInfo clang_TypeTraitExpr_getArg(CXTypeTraitExpr E, unsigned I);

// SizeOfPackExpr
CXNamedDecl clang_SizeOfPackExpr_getPack(CXSizeOfPackExpr E);

bool clang_SizeOfPackExpr_isPartiallySubstituted(CXSizeOfPackExpr E);

CXSourceLocation_ clang_SizeOfPackExpr_getOperatorLoc(CXSizeOfPackExpr E);

CXSourceLocation_ clang_SizeOfPackExpr_getPackLoc(CXSizeOfPackExpr E);

CXSourceLocation_ clang_SizeOfPackExpr_getRParenLoc(CXSizeOfPackExpr E);

// PRECONDITION: !isValueDependent() - Clang asserts; the Julia wrapper restates
// this as an @assert.
unsigned clang_SizeOfPackExpr_getPackLength(CXSizeOfPackExpr E);

// CXXFoldExpr
// The operand holding the unexpanded pack (getRHS() for a left fold, getLHS()
// for a right fold); never NULL.
CXExpr clang_CXXFoldExpr_getPattern(CXCXXFoldExpr E);

// The operator-lookup callee; may hold NULL when the fold has no callee.
CXUnresolvedLookupExpr clang_CXXFoldExpr_getCallee(CXCXXFoldExpr E);

// The left operand; NULL for a unary left fold `(... op pack)`.
CXExpr clang_CXXFoldExpr_getLHS(CXCXXFoldExpr E);

// The right operand; NULL for a unary right fold `(pack op ...)`.
CXExpr clang_CXXFoldExpr_getRHS(CXCXXFoldExpr E);

bool clang_CXXFoldExpr_isLeftFold(CXCXXFoldExpr E);

bool clang_CXXFoldExpr_isRightFold(CXCXXFoldExpr E);

// The non-pack operand of a binary fold; NULL for a unary fold.
CXExpr clang_CXXFoldExpr_getInit(CXCXXFoldExpr E);

CXSourceLocation_ clang_CXXFoldExpr_getLParenLoc(CXCXXFoldExpr E);

CXSourceLocation_ clang_CXXFoldExpr_getRParenLoc(CXCXXFoldExpr E);

CXSourceLocation_ clang_CXXFoldExpr_getEllipsisLoc(CXCXXFoldExpr E);

// mirrors clang::BinaryOperatorKind (CXBinaryOperatorKind in CXOperationKinds.h)
CXBinaryOperatorKind clang_CXXFoldExpr_getOperator(CXCXXFoldExpr E);

// CXXOperatorCallExpr
CXOverloadedOperatorKind clang_CXXOperatorCallExpr_getOperator(CXCXXOperatorCallExpr OCE);

CXSourceLocation_ clang_CXXOperatorCallExpr_getOperatorLoc(CXCXXOperatorCallExpr OCE);

bool clang_CXXOperatorCallExpr_isAssignmentOp(CXCXXOperatorCallExpr OCE);

bool clang_CXXOperatorCallExpr_isComparisonOp(CXCXXOperatorCallExpr OCE);

// CXXMemberCallExpr
CXExpr clang_CXXMemberCallExpr_getImplicitObjectArgument(CXCXXMemberCallExpr MCE);

CXCXXMethodDecl clang_CXXMemberCallExpr_getMethodDecl(CXCXXMemberCallExpr MCE);

CXCXXRecordDecl clang_CXXMemberCallExpr_getRecordDecl(CXCXXMemberCallExpr MCE);

// PRECONDITION: the call has an implicit object argument (a normal member call,
// not a pointer-to-member call) - getObjectType() dereferences
// getImplicitObjectArgument() unchecked; the Julia wrapper restates this as an
// @assert.
CXQualType clang_CXXMemberCallExpr_getObjectType(CXCXXMemberCallExpr MCE);

// CXXBoolLiteralExpr
bool clang_CXXBoolLiteralExpr_getValue(CXCXXBoolLiteralExpr BLE);

// CXXConstructExpr
// mirrors clang::CXXConstructionKind (synced by static_assert in CXEnumSync.cpp)
typedef enum CXCXXConstructionKind {
  CXCXXConstructionKind_Complete,
  CXCXXConstructionKind_NonVirtualBase,
  CXCXXConstructionKind_VirtualBase,
  CXCXXConstructionKind_Delegating
} CXCXXConstructionKind;

CXCXXConstructorDecl clang_CXXConstructExpr_getConstructor(CXCXXConstructExpr CE);

unsigned clang_CXXConstructExpr_getNumArgs(CXCXXConstructExpr CE);

CXExpr clang_CXXConstructExpr_getArg(CXCXXConstructExpr CE, unsigned Arg);

bool clang_CXXConstructExpr_isElidable(CXCXXConstructExpr CE);

CXCXXConstructionKind clang_CXXConstructExpr_getConstructionKind(CXCXXConstructExpr CE);

// LambdaExpr
CXCXXMethodDecl clang_LambdaExpr_getCallOperator(CXLambdaExpr LE);

CXCXXRecordDecl clang_LambdaExpr_getLambdaClass(CXLambdaExpr LE);

CXStmt clang_LambdaExpr_getBody(CXLambdaExpr LE);

bool clang_LambdaExpr_isMutable(CXLambdaExpr LE);

// CXXNewExpr
// mirrors clang::CXXNewInitializationStyle (synced by static_assert in CXEnumSync.cpp)
typedef enum CXCXXNewInitializationStyle {
  CXCXXNewInitializationStyle_None,
  CXCXXNewInitializationStyle_Parens,
  CXCXXNewInitializationStyle_Braces
} CXCXXNewInitializationStyle;

CXCXXNewInitializationStyle clang_CXXNewExpr_getInitializationStyle(CXCXXNewExpr NE);

CXFunctionDecl clang_CXXNewExpr_getOperatorNew(CXCXXNewExpr NE);

CXFunctionDecl clang_CXXNewExpr_getOperatorDelete(CXCXXNewExpr NE);

CXQualType clang_CXXNewExpr_getAllocatedType(CXCXXNewExpr NE);

bool clang_CXXNewExpr_isArray(CXCXXNewExpr NE);

// NULL when the new-expression has no array size
CXExpr clang_CXXNewExpr_getArraySize(CXCXXNewExpr NE);

bool clang_CXXNewExpr_hasInitializer(CXCXXNewExpr NE);

CXExpr clang_CXXNewExpr_getInitializer(CXCXXNewExpr NE);

// CXXDeleteExpr
CXExpr clang_CXXDeleteExpr_getArgument(CXCXXDeleteExpr DE);

bool clang_CXXDeleteExpr_isArrayForm(CXCXXDeleteExpr DE);

CXFunctionDecl clang_CXXDeleteExpr_getOperatorDelete(CXCXXDeleteExpr DE);

// CXXBoolLiteralExpr
CXSourceLocation_ clang_CXXBoolLiteralExpr_getLocation(CXCXXBoolLiteralExpr E);

// CXXThisExpr
CXSourceLocation_ clang_CXXThisExpr_getLocation(CXCXXThisExpr E);

bool clang_CXXThisExpr_isImplicit(CXCXXThisExpr E);

// CXXNewExpr
bool clang_CXXNewExpr_shouldNullCheckAllocation(CXCXXNewExpr E);

unsigned clang_CXXNewExpr_getNumPlacementArgs(CXCXXNewExpr E);

bool clang_CXXNewExpr_isParenTypeId(CXCXXNewExpr E);

bool clang_CXXNewExpr_isGlobalNew(CXCXXNewExpr E);

bool clang_CXXNewExpr_passAlignment(CXCXXNewExpr E);

bool clang_CXXNewExpr_doesUsualArrayDeleteWantSize(CXCXXNewExpr E);

// CXXDeleteExpr
bool clang_CXXDeleteExpr_isGlobalDelete(CXCXXDeleteExpr E);

bool clang_CXXDeleteExpr_isArrayFormAsWritten(CXCXXDeleteExpr E);

bool clang_CXXDeleteExpr_doesUsualArrayDeleteWantSize(CXCXXDeleteExpr E);

CXQualType clang_CXXDeleteExpr_getDestroyedType(CXCXXDeleteExpr E);

// CXXConstructExpr
CXSourceLocation_ clang_CXXConstructExpr_getLocation(CXCXXConstructExpr E);

bool clang_CXXConstructExpr_hadMultipleCandidates(CXCXXConstructExpr E);

bool clang_CXXConstructExpr_isListInitialization(CXCXXConstructExpr E);

bool clang_CXXConstructExpr_isStdInitListInitialization(CXCXXConstructExpr E);

bool clang_CXXConstructExpr_requiresZeroInitialization(CXCXXConstructExpr E);

bool clang_CXXConstructExpr_isImmediateEscalating(CXCXXConstructExpr E);

// MaterializeTemporaryExpr
unsigned clang_MaterializeTemporaryExpr_getManglingNumber(CXMaterializeTemporaryExpr E);

bool clang_MaterializeTemporaryExpr_isBoundToLvalueReference(CXMaterializeTemporaryExpr E);

// CXXNamedCastExpr
CXSourceLocation_ clang_CXXNamedCastExpr_getOperatorLoc(CXCXXNamedCastExpr E);

CXSourceLocation_ clang_CXXNamedCastExpr_getRParenLoc(CXCXXNamedCastExpr E);


// CXXNewExpr
CXTypeSourceInfo clang_CXXNewExpr_getAllocatedTypeSourceInfo(CXCXXNewExpr E);

CXCXXConstructExpr clang_CXXNewExpr_getConstructExpr(CXCXXNewExpr E);

// MaterializeTemporaryExpr
CXExpr clang_MaterializeTemporaryExpr_getSubExpr(CXMaterializeTemporaryExpr E);

CXValueDecl clang_MaterializeTemporaryExpr_getExtendingDecl(CXMaterializeTemporaryExpr E);

// LambdaExpr captures
// getNumCaptures/getCapture wrap LambdaExpr::capture_size/capture_begin; the
// capture_iterator is a random-access `const LambdaCapture *`.
unsigned clang_LambdaExpr_getNumCaptures(CXLambdaExpr LE);

// Borrowed interior pointer into the lambda's capture list; do not dispose.
CXLambdaCapture clang_LambdaExpr_getCapture(CXLambdaExpr LE, unsigned I);

bool clang_LambdaExpr_isGenericLambda(CXLambdaExpr LE);

// LambdaCapture (clang/AST/LambdaCapture.h) - borrowed, interior to the LambdaExpr
CXLambdaCaptureKind clang_LambdaCapture_getCaptureKind(CXLambdaCapture C);

bool clang_LambdaCapture_capturesThis(CXLambdaCapture C);

bool clang_LambdaCapture_capturesVariable(CXLambdaCapture C);

bool clang_LambdaCapture_capturesVLAType(CXLambdaCapture C);

// getCapturedVar returns clang::ValueDecl* (not VarDecl*); valid only when
// capturesVariable() is true (Clang asserts this precondition).
CXValueDecl clang_LambdaCapture_getCapturedVar(CXLambdaCapture C);

// LambdaExpr
CXLambdaCaptureDefault clang_LambdaExpr_getCaptureDefault(CXLambdaExpr LE);

CXSourceLocation_ clang_LambdaExpr_getCaptureDefaultLoc(CXLambdaExpr LE);

CXSourceRange_ clang_LambdaExpr_getIntroducerRange(CXLambdaExpr LE);

// Indexed form of LambdaExpr::capture_init_begin(); the capture_init_iterator is a
// random-access `Expr **`. PRECONDITION: I < getNumCaptures(LE) - the shim does no
// bounds check. NULL when the capture carries no initializer (VLA-type captures).
CXExpr clang_LambdaExpr_getCaptureInit(CXLambdaExpr LE, unsigned I);

// PRECONDITION: C must be one of LE's own captures - LambdaExpr::isInitCapture
// indexes LE's capture list with the pointer it is handed.
bool clang_LambdaExpr_isInitCapture(CXLambdaExpr LE, CXLambdaCapture C);

bool clang_LambdaExpr_hasExplicitParameters(CXLambdaExpr LE);

bool clang_LambdaExpr_hasExplicitResultType(CXLambdaExpr LE);

// PRECONDITION: getCompoundStmtBody unwraps the body with cast<CompoundStmt>, so the
// body must be a CompoundStmt, or a CoroutineBodyStmt wrapping one (Clang asserts).
CXCompoundStmt clang_LambdaExpr_getCompoundStmtBody(CXLambdaExpr LE);

// NULL unless the lambda is generic
CXFunctionTemplateDecl clang_LambdaExpr_getDependentCallOperator(CXLambdaExpr LE);

// NULL unless the lambda is generic
CXTemplateParameterList clang_LambdaExpr_getTemplateParameterList(CXLambdaExpr LE);

// NULL when the lambda has no trailing requires-clause
CXExpr clang_LambdaExpr_getTrailingRequiresClause(CXLambdaExpr LE);

// CXXConstructExpr
CXSourceRange_ clang_CXXConstructExpr_getParenOrBraceRange(CXCXXConstructExpr E);

// CXXTemporaryObjectExpr
CXTypeSourceInfo
clang_CXXTemporaryObjectExpr_getTypeSourceInfo(CXCXXTemporaryObjectExpr E);

// CXXNewExpr
// PRECONDITION: I < getNumPlacementArgs(E) (Clang asserts; the shim does not check)
CXExpr clang_CXXNewExpr_getPlacementArg(CXCXXNewExpr E, unsigned I);

CXSourceRange_ clang_CXXNewExpr_getDirectInitRange(CXCXXNewExpr E);

// Returns an invalid (default-constructed) range unless isParenTypeId()
CXSourceRange_ clang_CXXNewExpr_getTypeIdParens(CXCXXNewExpr E);

// UserDefinedLiteral
// mirrors clang::UserDefinedLiteral::LiteralOperatorKind (class-local enum;
// synced by static_assert in lib/Basic/CXEnumSync.cpp)
typedef enum CXUserDefinedLiteral_LiteralOperatorKind {
  CXUserDefinedLiteral_LOK_Raw,
  CXUserDefinedLiteral_LOK_Template,
  CXUserDefinedLiteral_LOK_Integer,
  CXUserDefinedLiteral_LOK_Floating,
  CXUserDefinedLiteral_LOK_String,
  CXUserDefinedLiteral_LOK_Character
} CXUserDefinedLiteral_LiteralOperatorKind;

CXUserDefinedLiteral_LiteralOperatorKind
clang_UserDefinedLiteral_getLiteralOperatorKind(CXUserDefinedLiteral E);

// PRECONDITION: getLiteralOperatorKind() is neither LOK_Raw nor LOK_Template -
// Clang asserts that and then returns getArg(0) unchecked; the Julia wrapper
// restates it as an @assert.
CXExpr clang_UserDefinedLiteral_getCookedLiteral(CXUserDefinedLiteral E);

// The ud-suffix identifier, reached through cast<FunctionDecl>(getCalleeDecl());
// that holds by construction for a UserDefinedLiteral node.
CXIdentifierInfo clang_UserDefinedLiteral_getUDSuffix(CXUserDefinedLiteral E);

// CXXRewrittenBinaryOperator
// getOpcode/getLHS/getRHS all route through getDecomposedForm(), which re-derives
// the written form from the rewritten semantic form.
CXExpr clang_CXXRewrittenBinaryOperator_getSemanticForm(CXCXXRewrittenBinaryOperator E);

CXBinaryOperatorKind
clang_CXXRewrittenBinaryOperator_getOpcode(CXCXXRewrittenBinaryOperator E);

CXExpr clang_CXXRewrittenBinaryOperator_getLHS(CXCXXRewrittenBinaryOperator E);

CXExpr clang_CXXRewrittenBinaryOperator_getRHS(CXCXXRewrittenBinaryOperator E);

bool clang_CXXRewrittenBinaryOperator_isReversed(CXCXXRewrittenBinaryOperator E);

// CXXStdInitializerListExpr
CXExpr clang_CXXStdInitializerListExpr_getSubExpr(CXCXXStdInitializerListExpr E);

// CXXScalarValueInitExpr
CXTypeSourceInfo clang_CXXScalarValueInitExpr_getTypeSourceInfo(CXCXXScalarValueInitExpr E);

CXSourceLocation_ clang_CXXScalarValueInitExpr_getRParenLoc(CXCXXScalarValueInitExpr E);

// CXXNullPtrLiteralExpr
CXSourceLocation_ clang_CXXNullPtrLiteralExpr_getLocation(CXCXXNullPtrLiteralExpr E);

// CXXInheritedCtorInitExpr
CXCXXConstructorDecl
clang_CXXInheritedCtorInitExpr_getConstructor(CXCXXInheritedCtorInitExpr E);

bool clang_CXXInheritedCtorInitExpr_constructsVBase(CXCXXInheritedCtorInitExpr E);

// Derived from constructsVBase(): VirtualBase when it is set, NonVirtualBase
// otherwise. An inheriting constructor never constructs a complete object.
CXCXXConstructionKind
clang_CXXInheritedCtorInitExpr_getConstructionKind(CXCXXInheritedCtorInitExpr E);

bool clang_CXXInheritedCtorInitExpr_inheritedFromVBase(CXCXXInheritedCtorInitExpr E);

CXSourceLocation_ clang_CXXInheritedCtorInitExpr_getLocation(CXCXXInheritedCtorInitExpr E);

// CoroutineSuspendExpr (base of CoawaitExpr and CoyieldExpr)
CXExpr clang_CoroutineSuspendExpr_getCommonExpr(CXCoroutineSuspendExpr E);

CXExpr clang_CoroutineSuspendExpr_getReadyExpr(CXCoroutineSuspendExpr E);

CXExpr clang_CoroutineSuspendExpr_getSuspendExpr(CXCoroutineSuspendExpr E);

CXExpr clang_CoroutineSuspendExpr_getResumeExpr(CXCoroutineSuspendExpr E);

// The syntactic operand written in the source (the `X` of `co_await X`)
CXExpr clang_CoroutineSuspendExpr_getOperand(CXCoroutineSuspendExpr E);

CXSourceLocation_ clang_CoroutineSuspendExpr_getKeywordLoc(CXCoroutineSuspendExpr E);

// CXXNoexceptExpr
CXExpr clang_CXXNoexceptExpr_getOperand(CXCXXNoexceptExpr E);

bool clang_CXXNoexceptExpr_getValue(CXCXXNoexceptExpr E);

// CXXPseudoDestructorExpr
CXExpr clang_CXXPseudoDestructorExpr_getBase(CXCXXPseudoDestructorExpr E);

bool clang_CXXPseudoDestructorExpr_hasQualifier(CXCXXPseudoDestructorExpr E);

// NULL when hasQualifier() is false - the destructor name carried no
// nested-name-specifier.
CXNestedNameSpecifier
clang_CXXPseudoDestructorExpr_getQualifier(CXCXXPseudoDestructorExpr E);

bool clang_CXXPseudoDestructorExpr_isArrow(CXCXXPseudoDestructorExpr E);

CXSourceLocation_ clang_CXXPseudoDestructorExpr_getOperatorLoc(CXCXXPseudoDestructorExpr E);

// The extra qualification of a `p->T::~T()` form: a scalar T cannot be part of a
// nested-name-specifier, so it is stored here instead. NULL when the destructor
// name was written without one.
CXTypeSourceInfo
clang_CXXPseudoDestructorExpr_getScopeTypeInfo(CXCXXPseudoDestructorExpr E);

// Invalid when the pseudo-destructor name carries no `::`.
CXSourceLocation_
clang_CXXPseudoDestructorExpr_getColonColonLoc(CXCXXPseudoDestructorExpr E);

CXSourceLocation_ clang_CXXPseudoDestructorExpr_getTildeLoc(CXCXXPseudoDestructorExpr E);

// The destroyed type's source information. The storage is a PointerUnion of this
// and the identifier below, so at most one of the two is non-NULL: a resolved
// destructor name yields the TypeSourceInfo, an unresolved dependent one the
// identifier.
CXTypeSourceInfo
clang_CXXPseudoDestructorExpr_getDestroyedTypeInfo(CXCXXPseudoDestructorExpr E);

// The written name of a dependent destroyed type that could not be resolved;
// NULL once the type resolved (see getDestroyedTypeInfo above).
CXIdentifierInfo
clang_CXXPseudoDestructorExpr_getDestroyedTypeIdentifier(CXCXXPseudoDestructorExpr E);

// getDestroyedType() is out-of-line; a dependent destructor name yields a null QualType.
CXQualType clang_CXXPseudoDestructorExpr_getDestroyedType(CXCXXPseudoDestructorExpr E);

CXSourceLocation_
clang_CXXPseudoDestructorExpr_getDestroyedTypeLoc(CXCXXPseudoDestructorExpr E);

// CXXUnresolvedConstructExpr
CXQualType
clang_CXXUnresolvedConstructExpr_getTypeAsWritten(CXCXXUnresolvedConstructExpr E);

CXSourceLocation_
clang_CXXUnresolvedConstructExpr_getLParenLoc(CXCXXUnresolvedConstructExpr E);

CXSourceLocation_
clang_CXXUnresolvedConstructExpr_getRParenLoc(CXCXXUnresolvedConstructExpr E);

bool clang_CXXUnresolvedConstructExpr_isListInitialization(CXCXXUnresolvedConstructExpr E);

unsigned clang_CXXUnresolvedConstructExpr_getNumArgs(CXCXXUnresolvedConstructExpr E);

// PRECONDITION: I < getNumArgs() - Clang asserts, then indexes the trailing arg
// array unchecked.
CXExpr clang_CXXUnresolvedConstructExpr_getArg(CXCXXUnresolvedConstructExpr E, unsigned I);

// PackExpansionExpr
CXExpr clang_PackExpansionExpr_getPattern(CXPackExpansionExpr E);

CXSourceLocation_ clang_PackExpansionExpr_getEllipsisLoc(CXPackExpansionExpr E);

// DependentScopeDeclRefExpr
CXSourceLocation_
clang_DependentScopeDeclRefExpr_getLocation(CXDependentScopeDeclRefExpr E);

bool clang_DependentScopeDeclRefExpr_hasTemplateKeyword(CXDependentScopeDeclRefExpr E);

bool clang_DependentScopeDeclRefExpr_hasExplicitTemplateArgs(CXDependentScopeDeclRefExpr E);

unsigned clang_DependentScopeDeclRefExpr_getNumTemplateArgs(CXDependentScopeDeclRefExpr E);

// OverloadExpr (base of UnresolvedLookupExpr and UnresolvedMemberExpr)
// getNamingClass dispatches to the concrete subclass; NULL for an unqualified
// lookup that names no class (e.g. a free-function overload set).
CXCXXRecordDecl clang_OverloadExpr_getNamingClass(CXOverloadExpr E);

unsigned clang_OverloadExpr_getNumDecls(CXOverloadExpr E);

CXDeclarationName clang_OverloadExpr_getName(CXOverloadExpr E);

CXSourceLocation_ clang_OverloadExpr_getNameLoc(CXOverloadExpr E);

// NULL when the name carried no nested-name qualifier
CXNestedNameSpecifier clang_OverloadExpr_getQualifier(CXOverloadExpr E);

CXSourceLocation_ clang_OverloadExpr_getTemplateKeywordLoc(CXOverloadExpr E);

CXSourceLocation_ clang_OverloadExpr_getLAngleLoc(CXOverloadExpr E);

CXSourceLocation_ clang_OverloadExpr_getRAngleLoc(CXOverloadExpr E);

bool clang_OverloadExpr_hasTemplateKeyword(CXOverloadExpr E);

bool clang_OverloadExpr_hasExplicitTemplateArgs(CXOverloadExpr E);

unsigned clang_OverloadExpr_getNumTemplateArgs(CXOverloadExpr E);

// UnresolvedLookupExpr
bool clang_UnresolvedLookupExpr_requiresADL(CXUnresolvedLookupExpr E);

bool clang_UnresolvedLookupExpr_isOverloaded(CXUnresolvedLookupExpr E);

// UnresolvedMemberExpr
bool clang_UnresolvedMemberExpr_isImplicitAccess(CXUnresolvedMemberExpr E);

// PRECONDITION: !isImplicitAccess() - getBase() asserts, then cast<Expr>(Base);
// the Julia wrapper restates this as an @assert.
CXExpr clang_UnresolvedMemberExpr_getBase(CXUnresolvedMemberExpr E);

CXQualType clang_UnresolvedMemberExpr_getBaseType(CXUnresolvedMemberExpr E);

bool clang_UnresolvedMemberExpr_hasUnresolvedUsing(CXUnresolvedMemberExpr E);

bool clang_UnresolvedMemberExpr_isArrow(CXUnresolvedMemberExpr E);

CXSourceLocation_ clang_UnresolvedMemberExpr_getOperatorLoc(CXUnresolvedMemberExpr E);

// CXXDynamicCastExpr
// Whether the cast provably evaluates to a null pointer (the destination class
// is not reachable from the source class).
bool clang_CXXDynamicCastExpr_isAlwaysNull(CXCXXDynamicCastExpr E);

// CXXDefaultArgExpr
bool clang_CXXDefaultArgExpr_hasRewrittenInit(CXCXXDefaultArgExpr E);

// NULL unless hasRewrittenInit() - a rewritten initializer only exists for a
// default argument that contains immediate (consteval) calls. The accessor is
// itself total: it returns nullptr when the trailing storage is absent.
CXExpr clang_CXXDefaultArgExpr_getRewrittenExpr(CXCXXDefaultArgExpr E);

// The context the default argument was used in. This is a DeclContext handle,
// not a Decl one - cross back with clang_Decl_castFromDeclContext.
CXDeclContext clang_CXXDefaultArgExpr_getUsedContext(CXCXXDefaultArgExpr E);

// CXXDefaultInitExpr
bool clang_CXXDefaultInitExpr_hasRewrittenInit(CXCXXDefaultInitExpr E);

// PRECONDITION: hasRewrittenInit() - Clang asserts and then dereferences the
// trailing Expr* storage unchecked; the Julia wrapper restates this as an
// @assert.
CXExpr clang_CXXDefaultInitExpr_getRewrittenExpr(CXCXXDefaultInitExpr E);

// The context the default member initializer was used in. A DeclContext handle,
// not a Decl one.
CXDeclContext clang_CXXDefaultInitExpr_getUsedContext(CXCXXDefaultInitExpr E);

// CXXBindTemporaryExpr
// Borrowed interior pointer into ASTContext-arena memory; do not dispose.
CXCXXTemporary clang_CXXBindTemporaryExpr_getTemporary(CXCXXBindTemporaryExpr E);

// CXXTemporary
CXCXXDestructorDecl clang_CXXTemporary_getDestructor(CXCXXTemporary T);

// CXXFunctionalCastExpr
// Invalid when the cast models list-initialization (`T{...}` writes no parens).
CXSourceLocation_ clang_CXXFunctionalCastExpr_getLParenLoc(CXCXXFunctionalCastExpr E);

CXSourceLocation_ clang_CXXFunctionalCastExpr_getRParenLoc(CXCXXFunctionalCastExpr E);

bool clang_CXXFunctionalCastExpr_isListInitialization(CXCXXFunctionalCastExpr E);

// MaterializeTemporaryExpr
CXStorageDuration
clang_MaterializeTemporaryExpr_getStorageDuration(CXMaterializeTemporaryExpr E);

// ArrayTypeTraitExpr
CXArrayTypeTrait clang_ArrayTypeTraitExpr_getTrait(CXArrayTypeTraitExpr E);

// Dereferences the queried TypeSourceInfo, which every parsed node carries (it
// is filled in by the constructor; only a deserialization EmptyShell leaves it
// null, and such a node is never handed out).
CXQualType clang_ArrayTypeTraitExpr_getQueriedType(CXArrayTypeTraitExpr E);

// PRECONDITION: !isTypeDependent() - Clang asserts, and the stored value is
// unspecified in a dependent context; the Julia wrapper restates this as an
// @assert.
uint64_t clang_ArrayTypeTraitExpr_getValue(CXArrayTypeTraitExpr E);

// NULL for a trait that takes no dimension operand (__array_rank).
CXExpr clang_ArrayTypeTraitExpr_getDimensionExpression(CXArrayTypeTraitExpr E);

// ExpressionTraitExpr
CXExpressionTrait clang_ExpressionTraitExpr_getTrait(CXExpressionTraitExpr E);

CXExpr clang_ExpressionTraitExpr_getQueriedExpression(CXExpressionTraitExpr E);

bool clang_ExpressionTraitExpr_getValue(CXExpressionTraitExpr E);

// SubstNonTypeTemplateParmExpr
CXSourceLocation_
clang_SubstNonTypeTemplateParmExpr_getNameLoc(CXSubstNonTypeTemplateParmExpr E);

CXExpr clang_SubstNonTypeTemplateParmExpr_getReplacement(CXSubstNonTypeTemplateParmExpr E);

// The template-like entity that owns the whole substituted pattern; never NULL
// (the constructor asserts it).
CXDecl
clang_SubstNonTypeTemplateParmExpr_getAssociatedDecl(CXSubstNonTypeTemplateParmExpr E);

unsigned clang_SubstNonTypeTemplateParmExpr_getIndex(CXSubstNonTypeTemplateParmExpr E);

// SubstNonTypeTemplateParmExpr::getPackIndex is optional<unsigned>: engaged ->
// fills *I and returns true; disengaged -> returns false, *I untouched.
bool clang_SubstNonTypeTemplateParmExpr_getPackIndex(CXSubstNonTypeTemplateParmExpr E,
                                                     unsigned *I);

// Out-of-line: indexes the associated declaration's replaced template parameter
// list with getIndex() and cast<>s the result. Total for any node the parser or
// the template instantiator built.
CXNonTypeTemplateParmDecl
clang_SubstNonTypeTemplateParmExpr_getParameter(CXSubstNonTypeTemplateParmExpr E);

bool clang_SubstNonTypeTemplateParmExpr_isReferenceParameter(
    CXSubstNonTypeTemplateParmExpr E);

CXQualType
clang_SubstNonTypeTemplateParmExpr_getParameterType(CXSubstNonTypeTemplateParmExpr E,
                                                    CXASTContext Ctx);

// CXXOperatorCallExpr
// Whether the call was written as an infix binary operator (`a + b`) rather than
// in call, subscript or unary form.
bool clang_CXXOperatorCallExpr_isInfixBinaryOp(CXCXXOperatorCallExpr OCE);

// CXXRewrittenBinaryOperator
// Constant on this class: a rewritten operator is always a comparison and never
// an assignment. Mirrors the CXXOperatorCallExpr pair.
bool clang_CXXRewrittenBinaryOperator_isComparisonOp(CXCXXRewrittenBinaryOperator E);

bool clang_CXXRewrittenBinaryOperator_isAssignmentOp(CXCXXRewrittenBinaryOperator E);

// Routes through getDecomposedForm(): the location of the inner `==` / `<=>` the
// rewrite was built from.
CXSourceLocation_
clang_CXXRewrittenBinaryOperator_getOperatorLoc(CXCXXRewrittenBinaryOperator E);

// UserDefinedLiteral
// A string literal may carry several identical ud-suffixes; this is the first.
CXSourceLocation_ clang_UserDefinedLiteral_getUDSuffixLoc(CXUserDefinedLiteral E);

// CXXDefaultArgExpr
// PRECONDITION: hasRewrittenInit() - only a default argument holding immediate
// (consteval) calls has a rewritten form; the Julia wrapper restates this as an
// @assert.
CXExpr clang_CXXDefaultArgExpr_getAdjustedRewrittenExpr(CXCXXDefaultArgExpr E);

// The location the default argument was used at (the call site); the node itself
// has an empty source range.
CXSourceLocation_ clang_CXXDefaultArgExpr_getUsedLocation(CXCXXDefaultArgExpr E);

// CXXDefaultInitExpr
CXSourceLocation_ clang_CXXDefaultInitExpr_getUsedLocation(CXCXXDefaultInitExpr E);

// ArrayTypeTraitExpr
CXTypeSourceInfo clang_ArrayTypeTraitExpr_getQueriedTypeSourceInfo(CXArrayTypeTraitExpr E);

// CXXUnresolvedConstructExpr
CXTypeSourceInfo
clang_CXXUnresolvedConstructExpr_getTypeSourceInfo(CXCXXUnresolvedConstructExpr E);

// PackExpansionExpr
// PackExpansionExpr::getNumExpansions is optional<unsigned>: engaged -> fills *N
// and returns true; disengaged (the count is not known yet) -> returns false with
// *N untouched.
bool clang_PackExpansionExpr_getNumExpansions(CXPackExpansionExpr E, unsigned *N);

// MaterializeTemporaryExpr
// NULL unless the temporary was lifetime-extended - the state is a PointerUnion
// of the plain sub-expression and this decl.
CXLifetimeExtendedTemporaryDecl
clang_MaterializeTemporaryExpr_getLifetimeExtendedTemporaryDecl(
    CXMaterializeTemporaryExpr E);

// PRECONDITION: getLifetimeExtendedTemporaryDecl() is non-NULL - Clang asserts
// the state holds that decl and then reads it unchecked; the Julia wrapper
// restates this as an @assert. The returned APValue is borrowed (owned by the
// extended-temporary decl), so it is never disposed; it is NULL when MayCreate is
// false and no value has been cached yet.
CXAPValue clang_MaterializeTemporaryExpr_getOrCreateValue(CXMaterializeTemporaryExpr E,
                                                          bool MayCreate);

bool clang_MaterializeTemporaryExpr_isUsableInConstantExpressions(
    CXMaterializeTemporaryExpr E, CXASTContext Ctx);

// CXXFoldExpr
// Same optional<unsigned> protocol as clang_PackExpansionExpr_getNumExpansions.
bool clang_CXXFoldExpr_getNumExpansions(CXCXXFoldExpr E, unsigned *N);

// CoroutineSuspendExpr
// The placeholder standing for the awaited operand inside the ready/suspend/
// resume sub-expressions; NULL for a dependent (uninstantiated) node.
CXOpaqueValueExpr clang_CoroutineSuspendExpr_getOpaqueValue(CXCoroutineSuspendExpr E);

// CoawaitExpr
// Whether the co_await was inserted by the compiler (a coroutine's initial and
// final suspend points) rather than written in the source.
bool clang_CoawaitExpr_isImplicit(CXCoawaitExpr E);

// DependentCoawaitExpr
CXExpr clang_DependentCoawaitExpr_getOperand(CXDependentCoawaitExpr E);

// The `operator co_await` overload set carried next to the operand; reached
// through cast<UnresolvedLookupExpr>, which holds for every node Sema builds.
CXUnresolvedLookupExpr
clang_DependentCoawaitExpr_getOperatorCoawaitLookup(CXDependentCoawaitExpr E);

CXSourceLocation_ clang_DependentCoawaitExpr_getKeywordLoc(CXDependentCoawaitExpr E);

// CXXDependentScopeMemberExpr
// True when no base object was written in the source (the implicit-`this` form);
// the operator location is invalid in that case.
bool clang_CXXDependentScopeMemberExpr_isImplicitAccess(CXCXXDependentScopeMemberExpr E);

// PRECONDITION: !isImplicitAccess() - Clang asserts, then cast<Expr>(Base); the
// Julia wrapper restates this as an @assert.
CXExpr clang_CXXDependentScopeMemberExpr_getBase(CXCXXDependentScopeMemberExpr E);

// The type of the base object; valid even for an implicit access.
CXQualType clang_CXXDependentScopeMemberExpr_getBaseType(CXCXXDependentScopeMemberExpr E);

bool clang_CXXDependentScopeMemberExpr_isArrow(CXCXXDependentScopeMemberExpr E);

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getOperatorLoc(CXCXXDependentScopeMemberExpr E);

// NULL when the member name carried no nested-name qualifier.
CXNestedNameSpecifier
clang_CXXDependentScopeMemberExpr_getQualifier(CXCXXDependentScopeMemberExpr E);

// What unqualified lookup found for the first component of the qualifier of an
// `x.Base::f` access; NULL when the node stores no such declaration.
CXNamedDecl clang_CXXDependentScopeMemberExpr_getFirstQualifierFoundInScope(
    CXCXXDependentScopeMemberExpr E);

CXDeclarationName
clang_CXXDependentScopeMemberExpr_getMember(CXCXXDependentScopeMemberExpr E);

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getMemberLoc(CXCXXDependentScopeMemberExpr E);

// Invalid unless the member name was preceded by the `template` keyword.
CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getTemplateKeywordLoc(CXCXXDependentScopeMemberExpr E);

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getLAngleLoc(CXCXXDependentScopeMemberExpr E);

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getRAngleLoc(CXCXXDependentScopeMemberExpr E);

bool clang_CXXDependentScopeMemberExpr_hasTemplateKeyword(CXCXXDependentScopeMemberExpr E);

bool clang_CXXDependentScopeMemberExpr_hasExplicitTemplateArgs(
    CXCXXDependentScopeMemberExpr E);

unsigned
clang_CXXDependentScopeMemberExpr_getNumTemplateArgs(CXCXXDependentScopeMemberExpr E);

// DependentScopeDeclRefExpr
CXDeclarationName
clang_DependentScopeDeclRefExpr_getDeclName(CXDependentScopeDeclRefExpr E);

// Never NULL: a DependentScopeDeclRefExpr only exists for a qualified name.
CXNestedNameSpecifier
clang_DependentScopeDeclRefExpr_getQualifier(CXDependentScopeDeclRefExpr E);

// Invalid unless the name was preceded by the `template` keyword.
CXSourceLocation_
clang_DependentScopeDeclRefExpr_getTemplateKeywordLoc(CXDependentScopeDeclRefExpr E);

CXSourceLocation_
clang_DependentScopeDeclRefExpr_getLAngleLoc(CXDependentScopeDeclRefExpr E);

CXSourceLocation_
clang_DependentScopeDeclRefExpr_getRAngleLoc(CXDependentScopeDeclRefExpr E);

// CXXConstructExpr
void clang_CXXConstructExpr_setLocation(CXCXXConstructExpr E, CXSourceLocation_ Loc);

void clang_CXXConstructExpr_setElidable(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setHadMultipleCandidates(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setListInitialization(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setStdInitListInitialization(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setRequiresZeroInitialization(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setConstructionKind(CXCXXConstructExpr E,
                                                CXCXXConstructionKind CK);

// PRECONDITION: Arg < getNumArgs(E) - Clang asserts, then writes the trailing
// argument array unchecked; the Julia wrapper restates this as an @assert.
void clang_CXXConstructExpr_setArg(CXCXXConstructExpr E, unsigned Arg, CXExpr ArgExpr);

void clang_CXXConstructExpr_setIsImmediateEscalating(CXCXXConstructExpr E, bool V);

void clang_CXXConstructExpr_setParenOrBraceRange(CXCXXConstructExpr E, CXSourceRange_ R);

// CXXThisExpr
void clang_CXXThisExpr_setLocation(CXCXXThisExpr E, CXSourceLocation_ Loc);

void clang_CXXThisExpr_setImplicit(CXCXXThisExpr E, bool V);

// CXXBoolLiteralExpr
void clang_CXXBoolLiteralExpr_setValue(CXCXXBoolLiteralExpr E, bool V);

void clang_CXXBoolLiteralExpr_setLocation(CXCXXBoolLiteralExpr E, CXSourceLocation_ Loc);

// CXXNullPtrLiteralExpr
void clang_CXXNullPtrLiteralExpr_setLocation(CXCXXNullPtrLiteralExpr E,
                                             CXSourceLocation_ Loc);

// OverloadExpr
// Indexed form of OverloadExpr::decls_begin(); decls_iterator is a random-access
// UnresolvedSetIterator over the trailing DeclAccessPair array, so this is the
// count+index shape of the decls() range (getNumDecls is the count).
// PRECONDITION: I < getNumDecls(E) - the shim does no bounds check.
CXNamedDecl clang_OverloadExpr_getDecl(CXOverloadExpr E, unsigned I);

// helper - the access the I-th lookup result was found with (AS_none for a
// namespace-scope overload set). Same precondition as clang_OverloadExpr_getDecl.
CXAccessSpecifier clang_OverloadExpr_getDeclAccess(CXOverloadExpr E, unsigned I);

// The I-th explicit template argument; the TemplateArgumentLoc is AST-owned and
// borrowed, never disposed. PRECONDITION: I < getNumTemplateArgs(E) -
// getTemplateArgs() returns NULL when the name carried no explicit template
// argument list, so any index is out of range then.
CXTemplateArgumentLoc clang_OverloadExpr_getTemplateArg(CXOverloadExpr E, unsigned I);

// CXXDependentScopeMemberExpr
// Same borrowed storage and bounds precondition as clang_OverloadExpr_getTemplateArg.
CXTemplateArgumentLoc
clang_CXXDependentScopeMemberExpr_getTemplateArg(CXCXXDependentScopeMemberExpr E,
                                                 unsigned I);

// DependentScopeDeclRefExpr
// Same borrowed storage and bounds precondition as clang_OverloadExpr_getTemplateArg.
CXTemplateArgumentLoc
clang_DependentScopeDeclRefExpr_getTemplateArg(CXDependentScopeDeclRefExpr E, unsigned I);

LLVM_CLANG_C_EXTERN_C_END

#endif
