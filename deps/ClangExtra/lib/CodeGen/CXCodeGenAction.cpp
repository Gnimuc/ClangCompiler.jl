#include "clang-ex/CodeGen/CXCodeGenAction.h"
#include "clang/CodeGen/CodeGenAction.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>

CXCodeGenAction clang_EmitAssemblyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitAssemblyAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

CXCodeGenAction clang_EmitBCAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitBCAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

CXCodeGenAction clang_EmitLLVMAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitLLVMAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

CXCodeGenAction clang_EmitLLVMOnlyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitLLVMOnlyAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

CXCodeGenAction clang_EmitCodeGenOnlyAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitCodeGenOnlyAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

CXCodeGenAction clang_EmitObjAction_create(LLVMContextRef LLVMCtx) {
  auto CGA = std::make_unique<clang::EmitObjAction>(llvm::unwrap(LLVMCtx));
  return reinterpret_cast<CXCodeGenAction>(CGA.release());
}

void clang_CodeGenAction_dispose(CXCodeGenAction CA) {
  delete reinterpret_cast<clang::CodeGenAction *>(CA);
}

LLVMModuleRef clang_CodeGenAction_takeModule(CXCodeGenAction CA) {
  return llvm::wrap((reinterpret_cast<clang::CodeGenAction *>(CA)->takeModule()).release());
}

LLVMContextRef clang_CodeGenAction_takeLLVMContext(CXCodeGenAction CA) {
  return llvm::wrap(reinterpret_cast<clang::CodeGenAction *>(CA)->takeLLVMContext());
}

CXCodeGenerator clang_CodeGenAction_getCodeGenerator(CXCodeGenAction CA) {
  auto *Action = reinterpret_cast<clang::CodeGenAction *>(CA);
  if (!Action->BEConsumer) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_CodeGenAction_getCodeGenerator: the action has "
                    "not created its backend consumer yet; run the action first\n";
    return nullptr;
  }
  return reinterpret_cast<CXCodeGenerator>(Action->getCodeGenerator());
}