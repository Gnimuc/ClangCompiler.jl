using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_parser, create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

# Pinned so every TargetInfo answer below is a fact about this target rather than about the
# runner. Without it, each predicate could only be asserted `isa Bool`.
const PIN = "x86_64-linux-gnu"

@testset "Basic | TargetInfo target queries" begin
    I = CC.create_parser(String[]; triple=PIN)
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # identity strings
    @test !isempty(CC.getTriple(ti))
    @test !isempty(CC.getDataLayoutString(ti))
    # the SysV x86_64 target names no ABI variant, so this is empty -- a value that
    # still fails for a shim handing back another member's string
    @test CC.getABI(ti) == ""
    @test !isempty(CC.getPlatformName(ti))
    @test CC.getUserLabelPrefix(ti) in ("", "_")
    @test !isempty(CC.getMCountName(ti))
    @test CC.getClobbers(ti) isa String

    # endianness: exactly one of the two
    @test CC.isBigEndian(ti) != CC.isLittleEndian(ti)

    # builtin type widths/alignments (bits)
    @test CC.getCharWidth(ti) == 8
    @test CC.getCharAlign(ti) == 8
    @test CC.getBoolWidth(ti) == 8
    @test CC.getShortWidth(ti) == 16
    @test CC.getShortAlign(ti) == 16
    @test CC.getIntWidth(ti) == 32
    @test CC.getIntAlign(ti) == 32
    @test CC.getLongWidth(ti) in (32, 64)
    @test CC.getLongLongWidth(ti) == 64
    @test CC.getInt128Align(ti) > 0
    @test CC.getHalfWidth(ti) == 16
    @test CC.getFloatWidth(ti) == 32
    @test CC.getDoubleWidth(ti) == 64
    @test CC.getDoubleAlign(ti) in (32, 64)
    @test CC.getLongDoubleWidth(ti) >= 64
    @test CC.getLongDoubleAlign(ti) >= 32
    @test CC.getFloat128Width(ti) == 128
    @test CC.getFloat128Align(ti) > 0
    @test CC.getBFloat16Width(ti) in (0, 16)
    @test CC.getWCharWidth(ti) in (16, 32)
    @test CC.getWCharAlign(ti) in (16, 32)
    @test CC.getChar16Width(ti) == 16
    @test CC.getChar16Align(ti) >= 16
    @test CC.getChar32Width(ti) == 32
    @test CC.getChar32Align(ti) >= 32
    @test CC.getHalfAlign(ti) > 0
    @test CC.getFloatAlign(ti) == 32
    @test CC.getBFloat16Align(ti) in (0, 16)
    @test CC.getBoolAlign(ti) == 8

    # pointers and address spaces
    w = CC.getPointerWidth(ti)
    @test w in (32, 64)
    @test CC.getPointerAlign(ti) == w
    @test CC.getMaxPointerWidth(ti) >= w
    @test CC.getTargetAddressSpace(ti) == 0

    # IntType surface
    st = CC.getSizeType(ti)
    @test st isa CC.CXTargetInfo_IntType
    @test !CC.isTypeSigned(st)
    @test CC.getTypeWidth(ti, st) == w
    @test CC.isTypeSigned(CC.getPtrDiffType(ti))
    @test CC.getTypeWidth(ti, CC.getPtrDiffType(ti)) == w
    @test CC.getTypeWidth(ti, CC.getIntPtrType(ti)) == w
    @test CC.isTypeSigned(CC.getIntMaxType(ti))
    @test CC.getTypeWidth(ti, CC.getInt64Type(ti)) == 64
    @test CC.getWCharType(ti) isa CC.CXTargetInfo_IntType
    @test CC.getCorrespondingUnsignedType(CC.CXTargetInfo_SignedInt) == CC.CXTargetInfo_UnsignedInt
    @test CC.getTypeName(CC.CXTargetInfo_SignedInt) == "int"
    @test CC.getTypeWidth(ti, CC.getIntTypeByWidth(ti, 32, true)) == 32
    @test CC.getTypeAlign(ti, CC.CXTargetInfo_SignedChar) == 8

    # presence/support predicates — pinned for x86_64-linux-gnu, including both polarities
    # so a predicate stuck at one answer fails
    @test CC.hasInt128Type(ti) == true
    @test CC.hasBitIntType(ti) == true
    @test CC.hasLongDoubleType(ti) == true
    @test CC.hasFPReturn(ti) == true
    @test CC.isTLSSupported(ti) == true
    @test CC.isVLASupported(ti) == true
    @test CC.hasLegalHalfType(ti) == false
    @test CC.hasFloat16Type(ti) == true
    @test CC.hasBFloat16Type(ti) == true
    @test CC.hasFullBFloat16Type(ti) == false
    @test CC.hasFloat128Type(ti) == true
    @test CC.hasIbm128Type(ti) == false
    @test CC.hasStrictFP(ti) == true
    @test CC.hasAArch64SVETypes(ti) == false
    @test CC.hasRISCVVTypes(ti) == false
    @test CC.supportsMultiVersioning(ti) == true
    @test CC.supportsIFunc(ti) == true

    # layout scalars
    @test CC.getSuitableAlign(ti) >= 64
    @test CC.getNewAlign(ti) >= 64
    @test CC.getDefaultAlignForAttributeAligned(ti) >= 64
    @test CC.getMaxAtomicPromoteWidth(ti) >= CC.getMaxAtomicInlineWidth(ti)
    @test CC.hasBuiltinAtomic(ti, 32, 32)
    @test CC.getMaxVectorAlign(ti) isa Cuint
    @test CC.getExnObjectAlignment(ti) > 0
    @test CC.getMaxBitIntWidth(ti) >= 64

    # feature/CPU validity
    @test CC.hasFeature(ti, "definitely-not-a-feature") == false
    @test CC.isValidCPUName(ti, "this-cpu-does-not-exist") == false
    @test CC.isValidTuneCPUName(ti, "this-cpu-does-not-exist") == false
    @test CC.isValidFeatureName(ti, "not-a-real-feature-name") == false
    cpus = CC.fillValidCPUList(ti)
    @test cpus isa Vector{String}
    @test !isempty(cpus)
    @test CC.isValidCPUName(ti, first(cpus))

    # optionals (bool + out-param)
    c = CC.getCPUCacheLineSize(ti)
    @test c === nothing || c isa Cuint
    lo = CC.getLangOpts(ci)
    r = CC.getVScaleRange(ti, lo)
    @test r === nothing || (r isa Tuple{Cuint,Cuint} && r[1] <= r[2])

    # ABI kinds
    @test CC.getBuiltinVaListKind(ti) isa CC.CXTargetInfo_BuiltinVaListKind
    k = CC.getCXXABI(ti)
    @test k isa CC.CXTargetCXXABI_Kind
    @test Sys.iswindows() || k != CC.CXTargetCXXABI_Microsoft

    CC.dispose(I)
end

@testset "Basic | TargetInfo integer-type and bitfield tail" begin
    I = CC.create_parser(String[]; triple=PIN)
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # signed/unsigned counterparts of the canonical typedefs
    sst = CC.getSignedSizeType(ti)
    @test sst isa CC.CXTargetInfo_IntType
    @test CC.isTypeSigned(sst)
    @test CC.getTypeWidth(ti, sst) == CC.getTypeWidth(ti, CC.getSizeType(ti))
    @test CC.getCorrespondingUnsignedType(sst) == CC.getSizeType(ti)

    uim = CC.getUIntMaxType(ti)
    @test !CC.isTypeSigned(uim)
    @test CC.getTypeWidth(ti, uim) == CC.getIntMaxTWidth(ti)
    @test CC.getIntMaxTWidth(ti) == CC.getTypeWidth(ti, CC.getIntMaxType(ti))

    upd = CC.getUnsignedPtrDiffType(ti)
    @test !CC.isTypeSigned(upd)
    @test CC.getTypeWidth(ti, upd) == CC.getTypeWidth(ti, CC.getPtrDiffType(ti))

    uip = CC.getUIntPtrType(ti)
    @test !CC.isTypeSigned(uip)
    @test CC.getTypeWidth(ti, uip) == CC.getTypeWidth(ti, CC.getIntPtrType(ti))

    u64 = CC.getUInt64Type(ti)
    @test !CC.isTypeSigned(u64)
    @test CC.getTypeWidth(ti, u64) == 64

    i16 = CC.getInt16Type(ti)
    @test CC.isTypeSigned(i16)
    @test CC.getTypeWidth(ti, i16) == 16
    u16 = CC.getUInt16Type(ti)
    @test !CC.isTypeSigned(u16)
    @test CC.getTypeWidth(ti, u16) == 16
    @test CC.getCorrespondingUnsignedType(i16) == u16

    # remaining IntType slots
    for f in (CC.getWIntType, CC.getChar16Type, CC.getChar32Type, CC.getSigAtomicType, CC.getProcessIDType)
        @test f(ti) isa CC.CXTargetInfo_IntType
    end
    @test CC.getTypeWidth(ti, CC.getChar16Type(ti)) == 16
    @test CC.getTypeWidth(ti, CC.getChar32Type(ti)) == 32

    # smallest integer type at least as wide as the request
    @test CC.getLeastIntTypeByWidth(ti, 4096, true) isa CC.CXTargetInfo_IntType
    l32 = CC.getLeastIntTypeByWidth(ti, 32, true)
    @test CC.isTypeSigned(l32)
    @test CC.getTypeWidth(ti, l32) >= 32
    @test !CC.isTypeSigned(CC.getLeastIntTypeByWidth(ti, 32, false))
    @test CC.getTypeWidth(ti, CC.getLeastIntTypeByWidth(ti, 8, true)) >= 8

    # spellings (the documented example is target-independent)
    @test CC.getTypeConstantSuffix(ti, CC.CXTargetInfo_SignedLong) in ("L", "LL")
    @test CC.getTypeConstantSuffix(ti, CC.CXTargetInfo_UnsignedInt) == "U"
    @test CC.getTypeFormatModifier(CC.CXTargetInfo_SignedLong) == "l"
    @test CC.getTypeFormatModifier(CC.CXTargetInfo_SignedShort) == "h"
    @test_throws AssertionError CC.getTypeFormatModifier(CC.CXTargetInfo_NoInt)

    # register width and bitfield layout scalars
    @test CC.getRegisterWidth(ti) in (32, 64)
    @test CC.useBitFieldTypeAlignment(ti) == true
    @test CC.getZeroLengthBitfieldBoundary(ti) isa Cuint
    @test CC.getMaxAlignedAttribute(ti) isa Cuint

    CC.dispose(I)
end

@testset "Basic | TargetInfo ABI knobs and GCC register names" begin
    I = CC.create_parser(String[]; triple=PIN)
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # null pointer value, minimum global alignment, large-array thresholds
    @test CC.getNullPointerValue(ti) isa UInt64
    @test CC.getNullPointerValue(ti, CC.CXLangAS_Default) == CC.getNullPointerValue(ti)
    @test CC.getMinGlobalAlign(ti, UInt64(64)) isa Cuint
    @test CC.getLargeArrayMinWidth(ti) isa Cuint
    @test CC.getLargeArrayAlign(ti) isa Cuint
    @test CC.getUnwindWordWidth(ti) in (32, 64)

    # __ibm128: the width is fixed; x86_64 does not have the type, so the mangling
    # accessor is gated rather than answered
    @test CC.getIbm128Width(ti) == 128
    @test CC.getIbm128Align(ti) isa Cuint
    @test CC.hasIbm128Type(ti) == false
    @test_throws AssertionError CC.getIbm128Mangling(ti)

    # Itanium mangling codes of the other extended floating-point types
    @test !isempty(CC.getLongDoubleMangling(ti))
    @test !isempty(CC.getFloat128Mangling(ti))
    @test !isempty(CC.getBFloat16Mangling(ti))

    # bitfield layout / address-space mangling / builtin predicates
    @test CC.useZeroLengthBitfieldAlignment(ti) == false
    @test CC.useLeadingZeroLengthBitfield(ti) == true
    @test CC.useExplicitBitFieldAlignment(ti) == true
    @test CC.useAddressSpaceMapMangling(ti) == false
    @test CC.isCLZForZeroUndef(ti) == true
    @test CC.hasBuiltinMSVaList(ti) == true

    # inline-asm clobbers and GCC register names
    @test CC.isValidClobber(ti, "memory")
    @test CC.isValidClobber(ti, "cc")
    @test !CC.isValidGCCRegisterName(ti, "not_a_register")
    @test !CC.isValidClobber(ti, "not_a_register")
    @test_throws AssertionError CC.getNormalizedGCCRegisterName(ti, "not_a_register")

    # the pinned triple is x86_64, so `rax` is a real register and the unnamed form of it
    # is `ax` — a target that ignored the `SkipUnnamed` flag would still return `rax`
    @test CC.isValidGCCRegisterName(ti, "rax")
    @test CC.isValidClobber(ti, "rax")
    @test !isempty(CC.getNormalizedGCCRegisterName(ti, "rax"))
    @test CC.getNormalizedGCCRegisterName(ti, "rax", true) == "ax"

    CC.dispose(I)
end

@testset "Basic | TargetInfo target policy queries" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)

    # the options the target was configured from: borrowed, never disposed here
    opts = CC.getTargetOpts(ti)
    @test opts isa CC.TargetOptions
    @test opts.ptr != C_NULL

    # ObjC BOOL / mac68k pragma / __fp16 conversion intrinsics
    @test CC.useSignedCharForObjCBool(ti) == true
    @test CC.hasAlignMac68kSupport(ti) == false
    @test CC.useFP16ConversionIntrinsics(ti) == false

    # ARM CDE coprocessor mask is an 8-bit bitfield, zero away from ARM
    @test CC.getARMCDECoprocMask(ti) <= 0xff

    # stack-pointer register names and single-register constraint extraction
    @test !CC.isSPRegName(ti, "not_a_register")
    # X86 names `esp`/`rsp` as the stack pointer and nothing else in this list
    @test !CC.isSPRegName(ti, "sp")
    @test CC.isSPRegName(ti, "esp")
    @test CC.isSPRegName(ti, "rsp")
    @test !CC.isSPRegName(ti, "r1")
    @test !CC.isSPRegName(ti, "x31")
    @test CC.getConstraintRegister(ti, "a", "") == "ax"
    @test CC.getConstraintRegister(ti, "r", "") == ""
    @test isempty(CC.getConstraintRegister(ti, "", ""))

    # NaN encoding, ELF protected visibility, MSVC dllimport comdat semantics
    @test CC.isNan2008(ti) == true
    @test CC.hasProtectedVisibility(ti) == true
    @test CC.shouldDLLImportComdatSymbols(ti) == false

    # register-passed arguments (clang itself asserts < 7) and the TLS alignment cap
    @test CC.getRegParmMax(ti) isa Cuint
    @test CC.getRegParmMax(ti) < 7
    @test CC.getMaxTLSAlign(ti) isa Cuint

    # SEH __try, asm variants, EH data registers, static-init section
    @test CC.isSEHTrySupported(ti) == false
    @test CC.hasNoAsmVariants(ti) == false
    @test CC.getEHDataRegisterNumber(ti, 0) isa Cint
    @test CC.getEHDataRegisterNumber(ti, 0) >= -1
    @test CC.getEHDataRegisterNumber(ti, 1) >= -1
    @test CC.getEHDataRegisterNumber(ti, 99) == -1
    sect = CC.getStaticInitSectionSpecifier(ti)
    @test sect === nothing || sect isa String

    # setjmp/longjmp lowering, over-alignment policy, vtable pointer address space
    @test CC.hasSjLjLowering(ti) == true
    @test CC.allowsLargerPreferedTypeAlignment(ti) == true
    @test CC.defaultsToAIXPowerAlignment(ti) == false
    @test CC.getVtblPtrAddressSpace(ti) isa Cuint

    dispose(I)
end

@testset "Basic | TargetInfo::ConstraintInfo" begin
    I = CC.create_parser(String[]; triple=PIN)
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # a fresh ConstraintInfo carries its two strings and no flags at all
    out = CC.ConstraintInfo("=r", "dst")
    @test CC.getConstraintStr(out) == "=r"
    @test CC.getName(out) == "dst"
    @test CC.isReadWrite(out) == false
    @test CC.earlyClobber(out) == false
    @test CC.allowsRegister(out) == false
    @test CC.allowsMemory(out) == false
    @test CC.hasMatchingInput(out) == false
    @test CC.hasTiedOperand(out) == false
    @test CC.requiresImmediateConstant(out) == false

    # "=r" is a valid output constraint on every target: '=' and 'r' are handled by
    # TargetInfo::validateOutputConstraint itself, not by the target-specific
    # validateAsmConstraint hook, so the flags it sets in place are the same everywhere.
    @test CC.validateOutputConstraint(ti, out) == true
    @test CC.allowsRegister(out) == true
    @test CC.allowsMemory(out) == false
    @test CC.isReadWrite(out) == false

    # "=m" is memory-only; an unnamed operand round-trips as the empty name
    mem = CC.ConstraintInfo("=m", "")
    @test CC.validateOutputConstraint(ti, mem)
    @test CC.allowsMemory(mem)
    @test CC.allowsRegister(mem) == false
    @test isempty(CC.getName(mem))
    @test CC.getConstraintStr(mem) == "=m"

    # "+&rm" is read-write, early clobber, register and memory all at once
    rw = CC.ConstraintInfo("+&rm", "")
    @test CC.validateOutputConstraint(ti, rw)
    @test CC.isReadWrite(rw)
    @test CC.earlyClobber(rw)
    @test CC.allowsRegister(rw)
    @test CC.allowsMemory(rw)

    # an output constraint must start with '=' or '+'
    bad = CC.ConstraintInfo("r", "")
    @test CC.validateOutputConstraint(ti, bad) == false
    @test CC.allowsRegister(bad) == false

    # Input constraints, validated against the outputs they may tie to. "r" is a plain
    # register input and ties to nothing; "0" is the digit form that ties to output 0, and
    # the tie is recorded on the OUTPUT -- which is the whole reason the outputs cross as an
    # in/out array rather than by value.
    out0 = CC.ConstraintInfo("=r", "")
    @test CC.validateOutputConstraint(ti, out0)
    @test CC.hasMatchingInput(out0) == false

    plain_in = CC.ConstraintInfo("r", "")
    @test CC.validateInputConstraint(ti, [out0], plain_in)
    @test CC.allowsRegister(plain_in)
    @test CC.hasMatchingInput(out0) == false      # nothing tied to it yet

    tied_in = CC.ConstraintInfo("0", "")
    @test CC.validateInputConstraint(ti, [out0], tied_in)
    @test CC.getTiedOperand(tied_in) == 0
    @test CC.hasMatchingInput(out0) == true       # the call mutated the output

    # a tie to an operand that does not exist is rejected; with no outputs at all, so is "0"
    @test CC.validateInputConstraint(ti, CC.ConstraintInfo[], CC.ConstraintInfo("0", "")) == false

    # setCPU/setABI/setFPMath answer for the concrete target, and x86_64 overrides setCPU:
    # it takes a real CPU name and refuses a nonsense one. Both answers come from clang.
    @test CC.setCPU(ti, "x86-64") == true
    @test CC.setCPU(ti, "not-a-real-cpu") == false
    @test CC.setFPMath(ti, "not-a-real-fpmath-unit") == false

    # A `[symbolic]` operand name resolves to the operand carrying that name, and to nothing
    # when no operand has it. `consumed` lands ON the closing bracket rather than past it —
    # 4 for "[sym]" — which is clang's own convention and the reason the count crosses
    # instead of the moving pointer clang advances.
    named = CC.ConstraintInfo("=r", "sym")
    @test CC.validateOutputConstraint(ti, named)
    got = CC.resolveSymbolicName(ti, "[sym]", [named])
    @test got !== nothing
    @test got.index == 0
    @test got.consumed == 4
    @test CC.resolveSymbolicName(ti, "[absent]", [named]) === nothing
    @test CC.resolveSymbolicName(ti, "[sym]", CC.ConstraintInfo[]) === nothing

    # validateConstraintModifier is a target decision, and this fixture's pinned x86_64 is a
    # target that declines to override it — so the base implementation answers, accepting
    # every modifier and suggesting nothing. That is what makes it assertable at all: the
    # same code on an AArch64 target rejects 'P' on a 32-bit "r" operand and suggests "w",
    # so without the pinned triple this would read differently on an Apple-silicon runner
    # than on the x86 ones.
    for (constraint, modifier, size) in (("r", 'P', 32), ("r", 'q', 8), ("m", 'P', 32))
        got = CC.validateConstraintModifier(ti, constraint, modifier, size)
        @test got.ok == true
        @test isempty(got.suggested)
    end
    CC.dispose(named)
    for c in (out0, plain_in, tied_in)
        CC.dispose(c)
    end

    # the setters reach the same flag bits without going through a target
    flags = CC.ConstraintInfo("=r", "")
    CC.setIsReadWrite(flags)
    CC.setEarlyClobber(flags)
    CC.setAllowsMemory(flags)
    CC.setAllowsRegister(flags)
    CC.setHasMatchingInput(flags)
    @test CC.isReadWrite(flags)
    @test CC.earlyClobber(flags)
    @test CC.allowsMemory(flags)
    @test CC.allowsRegister(flags)
    @test CC.hasMatchingInput(flags)
    @test CC.requiresImmediateConstant(flags) == false
    CC.setRequiresImmediate(flags, -8, 7)
    @test CC.requiresImmediateConstant(flags)

    # tying an input operand to output 0 copies the output's flags and marks the output
    input = CC.ConstraintInfo("0", "")
    @test CC.hasTiedOperand(input) == false
    CC.setTiedOperand(input, 0, out)
    @test CC.hasTiedOperand(input)
    @test CC.getTiedOperand(input) isa Cuint
    @test CC.getTiedOperand(input) == 0
    @test CC.hasMatchingInput(out)
    @test CC.allowsRegister(input) == CC.allowsRegister(out)
    # ... but the tied input keeps its own constraint string and name
    @test CC.getConstraintStr(input) == "0"
    @test isempty(CC.getName(input))

    for c in (out, mem, rw, bad, flags, input)
        dispose(c)
    end
    dispose(I)
end

@testset "Basic | TargetInfo feature, tuning and multiversioning queries" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)

    # Plain target predicates: the host triple decides every value, so assert only the shape.
    @test CC.allowHalfArgsAndReturns(ti) == false
    @test CC.supportSourceEvalMethod(ti) == true
    @test CC.useObjCFP2RetForComplexLongDouble(ti) == true
    @test CC.allowAMDGPUUnsafeFPAtomics(ti) == false
    @test CC.hasPS4DLLImportExport(ti) == false
    @test CC.supportsTargetAttributeTune(ti) == true
    @test CC.supportsExtendIntArgs(ti) == true
    @test CC.checkArithmeticFenceSupported(ti) == true
    @test CC.allowDebugInfoForExternalRef(ti) == false
    @test CC.getMaxOpenCLWorkGroupSize(ti) == 0x00000400

    # Feature-name queries are total for any string.
    @test CC.doesFeatureAffectCodeGen(ti, "sse2") == true
    @test CC.isReadOnlyFeature(ti, "sse2") == false
    @test CC.isBranchProtectionSupportedArch(ti, "x86-64") == false

    # __builtin_cpu_supports / __builtin_cpu_is / cpu_dispatch argument validation: these
    # are the functions Sema calls on raw user strings, so they are total.
    @test CC.validateCpuSupports(ti, "sse2") == true
    @test CC.validateCpuIs(ti, "atom") == true
    @test CC.validateCPUSpecificCPUDispatch(ti, "generic") == true
    @test CC.validateCpuSupports(ti, "definitely-not-a-feature") == false
    @test CC.validateCpuIs(ti, "definitely-not-a-cpu") == false

    dispose(I)
end

@testset "Basic | TargetInfo address spaces, calling conventions, target identity" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)
    lo = CC.getLangOpts(ci)
    diag = CC.getDiagnostics(ci)

    # Builtin-description address-space mapping. The base implementation is the identity
    # map through getLangASFromTargetAS, so only the carrier type is host-independent.
    @test CC.getOpenCLBuiltinAddressSpace(ti, 0) isa CC.CXLangAS
    @test CC.getCUDABuiltinAddressSpace(ti, 0) isa CC.CXLangAS
    @test CC.getOpenCLTypeAddrSpace(ti, CC.CXOpenCLTypeKind_OCLTK_Default) isa CC.CXLangAS

    # optional<LangAS> / optional<unsigned>: `nothing` when the target names none.
    cas = CC.getConstantAddressSpace(ti)
    @test cas === nothing || cas isa CC.CXLangAS
    # x86_64 does not remap DWARF address spaces
    @test CC.getDWARFAddressSpace(ti, 0) === nothing

    # Calling conventions: whichever default the target picks, its own checker has to
    # accept it -- that is the invariant Sema relies on when it substitutes the default.
    cc = CC.getDefaultCallingConv(ti)
    @test cc isa CC.CXCallingConv_
    @test CC.checkCallingConvention(ti, cc) == CC.CXTargetInfo_CCCR_OK
    @test CC.checkCallingConvention(ti, CC.CXCallingConv_CC_C) == CC.CXTargetInfo_CCCR_OK
    @test CC.getCallingConvKind(ti, false) isa CC.CXTargetInfo_CallingConvKind
    @test CC.getCallingConvKind(ti, true) isa CC.CXTargetInfo_CallingConvKind
    @test CC.areDefaultedSMFStillPOD(ti, lo) == true

    # VersionTuples cross as their printed form; the digits are the target's business, but
    # VersionTuple always prints at least a major number.
    @test CC.getPlatformMinVersion(ti) == "0"
    @test !isempty(CC.getPlatformMinVersion(ti))
    @test CC.getSDKVersion(ti) == "0"

    # Target identity. Both the target ID and the Darwin variant triple are absent on the
    # ordinary host targets CI runs on, so only the shape is asserted.
    @test CC.getTargetID(ti) == ""
    variant = CC.getDarwinTargetVariantTriple(ti)
    @test variant === nothing || variant isa String
    @test CC.hasHIPImageSupport(ti) == true
    @test CC.validateTarget(ti, diag) == true

    # Tune-CPU names: the list is target-decided (and empty on targets that model none),
    # but no entry is ever an empty string.
    tune = CC.fillValidTuneCPUList(ti)
    @test tune isa Vector{String}
    @test all(!isempty, tune)

    # cpu_specific mangling is an llvm_unreachable on every target that does not implement
    # it, so the wrapper asserts the same gate Sema checks first. Only X86 implements the
    # pair, so the accepting side is driven from an x86_64 target description built here
    # rather than from the host target, which is X86 only on some of the CI runners.
    @test_throws AssertionError CC.CPUSpecificManglingCharacter(ti, "definitely-not-a-cpu")
    x86_ci = CC.CompilerInstance()
    CC.createDiagnostics(x86_ci)
    x86_opts = CC.TargetOptions()
    CC.setTriple(x86_opts, "x86_64-unknown-linux-gnu")
    x86 = CC.TargetInfo(x86_opts, CC.getDiagnostics(x86_ci))  # absorbs x86_opts
    CC.setTarget(x86_ci, x86)  # the instance takes a reference; `x86` stays ours
    @test !CC.validateCPUSpecificCPUDispatch(x86, "definitely-not-a-cpu")
    # each cpu_specific variant mangles with a different character, which is the whole
    # reason the name is an argument
    @test CC.validateCPUSpecificCPUDispatch(x86, "generic")
    @test CC.CPUSpecificManglingCharacter(x86, "generic") == Int8('A')
    @test CC.validateCPUSpecificCPUDispatch(x86, "pentium_4")
    @test CC.CPUSpecificManglingCharacter(x86, "pentium_4") == Int8('J')
    @test CC.validateCPUSpecificCPUDispatch(x86, "core_2_duo_ssse3")
    @test CC.CPUSpecificManglingCharacter(x86, "core_2_duo_ssse3") == Int8('M')
    dispose(x86_ci)
    dispose(x86)

    dispose(I)
end

@testset "TargetInfo | fixed-point types" begin
    I = CC.create_parser(String[]; triple=PIN)
    ti = CC.getTarget(CC.get_instance(I))

    # pinned for x86_64-linux-gnu: short/plain/long _Accum and _Fract widths (bits)
    accum = [CC.getShortAccumWidth(ti), CC.getAccumWidth(ti), CC.getLongAccumWidth(ti)]
    fract = [CC.getShortFractWidth(ti), CC.getFractWidth(ti), CC.getLongFractWidth(ti)]
    @test accum == [16, 32, 64]
    @test fract == [8, 16, 32]
    # widths are non-decreasing from short to long
    @test issorted(accum)
    @test issorted(fract)

    aligns = [CC.getShortAccumAlign(ti), CC.getAccumAlign(ti), CC.getLongAccumAlign(ti), CC.getShortFractAlign(ti),
              CC.getFractAlign(ti), CC.getLongFractAlign(ti)]
    @test aligns == [16, 32, 64, 8, 16, 32]

    # A signed _Accum is a sign bit, its integral bits and its fractional bits, exactly.
    for (w, ibits, scale) in [(CC.getShortAccumWidth(ti), CC.getShortAccumIBits(ti), CC.getShortAccumScale(ti)),
                              (CC.getAccumWidth(ti), CC.getAccumIBits(ti), CC.getAccumScale(ti)),
                              (CC.getLongAccumWidth(ti), CC.getLongAccumIBits(ti), CC.getLongAccumScale(ti))]
        @test ibits > 0
        @test scale > 0
        @test 1 + ibits + scale == w
    end

    # A signed _Fract is a sign bit and its fractional bits: no integral bits at all.
    for (w, scale) in
        [(CC.getShortFractWidth(ti), CC.getShortFractScale(ti)), (CC.getFractWidth(ti), CC.getFractScale(ti)),
         (CC.getLongFractWidth(ti), CC.getLongFractScale(ti))]
        @test scale > 0
        @test 1 + scale == w
    end

    # The unsigned spellings reuse their signed counterpart's width, so they only expose
    # scale and integral bits. Whether they gain the sign bit back or pad it away is what
    # doUnsignedFixedPointTypesHavePadding reports.
    padded = CC.doUnsignedFixedPointTypesHavePadding(ti)
    @test padded == false
    for (w, uibits, uscale) in
        [(CC.getShortAccumWidth(ti), CC.getUnsignedShortAccumIBits(ti), CC.getUnsignedShortAccumScale(ti)),
         (CC.getAccumWidth(ti), CC.getUnsignedAccumIBits(ti), CC.getUnsignedAccumScale(ti)),
         (CC.getLongAccumWidth(ti), CC.getUnsignedLongAccumIBits(ti), CC.getUnsignedLongAccumScale(ti))]
        @test uibits > 0
        @test uscale > 0
        @test uibits + uscale == (padded ? w - 1 : w)
    end
    for (w, uscale) in [(CC.getShortFractWidth(ti), CC.getUnsignedShortFractScale(ti)),
                        (CC.getFractWidth(ti), CC.getUnsignedFractScale(ti)),
                        (CC.getLongFractWidth(ti), CC.getUnsignedLongFractScale(ti))]
        @test uscale == (padded ? w - 1 : w)
    end

    # --- Floating-point evaluation and the real type of a given width ---
    @test CC.getFPEvalMethod(ti) isa CC.CXFPEvalMethodKind
    # every target this package runs on has a 32-bit and a 64-bit real type
    @test CC.getRealTypeByWidth(ti, 32, CC.CXFloatModeKind_Float) == CC.CXFloatModeKind_Float
    @test CC.getRealTypeByWidth(ti, 64, CC.CXFloatModeKind_Float) == CC.CXFloatModeKind_Double
    # and none has a real type of an absurd width
    @test CC.getRealTypeByWidth(ti, 3, CC.CXFloatModeKind_Float) == CC.CXFloatModeKind_NoFloat

    dispose(I)
end

@testset "Basic | TargetInfo predefined macros and LangOptions adjustment" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)
    lo = CC.getLangOpts(ci)
    diag = CC.getDiagnostics(ci)

    # The target's own `#define` block. The pinned triple turns the arch and OS macros into
    # facts about x86_64-linux-gnu instead of facts about the runner; the *number* of lines
    # is not pinned, because that drifts with every LLVM bump.
    defines = CC.getTargetDefines(ti, lo)
    lines = split(defines, '\n'; keepempty=false)
    @test count(l -> startswith(l, "#define "), lines) > 10
    @test any(l -> startswith(l, "#define __x86_64__ "), lines)
    @test any(l -> startswith(l, "#define __amd64__ "), lines)
    @test any(l -> startswith(l, "#define __linux__ "), lines)
    @test any(l -> startswith(l, "#define __gnu_linux__ "), lines)
    # ... and it really is the *target's* set, not the whole predefines buffer: the macros
    # around it -- __cplusplus, __ELF__, __LP64__ -- come from InitializePreprocessor.
    @test !any(l -> startswith(l, "#define __cplusplus "), lines)
    @test !any(l -> startswith(l, "#define __ELF__ "), lines)

    # `adjust` is idempotent in the fields it sets, and the interpreter already applied it
    # with these very options -- so re-running it must move nothing and report nothing.
    before = (CC.getWCharType(ti), CC.getWCharWidth(ti), CC.getDoubleAlign(ti), CC.getLongDoubleWidth(ti),
              CC.getLongDoubleAlign(ti), CC.getNewAlign(ti), CC.useBitFieldTypeAlignment(ti), CC.getFPEvalMethod(ti))
    nerrors = CC.getNumErrors(diag)
    CC.adjust(ti, diag, lo)
    after = (CC.getWCharType(ti), CC.getWCharWidth(ti), CC.getDoubleAlign(ti), CC.getLongDoubleWidth(ti),
             CC.getLongDoubleAlign(ti), CC.getNewAlign(ti), CC.useBitFieldTypeAlignment(ti), CC.getFPEvalMethod(ti))
    @test after == before
    @test CC.getNumErrors(diag) == nerrors
    @test CC.validateTarget(ti, diag)            # the target is still coherent afterwards
    @test CC.getTargetDefines(ti, lo) == defines # so its macro set is unchanged too

    dispose(I)
end

@testset "Basic | TargetInfo control-flow protection support" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)
    diag = CC.getDiagnostics(ci)

    # x86 implements control-flow enforcement, so both answers are true here -- and a true
    # answer reports nothing, which is the half of the contract an error count witnesses.
    nerrors = CC.getNumErrors(diag)
    @test CC.checkCFProtectionBranchSupported(ti, diag) == true
    @test CC.checkCFProtectionReturnSupported(ti, diag) == true
    @test CC.getNumErrors(diag) == nerrors

    # The other half needs a target that does not implement it: only X86 overrides these
    # two, so an AArch64 target description takes `TargetInfo`'s own implementation, which
    # answers false *and emits* err_opt_not_valid_on_target. The engine below swallows the
    # text but still counts the error, so the side effect is asserted rather than printed.
    quiet = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), CC.IgnoringDiagConsumer(), true)
    arm_ci = CC.CompilerInstance()
    arm_opts = CC.TargetOptions()
    CC.setTriple(arm_opts, "aarch64-unknown-linux-gnu")
    arm = CC.TargetInfo(arm_opts, quiet)  # absorbs arm_opts
    CC.setTarget(arm_ci, arm)             # adopts arm
    base = CC.getNumErrors(quiet)
    @test CC.checkCFProtectionBranchSupported(arm, quiet) == false
    @test CC.getNumErrors(quiet) == base + 1
    @test CC.checkCFProtectionReturnSupported(arm, quiet) == false
    @test CC.getNumErrors(quiet) == base + 2

    # The same standalone target describes *itself*, which is what makes the x86_64 macro
    # block in the testset above a fact about the triple and not about the host.
    arm_defines = CC.getTargetDefines(arm, CC.getLangOpts(ci))
    @test occursin("#define __aarch64__ ", arm_defines)
    @test !occursin("#define __x86_64__ ", arm_defines)

    dispose(arm_ci)                       # releases the adopted target
    CC.dispose(quiet)
    dispose(I)
end

@testset "Basic | TargetInfo global registers, cpu_specific features and fpret" begin
    I = create_parser(String[]; triple=PIN)
    ci = get_instance(I)
    ti = CC.getTarget(ci)

    # Global register variables are a strictly smaller set than the GCC register names --
    # which is the whole reason this question has an accessor of its own.
    named = ["rsp", "rax", "rbx", "rcx", "rdx"]
    @test all(r -> CC.isValidGCCRegisterName(ti, r), named)
    globals = filter(r -> CC.validateGlobalRegisterVariable(ti, r, 64) !== nothing, named)
    @test "rsp" in globals
    @test isempty(intersect(globals, ["rax", "rbx", "rcx", "rdx"]))
    # ... and the width answer is a separate answer from the validity one
    @test CC.validateGlobalRegisterVariable(ti, "rsp", 64) == false
    @test CC.validateGlobalRegisterVariable(ti, "rsp", 32) == true
    # total for any string, the empty one included
    @test CC.validateGlobalRegisterVariable(ti, "", 64) === nothing
    @test CC.validateGlobalRegisterVariable(ti, "not_a_register", 64) === nothing

    # cpu_specific feature lists, behind the same llvm_unreachable gate as the mangling
    # character. The pinned triple makes these exact: even `generic` carries the two features
    # every x86_64 baseline has, so an empty answer would be wrong rather than merely unusual.
    @test_throws AssertionError CC.getCPUSpecificCPUDispatchFeatures(ti, "definitely-not-a-cpu")
    @test CC.validateCPUSpecificCPUDispatch(ti, "generic")
    @test CC.getCPUSpecificCPUDispatchFeatures(ti, "generic") == ["+cx8", "+x87"]
    @test CC.validateCPUSpecificCPUDispatch(ti, "core_2_duo_ssse3")
    ssse3 = CC.getCPUSpecificCPUDispatchFeatures(ti, "core_2_duo_ssse3")
    @test !isempty(ssse3)
    @test all(!isempty, ssse3)
    @test any(f -> occursin("ssse3", f), ssse3)
    # two different cpu_specific variants describe two different feature sets
    @test CC.validateCPUSpecificCPUDispatch(ti, "pentium_4")
    @test CC.getCPUSpecificCPUDispatchFeatures(ti, "pentium_4") != ssse3

    # useObjCFPRetForRealType is a bitmask test against a mask the target's own constructor
    # fills in, so the pinned triple turns it into an equality rather than a shape. On x86_64
    # exactly one bit is set: `long double` returns in st(0), which is why an ObjC message send
    # returning one has to go through objc_msgSend_fpret instead of objc_msgSend. NoFloat is the
    # empty bit pattern and is false on every target.
    @test CC.useObjCFPRetForRealType(ti, CC.CXFloatModeKind_NoFloat) == false
    @test CC.useObjCFPRetForRealType(ti, CC.CXFloatModeKind_LongDouble) == true
    for m in
        (CC.CXFloatModeKind_Half, CC.CXFloatModeKind_Float, CC.CXFloatModeKind_Double, CC.CXFloatModeKind_Float128,
         CC.CXFloatModeKind_Ibm128)
        @test CC.useObjCFPRetForRealType(ti, m) == false
    end

    dispose(I)
end

@testset "Basic | TargetInfo::ConstraintInfo immediate ranges" begin
    # A fresh ConstraintInfo records no immediate range, so it accepts every value. What
    # follows is the round trip of a range this test itself set through setRequiresImmediate,
    # which until now was write-only -- nothing read the ImmRange back.
    imm = CC.ConstraintInfo("=r", "")
    @test CC.requiresImmediateConstant(imm) == false
    @test CC.isValidAsmImmediate(imm, 0)
    @test CC.isValidAsmImmediate(imm, typemax(Int64))
    @test CC.isValidAsmImmediate(imm, typemin(Int64))

    CC.setRequiresImmediate(imm, -8, 7)
    @test CC.requiresImmediateConstant(imm)
    @test CC.isValidAsmImmediate(imm, -8)              # the range is inclusive at both ends
    @test CC.isValidAsmImmediate(imm, 0)
    @test CC.isValidAsmImmediate(imm, 7)
    @test CC.isValidAsmImmediate(imm, -9) == false
    @test CC.isValidAsmImmediate(imm, 8) == false
    @test CC.isValidAsmImmediate(imm, typemax(Int64)) == false
    @test CC.isValidAsmImmediate(imm, typemin(Int64)) == false

    # widening the range accepts what the narrow one rejected: the flag is sticky, the
    # bounds are replaced
    CC.setRequiresImmediate(imm, -128, 127)
    @test CC.requiresImmediateConstant(imm)
    @test CC.isValidAsmImmediate(imm, 8)
    @test CC.isValidAsmImmediate(imm, 127)
    @test CC.isValidAsmImmediate(imm, 128) == false

    dispose(imm)
end

@testset "TargetInfo | a target survives being lent to a compiler instance" begin
    # TargetInfo is reference counted, and setTarget parks it in an IntrusiveRefCntPtr that
    # the instance releases when disposed. Because the target is handed back already holding
    # our reference, that borrow runs 1 -> 2 -> 1 and the target outlives the instance; it
    # used to run 0 -> 1 -> 0 and be deleted, which only ever showed on a *second* use.
    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)
    topts = CC.TargetOptions()
    CC.setTriple(topts, PIN)
    ti = CC.TargetInfo(topts, CC.getDiagnostics(ci))  # absorbs topts
    @test !CC.is_null_handle(ti)

    # These come from TransferrableTargetInfo, the first base, so they occupy the object's
    # leading bytes -- where a freed block would have free-list linkage written over it.
    fingerprint() = (CC.getBoolWidth(ti), CC.getCharWidth(ti), CC.getShortWidth(ti), CC.getIntWidth(ti),
                     CC.getLongWidth(ti), CC.getSizeType(ti))
    before = fingerprint()

    CC.setTarget(ci, ti)
    dispose(ci)

    # Second lifetime over the same target. Whatever the widths are for PIN, they are the
    # same widths, which a deleted-and-reused block would not reliably give back.
    ci2 = CC.CompilerInstance()
    CC.createDiagnostics(ci2)
    CC.setTarget(ci2, ti)
    @test fingerprint() == before
    dispose(ci2)

    # And the target is ours to free -- before this conversion there was no dispose at all.
    dispose(ti)
end
