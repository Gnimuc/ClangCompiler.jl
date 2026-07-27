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
