#include "clang-ex/AST/CXASTConsumer.h"
#include "clang/AST/ASTConsumer.h"

void clang_ASTConsumer_Initialize(CXASTConsumer Csr, CXASTContext Ctx) {
  static_cast<clang::ASTConsumer *>(Csr)->Initialize(
      *static_cast<clang::ASTContext *>(Ctx));
}

void clang_ASTConsumer_HandleTranslationUnit(CXASTConsumer Csr, CXASTContext Ctx) {
  static_cast<clang::ASTConsumer *>(Csr)->HandleTranslationUnit(
      *static_cast<clang::ASTContext *>(Ctx));
}

void clang_ASTConsumer_PrintStats(CXASTConsumer Csr) {
  static_cast<clang::ASTConsumer *>(Csr)->PrintStats();
}