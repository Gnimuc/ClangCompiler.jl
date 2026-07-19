#include "clang-ex/AST/CXDeclarationName.h"
#include "utils.h"
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
  return extra::makeCXString(clang::DeclarationName::getFromOpaquePtr(DN).getAsString());
}

CXDeclarationNameInfo clang_DeclarationNameInfo_create(CXDeclarationName Name,
                                                       CXSourceLocation_ NameLoc) {
  return std::make_unique<clang::DeclarationNameInfo>(
             clang::DeclarationName::getFromOpaquePtr(Name),
             clang::SourceLocation::getFromPtrEncoding(NameLoc))
      .release();
}

void clang_DeclarationNameInfo_dispose(CXDeclarationNameInfo DNInfo) {
  delete static_cast<clang::DeclarationNameInfo *>(DNInfo);
}

CXDeclarationName clang_DeclarationNameInfo_getName(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->getName().getAsOpaquePtr();
}

CXSourceLocation_ clang_DeclarationNameInfo_getLoc(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->getLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclarationNameInfo_getBeginLoc(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclarationNameInfo_getEndLoc(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->getEndLoc().getPtrEncoding();
}

CXString clang_DeclarationNameInfo_getAsString(CXDeclarationNameInfo DNInfo) {
  return extra::makeCXString(
      static_cast<clang::DeclarationNameInfo *>(DNInfo)->getAsString());
}