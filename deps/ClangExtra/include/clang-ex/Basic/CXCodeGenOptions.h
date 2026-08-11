#ifndef LLVM_CLANG_C_EXTRA_CXCODEGENOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXCODEGENOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `llvm::codegenoptions::DebugInfoKind` (llvm/Frontend/Debug/Options.h), the
// type of the `DebugInfo` option that clang/Basic/DebugOptions.def declares with
// ENUM_DEBUGOPT and so the only get/set pair in this file that is .def-generated. Synced
// by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXDebugInfoKind {
  CXDebugInfoKind_NoDebugInfo,
  CXDebugInfoKind_LocTrackingOnly,
  CXDebugInfoKind_DebugDirectivesOnly,
  CXDebugInfoKind_DebugLineTablesOnly,
  CXDebugInfoKind_DebugInfoConstructor,
  CXDebugInfoKind_LimitedDebugInfo,
  CXDebugInfoKind_FullDebugInfo,
  CXDebugInfoKind_UnusedTypeInfo
} CXDebugInfoKind;

// Mirror of `llvm::Reloc::Model` (llvm/Support/CodeGen.h), the type of the plain
// `RelocationModel` member. Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXRelocModel {
  CXRelocModel_Static,
  CXRelocModel_PIC_,
  CXRelocModel_DynamicNoPIC,
  CXRelocModel_ROPI,
  CXRelocModel_RWPI,
  CXRelocModel_ROPI_RWPI
} CXRelocModel;

CXCodeGenOptions clang_CodeGenOptions_create(void);

void clang_CodeGenOptions_dispose(CXCodeGenOptions DO);

const char *clang_CodeGenOptions_getArgv0(CXCodeGenOptions CGO);

unsigned clang_CodeGenOptions_getCommandLineArgsNum(CXCodeGenOptions CGO);

// Fills `Buf` with min(N, count) pointers borrowed from the options' own
// storage — valid while the CodeGenOptions object is alive and unmodified.
void clang_CodeGenOptions_getCommandLineArgs(CXCodeGenOptions CGO, const char **Buf,
                                             unsigned N);

void clang_CodeGenOptions_PrintStats(CXCodeGenOptions CGO);

// -clear-ast-before-backend: the frontend releases the AST — `ASTContext::cleanup()` plus a
// reset of its arena — before the backend runs, keeping only what the SourceManager needs.
// A one-bit CODEGENOPT, i.e. a plain public bitfield of CodeGenOptionsBase with no generated
// accessor pair, so this reads and writes it by name.
unsigned clang_CodeGenOptions_getClearASTBeforeBackend(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setClearASTBeforeBackend(CXCodeGenOptions CGO, unsigned Value);

// -disable-free, the CodeGen copy. `CompilerInvocation::CreateFromArgsImpl` sets this from
// the FrontendOptions flag of the same name, after which the two are independent: clearing
// `clang_FrontendOptions_setDisableFree` does not clear this one. What reads it is
// `~EmitAssemblyHelper`, which buries the `llvm::TargetMachine` rather than destroying it —
// the only use in CodeGen, so clearing this trades a per-compilation leak for an ordinary
// destructor call and changes nothing else. Same one-bit CODEGENOPT shape as above.
unsigned clang_CodeGenOptions_getDisableFree(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setDisableFree(CXCodeGenOptions CGO, unsigned Value);

// The -O level (0..3). CodeGenOptions.def declares it AFFECTING_VALUE_CODEGENOPT, i.e. a
// plain two-bit public member of CodeGenOptionsBase with no generated accessor pair, so
// this reads and writes it directly. Values above 3 do not fit the bitfield and are
// truncated by the C++ assignment; the Julia wrapper is what rules them out.
unsigned clang_CodeGenOptions_getOptimizationLevel(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setOptimizationLevel(CXCodeGenOptions CGO, unsigned Level);

// -Os (1) or -Oz (2), 0 for neither. Same two-bit direct member as above.
unsigned clang_CodeGenOptions_getOptimizeSize(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setOptimizeSize(CXCodeGenOptions CGO, unsigned Level);

// The one ENUM_DEBUGOPT option here, so the only member reached through clang's own
// generated getter/setter rather than by name.
CXDebugInfoKind clang_CodeGenOptions_getDebugInfo(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setDebugInfo(CXCodeGenOptions CGO, CXDebugInfoKind Kind);

// Plain `llvm::Reloc::Model` member, not a bitfield.
CXRelocModel clang_CodeGenOptions_getRelocationModel(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setRelocationModel(CXCodeGenOptions CGO, CXRelocModel Model);

// -mcmodel, a plain std::string member; empty when unset. The getter copies because the
// member can be reassigned under the caller.
CXString clang_CodeGenOptions_getCodeModel(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setCodeModel(CXCodeGenOptions CGO, const char *Model);

// The name reported for the main file, a plain std::string member; empty when unset.
CXString clang_CodeGenOptions_getMainFileName(CXCodeGenOptions CGO);
void clang_CodeGenOptions_setMainFileName(CXCodeGenOptions CGO, const char *Name);

LLVM_CLANG_C_EXTERN_C_END

#endif
