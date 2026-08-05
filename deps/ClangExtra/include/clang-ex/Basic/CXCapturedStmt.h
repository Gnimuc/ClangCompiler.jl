#ifndef LLVM_CLANG_C_EXTRA_CXCAPTUREDSTMT_H
#define LLVM_CLANG_C_EXTRA_CXCAPTUREDSTMT_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::CapturedRegionKind (clang/Basic/CapturedStmt.h): which language
// construct a CapturedStmt was outlined for.
typedef enum CXCapturedRegionKind {
  CXCapturedRegionKind_CR_Default,
  CXCapturedRegionKind_CR_ObjCAtFinally,
  CXCapturedRegionKind_CR_OpenMP
} CXCapturedRegionKind;

LLVM_CLANG_C_EXTERN_C_END

#endif
