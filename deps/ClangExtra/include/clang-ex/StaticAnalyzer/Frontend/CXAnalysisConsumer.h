#ifndef LLVM_CLANG_C_EXTRA_CXANALYSISCONSUMER_H
#define LLVM_CLANG_C_EXTRA_CXANALYSISCONSUMER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ento (clang/StaticAnalyzer/Frontend/AnalysisConsumer.h) -- a namespace-level free
// function, so the namespace is the class segment of the name.

// Build the analyzer's AST consumer for CI, configured from CI's AnalyzerOptions. This is
// the analyzer without a FrontendAction: install it with
// clang_CompilerInstance_setASTConsumer and drive it with the already-wrapped
// clang_ParseAST, which is what a caller owning its own CompilerInstance/Sema lifecycle
// needs.
//
// The result is declared at CXASTConsumer -- clang::ento::AnalysisASTConsumer derives
// publicly from clang::ASTConsumer and adds nothing this boundary can reach (see below) --
// so it goes straight into setASTConsumer.
//
// ADOPTION: clang_CompilerInstance_setASTConsumer wraps the pointer in a unique_ptr, so
// after installing it the instance frees it and clang_ASTConsumer_dispose on it is a
// double free. Dispose it only if it never reached an instance.
//
// PRECONDITION: CI must be built out to an ASTContext. The consumer reads
// CI.getAnalyzerOpts() off the invocation, turns warnings-as-errors off through
// CI.getPreprocessor().getDiagnostics(), and holds a cross-TU context bound to
// CI.getASTContext() -- each an unchecked dereference behind an assert.
CXASTConsumer clang_ento_CreateAnalysisConsumer(CXCompilerInstance CI);

// AnalysisASTConsumer::AddDiagnosticConsumer -- takes an
// `ento::PathDiagnosticConsumer *`, an abstract class whose concrete implementations
// (createHTMLDiagnosticConsumer and friends) each need a PathDiagnosticConsumerOptions and
// a MacroExpansionContext. None of those has a handle here, so there is nothing valid to
// pass; -analyzer-output on the invocation installs the same consumers.
// AnalysisASTConsumer::AddCheckerRegistrationFn -- takes a
// `std::function<void(CheckerRegistry &)>`, which needs the callback trampoline this
// library does not have yet.

LLVM_CLANG_C_EXTERN_C_END

#endif
