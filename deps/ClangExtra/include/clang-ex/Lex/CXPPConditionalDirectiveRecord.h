#ifndef LLVM_CLANG_C_EXTRA_CXPPCONDITIONALDIRECTIVERECORD_H
#define LLVM_CLANG_C_EXTRA_CXPPCONDITIONALDIRECTIVERECORD_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Records every #if/#ifdef/#ifndef/#else/#endif region the preprocessor walks, and answers
// which region a location fell in. What that buys a refactoring is the question "are these
// two locations separated by conditional compilation?", which decides whether text can be
// moved between them.
//
// This is a CONCRETE PPCallbacks subclass, so no callback trampoline is involved: the shim
// instantiates it and clang drives it.

// Creates the record over `PP`'s SourceManager and installs it in `PP`'s callback chain.
// It only sees directives lexed AFTER this call, so install it before entering the main
// file. ADOPTION: `addPPCallbacks` takes ownership, so the returned handle is BORROWED --
// it lives as long as the preprocessor and there is no dispose.
CXPPConditionalDirectiveRecord clang_PPConditionalDirectiveRecord_create(CXPreprocessor PP);

size_t clang_PPConditionalDirectiveRecord_getTotalMemory(CXPPConditionalDirectiveRecord R);

CXSourceManager
clang_PPConditionalDirectiveRecord_getSourceManager(CXPPConditionalDirectiveRecord R);

// True when `Range` crosses a conditional directive. A #if/#endif block wholly contained
// in `Range` does NOT count -- the question is whether the range is cut, not whether it
// contains conditionals. Total: an invalid range, or one spanning two files, is false.
bool clang_PPConditionalDirectiveRecord_rangeIntersectsConditionalDirective(
    CXPPConditionalDirectiveRecord R, CXSourceRange_ Range);

// The location of the conditional directive opening the region `Loc` belongs to; an
// invalid location when it is outside every region (or when `Loc` itself is invalid).
CXSourceLocation_ clang_PPConditionalDirectiveRecord_findConditionalDirectiveRegionLoc(
    CXPPConditionalDirectiveRecord R, CXSourceLocation_ Loc);

// True when the two locations sit in different conditional-directive regions, i.e. when
// code cannot be moved between them without changing what is compiled.
bool clang_PPConditionalDirectiveRecord_areInDifferentConditionalDirectiveRegion(
    CXPPConditionalDirectiveRecord R, CXSourceLocation_ LHS, CXSourceLocation_ RHS);

LLVM_CLANG_C_EXTERN_C_END

#endif
