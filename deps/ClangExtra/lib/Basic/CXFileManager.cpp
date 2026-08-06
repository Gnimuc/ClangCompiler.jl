#include "clang-ex/Basic/CXFileManager.h"
#include "utils.h"
#include "clang/Basic/FileManager.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/MemoryBuffer.h"

CXFileManager clang_FileManager_create(void) {
  auto FM = std::make_unique<clang::FileManager>(clang::FileSystemOptions());
  return reinterpret_cast<CXFileManager>(FM.release());
}

void clang_FileManager_dispose(CXFileManager FM) {
  delete reinterpret_cast<clang::FileManager *>(FM);
}

LLVMMemoryBufferRef clang_FileManager_getBufferForFile(CXFileManager FM, CXFileEntryRef FER,
                                                       bool isVolatile,
                                                       bool RequiresNullTerminator) {
  auto buffer = reinterpret_cast<clang::FileManager *>(FM)->getBufferForFile(
      *reinterpret_cast<clang::FileEntryRef *>(FER), isVolatile, RequiresNullTerminator);
  if (std::error_code EC = buffer.getError()) {
    llvm::errs() << "Cannot get buffer for file. Error: " << EC.message() << "\n";
    return nullptr;
  }
  return llvm::wrap(buffer->release());
}

void clang_FileManager_PrintStats(CXFileManager FM) {
  reinterpret_cast<clang::FileManager *>(FM)->PrintStats();
}

// DirectoryEntry
CXDirectoryEntry clang_FileManager_getDirectory(CXFileManager FM, const char *DirName,
                                                bool CacheFailure) {
  return reinterpret_cast<CXDirectoryEntry>(const_cast<clang::DirectoryEntry *>(
      *reinterpret_cast<clang::FileManager *>(FM)->getDirectory(llvm::StringRef(DirName),
                                                           CacheFailure)));
}

// FileEntryRef
CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM, const char *Filename,
                                            bool OpenFile, bool CacheFailure);

CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM, const char *Filename,
                                            bool OpenFile, bool CacheFailure) {
  auto File =
      reinterpret_cast<clang::FileManager *>(FM)->getFileRef(Filename, OpenFile, CacheFailure);
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
  return reinterpret_cast<CXFileEntryRef>(ptr.release());
}

CXFileEntryRef clang_FileManager_getVirtualFileRef(CXFileManager FM, const char *Filename,
                                                   int64_t Size, int64_t ModificationTime) {
  auto FER = reinterpret_cast<clang::FileManager *>(FM)->getVirtualFileRef(
      llvm::StringRef(Filename), Size, ModificationTime);
  std::unique_ptr<clang::FileEntryRef> ptr = std::make_unique<clang::FileEntryRef>(FER);
  return reinterpret_cast<CXFileEntryRef>(ptr.release());
}

size_t clang_sizeof_off_t(void) { return sizeof(off_t); }

size_t clang_sizeof_time_t(void) { return sizeof(time_t); }

void clang_FileEntryRef_dispose(CXFileEntryRef FER) {
  delete reinterpret_cast<clang::FileEntryRef *>(FER);
}

CXFileEntry clang_FileEntryRef_getFileEntry(CXFileEntryRef FER) {
  auto &FE = const_cast<clang::FileEntry &>(
      reinterpret_cast<clang::FileEntryRef *>(FER)->getFileEntry());
  return reinterpret_cast<CXFileEntry>(&FE);
}

CXDirectoryEntryRef clang_FileManager_getOptionalDirectoryRef(CXFileManager FM,
                                                              const char *DirName,
                                                              bool CacheFailure) {
  auto D = reinterpret_cast<clang::FileManager *>(FM)->getOptionalDirectoryRef(
      llvm::StringRef(DirName), CacheFailure);
  if (!D)
    return nullptr;
  return reinterpret_cast<CXDirectoryEntryRef>(std::make_unique<clang::DirectoryEntryRef>(*D).release());
}

void clang_DirectoryEntryRef_dispose(CXDirectoryEntryRef DER) {
  delete reinterpret_cast<clang::DirectoryEntryRef *>(DER);
}

const char *clang_FileEntryRef_getName(CXFileEntryRef FER) {
  return reinterpret_cast<clang::FileEntryRef *>(FER)->getName().data();
}

CXDirectoryEntryRef clang_FileEntryRef_getDir(CXFileEntryRef FER) {
  return reinterpret_cast<CXDirectoryEntryRef>(std::make_unique<clang::DirectoryEntryRef>(
             reinterpret_cast<clang::FileEntryRef *>(FER)->getDir())
      .release());
}

bool clang_FileEntryRef_isSameRef(CXFileEntryRef FER, CXFileEntryRef RHS) {
  return reinterpret_cast<clang::FileEntryRef *>(FER)->isSameRef(
      *reinterpret_cast<clang::FileEntryRef *>(RHS));
}

size_t clang_FileManager_getNumUniqueRealFiles(CXFileManager FM) {
  return reinterpret_cast<clang::FileManager *>(FM)->getNumUniqueRealFiles();
}


int64_t clang_FileEntry_getSize(CXFileEntry FE) {
  return reinterpret_cast<clang::FileEntry *>(FE)->getSize();
}

// clang mutates a SmallVector in place; the shim seeds it from Path, calls, and copies the
// result out, so the Julia side never holds storage clang owns.
static CXString fixupOrAbsolute(CXFileManager FM, const char *Path, bool *Changed,
                                bool Absolute) {
  llvm::SmallString<128> Buf(Path);
  auto *M = reinterpret_cast<clang::FileManager *>(FM);
  bool Did = Absolute ? M->makeAbsolutePath(Buf) : M->FixupRelativePath(Buf);
  if (Changed)
    *Changed = Did;
  return extra::makeCXString(std::string(Buf.str()));
}

CXString clang_FileManager_FixupRelativePath(CXFileManager FM, const char *Path,
                                             bool *Changed) {
  return fixupOrAbsolute(FM, Path, Changed, /*Absolute=*/false);
}

CXString clang_FileManager_makeAbsolutePath(CXFileManager FM, const char *Path,
                                            bool *Changed) {
  return fixupOrAbsolute(FM, Path, Changed, /*Absolute=*/true);
}

CXString clang_FileManager_getCanonicalNameForFile(CXFileManager FM, CXFileEntryRef File) {
  return extra::makeCXString(
      reinterpret_cast<clang::FileManager *>(FM)
          ->getCanonicalName(*reinterpret_cast<clang::FileEntryRef *>(File))
          .str());
}

CXString clang_FileManager_getCanonicalNameForDir(CXFileManager FM, CXDirectoryEntryRef Dir) {
  return extra::makeCXString(
      reinterpret_cast<clang::FileManager *>(FM)
          ->getCanonicalName(*reinterpret_cast<clang::DirectoryEntryRef *>(Dir))
          .str());
}
