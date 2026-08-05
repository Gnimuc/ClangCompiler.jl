#ifndef LLVM_CLANG_C_EXTRA_CXBUILTINS_H
#define LLVM_CLANG_C_EXTRA_CXBUILTINS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/Builtins.h: enum BuiltinTemplateKind
typedef enum CXBuiltinTemplateKind {
  CXBuiltinTemplateKind_BTK__make_integer_seq,
  CXBuiltinTemplateKind_BTK__type_pack_element
} CXBuiltinTemplateKind;

LLVM_CLANG_C_EXTERN_C_END

#endif
