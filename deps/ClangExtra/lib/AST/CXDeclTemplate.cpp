#include "clang-ex/AST/CXDeclTemplate.h"
#include "clang/AST/DeclTemplate.h"
#include "utils.h"
#include "clang/AST/Expr.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/ASTConcept.h"
#include "llvm/ADT/SmallVector.h"
#include <optional>

// TemplateDecl
bool clang_TemplateDecl_classofKind(CXDeclKind K) {
  return clang::TemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// RedeclarableTemplateDecl
bool clang_RedeclarableTemplateDecl_classofKind(CXDeclKind K) {
  return clang::RedeclarableTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// FunctionTemplateDecl
bool clang_FunctionTemplateDecl_classofKind(CXDeclKind K) {
  return clang::FunctionTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

CXFunctionDecl clang_FunctionTemplateDecl_findSpecialization(CXFunctionTemplateDecl FTD,
                                                             CXTemplateArgumentList TAL,
                                                             void *InsertPos) {
  return static_cast<clang::FunctionTemplateDecl *>(FTD)->findSpecialization(
      static_cast<clang::TemplateArgumentList *>(TAL)->asArray(), InsertPos);
}

// TemplateTypeParmDecl
bool clang_TemplateTypeParmDecl_classofKind(CXDeclKind K) {
  return clang::TemplateTypeParmDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// NonTypeTemplateParmDecl
bool clang_NonTypeTemplateParmDecl_classofKind(CXDeclKind K) {
  return clang::NonTypeTemplateParmDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TemplateTemplateParmDecl
bool clang_TemplateTemplateParmDecl_classofKind(CXDeclKind K) {
  return clang::TemplateTemplateParmDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// BuiltinTemplateDecl
bool clang_BuiltinTemplateDecl_classofKind(CXDeclKind K) {
  return clang::BuiltinTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// ClassTemplateSpecializationDecl
bool clang_ClassTemplateSpecializationDecl_classofKind(CXDeclKind K) {
  return clang::ClassTemplateSpecializationDecl::classofKind(
      static_cast<clang::Decl::Kind>(K));
}

// ClassTemplatePartialSpecializationDecl
bool clang_ClassTemplatePartialSpecializationDecl_classofKind(CXDeclKind K) {
  return clang::ClassTemplatePartialSpecializationDecl::classofKind(
      static_cast<clang::Decl::Kind>(K));
}

// ClassTemplateDecl
bool clang_ClassTemplateDecl_classofKind(CXDeclKind K) {
  return clang::ClassTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// FriendTemplateDecl
bool clang_FriendTemplateDecl_classofKind(CXDeclKind K) {
  return clang::FriendTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TypeAliasTemplateDecl
bool clang_TypeAliasTemplateDecl_classofKind(CXDeclKind K) {
  return clang::TypeAliasTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// VarTemplateSpecializationDecl
bool clang_VarTemplateSpecializationDecl_classofKind(CXDeclKind K) {
  return clang::VarTemplateSpecializationDecl::classofKind(
      static_cast<clang::Decl::Kind>(K));
}

// VarTemplatePartialSpecializationDecl
bool clang_VarTemplatePartialSpecializationDecl_classofKind(CXDeclKind K) {
  return clang::VarTemplatePartialSpecializationDecl::classofKind(
      static_cast<clang::Decl::Kind>(K));
}

// VarTemplateDecl
bool clang_VarTemplateDecl_classofKind(CXDeclKind K) {
  return clang::VarTemplateDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

CXVarTemplateSpecializationDecl
clang_VarTemplateDecl_findSpecialization(CXVarTemplateDecl VTD, CXTemplateArgumentList TAL,
                                         void *InsertPos) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->findSpecialization(
      static_cast<clang::TemplateArgumentList *>(TAL)->asArray(), InsertPos);
}

CXVarTemplatePartialSpecializationDecl clang_VarTemplateDecl_findPartialSpecialization(
    CXVarTemplateDecl VTD, CXTemplateArgumentList TAL, CXTemplateParameterList TPL,
    void *InsertPos) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->findPartialSpecialization(
      static_cast<clang::TemplateArgumentList *>(TAL)->asArray(),
      static_cast<clang::TemplateParameterList *>(TPL), InsertPos);
}

// ConceptDecl
bool clang_ConceptDecl_classofKind(CXDeclKind K) {
  return clang::ConceptDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

// TemplateParamObjectDecl
bool clang_TemplateParamObjectDecl_classofKind(CXDeclKind K) {
  return clang::TemplateParamObjectDecl::classofKind(static_cast<clang::Decl::Kind>(K));
}

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

// TemplateDecl
void clang_TemplateDecl_setTemplateParameters(CXTemplateDecl TD,
                                              CXTemplateParameterList TPL) {
  static_cast<clang::TemplateDecl *>(TD)->setTemplateParameters(
      static_cast<clang::TemplateParameterList *>(TPL));
}

// FunctionTemplateSpecializationInfo
void clang_FunctionTemplateSpecializationInfo_setTemplateSpecializationKind(
    CXFunctionTemplateSpecializationInfo FTSI, CXTemplateSpecializationKind TSK) {
  static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)
      ->setTemplateSpecializationKind(static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_FunctionTemplateSpecializationInfo_setPointOfInstantiation(
    CXFunctionTemplateSpecializationInfo FTSI, CXSourceLocation_ POI) {
  static_cast<clang::FunctionTemplateSpecializationInfo *>(FTSI)->setPointOfInstantiation(
      clang::SourceLocation::getFromPtrEncoding(POI));
}

// MemberSpecializationInfo
void clang_MemberSpecializationInfo_setTemplateSpecializationKind(
    CXMemberSpecializationInfo MSI, CXTemplateSpecializationKind TSK) {
  static_cast<clang::MemberSpecializationInfo *>(MSI)->setTemplateSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_MemberSpecializationInfo_setPointOfInstantiation(CXMemberSpecializationInfo MSI,
                                                            CXSourceLocation_ POI) {
  static_cast<clang::MemberSpecializationInfo *>(MSI)->setPointOfInstantiation(
      clang::SourceLocation::getFromPtrEncoding(POI));
}

// TemplateTypeParmDecl
void clang_TemplateTypeParmDecl_setDefaultArgument(CXTemplateTypeParmDecl D,
                                                   CXTypeSourceInfo DefArg) {
  static_cast<clang::TemplateTypeParmDecl *>(D)->setDefaultArgument(
      static_cast<clang::TypeSourceInfo *>(DefArg));
}

void clang_TemplateTypeParmDecl_removeDefaultArgument(CXTemplateTypeParmDecl D) {
  static_cast<clang::TemplateTypeParmDecl *>(D)->removeDefaultArgument();
}

// NonTypeTemplateParmDecl
void clang_NonTypeTemplateParmDecl_setDefaultArgument(CXNonTypeTemplateParmDecl D,
                                                      CXExpr DefArg) {
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->setDefaultArgument(
      static_cast<clang::Expr *>(DefArg));
}

void clang_NonTypeTemplateParmDecl_removeDefaultArgument(CXNonTypeTemplateParmDecl D) {
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->removeDefaultArgument();
}

// TemplateTemplateParmDecl
void clang_TemplateTemplateParmDecl_setDefaultArgument(CXTemplateTemplateParmDecl D,
                                                       CXASTContext Context,
                                                       CXTemplateArgumentLoc DefArg) {
  static_cast<clang::TemplateTemplateParmDecl *>(D)->setDefaultArgument(
      *static_cast<clang::ASTContext *>(Context),
      *static_cast<clang::TemplateArgumentLoc *>(DefArg));
}

void clang_TemplateTemplateParmDecl_removeDefaultArgument(CXTemplateTemplateParmDecl D) {
  static_cast<clang::TemplateTemplateParmDecl *>(D)->removeDefaultArgument();
}

// ClassTemplateSpecializationDecl
void clang_ClassTemplateSpecializationDecl_setSpecializedTemplate(
    CXClassTemplateSpecializationDecl D, CXClassTemplateDecl CTD) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setSpecializedTemplate(
      static_cast<clang::ClassTemplateDecl *>(CTD));
}

void clang_ClassTemplateSpecializationDecl_setSpecializationKind(
    CXClassTemplateSpecializationDecl D, CXTemplateSpecializationKind TSK) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_ClassTemplateSpecializationDecl_setPointOfInstantiation(
    CXClassTemplateSpecializationDecl D, CXSourceLocation_ Loc) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setPointOfInstantiation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_ClassTemplateSpecializationDecl_setExternLoc(CXClassTemplateSpecializationDecl D,
                                                        CXSourceLocation_ Loc) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setExternLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_ClassTemplateSpecializationDecl_setTemplateKeywordLoc(
    CXClassTemplateSpecializationDecl D, CXSourceLocation_ Loc) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setTemplateKeywordLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// VarTemplateSpecializationDecl
void clang_VarTemplateSpecializationDecl_setSpecializationKind(
    CXVarTemplateSpecializationDecl D, CXTemplateSpecializationKind TSK) {
  static_cast<clang::VarTemplateSpecializationDecl *>(D)->setSpecializationKind(
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_VarTemplateSpecializationDecl_setPointOfInstantiation(
    CXVarTemplateSpecializationDecl D, CXSourceLocation_ Loc) {
  static_cast<clang::VarTemplateSpecializationDecl *>(D)->setPointOfInstantiation(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_VarTemplateSpecializationDecl_setExternLoc(CXVarTemplateSpecializationDecl D,
                                                      CXSourceLocation_ Loc) {
  static_cast<clang::VarTemplateSpecializationDecl *>(D)->setExternLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_VarTemplateSpecializationDecl_setTemplateKeywordLoc(
    CXVarTemplateSpecializationDecl D, CXSourceLocation_ Loc) {
  static_cast<clang::VarTemplateSpecializationDecl *>(D)->setTemplateKeywordLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

// TemplateParameterList
bool clang_TemplateParameterList_shouldIncludeTypeForArgument(CXTemplateParameterList TPL,
                                                              CXASTContext Context,
                                                              unsigned Idx) {
  auto *Ctx = static_cast<clang::ASTContext *>(Context);
  return clang::TemplateParameterList::shouldIncludeTypeForArgument(
      Ctx->getPrintingPolicy(), static_cast<clang::TemplateParameterList *>(TPL), Idx);
}

// TemplateDecl
CXSourceRange_ clang_TemplateDecl_getSourceRange(CXTemplateDecl TD) {
  auto rng = static_cast<clang::TemplateDecl *>(TD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// RedeclarableTemplateDecl
void clang_RedeclarableTemplateDecl_setInstantiatedFromMemberTemplate(
    CXRedeclarableTemplateDecl RTD, CXRedeclarableTemplateDecl TD) {
  static_cast<clang::RedeclarableTemplateDecl *>(RTD)->setInstantiatedFromMemberTemplate(
      static_cast<clang::RedeclarableTemplateDecl *>(TD));
}

// TemplateTypeParmDecl
unsigned clang_TemplateTypeParmDecl_getNumAssociatedConstraints(CXTemplateTypeParmDecl D) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::TemplateTypeParmDecl *>(D)->getAssociatedConstraints(AC);
  return static_cast<unsigned>(AC.size());
}

void clang_TemplateTypeParmDecl_getAssociatedConstraints(CXTemplateTypeParmDecl D,
                                                         CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::TemplateTypeParmDecl *>(D)->getAssociatedConstraints(V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

CXSourceRange_ clang_TemplateTypeParmDecl_getSourceRange(CXTemplateTypeParmDecl D) {
  auto rng = static_cast<clang::TemplateTypeParmDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// NonTypeTemplateParmDecl
unsigned
clang_NonTypeTemplateParmDecl_getNumAssociatedConstraints(CXNonTypeTemplateParmDecl D) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->getAssociatedConstraints(AC);
  return static_cast<unsigned>(AC.size());
}

void clang_NonTypeTemplateParmDecl_getAssociatedConstraints(CXNonTypeTemplateParmDecl D,
                                                            CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->getAssociatedConstraints(V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

CXSourceRange_ clang_NonTypeTemplateParmDecl_getSourceRange(CXNonTypeTemplateParmDecl D) {
  auto rng = static_cast<clang::NonTypeTemplateParmDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// TemplateTemplateParmDecl
CXSourceRange_ clang_TemplateTemplateParmDecl_getSourceRange(CXTemplateTemplateParmDecl D) {
  auto rng = static_cast<clang::TemplateTemplateParmDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// BuiltinTemplateDecl
CXSourceRange_ clang_BuiltinTemplateDecl_getSourceRange(CXBuiltinTemplateDecl D) {
  auto rng = static_cast<clang::BuiltinTemplateDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// ClassTemplateSpecializationDecl
void clang_ClassTemplateSpecializationDecl_setTypeAsWritten(
    CXClassTemplateSpecializationDecl D, CXTypeSourceInfo T) {
  static_cast<clang::ClassTemplateSpecializationDecl *>(D)->setTypeAsWritten(
      static_cast<clang::TypeSourceInfo *>(T));
}

// ClassTemplatePartialSpecializationDecl
unsigned clang_ClassTemplatePartialSpecializationDecl_getNumAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)->getAssociatedConstraints(
      AC);
  return static_cast<unsigned>(AC.size());
}

void clang_ClassTemplatePartialSpecializationDecl_getAssociatedConstraints(
    CXClassTemplatePartialSpecializationDecl D, CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)->getAssociatedConstraints(
      V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

void clang_ClassTemplatePartialSpecializationDecl_setInstantiatedFromMember(
    CXClassTemplatePartialSpecializationDecl D,
    CXClassTemplatePartialSpecializationDecl PartialSpec) {
  static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->setInstantiatedFromMember(
          static_cast<clang::ClassTemplatePartialSpecializationDecl *>(PartialSpec));
}

void clang_ClassTemplatePartialSpecializationDecl_setMemberSpecialization(
    CXClassTemplatePartialSpecializationDecl D) {
  static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D)
      ->setMemberSpecialization();
}

// ClassTemplateDecl
CXClassTemplatePartialSpecializationDecl
clang_ClassTemplateDecl_findPartialSpecInstantiatedFromMember(
    CXClassTemplateDecl CTD, CXClassTemplatePartialSpecializationDecl D) {
  return static_cast<clang::ClassTemplateDecl *>(CTD)
      ->findPartialSpecInstantiatedFromMember(
          static_cast<clang::ClassTemplatePartialSpecializationDecl *>(D));
}

// VarTemplateSpecializationDecl
void clang_VarTemplateSpecializationDecl_setTypeAsWritten(CXVarTemplateSpecializationDecl D,
                                                          CXTypeSourceInfo T) {
  static_cast<clang::VarTemplateSpecializationDecl *>(D)->setTypeAsWritten(
      static_cast<clang::TypeSourceInfo *>(T));
}

// VarTemplatePartialSpecializationDecl
unsigned clang_VarTemplatePartialSpecializationDecl_getNumAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D) {
  llvm::SmallVector<const clang::Expr *, 4> AC;
  static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->getAssociatedConstraints(
      AC);
  return static_cast<unsigned>(AC.size());
}

void clang_VarTemplatePartialSpecializationDecl_getAssociatedConstraints(
    CXVarTemplatePartialSpecializationDecl D, CXExpr *AC) {
  llvm::SmallVector<const clang::Expr *, 4> V;
  static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->getAssociatedConstraints(
      V);
  for (unsigned I = 0; I < V.size(); ++I)
    AC[I] = const_cast<clang::Expr *>(V[I]);
}

void clang_VarTemplatePartialSpecializationDecl_setInstantiatedFromMember(
    CXVarTemplatePartialSpecializationDecl D,
    CXVarTemplatePartialSpecializationDecl PartialSpec) {
  static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->setInstantiatedFromMember(
      static_cast<clang::VarTemplatePartialSpecializationDecl *>(PartialSpec));
}

void clang_VarTemplatePartialSpecializationDecl_setMemberSpecialization(
    CXVarTemplatePartialSpecializationDecl D) {
  static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->setMemberSpecialization();
}

CXSourceRange_ clang_VarTemplatePartialSpecializationDecl_getSourceRange(
    CXVarTemplatePartialSpecializationDecl D) {
  auto rng =
      static_cast<clang::VarTemplatePartialSpecializationDecl *>(D)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// VarTemplateDecl
CXVarTemplatePartialSpecializationDecl
clang_VarTemplateDecl_findPartialSpecInstantiatedFromMember(
    CXVarTemplateDecl VTD, CXVarTemplatePartialSpecializationDecl D) {
  return static_cast<clang::VarTemplateDecl *>(VTD)->findPartialSpecInstantiatedFromMember(
      static_cast<clang::VarTemplatePartialSpecializationDecl *>(D));
}

// FunctionTemplateDecl
CXFunctionTemplateDecl clang_FunctionTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ L,
                                                         CXDeclarationName Name,
                                                         CXTemplateParameterList Params,
                                                         CXNamedDecl Decl) {
  return clang::FunctionTemplateDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::DeclarationName::getFromOpaquePtr(Name),
      static_cast<clang::TemplateParameterList *>(Params),
      static_cast<clang::NamedDecl *>(Decl));
}

// TemplateTypeParmDecl
void clang_TemplateTypeParmDecl_setInheritedDefaultArgument(CXTemplateTypeParmDecl D,
                                                            CXASTContext Context,
                                                            CXTemplateTypeParmDecl Prev) {
  static_cast<clang::TemplateTypeParmDecl *>(D)->setInheritedDefaultArgument(
      *static_cast<clang::ASTContext *>(Context),
      static_cast<clang::TemplateTypeParmDecl *>(Prev));
}

// NonTypeTemplateParmDecl
void clang_NonTypeTemplateParmDecl_setInheritedDefaultArgument(
    CXNonTypeTemplateParmDecl D, CXASTContext Context, CXNonTypeTemplateParmDecl Prev) {
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->setInheritedDefaultArgument(
      *static_cast<clang::ASTContext *>(Context),
      static_cast<clang::NonTypeTemplateParmDecl *>(Prev));
}

// TemplateTemplateParmDecl
void clang_TemplateTemplateParmDecl_setInheritedDefaultArgument(
    CXTemplateTemplateParmDecl D, CXASTContext Context, CXTemplateTemplateParmDecl Prev) {
  static_cast<clang::TemplateTemplateParmDecl *>(D)->setInheritedDefaultArgument(
      *static_cast<clang::ASTContext *>(Context),
      static_cast<clang::TemplateTemplateParmDecl *>(Prev));
}

// BuiltinTemplateDecl
CXBuiltinTemplateDecl clang_BuiltinTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                       CXDeclarationName Name,
                                                       CXBuiltinTemplateKind BTK) {
  return clang::BuiltinTemplateDecl::Create(*static_cast<clang::ASTContext *>(C),
                                            static_cast<clang::DeclContext *>(DC),
                                            clang::DeclarationName::getFromOpaquePtr(Name),
                                            static_cast<clang::BuiltinTemplateKind>(BTK));
}

// ClassTemplateDecl
CXClassTemplateDecl clang_ClassTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                   CXSourceLocation_ L,
                                                   CXDeclarationName Name,
                                                   CXTemplateParameterList Params,
                                                   CXNamedDecl Decl) {
  return clang::ClassTemplateDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::DeclarationName::getFromOpaquePtr(Name),
      static_cast<clang::TemplateParameterList *>(Params),
      static_cast<clang::NamedDecl *>(Decl));
}

// FriendTemplateDecl
CXFriendTemplateDecl clang_FriendTemplateDecl_CreateWithFriendDecl(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ Loc,
    const CXTemplateParameterList *Params, unsigned NumParams, CXNamedDecl Friend,
    CXSourceLocation_ FriendLoc) {
  clang::ASTContext &Ctx = *static_cast<clang::ASTContext *>(C);
  auto **Buf = Ctx.Allocate<clang::TemplateParameterList *>(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    Buf[I] = static_cast<clang::TemplateParameterList *>(Params[I]);
  return clang::FriendTemplateDecl::Create(
      Ctx, static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      llvm::MutableArrayRef<clang::TemplateParameterList *>(Buf, NumParams),
      clang::FriendTemplateDecl::FriendUnion(static_cast<clang::NamedDecl *>(Friend)),
      clang::SourceLocation::getFromPtrEncoding(FriendLoc));
}

CXFriendTemplateDecl clang_FriendTemplateDecl_CreateWithFriendType(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ Loc,
    const CXTemplateParameterList *Params, unsigned NumParams, CXTypeSourceInfo Friend,
    CXSourceLocation_ FriendLoc) {
  clang::ASTContext &Ctx = *static_cast<clang::ASTContext *>(C);
  auto **Buf = Ctx.Allocate<clang::TemplateParameterList *>(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    Buf[I] = static_cast<clang::TemplateParameterList *>(Params[I]);
  return clang::FriendTemplateDecl::Create(
      Ctx, static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      llvm::MutableArrayRef<clang::TemplateParameterList *>(Buf, NumParams),
      clang::FriendTemplateDecl::FriendUnion(static_cast<clang::TypeSourceInfo *>(Friend)),
      clang::SourceLocation::getFromPtrEncoding(FriendLoc));
}

CXTypeSourceInfo clang_FriendTemplateDecl_getFriendType(CXFriendTemplateDecl D) {
  return static_cast<clang::FriendTemplateDecl *>(D)->getFriendType();
}

CXNamedDecl clang_FriendTemplateDecl_getFriendDecl(CXFriendTemplateDecl D) {
  return static_cast<clang::FriendTemplateDecl *>(D)->getFriendDecl();
}

CXSourceLocation_ clang_FriendTemplateDecl_getFriendLoc(CXFriendTemplateDecl D) {
  return static_cast<clang::FriendTemplateDecl *>(D)->getFriendLoc().getPtrEncoding();
}

CXTemplateParameterList
clang_FriendTemplateDecl_getTemplateParameterList(CXFriendTemplateDecl D, unsigned I) {
  return static_cast<clang::FriendTemplateDecl *>(D)->getTemplateParameterList(I);
}

unsigned clang_FriendTemplateDecl_getNumTemplateParameters(CXFriendTemplateDecl D) {
  return static_cast<clang::FriendTemplateDecl *>(D)->getNumTemplateParameters();
}

// TypeAliasTemplateDecl
CXTypeAliasTemplateDecl clang_TypeAliasTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                                           CXSourceLocation_ L,
                                                           CXDeclarationName Name,
                                                           CXTemplateParameterList Params,
                                                           CXNamedDecl Decl) {
  return clang::TypeAliasTemplateDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::DeclarationName::getFromOpaquePtr(Name),
      static_cast<clang::TemplateParameterList *>(Params),
      static_cast<clang::NamedDecl *>(Decl));
}

// VarTemplateDecl
CXVarTemplateDecl clang_VarTemplateDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ L, CXDeclarationName Name,
                                               CXTemplateParameterList Params,
                                               CXVarDecl Decl) {
  return clang::VarTemplateDecl::Create(*static_cast<clang::ASTContext *>(C),
                                        static_cast<clang::DeclContext *>(DC),
                                        clang::SourceLocation::getFromPtrEncoding(L),
                                        clang::DeclarationName::getFromOpaquePtr(Name),
                                        static_cast<clang::TemplateParameterList *>(Params),
                                        static_cast<clang::VarDecl *>(Decl));
}

// ConceptDecl
CXConceptDecl clang_ConceptDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ L, CXDeclarationName Name,
                                       CXTemplateParameterList Params,
                                       CXExpr ConstraintExpr) {
  return clang::ConceptDecl::Create(*static_cast<clang::ASTContext *>(C),
                                    static_cast<clang::DeclContext *>(DC),
                                    clang::SourceLocation::getFromPtrEncoding(L),
                                    clang::DeclarationName::getFromOpaquePtr(Name),
                                    static_cast<clang::TemplateParameterList *>(Params),
                                    static_cast<clang::Expr *>(ConstraintExpr));
}

// TemplateParameterList
CXTemplateParameterList
clang_TemplateParameterList_Create(CXASTContext C, CXSourceLocation_ TemplateLoc,
                                   CXSourceLocation_ LAngleLoc, const CXNamedDecl *Params,
                                   unsigned NumParams, CXSourceLocation_ RAngleLoc,
                                   CXExpr RequiresClause) {
  llvm::SmallVector<clang::NamedDecl *, 4> ParamVec;
  ParamVec.reserve(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    ParamVec.push_back(static_cast<clang::NamedDecl *>(const_cast<void *>(Params[I])));
  return clang::TemplateParameterList::Create(
      *static_cast<clang::ASTContext *>(C),
      clang::SourceLocation::getFromPtrEncoding(TemplateLoc),
      clang::SourceLocation::getFromPtrEncoding(LAngleLoc), ParamVec,
      clang::SourceLocation::getFromPtrEncoding(RAngleLoc),
      static_cast<clang::Expr *>(RequiresClause));
}

// DependentFunctionTemplateSpecializationInfo
unsigned clang_DependentFunctionTemplateSpecializationInfo_getNumCandidates(
    CXDependentFunctionTemplateSpecializationInfo I) {
  return static_cast<clang::DependentFunctionTemplateSpecializationInfo *>(I)
      ->getCandidates()
      .size();
}

CXFunctionTemplateDecl clang_DependentFunctionTemplateSpecializationInfo_getCandidate(
    CXDependentFunctionTemplateSpecializationInfo I, unsigned Idx) {
  return static_cast<clang::DependentFunctionTemplateSpecializationInfo *>(I)
      ->getCandidates()[Idx];
}

// TemplateTypeParmDecl
CXTemplateTypeParmDecl clang_TemplateTypeParmDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ KeyLoc, CXSourceLocation_ NameLoc,
    unsigned D, unsigned P, CXIdentifierInfo Id, bool Typename, bool ParameterPack,
    bool HasTypeConstraint, bool HasNumExpanded, unsigned NumExpanded) {
  return clang::TemplateTypeParmDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(KeyLoc),
      clang::SourceLocation::getFromPtrEncoding(NameLoc), D, P,
      static_cast<clang::IdentifierInfo *>(Id), Typename, ParameterPack, HasTypeConstraint,
      HasNumExpanded ? std::optional<unsigned>(NumExpanded) : std::nullopt);
}

bool clang_TemplateTypeParmDecl_hasInitializedTypeConstraint(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)->getTypeConstraint() != nullptr;
}

CXConceptDecl
clang_TemplateTypeParmDecl_getTypeConstraintConcept(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)
      ->getTypeConstraint()
      ->getNamedConcept();
}

CXExpr clang_TemplateTypeParmDecl_getTypeConstraintImmediatelyDeclaredConstraint(
    CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)
      ->getTypeConstraint()
      ->getImmediatelyDeclaredConstraint();
}

CXSourceLocation_
clang_TemplateTypeParmDecl_getTypeConstraintConceptNameLoc(CXTemplateTypeParmDecl D) {
  return static_cast<clang::TemplateTypeParmDecl *>(D)
      ->getTypeConstraint()
      ->getConceptNameLoc()
      .getPtrEncoding();
}

CXASTTemplateArgumentListInfo
clang_TemplateTypeParmDecl_getTypeConstraintTemplateArgsAsWritten(
    CXTemplateTypeParmDecl D) {
  return const_cast<clang::ASTTemplateArgumentListInfo *>(
      static_cast<clang::TemplateTypeParmDecl *>(D)
          ->getTypeConstraint()
          ->getTemplateArgsAsWritten());
}

// NonTypeTemplateParmDecl
CXNonTypeTemplateParmDecl clang_NonTypeTemplateParmDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc, CXSourceLocation_ IdLoc,
    unsigned D, unsigned P, CXIdentifierInfo Id, CXQualType T, bool ParameterPack,
    CXTypeSourceInfo TInfo) {
  return clang::NonTypeTemplateParmDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc), D, P,
      static_cast<clang::IdentifierInfo *>(Id), clang::QualType::getFromOpaquePtr(T),
      ParameterPack, static_cast<clang::TypeSourceInfo *>(TInfo));
}

void clang_NonTypeTemplateParmDecl_setDepth(CXNonTypeTemplateParmDecl D, unsigned Depth) {
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->setDepth(Depth);
}

void clang_NonTypeTemplateParmDecl_setPosition(CXNonTypeTemplateParmDecl D,
                                               unsigned Position) {
  static_cast<clang::NonTypeTemplateParmDecl *>(D)->setPosition(Position);
}

// TemplateTemplateParmDecl
CXTemplateTemplateParmDecl
clang_TemplateTemplateParmDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ L,
                                      unsigned D, unsigned P, bool ParameterPack,
                                      CXIdentifierInfo Id, CXTemplateParameterList Params) {
  return clang::TemplateTemplateParmDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(L), D, P, ParameterPack,
      static_cast<clang::IdentifierInfo *>(Id),
      static_cast<clang::TemplateParameterList *>(Params));
}

void clang_TemplateTemplateParmDecl_setDepth(CXTemplateTemplateParmDecl D, unsigned Depth) {
  static_cast<clang::TemplateTemplateParmDecl *>(D)->setDepth(Depth);
}

void clang_TemplateTemplateParmDecl_setPosition(CXTemplateTemplateParmDecl D,
                                                unsigned Position) {
  static_cast<clang::TemplateTemplateParmDecl *>(D)->setPosition(Position);
}

// ClassTemplateSpecializationDecl
CXDecl clang_ClassTemplateSpecializationDecl_getInstantiatedFrom(
    CXClassTemplateSpecializationDecl D) {
  auto U = static_cast<clang::ClassTemplateSpecializationDecl *>(D)->getInstantiatedFrom();
  if (auto *PD = U.dyn_cast<clang::ClassTemplatePartialSpecializationDecl *>())
    return PD;
  return U.dyn_cast<clang::ClassTemplateDecl *>();
}

// VarTemplateSpecializationDecl
CXDecl
clang_VarTemplateSpecializationDecl_getInstantiatedFrom(CXVarTemplateSpecializationDecl D) {
  auto U = static_cast<clang::VarTemplateSpecializationDecl *>(D)->getInstantiatedFrom();
  if (auto *PD = U.dyn_cast<clang::VarTemplatePartialSpecializationDecl *>())
    return PD;
  return U.dyn_cast<clang::VarTemplateDecl *>();
}

// ImplicitConceptSpecializationDecl
CXImplicitConceptSpecializationDecl clang_ImplicitConceptSpecializationDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ SL, const CXTemplateArgument *Args,
    unsigned NumArgs) {
  llvm::SmallVector<clang::TemplateArgument, 4> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(*static_cast<clang::TemplateArgument *>(const_cast<void *>(Args[I])));
  return clang::ImplicitConceptSpecializationDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(SL), ArgVec);
}

unsigned clang_ImplicitConceptSpecializationDecl_getNumTemplateArguments(
    CXImplicitConceptSpecializationDecl D) {
  return static_cast<clang::ImplicitConceptSpecializationDecl *>(D)
      ->getTemplateArguments()
      .size();
}

CXTemplateArgument clang_ImplicitConceptSpecializationDecl_getTemplateArgument(
    CXImplicitConceptSpecializationDecl D, unsigned I) {
  return const_cast<clang::TemplateArgument *>(
      &static_cast<clang::ImplicitConceptSpecializationDecl *>(D)
           ->getTemplateArguments()[I]);
}

void clang_ImplicitConceptSpecializationDecl_setTemplateArguments(
    CXImplicitConceptSpecializationDecl D, const CXTemplateArgument *Args,
    unsigned NumArgs) {
  llvm::SmallVector<clang::TemplateArgument, 4> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(*static_cast<clang::TemplateArgument *>(const_cast<void *>(Args[I])));
  static_cast<clang::ImplicitConceptSpecializationDecl *>(D)->setTemplateArguments(ArgVec);
}

bool clang_ImplicitConceptSpecializationDecl_classofKind(CXDeclKind K) {
  return clang::ImplicitConceptSpecializationDecl::classofKind(
      static_cast<clang::Decl::Kind>(K));
}
