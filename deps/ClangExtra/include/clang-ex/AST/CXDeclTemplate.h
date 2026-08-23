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

CXSourceLocation_ clang_VarTemplateSpecializationDecl_getExternLoc(
    CXVarTemplateSpecializationDecl D);

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

// getTypeAsWritten

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

// TemplateDecl
// Re-seats the parameter list; the list is borrowed (stored as-is, never copied).
void clang_TemplateDecl_setTemplateParameters(CXTemplateDecl TD,
                                              CXTemplateParameterList TPL);

// FunctionTemplateSpecializationInfo
// Precondition: TSK is not CXTemplateSpecializationKind_TSK_Undeclared — the info
// object encodes TSK - 1 in a two-bit field and asserts on the undeclared value.
void clang_FunctionTemplateSpecializationInfo_setTemplateSpecializationKind(
    CXFunctionTemplateSpecializationInfo FTSI, CXTemplateSpecializationKind TSK);

void clang_FunctionTemplateSpecializationInfo_setPointOfInstantiation(
    CXFunctionTemplateSpecializationInfo FTSI, CXSourceLocation_ POI);

// MemberSpecializationInfo
// Precondition: TSK is not CXTemplateSpecializationKind_TSK_Undeclared — the info
// object encodes TSK - 1 in a two-bit field and asserts on the undeclared value.
void clang_MemberSpecializationInfo_setTemplateSpecializationKind(
    CXMemberSpecializationInfo MSI, CXTemplateSpecializationKind TSK);

void clang_MemberSpecializationInfo_setPointOfInstantiation(CXMemberSpecializationInfo MSI,
                                                            CXSourceLocation_ POI);

// TemplateTypeParmDecl
// Precondition: !hasDefaultArgument() — DefaultArgStorage::set asserts the slot is
// still unset, so replacing an existing default needs removeDefaultArgument first.
void clang_TemplateTypeParmDecl_setDefaultArgument(CXTemplateTypeParmDecl D,
                                                   CXTypeSourceInfo DefArg);

void clang_TemplateTypeParmDecl_removeDefaultArgument(CXTemplateTypeParmDecl D);

// NonTypeTemplateParmDecl
// Precondition: !hasDefaultArgument() — DefaultArgStorage::set asserts the slot is
// still unset, so replacing an existing default needs removeDefaultArgument first.
void clang_NonTypeTemplateParmDecl_setDefaultArgument(CXNonTypeTemplateParmDecl D,
                                                      CXExpr DefArg);

void clang_NonTypeTemplateParmDecl_removeDefaultArgument(CXNonTypeTemplateParmDecl D);

// TemplateTemplateParmDecl
// Copies DefArg into Context-owned storage, so the caller's handle stays its own.
// Precondition: !hasDefaultArgument() — same DefaultArgStorage assert as above.
void clang_TemplateTemplateParmDecl_setDefaultArgument(CXTemplateTemplateParmDecl D,
                                                       CXASTContext Context,
                                                       CXTemplateArgumentLoc DefArg);

void clang_TemplateTemplateParmDecl_removeDefaultArgument(CXTemplateTemplateParmDecl D);

// ClassTemplateSpecializationDecl
// Overwrites the specialized-template slot with a plain ClassTemplateDecl, dropping
// any stored partial-specialization + deduced-argument pair. Precondition:
// !specializedOnPartial().
void clang_ClassTemplateSpecializationDecl_setSpecializedTemplate(
    CXClassTemplateSpecializationDecl D, CXClassTemplateDecl CTD);

void clang_ClassTemplateSpecializationDecl_setSpecializationKind(
    CXClassTemplateSpecializationDecl D, CXTemplateSpecializationKind TSK);

// Precondition: Loc is valid — Clang asserts on an invalid point of instantiation.
void clang_ClassTemplateSpecializationDecl_setPointOfInstantiation(
    CXClassTemplateSpecializationDecl D, CXSourceLocation_ Loc);

void clang_ClassTemplateSpecializationDecl_setExternLoc(CXClassTemplateSpecializationDecl D,
                                                        CXSourceLocation_ Loc);

// Allocates the explicit-specialization info block in the ASTContext on first use;
// any location, including an invalid one, is accepted.
void clang_ClassTemplateSpecializationDecl_setTemplateKeywordLoc(
    CXClassTemplateSpecializationDecl D, CXSourceLocation_ Loc);

// VarTemplateSpecializationDecl
void clang_VarTemplateSpecializationDecl_setSpecializationKind(
    CXVarTemplateSpecializationDecl D, CXTemplateSpecializationKind TSK);

// Precondition: Loc is valid — Clang asserts on an invalid point of instantiation.
void clang_VarTemplateSpecializationDecl_setPointOfInstantiation(
    CXVarTemplateSpecializationDecl D, CXSourceLocation_ Loc);

void clang_VarTemplateSpecializationDecl_setExternLoc(CXVarTemplateSpecializationDecl D,
                                                      CXSourceLocation_ Loc);

// Allocates the explicit-specialization info block in the ASTContext on first use;
// any location, including an invalid one, is accepted.
void clang_VarTemplateSpecializationDecl_setTemplateKeywordLoc(
    CXVarTemplateSpecializationDecl D, CXSourceLocation_ Loc);

// TemplateParameterList
// Runs Clang's static printer predicate with Context's default printing policy.
// Total: a NULL list or an Idx past the end of the list both answer true, which is
// Clang's own guard, not UB.
bool clang_TemplateParameterList_shouldIncludeTypeForArgument(CXTemplateParameterList TPL,
                                                              CXASTContext Context,
                                                              unsigned Idx);

// TemplateDecl
CXSourceRange_ clang_TemplateDecl_getSourceRange(CXTemplateDecl TD);

// RedeclarableTemplateDecl
// Precondition: getInstantiatedFromMemberTemplate() is null — Clang asserts the slot
// is still unset, so the link can be established only once.
void clang_RedeclarableTemplateDecl_setInstantiatedFromMemberTemplate(
    CXRedeclarableTemplateDecl RTD, CXRedeclarableTemplateDecl TD);

// TemplateTypeParmDecl
// Count for the getAssociatedConstraints fill below: 1 when the parameter carries a
// type-constraint, 0 otherwise.
unsigned clang_TemplateTypeParmDecl_getNumAssociatedConstraints(CXTemplateTypeParmDecl D);

// Fills exactly getNumAssociatedConstraints entries into AC; no slot is null.
void clang_TemplateTypeParmDecl_getAssociatedConstraints(CXTemplateTypeParmDecl D,
                                                         CXExpr *AC);

CXSourceRange_ clang_TemplateTypeParmDecl_getSourceRange(CXTemplateTypeParmDecl D);

// NonTypeTemplateParmDecl
// Count for the getAssociatedConstraints fill below: 1 when the parameter's type is a
// constrained placeholder, 0 otherwise.
unsigned
clang_NonTypeTemplateParmDecl_getNumAssociatedConstraints(CXNonTypeTemplateParmDecl D);

// Fills exactly getNumAssociatedConstraints entries into AC; no slot is null.
void clang_NonTypeTemplateParmDecl_getAssociatedConstraints(CXNonTypeTemplateParmDecl D,
                                                            CXExpr *AC);

CXSourceRange_ clang_NonTypeTemplateParmDecl_getSourceRange(CXNonTypeTemplateParmDecl D);

// TemplateTemplateParmDecl
CXSourceRange_ clang_TemplateTemplateParmDecl_getSourceRange(CXTemplateTemplateParmDecl D);

// BuiltinTemplateDecl
// Always an invalid range: a builtin template declaration has no written source.
CXSourceRange_ clang_BuiltinTemplateDecl_getSourceRange(CXBuiltinTemplateDecl D);

// setTypeAsWritten

// ClassTemplatePartialSpecializationDecl
// Count for the getAssociatedConstraints fill below; the count is exact and no slot
// is null.
unsigned clang_ClassTemplatePartialSpecializationDecl_getNumAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D);

// Fills exactly getNumAssociatedConstraints entries into AC, in declaration order.
void clang_ClassTemplatePartialSpecializationDecl_getAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D, CXExpr *AC);

// Re-seats, on the first declaration of the redeclaration chain, the member partial
// specialization this one was instantiated from. No assert here: any previously
// recorded link is overwritten.
void clang_ClassTemplatePartialSpecializationDecl_setInstantiatedFromMember(
    CXClassTemplatePartialSpecializationDecl D,
    CXClassTemplatePartialSpecializationDecl PartialSpec);

// Precondition: getInstantiatedFromMember() is non-null — Clang asserts that only
// member templates can be member template specializations.
void clang_ClassTemplatePartialSpecializationDecl_setMemberSpecialization(
    CXClassTemplatePartialSpecializationDecl D);

// ClassTemplateDecl
// Null when no partial specialization of CTD was instantiated from D. Precondition:
// every partial specialization of CTD has a non-null getInstantiatedFromMember() —
// the Clang implementation dereferences it unconditionally while scanning.
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplateDecl_findPartialSpecInstantiatedFromMember(
    CXClassTemplateDecl CTD, CXClassTemplatePartialSpecializationDecl D);

// setTypeAsWritten

// VarTemplatePartialSpecializationDecl
// Count for the getAssociatedConstraints fill below; the count is exact and no slot
// is null.
unsigned clang_VarTemplatePartialSpecializationDecl_getNumAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D);

// Fills exactly getNumAssociatedConstraints entries into AC, in declaration order.
void clang_VarTemplatePartialSpecializationDecl_getAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D, CXExpr *AC);

// Re-seats, on the first declaration of the redeclaration chain, the member partial
// specialization this one was instantiated from. No assert here: any previously
// recorded link is overwritten.
void clang_VarTemplatePartialSpecializationDecl_setInstantiatedFromMember(
    CXVarTemplatePartialSpecializationDecl D,
    CXVarTemplatePartialSpecializationDecl PartialSpec);

// Precondition: getInstantiatedFromMember() is non-null — Clang asserts that only
// member templates can be member template specializations.
void clang_VarTemplatePartialSpecializationDecl_setMemberSpecialization(
    CXVarTemplatePartialSpecializationDecl D);

CXSourceRange_ clang_VarTemplatePartialSpecializationDecl_getSourceRange(
    CXVarTemplatePartialSpecializationDecl D);

// VarTemplateDecl
// Null when no partial specialization of VTD was instantiated from D. Precondition:
// every partial specialization of VTD has a non-null getInstantiatedFromMember() —
// the Clang implementation dereferences it unconditionally while scanning.
CXVarTemplatePartialSpecializationDecl
clang_VarTemplateDecl_findPartialSpecInstantiatedFromMember(
    CXVarTemplateDecl VTD, CXVarTemplatePartialSpecializationDecl D);

// TemplateDecl
// Decl::Kind range test — the isa<> predicate for a caller holding a kind rather
// than a declaration. Covers every subclass kind.
bool clang_TemplateDecl_classofKind(CXDeclKind K);

// RedeclarableTemplateDecl
bool clang_RedeclarableTemplateDecl_classofKind(CXDeclKind K);

// FunctionTemplateDecl
bool clang_FunctionTemplateDecl_classofKind(CXDeclKind K);

// Null when the specialization set holds no entry for TAL's arguments; otherwise
// the most recent redeclaration of that specialization. InsertPos is Clang's
// FoldingSet insertion hint: it crosses by value, so the position Clang writes
// back through the reference is not observable here.
CXFunctionDecl clang_FunctionTemplateDecl_findSpecialization(CXFunctionTemplateDecl FTD,
                                                             CXTemplateArgumentList TAL,
                                                             void *InsertPos);

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_classofKind(CXDeclKind K);

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_classofKind(CXDeclKind K);

// TemplateTemplateParmDecl
bool clang_TemplateTemplateParmDecl_classofKind(CXDeclKind K);

// BuiltinTemplateDecl
bool clang_BuiltinTemplateDecl_classofKind(CXDeclKind K);

// ClassTemplateSpecializationDecl
bool clang_ClassTemplateSpecializationDecl_classofKind(CXDeclKind K);

// ClassTemplatePartialSpecializationDecl
bool clang_ClassTemplatePartialSpecializationDecl_classofKind(CXDeclKind K);

// ClassTemplateDecl
bool clang_ClassTemplateDecl_classofKind(CXDeclKind K);

// FriendTemplateDecl
bool clang_FriendTemplateDecl_classofKind(CXDeclKind K);

// TypeAliasTemplateDecl
bool clang_TypeAliasTemplateDecl_classofKind(CXDeclKind K);

// VarTemplateSpecializationDecl
bool clang_VarTemplateSpecializationDecl_classofKind(CXDeclKind K);

// VarTemplatePartialSpecializationDecl
bool clang_VarTemplatePartialSpecializationDecl_classofKind(CXDeclKind K);

// VarTemplateDecl
bool clang_VarTemplateDecl_classofKind(CXDeclKind K);

// Null when the specialization set holds no entry for TAL's arguments; otherwise
// the most recent redeclaration of that specialization. InsertPos as above.
CXVarTemplateSpecializationDecl
clang_VarTemplateDecl_findSpecialization(CXVarTemplateDecl VTD, CXTemplateArgumentList TAL,
                                         void *InsertPos);

// Null when no partial specialization is profiled by TAL together with TPL. Clang
// profiles the argument list and the parameter list as a pair, so both must come
// from the same partial specialization for the lookup to hit. InsertPos as above.
CXVarTemplatePartialSpecializationDecl clang_VarTemplateDecl_findPartialSpecialization(
    CXVarTemplateDecl VTD, CXTemplateArgumentList TAL, CXTemplateParameterList TPL,
    void *InsertPos);

// ConceptDecl
bool clang_ConceptDecl_classofKind(CXDeclKind K);

// TemplateParamObjectDecl
bool clang_TemplateParamObjectDecl_classofKind(CXDeclKind K);

// FunctionTemplateDecl
// Builds a function template over Params for the templated function Decl. Clang adopts
// Params: the parameters' owning context is re-seated when the template is built, so Decl
// must itself be a DeclContext and Params must be a list that already belongs there. The
// declaration is arena-allocated and is NOT added to DC.
CXFunctionTemplateDecl clang_FunctionTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ L,
                                                         CXDeclarationName Name,
                                                         CXTemplateParameterList Params,
                                                         CXNamedDecl Decl);

// TemplateTypeParmDecl
// Records that D's default argument is the one written on Prev. Precondition:
// !defaultArgumentWasInherited() — re-inheriting asserts that the old and the new default
// are the same template argument, which this API cannot establish.
void clang_TemplateTypeParmDecl_setInheritedDefaultArgument(CXTemplateTypeParmDecl D,
                                                            CXASTContext Context,
                                                            CXTemplateTypeParmDecl Prev);

// NonTypeTemplateParmDecl
// Same inheritance link and the same precondition as above.
void clang_NonTypeTemplateParmDecl_setInheritedDefaultArgument(
    CXNonTypeTemplateParmDecl D, CXASTContext Context, CXNonTypeTemplateParmDecl Prev);

// TemplateTemplateParmDecl
// Same inheritance link and the same precondition as above.
void clang_TemplateTemplateParmDecl_setInheritedDefaultArgument(
    CXTemplateTemplateParmDecl D, CXASTContext Context, CXTemplateTemplateParmDecl Prev);

// BuiltinTemplateDecl
// Builds the parameter list the builtin needs out of BTK; the declaration is
// arena-allocated and is NOT added to DC.
CXBuiltinTemplateDecl clang_BuiltinTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                       CXDeclarationName Name,
                                                       CXBuiltinTemplateKind BTK);

// ClassTemplateDecl
// Builds a class template over Params for the templated record Decl. Adopts Params and
// leaves the declaration out of DC exactly like clang_FunctionTemplateDecl_Create, so Decl
// must be a DeclContext here too.
CXClassTemplateDecl clang_ClassTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                   CXSourceLocation_ L,
                                                   CXDeclarationName Name,
                                                   CXTemplateParameterList Params,
                                                   CXNamedDecl Decl);

// FriendTemplateDecl
// Clang's Create takes the parameter-list array as a MutableArrayRef and the declaration
// keeps that storage, so the (Params, NumParams) buffer is copied into Context-owned
// memory here (MARSHALLING.md §11) and the caller's buffer needs no lifetime of its own.
// The FriendUnion parameter is split into one entry point per arm (MARSHALLING.md §8):
// this one stores the NamedDecl arm, so getFriendType is null on the result.
CXFriendTemplateDecl clang_FriendTemplateDecl_CreateWithFriendDecl(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ Loc,
    const CXTemplateParameterList *Params, unsigned NumParams, CXNamedDecl Friend,
    CXSourceLocation_ FriendLoc);

// The TypeSourceInfo arm of the same factory; getFriendDecl is null on the result.
CXFriendTemplateDecl clang_FriendTemplateDecl_CreateWithFriendType(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ Loc,
    const CXTemplateParameterList *Params, unsigned NumParams, CXTypeSourceInfo Friend,
    CXSourceLocation_ FriendLoc);

// Null unless the friend declaration names a type.
CXTypeSourceInfo clang_FriendTemplateDecl_getFriendType(CXFriendTemplateDecl D);

// Null unless the friend declaration names a declaration.
CXNamedDecl clang_FriendTemplateDecl_getFriendDecl(CXFriendTemplateDecl D);

CXSourceLocation_ clang_FriendTemplateDecl_getFriendLoc(CXFriendTemplateDecl D);

// Precondition: I < getNumTemplateParameters(). Clang's own assert is off by one (it
// admits I == NumParams, which reads one slot past the array), so the Julia layer
// restates the bound.
CXTemplateParameterList
clang_FriendTemplateDecl_getTemplateParameterList(CXFriendTemplateDecl D, unsigned I);

unsigned clang_FriendTemplateDecl_getNumTemplateParameters(CXFriendTemplateDecl D);

// TypeAliasTemplateDecl
// The templated TypeAliasDecl is not a DeclContext, so Params is adopted into DC itself;
// the declaration is NOT added to DC.
CXTypeAliasTemplateDecl clang_TypeAliasTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                           CXSourceLocation_ L,
                                                           CXDeclarationName Name,
                                                           CXTemplateParameterList Params,
                                                           CXNamedDecl Decl);

// VarTemplateDecl
// Params is adopted into DC (a VarDecl is not a DeclContext); the declaration is NOT
// added to DC.
CXVarTemplateDecl clang_VarTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ L, CXDeclarationName Name,
                                               CXTemplateParameterList Params,
                                               CXVarDecl Decl);

// ConceptDecl
// Params is adopted into DC; the declaration is NOT added to DC.
CXConceptDecl clang_ConceptDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ L, CXDeclarationName Name,
                                       CXTemplateParameterList Params,
                                       CXExpr ConstraintExpr);

// TemplateParameterList
// Builds a parameter list in C's arena — borrowed, no dispose. Params is a buffer of
// NamedDecl handles, each of which must be a TemplateTypeParmDecl, a
// NonTypeTemplateParmDecl or a TemplateTemplateParmDecl; the list stores the
// declarations themselves, so they must outlive it. RequiresClause may be NULL.
CXTemplateParameterList
clang_TemplateParameterList_Create(CXASTContext C, CXSourceLocation_ TemplateLoc,
                                   CXSourceLocation_ LAngleLoc, const CXNamedDecl *Params,
                                   unsigned NumParams, CXSourceLocation_ RAngleLoc,
                                   CXExpr RequiresClause);

// DependentFunctionTemplateSpecializationInfo
// Count for the index accessor below.
unsigned clang_DependentFunctionTemplateSpecializationInfo_getNumCandidates(
    CXDependentFunctionTemplateSpecializationInfo I);

// Borrowed candidate out of the info object's trailing array (no dispose).
// Precondition: Idx < getNumCandidates().
CXFunctionTemplateDecl clang_DependentFunctionTemplateSpecializationInfo_getCandidate(
    CXDependentFunctionTemplateSpecializationInfo I, unsigned Idx);

// TemplateTypeParmDecl
// The declaration is NOT added to DC. Id may be NULL for an unnamed parameter. clang's
// std::optional<unsigned> NumExpanded is flattened into the HasNumExpanded / NumExpanded
// pair: HasNumExpanded false means std::nullopt, i.e. not an already-expanded pack.
// HasTypeConstraint only reserves the trailing constraint slot; the constraint itself
// stays uninitialized, so clang_TemplateTypeParmDecl_hasInitializedTypeConstraint keeps
// reporting false until Sema fills it in.
CXTemplateTypeParmDecl clang_TemplateTypeParmDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ KeyLoc, CXSourceLocation_ NameLoc,
    unsigned D, unsigned P, CXIdentifierInfo Id, bool Typename, bool ParameterPack,
    bool HasTypeConstraint, bool HasNumExpanded, unsigned NumExpanded);

// Whether the trailing TypeConstraint slot has actually been filled in. This is NOT
// clang_TemplateTypeParmDecl_hasTypeConstraint: that one reports the flag chosen at
// creation, while the four accessors below read the slot, which Sema initializes later.
// Reading the slot before it is initialized is undefined behaviour, so this is the gate
// the Julia layer asserts on. // helper
bool clang_TemplateTypeParmDecl_hasInitializedTypeConstraint(CXTemplateTypeParmDecl D);

// The parameter's constraining concept, reached through TypeConstraint's
// ConceptReference. PARTIAL: precondition
// clang_TemplateTypeParmDecl_hasInitializedTypeConstraint. // helper
CXConceptDecl clang_TemplateTypeParmDecl_getTypeConstraintConcept(CXTemplateTypeParmDecl D);

// The immediately-declared constraint expression. Same precondition. // helper
CXExpr clang_TemplateTypeParmDecl_getTypeConstraintImmediatelyDeclaredConstraint(
    CXTemplateTypeParmDecl D);

// Location of the concept name in the type-constraint. Same precondition. // helper
CXSourceLocation_
clang_TemplateTypeParmDecl_getTypeConstraintConceptNameLoc(CXTemplateTypeParmDecl D);

// The as-written argument list of the type-constraint, NULL unless it was written with
// explicit template arguments. Same precondition. // helper
CXASTTemplateArgumentListInfo
clang_TemplateTypeParmDecl_getTypeConstraintTemplateArgsAsWritten(CXTemplateTypeParmDecl D);

// NonTypeTemplateParmDecl
// The declaration is NOT added to DC. Id and TInfo may be NULL. Depth and position are
// bit-fields of 20 and 12 bits and clang asserts D + 1 <= 0xFFFFF and P + 1 <= 0xFFF, so
// the Julia layer restates both bounds.
CXNonTypeTemplateParmDecl clang_NonTypeTemplateParmDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
    unsigned D, unsigned P, CXIdentifierInfo Id, CXQualType T, bool ParameterPack,
    CXTypeSourceInfo TInfo);

// Same bit-field bounds as the Create above: Depth + 1 <= 0xFFFFF.
void clang_NonTypeTemplateParmDecl_setDepth(CXNonTypeTemplateParmDecl D, unsigned Depth);

// Same bit-field bounds as the Create above: Position + 1 <= 0xFFF. Position and index
// are the same field, so this also moves clang_NonTypeTemplateParmDecl_getIndex.
void clang_NonTypeTemplateParmDecl_setPosition(CXNonTypeTemplateParmDecl D,
                                               unsigned Position);

// TemplateTemplateParmDecl
// The declaration is NOT added to DC; Params becomes the parameter's own list. Id may be
// NULL. Same 20-bit depth / 12-bit position bounds as NonTypeTemplateParmDecl.
CXTemplateTemplateParmDecl
clang_TemplateTemplateParmDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L,
                                      unsigned D, unsigned P, bool ParameterPack,
                                      CXIdentifierInfo Id, CXTemplateParameterList Params);

// Same bit-field bounds as the NonTypeTemplateParmDecl pair above.
void clang_TemplateTemplateParmDecl_setDepth(CXTemplateTemplateParmDecl D, unsigned Depth);

void clang_TemplateTemplateParmDecl_setPosition(CXTemplateTemplateParmDecl D,
                                                unsigned Position);

// ClassTemplateSpecializationDecl
// The template or partial specialization this one was INSTANTIATED from: the same union
// clang_ClassTemplateSpecializationDecl_getSpecializedTemplateOrPartial returns, but NULL
// when the specialization kind is not an instantiation (an explicit specialization).
// Pick the arm with clang_ClassTemplateSpecializationDecl_specializedOnPartial.
CXDecl clang_ClassTemplateSpecializationDecl_getInstantiatedFrom(
    CXClassTemplateSpecializationDecl D);

// VarTemplateSpecializationDecl
// As above, against clang_VarTemplateSpecializationDecl_getSpecializedTemplateOrPartial
// and clang_VarTemplateSpecializationDecl_specializedOnPartial.
CXDecl
clang_VarTemplateSpecializationDecl_getInstantiatedFrom(CXVarTemplateSpecializationDecl D);

// ImplicitConceptSpecializationDecl
// Args is a buffer of CXTemplateArgument handles; each is dereferenced and the values are
// copied into C's arena, so the caller keeps ownership of the handles it passed. The
// declaration is NOT added to DC.
CXImplicitConceptSpecializationDecl clang_ImplicitConceptSpecializationDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ SL, const CXTemplateArgument *Args,
    unsigned NumArgs);

// Count for the index accessor below.
unsigned clang_ImplicitConceptSpecializationDecl_getNumTemplateArguments(
    CXImplicitConceptSpecializationDecl D);

// Borrowed interior pointer into the declaration's trailing argument array (no dispose,
// unlike the heap-boxed TemplateArgument returned by the construct* helpers).
// Precondition: I < getNumTemplateArguments().
CXTemplateArgument clang_ImplicitConceptSpecializationDecl_getTemplateArgument(
    CXImplicitConceptSpecializationDecl D, unsigned I);

// Overwrites the trailing argument array in place. That array was sized once, at Create,
// so NumArgs MUST equal getNumTemplateArguments() — a longer list writes past the
// allocation. The Julia layer restates the bound.
void clang_ImplicitConceptSpecializationDecl_setTemplateArguments(
    CXImplicitConceptSpecializationDecl D, const CXTemplateArgument *Args,
    unsigned NumArgs);

bool clang_ImplicitConceptSpecializationDecl_classofKind(CXDeclKind K);

LLVM_CLANG_C_EXTERN_C_END

#endif
