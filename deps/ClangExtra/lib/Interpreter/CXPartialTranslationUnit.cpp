#include "clang-ex/Interpreter/CXPartialTranslationUnit.h"

#include "clang/Interpreter/PartialTranslationUnit.h"
#include "llvm/IR/Module.h"

CXTranslationUnitDecl clang_PartialTranslationUnit_getTUPart(CXPartialTranslationUnit PTU) {
  return reinterpret_cast<CXTranslationUnitDecl>(
      reinterpret_cast<clang::PartialTranslationUnit *>(PTU)->TUPart);
}

LLVMModuleRef clang_PartialTranslationUnit_getModule(CXPartialTranslationUnit PTU) {
  return llvm::wrap(reinterpret_cast<clang::PartialTranslationUnit *>(PTU)->TheModule.get());
}
