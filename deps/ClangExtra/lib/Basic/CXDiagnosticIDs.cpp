#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang/Basic/DiagnosticIDs.h"

CXDiagnosticIDs clang_DiagnosticIDs_create(void) {
  auto DIDs = std::make_unique<clang::DiagnosticIDs>();
  return DIDs.release();
}

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID) {
  delete static_cast<clang::DiagnosticIDs *>(ID);
}