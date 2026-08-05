#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTICOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTICOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/DiagnosticOptions.h: enum OverloadsShown : unsigned
typedef enum CXOverloadsShown : unsigned {
  CXOverloadsShown_Ovl_All = 0,
  CXOverloadsShown_Ovl_Best
} CXOverloadsShown;

CXDiagnosticOptions clang_DiagnosticOptions_create(void);

void clang_DiagnosticOptions_dispose(CXDiagnosticOptions DO);

void clang_DiagnosticOptions_PrintStats(CXDiagnosticOptions DO);

void clang_DiagnosticOptions_setShowColors(CXDiagnosticOptions DO, bool ShowColors);

void clang_DiagnosticOptions_setShowPresumedLoc(CXDiagnosticOptions DO,
                                                bool ShowPresumedLoc);

LLVM_CLANG_C_EXTERN_C_END

#endif