#ifndef LLVM_CLANG_C_EXTRA_CXHTMLREWRITE_H
#define LLVM_CLANG_C_EXTRA_CXHTMLREWRITE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::html -- namespace-level free functions; the namespace is the class segment of
// every name below. They introduce no handle of their own: each one MUTATES an existing
// Rewriter, turning the source of one FileID into HTML. The result is read back with
// clang_Rewriter_getRewriteBufferText, so the whole round trip stays in memory.
//
// PRECONDITION shared by every function taking a CXFileID: the FileID must be VALID and
// owned by the SourceManager the Rewriter (and, where one is passed, the Preprocessor) was
// built from -- the callees index that manager's tables with it.

/// Wrap [B, E] in StartTag/EndTag, splitting the tags per line when the range is
/// multiline. IsTokenRange extends E over the whole of the token that starts there.
///
/// PRECONDITION: B and E must be VALID and, after expansion, live in the SAME file --
/// upstream asserts `SM.getFileID(E) == SM.getFileID(B)`.
void clang_html_HighlightRange(CXRewriter R, CXSourceLocation_ B, CXSourceLocation_ E,
                               const char *StartTag, const char *EndTag,
                               bool IsTokenRange);

// HighlightRange (RewriteBuffer overload)
// -- takes a `RewriteBuffer &` plus decomposed offsets; RewriteBuffer is deliberately kept
// out of this C surface (see CXRewriter.h), and the Rewriter overload above covers it.

/// Rewrite FID in place so the characters HTML would otherwise read as markup become
/// entities. EscapeSpaces turns runs of spaces into non-breaking spaces and ReplaceTabs
/// expands tabs.
void clang_html_EscapeText(CXRewriter R, CXFileID FID, bool EscapeSpaces, bool ReplaceTabs);

/// The EscapeText(StringRef) overload: HTMLize a string instead of a file. Note the
/// different upstream default for ReplaceTabs (true there, always explicit here).
CXString clang_html_EscapeTextOfString(const char *S, bool EscapeSpaces, bool ReplaceTabs);

/// Prefix every line of FID with a numbered <td> cell.
void clang_html_AddLineNumbers(CXRewriter R, CXFileID FID);

/// Wrap FID in a complete HTML document -- <html><head> with clang's own built-in
/// stylesheet inlined, the given <title>, and the closing tags.
void clang_html_AddHeaderFooterInternalBuiltinCSS(CXRewriter R, CXFileID FID,
                                                  const char *title);

/// Relex FID with clang's own lexer and annotate keywords, comments, literals and
/// directives with <span class=...> tags. PP supplies the language options and the
/// SourceManager the relex runs against.
void clang_html_SyntaxHighlight(CXRewriter R, CXFileID FID, CXPreprocessor PP);

/// Re-expand the macros of FID and annotate each expansion with what it expanded to.
/// This reads the macro table as it stands NOW, so it is only meaningful once PP has
/// finished lexing the file; upstream describes the result as close, not exact.
void clang_html_HighlightMacros(CXRewriter R, CXFileID FID, CXPreprocessor PP);

LLVM_CLANG_C_EXTERN_C_END

#endif
