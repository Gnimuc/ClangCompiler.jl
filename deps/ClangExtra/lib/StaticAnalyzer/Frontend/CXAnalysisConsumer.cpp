#include "clang-ex/StaticAnalyzer/Frontend/CXAnalysisConsumer.h"

#include "clang/AST/ASTConsumer.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/StaticAnalyzer/Frontend/AnalysisConsumer.h"

#include <memory>

CXASTConsumer clang_ento_CreateAnalysisConsumer(CXCompilerInstance CI) {
  auto Consumer = clang::ento::CreateAnalysisConsumer(
      *reinterpret_cast<clang::CompilerInstance *>(CI));
  // Implicit derived-to-base conversion, not a cast.
  clang::ASTConsumer *Base = Consumer.release();
  return reinterpret_cast<CXASTConsumer>(Base);
}
