#ifndef LLVM_CLANG_C_EXTRA_CXCGFUNCTIONINFO_H
#define LLVM_CLANG_C_EXTRA_CXCGFUNCTIONINFO_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The lowered shape of one function signature: what LLVM type each argument is passed as,
// and by which mechanism. A CGFunctionInfo is interned in the CodeGenModule's CodeGenTypes
// and lives as long as the CodeGenModule, so both handles here are BORROWED -- there is no
// dispose, and neither may outlive the CXCodeGenModule that produced it. Obtain one from
// the arrange* entry points in clang-ex/CodeGen/CXCodeGenABITypes.h.
//
// A CXABIArgInfo points into the CGFunctionInfo's own trailing argument buffer, so it is
// borrowed from the CGFunctionInfo in turn.

// ABIArgInfo

// Mirrors clang::CodeGen::ABIArgInfo::Kind (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp). The tag of a tagged union: almost every accessor below reads
// fields that only one or two kinds have, and asserts on the rest, so this has to be
// consulted first. The KindFirst/KindLast aliases are omitted -- they duplicate values.
typedef enum CXABIArgInfo_Kind : unsigned char {
  CXABIArgInfo_Direct,
  CXABIArgInfo_Extend,
  CXABIArgInfo_Indirect,
  CXABIArgInfo_IndirectAliased,
  CXABIArgInfo_Ignore,
  CXABIArgInfo_Expand,
  CXABIArgInfo_CoerceAndExpand,
  CXABIArgInfo_InAlloca
} CXABIArgInfo_Kind;

// getDirect
// getDirectInReg
// getSignExtend
// getZeroExtend
// getExtend
// getExtendInReg
// getIgnore
// getIndirect
// getIndirectAliased
// getIndirectInReg
// getInAlloca
// getExpand
// getExpandWithPadding
// getCoerceAndExpand
// isPaddingForCoerceAndExpand

CXABIArgInfo_Kind clang_ABIArgInfo_getKind(CXABIArgInfo AI);

// isDirect
// isInAlloca
// isExtend
// isIgnore
// isIndirect
// isIndirectAliased
// isExpand
// isCoerceAndExpand
// canHaveCoerceToType
//
// Each of the eight predicates above is `getKind() == that kind`, so
// clang_ABIArgInfo_getKind answers all of them and the caller gates on it.

// PRECONDITION: kind is Direct or Extend -- clang asserts, and the union member read
// otherwise holds an alignment or an inalloca field index.
unsigned clang_ABIArgInfo_getDirectOffset(CXABIArgInfo AI);

// setDirectOffset

// PRECONDITION: kind is Direct or Extend.
unsigned clang_ABIArgInfo_getDirectAlign(CXABIArgInfo AI);

// setDirectAlign

// True when an integer argument is sign-extended rather than zero-extended.
// PRECONDITION: kind is Extend.
bool clang_ABIArgInfo_isSignExt(CXABIArgInfo AI);

// setSignExt

// The dummy argument emitted before the real one, or NULL when there is none. Total: the
// accessor answers NULL for every kind that cannot carry padding.
LLVMTypeRef clang_ABIArgInfo_getPaddingType(CXABIArgInfo AI);

// getPaddingInReg
// setPaddingInReg

// The LLVM type the argument is actually passed as, which is not always the argument's own
// converted type.
// PRECONDITION: kind is Direct, Extend or CoerceAndExpand -- the other kinds store an
// unrelated pointer in the same field.
LLVMTypeRef clang_ABIArgInfo_getCoerceToType(CXABIArgInfo AI);

// setCoerceToType
// getCoerceAndExpandType
// getUnpaddedCoerceAndExpandType
// getCoerceAndExpandTypeSequence
// getInReg
// setInReg

// The alignment of the hidden pointer, in chars; 0 means the target default.
// PRECONDITION: kind is Indirect or IndirectAliased.
int64_t clang_ABIArgInfo_getIndirectAlign(CXABIArgInfo AI);

// setIndirectAlign

// True when the hidden pointer carries the IR `byval` attribute -- i.e. the callee gets a
// copy it may modify.
// PRECONDITION: kind is Indirect.
bool clang_ABIArgInfo_getIndirectByVal(CXABIArgInfo AI);

// setIndirectByVal
// getIndirectAddrSpace
// setIndirectAddrSpace
// getIndirectRealign
// setIndirectRealign

// True when the sret pointer is passed after `this` rather than before it, as the Microsoft
// C++ ABI requires.
// PRECONDITION: kind is Indirect.
bool clang_ABIArgInfo_isSRetAfterThis(CXABIArgInfo AI);

// setSRetAfterThis

// The argument's slot in the inalloca struct returned by clang_CGFunctionInfo_getArgStruct.
// PRECONDITION: kind is InAlloca.
unsigned clang_ABIArgInfo_getInAllocaFieldIndex(CXABIArgInfo AI);

// setInAllocaFieldIndex
// getInAllocaIndirect
// setInAllocaIndirect
// getInAllocaSRet
// setInAllocaSRet

// False when the coerce-to type must be passed as one aggregate argument instead of being
// flattened into one argument per element.
// PRECONDITION: kind is Direct.
bool clang_ABIArgInfo_getCanBeFlattened(CXABIArgInfo AI);

// setCanBeFlattened
// dump

// CGFunctionInfo
// create
// arguments

// The number of explicit arguments, not counting the return value.
unsigned clang_CGFunctionInfo_arg_size(CXCGFunctionInfo FI);

// helper: the `arguments()` ArrayRef, split into an index pair against arg_size. Both
// PRECONDITION: I < clang_CGFunctionInfo_arg_size(FI).
CXQualType clang_CGFunctionInfo_getArgType(CXCGFunctionInfo FI, unsigned I);

CXABIArgInfo clang_CGFunctionInfo_getArgInfo(CXCGFunctionInfo FI, unsigned I);

// True when the signature accepts optional arguments beyond the required ones.
bool clang_CGFunctionInfo_isVariadic(CXCGFunctionInfo FI);

// getRequiredArgs

// The number of arguments before the variadic `...`; equal to arg_size when not variadic.
unsigned clang_CGFunctionInfo_getNumRequiredArgs(CXCGFunctionInfo FI);

// True when the signature carries an implicit `this`.
bool clang_CGFunctionInfo_isInstanceMethod(CXCGFunctionInfo FI);

// isChainCall
// isDelegateCall
// isCmseNSCall

bool clang_CGFunctionInfo_isNoReturn(CXCGFunctionInfo FI);

// isReturnsRetained
// isNoCallerSavedRegs
// isNoCfCheck

// The calling convention as written in the source, before lowering.
CXCallingConv_ clang_CGFunctionInfo_getASTCallingConvention(CXCGFunctionInfo FI);

// The user-specified convention translated to an llvm::CallingConv::ID.
unsigned clang_CGFunctionInfo_getCallingConvention(CXCGFunctionInfo FI);

// The llvm::CallingConv::ID actually used, which the ABI may change.
unsigned clang_CGFunctionInfo_getEffectiveCallingConvention(CXCGFunctionInfo FI);

// setEffectiveCallingConvention
// getHasRegParm
// getRegParm
// getExtInfo

CXQualType clang_CGFunctionInfo_getReturnType(CXCGFunctionInfo FI);

CXABIArgInfo clang_CGFunctionInfo_getReturnInfo(CXCGFunctionInfo FI);

// getExtParameterInfos
// getExtParameterInfo

// True when some argument is passed with the IR `inalloca` attribute, which is what makes
// clang_CGFunctionInfo_getArgStruct non-NULL.
bool clang_CGFunctionInfo_usesInAlloca(CXCGFunctionInfo FI);

// The struct holding every memory-passed argument, or NULL when the signature uses no
// inalloca arguments.
LLVMTypeRef clang_CGFunctionInfo_getArgStruct(CXCGFunctionInfo FI);

// getArgStructAlignment
// setArgStruct
// getMaxVectorWidth
// setMaxVectorWidth
// Profile

LLVM_CLANG_C_EXTERN_C_END

#endif
