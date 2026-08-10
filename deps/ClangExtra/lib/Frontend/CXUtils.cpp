#include "clang-ex/Frontend/CXUtils.h"
#include "utils.h"
#include <vector>
#include "clang/Basic/Diagnostic.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/DependencyOutputOptions.h"
#include "clang/Frontend/Utils.h"
#include "clang/Lex/Preprocessor.h"

#include <memory>

// DependencyCollector
CXDependencyCollector clang_DependencyCollector_create(void) {
  auto DC = std::make_unique<clang::DependencyCollector>();
  return reinterpret_cast<CXDependencyCollector>(DC.release());
}

void clang_DependencyCollector_dispose(CXDependencyCollector DC) {
  delete reinterpret_cast<clang::DependencyCollector *>(DC);
}

void clang_DependencyCollector_attachToPreprocessor(CXDependencyCollector DC,
                                                    CXPreprocessor PP) {
  reinterpret_cast<clang::DependencyCollector *>(DC)->attachToPreprocessor(
      *reinterpret_cast<clang::Preprocessor *>(PP));
}

unsigned clang_DependencyCollector_getDependenciesNum(CXDependencyCollector DC) {
  return reinterpret_cast<clang::DependencyCollector *>(DC)->getDependencies().size();
}

CXString clang_DependencyCollector_getDependency(CXDependencyCollector DC, unsigned Idx) {
  return extra::makeCXString(
      reinterpret_cast<clang::DependencyCollector *>(DC)->getDependencies()[Idx]);
}

bool clang_DependencyCollector_needSystemDependencies(CXDependencyCollector DC) {
  return reinterpret_cast<clang::DependencyCollector *>(DC)->needSystemDependencies();
}

void clang_DependencyCollector_maybeAddDependency(CXDependencyCollector DC,
                                                  const char *Filename, bool FromModule,
                                                  bool IsSystem, bool IsModuleFile,
                                                  bool IsMissing) {
  reinterpret_cast<clang::DependencyCollector *>(DC)->maybeAddDependency(
      llvm::StringRef(Filename), FromModule, IsSystem, IsModuleFile, IsMissing);
}

// DependencyFileGenerator
CXDependencyCollector
clang_DependencyFileGenerator_create(CXDependencyOutputOptions Opts) {
  std::unique_ptr<clang::DependencyCollector> DC =
      std::make_unique<clang::DependencyFileGenerator>(
          *reinterpret_cast<clang::DependencyOutputOptions *>(Opts));
  return reinterpret_cast<CXDependencyCollector>(DC.release());
}

void clang_DependencyFileGenerator_finishedMainFile(CXDependencyCollector DC,
                                                    CXDiagnosticsEngine Diags) {
  reinterpret_cast<clang::DependencyCollector *>(DC)->finishedMainFile(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

// createInvocation
CXCompilerInvocation clang_createInvocation(const char **Args, int NumArgs,
                                            CXDiagnosticsEngine Diags, bool RecoverOnError,
                                            bool ProbePrecompiled,
                                            CXStringSet **OutCC1Args) {
  clang::CreateInvocationOptions Opts;
  if (Diags) {
    // The IntrusiveRefCntPtr inside CreateInvocationOptions borrows the engine for the
    // length of this call. It arrives already holding the caller's reference, so the borrow
    // runs 1 -> 2 -> 1 and cannot free it.
    auto *DE = reinterpret_cast<clang::DiagnosticsEngine *>(Diags);
    Opts.Diags = llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE);
  }
  Opts.RecoverOnError = RecoverOnError;
  Opts.ProbePrecompiled = ProbePrecompiled;
  std::vector<std::string> CC1Args;
  if (OutCC1Args)
    Opts.CC1Args = &CC1Args;
  auto Invoc = clang::createInvocation(llvm::ArrayRef(Args, NumArgs), std::move(Opts));
  if (OutCC1Args)
    *OutCC1Args = extra::makeCXStringSet(CC1Args);
  return reinterpret_cast<CXCompilerInvocation>(Invoc.release());
}
