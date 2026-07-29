#ifndef LLVM_CLANG_C_EXTRA_CXDECLCXX_H
#define LLVM_CLANG_C_EXTRA_CXDECLCXX_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXLambda.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXOperatorKinds.h"
#include "clang-ex/Basic/CXLangOptions.h"

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

// PARTIAL: writes the class's definition data, whose accessor asserts a complete
// definition.
void clang_CXXRecordDecl_setInitMethod(CXCXXRecordDecl CXXRD, bool Val);

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

// PARTIAL: the flag lives in the record's DefinitionData, which data() reaches behind an
// assert, so clang_CXXRecordDecl_hasDefinition must hold. The flag only ever goes from
// false to true - the class exposes no way to clear it.
void clang_CXXRecordDecl_setIsParsingBaseSpecifiers(CXCXXRecordDecl CXXRD);

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

// friends: two-call protocol (friend_iterator is forward-only). The count is exact
// and no slot is null. clang::FriendDecl has no CX handle of its own, so the entries
// cross at their CXDecl base. PARTIAL: both calls reach the record's definition data,
// so clang_CXXRecordDecl_hasDefinition must hold.
unsigned clang_CXXRecordDecl_getNumFriends(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getFriends(CXCXXRecordDecl CXXRD, CXDecl *Buf);

// pushFriendDecl

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

// PARTIAL: asserts isLambda(). TS is stored, not adopted; NULL clears the written
// type of the closure type's call operator.
void clang_CXXRecordDecl_setLambdaTypeInfo(CXCXXRecordDecl CXXRD, CXTypeSourceInfo TS);

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

// PARTIAL: clang llvm_unreachable()s unless the class is a class template
// specialization or carries a MemberSpecializationInfo
// (clang_CXXRecordDecl_getMemberSpecializationInfo). On the latter path the info
// object encodes TSK - 1 in two bits, so
// CXTemplateSpecializationKind_TSK_Undeclared additionally trips a clang assert.
void clang_CXXRecordDecl_setTemplateSpecializationKind(CXCXXRecordDecl CXXRD,
                                                       CXTemplateSpecializationKind TSK);

// Null when this class is not a member class of a class template.
CXCXXRecordDecl clang_CXXRecordDecl_getInstantiatedFromMemberClass(CXCXXRecordDecl CXXRD);

// PARTIAL: clang asserts the template/instantiation slot is still empty (both
// clang_CXXRecordDecl_getDescribedClassTemplate and
// clang_CXXRecordDecl_getMemberSpecializationInfo NULL), that the receiver is not a
// class template partial specialization, and - through the MemberSpecializationInfo
// it builds - that TSK is not CXTemplateSpecializationKind_TSK_Undeclared. The call
// is one-way: clang exposes no way to clear the slot again.
void clang_CXXRecordDecl_setInstantiationOfMemberClass(CXCXXRecordDecl CXXRD,
                                                       CXCXXRecordDecl RD,
                                                       CXTemplateSpecializationKind TSK);

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

// getCaptureFields: two-call protocol (the C++ result is a DenseMap, not a contiguous
// array). Both calls re-run the same walk, so they agree; the count is exact, no slot is
// null, and the two buffers are filled in lockstep - VarBuf[i] is the variable captured
// into FieldBuf[i]. The map's iteration order is unspecified. Init-captures contribute no
// entry and the `this` capture is reported through *ThisCapture (NULL when `this` is not
// captured), so the count is not clang_CXXRecordDecl_capture_size. PARTIAL: both reach
// getLambdaData(), whose assert(DD && DD->IsLambda) is the only guard.
unsigned clang_CXXRecordDecl_getNumCaptureFields(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getCaptureFields(CXCXXRecordDecl CXXRD, CXValueDecl *VarBuf,
                                          CXFieldDecl *FieldBuf, CXFieldDecl *ThisCapture);

// Null unless this class is an instantiation of a member class of a class
// template specialization.
CXMemberSpecializationInfo
clang_CXXRecordDecl_getMemberSpecializationInfo(CXCXXRecordDecl CXXRD);

// Null unless this record is the pattern that describes a class template.
CXClassTemplateDecl clang_CXXRecordDecl_getDescribedClassTemplate(CXCXXRecordDecl CXXRD);

// Template is stored, not adopted; NULL clears the association.
void clang_CXXRecordDecl_setDescribedClassTemplate(CXCXXRecordDecl CXXRD,
                                                   CXClassTemplateDecl Template);

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

// lookupDependentName: two-call protocol (the C++ result is a std::vector). Both calls
// re-run the same lookup with an accept-all filter, so they agree; the count is exact and
// no slot is null. clang calls the lookup imprecise -- it does not follow strict semantic
// rules and is meant for indexing, not for language semantics. PARTIAL: when the class
// declares no ordinary member of that name the lookup walks the base classes, which reads
// the definition data, so clang_CXXRecordDecl_hasDefinition must hold.
unsigned clang_CXXRecordDecl_getNumDependentNameLookupResults(CXCXXRecordDecl CXXRD,
                                                              CXDeclarationName Name);

void clang_CXXRecordDecl_lookupDependentName(CXCXXRecordDecl CXXRD, CXDeclarationName Name,
                                             CXNamedDecl *Buf);

// Static; PARTIAL: asserts DeclAccess != AS_none.
CXAccessSpecifier clang_CXXRecordDecl_MergeAccess(CXAccessSpecifier PathAccess,
                                                  CXAccessSpecifier DeclAccess);

// PARTIAL: asserts isLambda().
unsigned clang_CXXRecordDecl_getDeviceLambdaManglingNumber(CXCXXRecordDecl CXXRD);

// Total: CXLambdaDependencyKind_Unknown when the class is not a lambda.
CXLambdaDependencyKind clang_CXXRecordDecl_getLambdaDependencyKind(CXCXXRecordDecl CXXRD);

// conversions: the conversion functions declared directly in this class
// (conversion_begin/conversion_end), random-access. The count is exact and no slot
// is null. PARTIAL: both reach the definition data, so the class must have a
// definition.
unsigned clang_CXXRecordDecl_getNumConversions(CXCXXRecordDecl CXXRD);

CXNamedDecl clang_CXXRecordDecl_getConversion(CXCXXRecordDecl CXXRD, unsigned i);

// Definition-data mutators. PARTIAL: every one of them writes through data(), whose
// accessor asserts a complete definition, so clang_CXXRecordDecl_hasDefinition must hold.
// The five setImplicit*IsDeleted setters additionally assert that the class either already
// carries the flag or still needs overload resolution for that operation
// (clang_CXXRecordDecl_needsOverloadResolutionFor*); only the second half is observable
// from here.
void clang_CXXRecordDecl_setImplicitCopyConstructorIsDeleted(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_setImplicitMoveConstructorIsDeleted(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_setImplicitDestructorIsDeleted(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_setImplicitCopyAssignmentIsDeleted(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_setImplicitMoveAssignmentIsDeleted(CXCXXRecordDecl CXXRD);

// PARTIAL: clang walks the conversion set and llvm_unreachable()s when Old is not in it, so
// Old must be one of the clang_CXXRecordDecl_getConversion entries.
void clang_CXXRecordDecl_removeConversion(CXCXXRecordDecl CXXRD, CXNamedDecl Old);

// The flag only ever goes from false to true; the class exposes no way to clear it.
void clang_CXXRecordDecl_markEmpty(CXCXXRecordDecl CXXRD);

// Sets the trivial-for-call bit for the copy constructor, the move constructor and the
// destructor at once, as clang's own setter does.
void clang_CXXRecordDecl_setHasTrivialSpecialMemberForCall(CXCXXRecordDecl CXXRD);

// PARTIAL: clang asserts MD is neither implicit nor user-provided, i.e. that it is an
// explicitly defaulted or deleted member.
void clang_CXXRecordDecl_finishedDefaultedOrDeletedMember(CXCXXRecordDecl CXXRD,
                                                          CXCXXMethodDecl MD);

// Folds MD's trivial-for-call bit into the class's flags. Only a copy constructor, a move
// constructor or a destructor contributes; any other method leaves the flags unchanged.
void clang_CXXRecordDecl_setTrivialForCallFlags(CXCXXRecordDecl CXXRD, CXCXXMethodDecl MD);

// The five fields of the by-value clang::CXXRecordDecl::LambdaNumbering (MARSHALLING.md
// section 7). PARTIAL: asserts isLambda(). ContextDecl may be NULL, and
// DeviceManglingNumber is only recorded in the ASTContext when it is non-zero.
void clang_CXXRecordDecl_setLambdaNumbering(CXCXXRecordDecl CXXRD, CXDecl ContextDecl,
                                            unsigned IndexInContext,
                                            unsigned ManglingNumber,
                                            unsigned DeviceManglingNumber,
                                            bool HasKnownInternalLinkage);

// PARTIAL: asserts isLambda().
void clang_CXXRecordDecl_setLambdaIsGeneric(CXCXXRecordDecl CXXRD, bool IsGeneric);

// The flag only ever goes from false to true; the class exposes no way to clear it.
void clang_CXXRecordDecl_markAbstract(CXCXXRecordDecl CXXRD);

// The Microsoft C++ ABI member-pointer inheritance model this class would be given.
// PARTIAL: reads the record's definition data, so clang_CXXRecordDecl_hasDefinition
// must hold.
CXMSInheritanceModel clang_CXXRecordDecl_calculateInheritanceModel(CXCXXRecordDecl CXXRD);

// The Microsoft C++ ABI member-pointer inheritance model recorded on this class. PARTIAL:
// clang dereferences the class's MSInheritanceAttr unconditionally, so
// clang_Decl_hasAttrOfKind(D, CXAttrKind_MSInheritance) must hold; only the Microsoft C++
// ABI ever attaches that attribute. clang_CXXRecordDecl_calculateInheritanceModel computes
// the model a class would be given and needs neither.
CXMSInheritanceModel clang_CXXRecordDecl_getMSInheritanceModel(CXCXXRecordDecl CXXRD);

// When vtordisps are emitted for this record used as a virtual base: the nearest
// __declspec(vtordisp) on the class or on a class it was instantiated from, falling back
// to the translation unit's vtordisp language option. Total, but a vtordisp is a Microsoft
// C++ ABI construct and the fallback is a language option no other ABI acts on, so the
// Julia wrapper gates it on the ABI.
CXMSVtorDispMode clang_CXXRecordDecl_getMSVtorDispMode(CXCXXRecordDecl CXXRD);

// getMSInheritanceModel
// getMSVtorDispMode
// True when a null data member pointer to this class may use a zero field offset
// under the Microsoft C++ ABI. PARTIAL: runs calculateInheritanceModel, so a
// definition is required (as above) AND the target must use the Microsoft C++ ABI
// -- the inheritance model lives behind MSInheritanceAttr, which no other ABI
// populates, so this segfaults on Itanium. The Julia wrapper asserts both.
bool clang_CXXRecordDecl_nullFieldOffsetIsZero(CXCXXRecordDecl CXXRD);

CXCXXRecordDecl clang_CXXRecordDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// ExplicitSpecifier
CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES);

CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES);

bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES);

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

void clang_CXXDeductionGuideDecl_setDeductionCandidateKind(CXCXXDeductionGuideDecl DGD,
                                                           CXDeductionCandidate K);

// ES is read, not adopted (the guide keeps its own copy) and must be non-NULL. Ctor is
// the constructor an implicit guide was generated from and may be NULL.
CXCXXDeductionGuideDecl clang_CXXDeductionGuideDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc, CXExplicitSpecifier ES,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo,
    CXSourceLocation_ EndLocation, CXCXXConstructorDecl Ctor, CXDeductionCandidate Kind);

CXCXXDeductionGuideDecl clang_CXXDeductionGuideDecl_CreateDeserialized(CXASTContext C,
                                                                       unsigned ID);

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


// Static; true for the allocation and deallocation operators, which are implicitly
// static members when declared in a class.
bool clang_CXXMethodDecl_isStaticOverloadedOperator(CXOverloadedOperatorKind OOK);

bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD);

bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD);

CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(CXCXXMethodDecl CXXMD,
                                                           CXExpr Base, bool IsAppleKext);


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

// PARTIAL: clang asserts the initializer is still implicit (!isWritten(), which also
// makes a second call illegal) and that Pos is non-negative. The call is one-way.
void clang_CXXCtorInitializer_setSourceOrder(CXCXXCtorInitializer CI, int Pos);

CXSourceLocation_ clang_CXXCtorInitializer_getLParenLoc(CXCXXCtorInitializer CI);

CXSourceLocation_ clang_CXXCtorInitializer_getRParenLoc(CXCXXCtorInitializer CI);

// InheritedConstructor

// CXXConstructorDecl
bool clang_CXXConstructorDecl_isExplicit(CXCXXConstructorDecl CD);

// Owned copy of the by-value specifier: clang_ExplicitSpecifier_dispose.
CXExplicitSpecifier clang_CXXConstructorDecl_getExplicitSpecifier(CXCXXConstructorDecl CD);

// ES is read, not adopted. PARTIAL: when ES carries an expression clang asserts the
// declaration was allocated with trailing explicit-specifier storage, which nothing in
// this API can observe; a specifier whose clang_ExplicitSpecifier_getExpr is NULL always
// satisfies it.
void clang_CXXConstructorDecl_setExplicitSpecifier(CXCXXConstructorDecl CD,
                                                   CXExplicitSpecifier ES);

bool clang_CXXConstructorDecl_isDefaultConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isCopyConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isMoveConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isCopyOrMoveConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isDelegatingConstructor(CXCXXConstructorDecl CD);

bool clang_CXXConstructorDecl_isInheritingConstructor(CXCXXConstructorDecl CD);

// Sets the bit alone: the inherited-constructor trailing object is allocated at Create
// time, so setting this true on a constructor built without it leaves
// clang_CXXConstructorDecl_getInheritedConstructorBaseCtor reading unallocated storage.
void clang_CXXConstructorDecl_setInheritingConstructor(CXCXXConstructorDecl CD, bool IsIC);

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

// PARTIAL: clang asserts NameInfo names a constructor
// (CXDeclarationName_CXXConstructorName). ES is read, not adopted, and must be non-NULL.
// InheritedShadow/InheritedBaseCtor are the two halves of the by-value
// clang::InheritedConstructor (MARSHALLING.md section 7); both NULL builds the default
// (non-inheriting) one.
CXCXXConstructorDecl clang_CXXConstructorDecl_Create(
    CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo,
    CXExplicitSpecifier ES, bool UsesFPIntrin, bool isInline, bool isImplicitlyDeclared,
    CXConstexprSpecKind ConstexprKind, CXConstructorUsingShadowDecl InheritedShadow,
    CXCXXConstructorDecl InheritedBaseCtor, CXExpr TrailingRequiresClause);

// AllocKind is the trailing-object bitmask CXXConstructorDecl serialises with: 0
// allocates neither the inherited-constructor nor the explicit-specifier tail.
CXCXXConstructorDecl clang_CXXConstructorDecl_CreateDeserialized(CXASTContext C,
                                                                 unsigned ID,
                                                                 uint64_t AllocKind);

// CXXDestructorDecl
CXFunctionDecl clang_CXXDestructorDecl_getOperatorDelete(CXCXXDestructorDecl DD);

// Null unless the destructor's operator delete takes a `this` argument.
CXExpr clang_CXXDestructorDecl_getOperatorDeleteThisArg(CXCXXDestructorDecl DD);

CXCXXDestructorDecl clang_CXXDestructorDecl_getCanonicalDecl(CXCXXDestructorDecl DD);

// PARTIAL: clang asserts NameInfo names a destructor
// (CXDeclarationName_CXXDestructorName).
CXCXXDestructorDecl clang_CXXDestructorDecl_Create(
    CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo, bool UsesFPIntrin,
    bool isInline, bool isImplicitlyDeclared, CXConstexprSpecKind ConstexprKind,
    CXExpr TrailingRequiresClause);

CXCXXDestructorDecl clang_CXXDestructorDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// Records the deallocation function this destructor is paired with. Total: clang stores it
// on the first declaration and keeps whatever is already there, so the call does nothing
// unless OD is non-NULL and no operator delete has been recorded yet. ThisArg may be NULL.
void clang_CXXDestructorDecl_setOperatorDelete(CXCXXDestructorDecl DD, CXFunctionDecl OD,
                                               CXExpr ThisArg);

// CXXConversionDecl
CXQualType clang_CXXConversionDecl_getConversionType(CXCXXConversionDecl CD);

bool clang_CXXConversionDecl_isExplicit(CXCXXConversionDecl CD);

// Owned copy of the by-value specifier: clang_ExplicitSpecifier_dispose.
CXExplicitSpecifier clang_CXXConversionDecl_getExplicitSpecifier(CXCXXConversionDecl CD);

// ES is read, not adopted: the conversion function stores its own copy.
void clang_CXXConversionDecl_setExplicitSpecifier(CXCXXConversionDecl CD,
                                                  CXExplicitSpecifier ES);

bool clang_CXXConversionDecl_isLambdaToBlockPointerConversion(CXCXXConversionDecl CD);

// CXXConversionDecl redeclares getCanonicalDecl with its own return type, so the
// canonical declaration crosses at CXCXXConversionDecl, not at CXFunctionDecl.
CXCXXConversionDecl clang_CXXConversionDecl_getCanonicalDecl(CXCXXConversionDecl CD);

// PARTIAL: clang asserts NameInfo names a conversion function
// (CXDeclarationName_CXXConversionFunctionName). ES is read, not adopted (the conversion
// function stores its own copy) and must be non-NULL.
CXCXXConversionDecl clang_CXXConversionDecl_Create(
    CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
    CXDeclarationNameInfo NameInfo, CXQualType T, CXTypeSourceInfo TInfo, bool UsesFPIntrin,
    bool isInline, CXExplicitSpecifier ES, CXConstexprSpecKind ConstexprKind,
    CXSourceLocation_ EndLocation, CXExpr TrailingRequiresClause);

CXCXXConversionDecl clang_CXXConversionDecl_CreateDeserialized(CXASTContext C, unsigned ID);

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

CXUsingDirectiveDecl clang_UsingDirectiveDecl_CreateDeserialized(CXASTContext C,
                                                                 unsigned ID);

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

CXNamespaceAliasDecl clang_NamespaceAliasDecl_CreateDeserialized(CXASTContext C,
                                                                 unsigned ID);

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

// PARTIAL: clang allocates the declaration in EDec's ASTContext and DeclContext and reads
// Temp's expression location, so both must be non-NULL.
CXLifetimeExtendedTemporaryDecl
clang_LifetimeExtendedTemporaryDecl_Create(CXExpr Temp, CXValueDecl EDec,
                                           unsigned Mangling);

CXLifetimeExtendedTemporaryDecl
clang_LifetimeExtendedTemporaryDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// UsingShadowDecl
CXNamedDecl clang_UsingShadowDecl_getTargetDecl(CXUsingShadowDecl USD);

// PARTIAL: clang asserts ND is non-null, and rebuilds the shadow's identifier namespace
// from ND's, so the target must be the declaration the shadow really names.
void clang_UsingShadowDecl_setTargetDecl(CXUsingShadowDecl USD, CXNamedDecl ND);

CXUsingShadowDecl clang_UsingShadowDecl_getCanonicalDecl(CXUsingShadowDecl USD);

// The written or instantiated using-declaration that introduced this shadow.
CXBaseUsingDecl clang_UsingShadowDecl_getIntroducer(CXUsingShadowDecl USD);

// Null unless another shadow of the same using-declaration follows this one.
CXUsingShadowDecl clang_UsingShadowDecl_getNextUsingShadowDecl(CXUsingShadowDecl USD);

// PARTIAL: Introducer is stored unchecked and Target, when non-null, must not itself
// be a UsingShadowDecl (clang asserts on that).
CXUsingShadowDecl clang_UsingShadowDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ Loc,
                                               CXDeclarationName Name,
                                               CXBaseUsingDecl Introducer,
                                               CXNamedDecl Target);

CXUsingShadowDecl clang_UsingShadowDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// BaseUsingDecl
// shadows: two-call protocol (shadow_iterator is forward-only).
unsigned clang_BaseUsingDecl_shadow_size(CXBaseUsingDecl BUD);

void clang_BaseUsingDecl_getShadows(CXBaseUsingDecl BUD, CXUsingShadowDecl *Buf);

// PARTIAL: clang asserts S was introduced by BUD (clang_UsingShadowDecl_getIntroducer) and
// that S is not yet in BUD's shadow list.
void clang_BaseUsingDecl_addShadowDecl(CXBaseUsingDecl BUD, CXUsingShadowDecl S);

// PARTIAL: clang asserts S was introduced by BUD and that S is currently in BUD's shadow
// list; removal leaves S re-addable.
void clang_BaseUsingDecl_removeShadowDecl(CXBaseUsingDecl BUD, CXUsingShadowDecl S);

// UsingDecl
CXSourceLocation_ clang_UsingDecl_getUsingLoc(CXUsingDecl UD);

void clang_UsingDecl_setUsingLoc(CXUsingDecl UD, CXSourceLocation_ L);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above).
CXSourceRange_ clang_UsingDecl_getQualifierRange(CXUsingDecl UD);

CXNestedNameSpecifier clang_UsingDecl_getQualifier(CXUsingDecl UD);

// Returns an owned box; release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_UsingDecl_getNameInfo(CXUsingDecl UD);

bool clang_UsingDecl_isAccessDeclaration(CXUsingDecl UD);

bool clang_UsingDecl_hasTypename(CXUsingDecl UD);

void clang_UsingDecl_setTypename(CXUsingDecl UD, bool TN);

CXSourceRange_ clang_UsingDecl_getSourceRange(CXUsingDecl UD);

CXUsingDecl clang_UsingDecl_getCanonicalDecl(CXUsingDecl UD);

CXUsingDecl clang_UsingDecl_CreateDeserialized(CXASTContext C, unsigned ID);

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

// PARTIAL: the constructor dereferences both Using (for its name) and Target (for
// its underlying declaration), so neither may be null.
CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_Create(CXASTContext C, CXDeclContext DC,
                                        CXSourceLocation_ Loc, CXUsingDecl Using,
                                        CXNamedDecl Target, bool IsVirtual);

CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// UsingEnumDecl
CXSourceLocation_ clang_UsingEnumDecl_getUsingLoc(CXUsingEnumDecl UED);

void clang_UsingEnumDecl_setUsingLoc(CXUsingEnumDecl UED, CXSourceLocation_ L);

CXSourceLocation_ clang_UsingEnumDecl_getEnumLoc(CXUsingEnumDecl UED);

void clang_UsingEnumDecl_setEnumLoc(CXUsingEnumDecl UED, CXSourceLocation_ L);

// Null when the enumeration is named without a nested-name-specifier.
CXNestedNameSpecifier clang_UsingEnumDecl_getQualifier(CXUsingEnumDecl UED);

// The extent of getQualifierLoc() (MARSHALLING.md section 7, as above). PARTIAL: the
// qualifier is read out of the written enumeration type, so clang_UsingEnumDecl_getEnumType
// must be non-null. Invalid when the enumeration is named unqualified.
CXSourceRange_ clang_UsingEnumDecl_getQualifierRange(CXUsingEnumDecl UED);

// The "qualifier::Name" part of the using-enum-declaration as a TypeLoc.
// PARTIAL: dereferences the written enumeration type, so
// clang_UsingEnumDecl_getEnumType must be non-null.
// Returns an owned box; release it with clang_TypeLoc_dispose.
CXTypeLoc clang_UsingEnumDecl_getEnumTypeLoc(CXUsingEnumDecl UED);

CXTypeSourceInfo clang_UsingEnumDecl_getEnumType(CXUsingEnumDecl UED);

void clang_UsingEnumDecl_setEnumType(CXUsingEnumDecl UED, CXTypeSourceInfo TSI);

// PARTIAL: cast<EnumDecl> on the tag the written type designates, so the
// declaration must still carry the enumeration type it was built with.
CXEnumDecl clang_UsingEnumDecl_getEnumDecl(CXUsingEnumDecl UED);

CXSourceRange_ clang_UsingEnumDecl_getSourceRange(CXUsingEnumDecl UED);

CXUsingEnumDecl clang_UsingEnumDecl_getCanonicalDecl(CXUsingEnumDecl UED);

// PARTIAL: EnumType is dereferenced for the enumeration's name, so it must be
// non-null and must designate a tag type.
CXUsingEnumDecl clang_UsingEnumDecl_Create(CXASTContext C, CXDeclContext DC,
                                           CXSourceLocation_ UsingL,
                                           CXSourceLocation_ EnumL, CXSourceLocation_ NameL,
                                           CXTypeSourceInfo EnumType);

CXUsingEnumDecl clang_UsingEnumDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// UsingPackDecl
CXNamedDecl clang_UsingPackDecl_getInstantiatedFromUsingDecl(CXUsingPackDecl UPD);

// expansions: random-access (the NamedDecl * array is a trailing object). The
// count is exact and no slot is null.
unsigned clang_UsingPackDecl_getNumExpansions(CXUsingPackDecl UPD);

CXNamedDecl clang_UsingPackDecl_getExpansion(CXUsingPackDecl UPD, unsigned i);

// PARTIAL: forwards through getInstantiatedFromUsingDecl() with no null check.
CXSourceRange_ clang_UsingPackDecl_getSourceRange(CXUsingPackDecl UPD);

CXUsingPackDecl clang_UsingPackDecl_getCanonicalDecl(CXUsingPackDecl UPD);

// UsingDecls is a (buffer, count) pair of CXNamedDecl handles; clang copies it into
// the declaration's trailing-object array.
CXUsingPackDecl clang_UsingPackDecl_Create(CXASTContext C, CXDeclContext DC,
                                           CXNamedDecl InstantiatedFrom,
                                           CXNamedDecl *UsingDecls, unsigned NumUsingDecls);

CXUsingPackDecl clang_UsingPackDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                       unsigned NumExpansions);

// UnresolvedUsingValueDecl
CXSourceLocation_
clang_UnresolvedUsingValueDecl_getUsingLoc(CXUnresolvedUsingValueDecl UUVD);

void clang_UnresolvedUsingValueDecl_setUsingLoc(CXUnresolvedUsingValueDecl UUVD,
                                                CXSourceLocation_ L);

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

CXUnresolvedUsingValueDecl clang_UnresolvedUsingValueDecl_CreateDeserialized(CXASTContext C,
                                                                             unsigned ID);

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

CXUnresolvedUsingTypenameDecl
clang_UnresolvedUsingTypenameDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// UnresolvedUsingIfExistsDecl
// The whole class: the marker declaration Sema builds when a using-declaration marked
// __attribute__((using_if_exists)) fails to resolve. It carries no payload of its own,
// so the two factories are its entire surface.
CXUnresolvedUsingIfExistsDecl
clang_UnresolvedUsingIfExistsDecl_Create(CXASTContext C, CXDeclContext DC,
                                         CXSourceLocation_ Loc, CXDeclarationName Name);

CXUnresolvedUsingIfExistsDecl
clang_UnresolvedUsingIfExistsDecl_CreateDeserialized(CXASTContext C, unsigned ID);

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

CXBindingDecl clang_BindingDecl_Create(CXASTContext C, CXDeclContext DC,
                                       CXSourceLocation_ IdLoc, CXIdentifierInfo Id);

CXBindingDecl clang_BindingDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// DecompositionDecl
// bindings: random-access (the BindingDecl* array is a trailing object).
unsigned clang_DecompositionDecl_getNumBindings(CXDecompositionDecl DD);

CXBindingDecl clang_DecompositionDecl_getBinding(CXDecompositionDecl DD, unsigned i);

// Bindings is a (buffer, count) pair of CXBindingDecl handles; clang copies it into the
// declaration's trailing-object array.
CXDecompositionDecl
clang_DecompositionDecl_Create(CXASTContext C, CXDeclContext DC, CXSourceLocation_ StartLoc,
                               CXSourceLocation_ LSquareLoc, CXQualType T,
                               CXTypeSourceInfo TInfo, CXStorageClass S,
                               CXBindingDecl *Bindings, unsigned NumBindings);

CXDecompositionDecl clang_DecompositionDecl_CreateDeserialized(CXASTContext C, unsigned ID,
                                                               unsigned NumBindings);

// MSPropertyDecl
bool clang_MSPropertyDecl_hasGetter(CXMSPropertyDecl MPD);

// Null unless clang_MSPropertyDecl_hasGetter.
CXIdentifierInfo clang_MSPropertyDecl_getGetterId(CXMSPropertyDecl MPD);

bool clang_MSPropertyDecl_hasSetter(CXMSPropertyDecl MPD);

// Null unless clang_MSPropertyDecl_hasSetter.
CXIdentifierInfo clang_MSPropertyDecl_getSetterId(CXMSPropertyDecl MPD);

// Getter and Setter may each be null: that is how a write-only or read-only
// property is spelled, and it is what hasGetter/hasSetter report on.
CXMSPropertyDecl clang_MSPropertyDecl_Create(CXASTContext C, CXDeclContext DC,
                                             CXSourceLocation_ L, CXDeclarationName N,
                                             CXQualType T, CXTypeSourceInfo TInfo,
                                             CXSourceLocation_ StartL,
                                             CXIdentifierInfo Getter,
                                             CXIdentifierInfo Setter);

CXMSPropertyDecl clang_MSPropertyDecl_CreateDeserialized(CXASTContext C, unsigned ID);

// MSGuidDecl
// printName

// helper: the fields of the by-value clang::MSGuidDecl::Parts, exposed one at a time
// (MARSHALLING.md section 7). Total.
uint32_t clang_MSGuidDecl_getPart1(CXMSGuidDecl GD);

uint16_t clang_MSGuidDecl_getPart2(CXMSGuidDecl GD);

uint16_t clang_MSGuidDecl_getPart3(CXMSGuidDecl GD);

// The last eight UUID bytes memcpy'd into one integer, so the value is byte-order
// dependent: compare it against another value read the same way, not against a literal.
uint64_t clang_MSGuidDecl_getPart4And5AsUint64(CXMSGuidDecl GD);

// The UUID as an APValue, computed on demand and cached inside the declaration - borrowed,
// never disposed. Total: the result is an absent APValue when the declaration's type is
// not of the expected _GUID shape.
CXAPValue clang_MSGuidDecl_getAsAPValue(CXMSGuidDecl GD);

// Profile

// CXXRecordDecl (final overriders)
// The final overrider of every virtual member function in the hierarchy CXXRD tops, as a
// two-call protocol over five buffers filled in lockstep. The result's element type -
// clang::UniqueVirtualMethod, keyed by the overridden method and the subobject it occurs
// in - has no pointer form, so it crosses as parallel component arrays (MARSHALLING.md
// section 6 for the count+fill shape, section 11 for the per-field arrays). Row i reads:
// OverriddenBuf[i], found in subobject OverriddenSubobjectBuf[i], is finally overridden by
// OverriderBuf[i], which lives in subobject OverriderSubobjectBuf[i] of the virtual base
// InVirtualSubobjectBuf[i] - NULL when the overrider is not inside a virtual base
// subobject. Subobject 0 is the virtual base subobject of its type; higher numbers are the
// non-virtual ones. The count is exact and no method slot is null. Both calls rebuild the
// map from scratch and clang keys it in a MapVector, so the rows come back in insertion
// order and the two walks agree. A class that neither declares nor inherits a virtual
// member function yields no rows. PARTIAL: the walk reads the class's definition data, so
// clang_CXXRecordDecl_hasDefinition must hold.
unsigned clang_CXXRecordDecl_getNumFinalOverriders(CXCXXRecordDecl CXXRD);

void clang_CXXRecordDecl_getFinalOverriders(CXCXXRecordDecl CXXRD,
                                            CXCXXMethodDecl *OverriddenBuf,
                                            unsigned *OverriddenSubobjectBuf,
                                            CXCXXMethodDecl *OverriderBuf,
                                            unsigned *OverriderSubobjectBuf,
                                            CXCXXRecordDecl *InVirtualSubobjectBuf);

// The getQualifierLoc family. Where the getQualifierRange accessors above flatten a
// qualifier to its outer extent, these hand back the whole NestedNameSpecifierLoc as an
// owned box (MARSHALLING.md section 10), which is the only way to reach the per-component
// locations, the prefix chain and the qualifier's TypeLoc. Every result is OWNED - release
// it with clang_NestedNameSpecifierLoc_dispose - and a name written without a
// nested-name-specifier yields an empty box rather than NULL.

// UsingDirectiveDecl (cont.)
CXNestedNameSpecifierLoc clang_UsingDirectiveDecl_getQualifierLoc(CXUsingDirectiveDecl UDD);

// NamespaceAliasDecl (cont.)
CXNestedNameSpecifierLoc clang_NamespaceAliasDecl_getQualifierLoc(CXNamespaceAliasDecl NAD);

// UsingDecl (cont.)
CXNestedNameSpecifierLoc clang_UsingDecl_getQualifierLoc(CXUsingDecl UD);

// UsingEnumDecl (cont.)
// PARTIAL: the qualifier is read out of the written enumeration type, so
// clang_UsingEnumDecl_getEnumType must be non-null. An enumeration named without a
// nested-name-specifier yields an empty box.
CXNestedNameSpecifierLoc clang_UsingEnumDecl_getQualifierLoc(CXUsingEnumDecl UED);

// UnresolvedUsingValueDecl (cont.)
CXNestedNameSpecifierLoc
clang_UnresolvedUsingValueDecl_getQualifierLoc(CXUnresolvedUsingValueDecl UUVD);

// UnresolvedUsingTypenameDecl (cont.)
CXNestedNameSpecifierLoc
clang_UnresolvedUsingTypenameDecl_getQualifierLoc(CXUnresolvedUsingTypenameDecl UUTD);

// The Create family that takes a nested-name-specifier. QualifierLoc is a BORROWED
// CXNestedNameSpecifierLoc box - clang copies the value out of it and the box stays the
// caller's to dispose - and the only way to obtain one is a getQualifierLoc accessor, whose
// empty box spells a name written without a nested-name-specifier. None of these register
// the new declaration with DC; they only allocate it in the context's arena.

// UsingDirectiveDecl (cont.)
// Nominated is the namespace the directive names, CommonAncestor the innermost context
// enclosing both the directive and that namespace.
CXUsingDirectiveDecl clang_UsingDirectiveDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ UsingLoc,
    CXSourceLocation_ NamespaceLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ IdentLoc, CXNamedDecl Nominated, CXDeclContext CommonAncestor);

// NamespaceAliasDecl (cont.)
// Alias is the identifier the alias introduces, Namespace the namespace it stands for.
CXNamespaceAliasDecl clang_NamespaceAliasDecl_Create(CXASTContext C, CXDeclContext DC,
                                                     CXSourceLocation_ NamespaceLoc,
                                                     CXSourceLocation_ AliasLoc,
                                                     CXIdentifierInfo Alias,
                                                     CXNestedNameSpecifierLoc QualifierLoc,
                                                     CXSourceLocation_ IdentLoc,
                                                     CXNamedDecl Namespace);

// UsingDecl (cont.)
// NameInfo is read, not adopted; release the box with clang_DeclarationNameInfo_dispose.
CXUsingDecl clang_UsingDecl_Create(CXASTContext C, CXDeclContext DC,
                                   CXSourceLocation_ UsingL,
                                   CXNestedNameSpecifierLoc QualifierLoc,
                                   CXDeclarationNameInfo NameInfo, bool HasTypenameKeyword);

// UnresolvedUsingValueDecl (cont.)
// A valid EllipsisLoc is what makes the declaration a pack expansion; pass an invalid one
// for the ordinary case. NameInfo is read, not adopted.
CXUnresolvedUsingValueDecl clang_UnresolvedUsingValueDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ UsingLoc,
    CXNestedNameSpecifierLoc QualifierLoc, CXDeclarationNameInfo NameInfo,
    CXSourceLocation_ EllipsisLoc);

// UnresolvedUsingTypenameDecl (cont.)
// PARTIAL: the constructor stores TargetName reduced to its IdentifierInfo, so a
// DeclarationName that is not a plain identifier produces an unnamed declaration. A valid
// EllipsisLoc is what makes the declaration a pack expansion.
CXUnresolvedUsingTypenameDecl clang_UnresolvedUsingTypenameDecl_Create(
    CXASTContext C, CXDeclContext DC, CXSourceLocation_ UsingLoc,
    CXSourceLocation_ TypenameLoc, CXNestedNameSpecifierLoc QualifierLoc,
    CXSourceLocation_ TargetNameLoc, CXDeclarationName TargetName,
    CXSourceLocation_ EllipsisLoc);

LLVM_CLANG_C_EXTERN_C_END

#endif
