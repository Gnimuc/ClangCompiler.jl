#include "clang-ex/Frontend/CXFrontendAction.h"
#include "utils.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Frontend/FrontendOptions.h"

// Compiler instance access
CXCompilerInstance clang_FrontendAction_getCompilerInstance(CXFrontendAction FA) {
  return reinterpret_cast<CXCompilerInstance>(&reinterpret_cast<clang::FrontendAction *>(FA)->getCompilerInstance());
}

void clang_FrontendAction_setCompilerInstance(CXFrontendAction FA,
                                              CXCompilerInstance Value) {
  reinterpret_cast<clang::FrontendAction *>(FA)->setCompilerInstance(
      reinterpret_cast<clang::CompilerInstance *>(Value));
}

// Current file information
bool clang_FrontendAction_isCurrentInputEmpty(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->getCurrentInput().isEmpty();
}

bool clang_FrontendAction_isCurrentFileAST(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->isCurrentFileAST();
}

CXString clang_FrontendAction_getCurrentFileOrBufferName(CXFrontendAction FA) {
  return extra::makeCXString(
      reinterpret_cast<clang::FrontendAction *>(FA)->getCurrentFileOrBufferName().str());
}

// Supported modes
bool clang_FrontendAction_isModelParsingAction(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->isModelParsingAction();
}

bool clang_FrontendAction_usesPreprocessorOnly(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->usesPreprocessorOnly();
}

CXTranslationUnitKind clang_FrontendAction_getTranslationUnitKind(CXFrontendAction FA) {
  return static_cast<CXTranslationUnitKind>(
      reinterpret_cast<clang::FrontendAction *>(FA)->getTranslationUnitKind());
}

bool clang_FrontendAction_hasPCHSupport(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->hasPCHSupport();
}

bool clang_FrontendAction_hasASTFileSupport(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->hasASTFileSupport();
}

bool clang_FrontendAction_hasIRSupport(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->hasIRSupport();
}

bool clang_FrontendAction_hasCodeCompletionSupport(CXFrontendAction FA) {
  return reinterpret_cast<clang::FrontendAction *>(FA)->hasCodeCompletionSupport();
}
