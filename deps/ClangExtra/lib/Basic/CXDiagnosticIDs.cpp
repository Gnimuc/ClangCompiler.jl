#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang/Basic/DiagnosticIDs.h"

#include <memory>

CXDiagnosticIDs clang_DiagnosticIDs_create(void) {
  auto DIDs = std::make_unique<clang::DiagnosticIDs>();
  // DiagnosticIDs is a RefCountedBase, so hand it back already holding the caller's own
  // reference rather than at a count of zero. Its one consumer here is
  // clang_DiagnosticsEngine_create, whose DiagnosticsEngine takes an IntrusiveRefCntPtr by
  // value and moves it into a member it keeps for the engine's whole life, so a borrow that
  // starts from zero goes 0 -> 1 -> 0 and deletes the table when that engine is disposed,
  // leaving the caller with a dangling handle for any later engine. Starting at one turns
  // every such borrow into 1 -> 2 -> 1, so one table can back several engines and the
  // caller's own dispose is the reference that frees it.
  DIDs->Retain();
  return reinterpret_cast<CXDiagnosticIDs>(DIDs.release());
}

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID) {
  // Balances the Retain in clang_DiagnosticIDs_create; the last Release deletes.
  reinterpret_cast<clang::DiagnosticIDs *>(ID)->Release();
}