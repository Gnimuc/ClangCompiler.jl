#ifndef LLVM_CLANG_C_EXTRA_CXASTDUMPERUTILS_H
#define LLVM_CLANG_C_EXTRA_CXASTDUMPERUTILS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/AST/ASTDumperUtils.h: enum clang::ASTDumpOutputFormat. Selects between the indented
// tree clang_Decl_dump writes and a machine-readable JSON rendering of the same nodes.
typedef enum CXASTDumpOutputFormat {
  CXASTDumpOutputFormat_ADOF_Default,
  CXASTDumpOutputFormat_ADOF_JSON
} CXASTDumpOutputFormat;

LLVM_CLANG_C_EXTERN_C_END

#endif
