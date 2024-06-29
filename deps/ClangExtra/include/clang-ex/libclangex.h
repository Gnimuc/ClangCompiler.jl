#ifndef LLVM_CLANG_C_EXTRA_H
#define LLVM_CLANG_C_EXTRA_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_Stmt_EnableStatistics(void);
void clang_Stmt_PrintStats(void);

LLVM_CLANG_C_EXTERN_C_END

#endif
