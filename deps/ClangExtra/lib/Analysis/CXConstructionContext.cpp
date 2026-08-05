#include "clang-ex/Analysis/CXConstructionContext.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/ExprCXX.h"
#include "clang/AST/Stmt.h"
#include "clang/Analysis/ConstructionContext.h"
#include "llvm/Support/Casting.h"

// clang::ConstructionContext's subclass names are long enough that a dyn_cast spelled
// out in full does not fit the 92-column limit; these file-local aliases keep each
// accessor below readable.
namespace {

using CC_Base = clang::ConstructionContext;
using CC_Variable = clang::VariableConstructionContext;
using CC_ElidedCopyVariable = clang::CXX17ElidedCopyVariableConstructionContext;
using CC_CtorInitializer = clang::ConstructorInitializerConstructionContext;
using CC_ElidedCopyCtorInitializer =
    clang::CXX17ElidedCopyConstructorInitializerConstructionContext;
using CC_NewAllocatedObject = clang::NewAllocatedObjectConstructionContext;
using CC_TemporaryObject = clang::TemporaryObjectConstructionContext;
using CC_ElidedTemporaryObject = clang::ElidedTemporaryObjectConstructionContext;
using CC_ReturnedValue = clang::ReturnedValueConstructionContext;
using CC_ElidedCopyReturnedValue = clang::CXX17ElidedCopyReturnedValueConstructionContext;
using CC_Argument = clang::ArgumentConstructionContext;
using CC_LambdaCapture = clang::LambdaCaptureConstructionContext;

} // namespace

// ConstructionContext

CXConstructionContextKind clang_ConstructionContext_getKind(CXConstructionContext CC) {
  return static_cast<CXConstructionContextKind>(static_cast<CC_Base *>(CC)->getKind());
}

// getArrayInitLoop

CXDeclStmt clang_ConstructionContext_getDeclStmt(CXConstructionContext CC) {
  const auto *V = llvm::dyn_cast_or_null<CC_Variable>(static_cast<CC_Base *>(CC));
  return V ? const_cast<clang::DeclStmt *>(V->getDeclStmt()) : nullptr;
}

CXCXXCtorInitializer
clang_ConstructionContext_getCXXCtorInitializer(CXConstructionContext CC) {
  const auto *I = llvm::dyn_cast_or_null<CC_CtorInitializer>(static_cast<CC_Base *>(CC));
  return I ? const_cast<clang::CXXCtorInitializer *>(I->getCXXCtorInitializer()) : nullptr;
}

CXCXXNewExpr clang_ConstructionContext_getCXXNewExpr(CXConstructionContext CC) {
  const auto *N = llvm::dyn_cast_or_null<CC_NewAllocatedObject>(static_cast<CC_Base *>(CC));
  return N ? const_cast<clang::CXXNewExpr *>(N->getCXXNewExpr()) : nullptr;
}

CXCXXBindTemporaryExpr
clang_ConstructionContext_getCXXBindTemporaryExpr(CXConstructionContext CC) {
  auto *C = static_cast<CC_Base *>(CC);
  const clang::CXXBindTemporaryExpr *BTE = nullptr;
  if (const auto *V = llvm::dyn_cast_or_null<CC_ElidedCopyVariable>(C))
    BTE = V->getCXXBindTemporaryExpr();
  else if (const auto *I = llvm::dyn_cast_or_null<CC_ElidedCopyCtorInitializer>(C))
    BTE = I->getCXXBindTemporaryExpr();
  else if (const auto *T = llvm::dyn_cast_or_null<CC_TemporaryObject>(C))
    BTE = T->getCXXBindTemporaryExpr();
  else if (const auto *R = llvm::dyn_cast_or_null<CC_ElidedCopyReturnedValue>(C))
    BTE = R->getCXXBindTemporaryExpr();
  else if (const auto *A = llvm::dyn_cast_or_null<CC_Argument>(C))
    BTE = A->getCXXBindTemporaryExpr();
  return const_cast<clang::CXXBindTemporaryExpr *>(BTE);
}

CXMaterializeTemporaryExpr
clang_ConstructionContext_getMaterializedTemporaryExpr(CXConstructionContext CC) {
  const auto *T = llvm::dyn_cast_or_null<CC_TemporaryObject>(static_cast<CC_Base *>(CC));
  return T ? const_cast<clang::MaterializeTemporaryExpr *>(
                 T->getMaterializedTemporaryExpr())
           : nullptr;
}

CXCXXConstructExpr
clang_ConstructionContext_getConstructorAfterElision(CXConstructionContext CC) {
  const auto *E =
      llvm::dyn_cast_or_null<CC_ElidedTemporaryObject>(static_cast<CC_Base *>(CC));
  return E ? const_cast<clang::CXXConstructExpr *>(E->getConstructorAfterElision())
           : nullptr;
}

CXConstructionContext
clang_ConstructionContext_getConstructionContextAfterElision(CXConstructionContext CC) {
  const auto *E =
      llvm::dyn_cast_or_null<CC_ElidedTemporaryObject>(static_cast<CC_Base *>(CC));
  return E ? const_cast<CC_Base *>(E->getConstructionContextAfterElision()) : nullptr;
}

CXReturnStmt clang_ConstructionContext_getReturnStmt(CXConstructionContext CC) {
  const auto *R = llvm::dyn_cast_or_null<CC_ReturnedValue>(static_cast<CC_Base *>(CC));
  return R ? const_cast<clang::ReturnStmt *>(R->getReturnStmt()) : nullptr;
}

CXExpr clang_ConstructionContext_getCallLikeExpr(CXConstructionContext CC) {
  const auto *A = llvm::dyn_cast_or_null<CC_Argument>(static_cast<CC_Base *>(CC));
  return A ? const_cast<clang::Expr *>(A->getCallLikeExpr()) : nullptr;
}

unsigned clang_ConstructionContext_getIndex(CXConstructionContext CC) {
  auto *C = static_cast<CC_Base *>(CC);
  if (const auto *A = llvm::dyn_cast_or_null<CC_Argument>(C))
    return A->getIndex();
  if (const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(C))
    return L->getIndex();
  return 0;
}

CXLambdaExpr clang_ConstructionContext_getLambdaExpr(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(static_cast<CC_Base *>(CC));
  return L ? const_cast<clang::LambdaExpr *>(L->getLambdaExpr()) : nullptr;
}

CXExpr clang_ConstructionContext_getInitializer(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(static_cast<CC_Base *>(CC));
  return L ? const_cast<clang::Expr *>(L->getInitializer()) : nullptr;
}

CXFieldDecl clang_ConstructionContext_getFieldDecl(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(static_cast<CC_Base *>(CC));
  return L ? const_cast<clang::FieldDecl *>(L->getFieldDecl()) : nullptr;
}
