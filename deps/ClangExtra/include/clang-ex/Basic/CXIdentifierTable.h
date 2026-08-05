#ifndef LLVM_CLANG_C_EXTRA_CXIDENTIFIERTABLE_H
#define LLVM_CLANG_C_EXTRA_CXIDENTIFIERTABLE_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXTokenKinds.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// mirrors clang::ReservedIdentifierStatus (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXReservedIdentifierStatus {
  CXReservedIdentifierStatus_NotReserved,
  CXReservedIdentifierStatus_StartsWithUnderscoreAtGlobalScope,
  CXReservedIdentifierStatus_StartsWithUnderscoreAndIsExternC,
  CXReservedIdentifierStatus_StartsWithDoubleUnderscore,
  CXReservedIdentifierStatus_StartsWithUnderscoreFollowedByCapitalLetter,
  CXReservedIdentifierStatus_ContainsDoubleUnderscore
} CXReservedIdentifierStatus;

// mirrors clang::ReservedLiteralSuffixIdStatus (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXReservedLiteralSuffixIdStatus {
  CXReservedLiteralSuffixIdStatus_NotReserved,
  CXReservedLiteralSuffixIdStatus_NotStartsWithUnderscore,
  CXReservedLiteralSuffixIdStatus_ContainsDoubleUnderscore
} CXReservedLiteralSuffixIdStatus;

// mirrors clang::ObjCMethodFamily (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXObjCMethodFamily {
  CXObjCMethodFamily_OMF_None,
  CXObjCMethodFamily_OMF_alloc,
  CXObjCMethodFamily_OMF_copy,
  CXObjCMethodFamily_OMF_init,
  CXObjCMethodFamily_OMF_mutableCopy,
  CXObjCMethodFamily_OMF_new,
  CXObjCMethodFamily_OMF_autorelease,
  CXObjCMethodFamily_OMF_dealloc,
  CXObjCMethodFamily_OMF_finalize,
  CXObjCMethodFamily_OMF_release,
  CXObjCMethodFamily_OMF_retain,
  CXObjCMethodFamily_OMF_retainCount,
  CXObjCMethodFamily_OMF_self,
  CXObjCMethodFamily_OMF_initialize,
  CXObjCMethodFamily_OMF_performSelector
} CXObjCMethodFamily;

// mirrors clang::ObjCInstanceTypeFamily (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXObjCInstanceTypeFamily {
  CXObjCInstanceTypeFamily_OIT_None,
  CXObjCInstanceTypeFamily_OIT_Array,
  CXObjCInstanceTypeFamily_OIT_Dictionary,
  CXObjCInstanceTypeFamily_OIT_Singleton,
  CXObjCInstanceTypeFamily_OIT_Init,
  CXObjCInstanceTypeFamily_OIT_ReturnsSelf
} CXObjCInstanceTypeFamily;

// mirrors clang::ObjCStringFormatFamily (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXObjCStringFormatFamily {
  CXObjCStringFormatFamily_SFF_None,
  CXObjCStringFormatFamily_SFF_NSString,
  CXObjCStringFormatFamily_SFF_CFString
} CXObjCStringFormatFamily;

void clang_IdentifierTable_PrintStats(CXIdentifierTable IT);

CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents, const char *Name);

// like clang_IdentifierTable_get but without consulting the external identifier source;
// this is the entry point an external source itself uses, where get would recurse
CXIdentifierInfo clang_IdentifierTable_getOwn(CXIdentifierTable IT, const char *Name);

// heap-allocates an IdentifierTable populated with the keywords for LO
CXIdentifierTable clang_IdentifierTable_create(CXLangOptions LO);

void clang_IdentifierTable_dispose(CXIdentifierTable IT);

unsigned clang_IdentifierTable_size(CXIdentifierTable IT);

// helper: IdentifierTable::find != end (lookup without inserting)
bool clang_IdentifierTable_contains(CXIdentifierTable IT, const char *Name);

void clang_IdentifierTable_AddKeywords(CXIdentifierTable IT, CXLangOptions LO);

// The diagnostic id warning that II will become a keyword in a future standard. Returns a
// plain diag id, the same currency clang_DiagnosticsEngine_isIgnored and _getDiagnosticLevel
// take. PRECONDITION: II is a future-compatible keyword -- clang's own comment says the
// identifier must already have been determined to be one; gate with
// clang_IdentifierInfo_isFutureCompatKeyword.
unsigned clang_IdentifierTable_getFutureCompatDiagKind(CXIdentifierTable IT,
                                                       CXIdentifierInfo II,
                                                       CXLangOptions LangOpts);

const char *clang_IdentifierInfo_getName(CXIdentifierInfo II);

bool clang_IdentifierInfo_isStr(CXIdentifierInfo II, const char *Str);

const char *clang_IdentifierInfo_getNameStart(CXIdentifierInfo II);

unsigned clang_IdentifierInfo_getLength(CXIdentifierInfo II);

bool clang_IdentifierInfo_hasMacroDefinition(CXIdentifierInfo II);

void clang_IdentifierInfo_setHasMacroDefinition(CXIdentifierInfo II, bool Val);

bool clang_IdentifierInfo_hadMacroDefinition(CXIdentifierInfo II);

bool clang_IdentifierInfo_isDeprecatedMacro(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsDeprecatedMacro(CXIdentifierInfo II, bool Val);

bool clang_IdentifierInfo_isRestrictExpansion(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsRestrictExpansion(CXIdentifierInfo II, bool Val);

bool clang_IdentifierInfo_isFinal(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsFinal(CXIdentifierInfo II, bool Val);

// returns the raw clang::tok::TokenKind value (query it with the clang_tok_*
// functions in CXTokenKinds.h)
unsigned clang_IdentifierInfo_getTokenID(CXIdentifierInfo II);

bool clang_IdentifierInfo_hasRevertedTokenIDToIdentifier(CXIdentifierInfo II);

// PRECONDITION: clang_IdentifierInfo_getTokenID(II) != clang::tok::identifier — the
// Clang method only asserts that, so reverting an already-reverted identifier is UB in
// a release build.
void clang_IdentifierInfo_revertTokenIDToIdentifier(CXIdentifierInfo II);

// TK is a raw clang::tok::TokenKind value (e.g. one previously read with
// clang_IdentifierInfo_getTokenID).
// PRECONDITION: clang_IdentifierInfo_getTokenID(II) == clang::tok::identifier — the
// Clang method only asserts that.
void clang_IdentifierInfo_revertIdentifierToTokenID(CXIdentifierInfo II, unsigned TK);

CXPPKeywordKind clang_IdentifierInfo_getPPKeywordID(CXIdentifierInfo II);

// returns the raw clang::tok::ObjCKeywordKind value (0 is tok::objc_not_keyword; that
// enum's .def-generated enumerators are not mirrored)
unsigned clang_IdentifierInfo_getObjCKeywordID(CXIdentifierInfo II);

// ID is a raw clang::tok::ObjCKeywordKind value. It overwrites the whole packed
// ObjCOrBuiltinID field, so it also clears any builtin or interesting-identifier ID.
void clang_IdentifierInfo_setObjCKeywordID(CXIdentifierInfo II, unsigned ID);

unsigned clang_IdentifierInfo_getBuiltinID(CXIdentifierInfo II);

// PRECONDITION: 1 <= ID <= clang_IdentifierInfo_getMaxBuiltinID() — the Clang method
// asserts ID != 0 and asserts that the packed field can round-trip ID.
void clang_IdentifierInfo_setBuiltinID(CXIdentifierInfo II, unsigned ID);

// helper: largest builtin ID the packed ObjCOrBuiltinID field can round-trip, i.e. the
// upper bound clang_IdentifierInfo_setBuiltinID accepts.
unsigned clang_IdentifierInfo_getMaxBuiltinID(void);

// zeroes the packed ObjCOrBuiltinID field (clearing the ObjC-keyword and
// interesting-identifier regions along with the builtin one)
void clang_IdentifierInfo_clearBuiltinID(CXIdentifierInfo II);

// returns the raw clang::tok::InterestingIdentifierKind value (0 is
// tok::not_interesting; that enum's .def-generated enumerators are not mirrored)
unsigned clang_IdentifierInfo_getInterestingIdentifierID(CXIdentifierInfo II);

// PRECONDITION: 1 <= ID <= clang_IdentifierInfo_getMaxInterestingIdentifierID() — the
// Clang method asserts ID != tok::not_interesting and asserts the round-trip.
void clang_IdentifierInfo_setInterestingIdentifierID(CXIdentifierInfo II, unsigned ID);

// helper: largest clang::tok::InterestingIdentifierKind value, i.e. the upper bound
// clang_IdentifierInfo_setInterestingIdentifierID accepts.
unsigned clang_IdentifierInfo_getMaxInterestingIdentifierID(void);

// the packed field backing getObjCKeywordID, getInterestingIdentifierID and
// getBuiltinID
unsigned clang_IdentifierInfo_getObjCOrBuiltinID(CXIdentifierInfo II);

// writes the packed field backing setObjCKeywordID, setInterestingIdentifierID and
// setBuiltinID directly, without encoding that field's three-region layout
void clang_IdentifierInfo_setObjCOrBuiltinID(CXIdentifierInfo II, unsigned ID);

bool clang_IdentifierInfo_isExtensionToken(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsExtensionToken(CXIdentifierInfo II, bool Val);

bool clang_IdentifierInfo_isFutureCompatKeyword(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsFutureCompatKeyword(CXIdentifierInfo II, bool Val);

void clang_IdentifierInfo_setIsPoisoned(CXIdentifierInfo II, bool Value);

bool clang_IdentifierInfo_isPoisoned(CXIdentifierInfo II);

void clang_IdentifierInfo_setIsCPlusPlusOperatorKeyword(CXIdentifierInfo II, bool Val);

bool clang_IdentifierInfo_isCPlusPlusOperatorKeyword(CXIdentifierInfo II);

bool clang_IdentifierInfo_isKeyword(CXIdentifierInfo II, CXLangOptions LO);

bool clang_IdentifierInfo_isCPlusPlusKeyword(CXIdentifierInfo II, CXLangOptions LO);

// getFETokenInfo
// setFETokenInfo

bool clang_IdentifierInfo_isHandleIdentifierCase(CXIdentifierInfo II);

bool clang_IdentifierInfo_isFromAST(CXIdentifierInfo II);

// one-way: clang::IdentifierInfo has no matching clear
void clang_IdentifierInfo_setIsFromAST(CXIdentifierInfo II);

bool clang_IdentifierInfo_hasChangedSinceDeserialization(CXIdentifierInfo II);

// one-way: clang::IdentifierInfo has no matching clear
void clang_IdentifierInfo_setChangedSinceDeserialization(CXIdentifierInfo II);

bool clang_IdentifierInfo_hasFETokenInfoChangedSinceDeserialization(CXIdentifierInfo II);

// one-way: clang::IdentifierInfo has no matching clear
void clang_IdentifierInfo_setFETokenInfoChangedSinceDeserialization(CXIdentifierInfo II);

bool clang_IdentifierInfo_isOutOfDate(CXIdentifierInfo II);

void clang_IdentifierInfo_setOutOfDate(CXIdentifierInfo II, bool OOD);

bool clang_IdentifierInfo_isModulesImport(CXIdentifierInfo II);

void clang_IdentifierInfo_setModulesImport(CXIdentifierInfo II, bool I);

bool clang_IdentifierInfo_isMangledOpenMPVariantName(CXIdentifierInfo II);

void clang_IdentifierInfo_setMangledOpenMPVariantName(CXIdentifierInfo II, bool I);

bool clang_IdentifierInfo_isEditorPlaceholder(CXIdentifierInfo II);

CXReservedIdentifierStatus clang_IdentifierInfo_isReserved(CXIdentifierInfo II,
                                                           CXLangOptions LO);

CXReservedLiteralSuffixIdStatus
clang_IdentifierInfo_isReservedLiteralSuffixId(CXIdentifierInfo II);

CXString clang_IdentifierInfo_deuglifiedName(CXIdentifierInfo II);

bool clang_IdentifierInfo_isPlaceholder(CXIdentifierInfo II);

// Selector
//
// A CXSelector is NOT a pointer to a clang::Selector: it is the value's own opaque
// encoding (Selector::getAsOpaquePtr()), the same way CXQualType and CXDeclarationName
// carry their value types. NULL is the null selector, so a CXSelector may legitimately
// be NULL; nothing here allocates, and no dispose exists.

bool clang_Selector_isNull(CXSelector Sel);

// getAsOpaquePtr is the CXSelector representation itself, so it needs no wrapper.

bool clang_Selector_isKeywordSelector(CXSelector Sel);

bool clang_Selector_isUnarySelector(CXSelector Sel);

unsigned clang_Selector_getNumArgs(CXSelector Sel);

// May return NULL: a slot need not carry an identifier.
// PRECONDITION: ArgIndex == 0, or ArgIndex < clang_Selector_getNumArgs(Sel) — the Clang
// method only asserts that for the zero- and one-argument representations, and indexes a
// MultiKeywordSelector unchecked otherwise.
CXIdentifierInfo clang_Selector_getIdentifierInfoForSlot(CXSelector Sel, unsigned ArgIndex);

// the empty string when the slot carries no identifier.
// PRECONDITION: same as clang_Selector_getIdentifierInfoForSlot.
CXString clang_Selector_getNameForSlot(CXSelector Sel, unsigned ArgIndex);

// the full selector name, e.g. "foo:bar:"
CXString clang_Selector_getAsString(CXSelector Sel);

// print writes the same text clang_Selector_getAsString returns, so only dump (which
// streams it to llvm::errs()) is wrapped.
void clang_Selector_dump(CXSelector Sel);

CXObjCMethodFamily clang_Selector_getMethodFamily(CXSelector Sel);

CXObjCStringFormatFamily clang_Selector_getStringFormatFamily(CXSelector Sel);

// static
CXObjCInstanceTypeFamily clang_Selector_getInstTypeMethodFamily(CXSelector Sel);

// static: llvm::DenseMap's empty key. The result is a sentinel encoding, not a real
// selector — only clang_Selector_isNull (a plain comparison) is defined on it.
CXSelector clang_Selector_getEmptyMarker(void);

// static: llvm::DenseMap's tombstone key. Same caveat as clang_Selector_getEmptyMarker.
CXSelector clang_Selector_getTombstoneMarker(void);

// SelectorTable

// IIV is a (handle-buffer, count) array of CXIdentifierInfo handles rebuilt into an
// IdentifierInfo ** inside the shim. It must hold at least max(NumArgs, 1) elements:
// Clang reads IIV[0] even when NumArgs is 0.
CXSelector clang_SelectorTable_getSelector(CXSelectorTable SelTab, unsigned NumArgs,
                                           const CXIdentifierInfo *IIV);

// the one-argument selector "ID:"
CXSelector clang_SelectorTable_getUnarySelector(CXSelectorTable SelTab,
                                                CXIdentifierInfo ID);

// the zero-argument selector "ID"
CXSelector clang_SelectorTable_getNullarySelector(CXSelectorTable SelTab,
                                                  CXIdentifierInfo ID);

size_t clang_SelectorTable_getTotalMemory(CXSelectorTable SelTab);

// static: "set" followed by Name with its initial character capitalized.
// PRECONDITION: Name is non-empty — the Clang method indexes its result at 3.
CXString clang_SelectorTable_constructSetterName(const char *Name);

// static: the one-argument selector spelled clang_SelectorTable_constructSetterName(Name).
// PRECONDITION: Name's spelling is non-empty (see constructSetterName).
CXSelector clang_SelectorTable_constructSetterSelector(CXIdentifierTable Idents,
                                                       CXSelectorTable SelTab,
                                                       CXIdentifierInfo Name);

// static: strips the "set" prefix of a setter selector and lowercases what follows.
// PRECONDITION: clang_Selector_getNameForSlot(Sel, 0) starts with "set" and is at least
// four characters long — the Clang method asserts the prefix and indexes at 3.
CXString clang_SelectorTable_getPropertyNameFromSetterSelector(CXSelector Sel);

LLVM_CLANG_C_EXTERN_C_END

#endif