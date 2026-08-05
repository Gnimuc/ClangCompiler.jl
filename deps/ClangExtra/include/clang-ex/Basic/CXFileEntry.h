#ifndef LLVM_CLANG_C_EXTRA_CXFILEENTRY_H
#define LLVM_CLANG_C_EXTRA_CXFILEENTRY_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// No getName here. `FileEntry::getName()` is deprecated in clang because it forwards to
// whichever `FileEntryRef` last referred to the file, so the answer depends on lookup history
// rather than on the entry: one file reached under two spellings (a VFS remapping, a symlink)
// answers with whichever was used most recently. `clang_FileEntryRef_getName` is the stable
// question and is already wrapped -- reach a name through the ref, not the entry.

const char *clang_FileEntry_tryGetRealPathName(CXFileEntry FE);

unsigned clang_FileEntry_getUID(CXFileEntry FE);

// Widened to int64_t so no time_t alias is needed, for the same reason getSize is: `time_t`
// spells different underlying types across the builds this package links, and the generated
// Julia alias resolves per-platform. Clang's own time_t is 64-bit on all three, so the widening
// is lossless everywhere and the binding no longer has to guess.
int64_t clang_FileEntry_getModificationTime(CXFileEntry FE);

CXDirectoryEntry clang_FileEntry_getDir(CXFileEntry FE);

bool clang_FileEntry_isNamedPipe(CXFileEntry FE);

LLVM_CLANG_C_EXTERN_C_END

#endif