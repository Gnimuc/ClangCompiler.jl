#ifndef LLVM_CLANG_C_EXTRA_CXHEADERMAP_H
#define LLVM_CLANG_C_EXTRA_CXHEADERMAP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// An Apple `.hmap` file: to #include resolution it acts like a directory of symlinks, and
// an Xcode-generated project is full of them. `clang_HeaderSearch_CreateHeaderMap` already
// hands the map out; these are the questions that make a failed #include in such a project
// explicable.
//
// The map is owned by the HeaderSearch that loaded it, so there is no dispose here.

// The file `Filename` maps to, or the empty string when the map has no entry for it.
CXString clang_HeaderMap_lookupFilename(CXHeaderMap HM, const char *Filename);

// The path of the .hmap file itself.
CXString clang_HeaderMap_getFileName(CXHeaderMap HM);

// The key that maps to `DestPath`, or the empty string. This is the inverse of
// `lookupFilename` and is what turns a resolved path back into the spelling a user wrote.
CXString clang_HeaderMap_reverseLookupFilename(CXHeaderMap HM, const char *DestPath);

// Dumps every bucket of the map to stderr.
void clang_HeaderMap_dump(CXHeaderMap HM);

// Every key in the map, in bucket order. Returned as a set rather than as a count + fill
// pair because the underlying `forEachKey` is a one-shot walk: counting first would mean
// walking the buckets twice and the second walk could disagree with the first.
CXStringSet *clang_HeaderMap_getKeys(CXHeaderMap HM);

LLVM_CLANG_C_EXTERN_C_END

#endif
