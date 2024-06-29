#include "clang-ex/Basic/CXFileEntry.h"
#include "clang/Basic/FileEntry.h"

const char *clang_FileEntry_getName(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->getName().data();
}

const char *clang_FileEntry_tryGetRealPathName(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->tryGetRealPathName().data();
}

bool clang_FileEntry_isValid(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->isValid();
}

unsigned clang_FileEntry_getUID(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->getUID();
}

time_t clang_FileEntry_getModificationTime(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->getModificationTime();
}

CXDirectoryEntry clang_FileEntry_getDir(CXFileEntry FE) {
  return const_cast<clang::DirectoryEntry *>(static_cast<clang::FileEntry *>(FE)->getDir());
}

bool clang_FileEntry_isNamedPipe(CXFileEntry FE) {
  return static_cast<clang::FileEntry *>(FE)->isNamedPipe();
}