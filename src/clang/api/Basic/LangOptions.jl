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
