#include "clang-ex/Basic/CXDiagnostic.h"
#include "utils.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/SourceManager.h"
#include "llvm/ADT/SmallString.h"

// DiagnosticConsumer
unsigned clang_DiagnosticConsumer_getNumErrors(CXDiagnosticConsumer DC) {
  return reinterpret_cast<clang::DiagnosticConsumer *>(DC)->getNumErrors();
}

unsigned clang_DiagnosticConsumer_getNumWarnings(CXDiagnosticConsumer DC) {
  return reinterpret_cast<clang::DiagnosticConsumer *>(DC)->getNumWarnings();
}

void clang_DiagnosticConsumer_clear(CXDiagnosticConsumer DC) {
  reinterpret_cast<clang::DiagnosticConsumer *>(DC)->clear();
}

void clang_DiagnosticConsumer_finish(CXDiagnosticConsumer DC) {
  reinterpret_cast<clang::DiagnosticConsumer *>(DC)->finish();
}

bool clang_DiagnosticConsumer_IncludeInDiagnosticCounts(CXDiagnosticConsumer DC) {
  return reinterpret_cast<clang::DiagnosticConsumer *>(DC)->IncludeInDiagnosticCounts();
}

CXDiagnosticConsumer clang_IgnoringDiagConsumer_create(void) {
  auto IDC = std::make_unique<clang::IgnoringDiagConsumer>();
  return reinterpret_cast<CXDiagnosticConsumer>(IDC.release());
}

void clang_DiagnosticConsumer_dispose(CXDiagnosticConsumer DC) {
  delete reinterpret_cast<clang::DiagnosticConsumer *>(DC);
}

void clang_DiagnosticConsumer_BeginSourceFile(CXDiagnosticConsumer DC,
                                              CXLangOptions LangOpts, CXPreprocessor PP) {
  reinterpret_cast<clang::DiagnosticConsumer *>(DC)->BeginSourceFile(
      *reinterpret_cast<clang::LangOptions *>(LangOpts), reinterpret_cast<clang::Preprocessor *>(PP));
}

void clang_DiagnosticConsumer_EndSourceFile(CXDiagnosticConsumer DC) {
  reinterpret_cast<clang::DiagnosticConsumer *>(DC)->EndSourceFile();
}

// ForwardingDiagnosticConsumer
CXDiagnosticConsumer
clang_ForwardingDiagnosticConsumer_create(CXDiagnosticConsumer Target) {
  auto FDC = std::make_unique<clang::ForwardingDiagnosticConsumer>(
      *reinterpret_cast<clang::DiagnosticConsumer *>(Target));
  return reinterpret_cast<CXDiagnosticConsumer>(FDC.release());
}

// DiagnosticsEngine
void clang_DiagnosticsEngine_dump(CXDiagnosticsEngine DE) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->dump();
}
CXDiagnosticIDs clang_DiagnosticsEngine_getDiagnosticIDs(CXDiagnosticsEngine DE) {
  return reinterpret_cast<CXDiagnosticIDs>(reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticIDs().get());
}

CXDiagnosticOptions clang_DiagnosticsEngine_getDiagnosticOptions(CXDiagnosticsEngine DE) {
  return reinterpret_cast<CXDiagnosticOptions>(&reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticOptions());
}

CXDiagnosticConsumer clang_DiagnosticsEngine_getClient(CXDiagnosticsEngine DE) {
  return reinterpret_cast<CXDiagnosticConsumer>(reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getClient());
}

bool clang_DiagnosticsEngine_ownsClient(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->ownsClient();
}

CXDiagnosticConsumer clang_DiagnosticsEngine_takeClient(CXDiagnosticsEngine DE) {
  return reinterpret_cast<CXDiagnosticConsumer>(reinterpret_cast<clang::DiagnosticsEngine *>(DE)->takeClient().release());
}

bool clang_DiagnosticsEngine_hasSourceManager(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasSourceManager();
}

CXSourceManager clang_DiagnosticsEngine_getSourceManager(CXDiagnosticsEngine DE) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getSourceManager());
}

void clang_DiagnosticsEngine_setSourceManager(CXDiagnosticsEngine DE, CXSourceManager SM) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSourceManager(
      reinterpret_cast<clang::SourceManager *>(SM));
}

void clang_DiagnosticsEngine_pushMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->pushMappings(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_popMappings(CXDiagnosticsEngine DE, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->popMappings(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_DiagnosticsEngine_setClient(CXDiagnosticsEngine DE, CXDiagnosticConsumer DC,
                                       bool ShouldOwnClient) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setClient(
      reinterpret_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
}

void clang_DiagnosticsEngine_setErrorLimit(CXDiagnosticsEngine DE, unsigned Limit) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setErrorLimit(Limit);
}

void clang_DiagnosticsEngine_setTemplateBacktraceLimit(CXDiagnosticsEngine DE,
                                                       unsigned Limit) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setTemplateBacktraceLimit(Limit);
}

unsigned clang_DiagnosticsEngine_getTemplateBacktraceLimit(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getTemplateBacktraceLimit();
}

void clang_DiagnosticsEngine_setConstexprBacktraceLimit(CXDiagnosticsEngine DE,
                                                        unsigned Limit) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setConstexprBacktraceLimit(Limit);
}

unsigned clang_DiagnosticsEngine_getConstexprBacktraceLimit(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getConstexprBacktraceLimit();
}

void clang_DiagnosticsEngine_setIgnoreAllWarnings(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setIgnoreAllWarnings(Val);
}

bool clang_DiagnosticsEngine_getIgnoreAllWarnings(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getIgnoreAllWarnings();
}

void clang_DiagnosticsEngine_setEnableAllWarnings(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setEnableAllWarnings(Val);
}

bool clang_DiagnosticsEngine_getEnableAllWarnings(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getEnableAllWarnings();
}

void clang_DiagnosticsEngine_setWarningsAsErrors(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setWarningsAsErrors(Val);
}

bool clang_DiagnosticsEngine_getWarningsAsErrors(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getWarningsAsErrors();
}

void clang_DiagnosticsEngine_setErrorsAsFatal(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setErrorsAsFatal(Val);
}

bool clang_DiagnosticsEngine_getErrorsAsFatal(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getErrorsAsFatal();
}

void clang_DiagnosticsEngine_setFatalsAsError(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setFatalsAsError(Val);
}

bool clang_DiagnosticsEngine_getFatalsAsError(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getFatalsAsError();
}

void clang_DiagnosticsEngine_setSuppressSystemWarnings(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSuppressSystemWarnings(Val);
}

bool clang_DiagnosticsEngine_getSuppressSystemWarnings(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getSuppressSystemWarnings();
}

void clang_DiagnosticsEngine_setSuppressAllDiagnostics(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSuppressAllDiagnostics(Val);
}

bool clang_DiagnosticsEngine_getSuppressAllDiagnostics(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getSuppressAllDiagnostics();
}

void clang_DiagnosticsEngine_setElideType(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setElideType(Val);
}

bool clang_DiagnosticsEngine_getElideType(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getElideType();
}

void clang_DiagnosticsEngine_setPrintTemplateTree(CXDiagnosticsEngine DE, bool Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setPrintTemplateTree(Val);
}

bool clang_DiagnosticsEngine_getPrintTemplateTree(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getPrintTemplateTree();
}

bool clang_DiagnosticsEngine_getShowColors(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getShowColors();
}

void clang_DiagnosticsEngine_setShowOverloads(CXDiagnosticsEngine DE,
                                              CXOverloadsShown Val) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setShowOverloads(
      static_cast<clang::OverloadsShown>(Val));
}

CXOverloadsShown clang_DiagnosticsEngine_getShowOverloads(CXDiagnosticsEngine DE) {
  return static_cast<CXOverloadsShown>(
      reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getShowOverloads());
}

unsigned clang_DiagnosticsEngine_getNumOverloadCandidatesToShow(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getNumOverloadCandidatesToShow();
}

void clang_DiagnosticsEngine_overloadCandidatesShown(CXDiagnosticsEngine DE, unsigned N) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->overloadCandidatesShown(N);
}

void clang_DiagnosticsEngine_setLastDiagnosticIgnored(CXDiagnosticsEngine DE,
                                                      bool Ignored) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setLastDiagnosticIgnored(Ignored);
}

bool clang_DiagnosticsEngine_isLastDiagnosticIgnored(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->isLastDiagnosticIgnored();
}

void clang_DiagnosticsEngine_setExtensionHandlingBehavior(CXDiagnosticsEngine DE,
                                                          CXDiag_Severity H) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setExtensionHandlingBehavior(
      static_cast<clang::diag::Severity>(H));
}

CXDiag_Severity
clang_DiagnosticsEngine_getExtensionHandlingBehavior(CXDiagnosticsEngine DE) {
  return static_cast<CXDiag_Severity>(
      reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getExtensionHandlingBehavior());
}

void clang_DiagnosticsEngine_IncrementAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->IncrementAllExtensionsSilenced();
}

void clang_DiagnosticsEngine_DecrementAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->DecrementAllExtensionsSilenced();
}

bool clang_DiagnosticsEngine_hasAllExtensionsSilenced(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasAllExtensionsSilenced();
}

void clang_DiagnosticsEngine_setSeverity(CXDiagnosticsEngine DE, unsigned Diag,
                                         CXDiag_Severity Map, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSeverity(
      Diag, static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_setSeverityForGroup(CXDiagnosticsEngine DE,
                                                 CXDiag_Flavor Flavor, const char *Group,
                                                 CXDiag_Severity Map,
                                                 CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSeverityForGroup(
      static_cast<clang::diag::Flavor>(Flavor), Group,
      static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_setDiagnosticGroupWarningAsError(CXDiagnosticsEngine DE,
                                                              const char *Group,
                                                              bool Enabled) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setDiagnosticGroupWarningAsError(
      Group, Enabled);
}

bool clang_DiagnosticsEngine_setDiagnosticGroupErrorAsFatal(CXDiagnosticsEngine DE,
                                                            const char *Group,
                                                            bool Enabled) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setDiagnosticGroupErrorAsFatal(
      Group, Enabled);
}

void clang_DiagnosticsEngine_setSeverityForAll(CXDiagnosticsEngine DE, CXDiag_Flavor Flavor,
                                               CXDiag_Severity Map, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setSeverityForAll(
      static_cast<clang::diag::Flavor>(Flavor), static_cast<clang::diag::Severity>(Map),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_DiagnosticsEngine_hasErrorOccurred(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasErrorOccurred();
}

bool clang_DiagnosticsEngine_hasUncompilableErrorOccurred(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasUncompilableErrorOccurred();
}

bool clang_DiagnosticsEngine_hasFatalErrorOccurred(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasFatalErrorOccurred();
}

bool clang_DiagnosticsEngine_hasUnrecoverableErrorOccurred(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->hasUnrecoverableErrorOccurred();
}

unsigned clang_DiagnosticsEngine_getNumErrors(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getNumErrors();
}

unsigned clang_DiagnosticsEngine_getNumWarnings(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getNumWarnings();
}

void clang_DiagnosticsEngine_setNumWarnings(CXDiagnosticsEngine DE, unsigned NumWarnings) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setNumWarnings(NumWarnings);
}

unsigned clang_DiagnosticsEngine_getCustomDiagID(CXDiagnosticsEngine DE,
                                                 CXDiagnosticsEngine_Level L,
                                                 const char *FormatString) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticIDs()->getCustomDiagID(
      static_cast<clang::DiagnosticIDs::Level>(L), FormatString);
}

void clang_DiagnosticsEngine_notePriorDiagnosticFrom(CXDiagnosticsEngine DE,
                                                     CXDiagnosticsEngine Other) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->notePriorDiagnosticFrom(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Other));
}

void clang_DiagnosticsEngine_Reset(CXDiagnosticsEngine DE, bool soft) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->Reset(soft);
}

bool clang_DiagnosticsEngine_isIgnored(CXDiagnosticsEngine DE, unsigned DiagID,
                                       CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->isIgnored(
      DiagID, clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXDiagnosticsEngine_Level
clang_DiagnosticsEngine_getDiagnosticLevel(CXDiagnosticsEngine DE, unsigned DiagID,
                                           CXSourceLocation_ Loc) {
  return static_cast<CXDiagnosticsEngine_Level>(
      reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getDiagnosticLevel(
          DiagID, clang::SourceLocation::getFromPtrEncoding(Loc)));
}

void clang_DiagnosticsEngine_Report(CXDiagnosticsEngine DE, CXSourceLocation_ Loc,
                                    unsigned DiagID) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->Report(
      clang::SourceLocation::getFromPtrEncoding(Loc), DiagID);
}

bool clang_DiagnosticsEngine_isDiagnosticInFlight(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->isDiagnosticInFlight();
}

void clang_DiagnosticsEngine_SetDelayedDiagnostic(CXDiagnosticsEngine DE, unsigned DiagID,
                                                  const char *Arg1, const char *Arg2,
                                                  const char *Arg3) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->SetDelayedDiagnostic(DiagID, Arg1, Arg2,
                                                                    Arg3);
}

void clang_DiagnosticsEngine_Clear(CXDiagnosticsEngine DE) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->Clear();
}

const char *clang_DiagnosticsEngine_getFlagValue(CXDiagnosticsEngine DE) {
  return reinterpret_cast<clang::DiagnosticsEngine *>(DE)->getFlagValue().data();
}

CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient) {
  auto DE = std::make_unique<clang::DiagnosticsEngine>(
      llvm::IntrusiveRefCntPtr<clang::DiagnosticIDs>(
          reinterpret_cast<clang::DiagnosticIDs *>(ID)),
      llvm::IntrusiveRefCntPtr<clang::DiagnosticOptions>(
          reinterpret_cast<clang::DiagnosticOptions *>(DO)),
      reinterpret_cast<clang::DiagnosticConsumer *>(DC), ShouldOwnClient);
  return reinterpret_cast<CXDiagnosticsEngine>(DE.release());
}

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE) {
  delete reinterpret_cast<clang::DiagnosticsEngine *>(DE);
}

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors) {
  reinterpret_cast<clang::DiagnosticsEngine *>(DE)->setShowColors(ShowColors);
}
// DiagnosticErrorTrap
CXDiagnosticErrorTrap clang_DiagnosticErrorTrap_create(CXDiagnosticsEngine DE) {
  auto Trap = std::make_unique<clang::DiagnosticErrorTrap>(
      *reinterpret_cast<clang::DiagnosticsEngine *>(DE));
  return reinterpret_cast<CXDiagnosticErrorTrap>(Trap.release());
}

bool clang_DiagnosticErrorTrap_hasErrorOccurred(CXDiagnosticErrorTrap T) {
  return reinterpret_cast<clang::DiagnosticErrorTrap *>(T)->hasErrorOccurred();
}

bool clang_DiagnosticErrorTrap_hasUnrecoverableErrorOccurred(CXDiagnosticErrorTrap T) {
  return reinterpret_cast<clang::DiagnosticErrorTrap *>(T)->hasUnrecoverableErrorOccurred();
}

void clang_DiagnosticErrorTrap_reset(CXDiagnosticErrorTrap T) {
  reinterpret_cast<clang::DiagnosticErrorTrap *>(T)->reset();
}

void clang_DiagnosticErrorTrap_dispose(CXDiagnosticErrorTrap T) {
  delete reinterpret_cast<clang::DiagnosticErrorTrap *>(T);
}

// StoredDiagnostic
CXStoredDiagnostic clang_StoredDiagnostic_create(CXDiagnosticsEngine_Level Level,
                                                 unsigned ID, const char *Message) {
  auto SD = std::make_unique<clang::StoredDiagnostic>(
      static_cast<clang::DiagnosticsEngine::Level>(Level), ID, Message);
  return reinterpret_cast<CXStoredDiagnostic>(SD.release());
}

unsigned clang_StoredDiagnostic_getID(CXStoredDiagnostic SD) {
  return reinterpret_cast<clang::StoredDiagnostic *>(SD)->getID();
}

CXDiagnosticsEngine_Level clang_StoredDiagnostic_getLevel(CXStoredDiagnostic SD) {
  return static_cast<CXDiagnosticsEngine_Level>(
      reinterpret_cast<clang::StoredDiagnostic *>(SD)->getLevel());
}

CXSourceLocation_ clang_StoredDiagnostic_getLocation(CXStoredDiagnostic SD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StoredDiagnostic *>(SD)->getLocation().getPtrEncoding());
}

CXSourceManager clang_StoredDiagnostic_getLocationManager(CXStoredDiagnostic SD) {
  const clang::FullSourceLoc &Loc =
      reinterpret_cast<clang::StoredDiagnostic *>(SD)->getLocation();
  if (!Loc.hasManager())
    return nullptr;
  return reinterpret_cast<CXSourceManager>(const_cast<clang::SourceManager *>(&Loc.getManager()));
}

const char *clang_StoredDiagnostic_getMessage(CXStoredDiagnostic SD) {
  return reinterpret_cast<clang::StoredDiagnostic *>(SD)->getMessage().data();
}

void clang_StoredDiagnostic_setLocation(CXStoredDiagnostic SD, CXSourceLocation_ Loc,
                                        CXSourceManager SM) {
  reinterpret_cast<clang::StoredDiagnostic *>(SD)->setLocation(
      clang::FullSourceLoc(clang::SourceLocation::getFromPtrEncoding(Loc),
                           *reinterpret_cast<clang::SourceManager *>(SM)));
}

unsigned clang_StoredDiagnostic_range_size(CXStoredDiagnostic SD) {
  return reinterpret_cast<clang::StoredDiagnostic *>(SD)->range_size();
}

unsigned clang_StoredDiagnostic_fixit_size(CXStoredDiagnostic SD) {
  return reinterpret_cast<clang::StoredDiagnostic *>(SD)->fixit_size();
}

void clang_StoredDiagnostic_dispose(CXStoredDiagnostic SD) {
  delete reinterpret_cast<clang::StoredDiagnostic *>(SD);
}

CXStoredDiagnostic clang_StoredDiagnostic_createWithRangesAndFixIts(
    CXDiagnosticsEngine_Level Level, unsigned ID, const char *Message,
    CXSourceLocation_ Loc, CXSourceManager SM, const CXSourceRange_ *Ranges,
    const bool *RangeIsTokenRange, unsigned NumRanges, const CXFixItHint *FixIts,
    unsigned NumFixIts) {
  std::vector<clang::CharSourceRange> R;
  R.reserve(NumRanges);
  for (unsigned I = 0; I != NumRanges; ++I)
    R.emplace_back(
        clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Ranges[I].B),
                           clang::SourceLocation::getFromPtrEncoding(Ranges[I].E)),
        RangeIsTokenRange[I]);
  std::vector<clang::FixItHint> F;
  F.reserve(NumFixIts);
  for (unsigned I = 0; I != NumFixIts; ++I)
    F.push_back(*reinterpret_cast<clang::FixItHint *>(FixIts[I]));
  auto SD = std::make_unique<clang::StoredDiagnostic>(
      static_cast<clang::DiagnosticsEngine::Level>(Level), ID, Message,
      clang::FullSourceLoc(clang::SourceLocation::getFromPtrEncoding(Loc),
                           *reinterpret_cast<clang::SourceManager *>(SM)),
      R, F);
  return reinterpret_cast<CXStoredDiagnostic>(SD.release());
}

CXSourceRange_ clang_StoredDiagnostic_getRange(CXStoredDiagnostic SD, unsigned Index) {
  const clang::CharSourceRange &R =
      reinterpret_cast<clang::StoredDiagnostic *>(SD)->getRanges()[Index];
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_StoredDiagnostic_isRangeTokenRange(CXStoredDiagnostic SD, unsigned Index) {
  return reinterpret_cast<clang::StoredDiagnostic *>(SD)->getRanges()[Index].isTokenRange();
}

CXFixItHint clang_StoredDiagnostic_getFixIt(CXStoredDiagnostic SD, unsigned Index) {
  return reinterpret_cast<CXFixItHint>(const_cast<clang::FixItHint *>(
      &reinterpret_cast<clang::StoredDiagnostic *>(SD)->getFixIts()[Index]));
}

// FixItHint
CXFixItHint clang_FixItHint_create(void) {
  auto H = std::make_unique<clang::FixItHint>();
  return reinterpret_cast<CXFixItHint>(H.release());
}

bool clang_FixItHint_isNull(CXFixItHint H) {
  return reinterpret_cast<clang::FixItHint *>(H)->isNull();
}

CXFixItHint clang_FixItHint_CreateInsertion(CXSourceLocation_ InsertionLoc,
                                            const char *Code,
                                            bool BeforePreviousInsertions) {
  auto H = std::make_unique<clang::FixItHint>(clang::FixItHint::CreateInsertion(
      clang::SourceLocation::getFromPtrEncoding(InsertionLoc), Code,
      BeforePreviousInsertions));
  return reinterpret_cast<CXFixItHint>(H.release());
}

CXFixItHint clang_FixItHint_CreateInsertionFromRange(CXSourceLocation_ InsertionLoc,
                                                     CXSourceRange_ FromRange,
                                                     bool IsTokenRange,
                                                     bool BeforePreviousInsertions) {
  clang::CharSourceRange CSR(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(FromRange.B),
                         clang::SourceLocation::getFromPtrEncoding(FromRange.E)),
      IsTokenRange);
  auto H = std::make_unique<clang::FixItHint>(clang::FixItHint::CreateInsertionFromRange(
      clang::SourceLocation::getFromPtrEncoding(InsertionLoc), CSR,
      BeforePreviousInsertions));
  return reinterpret_cast<CXFixItHint>(H.release());
}

CXFixItHint clang_FixItHint_CreateRemoval(CXSourceRange_ RemoveRange, bool IsTokenRange) {
  clang::CharSourceRange CSR(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(RemoveRange.B),
                         clang::SourceLocation::getFromPtrEncoding(RemoveRange.E)),
      IsTokenRange);
  auto H = std::make_unique<clang::FixItHint>(clang::FixItHint::CreateRemoval(CSR));
  return reinterpret_cast<CXFixItHint>(H.release());
}

CXFixItHint clang_FixItHint_CreateReplacement(CXSourceRange_ RemoveRange, bool IsTokenRange,
                                              const char *Code) {
  clang::CharSourceRange CSR(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(RemoveRange.B),
                         clang::SourceLocation::getFromPtrEncoding(RemoveRange.E)),
      IsTokenRange);
  auto H =
      std::make_unique<clang::FixItHint>(clang::FixItHint::CreateReplacement(CSR, Code));
  return reinterpret_cast<CXFixItHint>(H.release());
}

CXSourceRange_ clang_FixItHint_getRemoveRange(CXFixItHint H) {
  const clang::CharSourceRange &R = reinterpret_cast<clang::FixItHint *>(H)->RemoveRange;
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_FixItHint_isRemoveRangeTokenRange(CXFixItHint H) {
  return reinterpret_cast<clang::FixItHint *>(H)->RemoveRange.isTokenRange();
}

CXSourceRange_ clang_FixItHint_getInsertFromRange(CXFixItHint H) {
  const clang::CharSourceRange &R = reinterpret_cast<clang::FixItHint *>(H)->InsertFromRange;
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_FixItHint_isInsertFromRangeTokenRange(CXFixItHint H) {
  return reinterpret_cast<clang::FixItHint *>(H)->InsertFromRange.isTokenRange();
}

const char *clang_FixItHint_getCodeToInsert(CXFixItHint H) {
  return reinterpret_cast<clang::FixItHint *>(H)->CodeToInsert.c_str();
}

bool clang_FixItHint_getBeforePreviousInsertions(CXFixItHint H) {
  return reinterpret_cast<clang::FixItHint *>(H)->BeforePreviousInsertions;
}

void clang_FixItHint_dispose(CXFixItHint H) { delete reinterpret_cast<clang::FixItHint *>(H); }

// DiagnosticBuilder
CXDiagnosticBuilder clang_DiagnosticBuilder_create(CXDiagnosticsEngine DE,
                                                   CXSourceLocation_ Loc, unsigned DiagID) {
  auto DB = std::make_unique<clang::DiagnosticBuilder>(
      reinterpret_cast<clang::DiagnosticsEngine *>(DE)->Report(
          clang::SourceLocation::getFromPtrEncoding(Loc), DiagID));
  return reinterpret_cast<CXDiagnosticBuilder>(DB.release());
}

void clang_DiagnosticBuilder_dispose(CXDiagnosticBuilder DB) {
  delete reinterpret_cast<clang::DiagnosticBuilder *>(DB);
}

CXDiagnosticBuilder clang_DiagnosticBuilder_setForceEmit(CXDiagnosticBuilder DB) {
  return reinterpret_cast<CXDiagnosticBuilder>(const_cast<clang::DiagnosticBuilder *>(
      &reinterpret_cast<clang::DiagnosticBuilder *>(DB)->setForceEmit()));
}

void clang_DiagnosticBuilder_addFlagValue(CXDiagnosticBuilder DB, const char *V) {
  reinterpret_cast<clang::DiagnosticBuilder *>(DB)->addFlagValue(V);
}

// StreamingDiagnostic
void clang_StreamingDiagnostic_AddTaggedVal(CXStreamingDiagnostic SD, uint64_t V,
                                            CXDiagnosticsEngine_ArgumentKind Kind) {
  reinterpret_cast<clang::StreamingDiagnostic *>(SD)->AddTaggedVal(
      V, static_cast<clang::DiagnosticsEngine::ArgumentKind>(Kind));
}

void clang_StreamingDiagnostic_AddString(CXStreamingDiagnostic SD, const char *V) {
  reinterpret_cast<clang::StreamingDiagnostic *>(SD)->AddString(llvm::StringRef(V));
}

void clang_StreamingDiagnostic_AddSourceRange(CXStreamingDiagnostic SD, CXSourceRange_ R,
                                              bool IsTokenRange) {
  clang::SourceRange Range(clang::SourceLocation::getFromPtrEncoding(R.B),
                           clang::SourceLocation::getFromPtrEncoding(R.E));
  reinterpret_cast<clang::StreamingDiagnostic *>(SD)->AddSourceRange(
      clang::CharSourceRange(Range, IsTokenRange));
}

void clang_StreamingDiagnostic_AddFixItHint(CXStreamingDiagnostic SD, CXFixItHint Hint) {
  reinterpret_cast<clang::StreamingDiagnostic *>(SD)->AddFixItHint(
      *reinterpret_cast<clang::FixItHint *>(Hint));
}

// Diagnostic
CXDiagnostic_ clang_Diagnostic_create(CXDiagnosticsEngine DE) {
  auto D = std::make_unique<clang::Diagnostic>(reinterpret_cast<clang::DiagnosticsEngine *>(DE));
  return reinterpret_cast<CXDiagnostic_>(D.release());
}

CXDiagnosticsEngine clang_Diagnostic_getDiags(CXDiagnostic_ D) {
  return reinterpret_cast<CXDiagnosticsEngine>(const_cast<clang::DiagnosticsEngine *>(
      reinterpret_cast<clang::Diagnostic *>(D)->getDiags()));
}

unsigned clang_Diagnostic_getID(CXDiagnostic_ D) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getID();
}

CXSourceLocation_ clang_Diagnostic_getLocation(CXDiagnostic_ D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Diagnostic *>(D)->getLocation().getPtrEncoding());
}

bool clang_Diagnostic_hasSourceManager(CXDiagnostic_ D) {
  return reinterpret_cast<clang::Diagnostic *>(D)->hasSourceManager();
}

CXSourceManager clang_Diagnostic_getSourceManager(CXDiagnostic_ D) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::Diagnostic *>(D)->getSourceManager());
}

unsigned clang_Diagnostic_getNumArgs(CXDiagnostic_ D) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getNumArgs();
}

CXDiagnosticsEngine_ArgumentKind clang_Diagnostic_getArgKind(CXDiagnostic_ D,
                                                             unsigned Idx) {
  return static_cast<CXDiagnosticsEngine_ArgumentKind>(
      reinterpret_cast<clang::Diagnostic *>(D)->getArgKind(Idx));
}

const char *clang_Diagnostic_getArgStdStr(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getArgStdStr(Idx).c_str();
}

const char *clang_Diagnostic_getArgCStr(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getArgCStr(Idx);
}

int64_t clang_Diagnostic_getArgSInt(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getArgSInt(Idx);
}

uint64_t clang_Diagnostic_getArgUInt(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getArgUInt(Idx);
}

CXIdentifierInfo clang_Diagnostic_getArgIdentifier(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::Diagnostic *>(D)->getArgIdentifier(Idx)));
}

uint64_t clang_Diagnostic_getRawArg(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getRawArg(Idx);
}

unsigned clang_Diagnostic_getNumRanges(CXDiagnostic_ D) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getNumRanges();
}

CXSourceRange_ clang_Diagnostic_getRange(CXDiagnostic_ D, unsigned Idx) {
  const clang::CharSourceRange &R = reinterpret_cast<clang::Diagnostic *>(D)->getRange(Idx);
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_Diagnostic_isRangeTokenRange(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getRange(Idx).isTokenRange();
}

unsigned clang_Diagnostic_getNumFixItHints(CXDiagnostic_ D) {
  return reinterpret_cast<clang::Diagnostic *>(D)->getNumFixItHints();
}

CXFixItHint clang_Diagnostic_getFixItHint(CXDiagnostic_ D, unsigned Idx) {
  return reinterpret_cast<CXFixItHint>(const_cast<clang::FixItHint *>(
      &reinterpret_cast<clang::Diagnostic *>(D)->getFixItHint(Idx)));
}

CXString clang_Diagnostic_FormatDiagnostic(CXDiagnostic_ D) {
  llvm::SmallString<128> Out;
  reinterpret_cast<clang::Diagnostic *>(D)->FormatDiagnostic(Out);
  return extra::makeCXString(std::string(Out.data(), Out.size()));
}

void clang_Diagnostic_dispose(CXDiagnostic_ D) {
  delete reinterpret_cast<clang::Diagnostic *>(D);
}
