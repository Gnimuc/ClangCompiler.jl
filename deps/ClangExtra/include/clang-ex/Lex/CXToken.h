#ifndef LLVM_CLANG_C_EXTRA_CXTOKEN_H
#define LLVM_CLANG_C_EXTRA_CXTOKEN_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXAnnotationValue clang_Token_getAnnotationValue(CXToken_ Tok);

CXSourceLocation_ clang_Token_getLocation(CXToken_ Tok);
CXSourceLocation_ clang_Token_getAnnotationEndLoc(CXToken_ Tok);

const char *clang_Token_getName(CXToken_ Tok);

CXIdentifierInfo clang_Token_getIdentifierInfo(CXToken_ Tok);

void clang_Token_setIdentifierInfo(CXToken_ Tok, CXIdentifierInfo II);

bool clang_Token_isKind_eof(CXToken_ Tok);
bool clang_Token_isKind_annot_repl_input_end(CXToken_ Tok);
bool clang_Token_isKind_identifier(CXToken_ Tok);
bool clang_Token_isKind_coloncolon(CXToken_ Tok);

bool clang_Token_isKind_annot_cxxscope(CXToken_ Tok);
bool clang_Token_isKind_annot_typename(CXToken_ Tok);
bool clang_Token_isKind_annot_template_id(CXToken_ Tok);

bool clang_Token_isKind_kw_enum(CXToken_ Tok);
bool clang_Token_isKind_kw_typename(CXToken_ Tok);
bool clang_Token_isKind_raw_identifier(CXToken_ Tok);
bool clang_Token_isKind_numeric_constant(CXToken_ Tok);

// Heap-allocates an empty token initialized with `startToken`.
CXToken_ clang_Token_create(void);

void clang_Token_dispose(CXToken_ Tok);

// Mirror of `clang::Token::TokenFlags` (clang/Lex/Token.h).
typedef enum CXTokenFlags {
  CXTokenFlags_StartOfLine = 0x01,
  CXTokenFlags_LeadingSpace = 0x02,
  CXTokenFlags_DisableExpand = 0x04,
  CXTokenFlags_NeedsCleaning = 0x08,
  CXTokenFlags_LeadingEmptyMacro = 0x10,
  CXTokenFlags_HasUDSuffix = 0x20,
  CXTokenFlags_HasUCN = 0x40,
  CXTokenFlags_IgnoredComma = 0x80,
  CXTokenFlags_StringifiedInMacro = 0x100,
  CXTokenFlags_CommaAfterElided = 0x200,
  CXTokenFlags_IsEditorPlaceholder = 0x400,
  CXTokenFlags_IsReinjected = 0x800
} CXTokenFlags;

// The raw `clang::tok::TokenKind` value (the kind enum is deliberately not
// mirrored — use `clang_Token_getName` for the kind's spelling).
unsigned clang_Token_getKind(CXToken_ Tok);

// Takes a raw `clang::tok::TokenKind` value, as returned by `clang_Token_getKind`.
void clang_Token_setKind(CXToken_ Tok, unsigned Kind);

bool clang_Token_is(CXToken_ Tok, unsigned Kind);

bool clang_Token_isNot(CXToken_ Tok, unsigned Kind);

bool clang_Token_isAnyIdentifier(CXToken_ Tok);

bool clang_Token_isLiteral(CXToken_ Tok);

bool clang_Token_isAnnotation(CXToken_ Tok);

bool clang_Token_isRegularKeywordAttribute(CXToken_ Tok);

unsigned clang_Token_getLength(CXToken_ Tok);

void clang_Token_setLocation(CXToken_ Tok, CXSourceLocation_ L);

// Precondition: `Tok` is not an annotation token — an annotation stores its end location
// in the same field, and Clang asserts.
void clang_Token_setLength(CXToken_ Tok, unsigned Len);

CXSourceLocation_ clang_Token_getLastLoc(CXToken_ Tok);

CXSourceLocation_ clang_Token_getEndLoc(CXToken_ Tok);

void clang_Token_startToken(CXToken_ Tok);

bool clang_Token_hasPtrData(CXToken_ Tok);

CXString clang_Token_getRawIdentifier(CXToken_ Tok);

// Precondition: `Tok` is a literal (`clang_Token_isLiteral`). Returns a borrowed pointer
// into the source buffer that is NOT NUL-terminated — read exactly
// `clang_Token_getLength` bytes — and NULL when the literal's text was not recorded.
const char *clang_Token_getLiteralData(CXToken_ Tok);

bool clang_Token_getFlag(CXToken_ Tok, CXTokenFlags Flag);

unsigned clang_Token_getFlags(CXToken_ Tok);

void clang_Token_setFlagValue(CXToken_ Tok, CXTokenFlags Flag, bool Val);

bool clang_Token_isAtStartOfLine(CXToken_ Tok);

bool clang_Token_hasLeadingSpace(CXToken_ Tok);

bool clang_Token_isExpandDisabled(CXToken_ Tok);

bool clang_Token_needsCleaning(CXToken_ Tok);

bool clang_Token_hasLeadingEmptyMacro(CXToken_ Tok);

bool clang_Token_hasUDSuffix(CXToken_ Tok);

bool clang_Token_hasUCN(CXToken_ Tok);

bool clang_Token_stringifiedInMacro(CXToken_ Tok);

bool clang_Token_commaAfterElided(CXToken_ Tok);

bool clang_Token_isEditorPlaceholder(CXToken_ Tok);

LLVM_CLANG_C_EXTERN_C_END

#endif