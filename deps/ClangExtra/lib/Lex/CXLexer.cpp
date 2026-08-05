#include "clang-ex/Lex/CXLexer.h"
#include "utils.h"
#include "clang/Lex/Lexer.h"
#include "llvm/Support/MemoryBuffer.h"
#include <algorithm>
#include <cstring>

CXLexer clang_Lexer_create(CXFileID FID, LLVMMemoryBufferRef FromFile, CXSourceManager SM,
                           CXLangOptions langOpts) {
  auto L = std::make_unique<clang::Lexer>(*static_cast<clang::FileID *>(FID),
                                          llvm::MemoryBufferRef(*llvm::unwrap(FromFile)),
                                          *static_cast<clang::SourceManager *>(SM),
                                          *static_cast<clang::LangOptions *>(langOpts));
  return L.release();
}

void clang_Lexer_dispose(CXLexer Lex) { delete static_cast<clang::Lexer *>(Lex); }

CXSourceLocation_ clang_Lexer_getFileLoc(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->getFileLoc().getPtrEncoding();
}

bool clang_Lexer_Lex(CXLexer Lex, CXToken_ Result) {
  return static_cast<clang::Lexer *>(Lex)->Lex(*static_cast<clang::Token *>(Result));
}

bool clang_Lexer_isPragmaLexer(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->isPragmaLexer();
}

bool clang_Lexer_LexFromRawLexer(CXLexer Lex, CXToken_ Result) {
  return static_cast<clang::Lexer *>(Lex)->LexFromRawLexer(
      *static_cast<clang::Token *>(Result));
}

bool clang_Lexer_isKeepWhitespaceMode(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->isKeepWhitespaceMode();
}

void clang_Lexer_SetKeepWhitespaceMode(CXLexer Lex, bool Val) {
  static_cast<clang::Lexer *>(Lex)->SetKeepWhitespaceMode(Val);
}

bool clang_Lexer_inKeepCommentMode(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->inKeepCommentMode();
}

void clang_Lexer_SetCommentRetentionState(CXLexer Lex, bool Mode) {
  static_cast<clang::Lexer *>(Lex)->SetCommentRetentionState(Mode);
}

unsigned clang_Lexer_getCurrentBufferOffset(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->getCurrentBufferOffset();
}

CXString clang_Lexer_getSpelling(CXToken_ Tok, CXSourceManager SM,
                                 CXLangOptions LangOpts) {
  return extra::makeCXString(
      clang::Lexer::getSpelling(*static_cast<clang::Token *>(Tok),
                                *static_cast<clang::SourceManager *>(SM),
                                *static_cast<clang::LangOptions *>(LangOpts)));
}

unsigned clang_Lexer_MeasureTokenLength(CXSourceLocation_ Loc, CXSourceManager SM,
                                        CXLangOptions LangOpts) {
  return clang::Lexer::MeasureTokenLength(clang::SourceLocation::getFromPtrEncoding(Loc),
                                          *static_cast<clang::SourceManager *>(SM),
                                          *static_cast<clang::LangOptions *>(LangOpts));
}

bool clang_Lexer_getRawToken(CXSourceLocation_ Loc, CXToken_ Result, CXSourceManager SM,
                             CXLangOptions LangOpts, bool IgnoreWhiteSpace) {
  return clang::Lexer::getRawToken(clang::SourceLocation::getFromPtrEncoding(Loc),
                                   *static_cast<clang::Token *>(Result),
                                   *static_cast<clang::SourceManager *>(SM),
                                   *static_cast<clang::LangOptions *>(LangOpts),
                                   IgnoreWhiteSpace);
}

CXSourceLocation_ clang_Lexer_GetBeginningOfToken(CXSourceLocation_ Loc,
                                                  CXSourceManager SM,
                                                  CXLangOptions LangOpts) {
  return clang::Lexer::GetBeginningOfToken(clang::SourceLocation::getFromPtrEncoding(Loc),
                                           *static_cast<clang::SourceManager *>(SM),
                                           *static_cast<clang::LangOptions *>(LangOpts))
      .getPtrEncoding();
}

CXSourceLocation_ clang_Lexer_getLocForEndOfToken(CXSourceLocation_ Loc, unsigned Offset,
                                                  CXSourceManager SM,
                                                  CXLangOptions LangOpts) {
  return clang::Lexer::getLocForEndOfToken(clang::SourceLocation::getFromPtrEncoding(Loc),
                                           Offset,
                                           *static_cast<clang::SourceManager *>(SM),
                                           *static_cast<clang::LangOptions *>(LangOpts))
      .getPtrEncoding();
}

bool clang_Lexer_isAtStartOfMacroExpansion(CXSourceLocation_ Loc, CXSourceManager SM,
                                           CXLangOptions LangOpts,
                                           CXSourceLocation_ *MacroBegin) {
  clang::SourceLocation MB;
  bool Res = clang::Lexer::isAtStartOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      *static_cast<clang::SourceManager *>(SM),
      *static_cast<clang::LangOptions *>(LangOpts), MacroBegin ? &MB : nullptr);
  if (Res && MacroBegin)
    *MacroBegin = MB.getPtrEncoding();
  return Res;
}

bool clang_Lexer_isAtEndOfMacroExpansion(CXSourceLocation_ Loc, CXSourceManager SM,
                                         CXLangOptions LangOpts,
                                         CXSourceLocation_ *MacroEnd) {
  clang::SourceLocation ME;
  bool Res = clang::Lexer::isAtEndOfMacroExpansion(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      *static_cast<clang::SourceManager *>(SM),
      *static_cast<clang::LangOptions *>(LangOpts), MacroEnd ? &ME : nullptr);
  if (Res && MacroEnd)
    *MacroEnd = ME.getPtrEncoding();
  return Res;
}

CXString clang_Lexer_getSourceText(CXSourceRange_ Range, bool IsTokenRange,
                                   CXSourceManager SM, CXLangOptions LangOpts) {
  clang::CharSourceRange CSR(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      IsTokenRange);
  return extra::makeCXString(
      clang::Lexer::getSourceText(CSR, *static_cast<clang::SourceManager *>(SM),
                                  *static_cast<clang::LangOptions *>(LangOpts))
          .str());
}

CXString clang_Lexer_getImmediateMacroName(CXSourceLocation_ Loc, CXSourceManager SM,
                                           CXLangOptions LangOpts) {
  return extra::makeCXString(
      clang::Lexer::getImmediateMacroName(clang::SourceLocation::getFromPtrEncoding(Loc),
                                          *static_cast<clang::SourceManager *>(SM),
                                          *static_cast<clang::LangOptions *>(LangOpts))
          .str());
}

bool clang_Lexer_findNextToken(CXSourceLocation_ Loc, CXSourceManager SM,
                               CXLangOptions LangOpts, CXToken_ Result) {
  std::optional<clang::Token> Tok = clang::Lexer::findNextToken(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      *static_cast<clang::SourceManager *>(SM),
      *static_cast<clang::LangOptions *>(LangOpts));
  if (!Tok)
    return false;
  *static_cast<clang::Token *>(Result) = *Tok;
  return true;
}

bool clang_Lexer_isFirstTimeLexingFile(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->isFirstTimeLexingFile();
}

size_t clang_Lexer_getBufferLength(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->getBuffer().size();
}

void clang_Lexer_getBuffer(CXLexer Lex, char *Out, size_t N) {
  llvm::StringRef B = static_cast<clang::Lexer *>(Lex)->getBuffer();
  std::memcpy(Out, B.data(), std::min(N, B.size()));
}

CXSourceLocation_ clang_Lexer_getSourceLocation(CXLexer Lex) {
  return static_cast<clang::Lexer *>(Lex)->getSourceLocation().getPtrEncoding();
}

void clang_Lexer_seek(CXLexer Lex, unsigned Offset, bool IsAtStartOfLine) {
  static_cast<clang::Lexer *>(Lex)->seek(Offset, IsAtStartOfLine);
}

CXString clang_Lexer_Stringify(const char *Str, size_t Len, bool Charify) {
  return extra::makeCXString(clang::Lexer::Stringify(llvm::StringRef(Str, Len), Charify));
}

unsigned clang_Lexer_getTokenPrefixLength(CXSourceLocation_ TokStart, unsigned CharNo,
                                          CXSourceManager SM, CXLangOptions LangOpts) {
  return clang::Lexer::getTokenPrefixLength(
      clang::SourceLocation::getFromPtrEncoding(TokStart), CharNo,
      *static_cast<clang::SourceManager *>(SM),
      *static_cast<clang::LangOptions *>(LangOpts));
}

CXSourceRange_ clang_Lexer_makeFileCharRange(CXSourceRange_ Range, bool IsTokenRange,
                                             CXSourceManager SM, CXLangOptions LangOpts) {
  clang::CharSourceRange CSR(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range.B),
                         clang::SourceLocation::getFromPtrEncoding(Range.E)),
      IsTokenRange);
  clang::CharSourceRange R =
      clang::Lexer::makeFileCharRange(CSR, *static_cast<clang::SourceManager *>(SM),
                                      *static_cast<clang::LangOptions *>(LangOpts));
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXString clang_Lexer_getImmediateMacroNameForDiagnostics(CXSourceLocation_ Loc,
                                                         CXSourceManager SM,
                                                         CXLangOptions LangOpts) {
  return extra::makeCXString(clang::Lexer::getImmediateMacroNameForDiagnostics(
                                 clang::SourceLocation::getFromPtrEncoding(Loc),
                                 *static_cast<clang::SourceManager *>(SM),
                                 *static_cast<clang::LangOptions *>(LangOpts))
                                 .str());
}

CXString clang_Lexer_getIndentationForLine(CXSourceLocation_ Loc, CXSourceManager SM) {
  return extra::makeCXString(
      clang::Lexer::getIndentationForLine(clang::SourceLocation::getFromPtrEncoding(Loc),
                                          *static_cast<clang::SourceManager *>(SM))
          .str());
}

unsigned clang_Lexer_ComputePreamble(const char *Buffer, CXLangOptions LangOpts,
                                     unsigned MaxLines, bool *PreambleEndsAtStartOfLine) {
  clang::PreambleBounds PB = clang::Lexer::ComputePreamble(
      llvm::StringRef(Buffer), *static_cast<clang::LangOptions *>(LangOpts), MaxLines);
  if (PreambleEndsAtStartOfLine)
    *PreambleEndsAtStartOfLine = PB.PreambleEndsAtStartOfLine;
  return PB.Size;
}

CXSourceLocation_ clang_Lexer_findLocationAfterToken(
    CXSourceLocation_ Loc, unsigned TKind, CXSourceManager SM, CXLangOptions LangOpts,
    bool SkipTrailingWhitespaceAndNewLine) {
  return clang::Lexer::findLocationAfterToken(
             clang::SourceLocation::getFromPtrEncoding(Loc),
             static_cast<clang::tok::TokenKind>(TKind),
             *static_cast<clang::SourceManager *>(SM),
             *static_cast<clang::LangOptions *>(LangOpts),
             SkipTrailingWhitespaceAndNewLine)
      .getPtrEncoding();
}

bool clang_Lexer_isAsciiIdentifierContinueChar(char C, CXLangOptions LangOpts) {
  return clang::Lexer::isAsciiIdentifierContinueChar(
      C, *static_cast<clang::LangOptions *>(LangOpts));
}
