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

void clang_CXXUnresolvedConstructExpr_setLParenLoc(CXCXXUnresolvedConstructExpr E,
                                                   CXSourceLocation_ Loc);

void clang_CXXUnresolvedConstructExpr_setRParenLoc(CXCXXUnresolvedConstructExpr E,
                                                   CXSourceLocation_ Loc);

// PRECONDITION: I < getNumArgs() - Clang asserts, then writes into the trailing arg
// array unchecked.
void clang_CXXUnresolvedConstructExpr_setArg(CXCXXUnresolvedConstructExpr E, unsigned I,
                                             CXExpr Arg);

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

// CXXRewrittenBinaryOperator
// The spelling of the operator as *written* ("!=" for a `a != b` rewritten into
// `!(a == b)`), not the spelling of the rewritten semantic form. Borrowed static
// storage owned by BinaryOperator::getOpcodeStr; never freed.
const char *clang_CXXRewrittenBinaryOperator_getOpcodeStr(CXCXXRewrittenBinaryOperator E);

// MSPropertyRefExpr
// A `__declspec(property)` member reference (MS extension); it is the syntactic form
// of the enclosing PseudoObjectExpr, so it is reached by walking children.
bool clang_MSPropertyRefExpr_isImplicitAccess(CXMSPropertyRefExpr E);

// The object expression the property is named on; NULL when the reference carries no
// base expression at all.
CXExpr clang_MSPropertyRefExpr_getBaseExpr(CXMSPropertyRefExpr E);

CXMSPropertyDecl clang_MSPropertyRefExpr_getPropertyDecl(CXMSPropertyRefExpr E);

bool clang_MSPropertyRefExpr_isArrow(CXMSPropertyRefExpr E);

CXSourceLocation_ clang_MSPropertyRefExpr_getMemberLoc(CXMSPropertyRefExpr E);

// MSPropertySubscriptExpr
// The subscripted expression: an MSPropertyRefExpr, or a nested
// MSPropertySubscriptExpr for a multi-dimensional property.
CXExpr clang_MSPropertySubscriptExpr_getBase(CXMSPropertySubscriptExpr E);

CXExpr clang_MSPropertySubscriptExpr_getIdx(CXMSPropertySubscriptExpr E);

CXSourceLocation_ clang_MSPropertySubscriptExpr_getRBracketLoc(CXMSPropertySubscriptExpr E);

void clang_MSPropertySubscriptExpr_setRBracketLoc(CXMSPropertySubscriptExpr E,
                                                  CXSourceLocation_ Loc);

// CXXParenListInitExpr
// count+index shape of the getInitExprs() ArrayRef - every initializer, including the
// ones the compiler filled in from default member initializers.
unsigned clang_CXXParenListInitExpr_getNumInitExprs(CXCXXParenListInitExpr E);

// PRECONDITION: I < getNumInitExprs(E) - the shim does no bounds check.
CXExpr clang_CXXParenListInitExpr_getInitExpr(CXCXXParenListInitExpr E, unsigned I);

// count+index shape of the getUserSpecifiedInitExprs() ArrayRef - the leading
// initializers actually written in the parenthesized list.
unsigned clang_CXXParenListInitExpr_getNumUserSpecifiedInitExprs(CXCXXParenListInitExpr E);

// PRECONDITION: I < getNumUserSpecifiedInitExprs(E) - the shim does no bounds check.
CXExpr clang_CXXParenListInitExpr_getUserSpecifiedInitExpr(CXCXXParenListInitExpr E,
                                                           unsigned I);

CXSourceLocation_ clang_CXXParenListInitExpr_getInitLoc(CXCXXParenListInitExpr E);

// One arm of the ArrayFillerOrUnionFieldInit PointerUnion, read with dyn_cast: NULL
// when the union holds the other arm or is empty.
CXExpr clang_CXXParenListInitExpr_getArrayFiller(CXCXXParenListInitExpr E);

// The other arm of that same PointerUnion, same dyn_cast discriminator.
CXFieldDecl clang_CXXParenListInitExpr_getInitializedFieldInUnion(CXCXXParenListInitExpr E);

// CXXTypeidExpr (cont.)
void clang_CXXTypeidExpr_setSourceRange(CXCXXTypeidExpr E, CXSourceRange_ R);

// CXXUuidofExpr
// The `__uuidof(...)` MS extension (needs -fms-extensions and a declared _GUID).
// Its operand is a PointerUnion of an Expr and a TypeSourceInfo discriminated by
// isTypeOperand - the same shape CXXTypeidExpr uses.
bool clang_CXXUuidofExpr_isTypeOperand(CXCXXUuidofExpr E);

// PRECONDITION: isTypeOperand() - Clang asserts and then reads the type arm of the
// operand PointerUnion; the Julia wrapper restates this as an @assert.
CXQualType clang_CXXUuidofExpr_getTypeOperand(CXCXXUuidofExpr E, CXASTContext Ctx);

// PRECONDITION: isTypeOperand() - Clang asserts and then reads the operand
// PointerUnion unchecked; the Julia wrapper restates this as an @assert.
CXTypeSourceInfo clang_CXXUuidofExpr_getTypeOperandSourceInfo(CXCXXUuidofExpr E);

// PRECONDITION: !isTypeOperand() - same unchecked PointerUnion read.
CXExpr clang_CXXUuidofExpr_getExprOperand(CXCXXUuidofExpr E);

// The MSGuidDecl the operand's uuid attribute resolved to; NULL when the operand
// type carried no uuid attribute.
CXMSGuidDecl clang_CXXUuidofExpr_getGuidDecl(CXCXXUuidofExpr E);

void clang_CXXUuidofExpr_setSourceRange(CXCXXUuidofExpr E, CXSourceRange_ R);

// CXXThisExpr (cont.)
// Arena-allocated in the ASTContext; there is no dispose.
CXCXXThisExpr clang_CXXThisExpr_Create(CXASTContext Ctx, CXSourceLocation_ L, CXQualType Ty,
                                       bool IsImplicit);

// An empty shell for a deserializer to fill in: every CXXThisExpr payload accessor
// reads uninitialized storage until it does. Arena-allocated, no dispose.
CXCXXThisExpr clang_CXXThisExpr_CreateEmpty(CXASTContext Ctx);

// CXXTemporary (cont.)
// Arena-allocated in the ASTContext; there is no dispose.
CXCXXTemporary clang_CXXTemporary_Create(CXASTContext Ctx, CXCXXDestructorDecl Destructor);

void clang_CXXTemporary_setDestructor(CXCXXTemporary T, CXCXXDestructorDecl Dtor);

// CXXBindTemporaryExpr (cont.)
void clang_CXXBindTemporaryExpr_setTemporary(CXCXXBindTemporaryExpr E, CXCXXTemporary T);

void clang_CXXBindTemporaryExpr_setSubExpr(CXCXXBindTemporaryExpr E, CXExpr Sub);

// CXXFunctionalCastExpr (cont.)
// isListInitialization() is `getLParenLoc().isInvalid()`, so this setter also decides
// how the cast reports its initialization form.
void clang_CXXFunctionalCastExpr_setLParenLoc(CXCXXFunctionalCastExpr E,
                                              CXSourceLocation_ L);

void clang_CXXFunctionalCastExpr_setRParenLoc(CXCXXFunctionalCastExpr E,
                                              CXSourceLocation_ L);

// CXXNewExpr (cont.)
void clang_CXXNewExpr_setOperatorNew(CXCXXNewExpr NE, CXFunctionDecl D);

void clang_CXXNewExpr_setOperatorDelete(CXCXXNewExpr NE, CXFunctionDecl D);

// CXXParenListInitExpr (cont.)
// Writes the array-filler arm of the ArrayFillerOrUnionFieldInit PointerUnion,
// disengaging the union-field arm if that one was engaged.
void clang_CXXParenListInitExpr_setArrayFiller(CXCXXParenListInitExpr E, CXExpr Filler);

// Writes the union-field arm of that same PointerUnion, disengaging the array-filler
// arm if that one was engaged.
void clang_CXXParenListInitExpr_setInitializedFieldInUnion(CXCXXParenListInitExpr E,
                                                           CXFieldDecl FD);

// CXXRewrittenBinaryOperator (cont.)
// The inner `==` or `<=>` operator expression of the decomposed form. A
// DecomposedForm crosses as its parts (MARSHALLING.md section 7): the original
// opcode through getOpcode, the original operands through getLHS/getRHS, and the
// inner operator here.
CXExpr clang_CXXRewrittenBinaryOperator_getInnerBinOp(CXCXXRewrittenBinaryOperator E);

// CXXConstCastExpr
// Build a `const_cast<T>(Op)` node in Ctx's arena. The written destination type
// comes in as a TypeSourceInfo, the `<...>` extent as AngleBrackets. The node is
// arena-allocated: there is no dispose.
CXCXXConstCastExpr
clang_CXXConstCastExpr_Create(CXASTContext Ctx, CXQualType T, CXExprValueKind VK, CXExpr Op,
                              CXTypeSourceInfo WrittenTy, CXSourceLocation_ L,
                              CXSourceLocation_ RParenLoc, CXSourceRange_ AngleBrackets);

// CXXBoolLiteralExpr (cont.)
// Build a `true`/`false` literal of type Ty in C's arena. Arena-allocated: there
// is no dispose.
CXCXXBoolLiteralExpr clang_CXXBoolLiteralExpr_Create(CXASTContext C, bool Val,
                                                     CXQualType Ty, CXSourceLocation_ Loc);

// MSPropertyRefExpr (cont.)
// The extent of getQualifierLoc(). NestedNameSpecifierLoc has no handle of its
// own, so it crosses as its source range (MARSHALLING.md section 7); this class
// exposes no separate getQualifier. Invalid when the property name was written
// unqualified.
CXSourceRange_ clang_MSPropertyRefExpr_getQualifierRange(CXMSPropertyRefExpr E);

// CXXDefaultArgExpr (cont.)
// Build a use of Param's default argument in C's arena. RewrittenExpr may be NULL;
// a non-NULL one sets hasRewrittenInit(). Arena-allocated: there is no dispose.
// PRECONDITION: Param carries a parsed default argument - the constructor reads
// Param->getDefaultArg()'s type, value kind and object kind unchecked; the Julia
// wrapper restates this as an @assert.
CXCXXDefaultArgExpr clang_CXXDefaultArgExpr_Create(CXASTContext C, CXSourceLocation_ Loc,
                                                   CXParmVarDecl Param,
                                                   CXExpr RewrittenExpr,
                                                   CXDeclContext UsedContext);

// CXXDefaultInitExpr (cont.)
// Build a use of Field's in-class initializer in Ctx's arena. RewrittenInitExpr may
// be NULL; a non-NULL one sets hasRewrittenInit(). Arena-allocated: no dispose.
// PRECONDITION: Field carries an in-class initializer - Clang asserts it in the
// constructor and getExpr() reaches through it unchecked; the Julia wrapper
// restates this as an @assert.
CXCXXDefaultInitExpr
clang_CXXDefaultInitExpr_Create(CXASTContext Ctx, CXSourceLocation_ Loc, CXFieldDecl Field,
                                CXDeclContext UsedContext, CXExpr RewrittenInitExpr);

// CXXBindTemporaryExpr (cont.)
// Bind SubExpr to the temporary record Temp, in C's arena. Arena-allocated: there
// is no dispose.
CXCXXBindTemporaryExpr
clang_CXXBindTemporaryExpr_Create(CXASTContext C, CXCXXTemporary Temp, CXExpr SubExpr);

// LambdaExpr (cont.)
// getExplicitTemplateParameters() as a count + index pair (MARSHALLING.md section
// 6). The count is 0 for a non-generic lambda and for a generic lambda whose
// parameters were all invented by `auto`.
unsigned clang_LambdaExpr_getNumExplicitTemplateParameters(CXLambdaExpr E);

// PRECONDITION: I < getNumExplicitTemplateParameters(E) - the shim indexes the
// ArrayRef unchecked.
CXNamedDecl clang_LambdaExpr_getExplicitTemplateParameter(CXLambdaExpr E, unsigned I);

// CXXPseudoDestructorExpr (cont.)
// The extent of getQualifierLoc(); the source-range companion of getQualifier.
// Invalid when hasQualifier() is false - note that a scalar destroyed type keeps
// its written qualification in the scope type, not in the nested-name-specifier.
CXSourceRange_ clang_CXXPseudoDestructorExpr_getQualifierRange(CXCXXPseudoDestructorExpr E);

// OverloadExpr (cont.)
// The full name-plus-location of the name looked up. Returns an owned box; release
// it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_OverloadExpr_getNameInfo(CXOverloadExpr E);

// The extent of getQualifierLoc(); the source-range companion of getQualifier.
// Invalid when the name was written unqualified.
CXSourceRange_ clang_OverloadExpr_getQualifierRange(CXOverloadExpr E);

// DependentScopeDeclRefExpr (cont.)
// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_DependentScopeDeclRefExpr_getNameInfo(CXDependentScopeDeclRefExpr E);

// The extent of getQualifierLoc(); the source-range companion of getQualifier. The
// `T::` of a dependent reference is always written, so this range is valid.
CXSourceRange_
clang_DependentScopeDeclRefExpr_getQualifierRange(CXDependentScopeDeclRefExpr E);

// CXXDependentScopeMemberExpr (cont.)
// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_CXXDependentScopeMemberExpr_getMemberNameInfo(CXCXXDependentScopeMemberExpr E);

// The extent of getQualifierLoc(); the source-range companion of getQualifier.
// Invalid when the member name was written unqualified.
CXSourceRange_
clang_CXXDependentScopeMemberExpr_getQualifierRange(CXCXXDependentScopeMemberExpr E);

// The getQualifierLoc family. Where the getQualifierRange accessors above flatten the
// location to its outer extent, these hand back the whole NestedNameSpecifierLoc as an
// owned box (MARSHALLING.md section 9), which is the only way to reach the per-component
// locations, the prefix chain and the qualifier's TypeLoc. Every result is OWNED -
// release it with clang_NestedNameSpecifierLoc_dispose - and an unqualified name yields
// an empty box rather than NULL.

// MSPropertyRefExpr (cont.)
CXNestedNameSpecifierLoc clang_MSPropertyRefExpr_getQualifierLoc(CXMSPropertyRefExpr E);

// CXXPseudoDestructorExpr (cont.)
CXNestedNameSpecifierLoc
clang_CXXPseudoDestructorExpr_getQualifierLoc(CXCXXPseudoDestructorExpr E);

// OverloadExpr (cont.)
CXNestedNameSpecifierLoc clang_OverloadExpr_getQualifierLoc(CXOverloadExpr E);

// DependentScopeDeclRefExpr (cont.)
CXNestedNameSpecifierLoc
clang_DependentScopeDeclRefExpr_getQualifierLoc(CXDependentScopeDeclRefExpr E);

// CXXDependentScopeMemberExpr (cont.)
CXNestedNameSpecifierLoc
clang_CXXDependentScopeMemberExpr_getQualifierLoc(CXCXXDependentScopeMemberExpr E);

// CXXStaticCastExpr
// Build a `static_cast<T>(Op)` node in Context's arena. The written destination type
// crosses as a TypeSourceInfo, the `<...>` extent as AngleBrackets, and FPFeatures as the
// FPOptionsOverride opaque integer encoding (MARSHALLING.md section 7) - pass 0 for "no
// override", the only value that leaves hasStoredFPFeatures false. The shim never passes
// an inheritance path, so K must not be one of the base-path cast kinds (CK_DerivedToBase
// and friends), which clang asserts on. Arena-allocated: there is no dispose.
CXCXXStaticCastExpr clang_CXXStaticCastExpr_Create(CXASTContext Context, CXQualType T,
                                                   CXExprValueKind VK, CXCastKind K,
                                                   CXExpr Op, CXTypeSourceInfo Written,
                                                   uint64_t FPFeatures, CXSourceLocation_ L,
                                                   CXSourceLocation_ RParenLoc,
                                                   CXSourceRange_ AngleBrackets);

// The empty shell clang deserializes into: the operand, the written type, the PathSize
// base-specifier slots and the trailing FPOptionsOverride are all left uninitialized, so
// only the node's statement class may be read straight away.
CXCXXStaticCastExpr clang_CXXStaticCastExpr_CreateEmpty(CXASTContext Context,
                                                        unsigned PathSize,
                                                        bool HasFPFeatures);

// CXXDynamicCastExpr
// Build a `dynamic_cast<T>(Op)` node in Context's arena - the same shape as the
// static_cast factory minus the FPOptionsOverride, which this node has no storage for.
// Same empty-path precondition on Kind. Arena-allocated: there is no dispose.
CXCXXDynamicCastExpr clang_CXXDynamicCastExpr_Create(CXASTContext Context, CXQualType T,
                                                     CXExprValueKind VK, CXCastKind Kind,
                                                     CXExpr Op, CXTypeSourceInfo Written,
                                                     CXSourceLocation_ L,
                                                     CXSourceLocation_ RParenLoc,
                                                     CXSourceRange_ AngleBrackets);

// The empty shell clang deserializes into; the same uninitialized payload as
// clang_CXXStaticCastExpr_CreateEmpty, without the FP-features slot.
CXCXXDynamicCastExpr clang_CXXDynamicCastExpr_CreateEmpty(CXASTContext Context,
                                                          unsigned PathSize);

// CXXReinterpretCastExpr
// Build a `reinterpret_cast<T>(Op)` node in Context's arena; same shape and same
// empty-path precondition as the dynamic_cast factory. Arena-allocated: no dispose.
CXCXXReinterpretCastExpr
clang_CXXReinterpretCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                    CXCastKind Kind, CXExpr Op, CXTypeSourceInfo WrittenTy,
                                    CXSourceLocation_ L, CXSourceLocation_ RParenLoc,
                                    CXSourceRange_ AngleBrackets);

// The empty shell clang deserializes into; same uninitialized payload as
// clang_CXXDynamicCastExpr_CreateEmpty.
CXCXXReinterpretCastExpr clang_CXXReinterpretCastExpr_CreateEmpty(CXASTContext Context,
                                                                  unsigned PathSize);

// CXXConstCastExpr (cont.)
// The empty shell clang deserializes into. A const_cast carries neither a base path nor
// FP features, so the shell takes no size arguments; the operand and the written type are
// left uninitialized, and only the node's statement class may be read straight away.
CXCXXConstCastExpr clang_CXXConstCastExpr_CreateEmpty(CXASTContext Context);

// CXXAddrspaceCastExpr
// Build an `addrspace_cast<T>(Op)` node in Context's arena. This cast never carries an
// inheritance path, so clang's factory takes none. Arena-allocated: no dispose.
CXCXXAddrspaceCastExpr
clang_CXXAddrspaceCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                  CXCastKind Kind, CXExpr Op, CXTypeSourceInfo WrittenTy,
                                  CXSourceLocation_ L, CXSourceLocation_ RParenLoc,
                                  CXSourceRange_ AngleBrackets);

// The empty shell clang deserializes into; no base path and no FP features, so no size
// arguments, and the same uninitialized payload as clang_CXXConstCastExpr_CreateEmpty.
CXCXXAddrspaceCastExpr clang_CXXAddrspaceCastExpr_CreateEmpty(CXASTContext Context);

// CXXFunctionalCastExpr (cont.)
// Build a `T(Op)` functional-notation cast in Context's arena. Written is the destination
// type as spelled and FPFeatures the FPOptionsOverride opaque integer encoding (0 for "no
// override"). A valid LPLoc is what tells `T(x)` apart from list-initialization `T{x}`:
// isListInitialization() reads LPLoc.isInvalid(). Same empty-path precondition on Kind.
// Arena-allocated: there is no dispose.
CXCXXFunctionalCastExpr
clang_CXXFunctionalCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                   CXTypeSourceInfo Written, CXCastKind Kind, CXExpr Op,
                                   uint64_t FPFeatures, CXSourceLocation_ LPLoc,
                                   CXSourceLocation_ RPLoc);

// The empty shell clang deserializes into; same uninitialized payload as
// clang_CXXStaticCastExpr_CreateEmpty.
CXCXXFunctionalCastExpr clang_CXXFunctionalCastExpr_CreateEmpty(CXASTContext Context,
                                                                unsigned PathSize,
                                                                bool HasFPFeatures);

// FunctionParmPackExpr
// Build the reference to a function parameter pack (or init-capture pack) that has been
// substituted but not yet expanded, in Context's arena. The Params handles are copied into
// the node's trailing storage, so the buffer need not outlive the call and may be empty.
// Arena-allocated: there is no dispose.
CXFunctionParmPackExpr clang_FunctionParmPackExpr_Create(CXASTContext Context, CXQualType T,
                                                         CXVarDecl ParamPack,
                                                         CXSourceLocation_ NameLoc,
                                                         const CXVarDecl *Params,
                                                         unsigned NumParams);

CXVarDecl clang_FunctionParmPackExpr_getParameterPack(CXFunctionParmPackExpr E);

CXSourceLocation_
clang_FunctionParmPackExpr_getParameterPackLocation(CXFunctionParmPackExpr E);

// getNumExpansions/getExpansion are the count + index pair over the parameters the pack
// expanded into (MARSHALLING.md section 6); the trailing storage is random-access and the
// count is exact, with no null slots.
unsigned clang_FunctionParmPackExpr_getNumExpansions(CXFunctionParmPackExpr E);

// PRECONDITION: I < getNumExpansions(E) - the shim indexes the trailing array unchecked.
CXVarDecl clang_FunctionParmPackExpr_getExpansion(CXFunctionParmPackExpr E, unsigned I);

// SubstNonTypeTemplateParmPackExpr
// Build the reference to a non-type template parameter pack that has been substituted with
// an argument pack but not yet expanded, in Context's arena. The Args handles are copied
// into the context with TemplateArgument::CreatePackCopy, so the caller keeps its own boxes
// and the node's pack storage outlives them; the buffer may be empty. Arena-allocated:
// there is no dispose.
// PRECONDITION: AssociatedDecl is non-NULL - clang's constructor asserts it.
CXSubstNonTypeTemplateParmPackExpr clang_SubstNonTypeTemplateParmPackExpr_Create(
    CXASTContext Context, CXQualType T, CXExprValueKind ValueKind,
    CXSourceLocation_ NameLoc, const CXTemplateArgument *Args, unsigned NumArgs,
    CXDecl AssociatedDecl, unsigned Index);

CXDecl clang_SubstNonTypeTemplateParmPackExpr_getAssociatedDecl(
    CXSubstNonTypeTemplateParmPackExpr E);

unsigned
clang_SubstNonTypeTemplateParmPackExpr_getIndex(CXSubstNonTypeTemplateParmPackExpr E);

// PRECONDITION: getAssociatedDecl() names a template-like entity whose replaced parameter
// list holds a NonTypeTemplateParmDecl at getIndex() - the accessor walks that list and
// cast<>s the entry, both unchecked. Every node the template instantiator builds satisfies
// that; a hand-built one must be given a matching associated declaration and index.
CXNonTypeTemplateParmDecl clang_SubstNonTypeTemplateParmPackExpr_getParameterPack(
    CXSubstNonTypeTemplateParmPackExpr E);

CXSourceLocation_ clang_SubstNonTypeTemplateParmPackExpr_getParameterPackLocation(
    CXSubstNonTypeTemplateParmPackExpr E);

// The substituted argument pack. A TemplateArgument has no pointer form, so it comes back
// heap-boxed and owned: release it with clang_TemplateArgument_dispose. Its elements live
// in the node's arena memory, so the box must not outlive the ASTContext.
CXTemplateArgument clang_SubstNonTypeTemplateParmPackExpr_getArgumentPack(
    CXSubstNonTypeTemplateParmPackExpr E);

// CXXParenListInitExpr (cont.)
// Build a parenthesized aggregate-initialization node `T(a, b, ...)` in C's arena. Args
// holds every initializer, the leading NumUserSpecifiedExprs of which were written in the
// source and the rest filled in from default member initializers; the handles are copied
// into the node's trailing storage, so the buffer need not outlive the call. The node is
// arena-allocated: there is no dispose.
// PRECONDITION: NumUserSpecifiedExprs <= NumArgs - clang asserts it.
CXCXXParenListInitExpr clang_CXXParenListInitExpr_Create(CXASTContext C, const CXExpr *Args,
                                                         unsigned NumArgs, CXQualType T,
                                                         unsigned NumUserSpecifiedExprs,
                                                         CXSourceLocation_ InitLoc,
                                                         CXSourceLocation_ LParenLoc,
                                                         CXSourceLocation_ RParenLoc);

// The empty shell clang deserializes into: NumExprs initializer slots are reserved but left
// uninitialized, so only the node's statement class may be read straight away.
CXCXXParenListInitExpr clang_CXXParenListInitExpr_CreateEmpty(CXASTContext C,
                                                              unsigned NumExprs);

// CXXUnresolvedConstructExpr (cont.)
// Build an unresolved construction `T(a, b, ...)` of the type T in Context's arena. TSI is
// the type as written and IsListInit records a `T{...}` spelling. The Args handles are
// copied into the node's trailing storage, so the buffer need not outlive the call.
// Arena-allocated: there is no dispose.
CXCXXUnresolvedConstructExpr clang_CXXUnresolvedConstructExpr_Create(
    CXASTContext Context, CXQualType T, CXTypeSourceInfo TSI, CXSourceLocation_ LParenLoc,
    const CXExpr *Args, unsigned NumArgs, CXSourceLocation_ RParenLoc, bool IsListInit);

// The empty shell clang deserializes into; the NumArgs argument slots and the written type
// are left uninitialized.
CXCXXUnresolvedConstructExpr
clang_CXXUnresolvedConstructExpr_CreateEmpty(CXASTContext Context, unsigned NumArgs);

// CXXConstructExpr (cont.)
// The empty shell clang deserializes into: NumArgs argument slots are reserved, and the
// constructor, the construction kind and the source ranges behind them are uninitialized,
// so only the node's statement class may be read straight away. No dispose.
CXCXXConstructExpr clang_CXXConstructExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs);

// CXXTemporaryObjectExpr (cont.)
// The empty shell clang deserializes into; the CXXConstructExpr payload plus the written
// type are left uninitialized.
CXCXXTemporaryObjectExpr clang_CXXTemporaryObjectExpr_CreateEmpty(CXASTContext Ctx,
                                                                  unsigned NumArgs);

// CXXNewExpr (cont.)
// The empty shell clang deserializes into. The flags size the trailing storage - an array
// size slot, an initializer slot, NumPlacementArgs placement-argument slots and a
// parenthesized-type-id source range - and the payload behind them is uninitialized.
CXCXXNewExpr clang_CXXNewExpr_CreateEmpty(CXASTContext Ctx, bool IsArray, bool HasInit,
                                          unsigned NumPlacementArgs, bool IsParenTypeId);

// CXXDefaultArgExpr (cont.)
// The empty shell clang deserializes into; HasRewrittenInit reserves the trailing rewritten
// initializer slot. The parameter and the use context are left uninitialized.
CXCXXDefaultArgExpr clang_CXXDefaultArgExpr_CreateEmpty(CXASTContext C,
                                                        bool HasRewrittenInit);

// CXXDefaultInitExpr (cont.)
// The empty shell clang deserializes into; the same shape as the default-argument shell,
// with the field and the use context left uninitialized.
CXCXXDefaultInitExpr clang_CXXDefaultInitExpr_CreateEmpty(CXASTContext C,
                                                          bool HasRewrittenInit);

// UserDefinedLiteral (cont.)
// The empty shell clang deserializes into: NumArgs argument slots plus an optional
// FPOptionsOverride slot are reserved, and the callee and the ud-suffix location behind
// them are uninitialized.
CXUserDefinedLiteral
clang_UserDefinedLiteral_CreateEmpty(CXASTContext Ctx, unsigned NumArgs, bool HasFPOptions);

// CXXOperatorCallExpr (cont.)
// The empty shell clang deserializes into; the same shape as the user-defined-literal
// shell, with the overloaded operator kind left uninitialized.
CXCXXOperatorCallExpr clang_CXXOperatorCallExpr_CreateEmpty(CXASTContext Ctx,
                                                            unsigned NumArgs,
                                                            bool HasFPFeatures);

// CXXMemberCallExpr (cont.)
// The empty shell clang deserializes into; the callee and the NumArgs argument slots are
// left uninitialized.
CXCXXMemberCallExpr clang_CXXMemberCallExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs,
                                                        bool HasFPFeatures);

// UnresolvedLookupExpr (cont.)
// The empty shell clang deserializes into: NumResults lookup-result slots and, when
// HasTemplateKWAndArgsInfo is set, NumTemplateArgs explicit template-argument slots are
// reserved; everything behind them is uninitialized.
CXUnresolvedLookupExpr clang_UnresolvedLookupExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumResults,
                                                              bool HasTemplateKWAndArgsInfo,
                                                              unsigned NumTemplateArgs);

// FunctionParmPackExpr (cont.)
// The empty shell clang deserializes into; NumParams parameter slots are reserved and the
// referenced pack and its name location are left uninitialized.
CXFunctionParmPackExpr clang_FunctionParmPackExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumParams);

// LambdaExpr (cont.)
// helper: how many of getNumCaptures() captures were written in the lambda-introducer, i.e.
// the extent of LambdaExpr::explicit_capture_begin()..explicit_capture_end(). The remaining
// captures are the implicit ones a capture-default introduced.
unsigned clang_LambdaExpr_getNumExplicitCaptures(CXLambdaExpr LE);

// TypeTraitExpr (cont.)
CXTypeTrait clang_TypeTraitExpr_getTrait(CXTypeTraitExpr E);

// SizeOfPackExpr (cont.)
// The number of template arguments the pack has already been substituted with.
// PRECONDITION: isPartiallySubstituted() - SizeOfPackExpr::getPartialArguments() asserts
// it, and without that assert it reads trailing storage that was never allocated.
unsigned clang_SizeOfPackExpr_getNumPartialArguments(CXSizeOfPackExpr E);

// The Ith already-substituted template argument. A TemplateArgument has no pointer form, so
// it comes back heap-boxed and owned: release it with clang_TemplateArgument_dispose. Its
// elements live in the node's arena memory, so the box must not outlive the ASTContext.
// PRECONDITION: isPartiallySubstituted() and I < getNumPartialArguments().
CXTemplateArgument clang_SizeOfPackExpr_getPartialArgument(CXSizeOfPackExpr E, unsigned I);

// ExprWithCleanups (cont.)
// The empty shell clang deserializes into: NumObjects cleanup-object slots are reserved but
// left uninitialized, so only the node's statement class and getNumObjects may be read
// straight away. Arena-allocated: there is no dispose.
CXExprWithCleanups clang_ExprWithCleanups_Create(CXASTContext C, unsigned NumObjects);

// Discriminator for the Ith cleanup object: a CleanupObject is a union of a BlockDecl and a
// CompoundLiteralExpr, and this reports which arm is engaged - true selects
// clang_ExprWithCleanups_getObjectAsBlockDecl, false
// clang_ExprWithCleanups_getObjectAsCompoundLiteral.
// PRECONDITION: I < getNumObjects() - ExprWithCleanups::getObject asserts it.
bool clang_ExprWithCleanups_objectIsBlockDecl(CXExprWithCleanups E, unsigned I);

// The Ith cleanup object read as a block declaration.
// PRECONDITION: I < getNumObjects() and clang_ExprWithCleanups_objectIsBlockDecl(E, I) -
// the union arm is taken unchecked, so the wrong arm hands back a mistyped pointer.
CXBlockDecl clang_ExprWithCleanups_getObjectAsBlockDecl(CXExprWithCleanups E, unsigned I);

// The Ith cleanup object read as a block-scoped compound literal.
// PRECONDITION: I < getNumObjects() and !clang_ExprWithCleanups_objectIsBlockDecl(E, I).
CXCompoundLiteralExpr
clang_ExprWithCleanups_getObjectAsCompoundLiteral(CXExprWithCleanups E, unsigned I);

// UnresolvedMemberExpr (cont.)
// The name of the member, as the DeclarationName opaque encoding.
CXDeclarationName clang_UnresolvedMemberExpr_getMemberName(CXUnresolvedMemberExpr E);

// The full name-plus-location of the member. Returns an owned box; release it with
// clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_UnresolvedMemberExpr_getMemberNameInfo(CXUnresolvedMemberExpr E);

CXSourceLocation_ clang_UnresolvedMemberExpr_getMemberLoc(CXUnresolvedMemberExpr E);

// CXXPseudoDestructorExpr (cont.)
// Name the destroyed type of a dependent pseudo-destructor expression by identifier. This
// replaces the node's whole destroyed-type storage: getDestroyedTypeInfo() reads null
// afterwards and getDestroyedType() a null QualType, while getDestroyedTypeIdentifier() and
// getDestroyedTypeLoc() read back II and Loc.
void clang_CXXPseudoDestructorExpr_setDestroyedType(CXCXXPseudoDestructorExpr E,
                                                    CXIdentifierInfo II,
                                                    CXSourceLocation_ Loc);

// MaterializeTemporaryExpr (cont.)
// Record the declaration that lifetime-extends this temporary together with the mangling
// number the ABI assigns it; both read back through getExtendingDecl() and
// getManglingNumber(). On a node whose state is still the bare subexpression this allocates
// the LifetimeExtendedTemporaryDecl that carries them, in the ASTContext.
void clang_MaterializeTemporaryExpr_setExtendingDecl(CXMaterializeTemporaryExpr E,
                                                     CXValueDecl ExtendedBy,
                                                     unsigned ManglingNumber);

// CoawaitExpr (cont.)
// Mark the co_await as compiler-introduced - the initial and final suspend points a
// coroutine body is wrapped in - rather than written in the source.
void clang_CoawaitExpr_setIsImplicit(CXCoawaitExpr E, bool Value);

// CXXOperatorCallExpr (cont.)
// Build the overloaded-operator call `Fn(Args...)` of type Ty and value kind VK in Ctx's
// arena; OpKind names the operator and OperatorLoc is where it was written. The Args
// handles are copied into the node's trailing storage, so the buffer need not outlive the
// call. FPFeatures is the opaque clang::FPOptionsOverride encoding; 0 means "no override"
// and is the only value that leaves hasStoredFPFeatures false. UsesADL records a callee
// found through argument-dependent lookup. Arena-allocated: there is no dispose.
CXCXXOperatorCallExpr clang_CXXOperatorCallExpr_Create(
    CXASTContext Ctx, CXOverloadedOperatorKind OpKind, CXExpr Fn, const CXExpr *Args,
    unsigned NumArgs, CXQualType Ty, CXExprValueKind VK, CXSourceLocation_ OperatorLoc,
    uint64_t FPFeatures, bool UsesADL);

// CXXMemberCallExpr (cont.)
// Build the member call `Fn(Args...)` of type Ty and value kind VK in Ctx's arena, with RP
// the closing parenthesis. MinNumArgs pads the trailing argument storage out to the
// callee's parameter count when the call was written with fewer arguments; 0 reserves
// exactly NumArgs slots. FPFeatures is the same opaque clang::FPOptionsOverride encoding.
// The Args handles are copied into the node's trailing storage. Arena-allocated: there is
// no dispose.
CXCXXMemberCallExpr clang_CXXMemberCallExpr_Create(
    CXASTContext Ctx, CXExpr Fn, const CXExpr *Args, unsigned NumArgs, CXQualType Ty,
    CXExprValueKind VK, CXSourceLocation_ RP, uint64_t FPFeatures, unsigned MinNumArgs);

// CUDAKernelCallExpr
// The empty shell clang deserializes into: a kernel-configuration slot and NumArgs argument
// slots, plus an FPOptionsOverride slot when HasFPFeatures is set, are reserved, and
// everything behind them - the callee, the configuration call and the arguments - is left
// uninitialized, so only the node's statement class may be read straight away.
CXCUDAKernelCallExpr clang_CUDAKernelCallExpr_CreateEmpty(CXASTContext Ctx,
                                                          unsigned NumArgs,
                                                          bool HasFPFeatures);

// UserDefinedLiteral (cont.)
// Build the user-defined-literal call `Fn(Args...)` of type Ty and value kind VK in Ctx's
// arena, with LitEndLoc the end of the literal token and SuffixLoc the ud-suffix.
// FPFeatures is the same opaque clang::FPOptionsOverride encoding and the Args handles are
// copied into the node's trailing storage. PARTIAL: getUDSuffix and getLiteralOperatorKind
// read through cast<FunctionDecl>(getCalleeDecl()), so a node built with an Fn that is not
// a reference to a literal operator must not be asked for them. Arena-allocated: there is
// no dispose.
CXUserDefinedLiteral clang_UserDefinedLiteral_Create(CXASTContext Ctx, CXExpr Fn,
                                                     const CXExpr *Args, unsigned NumArgs,
                                                     CXQualType Ty, CXExprValueKind VK,
                                                     CXSourceLocation_ LitEndLoc,
                                                     CXSourceLocation_ SuffixLoc,
                                                     uint64_t FPFeatures);

// CXXConstructExpr (cont.)
// Build the construction `T(Args...)` of type Ty at Loc in Ctx's arena, calling Ctor. The
// flags mirror the accessors of the same name (isElidable, hadMultipleCandidates,
// isListInitialization, isStdInitListInitialization, requiresZeroInitialization), CK is the
// construction kind and ParenOrBraceRange the written argument list. The Args handles are
// copied into the node's trailing storage, so the buffer need not outlive the call.
// Arena-allocated: there is no dispose.
CXCXXConstructExpr clang_CXXConstructExpr_Create(
    CXASTContext Ctx, CXQualType Ty, CXSourceLocation_ Loc, CXCXXConstructorDecl Ctor,
    bool Elidable, const CXExpr *Args, unsigned NumArgs, bool HadMultipleCandidates,
    bool ListInitialization, bool StdInitListInitialization, bool ZeroInitialization,
    CXCXXConstructionKind CK, CXSourceRange_ ParenOrBraceRange);

// CXXTemporaryObjectExpr (cont.)
// Build the functional-notation construction `T(Args...)` of type Ty in Ctx's arena,
// calling Cons, with TSI the type as written and the flags the CXXConstructExpr ones. The
// Args handles are copied into the node's trailing storage. PRECONDITION: TSI is non-null -
// clang's constructor takes the node's location from TSI->getTypeLoc().getBeginLoc().
// Arena-allocated: there is no dispose.
CXCXXTemporaryObjectExpr clang_CXXTemporaryObjectExpr_Create(
    CXASTContext Ctx, CXCXXConstructorDecl Cons, CXQualType Ty, CXTypeSourceInfo TSI,
    const CXExpr *Args, unsigned NumArgs, CXSourceRange_ ParenOrBraceRange,
    bool HadMultipleCandidates, bool ListInitialization, bool StdInitListInitialization,
    bool ZeroInitialization);

// CXXNewExpr (cont.)
// Build the new-expression `new (PlacementArgs...) T Initializer` of type Ty in Ctx's
// arena. OperatorNew and OperatorDelete are the resolved allocation and deallocation
// functions and may be NULL. HasArraySize/ArraySize split the std::optional<Expr *> extent
// (MARSHALLING.md section 8): a clear HasArraySize is the non-array form, a set one with a
// NULL ArraySize the array form whose extent was not written (`new int[]{1, 2}`).
// InitializationStyle records the initializer's spelling. PRECONDITION: Initializer is
// non-null unless InitializationStyle is CXCXXNewInitializationStyle_None - clang asserts
// it. The PlacementArgs handles are copied into the node's trailing storage.
// Arena-allocated: there is no dispose.
CXCXXNewExpr clang_CXXNewExpr_Create(
    CXASTContext Ctx, bool IsGlobalNew, CXFunctionDecl OperatorNew,
    CXFunctionDecl OperatorDelete, bool ShouldPassAlignment, bool UsualArrayDeleteWantsSize,
    const CXExpr *PlacementArgs, unsigned NumPlacementArgs, CXSourceRange_ TypeIdParens,
    bool HasArraySize, CXExpr ArraySize, CXCXXNewInitializationStyle InitializationStyle,
    CXExpr Initializer, CXQualType Ty, CXTypeSourceInfo AllocatedTypeInfo,
    CXSourceRange_ Range, CXSourceRange_ DirectInitRange);

// LambdaExpr (cont.)
// The empty shell clang deserializes into: NumCaptures capture-initializer slots are
// reserved and the closure class, the introducer range and the capture default behind them
// are left uninitialized, so only the node's statement class may be read straight away.
CXLambdaExpr clang_LambdaExpr_CreateDeserialized(CXASTContext C, unsigned NumCaptures);

// TypeTraitExpr (cont.)
// Build the type-trait expression `Kind(Args...)` of type T at Loc in Ctx's arena, with
// RParenLoc the closing parenthesis and Value the already-evaluated result. The Args
// handles are copied into the node's trailing storage, so the buffer need not outlive the
// call. Only a node built from non-dependent arguments answers
// clang_TypeTraitExpr_getValue, which asserts !isValueDependent(). Arena-allocated: there
// is no dispose.
CXTypeTraitExpr clang_TypeTraitExpr_Create(CXASTContext C, CXQualType T,
                                           CXSourceLocation_ Loc, CXTypeTrait Kind,
                                           const CXTypeSourceInfo *Args, unsigned NumArgs,
                                           CXSourceLocation_ RParenLoc, bool Value);

// The empty shell clang deserializes into; the NumArgs argument slots and the trait kind
// behind them are left uninitialized.
CXTypeTraitExpr clang_TypeTraitExpr_CreateDeserialized(CXASTContext C, unsigned NumArgs);

// SizeOfPackExpr (cont.)
// Build the `sizeof...(Pack)` expression in Context's arena, with OperatorLoc, PackLoc and
// RParenLoc the written locations. HasLength/Length split the std::optional<unsigned> pack
// size (MARSHALLING.md section 8): a set HasLength gives the already-known size and makes
// the node non-dependent, a clear one leaves it value-dependent with NumPartialArgs as its
// length. PartialArgs holds heap-boxed clang::TemplateArgument handles, each dereferenced
// and copied into the node's trailing storage, so the boxes need not outlive the call.
// PRECONDITION: !HasLength || NumPartialArgs == 0 - clang asserts that a non-dependent
// sizeof... carries no partially-substituted arguments. Arena-allocated: there is no
// dispose.
CXSizeOfPackExpr
clang_SizeOfPackExpr_Create(CXASTContext Context, CXSourceLocation_ OperatorLoc,
                            CXNamedDecl Pack, CXSourceLocation_ PackLoc,
                            CXSourceLocation_ RParenLoc, bool HasLength, unsigned Length,
                            const CXTemplateArgument *PartialArgs, unsigned NumPartialArgs);

// The empty shell clang deserializes into: NumPartialArgs partially-substituted argument
// slots are reserved and the pack and its locations are left uninitialized.
CXSizeOfPackExpr clang_SizeOfPackExpr_CreateDeserialized(CXASTContext Context,
                                                         unsigned NumPartialArgs);

// DependentScopeDeclRefExpr (cont.)
// The empty shell clang deserializes into: when HasTemplateKWAndArgsInfo is set,
// NumTemplateArgs explicit template-argument slots are reserved; the qualifier and the name
// behind them are left uninitialized.
CXDependentScopeDeclRefExpr clang_DependentScopeDeclRefExpr_CreateEmpty(
    CXASTContext Context, bool HasTemplateKWAndArgsInfo, unsigned NumTemplateArgs);

// CXXDependentScopeMemberExpr (cont.)
// The empty shell clang deserializes into: the same template-argument storage as the
// dependent declaration-reference shell, plus a first-qualifier-found-in-scope slot when
// HasFirstQualifierFoundInScope is set. The base and the member name are left
// uninitialized.
CXCXXDependentScopeMemberExpr clang_CXXDependentScopeMemberExpr_CreateEmpty(
    CXASTContext Ctx, bool HasTemplateKWAndArgsInfo, unsigned NumTemplateArgs,
    bool HasFirstQualifierFoundInScope);

// UnresolvedMemberExpr (cont.)
// The empty shell clang deserializes into: NumResults lookup-result slots and, when
// HasTemplateKWAndArgsInfo is set, NumTemplateArgs explicit template-argument slots are
// reserved; everything behind them is uninitialized.
CXUnresolvedMemberExpr clang_UnresolvedMemberExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumResults,
                                                              bool HasTemplateKWAndArgsInfo,
                                                              unsigned NumTemplateArgs);

// LambdaExpr (cont.)
// Build the lambda expression whose closure type is Class in C's arena. IntroducerRange is
// the written `[...]` extent, CaptureDefault and CaptureDefaultLoc the capture default and
// where it was written, ExplicitParams and ExplicitResultType mirror the accessors of the
// same name, ClosingBrace closes the body and ContainsUnexpandedParameterPack seeds the
// node's dependence bits. The CaptureInits handles are copied into the node's trailing
// storage, so the buffer need not outlive the call; a slot may be null, which is how a
// VLA-typed capture is spelled. PRECONDITIONS: Class is a lambda closure type whose call
// operator already carries a body (the constructor copies it into the node), and clang
// asserts both that NumCaptureInits equals Class's capture count and that CaptureDefault
// equals Class's capture default. Arena-allocated: there is no dispose.
CXLambdaExpr clang_LambdaExpr_Create(CXASTContext C, CXCXXRecordDecl Class,
                                     CXSourceRange_ IntroducerRange,
                                     CXLambdaCaptureDefault CaptureDefault,
                                     CXSourceLocation_ CaptureDefaultLoc,
                                     bool ExplicitParams, bool ExplicitResultType,
                                     const CXExpr *CaptureInits, unsigned NumCaptureInits,
                                     CXSourceLocation_ ClosingBrace,
                                     bool ContainsUnexpandedParameterPack);

// CUDAKernelCallExpr (cont.)
// Build the kernel launch `Fn<<<...>>>(Args...)` of type Ty and value kind VK in Ctx's
// arena, with Config the `<<<...>>>` configuration call and RP the closing parenthesis.
// MinNumArgs pads the trailing argument storage out to the callee's parameter count when
// the call was written with fewer arguments; 0 reserves exactly NumArgs slots. FPFeatures
// is the opaque clang::FPOptionsOverride encoding; 0 means "no override". The Args handles
// are copied into the node's trailing storage, so the buffer need not outlive the call.
// Arena-allocated: there is no dispose.
CXCUDAKernelCallExpr
clang_CUDAKernelCallExpr_Create(CXASTContext Ctx, CXExpr Fn, CXCallExpr Config,
                                const CXExpr *Args, unsigned NumArgs, CXQualType Ty,
                                CXExprValueKind VK, CXSourceLocation_ RP,
                                uint64_t FPFeatures, unsigned MinNumArgs);

// The `<<<...>>>` configuration call, or null when the launch carries none. Reading it from
// a node built by clang_CUDAKernelCallExpr_CreateEmpty is undefined behaviour: that shell
// leaves the configuration slot uninitialized.
CXCallExpr clang_CUDAKernelCallExpr_getConfig(CXCUDAKernelCallExpr E);

// OverloadExpr (cont.)
// Find the overload set E names, looking through parentheses and a leading `&`. The return
// is the OverloadExpr itself; *IsAddressOfOperand records whether it was the operand of an
// `&`, and *HasFormOfMemberPointer whether that `&` applied to a qualified name and so
// forms a pointer to member. PRECONDITION: E's type is clang's Overload placeholder
// builtin - clang asserts it, and every cast below it is unchecked.
CXOverloadExpr clang_OverloadExpr_find(CXExpr E, bool *IsAddressOfOperand,
                                       bool *HasFormOfMemberPointer);

// CXXParenListInitExpr (cont.)
// Recompute the node's dependence bits from its current initializer list; the setters that
// replace an initializer leave them stale.
void clang_CXXParenListInitExpr_updateDependence(CXCXXParenListInitExpr E);

// OverloadExpr (cont.)
// Appends the explicit template arguments E was written with, and the angle-bracket
// locations, to List. List is caller-owned (clang_TemplateArgumentListInfo_create /
// _dispose). A lookup with no explicit `<...>` leaves List untouched, so this is total.
void clang_OverloadExpr_copyTemplateArgumentsInto(CXOverloadExpr E,
                                                  CXTemplateArgumentListInfo List);

// DependentScopeDeclRefExpr (cont.)
// Appends the written template arguments to List; see
// clang_OverloadExpr_copyTemplateArgumentsInto.
void clang_DependentScopeDeclRefExpr_copyTemplateArgumentsInto(
    CXDependentScopeDeclRefExpr E, CXTemplateArgumentListInfo List);

// CXXDependentScopeMemberExpr (cont.)
// Appends the written template arguments to List; see
// clang_OverloadExpr_copyTemplateArgumentsInto.
void clang_CXXDependentScopeMemberExpr_copyTemplateArgumentsInto(
    CXCXXDependentScopeMemberExpr E, CXTemplateArgumentListInfo List);

// DependentScopeDeclRefExpr (cont.)
// Build the dependent qualified reference `T::name` in Context's arena. QualifierLoc is the
// `T::` as written, TemplateKWLoc the `template` keyword of `T::template f<...>` (invalid
// when there is none) and NameInfo the name with its location. TemplateArgs may be NULL,
// which is how a reference with no explicit `<...>` is spelled. PRECONDITION: QualifierLoc
// must carry a qualifier - the node exists to name something through a dependent scope, and
// every consumer of getQualifier() assumes one. Arena-allocated: there is no dispose.
CXDependentScopeDeclRefExpr clang_DependentScopeDeclRefExpr_Create(
    CXASTContext Context, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXDeclarationNameInfo NameInfo,
    CXTemplateArgumentListInfo TemplateArgs);

// CXXDependentScopeMemberExpr (cont.)
// Build the dependent member access `Base.member` / `Base->member` in Ctx's arena. Base is
// NULL for an implicit access (a bare `member` inside a dependent class), BaseType the type
// of the object expression, QualifierLoc the `::`-qualification of the member name and
// FirstQualifierFoundInScope the declaration that qualification named at parse time, NULL
// when none was found. TemplateArgs may be NULL when no explicit `<...>` was written.
// Arena-allocated: there is no dispose.
CXCXXDependentScopeMemberExpr clang_CXXDependentScopeMemberExpr_Create(
    CXASTContext Ctx, CXExpr Base, CXQualType BaseType, bool IsArrow,
    CXSourceLocation_ OperatorLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXNamedDecl FirstQualifierFoundInScope,
    CXDeclarationNameInfo MemberNameInfo, CXTemplateArgumentListInfo TemplateArgs);

// UnresolvedLookupExpr (cont.)
// Build the unresolved lookup of an overload set in Context's arena. NamingClass is the
// class the lookup ran in and is NULL for a namespace-scope set, QualifierLoc the written
// `::`-qualification, RequiresADL whether argument-dependent lookup still has to run and
// Overloaded whether the name resolved to more than one declaration. The lookup results
// cross as the parallel component arrays Decls/Accesses of MARSHALLING.md section 11, read
// in lockstep against NumDecls; clang copies them into the node's trailing storage, so
// neither buffer need outlive the call. PRECONDITION: NumDecls >= 1 - an overload set with
// no results has no meaning. Arena-allocated: there is no dispose.
CXUnresolvedLookupExpr
clang_UnresolvedLookupExpr_Create(CXASTContext Context, CXCXXRecordDecl NamingClass,
                                  CXNestedNameSpecifierLoc QualifierLoc,
                                  CXDeclarationNameInfo NameInfo, bool RequiresADL,
                                  bool Overloaded, const CXNamedDecl *Decls,
                                  const CXAccessSpecifier *Accesses, unsigned NumDecls);

// The same overload set written with an explicit template argument list, e.g. `f<int>`.
// TemplateKWLoc is the `template` keyword, TemplateArgs the written `<...>` (NULL when the
// keyword appears without one) and KnownDependent whether any canonicalized argument is
// dependent, which selects the node's type. Lookup results and NumDecls cross exactly as in
// clang_UnresolvedLookupExpr_Create. Arena-allocated: there is no dispose.
CXUnresolvedLookupExpr clang_UnresolvedLookupExpr_CreateWithTemplateArgs(
    CXASTContext Context, CXCXXRecordDecl NamingClass,
    CXNestedNameSpecifierLoc QualifierLoc, CXSourceLocation_ TemplateKWLoc,
    CXDeclarationNameInfo NameInfo, bool RequiresADL,
    CXTemplateArgumentListInfo TemplateArgs, const CXNamedDecl *Decls,
    const CXAccessSpecifier *Accesses, unsigned NumDecls, bool KnownDependent);

// UnresolvedMemberExpr (cont.)
// Build the unresolved member access `Base.m` / `Base->m` in Context's arena, where m named
// an overload set. HasUnresolvedUsing records that the set holds an UnresolvedUsingValue
// declaration, Base is NULL for an implicit access and TemplateArgs may be NULL. Lookup
// results and NumDecls cross exactly as in clang_UnresolvedLookupExpr_Create.
// Arena-allocated: there is no dispose.
CXUnresolvedMemberExpr clang_UnresolvedMemberExpr_Create(
    CXASTContext Context, bool HasUnresolvedUsing, CXExpr Base, CXQualType BaseType,
    bool IsArrow, CXSourceLocation_ OperatorLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXDeclarationNameInfo MemberNameInfo,
    CXTemplateArgumentListInfo TemplateArgs, const CXNamedDecl *Decls,
    const CXAccessSpecifier *Accesses, unsigned NumDecls);

LLVM_CLANG_C_EXTERN_C_END

#endif
