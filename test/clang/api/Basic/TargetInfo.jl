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
