#ifndef LLVM_CLANG_C_EXTRA_CXANALYZEROPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXANALYZEROPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::AnalyzerOptions (clang/StaticAnalyzer/Core/AnalyzerOptions.h). The handle itself
// already existed in CXTypes.h, handed out by clang_CompilerInvocation_getAnalyzerOpts and
// clang_CompilerInstance_getAnalyzerOpts; this header is what makes it configurable
// without going through CC1 flag strings.
//
// Almost everything the analyzer reads off this class is a PUBLIC DATA MEMBER, not a
// method, so there is no upstream method name to copy: the wrappers below are spelled
// `get<Field>` / `set<Field>` with the field name capitalised after the verb. That is an
// invented spelling and it differs from the member for exactly one field --
// `maxBlockVisitOnPath`, which clang spells with a lowercase m. Where the member is a
// container the pair becomes the count+index enumeration the C boundary needs.
//
// Bitfield members (DisableAllCheckers, AnalyzeAll, AnalyzerWerror,
// ShouldEmitErrorsOnInvalidConfigValue) are value-copied in both directions: a bitfield has
// no address, so no accessor here can hand one out.

// clang/StaticAnalyzer/Core/AnalyzerOptions.h: enum clang::AnalysisConstraints, stamped
// from Analyses.def. The trailing NumConstraints counter is omitted -- it names no model.
typedef enum CXAnalysisConstraints {
  CXAnalysisConstraints_RangeConstraintsModel,
  CXAnalysisConstraints_Z3ConstraintsModel,
} CXAnalysisConstraints;

// clang/StaticAnalyzer/Core/AnalyzerOptions.h: enum clang::AnalysisDiagClients, stamped
// from Analyses.def and then extended with PD_NONE. This is the output client:
// PD_TEXT/PD_TEXT_MINIMAL route through the DiagnosticsEngine (and so through the already
// wrapped TextDiagnosticBuffer/Printer), the others write files. The trailing
// NUM_ANALYSIS_DIAG_CLIENTS counter is omitted -- it names no client.
typedef enum CXAnalysisDiagClients {
  CXAnalysisDiagClients_PD_HTML,
  CXAnalysisDiagClients_PD_HTML_SINGLE_FILE,
  CXAnalysisDiagClients_PD_PLIST,
  CXAnalysisDiagClients_PD_PLIST_MULTI_FILE,
  CXAnalysisDiagClients_PD_PLIST_HTML,
  CXAnalysisDiagClients_PD_SARIF,
  CXAnalysisDiagClients_PD_SARIF_HTML,
  CXAnalysisDiagClients_PD_TEXT,
  CXAnalysisDiagClients_PD_TEXT_MINIMAL,
  CXAnalysisDiagClients_PD_NONE,
} CXAnalysisDiagClients;

// Static members: the checker and package name lists TableGen stamps into Checkers.inc.
// Both are defined `inline` in the pinned header, so they compile into the shim and need
// no export from libclang-cpp. Neither reflects statically linked non-generated checkers
// nor plugin checkers -- clang_ento_printCheckerHelp does.
// Caller frees the set with clang_disposeStringSet.
CXStringSet *clang_AnalyzerOptions_getRegisteredCheckers(bool IncludeExperimental);
CXStringSet *clang_AnalyzerOptions_getRegisteredPackages(bool IncludeExperimental);

// CheckersAndPackages -- the -analyzer-checker / -analyzer-disable-checker list, in the
// order the flags were given; a later entry overrides an earlier one for the same name.
void clang_AnalyzerOptions_addCheckerOrPackage(CXAnalyzerOptions AO, const char *Name,
                                               bool Enable);
unsigned clang_AnalyzerOptions_getNumCheckersAndPackages(CXAnalyzerOptions AO);

// PRECONDITION for both: I < clang_AnalyzerOptions_getNumCheckersAndPackages.
CXString clang_AnalyzerOptions_getCheckerOrPackageName(CXAnalyzerOptions AO, unsigned I);
bool clang_AnalyzerOptions_isCheckerOrPackageEnabled(CXAnalyzerOptions AO, unsigned I);

// SilencedCheckersAndPackages -- checkers that still run but emit no warning.
void clang_AnalyzerOptions_addSilencedCheckerOrPackage(CXAnalyzerOptions AO,
                                                       const char *Name);
unsigned clang_AnalyzerOptions_getNumSilencedCheckersAndPackages(CXAnalyzerOptions AO);

// PRECONDITION: I < clang_AnalyzerOptions_getNumSilencedCheckersAndPackages.
CXString clang_AnalyzerOptions_getSilencedCheckerOrPackage(CXAnalyzerOptions AO,
                                                           unsigned I);

// Config -- the -analyzer-config key/value table (an llvm::StringMap<std::string>).
void clang_AnalyzerOptions_setConfig(CXAnalyzerOptions AO, const char *Key,
                                     const char *Value);

// An absent key yields the EMPTY string, which is also what an explicitly empty value
// yields; clang's own readers treat the two the same way.
CXString clang_AnalyzerOptions_getConfig(CXAnalyzerOptions AO, const char *Key);

unsigned clang_AnalyzerOptions_getNumConfigEntries(CXAnalyzerOptions AO);

// PRECONDITION for both: I < clang_AnalyzerOptions_getNumConfigEntries. The order is the
// StringMap's bucket order -- unspecified, but stable between two calls that do not
// mutate the table, so key and value at the same I always belong together.
CXString clang_AnalyzerOptions_getConfigKey(CXAnalyzerOptions AO, unsigned I);
CXString clang_AnalyzerOptions_getConfigValue(CXAnalyzerOptions AO, unsigned I);

// Scalar knobs
CXAnalysisDiagClients clang_AnalyzerOptions_getAnalysisDiagOpt(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setAnalysisDiagOpt(CXAnalyzerOptions AO,
                                              CXAnalysisDiagClients Value);

CXAnalysisConstraints clang_AnalyzerOptions_getAnalysisConstraintsOpt(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setAnalysisConstraintsOpt(CXAnalyzerOptions AO,
                                                     CXAnalysisConstraints Value);

CXString clang_AnalyzerOptions_getAnalyzeSpecificFunction(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setAnalyzeSpecificFunction(CXAnalyzerOptions AO,
                                                      const char *Value);

CXString clang_AnalyzerOptions_getDumpExplodedGraphTo(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setDumpExplodedGraphTo(CXAnalyzerOptions AO, const char *Value);

unsigned clang_AnalyzerOptions_getMaxBlockVisitOnPath(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setMaxBlockVisitOnPath(CXAnalyzerOptions AO, unsigned Value);

bool clang_AnalyzerOptions_getDisableAllCheckers(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setDisableAllCheckers(CXAnalyzerOptions AO, bool Value);

bool clang_AnalyzerOptions_getAnalyzeAll(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setAnalyzeAll(CXAnalyzerOptions AO, bool Value);

bool clang_AnalyzerOptions_getAnalyzerWerror(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setAnalyzerWerror(CXAnalyzerOptions AO, bool Value);

bool clang_AnalyzerOptions_getShouldEmitErrorsOnInvalidConfigValue(CXAnalyzerOptions AO);
void clang_AnalyzerOptions_setShouldEmitErrorsOnInvalidConfigValue(CXAnalyzerOptions AO,
                                                                   bool Value);

// printFormattedEntry
// isUnknownAnalyzerConfig
// getBooleanOption
// getStringOption
// getIntegerOption
// getCheckerBooleanOption
// getCheckerStringOption
// getCheckerIntegerOption
// getUserMode
// getExplorationStrategy
// getIPAMode
// mayInlineCXXMemberFunction
// getCTUPhase1Inlining
// shouldIgnoreBisonGeneratedFiles
// shouldIgnoreFlexGeneratedFiles

LLVM_CLANG_C_EXTERN_C_END

#endif
