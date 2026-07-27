#ifndef LLVM_CLANG_C_EXTRA_CXTYPE_H
#define LLVM_CLANG_C_EXTRA_CXTYPE_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXExceptionSpecificationType.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

#include "clang-ex/Basic/CXLinkage.h"
#include "clang-ex/Basic/CXVisibility.h"
#include "clang-ex/AST/CXAttr.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The Type classification surface below is stamped from the vendored
// clang-ex/AST/TypeNodes.inc (a verbatim copy of clang's TableGen output for
// the pinned LLVM version). Mirror-by-construction: the same table clang uses
// to build clang::Type::TypeClass builds CXTypeClass here, and the impl-side
// static_assert table in CXType.cpp proves value-for-value equality (plus a
// TypeLast count assert), so a stale vendored copy fails the build. POLICY:
// stamped symbols (CXTypeClass_* and the castTo family) are version-following
// per LLVM major, exempt from the frozen-ABI rule. Named CXTypeClass (not
// CXTypeKind) to avoid the libclang collision. The classification predicates
// live in the separate clang_isa_<Class>Type family; only downcasts are stamped
// here (clang_Type_is<Class>Type is reserved for clang's sugar-piercing
// semantic queries, which mean something different from isa).
typedef enum CXTypeClass {
#define TYPE(Class, Base) CXTypeClass_##Class,
#define ABSTRACT_TYPE(Class, Base)
#define LAST_TYPE(Class) CXTypeClass_TypeLast = CXTypeClass_##Class
#include "clang-ex/AST/TypeNodes.inc"
} CXTypeClass;

// Null-safe downcast for every class in the hierarchy, ABSTRACT bases included.
// The wrapper name carries the full class spelling (TypeNodes name + "Type").
#define TYPE(Class, Base) CXType_ clang_Type_castTo##Class##Type(CXType_ T);
#include "clang-ex/AST/TypeNodes.inc"

CXTypeClass clang_Type_getTypeClass(CXType_ T);

// Qualifiers
// The Qualifiers value type has no handle of its own: it crosses as the opaque
// unsigned encoding of MARSHALLING.md §7 — the same encoding
// clang_QualType_getQualifiersAsOpaqueValue and clang_FunctionProtoType_getMethodQuals
// return. Every wrapper below rebuilds its receiver with
// Qualifiers::fromOpaqueValue and re-serialises a Qualifiers result with
// getAsOpaqueValue, so nothing is allocated and nothing needs disposing.

// Static: the common qualifier set of two sets. L and R are in-out — on return
// each holds its own set with the common qualifiers stripped — and the return
// value is the common set. All three cross as opaque unsigned encodings.
unsigned clang_Qualifiers_removeCommonQualifiers(unsigned *L, unsigned *R);

// Precondition: Mask holds only fast-qualifier bits (const/volatile/restrict,
// mask 0x7); Qualifiers::addFastQualifiers asserts on anything wider.
unsigned clang_Qualifiers_fromFastMask(unsigned Mask);

// Precondition: CVR holds only const/volatile/restrict bits (mask 0x7);
// Qualifiers::addCVRQualifiers asserts on anything wider.
unsigned clang_Qualifiers_fromCVRMask(unsigned CVR);

// Precondition: CVRU holds only const/volatile/restrict/unaligned bits (mask
// 0xF); Qualifiers::addCVRUQualifiers asserts on anything wider.
unsigned clang_Qualifiers_fromCVRUMask(unsigned CVRU);

bool clang_Qualifiers_hasConst(unsigned Quals);
bool clang_Qualifiers_hasOnlyConst(unsigned Quals);
unsigned clang_Qualifiers_withConst(unsigned Quals);
unsigned clang_Qualifiers_removeConst(unsigned Quals);

bool clang_Qualifiers_hasVolatile(unsigned Quals);
bool clang_Qualifiers_hasOnlyVolatile(unsigned Quals);
unsigned clang_Qualifiers_withVolatile(unsigned Quals);
unsigned clang_Qualifiers_removeVolatile(unsigned Quals);

bool clang_Qualifiers_hasRestrict(unsigned Quals);
bool clang_Qualifiers_hasOnlyRestrict(unsigned Quals);
unsigned clang_Qualifiers_withRestrict(unsigned Quals);
unsigned clang_Qualifiers_removeRestrict(unsigned Quals);

bool clang_Qualifiers_hasCVRQualifiers(unsigned Quals);

unsigned clang_Qualifiers_getCVRQualifiers(unsigned Quals);

// The CVR set widened with the unaligned bit; getCVRQualifiers drops it.
unsigned clang_Qualifiers_getCVRUQualifiers(unsigned Quals);

// Precondition on the CVR mutator trio: Mask holds only const/volatile/restrict
// bits (mask 0x7); the clang methods assert on anything wider. setCVRQualifiers
// replaces the CVR set, addCVRQualifiers unions into it and removeCVRQualifiers
// subtracts from it; all three leave the non-CVR bits alone.
unsigned clang_Qualifiers_setCVRQualifiers(unsigned Quals, unsigned Mask);

unsigned clang_Qualifiers_addCVRQualifiers(unsigned Quals, unsigned Mask);

unsigned clang_Qualifiers_removeCVRQualifiers(unsigned Quals, unsigned Mask);

// Precondition: Mask holds only const/volatile/restrict/unaligned bits (mask
// 0xF); Qualifiers::addCVRUQualifiers asserts on anything wider.
unsigned clang_Qualifiers_addCVRUQualifiers(unsigned Quals, unsigned Mask);

bool clang_Qualifiers_hasUnaligned(unsigned Quals);

// Qualifiers::addUnaligned and Qualifiers::removeUnaligned are the two settings
// of this one mutator, so only the flag-taking form is wrapped.
unsigned clang_Qualifiers_setUnaligned(unsigned Quals, bool Flag);

// GC
// Mirrors clang::Qualifiers::GC -- the Objective-C garbage-collection attribute a
// qualifier set can carry. Declared here, ahead of the first accessor returning it.
typedef enum CXQualifiers_GC {
  CXQualifiers_GCNone = 0,
  CXQualifiers_Weak,
  CXQualifiers_Strong
} CXQualifiers_GC;

// ObjCLifetime
// Mirrors clang::Qualifiers::ObjCLifetime -- the ARC lifetime a qualifier set can carry.
// Declared here, ahead of the first accessor returning it.
typedef enum CXQualifiers_ObjCLifetime {
  CXQualifiers_OCL_None,
  CXQualifiers_OCL_ExplicitNone,
  CXQualifiers_OCL_Strong,
  CXQualifiers_OCL_Weak,
  CXQualifiers_OCL_Autoreleasing
} CXQualifiers_ObjCLifetime;

bool clang_Qualifiers_hasObjCGCAttr(unsigned Quals);

CXQualifiers_GC clang_Qualifiers_getObjCGCAttr(unsigned Quals);

// setObjCGCAttr replaces the GC attribute outright and CXQualifiers_GCNone clears it,
// which is exactly how Qualifiers::removeObjCGCAttr is spelled, so only the setter of that
// pair is wrapped.
unsigned clang_Qualifiers_setObjCGCAttr(unsigned Quals, CXQualifiers_GC Attr);

// PRECONDITION (Invariant 3): Attr must not be CXQualifiers_GCNone;
// Qualifiers::addObjCGCAttr asserts it. clang_Qualifiers_setObjCGCAttr is the unrestricted
// form; the Julia wrapper restates the precondition.
unsigned clang_Qualifiers_addObjCGCAttr(unsigned Quals, CXQualifiers_GC Attr);

unsigned clang_Qualifiers_withoutObjCGCAttr(unsigned Quals);

unsigned clang_Qualifiers_withoutObjCLifetime(unsigned Quals);

bool clang_Qualifiers_hasObjCLifetime(unsigned Quals);

CXQualifiers_ObjCLifetime clang_Qualifiers_getObjCLifetime(unsigned Quals);

// setObjCLifetime replaces the lifetime outright and CXQualifiers_OCL_None clears it,
// which is exactly how Qualifiers::removeObjCLifetime is spelled, so only the setter of
// that pair is wrapped.
unsigned clang_Qualifiers_setObjCLifetime(unsigned Quals,
                                          CXQualifiers_ObjCLifetime Lifetime);

// PRECONDITION (Invariant 3): Lifetime must not be CXQualifiers_OCL_None and Quals must not
// carry a lifetime already; Qualifiers::addObjCLifetime asserts both. The gate for the
// second is clang_Qualifiers_hasObjCLifetime above, clang_Qualifiers_setObjCLifetime is the
// unrestricted form, and the Julia wrapper restates both.
unsigned clang_Qualifiers_addObjCLifetime(unsigned Quals,
                                          CXQualifiers_ObjCLifetime Lifetime);

// True when the lifetime is neither OCL_None nor OCL_ExplicitNone.
bool clang_Qualifiers_hasNonTrivialObjCLifetime(unsigned Quals);

// True when the lifetime is OCL_Strong or OCL_Weak.
bool clang_Qualifiers_hasStrongOrWeakObjCLifetime(unsigned Quals);

// Whether an object qualified with Other can be used where Quals is expected, judging only
// the ObjC lifetimes: equal lifetimes match, OCL_Weak never mixes with a different
// lifetime, an OCL_None on either side is compatible, and otherwise Quals must carry const.
bool clang_Qualifiers_compatiblyIncludesObjCLifetime(unsigned Quals, unsigned Other);

unsigned clang_Qualifiers_withoutAddressSpace(unsigned Quals);

bool clang_Qualifiers_hasAddressSpace(unsigned Quals);

CXLangAS clang_Qualifiers_getAddressSpace(unsigned Quals);

bool clang_Qualifiers_hasTargetSpecificAddressSpace(unsigned Quals);

// PRECONDITION (Invariant 3): the address space must be LangAS::Default or a
// target-specific one; Qualifiers::getAddressSpaceAttributePrintValue asserts on a
// language-specific address space. The gate is observable through
// clang_Qualifiers_getAddressSpace and clang_Qualifiers_hasTargetSpecificAddressSpace,
// and the Julia wrapper restates it.
unsigned clang_Qualifiers_getAddressSpaceAttributePrintValue(unsigned Quals);

unsigned clang_Qualifiers_setAddressSpace(unsigned Quals, CXLangAS Space);

// PRECONDITION (Invariant 3): Space must not be CXLangAS_Default;
// Qualifiers::addAddressSpace asserts it. clang_Qualifiers_setAddressSpace is the
// unrestricted form, and Qualifiers::removeAddressSpace is already reachable as
// clang_Qualifiers_withoutAddressSpace. The Julia wrapper restates the assert.
unsigned clang_Qualifiers_addAddressSpace(unsigned Quals, CXLangAS Space);

// The fast/non-fast split: the fast set is the const/volatile/restrict subset
// that fits inline in a QualType; anything else needs an ExtQuals node.
bool clang_Qualifiers_hasFastQualifiers(unsigned Quals);

unsigned clang_Qualifiers_getFastQualifiers(unsigned Quals);

// Precondition on the fast mutator trio: Mask holds only fast-qualifier bits
// (const/volatile/restrict, mask 0x7); the clang methods assert on anything
// wider. setFastQualifiers replaces the fast set, addFastQualifiers unions into
// it and removeFastQualifiers subtracts from it.
unsigned clang_Qualifiers_setFastQualifiers(unsigned Quals, unsigned Mask);

unsigned clang_Qualifiers_addFastQualifiers(unsigned Quals, unsigned Mask);

unsigned clang_Qualifiers_removeFastQualifiers(unsigned Quals, unsigned Mask);

bool clang_Qualifiers_hasNonFastQualifiers(unsigned Quals);

unsigned clang_Qualifiers_getNonFastQualifiers(unsigned Quals);

bool clang_Qualifiers_hasQualifiers(unsigned Quals);

bool clang_Qualifiers_empty(unsigned Quals);

// Whole-set union and difference. Both are qualifier-aware rather than plain bit
// operations: the address space and the ObjC GC/lifetime fields are added or
// dropped as units, not bit-or'd together.
unsigned clang_Qualifiers_addQualifiers(unsigned Quals, unsigned Other);

unsigned clang_Qualifiers_removeQualifiers(unsigned Quals, unsigned Other);

// PRECONDITION (Invariant 3): the two sets must not disagree on any of the three
// non-fast fields. For each of address space, ObjC GC attribute and ObjC lifetime,
// either the two values are equal or at least one of the sets leaves the field unset;
// Qualifiers::addConsistentQualifiers asserts all three before OR-ing the masks. The
// Julia wrapper restates them.
unsigned clang_Qualifiers_addConsistentQualifiers(unsigned Quals, unsigned Other);

// Static: the OpenCL/SYCL/CUDA address-space superset relation over two LangAS
// values. This is Qualifiers::isAddressSpaceSupersetOf(LangAS, LangAS), not the
// same-named member overload taking another Qualifiers set, so it has no receiver.
bool clang_Qualifiers_isAddressSpaceSupersetOf(CXLangAS A, CXLangAS B);

bool clang_Qualifiers_compatiblyIncludes(unsigned Quals, unsigned Other);

bool clang_Qualifiers_isStrictSupersetOf(unsigned Quals, unsigned Other);

CXString clang_Qualifiers_getAsString(unsigned Quals);

// Static: the name clang prints for one address space value. No receiver.
CXString clang_Qualifiers_getAddrSpaceAsString(CXLangAS AS);

// The two printing entry points below take a CXASTContext and use its own
// getPrintingPolicy(), the way clang_Stmt_printPretty does: clang::PrintingPolicy is a
// by-value options bag with no handle of its own. isEmptyWhenPrinted answers whether print
// would write nothing at all.
bool clang_Qualifiers_isEmptyWhenPrinted(unsigned Quals, CXASTContext Ctx);

// clang::Qualifiers::print streams into a raw_ostream, so its output crosses as a copied
// CXString (MARSHALLING.md §5). AppendSpaceIfNonEmpty adds one trailing space when the set
// prints anything; an empty set prints "" whatever the flag says.
CXString clang_Qualifiers_printAsString(unsigned Quals, CXASTContext Ctx,
                                        bool AppendSpaceIfNonEmpty);

// SplitQualType
// A clang::SplitQualType is the (const Type *, Qualifiers) pair a QualType decomposes
// into. It has no handle of its own and crosses in both directions as the (CXType_,
// opaque unsigned) pair the clang_QualType_split family already produces
// (MARSHALLING.md §7): Ty and Quals carry the receiver, OutTy and OutQuals receive the
// result. Neither out-param may be NULL. clang::SplitQualType::asPair is the identity on
// this representation and is therefore not wrapped.
// PRECONDITION (Invariant 3): Ty must be non-null -- getSingleStepDesugaredType
// dereferences it -- and Quals must not disagree with the qualifiers written at the
// desugared level on the address space or on either Objective-C field, because the two
// sets are folded with Qualifiers::addConsistentQualifiers, which asserts all three. A
// pair that came out of clang_QualType_split (or clang_QualType_getSplitDesugaredType) on
// one type always satisfies the second half. The Julia wrapper restates both.
void clang_SplitQualType_getSingleStepDesugaredType(CXType_ Ty, unsigned Quals,
                                                    CXType_ *OutTy, unsigned *OutQuals);

// QualType

CXQualType clang_QualType_constructFromTypePtr(CXType_ Ptr, unsigned Quals);

CXType_ clang_QualType_getTypePtr(CXQualType OpaquePtr);

CXType_ clang_QualType_getTypePtrOrNull(CXQualType OpaquePtr);

// The *local* split, using the same two out-param shape as the getSplit* pair documented
// just below: Ty receives the type half, Quals the opaque Qualifiers encoding of the
// qualifiers attached at this level only. Neither out-param may be NULL. Unlike the two
// getSplit* variants this one is total — QualType::split reaches the type through
// getTypePtrUnsafe/getExtQualsUnsafe, neither of which asserts, so a null QualType yields
// a null Ty and an empty qualifier set.
void clang_QualType_split(CXQualType OpaquePtr, CXType_ *Ty, unsigned *Quals);

// A clang::SplitQualType is a (const Type *, Qualifiers) pair, so it crosses as two
// out-params (MARSHALLING.md §7): Ty receives the type half and Quals the opaque
// Qualifiers encoding shared with the clang_Qualifiers_* family. Neither out-param may
// be NULL.
// PRECONDITION (Invariant 3): OpaquePtr must be non-null. getSplitUnqualifiedType reaches
// the type through QualType::getTypePtr() and getSplitDesugaredType through
// QualifierCollector::strip, both of which assert/deref on a null QualType; the Julia
// wrappers restate it.
void clang_QualType_getSplitUnqualifiedType(CXQualType OpaquePtr, CXType_ *Ty,
                                            unsigned *Quals);

void clang_QualType_getSplitDesugaredType(CXQualType OpaquePtr, CXType_ *Ty,
                                          unsigned *Quals);

bool clang_QualType_isCanonical(CXQualType OpaquePtr);

// PRECONDITION (Invariant 3): OpaquePtr must be non-null. isCanonicalAsParam
// reaches the type through getCommonPtr()/getTypePtr(), both of which assert
// !isNull(); the Julia wrapper restates it.
bool clang_QualType_isCanonicalAsParam(CXQualType OpaquePtr);

bool clang_QualType_isNull(CXQualType OpaquePtr);

bool clang_QualType_isConstQualified(CXQualType OpaquePtr);
bool clang_QualType_isRestrictQualified(CXQualType OpaquePtr);
bool clang_QualType_isVolatileQualified(CXQualType OpaquePtr);

bool clang_QualType_hasQualifiers(CXQualType OpaquePtr);

CXQualType clang_QualType_withConst(CXQualType OpaquePtr);
CXQualType clang_QualType_withVolatile(CXQualType OpaquePtr);
CXQualType clang_QualType_withRestrict(CXQualType OpaquePtr);

// Precondition: CVR holds only const/volatile/restrict bits (mask 0x7);
// QualType::addFastQualifiers asserts on anything wider.
CXQualType clang_QualType_withCVRQualifiers(CXQualType OpaquePtr, unsigned CVR);

CXQualType clang_QualType_addConst(CXQualType OpaquePtr);
CXQualType clang_QualType_addVolatile(CXQualType OpaquePtr);
CXQualType clang_QualType_addRestrict(CXQualType OpaquePtr);

bool clang_QualType_isLocalConstQualified(CXQualType OpaquePtr);
bool clang_QualType_isLocalRestrictQualified(CXQualType OpaquePtr);
bool clang_QualType_isLocalVolatileQualified(CXQualType OpaquePtr);

bool clang_QualType_hasLocalQualifiers(CXQualType OpaquePtr);

bool clang_QualType_hasLocalNonFastQualifiers(CXQualType OpaquePtr);

unsigned clang_QualType_getLocalCVRQualifiers(CXQualType OpaquePtr);

unsigned clang_QualType_getCVRQualifiers(CXQualType OpaquePtr);

// Mirrors QualType::DestructionKind.
typedef enum CXDestructionKind {
  CXDestructionKind_DK_none = 0,
  CXDestructionKind_DK_cxx_destructor,
  CXDestructionKind_DK_objc_strong_lifetime,
  CXDestructionKind_DK_objc_weak_lifetime,
  CXDestructionKind_DK_nontrivial_c_struct
} CXDestructionKind;

// The whole Qualifiers value type crosses as its opaque unsigned encoding
// (MARSHALLING.md §7); rebuild it with Qualifiers::fromOpaqueValue.
unsigned clang_QualType_getQualifiersAsOpaqueValue(CXQualType OpaquePtr);

unsigned clang_QualType_getLocalFastQualifiers(CXQualType OpaquePtr);

// Whether operations on this type are evaluated at a wider format than the type itself,
// which is what the target's float-eval method decides for _Float16/__bf16.
// PRECONDITION (Invariant 3): OpaquePtr must be non-null -- it reaches the type through
// QualType::getTypePtr(), which asserts !isNull(). The Julia wrapper restates it.
bool clang_QualType_UseExcessPrecision(CXQualType OpaquePtr, CXASTContext Ctx);

// QualType is a value type crossing as its opaque encoding, so clang's in-place
// removeLocal* mutators surface here as value-returning wrappers, matching the
// clang_QualType_addConst/addVolatile/addRestrict trio above. Each clears only the
// LOCAL fast qualifier bit; qualifiers acquired through typedefs or other sugar are
// left untouched, and a null QualType is fine (these only edit the inline bits).
CXQualType clang_QualType_removeLocalConst(CXQualType OpaquePtr);
CXQualType clang_QualType_removeLocalVolatile(CXQualType OpaquePtr);
CXQualType clang_QualType_removeLocalRestrict(CXQualType OpaquePtr);

// Precondition: TQs holds only fast-qualifier bits (const/volatile/restrict, mask
// 0x7); QualType::addFastQualifiers asserts on anything wider.
CXQualType clang_QualType_withFastQualifiers(CXQualType OpaquePtr, unsigned TQs);

// Precondition: TQs holds only fast-qualifier bits (const/volatile/restrict, mask
// 0x7); QualType::addFastQualifiers asserts on anything wider. Unlike
// clang_QualType_withFastQualifiers this first clears the existing fast set.
CXQualType clang_QualType_withExactLocalFastQualifiers(CXQualType OpaquePtr, unsigned TQs);

CXQualType clang_QualType_withoutLocalFastQualifiers(CXQualType OpaquePtr);

bool clang_QualType_hasAddressSpace(CXQualType OpaquePtr);

CXLangAS clang_QualType_getAddressSpace(CXQualType OpaquePtr);

CXDestructionKind clang_QualType_isDestructedType(CXQualType OpaquePtr);

bool clang_QualType_isMoreQualifiedThan(CXQualType OpaquePtr, CXQualType Other);

// PRECONDITION (Invariant 3): both QualTypes must be non-null.
// QualType::isAddressSpaceOverlapping reads QualType::getQualifiers() on each operand,
// which reaches the type through getCommonPtr() and asserts !isNull(); the Julia wrapper
// restates it.
bool clang_QualType_isAddressSpaceOverlapping(CXQualType OpaquePtr, CXQualType Other);

// The ObjC qualifier tail. Every one of these reads QualType::getQualifiers(), which
// reaches the type through getCommonPtr() and asserts !isNull(), so a null QualType is
// undefined behaviour here; the Julia wrapper restates the precondition. The attribute and
// lifetime values are the same CXQualifiers_GC / CXQualifiers_ObjCLifetime mirrors the
// clang_Qualifiers_* family above uses.
CXQualifiers_GC clang_QualType_getObjCGCAttr(CXQualType OpaquePtr);

bool clang_QualType_isObjCGCWeak(CXQualType OpaquePtr);

bool clang_QualType_isObjCGCStrong(CXQualType OpaquePtr);

CXQualifiers_ObjCLifetime clang_QualType_getObjCLifetime(CXQualType OpaquePtr);

bool clang_QualType_hasNonTrivialObjCLifetime(CXQualType OpaquePtr);

bool clang_QualType_hasStrongOrWeakObjCLifetime(CXQualType OpaquePtr);

// PRECONDITION (Invariant 3): OpaquePtr must not be a null QualType --
// QualType::isNonWeakInMRRWithObjCWeak reads the qualifier set through getTypePtr(),
// which asserts !isNull(). True only for an Objective-C __weak type in a translation unit
// that enables weak references without ARC, so a C++ TU always reads false.
bool clang_QualType_isNonWeakInMRRWithObjCWeak(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isAtLeastAsQualifiedAs(CXQualType OpaquePtr, CXQualType Other);

CXQualType clang_QualType_getNonReferenceType(CXQualType OpaquePtr);

// PRECONDITION (Invariant 3): OpaquePtr must be non-null. getNonPackExpansionType
// reaches the type through getTypePtr(), which asserts !isNull(); the Julia
// wrapper restates it.
CXQualType clang_QualType_getNonPackExpansionType(CXQualType OpaquePtr);

CXQualType clang_QualType_IgnoreParens(CXQualType OpaquePtr);

// The ASTContext-taking classification cluster.
CXQualType clang_QualType_getDesugaredType(CXQualType OpaquePtr, CXASTContext Ctx);

CXQualType clang_QualType_getSingleStepDesugaredType(CXQualType OpaquePtr,
                                                     CXASTContext Ctx);

bool clang_QualType_isConstant(CXQualType OpaquePtr, CXASTContext Ctx);

// NonConstantStorageReason
// Mirrors clang::QualType::NonConstantStorageReason -- why instances of a type cannot be
// placed in immutable storage.
typedef enum CXNonConstantStorageReason {
  CXNonConstantStorageReason_MutableField,
  CXNonConstantStorageReason_NonConstNonReferenceType,
  CXNonConstantStorageReason_NonTrivialCtor,
  CXNonConstantStorageReason_NonTrivialDtor
} CXNonConstantStorageReason;

// std::optional<NonConstantStorageReason>: engaged (instances CANNOT go in immutable
// storage) -> fills *Out and returns true; disengaged (they can) -> returns false with
// *Out untouched (MARSHALLING.md §8). Out may not be NULL. This is the reason-carrying
// form of clang_QualType_isConstantStorage below, whose bool is exactly its negation.
// ExcludeCtor/ExcludeDtor drop the construction and destruction windows from
// consideration, as they do there.
bool clang_QualType_isNonConstantStorage(CXQualType OpaquePtr, CXASTContext Ctx,
                                         bool ExcludeCtor, bool ExcludeDtor,
                                         CXNonConstantStorageReason *Out);

// QualType::isConstantStorage is the negation of isNonConstantStorage, whose
// std::optional reason code is dropped here (MARSHALLING.md §8: only the
// discriminator crosses). ExcludeCtor/ExcludeDtor drop the construction and
// destruction windows from consideration.
bool clang_QualType_isConstantStorage(CXQualType OpaquePtr, CXASTContext Ctx,
                                      bool ExcludeCtor, bool ExcludeDtor);

bool clang_QualType_isPODType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isCXX98PODType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isCXX11PODType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isTrivialType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isTriviallyCopyableType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isTriviallyCopyConstructibleType(CXQualType OpaquePtr,
                                                     CXASTContext Ctx);

bool clang_QualType_isTriviallyRelocatableType(CXQualType OpaquePtr, CXASTContext Ctx);

bool clang_QualType_isTriviallyEqualityComparableType(CXQualType OpaquePtr,
                                                      CXASTContext Ctx);

CXString clang_QualType_getAsString(CXQualType OpaquePtr);

// clang::QualType::print streams into a raw_ostream, so its output crosses as a copied
// CXString (MARSHALLING.md §5), printed under Ctx's own getPrintingPolicy(). PlaceHolder is
// the declarator name printed inside the type ("int *p" for "p") and may be ""; Indentation
// is the base indent used when a record body is printed inline. A null QualType prints
// "NULL TYPE" rather than crashing, matching clang_QualType_getAsString.
CXString clang_QualType_printAsString(CXQualType OpaquePtr, CXASTContext Ctx,
                                      const char *PlaceHolder, unsigned Indentation);

void clang_QualType_dump(CXQualType OpaquePtr);

CXQualType clang_QualType_getCanonicalType(CXQualType OpaquePtr);

CXQualType clang_QualType_getLocalUnqualifiedType(CXQualType OpaquePtr);

CXQualType clang_QualType_getUnqualifiedType(CXQualType OpaquePtr);

// The qualifier and classification tail. Each of these but getLocalQualifiers
// reaches the type through QualType::getTypePtr(), which asserts !isNull(), so
// a null QualType is undefined behaviour here; the Julia wrapper restates the
// precondition. getLocalQualifiers is null-safe and returns the opaque
// Qualifiers encoding shared with the clang_Qualifiers_* family above.
CXIdentifierInfo clang_QualType_getBaseTypeIdentifier(CXQualType OpaquePtr);

bool clang_QualType_isReferenceable(CXQualType OpaquePtr);

unsigned clang_QualType_getLocalQualifiers(CXQualType OpaquePtr);

bool clang_QualType_mayBeDynamicClass(CXQualType OpaquePtr);

bool clang_QualType_mayBeNotDynamicClass(CXQualType OpaquePtr);

// The WebAssembly reference-type trio. Each reaches the type through
// QualType::getTypePtr(), which asserts !isNull(), so a null QualType is undefined
// behaviour here and the Julia wrapper restates the precondition.
// isWebAssemblyReferenceType is the disjunction of the other two, and
// isWebAssemblyFuncrefType additionally requires the wasm_funcref address space.
bool clang_QualType_isWebAssemblyReferenceType(CXQualType OpaquePtr);

bool clang_QualType_isWebAssemblyExternrefType(CXQualType OpaquePtr);

bool clang_QualType_isWebAssemblyFuncrefType(CXQualType OpaquePtr);

// PRECONDITION (Invariant 3): OpaquePtr must not be a null QualType --
// QualType::stripObjCKindOfType reaches the type through getTypePtr(), which asserts
// !isNull(). It is the identity on any type carrying no Objective-C __kindof sugar.
CXQualType clang_QualType_stripObjCKindOfType(CXQualType OpaquePtr, CXASTContext Ctx);

CXQualType clang_QualType_getAtomicUnqualifiedType(CXQualType OpaquePtr);

// The non-trivial-C-struct family. Every one of these reaches the type through
// QualType::getTypePtr(), which asserts !isNull(), so a null QualType is undefined
// behaviour here; the Julia wrapper restates the precondition.
// Mirrors QualType::PrimitiveDefaultInitializeKind.
typedef enum CXPrimitiveDefaultInitializeKind {
  CXPrimitiveDefaultInitializeKind_PDIK_Trivial,
  CXPrimitiveDefaultInitializeKind_PDIK_ARCStrong,
  CXPrimitiveDefaultInitializeKind_PDIK_ARCWeak,
  CXPrimitiveDefaultInitializeKind_PDIK_Struct
} CXPrimitiveDefaultInitializeKind;

CXPrimitiveDefaultInitializeKind
clang_QualType_isNonTrivialToPrimitiveDefaultInitialize(CXQualType OpaquePtr);

// Mirrors QualType::PrimitiveCopyKind.
typedef enum CXPrimitiveCopyKind {
  CXPrimitiveCopyKind_PCK_Trivial,
  CXPrimitiveCopyKind_PCK_VolatileTrivial,
  CXPrimitiveCopyKind_PCK_ARCStrong,
  CXPrimitiveCopyKind_PCK_ARCWeak,
  CXPrimitiveCopyKind_PCK_Struct
} CXPrimitiveCopyKind;

CXPrimitiveCopyKind clang_QualType_isNonTrivialToPrimitiveCopy(CXQualType OpaquePtr);

CXPrimitiveCopyKind
clang_QualType_isNonTrivialToPrimitiveDestructiveMove(CXQualType OpaquePtr);

bool clang_QualType_hasNonTrivialToPrimitiveDefaultInitializeCUnion(CXQualType OpaquePtr);

bool clang_QualType_hasNonTrivialToPrimitiveDestructCUnion(CXQualType OpaquePtr);

bool clang_QualType_hasNonTrivialToPrimitiveCopyCUnion(CXQualType OpaquePtr);

bool clang_QualType_isCForbiddenLValueType(CXQualType OpaquePtr);

CXQualType clang_QualType_getNonLValueExprType(CXQualType OpaquePtr, CXASTContext Ctx);

// Type
bool clang_Type_isFromAST(CXType_ T);

// containsUnexpandedParameterPack

bool clang_Type_containsUnexpandedParameterPack(CXType_ T);

bool clang_Type_isCanonicalUnqualified(CXType_ T);

// getLocallyUnqualifiedSingleStepDesugaredType

CXQualType clang_Type_getLocallyUnqualifiedSingleStepDesugaredType(CXType_ T);

bool clang_Type_isSizelessType(CXType_ T);

bool clang_Type_isSizelessBuiltinType(CXType_ T);

bool clang_Type_isSizelessVectorType(CXType_ T);

// isSVESizelessBuiltinType
bool clang_Type_isSVESizelessBuiltinType(CXType_ T);

// isRVVSizelessBuiltinType
bool clang_Type_isRVVSizelessBuiltinType(CXType_ T);

// isWebAssemblyExternrefType
bool clang_Type_isWebAssemblyExternrefType(CXType_ T);

// isWebAssemblyTableType
bool clang_Type_isWebAssemblyTableType(CXType_ T);

// isSveVLSBuiltinType
bool clang_Type_isSveVLSBuiltinType(CXType_ T);

// isVLSTBuiltinType

// getSveEltType
// PRECONDITION (Invariant 3): T must satisfy Type::isSveVLSBuiltinType(). getSveEltType
// reaches the BuiltinType subobject through an unchecked getAs<BuiltinType>() and
// dereferences it, so any other type is undefined behaviour. The gate is
// clang_Type_isSveVLSBuiltinType above; the Julia wrapper restates it.
CXQualType clang_Type_getSveEltType(CXType_ T, CXASTContext Ctx);

// isRVVVLSBuiltinType
bool clang_Type_isRVVVLSBuiltinType(CXType_ T);

// getRVVEltType
// PRECONDITION (Invariant 3): T must satisfy Type::isRVVVLSBuiltinType(), for the same
// unchecked getAs<BuiltinType>() reason as getSveEltType. The gate is
// clang_Type_isRVVVLSBuiltinType above; the Julia wrapper restates it.
CXQualType clang_Type_getRVVEltType(CXType_ T, CXASTContext Ctx);

// isIncompleteType

// Def is the optional `NamedDecl **` out-parameter of Type::isIncompleteType: pass NULL
// to ignore it, otherwise it receives the completable declaration (C struct, C++ class,
// ObjC class) the type refers to, or NULL when there is none.
bool clang_Type_isIncompleteType(CXType_ T, CXNamedDecl *Def);

bool clang_Type_isIncompleteOrObjectType(CXType_ T);

bool clang_Type_isObjectType(CXType_ T);

// isIncompleteOrObjectType

// isObjectType

// isLiteralType

// isStructuralType

// isStandardLayoutType

bool clang_Type_isLiteralType(CXType_ T, CXASTContext Ctx);

bool clang_Type_isStructuralType(CXType_ T);

bool clang_Type_isStandardLayoutType(CXType_ T);

bool clang_Type_isBuiltinType(CXType_ T);

// isSpecificBuiltinType

// K is a clang::BuiltinType::Kind value. The comparison is total, so a K
// outside the enumeration simply never matches.
bool clang_Type_isSpecificBuiltinType(CXType_ T, unsigned K);

// isPlaceholderType

bool clang_Type_isPlaceholderType(CXType_ T);

CXBuiltinType clang_Type_getAsPlaceholderType(CXType_ T);

// getAsPlaceholderType

// isSpecificPlaceholderType

// PRECONDITION (Invariant 3): K must name a placeholder BuiltinType::Kind;
// Type::isSpecificPlaceholderType asserts BuiltinType::isPlaceholderTypeKind(K).
// The gate is clang_BuiltinType_isPlaceholderTypeKind below and the Julia
// wrapper restates it.
bool clang_Type_isSpecificPlaceholderType(CXType_ T, unsigned K);

// isNonOverloadPlaceholderType

bool clang_Type_isNonOverloadPlaceholderType(CXType_ T);

bool clang_Type_isIntegerType(CXType_ T);

bool clang_Type_isEnumeralType(CXType_ T);

bool clang_Type_isScopedEnumeralType(CXType_ T);

bool clang_Type_isBooleanType(CXType_ T);

bool clang_Type_isCharType(CXType_ T);

bool clang_Type_isWideCharType(CXType_ T);

bool clang_Type_isChar8Type(CXType_ T);

bool clang_Type_isChar16Type(CXType_ T);

bool clang_Type_isChar32Type(CXType_ T);

bool clang_Type_isAnyCharacterType(CXType_ T);

// isIntegralType

bool clang_Type_isIntegralType(CXType_ T, CXASTContext Ctx);

bool clang_Type_isIntegralOrEnumerationType(CXType_ T);

bool clang_Type_isIntegralOrUnscopedEnumerationType(CXType_ T);

bool clang_Type_isUnscopedEnumerationType(CXType_ T);

bool clang_Type_isRealFloatingType(CXType_ T);

bool clang_Type_isComplexType(CXType_ T);

bool clang_Type_isAnyComplexType(CXType_ T);

bool clang_Type_isFloatingType(CXType_ T);

bool clang_Type_isHalfType(CXType_ T);

bool clang_Type_isFloat16Type(CXType_ T);

bool clang_Type_isBFloat16Type(CXType_ T);

bool clang_Type_isFloat128Type(CXType_ T);

// isIbm128Type

bool clang_Type_isIbm128Type(CXType_ T);

bool clang_Type_isRealType(CXType_ T);

bool clang_Type_isArithmeticType(CXType_ T);

bool clang_Type_isVoidType(CXType_ T);

bool clang_Type_isScalarType(CXType_ T);

bool clang_Type_isAggregateType(CXType_ T);

bool clang_Type_isFundamentalType(CXType_ T);

bool clang_Type_isCompoundType(CXType_ T);

bool clang_Type_isFunctionType(CXType_ T);

bool clang_Type_isFunctionNoProtoType(CXType_ T);

bool clang_Type_isFunctionProtoType(CXType_ T);

bool clang_Type_isPointerType(CXType_ T);

bool clang_Type_isAnyPointerType(CXType_ T);

bool clang_Type_isBlockPointerType(CXType_ T);

bool clang_Type_isVoidPointerType(CXType_ T);

bool clang_Type_isReferenceType(CXType_ T);

bool clang_Type_isLValueReferenceType(CXType_ T);

bool clang_Type_isRValueReferenceType(CXType_ T);

bool clang_Type_isObjectPointerType(CXType_ T);

bool clang_Type_isFunctionPointerType(CXType_ T);

bool clang_Type_isFunctionReferenceType(CXType_ T);

bool clang_Type_isMemberPointerType(CXType_ T);

bool clang_Type_isMemberFunctionPointerType(CXType_ T);

bool clang_Type_isMemberDataPointerType(CXType_ T);

bool clang_Type_isArrayType(CXType_ T);

bool clang_Type_isConstantArrayType(CXType_ T);

bool clang_Type_isIncompleteArrayType(CXType_ T);

bool clang_Type_isVariableArrayType(CXType_ T);

bool clang_Type_isDependentSizedArrayType(CXType_ T);

bool clang_Type_isRecordType(CXType_ T);

bool clang_Type_isClassType(CXType_ T);

bool clang_Type_isStructureType(CXType_ T);

bool clang_Type_isObjCBoxableRecordType(CXType_ T);

bool clang_Type_isInterfaceType(CXType_ T);

bool clang_Type_isStructureOrClassType(CXType_ T);

bool clang_Type_isUnionType(CXType_ T);

bool clang_Type_isComplexIntegerType(CXType_ T);

bool clang_Type_isVectorType(CXType_ T);

bool clang_Type_isExtVectorType(CXType_ T);

// isExtVectorBoolType
bool clang_Type_isExtVectorBoolType(CXType_ T);

bool clang_Type_isMatrixType(CXType_ T);

bool clang_Type_isConstantMatrixType(CXType_ T);

bool clang_Type_isDependentAddressSpaceType(CXType_ T);

// isObjCObjectPointerType
bool clang_Type_isObjCObjectPointerType(CXType_ T);

// isObjCRetainableType
bool clang_Type_isObjCRetainableType(CXType_ T);

// isObjCLifetimeType
bool clang_Type_isObjCLifetimeType(CXType_ T);

// isObjCIndirectLifetimeType
bool clang_Type_isObjCIndirectLifetimeType(CXType_ T);

// isObjCNSObjectType
bool clang_Type_isObjCNSObjectType(CXType_ T);

// isObjCIndependentClassType
bool clang_Type_isObjCIndependentClassType(CXType_ T);

// isObjCObjectType
bool clang_Type_isObjCObjectType(CXType_ T);

// isObjCQualifiedInterfaceType
bool clang_Type_isObjCQualifiedInterfaceType(CXType_ T);

// isObjCQualifiedIdType
bool clang_Type_isObjCQualifiedIdType(CXType_ T);

// isObjCQualifiedClassType
bool clang_Type_isObjCQualifiedClassType(CXType_ T);

// isObjCObjectOrInterfaceType
bool clang_Type_isObjCObjectOrInterfaceType(CXType_ T);

// isObjCIdType
bool clang_Type_isObjCIdType(CXType_ T);

bool clang_Type_isDecltypeType(CXType_ T);

// isObjCInertUnsafeUnretainedType
bool clang_Type_isObjCInertUnsafeUnretainedType(CXType_ T);

// isObjCIdOrObjectKindOfType
// Bound is an out-param and may be NULL when only the predicate is wanted. The shim clears
// its own local before the call, so a non-NULL Bound always receives a defined value: the
// (possibly specialized) Objective-C class type bounding a __kindof type, or NULL both for
// a plain `id` and for every type that does not match.
bool clang_Type_isObjCIdOrObjectKindOfType(CXType_ T, CXASTContext Ctx,
                                           CXObjCObjectType *Bound);

// isObjCClassType
bool clang_Type_isObjCClassType(CXType_ T);

// isObjCClassOrClassKindOfType
bool clang_Type_isObjCClassOrClassKindOfType(CXType_ T);

// isBlockCompatibleObjCPointerType
// clang takes the ASTContext by non-const reference here; Ctx may not be NULL. The
// predicate answers false for every type that is not an Objective-C object pointer, so a
// C++ translation unit always reads false.
bool clang_Type_isBlockCompatibleObjCPointerType(CXType_ T, CXASTContext Ctx);

// isObjCSelType
bool clang_Type_isObjCSelType(CXType_ T);

// isObjCBuiltinType
// The disjunction of isObjCIdType, isObjCClassType and isObjCSelType.
bool clang_Type_isObjCBuiltinType(CXType_ T);

// isObjCARCBridgableType
bool clang_Type_isObjCARCBridgableType(CXType_ T);

// isCARCBridgableType
bool clang_Type_isCARCBridgableType(CXType_ T);

bool clang_Type_isTemplateTypeParmType(CXType_ T);

bool clang_Type_isNullPtrType(CXType_ T);

bool clang_Type_isNothrowT(CXType_ T);

bool clang_Type_isAlignValT(CXType_ T);

bool clang_Type_isStdByteType(CXType_ T);

bool clang_Type_isAtomicType(CXType_ T);

bool clang_Type_isUndeducedAutoType(CXType_ T);

bool clang_Type_isTypedefNameType(CXType_ T);

// clang/Basic/OpenCLImageTypes.def

// isImageType
bool clang_Type_isImageType(CXType_ T);

// isSamplerT
bool clang_Type_isSamplerT(CXType_ T);

// isEventT
bool clang_Type_isEventT(CXType_ T);

// isClkEventT
bool clang_Type_isClkEventT(CXType_ T);

// isQueueT
bool clang_Type_isQueueT(CXType_ T);

// isReserveIDT
bool clang_Type_isReserveIDT(CXType_ T);

// clang/Basic/OpenCLExtensionTypes.def

// isOCLIntelSubgroupAVCType
bool clang_Type_isOCLIntelSubgroupAVCType(CXType_ T);

// isOCLExtOpaqueType
bool clang_Type_isOCLExtOpaqueType(CXType_ T);

// isPipeType
bool clang_Type_isPipeType(CXType_ T);

// isBitIntType

bool clang_Type_isBitIntType(CXType_ T);

// isOpenCLSpecificType
// The union of isSamplerT, isEventT, isImageType, isClkEventT, isQueueT,
// isReserveIDT, isPipeType and isOCLExtOpaqueType.
bool clang_Type_isOpenCLSpecificType(CXType_ T);

// isObjCARCImplicitlyUnretainedType
// PRECONDITION (Invariant 3): T must satisfy Type::isObjCLifetimeType();
// Type::isObjCARCImplicitlyUnretainedType asserts it on entry. The gate is
// clang_Type_isObjCLifetimeType above; the Julia wrapper restates it.
bool clang_Type_isObjCARCImplicitlyUnretainedType(CXType_ T);

// isCUDADeviceBuiltinSurfaceType
bool clang_Type_isCUDADeviceBuiltinSurfaceType(CXType_ T);

// isCUDADeviceBuiltinTextureType
bool clang_Type_isCUDADeviceBuiltinTextureType(CXType_ T);

// getObjCARCImplicitLifetime
// PRECONDITION (Invariant 3): T must satisfy Type::isObjCLifetimeType();
// Type::getObjCARCImplicitLifetime asserts it on entry. The gate is
// clang_Type_isObjCLifetimeType above; the Julia wrapper restates it.
CXQualifiers_ObjCLifetime clang_Type_getObjCARCImplicitLifetime(CXType_ T);

// isRVVType

// containsErrors

// Mirrors Type::ScalarTypeKind.
typedef enum CXScalarTypeKind {
  CXScalarTypeKind_STK_CPointer = 0,
  CXScalarTypeKind_STK_BlockPointer,
  CXScalarTypeKind_STK_ObjCObjectPointer,
  CXScalarTypeKind_STK_MemberPointer,
  CXScalarTypeKind_STK_Bool,
  CXScalarTypeKind_STK_Integral,
  CXScalarTypeKind_STK_Floating,
  CXScalarTypeKind_STK_IntegralComplex,
  CXScalarTypeKind_STK_FloatingComplex,
  CXScalarTypeKind_STK_FixedPoint
} CXScalarTypeKind;

// PRECONDITION (Invariant 3): T must be a scalar type. Type::getScalarTypeKind is
// total only over scalars -- it asserts on entry and falls off into llvm_unreachable
// for anything else. The Julia wrapper restates this as @assert isScalarType(x).
CXScalarTypeKind clang_Type_getScalarTypeKind(CXType_ T);

// The whole clang::TypeDependence bitmask in one call. It is an LLVM bitmask enum whose
// combined enumerators duplicate values, so it crosses as a plain unsigned rather than a
// mirrored CX enum, the same way clang_FunctionProtoType_getAArch64SMEAttributes does. The
// bits (clang/AST/DependenceFlags.h) are 1 UnexpandedPack, 2 Instantiation, 4 Dependent,
// 8 VariablyModified and 16 Error -- each already reachable one at a time through
// clang_Type_containsUnexpandedParameterPack, clang_Type_isInstantiationDependentType,
// clang_Type_isDependentType, clang_Type_isVariablyModifiedType and
// clang_Type_containsErrors.
unsigned clang_Type_getDependence(CXType_ T);

bool clang_Type_containsErrors(CXType_ T);

bool clang_Type_isDependentType(CXType_ T);

bool clang_Type_isInstantiationDependentType(CXType_ T);

bool clang_Type_isUndeducedType(CXType_ T);

bool clang_Type_isVariablyModifiedType(CXType_ T);

bool clang_Type_hasSizedVLAType(CXType_ T);

bool clang_Type_hasUnnamedOrLocalType(CXType_ T);

bool clang_Type_isOverloadableType(CXType_ T);

bool clang_Type_isElaboratedTypeSpecifier(CXType_ T);

bool clang_Type_canDecayToPointerType(CXType_ T);

bool clang_Type_hasPointerRepresentation(CXType_ T);

bool clang_Type_hasObjCPointerRepresentation(CXType_ T);

bool clang_Type_hasIntegerRepresentation(CXType_ T);

bool clang_Type_hasSignedIntegerRepresentation(CXType_ T);

bool clang_Type_hasUnsignedIntegerRepresentation(CXType_ T);

bool clang_Type_hasFloatingRepresentation(CXType_ T);

CXRecordType clang_Type_getAsStructureType(CXType_ T);

CXRecordType clang_Type_getAsUnionType(CXType_ T);

CXComplexType clang_Type_getAsComplexIntegerType(CXType_ T);

// getAsObjCInterfaceType

// getAsObjCInterfacePointerType

// getAsObjCQualifiedIdType

// getAsObjCQualifiedClassType

// getAsObjCQualifiedInterfaceType

// The Objective-C tail of the "Type Checking Functions" group. Each digs through typedefs
// and qualifiers for the Objective-C shape it names and answers NULL when the type is not
// that shape, so all five are total and a C++ translation unit reads NULL from every one
// of them. getAsObjCInterfaceType additionally requires the object type to name an
// interface, and the QualifiedId / QualifiedClass / QualifiedInterface forms require at
// least one protocol qualifier.
CXObjCObjectType clang_Type_getAsObjCInterfaceType(CXType_ T);

CXObjCObjectPointerType clang_Type_getAsObjCInterfacePointerType(CXType_ T);

CXObjCObjectPointerType clang_Type_getAsObjCQualifiedIdType(CXType_ T);

CXObjCObjectPointerType clang_Type_getAsObjCQualifiedClassType(CXType_ T);

CXObjCObjectType clang_Type_getAsObjCQualifiedInterfaceType(CXType_ T);

CXCXXRecordDecl clang_Type_getAsCXXRecordDecl(CXType_ T);

CXRecordDecl clang_Type_getAsRecordDecl(CXType_ T);

CXTagDecl clang_Type_getAsTagDecl(CXType_ T);

CXCXXRecordDecl clang_Type_getPointeeCXXRecordDecl(CXType_ T);

CXDeducedType clang_Type_getContainedDeducedType(CXType_ T);

// getContainedAutoType

// Null-safe: dyn_cast_or_null of the contained DeducedType, so a non-auto type
// yields NULL rather than a bad cast.
CXAutoType clang_Type_getContainedAutoType(CXType_ T);

bool clang_Type_hasAutoForTrailingReturnType(CXType_ T);

// getAsArrayTypeUnsafe

CXArrayType clang_Type_getAsArrayTypeUnsafe(CXType_ T);

// PRECONDITION (Invariant 3): T's canonical type must be an ArrayType. This is the
// castAs<> form -- it never returns NULL and performs no check. Use
// clang_Type_getAsArrayTypeUnsafe for the null-returning form. The Julia wrapper
// restates this as @assert isArrayType(x).
CXArrayType clang_Type_castAsArrayTypeUnsafe(CXType_ T);

// Whether the type carries the attribute AK, looking through top-level type sugar: clang
// walks the AttributedType chain, so a type with no attribute sugar is simply false.
bool clang_Type_hasAttr(CXType_ T, CXAttrKind AK);

// castAsArrayTypeUnsafe

// hasAttr

// getBaseElementTypeUnsafe

CXType_ clang_Type_getBaseElementTypeUnsafe(CXType_ T);

CXType_ clang_Type_getArrayElementTypeNoTypeQual(CXType_ T);

CXType_ clang_Type_getPointeeOrArrayElementType(CXType_ T);

CXQualType clang_Type_getPointeeType(CXType_ T);

CXType_ clang_Type_getUnqualifiedDesugaredType(CXType_ T);

bool clang_Type_isSignedIntegerType(CXType_ T);

bool clang_Type_isUnsignedIntegerType(CXType_ T);

bool clang_Type_isSignedIntegerOrEnumerationType(CXType_ T);

bool clang_Type_isUnsignedIntegerOrEnumerationType(CXType_ T);

bool clang_Type_isFixedPointType(CXType_ T);

bool clang_Type_isFixedPointOrIntegerType(CXType_ T);

bool clang_Type_isSaturatedFixedPointType(CXType_ T);

bool clang_Type_isUnsaturatedFixedPointType(CXType_ T);

bool clang_Type_isSignedFixedPointType(CXType_ T);

bool clang_Type_isUnsignedFixedPointType(CXType_ T);

bool clang_Type_isConstantSizeType(CXType_ T);

bool clang_Type_isSpecifierType(CXType_ T);

CXLinkage clang_Type_getLinkage(CXType_ T);

CXVisibility clang_Type_getVisibility(CXType_ T);

// getLinkage

// getVisibility

bool clang_Type_isVisibilityExplicit(CXType_ T);

// getLinkageAndVisibility
// The LinkageInfo aggregate crosses field-by-field, exactly as
// clang_NamedDecl_getLinkageAndVisibility does (MARSHALLING.md §7): the computed linkage,
// the computed visibility, and whether that visibility was explicitly specified. All three
// out-params are written on every call and must be non-NULL.
void clang_Type_getLinkageAndVisibility(CXType_ T, CXLinkage *L, CXVisibility *V,
                                        bool *VisibilityExplicit);

bool clang_Type_isLinkageValid(CXType_ T);

// getNullability
// clang::Type::getNullability returns std::optional<NullabilityKind>: engaged -> fills
// *Out and returns true; disengaged (the type carries no nullability sugar) -> returns
// false with *Out untouched (MARSHALLING.md §8). Out may not be NULL. Nullability is
// recorded only as sugar, so a canonicalised or desugared type always answers false.
bool clang_Type_getNullability(CXType_ T, CXNullabilityKind *Out);

// canHaveNullability
// ResultIfUnknown is what clang answers for a dependent type whose nullability
// admissibility is not yet decidable; clang's own default for it is true.
bool clang_Type_canHaveNullability(CXType_ T, bool ResultIfUnknown);

// acceptsObjCTypeParams
bool clang_Type_acceptsObjCTypeParams(CXType_ T);

// Borrowed pointer into clang's static TypeClass name table.
const char *clang_Type_getTypeClassName(CXType_ T);

// getresolveName

CXQualType clang_Type_getCanonicalTypeInternal(CXType_ T);

// The canonical type with its top-level qualifiers stripped. clang returns a CanQualType;
// it crosses as the plain QualType opaque encoding, since "is canonical" is a static C++
// guarantee the type-erased C surface cannot carry.
CXQualType clang_Type_getCanonicalTypeUnqualified(CXType_ T);

void clang_Type_dump(CXType_ T);

// isa
bool clang_isa_ComplexType(CXType_ T);

bool clang_isa_PointerType(CXType_ T);

bool clang_isa_ReferenceType(CXType_ T);

bool clang_isa_LValueReferenceType(CXType_ T);

bool clang_isa_RValueReferenceType(CXType_ T);

bool clang_isa_MemberPointerType(CXType_ T);

bool clang_isa_ArrayType(CXType_ T);

bool clang_isa_ConstantArrayType(CXType_ T);

bool clang_isa_IncompleteArrayType(CXType_ T);

bool clang_isa_VariableArrayType(CXType_ T);

bool clang_isa_DependentSizedArrayType(CXType_ T);

bool clang_isa_FunctionType(CXType_ T);

bool clang_isa_FunctionNoProtoType(CXType_ T);

bool clang_isa_FunctionProtoType(CXType_ T);

bool clang_isa_UnresolvedUsingType(CXType_ T);

bool clang_isa_UsingType(CXType_ T);

bool clang_isa_TypedefType(CXType_ T);

bool clang_isa_DecltypeType(CXType_ T);

bool clang_isa_DependentDecltypeType(CXType_ T);

bool clang_isa_TagType(CXType_ T);

bool clang_isa_RecordType(CXType_ T);

bool clang_isa_EnumType(CXType_ T);

bool clang_isa_TemplateTypeParmType(CXType_ T);

bool clang_isa_SubstTemplateTypeParmType(CXType_ T);

bool clang_isa_SubstTemplateTypeParmPackType(CXType_ T);

bool clang_isa_DeducedType(CXType_ T);

bool clang_isa_AutoType(CXType_ T);

bool clang_isa_DeducedTemplateSpecializationType(CXType_ T);

bool clang_isa_TemplateSpecializationType(CXType_ T);

bool clang_isa_ElaboratedType(CXType_ T);

bool clang_isa_DependentNameType(CXType_ T);

bool clang_isa_DependentTemplateSpecializationType(CXType_ T);

bool clang_isa_AtomicType(CXType_ T);

bool clang_isa_DecayedType(CXType_ T);

bool clang_isa_AdjustedType(CXType_ T);

bool clang_isa_InjectedClassNameType(CXType_ T);

bool clang_isa_MacroQualifiedType(CXType_ T);

bool clang_isa_UnaryTransformType(CXType_ T);

bool clang_isa_ParenType(CXType_ T);

bool clang_isa_DependentAddressSpaceType(CXType_ T);

bool clang_isa_DependentSizedExtVectorType(CXType_ T);

// BuiltinTypes
bool clang_isa_BuiltinType_Void(CXType_ T);

bool clang_isa_BuiltinType_Bool(CXType_ T);

bool clang_isa_BuiltinType_Char_U(CXType_ T);

bool clang_isa_BuiltinType_UChar(CXType_ T);

bool clang_isa_BuiltinType_WChar_U(CXType_ T);

bool clang_isa_BuiltinType_Char8(CXType_ T);

bool clang_isa_BuiltinType_Char16(CXType_ T);

bool clang_isa_BuiltinType_Char32(CXType_ T);

bool clang_isa_BuiltinType_UShort(CXType_ T);

bool clang_isa_BuiltinType_UInt(CXType_ T);

bool clang_isa_BuiltinType_ULong(CXType_ T);

bool clang_isa_BuiltinType_ULongLong(CXType_ T);

bool clang_isa_BuiltinType_UInt128(CXType_ T);

bool clang_isa_BuiltinType_Char_S(CXType_ T);

bool clang_isa_BuiltinType_SChar(CXType_ T);

bool clang_isa_BuiltinType_WChar_S(CXType_ T);

bool clang_isa_BuiltinType_Short(CXType_ T);

bool clang_isa_BuiltinType_Int(CXType_ T);

bool clang_isa_BuiltinType_Long(CXType_ T);

bool clang_isa_BuiltinType_LongLong(CXType_ T);

bool clang_isa_BuiltinType_Int128(CXType_ T);

bool clang_isa_BuiltinType_Half(CXType_ T);

bool clang_isa_BuiltinType_Float(CXType_ T);

bool clang_isa_BuiltinType_Double(CXType_ T);

bool clang_isa_BuiltinType_LongDouble(CXType_ T);

bool clang_isa_BuiltinType_Float16(CXType_ T);

bool clang_isa_BuiltinType_BFloat16(CXType_ T);

bool clang_isa_BuiltinType_Float128(CXType_ T);

bool clang_isa_BuiltinType_NullPtr(CXType_ T);

bool clang_BuiltinType_isSugared(CXBuiltinType T);

CXQualType clang_BuiltinType_desugar(CXBuiltinType T);

bool clang_BuiltinType_isInteger(CXBuiltinType T);

bool clang_BuiltinType_isSignedInteger(CXBuiltinType T);

bool clang_BuiltinType_isUnsignedInteger(CXBuiltinType T);

bool clang_BuiltinType_isFloatingPoint(CXBuiltinType T);

bool clang_BuiltinType_isSVEBool(CXBuiltinType T);

bool clang_BuiltinType_isSVECount(CXBuiltinType T);

// Static: whether a clang::BuiltinType::Kind value names a placeholder type; it
// takes no receiver. This is the gate clang_Type_isSpecificPlaceholderType
// asserts on.
bool clang_BuiltinType_isPlaceholderTypeKind(unsigned K);

// The kind itself crosses as a plain unsigned, matching the K parameter of
// clang_BuiltinType_isPlaceholderTypeKind and clang_Type_isSpecificBuiltinType:
// clang::BuiltinType::Kind is stamped from the OpenCL/SVE/RVV builtin tables and has no
// mirrored CX enum.
unsigned clang_BuiltinType_getKind(CXBuiltinType T);

// The printed spelling of a builtin type under Ctx's own getPrintingPolicy(), which is what
// decides e.g. "bool" versus "_Bool". clang::BuiltinType::getName returns a StringRef into
// clang's static name tables; it crosses as a copied CXString (MARSHALLING.md §5).
CXString clang_BuiltinType_getName(CXBuiltinType T, CXASTContext Ctx);

// The same spelling as a borrowed pointer into clang's static tables (never freed). clang
// asserts the name is a non-empty NUL-terminated literal, which holds for every
// BuiltinType::Kind, so this adds no precondition over clang_BuiltinType_getName.
const char *clang_BuiltinType_getNameAsCString(CXBuiltinType T, CXASTContext Ctx);

bool clang_BuiltinType_isPlaceholderType(CXBuiltinType T);

bool clang_BuiltinType_isNonOverloadPlaceholderType(CXBuiltinType T);

// ComplexType
CXQualType clang_ComplexType_getElementType(CXComplexType T);

bool clang_ComplexType_isSugared(CXComplexType T);

CXQualType clang_ComplexType_desugar(CXComplexType T);

// ParenType
CXQualType clang_ParenType_getInnerType(CXParenType T);

bool clang_ParenType_isSugared(CXParenType T);

CXQualType clang_ParenType_desugar(CXParenType T);

// PointerType
CXQualType clang_PointerType_getPointeeType(CXPointerType T);

bool clang_PointerType_isSugared(CXPointerType T);

CXQualType clang_PointerType_desugar(CXPointerType T);

// AdjustedType
CXQualType clang_AdjustedType_getOriginalType(CXAdjustedType T);

CXQualType clang_AdjustedType_getAdjustedType(CXAdjustedType T);

bool clang_AdjustedType_isSugared(CXAdjustedType T);

CXQualType clang_AdjustedType_desugar(CXAdjustedType T);

// DecayedType
CXQualType clang_DecayedType_getDecayedType(CXDecayedType T);

CXQualType clang_DecayedType_getPointeeType(CXDecayedType T);

// BlockPointerType
// The pointee is always a function type -- ASTContext::getBlockPointerType asserts it when
// the node is built -- so the accessor itself is total.
CXQualType clang_BlockPointerType_getPointeeType(CXBlockPointerType T);

bool clang_BlockPointerType_isSugared(CXBlockPointerType T);

CXQualType clang_BlockPointerType_desugar(CXBlockPointerType T);

// ReferenceType
bool clang_ReferenceType_isSpelledAsLValue(CXReferenceType T);

bool clang_ReferenceType_isInnerRef(CXReferenceType T);

CXQualType clang_ReferenceType_getPointeeTypeAsWritten(CXReferenceType T);

CXQualType clang_ReferenceType_getPointeeType(CXReferenceType T);

// LValueReferenceType
bool clang_LValueReferenceType_isSugared(CXLValueReferenceType T);

CXQualType clang_LValueReferenceType_desugar(CXLValueReferenceType T);

// RValueReferenceType
bool clang_RValueReferenceType_isSugared(CXRValueReferenceType T);

CXQualType clang_RValueReferenceType_desugar(CXRValueReferenceType T);

// MemberPointerType
CXQualType clang_MemberPointerType_getPointeeType(CXMemberPointerType T);

bool clang_MemberPointerType_isMemberFunctionPointer(CXMemberPointerType T);

bool clang_MemberPointerType_isMemberDataPointer(CXMemberPointerType T);

CXType_ clang_MemberPointerType_getClass(CXMemberPointerType T);

CXCXXRecordDecl clang_MemberPointerType_getMostRecentCXXRecordDecl(CXMemberPointerType T);

bool clang_MemberPointerType_isSugared(CXMemberPointerType T);

CXQualType clang_MemberPointerType_desugar(CXMemberPointerType T);

// ArrayType
typedef enum CXArraySizeModifier {
  CXArraySizeModifier_Normal,
  CXArraySizeModifier_Static,
  CXArraySizeModifier_Star
} CXArraySizeModifier;

CXQualType clang_ArrayType_getElementType(CXArrayType T);

CXArraySizeModifier clang_ArrayType_getSizeModifier(CXArrayType T);

// CXQualifiers clang_ArrayType_getIndexTypeQualifiers(CXArrayType T);

unsigned clang_ArrayType_getIndexTypeQualifiers(CXArrayType T);

unsigned clang_ArrayType_getIndexTypeCVRQualifiers(CXArrayType T);

// ConstantArrayType
// clang::ConstantArrayType::getSize returns `const llvm::APInt &` (the element
// count). It crosses as an owned llvm::GenericValue (MARSHALLING.md §1), like
// clang_IntegerLiteral_getValue; the caller owns it (LLVM-C disposal).
LLVMGenericValueRef clang_ConstantArrayType_getSize(CXConstantArrayType T);
// getSize
CXExpr clang_ConstantArrayType_getSizeExpr(CXConstantArrayType T);

bool clang_ConstantArrayType_isSugared(CXConstantArrayType T);

CXQualType clang_ConstantArrayType_desugar(CXConstantArrayType T);

unsigned clang_ConstantArrayType_getNumAddressingBits(CXConstantArrayType T,
                                                      CXASTContext C);

// Static: the maximum number of active bits an array's size may require on this target,
// which caps the size of a constant array. It takes no ConstantArrayType receiver.
unsigned clang_ConstantArrayType_getMaxSizeBits(CXASTContext C);

// IncompleteArrayType
bool clang_IncompleteArrayType_isSugared(CXIncompleteArrayType T);

CXQualType clang_IncompleteArrayType_desugar(CXIncompleteArrayType T);

// VariableArrayType
CXSourceRange_ clang_VariableArrayType_getBracketsRange(CXVariableArrayType T);

CXSourceLocation_ clang_VariableArrayType_getLBracketLoc(CXVariableArrayType T);

CXSourceLocation_ clang_VariableArrayType_getRBracketLoc(CXVariableArrayType T);
// getLBracketLoc
// getRBracketLoc
CXExpr clang_VariableArrayType_getSizeExpr(CXVariableArrayType T);

bool clang_VariableArrayType_isSugared(CXVariableArrayType T);

CXQualType clang_VariableArrayType_desugar(CXVariableArrayType T);

// DependentSizedArrayType
CXSourceRange_
clang_DependentSizedArrayType_getBracketsRange(CXDependentSizedArrayType T);

CXSourceLocation_ clang_DependentSizedArrayType_getLBracketLoc(CXDependentSizedArrayType T);

CXSourceLocation_ clang_DependentSizedArrayType_getRBracketLoc(CXDependentSizedArrayType T);
// getLBracketLoc
// getRBracketLoc
CXExpr clang_DependentSizedArrayType_getSizeExpr(CXDependentSizedArrayType T);

bool clang_DependentSizedArrayType_isSugared(CXDependentSizedArrayType T);

CXQualType clang_DependentSizedArrayType_desugar(CXDependentSizedArrayType T);

// DependentAddressSpaceType
CXExpr clang_DependentAddressSpaceType_getAddrSpaceExpr(CXDependentAddressSpaceType T);

CXQualType clang_DependentAddressSpaceType_getPointeeType(CXDependentAddressSpaceType T);

CXSourceLocation_
clang_DependentAddressSpaceType_getAttributeLoc(CXDependentAddressSpaceType T);

bool clang_DependentAddressSpaceType_isSugared(CXDependentAddressSpaceType T);

CXQualType clang_DependentAddressSpaceType_desugar(CXDependentAddressSpaceType T);

// DependentSizedExtVectorType
CXExpr clang_DependentSizedExtVectorType_getSizeExpr(CXDependentSizedExtVectorType T);

CXQualType
clang_DependentSizedExtVectorType_getElementType(CXDependentSizedExtVectorType T);

CXSourceLocation_
clang_DependentSizedExtVectorType_getAttributeLoc(CXDependentSizedExtVectorType T);

bool clang_DependentSizedExtVectorType_isSugared(CXDependentSizedExtVectorType T);

CXQualType clang_DependentSizedExtVectorType_desugar(CXDependentSizedExtVectorType T);

// VectorKind
typedef enum CXVectorKind {
  CXVectorKind_Generic,
  CXVectorKind_AltiVecVector,
  CXVectorKind_AltiVecPixel,
  CXVectorKind_AltiVecBool,
  CXVectorKind_Neon,
  CXVectorKind_NeonPoly,
  CXVectorKind_SveFixedLengthData,
  CXVectorKind_SveFixedLengthPredicate,
  CXVectorKind_RVVFixedLengthData,
  CXVectorKind_RVVFixedLengthMask
} CXVectorKind;

// VectorType
CXQualType clang_VectorType_getElementType(CXVectorType T);

unsigned clang_VectorType_getNumElements(CXVectorType T);

bool clang_VectorType_isSugared(CXVectorType T);

CXQualType clang_VectorType_desugar(CXVectorType T);

CXVectorKind clang_VectorType_getVectorKind(CXVectorType T);

// getVectorKind
// getElementType
// getNumElements

// DependentVectorType
// getElementType
CXQualType clang_DependentVectorType_getElementType(CXDependentVectorType T);

CXExpr clang_DependentVectorType_getSizeExpr(CXDependentVectorType T);

CXSourceLocation_ clang_DependentVectorType_getAttributeLoc(CXDependentVectorType T);

CXVectorKind clang_DependentVectorType_getVectorKind(CXDependentVectorType T);

bool clang_DependentVectorType_isSugared(CXDependentVectorType T);

CXQualType clang_DependentVectorType_desugar(CXDependentVectorType T);

// ExtVectorType
// The static accessor-character decoders. None takes an ExtVectorType receiver, and each
// answers -1 for a character naming no component: getPointAccessorIdx decodes the xyzw and
// rgba spellings, getNumericAccessorIdx the hexadecimal sN spellings (0-9, a-f, A-F), and
// getAccessorIdx dispatches between the two on IsNumericAccessor.
int clang_ExtVectorType_getPointAccessorIdx(char C);

int clang_ExtVectorType_getNumericAccessorIdx(char C);

int clang_ExtVectorType_getAccessorIdx(char C, bool IsNumericAccessor);

// The one ExtVectorType accessor that takes a receiver: true when C names a component this
// vector actually has, i.e. clang_ExtVectorType_getAccessorIdx(C, IsNumericAccessor)
// decodes to an index below getNumElements(). A character naming no component is false.
bool clang_ExtVectorType_isAccessorWithinNumElements(CXExtVectorType T, char C,
                                                     bool IsNumericAccessor);

// An ExtVectorType is a canonical leaf: it is never sugar, and desugaring hands back the
// node itself.
bool clang_ExtVectorType_isSugared(CXExtVectorType T);

CXQualType clang_ExtVectorType_desugar(CXExtVectorType T);

// MatrixType
// Static: whether T may be a matrix element type (a dependent type, an integer type that
// is neither bool nor an enumeration, or a real floating type). It takes no MatrixType
// receiver.
// PRECONDITION (Invariant 3): T must be non-null; MatrixType::isValidElementType reaches
// the type with operator->. The Julia wrapper restates it.
bool clang_MatrixType_isValidElementType(CXQualType T);
// getElementType

CXQualType clang_MatrixType_getElementType(CXMatrixType T);

bool clang_MatrixType_isSugared(CXMatrixType T);

CXQualType clang_MatrixType_desugar(CXMatrixType T);

// ConstantMatrixType
// Static: the per-dimension element cap and its validity predicate. Neither takes a
// ConstantMatrixType receiver.
unsigned clang_ConstantMatrixType_getMaxElementsPerDimension(void);

bool clang_ConstantMatrixType_isDimensionValid(size_t NumElements);
// getNumRows
// getNumColumns
// getNumElementsFlattened

unsigned clang_ConstantMatrixType_getNumRows(CXConstantMatrixType T);

unsigned clang_ConstantMatrixType_getNumColumns(CXConstantMatrixType T);

unsigned clang_ConstantMatrixType_getNumElementsFlattened(CXConstantMatrixType T);

// DependentSizedMatrixType
CXExpr clang_DependentSizedMatrixType_getRowExpr(CXDependentSizedMatrixType T);

CXExpr clang_DependentSizedMatrixType_getColumnExpr(CXDependentSizedMatrixType T);

CXSourceLocation_
clang_DependentSizedMatrixType_getAttributeLoc(CXDependentSizedMatrixType T);

// FunctionType
CXQualType clang_FunctionType_getReturnType(CXFunctionType T);

// ArmStateValue
// Mirrors clang::FunctionType::ArmStateValue.
typedef enum CXArmStateValue : unsigned {
  CXArmStateValue_ARM_None = 0,
  CXArmStateValue_ARM_Preserves = 1,
  CXArmStateValue_ARM_In = 2,
  CXArmStateValue_ARM_Out = 3,
  CXArmStateValue_ARM_InOut = 4
} CXArmStateValue;

// Static: the two state fields packed into the AArch64 SME attribute word that
// clang_FunctionProtoType_getAArch64SMEAttributes returns (ZA at bits 2-4, ZT0 at bits
// 5-7). Neither takes a FunctionType receiver.
// PRECONDITION (Invariant 3): each field is three bits wide but only 0..4 name an
// ArmStateValue, so a hand-built AttrBits word can carry a value clang never stores and
// the returned enum would then be out of range. The Julia wrappers restate it.
CXArmStateValue clang_FunctionType_getArmZAState(unsigned AttrBits);

CXArmStateValue clang_FunctionType_getArmZT0State(unsigned AttrBits);

bool clang_FunctionType_getHasRegParm(CXFunctionType T);

unsigned clang_FunctionType_getRegParmType(CXFunctionType T);

bool clang_FunctionType_getNoReturnAttr(CXFunctionType T);

bool clang_FunctionType_getCmseNSCallAttr(CXFunctionType T);

// helper: clang::FunctionType has no getProducesResult / getNoCallerSavedRegs /
// getNoCfCheck of its own -- the three live on the by-value FunctionType::ExtInfo, whose
// Bits field is private, so ExtInfo cannot cross as an opaque encoding the way
// ExtParameterInfo does (MARSHALLING.md §7). Each composes getExtInfo() with the matching
// ExtInfo accessor, alongside the 1:1 getNoReturnAttr / getCmseNSCallAttr pair above.
bool clang_FunctionType_getProducesResult(CXFunctionType T);

bool clang_FunctionType_getNoCallerSavedRegs(CXFunctionType T);

bool clang_FunctionType_getNoCfCheck(CXFunctionType T);

bool clang_FunctionType_isConst(CXFunctionType T);

bool clang_FunctionType_isRestrict(CXFunctionType T);

bool clang_FunctionType_isVolatile(CXFunctionType T);

// getCallConv
CXCallingConv_ clang_FunctionType_getCallConv(CXFunctionType T);

CXQualType clang_FunctionType_getCallResultType(CXFunctionType T, CXASTContext Ctx);
// getCallResultType
// getNameForCallConv
CXString clang_FunctionType_getNameForCallConv(CXCallingConv_ CC);

// FunctionType::ExtParameterInfo
// The ExtParameterInfo value type has no handle of its own: it crosses as the opaque
// `unsigned char` encoding of MARSHALLING.md §7 -- the same encoding
// clang_FunctionProtoType_getExtParameterInfo returns. Every wrapper below rebuilds its
// receiver with ExtParameterInfo::getFromOpaqueValue and re-serialises an
// ExtParameterInfo result with getOpaqueValue, so nothing is allocated and nothing needs
// disposing. ExtParameterInfo::getOpaqueValue and ::getFromOpaqueValue are the identity
// on this surface and are therefore not wrapped.
CXParameterABI clang_ExtParameterInfo_getABI(unsigned char Info);

unsigned char clang_ExtParameterInfo_withABI(unsigned char Info, CXParameterABI Kind);

bool clang_ExtParameterInfo_isConsumed(unsigned char Info);

unsigned char clang_ExtParameterInfo_withIsConsumed(unsigned char Info, bool Consumed);

bool clang_ExtParameterInfo_hasPassObjectSize(unsigned char Info);

// clang::FunctionType::ExtParameterInfo::withHasPassObjectSize only ever sets the bit, so
// there is no flag-taking form to mirror.
unsigned char clang_ExtParameterInfo_withHasPassObjectSize(unsigned char Info);

bool clang_ExtParameterInfo_isNoEscape(unsigned char Info);

unsigned char clang_ExtParameterInfo_withIsNoEscape(unsigned char Info, bool NoEscape);

// FunctionNoProtoType
bool clang_FunctionNoProtoType_isSugared(CXFunctionNoProtoType T);

CXQualType clang_FunctionNoProtoType_desugar(CXFunctionNoProtoType T);

// FunctionProtoType
// clang::FunctionProtoType::getMethodQuals returns a Qualifiers value; it
// crosses as its opaque unsigned encoding (MARSHALLING.md §7), rebuilt with
// Qualifiers::fromOpaqueValue.
unsigned clang_FunctionProtoType_getMethodQuals(CXFunctionProtoType T);

// PRECONDITION: I < getNumParams(). clang asserts it and this shim does not
// check; the Julia wrapper restates it as an @assert.
bool clang_FunctionProtoType_isParamConsumed(CXFunctionProtoType T, unsigned I);
unsigned clang_FunctionProtoType_getNumParams(CXFunctionProtoType T);

CXQualType clang_FunctionProtoType_getParamType(CXFunctionProtoType T, unsigned i);

CXArrayRef clang_FunctionProtoType_getParamTypes(CXFunctionProtoType T);

CXExceptionSpecificationType
clang_FunctionProtoType_getExceptionSpecType(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasDynamicExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasNoexceptExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasDependentExceptionSpec(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(CXFunctionProtoType T);

unsigned clang_FunctionProtoType_getNumExceptions(CXFunctionProtoType T);

CXQualType clang_FunctionProtoType_getExceptionType(CXFunctionProtoType T, unsigned i);

CXExpr clang_FunctionProtoType_getNoexceptExpr(CXFunctionProtoType T);

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecDecl(CXFunctionProtoType T);

CXFunctionDecl clang_FunctionProtoType_getExceptionSpecTemplate(CXFunctionProtoType T);

bool clang_FunctionProtoType_isNothrow(CXFunctionProtoType T);

bool clang_FunctionProtoType_isVariadic(CXFunctionProtoType T);

bool clang_FunctionProtoType_isTemplateVariadic(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasTrailingReturn(CXFunctionProtoType T);

CXArrayRef clang_FunctionProtoType_param_types(CXFunctionProtoType T);

CXArrayRef clang_FunctionProtoType_exceptions(CXFunctionProtoType T);

bool clang_FunctionProtoType_isSugared(CXFunctionProtoType T);

CXQualType clang_FunctionProtoType_desugar(CXFunctionProtoType T);

// clang::FunctionProtoType::printExceptionSpecification streams into a raw_ostream, so its
// output crosses as a copied CXString (MARSHALLING.md §5) under Ctx's own
// getPrintingPolicy(). A prototype with no exception specification prints "".
CXString clang_FunctionProtoType_printExceptionSpecificationAsString(CXFunctionProtoType T,
                                                                     CXASTContext Ctx);

CXSourceLocation_ clang_FunctionProtoType_getEllipsisLoc(CXFunctionProtoType T);

bool clang_FunctionProtoType_hasExtParameterInfos(CXFunctionProtoType T);

// PRECONDITION: I < getNumParams(). clang asserts it and this shim does not check; the
// Julia wrapper restates it as an @assert. The result is the opaque unsigned char
// ExtParameterInfo encoding shared with the clang_ExtParameterInfo_* family; a function
// type carrying no extra parameter info reads back 0 for every parameter.
unsigned char clang_FunctionProtoType_getExtParameterInfo(CXFunctionProtoType T,
                                                          unsigned I);

// PRECONDITION: I < getNumParams(), for the same reason as above. A function type with no
// extra parameter info reports CXParameterABI_Ordinary for every parameter.
CXParameterABI clang_FunctionProtoType_getParameterABI(CXFunctionProtoType T, unsigned I);

// Mirrors clang::RefQualifierKind (clang/AST/Type.h), placed ahead of the accessor
// that returns it.
typedef enum CXRefQualifierKind {
  CXRefQualifierKind_RQ_None,
  CXRefQualifierKind_RQ_LValue,
  CXRefQualifierKind_RQ_RValue
} CXRefQualifierKind;

CXRefQualifierKind clang_FunctionProtoType_getRefQualifier(CXFunctionProtoType T);

CXCanThrowResult clang_FunctionProtoType_canThrow(CXFunctionProtoType T);

// A bitmask of clang::FunctionType::AArch64SMETypeAttributes bits; every function
// type without SME attributes reads back 0 (SME_NormalFunction).
unsigned clang_FunctionProtoType_getAArch64SMEAttributes(CXFunctionProtoType T);

// UnresolvedUsingType
CXUnresolvedUsingTypenameDecl clang_UnresolvedUsingType_getDecl(CXUnresolvedUsingType T);

bool clang_UnresolvedUsingType_isSugared(CXUnresolvedUsingType T);

CXQualType clang_UnresolvedUsingType_desugar(CXUnresolvedUsingType T);

// UsingType
CXUsingShadowDecl clang_UsingType_getFoundDecl(CXUsingType T);

CXQualType clang_UsingType_getUnderlyingType(CXUsingType T);

bool clang_UsingType_isSugared(CXUsingType T);

CXQualType clang_UsingType_desugar(CXUsingType T);

bool clang_UsingType_typeMatchesDecl(CXUsingType T);

// TypedefType
CXTypedefNameDecl clang_TypedefType_getDecl(CXTypedefType T);

bool clang_TypedefType_isSugared(CXTypedefType T);

CXQualType clang_TypedefType_desugar(CXTypedefType T);

bool clang_TypedefType_typeMatchesDecl(CXTypedefType T);

// MacroQualifiedType
CXIdentifierInfo clang_MacroQualifiedType_getMacroIdentifier(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_getUnderlyingType(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_getModifiedType(CXMacroQualifiedType T);

bool clang_MacroQualifiedType_isSugared(CXMacroQualifiedType T);

CXQualType clang_MacroQualifiedType_desugar(CXMacroQualifiedType T);

// TypeOfExprType
// Mirrors clang::TypeOfKind (clang/AST/Type.h), shared by TypeOfExprType and TypeOfType.
// Declared here because this is the first section whose accessors return it.
typedef enum CXTypeOfKind : unsigned char {
  CXTypeOfKind_Qualified,
  CXTypeOfKind_Unqualified
} CXTypeOfKind;

CXExpr clang_TypeOfExprType_getUnderlyingExpr(CXTypeOfExprType T);

CXTypeOfKind clang_TypeOfExprType_getKind(CXTypeOfExprType T);

CXQualType clang_TypeOfExprType_desugar(CXTypeOfExprType T);

bool clang_TypeOfExprType_isSugared(CXTypeOfExprType T);

// DependentTypeOfExprType

// TypeOfType
// getUnmodifiedType
CXQualType clang_TypeOfType_getUnmodifiedType(CXTypeOfType T);

CXQualType clang_TypeOfType_desugar(CXTypeOfType T);

bool clang_TypeOfType_isSugared(CXTypeOfType T);

CXTypeOfKind clang_TypeOfType_getKind(CXTypeOfType T);

// DecltypeType
CXExpr clang_DecltypeType_getUnderlyingExpr(CXDecltypeType T);

CXQualType clang_DecltypeType_getUnderlyingType(CXDecltypeType T);

bool clang_DecltypeType_isSugared(CXDecltypeType T);

CXQualType clang_DecltypeType_desugar(CXDecltypeType T);

// DependentDecltypeType

// UnaryTransformType

bool clang_UnaryTransformType_isSugared(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_desugar(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_getUnderlyingType(CXUnaryTransformType T);

CXQualType clang_UnaryTransformType_getBaseType(CXUnaryTransformType T);

// UTTKind
// Mirrors clang::UnaryTransformType::UTTKind, in clang/Basic/TransformTypeTraits.def
// order.
typedef enum CXUTTKind {
  CXUTTKind_AddLvalueReference,
  CXUTTKind_AddPointer,
  CXUTTKind_AddRvalueReference,
  CXUTTKind_Decay,
  CXUTTKind_MakeSigned,
  CXUTTKind_MakeUnsigned,
  CXUTTKind_RemoveAllExtents,
  CXUTTKind_RemoveConst,
  CXUTTKind_RemoveCV,
  CXUTTKind_RemoveCVRef,
  CXUTTKind_RemoveExtent,
  CXUTTKind_RemovePointer,
  CXUTTKind_RemoveReference,
  CXUTTKind_RemoveRestrict,
  CXUTTKind_RemoveVolatile,
  CXUTTKind_EnumUnderlyingType
} CXUTTKind;

CXUTTKind clang_UnaryTransformType_getUTTKind(CXUnaryTransformType T);

// DependentUnaryTransformType

// TagType
CXTagDecl clang_TagType_getDecl(CXTagType T);

bool clang_TagType_isBeingDefined(CXTagType T);

// isBeingDefined

// RecordType
CXRecordDecl clang_RecordType_getDecl(CXRecordType T);

bool clang_RecordType_hasConstFields(CXRecordType T);

bool clang_RecordType_isSugared(CXRecordType T);

CXQualType clang_RecordType_desugar(CXRecordType T);

// EnumType
CXEnumDecl clang_EnumType_getDecl(CXEnumType T);

bool clang_EnumType_isSugared(CXEnumType T);

CXQualType clang_EnumType_desugar(CXEnumType T);

// AttributedType
// getAttrKind
CXAttrKind clang_AttributedType_getAttrKind(CXAttributedType T);
CXQualType clang_AttributedType_getModifiedType(CXAttributedType T);

CXQualType clang_AttributedType_getEquivalentType(CXAttributedType T);

bool clang_AttributedType_isSugared(CXAttributedType T);

CXQualType clang_AttributedType_desugar(CXAttributedType T);

bool clang_AttributedType_isQualifier(CXAttributedType T);

bool clang_AttributedType_isMSTypeSpec(CXAttributedType T);

bool clang_AttributedType_isWebAssemblyFuncrefSpec(CXAttributedType T);

bool clang_AttributedType_isCallingConv(CXAttributedType T);

// isQualifier
// isMSTypeSpec
// isCallingConv
// getImmediateNullability
// clang::AttributedType::getImmediateNullability returns std::optional<NullabilityKind>:
// engaged -> fills *Out and returns true; disengaged (this attribute is not a nullability
// attribute) -> returns false with *Out untouched (MARSHALLING.md §8). Out may not be
// NULL. Unlike clang_Type_getNullability this answers for T alone and looks through no
// sugar.
bool clang_AttributedType_getImmediateNullability(CXAttributedType T,
                                                  CXNullabilityKind *Out);

// Static: the attr::Kind that spells one nullability kind. Takes no receiver.
CXAttrKind clang_AttributedType_getNullabilityAttrKind(CXNullabilityKind Kind);

// Static in-out: *T is read as the type to strip and, when a top-level nullability
// AttributedType is peeled off, overwritten with that node's modified type; it is left
// unchanged otherwise. Engaged -> *Out receives the stripped kind and the call returns
// true; disengaged -> returns false with *Out untouched (MARSHALLING.md §8). Neither
// out-param may be NULL.
// PRECONDITION (Invariant 3): *T must be a non-null QualType -- the dyn_cast chain reaches
// the type through QualType::getTypePtr(), which asserts !isNull(). The Julia wrapper
// restates it.
bool clang_AttributedType_stripOuterNullability(CXQualType *T, CXNullabilityKind *Out);

// BTFTagAttributedType

// TemplateTypeParmType
unsigned clang_TemplateTypeParmType_getDepth(CXTemplateTypeParmType T);

unsigned clang_TemplateTypeParmType_getIndex(CXTemplateTypeParmType T);

bool clang_TemplateTypeParmType_isParameterPack(CXTemplateTypeParmType T);

CXTemplateTypeParmDecl clang_TemplateTypeParmType_getDecl(CXTemplateTypeParmType T);

bool clang_TemplateTypeParmType_isSugared(CXTemplateTypeParmType T);

CXQualType clang_TemplateTypeParmType_desugar(CXTemplateTypeParmType T);

CXIdentifierInfo clang_TemplateTypeParmType_getIdentifier(CXTemplateTypeParmType T);

// SubstTemplateTypeParmType
CXQualType
clang_SubstTemplateTypeParmType_getReplacementType(CXSubstTemplateTypeParmType T);

CXDecl clang_SubstTemplateTypeParmType_getAssociatedDecl(CXSubstTemplateTypeParmType T);

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmType_getReplacedParameter(CXSubstTemplateTypeParmType T);

unsigned clang_SubstTemplateTypeParmType_getIndex(CXSubstTemplateTypeParmType T);

// SubstTemplateTypeParmType::getPackIndex is optional<unsigned>: engaged -> true with *Out
// filled, disengaged (the replaced parameter was not a pack) -> false with *Out untouched
// (MARSHALLING.md §8).
bool clang_SubstTemplateTypeParmType_getPackIndex(CXSubstTemplateTypeParmType T,
                                                  unsigned *Out);

bool clang_SubstTemplateTypeParmType_isSugared(CXSubstTemplateTypeParmType T);

CXQualType clang_SubstTemplateTypeParmType_desugar(CXSubstTemplateTypeParmType T);

// SubstTemplateTypeParmPackType
CXDecl
clang_SubstTemplateTypeParmPackType_getAssociatedDecl(CXSubstTemplateTypeParmPackType T);

CXTemplateTypeParmDecl
clang_SubstTemplateTypeParmPackType_getReplacedParameter(CXSubstTemplateTypeParmPackType T);

unsigned clang_SubstTemplateTypeParmPackType_getIndex(CXSubstTemplateTypeParmPackType T);

bool clang_SubstTemplateTypeParmPackType_getFinal(CXSubstTemplateTypeParmPackType T);

unsigned clang_SubstTemplateTypeParmPackType_getNumArgs(CXSubstTemplateTypeParmPackType T);

bool clang_SubstTemplateTypeParmPackType_isSugared(CXSubstTemplateTypeParmPackType T);

CXQualType clang_SubstTemplateTypeParmPackType_desugar(CXSubstTemplateTypeParmPackType T);

CXArrayRef
clang_SubstTemplateTypeParmPackType_getArgumentPack(CXSubstTemplateTypeParmPackType T);

// DeducedType
bool clang_DeducedType_isSugared(CXDeducedType T);

CXQualType clang_DeducedType_desugar(CXDeducedType T);

CXQualType clang_DeducedType_getDeducedType(CXDeducedType T);

bool clang_DeducedType_isDeduced(CXDeducedType T);

// AutoType
typedef enum CXAutoTypeKeyword {
  CXAutoTypeKeyword_Auto,
  CXAutoTypeKeyword_DecltypeAuto,
  CXAutoTypeKeyword_GNUAutoType
} CXAutoTypeKeyword;
// getTypeConstraintArguments
// Borrowed CXArrayRef view of the AST-owned TemplateArgument array behind the type
// constraint; empty for an unconstrained `auto`, and never freed.
CXArrayRef clang_AutoType_getTypeConstraintArguments(CXAutoType T);
CXConceptDecl clang_AutoType_getTypeConstraintConcept(CXAutoType T);

bool clang_AutoType_isConstrained(CXAutoType T);

bool clang_AutoType_isDecltypeAuto(CXAutoType T);

bool clang_AutoType_isGNUAutoType(CXAutoType T);

CXAutoTypeKeyword clang_AutoType_getKeyword(CXAutoType T);

// getKeyword

// DeducedTemplateSpecializationType
CXTemplateName clang_DeducedTemplateSpecializationType_getTemplateName(
    CXDeducedTemplateSpecializationType T);

// TemplateSpecializationType
bool clang_TemplateSpecializationType_isCurrentInstantiation(
    CXTemplateSpecializationType T);

bool clang_TemplateSpecializationType_isTypeAlias(CXTemplateSpecializationType T);

CXQualType clang_TemplateSpecializationType_getAliasedType(CXTemplateSpecializationType T);

CXTemplateName
clang_TemplateSpecializationType_getTemplateName(CXTemplateSpecializationType T);

CXArrayRef
clang_TemplateSpecializationType_template_arguments(CXTemplateSpecializationType T);

// TemplateSpecializationType has no getNumArgs()/getArg() in this LLVM version;
// these compose the count+index idiom over template_arguments() so callers get
// correctly-strided per-element access (getArg borrows an interior pointer).
unsigned clang_TemplateSpecializationType_getNumArgs(CXTemplateSpecializationType T);

CXTemplateArgument
clang_TemplateSpecializationType_getArg(CXTemplateSpecializationType T, unsigned Idx);

bool clang_TemplateSpecializationType_isSugared(CXTemplateSpecializationType T);

CXQualType clang_TemplateSpecializationType_desugar(CXTemplateSpecializationType T);

// InjectedClassNameType
CXQualType
clang_InjectedClassNameType_getInjectedSpecializationType(CXInjectedClassNameType T);

CXTemplateSpecializationType
clang_InjectedClassNameType_getInjectedTST(CXInjectedClassNameType T);

CXTemplateName clang_InjectedClassNameType_getTemplateName(CXInjectedClassNameType T);

CXCXXRecordDecl clang_InjectedClassNameType_getDecl(CXInjectedClassNameType T);

bool clang_InjectedClassNameType_isSugared(CXInjectedClassNameType T);

CXQualType clang_InjectedClassNameType_desugar(CXInjectedClassNameType T);

// TypeWithKeyword

// ElaboratedType
CXNestedNameSpecifier clang_ElaboratedType_getQualifier(CXElaboratedType T);

CXQualType clang_ElaboratedType_getNamedType(CXElaboratedType T);

CXQualType clang_ElaboratedType_desugar(CXElaboratedType T);

bool clang_ElaboratedType_isSugared(CXElaboratedType T);

CXTagDecl clang_ElaboratedType_getOwnedTagDecl(CXElaboratedType T);

// DependentNameType
CXNestedNameSpecifier clang_DependentNameType_getQualifier(CXDependentNameType T);

CXIdentifierInfo clang_DependentNameType_getIdentifier(CXDependentNameType T);

bool clang_DependentNameType_isSugared(CXDependentNameType T);

CXQualType clang_DependentNameType_desugar(CXDependentNameType T);

// DependentTemplateSpecializationType
CXNestedNameSpecifier clang_DependentTemplateSpecializationType_getQualifier(
    CXDependentTemplateSpecializationType T);

CXIdentifierInfo clang_DependentTemplateSpecializationType_getIdentifier(
    CXDependentTemplateSpecializationType T);

CXArrayRef clang_DependentTemplateSpecializationType_template_arguments(
    CXDependentTemplateSpecializationType T);

bool clang_DependentTemplateSpecializationType_isSugared(
    CXDependentTemplateSpecializationType T);

CXQualType
clang_DependentTemplateSpecializationType_desugar(CXDependentTemplateSpecializationType T);

// PackExpansionType
CXQualType clang_PackExpansionType_getPattern(CXPackExpansionType T);

// PackExpansionType::getNumExpansions is optional<unsigned>: engaged -> fills
// *N and returns true; disengaged -> returns false, *N untouched.
bool clang_PackExpansionType_getNumExpansions(CXPackExpansionType T, unsigned *N);

bool clang_PackExpansionType_isSugared(CXPackExpansionType T);

CXQualType clang_PackExpansionType_desugar(CXPackExpansionType T);

// isSugared
// desugar

// AtomicType
CXQualType clang_AtomicType_getValueType(CXAtomicType T);

bool clang_AtomicType_isSugared(CXAtomicType T);

CXQualType clang_AtomicType_desugar(CXAtomicType T);

// PipeType
// An OpenCL pipe. clang builds these through ASTContext::getReadPipeType /
// getWritePipeType as well as from the `pipe` keyword, so a PipeType node is reachable
// from a translation unit in any language mode. A read pipe and a write pipe over the same
// element type are distinct nodes -- isReadOnly is part of the folding profile.
CXQualType clang_PipeType_getElementType(CXPipeType T);

bool clang_PipeType_isSugared(CXPipeType T);

CXQualType clang_PipeType_desugar(CXPipeType T);

bool clang_PipeType_isReadOnly(CXPipeType T);

// BitIntType
bool clang_BitIntType_isUnsigned(CXBitIntType T);

bool clang_BitIntType_isSigned(CXBitIntType T);

unsigned clang_BitIntType_getNumBits(CXBitIntType T);

bool clang_BitIntType_isSugared(CXBitIntType T);

CXQualType clang_BitIntType_desugar(CXBitIntType T);

// DependentBitIntType
bool clang_DependentBitIntType_isUnsigned(CXDependentBitIntType T);
// isSigned
bool clang_DependentBitIntType_isSigned(CXDependentBitIntType T);

CXExpr clang_DependentBitIntType_getNumBitsExpr(CXDependentBitIntType T);
// isSugared
// desugar

bool clang_DependentBitIntType_isSugared(CXDependentBitIntType T);

CXQualType clang_DependentBitIntType_desugar(CXDependentBitIntType T);

// TagTypeKind
typedef enum CXTagTypeKind {
  CXTagTypeKind_Struct,
  CXTagTypeKind_Interface,
  CXTagTypeKind_Union,
  CXTagTypeKind_Class,
  CXTagTypeKind_Enum
} CXTagTypeKind;

// ElaboratedTypeKeyword
typedef enum CXElaboratedTypeKeyword {
  CXElaboratedTypeKeyword_Struct,
  CXElaboratedTypeKeyword_Interface,
  CXElaboratedTypeKeyword_Union,
  CXElaboratedTypeKeyword_Class,
  CXElaboratedTypeKeyword_Enum,
  CXElaboratedTypeKeyword_Typename,
  CXElaboratedTypeKeyword_None
} CXElaboratedTypeKeyword;

CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeyword(CXTypeWithKeyword T);

// Static: the two DeclSpec::TST conversions. TypeSpec is a clang type-specifier value with
// no mirrored CX enum, so it crosses as a plain unsigned; getKeywordForTypeSpec answers
// CXElaboratedTypeKeyword_None for anything that is not a tag specifier.
CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeywordForTypeSpec(unsigned TypeSpec);

// PRECONDITION (Invariant 3): TypeSpec must name a tag specifier. clang documents "it is an
// error to provide a type specifier which *isn't* a tag kind here" and the implementation
// falls off into llvm_unreachable otherwise. The gate is getKeywordForTypeSpec above
// answering something other than CXElaboratedTypeKeyword_None; the Julia wrapper restates
// it.
CXTagTypeKind clang_TypeWithKeyword_getTagTypeKindForTypeSpec(unsigned TypeSpec);

// The static keyword/tag-kind conversion helpers below take no receiver.
CXElaboratedTypeKeyword clang_TypeWithKeyword_getKeywordForTagTypeKind(CXTagTypeKind Tag);

// PRECONDITION (Invariant 3): Keyword must name a tag kind. Clang documents "it is an
// error to provide an elaborated type keyword which *isn't* a tag kind here" and the
// implementation falls off into llvm_unreachable for Typename and None. The gate is
// clang_TypeWithKeyword_KeywordIsTagTypeKind; the Julia wrapper restates it.
CXTagTypeKind
clang_TypeWithKeyword_getTagTypeKindForKeyword(CXElaboratedTypeKeyword Keyword);

bool clang_TypeWithKeyword_KeywordIsTagTypeKind(CXElaboratedTypeKeyword Keyword);

// clang::TypeWithKeyword::getKeywordName returns a StringRef whose data pointer is null
// for ElaboratedTypeKeyword::None, so it crosses as a copied CXString (MARSHALLING.md
// §5) rather than a borrowed const char*.
CXString clang_TypeWithKeyword_getKeywordName(CXElaboratedTypeKeyword Keyword);

CXString clang_TypeWithKeyword_getTagTypeKindName(CXTagTypeKind Kind);

// TypeSourceInfo
CXQualType clang_TypeSourceInfo_getType(CXTypeSourceInfo TSI);

// Overwrites the type stored in the TypeSourceInfo while leaving its TypeLoc data
// untouched, so the written source information can disagree with the type; clang
// marks it "use with caution".
void clang_TypeSourceInfo_overrideType(CXTypeSourceInfo TSI, CXQualType T);

LLVM_CLANG_C_EXTERN_C_END

#endif