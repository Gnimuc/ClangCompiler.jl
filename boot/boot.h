#ifndef CLANG_COMPILER_BOOT_H
#define CLANG_COMPILER_BOOT_H

#include "CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP);

#ifdef __cplusplus
}
#endif
#endif