#include "clang-ex/Lex/CXPreprocessor.h"
#include "utils.h"
#include "clang/Basic/Builtins.h"
#include "clang/Lex/Preprocessor.h"

CXPreprocessorOptions clang_Preprocessor_getPreprocessorOpts(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getPreprocessorOpts();
}

unsigned clang_Preprocessor_getNumDirectives(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getNumDirectives();
}

bool clang_Preprocessor_isParsingIfOrElifDirective(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isParsingIfOrElifDirective();
}

void clang_Preprocessor_setPreprocessedOutput(CXPreprocessor PP,
                                              bool IsPreprocessedOutput) {
  static_cast<clang::Preprocessor *>(PP)->setPreprocessedOutput(IsPreprocessedOutput);
}

bool clang_Preprocessor_isPreprocessedOutput(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isPreprocessedOutput();
}

bool clang_Preprocessor_isInPrimaryFile(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isInPrimaryFile();
}

void clang_Preprocessor_overrideMaxTokens(CXPreprocessor PP, unsigned Value,
                                          CXSourceLocation_ Loc) {
  static_cast<clang::Preprocessor *>(PP)->overrideMaxTokens(
      Value, clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_Preprocessor_getMaxTokensOverrideLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getMaxTokensOverrideLoc().getPtrEncoding();
}

unsigned clang_Preprocessor_getCounterValue(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCounterValue();
}

void clang_Preprocessor_setCounterValue(CXPreprocessor PP, unsigned V) {
  static_cast<clang::Preprocessor *>(PP)->setCounterValue(V);
}

bool clang_Preprocessor_SawDateOrTime(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->SawDateOrTime();
}

size_t clang_Preprocessor_getTotalMemory(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getTotalMemory();
}

void clang_Preprocessor_EnableBacktrackAtThisPos(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->EnableBacktrackAtThisPos();
}

void clang_Preprocessor_CommitBacktrackedTokens(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->CommitBacktrackedTokens();
}

void clang_Preprocessor_Backtrack(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->Backtrack();
}

bool clang_Preprocessor_isBacktrackEnabled(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isBacktrackEnabled();
}

void clang_Preprocessor_SetMacroExpansionOnlyInDirectives(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->SetMacroExpansionOnlyInDirectives();
}

bool clang_Preprocessor_isInNamedModule(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isInNamedModule();
}

CXString clang_Preprocessor_getNamedModuleName(CXPreprocessor PP) {
  return extra::makeCXString(
      static_cast<clang::Preprocessor *>(PP)->getNamedModuleName().str());
}

CXMacroInfo clang_Preprocessor_getMacroInfoAtLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                 CXSourceLocation_ Loc) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getMacroDefinitionAtLoc(static_cast<clang::IdentifierInfo *>(II),
                                clang::SourceLocation::getFromPtrEncoding(Loc))
      .getMacroInfo();
}

CXDiagnosticsEngine clang_Preprocessor_getDiagnostics(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getDiagnostics();
}

CXLangOptions clang_Preprocessor_getLangOpts(CXPreprocessor PP) {
  return const_cast<clang::LangOptions *>(
      &static_cast<clang::Preprocessor *>(PP)->getLangOpts());
}

CXTargetInfo_ clang_Preprocessor_getTargetInfo(CXPreprocessor PP) {
  return const_cast<clang::TargetInfo *>(
      &static_cast<clang::Preprocessor *>(PP)->getTargetInfo());
}

CXFileManager clang_Preprocessor_getFileManager(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getFileManager();
}

CXSourceManager clang_Preprocessor_getSourceManager(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getSourceManager();
}

CXIdentifierTable clang_Preprocessor_getIdentifierTable(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getIdentifierTable();
}

void clang_Preprocessor_SetCommentRetentionState(CXPreprocessor PP, bool KeepComments,
                                                 bool KeepMacroComments) {
  static_cast<clang::Preprocessor *>(PP)->SetCommentRetentionState(KeepComments,
                                                                   KeepMacroComments);
}

bool clang_Preprocessor_getCommentRetentionState(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCommentRetentionState();
}

void clang_Preprocessor_setPragmasEnabled(CXPreprocessor PP, bool Enabled) {
  static_cast<clang::Preprocessor *>(PP)->setPragmasEnabled(Enabled);
}

bool clang_Preprocessor_getPragmasEnabled(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getPragmasEnabled();
}

CXFileID clang_Preprocessor_getPredefinesFileID(CXPreprocessor PP) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      static_cast<clang::Preprocessor *>(PP)->getPredefinesFileID());
  return ptr.release();
}

unsigned clang_Preprocessor_getTokenCount(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getTokenCount();
}

unsigned clang_Preprocessor_getMaxTokens(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getMaxTokens();
}

bool clang_Preprocessor_isMacroDefined(CXPreprocessor PP, const char *Id) {
  return static_cast<clang::Preprocessor *>(PP)->isMacroDefined(llvm::StringRef(Id));
}

CXMacroInfo clang_Preprocessor_getMacroInfo(CXPreprocessor PP, CXIdentifierInfo II) {
  return static_cast<clang::Preprocessor *>(PP)->getMacroInfo(
      static_cast<clang::IdentifierInfo *>(II));
}

CXString clang_Preprocessor_getPredefines(CXPreprocessor PP) {
  return extra::makeCXString(static_cast<clang::Preprocessor *>(PP)->getPredefines());
}

void clang_Preprocessor_setPredefines(CXPreprocessor PP, const char *P) {
  static_cast<clang::Preprocessor *>(PP)->setPredefines(std::string(P));
}

CXIdentifierInfo clang_Preprocessor_getIdentifierInfo(CXPreprocessor PP,
                                                      const char *Name) {
  return static_cast<clang::Preprocessor *>(PP)->getIdentifierInfo(
      llvm::StringRef(Name));
}

void clang_Preprocessor_Lex(CXPreprocessor PP, CXToken_ Result) {
  static_cast<clang::Preprocessor *>(PP)->Lex(*static_cast<clang::Token *>(Result));
}

CXString clang_Preprocessor_getSpelling(CXPreprocessor PP, CXToken_ Tok) {
  return extra::makeCXString(static_cast<clang::Preprocessor *>(PP)->getSpelling(
      *static_cast<clang::Token *>(Tok)));
}

CXHeaderSearch clang_Preprocessor_getHeaderSearchInfo(CXPreprocessor PP) {
  return &static_cast<clang::Preprocessor *>(PP)->getHeaderSearchInfo();
}

void clang_Preprocessor_EnterMainSourceFile(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->EnterMainSourceFile();
}

bool clang_Preprocessor_EnterSourceFile(CXPreprocessor PP, CXFileID FID,
                                        CXSourceLocation_ Loc) {
  return static_cast<clang::Preprocessor *>(PP)->EnterSourceFile(
      *static_cast<clang::FileID *>(FID), nullptr,
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Preprocessor_EndSourceFile(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->EndSourceFile();
}

void clang_Preprocessor_PrintStats(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->PrintStats();
}

void clang_Preprocessor_InitializeBuiltins(CXPreprocessor PP) {
  auto Prep = static_cast<clang::Preprocessor *>(PP);
  Prep->getBuiltinInfo().initializeBuiltins(Prep->getIdentifierTable(),
                                            Prep->getLangOpts());
}

void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->enableIncrementalProcessing();
}

bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isIncrementalProcessingEnabled();
}

void clang_Preprocessor_DumpToken(CXPreprocessor PP, CXToken_ Tok, bool DumpFlags) {
  static_cast<clang::Preprocessor *>(PP)->DumpToken(*static_cast<clang::Token *>(Tok),
                                                    DumpFlags);
}

void clang_Preprocessor_DumpLocation(CXPreprocessor PP, CXSourceLocation_ Loc) {
  static_cast<clang::Preprocessor *>(PP)->DumpLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Preprocessor_hadModuleLoaderFatalFailure(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->hadModuleLoaderFatalFailure();
}

void clang_Preprocessor_SetSuppressIncludeNotFoundError(CXPreprocessor PP, bool Suppress) {
  static_cast<clang::Preprocessor *>(PP)->SetSuppressIncludeNotFoundError(Suppress);
}

bool clang_Preprocessor_GetSuppressIncludeNotFoundError(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->GetSuppressIncludeNotFoundError();
}

bool clang_Preprocessor_creatingPCHWithThroughHeader(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->creatingPCHWithThroughHeader();
}

bool clang_Preprocessor_usingPCHWithThroughHeader(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->usingPCHWithThroughHeader();
}

bool clang_Preprocessor_creatingPCHWithPragmaHdrStop(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->creatingPCHWithPragmaHdrStop();
}

bool clang_Preprocessor_usingPCHWithPragmaHdrStop(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->usingPCHWithPragmaHdrStop();
}

void clang_Preprocessor_LexNonComment(CXPreprocessor PP, CXToken_ Result) {
  static_cast<clang::Preprocessor *>(PP)->LexNonComment(
      *static_cast<clang::Token *>(Result));
}

void clang_Preprocessor_LexUnexpandedToken(CXPreprocessor PP, CXToken_ Result) {
  static_cast<clang::Preprocessor *>(PP)->LexUnexpandedToken(
      *static_cast<clang::Token *>(Result));
}

void clang_Preprocessor_LexUnexpandedNonComment(CXPreprocessor PP, CXToken_ Result) {
  static_cast<clang::Preprocessor *>(PP)->LexUnexpandedNonComment(
      *static_cast<clang::Token *>(Result));
}

bool clang_Preprocessor_isCodeCompletionEnabled(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isCodeCompletionEnabled();
}

CXSourceLocation_ clang_Preprocessor_getCodeCompletionLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCodeCompletionLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Preprocessor_getCodeCompletionFileLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getCodeCompletionFileLoc()
      .getPtrEncoding();
}

bool clang_Preprocessor_isCodeCompletionReached(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isCodeCompletionReached();
}

bool clang_Preprocessor_getRawToken(CXPreprocessor PP, CXSourceLocation_ Loc,
                                    CXToken_ Result, bool IgnoreWhiteSpace) {
  return static_cast<clang::Preprocessor *>(PP)->getRawToken(
      clang::SourceLocation::getFromPtrEncoding(Loc), *static_cast<clang::Token *>(Result),
      IgnoreWhiteSpace);
}

CXSourceLocation_ clang_Preprocessor_getLocForEndOfToken(CXPreprocessor PP,
                                                         CXSourceLocation_ Loc,
                                                         unsigned Offset) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getLocForEndOfToken(clang::SourceLocation::getFromPtrEncoding(Loc), Offset)
      .getPtrEncoding();
}

CXModule clang_Preprocessor_getCurrentModule(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCurrentModule();
}

CXModule clang_Preprocessor_getCurrentModuleImplementation(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCurrentModuleImplementation();
}

bool clang_Preprocessor_isInNamedInterfaceUnit(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isInNamedInterfaceUnit();
}

bool clang_Preprocessor_isInImplementationUnit(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isInImplementationUnit();
}

CXTargetInfo_ clang_Preprocessor_getAuxTargetInfo(CXPreprocessor PP) {
  return const_cast<clang::TargetInfo *>(
      static_cast<clang::Preprocessor *>(PP)->getAuxTargetInfo());
}

CXModule clang_Preprocessor_getCurrentLexerSubmodule(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getCurrentLexerSubmodule();
}

void clang_Preprocessor_setCodeCompletionTokenRange(CXPreprocessor PP,
                                                    CXSourceLocation_ Start,
                                                    CXSourceLocation_ End) {
  static_cast<clang::Preprocessor *>(PP)->setCodeCompletionTokenRange(
      clang::SourceLocation::getFromPtrEncoding(Start),
      clang::SourceLocation::getFromPtrEncoding(End));
}

CXSourceRange_ clang_Preprocessor_getCodeCompletionTokenRange(CXPreprocessor PP) {
  auto R = static_cast<clang::Preprocessor *>(PP)->getCodeCompletionTokenRange();
  CXSourceLocation_ B = R.getBegin().getPtrEncoding();
  CXSourceLocation_ E = R.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_Preprocessor_mightHavePendingAnnotationTokens(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->mightHavePendingAnnotationTokens();
}

CXSourceLocation_ clang_Preprocessor_getPragmaAssumeNonNullLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getPragmaAssumeNonNullLoc()
      .getPtrEncoding();
}

void clang_Preprocessor_setPragmaAssumeNonNullLoc(CXPreprocessor PP,
                                                  CXSourceLocation_ Loc) {
  static_cast<clang::Preprocessor *>(PP)->setPragmaAssumeNonNullLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_
clang_Preprocessor_getPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getPreambleRecordedPragmaAssumeNonNullLoc()
      .getPtrEncoding();
}

CXString clang_Preprocessor_getImmediateMacroName(CXPreprocessor PP,
                                                  CXSourceLocation_ Loc) {
  auto Name = static_cast<clang::Preprocessor *>(PP)->getImmediateMacroName(
      clang::SourceLocation::getFromPtrEncoding(Loc));
  return extra::makeCXString(Name.str());
}

bool clang_Preprocessor_isAtStartOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                  CXSourceLocation_ *MacroBegin) {
  clang::SourceLocation MB;
  bool Res = static_cast<clang::Preprocessor *>(PP)->isAtStartOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroBegin ? &MB : nullptr);
  if (Res && MacroBegin)
    *MacroBegin = MB.getPtrEncoding();
  return Res;
}

bool clang_Preprocessor_isAtEndOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                CXSourceLocation_ *MacroEnd) {
  clang::SourceLocation ME;
  bool Res = static_cast<clang::Preprocessor *>(PP)->isAtEndOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroEnd ? &ME : nullptr);
  if (Res && MacroEnd)
    *MacroEnd = ME.getPtrEncoding();
  return Res;
}

CXSourceLocation_ clang_Preprocessor_AdvanceToTokenCharacter(CXPreprocessor PP,
                                                             CXSourceLocation_ TokStart,
                                                             unsigned Char) {
  return static_cast<clang::Preprocessor *>(PP)
      ->AdvanceToTokenCharacter(clang::SourceLocation::getFromPtrEncoding(TokStart), Char)
      .getPtrEncoding();
}

CXSourceLocation_ clang_Preprocessor_getLastFPEvalPragmaLocation(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getLastFPEvalPragmaLocation()
      .getPtrEncoding();
}

bool clang_Preprocessor_isInImportingCXXNamedModules(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isInImportingCXXNamedModules();
}

CXModule clang_Preprocessor_getModuleForLocation(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                 bool AllowTextual) {
  return static_cast<clang::Preprocessor *>(PP)->getModuleForLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc), AllowTextual);
}

bool clang_Preprocessor_isRecordingPreamble(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isRecordingPreamble();
}

bool clang_Preprocessor_hasRecordedPreamble(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->hasRecordedPreamble();
}

bool clang_Preprocessor_isPPInSafeBufferOptOutRegion(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->isPPInSafeBufferOptOutRegion();
}

void clang_Preprocessor_setPreprocessToken(CXPreprocessor PP, bool Preprocess) {
  static_cast<clang::Preprocessor *>(PP)->setPreprocessToken(Preprocess);
}

void clang_Preprocessor_IgnorePragmas(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->IgnorePragmas();
}

void clang_Preprocessor_recomputeCurLexerKind(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->recomputeCurLexerKind();
}

void clang_Preprocessor_setSkipMainFilePreamble(CXPreprocessor PP, unsigned Bytes,
                                                bool StartOfLine) {
  static_cast<clang::Preprocessor *>(PP)->setSkipMainFilePreamble(Bytes, StartOfLine);
}

void clang_Preprocessor_IncrementPasteCounter(CXPreprocessor PP, bool IsFast) {
  static_cast<clang::Preprocessor *>(PP)->IncrementPasteCounter(IsFast);
}

void clang_Preprocessor_PoisonSEHIdentifiers(CXPreprocessor PP, bool Poison) {
  static_cast<clang::Preprocessor *>(PP)->PoisonSEHIdentifiers(Poison);
}

CXMacroInfo clang_Preprocessor_AllocateMacroInfo(CXPreprocessor PP, CXSourceLocation_ L) {
  return static_cast<clang::Preprocessor *>(PP)->AllocateMacroInfo(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_Preprocessor_markMacroAsUsed(CXPreprocessor PP, CXMacroInfo MI) {
  static_cast<clang::Preprocessor *>(PP)->markMacroAsUsed(
      static_cast<clang::MacroInfo *>(MI));
}

bool clang_Preprocessor_isSafeBufferOptOut(CXPreprocessor PP, CXSourceManager SM,
                                           CXSourceLocation_ Loc) {
  return static_cast<clang::Preprocessor *>(PP)->isSafeBufferOptOut(
      *static_cast<clang::SourceManager *>(SM),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Preprocessor_enterOrExitSafeBufferOptOutRegion(CXPreprocessor PP, bool IsEnter,
                                                          CXSourceLocation_ Loc) {
  return static_cast<clang::Preprocessor *>(PP)->enterOrExitSafeBufferOptOutRegion(
      IsEnter, clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Preprocessor_markIncluded(CXPreprocessor PP, CXFileEntryRef File) {
  return static_cast<clang::Preprocessor *>(PP)->markIncluded(
      *static_cast<clang::FileEntryRef *>(File));
}

bool clang_Preprocessor_alreadyIncluded(CXPreprocessor PP, CXFileEntryRef File) {
  return static_cast<clang::Preprocessor *>(PP)->alreadyIncluded(
      *static_cast<clang::FileEntryRef *>(File));
}

void clang_Preprocessor_setCodeCompletionIdentifierInfo(CXPreprocessor PP,
                                                        CXIdentifierInfo Filter) {
  static_cast<clang::Preprocessor *>(PP)->setCodeCompletionIdentifierInfo(
      static_cast<clang::IdentifierInfo *>(Filter));
}

CXString clang_Preprocessor_getCodeCompletionFilter(CXPreprocessor PP) {
  return extra::makeCXString(
      static_cast<clang::Preprocessor *>(PP)->getCodeCompletionFilter().str());
}

bool clang_Preprocessor_IsPreviousCachedToken(CXPreprocessor PP, CXToken_ Tok) {
  return static_cast<clang::Preprocessor *>(PP)->IsPreviousCachedToken(
      *static_cast<clang::Token *>(Tok));
}

void clang_Preprocessor_TypoCorrectToken(CXPreprocessor PP, CXToken_ Tok) {
  static_cast<clang::Preprocessor *>(PP)->TypoCorrectToken(
      *static_cast<clang::Token *>(Tok));
}

void clang_Preprocessor_setCodeCompletionReached(CXPreprocessor PP) {
  static_cast<clang::Preprocessor *>(PP)->setCodeCompletionReached();
}

CXIdentifierInfo clang_Preprocessor_getPragmaARCCFCodeAuditedIdent(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)->getPragmaARCCFCodeAuditedInfo().first;
}

CXSourceLocation_ clang_Preprocessor_getPragmaARCCFCodeAuditedLoc(CXPreprocessor PP) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getPragmaARCCFCodeAuditedInfo()
      .second.getPtrEncoding();
}

void clang_Preprocessor_setPragmaARCCFCodeAuditedInfo(CXPreprocessor PP,
                                                      CXIdentifierInfo Ident,
                                                      CXSourceLocation_ Loc) {
  static_cast<clang::Preprocessor *>(PP)->setPragmaARCCFCodeAuditedInfo(
      static_cast<clang::IdentifierInfo *>(Ident),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Preprocessor_setPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP,
                                                                  CXSourceLocation_ Loc) {
  static_cast<clang::Preprocessor *>(PP)->setPreambleRecordedPragmaAssumeNonNullLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

char clang_Preprocessor_getSpellingOfSingleCharacterNumericConstant(CXPreprocessor PP,
                                                                    CXToken_ Tok,
                                                                    bool *Invalid) {
  return static_cast<clang::Preprocessor *>(PP)
      ->getSpellingOfSingleCharacterNumericConstant(*static_cast<clang::Token *>(Tok),
                                                    Invalid);
}

void clang_Preprocessor_CreateString(CXPreprocessor PP, const char *Str, CXToken_ Tok,
                                     CXSourceLocation_ ExpansionLocStart,
                                     CXSourceLocation_ ExpansionLocEnd) {
  static_cast<clang::Preprocessor *>(PP)->CreateString(
      Str, *static_cast<clang::Token *>(Tok),
      clang::SourceLocation::getFromPtrEncoding(ExpansionLocStart),
      clang::SourceLocation::getFromPtrEncoding(ExpansionLocEnd));
}

CXSourceLocation_ clang_Preprocessor_SplitToken(CXPreprocessor PP, CXSourceLocation_ TokLoc,
                                                unsigned Length) {
  return static_cast<clang::Preprocessor *>(PP)
      ->SplitToken(clang::SourceLocation::getFromPtrEncoding(TokLoc), Length)
      .getPtrEncoding();
}

CXIdentifierInfo clang_Preprocessor_LookUpIdentifierInfo(CXPreprocessor PP,
                                                         CXToken_ Identifier) {
  return static_cast<clang::Preprocessor *>(PP)->LookUpIdentifierInfo(
      *static_cast<clang::Token *>(Identifier));
}

CXFPEvalMethodKind clang_Preprocessor_getCurrentFPEvalMethod(CXPreprocessor PP) {
  return static_cast<CXFPEvalMethodKind>(
      static_cast<clang::Preprocessor *>(PP)->getCurrentFPEvalMethod());
}

CXFPEvalMethodKind clang_Preprocessor_getTUFPEvalMethod(CXPreprocessor PP) {
  return static_cast<CXFPEvalMethodKind>(
      static_cast<clang::Preprocessor *>(PP)->getTUFPEvalMethod());
}

void clang_Preprocessor_setCurrentFPEvalMethod(CXPreprocessor PP,
                                               CXSourceLocation_ PragmaLoc,
                                               CXFPEvalMethodKind Val) {
  static_cast<clang::Preprocessor *>(PP)->setCurrentFPEvalMethod(
      clang::SourceLocation::getFromPtrEncoding(PragmaLoc),
      static_cast<clang::LangOptions::FPEvalMethodKind>(Val));
}

void clang_Preprocessor_setTUFPEvalMethod(CXPreprocessor PP, CXFPEvalMethodKind Val) {
  static_cast<clang::Preprocessor *>(PP)->setTUFPEvalMethod(
      static_cast<clang::LangOptions::FPEvalMethodKind>(Val));
}

CXString clang_Preprocessor_GetIncludeFilenameSpelling(CXPreprocessor PP,
                                                       CXSourceLocation_ Loc,
                                                       const char *Buffer, bool *IsAngled) {
  llvm::StringRef Filename(Buffer);
  bool Angled = static_cast<clang::Preprocessor *>(PP)->GetIncludeFilenameSpelling(
      clang::SourceLocation::getFromPtrEncoding(Loc), Filename);
  if (IsAngled)
    *IsAngled = Angled;
  return extra::makeCXString(Filename.str());
}
