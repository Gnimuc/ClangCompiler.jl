#ifndef LLVM_CLANG_C_EXTRA_CXDECL_H
#define LLVM_CLANG_C_EXTRA_CXDECL_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXExceptionSpecificationType.h"
#include "clang-ex/Basic/CXLinkage.h"
#include "clang-ex/Basic/CXPragmaKinds.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXVisibility.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// TranslationUnitDecl
CXASTContext clang_TranslationUnitDecl_getASTContext(CXTranslationUnitDecl TUD);

CXNamespaceDecl clang_TranslationUnitDecl_getAnonymousNamespace(CXTranslationUnitDecl TUD);

void clang_TranslationUnitDecl_setAnonymousNamespace(CXTranslationUnitDecl TUD,
                                                     CXNamespaceDecl ND);

CXTranslationUnitDecl clang_TranslationUnitDecl_Create(CXTranslationUnitDecl TUD,
                                                       CXASTContext C);

// PragmaCommentDecl
CXPragmaCommentDecl clang_PragmaCommentDecl_Create(CXASTContext C, CXTranslationUnitDecl DC,
                                                   CXSourceLocation_ CommentLoc,
                                                   CXPragmaMSCommentKind CommentKind,
                                                   const char *Arg);

CXPragmaCommentDecl clang_PragmaCommentDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                               unsigned ArgSize);

CXPragmaMSCommentKind clang_PragmaCommentDecl_getCommentKind(CXPragmaCommentDecl PCD);

const char *clang_PragmaCommentDecl_getArg(CXPragmaCommentDecl PCD);

// PragmaDetectMismatchDecl
CXPragmaDetectMismatchDecl clang_PragmaDetectMismatchDecl_Create(CXASTContext C,
                                                                 CXTranslationUnitDecl DC,
                                                                 CXSourceLocation_ Loc,
                                                                 const char *Name,
                                                                 const char *Value);

CXPragmaDetectMismatchDecl
clang_PragmaDetectMismatchDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                  unsigned NameValueSize);

const char *clang_PragmaDetectMismatchDecl_getName(CXPragmaDetectMismatchDecl PDMD);

const char *clang_PragmaDetectMismatchDecl_getValue(CXPragmaDetectMismatchDecl PDMD);

// ExternCContextDecl
CXExternCContextDecl clang_ExternCContextDecl_Create(CXASTContext C,
                                                     CXTranslationUnitDecl TU);

// NamedDecl
CXIdentifierInfo clang_NamedDecl_getIdentifier(CXNamedDecl ND);

const char *clang_NamedDecl_getName(CXNamedDecl ND);

CXDeclarationName clang_NamedDecl_getDeclName(CXNamedDecl ND);

void clang_NamedDecl_setDeclName(CXNamedDecl ND, CXDeclarationName DN);

bool clang_NamedDecl_declarationReplaces(CXNamedDecl ND, CXNamedDecl OldD,
                                         bool IsKnownNewer);

bool clang_NamedDecl_hasLinkage(CXNamedDecl ND);

bool clang_NamedDecl_isCXXClassMember(CXNamedDecl ND);

bool clang_NamedDecl_isCXXInstanceMember(CXNamedDecl ND);

CXLinkage clang_NamedDecl_getLinkageInternal(CXNamedDecl ND);

CXLinkage clang_NamedDecl_getFormalLinkage(CXNamedDecl ND);

bool clang_NamedDecl_hasExternalFormalLinkage(CXNamedDecl ND);

bool clang_NamedDecl_isExternallyVisible(CXNamedDecl ND);

bool clang_NamedDecl_isExternallyDeclarable(CXNamedDecl ND);

CXVisibility clang_NamedDecl_getVisibility(CXNamedDecl ND);

// getLinkageAndVisibility
// getExplicitVisibility

bool clang_NamedDecl_isLinkageValid(CXNamedDecl ND);

bool clang_NamedDecl_hasLinkageBeenComputed(CXNamedDecl ND);

CXNamedDecl clang_NamedDecl_getUnderlyingDecl(CXNamedDecl ND);

CXNamedDecl clang_NamedDecl_getMostRecentDecl(CXNamedDecl ND);

// getObjCFStringFormattingFamily

// NamedDecl Cast
CXTypeDecl clang_NamedDecl_castToTypeDecl(CXNamedDecl ND);

CXEnumConstantDecl clang_NamedDecl_castToEnumConstantDecl(CXNamedDecl ND);

// LabelDecl
CXLabelDecl clang_LabelDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ IdentL, CXIdentifierInfo II);

CXLabelDecl clang_LabelDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXLabelStmt clang_LabelDecl_getStmt(CXLabelDecl LD);

void clang_LabelDecl_setStmt(CXLabelDecl LD, CXLabelStmt T);

bool clang_LabelDecl_isGnuLocal(CXLabelDecl LD);

void clang_LabelDecl_setLocStart(CXLabelDecl LD, CXSourceLocation_ Loc);

CXSourceRange_ clang_LabelDecl_getSourceRange(CXLabelDecl LD);

bool clang_LabelDecl_isMSAsmLabel(CXLabelDecl LD);

bool clang_LabelDecl_isResolvedMSAsmLabel(CXLabelDecl LD);

// setMSAsmLabel

const char *clang_LabelDecl_getMSAsmLabel(CXLabelDecl LD);

void clang_LabelDecl_setMSAsmLabelResolved(CXLabelDecl LD);

// NamespaceDecl
// CXNamespaceDecl clang_NamespaceDecl_Create(CXASTContext C, CXDeclContext DC, bool Inline,
//                                            CXSourceLocation_ StartLoc,
//                                            CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
//                                            CXNamespaceDecl PrevDecl);

CXNamespaceDecl clang_NamespaceDecl_CreateDeserialized(CXASTContext C, unsigned ID);

bool clang_NamespaceDecl_isAnonymousNamespace(CXNamespaceDecl ND);

bool clang_NamespaceDecl_isInline(CXNamespaceDecl ND);

void clang_NamespaceDecl_setInline(CXNamespaceDecl ND, bool Inline);

CXNamespaceDecl clang_NamespaceDecl_getOriginalNamespace(CXNamespaceDecl ND);

bool clang_NamespaceDecl_isOriginalNamespace(CXNamespaceDecl ND);

CXNamespaceDecl clang_NamespaceDecl_getAnonymousNamespace(CXNamespaceDecl ND);

void clang_NamespaceDecl_setAnonymousNamespace(CXNamespaceDecl ND, CXNamespaceDecl D);

CXNamespaceDecl clang_NamespaceDecl_getCanonicalDecl(CXNamespaceDecl ND);

CXSourceRange_ clang_NamespaceDecl_getSourceRange(CXNamespaceDecl ND);

CXSourceLocation_ clang_NamespaceDecl_getBeginLoc(CXNamespaceDecl ND);

CXSourceLocation_ clang_NamespaceDecl_getRBraceLoc(CXNamespaceDecl ND);

void clang_NamespaceDecl_setLocStart(CXNamespaceDecl ND, CXSourceLocation_ Loc);

void clang_NamespaceDecl_setRBraceLoc(CXNamespaceDecl ND, CXSourceLocation_ Loc);

// ValueDecl
CXQualType clang_ValueDecl_getType(CXValueDecl VD);

void clang_ValueDecl_setType(CXValueDecl VD, CXQualType OpaquePtr);

bool clang_ValueDecl_isWeak(CXValueDecl VD);

// DeclaratorDecl
CXTypeSourceInfo clang_DeclaratorDecl_getTypeSourceInfo(CXDeclaratorDecl DD);

void clang_DeclaratorDecl_setTypeSourceInfo(CXDeclaratorDecl DD, CXTypeSourceInfo TI);

CXSourceLocation_ clang_DeclaratorDecl_getInnerLocStart(CXDeclaratorDecl DD);

void clang_DeclaratorDecl_setInnerLocStart(CXDeclaratorDecl DD, CXSourceLocation_ Loc);

CXSourceLocation_ clang_DeclaratorDecl_getOuterLocStart(CXDeclaratorDecl DD);

CXSourceLocation_ clang_DeclaratorDecl_getBeginLoc(CXDeclaratorDecl DD);

CXNestedNameSpecifier clang_DeclaratorDecl_getQualifier(CXDeclaratorDecl DD);

// getQualifierLoc
// setQualifierInfo

CXExpr clang_DeclaratorDecl_getTrailingRequiresClause(CXDeclaratorDecl DD);

void clang_DeclaratorDecl_setTrailingRequiresClause(CXDeclaratorDecl DD,
                                                    CXExpr TrailingRequiresClause);

unsigned clang_DeclaratorDecl_getNumTemplateParameterLists(CXDeclaratorDecl DD);

CXTemplateParameterList clang_DeclaratorDecl_getTemplateParameterList(CXDeclaratorDecl DD,
                                                                      unsigned index);

// setTemplateParameterListsInfo

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecStartLoc(CXDeclaratorDecl DD);

CXSourceLocation_ clang_DeclaratorDecl_getTypeSpecEndLoc(CXDeclaratorDecl DD);

// VarDecl
CXVarDecl clang_VarDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc,
                               CXSourceLocation_ IdLoc, CXIdentifierInfo Id, CXQualType T,
                               CXTypeSourceInfo TInfo, CXStorageClass S);

CXVarDecl clang_VarDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceRange_ clang_VarDecl_getSourceRange(CXVarDecl VD);

CXStorageClass clang_VarDecl_getStorageClass(CXVarDecl VD);

void clang_VarDecl_setStorageClass(CXVarDecl VD, CXStorageClass SC);

void clang_VarDecl_setTSCSpec(CXVarDecl VD, CXThreadStorageClassSpecifier TSC);

CXThreadStorageClassSpecifier clang_VarDecl_getTSCSpec(CXVarDecl VD);

// getTLSKind

bool clang_VarDecl_hasLocalStorage(CXVarDecl VD);

bool clang_VarDecl_isStaticLocal(CXVarDecl VD);

bool clang_VarDecl_hasExternalStorage(CXVarDecl VD);

bool clang_VarDecl_hasGlobalStorage(CXVarDecl VD);

CXStorageDuration clang_VarDecl_getStorageDuration(CXVarDecl VD);

CXLanguageLinkage clang_VarDecl_getLanguageLinkage(CXVarDecl VD);

bool clang_VarDecl_isExternC(CXVarDecl VD);

bool clang_VarDecl_isInExternCContext(CXVarDecl VD);

bool clang_VarDecl_isInExternCXXContext(CXVarDecl VD);

bool clang_VarDecl_isLocalVarDecl(CXVarDecl VD);

bool clang_VarDecl_isLocalVarDeclOrParm(CXVarDecl VD);

bool clang_VarDecl_isFunctionOrMethodVarDecl(CXVarDecl VD);

bool clang_VarDecl_isStaticDataMember(CXVarDecl VD);

CXVarDecl clang_VarDecl_getCanonicalDecl(CXVarDecl VD);

// isThisDeclarationADefinition
// hasDefinition

CXVarDecl clang_VarDecl_getActingDefinition(CXVarDecl VD);

CXVarDecl clang_VarDecl_getDefinition(CXVarDecl VD);

bool clang_VarDecl_isOutOfLine(CXVarDecl VD);

bool clang_VarDecl_isFileVarDecl(CXVarDecl VD);

CXExpr clang_VarDecl_getAnyInitializer(CXVarDecl VD);

bool clang_VarDecl_hasInit(CXVarDecl VD);

CXExpr clang_VarDecl_getInit(CXVarDecl VD);

// getInitAddress

void clang_VarDecl_setInit(CXVarDecl VD, CXExpr I);

CXVarDecl clang_VarDecl_getInitializingDeclaration(CXVarDecl VD);

bool clang_VarDecl_mightBeUsableInConstantExpressions(CXVarDecl VD, CXASTContext C);

bool clang_VarDecl_isUsableInConstantExpressions(CXVarDecl VD, CXASTContext C);

CXEvaluatedStmt clang_VarDecl_ensureEvaluatedStmt(CXVarDecl VD);

CXEvaluatedStmt clang_VarDecl_getEvaluatedStmt(CXVarDecl VD);

// evaluateValue
// getEvaluatedValue
// evaluateDestruction

bool clang_VarDecl_hasConstantInitialization(CXVarDecl VD);

bool clang_VarDecl_hasICEInitializer(CXVarDecl VD, CXASTContext Context);

// checkForConstantInitialization
// setInitStyle
// getInitStyle

bool clang_VarDecl_isDirectInit(CXVarDecl VD);

bool clang_VarDecl_isThisDeclarationADemotedDefinition(CXVarDecl VD);

void clang_VarDecl_demoteThisDefinitionToDeclaration(CXVarDecl VD);

bool clang_VarDecl_isExceptionVariable(CXVarDecl VD);

void clang_VarDecl_setExceptionVariable(CXVarDecl VD, bool EV);

bool clang_VarDecl_isNRVOVariable(CXVarDecl VD);

void clang_VarDecl_setNRVOVariable(CXVarDecl VD, bool NRVO);

bool clang_VarDecl_isCXXForRangeDecl(CXVarDecl VD);

void clang_VarDecl_setCXXForRangeDecl(CXVarDecl VD, bool FRD);

bool clang_VarDecl_isObjCForDecl(CXVarDecl VD);

void clang_VarDecl_setObjCForDecl(CXVarDecl VD, bool FRD);

bool clang_VarDecl_isARCPseudoStrong(CXVarDecl VD);

void clang_VarDecl_setARCPseudoStrong(CXVarDecl VD, bool PS);

bool clang_VarDecl_isInline(CXVarDecl VD);

bool clang_VarDecl_isInlineSpecified(CXVarDecl VD);

void clang_VarDecl_setInlineSpecified(CXVarDecl VD);

void clang_VarDecl_setImplicitlyInline(CXVarDecl VD);

bool clang_VarDecl_isConstexpr(CXVarDecl VD);

void clang_VarDecl_setConstexpr(CXVarDecl VD, bool IC);

bool clang_VarDecl_isInitCapture(CXVarDecl VD);

void clang_VarDecl_setInitCapture(CXVarDecl VD, bool IC);

bool clang_VarDecl_isParameterPack(CXVarDecl VD);

bool clang_VarDecl_isPreviousDeclInSameBlockScope(CXVarDecl VD);

void clang_VarDecl_setPreviousDeclInSameBlockScope(CXVarDecl VD, bool Same);

bool clang_VarDecl_isEscapingByref(CXVarDecl VD);

bool clang_VarDecl_isNonEscapingByref(CXVarDecl VD);

void clang_VarDecl_setEscapingByref(CXVarDecl VD);

CXVarDecl clang_VarDecl_getTemplateInstantiationPattern(CXVarDecl VD);

CXVarDecl clang_VarDecl_getInstantiatedFromStaticDataMember(CXVarDecl VD);

CXTemplateSpecializationKind clang_VarDecl_getTemplateSpecializationKind(CXVarDecl VD);

CXTemplateSpecializationKind
clang_VarDecl_getTemplateSpecializationKindForInstantiation(CXVarDecl VD);

CXSourceLocation_ clang_VarDecl_getPointOfInstantiation(CXVarDecl VD);

// getMemberSpecializationInfo

void clang_VarDecl_setTemplateSpecializationKind(CXVarDecl VD,
                                                 CXTemplateSpecializationKind TSK,
                                                 CXSourceLocation_ PointOfInstantiation);

void clang_VarDecl_setInstantiationOfStaticDataMember(CXVarDecl VD, CXVarDecl VD2,
                                                      CXTemplateSpecializationKind TSK);

CXVarTemplateDecl clang_VarDecl_getDescribedVarTemplate(CXVarDecl VD);

void clang_VarDecl_setDescribedVarTemplate(CXVarDecl VD, CXVarTemplateDecl Template);

bool clang_VarDecl_isKnownToBeDefined(CXVarDecl VD);

bool clang_VarDecl_isNoDestroy(CXVarDecl VD, CXASTContext AST);

// needsDestruction

// ImplicitParamDecl
typedef enum CXImplicitParamKind : unsigned {
  CXImplicitParamKind_ObjCSelf,
  CXImplicitParamKind_ObjCCmd,
  CXImplicitParamKind_CXXThis,
  CXImplicitParamKind_CXXVTT,
  CXImplicitParamKind_CapturedContext,
  CXImplicitParamKind_ThreadPrivateVar,
  CXImplicitParamKind_Other,
} CXImplicitParamKind;

CXImplicitParamDecl clang_ImplicitParamDecl_Create(CXASTContext C, CXDeclContext DC,
                                                   CXSourceLocation_ IdLoc,
                                                   CXIdentifierInfo Id, CXQualType T,
                                                   CXImplicitParamKind ParamKind);

CXImplicitParamDecl clang_ImplicitParamDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXImplicitParamKind clang_ImplicitParamDecl_getParameterKind(CXImplicitParamDecl IPD);

// ParmVarDecl
CXParmVarDecl clang_ParmVarDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXQualType T,
                                       CXTypeSourceInfo TInfo, CXStorageClass S,
                                       CXExpr DefArg);

CXParmVarDecl clang_ParmVarDecl_CreateDeserialized(CXASTContext C, unsigned ID);

void clang_ParmVarDecl_setObjCMethodScopeInfo(CXParmVarDecl PVD, unsigned parameterIndex);

void clang_ParmVarDecl_setScopeInfo(CXParmVarDecl PVD, unsigned scopeDepth,
                                    unsigned parameterIndex);

bool clang_ParmVarDecl_isObjCMethodParameter(CXParmVarDecl PVD);

bool clang_ParmVarDecl_isDestroyedInCallee(CXParmVarDecl PVD);

unsigned clang_ParmVarDecl_getFunctionScopeDepth(CXParmVarDecl PVD);

unsigned clang_ParmVarDecl_getFunctionScopeIndex(CXParmVarDecl PVD);

// getObjCDeclQualifier
// setObjCDeclQualifier

bool clang_ParmVarDecl_isKNRPromoted(CXParmVarDecl PVD);

void clang_ParmVarDecl_setKNRPromoted(CXParmVarDecl PVD, bool promoted);

CXExpr clang_ParmVarDecl_getDefaultArg(CXParmVarDecl PVD);

void clang_ParmVarDecl_setDefaultArg(CXParmVarDecl PVD, CXExpr defarg);

CXSourceRange_ clang_ParmVarDecl_getDefaultArgRange(CXParmVarDecl PVD);

void clang_ParmVarDecl_setUninstantiatedDefaultArg(CXParmVarDecl PVD, CXExpr arg);

CXExpr clang_ParmVarDecl_getUninstantiatedDefaultArg(CXParmVarDecl PVD);

bool clang_ParmVarDecl_hasDefaultArg(CXParmVarDecl PVD);

bool clang_ParmVarDecl_hasUnparsedDefaultArg(CXParmVarDecl PVD);

bool clang_ParmVarDecl_hasUninstantiatedDefaultArg(CXParmVarDecl PVD);

void clang_ParmVarDecl_setUnparsedDefaultArg(CXParmVarDecl PVD);

bool clang_ParmVarDecl_hasInheritedDefaultArg(CXParmVarDecl PVD);

void clang_ParmVarDecl_setHasInheritedDefaultArg(CXParmVarDecl PVD, bool I);

CXQualType clang_ParmVarDecl_getOriginalType(CXParmVarDecl PVD);

void clang_ParmVarDecl_setOwningFunction(CXParmVarDecl PVD, CXDeclContext FD);

// MultiVersionKind
typedef enum CXMultiVersionKind {
  CXMultiVersionKind_None,
  CXMultiVersionKind_Target,
  CXMultiVersionKind_CPUSpecific,
  CXMultiVersionKind_CPUDispatch,
  CXMultiVersionKind_TargetClones,
  CXMultiVersionKind_TargetVersion
} CXMultiVersionKind;

// FunctionDecl
typedef enum CXFunctionDecl_TemplatedKind {
  CXFunctionDecl_TK_NonTemplate,
  CXFunctionDecl_TK_FunctionTemplate,
  CXFunctionDecl_TK_MemberSpecialization,
  CXFunctionDecl_TK_FunctionTemplateSpecialization,
  CXFunctionDecl_TK_DependentFunctionTemplateSpecialization,
  CXFunctionDecl_TK_DependentNonTemplate
} CXFunctionDecl_TemplatedKind;

typedef void *CXFunctionDecl_DefaultedFunctionInfo;

CXFunctionDecl clang_FunctionDecl_Create(CXASTContext C, CXDeclContext DC,
                                         CXSourceLocation_ StartLoc, CXSourceLocation_ NLoc,
                                         CXDeclarationName N, CXQualType T,
                                         CXTypeSourceInfo TInfo, CXStorageClass SC,
                                         bool isInlineSpecified, bool hasWrittenPrototype);

CXFunctionDecl clang_FunctionDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// getNameInfo
// getNameForDiagnostic

void clang_FunctionDecl_setRangeEnd(CXFunctionDecl FD, CXSourceLocation_ Loc);

CXSourceLocation_ clang_FunctionDecl_getEllipsisLoc(CXFunctionDecl FD);

CXSourceRange_ clang_FunctionDecl_getSourceRange(CXFunctionDecl FD);

bool clang_FunctionDecl_hasBody(CXFunctionDecl FD);

bool clang_FunctionDecl_hasTrivialBody(CXFunctionDecl FD);

bool clang_FunctionDecl_isDefined(CXFunctionDecl FD);

CXFunctionDecl clang_FunctionDecl_getDefinition(CXFunctionDecl FD);

CXStmt clang_FunctionDecl_getBody(CXFunctionDecl FD);

bool clang_FunctionDecl_isThisDeclarationADefinition(CXFunctionDecl FD);

bool clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(
    CXFunctionDecl FD);

bool clang_FunctionDecl_doesThisDeclarationHaveABody(CXFunctionDecl FD);

void clang_FunctionDecl_setBody(CXFunctionDecl FD, CXStmt B);

void clang_FunctionDecl_setLazyBody(CXFunctionDecl FD, uint64_t Offset);

void clang_FunctionDecl_setDefaultedFunctionInfo(CXFunctionDecl FD,
                                                 CXFunctionDecl_DefaultedFunctionInfo Info);

bool clang_FunctionDecl_isVariadic(CXFunctionDecl FD);

bool clang_FunctionDecl_isVirtualAsWritten(CXFunctionDecl FD);

void clang_FunctionDecl_setVirtualAsWritten(CXFunctionDecl FD, bool V);

bool clang_FunctionDecl_isPureVirtual(CXFunctionDecl FD);

void clang_FunctionDecl_setIsPureVirtual(CXFunctionDecl FD, bool P);

bool clang_FunctionDecl_isLateTemplateParsed(CXFunctionDecl FD);

void clang_FunctionDecl_setLateTemplateParsed(CXFunctionDecl FD, bool ILT);

bool clang_FunctionDecl_isTrivial(CXFunctionDecl FD);

void clang_FunctionDecl_setTrivial(CXFunctionDecl FD, bool IT);

bool clang_FunctionDecl_isTrivialForCall(CXFunctionDecl FD);

void clang_FunctionDecl_setTrivialForCall(CXFunctionDecl FD, bool IT);

bool clang_FunctionDecl_isDefaulted(CXFunctionDecl FD);

void clang_FunctionDecl_setDefaulted(CXFunctionDecl FD, bool D);

bool clang_FunctionDecl_isExplicitlyDefaulted(CXFunctionDecl FD);

void clang_FunctionDecl_setExplicitlyDefaulted(CXFunctionDecl FD, bool ED);

bool clang_FunctionDecl_isUserProvided(CXFunctionDecl FD);

bool clang_FunctionDecl_hasImplicitReturnZero(CXFunctionDecl FD);

void clang_FunctionDecl_setHasImplicitReturnZero(CXFunctionDecl FD, bool IRZ);

bool clang_FunctionDecl_hasPrototype(CXFunctionDecl FD);

bool clang_FunctionDecl_hasWrittenPrototype(CXFunctionDecl FD);

void clang_FunctionDecl_setHasWrittenPrototype(CXFunctionDecl FD, bool P);

bool clang_FunctionDecl_hasInheritedPrototype(CXFunctionDecl FD);

void clang_FunctionDecl_setHasInheritedPrototype(CXFunctionDecl FD, bool P);

bool clang_FunctionDecl_isConstexpr(CXFunctionDecl FD);

void clang_FunctionDecl_setConstexprKind(CXFunctionDecl FD, CXConstexprSpecKind CSK);

CXConstexprSpecKind clang_FunctionDecl_getConstexprKind(CXFunctionDecl FD);

bool clang_FunctionDecl_isConstexprSpecified(CXFunctionDecl FD);

bool clang_FunctionDecl_isConsteval(CXFunctionDecl FD);

bool clang_FunctionDecl_instantiationIsPending(CXFunctionDecl FD);

void clang_FunctionDecl_setInstantiationIsPending(CXFunctionDecl FD, bool IC);

bool clang_FunctionDecl_usesSEHTry(CXFunctionDecl FD);

void clang_FunctionDecl_setUsesSEHTry(CXFunctionDecl FD, bool UST);

bool clang_FunctionDecl_isDeleted(CXFunctionDecl FD);

bool clang_FunctionDecl_isDeletedAsWritten(CXFunctionDecl FD);

void clang_FunctionDecl_setDeletedAsWritten(CXFunctionDecl FD, bool D);

bool clang_FunctionDecl_isMain(CXFunctionDecl FD);

bool clang_FunctionDecl_isMSVCRTEntryPoint(CXFunctionDecl FD);

bool clang_FunctionDecl_isReservedGlobalPlacementOperator(CXFunctionDecl FD);

bool clang_FunctionDecl_isReplaceableGlobalAllocationFunction(CXFunctionDecl FD);

bool clang_FunctionDecl_isInlineBuiltinDeclaration(CXFunctionDecl FD);

bool clang_FunctionDecl_isDestroyingOperatorDelete(CXFunctionDecl FD);

CXLanguageLinkage clang_FunctionDecl_getLanguageLinkage(CXFunctionDecl FD);

bool clang_FunctionDecl_isExternC(CXFunctionDecl FD);

bool clang_FunctionDecl_isInExternCContext(CXFunctionDecl FD);

bool clang_FunctionDecl_isInExternCXXContext(CXFunctionDecl FD);

bool clang_FunctionDecl_isGlobal(CXFunctionDecl FD);

bool clang_FunctionDecl_isNoReturn(CXFunctionDecl FD);

bool clang_FunctionDecl_hasSkippedBody(CXFunctionDecl FD);

void clang_FunctionDecl_setHasSkippedBody(CXFunctionDecl FD, bool Skipped);

bool clang_FunctionDecl_willHaveBody(CXFunctionDecl FD);

void clang_FunctionDecl_setWillHaveBody(CXFunctionDecl FD, bool V);

bool clang_FunctionDecl_isMultiVersion(CXFunctionDecl FD);

void clang_FunctionDecl_setIsMultiVersion(CXFunctionDecl FD, bool V);

CXMultiVersionKind clang_FunctionDecl_getMultiVersionKind(CXFunctionDecl FD);

bool clang_FunctionDecl_isCPUDispatchMultiVersion(CXFunctionDecl FD);

bool clang_FunctionDecl_isCPUSpecificMultiVersion(CXFunctionDecl FD);

bool clang_FunctionDecl_isTargetMultiVersion(CXFunctionDecl FD);

// getAssociatedConstraints

void clang_FunctionDecl_setPreviousDeclaration(CXFunctionDecl FD, CXFunctionDecl PrevDecl);

CXFunctionDecl clang_FunctionDecl_getCanonicalDecl(CXFunctionDecl FD);

unsigned clang_FunctionDecl_getBuiltinID(CXFunctionDecl FD);

// parameters

unsigned clang_FunctionDecl_getNumParams(CXFunctionDecl FD);

CXParmVarDecl clang_FunctionDecl_getParamDecl(CXFunctionDecl FD, unsigned i);

// setParams

unsigned clang_FunctionDecl_getMinRequiredArguments(CXFunctionDecl FD);

bool clang_FunctionDecl_hasOneParamOrDefaultArgs(CXFunctionDecl FD);

// getFunctionTypeLoc

CXQualType clang_FunctionDecl_getReturnType(CXFunctionDecl FD);

CXSourceRange_ clang_FunctionDecl_getReturnTypeSourceRange(CXFunctionDecl FD);

CXSourceRange_ clang_FunctionDecl_getParametersSourceRange(CXFunctionDecl FD);

CXQualType clang_FunctionDecl_getDeclaredReturnType(CXFunctionDecl FD);

CXExceptionSpecificationType clang_FunctionDecl_getExceptionSpecType(CXFunctionDecl FD);

CXSourceRange_ clang_FunctionDecl_getExceptionSpecSourceRange(CXFunctionDecl FD);

CXQualType clang_FunctionDecl_getCallResultType(CXFunctionDecl FD);

CXStorageClass clang_FunctionDecl_getStorageClass(CXFunctionDecl FD);

void clang_FunctionDecl_setStorageClass(CXFunctionDecl FD, CXStorageClass SClass);

bool clang_FunctionDecl_isInlineSpecified(CXFunctionDecl FD);

void clang_FunctionDecl_setInlineSpecified(CXFunctionDecl FD, bool I);

void clang_FunctionDecl_setImplicitlyInline(CXFunctionDecl FD, bool I);

bool clang_FunctionDecl_isInlined(CXFunctionDecl FD);

bool clang_FunctionDecl_isInlineDefinitionExternallyVisible(CXFunctionDecl FD);

bool clang_FunctionDecl_isMSExternInline(CXFunctionDecl FD);

bool clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(CXFunctionDecl FD);

bool clang_FunctionDecl_isStatic(CXFunctionDecl FD);

bool clang_FunctionDecl_isOverloadedOperator(CXFunctionDecl FD);

// getOverloadedOperator

CXIdentifierInfo clang_FunctionDecl_getLiteralIdentifier(CXFunctionDecl FD);

CXFunctionDecl_TemplatedKind clang_FunctionDecl_getTemplatedKind(CXFunctionDecl FD);

CXMemberSpecializationInfo
clang_FunctionDecl_getMemberSpecializationInfo(CXFunctionDecl FD);

void clang_FunctionDecl_setInstantiationOfMemberFunction(CXFunctionDecl FD,
                                                         CXFunctionDecl FD2,
                                                         CXTemplateSpecializationKind TSK);

CXFunctionTemplateDecl clang_FunctionDecl_getDescribedFunctionTemplate(CXFunctionDecl FD);

void clang_FunctionDecl_setDescribedFunctionTemplate(CXFunctionDecl FD,
                                                     CXFunctionTemplateDecl Template);

CXFunctionDecl clang_FunctionDecl_getInstantiatedFromMemberFunction(CXFunctionDecl FD);

bool clang_FunctionDecl_isFunctionTemplateSpecialization(CXFunctionDecl FD);

CXFunctionTemplateSpecializationInfo
clang_FunctionDecl_getTemplateSpecializationInfo(CXFunctionDecl FD);

bool clang_FunctionDecl_isImplicitlyInstantiable(CXFunctionDecl FD);

bool clang_FunctionDecl_isTemplateInstantiation(CXFunctionDecl FD);

CXFunctionDecl clang_FunctionDecl_getTemplateInstantiationPattern(CXFunctionDecl FD,
                                                                  bool ForDefinition);

CXFunctionTemplateDecl clang_FunctionDecl_getPrimaryTemplate(CXFunctionDecl FD);

CXTemplateArgumentList clang_FunctionDecl_getTemplateSpecializationArgs(CXFunctionDecl FD);

CXASTTemplateArgumentListInfo
clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(CXFunctionDecl FD);

// setFunctionTemplateSpecialization
// setDependentTemplateSpecialization

CXDependentFunctionTemplateSpecializationInfo
clang_FunctionDecl_getDependentSpecializationInfo(CXFunctionDecl FD);

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKind(CXFunctionDecl FD);

CXTemplateSpecializationKind
clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(CXFunctionDecl FD);

void clang_FunctionDecl_setTemplateSpecializationKind(
    CXFunctionDecl FD, CXTemplateSpecializationKind TSK,
    CXSourceLocation_ PointOfInstantiation);

CXSourceLocation_ clang_FunctionDecl_getPointOfInstantiation(CXFunctionDecl FD);

bool clang_FunctionDecl_isOutOfLine(CXFunctionDecl FD);

unsigned clang_FunctionDecl_getMemoryFunctionKind(CXFunctionDecl FD);

unsigned clang_FunctionDecl_getODRHash(CXFunctionDecl FD);

// FieldDecl
CXFieldDecl clang_FieldDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                   CXIdentifierInfo I, CXQualType T, CXTypeSourceInfo TInfo,
                                   CXExpr BW, bool Mutable, CXInClassInitStyle InitStyle);

CXFieldDecl clang_FieldDecl_CreateDeserialized(CXASTContext C, unsigned ID);

unsigned clang_FieldDecl_getFieldIndex(CXFieldDecl FD);

bool clang_FieldDecl_isMutable(CXFieldDecl FD);

bool clang_FieldDecl_isBitField(CXFieldDecl FD);

bool clang_FieldDecl_isUnnamedBitfield(CXFieldDecl FD);

bool clang_FieldDecl_isAnonymousStructOrUnion(CXFieldDecl FD);

CXExpr clang_FieldDecl_getBitWidth(CXFieldDecl FD);

unsigned clang_FieldDecl_getBitWidthValue(CXFieldDecl FD, CXASTContext Ctx);

void clang_FieldDecl_setBitWidth(CXFieldDecl FD, CXExpr Width);

void clang_FieldDecl_removeBitWidth(CXFieldDecl FD);

bool clang_FieldDecl_isZeroLengthBitField(CXFieldDecl FD, CXASTContext Ctx);

bool clang_FieldDecl_isZeroSize(CXFieldDecl FD, CXASTContext Ctx);

CXInClassInitStyle clang_FieldDecl_getInClassInitStyle(CXFieldDecl FD);

bool clang_FieldDecl_hasInClassInitializer(CXFieldDecl FD);

CXExpr clang_FieldDecl_getInClassInitializer(CXFieldDecl FD);

void clang_FieldDecl_setInClassInitializer(CXFieldDecl FD, CXExpr Init);

void clang_FieldDecl_removeInClassInitializer(CXFieldDecl FD);

bool clang_FieldDecl_hasCapturedVLAType(CXFieldDecl FD);

CXVariableArrayType clang_FieldDecl_getCapturedVLAType(CXFieldDecl FD);

void clang_FieldDecl_setCapturedVLAType(CXFieldDecl FD, CXVariableArrayType VLAType);

CXRecordDecl clang_FieldDecl_getParent(CXFieldDecl FD);

CXSourceRange_ clang_FieldDecl_getSourceRange(CXFieldDecl FD);

CXFieldDecl clang_FieldDecl_getCanonicalDecl(CXFieldDecl FD);

// EnumConstantDecl
CXEnumConstantDecl clang_EnumConstantDecl_Create(CXASTContext C, CXEnumDecl DC,
                                                 CXSourceLocation_ L, CXIdentifierInfo Id,
                                                 CXQualType T, CXExpr E,
                                                 LLVMGenericValueRef V);

CXEnumConstantDecl clang_EnumConstantDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXExpr clang_EnumConstantDecl_getInitExpr(CXEnumConstantDecl ECD);

// getInitVal

void clang_EnumConstantDecl_setInitExpr(CXEnumConstantDecl ECD, CXExpr E);

// setInitVal

CXSourceRange_ clang_EnumConstantDecl_getSourceRange(CXEnumConstantDecl ECD);

CXEnumConstantDecl clang_EnumConstantDecl_getCanonicalDecl(CXEnumConstantDecl ECD);

// helper
long long clang_EnumConstantDecl_getEnumConstantDeclValue(CXEnumConstantDecl ECD);

// IndirectFieldDecl
CXIndirectFieldDecl clang_IndirectFieldDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// chain

unsigned clang_IndirectFieldDecl_getChainingSize(CXIndirectFieldDecl IFD);

CXFieldDecl clang_IndirectFieldDecl_getAnonField(CXIndirectFieldDecl IFD);

CXVarDecl clang_IndirectFieldDecl_getVarDecl(CXIndirectFieldDecl IFD);

CXIndirectFieldDecl clang_IndirectFieldDecl_getCanonicalDecl(CXIndirectFieldDecl IFD);

// TypeDecl
CXType_ clang_TypeDecl_getTypeForDecl(CXTypeDecl TD);

void clang_TypeDecl_setTypeForDecl(CXTypeDecl TD, CXType_ Ty);

CXSourceLocation_ clang_TypeDecl_getBeginLoc(CXTypeDecl TD);

void clang_TypeDecl_setLocStart(CXTypeDecl TD, CXSourceLocation_ Loc);

// TypedefNameDecl
bool clang_TypedefNameDecl_isModed(CXTypedefNameDecl TND);

CXTypeSourceInfo clang_TypedefNameDecl_getTypeSourceInfo(CXTypedefNameDecl TND);

CXQualType clang_TypedefNameDecl_getUnderlyingType(CXTypedefNameDecl TND);

void clang_TypedefNameDecl_setTypeSourceInfo(CXTypedefNameDecl TND,
                                             CXTypeSourceInfo newType);

void clang_TypedefNameDecl_setModedTypeSourceInfo(CXTypedefNameDecl TND,
                                                  CXTypeSourceInfo unmodedTSI,
                                                  CXQualType modedTy);

CXTypedefNameDecl clang_TypedefNameDecl_getCanonicalDecl(CXTypedefNameDecl TND);

CXTagDecl clang_TypedefNameDecl_getAnonDeclWithTypedefName(CXTypedefNameDecl TND,
                                                           bool AnyRedecl);

bool clang_TypedefNameDecl_isTransparentTag(CXTypedefNameDecl TND);

// TypedefDecl
CXTypedefDecl clang_TypedefDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                       CXIdentifierInfo Id, CXTypeSourceInfo TInfo);

CXTypedefDecl clang_TypedefDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceRange_ clang_TypedefDecl_getSourceRange(CXTypedefDecl TD);

// TypeAliasDecl
CXTypeAliasDecl clang_TypeAliasDecl_Create(CXASTContext C, CXDeclContext DC,
                                           CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXTypeSourceInfo TInfo);

CXTypeAliasDecl clang_TypeAliasDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceRange_ clang_TypeAliasDecl_getSourceRange(CXTypeAliasDecl TAD);

CXTypeAliasTemplateDecl clang_TypeAliasDecl_getDescribedAliasTemplate(CXTypeAliasDecl TAD);

void clang_TypeAliasDecl_setDescribedAliasTemplate(CXTypeAliasDecl TAD,
                                                   CXTypeAliasTemplateDecl TAT);

// TagDecl
CXSourceRange_ clang_TagDecl_getBraceRange(CXTagDecl TD);

void clang_TagDecl_setBraceRange(CXTagDecl TD, CXSourceRange_ R);

CXSourceLocation_ clang_TagDecl_getInnerLocStart(CXTagDecl TD);

CXSourceLocation_ clang_TagDecl_getOuterLocStart(CXTagDecl TD);

CXSourceRange_ clang_TagDecl_getSourceRange(CXTagDecl TD);

CXTagDecl clang_TagDecl_getCanonicalDecl(CXTagDecl TD);

bool clang_TagDecl_isThisDeclarationADefinition(CXTagDecl TD);

bool clang_TagDecl_isCompleteDefinition(CXTagDecl TD);

void clang_TagDecl_setCompleteDefinition(CXTagDecl TD, bool V);

bool clang_TagDecl_isCompleteDefinitionRequired(CXTagDecl TD);

void clang_TagDecl_setCompleteDefinitionRequired(CXTagDecl TD, bool V);

bool clang_TagDecl_isBeingDefined(CXTagDecl TD);

bool clang_TagDecl_isEmbeddedInDeclarator(CXTagDecl TD);

void clang_TagDecl_setEmbeddedInDeclarator(CXTagDecl TD, bool isInDeclarator);

bool clang_TagDecl_isFreeStanding(CXTagDecl TD);

void clang_TagDecl_setFreeStanding(CXTagDecl TD, bool isFreeStanding);

bool clang_TagDecl_mayHaveOutOfDateDef(CXTagDecl TD);

bool clang_TagDecl_isDependentType(CXTagDecl TD);

void clang_TagDecl_startDefinition(CXTagDecl TD);

CXTagDecl clang_TagDecl_getDefinition(CXTagDecl TD);

const char *clang_TagDecl_getKindName(CXTagDecl TD);

CXTagTypeKind clang_TagDecl_getTagKind(CXTagDecl TD);

void clang_TagDecl_setTagKind(CXTagDecl TD, CXTagTypeKind TK);

bool clang_TagDecl_isStruct(CXTagDecl TD);

bool clang_TagDecl_isInterface(CXTagDecl TD);

bool clang_TagDecl_isClass(CXTagDecl TD);

bool clang_TagDecl_isUnion(CXTagDecl TD);

bool clang_TagDecl_isEnum(CXTagDecl TD);

bool clang_TagDecl_hasNameForLinkage(CXTagDecl TD);

CXTypedefNameDecl clang_TagDecl_getTypedefNameForAnonDecl(CXTagDecl TD);

void clang_TagDecl_setTypedefNameForAnonDecl(CXTagDecl TD, CXTypedefNameDecl TDD);

CXNestedNameSpecifier clang_TagDecl_getQualifier(CXTagDecl TD);

// getQualifierLoc
// setQualifierInfo

unsigned clang_TagDecl_getNumTemplateParameterLists(CXTagDecl TD);

CXTemplateParameterList clang_TagDecl_getTemplateParameterList(CXTagDecl TD, unsigned i);

// setTemplateParameterListsInfo

// TagDecl Cast
CXDeclContext clang_TagDecl_castToDeclContext(CXTagDecl TD);

// EnumDecl
CXEnumDecl clang_EnumDecl_Create(CXASTContext C, CXDeclContext DC,
                                 CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                 CXIdentifierInfo Id, CXEnumDecl PrevDecl, bool IsScoped,
                                 bool IsScopedUsingClassTag, bool IsFixed);

CXEnumDecl clang_EnumDecl_CreateDeserialized(CXASTContext C, unsigned ID);

void clang_EnumDecl_setScoped(CXEnumDecl ED, bool Scoped);

void clang_EnumDecl_setScopedUsingClassTag(CXEnumDecl ED, bool ScopedUCT);

void clang_EnumDecl_setFixed(CXEnumDecl ED, bool Fixed);

CXEnumDecl clang_EnumDecl_getCanonicalDecl(CXEnumDecl ED);

CXEnumDecl clang_EnumDecl_getPreviousDecl(CXEnumDecl ED);

CXEnumDecl clang_EnumDecl_getMostRecentDecl(CXEnumDecl ED);

CXEnumDecl clang_EnumDecl_getDefinition(CXEnumDecl ED);

void clang_EnumDecl_completeDefinition(CXEnumDecl ED, CXQualType NewType,
                                       CXQualType PromotionType, unsigned NumPositiveBits,
                                       unsigned NumNegativeBits);

CXQualType clang_EnumDecl_getPromotionType(CXEnumDecl ED);

void clang_EnumDecl_setPromotionType(CXEnumDecl ED, CXQualType T);

CXQualType clang_EnumDecl_getIntegerType(CXEnumDecl ED);

void clang_EnumDecl_setIntegerType(CXEnumDecl ED, CXQualType T);

void clang_EnumDecl_setIntegerTypeSourceInfo(CXEnumDecl ED, CXTypeSourceInfo TInfo);

CXTypeSourceInfo clang_EnumDecl_getIntegerTypeSourceInfo(CXEnumDecl ED);

CXSourceRange_ clang_EnumDecl_getIntegerTypeRange(CXEnumDecl ED);

unsigned clang_EnumDecl_getNumPositiveBits(CXEnumDecl ED);

unsigned clang_EnumDecl_getNumNegativeBits(CXEnumDecl ED);

bool clang_EnumDecl_isScoped(CXEnumDecl ED);

bool clang_EnumDecl_isScopedUsingClassTag(CXEnumDecl ED);

bool clang_EnumDecl_isFixed(CXEnumDecl ED);

unsigned clang_EnumDecl_getODRHash(CXEnumDecl ED);

bool clang_EnumDecl_isComplete(CXEnumDecl ED);

bool clang_EnumDecl_isClosed(CXEnumDecl ED);

bool clang_EnumDecl_isClosedFlag(CXEnumDecl ED);

bool clang_EnumDecl_isClosedNonFlag(CXEnumDecl ED);

CXEnumDecl clang_EnumDecl_getTemplateInstantiationPattern(CXEnumDecl ED);

CXEnumDecl clang_EnumDecl_getInstantiatedFromMemberEnum(CXEnumDecl ED);

CXTemplateSpecializationKind clang_EnumDecl_getTemplateSpecializationKind(CXEnumDecl ED);

void clang_EnumDecl_setTemplateSpecializationKind(CXEnumDecl ED,
                                                  CXTemplateSpecializationKind TSK,
                                                  CXSourceLocation_ PointOfInstantiation);

CXMemberSpecializationInfo clang_EnumDecl_getMemberSpecializationInfo(CXEnumDecl ED);

void clang_EnumDecl_setInstantiationOfMemberEnum(CXEnumDecl ED, CXEnumDecl ED2,
                                                 CXTemplateSpecializationKind TSK);

// RecordDecl
typedef enum CXRecordArgPassingKind : unsigned {
  CXRecordDecl_APK_CanPassInRegs,
  CXRecordDecl_APK_CannotPassInRegs,
  CXRecordDecl_APK_CanNeverPassInRegs
} CXRecordArgPassingKind;

CXRecordDecl clang_RecordDecl_Create(CXASTContext C, CXTagTypeKind TK, CXDeclContext DC,
                                     CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
                                     CXIdentifierInfo Id, CXRecordDecl PrevDecl);

CXRecordDecl clang_RecordDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXRecordDecl clang_RecordDecl_getPreviousDecl(CXRecordDecl RD);

CXRecordDecl clang_RecordDecl_getMostRecentDecl(CXRecordDecl RD);

bool clang_RecordDecl_hasFlexibleArrayMember(CXRecordDecl RD);

void clang_RecordDecl_setHasFlexibleArrayMember(CXRecordDecl RD, bool V);

bool clang_RecordDecl_isAnonymousStructOrUnion(CXRecordDecl RD);

void clang_RecordDecl_setAnonymousStructOrUnion(CXRecordDecl RD, bool Anon);

bool clang_RecordDecl_hasObjectMember(CXRecordDecl RD);

void clang_RecordDecl_setHasObjectMember(CXRecordDecl RD, bool val);

bool clang_RecordDecl_hasVolatileMember(CXRecordDecl RD);

void clang_RecordDecl_setHasVolatileMember(CXRecordDecl RD, bool val);

bool clang_RecordDecl_hasLoadedFieldsFromExternalStorage(CXRecordDecl RD);

void clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(CXRecordDecl RD, bool val);

bool clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD);

void clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(CXRecordDecl RD, bool V);

bool clang_RecordDecl_isNonTrivialToPrimitiveCopy(CXRecordDecl RD);

void clang_RecordDecl_setNonTrivialToPrimitiveCopy(CXRecordDecl RD, bool V);

bool clang_RecordDecl_isNonTrivialToPrimitiveDestroy(CXRecordDecl RD);

void clang_RecordDecl_setNonTrivialToPrimitiveDestroy(CXRecordDecl RD, bool V);

bool clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD);

void clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(CXRecordDecl RD,
                                                                         bool V);

bool clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD);

void clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(CXRecordDecl RD, bool V);

bool clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD);

void clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(CXRecordDecl RD, bool V);

bool clang_RecordDecl_canPassInRegisters(CXRecordDecl RD);

CXRecordArgPassingKind clang_RecordDecl_getArgPassingRestrictions(CXRecordDecl RD);

void clang_RecordDecl_setArgPassingRestrictions(CXRecordDecl RD,
                                                CXRecordArgPassingKind Kind);

bool clang_RecordDecl_isParamDestroyedInCallee(CXRecordDecl RD);

void clang_RecordDecl_setParamDestroyedInCallee(CXRecordDecl RD, bool V);

bool clang_RecordDecl_isInjectedClassName(CXRecordDecl RD);

bool clang_RecordDecl_isLambda(CXRecordDecl RD);

bool clang_RecordDecl_isCapturedRecord(CXRecordDecl RD);

void clang_RecordDecl_setCapturedRecord(CXRecordDecl RD);

CXRecordDecl clang_RecordDecl_getDefinition(CXRecordDecl RD);

bool clang_RecordDecl_isOrContainsUnion(CXRecordDecl RD);

bool clang_RecordDecl_isMsStruct(CXRecordDecl RD, CXASTContext C);

bool clang_RecordDecl_mayInsertExtraPadding(CXRecordDecl RD, bool EmitRemark);

CXFieldDecl clang_RecordDecl_findFirstNamedDataMember(CXRecordDecl RD);

// RecordDecl Cast
CXClassTemplateSpecializationDecl
clang_RecordDecl_castToClassTemplateSpecializationDecl(CXRecordDecl RD);

// FileScopeAsmDecl
CXFileScopeAsmDecl clang_FileScopeAsmDecl_Create(CXASTContext C, CXDeclContext DC,
                                                 CXStringLiteral Str,
                                                 CXSourceLocation_ AsmLoc,
                                                 CXSourceLocation_ RParenLoc);

CXFileScopeAsmDecl clang_FileScopeAsmDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceLocation_ clang_FileScopeAsmDecl_getAsmLoc(CXFileScopeAsmDecl FSAD);

CXSourceLocation_ clang_FileScopeAsmDecl_getRParenLoc(CXFileScopeAsmDecl FSAD);

void clang_FileScopeAsmDecl_setRParenLoc(CXFileScopeAsmDecl FSAD, CXSourceLocation_ L);

CXSourceRange_ clang_FileScopeAsmDecl_getSourceRange(CXFileScopeAsmDecl FSAD);

CXStringLiteral clang_FileScopeAsmDecl_getAsmString(CXFileScopeAsmDecl FSAD);

void clang_FileScopeAsmDecl_setAsmString(CXFileScopeAsmDecl FSAD, CXStringLiteral Asm);

// BlockDecl
CXBlockDecl clang_BlockDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L);

CXBlockDecl clang_BlockDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceLocation_ clang_BlockDecl_getCaretLocation(CXBlockDecl BD);

bool clang_BlockDecl_isVariadic(CXBlockDecl BD);

void clang_BlockDecl_setBody(CXBlockDecl BD, CXCompoundStmt B);

void clang_BlockDecl_setSignatureAsWritten(CXBlockDecl BD, CXTypeSourceInfo Sig);

CXTypeSourceInfo clang_BlockDecl_getSignatureAsWritten(CXBlockDecl BD);

unsigned clang_BlockDecl_getNumParams(CXBlockDecl BD);

CXParmVarDecl clang_BlockDecl_getParamDecl(CXBlockDecl BD, unsigned i);

// setParams

bool clang_BlockDecl_hasCaptures(CXBlockDecl BD);

unsigned clang_BlockDecl_getNumCaptures(CXBlockDecl BD);

bool clang_BlockDecl_capturesCXXThis(CXBlockDecl BD);

void clang_BlockDecl_setCapturesCXXThis(CXBlockDecl BD, bool B);

bool clang_BlockDecl_blockMissingReturnType(CXBlockDecl BD);

void clang_BlockDecl_setBlockMissingReturnType(CXBlockDecl BD, bool val);

bool clang_BlockDecl_isConversionFromLambda(CXBlockDecl BD);

void clang_BlockDecl_setIsConversionFromLambda(CXBlockDecl BD, bool val);

bool clang_BlockDecl_doesNotEscape(CXBlockDecl BD);

void clang_BlockDecl_setDoesNotEscape(CXBlockDecl BD, bool B);

bool clang_BlockDecl_canAvoidCopyToHeap(CXBlockDecl BD);

void clang_BlockDecl_setCanAvoidCopyToHeap(CXBlockDecl BD, bool B);

bool clang_BlockDecl_capturesVariable(CXBlockDecl BD, CXVarDecl var);

// setCaptures

unsigned clang_BlockDecl_getBlockManglingNumber(CXBlockDecl BD);

CXDecl clang_BlockDecl_getBlockManglingContextDecl(CXBlockDecl BD);

void clang_BlockDecl_setBlockMangling(CXBlockDecl BD, unsigned Number, CXDecl Ctx);

CXSourceRange_ clang_BlockDecl_getSourceRange(CXBlockDecl BD);

// CapturedDecl
CXCapturedDecl clang_CapturedDecl_Create(CXASTContext C, CXDeclContext DC,
                                         unsigned NumParams);

CXCapturedDecl clang_CapturedDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                     unsigned NumParams);

CXStmt clang_CapturedDecl_getBody(CXCapturedDecl CD);

void clang_CapturedDecl_setBody(CXCapturedDecl CD, CXStmt B);

bool clang_CapturedDecl_isNothrow(CXCapturedDecl CD);

void clang_CapturedDecl_setNothrow(CXCapturedDecl CD, bool Nothrow);

unsigned clang_CapturedDecl_getNumParams(CXCapturedDecl CD);

CXImplicitParamDecl clang_CapturedDecl_getParam(CXCapturedDecl CD, unsigned i);

void clang_CapturedDecl_setParam(CXCapturedDecl CD, unsigned i, CXImplicitParamDecl P);

CXImplicitParamDecl clang_CapturedDecl_getContextParam(CXCapturedDecl CD);

void clang_CapturedDecl_setContextParam(CXCapturedDecl CD, unsigned i,
                                        CXImplicitParamDecl P);

unsigned clang_CapturedDecl_getContextParamPosition(CXCapturedDecl CD);

// ImportDecl
CXImportDecl clang_ImportDecl_CreateImplicit(CXASTContext C, CXDeclContext DC,
                                             CXSourceLocation_ StartLoc, CXModule Imported,
                                             CXSourceLocation_ EndLoc);

CXImportDecl clang_ImportDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                 unsigned NumLocations);

CXModule clang_ImportDecl_getImportedModule(CXImportDecl ID);

// getIdentifierLocs

CXSourceRange_ clang_ImportDecl_getSourceRange(CXImportDecl ID);

// ExportDecl
CXExportDecl clang_ExportDecl_Create(CXASTContext C, CXDeclContext DC,
                                     CXSourceLocation_ ExportLoc);

CXExportDecl clang_ExportDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXSourceLocation_ clang_ExportDecl_getExportLoc(CXExportDecl ED);

CXSourceLocation_ clang_ExportDecl_getRBraceLoc(CXExportDecl ED);

void clang_ExportDecl_setRBraceLoc(CXExportDecl ED, CXSourceLocation_ L);

bool clang_ExportDecl_hasBraces(CXExportDecl ED);

CXSourceLocation_ clang_ExportDecl_getEndLoc(CXExportDecl ED);

CXSourceRange_ clang_ExportDecl_getSourceRange(CXExportDecl ED);

// EmptyDecl
CXEmptyDecl clang_EmptyDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L);

CXEmptyDecl clang_EmptyDecl_CreateDeserialized(CXASTContext C, unsigned ID);

LLVM_CLANG_C_EXTERN_C_END

#endif