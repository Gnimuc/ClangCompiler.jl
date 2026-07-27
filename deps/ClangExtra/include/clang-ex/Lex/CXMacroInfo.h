#ifndef LLVM_CLANG_C_EXTRA_CXMACROINFO_H
#define LLVM_CLANG_C_EXTRA_CXMACROINFO_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXSourceLocation_ clang_MacroInfo_getDefinitionLoc(CXMacroInfo MI);

CXSourceLocation_ clang_MacroInfo_getDefinitionEndLoc(CXMacroInfo MI);

unsigned clang_MacroInfo_getDefinitionLength(CXMacroInfo MI, CXSourceManager SM);

bool clang_MacroInfo_isIdenticalTo(CXMacroInfo MI, CXMacroInfo Other, CXPreprocessor PP,
                                   bool Syntactically);

bool clang_MacroInfo_param_empty(CXMacroInfo MI);

unsigned clang_MacroInfo_getNumParams(CXMacroInfo MI);

// Index accessor over `MacroInfo::params()` (`Index` < `getNumParams`); borrowed.
CXIdentifierInfo clang_MacroInfo_getParam(CXMacroInfo MI, unsigned Index);

int clang_MacroInfo_getParameterNum(CXMacroInfo MI, CXIdentifierInfo Arg);

bool clang_MacroInfo_isFunctionLike(CXMacroInfo MI);

bool clang_MacroInfo_isObjectLike(CXMacroInfo MI);

bool clang_MacroInfo_isC99Varargs(CXMacroInfo MI);

bool clang_MacroInfo_isGNUVarargs(CXMacroInfo MI);

bool clang_MacroInfo_isVariadic(CXMacroInfo MI);

bool clang_MacroInfo_isBuiltinMacro(CXMacroInfo MI);

bool clang_MacroInfo_hasCommaPasting(CXMacroInfo MI);

bool clang_MacroInfo_isUsed(CXMacroInfo MI);

bool clang_MacroInfo_isAllowRedefinitionsWithoutWarning(CXMacroInfo MI);

bool clang_MacroInfo_isWarnIfUnused(CXMacroInfo MI);

unsigned clang_MacroInfo_getNumTokens(CXMacroInfo MI);

// Borrowed pointer into the macro's replacement-token list (`Index` < `getNumTokens`).
CXToken_ clang_MacroInfo_getReplacementToken(CXMacroInfo MI, unsigned Index);

bool clang_MacroInfo_isEnabled(CXMacroInfo MI);

bool clang_MacroInfo_isUsedForHeaderGuard(CXMacroInfo MI);

void clang_MacroInfo_dump(CXMacroInfo MI);

LLVM_CLANG_C_EXTERN_C_END

#endif