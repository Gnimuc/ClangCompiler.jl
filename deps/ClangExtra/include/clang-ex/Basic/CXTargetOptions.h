#ifndef LLVM_CLANG_C_EXTRA_CXTARGETOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXTARGETOPTIONS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXTargetOptions clang_TargetOptions_create(CXInit_Error *ErrorCode);

void clang_TargetOptions_dispose(CXTargetOptions TO);

void clang_TargetOptions_setTriple(CXTargetOptions TO, const char *TripleStr, size_t Num);

void clang_TargetOptions_PrintStats(CXTargetOptions TO);

LLVM_CLANG_C_EXTERN_C_END

#endif