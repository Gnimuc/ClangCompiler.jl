#include "clang-ex/Basic/CXTargetInfo.h"
#include "utils.h"
#include "clang/Basic/TargetInfo.h"

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts) {
  return clang::TargetInfo::CreateTargetInfo(
      *static_cast<clang::DiagnosticsEngine *>(DE),
      std::shared_ptr<clang::TargetOptions>(static_cast<clang::TargetOptions *>(Opts)));
}

CXTargetInfo_IntType clang_TargetInfo_getSizeType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getSizeType());
}

CXTargetInfo_IntType clang_TargetInfo_getIntMaxType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getIntMaxType());
}

CXTargetInfo_IntType clang_TargetInfo_getPtrDiffType(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getPtrDiffType(
          static_cast<clang::LangAS>(AddrSpace)));
}

CXTargetInfo_IntType clang_TargetInfo_getIntPtrType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getIntPtrType());
}

CXTargetInfo_IntType clang_TargetInfo_getWCharType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getWCharType());
}

CXTargetInfo_IntType clang_TargetInfo_getInt64Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getInt64Type());
}

CXTargetInfo_IntType clang_TargetInfo_getCorrespondingUnsignedType(CXTargetInfo_IntType T) {
  return static_cast<CXTargetInfo_IntType>(clang::TargetInfo::getCorrespondingUnsignedType(
      static_cast<clang::TargetInfo::IntType>(T)));
}

unsigned clang_TargetInfo_getTypeWidth(CXTargetInfo_ TI, CXTargetInfo_IntType T) {
  return static_cast<clang::TargetInfo *>(TI)->getTypeWidth(
      static_cast<clang::TargetInfo::IntType>(T));
}

CXTargetInfo_IntType clang_TargetInfo_getIntTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                        bool IsSigned) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getIntTypeByWidth(BitWidth, IsSigned));
}

unsigned clang_TargetInfo_getTypeAlign(CXTargetInfo_ TI, CXTargetInfo_IntType T) {
  return static_cast<clang::TargetInfo *>(TI)->getTypeAlign(
      static_cast<clang::TargetInfo::IntType>(T));
}

bool clang_TargetInfo_isTypeSigned(CXTargetInfo_IntType T) {
  return clang::TargetInfo::isTypeSigned(static_cast<clang::TargetInfo::IntType>(T));
}

uint64_t clang_TargetInfo_getPointerWidth(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<clang::TargetInfo *>(TI)->getPointerWidth(
      static_cast<clang::LangAS>(AddrSpace));
}

uint64_t clang_TargetInfo_getPointerAlign(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<clang::TargetInfo *>(TI)->getPointerAlign(
      static_cast<clang::LangAS>(AddrSpace));
}

uint64_t clang_TargetInfo_getMaxPointerWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxPointerWidth();
}

unsigned clang_TargetInfo_getBoolWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getBoolWidth();
}

unsigned clang_TargetInfo_getBoolAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getBoolAlign();
}

unsigned clang_TargetInfo_getCharWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getCharWidth();
}

unsigned clang_TargetInfo_getCharAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getCharAlign();
}

unsigned clang_TargetInfo_getShortWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getShortWidth();
}

unsigned clang_TargetInfo_getShortAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getShortAlign();
}

unsigned clang_TargetInfo_getIntWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIntWidth();
}

unsigned clang_TargetInfo_getIntAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIntAlign();
}

unsigned clang_TargetInfo_getLongWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongWidth();
}

unsigned clang_TargetInfo_getLongAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongAlign();
}

unsigned clang_TargetInfo_getLongLongWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongLongWidth();
}

unsigned clang_TargetInfo_getLongLongAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongLongAlign();
}

unsigned clang_TargetInfo_getInt128Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getInt128Align();
}

bool clang_TargetInfo_hasInt128Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasInt128Type();
}

bool clang_TargetInfo_hasBitIntType(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasBitIntType();
}

size_t clang_TargetInfo_getMaxBitIntWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxBitIntWidth();
}

bool clang_TargetInfo_hasLegalHalfType(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasLegalHalfType();
}

bool clang_TargetInfo_hasFloat128Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasFloat128Type();
}

bool clang_TargetInfo_hasFloat16Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasFloat16Type();
}

bool clang_TargetInfo_hasBFloat16Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasBFloat16Type();
}

bool clang_TargetInfo_hasFullBFloat16Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasFullBFloat16Type();
}

bool clang_TargetInfo_hasIbm128Type(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasIbm128Type();
}

bool clang_TargetInfo_hasLongDoubleType(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasLongDoubleType();
}

bool clang_TargetInfo_hasFPReturn(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasFPReturn();
}

bool clang_TargetInfo_hasStrictFP(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasStrictFP();
}

unsigned clang_TargetInfo_getSuitableAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getSuitableAlign();
}

unsigned clang_TargetInfo_getDefaultAlignForAttributeAligned(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getDefaultAlignForAttributeAligned();
}

unsigned clang_TargetInfo_getNewAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getNewAlign();
}

unsigned clang_TargetInfo_getWCharWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getWCharWidth();
}

unsigned clang_TargetInfo_getWCharAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getWCharAlign();
}

unsigned clang_TargetInfo_getChar16Width(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getChar16Width();
}

unsigned clang_TargetInfo_getChar16Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getChar16Align();
}

unsigned clang_TargetInfo_getChar32Width(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getChar32Width();
}

unsigned clang_TargetInfo_getChar32Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getChar32Align();
}

unsigned clang_TargetInfo_getHalfWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getHalfWidth();
}

unsigned clang_TargetInfo_getHalfAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getHalfAlign();
}

unsigned clang_TargetInfo_getFloatWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getFloatWidth();
}

unsigned clang_TargetInfo_getFloatAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getFloatAlign();
}

unsigned clang_TargetInfo_getBFloat16Width(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getBFloat16Width();
}

unsigned clang_TargetInfo_getBFloat16Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getBFloat16Align();
}

unsigned clang_TargetInfo_getDoubleWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getDoubleWidth();
}

unsigned clang_TargetInfo_getDoubleAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getDoubleAlign();
}

unsigned clang_TargetInfo_getLongDoubleWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongDoubleWidth();
}

unsigned clang_TargetInfo_getLongDoubleAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongDoubleAlign();
}

unsigned clang_TargetInfo_getFloat128Width(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getFloat128Width();
}

unsigned clang_TargetInfo_getFloat128Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getFloat128Align();
}

unsigned clang_TargetInfo_getMaxAtomicPromoteWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxAtomicPromoteWidth();
}

unsigned clang_TargetInfo_getMaxAtomicInlineWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxAtomicInlineWidth();
}

bool clang_TargetInfo_hasBuiltinAtomic(CXTargetInfo_ TI, uint64_t AtomicSizeInBits,
                                       uint64_t AlignmentInBits) {
  return static_cast<clang::TargetInfo *>(TI)->hasBuiltinAtomic(AtomicSizeInBits,
                                                                AlignmentInBits);
}

unsigned clang_TargetInfo_getMaxVectorAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxVectorAlign();
}

unsigned clang_TargetInfo_getExnObjectAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getExnObjectAlignment();
}

const char *clang_TargetInfo_getUserLabelPrefix(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getUserLabelPrefix();
}

const char *clang_TargetInfo_getMCountName(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMCountName();
}

const char *clang_TargetInfo_getTypeName(CXTargetInfo_IntType T) {
  return clang::TargetInfo::getTypeName(static_cast<clang::TargetInfo::IntType>(T));
}

bool clang_TargetInfo_getVScaleRange(CXTargetInfo_ TI, CXLangOptions LO, unsigned *Min,
                                     unsigned *Max) {
  auto Range = static_cast<clang::TargetInfo *>(TI)->getVScaleRange(
      *static_cast<clang::LangOptions *>(LO));
  if (!Range)
    return false;
  *Min = Range->first;
  *Max = Range->second;
  return true;
}

CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_BuiltinVaListKind>(
      static_cast<clang::TargetInfo *>(TI)->getBuiltinVaListKind());
}

bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasAArch64SVETypes();
}

bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasRISCVVTypes();
}

CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI) {
  return extra::makeCXString(
      std::string(static_cast<clang::TargetInfo *>(TI)->getClobbers()));
}

const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getTriple().getTriple().c_str();
}

const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getDataLayoutString();
}

CXString clang_TargetInfo_getABI(CXTargetInfo_ TI) {
  return extra::makeCXString(static_cast<clang::TargetInfo *>(TI)->getABI().str());
}

CXTargetCXXABI_Kind clang_TargetInfo_getCXXABI(CXTargetInfo_ TI) {
  return static_cast<CXTargetCXXABI_Kind>(
      static_cast<clang::TargetInfo *>(TI)->getCXXABI().getKind());
}

CXStringSet *clang_TargetInfo_fillValidCPUList(CXTargetInfo_ TI) {
  llvm::SmallVector<llvm::StringRef, 32> Values;
  static_cast<clang::TargetInfo *>(TI)->fillValidCPUList(Values);
  std::vector<std::string> Strs;
  Strs.reserve(Values.size());
  for (llvm::StringRef S : Values)
    Strs.push_back(S.str());
  return extra::makeCXStringSet(Strs);
}

bool clang_TargetInfo_isValidCPUName(CXTargetInfo_ TI, const char *Name) {
  return static_cast<clang::TargetInfo *>(TI)->isValidCPUName(Name);
}

bool clang_TargetInfo_isValidTuneCPUName(CXTargetInfo_ TI, const char *Name) {
  return static_cast<clang::TargetInfo *>(TI)->isValidTuneCPUName(Name);
}

bool clang_TargetInfo_isValidFeatureName(CXTargetInfo_ TI, const char *Feature) {
  return static_cast<clang::TargetInfo *>(TI)->isValidFeatureName(Feature);
}

bool clang_TargetInfo_hasFeature(CXTargetInfo_ TI, const char *Feature) {
  return static_cast<clang::TargetInfo *>(TI)->hasFeature(Feature);
}

bool clang_TargetInfo_supportsMultiVersioning(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->supportsMultiVersioning();
}

bool clang_TargetInfo_supportsIFunc(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->supportsIFunc();
}

bool clang_TargetInfo_getCPUCacheLineSize(CXTargetInfo_ TI, unsigned *Size) {
  auto LineSize = static_cast<clang::TargetInfo *>(TI)->getCPUCacheLineSize();
  if (!LineSize)
    return false;
  *Size = *LineSize;
  return true;
}

bool clang_TargetInfo_isTLSSupported(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isTLSSupported();
}

bool clang_TargetInfo_isVLASupported(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isVLASupported();
}

unsigned clang_TargetInfo_getTargetAddressSpace(CXTargetInfo_ TI, CXLangAS AS) {
  return static_cast<clang::TargetInfo *>(TI)->getTargetAddressSpace(
      static_cast<clang::LangAS>(AS));
}

CXString clang_TargetInfo_getPlatformName(CXTargetInfo_ TI) {
  return extra::makeCXString(
      static_cast<clang::TargetInfo *>(TI)->getPlatformName().str());
}

bool clang_TargetInfo_isBigEndian(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isBigEndian();
}

bool clang_TargetInfo_isLittleEndian(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isLittleEndian();
}