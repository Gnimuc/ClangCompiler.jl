function PrintStats(x::IdentifierTable)
    @check_ptrs x
    return clang_IdentifierTable_PrintStats(x)
end

function Base.get(x::IdentifierTable, s::String)
    @check_ptrs x
    return IdentifierInfo(clang_IdentifierTable_get(x, s))
end

function getName(x::IdentifierInfo)
    @check_ptrs x
    return unsafe_string(clang_IdentifierInfo_getName(x))
end


"""
    IdentifierTable(langopts::AbstractLangOptions) -> IdentifierTable
Create an identifier table populated with info about the language keywords for `langopts`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function IdentifierTable(langopts::AbstractLangOptions)
    @check_ptrs langopts
    ptr = clang_IdentifierTable_create(langopts)
    @assert ptr != C_NULL "Failed to create IdentifierTable"
    return IdentifierTable(ptr)
end

dispose(x::IdentifierTable) = clang_IdentifierTable_dispose(x)

function Base.size(x::AbstractIdentifierTable)
    @check_ptrs x
    return Int(clang_IdentifierTable_size(x))
end

"""
    Base.contains(x::AbstractIdentifierTable, name::AbstractString) -> Bool
Return true if `name` is already interned in the table, without inserting it.
"""
function Base.contains(x::AbstractIdentifierTable, name::AbstractString)
    @check_ptrs x
    return clang_IdentifierTable_contains(x, name)
end

function AddKeywords(x::AbstractIdentifierTable, langopts::AbstractLangOptions)
    @check_ptrs x langopts
    return clang_IdentifierTable_AddKeywords(x, langopts)
end

function isStr(x::AbstractIdentifierInfo, s::AbstractString)
    @check_ptrs x
    return clang_IdentifierInfo_isStr(x, s)
end

function getLength(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getLength(x))
end

function hasMacroDefinition(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_hasMacroDefinition(x)
end

function hadMacroDefinition(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_hadMacroDefinition(x)
end

function isDeprecatedMacro(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isDeprecatedMacro(x)
end

function isFinal(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isFinal(x)
end

"""
    getTokenID(x::AbstractIdentifierInfo) -> Int
Return the raw `clang::tok::TokenKind` value for this identifier; query it with the
TokenKinds helpers (`getTokenName`, `isAnyIdentifier`, ...).
"""
function getTokenID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getTokenID(x))
end

function getPPKeywordID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_getPPKeywordID(x)
end

function getBuiltinID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getBuiltinID(x))
end

function isExtensionToken(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isExtensionToken(x)
end

function isFutureCompatKeyword(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isFutureCompatKeyword(x)
end

function setIsPoisoned(x::AbstractIdentifierInfo, val::Bool=true)
    @check_ptrs x
    return clang_IdentifierInfo_setIsPoisoned(x, val)
end

function isPoisoned(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isPoisoned(x)
end

function isCPlusPlusOperatorKeyword(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isCPlusPlusOperatorKeyword(x)
end

function isKeyword(x::AbstractIdentifierInfo, langopts::AbstractLangOptions)
    @check_ptrs x langopts
    return clang_IdentifierInfo_isKeyword(x, langopts)
end

function isCPlusPlusKeyword(x::AbstractIdentifierInfo, langopts::AbstractLangOptions)
    @check_ptrs x langopts
    return clang_IdentifierInfo_isCPlusPlusKeyword(x, langopts)
end

function isEditorPlaceholder(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isEditorPlaceholder(x)
end

function isReserved(x::AbstractIdentifierInfo, langopts::AbstractLangOptions)
    @check_ptrs x langopts
    return clang_IdentifierInfo_isReserved(x, langopts)
end

function isReservedLiteralSuffixId(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isReservedLiteralSuffixId(x)
end

"""
    deuglifiedName(x::AbstractIdentifierInfo) -> String
If the identifier is an "uglified" reserved name (e.g. `_Foo`), return the cleaned form
(`Foo`); otherwise return the name unchanged.
"""
function deuglifiedName(x::AbstractIdentifierInfo)
    @check_ptrs x
    return get_string(clang_IdentifierInfo_deuglifiedName(x))
end

function isPlaceholder(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isPlaceholder(x)
end
