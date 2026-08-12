function PrintStats(x::LangOptions)
    @check_ptrs x
    return clang_LangOptions_PrintStats(x)
end

function isCompilingModule(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModule(x)
end

function isCompilingModuleInterface(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModuleInterface(x)
end

function isCompilingModuleImplementation(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isCompilingModuleImplementation(x)
end

function isSignedOverflowDefined(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSignedOverflowDefined(x)
end

function isSubscriptPointerArithmetic(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSubscriptPointerArithmetic(x)
end

function isNoBuiltinFunc(x::AbstractLangOptions, name::AbstractString)
    @check_ptrs x
    return clang_LangOptions_isNoBuiltinFunc(x, name)
end

"""
    getBorland(x::AbstractLangOptions) -> Bool
Whether Borland extensions (`-fborland-extensions`) are enabled. This gates the
SEH identifier surface — see [`PoisonSEHIdentifiers`](@ref).
"""
function getBorland(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getBorland(x)
end

"""
    getMicrosoftExt(x::AbstractLangOptions) -> Bool
Whether Microsoft extensions are enabled. A gate, like [`getBorland`](@ref): the `MSGuidTagDecl`
that `__uuidof` resolves against exists only when one of the two is set, and clang reaches for it
unchecked — see [`BuildCXXUuidof`](@ref).
"""
function getMicrosoftExt(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getMicrosoftExt(x)
end

"""
    hasLangStandard(x::LangOptions) -> Bool
Return whether a language standard has been selected, i.e. whether `LangStd` is something
other than `lang_unspecified`.

A default-constructed `CompilerInvocation` has not selected one, and
[`getCC1CommandLine`](@ref) aborts on that through LLVM's fatal-error handler, so this is
the gate to test before generating a command line (`MARSHALLING.md` §13).
"""
function hasLangStandard(x::LangOptions)
    @check_ptrs x
    return clang_LangOptions_hasLangStandard(x)
end

"""
    setLangDefaults(x::AbstractLangOptions, lang::CXLanguage, triple::AbstractString,
                    lang_std::CXLangStandardKind=CXLangStandardKind_lang_unspecified) -> Vector{String}
Configure `x` the way `-x <lang> -std=<lang_std>` for `triple` would have, and return the
headers the language implicitly requires — the empty vector for everything but HLSL and
OpenCL.

This is what makes a programmatically-created `LangOptions` usable without round-tripping
through CC1 argument parsing: it is the same static clang's own driver calls.

Leaving `lang_std` at `lang_unspecified` asks clang for the language's own default, and
that resolution is the one partial step here: it aborts the process for
`CXLanguage_Unknown` and `CXLanguage_LLVM_IR`, neither of which has a default standard. An
explicit `lang_std` bypasses it, so any language goes with one.
"""
function setLangDefaults(x::AbstractLangOptions, lang::CXLanguage, triple::AbstractString, lang_std::CXLangStandardKind=CXLangStandardKind_lang_unspecified)
    @check_ptrs x
    @assert lang_std != CXLangStandardKind_lang_unspecified || (lang != CXLanguage_Unknown && lang != CXLanguage_LLVM_IR) "no default language standard is defined for $lang"
    return get_string(clang_LangOptions_setLangDefaults(x, lang, triple, lang_std))
end

function assumeFunctionsAreConvergent(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_assumeFunctionsAreConvergent(x)
end

function getOpenCLCompatibleVersion(x::AbstractLangOptions)
    @check_ptrs x
    return Int(clang_LangOptions_getOpenCLCompatibleVersion(x))
end

function getOpenCLVersionString(x::AbstractLangOptions)
    @check_ptrs x
    return get_string(clang_LangOptions_getOpenCLVersionString(x))
end

function requiresStrictPrototypes(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_requiresStrictPrototypes(x)
end

function implicitFunctionsAllowed(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_implicitFunctionsAllowed(x)
end

function hasAtExit(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasAtExit(x)
end

function isImplicitIntRequired(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isImplicitIntRequired(x)
end

function isImplicitIntAllowed(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isImplicitIntAllowed(x)
end

function hasSjLjExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasSjLjExceptions(x)
end

function hasSEHExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasSEHExceptions(x)
end

function hasDWARFExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasDWARFExceptions(x)
end

function hasWasmExceptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasWasmExceptions(x)
end

function isSYCL(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSYCL(x)
end

function trackLocalOwningModule(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_trackLocalOwningModule(x)
end

"""
    isCompatibleWithMSVC(x::AbstractLangOptions, version::CXMSVCMajorVersion) -> Bool
Return whether `-fms-compatibility-version` is at least `version`.
"""
function isCompatibleWithMSVC(x::AbstractLangOptions, version::CXMSVCMajorVersion)
    @check_ptrs x
    return clang_LangOptions_isCompatibleWithMSVC(x, version)
end

"""
    resetNonModularOptions(x::AbstractLangOptions)
Reset every option that is not considered when building a module.

This mutates `x` in place. The options reached through a live interpreter belong to that
interpreter's compiler instance, so call this only on options you own.
"""
function resetNonModularOptions(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_resetNonModularOptions(x)
end

function allowsNonTrivialObjCLifetimeQualifiers(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_allowsNonTrivialObjCLifetimeQualifiers(x)
end

function hasSignReturnAddress(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasSignReturnAddress(x)
end

function isSignReturnAddressWithAKey(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSignReturnAddressWithAKey(x)
end

function isSignReturnAddressScopeAll(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isSignReturnAddressScopeAll(x)
end

function hasDefaultVisibilityExportMapping(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasDefaultVisibilityExportMapping(x)
end

function isExplicitDefaultVisibilityExportMapping(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isExplicitDefaultVisibilityExportMapping(x)
end

function isAllDefaultVisibilityExportMapping(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_isAllDefaultVisibilityExportMapping(x)
end

function hasGlobalAllocationFunctionVisibility(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasGlobalAllocationFunctionVisibility(x)
end

function hasDefaultGlobalAllocationFunctionVisibility(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasDefaultGlobalAllocationFunctionVisibility(x)
end

function hasProtectedGlobalAllocationFunctionVisibility(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasProtectedGlobalAllocationFunctionVisibility(x)
end

function hasHiddenGlobalAllocationFunctionVisibility(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_hasHiddenGlobalAllocationFunctionVisibility(x)
end

"""
    remapPathPrefix(x::AbstractLangOptions, path::AbstractString) -> String
Apply the `-fmacro-prefix-path` remappings recorded in `x` to `path` and return the
rewritten path. With no remappings configured `path` comes back unchanged.
"""
function remapPathPrefix(x::AbstractLangOptions, path::AbstractString)
    @check_ptrs x
    return get_string(clang_LangOptions_remapPathPrefix(x, path))
end

"""
    getDefaultRoundingMode(x::AbstractLangOptions) -> CXRoundingMode
Return the rounding mode in effect when no pragma overrides it: `Dynamic` under
`-frounding-math`, `NearestTiesToEven` otherwise.
"""
function getDefaultRoundingMode(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getDefaultRoundingMode(x)
end

"""
    getDefaultExceptionMode(x::AbstractLangOptions) -> CXFPExceptionModeKind
Return the floating-point exception mode in effect, resolving the internal
`FPE_Default` placeholder to `FPE_Ignore`.
"""
function getDefaultExceptionMode(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getDefaultExceptionMode(x)
end

"""
    defaultWithoutTrailingStorage(lang_opts::AbstractLangOptions) -> UInt32
Return the `clang::FPOptions` value used for nodes that carry no trailing override slot,
as its opaque integer encoding.

`clang::FPOptions` is one bitfield word, so it crosses as that encoding rather than as a
handle — the same encoding [`getFPFeaturesInEffect`](@ref) returns, and the input the
`getRoundingMode`/`getExceptionMode` decoders below expect.
"""
function defaultWithoutTrailingStorage(lang_opts::AbstractLangOptions)
    @check_ptrs lang_opts
    return clang_FPOptions_defaultWithoutTrailingStorage(lang_opts)
end

"""
    getRoundingMode(fp_options::Integer) -> CXRoundingMode
Decode the rounding mode out of a `clang::FPOptions` opaque integer encoding, resolving
`Dynamic` to `NearestTiesToEven` when neither FENV access nor `-frounding-math` is on.
"""
getRoundingMode(fp_options::Integer) = clang_FPOptions_getRoundingMode(fp_options)

"""
    getExceptionMode(fp_options::Integer) -> CXFPExceptionModeKind
Decode the floating-point exception mode out of a `clang::FPOptions` opaque integer
encoding, resolving the internal `FPE_Default` placeholder.
"""
getExceptionMode(fp_options::Integer) = clang_FPOptions_getExceptionMode(fp_options)

"""
    getCPlusPlus(x::AbstractLangOptions) -> Bool
Whether the translation unit is being compiled as C++ (`LangOptions.def`:
`LANGOPT(CPlusPlus, ...)`). This gates Sema's `std::` lookup entry points — see
[`isStdInitializerList`](@ref).
"""
function getCPlusPlus(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getCPlusPlus(x)
end

"""
    getCPlusPlus11(x::AbstractLangOptions) -> Bool
Whether C++11 or a later standard is in effect (`LangOptions.def`:
`LANGOPT(CPlusPlus11, ...)`).

Exposed as a gate: declaring an `operator new` form before C++11 makes Sema reach for
`std::bad_alloc`, which a translation unit that never parsed `<new>` does not have — see
[`DeclareGlobalAllocationFunction`](@ref).
"""
function getCPlusPlus11(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getCPlusPlus11(x)
end

"""
    getModules(x::AbstractLangOptions) -> Bool
Return whether modules (`-fmodules`) are enabled. This gates the `modules_enabled` argument of
[`ShouldEnterIncludeFile`](@ref), which has no other way to be checked against the invocation.
"""
function getModules(x::AbstractLangOptions)
    @check_ptrs x
    return clang_LangOptions_getModules(x)
end

"""
    allowFPContractWithinStatement(fp_options::Integer) -> Bool
Return whether `a * b + c` may be contracted into a fused operation *within* one statement.

This and [`allowFPContractAcrossStatement`](@ref) are mutually exclusive and together name the
contraction mode: `on` answers `true, false`, `fast` answers `false, true`, and `off` answers
`false, false`.
"""
allowFPContractWithinStatement(fp_options::Integer) = clang_FPOptions_allowFPContractWithinStatement(fp_options)

"""
    allowFPContractAcrossStatement(fp_options::Integer) -> Bool
Return whether contraction may cross statement boundaries — the `fast` mode. See
[`allowFPContractWithinStatement`](@ref) for how the pair encodes the three modes.
"""
allowFPContractAcrossStatement(fp_options::Integer) = clang_FPOptions_allowFPContractAcrossStatement(fp_options)

"""
    isFPConstrained(fp_options::Integer) -> Bool
Return whether the word describes constrained floating point: a non-default rounding mode,
non-ignored exceptions, or FEnv access. It is the single summary of state
[`getRoundingMode`](@ref) and [`getExceptionMode`](@ref) read piecemeal.
"""
isFPConstrained(fp_options::Integer) = clang_FPOptions_isFPConstrained(fp_options)

"""
    getChangesFrom(fp_options::Integer, base::Integer) -> UInt64
Return the `FPOptionsOverride` describing how `fp_options` differs from `base`, as the opaque
encoding this package already uses for stored FP features.

`getChangesFrom(w, w)` is `0` — no difference — which is what an expression with no FP pragma
in effect stores.
"""
getChangesFrom(fp_options::Integer, base::Integer) = clang_FPOptions_getChangesFrom(fp_options, base)

# FPOptionsOverride
# The class crosses as its uint64 opaque encoding — the currency every `getFPFeatures` and
# `getStoredFPFeatures` reader already hands out — rather than as a carrier: it is two 32-bit
# words, and a handle would make `@check_ptrs` reject the legitimate zero meaning "no
# override" (MARSHALLING.md §7).
"""
    applyOverrides(fp_override::Integer, base::Integer) -> UInt32
Apply `fp_override` to the `FPOptions` word `base` and return the resulting word.

This is what turns a stored override — everything [`getStoredFPFeatures`](@ref) and
[`getFPFeaturesInEffect`](@ref) hand back — into a word the `FPOptions` decoders read:
[`getRoundingMode`](@ref), [`getExceptionMode`](@ref),
[`allowFPContractWithinStatement`](@ref) and the rest. An empty override returns `base`
unchanged.
"""
applyOverrides(fp_override::Integer, base::Integer) = clang_FPOptionsOverride_applyOverrides(fp_override, base)

"""
    requiresTrailingStorage(fp_override::Integer) -> Bool
Return whether `fp_override` sets anything at all — equivalently, whether an AST node carrying
it needs trailing storage for it. This reads the override's mask without the caller having to
know how the encoding splits into value and mask halves.
"""
requiresTrailingStorage(fp_override::Integer) = clang_FPOptionsOverride_requiresTrailingStorage(fp_override)

"""
    setAllowFPContractWithinStatement(fp_override::Integer) -> UInt64
Return `fp_override` with the contraction mode overridden to `on`.

A value crossing has no object to mutate, so the three contraction setters take a word and
return the modified one rather than writing through a handle.
"""
function setAllowFPContractWithinStatement(fp_override::Integer)
    clang_FPOptionsOverride_setAllowFPContractWithinStatement(fp_override)
end

"""
    setAllowFPContractAcrossStatement(fp_override::Integer) -> UInt64
Return `fp_override` with the contraction mode overridden to `fast`.
"""
function setAllowFPContractAcrossStatement(fp_override::Integer)
    clang_FPOptionsOverride_setAllowFPContractAcrossStatement(fp_override)
end

"""
    setDisallowFPContract(fp_override::Integer) -> UInt64
Return `fp_override` with the contraction mode overridden to `off`.
"""
setDisallowFPContract(fp_override::Integer) = clang_FPOptionsOverride_setDisallowFPContract(fp_override)
