#include "clang-ex/AST/CXExpr.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/ExecutionEngine/GenericValue.h"

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L) {
  return clang::IntegerLiteral::Create(
      *static_cast<clang::ASTContext *>(C),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(Val)->IntVal),
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getEndLoc().getPtrEncoding();
}

CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getLocation().getPtrEncoding();
}

void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L) {
  static_cast<clang::IntegerLiteral *>(IL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CStyleCastExpr
CXCStyleCastExpr clang_CStyleCastExpr_CreateWithNoTypeInfo(CXASTContext C, CXQualType T,
                                                           CXExprValueKind VK, CXCastKind K,
                                                           CXExpr Op) {
  return clang::CStyleCastExpr::Create(
      *static_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(K),
      static_cast<clang::Expr *>(Op), nullptr, clang::FPOptionsOverride(),
      static_cast<clang::ASTContext *>(C)->getTrivialTypeSourceInfo(
          clang::QualType::getFromOpaquePtr(T), clang::SourceLocation()),
      clang::SourceLocation(), clang::SourceLocation());
}

CXCStyleCastExpr clang_CStyleCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                  bool HasFPFeatures) {
  return clang::CStyleCastExpr::CreateEmpty(*static_cast<clang::ASTContext *>(C), PathSize,
                                            HasFPFeatures);
}

CXSourceLocation_ clang_CStyleCastExpr_getLParenLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getLParenLoc().getPtrEncoding();
}

void clang_CStyleCastExpr_setLParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  static_cast<clang::CStyleCastExpr *>(CSCE)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getRParenLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getRParenLoc().getPtrEncoding();
}

void clang_CStyleCastExpr_setRParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  static_cast<clang::CStyleCastExpr *>(CSCE)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getBeginLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CStyleCastExpr_getEndLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getEndLoc().getPtrEncoding();
}