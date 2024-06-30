#include "clang-ex/Sema/CXScope.h"
#include "clang/Sema/Scope.h"

void clang_Scope_dump(CXScope S) { static_cast<clang::Scope *>(S)->dump(); }

CXScope clang_Scope_getParent(CXScope S) {
  return static_cast<clang::Scope *>(S)->getParent();
}

unsigned clang_Scope_getDepth(CXScope S) {
  return static_cast<clang::Scope *>(S)->getDepth();
}