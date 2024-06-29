#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang/Basic/DiagnosticIDs.h"

CXDiagnosticIDs clang_DiagnosticIDs_create(CXInit_Error *ErrorCode) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::DiagnosticIDs> ptr = std::make_unique<clang::DiagnosticIDs>();

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::DiagnosticIDs`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID) {
  delete static_cast<clang::DiagnosticIDs *>(ID);
}