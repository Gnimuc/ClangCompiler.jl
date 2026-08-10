#ifndef LLVM_CLANG_C_EXTRA_CXLITERALSUPPORT_H
#define LLVM_CLANG_C_EXTRA_CXLITERALSUPPORT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The three literal parsers turn a token's SPELLING into a value: the spelling still
// carries the radix prefix, the suffix, the quotes and the escape sequences, and the
// preprocessor hands out nothing else. `clang_Preprocessor_parseSimpleIntegerLiteral`
// covers plain integers only and destructively advances the token stream; these do not
// touch it.
//
// `Kind` is a raw `clang::tok::TokenKind` value throughout (as in CXToken.h and
// CXTokenKinds.h). Each `_create` VALIDATES the kind and returns NULL when the token is
// not a literal of the kind the parser handles, so no caller can reach the reads clang
// performs unconditionally on a well-formed spelling.
//
// All three parsers hold the source manager, language options, target and diagnostics
// engine they were built from BY REFERENCE, so those must outlive the parser -- dispose it
// before the compiler instance that owns them.

// expandUCNs
// isFunctionLocalStringLiteralMacro
// tokenIsLikeStringLiteral

// NumericLiteralParser

// Parses `Spelling` (`Len` bytes, the spelling of a `tok::numeric_constant`) as a
// ppnumber. The shim copies the spelling: the parser keeps markers pointing into it for
// its whole lifetime. `TokLoc` and `SM` are used only to place diagnostics on `Diags`.
// Release with `clang_NumericLiteralParser_dispose`.
CXNumericLiteralParser clang_NumericLiteralParser_create(const char *Spelling, size_t Len,
                                                         CXSourceLocation_ TokLoc,
                                                         CXSourceManager SM,
                                                         CXLangOptions LangOpts,
                                                         CXTargetInfo_ Target,
                                                         CXDiagnosticsEngine Diags);

// helper: the same, taking the spelling and the location from `Tok` and everything else
// from `PP`. Returns NULL unless `Tok` is a `tok::numeric_constant`.
CXNumericLiteralParser clang_NumericLiteralParser_createFromToken(CXPreprocessor PP,
                                                                  CXToken_ Tok);

void clang_NumericLiteralParser_dispose(CXNumericLiteralParser P);

// True when the spelling was not a well-formed ppnumber; every classification and value
// below is then meaningless and `GetIntegerValue`/`getLiteralDigits` must not be called.
bool clang_NumericLiteralParser_hadError(CXNumericLiteralParser P);

bool clang_NumericLiteralParser_isUnsigned(CXNumericLiteralParser P);
// set for `1l`, NOT for `1ll`
bool clang_NumericLiteralParser_isLong(CXNumericLiteralParser P);
bool clang_NumericLiteralParser_isLongLong(CXNumericLiteralParser P);
// `1z`, `1uz` (C++23)
bool clang_NumericLiteralParser_isSizeT(CXNumericLiteralParser P);
// `1.0h`
bool clang_NumericLiteralParser_isHalf(CXNumericLiteralParser P);
// `1.0f`
bool clang_NumericLiteralParser_isFloat(CXNumericLiteralParser P);
// `1.0i`
bool clang_NumericLiteralParser_isImaginary(CXNumericLiteralParser P);
// `1.0f16`
bool clang_NumericLiteralParser_isFloat16(CXNumericLiteralParser P);
// `1.0q`
bool clang_NumericLiteralParser_isFloat128(CXNumericLiteralParser P);
// `1.0hr` / `r` / `lr` / `uhr` / `ur` / `ulr`
bool clang_NumericLiteralParser_isFract(CXNumericLiteralParser P);
// `1.0hk` / `k` / `lk` / `uhk` / `uk` / `ulk`
bool clang_NumericLiteralParser_isAccum(CXNumericLiteralParser P);
// `1wb`, `1uwb` (C23)
bool clang_NumericLiteralParser_isBitInt(CXNumericLiteralParser P);
// the Microsoft suffix extension: 0, 8, 16, 32 or 64 for `i8`/`i16`/`i32`/`i64`
uint8_t clang_NumericLiteralParser_getMicrosoftInteger(CXNumericLiteralParser P);

// Exactly one of the three holds for an error-free spelling.
bool clang_NumericLiteralParser_isFixedPointLiteral(CXNumericLiteralParser P);
bool clang_NumericLiteralParser_isIntegerLiteral(CXNumericLiteralParser P);
bool clang_NumericLiteralParser_isFloatingLiteral(CXNumericLiteralParser P);

bool clang_NumericLiteralParser_hasUDSuffix(CXNumericLiteralParser P);
// Precondition: `clang_NumericLiteralParser_hasUDSuffix`; clang asserts.
CXString clang_NumericLiteralParser_getUDSuffix(CXNumericLiteralParser P);
// Precondition: `clang_NumericLiteralParser_hasUDSuffix`; clang asserts.
unsigned clang_NumericLiteralParser_getUDSuffixOffset(CXNumericLiteralParser P);

bool clang_NumericLiteralParser_isValidUDSuffix(CXLangOptions LangOpts,
                                                const char *Suffix);

// 2, 8, 10 or 16.
unsigned clang_NumericLiteralParser_getRadix(CXNumericLiteralParser P);

// Writes the literal's value, truncated to 64 bits, to *Value and returns whether it
// overflowed 64 bits. Precondition: `isIntegerLiteral` and not `hadError`.
bool clang_NumericLiteralParser_GetIntegerValue(CXNumericLiteralParser P, uint64_t *Value);

// Converts the literal to an IEEE double, writing it to *Value and returning the raw
// `llvm::APFloat::opStatus` bitmask (0 is opOK; 16 is opInexact, the usual answer for a
// decimal that is not representable). Precondition: `isFloatingLiteral` and not
// `hadError`.
unsigned clang_NumericLiteralParser_GetFloatValue(CXNumericLiteralParser P, double *Value);

// GetFixedPointValue

// The digits without the prefix or the suffix. Precondition: not `hadError`; clang
// asserts.
CXString clang_NumericLiteralParser_getLiteralDigits(CXNumericLiteralParser P);

// CharLiteralParser

// Parses `Text` (`Len` bytes, the spelling of a character literal including its prefix
// and quotes) at `Loc`. Returns NULL unless `Kind` is one of the five character-constant
// kinds and `Len` is at least 2. Release with `clang_CharLiteralParser_dispose`.
CXCharLiteralParser clang_CharLiteralParser_create(CXPreprocessor PP, const char *Text,
                                                   size_t Len, CXSourceLocation_ Loc,
                                                   unsigned Kind);

// helper: the same, taking the spelling, the location and the kind from `Tok`.
CXCharLiteralParser clang_CharLiteralParser_createFromToken(CXPreprocessor PP,
                                                            CXToken_ Tok);

void clang_CharLiteralParser_dispose(CXCharLiteralParser P);

bool clang_CharLiteralParser_hadError(CXCharLiteralParser P);
bool clang_CharLiteralParser_isOrdinary(CXCharLiteralParser P);
bool clang_CharLiteralParser_isWide(CXCharLiteralParser P);
bool clang_CharLiteralParser_isUTF8(CXCharLiteralParser P);
bool clang_CharLiteralParser_isUTF16(CXCharLiteralParser P);
bool clang_CharLiteralParser_isUTF32(CXCharLiteralParser P);
// `'ab'`: several characters in one ordinary literal, whose value is implementation
// defined.
bool clang_CharLiteralParser_isMultiChar(CXCharLiteralParser P);
uint64_t clang_CharLiteralParser_getValue(CXCharLiteralParser P);
// Empty when the literal carries no ud-suffix.
CXString clang_CharLiteralParser_getUDSuffix(CXCharLiteralParser P);
// Precondition: `clang_CharLiteralParser_getUDSuffix` is non-empty; clang asserts.
unsigned clang_CharLiteralParser_getUDSuffixOffset(CXCharLiteralParser P);

// StringLiteralEvalMethod

// clang/Lex/LiteralSupport.h: enum class StringLiteralEvalMethod.
typedef enum CXStringLiteralEvalMethod {
  CXStringLiteralEvalMethod_Evaluated = 0,
  CXStringLiteralEvalMethod_Unevaluated = 1
} CXStringLiteralEvalMethod;

// StringLiteralParser

// Concatenates `NumToks` adjacent string-literal tokens (translation phase 6) and decodes
// their escape sequences and UCNs. Returns NULL unless every token is a string-literal
// kind of length at least 2 and `NumToks` is non-zero. `Diags` may be NULL, which turns
// off the semantic checking of the literals. Release with
// `clang_StringLiteralParser_dispose`.
CXStringLiteralParser clang_StringLiteralParser_create(const CXToken_ *Toks,
                                                       unsigned NumToks,
                                                       CXSourceManager SM,
                                                       CXLangOptions LangOpts,
                                                       CXTargetInfo_ Target,
                                                       CXDiagnosticsEngine Diags);

// The preprocessor-driven overload, which additionally handles the Microsoft
// function-local predefined macros and can decode in unevaluated mode (what a
// `static_assert` message or an `asm` string needs).
CXStringLiteralParser
clang_StringLiteralParser_createFromPreprocessor(const CXToken_ *Toks, unsigned NumToks,
                                                 CXPreprocessor PP,
                                                 CXStringLiteralEvalMethod Method);

void clang_StringLiteralParser_dispose(CXStringLiteralParser P);

bool clang_StringLiteralParser_hadError(CXStringLiteralParser P);

// Count + fill over the decoded bytes. The result is binary data — a decoded `\0` is a
// byte in it, not a terminator — so read exactly `GetStringLength` bytes.
unsigned clang_StringLiteralParser_GetStringLength(CXStringLiteralParser P);
void clang_StringLiteralParser_GetString(CXStringLiteralParser P, char *Out, unsigned N);

// Decoded bytes divided by the character width, i.e. the length in characters of the
// element type the literal produces.
unsigned clang_StringLiteralParser_GetNumStringChars(CXStringLiteralParser P);

// Where byte `ByteNo` of the decoded string starts in `Tok`'s spelling, advancing over
// escape sequences. Precondition: `Tok` is one of the tokens the parser was built from
// and `ByteNo` is within its contribution; clang asserts.
unsigned clang_StringLiteralParser_getOffsetOfStringByte(CXStringLiteralParser P,
                                                         CXToken_ Tok, unsigned ByteNo);

bool clang_StringLiteralParser_isOrdinary(CXStringLiteralParser P);
bool clang_StringLiteralParser_isWide(CXStringLiteralParser P);
bool clang_StringLiteralParser_isUTF8(CXStringLiteralParser P);
bool clang_StringLiteralParser_isUTF16(CXStringLiteralParser P);
bool clang_StringLiteralParser_isUTF32(CXStringLiteralParser P);
// The Pascal-string extension `"\pfoo"`, whose first byte is the length.
bool clang_StringLiteralParser_isPascal(CXStringLiteralParser P);
bool clang_StringLiteralParser_isUnevaluated(CXStringLiteralParser P);

// Empty when no token carried a ud-suffix.
CXString clang_StringLiteralParser_getUDSuffix(CXStringLiteralParser P);
// Precondition: `clang_StringLiteralParser_getUDSuffix` is non-empty; clang asserts.
unsigned clang_StringLiteralParser_getUDSuffixToken(CXStringLiteralParser P);
// Precondition: `clang_StringLiteralParser_getUDSuffix` is non-empty; clang asserts.
unsigned clang_StringLiteralParser_getUDSuffixOffset(CXStringLiteralParser P);

bool clang_StringLiteralParser_isValidUDSuffix(CXLangOptions LangOpts, const char *Suffix);

LLVM_CLANG_C_EXTERN_C_END

#endif
