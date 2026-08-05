#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Lex/PreprocessorOptions.h: enum class DisableValidationForModuleKind.
// The trailing LLVM_MARK_AS_BITMASK_ENUM(Module) is omitted: it expands to
// LLVM_BITMASK_LARGEST_ENUMERATOR = Module, a duplicate value Julia's @enum rejects.
typedef enum CXDisableValidationForModuleKind {
  CXDisableValidationForModuleKind_None = 0,
  CXDisableValidationForModuleKind_PCH = 1,
  CXDisableValidationForModuleKind_Module = 2,
  CXDisableValidationForModuleKind_All = 3
} CXDisableValidationForModuleKind;

size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO);

void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO, const char **IncsOut,
                                           size_t Num);

void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO);

LLVM_CLANG_C_EXTERN_C_END

#endif