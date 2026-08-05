#include "clang-ex/Basic/CXSourceManager.h"
#include "clang/Basic/SourceManager.h"
#include "llvm/Support/MemoryBuffer.h"

CXDiagnosticsEngine clang_SourceManager_getDiagnostics(CXSourceManager SM) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::SourceManager *>(SM)->getDiagnostics());
}

CXFileManager clang_SourceManager_getFileManager(CXSourceManager SM) {
  return reinterpret_cast<CXFileManager>(&reinterpret_cast<clang::SourceManager *>(SM)->getFileManager());
}

void clang_SourceManager_setOverridenFilesKeepOriginalName(CXSourceManager SM, bool Value) {
  reinterpret_cast<clang::SourceManager *>(SM)->setOverridenFilesKeepOriginalName(Value);
}

bool clang_SourceManager_userFilesAreVolatile(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->userFilesAreVolatile();
}

void clang_SourceManager_clearIDTables(CXSourceManager SM) {
  reinterpret_cast<clang::SourceManager *>(SM)->clearIDTables();
}

void clang_SourceManager_initializeForReplay(CXSourceManager SM, CXSourceManager Old) {
  reinterpret_cast<clang::SourceManager *>(SM)->initializeForReplay(
      *reinterpret_cast<clang::SourceManager *>(Old));
}

unsigned clang_SourceManager_getModuleBuildStackSize(CXSourceManager SM) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::SourceManager *>(SM)->getModuleBuildStack().size());
}

const char *clang_SourceManager_getModuleBuildStackEntry(CXSourceManager SM, unsigned Index,
                                                         size_t *Length,
                                                         CXSourceLocation_ *ImportLoc) {
  const std::pair<std::string, clang::FullSourceLoc> &Entry =
      reinterpret_cast<clang::SourceManager *>(SM)->getModuleBuildStack()[Index];
  if (Length)
    *Length = Entry.first.size();
  if (ImportLoc)
    *ImportLoc = reinterpret_cast<CXSourceLocation_>(Entry.second.getPtrEncoding());
  return Entry.first.c_str();
}

void clang_SourceManager_pushModuleBuildStack(CXSourceManager SM, const char *ModuleName,
                                              CXSourceLocation_ ImportLoc) {
  clang::SourceManager *Mgr = reinterpret_cast<clang::SourceManager *>(SM);
  Mgr->pushModuleBuildStack(
      llvm::StringRef(ModuleName),
      clang::FullSourceLoc(clang::SourceLocation::getFromPtrEncoding(ImportLoc), *Mgr));
}

bool clang_SourceManager_isMainFile(CXSourceManager SM, CXFileEntry FE) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isMainFile(
      *reinterpret_cast<clang::FileEntry *>(FE));
}

CXFileID clang_SourceManager_getPreambleFileID(CXSourceManager SM) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      reinterpret_cast<clang::SourceManager *>(SM)->getPreambleFileID());
  return reinterpret_cast<CXFileID>(ptr.release());
}

void clang_SourceManager_setPreambleFileID(CXSourceManager SM, CXFileID Preamble) {
  reinterpret_cast<clang::SourceManager *>(SM)->setPreambleFileID(
      *reinterpret_cast<clang::FileID *>(Preamble));
}

CXFileID clang_SourceManager_getOrCreateFileID(CXSourceManager SM, CXFileEntryRef FER,
                                               CXCharacteristicKind FileCharacter) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      reinterpret_cast<clang::SourceManager *>(SM)->getOrCreateFileID(
          *reinterpret_cast<clang::FileEntryRef *>(FER),
          static_cast<clang::SrcMgr::CharacteristicKind>(FileCharacter)));
  return reinterpret_cast<CXFileID>(ptr.release());
}

CXSourceLocation_ clang_SourceManager_createMacroArgExpansionLoc(
    CXSourceManager SM, CXSourceLocation_ SpellingLoc, CXSourceLocation_ ExpansionLoc,
    unsigned Length) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->createMacroArgExpansionLoc(clang::SourceLocation::getFromPtrEncoding(SpellingLoc),
                                   clang::SourceLocation::getFromPtrEncoding(ExpansionLoc),
                                   Length)
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_createExpansionLoc(
    CXSourceManager SM, CXSourceLocation_ SpellingLoc, CXSourceLocation_ ExpansionLocStart,
    CXSourceLocation_ ExpansionLocEnd, unsigned Length, bool ExpansionIsTokenRange,
    int LoadedID, uint32_t LoadedOffset) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->createExpansionLoc(clang::SourceLocation::getFromPtrEncoding(SpellingLoc),
                           clang::SourceLocation::getFromPtrEncoding(ExpansionLocStart),
                           clang::SourceLocation::getFromPtrEncoding(ExpansionLocEnd),
                           Length, ExpansionIsTokenRange, LoadedID, LoadedOffset)
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_createTokenSplitLoc(CXSourceManager SM,
                                                          CXSourceLocation_ SpellingLoc,
                                                          CXSourceLocation_ TokenStart,
                                                          CXSourceLocation_ TokenEnd) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->createTokenSplitLoc(clang::SourceLocation::getFromPtrEncoding(SpellingLoc),
                            clang::SourceLocation::getFromPtrEncoding(TokenStart),
                            clang::SourceLocation::getFromPtrEncoding(TokenEnd))
      .getPtrEncoding());
}

const char *clang_SourceManager_getMemoryBufferDataForFileOrNone(CXSourceManager SM,
                                                                 CXFileEntryRef FER,
                                                                 size_t *Length) {
  std::optional<llvm::MemoryBufferRef> Buffer =
      reinterpret_cast<clang::SourceManager *>(SM)->getMemoryBufferForFileOrNone(
          *reinterpret_cast<clang::FileEntryRef *>(FER));
  if (!Buffer)
    return nullptr;
  if (Length)
    *Length = Buffer->getBufferSize();
  return Buffer->getBufferStart();
}

const char *clang_SourceManager_getMemoryBufferDataForFileOrFake(CXSourceManager SM,
                                                                 CXFileEntryRef FER,
                                                                 size_t *Length) {
  llvm::MemoryBufferRef Buffer =
      reinterpret_cast<clang::SourceManager *>(SM)->getMemoryBufferForFileOrFake(
          *reinterpret_cast<clang::FileEntryRef *>(FER));
  if (Length)
    *Length = Buffer.getBufferSize();
  return Buffer.getBufferStart();
}

bool clang_SourceManager_isFileOverridden(CXSourceManager SM, CXFileEntry FE) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isFileOverridden(
      reinterpret_cast<clang::FileEntry *>(FE));
}

CXFileEntryRef clang_SourceManager_bypassFileContentsOverride(CXSourceManager SM,
                                                              CXFileEntryRef FER) {
  clang::OptionalFileEntryRef Bypass =
      reinterpret_cast<clang::SourceManager *>(SM)->bypassFileContentsOverride(
          *reinterpret_cast<clang::FileEntryRef *>(FER));
  if (!Bypass)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(std::make_unique<clang::FileEntryRef>(*Bypass).release());
}

void clang_SourceManager_setFileIsTransient(CXSourceManager SM, CXFileEntryRef FER) {
  reinterpret_cast<clang::SourceManager *>(SM)->setFileIsTransient(
      *reinterpret_cast<clang::FileEntryRef *>(FER));
}

void clang_SourceManager_setAllFilesAreTransient(CXSourceManager SM, bool Transient) {
  reinterpret_cast<clang::SourceManager *>(SM)->setAllFilesAreTransient(Transient);
}

CXFileEntry clang_SourceManager_getFileEntryForID(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<CXFileEntry>(const_cast<clang::FileEntry *>(
      reinterpret_cast<clang::SourceManager *>(SM)->getFileEntryForID(
          *reinterpret_cast<clang::FileID *>(FID))));
}

CXFileEntryRef clang_SourceManager_getFileEntryRefForID(CXSourceManager SM, CXFileID FID) {
  clang::OptionalFileEntryRef Ref =
      reinterpret_cast<clang::SourceManager *>(SM)->getFileEntryRefForID(
          *reinterpret_cast<clang::FileID *>(FID));
  if (!Ref)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(std::make_unique<clang::FileEntryRef>(*Ref).release());
}

const char *clang_SourceManager_getNonBuiltinFilenameForID(CXSourceManager SM, CXFileID FID,
                                                           size_t *Length) {
  std::optional<llvm::StringRef> Name =
      reinterpret_cast<clang::SourceManager *>(SM)->getNonBuiltinFilenameForID(
          *reinterpret_cast<clang::FileID *>(FID));
  if (!Name)
    return nullptr;
  if (Length)
    *Length = Name->size();
  return Name->data();
}

CXFileEntry clang_SourceManager_getFileEntryForSLocEntry(CXSourceManager SM,
                                                         CXSLocEntry E) {
  return reinterpret_cast<CXFileEntry>(const_cast<clang::FileEntry *>(
      reinterpret_cast<clang::SourceManager *>(SM)->getFileEntryForSLocEntry(
          *reinterpret_cast<clang::SrcMgr::SLocEntry *>(E))));
}

const char *clang_SourceManager_getBufferData(CXSourceManager SM, CXFileID FID,
                                              size_t *Length, bool *Invalid) {
  llvm::StringRef Data = reinterpret_cast<clang::SourceManager *>(SM)->getBufferData(
      *reinterpret_cast<clang::FileID *>(FID), Invalid);
  if (Length)
    *Length = Data.size();
  return Data.data();
}

const char *clang_SourceManager_getBufferDataOrNone(CXSourceManager SM, CXFileID FID,
                                                    size_t *Length) {
  std::optional<llvm::StringRef> Data =
      reinterpret_cast<clang::SourceManager *>(SM)->getBufferDataOrNone(
          *reinterpret_cast<clang::FileID *>(FID));
  if (!Data)
    return nullptr;
  if (Length)
    *Length = Data->size();
  return Data->data();
}

const char *clang_SourceManager_getBufferDataOrFake(CXSourceManager SM, CXFileID FID,
                                                    CXSourceLocation_ Loc, size_t *Length) {
  llvm::MemoryBufferRef Buffer = reinterpret_cast<clang::SourceManager *>(SM)->getBufferOrFake(
      *reinterpret_cast<clang::FileID *>(FID), clang::SourceLocation::getFromPtrEncoding(Loc));
  if (Length)
    *Length = Buffer.getBufferSize();
  return Buffer.getBufferStart();
}

const char *clang_SourceManager_getBufferDataIfLoaded(CXSourceManager SM, CXFileID FID,
                                                      size_t *Length) {
  std::optional<llvm::StringRef> Data =
      reinterpret_cast<clang::SourceManager *>(SM)->getBufferDataIfLoaded(
          *reinterpret_cast<clang::FileID *>(FID));
  if (!Data)
    return nullptr;
  if (Length)
    *Length = Data->size();
  return Data->data();
}

unsigned clang_SourceManager_getNumCreatedFIDsForFileID(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getNumCreatedFIDsForFileID(
      *reinterpret_cast<clang::FileID *>(FID));
}

void clang_SourceManager_setNumCreatedFIDsForFileID(CXSourceManager SM, CXFileID FID,
                                                    unsigned NumFIDs, bool Force) {
  reinterpret_cast<clang::SourceManager *>(SM)->setNumCreatedFIDsForFileID(
      *reinterpret_cast<clang::FileID *>(FID), NumFIDs, Force);
}

CXFileID clang_SourceManager_getFileID(CXSourceManager SM, CXSourceLocation_ Loc) {
  std::unique_ptr<clang::FileID> ptr =
      std::make_unique<clang::FileID>(reinterpret_cast<clang::SourceManager *>(SM)->getFileID(
          clang::SourceLocation::getFromPtrEncoding(Loc)));
  return reinterpret_cast<CXFileID>(ptr.release());
}

const char *clang_SourceManager_getFilename(CXSourceManager SM, CXSourceLocation_ Loc,
                                            size_t *Length) {
  llvm::StringRef Name = reinterpret_cast<clang::SourceManager *>(SM)->getFilename(
      clang::SourceLocation::getFromPtrEncoding(Loc));
  if (Length)
    *Length = Name.size();
  return Name.data();
}

CXSourceLocation_ clang_SourceManager_getIncludeLoc(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getIncludeLoc(*reinterpret_cast<clang::FileID *>(FID))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getExpansionLoc(CXSourceManager SM,
                                                      CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getExpansionLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getFileLoc(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getFileLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getModuleImportLoc(CXSourceManager SM,
                                                         CXSourceLocation_ Loc,
                                                         const char **ModuleName,
                                                         size_t *NameLength) {
  std::pair<clang::SourceLocation, llvm::StringRef> Result =
      reinterpret_cast<clang::SourceManager *>(SM)->getModuleImportLoc(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (ModuleName)
    *ModuleName = Result.second.data();
  if (NameLength)
    *NameLength = Result.second.size();
  return reinterpret_cast<CXSourceLocation_>(Result.first.getPtrEncoding());
}

CXSourceRange_ clang_SourceManager_getImmediateExpansionRange(CXSourceManager SM,
                                                              CXSourceLocation_ Loc,
                                                              bool *IsTokenRange) {
  clang::CharSourceRange R =
      reinterpret_cast<clang::SourceManager *>(SM)->getImmediateExpansionRange(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (IsTokenRange)
    *IsTokenRange = R.isTokenRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceRange_ clang_SourceManager_getExpansionRange(CXSourceManager SM,
                                                     CXSourceLocation_ Loc,
                                                     bool *IsTokenRange) {
  clang::CharSourceRange R = reinterpret_cast<clang::SourceManager *>(SM)->getExpansionRange(
      clang::SourceLocation::getFromPtrEncoding(Loc));
  if (IsTokenRange)
    *IsTokenRange = R.isTokenRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceLocation_ clang_SourceManager_getSpellingLoc(CXSourceManager SM,
                                                     CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getSpellingLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getImmediateSpellingLoc(CXSourceManager SM,
                                                              CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getImmediateSpellingLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getComposedLoc(CXSourceManager SM, CXFileID FID,
                                                     unsigned Offset) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getComposedLoc(*reinterpret_cast<clang::FileID *>(FID), Offset)
      .getPtrEncoding());
}

CXFileID clang_SourceManager_getDecomposedLoc(CXSourceManager SM, CXSourceLocation_ Loc,
                                              unsigned *Offset) {
  std::pair<clang::FileID, unsigned> P =
      reinterpret_cast<clang::SourceManager *>(SM)->getDecomposedLoc(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (Offset)
    *Offset = P.second;
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(P.first).release());
}

CXFileID clang_SourceManager_getDecomposedExpansionLoc(CXSourceManager SM,
                                                       CXSourceLocation_ Loc,
                                                       unsigned *Offset) {
  std::pair<clang::FileID, unsigned> P =
      reinterpret_cast<clang::SourceManager *>(SM)->getDecomposedExpansionLoc(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (Offset)
    *Offset = P.second;
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(P.first).release());
}

CXFileID clang_SourceManager_getDecomposedSpellingLoc(CXSourceManager SM,
                                                      CXSourceLocation_ Loc,
                                                      unsigned *Offset) {
  std::pair<clang::FileID, unsigned> P =
      reinterpret_cast<clang::SourceManager *>(SM)->getDecomposedSpellingLoc(
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (Offset)
    *Offset = P.second;
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(P.first).release());
}

CXFileID clang_SourceManager_getDecomposedIncludedLoc(CXSourceManager SM, CXFileID FID,
                                                      unsigned *Offset) {
  std::pair<clang::FileID, unsigned> P =
      reinterpret_cast<clang::SourceManager *>(SM)->getDecomposedIncludedLoc(
          *reinterpret_cast<clang::FileID *>(FID));
  if (Offset)
    *Offset = P.second;
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(P.first).release());
}

unsigned clang_SourceManager_getFileOffset(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getFileOffset(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isMacroArgExpansion(CXSourceManager SM, CXSourceLocation_ Loc,
                                             CXSourceLocation_ *StartLoc) {
  clang::SourceLocation Start;
  bool Ret = reinterpret_cast<clang::SourceManager *>(SM)->isMacroArgExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), StartLoc ? &Start : nullptr);
  if (StartLoc)
    *StartLoc = reinterpret_cast<CXSourceLocation_>(Start.getPtrEncoding());
  return Ret;
}

bool clang_SourceManager_isMacroBodyExpansion(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isMacroBodyExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isAtStartOfImmediateMacroExpansion(CXSourceManager SM,
                                                            CXSourceLocation_ Loc,
                                                            CXSourceLocation_ *MacroBegin) {
  clang::SourceLocation Begin;
  bool Ret = reinterpret_cast<clang::SourceManager *>(SM)->isAtStartOfImmediateMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroBegin ? &Begin : nullptr);
  if (MacroBegin)
    *MacroBegin = reinterpret_cast<CXSourceLocation_>(Begin.getPtrEncoding());
  return Ret;
}

bool clang_SourceManager_isAtEndOfImmediateMacroExpansion(CXSourceManager SM,
                                                          CXSourceLocation_ Loc,
                                                          CXSourceLocation_ *MacroEnd) {
  clang::SourceLocation End;
  bool Ret = reinterpret_cast<clang::SourceManager *>(SM)->isAtEndOfImmediateMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc), MacroEnd ? &End : nullptr);
  if (MacroEnd)
    *MacroEnd = reinterpret_cast<CXSourceLocation_>(End.getPtrEncoding());
  return Ret;
}

bool clang_SourceManager_isInSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ Loc,
                                           CXSourceLocation_ Start, unsigned Length,
                                           uint32_t *RelativeOffset) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInSLocAddrSpace(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::SourceLocation::getFromPtrEncoding(Start), Length, RelativeOffset);
}

bool clang_SourceManager_isInSameSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ LHS,
                                               CXSourceLocation_ RHS,
                                               int32_t *RelativeOffset) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInSameSLocAddrSpace(
      clang::SourceLocation::getFromPtrEncoding(LHS),
      clang::SourceLocation::getFromPtrEncoding(RHS), RelativeOffset);
}

const char *clang_SourceManager_getCharacterData(CXSourceManager SM, CXSourceLocation_ Loc,
                                                 bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getCharacterData(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getColumnNumber(CXSourceManager SM, CXFileID FID,
                                             unsigned FilePos, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getColumnNumber(
      *reinterpret_cast<clang::FileID *>(FID), FilePos, Invalid);
}

unsigned clang_SourceManager_getSpellingColumnNumber(CXSourceManager SM,
                                                     CXSourceLocation_ Loc, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getSpellingColumnNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getExpansionColumnNumber(CXSourceManager SM,
                                                      CXSourceLocation_ Loc,
                                                      bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getExpansionColumnNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getPresumedColumnNumber(CXSourceManager SM,
                                                     CXSourceLocation_ Loc, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getPresumedColumnNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getLineNumber(CXSourceManager SM, CXFileID FID,
                                           unsigned FilePos, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getLineNumber(
      *reinterpret_cast<clang::FileID *>(FID), FilePos, Invalid);
}

unsigned clang_SourceManager_getSpellingLineNumber(CXSourceManager SM,
                                                   CXSourceLocation_ Loc, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getSpellingLineNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getExpansionLineNumber(CXSourceManager SM,
                                                    CXSourceLocation_ Loc, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getExpansionLineNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

unsigned clang_SourceManager_getPresumedLineNumber(CXSourceManager SM,
                                                   CXSourceLocation_ Loc, bool *Invalid) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getPresumedLineNumber(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
}

const char *clang_SourceManager_getBufferName(CXSourceManager SM, CXSourceLocation_ Loc,
                                              size_t *Length, bool *Invalid) {
  llvm::StringRef Name = reinterpret_cast<clang::SourceManager *>(SM)->getBufferName(
      clang::SourceLocation::getFromPtrEncoding(Loc), Invalid);
  if (Length)
    *Length = Name.size();
  return Name.data();
}

CXCharacteristicKind clang_SourceManager_getFileCharacteristic(CXSourceManager SM,
                                                               CXSourceLocation_ Loc) {
  return static_cast<CXCharacteristicKind>(
      reinterpret_cast<clang::SourceManager *>(SM)->getFileCharacteristic(
          clang::SourceLocation::getFromPtrEncoding(Loc)));
}

bool clang_SourceManager_getPresumedLoc(CXSourceManager SM, CXSourceLocation_ Loc,
                                        bool UseLineDirectives, const char **Filename,
                                        unsigned *Line, unsigned *Col,
                                        CXSourceLocation_ *IncludeLoc) {
  clang::PresumedLoc PLoc = reinterpret_cast<clang::SourceManager *>(SM)->getPresumedLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc), UseLineDirectives);
  if (PLoc.isInvalid())
    return false;
  if (Filename)
    *Filename = PLoc.getFilename();
  if (Line)
    *Line = PLoc.getLine();
  if (Col)
    *Col = PLoc.getColumn();
  if (IncludeLoc)
    *IncludeLoc = reinterpret_cast<CXSourceLocation_>(PLoc.getIncludeLoc().getPtrEncoding());
  return true;
}

bool clang_SourceManager_isInMainFile(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInMainFile(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isWrittenInSameFile(CXSourceManager SM, CXSourceLocation_ Loc1,
                                             CXSourceLocation_ Loc2) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isWrittenInSameFile(
      clang::SourceLocation::getFromPtrEncoding(Loc1),
      clang::SourceLocation::getFromPtrEncoding(Loc2));
}

bool clang_SourceManager_isWrittenInMainFile(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isWrittenInMainFile(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isWrittenInBuiltinFile(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isWrittenInBuiltinFile(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isWrittenInCommandLineFile(CXSourceManager SM,
                                                    CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isWrittenInCommandLineFile(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isWrittenInScratchSpace(CXSourceManager SM,
                                                 CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isWrittenInScratchSpace(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isInSystemHeader(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInSystemHeader(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isInExternCSystemHeader(CXSourceManager SM,
                                                 CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInExternCSystemHeader(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isInSystemMacro(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInSystemMacro(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

unsigned clang_SourceManager_getFileIDSize(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getFileIDSize(
      *reinterpret_cast<clang::FileID *>(FID));
}

bool clang_SourceManager_isInFileID(CXSourceManager SM, CXSourceLocation_ Loc, CXFileID FID,
                                    unsigned *RelativeOffset) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInFileID(
      clang::SourceLocation::getFromPtrEncoding(Loc), *reinterpret_cast<clang::FileID *>(FID),
      RelativeOffset);
}

unsigned clang_SourceManager_getLineTableFilenameID(CXSourceManager SM, const char *Str) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getLineTableFilenameID(
      llvm::StringRef(Str));
}

void clang_SourceManager_AddLineNote(CXSourceManager SM, CXSourceLocation_ Loc,
                                     unsigned LineNo, int FilenameID, bool IsFileEntry,
                                     bool IsFileExit, CXCharacteristicKind FileKind) {
  reinterpret_cast<clang::SourceManager *>(SM)->AddLineNote(
      clang::SourceLocation::getFromPtrEncoding(Loc), LineNo, FilenameID, IsFileEntry,
      IsFileExit, static_cast<clang::SrcMgr::CharacteristicKind>(FileKind));
}

bool clang_SourceManager_hasLineTable(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->hasLineTable();
}

size_t clang_SourceManager_getContentCacheSize(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getContentCacheSize();
}

void clang_SourceManager_getMemoryBufferSizes(CXSourceManager SM, size_t *MallocBytes,
                                              size_t *MmapBytes) {
  clang::SourceManager::MemoryBufferSizes Sizes =
      reinterpret_cast<clang::SourceManager *>(SM)->getMemoryBufferSizes();
  if (MallocBytes)
    *MallocBytes = Sizes.malloc_bytes;
  if (MmapBytes)
    *MmapBytes = Sizes.mmap_bytes;
}

size_t clang_SourceManager_getDataStructureSizes(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getDataStructureSizes();
}

CXSourceLocation_ clang_SourceManager_translateFileLineCol(CXSourceManager SM,
                                                           CXFileEntry FE, unsigned Line,
                                                           unsigned Col) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->translateFileLineCol(reinterpret_cast<clang::FileEntry *>(FE), Line, Col)
      .getPtrEncoding());
}

CXFileID clang_SourceManager_translateFile(CXSourceManager SM, CXFileEntry FE) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      reinterpret_cast<clang::SourceManager *>(SM)->translateFile(
          reinterpret_cast<clang::FileEntry *>(FE)));
  return reinterpret_cast<CXFileID>(ptr.release());
}

CXSourceLocation_ clang_SourceManager_translateLineCol(CXSourceManager SM, CXFileID FID,
                                                       unsigned Line, unsigned Col) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->translateLineCol(*reinterpret_cast<clang::FileID *>(FID), Line, Col)
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getMacroArgExpandedLocation(CXSourceManager SM,
                                                                  CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getMacroArgExpandedLocation(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

bool clang_SourceManager_isBeforeInTranslationUnit(CXSourceManager SM,
                                                   CXSourceLocation_ LHS,
                                                   CXSourceLocation_ RHS) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isBeforeInTranslationUnit(
      clang::SourceLocation::getFromPtrEncoding(LHS),
      clang::SourceLocation::getFromPtrEncoding(RHS));
}

bool clang_SourceManager_isInTheSameTranslationUnit(CXSourceManager SM, CXFileID LFID,
                                                    unsigned *LOffset, CXFileID RFID,
                                                    unsigned *ROffset,
                                                    bool *IsLHSBeforeRHS) {
  std::pair<clang::FileID, unsigned> LOffs(*reinterpret_cast<clang::FileID *>(LFID), *LOffset);
  std::pair<clang::FileID, unsigned> ROffs(*reinterpret_cast<clang::FileID *>(RFID), *ROffset);
  std::pair<bool, bool> R =
      reinterpret_cast<clang::SourceManager *>(SM)->isInTheSameTranslationUnit(LOffs, ROffs);
  *reinterpret_cast<clang::FileID *>(LFID) = LOffs.first;
  *LOffset = LOffs.second;
  *reinterpret_cast<clang::FileID *>(RFID) = ROffs.first;
  *ROffset = ROffs.second;
  if (IsLHSBeforeRHS)
    *IsLHSBeforeRHS = R.second;
  return R.first;
}

bool clang_SourceManager_isInTheSameTranslationUnitImpl(CXSourceManager SM, CXFileID LFID,
                                                        unsigned LOffset, CXFileID RFID,
                                                        unsigned ROffset) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isInTheSameTranslationUnitImpl(
      std::make_pair(*reinterpret_cast<clang::FileID *>(LFID), LOffset),
      std::make_pair(*reinterpret_cast<clang::FileID *>(RFID), ROffset));
}

bool clang_SourceManager_isBeforeInSLocAddrSpace(CXSourceManager SM, CXSourceLocation_ LHS,
                                                 CXSourceLocation_ RHS) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isBeforeInSLocAddrSpace(
      clang::SourceLocation::getFromPtrEncoding(LHS),
      clang::SourceLocation::getFromPtrEncoding(RHS));
}

bool clang_SourceManager_isPointWithin(CXSourceManager SM, CXSourceLocation_ Location,
                                       CXSourceLocation_ Start, CXSourceLocation_ End) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isPointWithin(
      clang::SourceLocation::getFromPtrEncoding(Location),
      clang::SourceLocation::getFromPtrEncoding(Start),
      clang::SourceLocation::getFromPtrEncoding(End));
}

unsigned clang_SourceManager_getNumFileInfos(CXSourceManager SM) {
  auto *Mgr = reinterpret_cast<clang::SourceManager *>(SM);
  unsigned N = 0;
  for (auto It = Mgr->fileinfo_begin(), End = Mgr->fileinfo_end(); It != End; ++It)
    ++N;
  return N;
}

void clang_SourceManager_getFileInfos(CXSourceManager SM, CXFileEntry *Files,
                                      CXContentCache *Caches) {
  auto *Mgr = reinterpret_cast<clang::SourceManager *>(SM);
  unsigned I = 0;
  for (auto It = Mgr->fileinfo_begin(), End = Mgr->fileinfo_end(); It != End; ++It, ++I) {
    if (Files)
      Files[I] = reinterpret_cast<CXFileEntry>(const_cast<clang::FileEntry *>(&It->first.getFileEntry()));
    if (Caches)
      Caches[I] = reinterpret_cast<CXContentCache>(It->second);
  }
}

bool clang_SourceManager_hasFileInfo(CXSourceManager SM, CXFileEntry File) {
  return reinterpret_cast<clang::SourceManager *>(SM)->hasFileInfo(
      reinterpret_cast<clang::FileEntry *>(File));
}

void clang_SourceManager_noteSLocAddressSpaceUsage(CXSourceManager SM,
                                                   CXDiagnosticsEngine Diag,
                                                   bool HasMaxNotes, unsigned MaxNotes) {
  reinterpret_cast<clang::SourceManager *>(SM)->noteSLocAddressSpaceUsage(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diag),
      HasMaxNotes ? std::optional<unsigned>(MaxNotes) : std::nullopt);
}

unsigned clang_SourceManager_local_sloc_entry_size(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->local_sloc_entry_size();
}

CXSLocEntry clang_SourceManager_getLocalSLocEntry(CXSourceManager SM, unsigned Index) {
  return reinterpret_cast<CXSLocEntry>(const_cast<clang::SrcMgr::SLocEntry *>(
      &reinterpret_cast<clang::SourceManager *>(SM)->getLocalSLocEntry(Index)));
}

unsigned clang_SourceManager_loaded_sloc_entry_size(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->loaded_sloc_entry_size();
}

CXSLocEntry clang_SourceManager_getLoadedSLocEntry(CXSourceManager SM, unsigned Index,
                                                   bool *Invalid) {
  return reinterpret_cast<CXSLocEntry>(const_cast<clang::SrcMgr::SLocEntry *>(
      &reinterpret_cast<clang::SourceManager *>(SM)->getLoadedSLocEntry(Index, Invalid)));
}

CXSLocEntry clang_SourceManager_getSLocEntry(CXSourceManager SM, CXFileID FID,
                                             bool *Invalid) {
  return reinterpret_cast<CXSLocEntry>(const_cast<clang::SrcMgr::SLocEntry *>(
      &reinterpret_cast<clang::SourceManager *>(SM)->getSLocEntry(
          *reinterpret_cast<clang::FileID *>(FID), Invalid)));
}

uint32_t clang_SourceManager_getNextLocalOffset(CXSourceManager SM) {
  return reinterpret_cast<clang::SourceManager *>(SM)->getNextLocalOffset();
}

bool clang_SourceManager_isLoadedSourceLocation(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isLoadedSourceLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isLocalSourceLocation(CXSourceManager SM, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isLocalSourceLocation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_SourceManager_isLoadedFileID(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isLoadedFileID(
      *reinterpret_cast<clang::FileID *>(FID));
}

bool clang_SourceManager_isLocalFileID(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<clang::SourceManager *>(SM)->isLocalFileID(
      *reinterpret_cast<clang::FileID *>(FID));
}

CXSourceLocation_ clang_SourceManager_getImmediateMacroCallerLoc(CXSourceManager SM,
                                                                 CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getImmediateMacroCallerLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getTopMacroCallerLoc(CXSourceManager SM,
                                                           CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getTopMacroCallerLoc(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

namespace {
// `clang::SrcMgr::LineOffsetMapping` keeps its offsets in a caller-supplied bump allocator,
// so the box owns the allocator the mapping points into.
struct LineOffsetMappingBox {
  llvm::BumpPtrAllocator Alloc;
  clang::SrcMgr::LineOffsetMapping Mapping;

  explicit LineOffsetMappingBox(llvm::MemoryBufferRef Buffer)
      : Mapping(clang::SrcMgr::LineOffsetMapping::get(Buffer, Alloc)) {}
};
} // namespace

CXLineOffsetMapping clang_LineOffsetMapping_create(const char *Buffer, size_t Length,
                                                   const char *BufferName) {
  return reinterpret_cast<CXLineOffsetMapping>(std::make_unique<LineOffsetMappingBox>(
             llvm::MemoryBufferRef(llvm::StringRef(Buffer, Length),
                                   llvm::StringRef(BufferName ? BufferName : "")))
      .release());
}

void clang_LineOffsetMapping_dispose(CXLineOffsetMapping M) {
  delete reinterpret_cast<LineOffsetMappingBox *>(M);
}

unsigned clang_LineOffsetMapping_size(CXLineOffsetMapping M) {
  return reinterpret_cast<LineOffsetMappingBox *>(M)->Mapping.size();
}

const unsigned *clang_LineOffsetMapping_getLines(CXLineOffsetMapping M, size_t *Length) {
  llvm::ArrayRef<unsigned> Lines =
      reinterpret_cast<LineOffsetMappingBox *>(M)->Mapping.getLines();
  if (Length)
    *Length = Lines.size();
  return Lines.data();
}

// SrcMgr::ContentCache

// getBufferOrNone

const char *clang_ContentCache_getBufferDataOrNone(CXContentCache CC,
                                                   CXDiagnosticsEngine Diag,
                                                   CXFileManager FileMgr,
                                                   CXSourceLocation_ Loc, size_t *Length) {
  std::optional<llvm::MemoryBufferRef> Buffer =
      reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getBufferOrNone(
          *reinterpret_cast<clang::DiagnosticsEngine *>(Diag),
          *reinterpret_cast<clang::FileManager *>(FileMgr),
          clang::SourceLocation::getFromPtrEncoding(Loc));
  if (!Buffer)
    return nullptr;
  if (Length)
    *Length = Buffer->getBufferSize();
  return Buffer->getBufferStart();
}

unsigned clang_ContentCache_getSize(CXContentCache CC) {
  return reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getSize();
}

unsigned clang_ContentCache_getSizeBytesMapped(CXContentCache CC) {
  return reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getSizeBytesMapped();
}

CXBufferKind clang_ContentCache_getMemoryBufferKind(CXContentCache CC) {
  return static_cast<CXBufferKind>(
      reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getMemoryBufferKind());
}

bool clang_ContentCache_isBufferLoaded(CXContentCache CC) {
  return reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getBufferIfLoaded().has_value();
}

const char *clang_ContentCache_getBufferDataIfLoaded(CXContentCache CC, size_t *Length) {
  std::optional<llvm::StringRef> Data =
      reinterpret_cast<clang::SrcMgr::ContentCache *>(CC)->getBufferDataIfLoaded();
  if (!Data)
    return nullptr;
  if (Length)
    *Length = Data->size();
  return Data->data();
}

// setBuffer
// setUnownedBuffer

const char *clang_ContentCache_getInvalidBOM(const char *Str, size_t Length) {
  return clang::SrcMgr::ContentCache::getInvalidBOM(llvm::StringRef(Str, Length));
}

CXSourceManager clang_SourceManager_create(CXDiagnosticsEngine Diag, CXFileManager FileMgr,
                                           bool UserFilesAreVolatile) {
  auto SM = std::make_unique<clang::SourceManager>(
      *(reinterpret_cast<clang::DiagnosticsEngine *>(Diag)),
      *(reinterpret_cast<clang::FileManager *>(FileMgr)), UserFilesAreVolatile);
  return reinterpret_cast<CXSourceManager>(SM.release());
}

void clang_SourceManager_dispose(CXSourceManager SM) {
  delete reinterpret_cast<clang::SourceManager *>(SM);
}

void clang_SourceManager_PrintStats(CXSourceManager SM) {
  reinterpret_cast<clang::SourceManager *>(SM)->PrintStats();
}

void clang_SourceManager_dump(CXSourceManager SM) {
  reinterpret_cast<clang::SourceManager *>(SM)->dump();
}

bool clang_FileID_isValid(CXFileID FID) {
  return reinterpret_cast<clang::FileID *>(FID)->isValid();
}

bool clang_FileID_isInvalid(CXFileID FID) {
  return reinterpret_cast<clang::FileID *>(FID)->isInvalid();
}

CXFileID clang_FileID_getSentinel(void) {
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(clang::FileID::getSentinel()).release());
}

unsigned clang_FileID_getHashValue(CXFileID FID) {
  return reinterpret_cast<clang::FileID *>(FID)->getHashValue();
}

void clang_FileID_dispose(CXFileID FID) { delete reinterpret_cast<clang::FileID *>(FID); }

CXFileID clang_SourceManager_createFileIDFromMemoryBuffer(CXSourceManager SM,
                                                          LLVMMemoryBufferRef MB) {
  std::unique_ptr<clang::FileID> ptr =
      std::make_unique<clang::FileID>(reinterpret_cast<clang::SourceManager *>(SM)->createFileID(
          std::unique_ptr<llvm::MemoryBuffer>(llvm::unwrap(MB)), clang::SrcMgr::C_User));
  return reinterpret_cast<CXFileID>(ptr.release());
}

CXFileID clang_SourceManager_createFileIDFromFileEntry(CXSourceManager SM,
                                                       CXFileEntryRef FER,
                                                       CXSourceLocation_ Loc) {
  std::unique_ptr<clang::FileID> ptr =
      std::make_unique<clang::FileID>(reinterpret_cast<clang::SourceManager *>(SM)->createFileID(
          *reinterpret_cast<clang::FileEntryRef *>(FER),
          clang::SourceLocation::getFromPtrEncoding(Loc), clang::SrcMgr::C_User));
  return reinterpret_cast<CXFileID>(ptr.release());
}

// this allocates because `static FileID get(int V)` is a private method and this is
// intended.
CXFileID clang_SourceManager_getMainFileID(CXSourceManager SM) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      reinterpret_cast<clang::SourceManager *>(SM)->getMainFileID());
  return reinterpret_cast<CXFileID>(ptr.release());
}

void clang_SourceManager_setMainFileID(CXSourceManager SM, CXFileID FID) {
  reinterpret_cast<clang::SourceManager *>(SM)->setMainFileID(
      *reinterpret_cast<clang::FileID *>(FID));
}

void clang_SourceManager_overrideFileContents(CXSourceManager SM, CXFileEntryRef FER,
                                              LLVMMemoryBufferRef MB) {
  reinterpret_cast<clang::SourceManager *>(SM)->overrideFileContents(
      *reinterpret_cast<clang::FileEntryRef *>(FER),
      std::unique_ptr<llvm::MemoryBuffer>(llvm::unwrap(MB)));
}

CXSourceLocation_ clang_SourceManager_getLocForStartOfFile(CXSourceManager SM,
                                                           CXFileID FID) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getLocForStartOfFile(*reinterpret_cast<clang::FileID *>(FID))
      .getPtrEncoding());
}

CXSourceLocation_ clang_SourceManager_getLocForEndOfFile(CXSourceManager SM, CXFileID FID) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceManager *>(SM)
      ->getLocForEndOfFile(*reinterpret_cast<clang::FileID *>(FID))
      .getPtrEncoding());
}
// SrcMgr::FileInfo

CXSourceLocation_ clang_FileInfo_getIncludeLoc(CXFileInfo FI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->getIncludeLoc().getPtrEncoding());
}

CXContentCache clang_FileInfo_getContentCache(CXFileInfo FI) {
  return reinterpret_cast<CXContentCache>(const_cast<clang::SrcMgr::ContentCache *>(
      &reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->getContentCache()));
}

CXCharacteristicKind clang_FileInfo_getFileCharacteristic(CXFileInfo FI) {
  return static_cast<CXCharacteristicKind>(
      reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->getFileCharacteristic());
}

bool clang_FileInfo_hasLineDirectives(CXFileInfo FI) {
  return reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->hasLineDirectives();
}

void clang_FileInfo_setHasLineDirectives(CXFileInfo FI) {
  reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->setHasLineDirectives();
}

const char *clang_FileInfo_getName(CXFileInfo FI, size_t *Length) {
  llvm::StringRef Name = reinterpret_cast<clang::SrcMgr::FileInfo *>(FI)->getName();
  if (Length)
    *Length = Name.size();
  return Name.data();
}

// SrcMgr::ExpansionInfo

CXSourceLocation_ clang_ExpansionInfo_getSpellingLoc(CXExpansionInfo EI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->getSpellingLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ExpansionInfo_getExpansionLocStart(CXExpansionInfo EI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)
      ->getExpansionLocStart()
      .getPtrEncoding());
}

CXSourceLocation_ clang_ExpansionInfo_getExpansionLocEnd(CXExpansionInfo EI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)
      ->getExpansionLocEnd()
      .getPtrEncoding());
}

bool clang_ExpansionInfo_isExpansionTokenRange(CXExpansionInfo EI) {
  return reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->isExpansionTokenRange();
}

CXSourceRange_ clang_ExpansionInfo_getExpansionLocRange(CXExpansionInfo EI,
                                                        bool *IsTokenRange) {
  clang::CharSourceRange R =
      reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->getExpansionLocRange();
  if (IsTokenRange)
    *IsTokenRange = R.isTokenRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_ExpansionInfo_isMacroArgExpansion(CXExpansionInfo EI) {
  return reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->isMacroArgExpansion();
}

bool clang_ExpansionInfo_isMacroBodyExpansion(CXExpansionInfo EI) {
  return reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->isMacroBodyExpansion();
}

bool clang_ExpansionInfo_isFunctionMacroExpansion(CXExpansionInfo EI) {
  return reinterpret_cast<clang::SrcMgr::ExpansionInfo *>(EI)->isFunctionMacroExpansion();
}

// SrcMgr::SLocEntry

uint32_t clang_SLocEntry_getOffset(CXSLocEntry E) {
  return reinterpret_cast<clang::SrcMgr::SLocEntry *>(E)->getOffset();
}

bool clang_SLocEntry_isExpansion(CXSLocEntry E) {
  return reinterpret_cast<clang::SrcMgr::SLocEntry *>(E)->isExpansion();
}

bool clang_SLocEntry_isFile(CXSLocEntry E) {
  return reinterpret_cast<clang::SrcMgr::SLocEntry *>(E)->isFile();
}

CXFileInfo clang_SLocEntry_getFile(CXSLocEntry E) {
  return reinterpret_cast<CXFileInfo>(const_cast<clang::SrcMgr::FileInfo *>(
      &reinterpret_cast<clang::SrcMgr::SLocEntry *>(E)->getFile()));
}

CXExpansionInfo clang_SLocEntry_getExpansion(CXSLocEntry E) {
  return reinterpret_cast<CXExpansionInfo>(const_cast<clang::SrcMgr::ExpansionInfo *>(
      &reinterpret_cast<clang::SrcMgr::SLocEntry *>(E)->getExpansion()));
}

namespace {
// `clang::SourceManagerForFile` stores only `StringRef`s of the name and content it is
// built from — the in-memory file system it creates wraps the content without copying it —
// so the box owns copies both outlive.
struct SourceManagerForFileBox {
  std::string FileName;
  std::string Content;
  clang::SourceManagerForFile SMF;

  SourceManagerForFileBox(llvm::StringRef Name, llvm::StringRef Text)
      : FileName(Name.str()), Content(Text.str()), SMF(FileName, Content) {}
};
} // namespace

CXSourceManagerForFile clang_SourceManagerForFile_create(const char *FileName,
                                                         size_t FileNameLength,
                                                         const char *Content,
                                                         size_t ContentLength) {
  return reinterpret_cast<CXSourceManagerForFile>(std::make_unique<SourceManagerForFileBox>(
             llvm::StringRef(FileName, FileNameLength),
             llvm::StringRef(Content, ContentLength))
      .release());
}

void clang_SourceManagerForFile_dispose(CXSourceManagerForFile SMF) {
  delete reinterpret_cast<SourceManagerForFileBox *>(SMF);
}

CXSourceManager clang_SourceManagerForFile_get(CXSourceManagerForFile SMF) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<SourceManagerForFileBox *>(SMF)->SMF.get());
}
