#include "clang-ex/Basic/CXFileManager.h"
#include "clang/Basic/FileManager.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/MemoryBuffer.h"

CXFileManager clang_FileManager_create(void) {
  auto FM = std::make_unique<clang::FileManager>(clang::FileSystemOptions());
  return FM.release();
}

void clang_FileManager_dispose(CXFileManager FM) {
  delete static_cast<clang::FileManager *>(FM);
}

LLVMMemoryBufferRef clang_FileManager_getBufferForFile(CXFileManager FM, CXFileEntryRef FER,
                                                       bool isVolatile,
                                                       bool RequiresNullTerminator) {
  auto buffer = static_cast<clang::FileManager *>(FM)->getBufferForFile(
      *static_cast<clang::FileEntryRef *>(FER), isVolatile, RequiresNullTerminator);
  if (std::error_code EC = buffer.getError()) {
    llvm::errs() << "Cannot get buffer for file. Error: " << EC.message() << "\n";
    return nullptr;
  }
  return llvm::wrap(buffer->release());
}

void clang_FileManager_PrintStats(CXFileManager FM) {
  static_cast<clang::FileManager *>(FM)->PrintStats();
}

// DirectoryEntry
CXDirectoryEntry clang_FileManager_getDirectory(CXFileManager FM, const char *DirName,
                                                bool CacheFailure) {
  return const_cast<clang::DirectoryEntry *>(
      *static_cast<clang::FileManager *>(FM)->getDirectory(llvm::StringRef(DirName),
                                                           CacheFailure));
}

// FileEntryRef
CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM, const char *Filename,
                                            bool OpenFile, bool CacheFailure);

CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM, const char *Filename,
                                            bool OpenFile, bool CacheFailure) {
  auto File =
      static_cast<clang::FileManager *>(FM)->getFileRef(Filename, OpenFile, CacheFailure);
  if (!File) {
    std::error_code EC = llvm::errorToErrorCode(File.takeError());
    if (EC != llvm::errc::no_such_file_or_directory && EC != llvm::errc::invalid_argument &&
        EC != llvm::errc::is_a_directory && EC != llvm::errc::not_a_directory) {
      llvm::errs() << "Cannot open file: " << Filename << " " << EC.message() << "\n";
    } else {
      llvm::errs() << Filename << " " << EC.message() << "\n";
    }
    return nullptr;
  }
  std::unique_ptr<clang::FileEntryRef> ptr = std::make_unique<clang::FileEntryRef>(*File);
  return ptr.release();
}

void clang_FileEntryRef_dispose(CXFileEntryRef FER) {
  delete static_cast<clang::FileEntryRef *>(FER);
}

CXFileEntry clang_FileEntryRef_getFileEntry(CXFileEntryRef FER) {
  auto &FE = const_cast<clang::FileEntry &>(
      static_cast<clang::FileEntryRef *>(FER)->getFileEntry());
  return &FE;
}