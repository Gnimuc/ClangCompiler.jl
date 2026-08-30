#include "clang-ex/AST/CXTemplateName.h"
#include "utils.h"
#include "clang/AST/TemplateName.h"
#include "clang/AST/ASTContext.h"
#include "llvm/Support/raw_ostream.h"

bool clang_TemplateName_isNull(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).isNull();
}

CXTemplateName_NameKind clang_TemplateName_getKind(CXTemplateName TN) {
  return static_cast<CXTemplateName_NameKind>(
      clang::TemplateName::getFromVoidPointer(TN).getKind());
}

CXTemplateDecl clang_TemplateName_getAsTemplateDecl(CXTemplateName TN) {
  return reinterpret_cast<CXTemplateDecl>(clang::TemplateName::getFromVoidPointer(TN).getAsTemplateDecl());
}

CXOverloadedTemplateStorage clang_TemplateName_getAsOverloadedTemplate(CXTemplateName TN) {
  return reinterpret_cast<CXOverloadedTemplateStorage>(clang::TemplateName::getFromVoidPointer(TN).getAsOverloadedTemplate());
}

CXAssumedTemplateStorage clang_TemplateName_getAsAssumedTemplateName(CXTemplateName TN) {
  return reinterpret_cast<CXAssumedTemplateStorage>(clang::TemplateName::getFromVoidPointer(TN).getAsAssumedTemplateName());
}

CXSubstTemplateTemplateParmStorage
clang_TemplateName_getAsSubstTemplateTemplateParm(CXTemplateName TN) {
  return reinterpret_cast<CXSubstTemplateTemplateParmStorage>(clang::TemplateName::getFromVoidPointer(TN).getAsSubstTemplateTemplateParm());
}

CXSubstTemplateTemplateParmPackStorage
clang_TemplateName_getAsSubstTemplateTemplateParmPack(CXTemplateName TN) {
  return reinterpret_cast<CXSubstTemplateTemplateParmPackStorage>(clang::TemplateName::getFromVoidPointer(TN).getAsSubstTemplateTemplateParmPack());
}

CXQualifiedTemplateName clang_TemplateName_getAsQualifiedTemplateName(CXTemplateName TN) {
  return reinterpret_cast<CXQualifiedTemplateName>(clang::TemplateName::getFromVoidPointer(TN).getAsQualifiedTemplateName());
}

CXDependentTemplateName clang_TemplateName_getAsDependentTemplateName(CXTemplateName TN) {
  return reinterpret_cast<CXDependentTemplateName>(clang::TemplateName::getFromVoidPointer(TN).getAsDependentTemplateName());
}

CXUsingShadowDecl clang_TemplateName_getAsUsingShadowDecl(CXTemplateName TN) {
  return reinterpret_cast<CXUsingShadowDecl>(clang::TemplateName::getFromVoidPointer(TN).getAsUsingShadowDecl());
}

CXTemplateName clang_TemplateName_getUnderlying(CXTemplateName TN) {
  return reinterpret_cast<CXTemplateName>(clang::TemplateName::getFromVoidPointer(TN).getUnderlying().getAsVoidPointer());
}

// getNameToSubstitute

unsigned clang_TemplateName_getDependence(CXTemplateName TN) {
  return static_cast<unsigned>(clang::TemplateName::getFromVoidPointer(TN).getDependence());
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

CXString clang_TemplateName_getAsString(CXTemplateName TN, CXASTContext Ctx,
                                        CXTemplateName_Qualified Qual) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::TemplateName::getFromVoidPointer(TN).print(
      OS, reinterpret_cast<clang::ASTContext *>(Ctx)->getPrintingPolicy(),
      static_cast<clang::TemplateName::Qualified>(Qual));
  return extra::makeCXString(Str);
}

void clang_TemplateName_dump(CXTemplateName TN) {
  return clang::TemplateName::getFromVoidPointer(TN).dump();
}
// SubstTemplateTemplateParmStorage

CXDecl clang_SubstTemplateTemplateParmStorage_getAssociatedDecl(
    CXSubstTemplateTemplateParmStorage S) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::SubstTemplateTemplateParmStorage *>(S)->getAssociatedDecl());
}

unsigned
clang_SubstTemplateTemplateParmStorage_getIndex(CXSubstTemplateTemplateParmStorage S) {
  return reinterpret_cast<clang::SubstTemplateTemplateParmStorage *>(S)->getIndex();
}

CXTemplateName clang_SubstTemplateTemplateParmStorage_getReplacement(
    CXSubstTemplateTemplateParmStorage S) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::SubstTemplateTemplateParmStorage *>(S)
      ->getReplacement()
      .getAsVoidPointer());
}

// QualifiedTemplateName

CXNestedNameSpecifier
clang_QualifiedTemplateName_getQualifier(CXQualifiedTemplateName QTN) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::QualifiedTemplateName *>(QTN)->getQualifier());
}

bool clang_QualifiedTemplateName_hasTemplateKeyword(CXQualifiedTemplateName QTN) {
  return reinterpret_cast<clang::QualifiedTemplateName *>(QTN)->hasTemplateKeyword();
}

CXTemplateName
clang_QualifiedTemplateName_getUnderlyingTemplate(CXQualifiedTemplateName QTN) {
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::QualifiedTemplateName *>(QTN)
      ->getUnderlyingTemplate()
      .getAsVoidPointer());
}

// DependentTemplateName

CXNestedNameSpecifier
clang_DependentTemplateName_getQualifier(CXDependentTemplateName DTN) {
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::DependentTemplateName *>(DTN)->getQualifier());
}

bool clang_DependentTemplateName_isIdentifier(CXDependentTemplateName DTN) {
  return reinterpret_cast<clang::DependentTemplateName *>(DTN)->isIdentifier();
}

CXIdentifierInfo clang_DependentTemplateName_getIdentifier(CXDependentTemplateName DTN) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::DependentTemplateName *>(DTN)->getIdentifier()));
}

bool clang_DependentTemplateName_isOverloadedOperator(CXDependentTemplateName DTN) {
  return reinterpret_cast<clang::DependentTemplateName *>(DTN)->isOverloadedOperator();
}

CXOverloadedOperatorKind
clang_DependentTemplateName_getOperator(CXDependentTemplateName DTN) {
  return static_cast<CXOverloadedOperatorKind>(
      reinterpret_cast<clang::DependentTemplateName *>(DTN)->getOperator());
}

bool clang_SubstTemplateTemplateParmStorage_getPackIndex(
    CXSubstTemplateTemplateParmStorage S, unsigned *Out) {
  auto I = reinterpret_cast<clang::SubstTemplateTemplateParmStorage *>(S)->getPackIndex();
  if (!I)
    return false;
  *Out = *I;
  return true;
}

CXTemplateTemplateParmDecl clang_SubstTemplateTemplateParmStorage_getParameter(
    CXSubstTemplateTemplateParmStorage S) {
  return reinterpret_cast<CXTemplateTemplateParmDecl>(reinterpret_cast<clang::SubstTemplateTemplateParmStorage *>(S)->getParameter());
}
