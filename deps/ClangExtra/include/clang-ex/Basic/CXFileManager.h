#ifndef LIBCLANGEX_CXFILEMANAGER_H
#define LIBCLANGEX_CXFILEMANAGER_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXFileManager clang_FileManager_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_FileManager_dispose(CXFileManager FM);

CINDEX_LINKAGE LLVMMemoryBufferRef clang_FileManager_getBufferForFile(
    CXFileManager FM, CXFileEntry FE, bool isVolatile, bool RequiresNullTerminator);

CINDEX_LINKAGE void clang_FileManager_PrintStats(CXFileManager FM);

// DirectoryEntry
CINDEX_LINKAGE CXDirectoryEntry clang_FileManager_getDirectory(CXFileManager FM,
                                                               const char *DirName,
                                                               bool CacheFailure);

CINDEX_LINKAGE const char *clang_DirectoryEntry_getName(CXDirectoryEntry DE);

// FileEntryRef
// FIXME: this function allocates memory, do not forget to call
// `clang_FileEntryRef_dispose` to release the resource
CINDEX_LINKAGE CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM,
                                                           const char *Filename,
                                                           bool OpenFile,
                                                           bool CacheFailure);

// FIXME: users must call this dispose function manually to release the resource created by
// `clang_FileManager_getFileRef`
CINDEX_LINKAGE void clang_FileEntryRef_dispose(CXFileEntryRef FER);

CINDEX_LINKAGE CXFileEntry clang_FileEntryRef_getFileEntry(CXFileEntryRef FER);

#ifdef __cplusplus
}
#endif
#endif