#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXLangStandard.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Frontend/FrontendOptions.h: enum clang::frontend::ActionKind. This is the field
// clang_ExecuteCompilerInvocation and clang_CreateFrontendAction switch on, so it is the
// one knob that turns a configured CompilerInstance into a particular cc1 run.
typedef enum CXActionKind {
  CXActionKind_ASTDeclList,
  CXActionKind_ASTDump,
  CXActionKind_ASTPrint,
  CXActionKind_ASTView,
  CXActionKind_DumpCompilerOptions,
  CXActionKind_DumpRawTokens,
  CXActionKind_DumpTokens,
  CXActionKind_EmitAssembly,
  CXActionKind_EmitBC,
  CXActionKind_EmitHTML,
  CXActionKind_EmitLLVM,
  CXActionKind_EmitLLVMOnly,
  CXActionKind_EmitCodeGenOnly,
  CXActionKind_EmitObj,
  CXActionKind_ExtractAPI,
  CXActionKind_FixIt,
  CXActionKind_GenerateModule,
  CXActionKind_GenerateModuleInterface,
  CXActionKind_GenerateHeaderUnit,
  CXActionKind_GeneratePCH,
  CXActionKind_GenerateInterfaceStubs,
  CXActionKind_InitOnly,
  CXActionKind_ModuleFileInfo,
  CXActionKind_VerifyPCH,
  CXActionKind_ParseSyntaxOnly,
  CXActionKind_PluginAction,
  CXActionKind_PrintPreamble,
  CXActionKind_PrintPreprocessedInput,
  CXActionKind_RewriteMacros,
  CXActionKind_RewriteObjC,
  CXActionKind_RewriteTest,
  CXActionKind_RunAnalysis,
  CXActionKind_TemplightDump,
  CXActionKind_MigrateSource,
  CXActionKind_RunPreprocessorOnly,
  CXActionKind_PrintDependencyDirectivesSourceMinimizerOutput
} CXActionKind;

// clang/Frontend/FrontendOptions.h: enum clang::InputKind::Format
typedef enum CXInputKind_Format {
  CXInputKind_Source,
  CXInputKind_ModuleMap,
  CXInputKind_Precompiled
} CXInputKind_Format;

// clang/Frontend/FrontendOptions.h: enum clang::InputKind::HeaderUnitKind
typedef enum CXInputKind_HeaderUnitKind {
  CXInputKind_HeaderUnit_None,
  CXInputKind_HeaderUnit_User,
  CXInputKind_HeaderUnit_System,
  CXInputKind_HeaderUnit_Abs
} CXInputKind_HeaderUnitKind;

// Flags
// Suppresses the frontend's teardown of its own allocations, the way `-disable-free` does.
bool clang_FrontendOptions_getDisableFree(CXFrontendOptions FEO);
void clang_FrontendOptions_setDisableFree(CXFrontendOptions FEO, bool Value);

// Parses function bodies lazily: declarations, types and lookup still work, the bodies are
// not built. The classic fast-parse knob for a declaration-lookup pass.
bool clang_FrontendOptions_getSkipFunctionBodies(CXFrontendOptions FEO);
void clang_FrontendOptions_setSkipFunctionBodies(CXFrontendOptions FEO, bool Value);

// DashX
// The `-x` input kind: what the frontend assumes about an input whose name does not say.
CXLanguage clang_FrontendOptions_getDashXLanguage(CXFrontendOptions FEO);
CXInputKind_Format clang_FrontendOptions_getDashXFormat(CXFrontendOptions FEO);
CXInputKind_HeaderUnitKind
clang_FrontendOptions_getDashXHeaderUnitKind(CXFrontendOptions FEO);
bool clang_FrontendOptions_isDashXPreprocessed(CXFrontendOptions FEO);
bool clang_FrontendOptions_isDashXHeader(CXFrontendOptions FEO);

// helper — clang::InputKind has no setters; it is rebuilt from its five components, which
// is what this does before assigning it to DashX.
void clang_FrontendOptions_setDashX(CXFrontendOptions FEO, CXLanguage Lang,
                                    CXInputKind_Format Fmt, bool IsPreprocessed,
                                    CXInputKind_HeaderUnitKind HU, bool IsHeader);

// Inputs
unsigned clang_FrontendOptions_getInputsNum(CXFrontendOptions FEO);

// PRECONDITION for all four: Idx < clang_FrontendOptions_getInputsNum.
bool clang_FrontendOptions_isInputFile(CXFrontendOptions FEO, unsigned Idx);
bool clang_FrontendOptions_isInputSystem(CXFrontendOptions FEO, unsigned Idx);
CXLanguage clang_FrontendOptions_getInputLanguage(CXFrontendOptions FEO, unsigned Idx);

// PRECONDITION additionally: the input must be a file, not a buffer
// (clang_FrontendOptions_isInputFile) — FrontendInputFile::getFile asserts on it. Caller
// frees the string with clang_disposeString.
CXString clang_FrontendOptions_getInputFile(CXFrontendOptions FEO, unsigned Idx);

// helper — appends one file-backed FrontendInputFile. clang::FrontendOptions exposes
// `Inputs` as a plain vector with no member function to grow it, and every cc1 action needs
// at least one entry, so this is the append the C boundary needs. Buffer-backed inputs are
// deliberately absent: the MemoryBufferRef they hold is non-owning and nothing on this side
// could keep the bytes alive for the parse.
void clang_FrontendOptions_addInputFile(CXFrontendOptions FEO, const char *File,
                                        CXLanguage Lang, CXInputKind_Format Fmt,
                                        bool IsPreprocessed, bool IsSystem);

// helper — empties the input list, so a reused invocation does not accumulate inputs.
void clang_FrontendOptions_clearInputs(CXFrontendOptions FEO);

// OutputFile
// Where the action writes. Required by clang_GeneratePCHAction_create and by every -emit-*
// action reached through clang_ExecuteCompilerInvocation; an empty string means stdout for
// the text actions and a hard failure for PCH generation. Caller frees the string with
// clang_disposeString.
CXString clang_FrontendOptions_getOutputFile(CXFrontendOptions FEO);
void clang_FrontendOptions_setOutputFile(CXFrontendOptions FEO, const char *Path);

// ProgramAction
CXActionKind clang_FrontendOptions_getProgramAction(CXFrontendOptions FEO);
void clang_FrontendOptions_setProgramAction(CXFrontendOptions FEO, CXActionKind Kind);

unsigned clang_FrontendOptions_getModulesEmbedFilesNum(CXFrontendOptions FEO);

// Fills `Buf` with min(N, count) pointers borrowed from the options' own
// storage — valid while the FrontendOptions object is alive and unmodified.
void clang_FrontendOptions_getModulesEmbedFiles(CXFrontendOptions FEO, const char **Buf,
                                                unsigned N);

void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO);

LLVM_CLANG_C_EXTERN_C_END

#endif
