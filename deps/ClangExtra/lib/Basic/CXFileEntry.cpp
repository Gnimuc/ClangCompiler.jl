#include "clang-ex/Basic/CXFileEntry.h"
#include "clang/Basic/FileEntry.h"

const char *clang_FileEntry_tryGetRealPathName(CXFileEntry FE) {
  return reinterpret_cast<clang::FileEntry *>(FE)->tryGetRealPathName().data();
}

unsigned clang_FileEntry_getUID(CXFileEntry FE) {
  return reinterpret_cast<clang::FileEntry *>(FE)->getUID();
}

int64_t clang_FileEntry_getModificationTime(CXFileEntry FE) {
  return reinterpret_cast<clang::FileEntry *>(FE)->getModificationTime();
}

CXDirectoryEntry clang_FileEntry_getDir(CXFileEntry FE) {
  return reinterpret_cast<CXDirectoryEntry>(const_cast<clang::DirectoryEntry *>(reinterpret_cast<clang::FileEntry *>(FE)->getDir()));
}

bool clang_FileEntry_isNamedPipe(CXFileEntry FE) {
  return reinterpret_cast<clang::FileEntry *>(FE)->isNamedPipe();
}
