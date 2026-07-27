#include "clang-ex/AST/CXExprCXX.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/LambdaCapture.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclarationName.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/TemplateBase.h"
#include "clang/AST/UnresolvedSet.h"
#include <memory>

// UserDefinedLiteral
CXUserDefinedLiteral_LiteralOperatorKind
clang_UserDefinedLiteral_getLiteralOperatorKind(CXUserDefinedLiteral E) {
  return static_cast<CXUserDefinedLiteral_LiteralOperatorKind>(
      static_cast<clang::UserDefinedLiteral *>(E)->getLiteralOperatorKind());
}

CXExpr clang_UserDefinedLiteral_getCookedLiteral(CXUserDefinedLiteral E) {
  return static_cast<clang::UserDefinedLiteral *>(E)->getCookedLiteral();
}

CXIdentifierInfo clang_UserDefinedLiteral_getUDSuffix(CXUserDefinedLiteral E) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::UserDefinedLiteral *>(E)->getUDSuffix());
}

// CXXRewrittenBinaryOperator
CXExpr clang_CXXRewrittenBinaryOperator_getSemanticForm(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getSemanticForm();
}

CXBinaryOperatorKind
clang_CXXRewrittenBinaryOperator_getOpcode(CXCXXRewrittenBinaryOperator E) {
  return static_cast<CXBinaryOperatorKind>(
      static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getOpcode());
}

CXExpr clang_CXXRewrittenBinaryOperator_getLHS(CXCXXRewrittenBinaryOperator E) {
  return const_cast<clang::Expr *>(
      static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getLHS());
}

CXExpr clang_CXXRewrittenBinaryOperator_getRHS(CXCXXRewrittenBinaryOperator E) {
  return const_cast<clang::Expr *>(
      static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getRHS());
}

bool clang_CXXRewrittenBinaryOperator_isReversed(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)->isReversed();
}

// CXXStdInitializerListExpr
CXExpr clang_CXXStdInitializerListExpr_getSubExpr(CXCXXStdInitializerListExpr E) {
  return static_cast<clang::CXXStdInitializerListExpr *>(E)->getSubExpr();
}

// CXXScalarValueInitExpr
CXTypeSourceInfo
clang_CXXScalarValueInitExpr_getTypeSourceInfo(CXCXXScalarValueInitExpr E) {
  return static_cast<clang::CXXScalarValueInitExpr *>(E)->getTypeSourceInfo();
}

CXSourceLocation_ clang_CXXScalarValueInitExpr_getRParenLoc(CXCXXScalarValueInitExpr E) {
  return static_cast<clang::CXXScalarValueInitExpr *>(E)->getRParenLoc().getPtrEncoding();
}

// CXXNullPtrLiteralExpr
CXSourceLocation_ clang_CXXNullPtrLiteralExpr_getLocation(CXCXXNullPtrLiteralExpr E) {
  return static_cast<clang::CXXNullPtrLiteralExpr *>(E)->getLocation().getPtrEncoding();
}

// CXXInheritedCtorInitExpr
CXCXXConstructorDecl
clang_CXXInheritedCtorInitExpr_getConstructor(CXCXXInheritedCtorInitExpr E) {
  return static_cast<clang::CXXInheritedCtorInitExpr *>(E)->getConstructor();
}

bool clang_CXXInheritedCtorInitExpr_constructsVBase(CXCXXInheritedCtorInitExpr E) {
  return static_cast<clang::CXXInheritedCtorInitExpr *>(E)->constructsVBase();
}

CXCXXConstructionKind
clang_CXXInheritedCtorInitExpr_getConstructionKind(CXCXXInheritedCtorInitExpr E) {
  return static_cast<CXCXXConstructionKind>(
      static_cast<clang::CXXInheritedCtorInitExpr *>(E)->getConstructionKind());
}

bool clang_CXXInheritedCtorInitExpr_inheritedFromVBase(CXCXXInheritedCtorInitExpr E) {
  return static_cast<clang::CXXInheritedCtorInitExpr *>(E)->inheritedFromVBase();
}

CXSourceLocation_ clang_CXXInheritedCtorInitExpr_getLocation(CXCXXInheritedCtorInitExpr E) {
  return static_cast<clang::CXXInheritedCtorInitExpr *>(E)->getLocation().getPtrEncoding();
}

// CoroutineSuspendExpr
CXExpr clang_CoroutineSuspendExpr_getCommonExpr(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getCommonExpr();
}

CXExpr clang_CoroutineSuspendExpr_getReadyExpr(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getReadyExpr();
}

CXExpr clang_CoroutineSuspendExpr_getSuspendExpr(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getSuspendExpr();
}

CXExpr clang_CoroutineSuspendExpr_getResumeExpr(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getResumeExpr();
}

CXExpr clang_CoroutineSuspendExpr_getOperand(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getOperand();
}

CXSourceLocation_ clang_CoroutineSuspendExpr_getKeywordLoc(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getKeywordLoc().getPtrEncoding();
}

// CXXNamedCastExpr
const char *clang_CXXNamedCastExpr_getCastName(CXCXXNamedCastExpr E) {
  return static_cast<clang::CXXNamedCastExpr *>(E)->getCastName();
}

CXSourceRange_ clang_CXXNamedCastExpr_getAngleBrackets(CXCXXNamedCastExpr E) {
  auto rng = static_cast<clang::CXXNamedCastExpr *>(E)->getAngleBrackets();
  CXSourceLocation_ Begin = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ End = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{Begin, End};
}

// CXXThrowExpr
CXExpr clang_CXXThrowExpr_getSubExpr(CXCXXThrowExpr E) {
  return static_cast<clang::CXXThrowExpr *>(E)->getSubExpr();
}

CXSourceLocation_ clang_CXXThrowExpr_getThrowLoc(CXCXXThrowExpr E) {
  return static_cast<clang::CXXThrowExpr *>(E)->getThrowLoc().getPtrEncoding();
}

bool clang_CXXThrowExpr_isThrownVariableInScope(CXCXXThrowExpr E) {
  return static_cast<clang::CXXThrowExpr *>(E)->isThrownVariableInScope();
}

// CXXTypeidExpr
bool clang_CXXTypeidExpr_isPotentiallyEvaluated(CXCXXTypeidExpr E) {
  return static_cast<clang::CXXTypeidExpr *>(E)->isPotentiallyEvaluated();
}

bool clang_CXXTypeidExpr_isMostDerived(CXCXXTypeidExpr E, CXASTContext Ctx) {
  return static_cast<clang::CXXTypeidExpr *>(E)->isMostDerived(
      *static_cast<clang::ASTContext *>(Ctx));
}
bool clang_CXXTypeidExpr_isTypeOperand(CXCXXTypeidExpr E) {
  return static_cast<clang::CXXTypeidExpr *>(E)->isTypeOperand();
}

CXQualType clang_CXXTypeidExpr_getTypeOperand(CXCXXTypeidExpr E, CXASTContext Ctx) {
  return static_cast<clang::CXXTypeidExpr *>(E)
      ->getTypeOperand(*static_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr();
}

CXTypeSourceInfo clang_CXXTypeidExpr_getTypeOperandSourceInfo(CXCXXTypeidExpr E) {
  return static_cast<clang::CXXTypeidExpr *>(E)->getTypeOperandSourceInfo();
}

CXExpr clang_CXXTypeidExpr_getExprOperand(CXCXXTypeidExpr E) {
  return static_cast<clang::CXXTypeidExpr *>(E)->getExprOperand();
}

// CXXDefaultArgExpr
CXParmVarDecl clang_CXXDefaultArgExpr_getParam(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getParam();
}

CXExpr clang_CXXDefaultArgExpr_getExpr(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getExpr();
}

// CXXDefaultInitExpr
CXFieldDecl clang_CXXDefaultInitExpr_getField(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->getField();
}

CXExpr clang_CXXDefaultInitExpr_getExpr(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->getExpr();
}

// CXXBindTemporaryExpr
CXExpr clang_CXXBindTemporaryExpr_getSubExpr(CXCXXBindTemporaryExpr E) {
  return static_cast<clang::CXXBindTemporaryExpr *>(E)->getSubExpr();
}

// ExprWithCleanups
unsigned clang_ExprWithCleanups_getNumObjects(CXExprWithCleanups E) {
  return static_cast<clang::ExprWithCleanups *>(E)->getNumObjects();
}

bool clang_ExprWithCleanups_cleanupsHaveSideEffects(CXExprWithCleanups E) {
  return static_cast<clang::ExprWithCleanups *>(E)->cleanupsHaveSideEffects();
}

// TypeTraitExpr
bool clang_TypeTraitExpr_getValue(CXTypeTraitExpr E) {
  return static_cast<clang::TypeTraitExpr *>(E)->getValue();
}

unsigned clang_TypeTraitExpr_getNumArgs(CXTypeTraitExpr E) {
  return static_cast<clang::TypeTraitExpr *>(E)->getNumArgs();
}

CXTypeSourceInfo clang_TypeTraitExpr_getArg(CXTypeTraitExpr E, unsigned I) {
  return static_cast<clang::TypeTraitExpr *>(E)->getArg(I);
}

// SizeOfPackExpr
CXNamedDecl clang_SizeOfPackExpr_getPack(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->getPack();
}

bool clang_SizeOfPackExpr_isPartiallySubstituted(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->isPartiallySubstituted();
}

CXSourceLocation_ clang_SizeOfPackExpr_getOperatorLoc(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->getOperatorLoc().getPtrEncoding();
}

CXSourceLocation_ clang_SizeOfPackExpr_getPackLoc(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->getPackLoc().getPtrEncoding();
}

CXSourceLocation_ clang_SizeOfPackExpr_getRParenLoc(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->getRParenLoc().getPtrEncoding();
}

unsigned clang_SizeOfPackExpr_getPackLength(CXSizeOfPackExpr E) {
  return static_cast<clang::SizeOfPackExpr *>(E)->getPackLength();
}

// CXXFoldExpr
CXExpr clang_CXXFoldExpr_getPattern(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getPattern();
}

CXUnresolvedLookupExpr clang_CXXFoldExpr_getCallee(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getCallee();
}

CXExpr clang_CXXFoldExpr_getLHS(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getLHS();
}

CXExpr clang_CXXFoldExpr_getRHS(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getRHS();
}

bool clang_CXXFoldExpr_isLeftFold(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->isLeftFold();
}

bool clang_CXXFoldExpr_isRightFold(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->isRightFold();
}

CXExpr clang_CXXFoldExpr_getInit(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getInit();
}

CXSourceLocation_ clang_CXXFoldExpr_getLParenLoc(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getLParenLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXFoldExpr_getRParenLoc(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getRParenLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXFoldExpr_getEllipsisLoc(CXCXXFoldExpr E) {
  return static_cast<clang::CXXFoldExpr *>(E)->getEllipsisLoc().getPtrEncoding();
}

CXBinaryOperatorKind clang_CXXFoldExpr_getOperator(CXCXXFoldExpr E) {
  return static_cast<CXBinaryOperatorKind>(
      static_cast<clang::CXXFoldExpr *>(E)->getOperator());
}

// LambdaExpr
CXLambdaCaptureDefault clang_LambdaExpr_getCaptureDefault(CXLambdaExpr LE) {
  return static_cast<CXLambdaCaptureDefault>(
      static_cast<clang::LambdaExpr *>(LE)->getCaptureDefault());
}

CXSourceLocation_ clang_LambdaExpr_getCaptureDefaultLoc(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getCaptureDefaultLoc().getPtrEncoding();
}

CXSourceRange_ clang_LambdaExpr_getIntroducerRange(CXLambdaExpr LE) {
  auto rng = static_cast<clang::LambdaExpr *>(LE)->getIntroducerRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXExpr clang_LambdaExpr_getCaptureInit(CXLambdaExpr LE, unsigned I) {
  return *(static_cast<clang::LambdaExpr *>(LE)->capture_init_begin() + I);
}

bool clang_LambdaExpr_isInitCapture(CXLambdaExpr LE, CXLambdaCapture C) {
  return static_cast<clang::LambdaExpr *>(LE)->isInitCapture(
      static_cast<clang::LambdaCapture *>(C));
}

bool clang_LambdaExpr_hasExplicitParameters(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->hasExplicitParameters();
}

bool clang_LambdaExpr_hasExplicitResultType(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->hasExplicitResultType();
}

CXCompoundStmt clang_LambdaExpr_getCompoundStmtBody(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getCompoundStmtBody();
}

CXFunctionTemplateDecl clang_LambdaExpr_getDependentCallOperator(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getDependentCallOperator();
}

CXTemplateParameterList clang_LambdaExpr_getTemplateParameterList(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getTemplateParameterList();
}

CXExpr clang_LambdaExpr_getTrailingRequiresClause(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getTrailingRequiresClause();
}

// CXXConstructExpr
CXSourceRange_ clang_CXXConstructExpr_getParenOrBraceRange(CXCXXConstructExpr E) {
  auto rng = static_cast<clang::CXXConstructExpr *>(E)->getParenOrBraceRange();
  CXSourceLocation_ Begin = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ End = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{Begin, End};
}

// CXXTemporaryObjectExpr
CXTypeSourceInfo
clang_CXXTemporaryObjectExpr_getTypeSourceInfo(CXCXXTemporaryObjectExpr E) {
  return static_cast<clang::CXXTemporaryObjectExpr *>(E)->getTypeSourceInfo();
}

// CXXNewExpr
CXExpr clang_CXXNewExpr_getPlacementArg(CXCXXNewExpr E, unsigned I) {
  return static_cast<clang::CXXNewExpr *>(E)->getPlacementArg(I);
}

CXSourceRange_ clang_CXXNewExpr_getDirectInitRange(CXCXXNewExpr E) {
  auto rng = static_cast<clang::CXXNewExpr *>(E)->getDirectInitRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ Ed = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, Ed};
}

CXSourceRange_ clang_CXXNewExpr_getTypeIdParens(CXCXXNewExpr E) {
  auto rng = static_cast<clang::CXXNewExpr *>(E)->getTypeIdParens();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ Ed = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, Ed};
}

// CXXOperatorCallExpr
CXOverloadedOperatorKind clang_CXXOperatorCallExpr_getOperator(CXCXXOperatorCallExpr OCE) {
  return static_cast<CXOverloadedOperatorKind>(
      static_cast<clang::CXXOperatorCallExpr *>(OCE)->getOperator());
}

CXSourceLocation_ clang_CXXOperatorCallExpr_getOperatorLoc(CXCXXOperatorCallExpr OCE) {
  return static_cast<clang::CXXOperatorCallExpr *>(OCE)->getOperatorLoc().getPtrEncoding();
}

bool clang_CXXOperatorCallExpr_isAssignmentOp(CXCXXOperatorCallExpr OCE) {
  return static_cast<clang::CXXOperatorCallExpr *>(OCE)->isAssignmentOp();
}

bool clang_CXXOperatorCallExpr_isComparisonOp(CXCXXOperatorCallExpr OCE) {
  return static_cast<clang::CXXOperatorCallExpr *>(OCE)->isComparisonOp();
}

// CXXMemberCallExpr
CXExpr clang_CXXMemberCallExpr_getImplicitObjectArgument(CXCXXMemberCallExpr MCE) {
  return static_cast<clang::CXXMemberCallExpr *>(MCE)->getImplicitObjectArgument();
}

CXCXXMethodDecl clang_CXXMemberCallExpr_getMethodDecl(CXCXXMemberCallExpr MCE) {
  return static_cast<clang::CXXMemberCallExpr *>(MCE)->getMethodDecl();
}

CXCXXRecordDecl clang_CXXMemberCallExpr_getRecordDecl(CXCXXMemberCallExpr MCE) {
  return static_cast<clang::CXXMemberCallExpr *>(MCE)->getRecordDecl();
}

CXQualType clang_CXXMemberCallExpr_getObjectType(CXCXXMemberCallExpr MCE) {
  return static_cast<clang::CXXMemberCallExpr *>(MCE)->getObjectType().getAsOpaquePtr();
}

// CXXBoolLiteralExpr
bool clang_CXXBoolLiteralExpr_getValue(CXCXXBoolLiteralExpr BLE) {
  return static_cast<clang::CXXBoolLiteralExpr *>(BLE)->getValue();
}

// CXXConstructExpr
CXCXXConstructorDecl clang_CXXConstructExpr_getConstructor(CXCXXConstructExpr CE) {
  return static_cast<clang::CXXConstructExpr *>(CE)->getConstructor();
}

unsigned clang_CXXConstructExpr_getNumArgs(CXCXXConstructExpr CE) {
  return static_cast<clang::CXXConstructExpr *>(CE)->getNumArgs();
}

CXExpr clang_CXXConstructExpr_getArg(CXCXXConstructExpr CE, unsigned Arg) {
  return static_cast<clang::CXXConstructExpr *>(CE)->getArg(Arg);
}

bool clang_CXXConstructExpr_isElidable(CXCXXConstructExpr CE) {
  return static_cast<clang::CXXConstructExpr *>(CE)->isElidable();
}

// LambdaExpr
CXCXXMethodDecl clang_LambdaExpr_getCallOperator(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getCallOperator();
}

CXCXXRecordDecl clang_LambdaExpr_getLambdaClass(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getLambdaClass();
}

CXStmt clang_LambdaExpr_getBody(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->getBody();
}

bool clang_LambdaExpr_isMutable(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->isMutable();
}

// CXXNewExpr
CXQualType clang_CXXNewExpr_getAllocatedType(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->getAllocatedType().getAsOpaquePtr();
}

bool clang_CXXNewExpr_isArray(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->isArray();
}

CXExpr clang_CXXNewExpr_getArraySize(CXCXXNewExpr NE) {
  auto Size = static_cast<clang::CXXNewExpr *>(NE)->getArraySize();
  return Size ? *Size : nullptr;
}

bool clang_CXXNewExpr_hasInitializer(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->hasInitializer();
}

CXExpr clang_CXXNewExpr_getInitializer(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->getInitializer();
}

// CXXDeleteExpr
CXExpr clang_CXXDeleteExpr_getArgument(CXCXXDeleteExpr DE) {
  return static_cast<clang::CXXDeleteExpr *>(DE)->getArgument();
}

bool clang_CXXDeleteExpr_isArrayForm(CXCXXDeleteExpr DE) {
  return static_cast<clang::CXXDeleteExpr *>(DE)->isArrayForm();
}

// CXXBoolLiteralExpr
CXSourceLocation_ clang_CXXBoolLiteralExpr_getLocation(CXCXXBoolLiteralExpr E) {
  return static_cast<clang::CXXBoolLiteralExpr *>(E)->getLocation().getPtrEncoding();
}

// CXXThisExpr
CXSourceLocation_ clang_CXXThisExpr_getLocation(CXCXXThisExpr E) {
  return static_cast<clang::CXXThisExpr *>(E)->getLocation().getPtrEncoding();
}

bool clang_CXXThisExpr_isImplicit(CXCXXThisExpr E) {
  return static_cast<clang::CXXThisExpr *>(E)->isImplicit();
}

// CXXNewExpr
bool clang_CXXNewExpr_shouldNullCheckAllocation(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->shouldNullCheckAllocation();
}

unsigned clang_CXXNewExpr_getNumPlacementArgs(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->getNumPlacementArgs();
}

bool clang_CXXNewExpr_isParenTypeId(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->isParenTypeId();
}

bool clang_CXXNewExpr_isGlobalNew(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->isGlobalNew();
}

bool clang_CXXNewExpr_passAlignment(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->passAlignment();
}

bool clang_CXXNewExpr_doesUsualArrayDeleteWantSize(CXCXXNewExpr E) {
  return static_cast<clang::CXXNewExpr *>(E)->doesUsualArrayDeleteWantSize();
}

// CXXDeleteExpr
bool clang_CXXDeleteExpr_isGlobalDelete(CXCXXDeleteExpr E) {
  return static_cast<clang::CXXDeleteExpr *>(E)->isGlobalDelete();
}

bool clang_CXXDeleteExpr_isArrayFormAsWritten(CXCXXDeleteExpr E) {
  return static_cast<clang::CXXDeleteExpr *>(E)->isArrayFormAsWritten();
}

bool clang_CXXDeleteExpr_doesUsualArrayDeleteWantSize(CXCXXDeleteExpr E) {
  return static_cast<clang::CXXDeleteExpr *>(E)->doesUsualArrayDeleteWantSize();
}

CXQualType clang_CXXDeleteExpr_getDestroyedType(CXCXXDeleteExpr E) {
  return static_cast<clang::CXXDeleteExpr *>(E)->getDestroyedType().getAsOpaquePtr();
}

// CXXConstructExpr
CXSourceLocation_ clang_CXXConstructExpr_getLocation(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->getLocation().getPtrEncoding();
}

bool clang_CXXConstructExpr_hadMultipleCandidates(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->hadMultipleCandidates();
}

bool clang_CXXConstructExpr_isListInitialization(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->isListInitialization();
}

bool clang_CXXConstructExpr_isStdInitListInitialization(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->isStdInitListInitialization();
}

bool clang_CXXConstructExpr_requiresZeroInitialization(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->requiresZeroInitialization();
}

bool clang_CXXConstructExpr_isImmediateEscalating(CXCXXConstructExpr E) {
  return static_cast<clang::CXXConstructExpr *>(E)->isImmediateEscalating();
}

// MaterializeTemporaryExpr
unsigned clang_MaterializeTemporaryExpr_getManglingNumber(CXMaterializeTemporaryExpr E) {
  return static_cast<clang::MaterializeTemporaryExpr *>(E)->getManglingNumber();
}

bool clang_MaterializeTemporaryExpr_isBoundToLvalueReference(CXMaterializeTemporaryExpr E) {
  return static_cast<clang::MaterializeTemporaryExpr *>(E)->isBoundToLvalueReference();
}

// CXXNamedCastExpr
CXSourceLocation_ clang_CXXNamedCastExpr_getOperatorLoc(CXCXXNamedCastExpr E) {
  return static_cast<clang::CXXNamedCastExpr *>(E)->getOperatorLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXNamedCastExpr_getRParenLoc(CXCXXNamedCastExpr E) {
  return static_cast<clang::CXXNamedCastExpr *>(E)->getRParenLoc().getPtrEncoding();
}


// CXXConstructExpr construction kind
CXCXXConstructionKind clang_CXXConstructExpr_getConstructionKind(CXCXXConstructExpr CE) {
  return static_cast<CXCXXConstructionKind>(
      static_cast<clang::CXXConstructExpr *>(CE)->getConstructionKind());
}

// CXXNewExpr metadata
CXCXXNewInitializationStyle clang_CXXNewExpr_getInitializationStyle(CXCXXNewExpr NE) {
  return static_cast<CXCXXNewInitializationStyle>(
      static_cast<clang::CXXNewExpr *>(NE)->getInitializationStyle());
}

CXFunctionDecl clang_CXXNewExpr_getOperatorNew(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->getOperatorNew();
}

CXFunctionDecl clang_CXXNewExpr_getOperatorDelete(CXCXXNewExpr NE) {
  return static_cast<clang::CXXNewExpr *>(NE)->getOperatorDelete();
}

// CXXDeleteExpr operator delete
CXFunctionDecl clang_CXXDeleteExpr_getOperatorDelete(CXCXXDeleteExpr DE) {
  return static_cast<clang::CXXDeleteExpr *>(DE)->getOperatorDelete();
}

// CXXNewExpr
CXTypeSourceInfo clang_CXXNewExpr_getAllocatedTypeSourceInfo(CXCXXNewExpr E) {
  return const_cast<clang::TypeSourceInfo *>(static_cast<clang::CXXNewExpr *>(E)->getAllocatedTypeSourceInfo());
}

CXCXXConstructExpr clang_CXXNewExpr_getConstructExpr(CXCXXNewExpr E) {
  return const_cast<clang::CXXConstructExpr *>(static_cast<clang::CXXNewExpr *>(E)->getConstructExpr());
}

// MaterializeTemporaryExpr
CXExpr clang_MaterializeTemporaryExpr_getSubExpr(CXMaterializeTemporaryExpr E) {
  return const_cast<clang::Expr *>(static_cast<clang::MaterializeTemporaryExpr *>(E)->getSubExpr());
}

CXValueDecl clang_MaterializeTemporaryExpr_getExtendingDecl(CXMaterializeTemporaryExpr E) {
  return const_cast<clang::ValueDecl *>(static_cast<clang::MaterializeTemporaryExpr *>(E)->getExtendingDecl());
}

// LambdaExpr captures
unsigned clang_LambdaExpr_getNumCaptures(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->capture_size();
}

CXLambdaCapture clang_LambdaExpr_getCapture(CXLambdaExpr LE, unsigned I) {
  return const_cast<clang::LambdaCapture *>(
      static_cast<clang::LambdaExpr *>(LE)->capture_begin() + I);
}

bool clang_LambdaExpr_isGenericLambda(CXLambdaExpr LE) {
  return static_cast<clang::LambdaExpr *>(LE)->isGenericLambda();
}

// LambdaCapture
CXLambdaCaptureKind clang_LambdaCapture_getCaptureKind(CXLambdaCapture C) {
  return static_cast<CXLambdaCaptureKind>(
      static_cast<clang::LambdaCapture *>(C)->getCaptureKind());
}

bool clang_LambdaCapture_capturesThis(CXLambdaCapture C) {
  return static_cast<clang::LambdaCapture *>(C)->capturesThis();
}

bool clang_LambdaCapture_capturesVariable(CXLambdaCapture C) {
  return static_cast<clang::LambdaCapture *>(C)->capturesVariable();
}

bool clang_LambdaCapture_capturesVLAType(CXLambdaCapture C) {
  return static_cast<clang::LambdaCapture *>(C)->capturesVLAType();
}

CXValueDecl clang_LambdaCapture_getCapturedVar(CXLambdaCapture C) {
  return static_cast<clang::LambdaCapture *>(C)->getCapturedVar();
}

// CXXNoexceptExpr
CXExpr clang_CXXNoexceptExpr_getOperand(CXCXXNoexceptExpr E) {
  return static_cast<clang::CXXNoexceptExpr *>(E)->getOperand();
}

bool clang_CXXNoexceptExpr_getValue(CXCXXNoexceptExpr E) {
  return static_cast<clang::CXXNoexceptExpr *>(E)->getValue();
}

// CXXPseudoDestructorExpr
CXExpr clang_CXXPseudoDestructorExpr_getBase(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getBase();
}

bool clang_CXXPseudoDestructorExpr_hasQualifier(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->hasQualifier();
}

CXNestedNameSpecifier
clang_CXXPseudoDestructorExpr_getQualifier(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getQualifier();
}

bool clang_CXXPseudoDestructorExpr_isArrow(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->isArrow();
}

CXSourceLocation_
clang_CXXPseudoDestructorExpr_getOperatorLoc(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)
      ->getOperatorLoc()
      .getPtrEncoding();
}

CXTypeSourceInfo
clang_CXXPseudoDestructorExpr_getScopeTypeInfo(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getScopeTypeInfo();
}

CXSourceLocation_
clang_CXXPseudoDestructorExpr_getColonColonLoc(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)
      ->getColonColonLoc()
      .getPtrEncoding();
}

CXSourceLocation_ clang_CXXPseudoDestructorExpr_getTildeLoc(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getTildeLoc().getPtrEncoding();
}

CXTypeSourceInfo
clang_CXXPseudoDestructorExpr_getDestroyedTypeInfo(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getDestroyedTypeInfo();
}

CXIdentifierInfo
clang_CXXPseudoDestructorExpr_getDestroyedTypeIdentifier(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)->getDestroyedTypeIdentifier();
}

CXQualType clang_CXXPseudoDestructorExpr_getDestroyedType(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)
      ->getDestroyedType()
      .getAsOpaquePtr();
}

CXSourceLocation_
clang_CXXPseudoDestructorExpr_getDestroyedTypeLoc(CXCXXPseudoDestructorExpr E) {
  return static_cast<clang::CXXPseudoDestructorExpr *>(E)
      ->getDestroyedTypeLoc()
      .getPtrEncoding();
}

// CXXUnresolvedConstructExpr
CXQualType
clang_CXXUnresolvedConstructExpr_getTypeAsWritten(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)
      ->getTypeAsWritten()
      .getAsOpaquePtr();
}

CXSourceLocation_
clang_CXXUnresolvedConstructExpr_getLParenLoc(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)
      ->getLParenLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_CXXUnresolvedConstructExpr_getRParenLoc(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)
      ->getRParenLoc()
      .getPtrEncoding();
}

bool clang_CXXUnresolvedConstructExpr_isListInitialization(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)->isListInitialization();
}

unsigned clang_CXXUnresolvedConstructExpr_getNumArgs(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)->getNumArgs();
}

CXExpr clang_CXXUnresolvedConstructExpr_getArg(CXCXXUnresolvedConstructExpr E, unsigned I) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)->getArg(I);
}

void clang_CXXUnresolvedConstructExpr_setLParenLoc(CXCXXUnresolvedConstructExpr E,
                                                   CXSourceLocation_ Loc) {
  static_cast<clang::CXXUnresolvedConstructExpr *>(E)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXUnresolvedConstructExpr_setRParenLoc(CXCXXUnresolvedConstructExpr E,
                                                   CXSourceLocation_ Loc) {
  static_cast<clang::CXXUnresolvedConstructExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXUnresolvedConstructExpr_setArg(CXCXXUnresolvedConstructExpr E, unsigned I,
                                             CXExpr Arg) {
  static_cast<clang::CXXUnresolvedConstructExpr *>(E)->setArg(
      I, static_cast<clang::Expr *>(Arg));
}

// PackExpansionExpr
CXExpr clang_PackExpansionExpr_getPattern(CXPackExpansionExpr E) {
  return static_cast<clang::PackExpansionExpr *>(E)->getPattern();
}

CXSourceLocation_ clang_PackExpansionExpr_getEllipsisLoc(CXPackExpansionExpr E) {
  return static_cast<clang::PackExpansionExpr *>(E)->getEllipsisLoc().getPtrEncoding();
}

// DependentScopeDeclRefExpr
CXSourceLocation_
clang_DependentScopeDeclRefExpr_getLocation(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->getLocation().getPtrEncoding();
}

bool clang_DependentScopeDeclRefExpr_hasTemplateKeyword(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->hasTemplateKeyword();
}

bool clang_DependentScopeDeclRefExpr_hasExplicitTemplateArgs(
    CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_DependentScopeDeclRefExpr_getNumTemplateArgs(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->getNumTemplateArgs();
}

// OverloadExpr (base of UnresolvedLookupExpr and UnresolvedMemberExpr)
CXCXXRecordDecl clang_OverloadExpr_getNamingClass(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getNamingClass();
}

unsigned clang_OverloadExpr_getNumDecls(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getNumDecls();
}

CXDeclarationName clang_OverloadExpr_getName(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getName().getAsOpaquePtr();
}

CXSourceLocation_ clang_OverloadExpr_getNameLoc(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getNameLoc().getPtrEncoding();
}

CXNestedNameSpecifier clang_OverloadExpr_getQualifier(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getQualifier();
}

CXSourceLocation_ clang_OverloadExpr_getTemplateKeywordLoc(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getTemplateKeywordLoc().getPtrEncoding();
}

CXSourceLocation_ clang_OverloadExpr_getLAngleLoc(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getLAngleLoc().getPtrEncoding();
}

CXSourceLocation_ clang_OverloadExpr_getRAngleLoc(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getRAngleLoc().getPtrEncoding();
}

bool clang_OverloadExpr_hasTemplateKeyword(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->hasTemplateKeyword();
}

bool clang_OverloadExpr_hasExplicitTemplateArgs(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_OverloadExpr_getNumTemplateArgs(CXOverloadExpr E) {
  return static_cast<clang::OverloadExpr *>(E)->getNumTemplateArgs();
}

// UnresolvedLookupExpr
bool clang_UnresolvedLookupExpr_requiresADL(CXUnresolvedLookupExpr E) {
  return static_cast<clang::UnresolvedLookupExpr *>(E)->requiresADL();
}

bool clang_UnresolvedLookupExpr_isOverloaded(CXUnresolvedLookupExpr E) {
  return static_cast<clang::UnresolvedLookupExpr *>(E)->isOverloaded();
}

// UnresolvedMemberExpr
bool clang_UnresolvedMemberExpr_isImplicitAccess(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->isImplicitAccess();
}

CXExpr clang_UnresolvedMemberExpr_getBase(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->getBase();
}

CXQualType clang_UnresolvedMemberExpr_getBaseType(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->getBaseType().getAsOpaquePtr();
}

bool clang_UnresolvedMemberExpr_hasUnresolvedUsing(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->hasUnresolvedUsing();
}

bool clang_UnresolvedMemberExpr_isArrow(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->isArrow();
}

CXSourceLocation_ clang_UnresolvedMemberExpr_getOperatorLoc(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->getOperatorLoc().getPtrEncoding();
}

// CXXDynamicCastExpr
bool clang_CXXDynamicCastExpr_isAlwaysNull(CXCXXDynamicCastExpr E) {
  return static_cast<clang::CXXDynamicCastExpr *>(E)->isAlwaysNull();
}

// CXXDefaultArgExpr
bool clang_CXXDefaultArgExpr_hasRewrittenInit(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->hasRewrittenInit();
}

CXExpr clang_CXXDefaultArgExpr_getRewrittenExpr(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getRewrittenExpr();
}

CXDeclContext clang_CXXDefaultArgExpr_getUsedContext(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getUsedContext();
}

// CXXDefaultInitExpr
bool clang_CXXDefaultInitExpr_hasRewrittenInit(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->hasRewrittenInit();
}

CXExpr clang_CXXDefaultInitExpr_getRewrittenExpr(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->getRewrittenExpr();
}

CXDeclContext clang_CXXDefaultInitExpr_getUsedContext(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->getUsedContext();
}

// CXXBindTemporaryExpr
CXCXXTemporary clang_CXXBindTemporaryExpr_getTemporary(CXCXXBindTemporaryExpr E) {
  return static_cast<clang::CXXBindTemporaryExpr *>(E)->getTemporary();
}

// CXXTemporary
CXCXXDestructorDecl clang_CXXTemporary_getDestructor(CXCXXTemporary T) {
  return const_cast<clang::CXXDestructorDecl *>(
      static_cast<clang::CXXTemporary *>(T)->getDestructor());
}

// CXXFunctionalCastExpr
CXSourceLocation_ clang_CXXFunctionalCastExpr_getLParenLoc(CXCXXFunctionalCastExpr E) {
  return static_cast<clang::CXXFunctionalCastExpr *>(E)->getLParenLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXFunctionalCastExpr_getRParenLoc(CXCXXFunctionalCastExpr E) {
  return static_cast<clang::CXXFunctionalCastExpr *>(E)->getRParenLoc().getPtrEncoding();
}

bool clang_CXXFunctionalCastExpr_isListInitialization(CXCXXFunctionalCastExpr E) {
  return static_cast<clang::CXXFunctionalCastExpr *>(E)->isListInitialization();
}

// MaterializeTemporaryExpr
CXStorageDuration
clang_MaterializeTemporaryExpr_getStorageDuration(CXMaterializeTemporaryExpr E) {
  return static_cast<CXStorageDuration>(
      static_cast<clang::MaterializeTemporaryExpr *>(E)->getStorageDuration());
}

// ArrayTypeTraitExpr
CXArrayTypeTrait clang_ArrayTypeTraitExpr_getTrait(CXArrayTypeTraitExpr E) {
  return static_cast<CXArrayTypeTrait>(
      static_cast<clang::ArrayTypeTraitExpr *>(E)->getTrait());
}

CXQualType clang_ArrayTypeTraitExpr_getQueriedType(CXArrayTypeTraitExpr E) {
  return static_cast<clang::ArrayTypeTraitExpr *>(E)->getQueriedType().getAsOpaquePtr();
}

uint64_t clang_ArrayTypeTraitExpr_getValue(CXArrayTypeTraitExpr E) {
  return static_cast<clang::ArrayTypeTraitExpr *>(E)->getValue();
}

CXExpr clang_ArrayTypeTraitExpr_getDimensionExpression(CXArrayTypeTraitExpr E) {
  return static_cast<clang::ArrayTypeTraitExpr *>(E)->getDimensionExpression();
}

// ExpressionTraitExpr
CXExpressionTrait clang_ExpressionTraitExpr_getTrait(CXExpressionTraitExpr E) {
  return static_cast<CXExpressionTrait>(
      static_cast<clang::ExpressionTraitExpr *>(E)->getTrait());
}

CXExpr clang_ExpressionTraitExpr_getQueriedExpression(CXExpressionTraitExpr E) {
  return static_cast<clang::ExpressionTraitExpr *>(E)->getQueriedExpression();
}

bool clang_ExpressionTraitExpr_getValue(CXExpressionTraitExpr E) {
  return static_cast<clang::ExpressionTraitExpr *>(E)->getValue();
}

// SubstNonTypeTemplateParmExpr
CXSourceLocation_
clang_SubstNonTypeTemplateParmExpr_getNameLoc(CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)
      ->getNameLoc()
      .getPtrEncoding();
}

CXExpr clang_SubstNonTypeTemplateParmExpr_getReplacement(CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->getReplacement();
}

CXDecl
clang_SubstNonTypeTemplateParmExpr_getAssociatedDecl(CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->getAssociatedDecl();
}

unsigned clang_SubstNonTypeTemplateParmExpr_getIndex(CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->getIndex();
}

bool clang_SubstNonTypeTemplateParmExpr_getPackIndex(CXSubstNonTypeTemplateParmExpr E,
                                                     unsigned *I) {
  if (auto Idx = static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->getPackIndex()) {
    *I = *Idx;
    return true;
  }
  return false;
}

CXNonTypeTemplateParmDecl
clang_SubstNonTypeTemplateParmExpr_getParameter(CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->getParameter();
}

bool clang_SubstNonTypeTemplateParmExpr_isReferenceParameter(
    CXSubstNonTypeTemplateParmExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)->isReferenceParameter();
}

CXQualType
clang_SubstNonTypeTemplateParmExpr_getParameterType(CXSubstNonTypeTemplateParmExpr E,
                                                    CXASTContext Ctx) {
  return static_cast<clang::SubstNonTypeTemplateParmExpr *>(E)
      ->getParameterType(*static_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr();
}

// CXXOperatorCallExpr
bool clang_CXXOperatorCallExpr_isInfixBinaryOp(CXCXXOperatorCallExpr OCE) {
  return static_cast<clang::CXXOperatorCallExpr *>(OCE)->isInfixBinaryOp();
}

// CXXRewrittenBinaryOperator
bool clang_CXXRewrittenBinaryOperator_isComparisonOp(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)->isComparisonOp();
}

bool clang_CXXRewrittenBinaryOperator_isAssignmentOp(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)->isAssignmentOp();
}

CXSourceLocation_
clang_CXXRewrittenBinaryOperator_getOperatorLoc(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)
      ->getOperatorLoc()
      .getPtrEncoding();
}

// UserDefinedLiteral
CXSourceLocation_ clang_UserDefinedLiteral_getUDSuffixLoc(CXUserDefinedLiteral E) {
  return static_cast<clang::UserDefinedLiteral *>(E)->getUDSuffixLoc().getPtrEncoding();
}

// CXXDefaultArgExpr
CXExpr clang_CXXDefaultArgExpr_getAdjustedRewrittenExpr(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getAdjustedRewrittenExpr();
}

CXSourceLocation_ clang_CXXDefaultArgExpr_getUsedLocation(CXCXXDefaultArgExpr E) {
  return static_cast<clang::CXXDefaultArgExpr *>(E)->getUsedLocation().getPtrEncoding();
}

// CXXDefaultInitExpr
CXSourceLocation_ clang_CXXDefaultInitExpr_getUsedLocation(CXCXXDefaultInitExpr E) {
  return static_cast<clang::CXXDefaultInitExpr *>(E)->getUsedLocation().getPtrEncoding();
}

// ArrayTypeTraitExpr
CXTypeSourceInfo clang_ArrayTypeTraitExpr_getQueriedTypeSourceInfo(CXArrayTypeTraitExpr E) {
  return static_cast<clang::ArrayTypeTraitExpr *>(E)->getQueriedTypeSourceInfo();
}

// CXXUnresolvedConstructExpr
CXTypeSourceInfo
clang_CXXUnresolvedConstructExpr_getTypeSourceInfo(CXCXXUnresolvedConstructExpr E) {
  return static_cast<clang::CXXUnresolvedConstructExpr *>(E)->getTypeSourceInfo();
}

// PackExpansionExpr
bool clang_PackExpansionExpr_getNumExpansions(CXPackExpansionExpr E, unsigned *N) {
  if (auto Num = static_cast<clang::PackExpansionExpr *>(E)->getNumExpansions()) {
    *N = *Num;
    return true;
  }
  return false;
}

// MaterializeTemporaryExpr
CXLifetimeExtendedTemporaryDecl
clang_MaterializeTemporaryExpr_getLifetimeExtendedTemporaryDecl(
    CXMaterializeTemporaryExpr E) {
  return static_cast<clang::MaterializeTemporaryExpr *>(E)
      ->getLifetimeExtendedTemporaryDecl();
}

CXAPValue clang_MaterializeTemporaryExpr_getOrCreateValue(CXMaterializeTemporaryExpr E,
                                                          bool MayCreate) {
  return static_cast<clang::MaterializeTemporaryExpr *>(E)->getOrCreateValue(MayCreate);
}

bool clang_MaterializeTemporaryExpr_isUsableInConstantExpressions(
    CXMaterializeTemporaryExpr E, CXASTContext Ctx) {
  return static_cast<clang::MaterializeTemporaryExpr *>(E)->isUsableInConstantExpressions(
      *static_cast<clang::ASTContext *>(Ctx));
}

// CXXFoldExpr
bool clang_CXXFoldExpr_getNumExpansions(CXCXXFoldExpr E, unsigned *N) {
  if (auto Num = static_cast<clang::CXXFoldExpr *>(E)->getNumExpansions()) {
    *N = *Num;
    return true;
  }
  return false;
}

// CoroutineSuspendExpr
CXOpaqueValueExpr clang_CoroutineSuspendExpr_getOpaqueValue(CXCoroutineSuspendExpr E) {
  return static_cast<clang::CoroutineSuspendExpr *>(E)->getOpaqueValue();
}

// CoawaitExpr
bool clang_CoawaitExpr_isImplicit(CXCoawaitExpr E) {
  return static_cast<clang::CoawaitExpr *>(E)->isImplicit();
}

// DependentCoawaitExpr
CXExpr clang_DependentCoawaitExpr_getOperand(CXDependentCoawaitExpr E) {
  return static_cast<clang::DependentCoawaitExpr *>(E)->getOperand();
}

CXUnresolvedLookupExpr
clang_DependentCoawaitExpr_getOperatorCoawaitLookup(CXDependentCoawaitExpr E) {
  return static_cast<clang::DependentCoawaitExpr *>(E)->getOperatorCoawaitLookup();
}

CXSourceLocation_ clang_DependentCoawaitExpr_getKeywordLoc(CXDependentCoawaitExpr E) {
  return static_cast<clang::DependentCoawaitExpr *>(E)->getKeywordLoc().getPtrEncoding();
}

// CXXDependentScopeMemberExpr
bool clang_CXXDependentScopeMemberExpr_isImplicitAccess(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->isImplicitAccess();
}

CXExpr clang_CXXDependentScopeMemberExpr_getBase(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getBase();
}

CXQualType clang_CXXDependentScopeMemberExpr_getBaseType(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getBaseType()
      .getAsOpaquePtr();
}

bool clang_CXXDependentScopeMemberExpr_isArrow(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->isArrow();
}

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getOperatorLoc(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getOperatorLoc()
      .getPtrEncoding();
}

CXNestedNameSpecifier
clang_CXXDependentScopeMemberExpr_getQualifier(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getQualifier();
}

CXNamedDecl clang_CXXDependentScopeMemberExpr_getFirstQualifierFoundInScope(
    CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getFirstQualifierFoundInScope();
}

CXDeclarationName
clang_CXXDependentScopeMemberExpr_getMember(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getMember().getAsOpaquePtr();
}

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getMemberLoc(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getMemberLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getTemplateKeywordLoc(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getTemplateKeywordLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getLAngleLoc(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getLAngleLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_CXXDependentScopeMemberExpr_getRAngleLoc(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)
      ->getRAngleLoc()
      .getPtrEncoding();
}

bool clang_CXXDependentScopeMemberExpr_hasTemplateKeyword(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->hasTemplateKeyword();
}

bool clang_CXXDependentScopeMemberExpr_hasExplicitTemplateArgs(
    CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned
clang_CXXDependentScopeMemberExpr_getNumTemplateArgs(CXCXXDependentScopeMemberExpr E) {
  return static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getNumTemplateArgs();
}

// DependentScopeDeclRefExpr
CXDeclarationName
clang_DependentScopeDeclRefExpr_getDeclName(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->getDeclName().getAsOpaquePtr();
}

CXNestedNameSpecifier
clang_DependentScopeDeclRefExpr_getQualifier(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)->getQualifier();
}

CXSourceLocation_
clang_DependentScopeDeclRefExpr_getTemplateKeywordLoc(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)
      ->getTemplateKeywordLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_DependentScopeDeclRefExpr_getLAngleLoc(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)
      ->getLAngleLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_DependentScopeDeclRefExpr_getRAngleLoc(CXDependentScopeDeclRefExpr E) {
  return static_cast<clang::DependentScopeDeclRefExpr *>(E)
      ->getRAngleLoc()
      .getPtrEncoding();
}

// CXXConstructExpr
void clang_CXXConstructExpr_setLocation(CXCXXConstructExpr E, CXSourceLocation_ Loc) {
  static_cast<clang::CXXConstructExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXConstructExpr_setElidable(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setElidable(V);
}

void clang_CXXConstructExpr_setHadMultipleCandidates(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setHadMultipleCandidates(V);
}

void clang_CXXConstructExpr_setListInitialization(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setListInitialization(V);
}

void clang_CXXConstructExpr_setStdInitListInitialization(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setStdInitListInitialization(V);
}

void clang_CXXConstructExpr_setRequiresZeroInitialization(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setRequiresZeroInitialization(V);
}

void clang_CXXConstructExpr_setConstructionKind(CXCXXConstructExpr E,
                                                CXCXXConstructionKind CK) {
  static_cast<clang::CXXConstructExpr *>(E)->setConstructionKind(
      static_cast<clang::CXXConstructionKind>(CK));
}

void clang_CXXConstructExpr_setArg(CXCXXConstructExpr E, unsigned Arg, CXExpr ArgExpr) {
  static_cast<clang::CXXConstructExpr *>(E)->setArg(Arg,
                                                    static_cast<clang::Expr *>(ArgExpr));
}

void clang_CXXConstructExpr_setIsImmediateEscalating(CXCXXConstructExpr E, bool V) {
  static_cast<clang::CXXConstructExpr *>(E)->setIsImmediateEscalating(V);
}

void clang_CXXConstructExpr_setParenOrBraceRange(CXCXXConstructExpr E, CXSourceRange_ R) {
  static_cast<clang::CXXConstructExpr *>(E)->setParenOrBraceRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
}

// CXXThisExpr
void clang_CXXThisExpr_setLocation(CXCXXThisExpr E, CXSourceLocation_ Loc) {
  static_cast<clang::CXXThisExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_CXXThisExpr_setImplicit(CXCXXThisExpr E, bool V) {
  static_cast<clang::CXXThisExpr *>(E)->setImplicit(V);
}

// CXXBoolLiteralExpr
void clang_CXXBoolLiteralExpr_setValue(CXCXXBoolLiteralExpr E, bool V) {
  static_cast<clang::CXXBoolLiteralExpr *>(E)->setValue(V);
}

void clang_CXXBoolLiteralExpr_setLocation(CXCXXBoolLiteralExpr E, CXSourceLocation_ Loc) {
  static_cast<clang::CXXBoolLiteralExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CXXNullPtrLiteralExpr
void clang_CXXNullPtrLiteralExpr_setLocation(CXCXXNullPtrLiteralExpr E,
                                             CXSourceLocation_ Loc) {
  static_cast<clang::CXXNullPtrLiteralExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// OverloadExpr
CXNamedDecl clang_OverloadExpr_getDecl(CXOverloadExpr E, unsigned I) {
  return (static_cast<clang::OverloadExpr *>(E)->decls_begin() + I).getDecl();
}

CXAccessSpecifier clang_OverloadExpr_getDeclAccess(CXOverloadExpr E, unsigned I) {
  return static_cast<CXAccessSpecifier>(
      (static_cast<clang::OverloadExpr *>(E)->decls_begin() + I).getAccess());
}

CXTemplateArgumentLoc clang_OverloadExpr_getTemplateArg(CXOverloadExpr E, unsigned I) {
  return const_cast<clang::TemplateArgumentLoc *>(
      static_cast<clang::OverloadExpr *>(E)->getTemplateArgs() + I);
}

// CXXDependentScopeMemberExpr
CXTemplateArgumentLoc
clang_CXXDependentScopeMemberExpr_getTemplateArg(CXCXXDependentScopeMemberExpr E,
                                                 unsigned I) {
  return const_cast<clang::TemplateArgumentLoc *>(
      static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getTemplateArgs() + I);
}

// DependentScopeDeclRefExpr
CXTemplateArgumentLoc
clang_DependentScopeDeclRefExpr_getTemplateArg(CXDependentScopeDeclRefExpr E, unsigned I) {
  return const_cast<clang::TemplateArgumentLoc *>(
      static_cast<clang::DependentScopeDeclRefExpr *>(E)->getTemplateArgs() + I);
}

// CXXRewrittenBinaryOperator
const char *clang_CXXRewrittenBinaryOperator_getOpcodeStr(CXCXXRewrittenBinaryOperator E) {
  return static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getOpcodeStr().data();
}

// MSPropertyRefExpr
bool clang_MSPropertyRefExpr_isImplicitAccess(CXMSPropertyRefExpr E) {
  return static_cast<clang::MSPropertyRefExpr *>(E)->isImplicitAccess();
}

CXExpr clang_MSPropertyRefExpr_getBaseExpr(CXMSPropertyRefExpr E) {
  return static_cast<clang::MSPropertyRefExpr *>(E)->getBaseExpr();
}

CXMSPropertyDecl clang_MSPropertyRefExpr_getPropertyDecl(CXMSPropertyRefExpr E) {
  return static_cast<clang::MSPropertyRefExpr *>(E)->getPropertyDecl();
}

bool clang_MSPropertyRefExpr_isArrow(CXMSPropertyRefExpr E) {
  return static_cast<clang::MSPropertyRefExpr *>(E)->isArrow();
}

CXSourceLocation_ clang_MSPropertyRefExpr_getMemberLoc(CXMSPropertyRefExpr E) {
  return static_cast<clang::MSPropertyRefExpr *>(E)->getMemberLoc().getPtrEncoding();
}

// MSPropertySubscriptExpr
CXExpr clang_MSPropertySubscriptExpr_getBase(CXMSPropertySubscriptExpr E) {
  return static_cast<clang::MSPropertySubscriptExpr *>(E)->getBase();
}

CXExpr clang_MSPropertySubscriptExpr_getIdx(CXMSPropertySubscriptExpr E) {
  return static_cast<clang::MSPropertySubscriptExpr *>(E)->getIdx();
}

CXSourceLocation_
clang_MSPropertySubscriptExpr_getRBracketLoc(CXMSPropertySubscriptExpr E) {
  return static_cast<clang::MSPropertySubscriptExpr *>(E)
      ->getRBracketLoc()
      .getPtrEncoding();
}

void clang_MSPropertySubscriptExpr_setRBracketLoc(CXMSPropertySubscriptExpr E,
                                                  CXSourceLocation_ Loc) {
  static_cast<clang::MSPropertySubscriptExpr *>(E)->setRBracketLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// CXXParenListInitExpr
unsigned clang_CXXParenListInitExpr_getNumInitExprs(CXCXXParenListInitExpr E) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getInitExprs().size();
}

CXExpr clang_CXXParenListInitExpr_getInitExpr(CXCXXParenListInitExpr E, unsigned I) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getInitExprs()[I];
}

unsigned clang_CXXParenListInitExpr_getNumUserSpecifiedInitExprs(CXCXXParenListInitExpr E) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getUserSpecifiedInitExprs().size();
}

CXExpr clang_CXXParenListInitExpr_getUserSpecifiedInitExpr(CXCXXParenListInitExpr E,
                                                           unsigned I) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getUserSpecifiedInitExprs()[I];
}

CXSourceLocation_ clang_CXXParenListInitExpr_getInitLoc(CXCXXParenListInitExpr E) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getInitLoc().getPtrEncoding();
}

CXExpr clang_CXXParenListInitExpr_getArrayFiller(CXCXXParenListInitExpr E) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getArrayFiller();
}

CXFieldDecl
clang_CXXParenListInitExpr_getInitializedFieldInUnion(CXCXXParenListInitExpr E) {
  return static_cast<clang::CXXParenListInitExpr *>(E)->getInitializedFieldInUnion();
}

// CXXTypeidExpr (cont.)
void clang_CXXTypeidExpr_setSourceRange(CXCXXTypeidExpr E, CXSourceRange_ R) {
  static_cast<clang::CXXTypeidExpr *>(E)->setSourceRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
}

// CXXUuidofExpr
bool clang_CXXUuidofExpr_isTypeOperand(CXCXXUuidofExpr E) {
  return static_cast<clang::CXXUuidofExpr *>(E)->isTypeOperand();
}

CXQualType clang_CXXUuidofExpr_getTypeOperand(CXCXXUuidofExpr E, CXASTContext Ctx) {
  return static_cast<clang::CXXUuidofExpr *>(E)
      ->getTypeOperand(*static_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr();
}

CXTypeSourceInfo clang_CXXUuidofExpr_getTypeOperandSourceInfo(CXCXXUuidofExpr E) {
  return static_cast<clang::CXXUuidofExpr *>(E)->getTypeOperandSourceInfo();
}

CXExpr clang_CXXUuidofExpr_getExprOperand(CXCXXUuidofExpr E) {
  return static_cast<clang::CXXUuidofExpr *>(E)->getExprOperand();
}

CXMSGuidDecl clang_CXXUuidofExpr_getGuidDecl(CXCXXUuidofExpr E) {
  return static_cast<clang::CXXUuidofExpr *>(E)->getGuidDecl();
}

void clang_CXXUuidofExpr_setSourceRange(CXCXXUuidofExpr E, CXSourceRange_ R) {
  static_cast<clang::CXXUuidofExpr *>(E)->setSourceRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
}

// CXXThisExpr (cont.)
CXCXXThisExpr clang_CXXThisExpr_Create(CXASTContext Ctx, CXSourceLocation_ L, CXQualType Ty,
                                       bool IsImplicit) {
  return clang::CXXThisExpr::Create(*static_cast<clang::ASTContext *>(Ctx),
                                    clang::SourceLocation::getFromPtrEncoding(L),
                                    clang::QualType::getFromOpaquePtr(Ty), IsImplicit);
}

CXCXXThisExpr clang_CXXThisExpr_CreateEmpty(CXASTContext Ctx) {
  return clang::CXXThisExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx));
}

// CXXTemporary (cont.)
CXCXXTemporary clang_CXXTemporary_Create(CXASTContext Ctx, CXCXXDestructorDecl Destructor) {
  return clang::CXXTemporary::Create(*static_cast<clang::ASTContext *>(Ctx),
                                     static_cast<clang::CXXDestructorDecl *>(Destructor));
}

void clang_CXXTemporary_setDestructor(CXCXXTemporary T, CXCXXDestructorDecl Dtor) {
  static_cast<clang::CXXTemporary *>(T)->setDestructor(
      static_cast<clang::CXXDestructorDecl *>(Dtor));
}

// CXXBindTemporaryExpr (cont.)
void clang_CXXBindTemporaryExpr_setTemporary(CXCXXBindTemporaryExpr E, CXCXXTemporary T) {
  static_cast<clang::CXXBindTemporaryExpr *>(E)->setTemporary(
      static_cast<clang::CXXTemporary *>(T));
}

void clang_CXXBindTemporaryExpr_setSubExpr(CXCXXBindTemporaryExpr E, CXExpr Sub) {
  static_cast<clang::CXXBindTemporaryExpr *>(E)->setSubExpr(
      static_cast<clang::Expr *>(Sub));
}

// CXXFunctionalCastExpr (cont.)
void clang_CXXFunctionalCastExpr_setLParenLoc(CXCXXFunctionalCastExpr E,
                                              CXSourceLocation_ L) {
  static_cast<clang::CXXFunctionalCastExpr *>(E)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_CXXFunctionalCastExpr_setRParenLoc(CXCXXFunctionalCastExpr E,
                                              CXSourceLocation_ L) {
  static_cast<clang::CXXFunctionalCastExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CXXNewExpr (cont.)
void clang_CXXNewExpr_setOperatorNew(CXCXXNewExpr NE, CXFunctionDecl D) {
  static_cast<clang::CXXNewExpr *>(NE)->setOperatorNew(
      static_cast<clang::FunctionDecl *>(D));
}

void clang_CXXNewExpr_setOperatorDelete(CXCXXNewExpr NE, CXFunctionDecl D) {
  static_cast<clang::CXXNewExpr *>(NE)->setOperatorDelete(
      static_cast<clang::FunctionDecl *>(D));
}

// CXXParenListInitExpr (cont.)
void clang_CXXParenListInitExpr_setArrayFiller(CXCXXParenListInitExpr E, CXExpr Filler) {
  static_cast<clang::CXXParenListInitExpr *>(E)->setArrayFiller(
      static_cast<clang::Expr *>(Filler));
}

void clang_CXXParenListInitExpr_setInitializedFieldInUnion(CXCXXParenListInitExpr E,
                                                           CXFieldDecl FD) {
  static_cast<clang::CXXParenListInitExpr *>(E)->setInitializedFieldInUnion(
      static_cast<clang::FieldDecl *>(FD));
}

// CXXRewrittenBinaryOperator (cont.)
CXExpr clang_CXXRewrittenBinaryOperator_getInnerBinOp(CXCXXRewrittenBinaryOperator E) {
  auto D = static_cast<clang::CXXRewrittenBinaryOperator *>(E)->getDecomposedForm();
  return const_cast<clang::Expr *>(D.InnerBinOp);
}

// CXXConstCastExpr
CXCXXConstCastExpr
clang_CXXConstCastExpr_Create(CXASTContext Ctx, CXQualType T, CXExprValueKind VK, CXExpr Op,
                              CXTypeSourceInfo WrittenTy, CXSourceLocation_ L,
                              CXSourceLocation_ RParenLoc, CXSourceRange_ AngleBrackets) {
  return clang::CXXConstCastExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::Expr *>(Op),
      static_cast<clang::TypeSourceInfo *>(WrittenTy),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBrackets.B),
                         clang::SourceLocation::getFromPtrEncoding(AngleBrackets.E)));
}

// CXXBoolLiteralExpr (cont.)
CXCXXBoolLiteralExpr clang_CXXBoolLiteralExpr_Create(CXASTContext C, bool Val,
                                                     CXQualType Ty, CXSourceLocation_ Loc) {
  return clang::CXXBoolLiteralExpr::Create(*static_cast<clang::ASTContext *>(C), Val,
                                           clang::QualType::getFromOpaquePtr(Ty),
                                           clang::SourceLocation::getFromPtrEncoding(Loc));
}

// MSPropertyRefExpr (cont.)
CXSourceRange_ clang_MSPropertyRefExpr_getQualifierRange(CXMSPropertyRefExpr E) {
  auto Q = static_cast<clang::MSPropertyRefExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// CXXDefaultArgExpr (cont.)
CXCXXDefaultArgExpr clang_CXXDefaultArgExpr_Create(CXASTContext C, CXSourceLocation_ Loc,
                                                   CXParmVarDecl Param,
                                                   CXExpr RewrittenExpr,
                                                   CXDeclContext UsedContext) {
  return clang::CXXDefaultArgExpr::Create(
      *static_cast<clang::ASTContext *>(C), clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::ParmVarDecl *>(Param), static_cast<clang::Expr *>(RewrittenExpr),
      static_cast<clang::DeclContext *>(UsedContext));
}

// CXXDefaultInitExpr (cont.)
CXCXXDefaultInitExpr
clang_CXXDefaultInitExpr_Create(CXASTContext Ctx, CXSourceLocation_ Loc, CXFieldDecl Field,
                                CXDeclContext UsedContext, CXExpr RewrittenInitExpr) {
  return clang::CXXDefaultInitExpr::Create(*static_cast<clang::ASTContext *>(Ctx),
                                           clang::SourceLocation::getFromPtrEncoding(Loc),
                                           static_cast<clang::FieldDecl *>(Field),
                                           static_cast<clang::DeclContext *>(UsedContext),
                                           static_cast<clang::Expr *>(RewrittenInitExpr));
}

// CXXBindTemporaryExpr (cont.)
CXCXXBindTemporaryExpr
clang_CXXBindTemporaryExpr_Create(CXASTContext C, CXCXXTemporary Temp, CXExpr SubExpr) {
  return clang::CXXBindTemporaryExpr::Create(*static_cast<clang::ASTContext *>(C),
                                             static_cast<clang::CXXTemporary *>(Temp),
                                             static_cast<clang::Expr *>(SubExpr));
}

// LambdaExpr (cont.)
unsigned clang_LambdaExpr_getNumExplicitTemplateParameters(CXLambdaExpr E) {
  return static_cast<clang::LambdaExpr *>(E)->getExplicitTemplateParameters().size();
}

CXNamedDecl clang_LambdaExpr_getExplicitTemplateParameter(CXLambdaExpr E, unsigned I) {
  return static_cast<clang::LambdaExpr *>(E)->getExplicitTemplateParameters()[I];
}

// CXXPseudoDestructorExpr (cont.)
CXSourceRange_
clang_CXXPseudoDestructorExpr_getQualifierRange(CXCXXPseudoDestructorExpr E) {
  auto Q = static_cast<clang::CXXPseudoDestructorExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// OverloadExpr (cont.)
CXDeclarationNameInfo clang_OverloadExpr_getNameInfo(CXOverloadExpr E) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::OverloadExpr *>(E)->getNameInfo())
      .release();
}

CXSourceRange_ clang_OverloadExpr_getQualifierRange(CXOverloadExpr E) {
  auto Q = static_cast<clang::OverloadExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// DependentScopeDeclRefExpr (cont.)
CXDeclarationNameInfo
clang_DependentScopeDeclRefExpr_getNameInfo(CXDependentScopeDeclRefExpr E) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::DependentScopeDeclRefExpr *>(E)->getNameInfo())
      .release();
}

CXSourceRange_
clang_DependentScopeDeclRefExpr_getQualifierRange(CXDependentScopeDeclRefExpr E) {
  auto Q = static_cast<clang::DependentScopeDeclRefExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// CXXDependentScopeMemberExpr (cont.)
CXDeclarationNameInfo
clang_CXXDependentScopeMemberExpr_getMemberNameInfo(CXCXXDependentScopeMemberExpr E) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getMemberNameInfo())
      .release();
}

CXSourceRange_
clang_CXXDependentScopeMemberExpr_getQualifierRange(CXCXXDependentScopeMemberExpr E) {
  auto Q = static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// MSPropertyRefExpr (cont.)
CXNestedNameSpecifierLoc clang_MSPropertyRefExpr_getQualifierLoc(CXMSPropertyRefExpr E) {
  return new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      static_cast<clang::MSPropertyRefExpr *>(E)->getQualifierLoc());
}

// CXXPseudoDestructorExpr (cont.)
CXNestedNameSpecifierLoc
clang_CXXPseudoDestructorExpr_getQualifierLoc(CXCXXPseudoDestructorExpr E) {
  return new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      static_cast<clang::CXXPseudoDestructorExpr *>(E)->getQualifierLoc());
}

// OverloadExpr (cont.)
CXNestedNameSpecifierLoc clang_OverloadExpr_getQualifierLoc(CXOverloadExpr E) {
  return new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      static_cast<clang::OverloadExpr *>(E)->getQualifierLoc());
}

// DependentScopeDeclRefExpr (cont.)
CXNestedNameSpecifierLoc
clang_DependentScopeDeclRefExpr_getQualifierLoc(CXDependentScopeDeclRefExpr E) {
  return new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      static_cast<clang::DependentScopeDeclRefExpr *>(E)->getQualifierLoc());
}

// CXXDependentScopeMemberExpr (cont.)
CXNestedNameSpecifierLoc
clang_CXXDependentScopeMemberExpr_getQualifierLoc(CXCXXDependentScopeMemberExpr E) {
  return new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      static_cast<clang::CXXDependentScopeMemberExpr *>(E)->getQualifierLoc());
}

// CXXStaticCastExpr
CXCXXStaticCastExpr clang_CXXStaticCastExpr_Create(CXASTContext Context, CXQualType T,
                                                   CXExprValueKind VK, CXCastKind K,
                                                   CXExpr Op, CXTypeSourceInfo Written,
                                                   uint64_t FPFeatures, CXSourceLocation_ L,
                                                   CXSourceLocation_ RParenLoc,
                                                   CXSourceRange_ AngleBrackets) {
  return clang::CXXStaticCastExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(K),
      static_cast<clang::Expr *>(Op), nullptr,
      static_cast<clang::TypeSourceInfo *>(Written),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBrackets.B),
                         clang::SourceLocation::getFromPtrEncoding(AngleBrackets.E)));
}

CXCXXStaticCastExpr clang_CXXStaticCastExpr_CreateEmpty(CXASTContext Context,
                                                        unsigned PathSize,
                                                        bool HasFPFeatures) {
  return clang::CXXStaticCastExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Context),
                                               PathSize, HasFPFeatures);
}

// CXXDynamicCastExpr
CXCXXDynamicCastExpr clang_CXXDynamicCastExpr_Create(CXASTContext Context, CXQualType T,
                                                     CXExprValueKind VK, CXCastKind Kind,
                                                     CXExpr Op, CXTypeSourceInfo Written,
                                                     CXSourceLocation_ L,
                                                     CXSourceLocation_ RParenLoc,
                                                     CXSourceRange_ AngleBrackets) {
  return clang::CXXDynamicCastExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(Kind),
      static_cast<clang::Expr *>(Op), nullptr,
      static_cast<clang::TypeSourceInfo *>(Written),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBrackets.B),
                         clang::SourceLocation::getFromPtrEncoding(AngleBrackets.E)));
}

CXCXXDynamicCastExpr clang_CXXDynamicCastExpr_CreateEmpty(CXASTContext Context,
                                                          unsigned PathSize) {
  return clang::CXXDynamicCastExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Context),
                                                PathSize);
}

// CXXReinterpretCastExpr
CXCXXReinterpretCastExpr
clang_CXXReinterpretCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                    CXCastKind Kind, CXExpr Op, CXTypeSourceInfo WrittenTy,
                                    CXSourceLocation_ L, CXSourceLocation_ RParenLoc,
                                    CXSourceRange_ AngleBrackets) {
  return clang::CXXReinterpretCastExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(Kind),
      static_cast<clang::Expr *>(Op), nullptr,
      static_cast<clang::TypeSourceInfo *>(WrittenTy),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBrackets.B),
                         clang::SourceLocation::getFromPtrEncoding(AngleBrackets.E)));
}

CXCXXReinterpretCastExpr clang_CXXReinterpretCastExpr_CreateEmpty(CXASTContext Context,
                                                                  unsigned PathSize) {
  return clang::CXXReinterpretCastExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), PathSize);
}

// CXXConstCastExpr (cont.)
CXCXXConstCastExpr clang_CXXConstCastExpr_CreateEmpty(CXASTContext Context) {
  return clang::CXXConstCastExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Context));
}

// CXXAddrspaceCastExpr
CXCXXAddrspaceCastExpr
clang_CXXAddrspaceCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                  CXCastKind Kind, CXExpr Op, CXTypeSourceInfo WrittenTy,
                                  CXSourceLocation_ L, CXSourceLocation_ RParenLoc,
                                  CXSourceRange_ AngleBrackets) {
  return clang::CXXAddrspaceCastExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(Kind),
      static_cast<clang::Expr *>(Op), static_cast<clang::TypeSourceInfo *>(WrittenTy),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBrackets.B),
                         clang::SourceLocation::getFromPtrEncoding(AngleBrackets.E)));
}

CXCXXAddrspaceCastExpr clang_CXXAddrspaceCastExpr_CreateEmpty(CXASTContext Context) {
  return clang::CXXAddrspaceCastExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context));
}

// CXXFunctionalCastExpr (cont.)
CXCXXFunctionalCastExpr
clang_CXXFunctionalCastExpr_Create(CXASTContext Context, CXQualType T, CXExprValueKind VK,
                                   CXTypeSourceInfo Written, CXCastKind Kind, CXExpr Op,
                                   uint64_t FPFeatures, CXSourceLocation_ LPLoc,
                                   CXSourceLocation_ RPLoc) {
  return clang::CXXFunctionalCastExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::TypeSourceInfo *>(Written),
      static_cast<clang::CastKind>(Kind), static_cast<clang::Expr *>(Op), nullptr,
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures),
      clang::SourceLocation::getFromPtrEncoding(LPLoc),
      clang::SourceLocation::getFromPtrEncoding(RPLoc));
}

CXCXXFunctionalCastExpr clang_CXXFunctionalCastExpr_CreateEmpty(CXASTContext Context,
                                                                unsigned PathSize,
                                                                bool HasFPFeatures) {
  return clang::CXXFunctionalCastExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), PathSize, HasFPFeatures);
}

// FunctionParmPackExpr
CXFunctionParmPackExpr clang_FunctionParmPackExpr_Create(CXASTContext Context, CXQualType T,
                                                         CXVarDecl ParamPack,
                                                         CXSourceLocation_ NameLoc,
                                                         const CXVarDecl *Params,
                                                         unsigned NumParams) {
  llvm::SmallVector<clang::VarDecl *, 8> Expansions;
  Expansions.reserve(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    Expansions.push_back(static_cast<clang::VarDecl *>(Params[I]));
  return clang::FunctionParmPackExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::VarDecl *>(ParamPack),
      clang::SourceLocation::getFromPtrEncoding(NameLoc), Expansions);
}

CXVarDecl clang_FunctionParmPackExpr_getParameterPack(CXFunctionParmPackExpr E) {
  return static_cast<clang::FunctionParmPackExpr *>(E)->getParameterPack();
}

CXSourceLocation_
clang_FunctionParmPackExpr_getParameterPackLocation(CXFunctionParmPackExpr E) {
  return static_cast<clang::FunctionParmPackExpr *>(E)
      ->getParameterPackLocation()
      .getPtrEncoding();
}

unsigned clang_FunctionParmPackExpr_getNumExpansions(CXFunctionParmPackExpr E) {
  return static_cast<clang::FunctionParmPackExpr *>(E)->getNumExpansions();
}

CXVarDecl clang_FunctionParmPackExpr_getExpansion(CXFunctionParmPackExpr E, unsigned I) {
  return static_cast<clang::FunctionParmPackExpr *>(E)->getExpansion(I);
}

// SubstNonTypeTemplateParmPackExpr
CXSubstNonTypeTemplateParmPackExpr clang_SubstNonTypeTemplateParmPackExpr_Create(
    CXASTContext Context, CXQualType T, CXExprValueKind ValueKind,
    CXSourceLocation_ NameLoc, const CXTemplateArgument *Args, unsigned NumArgs,
    CXDecl AssociatedDecl, unsigned Index) {
  auto &Ctx = *static_cast<clang::ASTContext *>(Context);
  llvm::SmallVector<clang::TemplateArgument, 8> Pack;
  Pack.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Pack.push_back(*static_cast<clang::TemplateArgument *>(Args[I]));
  clang::TemplateArgument ArgPack = clang::TemplateArgument::CreatePackCopy(Ctx, Pack);
  return new (Ctx) clang::SubstNonTypeTemplateParmPackExpr(
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::ExprValueKind>(ValueKind),
      clang::SourceLocation::getFromPtrEncoding(NameLoc), ArgPack,
      static_cast<clang::Decl *>(AssociatedDecl), Index);
}

CXDecl clang_SubstNonTypeTemplateParmPackExpr_getAssociatedDecl(
    CXSubstNonTypeTemplateParmPackExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmPackExpr *>(E)->getAssociatedDecl();
}

unsigned
clang_SubstNonTypeTemplateParmPackExpr_getIndex(CXSubstNonTypeTemplateParmPackExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmPackExpr *>(E)->getIndex();
}

CXNonTypeTemplateParmDecl clang_SubstNonTypeTemplateParmPackExpr_getParameterPack(
    CXSubstNonTypeTemplateParmPackExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmPackExpr *>(E)->getParameterPack();
}

CXSourceLocation_ clang_SubstNonTypeTemplateParmPackExpr_getParameterPackLocation(
    CXSubstNonTypeTemplateParmPackExpr E) {
  return static_cast<clang::SubstNonTypeTemplateParmPackExpr *>(E)
      ->getParameterPackLocation()
      .getPtrEncoding();
}

CXTemplateArgument clang_SubstNonTypeTemplateParmPackExpr_getArgumentPack(
    CXSubstNonTypeTemplateParmPackExpr E) {
  auto *P = static_cast<clang::SubstNonTypeTemplateParmPackExpr *>(E);
  return std::make_unique<clang::TemplateArgument>(P->getArgumentPack()).release();
}

// CXXParenListInitExpr (cont.)
CXCXXParenListInitExpr clang_CXXParenListInitExpr_Create(CXASTContext C, const CXExpr *Args,
                                                         unsigned NumArgs, CXQualType T,
                                                         unsigned NumUserSpecifiedExprs,
                                                         CXSourceLocation_ InitLoc,
                                                         CXSourceLocation_ LParenLoc,
                                                         CXSourceLocation_ RParenLoc) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXParenListInitExpr::Create(
      *static_cast<clang::ASTContext *>(C), Exprs, clang::QualType::getFromOpaquePtr(T),
      NumUserSpecifiedExprs, clang::SourceLocation::getFromPtrEncoding(InitLoc),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
}

CXCXXParenListInitExpr clang_CXXParenListInitExpr_CreateEmpty(CXASTContext C,
                                                              unsigned NumExprs) {
  return clang::CXXParenListInitExpr::CreateEmpty(*static_cast<clang::ASTContext *>(C),
                                                  NumExprs, clang::Stmt::EmptyShell());
}

// CXXUnresolvedConstructExpr (cont.)
CXCXXUnresolvedConstructExpr clang_CXXUnresolvedConstructExpr_Create(
    CXASTContext Context, CXQualType T, CXTypeSourceInfo TSI, CXSourceLocation_ LParenLoc,
    const CXExpr *Args, unsigned NumArgs, CXSourceLocation_ RParenLoc, bool IsListInit) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXUnresolvedConstructExpr::Create(
      *static_cast<clang::ASTContext *>(Context), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::TypeSourceInfo *>(TSI),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), Exprs,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), IsListInit);
}

CXCXXUnresolvedConstructExpr
clang_CXXUnresolvedConstructExpr_CreateEmpty(CXASTContext Context, unsigned NumArgs) {
  return clang::CXXUnresolvedConstructExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), NumArgs);
}

// CXXConstructExpr (cont.)
CXCXXConstructExpr clang_CXXConstructExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs) {
  return clang::CXXConstructExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                              NumArgs);
}

// CXXTemporaryObjectExpr (cont.)
CXCXXTemporaryObjectExpr clang_CXXTemporaryObjectExpr_CreateEmpty(CXASTContext Ctx,
                                                                  unsigned NumArgs) {
  return clang::CXXTemporaryObjectExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                                    NumArgs);
}

// CXXNewExpr (cont.)
CXCXXNewExpr clang_CXXNewExpr_CreateEmpty(CXASTContext Ctx, bool IsArray, bool HasInit,
                                          unsigned NumPlacementArgs, bool IsParenTypeId) {
  return clang::CXXNewExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx), IsArray,
                                        HasInit, NumPlacementArgs, IsParenTypeId);
}

// CXXDefaultArgExpr (cont.)
CXCXXDefaultArgExpr clang_CXXDefaultArgExpr_CreateEmpty(CXASTContext C,
                                                        bool HasRewrittenInit) {
  return clang::CXXDefaultArgExpr::CreateEmpty(*static_cast<clang::ASTContext *>(C),
                                               HasRewrittenInit);
}

// CXXDefaultInitExpr (cont.)
CXCXXDefaultInitExpr clang_CXXDefaultInitExpr_CreateEmpty(CXASTContext C,
                                                          bool HasRewrittenInit) {
  return clang::CXXDefaultInitExpr::CreateEmpty(*static_cast<clang::ASTContext *>(C),
                                                HasRewrittenInit);
}

// UserDefinedLiteral (cont.)
CXUserDefinedLiteral clang_UserDefinedLiteral_CreateEmpty(CXASTContext Ctx,
                                                          unsigned NumArgs,
                                                          bool HasFPOptions) {
  return clang::UserDefinedLiteral::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                                NumArgs, HasFPOptions,
                                                clang::Stmt::EmptyShell());
}

// CXXOperatorCallExpr (cont.)
CXCXXOperatorCallExpr clang_CXXOperatorCallExpr_CreateEmpty(CXASTContext Ctx,
                                                            unsigned NumArgs,
                                                            bool HasFPFeatures) {
  return clang::CXXOperatorCallExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                                 NumArgs, HasFPFeatures,
                                                 clang::Stmt::EmptyShell());
}

// CXXMemberCallExpr (cont.)
CXCXXMemberCallExpr clang_CXXMemberCallExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs,
                                                        bool HasFPFeatures) {
  return clang::CXXMemberCallExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                               NumArgs, HasFPFeatures,
                                               clang::Stmt::EmptyShell());
}

// UnresolvedLookupExpr (cont.)
CXUnresolvedLookupExpr clang_UnresolvedLookupExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumResults,
                                                              bool HasTemplateKWAndArgsInfo,
                                                              unsigned NumTemplateArgs) {
  return clang::UnresolvedLookupExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), NumResults, HasTemplateKWAndArgsInfo,
      NumTemplateArgs);
}

// FunctionParmPackExpr (cont.)
CXFunctionParmPackExpr clang_FunctionParmPackExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumParams) {
  return clang::FunctionParmPackExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), NumParams);
}

// LambdaExpr (cont.)
unsigned clang_LambdaExpr_getNumExplicitCaptures(CXLambdaExpr LE) {
  auto *L = static_cast<clang::LambdaExpr *>(LE);
  return static_cast<unsigned>(L->explicit_capture_end() - L->explicit_capture_begin());
}

// TypeTraitExpr (cont.)
CXTypeTrait clang_TypeTraitExpr_getTrait(CXTypeTraitExpr E) {
  return static_cast<CXTypeTrait>(static_cast<clang::TypeTraitExpr *>(E)->getTrait());
}

// SizeOfPackExpr (cont.)
unsigned clang_SizeOfPackExpr_getNumPartialArguments(CXSizeOfPackExpr E) {
  return static_cast<unsigned>(
      static_cast<clang::SizeOfPackExpr *>(E)->getPartialArguments().size());
}

CXTemplateArgument clang_SizeOfPackExpr_getPartialArgument(CXSizeOfPackExpr E, unsigned I) {
  auto *P = static_cast<clang::SizeOfPackExpr *>(E);
  return std::make_unique<clang::TemplateArgument>(P->getPartialArguments()[I]).release();
}

// ExprWithCleanups (cont.)
CXExprWithCleanups clang_ExprWithCleanups_Create(CXASTContext C, unsigned NumObjects) {
  return clang::ExprWithCleanups::Create(*static_cast<clang::ASTContext *>(C),
                                         clang::Stmt::EmptyShell(), NumObjects);
}

bool clang_ExprWithCleanups_objectIsBlockDecl(CXExprWithCleanups E, unsigned I) {
  return static_cast<clang::ExprWithCleanups *>(E)->getObject(I).is<clang::BlockDecl *>();
}

CXBlockDecl clang_ExprWithCleanups_getObjectAsBlockDecl(CXExprWithCleanups E, unsigned I) {
  return static_cast<clang::ExprWithCleanups *>(E)->getObject(I).get<clang::BlockDecl *>();
}

CXCompoundLiteralExpr
clang_ExprWithCleanups_getObjectAsCompoundLiteral(CXExprWithCleanups E, unsigned I) {
  return static_cast<clang::ExprWithCleanups *>(E)
      ->getObject(I)
      .get<clang::CompoundLiteralExpr *>();
}

// UnresolvedMemberExpr (cont.)
CXDeclarationName clang_UnresolvedMemberExpr_getMemberName(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->getMemberName().getAsOpaquePtr();
}

CXDeclarationNameInfo
clang_UnresolvedMemberExpr_getMemberNameInfo(CXUnresolvedMemberExpr E) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::UnresolvedMemberExpr *>(E)->getMemberNameInfo())
      .release();
}

CXSourceLocation_ clang_UnresolvedMemberExpr_getMemberLoc(CXUnresolvedMemberExpr E) {
  return static_cast<clang::UnresolvedMemberExpr *>(E)->getMemberLoc().getPtrEncoding();
}

// CXXPseudoDestructorExpr (cont.)
void clang_CXXPseudoDestructorExpr_setDestroyedType(CXCXXPseudoDestructorExpr E,
                                                    CXIdentifierInfo II,
                                                    CXSourceLocation_ Loc) {
  static_cast<clang::CXXPseudoDestructorExpr *>(E)->setDestroyedType(
      static_cast<clang::IdentifierInfo *>(II),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// MaterializeTemporaryExpr (cont.)
void clang_MaterializeTemporaryExpr_setExtendingDecl(CXMaterializeTemporaryExpr E,
                                                     CXValueDecl ExtendedBy,
                                                     unsigned ManglingNumber) {
  static_cast<clang::MaterializeTemporaryExpr *>(E)->setExtendingDecl(
      static_cast<clang::ValueDecl *>(ExtendedBy), ManglingNumber);
}

// CoawaitExpr (cont.)
void clang_CoawaitExpr_setIsImplicit(CXCoawaitExpr E, bool Value) {
  static_cast<clang::CoawaitExpr *>(E)->setIsImplicit(Value);
}

// CXXOperatorCallExpr (cont.)
CXCXXOperatorCallExpr clang_CXXOperatorCallExpr_Create(
    CXASTContext Ctx, CXOverloadedOperatorKind OpKind, CXExpr Fn, const CXExpr *Args,
    unsigned NumArgs, CXQualType Ty, CXExprValueKind VK, CXSourceLocation_ OperatorLoc,
    uint64_t FPFeatures, bool UsesADL) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXOperatorCallExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx),
      static_cast<clang::OverloadedOperatorKind>(OpKind), static_cast<clang::Expr *>(Fn),
      Exprs, clang::QualType::getFromOpaquePtr(Ty), static_cast<clang::ExprValueKind>(VK),
      clang::SourceLocation::getFromPtrEncoding(OperatorLoc),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures),
      UsesADL ? clang::CallExpr::UsesADL : clang::CallExpr::NotADL);
}

// CXXMemberCallExpr (cont.)
CXCXXMemberCallExpr clang_CXXMemberCallExpr_Create(
    CXASTContext Ctx, CXExpr Fn, const CXExpr *Args, unsigned NumArgs, CXQualType Ty,
    CXExprValueKind VK, CXSourceLocation_ RP, uint64_t FPFeatures, unsigned MinNumArgs) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXMemberCallExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::Expr *>(Fn), Exprs,
      clang::QualType::getFromOpaquePtr(Ty), static_cast<clang::ExprValueKind>(VK),
      clang::SourceLocation::getFromPtrEncoding(RP),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures), MinNumArgs);
}

// CUDAKernelCallExpr
CXCUDAKernelCallExpr clang_CUDAKernelCallExpr_CreateEmpty(CXASTContext Ctx,
                                                          unsigned NumArgs,
                                                          bool HasFPFeatures) {
  return clang::CUDAKernelCallExpr::CreateEmpty(*static_cast<clang::ASTContext *>(Ctx),
                                                NumArgs, HasFPFeatures,
                                                clang::Stmt::EmptyShell());
}

// UserDefinedLiteral (cont.)
CXUserDefinedLiteral clang_UserDefinedLiteral_Create(CXASTContext Ctx, CXExpr Fn,
                                                     const CXExpr *Args, unsigned NumArgs,
                                                     CXQualType Ty, CXExprValueKind VK,
                                                     CXSourceLocation_ LitEndLoc,
                                                     CXSourceLocation_ SuffixLoc,
                                                     uint64_t FPFeatures) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::UserDefinedLiteral::Create(
      *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::Expr *>(Fn), Exprs,
      clang::QualType::getFromOpaquePtr(Ty), static_cast<clang::ExprValueKind>(VK),
      clang::SourceLocation::getFromPtrEncoding(LitEndLoc),
      clang::SourceLocation::getFromPtrEncoding(SuffixLoc),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures));
}

// CXXConstructExpr (cont.)
CXCXXConstructExpr clang_CXXConstructExpr_Create(
    CXASTContext Ctx, CXQualType Ty, CXSourceLocation_ Loc, CXCXXConstructorDecl Ctor,
    bool Elidable, const CXExpr *Args, unsigned NumArgs, bool HadMultipleCandidates,
    bool ListInitialization, bool StdInitListInitialization, bool ZeroInitialization,
    CXCXXConstructionKind CK, CXSourceRange_ ParenOrBraceRange) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXConstructExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), clang::QualType::getFromOpaquePtr(Ty),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::CXXConstructorDecl *>(Ctor), Elidable, Exprs,
      HadMultipleCandidates, ListInitialization, StdInitListInitialization,
      ZeroInitialization, static_cast<clang::CXXConstructionKind>(CK),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(ParenOrBraceRange.B),
                         clang::SourceLocation::getFromPtrEncoding(ParenOrBraceRange.E)));
}

// CXXTemporaryObjectExpr (cont.)
CXCXXTemporaryObjectExpr clang_CXXTemporaryObjectExpr_Create(
    CXASTContext Ctx, CXCXXConstructorDecl Cons, CXQualType Ty, CXTypeSourceInfo TSI,
    const CXExpr *Args, unsigned NumArgs, CXSourceRange_ ParenOrBraceRange,
    bool HadMultipleCandidates, bool ListInitialization, bool StdInitListInitialization,
    bool ZeroInitialization) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CXXTemporaryObjectExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx),
      static_cast<clang::CXXConstructorDecl *>(Cons), clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::TypeSourceInfo *>(TSI), Exprs,
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(ParenOrBraceRange.B),
                         clang::SourceLocation::getFromPtrEncoding(ParenOrBraceRange.E)),
      HadMultipleCandidates, ListInitialization, StdInitListInitialization,
      ZeroInitialization);
}

// CXXNewExpr (cont.)
CXCXXNewExpr clang_CXXNewExpr_Create(
    CXASTContext Ctx, bool IsGlobalNew, CXFunctionDecl OperatorNew,
    CXFunctionDecl OperatorDelete, bool ShouldPassAlignment, bool UsualArrayDeleteWantsSize,
    const CXExpr *PlacementArgs, unsigned NumPlacementArgs, CXSourceRange_ TypeIdParens,
    bool HasArraySize, CXExpr ArraySize, CXCXXNewInitializationStyle InitializationStyle,
    CXExpr Initializer, CXQualType Ty, CXTypeSourceInfo AllocatedTypeInfo,
    CXSourceRange_ Range, CXSourceRange_ DirectInitRange) {
  llvm::SmallVector<clang::Expr *, 4> Placement;
  Placement.reserve(NumPlacementArgs);
  for (unsigned I = 0; I < NumPlacementArgs; ++I)
    Placement.push_back(static_cast<clang::Expr *>(PlacementArgs[I]));
  std::optional<clang::Expr *> Size;
  if (HasArraySize)
    Size = static_cast<clang::Expr *>(ArraySize);
  return clang::CXXNewExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), IsGlobalNew,
      static_cast<clang::FunctionDecl *>(OperatorNew),
      static_cast<clang::FunctionDecl *>(OperatorDelete), ShouldPassAlignment,
      UsualArrayDeleteWantsSize, Placement,
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(TypeIdParens.B),
                         clang::SourceLocation::getFromPtrEncoding(TypeIdParens.E)),
      Size, static_cast<clang::CXXNewInitializationStyle>(InitializationStyle),
      static_cast<clang::Expr *>(Initializer), clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::TypeSourceInfo *>(AllocatedTypeInfo),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(DirectInitRange.B),
                         clang::SourceLocation::getFromPtrEncoding(DirectInitRange.E)));
}

// LambdaExpr (cont.)
CXLambdaExpr clang_LambdaExpr_CreateDeserialized(CXASTContext C, unsigned NumCaptures) {
  return clang::LambdaExpr::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                               NumCaptures);
}

// TypeTraitExpr (cont.)
CXTypeTraitExpr clang_TypeTraitExpr_Create(CXASTContext C, CXQualType T,
                                           CXSourceLocation_ Loc, CXTypeTrait Kind,
                                           const CXTypeSourceInfo *Args, unsigned NumArgs,
                                           CXSourceLocation_ RParenLoc, bool Value) {
  llvm::SmallVector<clang::TypeSourceInfo *, 4> Infos;
  Infos.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Infos.push_back(static_cast<clang::TypeSourceInfo *>(Args[I]));
  return clang::TypeTraitExpr::Create(
      *static_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      clang::SourceLocation::getFromPtrEncoding(Loc), static_cast<clang::TypeTrait>(Kind),
      Infos, clang::SourceLocation::getFromPtrEncoding(RParenLoc), Value);
}

CXTypeTraitExpr clang_TypeTraitExpr_CreateDeserialized(CXASTContext C, unsigned NumArgs) {
  return clang::TypeTraitExpr::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                  NumArgs);
}

// SizeOfPackExpr (cont.)
CXSizeOfPackExpr clang_SizeOfPackExpr_Create(
    CXASTContext Context, CXSourceLocation_ OperatorLoc, CXNamedDecl Pack,
    CXSourceLocation_ PackLoc, CXSourceLocation_ RParenLoc, bool HasLength, unsigned Length,
    const CXTemplateArgument *PartialArgs, unsigned NumPartialArgs) {
  llvm::SmallVector<clang::TemplateArgument, 4> Args;
  Args.reserve(NumPartialArgs);
  for (unsigned I = 0; I < NumPartialArgs; ++I)
    Args.push_back(*static_cast<clang::TemplateArgument *>(PartialArgs[I]));
  std::optional<unsigned> PackLength;
  if (HasLength)
    PackLength = Length;
  return clang::SizeOfPackExpr::Create(
      *static_cast<clang::ASTContext *>(Context),
      clang::SourceLocation::getFromPtrEncoding(OperatorLoc),
      static_cast<clang::NamedDecl *>(Pack),
      clang::SourceLocation::getFromPtrEncoding(PackLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), PackLength, Args);
}

CXSizeOfPackExpr clang_SizeOfPackExpr_CreateDeserialized(CXASTContext Context,
                                                         unsigned NumPartialArgs) {
  return clang::SizeOfPackExpr::CreateDeserialized(
      *static_cast<clang::ASTContext *>(Context), NumPartialArgs);
}

// DependentScopeDeclRefExpr (cont.)
CXDependentScopeDeclRefExpr clang_DependentScopeDeclRefExpr_CreateEmpty(
    CXASTContext Context, bool HasTemplateKWAndArgsInfo, unsigned NumTemplateArgs) {
  return clang::DependentScopeDeclRefExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), HasTemplateKWAndArgsInfo,
      NumTemplateArgs);
}

// CXXDependentScopeMemberExpr (cont.)
CXCXXDependentScopeMemberExpr clang_CXXDependentScopeMemberExpr_CreateEmpty(
    CXASTContext Ctx, bool HasTemplateKWAndArgsInfo, unsigned NumTemplateArgs,
    bool HasFirstQualifierFoundInScope) {
  return clang::CXXDependentScopeMemberExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Ctx), HasTemplateKWAndArgsInfo, NumTemplateArgs,
      HasFirstQualifierFoundInScope);
}

// UnresolvedMemberExpr (cont.)
CXUnresolvedMemberExpr clang_UnresolvedMemberExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumResults,
                                                              bool HasTemplateKWAndArgsInfo,
                                                              unsigned NumTemplateArgs) {
  return clang::UnresolvedMemberExpr::CreateEmpty(
      *static_cast<clang::ASTContext *>(Context), NumResults, HasTemplateKWAndArgsInfo,
      NumTemplateArgs);
}

// LambdaExpr (cont.)
CXLambdaExpr clang_LambdaExpr_Create(CXASTContext C, CXCXXRecordDecl Class,
                                     CXSourceRange_ IntroducerRange,
                                     CXLambdaCaptureDefault CaptureDefault,
                                     CXSourceLocation_ CaptureDefaultLoc,
                                     bool ExplicitParams, bool ExplicitResultType,
                                     const CXExpr *CaptureInits, unsigned NumCaptureInits,
                                     CXSourceLocation_ ClosingBrace,
                                     bool ContainsUnexpandedParameterPack) {
  llvm::SmallVector<clang::Expr *, 8> Inits;
  Inits.reserve(NumCaptureInits);
  for (unsigned I = 0; I < NumCaptureInits; ++I)
    Inits.push_back(static_cast<clang::Expr *>(CaptureInits[I]));
  return clang::LambdaExpr::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::CXXRecordDecl *>(Class),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(IntroducerRange.B),
                         clang::SourceLocation::getFromPtrEncoding(IntroducerRange.E)),
      static_cast<clang::LambdaCaptureDefault>(CaptureDefault),
      clang::SourceLocation::getFromPtrEncoding(CaptureDefaultLoc), ExplicitParams,
      ExplicitResultType, Inits, clang::SourceLocation::getFromPtrEncoding(ClosingBrace),
      ContainsUnexpandedParameterPack);
}

// CUDAKernelCallExpr (cont.)
CXCUDAKernelCallExpr
clang_CUDAKernelCallExpr_Create(CXASTContext Ctx, CXExpr Fn, CXCallExpr Config,
                                const CXExpr *Args, unsigned NumArgs, CXQualType Ty,
                                CXExprValueKind VK, CXSourceLocation_ RP,
                                uint64_t FPFeatures, unsigned MinNumArgs) {
  llvm::SmallVector<clang::Expr *, 8> Exprs;
  Exprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Exprs.push_back(static_cast<clang::Expr *>(Args[I]));
  return clang::CUDAKernelCallExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::Expr *>(Fn),
      static_cast<clang::CallExpr *>(Config), Exprs, clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::ExprValueKind>(VK), clang::SourceLocation::getFromPtrEncoding(RP),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures), MinNumArgs);
}

CXCallExpr clang_CUDAKernelCallExpr_getConfig(CXCUDAKernelCallExpr E) {
  return static_cast<clang::CUDAKernelCallExpr *>(E)->getConfig();
}

// OverloadExpr (cont.)
CXOverloadExpr clang_OverloadExpr_find(CXExpr E, bool *IsAddressOfOperand,
                                       bool *HasFormOfMemberPointer) {
  clang::OverloadExpr::FindResult R =
      clang::OverloadExpr::find(static_cast<clang::Expr *>(E));
  *IsAddressOfOperand = R.IsAddressOfOperand;
  *HasFormOfMemberPointer = R.HasFormOfMemberPointer;
  return R.Expression;
}

// CXXParenListInitExpr (cont.)
void clang_CXXParenListInitExpr_updateDependence(CXCXXParenListInitExpr E) {
  static_cast<clang::CXXParenListInitExpr *>(E)->updateDependence();
}

// OverloadExpr (cont.)
void clang_OverloadExpr_copyTemplateArgumentsInto(CXOverloadExpr E,
                                                  CXTemplateArgumentListInfo List) {
  static_cast<clang::OverloadExpr *>(E)->copyTemplateArgumentsInto(
      *static_cast<clang::TemplateArgumentListInfo *>(List));
}

// DependentScopeDeclRefExpr (cont.)
void clang_DependentScopeDeclRefExpr_copyTemplateArgumentsInto(
    CXDependentScopeDeclRefExpr E, CXTemplateArgumentListInfo List) {
  static_cast<clang::DependentScopeDeclRefExpr *>(E)->copyTemplateArgumentsInto(
      *static_cast<clang::TemplateArgumentListInfo *>(List));
}

// CXXDependentScopeMemberExpr (cont.)
void clang_CXXDependentScopeMemberExpr_copyTemplateArgumentsInto(
    CXCXXDependentScopeMemberExpr E, CXTemplateArgumentListInfo List) {
  static_cast<clang::CXXDependentScopeMemberExpr *>(E)->copyTemplateArgumentsInto(
      *static_cast<clang::TemplateArgumentListInfo *>(List));
}

// DependentScopeDeclRefExpr (cont.)
CXDependentScopeDeclRefExpr clang_DependentScopeDeclRefExpr_Create(
    CXASTContext Context, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXDeclarationNameInfo NameInfo,
    CXTemplateArgumentListInfo TemplateArgs) {
  return clang::DependentScopeDeclRefExpr::Create(
      *static_cast<clang::ASTContext *>(Context),
      *static_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      clang::SourceLocation::getFromPtrEncoding(TemplateKWLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo),
      static_cast<clang::TemplateArgumentListInfo *>(TemplateArgs));
}

// CXXDependentScopeMemberExpr (cont.)
CXCXXDependentScopeMemberExpr clang_CXXDependentScopeMemberExpr_Create(
    CXASTContext Ctx, CXExpr Base, CXQualType BaseType, bool IsArrow,
    CXSourceLocation_ OperatorLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXNamedDecl FirstQualifierFoundInScope,
    CXDeclarationNameInfo MemberNameInfo, CXTemplateArgumentListInfo TemplateArgs) {
  return clang::CXXDependentScopeMemberExpr::Create(
      *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::Expr *>(Base),
      clang::QualType::getFromOpaquePtr(BaseType), IsArrow,
      clang::SourceLocation::getFromPtrEncoding(OperatorLoc),
      *static_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      clang::SourceLocation::getFromPtrEncoding(TemplateKWLoc),
      static_cast<clang::NamedDecl *>(FirstQualifierFoundInScope),
      *static_cast<clang::DeclarationNameInfo *>(MemberNameInfo),
      static_cast<clang::TemplateArgumentListInfo *>(TemplateArgs));
}

namespace {
// Rebuild the [Begin, End) UnresolvedSetIterator pair clang's overload-set builders take
// from the parallel (declaration, access) component arrays the C surface carries
// (MARSHALLING.md section 11): UnresolvedSetIterator's own constructors are private, so a
// local UnresolvedSet is the only way to mint one. clang copies the DeclAccessPairs into
// the node's trailing storage, so the set need not outlive the Create call.
void fillUnresolvedSet(clang::UnresolvedSet<8> &Set, const CXNamedDecl *Decls,
                       const CXAccessSpecifier *Accesses, unsigned NumDecls) {
  for (unsigned I = 0; I < NumDecls; ++I)
    Set.addDecl(static_cast<clang::NamedDecl *>(Decls[I]),
                static_cast<clang::AccessSpecifier>(Accesses[I]));
}
} // namespace

// UnresolvedLookupExpr (cont.)
CXUnresolvedLookupExpr
clang_UnresolvedLookupExpr_Create(CXASTContext Context, CXCXXRecordDecl NamingClass,
                                  CXNestedNameSpecifierLoc QualifierLoc,
                                  CXDeclarationNameInfo NameInfo, bool RequiresADL,
                                  bool Overloaded, const CXNamedDecl *Decls,
                                  const CXAccessSpecifier *Accesses, unsigned NumDecls) {
  clang::UnresolvedSet<8> Set;
  fillUnresolvedSet(Set, Decls, Accesses, NumDecls);
  return clang::UnresolvedLookupExpr::Create(
      *static_cast<clang::ASTContext *>(Context),
      static_cast<clang::CXXRecordDecl *>(NamingClass),
      *static_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo), RequiresADL, Overloaded,
      Set.begin(), Set.end());
}

CXUnresolvedLookupExpr clang_UnresolvedLookupExpr_CreateWithTemplateArgs(
    CXASTContext Context, CXCXXRecordDecl NamingClass,
    CXNestedNameSpecifierLoc QualifierLoc, CXSourceLocation_ TemplateKWLoc,
    CXDeclarationNameInfo NameInfo, bool RequiresADL,
    CXTemplateArgumentListInfo TemplateArgs, const CXNamedDecl *Decls,
    const CXAccessSpecifier *Accesses, unsigned NumDecls, bool KnownDependent) {
  clang::UnresolvedSet<8> Set;
  fillUnresolvedSet(Set, Decls, Accesses, NumDecls);
  return clang::UnresolvedLookupExpr::Create(
      *static_cast<clang::ASTContext *>(Context),
      static_cast<clang::CXXRecordDecl *>(NamingClass),
      *static_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      clang::SourceLocation::getFromPtrEncoding(TemplateKWLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo), RequiresADL,
      static_cast<clang::TemplateArgumentListInfo *>(TemplateArgs), Set.begin(), Set.end(),
      KnownDependent);
}

// UnresolvedMemberExpr (cont.)
CXUnresolvedMemberExpr clang_UnresolvedMemberExpr_Create(
    CXASTContext Context, bool HasUnresolvedUsing, CXExpr Base, CXQualType BaseType,
    bool IsArrow, CXSourceLocation_ OperatorLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TemplateKWLoc, CXDeclarationNameInfo MemberNameInfo,
    CXTemplateArgumentListInfo TemplateArgs, const CXNamedDecl *Decls,
    const CXAccessSpecifier *Accesses, unsigned NumDecls) {
  clang::UnresolvedSet<8> Set;
  fillUnresolvedSet(Set, Decls, Accesses, NumDecls);
  return clang::UnresolvedMemberExpr::Create(
      *static_cast<clang::ASTContext *>(Context), HasUnresolvedUsing,
      static_cast<clang::Expr *>(Base), clang::QualType::getFromOpaquePtr(BaseType),
      IsArrow, clang::SourceLocation::getFromPtrEncoding(OperatorLoc),
      *static_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      clang::SourceLocation::getFromPtrEncoding(TemplateKWLoc),
      *static_cast<clang::DeclarationNameInfo *>(MemberNameInfo),
      static_cast<clang::TemplateArgumentListInfo *>(TemplateArgs), Set.begin(), Set.end());
}
