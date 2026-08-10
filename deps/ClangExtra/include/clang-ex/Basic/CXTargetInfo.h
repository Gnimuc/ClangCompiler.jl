#ifndef LLVM_CLANG_C_EXTRA_CXTARGETINFO_H
#define LLVM_CLANG_C_EXTRA_CXTARGETINFO_H

#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXTargetCXXABI.h"

#include "clang-ex/Basic/CXFloatModeKind.h" // CXFloatModeKind
#include "clang-ex/Basic/CXLangOptions.h"   // CXFPEvalMethodKind
#include "clang-ex/Basic/CXSpecifiers.h"
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

// The target comes back holding the caller's own reference, so lending it to a
// CompilerInstance cannot free it and one dispose at the end does (MARSHALLING.md section
// 12). Returns null when the triple names no known target. `Opts` is absorbed: the target
// keeps it in a shared_ptr and frees it, so it must not be disposed separately.
CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts);

// Only for a target built by clang_TargetInfo_CreateTargetInfo. Targets reached through a
// getter -- clang_CompilerInstance_getTarget, clang_Preprocessor_getTargetInfo and the like
// -- are borrowed from their owner and must never be disposed.
void clang_TargetInfo_dispose(CXTargetInfo_ TI);

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
bool clang_TargetInfo_allowHalfArgsAndReturns(CXTargetInfo_ TI);
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
bool clang_TargetInfo_supportSourceEvalMethod(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLargeArrayMinWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLargeArrayAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicPromoteWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxAtomicInlineWidth(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBuiltinAtomic(CXTargetInfo_ TI, uint64_t AtomicSizeInBits,
                                       uint64_t AlignmentInBits);
unsigned clang_TargetInfo_getMaxVectorAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getMaxOpenCLWorkGroupSize(CXTargetInfo_ TI);
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
// Whether the real type T should use the "fpret" flavour of Objective-C message passing on
// this target. A bitmask test against RealTypeUsesObjCFPRetMask, which the target's own
// constructor sets whether or not Objective-C is being compiled; total for every
// enumerator, CXFloatModeKind_NoFloat included.
bool clang_TargetInfo_useObjCFPRetForRealType(CXTargetInfo_ TI, CXFloatModeKind T);
bool clang_TargetInfo_useObjCFP2RetForComplexLongDouble(CXTargetInfo_ TI);
bool clang_TargetInfo_useFP16ConversionIntrinsics(CXTargetInfo_ TI);
bool clang_TargetInfo_useAddressSpaceMapMangling(CXTargetInfo_ TI);
// The target's own `#define` block, as the text a MacroBuilder would emit -- the same text
// clang folds into the predefines buffer during InitializePreprocessor, reachable here from
// a TargetInfo alone because the shim materialises the raw_ostream sink (MARSHALLING.md
// §5). Pure virtual, so TI must be a concrete target; some targets read getTargetOpts(), so
// the same TargetOpts precondition as clang_TargetInfo_getTargetOpts applies. Targets read
// the LangOptions they are handed, and clang always calls this after adjust().
CXString clang_TargetInfo_getTargetDefines(CXTargetInfo_ TI, CXLangOptions LO);
bool clang_TargetInfo_getVScaleRange(CXTargetInfo_ TI, CXLangOptions LO, unsigned *Min,
                                     unsigned *Max);
bool clang_TargetInfo_isCLZForZeroUndef(CXTargetInfo_ TI);
CXTargetInfo_BuiltinVaListKind clang_TargetInfo_getBuiltinVaListKind(CXTargetInfo_ TI);
bool clang_TargetInfo_hasBuiltinMSVaList(CXTargetInfo_ TI);
bool clang_TargetInfo_isRenderScriptTarget(CXTargetInfo_ TI);
bool clang_TargetInfo_hasAArch64SVETypes(CXTargetInfo_ TI);
bool clang_TargetInfo_hasRISCVVTypes(CXTargetInfo_ TI);
bool clang_TargetInfo_allowAMDGPUUnsafeFPAtomics(CXTargetInfo_ TI);
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

// TargetInfo::ConstraintInfo

// The caller owns the object; release it with clang_ConstraintInfo_dispose.
CXConstraintInfo clang_ConstraintInfo_create(const char *ConstraintStr, const char *Name);

void clang_ConstraintInfo_dispose(CXConstraintInfo CI);

// Borrowed from the ConstraintInfo's own std::string storage; invalidated by dispose.
const char *clang_ConstraintInfo_getConstraintStr(CXConstraintInfo CI);
// Borrowed from the ConstraintInfo's own std::string storage; invalidated by dispose.
const char *clang_ConstraintInfo_getName(CXConstraintInfo CI);
bool clang_ConstraintInfo_isReadWrite(CXConstraintInfo CI);
bool clang_ConstraintInfo_earlyClobber(CXConstraintInfo CI);
bool clang_ConstraintInfo_allowsRegister(CXConstraintInfo CI);
bool clang_ConstraintInfo_allowsMemory(CXConstraintInfo CI);
bool clang_ConstraintInfo_hasMatchingInput(CXConstraintInfo CI);
bool clang_ConstraintInfo_hasTiedOperand(CXConstraintInfo CI);
// Precondition: hasTiedOperand(CI); asserts "Has no tied operand!" otherwise.
unsigned clang_ConstraintInfo_getTiedOperand(CXConstraintInfo CI);
bool clang_ConstraintInfo_requiresImmediateConstant(CXConstraintInfo CI);
// Whether Value satisfies the immediate constraint recorded by setRequiresImmediate; true
// on a ConstraintInfo that records none. Deliberately NOT the LLVMGenericValueRef bridge of
// MARSHALLING.md §1: the bounds a ConstraintInfo can hold are `int` (ImmRange.Min/Max) and
// its exact-value set is SmallSet<int, 4>, so a signed 64-bit argument is already wider
// than any constraint this receiver can express, and the shim rebuilds it as a signed
// 64-bit APInt without loss.
bool clang_ConstraintInfo_isValidAsmImmediate(CXConstraintInfo CI, int64_t Value);
void clang_ConstraintInfo_setIsReadWrite(CXConstraintInfo CI);
void clang_ConstraintInfo_setEarlyClobber(CXConstraintInfo CI);
void clang_ConstraintInfo_setAllowsMemory(CXConstraintInfo CI);
void clang_ConstraintInfo_setAllowsRegister(CXConstraintInfo CI);
void clang_ConstraintInfo_setHasMatchingInput(CXConstraintInfo CI);
// Wraps the (int Min, int Max) overload of ConstraintInfo::setRequiresImmediate.
void clang_ConstraintInfo_setRequiresImmediate(CXConstraintInfo CI, int Min, int Max);
// Copies Output's flags into CI and marks Output as having a matching input; CI's own
// constraint string and name are left alone.
void clang_ConstraintInfo_setTiedOperand(CXConstraintInfo CI, unsigned N,
                                         CXConstraintInfo Output);

// Whether RegName may back a global register variable of RegSize bits on this target.
// *HasSizeMismatch receives whether the register's own width differs from RegSize, and is
// written on both the true and the false return. Total for any string, the empty one
// included.
bool clang_TargetInfo_validateGlobalRegisterVariable(CXTargetInfo_ TI, const char *RegName,
                                                     unsigned RegSize,
                                                     bool *HasSizeMismatch);

// Parses Info's constraint string as an output constraint and updates Info's flags in
// place; false when it is not a valid output constraint for this target.
bool clang_TargetInfo_validateOutputConstraint(CXTargetInfo_ TI, CXConstraintInfo Info);

// Validate one input constraint against the outputs it may tie to. `OutputConstraints` is the
// array already accepted by clang_TargetInfo_validateOutputConstraint, in operand order;
// NumOutputs may be 0 and then OutputConstraints may be NULL.
//
// clang takes the outputs as a MutableArrayRef and MUTATES them: tying an input to output N
// records the tie on that output, which is what clang_ConstraintInfo_getTiedOperand later
// reads. The handles are separate boxes rather than one contiguous array, so the shim copies
// them into a local vector, calls, and copies the results back — an input that ties leaves its
// output changed exactly as the C++ API would.
bool clang_TargetInfo_validateInputConstraint(CXTargetInfo_ TI,
                                              CXConstraintInfo *OutputConstraints,
                                              unsigned NumOutputs, CXConstraintInfo Info);

// Select the target's CPU / ABI / floating-point maths by name, returning whether the target
// accepts it. `TargetInfo`'s own implementations return false, so a target that overrides
// none of them rejects every name rather than aborting.
bool clang_TargetInfo_setCPU(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_setABI(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_setFPMath(CXTargetInfo_ TI, const char *Name);

// Resolve a `[symbolic]` operand name in an asm constraint to its operand index.
//
// `Name` points at the '['. clang takes it as `const char *&` and advances it TO the closing
// ']' -- not past it, so "[sym]" reports 4 consumed and the caller still steps over the
// bracket itself. A moving interior pointer is not something the Julia side can hold
// (MARSHALLING.md §14), so the shim reports how far it moved in *Consumed instead. *Index
// receives the operand number. Both out-params are written only on success, and either may
// be NULL.
bool clang_TargetInfo_resolveSymbolicName(CXTargetInfo_ TI, const char *Name,
                                          CXConstraintInfo *OutputConstraints,
                                          unsigned NumOutputs, unsigned *Consumed,
                                          unsigned *Index);

// Whether `Modifier` (the letter in `%<modifier><operand>`) is valid for `Constraint` at an
// operand of `Size` bits. On rejection *Suggested receives the modifier clang would accept,
// as an owned CXString the caller disposes; it is set to the empty string otherwise. The base
// implementation accepts everything, so a target overriding nothing answers true.
bool clang_TargetInfo_validateConstraintModifier(CXTargetInfo_ TI, const char *Constraint,
                                                 char Modifier, unsigned Size,
                                                 CXString *Suggested);
CXString clang_TargetInfo_getClobbers(CXTargetInfo_ TI);
bool clang_TargetInfo_isNan2008(CXTargetInfo_ TI);
// Returns the triple string, borrowed from the llvm::Triple owned by the target.
const char *clang_TargetInfo_getTriple(CXTargetInfo_ TI);
// The target ID (the AMDGPU "processor:feature" form), or the empty string when the
// target exposes none -- the disengaged optional and an engaged empty string are
// deliberately conflated.
CXString clang_TargetInfo_getTargetID(CXTargetInfo_ TI);
const char *clang_TargetInfo_getDataLayoutString(CXTargetInfo_ TI);
bool clang_TargetInfo_hasProtectedVisibility(CXTargetInfo_ TI);
bool clang_TargetInfo_shouldDLLImportComdatSymbols(CXTargetInfo_ TI);
bool clang_TargetInfo_hasPS4DLLImportExport(CXTargetInfo_ TI);
// Applies the language options to the target and, in the other direction, lets the target
// force language options. Mutates BOTH operands and reports through Diags. Clang calls it
// exactly once, between CreateTargetInfo and the target's first use;
// clang_CompilerInstance_createTarget and clang_CompilerInstance_setTargetAndLangOpts
// already do so for the target they build. Idempotent in the fields it sets, but not in its
// diagnostics -- a second call re-emits them.
void clang_TargetInfo_adjust(CXTargetInfo_ TI, CXDiagnosticsEngine Diags,
                             CXLangOptions Opts);
CXString clang_TargetInfo_getABI(CXTargetInfo_ TI);
CXTargetCXXABI_Kind clang_TargetInfo_getCXXABI(CXTargetInfo_ TI);
// The caller owns the returned set (freed via libclang's clang_disposeStringSet).
CXStringSet *clang_TargetInfo_fillValidCPUList(CXTargetInfo_ TI);
// The caller owns the returned set (freed via libclang's clang_disposeStringSet). Falls
// back to the fillValidCPUList result on targets that do not model separate tune CPUs.
CXStringSet *clang_TargetInfo_fillValidTuneCPUList(CXTargetInfo_ TI);
bool clang_TargetInfo_isValidCPUName(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_isValidTuneCPUName(CXTargetInfo_ TI, const char *Name);
bool clang_TargetInfo_supportsTargetAttributeTune(CXTargetInfo_ TI);
bool clang_TargetInfo_isValidFeatureName(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_doesFeatureAffectCodeGen(CXTargetInfo_ TI, const char *Feature);
// Returns the empty string when Feature pulls in no other feature on this target (which is
// also what every target that does not model feature dependencies returns).
CXString clang_TargetInfo_getFeatureDependencies(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_isBranchProtectionSupportedArch(CXTargetInfo_ TI, const char *Arch);
bool clang_TargetInfo_hasFeature(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_isReadOnlyFeature(CXTargetInfo_ TI, const char *Feature);
bool clang_TargetInfo_supportsMultiVersioning(CXTargetInfo_ TI);
bool clang_TargetInfo_supportsIFunc(CXTargetInfo_ TI);
// Validates the argument of __builtin_cpu_supports; total for any string.
bool clang_TargetInfo_validateCpuSupports(CXTargetInfo_ TI, const char *Name);
// Precondition: on a target with multiversioning support (supportsMultiVersioning), Name is
// one that target already accepted (isValidCPUName or validateCpuSupports) -- the x86
// implementation looks Name up in a priority table and reads past its end otherwise.
unsigned clang_TargetInfo_multiVersionSortPriority(CXTargetInfo_ TI, const char *Name);
unsigned clang_TargetInfo_multiVersionFeatureCost(CXTargetInfo_ TI);
// Validates the argument of __builtin_cpu_is; total for any string.
bool clang_TargetInfo_validateCpuIs(CXTargetInfo_ TI, const char *Name);
// Validates a cpu_specific/cpu_dispatch CPU option; checked through features, so the
// accepted list differs from validateCpuIs'.
bool clang_TargetInfo_validateCPUSpecificCPUDispatch(CXTargetInfo_ TI, const char *Name);
// Precondition: clang_TargetInfo_validateCPUSpecificCPUDispatch(TI, Name). TargetInfo's
// own implementation is an llvm_unreachable, so a target that does not implement
// cpu_specific multiversioning aborts instead of returning.
char clang_TargetInfo_CPUSpecificManglingCharacter(CXTargetInfo_ TI, const char *Name);
// getCPUSpecificTuneName -- not wrapped. No target in clang 18 overrides it, so the base
// llvm_unreachable is the only implementation and every call aborts the process.

// The features making up a cpu_specific/cpu_dispatch CPU option. The caller owns the
// returned set (freed via libclang's clang_disposeStringSet); the StringRefs it is built
// from point into static target-description literals and are copied out (MARSHALLING.md
// §6, count+fill realised as this file's CXStringSet form).
// Precondition: clang_TargetInfo_validateCPUSpecificCPUDispatch(TI, Name). TargetInfo's own
// implementation is an llvm_unreachable, so a target that does not implement cpu_specific
// multiversioning aborts instead of returning. An empty set is a valid answer: the gate
// also accepts the CPU_SPECIFIC_ALIAS names, which carry no features of their own.
CXStringSet *clang_TargetInfo_getCPUSpecificCPUDispatchFeatures(CXTargetInfo_ TI,
                                                                const char *Name);
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
// Map an address-space field taken from a builtin description string to the language
// address space it names; the base implementation is the identity mapping through
// getLangASFromTargetAS.
CXLangAS clang_TargetInfo_getOpenCLBuiltinAddressSpace(CXTargetInfo_ TI, unsigned AS);
CXLangAS clang_TargetInfo_getCUDABuiltinAddressSpace(CXTargetInfo_ TI, unsigned AS);
// Writes the address space usable opportunistically for constant global memory into *AS
// and returns true; returns false, leaving *AS untouched, when the target names none.
bool clang_TargetInfo_getConstantAddressSpace(CXTargetInfo_ TI, CXLangAS *AS);
CXString clang_TargetInfo_getPlatformName(CXTargetInfo_ TI);
// The deployment version used by the availability attribute, in VersionTuple's printed
// form ("0" when the target names no minimum version).
CXString clang_TargetInfo_getPlatformMinVersion(CXTargetInfo_ TI);
bool clang_TargetInfo_isBigEndian(CXTargetInfo_ TI);
bool clang_TargetInfo_isLittleEndian(CXTargetInfo_ TI);
bool clang_TargetInfo_supportsExtendIntArgs(CXTargetInfo_ TI);
bool clang_TargetInfo_checkArithmeticFenceSupported(CXTargetInfo_ TI);
CXCallingConv_ clang_TargetInfo_getDefaultCallingConv(CXTargetInfo_ TI);

// Mirrors TargetInfo::CallingConvCheckResult.
typedef enum CXTargetInfo_CallingConvCheckResult {
  CXTargetInfo_CCCR_OK = 0,
  CXTargetInfo_CCCR_Warning,
  CXTargetInfo_CCCR_Ignore,
  CXTargetInfo_CCCR_Error
} CXTargetInfo_CallingConvCheckResult;

CXTargetInfo_CallingConvCheckResult
clang_TargetInfo_checkCallingConvention(CXTargetInfo_ TI, CXCallingConv_ CC);

// Mirrors TargetInfo::CallingConvKind.
typedef enum CXTargetInfo_CallingConvKind {
  CXTargetInfo_CCK_Default = 0,
  CXTargetInfo_CCK_ClangABI4OrPS4,
  CXTargetInfo_CCK_MicrosoftWin64
} CXTargetInfo_CallingConvKind;

CXTargetInfo_CallingConvKind clang_TargetInfo_getCallingConvKind(CXTargetInfo_ TI,
                                                                 bool ClangABICompat4);

bool clang_TargetInfo_areDefaultedSMFStillPOD(CXTargetInfo_ TI, CXLangOptions LO);
bool clang_TargetInfo_hasSjLjLowering(CXTargetInfo_ TI);
// Whether -fcf-protection=branch / =return is supported on this target. Both report through
// Diags -- a false answer *emits* err_opt_not_valid_on_target, so the engine's error count
// moves -- which is why they take a live engine rather than answering silently.
bool clang_TargetInfo_checkCFProtectionBranchSupported(CXTargetInfo_ TI,
                                                       CXDiagnosticsEngine Diags);
bool clang_TargetInfo_checkCFProtectionReturnSupported(CXTargetInfo_ TI,
                                                       CXDiagnosticsEngine Diags);
bool clang_TargetInfo_allowsLargerPreferedTypeAlignment(CXTargetInfo_ TI);
bool clang_TargetInfo_defaultsToAIXPowerAlignment(CXTargetInfo_ TI);
CXLangAS clang_TargetInfo_getOpenCLTypeAddrSpace(CXTargetInfo_ TI, CXOpenCLTypeKind TK);
unsigned clang_TargetInfo_getVtblPtrAddressSpace(CXTargetInfo_ TI);
// Writes the DWARF address space AddressSpace must be converted to into *Out and returns
// true; returns false, leaving *Out untouched, when the target needs no conversion.
bool clang_TargetInfo_getDWARFAddressSpace(CXTargetInfo_ TI, unsigned AddressSpace,
                                           unsigned *Out);
// The SDK version recorded in the target options, in VersionTuple's printed form ("0"
// when none was specified). Same TargetOpts precondition as
// clang_TargetInfo_getTargetOpts.
CXString clang_TargetInfo_getSDKVersion(CXTargetInfo_ TI);
// Reports through Diags when the fully-initialized target is invalid.
bool clang_TargetInfo_validateTarget(CXTargetInfo_ TI, CXDiagnosticsEngine Diags);
bool clang_TargetInfo_allowDebugInfoForExternalRef(CXTargetInfo_ TI);
// The Darwin target-variant triple string, borrowed from the llvm::Triple the target
// owns; NULL when the target names no variant.
const char *clang_TargetInfo_getDarwinTargetVariantTriple(CXTargetInfo_ TI);
bool clang_TargetInfo_hasHIPImageSupport(CXTargetInfo_ TI);

// --- The fixed-point types (`_Accum`, `_Fract` and their short/long/unsigned spellings)
// ---
//
// Width is the whole type's bit width, Scale the number of fractional bits, IBits the
// number of integral bits, and Align the ABI alignment. Every one of these is target-set:
// assert their shape, never a particular value. Signed types carry a sign bit, so their
// IBits accessor exists separately from the unsigned one; the unsigned types have no
// separate width or alignment because they match their signed counterparts.
unsigned clang_TargetInfo_getAccumAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getAccumWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFractAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFractScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getFractWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongAccumAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongAccumWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongFractAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongFractScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getLongFractWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortAccumAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortAccumWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortFractAlign(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortFractScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getShortFractWidth(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedFractScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedLongAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedLongAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedLongFractScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedShortAccumIBits(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedShortAccumScale(CXTargetInfo_ TI);
unsigned clang_TargetInfo_getUnsignedShortFractScale(CXTargetInfo_ TI);

// Whether the unsigned fixed-point types spend a bit on padding to keep the same scale as
// their signed counterparts.
bool clang_TargetInfo_doUnsignedFixedPointTypesHavePadding(CXTargetInfo_ TI);

// The floating-point evaluation method the target's default excess precision implies.
CXFPEvalMethodKind clang_TargetInfo_getFPEvalMethod(CXTargetInfo_ TI);

// The real floating-point type of the given bit width, or CXFloatModeKind_NoFloat when the
// target has none. ExplicitType selects between the `float`/`__bf16` spellings at 16 bits.
CXFloatModeKind clang_TargetInfo_getRealTypeByWidth(CXTargetInfo_ TI, unsigned BitWidth,
                                                    CXFloatModeKind ExplicitType);

LLVM_CLANG_C_EXTERN_C_END

#endif