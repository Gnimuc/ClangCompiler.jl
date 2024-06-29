#ifndef LLVM_CLANG_C_EXTRA_CXPARSEAST_H
#define LLVM_CLANG_C_EXTRA_CXPARSEAST_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_ParseAST(CXSema Sema, bool PrintStats, bool SkipFunctionBodies);

LLVM_CLANG_C_EXTERN_C_END

#endif