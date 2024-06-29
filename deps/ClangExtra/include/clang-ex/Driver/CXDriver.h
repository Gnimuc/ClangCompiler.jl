#ifndef LIBCLANGEX_CXDRIVER_H
#define LIBCLANGEX_CXDRIVER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath);

CINDEX_LINKAGE void clang_Driver_GetResourcesPath(const char *BinaryPath,
                                                  char *ResourcesPath, size_t N);

#ifdef __cplusplus
}
#endif
#endif