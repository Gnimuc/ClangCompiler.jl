#include "clang-ex/Sema/CXOverload.h"
#include "clang/Sema/Overload.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/APValue.h"
#include "clang/Sema/Sema.h"

void clang_StandardConversionSequence_setFromType(CXStandardConversionSequence SCS,
                                                  CXQualType T) {
  static_cast<clang::StandardConversionSequence *>(SCS)->setFromType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_StandardConversionSequence_setToType(CXStandardConversionSequence SCS,
                                                unsigned Idx, CXQualType T) {
  static_cast<clang::StandardConversionSequence *>(SCS)->setToType(
      Idx, clang::QualType::getFromOpaquePtr(T));
}

void clang_StandardConversionSequence_setAllToTypes(CXStandardConversionSequence SCS,
                                                    CXQualType T) {
  static_cast<clang::StandardConversionSequence *>(SCS)->setAllToTypes(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_StandardConversionSequence_getFromType(CXStandardConversionSequence SCS) {
  return static_cast<clang::StandardConversionSequence *>(SCS)
      ->getFromType()
      .getAsOpaquePtr();
}

CXQualType clang_StandardConversionSequence_getToType(CXStandardConversionSequence SCS,
                                                      unsigned Idx) {
  return static_cast<clang::StandardConversionSequence *>(SCS)
      ->getToType(Idx)
      .getAsOpaquePtr();
}

void clang_StandardConversionSequence_setAsIdentityConversion(
    CXStandardConversionSequence SCS) {
  static_cast<clang::StandardConversionSequence *>(SCS)->setAsIdentityConversion();
}

bool clang_StandardConversionSequence_isIdentityConversion(
    CXStandardConversionSequence SCS) {
  return static_cast<clang::StandardConversionSequence *>(SCS)->isIdentityConversion();
}

CXImplicitConversionRank
clang_StandardConversionSequence_getRank(CXStandardConversionSequence SCS) {
  return static_cast<CXImplicitConversionRank>(
      static_cast<clang::StandardConversionSequence *>(SCS)->getRank());
}

bool clang_StandardConversionSequence_isPointerConversionToBool(
    CXStandardConversionSequence SCS) {
  return static_cast<clang::StandardConversionSequence *>(SCS)->isPointerConversionToBool();
}

bool clang_StandardConversionSequence_isPointerConversionToVoidPointer(
    CXStandardConversionSequence SCS, CXASTContext Ctx) {
  return static_cast<clang::StandardConversionSequence *>(SCS)
      ->isPointerConversionToVoidPointer(*static_cast<clang::ASTContext *>(Ctx));
}

CXNarrowingKind clang_StandardConversionSequence_getNarrowingKind(
    CXStandardConversionSequence SCS, CXASTContext Ctx, CXExpr Converted,
    CXAPValue ConstantValue, CXQualType *ConstantType,
    bool IgnoreFloatToIntegralConversion) {
  clang::QualType CT;
  clang::NarrowingKind NK =
      static_cast<clang::StandardConversionSequence *>(SCS)->getNarrowingKind(
          *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::Expr *>(Converted),
          *static_cast<clang::APValue *>(ConstantValue), CT,
          IgnoreFloatToIntegralConversion);
  *ConstantType = CT.getAsOpaquePtr();
  return static_cast<CXNarrowingKind>(NK);
}

void clang_StandardConversionSequence_dump(CXStandardConversionSequence SCS) {
  static_cast<clang::StandardConversionSequence *>(SCS)->dump();
}

CXStandardConversionSequence
clang_UserDefinedConversionSequence_getBefore(CXUserDefinedConversionSequence UDCS) {
  return &static_cast<clang::UserDefinedConversionSequence *>(UDCS)->Before;
}

CXStandardConversionSequence
clang_UserDefinedConversionSequence_getAfter(CXUserDefinedConversionSequence UDCS) {
  return &static_cast<clang::UserDefinedConversionSequence *>(UDCS)->After;
}

bool clang_UserDefinedConversionSequence_getEllipsisConversion(
    CXUserDefinedConversionSequence UDCS) {
  return static_cast<clang::UserDefinedConversionSequence *>(UDCS)->EllipsisConversion;
}

void clang_UserDefinedConversionSequence_setEllipsisConversion(
    CXUserDefinedConversionSequence UDCS, bool V) {
  static_cast<clang::UserDefinedConversionSequence *>(UDCS)->EllipsisConversion = V;
}

bool clang_UserDefinedConversionSequence_getHadMultipleCandidates(
    CXUserDefinedConversionSequence UDCS) {
  return static_cast<clang::UserDefinedConversionSequence *>(UDCS)->HadMultipleCandidates;
}

void clang_UserDefinedConversionSequence_setHadMultipleCandidates(
    CXUserDefinedConversionSequence UDCS, bool V) {
  static_cast<clang::UserDefinedConversionSequence *>(UDCS)->HadMultipleCandidates = V;
}

CXFunctionDecl clang_UserDefinedConversionSequence_getConversionFunction(
    CXUserDefinedConversionSequence UDCS) {
  return static_cast<clang::UserDefinedConversionSequence *>(UDCS)->ConversionFunction;
}

void clang_UserDefinedConversionSequence_setConversionFunction(
    CXUserDefinedConversionSequence UDCS, CXFunctionDecl FD) {
  static_cast<clang::UserDefinedConversionSequence *>(UDCS)->ConversionFunction =
      static_cast<clang::FunctionDecl *>(FD);
}

void clang_UserDefinedConversionSequence_dump(CXUserDefinedConversionSequence UDCS) {
  static_cast<clang::UserDefinedConversionSequence *>(UDCS)->dump();
}

CXQualType
clang_AmbiguousConversionSequence_getFromType(CXAmbiguousConversionSequence ACS) {
  return static_cast<clang::AmbiguousConversionSequence *>(ACS)
      ->getFromType()
      .getAsOpaquePtr();
}

CXQualType clang_AmbiguousConversionSequence_getToType(CXAmbiguousConversionSequence ACS) {
  return static_cast<clang::AmbiguousConversionSequence *>(ACS)
      ->getToType()
      .getAsOpaquePtr();
}

void clang_AmbiguousConversionSequence_setFromType(CXAmbiguousConversionSequence ACS,
                                                   CXQualType T) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->setFromType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_AmbiguousConversionSequence_setToType(CXAmbiguousConversionSequence ACS,
                                                 CXQualType T) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->setToType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_AmbiguousConversionSequence_addConversion(CXAmbiguousConversionSequence ACS,
                                                     CXNamedDecl Found, CXFunctionDecl D) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->addConversion(
      static_cast<clang::NamedDecl *>(Found), static_cast<clang::FunctionDecl *>(D));
}

unsigned
clang_AmbiguousConversionSequence_getNumConversions(CXAmbiguousConversionSequence ACS) {
  return static_cast<unsigned>(
      static_cast<clang::AmbiguousConversionSequence *>(ACS)->conversions().size());
}

CXNamedDecl
clang_AmbiguousConversionSequence_getConversionFound(CXAmbiguousConversionSequence ACS,
                                                     unsigned I) {
  return static_cast<clang::AmbiguousConversionSequence *>(ACS)->conversions()[I].first;
}

CXFunctionDecl
clang_AmbiguousConversionSequence_getConversionFunction(CXAmbiguousConversionSequence ACS,
                                                        unsigned I) {
  return static_cast<clang::AmbiguousConversionSequence *>(ACS)->conversions()[I].second;
}

void clang_AmbiguousConversionSequence_construct(CXAmbiguousConversionSequence ACS) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->construct();
}

void clang_AmbiguousConversionSequence_destruct(CXAmbiguousConversionSequence ACS) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->destruct();
}

void clang_AmbiguousConversionSequence_copyFrom(CXAmbiguousConversionSequence ACS,
                                                CXAmbiguousConversionSequence Other) {
  static_cast<clang::AmbiguousConversionSequence *>(ACS)->copyFrom(
      *static_cast<clang::AmbiguousConversionSequence *>(Other));
}

void clang_BadConversionSequence_init(CXBadConversionSequence BCS,
                                      CXBadConversionSequence_FailureKind K, CXExpr From,
                                      CXQualType To) {
  static_cast<clang::BadConversionSequence *>(BCS)->init(
      static_cast<clang::BadConversionSequence::FailureKind>(K),
      static_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(To));
}

CXQualType clang_BadConversionSequence_getFromType(CXBadConversionSequence BCS) {
  return static_cast<clang::BadConversionSequence *>(BCS)->getFromType().getAsOpaquePtr();
}

CXQualType clang_BadConversionSequence_getToType(CXBadConversionSequence BCS) {
  return static_cast<clang::BadConversionSequence *>(BCS)->getToType().getAsOpaquePtr();
}

CXBadConversionSequence_FailureKind
clang_BadConversionSequence_getFailureKind(CXBadConversionSequence BCS) {
  return static_cast<CXBadConversionSequence_FailureKind>(
      static_cast<clang::BadConversionSequence *>(BCS)->Kind);
}

CXExpr clang_BadConversionSequence_getFromExpr(CXBadConversionSequence BCS) {
  return static_cast<clang::BadConversionSequence *>(BCS)->FromExpr;
}

void clang_BadConversionSequence_setFromExpr(CXBadConversionSequence BCS, CXExpr E) {
  static_cast<clang::BadConversionSequence *>(BCS)->setFromExpr(
      static_cast<clang::Expr *>(E));
}

void clang_BadConversionSequence_setFromType(CXBadConversionSequence BCS, CXQualType T) {
  static_cast<clang::BadConversionSequence *>(BCS)->setFromType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_BadConversionSequence_setToType(CXBadConversionSequence BCS, CXQualType T) {
  static_cast<clang::BadConversionSequence *>(BCS)->setToType(
      clang::QualType::getFromOpaquePtr(T));
}

CXImplicitConversionSequence clang_ImplicitConversionSequence_create(void) {
  auto ICS = std::make_unique<clang::ImplicitConversionSequence>();
  return ICS.release();
}

void clang_ImplicitConversionSequence_dispose(CXImplicitConversionSequence ICS) {
  delete static_cast<clang::ImplicitConversionSequence *>(ICS);
}

CXImplicitConversionSequence_Kind
clang_ImplicitConversionSequence_getKind(CXImplicitConversionSequence ICS) {
  return static_cast<CXImplicitConversionSequence_Kind>(
      static_cast<clang::ImplicitConversionSequence *>(ICS)->getKind());
}

unsigned clang_ImplicitConversionSequence_getKindRank(CXImplicitConversionSequence ICS) {
  return static_cast<clang::ImplicitConversionSequence *>(ICS)->getKindRank();
}

CXStandardConversionSequence
clang_ImplicitConversionSequence_getStandard(CXImplicitConversionSequence ICS) {
  return &static_cast<clang::ImplicitConversionSequence *>(ICS)->Standard;
}

CXBadConversionSequence
clang_ImplicitConversionSequence_getBad(CXImplicitConversionSequence ICS) {
  return &static_cast<clang::ImplicitConversionSequence *>(ICS)->Bad;
}

CXAmbiguousConversionSequence
clang_ImplicitConversionSequence_getAmbiguous(CXImplicitConversionSequence ICS) {
  return &static_cast<clang::ImplicitConversionSequence *>(ICS)->Ambiguous;
}

CXUserDefinedConversionSequence
clang_ImplicitConversionSequence_getUserDefined(CXImplicitConversionSequence ICS) {
  return &static_cast<clang::ImplicitConversionSequence *>(ICS)->UserDefined;
}

bool clang_ImplicitConversionSequence_isInitialized(CXImplicitConversionSequence ICS) {
  return static_cast<clang::ImplicitConversionSequence *>(ICS)->isInitialized();
}

void clang_ImplicitConversionSequence_setBad(CXImplicitConversionSequence ICS,
                                             CXBadConversionSequence_FailureKind Failure,
                                             CXQualType FromType, CXQualType ToType) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setBad(
      static_cast<clang::BadConversionSequence::FailureKind>(Failure),
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType));
}

void clang_ImplicitConversionSequence_setStandard(CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setStandard();
}

void clang_ImplicitConversionSequence_setStaticObjectArgument(
    CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setStaticObjectArgument();
}

void clang_ImplicitConversionSequence_setEllipsis(CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setEllipsis();
}

void clang_ImplicitConversionSequence_setUserDefined(CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setUserDefined();
}

void clang_ImplicitConversionSequence_setAmbiguous(CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setAmbiguous();
}

void clang_ImplicitConversionSequence_setAsIdentityConversion(
    CXImplicitConversionSequence ICS, CXQualType T) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setAsIdentityConversion(
      clang::QualType::getFromOpaquePtr(T));
}

bool clang_ImplicitConversionSequence_hasInitializerListContainerType(
    CXImplicitConversionSequence ICS) {
  return static_cast<clang::ImplicitConversionSequence *>(ICS)
      ->hasInitializerListContainerType();
}

void clang_ImplicitConversionSequence_setInitializerListContainerType(
    CXImplicitConversionSequence ICS, CXQualType T, bool IncompleteArray) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->setInitializerListContainerType(
      clang::QualType::getFromOpaquePtr(T), IncompleteArray);
}

bool clang_ImplicitConversionSequence_isInitializerListOfIncompleteArray(
    CXImplicitConversionSequence ICS) {
  return static_cast<clang::ImplicitConversionSequence *>(ICS)
      ->isInitializerListOfIncompleteArray();
}

CXQualType clang_ImplicitConversionSequence_getInitializerListContainerType(
    CXImplicitConversionSequence ICS) {
  return static_cast<clang::ImplicitConversionSequence *>(ICS)
      ->getInitializerListContainerType()
      .getAsOpaquePtr();
}

CXImplicitConversionSequence clang_ImplicitConversionSequence_getNullptrToBool(
    CXQualType SourceType, CXQualType DestType, bool NeedLValToRVal) {
  auto ICS = std::make_unique<clang::ImplicitConversionSequence>(
      clang::ImplicitConversionSequence::getNullptrToBool(
          clang::QualType::getFromOpaquePtr(SourceType),
          clang::QualType::getFromOpaquePtr(DestType), NeedLValToRVal));
  return ICS.release();
}

void clang_ImplicitConversionSequence_dump(CXImplicitConversionSequence ICS) {
  static_cast<clang::ImplicitConversionSequence *>(ICS)->dump();
}

CXOverloadCandidateRewriteKind
clang_OverloadCandidate_getRewriteKind(CXOverloadCandidate C) {
  return static_cast<CXOverloadCandidateRewriteKind>(
      static_cast<clang::OverloadCandidate *>(C)->getRewriteKind());
}

bool clang_OverloadCandidate_isReversed(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->isReversed();
}

bool clang_OverloadCandidate_hasAmbiguousConversion(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->hasAmbiguousConversion();
}

bool clang_OverloadCandidate_TryToFixBadConversion(CXOverloadCandidate C, unsigned Idx,
                                                   CXSema S) {
  return static_cast<clang::OverloadCandidate *>(C)->TryToFixBadConversion(
      Idx, *static_cast<clang::Sema *>(S));
}

unsigned clang_OverloadCandidate_getNumParams(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->getNumParams();
}

bool clang_OverloadCandidate_NotValidBecauseConstraintExprHasError(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)
      ->NotValidBecauseConstraintExprHasError();
}

unsigned clang_OverloadCandidate_getNumConversions(CXOverloadCandidate C) {
  return static_cast<unsigned>(
      static_cast<clang::OverloadCandidate *>(C)->Conversions.size());
}

CXImplicitConversionSequence clang_OverloadCandidate_getConversion(CXOverloadCandidate C,
                                                                   unsigned I) {
  return &static_cast<clang::OverloadCandidate *>(C)->Conversions[I];
}

CXFunctionDecl clang_OverloadCandidate_getFunction(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->Function;
}

CXCXXConversionDecl clang_OverloadCandidate_getSurrogate(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->Surrogate;
}

bool clang_OverloadCandidate_getViable(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->Viable;
}

bool clang_OverloadCandidate_getBest(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->Best;
}

bool clang_OverloadCandidate_isSurrogate(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->IsSurrogate;
}

bool clang_OverloadCandidate_getIgnoreObjectArgument(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->IgnoreObjectArgument;
}

unsigned clang_OverloadCandidate_getExplicitCallArguments(CXOverloadCandidate C) {
  return static_cast<clang::OverloadCandidate *>(C)->ExplicitCallArguments;
}

CXOverloadCandidateSet
clang_OverloadCandidateSet_create(CXSourceLocation_ Loc,
                                  CXOverloadCandidateSet_CandidateSetKind CSK) {
  auto CS = std::make_unique<clang::OverloadCandidateSet>(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::OverloadCandidateSet::CandidateSetKind>(CSK));
  return CS.release();
}

void clang_OverloadCandidateSet_dispose(CXOverloadCandidateSet CS) {
  delete static_cast<clang::OverloadCandidateSet *>(CS);
}

CXOverloadCandidateSet clang_OverloadCandidateSet_createWithRewriteInfo(
    CXSourceLocation_ Loc, CXOverloadCandidateSet_CandidateSetKind CSK,
    CXOverloadedOperatorKind Op, CXSourceLocation_ OpLoc, bool AllowRewritten) {
  auto CS = std::make_unique<clang::OverloadCandidateSet>(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::OverloadCandidateSet::CandidateSetKind>(CSK),
      clang::OverloadCandidateSet::OperatorRewriteInfo(
          static_cast<clang::OverloadedOperatorKind>(Op),
          clang::SourceLocation::getFromPtrEncoding(OpLoc), AllowRewritten));
  return CS.release();
}

CXSourceLocation_ clang_OverloadCandidateSet_getLocation(CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->getLocation().getPtrEncoding();
}

CXOverloadCandidateSet_CandidateSetKind
clang_OverloadCandidateSet_getKind(CXOverloadCandidateSet CS) {
  return static_cast<CXOverloadCandidateSet_CandidateSetKind>(
      static_cast<clang::OverloadCandidateSet *>(CS)->getKind());
}

CXOverloadedOperatorKind
clang_OverloadCandidateSet_getRewriteInfoOriginalOperator(CXOverloadCandidateSet CS) {
  return static_cast<CXOverloadedOperatorKind>(
      static_cast<clang::OverloadCandidateSet *>(CS)->getRewriteInfo().OriginalOperator);
}

CXSourceLocation_
clang_OverloadCandidateSet_getRewriteInfoOpLoc(CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)
      ->getRewriteInfo()
      .OpLoc.getPtrEncoding();
}

bool clang_OverloadCandidateSet_getRewriteInfoAllowRewrittenCandidates(
    CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)
      ->getRewriteInfo()
      .AllowRewrittenCandidates;
}

bool clang_OverloadCandidateSet_rewriteInfoIsRewrittenOperator(CXOverloadCandidateSet CS,
                                                               CXFunctionDecl FD) {
  return static_cast<clang::OverloadCandidateSet *>(CS)
      ->getRewriteInfo()
      .isRewrittenOperator(static_cast<clang::FunctionDecl *>(FD));
}

bool clang_OverloadCandidateSet_rewriteInfoIsAcceptableCandidate(CXOverloadCandidateSet CS,
                                                                 CXFunctionDecl FD) {
  return static_cast<clang::OverloadCandidateSet *>(CS)
      ->getRewriteInfo()
      .isAcceptableCandidate(static_cast<clang::FunctionDecl *>(FD));
}

CXOverloadCandidateRewriteKind
clang_OverloadCandidateSet_rewriteInfoGetRewriteKind(CXOverloadCandidateSet CS,
                                                     CXFunctionDecl FD, bool Reversed) {
  return static_cast<CXOverloadCandidateRewriteKind>(
      static_cast<clang::OverloadCandidateSet *>(CS)->getRewriteInfo().getRewriteKind(
          static_cast<clang::FunctionDecl *>(FD),
          Reversed ? clang::OverloadCandidateParamOrder::Reversed
                   : clang::OverloadCandidateParamOrder::Normal));
}

bool clang_OverloadCandidateSet_rewriteInfoIsReversible(CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->getRewriteInfo().isReversible();
}

bool clang_OverloadCandidateSet_rewriteInfoAllowsReversed(CXOverloadCandidateSet CS,
                                                          CXOverloadedOperatorKind Op) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->getRewriteInfo().allowsReversed(
      static_cast<clang::OverloadedOperatorKind>(Op));
}

bool clang_OverloadCandidateSet_shouldDeferDiags(CXOverloadCandidateSet CS, CXSema S,
                                                 const CXExpr *Args, unsigned NumArgs,
                                                 CXSourceLocation_ OpLoc) {
  llvm::SmallVector<clang::Expr *, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(static_cast<clang::Expr *>(Args[I]));
  return static_cast<clang::OverloadCandidateSet *>(CS)->shouldDeferDiags(
      *static_cast<clang::Sema *>(S), ArgVec,
      clang::SourceLocation::getFromPtrEncoding(OpLoc));
}

bool clang_OverloadCandidateSet_isNewCandidate(CXOverloadCandidateSet CS, CXDecl F,
                                               bool Reversed) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->isNewCandidate(
      static_cast<clang::Decl *>(F), Reversed ? clang::OverloadCandidateParamOrder::Reversed
                                              : clang::OverloadCandidateParamOrder::Normal);
}

void clang_OverloadCandidateSet_exclude(CXOverloadCandidateSet CS, CXDecl F) {
  static_cast<clang::OverloadCandidateSet *>(CS)->exclude(static_cast<clang::Decl *>(F));
}

void clang_OverloadCandidateSet_clear(CXOverloadCandidateSet CS,
                                      CXOverloadCandidateSet_CandidateSetKind CSK) {
  static_cast<clang::OverloadCandidateSet *>(CS)->clear(
      static_cast<clang::OverloadCandidateSet::CandidateSetKind>(CSK));
}

size_t clang_OverloadCandidateSet_size(CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->size();
}

bool clang_OverloadCandidateSet_empty(CXOverloadCandidateSet CS) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->empty();
}

CXOverloadCandidate clang_OverloadCandidateSet_getCandidate(CXOverloadCandidateSet CS,
                                                            unsigned I) {
  return static_cast<clang::OverloadCandidateSet *>(CS)->begin() + I;
}

void clang_OverloadCandidateSet_allocateConversionSequences(
    CXOverloadCandidateSet CS, unsigned NumConversions, CXImplicitConversionSequence *Out) {
  clang::ConversionSequenceList Seqs =
      static_cast<clang::OverloadCandidateSet *>(CS)->allocateConversionSequences(
          NumConversions);
  for (unsigned I = 0; I < NumConversions; ++I)
    Out[I] = Seqs.data() + I;
}

CXOverloadCandidate clang_OverloadCandidateSet_addCandidate(CXOverloadCandidateSet CS,
                                                            unsigned NumConversions) {
  clang::OverloadCandidate &C =
      static_cast<clang::OverloadCandidateSet *>(CS)->addCandidate(NumConversions);
  // clang leaves these indeterminate for Sema's Add*Candidate paths to fill in, and
  // destroyCandidates reads Viable and FailureKind when the set is cleared or disposed.
  C.Function = nullptr;
  C.Surrogate = nullptr;
  C.Viable = true;
  C.Best = false;
  C.IgnoreObjectArgument = false;
  C.FailureKind = clang::ovl_fail_bad_conversion;
  C.ExplicitCallArguments = NumConversions;
  return &C;
}

CXOverloadingResult clang_OverloadCandidateSet_BestViableFunction(
    CXOverloadCandidateSet CS, CXSema S, CXSourceLocation_ Loc, CXOverloadCandidate *Best) {
  auto *Set = static_cast<clang::OverloadCandidateSet *>(CS);
  clang::OverloadCandidateSet::iterator It = Set->end();
  clang::OverloadingResult R = Set->BestViableFunction(
      *static_cast<clang::Sema *>(S), clang::SourceLocation::getFromPtrEncoding(Loc), It);
  // clang parks the iterator at end() on the outcomes that select nothing; that pointer is
  // one past the candidate vector, so it never leaves this shim.
  *Best = It == Set->end() ? nullptr : It;
  return static_cast<CXOverloadingResult>(R);
}

unsigned clang_OverloadCandidateSet_CompleteCandidates(CXOverloadCandidateSet CS, CXSema S,
                                                       CXOverloadCandidateDisplayKind OCD,
                                                       const CXExpr *Args, unsigned NumArgs,
                                                       CXSourceLocation_ OpLoc,
                                                       CXOverloadCandidate *Out,
                                                       unsigned OutSize) {
  llvm::SmallVector<clang::Expr *, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(static_cast<clang::Expr *>(Args[I]));
  llvm::SmallVector<clang::OverloadCandidate *, 32> Cands =
      static_cast<clang::OverloadCandidateSet *>(CS)->CompleteCandidates(
          *static_cast<clang::Sema *>(S),
          static_cast<clang::OverloadCandidateDisplayKind>(OCD), ArgVec,
          clang::SourceLocation::getFromPtrEncoding(OpLoc));
  unsigned Total = static_cast<unsigned>(Cands.size());
  if (Out) {
    unsigned N = Total < OutSize ? Total : OutSize;
    for (unsigned I = 0; I < N; ++I)
      Out[I] = Cands[I];
  }
  return Total;
}

CXLangAS clang_OverloadCandidateSet_getDestAS(CXOverloadCandidateSet CS) {
  return static_cast<CXLangAS>(static_cast<clang::OverloadCandidateSet *>(CS)->getDestAS());
}

void clang_OverloadCandidateSet_setDestAS(CXOverloadCandidateSet CS, CXLangAS AS) {
  static_cast<clang::OverloadCandidateSet *>(CS)->setDestAS(static_cast<clang::LangAS>(AS));
}
