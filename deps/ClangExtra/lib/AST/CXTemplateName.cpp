#include "clang-ex/AST/CXTemplateName.h"
#include "clang/AST/TemplateName.h"

bool clang_TemplateName_isNull(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).isNull();
}

CXTemplateName_NameKind clang_TemplateName_getKind(CXTemplateName TN) {
  return static_cast<CXTemplateName_NameKind>(
      clang::TemplateName::getFromVoidPointer(TN).getKind());
}

CXTemplateDecl clang_TemplateName_getAsTemplateDecl(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).getAsTemplateDecl();
}

CXTemplateName clang_TemplateName_getUnderlying(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).getUnderlying().getAsVoidPointer();
}

CXTemplateName clang_TemplateName_getNameToSubstitute(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN)
      .getNameToSubstitute()
      .getAsVoidPointer();
}

bool clang_TemplateName_isDependent(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).isDependent();
}

bool clang_TemplateName_isInstantiationDependent(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).isInstantiationDependent();
}

bool clang_TemplateName_containsUnexpandedParameterPack(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).containsUnexpandedParameterPack();
}

void clang_TemplateName_dump(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).dump();
}