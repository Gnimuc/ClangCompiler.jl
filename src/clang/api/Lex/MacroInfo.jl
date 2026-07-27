# MacroInfo
function getDefinitionLoc(x::AbstractMacroInfo)
    @check_ptrs x
    return SourceLocation(clang_MacroInfo_getDefinitionLoc(x))
end

function getDefinitionEndLoc(x::AbstractMacroInfo)
    @check_ptrs x
    return SourceLocation(clang_MacroInfo_getDefinitionEndLoc(x))
end

function getDefinitionLength(x::AbstractMacroInfo, src_mgr::AbstractSourceManager)
    @check_ptrs x src_mgr
    return clang_MacroInfo_getDefinitionLength(x, src_mgr)
end

function isIdenticalTo(x::AbstractMacroInfo, other::AbstractMacroInfo,
                       pp::AbstractPreprocessor, syntactically::Bool)
    @check_ptrs x other pp
    return clang_MacroInfo_isIdenticalTo(x, other, pp, syntactically)
end

function param_empty(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_param_empty(x)
end

function getNumParams(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_getNumParams(x)
end

function getParam(x::AbstractMacroInfo, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumParams(x) "parameter index out of bounds"
    return IdentifierInfo(clang_MacroInfo_getParam(x, i))
end

function getParameterNum(x::AbstractMacroInfo, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_MacroInfo_getParameterNum(x, ii)
end

function isFunctionLike(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isFunctionLike(x)
end

function isObjectLike(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isObjectLike(x)
end

function isC99Varargs(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isC99Varargs(x)
end

function isGNUVarargs(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isGNUVarargs(x)
end

function isVariadic(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isVariadic(x)
end

function isBuiltinMacro(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isBuiltinMacro(x)
end

function hasCommaPasting(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_hasCommaPasting(x)
end

function isUsed(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isUsed(x)
end

function isAllowRedefinitionsWithoutWarning(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isAllowRedefinitionsWithoutWarning(x)
end

function isWarnIfUnused(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isWarnIfUnused(x)
end

function getNumTokens(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_getNumTokens(x)
end

function getReplacementToken(x::AbstractMacroInfo, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumTokens(x) "replacement-token index out of bounds"
    return Token(clang_MacroInfo_getReplacementToken(x, i))
end

function isEnabled(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isEnabled(x)
end

function isUsedForHeaderGuard(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_isUsedForHeaderGuard(x)
end

function dump(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_dump(x)
end
