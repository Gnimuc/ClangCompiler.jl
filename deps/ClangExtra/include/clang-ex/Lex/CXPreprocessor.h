#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXLangOptions.h" // CXFPEvalMethodKind

LLVM_CLANG_C_EXTERN_C_BEGIN

CXHeaderSearch clang_Preprocessor_getHeaderSearchInfo(CXPreprocessor PP);

void clang_Preprocessor_EnterMainSourceFile(CXPreprocessor PP);

bool clang_Preprocessor_EnterSourceFile(CXPreprocessor PP, CXFileID FID,
                                        CXSourceLocation_ Loc);

void clang_Preprocessor_EndSourceFile(CXPreprocessor PP);

void clang_Preprocessor_PrintStats(CXPreprocessor PP);

void clang_Preprocessor_InitializeBuiltins(CXPreprocessor PP);

void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP);

bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP);

void clang_Preprocessor_DumpToken(CXPreprocessor PP, CXToken_ Tok, bool DumpFlags);

void clang_Preprocessor_DumpLocation(CXPreprocessor PP, CXSourceLocation_ Loc);

// Dumps `MI`'s replacement tokens to stderr; a builtin macro dumps as an empty body.
void clang_Preprocessor_DumpMacro(CXPreprocessor PP, CXMacroInfo MI);

// Dumps `II`'s macro-definition history to stderr. Total: an identifier that never named
// a macro dumps an empty state.
void clang_Preprocessor_dumpMacroInfo(CXPreprocessor PP, CXIdentifierInfo II);

CXDiagnosticsEngine clang_Preprocessor_getDiagnostics(CXPreprocessor PP);

CXLangOptions clang_Preprocessor_getLangOpts(CXPreprocessor PP);

CXTargetInfo_ clang_Preprocessor_getTargetInfo(CXPreprocessor PP);

CXFileManager clang_Preprocessor_getFileManager(CXPreprocessor PP);

CXSourceManager clang_Preprocessor_getSourceManager(CXPreprocessor PP);

CXIdentifierTable clang_Preprocessor_getIdentifierTable(CXPreprocessor PP);

CXSelectorTable clang_Preprocessor_getSelectorTable(CXPreprocessor PP);

// Borrowed: the builtin-function table the preprocessor owns for its whole lifetime.
CXBuiltinContext clang_Preprocessor_getBuiltinInfo(CXPreprocessor PP);

// Borrowed: the preprocessor stores the pointer and does not take ownership, so the
// source must outlive it. A NULL `Source` detaches the current one.
void clang_Preprocessor_setExternalSource(CXPreprocessor PP,
                                          CXExternalPreprocessorSource Source);

// Borrowed; NULL when no external macro source (an AST reader) is attached.
CXExternalPreprocessorSource clang_Preprocessor_getExternalSource(CXPreprocessor PP);

// Borrowed: the module loader the preprocessor was constructed with; never NULL.
CXModuleLoader clang_Preprocessor_getModuleLoader(CXPreprocessor PP);

void clang_Preprocessor_SetCommentRetentionState(CXPreprocessor PP, bool KeepComments,
                                                 bool KeepMacroComments);

bool clang_Preprocessor_getCommentRetentionState(CXPreprocessor PP);

void clang_Preprocessor_setPragmasEnabled(CXPreprocessor PP, bool Enabled);

bool clang_Preprocessor_getPragmasEnabled(CXPreprocessor PP);

// The returned FileID is heap-allocated; dispose with `clang_FileID_dispose`.
CXFileID clang_Preprocessor_getPredefinesFileID(CXPreprocessor PP);

// Borrowed; NULL when no callbacks are installed. The chain is owned by the
// preprocessor, and `clang_Preprocessor_createPreprocessingRecord` is the only entry
// point here that adds to it.
CXPPCallbacks clang_Preprocessor_getPPCallbacks(CXPreprocessor PP);

unsigned clang_Preprocessor_getTokenCount(CXPreprocessor PP);

unsigned clang_Preprocessor_getMaxTokens(CXPreprocessor PP);

bool clang_Preprocessor_isMacroDefined(CXPreprocessor PP, const char *Id);

// helper: `getMacroDefinition(II).isAmbiguous()` — true when several visible module
// macros define `II` and none overrides the others. Total: false when `II` names no
// macro.
bool clang_Preprocessor_isMacroDefinitionAmbiguous(CXPreprocessor PP, CXIdentifierInfo II);

// Borrowed; NULL when `II` has no active macro definition.
CXMacroInfo clang_Preprocessor_getMacroInfo(CXPreprocessor PP, CXIdentifierInfo II);

// True when `II` is #define'd inside the already-preprocessed module `M`; macros merely
// imported into `M` do not count.
bool clang_Preprocessor_isMacroDefinedInLocalModule(CXPreprocessor PP, CXIdentifierInfo II,
                                                    CXModule_ M);

// Borrowed; NULL when `II` is not currently #define'd in this translation unit.
CXMacroDirective clang_Preprocessor_getLocalMacroDirective(CXPreprocessor PP,
                                                           CXIdentifierInfo II);

// Borrowed; the head of `II`'s local #define/#undef history, NULL when it has none. The
// head may be an #undef, so a non-NULL history does not imply a live definition.
CXMacroDirective clang_Preprocessor_getLocalMacroDirectiveHistory(CXPreprocessor PP,
                                                                  CXIdentifierInfo II);

// Allocates a `DefMacroDirective` for `MI` at `Loc` in the preprocessor's arena and
// pushes it onto `II`'s macro-definition history, making the macro live. Borrowed
// (arena-owned, no dispose); the result is typed at the `MacroDirective` base.
CXMacroDirective clang_Preprocessor_appendDefMacroDirective(CXPreprocessor PP,
                                                            CXIdentifierInfo II,
                                                            CXMacroInfo MI,
                                                            CXSourceLocation_ Loc);

// Registers `Macro` as the macro `Mod` exports under the name `II`, overriding the
// `NumOverrides` module macros in `Overrides`. Borrowed (preprocessor-arena, no dispose):
// an identical (module, name, macro, overrides) registration folds onto the node that
// already exists instead of creating a second one, and `*IsNew` (when non-NULL) reports
// which of the two happened.
CXModuleMacro clang_Preprocessor_addModuleMacro(CXPreprocessor PP, CXModule_ Mod,
                                                CXIdentifierInfo II, CXMacroInfo Macro,
                                                const CXModuleMacro *Overrides,
                                                unsigned NumOverrides, bool *IsNew);

// Borrowed; NULL when `Mod` exports no macro named `II`.
CXModuleMacro clang_Preprocessor_getModuleMacro(CXPreprocessor PP, CXModule_ Mod,
                                                CXIdentifierInfo II);

// Count + fill over the leaf (non-overridden) module macros visible for the name `II`. The
// count is exact and no slot is NULL; both calls refresh an out-of-date identifier from the
// external source first, so nothing may register a module macro between them.
unsigned clang_Preprocessor_getNumLeafModuleMacros(CXPreprocessor PP, CXIdentifierInfo II);

void clang_Preprocessor_getLeafModuleMacros(CXPreprocessor PP, CXIdentifierInfo II,
                                            CXModuleMacro *Buffer);

// Count + fill over the macro history table (`macro_begin`/`macro_end`). The count is
// exact and no slot is NULL, but an entry only records that the name once named a macro —
// it may since have been #undef'd. Both calls fold the visible module macros into the
// table, so nothing may lex between them.
unsigned clang_Preprocessor_getNumMacros(CXPreprocessor PP, bool IncludeExternalMacros);

void clang_Preprocessor_getMacros(CXPreprocessor PP, bool IncludeExternalMacros,
                                  CXIdentifierInfo *Buffer);

// Count + fill over the stack of submodules currently being built, outermost first. The
// count is exact and no `Modules` slot is NULL; `ImportLocs[i]` is where the submodule was
// entered and `IsPragma[i]` records whether it was entered through a `#pragma clang module`
// rather than an import. All three buffers must have room for the full count.
unsigned clang_Preprocessor_getNumBuildingSubmodules(CXPreprocessor PP);

void clang_Preprocessor_getBuildingSubmodules(CXPreprocessor PP, CXModule_ *Modules,
                                              CXSourceLocation_ *ImportLocs,
                                              bool *IsPragma);

// Precondition: `M` is a module-map module (`clang_Module_isModuleMapModule`); Clang
// asserts. The preprocessor keeps a borrowed pointer to `M`, so `M` must outlive it.
void clang_Preprocessor_markClangModuleAsAffecting(CXPreprocessor PP, CXModule_ M);

// Count + fill over the top-level clang modules that affected preprocessing without being
// imported. The count is exact and no slot is NULL; the order is the underlying set's.
unsigned clang_Preprocessor_getNumAffectingClangModules(CXPreprocessor PP);

void clang_Preprocessor_getAffectingClangModules(CXPreprocessor PP, CXModule_ *Buffer);

// Count + fill over the set of files already #include'd. The count is exact and no slot is
// NULL; the order is the underlying hash set's and carries no meaning.
unsigned clang_Preprocessor_getNumIncludedFiles(CXPreprocessor PP);

void clang_Preprocessor_getIncludedFiles(CXPreprocessor PP, CXFileEntry *Buffer);

// The name of the last object-like macro defined before `Loc` whose replacement tokens
// equal the `NumTokens` token values built from the parallel `Kinds`/`IIs` arrays: slot `i`
// is the identifier `IIs[i]` when that entry is non-NULL, and the raw
// `clang::tok::TokenKind` value `Kinds[i]` otherwise. The empty string when nothing
// matches. Preconditions: `Loc` is valid (the macro directive history lookup asserts on an
// invalid location), and every kind slot names a kind that is neither an identifier nor a
// literal nor an annotation — Clang asserts all three in the `TokenValue` constructor.
CXString clang_Preprocessor_getLastMacroWithSpelling(CXPreprocessor PP,
                                                     CXSourceLocation_ Loc,
                                                     const unsigned *Kinds,
                                                     const CXIdentifierInfo *IIs,
                                                     unsigned NumTokens);

// Borrowed; NULL until `clang_Preprocessor_createPreprocessingRecord` has run.
CXPreprocessingRecord clang_Preprocessor_getPreprocessingRecord(CXPreprocessor PP);

// Installs a preprocessing record. The record is adopted by the preprocessor's callback
// chain — it has no dispose and must not be freed.
void clang_Preprocessor_createPreprocessingRecord(CXPreprocessor PP);

// Precondition: `M` is a global module fragment or `Loc` is valid; Clang asserts. The
// preprocessor keeps a borrowed pointer to `M`, so `M` must outlive it.
void clang_Preprocessor_makeModuleVisible(CXPreprocessor PP, CXModule_ M,
                                          CXSourceLocation_ Loc);

// The location `M` was made visible at; an invalid location when it never was.
CXSourceLocation_ clang_Preprocessor_getModuleImportLoc(CXPreprocessor PP, CXModule_ M);

CXString clang_Preprocessor_getPredefines(CXPreprocessor PP);

void clang_Preprocessor_setPredefines(CXPreprocessor PP, const char *P);

CXIdentifierInfo clang_Preprocessor_getIdentifierInfo(CXPreprocessor PP,
                                                      const char *Name);

void clang_Preprocessor_Lex(CXPreprocessor PP, CXToken_ Result);

CXString clang_Preprocessor_getSpelling(CXPreprocessor PP, CXToken_ Tok);

CXPreprocessorOptions clang_Preprocessor_getPreprocessorOpts(CXPreprocessor PP);

unsigned clang_Preprocessor_getNumDirectives(CXPreprocessor PP);

bool clang_Preprocessor_isParsingIfOrElifDirective(CXPreprocessor PP);

void clang_Preprocessor_setPreprocessedOutput(CXPreprocessor PP, bool IsPreprocessedOutput);

bool clang_Preprocessor_isPreprocessedOutput(CXPreprocessor PP);

bool clang_Preprocessor_isInPrimaryFile(CXPreprocessor PP);

void clang_Preprocessor_overrideMaxTokens(CXPreprocessor PP, unsigned Value,
                                          CXSourceLocation_ Loc);

CXSourceLocation_ clang_Preprocessor_getMaxTokensOverrideLoc(CXPreprocessor PP);

unsigned clang_Preprocessor_getCounterValue(CXPreprocessor PP);

void clang_Preprocessor_setCounterValue(CXPreprocessor PP, unsigned V);

bool clang_Preprocessor_SawDateOrTime(CXPreprocessor PP);

size_t clang_Preprocessor_getTotalMemory(CXPreprocessor PP);

void clang_Preprocessor_EnableBacktrackAtThisPos(CXPreprocessor PP);

// Precondition: a matching `clang_Preprocessor_EnableBacktrackAtThisPos` is pending
// (asserted inside Clang).
void clang_Preprocessor_CommitBacktrackedTokens(CXPreprocessor PP);

// Precondition: a matching `clang_Preprocessor_EnableBacktrackAtThisPos` is pending
// (asserted inside Clang).
void clang_Preprocessor_Backtrack(CXPreprocessor PP);

bool clang_Preprocessor_isBacktrackEnabled(CXPreprocessor PP);

void clang_Preprocessor_SetMacroExpansionOnlyInDirectives(CXPreprocessor PP);

bool clang_Preprocessor_isInNamedModule(CXPreprocessor PP);

// Precondition: `clang_Preprocessor_isInNamedModule` is true.
CXString clang_Preprocessor_getNamedModuleName(CXPreprocessor PP);

// helper: `getMacroDefinitionAtLoc(II, Loc).getMacroInfo()`. Borrowed; NULL when `II` has
// no macro definition active at `Loc`. Precondition: `Loc` is valid — the directive
// history lookup asserts on an invalid location.
CXMacroInfo clang_Preprocessor_getMacroInfoAtLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                 CXSourceLocation_ Loc);

bool clang_Preprocessor_hadModuleLoaderFatalFailure(CXPreprocessor PP);

void clang_Preprocessor_SetSuppressIncludeNotFoundError(CXPreprocessor PP, bool Suppress);

bool clang_Preprocessor_GetSuppressIncludeNotFoundError(CXPreprocessor PP);

// True when `FE` is the PCH through-header. Precondition: a through-header is configured
// (`clang_Preprocessor_creatingPCHWithThroughHeader` or
// `clang_Preprocessor_usingPCHWithThroughHeader` is true) — the setting is read
// unconditionally and the answer is meaningless without one.
bool clang_Preprocessor_isPCHThroughHeader(CXPreprocessor PP, CXFileEntry FE);

bool clang_Preprocessor_creatingPCHWithThroughHeader(CXPreprocessor PP);

bool clang_Preprocessor_usingPCHWithThroughHeader(CXPreprocessor PP);

bool clang_Preprocessor_creatingPCHWithPragmaHdrStop(CXPreprocessor PP);

bool clang_Preprocessor_usingPCHWithPragmaHdrStop(CXPreprocessor PP);

// Lexes until a non-comment token is produced; `Result` is overwritten with it.
void clang_Preprocessor_LexNonComment(CXPreprocessor PP, CXToken_ Result);

void clang_Preprocessor_LexUnexpandedToken(CXPreprocessor PP, CXToken_ Result);

void clang_Preprocessor_LexUnexpandedNonComment(CXPreprocessor PP, CXToken_ Result);

// Parses Tok's spelling as a plain integer literal and writes it to *Value, returning true;
// a floating-point literal, a user-defined-suffix literal or an unreadable spelling returns
// false and leaves *Value untouched. PRECONDITION: Tok is a tok::numeric_constant
// (clang_Token_isKind_numeric_constant); clang asserts.
// NOTE: on success clang lexes the FOLLOWING token into Tok, so Tok is overwritten and the
// preprocessor's token stream advances by one -- read the answer out of *Value, never out of
// Tok, and expect the live stream to have moved.
bool clang_Preprocessor_parseSimpleIntegerLiteral(CXPreprocessor PP, CXToken_ Tok,
                                                  uint64_t *Value);

bool clang_Preprocessor_isCodeCompletionEnabled(CXPreprocessor PP);

CXSourceLocation_ clang_Preprocessor_getCodeCompletionLoc(CXPreprocessor PP);

CXSourceLocation_ clang_Preprocessor_getCodeCompletionFileLoc(CXPreprocessor PP);

bool clang_Preprocessor_isCodeCompletionReached(CXPreprocessor PP);

// Returns true on FAILURE (mirroring `Preprocessor::getRawToken`); on success `Result` is
// overwritten with the relexed token.
bool clang_Preprocessor_getRawToken(CXPreprocessor PP, CXSourceLocation_ Loc,
                                    CXToken_ Result, bool IgnoreWhiteSpace);

CXSourceLocation_ clang_Preprocessor_getLocForEndOfToken(CXPreprocessor PP,
                                                         CXSourceLocation_ Loc,
                                                         unsigned Offset);

// Borrowed; NULL unless a module is currently being built.
CXModule_ clang_Preprocessor_getCurrentModule(CXPreprocessor PP);

// Borrowed; NULL unless a module implementation is currently being compiled.
CXModule_ clang_Preprocessor_getCurrentModuleImplementation(CXPreprocessor PP);

bool clang_Preprocessor_isInNamedInterfaceUnit(CXPreprocessor PP);

bool clang_Preprocessor_isInImplementationUnit(CXPreprocessor PP);

// Borrowed; NULL when there is no auxiliary target.
CXTargetInfo_ clang_Preprocessor_getAuxTargetInfo(CXPreprocessor PP);

// Borrowed; NULL when the current lexer is not in a submodule.
CXModule_ clang_Preprocessor_getCurrentLexerSubmodule(CXPreprocessor PP);

void clang_Preprocessor_setCodeCompletionTokenRange(CXPreprocessor PP,
                                                    CXSourceLocation_ Start,
                                                    CXSourceLocation_ End);

CXSourceRange_ clang_Preprocessor_getCodeCompletionTokenRange(CXPreprocessor PP);

bool clang_Preprocessor_mightHavePendingAnnotationTokens(CXPreprocessor PP);

CXSourceLocation_ clang_Preprocessor_getPragmaAssumeNonNullLoc(CXPreprocessor PP);

void clang_Preprocessor_setPragmaAssumeNonNullLoc(CXPreprocessor PP, CXSourceLocation_ Loc);

CXSourceLocation_
clang_Preprocessor_getPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP);

// Precondition: `Loc` is a valid macro-expansion location (`isMacroID`); Clang asserts.
CXString clang_Preprocessor_getImmediateMacroName(CXPreprocessor PP, CXSourceLocation_ Loc);

// Precondition: `Loc` is a valid macro-expansion location (`isMacroID`). On success and
// when `MacroBegin` is non-null, `*MacroBegin` receives the macro's begin location.
bool clang_Preprocessor_isAtStartOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                  CXSourceLocation_ *MacroBegin);

// Precondition: `Loc` is a valid macro-expansion location (`isMacroID`). On success and
// when `MacroEnd` is non-null, `*MacroEnd` receives the macro's end location.
bool clang_Preprocessor_isAtEndOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                CXSourceLocation_ *MacroEnd);

CXSourceLocation_ clang_Preprocessor_AdvanceToTokenCharacter(CXPreprocessor PP,
                                                             CXSourceLocation_ TokStart,
                                                             unsigned Char);

CXSourceLocation_ clang_Preprocessor_getLastFPEvalPragmaLocation(CXPreprocessor PP);

bool clang_Preprocessor_isInImportingCXXNamedModules(CXPreprocessor PP);

// Borrowed; NULL when `Loc` is outside any module.
CXModule_ clang_Preprocessor_getModuleForLocation(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                 bool AllowTextual);

// Static: true when the check FAILED, i.e. `M` is not usable — a diagnostic naming the
// unmet requirement, the missing header or the shadowing module is reported through `Diags`
// in that case. A module built by hand has no module map behind it, so whether it counts as
// available is host-decided.
bool clang_Preprocessor_checkModuleIsAvailable(CXLangOptions LangOpts, CXTargetInfo_ TI,
                                               CXModule_ M, CXDiagnosticsEngine Diags);

// The header to #include at `IncLoc` so that the entity at `MLoc` becomes reachable, or
// NULL when no such header exists or when importing a module is the right answer instead.
// Not fast, and it may load module maps that were not otherwise needed. The returned
// FileEntryRef is heap-allocated; dispose it with `clang_FileEntryRef_dispose`.
CXFileEntryRef clang_Preprocessor_getHeaderToIncludeForDiagnostics(CXPreprocessor PP,
                                                                   CXSourceLocation_ IncLoc,
                                                                   CXSourceLocation_ MLoc);

bool clang_Preprocessor_isRecordingPreamble(CXPreprocessor PP);

bool clang_Preprocessor_hasRecordedPreamble(CXPreprocessor PP);

// Count + fill over the recorded preamble conditional stack (the `#if` directives still
// open at the end of the preamble), outermost first. The count is exact and all four
// buffers must have room for it: `IfLocs[i]` is where the conditional started,
// `WasSkipping[i]` whether it sat inside a skipped block, `FoundNonSkip[i]` whether tokens
// were already emitted for it, `FoundElse[i]` whether its `#else` has been seen.
unsigned clang_Preprocessor_getNumPreambleConditionals(CXPreprocessor PP);

void clang_Preprocessor_getPreambleConditionalStack(CXPreprocessor PP,
                                                    CXSourceLocation_ *IfLocs,
                                                    bool *WasSkipping, bool *FoundNonSkip,
                                                    bool *FoundElse);

// Replaces the recorded preamble conditional stack from `N` parallel entries. Total, but
// deliberately inert unless the store is recording or replaying a preamble — Clang drops
// the new stack on the floor otherwise.
void clang_Preprocessor_setRecordedPreambleConditionalStack(
    CXPreprocessor PP, const CXSourceLocation_ *IfLocs, const bool *WasSkipping,
    const bool *FoundNonSkip, const bool *FoundElse, unsigned N);

// Fills the "reached EOF while still skipping a preamble conditional" record and returns
// true; returns false leaving every out-param untouched when no such record exists.
bool clang_Preprocessor_getPreambleSkipInfo(CXPreprocessor PP,
                                            CXSourceLocation_ *HashTokenLoc,
                                            CXSourceLocation_ *IfTokenLoc,
                                            bool *FoundNonSkipPortion, bool *FoundElse,
                                            CXSourceLocation_ *ElseLoc);

bool clang_Preprocessor_isPPInSafeBufferOptOutRegion(CXPreprocessor PP);

void clang_Preprocessor_setPreprocessToken(CXPreprocessor PP, bool Preprocess);

void clang_Preprocessor_IgnorePragmas(CXPreprocessor PP);

// Borrowed: the preprocessor stores the pointer and does not take ownership, so the
// handler must outlive it. A NULL `Handler` detaches the current one.
void clang_Preprocessor_setEmptylineHandler(CXPreprocessor PP, CXEmptylineHandler Handler);

// Borrowed; NULL when no empty-line handler is installed.
CXEmptylineHandler clang_Preprocessor_getEmptylineHandler(CXPreprocessor PP);

// Borrowed: the preprocessor stores the pointer and does not take ownership, so the handler
// must outlive it. `Handler` must be non-NULL — Clang takes it by reference.
void clang_Preprocessor_setCodeCompletionHandler(CXPreprocessor PP,
                                                 CXCodeCompletionHandler Handler);

// Borrowed; NULL when no code-completion handler is installed.
CXCodeCompletionHandler clang_Preprocessor_getCodeCompletionHandler(CXPreprocessor PP);

// Detaches the code-completion handler; the handler itself is not owned here.
void clang_Preprocessor_clearCodeCompletionHandler(CXPreprocessor PP);

void clang_Preprocessor_recomputeCurLexerKind(CXPreprocessor PP);

void clang_Preprocessor_setSkipMainFilePreamble(CXPreprocessor PP, unsigned Bytes,
                                                bool StartOfLine);

void clang_Preprocessor_IncrementPasteCounter(CXPreprocessor PP, bool IsFast);

// PRECONDITION: the LangOptions must have Borland extensions enabled
// (-fborland-extensions). Preprocessor's nine SEH `IdentifierInfo *` members
// (Ident__exception_code and friends) have NO default initializer and are
// populated only on the Borland path; PoisonSEHIdentifiers dereferences all of
// them unconditionally, so calling it otherwise segfaults. The Julia wrapper
// restates this via clang_LangOptions_getBorland.
void clang_Preprocessor_PoisonSEHIdentifiers(CXPreprocessor PP, bool Poison);

// Allocates a MacroInfo in the preprocessor's arena; borrowed (arena-owned, no dispose).
CXMacroInfo clang_Preprocessor_AllocateMacroInfo(CXPreprocessor PP, CXSourceLocation_ L);

void clang_Preprocessor_markMacroAsUsed(CXPreprocessor PP, CXMacroInfo MI);

// Precondition: `Loc` is a source location that has already been preprocessed.
bool clang_Preprocessor_isSafeBufferOptOut(CXPreprocessor PP, CXSourceManager SM,
                                           CXSourceLocation_ Loc);

// Returns true iff it is INVALID to enter or exit the region (entering before exiting a
// previous region, or exiting a region the PP is not currently in).
bool clang_Preprocessor_enterOrExitSafeBufferOptOutRegion(CXPreprocessor PP, bool IsEnter,
                                                          CXSourceLocation_ Loc);

bool clang_Preprocessor_markIncluded(CXPreprocessor PP, CXFileEntryRef File);

bool clang_Preprocessor_alreadyIncluded(CXPreprocessor PP, CXFileEntryRef File);

void clang_Preprocessor_setCodeCompletionIdentifierInfo(CXPreprocessor PP,
                                                        CXIdentifierInfo Filter);

// The empty string when no code-completion filter identifier has been installed.
CXString clang_Preprocessor_getCodeCompletionFilter(CXPreprocessor PP);

// False whenever no tokens are cached (i.e. outside a backtracking scope).
bool clang_Preprocessor_IsPreviousCachedToken(CXPreprocessor PP, CXToken_ Tok);

// Precondition: `Tok` is not a `tok::raw_identifier` and carries an identifier
// (`clang_Token_getIdentifierInfo` is non-NULL); Clang asserts on both. A no-op unless
// backtracking is enabled and at least one token has been cached.
void clang_Preprocessor_TypoCorrectToken(CXPreprocessor PP, CXToken_ Tok);

// Precondition: `clang_Preprocessor_isCodeCompletionEnabled` is true (Clang asserts).
void clang_Preprocessor_setCodeCompletionReached(CXPreprocessor PP);

// helper: the `IdentifierInfo *` half of `getPragmaARCCFCodeAuditedInfo()`. Borrowed; NULL
// when no `#pragma clang arc_cf_code_audited begin` is active.
CXIdentifierInfo clang_Preprocessor_getPragmaARCCFCodeAuditedIdent(CXPreprocessor PP);

// helper: the `SourceLocation` half of `getPragmaARCCFCodeAuditedInfo()`. Invalid when no
// `#pragma clang arc_cf_code_audited begin` is active.
CXSourceLocation_ clang_Preprocessor_getPragmaARCCFCodeAuditedLoc(CXPreprocessor PP);

// An invalid `Loc` ends the pragma.
void clang_Preprocessor_setPragmaARCCFCodeAuditedInfo(CXPreprocessor PP,
                                                      CXIdentifierInfo Ident,
                                                      CXSourceLocation_ Loc);

void clang_Preprocessor_setPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP,
                                                                  CXSourceLocation_ Loc);

// Precondition: `Tok` is a `tok::numeric_constant` of length 1 that needs no cleaning;
// Clang asserts all three. When `Invalid` is non-null it receives whether the character
// data could not be read.
char clang_Preprocessor_getSpellingOfSingleCharacterNumericConstant(CXPreprocessor PP,
                                                                    CXToken_ Tok,
                                                                    bool *Invalid);

// Copies `Str` into the preprocessor's scratch buffer and points `Tok` at it, setting the
// token's location and length. Pass an invalid `ExpansionLocStart`/`ExpansionLocEnd` pair
// for a plain scratch token, or a valid pair to give it a macro-expansion location.
void clang_Preprocessor_CreateString(CXPreprocessor PP, const char *Str, CXToken_ Tok,
                                     CXSourceLocation_ ExpansionLocStart,
                                     CXSourceLocation_ ExpansionLocEnd);

// Precondition: `TokLoc` is a valid location naming the start of a token.
CXSourceLocation_ clang_Preprocessor_SplitToken(CXPreprocessor PP, CXSourceLocation_ TokLoc,
                                                unsigned Length);

// Installs the identifier info (and the matching token kind) on `Identifier` and returns
// it. Precondition: `Identifier` is a non-empty `tok::raw_identifier`; Clang asserts.
CXIdentifierInfo clang_Preprocessor_LookUpIdentifierInfo(CXPreprocessor PP,
                                                         CXToken_ Identifier);

// Precondition: the current evaluation method has been set — `Preprocessor::Initialize`
// does that from the target or the command line, and Clang asserts it is no longer
// `FEM_UnsetOnCommandLine`. `setCurrentFPEvalMethod` always writes the TU-wide method too,
// so `clang_Preprocessor_getTUFPEvalMethod() != CXFPEvalMethodKind_FEM_UnsetOnCommandLine`
// is a sound gate for it — the Julia wrapper asserts on that.
CXFPEvalMethodKind clang_Preprocessor_getCurrentFPEvalMethod(CXPreprocessor PP);

CXFPEvalMethodKind clang_Preprocessor_getTUFPEvalMethod(CXPreprocessor PP);

// Precondition: `Val` is not `CXFPEvalMethodKind_FEM_UnsetOnCommandLine` (Clang asserts).
void clang_Preprocessor_setCurrentFPEvalMethod(CXPreprocessor PP,
                                               CXSourceLocation_ PragmaLoc,
                                               CXFPEvalMethodKind Val);

// Precondition: `Val` is not `CXFPEvalMethodKind_FEM_UnsetOnCommandLine` (Clang asserts).
void clang_Preprocessor_setTUFPEvalMethod(CXPreprocessor PP, CXFPEvalMethodKind Val);

// Strips the `<>` or `""` delimiters off an `#include` filename spelling and returns the
// bare filename; `*IsAngled` (when non-null) receives true for `<x>` and false for `"x"`.
// A malformed spelling reports a diagnostic at `Loc`, sets `*IsAngled` to true and returns
// the empty string. Precondition: `Buffer` is non-empty (Clang asserts).
CXString clang_Preprocessor_GetIncludeFilenameSpelling(CXPreprocessor PP,
                                                       CXSourceLocation_ Loc,
                                                       const char *Buffer, bool *IsAngled);

// Borrowed: the preprocessor stores the pointer and does not take ownership, so the
// engine must outlive it.
void clang_Preprocessor_setDiagnostics(CXPreprocessor PP, CXDiagnosticsEngine Diags);

bool clang_Preprocessor_isCurrentLexer(CXPreprocessor PP, CXPreprocessorLexer L);

// Borrowed; NULL while the preprocessor is serving tokens from a macro expansion or from
// the token cache rather than from a lexer.
CXPreprocessorLexer clang_Preprocessor_getCurrentLexer(CXPreprocessor PP);

// Borrowed; the innermost *file* lexer on the include stack, NULL when there is none.
CXPreprocessorLexer clang_Preprocessor_getCurrentFileLexer(CXPreprocessor PP);

// Copies the token `N` positions ahead of the next one to be lexed into `Result` without
// consuming anything; `N == 0` is the token `clang_Preprocessor_Lex` would return next.
// Peeking pulls tokens into the preprocessor's cache, so it must not run from inside a
// nested lexing action (Clang asserts `LexLevel == 0`, which nothing observes).
void clang_Preprocessor_LookAhead(CXPreprocessor PP, unsigned N, CXToken_ Result);

// Precondition: backtracking is enabled and `N` does not reach past the last backtrack
// position; Clang asserts both, only the first is observable.
void clang_Preprocessor_RevertCachedTokens(CXPreprocessor PP, unsigned N);

// Pushes a copy of `Tok` to be lexed next. Outside a nested lexing action Clang asserts
// `IsReinject`.
void clang_Preprocessor_EnterToken(CXPreprocessor PP, CXToken_ Tok, bool IsReinject);

// Replaces the cached tokens back to the last backtrack position with the annotation
// token `Tok`; a no-op when backtracking is not enabled. Precondition: `Tok` is an
// annotation token (`clang_Token_isAnnotation`); Clang asserts.
void clang_Preprocessor_AnnotateCachedTokens(CXPreprocessor PP, CXToken_ Tok);

// Precondition: at least one token has been cached — Clang asserts `CachedLexPos != 0`
// and the class exposes no accessor for that position, so the Julia wrapper documents the
// precondition instead of asserting it (MARSHALLING.md section 13).
CXSourceLocation_ clang_Preprocessor_getLastCachedTokenLocation(CXPreprocessor PP);

// Replaces only the most recent cached token with the annotation token `Tok`; a no-op
// when backtracking is not enabled. Precondition: `Tok` is an annotation token.
void clang_Preprocessor_ReplaceLastTokenWithAnnotation(CXPreprocessor PP, CXToken_ Tok);

// Truncates `File` at `Line`:`Column` (both 1-based) and makes that the code-completion
// point; returns true on error. Preconditions: `Line` and `Column` are non-zero and no
// code-completion point has been set yet (`clang_Preprocessor_isCodeCompletionEnabled`
// is false); Clang asserts both.
bool clang_Preprocessor_SetCodeCompletionPoint(CXPreprocessor PP, CXFileEntryRef File,
                                               unsigned Line, unsigned Column);

void clang_Preprocessor_SetPoisonReason(CXPreprocessor PP, CXIdentifierInfo II,
                                        unsigned DiagID);

// Precondition: `Identifier` carries an identifier info (`clang_Token_getIdentifierInfo`
// is non-NULL); Clang asserts. A diagnostic is reported only when it is poisoned.
void clang_Preprocessor_HandlePoisonedIdentifier(CXPreprocessor PP, CXToken_ Identifier);

// Null-safe: does nothing when `Identifier` carries no identifier info.
void clang_Preprocessor_MaybeHandlePoisonedIdentifier(CXPreprocessor PP,
                                                      CXToken_ Identifier);

void clang_Preprocessor_addMacroDeprecationMsg(CXPreprocessor PP, CXIdentifierInfo II,
                                               const char *Msg,
                                               CXSourceLocation_ AnnotationLoc);

void clang_Preprocessor_addRestrictExpansionMsg(CXPreprocessor PP, CXIdentifierInfo II,
                                                const char *Msg,
                                                CXSourceLocation_ AnnotationLoc);

void clang_Preprocessor_addFinalLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                    CXSourceLocation_ AnnotationLoc);

// The five readers below split `getMacroAnnotations(II)` into its parts. The `*Loc`
// variants return false, leaving `*Loc` untouched, when that annotation was never recorded
// for `II`; the `*Msg` variants return the empty string in the same case. PRECONDITION:
// `II` has a macro-annotation entry at all — the lookup is a `DenseMap::find(II)->second`
// with no end() check, so an identifier that was never annotated reads past the map.
// Clang's own gate for it is the identifier's annotation flags, which its pragma handlers
// set alongside the matching `clang_Preprocessor_add*` call; the Julia wrapper asserts on
// `clang_IdentifierInfo_isDeprecatedMacro` / `isRestrictExpansion` / `isFinal`.
bool clang_Preprocessor_getMacroDeprecationLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                               CXSourceLocation_ *Loc);

CXString clang_Preprocessor_getMacroDeprecationMsg(CXPreprocessor PP, CXIdentifierInfo II);

bool clang_Preprocessor_getMacroRestrictExpansionLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                     CXSourceLocation_ *Loc);

CXString clang_Preprocessor_getMacroRestrictExpansionMsg(CXPreprocessor PP,
                                                         CXIdentifierInfo II);

bool clang_Preprocessor_getMacroFinalAnnotationLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                   CXSourceLocation_ *Loc);

// Emits the deprecation, restricted-expansion and INFINITY/NAN warnings registered for
// the macro `Identifier` names. Precondition: `Identifier` carries an identifier info
// (`clang_Token_getIdentifierInfo` is non-NULL) — it is dereferenced unconditionally.
// `IsIfnDef` suppresses the INFINITY/NAN warnings, which do not apply to `#ifndef`.
void clang_Preprocessor_emitMacroExpansionWarnings(CXPreprocessor PP, CXToken_ Identifier,
                                                   bool IsIfnDef);

// Static: applies the `__FILE__` path transformations (`-ffile-prefix-map` remappings and
// the target's preferred path separators) to `Path` and returns the result.
CXString clang_Preprocessor_processPathForFileMacro(const char *Path,
                                                    CXLangOptions LangOpts,
                                                    CXTargetInfo_ TI);

LLVM_CLANG_C_EXTERN_C_END

#endif