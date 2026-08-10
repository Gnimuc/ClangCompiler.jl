#include "clang-ex/Tooling/CXTooling.h"

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Basic/FileManager.h"
#include "clang/Frontend/ASTUnit.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Frontend/PCHContainerOperations.h"
#include "clang/Tooling/ArgumentsAdjusters.h"
#include "clang/Tooling/CompilationDatabase.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"

#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace {

clang::tooling::ClangTool *unwrapTool(CXClangTool CT) {
  return reinterpret_cast<clang::tooling::ClangTool *>(CT);
}

clang::tooling::ToolInvocation *unwrapInvocation(CXToolInvocation TI) {
  return reinterpret_cast<clang::tooling::ToolInvocation *>(TI);
}

std::vector<std::string> toStrings(const char **Strs, unsigned N) {
  std::vector<std::string> Out;
  Out.reserve(N);
  for (unsigned I = 0; I < N; ++I)
    Out.emplace_back(Strs && Strs[I] ? Strs[I] : "");
  return Out;
}

clang::tooling::FileContentMappings toMappings(const char **Names,
                                               const char **Contents, unsigned N) {
  clang::tooling::FileContentMappings Out;
  Out.reserve(N);
  for (unsigned I = 0; I < N; ++I)
    Out.emplace_back(Names && Names[I] ? Names[I] : "",
                     Contents && Contents[I] ? Contents[I] : "");
  return Out;
}

const char *orDefault(const char *S, const char *Fallback) {
  return S && *S ? S : Fallback;
}

} // namespace

bool clang_tooling_runToolOnCodeWithArgs(CXFrontendAction ToolAction, const char *Code,
                                         const char **Args, unsigned NumArgs,
                                         const char *FileName, const char *ToolName,
                                         const char **VirtualFileNames,
                                         const char **VirtualFileContents,
                                         unsigned NumVirtualFiles) {
  std::unique_ptr<clang::FrontendAction> Action(
      reinterpret_cast<clang::FrontendAction *>(ToolAction));
  return clang::tooling::runToolOnCodeWithArgs(
      std::move(Action), llvm::Twine(Code ? Code : ""), toStrings(Args, NumArgs),
      llvm::Twine(orDefault(FileName, "input.cc")),
      llvm::Twine(orDefault(ToolName, "clang-tool")),
      std::make_shared<clang::PCHContainerOperations>(),
      toMappings(VirtualFileNames, VirtualFileContents, NumVirtualFiles));
}

CXASTUnit clang_tooling_buildASTFromCode(const char *Code, const char *FileName) {
  auto AU = clang::tooling::buildASTFromCode(Code ? Code : "",
                                             orDefault(FileName, "input.cc"),
                                             std::make_shared<clang::PCHContainerOperations>());
  return reinterpret_cast<CXASTUnit>(AU.release());
}

CXASTUnit clang_tooling_buildASTFromCodeWithArgs(
    const char *Code, const char **Args, unsigned NumArgs, const char *FileName,
    const char *ToolName, CXArgumentsAdjuster Adjuster, const char **VirtualFileNames,
    const char **VirtualFileContents, unsigned NumVirtualFiles,
    CXDiagnosticConsumer DiagConsumer) {
  clang::tooling::ArgumentsAdjuster Adj =
      Adjuster ? *reinterpret_cast<clang::tooling::ArgumentsAdjuster *>(Adjuster)
               : clang::tooling::getClangStripDependencyFileAdjuster();
  auto AU = clang::tooling::buildASTFromCodeWithArgs(
      Code ? Code : "", toStrings(Args, NumArgs), orDefault(FileName, "input.cc"),
      orDefault(ToolName, "clang-tool"), std::make_shared<clang::PCHContainerOperations>(),
      std::move(Adj), toMappings(VirtualFileNames, VirtualFileContents, NumVirtualFiles),
      reinterpret_cast<clang::DiagnosticConsumer *>(DiagConsumer));
  return reinterpret_cast<CXASTUnit>(AU.release());
}

// ToolInvocation

CXToolInvocation clang_ToolInvocation_create(const char **CommandLine, unsigned N,
                                             CXFrontendAction Action, CXFileManager Files) {
  std::unique_ptr<clang::FrontendAction> FA(
      reinterpret_cast<clang::FrontendAction *>(Action));
  return reinterpret_cast<CXToolInvocation>(
      std::make_unique<clang::tooling::ToolInvocation>(
          toStrings(CommandLine, N), std::move(FA),
          reinterpret_cast<clang::FileManager *>(Files),
          std::make_shared<clang::PCHContainerOperations>())
          .release());
}

void clang_ToolInvocation_dispose(CXToolInvocation TI) { delete unwrapInvocation(TI); }

void clang_ToolInvocation_setDiagnosticConsumer(CXToolInvocation TI,
                                                CXDiagnosticConsumer DiagConsumer) {
  unwrapInvocation(TI)->setDiagnosticConsumer(
      reinterpret_cast<clang::DiagnosticConsumer *>(DiagConsumer));
}

void clang_ToolInvocation_setDiagnosticOptions(CXToolInvocation TI,
                                               CXDiagnosticOptions DiagOpts) {
  // The invocation stores only the raw pointer, but run() lends the options to a stack
  // TextDiagnosticPrinter and a stack DiagnosticsEngine, each holding an IntrusiveRefCntPtr
  // for the length of that run. No pin is needed: clang_DiagnosticOptions_create hands the
  // object back already holding the caller's own reference, so those borrows run
  // 1 -> 2 -> 1 and the caller's dispose remains the reference that frees.
  unwrapInvocation(TI)->setDiagnosticOptions(
      reinterpret_cast<clang::DiagnosticOptions *>(DiagOpts));
}

bool clang_ToolInvocation_run(CXToolInvocation TI) { return unwrapInvocation(TI)->run(); }

// ClangTool

CXClangTool clang_ClangTool_create(CXCompilationDatabase Compilations,
                                   const char **SourcePaths, unsigned N) {
  std::vector<std::string> Paths = toStrings(SourcePaths, N);
  return reinterpret_cast<CXClangTool>(
      std::make_unique<clang::tooling::ClangTool>(
          *reinterpret_cast<clang::tooling::CompilationDatabase *>(Compilations),
          llvm::ArrayRef<std::string>(Paths))
          .release());
}

void clang_ClangTool_dispose(CXClangTool CT) { delete unwrapTool(CT); }

void clang_ClangTool_mapVirtualFile(CXClangTool CT, const char *FilePath,
                                    const char *Content) {
  unwrapTool(CT)->mapVirtualFile(FilePath ? FilePath : "", Content ? Content : "");
}

void clang_ClangTool_appendArgumentsAdjuster(CXClangTool CT, CXArgumentsAdjuster Adjuster) {
  unwrapTool(CT)->appendArgumentsAdjuster(
      *reinterpret_cast<clang::tooling::ArgumentsAdjuster *>(Adjuster));
}

void clang_ClangTool_clearArgumentsAdjusters(CXClangTool CT) {
  unwrapTool(CT)->clearArgumentsAdjusters();
}

void clang_ClangTool_setDiagnosticConsumer(CXClangTool CT,
                                           CXDiagnosticConsumer DiagConsumer) {
  unwrapTool(CT)->setDiagnosticConsumer(
      reinterpret_cast<clang::DiagnosticConsumer *>(DiagConsumer));
}

void clang_ClangTool_setPrintErrorMessage(CXClangTool CT, bool PrintErrorMessage) {
  unwrapTool(CT)->setPrintErrorMessage(PrintErrorMessage);
}

CXFileManager clang_ClangTool_getFiles(CXClangTool CT) {
  return reinterpret_cast<CXFileManager>(&unwrapTool(CT)->getFiles());
}

unsigned clang_ClangTool_getNumSourcePaths(CXClangTool CT) {
  return static_cast<unsigned>(unwrapTool(CT)->getSourcePaths().size());
}

const char *clang_ClangTool_getSourcePath(CXClangTool CT, unsigned Index) {
  return unwrapTool(CT)->getSourcePaths()[Index].c_str();
}

int clang_ClangTool_buildASTs(CXClangTool CT, CXASTUnit *ASTs, unsigned MaxASTs,
                              unsigned *NumASTs) {
  std::vector<std::unique_ptr<clang::ASTUnit>> Units;
  int Status = unwrapTool(CT)->buildASTs(Units);
  unsigned Built = static_cast<unsigned>(Units.size());
  if (NumASTs)
    *NumASTs = Built;
  if (ASTs) {
    unsigned Written = Built < MaxASTs ? Built : MaxASTs;
    for (unsigned I = 0; I < Written; ++I)
      ASTs[I] = reinterpret_cast<CXASTUnit>(Units[I].release());
  }
  return Status;
}
