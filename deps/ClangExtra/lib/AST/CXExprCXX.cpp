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
