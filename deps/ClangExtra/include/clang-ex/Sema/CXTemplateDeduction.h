#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATEDEDUCTION_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATEDEDUCTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::sema::TemplateDeductionInfo is a by-value class with no pointer form and a
// deleted copy constructor, so a CXTemplateDeductionInfo is an owned heap box released
// with clang_TemplateDeductionInfo_dispose. It is the out-parameter every Sema deduction
// entry point takes by reference: on success it carries the deduced argument list, on
// failure the template parameter and arguments the mismatch was about.

// DeducedDepth is the template-parameter depth deduction runs at; it is 0 for a deduction
// started outside an enclosing template.
CXTemplateDeductionInfo clang_TemplateDeductionInfo_create(CXSourceLocation_ Loc,
                                                           unsigned DeducedDepth);

void clang_TemplateDeductionInfo_dispose(CXTemplateDeductionInfo Info);

CXSourceLocation_ clang_TemplateDeductionInfo_getLocation(CXTemplateDeductionInfo Info);

unsigned clang_TemplateDeductionInfo_getDeducedDepth(CXTemplateDeductionInfo Info);

unsigned clang_TemplateDeductionInfo_getNumExplicitArgs(CXTemplateDeductionInfo Info);

bool clang_TemplateDeductionInfo_hasSFINAEDiagnostic(CXTemplateDeductionInfo Info);

// Transfers the deduced argument list out of Info, so a second call returns null. The list
// itself is ASTContext memory and is never disposed, and is null until a deduction has
// filled it in. takeSugared keeps the sugar deduction saw; takeCanonical is the canonical
// form.
CXTemplateArgumentList
clang_TemplateDeductionInfo_takeSugared(CXTemplateDeductionInfo Info);

CXTemplateArgumentList
clang_TemplateDeductionInfo_takeCanonical(CXTemplateDeductionInfo Info);

// The public CallArgIndex member: which call argument the mismatch was about. Reads 0
// unless the deduction returned CXTemplateDeductionResult_TDK_DeducedMismatch.
unsigned clang_TemplateDeductionInfo_getCallArgIndex(CXTemplateDeductionInfo Info);

LLVM_CLANG_C_EXTERN_C_END

#endif
