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
