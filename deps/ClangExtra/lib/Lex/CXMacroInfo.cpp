#include "clang-ex/Lex/CXMacroInfo.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/MacroInfo.h"
#include "clang/Lex/Preprocessor.h"

CXSourceLocation_ clang_MacroInfo_getDefinitionLoc(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->getDefinitionLoc().getPtrEncoding();
}

CXSourceLocation_ clang_MacroInfo_getDefinitionEndLoc(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->getDefinitionEndLoc().getPtrEncoding();
}

unsigned clang_MacroInfo_getDefinitionLength(CXMacroInfo MI, CXSourceManager SM) {
  return static_cast<clang::MacroInfo *>(MI)->getDefinitionLength(
      *static_cast<clang::SourceManager *>(SM));
}

bool clang_MacroInfo_isIdenticalTo(CXMacroInfo MI, CXMacroInfo Other, CXPreprocessor PP,
                                   bool Syntactically) {
  return static_cast<clang::MacroInfo *>(MI)->isIdenticalTo(
      *static_cast<clang::MacroInfo *>(Other), *static_cast<clang::Preprocessor *>(PP),
      Syntactically);
}

bool clang_MacroInfo_param_empty(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->param_empty();
}

unsigned clang_MacroInfo_getNumParams(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->getNumParams();
}

CXIdentifierInfo clang_MacroInfo_getParam(CXMacroInfo MI, unsigned Index) {
  return const_cast<clang::IdentifierInfo *>(
      static_cast<clang::MacroInfo *>(MI)->params()[Index]);
}

int clang_MacroInfo_getParameterNum(CXMacroInfo MI, CXIdentifierInfo Arg) {
  return static_cast<clang::MacroInfo *>(MI)->getParameterNum(
      static_cast<clang::IdentifierInfo *>(Arg));
}

bool clang_MacroInfo_isFunctionLike(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isFunctionLike();
}

bool clang_MacroInfo_isObjectLike(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isObjectLike();
}

bool clang_MacroInfo_isC99Varargs(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isC99Varargs();
}

bool clang_MacroInfo_isGNUVarargs(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isGNUVarargs();
}

bool clang_MacroInfo_isVariadic(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isVariadic();
}

bool clang_MacroInfo_isBuiltinMacro(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isBuiltinMacro();
}

bool clang_MacroInfo_hasCommaPasting(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->hasCommaPasting();
}

bool clang_MacroInfo_isUsed(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isUsed();
}

bool clang_MacroInfo_isAllowRedefinitionsWithoutWarning(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isAllowRedefinitionsWithoutWarning();
}

bool clang_MacroInfo_isWarnIfUnused(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isWarnIfUnused();
}

unsigned clang_MacroInfo_getNumTokens(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->getNumTokens();
}

CXToken_ clang_MacroInfo_getReplacementToken(CXMacroInfo MI, unsigned Index) {
  return const_cast<clang::Token *>(
      &static_cast<clang::MacroInfo *>(MI)->getReplacementToken(Index));
}

bool clang_MacroInfo_isEnabled(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isEnabled();
}

bool clang_MacroInfo_isUsedForHeaderGuard(CXMacroInfo MI) {
  return static_cast<clang::MacroInfo *>(MI)->isUsedForHeaderGuard();
}

void clang_MacroInfo_dump(CXMacroInfo MI) { static_cast<clang::MacroInfo *>(MI)->dump(); }