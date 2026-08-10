#ifndef LLVM_CLANG_C_EXTRA_CXHEADERANALYSIS_H
#define LLVM_CLANG_C_EXTRA_CXHEADERANALYSIS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Free functions in clang::tooling, so the namespace is the leading segment.

/// Whether FE names a header that compiles on its own: it has a header guard, or has been
/// #imported, or contains #imports -- and carries no dont-include-me pattern. HeaderInfo
/// must be the HeaderSearch that SM's preprocessor uses, since the guard state is read out
/// of its per-file info. Can be expensive: it may fall back to scanning the file's text.
bool clang_tooling_isSelfContainedHeader(CXFileEntryRef FE, CXSourceManager SM,
                                         CXHeaderSearch HeaderInfo);

/// Whether Code contains any #import directive.
bool clang_tooling_codeContainsImports(const char *Code);

/// If Text begins an include-what-you-use directive, the directive itself: "// IWYU pragma:
/// keep" answers "keep". clang returns std::optional<StringRef>; the shim splits it -- when
/// OutFound is non-NULL it receives whether there was a pragma at all, and the CXString is
/// empty when there was not. Only the first line of a multi-line comment is considered.
/// Text must be NUL-terminated: clang deliberately takes a char* here so that it never
/// scans for a length, which is what makes it cheap to call on SM.getCharacterData().
CXString clang_tooling_parseIWYUPragma(const char *Text, bool *OutFound);

LLVM_CLANG_C_EXTERN_C_END

#endif
