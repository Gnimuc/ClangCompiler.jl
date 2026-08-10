#ifndef LLVM_CLANG_C_EXTRA_CXANALYSISACTION_H
#define LLVM_CLANG_C_EXTRA_CXANALYSISACTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ento::AnalysisAction (clang/StaticAnalyzer/Frontend/FrontendActions.h).
//
// The file is named after the class rather than after the clang header: three different
// clang headers in this tree are called FrontendActions.h, and a clang-ex header's include
// guard is derived from its basename, so same-named files would silently collide.
//
// AnalysisAction is the ASTFrontendAction that runs the whole static analyzer pipeline.
// Its only member is a protected CreateASTConsumer override, so the class is
// default-constructible and there is nothing else on it to wrap: everything a caller
// configures lives on the CompilerInvocation (-analyze, -analyzer-checker=...,
// -analyzer-output=text/html/plist/sarif, or the programmatic equivalents in
// clang-ex/StaticAnalyzer/Core/CXAnalyzerOptions.h), and the run happens through the
// already-wrapped clang_CompilerInstance_ExecuteAction. Warnings come back through the
// instance's DiagnosticsEngine for -analyzer-output=text, or as files on disk otherwise.
//
// Like the clang_Emit*Action_create family, the factory hands back the BASE
// CXFrontendAction handle: every accessor in clang-ex/Frontend/CXFrontendAction.h then
// applies, and the dispose below is the class's own.
CXFrontendAction clang_ento_AnalysisAction_create(void);

// Frees an action that was never executed, or one whose ExecuteAction has returned:
// clang_CompilerInstance_ExecuteAction borrows the action and does not adopt it.
void clang_ento_AnalysisAction_dispose(CXFrontendAction FA);

// ParseModelFileAction -- constructor takes an `llvm::StringMap<Stmt *> &` the caller must
// own and read back, which has no C spelling here; the analyzer builds it internally when
// -analyzer-config model-path is set.

LLVM_CLANG_C_EXTERN_C_END

#endif
