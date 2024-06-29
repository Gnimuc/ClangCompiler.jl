#ifndef LIBCLANGEX_CXDIAGNOSTICIDS_H
#define LIBCLANGEX_CXDIAGNOSTICIDS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXDiagnosticIDs clang_DiagnosticIDs_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID);

#ifdef __cplusplus
}
#endif
#endif