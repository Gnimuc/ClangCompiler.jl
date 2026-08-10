#ifndef LLVM_CLANG_C_EXTRA_CXCOMMIT_H
#define LLVM_CLANG_C_EXTRA_CXCOMMIT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Commit
//
// A batch of source edits that is accepted or rejected AS A WHOLE. This is what plain
// Rewriter cannot do: a Commit knows about macro expansions -- it can rewrite through a
// macro ARGUMENT, refuses to rewrite a location that only exists inside a macro BODY, and
// the moment one edit in the batch is refused the whole batch stops being commitable, so
// no half-applied rewrite can reach the source.
//
// A CharSourceRange crosses as its CXSourceRange_ plus a separate token-range flag: true
// makes the range cover the whole of the token that starts at its end location, false
// makes the end an exclusive character offset.
//
// RETURN CONVENTION, opposite to Rewriter's: every edit below returns TRUE on SUCCESS and
// FALSE when the edit could not be expressed. A false also latches isCommitable to false.

/// Create a Commit whose edits will be applied through Editor. Caller-owned: pair with
/// clang_Commit_dispose. The Commit stores raw references to Editor and to the
/// SourceManager/LangOptions behind it, so it must be disposed before them.
CXCommit clang_Commit_create(CXEditedSource Editor);

// Commit(const SourceManager &, const LangOptions &, const PPConditionalDirectiveRecord *)
// -- the editor-less constructor. Not wrapped: a Commit built that way has no
// EditedSource to commit to, so nothing this API can do with it is observable.

void clang_Commit_dispose(CXCommit C);

/// False once any edit in the batch has been refused. clang_EditedSource_commit rejects a
/// Commit for which this is false, leaving the edited source untouched.
bool clang_Commit_isCommitable(CXCommit C);

/// Insert Text at Loc. AfterToken puts it after the whole token that starts at Loc rather
/// than at Loc itself; BeforePreviousInsertions orders it ahead of text already inserted
/// at the same point. An empty Text succeeds and records nothing.
bool clang_Commit_insert(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                         bool AfterToken, bool BeforePreviousInsertions);

bool clang_Commit_insertAfterToken(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                                   bool BeforePreviousInsertions);

bool clang_Commit_insertBefore(CXCommit C, CXSourceLocation_ Loc, const char *Text);

/// Insert at Loc a copy of the source text currently covered by Range.
bool clang_Commit_insertFromRange(CXCommit C, CXSourceLocation_ Loc, CXSourceRange_ Range,
                                  bool IsTokenRange, bool AfterToken,
                                  bool BeforePreviousInsertions);

/// Surround Range with Before and After.
bool clang_Commit_insertWrap(CXCommit C, const char *Before, CXSourceRange_ Range,
                             bool IsTokenRange, const char *After);

bool clang_Commit_remove(CXCommit C, CXSourceRange_ Range, bool IsTokenRange);

bool clang_Commit_replace(CXCommit C, CXSourceRange_ Range, bool IsTokenRange,
                          const char *Text);

/// Replace Range with the text of InnerRange, which must lie inside it -- the shape of
/// "drop the call and keep its argument".
bool clang_Commit_replaceWithInner(CXCommit C, CXSourceRange_ Range, bool IsTokenRange,
                                   CXSourceRange_ InnerRange, bool InnerIsTokenRange);

/// Replace the token spelled Text at Loc with ReplacementText. Both empty strings succeed
/// and record nothing.
bool clang_Commit_replaceText(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                              const char *ReplacementText);

// edit_begin
// edit_end
// -- iteration over Commit::Edit, a struct of private-by-convention bookkeeping (the
// FileOffsets the accessors above computed). The observable result of a Commit is the
// text clang_EditedSource_applyRewrites produces, not its edit list.

LLVM_CLANG_C_EXTERN_C_END

#endif
