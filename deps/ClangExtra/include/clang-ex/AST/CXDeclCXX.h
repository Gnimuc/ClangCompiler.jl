#ifndef LLVM_CLANG_C_EXTRA_CXDECLCXX_H
#define LLVM_CLANG_C_EXTRA_CXDECLCXX_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// AccessSpecDecl
CXSourceLocation_ clang_AccessSpecDecl_getAccessSpecifierLoc(CXAccessSpecDecl AS);

void clang_AccessSpecDecl_setAccessSpecifierLoc(CXAccessSpecDecl AS,
                                                CXSourceLocation_ ASLoc);

CXSourceLocation_ clang_AccessSpecDecl_getColonLoc(CXAccessSpecDecl AS);

void clang_AccessSpecDecl_setColonLoc(CXAccessSpecDecl AS, CXSourceLocation_ CLoc);

CXSourceRange_ clang_AccessSpecDecl_getSourceRange(CXAccessSpecDecl AS);

CXAccessSpecDecl clang_AccessSpecDecl_Create(CXASTContext C, CXAccessSpecifier AS,
                                             CXDeclContext DC, CXSourceLocation_ ASLoc,
                                             CXSourceLocation_ ColonLoc);

CXAccessSpecDecl clang_AccessSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// CXXBaseSpecifier
CXSourceRange_ clang_CXXBaseSpecifier_getSourceRange(CXCXXBaseSpecifier CXXBS);

CXSourceLocation_ clang_CXXBaseSpecifier_getColonLoc(CXCXXBaseSpecifier CXXBS);

CXSourceLocation_ clang_CXXBaseSpecifier_getEndLoc(CXCXXBaseSpecifier CXXBS);

CXSourceLocation_ clang_CXXBaseSpecifier_getBaseTypeLoc(CXCXXBaseSpecifier CXXBS);

bool clang_CXXBaseSpecifier_isVirtual(CXCXXBaseSpecifier CXXBS);

bool clang_CXXBaseSpecifier_isBaseOfClass(CXCXXBaseSpecifier CXXBS);

bool clang_CXXBaseSpecifier_isPackExpansion(CXCXXBaseSpecifier CXXBS);

bool clang_CXXBaseSpecifier_getInheritConstructors(CXCXXBaseSpecifier CXXBS);

void clang_CXXBaseSpecifier_setInheritConstructors(CXCXXBaseSpecifier CXXBS, bool Inherit);

CXSourceLocation_ clang_CXXBaseSpecifier_getEllipsisLoc(CXCXXBaseSpecifier CXXBS);

CXAccessSpecifier clang_CXXBaseSpecifier_getAccessSpecifier(CXCXXBaseSpecifier CXXBS);

CXAccessSpecifier
clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXCXXBaseSpecifier CXXBS);

CXQualType clang_CXXBaseSpecifier_getType(CXCXXBaseSpecifier CXXBS);

CXTypeSourceInfo clang_CXXBaseSpecifier_getTypeSourceInfo(CXCXXBaseSpecifier CXXBS);

// CXXRecordDecl
CXCXXRecordDecl clang_CXXRecordDecl_getCanonicalDecl(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_getPreviousDecl(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentDecl(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_getDefinition(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasDefinition(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_Create(CXASTContext C, CXTagTypeKind TK,
                                           CXDeclContext DC, CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXCXXRecordDecl PrevDecl,
                                           bool DelayTypeCreation);

CXCXXRecordDecl clang_CXXRecordDecl_CreateLambda(CXASTContext C, CXDeclContext DC,
                                                 CXTypeSourceInfo Info,
                                                 CXSourceLocation_ Loc,
                                                 bool DependentLambda, bool IsGeneric,
                                                 CXLambdaCaptureDefault CaptureDefault);

bool clang_CXXRecordDecl_isLambda(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isGenericLambda(CXCXXRecordDecl CXXRD);

CXTemplateParameterList
clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isAggregate(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isPOD(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isCLike(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isEmpty(CXCXXRecordDecl CXXRD);

// ExplicitSpecifier
CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES);

CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES);

bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES);

// isEquivalent

bool clang_ExplicitSpecifier_isExplicit(CXExplicitSpecifier ES);

bool clang_ExplicitSpecifier_isInvalid(CXExplicitSpecifier ES);

void clang_ExplicitSpecifier_setKind(CXExplicitSpecifier ES, CXExplicitSpecKind Kind);

void clang_ExplicitSpecifier_setExpr(CXExplicitSpecifier ES, CXExpr E);

// getFromDecl
// Invalid

// CXXDeductionGuideDecl

// RequiresExprBodyDecl
CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ StartLoc);

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_CreateDeserialized(CXASTContext C,
                                                                     unsigned ID);

// CXXMethodDecl
CXCXXMethodDecl
clang_CXXMethodDecl_Create(CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
                           CXDeclarationNameInfo NameInfo, CXQualType T,
                           CXTypeSourceInfo TInfo, CXStorageClass SC, bool UsesFPIntrin,
                           bool isInline, CXConstexprSpecKind ConstexprKind,
                           CXSourceLocation_ EndLocation, CXExpr TrailingRequiresClause);

CXCXXMethodDecl clang_CXXMethodDecl_CreateDeserialized(CXASTContext C, unsigned ID);

bool clang_CXXMethodDecl_isStatic(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isInstance(CXCXXMethodDecl CXXMD);

// isStaticOverloadedOperator

bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(CXCXXMethodDecl CXXMD,
                                                           CXExpr Base, bool IsAppleKext);

// isUsualDeallocationFunction

bool clang_CXXMethodDecl_isCopyAssignmentOperator(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isMoveAssignmentOperator(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getCanonicalDecl(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getMostRecentDecl(CXCXXMethodDecl CXXMD);

void clang_CXXMethodDecl_addOverriddenMethod(CXCXXMethodDecl CXXMD, CXCXXMethodDecl MD);

CXCXXRecordDecl clang_CXXMethodDecl_getParent(CXCXXMethodDecl CXXMD);

CXQualType clang_CXXMethodDecl_getThisType(CXCXXMethodDecl CXXMD);

// getMethodQualifiers
// getRefQualifier

bool clang_CXXMethodDecl_hasInlineBody(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isLambdaStaticInvoker(CXCXXMethodDecl CXXMD);

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodInClass(CXCXXMethodDecl CXXMD,
                                                                  CXCXXRecordDecl RD,
                                                                  bool MayBeBase);

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase);

// CXXCtorInitializer

// InheritedConstructor

// CXXConstructorDecl

// CXXDestructorDecl

// CXXConversionDecl

// LinkageSpecDecl
typedef enum CXLinkageSpecLanguageIDs {
  CXLinkageSpecDecl_lang_c = 1,
  CXLinkageSpecDecl_lang_cxx = 2
} CXLinkageSpecLanguageIDs;

CXLinkageSpecDecl clang_LinkageSpecDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ ExternLoc,
                                               CXSourceLocation_ LangLoc,
                                               CXLinkageSpecLanguageIDs Lang,
                                               bool HasBraces);

CXLinkageSpecDecl clang_LinkageSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXLinkageSpecLanguageIDs clang_LinkageSpecDecl_getLanguage(CXLinkageSpecDecl LSD);

void clang_LinkageSpecDecl_setLanguage(CXLinkageSpecDecl LSD,
                                       CXLinkageSpecLanguageIDs Lang);

bool clang_LinkageSpecDecl_hasBraces(CXLinkageSpecDecl LSD);

CXSourceLocation_ clang_LinkageSpecDecl_getExternLoc(CXLinkageSpecDecl LSD);

CXSourceLocation_ clang_LinkageSpecDecl_getRBraceLoc(CXLinkageSpecDecl LSD);

void clang_LinkageSpecDecl_setExternLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc);

void clang_LinkageSpecDecl_setRBraceLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc);

CXSourceLocation_ clang_LinkageSpecDecl_getEndLoc(CXLinkageSpecDecl LSD);

CXSourceRange_ clang_LinkageSpecDecl_getSourceRange(CXLinkageSpecDecl LSD);

CXDeclContext clang_LinkageSpecDecl_castToDeclContext(CXLinkageSpecDecl LSD);

CXLinkageSpecDecl clang_LinkageSpecDecl_castFromDeclContext(CXDeclContext DC);

LLVM_CLANG_C_EXTERN_C_END

#endif
