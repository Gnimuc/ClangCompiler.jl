#include "clang-ex/AST/CXParentMapContext.h"

#include "clang/AST/ASTTypeTraits.h"
#include "clang/AST/Expr.h"
#include "clang/AST/ParentMapContext.h"

// ParentMapContext

// getParents

void clang_ParentMapContext_clear(CXParentMapContext PMC) {
  reinterpret_cast<clang::ParentMapContext *>(PMC)->clear();
}

CXTraversalKind clang_ParentMapContext_getTraversalKind(CXParentMapContext PMC) {
  return static_cast<CXTraversalKind>(
      reinterpret_cast<clang::ParentMapContext *>(PMC)->getTraversalKind());
}

void clang_ParentMapContext_setTraversalKind(CXParentMapContext PMC, CXTraversalKind TK) {
  reinterpret_cast<clang::ParentMapContext *>(PMC)->setTraversalKind(
      static_cast<clang::TraversalKind>(TK));
}

CXExpr clang_ParentMapContext_traverseIgnored(CXParentMapContext PMC, CXExpr E) {
  return reinterpret_cast<CXExpr>(
      reinterpret_cast<clang::ParentMapContext *>(PMC)->traverseIgnored(
          reinterpret_cast<clang::Expr *>(E)));
}
