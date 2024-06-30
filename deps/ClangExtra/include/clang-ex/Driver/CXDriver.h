#ifndef LLVM_CLANG_C_EXTRA_CXDRIVER_H
#define LLVM_CLANG_C_EXTRA_CXDRIVER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath);

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N);

LLVM_CLANG_C_EXTERN_C_END

#endif