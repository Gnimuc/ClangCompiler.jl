#ifndef LLVM_CLANG_C_EXTRA_CXCODEGENACTION_H
#define LLVM_CLANG_C_EXTRA_CXCODEGENACTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCodeGenAction clang_EmitAssemblyAction_create(LLVMContextRef LLVMCtx);
CXCodeGenAction clang_EmitBCAction_create(LLVMContextRef LLVMCtx);
CXCodeGenAction clang_EmitLLVMAction_create(LLVMContextRef LLVMCtx);
CXCodeGenAction clang_EmitLLVMOnlyAction_create(LLVMContextRef LLVMCtx);
CXCodeGenAction clang_EmitCodeGenOnlyAction_create(LLVMContextRef LLVMCtx);
CXCodeGenAction clang_EmitObjAction_create(LLVMContextRef LLVMCtx);

void clang_CodeGenAction_dispose(CXCodeGenAction CA);

LLVMModuleRef clang_CodeGenAction_takeModule(CXCodeGenAction CA);

LLVM_CLANG_C_EXTERN_C_END

#endif