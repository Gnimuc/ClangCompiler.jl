#include "clang-ex/Frontend/CXFrontendOptions.h"
#include "utils.h"
#include "clang/Frontend/FrontendOptions.h"
#include "llvm/Support/Errc.h"

// Flags
bool clang_FrontendOptions_getDisableFree(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->DisableFree;
}

void clang_FrontendOptions_setDisableFree(CXFrontendOptions FEO, bool Value) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->DisableFree = Value;
}

bool clang_FrontendOptions_getSkipFunctionBodies(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->SkipFunctionBodies;
}

void clang_FrontendOptions_setSkipFunctionBodies(CXFrontendOptions FEO, bool Value) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->SkipFunctionBodies = Value;
}

// DashX
CXLanguage clang_FrontendOptions_getDashXLanguage(CXFrontendOptions FEO) {
  return static_cast<CXLanguage>(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX.getLanguage());
}

CXInputKind_Format clang_FrontendOptions_getDashXFormat(CXFrontendOptions FEO) {
  return static_cast<CXInputKind_Format>(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX.getFormat());
}

CXInputKind_HeaderUnitKind
clang_FrontendOptions_getDashXHeaderUnitKind(CXFrontendOptions FEO) {
  return static_cast<CXInputKind_HeaderUnitKind>(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX.getHeaderUnitKind());
}

bool clang_FrontendOptions_isDashXPreprocessed(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX.isPreprocessed();
}

bool clang_FrontendOptions_isDashXHeader(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX.isHeader();
}

void clang_FrontendOptions_setDashX(CXFrontendOptions FEO, CXLanguage Lang,
                                    CXInputKind_Format Fmt, bool IsPreprocessed,
                                    CXInputKind_HeaderUnitKind HU, bool IsHeader) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->DashX = clang::InputKind(
      static_cast<clang::Language>(Lang), static_cast<clang::InputKind::Format>(Fmt),
      IsPreprocessed, static_cast<clang::InputKind::HeaderUnitKind>(HU), IsHeader);
}

// Inputs
unsigned clang_FrontendOptions_getInputsNum(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs.size();
}

bool clang_FrontendOptions_isInputFile(CXFrontendOptions FEO, unsigned Idx) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs[Idx].isFile();
}

bool clang_FrontendOptions_isInputSystem(CXFrontendOptions FEO, unsigned Idx) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs[Idx].isSystem();
}

CXLanguage clang_FrontendOptions_getInputLanguage(CXFrontendOptions FEO, unsigned Idx) {
  return static_cast<CXLanguage>(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs[Idx].getKind().getLanguage());
}

CXString clang_FrontendOptions_getInputFile(CXFrontendOptions FEO, unsigned Idx) {
  return extra::makeCXString(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs[Idx].getFile().str());
}

void clang_FrontendOptions_addInputFile(CXFrontendOptions FEO, const char *File,
                                        CXLanguage Lang, CXInputKind_Format Fmt,
                                        bool IsPreprocessed, bool IsSystem) {
  clang::InputKind Kind(static_cast<clang::Language>(Lang),
                        static_cast<clang::InputKind::Format>(Fmt), IsPreprocessed);
  reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs.emplace_back(
      llvm::StringRef(File), Kind, IsSystem);
}

void clang_FrontendOptions_clearInputs(CXFrontendOptions FEO) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->Inputs.clear();
}

// OutputFile
CXString clang_FrontendOptions_getOutputFile(CXFrontendOptions FEO) {
  return extra::makeCXString(reinterpret_cast<clang::FrontendOptions *>(FEO)->OutputFile);
}

void clang_FrontendOptions_setOutputFile(CXFrontendOptions FEO, const char *Path) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->OutputFile = Path;
}

// ProgramAction
CXActionKind clang_FrontendOptions_getProgramAction(CXFrontendOptions FEO) {
  return static_cast<CXActionKind>(
      reinterpret_cast<clang::FrontendOptions *>(FEO)->ProgramAction);
}

void clang_FrontendOptions_setProgramAction(CXFrontendOptions FEO, CXActionKind Kind) {
  reinterpret_cast<clang::FrontendOptions *>(FEO)->ProgramAction =
      static_cast<clang::frontend::ActionKind>(Kind);
}

unsigned clang_FrontendOptions_getModulesEmbedFilesNum(CXFrontendOptions FEO) {
  return reinterpret_cast<clang::FrontendOptions *>(FEO)->ModulesEmbedFiles.size();
}

void clang_FrontendOptions_getModulesEmbedFiles(CXFrontendOptions FEO, const char **Buf,
                                                unsigned N) {
  const auto &Files = reinterpret_cast<clang::FrontendOptions *>(FEO)->ModulesEmbedFiles;
  for (unsigned I = 0; I < N && I < Files.size(); ++I)
    Buf[I] = Files[I].c_str();
}

void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO) {
  auto Opts = reinterpret_cast<clang::FrontendOptions *>(FEO);
  llvm::errs() << "\n*** FrontendOptions Stats:\n";
  llvm::errs() << "  Inputs: \n";
  for (const auto &IF : Opts->Inputs)
    llvm::errs() << "    " << IF.getFile() << "  (IsSystem:" << IF.isSystem()
                 << "; IsBuffer:" << IF.isBuffer() << "; IsEmpty:" << IF.isEmpty()
                 << "; IsPreprocessed:" << IF.isPreprocessed() << ")\n";

  llvm::errs() << "  OutputFile: " << Opts->OutputFile << "\n";

  llvm::errs() << "  ModuleMapFiles: \n";
  for (const auto &MF : Opts->ModuleMapFiles)
    llvm::errs() << "    " << MF << "\n";

  llvm::errs() << "  ModuleFiles: \n";
  for (const auto &MF : Opts->ModuleFiles)
    llvm::errs() << "    " << MF << "\n";

  llvm::errs() << "  ModulesEmbedFiles: \n";
  for (const auto &MF : Opts->ModulesEmbedFiles)
    llvm::errs() << "    " << MF << "\n";

  llvm::errs() << "  LLVMArgs: \n";
  for (const auto &Arg : Opts->LLVMArgs)
    llvm::errs() << "    " << Arg << "\n";

  llvm::errs() << "  AuxTriple: " << Opts->AuxTriple << "\n";
  llvm::errs() << "  StatsFile: " << Opts->StatsFile << "\n";

  llvm::errs() << "  Options: \n";
  llvm::errs() << "    ShowHelp: " << Opts->ShowHelp << "\n";
  llvm::errs() << "    ShowStats: " << Opts->ShowStats << "\n";
  llvm::errs() << "    PrintSupportedCPUs: " << Opts->PrintSupportedCPUs << "\n";
  llvm::errs() << "    ShowVersion: " << Opts->ShowVersion << "\n";
  llvm::errs() << "    SkipFunctionBodies: " << Opts->SkipFunctionBodies << "\n";
  llvm::errs() << "    ASTDumpDecls: " << Opts->ASTDumpDecls << "\n";
  llvm::errs() << "    ASTDumpAll: " << Opts->ASTDumpAll << "\n";
  llvm::errs() << "    ASTDumpLookups: " << Opts->ASTDumpLookups << "\n";
  llvm::errs() << "    ASTDumpDeclTypes: " << Opts->ASTDumpDeclTypes << "\n";
  llvm::errs() << "    ModulesEmbedAllFiles: " << Opts->ModulesEmbedAllFiles << "\n";
  llvm::errs() << "    UseTemporary: " << Opts->UseTemporary << "\n";
  llvm::errs() << "    IsSystemModule: " << Opts->IsSystemModule << "\n";
}