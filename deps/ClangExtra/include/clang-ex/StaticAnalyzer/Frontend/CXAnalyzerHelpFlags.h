#ifndef LLVM_CLANG_C_EXTRA_CXANALYZERHELPFLAGS_H
#define LLVM_CLANG_C_EXTRA_CXANALYZERHELPFLAGS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ento (clang/StaticAnalyzer/Frontend/AnalyzerHelpFlags.h) -- namespace-level free
// functions, so the namespace is the class segment.
//
// Each upstream function prints to an `llvm::raw_ostream`; every wrapper here captures
// that through a raw_string_ostream and returns the text as one CXString. The text is
// human-formatted (the same listing `clang -cc1 -analyzer-checker-help` prints, wrapped to
// a fixed width) and is not a stable machine format -- it is checker DISCOVERY, complete
// with descriptions, documentation URIs and per-checker config options, which the static
// clang_AnalyzerOptions_getRegisteredCheckers name list cannot give.
//
// PRECONDITION for the three CompilerInstance forms: CI must have a DiagnosticsEngine and
// an invocation. Each builds a CheckerManager out of `CI.getAnalyzerOpts()`,
// `CI.getLangOpts()`, `CI.getDiagnostics()` and `CI.getFrontendOpts().Plugins`, and
// getDiagnostics/getAnalyzerOpts both reach through members that are only set once the
// instance is configured.

// Every registered checker, with its description -- plugin checkers included, because the
// registry is built from this instance's plugin list.
CXString clang_ento_printCheckerHelp(CXCompilerInstance CI);

// The subset CI's AnalyzerOptions actually enable.
CXString clang_ento_printEnabledCheckerList(CXCompilerInstance CI);

// Per-checker -analyzer-config options of the enabled checkers.
CXString clang_ento_printCheckerConfigList(CXCompilerInstance CI);

// The non-checker -analyzer-config options, from AnalyzerOptions.def. Needs no instance.
CXString clang_ento_printAnalyzerConfigList(void);

LLVM_CLANG_C_EXTERN_C_END

#endif
