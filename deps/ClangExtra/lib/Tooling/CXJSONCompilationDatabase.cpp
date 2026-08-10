#include "clang-ex/Tooling/CXJSONCompilationDatabase.h"

#include "utils.h"

#include "clang/Tooling/JSONCompilationDatabase.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <string>

namespace {

void publishError(CXString *Out, const std::string &Msg) {
  if (Out)
    *Out = extra::makeCXString(Msg);
}

} // namespace

CXJSONCompilationDatabase
clang_JSONCompilationDatabase_loadFromFile(const char *FilePath, CXString *ErrorMessage,
                                           CXJSONCommandLineSyntax Syntax) {
  std::string Err;
  auto DB = clang::tooling::JSONCompilationDatabase::loadFromFile(
      FilePath ? FilePath : "", Err,
      static_cast<clang::tooling::JSONCommandLineSyntax>(Syntax));
  publishError(ErrorMessage, Err);
  return reinterpret_cast<CXJSONCompilationDatabase>(DB.release());
}

CXJSONCompilationDatabase
clang_JSONCompilationDatabase_loadFromBuffer(const char *DatabaseString,
                                             CXString *ErrorMessage,
                                             CXJSONCommandLineSyntax Syntax) {
  std::string Err;
  auto DB = clang::tooling::JSONCompilationDatabase::loadFromBuffer(
      DatabaseString ? DatabaseString : "", Err,
      static_cast<clang::tooling::JSONCommandLineSyntax>(Syntax));
  publishError(ErrorMessage, Err);
  return reinterpret_cast<CXJSONCompilationDatabase>(DB.release());
}
