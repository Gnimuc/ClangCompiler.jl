#ifndef LLVM_CLANG_C_EXTRA_CXERROR_H
#define LLVM_CLANG_C_EXTRA_CXERROR_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum {
  CXInit_NoError = 0,
  CXInit_CanNotCreate = 1
} CXInit_Error;

LLVM_CLANG_C_EXTERN_C_END

#endif