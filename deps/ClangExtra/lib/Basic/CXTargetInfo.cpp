#include "clang-ex/Basic/CXTargetInfo.h"
#include "utils.h"
#include "clang/Basic/TargetInfo.h"

#include "clang/Basic/MacroBuilder.h"
#include "llvm/ADT/APInt.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts) {
  auto *TI = clang::TargetInfo::CreateTargetInfo(
      *reinterpret_cast<clang::DiagnosticsEngine *>(DE),
      std::shared_ptr<clang::TargetOptions>(reinterpret_cast<clang::TargetOptions *>(Opts)));
  // TargetInfo is a RefCountedBase and clang's factory hands back a raw pointer at a count
  // of zero, so pin the caller's own reference before returning (MARSHALLING.md section 12).
  // CompilerInstance::setTarget and setAuxTarget park the pointer in an IntrusiveRefCntPtr
  // member, so a borrow starting from zero goes 0 -> 1 -> 0 and deletes the target when that
  // instance is disposed, leaving the caller with a dangling handle. Starting at one turns
  // every such borrow into 1 -> 2 -> 1. The factory returns null on an unusable triple, and
  // there is nothing to pin in that case.
  if (TI)
    TI->Retain();
  return reinterpret_cast<CXTargetInfo_>(TI);
}

void clang_TargetInfo_dispose(CXTargetInfo_ TI) {
  // Balances the Retain in clang_TargetInfo_CreateTargetInfo; the last Release deletes, and
  // deleting the target also drops the shared_ptr to the TargetOptions it absorbed.
  reinterpret_cast<clang::TargetInfo *>(TI)->Release();
}

CXTargetOptions clang_TargetInfo_getTargetOpts(CXTargetInfo_ TI) {
  return reinterpret_cast<CXTargetOptions>(&reinterpret_cast<clang::TargetInfo *>(TI)->getTargetOpts());
}

CXTargetInfo_IntType clang_TargetInfo_getSizeType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getSizeType());
}

CXTargetInfo_IntType clang_TargetInfo_getSignedSizeType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getSignedSizeType());
}

CXTargetInfo_IntType clang_TargetInfo_getIntMaxType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getIntMaxType());
}

CXTargetInfo_IntType clang_TargetInfo_getUIntMaxType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getUIntMaxType());
}

CXTargetInfo_IntType clang_TargetInfo_getPtrDiffType(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getPtrDiffType(
          static_cast<clang::LangAS>(AddrSpace)));
}

CXTargetInfo_IntType clang_TargetInfo_getUnsignedPtrDiffType(CXTargetInfo_ TI,
                                                             CXLangAS AddrSpace) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedPtrDiffType(
          static_cast<clang::LangAS>(AddrSpace)));
}

CXTargetInfo_IntType clang_TargetInfo_getIntPtrType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getIntPtrType());
}

CXTargetInfo_IntType clang_TargetInfo_getUIntPtrType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getUIntPtrType());
}

CXTargetInfo_IntType clang_TargetInfo_getWCharType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getWCharType());
}

CXTargetInfo_IntType clang_TargetInfo_getWIntType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getWIntType());
}

CXTargetInfo_IntType clang_TargetInfo_getChar16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getChar16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getChar32Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getChar32Type());
}

CXTargetInfo_IntType clang_TargetInfo_getInt64Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getInt64Type());
}

CXTargetInfo_IntType clang_TargetInfo_getUInt64Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getUInt64Type());
}

CXTargetInfo_IntType clang_TargetInfo_getInt16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getInt16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getUInt16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getUInt16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getSigAtomicType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getSigAtomicType());
}

CXTargetInfo_IntType clang_TargetInfo_getProcessIDType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getProcessIDType());
}

CXTargetInfo_IntType clang_TargetInfo_getCorrespondingUnsignedType(CXTargetInfo_IntType T) {
  return static_cast<CXTargetInfo_IntType>(clang::TargetInfo::getCorrespondingUnsignedType(
      static_cast<clang::TargetInfo::IntType>(T)));
}

unsigned clang_TargetInfo_getTypeWidth(CXTargetInfo_ TI, CXTargetInfo_IntType T) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getTypeWidth(
      static_cast<clang::TargetInfo::IntType>(T));
}

CXTargetInfo_IntType clang_TargetInfo_getIntTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                        bool IsSigned) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getIntTypeByWidth(BitWidth, IsSigned));
}

CXTargetInfo_IntType clang_TargetInfo_getLeastIntTypeByWidth(CXTargetInfo_ TI,
                                                             unsigned BitWidth,
                                                             bool IsSigned) {
  return static_cast<CXTargetInfo_IntType>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getLeastIntTypeByWidth(BitWidth, IsSigned));
}

unsigned clang_TargetInfo_getTypeAlign(CXTargetInfo_ TI, CXTargetInfo_IntType T) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getTypeAlign(
      static_cast<clang::TargetInfo::IntType>(T));
}

bool clang_TargetInfo_isTypeSigned(CXTargetInfo_IntType T) {
  return clang::TargetInfo::isTypeSigned(static_cast<clang::TargetInfo::IntType>(T));
}

uint64_t clang_TargetInfo_getPointerWidth(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getPointerWidth(
      static_cast<clang::LangAS>(AddrSpace));
}

uint64_t clang_TargetInfo_getPointerAlign(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getPointerAlign(
      static_cast<clang::LangAS>(AddrSpace));
}

uint64_t clang_TargetInfo_getMaxPointerWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxPointerWidth();
}

uint64_t clang_TargetInfo_getNullPointerValue(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getNullPointerValue(
      static_cast<clang::LangAS>(AddrSpace));
}

unsigned clang_TargetInfo_getBoolWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getBoolWidth();
}

unsigned clang_TargetInfo_getBoolAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getBoolAlign();
}

unsigned clang_TargetInfo_getCharWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getCharWidth();
}

unsigned clang_TargetInfo_getCharAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getCharAlign();
}

unsigned clang_TargetInfo_getShortWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortWidth();
}

unsigned clang_TargetInfo_getShortAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortAlign();
}

unsigned clang_TargetInfo_getIntWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIntWidth();
}

unsigned clang_TargetInfo_getIntAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIntAlign();
}

unsigned clang_TargetInfo_getLongWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongWidth();
}

unsigned clang_TargetInfo_getLongAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongAlign();
}

unsigned clang_TargetInfo_getLongLongWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongLongWidth();
}

unsigned clang_TargetInfo_getLongLongAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongLongAlign();
}

unsigned clang_TargetInfo_getInt128Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getInt128Align();
}

bool clang_TargetInfo_hasInt128Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasInt128Type();
}

bool clang_TargetInfo_hasBitIntType(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasBitIntType();
}

size_t clang_TargetInfo_getMaxBitIntWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxBitIntWidth();
}

bool clang_TargetInfo_hasLegalHalfType(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasLegalHalfType();
}

bool clang_TargetInfo_allowHalfArgsAndReturns(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->allowHalfArgsAndReturns();
}

bool clang_TargetInfo_hasFloat128Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasFloat128Type();
}

bool clang_TargetInfo_hasFloat16Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasFloat16Type();
}

bool clang_TargetInfo_hasBFloat16Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasBFloat16Type();
}

bool clang_TargetInfo_hasFullBFloat16Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasFullBFloat16Type();
}

bool clang_TargetInfo_hasIbm128Type(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasIbm128Type();
}

bool clang_TargetInfo_hasLongDoubleType(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasLongDoubleType();
}

bool clang_TargetInfo_hasFPReturn(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasFPReturn();
}

bool clang_TargetInfo_hasStrictFP(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasStrictFP();
}

unsigned clang_TargetInfo_getSuitableAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getSuitableAlign();
}

unsigned clang_TargetInfo_getDefaultAlignForAttributeAligned(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getDefaultAlignForAttributeAligned();
}

unsigned clang_TargetInfo_getMinGlobalAlign(CXTargetInfo_ TI, uint64_t Size) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMinGlobalAlign(Size, false);
}

unsigned clang_TargetInfo_getNewAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getNewAlign();
}

unsigned clang_TargetInfo_getWCharWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getWCharWidth();
}

unsigned clang_TargetInfo_getWCharAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getWCharAlign();
}

unsigned clang_TargetInfo_getChar16Width(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getChar16Width();
}

unsigned clang_TargetInfo_getChar16Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getChar16Align();
}

unsigned clang_TargetInfo_getChar32Width(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getChar32Width();
}

unsigned clang_TargetInfo_getChar32Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getChar32Align();
}

unsigned clang_TargetInfo_getHalfWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getHalfWidth();
}

unsigned clang_TargetInfo_getHalfAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getHalfAlign();
}

unsigned clang_TargetInfo_getFloatWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFloatWidth();
}

unsigned clang_TargetInfo_getFloatAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFloatAlign();
}

unsigned clang_TargetInfo_getBFloat16Width(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getBFloat16Width();
}

unsigned clang_TargetInfo_getBFloat16Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getBFloat16Align();
}

unsigned clang_TargetInfo_getDoubleWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getDoubleWidth();
}

unsigned clang_TargetInfo_getDoubleAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getDoubleAlign();
}

unsigned clang_TargetInfo_getLongDoubleWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongDoubleWidth();
}

unsigned clang_TargetInfo_getLongDoubleAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongDoubleAlign();
}

unsigned clang_TargetInfo_getFloat128Width(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFloat128Width();
}

unsigned clang_TargetInfo_getFloat128Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFloat128Align();
}

unsigned clang_TargetInfo_getIbm128Width(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIbm128Width();
}

unsigned clang_TargetInfo_getIbm128Align(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIbm128Align();
}

const char *clang_TargetInfo_getLongDoubleMangling(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongDoubleMangling();
}

const char *clang_TargetInfo_getFloat128Mangling(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFloat128Mangling();
}

const char *clang_TargetInfo_getIbm128Mangling(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIbm128Mangling();
}

const char *clang_TargetInfo_getBFloat16Mangling(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getBFloat16Mangling();
}

bool clang_TargetInfo_supportSourceEvalMethod(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->supportSourceEvalMethod();
}

unsigned clang_TargetInfo_getLargeArrayMinWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLargeArrayMinWidth();
}

unsigned clang_TargetInfo_getLargeArrayAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLargeArrayAlign();
}

unsigned clang_TargetInfo_getMaxAtomicPromoteWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxAtomicPromoteWidth();
}

unsigned clang_TargetInfo_getMaxAtomicInlineWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxAtomicInlineWidth();
}

bool clang_TargetInfo_hasBuiltinAtomic(CXTargetInfo_ TI, uint64_t AtomicSizeInBits,
                                       uint64_t AlignmentInBits) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasBuiltinAtomic(AtomicSizeInBits,
                                                                AlignmentInBits);
}

unsigned clang_TargetInfo_getMaxVectorAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxVectorAlign();
}

unsigned clang_TargetInfo_getMaxOpenCLWorkGroupSize(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxOpenCLWorkGroupSize();
}

unsigned clang_TargetInfo_getExnObjectAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getExnObjectAlignment();
}

unsigned clang_TargetInfo_getIntMaxTWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getIntMaxTWidth();
}

unsigned clang_TargetInfo_getUnwindWordWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnwindWordWidth();
}

unsigned clang_TargetInfo_getRegisterWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getRegisterWidth();
}

const char *clang_TargetInfo_getUserLabelPrefix(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUserLabelPrefix();
}

const char *clang_TargetInfo_getMCountName(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMCountName();
}

bool clang_TargetInfo_useSignedCharForObjCBool(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useSignedCharForObjCBool();
}

bool clang_TargetInfo_useBitFieldTypeAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useBitFieldTypeAlignment();
}

bool clang_TargetInfo_useZeroLengthBitfieldAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useZeroLengthBitfieldAlignment();
}

bool clang_TargetInfo_useLeadingZeroLengthBitfield(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useLeadingZeroLengthBitfield();
}

unsigned clang_TargetInfo_getZeroLengthBitfieldBoundary(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getZeroLengthBitfieldBoundary();
}

unsigned clang_TargetInfo_getMaxAlignedAttribute(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxAlignedAttribute();
}

bool clang_TargetInfo_useExplicitBitFieldAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useExplicitBitFieldAlignment();
}

bool clang_TargetInfo_hasAlignMac68kSupport(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasAlignMac68kSupport();
}

const char *clang_TargetInfo_getTypeName(CXTargetInfo_IntType T) {
  return clang::TargetInfo::getTypeName(static_cast<clang::TargetInfo::IntType>(T));
}

const char *clang_TargetInfo_getTypeConstantSuffix(CXTargetInfo_ TI,
                                                   CXTargetInfo_IntType T) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getTypeConstantSuffix(
      static_cast<clang::TargetInfo::IntType>(T));
}

const char *clang_TargetInfo_getTypeFormatModifier(CXTargetInfo_IntType T) {
  return clang::TargetInfo::getTypeFormatModifier(
      static_cast<clang::TargetInfo::IntType>(T));
}

bool clang_TargetInfo_useObjCFPRetForRealType(CXTargetInfo_ TI, CXFloatModeKind T) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useObjCFPRetForRealType(
      static_cast<clang::FloatModeKind>(T));
}

bool clang_TargetInfo_useObjCFP2RetForComplexLongDouble(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useObjCFP2RetForComplexLongDouble();
}

bool clang_TargetInfo_useFP16ConversionIntrinsics(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useFP16ConversionIntrinsics();
}

bool clang_TargetInfo_useAddressSpaceMapMangling(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->useAddressSpaceMapMangling();
}

CXString clang_TargetInfo_getTargetDefines(CXTargetInfo_ TI, CXLangOptions LO) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::MacroBuilder Builder(OS);
  reinterpret_cast<clang::TargetInfo *>(TI)->getTargetDefines(
      *reinterpret_cast<clang::LangOptions *>(LO), Builder);
  return extra::makeCXString(S);
}

bool clang_TargetInfo_getVScaleRange(CXTargetInfo_ TI, CXLangOptions LO, unsigned *Min,
                                     unsigned *Max) {
  auto Range = reinterpret_cast<clang::TargetInfo *>(TI)->getVScaleRange(
      *reinterpret_cast<clang::LangOptions *>(LO), false);
  if (!Range)
    return false;
  *Min = Range->first;
  *Max = Range->second;
  return true;
}

bool clang_TargetInfo_isCLZForZeroUndef(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isCLZForZeroUndef();
}

CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_BuiltinVaListKind>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getBuiltinVaListKind());
}

bool clang_TargetInfo_hasBuiltinMSVaList(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasBuiltinMSVaList();
}

bool clang_TargetInfo_isRenderScriptTarget(CXTargetInfo_ TI) {
  (void)TI;
  // LLVM 20 dropped Language::RenderScript and TargetInfo::isRenderScriptTarget.
  return false;
}

bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasAArch64SVETypes();
}

bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasRISCVVTypes();
}

bool clang_TargetInfo_allowAMDGPUUnsafeFPAtomics(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->allowAMDGPUUnsafeFPAtomics();
}

uint32_t clang_TargetInfo_getARMCDECoprocMask(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getARMCDECoprocMask();
}

bool clang_TargetInfo_isValidClobber(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isValidClobber(Name);
}

bool clang_TargetInfo_isValidGCCRegisterName(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isValidGCCRegisterName(Name);
}

CXString clang_TargetInfo_getNormalizedGCCRegisterName(CXTargetInfo_ TI, const char *Name,
                                                       bool ReturnCanonical) {
  auto *T = reinterpret_cast<clang::TargetInfo *>(TI);
  return extra::makeCXString(T->getNormalizedGCCRegisterName(Name, ReturnCanonical).str());
}

bool clang_TargetInfo_isSPRegName(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isSPRegName(Name);
}

CXString clang_TargetInfo_getConstraintRegister(CXTargetInfo_ TI, const char *Constraint,
                                                const char *Expression) {
  auto *T = reinterpret_cast<clang::TargetInfo *>(TI);
  return extra::makeCXString(T->getConstraintRegister(Constraint, Expression).str());
}

// TargetInfo::ConstraintInfo

CXConstraintInfo clang_ConstraintInfo_create(const char *ConstraintStr, const char *Name) {
  auto CI = std::make_unique<clang::TargetInfo::ConstraintInfo>(ConstraintStr, Name);
  return reinterpret_cast<CXConstraintInfo>(CI.release());
}

void clang_ConstraintInfo_dispose(CXConstraintInfo CI) {
  delete reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI);
}

const char *clang_ConstraintInfo_getConstraintStr(CXConstraintInfo CI) {
  auto *C = reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI);
  return C->getConstraintStr().c_str();
}

const char *clang_ConstraintInfo_getName(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->getName().c_str();
}

bool clang_ConstraintInfo_isReadWrite(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->isReadWrite();
}

bool clang_ConstraintInfo_earlyClobber(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->earlyClobber();
}

bool clang_ConstraintInfo_allowsRegister(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->allowsRegister();
}

bool clang_ConstraintInfo_allowsMemory(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->allowsMemory();
}

bool clang_ConstraintInfo_hasMatchingInput(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->hasMatchingInput();
}

bool clang_ConstraintInfo_hasTiedOperand(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->hasTiedOperand();
}

unsigned clang_ConstraintInfo_getTiedOperand(CXConstraintInfo CI) {
  return reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->getTiedOperand();
}

bool clang_ConstraintInfo_requiresImmediateConstant(CXConstraintInfo CI) {
  auto *C = reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI);
  return C->requiresImmediateConstant();
}

bool clang_ConstraintInfo_isValidAsmImmediate(CXConstraintInfo CI, int64_t Value) {
  auto *C = reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI);
  return C->isValidAsmImmediate(
      llvm::APInt(64, static_cast<uint64_t>(Value), /*isSigned=*/true));
}

void clang_ConstraintInfo_setIsReadWrite(CXConstraintInfo CI) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setIsReadWrite();
}

void clang_ConstraintInfo_setEarlyClobber(CXConstraintInfo CI) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setEarlyClobber();
}

void clang_ConstraintInfo_setAllowsMemory(CXConstraintInfo CI) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setAllowsMemory();
}

void clang_ConstraintInfo_setAllowsRegister(CXConstraintInfo CI) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setAllowsRegister();
}

void clang_ConstraintInfo_setHasMatchingInput(CXConstraintInfo CI) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setHasMatchingInput();
}

void clang_ConstraintInfo_setRequiresImmediate(CXConstraintInfo CI, int Min, int Max) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setRequiresImmediate(Min, Max);
}

void clang_ConstraintInfo_setTiedOperand(CXConstraintInfo CI, unsigned N,
                                         CXConstraintInfo Output) {
  reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(CI)->setTiedOperand(
      N, *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(Output));
}

bool clang_TargetInfo_validateGlobalRegisterVariable(CXTargetInfo_ TI, const char *RegName,
                                                     unsigned RegSize,
                                                     bool *HasSizeMismatch) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateGlobalRegisterVariable(
      RegName, RegSize, *HasSizeMismatch);
}

bool clang_TargetInfo_validateOutputConstraint(CXTargetInfo_ TI, CXConstraintInfo Info) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateOutputConstraint(
      *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(Info));
}

bool clang_TargetInfo_validateInputConstraint(CXTargetInfo_ TI,
                                              CXConstraintInfo *OutputConstraints,
                                              unsigned NumOutputs, CXConstraintInfo Info) {
  llvm::SmallVector<clang::TargetInfo::ConstraintInfo, 4> Outs;
  Outs.reserve(NumOutputs);
  for (unsigned I = 0; I < NumOutputs; ++I)
    Outs.push_back(
        *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(OutputConstraints[I]));
  bool OK = reinterpret_cast<clang::TargetInfo *>(TI)->validateInputConstraint(
      Outs, *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(Info));
  // The outputs are an in/out parameter: a tie is recorded on the output, not the input.
  for (unsigned I = 0; I < NumOutputs; ++I)
    *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(OutputConstraints[I]) = Outs[I];
  return OK;
}

bool clang_TargetInfo_setCPU(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->setCPU(std::string(Name));
}

bool clang_TargetInfo_setABI(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->setABI(std::string(Name));
}

bool clang_TargetInfo_setFPMath(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->setFPMath(llvm::StringRef(Name));
}

bool clang_TargetInfo_resolveSymbolicName(CXTargetInfo_ TI, const char *Name,
                                          CXConstraintInfo *OutputConstraints,
                                          unsigned NumOutputs, unsigned *Consumed,
                                          unsigned *Index) {
  llvm::SmallVector<clang::TargetInfo::ConstraintInfo, 4> Outs;
  Outs.reserve(NumOutputs);
  for (unsigned I = 0; I < NumOutputs; ++I)
    Outs.push_back(
        *reinterpret_cast<clang::TargetInfo::ConstraintInfo *>(OutputConstraints[I]));
  const char *Cursor = Name;
  unsigned Idx = 0;
  bool OK = reinterpret_cast<clang::TargetInfo *>(TI)->resolveSymbolicName(Cursor, Outs, Idx);
  if (OK) {
    // Cursor now sits ON the closing ']'; report the distance rather than the pointer.
    if (Consumed)
      *Consumed = static_cast<unsigned>(Cursor - Name);
    if (Index)
      *Index = Idx;
  }
  return OK;
}

bool clang_TargetInfo_validateConstraintModifier(CXTargetInfo_ TI, const char *Constraint,
                                                 char Modifier, unsigned Size,
                                                 CXString *Suggested) {
  std::string S;
  bool OK = reinterpret_cast<clang::TargetInfo *>(TI)->validateConstraintModifier(
      llvm::StringRef(Constraint), Modifier, Size, S);
  if (Suggested)
    *Suggested = extra::makeCXString(S);
  return OK;
}

CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI) {
  return extra::makeCXString(
      std::string(reinterpret_cast<clang::TargetInfo *>(TI)->getClobbers()));
}

bool clang_TargetInfo_isNan2008(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isNan2008();
}

const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getTriple().getTriple().c_str();
}

CXString clang_TargetInfo_getTargetID(CXTargetInfo_ TI) {
  auto ID = reinterpret_cast<clang::TargetInfo *>(TI)->getTargetID();
  return extra::makeCXString(ID ? *ID : std::string());
}

const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getDataLayoutString();
}

bool clang_TargetInfo_hasProtectedVisibility(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasProtectedVisibility();
}

bool clang_TargetInfo_shouldDLLImportComdatSymbols(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->shouldDLLImportComdatSymbols();
}

bool clang_TargetInfo_hasPS4DLLImportExport(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasPS4DLLImportExport();
}

void clang_TargetInfo_adjust(CXTargetInfo_ TI, CXDiagnosticsEngine Diags,
                             CXLangOptions Opts) {
  reinterpret_cast<clang::TargetInfo *>(TI)->adjust(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags),
      *reinterpret_cast<clang::LangOptions *>(Opts));
}

CXString clang_TargetInfo_getABI(CXTargetInfo_ TI) {
  return extra::makeCXString(reinterpret_cast<clang::TargetInfo *>(TI)->getABI().str());
}

CXTargetCXXABI_Kind clang_TargetInfo_getCXXABI(CXTargetInfo_ TI) {
  return static_cast<CXTargetCXXABI_Kind>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getCXXABI().getKind());
}

CXStringSet *clang_TargetInfo_fillValidCPUList(CXTargetInfo_ TI) {
  llvm::SmallVector<llvm::StringRef, 32> Values;
  reinterpret_cast<clang::TargetInfo *>(TI)->fillValidCPUList(Values);
  std::vector<std::string> Strs;
  Strs.reserve(Values.size());
  for (llvm::StringRef S : Values)
    Strs.push_back(S.str());
  return extra::makeCXStringSet(Strs);
}

CXStringSet *clang_TargetInfo_fillValidTuneCPUList(CXTargetInfo_ TI) {
  llvm::SmallVector<llvm::StringRef, 32> Values;
  reinterpret_cast<clang::TargetInfo *>(TI)->fillValidTuneCPUList(Values);
  std::vector<std::string> Strs;
  Strs.reserve(Values.size());
  for (llvm::StringRef S : Values)
    Strs.push_back(S.str());
  return extra::makeCXStringSet(Strs);
}

bool clang_TargetInfo_isValidCPUName(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isValidCPUName(Name);
}

bool clang_TargetInfo_isValidTuneCPUName(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isValidTuneCPUName(Name);
}

bool clang_TargetInfo_supportsTargetAttributeTune(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->supportsTargetAttributeTune();
}

bool clang_TargetInfo_isValidFeatureName(CXTargetInfo_ TI, const char *Feature) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isValidFeatureName(Feature);
}

bool clang_TargetInfo_doesFeatureAffectCodeGen(CXTargetInfo_ TI, const char *Feature) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->doesFeatureAffectCodeGen(Feature);
}

CXString clang_TargetInfo_getFeatureDependencies(CXTargetInfo_ TI,
                                                 const char *Feature) {
  (void)TI;
  (void)Feature;
  // LLVM 20 dropped TargetInfo::getFeatureDependencies.
  return extra::makeCXString("");
}

bool clang_TargetInfo_isBranchProtectionSupportedArch(CXTargetInfo_ TI, const char *Arch) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isBranchProtectionSupportedArch(Arch);
}

bool clang_TargetInfo_hasFeature(CXTargetInfo_ TI, const char *Feature) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasFeature(Feature);
}

bool clang_TargetInfo_isReadOnlyFeature(CXTargetInfo_ TI, const char *Feature) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isReadOnlyFeature(Feature);
}

bool clang_TargetInfo_supportsMultiVersioning(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->supportsMultiVersioning();
}

bool clang_TargetInfo_supportsIFunc(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->supportsIFunc();
}

bool clang_TargetInfo_validateCpuSupports(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateCpuSupports(Name);
}

unsigned clang_TargetInfo_multiVersionSortPriority(CXTargetInfo_ TI, const char *Name) {
  (void)TI;
  (void)Name;
  // LLVM 20 dropped TargetInfo::multiVersionSortPriority.
  return 0;
}

unsigned clang_TargetInfo_multiVersionFeatureCost(CXTargetInfo_ TI) {
  (void)TI;
  // LLVM 20 dropped TargetInfo::multiVersionFeatureCost.
  return 0;
}

bool clang_TargetInfo_validateCpuIs(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateCpuIs(Name);
}

bool clang_TargetInfo_validateCPUSpecificCPUDispatch(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateCPUSpecificCPUDispatch(Name);
}

char clang_TargetInfo_CPUSpecificManglingCharacter(CXTargetInfo_ TI, const char *Name) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->CPUSpecificManglingCharacter(Name);
}

// getCPUSpecificTuneName -- not wrapped, see the header.

CXStringSet *clang_TargetInfo_getCPUSpecificCPUDispatchFeatures(CXTargetInfo_ TI,
                                                                const char *Name) {
  llvm::SmallVector<llvm::StringRef, 32> Features;
  auto *T = reinterpret_cast<clang::TargetInfo *>(TI);
  T->getCPUSpecificCPUDispatchFeatures(Name, Features);
  std::vector<std::string> Strs;
  Strs.reserve(Features.size());
  for (llvm::StringRef S : Features)
    Strs.push_back(S.str());
  return extra::makeCXStringSet(Strs);
}

bool clang_TargetInfo_getCPUCacheLineSize(CXTargetInfo_ TI, unsigned *Size) {
  auto LineSize = reinterpret_cast<clang::TargetInfo *>(TI)->getCPUCacheLineSize();
  if (!LineSize)
    return false;
  *Size = *LineSize;
  return true;
}

unsigned clang_TargetInfo_getRegParmMax(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getRegParmMax();
}

bool clang_TargetInfo_isTLSSupported(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isTLSSupported();
}

unsigned clang_TargetInfo_getMaxTLSAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getMaxTLSAlign();
}

bool clang_TargetInfo_isVLASupported(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isVLASupported();
}

bool clang_TargetInfo_isSEHTrySupported(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isSEHTrySupported();
}

bool clang_TargetInfo_hasNoAsmVariants(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasNoAsmVariants();
}

int clang_TargetInfo_getEHDataRegisterNumber(CXTargetInfo_ TI, unsigned RegNo) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getEHDataRegisterNumber(RegNo);
}

const char *clang_TargetInfo_getStaticInitSectionSpecifier(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getStaticInitSectionSpecifier();
}

unsigned clang_TargetInfo_getTargetAddressSpace(CXTargetInfo_ TI, CXLangAS AS) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getTargetAddressSpace(
      static_cast<clang::LangAS>(AS));
}

CXLangAS clang_TargetInfo_getOpenCLBuiltinAddressSpace(CXTargetInfo_ TI, unsigned AS) {
  return static_cast<CXLangAS>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getOpenCLBuiltinAddressSpace(AS));
}

CXLangAS clang_TargetInfo_getCUDABuiltinAddressSpace(CXTargetInfo_ TI, unsigned AS) {
  return static_cast<CXLangAS>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getCUDABuiltinAddressSpace(AS));
}

bool clang_TargetInfo_getConstantAddressSpace(CXTargetInfo_ TI, CXLangAS *AS) {
  auto Space = reinterpret_cast<clang::TargetInfo *>(TI)->getConstantAddressSpace();
  if (!Space)
    return false;
  *AS = static_cast<CXLangAS>(*Space);
  return true;
}

CXString clang_TargetInfo_getPlatformName(CXTargetInfo_ TI) {
  return extra::makeCXString(
      reinterpret_cast<clang::TargetInfo *>(TI)->getPlatformName().str());
}

CXString clang_TargetInfo_getPlatformMinVersion(CXTargetInfo_ TI) {
  return extra::makeCXString(
      reinterpret_cast<clang::TargetInfo *>(TI)->getPlatformMinVersion().getAsString());
}

bool clang_TargetInfo_isBigEndian(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isBigEndian();
}

bool clang_TargetInfo_isLittleEndian(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->isLittleEndian();
}

bool clang_TargetInfo_supportsExtendIntArgs(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->supportsExtendIntArgs();
}

bool clang_TargetInfo_checkArithmeticFenceSupported(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->checkArithmeticFenceSupported();
}

CXCallingConv_ clang_TargetInfo_getDefaultCallingConv(CXTargetInfo_ TI) {
  return static_cast<CXCallingConv_>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getDefaultCallingConv());
}

CXTargetInfo_CallingConvCheckResult
clang_TargetInfo_checkCallingConvention(CXTargetInfo_ TI, CXCallingConv_ CC) {
  return static_cast<CXTargetInfo_CallingConvCheckResult>(
      reinterpret_cast<clang::TargetInfo *>(TI)->checkCallingConvention(
          static_cast<clang::CallingConv>(CC)));
}

CXTargetInfo_CallingConvKind clang_TargetInfo_getCallingConvKind(CXTargetInfo_ TI,
                                                                 bool ClangABICompat4) {
  return static_cast<CXTargetInfo_CallingConvKind>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getCallingConvKind(ClangABICompat4));
}

bool clang_TargetInfo_areDefaultedSMFStillPOD(CXTargetInfo_ TI, CXLangOptions LO) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->areDefaultedSMFStillPOD(
      *reinterpret_cast<clang::LangOptions *>(LO));
}
bool clang_TargetInfo_hasSjLjLowering(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasSjLjLowering();
}

bool clang_TargetInfo_checkCFProtectionBranchSupported(CXTargetInfo_ TI,
                                                       CXDiagnosticsEngine Diags) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->checkCFProtectionBranchSupported(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

bool clang_TargetInfo_checkCFProtectionReturnSupported(CXTargetInfo_ TI,
                                                       CXDiagnosticsEngine Diags) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->checkCFProtectionReturnSupported(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

bool clang_TargetInfo_allowsLargerPreferedTypeAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->allowsLargerPreferedTypeAlignment();
}

bool clang_TargetInfo_defaultsToAIXPowerAlignment(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->defaultsToAIXPowerAlignment();
}

CXLangAS clang_TargetInfo_getOpenCLTypeAddrSpace(CXTargetInfo_ TI, CXOpenCLTypeKind TK) {
  return static_cast<CXLangAS>(reinterpret_cast<clang::TargetInfo *>(TI)->getOpenCLTypeAddrSpace(
      static_cast<clang::OpenCLTypeKind>(TK)));
}

unsigned clang_TargetInfo_getVtblPtrAddressSpace(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getVtblPtrAddressSpace();
}

bool clang_TargetInfo_getDWARFAddressSpace(CXTargetInfo_ TI, unsigned AddressSpace,
                                           unsigned *Out) {
  auto Space = reinterpret_cast<clang::TargetInfo *>(TI)->getDWARFAddressSpace(AddressSpace);
  if (!Space)
    return false;
  *Out = *Space;
  return true;
}

CXString clang_TargetInfo_getSDKVersion(CXTargetInfo_ TI) {
  return extra::makeCXString(
      reinterpret_cast<clang::TargetInfo *>(TI)->getSDKVersion().getAsString());
}

bool clang_TargetInfo_validateTarget(CXTargetInfo_ TI, CXDiagnosticsEngine Diags) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->validateTarget(
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags));
}

bool clang_TargetInfo_allowDebugInfoForExternalRef(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->allowDebugInfoForExternalRef();
}

const char *clang_TargetInfo_getDarwinTargetVariantTriple(CXTargetInfo_ TI) {
  const llvm::Triple *T =
      reinterpret_cast<clang::TargetInfo *>(TI)->getDarwinTargetVariantTriple();
  return T ? T->getTriple().c_str() : nullptr;
}

bool clang_TargetInfo_hasHIPImageSupport(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->hasHIPImageSupport();
}

unsigned clang_TargetInfo_getAccumAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getAccumAlign();
}

unsigned clang_TargetInfo_getAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getAccumIBits();
}

unsigned clang_TargetInfo_getAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getAccumScale();
}

unsigned clang_TargetInfo_getAccumWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getAccumWidth();
}

unsigned clang_TargetInfo_getFractAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFractAlign();
}

unsigned clang_TargetInfo_getFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFractScale();
}

unsigned clang_TargetInfo_getFractWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getFractWidth();
}

unsigned clang_TargetInfo_getLongAccumAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongAccumAlign();
}

unsigned clang_TargetInfo_getLongAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongAccumIBits();
}

unsigned clang_TargetInfo_getLongAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongAccumScale();
}

unsigned clang_TargetInfo_getLongAccumWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongAccumWidth();
}

unsigned clang_TargetInfo_getLongFractAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongFractAlign();
}

unsigned clang_TargetInfo_getLongFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongFractScale();
}

unsigned clang_TargetInfo_getLongFractWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getLongFractWidth();
}

unsigned clang_TargetInfo_getShortAccumAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortAccumAlign();
}

unsigned clang_TargetInfo_getShortAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortAccumIBits();
}

unsigned clang_TargetInfo_getShortAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortAccumScale();
}

unsigned clang_TargetInfo_getShortAccumWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortAccumWidth();
}

unsigned clang_TargetInfo_getShortFractAlign(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortFractAlign();
}

unsigned clang_TargetInfo_getShortFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortFractScale();
}

unsigned clang_TargetInfo_getShortFractWidth(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getShortFractWidth();
}

unsigned clang_TargetInfo_getUnsignedAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedAccumIBits();
}

unsigned clang_TargetInfo_getUnsignedAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedAccumScale();
}

unsigned clang_TargetInfo_getUnsignedFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedFractScale();
}

unsigned clang_TargetInfo_getUnsignedLongAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedLongAccumIBits();
}

unsigned clang_TargetInfo_getUnsignedLongAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedLongAccumScale();
}

unsigned clang_TargetInfo_getUnsignedLongFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedLongFractScale();
}

unsigned clang_TargetInfo_getUnsignedShortAccumIBits(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedShortAccumIBits();
}

unsigned clang_TargetInfo_getUnsignedShortAccumScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedShortAccumScale();
}

unsigned clang_TargetInfo_getUnsignedShortFractScale(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->getUnsignedShortFractScale();
}

bool clang_TargetInfo_doUnsignedFixedPointTypesHavePadding(CXTargetInfo_ TI) {
  return reinterpret_cast<clang::TargetInfo *>(TI)->doUnsignedFixedPointTypesHavePadding();
}

CXFPEvalMethodKind clang_TargetInfo_getFPEvalMethod(CXTargetInfo_ TI) {
  return static_cast<CXFPEvalMethodKind>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getFPEvalMethod());
}

CXFloatModeKind clang_TargetInfo_getRealTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                    CXFloatModeKind ExplicitType) {
  return static_cast<CXFloatModeKind>(
      reinterpret_cast<clang::TargetInfo *>(TI)->getRealTypeByWidth(
          BitWidth, static_cast<clang::FloatModeKind>(ExplicitType)));
}
