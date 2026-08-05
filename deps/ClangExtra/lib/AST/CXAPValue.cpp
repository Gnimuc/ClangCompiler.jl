#include "clang-ex/AST/CXAPValue.h"
#include "utils.h"

#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/CharUnits.h"
#include "clang/AST/Decl.h"
#include "clang/AST/Expr.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/ADT/FoldingSet.h"

bool clang_APValue_needsCleanup(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->needsCleanup();
}

CXAPValue clang_APValue_IndeterminateValue(void) {
  // NOLINTNEXTLINE(*-owning-memory)
  return reinterpret_cast<CXAPValue>(new clang::APValue(clang::APValue::IndeterminateValue()));
}

void clang_APValue_swap(CXAPValue V, CXAPValue RHS) {
  reinterpret_cast<clang::APValue *>(V)->swap(*reinterpret_cast<clang::APValue *>(RHS));
}

LLVMGenericValueRef clang_APValue_getComplexIntReal(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getComplexIntReal();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexIntImag(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getComplexIntImag();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexFloatReal(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getComplexFloatReal().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getComplexFloatImag(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getComplexFloatImag().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

int64_t clang_APValue_getLValueOffset(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueOffset().getQuantity();
}

bool clang_APValue_isLValueOnePastTheEnd(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isLValueOnePastTheEnd();
}

bool clang_APValue_hasLValuePath(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->hasLValuePath();
}

unsigned clang_APValue_getLValueCallIndex(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueCallIndex();
}

unsigned clang_APValue_getLValueVersion(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueVersion();
}

bool clang_APValue_isNullPointer(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isNullPointer();
}

CXValueDecl clang_APValue_getLValueBaseAsValueDecl(CXAPValue V) {
  clang::APValue::LValueBase B = reinterpret_cast<clang::APValue *>(V)->getLValueBase();
  if (!B.is<const clang::ValueDecl *>())
    return nullptr;
  return reinterpret_cast<CXValueDecl>(const_cast<clang::ValueDecl *>(B.get<const clang::ValueDecl *>()));
}

CXExpr clang_APValue_getLValueBaseAsExpr(CXAPValue V) {
  clang::APValue::LValueBase B = reinterpret_cast<clang::APValue *>(V)->getLValueBase();
  if (!B.is<const clang::Expr *>())
    return nullptr;
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(B.get<const clang::Expr *>()));
}

bool clang_APValue_isLValueBaseNull(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueBase().isNull();
}

CXQualType clang_APValue_getLValueBaseType(CXAPValue V) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::APValue *>(V)->getLValueBase().getType().getAsOpaquePtr());
}

bool clang_APValue_isLValueBaseTypeInfo(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueBase().is<clang::TypeInfoLValue>();
}

CXType_ clang_APValue_getLValueBaseTypeInfoOperand(CXAPValue V) {
  clang::APValue::LValueBase B = reinterpret_cast<clang::APValue *>(V)->getLValueBase();
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(B.get<clang::TypeInfoLValue>().getType()));
}

CXQualType clang_APValue_getLValueBaseTypeInfoType(CXAPValue V) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::APValue *>(V)
      ->getLValueBase()
      .getTypeInfoType()
      .getAsOpaquePtr());
}

bool clang_APValue_isLValueBaseDynamicAlloc(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getLValueBase().is<clang::DynamicAllocLValue>();
}

unsigned clang_APValue_getLValueBaseDynamicAllocIndex(CXAPValue V) {
  clang::APValue::LValueBase B = reinterpret_cast<clang::APValue *>(V)->getLValueBase();
  return B.get<clang::DynamicAllocLValue>().getIndex();
}

CXQualType clang_APValue_getLValueBaseDynamicAllocType(CXAPValue V) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::APValue *>(V)
      ->getLValueBase()
      .getDynamicAllocType()
      .getAsOpaquePtr());
}

unsigned clang_APValue_getLValueBaseProfileHash(CXAPValue V) {
  llvm::FoldingSetNodeID ID;
  reinterpret_cast<clang::APValue *>(V)->getLValueBase().Profile(ID);
  return ID.ComputeHash();
}

unsigned clang_APValue_getLValuePathLength(CXAPValue V) {
  return static_cast<unsigned>(reinterpret_cast<clang::APValue *>(V)->getLValuePath().size());
}

uint64_t clang_APValue_getLValuePathAsArrayIndex(CXAPValue V, unsigned I) {
  return reinterpret_cast<clang::APValue *>(V)->getLValuePath()[I].getAsArrayIndex();
}

CXDecl clang_APValue_getLValuePathAsBaseOrMember(CXAPValue V, unsigned I) {
  auto Entry = reinterpret_cast<clang::APValue *>(V)->getLValuePath()[I];
  return reinterpret_cast<CXDecl>(const_cast<clang::Decl *>(Entry.getAsBaseOrMember().getPointer()));
}

bool clang_APValue_isLValuePathBaseOrMemberVirtual(CXAPValue V, unsigned I) {
  auto Entry = reinterpret_cast<clang::APValue *>(V)->getLValuePath()[I];
  return Entry.getAsBaseOrMember().getInt();
}

unsigned clang_APValue_getLValuePathEntryProfileHash(CXAPValue V, unsigned I) {
  llvm::FoldingSetNodeID ID;
  reinterpret_cast<clang::APValue *>(V)->getLValuePath()[I].Profile(ID);
  return ID.ComputeHash();
}

CXValueDecl clang_APValue_getMemberPointerDecl(CXAPValue V) {
  return reinterpret_cast<CXValueDecl>(const_cast<clang::ValueDecl *>(
      reinterpret_cast<clang::APValue *>(V)->getMemberPointerDecl()));
}

bool clang_APValue_isMemberPointerToDerivedMember(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isMemberPointerToDerivedMember();
}

unsigned clang_APValue_getMemberPointerPathSize(CXAPValue V) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::APValue *>(V)->getMemberPointerPath().size());
}

CXCXXRecordDecl clang_APValue_getMemberPointerPathEntry(CXAPValue V, unsigned I) {
  return reinterpret_cast<CXCXXRecordDecl>(const_cast<clang::CXXRecordDecl *>(
      reinterpret_cast<clang::APValue *>(V)->getMemberPointerPath()[I]));
}

CXAddrLabelExpr clang_APValue_getAddrLabelDiffLHS(CXAPValue V) {
  return reinterpret_cast<CXAddrLabelExpr>(const_cast<clang::AddrLabelExpr *>(
      reinterpret_cast<clang::APValue *>(V)->getAddrLabelDiffLHS()));
}

CXAddrLabelExpr clang_APValue_getAddrLabelDiffRHS(CXAPValue V) {
  return reinterpret_cast<CXAddrLabelExpr>(const_cast<clang::AddrLabelExpr *>(
      reinterpret_cast<clang::APValue *>(V)->getAddrLabelDiffRHS()));
}

void clang_APValue_setInt(CXAPValue V, LLVMGenericValueRef GV, bool IsUnsigned) {
  auto *G = reinterpret_cast<llvm::GenericValue *>(GV);
  reinterpret_cast<clang::APValue *>(V)->setInt(llvm::APSInt(G->IntVal, IsUnsigned));
}

void clang_APValue_setFloat(CXAPValue V, LLVMGenericValueRef GV) {
  auto *A = reinterpret_cast<clang::APValue *>(V);
  auto *G = reinterpret_cast<llvm::GenericValue *>(GV);
  const llvm::fltSemantics &Sem = A->getFloat().getSemantics();
  llvm::APFloat New(Sem, G->IntVal.zextOrTrunc(llvm::APFloat::getSizeInBits(Sem)));
  A->setFloat(New);
}

void clang_APValue_setComplexInt(CXAPValue V, LLVMGenericValueRef Real,
                                 LLVMGenericValueRef Imag, bool IsUnsigned) {
  auto *A = reinterpret_cast<clang::APValue *>(V);
  auto *R = reinterpret_cast<llvm::GenericValue *>(Real);
  auto *I = reinterpret_cast<llvm::GenericValue *>(Imag);
  unsigned Width = A->getComplexIntReal().getBitWidth();
  llvm::APSInt NewReal(R->IntVal.zextOrTrunc(Width), IsUnsigned);
  llvm::APSInt NewImag(I->IntVal.zextOrTrunc(Width), IsUnsigned);
  A->setComplexInt(NewReal, NewImag);
}

void clang_APValue_setComplexFloat(CXAPValue V, LLVMGenericValueRef Real,
                                   LLVMGenericValueRef Imag) {
  auto *A = reinterpret_cast<clang::APValue *>(V);
  auto *R = reinterpret_cast<llvm::GenericValue *>(Real);
  auto *I = reinterpret_cast<llvm::GenericValue *>(Imag);
  const llvm::fltSemantics &Sem = A->getComplexFloatReal().getSemantics();
  unsigned Width = llvm::APFloat::getSizeInBits(Sem);
  llvm::APFloat NewReal(Sem, R->IntVal.zextOrTrunc(Width));
  llvm::APFloat NewImag(Sem, I->IntVal.zextOrTrunc(Width));
  A->setComplexFloat(NewReal, NewImag);
}

void clang_APValue_setUnion(CXAPValue V, CXFieldDecl Field, CXAPValue Value) {
  auto *FD = reinterpret_cast<clang::FieldDecl *>(Field);
  auto *Val = reinterpret_cast<clang::APValue *>(Value);
  reinterpret_cast<clang::APValue *>(V)->setUnion(FD, *Val);
}

CXAPValueKind clang_APValue_getKind(CXAPValue V) {
  return static_cast<CXAPValueKind>(reinterpret_cast<clang::APValue *>(V)->getKind());
}

bool clang_APValue_isInt(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isInt();
}

bool clang_APValue_isFloat(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isFloat();
}

bool clang_APValue_isArray(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isArray();
}

bool clang_APValue_isStruct(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isStruct();
}

bool clang_APValue_isAbsent(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isAbsent();
}

bool clang_APValue_isIndeterminate(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isIndeterminate();
}

bool clang_APValue_hasValue(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->hasValue();
}

bool clang_APValue_isFixedPoint(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isFixedPoint();
}

bool clang_APValue_isComplexInt(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isComplexInt();
}

bool clang_APValue_isComplexFloat(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isComplexFloat();
}

bool clang_APValue_isLValue(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isLValue();
}

bool clang_APValue_isVector(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isVector();
}

bool clang_APValue_isUnion(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isUnion();
}

bool clang_APValue_isMemberPointer(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isMemberPointer();
}

bool clang_APValue_isAddrLabelDiff(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->isAddrLabelDiff();
}

CXString clang_APValue_getAsString(CXAPValue V, CXASTContext Ctx, CXQualType T) {
  return extra::makeCXString(reinterpret_cast<clang::APValue *>(V)->getAsString(
      *reinterpret_cast<clang::ASTContext *>(Ctx), clang::QualType::getFromOpaquePtr(T)));
}

unsigned clang_APValue_getProfileHash(CXAPValue V) {
  llvm::FoldingSetNodeID ID;
  reinterpret_cast<clang::APValue *>(V)->Profile(ID);
  return ID.ComputeHash();
}

LLVMGenericValueRef clang_APValue_getInt(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_getFloat(CXAPValue V) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::APValue *>(V)->getFloat().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_APValue_toIntegralConstant(CXAPValue V, CXQualType SrcTy,
                                                     CXASTContext Ctx) {
  llvm::APSInt Result;
  if (!reinterpret_cast<clang::APValue *>(V)->toIntegralConstant(
          Result, clang::QualType::getFromOpaquePtr(SrcTy),
          *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = Result;
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

unsigned clang_APValue_getArraySize(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getArraySize();
}

unsigned clang_APValue_getArrayInitializedElts(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getArrayInitializedElts();
}

CXAPValue clang_APValue_getArrayInitializedElt(CXAPValue V, unsigned I) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getArrayInitializedElt(I));
}

bool clang_APValue_hasArrayFiller(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->hasArrayFiller();
}

CXAPValue clang_APValue_getArrayFiller(CXAPValue V) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getArrayFiller());
}

unsigned clang_APValue_getStructNumFields(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getStructNumFields();
}

CXAPValue clang_APValue_getStructField(CXAPValue V, unsigned I) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getStructField(I));
}

unsigned clang_APValue_getStructNumBases(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getStructNumBases();
}

CXAPValue clang_APValue_getStructBase(CXAPValue V, unsigned I) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getStructBase(I));
}

CXFieldDecl clang_APValue_getUnionField(CXAPValue V) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(
      reinterpret_cast<clang::APValue *>(V)->getUnionField()));
}

CXAPValue clang_APValue_getUnionValue(CXAPValue V) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getUnionValue());
}

unsigned clang_APValue_getVectorLength(CXAPValue V) {
  return reinterpret_cast<clang::APValue *>(V)->getVectorLength();
}

CXAPValue clang_APValue_getVectorElt(CXAPValue V, unsigned I) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::APValue *>(V)->getVectorElt(I));
}

void clang_APValue_dispose(CXAPValue V) {
  delete reinterpret_cast<clang::APValue *>(V); // NOLINT(*-owning-memory)
}

// DynamicAllocLValue
unsigned clang_DynamicAllocLValue_getMaxIndex(void) {
  return clang::DynamicAllocLValue::getMaxIndex();
}
