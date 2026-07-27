# TargetInfo
function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @check_ptrs opts diag
    info = clang_TargetInfo_CreateTargetInfo(diag, opts)
    return TargetInfo(info)
end


function getSizeType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getSizeType(x)
end

function getIntMaxType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIntMaxType(x)
end

function getPtrDiffType(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_TargetInfo_getPtrDiffType(x, addr_space)
end

function getIntPtrType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIntPtrType(x)
end

function getWCharType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getWCharType(x)
end

function getInt64Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getInt64Type(x)
end

getCorrespondingUnsignedType(T::CXTargetInfo_IntType) = clang_TargetInfo_getCorrespondingUnsignedType(T)

function getTypeWidth(x::AbstractTargetInfo, T::CXTargetInfo_IntType)
    @check_ptrs x
    return clang_TargetInfo_getTypeWidth(x, T)
end

function getIntTypeByWidth(x::AbstractTargetInfo, bit_width::Integer, is_signed::Bool)
    @check_ptrs x
    return clang_TargetInfo_getIntTypeByWidth(x, bit_width, is_signed)
end

function getTypeAlign(x::AbstractTargetInfo, T::CXTargetInfo_IntType)
    @check_ptrs x
    return clang_TargetInfo_getTypeAlign(x, T)
end

isTypeSigned(T::CXTargetInfo_IntType) = clang_TargetInfo_isTypeSigned(T)

function getPointerWidth(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_TargetInfo_getPointerWidth(x, addr_space)
end

function getPointerAlign(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_TargetInfo_getPointerAlign(x, addr_space)
end

function getMaxPointerWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxPointerWidth(x)
end

function getBoolWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getBoolWidth(x)
end

function getBoolAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getBoolAlign(x)
end

function getCharWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getCharWidth(x)
end

function getCharAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getCharAlign(x)
end

function getShortWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getShortWidth(x)
end

function getShortAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getShortAlign(x)
end

function getIntWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIntWidth(x)
end

function getIntAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIntAlign(x)
end

function getLongWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongWidth(x)
end

function getLongAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongAlign(x)
end

function getLongLongWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongLongWidth(x)
end

function getLongLongAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongLongAlign(x)
end

function getInt128Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getInt128Align(x)
end

function hasInt128Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasInt128Type(x)
end

function hasBitIntType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasBitIntType(x)
end

function getMaxBitIntWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxBitIntWidth(x)
end

function hasLegalHalfType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasLegalHalfType(x)
end

function hasFloat128Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasFloat128Type(x)
end

function hasFloat16Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasFloat16Type(x)
end

function hasBFloat16Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasBFloat16Type(x)
end

function hasFullBFloat16Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasFullBFloat16Type(x)
end

function hasIbm128Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasIbm128Type(x)
end

function hasLongDoubleType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasLongDoubleType(x)
end

function hasFPReturn(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasFPReturn(x)
end

function hasStrictFP(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasStrictFP(x)
end

function getSuitableAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getSuitableAlign(x)
end

function getDefaultAlignForAttributeAligned(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getDefaultAlignForAttributeAligned(x)
end

function getNewAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getNewAlign(x)
end

function getWCharWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getWCharWidth(x)
end

function getWCharAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getWCharAlign(x)
end

function getChar16Width(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar16Width(x)
end

function getChar16Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar16Align(x)
end

function getChar32Width(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar32Width(x)
end

function getChar32Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar32Align(x)
end

function getHalfWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getHalfWidth(x)
end

function getHalfAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getHalfAlign(x)
end

function getFloatWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getFloatWidth(x)
end

function getFloatAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getFloatAlign(x)
end

function getBFloat16Width(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getBFloat16Width(x)
end

function getBFloat16Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getBFloat16Align(x)
end

function getDoubleWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getDoubleWidth(x)
end

function getDoubleAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getDoubleAlign(x)
end

function getLongDoubleWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongDoubleWidth(x)
end

function getLongDoubleAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLongDoubleAlign(x)
end

function getFloat128Width(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getFloat128Width(x)
end

function getFloat128Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getFloat128Align(x)
end

function getMaxAtomicPromoteWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxAtomicPromoteWidth(x)
end

function getMaxAtomicInlineWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxAtomicInlineWidth(x)
end

function hasBuiltinAtomic(x::AbstractTargetInfo, atomic_size_bits::Integer, alignment_bits::Integer)
    @check_ptrs x
    return clang_TargetInfo_hasBuiltinAtomic(x, atomic_size_bits, alignment_bits)
end

function getMaxVectorAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxVectorAlign(x)
end

function getExnObjectAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getExnObjectAlignment(x)
end

function getUserLabelPrefix(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getUserLabelPrefix(x))
end

function getMCountName(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getMCountName(x))
end

getTypeName(T::CXTargetInfo_IntType) = unsafe_string(clang_TargetInfo_getTypeName(T))

"""
    getVScaleRange(x::AbstractTargetInfo, lo::LangOptions) -> Union{Tuple{Cuint,Cuint},Nothing}
Return the target-specific `(min, max)` vscale range, or `nothing` when the target defines
none (the C++ optional is disengaged).
"""
function getVScaleRange(x::AbstractTargetInfo, lo::LangOptions)
    @check_ptrs x lo
    vmin = Ref{Cuint}(0)
    vmax = Ref{Cuint}(0)
    return clang_TargetInfo_getVScaleRange(x, lo, vmin, vmax) ? (vmin[], vmax[]) : nothing
end

function getBuiltinVaListKind(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getBuiltinVaListKind(x)
end

function hasAArch64SVETypes(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasAArch64SVETypes(x)
end

function hasRISCVVTypes(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasRISCVVTypes(x)
end

function getClobbers(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getClobbers(x))
end

"""
    getTriple(x::AbstractTargetInfo) -> String
Return the target triple string of the primary target.
"""
function getTriple(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getTriple(x))
end

function getDataLayoutString(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getDataLayoutString(x))
end

function getABI(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getABI(x))
end

function getCXXABI(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getCXXABI(x)
end

"""
    fillValidCPUList(x::AbstractTargetInfo) -> Vector{String}
Return the valid CPU names for this target (the valid values for `-target-cpu`).
"""
function fillValidCPUList(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_fillValidCPUList(x))
end

function isValidCPUName(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isValidCPUName(x, name)
end

function isValidTuneCPUName(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isValidTuneCPUName(x, name)
end

function isValidFeatureName(x::AbstractTargetInfo, feature::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isValidFeatureName(x, feature)
end

function hasFeature(x::AbstractTargetInfo, feature::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_hasFeature(x, feature)
end

function supportsMultiVersioning(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_supportsMultiVersioning(x)
end

function supportsIFunc(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_supportsIFunc(x)
end

"""
    getCPUCacheLineSize(x::AbstractTargetInfo) -> Union{Cuint,Nothing}
Return the cache line size of the target CPU, or `nothing` when the CPU is unknown
(the C++ optional is disengaged).
"""
function getCPUCacheLineSize(x::AbstractTargetInfo)
    @check_ptrs x
    sz = Ref{Cuint}(0)
    return clang_TargetInfo_getCPUCacheLineSize(x, sz) ? sz[] : nothing
end

function isTLSSupported(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isTLSSupported(x)
end

function isVLASupported(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isVLASupported(x)
end

function getTargetAddressSpace(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_TargetInfo_getTargetAddressSpace(x, addr_space)
end

function getPlatformName(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getPlatformName(x))
end

function isBigEndian(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isBigEndian(x)
end

function isLittleEndian(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isLittleEndian(x)
end


"""
    getSignedSizeType(x::AbstractTargetInfo) -> CXTargetInfo_IntType
Return the signed counterpart of the target's `size_t`.

The target's `size_t` must be one of unsigned short/int/long/long long.
"""
function getSignedSizeType(x::AbstractTargetInfo)
    @check_ptrs x
    @assert getSizeType(x) in (CXTargetInfo_UnsignedShort, CXTargetInfo_UnsignedInt, CXTargetInfo_UnsignedLong,
                               CXTargetInfo_UnsignedLongLong) "size_t must be an unsigned integer type"
    return clang_TargetInfo_getSignedSizeType(x)
end

"""
    getUIntMaxType(x::AbstractTargetInfo) -> CXTargetInfo_IntType
Return the target's `uintmax_t`. The target's `intmax_t` must be a signed integer type.
"""
function getUIntMaxType(x::AbstractTargetInfo)
    @check_ptrs x
    @assert isTypeSigned(getIntMaxType(x)) "intmax_t must be a signed integer type"
    return clang_TargetInfo_getUIntMaxType(x)
end

"""
    getUnsignedPtrDiffType(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default) -> CXTargetInfo_IntType
Return the unsigned counterpart of the target's `ptrdiff_t` in `addr_space`, which must be
a signed integer type.
"""
function getUnsignedPtrDiffType(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    @assert isTypeSigned(getPtrDiffType(x, addr_space)) "ptrdiff_t must be a signed integer type"
    return clang_TargetInfo_getUnsignedPtrDiffType(x, addr_space)
end

"""
    getUIntPtrType(x::AbstractTargetInfo) -> CXTargetInfo_IntType
Return the target's `uintptr_t`. The target's `intptr_t` must be a signed integer type.
"""
function getUIntPtrType(x::AbstractTargetInfo)
    @check_ptrs x
    @assert isTypeSigned(getIntPtrType(x)) "intptr_t must be a signed integer type"
    return clang_TargetInfo_getUIntPtrType(x)
end

function getWIntType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getWIntType(x)
end

function getChar16Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar16Type(x)
end

function getChar32Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getChar32Type(x)
end

"""
    getUInt64Type(x::AbstractTargetInfo) -> CXTargetInfo_IntType
Return the target's `uint64_t`. The target's `int64_t` must be a signed integer type.
"""
function getUInt64Type(x::AbstractTargetInfo)
    @check_ptrs x
    @assert isTypeSigned(getInt64Type(x)) "int64_t must be a signed integer type"
    return clang_TargetInfo_getUInt64Type(x)
end

function getInt16Type(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getInt16Type(x)
end

"""
    getUInt16Type(x::AbstractTargetInfo) -> CXTargetInfo_IntType
Return the target's `uint16_t`. The target's `int16_t` must be a signed integer type.
"""
function getUInt16Type(x::AbstractTargetInfo)
    @check_ptrs x
    @assert isTypeSigned(getInt16Type(x)) "int16_t must be a signed integer type"
    return clang_TargetInfo_getUInt16Type(x)
end

function getSigAtomicType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getSigAtomicType(x)
end

function getProcessIDType(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getProcessIDType(x)
end

"""
    getLeastIntTypeByWidth(x::AbstractTargetInfo, bit_width::Integer, is_signed::Bool) -> CXTargetInfo_IntType
Return the smallest integer type with at least `bit_width` bits.
"""
function getLeastIntTypeByWidth(x::AbstractTargetInfo, bit_width::Integer, is_signed::Bool)
    @check_ptrs x
    return clang_TargetInfo_getLeastIntTypeByWidth(x, bit_width, is_signed)
end

function getIntMaxTWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIntMaxTWidth(x)
end

function getRegisterWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getRegisterWidth(x)
end

function useBitFieldTypeAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useBitFieldTypeAlignment(x)
end

function getZeroLengthBitfieldBoundary(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getZeroLengthBitfieldBoundary(x)
end

function getMaxAlignedAttribute(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxAlignedAttribute(x)
end

"""
    getTypeConstantSuffix(x::AbstractTargetInfo, T::CXTargetInfo_IntType) -> String
Return the integer-literal constant suffix for `T` (e.g. `CXTargetInfo_SignedLong` -> `"L"`).
`T` must name an integer type, i.e. not `CXTargetInfo_NoInt`.
"""
function getTypeConstantSuffix(x::AbstractTargetInfo, T::CXTargetInfo_IntType)
    @check_ptrs x
    @assert T != CXTargetInfo_NoInt "T must name an integer type"
    return unsafe_string(clang_TargetInfo_getTypeConstantSuffix(x, T))
end

"""
    getTypeFormatModifier(T::CXTargetInfo_IntType) -> String
Return the printf format modifier for `T` (e.g. `CXTargetInfo_SignedLong` -> `"l"`).
`T` must name an integer type, i.e. not `CXTargetInfo_NoInt`.
"""
function getTypeFormatModifier(T::CXTargetInfo_IntType)
    @assert T != CXTargetInfo_NoInt "T must name an integer type"
    return unsafe_string(clang_TargetInfo_getTypeFormatModifier(T))
end


function getNullPointerValue(x::AbstractTargetInfo, addr_space::CXLangAS=CXLangAS_Default)
    @check_ptrs x
    return clang_TargetInfo_getNullPointerValue(x, addr_space)
end

function getMinGlobalAlign(x::AbstractTargetInfo, size::Integer)
    @check_ptrs x
    return clang_TargetInfo_getMinGlobalAlign(x, size)
end

function getIbm128Width(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIbm128Width(x)
end

function getIbm128Align(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getIbm128Align(x)
end

function getLongDoubleMangling(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getLongDoubleMangling(x))
end

function getFloat128Mangling(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getFloat128Mangling(x))
end

"""
    getIbm128Mangling(x::AbstractTargetInfo) -> String
Return the mangled code of `__ibm128`. The target must provide that type, i.e.
`hasIbm128Type(x)` must hold — the base implementation is `llvm_unreachable` otherwise.
"""
function getIbm128Mangling(x::AbstractTargetInfo)
    @check_ptrs x
    @assert hasIbm128Type(x) "target must provide an __ibm128 type"
    return unsafe_string(clang_TargetInfo_getIbm128Mangling(x))
end

function getBFloat16Mangling(x::AbstractTargetInfo)
    @check_ptrs x
    return unsafe_string(clang_TargetInfo_getBFloat16Mangling(x))
end

function getLargeArrayMinWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLargeArrayMinWidth(x)
end

function getLargeArrayAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getLargeArrayAlign(x)
end

function getUnwindWordWidth(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getUnwindWordWidth(x)
end

function useZeroLengthBitfieldAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useZeroLengthBitfieldAlignment(x)
end

function useLeadingZeroLengthBitfield(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useLeadingZeroLengthBitfield(x)
end

function useExplicitBitFieldAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useExplicitBitFieldAlignment(x)
end

function useAddressSpaceMapMangling(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useAddressSpaceMapMangling(x)
end

function isCLZForZeroUndef(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isCLZForZeroUndef(x)
end

function hasBuiltinMSVaList(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasBuiltinMSVaList(x)
end

function isValidClobber(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isValidClobber(x, name)
end

function isValidGCCRegisterName(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isValidGCCRegisterName(x, name)
end

"""
    getNormalizedGCCRegisterName(x::AbstractTargetInfo, name::AbstractString,
                                 canonical::Bool=false) -> String
Return the "normalized" GCC register name for `name`; with `canonical`, the form without any
`%` prefix or `{}` wrapping (e.g. `"rax"` -> `"ax"` on x86). `name` must be a valid GCC
register name for this target, i.e. `isValidGCCRegisterName(x, name)` must hold.
"""
function getNormalizedGCCRegisterName(x::AbstractTargetInfo, name::AbstractString,
                                      canonical::Bool=false)
    @check_ptrs x
    @assert isValidGCCRegisterName(x, name) "name must be a valid GCC register name"
    return get_string(clang_TargetInfo_getNormalizedGCCRegisterName(x, name, canonical))
end


"""
    getTargetOpts(x::AbstractTargetInfo) -> TargetOptions
Return the [`TargetOptions`](@ref) this target was configured from. The options are borrowed
(the `TargetInfo` holds the only owning reference), so the result must never be `dispose`d.
"""
function getTargetOpts(x::AbstractTargetInfo)
    @check_ptrs x
    return TargetOptions(clang_TargetInfo_getTargetOpts(x))
end

function useSignedCharForObjCBool(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useSignedCharForObjCBool(x)
end

function hasAlignMac68kSupport(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasAlignMac68kSupport(x)
end

function useFP16ConversionIntrinsics(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useFP16ConversionIntrinsics(x)
end

"""
    getARMCDECoprocMask(x::AbstractTargetInfo) -> UInt32
Return the 8-bit mask of coprocessors configured as ARM Custom Datapath Extension units; it
is zero on every target that has no CDE support.
"""
function getARMCDECoprocMask(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getARMCDECoprocMask(x)
end

function isSPRegName(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isSPRegName(x, name)
end

"""
    getConstraintRegister(x::AbstractTargetInfo, constraint::AbstractString,
                          expression::AbstractString) -> String
Return the register `constraint` designates, given `expression` as the asm label of the
related input/output operand. Returns the empty string when `constraint` is not a
single-register constraint.
"""
function getConstraintRegister(x::AbstractTargetInfo, constraint::AbstractString,
                               expression::AbstractString)
    @check_ptrs x
    return get_string(clang_TargetInfo_getConstraintRegister(x, constraint, expression))
end

function isNan2008(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isNan2008(x)
end

function hasProtectedVisibility(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasProtectedVisibility(x)
end

function shouldDLLImportComdatSymbols(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_shouldDLLImportComdatSymbols(x)
end

"""
    getRegParmMax(x::AbstractTargetInfo) -> Cuint
Return the maximum number of arguments this target passes in registers. Clang caps the value
at 6, since that is all the AST can encode.
"""
function getRegParmMax(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getRegParmMax(x)
end

"""
    getMaxTLSAlign(x::AbstractTargetInfo) -> Cuint
Return the maximum alignment (in bits) of a thread-local variable, or zero when the target
imposes no such limit.
"""
function getMaxTLSAlign(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxTLSAlign(x)
end

function isSEHTrySupported(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isSEHTrySupported(x)
end

"""
    hasNoAsmVariants(x::AbstractTargetInfo) -> Bool
Return `true` when `{` and `}` are ordinary characters in an asm string. When `false`, the
`{abc|xyz}` syntax selects between asm variants.
"""
function hasNoAsmVariants(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasNoAsmVariants(x)
end

"""
    getEHDataRegisterNumber(x::AbstractTargetInfo, regno::Integer) -> Cint
Return the register number `__builtin_eh_return_regno(regno)` yields on this target, or `-1`
when the target defines no register for `regno`.
"""
function getEHDataRegisterNumber(x::AbstractTargetInfo, regno::Integer)
    @check_ptrs x
    return clang_TargetInfo_getEHDataRegisterNumber(x, regno)
end

"""
    getStaticInitSectionSpecifier(x::AbstractTargetInfo) -> Union{String,Nothing}
Return the section C++ static initialization functions are emitted into, or `nothing` when
the target names no such section (the default).
"""
function getStaticInitSectionSpecifier(x::AbstractTargetInfo)
    @check_ptrs x
    p = clang_TargetInfo_getStaticInitSectionSpecifier(x)
    return p == C_NULL ? nothing : unsafe_string(p)
end

"""
    hasSjLjLowering(x::AbstractTargetInfo) -> Bool
Return `true` when `__builtin_setjmp`/`__builtin_longjmp` may be lowered to the
`llvm.eh.sjlj.*` intrinsics on this target.
"""
function hasSjLjLowering(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasSjLjLowering(x)
end

function allowsLargerPreferedTypeAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_allowsLargerPreferedTypeAlignment(x)
end

function defaultsToAIXPowerAlignment(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_defaultsToAIXPowerAlignment(x)
end

function getVtblPtrAddressSpace(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getVtblPtrAddressSpace(x)
end
