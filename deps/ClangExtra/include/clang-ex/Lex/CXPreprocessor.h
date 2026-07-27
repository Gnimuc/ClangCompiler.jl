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

CXDiagnosticsEngine clang_Preprocessor_getDiagnostics(CXPreprocessor PP);

CXLangOptions clang_Preprocessor_getLangOpts(CXPreprocessor PP);

CXTargetInfo_ clang_Preprocessor_getTargetInfo(CXPreprocessor PP);

CXFileManager clang_Preprocessor_getFileManager(CXPreprocessor PP);

CXSourceManager clang_Preprocessor_getSourceManager(CXPreprocessor PP);

CXIdentifierTable clang_Preprocessor_getIdentifierTable(CXPreprocessor PP);

void clang_Preprocessor_SetCommentRetentionState(CXPreprocessor PP, bool KeepComments,
                                                 bool KeepMacroComments);

bool clang_Preprocessor_getCommentRetentionState(CXPreprocessor PP);

void clang_Preprocessor_setPragmasEnabled(CXPreprocessor PP, bool Enabled);

bool clang_Preprocessor_getPragmasEnabled(CXPreprocessor PP);

// The returned FileID is heap-allocated; dispose with `clang_FileID_dispose`.
CXFileID clang_Preprocessor_getPredefinesFileID(CXPreprocessor PP);

unsigned clang_Preprocessor_getTokenCount(CXPreprocessor PP);

unsigned clang_Preprocessor_getMaxTokens(CXPreprocessor PP);

bool clang_Preprocessor_isMacroDefined(CXPreprocessor PP, const char *Id);

// Borrowed; NULL when `II` has no active macro definition.
CXMacroInfo clang_Preprocessor_getMacroInfo(CXPreprocessor PP, CXIdentifierInfo II);

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

bool clang_Preprocessor_creatingPCHWithThroughHeader(CXPreprocessor PP);

bool clang_Preprocessor_usingPCHWithThroughHeader(CXPreprocessor PP);

bool clang_Preprocessor_creatingPCHWithPragmaHdrStop(CXPreprocessor PP);

bool clang_Preprocessor_usingPCHWithPragmaHdrStop(CXPreprocessor PP);

// Lexes until a non-comment token is produced; `Result` is overwritten with it.
void clang_Preprocessor_LexNonComment(CXPreprocessor PP, CXToken_ Result);

void clang_Preprocessor_LexUnexpandedToken(CXPreprocessor PP, CXToken_ Result);

void clang_Preprocessor_LexUnexpandedNonComment(CXPreprocessor PP, CXToken_ Result);

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
CXModule clang_Preprocessor_getCurrentModule(CXPreprocessor PP);

// Borrowed; NULL unless a module implementation is currently being compiled.
CXModule clang_Preprocessor_getCurrentModuleImplementation(CXPreprocessor PP);

bool clang_Preprocessor_isInNamedInterfaceUnit(CXPreprocessor PP);

bool clang_Preprocessor_isInImplementationUnit(CXPreprocessor PP);

// Borrowed; NULL when there is no auxiliary target.
CXTargetInfo_ clang_Preprocessor_getAuxTargetInfo(CXPreprocessor PP);

// Borrowed; NULL when the current lexer is not in a submodule.
CXModule clang_Preprocessor_getCurrentLexerSubmodule(CXPreprocessor PP);

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
CXModule clang_Preprocessor_getModuleForLocation(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                 bool AllowTextual);

bool clang_Preprocessor_isRecordingPreamble(CXPreprocessor PP);

bool clang_Preprocessor_hasRecordedPreamble(CXPreprocessor PP);

bool clang_Preprocessor_isPPInSafeBufferOptOutRegion(CXPreprocessor PP);

void clang_Preprocessor_setPreprocessToken(CXPreprocessor PP, bool Preprocess);

void clang_Preprocessor_IgnorePragmas(CXPreprocessor PP);

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

LLVM_CLANG_C_EXTERN_C_END

#endif