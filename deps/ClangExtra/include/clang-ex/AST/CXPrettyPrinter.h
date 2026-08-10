#ifndef LLVM_CLANG_C_EXTRA_CXPRETTYPRINTER_H
#define LLVM_CLANG_C_EXTRA_CXPRETTYPRINTER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::PrintingPolicy is an options bag consumed by every printer that takes a
// CXASTContext -- clang_QualType_printAsString, clang_Stmt_printPretty,
// clang_Qualifiers_printAsString and the rest read the policy of the context they are handed.
// It gets a handle here so those printers can be influenced.
//
// A policy from clang_PrintingPolicy_create or _copy is caller-owned; one from
// clang_ASTContext_getPrintingPolicy is a BORROWED interior pointer into the context and must
// never be disposed -- the same split as clang_CompilerInvocation_create vs
// clang_CompilerInstance_getInvocation.
CXPrintingPolicy_ clang_PrintingPolicy_create(CXLangOptions LO);

CXPrintingPolicy_ clang_PrintingPolicy_copy(CXPrintingPolicy_ PP);

// Only for a policy from _create or _copy. Never for one from
// clang_ASTContext_getPrintingPolicy.
void clang_PrintingPolicy_dispose(CXPrintingPolicy_ PP);

// Whether "struct"/"class"/"union"/"enum" is omitted before a tag type's name. Set from
// LangOpts.CPlusPlus when the policy is built.
bool clang_PrintingPolicy_getSuppressTagKeyword(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setSuppressTagKeyword(CXPrintingPolicy_ PP, bool Value);

// Whether the qualified part of a name is omitted, printing "S" rather than "NS::S".
bool clang_PrintingPolicy_getSuppressScope(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setSuppressScope(CXPrintingPolicy_ PP, bool Value);

// Whether the boolean type prints as "bool" rather than "_Bool".
bool clang_PrintingPolicy_getBool(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setBool(CXPrintingPolicy_ PP, bool Value);

// Whether names print fully qualified from the global namespace. This is a printer
// setting: it qualifies the name as the AST spells it, and does not resolve
// using-declarations or requalify template arguments the way
// clang_TypeName_getFullyQualifiedName does.
bool clang_PrintingPolicy_getFullyQualifiedName(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setFullyQualifiedName(CXPrintingPolicy_ PP, bool Value);

// Whether template arguments matching their parameter's default are omitted, printing
// "std::vector<int>" rather than "std::vector<int, std::allocator<int>>".
bool clang_PrintingPolicy_getSuppressDefaultTemplateArgs(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setSuppressDefaultTemplateArgs(CXPrintingPolicy_ PP, bool Value);

// Whether types print canonically, with sugar (typedefs, using-aliases) stripped.
bool clang_PrintingPolicy_getPrintCanonicalTypes(CXPrintingPolicy_ PP);
void clang_PrintingPolicy_setPrintCanonicalTypes(CXPrintingPolicy_ PP, bool Value);

LLVM_CLANG_C_EXTERN_C_END

#endif
