#ifndef LLVM_CLANG_C_EXTRA_CXEXPRCONCEPTS_H
#define LLVM_CLANG_C_EXTRA_CXEXPRCONCEPTS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The two C++20 expression nodes whose Stmt classes the generated cast surface already
// names but which had no accessors at all: a concept-id (`Sortable<T>`) and a
// requires-expression. Between them they answer the three questions an analysis of modern
// C++ asks — which concept, with which arguments, and was it satisfied.

// ConceptSpecializationExpr
//
// Everything the expression knows about the concept named lives on its ConceptReference;
// the accessors clang keeps on the expression itself are forwarders, and the header marks
// them for removal. Wrapping goes through clang_ConceptSpecializationExpr_getConceptReference
// where a choice exists.

// The reference this expression was built from. BORROWED AST-arena pointer.
CXConceptReference
clang_ConceptSpecializationExpr_getConceptReference(CXConceptSpecializationExpr E);

// helper — how many arguments clang_ConceptSpecializationExpr_getTemplateArgument indexes
// (MARSHALLING.md §6, count+index). These are the SUBSTITUTED arguments, which is why they
// come from the implicit specialization decl rather than from what was written.
unsigned
clang_ConceptSpecializationExpr_getNumTemplateArguments(CXConceptSpecializationExpr E);

// PRECONDITION: I < clang_ConceptSpecializationExpr_getNumTemplateArguments(E), restated as
// an @assert in the Julia layer; out of range the shim answers NULL. A BORROWED interior
// pointer into the specialization decl's argument array — not a box, so it has no dispose.
CXTemplateArgument
clang_ConceptSpecializationExpr_getTemplateArgument(CXConceptSpecializationExpr E,
                                                    unsigned I);

// The concept named, after lookup. BORROWED.
CXConceptDecl
clang_ConceptSpecializationExpr_getNamedConcept(CXConceptSpecializationExpr E);

// The invented declaration holding the substituted arguments.
CXImplicitConceptSpecializationDecl
clang_ConceptSpecializationExpr_getSpecializationDecl(CXConceptSpecializationExpr E);

bool clang_ConceptSpecializationExpr_hasExplicitTemplateArgs(CXConceptSpecializationExpr E);

// Whether the concept held for these arguments, decided when the expression was built.
// PRECONDITION: the expression must not be value-dependent — clang asserts it, and the
// satisfaction record is meaningless (and may be absent) inside an uninstantiated template.
// Restated as an @assert in the Julia layer.
bool clang_ConceptSpecializationExpr_isSatisfied(CXConceptSpecializationExpr E);

// getSatisfaction

// ConceptReference
//
// clang/AST/ASTConcept.h. A BORROWED AST-arena object: it is created with the ASTContext's
// allocator and outlives nothing in particular, so it has no dispose.

CXConceptDecl clang_ConceptReference_getNamedConcept(CXConceptReference CR);

// The declaration name lookup actually found, which differs from the named concept when the
// concept was reached through a using-declaration.
CXNamedDecl clang_ConceptReference_getFoundDecl(CXConceptReference CR);

// getConceptNameInfo

CXSourceLocation_ clang_ConceptReference_getConceptNameLoc(CXConceptReference CR);

CXSourceLocation_ clang_ConceptReference_getTemplateKWLoc(CXConceptReference CR);

CXSourceLocation_ clang_ConceptReference_getLocation(CXConceptReference CR);

CXSourceLocation_ clang_ConceptReference_getBeginLoc(CXConceptReference CR);

CXSourceLocation_ clang_ConceptReference_getEndLoc(CXConceptReference CR);

CXSourceRange_ clang_ConceptReference_getSourceRange(CXConceptReference CR);

// The qualifier written before the concept name. OWNED heap box, the NestedNameSpecifierLoc
// convention of clang-ex/AST/CXNestedNameSpecifier.h: release it with
// clang_NestedNameSpecifierLoc_dispose. An unqualified reference boxes an empty location.
CXNestedNameSpecifierLoc
clang_ConceptReference_getNestedNameSpecifierLoc(CXConceptReference CR);

// The arguments as WRITTEN, which a type-constraint may not have at all. NULL then; the
// substituted arguments are on the expression instead.
CXASTTemplateArgumentListInfo
clang_ConceptReference_getTemplateArgsAsWritten(CXConceptReference CR);

bool clang_ConceptReference_hasExplicitTemplateArgs(CXConceptReference CR);

// print
// dump

// Requirement
//
// clang::concepts::Requirement and its three subclasses, the entries of a
// requires-expression's body. BORROWED AST-arena pointers owned by the RequiresExpr.

// clang/AST/ExprConcepts.h: enum clang::concepts::Requirement::RequirementKind. RK_Simple
// and RK_Compound are both ExprRequirement — the kind is what tells them apart.
typedef enum CXRequirement_RequirementKind {
  CXRequirement_RK_Type,
  CXRequirement_RK_Simple,
  CXRequirement_RK_Compound,
  CXRequirement_RK_Nested
} CXRequirement_RequirementKind;

// clang/AST/ExprConcepts.h: enum clang::concepts::TypeRequirement::SatisfactionStatus.
typedef enum CXTypeRequirement_SatisfactionStatus {
  CXTypeRequirement_SS_Dependent,
  CXTypeRequirement_SS_SubstitutionFailure,
  CXTypeRequirement_SS_Satisfied
} CXTypeRequirement_SatisfactionStatus;

// clang/AST/ExprConcepts.h: enum clang::concepts::ExprRequirement::SatisfactionStatus —
// ordered, and clang compares against it with >=.
typedef enum CXExprRequirement_SatisfactionStatus {
  CXExprRequirement_SS_Dependent,
  CXExprRequirement_SS_ExprSubstitutionFailure,
  CXExprRequirement_SS_NoexceptNotMet,
  CXExprRequirement_SS_TypeRequirementSubstitutionFailure,
  CXExprRequirement_SS_ConstraintsNotSatisfied,
  CXExprRequirement_SS_Satisfied
} CXExprRequirement_SatisfactionStatus;

CXRequirement_RequirementKind clang_Requirement_getKind(CXRequirement R);

// PRECONDITION: R must not be dependent — clang asserts it. Restated as an @assert in the
// Julia layer.
bool clang_Requirement_isSatisfied(CXRequirement R);

bool clang_Requirement_isDependent(CXRequirement R);

bool clang_Requirement_containsUnexpandedParameterPack(CXRequirement R);

// Requirement Cast
//
// The kind is the discriminator, so each cast answers NULL when it does not match. There is
// no llvm::dyn_cast route here: concepts::Requirement is not polymorphic and its subclasses
// are plain single-inheritance, so the class check is the kind check clang's own classof
// performs.
CXTypeRequirement clang_Requirement_castToTypeRequirement(CXRequirement R);

CXExprRequirement clang_Requirement_castToExprRequirement(CXRequirement R);

CXNestedRequirement clang_Requirement_castToNestedRequirement(CXRequirement R);

// TypeRequirement
CXTypeRequirement_SatisfactionStatus
clang_TypeRequirement_getSatisfactionStatus(CXTypeRequirement R);

bool clang_TypeRequirement_isSubstitutionFailure(CXTypeRequirement R);

// getSubstitutionDiagnostic

// The type named by a `typename T::foo;` requirement.
// PRECONDITION: !clang_TypeRequirement_isSubstitutionFailure(R) — clang asserts it, then
// unconditionally reads the other arm of the union.
CXTypeSourceInfo clang_TypeRequirement_getType(CXTypeRequirement R);

// ExprRequirement
bool clang_ExprRequirement_isSimple(CXExprRequirement R);

bool clang_ExprRequirement_isCompound(CXExprRequirement R);

bool clang_ExprRequirement_hasNoexceptRequirement(CXExprRequirement R);

CXSourceLocation_ clang_ExprRequirement_getNoexceptLoc(CXExprRequirement R);

CXExprRequirement_SatisfactionStatus
clang_ExprRequirement_getSatisfactionStatus(CXExprRequirement R);

bool clang_ExprRequirement_isExprSubstitutionFailure(CXExprRequirement R);

// getReturnTypeRequirement
// getReturnTypeRequirementSubstitutedConstraintExpr
// getExprSubstitutionDiagnostic

// The expression the requirement checks.
// PRECONDITION: !clang_ExprRequirement_isExprSubstitutionFailure(R) — clang asserts it,
// then unconditionally reads the other arm of the union.
CXExpr clang_ExprRequirement_getExpr(CXExprRequirement R);

// NestedRequirement
bool clang_NestedRequirement_hasInvalidConstraint(CXNestedRequirement R);

// PRECONDITION: clang_NestedRequirement_hasInvalidConstraint(R). The CXString is
// caller-owned.
CXString clang_NestedRequirement_getInvalidConstraintEntity(CXNestedRequirement R);

// PRECONDITION: !clang_NestedRequirement_hasInvalidConstraint(R).
CXExpr clang_NestedRequirement_getConstraintExpr(CXNestedRequirement R);

// getConstraintSatisfaction

// createSubstDiagAt

// RequiresExpr

// helper — how many parameters clang_RequiresExpr_getLocalParameter indexes: the
// `requires (T a, T b)` list.
unsigned clang_RequiresExpr_getNumLocalParameters(CXRequiresExpr E);

// PRECONDITION: I < clang_RequiresExpr_getNumLocalParameters(E); out of range the shim
// answers NULL.
CXParmVarDecl clang_RequiresExpr_getLocalParameter(CXRequiresExpr E, unsigned I);

CXRequiresExprBodyDecl clang_RequiresExpr_getBody(CXRequiresExpr E);

// helper — how many requirements clang_RequiresExpr_getRequirement indexes.
unsigned clang_RequiresExpr_getNumRequirements(CXRequiresExpr E);

// PRECONDITION: I < clang_RequiresExpr_getNumRequirements(E); out of range the shim answers
// NULL. BORROWED — the requirements are trailing objects of E.
CXRequirement clang_RequiresExpr_getRequirement(CXRequiresExpr E, unsigned I);

// PRECONDITION: E must not be value-dependent — clang asserts it. Restated as an @assert in
// the Julia layer.
bool clang_RequiresExpr_isSatisfied(CXRequiresExpr E);

// setSatisfied

CXSourceLocation_ clang_RequiresExpr_getRequiresKWLoc(CXRequiresExpr E);

CXSourceLocation_ clang_RequiresExpr_getLParenLoc(CXRequiresExpr E);

CXSourceLocation_ clang_RequiresExpr_getRParenLoc(CXRequiresExpr E);

CXSourceLocation_ clang_RequiresExpr_getRBraceLoc(CXRequiresExpr E);

LLVM_CLANG_C_EXTERN_C_END

#endif
