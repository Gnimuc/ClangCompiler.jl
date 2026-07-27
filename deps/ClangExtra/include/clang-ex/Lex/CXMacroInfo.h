#ifndef LLVM_CLANG_C_EXTRA_CXMACROINFO_H
#define LLVM_CLANG_C_EXTRA_CXMACROINFO_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXSourceLocation_ clang_MacroInfo_getDefinitionLoc(CXMacroInfo MI);

void clang_MacroInfo_setDefinitionEndLoc(CXMacroInfo MI, CXSourceLocation_ EndLoc);

CXSourceLocation_ clang_MacroInfo_getDefinitionEndLoc(CXMacroInfo MI);

unsigned clang_MacroInfo_getDefinitionLength(CXMacroInfo MI, CXSourceManager SM);

bool clang_MacroInfo_isIdenticalTo(CXMacroInfo MI, CXMacroInfo Other, CXPreprocessor PP,
                                   bool Syntactically);

void clang_MacroInfo_setIsBuiltinMacro(CXMacroInfo MI, bool Val);

void clang_MacroInfo_setIsUsed(CXMacroInfo MI, bool Val);

void clang_MacroInfo_setIsAllowRedefinitionsWithoutWarning(CXMacroInfo MI, bool Val);

void clang_MacroInfo_setIsWarnIfUnused(CXMacroInfo MI, bool Val);

bool clang_MacroInfo_param_empty(CXMacroInfo MI);

unsigned clang_MacroInfo_getNumParams(CXMacroInfo MI);

// Index accessor over `MacroInfo::params()` (`Index` < `getNumParams`); borrowed.
CXIdentifierInfo clang_MacroInfo_getParam(CXMacroInfo MI, unsigned Index);

int clang_MacroInfo_getParameterNum(CXMacroInfo MI, CXIdentifierInfo Arg);

// One-way: MacroInfo offers no way back to object-like, and isObjectLike is defined as
// the negation of this flag.
void clang_MacroInfo_setIsFunctionLike(CXMacroInfo MI);

bool clang_MacroInfo_isFunctionLike(CXMacroInfo MI);

bool clang_MacroInfo_isObjectLike(CXMacroInfo MI);

// One-way, and only meaningful on a function-like macro.
void clang_MacroInfo_setIsC99Varargs(CXMacroInfo MI);

// One-way, and only meaningful on a function-like macro.
void clang_MacroInfo_setIsGNUVarargs(CXMacroInfo MI);

bool clang_MacroInfo_isC99Varargs(CXMacroInfo MI);

bool clang_MacroInfo_isGNUVarargs(CXMacroInfo MI);

bool clang_MacroInfo_isVariadic(CXMacroInfo MI);

bool clang_MacroInfo_isBuiltinMacro(CXMacroInfo MI);

bool clang_MacroInfo_hasCommaPasting(CXMacroInfo MI);

// One-way: there is no matching clear.
void clang_MacroInfo_setHasCommaPasting(CXMacroInfo MI);

bool clang_MacroInfo_isUsed(CXMacroInfo MI);

bool clang_MacroInfo_isAllowRedefinitionsWithoutWarning(CXMacroInfo MI);

bool clang_MacroInfo_isWarnIfUnused(CXMacroInfo MI);

unsigned clang_MacroInfo_getNumTokens(CXMacroInfo MI);

// Borrowed pointer into the macro's replacement-token list (`Index` < `getNumTokens`).
CXToken_ clang_MacroInfo_getReplacementToken(CXMacroInfo MI, unsigned Index);

bool clang_MacroInfo_tokens_empty(CXMacroInfo MI);

bool clang_MacroInfo_isEnabled(CXMacroInfo MI);

// Precondition: the macro is currently disabled (`clang_MacroInfo_isEnabled` is false).
void clang_MacroInfo_EnableMacro(CXMacroInfo MI);

// Precondition: the macro is currently enabled (`clang_MacroInfo_isEnabled` is true).
void clang_MacroInfo_DisableMacro(CXMacroInfo MI);

bool clang_MacroInfo_isUsedForHeaderGuard(CXMacroInfo MI);

void clang_MacroInfo_setUsedForHeaderGuard(CXMacroInfo MI, bool Val);

void clang_MacroInfo_dump(CXMacroInfo MI);

// MacroDirective

// Mirror of `clang::MacroDirective::Kind` (clang/Lex/MacroInfo.h).
typedef enum CXMacroDirectiveKind {
  CXMacroDirectiveKind_MD_Define,
  CXMacroDirectiveKind_MD_Undefine,
  CXMacroDirectiveKind_MD_Visibility
} CXMacroDirectiveKind;

CXMacroDirectiveKind clang_MacroDirective_getKind(CXMacroDirective MD);

CXSourceLocation_ clang_MacroDirective_getLocation(CXMacroDirective MD);

// Relinks MD's directive history. Prev is borrowed, not adopted, and must come from the
// same identifier's history — the preprocessor walks this chain to decide whether the
// macro is currently defined.
void clang_MacroDirective_setPrevious(CXMacroDirective MD, CXMacroDirective Prev);

// Borrowed; NULL past the oldest directive in the identifier's history.
CXMacroDirective clang_MacroDirective_getPrevious(CXMacroDirective MD);

bool clang_MacroDirective_isFromPCH(CXMacroDirective MD);

// One-way: there is no matching clear.
void clang_MacroDirective_setIsFromPCH(CXMacroDirective MD);

// Walks the directive history backwards and boxes the definition active at MD. The
// result is owned and pairs with clang_DefInfo_dispose; a history holding no #define
// boxes an invalid DefInfo, which is still a box to dispose and never NULL.
CXDefInfo clang_MacroDirective_getDefinition(CXMacroDirective MD);

bool clang_MacroDirective_isDefined(CXMacroDirective MD);

// Walks the directive history back to the definition active at this point; borrowed,
// NULL when the history holds no definition at all.
CXMacroInfo clang_MacroDirective_getMacroInfo(CXMacroDirective MD);

// Boxes the definition active at L, or an invalid DefInfo when the macro was not defined
// there. Owned; pairs with clang_DefInfo_dispose.
// PRECONDITION: L is a valid source location — the walk orders L against each directive's
// location through SM, which is meaningless for an invalid location.
CXDefInfo clang_MacroDirective_findDirectiveAtLoc(CXMacroDirective MD, CXSourceLocation_ L,
                                                  CXSourceManager SM);

// Writes the directive, its history links and — for a #define — its MacroInfo to stderr.
void clang_MacroDirective_dump(CXMacroDirective MD);

// MacroDirective::DefInfo
//
// A CXDefInfo is owned: clang::MacroDirective::DefInfo is a by-value triple (the
// DefMacroDirective it resolved to, the location of the #undef that cancelled it, and a
// module-visibility flag) with no pointer form, so it is heap-boxed here. Every function
// returning one pairs with clang_DefInfo_dispose, the invalid form included.

void clang_DefInfo_dispose(CXDefInfo DI);

// Borrowed; NULL when DI is invalid.
CXDefMacroDirective clang_DefInfo_getDirective(CXDefInfo DI);

// An invalid DefInfo reports an invalid location rather than dereferencing.
CXSourceLocation_ clang_DefInfo_getLocation(CXDefInfo DI);

// Borrowed; NULL when DI is invalid.
CXMacroInfo clang_DefInfo_getMacroInfo(CXDefInfo DI);

// Invalid unless a later #undef cancelled this definition.
CXSourceLocation_ clang_DefInfo_getUndefLocation(CXDefInfo DI);

bool clang_DefInfo_isUndefined(CXDefInfo DI);

bool clang_DefInfo_isPublic(CXDefInfo DI);

bool clang_DefInfo_isValid(CXDefInfo DI);

bool clang_DefInfo_isInvalid(CXDefInfo DI);

// Boxes the definition preceding this one, or an invalid DefInfo once the history runs
// out; total on an invalid DI. Owned; pairs with clang_DefInfo_dispose.
CXDefInfo clang_DefInfo_getPreviousDefinition(CXDefInfo DI);

// DefMacroDirective

// The definition body this #define introduced; borrowed, and never NULL because
// DefMacroDirective asserts it at construction.
CXMacroInfo clang_DefMacroDirective_getInfo(CXDefMacroDirective DMD);

LLVM_CLANG_C_EXTERN_C_END

#endif