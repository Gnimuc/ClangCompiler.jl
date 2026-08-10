#ifndef LLVM_CLANG_C_EXTRA_CXABI_H
#define LLVM_CLANG_C_EXTRA_CXABI_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/ABI.h: enum clang::CXXCtorType. Which of a constructor's several emitted
// bodies a GlobalDecl names.
typedef enum CXCXXCtorType {
  CXCXXCtorType_Ctor_Complete,
  CXCXXCtorType_Ctor_Base,
  CXCXXCtorType_Ctor_Comdat,
  CXCXXCtorType_Ctor_CopyingClosure,
  CXCXXCtorType_Ctor_DefaultClosure
} CXCXXCtorType;

// clang/Basic/ABI.h: enum clang::CXXDtorType.
typedef enum CXCXXDtorType {
  CXCXXDtorType_Dtor_Deleting,
  CXCXXDtorType_Dtor_Complete,
  CXCXXDtorType_Dtor_Base,
  CXCXXDtorType_Dtor_Comdat
} CXCXXDtorType;

LLVM_CLANG_C_EXTERN_C_END

#endif
