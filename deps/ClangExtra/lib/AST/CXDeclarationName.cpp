#include "clang-ex/AST/CXDeclarationName.h"
#include "libclang/CXString.h"
#include "clang/AST/DeclarationName.h"

CXDeclarationName clang_DeclarationName_create(void) {
  return clang::DeclarationName().getAsOpaquePtr();
}

CXDeclarationName clang_DeclarationName_createFromIdentifierInfo(CXIdentifierInfo IDInfo) {
  return clang::DeclarationName(static_cast<clang::IdentifierInfo *>(IDInfo))
      .getAsOpaquePtr();
}

void clang_DeclarationName_dump(CXDeclarationName DN) {
  clang::DeclarationName::getFromOpaquePtr(DN).dump();
}

bool clang_DeclarationName_isEmpty(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).isEmpty();
}

CXString clang_DeclarationName_getAsString(CXDeclarationName DN) {
  return clang::cxstring::createDup(
      clang::DeclarationName::getFromOpaquePtr(DN).getAsString());
}