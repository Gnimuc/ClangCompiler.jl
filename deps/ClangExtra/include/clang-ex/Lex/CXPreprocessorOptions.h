#ifndef LIBCLANGEX_CXPREPROCESSOROPTIONS_H
#define LIBCLANGEX_CXPREPROCESSOROPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO);

CINDEX_LINKAGE void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO,
                                                          const char **IncsOut, size_t Num);

CINDEX_LINKAGE void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO);

#ifdef __cplusplus
}
#endif
#endif