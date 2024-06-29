#ifndef LIBCLANGEX_CXDECLCXX_H
#define LIBCLANGEX_CXDECLCXX_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

// AccessSpecDecl
CINDEX_LINKAGE CXSourceLocation_
clang_AccessSpecDecl_getAccessSpecifierLoc(CXAccessSpecDecl AS);

CINDEX_LINKAGE void clang_AccessSpecDecl_setAccessSpecifierLoc(CXAccessSpecDecl AS,
                                                               CXSourceLocation_ ASLoc);

CINDEX_LINKAGE CXSourceLocation_ clang_AccessSpecDecl_getColonLoc(CXAccessSpecDecl AS);

CINDEX_LINKAGE void clang_AccessSpecDecl_setColonLoc(CXAccessSpecDecl AS,
                                                     CXSourceLocation_ CLoc);

CINDEX_LINKAGE CXSourceRange_ clang_AccessSpecDecl_getSourceRange(CXAccessSpecDecl AS);

CINDEX_LINKAGE CXAccessSpecDecl clang_AccessSpecDecl_Create(CXASTContext C,
                                                            CXAccessSpecifier AS,
                                                            CXDeclContext DC,
                                                            CXSourceLocation_ ASLoc,
                                                            CXSourceLocation_ ColonLoc);

CINDEX_LINKAGE CXAccessSpecDecl clang_AccessSpecDecl_CreateDeserialized(CXASTContext C,
                                                                        unsigned ID);

// CXXBaseSpecifier
CINDEX_LINKAGE CXSourceRange_
clang_CXXBaseSpecifier_getSourceRange(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXSourceLocation_
clang_CXXBaseSpecifier_getColonLoc(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXSourceLocation_ clang_CXXBaseSpecifier_getEndLoc(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXSourceLocation_
clang_CXXBaseSpecifier_getBaseTypeLoc(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE bool clang_CXXBaseSpecifier_isVirtual(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE bool clang_CXXBaseSpecifier_isBaseOfClass(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE bool clang_CXXBaseSpecifier_isPackExpansion(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE bool clang_CXXBaseSpecifier_getInheritConstructors(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE void clang_CXXBaseSpecifier_setInheritConstructors(CXCXXBaseSpecifier CXXBS,
                                                                  bool Inherit);

CINDEX_LINKAGE CXSourceLocation_
clang_CXXBaseSpecifier_getEllipsisLoc(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXAccessSpecifier
clang_CXXBaseSpecifier_getAccessSpecifier(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXAccessSpecifier
clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXQualType clang_CXXBaseSpecifier_getType(CXCXXBaseSpecifier CXXBS);

CINDEX_LINKAGE CXTypeSourceInfo
clang_CXXBaseSpecifier_getTypeSourceInfo(CXCXXBaseSpecifier CXXBS);

// CXXRecordDecl
CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_getCanonicalDecl(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_getPreviousDecl(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentDecl(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXCXXRecordDecl
clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_getDefinition(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_hasDefinition(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_Create(
    CXASTContext C, CXTagTypeKind TK, CXDeclContext DC, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXCXXRecordDecl PrevDecl,
    bool DelayTypeCreation);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXRecordDecl_CreateLambda(
    CXASTContext C, CXDeclContext DC, CXTypeSourceInfo Info, CXSourceLocation_ Loc,
    bool DependentLambda, bool IsGeneric, CXLambdaCaptureDefault CaptureDefault);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isLambda(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isGenericLambda(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE CXTemplateParameterList
clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isAggregate(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isPOD(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isCLike(CXCXXRecordDecl CXXRD);

CINDEX_LINKAGE bool clang_CXXRecordDecl_isEmpty(CXCXXRecordDecl CXXRD);

// ExplicitSpecifier
CINDEX_LINKAGE CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES);

CINDEX_LINKAGE CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES);

CINDEX_LINKAGE bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES);

// isEquivalent

CINDEX_LINKAGE bool clang_ExplicitSpecifier_isExplicit(CXExplicitSpecifier ES);

CINDEX_LINKAGE bool clang_ExplicitSpecifier_isInvalid(CXExplicitSpecifier ES);

CINDEX_LINKAGE void clang_ExplicitSpecifier_setKind(CXExplicitSpecifier ES,
                                                    CXExplicitSpecKind Kind);

CINDEX_LINKAGE void clang_ExplicitSpecifier_setExpr(CXExplicitSpecifier ES, CXExpr E);

// getFromDecl
// Invalid

// CXXDeductionGuideDecl

// RequiresExprBodyDecl
CINDEX_LINKAGE CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc);

CINDEX_LINKAGE CXRequiresExprBodyDecl
clang_RequiresExprBodyDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// CXXMethodDecl
#if LLVM_VERSION_MAJOR >= 14
CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_Create(
    CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo, CXStorageClass SC,
    bool UsesFPIntrin, bool isInline, CXConstexprSpecKind ConstexprKind, CXSourceLocation_ EndLocation,
    CXExpr TrailingRequiresClause); 
#else
CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_Create(
    CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo, CXStorageClass SC,
    bool isInline, CXConstexprSpecKind ConstexprKind, CXSourceLocation_ EndLocation,
    CXExpr TrailingRequiresClause);
#endif

CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_CreateDeserialized(CXASTContext C,
                                                                      unsigned ID);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isStatic(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isInstance(CXCXXMethodDecl CXXMD);

// isStaticOverloadedOperator

CINDEX_LINKAGE bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(
    CXCXXMethodDecl CXXMD, CXExpr Base, bool IsAppleKext);

// isUsualDeallocationFunction

CINDEX_LINKAGE bool clang_CXXMethodDecl_isCopyAssignmentOperator(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isMoveAssignmentOperator(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_getCanonicalDecl(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXCXXMethodDecl clang_CXXMethodDecl_getMostRecentDecl(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE void clang_CXXMethodDecl_addOverriddenMethod(CXCXXMethodDecl CXXMD,
                                                            CXCXXMethodDecl MD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXMethodDecl_getParent(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXQualType clang_CXXMethodDecl_getThisType(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXQualType clang_CXXMethodDecl_getThisObjectType(CXCXXMethodDecl CXXMD);

// getMethodQualifiers
// getRefQualifier

CINDEX_LINKAGE bool clang_CXXMethodDecl_hasInlineBody(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE bool clang_CXXMethodDecl_isLambdaStaticInvoker(CXCXXMethodDecl CXXMD);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase);

CINDEX_LINKAGE CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase);

// CXXCtorInitializer

// InheritedConstructor

// CXXConstructorDecl

// CXXDestructorDecl

// CXXConversionDecl

// LinkageSpecDecl
typedef enum CXLinkageSpecDecl_LanguageIDs {
  CXLinkageSpecDecl_lang_c = 1,
  CXLinkageSpecDecl_lang_cxx = 2
} CXLinkageSpecDecl_LanguageIDs;

CINDEX_LINKAGE CXLinkageSpecDecl clang_LinkageSpecDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ ExternLoc,
    CXSourceLocation_ LangLoc, CXLinkageSpecDecl_LanguageIDs Lang, bool HasBraces);

CINDEX_LINKAGE CXLinkageSpecDecl clang_LinkageSpecDecl_CreateDeserialized(CXASTContext C,
                                                                          unsigned ID);

CINDEX_LINKAGE CXLinkageSpecDecl_LanguageIDs
clang_LinkageSpecDecl_getLanguage(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE void clang_LinkageSpecDecl_setLanguage(CXLinkageSpecDecl LSD,
                                                      CXLinkageSpecDecl_LanguageIDs Lang);

CINDEX_LINKAGE bool clang_LinkageSpecDecl_hasBraces(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE CXSourceLocation_ clang_LinkageSpecDecl_getExternLoc(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE CXSourceLocation_ clang_LinkageSpecDecl_getRBraceLoc(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE void clang_LinkageSpecDecl_setExternLoc(CXLinkageSpecDecl LSD,
                                                       CXSourceLocation_ Loc);

CINDEX_LINKAGE void clang_LinkageSpecDecl_setRBraceLoc(CXLinkageSpecDecl LSD,
                                                       CXSourceLocation_ Loc);

CINDEX_LINKAGE CXSourceLocation_ clang_LinkageSpecDecl_getEndLoc(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE CXSourceRange_ clang_LinkageSpecDecl_getSourceRange(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE CXDeclContext clang_LinkageSpecDecl_castToDeclContext(CXLinkageSpecDecl LSD);

CINDEX_LINKAGE CXLinkageSpecDecl
clang_LinkageSpecDecl_castFromDeclContext(CXDeclContext DC);

#ifdef __cplusplus
}
#endif
#endif
