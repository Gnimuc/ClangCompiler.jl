#ifndef LLVM_CLANG_C_EXTRA_CXHEADERSEARCHOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXHEADERSEARCHOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

size_t clang_HeaderSearchOptions_GetResourceDirLength(CXHeaderSearchOptions HSO);

void clang_HeaderSearchOptions_GetResourceDir(CXHeaderSearchOptions HSO, char *ResourcesDir,
                                              size_t N);

void clang_HeaderSearchOptions_SetResourceDir(CXHeaderSearchOptions HSO,
                                              const char *ResourcesDir, size_t N);

// `HeaderSearchOptions` is a plain option bag with public data members, so each pair below
// is named for the field it reads and writes. UserEntries is deliberately absent: an entry
// is a struct with its own group/framework/ignore-sysroot flags, and
// `clang_HeaderSearch_*` already drives the search path a CompilerInstance ends up with.

// The path the driver prefixes to system include paths ("/" by default).
CXString clang_HeaderSearchOptions_getSysroot(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setSysroot(CXHeaderSearchOptions HSO, const char *Sysroot);

// Where implicitly-built module files are cached; empty disables implicit module builds.
CXString clang_HeaderSearchOptions_getModuleCachePath(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setModuleCachePath(CXHeaderSearchOptions HSO,
                                                  const char *Path);

// Use the compiler's own builtin headers (the resource directory's include/).
bool clang_HeaderSearchOptions_getUseBuiltinIncludes(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setUseBuiltinIncludes(CXHeaderSearchOptions HSO, bool Value);

bool clang_HeaderSearchOptions_getUseStandardSystemIncludes(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setUseStandardSystemIncludes(CXHeaderSearchOptions HSO,
                                                            bool Value);

bool clang_HeaderSearchOptions_getUseStandardCXXIncludes(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setUseStandardCXXIncludes(CXHeaderSearchOptions HSO,
                                                         bool Value);

// Print each header search attempt to stderr, as `-v` does.
bool clang_HeaderSearchOptions_getVerbose(CXHeaderSearchOptions HSO);
void clang_HeaderSearchOptions_setVerbose(CXHeaderSearchOptions HSO, bool Value);

void clang_HeaderSearchOptions_PrintStats(CXHeaderSearchOptions HSO);

LLVM_CLANG_C_EXTERN_C_END

#endif