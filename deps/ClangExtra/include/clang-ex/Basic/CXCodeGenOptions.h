#ifndef LLVM_CLANG_C_EXTRA_CXCODEGENOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXCODEGENOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCodeGenOptions clang_CodeGenOptions_create(void);

void clang_CodeGenOptions_dispose(CXCodeGenOptions DO);

const char *clang_CodeGenOptions_getArgv0(CXCodeGenOptions CGO);

unsigned clang_CodeGenOptions_getCommandLineArgsNum(CXCodeGenOptions CGO);

// Fills `Buf` with min(N, count) pointers borrowed from the options' own
// storage — valid while the CodeGenOptions object is alive and unmodified.
void clang_CodeGenOptions_getCommandLineArgs(CXCodeGenOptions CGO, const char **Buf,
                                             unsigned N);

void clang_CodeGenOptions_PrintStats(CXCodeGenOptions CGO);

LLVM_CLANG_C_EXTERN_C_END

#endif