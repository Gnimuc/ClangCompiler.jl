#include "clang-ex/Frontend/CXASTUnit.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclBase.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Frontend/ASTUnit.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Sema/Sema.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>

// Mirror sync for CXCaptureDiagsKind. It lives here rather than in lib/Basic/CXEnumSync.cpp
// because clang/Frontend/ASTUnit.h includes clang-c/Index.h, whose declarations collide
// with this library's own once the clang-ex headers that file gathers are also in scope.
#define ENUM_SYNC(cx, cpp)                                                                 \
  static_assert(static_cast<int>(cx) == static_cast<int>(cpp), #cx " != " #cpp)

ENUM_SYNC(CXCaptureDiagsKind_None, clang::CaptureDiagsKind::None);
ENUM_SYNC(CXCaptureDiagsKind_All, clang::CaptureDiagsKind::All);
ENUM_SYNC(CXCaptureDiagsKind_AllWithoutNonErrorsFromIncludes,
          clang::CaptureDiagsKind::AllWithoutNonErrorsFromIncludes);

#undef ENUM_SYNC

bool clang_ASTUnit_isMainFileAST(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->isMainFileAST();
}

bool clang_ASTUnit_isUnsafeToFree(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->isUnsafeToFree();
}

void clang_ASTUnit_setUnsafeToFree(CXASTUnit AU, bool Value) {
  static_cast<clang::ASTUnit *>(AU)->setUnsafeToFree(Value);
}

// isUnsafeToFree
// setUnsafeToFree

CXDiagnosticsEngine clang_ASTUnit_getDiagnostics(CXASTUnit AU) {
  return &static_cast<clang::ASTUnit *>(AU)->getDiagnostics();
}

CXSourceManager clang_ASTUnit_getSourceManager(CXASTUnit AU) {
  return &static_cast<clang::ASTUnit *>(AU)->getSourceManager();
}

bool clang_ASTUnit_hasPreprocessor(CXASTUnit AU) {
  return static_cast<bool>(static_cast<clang::ASTUnit *>(AU)->getPreprocessorPtr());
}

CXPreprocessor clang_ASTUnit_getPreprocessor(CXASTUnit AU) {
  // Goes through getPreprocessorPtr rather than getPreprocessor: the latter returns *PP,
  // and a libstdc++ built with _GLIBCXX_ASSERTIONS aborts on dereferencing the null
  // shared_ptr a unit that has never parsed still holds.
  return static_cast<clang::ASTUnit *>(AU)->getPreprocessorPtr().get();
}

// getPreprocessorPtr

CXASTContext clang_ASTUnit_getASTContext(CXASTUnit AU) {
  return &static_cast<clang::ASTUnit *>(AU)->getASTContext();
}

void clang_ASTUnit_setASTContext(CXASTUnit AU, CXASTContext Ctx) {
  static_cast<clang::ASTUnit *>(AU)->setASTContext(static_cast<clang::ASTContext *>(Ctx));
}

// setPreprocessor
// enableSourceFileDiagnostics

bool clang_ASTUnit_hasSema(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->hasSema();
}

CXSema clang_ASTUnit_getSema(CXASTUnit AU) {
  return &static_cast<clang::ASTUnit *>(AU)->getSema();
}

// getLangOpts
// getHeaderSearchOpts
// getPreprocessorOpts

CXFileManager clang_ASTUnit_getFileManager(CXASTUnit AU) {
  return &static_cast<clang::ASTUnit *>(AU)->getFileManager();
}

CXFileSystemOptions clang_ASTUnit_getFileSystemOpts(CXASTUnit AU) {
  return const_cast<clang::FileSystemOptions *>(
      &static_cast<clang::ASTUnit *>(AU)->getFileSystemOpts());
}

// getFileSystemOpts
// getASTReader

CXString clang_ASTUnit_getOriginalSourceFileName(CXASTUnit AU) {
  return extra::makeCXString(
      static_cast<clang::ASTUnit *>(AU)->getOriginalSourceFileName().str());
}

// getASTMutationListener
// getDeserializationListener

bool clang_ASTUnit_getOnlyLocalDecls(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getOnlyLocalDecls();
}

bool clang_ASTUnit_getOwnsRemappedFileBuffers(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getOwnsRemappedFileBuffers();
}

void clang_ASTUnit_setOwnsRemappedFileBuffers(CXASTUnit AU, bool Value) {
  static_cast<clang::ASTUnit *>(AU)->setOwnsRemappedFileBuffers(Value);
}

CXString clang_ASTUnit_getMainFileName(CXASTUnit AU) {
  return extra::makeCXString(static_cast<clang::ASTUnit *>(AU)->getMainFileName().str());
}

// getASTFileName

// Top-level declarations
size_t clang_ASTUnit_top_level_size(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->top_level_size();
}

bool clang_ASTUnit_top_level_empty(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->top_level_empty();
}

CXDecl clang_ASTUnit_getTopLevelDecl(CXASTUnit AU, unsigned Index) {
  return *(static_cast<clang::ASTUnit *>(AU)->top_level_begin() + Index);
}

void clang_ASTUnit_addTopLevelDecl(CXASTUnit AU, CXDecl D) {
  static_cast<clang::ASTUnit *>(AU)->addTopLevelDecl(static_cast<clang::Decl *>(D));
}

// File-level declarations
void clang_ASTUnit_addFileLevelDecl(CXASTUnit AU, CXDecl D) {
  static_cast<clang::ASTUnit *>(AU)->addFileLevelDecl(static_cast<clang::Decl *>(D));
}

size_t clang_ASTUnit_getNumFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                           unsigned Length) {
  llvm::SmallVector<clang::Decl *, 8> Decls;
  static_cast<clang::ASTUnit *>(AU)->findFileRegionDecls(
      *static_cast<clang::FileID *>(File), Offset, Length, Decls);
  return Decls.size();
}

void clang_ASTUnit_findFileRegionDecls(CXASTUnit AU, CXFileID File, unsigned Offset,
                                       unsigned Length, CXDecl *Buf) {
  llvm::SmallVector<clang::Decl *, 8> Decls;
  static_cast<clang::ASTUnit *>(AU)->findFileRegionDecls(
      *static_cast<clang::FileID *>(File), Offset, Length, Decls);
  for (size_t I = 0; I < Decls.size(); ++I)
    Buf[I] = Decls[I];
}

unsigned clang_ASTUnit_getCurrentTopLevelHashValue(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getCurrentTopLevelHashValue();
}

void clang_ASTUnit_setCurrentTopLevelHashValue(CXASTUnit AU, unsigned Value) {
  static_cast<clang::ASTUnit *>(AU)->getCurrentTopLevelHashValue() = Value;
}

CXSourceLocation_ clang_ASTUnit_getLocation(CXASTUnit AU, CXFileEntry File, unsigned Line,
                                            unsigned Col) {
  return static_cast<clang::ASTUnit *>(AU)
      ->getLocation(static_cast<const clang::FileEntry *>(File), Line, Col)
      .getPtrEncoding();
}

CXSourceLocation_ clang_ASTUnit_mapLocationFromPreamble(CXASTUnit AU,
                                                        CXSourceLocation_ Loc) {
  return static_cast<clang::ASTUnit *>(AU)
      ->mapLocationFromPreamble(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding();
}

CXSourceLocation_ clang_ASTUnit_mapLocationToPreamble(CXASTUnit AU, CXSourceLocation_ Loc) {
  return static_cast<clang::ASTUnit *>(AU)
      ->mapLocationToPreamble(clang::SourceLocation::getFromPtrEncoding(Loc))
      .getPtrEncoding();
}

bool clang_ASTUnit_isInPreambleFileID(CXASTUnit AU, CXSourceLocation_ Loc) {
  return static_cast<clang::ASTUnit *>(AU)->isInPreambleFileID(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_ASTUnit_isInMainFileID(CXASTUnit AU, CXSourceLocation_ Loc) {
  return static_cast<clang::ASTUnit *>(AU)->isInMainFileID(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_ASTUnit_getStartOfMainFileID(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getStartOfMainFileID().getPtrEncoding();
}

CXSourceLocation_ clang_ASTUnit_getEndOfPreambleFileID(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getEndOfPreambleFileID().getPtrEncoding();
}

CXSourceRange_ clang_ASTUnit_mapRangeFromPreamble(CXASTUnit AU, CXSourceRange_ R) {
  auto Rng = static_cast<clang::ASTUnit *>(AU)->mapRangeFromPreamble(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
  return CXSourceRange_{Rng.getBegin().getPtrEncoding(), Rng.getEnd().getPtrEncoding()};
}

CXSourceRange_ clang_ASTUnit_mapRangeToPreamble(CXASTUnit AU, CXSourceRange_ R) {
  auto Rng = static_cast<clang::ASTUnit *>(AU)->mapRangeToPreamble(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R.B),
                         clang::SourceLocation::getFromPtrEncoding(R.E)));
  return CXSourceRange_{Rng.getBegin().getPtrEncoding(), Rng.getEnd().getPtrEncoding()};
}

unsigned clang_ASTUnit_getPreambleCounterForTests(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->getPreambleCounterForTests();
}

size_t clang_ASTUnit_stored_diag_size(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->stored_diag_size();
}

CXStoredDiagnostic clang_ASTUnit_getStoredDiagnostic(CXASTUnit AU, unsigned Index) {
  return static_cast<clang::ASTUnit *>(AU)->stored_diag_begin() + Index;
}

size_t clang_ASTUnit_stored_diag_afterDriver_index(CXASTUnit AU) {
  auto *Unit = static_cast<clang::ASTUnit *>(AU);
  return static_cast<size_t>(Unit->stored_diag_afterDriver_begin() -
                             Unit->stored_diag_begin());
}

size_t clang_ASTUnit_cached_completion_size(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->cached_completion_size();
}

// visitLocalTopLevelDecls

CXFileEntryRef clang_ASTUnit_getPCHFile(CXASTUnit AU) {
  clang::OptionalFileEntryRef Ref = static_cast<clang::ASTUnit *>(AU)->getPCHFile();
  if (!Ref)
    return nullptr;
  return std::make_unique<clang::FileEntryRef>(*Ref).release();
}

bool clang_ASTUnit_isModuleFile(CXASTUnit AU) {
  return static_cast<clang::ASTUnit *>(AU)->isModuleFile();
}

LLVMMemoryBufferRef clang_ASTUnit_getBufferForFile(CXASTUnit AU, const char *Filename) {
  std::string Err;
  auto Buffer =
      static_cast<clang::ASTUnit *>(AU)->getBufferForFile(llvm::StringRef(Filename), &Err);
  if (!Buffer) {
    llvm::errs() << "Cannot get buffer for file. Error: " << Err << "\n";
    return nullptr;
  }
  return llvm::wrap(Buffer.release());
}

CXTranslationUnitKind clang_ASTUnit_getTranslationUnitKind(CXASTUnit AU) {
  return static_cast<CXTranslationUnitKind>(
      static_cast<clang::ASTUnit *>(AU)->getTranslationUnitKind());
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
  auto *DE = static_cast<clang::DiagnosticsEngine *>(Diags);
  DE->Retain();
  auto AU = clang::ASTUnit::create(std::shared_ptr<clang::CompilerInvocation>(
                                       static_cast<clang::CompilerInvocation *>(CI)),
                                   llvm::IntrusiveRefCntPtr<clang::DiagnosticsEngine>(DE),
                                   static_cast<clang::CaptureDiagsKind>(CaptureDiagnostics),
                                   UserFilesAreVolatile);
  return AU.release();
}

void clang_ASTUnit_dispose(CXASTUnit AU) { delete static_cast<clang::ASTUnit *>(AU); }

// LoadFromASTFile
// LoadFromCompilerInvocationAction
// LoadFromCompilerInvocation
// LoadFromCommandLine
// Reparse
// ResetForParse
// CodeComplete
// Save
// serialize
