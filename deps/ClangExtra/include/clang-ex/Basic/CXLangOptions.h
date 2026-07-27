#ifndef LLVM_CLANG_C_EXTRA_CXLANGOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXLANGOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_LangOptions_PrintStats(CXLangOptions LO);

bool clang_LangOptions_isCompilingModule(CXLangOptions LO);

bool clang_LangOptions_isCompilingModuleInterface(CXLangOptions LO);

bool clang_LangOptions_isCompilingModuleImplementation(CXLangOptions LO);

bool clang_LangOptions_isSignedOverflowDefined(CXLangOptions LO);

bool clang_LangOptions_isSubscriptPointerArithmetic(CXLangOptions LO);

bool clang_LangOptions_isNoBuiltinFunc(CXLangOptions LO, const char *Name);

bool clang_LangOptions_assumeFunctionsAreConvergent(CXLangOptions LO);

unsigned clang_LangOptions_getOpenCLCompatibleVersion(CXLangOptions LO);

CXString clang_LangOptions_getOpenCLVersionString(CXLangOptions LO);

bool clang_LangOptions_requiresStrictPrototypes(CXLangOptions LO);

bool clang_LangOptions_implicitFunctionsAllowed(CXLangOptions LO);

bool clang_LangOptions_hasAtExit(CXLangOptions LO);

bool clang_LangOptions_isImplicitIntRequired(CXLangOptions LO);

bool clang_LangOptions_isImplicitIntAllowed(CXLangOptions LO);

bool clang_LangOptions_hasSjLjExceptions(CXLangOptions LO);

bool clang_LangOptions_hasSEHExceptions(CXLangOptions LO);

bool clang_LangOptions_hasDWARFExceptions(CXLangOptions LO);

bool clang_LangOptions_hasWasmExceptions(CXLangOptions LO);

bool clang_LangOptions_isSYCL(CXLangOptions LO);

LLVM_CLANG_C_EXTERN_C_END

#endif