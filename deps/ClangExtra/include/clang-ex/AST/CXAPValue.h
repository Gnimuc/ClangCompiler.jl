#ifndef LLVM_CLANG_C_EXTRA_CXAPVALUE_H
#define LLVM_CLANG_C_EXTRA_CXAPVALUE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::APValue::ValueKind (a plain enum). Kept in ValueKind
// declaration order; CXEnumSync.cpp proves value-for-value equality.
typedef enum CXAPValueKind {
  CXAPValueKind_None,
  CXAPValueKind_Indeterminate,
  CXAPValueKind_Int,
  CXAPValueKind_Float,
  CXAPValueKind_FixedPoint,
  CXAPValueKind_ComplexInt,
  CXAPValueKind_ComplexFloat,
  CXAPValueKind_LValue,
  CXAPValueKind_Vector,
  CXAPValueKind_Array,
  CXAPValueKind_Struct,
  CXAPValueKind_Union,
  CXAPValueKind_MemberPointer,
  CXAPValueKind_AddrLabelDiff
} CXAPValueKind;

// A freshly heap-boxed indeterminate value. Owned by the caller: release it with
// clang_APValue_dispose.
CXAPValue clang_APValue_IndeterminateValue(void);

// Exchanges the contents of the two values. Both handles stay valid and keep the
// ownership they already had.
void clang_APValue_swap(CXAPValue V, CXAPValue RHS);

CXAPValueKind clang_APValue_getKind(CXAPValue V);

bool clang_APValue_isInt(CXAPValue V);

bool clang_APValue_isFloat(CXAPValue V);

bool clang_APValue_isArray(CXAPValue V);

bool clang_APValue_isStruct(CXAPValue V);

bool clang_APValue_isAbsent(CXAPValue V);

bool clang_APValue_isIndeterminate(CXAPValue V);

bool clang_APValue_hasValue(CXAPValue V);

bool clang_APValue_isFixedPoint(CXAPValue V);

bool clang_APValue_isComplexInt(CXAPValue V);

bool clang_APValue_isComplexFloat(CXAPValue V);

bool clang_APValue_isLValue(CXAPValue V);

bool clang_APValue_isVector(CXAPValue V);

bool clang_APValue_isUnion(CXAPValue V);

bool clang_APValue_isMemberPointer(CXAPValue V);

bool clang_APValue_isAddrLabelDiff(CXAPValue V);

// helper: clang::APValue::Profile fills an llvm::FoldingSetNodeID, which has no CX
// handle — MARSHALLING.md section 7 (expose the useful scalar, not the aggregate).
// This runs the profile into a local ID and returns its hash, so two values with the
// same profile compare equal. It is a hash: equal profiles always agree, distinct ones
// agree only on a collision. Total over every kind; no precondition.
unsigned clang_APValue_getProfileHash(CXAPValue V);

// Pretty-prints the value the way it would appear in source. `T` must be the
// type the value was evaluated at.
CXString clang_APValue_getAsString(CXAPValue V, CXASTContext Ctx, CXQualType T);

// Integer/float leaves cross as LLVM's GenericValue (the APInt lives in
// GV->IntVal), matching clang_IntegerLiteral_getValue and the LLVM-type-reuse
// rule (MARSHALLING.md §0). getFloat stores the exact bits via
// APFloat::bitcastToAPInt (MARSHALLING.md §2). The GenericValue is caller-owned
// (allocated with `new`); the Julia layer disposes it via llvm-c.
LLVMGenericValueRef clang_APValue_getInt(CXAPValue V);

LLVMGenericValueRef clang_APValue_getFloat(CXAPValue V);

// Converts the value to an integral constant when it is an integer, a null pointer,
// or an offset from a null pointer; NULL when it is none of those (the nullptr
// sentinel of MARSHALLING.md §8). SrcTy must be the type the value was evaluated at:
// the two lvalue paths feed it to ASTContext::getTargetNullPointerValue and
// MakeIntValue, which need a complete pointer or integral type, while the integer
// path ignores it. The GenericValue is caller-owned; the Julia layer disposes it via
// llvm-c.
LLVMGenericValueRef clang_APValue_toIntegralConstant(CXAPValue V, CXQualType SrcTy,
                                                     CXASTContext Ctx);

// Aggregate navigation. The returned element CXAPValue is BORROWED — it is
// interior to the parent APValue and must NOT be disposed; it is invalidated
// when the parent is disposed.
unsigned clang_APValue_getArraySize(CXAPValue V);

unsigned clang_APValue_getArrayInitializedElts(CXAPValue V);

CXAPValue clang_APValue_getArrayInitializedElt(CXAPValue V, unsigned I);

// Precondition: isArray() — hasArrayFiller() reads getArrayInitializedElts(),
// which asserts it. getArrayFiller() additionally requires hasArrayFiller().
bool clang_APValue_hasArrayFiller(CXAPValue V);

CXAPValue clang_APValue_getArrayFiller(CXAPValue V);

unsigned clang_APValue_getStructNumFields(CXAPValue V);

CXAPValue clang_APValue_getStructField(CXAPValue V, unsigned I);

// Precondition: isStruct(), and I < getStructNumBases() for getStructBase.
unsigned clang_APValue_getStructNumBases(CXAPValue V);

CXAPValue clang_APValue_getStructBase(CXAPValue V, unsigned I);

// Precondition: isUnion(). getUnionField may still return NULL when the union
// value has no active member.
CXFieldDecl clang_APValue_getUnionField(CXAPValue V);

CXAPValue clang_APValue_getUnionValue(CXAPValue V);

// Precondition: isVector(), and I < getVectorLength() for getVectorElt.
unsigned clang_APValue_getVectorLength(CXAPValue V);

CXAPValue clang_APValue_getVectorElt(CXAPValue V, unsigned I);

// Whether the value owns heap storage its destructor must release. Total over
// every kind (aggregates are true, small scalars false); no precondition.
bool clang_APValue_needsCleanup(CXAPValue V);

// Complex leaves. Precondition: isComplexInt() for the Int pair, isComplexFloat()
// for the Float pair — each accessor asserts its own kind. They cross through the
// same GenericValue bridge as getInt/getFloat (MARSHALLING.md §1 and §2), so the
// float halves carry the exact bits via APFloat::bitcastToAPInt. The returned
// GenericValue is caller-owned; the Julia layer disposes it via llvm-c.
LLVMGenericValueRef clang_APValue_getComplexIntReal(CXAPValue V);

LLVMGenericValueRef clang_APValue_getComplexIntImag(CXAPValue V);

LLVMGenericValueRef clang_APValue_getComplexFloatReal(CXAPValue V);

LLVMGenericValueRef clang_APValue_getComplexFloatImag(CXAPValue V);

// LValue payload. Precondition for all six: isLValue(). getLValueOffset carries a
// CharUnits and crosses in bytes, matching the CharUnits convention in
// CXRecordLayout.h.
int64_t clang_APValue_getLValueOffset(CXAPValue V);

bool clang_APValue_isLValueOnePastTheEnd(CXAPValue V);

bool clang_APValue_hasLValuePath(CXAPValue V);

unsigned clang_APValue_getLValueCallIndex(CXAPValue V);

unsigned clang_APValue_getLValueVersion(CXAPValue V);

bool clang_APValue_isNullPointer(CXAPValue V);

// The designator the lvalue is based on, split into the arms of its PointerUnion
// (MARSHALLING.md §8): at most one of the two pointer accessors is non-NULL, and both
// are NULL for a null base and for the type-info / dynamic-allocation arms.
// Precondition for all four: isLValue().
CXValueDecl clang_APValue_getLValueBaseAsValueDecl(CXAPValue V);

CXExpr clang_APValue_getLValueBaseAsExpr(CXAPValue V);

// helper - APValue::getLValueBase().isNull().
bool clang_APValue_isLValueBaseNull(CXAPValue V);

// The type of the base designator; a null CXQualType when the base is null.
CXQualType clang_APValue_getLValueBaseType(CXAPValue V);

// The remaining two arms of the base designator's PointerUnion (MARSHALLING.md §8):
// a typeid(T) lvalue and a constant-evaluation dynamic allocation. Neither arm
// survives into a completed constant, so both predicates normally read false. Each
// payload accessor either reads its union arm unchecked or asserts it, so the
// preconditions are isLValue() plus the matching predicate below.
bool clang_APValue_isLValueBaseTypeInfo(CXAPValue V);

// helper - the operand type T of the typeid(T) the lvalue is based on, i.e.
// TypeInfoLValue::getType(). Precondition: isLValueBaseTypeInfo().
CXType_ clang_APValue_getLValueBaseTypeInfoOperand(CXAPValue V);

// The std::type_info type the lvalue itself has. Precondition:
// isLValueBaseTypeInfo() - LValueBase::getTypeInfoType() asserts the arm.
CXQualType clang_APValue_getLValueBaseTypeInfoType(CXAPValue V);

bool clang_APValue_isLValueBaseDynamicAlloc(CXAPValue V);

// helper - the allocation's index, i.e. DynamicAllocLValue::getIndex().
// Precondition: isLValueBaseDynamicAlloc().
unsigned clang_APValue_getLValueBaseDynamicAllocIndex(CXAPValue V);

// The allocated type. Precondition: isLValueBaseDynamicAlloc() -
// LValueBase::getDynamicAllocType() asserts the arm.
CXQualType clang_APValue_getLValueBaseDynamicAllocType(CXAPValue V);

// helper: the same FoldingSetNodeID-to-hash reduction applied to the base designator
// alone (APValue::LValueBase::Profile), which covers the base together with its call
// index and version but neither the byte offset nor the designator path.
// Precondition: isLValue().
unsigned clang_APValue_getLValueBaseProfileHash(CXAPValue V);

// The lvalue designator path, as a count + index pair (MARSHALLING.md §6).
// Precondition: isLValue() && hasLValuePath(), and I < getLValuePathLength(). A path
// entry is a bare 64-bit word; the array-index reading below is the meaningful one
// only while the type reached so far is an array, which the caller tracks itself.
unsigned clang_APValue_getLValuePathLength(CXAPValue V);

uint64_t clang_APValue_getLValuePathAsArrayIndex(CXAPValue V, unsigned I);

// The other reading of a path entry: LValuePathEntry::getAsBaseOrMember() unpacked into
// its two halves — the FieldDecl or CXXRecordDecl the entry designates, and the flag
// saying that record is a virtual base. Like the array-index reading above, this one is
// meaningful only while the type reached so far is a class type, which the caller tracks
// itself; on an array entry the stored index is reinterpreted as a pointer.
// Preconditions: isLValue() && hasLValuePath(), and I < getLValuePathLength().
CXDecl clang_APValue_getLValuePathAsBaseOrMember(CXAPValue V, unsigned I);

bool clang_APValue_isLValuePathBaseOrMemberVirtual(CXAPValue V, unsigned I);

// helper: LValuePathEntry::Profile reduced to its hash the same way
// clang_APValue_getProfileHash reduces APValue::Profile. Two entries designating the
// same base, member or array index hash equal. Preconditions: isLValue() &&
// hasLValuePath(), and I < getLValuePathLength().
unsigned clang_APValue_getLValuePathEntryProfileHash(CXAPValue V, unsigned I);

// Member-pointer payload. Precondition: isMemberPointer().
// getMemberPointerDecl returns NULL for a null member pointer.
CXValueDecl clang_APValue_getMemberPointerDecl(CXAPValue V);

bool clang_APValue_isMemberPointerToDerivedMember(CXAPValue V);

// The class chain recorded for a pointer to a member of a derived class, as a
// count + index pair (MARSHALLING.md §6); empty for a plain member pointer.
// Precondition: isMemberPointer(), and I < getMemberPointerPathSize().
unsigned clang_APValue_getMemberPointerPathSize(CXAPValue V);

CXCXXRecordDecl clang_APValue_getMemberPointerPathEntry(CXAPValue V, unsigned I);

// Address-of-label difference payload. Precondition: isAddrLabelDiff().
CXAddrLabelExpr clang_APValue_getAddrLabelDiffLHS(CXAPValue V);

CXAddrLabelExpr clang_APValue_getAddrLabelDiffRHS(CXAPValue V);

// Leaf mutators. Each C++ setter asserts that the value already holds its own kind — they
// overwrite the payload in place and never change the kind — so the precondition is the
// matching predicate. The incoming APSInt/APFloat ride the same GenericValue bridge the
// getters return on (MARSHALLING.md sections 1 and 2) and stay caller-owned.
// setInt takes the signedness the bridge cannot carry; the bit width crosses unchanged, so
// keep it the width of the type the value was evaluated at. Precondition: isInt().
void clang_APValue_setInt(CXAPValue V, LLVMGenericValueRef GV, bool IsUnsigned);

// The floating-point semantics are taken from the value's current float — the only
// description of them the bridge carries — and the incoming bit pattern is zero-extended
// or truncated to that width, so any GenericValue is accepted. Precondition: isFloat().
void clang_APValue_setFloat(CXAPValue V, LLVMGenericValueRef GV);

// clang::APValue::setComplexInt asserts the two halves share a bit width, so both are
// normalized to the width of the value's current real half. Precondition: isComplexInt().
void clang_APValue_setComplexInt(CXAPValue V, LLVMGenericValueRef Real,
                                 LLVMGenericValueRef Imag, bool IsUnsigned);

// Both halves take the semantics of the value's current real half, which also satisfies
// clang::APValue::setComplexFloat's same-semantics assertion.
// Precondition: isComplexFloat().
void clang_APValue_setComplexFloat(CXAPValue V, LLVMGenericValueRef Real,
                                   LLVMGenericValueRef Imag);

// Stores Field as the active member and copies Value into the union's payload. Value stays
// caller-owned and may be an element borrowed from another APValue; Field may be NULL,
// which leaves the union with no active member. Precondition: isUnion().
void clang_APValue_setUnion(CXAPValue V, CXFieldDecl Field, CXAPValue Value);

// Release an owned APValue (one produced by clang_Expr_EvaluateAsRValue). Never
// call on a borrowed element or on VarDecl::evaluateValue's cached result.
void clang_APValue_dispose(CXAPValue V);

// DynamicAllocLValue
// The largest index the dynamic-allocation encoding can represent. Static, and the
// class gets no handle of its own: every DynamicAllocLValue reachable from Julia
// lives inside an APValue's lvalue base.
unsigned clang_DynamicAllocLValue_getMaxIndex(void);

LLVM_CLANG_C_EXTERN_C_END

#endif
