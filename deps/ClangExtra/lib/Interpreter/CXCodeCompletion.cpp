#include "clang-ex/Interpreter/CXCodeCompletion.h"
#include "utils.h"

#include "clang/Frontend/CompilerInstance.h"
#include "clang/Interpreter/CodeCompletion.h"

#include <string>
#include <vector>

CXStringSet *clang_ReplCodeCompleter_codeComplete(CXCompilerInstance InterpCI,
                                                  const char *Content, unsigned Line,
                                                  unsigned Col, CXCompilerInstance ParentCI,
                                                  CXString *OutPrefix) {
  clang::ReplCodeCompleter Completer;
  std::vector<std::string> Results;
  Completer.codeComplete(reinterpret_cast<clang::CompilerInstance *>(InterpCI),
                         llvm::StringRef(Content), Line, Col,
                         reinterpret_cast<const clang::CompilerInstance *>(ParentCI), Results);
  if (OutPrefix)
    *OutPrefix = extra::makeCXString(Completer.Prefix);
  return extra::makeCXStringSet(Results);
}
