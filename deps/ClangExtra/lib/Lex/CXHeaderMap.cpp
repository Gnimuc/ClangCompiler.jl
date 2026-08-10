#include "clang-ex/Lex/CXHeaderMap.h"
#include "utils.h"

#include "clang/Lex/HeaderMap.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringRef.h"

#include <string>
#include <vector>

namespace {

clang::HeaderMap *hmap(CXHeaderMap HM) { return reinterpret_cast<clang::HeaderMap *>(HM); }

} // namespace

CXString clang_HeaderMap_lookupFilename(CXHeaderMap HM, const char *Filename) {
  llvm::SmallString<256> DestPath;
  llvm::StringRef Result = hmap(HM)->lookupFilename(llvm::StringRef(Filename), DestPath);
  return extra::makeCXString(Result.str());
}

CXString clang_HeaderMap_getFileName(CXHeaderMap HM) {
  return extra::makeCXString(hmap(HM)->getFileName().str());
}

CXString clang_HeaderMap_reverseLookupFilename(CXHeaderMap HM, const char *DestPath) {
  return extra::makeCXString(
      hmap(HM)->reverseLookupFilename(llvm::StringRef(DestPath)).str());
}

void clang_HeaderMap_dump(CXHeaderMap HM) { hmap(HM)->dump(); }

CXStringSet *clang_HeaderMap_getKeys(CXHeaderMap HM) {
  std::vector<std::string> Keys;
  hmap(HM)->forEachKey([&Keys](llvm::StringRef Key) { Keys.push_back(Key.str()); });
  return extra::makeCXStringSet(Keys);
}
