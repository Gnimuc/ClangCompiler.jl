#include "clang-ex/Lex/CXLiteralSupport.h"
#include "utils.h"

#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Basic/TokenKinds.h"
#include "clang/Lex/LiteralSupport.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/Token.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <memory>
#include <string>

namespace {

// NumericLiteralParser keeps `ThisTokBegin`/`ThisTokEnd` and the digit markers pointing
// into the spelling it was constructed from, so the spelling has to outlive it. Declaring
// it first makes it initialized first, and boxing the two together makes the lifetimes one
// allocation the caller disposes once.
struct NumericLiteralParserBox {
  std::string Spelling;
  clang::NumericLiteralParser Parser;

  NumericLiteralParserBox(std::string S, clang::SourceLocation TokLoc,
                          const clang::SourceManager &SM, const clang::LangOptions &LangOpts,
                          const clang::TargetInfo &Target, clang::DiagnosticsEngine &Diags)
      : Spelling(std::move(S)), Parser(Spelling, TokLoc, SM, LangOpts, Target, Diags) {}
};

NumericLiteralParserBox *numBox(CXNumericLiteralParser P) {
  return reinterpret_cast<NumericLiteralParserBox *>(P);
}

clang::CharLiteralParser *charParser(CXCharLiteralParser P) {
  return reinterpret_cast<clang::CharLiteralParser *>(P);
}

clang::StringLiteralParser *strParser(CXStringLiteralParser P) {
  return reinterpret_cast<clang::StringLiteralParser *>(P);
}

bool isCharConstantKind(clang::tok::TokenKind K) {
  return K == clang::tok::char_constant || K == clang::tok::wide_char_constant ||
         K == clang::tok::utf8_char_constant || K == clang::tok::utf16_char_constant ||
         K == clang::tok::utf32_char_constant;
}

// The shape `StringLiteralParser::init` reads without checking: at least one token, every
// token a string-literal kind, every token long enough to hold its two quotes.
bool areStringLiteralTokens(const llvm::SmallVectorImpl<clang::Token> &Toks) {
  if (Toks.empty())
    return false;
  for (const clang::Token &Tok : Toks)
    if (!clang::tok::isStringLiteral(Tok.getKind()) || Tok.getLength() < 2)
      return false;
  return true;
}

llvm::SmallVector<clang::Token, 4> collectTokens(const CXToken_ *Toks, unsigned NumToks) {
  llvm::SmallVector<clang::Token, 4> Out;
  Out.reserve(NumToks);
  for (unsigned I = 0; I != NumToks; ++I)
    Out.push_back(*reinterpret_cast<clang::Token *>(Toks[I]));
  return Out;
}

} // namespace

// NumericLiteralParser

CXNumericLiteralParser clang_NumericLiteralParser_create(const char *Spelling, size_t Len,
                                                         CXSourceLocation_ TokLoc,
                                                         CXSourceManager SM,
                                                         CXLangOptions LangOpts,
                                                         CXTargetInfo_ Target,
                                                         CXDiagnosticsEngine Diags) {
  auto Box = std::make_unique<NumericLiteralParserBox>(
      std::string(Spelling, Len), clang::SourceLocation::getFromPtrEncoding(TokLoc),
      *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::LangOptions *>(LangOpts),
      *reinterpret_cast<clang::TargetInfo *>(Target),
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
  return reinterpret_cast<CXNumericLiteralParser>(Box.release());
}

CXNumericLiteralParser clang_NumericLiteralParser_createFromToken(CXPreprocessor PP,
                                                                  CXToken_ Tok) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  auto *T = reinterpret_cast<clang::Token *>(Tok);
  if (T->getKind() != clang::tok::numeric_constant)
    return nullptr;
  auto Box = std::make_unique<NumericLiteralParserBox>(
      P->getSpelling(*T), T->getLocation(), P->getSourceManager(), P->getLangOpts(),
      P->getTargetInfo(), P->getDiagnostics());
  return reinterpret_cast<CXNumericLiteralParser>(Box.release());
}

void clang_NumericLiteralParser_dispose(CXNumericLiteralParser P) { delete numBox(P); }

bool clang_NumericLiteralParser_hadError(CXNumericLiteralParser P) {
  return numBox(P)->Parser.hadError;
}

bool clang_NumericLiteralParser_isUnsigned(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isUnsigned;
}

bool clang_NumericLiteralParser_isLong(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isLong;
}

bool clang_NumericLiteralParser_isLongLong(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isLongLong;
}

bool clang_NumericLiteralParser_isSizeT(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isSizeT;
}

bool clang_NumericLiteralParser_isHalf(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isHalf;
}

bool clang_NumericLiteralParser_isFloat(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFloat;
}

bool clang_NumericLiteralParser_isImaginary(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isImaginary;
}

bool clang_NumericLiteralParser_isFloat16(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFloat16;
}

bool clang_NumericLiteralParser_isFloat128(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFloat128;
}

bool clang_NumericLiteralParser_isFract(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFract;
}

bool clang_NumericLiteralParser_isAccum(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isAccum;
}

bool clang_NumericLiteralParser_isBitInt(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isBitInt;
}

uint8_t clang_NumericLiteralParser_getMicrosoftInteger(CXNumericLiteralParser P) {
  return numBox(P)->Parser.MicrosoftInteger;
}

bool clang_NumericLiteralParser_isFixedPointLiteral(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFixedPointLiteral();
}

bool clang_NumericLiteralParser_isIntegerLiteral(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isIntegerLiteral();
}

bool clang_NumericLiteralParser_isFloatingLiteral(CXNumericLiteralParser P) {
  return numBox(P)->Parser.isFloatingLiteral();
}

bool clang_NumericLiteralParser_hasUDSuffix(CXNumericLiteralParser P) {
  return numBox(P)->Parser.hasUDSuffix();
}

CXString clang_NumericLiteralParser_getUDSuffix(CXNumericLiteralParser P) {
  return extra::makeCXString(numBox(P)->Parser.getUDSuffix().str());
}

unsigned clang_NumericLiteralParser_getUDSuffixOffset(CXNumericLiteralParser P) {
  return numBox(P)->Parser.getUDSuffixOffset();
}

bool clang_NumericLiteralParser_isValidUDSuffix(CXLangOptions LangOpts,
                                                const char *Suffix) {
  return clang::NumericLiteralParser::isValidUDSuffix(
      *reinterpret_cast<clang::LangOptions *>(LangOpts), llvm::StringRef(Suffix));
}

unsigned clang_NumericLiteralParser_getRadix(CXNumericLiteralParser P) {
  return numBox(P)->Parser.getRadix();
}

bool clang_NumericLiteralParser_GetIntegerValue(CXNumericLiteralParser P,
                                                uint64_t *Value) {
  llvm::APInt Val(64, 0);
  bool Overflow = numBox(P)->Parser.GetIntegerValue(Val);
  *Value = Val.getZExtValue();
  return Overflow;
}

unsigned clang_NumericLiteralParser_GetFloatValue(CXNumericLiteralParser P,
                                                  double *Value) {
  llvm::APFloat Result(llvm::APFloat::IEEEdouble());
  llvm::APFloat::opStatus Status =
      numBox(P)->Parser.GetFloatValue(Result, llvm::RoundingMode::NearestTiesToEven);
  *Value = Result.convertToDouble();
  return static_cast<unsigned>(Status);
}

// GetFixedPointValue

CXString clang_NumericLiteralParser_getLiteralDigits(CXNumericLiteralParser P) {
  return extra::makeCXString(numBox(P)->Parser.getLiteralDigits().str());
}

// CharLiteralParser

CXCharLiteralParser clang_CharLiteralParser_create(CXPreprocessor PP, const char *Text,
                                                   size_t Len, CXSourceLocation_ Loc,
                                                   unsigned Kind) {
  auto TokKind = static_cast<clang::tok::TokenKind>(Kind);
  if (!isCharConstantKind(TokKind) || Len < 2)
    return nullptr;
  auto Parser = std::make_unique<clang::CharLiteralParser>(
      Text, Text + Len, clang::SourceLocation::getFromPtrEncoding(Loc),
      *reinterpret_cast<clang::Preprocessor *>(PP), TokKind);
  return reinterpret_cast<CXCharLiteralParser>(Parser.release());
}

CXCharLiteralParser clang_CharLiteralParser_createFromToken(CXPreprocessor PP,
                                                            CXToken_ Tok) {
  auto *P = reinterpret_cast<clang::Preprocessor *>(PP);
  auto *T = reinterpret_cast<clang::Token *>(Tok);
  if (!isCharConstantKind(T->getKind()))
    return nullptr;
  std::string Spelling = P->getSpelling(*T);
  if (Spelling.size() < 2)
    return nullptr;
  auto Parser = std::make_unique<clang::CharLiteralParser>(
      Spelling.data(), Spelling.data() + Spelling.size(), T->getLocation(), *P,
      T->getKind());
  return reinterpret_cast<CXCharLiteralParser>(Parser.release());
}

void clang_CharLiteralParser_dispose(CXCharLiteralParser P) { delete charParser(P); }

bool clang_CharLiteralParser_hadError(CXCharLiteralParser P) {
  return charParser(P)->hadError();
}

bool clang_CharLiteralParser_isOrdinary(CXCharLiteralParser P) {
  return charParser(P)->isOrdinary();
}

bool clang_CharLiteralParser_isWide(CXCharLiteralParser P) {
  return charParser(P)->isWide();
}

bool clang_CharLiteralParser_isUTF8(CXCharLiteralParser P) {
  return charParser(P)->isUTF8();
}

bool clang_CharLiteralParser_isUTF16(CXCharLiteralParser P) {
  return charParser(P)->isUTF16();
}

bool clang_CharLiteralParser_isUTF32(CXCharLiteralParser P) {
  return charParser(P)->isUTF32();
}

bool clang_CharLiteralParser_isMultiChar(CXCharLiteralParser P) {
  return charParser(P)->isMultiChar();
}

uint64_t clang_CharLiteralParser_getValue(CXCharLiteralParser P) {
  return charParser(P)->getValue();
}

CXString clang_CharLiteralParser_getUDSuffix(CXCharLiteralParser P) {
  return extra::makeCXString(charParser(P)->getUDSuffix().str());
}

unsigned clang_CharLiteralParser_getUDSuffixOffset(CXCharLiteralParser P) {
  return charParser(P)->getUDSuffixOffset();
}

// StringLiteralParser

CXStringLiteralParser clang_StringLiteralParser_create(const CXToken_ *Toks,
                                                       unsigned NumToks,
                                                       CXSourceManager SM,
                                                       CXLangOptions LangOpts,
                                                       CXTargetInfo_ Target,
                                                       CXDiagnosticsEngine Diags) {
  llvm::SmallVector<clang::Token, 4> TokVec = collectTokens(Toks, NumToks);
  if (!areStringLiteralTokens(TokVec))
    return nullptr;
  // Constructed in place and never moved: `ResultPtr` is a cursor into the parser's own
  // inline `ResultBuf`, so relocating the object would leave it dangling.
  auto Parser = std::make_unique<clang::StringLiteralParser>(
      TokVec, *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::LangOptions *>(LangOpts),
      *reinterpret_cast<clang::TargetInfo *>(Target),
      reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
  return reinterpret_cast<CXStringLiteralParser>(Parser.release());
}

CXStringLiteralParser
clang_StringLiteralParser_createFromPreprocessor(const CXToken_ *Toks, unsigned NumToks,
                                                 CXPreprocessor PP,
                                                 CXStringLiteralEvalMethod Method) {
  llvm::SmallVector<clang::Token, 4> TokVec = collectTokens(Toks, NumToks);
  if (!areStringLiteralTokens(TokVec))
    return nullptr;
  auto Parser = std::make_unique<clang::StringLiteralParser>(
      TokVec, *reinterpret_cast<clang::Preprocessor *>(PP),
      static_cast<clang::StringLiteralEvalMethod>(Method));
  return reinterpret_cast<CXStringLiteralParser>(Parser.release());
}

void clang_StringLiteralParser_dispose(CXStringLiteralParser P) { delete strParser(P); }

bool clang_StringLiteralParser_hadError(CXStringLiteralParser P) {
  return strParser(P)->hadError;
}

unsigned clang_StringLiteralParser_GetStringLength(CXStringLiteralParser P) {
  return strParser(P)->GetStringLength();
}

void clang_StringLiteralParser_GetString(CXStringLiteralParser P, char *Out, unsigned N) {
  llvm::StringRef S = strParser(P)->GetString();
  std::copy_n(S.begin(), std::min<size_t>(N, S.size()), Out);
}

unsigned clang_StringLiteralParser_GetNumStringChars(CXStringLiteralParser P) {
  return strParser(P)->GetNumStringChars();
}

unsigned clang_StringLiteralParser_getOffsetOfStringByte(CXStringLiteralParser P,
                                                         CXToken_ Tok, unsigned ByteNo) {
  return strParser(P)->getOffsetOfStringByte(*reinterpret_cast<clang::Token *>(Tok),
                                             ByteNo);
}

bool clang_StringLiteralParser_isOrdinary(CXStringLiteralParser P) {
  return strParser(P)->isOrdinary();
}

bool clang_StringLiteralParser_isWide(CXStringLiteralParser P) {
  return strParser(P)->isWide();
}

bool clang_StringLiteralParser_isUTF8(CXStringLiteralParser P) {
  return strParser(P)->isUTF8();
}

bool clang_StringLiteralParser_isUTF16(CXStringLiteralParser P) {
  return strParser(P)->isUTF16();
}

bool clang_StringLiteralParser_isUTF32(CXStringLiteralParser P) {
  return strParser(P)->isUTF32();
}

bool clang_StringLiteralParser_isPascal(CXStringLiteralParser P) {
  return strParser(P)->isPascal();
}

bool clang_StringLiteralParser_isUnevaluated(CXStringLiteralParser P) {
  return strParser(P)->isUnevaluated();
}

CXString clang_StringLiteralParser_getUDSuffix(CXStringLiteralParser P) {
  return extra::makeCXString(strParser(P)->getUDSuffix().str());
}

unsigned clang_StringLiteralParser_getUDSuffixToken(CXStringLiteralParser P) {
  return strParser(P)->getUDSuffixToken();
}

unsigned clang_StringLiteralParser_getUDSuffixOffset(CXStringLiteralParser P) {
  return strParser(P)->getUDSuffixOffset();
}

bool clang_StringLiteralParser_isValidUDSuffix(CXLangOptions LangOpts,
                                               const char *Suffix) {
  return clang::StringLiteralParser::isValidUDSuffix(
      *reinterpret_cast<clang::LangOptions *>(LangOpts), llvm::StringRef(Suffix));
}
