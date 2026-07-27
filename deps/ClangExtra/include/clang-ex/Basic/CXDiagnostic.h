#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang-ex/Basic/CXDiagnosticOptions.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// DiagnosticConsumer
unsigned clang_DiagnosticConsumer_getNumErrors(CXDiagnosticConsumer DC);

unsigned clang_DiagnosticConsumer_getNumWarnings(CXDiagnosticConsumer DC);

void clang_DiagnosticConsumer_clear(CXDiagnosticConsumer DC);

void clang_DiagnosticConsumer_finish(CXDiagnosticConsumer DC);

bool clang_DiagnosticConsumer_IncludeInDiagnosticCounts(CXDiagnosticConsumer DC);

CXDiagnosticConsumer clang_IgnoringDiagConsumer_create(void);

void clang_DiagnosticConsumer_dispose(CXDiagnosticConsumer DC);

void clang_DiagnosticConsumer_BeginSourceFile(CXDiagnosticConsumer DC,
                                              CXLangOptions LangOpts, CXPreprocessor PP);

void clang_DiagnosticConsumer_EndSourceFile(CXDiagnosticConsumer DC);

// DiagnosticsEngine
typedef enum CXDiagnosticsEngine_Level {
  CXDiagnosticsEngine_Ignored = 0,
  CXDiagnosticsEngine_Note,
  CXDiagnosticsEngine_Remark,
  CXDiagnosticsEngine_Warning,
  CXDiagnosticsEngine_Error,
  CXDiagnosticsEngine_Fatal
} CXDiagnosticsEngine_Level;

// The get* accessors below return interior pointers borrowed from the engine — never
// dispose them.
CXDiagnosticIDs clang_DiagnosticsEngine_getDiagnosticIDs(CXDiagnosticsEngine DE);

CXDiagnosticOptions clang_DiagnosticsEngine_getDiagnosticOptions(CXDiagnosticsEngine DE);

CXDiagnosticConsumer clang_DiagnosticsEngine_getClient(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_ownsClient(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_hasSourceManager(CXDiagnosticsEngine DE);

CXSourceManager clang_DiagnosticsEngine_getSourceManager(CXDiagnosticsEngine DE);

// The engine stores the raw pointer; SM must outlive location-based severity queries.
void clang_DiagnosticsEngine_setSourceManager(CXDiagnosticsEngine DE, CXSourceManager SM);

void clang_DiagnosticsEngine_pushMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc);

bool clang_DiagnosticsEngine_popMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc);

// If ShouldOwnClient, the engine adopts DC — disposing it afterwards is a double free.
void clang_DiagnosticsEngine_setClient(CXDiagnosticsEngine DE, CXDiagnosticConsumer DC,
                                       bool ShouldOwnClient);

void clang_DiagnosticsEngine_setErrorLimit(CXDiagnosticsEngine DE, unsigned Limit);

void clang_DiagnosticsEngine_setTemplateBacktraceLimit(CXDiagnosticsEngine DE,
                                                       unsigned Limit);

unsigned clang_DiagnosticsEngine_getTemplateBacktraceLimit(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setConstexprBacktraceLimit(CXDiagnosticsEngine DE,
                                                        unsigned Limit);

unsigned clang_DiagnosticsEngine_getConstexprBacktraceLimit(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setIgnoreAllWarnings(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getIgnoreAllWarnings(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setEnableAllWarnings(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getEnableAllWarnings(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setWarningsAsErrors(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getWarningsAsErrors(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setErrorsAsFatal(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getErrorsAsFatal(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setFatalsAsError(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getFatalsAsError(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setSuppressSystemWarnings(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getSuppressSystemWarnings(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setSuppressAllDiagnostics(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getSuppressAllDiagnostics(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setElideType(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getElideType(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setPrintTemplateTree(CXDiagnosticsEngine DE, bool Val);

bool clang_DiagnosticsEngine_getPrintTemplateTree(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_getShowColors(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setShowOverloads(CXDiagnosticsEngine DE, CXOverloadsShown Val);

CXOverloadsShown clang_DiagnosticsEngine_getShowOverloads(CXDiagnosticsEngine DE);

unsigned clang_DiagnosticsEngine_getNumOverloadCandidatesToShow(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setLastDiagnosticIgnored(CXDiagnosticsEngine DE, bool Ignored);

bool clang_DiagnosticsEngine_isLastDiagnosticIgnored(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setExtensionHandlingBehavior(CXDiagnosticsEngine DE,
                                                          CXDiag_Severity H);

CXDiag_Severity
clang_DiagnosticsEngine_getExtensionHandlingBehavior(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setSeverity(CXDiagnosticsEngine DE, unsigned Diag,
                                         CXDiag_Severity Map, CXSourceLocation_ Loc);

// Returns true (and ignores the request) if Group is unknown.
bool clang_DiagnosticsEngine_setSeverityForGroup(CXDiagnosticsEngine DE,
                                                 CXDiag_Flavor Flavor, const char *Group,
                                                 CXDiag_Severity Map,
                                                 CXSourceLocation_ Loc);

// Returns true if Group is unknown.
bool clang_DiagnosticsEngine_setDiagnosticGroupWarningAsError(CXDiagnosticsEngine DE,
                                                              const char *Group,
                                                              bool Enabled);

// Returns true if Group is unknown.
bool clang_DiagnosticsEngine_setDiagnosticGroupErrorAsFatal(CXDiagnosticsEngine DE,
                                                            const char *Group,
                                                            bool Enabled);

void clang_DiagnosticsEngine_setSeverityForAll(CXDiagnosticsEngine DE, CXDiag_Flavor Flavor,
                                               CXDiag_Severity Map, CXSourceLocation_ Loc);

bool clang_DiagnosticsEngine_hasErrorOccurred(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_hasUncompilableErrorOccurred(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_hasFatalErrorOccurred(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_hasUnrecoverableErrorOccurred(CXDiagnosticsEngine DE);

unsigned clang_DiagnosticsEngine_getNumErrors(CXDiagnosticsEngine DE);

unsigned clang_DiagnosticsEngine_getNumWarnings(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setNumWarnings(CXDiagnosticsEngine DE, unsigned NumWarnings);

// helper: flattens the DiagnosticsEngine::getCustomDiagID template over a runtime
// format string.
unsigned clang_DiagnosticsEngine_getCustomDiagID(CXDiagnosticsEngine DE,
                                                 CXDiagnosticsEngine_Level L,
                                                 const char *FormatString);

void clang_DiagnosticsEngine_Reset(CXDiagnosticsEngine DE, bool soft);

bool clang_DiagnosticsEngine_isIgnored(CXDiagnosticsEngine DE, unsigned DiagID,
                                       CXSourceLocation_ Loc);

CXDiagnosticsEngine_Level
clang_DiagnosticsEngine_getDiagnosticLevel(CXDiagnosticsEngine DE, unsigned DiagID,
                                           CXSourceLocation_ Loc);

// helper: emits the diagnostic immediately (the DiagnosticBuilder is destroyed on
// return), so DiagID must not require any format arguments.
void clang_DiagnosticsEngine_Report(CXDiagnosticsEngine DE, CXSourceLocation_ Loc,
                                    unsigned DiagID);

bool clang_DiagnosticsEngine_isDiagnosticInFlight(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_Clear(CXDiagnosticsEngine DE);

// Borrowed pointer into the engine's flag-value storage.
const char *clang_DiagnosticsEngine_getFlagValue(CXDiagnosticsEngine DE);

CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient);

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors);

LLVM_CLANG_C_EXTERN_C_END

#endif