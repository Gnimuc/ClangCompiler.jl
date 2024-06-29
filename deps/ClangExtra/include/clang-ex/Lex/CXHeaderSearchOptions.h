#ifndef LIBCLANGEX_CXHEADERSEARCHOPTIONS_H
#define LIBCLANGEX_CXHEADERSEARCHOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE size_t
clang_HeaderSearchOptions_GetResourceDirLength(CXHeaderSearchOptions HSO);

CINDEX_LINKAGE void clang_HeaderSearchOptions_GetResourceDir(CXHeaderSearchOptions HSO,
                                                             char *ResourcesDir, size_t N);

CINDEX_LINKAGE void clang_HeaderSearchOptions_SetResourceDir(CXHeaderSearchOptions HSO,
                                                             const char *ResourcesDir,
                                                             size_t N);

CINDEX_LINKAGE void clang_HeaderSearchOptions_PrintStats(CXHeaderSearchOptions HSO);

#ifdef __cplusplus
}
#endif
#endif