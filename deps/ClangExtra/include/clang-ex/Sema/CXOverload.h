#ifndef LLVM_CLANG_C_EXTRA_CXOVERLOAD_H
#define LLVM_CLANG_C_EXTRA_CXOVERLOAD_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXOperatorKinds.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// ImplicitConversionRank -- the rank of an implicit conversion kind. Smaller ranks are
// better conversion sequences.
typedef enum CXImplicitConversionRank {
  CXImplicitConversionRank_ICR_Exact_Match = 0,
  CXImplicitConversionRank_ICR_HLSL_Scalar_Widening,
  CXImplicitConversionRank_ICR_Promotion,
  CXImplicitConversionRank_ICR_HLSL_Scalar_Widening_Promotion,
  CXImplicitConversionRank_ICR_Conversion,
  CXImplicitConversionRank_ICR_OCL_Scalar_Widening,
  CXImplicitConversionRank_ICR_HLSL_Scalar_Widening_Conversion,
  CXImplicitConversionRank_ICR_Complex_Real_Conversion,
  CXImplicitConversionRank_ICR_Writeback_Conversion,
  CXImplicitConversionRank_ICR_C_Conversion,
  CXImplicitConversionRank_ICR_C_Conversion_Extension,
  CXImplicitConversionRank_ICR_HLSL_Dimension_Reduction,
  CXImplicitConversionRank_ICR_HLSL_Dimension_Reduction_Promotion,
  CXImplicitConversionRank_ICR_HLSL_Dimension_Reduction_Conversion
} CXImplicitConversionRank;

// NarrowingKind -- the kind of narrowing a standard conversion sequence performs, per
// C++11 [dcl.init.list]p7.
typedef enum CXNarrowingKind {
  CXNarrowingKind_NK_Not_Narrowing,
  CXNarrowingKind_NK_Type_Narrowing,
  CXNarrowingKind_NK_Constant_Narrowing,
  CXNarrowingKind_NK_Variable_Narrowing,
  CXNarrowingKind_NK_Dependent_Narrowing
} CXNarrowingKind;

// StandardConversionSequence
//
// A CXStandardConversionSequence is a borrowed interior pointer into the
// ImplicitConversionSequence that owns it (its `Standard` union arm). It stays valid
// only while that sequence is alive and while the sequence's kind is still
// StandardConversion; it has no dispose of its own.

// setFromType
// setToType
// setAllToTypes

void clang_StandardConversionSequence_setFromType(CXStandardConversionSequence SCS,
                                                  CXQualType T);

// Idx must be < 3 -- the C++ method asserts on it.
void clang_StandardConversionSequence_setToType(CXStandardConversionSequence SCS,
                                                unsigned Idx, CXQualType T);

void clang_StandardConversionSequence_setAllToTypes(CXStandardConversionSequence SCS,
                                                    CXQualType T);

CXQualType clang_StandardConversionSequence_getFromType(CXStandardConversionSequence SCS);

// Idx must be < 3 -- the C++ method asserts on it.
CXQualType clang_StandardConversionSequence_getToType(CXStandardConversionSequence SCS,
                                                      unsigned Idx);


// Resets the three conversion kinds to ICK_Identity and clears the binding flags. It does
// NOT touch the from/to types.
void clang_StandardConversionSequence_setAsIdentityConversion(
    CXStandardConversionSequence SCS);

bool clang_StandardConversionSequence_isIdentityConversion(
    CXStandardConversionSequence SCS);


// Reads only the three ImplicitConversionKind fields. Every sequence reachable through
// clang_ImplicitConversionSequence_getStandard has them, because the owning sequence's
// constructor runs setAsIdentityConversion on the Standard arm.
CXImplicitConversionRank
clang_StandardConversionSequence_getRank(CXStandardConversionSequence SCS);
// getNarrowingKind
// isPointerConversionToBool
// isPointerConversionToVoidPointer
CXNarrowingKind clang_StandardConversionSequence_getNarrowingKind(
    CXStandardConversionSequence SCS, CXASTContext Ctx, CXExpr Converted,
    CXAPValue ConstantValue, CXQualType *ConstantType,
    bool IgnoreFloatToIntegralConversion);

// Classifies the narrowing this sequence performs on Converted. ConstantValue is an in/out
// box -- clang overwrites it with the source constant on the NK_Constant_Narrowing outcome
// -- and the narrowed destination type is written through ConstantType, which is left null
// on every outcome that records none.
//
// Two preconditions. Ctx must be a C++ context: the C++ method opens with
// assert(Ctx.getLangOpts().CPlusPlus). And this sequence's to-types must already be set --
// the method reads getToType(0) and dereferences getToType(1), so the indeterminate
// to-types of a sequence no setter has touched are UB, exactly as for the two
// isPointerConversion* predicates below.

// Both of these read the sequence's from- and to-types, which have no default initializer.
// They are written by setFromType/setToType/setAllToTypes, or wholesale by
// clang_ImplicitConversionSequence_setAsIdentityConversion; calling either predicate before
// that reads indeterminate pointers. No flag records whether the types have been set, so
// the Julia wrapper documents the precondition instead of asserting it.
bool clang_StandardConversionSequence_isPointerConversionToBool(
    CXStandardConversionSequence SCS);

bool clang_StandardConversionSequence_isPointerConversionToVoidPointer(
    CXStandardConversionSequence SCS, CXASTContext Ctx);

// Writes a one-line description of the three conversion kinds to llvm::errs(). It reads
// only those kinds and the binding flags, which
// clang_StandardConversionSequence_setAsIdentityConversion establishes; on the Before/After
// arms of a user-defined sequence they stay indeterminate until it has run.
void clang_StandardConversionSequence_dump(CXStandardConversionSequence SCS);

// UserDefinedConversionSequence
//
// A CXUserDefinedConversionSequence is a borrowed interior pointer into the
// ImplicitConversionSequence that owns it (its `UserDefined` union arm). It stays valid
// only while that sequence's kind is still UserDefinedConversion; it has no dispose of its
// own.
//
// Every member of the struct is raw storage with no default initializer, and
// clang_ImplicitConversionSequence_setUserDefined only changes the kind -- it does not
// touch the arm. Sema fills the arm during overload resolution; a caller building one by
// hand must run the setters below, plus
// clang_StandardConversionSequence_setAsIdentityConversion on both getBefore and getAfter,
// before any getter or dump reads it. No flag records whether that has happened.

// helper -- the `Before` member, the standard conversion applied ahead of the user-defined
// one. A borrowed interior pointer, valid for as long as the arm is.
CXStandardConversionSequence
clang_UserDefinedConversionSequence_getBefore(CXUserDefinedConversionSequence UDCS);

// helper -- the `After` member, the standard conversion applied after the user-defined one.
CXStandardConversionSequence
clang_UserDefinedConversionSequence_getAfter(CXUserDefinedConversionSequence UDCS);

// helper -- the `EllipsisConversion` bit. When set the sequence starts with an ellipsis
// conversion and the Before arm carries no meaning.
bool clang_UserDefinedConversionSequence_getEllipsisConversion(
    CXUserDefinedConversionSequence UDCS);

void clang_UserDefinedConversionSequence_setEllipsisConversion(
    CXUserDefinedConversionSequence UDCS, bool V);

// helper -- the `HadMultipleCandidates` bit, set when the conversion function came out of
// an overload set with more than one member.
bool clang_UserDefinedConversionSequence_getHadMultipleCandidates(
    CXUserDefinedConversionSequence UDCS);

void clang_UserDefinedConversionSequence_setHadMultipleCandidates(
    CXUserDefinedConversionSequence UDCS, bool V);

// helper -- the `ConversionFunction` member. Null when the conversion is an aggregate
// initialization from an initializer list.
CXFunctionDecl clang_UserDefinedConversionSequence_getConversionFunction(
    CXUserDefinedConversionSequence UDCS);

void clang_UserDefinedConversionSequence_setConversionFunction(
    CXUserDefinedConversionSequence UDCS, CXFunctionDecl FD);

// Writes the sequence to llvm::errs(). It reads the Before and After conversion kinds and
// the conversion function, so the arm must have been filled first.
void clang_UserDefinedConversionSequence_dump(CXUserDefinedConversionSequence UDCS);

// AmbiguousConversionSequence
//
// A CXAmbiguousConversionSequence is a borrowed interior pointer into the
// ImplicitConversionSequence that owns it (its `Ambiguous` union arm). It stays valid only
// while that sequence's kind is still AmbiguousConversion; the next kind change destroys
// the conversion set with it, and it has no dispose of its own.

// The from- and to-types are raw `void *` members with no default initializer:
// ImplicitConversionSequence::setAmbiguous constructs the conversion set but leaves both
// pointers indeterminate, so reading either before the matching setter runs reads
// indeterminate memory. No flag records whether they have been set.
CXQualType clang_AmbiguousConversionSequence_getFromType(CXAmbiguousConversionSequence ACS);

CXQualType clang_AmbiguousConversionSequence_getToType(CXAmbiguousConversionSequence ACS);

void clang_AmbiguousConversionSequence_setFromType(CXAmbiguousConversionSequence ACS,
                                                   CXQualType T);

void clang_AmbiguousConversionSequence_setToType(CXAmbiguousConversionSequence ACS,
                                                 CXQualType T);

// conversions / begin / end -- the set is a SmallVector of (found declaration, function)
// pairs, exposed as a count plus one index accessor per component. The count is exact, no
// slot is null, and both accessors require I < getNumConversions. addConversion appends one
// pair and may reallocate the set's storage.
void clang_AmbiguousConversionSequence_addConversion(CXAmbiguousConversionSequence ACS,
                                                     CXNamedDecl Found, CXFunctionDecl D);

unsigned
clang_AmbiguousConversionSequence_getNumConversions(CXAmbiguousConversionSequence ACS);

CXNamedDecl
clang_AmbiguousConversionSequence_getConversionFound(CXAmbiguousConversionSequence ACS,
                                                     unsigned I);

CXFunctionDecl
clang_AmbiguousConversionSequence_getConversionFunction(CXAmbiguousConversionSequence ACS,
                                                        unsigned I);
// construct
// destruct
// copyFrom

// Constructs the conversion set in the arm's raw buffer.
// clang_ImplicitConversionSequence_setAmbiguous already does this, so running it on a live
// set leaks that set's heap storage; it exists to pair with destruct.
void clang_AmbiguousConversionSequence_construct(CXAmbiguousConversionSequence ACS);

// Destroys the conversion set. The set must be live, and nothing may read it afterwards --
// neither a getter, nor the owning sequence's next kind change, nor its dispose, each of
// which would destroy it a second time. Follow this with construct or copyFrom.
void clang_AmbiguousConversionSequence_destruct(CXAmbiguousConversionSequence ACS);

// Copies Other's from-type, to-type and conversion set into this arm. The C++ method
// constructs the set in place rather than assigning to it -- it is what
// ImplicitConversionSequence's copy constructor calls on freshly allocated storage -- so
// this arm's set must NOT be live: run destruct first. Other's set must be live and both of
// its types must have been set.
void clang_AmbiguousConversionSequence_copyFrom(CXAmbiguousConversionSequence ACS,
                                                CXAmbiguousConversionSequence Other);

// BadConversionSequence

typedef enum CXBadConversionSequence_FailureKind {
  CXBadConversionSequence_no_conversion,
  CXBadConversionSequence_unrelated_class,
  CXBadConversionSequence_bad_qualifiers,
  CXBadConversionSequence_lvalue_ref_to_rvalue,
  CXBadConversionSequence_rvalue_ref_to_lvalue,
  CXBadConversionSequence_too_few_initializers,
  CXBadConversionSequence_too_many_initializers
} CXBadConversionSequence_FailureKind;

// init

// The Expr overload of init: it sets the failure kind, records From as the source
// expression and takes the from-type from it. From must be non-null -- the C++ method reads
// From->getType(). The QualType overload is reached through
// clang_ImplicitConversionSequence_setBad.
void clang_BadConversionSequence_init(CXBadConversionSequence BCS,
                                      CXBadConversionSequence_FailureKind K, CXExpr From,
                                      CXQualType To);

// A CXBadConversionSequence is a borrowed interior pointer into the
// ImplicitConversionSequence that owns it (its `Bad` union arm), valid only while that
// sequence's kind is still BadConversion.
CXQualType clang_BadConversionSequence_getFromType(CXBadConversionSequence BCS);

CXQualType clang_BadConversionSequence_getToType(CXBadConversionSequence BCS);

// helper -- the public `Kind` member. Every path that turns an ImplicitConversionSequence
// into a BadConversion runs BadConversionSequence::init, so the member is always live on a
// sequence obtained from clang_ImplicitConversionSequence_getBad.
CXBadConversionSequence_FailureKind
clang_BadConversionSequence_getFailureKind(CXBadConversionSequence BCS);

// helper -- the public `FromExpr` member. Null when the failure records no source
// expression, which is the case for an implicit object argument and for any sequence built
// from types alone.
CXExpr clang_BadConversionSequence_getFromExpr(CXBadConversionSequence BCS);

// setFromExpr
// setFromType
// setToType

// E must be non-null: the C++ method reads E->getType() to set the from-type.
void clang_BadConversionSequence_setFromExpr(CXBadConversionSequence BCS, CXExpr E);

void clang_BadConversionSequence_setFromType(CXBadConversionSequence BCS, CXQualType T);

void clang_BadConversionSequence_setToType(CXBadConversionSequence BCS, CXQualType T);

// ImplicitConversionSequence

typedef enum CXImplicitConversionSequence_Kind {
  CXImplicitConversionSequence_StandardConversion = 0,
  CXImplicitConversionSequence_StaticObjectArgumentConversion,
  CXImplicitConversionSequence_UserDefinedConversion,
  CXImplicitConversionSequence_AmbiguousConversion,
  CXImplicitConversionSequence_EllipsisConversion,
  CXImplicitConversionSequence_BadConversion
} CXImplicitConversionSequence_Kind;

// An ImplicitConversionSequence is a by-value C++ object with no pointer encoding, so
// it is heap-boxed here and the box is caller-owned. A freshly created sequence is
// *uninitialized*: its kind is the private Uninitialized sentinel, which is outside
// CXImplicitConversionSequence_Kind, and every kind query below asserts against it.
CXImplicitConversionSequence clang_ImplicitConversionSequence_create(void);

void clang_ImplicitConversionSequence_dispose(CXImplicitConversionSequence ICS);

// Asserts isInitialized().
CXImplicitConversionSequence_Kind
clang_ImplicitConversionSequence_getKind(CXImplicitConversionSequence ICS);

// Asserts isInitialized() (it reads getKind()). Smaller ranks are better sequences.
unsigned clang_ImplicitConversionSequence_getKindRank(CXImplicitConversionSequence ICS);

// helper -- the `Standard` union arm; reading it is only defined when the kind is
// StandardConversion.
CXStandardConversionSequence
clang_ImplicitConversionSequence_getStandard(CXImplicitConversionSequence ICS);

// helper -- the `Bad` union arm; reading it is only defined when the kind is
// BadConversion.
CXBadConversionSequence
clang_ImplicitConversionSequence_getBad(CXImplicitConversionSequence ICS);

// helper -- the `Ambiguous` union arm; reading it is only defined when the kind is
// AmbiguousConversion, which is also what guarantees its conversion set is constructed.
CXAmbiguousConversionSequence
clang_ImplicitConversionSequence_getAmbiguous(CXImplicitConversionSequence ICS);

// helper -- the `UserDefined` union arm; reading it is only defined when the kind is
// UserDefinedConversion. Unlike the ambiguous arm, switching to that kind does NOT
// initialise the arm -- see the CXUserDefinedConversionSequence comment above.
CXUserDefinedConversionSequence
clang_ImplicitConversionSequence_getUserDefined(CXImplicitConversionSequence ICS);

// isBad
// isStandard
// isStaticObjectArgument
// isEllipsis
// isAmbiguous
// isUserDefined
// isFailure

bool clang_ImplicitConversionSequence_isInitialized(CXImplicitConversionSequence ICS);

// The implicit-argument overload of setBad, taking the source type rather than the
// source expression.
void clang_ImplicitConversionSequence_setBad(CXImplicitConversionSequence ICS,
                                             CXBadConversionSequence_FailureKind Failure,
                                             CXQualType FromType, CXQualType ToType);

// setStandard
// setStaticObjectArgument

// Makes this a StandardConversion without touching the Standard arm's payload, which keeps
// whatever it last held.
void clang_ImplicitConversionSequence_setStandard(CXImplicitConversionSequence ICS);

void clang_ImplicitConversionSequence_setStaticObjectArgument(
    CXImplicitConversionSequence ICS);

void clang_ImplicitConversionSequence_setEllipsis(CXImplicitConversionSequence ICS);

// Makes this a UserDefinedConversion without touching the UserDefined arm's payload, which
// this shim exposes no accessor for; the arm keeps whatever it last held.
void clang_ImplicitConversionSequence_setUserDefined(CXImplicitConversionSequence ICS);

// setUserDefined

// Makes this an AmbiguousConversion and constructs its (empty) conversion set in place. The
// set is destroyed by clang_ImplicitConversionSequence_dispose or by the next kind change.
void clang_ImplicitConversionSequence_setAmbiguous(CXImplicitConversionSequence ICS);

// Makes this a StandardConversion whose standard sequence is the identity conversion
// from T to T.
void clang_ImplicitConversionSequence_setAsIdentityConversion(
    CXImplicitConversionSequence ICS, CXQualType T);

bool clang_ImplicitConversionSequence_hasInitializerListContainerType(
    CXImplicitConversionSequence ICS);

void clang_ImplicitConversionSequence_setInitializerListContainerType(
    CXImplicitConversionSequence ICS, CXQualType T, bool IncompleteArray);

bool clang_ImplicitConversionSequence_isInitializerListOfIncompleteArray(
    CXImplicitConversionSequence ICS);

// Asserts hasInitializerListContainerType().
CXQualType clang_ImplicitConversionSequence_getInitializerListContainerType(
    CXImplicitConversionSequence ICS);


// Forms the implicit conversion sequence from nullptr_t to bool used when
// direct-initializing a bool object. A static member function, so it takes no receiver; the
// sequence it returns is a fresh heap-boxed value the caller owns and must release with
// clang_ImplicitConversionSequence_dispose.
CXImplicitConversionSequence
clang_ImplicitConversionSequence_getNullptrToBool(CXQualType SourceType,
                                                  CXQualType DestType, bool NeedLValToRVal);
// DiagnoseAmbiguousConversion

// Writes the sequence to llvm::errs(). Every kind but UserDefinedConversion prints from
// state this shim guarantees; for UserDefinedConversion it dumps the UserDefined arm, whose
// members stay indeterminate until a caller fills them. Nothing records whether that has
// happened, so the Julia wrapper documents that case instead of asserting it.
void clang_ImplicitConversionSequence_dump(CXImplicitConversionSequence ICS);

// OverloadCandidate

// The kinds of rewrite performed on an overload candidate. The values are bit flags as well
// as a rank, so a candidate rewritten both ways carries CRK_DifferentOperator |
// CRK_Reversed -- a combination that is not itself an enumerator.
typedef enum CXOverloadCandidateRewriteKind : unsigned {
  CXOverloadCandidateRewriteKind_CRK_None = 0x0,
  CXOverloadCandidateRewriteKind_CRK_DifferentOperator = 0x1,
  CXOverloadCandidateRewriteKind_CRK_Reversed = 0x2
} CXOverloadCandidateRewriteKind;

// A CXOverloadCandidate is a borrowed interior pointer into the OverloadCandidateSet that
// owns it, and the candidate vector is contiguous:
// clang_OverloadCandidateSet_addCandidate may reallocate it, so every handle taken from the
// set before an add dangles afterwards, and clear/dispose destroy them all. It has no
// dispose of its own.

CXOverloadCandidateRewriteKind
clang_OverloadCandidate_getRewriteKind(CXOverloadCandidate C);

bool clang_OverloadCandidate_isReversed(CXOverloadCandidate C);

// Scans the argument conversions and stops at the first uninitialized one, so a candidate
// whose conversions have not been resolved reports false.
bool clang_OverloadCandidate_hasAmbiguousConversion(CXOverloadCandidate C);

// Asks clang whether the bad conversion at index Idx can be repaired by a fix-it, recording
// the hints on the candidate when it can. It reads that conversion's `Bad` union arm
// directly with no kind check, so the conversion at Idx must already be a BadConversion,
// and Idx must be < clang_OverloadCandidate_getNumConversions.
bool clang_OverloadCandidate_TryToFixBadConversion(CXOverloadCandidate C, unsigned Idx,
                                                   CXSema S);

// Reads the Surrogate's conversion type when the candidate is a surrogate (reaching a
// FunctionProtoType through castAs<>), the Function's parameter count when a Function is
// set, and the recorded argument count otherwise. A candidate from
// clang_OverloadCandidateSet_addCandidate is neither, so it reports the conversion-slot
// count that add call asked for.
unsigned clang_OverloadCandidate_getNumParams(CXOverloadCandidate C);

bool clang_OverloadCandidate_NotValidBecauseConstraintExprHasError(CXOverloadCandidate C);

// helper -- the public `Conversions` member, the argument-indexed conversion sequences,
// exposed as a count + index pair. getConversion requires I < getNumConversions and returns
// a borrowed interior pointer into the owning set's slab storage: it must never reach
// clang_ImplicitConversionSequence_dispose.
unsigned clang_OverloadCandidate_getNumConversions(CXOverloadCandidate C);

CXImplicitConversionSequence clang_OverloadCandidate_getConversion(CXOverloadCandidate C,
                                                                   unsigned I);

// helper -- the remaining public members of the candidate. Every CXOverloadCandidate a
// caller can hold points into a set's candidate vector, so it came out of
// clang_OverloadCandidateSet_addCandidate, which writes Function, Surrogate, Viable, Best,
// IgnoreObjectArgument and ExplicitCallArguments on top of the IsSurrogate clang's own
// (private) constructor initialises. None of these reads indeterminate storage.

// The function this candidate stands for. Null on a built-in candidate, on a surrogate for
// a conversion to function pointer or reference, and on every candidate addCandidate
// builds.
CXFunctionDecl clang_OverloadCandidate_getFunction(CXOverloadCandidate C);

// The conversion function this candidate is a surrogate for. Only meaningful when
// clang_OverloadCandidate_isSurrogate is true; addCandidate writes null.
CXCXXConversionDecl clang_OverloadCandidate_getSurrogate(CXOverloadCandidate C);

// Whether this candidate is viable. addCandidate builds viable candidates.
bool clang_OverloadCandidate_getViable(CXOverloadCandidate C);

// Whether this candidate is the best viable function, or tied for it. Overload resolution
// writes the flag, so every candidate of a set BestViableFunction has not yet run over
// reports false.
bool clang_OverloadCandidate_getBest(CXOverloadCandidate C);

// Whether this candidate is a surrogate for a conversion to function pointer or reference.
bool clang_OverloadCandidate_isSurrogate(CXOverloadCandidate C);

// Whether the first argument's conversion -- the implicit object argument -- is to be
// ignored. addCandidate writes false.
bool clang_OverloadCandidate_getIgnoreObjectArgument(CXOverloadCandidate C);

// The number of call arguments explicitly provided at the call site. addCandidate writes
// the conversion-slot count it was asked for.
unsigned clang_OverloadCandidate_getExplicitCallArguments(CXOverloadCandidate C);

// OverloadCandidateSet

typedef enum CXOverloadCandidateSet_CandidateSetKind {
  CXOverloadCandidateSet_CSK_Normal,
  CXOverloadCandidateSet_CSK_Operator,
  CXOverloadCandidateSet_CSK_InitByUserDefinedConversion,
  CXOverloadCandidateSet_CSK_InitByConstructor
} CXOverloadCandidateSet_CandidateSetKind;

// An OverloadCandidateSet owns its candidates and the conversion sequences it slab-
// allocates for them, so the box is caller-owned and everything it holds dies with it.
// The set is created with the default (empty) OperatorRewriteInfo.
CXOverloadCandidateSet
clang_OverloadCandidateSet_create(CXSourceLocation_ Loc,
                                  CXOverloadCandidateSet_CandidateSetKind CSK);

void clang_OverloadCandidateSet_dispose(CXOverloadCandidateSet CS);

// The same create with an explicit OperatorRewriteInfo, which clang_OverloadCandidateSet_-
// create leaves at its default (OO_None, invalid location, no rewritten candidates). The
// box is caller-owned exactly as it is there.
CXOverloadCandidateSet clang_OverloadCandidateSet_createWithRewriteInfo(
    CXSourceLocation_ Loc, CXOverloadCandidateSet_CandidateSetKind CSK,
    CXOverloadedOperatorKind Op, CXSourceLocation_ OpLoc, bool AllowRewritten);

CXSourceLocation_ clang_OverloadCandidateSet_getLocation(CXOverloadCandidateSet CS);

CXOverloadCandidateSet_CandidateSetKind
clang_OverloadCandidateSet_getKind(CXOverloadCandidateSet CS);

// getRewriteInfo
// shouldDeferDiags
// isNewCandidate
// exclude

// getRewriteInfo returns an OperatorRewriteInfo by value, so its three fields cross
// separately rather than as an aggregate.
CXOverloadedOperatorKind
clang_OverloadCandidateSet_getRewriteInfoOriginalOperator(CXOverloadCandidateSet CS);

CXSourceLocation_ clang_OverloadCandidateSet_getRewriteInfoOpLoc(CXOverloadCandidateSet CS);

bool clang_OverloadCandidateSet_getRewriteInfoAllowRewrittenCandidates(
    CXOverloadCandidateSet CS);

// The OperatorRewriteInfo predicates. RewriteInfo is a private member of the set, reached
// here through getRewriteInfo(), which hands out a copy by value; none of these five writes
// to it, so running them against the copy is equivalent to running them against the member.
// FD is passed through unchecked -- clang dereferences it whenever the set carries an
// original operator.

// Whether a candidate for FD would be a rewrite using a *different* operator than the one
// this set was built for. Always false on a set whose rewrite info has no original
// operator, which is what clang_OverloadCandidateSet_create leaves behind.
bool clang_OverloadCandidateSet_rewriteInfoIsRewrittenOperator(CXOverloadCandidateSet CS,
                                                               CXFunctionDecl FD);

// Whether FD is one of the candidates this set is supposed to consider. Always true on a
// set with no original operator; otherwise FD must name that operator, or -- when the set
// allows rewritten candidates -- the operator that rewrites to it.
bool clang_OverloadCandidateSet_rewriteInfoIsAcceptableCandidate(CXOverloadCandidateSet CS,
                                                                 CXFunctionDecl FD);

// The rewrite kind a candidate for FD would carry in the reversed or the normal parameter
// order. The result is a bitmask as well as a rank, so a candidate that is both a different
// operator and reversed comes back as CRK_DifferentOperator | CRK_Reversed, which is not
// itself an enumerator.
CXOverloadCandidateRewriteKind
clang_OverloadCandidateSet_rewriteInfoGetRewriteKind(CXOverloadCandidateSet CS,
                                                     CXFunctionDecl FD, bool Reversed);

// Whether the operator this set was built for could be implemented by a function with
// reversed parameter order. False whenever the set does not allow rewritten candidates.
bool clang_OverloadCandidateSet_rewriteInfoIsReversible(CXOverloadCandidateSet CS);

// Whether reversing parameter order is allowed for Op, judged against this set's rewrite
// info.
bool clang_OverloadCandidateSet_rewriteInfoAllowsReversed(CXOverloadCandidateSet CS,
                                                          CXOverloadedOperatorKind Op);

// shouldAddReversed

// Whether diagnostics for this candidate set should be deferred. Only the CUDA/HIP
// deferred-diagnostic path answers anything but false, and that path walks both the
// candidates and the argument expressions; Args is the argument list the set was built for,
// crossing as a (buffer, count) pair.
bool clang_OverloadCandidateSet_shouldDeferDiags(CXOverloadCandidateSet CS, CXSema S,
                                                 const CXExpr *Args, unsigned NumArgs,
                                                 CXSourceLocation_ OpLoc);

// Records F -- keyed by its canonical declaration together with the parameter order -- as
// seen by this set, and returns whether it was new. Reversed selects
// OverloadCandidateParamOrder::Reversed, which is a distinct key from Normal.
bool clang_OverloadCandidateSet_isNewCandidate(CXOverloadCandidateSet CS, CXDecl F,
                                               bool Reversed);

// Marks F as seen in both parameter orders, so no later candidate for it counts as new.
void clang_OverloadCandidateSet_exclude(CXOverloadCandidateSet CS, CXDecl F);

// Destroys every candidate and releases the slab storage.
void clang_OverloadCandidateSet_clear(CXOverloadCandidateSet CS,
                                      CXOverloadCandidateSet_CandidateSetKind CSK);

// begin
// end

size_t clang_OverloadCandidateSet_size(CXOverloadCandidateSet CS);

bool clang_OverloadCandidateSet_empty(CXOverloadCandidateSet CS);

// begin / end -- the candidate vector is contiguous, so it crosses as this index accessor
// against clang_OverloadCandidateSet_size. I must be < size.
CXOverloadCandidate clang_OverloadCandidateSet_getCandidate(CXOverloadCandidateSet CS,
                                                            unsigned I);

// Appends a candidate with NumConversions freshly constructed (uninitialized) conversion
// slots and returns it.
//
// clang's OverloadCandidate constructor initialises only IsSurrogate, IsADLCandidate and
// RewriteKind and leaves Function, Surrogate, Viable, Best, IgnoreObjectArgument,
// FailureKind and ExplicitCallArguments indeterminate for Sema's Add*Candidate paths to
// fill in -- and OverloadCandidateSet::destroyCandidates reads Viable and FailureKind when
// the set is cleared or disposed. This shim therefore completes the object it hands out,
// writing the defaults of a viable non-surrogate candidate with no function and
// ExplicitCallArguments = NumConversions. FoundDecl and the
// DeductionFailure/FinalConversion union stay indeterminate; nothing this shim exposes
// reads them.
CXOverloadCandidate clang_OverloadCandidateSet_addCandidate(CXOverloadCandidateSet CS,
                                                            unsigned NumConversions);

// allocateConversionSequences
// addCandidate
// BestViableFunction
// CompleteCandidates
// NoteCandidates
// getDestAS
// setDestAS

// Slab-allocates NumConversions freshly constructed (uninitialized) conversion sequences
// out of the set and writes one borrowed interior pointer per slot into Out, which must
// have room for NumConversions handles. The storage dies with the set, so no slot may reach
// clang_ImplicitConversionSequence_dispose. Slots not handed to a candidate are never
// destructed either (destroyCandidates only walks the candidates), so do not give one the
// ambiguous kind -- its conversion set would leak.
void clang_OverloadCandidateSet_allocateConversionSequences(
    CXOverloadCandidateSet CS, unsigned NumConversions, CXImplicitConversionSequence *Out);

// OverloadingResult -- the outcome of overload resolution over a candidate set. clang
// declares it at namespace scope in clang/Sema/Overload.h; it is mirrored here, ahead of
// the only accessor that returns it.
typedef enum CXOverloadingResult {
  CXOverloadingResult_OR_Success,
  CXOverloadingResult_OR_No_Viable_Function,
  CXOverloadingResult_OR_Ambiguous,
  CXOverloadingResult_OR_Deleted
} CXOverloadingResult;

// Runs overload resolution over the set and reports the outcome. Best must be non-null; it
// receives the winning candidate, or null on the outcomes for which clang leaves its
// iterator at end() -- this shim never hands that one-past-the-end pointer across.
//
// The pass reads every candidate's viability flag and, whenever two candidates are both
// viable, compares them through their argument conversion sequences. The slots handed out
// by clang_OverloadCandidateSet_addCandidate are uninitialized, so a set holding more than
// one such candidate is UB here; the Julia wrapper asserts that every conversion of every
// candidate is initialized before it calls. Resolution also writes each candidate's
// best-so-far flag, so candidate handles stay valid but their state changes.
CXOverloadingResult clang_OverloadCandidateSet_BestViableFunction(
    CXOverloadCandidateSet CS, CXSema S, CXSourceLocation_ Loc, CXOverloadCandidate *Best);

// OverloadCandidateDisplayKind -- which of a set's candidates a diagnostic would list.
// clang declares it at namespace scope in clang/Sema/Overload.h; it is mirrored here,
// ahead of the only accessor that takes it.
typedef enum CXOverloadCandidateDisplayKind {
  CXOverloadCandidateDisplayKind_OCD_AllCandidates,
  CXOverloadCandidateDisplayKind_OCD_ViableCandidates,
  CXOverloadCandidateDisplayKind_OCD_AmbiguousCandidates
} CXOverloadCandidateDisplayKind;

// Selects the candidates a diagnostic over this set would list and orders them the way
// clang would print them, emitting nothing. Returns how many were selected -- never more
// than clang_OverloadCandidateSet_size -- and, when Out is non-null, writes the first
// min(count, OutSize) of them there. The handles borrow the set's candidate vector just
// as clang_OverloadCandidateSet_getCandidate's do.
//
// The walk is not read-only. On CXOverloadCandidateDisplayKind_OCD_AllCandidates clang
// completes every non-viable candidate that has a function or is a surrogate, redoing
// that candidate's argument conversions against Args -- so Args must be the argument list
// the set was built for, crossing as a (buffer, count) pair. It then display-sorts the
// selection, and the comparator reads two candidates' argument conversion sequences
// whenever it has two to order. The slots addCandidate hands out are uninitialized, so a
// set holding more than one such candidate is UB here exactly as it is for
// clang_OverloadCandidateSet_BestViableFunction; the Julia wrapper asserts the same
// precondition. The C++ method's trailing per-candidate filter is a function_ref and
// does not cross the boundary: this is its unfiltered form.
unsigned clang_OverloadCandidateSet_CompleteCandidates(CXOverloadCandidateSet CS, CXSema S,
                                                       CXOverloadCandidateDisplayKind OCD,
                                                       const CXExpr *Args, unsigned NumArgs,
                                                       CXSourceLocation_ OpLoc,
                                                       CXOverloadCandidate *Out,
                                                       unsigned OutSize);

CXLangAS clang_OverloadCandidateSet_getDestAS(CXOverloadCandidateSet CS);

// The C++ method asserts the set's kind is CSK_InitByConstructor or
// CSK_InitByUserDefinedConversion.
void clang_OverloadCandidateSet_setDestAS(CXOverloadCandidateSet CS, CXLangAS AS);

LLVM_CLANG_C_EXTERN_C_END

#endif
