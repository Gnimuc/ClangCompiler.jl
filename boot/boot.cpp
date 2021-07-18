#include "boot.h"
#include "clang/Lex/Preprocessor.h"

void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->enableIncrementalProcessing();
}

bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->isIncrementalProcessingEnabled();
}