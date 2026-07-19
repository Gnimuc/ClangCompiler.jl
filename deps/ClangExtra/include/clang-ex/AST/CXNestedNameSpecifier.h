#ifndef LLVM_CLANG_C_EXTRA_CXNESTEDNAMESPECIFIER_H
#define LLVM_CLANG_C_EXTRA_CXNESTEDNAMESPECIFIER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::NestedNameSpecifier::SpecifierKind (a plain int enum). Kept in
// SpecifierKind declaration order; CXEnumSync.cpp proves value-for-value
// equality. getKind reports which component completes this specifier.
typedef enum CXNestedNameSpecifierKind {
  CXNestedNameSpecifierKind_Identifier,
  CXNestedNameSpecifierKind_Namespace,
  CXNestedNameSpecifierKind_NamespaceAlias,
  CXNestedNameSpecifierKind_TypeSpec,
  CXNestedNameSpecifierKind_TypeSpecWithTemplate,
  CXNestedNameSpecifierKind_Global,
  CXNestedNameSpecifierKind_Super
} CXNestedNameSpecifierKind;

CXNestedNameSpecifier clang_NestedNameSpecifier_getPrefix(CXNestedNameSpecifier NNS);

CXNestedNameSpecifierKind clang_NestedNameSpecifier_getKind(CXNestedNameSpecifier NNS);

// getAs* return BORROWED interior pointers (AST/context-owned); never dispose.
// Each yields nullptr when the specifier is not of the requested kind.
CXIdentifierInfo clang_NestedNameSpecifier_getAsIdentifier(CXNestedNameSpecifier NNS);

CXNamespaceDecl clang_NestedNameSpecifier_getAsNamespace(CXNestedNameSpecifier NNS);

CXNamespaceAliasDecl clang_NestedNameSpecifier_getAsNamespaceAlias(CXNestedNameSpecifier NNS);

CXCXXRecordDecl clang_NestedNameSpecifier_getAsRecordDecl(CXNestedNameSpecifier NNS);

CXType_ clang_NestedNameSpecifier_getAsType(CXNestedNameSpecifier NNS);

bool clang_NestedNameSpecifier_isDependent(CXNestedNameSpecifier NNS);

bool clang_NestedNameSpecifier_isInstantiationDependent(CXNestedNameSpecifier NNS);

bool clang_NestedNameSpecifier_containsUnexpandedParameterPack(CXNestedNameSpecifier NNS);

bool clang_NestedNameSpecifier_containsErrors(CXNestedNameSpecifier NNS);

void clang_NestedNameSpecifier_dump(CXNestedNameSpecifier NNS);

CXString clang_NestedNameSpecifier_getName(CXNestedNameSpecifier NNS);

LLVM_CLANG_C_EXTERN_C_END

#endif