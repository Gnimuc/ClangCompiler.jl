#include "clang-ex/Interpreter/CXInterpreter.h"
#include "clang/Frontend/CompilerInstance.h"
// hacks
// #include "clang/Interpreter/Interpreter.h"
#include "Interpreter/IncrementalParser.h"
#include "Interpreter/Interpreter.h"

#include <memory>
#include <vector>

CXIncrementalCompilerBuilder clang_IncrementalCompilerBuilder_create(void) {
  auto CB = std::make_unique<clang::IncrementalCompilerBuilder>();
  return reinterpret_cast<CXIncrementalCompilerBuilder>(CB.release());
}

void clang_IncrementalCompilerBuilder_dispose(CXIncrementalCompilerBuilder CB) {
  delete reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB);
}

void clang_IncrementalCompilerBuilder_SetCompilerArgs(CXIncrementalCompilerBuilder CB,
                                                      const char **Args, int N) {
  std::vector<const char *> arr(Args, Args + N);
  reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->SetCompilerArgs(arr);
}

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCpp(CXIncrementalCompilerBuilder CB) {
  auto CI = reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->CreateCpp();
  if (auto E = CI.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  std::unique_ptr<clang::CompilerInstance> Ptr = std::move(*CI);
  return reinterpret_cast<CXCompilerInstance>(Ptr.release());
}

void clang_IncrementalCompilerBuilder_SetOffloadArch(CXIncrementalCompilerBuilder CB,
                                                     const char *Arch) {
  reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->SetOffloadArch(
      llvm::StringRef(Arch));
}

void clang_IncrementalCompilerBuilder_SetCudaSDK(CXIncrementalCompilerBuilder CB,
                                                 const char *path) {
  reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->SetCudaSDK(llvm::StringRef(path));
}

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCudaHost(CXIncrementalCompilerBuilder CB) {
  auto CI = reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->CreateCudaHost();
  if (auto E = CI.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  std::unique_ptr<clang::CompilerInstance> Ptr = std::move(*CI);
  return reinterpret_cast<CXCompilerInstance>(Ptr.release());
}

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCudaDevice(CXIncrementalCompilerBuilder CB) {
  auto CI = reinterpret_cast<clang::IncrementalCompilerBuilder *>(CB)->CreateCudaDevice();
  if (auto E = CI.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  std::unique_ptr<clang::CompilerInstance> Ptr = std::move(*CI);
  return reinterpret_cast<CXCompilerInstance>(Ptr.release());
}

CXInterpreter clang_Interpreter_create(CXCompilerInstance CI) {
  auto I = clang::Interpreter::create(
      std::unique_ptr<clang::CompilerInstance>(reinterpret_cast<clang::CompilerInstance *>(CI)));
  if (auto E = I.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  std::unique_ptr<clang::Interpreter> Ptr = std::move(*I);
  return reinterpret_cast<CXInterpreter>(Ptr.release());
}

CXInterpreter clang_Interpreter_createWithCUDA(CXCompilerInstance CI,
                                               CXCompilerInstance DCI) {
  auto I = clang::Interpreter::createWithCUDA(
      std::unique_ptr<clang::CompilerInstance>(reinterpret_cast<clang::CompilerInstance *>(CI)),
      std::unique_ptr<clang::CompilerInstance>(
          reinterpret_cast<clang::CompilerInstance *>(DCI)));
  if (auto E = I.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  std::unique_ptr<clang::Interpreter> Ptr = std::move(*I);
  return reinterpret_cast<CXInterpreter>(Ptr.release());
}

void clang_Interpreter_dispose(CXInterpreter Interp) {
  delete reinterpret_cast<clang::Interpreter *>(Interp);
}

CXCompilerInstance clang_Interpreter_getCompilerInstance(CXInterpreter Interp) {
  return reinterpret_cast<CXCompilerInstance>(const_cast<clang::CompilerInstance *>(
      reinterpret_cast<clang::Interpreter *>(Interp)->getCompilerInstance()));
}

LLVMOrcLLJITRef clang_Interpreter_getExecutionEngine(CXInterpreter Interp) {
  return reinterpret_cast<LLVMOrcLLJITRef>(const_cast<llvm::orc::LLJIT *>(
      &*reinterpret_cast<clang::Interpreter *>(Interp)->getExecutionEngine()));
}

CXPartialTranslationUnit clang_Interpreter_Parse(CXInterpreter Interp, const char *Code) {
  auto PTU = reinterpret_cast<clang::Interpreter *>(Interp)->Parse(llvm::StringRef(Code));
  if (auto E = PTU.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return nullptr;
  }
  return reinterpret_cast<CXPartialTranslationUnit>(&*PTU);
}

void clang_Interpreter_Execute(CXInterpreter Interp, CXPartialTranslationUnit PTU) {
  auto Err = reinterpret_cast<clang::Interpreter *>(Interp)->Execute(
      *reinterpret_cast<clang::PartialTranslationUnit *>(PTU));
  if (Err)
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(Err)) << "\n";
}

void clang_Interpreter_ParseAndExecute(CXInterpreter Interp, const char *Code,
                                       CXValue Result) {
  auto Err = reinterpret_cast<clang::Interpreter *>(Interp)->ParseAndExecute(
      llvm::StringRef(Code), reinterpret_cast<clang::Value *>(Result));
  if (Err)
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(Err)) << "\n";
}

LLVMOrcExecutorAddress clang_Interpreter_CompileDtorCall(CXInterpreter Interp,
                                                         CXCXXRecordDecl CXXRD) {
  auto Addr = reinterpret_cast<clang::Interpreter *>(Interp)->CompileDtorCall(
      reinterpret_cast<clang::CXXRecordDecl *>(CXXRD));
  if (auto E = Addr.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return 0;
  }
  return Addr->getValue();
}

void clang_Interpreter_Undo(CXInterpreter Interp, unsigned int N) {
  auto Err = reinterpret_cast<clang::Interpreter *>(Interp)->Undo(N);
  if (Err)
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(Err)) << "\n";
}

void clang_Interpreter_LoadDynamicLibrary(CXInterpreter Interp, const char *name) {
  auto Err = reinterpret_cast<clang::Interpreter *>(Interp)->LoadDynamicLibrary(name);
  if (Err)
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(Err)) << "\n";
}

LLVMOrcExecutorAddress clang_Interpreter_getSymbolAddress(CXInterpreter Interp,
                                                          const char *IRName) {
  auto Addr =
      reinterpret_cast<clang::Interpreter *>(Interp)->getSymbolAddress(llvm::StringRef(IRName));
  if (auto E = Addr.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return 0;
  }
  return Addr->getValue();
}

LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromLinkerName(CXInterpreter Interp,
                                                 const char *LinkerName) {
  auto Addr = reinterpret_cast<clang::Interpreter *>(Interp)->getSymbolAddressFromLinkerName(
      llvm::StringRef(LinkerName));
  if (auto E = Addr.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return 0;
  }
  return Addr->getValue();
}

CXCodeGenerator clang_Interpreter_getCodeGen(CXInterpreter Interp) {
  return reinterpret_cast<CXCodeGenerator>(reinterpret_cast<clang::Interpreter *>(Interp)->IncrParser->getCodeGen());
}

CXParser clang_Interpreter_getParser(CXInterpreter Interp) {
  return reinterpret_cast<CXParser>(reinterpret_cast<clang::Interpreter *>(Interp)->IncrParser->P.get());
}

CXASTContext clang_Interpreter_getASTContext(CXInterpreter Interp) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::Interpreter *>(Interp)->getASTContext());
}
