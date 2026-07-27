#ifndef LLVM_CLANG_C_EXTRA_CXTARGETINFO_H
#define LLVM_CLANG_C_EXTRA_CXTARGETINFO_H

#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXTargetCXXABI.h"

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors TransferrableTargetInfo::IntType.
typedef enum CXTargetInfo_IntType {
  CXTargetInfo_NoInt = 0,
  CXTargetInfo_SignedChar,
  CXTargetInfo_UnsignedChar,
  CXTargetInfo_SignedShort,
  CXTargetInfo_UnsignedShort,
  CXTargetInfo_SignedInt,
  CXTargetInfo_UnsignedInt,
  CXTargetInfo_SignedLong,
  CXTargetInfo_UnsignedLong,
  CXTargetInfo_SignedLongLong,
  CXTargetInfo_UnsignedLongLong
} CXTargetInfo_IntType;

// Mirrors TargetInfo::BuiltinVaListKind.
typedef enum CXTargetInfo_BuiltinVaListKind {
  CXTargetInfo_CharPtrBuiltinVaList = 0,
  CXTargetInfo_VoidPtrBuiltinVaList,
  CXTargetInfo_AArch64ABIBuiltinVaList,
  CXTargetInfo_PNaClABIBuiltinVaList,
  CXTargetInfo_PowerABIBuiltinVaList,
  CXTargetInfo_X86_64ABIBuiltinVaList,
  CXTargetInfo_AAPCSABIBuiltinVaList,
  CXTargetInfo_SystemZBuiltinVaList,
  CXTargetInfo_HexagonBuiltinVaList
} CXTargetInfo_BuiltinVaListKind;

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts);

CXTargetInfo_IntType clang_TargetInfo_getSizeType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getIntMaxType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getPtrDiffType(CXTargetInfo_ TI, CXLangAS AddrSpace);
CXTargetInfo_IntType clang_TargetInfo_getIntPtrType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getWCharType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getInt64Type(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getCorrespondingUnsignedType(CXTargetInfo_IntType T);
unsigned clang_TargetInfo_getTypeWidth(CXTargetInfo_ TI, CXTargetInfo_IntType T);
CXTargetInfo_IntType clang_TargetInfo_getIntTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                        bool IsSigned);
unsigned clang_TargetInfo_getTypeAlign(CXTargetInfo_ TI, CXTargetInfo_IntType T);
bool clang_TargetInfo_isTypeSigned(CXTargetInfo_IntType T);
uint64_t clang_TargetInfo_getPointerWidth(CXTargetInfo_ TI, CXLangAS AddrSpace);
uint64_t clang_TargetInfo_getPointerAlign(CXTargetInfo_ TI, CXLangAS AddrSpace);
uint64_t clang_TargetInfo_getMaxPointerWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getBoolWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getBoolAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getCharWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getCharAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getIntWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getIntAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongLongWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongLongAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getInt128Align(CXTargetInfo_ TI);
bool clang_TargetInfo_hasInt128Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBitIntType(CXTargetInfo_ TI);
size_t clang_TargetInfo_getMaxBitIntWidth(CXTargetInfo_ TI);
bool clang_TargetInfo_hasLegalHalfType(CXTargetInfo_ TI);
bool clang_TargetInfo_hasFloat128Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasFloat16Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBFloat16Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasFullBFloat16Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasIbm128Type(CXTargetInfo_ TI);
bool clang_TargetInfo_hasLongDoubleType(CXTargetInfo_ TI);
bool clang_TargetInfo_hasFPReturn(CXTargetInfo_ TI);
bool clang_TargetInfo_hasStrictFP(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getSuitableAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getDefaultAlignForAttributeAligned(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getNewAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getWCharWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getWCharAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getChar16Width(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getChar16Align(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getChar32Width(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getChar32Align(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getHalfWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getHalfAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFloatWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFloatAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getBFloat16Width(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getBFloat16Align(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getDoubleWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getDoubleAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongDoubleWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongDoubleAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFloat128Width(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFloat128Align(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicPromoteWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicInlineWidth(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBuiltinAtomic(CXTargetInfo_ TI, uint64_t AtomicSizeInBits,
                                       uint64_t AlignmentInBits);
unsigned clang_TargetInfo_getMaxVectorAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getExnObjectAlignment(CXTargetInfo_ TI);
const char *clang_TargetInfo_getUserLabelPrefix(CXTargetInfo_ TI);
const char *clang_TargetInfo_getMCountName(CXTargetInfo_ TI);
const char *clang_TargetInfo_getTypeName(CXTargetInfo_IntType T);
bool clang_TargetInfo_getVScaleRange(CXTargetInfo_ TI, CXLangOptions LO, unsigned *Min,
                                     unsigned *Max);
CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI);
bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI);
bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI);
CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI);
// Returns the triple string, borrowed from the llvm::Triple owned by the target.
const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI);
const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI);
CXString clang_TargetInfo_getABI(CXTargetInfo_ TI);
CXTargetCXXABI_Kind clang_TargetInfo_getCXXABI(CXTargetInfo_ TI);
// The caller owns the returned set (freed via libclang's clang_disposeStringSet).
CXStringSet *clang_TargetInfo_fillValidCPUList(CXTargetInfo_ TI);
bool clang_TargetInfo_isValidCPUName(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_isValidTuneCPUName(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_isValidFeatureName(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_hasFeature(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_supportsMultiVersioning(CXTargetInfo_ TI);
bool clang_TargetInfo_supportsIFunc(CXTargetInfo_ TI);
bool clang_TargetInfo_getCPUCacheLineSize(CXTargetInfo_ TI, unsigned *Size);
bool clang_TargetInfo_isTLSSupported(CXTargetInfo_ TI);
bool clang_TargetInfo_isVLASupported(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getTargetAddressSpace(CXTargetInfo_ TI, CXLangAS AS);
CXString clang_TargetInfo_getPlatformName(CXTargetInfo_ TI);
bool clang_TargetInfo_isBigEndian(CXTargetInfo_ TI);
bool clang_TargetInfo_isLittleEndian(CXTargetInfo_ TI);

LLVM_CLANG_C_EXTERN_C_END

#endif