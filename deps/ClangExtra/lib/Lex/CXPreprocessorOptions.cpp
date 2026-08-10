#include "clang-ex/Lex/CXPreprocessorOptions.h"
#include "utils.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"

namespace {

clang::PreprocessorOptions *opts(CXPreprocessorOptions PPO) {
  return reinterpret_cast<clang::PreprocessorOptions *>(PPO);
}

} // namespace

size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO) {
  return reinterpret_cast<clang::PreprocessorOptions *>(PPO)->Includes.size();
}

void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO, const char **IncsOut,
                                           size_t Num) {
  auto &Incs = reinterpret_cast<clang::PreprocessorOptions *>(PPO)->Includes;
  for (auto &Inc : Incs) {
    auto i = &Inc - &Incs[0];
    if (i < Num)
      IncsOut[i] = Inc.c_str();
  }
}

bool clang_PreprocessorOptions_getUsePredefines(CXPreprocessorOptions PPO) {
  return opts(PPO)->UsePredefines;
}

void clang_PreprocessorOptions_setUsePredefines(CXPreprocessorOptions PPO, bool Value) {
  opts(PPO)->UsePredefines = Value;
}

bool clang_PreprocessorOptions_getDetailedRecord(CXPreprocessorOptions PPO) {
  return opts(PPO)->DetailedRecord;
}

void clang_PreprocessorOptions_setDetailedRecord(CXPreprocessorOptions PPO, bool Value) {
  opts(PPO)->DetailedRecord = Value;
}

bool clang_PreprocessorOptions_getPCHWithHdrStop(CXPreprocessorOptions PPO) {
  return opts(PPO)->PCHWithHdrStop;
}

void clang_PreprocessorOptions_setPCHWithHdrStop(CXPreprocessorOptions PPO, bool Value) {
  opts(PPO)->PCHWithHdrStop = Value;
}

bool clang_PreprocessorOptions_getPCHWithHdrStopCreate(CXPreprocessorOptions PPO) {
  return opts(PPO)->PCHWithHdrStopCreate;
}

void clang_PreprocessorOptions_setPCHWithHdrStopCreate(CXPreprocessorOptions PPO,
                                                       bool Value) {
  opts(PPO)->PCHWithHdrStopCreate = Value;
}

CXString clang_PreprocessorOptions_getPCHThroughHeader(CXPreprocessorOptions PPO) {
  return extra::makeCXString(opts(PPO)->PCHThroughHeader);
}

void clang_PreprocessorOptions_setPCHThroughHeader(CXPreprocessorOptions PPO,
                                                   const char *Header) {
  opts(PPO)->PCHThroughHeader = Header ? std::string(Header) : std::string();
}

CXString clang_PreprocessorOptions_getImplicitPCHInclude(CXPreprocessorOptions PPO) {
  return extra::makeCXString(opts(PPO)->ImplicitPCHInclude);
}

void clang_PreprocessorOptions_setImplicitPCHInclude(CXPreprocessorOptions PPO,
                                                     const char *Path) {
  opts(PPO)->ImplicitPCHInclude = Path ? std::string(Path) : std::string();
}

CXDisableValidationForModuleKind
clang_PreprocessorOptions_getDisablePCHOrModuleValidation(CXPreprocessorOptions PPO) {
  return static_cast<CXDisableValidationForModuleKind>(
      opts(PPO)->DisablePCHOrModuleValidation);
}

void clang_PreprocessorOptions_setDisablePCHOrModuleValidation(
    CXPreprocessorOptions PPO, CXDisableValidationForModuleKind Kind) {
  opts(PPO)->DisablePCHOrModuleValidation =
      static_cast<clang::DisableValidationForModuleKind>(Kind);
}

bool clang_PreprocessorOptions_getAllowPCHWithCompilerErrors(CXPreprocessorOptions PPO) {
  return opts(PPO)->AllowPCHWithCompilerErrors;
}

void clang_PreprocessorOptions_setAllowPCHWithCompilerErrors(CXPreprocessorOptions PPO,
                                                             bool Value) {
  opts(PPO)->AllowPCHWithCompilerErrors = Value;
}

bool clang_PreprocessorOptions_getAllowPCHWithDifferentModulesCachePath(
    CXPreprocessorOptions PPO) {
  return opts(PPO)->AllowPCHWithDifferentModulesCachePath;
}

void clang_PreprocessorOptions_setAllowPCHWithDifferentModulesCachePath(
    CXPreprocessorOptions PPO, bool Value) {
  opts(PPO)->AllowPCHWithDifferentModulesCachePath = Value;
}

unsigned clang_PreprocessorOptions_getPrecompiledPreambleSize(CXPreprocessorOptions PPO) {
  return opts(PPO)->PrecompiledPreambleBytes.first;
}

bool clang_PreprocessorOptions_getPrecompiledPreambleEndsAtStartOfLine(
    CXPreprocessorOptions PPO) {
  return opts(PPO)->PrecompiledPreambleBytes.second;
}

void clang_PreprocessorOptions_setPrecompiledPreambleBytes(CXPreprocessorOptions PPO,
                                                           unsigned Size,
                                                           bool EndsAtStartOfLine) {
  opts(PPO)->PrecompiledPreambleBytes.first = Size;
  opts(PPO)->PrecompiledPreambleBytes.second = EndsAtStartOfLine;
}

bool clang_PreprocessorOptions_getGeneratePreamble(CXPreprocessorOptions PPO) {
  return opts(PPO)->GeneratePreamble;
}

void clang_PreprocessorOptions_setGeneratePreamble(CXPreprocessorOptions PPO, bool Value) {
  opts(PPO)->GeneratePreamble = Value;
}

bool clang_PreprocessorOptions_getSingleFileParseMode(CXPreprocessorOptions PPO) {
  return opts(PPO)->SingleFileParseMode;
}

void clang_PreprocessorOptions_setSingleFileParseMode(CXPreprocessorOptions PPO,
                                                      bool Value) {
  opts(PPO)->SingleFileParseMode = Value;
}

void clang_PreprocessorOptions_addRemappedFile(CXPreprocessorOptions PPO, const char *From,
                                               const char *To) {
  opts(PPO)->addRemappedFile(llvm::StringRef(From), llvm::StringRef(To));
}

void clang_PreprocessorOptions_addRemappedFileBuffer(CXPreprocessorOptions PPO,
                                                     const char *From,
                                                     LLVMMemoryBufferRef To) {
  opts(PPO)->addRemappedFile(llvm::StringRef(From), llvm::unwrap(To));
}

size_t clang_PreprocessorOptions_getNumRemappedFiles(CXPreprocessorOptions PPO) {
  return opts(PPO)->RemappedFiles.size();
}

CXString clang_PreprocessorOptions_getRemappedFileFrom(CXPreprocessorOptions PPO,
                                                       size_t I) {
  return extra::makeCXString(opts(PPO)->RemappedFiles[I].first);
}

CXString clang_PreprocessorOptions_getRemappedFileTo(CXPreprocessorOptions PPO, size_t I) {
  return extra::makeCXString(opts(PPO)->RemappedFiles[I].second);
}

size_t clang_PreprocessorOptions_getNumRemappedFileBuffers(CXPreprocessorOptions PPO) {
  return opts(PPO)->RemappedFileBuffers.size();
}

CXString clang_PreprocessorOptions_getRemappedFileBufferFrom(CXPreprocessorOptions PPO,
                                                             size_t I) {
  return extra::makeCXString(opts(PPO)->RemappedFileBuffers[I].first);
}

void clang_PreprocessorOptions_clearRemappedFiles(CXPreprocessorOptions PPO) {
  opts(PPO)->clearRemappedFiles();
}

bool clang_PreprocessorOptions_getRetainRemappedFileBuffers(CXPreprocessorOptions PPO) {
  return opts(PPO)->RetainRemappedFileBuffers;
}

void clang_PreprocessorOptions_setRetainRemappedFileBuffers(CXPreprocessorOptions PPO,
                                                            bool Value) {
  opts(PPO)->RetainRemappedFileBuffers = Value;
}

void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO) {
  auto Opts = reinterpret_cast<clang::PreprocessorOptions *>(PPO);
  llvm::errs() << "\n*** PreprocessorOptions Stats:\n";
  llvm::errs() << "  Macros: \n";
  for (const auto &M : Opts->Macros)
    llvm::errs() << "    " << M.first << "  (isUndef:" << M.second << ")\n";

  llvm::errs() << "  Includes: \n";
  for (const auto &Inc : Opts->Includes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  MacroIncludes: \n";
  for (const auto &Inc : Opts->MacroIncludes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  ImplicitPCHInclude: " << Opts->ImplicitPCHInclude << "\n";

  llvm::errs() << "  ChainedIncludes: \n";
  for (const auto &Inc : Opts->ChainedIncludes)
    llvm::errs() << "    " << Inc << "\n";

  llvm::errs() << "  Options: \n";
  llvm::errs() << "    UsePredefines: " << Opts->UsePredefines << "\n";
  llvm::errs() << "    DetailedRecord: " << Opts->DetailedRecord << "\n";
  llvm::errs() << "    SingleFileParseMode: " << Opts->SingleFileParseMode << "\n";

  llvm::errs() << "  RemappedFiles: \n";
  for (const auto &RF : Opts->RemappedFiles)
    llvm::errs() << "    " << RF.first << "  ->  " << RF.second << "\n";
}