#include "clang-ex/AST/CXDeclCXX.h"
#include "clang/AST/DeclCXX.h"

// AccessSpecDecl
CXSourceLocation_ clang_AccessSpecDecl_getAccessSpecifierLoc(CXAccessSpecDecl AS) {
  return static_cast<clang::AccessSpecDecl *>(AS)->getAccessSpecifierLoc().getPtrEncoding();
}

void clang_AccessSpecDecl_setAccessSpecifierLoc(CXAccessSpecDecl AS,
                                                CXSourceLocation_ ASLoc) {
  static_cast<clang::AccessSpecDecl *>(AS)->setAccessSpecifierLoc(
      clang::SourceLocation::getFromPtrEncoding(ASLoc));
}

CXSourceLocation_ clang_AccessSpecDecl_getColonLoc(CXAccessSpecDecl AS) {
  return static_cast<clang::AccessSpecDecl *>(AS)->getColonLoc().getPtrEncoding();
}

void clang_AccessSpecDecl_setColonLoc(CXAccessSpecDecl AS, CXSourceLocation_ CLoc) {
  static_cast<clang::AccessSpecDecl *>(AS)->setColonLoc(
      clang::SourceLocation::getFromPtrEncoding(CLoc));
}

CXSourceRange_ clang_AccessSpecDecl_getSourceRange(CXAccessSpecDecl AS) {
  auto rng = static_cast<clang::AccessSpecDecl *>(AS)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXAccessSpecDecl clang_AccessSpecDecl_Create(CXASTContext C, CXAccessSpecifier AS,
                                             CXDeclContext DC, CXSourceLocation_ ASLoc,
                                             CXSourceLocation_ ColonLoc) {
  return clang::AccessSpecDecl::Create(*static_cast<clang::ASTContext *>(C),
                                       static_cast<clang::AccessSpecifier>(AS),
                                       static_cast<clang::DeclContext *>(DC),
                                       clang::SourceLocation::getFromPtrEncoding(ASLoc),
                                       clang::SourceLocation::getFromPtrEncoding(ColonLoc));
}

CXAccessSpecDecl clang_AccessSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::AccessSpecDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                   ID);
}

// CXXBaseSpecifier
CXSourceRange_ clang_CXXBaseSpecifier_getSourceRange(CXCXXBaseSpecifier CXXBS) {
  auto rng = static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_CXXBaseSpecifier_getColonLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXBaseSpecifier_getEndLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getEndLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXBaseSpecifier_getBaseTypeLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getBaseTypeLoc().getPtrEncoding();
}

bool clang_CXXBaseSpecifier_isVirtual(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isVirtual();
}

bool clang_CXXBaseSpecifier_isBaseOfClass(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isBaseOfClass();
}

bool clang_CXXBaseSpecifier_isPackExpansion(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isPackExpansion();
}

bool clang_CXXBaseSpecifier_getInheritConstructors(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getInheritConstructors();
}

void clang_CXXBaseSpecifier_setInheritConstructors(CXCXXBaseSpecifier CXXBS, bool Inherit) {
  static_cast<clang::CXXBaseSpecifier *>(CXXBS)->setInheritConstructors(Inherit);
}

CXSourceLocation_ clang_CXXBaseSpecifier_getEllipsisLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getEllipsisLoc().getPtrEncoding();
}

CXAccessSpecifier clang_CXXBaseSpecifier_getAccessSpecifier(CXCXXBaseSpecifier CXXBS) {
  return static_cast<CXAccessSpecifier>(
      static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getAccessSpecifier());
}

CXAccessSpecifier
clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXCXXBaseSpecifier CXXBS) {
  return static_cast<CXAccessSpecifier>(
      static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getAccessSpecifierAsWritten());
}

CXQualType clang_CXXBaseSpecifier_getType(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getType().getAsOpaquePtr();
}

CXTypeSourceInfo clang_CXXBaseSpecifier_getTypeSourceInfo(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getTypeSourceInfo();
}

// CXXRecordDecl
CXCXXRecordDecl clang_CXXRecordDecl_getCanonicalDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getCanonicalDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getPreviousDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getPreviousDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getMostRecentDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getMostRecentNonInjectedDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getDefinition(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDefinition();
}

bool clang_CXXRecordDecl_hasDefinition(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasDefinition();
}

CXCXXRecordDecl clang_CXXRecordDecl_Create(CXASTContext C, CXTagTypeKind TK,
                                           CXDeclContext DC, CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXCXXRecordDecl PrevDecl,
                                           bool DelayTypeCreation) {
  return clang::CXXRecordDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::TagTypeKind>(TK),
      static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id),
      static_cast<clang::CXXRecordDecl *>(PrevDecl), DelayTypeCreation);
}

CXCXXRecordDecl clang_CXXRecordDecl_CreateLambda(CXASTContext C, CXDeclContext DC,
                                                 CXTypeSourceInfo Info,
                                                 CXSourceLocation_ Loc,
                                                 bool DependentLambda, bool IsGeneric,
                                                 CXLambdaCaptureDefault CaptureDefault) {
  return clang::CXXRecordDecl::CreateLambda(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      static_cast<clang::TypeSourceInfo *>(Info),
      clang::SourceLocation::getFromPtrEncoding(Loc), DependentLambda, IsGeneric,
      static_cast<clang::LambdaCaptureDefault>(CaptureDefault));
}

bool clang_CXXRecordDecl_isDynamicClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isDynamicClass();
}

bool clang_CXXRecordDecl_isLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isLambda();
}

bool clang_CXXRecordDecl_isGenericLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isGenericLambda();
}

CXTemplateParameterList
clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)
      ->getGenericLambdaTemplateParameterList();
}

bool clang_CXXRecordDecl_isAggregate(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isAggregate();
}

bool clang_CXXRecordDecl_isPOD(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isPOD();
}

bool clang_CXXRecordDecl_isCLike(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isCLike();
}

bool clang_CXXRecordDecl_isEmpty(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isEmpty();
}

// ExplicitSpecifier
CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES) {
  return static_cast<CXExplicitSpecKind>(
      static_cast<clang::ExplicitSpecifier *>(ES)->getKind());
}

CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->getExpr();
}

bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isSpecified();
}

// isEquivalent

bool clang_ExplicitSpecifier_isExplicit(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isExplicit();
}

bool clang_ExplicitSpecifier_isInvalid(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isInvalid();
}

void clang_ExplicitSpecifier_setKind(CXExplicitSpecifier ES, CXExplicitSpecKind Kind) {
  static_cast<clang::ExplicitSpecifier *>(ES)->setKind(
      static_cast<clang::ExplicitSpecKind>(Kind));
}

void clang_ExplicitSpecifier_setExpr(CXExplicitSpecifier ES, CXExpr E) {
  static_cast<clang::ExplicitSpecifier *>(ES)->setExpr(static_cast<clang::Expr *>(E));
}

// getFromDecl
// Invalid

// CXXDeductionGuideDecl

// RequiresExprBodyDecl
CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ StartLoc) {
  return clang::RequiresExprBodyDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc));
}

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_CreateDeserialized(CXASTContext C,
                                                                     unsigned ID) {
  return clang::RequiresExprBodyDecl::CreateDeserialized(
      *static_cast<clang::ASTContext *>(C), ID);
}

// CXXMethodDecl
#if LLVM_VERSION_MAJOR >= 14
CXCXXMethodDecl clang_CXXMethodDecl_Create(CXASTContext C, CXCXXRecordDecl RD,
                                           CXSourceLocation_ StartLoc,
                                           CXDeclarationNameInfo NameInfo, CXQualType T,
                                           CXTypeSourceInfo TInfo, CXStorageClass SC,
                                           bool UsesFPIntrin, bool isInline,
                                           CXConstexprSpecKind ConstexprKind,
                                           CXSourceLocation_ EndLocation,
                                           CXExpr TrailingRequiresClause) {
  return clang::CXXMethodDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::CXXRecordDecl *>(RD),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo),
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::TypeSourceInfo *>(TInfo),
      static_cast<clang::StorageClass>(SC), isInline, UsesFPIntrin,
      static_cast<clang::ConstexprSpecKind>(ConstexprKind),
      clang::SourceLocation::getFromPtrEncoding(EndLocation),
      static_cast<clang::Expr *>(TrailingRequiresClause));
}
#else
CXCXXMethodDecl clang_CXXMethodDecl_Create(CXASTContext C, CXCXXRecordDecl RD,
                                           CXSourceLocation_ StartLoc,
                                           CXDeclarationNameInfo NameInfo, CXQualType T,
                                           CXTypeSourceInfo TInfo, CXStorageClass SC,
                                           bool isInline, CXConstexprSpecKind ConstexprKind,
                                           CXSourceLocation_ EndLocation,
                                           CXExpr TrailingRequiresClause) {
  return clang::CXXMethodDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::CXXRecordDecl *>(RD),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo),
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::TypeSourceInfo *>(TInfo),

      static_cast<clang::StorageClass>(SC), isInline,
      static_cast<clang::ConstexprSpecKind>(ConstexprKind),
      clang::SourceLocation::getFromPtrEncoding(EndLocation),
      static_cast<clang::Expr *>(TrailingRequiresClause));
}
#endif

CXCXXMethodDecl clang_CXXMethodDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::CXXMethodDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

bool clang_CXXMethodDecl_isStatic(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isStatic();
}

bool clang_CXXMethodDecl_isInstance(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isInstance();
}

// isStaticOverloadedOperator

bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isConst();
}

bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isVolatile();
}

bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isVirtual();
}

CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(CXCXXMethodDecl CXXMD,
                                                           CXExpr Base, bool IsAppleKext) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getDevirtualizedMethod(
      static_cast<clang::Expr *>(Base), IsAppleKext);
}

// isUsualDeallocationFunction

bool clang_CXXMethodDecl_isCopyAssignmentOperator(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isCopyAssignmentOperator();
}

bool clang_CXXMethodDecl_isMoveAssignmentOperator(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isMoveAssignmentOperator();
}

CXCXXMethodDecl clang_CXXMethodDecl_getCanonicalDecl(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCanonicalDecl();
}

CXCXXMethodDecl clang_CXXMethodDecl_getMostRecentDecl(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getMostRecentDecl();
}

void clang_CXXMethodDecl_addOverriddenMethod(CXCXXMethodDecl CXXMD, CXCXXMethodDecl MD) {
  static_cast<clang::CXXMethodDecl *>(CXXMD)->addOverriddenMethod(
      static_cast<clang::CXXMethodDecl *>(MD));
}

CXCXXRecordDecl clang_CXXMethodDecl_getParent(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getParent();
}

CXQualType clang_CXXMethodDecl_getThisType(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getThisType().getAsOpaquePtr();
}

CXQualType clang_CXXMethodDecl_getThisObjectType(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getThisObjectType().getAsOpaquePtr();
}

// getMethodQualifiers
// getRefQualifier

bool clang_CXXMethodDecl_hasInlineBody(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->hasInlineBody();
}

bool clang_CXXMethodDecl_isLambdaStaticInvoker(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isLambdaStaticInvoker();
}

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodInClass(CXCXXMethodDecl CXXMD,
                                                                  CXCXXRecordDecl RD,
                                                                  bool MayBeBase) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCorrespondingMethodInClass(
      static_cast<clang::CXXRecordDecl *>(RD), MayBeBase);
}

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCorrespondingMethodDeclaredInClass(
      static_cast<clang::CXXRecordDecl *>(RD), MayBeBase);
}

// CXXCtorInitializer

// InheritedConstructor

// CXXConstructorDecl

// CXXDestructorDecl

// CXXConversionDecl

// LinkageSpecDecl
CXLinkageSpecDecl clang_LinkageSpecDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ ExternLoc,
                                               CXSourceLocation_ LangLoc,
                                               CXLinkageSpecDecl_LanguageIDs Lang,
                                               bool HasBraces) {
  return clang::LinkageSpecDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(ExternLoc),
      clang::SourceLocation::getFromPtrEncoding(LangLoc),
      static_cast<clang::LinkageSpecDecl::LanguageIDs>(Lang), HasBraces);
}

CXLinkageSpecDecl clang_LinkageSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::LinkageSpecDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                    ID);
}

CXLinkageSpecDecl_LanguageIDs clang_LinkageSpecDecl_getLanguage(CXLinkageSpecDecl LSD) {
  return static_cast<CXLinkageSpecDecl_LanguageIDs>(
      static_cast<clang::LinkageSpecDecl *>(LSD)->getLanguage());
}

void clang_LinkageSpecDecl_setLanguage(CXLinkageSpecDecl LSD,
                                       CXLinkageSpecDecl_LanguageIDs Lang) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setLanguage(
      static_cast<clang::LinkageSpecDecl::LanguageIDs>(Lang));
}

bool clang_LinkageSpecDecl_hasBraces(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->hasBraces();
}

CXSourceLocation_ clang_LinkageSpecDecl_getExternLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getExternLoc().getPtrEncoding();
}

CXSourceLocation_ clang_LinkageSpecDecl_getRBraceLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getRBraceLoc().getPtrEncoding();
}

void clang_LinkageSpecDecl_setExternLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setExternLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_LinkageSpecDecl_setRBraceLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_LinkageSpecDecl_getEndLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_LinkageSpecDecl_getSourceRange(CXLinkageSpecDecl LSD) {
  auto rng = static_cast<clang::LinkageSpecDecl *>(LSD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXDeclContext clang_LinkageSpecDecl_castToDeclContext(CXLinkageSpecDecl LSD) {
  return clang::LinkageSpecDecl::castToDeclContext(
      static_cast<clang::LinkageSpecDecl *>(LSD));
}

CXLinkageSpecDecl clang_LinkageSpecDecl_castFromDeclContext(CXDeclContext DC) {
  return clang::LinkageSpecDecl::castFromDeclContext(static_cast<clang::DeclContext *>(DC));
}