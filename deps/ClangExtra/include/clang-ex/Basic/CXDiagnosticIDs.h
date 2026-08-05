#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTICIDS_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTICIDS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/DiagnosticIDs.h: enum class diag::Severity (0 means "uncomputed" and has
// no enumerator).
typedef enum CXDiag_Severity {
  CXDiag_Severity_Ignored = 1,
  CXDiag_Severity_Remark = 2,
  CXDiag_Severity_Warning = 3,
  CXDiag_Severity_Error = 4,
  CXDiag_Severity_Fatal = 5
} CXDiag_Severity;

// clang/Basic/DiagnosticIDs.h: enum class diag::Flavor
typedef enum CXDiag_Flavor {
  CXDiag_Flavor_WarningOrError = 0,
  CXDiag_Flavor_Remark
} CXDiag_Flavor;

CXDiagnosticIDs clang_DiagnosticIDs_create(void);

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID);

LLVM_CLANG_C_EXTERN_C_END

#endif