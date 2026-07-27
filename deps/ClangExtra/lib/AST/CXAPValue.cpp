#include "clang-ex/AST/CXAPValue.h"
#include "utils.h"

#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/CharUnits.h"
#include "clang/AST/Decl.h"
#include "llvm/ExecutionEngine/GenericValue.h"

bool clang_APValue_needsCleanup(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->needsCleanup();
}

LLVMGenericValueRef clang_APValue_getComplexIntReal(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getComplexIntReal();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexIntImag(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getComplexIntImag();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexFloatReal(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getComplexFloatReal().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexFloatImag(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getComplexFloatImag().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

int64_t clang_APValue_getLValueOffset(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getLValueOffset().getQuantity();
}

bool clang_APValue_isLValueOnePastTheEnd(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isLValueOnePastTheEnd();
}

bool clang_APValue_hasLValuePath(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->hasLValuePath();
}

unsigned clang_APValue_getLValueCallIndex(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getLValueCallIndex();
}

unsigned clang_APValue_getLValueVersion(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getLValueVersion();
}

bool clang_APValue_isNullPointer(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isNullPointer();
}

CXValueDecl clang_APValue_getMemberPointerDecl(CXAPValue V) {
  return const_cast<clang::ValueDecl *>(
      static_cast<clang::APValue *>(V)->getMemberPointerDecl());
}

bool clang_APValue_isMemberPointerToDerivedMember(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isMemberPointerToDerivedMember();
}

CXAddrLabelExpr clang_APValue_getAddrLabelDiffLHS(CXAPValue V) {
  return const_cast<clang::AddrLabelExpr *>(
      static_cast<clang::APValue *>(V)->getAddrLabelDiffLHS());
}

CXAddrLabelExpr clang_APValue_getAddrLabelDiffRHS(CXAPValue V) {
  return const_cast<clang::AddrLabelExpr *>(
      static_cast<clang::APValue *>(V)->getAddrLabelDiffRHS());
}

CXAPValueKind clang_APValue_getKind(CXAPValue V) {
  return static_cast<CXAPValueKind>(static_cast<clang::APValue *>(V)->getKind());
}

bool clang_APValue_isInt(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isInt();
}

bool clang_APValue_isFloat(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isFloat();
}

bool clang_APValue_isArray(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isArray();
}

bool clang_APValue_isStruct(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isStruct();
}

bool clang_APValue_isAbsent(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isAbsent();
}

bool clang_APValue_isIndeterminate(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isIndeterminate();
}

bool clang_APValue_hasValue(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->hasValue();
}

bool clang_APValue_isFixedPoint(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isFixedPoint();
}

bool clang_APValue_isComplexInt(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isComplexInt();
}

bool clang_APValue_isComplexFloat(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isComplexFloat();
}

bool clang_APValue_isLValue(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isLValue();
}

bool clang_APValue_isVector(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isVector();
}

bool clang_APValue_isUnion(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isUnion();
}

bool clang_APValue_isMemberPointer(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isMemberPointer();
}

bool clang_APValue_isAddrLabelDiff(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->isAddrLabelDiff();
}

CXString clang_APValue_getAsString(CXAPValue V, CXASTContext Ctx, CXQualType T) {
  return extra::makeCXString(static_cast<clang::APValue *>(V)->getAsString(
      *static_cast<clang::ASTContext *>(Ctx), clang::QualType::getFromOpaquePtr(T)));
}

LLVMGenericValueRef clang_APValue_getInt(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getFloat(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::APValue *>(V)->getFloat().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

unsigned clang_APValue_getArraySize(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getArraySize();
}

unsigned clang_APValue_getArrayInitializedElts(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getArrayInitializedElts();
}

CXAPValue clang_APValue_getArrayInitializedElt(CXAPValue V, unsigned I) {
  return &static_cast<clang::APValue *>(V)->getArrayInitializedElt(I);
}

bool clang_APValue_hasArrayFiller(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->hasArrayFiller();
}

CXAPValue clang_APValue_getArrayFiller(CXAPValue V) {
  return &static_cast<clang::APValue *>(V)->getArrayFiller();
}

unsigned clang_APValue_getStructNumFields(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getStructNumFields();
}

CXAPValue clang_APValue_getStructField(CXAPValue V, unsigned I) {
  return &static_cast<clang::APValue *>(V)->getStructField(I);
}

unsigned clang_APValue_getStructNumBases(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getStructNumBases();
}

CXAPValue clang_APValue_getStructBase(CXAPValue V, unsigned I) {
  return &static_cast<clang::APValue *>(V)->getStructBase(I);
}

CXFieldDecl clang_APValue_getUnionField(CXAPValue V) {
  return const_cast<clang::FieldDecl *>(
      static_cast<clang::APValue *>(V)->getUnionField());
}

CXAPValue clang_APValue_getUnionValue(CXAPValue V) {
  return &static_cast<clang::APValue *>(V)->getUnionValue();
}

unsigned clang_APValue_getVectorLength(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getVectorLength();
}

CXAPValue clang_APValue_getVectorElt(CXAPValue V, unsigned I) {
  return &static_cast<clang::APValue *>(V)->getVectorElt(I);
}

void clang_APValue_dispose(CXAPValue V) {
  delete static_cast<clang::APValue *>(V); // NOLINT(*-owning-memory)
}
