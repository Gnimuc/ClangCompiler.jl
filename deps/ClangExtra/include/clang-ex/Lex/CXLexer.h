#ifndef LLVM_CLANG_C_EXTRA_CXLEXER_H
#define LLVM_CLANG_C_EXTRA_CXLEXER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile, CXSourceManager SM,
                           CXLangOptions langOpts);

void clang_Lexer_dispose(CXLexer Lex);

CXSourceLocation_ clang_Lexer_getFileLoc(CXLexer Lex);

bool clang_Lexer_Lex(CXLexer Lex, CXToken_ Result);

bool clang_Lexer_isPragmaLexer(CXLexer Lex);

bool clang_Lexer_LexFromRawLexer(CXLexer Lex, CXToken_ Result);

bool clang_Lexer_isKeepWhitespaceMode(CXLexer Lex);

void clang_Lexer_SetKeepWhitespaceMode(CXLexer Lex, bool Val);

bool clang_Lexer_inKeepCommentMode(CXLexer Lex);

void clang_Lexer_SetCommentRetentionState(CXLexer Lex, bool Mode);

unsigned clang_Lexer_getCurrentBufferOffset(CXLexer Lex);

CXString clang_Lexer_getSpelling(CXToken_ Tok, CXSourceManager SM,
                                 CXLangOptions LangOpts);

unsigned clang_Lexer_MeasureTokenLength(CXSourceLocation_ Loc, CXSourceManager SM,
                                        CXLangOptions LangOpts);

// Returns true on FAILURE (mirroring `Lexer::getRawToken`); on success `Result`
// is overwritten with the relexed token.
bool clang_Lexer_getRawToken(CXSourceLocation_ Loc, CXToken_ Result, CXSourceManager SM,
                             CXLangOptions LangOpts, bool IgnoreWhiteSpace);

CXSourceLocation_ clang_Lexer_GetBeginningOfToken(CXSourceLocation_ Loc,
                                                  CXSourceManager SM,
                                                  CXLangOptions LangOpts);

// The location of the `Characters`-th character of the token beginning at TokStart, in the
// *spelling* of that token — so it steps over escaped newlines and trigraphs rather than
// counting raw bytes. Same shape as GetBeginningOfToken above.
CXSourceLocation_ clang_Lexer_AdvanceToTokenCharacter(CXSourceLocation_ TokStart,
                                                      unsigned Characters,
                                                      CXSourceManager SM,
                                                      CXLangOptions LangOpts);

// Widen a token range — one whose end names the START of its last token — to the character
// range covering that last token in full.
//
// clang returns a CharSourceRange, an aggregate of a SourceRange plus an is-token-range flag.
// Only the range crosses, because this function's whole purpose is to produce a CHARACTER
// range: the flag is false for every result it can return, and a constant is not worth a
// marshalling scheme. The Julia layer supplies it when it builds its own CharSourceRange.
CXSourceRange_ clang_Lexer_getAsCharRange(CXSourceRange_ Range, CXSourceManager SM,
                                          CXLangOptions LangOpts);

CXSourceLocation_ clang_Lexer_getLocForEndOfToken(CXSourceLocation_ Loc, unsigned Offset,
                                                  CXSourceManager SM,
                                                  CXLangOptions LangOpts);

// `MacroBegin` may be NULL; it is written only when the function returns true.
bool clang_Lexer_isAtStartOfMacroExpansion(CXSourceLocation_ Loc, CXSourceManager SM,
                                           CXLangOptions LangOpts,
                                           CXSourceLocation_ *MacroBegin);

// `MacroEnd` may be NULL; it is written only when the function returns true.
bool clang_Lexer_isAtEndOfMacroExpansion(CXSourceLocation_ Loc, CXSourceManager SM,
                                         CXLangOptions LangOpts,
                                         CXSourceLocation_ *MacroEnd);

// `Range` is a token range when `IsTokenRange` is true, a char range otherwise.
CXString clang_Lexer_getSourceText(CXSourceRange_ Range, bool IsTokenRange,
                                   CXSourceManager SM, CXLangOptions LangOpts);

CXString clang_Lexer_getImmediateMacroName(CXSourceLocation_ Loc, CXSourceManager SM,
                                           CXLangOptions LangOpts);

// Returns true and fills `Result` with the token after `Loc`; false when the
// location is inside a macro (`Result` untouched).
bool clang_Lexer_findNextToken(CXSourceLocation_ Loc, CXSourceManager SM,
                               CXLangOptions LangOpts, CXToken_ Result);

bool clang_Lexer_isFirstTimeLexingFile(CXLexer Lex);

// Two-call length+fill (MARSHALLING.md §5, the clang_Driver_GetResourcesPathLength shape):
// this returns the buffer's byte count and clang_Lexer_getBuffer copies min(N, length) bytes
// into Out with NO NUL terminator. Deliberately not a CXString: extra::makeCXString is
// strdup, so a source buffer holding a NUL byte would be silently truncated, and the exact
// count is load-bearing -- it is the bound clang_Lexer_seek needs.
size_t clang_Lexer_getBufferLength(CXLexer Lex);

void clang_Lexer_getBuffer(CXLexer Lex, char *Out, size_t N);

// The location of the next character to be lexed, i.e. of the lexer's current buffer
// pointer -- clang::Lexer's own override, not the PreprocessorLexer pure virtual.
CXSourceLocation_ clang_Lexer_getSourceLocation(CXLexer Lex);

// Sets the buffer pointer to Offset and the start-of-line flag. Performs NO bounds check:
// the body is `BufferPtr = BufferStart + Offset` with nothing compared against BufferEnd, so
// an out-of-range Offset leaves the next lex reading past the buffer. Gate with
// clang_Lexer_getBufferLength; restated as an @assert in the Julia layer.
void clang_Lexer_seek(CXLexer Lex, unsigned Offset, bool IsAtStartOfLine);

// Escapes '\' and '"' and turns newlines into "\n"; with Charify it escapes '\'' instead of
// '"'. The (Str, Len) pair is explicit because the caller's length is authoritative.
CXString clang_Lexer_Stringify(const char *Str, size_t Len, bool Charify);

// Physical length (including trigraphs and escaped newlines) of the first CharNo characters
// of the token starting at TokStart. PRECONDITION: CharNo may not exceed the number of
// characters in that token's CLEANED spelling -- clang walks with
// isObviouslySimpleCharacter, which is true of a NUL, so the walk stops neither at the end of
// the token nor at the end of the buffer. Restated as an @assert in the Julia layer.
unsigned clang_Lexer_getTokenPrefixLength(CXSourceLocation_ TokStart, unsigned CharNo,
                                          CXSourceManager SM, CXLangOptions LangOpts);

// Maps Range (a token range when IsTokenRange is true, a character range otherwise) onto a
// character range of file locations. The result is ALWAYS a character range, so only the two
// locations cross back; two invalid locations are the documented failure signal -- a range
// that only partly overlaps a macro expansion, or whose ends sit in different files.
CXSourceRange_ clang_Lexer_makeFileCharRange(CXSourceRange_ Range, bool IsTokenRange,
                                             CXSourceManager SM, CXLangOptions LangOpts);

// Like clang_Lexer_getImmediateMacroName, except that a macro-argument location resolves to
// the TOPMOST function macro that accepted it rather than the innermost one.
// PRECONDITION: Loc is a macro location -- clang asserts isMacroID.
CXString clang_Lexer_getImmediateMacroNameForDiagnostics(CXSourceLocation_ Loc,
                                                         CXSourceManager SM,
                                                         CXLangOptions LangOpts);

// The leading whitespace of the line Loc is on. Empty for an invalid location, for a macro
// location, and for a line with no indentation. Takes no LangOptions.
CXString clang_Lexer_getIndentationForLine(CXSourceLocation_ Loc, CXSourceManager SM);

// The preamble's byte size is the return value; *PreambleEndsAtStartOfLine is filled when
// non-null (MARSHALLING.md §7 -- the two fields of PreambleBounds, not the aggregate).
// Buffer must be NUL-terminated: clang builds a Lexer over [Buffer.begin(), Buffer.end()).
unsigned clang_Lexer_ComputePreamble(const char *Buffer, CXLangOptions LangOpts,
                                     unsigned MaxLines, bool *PreambleEndsAtStartOfLine);

// The location just past the token after Loc, when that token has kind TKind; an invalid
// location when it has another kind, when there is none, or when Loc is inside a macro.
// TKind is a raw clang::tok::TokenKind value, as returned by clang_Token_getKind -- the kind
// enum is deliberately not mirrored (see Lex/CXToken.h).
CXSourceLocation_ clang_Lexer_findLocationAfterToken(CXSourceLocation_ Loc, unsigned TKind,
                                                     CXSourceManager SM,
                                                     CXLangOptions LangOpts,
                                                     bool SkipTrailingWhitespaceAndNewLine);

bool clang_Lexer_isAsciiIdentifierContinueChar(char C, CXLangOptions LangOpts);

LLVM_CLANG_C_EXTERN_C_END

#endif