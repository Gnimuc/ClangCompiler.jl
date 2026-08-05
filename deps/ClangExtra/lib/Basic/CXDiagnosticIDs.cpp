#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang/Basic/DiagnosticIDs.h"

CXDiagnosticIDs clang_DiagnosticIDs_create(void) {
  auto DIDs = std::make_unique<clang::DiagnosticIDs>();
  return reinterpret_cast<CXDiagnosticIDs>(DIDs.release());
}

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID) {
  delete reinterpret_cast<clang::DiagnosticIDs *>(ID);
}