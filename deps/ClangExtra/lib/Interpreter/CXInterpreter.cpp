#include "clang-ex/Interpreter/CXInterpreter.h"
#include "utils.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/GlobalDecl.h"
#include "clang/Frontend/CompilerInstance.h"
// hacks: access-specifier edits of clang 20 Interpreter internals so we can
// reach getCodeGen, CompileDtorCall, IncrParser, and IncrementalParser::P.
// #include "clang/Interpreter/Interpreter.h"
#include "Interpreter/IncrementalParser.h"
#include "Interpreter/Interpreter.h"
#include "llvm/Support/TargetSelect.h"

#include <list>
#include <memory>
#include <mutex>
#include <optional>
#include <string>
#include <vector>

namespace {

void ensureLLVMTargets() {
  static std::once_flag Once;
  std::call_once(Once, [] {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargets();
    llvm::InitializeAllTargetMCs();
    llvm::InitializeAllAsmPrinters();
    llvm::InitializeAllAsmParsers();
  });
}

// The four fallible void methods return their llvm::Error's message, empty on success.
// Consuming the Error is mandatory: a destroyed-unconsumed Error aborts under the assertion
// builds build_local.jl supports.
CXString takeErrorMessage(llvm::Error Err) {
  if (!Err)
    return extra::makeCXString(std::string());
  return extra::makeCXString(llvm::toString(std::move(Err)));
}

LLVMOrcExecutorAddress symbolAddressOf(CXInterpreter Interp, clang::GlobalDecl GD) {
  auto Addr = reinterpret_cast<clang::Interpreter *>(Interp)->getSymbolAddress(GD);
  if (auto E = Addr.takeError()) {
    llvm::errs() << "LIBCLANGEX ERROR: " << llvm::toString(std::move(E)) << "\n";
    return 0;
  }
  return Addr->getValue();
}

} // namespace

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
  ensureLLVMTargets();
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
  ensureLLVMTargets();
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
  return reinterpret_cast<CXCompilerInstance>(
      reinterpret_cast<clang::Interpreter *>(Interp)->getCompilerInstance());
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

CXString clang_Interpreter_Execute(CXInterpreter Interp, CXPartialTranslationUnit PTU) {
  return takeErrorMessage(reinterpret_cast<clang::Interpreter *>(Interp)->Execute(
      *reinterpret_cast<clang::PartialTranslationUnit *>(PTU)));
}

CXString clang_Interpreter_ParseAndExecute(CXInterpreter Interp, const char *Code,
                                           CXValue Result) {
  return takeErrorMessage(reinterpret_cast<clang::Interpreter *>(Interp)->ParseAndExecute(
      llvm::StringRef(Code), reinterpret_cast<clang::Value *>(Result)));
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

CXString clang_Interpreter_Undo(CXInterpreter Interp, unsigned int N) {
  return takeErrorMessage(reinterpret_cast<clang::Interpreter *>(Interp)->Undo(N));
}

CXString clang_Interpreter_LoadDynamicLibrary(CXInterpreter Interp, const char *name) {
  return takeErrorMessage(
      reinterpret_cast<clang::Interpreter *>(Interp)->LoadDynamicLibrary(name));
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

LLVMOrcExecutorAddress clang_Interpreter_getSymbolAddressFromDecl(CXInterpreter Interp,
                                                                  CXNamedDecl D) {
  return symbolAddressOf(Interp,
                         clang::GlobalDecl(reinterpret_cast<clang::NamedDecl *>(D)));
}

LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromCtorDecl(CXInterpreter Interp, CXCXXConstructorDecl D,
                                               CXCXXCtorType CtorKind) {
  return symbolAddressOf(
      Interp, clang::GlobalDecl(reinterpret_cast<clang::CXXConstructorDecl *>(D),
                                static_cast<clang::CXXCtorType>(CtorKind)));
}

LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromDtorDecl(CXInterpreter Interp, CXCXXDestructorDecl D,
                                               CXCXXDtorType DtorKind) {
  return symbolAddressOf(
      Interp, clang::GlobalDecl(reinterpret_cast<clang::CXXDestructorDecl *>(D),
                                static_cast<clang::CXXDtorType>(DtorKind)));
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
  return reinterpret_cast<CXCodeGenerator>(
      reinterpret_cast<clang::Interpreter *>(Interp)->getCodeGen());
}

CXParser clang_Interpreter_getParser(CXInterpreter Interp) {
  return reinterpret_cast<CXParser>(reinterpret_cast<clang::Interpreter *>(Interp)->IncrParser->P.get());
}

CXASTContext clang_Interpreter_getASTContext(CXInterpreter Interp) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::Interpreter *>(Interp)->getASTContext());
}
