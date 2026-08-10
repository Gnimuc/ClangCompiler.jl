#include "clang-ex/Tooling/Inclusions/CXHeaderAnalysis.h"

#include "utils.h"

#include "clang/Basic/FileEntry.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/HeaderSearch.h"
#include "clang/Tooling/Inclusions/HeaderAnalysis.h"
#include "llvm/ADT/StringRef.h"

#include <optional>
#include <string>

bool clang_tooling_isSelfContainedHeader(CXFileEntryRef FE, CXSourceManager SM,
                                         CXHeaderSearch HeaderInfo) {
  return clang::tooling::isSelfContainedHeader(
      *reinterpret_cast<clang::FileEntryRef *>(FE),
      *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::HeaderSearch *>(HeaderInfo));
}

bool clang_tooling_codeContainsImports(const char *Code) {
  return clang::tooling::codeContainsImports(llvm::StringRef(Code));
}

CXString clang_tooling_parseIWYUPragma(const char *Text, bool *OutFound) {
  std::optional<llvm::StringRef> Pragma = clang::tooling::parseIWYUPragma(Text);
  if (OutFound)
    *OutFound = Pragma.has_value();
  if (!Pragma)
    return extra::makeCXString(std::string());
  // The StringRef points into the caller's buffer, so it has to be copied out.
  return extra::makeCXString(Pragma->str());
}
