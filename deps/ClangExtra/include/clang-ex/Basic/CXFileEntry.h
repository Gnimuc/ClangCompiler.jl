#ifndef LIBCLANGEX_CXFILEENTRY_H
#define LIBCLANGEX_CXFILEENTRY_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE const char *clang_FileEntry_getName(CXFileEntry FE);

CINDEX_LINKAGE const char *clang_FileEntry_tryGetRealPathName(CXFileEntry FE);

CINDEX_LINKAGE bool clang_FileEntry_isValid(CXFileEntry FE);

CINDEX_LINKAGE unsigned clang_FileEntry_getUID(CXFileEntry FE);

CINDEX_LINKAGE time_t clang_FileEntry_getModificationTime(CXFileEntry FE);

CINDEX_LINKAGE CXDirectoryEntry clang_FileEntry_getDir(CXFileEntry FE);

CINDEX_LINKAGE bool clang_FileEntry_isNamedPipe(CXFileEntry FE);

#ifdef __cplusplus
}
#endif
#endif