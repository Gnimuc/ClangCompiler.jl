#ifndef LLVM_CLANG_C_EXTRA_CXLANGOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXLANGOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::LangOptions::FPEvalMethodKind` (clang/Basic/LangOptions.h).
typedef enum CXFPEvalMethodKind {
  CXFPEvalMethodKind_FEM_Indeterminable = -1,
  CXFPEvalMethodKind_FEM_Source = 0,
  CXFPEvalMethodKind_FEM_Double = 1,
  CXFPEvalMethodKind_FEM_Extended = 2,
  CXFPEvalMethodKind_FEM_UnsetOnCommandLine = 3
} CXFPEvalMethodKind;

// Mirror of `clang::LangOptions::StrictFlexArraysLevelKind` (clang/Basic/LangOptions.h):
// which trailing array members count as a flexible array member, i.e. the
// -fstrict-flex-arrays level.
typedef enum CXStrictFlexArraysLevelKind {
  CXStrictFlexArraysLevelKind_Default,
  CXStrictFlexArraysLevelKind_OneZeroOrIncomplete,
  CXStrictFlexArraysLevelKind_ZeroOrIncomplete,
  CXStrictFlexArraysLevelKind_IncompleteOnly
} CXStrictFlexArraysLevelKind;

// Mirror of `clang::MSVtorDispMode` (clang/Basic/LangOptions.h): where the Microsoft
// C++ ABI places the virtual displacement members that implement virtual inheritance.
typedef enum CXMSVtorDispMode {
  CXMSVtorDispMode_Never = 0,
  CXMSVtorDispMode_ForVBaseOverride = 1,
  CXMSVtorDispMode_ForVFTable = 2
} CXMSVtorDispMode;

// Mirror of `clang::LangOptions::MSVCMajorVersion` (clang/Basic/LangOptions.h): the
// _MSC_VER major values -fms-compatibility-version is compared against.
typedef enum CXMSVCMajorVersion {
  CXMSVCMajorVersion_MSVC2010 = 1600,
  CXMSVCMajorVersion_MSVC2012 = 1700,
  CXMSVCMajorVersion_MSVC2013 = 1800,
  CXMSVCMajorVersion_MSVC2015 = 1900,
  CXMSVCMajorVersion_MSVC2017 = 1910,
  CXMSVCMajorVersion_MSVC2017_5 = 1912,
  CXMSVCMajorVersion_MSVC2017_7 = 1914,
  CXMSVCMajorVersion_MSVC2019 = 1920,
  CXMSVCMajorVersion_MSVC2019_5 = 1925,
  CXMSVCMajorVersion_MSVC2019_8 = 1928,
  CXMSVCMajorVersion_MSVC2022_3 = 1933
} CXMSVCMajorVersion;

// Mirror of `clang::LangOptions::FPExceptionModeKind` (clang/Basic/LangOptions.h):
// how strictly floating-point exception semantics are preserved. FPE_Default is the
// internal "unspecified" state and never comes back from the resolving accessors.
typedef enum CXFPExceptionModeKind {
  CXFPExceptionModeKind_FPE_Ignore,
  CXFPExceptionModeKind_FPE_MayTrap,
  CXFPExceptionModeKind_FPE_Strict,
  CXFPExceptionModeKind_FPE_Default
} CXFPExceptionModeKind;

// Mirror of `llvm::RoundingMode` (llvm/ADT/FloatingPointMode.h): the five IEEE-754
// rounding directions, plus Dynamic for a mode unknown at compile time and Invalid.
// llvm declares it `: int8_t`, which this mirror deliberately does NOT copy: the binding
// generator cannot read a `signed char`-based enum (Clang.jl handles CXType_Char_S but not
// CXType_SChar). The value only ever crosses by value through a static_cast, never by
// pointer and never inside a struct, so the widths need not agree.
typedef enum CXRoundingMode {
  CXRoundingMode_TowardZero = 0,
  CXRoundingMode_NearestTiesToEven = 1,
  CXRoundingMode_TowardPositive = 2,
  CXRoundingMode_TowardNegative = 3,
  CXRoundingMode_NearestTiesToAway = 4,
  CXRoundingMode_Dynamic = 7,
  CXRoundingMode_Invalid = -1
} CXRoundingMode;

void clang_LangOptions_PrintStats(CXLangOptions LO);

bool clang_LangOptions_isCompilingModule(CXLangOptions LO);

bool clang_LangOptions_isCompilingModuleInterface(CXLangOptions LO);

bool clang_LangOptions_isCompilingModuleImplementation(CXLangOptions LO);

bool clang_LangOptions_trackLocalOwningModule(CXLangOptions LO);

bool clang_LangOptions_isSignedOverflowDefined(CXLangOptions LO);

bool clang_LangOptions_isSubscriptPointerArithmetic(CXLangOptions LO);

bool clang_LangOptions_isCompatibleWithMSVC(CXLangOptions LO,
                                            CXMSVCMajorVersion MajorVersion);

// Resets every option that is not considered when building a module. Mutates LO in
// place and leaves it usable.
void clang_LangOptions_resetNonModularOptions(CXLangOptions LO);

bool clang_LangOptions_isNoBuiltinFunc(CXLangOptions LO, const char *Name);

bool clang_LangOptions_allowsNonTrivialObjCLifetimeQualifiers(CXLangOptions LO);

// The Borland-extensions flag (LangOptions.def: LANGOPT(Borland, ...)). Exposed
// because Preprocessor::PoisonSEHIdentifiers is only safe when it is set — see
// clang_Preprocessor_PoisonSEHIdentifiers.
bool clang_LangOptions_getBorland(CXLangOptions LO);

// The modules flag (LangOptions.def: LANGOPT(Modules, ...)). Exposed as a gate:
// clang_HeaderSearch_ShouldEnterIncludeFile takes a ModulesEnabled argument that must match
// the invocation, and nothing else can observe it.
bool clang_LangOptions_getModules(CXLangOptions LO);

// The C++ flag (LangOptions.def: LANGOPT(CPlusPlus, ...)). Exposed as a gate:
// Sema's std:: lookup entry points assert on it — see
// clang_Sema_isStdInitializerList.
bool clang_LangOptions_getCPlusPlus(CXLangOptions LO);

// The C++11 flag (LangOptions.def: LANGOPT(CPlusPlus11, ...)). Exposed as a gate:
// Sema::DeclareGlobalAllocationFunction reaches for std::bad_alloc when it declares an
// operator new form and this is off - see clang_Sema_DeclareGlobalAllocationFunction.
bool clang_LangOptions_getCPlusPlus11(CXLangOptions LO);

// helper: whether a language standard has been selected, i.e. LangStd is not
// LangStandard::lang_unspecified. Exported as a gate: CompilerInvocation::getCC1CommandLine
// calls getLangStandardForKind, which report_fatal_error's on the unspecified kind, and a
// default-constructed invocation has exactly that.
bool clang_LangOptions_hasLangStandard(CXLangOptions LO);

bool clang_LangOptions_assumeFunctionsAreConvergent(CXLangOptions LO);

unsigned clang_LangOptions_getOpenCLCompatibleVersion(CXLangOptions LO);

CXString clang_LangOptions_getOpenCLVersionString(CXLangOptions LO);

bool clang_LangOptions_requiresStrictPrototypes(CXLangOptions LO);

bool clang_LangOptions_implicitFunctionsAllowed(CXLangOptions LO);

bool clang_LangOptions_hasAtExit(CXLangOptions LO);

bool clang_LangOptions_isImplicitIntRequired(CXLangOptions LO);

bool clang_LangOptions_isImplicitIntAllowed(CXLangOptions LO);

bool clang_LangOptions_hasSignReturnAddress(CXLangOptions LO);

bool clang_LangOptions_isSignReturnAddressWithAKey(CXLangOptions LO);

bool clang_LangOptions_isSignReturnAddressScopeAll(CXLangOptions LO);

bool clang_LangOptions_hasSjLjExceptions(CXLangOptions LO);

bool clang_LangOptions_hasSEHExceptions(CXLangOptions LO);

bool clang_LangOptions_hasDWARFExceptions(CXLangOptions LO);

bool clang_LangOptions_hasWasmExceptions(CXLangOptions LO);

bool clang_LangOptions_isSYCL(CXLangOptions LO);

bool clang_LangOptions_hasDefaultVisibilityExportMapping(CXLangOptions LO);

bool clang_LangOptions_isExplicitDefaultVisibilityExportMapping(CXLangOptions LO);

bool clang_LangOptions_isAllDefaultVisibilityExportMapping(CXLangOptions LO);

bool clang_LangOptions_hasGlobalAllocationFunctionVisibility(CXLangOptions LO);

bool clang_LangOptions_hasDefaultGlobalAllocationFunctionVisibility(CXLangOptions LO);

bool clang_LangOptions_hasProtectedGlobalAllocationFunctionVisibility(CXLangOptions LO);

bool clang_LangOptions_hasHiddenGlobalAllocationFunctionVisibility(CXLangOptions LO);

// Applies the -fmacro-prefix-path remappings to Path and returns the rewritten path.
// Path is borrowed; the result is caller-owned (clang_disposeString).
CXString clang_LangOptions_remapPathPrefix(CXLangOptions LO, const char *Path);

CXRoundingMode clang_LangOptions_getDefaultRoundingMode(CXLangOptions LO);

CXFPExceptionModeKind clang_LangOptions_getDefaultExceptionMode(CXLangOptions LO);

// FPOptions
// clang::FPOptions is a single 32-bit bitfield word, so it crosses as its opaque
// integer encoding (MARSHALLING.md §7) rather than as a handle — the same encoding
// clang_Expr_getFPFeaturesInEffect returns. Each accessor below rebuilds the value
// with FPOptions::getFromOpaqueInt, so any word those functions produce is a valid
// receiver.
unsigned clang_FPOptions_defaultWithoutTrailingStorage(CXLangOptions LO);

CXRoundingMode clang_FPOptions_getRoundingMode(unsigned FPO);

CXFPExceptionModeKind clang_FPOptions_getExceptionMode(unsigned FPO);

// Whether contraction of a*b+c is allowed within a single statement, and whether it is
// allowed across statements. The two are mutually exclusive: FPM_On answers true/false,
// FPM_Fast false/true, FPM_Off false/false. Both are pure bitfield reads of the FPContractMode
// field, so every 32-bit word decodes (MARSHALLING.md §7).
bool clang_FPOptions_allowFPContractWithinStatement(unsigned FPO);
bool clang_FPOptions_allowFPContractAcrossStatement(unsigned FPO);

// Whether the word describes constrained floating point -- non-default rounding, non-ignored
// exceptions, or FEnv access. A pure read of three fields the package already decodes
// piecemeal through getRoundingMode/getExceptionMode.
bool clang_FPOptions_isFPConstrained(unsigned FPO);

// The FPOptionsOverride describing how FPO differs from Base, as the uint64 opaque encoding
// that is already this package's currency for stored FP features.
uint64_t clang_FPOptions_getChangesFrom(unsigned FPO, unsigned Base);

// FPOptionsOverride crosses as its uint64 opaque encoding, the same currency every
// *_getFPFeatures / *_getStoredFPFeatures reader already hands out; there is no carrier,
// because the class is two 32-bit words and a handle would make @check_ptrs assert on the
// legitimate zero that means "no override" (MARSHALLING.md §7).

// Applies the override to Base and returns the resulting FPOptions word. This is what turns a
// stored uint64 back into something the FPOptions decoders can read.
unsigned clang_FPOptionsOverride_applyOverrides(uint64_t FPO, unsigned Base);

// Whether the override sets anything, i.e. whether an AST node carrying it needs trailing
// storage. Reads the mask half without the caller having to know the 32/32 split.
bool clang_FPOptionsOverride_requiresTrailingStorage(uint64_t FPO);

// The three contraction-mode setters. A value crossing has no C-side object to mutate, so each
// takes the word and returns the modified one rather than writing through a handle.
uint64_t clang_FPOptionsOverride_setAllowFPContractWithinStatement(uint64_t FPO);
uint64_t clang_FPOptionsOverride_setAllowFPContractAcrossStatement(uint64_t FPO);
uint64_t clang_FPOptionsOverride_setDisallowFPContract(uint64_t FPO);

LLVM_CLANG_C_EXTERN_C_END

#endif