#ifndef LIBCLANGEX_CXTEXTDIAGNOSTICPRINTER_H
#define LIBCLANGEX_CXTEXTDIAGNOSTICPRINTER_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXDiagnosticConsumer
clang_TextDiagnosticPrinter_create(CXDiagnosticOptions Opts, CXInit_Error *ErrorCode);

#ifdef __cplusplus
}
#endif
#endif