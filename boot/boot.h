#ifndef CLANG_COMPILER_BOOT_H
#define CLANG_COMPILER_BOOT_H

#include "CXTypes.h"
#include "julia.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void
clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP);

CINDEX_LINKAGE bool
clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP);

#ifdef __cplusplus
}
#endif
#endif