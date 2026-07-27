#include "clang-ex/Lex/CXPreprocessor.h"
#include "utils.h"
#include "clang/Basic/Builtins.h"
#include "clang/Lex/Preprocessor.h"

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
