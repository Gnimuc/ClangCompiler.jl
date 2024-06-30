#ifndef LLVM_CLANG_C_EXTRA_CXLEXER_H
#define LLVM_CLANG_C_EXTRA_CXLEXER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile, CXSourceManager SM,
                           CXLangOptions langOpts);

void clang_Lexer_dispose(CXLexer Lex);

LLVM_CLANG_C_EXTERN_C_END

#endif