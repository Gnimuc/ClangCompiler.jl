#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOROPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Lex/PreprocessorOptions.h: enum class DisableValidationForModuleKind.
// The trailing LLVM_MARK_AS_BITMASK_ENUM(Module) is omitted: it expands to
// LLVM_BITMASK_LARGEST_ENUMERATOR = Module, a duplicate value Julia's @enum rejects.
typedef enum CXDisableValidationForModuleKind {
  CXDisableValidationForModuleKind_None = 0,
  CXDisableValidationForModuleKind_PCH = 1,
  CXDisableValidationForModuleKind_Module = 2,
  CXDisableValidationForModuleKind_All = 3
} CXDisableValidationForModuleKind;

size_t clang_PreprocessorOptions_getIncludesNum(CXPreprocessorOptions PPO);

void clang_PreprocessorOptions_getIncludes(CXPreprocessorOptions PPO, const char **IncsOut,
                                           size_t Num);

// The PCH-centric fields. `PreprocessorOptions` is a plain option bag with public data
// members and no accessors, so each pair below is named for the field it reads and writes.
// Together with `ImplicitPCHInclude` these are what a PCH-consuming CompilerInstance is
// configured through; `clang_CompilerInstance_createPCHExternalASTSource` is the other,
// instance-level entry point and does not substitute for them.

// Initialize the preprocessor with the compiler and target specific predefines.
bool clang_PreprocessorOptions_getUsePredefines(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setUsePredefines(CXPreprocessorOptions PPO, bool Value);

// Whether a detailed record of macro definitions and expansions is kept; this is what
// `clang_Preprocessor_createPreprocessingRecord` needs to have been asked for.
bool clang_PreprocessorOptions_getDetailedRecord(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setDetailedRecord(CXPreprocessorOptions PPO, bool Value);

// Creating or using a PCH where a `#pragma hdrstop` marks the PCH boundary.
bool clang_PreprocessorOptions_getPCHWithHdrStop(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setPCHWithHdrStop(CXPreprocessorOptions PPO, bool Value);

bool clang_PreprocessorOptions_getPCHWithHdrStopCreate(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setPCHWithHdrStopCreate(CXPreprocessorOptions PPO,
                                                       bool Value);

// The MSVC-style "through header": when creating a PCH, generation stops after this
// `#include`; when using one, tokens are skipped until it is seen. Empty when unset.
CXString clang_PreprocessorOptions_getPCHThroughHeader(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setPCHThroughHeader(CXPreprocessorOptions PPO,
                                                   const char *Header);

// The PCH implicitly included at the start of the translation unit; empty when there is
// none. This is the field that makes a CompilerInstance consume a PCH.
CXString clang_PreprocessorOptions_getImplicitPCHInclude(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setImplicitPCHInclude(CXPreprocessorOptions PPO,
                                                     const char *Path);

CXDisableValidationForModuleKind
clang_PreprocessorOptions_getDisablePCHOrModuleValidation(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setDisablePCHOrModuleValidation(
    CXPreprocessorOptions PPO, CXDisableValidationForModuleKind Kind);

bool clang_PreprocessorOptions_getAllowPCHWithCompilerErrors(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setAllowPCHWithCompilerErrors(CXPreprocessorOptions PPO,
                                                             bool Value);

bool
clang_PreprocessorOptions_getAllowPCHWithDifferentModulesCachePath(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setAllowPCHWithDifferentModulesCachePath(
    CXPreprocessorOptions PPO, bool Value);

// `PrecompiledPreambleBytes` is a std::pair<unsigned, bool>, marshalled as two scalars:
// how many bytes of the main file the precompiled preamble covers (zero when the implicit
// PCH is not a preamble) and whether the preamble ends at the start of a new line.
unsigned clang_PreprocessorOptions_getPrecompiledPreambleSize(CXPreprocessorOptions PPO);
bool clang_PreprocessorOptions_getPrecompiledPreambleEndsAtStartOfLine(
    CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setPrecompiledPreambleBytes(CXPreprocessorOptions PPO,
                                                           unsigned Size,
                                                           bool EndsAtStartOfLine);

// True while a preamble is being generated: the lexer then preserves the open `#if` stack
// so the ASTWriter/ASTReader can save and restore it.
bool clang_PreprocessorOptions_getGeneratePreamble(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setGeneratePreamble(CXPreprocessorOptions PPO, bool Value);

// Parse a single file only: `#include`s of other files are disabled and unresolved
// identifiers in directive conditions cause every block to be parsed.
bool clang_PreprocessorOptions_getSingleFileParseMode(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setSingleFileParseMode(CXPreprocessorOptions PPO,
                                                      bool Value);

// File remappings: give an existing path the contents of another path, or of a memory
// buffer. The buffer is BORROWED — it must outlive the compiler instance, and
// `RetainRemappedFileBuffers` decides whether that instance frees it.
void clang_PreprocessorOptions_addRemappedFile(CXPreprocessorOptions PPO, const char *From,
                                               const char *To);
void clang_PreprocessorOptions_addRemappedFileBuffer(CXPreprocessorOptions PPO,
                                                     const char *From,
                                                     LLVMMemoryBufferRef To);

size_t clang_PreprocessorOptions_getNumRemappedFiles(CXPreprocessorOptions PPO);
CXString clang_PreprocessorOptions_getRemappedFileFrom(CXPreprocessorOptions PPO, size_t I);
CXString clang_PreprocessorOptions_getRemappedFileTo(CXPreprocessorOptions PPO, size_t I);

size_t clang_PreprocessorOptions_getNumRemappedFileBuffers(CXPreprocessorOptions PPO);
CXString clang_PreprocessorOptions_getRemappedFileBufferFrom(CXPreprocessorOptions PPO,
                                                             size_t I);

void clang_PreprocessorOptions_clearRemappedFiles(CXPreprocessorOptions PPO);

bool clang_PreprocessorOptions_getRetainRemappedFileBuffers(CXPreprocessorOptions PPO);
void clang_PreprocessorOptions_setRetainRemappedFileBuffers(CXPreprocessorOptions PPO,
                                                            bool Value);

void clang_PreprocessorOptions_PrintStats(CXPreprocessorOptions PPO);

LLVM_CLANG_C_EXTERN_C_END

#endif