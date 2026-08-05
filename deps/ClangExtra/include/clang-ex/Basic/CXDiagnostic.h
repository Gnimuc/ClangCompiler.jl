#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTIC_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXDiagnosticIDs.h"
#include "clang-ex/Basic/CXDiagnosticOptions.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

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

// ForwardingDiagnosticConsumer
// Relays every diagnostic to Target, which is stored by reference and must outlive the
// returned consumer. Disposal goes through clang_DiagnosticConsumer_dispose.
CXDiagnosticConsumer clang_ForwardingDiagnosticConsumer_create(CXDiagnosticConsumer Target);

// DiagnosticsEngine
typedef enum CXDiagnosticsEngine_Level {
  CXDiagnosticsEngine_Ignored = 0,
  CXDiagnosticsEngine_Note,
  CXDiagnosticsEngine_Remark,
  CXDiagnosticsEngine_Warning,
  CXDiagnosticsEngine_Error,
  CXDiagnosticsEngine_Fatal
} CXDiagnosticsEngine_Level;

// Dumps the engine's diagnostic-state map (every `#pragma diagnostic` state point and the
// location that introduced it) to stderr. `clang::DiagnosticsEngine::dump` renders those
// locations through the engine's own SourceManager and dereferences it unconditionally, so
// clang_DiagnosticsEngine_hasSourceManager must hold.
void clang_DiagnosticsEngine_dump(CXDiagnosticsEngine DE);

// The get* accessors below return interior pointers borrowed from the engine — never
// dispose them.
CXDiagnosticIDs clang_DiagnosticsEngine_getDiagnosticIDs(CXDiagnosticsEngine DE);

CXDiagnosticOptions clang_DiagnosticsEngine_getDiagnosticOptions(CXDiagnosticsEngine DE);

CXDiagnosticConsumer clang_DiagnosticsEngine_getClient(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_ownsClient(CXDiagnosticsEngine DE);

// Hands ownership of the client back to the caller (nullptr when the engine never owned
// it). The engine goes on using the same consumer, so it must outlive DE and only then be
// released with clang_DiagnosticConsumer_dispose.
CXDiagnosticConsumer clang_DiagnosticsEngine_takeClient(CXDiagnosticsEngine DE);

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

// Call after showing N candidates; N > 4 permanently lowers what
// getNumOverloadCandidatesToShow reports.
void clang_DiagnosticsEngine_overloadCandidatesShown(CXDiagnosticsEngine DE, unsigned N);

void clang_DiagnosticsEngine_setLastDiagnosticIgnored(CXDiagnosticsEngine DE, bool Ignored);

bool clang_DiagnosticsEngine_isLastDiagnosticIgnored(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setExtensionHandlingBehavior(CXDiagnosticsEngine DE,
                                                          CXDiag_Severity H);

CXDiag_Severity
clang_DiagnosticsEngine_getExtensionHandlingBehavior(CXDiagnosticsEngine DE);

// The silencing counter is an unsigned char: a Decrement with no matching prior Increment
// wraps it to a nonzero value and silences every extension diagnostic.
void clang_DiagnosticsEngine_IncrementAllExtensionsSilenced(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_DecrementAllExtensionsSilenced(CXDiagnosticsEngine DE);

bool clang_DiagnosticsEngine_hasAllExtensionsSilenced(CXDiagnosticsEngine DE);

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

// Copies Other's last-diagnostic level into DE, so a note issued on DE attaches to the
// diagnostic Other emitted.
void clang_DiagnosticsEngine_notePriorDiagnosticFrom(CXDiagnosticsEngine DE,
                                                     CXDiagnosticsEngine Other);

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

// Queues DiagID to be reported as soon as the next diagnostic finishes emitting, with
// Arg1/Arg2/Arg3 copied into the engine as its %0/%1/%2 arguments. Only one delayed
// diagnostic fits at a time: a second call before the queued one has been reported is
// silently dropped, and a force-emitted diagnostic does not flush the queue.
void clang_DiagnosticsEngine_SetDelayedDiagnostic(CXDiagnosticsEngine DE, unsigned DiagID,
                                                  const char *Arg1, const char *Arg2,
                                                  const char *Arg3);

void clang_DiagnosticsEngine_Clear(CXDiagnosticsEngine DE);

// Borrowed pointer into the engine's flag-value storage.
const char *clang_DiagnosticsEngine_getFlagValue(CXDiagnosticsEngine DE);

CXDiagnosticsEngine clang_DiagnosticsEngine_create(CXDiagnosticIDs ID,
                                                   CXDiagnosticOptions DO,
                                                   CXDiagnosticConsumer DC,
                                                   bool ShouldOwnClient);

void clang_DiagnosticsEngine_dispose(CXDiagnosticsEngine DE);

void clang_DiagnosticsEngine_setShowColors(CXDiagnosticsEngine DE, bool ShowColors);

// DiagnosticErrorTrap
// The trap holds a reference to DE and snapshots its error counters, so DE must outlive it.
CXDiagnosticErrorTrap clang_DiagnosticErrorTrap_create(CXDiagnosticsEngine DE);

bool clang_DiagnosticErrorTrap_hasErrorOccurred(CXDiagnosticErrorTrap T);

bool clang_DiagnosticErrorTrap_hasUnrecoverableErrorOccurred(CXDiagnosticErrorTrap T);

void clang_DiagnosticErrorTrap_reset(CXDiagnosticErrorTrap T);

void clang_DiagnosticErrorTrap_dispose(CXDiagnosticErrorTrap T);

// StoredDiagnostic
// The diagnostic created here carries no location, ranges or fix-it hints.
CXStoredDiagnostic clang_StoredDiagnostic_create(CXDiagnosticsEngine_Level Level,
                                                 unsigned ID, const char *Message);

unsigned clang_StoredDiagnostic_getID(CXStoredDiagnostic SD);

CXDiagnosticsEngine_Level clang_StoredDiagnostic_getLevel(CXStoredDiagnostic SD);

// The stored FullSourceLoc crosses as its two parts: the SourceLocation encoding here, and
// the SourceManager from getLocationManager.
CXSourceLocation_ clang_StoredDiagnostic_getLocation(CXStoredDiagnostic SD);

// helper: the SourceManager half of the stored FullSourceLoc, nullptr when it has none.
CXSourceManager clang_StoredDiagnostic_getLocationManager(CXStoredDiagnostic SD);

// Borrowed pointer into the diagnostic's own message storage; valid until SD is disposed.
const char *clang_StoredDiagnostic_getMessage(CXStoredDiagnostic SD);

// SM is stored by address in the FullSourceLoc and must outlive SD.
void clang_StoredDiagnostic_setLocation(CXStoredDiagnostic SD, CXSourceLocation_ Loc,
                                        CXSourceManager SM);

unsigned clang_StoredDiagnostic_range_size(CXStoredDiagnostic SD);

unsigned clang_StoredDiagnostic_fixit_size(CXStoredDiagnostic SD);

void clang_StoredDiagnostic_dispose(CXStoredDiagnostic SD);

// helper: builds the full record. Ranges is paired elementwise with RangeIsTokenRange, and
// both the ranges and the FixIts pointed to by the handle buffer are copied into SD. SM is
// stored by address in the FullSourceLoc and must outlive SD.
CXStoredDiagnostic clang_StoredDiagnostic_createWithRangesAndFixIts(
    CXDiagnosticsEngine_Level Level, unsigned ID, const char *Message,
    CXSourceLocation_ Loc, CXSourceManager SM, const CXSourceRange_ *Ranges,
    const bool *RangeIsTokenRange, unsigned NumRanges, const CXFixItHint *FixIts,
    unsigned NumFixIts);

// Indexes the range vector unchecked: Index must be <
// clang_StoredDiagnostic_range_size(SD).
CXSourceRange_ clang_StoredDiagnostic_getRange(CXStoredDiagnostic SD, unsigned Index);

bool clang_StoredDiagnostic_isRangeTokenRange(CXStoredDiagnostic SD, unsigned Index);

// Borrowed interior pointer into the diagnostic's own hint vector — never dispose it. Index
// must be < clang_StoredDiagnostic_fixit_size(SD).
CXFixItHint clang_StoredDiagnostic_getFixIt(CXStoredDiagnostic SD, unsigned Index);

// FixItHint
// A FixItHint is a by-value C++ object, so every create heap-boxes one and the caller
// releases it with clang_FixItHint_dispose. A CharSourceRange crosses as its CXSourceRange_
// plus a separate token-range flag.
CXFixItHint clang_FixItHint_create(void);

bool clang_FixItHint_isNull(CXFixItHint H);

CXFixItHint clang_FixItHint_CreateInsertion(CXSourceLocation_ InsertionLoc,
                                            const char *Code,
                                            bool BeforePreviousInsertions);

CXFixItHint clang_FixItHint_CreateInsertionFromRange(CXSourceLocation_ InsertionLoc,
                                                     CXSourceRange_ FromRange,
                                                     bool IsTokenRange,
                                                     bool BeforePreviousInsertions);

CXFixItHint clang_FixItHint_CreateRemoval(CXSourceRange_ RemoveRange, bool IsTokenRange);

CXFixItHint clang_FixItHint_CreateReplacement(CXSourceRange_ RemoveRange, bool IsTokenRange,
                                              const char *Code);

CXSourceRange_ clang_FixItHint_getRemoveRange(CXFixItHint H);

bool clang_FixItHint_isRemoveRangeTokenRange(CXFixItHint H);

CXSourceRange_ clang_FixItHint_getInsertFromRange(CXFixItHint H);

bool clang_FixItHint_isInsertFromRangeTokenRange(CXFixItHint H);

// Borrowed pointer into the hint's own std::string storage; valid until H is disposed.
const char *clang_FixItHint_getCodeToInsert(CXFixItHint H);

bool clang_FixItHint_getBeforePreviousInsertions(CXFixItHint H);

void clang_FixItHint_dispose(CXFixItHint H);

// DiagnosticsEngine::ArgumentKind
// mirrors clang::DiagnosticsEngine::ArgumentKind (clang/Basic/Diagnostic.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXDiagnosticsEngine_ArgumentKind {
  CXDiagnosticsEngine_ak_std_string = 0,
  CXDiagnosticsEngine_ak_c_string,
  CXDiagnosticsEngine_ak_sint,
  CXDiagnosticsEngine_ak_uint,
  CXDiagnosticsEngine_ak_tokenkind,
  CXDiagnosticsEngine_ak_identifierinfo,
  CXDiagnosticsEngine_ak_addrspace,
  CXDiagnosticsEngine_ak_qual,
  CXDiagnosticsEngine_ak_qualtype,
  CXDiagnosticsEngine_ak_declarationname,
  CXDiagnosticsEngine_ak_nameddecl,
  CXDiagnosticsEngine_ak_nestednamespec,
  CXDiagnosticsEngine_ak_declcontext,
  CXDiagnosticsEngine_ak_qualtype_pair,
  CXDiagnosticsEngine_ak_attr
} CXDiagnosticsEngine_ArgumentKind;

// DiagnosticBuilder
// Opens a diagnostic on DE and leaves it in flight: the arguments, ranges and hints added
// through the StreamingDiagnostic functions below land in DE's own storage, where the
// clang_Diagnostic_* accessors read them back. DE must have no diagnostic in flight
// (clang_DiagnosticsEngine_isDiagnosticInFlight). A DiagnosticBuilder is a by-value C++
// object, so it is heap-boxed here; clang_DiagnosticBuilder_dispose emits the diagnostic to
// DE's client and releases the box, and it must run before DE is disposed.
CXDiagnosticBuilder clang_DiagnosticBuilder_create(CXDiagnosticsEngine DE,
                                                   CXSourceLocation_ Loc, unsigned DiagID);

// Emits the diagnostic and releases the builder.
void clang_DiagnosticBuilder_dispose(CXDiagnosticBuilder DB);

// Marks the diagnostic for unconditional emission, bypassing the severity mapping that
// would otherwise suppress it. Returns DB itself, as the C++ method returns *this.
CXDiagnosticBuilder clang_DiagnosticBuilder_setForceEmit(CXDiagnosticBuilder DB);

// Sets the engine's flag value, which clang_DiagnosticsEngine_getFlagValue reads back. The
// value lives on the engine rather than on the builder, and opening the next diagnostic on
// that engine clears it.
void clang_DiagnosticBuilder_addFlagValue(CXDiagnosticBuilder DB, const char *V);

// StreamingDiagnostic
// Appends one non-string argument. Kind must not be CXDiagnosticsEngine_ak_std_string, and
// at most ten arguments fit in one diagnostic.
void clang_StreamingDiagnostic_AddTaggedVal(CXStreamingDiagnostic SD, uint64_t V,
                                            CXDiagnosticsEngine_ArgumentKind Kind);

// Appends one CXDiagnosticsEngine_ak_std_string argument, copying V into the diagnostic's
// own storage.
void clang_StreamingDiagnostic_AddString(CXStreamingDiagnostic SD, const char *V);

// A CharSourceRange crosses as its CXSourceRange_ plus a separate token-range flag.
void clang_StreamingDiagnostic_AddSourceRange(CXStreamingDiagnostic SD, CXSourceRange_ R,
                                              bool IsTokenRange);

// Copies *Hint into the diagnostic; a null hint is silently dropped.
void clang_StreamingDiagnostic_AddFixItHint(CXStreamingDiagnostic SD, CXFixItHint Hint);

// Diagnostic
// A Diagnostic is a by-value view onto whatever DE currently has in flight, so it is
// heap-boxed here and released with clang_Diagnostic_dispose. Every accessor reads through
// to DE, so a Diagnostic must not outlive it. With nothing in flight the counts read back
// as whatever the last diagnostic left behind and clang_Diagnostic_getID reports the
// not-in-flight sentinel (~0u).
CXDiagnostic_ clang_Diagnostic_create(CXDiagnosticsEngine DE);

// Borrowed: the engine the view reads through, never disposed through this handle.
CXDiagnosticsEngine clang_Diagnostic_getDiags(CXDiagnostic_ D);

unsigned clang_Diagnostic_getID(CXDiagnostic_ D);

CXSourceLocation_ clang_Diagnostic_getLocation(CXDiagnostic_ D);

bool clang_Diagnostic_hasSourceManager(CXDiagnostic_ D);

// Asserts in the C++ layer unless clang_Diagnostic_hasSourceManager.
CXSourceManager clang_Diagnostic_getSourceManager(CXDiagnostic_ D);

unsigned clang_Diagnostic_getNumArgs(CXDiagnostic_ D);

// Idx must be < clang_Diagnostic_getNumArgs(D).
CXDiagnosticsEngine_ArgumentKind clang_Diagnostic_getArgKind(CXDiagnostic_ D, unsigned Idx);

// Borrowed pointer into the diagnostic's own std::string storage; valid until the next
// diagnostic is opened on the engine. Requires getArgKind(Idx) ==
// CXDiagnosticsEngine_ak_std_string.
const char *clang_Diagnostic_getArgStdStr(CXDiagnostic_ D, unsigned Idx);

// Borrowed: the diagnostic stores the pointer the argument was added with rather than a
// copy, so it stays valid only as long as the caller's own storage does. Requires
// getArgKind(Idx) == CXDiagnosticsEngine_ak_c_string.
const char *clang_Diagnostic_getArgCStr(CXDiagnostic_ D, unsigned Idx);

// Requires getArgKind(Idx) == CXDiagnosticsEngine_ak_sint.
int64_t clang_Diagnostic_getArgSInt(CXDiagnostic_ D, unsigned Idx);

// Requires getArgKind(Idx) == CXDiagnosticsEngine_ak_uint.
uint64_t clang_Diagnostic_getArgUInt(CXDiagnostic_ D, unsigned Idx);

// Requires getArgKind(Idx) == CXDiagnosticsEngine_ak_identifierinfo.
CXIdentifierInfo clang_Diagnostic_getArgIdentifier(CXDiagnostic_ D, unsigned Idx);

// The opaque payload of any argument whose kind is not CXDiagnosticsEngine_ak_std_string.
uint64_t clang_Diagnostic_getRawArg(CXDiagnostic_ D, unsigned Idx);

unsigned clang_Diagnostic_getNumRanges(CXDiagnostic_ D);

// Idx must be < clang_Diagnostic_getNumRanges(D).
CXSourceRange_ clang_Diagnostic_getRange(CXDiagnostic_ D, unsigned Idx);

bool clang_Diagnostic_isRangeTokenRange(CXDiagnostic_ D, unsigned Idx);

unsigned clang_Diagnostic_getNumFixItHints(CXDiagnostic_ D);

// Borrowed interior pointer into the diagnostic's own hint vector — never dispose it. Idx
// must be < clang_Diagnostic_getNumFixItHints(D).
CXFixItHint clang_Diagnostic_getFixItHint(CXDiagnostic_ D, unsigned Idx);

// Renders the diagnostic's description with its arguments substituted into the %0 slots.
// The id is looked up in the engine's DiagnosticIDs, so a diagnostic must be in flight.
CXString clang_Diagnostic_FormatDiagnostic(CXDiagnostic_ D);

void clang_Diagnostic_dispose(CXDiagnostic_ D);

LLVM_CLANG_C_EXTERN_C_END

#endif