#include "clang-ex/Basic/CXTokenKinds.h"
#include "clang/Basic/TokenKinds.h"

const char *clang_tok_getTokenName(unsigned Kind) {
  return clang::tok::getTokenName(static_cast<clang::tok::TokenKind>(Kind));
}

const char *clang_tok_getPunctuatorSpelling(unsigned Kind) {
  return clang::tok::getPunctuatorSpelling(static_cast<clang::tok::TokenKind>(Kind));
}

const char *clang_tok_getKeywordSpelling(unsigned Kind) {
  return clang::tok::getKeywordSpelling(static_cast<clang::tok::TokenKind>(Kind));
}

const char *clang_tok_getPPKeywordSpelling(CXPPKeywordKind Kind) {
  return clang::tok::getPPKeywordSpelling(static_cast<clang::tok::PPKeywordKind>(Kind));
}

bool clang_tok_isAnyIdentifier(unsigned Kind) {
  return clang::tok::isAnyIdentifier(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_tok_isStringLiteral(unsigned Kind) {
  return clang::tok::isStringLiteral(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_tok_isLiteral(unsigned Kind) {
  return clang::tok::isLiteral(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_tok_isAnnotation(unsigned Kind) {
  return clang::tok::isAnnotation(static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_tok_isPragmaAnnotation(unsigned Kind) {
  return clang::tok::isPragmaAnnotation(static_cast<clang::tok::TokenKind>(Kind));
}

// isRegularKeywordAttribute
