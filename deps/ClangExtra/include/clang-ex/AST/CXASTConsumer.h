#ifndef LLVM_CLANG_C_EXTRA_CXASTCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXASTCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A plain clang::ASTConsumer: every virtual on the base has an empty body, so this is the
// consumer a parse-only driver wants -- CompilerInstance::createSema requires one, and a
// driver that never generates code has nothing for it to do.
// ADOPTION: clang_CompilerInstance_setASTConsumer rewraps this in a unique_ptr, so once it
// has been installed the instance frees it and clang_ASTConsumer_dispose is a double free.
CXASTConsumer clang_ASTConsumer_create(void);

void clang_ASTConsumer_dispose(CXASTConsumer Csr);

void clang_ASTConsumer_Initialize(CXASTConsumer Csr, CXASTContext Ctx);

void clang_ASTConsumer_HandleTranslationUnit(CXASTConsumer Csr, CXASTContext Ctx);

void clang_ASTConsumer_PrintStats(CXASTConsumer Csr);

LLVM_CLANG_C_EXTERN_C_END

#endif