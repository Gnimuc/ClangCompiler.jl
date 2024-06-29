#include "clang-ex/CodeGen/CXCodeGenABITypes.h"
#include "clang/CodeGen/CodeGenABITypes.h"

LLVMTypeRef clang_CodeGen_convertTypeForMemory(CXCodeGenModule CGM, CXQualType T) {
  return llvm::wrap(clang::CodeGen::convertTypeForMemory(
      *static_cast<clang::CodeGen::CodeGenModule *>(CGM),
      clang::QualType::getFromOpaquePtr(T)));
}