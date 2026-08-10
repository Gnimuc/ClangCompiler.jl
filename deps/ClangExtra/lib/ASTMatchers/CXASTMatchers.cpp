#include "clang-ex/ASTMatchers/CXASTMatchers.h"

#include "utils.h"

#include "clang/AST/ASTTypeTraits.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/Type.h"
#include "clang/AST/TypeLoc.h"
#include "clang/ASTMatchers/ASTMatchers.h"

#include <iterator>
#include <string>

namespace {
clang::ast_matchers::BoundNodes *nodes(CXBoundNodes BN) {
  return reinterpret_cast<clang::ast_matchers::BoundNodes *>(BN);
}
} // namespace

void clang_BoundNodes_dispose(CXBoundNodes BN) {
  delete nodes(BN); // NOLINT(*-owning-memory)
}

unsigned clang_BoundNodes_getNumBindings(CXBoundNodes BN) {
  return static_cast<unsigned>(nodes(BN)->getMap().size());
}

CXString clang_BoundNodes_getBindingID(CXBoundNodes BN, unsigned Index) {
  const clang::ast_matchers::BoundNodes::IDToNodeMap &Map = nodes(BN)->getMap();
  if (Index >= Map.size())
    return extra::makeCXString("");
  clang::ast_matchers::BoundNodes::IDToNodeMap::const_iterator It = Map.begin();
  std::advance(It, Index);
  return extra::makeCXString(It->first);
}

CXDecl clang_BoundNodes_getNodeAsDecl(CXBoundNodes BN, const char *ID) {
  return reinterpret_cast<CXDecl>(
      const_cast<clang::Decl *>(nodes(BN)->getNodeAs<clang::Decl>(ID)));
}

CXStmt clang_BoundNodes_getNodeAsStmt(CXBoundNodes BN, const char *ID) {
  return reinterpret_cast<CXStmt>(
      const_cast<clang::Stmt *>(nodes(BN)->getNodeAs<clang::Stmt>(ID)));
}

CXQualType clang_BoundNodes_getNodeAsQualType(CXBoundNodes BN, const char *ID) {
  const clang::QualType *QT = nodes(BN)->getNodeAs<clang::QualType>(ID);
  if (QT == nullptr)
    return nullptr;
  return reinterpret_cast<CXQualType>(QT->getAsOpaquePtr());
}

CXTypeLoc clang_BoundNodes_getNodeAsTypeLoc(CXBoundNodes BN, const char *ID) {
  const clang::TypeLoc *TL = nodes(BN)->getNodeAs<clang::TypeLoc>(ID);
  if (TL == nullptr)
    return nullptr;
  // The TypeLoc lives inside this BoundNodes' DynTypedNode storage, so it would
  // dangle the moment the caller disposed the match. Box a copy instead, on the
  // same owned-CXTypeLoc contract as clang-ex/AST/CXTypeLoc.h.
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(*TL)); // NOLINT(*-owning-memory)
}
