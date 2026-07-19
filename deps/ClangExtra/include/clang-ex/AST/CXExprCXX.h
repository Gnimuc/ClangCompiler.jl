#ifndef LLVM_CLANG_C_EXTRA_CXEXPRCXX_H
#define LLVM_CLANG_C_EXTRA_CXEXPRCXX_H

#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang-ex/Basic/CXLambda.h"
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


LLVM_CLANG_C_EXTERN_C_END

#endif
