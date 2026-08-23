#include "clang-ex/CodeGen/CXBackendUtil.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/CodeGen/BackendUtil.h"
#include "clang/Frontend/CompilerInstance.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <system_error>

bool clang_EmitBackendOutput(CXCompilerInstance CI, LLVMModuleRef M, CXBackendAction Action,
                             const char *OutputPath) {
  auto *Compiler = reinterpret_cast<clang::CompilerInstance *>(CI);
  if (!Compiler->hasFileManager()) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_EmitBackendOutput: the CompilerInstance has no "
                    "FileManager, so it has no virtual file system to give the backend\n";
    return false;
  }
  if (!Compiler->hasTarget()) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_EmitBackendOutput: the CompilerInstance has no "
                    "target, so there is no data layout to compile against\n";
    return false;
  }

  auto BA = static_cast<clang::BackendAction>(Action);
  if (!OutputPath && BA != clang::Backend_EmitNothing) {
    llvm::errs() << "LIBCLANGEX ERROR: clang_EmitBackendOutput: this action writes output, "
                    "so it needs an output path\n";
    return false;
  }

  std::unique_ptr<llvm::raw_pwrite_stream> OS;
  if (OutputPath) {
    bool IsText = BA == clang::Backend_EmitAssembly || BA == clang::Backend_EmitLL;
    std::error_code EC;
    auto FileOS = std::make_unique<llvm::raw_fd_ostream>(
        OutputPath, EC,
        IsText ? llvm::sys::fs::OF_TextWithCRLF : llvm::sys::fs::OF_None);
    if (EC) {
      llvm::errs() << "LIBCLANGEX ERROR: clang_EmitBackendOutput: cannot open " << OutputPath
                   << ": " << EC.message() << "\n";
      return false;
    }
    OS = std::move(FileOS);
  }

  auto &Diags = Compiler->getDiagnostics();
  unsigned ErrorsBefore = Diags.getNumErrors();
  clang::emitBackendOutput(*Compiler, Compiler->getCodeGenOpts(),
                           Compiler->getTarget().getDataLayoutString(), llvm::unwrap(M), BA,
                           Compiler->getFileManager().getVirtualFileSystemPtr(),
                           std::move(OS));
  return Diags.getNumErrors() == ErrorsBefore;
}
