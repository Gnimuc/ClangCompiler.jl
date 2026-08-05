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

"""
    getNameStart(x::AbstractIdentifierInfo) -> String
Return the identifier's name read straight from its interned, NUL-terminated storage.
"""
function getNameStart(x::AbstractIdentifierInfo)
    @check_ptrs x
    return unsafe_string(clang_IdentifierInfo_getNameStart(x))
end

"""
    setHasMacroDefinition(x::AbstractIdentifierInfo, val::Bool)
Mark the identifier as currently `#define`d. Setting `true` also latches
`hadMacroDefinition`; setting `false` clears `isDeprecatedMacro`/`isRestrictExpansion`
unless the identifier is final.
"""
function setHasMacroDefinition(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setHasMacroDefinition(x, val)
end

function setIsDeprecatedMacro(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setIsDeprecatedMacro(x, val)
end

function isRestrictExpansion(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isRestrictExpansion(x)
end

function setIsRestrictExpansion(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setIsRestrictExpansion(x, val)
end

function setIsFinal(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setIsFinal(x, val)
end

function hasRevertedTokenIDToIdentifier(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_hasRevertedTokenIDToIdentifier(x)
end

"""
    getObjCKeywordID(x::AbstractIdentifierInfo) -> Int
Return the raw `clang::tok::ObjCKeywordKind` value for this identifier; `0` is
`tok::objc_not_keyword`.
"""
function getObjCKeywordID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getObjCKeywordID(x))
end

"""
    getInterestingIdentifierID(x::AbstractIdentifierInfo) -> Int
Return the raw `clang::tok::InterestingIdentifierKind` value for this identifier; `0` is
`tok::not_interesting`.
"""
function getInterestingIdentifierID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getInterestingIdentifierID(x))
end

"""
    getObjCOrBuiltinID(x::AbstractIdentifierInfo) -> Int
Return the packed field backing `getObjCKeywordID`, `getInterestingIdentifierID` and
`getBuiltinID`; `0` means the identifier is none of them.
"""
function getObjCOrBuiltinID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return Int(clang_IdentifierInfo_getObjCOrBuiltinID(x))
end

function setIsExtensionToken(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setIsExtensionToken(x, val)
end

function setIsFutureCompatKeyword(x::AbstractIdentifierInfo, val::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setIsFutureCompatKeyword(x, val)
end

function setIsCPlusPlusOperatorKeyword(x::AbstractIdentifierInfo, val::Bool=true)
    @check_ptrs x
    return clang_IdentifierInfo_setIsCPlusPlusOperatorKeyword(x, val)
end

"""
    isHandleIdentifierCase(x::AbstractIdentifierInfo) -> Bool
Return `true` if `Preprocessor::HandleIdentifier` must run on tokens of this identifier.
It is the disjunction of `isPoisoned`, `hasMacroDefinition`, `isExtensionToken`,
`isFutureCompatKeyword`, `isOutOfDate` and `isModulesImport`.
"""
function isHandleIdentifierCase(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isHandleIdentifierCase(x)
end

function isFromAST(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isFromAST(x)
end

function hasChangedSinceDeserialization(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_hasChangedSinceDeserialization(x)
end

function isOutOfDate(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isOutOfDate(x)
end

function setOutOfDate(x::AbstractIdentifierInfo, ood::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setOutOfDate(x, ood)
end

function isModulesImport(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isModulesImport(x)
end

function setModulesImport(x::AbstractIdentifierInfo, i::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setModulesImport(x, i)
end

"""
    revertTokenIDToIdentifier(x::AbstractIdentifierInfo)
Map this identifier's front-end token ID back to `tok::identifier` — the libstdc++ 4.2
compatibility hook — and record the reversion so `hasRevertedTokenIDToIdentifier` reports
it.

The Clang method only asserts that the identifier is not already `tok::identifier`, so
that precondition is restated here.
"""
function revertTokenIDToIdentifier(x::AbstractIdentifierInfo)
    @check_ptrs x
    @assert getTokenName(getTokenID(x)) != "identifier" "identifier is already tok::identifier"
    return clang_IdentifierInfo_revertTokenIDToIdentifier(x)
end

"""
    revertIdentifierToTokenID(x::AbstractIdentifierInfo, kind::Integer)
Give this identifier back the front-end token ID `kind` (a raw `clang::tok::TokenKind`
value, such as one previously read with [`getTokenID`](@ref)) and clear the reversion
flag.

The Clang method only asserts that the identifier currently is `tok::identifier`, so that
precondition is restated here.
"""
function revertIdentifierToTokenID(x::AbstractIdentifierInfo, kind::Integer)
    @check_ptrs x
    @assert getTokenName(getTokenID(x)) == "identifier" "identifier must be tok::identifier"
    return clang_IdentifierInfo_revertIdentifierToTokenID(x, kind)
end

"""
    setObjCKeywordID(x::AbstractIdentifierInfo, id::Integer)
Set the Objective-C keyword ID (a raw `clang::tok::ObjCKeywordKind` value). This
overwrites the whole packed `ObjCOrBuiltinID` field, so it also clears any builtin or
interesting-identifier ID the identifier carried.
"""
function setObjCKeywordID(x::AbstractIdentifierInfo, id::Integer)
    @check_ptrs x
    return clang_IdentifierInfo_setObjCKeywordID(x, id)
end

"""
    setBuiltinID(x::AbstractIdentifierInfo, id::Integer)
Mark this identifier as builtin function number `id` (1-based; 0 means "not a builtin"
and is rejected — use [`clearBuiltinID`](@ref) for that).

`id` must fit the packed `ObjCOrBuiltinID` field, i.e. `1 <= id <= getMaxBuiltinID()`.
Clang only asserts those bounds, so both are restated here.
"""
function setBuiltinID(x::AbstractIdentifierInfo, id::Integer)
    @check_ptrs x
    @assert 1 <= id <= getMaxBuiltinID() "builtin ID does not fit the packed field"
    return clang_IdentifierInfo_setBuiltinID(x, id)
end

"""
    getMaxBuiltinID() -> UInt32
Return the largest builtin ID the packed `clang::IdentifierInfo::ObjCOrBuiltinID` field
can round-trip, i.e. the upper bound [`setBuiltinID`](@ref) accepts.
"""
getMaxBuiltinID() = clang_IdentifierInfo_getMaxBuiltinID()

"""
    clearBuiltinID(x::AbstractIdentifierInfo)
Zero the packed `ObjCOrBuiltinID` field, leaving the identifier neither a builtin, nor an
Objective-C keyword, nor an interesting identifier.
"""
function clearBuiltinID(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_clearBuiltinID(x)
end

"""
    setInterestingIdentifierID(x::AbstractIdentifierInfo, id::Integer)
Mark this identifier with the `clang::tok::InterestingIdentifierKind` `id` (1-based; 0 is
`tok::not_interesting` and is rejected).

`id` must lie inside that kind's region of the packed field, i.e.
`1 <= id <= getMaxInterestingIdentifierID()`. Clang only asserts those bounds, so both
are restated here.
"""
function setInterestingIdentifierID(x::AbstractIdentifierInfo, id::Integer)
    @check_ptrs x
    @assert 1 <= id <= getMaxInterestingIdentifierID() "interesting-identifier ID out of range"
    return clang_IdentifierInfo_setInterestingIdentifierID(x, id)
end

"""
    getMaxInterestingIdentifierID() -> UInt32
Return the largest `clang::tok::InterestingIdentifierKind` value, i.e. the upper bound
[`setInterestingIdentifierID`](@ref) accepts.
"""
getMaxInterestingIdentifierID() = clang_IdentifierInfo_getMaxInterestingIdentifierID()

"""
    setObjCOrBuiltinID(x::AbstractIdentifierInfo, id::Integer)
Write the packed field that backs [`setObjCKeywordID`](@ref),
[`setInterestingIdentifierID`](@ref) and [`setBuiltinID`](@ref) directly. Prefer those
three setters: they encode the field's three-region layout, this one does not.
"""
function setObjCOrBuiltinID(x::AbstractIdentifierInfo, id::Integer)
    @check_ptrs x
    return clang_IdentifierInfo_setObjCOrBuiltinID(x, id)
end

"""
    setIsFromAST(x::AbstractIdentifierInfo)
Note that this identifier, in its current state, was loaded from an AST file. One-way:
`clang::IdentifierInfo` offers no matching clear.
"""
function setIsFromAST(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_setIsFromAST(x)
end

"""
    setChangedSinceDeserialization(x::AbstractIdentifierInfo)
Note that this identifier has changed since it was loaded from an AST file. One-way:
`clang::IdentifierInfo` offers no matching clear.
"""
function setChangedSinceDeserialization(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_setChangedSinceDeserialization(x)
end

"""
    hasFETokenInfoChangedSinceDeserialization(x::AbstractIdentifierInfo) -> Bool
Return `true` if the front-end token information for this identifier changed since it was
loaded from an AST file.
"""
function hasFETokenInfoChangedSinceDeserialization(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_hasFETokenInfoChangedSinceDeserialization(x)
end

"""
    setFETokenInfoChangedSinceDeserialization(x::AbstractIdentifierInfo)
Note that the front-end token information for this identifier changed since it was loaded
from an AST file. One-way: `clang::IdentifierInfo` offers no matching clear.
"""
function setFETokenInfoChangedSinceDeserialization(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_setFETokenInfoChangedSinceDeserialization(x)
end

function isMangledOpenMPVariantName(x::AbstractIdentifierInfo)
    @check_ptrs x
    return clang_IdentifierInfo_isMangledOpenMPVariantName(x)
end

function setMangledOpenMPVariantName(x::AbstractIdentifierInfo, i::Bool)
    @check_ptrs x
    return clang_IdentifierInfo_setMangledOpenMPVariantName(x, i)
end

"""
    getOwn(x::AbstractIdentifierTable, name::AbstractString) -> IdentifierInfo
Return the `IdentifierInfo` for `name`, creating and interning it if the table does not
have one yet, **without** consulting the external identifier source. This is the entry
point an external source itself uses, where `get` would recurse back into it.
"""
function getOwn(x::AbstractIdentifierTable, name::AbstractString)
    @check_ptrs x
    return IdentifierInfo(clang_IdentifierTable_getOwn(x, name))
end

# Selector
"""
    Selector() -> Selector
Construct the null selector, i.e. the value `clang::Selector`'s default constructor yields.
"""
Selector() = Selector(CXSelector(C_NULL))

"""
    isNull(x::AbstractSelector) -> Bool
Return `true` if this is the empty selector. A NULL handle is a legal `Selector` value, so
this is a plain comparison and is defined even on the `DenseMap` marker selectors.
"""
isNull(x::AbstractSelector) = clang_Selector_isNull(x)

"""
    isKeywordSelector(x::AbstractSelector) -> Bool
Return `true` if this selector takes at least one argument, i.e. its spelling ends in `:`.
"""
isKeywordSelector(x::AbstractSelector) = clang_Selector_isKeywordSelector(x)

"""
    isUnarySelector(x::AbstractSelector) -> Bool
Return `true` if this selector takes no argument, i.e. its spelling carries no `:`.
"""
isUnarySelector(x::AbstractSelector) = clang_Selector_isUnarySelector(x)

"""
    getNumArgs(x::AbstractSelector) -> UInt32
Return the number of arguments this selector takes.
"""
getNumArgs(x::AbstractSelector) = clang_Selector_getNumArgs(x)

"""
    getIdentifierInfoForSlot(x::AbstractSelector, i::Integer) -> IdentifierInfo
Return the identifier at position `i` of this selector, or a NULL-pointer carrier when that
slot carries no identifier.

`i` must be `0` for the zero- and one-argument representations and less than `getNumArgs(x)`
otherwise; `clang::Selector` only asserts that and indexes unchecked in a release build.
"""
function getIdentifierInfoForSlot(x::AbstractSelector, i::Integer)
    @assert i == 0 || i < getNumArgs(x) "selector slot index out of range"
    return IdentifierInfo(clang_Selector_getIdentifierInfoForSlot(x, i))
end

"""
    getNameForSlot(x::AbstractSelector, i::Integer) -> String
Return the name at position `i` of this selector, or `""` when that slot carries no
identifier. `i` is bounded exactly as in [`getIdentifierInfoForSlot`](@ref).
"""
function getNameForSlot(x::AbstractSelector, i::Integer)
    @assert i == 0 || i < getNumArgs(x) "selector slot index out of range"
    return get_string(clang_Selector_getNameForSlot(x, i))
end

"""
    getAsString(x::AbstractSelector) -> String
Return the full selector name, e.g. `"foo:bar:"`.
"""
getAsString(x::AbstractSelector) = get_string(clang_Selector_getAsString(x))

"""
    dump(x::AbstractSelector)
Print the full selector name to `stderr`.
"""
dump(x::AbstractSelector) = clang_Selector_dump(x)

"""
    getMethodFamily(x::AbstractSelector) -> CXObjCMethodFamily
Return the conventional Objective-C method family this selector name implies.
"""
getMethodFamily(x::AbstractSelector) = clang_Selector_getMethodFamily(x)

"""
    getStringFormatFamily(x::AbstractSelector) -> CXObjCStringFormatFamily
Return the string-format family this selector name implies.
"""
getStringFormatFamily(x::AbstractSelector) = clang_Selector_getStringFormatFamily(x)

"""
    getInstTypeMethodFamily(x::AbstractSelector) -> CXObjCInstanceTypeFamily
Return the family of Objective-C methods whose initially-`id` result type is a candidate for
`instancetype`, as implied by this selector name.
"""
getInstTypeMethodFamily(x::AbstractSelector) = clang_Selector_getInstTypeMethodFamily(x)

"""
    getEmptyMarker() -> Selector
Return the sentinel selector `llvm::DenseMap` uses as its empty key.

The result is a sentinel encoding, not a real selector: only [`isNull`](@ref), which merely
compares the encoding, is defined on it. Every accessor that reads through the encoding —
`getNumArgs`, `getNameForSlot`, `getMethodFamily`, ... — is undefined behaviour.
"""
getEmptyMarker() = Selector(clang_Selector_getEmptyMarker())

"""
    getTombstoneMarker() -> Selector
Return the sentinel selector `llvm::DenseMap` uses as its tombstone key. The same caveat as
[`getEmptyMarker`](@ref) applies.
"""
getTombstoneMarker() = Selector(clang_Selector_getTombstoneMarker())

# SelectorTable
"""
    getSelector(x::AbstractSelectorTable, numArgs::Integer, ids::Vector{IdentifierInfo}) -> Selector
Return the selector taking `numArgs` arguments and spelled by `ids`, uniquing it in the
table.

`ids` must hold at least `max(numArgs, 1)` identifiers: `clang::SelectorTable` reads the
first slot even for the zero-argument case.
"""
function getSelector(x::AbstractSelectorTable, numArgs::Integer, ids::Vector{IdentifierInfo})
    @check_ptrs x
    @assert length(ids) >= max(numArgs, 1) "getSelector reads max(numArgs, 1) identifiers"
    buf = CXIdentifierInfo[Base.unsafe_convert(CXIdentifierInfo, id) for id in ids]
    return Selector(clang_SelectorTable_getSelector(x, numArgs, buf))
end

"""
    getUnarySelector(x::AbstractSelectorTable, id::AbstractIdentifierInfo) -> Selector
Return the one-argument selector spelled `"id:"`.
"""
function getUnarySelector(x::AbstractSelectorTable, id::AbstractIdentifierInfo)
    @check_ptrs x id
    return Selector(clang_SelectorTable_getUnarySelector(x, id))
end

"""
    getNullarySelector(x::AbstractSelectorTable, id::AbstractIdentifierInfo) -> Selector
Return the zero-argument selector spelled `"id"`.
"""
function getNullarySelector(x::AbstractSelectorTable, id::AbstractIdentifierInfo)
    @check_ptrs x id
    return Selector(clang_SelectorTable_getNullarySelector(x, id))
end

"""
    getTotalMemory(x::AbstractSelectorTable) -> Csize_t
Return the number of bytes this table has allocated for managing selectors.
"""
function getTotalMemory(x::AbstractSelectorTable)
    @check_ptrs x
    return clang_SelectorTable_getTotalMemory(x)
end

"""
    constructSetterName(name::AbstractString) -> String
Return the default setter name for `name`, i.e. `"set"` followed by `name` with its initial
character capitalized. `name` must be non-empty — Clang indexes the result at position 3.
"""
function constructSetterName(name::AbstractString)
    @assert !isempty(name) "a setter name needs a non-empty property name"
    return get_string(clang_SelectorTable_constructSetterName(name))
end

"""
    constructSetterSelector(idents::AbstractIdentifierTable, seltab::AbstractSelectorTable,
                            name::AbstractIdentifierInfo) -> Selector
Return the default setter selector for `name`, i.e. the one-argument selector spelled
[`constructSetterName`](@ref). `name`'s spelling must be non-empty.
"""
function constructSetterSelector(idents::AbstractIdentifierTable, seltab::AbstractSelectorTable, name::AbstractIdentifierInfo)
    @check_ptrs idents seltab name
    @assert getLength(name) > 0 "a setter name needs a non-empty property name"
    return Selector(clang_SelectorTable_constructSetterSelector(idents, seltab, name))
end

"""
    getPropertyNameFromSetterSelector(x::AbstractSelector) -> String
Return the property name a setter selector sets, i.e. the first slot of `x` with its `"set"`
prefix stripped and the following character lowercased.

`x` must be a setter selector: Clang asserts the `"set"` prefix and then indexes the name at
position 3, which is out of bounds for a name spelled exactly `"set"`.
"""
function getPropertyNameFromSetterSelector(x::AbstractSelector)
    name = getNameForSlot(x, 0)
    @assert startswith(name, "set") && length(name) > 3 "not a setter selector"
    return get_string(clang_SelectorTable_getPropertyNameFromSetterSelector(x))
end

"""
    getFutureCompatDiagKind(x::AbstractIdentifierTable, ii::AbstractIdentifierInfo,
                            opts::AbstractLangOptions) -> Cuint
Return the diagnostic id warning that `ii` will become a keyword in a future standard.

`ii` must already be a future-compatible keyword — clang's own comment says the caller must
have determined that — so the gate is [`isFutureCompatKeyword`](@ref). The result is a plain
diagnostic id, the currency [`isIgnored`](@ref) and [`getDiagnosticLevel`](@ref) take.
"""
function getFutureCompatDiagKind(x::AbstractIdentifierTable, ii::AbstractIdentifierInfo, opts::AbstractLangOptions)
    @check_ptrs x ii opts
    @assert isFutureCompatKeyword(ii) "identifier must be a future-compatible keyword"
    return clang_IdentifierTable_getFutureCompatDiagKind(x, ii, opts)
end
