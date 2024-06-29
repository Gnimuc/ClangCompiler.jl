#ifndef LIBCLANGEX_CXDIAGNOSTICOPTIONS_H
#define LIBCLANGEX_CXDIAGNOSTICOPTIONS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXDiagnosticOptions clang_DiagnosticOptions_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_DiagnosticOptions_dispose(CXDiagnosticOptions DO);

CINDEX_LINKAGE void clang_DiagnosticOptions_PrintStats(CXDiagnosticOptions DO);

CINDEX_LINKAGE void clang_DiagnosticOptions_setShowColors(CXDiagnosticOptions DO,
                                                          bool ShowColors);

CINDEX_LINKAGE void clang_DiagnosticOptions_setShowPresumedLoc(CXDiagnosticOptions DO,
                                                               bool ShowPresumedLoc);

#ifdef __cplusplus
}
#endif
#endif