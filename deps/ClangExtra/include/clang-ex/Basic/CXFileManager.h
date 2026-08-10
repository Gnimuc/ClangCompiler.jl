#ifndef LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H
#define LLVM_CLANG_C_EXTRA_CXFILEMANAGER_H

#include <sys/types.h>   // off_t, whose width is the point of this file
#include <time.h>
#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
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

// Rewrite `Path` per the FileManager's FileSystemOptions working directory, returning the
// result as an owned CXString and reporting in *Changed whether clang altered it.
//
// clang takes a `SmallVectorImpl<char>&` in/out; a caller-supplied buffer would have to be
// sized in advance for a result whose length clang alone knows, so the string crosses as a
// copy (MARSHALLING.md §5) and the boolean the C++ API returns becomes the out-param.
// *Changed may be NULL.
CXString clang_FileManager_FixupRelativePath(CXFileManager FM, const char *Path,
                                             bool *Changed);

// Same shape as FixupRelativePath: make `Path` absolute per FileSystemOptions and the working
// directory, returning the result and reporting whether it changed.
CXString clang_FileManager_makeAbsolutePath(CXFileManager FM, const char *Path,
                                            bool *Changed);

// The canonical on-disk name of a file or directory.
//
// Very expensive despite clang's cache, and needed only when the physical layout of the file
// system is. clang returns a StringRef into that cache — an interior pointer whose lifetime
// this boundary cannot observe (MARSHALLING.md §14) — so it crosses as an owned copy.
CXString clang_FileManager_getCanonicalNameForFile(CXFileManager FM, CXFileEntryRef File);
CXString clang_FileManager_getCanonicalNameForDir(CXFileManager FM, CXDirectoryEntryRef Dir);

// llvm::vfs — the virtual file system a FileManager reads through
//
// Every handle in this cluster points at a heap-allocated
// `llvm::IntrusiveRefCntPtr<llvm::vfs::FileSystem>`: the box is what the caller owns and
// disposes, and disposing it drops one reference rather than destroying a file system some
// FileManager is still reading through. That is what makes the ownership answerable at this
// boundary at all — a bare `vfs::FileSystem *` would say nothing about who keeps it alive.
//
// The three handles are distinct C types so a wrapper cannot hand an overlay where an
// in-memory file system is meant; `_castToFileSystem` is the upcast, and it returns the
// SAME box rather than a new reference, so it must not be disposed separately.
//
// Together with clang_FileManager_setVirtualFileSystem this is the general form of
// clang_CompilerInstance_createFileManagerWithVOFS4PCH, which does one hardcoded
// overlay-a-PCH-buffer-on-the-real-filesystem arrangement and nothing else: build an
// InMemoryFileSystem with as many files as the session needs, push it onto an overlay over
// the real file system, and install that.

// The physical file system, as a fresh owned reference.
CXVirtualFileSystem clang_vfs_getRealFileSystem(void);

void clang_VirtualFileSystem_dispose(CXVirtualFileSystem FS);

// Whether a path resolves to something in this file system. The convenience predicate
// clang's own FileManager reaches for, and the cheapest way to observe that an overlay is
// wired up the way the caller meant.
bool clang_VirtualFileSystem_exists(CXVirtualFileSystem FS, const char *Path);

CXInMemoryFileSystem clang_InMemoryFileSystem_create(void);

void clang_InMemoryFileSystem_dispose(CXInMemoryFileSystem FS);

// Adds `Path` with the given contents, taking ownership of the buffer. Returns false when
// a file of that name is already present with different contents, in which case the buffer
// is dropped rather than installed.
bool clang_InMemoryFileSystem_addFile(CXInMemoryFileSystem FS, const char *Path,
                                      int64_t ModificationTime,
                                      LLVMMemoryBufferRef Buffer);

// A one-entry-per-line rendering of the tree, which is how a caller checks what was added.
CXString clang_InMemoryFileSystem_toString(CXInMemoryFileSystem FS);

// Upcast. Borrowed: the same reference the argument holds, not a new one.
CXVirtualFileSystem clang_InMemoryFileSystem_castToFileSystem(CXInMemoryFileSystem FS);

// An overlay stack whose bottom layer is `Base`. Later pushes shadow earlier ones.
CXOverlayFileSystem clang_OverlayFileSystem_create(CXVirtualFileSystem Base);

void clang_OverlayFileSystem_dispose(CXOverlayFileSystem FS);

void clang_OverlayFileSystem_pushOverlay(CXOverlayFileSystem FS,
                                         CXVirtualFileSystem Overlay);

// Upcast. Borrowed, exactly as clang_InMemoryFileSystem_castToFileSystem.
CXVirtualFileSystem clang_OverlayFileSystem_castToFileSystem(CXOverlayFileSystem FS);

// The file system this manager reads through, as a fresh owned reference — clang's
// getVirtualFileSystemPtr, not the reference-returning getVirtualFileSystem, because a bare
// reference could outlive the manager. Release it with clang_VirtualFileSystem_dispose.
CXVirtualFileSystem clang_FileManager_getVirtualFileSystem(CXFileManager FM);

// Installs a different file system. The manager keeps the caches it has already filled, so
// this belongs before the first lookup: a file resolved through the old file system stays
// resolved that way.
void clang_FileManager_setVirtualFileSystem(CXFileManager FM, CXVirtualFileSystem FS);

LLVM_CLANG_C_EXTERN_C_END

#endif