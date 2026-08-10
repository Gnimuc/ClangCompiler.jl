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

// The LLVM context the action is using, with ownership transferred to the caller. Every
// create above supplies the context, so what comes back is that same context -- the caller
// already owns it, and this only stops the action from also claiming it.
LLVMContextRef clang_CodeGenAction_takeLLVMContext(CXCodeGenAction CA);

// The action's code generator, which is the way into the whole CodeGenerator / CodeGenModule
// surface (clang-ex/CodeGen/CXModuleBuilder.h, CXCodeGenABITypes.h) from an action-driven
// compile rather than from an Interpreter.
//
// PRECONDITION: the action must have created its backend consumer, which happens in
// CreateASTConsumer -- i.e. only after clang_CompilerInstance_ExecuteAction has started it.
// The accessor dereferences that consumer unconditionally, so the shim checks it first and
// answers NULL (with a log line) rather than crashing.
CXCodeGenerator clang_CodeGenAction_getCodeGenerator(CXCodeGenAction CA);

LLVM_CLANG_C_EXTERN_C_END

#endif
