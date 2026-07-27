#include "clang-ex/Lex/CXToken.h"
#include "utils.h"
#include "clang/Lex/Token.h"

bool clang_Token_isKind_raw_identifier(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::raw_identifier);
}

bool clang_Token_isKind_numeric_constant(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::numeric_constant);
}

CXToken_ clang_Token_create(void) {
  auto T = std::make_unique<clang::Token>();
  T->startToken();
  return T.release();
}

void clang_Token_dispose(CXToken_ Tok) { delete static_cast<clang::Token *>(Tok); }

unsigned clang_Token_getKind(CXToken_ Tok) {
  return static_cast<unsigned>(static_cast<clang::Token *>(Tok)->getKind());
}

void clang_Token_setKind(CXToken_ Tok, unsigned Kind) {
  static_cast<clang::Token *>(Tok)->setKind(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_Token_is(CXToken_ Tok, unsigned Kind) {
  return static_cast<clang::Token *>(Tok)->is(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_Token_isNot(CXToken_ Tok, unsigned Kind) {
  return static_cast<clang::Token *>(Tok)->isNot(
      static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_Token_isAnyIdentifier(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isAnyIdentifier();
}

bool clang_Token_isLiteral(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isLiteral();
}

bool clang_Token_isAnnotation(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isAnnotation();
}

bool clang_Token_isRegularKeywordAttribute(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isRegularKeywordAttribute();
}

unsigned clang_Token_getLength(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getLength();
}

void clang_Token_setLocation(CXToken_ Tok, CXSourceLocation_ L) {
  static_cast<clang::Token *>(Tok)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_Token_setLength(CXToken_ Tok, unsigned Len) {
  static_cast<clang::Token *>(Tok)->setLength(Len);
}

CXSourceLocation_ clang_Token_getLastLoc(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getLastLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Token_getEndLoc(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getEndLoc().getPtrEncoding();
}

void clang_Token_startToken(CXToken_ Tok) {
  static_cast<clang::Token *>(Tok)->startToken();
}

bool clang_Token_hasPtrData(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->hasPtrData();
}

CXString clang_Token_getRawIdentifier(CXToken_ Tok) {
  return extra::makeCXString(static_cast<clang::Token *>(Tok)->getRawIdentifier().str());
}

const char *clang_Token_getLiteralData(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getLiteralData();
}

bool clang_Token_getFlag(CXToken_ Tok, CXTokenFlags Flag) {
  return static_cast<clang::Token *>(Tok)->getFlag(
      static_cast<clang::Token::TokenFlags>(Flag));
}

unsigned clang_Token_getFlags(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getFlags();
}

void clang_Token_setFlagValue(CXToken_ Tok, CXTokenFlags Flag, bool Val) {
  static_cast<clang::Token *>(Tok)->setFlagValue(
      static_cast<clang::Token::TokenFlags>(Flag), Val);
}

bool clang_Token_isAtStartOfLine(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isAtStartOfLine();
}

bool clang_Token_hasLeadingSpace(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->hasLeadingSpace();
}

bool clang_Token_isExpandDisabled(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isExpandDisabled();
}

bool clang_Token_needsCleaning(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->needsCleaning();
}

bool clang_Token_hasLeadingEmptyMacro(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->hasLeadingEmptyMacro();
}

bool clang_Token_hasUDSuffix(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->hasUDSuffix();
}

bool clang_Token_hasUCN(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->hasUCN();
}

bool clang_Token_stringifiedInMacro(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->stringifiedInMacro();
}

bool clang_Token_commaAfterElided(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->commaAfterElided();
}

bool clang_Token_isEditorPlaceholder(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->isEditorPlaceholder();
}

CXAnnotationValue clang_Token_getAnnotationValue(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getAnnotationValue();
}

CXSourceLocation_ clang_Token_getLocation(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getLocation().getPtrEncoding();
}

CXSourceLocation_ clang_Token_getAnnotationEndLoc(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getAnnotationEndLoc().getPtrEncoding();
}

const char *clang_Token_getName(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getName();
}

CXIdentifierInfo clang_Token_getIdentifierInfo(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->getIdentifierInfo();
}

void clang_Token_setIdentifierInfo(CXToken_ Tok, CXIdentifierInfo II) {
  static_cast<clang::Token *>(Tok)->setIdentifierInfo(
      static_cast<clang::IdentifierInfo *>(II));
}

bool clang_Token_isKind_eof(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::eof);
}

bool clang_Token_isKind_annot_repl_input_end(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_repl_input_end);
}

bool clang_Token_isKind_identifier(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::identifier);
}

bool clang_Token_isKind_coloncolon(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::coloncolon);
}

bool clang_Token_isKind_annot_cxxscope(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_cxxscope);
}

bool clang_Token_isKind_annot_typename(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_typename);
}

bool clang_Token_isKind_annot_template_id(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::annot_template_id);
}

bool clang_Token_isKind_kw_enum(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::kw_enum);
}

bool clang_Token_isKind_kw_typename(CXToken_ Tok) {
  return static_cast<clang::Token *>(Tok)->is(clang::tok::kw_typename);
}