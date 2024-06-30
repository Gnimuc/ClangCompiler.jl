#ifndef LLVM_CLANG_C_EXTRA_CXVISIBILITY_H
#define LLVM_CLANG_C_EXTRA_CXVISIBILITY_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXVisibility {
  CXVisibility_HiddenVisibility,
  CXVisibility_ProtectedVisibility,
  CXVisibility_DefaultVisibility
} CXVisibility;

LLVM_CLANG_C_EXTERN_C_END

#endif