#include "clang-ex/Frontend/CXFrontendOptions.h"
#include "clang/Frontend/FrontendOptions.h"
#include "llvm/Support/Errc.h"

void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO) {
  auto Opts = static_cast<clang::FrontendOptions *>(FEO);
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