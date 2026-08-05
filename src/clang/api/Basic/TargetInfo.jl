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
    getTargetDefines(x::AbstractTargetInfo, lo::LangOptions) -> String
Return the target-specific `#define` block for `x`: the text Clang folds into the predefines
buffer while initialising a preprocessor, one newline-terminated directive per line.

`lo` is read, never written. The answer therefore reflects the language options exactly as
they stand, so reading it before [`adjust`](@ref) gives the faithful pre-adjust picture
rather than the one the preprocessor would eventually see.
"""
function getTargetDefines(x::AbstractTargetInfo, lo::LangOptions)
    @check_ptrs x lo
    return get_string(clang_TargetInfo_getTargetDefines(x, lo))
end

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
    @assert getSizeType(x) in (CXTargetInfo_UnsignedShort, CXTargetInfo_UnsignedInt, CXTargetInfo_UnsignedLong, CXTargetInfo_UnsignedLongLong) "size_t must be an unsigned integer type"
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
function getNormalizedGCCRegisterName(x::AbstractTargetInfo, name::AbstractString, canonical::Bool=false)
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
function getConstraintRegister(x::AbstractTargetInfo, constraint::AbstractString, expression::AbstractString)
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

"""
    checkCFProtectionBranchSupported(x::AbstractTargetInfo, diag::DiagnosticsEngine) -> Bool
Whether `-fcf-protection=branch` -- control-flow enforcement on indirect branches -- is
supported on this target.

A `false` answer *emits* an error into `diag` rather than returning quietly, so the engine's
error count moves; pass a throwaway engine when that matters.
"""
function checkCFProtectionBranchSupported(x::AbstractTargetInfo, diag::DiagnosticsEngine)
    @check_ptrs x diag
    return clang_TargetInfo_checkCFProtectionBranchSupported(x, diag)
end

"""
    checkCFProtectionReturnSupported(x::AbstractTargetInfo, diag::DiagnosticsEngine) -> Bool
Whether `-fcf-protection=return` -- control-flow enforcement on returns -- is supported on
this target.

A `false` answer *emits* an error into `diag` rather than returning quietly, so the engine's
error count moves; pass a throwaway engine when that matters.
"""
function checkCFProtectionReturnSupported(x::AbstractTargetInfo, diag::DiagnosticsEngine)
    @check_ptrs x diag
    return clang_TargetInfo_checkCFProtectionReturnSupported(x, diag)
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

# TargetInfo::ConstraintInfo

"""
    ConstraintInfo(constraint::AbstractString, name::AbstractString)
Create a `clang::TargetInfo::ConstraintInfo` describing the inline-asm operand constraint
string `constraint` (e.g. `"=rm"`), carrying the symbolic operand name `name` — the `foo` of
`[foo]`, with no brackets; pass `""` for an unnamed operand.

The object starts out with no flags and no tied operand: `validateOutputConstraint` and the
`set*` methods are what populate it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ConstraintInfo(constraint::AbstractString, name::AbstractString)
    ptr = clang_ConstraintInfo_create(constraint, name)
    @assert ptr != C_NULL "Failed to create TargetInfo::ConstraintInfo"
    return ConstraintInfo(ptr)
end

dispose(x::ConstraintInfo) = clang_ConstraintInfo_dispose(x)

"""
    getConstraintStr(x::AbstractConstraintInfo) -> String
Return the constraint string `x` was built from, e.g. `"=rm"`.
"""
function getConstraintStr(x::AbstractConstraintInfo)
    @check_ptrs x
    return unsafe_string(clang_ConstraintInfo_getConstraintStr(x))
end

"""
    getName(x::AbstractConstraintInfo) -> String
Return the symbolic operand name of `x` (the `foo` of `[foo]`, with no brackets), or the
empty string when the operand is unnamed.
"""
function getName(x::AbstractConstraintInfo)
    @check_ptrs x
    return unsafe_string(clang_ConstraintInfo_getName(x))
end

"""
    isReadWrite(x::AbstractConstraintInfo) -> Bool
Whether `x` is a `"+r"`-style output constraint, i.e. one the asm both reads and writes.
"""
function isReadWrite(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_isReadWrite(x)
end

"""
    earlyClobber(x::AbstractConstraintInfo) -> Bool
Whether `x` carries the `"&"` early-clobber modifier — the operand is written before all
inputs have been consumed, so it may not share a register with any of them.
"""
function earlyClobber(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_earlyClobber(x)
end

"""
    allowsRegister(x::AbstractConstraintInfo) -> Bool
Whether the operand described by `x` may live in a register.
"""
function allowsRegister(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_allowsRegister(x)
end

"""
    allowsMemory(x::AbstractConstraintInfo) -> Bool
Whether the operand described by `x` may live in memory.
"""
function allowsMemory(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_allowsMemory(x)
end

"""
    hasMatchingInput(x::AbstractConstraintInfo) -> Bool
Whether this output operand has a matching (tied) input operand.
"""
function hasMatchingInput(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_hasMatchingInput(x)
end

"""
    hasTiedOperand(x::AbstractConstraintInfo) -> Bool
Whether this input operand is a matching constraint tying it to an output operand; when
`true`, `getTiedOperand` names which one.
"""
function hasTiedOperand(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_hasTiedOperand(x)
end

"""
    getTiedOperand(x::AbstractConstraintInfo) -> Cuint
Return the index of the output operand this input operand is tied to.

Precondition: `hasTiedOperand(x)` — Clang asserts otherwise.
"""
function getTiedOperand(x::AbstractConstraintInfo)
    @check_ptrs x
    @assert hasTiedOperand(x) "constraint has no tied operand"
    return clang_ConstraintInfo_getTiedOperand(x)
end

"""
    requiresImmediateConstant(x::AbstractConstraintInfo) -> Bool
Whether the operand described by `x` must be an immediate constant.
"""
function requiresImmediateConstant(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_requiresImmediateConstant(x)
end

"""
    isValidAsmImmediate(x::AbstractConstraintInfo, value::Integer) -> Bool
Whether `value` satisfies the immediate-constant constraint recorded on `x`.

A `ConstraintInfo` that records no immediate range accepts every value, so this is `true`
until [`setRequiresImmediate`](@ref) narrows it. The bounds a `ConstraintInfo` can hold are
C `int`s, so no `value` is ever too wide to compare against them.
"""
function isValidAsmImmediate(x::AbstractConstraintInfo, value::Integer)
    @check_ptrs x
    return clang_ConstraintInfo_isValidAsmImmediate(x, value)
end

"""
    setIsReadWrite(x::AbstractConstraintInfo)
Mark `x` as a read-write (`"+"`) output constraint.
"""
function setIsReadWrite(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_setIsReadWrite(x)
end

"""
    setEarlyClobber(x::AbstractConstraintInfo)
Mark `x` as an early-clobber (`"&"`) output constraint.
"""
function setEarlyClobber(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_setEarlyClobber(x)
end

"""
    setAllowsMemory(x::AbstractConstraintInfo)
Mark the operand described by `x` as allowed to live in memory.
"""
function setAllowsMemory(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_setAllowsMemory(x)
end

"""
    setAllowsRegister(x::AbstractConstraintInfo)
Mark the operand described by `x` as allowed to live in a register.
"""
function setAllowsRegister(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_setAllowsRegister(x)
end

"""
    setHasMatchingInput(x::AbstractConstraintInfo)
Mark this output operand as having a matching (tied) input operand.
"""
function setHasMatchingInput(x::AbstractConstraintInfo)
    @check_ptrs x
    return clang_ConstraintInfo_setHasMatchingInput(x)
end

"""
    setRequiresImmediate(x::AbstractConstraintInfo, min::Integer, max::Integer)
Require the operand described by `x` to be an immediate constant in the inclusive range
`min:max`.
"""
function setRequiresImmediate(x::AbstractConstraintInfo, min::Integer, max::Integer)
    @check_ptrs x
    return clang_ConstraintInfo_setRequiresImmediate(x, min, max)
end

"""
    setTiedOperand(x::AbstractConstraintInfo, n::Integer, output::AbstractConstraintInfo)
Tie the input operand `x` to output operand number `n`, described by `output`: `output` is
marked as having a matching input and its flags are copied into `x`. The constraint string
and name of `x` are left alone.
"""
function setTiedOperand(x::AbstractConstraintInfo, n::Integer, output::AbstractConstraintInfo)
    @check_ptrs x output
    return clang_ConstraintInfo_setTiedOperand(x, n, output)
end

"""
    validateGlobalRegisterVariable(x::AbstractTargetInfo, reg_name::AbstractString,
                                   reg_size::Integer) -> Union{Bool,Nothing}
Whether `reg_name` may back a global register variable (`register long x asm("rsp")`) of
`reg_size` bits on this target: `nothing` when the register cannot back one at all,
otherwise whether the register's own width differs from `reg_size`.

This asks a different question from [`isValidGCCRegisterName`](@ref) -- x86 accepts every
GCC register name there but only a subset here, and reports the width mismatch separately.
Total for any string, the empty one included.
"""
function validateGlobalRegisterVariable(x::AbstractTargetInfo, reg_name::AbstractString, reg_size::Integer)
    @check_ptrs x
    mismatch = Ref{Bool}(false)
    ok = clang_TargetInfo_validateGlobalRegisterVariable(x, reg_name, reg_size, mismatch)
    return ok ? mismatch[] : nothing
end

"""
    validateOutputConstraint(x::AbstractTargetInfo, info::AbstractConstraintInfo) -> Bool
Parse `info`'s constraint string as an inline-asm *output* constraint for target `x`,
returning `false` when it is not a valid one (an output constraint must start with `=` or
`+`). On success the flags of `info` are updated in place — `isReadWrite`, `earlyClobber`,
`allowsRegister`, `allowsMemory` and `requiresImmediateConstant` only become meaningful
after this call.
"""
function validateOutputConstraint(x::AbstractTargetInfo, info::AbstractConstraintInfo)
    @check_ptrs x info
    return clang_TargetInfo_validateOutputConstraint(x, info)
end

"""
    allowHalfArgsAndReturns(x::AbstractTargetInfo) -> Bool
Whether half-precision floating point may be used as a function argument or return type on
this target.
"""
function allowHalfArgsAndReturns(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_allowHalfArgsAndReturns(x)
end

"""
    supportSourceEvalMethod(x::AbstractTargetInfo) -> Bool
Whether this target supports the `source` floating-point evaluation method.
"""
function supportSourceEvalMethod(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_supportSourceEvalMethod(x)
end

"""
    getMaxOpenCLWorkGroupSize(x::AbstractTargetInfo) -> Cuint
Return the largest OpenCL work-group size this target accepts, in work-items.
"""
function getMaxOpenCLWorkGroupSize(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getMaxOpenCLWorkGroupSize(x)
end

"""
    useObjCFPRetForRealType(x::AbstractTargetInfo, t::CXFloatModeKind) -> Bool
Whether the real floating-point type `t` uses the `fpret` flavour of Objective-C message
passing on this target.

The mask this reads is set by the target's own constructor whether or not Objective-C is
being compiled, so the answer is a plain ABI fact about the triple. It is a bitmask test and
is total for every enumerator, `CXFloatModeKind_NoFloat` included.
"""
function useObjCFPRetForRealType(x::AbstractTargetInfo, t::CXFloatModeKind)
    @check_ptrs x
    return clang_TargetInfo_useObjCFPRetForRealType(x, t)
end

"""
    useObjCFP2RetForComplexLongDouble(x::AbstractTargetInfo) -> Bool
Whether `_Complex long double` uses the `fp2ret` flavour of Objective-C message passing on
this target.
"""
function useObjCFP2RetForComplexLongDouble(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_useObjCFP2RetForComplexLongDouble(x)
end

"""
    isRenderScriptTarget(x::AbstractTargetInfo) -> Bool
Whether this target is a RenderScript one.
"""
function isRenderScriptTarget(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_isRenderScriptTarget(x)
end

"""
    allowAMDGPUUnsafeFPAtomics(x::AbstractTargetInfo) -> Bool
Whether unsafe AMDGPU floating-point atomics are allowed on this target.
"""
function allowAMDGPUUnsafeFPAtomics(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_allowAMDGPUUnsafeFPAtomics(x)
end

"""
    hasPS4DLLImportExport(x::AbstractTargetInfo) -> Bool
Whether this target uses the PS4 flavour of `dllimport`/`dllexport` handling.
"""
function hasPS4DLLImportExport(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasPS4DLLImportExport(x)
end

"""
    adjust(x::AbstractTargetInfo, diag::DiagnosticsEngine, lo::LangOptions)
Apply the language options `lo` to the target `x` and, in the other direction, let the target
force language options back into `lo`, reporting any conflict through `diag`. Both `x` and
`lo` are mutated.

This is the only call that makes the `LangOptions`-dependent target properties reflect the
language options at all: plain `char` signedness under `-fno-signed-char`, `getWCharType`
under `-fshort-wchar`, `allowHalfArgsAndReturns`, `getFPEvalMethod`, and the long-double
format under `-mlong-double-64`. Clang runs it exactly once, between building a target and
its first use; `createTarget` and `setTargetAndLangOpts` already do so for the target they
build, so this is for a [`TargetInfo`](@ref) constructed directly. It is idempotent in the
fields it sets, but not in its diagnostics -- a second call re-emits them.
"""
function adjust(x::AbstractTargetInfo, diag::DiagnosticsEngine, lo::LangOptions)
    @check_ptrs x diag lo
    clang_TargetInfo_adjust(x, diag, lo)
    return nothing
end

"""
    supportsTargetAttributeTune(x::AbstractTargetInfo) -> Bool
Whether this target supports `tune=` inside `__attribute__((target(...)))`.
"""
function supportsTargetAttributeTune(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_supportsTargetAttributeTune(x)
end

"""
    doesFeatureAffectCodeGen(x::AbstractTargetInfo, feature::AbstractString) -> Bool
Whether `feature` has an impact on code generation for this target.
"""
function doesFeatureAffectCodeGen(x::AbstractTargetInfo, feature::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_doesFeatureAffectCodeGen(x, feature)
end

"""
    getFeatureDependencies(x::AbstractTargetInfo, feature::AbstractString) -> String
Return the features `feature` depends on for this target, or the empty string when it has
none — which is also what every target that does not model feature dependencies returns.
"""
function getFeatureDependencies(x::AbstractTargetInfo, feature::AbstractString)
    @check_ptrs x
    return get_string(clang_TargetInfo_getFeatureDependencies(x, feature))
end

"""
    isBranchProtectionSupportedArch(x::AbstractTargetInfo, arch::AbstractString) -> Bool
Whether the architecture `arch` supports branch protection on this target.
"""
function isBranchProtectionSupportedArch(x::AbstractTargetInfo, arch::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isBranchProtectionSupportedArch(x, arch)
end

"""
    isReadOnlyFeature(x::AbstractTargetInfo, feature::AbstractString) -> Bool
Whether `feature` is read-only on this target, i.e. it cannot be toggled through
`__attribute__((target(...)))`.
"""
function isReadOnlyFeature(x::AbstractTargetInfo, feature::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_isReadOnlyFeature(x, feature)
end

"""
    validateCpuSupports(x::AbstractTargetInfo, name::AbstractString) -> Bool
Whether `name` is a valid argument to `__builtin_cpu_supports` on this target.
"""
function validateCpuSupports(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_validateCpuSupports(x, name)
end

"""
    multiVersionSortPriority(x::AbstractTargetInfo, name::AbstractString) -> Cuint
Return the target-specific priority of the CPU or feature `name`, used to order function
multiversioning resolvers.

On a target that supports multiversioning, `name` must be one that target has already
accepted: the x86 implementation looks `name` up in a priority table and reads past its end
for an unknown one. Targets without multiversioning support run the total base
implementation and are exempt from the check.
"""
function multiVersionSortPriority(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    known = isValidCPUName(x, name) || validateCpuSupports(x, name)
    @assert !supportsMultiVersioning(x) || known "`name` must be a CPU or feature this target knows"
    return clang_TargetInfo_multiVersionSortPriority(x, name)
end

"""
    multiVersionFeatureCost(x::AbstractTargetInfo) -> Cuint
Return the target-specific cost a feature adds when sorting multiversioning resolvers.
"""
function multiVersionFeatureCost(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_multiVersionFeatureCost(x)
end

"""
    validateCpuIs(x::AbstractTargetInfo, name::AbstractString) -> Bool
Whether `name` is a valid argument to `__builtin_cpu_is` on this target.
"""
function validateCpuIs(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_validateCpuIs(x, name)
end

"""
    validateCPUSpecificCPUDispatch(x::AbstractTargetInfo, name::AbstractString) -> Bool
Whether `name` is a valid CPU for the `cpu_specific`/`cpu_dispatch` attributes on this
target. That list is checked through features, so it differs from the one `validateCpuIs`
accepts.
"""
function validateCPUSpecificCPUDispatch(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    return clang_TargetInfo_validateCPUSpecificCPUDispatch(x, name)
end

"""
    supportsExtendIntArgs(x::AbstractTargetInfo) -> Bool
Whether `-fextend-arguments={32,64}` is supported on this target.
"""
function supportsExtendIntArgs(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_supportsExtendIntArgs(x)
end

"""
    checkArithmeticFenceSupported(x::AbstractTargetInfo) -> Bool
Whether `__arithmetic_fence` is supported by this target's backend.
"""
function checkArithmeticFenceSupported(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_checkArithmeticFenceSupported(x)
end

"""
    allowDebugInfoForExternalRef(x::AbstractTargetInfo) -> Bool
Whether this target allows debug-info types for declaration-only variables and functions.
"""
function allowDebugInfoForExternalRef(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_allowDebugInfoForExternalRef(x)
end

"""
    getOpenCLBuiltinAddressSpace(x::AbstractTargetInfo, addr_space::Integer) -> CXLangAS
Map `addr_space` -- an address-space field taken from an OpenCL builtin description string
-- to the language address space it names.
"""
function getOpenCLBuiltinAddressSpace(x::AbstractTargetInfo, addr_space::Integer)
    @check_ptrs x
    return clang_TargetInfo_getOpenCLBuiltinAddressSpace(x, addr_space)
end

"""
    getCUDABuiltinAddressSpace(x::AbstractTargetInfo, addr_space::Integer) -> CXLangAS
Map `addr_space` -- an address-space field taken from a CUDA builtin description string --
to the language address space it names.
"""
function getCUDABuiltinAddressSpace(x::AbstractTargetInfo, addr_space::Integer)
    @check_ptrs x
    return clang_TargetInfo_getCUDABuiltinAddressSpace(x, addr_space)
end

"""
    getConstantAddressSpace(x::AbstractTargetInfo) -> Union{CXLangAS,Nothing}
Return an address space that may be used opportunistically for constant global memory, or
`nothing` when the target names none (the C++ optional is disengaged).
"""
function getConstantAddressSpace(x::AbstractTargetInfo)
    @check_ptrs x
    as = Ref{CXLangAS}(CXLangAS_Default)
    return clang_TargetInfo_getConstantAddressSpace(x, as) ? as[] : nothing
end

"""
    getPlatformMinVersion(x::AbstractTargetInfo) -> String
Return the minimum platform version the program should be compiled for -- the version the
`availability` attribute is checked against -- in `llvm::VersionTuple`'s printed form
(`"0"` when the target names no minimum).
"""
function getPlatformMinVersion(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getPlatformMinVersion(x))
end

"""
    getDefaultCallingConv(x::AbstractTargetInfo) -> CXCallingConv_
Return the calling convention this target uses when a declaration names none.
"""
function getDefaultCallingConv(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getDefaultCallingConv(x)
end

"""
    checkCallingConvention(x::AbstractTargetInfo, cc::CXCallingConv_) -> CXTargetInfo_CallingConvCheckResult
Report whether `cc` is valid for this target: accepted, warned about and substituted with
the default convention, ignored, or rejected.
"""
function checkCallingConvention(x::AbstractTargetInfo, cc::CXCallingConv_)
    @check_ptrs x
    return clang_TargetInfo_checkCallingConvention(x, cc)
end

"""
    getCallingConvKind(x::AbstractTargetInfo, clang_abi_compat4::Bool) -> CXTargetInfo_CallingConvKind
Return the calling-convention family this target's ABI belongs to. `clang_abi_compat4`
requests the Clang 4 compatibility behaviour (`-fclang-abi-compat=4`).
"""
function getCallingConvKind(x::AbstractTargetInfo, clang_abi_compat4::Bool)
    @check_ptrs x
    return clang_TargetInfo_getCallingConvKind(x, clang_abi_compat4)
end

"""
    areDefaultedSMFStillPOD(x::AbstractTargetInfo, lo::LangOptions) -> Bool
Return whether explicitly defaulted special member functions still leave a class POD for
layout purposes, under the Clang ABI compatibility level `lo` requests.
"""
function areDefaultedSMFStillPOD(x::AbstractTargetInfo, lo::LangOptions)
    @check_ptrs x lo
    return clang_TargetInfo_areDefaultedSMFStillPOD(x, lo)
end

"""
    getOpenCLTypeAddrSpace(x::AbstractTargetInfo, tk::CXOpenCLTypeKind) -> CXLangAS
Return the address space this target assigns to the OpenCL type family `tk`.
"""
function getOpenCLTypeAddrSpace(x::AbstractTargetInfo, tk::CXOpenCLTypeKind)
    @check_ptrs x
    return clang_TargetInfo_getOpenCLTypeAddrSpace(x, tk)
end

"""
    getDWARFAddressSpace(x::AbstractTargetInfo, addr_space::Integer) -> Union{Cuint,Nothing}
Return the DWARF address space `addr_space` must be converted to before use, or `nothing`
when the target needs no conversion (the C++ optional is disengaged).
"""
function getDWARFAddressSpace(x::AbstractTargetInfo, addr_space::Integer)
    @check_ptrs x
    out = Ref{Cuint}(0)
    return clang_TargetInfo_getDWARFAddressSpace(x, addr_space, out) ? out[] : nothing
end

"""
    getSDKVersion(x::AbstractTargetInfo) -> String
Return the SDK version recorded in the target options, in `llvm::VersionTuple`'s printed
form (`"0"` when none was specified).
"""
function getSDKVersion(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getSDKVersion(x))
end

"""
    validateTarget(x::AbstractTargetInfo, diag::DiagnosticsEngine) -> Bool
Return whether the fully-initialized target is valid, reporting the reason through `diag`
when it is not.
"""
function validateTarget(x::AbstractTargetInfo, diag::DiagnosticsEngine)
    @check_ptrs x diag
    return clang_TargetInfo_validateTarget(x, diag)
end

"""
    getDarwinTargetVariantTriple(x::AbstractTargetInfo) -> Union{String,Nothing}
Return the Darwin target-variant triple string -- the variant of the deployment target the
code is being compiled for -- or `nothing` when the target names no variant.
"""
function getDarwinTargetVariantTriple(x::AbstractTargetInfo)
    @check_ptrs x
    ptr = clang_TargetInfo_getDarwinTargetVariantTriple(x)
    return ptr == C_NULL ? nothing : unsafe_string(ptr)
end

"""
    hasHIPImageSupport(x::AbstractTargetInfo) -> Bool
Return whether the target supports the HIP image/texture APIs.
"""
function hasHIPImageSupport(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_hasHIPImageSupport(x)
end

"""
    fillValidTuneCPUList(x::AbstractTargetInfo) -> Vector{String}
Return the valid CPU names for tuning this target (the valid values for `-tune-cpu`).
Targets that do not model separate tune CPUs return the `fillValidCPUList` result.
"""
function fillValidTuneCPUList(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_fillValidTuneCPUList(x))
end

"""
    CPUSpecificManglingCharacter(x::AbstractTargetInfo, name::AbstractString) -> Cchar
Return the character `cpu_specific` multiversioning appends to the mangled name of the
variant compiled for CPU `name`.

Precondition: `validateCPUSpecificCPUDispatch(x, name)`. `TargetInfo`'s own implementation
is an `llvm_unreachable`, so a target that does not implement `cpu_specific`
multiversioning aborts instead of returning.
"""
function CPUSpecificManglingCharacter(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    @assert validateCPUSpecificCPUDispatch(x, name) "target rejects this cpu_specific CPU name"
    return clang_TargetInfo_CPUSpecificManglingCharacter(x, name)
end

"""
    getCPUSpecificCPUDispatchFeatures(x::AbstractTargetInfo,
                                      name::AbstractString) -> Vector{String}
Return the target features the `cpu_specific`/`cpu_dispatch` CPU option `name` turns on --
the answer to why one multiversioned variant differs from another.

Precondition: `validateCPUSpecificCPUDispatch(x, name)`. `TargetInfo`'s own implementation
is an `llvm_unreachable`, so a target that does not implement `cpu_specific` multiversioning
aborts instead of returning. An empty result is a valid answer, not a failure: the gate also
accepts the alias CPU names, which carry no features of their own.
"""
function getCPUSpecificCPUDispatchFeatures(x::AbstractTargetInfo, name::AbstractString)
    @check_ptrs x
    @assert validateCPUSpecificCPUDispatch(x, name) "target rejects this cpu_specific CPU name"
    return get_string(clang_TargetInfo_getCPUSpecificCPUDispatchFeatures(x, name))
end

"""
    getTargetID(x::AbstractTargetInfo) -> String
Return the target ID (the AMDGPU `processor:feature` form), or the empty string when the
target exposes none -- the disengaged C++ optional and an engaged empty string are
conflated.
"""
function getTargetID(x::AbstractTargetInfo)
    @check_ptrs x
    return get_string(clang_TargetInfo_getTargetID(x))
end

# The fixed-point types (`_Accum`, `_Fract`, and their short/long/unsigned spellings). Every
# value below is chosen by the target, so tests must assert their shape and their algebraic
# relationships -- never a particular number.

"""
    getAccumAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `_Accum`.
"""
function getAccumAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getAccumAlign(x)
end

"""
    getAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `_Accum`.
"""
function getAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getAccumIBits(x)
end

"""
    getAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `_Accum`.
"""
function getAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getAccumScale(x)
end

"""
    getAccumWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `_Accum`.
"""
function getAccumWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getAccumWidth(x)
end

"""
    getFractAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `_Fract`.
"""
function getFractAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getFractAlign(x)
end

"""
    getFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `_Fract`.
"""
function getFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getFractScale(x)
end

"""
    getFractWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `_Fract`.
"""
function getFractWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getFractWidth(x)
end

"""
    getLongAccumAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `long _Accum`.
"""
function getLongAccumAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongAccumAlign(x)
end

"""
    getLongAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `long _Accum`.
"""
function getLongAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongAccumIBits(x)
end

"""
    getLongAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `long _Accum`.
"""
function getLongAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongAccumScale(x)
end

"""
    getLongAccumWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `long _Accum`.
"""
function getLongAccumWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongAccumWidth(x)
end

"""
    getLongFractAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `long _Fract`.
"""
function getLongFractAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongFractAlign(x)
end

"""
    getLongFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `long _Fract`.
"""
function getLongFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongFractScale(x)
end

"""
    getLongFractWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `long _Fract`.
"""
function getLongFractWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getLongFractWidth(x)
end

"""
    getShortAccumAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `short _Accum`.
"""
function getShortAccumAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortAccumAlign(x)
end

"""
    getShortAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `short _Accum`.
"""
function getShortAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortAccumIBits(x)
end

"""
    getShortAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `short _Accum`.
"""
function getShortAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortAccumScale(x)
end

"""
    getShortAccumWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `short _Accum`.
"""
function getShortAccumWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortAccumWidth(x)
end

"""
    getShortFractAlign(x::AbstractTargetInfo) -> Int
Return the ABI alignment, in bits, of `short _Fract`.
"""
function getShortFractAlign(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortFractAlign(x)
end

"""
    getShortFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `short _Fract`.
"""
function getShortFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortFractScale(x)
end

"""
    getShortFractWidth(x::AbstractTargetInfo) -> Int
Return the bit width of `short _Fract`.
"""
function getShortFractWidth(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getShortFractWidth(x)
end

"""
    getUnsignedAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `unsigned _Accum`.
"""
function getUnsignedAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedAccumIBits(x)
end

"""
    getUnsignedAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned _Accum`.
"""
function getUnsignedAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedAccumScale(x)
end

"""
    getUnsignedFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned _Fract`.
"""
function getUnsignedFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedFractScale(x)
end

"""
    getUnsignedLongAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `unsigned long _Accum`.
"""
function getUnsignedLongAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedLongAccumIBits(x)
end

"""
    getUnsignedLongAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned long _Accum`.
"""
function getUnsignedLongAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedLongAccumScale(x)
end

"""
    getUnsignedLongFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned long _Fract`.
"""
function getUnsignedLongFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedLongFractScale(x)
end

"""
    getUnsignedShortAccumIBits(x::AbstractTargetInfo) -> Int
Return the number of integral bits in `unsigned short _Accum`.
"""
function getUnsignedShortAccumIBits(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedShortAccumIBits(x)
end

"""
    getUnsignedShortAccumScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned short _Accum`.
"""
function getUnsignedShortAccumScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedShortAccumScale(x)
end

"""
    getUnsignedShortFractScale(x::AbstractTargetInfo) -> Int
Return the number of fractional bits in `unsigned short _Fract`.
"""
function getUnsignedShortFractScale(x::AbstractTargetInfo)::Int
    @check_ptrs x
    return clang_TargetInfo_getUnsignedShortFractScale(x)
end

"""
    doUnsignedFixedPointTypesHavePadding(x::AbstractTargetInfo) -> Bool
Return whether the unsigned fixed-point types spend a bit on padding so that they keep the
same scale as their signed counterparts.
"""
function doUnsignedFixedPointTypesHavePadding(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_doUnsignedFixedPointTypesHavePadding(x)
end

"""
    getFPEvalMethod(x::AbstractTargetInfo) -> CXFPEvalMethodKind
Return the floating-point evaluation method the target's default excess precision implies.
"""
function getFPEvalMethod(x::AbstractTargetInfo)
    @check_ptrs x
    return clang_TargetInfo_getFPEvalMethod(x)
end

"""
    getRealTypeByWidth(x::AbstractTargetInfo, bit_width::Integer,
                       explicit_type::CXFloatModeKind) -> CXFloatModeKind
Return the real floating-point type of the given bit width, or `CXFloatModeKind_NoFloat`
when the target has none. `explicit_type` selects between the `float` and `__bf16`
spellings at 16 bits.
"""
function getRealTypeByWidth(x::AbstractTargetInfo, bit_width::Integer, explicit_type::CXFloatModeKind)
    @check_ptrs x
    return clang_TargetInfo_getRealTypeByWidth(x, bit_width, explicit_type)
end
