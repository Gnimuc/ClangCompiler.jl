#ifndef LLVM_CLANG_C_EXTRA_CXREWRITER_H
#define LLVM_CLANG_C_EXTRA_CXREWRITER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Rewriter

/// Create a Rewriter bound to SM/LO. Caller-owned: pair with clang_Rewriter_dispose.
/// The Rewriter stores raw references to both, so it must be disposed before the
/// SourceManager it was built from.
CXRewriter clang_Rewriter_create(CXSourceManager SM, CXLangOptions LO);

// The language options the rewriter was created with, borrowed. Every Rewriter this API can
// build comes from clang_Rewriter_create, which always stores a non-null LangOptions; clang's
// own default-constructed Rewriter leaves it null, and that one is unreachable from here.
CXLangOptions clang_Rewriter_getLangOpts(CXRewriter R);

void clang_Rewriter_dispose(CXRewriter R);

CXSourceManager clang_Rewriter_getSourceMgr(CXRewriter R);

/// Rewriter::isRewritable (static) -- true for raw file locations only; macro
/// locations are not rewritable.
/// NOTE: this is SourceLocation::isFileID, which is also true for an INVALID
/// location (raw encoding 0 carries no macro bit). Validity is a separate check
/// the Julia wrapper must make.
bool clang_Rewriter_isRewritable(CXSourceLocation_ Loc);

/// PRECONDITION: both endpoints of Range must be VALID SourceLocations --
/// Rewriter::getLocationOffsetAndFileID asserts on an invalid one. Returns -1 when
/// the endpoints are unrewritable or live in different files.
int clang_Rewriter_getRangeSize(CXRewriter R, CXSourceRange_ Range);

/// PRECONDITION: both endpoints of Range must be VALID SourceLocations (same assert
/// as getRangeSize). Returns the empty string when the range is unrewritable or spans
/// two buffers.
CXString clang_Rewriter_getRewrittenText(CXRewriter R, CXSourceRange_ Range);

/// The Insert*/Remove*/Replace* family below returns true on FAILURE (the location
/// was not rewritable) and false on success.
/// PRECONDITION for all of them: every SourceLocation argument must be VALID; the
/// underlying getLocationOffsetAndFileID asserts otherwise.
bool clang_Rewriter_InsertText(CXRewriter R, CXSourceLocation_ Loc, const char *Str,
                               bool InsertAfter, bool indentNewLines);

bool clang_Rewriter_InsertTextAfter(CXRewriter R, CXSourceLocation_ Loc,
                                    const char *Str);

bool clang_Rewriter_InsertTextAfterToken(CXRewriter R, CXSourceLocation_ Loc,
                                         const char *Str);

bool clang_Rewriter_InsertTextBefore(CXRewriter R, CXSourceLocation_ Loc,
                                     const char *Str);

bool clang_Rewriter_RemoveText(CXRewriter R, CXSourceLocation_ Start, unsigned Length);

/// RemoveText(SourceRange) overload.
bool clang_Rewriter_RemoveTextInRange(CXRewriter R, CXSourceRange_ Range);

bool clang_Rewriter_ReplaceText(CXRewriter R, CXSourceLocation_ Start,
                                unsigned OrigLength, const char *NewStr);

/// ReplaceText(SourceRange, StringRef) overload.
bool clang_Rewriter_ReplaceTextInRange(CXRewriter R, CXSourceRange_ Range,
                                       const char *NewStr);

/// ReplaceText(SourceRange, SourceRange) overload -- replaces Range with the current
/// text of ReplacementRange.
bool clang_Rewriter_ReplaceTextInRangeWithRange(CXRewriter R, CXSourceRange_ Range,
                                                CXSourceRange_ ReplacementRange);

/// PRECONDITION: ParentIndent must be a valid location one indentation degree lower
/// than Range.
bool clang_Rewriter_IncreaseIndentation(CXRewriter R, CXSourceRange_ Range,
                                        CXSourceLocation_ ParentIndent);

/// Save all changed buffers to disk; true if any file failed to save. Diagnostics go
/// through the SourceManager's DiagnosticsEngine.
bool clang_Rewriter_overwriteChangedFiles(CXRewriter R);

// setSourceMgr
// getLangOpts
// getEditBuffer
// getRewriteBufferFor
// buffer_begin
// buffer_end

LLVM_CLANG_C_EXTERN_C_END

#endif
