#include "clang-ex/StaticAnalyzer/Frontend/CXAnalyzerHelpFlags.h"

#include "utils.h"

#include "clang/Frontend/CompilerInstance.h"
#include "clang/StaticAnalyzer/Frontend/AnalyzerHelpFlags.h"
#include "llvm/Support/raw_ostream.h"

#include <string>

CXString clang_ento_printCheckerHelp(CXCompilerInstance CI) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::ento::printCheckerHelp(OS, *reinterpret_cast<clang::CompilerInstance *>(CI));
  return extra::makeCXString(S);
}

CXString clang_ento_printEnabledCheckerList(CXCompilerInstance CI) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::ento::printEnabledCheckerList(OS,
                                       *reinterpret_cast<clang::CompilerInstance *>(CI));
  return extra::makeCXString(S);
}

CXString clang_ento_printCheckerConfigList(CXCompilerInstance CI) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::ento::printCheckerConfigList(OS,
                                      *reinterpret_cast<clang::CompilerInstance *>(CI));
  return extra::makeCXString(S);
}

CXString clang_ento_printAnalyzerConfigList(void) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::ento::printAnalyzerConfigList(OS);
  return extra::makeCXString(S);
}
