#include "clang-ex/Rewrite/CXHTMLRewrite.h"

#include "utils.h"

#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Rewrite/Core/HTMLRewrite.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "llvm/ADT/StringRef.h"

// html

void clang_html_HighlightRange(CXRewriter R, CXSourceLocation_ B, CXSourceLocation_ E,
                               const char *StartTag, const char *EndTag,
                               bool IsTokenRange) {
  clang::html::HighlightRange(*reinterpret_cast<clang::Rewriter *>(R),
                              clang::SourceLocation::getFromPtrEncoding(B),
                              clang::SourceLocation::getFromPtrEncoding(E), StartTag,
                              EndTag, IsTokenRange);
}

void clang_html_EscapeText(CXRewriter R, CXFileID FID, bool EscapeSpaces,
                           bool ReplaceTabs) {
  clang::html::EscapeText(*reinterpret_cast<clang::Rewriter *>(R),
                          *reinterpret_cast<clang::FileID *>(FID), EscapeSpaces,
                          ReplaceTabs);
}

CXString clang_html_EscapeTextOfString(const char *S, bool EscapeSpaces,
                                       bool ReplaceTabs) {
  return extra::makeCXString(
      clang::html::EscapeText(llvm::StringRef(S), EscapeSpaces, ReplaceTabs));
}

void clang_html_AddLineNumbers(CXRewriter R, CXFileID FID) {
  clang::html::AddLineNumbers(*reinterpret_cast<clang::Rewriter *>(R),
                              *reinterpret_cast<clang::FileID *>(FID));
}

void clang_html_AddHeaderFooterInternalBuiltinCSS(CXRewriter R, CXFileID FID,
                                                  const char *title) {
  clang::html::AddHeaderFooterInternalBuiltinCSS(
      *reinterpret_cast<clang::Rewriter *>(R), *reinterpret_cast<clang::FileID *>(FID),
      llvm::StringRef(title));
}

void clang_html_SyntaxHighlight(CXRewriter R, CXFileID FID, CXPreprocessor PP) {
  clang::html::SyntaxHighlight(*reinterpret_cast<clang::Rewriter *>(R),
                               *reinterpret_cast<clang::FileID *>(FID),
                               *reinterpret_cast<clang::Preprocessor *>(PP));
}

void clang_html_HighlightMacros(CXRewriter R, CXFileID FID, CXPreprocessor PP) {
  clang::html::HighlightMacros(*reinterpret_cast<clang::Rewriter *>(R),
                               *reinterpret_cast<clang::FileID *>(FID),
                               *reinterpret_cast<clang::Preprocessor *>(PP));
}
