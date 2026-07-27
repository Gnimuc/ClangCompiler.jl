#include "clang-ex/Basic/CXTargetInfo.h"
#include "utils.h"
#include "clang/Basic/TargetInfo.h"

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts) {
  return clang::TargetInfo::CreateTargetInfo(
      *static_cast<clang::DiagnosticsEngine *>(DE),
      std::shared_ptr<clang::TargetOptions>(static_cast<clang::TargetOptions *>(Opts)));
}

CXTargetOptions clang_TargetInfo_getTargetOpts(CXTargetInfo_ TI) {
  return &static_cast<clang::TargetInfo *>(TI)->getTargetOpts();
}

CXTargetInfo_IntType clang_TargetInfo_getSizeType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getSizeType());
}

CXTargetInfo_IntType clang_TargetInfo_getSignedSizeType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getSignedSizeType());
}

CXTargetInfo_IntType clang_TargetInfo_getIntMaxType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getIntMaxType());
}

CXTargetInfo_IntType clang_TargetInfo_getUIntMaxType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getUIntMaxType());
}

CXTargetInfo_IntType clang_TargetInfo_getPtrDiffType(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getPtrDiffType(
          static_cast<clang::LangAS>(AddrSpace)));
}

CXTargetInfo_IntType clang_TargetInfo_getUnsignedPtrDiffType(CXTargetInfo_ TI,
                                                             CXLangAS AddrSpace) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getUnsignedPtrDiffType(
          static_cast<clang::LangAS>(AddrSpace)));
}

CXTargetInfo_IntType clang_TargetInfo_getIntPtrType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getIntPtrType());
}

CXTargetInfo_IntType clang_TargetInfo_getUIntPtrType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getUIntPtrType());
}

CXTargetInfo_IntType clang_TargetInfo_getWCharType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getWCharType());
}

CXTargetInfo_IntType clang_TargetInfo_getWIntType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getWIntType());
}

CXTargetInfo_IntType clang_TargetInfo_getChar16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getChar16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getChar32Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getChar32Type());
}

CXTargetInfo_IntType clang_TargetInfo_getInt64Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getInt64Type());
}

CXTargetInfo_IntType clang_TargetInfo_getUInt64Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getUInt64Type());
}

CXTargetInfo_IntType clang_TargetInfo_getInt16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getInt16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getUInt16Type(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getUInt16Type());
}

CXTargetInfo_IntType clang_TargetInfo_getSigAtomicType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getSigAtomicType());
}

CXTargetInfo_IntType clang_TargetInfo_getProcessIDType(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getProcessIDType());
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

CXTargetInfo_IntType clang_TargetInfo_getLeastIntTypeByWidth(CXTargetInfo_ TI,
                                                             unsigned BitWidth,
                                                             bool IsSigned) {
  return static_cast<CXTargetInfo_IntType>(
      static_cast<clang::TargetInfo *>(TI)->getLeastIntTypeByWidth(BitWidth, IsSigned));
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

uint64_t clang_TargetInfo_getNullPointerValue(CXTargetInfo_ TI, CXLangAS AddrSpace) {
  return static_cast<clang::TargetInfo *>(TI)->getNullPointerValue(
      static_cast<clang::LangAS>(AddrSpace));
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

unsigned clang_TargetInfo_getMinGlobalAlign(CXTargetInfo_ TI, uint64_t Size) {
  return static_cast<clang::TargetInfo *>(TI)->getMinGlobalAlign(Size);
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

unsigned clang_TargetInfo_getIbm128Width(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIbm128Width();
}

unsigned clang_TargetInfo_getIbm128Align(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIbm128Align();
}

const char *clang_TargetInfo_getLongDoubleMangling(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLongDoubleMangling();
}

const char *clang_TargetInfo_getFloat128Mangling(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getFloat128Mangling();
}

const char *clang_TargetInfo_getIbm128Mangling(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIbm128Mangling();
}

const char *clang_TargetInfo_getBFloat16Mangling(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getBFloat16Mangling();
}

unsigned clang_TargetInfo_getLargeArrayMinWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLargeArrayMinWidth();
}

unsigned clang_TargetInfo_getLargeArrayAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getLargeArrayAlign();
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

unsigned clang_TargetInfo_getIntMaxTWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getIntMaxTWidth();
}

unsigned clang_TargetInfo_getUnwindWordWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getUnwindWordWidth();
}

unsigned clang_TargetInfo_getRegisterWidth(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getRegisterWidth();
}

const char *clang_TargetInfo_getUserLabelPrefix(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getUserLabelPrefix();
}

const char *clang_TargetInfo_getMCountName(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMCountName();
}

bool clang_TargetInfo_useSignedCharForObjCBool(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useSignedCharForObjCBool();
}

bool clang_TargetInfo_useBitFieldTypeAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useBitFieldTypeAlignment();
}

bool clang_TargetInfo_useZeroLengthBitfieldAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useZeroLengthBitfieldAlignment();
}

bool clang_TargetInfo_useLeadingZeroLengthBitfield(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useLeadingZeroLengthBitfield();
}

unsigned clang_TargetInfo_getZeroLengthBitfieldBoundary(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getZeroLengthBitfieldBoundary();
}

unsigned clang_TargetInfo_getMaxAlignedAttribute(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxAlignedAttribute();
}

bool clang_TargetInfo_useExplicitBitFieldAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useExplicitBitFieldAlignment();
}

bool clang_TargetInfo_hasAlignMac68kSupport(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasAlignMac68kSupport();
}

const char *clang_TargetInfo_getTypeName(CXTargetInfo_IntType T) {
  return clang::TargetInfo::getTypeName(static_cast<clang::TargetInfo::IntType>(T));
}

const char *clang_TargetInfo_getTypeConstantSuffix(CXTargetInfo_ TI,
                                                   CXTargetInfo_IntType T) {
  return static_cast<clang::TargetInfo *>(TI)->getTypeConstantSuffix(
      static_cast<clang::TargetInfo::IntType>(T));
}

const char *clang_TargetInfo_getTypeFormatModifier(CXTargetInfo_IntType T) {
  return clang::TargetInfo::getTypeFormatModifier(
      static_cast<clang::TargetInfo::IntType>(T));
}

bool clang_TargetInfo_useFP16ConversionIntrinsics(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useFP16ConversionIntrinsics();
}

bool clang_TargetInfo_useAddressSpaceMapMangling(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->useAddressSpaceMapMangling();
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

bool clang_TargetInfo_isCLZForZeroUndef(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isCLZForZeroUndef();
}

CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI) {
  return static_cast<CXTargetInfo_BuiltinVaListKind>(
      static_cast<clang::TargetInfo *>(TI)->getBuiltinVaListKind());
}

bool clang_TargetInfo_hasBuiltinMSVaList(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasBuiltinMSVaList();
}

bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasAArch64SVETypes();
}

bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasRISCVVTypes();
}

uint32_t clang_TargetInfo_getARMCDECoprocMask(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getARMCDECoprocMask();
}

bool clang_TargetInfo_isValidClobber(CXTargetInfo_ TI, const char *Name) {
  return static_cast<clang::TargetInfo *>(TI)->isValidClobber(Name);
}

bool clang_TargetInfo_isValidGCCRegisterName(CXTargetInfo_ TI, const char *Name) {
  return static_cast<clang::TargetInfo *>(TI)->isValidGCCRegisterName(Name);
}

CXString clang_TargetInfo_getNormalizedGCCRegisterName(CXTargetInfo_ TI, const char *Name,
                                                       bool ReturnCanonical) {
  auto *T = static_cast<clang::TargetInfo *>(TI);
  return extra::makeCXString(T->getNormalizedGCCRegisterName(Name, ReturnCanonical).str());
}

bool clang_TargetInfo_isSPRegName(CXTargetInfo_ TI, const char *Name) {
  return static_cast<clang::TargetInfo *>(TI)->isSPRegName(Name);
}

CXString clang_TargetInfo_getConstraintRegister(CXTargetInfo_ TI, const char *Constraint,
                                                const char *Expression) {
  auto *T = static_cast<clang::TargetInfo *>(TI);
  return extra::makeCXString(T->getConstraintRegister(Constraint, Expression).str());
}

CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI) {
  return extra::makeCXString(
      std::string(static_cast<clang::TargetInfo *>(TI)->getClobbers()));
}

bool clang_TargetInfo_isNan2008(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isNan2008();
}

const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getTriple().getTriple().c_str();
}

const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getDataLayoutString();
}

bool clang_TargetInfo_hasProtectedVisibility(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasProtectedVisibility();
}

bool clang_TargetInfo_shouldDLLImportComdatSymbols(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->shouldDLLImportComdatSymbols();
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

unsigned clang_TargetInfo_getRegParmMax(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getRegParmMax();
}

bool clang_TargetInfo_isTLSSupported(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isTLSSupported();
}

unsigned clang_TargetInfo_getMaxTLSAlign(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getMaxTLSAlign();
}

bool clang_TargetInfo_isVLASupported(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isVLASupported();
}

bool clang_TargetInfo_isSEHTrySupported(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->isSEHTrySupported();
}

bool clang_TargetInfo_hasNoAsmVariants(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasNoAsmVariants();
}

int clang_TargetInfo_getEHDataRegisterNumber(CXTargetInfo_ TI, unsigned RegNo) {
  return static_cast<clang::TargetInfo *>(TI)->getEHDataRegisterNumber(RegNo);
}

const char *clang_TargetInfo_getStaticInitSectionSpecifier(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getStaticInitSectionSpecifier();
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
bool clang_TargetInfo_hasSjLjLowering(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->hasSjLjLowering();
}

bool clang_TargetInfo_allowsLargerPreferedTypeAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->allowsLargerPreferedTypeAlignment();
}

bool clang_TargetInfo_defaultsToAIXPowerAlignment(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->defaultsToAIXPowerAlignment();
}

unsigned clang_TargetInfo_getVtblPtrAddressSpace(CXTargetInfo_ TI) {
  return static_cast<clang::TargetInfo *>(TI)->getVtblPtrAddressSpace();
}
