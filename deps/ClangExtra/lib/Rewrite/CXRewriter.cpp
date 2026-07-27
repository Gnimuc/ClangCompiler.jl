#include "clang-ex/Rewrite/CXRewriter.h"

#include "utils.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "llvm/ADT/StringRef.h"

// Rewriter

CXRewriter clang_Rewriter_create(CXSourceManager SM, CXLangOptions LO) {
  return std::make_unique<clang::Rewriter>(*static_cast<clang::SourceManager *>(SM),
                                           *static_cast<clang::LangOptions *>(LO))
      .release();
}

void clang_Rewriter_dispose(CXRewriter R) { delete static_cast<clang::Rewriter *>(R); }

CXSourceManager clang_Rewriter_getSourceMgr(CXRewriter R) {
  return &static_cast<clang::Rewriter *>(R)->getSourceMgr();
}

bool clang_Rewriter_isRewritable(CXSourceLocation_ Loc) {
  return clang::Rewriter::isRewritable(clang::SourceLocation::getFromPtrEncoding(Loc));
}

int clang_Rewriter_getRangeSize(CXRewriter R, CXSourceRange_ Range) {
  return static_cast<clang::Rewriter *>(R)->getRangeSize(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)));
}

CXString clang_Rewriter_getRewrittenText(CXRewriter R, CXSourceRange_ Range) {
  return extra::makeCXString(static_cast<clang::Rewriter *>(R)->getRewrittenText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E))));
}

bool clang_Rewriter_InsertText(CXRewriter R, CXSourceLocation_ Loc, const char *Str,
                               bool InsertAfter, bool indentNewLines) {
  return static_cast<clang::Rewriter *>(R)->InsertText(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str), InsertAfter,
      indentNewLines);
}

bool clang_Rewriter_InsertTextAfter(CXRewriter R, CXSourceLocation_ Loc,
                                    const char *Str) {
  return static_cast<clang::Rewriter *>(R)->InsertTextAfter(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_InsertTextAfterToken(CXRewriter R, CXSourceLocation_ Loc,
                                         const char *Str) {
  return static_cast<clang::Rewriter *>(R)->InsertTextAfterToken(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_InsertTextBefore(CXRewriter R, CXSourceLocation_ Loc,
                                     const char *Str) {
  return static_cast<clang::Rewriter *>(R)->InsertTextBefore(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_RemoveText(CXRewriter R, CXSourceLocation_ Start, unsigned Length) {
  return static_cast<clang::Rewriter *>(R)->RemoveText(
      clang::SourceLocation::getFromPtrEncoding(Start), Length);
}

bool clang_Rewriter_RemoveTextInRange(CXRewriter R, CXSourceRange_ Range) {
  return static_cast<clang::Rewriter *>(R)->RemoveText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)));
}

bool clang_Rewriter_ReplaceText(CXRewriter R, CXSourceLocation_ Start,
                                unsigned OrigLength, const char *NewStr) {
  return static_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceLocation::getFromPtrEncoding(Start), OrigLength,
      llvm::StringRef(NewStr));
}

bool clang_Rewriter_ReplaceTextInRange(CXRewriter R, CXSourceRange_ Range,
                                       const char *NewStr) {
  return static_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      llvm::StringRef(NewStr));
}

bool clang_Rewriter_ReplaceTextInRangeWithRange(CXRewriter R, CXSourceRange_ Range,
                                                CXSourceRange_ ReplacementRange) {
  return static_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(ReplacementRange.B),
                         clang::SourceLocation::getFromPtrEncoding(ReplacementRange.E)));
}

bool clang_Rewriter_IncreaseIndentation(CXRewriter R, CXSourceRange_ Range,
                                        CXSourceLocation_ ParentIndent) {
  return static_cast<clang::Rewriter *>(R)->IncreaseIndentation(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      clang::SourceLocation::getFromPtrEncoding(ParentIndent));
}

bool clang_Rewriter_overwriteChangedFiles(CXRewriter R) {
  return static_cast<clang::Rewriter *>(R)->overwriteChangedFiles();
}

// setSourceMgr
// getLangOpts
// getEditBuffer
// getRewriteBufferFor
// buffer_begin
// buffer_end
