#include "clang-ex/AST/CXDeclCXX.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/CXXInheritance.h"
#include "clang/AST/TypeLoc.h"
#include "llvm/ADT/SmallVector.h"
#include <memory>

// CXXRecordDecl (lambda / conversion / template-instantiation tail)
CXCXXMethodDecl clang_CXXRecordDecl_getLambdaCallOperator(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaCallOperator();
}

CXFunctionTemplateDecl
clang_CXXRecordDecl_getDependentLambdaCallOperator(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDependentLambdaCallOperator();
}

CXCXXMethodDecl clang_CXXRecordDecl_getLambdaStaticInvoker(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaStaticInvoker();
}

CXLambdaCaptureDefault clang_CXXRecordDecl_getLambdaCaptureDefault(CXCXXRecordDecl CXXRD) {
  return static_cast<CXLambdaCaptureDefault>(
      static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaCaptureDefault());
}

unsigned clang_CXXRecordDecl_getLambdaManglingNumber(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaManglingNumber();
}

unsigned clang_CXXRecordDecl_getLambdaIndexInContext(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaIndexInContext();
}

CXDecl clang_CXXRecordDecl_getLambdaContextDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaContextDecl();
}

CXTypeSourceInfo clang_CXXRecordDecl_getLambdaTypeInfo(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaTypeInfo();
}

CXCXXDestructorDecl clang_CXXRecordDecl_getDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDestructor();
}

unsigned clang_CXXRecordDecl_getNumVisibleConversionFunctions(CXCXXRecordDecl CXXRD) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned N = 0;
  for (auto *C : D->getVisibleConversionFunctions()) {
    (void)C;
    ++N;
  }
  return N;
}

void clang_CXXRecordDecl_getVisibleConversionFunctions(CXCXXRecordDecl CXXRD,
                                                       CXNamedDecl *Buf) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned I = 0;
  for (auto *C : D->getVisibleConversionFunctions())
    Buf[I++] = C;
}

CXCXXRecordDecl clang_CXXRecordDecl_getTemplateInstantiationPattern(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getTemplateInstantiationPattern();
}

CXTemplateSpecializationKind
clang_CXXRecordDecl_getTemplateSpecializationKind(CXCXXRecordDecl CXXRD) {
  return static_cast<CXTemplateSpecializationKind>(
      static_cast<clang::CXXRecordDecl *>(CXXRD)->getTemplateSpecializationKind());
}

CXCXXRecordDecl clang_CXXRecordDecl_getInstantiatedFromMemberClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getInstantiatedFromMemberClass();
}

CXFunctionDecl clang_CXXRecordDecl_isLocalClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isLocalClass();
}

unsigned clang_CXXRecordDecl_getODRHash(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getODRHash();
}

bool clang_CXXRecordDecl_implicitCopyConstructorHasConstParam(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->implicitCopyConstructorHasConstParam();
}

bool clang_CXXRecordDecl_implicitCopyAssignmentHasConstParam(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->implicitCopyAssignmentHasConstParam();
}

bool clang_CXXRecordDecl_lambdaIsDefaultConstructibleAndAssignable(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)
      ->lambdaIsDefaultConstructibleAndAssignable();
}

unsigned clang_CXXRecordDecl_getNumLambdaExplicitTemplateParameters(CXCXXRecordDecl CXXRD) {
  auto Params =
      static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaExplicitTemplateParameters();
  return static_cast<unsigned>(Params.size());
}

CXNamedDecl clang_CXXRecordDecl_getLambdaExplicitTemplateParameter(CXCXXRecordDecl CXXRD,
                                                                   unsigned i) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)
      ->getLambdaExplicitTemplateParameters()[i];
}

unsigned clang_CXXRecordDecl_capture_size(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->capture_size();
}

CXLambdaCapture clang_CXXRecordDecl_getCapture(CXCXXRecordDecl CXXRD, unsigned I) {
  return const_cast<clang::LambdaCapture *>(
      static_cast<clang::CXXRecordDecl *>(CXXRD)->getCapture(I));
}

CXMemberSpecializationInfo
clang_CXXRecordDecl_getMemberSpecializationInfo(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getMemberSpecializationInfo();
}

CXClassTemplateDecl clang_CXXRecordDecl_getDescribedClassTemplate(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDescribedClassTemplate();
}

bool clang_CXXRecordDecl_isCurrentInstantiation(CXCXXRecordDecl CXXRD,
                                                CXDeclContext CurContext) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isCurrentInstantiation(
      static_cast<clang::DeclContext *>(CurContext));
}

bool clang_CXXRecordDecl_isProvablyNotDerivedFrom(CXCXXRecordDecl CXXRD,
                                                  CXCXXRecordDecl Base) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isProvablyNotDerivedFrom(
      static_cast<clang::CXXRecordDecl *>(Base));
}

unsigned clang_CXXRecordDecl_getNumIndirectPrimaryBases(CXCXXRecordDecl CXXRD) {
  clang::CXXIndirectPrimaryBaseSet Bases;
  static_cast<clang::CXXRecordDecl *>(CXXRD)->getIndirectPrimaryBases(Bases);
  return static_cast<unsigned>(Bases.size());
}

void clang_CXXRecordDecl_getIndirectPrimaryBases(CXCXXRecordDecl CXXRD,
                                                 CXCXXRecordDecl *Buf) {
  clang::CXXIndirectPrimaryBaseSet Bases;
  static_cast<clang::CXXRecordDecl *>(CXXRD)->getIndirectPrimaryBases(Bases);
  unsigned I = 0;
  for (const clang::CXXRecordDecl *RD : Bases)
    Buf[I++] = const_cast<clang::CXXRecordDecl *>(RD);
}

bool clang_CXXRecordDecl_hasMemberName(CXCXXRecordDecl CXXRD, CXDeclarationName N) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasMemberName(
      clang::DeclarationName::getFromOpaquePtr(N));
}

CXAccessSpecifier clang_CXXRecordDecl_MergeAccess(CXAccessSpecifier PathAccess,
                                                  CXAccessSpecifier DeclAccess) {
  return static_cast<CXAccessSpecifier>(
      clang::CXXRecordDecl::MergeAccess(static_cast<clang::AccessSpecifier>(PathAccess),
                                        static_cast<clang::AccessSpecifier>(DeclAccess)));
}

unsigned clang_CXXRecordDecl_getDeviceLambdaManglingNumber(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDeviceLambdaManglingNumber();
}

CXLambdaDependencyKind clang_CXXRecordDecl_getLambdaDependencyKind(CXCXXRecordDecl CXXRD) {
  return static_cast<CXLambdaDependencyKind>(
      static_cast<clang::CXXRecordDecl *>(CXXRD)->getLambdaDependencyKind());
}

// AccessSpecDecl
CXSourceLocation_ clang_AccessSpecDecl_getAccessSpecifierLoc(CXAccessSpecDecl AS) {
  return static_cast<clang::AccessSpecDecl *>(AS)->getAccessSpecifierLoc().getPtrEncoding();
}

void clang_AccessSpecDecl_setAccessSpecifierLoc(CXAccessSpecDecl AS,
                                                CXSourceLocation_ ASLoc) {
  static_cast<clang::AccessSpecDecl *>(AS)->setAccessSpecifierLoc(
      clang::SourceLocation::getFromPtrEncoding(ASLoc));
}

CXSourceLocation_ clang_AccessSpecDecl_getColonLoc(CXAccessSpecDecl AS) {
  return static_cast<clang::AccessSpecDecl *>(AS)->getColonLoc().getPtrEncoding();
}

void clang_AccessSpecDecl_setColonLoc(CXAccessSpecDecl AS, CXSourceLocation_ CLoc) {
  static_cast<clang::AccessSpecDecl *>(AS)->setColonLoc(
      clang::SourceLocation::getFromPtrEncoding(CLoc));
}

CXSourceRange_ clang_AccessSpecDecl_getSourceRange(CXAccessSpecDecl AS) {
  auto rng = static_cast<clang::AccessSpecDecl *>(AS)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXAccessSpecDecl clang_AccessSpecDecl_Create(CXASTContext C, CXAccessSpecifier AS,
                                             CXDeclContext DC, CXSourceLocation_ ASLoc,
                                             CXSourceLocation_ ColonLoc) {
  return clang::AccessSpecDecl::Create(*static_cast<clang::ASTContext *>(C),
                                       static_cast<clang::AccessSpecifier>(AS),
                                       static_cast<clang::DeclContext *>(DC),
                                       clang::SourceLocation::getFromPtrEncoding(ASLoc),
                                       clang::SourceLocation::getFromPtrEncoding(ColonLoc));
}

CXAccessSpecDecl clang_AccessSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::AccessSpecDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                   ID);
}

// CXXBaseSpecifier
CXSourceRange_ clang_CXXBaseSpecifier_getSourceRange(CXCXXBaseSpecifier CXXBS) {
  auto rng = static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_CXXBaseSpecifier_getBeginLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXBaseSpecifier_getEndLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getEndLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXBaseSpecifier_getBaseTypeLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getBaseTypeLoc().getPtrEncoding();
}

bool clang_CXXBaseSpecifier_isVirtual(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isVirtual();
}

bool clang_CXXBaseSpecifier_isBaseOfClass(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isBaseOfClass();
}

bool clang_CXXBaseSpecifier_isPackExpansion(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->isPackExpansion();
}

bool clang_CXXBaseSpecifier_getInheritConstructors(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getInheritConstructors();
}

void clang_CXXBaseSpecifier_setInheritConstructors(CXCXXBaseSpecifier CXXBS, bool Inherit) {
  static_cast<clang::CXXBaseSpecifier *>(CXXBS)->setInheritConstructors(Inherit);
}

CXSourceLocation_ clang_CXXBaseSpecifier_getEllipsisLoc(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getEllipsisLoc().getPtrEncoding();
}

CXAccessSpecifier clang_CXXBaseSpecifier_getAccessSpecifier(CXCXXBaseSpecifier CXXBS) {
  return static_cast<CXAccessSpecifier>(
      static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getAccessSpecifier());
}

CXAccessSpecifier
clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXCXXBaseSpecifier CXXBS) {
  return static_cast<CXAccessSpecifier>(
      static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getAccessSpecifierAsWritten());
}

CXQualType clang_CXXBaseSpecifier_getType(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getType().getAsOpaquePtr();
}

CXTypeSourceInfo clang_CXXBaseSpecifier_getTypeSourceInfo(CXCXXBaseSpecifier CXXBS) {
  return static_cast<clang::CXXBaseSpecifier *>(CXXBS)->getTypeSourceInfo();
}

// CXXRecordDecl
CXCXXRecordDecl clang_CXXRecordDecl_getCanonicalDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getCanonicalDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getPreviousDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getPreviousDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getMostRecentDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getMostRecentNonInjectedDecl();
}

CXCXXRecordDecl clang_CXXRecordDecl_getDefinition(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getDefinition();
}

bool clang_CXXRecordDecl_hasDefinition(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasDefinition();
}

CXCXXRecordDecl clang_CXXRecordDecl_Create(CXASTContext C, CXTagTypeKind TK,
                                           CXDeclContext DC, CXSourceLocation_ StartLoc,
                                           CXSourceLocation_ IdLoc, CXIdentifierInfo Id,
                                           CXCXXRecordDecl PrevDecl,
                                           bool DelayTypeCreation) {
  return clang::CXXRecordDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::TagTypeKind>(TK),
      static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      static_cast<clang::IdentifierInfo *>(Id),
      static_cast<clang::CXXRecordDecl *>(PrevDecl), DelayTypeCreation);
}

CXCXXRecordDecl clang_CXXRecordDecl_CreateLambda(CXASTContext C, CXDeclContext DC,
                                                 CXTypeSourceInfo Info,
                                                 CXSourceLocation_ Loc,
                                                 CXLambdaDependencyKind DependencyKind,
                                                 bool IsGeneric,
                                                 CXLambdaCaptureDefault CaptureDefault) {
  return clang::CXXRecordDecl::CreateLambda(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      static_cast<clang::TypeSourceInfo *>(Info),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<unsigned>(DependencyKind), IsGeneric,
      static_cast<clang::LambdaCaptureDefault>(CaptureDefault));
}

bool clang_CXXRecordDecl_isDynamicClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isDynamicClass();
}

bool clang_CXXRecordDecl_isLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isLambda();
}

bool clang_CXXRecordDecl_isGenericLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isGenericLambda();
}

CXTemplateParameterList
clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)
      ->getGenericLambdaTemplateParameterList();
}

bool clang_CXXRecordDecl_isAggregate(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isAggregate();
}

bool clang_CXXRecordDecl_isPOD(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isPOD();
}

bool clang_CXXRecordDecl_isCLike(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isCLike();
}

bool clang_CXXRecordDecl_isEmpty(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isEmpty();
}

bool clang_CXXRecordDecl_allowConstDefaultInit(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->allowConstDefaultInit();
}

bool clang_CXXRecordDecl_defaultedCopyConstructorIsDeleted(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->defaultedCopyConstructorIsDeleted();
}

bool clang_CXXRecordDecl_defaultedDefaultConstructorIsConstexpr(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->defaultedDefaultConstructorIsConstexpr();
}

bool clang_CXXRecordDecl_defaultedDestructorIsConstexpr(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->defaultedDestructorIsConstexpr();
}

bool clang_CXXRecordDecl_defaultedDestructorIsDeleted(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->defaultedDestructorIsDeleted();
}

bool clang_CXXRecordDecl_defaultedMoveConstructorIsDeleted(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->defaultedMoveConstructorIsDeleted();
}

bool clang_CXXRecordDecl_hasAnyDependentBases(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasAnyDependentBases();
}

bool clang_CXXRecordDecl_hasConstexprDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasConstexprDefaultConstructor();
}

bool clang_CXXRecordDecl_hasConstexprDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasConstexprDestructor();
}

bool clang_CXXRecordDecl_hasConstexprNonCopyMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasConstexprNonCopyMoveConstructor();
}

bool clang_CXXRecordDecl_hasCopyAssignmentWithConstParam(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasCopyAssignmentWithConstParam();
}

bool clang_CXXRecordDecl_hasCopyConstructorWithConstParam(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasCopyConstructorWithConstParam();
}

bool clang_CXXRecordDecl_hasDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasDefaultConstructor();
}

bool clang_CXXRecordDecl_hasDirectFields(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasDirectFields();
}

bool clang_CXXRecordDecl_hasFriends(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasFriends();
}

bool clang_CXXRecordDecl_hasInClassInitializer(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasInClassInitializer();
}

bool clang_CXXRecordDecl_hasInheritedAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasInheritedAssignment();
}

bool clang_CXXRecordDecl_hasInheritedConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasInheritedConstructor();
}

bool clang_CXXRecordDecl_hasInitMethod(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasInitMethod();
}

bool clang_CXXRecordDecl_hasIrrelevantDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasIrrelevantDestructor();
}

bool clang_CXXRecordDecl_hasKnownLambdaInternalLinkage(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasKnownLambdaInternalLinkage();
}

bool clang_CXXRecordDecl_hasMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasMoveAssignment();
}

bool clang_CXXRecordDecl_hasMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasMoveConstructor();
}

bool clang_CXXRecordDecl_hasMutableFields(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasMutableFields();
}

bool clang_CXXRecordDecl_hasNonLiteralTypeFieldsOrBases(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonLiteralTypeFieldsOrBases();
}

bool clang_CXXRecordDecl_hasNonTrivialCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialCopyAssignment();
}

bool clang_CXXRecordDecl_hasNonTrivialCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialCopyConstructor();
}

bool clang_CXXRecordDecl_hasNonTrivialCopyConstructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialCopyConstructorForCall();
}

bool clang_CXXRecordDecl_hasNonTrivialDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialDefaultConstructor();
}

bool clang_CXXRecordDecl_hasNonTrivialDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialDestructor();
}

bool clang_CXXRecordDecl_hasNonTrivialDestructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialDestructorForCall();
}

bool clang_CXXRecordDecl_hasNonTrivialMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialMoveAssignment();
}

bool clang_CXXRecordDecl_hasNonTrivialMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialMoveConstructor();
}

bool clang_CXXRecordDecl_hasNonTrivialMoveConstructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasNonTrivialMoveConstructorForCall();
}

bool clang_CXXRecordDecl_hasPrivateFields(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasPrivateFields();
}

bool clang_CXXRecordDecl_hasProtectedFields(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasProtectedFields();
}

bool clang_CXXRecordDecl_hasSimpleCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasSimpleCopyAssignment();
}

bool clang_CXXRecordDecl_hasSimpleCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasSimpleCopyConstructor();
}

bool clang_CXXRecordDecl_hasSimpleDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasSimpleDestructor();
}

bool clang_CXXRecordDecl_hasSimpleMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasSimpleMoveAssignment();
}

bool clang_CXXRecordDecl_hasSimpleMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasSimpleMoveConstructor();
}

bool clang_CXXRecordDecl_hasTrivialCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialCopyAssignment();
}

bool clang_CXXRecordDecl_hasTrivialCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialCopyConstructor();
}

bool clang_CXXRecordDecl_hasTrivialCopyConstructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialCopyConstructorForCall();
}

bool clang_CXXRecordDecl_hasTrivialDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialDefaultConstructor();
}

bool clang_CXXRecordDecl_hasTrivialDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialDestructor();
}

bool clang_CXXRecordDecl_hasTrivialDestructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialDestructorForCall();
}

bool clang_CXXRecordDecl_hasTrivialMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialMoveAssignment();
}

bool clang_CXXRecordDecl_hasTrivialMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialMoveConstructor();
}

bool clang_CXXRecordDecl_hasTrivialMoveConstructorForCall(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasTrivialMoveConstructorForCall();
}

bool clang_CXXRecordDecl_hasUninitializedReferenceMember(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUninitializedReferenceMember();
}

bool clang_CXXRecordDecl_hasUserDeclaredConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredConstructor();
}

bool clang_CXXRecordDecl_hasUserDeclaredCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredCopyAssignment();
}

bool clang_CXXRecordDecl_hasUserDeclaredCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredCopyConstructor();
}

bool clang_CXXRecordDecl_hasUserDeclaredDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredDestructor();
}

bool clang_CXXRecordDecl_hasUserDeclaredMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredMoveAssignment();
}

bool clang_CXXRecordDecl_hasUserDeclaredMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredMoveConstructor();
}

bool clang_CXXRecordDecl_hasUserDeclaredMoveOperation(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserDeclaredMoveOperation();
}

bool clang_CXXRecordDecl_hasUserProvidedDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasUserProvidedDefaultConstructor();
}

bool clang_CXXRecordDecl_hasVariantMembers(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->hasVariantMembers();
}

bool clang_CXXRecordDecl_isAbstract(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isAbstract();
}

bool clang_CXXRecordDecl_isAnyDestructorNoReturn(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isAnyDestructorNoReturn();
}

bool clang_CXXRecordDecl_isCXX11StandardLayout(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isCXX11StandardLayout();
}

bool clang_CXXRecordDecl_isCapturelessLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isCapturelessLambda();
}

bool clang_CXXRecordDecl_isDependentLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isDependentLambda();
}

bool clang_CXXRecordDecl_isDerivedFrom(CXCXXRecordDecl CXXRD, CXCXXRecordDecl Base) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isDerivedFrom(
      static_cast<clang::CXXRecordDecl *>(Base));
}

bool clang_CXXRecordDecl_isEffectivelyFinal(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isEffectivelyFinal();
}

bool clang_CXXRecordDecl_isInterfaceLike(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isInterfaceLike();
}

bool clang_CXXRecordDecl_isLiteral(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isLiteral();
}

bool clang_CXXRecordDecl_isNeverDependentLambda(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isNeverDependentLambda();
}

bool clang_CXXRecordDecl_isParsingBaseSpecifiers(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isParsingBaseSpecifiers();
}

bool clang_CXXRecordDecl_isPolymorphic(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isPolymorphic();
}

bool clang_CXXRecordDecl_isStandardLayout(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isStandardLayout();
}

bool clang_CXXRecordDecl_isStructural(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isStructural();
}

bool clang_CXXRecordDecl_isTrivial(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isTrivial();
}

bool clang_CXXRecordDecl_isTriviallyCopyConstructible(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isTriviallyCopyConstructible();
}

bool clang_CXXRecordDecl_isTriviallyCopyable(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isTriviallyCopyable();
}

bool clang_CXXRecordDecl_isVirtuallyDerivedFrom(CXCXXRecordDecl CXXRD,
                                                CXCXXRecordDecl Base) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->isVirtuallyDerivedFrom(
      static_cast<clang::CXXRecordDecl *>(Base));
}

bool clang_CXXRecordDecl_mayBeAbstract(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->mayBeAbstract();
}

bool clang_CXXRecordDecl_mayBeDynamicClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->mayBeDynamicClass();
}

bool clang_CXXRecordDecl_mayBeNonDynamicClass(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->mayBeNonDynamicClass();
}

bool clang_CXXRecordDecl_needsImplicitCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitCopyAssignment();
}

bool clang_CXXRecordDecl_needsImplicitCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitCopyConstructor();
}

bool clang_CXXRecordDecl_needsImplicitDefaultConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitDefaultConstructor();
}

bool clang_CXXRecordDecl_needsImplicitDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitDestructor();
}

bool clang_CXXRecordDecl_needsImplicitMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitMoveAssignment();
}

bool clang_CXXRecordDecl_needsImplicitMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsImplicitMoveConstructor();
}

bool clang_CXXRecordDecl_needsOverloadResolutionForCopyAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsOverloadResolutionForCopyAssignment();
}

bool clang_CXXRecordDecl_needsOverloadResolutionForCopyConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsOverloadResolutionForCopyConstructor();
}

bool clang_CXXRecordDecl_needsOverloadResolutionForDestructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsOverloadResolutionForDestructor();
}

bool clang_CXXRecordDecl_needsOverloadResolutionForMoveAssignment(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsOverloadResolutionForMoveAssignment();
}

bool clang_CXXRecordDecl_needsOverloadResolutionForMoveConstructor(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->needsOverloadResolutionForMoveConstructor();
}

unsigned clang_CXXRecordDecl_getNumBases(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getNumBases();
}

CXCXXBaseSpecifier clang_CXXRecordDecl_getBase(CXCXXRecordDecl CXXRD, unsigned i) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->bases_begin() + i;
}

unsigned clang_CXXRecordDecl_getNumVBases(CXCXXRecordDecl CXXRD) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->getNumVBases();
}

CXCXXBaseSpecifier clang_CXXRecordDecl_getVBase(CXCXXRecordDecl CXXRD, unsigned i) {
  return static_cast<clang::CXXRecordDecl *>(CXXRD)->vbases_begin() + i;
}

unsigned clang_CXXRecordDecl_getNumMethods(CXCXXRecordDecl CXXRD) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned N = 0;
  for (auto *M : D->methods()) {
    (void)M;
    ++N;
  }
  return N;
}

void clang_CXXRecordDecl_getMethods(CXCXXRecordDecl CXXRD, CXCXXMethodDecl *Buf) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned I = 0;
  for (auto *M : D->methods())
    Buf[I++] = M;
}

unsigned clang_CXXRecordDecl_getNumCtors(CXCXXRecordDecl CXXRD) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned N = 0;
  for (auto *C : D->ctors()) {
    (void)C;
    ++N;
  }
  return N;
}

void clang_CXXRecordDecl_getCtors(CXCXXRecordDecl CXXRD, CXCXXConstructorDecl *Buf) {
  auto *D = static_cast<clang::CXXRecordDecl *>(CXXRD);
  unsigned I = 0;
  for (auto *C : D->ctors())
    Buf[I++] = C;
}

// ExplicitSpecifier
CXExplicitSpecKind clang_ExplicitSpecifier_getKind(CXExplicitSpecifier ES) {
  return static_cast<CXExplicitSpecKind>(
      static_cast<clang::ExplicitSpecifier *>(ES)->getKind());
}

CXExpr clang_ExplicitSpecifier_getExpr(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->getExpr();
}

bool clang_ExplicitSpecifier_isSpecified(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isSpecified();
}

// isEquivalent
bool clang_ExplicitSpecifier_isEquivalent(CXExplicitSpecifier ES,
                                          CXExplicitSpecifier Other) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isEquivalent(
      *static_cast<clang::ExplicitSpecifier *>(Other));
}

bool clang_ExplicitSpecifier_isExplicit(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isExplicit();
}

bool clang_ExplicitSpecifier_isInvalid(CXExplicitSpecifier ES) {
  return static_cast<clang::ExplicitSpecifier *>(ES)->isInvalid();
}

void clang_ExplicitSpecifier_setKind(CXExplicitSpecifier ES, CXExplicitSpecKind Kind) {
  static_cast<clang::ExplicitSpecifier *>(ES)->setKind(
      static_cast<clang::ExplicitSpecKind>(Kind));
}

void clang_ExplicitSpecifier_setExpr(CXExplicitSpecifier ES, CXExpr E) {
  static_cast<clang::ExplicitSpecifier *>(ES)->setExpr(static_cast<clang::Expr *>(E));
}

// getFromDecl
// Invalid
CXExplicitSpecifier clang_ExplicitSpecifier_getFromDecl(CXFunctionDecl FD) {
  auto ES = clang::ExplicitSpecifier::getFromDecl(static_cast<clang::FunctionDecl *>(FD));
  return std::make_unique<clang::ExplicitSpecifier>(ES).release();
}

CXExplicitSpecifier clang_ExplicitSpecifier_Invalid(void) {
  auto ES = clang::ExplicitSpecifier::Invalid();
  return std::make_unique<clang::ExplicitSpecifier>(ES).release();
}

void clang_ExplicitSpecifier_dispose(CXExplicitSpecifier ES) {
  delete static_cast<clang::ExplicitSpecifier *>(ES);
}

// CXXDeductionGuideDecl
bool clang_CXXDeductionGuideDecl_isExplicit(CXCXXDeductionGuideDecl DGD) {
  return static_cast<clang::CXXDeductionGuideDecl *>(DGD)->isExplicit();
}

CXExplicitSpecifier
clang_CXXDeductionGuideDecl_getExplicitSpecifier(CXCXXDeductionGuideDecl DGD) {
  auto ES = static_cast<clang::CXXDeductionGuideDecl *>(DGD)->getExplicitSpecifier();
  return std::make_unique<clang::ExplicitSpecifier>(ES).release();
}

CXCXXConstructorDecl
clang_CXXDeductionGuideDecl_getCorrespondingConstructor(CXCXXDeductionGuideDecl DGD) {
  return static_cast<clang::CXXDeductionGuideDecl *>(DGD)->getCorrespondingConstructor();
}

CXTemplateDecl
clang_CXXDeductionGuideDecl_getDeducedTemplate(CXCXXDeductionGuideDecl DGD) {
  return static_cast<clang::CXXDeductionGuideDecl *>(DGD)->getDeducedTemplate();
}

CXDeductionCandidate
clang_CXXDeductionGuideDecl_getDeductionCandidateKind(CXCXXDeductionGuideDecl DGD) {
  return static_cast<CXDeductionCandidate>(
      static_cast<clang::CXXDeductionGuideDecl *>(DGD)->getDeductionCandidateKind());
}

// RequiresExprBodyDecl
CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_Create(CXASTContext C, CXDeclContext DC,
                                                         CXSourceLocation_ StartLoc) {
  return clang::RequiresExprBodyDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StartLoc));
}

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_CreateDeserialized(CXASTContext C,
                                                                     unsigned ID) {
  return clang::RequiresExprBodyDecl::CreateDeserialized(
      *static_cast<clang::ASTContext *>(C), ID);
}

// RequiresExprBodyDecl Cast
CXDeclContext clang_RequiresExprBodyDecl_castToDeclContext(CXRequiresExprBodyDecl REBD) {
  return clang::RequiresExprBodyDecl::castToDeclContext(
      static_cast<clang::RequiresExprBodyDecl *>(REBD));
}

CXRequiresExprBodyDecl clang_RequiresExprBodyDecl_castFromDeclContext(CXDeclContext DC) {
  return clang::RequiresExprBodyDecl::castFromDeclContext(
      static_cast<clang::DeclContext *>(DC));
}

// CXXMethodDecl
CXCXXMethodDecl
clang_CXXMethodDecl_Create(CXASTContext C, CXCXXRecordDecl RD, CXSourceLocation_ StartLoc,
                           CXDeclarationNameInfo NameInfo, CXQualType T,
                           CXTypeSourceInfo TInfo, CXStorageClass SC, bool UsesFPIntrin,
                           bool isInline, CXConstexprSpecKind ConstexprKind,
                           CXSourceLocation_ EndLocation, CXExpr TrailingRequiresClause) {
  return clang::CXXMethodDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::CXXRecordDecl *>(RD),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      *static_cast<clang::DeclarationNameInfo *>(NameInfo),
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::TypeSourceInfo *>(TInfo),
      static_cast<clang::StorageClass>(SC), UsesFPIntrin, isInline,
      static_cast<clang::ConstexprSpecKind>(ConstexprKind),
      clang::SourceLocation::getFromPtrEncoding(EndLocation),
      static_cast<clang::Expr *>(TrailingRequiresClause));
}

CXCXXMethodDecl clang_CXXMethodDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::CXXMethodDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C), ID);
}

bool clang_CXXMethodDecl_isStatic(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isStatic();
}

bool clang_CXXMethodDecl_isInstance(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isInstance();
}

// isStaticOverloadedOperator

bool clang_CXXMethodDecl_isStaticOverloadedOperator(CXOverloadedOperatorKind OOK) {
  return clang::CXXMethodDecl::isStaticOverloadedOperator(
      static_cast<clang::OverloadedOperatorKind>(OOK));
}

bool clang_CXXMethodDecl_isConst(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isConst();
}

bool clang_CXXMethodDecl_isVolatile(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isVolatile();
}

bool clang_CXXMethodDecl_isVirtual(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isVirtual();
}

CXCXXMethodDecl clang_CXXMethodDecl_getDevirtualizedMethod(CXCXXMethodDecl CXXMD,
                                                           CXExpr Base, bool IsAppleKext) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getDevirtualizedMethod(
      static_cast<clang::Expr *>(Base), IsAppleKext);
}

// isUsualDeallocationFunction

bool clang_CXXMethodDecl_isUsualDeallocationFunction(CXCXXMethodDecl CXXMD) {
  llvm::SmallVector<const clang::FunctionDecl *, 4> PreventedBy;
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isUsualDeallocationFunction(
      PreventedBy);
}

bool clang_CXXMethodDecl_isCopyAssignmentOperator(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isCopyAssignmentOperator();
}

bool clang_CXXMethodDecl_isMoveAssignmentOperator(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isMoveAssignmentOperator();
}

CXCXXMethodDecl clang_CXXMethodDecl_getCanonicalDecl(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCanonicalDecl();
}

CXCXXMethodDecl clang_CXXMethodDecl_getMostRecentDecl(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getMostRecentDecl();
}

void clang_CXXMethodDecl_addOverriddenMethod(CXCXXMethodDecl CXXMD, CXCXXMethodDecl MD) {
  static_cast<clang::CXXMethodDecl *>(CXXMD)->addOverriddenMethod(
      static_cast<clang::CXXMethodDecl *>(MD));
}

CXCXXRecordDecl clang_CXXMethodDecl_getParent(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getParent();
}

CXQualType clang_CXXMethodDecl_getThisType(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getThisType().getAsOpaquePtr();
}

CXQualType
clang_CXXMethodDecl_getFunctionObjectParameterReferenceType(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)
      ->getFunctionObjectParameterReferenceType()
      .getAsOpaquePtr();
}

CXQualType clang_CXXMethodDecl_getFunctionObjectParameterType(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)
      ->getFunctionObjectParameterType()
      .getAsOpaquePtr();
}

// getMethodQualifiers
// getRefQualifier
unsigned clang_CXXMethodDecl_getMethodQualifiers(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)
      ->getMethodQualifiers()
      .getAsOpaqueValue();
}

CXRefQualifierKind clang_CXXMethodDecl_getRefQualifier(CXCXXMethodDecl CXXMD) {
  return static_cast<CXRefQualifierKind>(
      static_cast<clang::CXXMethodDecl *>(CXXMD)->getRefQualifier());
}

bool clang_CXXMethodDecl_hasInlineBody(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->hasInlineBody();
}

bool clang_CXXMethodDecl_isLambdaStaticInvoker(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isLambdaStaticInvoker();
}

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodInClass(CXCXXMethodDecl CXXMD,
                                                                  CXCXXRecordDecl RD,
                                                                  bool MayBeBase) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCorrespondingMethodInClass(
      static_cast<clang::CXXRecordDecl *>(RD), MayBeBase);
}

CXCXXRecordDecl clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(
    CXCXXMethodDecl CXXMD, CXCXXRecordDecl RD, bool MayBeBase) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getCorrespondingMethodDeclaredInClass(
      static_cast<clang::CXXRecordDecl *>(RD), MayBeBase);
}

bool clang_CXXMethodDecl_isExplicitObjectMemberFunction(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isExplicitObjectMemberFunction();
}

bool clang_CXXMethodDecl_isImplicitObjectMemberFunction(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->isImplicitObjectMemberFunction();
}

unsigned clang_CXXMethodDecl_size_overridden_methods(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->size_overridden_methods();
}

void clang_CXXMethodDecl_getOverriddenMethods(CXCXXMethodDecl CXXMD, CXCXXMethodDecl *Buf) {
  auto *D = static_cast<clang::CXXMethodDecl *>(CXXMD);
  unsigned I = 0;
  for (auto It = D->begin_overridden_methods(), E = D->end_overridden_methods(); It != E;
       ++It)
    Buf[I++] = const_cast<clang::CXXMethodDecl *>(*It);
}

unsigned clang_CXXMethodDecl_getNumExplicitParams(CXCXXMethodDecl CXXMD) {
  return static_cast<clang::CXXMethodDecl *>(CXXMD)->getNumExplicitParams();
}

// CXXCtorInitializer
// A CXXCtorInitializer is interior to its CXXConstructorDecl: borrowed, no dispose.
int64_t clang_CXXCtorInitializer_getID(CXCXXCtorInitializer CI, CXASTContext C) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getID(
      *static_cast<clang::ASTContext *>(C));
}
bool clang_CXXCtorInitializer_isBaseInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isBaseInitializer();
}

bool clang_CXXCtorInitializer_isMemberInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isMemberInitializer();
}

bool clang_CXXCtorInitializer_isAnyMemberInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isAnyMemberInitializer();
}

bool clang_CXXCtorInitializer_isDelegatingInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isDelegatingInitializer();
}

CXFieldDecl clang_CXXCtorInitializer_getMember(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getMember();
}

CXType_ clang_CXXCtorInitializer_getBaseClass(CXCXXCtorInitializer CI) {
  return const_cast<clang::Type *>(
      static_cast<clang::CXXCtorInitializer *>(CI)->getBaseClass());
}

CXExpr clang_CXXCtorInitializer_getInit(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getInit();
}

CXSourceLocation_ clang_CXXCtorInitializer_getSourceLocation(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getSourceLocation().getPtrEncoding();
}

bool clang_CXXCtorInitializer_isIndirectMemberInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isIndirectMemberInitializer();
}

bool clang_CXXCtorInitializer_isInClassMemberInitializer(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isInClassMemberInitializer();
}

bool clang_CXXCtorInitializer_isPackExpansion(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isPackExpansion();
}

CXSourceLocation_ clang_CXXCtorInitializer_getEllipsisLoc(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getEllipsisLoc().getPtrEncoding();
}

CXTypeLoc clang_CXXCtorInitializer_getBaseClassLoc(CXCXXCtorInitializer CI) {
  return new clang::TypeLoc( // NOLINT(*-owning-memory)
      static_cast<clang::CXXCtorInitializer *>(CI)->getBaseClassLoc());
}

bool clang_CXXCtorInitializer_isBaseVirtual(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isBaseVirtual();
}

CXTypeSourceInfo clang_CXXCtorInitializer_getTypeSourceInfo(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getTypeSourceInfo();
}

CXFieldDecl clang_CXXCtorInitializer_getAnyMember(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getAnyMember();
}

CXIndirectFieldDecl clang_CXXCtorInitializer_getIndirectMember(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getIndirectMember();
}

CXSourceLocation_ clang_CXXCtorInitializer_getMemberLocation(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getMemberLocation().getPtrEncoding();
}

CXSourceRange_ clang_CXXCtorInitializer_getSourceRange(CXCXXCtorInitializer CI) {
  auto rng = static_cast<clang::CXXCtorInitializer *>(CI)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_CXXCtorInitializer_isWritten(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->isWritten();
}

int clang_CXXCtorInitializer_getSourceOrder(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getSourceOrder();
}

CXSourceLocation_ clang_CXXCtorInitializer_getLParenLoc(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getLParenLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CXXCtorInitializer_getRParenLoc(CXCXXCtorInitializer CI) {
  return static_cast<clang::CXXCtorInitializer *>(CI)->getRParenLoc().getPtrEncoding();
}

// InheritedConstructor

// CXXConstructorDecl
bool clang_CXXConstructorDecl_isExplicit(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isExplicit();
}

CXExplicitSpecifier clang_CXXConstructorDecl_getExplicitSpecifier(CXCXXConstructorDecl CD) {
  auto ES = static_cast<clang::CXXConstructorDecl *>(CD)->getExplicitSpecifier();
  return std::make_unique<clang::ExplicitSpecifier>(ES).release();
}

bool clang_CXXConstructorDecl_isDefaultConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isDefaultConstructor();
}

bool clang_CXXConstructorDecl_isCopyConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isCopyConstructor();
}

bool clang_CXXConstructorDecl_isMoveConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isMoveConstructor();
}

bool clang_CXXConstructorDecl_isCopyOrMoveConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isCopyOrMoveConstructor();
}

bool clang_CXXConstructorDecl_isDelegatingConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isDelegatingConstructor();
}

bool clang_CXXConstructorDecl_isInheritingConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isInheritingConstructor();
}

bool clang_CXXConstructorDecl_isSpecializationCopyingObject(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isSpecializationCopyingObject();
}

CXConstructorUsingShadowDecl
clang_CXXConstructorDecl_getInheritedConstructorShadowDecl(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)
      ->getInheritedConstructor()
      .getShadowDecl();
}

CXCXXConstructorDecl
clang_CXXConstructorDecl_getInheritedConstructorBaseCtor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)
      ->getInheritedConstructor()
      .getConstructor();
}

unsigned clang_CXXConstructorDecl_getNumCtorInitializers(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->getNumCtorInitializers();
}

CXCXXCtorInitializer
clang_CXXConstructorDecl_getCtorInitializer(CXCXXConstructorDecl CD, unsigned i) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->init_begin()[i];
}

CXCXXConstructorDecl clang_CXXConstructorDecl_getTargetConstructor(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->getTargetConstructor();
}

bool clang_CXXConstructorDecl_isConvertingConstructor(CXCXXConstructorDecl CD,
                                                      bool AllowExplicit) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->isConvertingConstructor(
      AllowExplicit);
}

CXCXXConstructorDecl clang_CXXConstructorDecl_getCanonicalDecl(CXCXXConstructorDecl CD) {
  return static_cast<clang::CXXConstructorDecl *>(CD)->getCanonicalDecl();
}

// CXXDestructorDecl
CXFunctionDecl clang_CXXDestructorDecl_getOperatorDelete(CXCXXDestructorDecl DD) {
  return const_cast<clang::FunctionDecl *>(
      static_cast<clang::CXXDestructorDecl *>(DD)->getOperatorDelete());
}

CXExpr clang_CXXDestructorDecl_getOperatorDeleteThisArg(CXCXXDestructorDecl DD) {
  return static_cast<clang::CXXDestructorDecl *>(DD)->getOperatorDeleteThisArg();
}

CXCXXDestructorDecl clang_CXXDestructorDecl_getCanonicalDecl(CXCXXDestructorDecl DD) {
  return static_cast<clang::CXXDestructorDecl *>(DD)->getCanonicalDecl();
}

// CXXConversionDecl
CXQualType clang_CXXConversionDecl_getConversionType(CXCXXConversionDecl CD) {
  return static_cast<clang::CXXConversionDecl *>(CD)->getConversionType().getAsOpaquePtr();
}

bool clang_CXXConversionDecl_isExplicit(CXCXXConversionDecl CD) {
  return static_cast<clang::CXXConversionDecl *>(CD)->isExplicit();
}

CXExplicitSpecifier clang_CXXConversionDecl_getExplicitSpecifier(CXCXXConversionDecl CD) {
  auto ES = static_cast<clang::CXXConversionDecl *>(CD)->getExplicitSpecifier();
  return std::make_unique<clang::ExplicitSpecifier>(ES).release();
}

bool clang_CXXConversionDecl_isLambdaToBlockPointerConversion(CXCXXConversionDecl CD) {
  return static_cast<clang::CXXConversionDecl *>(CD)->isLambdaToBlockPointerConversion();
}

CXCXXConversionDecl clang_CXXConversionDecl_getCanonicalDecl(CXCXXConversionDecl CD) {
  return static_cast<clang::CXXConversionDecl *>(CD)->getCanonicalDecl();
}

// LinkageSpecDecl
CXLinkageSpecDecl clang_LinkageSpecDecl_Create(CXASTContext C, CXDeclContext DC,
                                               CXSourceLocation_ ExternLoc,
                                               CXSourceLocation_ LangLoc,
                                               CXLinkageSpecLanguageIDs Lang,
                                               bool HasBraces) {
  return clang::LinkageSpecDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(ExternLoc),
      clang::SourceLocation::getFromPtrEncoding(LangLoc),
      static_cast<clang::LinkageSpecLanguageIDs>(Lang), HasBraces);
}

CXLinkageSpecDecl clang_LinkageSpecDecl_CreateDeserialized(CXASTContext C, unsigned ID) {
  return clang::LinkageSpecDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                    ID);
}

CXLinkageSpecLanguageIDs clang_LinkageSpecDecl_getLanguage(CXLinkageSpecDecl LSD) {
  return static_cast<CXLinkageSpecLanguageIDs>(
      static_cast<clang::LinkageSpecDecl *>(LSD)->getLanguage());
}

void clang_LinkageSpecDecl_setLanguage(CXLinkageSpecDecl LSD,
                                       CXLinkageSpecLanguageIDs Lang) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setLanguage(
      static_cast<clang::LinkageSpecLanguageIDs>(Lang));
}

bool clang_LinkageSpecDecl_hasBraces(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->hasBraces();
}

CXSourceLocation_ clang_LinkageSpecDecl_getExternLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getExternLoc().getPtrEncoding();
}

CXSourceLocation_ clang_LinkageSpecDecl_getRBraceLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getRBraceLoc().getPtrEncoding();
}

void clang_LinkageSpecDecl_setExternLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setExternLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_LinkageSpecDecl_setRBraceLoc(CXLinkageSpecDecl LSD, CXSourceLocation_ Loc) {
  static_cast<clang::LinkageSpecDecl *>(LSD)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXSourceLocation_ clang_LinkageSpecDecl_getEndLoc(CXLinkageSpecDecl LSD) {
  return static_cast<clang::LinkageSpecDecl *>(LSD)->getEndLoc().getPtrEncoding();
}

CXSourceRange_ clang_LinkageSpecDecl_getSourceRange(CXLinkageSpecDecl LSD) {
  auto rng = static_cast<clang::LinkageSpecDecl *>(LSD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXDeclContext clang_LinkageSpecDecl_castToDeclContext(CXLinkageSpecDecl LSD) {
  return clang::LinkageSpecDecl::castToDeclContext(
      static_cast<clang::LinkageSpecDecl *>(LSD));
}

CXLinkageSpecDecl clang_LinkageSpecDecl_castFromDeclContext(CXDeclContext DC) {
  return clang::LinkageSpecDecl::castFromDeclContext(static_cast<clang::DeclContext *>(DC));
}

// UsingDirectiveDecl
CXNamespaceDecl clang_UsingDirectiveDecl_getNominatedNamespace(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getNominatedNamespace();
}

CXSourceRange_ clang_UsingDirectiveDecl_getQualifierRange(CXUsingDirectiveDecl UDD) {
  auto Q = static_cast<clang::UsingDirectiveDecl *>(UDD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXNestedNameSpecifier clang_UsingDirectiveDecl_getQualifier(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getQualifier();
}

CXNamedDecl
clang_UsingDirectiveDecl_getNominatedNamespaceAsWritten(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getNominatedNamespaceAsWritten();
}

CXDeclContext clang_UsingDirectiveDecl_getCommonAncestor(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getCommonAncestor();
}

CXSourceLocation_ clang_UsingDirectiveDecl_getUsingLoc(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getUsingLoc().getPtrEncoding();
}

CXSourceLocation_
clang_UsingDirectiveDecl_getNamespaceKeyLocation(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)
      ->getNamespaceKeyLocation()
      .getPtrEncoding();
}

CXSourceLocation_ clang_UsingDirectiveDecl_getIdentLocation(CXUsingDirectiveDecl UDD) {
  return static_cast<clang::UsingDirectiveDecl *>(UDD)->getIdentLocation().getPtrEncoding();
}

CXSourceRange_ clang_UsingDirectiveDecl_getSourceRange(CXUsingDirectiveDecl UDD) {
  clang::SourceRange R = static_cast<clang::UsingDirectiveDecl *>(UDD)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// NamespaceAliasDecl
CXNamespaceAliasDecl clang_NamespaceAliasDecl_getCanonicalDecl(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getCanonicalDecl();
}

CXSourceRange_ clang_NamespaceAliasDecl_getQualifierRange(CXNamespaceAliasDecl NAD) {
  auto Q = static_cast<clang::NamespaceAliasDecl *>(NAD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXNestedNameSpecifier clang_NamespaceAliasDecl_getQualifier(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getQualifier();
}

CXNamespaceDecl clang_NamespaceAliasDecl_getNamespace(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getNamespace();
}

CXSourceLocation_ clang_NamespaceAliasDecl_getAliasLoc(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getAliasLoc().getPtrEncoding();
}

CXSourceLocation_ clang_NamespaceAliasDecl_getNamespaceLoc(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getNamespaceLoc().getPtrEncoding();
}

CXSourceLocation_ clang_NamespaceAliasDecl_getTargetNameLoc(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getTargetNameLoc().getPtrEncoding();
}

CXNamedDecl clang_NamespaceAliasDecl_getAliasedNamespace(CXNamespaceAliasDecl NAD) {
  return static_cast<clang::NamespaceAliasDecl *>(NAD)->getAliasedNamespace();
}

CXSourceRange_ clang_NamespaceAliasDecl_getSourceRange(CXNamespaceAliasDecl NAD) {
  clang::SourceRange R = static_cast<clang::NamespaceAliasDecl *>(NAD)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

// LifetimeExtendedTemporaryDecl
CXValueDecl
clang_LifetimeExtendedTemporaryDecl_getExtendingDecl(CXLifetimeExtendedTemporaryDecl D) {
  return static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getExtendingDecl();
}

CXStorageDuration
clang_LifetimeExtendedTemporaryDecl_getStorageDuration(CXLifetimeExtendedTemporaryDecl D) {
  return static_cast<CXStorageDuration>(
      static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getStorageDuration());
}

bool clang_LifetimeExtendedTemporaryDecl_hasTemporaryExpr(
    CXLifetimeExtendedTemporaryDecl D) {
  auto *LETD = static_cast<clang::LifetimeExtendedTemporaryDecl *>(D);
  return *LETD->childrenExpr().begin() != nullptr;
}

CXExpr
clang_LifetimeExtendedTemporaryDecl_getTemporaryExpr(CXLifetimeExtendedTemporaryDecl D) {
  return static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getTemporaryExpr();
}

unsigned
clang_LifetimeExtendedTemporaryDecl_getManglingNumber(CXLifetimeExtendedTemporaryDecl D) {
  return static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getManglingNumber();
}

CXAPValue
clang_LifetimeExtendedTemporaryDecl_getOrCreateValue(CXLifetimeExtendedTemporaryDecl D,
                                                     bool MayCreate) {
  return static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getOrCreateValue(
      MayCreate);
}

CXAPValue clang_LifetimeExtendedTemporaryDecl_getValue(CXLifetimeExtendedTemporaryDecl D) {
  return static_cast<clang::LifetimeExtendedTemporaryDecl *>(D)->getValue();
}

// UsingShadowDecl
CXNamedDecl clang_UsingShadowDecl_getTargetDecl(CXUsingShadowDecl USD) {
  return static_cast<clang::UsingShadowDecl *>(USD)->getTargetDecl();
}

CXUsingShadowDecl clang_UsingShadowDecl_getCanonicalDecl(CXUsingShadowDecl USD) {
  return static_cast<clang::UsingShadowDecl *>(USD)->getCanonicalDecl();
}

CXBaseUsingDecl clang_UsingShadowDecl_getIntroducer(CXUsingShadowDecl USD) {
  return static_cast<clang::UsingShadowDecl *>(USD)->getIntroducer();
}

CXUsingShadowDecl clang_UsingShadowDecl_getNextUsingShadowDecl(CXUsingShadowDecl USD) {
  return static_cast<clang::UsingShadowDecl *>(USD)->getNextUsingShadowDecl();
}

// BaseUsingDecl
// StaticAssertDecl
CXStaticAssertDecl clang_StaticAssertDecl_Create(CXASTContext C, CXDeclContext DC,
                                                 CXSourceLocation_ StaticAssertLoc,
                                                 CXExpr AssertExpr, CXExpr Message,
                                                 CXSourceLocation_ RParenLoc,
                                                 bool Failed) {
  return clang::StaticAssertDecl::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::DeclContext *>(DC),
      clang::SourceLocation::getFromPtrEncoding(StaticAssertLoc),
      static_cast<clang::Expr *>(AssertExpr), static_cast<clang::Expr *>(Message),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), Failed);
}

CXStaticAssertDecl clang_StaticAssertDecl_CreateDeserialized(CXASTContext C,
                                                             unsigned ID) {
  return clang::StaticAssertDecl::CreateDeserialized(*static_cast<clang::ASTContext *>(C),
                                                     ID);
}

CXExpr clang_StaticAssertDecl_getAssertExpr(CXStaticAssertDecl SAD) {
  return static_cast<clang::StaticAssertDecl *>(SAD)->getAssertExpr();
}

CXExpr clang_StaticAssertDecl_getMessage(CXStaticAssertDecl SAD) {
  return static_cast<clang::StaticAssertDecl *>(SAD)->getMessage();
}

bool clang_StaticAssertDecl_isFailed(CXStaticAssertDecl SAD) {
  return static_cast<clang::StaticAssertDecl *>(SAD)->isFailed();
}

CXSourceLocation_ clang_StaticAssertDecl_getRParenLoc(CXStaticAssertDecl SAD) {
  return static_cast<clang::StaticAssertDecl *>(SAD)->getRParenLoc().getPtrEncoding();
}

CXSourceRange_ clang_StaticAssertDecl_getSourceRange(CXStaticAssertDecl SAD) {
  clang::SourceRange R = static_cast<clang::StaticAssertDecl *>(SAD)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

unsigned clang_BaseUsingDecl_shadow_size(CXBaseUsingDecl BUD) {
  return static_cast<clang::BaseUsingDecl *>(BUD)->shadow_size();
}

void clang_BaseUsingDecl_getShadows(CXBaseUsingDecl BUD, CXUsingShadowDecl *Buf) {
  auto *D = static_cast<clang::BaseUsingDecl *>(BUD);
  unsigned I = 0;
  for (auto *S : D->shadows())
    Buf[I++] = S;
}

// UsingDecl
CXSourceLocation_ clang_UsingDecl_getUsingLoc(CXUsingDecl UD) {
  return static_cast<clang::UsingDecl *>(UD)->getUsingLoc().getPtrEncoding();
}

CXSourceRange_ clang_UsingDecl_getQualifierRange(CXUsingDecl UD) {
  auto Q = static_cast<clang::UsingDecl *>(UD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXNestedNameSpecifier clang_UsingDecl_getQualifier(CXUsingDecl UD) {
  return static_cast<clang::UsingDecl *>(UD)->getQualifier();
}

CXDeclarationNameInfo clang_UsingDecl_getNameInfo(CXUsingDecl UD) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::UsingDecl *>(UD)->getNameInfo())
      .release();
}

bool clang_UsingDecl_isAccessDeclaration(CXUsingDecl UD) {
  return static_cast<clang::UsingDecl *>(UD)->isAccessDeclaration();
}

bool clang_UsingDecl_hasTypename(CXUsingDecl UD) {
  return static_cast<clang::UsingDecl *>(UD)->hasTypename();
}

CXSourceRange_ clang_UsingDecl_getSourceRange(CXUsingDecl UD) {
  clang::SourceRange R = static_cast<clang::UsingDecl *>(UD)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXUsingDecl clang_UsingDecl_getCanonicalDecl(CXUsingDecl UD) {
  return static_cast<clang::UsingDecl *>(UD)->getCanonicalDecl();
}

// ConstructorUsingShadowDecl
CXUsingDecl
clang_ConstructorUsingShadowDecl_getIntroducer(CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)->getIntroducer();
}

CXCXXRecordDecl
clang_ConstructorUsingShadowDecl_getParent(CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)->getParent();
}

CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_getNominatedBaseClassShadowDecl(
    CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)
      ->getNominatedBaseClassShadowDecl();
}

CXConstructorUsingShadowDecl
clang_ConstructorUsingShadowDecl_getConstructedBaseClassShadowDecl(
    CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)
      ->getConstructedBaseClassShadowDecl();
}

CXCXXRecordDecl
clang_ConstructorUsingShadowDecl_getNominatedBaseClass(CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)->getNominatedBaseClass();
}

CXCXXRecordDecl clang_ConstructorUsingShadowDecl_getConstructedBaseClass(
    CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)->getConstructedBaseClass();
}

bool clang_ConstructorUsingShadowDecl_constructsVirtualBase(
    CXConstructorUsingShadowDecl CUSD) {
  return static_cast<clang::ConstructorUsingShadowDecl *>(CUSD)->constructsVirtualBase();
}

// UsingEnumDecl
CXSourceLocation_ clang_UsingEnumDecl_getUsingLoc(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getUsingLoc().getPtrEncoding();
}

CXSourceLocation_ clang_UsingEnumDecl_getEnumLoc(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getEnumLoc().getPtrEncoding();
}

CXNestedNameSpecifier clang_UsingEnumDecl_getQualifier(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getQualifier();
}

CXTypeLoc clang_UsingEnumDecl_getEnumTypeLoc(CXUsingEnumDecl UED) {
  return new clang::TypeLoc( // NOLINT(*-owning-memory)
      static_cast<clang::UsingEnumDecl *>(UED)->getEnumTypeLoc());
}

CXTypeSourceInfo clang_UsingEnumDecl_getEnumType(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getEnumType();
}

CXEnumDecl clang_UsingEnumDecl_getEnumDecl(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getEnumDecl();
}

CXSourceRange_ clang_UsingEnumDecl_getSourceRange(CXUsingEnumDecl UED) {
  auto rng = static_cast<clang::UsingEnumDecl *>(UED)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXUsingEnumDecl clang_UsingEnumDecl_getCanonicalDecl(CXUsingEnumDecl UED) {
  return static_cast<clang::UsingEnumDecl *>(UED)->getCanonicalDecl();
}

// UsingPackDecl
CXNamedDecl clang_UsingPackDecl_getInstantiatedFromUsingDecl(CXUsingPackDecl UPD) {
  return static_cast<clang::UsingPackDecl *>(UPD)->getInstantiatedFromUsingDecl();
}

unsigned clang_UsingPackDecl_getNumExpansions(CXUsingPackDecl UPD) {
  return static_cast<clang::UsingPackDecl *>(UPD)->expansions().size();
}

CXNamedDecl clang_UsingPackDecl_getExpansion(CXUsingPackDecl UPD, unsigned i) {
  return static_cast<clang::UsingPackDecl *>(UPD)->expansions()[i];
}

CXSourceRange_ clang_UsingPackDecl_getSourceRange(CXUsingPackDecl UPD) {
  auto rng = static_cast<clang::UsingPackDecl *>(UPD)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXUsingPackDecl clang_UsingPackDecl_getCanonicalDecl(CXUsingPackDecl UPD) {
  return static_cast<clang::UsingPackDecl *>(UPD)->getCanonicalDecl();
}

// UnresolvedUsingValueDecl
CXSourceLocation_
clang_UnresolvedUsingValueDecl_getUsingLoc(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)
      ->getUsingLoc()
      .getPtrEncoding();
}

bool clang_UnresolvedUsingValueDecl_isAccessDeclaration(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->isAccessDeclaration();
}

CXSourceRange_
clang_UnresolvedUsingValueDecl_getQualifierRange(CXUnresolvedUsingValueDecl UUVD) {
  auto Q = static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXNestedNameSpecifier
clang_UnresolvedUsingValueDecl_getQualifier(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->getQualifier();
}

CXDeclarationNameInfo
clang_UnresolvedUsingValueDecl_getNameInfo(CXUnresolvedUsingValueDecl UUVD) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->getNameInfo())
      .release();
}

bool clang_UnresolvedUsingValueDecl_isPackExpansion(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->isPackExpansion();
}

CXSourceLocation_
clang_UnresolvedUsingValueDecl_getEllipsisLoc(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)
      ->getEllipsisLoc()
      .getPtrEncoding();
}

CXSourceRange_
clang_UnresolvedUsingValueDecl_getSourceRange(CXUnresolvedUsingValueDecl UUVD) {
  clang::SourceRange R =
      static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXUnresolvedUsingValueDecl
clang_UnresolvedUsingValueDecl_getCanonicalDecl(CXUnresolvedUsingValueDecl UUVD) {
  return static_cast<clang::UnresolvedUsingValueDecl *>(UUVD)->getCanonicalDecl();
}

// UnresolvedUsingTypenameDecl
CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getUsingLoc(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)
      ->getUsingLoc()
      .getPtrEncoding();
}

CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getTypenameLoc(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)
      ->getTypenameLoc()
      .getPtrEncoding();
}

CXSourceRange_
clang_UnresolvedUsingTypenameDecl_getQualifierRange(CXUnresolvedUsingTypenameDecl UUTD) {
  auto Q = static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXNestedNameSpecifier
clang_UnresolvedUsingTypenameDecl_getQualifier(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)->getQualifier();
}

CXDeclarationNameInfo
clang_UnresolvedUsingTypenameDecl_getNameInfo(CXUnresolvedUsingTypenameDecl UUTD) {
  return std::make_unique<clang::DeclarationNameInfo>(
             static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)->getNameInfo())
      .release();
}

bool clang_UnresolvedUsingTypenameDecl_isPackExpansion(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)->isPackExpansion();
}

CXSourceLocation_
clang_UnresolvedUsingTypenameDecl_getEllipsisLoc(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)
      ->getEllipsisLoc()
      .getPtrEncoding();
}

CXUnresolvedUsingTypenameDecl
clang_UnresolvedUsingTypenameDecl_getCanonicalDecl(CXUnresolvedUsingTypenameDecl UUTD) {
  return static_cast<clang::UnresolvedUsingTypenameDecl *>(UUTD)->getCanonicalDecl();
}

// BindingDecl
CXExpr clang_BindingDecl_getBinding(CXBindingDecl BD) {
  return static_cast<clang::BindingDecl *>(BD)->getBinding();
}

CXValueDecl clang_BindingDecl_getDecomposedDecl(CXBindingDecl BD) {
  return static_cast<clang::BindingDecl *>(BD)->getDecomposedDecl();
}

CXVarDecl clang_BindingDecl_getHoldingVar(CXBindingDecl BD) {
  return static_cast<clang::BindingDecl *>(BD)->getHoldingVar();
}

void clang_BindingDecl_setBinding(CXBindingDecl BD, CXQualType DeclaredType,
                                  CXExpr Binding) {
  static_cast<clang::BindingDecl *>(BD)->setBinding(
      clang::QualType::getFromOpaquePtr(DeclaredType), static_cast<clang::Expr *>(Binding));
}

void clang_BindingDecl_setDecomposedDecl(CXBindingDecl BD, CXValueDecl Decomposed) {
  static_cast<clang::BindingDecl *>(BD)->setDecomposedDecl(
      static_cast<clang::ValueDecl *>(Decomposed));
}

// DecompositionDecl
unsigned clang_DecompositionDecl_getNumBindings(CXDecompositionDecl DD) {
  return static_cast<clang::DecompositionDecl *>(DD)->bindings().size();
}

CXBindingDecl clang_DecompositionDecl_getBinding(CXDecompositionDecl DD, unsigned i) {
  return static_cast<clang::DecompositionDecl *>(DD)->bindings()[i];
}

// MSPropertyDecl
bool clang_MSPropertyDecl_hasGetter(CXMSPropertyDecl MPD) {
  return static_cast<clang::MSPropertyDecl *>(MPD)->hasGetter();
}

CXIdentifierInfo clang_MSPropertyDecl_getGetterId(CXMSPropertyDecl MPD) {
  return static_cast<clang::MSPropertyDecl *>(MPD)->getGetterId();
}

bool clang_MSPropertyDecl_hasSetter(CXMSPropertyDecl MPD) {
  return static_cast<clang::MSPropertyDecl *>(MPD)->hasSetter();
}

CXIdentifierInfo clang_MSPropertyDecl_getSetterId(CXMSPropertyDecl MPD) {
  return static_cast<clang::MSPropertyDecl *>(MPD)->getSetterId();
}
