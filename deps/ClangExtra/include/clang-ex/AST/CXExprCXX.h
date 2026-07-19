#ifndef LLVM_CLANG_C_EXTRA_CXEXPRCXX_H
#define LLVM_CLANG_C_EXTRA_CXEXPRCXX_H

#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CXXOperatorCallExpr
CXOverloadedOperatorKind clang_CXXOperatorCallExpr_getOperator(CXCXXOperatorCallExpr OCE);

CXSourceLocation_ clang_CXXOperatorCallExpr_getOperatorLoc(CXCXXOperatorCallExpr OCE);

// CXXMemberCallExpr
CXExpr clang_CXXMemberCallExpr_getImplicitObjectArgument(CXCXXMemberCallExpr MCE);

CXCXXMethodDecl clang_CXXMemberCallExpr_getMethodDecl(CXCXXMemberCallExpr MCE);

CXCXXRecordDecl clang_CXXMemberCallExpr_getRecordDecl(CXCXXMemberCallExpr MCE);

// CXXBoolLiteralExpr
bool clang_CXXBoolLiteralExpr_getValue(CXCXXBoolLiteralExpr BLE);

// CXXConstructExpr
CXCXXConstructorDecl clang_CXXConstructExpr_getConstructor(CXCXXConstructExpr CE);

unsigned clang_CXXConstructExpr_getNumArgs(CXCXXConstructExpr CE);

CXExpr clang_CXXConstructExpr_getArg(CXCXXConstructExpr CE, unsigned Arg);

bool clang_CXXConstructExpr_isElidable(CXCXXConstructExpr CE);

// LambdaExpr
CXCXXMethodDecl clang_LambdaExpr_getCallOperator(CXLambdaExpr LE);

CXCXXRecordDecl clang_LambdaExpr_getLambdaClass(CXLambdaExpr LE);

CXStmt clang_LambdaExpr_getBody(CXLambdaExpr LE);

bool clang_LambdaExpr_isMutable(CXLambdaExpr LE);

// CXXNewExpr
CXQualType clang_CXXNewExpr_getAllocatedType(CXCXXNewExpr NE);

bool clang_CXXNewExpr_isArray(CXCXXNewExpr NE);

// NULL when the new-expression has no array size
CXExpr clang_CXXNewExpr_getArraySize(CXCXXNewExpr NE);

bool clang_CXXNewExpr_hasInitializer(CXCXXNewExpr NE);

CXExpr clang_CXXNewExpr_getInitializer(CXCXXNewExpr NE);

// CXXDeleteExpr
CXExpr clang_CXXDeleteExpr_getArgument(CXCXXDeleteExpr DE);

bool clang_CXXDeleteExpr_isArrayForm(CXCXXDeleteExpr DE);

LLVM_CLANG_C_EXTERN_C_END

#endif
