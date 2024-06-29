#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_HeaderSearch_PrintStats(CXHeaderSearch HS);

LLVM_CLANG_C_EXTERN_C_END

#endif