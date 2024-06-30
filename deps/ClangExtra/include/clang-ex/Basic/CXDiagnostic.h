#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// DiagnosticConsumer
CXDiagnosticConsumer clang_IgnoringDiagConsumer_create(void);

void clang_DiagnosticConsumer_dispose(CXDiagnosticConsumer DC);

void clang_DiagnosticConsumer_BeginSourceFile(CXDiagnosticConsumer DC,
                                              CXLangOptions LangOpts, CXPreprocessor PP);

void clang_DiagnosticConsumer_EndSourceFile(CXDiagnosticConsumer DC);

// DiagnosticsEngine
CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient);

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors);

LLVM_CLANG_C_EXTERN_C_END

#endif