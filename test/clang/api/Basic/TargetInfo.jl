using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Basic | TargetInfo target queries" begin
    I = CC.create_interpreter(String[])
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # identity strings
    @test !isempty(CC.getTriple(ti))
    @test !isempty(CC.getDataLayoutString(ti))
    @test CC.getABI(ti) isa String
    @test CC.getPlatformName(ti) isa String
    @test CC.getUserLabelPrefix(ti) isa String
    @test CC.getMCountName(ti) isa String
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

    # presence/support predicates
    for f in (CC.hasInt128Type, CC.hasBitIntType, CC.hasLegalHalfType, CC.hasFloat16Type,
              CC.hasBFloat16Type, CC.hasFullBFloat16Type, CC.hasFloat128Type, CC.hasIbm128Type,
              CC.hasLongDoubleType, CC.hasFPReturn, CC.hasStrictFP, CC.hasAArch64SVETypes,
              CC.hasRISCVVTypes, CC.supportsMultiVersioning, CC.supportsIFunc,
              CC.isTLSSupported, CC.isVLASupported)
        @test f(ti) isa Bool
    end

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
    @test CC.isValidTuneCPUName(ti, "this-cpu-does-not-exist") isa Bool
    @test CC.isValidFeatureName(ti, "not-a-real-feature-name") isa Bool
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
    I = CC.create_interpreter(String[])
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
    for f in (CC.getWIntType, CC.getChar16Type, CC.getChar32Type, CC.getSigAtomicType,
              CC.getProcessIDType)
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
    @test CC.getTypeConstantSuffix(ti, CC.CXTargetInfo_SignedLong) isa String
    @test CC.getTypeConstantSuffix(ti, CC.CXTargetInfo_UnsignedInt) isa String
    @test CC.getTypeFormatModifier(CC.CXTargetInfo_SignedLong) == "l"
    @test CC.getTypeFormatModifier(CC.CXTargetInfo_SignedShort) isa String
    @test_throws AssertionError CC.getTypeFormatModifier(CC.CXTargetInfo_NoInt)

    # register width and bitfield layout scalars
    @test CC.getRegisterWidth(ti) in (32, 64)
    @test CC.useBitFieldTypeAlignment(ti) isa Bool
    @test CC.getZeroLengthBitfieldBoundary(ti) isa Cuint
    @test CC.getMaxAlignedAttribute(ti) isa Cuint

    CC.dispose(I)
end

@testset "Basic | TargetInfo ABI knobs and GCC register names" begin
    I = CC.create_interpreter(String[])
    ci = CC.get_instance(I)
    ti = CC.getTarget(ci)

    # null pointer value, minimum global alignment, large-array thresholds
    @test CC.getNullPointerValue(ti) isa UInt64
    @test CC.getNullPointerValue(ti, CC.CXLangAS_Default) == CC.getNullPointerValue(ti)
    @test CC.getMinGlobalAlign(ti, UInt64(64)) isa Cuint
    @test CC.getLargeArrayMinWidth(ti) isa Cuint
    @test CC.getLargeArrayAlign(ti) isa Cuint
    @test CC.getUnwindWordWidth(ti) in (32, 64)

    # __ibm128: the width is fixed, the mangling only exists where the type does
    @test CC.getIbm128Width(ti) == 128
    @test CC.getIbm128Align(ti) isa Cuint
    if CC.hasIbm128Type(ti)
        @test !isempty(CC.getIbm128Mangling(ti))
    else
        @test_throws AssertionError CC.getIbm128Mangling(ti)
    end

    # Itanium mangling codes of the other extended floating-point types
    @test !isempty(CC.getLongDoubleMangling(ti))
    @test !isempty(CC.getFloat128Mangling(ti))
    @test !isempty(CC.getBFloat16Mangling(ti))

    # bitfield layout / address-space mangling / builtin predicates
    @test CC.useZeroLengthBitfieldAlignment(ti) isa Bool
    @test CC.useLeadingZeroLengthBitfield(ti) isa Bool
    @test CC.useExplicitBitFieldAlignment(ti) isa Bool
    @test CC.useAddressSpaceMapMangling(ti) isa Bool
    @test CC.isCLZForZeroUndef(ti) isa Bool
    @test CC.hasBuiltinMSVaList(ti) isa Bool

    # inline-asm clobbers and GCC register names
    @test CC.isValidClobber(ti, "memory")
    @test CC.isValidClobber(ti, "cc")
    @test !CC.isValidGCCRegisterName(ti, "not_a_register")
    @test !CC.isValidClobber(ti, "not_a_register")
    @test_throws AssertionError CC.getNormalizedGCCRegisterName(ti, "not_a_register")

    # normalization needs a register this host's target actually has
    candidates = ["ax", "eax", "rax", "x0", "r0", "sp"]
    i = findfirst(r -> CC.isValidGCCRegisterName(ti, r), candidates)
    if i !== nothing
        reg = candidates[i]
        @test CC.isValidClobber(ti, reg)
        @test !isempty(CC.getNormalizedGCCRegisterName(ti, reg))
        @test CC.getNormalizedGCCRegisterName(ti, reg, true) isa String
    end

    CC.dispose(I)
end

@testset "Basic | TargetInfo target policy queries" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    ti = CC.getTarget(ci)

    # the options the target was configured from: borrowed, never disposed here
    opts = CC.getTargetOpts(ti)
    @test opts isa CC.TargetOptions
    @test opts.ptr != C_NULL

    # ObjC BOOL / mac68k pragma / __fp16 conversion intrinsics
    @test CC.useSignedCharForObjCBool(ti) isa Bool
    @test CC.hasAlignMac68kSupport(ti) isa Bool
    @test CC.useFP16ConversionIntrinsics(ti) isa Bool

    # ARM CDE coprocessor mask is an 8-bit bitfield, zero away from ARM
    @test CC.getARMCDECoprocMask(ti) isa Unsigned
    @test CC.getARMCDECoprocMask(ti) <= 0xff

    # stack-pointer register names and single-register constraint extraction
    @test !CC.isSPRegName(ti, "not_a_register")
    @test all(r -> CC.isSPRegName(ti, r) isa Bool, ["sp", "esp", "rsp", "r1", "x31"])
    @test CC.getConstraintRegister(ti, "a", "") isa String
    @test CC.getConstraintRegister(ti, "r", "") isa String
    @test isempty(CC.getConstraintRegister(ti, "", ""))

    # NaN encoding, ELF protected visibility, MSVC dllimport comdat semantics
    @test CC.isNan2008(ti) isa Bool
    @test CC.hasProtectedVisibility(ti) isa Bool
    @test CC.shouldDLLImportComdatSymbols(ti) isa Bool

    # register-passed arguments (clang itself asserts < 7) and the TLS alignment cap
    @test CC.getRegParmMax(ti) isa Cuint
    @test CC.getRegParmMax(ti) < 7
    @test CC.getMaxTLSAlign(ti) isa Cuint

    # SEH __try, asm variants, EH data registers, static-init section
    @test CC.isSEHTrySupported(ti) isa Bool
    @test CC.hasNoAsmVariants(ti) isa Bool
    @test CC.getEHDataRegisterNumber(ti, 0) isa Cint
    @test CC.getEHDataRegisterNumber(ti, 0) >= -1
    @test CC.getEHDataRegisterNumber(ti, 1) >= -1
    @test CC.getEHDataRegisterNumber(ti, 99) == -1
    sect = CC.getStaticInitSectionSpecifier(ti)
    @test sect === nothing || sect isa String

    # setjmp/longjmp lowering, over-alignment policy, vtable pointer address space
    @test CC.hasSjLjLowering(ti) isa Bool
    @test CC.allowsLargerPreferedTypeAlignment(ti) isa Bool
    @test CC.defaultsToAIXPowerAlignment(ti) isa Bool
    @test CC.getVtblPtrAddressSpace(ti) isa Cuint

    dispose(I)
end

@testset "Basic | TargetInfo::ConstraintInfo" begin
    I = CC.create_interpreter(String[])
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
    I = create_interpreter(String[])
    ci = get_instance(I)
    ti = CC.getTarget(ci)

    # Plain target predicates: the host triple decides every value, so assert only the shape.
    @test CC.allowHalfArgsAndReturns(ti) isa Bool
    @test CC.supportSourceEvalMethod(ti) isa Bool
    @test CC.useObjCFP2RetForComplexLongDouble(ti) isa Bool
    @test CC.allowAMDGPUUnsafeFPAtomics(ti) isa Bool
    @test CC.hasPS4DLLImportExport(ti) isa Bool
    @test CC.supportsTargetAttributeTune(ti) isa Bool
    @test CC.supportsExtendIntArgs(ti) isa Bool
    @test CC.checkArithmeticFenceSupported(ti) isa Bool
    @test CC.allowDebugInfoForExternalRef(ti) isa Bool
    @test CC.getMaxOpenCLWorkGroupSize(ti) isa Integer
    # not host-decided: an interpreter built from an empty command line never targets
    # RenderScript on any of the CI platforms
    @test CC.isRenderScriptTarget(ti) == false

    # Feature-name queries are total for any string.
    @test CC.doesFeatureAffectCodeGen(ti, "sse2") isa Bool
    @test CC.isReadOnlyFeature(ti, "sse2") isa Bool
    @test CC.getFeatureDependencies(ti, "sse2") isa String
    @test isempty(CC.getFeatureDependencies(ti, "no-such-feature"))
    @test CC.isBranchProtectionSupportedArch(ti, "x86-64") isa Bool

    # __builtin_cpu_supports / __builtin_cpu_is / cpu_dispatch argument validation: these
    # are the functions Sema calls on raw user strings, so they are total.
    @test CC.validateCpuSupports(ti, "sse2") isa Bool
    @test CC.validateCpuIs(ti, "atom") isa Bool
    @test CC.validateCPUSpecificCPUDispatch(ti, "generic") isa Bool
    @test CC.validateCpuSupports(ti, "definitely-not-a-feature") == false
    @test CC.validateCpuIs(ti, "definitely-not-a-cpu") == false
    @test CC.multiVersionFeatureCost(ti) isa Integer

    # multiVersionSortPriority indexes a target-specific priority table, so it is only
    # defined for a name the same target already validated -- clang itself only reaches it
    # from strings that passed validateCpuSupports. On a target with no multiversioning
    # support nothing validates and the loop body simply does not run.
    for f in filter(n -> CC.validateCpuSupports(ti, n), ["sse2", "avx", "neon"])
        @test CC.multiVersionSortPriority(ti, f) isa Integer
    end

    dispose(I)
end

@testset "Basic | TargetInfo address spaces, calling conventions, target identity" begin
    I = create_interpreter(String[])
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
    dwarf = CC.getDWARFAddressSpace(ti, 0)
    @test dwarf === nothing || dwarf isa Integer

    # Calling conventions: whichever default the target picks, its own checker has to
    # accept it -- that is the invariant Sema relies on when it substitutes the default.
    cc = CC.getDefaultCallingConv(ti)
    @test cc isa CC.CXCallingConv_
    @test CC.checkCallingConvention(ti, cc) == CC.CXTargetInfo_CCCR_OK
    @test CC.checkCallingConvention(ti, CC.CXCallingConv_CC_C) == CC.CXTargetInfo_CCCR_OK
    @test CC.getCallingConvKind(ti, false) isa CC.CXTargetInfo_CallingConvKind
    @test CC.getCallingConvKind(ti, true) isa CC.CXTargetInfo_CallingConvKind
    @test CC.areDefaultedSMFStillPOD(ti, lo) isa Bool

    # VersionTuples cross as their printed form; the digits are the target's business, but
    # VersionTuple always prints at least a major number.
    @test CC.getPlatformMinVersion(ti) isa String
    @test !isempty(CC.getPlatformMinVersion(ti))
    @test CC.getSDKVersion(ti) isa String

    # Target identity. Both the target ID and the Darwin variant triple are absent on the
    # ordinary host targets CI runs on, so only the shape is asserted.
    @test CC.getTargetID(ti) isa String
    variant = CC.getDarwinTargetVariantTriple(ti)
    @test variant === nothing || variant isa String
    @test CC.hasHIPImageSupport(ti) isa Bool
    @test CC.validateTarget(ti, diag) isa Bool

    # Tune-CPU names: the list is target-decided (and empty on targets that model none),
    # but no entry is ever an empty string.
    tune = CC.fillValidTuneCPUList(ti)
    @test tune isa Vector{String}
    @test all(!isempty, tune)

    # cpu_specific mangling is an llvm_unreachable on every target that does not implement
    # it, so the wrapper asserts the same gate Sema checks first. Only X86 implements it,
    # so the positive branch runs on the x86_64 runners and not on an arm64 host.
    @test_throws AssertionError CC.CPUSpecificManglingCharacter(ti, "definitely-not-a-cpu")
    for name in ("generic", "pentium_4", "core_2_duo_ssse3")
        if CC.validateCPUSpecificCPUDispatch(ti, name)
            @test CC.CPUSpecificManglingCharacter(ti, name) isa Integer
            break
        end
    end

    dispose(I)
end
