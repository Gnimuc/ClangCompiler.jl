#ifndef LIBCLANGEX_CXCODEGENABITYPES_H
#define LIBCLANGEX_CXCODEGENABITYPES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE LLVMTypeRef clang_CodeGen_convertTypeForMemory(CXCodeGenModule CGM, CXQualType T);

#ifdef __cplusplus
}
#endif
#endif