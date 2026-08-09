#include "clang-ex/AST/CXDeclGroup.h"
#include "clang/AST/DeclGroup.h"

CXDeclGroupRef clang_DeclGroupRef_fromDecl(CXDecl D) {
  return reinterpret_cast<CXDeclGroupRef>(clang::DeclGroupRef(reinterpret_cast<clang::Decl *>(D)).getAsOpaquePtr());
}

bool clang_DeclGroupRef_isNull(CXDeclGroupRef DG) {
  return clang::DeclGroupRef::getFromOpaquePtr(DG).isNull();
}

bool clang_DeclGroupRef_isSingleDecl(CXDeclGroupRef DG) {
  return clang::DeclGroupRef::getFromOpaquePtr(DG).isSingleDecl();
}

bool clang_DeclGroupRef_isDeclGroup(CXDeclGroupRef DG) {
  return clang::DeclGroupRef::getFromOpaquePtr(DG).isDeclGroup();
}

CXDecl clang_DeclGroupRef_getSingleDecl(CXDeclGroupRef DG) {
  return reinterpret_cast<CXDecl>(clang::DeclGroupRef::getFromOpaquePtr(DG).getSingleDecl());
}

unsigned clang_DeclGroupRef_size(CXDeclGroupRef DG) {
  clang::DeclGroupRef G = clang::DeclGroupRef::getFromOpaquePtr(DG);
  if (G.isNull())
    return 0;
  if (G.isSingleDecl())
    return 1;
  return G.getDeclGroup().size();
}

CXDecl clang_DeclGroupRef_getDecl(CXDeclGroupRef DG, unsigned I) {
  clang::DeclGroupRef G = clang::DeclGroupRef::getFromOpaquePtr(DG);
  return reinterpret_cast<CXDecl>(G.isSingleDecl() ? G.getSingleDecl() : G.getDeclGroup()[I]);
}