#ifndef LLVM_CLANG_C_EXTRA_CXTOKENS_H
#define LLVM_CLANG_C_EXTRA_CXTOKENS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Everything here lives in clang::syntax, and the namespace is part of the C name:
// `syntax::Token` is a different class from `clang::Token`, which already owns CXToken_.

// syntax::FileRange
// Not given a handle: it is a (FileID, begin offset, end offset) triple, and the two places
// it crosses below spell it out as those three values.

// syntax::Token

/// The raw `clang::tok::TokenKind` value, exactly as clang_Token_getKind reports it for a
/// `clang::Token` -- the kind enum is not mirrored, `clang_tok_getTokenName` names it.
unsigned clang_syntax_Token_kind(CXSyntaxToken T);

/// Location of the token's first character.
CXSourceLocation_ clang_syntax_Token_location(CXSyntaxToken T);

/// Location just past the token's last character.
CXSourceLocation_ clang_syntax_Token_endLocation(CXSyntaxToken T);

unsigned clang_syntax_Token_length(CXSyntaxToken T);

/// The source text the token covers, digraphs and line continuations included -- `int` and
/// `in\<newline>t` are both tok::kw_int but spell differently.
/// PRECONDITION: SM must be the SourceManager the token's location came from.
CXString clang_syntax_Token_text(CXSyntaxToken T, CXSourceManager SM);

/// Token::str -- the debugging form, kind and length but no text.
CXString clang_syntax_Token_str(CXSyntaxToken T);

// range (both overloads)
// dumpForTests

// A shim-owned std::vector<syntax::Token>. clang has no such class, and one is needed
// because every token sequence below is either returned by value or is an ArrayRef into
// storage whose lifetime the caller cannot see; syntax::Token is a small trivially copyable
// value, so the shim copies rather than borrows.

unsigned clang_syntax_TokenList_getNumTokens(CXSyntaxTokenList TL);

/// BORROWED from the list: valid until the list is disposed, and never disposed itself.
/// Returns NULL when I is out of range.
CXSyntaxToken clang_syntax_TokenList_getToken(CXSyntaxTokenList TL, unsigned I);

void clang_syntax_TokenList_dispose(CXSyntaxTokenList TL);

/// syntax::tokenize(FileID, const SourceManager &, const LangOptions &) -- lexes the whole
/// buffer in RAW mode: no preprocessing at all, so directives and disabled branches come
/// back as ordinary tokens and macros are not expanded. There is no trailing eof token.
/// Caller-owned list.
/// PRECONDITION: FID must be valid and known to SM.
CXSyntaxTokenList clang_syntax_tokenize(CXFileID FID, CXSourceManager SM, CXLangOptions LO);

/// The syntax::tokenize(const FileRange &, ...) overload, with the FileRange spelled out.
/// The first token may be incomplete when BeginOffset is not on a token boundary, and the
/// last one may run past EndOffset. Caller-owned list.
/// PRECONDITION: FID valid and BeginOffset <= EndOffset, which is what FileRange expects.
CXSyntaxTokenList clang_syntax_tokenizeFileRange(CXFileID FID, unsigned BeginOffset,
                                                 unsigned EndOffset, CXSourceManager SM,
                                                 CXLangOptions LO);

// syntax::TokenBuffer
//
// Only clang_syntax_TokenCollector_consume produces one. That is deliberate: the accessors
// keyed on a FileID assert that the buffer tracks that file, which is only true of the
// files a real collection ran over, and clang's public TokenBuffer(SourceManager&) would
// hand out an empty buffer that fails every one of them.

/// expandedTokens() -- the post-preprocessing stream, in translation-unit order, ending in
/// an eof token. These are the tokens AST source locations point at. Caller-owned list.
CXSyntaxTokenList clang_syntax_TokenBuffer_expandedTokens(CXTokenBuffer TB);

/// The expandedTokens(SourceRange) overload: the subrange covered by the closed token range
/// R. An invalid range answers an empty list. Caller-owned list.
CXSyntaxTokenList clang_syntax_TokenBuffer_expandedTokensInRange(CXTokenBuffer TB,
                                                                 CXSourceRange_ R);

/// Builds the index that makes expandedTokensInRange fast. Idempotent.
void clang_syntax_TokenBuffer_indexExpandedTokens(CXTokenBuffer TB);

/// spelledTokens(FileID) -- the file's tokens as written, before any macro replacement,
/// including the tokens of every preprocessor directive. Caller-owned list.
/// PRECONDITION: FID must be a file this buffer tracks, i.e. one the collected
/// preprocessing actually read. clang asserts otherwise.
CXSyntaxTokenList clang_syntax_TokenBuffer_spelledTokens(CXTokenBuffer TB, CXFileID FID);

/// The spelled token that starts exactly at Loc, or NULL when none does. BORROWED from the
/// buffer.
/// PRECONDITION: Loc must be a valid file (non-macro) location in a file this buffer
/// tracks -- the lookup goes through spelledTokens and inherits its assert.
CXSyntaxToken clang_syntax_TokenBuffer_spelledTokenAt(CXTokenBuffer TB,
                                                      CXSourceLocation_ Loc);

/// spelledForExpanded() over the half-open index range [Begin, Begin+Count) of
/// expandedTokens(): the tokens as written that produced those expanded tokens, which is
/// the text a refactoring would have to replace. Returns NULL when the range is empty, out
/// of bounds, or does not correspond to a whole run of spelled tokens (`a f1` out of
/// `a FIRST` cannot be mapped). Caller-owned list otherwise.
CXSyntaxTokenList clang_syntax_TokenBuffer_spelledForExpanded(CXTokenBuffer TB,
                                                              unsigned Begin,
                                                              unsigned Count);

/// The SourceManager the buffer was collected against, borrowed.
CXSourceManager clang_syntax_TokenBuffer_sourceManager(CXTokenBuffer TB);

CXString clang_syntax_TokenBuffer_dumpForTests(CXTokenBuffer TB);

void clang_syntax_TokenBuffer_dispose(CXTokenBuffer TB);

// expandedForSpelled
// expansionStartingAt
// expansionsOverlapping
// macroExpansions
// spelledTokensTouching
// spelledIdentifierTouching

// syntax::TokenCollector

/// LIFECYCLE -- the collector installs its own PPCallbacks and token watcher on PP inside
/// this call, so it has to exist BEFORE preprocessing starts (clang's own users build one
/// in FrontendAction::BeginSourceFile) and it must not outlive PP. Caller-owned.
CXTokenCollector clang_syntax_TokenCollector_create(CXPreprocessor PP);

/// TokenCollector::consume, which clang qualifies `&&`: it moves the collected state out,
/// so call it EXACTLY ONCE, and only after the frontend action has finished running. The
/// returned TokenBuffer is caller-owned and outlives the collector; TC itself is spent
/// afterwards and its only remaining use is clang_syntax_TokenCollector_dispose.
CXTokenBuffer clang_syntax_TokenCollector_consume(CXTokenCollector TC);

/// Disposing a collector that was never consumed leaves PP holding callbacks that point at
/// it, so consume first whenever the preprocessor is still alive.
void clang_syntax_TokenCollector_dispose(CXTokenCollector TC);

LLVM_CLANG_C_EXTERN_C_END

#endif
