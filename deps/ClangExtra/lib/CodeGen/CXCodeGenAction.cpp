#include "clang-ex/CodeGen/CXCodeGenAction.h"
#include "clang/CodeGen/CodeGenAction.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"

CXCodeGenAction clang_EmitAssemblyAction_create(CXInit_Error *ErrorCode,
                                                LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitAssemblyAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitAssemblyAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

CXCodeGenAction clang_EmitBCAction_create(CXInit_Error *ErrorCode, LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitBCAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitBCAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

CXCodeGenAction clang_EmitLLVMAction_create(CXInit_Error *ErrorCode,
                                            LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitLLVMAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitLLVMAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

CXCodeGenAction clang_EmitLLVMOnlyAction_create(CXInit_Error *ErrorCode,
                                                LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitLLVMOnlyAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitLLVMOnlyAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

CXCodeGenAction clang_EmitCodeGenOnlyAction_create(CXInit_Error *ErrorCode,
                                                   LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitCodeGenOnlyAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitCodeGenOnlyAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

CXCodeGenAction clang_EmitObjAction_create(CXInit_Error *ErrorCode,
                                           LLVMContextRef LLVMCtx) {
  CXInit_Error Err = CXInit_NoError;
  std::unique_ptr<clang::CodeGenAction> ptr =
      std::make_unique<clang::EmitObjAction>(llvm::unwrap(LLVMCtx));

  if (!ptr) {
    fprintf(stderr, "LIBCLANGEX ERROR: failed to create `clang::EmitObjAction`\n");
    Err = CXInit_CanNotCreate;
  }

  if (ErrorCode)
    *ErrorCode = Err;

  return ptr.release();
}

void clang_CodeGenAction_dispose(CXCodeGenAction CA) {
  delete static_cast<clang::CodeGenAction *>(CA);
}

LLVMModuleRef clang_CodeGenAction_takeModule(CXCodeGenAction CA) {
  return llvm::wrap((static_cast<clang::CodeGenAction *>(CA)->takeModule()).release());
}