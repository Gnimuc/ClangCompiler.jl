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

// Mirrors clang::OpenCLTypeKind (clang/Basic/TargetInfo.h).
typedef enum CXOpenCLTypeKind : unsigned char {
  CXOpenCLTypeKind_OCLTK_Default,
  CXOpenCLTypeKind_OCLTK_ClkEvent,
  CXOpenCLTypeKind_OCLTK_Event,
  CXOpenCLTypeKind_OCLTK_Image,
  CXOpenCLTypeKind_OCLTK_Pipe,
  CXOpenCLTypeKind_OCLTK_Queue,
  CXOpenCLTypeKind_OCLTK_ReserveID,
  CXOpenCLTypeKind_OCLTK_Sampler
} CXOpenCLTypeKind;

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts);

// Precondition: TI was built by clang_TargetInfo_CreateTargetInfo (the only constructor
// this API exposes); the accessor asserts on, and otherwise dereferences, a null
// TargetOptions. The result is borrowed from the TargetInfo's shared_ptr and must not be
// disposed.
CXTargetOptions clang_TargetInfo_getTargetOpts(CXTargetInfo_ TI);

CXTargetInfo_IntType clang_TargetInfo_getSizeType(CXTargetInfo_ TI);
// Precondition: the target's size_t is one of unsigned short/int/long/long long;
// llvm_unreachable otherwise.
CXTargetInfo_IntType clang_TargetInfo_getSignedSizeType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getIntMaxType(CXTargetInfo_ TI);
// Precondition: intmax_t is a signed integer type; llvm_unreachable otherwise.
CXTargetInfo_IntType clang_TargetInfo_getUIntMaxType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getPtrDiffType(CXTargetInfo_ TI, CXLangAS AddrSpace);
// Precondition: ptrdiff_t in AddrSpace is a signed integer type; llvm_unreachable
// otherwise.
CXTargetInfo_IntType clang_TargetInfo_getUnsignedPtrDiffType(CXTargetInfo_ TI,
                                                             CXLangAS AddrSpace);
CXTargetInfo_IntType clang_TargetInfo_getIntPtrType(CXTargetInfo_ TI);
// Precondition: intptr_t is a signed integer type; llvm_unreachable otherwise.
CXTargetInfo_IntType clang_TargetInfo_getUIntPtrType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getWCharType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getWIntType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getChar16Type(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getChar32Type(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getInt64Type(CXTargetInfo_ TI);
// Precondition: int64_t is a signed integer type; llvm_unreachable otherwise.
CXTargetInfo_IntType clang_TargetInfo_getUInt64Type(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getInt16Type(CXTargetInfo_ TI);
// Precondition: int16_t is a signed integer type; llvm_unreachable otherwise.
CXTargetInfo_IntType clang_TargetInfo_getUInt16Type(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getSigAtomicType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getProcessIDType(CXTargetInfo_ TI);
CXTargetInfo_IntType clang_TargetInfo_getCorrespondingUnsignedType(CXTargetInfo_IntType T);
unsigned clang_TargetInfo_getTypeWidth(CXTargetInfo_ TI, CXTargetInfo_IntType T);
CXTargetInfo_IntType clang_TargetInfo_getIntTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                        bool IsSigned);
CXTargetInfo_IntType
clang_TargetInfo_getLeastIntTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth, bool IsSigned);
unsigned clang_TargetInfo_getTypeAlign(CXTargetInfo_ TI, CXTargetInfo_IntType T);
bool clang_TargetInfo_isTypeSigned(CXTargetInfo_IntType T);
uint64_t clang_TargetInfo_getPointerWidth(CXTargetInfo_ TI, CXLangAS AddrSpace);
uint64_t clang_TargetInfo_getPointerAlign(CXTargetInfo_ TI, CXLangAS AddrSpace);
uint64_t clang_TargetInfo_getMaxPointerWidth(CXTargetInfo_ TI);
uint64_t clang_TargetInfo_getNullPointerValue(CXTargetInfo_ TI, CXLangAS AddrSpace);
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
unsigned clang_TargetInfo_getMinGlobalAlign(CXTargetInfo_ TI, uint64_t Size);
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
unsigned clang_TargetInfo_getIbm128Width(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getIbm128Align(CXTargetInfo_ TI);
const char *clang_TargetInfo_getLongDoubleMangling(CXTargetInfo_ TI);
const char *clang_TargetInfo_getFloat128Mangling(CXTargetInfo_ TI);
// Precondition: the target provides an __ibm128 type (hasIbm128Type);
// llvm_unreachable otherwise.
const char *clang_TargetInfo_getIbm128Mangling(CXTargetInfo_ TI);
const char *clang_TargetInfo_getBFloat16Mangling(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLargeArrayMinWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLargeArrayAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicPromoteWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicInlineWidth(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBuiltinAtomic(CXTargetInfo_ TI, uint64_t AtomicSizeInBits,
                                       uint64_t AlignmentInBits);
unsigned clang_TargetInfo_getMaxVectorAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getExnObjectAlignment(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getIntMaxTWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnwindWordWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getRegisterWidth(CXTargetInfo_ TI);
const char *clang_TargetInfo_getUserLabelPrefix(CXTargetInfo_ TI);
const char *clang_TargetInfo_getMCountName(CXTargetInfo_ TI);
bool clang_TargetInfo_useSignedCharForObjCBool(CXTargetInfo_ TI);
bool clang_TargetInfo_useBitFieldTypeAlignment(CXTargetInfo_ TI);
bool clang_TargetInfo_useZeroLengthBitfieldAlignment(CXTargetInfo_ TI);
bool clang_TargetInfo_useLeadingZeroLengthBitfield(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getZeroLengthBitfieldBoundary(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAlignedAttribute(CXTargetInfo_ TI);
bool clang_TargetInfo_useExplicitBitFieldAlignment(CXTargetInfo_ TI);
bool clang_TargetInfo_hasAlignMac68kSupport(CXTargetInfo_ TI);
const char *clang_TargetInfo_getTypeName(CXTargetInfo_IntType T);
// Precondition: T is not CXTargetInfo_NoInt; llvm_unreachable otherwise.
const char *clang_TargetInfo_getTypeConstantSuffix(CXTargetInfo_ TI,
                                                   CXTargetInfo_IntType T);
// Precondition: T is not CXTargetInfo_NoInt; llvm_unreachable otherwise.
const char *clang_TargetInfo_getTypeFormatModifier(CXTargetInfo_IntType T);
bool clang_TargetInfo_useFP16ConversionIntrinsics(CXTargetInfo_ TI);
bool clang_TargetInfo_useAddressSpaceMapMangling(CXTargetInfo_ TI);
bool clang_TargetInfo_getVScaleRange(CXTargetInfo_ TI, CXLangOptions LO, unsigned *Min,
                                     unsigned *Max);
bool clang_TargetInfo_isCLZForZeroUndef(CXTargetInfo_ TI);
CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBuiltinMSVaList(CXTargetInfo_ TI);
bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI);
bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI);
uint32_t clang_TargetInfo_getARMCDECoprocMask(CXTargetInfo_ TI);
bool clang_TargetInfo_isValidClobber(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_isValidGCCRegisterName(CXTargetInfo_ TI, const char *Name);
// Precondition: Name is a valid GCC register name for this target
// (isValidGCCRegisterName); asserts in TargetInfo.cpp otherwise.
CXString clang_TargetInfo_getNormalizedGCCRegisterName(CXTargetInfo_ TI, const char *Name,
                                                       bool ReturnCanonical);
bool clang_TargetInfo_isSPRegName(CXTargetInfo_ TI, const char *Name);
// Returns the empty string when Constraint names no single register.
CXString clang_TargetInfo_getConstraintRegister(CXTargetInfo_ TI, const char *Constraint,
                                                const char *Expression);
CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI);
bool clang_TargetInfo_isNan2008(CXTargetInfo_ TI);
// Returns the triple string, borrowed from the llvm::Triple owned by the target.
const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI);
const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI);
bool clang_TargetInfo_hasProtectedVisibility(CXTargetInfo_ TI);
bool clang_TargetInfo_shouldDLLImportComdatSymbols(CXTargetInfo_ TI);
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
unsigned clang_TargetInfo_getRegParmMax(CXTargetInfo_ TI);
bool clang_TargetInfo_isTLSSupported(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxTLSAlign(CXTargetInfo_ TI);
bool clang_TargetInfo_isVLASupported(CXTargetInfo_ TI);
bool clang_TargetInfo_isSEHTrySupported(CXTargetInfo_ TI);
bool clang_TargetInfo_hasNoAsmVariants(CXTargetInfo_ TI);
int clang_TargetInfo_getEHDataRegisterNumber(CXTargetInfo_ TI, unsigned RegNo);
// Returns NULL when the target names no C++ static initialization section.
const char *clang_TargetInfo_getStaticInitSectionSpecifier(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getTargetAddressSpace(CXTargetInfo_ TI, CXLangAS AS);
CXString clang_TargetInfo_getPlatformName(CXTargetInfo_ TI);
bool clang_TargetInfo_isBigEndian(CXTargetInfo_ TI);
bool clang_TargetInfo_isLittleEndian(CXTargetInfo_ TI);
bool clang_TargetInfo_hasSjLjLowering(CXTargetInfo_ TI);
bool clang_TargetInfo_allowsLargerPreferedTypeAlignment(CXTargetInfo_ TI);
bool clang_TargetInfo_defaultsToAIXPowerAlignment(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getVtblPtrAddressSpace(CXTargetInfo_ TI);

LLVM_CLANG_C_EXTERN_C_END

#endif