#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

unsigned clang_FrontendOptions_getModulesEmbedFilesNum(CXFrontendOptions FEO);

// Fills `Buf` with min(N, count) pointers borrowed from the options' own
// storage — valid while the FrontendOptions object is alive and unmodified.
void clang_FrontendOptions_getModulesEmbedFiles(CXFrontendOptions FEO, const char **Buf,
                                                unsigned N);

void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO);

LLVM_CLANG_C_EXTERN_C_END

#endif