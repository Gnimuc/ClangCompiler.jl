#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTICIDS_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTICIDS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDiagnosticIDs clang_DiagnosticIDs_create(CXInit_Error *ErrorCode);

void clang_DiagnosticIDs_dispose(CXDiagnosticIDs ID);

LLVM_CLANG_C_EXTERN_C_END

#endif