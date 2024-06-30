#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO);

void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO, const char **IncsOut,
                                           size_t Num);

void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO);

LLVM_CLANG_C_EXTERN_C_END

#endif