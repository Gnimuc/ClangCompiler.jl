#ifndef LLVM_CLANG_C_EXTRA_CXFLOATMODEKIND_H
#define LLVM_CLANG_C_EXTRA_CXFLOATMODEKIND_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::FloatModeKind (clang/Basic/TargetInfo.h). The enumerators are bit flags
// with explicit values upstream, so the values are copied verbatim rather than left
// implicit; the LLVM_MARK_AS_BITMASK_ENUM alias enumerator is omitted like every other
// alias enumerator.
typedef enum CXFloatModeKind {
  CXFloatModeKind_NoFloat = 0,
  CXFloatModeKind_Half = 1,
  CXFloatModeKind_Float = 2,
  CXFloatModeKind_Double = 4,
  CXFloatModeKind_LongDouble = 8,
  CXFloatModeKind_Float128 = 16,
  CXFloatModeKind_Ibm128 = 32
} CXFloatModeKind;

LLVM_CLANG_C_EXTERN_C_END

#endif
