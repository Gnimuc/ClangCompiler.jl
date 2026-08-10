#ifndef LLVM_CLANG_C_EXTRA_CXASTTYPETRAITS_H
#define LLVM_CLANG_C_EXTRA_CXASTTYPETRAITS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// DynTypedNode
//
// clang's one container that can hold any AST node -- a Stmt, a Decl, a Type, a QualType, a
// TypeLoc, a NestedNameSpecifier(Loc), an Attr, a base specifier, a ctor initializer -- with
// a runtime tag saying which. It is what ASTContext::getParents actually answers with.
//
// EVERY handle from this family is OWNED (MARSHALLING.md §14 -- copy, don't caveat).
// DynTypedNode is a small copyable value whose by-value node kinds (QualType, TypeLoc,
// NestedNameSpecifierLoc, TemplateArgument) live INSIDE its own storage, so `get<T>()` on
// one that sits in a temporary DynTypedNodeList
// returns a pointer into memory that is already gone. That is exactly why the parent API in
// clang-ex/AST/CXASTContext.h answers NULL for those kinds. A heap copy removes the trap --
// the storage is the caller's for as long as the handle lives -- so release each one with
// clang_DynTypedNode_dispose.
//
// The node kind is NOT mirrored as an enum: clang keeps ASTNodeKind::NodeKindId private and
// stamps it from four .inc files plus OMP.inc, so the only stable spelling of a kind is the
// name clang prints for it. Discriminate with the getAs* family (at most one answers
// non-NULL) and read the name for reporting.

CXDynTypedNode clang_DynTypedNode_createFromStmt(CXStmt S);

CXDynTypedNode clang_DynTypedNode_createFromDecl(CXDecl D);

CXDynTypedNode clang_DynTypedNode_createFromType(CXType_ T);

CXDynTypedNode clang_DynTypedNode_createFromQualType(CXQualType T);

CXDynTypedNode clang_DynTypedNode_createFromTypeLoc(CXTypeLoc TL);

CXDynTypedNode clang_DynTypedNode_createFromNestedNameSpecifier(CXNestedNameSpecifier NNS);

CXDynTypedNode
clang_DynTypedNode_createFromNestedNameSpecifierLoc(CXNestedNameSpecifierLoc NNSL);

CXDynTypedNode clang_DynTypedNode_createFromAttr(CXAttr A);

void clang_DynTypedNode_dispose(CXDynTypedNode N);

// The name clang prints for the node's kind ("IfStmt", "QualType", "PointerTypeLoc", ...),
// and "<None>" for the empty kind. The CXString is caller-owned.
CXString clang_DynTypedNode_getNodeKindName(CXDynTypedNode N);

// True only for the default-constructed kind, which matches nothing.
bool clang_DynTypedNode_isNodeKindNone(CXDynTypedNode N);

// Whether the node's kind is one whose value is a pointer into the AST rather than a value
// copied into the node -- the same split that decides whether
// clang_DynTypedNode_getMemoizationData answers.
bool clang_DynTypedNode_nodeKindHasPointerIdentity(CXDynTypedNode N);

// Whether the two nodes have exactly the same kind (never true when either kind is none).
bool clang_DynTypedNode_isNodeKindSame(CXDynTypedNode A, CXDynTypedNode B);

// Whether Base's kind is the same as, or a base class of, Derived's -- how to ask "is this
// parent some kind of Decl?" without naming every subclass.
bool clang_DynTypedNode_isNodeKindBaseOf(CXDynTypedNode Base, CXDynTypedNode Derived);

// The discrimination (MARSHALLING.md §8): at most one of these answers non-NULL for a given
// node, and all of them answer NULL for a kind none of them covers. Each is clang's
// `get<T>()`, so a subclass node answers its base's accessor too -- an IfStmt node answers
// clang_DynTypedNode_getAsStmt.
//
// The pointer-identity kinds hand back BORROWED AST-arena pointers, valid as long as the
// AST is.
CXStmt clang_DynTypedNode_getAsStmt(CXDynTypedNode N);

CXDecl clang_DynTypedNode_getAsDecl(CXDynTypedNode N);

CXType_ clang_DynTypedNode_getAsType(CXDynTypedNode N);

CXNestedNameSpecifier clang_DynTypedNode_getAsNestedNameSpecifier(CXDynTypedNode N);

CXAttr clang_DynTypedNode_getAsAttr(CXDynTypedNode N);

CXCXXCtorInitializer clang_DynTypedNode_getAsCXXCtorInitializer(CXDynTypedNode N);

CXCXXBaseSpecifier clang_DynTypedNode_getAsCXXBaseSpecifier(CXDynTypedNode N);

// A QualType crosses as its own opaque encoding, so this one is a copy and needs no
// lifetime caveat. NULL both for "not a QualType node" and for a node holding a null type.
CXQualType clang_DynTypedNode_getAsQualType(CXDynTypedNode N);

// The by-value kinds are copied OUT of the node into their own boxes, so each result
// outlives N and carries its family's own dispose:
// clang_TypeLoc_dispose, clang_NestedNameSpecifierLoc_dispose.
CXTypeLoc clang_DynTypedNode_getAsTypeLoc(CXDynTypedNode N);

CXNestedNameSpecifierLoc clang_DynTypedNode_getAsNestedNameSpecifierLoc(CXDynTypedNode N);

// The exception: a TemplateArgument has no box-and-dispose family in the shim, so this is a
// BORROWED interior pointer into N's own storage. It dies with N.
CXTemplateArgument clang_DynTypedNode_getAsTemplateArgument(CXDynTypedNode N);

// getUnchecked

// The address that identifies the node, or NULL for a kind stored by value. Two nodes of
// the same kind name the same AST node exactly when this is equal and non-NULL, which is
// the comparison clang's own DenseMap over DynTypedNode uses.
const void *clang_DynTypedNode_getMemoizationData(CXDynTypedNode N);

// Where the node was written, or an invalid range for a node that is not a textual entity.
CXSourceRange_ clang_DynTypedNode_getSourceRange(CXDynTypedNode N);

// The node as source, and as an AST dump. Both CXStrings are caller-owned.
CXString clang_DynTypedNode_print(CXDynTypedNode N, CXPrintingPolicy_ PP);

CXString clang_DynTypedNode_dump(CXDynTypedNode N, CXASTContext Context);

LLVM_CLANG_C_EXTERN_C_END

#endif
