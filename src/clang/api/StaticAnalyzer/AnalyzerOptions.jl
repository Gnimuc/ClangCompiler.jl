# AnalyzerOptions — the analyzer's configuration object, handed out borrowed by
# `getAnalyzerOpts` on a `CompilerInvocation` or a `CompilerInstance`. Almost every knob
# below is a public data member of `clang::AnalyzerOptions`, so each pair is a plain
# get/set on that field; the container members get the count+index enumeration the C
# boundary needs.

"""
    getRegisteredCheckers(; include_experimental=false) -> Vector{String}
Return the checker names TableGen stamped into `Checkers.inc`.

`debug.*` checkers are always excluded and `alpha.*` ones only appear when
`include_experimental` is set. This list is static: it knows nothing about statically
linked non-generated checkers or plugin checkers, which is what
[`printCheckerHelp`](@ref) reports instead.
"""
function getRegisteredCheckers(; include_experimental::Bool=false)
    return get_string(clang_AnalyzerOptions_getRegisteredCheckers(include_experimental))
end

"""
    getRegisteredPackages(; include_experimental=false) -> Vector{String}
Return the checker *package* names TableGen stamped into `Checkers.inc`, with the same
`debug`/`alpha` filtering as [`getRegisteredCheckers`](@ref).
"""
function getRegisteredPackages(; include_experimental::Bool=false)
    return get_string(clang_AnalyzerOptions_getRegisteredPackages(include_experimental))
end

# CheckersAndPackages
"""
    addCheckerOrPackage(x::AbstractAnalyzerOptions, name, enable::Bool) -> Nothing
Append one `-analyzer-checker` (`enable = true`) or `-analyzer-disable-checker`
(`enable = false`) entry. Order matters: a later entry overrides an earlier one naming the
same checker or package.
"""
function addCheckerOrPackage(x::AbstractAnalyzerOptions, name::AbstractString, enable::Bool)
    @check_ptrs x
    return clang_AnalyzerOptions_addCheckerOrPackage(x, name, enable)
end

"""
    getNumCheckersAndPackages(x::AbstractAnalyzerOptions) -> UInt32
Return how many checker/package enable-disable entries are recorded.
"""
function getNumCheckersAndPackages(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getNumCheckersAndPackages(x)
end

"""
    getCheckerOrPackageName(x::AbstractAnalyzerOptions, i::Integer) -> String
Return the name of entry `i` (zero-based).
"""
function getCheckerOrPackageName(x::AbstractAnalyzerOptions, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumCheckersAndPackages(x) "checker/package index $i is out of range."
    return get_string(clang_AnalyzerOptions_getCheckerOrPackageName(x, i))
end

"""
    isCheckerOrPackageEnabled(x::AbstractAnalyzerOptions, i::Integer) -> Bool
Return whether entry `i` (zero-based) enables or disables its checker or package.
"""
function isCheckerOrPackageEnabled(x::AbstractAnalyzerOptions, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumCheckersAndPackages(x) "checker/package index $i is out of range."
    return clang_AnalyzerOptions_isCheckerOrPackageEnabled(x, i)
end

# SilencedCheckersAndPackages
"""
    addSilencedCheckerOrPackage(x::AbstractAnalyzerOptions, name) -> Nothing
Silence a checker or package: it still runs, but emits no warning.
"""
function addSilencedCheckerOrPackage(x::AbstractAnalyzerOptions, name::AbstractString)
    @check_ptrs x
    return clang_AnalyzerOptions_addSilencedCheckerOrPackage(x, name)
end

"""
    getNumSilencedCheckersAndPackages(x::AbstractAnalyzerOptions) -> UInt32
Return how many checkers or packages are silenced.
"""
function getNumSilencedCheckersAndPackages(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getNumSilencedCheckersAndPackages(x)
end

"""
    getSilencedCheckerOrPackage(x::AbstractAnalyzerOptions, i::Integer) -> String
Return the name of silenced entry `i` (zero-based).
"""
function getSilencedCheckerOrPackage(x::AbstractAnalyzerOptions, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumSilencedCheckersAndPackages(x) "silenced index $i is out of range."
    return get_string(clang_AnalyzerOptions_getSilencedCheckerOrPackage(x, i))
end

# Config
"""
    setConfig(x::AbstractAnalyzerOptions, key, value) -> Nothing
Set one `-analyzer-config key=value` pair, replacing any previous value for `key`.
"""
function setConfig(x::AbstractAnalyzerOptions, key::AbstractString, value::AbstractString)
    @check_ptrs x
    return clang_AnalyzerOptions_setConfig(x, key, value)
end

"""
    getConfig(x::AbstractAnalyzerOptions, key) -> String
Return the value recorded for `key`, or `""` when there is none. An explicitly empty value
is indistinguishable from an absent key, which is also how clang's own readers treat it.
"""
function getConfig(x::AbstractAnalyzerOptions, key::AbstractString)
    @check_ptrs x
    return get_string(clang_AnalyzerOptions_getConfig(x, key))
end

"""
    getNumConfigEntries(x::AbstractAnalyzerOptions) -> UInt32
Return how many `-analyzer-config` pairs are recorded.
"""
function getNumConfigEntries(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getNumConfigEntries(x)
end

"""
    getConfigKey(x::AbstractAnalyzerOptions, i::Integer) -> String
Return the key of config entry `i` (zero-based).

The order is the underlying `StringMap`'s bucket order — unspecified, but stable between
two calls that do not mutate the table, so `getConfigKey(x, i)` and `getConfigValue(x, i)`
always name the same entry.
"""
function getConfigKey(x::AbstractAnalyzerOptions, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumConfigEntries(x) "config index $i is out of range."
    return get_string(clang_AnalyzerOptions_getConfigKey(x, i))
end

"""
    getConfigValue(x::AbstractAnalyzerOptions, i::Integer) -> String
Return the value of config entry `i` (zero-based); see [`getConfigKey`](@ref) for the
ordering.
"""
function getConfigValue(x::AbstractAnalyzerOptions, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumConfigEntries(x) "config index $i is out of range."
    return get_string(clang_AnalyzerOptions_getConfigValue(x, i))
end

# Scalar knobs
"""
    getAnalysisDiagOpt(x::AbstractAnalyzerOptions) -> CXAnalysisDiagClients
Return which path-diagnostic client renders the results (`-analyzer-output`). `PD_TEXT` and
`PD_TEXT_MINIMAL` route through the instance's `DiagnosticsEngine`; the rest write files.
"""
function getAnalysisDiagOpt(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getAnalysisDiagOpt(x)
end

"""
    setAnalysisDiagOpt(x::AbstractAnalyzerOptions, value::CXAnalysisDiagClients) -> Nothing
Choose the path-diagnostic client.
"""
function setAnalysisDiagOpt(x::AbstractAnalyzerOptions, value::CXAnalysisDiagClients)
    @check_ptrs x
    return clang_AnalyzerOptions_setAnalysisDiagOpt(x, value)
end

"""
    getAnalysisConstraintsOpt(x::AbstractAnalyzerOptions) -> CXAnalysisConstraints
Return the constraint solver the engine uses.
"""
function getAnalysisConstraintsOpt(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getAnalysisConstraintsOpt(x)
end

"""
    setAnalysisConstraintsOpt(x::AbstractAnalyzerOptions, value::CXAnalysisConstraints) -> Nothing
Choose the constraint solver. `Z3ConstraintsModel` only works in a build configured with
Z3; the range model is the default everywhere.
"""
function setAnalysisConstraintsOpt(x::AbstractAnalyzerOptions, value::CXAnalysisConstraints)
    @check_ptrs x
    return clang_AnalyzerOptions_setAnalysisConstraintsOpt(x, value)
end

"""
    getAnalyzeSpecificFunction(x::AbstractAnalyzerOptions) -> String
Return the single function the analysis is restricted to, or `""` for no restriction.
"""
function getAnalyzeSpecificFunction(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return get_string(clang_AnalyzerOptions_getAnalyzeSpecificFunction(x))
end

"""
    setAnalyzeSpecificFunction(x::AbstractAnalyzerOptions, value) -> Nothing
Restrict the analysis to one function; `""` lifts the restriction.
"""
function setAnalyzeSpecificFunction(x::AbstractAnalyzerOptions, value::AbstractString)
    @check_ptrs x
    return clang_AnalyzerOptions_setAnalyzeSpecificFunction(x, value)
end

"""
    getDumpExplodedGraphTo(x::AbstractAnalyzerOptions) -> String
Return the file the exploded graph is dumped to, or `""` when it is not dumped.
"""
function getDumpExplodedGraphTo(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return get_string(clang_AnalyzerOptions_getDumpExplodedGraphTo(x))
end

"""
    setDumpExplodedGraphTo(x::AbstractAnalyzerOptions, value) -> Nothing
Dump the exploded graph to `value`; `""` turns the dump off.
"""
function setDumpExplodedGraphTo(x::AbstractAnalyzerOptions, value::AbstractString)
    @check_ptrs x
    return clang_AnalyzerOptions_setDumpExplodedGraphTo(x, value)
end

"""
    getMaxBlockVisitOnPath(x::AbstractAnalyzerOptions) -> UInt32
Return the cap on how many times the engine revisits one basic block along a path (clang
spells the field `maxBlockVisitOnPath`).
"""
function getMaxBlockVisitOnPath(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getMaxBlockVisitOnPath(x)
end

"""
    setMaxBlockVisitOnPath(x::AbstractAnalyzerOptions, value::Integer) -> Nothing
Set the per-path block revisit cap.
"""
function setMaxBlockVisitOnPath(x::AbstractAnalyzerOptions, value::Integer)
    @check_ptrs x
    return clang_AnalyzerOptions_setMaxBlockVisitOnPath(x, value)
end

"""
    getDisableAllCheckers(x::AbstractAnalyzerOptions) -> Bool
Return whether every checker is disabled — the code is still parsed and the flags still
validated, but nothing checks it.
"""
function getDisableAllCheckers(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getDisableAllCheckers(x)
end

"""
    setDisableAllCheckers(x::AbstractAnalyzerOptions, value::Bool) -> Nothing
Disable (or re-enable) every checker at once.
"""
function setDisableAllCheckers(x::AbstractAnalyzerOptions, value::Bool)
    @check_ptrs x
    return clang_AnalyzerOptions_setDisableAllCheckers(x, value)
end

"""
    getAnalyzeAll(x::AbstractAnalyzerOptions) -> Bool
Return whether every function is analysed as a top-level entry point, rather than only
those not reached by inlining.
"""
function getAnalyzeAll(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getAnalyzeAll(x)
end

"""
    setAnalyzeAll(x::AbstractAnalyzerOptions, value::Bool) -> Nothing
Analyse every function as a top-level entry point.
"""
function setAnalyzeAll(x::AbstractAnalyzerOptions, value::Bool)
    @check_ptrs x
    return clang_AnalyzerOptions_setAnalyzeAll(x, value)
end

"""
    getAnalyzerWerror(x::AbstractAnalyzerOptions) -> Bool
Return whether analyzer warnings are emitted as errors.
"""
function getAnalyzerWerror(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getAnalyzerWerror(x)
end

"""
    setAnalyzerWerror(x::AbstractAnalyzerOptions, value::Bool) -> Nothing
Emit analyzer warnings as errors.
"""
function setAnalyzerWerror(x::AbstractAnalyzerOptions, value::Bool)
    @check_ptrs x
    return clang_AnalyzerOptions_setAnalyzerWerror(x, value)
end

"""
    getShouldEmitErrorsOnInvalidConfigValue(x::AbstractAnalyzerOptions) -> Bool
Return whether an unrecognised or malformed `-analyzer-config` value is an error rather
than a silently ignored setting.
"""
function getShouldEmitErrorsOnInvalidConfigValue(x::AbstractAnalyzerOptions)
    @check_ptrs x
    return clang_AnalyzerOptions_getShouldEmitErrorsOnInvalidConfigValue(x)
end

"""
    setShouldEmitErrorsOnInvalidConfigValue(x::AbstractAnalyzerOptions, value::Bool) -> Nothing
Report invalid `-analyzer-config` values as errors.
"""
function setShouldEmitErrorsOnInvalidConfigValue(x::AbstractAnalyzerOptions, value::Bool)
    @check_ptrs x
    return clang_AnalyzerOptions_setShouldEmitErrorsOnInvalidConfigValue(x, value)
end
