#include "clang-ex/Lex/CXPreprocessor.h"
#include "utils.h"
#include "clang/Basic/Builtins.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Lex/PreprocessorLexer.h"
#include "clang/Basic/Module.h"
#include "clang/Lex/MacroInfo.h"
#include "llvm/ADT/SmallString.h"
#include "clang/Lex/Token.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileEntry.h"
#include "llvm/ADT/SmallVector.h"
#include <memory>
#include <string>

CXPreprocessorOptions clang_Preprocessor_getPreprocessorOpts(CXPreprocessor PP) {
  return reinterpret_cast<CXPreprocessorOptions>(&reinterpret_cast<clang::Preprocessor *>(PP)->getPreprocessorOpts());
}

unsigned clang_Preprocessor_getNumDirectives(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getNumDirectives();
}

bool clang_Preprocessor_isParsingIfOrElifDirective(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isParsingIfOrElifDirective();
}

void clang_Preprocessor_setPreprocessedOutput(CXPreprocessor PP,
                                              bool IsPreprocessedOutput) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPreprocessedOutput(IsPreprocessedOutput);
}

bool clang_Preprocessor_isPreprocessedOutput(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isPreprocessedOutput();
}

bool clang_Preprocessor_isInPrimaryFile(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isInPrimaryFile();
}

void clang_Preprocessor_overrideMaxTokens(CXPreprocessor PP, unsigned Value,
                                          CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->overrideMaxTokens(
      Value, clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_Preprocessor_getMaxTokensOverrideLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)->getMaxTokensOverrideLoc().getPtrEncoding());
}

unsigned clang_Preprocessor_getCounterValue(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getCounterValue();
}

void clang_Preprocessor_setCounterValue(CXPreprocessor PP, unsigned V) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCounterValue(V);
}

bool clang_Preprocessor_SawDateOrTime(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->SawDateOrTime();
}

size_t clang_Preprocessor_getTotalMemory(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getTotalMemory();
}

void clang_Preprocessor_EnableBacktrackAtThisPos(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->EnableBacktrackAtThisPos();
}

void clang_Preprocessor_CommitBacktrackedTokens(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->CommitBacktrackedTokens();
}

void clang_Preprocessor_Backtrack(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->Backtrack();
}

bool clang_Preprocessor_isBacktrackEnabled(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isBacktrackEnabled();
}

void clang_Preprocessor_SetMacroExpansionOnlyInDirectives(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->SetMacroExpansionOnlyInDirectives();
}

bool clang_Preprocessor_isInNamedModule(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isInNamedModule();
}

CXString clang_Preprocessor_getNamedModuleName(CXPreprocessor PP) {
  return extra::makeCXString(
      reinterpret_cast<clang::Preprocessor *>(PP)->getNamedModuleName().str());
}

CXMacroInfo clang_Preprocessor_getMacroInfoAtLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                 CXSourceLocation_ Loc) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getMacroDefinitionAtLoc(reinterpret_cast<clang::IdentifierInfo *>(II),
                                clang::SourceLocation::getFromPtrEncoding(Loc))
      .getMacroInfo());
}

CXDiagnosticsEngine clang_Preprocessor_getDiagnostics(CXPreprocessor PP) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::Preprocessor *>(PP)->getDiagnostics());
}

CXLangOptions clang_Preprocessor_getLangOpts(CXPreprocessor PP) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(
      &reinterpret_cast<clang::Preprocessor *>(PP)->getLangOpts()));
}

CXTargetInfo_ clang_Preprocessor_getTargetInfo(CXPreprocessor PP) {
  return reinterpret_cast<CXTargetInfo_>(const_cast<clang::TargetInfo *>(
      &reinterpret_cast<clang::Preprocessor *>(PP)->getTargetInfo()));
}

CXFileManager clang_Preprocessor_getFileManager(CXPreprocessor PP) {
  return reinterpret_cast<CXFileManager>(&reinterpret_cast<clang::Preprocessor *>(PP)->getFileManager());
}

CXSourceManager clang_Preprocessor_getSourceManager(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::Preprocessor *>(PP)->getSourceManager());
}

CXIdentifierTable clang_Preprocessor_getIdentifierTable(CXPreprocessor PP) {
  return reinterpret_cast<CXIdentifierTable>(&reinterpret_cast<clang::Preprocessor *>(PP)->getIdentifierTable());
}

CXSelectorTable clang_Preprocessor_getSelectorTable(CXPreprocessor PP) {
  return reinterpret_cast<CXSelectorTable>(&reinterpret_cast<clang::Preprocessor *>(PP)->getSelectorTable());
}

CXBuiltinContext clang_Preprocessor_getBuiltinInfo(CXPreprocessor PP) {
  return reinterpret_cast<CXBuiltinContext>(&reinterpret_cast<clang::Preprocessor *>(PP)->getBuiltinInfo());
}

void clang_Preprocessor_setExternalSource(CXPreprocessor PP,
                                          CXExternalPreprocessorSource Source) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setExternalSource(
      reinterpret_cast<clang::ExternalPreprocessorSource *>(Source));
}

CXExternalPreprocessorSource clang_Preprocessor_getExternalSource(CXPreprocessor PP) {
  return reinterpret_cast<CXExternalPreprocessorSource>(reinterpret_cast<clang::Preprocessor *>(PP)->getExternalSource());
}

CXModuleLoader clang_Preprocessor_getModuleLoader(CXPreprocessor PP) {
  return reinterpret_cast<CXModuleLoader>(&reinterpret_cast<clang::Preprocessor *>(PP)->getModuleLoader());
}

void clang_Preprocessor_SetCommentRetentionState(CXPreprocessor PP, bool KeepComments,
                                                 bool KeepMacroComments) {
  reinterpret_cast<clang::Preprocessor *>(PP)->SetCommentRetentionState(KeepComments,
                                                                   KeepMacroComments);
}

bool clang_Preprocessor_getCommentRetentionState(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getCommentRetentionState();
}

void clang_Preprocessor_setPragmasEnabled(CXPreprocessor PP, bool Enabled) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPragmasEnabled(Enabled);
}

bool clang_Preprocessor_getPragmasEnabled(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getPragmasEnabled();
}

CXFileID clang_Preprocessor_getPredefinesFileID(CXPreprocessor PP) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      reinterpret_cast<clang::Preprocessor *>(PP)->getPredefinesFileID());
  return reinterpret_cast<CXFileID>(ptr.release());
}

CXPPCallbacks clang_Preprocessor_getPPCallbacks(CXPreprocessor PP) {
  return reinterpret_cast<CXPPCallbacks>(reinterpret_cast<clang::Preprocessor *>(PP)->getPPCallbacks());
}

unsigned clang_Preprocessor_getTokenCount(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getTokenCount();
}

unsigned clang_Preprocessor_getMaxTokens(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getMaxTokens();
}

bool clang_Preprocessor_isMacroDefined(CXPreprocessor PP, const char *Id) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isMacroDefined(llvm::StringRef(Id));
}

bool clang_Preprocessor_isMacroDefinitionAmbiguous(CXPreprocessor PP, CXIdentifierInfo II) {
  return reinterpret_cast<clang::Preprocessor *>(PP)
      ->getMacroDefinition(reinterpret_cast<clang::IdentifierInfo *>(II))
      .isAmbiguous();
}

CXMacroInfo clang_Preprocessor_getMacroInfo(CXPreprocessor PP, CXIdentifierInfo II) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::Preprocessor *>(PP)->getMacroInfo(
      reinterpret_cast<clang::IdentifierInfo *>(II)));
}

bool clang_Preprocessor_isMacroDefinedInLocalModule(CXPreprocessor PP, CXIdentifierInfo II,
                                                    CXModule_ M) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isMacroDefinedInLocalModule(
      reinterpret_cast<clang::IdentifierInfo *>(II), reinterpret_cast<clang::Module *>(M));
}

CXMacroDirective clang_Preprocessor_getLocalMacroDirective(CXPreprocessor PP,
                                                           CXIdentifierInfo II) {
  return reinterpret_cast<CXMacroDirective>(reinterpret_cast<clang::Preprocessor *>(PP)->getLocalMacroDirective(
      reinterpret_cast<clang::IdentifierInfo *>(II)));
}

CXMacroDirective clang_Preprocessor_getLocalMacroDirectiveHistory(CXPreprocessor PP,
                                                                  CXIdentifierInfo II) {
  return reinterpret_cast<CXMacroDirective>(reinterpret_cast<clang::Preprocessor *>(PP)->getLocalMacroDirectiveHistory(
      reinterpret_cast<clang::IdentifierInfo *>(II)));
}

CXMacroDirective clang_Preprocessor_appendDefMacroDirective(CXPreprocessor PP,
                                                            CXIdentifierInfo II,
                                                            CXMacroInfo MI,
                                                            CXSourceLocation_ Loc) {
  return reinterpret_cast<CXMacroDirective>(reinterpret_cast<clang::Preprocessor *>(PP)->appendDefMacroDirective(
      reinterpret_cast<clang::IdentifierInfo *>(II), reinterpret_cast<clang::MacroInfo *>(MI),
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

CXModuleMacro clang_Preprocessor_addModuleMacro(CXPreprocessor PP, CXModule_ Mod,
                                                CXIdentifierInfo II, CXMacroInfo Macro,
                                                const CXModuleMacro *Overrides,
                                                unsigned NumOverrides, bool *IsNew) {
  llvm::SmallVector<clang::ModuleMacro *, 4> Ovr;
  Ovr.reserve(NumOverrides);
  for (unsigned I = 0; I != NumOverrides; ++I)
    Ovr.push_back(reinterpret_cast<clang::ModuleMacro *>(Overrides[I]));
  bool New = false;
  clang::ModuleMacro *MM = reinterpret_cast<clang::Preprocessor *>(PP)->addModuleMacro(
      reinterpret_cast<clang::Module *>(Mod), reinterpret_cast<clang::IdentifierInfo *>(II),
      reinterpret_cast<clang::MacroInfo *>(Macro), Ovr, New);
  if (IsNew)
    *IsNew = New;
  return reinterpret_cast<CXModuleMacro>(MM);
}

CXModuleMacro clang_Preprocessor_getModuleMacro(CXPreprocessor PP, CXModule_ Mod,
                                                CXIdentifierInfo II) {
  return reinterpret_cast<CXModuleMacro>(reinterpret_cast<clang::Preprocessor *>(PP)->getModuleMacro(
      reinterpret_cast<clang::Module *>(Mod), reinterpret_cast<clang::IdentifierInfo *>(II)));
}

unsigned clang_Preprocessor_getNumLeafModuleMacros(CXPreprocessor PP, CXIdentifierInfo II) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  return P->getLeafModuleMacros(reinterpret_cast<clang::IdentifierInfo *>(II)).size();
}

void clang_Preprocessor_getLeafModuleMacros(CXPreprocessor PP, CXIdentifierInfo II,
                                            CXModuleMacro *Buffer) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  unsigned I = 0;
  for (clang::ModuleMacro *MM :
       P->getLeafModuleMacros(reinterpret_cast<clang::IdentifierInfo *>(II)))
    Buffer[I++] = reinterpret_cast<CXModuleMacro>(MM);
}

unsigned clang_Preprocessor_getNumMacros(CXPreprocessor PP, bool IncludeExternalMacros) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  unsigned N = 0;
  for (auto It = P->macro_begin(IncludeExternalMacros),
            E = P->macro_end(IncludeExternalMacros);
       It != E; ++It)
    ++N;
  return N;
}

void clang_Preprocessor_getMacros(CXPreprocessor PP, bool IncludeExternalMacros,
                                  CXIdentifierInfo *Buffer) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  unsigned I = 0;
  for (auto It = P->macro_begin(IncludeExternalMacros),
            E = P->macro_end(IncludeExternalMacros);
       It != E; ++It)
    Buffer[I++] = reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(It->first));
}

unsigned clang_Preprocessor_getNumBuildingSubmodules(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getBuildingSubmodules().size();
}

void clang_Preprocessor_getBuildingSubmodules(CXPreprocessor PP, CXModule_ *Modules,
                                              CXSourceLocation_ *ImportLocs,
                                              bool *IsPragma) {
  auto Stack = reinterpret_cast<clang::Preprocessor *>(PP)->getBuildingSubmodules();
  for (unsigned I = 0, N = Stack.size(); I != N; ++I) {
    Modules[I] = reinterpret_cast<CXModule_>(Stack[I].M);
    ImportLocs[I] = reinterpret_cast<CXSourceLocation_>(Stack[I].ImportLoc.getPtrEncoding());
    IsPragma[I] = Stack[I].IsPragma;
  }
}

void clang_Preprocessor_markClangModuleAsAffecting(CXPreprocessor PP, CXModule_ M) {
  reinterpret_cast<clang::Preprocessor *>(PP)->markClangModuleAsAffecting(
      reinterpret_cast<clang::Module *>(M));
}

unsigned clang_Preprocessor_getNumAffectingClangModules(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getAffectingClangModules().size();
}

void clang_Preprocessor_getAffectingClangModules(CXPreprocessor PP, CXModule_ *Buffer) {
  const auto &Modules = reinterpret_cast<clang::Preprocessor *>(PP)->getAffectingClangModules();
  unsigned I = 0;
  for (clang::Module *M : Modules)
    Buffer[I++] = reinterpret_cast<CXModule_>(M);
}

unsigned clang_Preprocessor_getNumIncludedFiles(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getIncludedFiles().size();
}

void clang_Preprocessor_getIncludedFiles(CXPreprocessor PP, CXFileEntry *Buffer) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  unsigned I = 0;
  for (const clang::FileEntry *FE : P->getIncludedFiles())
    Buffer[I++] = reinterpret_cast<CXFileEntry>(const_cast<clang::FileEntry *>(FE));
}

CXString clang_Preprocessor_getLastMacroWithSpelling(CXPreprocessor PP,
                                                     CXSourceLocation_ Loc,
                                                     const unsigned *Kinds,
                                                     const CXIdentifierInfo *IIs,
                                                     unsigned NumTokens) {
  llvm::SmallVector<clang::TokenValue, 8> Values;
  Values.reserve(NumTokens);
  for (unsigned I = 0; I != NumTokens; ++I) {
    if (IIs[I])
      Values.push_back(clang::TokenValue(reinterpret_cast<clang::IdentifierInfo *>(IIs[I])));
    else
      Values.push_back(clang::TokenValue(static_cast<clang::tok::TokenKind>(Kinds[I])));
  }
  llvm::StringRef Name = reinterpret_cast<clang::Preprocessor *>(PP)->getLastMacroWithSpelling(
      clang::SourceLocation::getFromPtrEncoding(Loc), Values);
  return extra::makeCXString(Name.str());
}

CXPreprocessingRecord clang_Preprocessor_getPreprocessingRecord(CXPreprocessor PP) {
  return reinterpret_cast<CXPreprocessingRecord>(reinterpret_cast<clang::Preprocessor *>(PP)->getPreprocessingRecord());
}

void clang_Preprocessor_createPreprocessingRecord(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->createPreprocessingRecord();
}

void clang_Preprocessor_makeModuleVisible(CXPreprocessor PP, CXModule_ M,
                                          CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->makeModuleVisible(
      reinterpret_cast<clang::Module *>(M), clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_Preprocessor_getModuleImportLoc(CXPreprocessor PP, CXModule_ M) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getModuleImportLoc(reinterpret_cast<clang::Module *>(M))
      .getPtrEncoding());
}

CXString clang_Preprocessor_getPredefines(CXPreprocessor PP) {
  return extra::makeCXString(reinterpret_cast<clang::Preprocessor *>(PP)->getPredefines());
}

void clang_Preprocessor_setPredefines(CXPreprocessor PP, const char *P) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPredefines(std::string(P));
}

CXIdentifierInfo clang_Preprocessor_getIdentifierInfo(CXPreprocessor PP,
                                                      const char *Name) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Preprocessor *>(PP)->getIdentifierInfo(
      llvm::StringRef(Name)));
}

void clang_Preprocessor_Lex(CXPreprocessor PP, CXToken_ Result) {
  reinterpret_cast<clang::Preprocessor *>(PP)->Lex(*reinterpret_cast<clang::Token *>(Result));
}

void clang_Preprocessor_LexTokensUntilEOF(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->LexTokensUntilEOF();
}

CXString clang_Preprocessor_getSpelling(CXPreprocessor PP, CXToken_ Tok) {
  return extra::makeCXString(reinterpret_cast<clang::Preprocessor *>(PP)->getSpelling(
      *reinterpret_cast<clang::Token *>(Tok)));
}

CXHeaderSearch clang_Preprocessor_getHeaderSearchInfo(CXPreprocessor PP) {
  return reinterpret_cast<CXHeaderSearch>(&reinterpret_cast<clang::Preprocessor *>(PP)->getHeaderSearchInfo());
}

void clang_Preprocessor_initializeBuiltins(CXPreprocessor PP) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  P->getBuiltinInfo().initializeBuiltins(P->getIdentifierTable(), P->getLangOpts());
}

void clang_Preprocessor_EnterMainSourceFile(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->EnterMainSourceFile();
}

bool clang_Preprocessor_EnterSourceFile(CXPreprocessor PP, CXFileID FID,
                                        CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->EnterSourceFile(
      *reinterpret_cast<clang::FileID *>(FID), nullptr,
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Preprocessor_EndSourceFile(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->EndSourceFile();
}

void clang_Preprocessor_PrintStats(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->PrintStats();
}

void clang_Preprocessor_InitializeBuiltins(CXPreprocessor PP) {
  auto Prep = reinterpret_cast<clang::Preprocessor *>(PP);
  Prep->getBuiltinInfo().initializeBuiltins(Prep->getIdentifierTable(),
                                            Prep->getLangOpts());
}

void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->enableIncrementalProcessing();
}

bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isIncrementalProcessingEnabled();
}

void clang_Preprocessor_DumpToken(CXPreprocessor PP, CXToken_ Tok, bool DumpFlags) {
  reinterpret_cast<clang::Preprocessor *>(PP)->DumpToken(*reinterpret_cast<clang::Token *>(Tok),
                                                    DumpFlags);
}

void clang_Preprocessor_DumpLocation(CXPreprocessor PP, CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->DumpLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Preprocessor_DumpMacro(CXPreprocessor PP, CXMacroInfo MI) {
  reinterpret_cast<clang::Preprocessor *>(PP)->DumpMacro(*reinterpret_cast<clang::MacroInfo *>(MI));
}

void clang_Preprocessor_dumpMacroInfo(CXPreprocessor PP, CXIdentifierInfo II) {
  reinterpret_cast<clang::Preprocessor *>(PP)->dumpMacroInfo(
      reinterpret_cast<clang::IdentifierInfo *>(II));
}

bool clang_Preprocessor_hadModuleLoaderFatalFailure(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->hadModuleLoaderFatalFailure();
}

void clang_Preprocessor_SetSuppressIncludeNotFoundError(CXPreprocessor PP, bool Suppress) {
  reinterpret_cast<clang::Preprocessor *>(PP)->SetSuppressIncludeNotFoundError(Suppress);
}

bool clang_Preprocessor_GetSuppressIncludeNotFoundError(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->GetSuppressIncludeNotFoundError();
}

bool clang_Preprocessor_isPCHThroughHeader(CXPreprocessor PP, CXFileEntry FE) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isPCHThroughHeader(
      reinterpret_cast<const clang::FileEntry *>(FE));
}

bool clang_Preprocessor_creatingPCHWithThroughHeader(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->creatingPCHWithThroughHeader();
}

bool clang_Preprocessor_usingPCHWithThroughHeader(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->usingPCHWithThroughHeader();
}

bool clang_Preprocessor_creatingPCHWithPragmaHdrStop(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->creatingPCHWithPragmaHdrStop();
}

bool clang_Preprocessor_usingPCHWithPragmaHdrStop(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->usingPCHWithPragmaHdrStop();
}

void clang_Preprocessor_LexNonComment(CXPreprocessor PP, CXToken_ Result) {
  reinterpret_cast<clang::Preprocessor *>(PP)->LexNonComment(
      *reinterpret_cast<clang::Token *>(Result));
}

void clang_Preprocessor_LexUnexpandedToken(CXPreprocessor PP, CXToken_ Result) {
  reinterpret_cast<clang::Preprocessor *>(PP)->LexUnexpandedToken(
      *reinterpret_cast<clang::Token *>(Result));
}

void clang_Preprocessor_LexUnexpandedNonComment(CXPreprocessor PP, CXToken_ Result) {
  reinterpret_cast<clang::Preprocessor *>(PP)->LexUnexpandedNonComment(
      *reinterpret_cast<clang::Token *>(Result));
}

bool clang_Preprocessor_isCodeCompletionEnabled(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isCodeCompletionEnabled();
}

CXSourceLocation_ clang_Preprocessor_getCodeCompletionLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)->getCodeCompletionLoc().getPtrEncoding());
}

CXSourceLocation_ clang_Preprocessor_getCodeCompletionFileLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getCodeCompletionFileLoc()
      .getPtrEncoding());
}

bool clang_Preprocessor_isCodeCompletionReached(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isCodeCompletionReached();
}

bool clang_Preprocessor_getRawToken(CXPreprocessor PP, CXSourceLocation_ Loc,
                                    CXToken_ Result, bool IgnoreWhiteSpace) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getRawToken(
      clang::SourceLocation::getFromPtrEncoding(Loc), *reinterpret_cast<clang::Token *>(Result),
      IgnoreWhiteSpace);
}

CXSourceLocation_ clang_Preprocessor_getLocForEndOfToken(CXPreprocessor PP,
                                                         CXSourceLocation_ Loc,
                                                         unsigned Offset) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getLocForEndOfToken(clang::SourceLocation::getFromPtrEncoding(Loc), Offset)
      .getPtrEncoding());
}

CXModule_ clang_Preprocessor_getCurrentModule(CXPreprocessor PP) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentModule());
}

CXModule_ clang_Preprocessor_getCurrentModuleImplementation(CXPreprocessor PP) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentModuleImplementation());
}

bool clang_Preprocessor_isInNamedInterfaceUnit(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isInNamedInterfaceUnit();
}

bool clang_Preprocessor_isInImplementationUnit(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isInImplementationUnit();
}

CXTargetInfo_ clang_Preprocessor_getAuxTargetInfo(CXPreprocessor PP) {
  return reinterpret_cast<CXTargetInfo_>(const_cast<clang::TargetInfo *>(
      reinterpret_cast<clang::Preprocessor *>(PP)->getAuxTargetInfo()));
}

CXModule_ clang_Preprocessor_getCurrentLexerSubmodule(CXPreprocessor PP) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentLexerSubmodule());
}

void clang_Preprocessor_setCodeCompletionTokenRange(CXPreprocessor PP,
                                                    CXSourceLocation_ Start,
                                                    CXSourceLocation_ End) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCodeCompletionTokenRange(
      clang::SourceLocation::getFromPtrEncoding(Start),
      clang::SourceLocation::getFromPtrEncoding(End));
}

CXSourceRange_ clang_Preprocessor_getCodeCompletionTokenRange(CXPreprocessor PP) {
  auto R = reinterpret_cast<clang::Preprocessor *>(PP)->getCodeCompletionTokenRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_Preprocessor_mightHavePendingAnnotationTokens(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->mightHavePendingAnnotationTokens();
}

CXSourceLocation_ clang_Preprocessor_getPragmaAssumeNonNullLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getPragmaAssumeNonNullLoc()
      .getPtrEncoding());
}

void clang_Preprocessor_setPragmaAssumeNonNullLoc(CXPreprocessor PP,
                                                  CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPragmaAssumeNonNullLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_
clang_Preprocessor_getPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getPreambleRecordedPragmaAssumeNonNullLoc()
      .getPtrEncoding());
}

CXString clang_Preprocessor_getImmediateMacroName(CXPreprocessor PP,
                                                  CXSourceLocation_ Loc) {
  auto Name = reinterpret_cast<clang::Preprocessor *>(PP)->getImmediateMacroName(
      clang::SourceLocation::getFromPtrEncoding(Loc));
  return extra::makeCXString(Name.str());
}

bool clang_Preprocessor_isAtStartOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                  CXSourceLocation_ *MacroBegin) {
  clang::SourceLocation MB;
  bool Res = reinterpret_cast<clang::Preprocessor *>(PP)->isAtStartOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroBegin ? &MB : nullptr);
  if (Res && MacroBegin)
    *MacroBegin = reinterpret_cast<CXSourceLocation_>(MB.getPtrEncoding());
  return Res;
}

bool clang_Preprocessor_isAtEndOfMacroExpansion(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                CXSourceLocation_ *MacroEnd) {
  clang::SourceLocation ME;
  bool Res = reinterpret_cast<clang::Preprocessor *>(PP)->isAtEndOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroEnd ? &ME : nullptr);
  if (Res && MacroEnd)
    *MacroEnd = reinterpret_cast<CXSourceLocation_>(ME.getPtrEncoding());
  return Res;
}

CXSourceLocation_ clang_Preprocessor_AdvanceToTokenCharacter(CXPreprocessor PP,
                                                             CXSourceLocation_ TokStart,
                                                             unsigned Char) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->AdvanceToTokenCharacter(clang::SourceLocation::getFromPtrEncoding(TokStart), Char)
      .getPtrEncoding());
}

CXSourceLocation_ clang_Preprocessor_getLastFPEvalPragmaLocation(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getLastFPEvalPragmaLocation()
      .getPtrEncoding());
}

bool clang_Preprocessor_isInImportingCXXNamedModules(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isInImportingCXXNamedModules();
}

CXModule_ clang_Preprocessor_getModuleForLocation(CXPreprocessor PP, CXSourceLocation_ Loc,
                                                 bool AllowTextual) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Preprocessor *>(PP)->getModuleForLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc), AllowTextual));
}

bool clang_Preprocessor_checkModuleIsAvailable(CXLangOptions LangOpts, CXTargetInfo_ TI,
                                               CXModule_ M, CXDiagnosticsEngine Diags) {
  return clang::Preprocessor::checkModuleIsAvailable(
      *reinterpret_cast<clang::LangOptions *>(LangOpts), *reinterpret_cast<clang::TargetInfo *>(TI),
      *reinterpret_cast<clang::Module *>(M), *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

CXFileEntryRef clang_Preprocessor_getHeaderToIncludeForDiagnostics(CXPreprocessor PP,
                                                                   CXSourceLocation_ IncLoc,
                                                                   CXSourceLocation_ MLoc) {
  auto File = reinterpret_cast<clang::Preprocessor *>(PP)->getHeaderToIncludeForDiagnostics(
      clang::SourceLocation::getFromPtrEncoding(IncLoc),
      clang::SourceLocation::getFromPtrEncoding(MLoc));
  if (!File)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(std::make_unique<clang::FileEntryRef>(*File).release());
}

bool clang_Preprocessor_isRecordingPreamble(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isRecordingPreamble();
}

bool clang_Preprocessor_hasRecordedPreamble(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->hasRecordedPreamble();
}

unsigned clang_Preprocessor_getNumPreambleConditionals(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->getPreambleConditionalStack().size();
}

void clang_Preprocessor_getPreambleConditionalStack(CXPreprocessor PP,
                                                    CXSourceLocation_ *IfLocs,
                                                    bool *WasSkipping, bool *FoundNonSkip,
                                                    bool *FoundElse) {
  auto Stack = reinterpret_cast<clang::Preprocessor *>(PP)->getPreambleConditionalStack();
  for (unsigned I = 0, N = Stack.size(); I != N; ++I) {
    IfLocs[I] = reinterpret_cast<CXSourceLocation_>(Stack[I].IfLoc.getPtrEncoding());
    WasSkipping[I] = Stack[I].WasSkipping;
    FoundNonSkip[I] = Stack[I].FoundNonSkip;
    FoundElse[I] = Stack[I].FoundElse;
  }
}

void clang_Preprocessor_setRecordedPreambleConditionalStack(
    CXPreprocessor PP, const CXSourceLocation_ *IfLocs, const bool *WasSkipping,
    const bool *FoundNonSkip, const bool *FoundElse, unsigned N) {
  llvm::SmallVector<clang::PPConditionalInfo, 4> Stack;
  Stack.reserve(N);
  for (unsigned I = 0; I != N; ++I) {
    clang::PPConditionalInfo Info = {clang::SourceLocation::getFromPtrEncoding(IfLocs[I]),
                                     WasSkipping[I], FoundNonSkip[I], FoundElse[I]};
    Stack.push_back(Info);
  }
  reinterpret_cast<clang::Preprocessor *>(PP)->setRecordedPreambleConditionalStack(Stack);
}

bool clang_Preprocessor_getPreambleSkipInfo(CXPreprocessor PP,
                                            CXSourceLocation_ *HashTokenLoc,
                                            CXSourceLocation_ *IfTokenLoc,
                                            bool *FoundNonSkipPortion, bool *FoundElse,
                                            CXSourceLocation_ *ElseLoc) {
  auto Info = reinterpret_cast<clang::Preprocessor *>(PP)->getPreambleSkipInfo();
  if (!Info)
    return false;
  *HashTokenLoc = reinterpret_cast<CXSourceLocation_>(Info->HashTokenLoc.getPtrEncoding());
  *IfTokenLoc = reinterpret_cast<CXSourceLocation_>(Info->IfTokenLoc.getPtrEncoding());
  *FoundNonSkipPortion = Info->FoundNonSkipPortion;
  *FoundElse = Info->FoundElse;
  *ElseLoc = reinterpret_cast<CXSourceLocation_>(Info->ElseLoc.getPtrEncoding());
  return true;
}

bool clang_Preprocessor_isPPInSafeBufferOptOutRegion(CXPreprocessor PP) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isPPInSafeBufferOptOutRegion();
}

void clang_Preprocessor_setPreprocessToken(CXPreprocessor PP, bool Preprocess) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPreprocessToken(Preprocess);
}

void clang_Preprocessor_IgnorePragmas(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->IgnorePragmas();
}

void clang_Preprocessor_setEmptylineHandler(CXPreprocessor PP, CXEmptylineHandler Handler) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setEmptylineHandler(
      reinterpret_cast<clang::EmptylineHandler *>(Handler));
}

CXEmptylineHandler clang_Preprocessor_getEmptylineHandler(CXPreprocessor PP) {
  return reinterpret_cast<CXEmptylineHandler>(reinterpret_cast<clang::Preprocessor *>(PP)->getEmptylineHandler());
}

void clang_Preprocessor_setCodeCompletionHandler(CXPreprocessor PP,
                                                 CXCodeCompletionHandler Handler) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCodeCompletionHandler(
      *reinterpret_cast<clang::CodeCompletionHandler *>(Handler));
}

CXCodeCompletionHandler clang_Preprocessor_getCodeCompletionHandler(CXPreprocessor PP) {
  return reinterpret_cast<CXCodeCompletionHandler>(reinterpret_cast<clang::Preprocessor *>(PP)->getCodeCompletionHandler());
}

void clang_Preprocessor_clearCodeCompletionHandler(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->clearCodeCompletionHandler();
}

void clang_Preprocessor_recomputeCurLexerKind(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->recomputeCurLexerKind();
}

void clang_Preprocessor_setSkipMainFilePreamble(CXPreprocessor PP, unsigned Bytes,
                                                bool StartOfLine) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setSkipMainFilePreamble(Bytes, StartOfLine);
}

void clang_Preprocessor_IncrementPasteCounter(CXPreprocessor PP, bool IsFast) {
  reinterpret_cast<clang::Preprocessor *>(PP)->IncrementPasteCounter(IsFast);
}

void clang_Preprocessor_PoisonSEHIdentifiers(CXPreprocessor PP, bool Poison) {
  reinterpret_cast<clang::Preprocessor *>(PP)->PoisonSEHIdentifiers(Poison);
}

CXMacroInfo clang_Preprocessor_AllocateMacroInfo(CXPreprocessor PP, CXSourceLocation_ L) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::Preprocessor *>(PP)->AllocateMacroInfo(
      clang::SourceLocation::getFromPtrEncoding(L)));
}

void clang_Preprocessor_markMacroAsUsed(CXPreprocessor PP, CXMacroInfo MI) {
  reinterpret_cast<clang::Preprocessor *>(PP)->markMacroAsUsed(
      reinterpret_cast<clang::MacroInfo *>(MI));
}

bool clang_Preprocessor_isSafeBufferOptOut(CXPreprocessor PP, CXSourceManager SM,
                                           CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isSafeBufferOptOut(
      *reinterpret_cast<clang::SourceManager *>(SM),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Preprocessor_enterOrExitSafeBufferOptOutRegion(CXPreprocessor PP, bool IsEnter,
                                                          CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->enterOrExitSafeBufferOptOutRegion(
      IsEnter, clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Preprocessor_markIncluded(CXPreprocessor PP, CXFileEntryRef File) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->markIncluded(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

bool clang_Preprocessor_alreadyIncluded(CXPreprocessor PP, CXFileEntryRef File) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->alreadyIncluded(
      *reinterpret_cast<clang::FileEntryRef *>(File));
}

void clang_Preprocessor_setCodeCompletionIdentifierInfo(CXPreprocessor PP,
                                                        CXIdentifierInfo Filter) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCodeCompletionIdentifierInfo(
      reinterpret_cast<clang::IdentifierInfo *>(Filter));
}

CXString clang_Preprocessor_getCodeCompletionFilter(CXPreprocessor PP) {
  return extra::makeCXString(
      reinterpret_cast<clang::Preprocessor *>(PP)->getCodeCompletionFilter().str());
}

bool clang_Preprocessor_IsPreviousCachedToken(CXPreprocessor PP, CXToken_ Tok) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->IsPreviousCachedToken(
      *reinterpret_cast<clang::Token *>(Tok));
}

void clang_Preprocessor_TypoCorrectToken(CXPreprocessor PP, CXToken_ Tok) {
  reinterpret_cast<clang::Preprocessor *>(PP)->TypoCorrectToken(
      *reinterpret_cast<clang::Token *>(Tok));
}

void clang_Preprocessor_setCodeCompletionReached(CXPreprocessor PP) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCodeCompletionReached();
}

CXIdentifierInfo clang_Preprocessor_getPragmaARCCFCodeAuditedIdent(CXPreprocessor PP) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Preprocessor *>(PP)->getPragmaARCCFCodeAuditedInfo().first);
}

CXSourceLocation_ clang_Preprocessor_getPragmaARCCFCodeAuditedLoc(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getPragmaARCCFCodeAuditedInfo()
      .second.getPtrEncoding());
}

void clang_Preprocessor_setPragmaARCCFCodeAuditedInfo(CXPreprocessor PP,
                                                      CXIdentifierInfo Ident,
                                                      CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPragmaARCCFCodeAuditedInfo(
      reinterpret_cast<clang::IdentifierInfo *>(Ident),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Preprocessor_setPreambleRecordedPragmaAssumeNonNullLoc(CXPreprocessor PP,
                                                                  CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setPreambleRecordedPragmaAssumeNonNullLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

char clang_Preprocessor_getSpellingOfSingleCharacterNumericConstant(CXPreprocessor PP,
                                                                    CXToken_ Tok,
                                                                    bool *Invalid) {
  return reinterpret_cast<clang::Preprocessor *>(PP)
      ->getSpellingOfSingleCharacterNumericConstant(*reinterpret_cast<clang::Token *>(Tok),
                                                    Invalid);
}

void clang_Preprocessor_CreateString(CXPreprocessor PP, const char *Str, CXToken_ Tok,
                                     CXSourceLocation_ ExpansionLocStart,
                                     CXSourceLocation_ ExpansionLocEnd) {
  reinterpret_cast<clang::Preprocessor *>(PP)->CreateString(
      Str, *reinterpret_cast<clang::Token *>(Tok),
      clang::SourceLocation::getFromPtrEncoding(ExpansionLocStart),
      clang::SourceLocation::getFromPtrEncoding(ExpansionLocEnd));
}

CXSourceLocation_ clang_Preprocessor_SplitToken(CXPreprocessor PP, CXSourceLocation_ TokLoc,
                                                unsigned Length) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->SplitToken(clang::SourceLocation::getFromPtrEncoding(TokLoc), Length)
      .getPtrEncoding());
}

CXIdentifierInfo clang_Preprocessor_LookUpIdentifierInfo(CXPreprocessor PP,
                                                         CXToken_ Identifier) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Preprocessor *>(PP)->LookUpIdentifierInfo(
      *reinterpret_cast<clang::Token *>(Identifier)));
}

bool clang_Preprocessor_CheckMacroName(CXPreprocessor PP, CXToken_ MacroNameTok,
                                       CXMacroUse isDefineUndef, bool *ShadowFlag) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->CheckMacroName(
      *reinterpret_cast<clang::Token *>(MacroNameTok),
      static_cast<clang::MacroUse>(isDefineUndef), ShadowFlag);
}

CXFPEvalMethodKind clang_Preprocessor_getCurrentFPEvalMethod(CXPreprocessor PP) {
  return static_cast<CXFPEvalMethodKind>(
      reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentFPEvalMethod());
}

CXFPEvalMethodKind clang_Preprocessor_getTUFPEvalMethod(CXPreprocessor PP) {
  return static_cast<CXFPEvalMethodKind>(
      reinterpret_cast<clang::Preprocessor *>(PP)->getTUFPEvalMethod());
}

void clang_Preprocessor_setCurrentFPEvalMethod(CXPreprocessor PP,
                                               CXSourceLocation_ PragmaLoc,
                                               CXFPEvalMethodKind Val) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setCurrentFPEvalMethod(
      clang::SourceLocation::getFromPtrEncoding(PragmaLoc),
      static_cast<clang::LangOptions::FPEvalMethodKind>(Val));
}

void clang_Preprocessor_setTUFPEvalMethod(CXPreprocessor PP, CXFPEvalMethodKind Val) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setTUFPEvalMethod(
      static_cast<clang::LangOptions::FPEvalMethodKind>(Val));
}

CXString clang_Preprocessor_GetIncludeFilenameSpelling(CXPreprocessor PP,
                                                       CXSourceLocation_ Loc,
                                                       const char *Buffer, bool *IsAngled) {
  llvm::StringRef Filename(Buffer);
  bool Angled = reinterpret_cast<clang::Preprocessor *>(PP)->GetIncludeFilenameSpelling(
      clang::SourceLocation::getFromPtrEncoding(Loc), Filename);
  if (IsAngled)
    *IsAngled = Angled;
  return extra::makeCXString(Filename.str());
}

void clang_Preprocessor_setDiagnostics(CXPreprocessor PP, CXDiagnosticsEngine Diags) {
  reinterpret_cast<clang::Preprocessor *>(PP)->setDiagnostics(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

bool clang_Preprocessor_isCurrentLexer(CXPreprocessor PP, CXPreprocessorLexer L) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->isCurrentLexer(
      reinterpret_cast<clang::PreprocessorLexer *>(L));
}

CXPreprocessorLexer clang_Preprocessor_getCurrentLexer(CXPreprocessor PP) {
  return reinterpret_cast<CXPreprocessorLexer>(reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentLexer());
}

CXPreprocessorLexer clang_Preprocessor_getCurrentFileLexer(CXPreprocessor PP) {
  return reinterpret_cast<CXPreprocessorLexer>(reinterpret_cast<clang::Preprocessor *>(PP)->getCurrentFileLexer());
}

void clang_Preprocessor_LookAhead(CXPreprocessor PP, unsigned N, CXToken_ Result) {
  *reinterpret_cast<clang::Token *>(Result) =
      reinterpret_cast<clang::Preprocessor *>(PP)->LookAhead(N);
}

void clang_Preprocessor_RevertCachedTokens(CXPreprocessor PP, unsigned N) {
  reinterpret_cast<clang::Preprocessor *>(PP)->RevertCachedTokens(N);
}

void clang_Preprocessor_EnterToken(CXPreprocessor PP, CXToken_ Tok, bool IsReinject) {
  reinterpret_cast<clang::Preprocessor *>(PP)->EnterToken(*reinterpret_cast<clang::Token *>(Tok),
                                                     IsReinject);
}

void clang_Preprocessor_AnnotateCachedTokens(CXPreprocessor PP, CXToken_ Tok) {
  reinterpret_cast<clang::Preprocessor *>(PP)->AnnotateCachedTokens(
      *reinterpret_cast<clang::Token *>(Tok));
}

CXSourceLocation_ clang_Preprocessor_getLastCachedTokenLocation(CXPreprocessor PP) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Preprocessor *>(PP)
      ->getLastCachedTokenLocation()
      .getPtrEncoding());
}

void clang_Preprocessor_ReplaceLastTokenWithAnnotation(CXPreprocessor PP, CXToken_ Tok) {
  reinterpret_cast<clang::Preprocessor *>(PP)->ReplaceLastTokenWithAnnotation(
      *reinterpret_cast<clang::Token *>(Tok));
}

bool clang_Preprocessor_SetCodeCompletionPoint(CXPreprocessor PP, CXFileEntryRef File,
                                               unsigned Line, unsigned Column) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->SetCodeCompletionPoint(
      *reinterpret_cast<clang::FileEntryRef *>(File), Line, Column);
}

void clang_Preprocessor_SetPoisonReason(CXPreprocessor PP, CXIdentifierInfo II,
                                        unsigned DiagID) {
  reinterpret_cast<clang::Preprocessor *>(PP)->SetPoisonReason(
      reinterpret_cast<clang::IdentifierInfo *>(II), DiagID);
}

void clang_Preprocessor_HandlePoisonedIdentifier(CXPreprocessor PP, CXToken_ Identifier) {
  reinterpret_cast<clang::Preprocessor *>(PP)->HandlePoisonedIdentifier(
      *reinterpret_cast<clang::Token *>(Identifier));
}

void clang_Preprocessor_MaybeHandlePoisonedIdentifier(CXPreprocessor PP,
                                                      CXToken_ Identifier) {
  reinterpret_cast<clang::Preprocessor *>(PP)->MaybeHandlePoisonedIdentifier(
      *reinterpret_cast<clang::Token *>(Identifier));
}

void clang_Preprocessor_addMacroDeprecationMsg(CXPreprocessor PP, CXIdentifierInfo II,
                                               const char *Msg,
                                               CXSourceLocation_ AnnotationLoc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->addMacroDeprecationMsg(
      reinterpret_cast<clang::IdentifierInfo *>(II), std::string(Msg),
      clang::SourceLocation::getFromPtrEncoding(AnnotationLoc));
}

void clang_Preprocessor_addRestrictExpansionMsg(CXPreprocessor PP, CXIdentifierInfo II,
                                                const char *Msg,
                                                CXSourceLocation_ AnnotationLoc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->addRestrictExpansionMsg(
      reinterpret_cast<clang::IdentifierInfo *>(II), std::string(Msg),
      clang::SourceLocation::getFromPtrEncoding(AnnotationLoc));
}

void clang_Preprocessor_addFinalLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                    CXSourceLocation_ AnnotationLoc) {
  reinterpret_cast<clang::Preprocessor *>(PP)->addFinalLoc(
      reinterpret_cast<clang::IdentifierInfo *>(II),
      clang::SourceLocation::getFromPtrEncoding(AnnotationLoc));
}

bool clang_Preprocessor_getMacroDeprecationLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                               CXSourceLocation_ *Loc) {
  const auto &A = reinterpret_cast<clang::Preprocessor *>(PP)->getMacroAnnotations(
      reinterpret_cast<clang::IdentifierInfo *>(II));
  if (!A.DeprecationInfo)
    return false;
  if (Loc)
    *Loc = reinterpret_cast<CXSourceLocation_>(A.DeprecationInfo->Location.getPtrEncoding());
  return true;
}

CXString clang_Preprocessor_getMacroDeprecationMsg(CXPreprocessor PP, CXIdentifierInfo II) {
  const auto &A = reinterpret_cast<clang::Preprocessor *>(PP)->getMacroAnnotations(
      reinterpret_cast<clang::IdentifierInfo *>(II));
  if (!A.DeprecationInfo)
    return extra::makeCXString(std::string());
  return extra::makeCXString(A.DeprecationInfo->Message);
}

bool clang_Preprocessor_getMacroRestrictExpansionLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                     CXSourceLocation_ *Loc) {
  const auto &A = reinterpret_cast<clang::Preprocessor *>(PP)->getMacroAnnotations(
      reinterpret_cast<clang::IdentifierInfo *>(II));
  if (!A.RestrictExpansionInfo)
    return false;
  if (Loc)
    *Loc = reinterpret_cast<CXSourceLocation_>(A.RestrictExpansionInfo->Location.getPtrEncoding());
  return true;
}

CXString clang_Preprocessor_getMacroRestrictExpansionMsg(CXPreprocessor PP,
                                                         CXIdentifierInfo II) {
  const auto &A = reinterpret_cast<clang::Preprocessor *>(PP)->getMacroAnnotations(
      reinterpret_cast<clang::IdentifierInfo *>(II));
  if (!A.RestrictExpansionInfo)
    return extra::makeCXString(std::string());
  return extra::makeCXString(A.RestrictExpansionInfo->Message);
}

bool clang_Preprocessor_getMacroFinalAnnotationLoc(CXPreprocessor PP, CXIdentifierInfo II,
                                                   CXSourceLocation_ *Loc) {
  const auto &A = reinterpret_cast<clang::Preprocessor *>(PP)->getMacroAnnotations(
      reinterpret_cast<clang::IdentifierInfo *>(II));
  if (!A.FinalAnnotationLoc)
    return false;
  if (Loc)
    *Loc = reinterpret_cast<CXSourceLocation_>(A.FinalAnnotationLoc->getPtrEncoding());
  return true;
}

void clang_Preprocessor_emitMacroExpansionWarnings(CXPreprocessor PP, CXToken_ Identifier,
                                                   bool IsIfnDef) {
  reinterpret_cast<clang::Preprocessor *>(PP)->emitMacroExpansionWarnings(
      *reinterpret_cast<clang::Token *>(Identifier), IsIfnDef);
}

CXString clang_Preprocessor_processPathForFileMacro(const char *Path,
                                                    CXLangOptions LangOpts,
                                                    CXTargetInfo_ TI) {
  llvm::SmallString<128> Buffer(Path);
  clang::Preprocessor::processPathForFileMacro(Buffer,
                                               *reinterpret_cast<clang::LangOptions *>(LangOpts),
                                               *reinterpret_cast<clang::TargetInfo *>(TI));
  return extra::makeCXString(Buffer.str().str());
}

bool clang_Preprocessor_parseSimpleIntegerLiteral(CXPreprocessor PP, CXToken_ Tok,
                                                  uint64_t *Value) {
  return reinterpret_cast<clang::Preprocessor *>(PP)->parseSimpleIntegerLiteral(
      *reinterpret_cast<clang::Token *>(Tok), *Value);
}
