#ifndef LLVM_CLANG_C_EXTRA_CXCODEGENABITYPES_H
#define LLVM_CLANG_C_EXTRA_CXCODEGENABITYPES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

LLVMTypeRef clang_CodeGen_convertTypeForMemory(CXCodeGenModule CGM, CXQualType T);

LLVM_CLANG_C_EXTERN_C_END

#endif