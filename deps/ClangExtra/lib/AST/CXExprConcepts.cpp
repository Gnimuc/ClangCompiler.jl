#include "clang-ex/AST/CXExprConcepts.h"
#include "utils.h"

#include "clang/AST/ASTConcept.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclTemplate.h"
#include "clang/AST/ExprConcepts.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/TemplateBase.h"

#include <string>

namespace {

clang::ConceptSpecializationExpr *conceptExpr(CXConceptSpecializationExpr E) {
  return reinterpret_cast<clang::ConceptSpecializationExpr *>(E);
}

clang::ConceptReference *conceptRef(CXConceptReference CR) {
  return reinterpret_cast<clang::ConceptReference *>(CR);
}

clang::concepts::Requirement *requirement(CXRequirement R) {
  return reinterpret_cast<clang::concepts::Requirement *>(R);
}

clang::RequiresExpr *requiresExpr(CXRequiresExpr E) {
  return reinterpret_cast<clang::RequiresExpr *>(E);
}

CXSourceLocation_ encode(clang::SourceLocation Loc) {
  return reinterpret_cast<CXSourceLocation_>(Loc.getPtrEncoding());
}

} // namespace

// ConceptSpecializationExpr
CXConceptReference
clang_ConceptSpecializationExpr_getConceptReference(CXConceptSpecializationExpr E) {
  return reinterpret_cast<CXConceptReference>(conceptExpr(E)->getConceptReference());
}

unsigned
clang_ConceptSpecializationExpr_getNumTemplateArguments(CXConceptSpecializationExpr E) {
  return static_cast<unsigned>(conceptExpr(E)->getTemplateArguments().size());
}

CXTemplateArgument
clang_ConceptSpecializationExpr_getTemplateArgument(CXConceptSpecializationExpr E,
                                                    unsigned I) {
  llvm::ArrayRef<clang::TemplateArgument> Args = conceptExpr(E)->getTemplateArguments();
  if (I >= Args.size())
    return nullptr;
  return reinterpret_cast<CXTemplateArgument>(
      const_cast<clang::TemplateArgument *>(&Args[I]));
}

CXConceptDecl
clang_ConceptSpecializationExpr_getNamedConcept(CXConceptSpecializationExpr E) {
  return reinterpret_cast<CXConceptDecl>(conceptExpr(E)->getNamedConcept());
}

CXImplicitConceptSpecializationDecl
clang_ConceptSpecializationExpr_getSpecializationDecl(CXConceptSpecializationExpr E) {
  return reinterpret_cast<CXImplicitConceptSpecializationDecl>(
      const_cast<clang::ImplicitConceptSpecializationDecl *>(
          conceptExpr(E)->getSpecializationDecl()));
}

bool clang_ConceptSpecializationExpr_hasExplicitTemplateArgs(
    CXConceptSpecializationExpr E) {
  return conceptExpr(E)->hasExplicitTemplateArgs();
}

bool clang_ConceptSpecializationExpr_isSatisfied(CXConceptSpecializationExpr E) {
  return conceptExpr(E)->isSatisfied();
}

// getSatisfaction

// ConceptReference
CXConceptDecl clang_ConceptReference_getNamedConcept(CXConceptReference CR) {
  return reinterpret_cast<CXConceptDecl>(conceptRef(CR)->getNamedConcept());
}

CXNamedDecl clang_ConceptReference_getFoundDecl(CXConceptReference CR) {
  return reinterpret_cast<CXNamedDecl>(conceptRef(CR)->getFoundDecl());
}

// getConceptNameInfo

CXSourceLocation_ clang_ConceptReference_getConceptNameLoc(CXConceptReference CR) {
  return encode(conceptRef(CR)->getConceptNameLoc());
}

CXSourceLocation_ clang_ConceptReference_getTemplateKWLoc(CXConceptReference CR) {
  return encode(conceptRef(CR)->getTemplateKWLoc());
}

CXSourceLocation_ clang_ConceptReference_getLocation(CXConceptReference CR) {
  return encode(conceptRef(CR)->getLocation());
}

CXSourceLocation_ clang_ConceptReference_getBeginLoc(CXConceptReference CR) {
  return encode(conceptRef(CR)->getBeginLoc());
}

CXSourceLocation_ clang_ConceptReference_getEndLoc(CXConceptReference CR) {
  return encode(conceptRef(CR)->getEndLoc());
}

CXSourceRange_ clang_ConceptReference_getSourceRange(CXConceptReference CR) {
  clang::SourceRange R = conceptRef(CR)->getSourceRange();
  return CXSourceRange_{encode(R.getBegin()), encode(R.getEnd())};
}

CXNestedNameSpecifierLoc
clang_ConceptReference_getNestedNameSpecifierLoc(CXConceptReference CR) {
  return reinterpret_cast<CXNestedNameSpecifierLoc>(
      new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
          conceptRef(CR)->getNestedNameSpecifierLoc()));
}

CXASTTemplateArgumentListInfo
clang_ConceptReference_getTemplateArgsAsWritten(CXConceptReference CR) {
  return reinterpret_cast<CXASTTemplateArgumentListInfo>(
      const_cast<clang::ASTTemplateArgumentListInfo *>(
          conceptRef(CR)->getTemplateArgsAsWritten()));
}

bool clang_ConceptReference_hasExplicitTemplateArgs(CXConceptReference CR) {
  return conceptRef(CR)->hasExplicitTemplateArgs();
}

// print
// dump

// Requirement
CXRequirement_RequirementKind clang_Requirement_getKind(CXRequirement R) {
  return static_cast<CXRequirement_RequirementKind>(requirement(R)->getKind());
}

bool clang_Requirement_isSatisfied(CXRequirement R) {
  return requirement(R)->isSatisfied();
}

bool clang_Requirement_isDependent(CXRequirement R) {
  return requirement(R)->isDependent();
}

bool clang_Requirement_containsUnexpandedParameterPack(CXRequirement R) {
  return requirement(R)->containsUnexpandedParameterPack();
}

// Requirement Cast
//
// Each classof is the kind check, so llvm's own narrowing is the class check -- no RTTI is
// involved (concepts::Requirement is not even polymorphic).
CXTypeRequirement clang_Requirement_castToTypeRequirement(CXRequirement R) {
  return reinterpret_cast<CXTypeRequirement>(
      llvm::dyn_cast_or_null<clang::concepts::TypeRequirement>(requirement(R)));
}

CXExprRequirement clang_Requirement_castToExprRequirement(CXRequirement R) {
  return reinterpret_cast<CXExprRequirement>(
      llvm::dyn_cast_or_null<clang::concepts::ExprRequirement>(requirement(R)));
}

CXNestedRequirement clang_Requirement_castToNestedRequirement(CXRequirement R) {
  return reinterpret_cast<CXNestedRequirement>(
      llvm::dyn_cast_or_null<clang::concepts::NestedRequirement>(requirement(R)));
}

// TypeRequirement
CXTypeRequirement_SatisfactionStatus
clang_TypeRequirement_getSatisfactionStatus(CXTypeRequirement R) {
  return static_cast<CXTypeRequirement_SatisfactionStatus>(
      reinterpret_cast<clang::concepts::TypeRequirement *>(R)->getSatisfactionStatus());
}

bool clang_TypeRequirement_isSubstitutionFailure(CXTypeRequirement R) {
  return reinterpret_cast<clang::concepts::TypeRequirement *>(R)->isSubstitutionFailure();
}

// getSubstitutionDiagnostic

CXTypeSourceInfo clang_TypeRequirement_getType(CXTypeRequirement R) {
  return reinterpret_cast<CXTypeSourceInfo>(
      reinterpret_cast<clang::concepts::TypeRequirement *>(R)->getType());
}

// ExprRequirement
bool clang_ExprRequirement_isSimple(CXExprRequirement R) {
  return reinterpret_cast<clang::concepts::ExprRequirement *>(R)->isSimple();
}

bool clang_ExprRequirement_isCompound(CXExprRequirement R) {
  return reinterpret_cast<clang::concepts::ExprRequirement *>(R)->isCompound();
}

bool clang_ExprRequirement_hasNoexceptRequirement(CXExprRequirement R) {
  return reinterpret_cast<clang::concepts::ExprRequirement *>(R)->hasNoexceptRequirement();
}

CXSourceLocation_ clang_ExprRequirement_getNoexceptLoc(CXExprRequirement R) {
  return encode(reinterpret_cast<clang::concepts::ExprRequirement *>(R)->getNoexceptLoc());
}

CXExprRequirement_SatisfactionStatus
clang_ExprRequirement_getSatisfactionStatus(CXExprRequirement R) {
  return static_cast<CXExprRequirement_SatisfactionStatus>(
      reinterpret_cast<clang::concepts::ExprRequirement *>(R)->getSatisfactionStatus());
}

bool clang_ExprRequirement_isExprSubstitutionFailure(CXExprRequirement R) {
  return reinterpret_cast<clang::concepts::ExprRequirement *>(R)
      ->isExprSubstitutionFailure();
}

// getReturnTypeRequirement
// getReturnTypeRequirementSubstitutedConstraintExpr
// getExprSubstitutionDiagnostic

CXExpr clang_ExprRequirement_getExpr(CXExprRequirement R) {
  return reinterpret_cast<CXExpr>(
      reinterpret_cast<clang::concepts::ExprRequirement *>(R)->getExpr());
}

// NestedRequirement
bool clang_NestedRequirement_hasInvalidConstraint(CXNestedRequirement R) {
  return reinterpret_cast<clang::concepts::NestedRequirement *>(R)->hasInvalidConstraint();
}

CXString clang_NestedRequirement_getInvalidConstraintEntity(CXNestedRequirement R) {
  llvm::StringRef Entity = reinterpret_cast<clang::concepts::NestedRequirement *>(R)
                               ->getInvalidConstraintEntity();
  return extra::makeCXString(Entity.str());
}

CXExpr clang_NestedRequirement_getConstraintExpr(CXNestedRequirement R) {
  return reinterpret_cast<CXExpr>(
      reinterpret_cast<clang::concepts::NestedRequirement *>(R)->getConstraintExpr());
}

// getConstraintSatisfaction
// createSubstDiagAt

// RequiresExpr
unsigned clang_RequiresExpr_getNumLocalParameters(CXRequiresExpr E) {
  return static_cast<unsigned>(requiresExpr(E)->getLocalParameters().size());
}

CXParmVarDecl clang_RequiresExpr_getLocalParameter(CXRequiresExpr E, unsigned I) {
  llvm::ArrayRef<clang::ParmVarDecl *> Params = requiresExpr(E)->getLocalParameters();
  if (I >= Params.size())
    return nullptr;
  return reinterpret_cast<CXParmVarDecl>(Params[I]);
}

CXRequiresExprBodyDecl clang_RequiresExpr_getBody(CXRequiresExpr E) {
  return reinterpret_cast<CXRequiresExprBodyDecl>(requiresExpr(E)->getBody());
}

unsigned clang_RequiresExpr_getNumRequirements(CXRequiresExpr E) {
  return static_cast<unsigned>(requiresExpr(E)->getRequirements().size());
}

CXRequirement clang_RequiresExpr_getRequirement(CXRequiresExpr E, unsigned I) {
  llvm::ArrayRef<clang::concepts::Requirement *> Reqs = requiresExpr(E)->getRequirements();
  if (I >= Reqs.size())
    return nullptr;
  return reinterpret_cast<CXRequirement>(Reqs[I]);
}

bool clang_RequiresExpr_isSatisfied(CXRequiresExpr E) {
  return requiresExpr(E)->isSatisfied();
}

// setSatisfied

CXSourceLocation_ clang_RequiresExpr_getRequiresKWLoc(CXRequiresExpr E) {
  return encode(requiresExpr(E)->getRequiresKWLoc());
}

CXSourceLocation_ clang_RequiresExpr_getLParenLoc(CXRequiresExpr E) {
  return encode(requiresExpr(E)->getLParenLoc());
}

CXSourceLocation_ clang_RequiresExpr_getRParenLoc(CXRequiresExpr E) {
  return encode(requiresExpr(E)->getRParenLoc());
}

CXSourceLocation_ clang_RequiresExpr_getRBraceLoc(CXRequiresExpr E) {
  return encode(requiresExpr(E)->getRBraceLoc());
}
