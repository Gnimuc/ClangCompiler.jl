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