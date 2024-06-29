#ifndef LLVM_CLANG_C_EXTRA_CXASTCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXASTCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_ASTConsumer_Initialize(CXASTConsumer Csr, CXASTContext Ctx);

void clang_ASTConsumer_HandleTranslationUnit(CXASTConsumer Csr, CXASTContext Ctx);

void clang_ASTConsumer_PrintStats(CXASTConsumer Csr);

LLVM_CLANG_C_EXTERN_C_END

#endif