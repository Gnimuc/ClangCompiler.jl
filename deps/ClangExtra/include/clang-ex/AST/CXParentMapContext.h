#ifndef LLVM_CLANG_C_EXTRA_CXPARENTMAPCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXPARENTMAPCONTEXT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::TraversalKind (clang/AST/ASTTypeTraits.h) — how a parent walk descends
// through expressions. Placed ahead of the accessors that carry it.
typedef enum CXTraversalKind {
  CXTraversalKind_TK_AsIs,
  CXTraversalKind_TK_IgnoreUnlessSpelledInSource
} CXTraversalKind;

// ParentMapContext

// getParents

// Drop the cached parent map. The next parent query rebuilds it over the ASTContext's
// current traversal scope, which is what makes a map built before a later incremental parse
// recoverable without narrowing the scope.
void clang_ParentMapContext_clear(CXParentMapContext PMC);

// The kind every parent query and every clang_ParentMapContext_traverseIgnored below
// applies. A plain member with an in-class initializer (TK_AsIs), so it is defined to read
// on a freshly built map.
CXTraversalKind clang_ParentMapContext_getTraversalKind(CXParentMapContext PMC);

// Changing the kind does NOT drop the cached map — clang applies the kind as the map is
// walked, not as it is built.
void clang_ParentMapContext_setTraversalKind(CXParentMapContext PMC, CXTraversalKind TK);

// E with whatever the current traversal kind ignores skipped: E itself under TK_AsIs, and
// clang_Expr_IgnoreUnlessSpelledInSource(E) under TK_IgnoreUnlessSpelledInSource. A
// borrowed AST-arena pointer. The DynTypedNode overload is not wrapped.
CXExpr clang_ParentMapContext_traverseIgnored(CXParentMapContext PMC, CXExpr E);

LLVM_CLANG_C_EXTERN_C_END

#endif
