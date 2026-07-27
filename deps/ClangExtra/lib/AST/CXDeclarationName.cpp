#include "clang-ex/AST/CXDeclarationName.h"
#include "utils.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/CanonicalType.h"
#include "clang/AST/DeclTemplate.h"
#include "clang/AST/DeclarationName.h"

CXDeclarationName_NameKind clang_DeclarationName_getNameKind(CXDeclarationName DN) {
  return static_cast<CXDeclarationName_NameKind>(
      clang::DeclarationName::getFromOpaquePtr(DN).getNameKind());
}

bool clang_DeclarationName_isIdentifier(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).isIdentifier();
}

bool clang_DeclarationName_isDependentName(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).isDependentName();
}

CXIdentifierInfo clang_DeclarationName_getAsIdentifierInfo(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).getAsIdentifierInfo();
}

CXQualType clang_DeclarationName_getCXXNameType(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).getCXXNameType().getAsOpaquePtr();
}

CXTemplateDecl clang_DeclarationName_getCXXDeductionGuideTemplate(CXDeclarationName DN) {
  return clang::DeclarationName::getFromOpaquePtr(DN).getCXXDeductionGuideTemplate();
}

CXOverloadedOperatorKind
clang_DeclarationName_getCXXOverloadedOperator(CXDeclarationName DN) {
  return static_cast<CXOverloadedOperatorKind>(
      clang::DeclarationName::getFromOpaquePtr(DN).getCXXOverloadedOperator());
}

CXIdentifierInfo clang_DeclarationName_getCXXLiteralIdentifier(CXDeclarationName DN) {
  return const_cast<clang::IdentifierInfo *>(
      clang::DeclarationName::getFromOpaquePtr(DN).getCXXLiteralIdentifier());
}

CXDeclarationName clang_DeclarationName_getUsingDirectiveName(void) {
  return clang::DeclarationName::getUsingDirectiveName().getAsOpaquePtr();
}

int clang_DeclarationName_compare(CXDeclarationName LHS, CXDeclarationName RHS) {
  return clang::DeclarationName::compare(clang::DeclarationName::getFromOpaquePtr(LHS),
                                         clang::DeclarationName::getFromOpaquePtr(RHS));
}

CXDeclarationNameTable clang_DeclarationNameTable_getFromASTContext(CXASTContext Ctx) {
  return &static_cast<clang::ASTContext *>(Ctx)->DeclarationNames;
}

CXDeclarationName clang_DeclarationNameTable_getIdentifier(CXDeclarationNameTable Table,
                                                           CXIdentifierInfo ID) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getIdentifier(static_cast<clang::IdentifierInfo *>(ID))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXConstructorName(CXDeclarationNameTable Table,
                                                 CXQualType Ty) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXConstructorName(
          clang::CanQualType::CreateUnsafe(clang::QualType::getFromOpaquePtr(Ty)))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXDestructorName(CXDeclarationNameTable Table,
                                                CXQualType Ty) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXDestructorName(
          clang::CanQualType::CreateUnsafe(clang::QualType::getFromOpaquePtr(Ty)))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXDeductionGuideName(CXDeclarationNameTable Table,
                                                    CXTemplateDecl TD) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXDeductionGuideName(static_cast<clang::TemplateDecl *>(TD))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXConversionFunctionName(CXDeclarationNameTable Table,
                                                        CXQualType Ty) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXConversionFunctionName(
          clang::CanQualType::CreateUnsafe(clang::QualType::getFromOpaquePtr(Ty)))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXSpecialName(CXDeclarationNameTable Table,
                                             CXDeclarationName_NameKind Kind,
                                             CXQualType Ty) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXSpecialName(
          static_cast<clang::DeclarationName::NameKind>(Kind),
          clang::CanQualType::CreateUnsafe(clang::QualType::getFromOpaquePtr(Ty)))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXOperatorName(CXDeclarationNameTable Table,
                                              CXOverloadedOperatorKind Op) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXOperatorName(static_cast<clang::OverloadedOperatorKind>(Op))
      .getAsOpaquePtr();
}

CXDeclarationName
clang_DeclarationNameTable_getCXXLiteralOperatorName(CXDeclarationNameTable Table,
                                                     CXIdentifierInfo II) {
  return static_cast<clang::DeclarationNameTable *>(Table)
      ->getCXXLiteralOperatorName(static_cast<clang::IdentifierInfo *>(II))
      .getAsOpaquePtr();
}

void clang_DeclarationNameInfo_setName(CXDeclarationNameInfo DNInfo,
                                       CXDeclarationName Name) {
  static_cast<clang::DeclarationNameInfo *>(DNInfo)->setName(
      clang::DeclarationName::getFromOpaquePtr(Name));
}

void clang_DeclarationNameInfo_setLoc(CXDeclarationNameInfo DNInfo,
                                      CXSourceLocation_ L) {
  static_cast<clang::DeclarationNameInfo *>(DNInfo)->setLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXTypeSourceInfo
clang_DeclarationNameInfo_getNamedTypeInfo(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->getNamedTypeInfo();
}

CXSourceRange_
clang_DeclarationNameInfo_getCXXOperatorNameRange(CXDeclarationNameInfo DNInfo) {
  auto rng = static_cast<clang::DeclarationNameInfo *>(DNInfo)->getCXXOperatorNameRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_
clang_DeclarationNameInfo_getCXXLiteralOperatorNameLoc(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)
      ->getCXXLiteralOperatorNameLoc()
      .getPtrEncoding();
}

bool clang_DeclarationNameInfo_isInstantiationDependent(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)->isInstantiationDependent();
}

bool
clang_DeclarationNameInfo_containsUnexpandedParameterPack(CXDeclarationNameInfo DNInfo) {
  return static_cast<clang::DeclarationNameInfo *>(DNInfo)
      ->containsUnexpandedParameterPack();
}

CXSourceRange_ clang_DeclarationNameInfo_getSourceRange(CXDeclarationNameInfo DNInfo) {
  auto rng = static_cast<clang::DeclarationNameInfo *>(DNInfo)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

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