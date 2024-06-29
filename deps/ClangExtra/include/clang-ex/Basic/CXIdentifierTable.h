#ifndef LLVM_CLANG_C_EXTRA_CXIDENTIFIERTABLE_H
#define LLVM_CLANG_C_EXTRA_CXIDENTIFIERTABLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_IdentifierTable_PrintStats(CXIdentifierTable IT);

CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents, const char *Name);

LLVM_CLANG_C_EXTERN_C_END

#endif