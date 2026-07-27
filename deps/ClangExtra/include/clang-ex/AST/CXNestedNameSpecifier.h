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

// The static builders. Each interns the specifier in Ctx's arena, so the result is
// BORROWED (context-owned) exactly like the accessors above.
//
// PRECONDITION for Create: II must be non-NULL, and Prefix must be either NULL or
// dependent (clang_NestedNameSpecifier_isDependent) — an identifier component is
// only well-formed where the prefix cannot be resolved.
CXNestedNameSpecifier clang_NestedNameSpecifier_Create(CXASTContext Ctx,
                                                       CXNestedNameSpecifier Prefix,
                                                       CXIdentifierInfo II);

CXNestedNameSpecifier clang_NestedNameSpecifier_GlobalSpecifier(CXASTContext Ctx);

CXNestedNameSpecifier clang_NestedNameSpecifier_SuperSpecifier(CXASTContext Ctx,
                                                               CXCXXRecordDecl RD);

// NestedNameSpecifierLoc
// A NestedNameSpecifierLoc pairs a NestedNameSpecifier with the source location of
// every component that was written (`::std::vector<int>::`). It is a small by-value
// object - specifier pointer plus an opaque location buffer - with no pointer form of
// its own, so it crosses heap-boxed exactly like CXTypeLoc (MARSHALLING.md section 9):
// every CXNestedNameSpecifierLoc produced here or by a getQualifierLoc accessor is
// OWNED and must be released with clang_NestedNameSpecifierLoc_dispose. An empty box
// (hasQualifier false) is what an unqualified name yields; it is a legal value, not a
// NULL handle, and only the "last component" accessors reject it.
bool clang_NestedNameSpecifierLoc_hasQualifier(CXNestedNameSpecifierLoc NNSL);

// The specifier this location describes, BORROWED (context-owned) - the same pointer
// the matching getQualifier accessor returns, NULL for an empty box.
CXNestedNameSpecifier
clang_NestedNameSpecifierLoc_getNestedNameSpecifier(CXNestedNameSpecifierLoc NNSL);

// The extent of the whole specifier, prefix included. An empty box yields an invalid
// range rather than crashing.
CXSourceRange_ clang_NestedNameSpecifierLoc_getSourceRange(CXNestedNameSpecifierLoc NNSL);

// The extent of just the last component, prefix excluded.
// PRECONDITION: hasQualifier(NNSL) - an empty location has no last component; the
// Julia wrapper restates this as an @assert.
CXSourceRange_
clang_NestedNameSpecifierLoc_getLocalSourceRange(CXNestedNameSpecifierLoc NNSL);

// The endpoints of getSourceRange; both invalid for an empty box.
CXSourceLocation_ clang_NestedNameSpecifierLoc_getBeginLoc(CXNestedNameSpecifierLoc NNSL);

CXSourceLocation_ clang_NestedNameSpecifierLoc_getEndLoc(CXNestedNameSpecifierLoc NNSL);

// The endpoints of getLocalSourceRange; same PRECONDITION as that function.
CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalBeginLoc(CXNestedNameSpecifierLoc NNSL);

CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalEndLoc(CXNestedNameSpecifierLoc NNSL);

// Everything but the last component, as a NEW box; release it with
// clang_NestedNameSpecifierLoc_dispose. An empty box's prefix is empty in turn, so a
// walk guarded by hasQualifier terminates.
CXNestedNameSpecifierLoc
clang_NestedNameSpecifierLoc_getPrefix(CXNestedNameSpecifierLoc NNSL);

// The written type of the last component, as a NEW CXTypeLoc box; release it with
// clang_TypeLoc_dispose.
// PRECONDITION: hasQualifier(NNSL) and clang_NestedNameSpecifier_getKind of the
// specifier is TypeSpec or TypeSpecWithTemplate - clang dereferences the specifier and
// reads the component's trailing TypeLoc storage unchecked; the Julia wrapper restates
// both halves as @asserts.
CXTypeLoc clang_NestedNameSpecifierLoc_getTypeLoc(CXNestedNameSpecifierLoc NNSL);

void clang_NestedNameSpecifierLoc_dispose(CXNestedNameSpecifierLoc NNSL);

LLVM_CLANG_C_EXTERN_C_END

#endif