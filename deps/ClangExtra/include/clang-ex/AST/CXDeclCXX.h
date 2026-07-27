#ifndef LLVM_CLANG_C_EXTRA_CXDECLCXX_H
#define LLVM_CLANG_C_EXTRA_CXDECLCXX_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXOperatorKinds.h"

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

CXSourceLocation_ clang_CXXBaseSpecifier_getBeginLoc(CXCXXBaseSpecifier CXXBS);

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

// CXXRecordDecl::LambdaDependencyKind
typedef enum CXLambdaDependencyKind {
  CXLambdaDependencyKind_Unknown = 0,
  CXLambdaDependencyKind_AlwaysDependent,
  CXLambdaDependencyKind_NeverDependent
} CXLambdaDependencyKind;

CXCXXRecordDecl clang_CXXRecordDecl_CreateLambda(CXASTContext C, CXDeclContext DC,
                                                 CXTypeSourceInfo Info,
                                                 CXSourceLocation_ Loc,
                                                 CXLambdaDependencyKind DependencyKind,
                                                 bool IsGeneric,
                                                 CXLambdaCaptureDefault CaptureDefault);

bool clang_CXXRecordDecl_isDynamicClass(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isLambda(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isGenericLambda(CXCXXRecordDecl CXXRD);

CXTemplateParameterList
clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isAggregate(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isPOD(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isCLike(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isEmpty(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_allowConstDefaultInit(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_defaultedCopyConstructorIsDeleted(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_defaultedDefaultConstructorIsConstexpr(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_defaultedDestructorIsConstexpr(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_defaultedDestructorIsDeleted(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_defaultedMoveConstructorIsDeleted(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasAnyDependentBases(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasConstexprDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasConstexprDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasConstexprNonCopyMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasCopyAssignmentWithConstParam(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasCopyConstructorWithConstParam(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasDirectFields(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasFriends(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasInClassInitializer(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasInheritedAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasInheritedConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasInitMethod(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasIrrelevantDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasKnownLambdaInternalLinkage(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasMutableFields(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonLiteralTypeFieldsOrBases(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialCopyConstructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialDestructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasNonTrivialMoveConstructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasPrivateFields(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasProtectedFields(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasSimpleCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasSimpleCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasSimpleDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasSimpleMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasSimpleMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialCopyConstructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialDestructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasTrivialMoveConstructorForCall(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUninitializedReferenceMember(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserDeclaredMoveOperation(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasUserProvidedDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_hasVariantMembers(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isAbstract(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isAnyDestructorNoReturn(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isCXX11StandardLayout(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isCapturelessLambda(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isDependentLambda(CXCXXRecordDecl CXXRD);

// Narrow predicates in place of the std::function-taking forallBases/
// lookupInBases (the walk runs entirely on the C++ side); both require the
// receiver to have a definition.
bool clang_CXXRecordDecl_isDerivedFrom(CXCXXRecordDecl CXXRD, CXCXXRecordDecl Base);

bool clang_CXXRecordDecl_isEffectivelyFinal(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isInterfaceLike(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isLiteral(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isNeverDependentLambda(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isParsingBaseSpecifiers(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isPolymorphic(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isStandardLayout(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isStructural(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isTrivial(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isTriviallyCopyConstructible(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isTriviallyCopyable(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_isVirtuallyDerivedFrom(CXCXXRecordDecl CXXRD,
                                                CXCXXRecordDecl Base);

bool clang_CXXRecordDecl_mayBeAbstract(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_mayBeDynamicClass(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_mayBeNonDynamicClass(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitDefaultConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsImplicitMoveConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsOverloadResolutionForCopyAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsOverloadResolutionForCopyConstructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsOverloadResolutionForDestructor(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsOverloadResolutionForMoveAssignment(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_needsOverloadResolutionForMoveConstructor(CXCXXRecordDecl CXXRD);

// bases: random-access (bases_begin is a contiguous CXXBaseSpecifier array).
// getNumBases/getNumVBases require a complete definition.
unsigned clang_CXXRecordDecl_getNumBases(CXCXXRecordDecl CXXRD);

CXCXXBaseSpecifier clang_CXXRecordDecl_getBase(CXCXXRecordDecl CXXRD, unsigned i);

unsigned clang_CXXRecordDecl_getNumVBases(CXCXXRecordDecl CXXRD);

CXCXXBaseSpecifier clang_CXXRecordDecl_getVBase(CXCXXRecordDecl CXXRD, unsigned i);

// methods/ctors: two-call protocol (specific_decl_iterator is forward-only).
unsigned clang_CXXRecordDecl_getNumMethods(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getMethods(CXCXXRecordDecl CXXRD, CXCXXMethodDecl *Buf);

unsigned clang_CXXRecordDecl_getNumCtors(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getCtors(CXCXXRecordDecl CXXRD, CXCXXConstructorDecl *Buf);

// lambda closure-type accessors. PARTIAL: each of these reaches
// clang::CXXRecordDecl::getLambdaData(), whose assert(DD && DD->IsLambda) is the
// only guard — on a non-lambda class the DefinitionData is reinterpreted as a
// LambdaDefinitionData. The Julia wrappers restate isLambda() (Invariant 3).
CXCXXMethodDecl clang_CXXRecordDecl_getLambdaCallOperator(CXCXXRecordDecl CXXRD);

// Null unless the closure type is a generic (templated) lambda.
CXFunctionTemplateDecl
clang_CXXRecordDecl_getDependentLambdaCallOperator(CXCXXRecordDecl CXXRD);

// Uses the call operator's own calling convention (the CallingConv overload is
// not wrapped).
CXCXXMethodDecl clang_CXXRecordDecl_getLambdaStaticInvoker(CXCXXRecordDecl CXXRD);

CXLambdaCaptureDefault clang_CXXRecordDecl_getLambdaCaptureDefault(CXCXXRecordDecl CXXRD);

unsigned clang_CXXRecordDecl_getLambdaManglingNumber(CXCXXRecordDecl CXXRD);

unsigned clang_CXXRecordDecl_getLambdaIndexInContext(CXCXXRecordDecl CXXRD);

// Null when the lambda's normal declaration context is specific enough.
CXDecl clang_CXXRecordDecl_getLambdaContextDecl(CXCXXRecordDecl CXXRD);

CXTypeSourceInfo clang_CXXRecordDecl_getLambdaTypeInfo(CXCXXRecordDecl CXXRD);

// PARTIAL: getDestructor() and the conversion-function range below both go
// through data(), which asserts a complete definition.
CXCXXDestructorDecl clang_CXXRecordDecl_getDestructor(CXCXXRecordDecl CXXRD);

// visible conversion functions: two-call protocol (UnresolvedSetIterator is not
// a contiguous NamedDecl * array). Entries are CXXConversionDecl or
// FunctionTemplateDecl, so they cross at their common CXNamedDecl base.
unsigned clang_CXXRecordDecl_getNumVisibleConversionFunctions(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getVisibleConversionFunctions(CXCXXRecordDecl CXXRD,
                                                       CXNamedDecl *Buf);

// Null when this class is not a template instantiation.
CXCXXRecordDecl clang_CXXRecordDecl_getTemplateInstantiationPattern(CXCXXRecordDecl CXXRD);

CXTemplateSpecializationKind
clang_CXXRecordDecl_getTemplateSpecializationKind(CXCXXRecordDecl CXXRD);

// Null when this class is not a member class of a class template.
CXCXXRecordDecl clang_CXXRecordDecl_getInstantiatedFromMemberClass(CXCXXRecordDecl CXXRD);

// The enclosing function for a local class [class.local], null otherwise.
CXFunctionDecl clang_CXXRecordDecl_isLocalClass(CXCXXRecordDecl CXXRD);

// CXXRecordDecl declares its own getODRHash, which hides RecordDecl's; PARTIAL:
// it asserts a complete definition.
unsigned clang_CXXRecordDecl_getODRHash(CXCXXRecordDecl CXXRD);

// PARTIAL: both read clang's definition data, which asserts a complete
// definition.
bool clang_CXXRecordDecl_implicitCopyConstructorHasConstParam(CXCXXRecordDecl CXXRD);

bool clang_CXXRecordDecl_implicitCopyAssignmentHasConstParam(CXCXXRecordDecl CXXRD);

// PARTIAL: asserts isLambda().
bool clang_CXXRecordDecl_lambdaIsDefaultConstructibleAndAssignable(CXCXXRecordDecl CXXRD);

// getLambdaExplicitTemplateParameters: random-access (the ArrayRef is a
// contiguous NamedDecl * view into the generic lambda's template parameter
// list). Total - the count is 0 for anything that is not a generic lambda.
unsigned clang_CXXRecordDecl_getNumLambdaExplicitTemplateParameters(CXCXXRecordDecl CXXRD);

CXNamedDecl clang_CXXRecordDecl_getLambdaExplicitTemplateParameter(CXCXXRecordDecl CXXRD,
                                                                   unsigned i);

// captures: random-access (captures_begin is a contiguous LambdaCapture array).
// PARTIAL: capture_size reaches getLambdaData(), whose assert(DD && DD->IsLambda)
// is the only guard; getCapture additionally asserts I < capture_size(). The
// returned LambdaCapture borrows into the closure type's capture list.
unsigned clang_CXXRecordDecl_capture_size(CXCXXRecordDecl CXXRD);

CXLambdaCapture clang_CXXRecordDecl_getCapture(CXCXXRecordDecl CXXRD, unsigned I);

// Null unless this class is an instantiation of a member class of a class
// template specialization.
CXMemberSpecializationInfo
clang_CXXRecordDecl_getMemberSpecializationInfo(CXCXXRecordDecl CXXRD);

// Null unless this record is the pattern that describes a class template.
CXClassTemplateDecl clang_CXXRecordDecl_getDescribedClassTemplate(CXCXXRecordDecl CXXRD);

// PARTIAL: asserts the receiver, viewed as a DeclContext, is dependent.
bool clang_CXXRecordDecl_isCurrentInstantiation(CXCXXRecordDecl CXXRD,
                                                CXDeclContext CurContext);

// PARTIAL: walks the bases through forallBases(), so the receiver needs a
// complete definition.
bool clang_CXXRecordDecl_isProvablyNotDerivedFrom(CXCXXRecordDecl CXXRD,
                                                  CXCXXRecordDecl Base);

// getIndirectPrimaryBases: two-call protocol (the C++ result is a set, not a
// contiguous array). Both calls re-run the same walk; the count is exact and no
// slot is null. PARTIAL: the walk reads the definition data and lays out every
// base class, so the receiver needs a complete, non-dependent definition. It is
// 0 for a class with no virtual bases (clang takes an early exit).
unsigned clang_CXXRecordDecl_getNumIndirectPrimaryBases(CXCXXRecordDecl CXXRD);

// Fills Buf with clang_CXXRecordDecl_getNumIndirectPrimaryBases entries. The
// order is the underlying set's iteration order, which is unspecified.
void clang_CXXRecordDecl_getIndirectPrimaryBases(CXCXXRecordDecl CXXRD,
                                                 CXCXXRecordDecl *Buf);

// PARTIAL: looks into the non-dependent bases through forallBases(), so the
// receiver needs a complete definition. No ambiguity check is performed.
bool clang_CXXRecordDecl_hasMemberName(CXCXXRecordDecl CXXRD, CXDeclarationName N);

// Static; PARTIAL: asserts DeclAccess != AS_none.
CXAccessSpecifier clang_CXXRecordDecl_MergeAccess(CXAccessSpecifier PathAccess,
                                                  CXAccessSpecifier DeclAccess);

// PARTIAL: asserts isLambda().
unsigned clang_CXXRecordDecl_getDeviceLambdaManglingNumber(CXCXXRecordDecl CXXRD);

// Total: CXLambdaDependencyKind_Unknown when the class is not a lambda.
CXLambdaDependencyKind clang_CXXRecordDecl_getLambdaDependencyKind(CXCXXRecordDecl CXXRD);

// ExplicitSpecifier
CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES);

CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES);

bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES);

// isEquivalent
bool clang_ExplicitSpecifier_isEquivalent(CXExplicitSpecifier ES,
                                          CXExplicitSpecifier Other);

bool clang_ExplicitSpecifier_isExplicit(CXExplicitSpecifier ES);

bool clang_ExplicitSpecifier_isInvalid(CXExplicitSpecifier ES);

void clang_ExplicitSpecifier_setKind(CXExplicitSpecifier ES, CXExplicitSpecKind Kind);

void clang_ExplicitSpecifier_setExpr(CXExplicitSpecifier ES, CXExpr E);

// getFromDecl
// Invalid
// Both producers return a heap-boxed copy of the by-value clang::ExplicitSpecifier:
// caller-owned, released with clang_ExplicitSpecifier_dispose. Mutating the copy
// through setKind/setExpr does not touch the declaration it came from.
CXExplicitSpecifier clang_ExplicitSpecifier_getFromDecl(CXFunctionDecl FD);

CXExplicitSpecifier clang_ExplicitSpecifier_Invalid(void);

void clang_ExplicitSpecifier_dispose(CXExplicitSpecifier ES);

// CXXDeductionGuideDecl
typedef enum CXDeductionCandidate : unsigned char {
  CXDeductionCandidate_Normal,
  CXDeductionCandidate_Copy,
  CXDeductionCandidate_Aggregate
} CXDeductionCandidate;

bool clang_CXXDeductionGuideDecl_isExplicit(CXCXXDeductionGuideDecl DGD);

// Owned copy of the by-value specifier: clang_ExplicitSpecifier_dispose.
CXExplicitSpecifier
clang_CXXDeductionGuideDecl_getExplicitSpecifier(CXCXXDeductionGuideDecl DGD);

CXCXXConstructorDecl
clang_CXXDeductionGuideDecl_getCorrespondingConstructor(CXCXXDeductionGuideDecl DGD);

CXTemplateDecl
clang_CXXDeductionGuideDecl_getDeducedTemplate(CXCXXDeductionGuideDecl DGD);

CXDeductionCandidate
clang_CXXDeductionGuideDecl_getDeductionCandidateKind(CXCXXDeductionGuideDecl DGD);

// RequiresExprBodyDecl
CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ StartLoc);

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_CreateDeserialized(CXASTContext C,
                                                                     unsigned ID);

// RequiresExprBodyDecl Cast
CXDeclContext clang_RequiresExprBodyDecl_castToDeclContext(CXRequiresExprBodyDecl REBD);

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_castFromDeclContext(CXDeclContext DC);

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

// Static; true for the allocation and deallocation operators, which are implicitly
// static members when declared in a class.
bool clang_CXXMethodDecl_isStaticOverloadedOperator(CXOverloadedOperatorKind OOK);

bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(CXCXXMethodDecl CXXMD,
                                                           CXExpr Base, bool IsAppleKext);

// isUsualDeallocationFunction

// helper: runs clang::CXXMethodDecl::isUsualDeallocationFunction with a throw-away
// PreventedBy buffer, so the declarations that prevented a false answer are dropped.
bool clang_CXXMethodDecl_isUsualDeallocationFunction(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isCopyAssignmentOperator(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isMoveAssignmentOperator(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getCanonicalDecl(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getMostRecentDecl(CXCXXMethodDecl CXXMD);

void clang_CXXMethodDecl_addOverriddenMethod(CXCXXMethodDecl CXXMD, CXCXXMethodDecl MD);

CXCXXRecordDecl clang_CXXMethodDecl_getParent(CXCXXMethodDecl CXXMD);

CXQualType clang_CXXMethodDecl_getThisType(CXCXXMethodDecl CXXMD);

// PARTIAL: castAs<FunctionProtoType> on the method's type, and (like getThisType)
// only meaningful for instance methods. The reference form keeps the method's
// ref-qualifier; the plain form strips it.
CXQualType
clang_CXXMethodDecl_getFunctionObjectParameterReferenceType(CXCXXMethodDecl CXXMD);

CXQualType clang_CXXMethodDecl_getFunctionObjectParameterType(CXCXXMethodDecl CXXMD);

// getMethodQualifiers
// getRefQualifier
// PARTIAL: castAs<FunctionProtoType> on the method's type. The qualifiers cross as
// the opaque clang::Qualifiers encoding (MARSHALLING.md section 7), the same encoding
// clang_QualType_getQualifiersAsOpaqueValue returns.
unsigned clang_CXXMethodDecl_getMethodQualifiers(CXCXXMethodDecl CXXMD);

// PARTIAL: castAs<FunctionProtoType> on the method's type.
CXRefQualifierKind clang_CXXMethodDecl_getRefQualifier(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_hasInlineBody(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isLambdaStaticInvoker(CXCXXMethodDecl CXXMD);

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodInClass(CXCXXMethodDecl CXXMD,
                                                                  CXCXXRecordDecl RD,
                                                                  bool MayBeBase);

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase);

bool clang_CXXMethodDecl_isExplicitObjectMemberFunction(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isImplicitObjectMemberFunction(CXCXXMethodDecl CXXMD);

unsigned clang_CXXMethodDecl_size_overridden_methods(CXCXXMethodDecl CXXMD);

// overridden_methods: two-call protocol (method_iterator is forward-only).
// size_overridden_methods gives the exact slot count; no slot is null.
void clang_CXXMethodDecl_getOverriddenMethods(CXCXXMethodDecl CXXMD, CXCXXMethodDecl *Buf);

unsigned clang_CXXMethodDecl_getNumExplicitParams(CXCXXMethodDecl CXXMD);

// CXXCtorInitializer
// A CXXCtorInitializer is interior to its CXXConstructorDecl: borrowed, no dispose.
// Unique reproducible identifier among the objects C's allocator handed out.
int64_t clang_CXXCtorInitializer_getID(CXCXXCtorInitializer CI, CXASTContext C);
bool clang_CXXCtorInitializer_isBaseInitializer(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isMemberInitializer(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isAnyMemberInitializer(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isDelegatingInitializer(CXCXXCtorInitializer CI);

CXFieldDecl clang_CXXCtorInitializer_getMember(CXCXXCtorInitializer CI);

CXType_ clang_CXXCtorInitializer_getBaseClass(CXCXXCtorInitializer CI);

CXExpr clang_CXXCtorInitializer_getInit(CXCXXCtorInitializer CI);

CXSourceLocation_ clang_CXXCtorInitializer_getSourceLocation(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isIndirectMemberInitializer(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isInClassMemberInitializer(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isPackExpansion(CXCXXCtorInitializer CI);

// Invalid location unless the initializer is a pack expansion.
CXSourceLocation_ clang_CXXCtorInitializer_getEllipsisLoc(CXCXXCtorInitializer CI);

// The written base-class type with source-location information. Total: a NULL
// (isNull) TypeLoc for any initializer that is not a base-class initializer.
// Returns an owned box; release it with clang_TypeLoc_dispose.
CXTypeLoc clang_CXXCtorInitializer_getBaseClassLoc(CXCXXCtorInitializer CI);

// Precondition: CI must be a base-class initializer (isBaseInitializer()).
bool clang_CXXCtorInitializer_isBaseVirtual(CXCXXCtorInitializer CI);

// Null unless this is a base-class or delegating initializer.
CXTypeSourceInfo clang_CXXCtorInitializer_getTypeSourceInfo(CXCXXCtorInitializer CI);

// Null unless this is a (possibly indirect) member initializer.
CXFieldDecl clang_CXXCtorInitializer_getAnyMember(CXCXXCtorInitializer CI);

// Null unless this is an indirect member initializer.
CXIndirectFieldDecl clang_CXXCtorInitializer_getIndirectMember(CXCXXCtorInitializer CI);

CXSourceLocation_ clang_CXXCtorInitializer_getMemberLocation(CXCXXCtorInitializer CI);

CXSourceRange_ clang_CXXCtorInitializer_getSourceRange(CXCXXCtorInitializer CI);

bool clang_CXXCtorInitializer_isWritten(CXCXXCtorInitializer CI);

// -1 for an implicit (not source-written) initializer.
int clang_CXXCtorInitializer_getSourceOrder(CXCXXCtorInitializer CI);

CXSourceLocation_ clang_CXXCtorInitializer_getLParenLoc(CXCXXCtorInitializer CI);

CXSourceLocation_ clang_CXXCtorInitializer_getRParenLoc(CXCXXCtorInitializer CI);

// InheritedConstructor

// CXXConstructorDecl
bool clang_CXXConstructorDecl_isExplicit(CXCXXConstructorDecl CD);

// Owned copy of the by-value specifier: clang_ExplicitSpecifier_dispose.
CXExplicitSpecifier clang_CXXConstructorDecl_getExplicitSpecifier(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isDefaultConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isCopyConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isMoveConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isCopyOrMoveConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isDelegatingConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isInheritingConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isSpecializationCopyingObject(CXCXXConstructorDecl CD);

// The two halves of the by-value clang::InheritedConstructor (MARSHALLING.md
// section 7). Total: both are null unless clang_CXXConstructorDecl_isInheritingConstructor.
CXConstructorUsingShadowDecl
clang_CXXConstructorDecl_getInheritedConstructorShadowDecl(CXCXXConstructorDecl CD);

CXCXXConstructorDecl
clang_CXXConstructorDecl_getInheritedConstructorBaseCtor(CXCXXConstructorDecl CD);

unsigned clang_CXXConstructorDecl_getNumCtorInitializers(CXCXXConstructorDecl CD);

// inits: random-access (init_begin is a contiguous CXXCtorInitializer* array).
CXCXXCtorInitializer
clang_CXXConstructorDecl_getCtorInitializer(CXCXXConstructorDecl CD, unsigned i);

CXCXXConstructorDecl clang_CXXConstructorDecl_getTargetConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isConvertingConstructor(CXCXXConstructorDecl CD,
                                                      bool AllowExplicit);

CXCXXConstructorDecl clang_CXXConstructorDecl_getCanonicalDecl(CXCXXConstructorDecl CD);

// CXXDestructorDecl
CXFunctionDecl clang_CXXDestructorDecl_getOperatorDelete(CXCXXDestructorDecl DD);

// Null unless the destructor's operator delete takes a `this` argument.
CXExpr clang_CXXDestructorDecl_getOperatorDeleteThisArg(CXCXXDestructorDecl DD);

CXCXXDestructorDecl clang_CXXDestructorDecl_getCanonicalDecl(CXCXXDestructorDecl DD);

// CXXConversionDecl
CXQualType clang_CXXConversionDecl_getConversionType(CXCXXConversionDecl CD);

bool clang_CXXConversionDecl_isExplicit(CXCXXConversionDecl CD);

// Owned copy of the by-value specifier: clang_ExplicitSpecifier_dispose.
CXExplicitSpecifier clang_CXXConversionDecl_getExplicitSpecifier(CXCXXConversionDecl CD);

bool clang_CXXConversionDecl_isLambdaToBlockPointerConversion(CXCXXConversionDecl CD);

// CXXConversionDecl redeclares getCanonicalDecl with its own return type, so the
// canonical declaration crosses at CXCXXConversionDecl, not at CXFunctionDecl.
CXCXXConversionDecl clang_CXXConversionDecl_getCanonicalDecl(CXCXXConversionDecl CD);

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

// UsingDirectiveDecl
CXNamespaceDecl clang_UsingDirectiveDecl_getNominatedNamespace(CXUsingDirectiveDecl UDD);

// The extent of getQualifierLoc(). NestedNameSpecifierLoc has no handle of its
// own, so it crosses as its two parts (MARSHALLING.md section 7): the qualifier
// through getQualifier, its source range here. Invalid when unqualified.
CXSourceRange_ clang_UsingDirectiveDecl_getQualifierRange(CXUsingDirectiveDecl UDD);

CXNestedNameSpecifier clang_UsingDirectiveDecl_getQualifier(CXUsingDirectiveDecl UDD);

CXNamedDecl
clang_UsingDirectiveDecl_getNominatedNamespaceAsWritten(CXUsingDirectiveDecl UDD);

CXDeclContext clang_UsingDirectiveDecl_getCommonAncestor(CXUsingDirectiveDecl UDD);

CXSourceLocation_ clang_UsingDirectiveDecl_getUsingLoc(CXUsingDirectiveDecl UDD);

CXSourceLocation_
clang_UsingDirectiveDecl_getNamespaceKeyLocation(CXUsingDirectiveDecl UDD);

CXSourceLocation_ clang_UsingDirectiveDecl_getIdentLocation(CXUsingDirectiveDecl UDD);

CXSourceRange_ clang_UsingDirectiveDecl_getSourceRange(CXUsingDirectiveDecl UDD);

// NamespaceAliasDecl
CXNamespaceAliasDecl clang_NamespaceAliasDecl_getCanonicalDecl(CXNamespaceAliasDecl NAD);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above). Invalid
// when the aliased namespace is named without a nested-name-specifier.
CXSourceRange_ clang_NamespaceAliasDecl_getQualifierRange(CXNamespaceAliasDecl NAD);

// Null when the aliased namespace is named without a nested-name-specifier.
CXNestedNameSpecifier clang_NamespaceAliasDecl_getQualifier(CXNamespaceAliasDecl NAD);

CXNamespaceDecl clang_NamespaceAliasDecl_getNamespace(CXNamespaceAliasDecl NAD);

CXSourceLocation_ clang_NamespaceAliasDecl_getAliasLoc(CXNamespaceAliasDecl NAD);

CXSourceLocation_ clang_NamespaceAliasDecl_getNamespaceLoc(CXNamespaceAliasDecl NAD);

CXSourceLocation_ clang_NamespaceAliasDecl_getTargetNameLoc(CXNamespaceAliasDecl NAD);

CXNamedDecl clang_NamespaceAliasDecl_getAliasedNamespace(CXNamespaceAliasDecl NAD);

CXSourceRange_ clang_NamespaceAliasDecl_getSourceRange(CXNamespaceAliasDecl NAD);

// LifetimeExtendedTemporaryDecl
// The VarDecl (or, for a ctor-initializer, the FieldDecl) that extends the
// temporary's lifetime.
CXValueDecl
clang_LifetimeExtendedTemporaryDecl_getExtendingDecl(CXLifetimeExtendedTemporaryDecl D);

CXStorageDuration
clang_LifetimeExtendedTemporaryDecl_getStorageDuration(CXLifetimeExtendedTemporaryDecl D);

// helper: reads the materialized-expression slot through childrenExpr(), which is the
// same storage getTemporaryExpr() reaches with an unchecked cast<Expr>. False only for a
// declaration built by CreateDeserialized whose slot the AST reader has not filled yet.
bool clang_LifetimeExtendedTemporaryDecl_hasTemporaryExpr(
    CXLifetimeExtendedTemporaryDecl D);

// PARTIAL: cast<Expr> on the slot clang_LifetimeExtendedTemporaryDecl_hasTemporaryExpr
// reports, so that must hold.
CXExpr
clang_LifetimeExtendedTemporaryDecl_getTemporaryExpr(CXLifetimeExtendedTemporaryDecl D);

// UNINITIALIZED on the deserialization path (MARSHALLING.md section 13): the EmptyShell
// constructor leaves ManglingNumber without an initializer and only the AST reader fills
// it in. A declaration reached from a parsed AST always carries it; the class exposes no
// flag for the shell state, so this one is documented rather than gated.
unsigned
clang_LifetimeExtendedTemporaryDecl_getManglingNumber(CXLifetimeExtendedTemporaryDecl D);

// PARTIAL: asserts the storage duration is SD_Static and, when MayCreate is false, that a
// value has already been cached. The APValue is owned by this declaration - borrowed,
// never disposed.
CXAPValue
clang_LifetimeExtendedTemporaryDecl_getOrCreateValue(CXLifetimeExtendedTemporaryDecl D,
                                                     bool MayCreate);

// Null until the constant value has been cached. Borrowed, never disposed.
CXAPValue clang_LifetimeExtendedTemporaryDecl_getValue(CXLifetimeExtendedTemporaryDecl D);

// UsingShadowDecl
CXNamedDecl clang_UsingShadowDecl_getTargetDecl(CXUsingShadowDecl USD);

CXUsingShadowDecl clang_UsingShadowDecl_getCanonicalDecl(CXUsingShadowDecl USD);

// The written or instantiated using-declaration that introduced this shadow.
CXBaseUsingDecl clang_UsingShadowDecl_getIntroducer(CXUsingShadowDecl USD);

// Null unless another shadow of the same using-declaration follows this one.
CXUsingShadowDecl clang_UsingShadowDecl_getNextUsingShadowDecl(CXUsingShadowDecl USD);

// BaseUsingDecl
// shadows: two-call protocol (shadow_iterator is forward-only).
unsigned clang_BaseUsingDecl_shadow_size(CXBaseUsingDecl BUD);

void clang_BaseUsingDecl_getShadows(CXBaseUsingDecl BUD, CXUsingShadowDecl *Buf);

// UsingDecl
CXSourceLocation_ clang_UsingDecl_getUsingLoc(CXUsingDecl UD);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above).
CXSourceRange_ clang_UsingDecl_getQualifierRange(CXUsingDecl UD);

CXNestedNameSpecifier clang_UsingDecl_getQualifier(CXUsingDecl UD);

// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_UsingDecl_getNameInfo(CXUsingDecl UD);

bool clang_UsingDecl_isAccessDeclaration(CXUsingDecl UD);

bool clang_UsingDecl_hasTypename(CXUsingDecl UD);

CXSourceRange_ clang_UsingDecl_getSourceRange(CXUsingDecl UD);

CXUsingDecl clang_UsingDecl_getCanonicalDecl(CXUsingDecl UD);

// ConstructorUsingShadowDecl
CXUsingDecl
clang_ConstructorUsingShadowDecl_getIntroducer(CXConstructorUsingShadowDecl CUSD);

CXCXXRecordDecl
clang_ConstructorUsingShadowDecl_getParent(CXConstructorUsingShadowDecl CUSD);

// Null unless the constructor was inherited from an indirect base class.
CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_getNominatedBaseClassShadowDecl(
    CXConstructorUsingShadowDecl CUSD);

// Null unless the constructor was inherited from an indirect base class.
CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_getConstructedBaseClassShadowDecl(
    CXConstructorUsingShadowDecl CUSD);

CXCXXRecordDecl
clang_ConstructorUsingShadowDecl_getNominatedBaseClass(CXConstructorUsingShadowDecl CUSD);

CXCXXRecordDecl
clang_ConstructorUsingShadowDecl_getConstructedBaseClass(CXConstructorUsingShadowDecl CUSD);

bool clang_ConstructorUsingShadowDecl_constructsVirtualBase(
    CXConstructorUsingShadowDecl CUSD);

// UsingEnumDecl
CXSourceLocation_ clang_UsingEnumDecl_getUsingLoc(CXUsingEnumDecl UED);

CXSourceLocation_ clang_UsingEnumDecl_getEnumLoc(CXUsingEnumDecl UED);

// Null when the enumeration is named without a nested-name-specifier.
CXNestedNameSpecifier clang_UsingEnumDecl_getQualifier(CXUsingEnumDecl UED);

// The "qualifier::Name" part of the using-enum-declaration as a TypeLoc.
// PARTIAL: dereferences the written enumeration type, so
// clang_UsingEnumDecl_getEnumType must be non-null.
// Returns an owned box; release it with clang_TypeLoc_dispose.
CXTypeLoc clang_UsingEnumDecl_getEnumTypeLoc(CXUsingEnumDecl UED);

CXTypeSourceInfo clang_UsingEnumDecl_getEnumType(CXUsingEnumDecl UED);

// PARTIAL: cast<EnumDecl> on the tag the written type designates, so the
// declaration must still carry the enumeration type it was built with.
CXEnumDecl clang_UsingEnumDecl_getEnumDecl(CXUsingEnumDecl UED);

CXSourceRange_ clang_UsingEnumDecl_getSourceRange(CXUsingEnumDecl UED);

CXUsingEnumDecl clang_UsingEnumDecl_getCanonicalDecl(CXUsingEnumDecl UED);

// UsingPackDecl
CXNamedDecl clang_UsingPackDecl_getInstantiatedFromUsingDecl(CXUsingPackDecl UPD);

// expansions: random-access (the NamedDecl * array is a trailing object). The
// count is exact and no slot is null.
unsigned clang_UsingPackDecl_getNumExpansions(CXUsingPackDecl UPD);

CXNamedDecl clang_UsingPackDecl_getExpansion(CXUsingPackDecl UPD, unsigned i);

// PARTIAL: forwards through getInstantiatedFromUsingDecl() with no null check.
CXSourceRange_ clang_UsingPackDecl_getSourceRange(CXUsingPackDecl UPD);

CXUsingPackDecl clang_UsingPackDecl_getCanonicalDecl(CXUsingPackDecl UPD);

// UnresolvedUsingValueDecl
CXSourceLocation_
clang_UnresolvedUsingValueDecl_getUsingLoc(CXUnresolvedUsingValueDecl UUVD);

bool clang_UnresolvedUsingValueDecl_isAccessDeclaration(CXUnresolvedUsingValueDecl UUVD);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above).
CXSourceRange_
clang_UnresolvedUsingValueDecl_getQualifierRange(CXUnresolvedUsingValueDecl UUVD);

CXNestedNameSpecifier
clang_UnresolvedUsingValueDecl_getQualifier(CXUnresolvedUsingValueDecl UUVD);

// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_UnresolvedUsingValueDecl_getNameInfo(CXUnresolvedUsingValueDecl UUVD);

bool clang_UnresolvedUsingValueDecl_isPackExpansion(CXUnresolvedUsingValueDecl UUVD);

// Invalid unless isPackExpansion().
CXSourceLocation_
clang_UnresolvedUsingValueDecl_getEllipsisLoc(CXUnresolvedUsingValueDecl UUVD);

CXSourceRange_
clang_UnresolvedUsingValueDecl_getSourceRange(CXUnresolvedUsingValueDecl UUVD);

CXUnresolvedUsingValueDecl
clang_UnresolvedUsingValueDecl_getCanonicalDecl(CXUnresolvedUsingValueDecl UUVD);

// UnresolvedUsingTypenameDecl
CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getUsingLoc(CXUnresolvedUsingTypenameDecl UUTD);

CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getTypenameLoc(CXUnresolvedUsingTypenameDecl UUTD);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above).
CXSourceRange_
clang_UnresolvedUsingTypenameDecl_getQualifierRange(CXUnresolvedUsingTypenameDecl UUTD);

CXNestedNameSpecifier
clang_UnresolvedUsingTypenameDecl_getQualifier(CXUnresolvedUsingTypenameDecl UUTD);

// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_UnresolvedUsingTypenameDecl_getNameInfo(CXUnresolvedUsingTypenameDecl UUTD);

bool clang_UnresolvedUsingTypenameDecl_isPackExpansion(CXUnresolvedUsingTypenameDecl UUTD);

// Invalid unless isPackExpansion().
CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getEllipsisLoc(CXUnresolvedUsingTypenameDecl UUTD);

CXUnresolvedUsingTypenameDecl
clang_UnresolvedUsingTypenameDecl_getCanonicalDecl(CXUnresolvedUsingTypenameDecl UUTD);

// StaticAssertDecl
CXStaticAssertDecl clang_StaticAssertDecl_Create(CXASTContext C, CXDeclContext DC,
                                                 CXSourceLocation_ StaticAssertLoc,
                                                 CXExpr AssertExpr, CXExpr Message,
                                                 CXSourceLocation_ RParenLoc,
                                                 bool Failed);

CXStaticAssertDecl clang_StaticAssertDecl_CreateDeserialized(CXASTContext C, unsigned ID);

CXExpr clang_StaticAssertDecl_getAssertExpr(CXStaticAssertDecl SAD);

// Null for a message-less static_assert.
CXExpr clang_StaticAssertDecl_getMessage(CXStaticAssertDecl SAD);

bool clang_StaticAssertDecl_isFailed(CXStaticAssertDecl SAD);

CXSourceLocation_ clang_StaticAssertDecl_getRParenLoc(CXStaticAssertDecl SAD);

CXSourceRange_ clang_StaticAssertDecl_getSourceRange(CXStaticAssertDecl SAD);

// BindingDecl
// Null while the decomposition initializer is being parsed, and for a
// type-dependent initializer.
CXExpr clang_BindingDecl_getBinding(CXBindingDecl BD);

CXValueDecl clang_BindingDecl_getDecomposedDecl(CXBindingDecl BD);

// Null unless the binding is a user-defined (tuple-like) binding whose value is
// held by an implicit variable.
CXVarDecl clang_BindingDecl_getHoldingVar(CXBindingDecl BD);

void clang_BindingDecl_setBinding(CXBindingDecl BD, CXQualType DeclaredType,
                                  CXExpr Binding);

void clang_BindingDecl_setDecomposedDecl(CXBindingDecl BD, CXValueDecl Decomposed);

// DecompositionDecl
// bindings: random-access (the BindingDecl* array is a trailing object).
unsigned clang_DecompositionDecl_getNumBindings(CXDecompositionDecl DD);

CXBindingDecl clang_DecompositionDecl_getBinding(CXDecompositionDecl DD, unsigned i);

// MSPropertyDecl
bool clang_MSPropertyDecl_hasGetter(CXMSPropertyDecl MPD);

// Null unless clang_MSPropertyDecl_hasGetter.
CXIdentifierInfo clang_MSPropertyDecl_getGetterId(CXMSPropertyDecl MPD);

bool clang_MSPropertyDecl_hasSetter(CXMSPropertyDecl MPD);

// Null unless clang_MSPropertyDecl_hasSetter.
CXIdentifierInfo clang_MSPropertyDecl_getSetterId(CXMSPropertyDecl MPD);

LLVM_CLANG_C_EXTERN_C_END

#endif
