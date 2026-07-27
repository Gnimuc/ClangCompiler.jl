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

// mirrors clang::ObjCStringFormatFamily (clang/Basic/IdentifierTable.h).
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXObjCStringFormatFamily {
  CXObjCStringFormatFamily_SFF_None,
  CXObjCStringFormatFamily_SFF_NSString,
  CXObjCStringFormatFamily_SFF_CFString
} CXObjCStringFormatFamily;

void clang_IdentifierTable_PrintStats(CXIdentifierTable IT);

CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents, const char *Name);

// heap-allocates an IdentifierTable populated with the keywords for LO
CXIdentifierTable clang_IdentifierTable_create(CXLangOptions LO);

void clang_IdentifierTable_dispose(CXIdentifierTable IT);

unsigned clang_IdentifierTable_size(CXIdentifierTable IT);

// helper: IdentifierTable::find != end (lookup without inserting)
bool clang_IdentifierTable_contains(CXIdentifierTable IT, const char *Name);

void clang_IdentifierTable_AddKeywords(CXIdentifierTable IT, CXLangOptions LO);

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

CXPPKeywordKind clang_IdentifierInfo_getPPKeywordID(CXIdentifierInfo II);

// returns the raw clang::tok::ObjCKeywordKind value (0 is tok::objc_not_keyword; that
// enum's .def-generated enumerators are not mirrored)
unsigned clang_IdentifierInfo_getObjCKeywordID(CXIdentifierInfo II);

unsigned clang_IdentifierInfo_getBuiltinID(CXIdentifierInfo II);

// returns the raw clang::tok::InterestingIdentifierKind value (0 is
// tok::not_interesting; that enum's .def-generated enumerators are not mirrored)
unsigned clang_IdentifierInfo_getInterestingIdentifierID(CXIdentifierInfo II);

// the packed field backing getObjCKeywordID, getInterestingIdentifierID and
// getBuiltinID
unsigned clang_IdentifierInfo_getObjCOrBuiltinID(CXIdentifierInfo II);

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

bool clang_IdentifierInfo_hasChangedSinceDeserialization(CXIdentifierInfo II);

bool clang_IdentifierInfo_isOutOfDate(CXIdentifierInfo II);

void clang_IdentifierInfo_setOutOfDate(CXIdentifierInfo II, bool OOD);

bool clang_IdentifierInfo_isModulesImport(CXIdentifierInfo II);

void clang_IdentifierInfo_setModulesImport(CXIdentifierInfo II, bool I);

bool clang_IdentifierInfo_isEditorPlaceholder(CXIdentifierInfo II);

CXReservedIdentifierStatus clang_IdentifierInfo_isReserved(CXIdentifierInfo II,
                                                           CXLangOptions LO);

CXReservedLiteralSuffixIdStatus
clang_IdentifierInfo_isReservedLiteralSuffixId(CXIdentifierInfo II);

CXString clang_IdentifierInfo_deuglifiedName(CXIdentifierInfo II);

bool clang_IdentifierInfo_isPlaceholder(CXIdentifierInfo II);

LLVM_CLANG_C_EXTERN_C_END

#endif