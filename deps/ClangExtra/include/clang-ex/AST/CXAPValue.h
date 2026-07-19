#ifndef LLVM_CLANG_C_EXTRA_CXAPVALUE_H
#define LLVM_CLANG_C_EXTRA_CXAPVALUE_H

#include "clang-ex/CXTypes.h"
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

unsigned clang_APValue_getStructNumFields(CXAPValue V);

CXAPValue clang_APValue_getStructField(CXAPValue V, unsigned I);

// Release an owned APValue (one produced by clang_Expr_EvaluateAsRValue). Never
// call on a borrowed element or on VarDecl::evaluateValue's cached result.
void clang_APValue_dispose(CXAPValue V);

LLVM_CLANG_C_EXTERN_C_END

#endif
