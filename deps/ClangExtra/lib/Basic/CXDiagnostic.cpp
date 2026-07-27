#include "clang-ex/Basic/CXDiagnostic.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/SourceManager.h"

// DiagnosticConsumer
unsigned clang_DiagnosticConsumer_getNumErrors(CXDiagnosticConsumer DC) {
  return static_cast<clang::DiagnosticConsumer *>(DC)->getNumErrors();
}

unsigned clang_DiagnosticConsumer_getNumWarnings(CXDiagnosticConsumer DC) {
  return static_cast<clang::DiagnosticConsumer *>(DC)->getNumWarnings();
}

void clang_DiagnosticConsumer_clear(CXDiagnosticConsumer DC) {
  static_cast<clang::DiagnosticConsumer *>(DC)->clear();
}

void clang_DiagnosticConsumer_finish(CXDiagnosticConsumer DC) {
  static_cast<clang::DiagnosticConsumer *>(DC)->finish();
}

bool clang_DiagnosticConsumer_IncludeInDiagnosticCounts(CXDiagnosticConsumer DC) {
  return static_cast<clang::DiagnosticConsumer *>(DC)->IncludeInDiagnosticCounts();
}

CXDiagnosticConsumer clang_IgnoringDiagConsumer_create(void) {
  auto IDC = std::make_unique<clang::IgnoringDiagConsumer>();
  return IDC.release();
}

void clang_DiagnosticConsumer_dispose(CXDiagnosticConsumer DC) {
  delete static_cast<clang::DiagnosticConsumer *>(DC);
}

void clang_DiagnosticConsumer_BeginSourceFile(CXDiagnosticConsumer DC,
                                              CXLangOptions LangOpts, CXPreprocessor PP) {
  static_cast<clang::DiagnosticConsumer *>(DC)->BeginSourceFile(
      *static_cast<clang::LangOptions *>(LangOpts), static_cast<clang::Preprocessor *>(PP));
}

void clang_DiagnosticConsumer_EndSourceFile(CXDiagnosticConsumer DC) {
  static_cast<clang::DiagnosticConsumer *>(DC)->EndSourceFile();
}

// DiagnosticsEngine
CXDiagnosticIDs clang_DiagnosticsEngine_getDiagnosticIDs(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticIDs().get();
}

CXDiagnosticOptions clang_DiagnosticsEngine_getDiagnosticOptions(CXDiagnosticsEngine DE) {
  return &static_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticOptions();
}

CXDiagnosticConsumer clang_DiagnosticsEngine_getClient(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getClient();
}

bool clang_DiagnosticsEngine_ownsClient(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->ownsClient();
}

bool clang_DiagnosticsEngine_hasSourceManager(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasSourceManager();
}

CXSourceManager clang_DiagnosticsEngine_getSourceManager(CXDiagnosticsEngine DE) {
  return &static_cast<clang::DiagnosticsEngine *>(DE)->getSourceManager();
}

void clang_DiagnosticsEngine_setSourceManager(CXDiagnosticsEngine DE, CXSourceManager SM) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setSourceManager(
      static_cast<clang::SourceManager *>(SM));
}

void clang_DiagnosticsEngine_pushMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc) {
  static_cast<clang::DiagnosticsEngine *>(DE)->pushMappings(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_popMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->popMappings(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_DiagnosticsEngine_setClient(CXDiagnosticsEngine DE, CXDiagnosticConsumer DC,
                                       bool ShouldOwnClient) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setClient(
      static_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
}

void clang_DiagnosticsEngine_setErrorLimit(CXDiagnosticsEngine DE, unsigned Limit) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setErrorLimit(Limit);
}

void clang_DiagnosticsEngine_setTemplateBacktraceLimit(CXDiagnosticsEngine DE,
                                                       unsigned Limit) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setTemplateBacktraceLimit(Limit);
}

unsigned clang_DiagnosticsEngine_getTemplateBacktraceLimit(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getTemplateBacktraceLimit();
}

void clang_DiagnosticsEngine_setConstexprBacktraceLimit(CXDiagnosticsEngine DE,
                                                        unsigned Limit) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setConstexprBacktraceLimit(Limit);
}

unsigned clang_DiagnosticsEngine_getConstexprBacktraceLimit(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getConstexprBacktraceLimit();
}

void clang_DiagnosticsEngine_setIgnoreAllWarnings(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setIgnoreAllWarnings(Val);
}

bool clang_DiagnosticsEngine_getIgnoreAllWarnings(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getIgnoreAllWarnings();
}

void clang_DiagnosticsEngine_setEnableAllWarnings(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setEnableAllWarnings(Val);
}

bool clang_DiagnosticsEngine_getEnableAllWarnings(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getEnableAllWarnings();
}

void clang_DiagnosticsEngine_setWarningsAsErrors(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setWarningsAsErrors(Val);
}

bool clang_DiagnosticsEngine_getWarningsAsErrors(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getWarningsAsErrors();
}

void clang_DiagnosticsEngine_setErrorsAsFatal(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setErrorsAsFatal(Val);
}

bool clang_DiagnosticsEngine_getErrorsAsFatal(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getErrorsAsFatal();
}

void clang_DiagnosticsEngine_setFatalsAsError(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setFatalsAsError(Val);
}

bool clang_DiagnosticsEngine_getFatalsAsError(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getFatalsAsError();
}

void clang_DiagnosticsEngine_setSuppressSystemWarnings(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setSuppressSystemWarnings(Val);
}

bool clang_DiagnosticsEngine_getSuppressSystemWarnings(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getSuppressSystemWarnings();
}

void clang_DiagnosticsEngine_setSuppressAllDiagnostics(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setSuppressAllDiagnostics(Val);
}

bool clang_DiagnosticsEngine_getSuppressAllDiagnostics(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getSuppressAllDiagnostics();
}

void clang_DiagnosticsEngine_setElideType(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setElideType(Val);
}

bool clang_DiagnosticsEngine_getElideType(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getElideType();
}

void clang_DiagnosticsEngine_setPrintTemplateTree(CXDiagnosticsEngine DE, bool Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setPrintTemplateTree(Val);
}

bool clang_DiagnosticsEngine_getPrintTemplateTree(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getPrintTemplateTree();
}

bool clang_DiagnosticsEngine_getShowColors(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getShowColors();
}

void clang_DiagnosticsEngine_setShowOverloads(CXDiagnosticsEngine DE,
                                              CXOverloadsShown Val) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setShowOverloads(
      static_cast<clang::OverloadsShown>(Val));
}

CXOverloadsShown clang_DiagnosticsEngine_getShowOverloads(CXDiagnosticsEngine DE) {
  return static_cast<CXOverloadsShown>(
      static_cast<clang::DiagnosticsEngine *>(DE)->getShowOverloads());
}

unsigned clang_DiagnosticsEngine_getNumOverloadCandidatesToShow(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getNumOverloadCandidatesToShow();
}

void clang_DiagnosticsEngine_overloadCandidatesShown(CXDiagnosticsEngine DE, unsigned N) {
  static_cast<clang::DiagnosticsEngine *>(DE)->overloadCandidatesShown(N);
}

void clang_DiagnosticsEngine_setLastDiagnosticIgnored(CXDiagnosticsEngine DE,
                                                      bool Ignored) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setLastDiagnosticIgnored(Ignored);
}

bool clang_DiagnosticsEngine_isLastDiagnosticIgnored(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->isLastDiagnosticIgnored();
}

void clang_DiagnosticsEngine_setExtensionHandlingBehavior(CXDiagnosticsEngine DE,
                                                          CXDiag_Severity H) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setExtensionHandlingBehavior(
      static_cast<clang::diag::Severity>(H));
}

CXDiag_Severity
clang_DiagnosticsEngine_getExtensionHandlingBehavior(CXDiagnosticsEngine DE) {
  return static_cast<CXDiag_Severity>(
      static_cast<clang::DiagnosticsEngine *>(DE)->getExtensionHandlingBehavior());
}

void clang_DiagnosticsEngine_IncrementAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  static_cast<clang::DiagnosticsEngine *>(DE)->IncrementAllExtensionsSilenced();
}

void clang_DiagnosticsEngine_DecrementAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  static_cast<clang::DiagnosticsEngine *>(DE)->DecrementAllExtensionsSilenced();
}

bool clang_DiagnosticsEngine_hasAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasAllExtensionsSilenced();
}

void clang_DiagnosticsEngine_setSeverity(CXDiagnosticsEngine DE, unsigned Diag,
                                         CXDiag_Severity Map, CXSourceLocation_ Loc) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setSeverity(
      Diag, static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_setSeverityForGroup(CXDiagnosticsEngine DE,
                                                 CXDiag_Flavor Flavor, const char *Group,
                                                 CXDiag_Severity Map,
                                                 CXSourceLocation_ Loc) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->setSeverityForGroup(
      static_cast<clang::diag::Flavor>(Flavor), Group,
      static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_setDiagnosticGroupWarningAsError(CXDiagnosticsEngine DE,
                                                              const char *Group,
                                                              bool Enabled) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->setDiagnosticGroupWarningAsError(
      Group, Enabled);
}

bool clang_DiagnosticsEngine_setDiagnosticGroupErrorAsFatal(CXDiagnosticsEngine DE,
                                                            const char *Group,
                                                            bool Enabled) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->setDiagnosticGroupErrorAsFatal(
      Group, Enabled);
}

void clang_DiagnosticsEngine_setSeverityForAll(CXDiagnosticsEngine DE, CXDiag_Flavor Flavor,
                                               CXDiag_Severity Map, CXSourceLocation_ Loc) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setSeverityForAll(
      static_cast<clang::diag::Flavor>(Flavor), static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_hasErrorOccurred(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasErrorOccurred();
}

bool clang_DiagnosticsEngine_hasUncompilableErrorOccurred(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasUncompilableErrorOccurred();
}

bool clang_DiagnosticsEngine_hasFatalErrorOccurred(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasFatalErrorOccurred();
}

bool clang_DiagnosticsEngine_hasUnrecoverableErrorOccurred(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->hasUnrecoverableErrorOccurred();
}

unsigned clang_DiagnosticsEngine_getNumErrors(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getNumErrors();
}

unsigned clang_DiagnosticsEngine_getNumWarnings(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getNumWarnings();
}

void clang_DiagnosticsEngine_setNumWarnings(CXDiagnosticsEngine DE, unsigned NumWarnings) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setNumWarnings(NumWarnings);
}

unsigned clang_DiagnosticsEngine_getCustomDiagID(CXDiagnosticsEngine DE,
                                                 CXDiagnosticsEngine_Level L,
                                                 const char *FormatString) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticIDs()->getCustomDiagID(
      static_cast<clang::DiagnosticIDs::Level>(L), FormatString);
}

void clang_DiagnosticsEngine_notePriorDiagnosticFrom(CXDiagnosticsEngine DE,
                                                     CXDiagnosticsEngine Other) {
  static_cast<clang::DiagnosticsEngine *>(DE)->notePriorDiagnosticFrom(
      *static_cast<clang::DiagnosticsEngine *>(Other));
}

void clang_DiagnosticsEngine_Reset(CXDiagnosticsEngine DE, bool soft) {
  static_cast<clang::DiagnosticsEngine *>(DE)->Reset(soft);
}

bool clang_DiagnosticsEngine_isIgnored(CXDiagnosticsEngine DE, unsigned DiagID,
                                       CXSourceLocation_ Loc) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->isIgnored(
      DiagID, clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXDiagnosticsEngine_Level
clang_DiagnosticsEngine_getDiagnosticLevel(CXDiagnosticsEngine DE, unsigned DiagID,
                                           CXSourceLocation_ Loc) {
  return static_cast<CXDiagnosticsEngine_Level>(
      static_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticLevel(
          DiagID, clang::SourceLocation::getFromPtrEncoding(Loc)));
}

void clang_DiagnosticsEngine_Report(CXDiagnosticsEngine DE, CXSourceLocation_ Loc,
                                    unsigned DiagID) {
  static_cast<clang::DiagnosticsEngine *>(DE)->Report(
      clang::SourceLocation::getFromPtrEncoding(Loc), DiagID);
}

bool clang_DiagnosticsEngine_isDiagnosticInFlight(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->isDiagnosticInFlight();
}

void clang_DiagnosticsEngine_Clear(CXDiagnosticsEngine DE) {
  static_cast<clang::DiagnosticsEngine *>(DE)->Clear();
}

const char *clang_DiagnosticsEngine_getFlagValue(CXDiagnosticsEngine DE) {
  return static_cast<clang::DiagnosticsEngine *>(DE)->getFlagValue().data();
}

CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient) {
  auto DE = std::make_unique<clang::DiagnosticsEngine>(
      llvm::IntrusiveRefCntPtr<clang::DiagnosticIDs>(
          static_cast<clang::DiagnosticIDs *>(ID)),
      llvm::IntrusiveRefCntPtr<clang::DiagnosticOptions>(
          static_cast<clang::DiagnosticOptions *>(DO)),
      static_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
  return DE.release();
}

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE) {
  delete static_cast<clang::DiagnosticsEngine *>(DE);
}

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors) {
  static_cast<clang::DiagnosticsEngine *>(DE)->setShowColors(ShowColors);
}
// DiagnosticErrorTrap
CXDiagnosticErrorTrap clang_DiagnosticErrorTrap_create(CXDiagnosticsEngine DE) {
  auto Trap = std::make_unique<clang::DiagnosticErrorTrap>(
      *static_cast<clang::DiagnosticsEngine *>(DE));
  return Trap.release();
}

bool clang_DiagnosticErrorTrap_hasErrorOccurred(CXDiagnosticErrorTrap T) {
  return static_cast<clang::DiagnosticErrorTrap *>(T)->hasErrorOccurred();
}

bool clang_DiagnosticErrorTrap_hasUnrecoverableErrorOccurred(CXDiagnosticErrorTrap T) {
  return static_cast<clang::DiagnosticErrorTrap *>(T)->hasUnrecoverableErrorOccurred();
}

void clang_DiagnosticErrorTrap_reset(CXDiagnosticErrorTrap T) {
  static_cast<clang::DiagnosticErrorTrap *>(T)->reset();
}

void clang_DiagnosticErrorTrap_dispose(CXDiagnosticErrorTrap T) {
  delete static_cast<clang::DiagnosticErrorTrap *>(T);
}

// StoredDiagnostic
CXStoredDiagnostic clang_StoredDiagnostic_create(CXDiagnosticsEngine_Level Level,
                                                 unsigned ID, const char *Message) {
  auto SD = std::make_unique<clang::StoredDiagnostic>(
      static_cast<clang::DiagnosticsEngine::Level>(Level), ID, Message);
  return SD.release();
}

unsigned clang_StoredDiagnostic_getID(CXStoredDiagnostic SD) {
  return static_cast<clang::StoredDiagnostic *>(SD)->getID();
}

CXDiagnosticsEngine_Level clang_StoredDiagnostic_getLevel(CXStoredDiagnostic SD) {
  return static_cast<CXDiagnosticsEngine_Level>(
      static_cast<clang::StoredDiagnostic *>(SD)->getLevel());
}

CXSourceLocation_ clang_StoredDiagnostic_getLocation(CXStoredDiagnostic SD) {
  return static_cast<clang::StoredDiagnostic *>(SD)->getLocation().getPtrEncoding();
}

CXSourceManager clang_StoredDiagnostic_getLocationManager(CXStoredDiagnostic SD) {
  const clang::FullSourceLoc &Loc =
      static_cast<clang::StoredDiagnostic *>(SD)->getLocation();
  if (!Loc.hasManager())
    return nullptr;
  return const_cast<clang::SourceManager *>(&Loc.getManager());
}

const char *clang_StoredDiagnostic_getMessage(CXStoredDiagnostic SD) {
  return static_cast<clang::StoredDiagnostic *>(SD)->getMessage().data();
}

void clang_StoredDiagnostic_setLocation(CXStoredDiagnostic SD, CXSourceLocation_ Loc,
                                        CXSourceManager SM) {
  static_cast<clang::StoredDiagnostic *>(SD)->setLocation(
      clang::FullSourceLoc(clang::SourceLocation::getFromPtrEncoding(Loc),
                           *static_cast<clang::SourceManager *>(SM)));
}

unsigned clang_StoredDiagnostic_range_size(CXStoredDiagnostic SD) {
  return static_cast<clang::StoredDiagnostic *>(SD)->range_size();
}

unsigned clang_StoredDiagnostic_fixit_size(CXStoredDiagnostic SD) {
  return static_cast<clang::StoredDiagnostic *>(SD)->fixit_size();
}

void clang_StoredDiagnostic_dispose(CXStoredDiagnostic SD) {
  delete static_cast<clang::StoredDiagnostic *>(SD);
}
