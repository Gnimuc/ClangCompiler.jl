#include "clang-ex/AST/CXAPValue.h"

#include "clang/AST/APValue.h"
#include "llvm/ExecutionEngine/GenericValue.h"

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

unsigned clang_APValue_getStructNumFields(CXAPValue V) {
  return static_cast<clang::APValue *>(V)->getStructNumFields();
}

CXAPValue clang_APValue_getStructField(CXAPValue V, unsigned I) {
  return &static_cast<clang::APValue *>(V)->getStructField(I);
}

void clang_APValue_dispose(CXAPValue V) {
  delete static_cast<clang::APValue *>(V); // NOLINT(*-owning-memory)
}
