#include "clang-ex/AST/CXASTConsumer.h"
#include "clang/AST/ASTConsumer.h"

void clang_ASTConsumer_Initialize(CXASTConsumer Csr, CXASTContext Ctx) {
  reinterpret_cast<clang::ASTConsumer *>(Csr)->Initialize(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_ASTConsumer_HandleTranslationUnit(CXASTConsumer Csr, CXASTContext Ctx) {
  reinterpret_cast<clang::ASTConsumer *>(Csr)->HandleTranslationUnit(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_ASTConsumer_PrintStats(CXASTConsumer Csr) {
  reinterpret_cast<clang::ASTConsumer *>(Csr)->PrintStats();
}