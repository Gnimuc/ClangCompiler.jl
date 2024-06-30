#include "clang-ex/Basic/CXIdentifierTable.h"
#include "clang/Basic/IdentifierTable.h"

void clang_IdentifierTable_PrintStats(CXIdentifierTable IT) {
  static_cast<clang::IdentifierTable *>(IT)->PrintStats();
}

CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents, const char *Name) {
  return &static_cast<clang::IdentifierTable *>(Idents)->get(llvm::StringRef(Name));
}