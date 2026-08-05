#include "clang-ex/Lex/CXDirectoryLookup.h"
#include "utils.h"
#include "clang/Basic/FileManager.h"
#include "clang/Lex/DirectoryLookup.h"
#include <memory>

CXDirectoryLookup clang_DirectoryLookup_create(CXDirectoryEntryRef Dir,
                                               CXCharacteristicKind DT, bool isFramework) {
  return reinterpret_cast<CXDirectoryLookup>(std::make_unique<clang::DirectoryLookup>(
             *reinterpret_cast<clang::DirectoryEntryRef *>(Dir),
             static_cast<clang::SrcMgr::CharacteristicKind>(DT), isFramework)
      .release());
}

void clang_DirectoryLookup_dispose(CXDirectoryLookup DL) {
  delete reinterpret_cast<clang::DirectoryLookup *>(DL);
}

CXString clang_DirectoryLookup_getName(CXDirectoryLookup DL) {
  return extra::makeCXString(reinterpret_cast<clang::DirectoryLookup *>(DL)->getName().str());
}
