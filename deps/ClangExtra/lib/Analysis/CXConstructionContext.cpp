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
  return static_cast<CXConstructionContextKind>(reinterpret_cast<CC_Base *>(CC)->getKind());
}

// getArrayInitLoop

CXDeclStmt clang_ConstructionContext_getDeclStmt(CXConstructionContext CC) {
  const auto *V = llvm::dyn_cast_or_null<CC_Variable>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXDeclStmt>(V ? const_cast<clang::DeclStmt *>(V->getDeclStmt()) : nullptr);
}

CXCXXCtorInitializer
clang_ConstructionContext_getCXXCtorInitializer(CXConstructionContext CC) {
  const auto *I = llvm::dyn_cast_or_null<CC_CtorInitializer>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXCXXCtorInitializer>(I ? const_cast<clang::CXXCtorInitializer *>(I->getCXXCtorInitializer()) : nullptr);
}

CXCXXNewExpr clang_ConstructionContext_getCXXNewExpr(CXConstructionContext CC) {
  const auto *N = llvm::dyn_cast_or_null<CC_NewAllocatedObject>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXCXXNewExpr>(N ? const_cast<clang::CXXNewExpr *>(N->getCXXNewExpr()) : nullptr);
}

CXCXXBindTemporaryExpr
clang_ConstructionContext_getCXXBindTemporaryExpr(CXConstructionContext CC) {
  auto *C = reinterpret_cast<CC_Base *>(CC);
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
  return reinterpret_cast<CXCXXBindTemporaryExpr>(const_cast<clang::CXXBindTemporaryExpr *>(BTE));
}

CXMaterializeTemporaryExpr
clang_ConstructionContext_getMaterializedTemporaryExpr(CXConstructionContext CC) {
  const auto *T = llvm::dyn_cast_or_null<CC_TemporaryObject>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXMaterializeTemporaryExpr>(T ? const_cast<clang::MaterializeTemporaryExpr *>(
                 T->getMaterializedTemporaryExpr())
           : nullptr);
}

CXCXXConstructExpr
clang_ConstructionContext_getConstructorAfterElision(CXConstructionContext CC) {
  const auto *E =
      llvm::dyn_cast_or_null<CC_ElidedTemporaryObject>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXCXXConstructExpr>(E ? const_cast<clang::CXXConstructExpr *>(E->getConstructorAfterElision())
           : nullptr);
}

CXConstructionContext
clang_ConstructionContext_getConstructionContextAfterElision(CXConstructionContext CC) {
  const auto *E =
      llvm::dyn_cast_or_null<CC_ElidedTemporaryObject>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXConstructionContext>(E ? const_cast<CC_Base *>(E->getConstructionContextAfterElision()) : nullptr);
}

CXReturnStmt clang_ConstructionContext_getReturnStmt(CXConstructionContext CC) {
  const auto *R = llvm::dyn_cast_or_null<CC_ReturnedValue>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXReturnStmt>(R ? const_cast<clang::ReturnStmt *>(R->getReturnStmt()) : nullptr);
}

CXExpr clang_ConstructionContext_getCallLikeExpr(CXConstructionContext CC) {
  const auto *A = llvm::dyn_cast_or_null<CC_Argument>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXExpr>(A ? const_cast<clang::Expr *>(A->getCallLikeExpr()) : nullptr);
}

unsigned clang_ConstructionContext_getIndex(CXConstructionContext CC) {
  auto *C = reinterpret_cast<CC_Base *>(CC);
  if (const auto *A = llvm::dyn_cast_or_null<CC_Argument>(C))
    return A->getIndex();
  if (const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(C))
    return L->getIndex();
  return 0;
}

CXLambdaExpr clang_ConstructionContext_getLambdaExpr(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXLambdaExpr>(L ? const_cast<clang::LambdaExpr *>(L->getLambdaExpr()) : nullptr);
}

CXExpr clang_ConstructionContext_getInitializer(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXExpr>(L ? const_cast<clang::Expr *>(L->getInitializer()) : nullptr);
}

CXFieldDecl clang_ConstructionContext_getFieldDecl(CXConstructionContext CC) {
  const auto *L = llvm::dyn_cast_or_null<CC_LambdaCapture>(reinterpret_cast<CC_Base *>(CC));
  return reinterpret_cast<CXFieldDecl>(L ? const_cast<clang::FieldDecl *>(L->getFieldDecl()) : nullptr);
}
