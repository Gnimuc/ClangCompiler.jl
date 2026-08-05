#ifndef LLVM_CLANG_C_EXTRA_CXTARGETCXXABI_H
#define LLVM_CLANG_C_EXTRA_CXTARGETCXXABI_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors TargetCXXABI::Kind, whose enumerators come from
// clang/Basic/TargetCXXABI.def in declaration order.
typedef enum CXTargetCXXABI_Kind {
  CXTargetCXXABI_GenericItanium = 0,
  CXTargetCXXABI_GenericARM,
  CXTargetCXXABI_iOS,
  CXTargetCXXABI_AppleARM64,
  CXTargetCXXABI_WatchOS,
  CXTargetCXXABI_GenericAArch64,
  CXTargetCXXABI_GenericMIPS,
  CXTargetCXXABI_WebAssembly,
  CXTargetCXXABI_Fuchsia,
  CXTargetCXXABI_XL,
  CXTargetCXXABI_Microsoft
} CXTargetCXXABI_Kind;

LLVM_CLANG_C_EXTERN_C_END

#endif
