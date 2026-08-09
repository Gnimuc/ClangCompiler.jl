#include "clang-ex/Frontend/CXASTUnit.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclBase.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/ASTUnit.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/PCHContainerOperations.h"
#include "clang/Lex/HeaderSearchOptions.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Sema/Sema.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>

// Mirror sync for CXCaptureDiagsKind and CXASTUnit_WhatToLoad. It lives here rather than in lib/Basic/CXEnumSync.cpp
// because clang/Frontend/ASTUnit.h includes clang-c/Index.h, whose declarations collide
// with this library's own once the clang-ex headers that file gathers are also in scope.
#define ENUM_SYNC(cx, cpp)                                                                 \
  static_assert(static_cast<int>(cx) == static_cast<int>(cpp), #cx " != " #cpp)

ENUM_SYNC(CXCaptureDiagsKind_None, clang::CaptureDiagsKind::None);
ENUM_SYNC(CXCaptureDiagsKind_All, clang::CaptureDiagsKind::All);
ENUM_SYNC(CXCaptureDiagsKind_AllWithoutNonErrorsFromIncludes,
          clang::CaptureDiagsKind::AllWithoutNonErrorsFromIncludes);

ENUM_SYNC(CXASTUnit_LoadPreprocessorOnly, clang::ASTUnit::LoadPreprocessorOnly);
ENUM_SYNC(CXASTUnit_LoadASTOnly, clang::ASTUnit::LoadASTOnly);
ENUM_SYNC(CXASTUnit_LoadEverything, clang::ASTUnit::LoadEverything);

#undef ENUM_SYNC

bool clang_ASTUnit_isMainFileAST(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->isMainFileAST();
}

bool clang_ASTUnit_isUnsafeToFree(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->isUnsafeToFree();
}

void clang_ASTUnit_setUnsafeToFree(CXASTUnit AU, bool Value) {
  reinterpret_cast<clang::ASTUnit *>(AU)->setUnsafeToFree(Value);
}

// isUnsafeToFree
// setUnsafeToFree

CXDiagnosticsEngine clang_ASTUnit_getDiagnostics(CXASTUnit AU) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::ASTUnit *>(AU)->getDiagnostics());
}

CXSourceManager clang_ASTUnit_getSourceManager(CXASTUnit AU) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::ASTUnit *>(AU)->getSourceManager());
}

bool clang_ASTUnit_hasPreprocessor(CXASTUnit AU) {
  return static_cast<bool>(reinterpret_cast<clang::ASTUnit *>(AU)->getPreprocessorPtr());
}

CXPreprocessor clang_ASTUnit_getPreprocessor(CXASTUnit AU) {
  // Goes through getPreprocessorPtr rather than getPreprocessor: the latter returns *PP,
  // and a libstdc++ built with _GLIBCXX_ASSERTIONS aborts on dereferencing the null
  // shared_ptr a unit that has never parsed still holds.
  return reinterpret_cast<CXPreprocessor>(reinterpret_cast<clang::ASTUnit *>(AU)->getPreprocessorPtr().get());
}

// getPreprocessorPtr

CXASTContext clang_ASTUnit_getASTContext(CXASTUnit AU) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::ASTUnit *>(AU)->getASTContext());
}

void clang_ASTUnit_setASTContext(CXASTUnit AU, CXASTContext Ctx) {
  reinterpret_cast<clang::ASTUnit *>(AU)->setASTContext(reinterpret_cast<clang::ASTContext *>(Ctx));
}

// setPreprocessor
// enableSourceFileDiagnostics

bool clang_ASTUnit_hasSema(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->hasSema();
}

CXSema clang_ASTUnit_getSema(CXASTUnit AU) {
  return reinterpret_cast<CXSema>(&reinterpret_cast<clang::ASTUnit *>(AU)->getSema());
}

// getLangOpts
// getHeaderSearchOpts
// getPreprocessorOpts

CXFileManager clang_ASTUnit_getFileManager(CXASTUnit AU) {
  return reinterpret_cast<CXFileManager>(&reinterpret_cast<clang::ASTUnit *>(AU)->getFileManager());
}

CXFileSystemOptions clang_ASTUnit_getFileSystemOpts(CXASTUnit AU) {
  return reinterpret_cast<CXFileSystemOptions>(const_cast<clang::FileSystemOptions *>(
      &reinterpret_cast<clang::ASTUnit *>(AU)->getFileSystemOpts()));
}

// getFileSystemOpts
// getASTReader

CXString clang_ASTUnit_getOriginalSourceFileName(CXASTUnit AU) {
  return extra::makeCXString(
      reinterpret_cast<clang::ASTUnit *>(AU)->getOriginalSourceFileName().str());
}

// getASTMutationListener
// getDeserializationListener

bool clang_ASTUnit_getOnlyLocalDecls(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->getOnlyLocalDecls();
}

bool clang_ASTUnit_getOwnsRemappedFileBuffers(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->getOwnsRemappedFileBuffers();
}

void clang_ASTUnit_setOwnsRemappedFileBuffers(CXASTUnit AU, bool Value) {
  reinterpret_cast<clang::ASTUnit *>(AU)->setOwnsRemappedFileBuffers(Value);
}

CXString clang_ASTUnit_getMainFileName(CXASTUnit AU) {
  return extra::makeCXString(reinterpret_cast<clang::ASTUnit *>(AU)->getMainFileName().str());
}

// getASTFileName

// Top-level declarations
size_t clang_ASTUnit_top_level_size(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->top_level_size();
}

bool clang_ASTUnit_top_level_empty(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->top_level_empty();
}

CXDecl clang_ASTUnit_getTopLevelDecl(CXASTUnit AU, unsigned Index) {
  return reinterpret_cast<CXDecl>(*(reinterpret_cast<clang::ASTUnit *>(AU)->top_level_begin() + Index));
}

void clang_ASTUnit_addTopLevelDecl(CXASTUnit AU, CXDecl D) {
  reinterpret_cast<clang::ASTUnit *>(AU)->addTopLevelDecl(reinterpret_cast<clang::Decl *>(D));
}

// File-level declarations
void clang_ASTUnit_addFileLevelDecl(CXASTUnit AU, CXDecl D) {
  reinterpret_cast<clang::ASTUnit *>(AU)->addFileLevelDecl(reinterpret_cast<clang::Decl *>(D));
}

size_t clang_ASTUnit_getNumFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                           unsigned Length) {
  llvm::SmallVector<clang::Decl *, 8> Decls;
  reinterpret_cast<clang::ASTUnit *>(AU)->findFileRegionDecls(
      *reinterpret_cast<clang::FileID *>(File), Offset, Length, Decls);
  return Decls.size();
}

void clang_ASTUnit_findFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                       unsigned Length, CXDecl *Buf) {
  llvm::SmallVector<clang::Decl *, 8> Decls;
  reinterpret_cast<clang::ASTUnit *>(AU)->findFileRegionDecls(
      *reinterpret_cast<clang::FileID *>(File), Offset, Length, Decls);
  for (size_t I = 0; I < Decls.size(); ++I)
    Buf[I] = reinterpret_cast<CXDecl>(Decls[I]);
}

unsigned clang_ASTUnit_getCurrentTopLevelHashValue(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->getCurrentTopLevelHashValue();
}

void clang_ASTUnit_setCurrentTopLevelHashValue(CXASTUnit AU, unsigned Value) {
  reinterpret_cast<clang::ASTUnit *>(AU)->getCurrentTopLevelHashValue() = Value;
}

CXSourceLocation_ clang_ASTUnit_getLocation(CXASTUnit AU, CXFileEntry File, unsigned Line,
                                            unsigned Col) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTUnit *>(AU)
      ->getLocation(reinterpret_cast<const clang::FileEntry *>(File), Line, Col)
      .getPtrEncoding());
}

CXSourceLocation_ clang_ASTUnit_mapLocationFromPreamble(CXASTUnit AU,
                                                        CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTUnit *>(AU)
      ->mapLocationFromPreamble(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

CXSourceLocation_ clang_ASTUnit_mapLocationToPreamble(CXASTUnit AU, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTUnit *>(AU)
      ->mapLocationToPreamble(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding());
}

bool clang_ASTUnit_isInPreambleFileID(CXASTUnit AU, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->isInPreambleFileID(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_ASTUnit_isInMainFileID(CXASTUnit AU, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->isInMainFileID(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_ASTUnit_getStartOfMainFileID(CXASTUnit AU) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTUnit *>(AU)->getStartOfMainFileID().getPtrEncoding());
}

CXSourceLocation_ clang_ASTUnit_getEndOfPreambleFileID(CXASTUnit AU) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ASTUnit *>(AU)->getEndOfPreambleFileID().getPtrEncoding());
}

CXSourceRange_ clang_ASTUnit_mapRangeFromPreamble(CXASTUnit AU, CXSourceRange_ R) {
  auto Rng = reinterpret_cast<clang::ASTUnit *>(AU)->mapRangeFromPreamble(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(Rng.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(Rng.getEnd().getPtrEncoding())};
}

CXSourceRange_ clang_ASTUnit_mapRangeToPreamble(CXASTUnit AU, CXSourceRange_ R) {
  auto Rng = reinterpret_cast<clang::ASTUnit *>(AU)->mapRangeToPreamble(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(Rng.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(Rng.getEnd().getPtrEncoding())};
}

unsigned clang_ASTUnit_getPreambleCounterForTests(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->getPreambleCounterForTests();
}

size_t clang_ASTUnit_stored_diag_size(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->stored_diag_size();
}

CXStoredDiagnostic clang_ASTUnit_getStoredDiagnostic(CXASTUnit AU, unsigned Index) {
  return reinterpret_cast<CXStoredDiagnostic>(reinterpret_cast<clang::ASTUnit *>(AU)->stored_diag_begin() + Index);
}

size_t clang_ASTUnit_stored_diag_afterDriver_index(CXASTUnit AU) {
  auto *Unit = reinterpret_cast<clang::ASTUnit *>(AU);
  return static_cast<size_t>(Unit->stored_diag_afterDriver_begin() -
                             Unit->stored_diag_begin());
}

size_t clang_ASTUnit_cached_completion_size(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->cached_completion_size();
}

// visitLocalTopLevelDecls

CXFileEntryRef clang_ASTUnit_getPCHFile(CXASTUnit AU) {
  clang::OptionalFileEntryRef Ref = reinterpret_cast<clang::ASTUnit *>(AU)->getPCHFile();
  if (!Ref)
    return nullptr;
  return reinterpret_cast<CXFileEntryRef>(std::make_unique<clang::FileEntryRef>(*Ref).release());
}

bool clang_ASTUnit_isModuleFile(CXASTUnit AU) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->isModuleFile();
}

LLVMMemoryBufferRef clang_ASTUnit_getBufferForFile(CXASTUnit AU, const char *Filename) {
  std::string Err;
  auto Buffer =
      reinterpret_cast<clang::ASTUnit *>(AU)->getBufferForFile(llvm::StringRef(Filename), &Err);
  if (!Buffer) {
    llvm::errs() << "Cannot get buffer for file. Error: " << Err << "\n";
    return nullptr;
  }
  return llvm::wrap(Buffer.release());
}

CXTranslationUnitKind clang_ASTUnit_getTranslationUnitKind(CXASTUnit AU) {
  return static_cast<CXTranslationUnitKind>(
      reinterpret_cast<clang::ASTUnit *>(AU)->getTranslationUnitKind());
}

// addFileLevelDecl
// findFileRegionDecls
// getLocation
// mapLocationFromPreamble
// mapLocationToPreamble
// mapRangeFromPreamble
// mapRangeToPreamble
// getStartOfMainFileID
// getEndOfPreambleFileID
// isInMainFileID
// isInPreambleFileID
// visitLocalTopLevelDecls
// getPCHFile
// isModuleFile
// getBufferForFile
// getTranslationUnitKind
// getInputKind

CXASTUnit clang_ASTUnit_create(CXCompilerInvocation CI, CXDiagnosticsEngine Diags,
                               CXCaptureDiagsKind CaptureDiagnostics,
                               bool UserFilesAreVolatile) {
  auto *DE = reinterpret_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  auto AU = clang::ASTUnit::create(std::shared_ptr<clang::CompilerInvocation>(
                                       reinterpret_cast<clang::CompilerInvocation *>(CI)),
                                   llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE),
                                   static_cast<clang::CaptureDiagsKind>(CaptureDiagnostics),
                                   UserFilesAreVolatile);
  return reinterpret_cast<CXASTUnit>(AU.release());
}

void clang_ASTUnit_dispose(CXASTUnit AU) { delete reinterpret_cast<clang::ASTUnit *>(AU); }

CXASTUnit clang_ASTUnit_LoadFromASTFile(const char *Filename, CXASTUnit_WhatToLoad ToLoad,
                                        CXDiagnosticsEngine Diags,
                                        CXFileSystemOptions FileSystemOpts,
                                        CXHeaderSearchOptions HSOpts, bool OnlyLocalDecls,
                                        CXCaptureDiagsKind CaptureDiagnostics,
                                        bool AllowASTWithCompilerErrors,
                                        bool UserFilesAreVolatile) {
  auto *DE = reinterpret_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  clang::FileSystemOptions FSOpts =
      FileSystemOpts ? *reinterpret_cast<clang::FileSystemOptions *>(FileSystemOpts)
                     : clang::FileSystemOptions();
  auto HS = HSOpts ? std::make_shared<clang::HeaderSearchOptions>(
                         *reinterpret_cast<clang::HeaderSearchOptions *>(HSOpts))
                   : std::make_shared<clang::HeaderSearchOptions>();
  // ASTReader stores this BY REFERENCE (Serialization/ASTReader.h: `const
  // PCHContainerReader &PCHContainerRdr;`) and the unit owns that reader for its whole
  // life, consulting it on every lazy deserialization -- so a function-local would dangle
  // the moment this returns. RawPCHContainerReader is stateless, so one shared instance
  // with static lifetime is the whole fix.
  static const clang::RawPCHContainerReader Reader;
  auto AU = clang::ASTUnit::LoadFromASTFile(
      std::string(Filename), Reader, static_cast<clang::ASTUnit::WhatToLoad>(ToLoad),
      llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE), FSOpts, HS, OnlyLocalDecls,
      static_cast<clang::CaptureDiagsKind>(CaptureDiagnostics), AllowASTWithCompilerErrors,
      UserFilesAreVolatile);
  return reinterpret_cast<CXASTUnit>(AU.release());
}

// LoadFromCompilerInvocationAction

CXASTUnit clang_ASTUnit_LoadFromCompilerInvocation(
    CXCompilerInvocation CI, CXDiagnosticsEngine Diags, CXFileManager FileMgr,
    bool OnlyLocalDecls, CXCaptureDiagsKind CaptureDiagnostics,
    unsigned PrecompilePreambleAfterNParses, CXTranslationUnitKind TUKind,
    bool CacheCodeCompletionResults, bool IncludeBriefCommentsInCodeCompletion,
    bool UserFilesAreVolatile) {
  // Both objects land in an IntrusiveRefCntPtr member of the unit, while the C surface
  // hands them over as caller-owned raw pointers it never refcounts, so each is pinned
  // with an explicit Retain first (MARSHALLING.md section 12): without it the unit's
  // release drops the last reference and deletes an object the caller still disposes.
  auto *DE = reinterpret_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  auto *FM = reinterpret_cast<clang::FileManager *>(FileMgr);
  FM->Retain();
  auto AU = clang::ASTUnit::LoadFromCompilerInvocation(
      std::shared_ptr<clang::CompilerInvocation>(
          reinterpret_cast<clang::CompilerInvocation *>(CI)),
      std::make_shared<clang::PCHContainerOperations>(),
      llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE), FM, OnlyLocalDecls,
      static_cast<clang::CaptureDiagsKind>(CaptureDiagnostics),
      PrecompilePreambleAfterNParses, static_cast<clang::TranslationUnitKind>(TUKind),
      CacheCodeCompletionResults, IncludeBriefCommentsInCodeCompletion,
      UserFilesAreVolatile);
  return reinterpret_cast<CXASTUnit>(AU.release());
}

// LoadFromCommandLine
// Reparse
// ResetForParse
// CodeComplete

bool clang_ASTUnit_Save(CXASTUnit AU, const char *File) {
  return reinterpret_cast<clang::ASTUnit *>(AU)->Save(llvm::StringRef(File));
}

// serialize
