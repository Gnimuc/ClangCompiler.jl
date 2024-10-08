#include "clang-ex/Basic/CXSourceManager.h"
#include "clang/Basic/SourceManager.h"
#include "llvm/Support/MemoryBuffer.h"

CXSourceManager clang_SourceManager_create(CXDiagnosticsEngine Diag, CXFileManager FileMgr,
                                           bool UserFilesAreVolatile) {
  auto SM = std::make_unique<clang::SourceManager>(
      *(static_cast<clang::DiagnosticsEngine *>(Diag)),
      *(static_cast<clang::FileManager *>(FileMgr)), UserFilesAreVolatile);
  return SM.release();
}

void clang_SourceManager_dispose(CXSourceManager SM) {
  delete static_cast<clang::SourceManager *>(SM);
}

void clang_SourceManager_PrintStats(CXSourceManager SM) {
  static_cast<clang::SourceManager *>(SM)->PrintStats();
}

unsigned clang_FileID_getHashValue(CXFileID FID) {
  return static_cast<clang::FileID *>(FID)->getHashValue();
}

void clang_FileID_dispose(CXFileID FID) { delete static_cast<clang::FileID *>(FID); }

CXFileID clang_SourceManager_createFileIDFromMemoryBuffer(CXSourceManager SM,
                                                          LLVMMemoryBufferRef MB) {
  std::unique_ptr<clang::FileID> ptr =
      std::make_unique<clang::FileID>(static_cast<clang::SourceManager *>(SM)->createFileID(
          std::unique_ptr<llvm::MemoryBuffer>(llvm::unwrap(MB)), clang::SrcMgr::C_User));
  return ptr.release();
}

CXFileID clang_SourceManager_createFileIDFromFileEntry(CXSourceManager SM,
                                                       CXFileEntryRef FER,
                                                       CXSourceLocation_ Loc) {
  std::unique_ptr<clang::FileID> ptr =
      std::make_unique<clang::FileID>(static_cast<clang::SourceManager *>(SM)->createFileID(
          *static_cast<clang::FileEntryRef *>(FER),
          clang::SourceLocation::getFromPtrEncoding(Loc), clang::SrcMgr::C_User));
  return ptr.release();
}

// this allocates because `static FileID get(int V)` is a private method and this is
// intended.
CXFileID clang_SourceManager_getMainFileID(CXSourceManager SM) {
  std::unique_ptr<clang::FileID> ptr = std::make_unique<clang::FileID>(
      static_cast<clang::SourceManager *>(SM)->getMainFileID());
  return ptr.release();
}

void clang_SourceManager_setMainFileID(CXSourceManager SM, CXFileID FID) {
  static_cast<clang::SourceManager *>(SM)->setMainFileID(
      *static_cast<clang::FileID *>(FID));
}

void clang_SourceManager_overrideFileContents(CXSourceManager SM, CXFileEntryRef FER,
                                              LLVMMemoryBufferRef MB) {
  static_cast<clang::SourceManager *>(SM)->overrideFileContents(
      *static_cast<clang::FileEntryRef *>(FER),
      std::unique_ptr<llvm::MemoryBuffer>(llvm::unwrap(MB)));
}

CXSourceLocation_ clang_SourceManager_getLocForStartOfFile(CXSourceManager SM,
                                                           CXFileID FID) {
  return static_cast<clang::SourceManager *>(SM)
      ->getLocForStartOfFile(*static_cast<clang::FileID *>(FID))
      .getPtrEncoding();
}

CXSourceLocation_ clang_SourceManager_getLocForEndOfFile(CXSourceManager SM, CXFileID FID) {
  return static_cast<clang::SourceManager *>(SM)
      ->getLocForEndOfFile(*static_cast<clang::FileID *>(FID))
      .getPtrEncoding();
}