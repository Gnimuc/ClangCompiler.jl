#ifndef LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXFileManager clang_FileManager_create(void);

void clang_FileManager_dispose(CXFileManager FM);

LLVMMemoryBufferRef clang_FileManager_getBufferForFile(CXFileManager FM, CXFileEntryRef FER,
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

// The name the reference was looked up under, following redirects to the base entry. Borrowed:
// the bytes are an llvm::StringMapEntry key in the FileManager's map, individually allocated
// with a trailing NUL and never erased for the manager's lifetime.
const char *clang_FileEntryRef_getName(CXFileEntryRef FER);

// The directory holding the referenced file, heap-boxed like every by-value DirectoryEntryRef;
// release it with the existing clang_DirectoryEntryRef_dispose.
CXDirectoryEntryRef clang_FileEntryRef_getDir(CXFileEntryRef FER);

// Whether the two references name the same map entry. This is reference identity, which is
// finer than file identity: two names for one file compare unequal here.
bool clang_FileEntryRef_isSameRef(CXFileEntryRef FER, CXFileEntryRef RHS);

// The number of unique real files the manager has opened.
size_t clang_FileManager_getNumUniqueRealFiles(CXFileManager FM);

// getVirtualFileRef is deliberately NOT wrapped. Its C++ signature is
// (StringRef, off_t, time_t), and those two spell different underlying types across the
// clang-cpp builds this package links: off_t is `long long` on Darwin/Linux but `long` on
// mingw, so the overload a fixed-width shim resolves to does not exist in the Windows import
// library and the link fails there while succeeding everywhere else.

// The file's size in bytes, widened to int64_t so no off_t alias is needed.
int64_t clang_FileEntry_getSize(CXFileEntry FE);

// DirectoryEntryRef
// Heap-boxes the by-value clang::DirectoryEntryRef for DirName, or returns NULL when the
// directory does not exist (MARSHALLING.md §8, nullptr sentinel). Release a non-NULL result
// with clang_DirectoryEntryRef_dispose. Unlike clang_FileManager_getDirectory, whose bare
// const DirectoryEntry * cannot be turned back into a ref, this is what DirectoryLookup needs.
CXDirectoryEntryRef clang_FileManager_getOptionalDirectoryRef(CXFileManager FM,
                                                              const char *DirName,
                                                              bool CacheFailure);

void clang_DirectoryEntryRef_dispose(CXDirectoryEntryRef DER);

LLVM_CLANG_C_EXTERN_C_END

#endif