#ifndef LLVM_CLANG_C_EXTRA_CXDECLTEMPLATE_H
#define LLVM_CLANG_C_EXTRA_CXDECLTEMPLATE_H

#include "clang-ex/AST/CXDecl.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"
#include "clang-ex/Basic/CXBuiltins.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// TemplateParameterList
CXSourceRange_ clang_TemplateParameterList_getSourceRange(CXTemplateParameterList L);

// Null when the parameter list carries no requires-clause.
CXExpr clang_TemplateParameterList_getRequiresClause(CXTemplateParameterList L);

bool clang_TemplateParameterList_hasAssociatedConstraints(CXTemplateParameterList L);

// TemplateTemplateParmDecl
unsigned clang_TemplateTemplateParmDecl_getDepth(CXTemplateTemplateParmDecl D);

unsigned clang_TemplateTemplateParmDecl_getIndex(CXTemplateTemplateParmDecl D);

bool clang_TemplateTemplateParmDecl_isParameterPack(CXTemplateTemplateParmDecl D);

bool clang_TemplateTemplateParmDecl_hasDefaultArgument(CXTemplateTemplateParmDecl D);

// TemplateParameterList
CXNamedDecl clang_TemplateParameterList_getParam(CXTemplateParameterList TPL, unsigned Idx);

unsigned clang_TemplateParameterList_size(CXTemplateParameterList TPL);

// TemplateArgumentList
CXTemplateArgumentList clang_TemplateArgumentList_CreateCopy(CXASTContext Context,
                                                             CXTemplateArgument Args,
                                                             size_t ArgNum);

unsigned clang_TemplateArgumentList_size(CXTemplateArgumentList TAL);

CXTemplateArgument clang_TemplateArgumentList_data(CXTemplateArgumentList TAL);

CXTemplateArgument clang_TemplateArgumentList_get(CXTemplateArgumentList TAL, unsigned Idx);

// TemplateDecl
// void clang_TemplateDecl_init(CXTemplateDecl TD, CXNamedDecl ND, CXTemplateParameterList
// TP);

// RedeclarableTemplateDecl
CXRedeclarableTemplateDecl
clang_RedeclarableTemplateDecl_getCanonicalDecl(CXRedeclarableTemplateDecl RTD);

bool clang_RedeclarableTemplateDecl_isMemberSpecialization(CXRedeclarableTemplateDecl RTD);

void clang_RedeclarableTemplateDecl_setMemberSpecialization(CXRedeclarableTemplateDecl RTD);

// ClassTemplateDecl
CXCXXRecordDecl clang_ClassTemplateDecl_getTemplatedDecl(CXClassTemplateDecl CTD);

bool clang_ClassTemplateDecl_isThisDeclarationADefinition(CXClassTemplateDecl CTD);

CXClassTemplateSpecializationDecl
clang_ClassTemplateDecl_findSpecialization(CXClassTemplateDecl CTD,
                                           CXTemplateArgumentList TAL, void *InsertPos);

void clang_ClassTemplateDecl_AddSpecialization(CXClassTemplateDecl CTD,
                                               CXClassTemplateSpecializationDecl CTSD,
                                               void *InsertPos);

CXClassTemplateDecl clang_ClassTemplateDecl_getCanonicalDecl(CXClassTemplateDecl CTD);

CXClassTemplateDecl clang_ClassTemplateDecl_getPreviousDecl(CXClassTemplateDecl CTD);

CXClassTemplateDecl clang_ClassTemplateDecl_getMostRecentDecl(CXClassTemplateDecl CTD);

// ClassTemplateSpecializationDecl
CXClassTemplateSpecializationDecl clang_ClassTemplateSpecializationDecl_Create(
    CXASTContext Context, CXTagTypeKind TK, CXDeclContext DC, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXClassTemplateDecl SpecializedTemplate,
    CXTemplateArgumentList Args, CXClassTemplateSpecializationDecl PrevDecl);

CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD);

void clang_ClassTemplateSpecializationDecl_setTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD, CXTemplateArgumentList TAL);

// TemplateDecl navigation
CXNamedDecl clang_TemplateDecl_getTemplatedDecl(CXTemplateDecl TD);

CXTemplateParameterList clang_TemplateDecl_getTemplateParameters(CXTemplateDecl TD);

// TemplateParameterList
unsigned clang_TemplateParameterList_getDepth(CXTemplateParameterList L);

unsigned clang_TemplateParameterList_getMinRequiredArguments(CXTemplateParameterList L);

bool clang_TemplateParameterList_hasParameterPack(CXTemplateParameterList L);

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_wasDeclaredWithTypename(CXTemplateTypeParmDecl D);

bool clang_TemplateTypeParmDecl_hasDefaultArgument(CXTemplateTypeParmDecl D);

// Precondition: hasDefaultArgument() — the body dereferences the stored
// TypeSourceInfo, which is null when no default argument was written.
CXQualType clang_TemplateTypeParmDecl_getDefaultArgument(CXTemplateTypeParmDecl D);

bool clang_TemplateTypeParmDecl_defaultArgumentWasInherited(CXTemplateTypeParmDecl D);

bool clang_TemplateTypeParmDecl_isExpandedParameterPack(CXTemplateTypeParmDecl D);

// Precondition: isExpandedParameterPack().
unsigned clang_TemplateTypeParmDecl_getNumExpansionParameters(CXTemplateTypeParmDecl D);

bool clang_TemplateTypeParmDecl_hasTypeConstraint(CXTemplateTypeParmDecl D);
unsigned clang_TemplateTypeParmDecl_getDepth(CXTemplateTypeParmDecl D);

unsigned clang_TemplateTypeParmDecl_getIndex(CXTemplateTypeParmDecl D);

bool clang_TemplateTypeParmDecl_isParameterPack(CXTemplateTypeParmDecl D);

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_hasDefaultArgument(CXNonTypeTemplateParmDecl D);

// Null when the parameter has no default argument.
CXExpr clang_NonTypeTemplateParmDecl_getDefaultArgument(CXNonTypeTemplateParmDecl D);

bool clang_NonTypeTemplateParmDecl_isExpandedParameterPack(CXNonTypeTemplateParmDecl D);

// Precondition: isExpandedParameterPack().
unsigned clang_NonTypeTemplateParmDecl_getNumExpansionTypes(CXNonTypeTemplateParmDecl D);

// Precondition: isExpandedParameterPack() and I < getNumExpansionTypes().
CXQualType clang_NonTypeTemplateParmDecl_getExpansionType(CXNonTypeTemplateParmDecl D,
                                                          unsigned I);

bool clang_NonTypeTemplateParmDecl_hasPlaceholderTypeConstraint(
    CXNonTypeTemplateParmDecl D);
unsigned clang_NonTypeTemplateParmDecl_getDepth(CXNonTypeTemplateParmDecl D);

unsigned clang_NonTypeTemplateParmDecl_getIndex(CXNonTypeTemplateParmDecl D);

bool clang_NonTypeTemplateParmDecl_isParameterPack(CXNonTypeTemplateParmDecl D);

// ClassTemplateSpecializationDecl navigation
CXClassTemplateDecl
clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(CXClassTemplateSpecializationDecl D);

// PointerUnion split: the raw arm pointer, discriminated by the companion
// predicate — CXClassTemplatePartialSpecializationDecl when specializedOnPartial
// is true, CXClassTemplateDecl otherwise. The arm pointer is returned untouched
// (no base-class adjustment), so the caller wraps it at the exact arm type.
CXDecl clang_ClassTemplateSpecializationDecl_getSpecializedTemplateOrPartial(
    CXClassTemplateSpecializationDecl D);

bool clang_ClassTemplateSpecializationDecl_specializedOnPartial(
    CXClassTemplateSpecializationDecl D);

CXTemplateSpecializationKind
clang_ClassTemplateSpecializationDecl_getSpecializationKind(CXClassTemplateSpecializationDecl D);

// VarTemplateSpecializationDecl
// Borrowed interior reference to the specialization's argument list (no dispose).
CXTemplateArgumentList clang_VarTemplateSpecializationDecl_getTemplateArgs(
    CXVarTemplateSpecializationDecl VTSD);

// RedeclarableTemplateDecl
// The member template this was instantiated from, or null when this template is
// not an instantiated member. The shared base covers every redeclarable template.
CXRedeclarableTemplateDecl clang_RedeclarableTemplateDecl_getInstantiatedFromMemberTemplate(
    CXRedeclarableTemplateDecl RTD);

// FunctionTemplateDecl
CXFunctionDecl clang_FunctionTemplateDecl_getTemplatedDecl(CXFunctionTemplateDecl FTD);

bool clang_FunctionTemplateDecl_isThisDeclarationADefinition(CXFunctionTemplateDecl FTD);

bool clang_FunctionTemplateDecl_isAbbreviated(CXFunctionTemplateDecl FTD);

// TypeAliasTemplateDecl
CXTypeAliasDecl clang_TypeAliasTemplateDecl_getTemplatedDecl(CXTypeAliasTemplateDecl TATD);

// VarTemplateDecl
CXVarDecl clang_VarTemplateDecl_getTemplatedDecl(CXVarTemplateDecl VTD);

bool clang_VarTemplateDecl_isThisDeclarationADefinition(CXVarTemplateDecl VTD);

// ClassTemplatePartialSpecializationDecl
CXTemplateParameterList clang_ClassTemplatePartialSpecializationDecl_getTemplateParameters(
    CXClassTemplatePartialSpecializationDecl D);

bool clang_ClassTemplatePartialSpecializationDecl_hasAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D);

CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMember(
    CXClassTemplatePartialSpecializationDecl D);

bool clang_ClassTemplatePartialSpecializationDecl_isMemberSpecialization(
    CXClassTemplatePartialSpecializationDecl D);

// TemplateParameterList
CXSourceLocation_ clang_TemplateParameterList_getTemplateLoc(CXTemplateParameterList L);

CXSourceLocation_ clang_TemplateParameterList_getLAngleLoc(CXTemplateParameterList L);

CXSourceLocation_ clang_TemplateParameterList_getRAngleLoc(CXTemplateParameterList L);

// ClassTemplateSpecializationDecl
CXClassTemplateSpecializationDecl clang_ClassTemplateSpecializationDecl_getMostRecentDecl(
    CXClassTemplateSpecializationDecl D);

CXSourceLocation_ clang_ClassTemplateSpecializationDecl_getPointOfInstantiation(
    CXClassTemplateSpecializationDecl D);

bool clang_ClassTemplateSpecializationDecl_isExplicitSpecialization(
    CXClassTemplateSpecializationDecl D);

bool clang_ClassTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(
    CXClassTemplateSpecializationDecl D);

// VarTemplateSpecializationDecl
CXVarTemplateSpecializationDecl
clang_VarTemplateSpecializationDecl_getMostRecentDecl(CXVarTemplateSpecializationDecl D);

CXVarTemplateDecl clang_VarTemplateSpecializationDecl_getSpecializedTemplate(
    CXVarTemplateSpecializationDecl D);

CXTemplateSpecializationKind clang_VarTemplateSpecializationDecl_getSpecializationKind(
    CXVarTemplateSpecializationDecl D);

bool clang_VarTemplateSpecializationDecl_isExplicitSpecialization(
    CXVarTemplateSpecializationDecl D);

bool clang_VarTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(
    CXVarTemplateSpecializationDecl D);

CXSourceLocation_ clang_VarTemplateSpecializationDecl_getPointOfInstantiation(
    CXVarTemplateSpecializationDecl D);

// PointerUnion split: the raw arm pointer, discriminated by the companion
// predicate — CXVarTemplatePartialSpecializationDecl when specializedOnPartial
// is true, CXVarTemplateDecl otherwise. The arm pointer is returned untouched
// (no base-class adjustment), so the caller wraps it at the exact arm type.
CXDecl clang_VarTemplateSpecializationDecl_getSpecializedTemplateOrPartial(
    CXVarTemplateSpecializationDecl D);

bool clang_VarTemplateSpecializationDecl_specializedOnPartial(
    CXVarTemplateSpecializationDecl D);

CXSourceLocation_
clang_VarTemplateSpecializationDecl_getExternLoc(CXVarTemplateSpecializationDecl D);

CXSourceLocation_ clang_VarTemplateSpecializationDecl_getTemplateKeywordLoc(
    CXVarTemplateSpecializationDecl D);

// ConceptDecl
CXExpr clang_ConceptDecl_getConstraintExpr(CXConceptDecl D);

bool clang_ConceptDecl_isTypeConcept(CXConceptDecl D);

CXConceptDecl clang_ConceptDecl_getCanonicalDecl(CXConceptDecl D);

// getSourceRange reads the constraint-expression's end location; valid for any
// parsed concept (ConstraintExpr is set at construction).
CXSourceRange_ clang_ConceptDecl_getSourceRange(CXConceptDecl D);

// TemplateDecl
bool clang_TemplateDecl_hasAssociatedConstraints(CXTemplateDecl TD);

bool clang_TemplateDecl_isTypeAlias(CXTemplateDecl TD);

// ClassTemplateSpecializationDecl
bool clang_ClassTemplateSpecializationDecl_isClassScopeExplicitSpecialization(
    CXClassTemplateSpecializationDecl D);

// Borrowed interior reference to the deduced instantiation arguments (no
// dispose). Falls back to the specialization's own argument list when this was
// not instantiated from a partial specialization.
CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateInstantiationArgs(
    CXClassTemplateSpecializationDecl D);

// Null when the specialization type was not written by the user.
CXTypeSourceInfo
clang_ClassTemplateSpecializationDecl_getTypeAsWritten(CXClassTemplateSpecializationDecl D);

CXSourceLocation_
clang_ClassTemplateSpecializationDecl_getExternLoc(CXClassTemplateSpecializationDecl D);

CXSourceLocation_ clang_ClassTemplateSpecializationDecl_getTemplateKeywordLoc(
    CXClassTemplateSpecializationDecl D);

CXSourceRange_
clang_ClassTemplateSpecializationDecl_getSourceRange(CXClassTemplateSpecializationDecl D);

// VarTemplateSpecializationDecl
bool clang_VarTemplateSpecializationDecl_isClassScopeExplicitSpecialization(
    CXVarTemplateSpecializationDecl D);

// Borrowed interior reference to the deduced instantiation arguments (no
// dispose).
CXTemplateArgumentList clang_VarTemplateSpecializationDecl_getTemplateInstantiationArgs(
    CXVarTemplateSpecializationDecl D);

// Null when the specialization type was not written by the user.
CXTypeSourceInfo
clang_VarTemplateSpecializationDecl_getTypeAsWritten(CXVarTemplateSpecializationDecl D);

CXSourceRange_
clang_VarTemplateSpecializationDecl_getSourceRange(CXVarTemplateSpecializationDecl D);

// VarTemplatePartialSpecializationDecl
CXTemplateParameterList clang_VarTemplatePartialSpecializationDecl_getTemplateParameters(
    CXVarTemplatePartialSpecializationDecl D);

bool clang_VarTemplatePartialSpecializationDecl_hasAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D);

CXVarTemplatePartialSpecializationDecl
clang_VarTemplatePartialSpecializationDecl_getInstantiatedFromMember(
    CXVarTemplatePartialSpecializationDecl D);

bool clang_VarTemplatePartialSpecializationDecl_isMemberSpecialization(
    CXVarTemplatePartialSpecializationDecl D);

// MemberSpecializationInfo
CXNamedDecl
clang_MemberSpecializationInfo_getInstantiatedFrom(CXMemberSpecializationInfo MSI);

CXTemplateSpecializationKind clang_MemberSpecializationInfo_getTemplateSpecializationKind(
    CXMemberSpecializationInfo MSI);

bool clang_MemberSpecializationInfo_isExplicitSpecialization(
    CXMemberSpecializationInfo MSI);

// An invalid location means this member has not been instantiated yet.
CXSourceLocation_
clang_MemberSpecializationInfo_getPointOfInstantiation(CXMemberSpecializationInfo MSI);

// FunctionTemplateSpecializationInfo
CXFunctionDecl clang_FunctionTemplateSpecializationInfo_getFunction(
    CXFunctionTemplateSpecializationInfo FTSI);

CXFunctionTemplateDecl clang_FunctionTemplateSpecializationInfo_getTemplate(
    CXFunctionTemplateSpecializationInfo FTSI);

CXTemplateSpecializationKind
clang_FunctionTemplateSpecializationInfo_getTemplateSpecializationKind(
    CXFunctionTemplateSpecializationInfo FTSI);

bool clang_FunctionTemplateSpecializationInfo_isExplicitSpecialization(
    CXFunctionTemplateSpecializationInfo FTSI);

bool clang_FunctionTemplateSpecializationInfo_isExplicitInstantiationOrSpecialization(
    CXFunctionTemplateSpecializationInfo FTSI);

// An invalid location means this specialization has not been instantiated yet.
CXSourceLocation_ clang_FunctionTemplateSpecializationInfo_getPointOfInstantiation(
    CXFunctionTemplateSpecializationInfo FTSI);

// Null unless this function template specialization is also a member
// specialization of a class-template member.
CXMemberSpecializationInfo
clang_FunctionTemplateSpecializationInfo_getMemberSpecializationInfo(
    CXFunctionTemplateSpecializationInfo FTSI);

// TemplateTemplateParmDecl
bool clang_TemplateTemplateParmDecl_isPackExpansion(CXTemplateTemplateParmDecl D);

bool clang_TemplateTemplateParmDecl_isExpandedParameterPack(CXTemplateTemplateParmDecl D);

// Precondition: isExpandedParameterPack().
unsigned clang_TemplateTemplateParmDecl_getNumExpansionTemplateParameters(
    CXTemplateTemplateParmDecl D);

// Precondition: isExpandedParameterPack() and I <
// getNumExpansionTemplateParameters().
CXTemplateParameterList
clang_TemplateTemplateParmDecl_getExpansionTemplateParameters(CXTemplateTemplateParmDecl D,
                                                              unsigned I);

// An invalid location when no default argument was written.
CXSourceLocation_
clang_TemplateTemplateParmDecl_getDefaultArgumentLoc(CXTemplateTemplateParmDecl D);

bool clang_TemplateTemplateParmDecl_defaultArgumentWasInherited(
    CXTemplateTemplateParmDecl D);

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_defaultArgumentWasInherited(CXNonTypeTemplateParmDecl D);

bool clang_NonTypeTemplateParmDecl_isPackExpansion(CXNonTypeTemplateParmDecl D);

// Null when the parameter's type carries no constrained placeholder.
CXExpr
clang_NonTypeTemplateParmDecl_getPlaceholderTypeConstraint(CXNonTypeTemplateParmDecl D);

// FunctionTemplateDecl
CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getCanonicalDecl(CXFunctionTemplateDecl FTD);

// Null when this is the first declaration of the function template.
CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getPreviousDecl(CXFunctionTemplateDecl FTD);

CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getMostRecentDecl(CXFunctionTemplateDecl FTD);

// ClassTemplatePartialSpecializationDecl
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getMostRecentDecl(
    CXClassTemplatePartialSpecializationDecl D);

// Null when no as-written argument list was recorded.
CXASTTemplateArgumentListInfo
clang_ClassTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(
    CXClassTemplatePartialSpecializationDecl D);

// Precondition: getTypeForDecl() is set and is an InjectedClassNameType — the
// body asserts the former and reaches the latter through an unchecked cast.
CXQualType clang_ClassTemplatePartialSpecializationDecl_getInjectedSpecializationType(
    CXClassTemplatePartialSpecializationDecl D);

// ClassTemplateDecl
// Count for the getPartialSpecializations fill below; the count is exact and no
// slot is null.
unsigned clang_ClassTemplateDecl_getNumPartialSpecializations(CXClassTemplateDecl CTD);

// Fills exactly getNumPartialSpecializations entries into PS, in source order.
void clang_ClassTemplateDecl_getPartialSpecializations(
    CXClassTemplateDecl CTD, CXClassTemplatePartialSpecializationDecl *PS);

// Null when no partial specialization's injected specialization type matches T.
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplateDecl_findPartialSpecialization(CXClassTemplateDecl CTD, CXQualType T);

CXQualType
clang_ClassTemplateDecl_getInjectedClassNameSpecialization(CXClassTemplateDecl CTD);

// TypeAliasTemplateDecl
CXTypeAliasTemplateDecl
clang_TypeAliasTemplateDecl_getCanonicalDecl(CXTypeAliasTemplateDecl TATD);

// Null when this is the first declaration of the alias template.
CXTypeAliasTemplateDecl
clang_TypeAliasTemplateDecl_getPreviousDecl(CXTypeAliasTemplateDecl TATD);

// VarTemplateSpecializationDecl
// Null when no as-written argument list was recorded.
CXASTTemplateArgumentListInfo
clang_VarTemplateSpecializationDecl_getTemplateArgsInfo(CXVarTemplateSpecializationDecl D);

// VarTemplatePartialSpecializationDecl
// Null when no as-written argument list was recorded.
CXASTTemplateArgumentListInfo
clang_VarTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(
    CXVarTemplatePartialSpecializationDecl D);

// VarTemplateDecl
// Null when no declaration in the redeclaration chain is a definition.
CXVarTemplateDecl clang_VarTemplateDecl_getDefinition(CXVarTemplateDecl VTD);

CXVarTemplateDecl clang_VarTemplateDecl_getCanonicalDecl(CXVarTemplateDecl VTD);

// Null when this is the first declaration of the variable template.
CXVarTemplateDecl clang_VarTemplateDecl_getPreviousDecl(CXVarTemplateDecl VTD);

CXVarTemplateDecl clang_VarTemplateDecl_getMostRecentDecl(CXVarTemplateDecl VTD);

// Count for the getPartialSpecializations fill below; the count is exact and no
// slot is null.
unsigned clang_VarTemplateDecl_getNumPartialSpecializations(CXVarTemplateDecl VTD);

// Fills exactly getNumPartialSpecializations entries into PS, in source order.
void clang_VarTemplateDecl_getPartialSpecializations(
    CXVarTemplateDecl VTD, CXVarTemplatePartialSpecializationDecl *PS);

// TemplateParameterList
bool clang_TemplateParameterList_containsUnexpandedParameterPack(
    CXTemplateParameterList TPL);

// Count for the getAssociatedConstraints fill below; the count is exact and no
// slot is null.
unsigned
clang_TemplateParameterList_getNumAssociatedConstraints(CXTemplateParameterList TPL);

// Fills exactly getNumAssociatedConstraints entries into AC, in declaration order.
void clang_TemplateParameterList_getAssociatedConstraints(CXTemplateParameterList TPL,
                                                          CXExpr *AC);

// TemplateDecl
// Count for the getAssociatedConstraints fill below; the count is exact and no
// slot is null.
unsigned clang_TemplateDecl_getNumAssociatedConstraints(CXTemplateDecl TD);

// Fills exactly getNumAssociatedConstraints entries into AC, in declaration order.
void clang_TemplateDecl_getAssociatedConstraints(CXTemplateDecl TD, CXExpr *AC);

// RedeclarableTemplateDecl
// Count for the getInjectedTemplateArg index accessor below. The argument array
// is computed once and cached on the template's shared common state.
unsigned
clang_RedeclarableTemplateDecl_getNumInjectedTemplateArgs(CXRedeclarableTemplateDecl RTD);

// Borrowed interior pointer into the cached injected-argument array (no dispose,
// unlike the heap-boxed TemplateArgument returned by the construct* helpers).
// Precondition: I < getNumInjectedTemplateArgs().
CXTemplateArgument
clang_RedeclarableTemplateDecl_getInjectedTemplateArg(CXRedeclarableTemplateDecl RTD,
                                                      unsigned I);

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_isPackExpansion(CXTemplateTypeParmDecl D);

// An invalid location when no default argument was written.
CXSourceLocation_
clang_TemplateTypeParmDecl_getDefaultArgumentLoc(CXTemplateTypeParmDecl D);

// NonTypeTemplateParmDecl
// An invalid location when no default argument was written.
CXSourceLocation_
clang_NonTypeTemplateParmDecl_getDefaultArgumentLoc(CXNonTypeTemplateParmDecl D);

// TemplateTemplateParmDecl
// Borrowed interior reference (no dispose). When hasDefaultArgument() is false
// this is a shared empty TemplateArgumentLoc, never null.
CXTemplateArgumentLoc
clang_TemplateTemplateParmDecl_getDefaultArgument(CXTemplateTemplateParmDecl D);

// BuiltinTemplateDecl
CXBuiltinTemplateKind
clang_BuiltinTemplateDecl_getBuiltinTemplateKind(CXBuiltinTemplateDecl D);

// TemplateParamObjectDecl
// Borrowed interior reference to the object's value (no dispose).
CXAPValue clang_TemplateParamObjectDecl_getValue(CXTemplateParamObjectDecl D);

CXString clang_TemplateParamObjectDecl_printAsExpr(CXTemplateParamObjectDecl D);

CXString clang_TemplateParamObjectDecl_printAsInit(CXTemplateParamObjectDecl D);

CXTemplateParamObjectDecl
clang_TemplateParamObjectDecl_getCanonicalDecl(CXTemplateParamObjectDecl D);

// ClassTemplateDecl
// Null when this class template is not an instantiated member template.
CXClassTemplateDecl
clang_ClassTemplateDecl_getInstantiatedFromMemberTemplate(CXClassTemplateDecl CTD);

// ClassTemplatePartialSpecializationDecl
// Null when this partial specialization is not an instantiated member.
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMemberTemplate(
    CXClassTemplatePartialSpecializationDecl D);

// FunctionTemplateDecl
// Null when this function template is not an instantiated member template.
CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getInstantiatedFromMemberTemplate(CXFunctionTemplateDecl FTD);

// TypeAliasTemplateDecl
// Null when this alias template is not an instantiated member template.
CXTypeAliasTemplateDecl
clang_TypeAliasTemplateDecl_getInstantiatedFromMemberTemplate(CXTypeAliasTemplateDecl TATD);

// VarTemplateDecl
// Null when this variable template is not an instantiated member template.
CXVarTemplateDecl
clang_VarTemplateDecl_getInstantiatedFromMemberTemplate(CXVarTemplateDecl VTD);

// VarTemplatePartialSpecializationDecl
CXVarTemplatePartialSpecializationDecl
clang_VarTemplatePartialSpecializationDecl_getMostRecentDecl(
    CXVarTemplatePartialSpecializationDecl D);

// TemplateParameterList
// Renders the list as source text ("template <typename T, int N = 3>") using the
// context's default printing policy. OmitTemplateKW drops the leading 'template'
// keyword and keeps the angle-bracketed parameters.
CXString clang_TemplateParameterList_print(CXTemplateParameterList TPL,
                                           CXASTContext Context, bool OmitTemplateKW);

// FunctionTemplateDecl
// Pulls in specializations an external AST source (PCH/module file) is still
// holding lazily; a no-op when the translation unit has no external source.
void clang_FunctionTemplateDecl_LoadLazySpecializations(CXFunctionTemplateDecl FTD);

// Count for the getSpecializations fill below; the count is exact and no slot is
// null.
unsigned clang_FunctionTemplateDecl_getNumSpecializations(CXFunctionTemplateDecl FTD);

// Fills exactly getNumSpecializations entries into S, in the specialization set's
// own order. Each entry is the most recent redeclaration of that specialization.
void clang_FunctionTemplateDecl_getSpecializations(CXFunctionTemplateDecl FTD,
                                                   CXFunctionDecl *S);

// TemplateTypeParmDecl
// Null when the parameter has no default argument (the storage is default-
// constructed to a null TypeSourceInfo, so this never dereferences).
CXTypeSourceInfo
clang_TemplateTypeParmDecl_getDefaultArgumentInfo(CXTemplateTypeParmDecl D);

void clang_TemplateTypeParmDecl_setDeclaredWithTypename(CXTemplateTypeParmDecl D,
                                                        bool WithTypename);

// NonTypeTemplateParmDecl
// Same stored field as getIndex — both read TemplateParmPosition::Position.
unsigned clang_NonTypeTemplateParmDecl_getPosition(CXNonTypeTemplateParmDecl D);

// Precondition: isExpandedParameterPack() and I < getNumExpansionTypes().
CXTypeSourceInfo
clang_NonTypeTemplateParmDecl_getExpansionTypeSourceInfo(CXNonTypeTemplateParmDecl D,
                                                         unsigned I);

// TemplateTemplateParmDecl
// Same stored field as getIndex — both read TemplateParmPosition::Position.
unsigned clang_TemplateTemplateParmDecl_getPosition(CXTemplateTemplateParmDecl D);

// ClassTemplateDecl
// Pulls in specializations an external AST source (PCH/module file) is still
// holding lazily; a no-op when the translation unit has no external source.
void clang_ClassTemplateDecl_LoadLazySpecializations(CXClassTemplateDecl CTD);

// Count for the getSpecializations fill below; the count is exact and no slot is
// null.
unsigned clang_ClassTemplateDecl_getNumSpecializations(CXClassTemplateDecl CTD);

// Fills exactly getNumSpecializations entries into S, in the specialization set's
// own order. Each entry is the most recent redeclaration of that specialization.
void clang_ClassTemplateDecl_getSpecializations(CXClassTemplateDecl CTD,
                                                CXClassTemplateSpecializationDecl *S);

// VarTemplateDecl
// Pulls in specializations an external AST source (PCH/module file) is still
// holding lazily; a no-op when the translation unit has no external source.
void clang_VarTemplateDecl_LoadLazySpecializations(CXVarTemplateDecl VTD);

// Count for the getSpecializations fill below; the count is exact and no slot is
// null.
unsigned clang_VarTemplateDecl_getNumSpecializations(CXVarTemplateDecl VTD);

// Fills exactly getNumSpecializations entries into S, in the specialization set's
// own order. Each entry is the most recent redeclaration of that specialization.
void clang_VarTemplateDecl_getSpecializations(CXVarTemplateDecl VTD,
                                              CXVarTemplateSpecializationDecl *S);

LLVM_CLANG_C_EXTERN_C_END

#endif
