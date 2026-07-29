#ifndef LLVM_CLANG_C_EXTRA_CXDIRECTORYLOOKUP_H
#define LLVM_CLANG_C_EXTRA_CXDIRECTORYLOOKUP_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXSourceManager.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A clang::DirectoryLookup is a by-value search-path entry with no pointer form, so it is
// heap-boxed and caller-owned (the FileEntryRef and FileID precedent).
// clang_HeaderSearch_AddSearchPath and _AddSystemSearchPath COPY the value into the search's
// vector, so the box may be disposed immediately after either call.
CXDirectoryLookup clang_DirectoryLookup_create(CXDirectoryEntryRef Dir,
                                               CXCharacteristicKind DT, bool isFramework);

void clang_DirectoryLookup_dispose(CXDirectoryLookup DL);

// For a normal directory this is the DirectoryEntryRef's name, i.e. the string
// clang_FileManager_getOptionalDirectoryRef was given.
CXString clang_DirectoryLookup_getName(CXDirectoryLookup DL);

LLVM_CLANG_C_EXTERN_C_END

#endif
