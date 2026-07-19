#include "clang-ex/AST/CXExprCXX.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/ExprCXX.h"

// CXXOperatorCallExpr
CXOverloadedOperatorKind clang_CXXOperatorCallExpr_getOperator(CXCXXOperatorCallExpr OCE) {
  return static_cast<CXOverloadedOperatorKind>(
      static_cast<clang::CXXOperatorCallExpr *>(OCE)->getOperator());
}

CXSourceLocation_ clang_CXXOperatorCallExpr_getOperatorLoc(CXCXXOperatorCallExpr OCE) {
  return static_cast<clang::CXXOperatorCallExpr *>(OCE)->getOperatorLoc().getPtrEncoding();
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

