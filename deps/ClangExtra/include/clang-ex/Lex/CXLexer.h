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

LLVM_CLANG_C_EXTERN_C_END

#endif