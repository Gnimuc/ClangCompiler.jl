#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDACTIONS_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDACTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The concrete clang::FrontendActions that are default-constructible, so a factory per
// class is their whole surface: none of them adds a member function a caller of this
// library can reach, and the queries already live on the base in
// clang-ex/Frontend/CXFrontendAction.h.
//
// Like the clang_Emit*Action_create family in clang-ex/CodeGen/CXCodeGenAction.h, each
// create returns the BASE handle. Here the base is CXFrontendAction itself, so every one of
// them is released with clang_FrontendAction_dispose, which deletes through
// clang::FrontendAction's virtual destructor. clang_CompilerInstance_ExecuteAction only
// borrows an action for the duration of the run and never adopts it.

// Custom Consumer Actions
// InitOnlyAction

// Preprocesses the input the way -E does, but loads an implicit PCH first, so a caller that
// set PreprocessorOpts.ImplicitPCHInclude (which
// clang_PrecompiledPreamble_AddImplicitPreamble does) sees the preamble's macros.
CXFrontendAction clang_ReadPCHAndPreprocessAction_create(void);

// DumpCompilerOptionsAction

// AST Consumer Actions
// Pretty-prints each top-level declaration to the instance's output stream.
CXFrontendAction clang_ASTPrintAction_create(void);

// Dumps the AST in the form FrontendOpts.ASTDumpFormat selects.
CXFrontendAction clang_ASTDumpAction_create(void);

// ASTDeclListAction
// ASTViewAction

// Writes a precompiled header for the input translation unit. This is the generating half
// of PCH support: the shim could already consume a PCH and now produces one on the standard
// cc1 path, without the full ASTUnit parse clang_ASTUnit_Save needs.
//
// Set the instance's FrontendOpts.OutputFile to the .pch to write
// (clang_FrontendOptions_setOutputFile) before executing this. Leaving it empty is not an
// error and not a no-op: CompilerInstance::createDefaultOutputFile falls back to "-" when
// both the output path and the action's extension are empty, and the PCH goes to standard
// output.
CXFrontendAction clang_GeneratePCHAction_create(void);

// GenerateModuleAction
// GenerateInterfaceStubsAction
// GenerateModuleFromModuleMapAction
// GenerateModuleInterfaceAction
// GenerateHeaderUnitAction

// Parses and runs semantic analysis, then stops: the AST is complete and no LLVM module is
// built, which is the cheap path for a lookup-only or diagnostics-only run.
CXFrontendAction clang_SyntaxOnlyAction_create(void);

// DumpModuleInfoAction
// VerifyPCHAction
// TemplightDumpAction
// ASTMergeAction
// PrintPreambleAction
// PrintDependencyDirectivesSourceMinimizerAction

// Preprocessor Actions
// DumpRawTokensAction
// DumpTokensAction
// PreprocessOnlyAction
// PrintPreprocessedAction
// GetDependenciesByModuleNameAction

LLVM_CLANG_C_EXTERN_C_END

#endif
