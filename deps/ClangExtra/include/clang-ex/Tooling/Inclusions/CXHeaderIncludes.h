#ifndef LLVM_CLANG_C_EXTRA_CXHEADERINCLUDES_H
#define LLVM_CLANG_C_EXTRA_CXHEADERINCLUDES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// IncludeCategoryManager

/// Caller-owned: pair with clang_IncludeCategoryManager_dispose. Style is COPIED into the
/// manager (its member is `const IncludeStyle Style`, by value), so the CXIncludeStyle may
/// be disposed straight away. FileName decides which include counts as the main header.
CXIncludeCategoryManager clang_IncludeCategoryManager_create(CXIncludeStyle Style,
                                                             const char *FileName);

void clang_IncludeCategoryManager_dispose(CXIncludeCategoryManager M);

/// The priority of the category IncludeName falls in -- 0 for the main header when
/// CheckMainHeader is set, INT_MAX when no category regex matches. IncludeName carries its
/// quotes or angle brackets, e.g. "<vector>".
/// NOTE: clang documents this as not thread-safe; it matches against regexes it mutates.
int clang_IncludeCategoryManager_getIncludePriority(CXIncludeCategoryManager M,
                                                    const char *IncludeName,
                                                    bool CheckMainHeader);

/// Same, but reporting the category's SortPriority rather than its Priority.
int clang_IncludeCategoryManager_getSortIncludePriority(CXIncludeCategoryManager M,
                                                        const char *IncludeName,
                                                        bool CheckMainHeader);

// isMainHeader is private.

// Mirror of `clang::tooling::IncludeDirective`
// (clang/Tooling/Inclusions/HeaderIncludes.h).
typedef enum CXIncludeDirective {
  CXIncludeDirective_Include,
  CXIncludeDirective_Import
} CXIncludeDirective;

// HeaderIncludes

/// Scans Code once and records where each existing #include/#import lives, so the
/// insert/remove pair below can answer in terms of that layout. FileName is the name the
/// code would be compiled under -- it is what makes one of the includes the main header.
/// Style is copied. Caller-owned: pair with clang_HeaderIncludes_dispose.
CXHeaderIncludes clang_HeaderIncludes_create(const char *FileName, const char *Code,
                                             CXIncludeStyle Style);

void clang_HeaderIncludes_dispose(CXHeaderIncludes HI);

/// The edit that adds `#include <Header>` (IsAngled) or `#include "Header"` in the right
/// block for its category, respecting the order of the includes already there. clang
/// returns std::optional<Replacement>; NULL here is the nullopt, which means Header is
/// already included with exactly this spelling AND the same directive. Caller-owned
/// Replacement otherwise -- dispose it with clang_Replacement_dispose.
/// PRECONDITION: Header is the bare name with no quoting -- "vector", not "<vector>".
/// IsAngled is what supplies the brackets, and clang asserts the name is already trimmed.
CXReplacement clang_HeaderIncludes_insert(CXHeaderIncludes HI, const char *Header,
                                          bool IsAngled, CXIncludeDirective Directive);

/// The edits that delete every existing #include/#import of Header with this quoting. This
/// does not resolve paths: only an exactly equal spelling is removed. Header is the bare
/// name, exactly as for insert above. The returned set is
/// caller-owned -- dispose it with clang_Replacements_dispose -- and is empty when there is
/// nothing to remove.
CXReplacements clang_HeaderIncludes_remove(CXHeaderIncludes HI, const char *Header,
                                           bool IsAngled);

// IncludeRegex

LLVM_CLANG_C_EXTERN_C_END

#endif
