#include "clang-ex/Basic/CXIdentifierTable.h"
#include "utils.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/LangOptions.h"

CXIdentifierTable clang_IdentifierTable_create(CXLangOptions LO) {
  auto IT =
      std::make_unique<clang::IdentifierTable>(*static_cast<clang::LangOptions *>(LO));
  return IT.release();
}

void clang_IdentifierTable_dispose(CXIdentifierTable IT) {
  delete static_cast<clang::IdentifierTable *>(IT);
}

unsigned clang_IdentifierTable_size(CXIdentifierTable IT) {
  return static_cast<clang::IdentifierTable *>(IT)->size();
}

bool clang_IdentifierTable_contains(CXIdentifierTable IT, const char *Name) {
  auto Table = static_cast<clang::IdentifierTable *>(IT);
  return Table->find(llvm::StringRef(Name)) != Table->end();
}

void clang_IdentifierTable_AddKeywords(CXIdentifierTable IT, CXLangOptions LO) {
  static_cast<clang::IdentifierTable *>(IT)->AddKeywords(
      *static_cast<clang::LangOptions *>(LO));
}

bool clang_IdentifierInfo_isStr(CXIdentifierInfo II, const char *Str) {
  return static_cast<clang::IdentifierInfo *>(II)->isStr(llvm::StringRef(Str));
}

unsigned clang_IdentifierInfo_getLength(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getLength();
}

bool clang_IdentifierInfo_hasMacroDefinition(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hasMacroDefinition();
}

bool clang_IdentifierInfo_hadMacroDefinition(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hadMacroDefinition();
}

bool clang_IdentifierInfo_isDeprecatedMacro(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isDeprecatedMacro();
}

bool clang_IdentifierInfo_isFinal(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isFinal();
}

unsigned clang_IdentifierInfo_getTokenID(CXIdentifierInfo II) {
  return static_cast<unsigned>(static_cast<clang::IdentifierInfo *>(II)->getTokenID());
}

CXPPKeywordKind clang_IdentifierInfo_getPPKeywordID(CXIdentifierInfo II) {
  return static_cast<CXPPKeywordKind>(
      static_cast<clang::IdentifierInfo *>(II)->getPPKeywordID());
}

unsigned clang_IdentifierInfo_getBuiltinID(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getBuiltinID();
}

bool clang_IdentifierInfo_isExtensionToken(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isExtensionToken();
}

bool clang_IdentifierInfo_isFutureCompatKeyword(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isFutureCompatKeyword();
}

void clang_IdentifierInfo_setIsPoisoned(CXIdentifierInfo II, bool Value) {
  static_cast<clang::IdentifierInfo *>(II)->setIsPoisoned(Value);
}

bool clang_IdentifierInfo_isPoisoned(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isPoisoned();
}

bool clang_IdentifierInfo_isCPlusPlusOperatorKeyword(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isCPlusPlusOperatorKeyword();
}

bool clang_IdentifierInfo_isKeyword(CXIdentifierInfo II, CXLangOptions LO) {
  return static_cast<clang::IdentifierInfo *>(II)->isKeyword(
      *static_cast<clang::LangOptions *>(LO));
}

bool clang_IdentifierInfo_isCPlusPlusKeyword(CXIdentifierInfo II, CXLangOptions LO) {
  return static_cast<clang::IdentifierInfo *>(II)->isCPlusPlusKeyword(
      *static_cast<clang::LangOptions *>(LO));
}

bool clang_IdentifierInfo_isEditorPlaceholder(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isEditorPlaceholder();
}

CXReservedIdentifierStatus clang_IdentifierInfo_isReserved(CXIdentifierInfo II,
                                                           CXLangOptions LO) {
  return static_cast<CXReservedIdentifierStatus>(
      static_cast<clang::IdentifierInfo *>(II)->isReserved(
          *static_cast<clang::LangOptions *>(LO)));
}

CXReservedLiteralSuffixIdStatus
clang_IdentifierInfo_isReservedLiteralSuffixId(CXIdentifierInfo II) {
  return static_cast<CXReservedLiteralSuffixIdStatus>(
      static_cast<clang::IdentifierInfo *>(II)->isReservedLiteralSuffixId());
}

CXString clang_IdentifierInfo_deuglifiedName(CXIdentifierInfo II) {
  return extra::makeCXString(
      static_cast<clang::IdentifierInfo *>(II)->deuglifiedName().str());
}

bool clang_IdentifierInfo_isPlaceholder(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isPlaceholder();
}

void clang_IdentifierTable_PrintStats(CXIdentifierTable IT) {
  static_cast<clang::IdentifierTable *>(IT)->PrintStats();
}

CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents, const char *Name) {
  return &static_cast<clang::IdentifierTable *>(Idents)->get(llvm::StringRef(Name));
}

const char *clang_IdentifierInfo_getName(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getName().data();
}