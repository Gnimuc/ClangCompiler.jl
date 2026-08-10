#ifndef LLVM_CLANG_C_EXTRA_CXINCLUDESTYLE_H
#define LLVM_CLANG_C_EXTRA_CXINCLUDESTYLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::tooling::IncludeStyle::IncludeBlocksStyle`
// (clang/Tooling/Inclusions/IncludeStyle.h).
typedef enum CXIncludeBlocksStyle {
  CXIncludeBlocksStyle_IBS_Preserve,
  CXIncludeBlocksStyle_IBS_Merge,
  CXIncludeBlocksStyle_IBS_Regroup
} CXIncludeBlocksStyle;

// IncludeStyle
//
// A plain settings struct with no member functions, so every entry point below is a field
// accessor rather than a wrapped method. It is also a struct with no in-class initialisers:
// a default-constructed one leaves IncludeBlocks and both regexes indeterminate, which is
// why the shim seeds it from clang-format's own LLVM style instead of value-initialising.
// Only the fields HeaderIncludes actually consults are exposed; the struct grows across
// releases and mirroring it whole would be a standing merge conflict.

/// Caller-owned copy of clang-format's LLVM include style: IBS_Preserve, the three LLVM
/// include categories, and IncludeIsMainRegex = "(Test)?$". Pair with
/// clang_IncludeStyle_dispose.
CXIncludeStyle clang_IncludeStyle_create(void);

void clang_IncludeStyle_dispose(CXIncludeStyle IS);

CXIncludeBlocksStyle clang_IncludeStyle_getIncludeBlocks(CXIncludeStyle IS);

void clang_IncludeStyle_setIncludeBlocks(CXIncludeStyle IS, CXIncludeBlocksStyle S);

CXString clang_IncludeStyle_getIncludeIsMainRegex(CXIncludeStyle IS);

void clang_IncludeStyle_setIncludeIsMainRegex(CXIncludeStyle IS, const char *Regex);

CXString clang_IncludeStyle_getIncludeIsMainSourceRegex(CXIncludeStyle IS);

void clang_IncludeStyle_setIncludeIsMainSourceRegex(CXIncludeStyle IS, const char *Regex);

/// IncludeCategories, as the usual count plus indexed reads. The four accessors below all
/// have the same PRECONDITION: I < clang_IncludeStyle_getNumIncludeCategories(IS).
unsigned clang_IncludeStyle_getNumIncludeCategories(CXIncludeStyle IS);

CXString clang_IncludeStyle_getIncludeCategoryRegex(CXIncludeStyle IS, unsigned I);

int clang_IncludeStyle_getIncludeCategoryPriority(CXIncludeStyle IS, unsigned I);

int clang_IncludeStyle_getIncludeCategorySortPriority(CXIncludeStyle IS, unsigned I);

bool clang_IncludeStyle_getIncludeCategoryRegexIsCaseSensitive(CXIncludeStyle IS,
                                                               unsigned I);

/// Appends one IncludeCategory. Categories are matched in order, so this puts the new one
/// last -- clear and rebuild the list to control the order.
void clang_IncludeStyle_addIncludeCategory(CXIncludeStyle IS, const char *Regex,
                                           int Priority, int SortPriority,
                                           bool RegexIsCaseSensitive);

void clang_IncludeStyle_clearIncludeCategories(CXIncludeStyle IS);

LLVM_CLANG_C_EXTERN_C_END

#endif
