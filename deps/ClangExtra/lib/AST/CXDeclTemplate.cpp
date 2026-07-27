#include "clang-ex/AST/CXDeclTemplate.h"
#include "clang/AST/DeclTemplate.h"
#include "utils.h"
#include "clang/AST/Expr.h"
#include "llvm/Support/raw_ostream.h"

// TemplateParameterList
CXSourceRange_ clang_TemplateParameterList_getSourceRange(CXTemplateParameterList L) {
  auto rng = static_cast<clang::TemplateParameterList *>(L)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXExpr clang_TemplateParameterList_getRequiresClause(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getRequiresClause();
}

bool clang_TemplateParameterList_hasAssociatedConstraints(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->hasAssociatedConstraints();
}

// TemplateTemplateParmDecl
unsigned clang_TemplateTemplateParmDecl_getDepth(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->getDepth();
}

unsigned clang_TemplateTemplateParmDecl_getIndex(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->getIndex();
}

bool clang_TemplateTemplateParmDecl_isParameterPack(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->isParameterPack();
}

bool clang_TemplateTemplateParmDecl_hasDefaultArgument(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->hasDefaultArgument();
}

// TemplateParameterList
CXNamedDecl clang_TemplateParameterList_getParam(CXTemplateParameterList TPL,
                                                 unsigned Idx) {
  return static_cast<clang::TemplateParameterList *>(TPL)->getParam(Idx);
}

unsigned clang_TemplateParameterList_size(CXTemplateParameterList TPL) {
  return static_cast<clang::TemplateParameterList *>(TPL)->size();
}

// TemplateArgumentList
CXTemplateArgumentList clang_TemplateArgumentList_CreateCopy(CXASTContext Context,
                                                             CXTemplateArgument Args,
                                                             size_t ArgNum) {
  // Args is a caller buffer of CXTemplateArgument handles (pointers to
  // heap-boxed clang::TemplateArgument), not a contiguous value array —
  // dereference each into a value vector before copying.
  auto **Handles = static_cast<clang::TemplateArgument **>(Args);
  llvm::SmallVector<clang::TemplateArgument, 4> Vec;
  Vec.reserve(ArgNum);
  for (size_t I = 0; I < ArgNum; ++I)
    Vec.push_back(*Handles[I]);
  return clang::TemplateArgumentList::CreateCopy(
      *static_cast<clang::ASTContext *>(Context), Vec);
}

unsigned clang_TemplateArgumentList_size(CXTemplateArgumentList TAL) {
  return static_cast<clang::TemplateArgumentList *>(TAL)->size();
}

CXTemplateArgument clang_TemplateArgumentList_data(CXTemplateArgumentList TAL) {
  return const_cast<clang::TemplateArgument *>(
      static_cast<clang::TemplateArgumentList *>(TAL)->data());
}

CXTemplateArgument clang_TemplateArgumentList_get(CXTemplateArgumentList TAL,
                                                  unsigned Idx) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::TemplateArgumentList *>(TAL)->get(Idx));
}

// TemplateDecl
// void clang_TemplateDecl_init(CXTemplateDecl TD, CXNamedDecl ND,
//                              CXTemplateParameterList TP) {
//   static_cast<clang::TemplateDecl *>(TD)->init(
//       static_cast<clang::NamedDecl *>(ND), static_cast<clang::TemplateParameterList
//       *>(ND));
// }

// RedeclarableTemplateDecl
CXRedeclarableTemplateDecl
clang_RedeclarableTemplateDecl_getCanonicalDecl(CXRedeclarableTemplateDecl RTD) {
  return static_cast<clang::RedeclarableTemplateDecl *>(RTD)->getCanonicalDecl();
}

bool clang_RedeclarableTemplateDecl_isMemberSpecialization(CXRedeclarableTemplateDecl RTD) {
  return static_cast<clang::RedeclarableTemplateDecl *>(RTD)->isMemberSpecialization();
}

void clang_RedeclarableTemplateDecl_setMemberSpecialization(
    CXRedeclarableTemplateDecl RTD) {
  static_cast<clang::RedeclarableTemplateDecl *>(RTD)->setMemberSpecialization();
}

// ClassTemplateDecl
CXCXXRecordDecl clang_ClassTemplateDecl_getTemplatedDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getTemplatedDecl();
}

bool clang_ClassTemplateDecl_isThisDeclarationADefinition(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->isThisDeclarationADefinition();
}

CXClassTemplateSpecializationDecl
clang_ClassTemplateDecl_findSpecialization(CXClassTemplateDecl CTD,
                                           CXTemplateArgumentList TAL, void *InsertPos) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->findSpecialization(
      static_cast<clang::TemplateArgumentList *>(TAL)->asArray(), InsertPos);
}

void clang_ClassTemplateDecl_AddSpecialization(CXClassTemplateDecl CTD,
                                               CXClassTemplateSpecializationDecl CTSD,
                                               void *InsertPos) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->AddSpecialization(
      static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD), InsertPos);
}

CXClassTemplateDecl clang_ClassTemplateDecl_getCanonicalDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getCanonicalDecl();
}

CXClassTemplateDecl clang_ClassTemplateDecl_getPreviousDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getPreviousDecl();
}

CXClassTemplateDecl clang_ClassTemplateDecl_getMostRecentDecl(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getMostRecentDecl();
}

// ClassTemplateSpecializationDecl
CXClassTemplateSpecializationDecl clang_ClassTemplateSpecializationDecl_Create(
    CXASTContext Context, CXTagTypeKind TK, CXDeclContext DC, CXSourceLocation_ StartLoc,
    CXSourceLocation_ IdLoc, CXClassTemplateDecl SpecializedTemplate,
    CXTemplateArgumentList Args, CXClassTemplateSpecializationDecl PrevDecl) {
  return clang::ClassTemplateSpecializationDecl::Create(
      *static_cast<clang::ASTContext *>(Context), static_cast<clang::TagTypeKind>(TK),
      static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::ClassTemplateDecl *>(SpecializedTemplate),
      static_cast<clang::TemplateArgumentList *>(Args)->asArray(),
      static_cast<clang::ClassTemplateSpecializationDecl *>(PrevDecl));
}

CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD) {
  return const_cast<clang::TemplateArgumentList *>(
      &static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD)->getTemplateArgs());
}

void clang_ClassTemplateSpecializationDecl_setTemplateArgs(
    CXClassTemplateSpecializationDecl CTSD, CXTemplateArgumentList TAL) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(CTSD)->setTemplateArgs(
      static_cast<clang::TemplateArgumentList *>(TAL));
}
// TemplateDecl navigation
CXNamedDecl clang_TemplateDecl_getTemplatedDecl(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->getTemplatedDecl();
}

CXTemplateParameterList clang_TemplateDecl_getTemplateParameters(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->getTemplateParameters();
}

// TemplateParameterList
unsigned clang_TemplateParameterList_getDepth(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getDepth();
}

unsigned clang_TemplateParameterList_getMinRequiredArguments(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getMinRequiredArguments();
}

bool clang_TemplateParameterList_hasParameterPack(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->hasParameterPack();
}

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_wasDeclaredWithTypename(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->wasDeclaredWithTypename();
}

bool clang_TemplateTypeParmDecl_hasDefaultArgument(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->hasDefaultArgument();
}

// Precondition: hasDefaultArgument().
CXQualType clang_TemplateTypeParmDecl_getDefaultArgument(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)
      ->getDefaultArgument()
      .getAsOpaquePtr();
}

bool clang_TemplateTypeParmDecl_defaultArgumentWasInherited(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->defaultArgumentWasInherited();
}

bool clang_TemplateTypeParmDecl_isExpandedParameterPack(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->isExpandedParameterPack();
}

// Precondition: isExpandedParameterPack().
unsigned clang_TemplateTypeParmDecl_getNumExpansionParameters(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getNumExpansionParameters();
}

bool clang_TemplateTypeParmDecl_hasTypeConstraint(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->hasTypeConstraint();
}
unsigned clang_TemplateTypeParmDecl_getDepth(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getDepth();
}

unsigned clang_TemplateTypeParmDecl_getIndex(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getIndex();
}

bool clang_TemplateTypeParmDecl_isParameterPack(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->isParameterPack();
}

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_hasDefaultArgument(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->hasDefaultArgument();
}

CXExpr clang_NonTypeTemplateParmDecl_getDefaultArgument(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getDefaultArgument();
}

bool clang_NonTypeTemplateParmDecl_isExpandedParameterPack(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->isExpandedParameterPack();
}

// Precondition: isExpandedParameterPack().
unsigned clang_NonTypeTemplateParmDecl_getNumExpansionTypes(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getNumExpansionTypes();
}

// Precondition: isExpandedParameterPack() and I < getNumExpansionTypes().
CXQualType clang_NonTypeTemplateParmDecl_getExpansionType(CXNonTypeTemplateParmDecl D,
                                                          unsigned I) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)
      ->getExpansionType(I)
      .getAsOpaquePtr();
}

bool clang_NonTypeTemplateParmDecl_hasPlaceholderTypeConstraint(
    CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)
      ->hasPlaceholderTypeConstraint();
}
unsigned clang_NonTypeTemplateParmDecl_getDepth(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getDepth();
}

unsigned clang_NonTypeTemplateParmDecl_getIndex(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getIndex();
}

bool clang_NonTypeTemplateParmDecl_isParameterPack(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->isParameterPack();
}

// ClassTemplateSpecializationDecl navigation
CXClassTemplateDecl
clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getSpecializedTemplate();
}

CXDecl clang_ClassTemplateSpecializationDecl_getSpecializedTemplateOrPartial(
    CXClassTemplateSpecializationDecl D) {
  auto U = static_cast<clang::ClassTemplateSpecializationDecl *>(D)
               ->getSpecializedTemplateOrPartial();
  if (auto *PD = U.dyn_cast<clang::ClassTemplatePartialSpecializationDecl *>())
    return PD;
  return U.get<clang::ClassTemplateDecl *>();
}

bool clang_ClassTemplateSpecializationDecl_specializedOnPartial(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->getSpecializedTemplateOrPartial()
      .is<clang::ClassTemplatePartialSpecializationDecl *>();
}

CXTemplateSpecializationKind
clang_ClassTemplateSpecializationDecl_getSpecializationKind(CXClassTemplateSpecializationDecl D) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getSpecializationKind());
}

// VarTemplateSpecializationDecl
CXTemplateArgumentList clang_VarTemplateSpecializationDecl_getTemplateArgs(
    CXVarTemplateSpecializationDecl VTSD) {
  return const_cast<clang::TemplateArgumentList *>(
      &static_cast<clang::VarTemplateSpecializationDecl *>(VTSD)->getTemplateArgs());
}

// RedeclarableTemplateDecl
CXRedeclarableTemplateDecl clang_RedeclarableTemplateDecl_getInstantiatedFromMemberTemplate(
    CXRedeclarableTemplateDecl RTD) {
  return static_cast<clang::RedeclarableTemplateDecl *>(RTD)
      ->getInstantiatedFromMemberTemplate();
}

// FunctionTemplateDecl
CXFunctionDecl clang_FunctionTemplateDecl_getTemplatedDecl(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->getTemplatedDecl();
}

bool clang_FunctionTemplateDecl_isThisDeclarationADefinition(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->isThisDeclarationADefinition();
}

bool clang_FunctionTemplateDecl_isAbbreviated(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->isAbbreviated();
}

// TypeAliasTemplateDecl
CXTypeAliasDecl clang_TypeAliasTemplateDecl_getTemplatedDecl(CXTypeAliasTemplateDecl TATD) {
  return static_cast<clang::TypeAliasTemplateDecl *>(TATD)->getTemplatedDecl();
}

// VarTemplateDecl
CXVarDecl clang_VarTemplateDecl_getTemplatedDecl(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getTemplatedDecl();
}

bool clang_VarTemplateDecl_isThisDeclarationADefinition(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->isThisDeclarationADefinition();
}

// ClassTemplatePartialSpecializationDecl
CXTemplateParameterList clang_ClassTemplatePartialSpecializationDecl_getTemplateParameters(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->getTemplateParameters();
}

bool clang_ClassTemplatePartialSpecializationDecl_hasAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->hasAssociatedConstraints();
}

CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMember(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->getInstantiatedFromMember();
}

bool clang_ClassTemplatePartialSpecializationDecl_isMemberSpecialization(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->isMemberSpecialization();
}

// TemplateParameterList
CXSourceLocation_ clang_TemplateParameterList_getTemplateLoc(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getTemplateLoc().getPtrEncoding();
}

CXSourceLocation_ clang_TemplateParameterList_getLAngleLoc(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getLAngleLoc().getPtrEncoding();
}

CXSourceLocation_ clang_TemplateParameterList_getRAngleLoc(CXTemplateParameterList L) {
  return static_cast<clang::TemplateParameterList *>(L)->getRAngleLoc().getPtrEncoding();
}

// ClassTemplateSpecializationDecl
CXClassTemplateSpecializationDecl clang_ClassTemplateSpecializationDecl_getMostRecentDecl(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getMostRecentDecl();
}

CXSourceLocation_ clang_ClassTemplateSpecializationDecl_getPointOfInstantiation(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->getPointOfInstantiation()
      .getPtrEncoding();
}

bool clang_ClassTemplateSpecializationDecl_isExplicitSpecialization(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->isExplicitSpecialization();
}

bool clang_ClassTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->isExplicitInstantiationOrSpecialization();
}

// VarTemplateSpecializationDecl
CXVarTemplateSpecializationDecl
clang_VarTemplateSpecializationDecl_getMostRecentDecl(CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)->getMostRecentDecl();
}

CXVarTemplateDecl clang_VarTemplateSpecializationDecl_getSpecializedTemplate(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)->getSpecializedTemplate();
}

CXTemplateSpecializationKind clang_VarTemplateSpecializationDecl_getSpecializationKind(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::VarTemplateSpecializationDecl *>(D)->getSpecializationKind());
}

bool clang_VarTemplateSpecializationDecl_isExplicitSpecialization(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)->isExplicitSpecialization();
}

bool clang_VarTemplateSpecializationDecl_isExplicitInstantiationOrSpecialization(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->isExplicitInstantiationOrSpecialization();
}

CXSourceLocation_ clang_VarTemplateSpecializationDecl_getPointOfInstantiation(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->getPointOfInstantiation()
      .getPtrEncoding();
}

CXDecl clang_VarTemplateSpecializationDecl_getSpecializedTemplateOrPartial(
    CXVarTemplateSpecializationDecl D) {
  auto U = static_cast<clang::VarTemplateSpecializationDecl *>(D)
               ->getSpecializedTemplateOrPartial();
  if (auto *PD = U.dyn_cast<clang::VarTemplatePartialSpecializationDecl *>())
    return PD;
  return U.get<clang::VarTemplateDecl *>();
}

bool clang_VarTemplateSpecializationDecl_specializedOnPartial(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->getSpecializedTemplateOrPartial()
      .is<clang::VarTemplatePartialSpecializationDecl *>();
}

CXSourceLocation_
clang_VarTemplateSpecializationDecl_getExternLoc(CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->getExternLoc()
      .getPtrEncoding();
}

CXSourceLocation_ clang_VarTemplateSpecializationDecl_getTemplateKeywordLoc(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->getTemplateKeywordLoc()
      .getPtrEncoding();
}

// ConceptDecl
CXExpr clang_ConceptDecl_getConstraintExpr(CXConceptDecl D) {
  return static_cast<clang::ConceptDecl *>(D)->getConstraintExpr();
}

bool clang_ConceptDecl_isTypeConcept(CXConceptDecl D) {
  return static_cast<clang::ConceptDecl *>(D)->isTypeConcept();
}

CXConceptDecl clang_ConceptDecl_getCanonicalDecl(CXConceptDecl D) {
  return static_cast<clang::ConceptDecl *>(D)->getCanonicalDecl();
}

CXSourceRange_ clang_ConceptDecl_getSourceRange(CXConceptDecl D) {
  auto rng = static_cast<clang::ConceptDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// TemplateDecl
bool clang_TemplateDecl_hasAssociatedConstraints(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->hasAssociatedConstraints();
}

bool clang_TemplateDecl_isTypeAlias(CXTemplateDecl TD) {
  return static_cast<clang::TemplateDecl *>(TD)->isTypeAlias();
}

// ClassTemplateSpecializationDecl
bool clang_ClassTemplateSpecializationDecl_isClassScopeExplicitSpecialization(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->isClassScopeExplicitSpecialization();
}

CXTemplateArgumentList clang_ClassTemplateSpecializationDecl_getTemplateInstantiationArgs(
    CXClassTemplateSpecializationDecl D) {
  return const_cast<clang::TemplateArgumentList *>(
      &static_cast<clang::ClassTemplateSpecializationDecl *>(D)
           ->getTemplateInstantiationArgs());
}

CXTypeSourceInfo clang_ClassTemplateSpecializationDecl_getTypeAsWritten(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getTypeAsWritten();
}

CXSourceLocation_
clang_ClassTemplateSpecializationDecl_getExternLoc(CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->getExternLoc()
      .getPtrEncoding();
}

CXSourceLocation_ clang_ClassTemplateSpecializationDecl_getTemplateKeywordLoc(
    CXClassTemplateSpecializationDecl D) {
  return static_cast<clang::ClassTemplateSpecializationDecl *>(D)
      ->getTemplateKeywordLoc()
      .getPtrEncoding();
}

CXSourceRange_
clang_ClassTemplateSpecializationDecl_getSourceRange(CXClassTemplateSpecializationDecl D) {
  auto rng = static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// VarTemplateSpecializationDecl
bool clang_VarTemplateSpecializationDecl_isClassScopeExplicitSpecialization(
    CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)
      ->isClassScopeExplicitSpecialization();
}

CXTemplateArgumentList clang_VarTemplateSpecializationDecl_getTemplateInstantiationArgs(
    CXVarTemplateSpecializationDecl D) {
  return const_cast<clang::TemplateArgumentList *>(
      &static_cast<clang::VarTemplateSpecializationDecl *>(D)
           ->getTemplateInstantiationArgs());
}

CXTypeSourceInfo
clang_VarTemplateSpecializationDecl_getTypeAsWritten(CXVarTemplateSpecializationDecl D) {
  return static_cast<clang::VarTemplateSpecializationDecl *>(D)->getTypeAsWritten();
}

CXSourceRange_
clang_VarTemplateSpecializationDecl_getSourceRange(CXVarTemplateSpecializationDecl D) {
  auto rng = static_cast<clang::VarTemplateSpecializationDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// VarTemplatePartialSpecializationDecl
CXTemplateParameterList clang_VarTemplatePartialSpecializationDecl_getTemplateParameters(
    CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)
      ->getTemplateParameters();
}

bool clang_VarTemplatePartialSpecializationDecl_hasAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)
      ->hasAssociatedConstraints();
}

CXVarTemplatePartialSpecializationDecl
clang_VarTemplatePartialSpecializationDecl_getInstantiatedFromMember(
    CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)
      ->getInstantiatedFromMember();
}

bool clang_VarTemplatePartialSpecializationDecl_isMemberSpecialization(
    CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)
      ->isMemberSpecialization();
}

// MemberSpecializationInfo
CXNamedDecl
clang_MemberSpecializationInfo_getInstantiatedFrom(CXMemberSpecializationInfo MSI) {
  return static_cast<clang::MemberSpecializationInfo *>(MSI)->getInstantiatedFrom();
}

CXTemplateSpecializationKind clang_MemberSpecializationInfo_getTemplateSpecializationKind(
    CXMemberSpecializationInfo MSI) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::MemberSpecializationInfo *>(MSI)->getTemplateSpecializationKind());
}

bool clang_MemberSpecializationInfo_isExplicitSpecialization(
    CXMemberSpecializationInfo MSI) {
  return static_cast<clang::MemberSpecializationInfo *>(MSI)->isExplicitSpecialization();
}

CXSourceLocation_
clang_MemberSpecializationInfo_getPointOfInstantiation(CXMemberSpecializationInfo MSI) {
  return static_cast<clang::MemberSpecializationInfo *>(MSI)
      ->getPointOfInstantiation()
      .getPtrEncoding();
}

// FunctionTemplateSpecializationInfo
CXFunctionDecl clang_FunctionTemplateSpecializationInfo_getFunction(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)->getFunction();
}

CXFunctionTemplateDecl clang_FunctionTemplateSpecializationInfo_getTemplate(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)->getTemplate();
}

CXTemplateSpecializationKind
clang_FunctionTemplateSpecializationInfo_getTemplateSpecializationKind(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
          ->getTemplateSpecializationKind());
}

bool clang_FunctionTemplateSpecializationInfo_isExplicitSpecialization(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
      ->isExplicitSpecialization();
}

bool clang_FunctionTemplateSpecializationInfo_isExplicitInstantiationOrSpecialization(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
      ->isExplicitInstantiationOrSpecialization();
}

CXSourceLocation_ clang_FunctionTemplateSpecializationInfo_getPointOfInstantiation(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
      ->getPointOfInstantiation()
      .getPtrEncoding();
}

CXMemberSpecializationInfo
clang_FunctionTemplateSpecializationInfo_getMemberSpecializationInfo(
    CXFunctionTemplateSpecializationInfo FTSI) {
  return static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
      ->getMemberSpecializationInfo();
}

// TemplateTemplateParmDecl
bool clang_TemplateTemplateParmDecl_isPackExpansion(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->isPackExpansion();
}

bool clang_TemplateTemplateParmDecl_isExpandedParameterPack(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->isExpandedParameterPack();
}

unsigned clang_TemplateTemplateParmDecl_getNumExpansionTemplateParameters(
    CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)
      ->getNumExpansionTemplateParameters();
}

CXTemplateParameterList
clang_TemplateTemplateParmDecl_getExpansionTemplateParameters(CXTemplateTemplateParmDecl D,
                                                              unsigned I) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->getExpansionTemplateParameters(
      I);
}

CXSourceLocation_
clang_TemplateTemplateParmDecl_getDefaultArgumentLoc(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)
      ->getDefaultArgumentLoc()
      .getPtrEncoding();
}

bool clang_TemplateTemplateParmDecl_defaultArgumentWasInherited(
    CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->defaultArgumentWasInherited();
}

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_defaultArgumentWasInherited(
    CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->defaultArgumentWasInherited();
}

bool clang_NonTypeTemplateParmDecl_isPackExpansion(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->isPackExpansion();
}

CXExpr
clang_NonTypeTemplateParmDecl_getPlaceholderTypeConstraint(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getPlaceholderTypeConstraint();
}

// FunctionTemplateDecl
CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getCanonicalDecl(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->getCanonicalDecl();
}

CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getPreviousDecl(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->getPreviousDecl();
}

CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getMostRecentDecl(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->getMostRecentDecl();
}

// ClassTemplatePartialSpecializationDecl
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getMostRecentDecl(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->getMostRecentDecl();
}

CXASTTemplateArgumentListInfo
clang_ClassTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(
    CXClassTemplatePartialSpecializationDecl D) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
          ->getTemplateArgsAsWritten());
}

CXQualType clang_ClassTemplatePartialSpecializationDecl_getInjectedSpecializationType(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->getInjectedSpecializationType()
      .getAsOpaquePtr();
}

// ClassTemplateDecl
unsigned clang_ClassTemplateDecl_getNumPartialSpecializations(CXClassTemplateDecl CTD) {
  llvm::SmallVector<clang::ClassTemplatePartialSpecializationDecl *, 4> V;
  static_cast<clang::ClassTemplateDecl *>(CTD)->getPartialSpecializations(V);
  return static_cast<unsigned>(V.size());
}

void clang_ClassTemplateDecl_getPartialSpecializations(
    CXClassTemplateDecl CTD, CXClassTemplatePartialSpecializationDecl *PS) {
  llvm::SmallVector<clang::ClassTemplatePartialSpecializationDecl *, 4> V;
  static_cast<clang::ClassTemplateDecl *>(CTD)->getPartialSpecializations(V);
  unsigned I = 0;
  for (auto *P : V)
    PS[I++] = P;
}

CXClassTemplatePartialSpecializationDecl
clang_ClassTemplateDecl_findPartialSpecialization(CXClassTemplateDecl CTD, CXQualType T) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->findPartialSpecialization(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType
clang_ClassTemplateDecl_getInjectedClassNameSpecialization(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)
      ->getInjectedClassNameSpecialization()
      .getAsOpaquePtr();
}

// TypeAliasTemplateDecl
CXTypeAliasTemplateDecl
clang_TypeAliasTemplateDecl_getCanonicalDecl(CXTypeAliasTemplateDecl TATD) {
  return static_cast<clang::TypeAliasTemplateDecl *>(TATD)->getCanonicalDecl();
}

CXTypeAliasTemplateDecl
clang_TypeAliasTemplateDecl_getPreviousDecl(CXTypeAliasTemplateDecl TATD) {
  return static_cast<clang::TypeAliasTemplateDecl *>(TATD)->getPreviousDecl();
}

// VarTemplateSpecializationDecl
CXASTTemplateArgumentListInfo
clang_VarTemplateSpecializationDecl_getTemplateArgsInfo(CXVarTemplateSpecializationDecl D) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      static_cast<clang::VarTemplateSpecializationDecl *>(D)->getTemplateArgsInfo());
}

// VarTemplatePartialSpecializationDecl
CXASTTemplateArgumentListInfo
clang_VarTemplatePartialSpecializationDecl_getTemplateArgsAsWritten(
    CXVarTemplatePartialSpecializationDecl D) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)
          ->getTemplateArgsAsWritten());
}

// VarTemplateDecl
CXVarTemplateDecl clang_VarTemplateDecl_getDefinition(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getDefinition();
}

CXVarTemplateDecl clang_VarTemplateDecl_getCanonicalDecl(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getCanonicalDecl();
}

CXVarTemplateDecl clang_VarTemplateDecl_getPreviousDecl(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getPreviousDecl();
}

CXVarTemplateDecl clang_VarTemplateDecl_getMostRecentDecl(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getMostRecentDecl();
}

unsigned clang_VarTemplateDecl_getNumPartialSpecializations(CXVarTemplateDecl VTD) {
  llvm::SmallVector<clang::VarTemplatePartialSpecializationDecl *, 4> V;
  static_cast<clang::VarTemplateDecl *>(VTD)->getPartialSpecializations(V);
  return static_cast<unsigned>(V.size());
}

void clang_VarTemplateDecl_getPartialSpecializations(
    CXVarTemplateDecl VTD, CXVarTemplatePartialSpecializationDecl *PS) {
  llvm::SmallVector<clang::VarTemplatePartialSpecializationDecl *, 4> V;
  static_cast<clang::VarTemplateDecl *>(VTD)->getPartialSpecializations(V);
  unsigned I = 0;
  for (auto *P : V)
    PS[I++] = P;
}

// TemplateParameterList
bool clang_TemplateParameterList_containsUnexpandedParameterPack(
    CXTemplateParameterList TPL) {
  return static_cast<clang::TemplateParameterList *>(TPL)
      ->containsUnexpandedParameterPack();
}

unsigned
clang_TemplateParameterList_getNumAssociatedConstraints(CXTemplateParameterList TPL) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::TemplateParameterList *>(TPL)->getAssociatedConstraints(AC);
  return static_cast<unsigned>(AC.size());
}

void clang_TemplateParameterList_getAssociatedConstraints(CXTemplateParameterList TPL,
                                                          CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::TemplateParameterList *>(TPL)->getAssociatedConstraints(V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

// TemplateDecl
unsigned clang_TemplateDecl_getNumAssociatedConstraints(CXTemplateDecl TD) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::TemplateDecl *>(TD)->getAssociatedConstraints(AC);
  return static_cast<unsigned>(AC.size());
}

void clang_TemplateDecl_getAssociatedConstraints(CXTemplateDecl TD, CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::TemplateDecl *>(TD)->getAssociatedConstraints(V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

// RedeclarableTemplateDecl
unsigned
clang_RedeclarableTemplateDecl_getNumInjectedTemplateArgs(CXRedeclarableTemplateDecl RTD) {
  auto *D = static_cast<clang::RedeclarableTemplateDecl *>(RTD);
  return static_cast<unsigned>(D->getInjectedTemplateArgs().size());
}

CXTemplateArgument
clang_RedeclarableTemplateDecl_getInjectedTemplateArg(CXRedeclarableTemplateDecl RTD,
                                                      unsigned I) {
  auto *D = static_cast<clang::RedeclarableTemplateDecl *>(RTD);
  return const_cast<clang::TemplateArgument *>(&D->getInjectedTemplateArgs()[I]);
}

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_isPackExpansion(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->isPackExpansion();
}

CXSourceLocation_
clang_TemplateTypeParmDecl_getDefaultArgumentLoc(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)
      ->getDefaultArgumentLoc()
      .getPtrEncoding();
}

// NonTypeTemplateParmDecl
CXSourceLocation_
clang_NonTypeTemplateParmDecl_getDefaultArgumentLoc(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)
      ->getDefaultArgumentLoc()
      .getPtrEncoding();
}

// TemplateTemplateParmDecl
CXTemplateArgumentLoc
clang_TemplateTemplateParmDecl_getDefaultArgument(CXTemplateTemplateParmDecl D) {
  return const_cast<clang::TemplateArgumentLoc *>(
      &static_cast<clang::TemplateTemplateParmDecl *>(D)->getDefaultArgument());
}

// BuiltinTemplateDecl
CXBuiltinTemplateKind
clang_BuiltinTemplateDecl_getBuiltinTemplateKind(CXBuiltinTemplateDecl D) {
  return static_cast<CXBuiltinTemplateKind>(
      static_cast<clang::BuiltinTemplateDecl *>(D)->getBuiltinTemplateKind());
}

// TemplateParamObjectDecl
CXAPValue clang_TemplateParamObjectDecl_getValue(CXTemplateParamObjectDecl D) {
  return const_cast<clang::APValue *>(
      &static_cast<clang::TemplateParamObjectDecl *>(D)->getValue());
}

CXString clang_TemplateParamObjectDecl_printAsExpr(CXTemplateParamObjectDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::TemplateParamObjectDecl *>(D)->printAsExpr(OS);
  return extra::makeCXString(S);
}

CXString clang_TemplateParamObjectDecl_printAsInit(CXTemplateParamObjectDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::TemplateParamObjectDecl *>(D)->printAsInit(OS);
  return extra::makeCXString(S);
}

CXTemplateParamObjectDecl
clang_TemplateParamObjectDecl_getCanonicalDecl(CXTemplateParamObjectDecl D) {
  return static_cast<clang::TemplateParamObjectDecl *>(D)->getCanonicalDecl();
}

// ClassTemplateDecl
CXClassTemplateDecl
clang_ClassTemplateDecl_getInstantiatedFromMemberTemplate(CXClassTemplateDecl CTD) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)->getInstantiatedFromMemberTemplate();
}

// ClassTemplatePartialSpecializationDecl
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplatePartialSpecializationDecl_getInstantiatedFromMemberTemplate(
    CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->getInstantiatedFromMemberTemplate();
}

// FunctionTemplateDecl
CXFunctionTemplateDecl
clang_FunctionTemplateDecl_getInstantiatedFromMemberTemplate(CXFunctionTemplateDecl FTD) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)
      ->getInstantiatedFromMemberTemplate();
}

// TypeAliasTemplateDecl
CXTypeAliasTemplateDecl clang_TypeAliasTemplateDecl_getInstantiatedFromMemberTemplate(
    CXTypeAliasTemplateDecl TATD) {
  return static_cast<clang::TypeAliasTemplateDecl *>(TATD)
      ->getInstantiatedFromMemberTemplate();
}

// VarTemplateDecl
CXVarTemplateDecl
clang_VarTemplateDecl_getInstantiatedFromMemberTemplate(CXVarTemplateDecl VTD) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->getInstantiatedFromMemberTemplate();
}

// VarTemplatePartialSpecializationDecl
CXVarTemplatePartialSpecializationDecl
clang_VarTemplatePartialSpecializationDecl_getMostRecentDecl(
    CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->getMostRecentDecl();
}

// TemplateParameterList
CXString clang_TemplateParameterList_print(CXTemplateParameterList TPL,
                                           CXASTContext Context, bool OmitTemplateKW) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::TemplateParameterList *>(TPL)->print(
      OS, *static_cast<clang::ASTContext *>(Context), OmitTemplateKW);
  return extra::makeCXString(S);
}

// FunctionTemplateDecl
void clang_FunctionTemplateDecl_LoadLazySpecializations(CXFunctionTemplateDecl FTD) {
  static_cast<clang::FunctionTemplateDecl *>(FTD)->LoadLazySpecializations();
}

unsigned clang_FunctionTemplateDecl_getNumSpecializations(CXFunctionTemplateDecl FTD) {
  auto Specs = static_cast<clang::FunctionTemplateDecl *>(FTD)->specializations();
  unsigned N = 0;
  for (auto It = Specs.begin(), E = Specs.end(); It != E; ++It)
    ++N;
  return N;
}

void clang_FunctionTemplateDecl_getSpecializations(CXFunctionTemplateDecl FTD,
                                                   CXFunctionDecl *S) {
  unsigned I = 0;
  for (auto *Spec : static_cast<clang::FunctionTemplateDecl *>(FTD)->specializations())
    S[I++] = Spec;
}

// TemplateTypeParmDecl
CXTypeSourceInfo
clang_TemplateTypeParmDecl_getDefaultArgumentInfo(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getDefaultArgumentInfo();
}

void clang_TemplateTypeParmDecl_setDeclaredWithTypename(CXTemplateTypeParmDecl D,
                                                        bool WithTypename) {
  static_cast<clang::TemplateTypeParmDecl *>(D)->setDeclaredWithTypename(WithTypename);
}

// NonTypeTemplateParmDecl
unsigned clang_NonTypeTemplateParmDecl_getPosition(CXNonTypeTemplateParmDecl D) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getPosition();
}

CXTypeSourceInfo
clang_NonTypeTemplateParmDecl_getExpansionTypeSourceInfo(CXNonTypeTemplateParmDecl D,
                                                         unsigned I) {
  return static_cast<clang::NonTypeTemplateParmDecl *>(D)->getExpansionTypeSourceInfo(I);
}

// TemplateTemplateParmDecl
unsigned clang_TemplateTemplateParmDecl_getPosition(CXTemplateTemplateParmDecl D) {
  return static_cast<clang::TemplateTemplateParmDecl *>(D)->getPosition();
}

// ClassTemplateDecl
void clang_ClassTemplateDecl_LoadLazySpecializations(CXClassTemplateDecl CTD) {
  static_cast<clang::ClassTemplateDecl *>(CTD)->LoadLazySpecializations();
}

unsigned clang_ClassTemplateDecl_getNumSpecializations(CXClassTemplateDecl CTD) {
  auto Specs = static_cast<clang::ClassTemplateDecl *>(CTD)->specializations();
  unsigned N = 0;
  for (auto It = Specs.begin(), E = Specs.end(); It != E; ++It)
    ++N;
  return N;
}

void clang_ClassTemplateDecl_getSpecializations(CXClassTemplateDecl CTD,
                                                CXClassTemplateSpecializationDecl *S) {
  unsigned I = 0;
  for (auto *Spec : static_cast<clang::ClassTemplateDecl *>(CTD)->specializations())
    S[I++] = Spec;
}

// VarTemplateDecl
void clang_VarTemplateDecl_LoadLazySpecializations(CXVarTemplateDecl VTD) {
  static_cast<clang::VarTemplateDecl *>(VTD)->LoadLazySpecializations();
}

unsigned clang_VarTemplateDecl_getNumSpecializations(CXVarTemplateDecl VTD) {
  auto Specs = static_cast<clang::VarTemplateDecl *>(VTD)->specializations();
  unsigned N = 0;
  for (auto It = Specs.begin(), E = Specs.end(); It != E; ++It)
    ++N;
  return N;
}

void clang_VarTemplateDecl_getSpecializations(CXVarTemplateDecl VTD,
                                              CXVarTemplateSpecializationDecl *S) {
  unsigned I = 0;
  for (auto *Spec : static_cast<clang::VarTemplateDecl *>(VTD)->specializations())
    S[I++] = Spec;
}
