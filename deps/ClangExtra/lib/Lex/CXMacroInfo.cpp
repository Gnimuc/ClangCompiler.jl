#include "clang-ex/Lex/CXMacroInfo.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/MacroInfo.h"
#include "clang/Lex/Preprocessor.h"

CXSourceLocation_ clang_MacroInfo_getDefinitionLoc(CXMacroInfo MI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MacroInfo *>(MI)->getDefinitionLoc().getPtrEncoding());
}

void clang_MacroInfo_setDefinitionEndLoc(CXMacroInfo MI, CXSourceLocation_ EndLoc) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setDefinitionEndLoc(
      clang::SourceLocation::getFromPtrEncoding(EndLoc));
}

CXSourceLocation_ clang_MacroInfo_getDefinitionEndLoc(CXMacroInfo MI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MacroInfo *>(MI)->getDefinitionEndLoc().getPtrEncoding());
}

unsigned clang_MacroInfo_getDefinitionLength(CXMacroInfo MI, CXSourceManager SM) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->getDefinitionLength(
      *reinterpret_cast<clang::SourceManager *>(SM));
}

bool clang_MacroInfo_isIdenticalTo(CXMacroInfo MI, CXMacroInfo Other, CXPreprocessor PP,
                                   bool Syntactically) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isIdenticalTo(
      *reinterpret_cast<clang::MacroInfo *>(Other), *reinterpret_cast<clang::Preprocessor *>(PP),
      Syntactically);
}

void clang_MacroInfo_setIsBuiltinMacro(CXMacroInfo MI, bool Val) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsBuiltinMacro(Val);
}

void clang_MacroInfo_setIsUsed(CXMacroInfo MI, bool Val) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsUsed(Val);
}

void clang_MacroInfo_setIsAllowRedefinitionsWithoutWarning(CXMacroInfo MI, bool Val) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsAllowRedefinitionsWithoutWarning(Val);
}

void clang_MacroInfo_setIsWarnIfUnused(CXMacroInfo MI, bool Val) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsWarnIfUnused(Val);
}

bool clang_MacroInfo_param_empty(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->param_empty();
}

unsigned clang_MacroInfo_getNumParams(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->getNumParams();
}

CXIdentifierInfo clang_MacroInfo_getParam(CXMacroInfo MI, unsigned Index) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::MacroInfo *>(MI)->params()[Index]));
}

int clang_MacroInfo_getParameterNum(CXMacroInfo MI, CXIdentifierInfo Arg) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->getParameterNum(
      reinterpret_cast<clang::IdentifierInfo *>(Arg));
}

void clang_MacroInfo_setIsFunctionLike(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsFunctionLike();
}

bool clang_MacroInfo_isFunctionLike(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isFunctionLike();
}

bool clang_MacroInfo_isObjectLike(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isObjectLike();
}

void clang_MacroInfo_setIsC99Varargs(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsC99Varargs();
}

void clang_MacroInfo_setIsGNUVarargs(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setIsGNUVarargs();
}

bool clang_MacroInfo_isC99Varargs(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isC99Varargs();
}

bool clang_MacroInfo_isGNUVarargs(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isGNUVarargs();
}

bool clang_MacroInfo_isVariadic(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isVariadic();
}

bool clang_MacroInfo_isBuiltinMacro(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isBuiltinMacro();
}

bool clang_MacroInfo_hasCommaPasting(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->hasCommaPasting();
}

void clang_MacroInfo_setHasCommaPasting(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setHasCommaPasting();
}

bool clang_MacroInfo_isUsed(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isUsed();
}

bool clang_MacroInfo_isAllowRedefinitionsWithoutWarning(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isAllowRedefinitionsWithoutWarning();
}

bool clang_MacroInfo_isWarnIfUnused(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isWarnIfUnused();
}

unsigned clang_MacroInfo_getNumTokens(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->getNumTokens();
}

CXToken_ clang_MacroInfo_getReplacementToken(CXMacroInfo MI, unsigned Index) {
  return reinterpret_cast<CXToken_>(const_cast<clang::Token *>(
      &reinterpret_cast<clang::MacroInfo *>(MI)->getReplacementToken(Index)));
}

bool clang_MacroInfo_tokens_empty(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->tokens_empty();
}

bool clang_MacroInfo_isEnabled(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isEnabled();
}

void clang_MacroInfo_EnableMacro(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->EnableMacro();
}

void clang_MacroInfo_DisableMacro(CXMacroInfo MI) {
  reinterpret_cast<clang::MacroInfo *>(MI)->DisableMacro();
}

bool clang_MacroInfo_isUsedForHeaderGuard(CXMacroInfo MI) {
  return reinterpret_cast<clang::MacroInfo *>(MI)->isUsedForHeaderGuard();
}

void clang_MacroInfo_setUsedForHeaderGuard(CXMacroInfo MI, bool Val) {
  reinterpret_cast<clang::MacroInfo *>(MI)->setUsedForHeaderGuard(Val);
}

void clang_MacroInfo_dump(CXMacroInfo MI) { reinterpret_cast<clang::MacroInfo *>(MI)->dump(); }

CXMacroDirectiveKind clang_MacroDirective_getKind(CXMacroDirective MD) {
  return static_cast<CXMacroDirectiveKind>(
      reinterpret_cast<clang::MacroDirective *>(MD)->getKind());
}

CXSourceLocation_ clang_MacroDirective_getLocation(CXMacroDirective MD) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MacroDirective *>(MD)->getLocation().getPtrEncoding());
}

void clang_MacroDirective_setPrevious(CXMacroDirective MD, CXMacroDirective Prev) {
  reinterpret_cast<clang::MacroDirective *>(MD)->setPrevious(
      reinterpret_cast<clang::MacroDirective *>(Prev));
}

CXMacroDirective clang_MacroDirective_getPrevious(CXMacroDirective MD) {
  return reinterpret_cast<CXMacroDirective>(reinterpret_cast<clang::MacroDirective *>(MD)->getPrevious());
}

bool clang_MacroDirective_isFromPCH(CXMacroDirective MD) {
  return reinterpret_cast<clang::MacroDirective *>(MD)->isFromPCH();
}

void clang_MacroDirective_setIsFromPCH(CXMacroDirective MD) {
  reinterpret_cast<clang::MacroDirective *>(MD)->setIsFromPCH();
}

CXDefInfo clang_MacroDirective_getDefinition(CXMacroDirective MD) {
  return reinterpret_cast<CXDefInfo>(new clang::MacroDirective::DefInfo(
      reinterpret_cast<clang::MacroDirective *>(MD)->getDefinition()));
}

bool clang_MacroDirective_isDefined(CXMacroDirective MD) {
  return reinterpret_cast<clang::MacroDirective *>(MD)->isDefined();
}

CXMacroInfo clang_MacroDirective_getMacroInfo(CXMacroDirective MD) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::MacroDirective *>(MD)->getMacroInfo());
}

CXDefInfo clang_MacroDirective_findDirectiveAtLoc(CXMacroDirective MD, CXSourceLocation_ L,
                                                  CXSourceManager SM) {
  return reinterpret_cast<CXDefInfo>(new clang::MacroDirective::DefInfo(
      reinterpret_cast<clang::MacroDirective *>(MD)->findDirectiveAtLoc(
          clang::SourceLocation::getFromPtrEncoding(L),
          *reinterpret_cast<clang::SourceManager *>(SM))));
}

void clang_MacroDirective_dump(CXMacroDirective MD) {
  reinterpret_cast<clang::MacroDirective *>(MD)->dump();
}

// MacroDirective::DefInfo

void clang_DefInfo_dispose(CXDefInfo DI) {
  delete reinterpret_cast<clang::MacroDirective::DefInfo *>(DI);
}

CXDefMacroDirective clang_DefInfo_getDirective(CXDefInfo DI) {
  return reinterpret_cast<CXDefMacroDirective>(reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->getDirective());
}

CXSourceLocation_ clang_DefInfo_getLocation(CXDefInfo DI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->getLocation().getPtrEncoding());
}

CXMacroInfo clang_DefInfo_getMacroInfo(CXDefInfo DI) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->getMacroInfo());
}

CXSourceLocation_ clang_DefInfo_getUndefLocation(CXDefInfo DI) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)
      ->getUndefLocation()
      .getPtrEncoding());
}

bool clang_DefInfo_isUndefined(CXDefInfo DI) {
  return reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->isUndefined();
}

bool clang_DefInfo_isPublic(CXDefInfo DI) {
  return reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->isPublic();
}

bool clang_DefInfo_isValid(CXDefInfo DI) {
  return reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->isValid();
}

bool clang_DefInfo_isInvalid(CXDefInfo DI) {
  return reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->isInvalid();
}

CXDefInfo clang_DefInfo_getPreviousDefinition(CXDefInfo DI) {
  return reinterpret_cast<CXDefInfo>(new clang::MacroDirective::DefInfo(
      reinterpret_cast<clang::MacroDirective::DefInfo *>(DI)->getPreviousDefinition()));
}

// DefMacroDirective

CXMacroInfo clang_DefMacroDirective_getInfo(CXDefMacroDirective DMD) {
  return reinterpret_cast<CXMacroInfo>(reinterpret_cast<clang::DefMacroDirective *>(DMD)->getInfo());
}
