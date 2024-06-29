#ifndef LLVM_CLANG_C_EXTRA_CXSCOPE_H
#define LLVM_CLANG_C_EXTRA_CXSCOPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_Scope_dump(CXScope S);

CXScope clang_Scope_getParent(CXScope S);

unsigned clang_Scope_getDepth(CXScope S);

LLVM_CLANG_C_EXTERN_C_END

#endif