#include "clang-ex/Basic/CXLangStandard.h"
#include "utils.h"

#include "clang/Basic/LangStandard.h"
#include "llvm/TargetParser/Triple.h"

static const clang::LangStandard *unwrapLS(CXLangStandard LS) {
  return reinterpret_cast<const clang::LangStandard *>(LS);
}

CXLangStandardKind clang_LangStandard_getLangKind(const char *Name) {
  return static_cast<CXLangStandardKind>(
      clang::LangStandard::getLangKind(llvm::StringRef(Name)));
}

CXLangStandard clang_LangStandard_getLangStandardForKind(CXLangStandardKind K) {
  const clang::LangStandard &LS = clang::LangStandard::getLangStandardForKind(
      static_cast<clang::LangStandard::Kind>(K));
  return reinterpret_cast<CXLangStandard>(const_cast<clang::LangStandard *>(&LS));
}

CXLangStandard clang_LangStandard_getLangStandardForName(const char *Name) {
  return reinterpret_cast<CXLangStandard>(const_cast<clang::LangStandard *>(
      clang::LangStandard::getLangStandardForName(llvm::StringRef(Name))));
}

const char *clang_LangStandard_getName(CXLangStandard LS) {
  return unwrapLS(LS)->getName();
}

const char *clang_LangStandard_getDescription(CXLangStandard LS) {
  return unwrapLS(LS)->getDescription();
}

CXLanguage clang_LangStandard_getLanguage(CXLangStandard LS) {
  return static_cast<CXLanguage>(unwrapLS(LS)->getLanguage());
}

bool clang_LangStandard_hasLineComments(CXLangStandard LS) {
  return unwrapLS(LS)->hasLineComments();
}

bool clang_LangStandard_isC99(CXLangStandard LS) { return unwrapLS(LS)->isC99(); }

bool clang_LangStandard_isC11(CXLangStandard LS) { return unwrapLS(LS)->isC11(); }

bool clang_LangStandard_isC17(CXLangStandard LS) { return unwrapLS(LS)->isC17(); }

bool clang_LangStandard_isC23(CXLangStandard LS) { return unwrapLS(LS)->isC23(); }

bool clang_LangStandard_isCPlusPlus(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus();
}

bool clang_LangStandard_isCPlusPlus11(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus11();
}

bool clang_LangStandard_isCPlusPlus14(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus14();
}

bool clang_LangStandard_isCPlusPlus17(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus17();
}

bool clang_LangStandard_isCPlusPlus20(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus20();
}

bool clang_LangStandard_isCPlusPlus23(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus23();
}

bool clang_LangStandard_isCPlusPlus26(CXLangStandard LS) {
  return unwrapLS(LS)->isCPlusPlus26();
}

bool clang_LangStandard_hasDigraphs(CXLangStandard LS) {
  return unwrapLS(LS)->hasDigraphs();
}

bool clang_LangStandard_isGNUMode(CXLangStandard LS) {
  return unwrapLS(LS)->isGNUMode();
}

bool clang_LangStandard_hasHexFloats(CXLangStandard LS) {
  return unwrapLS(LS)->hasHexFloats();
}

bool clang_LangStandard_isOpenCL(CXLangStandard LS) { return unwrapLS(LS)->isOpenCL(); }

CXString clang_languageToString(CXLanguage L) {
  return extra::makeCXString(
      clang::languageToString(static_cast<clang::Language>(L)).str());
}

CXLangStandardKind clang_getDefaultLanguageStandard(CXLanguage Lang, const char *Triple) {
  return static_cast<CXLangStandardKind>(clang::getDefaultLanguageStandard(
      static_cast<clang::Language>(Lang), llvm::Triple(llvm::StringRef(Triple))));
}
