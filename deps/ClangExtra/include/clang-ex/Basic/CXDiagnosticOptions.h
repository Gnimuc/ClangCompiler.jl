#ifndef LLVM_CLANG_C_EXTRA_CXDIAGNOSTICOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXDIAGNOSTICOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/DiagnosticOptions.h: enum OverloadsShown : unsigned
typedef enum CXOverloadsShown : unsigned {
  CXOverloadsShown_Ovl_All = 0,
  CXOverloadsShown_Ovl_Best
} CXOverloadsShown;

CXDiagnosticOptions clang_DiagnosticOptions_create(void);

void clang_DiagnosticOptions_dispose(CXDiagnosticOptions DO);

void clang_DiagnosticOptions_PrintStats(CXDiagnosticOptions DO);

void clang_DiagnosticOptions_setShowColors(CXDiagnosticOptions DO, bool ShowColors);

void clang_DiagnosticOptions_setShowPresumedLoc(CXDiagnosticOptions DO,
                                                bool ShowPresumedLoc);

// VerifyPrefixes
// clang::VerifyDiagnosticConsumer only recognises a directive whose prefix is in this list,
// and clang fills the list from `-verify` / `-verify=<prefix>` alone -- plain `-verify` adds
// "expected". A caller that installs the consumer itself
// (clang_VerifyDiagnosticConsumer_create) must therefore add at least one prefix here, or
// the consumer finds no directives in any source and reports that as an error.
unsigned clang_DiagnosticOptions_getVerifyPrefixesNum(CXDiagnosticOptions DO);

// PRECONDITION: Idx < clang_DiagnosticOptions_getVerifyPrefixesNum. Caller frees the string
// with clang_disposeString.
CXString clang_DiagnosticOptions_getVerifyPrefix(CXDiagnosticOptions DO, unsigned Idx);

// helper -- `VerifyPrefixes` is a plain vector with no member function to grow it. The list
// is kept sorted afterwards, as ParseDiagnosticArgs leaves it, because the consumer looks a
// prefix up with a binary search.
void clang_DiagnosticOptions_addVerifyPrefix(CXDiagnosticOptions DO, const char *Prefix);

LLVM_CLANG_C_EXTERN_C_END

#endif