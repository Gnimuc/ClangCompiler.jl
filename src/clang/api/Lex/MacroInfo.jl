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


"""
    setDefinitionEndLoc(x::AbstractMacroInfo, loc::SourceLocation)
Set the location of the last token in this macro's definition.
"""
function setDefinitionEndLoc(x::AbstractMacroInfo, loc::SourceLocation)
    @check_ptrs x
    return clang_MacroInfo_setDefinitionEndLoc(x, loc)
end

"""
    setIsBuiltinMacro(x::AbstractMacroInfo, val::Bool=true)
Mark this macro as one whose expansion is computed by the preprocessor (`__LINE__` and
friends) rather than taken from a replacement-token list.
"""
function setIsBuiltinMacro(x::AbstractMacroInfo, val::Bool=true)
    @check_ptrs x
    return clang_MacroInfo_setIsBuiltinMacro(x, val)
end

"""
    setIsUsed(x::AbstractMacroInfo, val::Bool)
Record whether this macro has been expanded or tested since it was defined.
"""
function setIsUsed(x::AbstractMacroInfo, val::Bool)
    @check_ptrs x
    return clang_MacroInfo_setIsUsed(x, val)
end

"""
    setIsAllowRedefinitionsWithoutWarning(x::AbstractMacroInfo, val::Bool)
Record whether redefining this macro is allowed without a warning.
"""
function setIsAllowRedefinitionsWithoutWarning(x::AbstractMacroInfo, val::Bool)
    @check_ptrs x
    return clang_MacroInfo_setIsAllowRedefinitionsWithoutWarning(x, val)
end

"""
    setIsWarnIfUnused(x::AbstractMacroInfo, val::Bool)
Record whether the preprocessor should warn when this macro is never used.
"""
function setIsWarnIfUnused(x::AbstractMacroInfo, val::Bool)
    @check_ptrs x
    return clang_MacroInfo_setIsWarnIfUnused(x, val)
end

"""
    tokens_empty(x::AbstractMacroInfo) -> Bool
Return whether this macro's replacement-token list is empty.
"""
function tokens_empty(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_tokens_empty(x)
end

"""
    EnableMacro(x::AbstractMacroInfo)
Re-enable expansion of this macro. Clang asserts that the macro is currently disabled, so
`isEnabled(x)` must be `false`.
"""
function EnableMacro(x::AbstractMacroInfo)
    @check_ptrs x
    @assert !isEnabled(x) "macro is already enabled"
    return clang_MacroInfo_EnableMacro(x)
end

"""
    DisableMacro(x::AbstractMacroInfo)
Suppress expansion of this macro. Clang asserts that the macro is currently enabled, so
`isEnabled(x)` must be `true`.
"""
function DisableMacro(x::AbstractMacroInfo)
    @check_ptrs x
    @assert isEnabled(x) "macro is already disabled"
    return clang_MacroInfo_DisableMacro(x)
end

"""
    setUsedForHeaderGuard(x::AbstractMacroInfo, val::Bool)
Record whether this macro was used as a multiple-inclusion guard.
"""
function setUsedForHeaderGuard(x::AbstractMacroInfo, val::Bool)
    @check_ptrs x
    return clang_MacroInfo_setUsedForHeaderGuard(x, val)
end

# MacroDirective

"""
    getKind(x::AbstractMacroDirective) -> CXMacroDirectiveKind
Return whether this directive is a `#define`, an `#undef`, or a visibility pragma.
"""
function getKind(x::AbstractMacroDirective)
    @check_ptrs x
    return clang_MacroDirective_getKind(x)
end

"""
    getLocation(x::AbstractMacroDirective) -> SourceLocation
Return the location of the directive itself.
"""
function getLocation(x::AbstractMacroDirective)
    @check_ptrs x
    return SourceLocation(clang_MacroDirective_getLocation(x))
end

"""
    getPrevious(x::AbstractMacroDirective) -> MacroDirective
Return the directive that preceded this one for the same identifier. The result is borrowed
and holds a NULL pointer past the oldest directive in the history.
"""
function getPrevious(x::AbstractMacroDirective)
    @check_ptrs x
    return MacroDirective(clang_MacroDirective_getPrevious(x))
end

"""
    isFromPCH(x::AbstractMacroDirective) -> Bool
Return whether this directive was loaded from a PCH file.
"""
function isFromPCH(x::AbstractMacroDirective)
    @check_ptrs x
    return clang_MacroDirective_isFromPCH(x)
end

"""
    isDefined(x::AbstractMacroDirective) -> Bool
Return whether the macro is defined at this point in its directive history — that is, the
history reaches a `#define` that no later `#undef` has cancelled.
"""
function isDefined(x::AbstractMacroDirective)
    @check_ptrs x
    return clang_MacroDirective_isDefined(x)
end

"""
    getMacroInfo(x::AbstractMacroDirective) -> MacroInfo
Return the definition this directive resolves to, found by walking the directive history
backwards. The result is borrowed and holds a NULL pointer when the history holds no
`#define` at all; an `#undef` directive still resolves to the definition it cancelled, so
pair this with `isDefined`.
"""
function getMacroInfo(x::AbstractMacroDirective)
    @check_ptrs x
    return MacroInfo(clang_MacroDirective_getMacroInfo(x))
end


# MacroInfo — the one-way flags a macro's builder sets while filling it in

"""
    setIsFunctionLike(x::AbstractMacroInfo)
Record that this macro takes a parameter list. The flag is one-way: `clang::MacroInfo`
offers no way back to object-like, and `isObjectLike` is defined as its negation.
"""
function setIsFunctionLike(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_setIsFunctionLike(x)
end

"""
    setIsC99Varargs(x::AbstractMacroInfo)
Record that this macro is a C99 variadic macro, i.e. one spelled `...` and referred to as
`__VA_ARGS__`. Only meaningful on a function-like macro, and one-way.
"""
function setIsC99Varargs(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_setIsC99Varargs(x)
end

"""
    setIsGNUVarargs(x::AbstractMacroInfo)
Record that this macro is a GNU variadic macro, i.e. one whose last parameter is spelled
`args...`. Only meaningful on a function-like macro, and one-way.
"""
function setIsGNUVarargs(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_setIsGNUVarargs(x)
end

"""
    setHasCommaPasting(x::AbstractMacroInfo)
Record that the replacement list pastes a comma against the variadic parameter, i.e. the
GNU `, ## __VA_ARGS__` extension. One-way.
"""
function setHasCommaPasting(x::AbstractMacroInfo)
    @check_ptrs x
    return clang_MacroInfo_setHasCommaPasting(x)
end

# MacroDirective — history mutation and the boxed definition view

"""
    setPrevious(x::AbstractMacroDirective, prev::AbstractMacroDirective)
Relink `x`'s directive history so that `prev` precedes it. `prev` is borrowed, not adopted,
and must come from the same identifier's history: the preprocessor walks this chain to
decide whether the macro is currently defined.
"""
function setPrevious(x::AbstractMacroDirective, prev::AbstractMacroDirective)
    @check_ptrs x prev
    return clang_MacroDirective_setPrevious(x, prev)
end

"""
    setIsFromPCH(x::AbstractMacroDirective)
Record that this directive was loaded from a PCH file. One-way — there is no matching
clear.
"""
function setIsFromPCH(x::AbstractMacroDirective)
    @check_ptrs x
    return clang_MacroDirective_setIsFromPCH(x)
end

"""
    getDefinition(x::AbstractMacroDirective) -> DefInfo
Return the definition active at this directive, found by walking the history backwards. A
history holding no `#define` yields an invalid `DefInfo`, which is still a box and not a
NULL carrier — check it with `isValid`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getDefinition(x::AbstractMacroDirective)
    @check_ptrs x
    return DefInfo(clang_MacroDirective_getDefinition(x))
end

"""
    findDirectiveAtLoc(x::AbstractMacroDirective, loc::SourceLocation, src_mgr::AbstractSourceManager) -> DefInfo
Return the definition that was active at `loc`, or an invalid `DefInfo` when the macro was
not defined there.

`loc` must be valid: the walk orders `loc` against each directive's location through
`src_mgr`, which is meaningless for an invalid location.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function findDirectiveAtLoc(x::AbstractMacroDirective, loc::SourceLocation, src_mgr::AbstractSourceManager)
    @check_ptrs x src_mgr
    @assert isValid(loc) "the queried source location must be valid"
    return DefInfo(clang_MacroDirective_findDirectiveAtLoc(x, loc, src_mgr))
end

"""
    dump(x::AbstractMacroDirective)
Write the directive, its history links and — for a `#define` — its `MacroInfo` to stderr.
"""
function dump(x::AbstractMacroDirective)
    @check_ptrs x
    return clang_MacroDirective_dump(x)
end

# MacroDirective::DefInfo

"""
    dispose(x::AbstractDefInfo)
Release a `DefInfo` produced by `getDefinition`, `findDirectiveAtLoc` or
`getPreviousDefinition`. Invalid boxes need disposing just as valid ones do.
"""
function dispose(x::AbstractDefInfo)
    @check_ptrs x
    return clang_DefInfo_dispose(x)
end

"""
    getDirective(x::AbstractDefInfo) -> DefMacroDirective
Return the `#define` directive this definition came from. The result is borrowed and holds
a NULL pointer when `x` is invalid.
"""
function getDirective(x::AbstractDefInfo)
    @check_ptrs x
    return DefMacroDirective(clang_DefInfo_getDirective(x))
end

"""
    getLocation(x::AbstractDefInfo) -> SourceLocation
Return the location of the `#define` this definition came from, or an invalid location when
`x` is invalid.
"""
function getLocation(x::AbstractDefInfo)
    @check_ptrs x
    return SourceLocation(clang_DefInfo_getLocation(x))
end

"""
    getMacroInfo(x::AbstractDefInfo) -> MacroInfo
Return the definition body. The result is borrowed and holds a NULL pointer when `x` is
invalid.
"""
function getMacroInfo(x::AbstractDefInfo)
    @check_ptrs x
    return MacroInfo(clang_DefInfo_getMacroInfo(x))
end

"""
    getUndefLocation(x::AbstractDefInfo) -> SourceLocation
Return the location of the `#undef` that cancelled this definition, or an invalid location
when nothing cancelled it.
"""
function getUndefLocation(x::AbstractDefInfo)
    @check_ptrs x
    return SourceLocation(clang_DefInfo_getUndefLocation(x))
end

"""
    isUndefined(x::AbstractDefInfo) -> Bool
Return whether a later `#undef` cancelled this definition.
"""
function isUndefined(x::AbstractDefInfo)
    @check_ptrs x
    return clang_DefInfo_isUndefined(x)
end

"""
    isPublic(x::AbstractDefInfo) -> Bool
Return whether this definition is part of its module's public macro API, as decided by the
visibility directives the history walk passed through.
"""
function isPublic(x::AbstractDefInfo)
    @check_ptrs x
    return clang_DefInfo_isPublic(x)
end

"""
    isValid(x::AbstractDefInfo) -> Bool
Return whether the history walk found a `#define` at all.
"""
function isValid(x::AbstractDefInfo)
    @check_ptrs x
    return clang_DefInfo_isValid(x)
end

"""
    isInvalid(x::AbstractDefInfo) -> Bool
Return whether the history walk found no `#define`; the negation of `isValid`.
"""
function isInvalid(x::AbstractDefInfo)
    @check_ptrs x
    return clang_DefInfo_isInvalid(x)
end

"""
    getPreviousDefinition(x::AbstractDefInfo) -> DefInfo
Return the definition preceding this one, or an invalid `DefInfo` once the history runs
out. Total on an invalid `x`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getPreviousDefinition(x::AbstractDefInfo)
    @check_ptrs x
    return DefInfo(clang_DefInfo_getPreviousDefinition(x))
end

# DefMacroDirective

"""
    getInfo(x::AbstractDefMacroDirective) -> MacroInfo
Return the definition body this `#define` introduced. The result is borrowed, and is never
NULL because `clang::DefMacroDirective` asserts it at construction.
"""
function getInfo(x::AbstractDefMacroDirective)
    @check_ptrs x
    return MacroInfo(clang_DefMacroDirective_getInfo(x))
end
