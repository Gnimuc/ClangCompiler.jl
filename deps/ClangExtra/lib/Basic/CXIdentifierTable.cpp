#include "clang-ex/Basic/CXIdentifierTable.h"
#include "utils.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <cstdint>

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

const char *clang_IdentifierInfo_getNameStart(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getNameStart();
}

unsigned clang_IdentifierInfo_getLength(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getLength();
}

bool clang_IdentifierInfo_hasMacroDefinition(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hasMacroDefinition();
}

void clang_IdentifierInfo_setHasMacroDefinition(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setHasMacroDefinition(Val);
}

bool clang_IdentifierInfo_hadMacroDefinition(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hadMacroDefinition();
}

bool clang_IdentifierInfo_isDeprecatedMacro(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isDeprecatedMacro();
}

void clang_IdentifierInfo_setIsDeprecatedMacro(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsDeprecatedMacro(Val);
}

bool clang_IdentifierInfo_isRestrictExpansion(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isRestrictExpansion();
}

void clang_IdentifierInfo_setIsRestrictExpansion(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsRestrictExpansion(Val);
}

bool clang_IdentifierInfo_isFinal(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isFinal();
}

void clang_IdentifierInfo_setIsFinal(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsFinal(Val);
}

unsigned clang_IdentifierInfo_getTokenID(CXIdentifierInfo II) {
  return static_cast<unsigned>(static_cast<clang::IdentifierInfo *>(II)->getTokenID());
}

bool clang_IdentifierInfo_hasRevertedTokenIDToIdentifier(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hasRevertedTokenIDToIdentifier();
}

void clang_IdentifierInfo_revertTokenIDToIdentifier(CXIdentifierInfo II) {
  static_cast<clang::IdentifierInfo *>(II)->revertTokenIDToIdentifier();
}

void clang_IdentifierInfo_revertIdentifierToTokenID(CXIdentifierInfo II, unsigned TK) {
  static_cast<clang::IdentifierInfo *>(II)->revertIdentifierToTokenID(
      static_cast<clang::tok::TokenKind>(TK));
}

CXPPKeywordKind clang_IdentifierInfo_getPPKeywordID(CXIdentifierInfo II) {
  return static_cast<CXPPKeywordKind>(
      static_cast<clang::IdentifierInfo *>(II)->getPPKeywordID());
}

unsigned clang_IdentifierInfo_getObjCKeywordID(CXIdentifierInfo II) {
  return static_cast<unsigned>(
      static_cast<clang::IdentifierInfo *>(II)->getObjCKeywordID());
}

void clang_IdentifierInfo_setObjCKeywordID(CXIdentifierInfo II, unsigned ID) {
  static_cast<clang::IdentifierInfo *>(II)->setObjCKeywordID(
      static_cast<clang::tok::ObjCKeywordKind>(ID));
}

unsigned clang_IdentifierInfo_getBuiltinID(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getBuiltinID();
}

void clang_IdentifierInfo_setBuiltinID(CXIdentifierInfo II, unsigned ID) {
  static_cast<clang::IdentifierInfo *>(II)->setBuiltinID(ID);
}

unsigned clang_IdentifierInfo_getMaxBuiltinID(void) {
  return (1u << clang::ObjCOrBuiltinIDBits) - static_cast<unsigned>(clang::FirstBuiltinID);
}

void clang_IdentifierInfo_clearBuiltinID(CXIdentifierInfo II) {
  static_cast<clang::IdentifierInfo *>(II)->clearBuiltinID();
}

unsigned clang_IdentifierInfo_getInterestingIdentifierID(CXIdentifierInfo II) {
  return static_cast<unsigned>(
      static_cast<clang::IdentifierInfo *>(II)->getInterestingIdentifierID());
}

void clang_IdentifierInfo_setInterestingIdentifierID(CXIdentifierInfo II, unsigned ID) {
  static_cast<clang::IdentifierInfo *>(II)->setInterestingIdentifierID(ID);
}

unsigned clang_IdentifierInfo_getMaxInterestingIdentifierID(void) {
  return static_cast<unsigned>(clang::LastInterestingIdentifierID -
                               clang::FirstInterestingIdentifierID + 1);
}

unsigned clang_IdentifierInfo_getObjCOrBuiltinID(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getObjCOrBuiltinID();
}

void clang_IdentifierInfo_setObjCOrBuiltinID(CXIdentifierInfo II, unsigned ID) {
  static_cast<clang::IdentifierInfo *>(II)->setObjCOrBuiltinID(ID);
}

bool clang_IdentifierInfo_isExtensionToken(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isExtensionToken();
}

void clang_IdentifierInfo_setIsExtensionToken(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsExtensionToken(Val);
}

bool clang_IdentifierInfo_isFutureCompatKeyword(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isFutureCompatKeyword();
}

void clang_IdentifierInfo_setIsFutureCompatKeyword(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsFutureCompatKeyword(Val);
}

void clang_IdentifierInfo_setIsPoisoned(CXIdentifierInfo II, bool Value) {
  static_cast<clang::IdentifierInfo *>(II)->setIsPoisoned(Value);
}

bool clang_IdentifierInfo_isPoisoned(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isPoisoned();
}

void clang_IdentifierInfo_setIsCPlusPlusOperatorKeyword(CXIdentifierInfo II, bool Val) {
  static_cast<clang::IdentifierInfo *>(II)->setIsCPlusPlusOperatorKeyword(Val);
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

bool clang_IdentifierInfo_isHandleIdentifierCase(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isHandleIdentifierCase();
}

bool clang_IdentifierInfo_isFromAST(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isFromAST();
}

void clang_IdentifierInfo_setIsFromAST(CXIdentifierInfo II) {
  static_cast<clang::IdentifierInfo *>(II)->setIsFromAST();
}

bool clang_IdentifierInfo_hasChangedSinceDeserialization(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->hasChangedSinceDeserialization();
}

void clang_IdentifierInfo_setChangedSinceDeserialization(CXIdentifierInfo II) {
  static_cast<clang::IdentifierInfo *>(II)->setChangedSinceDeserialization();
}

bool clang_IdentifierInfo_hasFETokenInfoChangedSinceDeserialization(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)
      ->hasFETokenInfoChangedSinceDeserialization();
}

void clang_IdentifierInfo_setFETokenInfoChangedSinceDeserialization(CXIdentifierInfo II) {
  static_cast<clang::IdentifierInfo *>(II)->setFETokenInfoChangedSinceDeserialization();
}

bool clang_IdentifierInfo_isOutOfDate(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isOutOfDate();
}

void clang_IdentifierInfo_setOutOfDate(CXIdentifierInfo II, bool OOD) {
  static_cast<clang::IdentifierInfo *>(II)->setOutOfDate(OOD);
}

bool clang_IdentifierInfo_isModulesImport(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isModulesImport();
}

void clang_IdentifierInfo_setModulesImport(CXIdentifierInfo II, bool I) {
  static_cast<clang::IdentifierInfo *>(II)->setModulesImport(I);
}

bool clang_IdentifierInfo_isMangledOpenMPVariantName(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->isMangledOpenMPVariantName();
}

void clang_IdentifierInfo_setMangledOpenMPVariantName(CXIdentifierInfo II, bool I) {
  static_cast<clang::IdentifierInfo *>(II)->setMangledOpenMPVariantName(I);
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

CXIdentifierInfo clang_IdentifierTable_getOwn(CXIdentifierTable IT, const char *Name) {
  return &static_cast<clang::IdentifierTable *>(IT)->getOwn(llvm::StringRef(Name));
}

const char *clang_IdentifierInfo_getName(CXIdentifierInfo II) {
  return static_cast<clang::IdentifierInfo *>(II)->getName().data();
}
// A CXSelector is the clang::Selector value's own opaque encoding, so it is rebuilt
// through Selector's public uintptr_t constructor rather than dereferenced.
static clang::Selector toSelector(CXSelector Sel) {
  return clang::Selector(reinterpret_cast<uintptr_t>(Sel));
}

bool clang_Selector_isNull(CXSelector Sel) { return toSelector(Sel).isNull(); }

bool clang_Selector_isKeywordSelector(CXSelector Sel) {
  return toSelector(Sel).isKeywordSelector();
}

bool clang_Selector_isUnarySelector(CXSelector Sel) {
  return toSelector(Sel).isUnarySelector();
}

unsigned clang_Selector_getNumArgs(CXSelector Sel) { return toSelector(Sel).getNumArgs(); }

CXIdentifierInfo clang_Selector_getIdentifierInfoForSlot(CXSelector Sel,
                                                         unsigned ArgIndex) {
  return toSelector(Sel).getIdentifierInfoForSlot(ArgIndex);
}

CXString clang_Selector_getNameForSlot(CXSelector Sel, unsigned ArgIndex) {
  return extra::makeCXString(toSelector(Sel).getNameForSlot(ArgIndex).str());
}

CXString clang_Selector_getAsString(CXSelector Sel) {
  return extra::makeCXString(toSelector(Sel).getAsString());
}

void clang_Selector_dump(CXSelector Sel) { toSelector(Sel).dump(); }

CXObjCMethodFamily clang_Selector_getMethodFamily(CXSelector Sel) {
  return static_cast<CXObjCMethodFamily>(toSelector(Sel).getMethodFamily());
}

CXObjCStringFormatFamily clang_Selector_getStringFormatFamily(CXSelector Sel) {
  return static_cast<CXObjCStringFormatFamily>(toSelector(Sel).getStringFormatFamily());
}

CXObjCInstanceTypeFamily clang_Selector_getInstTypeMethodFamily(CXSelector Sel) {
  return static_cast<CXObjCInstanceTypeFamily>(
      clang::Selector::getInstTypeMethodFamily(toSelector(Sel)));
}

CXSelector clang_Selector_getEmptyMarker(void) {
  return clang::Selector::getEmptyMarker().getAsOpaquePtr();
}

CXSelector clang_Selector_getTombstoneMarker(void) {
  return clang::Selector::getTombstoneMarker().getAsOpaquePtr();
}

CXSelector clang_SelectorTable_getSelector(CXSelectorTable SelTab, unsigned NumArgs,
                                           const CXIdentifierInfo *IIV) {
  llvm::SmallVector<clang::IdentifierInfo *, 8> Idents;
  for (unsigned I = 0, E = NumArgs ? NumArgs : 1u; I != E; ++I)
    Idents.push_back(static_cast<clang::IdentifierInfo *>(IIV[I]));
  return static_cast<clang::SelectorTable *>(SelTab)
      ->getSelector(NumArgs, Idents.data())
      .getAsOpaquePtr();
}

CXSelector clang_SelectorTable_getUnarySelector(CXSelectorTable SelTab,
                                                CXIdentifierInfo ID) {
  return static_cast<clang::SelectorTable *>(SelTab)
      ->getUnarySelector(static_cast<clang::IdentifierInfo *>(ID))
      .getAsOpaquePtr();
}

CXSelector clang_SelectorTable_getNullarySelector(CXSelectorTable SelTab,
                                                  CXIdentifierInfo ID) {
  return static_cast<clang::SelectorTable *>(SelTab)
      ->getNullarySelector(static_cast<clang::IdentifierInfo *>(ID))
      .getAsOpaquePtr();
}

size_t clang_SelectorTable_getTotalMemory(CXSelectorTable SelTab) {
  return static_cast<clang::SelectorTable *>(SelTab)->getTotalMemory();
}

CXString clang_SelectorTable_constructSetterName(const char *Name) {
  llvm::SmallString<64> Setter =
      clang::SelectorTable::constructSetterName(llvm::StringRef(Name));
  return extra::makeCXString(Setter.str().str());
}

CXSelector clang_SelectorTable_constructSetterSelector(CXIdentifierTable Idents,
                                                       CXSelectorTable SelTab,
                                                       CXIdentifierInfo Name) {
  return clang::SelectorTable::constructSetterSelector(
             *static_cast<clang::IdentifierTable *>(Idents),
             *static_cast<clang::SelectorTable *>(SelTab),
             static_cast<clang::IdentifierInfo *>(Name))
      .getAsOpaquePtr();
}

CXString clang_SelectorTable_getPropertyNameFromSetterSelector(CXSelector Sel) {
  return extra::makeCXString(
      clang::SelectorTable::getPropertyNameFromSetterSelector(toSelector(Sel)));
}

unsigned clang_IdentifierTable_getFutureCompatDiagKind(CXIdentifierTable IT,
                                                       CXIdentifierInfo II,
                                                       CXLangOptions LangOpts) {
  return static_cast<clang::IdentifierTable *>(IT)->getFutureCompatDiagKind(
      *static_cast<clang::IdentifierInfo *>(II),
      *static_cast<clang::LangOptions *>(LangOpts));
}
