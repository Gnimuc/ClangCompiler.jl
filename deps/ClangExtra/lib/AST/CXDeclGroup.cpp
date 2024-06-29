#include "clang-ex/AST/CXDeclGroup.h"
#include "clang/AST/DeclGroup.h"

CXDeclGroupRef clang_DeclGroupRef_fromeDecl(CXDecl D) {
  return clang::DeclGroupRef(static_cast<clang::Decl *>(D)).getAsOpaquePtr();
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
  return clang::DeclGroupRef::getFromOpaquePtr(DG).getSingleDecl();
}