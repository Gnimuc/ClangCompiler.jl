#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCHOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCHOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

size_t clang_HeaderSearchOptions_GetResourceDirLength(CXHeaderSearchOptions HSO);

void clang_HeaderSearchOptions_GetResourceDir(CXHeaderSearchOptions HSO, char *ResourcesDir,
                                              size_t N);

void clang_HeaderSearchOptions_SetResourceDir(CXHeaderSearchOptions HSO,
                                              const char *ResourcesDir, size_t N);

void clang_HeaderSearchOptions_PrintStats(CXHeaderSearchOptions HSO);

LLVM_CLANG_C_EXTERN_C_END

#endif