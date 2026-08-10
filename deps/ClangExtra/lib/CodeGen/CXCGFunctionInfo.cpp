#include "clang-ex/CodeGen/CXCGFunctionInfo.h"
#include "clang/CodeGen/CGFunctionInfo.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"

namespace {

const clang::CodeGen::ABIArgInfo *unwrapArgInfo(CXABIArgInfo AI) {
  return reinterpret_cast<const clang::CodeGen::ABIArgInfo *>(AI);
}

const clang::CodeGen::CGFunctionInfo *unwrapFunctionInfo(CXCGFunctionInfo FI) {
  return reinterpret_cast<const clang::CodeGen::CGFunctionInfo *>(FI);
}

CXABIArgInfo wrapArgInfo(const clang::CodeGen::ABIArgInfo &AI) {
  return reinterpret_cast<CXABIArgInfo>(
      const_cast<clang::CodeGen::ABIArgInfo *>(&AI));
}

} // namespace

// ABIArgInfo
CXABIArgInfo_Kind clang_ABIArgInfo_getKind(CXABIArgInfo AI) {
  return static_cast<CXABIArgInfo_Kind>(unwrapArgInfo(AI)->getKind());
}

unsigned clang_ABIArgInfo_getDirectOffset(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getDirectOffset();
}

unsigned clang_ABIArgInfo_getDirectAlign(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getDirectAlign();
}

bool clang_ABIArgInfo_isSignExt(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->isSignExt();
}

LLVMTypeRef clang_ABIArgInfo_getPaddingType(CXABIArgInfo AI) {
  return llvm::wrap(unwrapArgInfo(AI)->getPaddingType());
}

LLVMTypeRef clang_ABIArgInfo_getCoerceToType(CXABIArgInfo AI) {
  return llvm::wrap(unwrapArgInfo(AI)->getCoerceToType());
}

int64_t clang_ABIArgInfo_getIndirectAlign(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getIndirectAlign().getQuantity();
}

bool clang_ABIArgInfo_getIndirectByVal(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getIndirectByVal();
}

bool clang_ABIArgInfo_isSRetAfterThis(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->isSRetAfterThis();
}

unsigned clang_ABIArgInfo_getInAllocaFieldIndex(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getInAllocaFieldIndex();
}

bool clang_ABIArgInfo_getCanBeFlattened(CXABIArgInfo AI) {
  return unwrapArgInfo(AI)->getCanBeFlattened();
}

// CGFunctionInfo
unsigned clang_CGFunctionInfo_arg_size(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->arg_size();
}

CXQualType clang_CGFunctionInfo_getArgType(CXCGFunctionInfo FI, unsigned I) {
  return reinterpret_cast<CXQualType>(
      unwrapFunctionInfo(FI)->arguments()[I].type.getAsOpaquePtr());
}

CXABIArgInfo clang_CGFunctionInfo_getArgInfo(CXCGFunctionInfo FI, unsigned I) {
  return wrapArgInfo(unwrapFunctionInfo(FI)->arguments()[I].info);
}

bool clang_CGFunctionInfo_isVariadic(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->isVariadic();
}

unsigned clang_CGFunctionInfo_getNumRequiredArgs(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->getNumRequiredArgs();
}

bool clang_CGFunctionInfo_isInstanceMethod(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->isInstanceMethod();
}

bool clang_CGFunctionInfo_isNoReturn(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->isNoReturn();
}

CXCallingConv_ clang_CGFunctionInfo_getASTCallingConvention(CXCGFunctionInfo FI) {
  return static_cast<CXCallingConv_>(
      unwrapFunctionInfo(FI)->getASTCallingConvention());
}

unsigned clang_CGFunctionInfo_getCallingConvention(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->getCallingConvention();
}

unsigned clang_CGFunctionInfo_getEffectiveCallingConvention(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->getEffectiveCallingConvention();
}

CXQualType clang_CGFunctionInfo_getReturnType(CXCGFunctionInfo FI) {
  return reinterpret_cast<CXQualType>(
      unwrapFunctionInfo(FI)->getReturnType().getAsOpaquePtr());
}

CXABIArgInfo clang_CGFunctionInfo_getReturnInfo(CXCGFunctionInfo FI) {
  return wrapArgInfo(unwrapFunctionInfo(FI)->getReturnInfo());
}

bool clang_CGFunctionInfo_usesInAlloca(CXCGFunctionInfo FI) {
  return unwrapFunctionInfo(FI)->usesInAlloca();
}

LLVMTypeRef clang_CGFunctionInfo_getArgStruct(CXCGFunctionInfo FI) {
  return llvm::wrap(unwrapFunctionInfo(FI)->getArgStruct());
}
