#include "clang-ex/CodeGen/CXModuleBuilder.h"
#include "utils.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/GlobalDecl.h"
#include "clang/Basic/FileManager.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Frontend/CompilerInstance.h"
#include "llvm/IR/Constant.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"

namespace {

clang::CodeGenerator *unwrapCodeGen(CXCodeGenerator CG) {
  return reinterpret_cast<clang::CodeGenerator *>(CG);
}

CXString mangledNameOf(CXCodeGenerator CG, clang::GlobalDecl GD) {
  return extra::makeCXString(unwrapCodeGen(CG)->GetMangledName(GD).str());
}

LLVMValueRef addrOfGlobal(CXCodeGenerator CG, clang::GlobalDecl GD, bool IsForDefinition) {
  return llvm::wrap(unwrapCodeGen(CG)->GetAddrOfGlobal(GD, IsForDefinition));
}

} // namespace

CXCodeGenerator clang_CreateLLVMCodeGen(CXCompilerInstance CI, const char *ModuleName,
                                        LLVMContextRef LLVMCtx) {
  auto *Compiler = reinterpret_cast<clang::CompilerInstance *>(CI);
  if (!Compiler->hasFileManager()) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_CreateLLVMCodeGen: the CompilerInstance has no "
                    "FileManager, so it has no virtual file system to hand the code "
                    "generator\n";
    return nullptr;
  }
  return reinterpret_cast<CXCodeGenerator>(clang::CreateLLVMCodeGen(
      Compiler->getDiagnostics(), llvm::StringRef(ModuleName),
      Compiler->getFileManager().getVirtualFileSystemPtr(), Compiler->getHeaderSearchOpts(),
      Compiler->getPreprocessorOpts(), Compiler->getCodeGenOpts(), *llvm::unwrap(LLVMCtx),
      nullptr));
}

void clang_CodeGenerator_dispose(CXCodeGenerator CG) {
  delete reinterpret_cast<clang::CodeGenerator *>(CG);
}

CXCodeGenModule clang_CodeGenerator_CGM(CXCodeGenerator CG) {
  return reinterpret_cast<CXCodeGenModule>(&unwrapCodeGen(CG)->CGM());
}

LLVMModuleRef clang_CodeGenerator_GetModule(CXCodeGenerator CG) {
  return llvm::wrap(unwrapCodeGen(CG)->GetModule());
}

LLVMModuleRef clang_CodeGenerator_ReleaseModule(CXCodeGenerator CG) {
  return llvm::wrap(unwrapCodeGen(CG)->ReleaseModule());
}

CXDecl clang_CodeGenerator_GetDeclForMangledName(CXCodeGenerator CG,
                                                 const char *MangledName) {
  return reinterpret_cast<CXDecl>(const_cast<clang::Decl *>(
      unwrapCodeGen(CG)->GetDeclForMangledName(llvm::StringRef(MangledName))));
}

CXString clang_CodeGenerator_GetMangledName(CXCodeGenerator CG, CXNamedDecl D) {
  return mangledNameOf(CG, clang::GlobalDecl(reinterpret_cast<clang::NamedDecl *>(D)));
}

CXString clang_CodeGenerator_GetMangledNameFromCtorDecl(CXCodeGenerator CG,
                                                        CXCXXConstructorDecl D,
                                                        CXCXXCtorType CtorKind) {
  return mangledNameOf(CG,
                       clang::GlobalDecl(reinterpret_cast<clang::CXXConstructorDecl *>(D),
                                         static_cast<clang::CXXCtorType>(CtorKind)));
}

CXString clang_CodeGenerator_GetMangledNameFromDtorDecl(CXCodeGenerator CG,
                                                        CXCXXDestructorDecl D,
                                                        CXCXXDtorType DtorKind) {
  return mangledNameOf(CG, clang::GlobalDecl(reinterpret_cast<clang::CXXDestructorDecl *>(D),
                                             static_cast<clang::CXXDtorType>(DtorKind)));
}

LLVMValueRef clang_CodeGenerator_GetAddrOfGlobal(CXCodeGenerator CG, CXNamedDecl D,
                                                 bool IsForDefinition) {
  return addrOfGlobal(CG, clang::GlobalDecl(reinterpret_cast<clang::NamedDecl *>(D)),
                      IsForDefinition);
}

LLVMValueRef clang_CodeGenerator_GetAddrOfGlobalFromCtorDecl(CXCodeGenerator CG,
                                                             CXCXXConstructorDecl D,
                                                             CXCXXCtorType CtorKind,
                                                             bool IsForDefinition) {
  return addrOfGlobal(CG,
                      clang::GlobalDecl(reinterpret_cast<clang::CXXConstructorDecl *>(D),
                                        static_cast<clang::CXXCtorType>(CtorKind)),
                      IsForDefinition);
}

LLVMValueRef clang_CodeGenerator_GetAddrOfGlobalFromDtorDecl(CXCodeGenerator CG,
                                                             CXCXXDestructorDecl D,
                                                             CXCXXDtorType DtorKind,
                                                             bool IsForDefinition) {
  return addrOfGlobal(CG,
                      clang::GlobalDecl(reinterpret_cast<clang::CXXDestructorDecl *>(D),
                                        static_cast<clang::CXXDtorType>(DtorKind)),
                      IsForDefinition);
}

LLVMModuleRef clang_CodeGenerator_StartModule(CXCodeGenerator CG, LLVMContextRef LLVMCtx,
                                              const char *ModuleName) {
  return llvm::wrap(
      unwrapCodeGen(CG)->StartModule(llvm::StringRef(ModuleName), *llvm::unwrap(LLVMCtx)));
}
