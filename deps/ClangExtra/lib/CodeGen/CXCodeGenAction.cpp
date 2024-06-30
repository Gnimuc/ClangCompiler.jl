#include "clang-ex/CodeGen/CXCodeGenAction.h"
#include "clang/CodeGen/CodeGenAction.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

CXCodeGenAction clang_EmitAssemblyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitAssemblyAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

CXCodeGenAction clang_EmitBCAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitBCAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

CXCodeGenAction clang_EmitLLVMAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitLLVMAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

CXCodeGenAction clang_EmitLLVMOnlyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitLLVMOnlyAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

CXCodeGenAction clang_EmitCodeGenOnlyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitCodeGenOnlyAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

CXCodeGenAction clang_EmitObjAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitObjAction>(llvm::unwrap(LLVMCtx));
  return CGA.release();
}

void clang_CodeGenAction_dispose(CXCodeGenAction CA) {
  delete static_cast<clang::CodeGenAction *>(CA);
}

LLVMModuleRef clang_CodeGenAction_takeModule(CXCodeGenAction CA) {
  return llvm::wrap((static_cast<clang::CodeGenAction *>(CA)->takeModule()).release());
}