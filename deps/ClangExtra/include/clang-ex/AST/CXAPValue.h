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

// Member-pointer payload. Precondition: isMemberPointer().
// getMemberPointerDecl returns NULL for a null member pointer.
CXValueDecl clang_APValue_getMemberPointerDecl(CXAPValue V);

bool clang_APValue_isMemberPointerToDerivedMember(CXAPValue V);

// Address-of-label difference payload. Precondition: isAddrLabelDiff().
CXAddrLabelExpr clang_APValue_getAddrLabelDiffLHS(CXAPValue V);

CXAddrLabelExpr clang_APValue_getAddrLabelDiffRHS(CXAPValue V);

// Release an owned APValue (one produced by clang_Expr_EvaluateAsRValue). Never
// call on a borrowed element or on VarDecl::evaluateValue's cached result.
void clang_APValue_dispose(CXAPValue V);

LLVM_CLANG_C_EXTERN_C_END

#endif
