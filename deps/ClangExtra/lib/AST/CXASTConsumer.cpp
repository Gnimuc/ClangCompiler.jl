#include "clang-ex/AST/CXASTConsumer.h"
#include "clang/AST/ASTConsumer.h"
#include <memory>

CXASTConsumer clang_ASTConsumer_create(void) {
  auto Csr = std::make_unique<clang::ASTConsumer>();
  return reinterpret_cast<CXASTConsumer>(Csr.release());
}

void clang_ASTConsumer_dispose(CXASTConsumer Csr) {
  delete reinterpret_cast<clang::ASTConsumer *>(Csr);
}

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