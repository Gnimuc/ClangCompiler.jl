#ifndef LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H

#include <sys/types.h>   // off_t, whose width is the point of this file
#include <time.h>
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

// A virtual file: one that behaves as if a file of this name, size and mtime were on disk,
// without the file being accessed.
//
// The C++ callee is (StringRef, off_t, time_t), and both of those are spelled differently per
// platform, so its mangled name differs on all three -- `Exl` on Darwin, `Ell` on Linux, `Exx`
// on mingw once _FILE_OFFSET_BITS=64 is set. That resolves at compile time from clang's own
// header, which this file includes.
//
// What it does NOT resolve by itself is that on Windows the two sides come from different
// toolchains: this shim is compiled on the runner by msys2's mingw gcc, while clang-cpp arrives
// prebuilt from LLVM_full_jll. They must agree on off_t or the link fails with
//
//   undefined reference to `clang::FileManager::getVirtualFileRef(llvm::StringRef, long, long long)'
//
// which is what happened before CMakeLists.txt set _FILE_OFFSET_BITS=64. With it set, off_t is
// 64 bits on all three and the shim can spell int64_t at its own boundary with nothing to
// truncate. `clang_sizeof_off_t` below is what keeps that agreement checkable.
//
// FIXME: allocates; release with `clang_FileEntryRef_dispose`.
CXFileEntryRef clang_FileManager_getVirtualFileRef(CXFileManager FM, const char *Filename,
                                                   int64_t Size, int64_t ModificationTime);

size_t clang_sizeof_off_t(void);
size_t clang_sizeof_time_t(void);

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