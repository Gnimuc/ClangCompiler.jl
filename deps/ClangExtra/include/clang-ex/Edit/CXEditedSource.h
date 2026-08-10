#ifndef LLVM_CLANG_C_EXTRA_CXEDITEDSOURCE_H
#define LLVM_CLANG_C_EXTRA_CXEDITEDSOURCE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// EditedSource
//
// The accumulator a Commit commits INTO: it holds the accepted edits for a whole
// translation unit, keyed on file offsets, and knows how to fold several edits that land
// in the same macro argument into one consistent rewrite. Commits are atomic against it --
// clang_EditedSource_commit either records every edit of the batch or none of them.

/// Create an EditedSource over SM/LangOpts. Caller-owned: pair with
/// clang_EditedSource_dispose. Both are stored as raw references and must outlive it, and
/// so must every Commit created against it.
///
/// Upstream's optional PPConditionalDirectiveRecord (which would keep edits from crossing
/// an #if boundary) is not exposed; this passes null, as clang's own callers do when they
/// have no preprocessing record.
CXEditedSource clang_EditedSource_create(CXSourceManager SM, CXLangOptions LangOpts);

void clang_EditedSource_dispose(CXEditedSource E);

/// Borrowed -- never dispose through these.
CXSourceManager clang_EditedSource_getSourceManager(CXEditedSource E);

CXLangOptions clang_EditedSource_getLangOpts(CXEditedSource E);

// getPPCondDirectiveRecord -- always null here; see clang_EditedSource_create.

/// Whether an insertion at the file offset (FID, Offs) reached from OrigLoc would be
/// consistent with the edits already recorded. A FileOffset crosses as its FileID plus the
/// byte offset within it.
bool clang_EditedSource_canInsertInOffset(CXEditedSource E, CXSourceLocation_ OrigLoc,
                                          CXFileID FID, unsigned Offs);

/// Record every edit of C, or none. Returns false when C is not commitable (some edit in
/// it was refused) or when one of its edits conflicts with what is already recorded; the
/// edited source is left exactly as it was in both cases.
bool clang_EditedSource_commit(CXEditedSource E, CXCommit C);

/// Replay the accumulated edits into R. This is the extraction path: clang's
/// edit::EditsReceiver is a pure-virtual sink, and libclangex compiles ONE fixed
/// implementation of it that forwards `insert` to Rewriter::InsertText and `replace` to
/// Rewriter::ReplaceText -- the same adapter clang's own migrator uses. Read the result
/// back with clang_Rewriter_getRewriteBufferText.
///
/// AdjustRemovals widens a removal to swallow the whitespace and trailing comment left
/// behind, which is what makes deletions look hand-written.
///
/// R and E must be built over the SAME SourceManager; the offsets replayed here are that
/// manager's.
void clang_EditedSource_applyRewrites(CXEditedSource E, CXRewriter R, bool AdjustRemovals);

/// Drop every accumulated edit, leaving E as freshly created.
void clang_EditedSource_clearRewrites(CXEditedSource E);

// copyString -- interns a string in the EditedSource's own allocator. It exists so that
// clang's in-tree rewriters can hand a Commit a StringRef that outlives the caller's
// buffer; every string crossing this boundary is copied by the shim already.

LLVM_CLANG_C_EXTERN_C_END

#endif
