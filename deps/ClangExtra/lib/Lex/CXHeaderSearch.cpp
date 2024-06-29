#include "clang-ex/Lex/CXHeaderSearch.h"
#include "clang/Lex/HeaderSearch.h"

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS) {
  static_cast<clang::HeaderSearch *>(HS)->PrintStats();
}