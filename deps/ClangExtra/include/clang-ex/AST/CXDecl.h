#ifndef LIBCLANGEX_CXDECL_H
#define LIBCLANGEX_CXDECL_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXExceptionSpecificationType.h"
#include "clang-ex/Basic/CXLinkage.h"
#include "clang-ex/Basic/CXPragmaKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXVisibility.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

#ifdef __cplusplus
extern "C" {
#endif

// TranslationUnitDecl
CINDEX_LINKAGE CXASTContext
clang_TranslationUnitDecl_getASTContext(CXTranslationUnitDecl TUD);

CINDEX_LINKAGE CXNamespaceDecl
clang_TranslationUnitDecl_getAnonymousNamespace(CXTranslationUnitDecl TUD);

CINDEX_LINKAGE void
clang_TranslationUnitDecl_setAnonymousNamespace(CXTranslationUnitDecl TUD,
                                                CXNamespaceDecl ND);

CINDEX_LINKAGE CXTranslationUnitDecl
clang_TranslationUnitDecl_Create(CXTranslationUnitDecl TUD, CXASTContext C);

// PragmaCommentDecl
CINDEX_LINKAGE CXPragmaCommentDecl clang_PragmaCommentDecl_Create(
    CXASTContext C, CXTranslationUnitDecl DC, CXSourceLocation_ CommentLoc,
    CXPragmaMSCommentKind CommentKind, const char *Arg);

CINDEX_LINKAGE CXPragmaCommentDecl
clang_PragmaCommentDecl_CreateDeserialized(CXASTContext C, unsigned ID, unsigned ArgSize);

CINDEX_LINKAGE CXPragmaMSCommentKind
clang_PragmaCommentDecl_getCommentKind(CXPragmaCommentDecl PCD);

CINDEX_LINKAGE const char *clang_PragmaCommentDecl_getArg(CXPragmaCommentDecl PCD);

// PragmaDetectMismatchDecl
CINDEX_LINKAGE CXPragmaDetectMismatchDecl clang_PragmaDetectMismatchDecl_Create(
    CXASTContext C, CXTranslationUnitDecl DC, CXSourceLocation_ Loc, const char *Name,
    const char *Value);

CINDEX_LINKAGE CXPragmaDetectMismatchDecl clang_PragmaDetectMismatchDecl_CreateDeserialized(
    CXASTContext C, unsigned ID, unsigned NameValueSize);

CINDEX_LINKAGE const char *
clang_PragmaDetectMismatchDecl_getName(CXPragmaDetectMismatchDecl PDMD);

CINDEX_LINKAGE const char *
clang_PragmaDetectMismatchDecl_getValue(CXPragmaDetectMismatchDecl PDMD);

// ExternCContextDecl
CINDEX_LINKAGE CXExternCContextDecl
clang_ExternCContextDecl_Create(CXASTContext C, CXTranslationUnitDecl TU);

// NamedDecl
CINDEX_LINKAGE CXIdentifierInfo clang_NamedDecl_getIdentifier(CXNamedDecl ND);

CINDEX_LINKAGE const char *clang_NamedDecl_getName(CXNamedDecl ND);

CINDEX_LINKAGE CXDeclarationName clang_NamedDecl_getDeclName(CXNamedDecl ND);

CINDEX_LINKAGE void clang_NamedDecl_setDeclName(CXNamedDecl ND, CXDeclarationName DN);

CINDEX_LINKAGE bool clang_NamedDecl_declarationReplaces(CXNamedDecl ND, CXNamedDecl OldD,
                                                        bool IsKnownNewer);

CINDEX_LINKAGE bool clang_NamedDecl_hasLinkage(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_isCXXClassMember(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_isCXXInstanceMember(CXNamedDecl ND);

CINDEX_LINKAGE CXLinkage clang_NamedDecl_getLinkageInternal(CXNamedDecl ND);

CINDEX_LINKAGE CXLinkage clang_NamedDecl_getFormalLinkage(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_hasExternalFormalLinkage(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_isExternallyVisible(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_isExternallyDeclarable(CXNamedDecl ND);

CINDEX_LINKAGE CXVisibility clang_NamedDecl_getVisibility(CXNamedDecl ND);

// getLinkageAndVisibility
// getExplicitVisibility

CINDEX_LINKAGE bool clang_NamedDecl_isLinkageValid(CXNamedDecl ND);

CINDEX_LINKAGE bool clang_NamedDecl_hasLinkageBeenComputed(CXNamedDecl ND);

CINDEX_LINKAGE CXNamedDecl clang_NamedDecl_getUnderlyingDecl(CXNamedDecl ND);

CINDEX_LINKAGE CXNamedDecl clang_NamedDecl_getMostRecentDecl(CXNamedDecl ND);

// getObjCFStringFormattingFamily

// NamedDecl Cast
CINDEX_LINKAGE CXTypeDecl clang_NamedDecl_castToTypeDecl(CXNamedDecl ND);

// LabelDecl
CINDEX_LINKAGE CXLabelDecl clang_LabelDecl_Create(CXASTContext C, CXDeclContext DC,
                                                  CXSourceLocation_ IdentL,
                                                  CXIdentifierInfo II);

CINDEX_LINKAGE CXLabelDecl clang_LabelDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE CXLabelStmt clang_LabelDecl_getStmt(CXLabelDecl LD);

CINDEX_LINKAGE void clang_LabelDecl_setStmt(CXLabelDecl LD, CXLabelStmt T);

CINDEX_LINKAGE bool clang_LabelDecl_isGnuLocal(CXLabelDecl LD);

CINDEX_LINKAGE void clang_LabelDecl_setLocStart(CXLabelDecl LD, CXSourceLocation_ Loc);

CINDEX_LINKAGE CXSourceRange_ clang_LabelDecl_getSourceRange(CXLabelDecl LD);

CINDEX_LINKAGE bool clang_LabelDecl_isMSAsmLabel(CXLabelDecl LD);

CINDEX_LINKAGE bool clang_LabelDecl_isResolvedMSAsmLabel(CXLabelDecl LD);

// setMSAsmLabel

CINDEX_LINKAGE const char *clang_LabelDecl_getMSAsmLabel(CXLabelDecl LD);

CINDEX_LINKAGE void clang_LabelDecl_setMSAsmLabelResolved(CXLabelDecl LD);

// NamespaceDecl
CINDEX_LINKAGE CXNamespaceDecl clang_NamespaceDecl_Create(
    CXASTContext C, CXDeclContext DC, bool Inline, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXNamespaceDecl PrevDecl);

CINDEX_LINKAGE CXNamespaceDecl clang_NamespaceDecl_CreateDeserialized(CXASTContext C,
                                                                      unsigned ID);

CINDEX_LINKAGE bool clang_NamespaceDecl_isAnonymousNamespace(CXNamespaceDecl ND);

CINDEX_LINKAGE bool clang_NamespaceDecl_isInline(CXNamespaceDecl ND);

CINDEX_LINKAGE void clang_NamespaceDecl_setInline(CXNamespaceDecl ND, bool Inline);

CINDEX_LINKAGE CXNamespaceDecl clang_NamespaceDecl_getOriginalNamespace(CXNamespaceDecl ND);

CINDEX_LINKAGE bool clang_NamespaceDecl_isOriginalNamespace(CXNamespaceDecl ND);

CINDEX_LINKAGE CXNamespaceDecl
clang_NamespaceDecl_getAnonymousNamespace(CXNamespaceDecl ND);

CINDEX_LINKAGE void clang_NamespaceDecl_setAnonymousNamespace(CXNamespaceDecl ND,
                                                              CXNamespaceDecl D);

CINDEX_LINKAGE CXNamespaceDecl clang_NamespaceDecl_getCanonicalDecl(CXNamespaceDecl ND);

CINDEX_LINKAGE CXSourceRange_ clang_NamespaceDecl_getSourceRange(CXNamespaceDecl ND);

CINDEX_LINKAGE CXSourceLocation_ clang_NamespaceDecl_getBeginLoc(CXNamespaceDecl ND);

CINDEX_LINKAGE CXSourceLocation_ clang_NamespaceDecl_getRBraceLoc(CXNamespaceDecl ND);

CINDEX_LINKAGE void clang_NamespaceDecl_setLocStart(CXNamespaceDecl ND,
                                                    CXSourceLocation_ Loc);

CINDEX_LINKAGE void clang_NamespaceDecl_setRBraceLoc(CXNamespaceDecl ND,
                                                     CXSourceLocation_ Loc);

// ValueDecl
CINDEX_LINKAGE CXQualType clang_ValueDecl_getType(CXValueDecl VD);

CINDEX_LINKAGE void clang_ValueDecl_setType(CXValueDecl VD, CXQualType OpaquePtr);

CINDEX_LINKAGE bool clang_ValueDecl_isWeak(CXValueDecl VD);

// DeclaratorDecl
CINDEX_LINKAGE CXTypeSourceInfo clang_DeclaratorDecl_getTypeSourceInfo(CXDeclaratorDecl DD);

CINDEX_LINKAGE void clang_DeclaratorDecl_setTypeSourceInfo(CXDeclaratorDecl DD,
                                                           CXTypeSourceInfo TI);

CINDEX_LINKAGE CXSourceLocation_ clang_DeclaratorDecl_getInnerLocStart(CXDeclaratorDecl DD);

CINDEX_LINKAGE void clang_DeclaratorDecl_setInnerLocStart(CXDeclaratorDecl DD,
                                                          CXSourceLocation_ Loc);

CINDEX_LINKAGE CXSourceLocation_ clang_DeclaratorDecl_getOuterLocStart(CXDeclaratorDecl DD);

CINDEX_LINKAGE CXSourceLocation_ clang_DeclaratorDecl_getBeginLoc(CXDeclaratorDecl DD);

CINDEX_LINKAGE CXNestedNameSpecifier clang_DeclaratorDecl_getQualifier(CXDeclaratorDecl DD);

// getQualifierLoc
// setQualifierInfo

CINDEX_LINKAGE CXExpr clang_DeclaratorDecl_getTrailingRequiresClause(CXDeclaratorDecl DD);

CINDEX_LINKAGE void
clang_DeclaratorDecl_setTrailingRequiresClause(CXDeclaratorDecl DD,
                                               CXExpr TrailingRequiresClause);

CINDEX_LINKAGE unsigned
clang_DeclaratorDecl_getNumTemplateParameterLists(CXDeclaratorDecl DD);

CINDEX_LINKAGE CXTemplateParameterList
clang_DeclaratorDecl_getTemplateParameterList(CXDeclaratorDecl DD, unsigned index);

// setTemplateParameterListsInfo

CINDEX_LINKAGE CXSourceLocation_
clang_DeclaratorDecl_getTypeSpecStartLoc(CXDeclaratorDecl DD);

CINDEX_LINKAGE CXSourceLocation_
clang_DeclaratorDecl_getTypeSpecEndLoc(CXDeclaratorDecl DD);

// VarDecl
CINDEX_LINKAGE CXVarDecl clang_VarDecl_Create(CXASTContext C, CXDeclContext DC,
                                              CXSourceLocation_ StartLoc,
                                              CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                              CXQualType T, CXTypeSourceInfo TInfo,
                                              CXStorageClass S);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE CXSourceRange_ clang_VarDecl_getSourceRange(CXVarDecl VD);

CINDEX_LINKAGE CXStorageClass clang_VarDecl_getStorageClass(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setStorageClass(CXVarDecl VD, CXStorageClass SC);

CINDEX_LINKAGE void clang_VarDecl_setTSCSpec(CXVarDecl VD,
                                             CXThreadStorageClassSpecifier TSC);

CINDEX_LINKAGE CXThreadStorageClassSpecifier clang_VarDecl_getTSCSpec(CXVarDecl VD);

// getTLSKind

CINDEX_LINKAGE bool clang_VarDecl_hasLocalStorage(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isStaticLocal(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_hasExternalStorage(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_hasGlobalStorage(CXVarDecl VD);

CINDEX_LINKAGE CXStorageDuration clang_VarDecl_getStorageDuration(CXVarDecl VD);

CINDEX_LINKAGE CXLanguageLinkage clang_VarDecl_getLanguageLinkage(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isExternC(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isInExternCContext(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isInExternCXXContext(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isLocalVarDecl(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isLocalVarDeclOrParm(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isFunctionOrMethodVarDecl(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isStaticDataMember(CXVarDecl VD);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getCanonicalDecl(CXVarDecl VD);

// isThisDeclarationADefinition
// hasDefinition

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getActingDefinition(CXVarDecl VD);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getDefinition(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isOutOfLine(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isFileVarDecl(CXVarDecl VD);

CINDEX_LINKAGE CXExpr clang_VarDecl_getAnyInitializer(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_hasInit(CXVarDecl VD);

CINDEX_LINKAGE CXExpr clang_VarDecl_getInit(CXVarDecl VD);

// getInitAddress

CINDEX_LINKAGE void clang_VarDecl_setInit(CXVarDecl VD, CXExpr I);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getInitializingDeclaration(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_mightBeUsableInConstantExpressions(CXVarDecl VD,
                                                                     CXASTContext C);

CINDEX_LINKAGE bool clang_VarDecl_isUsableInConstantExpressions(CXVarDecl VD,
                                                                CXASTContext C);

CINDEX_LINKAGE CXEvaluatedStmt clang_VarDecl_ensureEvaluatedStmt(CXVarDecl VD);

CINDEX_LINKAGE CXEvaluatedStmt clang_VarDecl_getEvaluatedStmt(CXVarDecl VD);

// evaluateValue
// getEvaluatedValue
// evaluateDestruction

CINDEX_LINKAGE bool clang_VarDecl_hasConstantInitialization(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_hasICEInitializer(CXVarDecl VD, CXASTContext Context);

// checkForConstantInitialization
// setInitStyle
// getInitStyle

CINDEX_LINKAGE bool clang_VarDecl_isDirectInit(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isThisDeclarationADemotedDefinition(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_demoteThisDefinitionToDeclaration(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isExceptionVariable(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setExceptionVariable(CXVarDecl VD, bool EV);

CINDEX_LINKAGE bool clang_VarDecl_isNRVOVariable(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setNRVOVariable(CXVarDecl VD, bool NRVO);

CINDEX_LINKAGE bool clang_VarDecl_isCXXForRangeDecl(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setCXXForRangeDecl(CXVarDecl VD, bool FRD);

CINDEX_LINKAGE bool clang_VarDecl_isObjCForDecl(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setObjCForDecl(CXVarDecl VD, bool FRD);

CINDEX_LINKAGE bool clang_VarDecl_isARCPseudoStrong(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setARCPseudoStrong(CXVarDecl VD, bool PS);

CINDEX_LINKAGE bool clang_VarDecl_isInline(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isInlineSpecified(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setInlineSpecified(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setImplicitlyInline(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isConstexpr(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setConstexpr(CXVarDecl VD, bool IC);

CINDEX_LINKAGE bool clang_VarDecl_isInitCapture(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setInitCapture(CXVarDecl VD, bool IC);

CINDEX_LINKAGE bool clang_VarDecl_isParameterPack(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isPreviousDeclInSameBlockScope(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setPreviousDeclInSameBlockScope(CXVarDecl VD, bool Same);

CINDEX_LINKAGE bool clang_VarDecl_isEscapingByref(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isNonEscapingByref(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setEscapingByref(CXVarDecl VD);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getTemplateInstantiationPattern(CXVarDecl VD);

CINDEX_LINKAGE CXVarDecl clang_VarDecl_getInstantiatedFromStaticDataMember(CXVarDecl VD);

CINDEX_LINKAGE CXTemplateSpecializationKind
clang_VarDecl_getTemplateSpecializationKind(CXVarDecl VD);

CINDEX_LINKAGE CXTemplateSpecializationKind
clang_VarDecl_getTemplateSpecializationKindForInstantiation(CXVarDecl VD);

CINDEX_LINKAGE CXSourceLocation_ clang_VarDecl_getPointOfInstantiation(CXVarDecl VD);

// getMemberSpecializationInfo

CINDEX_LINKAGE void
clang_VarDecl_setTemplateSpecializationKind(CXVarDecl VD, CXTemplateSpecializationKind TSK,
                                            CXSourceLocation_ PointOfInstantiation);

CINDEX_LINKAGE void
clang_VarDecl_setInstantiationOfStaticDataMember(CXVarDecl VD, CXVarDecl VD2,
                                                 CXTemplateSpecializationKind TSK);

CINDEX_LINKAGE CXVarTemplateDecl clang_VarDecl_getDescribedVarTemplate(CXVarDecl VD);

CINDEX_LINKAGE void clang_VarDecl_setDescribedVarTemplate(CXVarDecl VD,
                                                          CXVarTemplateDecl Template);

CINDEX_LINKAGE bool clang_VarDecl_isKnownToBeDefined(CXVarDecl VD);

CINDEX_LINKAGE bool clang_VarDecl_isNoDestroy(CXVarDecl VD, CXASTContext AST);

// needsDestruction

// ImplicitParamDecl
typedef enum CXImplicitParamDecl_ImplicitParamKind : unsigned {
  CXImplicitParamDecl_ObjCSelf,
  CXImplicitParamDecl_ObjCCmd,
  CXImplicitParamDecl_CXXThis,
  CXImplicitParamDecl_CXXVTT,
  CXImplicitParamDecl_CapturedContext,
  CXImplicitParamDecl_Other,
} CXImplicitParamDecl_ImplicitParamKind;

CXImplicitParamDecl
clang_ImplicitParamDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ IdLoc,
                               CXIdentifierInfo Id, CXQualType T,
                               CXImplicitParamDecl_ImplicitParamKind ParamKind);

CINDEX_LINKAGE CXImplicitParamDecl
clang_ImplicitParamDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE CXImplicitParamDecl_ImplicitParamKind
clang_ImplicitParamDecl_getParameterKind(CXImplicitParamDecl IPD);

// ParmVarDecl
CINDEX_LINKAGE CXParmVarDecl clang_ParmVarDecl_Create(CXASTContext C, CXDeclContext DC,
                                                      CXSourceLocation_ StartLoc,
                                                      CXSourceLocation_ IdLoc,
                                                      CXIdentifierInfo Id, CXQualType T,
                                                      CXTypeSourceInfo TInfo,
                                                      CXStorageClass S, CXExpr DefArg);

CINDEX_LINKAGE CXParmVarDecl clang_ParmVarDecl_CreateDeserialized(CXASTContext C,
                                                                  unsigned ID);

CINDEX_LINKAGE void clang_ParmVarDecl_setObjCMethodScopeInfo(CXParmVarDecl PVD,
                                                             unsigned parameterIndex);

CINDEX_LINKAGE void clang_ParmVarDecl_setScopeInfo(CXParmVarDecl PVD, unsigned scopeDepth,
                                                   unsigned parameterIndex);

CINDEX_LINKAGE bool clang_ParmVarDecl_isObjCMethodParameter(CXParmVarDecl PVD);

CINDEX_LINKAGE bool clang_ParmVarDecl_isDestroyedInCallee(CXParmVarDecl PVD);

CINDEX_LINKAGE unsigned clang_ParmVarDecl_getFunctionScopeDepth(CXParmVarDecl PVD);

CINDEX_LINKAGE unsigned clang_ParmVarDecl_getFunctionScopeIndex(CXParmVarDecl PVD);

// getObjCDeclQualifier
// setObjCDeclQualifier

CINDEX_LINKAGE bool clang_ParmVarDecl_isKNRPromoted(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setKNRPromoted(CXParmVarDecl PVD, bool promoted);

CINDEX_LINKAGE CXExpr clang_ParmVarDecl_getDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setDefaultArg(CXParmVarDecl PVD, CXExpr defarg);

CINDEX_LINKAGE CXSourceRange_ clang_ParmVarDecl_getDefaultArgRange(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setUninstantiatedDefaultArg(CXParmVarDecl PVD,
                                                                  CXExpr arg);

CINDEX_LINKAGE CXExpr clang_ParmVarDecl_getUninstantiatedDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE bool clang_ParmVarDecl_hasDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE bool clang_ParmVarDecl_hasUnparsedDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE bool clang_ParmVarDecl_hasUninstantiatedDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setUnparsedDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE bool clang_ParmVarDecl_hasInheritedDefaultArg(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setHasInheritedDefaultArg(CXParmVarDecl PVD, bool I);

CINDEX_LINKAGE CXQualType clang_ParmVarDecl_getOriginalType(CXParmVarDecl PVD);

CINDEX_LINKAGE void clang_ParmVarDecl_setOwningFunction(CXParmVarDecl PVD,
                                                        CXDeclContext FD);

// MultiVersionKind
typedef enum CXMultiVersionKind {
  CXMultiVersionKind_None,
  CXMultiVersionKind_Target,
  CXMultiVersionKind_CPUSpecific,
  CXMultiVersionKind_CPUDispatch
} CXMultiVersionKind;

// FunctionDecl
typedef enum CXFunctionDecl_TemplatedKind {
  CXFunctionDecl_TK_NonTemplate,
  CXFunctionDecl_TK_FunctionTemplate,
  CXFunctionDecl_TK_MemberSpecialization,
  CXFunctionDecl_TK_FunctionTemplateSpecialization,
  CXFunctionDecl_TK_DependentFunctionTemplateSpecialization
} CXFunctionDecl_TemplatedKind;

typedef void *CXFunctionDecl_DefaultedFunctionInfo;

CINDEX_LINKAGE CXFunctionDecl clang_FunctionDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc, CXSourceLocation_ NLoc,
    CXDeclarationName N, CXQualType T, CXTypeSourceInfo TInfo, CXStorageClass SC,
    bool isInlineSpecified, bool hasWrittenPrototype);

CINDEX_LINKAGE CXFunctionDecl clang_FunctionDecl_CreateDeserialized(CXASTContext C,
                                                                    unsigned ID);

// getNameInfo
// getNameForDiagnostic

CINDEX_LINKAGE void clang_FunctionDecl_setRangeEnd(CXFunctionDecl FD,
                                                   CXSourceLocation_ Loc);

CINDEX_LINKAGE CXSourceLocation_ clang_FunctionDecl_getEllipsisLoc(CXFunctionDecl FD);

CINDEX_LINKAGE CXSourceRange_ clang_FunctionDecl_getSourceRange(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasBody(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasTrivialBody(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isDefined(CXFunctionDecl FD);

CINDEX_LINKAGE CXFunctionDecl clang_FunctionDecl_getDefinition(CXFunctionDecl FD);

CINDEX_LINKAGE CXStmt clang_FunctionDecl_getBody(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isThisDeclarationADefinition(CXFunctionDecl FD);

CINDEX_LINKAGE bool
clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_doesThisDeclarationHaveABody(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setBody(CXFunctionDecl FD, CXStmt B);

CINDEX_LINKAGE void clang_FunctionDecl_setLazyBody(CXFunctionDecl FD, uint64_t Offset);

CINDEX_LINKAGE void
clang_FunctionDecl_setDefaultedFunctionInfo(CXFunctionDecl FD,
                                            CXFunctionDecl_DefaultedFunctionInfo Info);

CINDEX_LINKAGE bool clang_FunctionDecl_isVariadic(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isVirtualAsWritten(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setVirtualAsWritten(CXFunctionDecl FD, bool V);

CINDEX_LINKAGE bool clang_FunctionDecl_isPure(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setPure(CXFunctionDecl FD, bool P);

CINDEX_LINKAGE bool clang_FunctionDecl_isLateTemplateParsed(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setLateTemplateParsed(CXFunctionDecl FD, bool ILT);

CINDEX_LINKAGE bool clang_FunctionDecl_isTrivial(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setTrivial(CXFunctionDecl FD, bool IT);

CINDEX_LINKAGE bool clang_FunctionDecl_isTrivialForCall(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setTrivialForCall(CXFunctionDecl FD, bool IT);

CINDEX_LINKAGE bool clang_FunctionDecl_isDefaulted(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setDefaulted(CXFunctionDecl FD, bool D);

CINDEX_LINKAGE bool clang_FunctionDecl_isExplicitlyDefaulted(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setExplicitlyDefaulted(CXFunctionDecl FD, bool ED);

CINDEX_LINKAGE bool clang_FunctionDecl_isUserProvided(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasImplicitReturnZero(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setHasImplicitReturnZero(CXFunctionDecl FD,
                                                                bool IRZ);

CINDEX_LINKAGE bool clang_FunctionDecl_hasPrototype(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasWrittenPrototype(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setHasWrittenPrototype(CXFunctionDecl FD, bool P);

CINDEX_LINKAGE bool clang_FunctionDecl_hasInheritedPrototype(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setHasInheritedPrototype(CXFunctionDecl FD, bool P);

CINDEX_LINKAGE bool clang_FunctionDecl_isConstexpr(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setConstexprKind(CXFunctionDecl FD,
                                                        CXConstexprSpecKind CSK);

CINDEX_LINKAGE CXConstexprSpecKind clang_FunctionDecl_getConstexprKind(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isConstexprSpecified(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isConsteval(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_instantiationIsPending(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setInstantiationIsPending(CXFunctionDecl FD,
                                                                 bool IC);

CINDEX_LINKAGE bool clang_FunctionDecl_usesSEHTry(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setUsesSEHTry(CXFunctionDecl FD, bool UST);

CINDEX_LINKAGE bool clang_FunctionDecl_isDeleted(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isDeletedAsWritten(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setDeletedAsWritten(CXFunctionDecl FD, bool D);

CINDEX_LINKAGE bool clang_FunctionDecl_isMain(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isMSVCRTEntryPoint(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isReservedGlobalPlacementOperator(CXFunctionDecl FD);

CINDEX_LINKAGE bool
clang_FunctionDecl_isReplaceableGlobalAllocationFunction(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isInlineBuiltinDeclaration(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isDestroyingOperatorDelete(CXFunctionDecl FD);

CINDEX_LINKAGE CXLanguageLinkage clang_FunctionDecl_getLanguageLinkage(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isExternC(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isInExternCContext(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isInExternCXXContext(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isGlobal(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isNoReturn(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasSkippedBody(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setHasSkippedBody(CXFunctionDecl FD, bool Skipped);

CINDEX_LINKAGE bool clang_FunctionDecl_willHaveBody(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setWillHaveBody(CXFunctionDecl FD, bool V);

CINDEX_LINKAGE bool clang_FunctionDecl_isMultiVersion(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setIsMultiVersion(CXFunctionDecl FD, bool V);

CINDEX_LINKAGE CXMultiVersionKind clang_FunctionDecl_getMultiVersionKind(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isCPUDispatchMultiVersion(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isCPUSpecificMultiVersion(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isTargetMultiVersion(CXFunctionDecl FD);

// getAssociatedConstraints

CINDEX_LINKAGE void clang_FunctionDecl_setPreviousDeclaration(CXFunctionDecl FD,
                                                              CXFunctionDecl PrevDecl);

CINDEX_LINKAGE CXFunctionDecl clang_FunctionDecl_getCanonicalDecl(CXFunctionDecl FD);

CINDEX_LINKAGE unsigned clang_FunctionDecl_getBuiltinID(CXFunctionDecl FD);

// parameters

CINDEX_LINKAGE unsigned clang_FunctionDecl_getNumParams(CXFunctionDecl FD);

CINDEX_LINKAGE CXParmVarDecl clang_FunctionDecl_getParamDecl(CXFunctionDecl FD, unsigned i);

// setParams

CINDEX_LINKAGE unsigned clang_FunctionDecl_getMinRequiredArguments(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_hasOneParamOrDefaultArgs(CXFunctionDecl FD);

// getFunctionTypeLoc

CINDEX_LINKAGE CXQualType clang_FunctionDecl_getReturnType(CXFunctionDecl FD);

CINDEX_LINKAGE CXSourceRange_
clang_FunctionDecl_getReturnTypeSourceRange(CXFunctionDecl FD);

CINDEX_LINKAGE CXSourceRange_
clang_FunctionDecl_getParametersSourceRange(CXFunctionDecl FD);

CINDEX_LINKAGE CXQualType clang_FunctionDecl_getDeclaredReturnType(CXFunctionDecl FD);

CINDEX_LINKAGE CXExceptionSpecificationType
clang_FunctionDecl_getExceptionSpecType(CXFunctionDecl FD);

CINDEX_LINKAGE CXSourceRange_
clang_FunctionDecl_getExceptionSpecSourceRange(CXFunctionDecl FD);

CINDEX_LINKAGE CXQualType clang_FunctionDecl_getCallResultType(CXFunctionDecl FD);

CINDEX_LINKAGE CXStorageClass clang_FunctionDecl_getStorageClass(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setStorageClass(CXFunctionDecl FD,
                                                       CXStorageClass SClass);

CINDEX_LINKAGE bool clang_FunctionDecl_isInlineSpecified(CXFunctionDecl FD);

CINDEX_LINKAGE void clang_FunctionDecl_setInlineSpecified(CXFunctionDecl FD, bool I);

CINDEX_LINKAGE void clang_FunctionDecl_setImplicitlyInline(CXFunctionDecl FD, bool I);

CINDEX_LINKAGE bool clang_FunctionDecl_isInlined(CXFunctionDecl FD);

CINDEX_LINKAGE bool
clang_FunctionDecl_isInlineDefinitionExternallyVisible(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isMSExternInline(CXFunctionDecl FD);

CINDEX_LINKAGE bool
clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isStatic(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isOverloadedOperator(CXFunctionDecl FD);

// getOverloadedOperator

CINDEX_LINKAGE CXIdentifierInfo clang_FunctionDecl_getLiteralIdentifier(CXFunctionDecl FD);

CINDEX_LINKAGE CXFunctionDecl_TemplatedKind
clang_FunctionDecl_getTemplatedKind(CXFunctionDecl FD);

CINDEX_LINKAGE CXMemberSpecializationInfo
clang_FunctionDecl_getMemberSpecializationInfo(CXFunctionDecl FD);

CINDEX_LINKAGE void
clang_FunctionDecl_setInstantiationOfMemberFunction(CXFunctionDecl FD, CXFunctionDecl FD2,
                                                    CXTemplateSpecializationKind TSK);

CINDEX_LINKAGE CXFunctionTemplateDecl
clang_FunctionDecl_getDescribedFunctionTemplate(CXFunctionDecl FD);

CINDEX_LINKAGE void
clang_FunctionDecl_setDescribedFunctionTemplate(CXFunctionDecl FD,
                                                CXFunctionTemplateDecl Template);

CINDEX_LINKAGE CXFunctionDecl
clang_FunctionDecl_getInstantiatedFromMemberFunction(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isFunctionTemplateSpecialization(CXFunctionDecl FD);

CINDEX_LINKAGE CXFunctionTemplateSpecializationInfo
clang_FunctionDecl_getTemplateSpecializationInfo(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isImplicitlyInstantiable(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isTemplateInstantiation(CXFunctionDecl FD);

CINDEX_LINKAGE CXFunctionDecl
clang_FunctionDecl_getTemplateInstantiationPattern(CXFunctionDecl FD, bool ForDefinition);

CINDEX_LINKAGE CXFunctionTemplateDecl
clang_FunctionDecl_getPrimaryTemplate(CXFunctionDecl FD);

CINDEX_LINKAGE CXTemplateArgumentList
clang_FunctionDecl_getTemplateSpecializationArgs(CXFunctionDecl FD);

CINDEX_LINKAGE CXASTTemplateArgumentListInfo
clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(CXFunctionDecl FD);

// setFunctionTemplateSpecialization
// setDependentTemplateSpecialization

CINDEX_LINKAGE CXDependentFunctionTemplateSpecializationInfo
clang_FunctionDecl_getDependentSpecializationInfo(CXFunctionDecl FD);

CINDEX_LINKAGE CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKind(CXFunctionDecl FD);

CINDEX_LINKAGE CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(CXFunctionDecl FD);

CINDEX_LINKAGE void
clang_FunctionDecl_setTemplateSpecializationKind(CXFunctionDecl FD,
                                                 CXTemplateSpecializationKind TSK,
                                                 CXSourceLocation_ PointOfInstantiation);

CINDEX_LINKAGE CXSourceLocation_
clang_FunctionDecl_getPointOfInstantiation(CXFunctionDecl FD);

CINDEX_LINKAGE bool clang_FunctionDecl_isOutOfLine(CXFunctionDecl FD);

CINDEX_LINKAGE unsigned clang_FunctionDecl_getMemoryFunctionKind(CXFunctionDecl FD);

CINDEX_LINKAGE unsigned clang_FunctionDecl_getODRHash(CXFunctionDecl FD);

// FieldDecl
CINDEX_LINKAGE CXFieldDecl clang_FieldDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
    CXIdentifierInfo I, CXQualType T, CXTypeSourceInfo TInfo, CXExpr BW, bool Mutable,
    CXInClassInitStyle InitStyle);

CINDEX_LINKAGE CXFieldDecl clang_FieldDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE unsigned clang_FieldDecl_getFieldIndex(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_isMutable(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_isBitField(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_isUnnamedBitfield(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_isAnonymousStructOrUnion(CXFieldDecl FD);

CINDEX_LINKAGE CXExpr clang_FieldDecl_getBitWidth(CXFieldDecl FD);

CINDEX_LINKAGE unsigned clang_FieldDecl_getBitWidthValue(CXFieldDecl FD, CXASTContext Ctx);

CINDEX_LINKAGE void clang_FieldDecl_setBitWidth(CXFieldDecl FD, CXExpr Width);

CINDEX_LINKAGE void clang_FieldDecl_removeBitWidth(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_isZeroLengthBitField(CXFieldDecl FD, CXASTContext Ctx);

CINDEX_LINKAGE bool clang_FieldDecl_isZeroSize(CXFieldDecl FD, CXASTContext Ctx);

CINDEX_LINKAGE CXInClassInitStyle clang_FieldDecl_getInClassInitStyle(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_hasInClassInitializer(CXFieldDecl FD);

CINDEX_LINKAGE CXExpr clang_FieldDecl_getInClassInitializer(CXFieldDecl FD);

CINDEX_LINKAGE void clang_FieldDecl_setInClassInitializer(CXFieldDecl FD, CXExpr Init);

CINDEX_LINKAGE void clang_FieldDecl_removeInClassInitializer(CXFieldDecl FD);

CINDEX_LINKAGE bool clang_FieldDecl_hasCapturedVLAType(CXFieldDecl FD);

CINDEX_LINKAGE CXVariableArrayType clang_FieldDecl_getCapturedVLAType(CXFieldDecl FD);

CINDEX_LINKAGE void clang_FieldDecl_setCapturedVLAType(CXFieldDecl FD,
                                                       CXVariableArrayType VLAType);

CINDEX_LINKAGE CXRecordDecl clang_FieldDecl_getParent(CXFieldDecl FD);

CINDEX_LINKAGE CXSourceRange_ clang_FieldDecl_getSourceRange(CXFieldDecl FD);

CINDEX_LINKAGE CXFieldDecl clang_FieldDecl_getCanonicalDecl(CXFieldDecl FD);

// EnumConstantDecl
CINDEX_LINKAGE CXEnumConstantDecl clang_EnumConstantDecl_Create(
    CXASTContext C, CXEnumDecl DC, CXSourceLocation_ L, CXIdentifierInfo Id, CXQualType T,
    CXExpr E, LLVMGenericValueRef V);

CINDEX_LINKAGE CXEnumConstantDecl clang_EnumConstantDecl_CreateDeserialized(CXASTContext C,
                                                                            unsigned ID);

CINDEX_LINKAGE CXExpr clang_EnumConstantDecl_getInitExpr(CXEnumConstantDecl ECD);

// getInitVal

CINDEX_LINKAGE void clang_EnumConstantDecl_setInitExpr(CXEnumConstantDecl ECD, CXExpr E);

// setInitVal

CINDEX_LINKAGE CXSourceRange_ clang_EnumConstantDecl_getSourceRange(CXEnumConstantDecl ECD);

CINDEX_LINKAGE CXEnumConstantDecl
clang_EnumConstantDecl_getCanonicalDecl(CXEnumConstantDecl ECD);

// IndirectFieldDecl
CINDEX_LINKAGE CXIndirectFieldDecl
clang_IndirectFieldDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// chain

CINDEX_LINKAGE unsigned clang_IndirectFieldDecl_getChainingSize(CXIndirectFieldDecl IFD);

CINDEX_LINKAGE CXFieldDecl clang_IndirectFieldDecl_getAnonField(CXIndirectFieldDecl IFD);

CINDEX_LINKAGE CXVarDecl clang_IndirectFieldDecl_getVarDecl(CXIndirectFieldDecl IFD);

CINDEX_LINKAGE CXIndirectFieldDecl
clang_IndirectFieldDecl_getCanonicalDecl(CXIndirectFieldDecl IFD);

// TypeDecl
CINDEX_LINKAGE CXType_ clang_TypeDecl_getTypeForDecl(CXTypeDecl TD);

CINDEX_LINKAGE void clang_TypeDecl_setTypeForDecl(CXTypeDecl TD, CXType_ Ty);

CINDEX_LINKAGE CXSourceLocation_ clang_TypeDecl_getBeginLoc(CXTypeDecl TD);

CINDEX_LINKAGE void clang_TypeDecl_setLocStart(CXTypeDecl TD, CXSourceLocation_ Loc);

// TypedefNameDecl
CINDEX_LINKAGE bool clang_TypedefNameDecl_isModed(CXTypedefNameDecl TND);

CINDEX_LINKAGE CXTypeSourceInfo
clang_TypedefNameDecl_getTypeSourceInfo(CXTypedefNameDecl TND);

CINDEX_LINKAGE CXQualType clang_TypedefNameDecl_getUnderlyingType(CXTypedefNameDecl TND);

CINDEX_LINKAGE void clang_TypedefNameDecl_setTypeSourceInfo(CXTypedefNameDecl TND,
                                                            CXTypeSourceInfo newType);
CINDEX_LINKAGE
void clang_TypedefNameDecl_setModedTypeSourceInfo(CXTypedefNameDecl TND,
                                                  CXTypeSourceInfo unmodedTSI,
                                                  CXQualType modedTy);

CINDEX_LINKAGE CXTypedefNameDecl
clang_TypedefNameDecl_getCanonicalDecl(CXTypedefNameDecl TND);

CINDEX_LINKAGE CXTagDecl
clang_TypedefNameDecl_getAnonDeclWithTypedefName(CXTypedefNameDecl TND, bool AnyRedecl);

CINDEX_LINKAGE bool clang_TypedefNameDecl_isTransparentTag(CXTypedefNameDecl TND);

// TypedefDecl
CINDEX_LINKAGE CXTypedefDecl clang_TypedefDecl_Create(CXASTContext C, CXDeclContext DC,
                                                      CXSourceLocation_ StartLoc,
                                                      CXSourceLocation_ IdLoc,
                                                      CXIdentifierInfo Id,
                                                      CXTypeSourceInfo TInfo);

CINDEX_LINKAGE CXTypedefDecl clang_TypedefDecl_CreateDeserialized(CXASTContext C,
                                                                  unsigned ID);

CINDEX_LINKAGE CXSourceRange_ clang_TypedefDecl_getSourceRange(CXTypedefDecl TD);

// TypeAliasDecl
CINDEX_LINKAGE CXTypeAliasDecl clang_TypeAliasDecl_Create(CXASTContext C, CXDeclContext DC,
                                                          CXSourceLocation_ StartLoc,
                                                          CXSourceLocation_ IdLoc,
                                                          CXIdentifierInfo Id,
                                                          CXTypeSourceInfo TInfo);

CINDEX_LINKAGE CXTypeAliasDecl clang_TypeAliasDecl_CreateDeserialized(CXASTContext C,
                                                                      unsigned ID);

CINDEX_LINKAGE CXSourceRange_ clang_TypeAliasDecl_getSourceRange(CXTypeAliasDecl TAD);

CINDEX_LINKAGE CXTypeAliasTemplateDecl
clang_TypeAliasDecl_getDescribedAliasTemplate(CXTypeAliasDecl TAD);

CINDEX_LINKAGE void
clang_TypeAliasDecl_setDescribedAliasTemplate(CXTypeAliasDecl TAD,
                                              CXTypeAliasTemplateDecl TAT);

// TagDecl
CINDEX_LINKAGE CXSourceRange_ clang_TagDecl_getBraceRange(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setBraceRange(CXTagDecl TD, CXSourceRange_ R);

CINDEX_LINKAGE CXSourceLocation_ clang_TagDecl_getInnerLocStart(CXTagDecl TD);

CINDEX_LINKAGE CXSourceLocation_ clang_TagDecl_getOuterLocStart(CXTagDecl TD);

CINDEX_LINKAGE CXSourceRange_ clang_TagDecl_getSourceRange(CXTagDecl TD);

CINDEX_LINKAGE CXTagDecl clang_TagDecl_getCanonicalDecl(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isThisDeclarationADefinition(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isCompleteDefinition(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setCompleteDefinition(CXTagDecl TD, bool V);

CINDEX_LINKAGE bool clang_TagDecl_isCompleteDefinitionRequired(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setCompleteDefinitionRequired(CXTagDecl TD, bool V);

CINDEX_LINKAGE bool clang_TagDecl_isBeingDefined(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isEmbeddedInDeclarator(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setEmbeddedInDeclarator(CXTagDecl TD,
                                                          bool isInDeclarator);

CINDEX_LINKAGE bool clang_TagDecl_isFreeStanding(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setFreeStanding(CXTagDecl TD, bool isFreeStanding);

CINDEX_LINKAGE bool clang_TagDecl_mayHaveOutOfDateDef(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isDependentType(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_startDefinition(CXTagDecl TD);

CINDEX_LINKAGE CXTagDecl clang_TagDecl_getDefinition(CXTagDecl TD);

CINDEX_LINKAGE const char *clang_TagDecl_getKindName(CXTagDecl TD);

CINDEX_LINKAGE CXTagTypeKind clang_TagDecl_getTagKind(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setTagKind(CXTagDecl TD, CXTagTypeKind TK);

CINDEX_LINKAGE bool clang_TagDecl_isStruct(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isInterface(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isClass(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isUnion(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_isEnum(CXTagDecl TD);

CINDEX_LINKAGE bool clang_TagDecl_hasNameForLinkage(CXTagDecl TD);

CINDEX_LINKAGE CXTypedefNameDecl clang_TagDecl_getTypedefNameForAnonDecl(CXTagDecl TD);

CINDEX_LINKAGE void clang_TagDecl_setTypedefNameForAnonDecl(CXTagDecl TD,
                                                            CXTypedefNameDecl TDD);

CINDEX_LINKAGE CXNestedNameSpecifier clang_TagDecl_getQualifier(CXTagDecl TD);

// getQualifierLoc
// setQualifierInfo

CINDEX_LINKAGE unsigned clang_TagDecl_getNumTemplateParameterLists(CXTagDecl TD);

CINDEX_LINKAGE CXTemplateParameterList clang_TagDecl_getTemplateParameterList(CXTagDecl TD,
                                                                              unsigned i);

// setTemplateParameterListsInfo

// TagDecl Cast
CINDEX_LINKAGE CXDeclContext clang_TagDecl_castToDeclContext(CXTagDecl TD);

// EnumDecl
CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_Create(CXASTContext C, CXDeclContext DC,
                                                CXSourceLocation_ StartLoc,
                                                CXSourceLocation_ IdLoc,
                                                CXIdentifierInfo Id, CXEnumDecl PrevDecl,
                                                bool IsScoped, bool IsScopedUsingClassTag,
                                                bool IsFixed);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE void clang_EnumDecl_setScoped(CXEnumDecl ED, bool Scoped);

CINDEX_LINKAGE void clang_EnumDecl_setScopedUsingClassTag(CXEnumDecl ED, bool ScopedUCT);

CINDEX_LINKAGE void clang_EnumDecl_setFixed(CXEnumDecl ED, bool Fixed);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getCanonicalDecl(CXEnumDecl ED);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getPreviousDecl(CXEnumDecl ED);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getMostRecentDecl(CXEnumDecl ED);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getDefinition(CXEnumDecl ED);

CINDEX_LINKAGE void clang_EnumDecl_completeDefinition(CXEnumDecl ED, CXQualType NewType,
                                                      CXQualType PromotionType,
                                                      unsigned NumPositiveBits,
                                                      unsigned NumNegativeBits);

CINDEX_LINKAGE CXQualType clang_EnumDecl_getPromotionType(CXEnumDecl ED);

CINDEX_LINKAGE void clang_EnumDecl_setPromotionType(CXEnumDecl ED, CXQualType T);

CINDEX_LINKAGE CXQualType clang_EnumDecl_getIntegerType(CXEnumDecl ED);

CINDEX_LINKAGE void clang_EnumDecl_setIntegerType(CXEnumDecl ED, CXQualType T);

CINDEX_LINKAGE void clang_EnumDecl_setIntegerTypeSourceInfo(CXEnumDecl ED,
                                                            CXTypeSourceInfo TInfo);

CINDEX_LINKAGE CXTypeSourceInfo clang_EnumDecl_getIntegerTypeSourceInfo(CXEnumDecl ED);

CINDEX_LINKAGE CXSourceRange_ clang_EnumDecl_getIntegerTypeRange(CXEnumDecl ED);

CINDEX_LINKAGE unsigned clang_EnumDecl_getNumPositiveBits(CXEnumDecl ED);

CINDEX_LINKAGE unsigned clang_EnumDecl_getNumNegativeBits(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isScoped(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isScopedUsingClassTag(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isFixed(CXEnumDecl ED);

CINDEX_LINKAGE unsigned clang_EnumDecl_getODRHash(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isComplete(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isClosed(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isClosedFlag(CXEnumDecl ED);

CINDEX_LINKAGE bool clang_EnumDecl_isClosedNonFlag(CXEnumDecl ED);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getTemplateInstantiationPattern(CXEnumDecl ED);

CINDEX_LINKAGE CXEnumDecl clang_EnumDecl_getInstantiatedFromMemberEnum(CXEnumDecl ED);

CINDEX_LINKAGE CXTemplateSpecializationKind
clang_EnumDecl_getTemplateSpecializationKind(CXEnumDecl ED);

CINDEX_LINKAGE void
clang_EnumDecl_setTemplateSpecializationKind(CXEnumDecl ED,
                                             CXTemplateSpecializationKind TSK,
                                             CXSourceLocation_ PointOfInstantiation);

CINDEX_LINKAGE CXMemberSpecializationInfo
clang_EnumDecl_getMemberSpecializationInfo(CXEnumDecl ED);

CINDEX_LINKAGE void
clang_EnumDecl_setInstantiationOfMemberEnum(CXEnumDecl ED, CXEnumDecl ED2,
                                            CXTemplateSpecializationKind TSK);

// RecordDecl
typedef enum CXRecordDecl_ArgPassingKind : unsigned {
  CXRecordDecl_APK_CanPassInRegs,
  CXRecordDecl_APK_CannotPassInRegs,
  CXRecordDecl_APK_CanNeverPassInRegs
} CXRecordDecl_ArgPassingKind;

CINDEX_LINKAGE CXRecordDecl clang_RecordDecl_Create(
    CXASTContext C, CXTagTypeKind TK, CXDeclContext DC, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXRecordDecl PrevDecl);

CINDEX_LINKAGE CXRecordDecl clang_RecordDecl_CreateDeserialized(CXASTContext C,
                                                                unsigned ID);

CINDEX_LINKAGE CXRecordDecl clang_RecordDecl_getPreviousDecl(CXRecordDecl RD);

CINDEX_LINKAGE CXRecordDecl clang_RecordDecl_getMostRecentDecl(CXRecordDecl RD);

CINDEX_LINKAGE bool clang_RecordDecl_hasFlexibleArrayMember(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setHasFlexibleArrayMember(CXRecordDecl RD, bool V);

CINDEX_LINKAGE bool clang_RecordDecl_isAnonymousStructOrUnion(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setAnonymousStructOrUnion(CXRecordDecl RD, bool Anon);

CINDEX_LINKAGE bool clang_RecordDecl_hasObjectMember(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setHasObjectMember(CXRecordDecl RD, bool val);

CINDEX_LINKAGE bool clang_RecordDecl_hasVolatileMember(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setHasVolatileMember(CXRecordDecl RD, bool val);

CINDEX_LINKAGE bool clang_RecordDecl_hasLoadedFieldsFromExternalStorage(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(CXRecordDecl RD,
                                                                           bool val);

CINDEX_LINKAGE bool
clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD);

CINDEX_LINKAGE void
clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD, bool V);

CINDEX_LINKAGE bool clang_RecordDecl_isNonTrivialToPrimitiveCopy(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setNonTrivialToPrimitiveCopy(CXRecordDecl RD, bool V);

CINDEX_LINKAGE bool clang_RecordDecl_isNonTrivialToPrimitiveDestroy(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setNonTrivialToPrimitiveDestroy(CXRecordDecl RD,
                                                                     bool V);

CINDEX_LINKAGE bool
clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD);

CINDEX_LINKAGE void
clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD,
                                                                    bool V);

CINDEX_LINKAGE bool
clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD);

CINDEX_LINKAGE void
clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD, bool V);

CINDEX_LINKAGE bool clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD,
                                                                           bool V);

CINDEX_LINKAGE bool clang_RecordDecl_canPassInRegisters(CXRecordDecl RD);

CINDEX_LINKAGE CXRecordDecl_ArgPassingKind
clang_RecordDecl_getArgPassingRestrictions(CXRecordDecl RD);

CINDEX_LINKAGE void
clang_RecordDecl_setArgPassingRestrictions(CXRecordDecl RD,
                                           CXRecordDecl_ArgPassingKind Kind);

CINDEX_LINKAGE bool clang_RecordDecl_isParamDestroyedInCallee(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setParamDestroyedInCallee(CXRecordDecl RD, bool V);

CINDEX_LINKAGE bool clang_RecordDecl_isInjectedClassName(CXRecordDecl RD);

CINDEX_LINKAGE bool clang_RecordDecl_isLambda(CXRecordDecl RD);

CINDEX_LINKAGE bool clang_RecordDecl_isCapturedRecord(CXRecordDecl RD);

CINDEX_LINKAGE void clang_RecordDecl_setCapturedRecord(CXRecordDecl RD);

CINDEX_LINKAGE CXRecordDecl clang_RecordDecl_getDefinition(CXRecordDecl RD);

CINDEX_LINKAGE bool clang_RecordDecl_isOrContainsUnion(CXRecordDecl RD);

CINDEX_LINKAGE bool clang_RecordDecl_isMsStruct(CXRecordDecl RD, CXASTContext C);

CINDEX_LINKAGE bool clang_RecordDecl_mayInsertExtraPadding(CXRecordDecl RD,
                                                           bool EmitRemark);

CINDEX_LINKAGE CXFieldDecl clang_RecordDecl_findFirstNamedDataMember(CXRecordDecl RD);

// FileScopeAsmDecl
CINDEX_LINKAGE CXFileScopeAsmDecl
clang_FileScopeAsmDecl_Create(CXASTContext C, CXDeclContext DC, CXStringLiteral Str,
                              CXSourceLocation_ AsmLoc, CXSourceLocation_ RParenLoc);

CINDEX_LINKAGE CXFileScopeAsmDecl clang_FileScopeAsmDecl_CreateDeserialized(CXASTContext C,
                                                                            unsigned ID);

CINDEX_LINKAGE CXSourceLocation_ clang_FileScopeAsmDecl_getAsmLoc(CXFileScopeAsmDecl FSAD);

CINDEX_LINKAGE CXSourceLocation_
clang_FileScopeAsmDecl_getRParenLoc(CXFileScopeAsmDecl FSAD);

CINDEX_LINKAGE void clang_FileScopeAsmDecl_setRParenLoc(CXFileScopeAsmDecl FSAD,
                                                        CXSourceLocation_ L);

CINDEX_LINKAGE CXSourceRange_
clang_FileScopeAsmDecl_getSourceRange(CXFileScopeAsmDecl FSAD);

CINDEX_LINKAGE CXStringLiteral clang_FileScopeAsmDecl_getAsmString(CXFileScopeAsmDecl FSAD);

CINDEX_LINKAGE void clang_FileScopeAsmDecl_setAsmString(CXFileScopeAsmDecl FSAD,
                                                        CXStringLiteral Asm);

// BlockDecl
CINDEX_LINKAGE CXBlockDecl clang_BlockDecl_Create(CXASTContext C, CXDeclContext DC,
                                                  CXSourceLocation_ L);

CINDEX_LINKAGE CXBlockDecl clang_BlockDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CINDEX_LINKAGE CXSourceLocation_ clang_BlockDecl_getCaretLocation(CXBlockDecl BD);

CINDEX_LINKAGE bool clang_BlockDecl_isVariadic(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setBody(CXBlockDecl BD, CXCompoundStmt B);

CINDEX_LINKAGE void clang_BlockDecl_setSignatureAsWritten(CXBlockDecl BD,
                                                          CXTypeSourceInfo Sig);

CINDEX_LINKAGE CXTypeSourceInfo clang_BlockDecl_getSignatureAsWritten(CXBlockDecl BD);

CINDEX_LINKAGE unsigned clang_BlockDecl_getNumParams(CXBlockDecl BD);

CINDEX_LINKAGE CXParmVarDecl clang_BlockDecl_getParamDecl(CXBlockDecl BD, unsigned i);

// setParams

CINDEX_LINKAGE bool clang_BlockDecl_hasCaptures(CXBlockDecl BD);

CINDEX_LINKAGE unsigned clang_BlockDecl_getNumCaptures(CXBlockDecl BD);

CINDEX_LINKAGE bool clang_BlockDecl_capturesCXXThis(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setCapturesCXXThis(CXBlockDecl BD, bool B);

CINDEX_LINKAGE bool clang_BlockDecl_blockMissingReturnType(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setBlockMissingReturnType(CXBlockDecl BD, bool val);

CINDEX_LINKAGE bool clang_BlockDecl_isConversionFromLambda(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setIsConversionFromLambda(CXBlockDecl BD, bool val);

CINDEX_LINKAGE bool clang_BlockDecl_doesNotEscape(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setDoesNotEscape(CXBlockDecl BD, bool B);

CINDEX_LINKAGE bool clang_BlockDecl_canAvoidCopyToHeap(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setCanAvoidCopyToHeap(CXBlockDecl BD, bool B);

CINDEX_LINKAGE bool clang_BlockDecl_capturesVariable(CXBlockDecl BD, CXVarDecl var);

// setCaptures

CINDEX_LINKAGE unsigned clang_BlockDecl_getBlockManglingNumber(CXBlockDecl BD);

CINDEX_LINKAGE CXDecl clang_BlockDecl_getBlockManglingContextDecl(CXBlockDecl BD);

CINDEX_LINKAGE void clang_BlockDecl_setBlockMangling(CXBlockDecl BD, unsigned Number,
                                                     CXDecl Ctx);

CINDEX_LINKAGE CXSourceRange_ clang_BlockDecl_getSourceRange(CXBlockDecl BD);

// CapturedDecl
CINDEX_LINKAGE CXCapturedDecl clang_CapturedDecl_Create(CXASTContext C, CXDeclContext DC,
                                                        unsigned NumParams);

CINDEX_LINKAGE CXCapturedDecl clang_CapturedDecl_CreateDeserialized(CXASTContext C,
                                                                    unsigned ID,
                                                                    unsigned NumParams);

CINDEX_LINKAGE CXStmt clang_CapturedDecl_getBody(CXCapturedDecl CD);

CINDEX_LINKAGE void clang_CapturedDecl_setBody(CXCapturedDecl CD, CXStmt B);

CINDEX_LINKAGE bool clang_CapturedDecl_isNothrow(CXCapturedDecl CD);

CINDEX_LINKAGE void clang_CapturedDecl_setNothrow(CXCapturedDecl CD, bool Nothrow);

CINDEX_LINKAGE unsigned clang_CapturedDecl_getNumParams(CXCapturedDecl CD);

CINDEX_LINKAGE CXImplicitParamDecl clang_CapturedDecl_getParam(CXCapturedDecl CD,
                                                               unsigned i);

CINDEX_LINKAGE void clang_CapturedDecl_setParam(CXCapturedDecl CD, unsigned i,
                                                CXImplicitParamDecl P);

CINDEX_LINKAGE CXImplicitParamDecl clang_CapturedDecl_getContextParam(CXCapturedDecl CD);

CINDEX_LINKAGE void clang_CapturedDecl_setContextParam(CXCapturedDecl CD, unsigned i,
                                                       CXImplicitParamDecl P);
CINDEX_LINKAGE
unsigned clang_CapturedDecl_getContextParamPosition(CXCapturedDecl CD);

// ImportDecl
CINDEX_LINKAGE CXImportDecl clang_ImportDecl_CreateImplicit(CXASTContext C,
                                                            CXDeclContext DC,
                                                            CXSourceLocation_ StartLoc,
                                                            CXModule Imported,
                                                            CXSourceLocation_ EndLoc);

CINDEX_LINKAGE CXImportDecl clang_ImportDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                                unsigned NumLocations);

CINDEX_LINKAGE CXModule clang_ImportDecl_getImportedModule(CXImportDecl ID);

// getIdentifierLocs

CINDEX_LINKAGE CXSourceRange_ clang_ImportDecl_getSourceRange(CXImportDecl ID);

// ExportDecl
CINDEX_LINKAGE CXExportDecl clang_ExportDecl_Create(CXASTContext C, CXDeclContext DC,
                                                    CXSourceLocation_ ExportLoc);

CINDEX_LINKAGE CXExportDecl clang_ExportDecl_CreateDeserialized(CXASTContext C,
                                                                unsigned ID);

CINDEX_LINKAGE CXSourceLocation_ clang_ExportDecl_getExportLoc(CXExportDecl ED);

CINDEX_LINKAGE CXSourceLocation_ clang_ExportDecl_getRBraceLoc(CXExportDecl ED);

CINDEX_LINKAGE void clang_ExportDecl_setRBraceLoc(CXExportDecl ED, CXSourceLocation_ L);

CINDEX_LINKAGE bool clang_ExportDecl_hasBraces(CXExportDecl ED);

CINDEX_LINKAGE CXSourceLocation_ clang_ExportDecl_getEndLoc(CXExportDecl ED);

CINDEX_LINKAGE CXSourceRange_ clang_ExportDecl_getSourceRange(CXExportDecl ED);

// EmptyDecl
CINDEX_LINKAGE CXEmptyDecl clang_EmptyDecl_Create(CXASTContext C, CXDeclContext DC,
                                                  CXSourceLocation_ L);

CINDEX_LINKAGE CXEmptyDecl clang_EmptyDecl_CreateDeserialized(CXASTContext C, unsigned ID);

#ifdef __cplusplus
}
#endif
#endif