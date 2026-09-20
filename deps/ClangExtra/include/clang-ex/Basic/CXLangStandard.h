#ifndef LLVM_CLANG_C_EXTRA_CXLANGSTANDARD_H
#define LLVM_CLANG_C_EXTRA_CXLANGSTANDARD_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::Language` (clang/Basic/LangStandard.h), the input language that
// selects which `-std=` standards are legal. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXLanguage : unsigned char {
  CXLanguage_Unknown,
  CXLanguage_Asm,
  CXLanguage_CIR,
  CXLanguage_LLVM_IR,
  CXLanguage_C,
  CXLanguage_CXX,
  CXLanguage_ObjC,
  CXLanguage_ObjCXX,
  CXLanguage_OpenCL,
  CXLanguage_OpenCLCXX,
  CXLanguage_CUDA,
  CXLanguage_HIP,
  CXLanguage_HLSL
} CXLanguage;

// Mirror of `clang::LangStandard::Kind` (clang/Basic/LangStandard.h). The enumerators are
// X-macro-generated from the LANGSTANDARD lines of clang/Basic/LangStandards.def, so this
// order tracks that file; `lang_unspecified` closes the list there and here. The
// LANGSTANDARD_ALIAS lines add no enumerators — an alias resolves to the standard it names
// through clang_LangStandard_getLangKind. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXLangStandardKind {
  CXLangStandardKind_lang_c89,
  CXLangStandardKind_lang_c94,
  CXLangStandardKind_lang_gnu89,
  CXLangStandardKind_lang_c99,
  CXLangStandardKind_lang_gnu99,
  CXLangStandardKind_lang_c11,
  CXLangStandardKind_lang_gnu11,
  CXLangStandardKind_lang_c17,
  CXLangStandardKind_lang_gnu17,
  CXLangStandardKind_lang_c23,
  CXLangStandardKind_lang_gnu23,
  CXLangStandardKind_lang_c2y,
  CXLangStandardKind_lang_gnu2y,
  CXLangStandardKind_lang_cxx98,
  CXLangStandardKind_lang_gnucxx98,
  CXLangStandardKind_lang_cxx11,
  CXLangStandardKind_lang_gnucxx11,
  CXLangStandardKind_lang_cxx14,
  CXLangStandardKind_lang_gnucxx14,
  CXLangStandardKind_lang_cxx17,
  CXLangStandardKind_lang_gnucxx17,
  CXLangStandardKind_lang_cxx20,
  CXLangStandardKind_lang_gnucxx20,
  CXLangStandardKind_lang_cxx23,
  CXLangStandardKind_lang_gnucxx23,
  CXLangStandardKind_lang_cxx26,
  CXLangStandardKind_lang_gnucxx26,
  CXLangStandardKind_lang_opencl10,
  CXLangStandardKind_lang_opencl11,
  CXLangStandardKind_lang_opencl12,
  CXLangStandardKind_lang_opencl20,
  CXLangStandardKind_lang_opencl30,
  CXLangStandardKind_lang_openclcpp10,
  CXLangStandardKind_lang_openclcpp2021,
  CXLangStandardKind_lang_hlsl,
  CXLangStandardKind_lang_hlsl2015,
  CXLangStandardKind_lang_hlsl2016,
  CXLangStandardKind_lang_hlsl2017,
  CXLangStandardKind_lang_hlsl2018,
  CXLangStandardKind_lang_hlsl2021,
  CXLangStandardKind_lang_hlsl202x,
  CXLangStandardKind_lang_hlsl202y,
  CXLangStandardKind_lang_unspecified
} CXLangStandardKind;

// A CXLangStandard is a borrowed pointer into clang's static LangStandards table: one
// entry per LANGSTANDARD line, with static storage duration. There is no dispose, and
// two handles for the same kind compare equal.

// The kind `-std=Name` selects, or CXLangStandardKind_lang_unspecified when clang knows
// no standard by that name. Aliases ("c90", "c++2b", "CL2.0") resolve here too.
CXLangStandardKind clang_LangStandard_getLangKind(const char *Name);

// Precondition: K is not CXLangStandardKind_lang_unspecified — clang report_fatal_error's
// on that kind rather than returning. Every other kind names a table entry.
CXLangStandard clang_LangStandard_getLangStandardForKind(CXLangStandardKind K);

// The table entry `-std=Name` selects, or NULL when clang knows no standard by that name.
CXLangStandard clang_LangStandard_getLangStandardForName(const char *Name);

// Borrowed: the name and description are string literals stamped into the static table by
// LangStandards.def, so they outlive any caller.
const char *clang_LangStandard_getName(CXLangStandard LS);

const char *clang_LangStandard_getDescription(CXLangStandard LS);

CXLanguage clang_LangStandard_getLanguage(CXLangStandard LS);

// The LangFeatures bits of the entry, one predicate each. Every one of them is a pure mask
// test over the entry's Flags word, so all are total.
bool clang_LangStandard_hasLineComments(CXLangStandard LS);
bool clang_LangStandard_isC99(CXLangStandard LS);
bool clang_LangStandard_isC11(CXLangStandard LS);
bool clang_LangStandard_isC17(CXLangStandard LS);
bool clang_LangStandard_isC23(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus11(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus14(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus17(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus20(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus23(CXLangStandard LS);
bool clang_LangStandard_isCPlusPlus26(CXLangStandard LS);
bool clang_LangStandard_hasDigraphs(CXLangStandard LS);
bool clang_LangStandard_isGNUMode(CXLangStandard LS);
bool clang_LangStandard_hasHexFloats(CXLangStandard LS);
bool clang_LangStandard_isOpenCL(CXLangStandard LS);

// clang::languageToString, a free function in namespace clang. The StringRef it returns
// points at a literal, but crossing as a copy keeps the NUL-termination question out of
// the boundary.
CXString clang_languageToString(CXLanguage L);

// The standard clang would pick for `Lang` on target `Triple` with no -std= given. The
// triple is spelled as text and parsed on this side, so no llvm::Triple crosses.
CXLangStandardKind clang_getDefaultLanguageStandard(CXLanguage Lang, const char *Triple);

LLVM_CLANG_C_EXTERN_C_END

#endif
