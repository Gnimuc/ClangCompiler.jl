#ifndef LLVM_CLANG_C_EXTRA_CXFILEENTRY_H
#define LLVM_CLANG_C_EXTRA_CXFILEENTRY_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

const char *clang_FileEntry_getName(CXFileEntry FE);

const char *clang_FileEntry_tryGetRealPathName(CXFileEntry FE);

unsigned clang_FileEntry_getUID(CXFileEntry FE);

time_t clang_FileEntry_getModificationTime(CXFileEntry FE);

CXDirectoryEntry clang_FileEntry_getDir(CXFileEntry FE);

bool clang_FileEntry_isNamedPipe(CXFileEntry FE);

LLVM_CLANG_C_EXTERN_C_END

#endif