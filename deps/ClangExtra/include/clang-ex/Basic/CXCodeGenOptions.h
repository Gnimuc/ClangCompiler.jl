#ifndef LIBCLANGEX_CXCODEGENOPTIONS_H
#define LIBCLANGEX_CXCODEGENOPTIONS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXCodeGenOptions clang_CodeGenOptions_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_CodeGenOptions_dispose(CXCodeGenOptions DO);

CINDEX_LINKAGE const char *clang_CodeGenOptions_getArgv0(CXCodeGenOptions CGO);

CINDEX_LINKAGE void clang_CodeGenOptions_PrintStats(CXCodeGenOptions CGO);

#ifdef __cplusplus
}
#endif
#endif