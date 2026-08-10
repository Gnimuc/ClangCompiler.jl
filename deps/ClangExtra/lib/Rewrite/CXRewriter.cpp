#include "clang-ex/Rewrite/CXRewriter.h"

#include "utils.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Rewrite/Core/RewriteBuffer.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"

#include <iterator>
#include <memory>
#include <string>

// Rewriter

CXRewriter clang_Rewriter_create(CXSourceManager SM, CXLangOptions LO) {
  return reinterpret_cast<CXRewriter>(std::make_unique<clang::Rewriter>(*reinterpret_cast<clang::SourceManager *>(SM),
                                           *reinterpret_cast<clang::LangOptions *>(LO))
      .release());
}

void clang_Rewriter_dispose(CXRewriter R) { delete reinterpret_cast<clang::Rewriter *>(R); }

void clang_Rewriter_setSourceMgr(CXRewriter R, CXSourceManager SM, CXLangOptions LO) {
  reinterpret_cast<clang::Rewriter *>(R)->setSourceMgr(
      *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::LangOptions *>(LO));
}

CXSourceManager clang_Rewriter_getSourceMgr(CXRewriter R) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::Rewriter *>(R)->getSourceMgr());
}

bool clang_Rewriter_isRewritable(CXSourceLocation_ Loc) {
  return clang::Rewriter::isRewritable(clang::SourceLocation::getFromPtrEncoding(Loc));
}

int clang_Rewriter_getRangeSize(CXRewriter R, CXSourceRange_ Range) {
  return reinterpret_cast<clang::Rewriter *>(R)->getRangeSize(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)));
}

CXString clang_Rewriter_getRewrittenText(CXRewriter R, CXSourceRange_ Range) {
  return extra::makeCXString(reinterpret_cast<clang::Rewriter *>(R)->getRewrittenText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E))));
}

bool clang_Rewriter_InsertText(CXRewriter R, CXSourceLocation_ Loc, const char *Str,
                               bool InsertAfter, bool indentNewLines) {
  return reinterpret_cast<clang::Rewriter *>(R)->InsertText(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str), InsertAfter,
      indentNewLines);
}

bool clang_Rewriter_InsertTextAfter(CXRewriter R, CXSourceLocation_ Loc,
                                    const char *Str) {
  return reinterpret_cast<clang::Rewriter *>(R)->InsertTextAfter(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_InsertTextAfterToken(CXRewriter R, CXSourceLocation_ Loc,
                                         const char *Str) {
  return reinterpret_cast<clang::Rewriter *>(R)->InsertTextAfterToken(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_InsertTextBefore(CXRewriter R, CXSourceLocation_ Loc,
                                     const char *Str) {
  return reinterpret_cast<clang::Rewriter *>(R)->InsertTextBefore(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Str));
}

bool clang_Rewriter_RemoveText(CXRewriter R, CXSourceLocation_ Start, unsigned Length) {
  return reinterpret_cast<clang::Rewriter *>(R)->RemoveText(
      clang::SourceLocation::getFromPtrEncoding(Start), Length);
}

bool clang_Rewriter_RemoveTextInRange(CXRewriter R, CXSourceRange_ Range) {
  return reinterpret_cast<clang::Rewriter *>(R)->RemoveText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)));
}

bool clang_Rewriter_ReplaceText(CXRewriter R, CXSourceLocation_ Start,
                                unsigned OrigLength, const char *NewStr) {
  return reinterpret_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceLocation::getFromPtrEncoding(Start), OrigLength,
      llvm::StringRef(NewStr));
}

bool clang_Rewriter_ReplaceTextInRange(CXRewriter R, CXSourceRange_ Range,
                                       const char *NewStr) {
  return reinterpret_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      llvm::StringRef(NewStr));
}

bool clang_Rewriter_ReplaceTextInRangeWithRange(CXRewriter R, CXSourceRange_ Range,
                                                CXSourceRange_ ReplacementRange) {
  return reinterpret_cast<clang::Rewriter *>(R)->ReplaceText(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(ReplacementRange.B),
                         clang::SourceLocation::getFromPtrEncoding(ReplacementRange.E)));
}

bool clang_Rewriter_IncreaseIndentation(CXRewriter R, CXSourceRange_ Range,
                                        CXSourceLocation_ ParentIndent) {
  return reinterpret_cast<clang::Rewriter *>(R)->IncreaseIndentation(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      clang::SourceLocation::getFromPtrEncoding(ParentIndent));
}

// getEditBuffer -- RewriteBuffer stays out of the C surface; see CXRewriter.h.

bool clang_Rewriter_hasChangesForFileID(CXRewriter R, CXFileID FID) {
  return reinterpret_cast<clang::Rewriter *>(R)->getRewriteBufferFor(
             *reinterpret_cast<clang::FileID *>(FID)) != nullptr;
}

CXString clang_Rewriter_getRewriteBufferText(CXRewriter R, CXFileID FID) {
  const clang::RewriteBuffer *Buf =
      reinterpret_cast<clang::Rewriter *>(R)->getRewriteBufferFor(
          *reinterpret_cast<clang::FileID *>(FID));
  if (!Buf)
    return extra::makeCXString("");
  std::string S;
  llvm::raw_string_ostream OS(S);
  Buf->write(OS);
  OS.flush();
  return extra::makeCXString(S);
}

unsigned clang_Rewriter_getNumBuffers(CXRewriter R) {
  clang::Rewriter *Rw = reinterpret_cast<clang::Rewriter *>(R);
  return static_cast<unsigned>(std::distance(Rw->buffer_begin(), Rw->buffer_end()));
}

CXFileID clang_Rewriter_getBufferFileID(CXRewriter R, unsigned Idx) {
  clang::Rewriter *Rw = reinterpret_cast<clang::Rewriter *>(R);
  clang::Rewriter::buffer_iterator I = Rw->buffer_begin();
  std::advance(I, Idx);
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(I->first).release());
}

bool clang_Rewriter_overwriteChangedFiles(CXRewriter R) {
  return reinterpret_cast<clang::Rewriter *>(R)->overwriteChangedFiles();
}

CXLangOptions clang_Rewriter_getLangOpts(CXRewriter R) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(&reinterpret_cast<clang::Rewriter *>(R)->getLangOpts()));
}
