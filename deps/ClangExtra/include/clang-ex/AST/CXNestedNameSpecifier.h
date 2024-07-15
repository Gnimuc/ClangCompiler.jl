#ifndef LLVM_CLANG_C_EXTRA_CXNESTEDNAMESPECIFIER_H
#define LLVM_CLANG_C_EXTRA_CXNESTEDNAMESPECIFIER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXNestedNameSpecifier clang_NestedNameSpecifier_getPrefix(CXNestedNameSpecifier NNS);

bool clang_NestedNameSpecifier_containsErrors(CXNestedNameSpecifier NNS);

void clang_NestedNameSpecifier_dump(CXNestedNameSpecifier NNS);

CXString clang_NestedNameSpecifier_getName(CXNestedNameSpecifier NNS);

LLVM_CLANG_C_EXTERN_C_END

#endif