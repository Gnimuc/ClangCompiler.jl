#ifndef LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXFileManager clang_FileManager_create(CXInit_Error *ErrorCode);

void clang_FileManager_dispose(CXFileManager FM);

LLVMMemoryBufferRef clang_FileManager_getBufferForFile(CXFileManager FM, CXFileEntry FE,
                                                       bool isVolatile,
                                                       bool RequiresNullTerminator);

void clang_FileManager_PrintStats(CXFileManager FM);

// DirectoryEntry
CXDirectoryEntry clang_FileManager_getDirectory(CXFileManager FM, const char *DirName,
                                                bool CacheFailure);

// FileEntryRef
// FIXME: this function allocates memory, do not forget to call
// `clang_FileEntryRef_dispose` to release the resource
CXFileEntryRef clang_FileManager_getFileRef(CXFileManager FM, const char *Filename,
                                            bool OpenFile, bool CacheFailure);

// FIXME: users must call this dispose function manually to release the resource created by
// `clang_FileManager_getFileRef`
void clang_FileEntryRef_dispose(CXFileEntryRef FER);

CXFileEntry clang_FileEntryRef_getFileEntry(CXFileEntryRef FER);

LLVM_CLANG_C_EXTERN_C_END

#endif