# DiagnosticConsumer
function BeginSourceFile(consumer::AbstractDiagnosticConsumer, lang::LangOptions,
                         pp::Preprocessor)
    @check_ptrs consumer lang pp
    clang_DiagnosticConsumer_BeginSourceFile(consumer, lang, pp)
    return nothing
end

function EndSourceFile(consumer::AbstractDiagnosticConsumer)
    @check_ptrs consumer
    clang_DiagnosticConsumer_EndSourceFile(consumer)
    return nothing
end

dispose(x::AbstractDiagnosticConsumer) = clang_DiagnosticConsumer_dispose(x)

# IgnoringDiagConsumer
IgnoringDiagConsumer() = IgnoringDiagConsumer(create_ignoring_diagnostic_consumer())

"""
    create_ignoring_diagnostic_consumer() -> CXDiagnosticConsumer
Return a pointer to a `clang::IgnoringDiagConsumer` object.
"""
function create_ignoring_diagnostic_consumer()
    consumer = clang_IgnoringDiagConsumer_create()
    @assert consumer != C_NULL "Failed to create IgnoringDiagConsumer"
    return consumer
end

# DiagnosticsEngine
DiagnosticsEngine() = DiagnosticsEngine(create_diagnostics_engine())

function DiagnosticsEngine(opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    ids = create_diagnostic_ids()
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return DiagnosticsEngine(engine)
end

function DiagnosticsEngine(ids::DiagnosticIDs, opts::DiagnosticOptions,
                           client::AbstractDiagnosticConsumer=TextDiagnosticPrinter(opts),
                           should_own_client=true)
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return DiagnosticsEngine(engine)
end

"""
    create_diagnostics_engine() -> CXDiagnosticsEngine
Return a pointer to a `clang::DiagnosticsEngine` object.
"""
function create_diagnostics_engine()
    ids = create_diagnostic_ids()
    opts = DiagnosticOptions()
    client = TextDiagnosticPrinter(opts)
    should_own_client = true
    engine = clang_DiagnosticsEngine_create(ids, opts, client, should_own_client)
    @assert engine != C_NULL "Failed to create DiagnosticsEngine"
    return engine
end

dispose(x::DiagnosticsEngine) = clang_DiagnosticsEngine_dispose(x)

function setShowColors(x::DiagnosticsEngine, should_show::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setShowColors(x, should_show)
end


# DiagnosticConsumer (counts & lifecycle)
function getNumErrors(x::AbstractDiagnosticConsumer)
    @check_ptrs x
    return clang_DiagnosticConsumer_getNumErrors(x)
end

function getNumWarnings(x::AbstractDiagnosticConsumer)
    @check_ptrs x
    return clang_DiagnosticConsumer_getNumWarnings(x)
end

function clear(x::AbstractDiagnosticConsumer)
    @check_ptrs x
    return clang_DiagnosticConsumer_clear(x)
end

function finish(x::AbstractDiagnosticConsumer)
    @check_ptrs x
    return clang_DiagnosticConsumer_finish(x)
end

function IncludeInDiagnosticCounts(x::AbstractDiagnosticConsumer)
    @check_ptrs x
    return clang_DiagnosticConsumer_IncludeInDiagnosticCounts(x)
end

# DiagnosticsEngine (state, counts & severity mapping)
function getDiagnosticIDs(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return DiagnosticIDs(clang_DiagnosticsEngine_getDiagnosticIDs(x))
end

function getDiagnosticOptions(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return DiagnosticOptions(clang_DiagnosticsEngine_getDiagnosticOptions(x))
end

function getClient(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return DiagnosticConsumer(clang_DiagnosticsEngine_getClient(x))
end

function ownsClient(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_ownsClient(x)
end

function hasSourceManager(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasSourceManager(x)
end

function getSourceManager(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    @assert hasSourceManager(x) "DiagnosticsEngine has no source manager."
    return SourceManager(clang_DiagnosticsEngine_getSourceManager(x))
end

function setSourceManager(x::AbstractDiagnosticsEngine, src_mgr::SourceManager)
    @check_ptrs x src_mgr
    return clang_DiagnosticsEngine_setSourceManager(x, src_mgr)
end

function pushMappings(x::AbstractDiagnosticsEngine, loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_pushMappings(x, loc)
end

function popMappings(x::AbstractDiagnosticsEngine, loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_popMappings(x, loc)
end

"""
    setClient(x::AbstractDiagnosticsEngine, client::AbstractDiagnosticConsumer, should_own_client=true)
Set the diagnostic client. When `should_own_client` is `true` the engine adopts `client` and one
should NOT call `dispose` on it afterwards.
"""
function setClient(x::AbstractDiagnosticsEngine, client::AbstractDiagnosticConsumer,
                   should_own_client::Bool=true)
    @check_ptrs x client
    return clang_DiagnosticsEngine_setClient(x, client, should_own_client)
end

function setErrorLimit(x::AbstractDiagnosticsEngine, limit::Integer)
    @check_ptrs x
    return clang_DiagnosticsEngine_setErrorLimit(x, limit)
end

function setTemplateBacktraceLimit(x::AbstractDiagnosticsEngine, limit::Integer)
    @check_ptrs x
    return clang_DiagnosticsEngine_setTemplateBacktraceLimit(x, limit)
end

function getTemplateBacktraceLimit(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getTemplateBacktraceLimit(x)
end

function setConstexprBacktraceLimit(x::AbstractDiagnosticsEngine, limit::Integer)
    @check_ptrs x
    return clang_DiagnosticsEngine_setConstexprBacktraceLimit(x, limit)
end

function getConstexprBacktraceLimit(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getConstexprBacktraceLimit(x)
end

function setIgnoreAllWarnings(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setIgnoreAllWarnings(x, val)
end

function getIgnoreAllWarnings(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getIgnoreAllWarnings(x)
end

function setEnableAllWarnings(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setEnableAllWarnings(x, val)
end

function getEnableAllWarnings(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getEnableAllWarnings(x)
end

function setWarningsAsErrors(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setWarningsAsErrors(x, val)
end

function getWarningsAsErrors(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getWarningsAsErrors(x)
end

function setErrorsAsFatal(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setErrorsAsFatal(x, val)
end

function getErrorsAsFatal(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getErrorsAsFatal(x)
end

function setFatalsAsError(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setFatalsAsError(x, val)
end

function getFatalsAsError(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getFatalsAsError(x)
end

function setSuppressSystemWarnings(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setSuppressSystemWarnings(x, val)
end

function getSuppressSystemWarnings(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getSuppressSystemWarnings(x)
end

function setSuppressAllDiagnostics(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setSuppressAllDiagnostics(x, val)
end

function getSuppressAllDiagnostics(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getSuppressAllDiagnostics(x)
end

function setElideType(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setElideType(x, val)
end

function getElideType(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getElideType(x)
end

function setPrintTemplateTree(x::AbstractDiagnosticsEngine, val::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setPrintTemplateTree(x, val)
end

function getPrintTemplateTree(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getPrintTemplateTree(x)
end

function getShowColors(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getShowColors(x)
end

function setShowOverloads(x::AbstractDiagnosticsEngine, val::CXOverloadsShown)
    @check_ptrs x
    return clang_DiagnosticsEngine_setShowOverloads(x, val)
end

function getShowOverloads(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getShowOverloads(x)
end

function getNumOverloadCandidatesToShow(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getNumOverloadCandidatesToShow(x)
end

function setLastDiagnosticIgnored(x::AbstractDiagnosticsEngine, ignored::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setLastDiagnosticIgnored(x, ignored)
end

function isLastDiagnosticIgnored(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_isLastDiagnosticIgnored(x)
end

function setExtensionHandlingBehavior(x::AbstractDiagnosticsEngine, severity::CXDiag_Severity)
    @check_ptrs x
    return clang_DiagnosticsEngine_setExtensionHandlingBehavior(x, severity)
end

function getExtensionHandlingBehavior(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getExtensionHandlingBehavior(x)
end

function setSeverity(x::AbstractDiagnosticsEngine, diag_id::Integer, severity::CXDiag_Severity,
                     loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_setSeverity(x, diag_id, severity, loc)
end

"""
    setSeverityForGroup(x::AbstractDiagnosticsEngine, flavor, group, severity, loc=SourceLocation()) -> Bool
Return `true` (and ignore the request) if `group` is unknown, `false` otherwise.
"""
function setSeverityForGroup(x::AbstractDiagnosticsEngine, flavor::CXDiag_Flavor,
                             group::AbstractString, severity::CXDiag_Severity,
                             loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_setSeverityForGroup(x, flavor, group, severity, loc)
end

"""
    setDiagnosticGroupWarningAsError(x::AbstractDiagnosticsEngine, group, enabled) -> Bool
Return `true` if `group` is unknown, `false` otherwise.
"""
function setDiagnosticGroupWarningAsError(x::AbstractDiagnosticsEngine, group::AbstractString,
                                          enabled::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setDiagnosticGroupWarningAsError(x, group, enabled)
end

"""
    setDiagnosticGroupErrorAsFatal(x::AbstractDiagnosticsEngine, group, enabled) -> Bool
Return `true` if `group` is unknown, `false` otherwise.
"""
function setDiagnosticGroupErrorAsFatal(x::AbstractDiagnosticsEngine, group::AbstractString,
                                        enabled::Bool)
    @check_ptrs x
    return clang_DiagnosticsEngine_setDiagnosticGroupErrorAsFatal(x, group, enabled)
end

function setSeverityForAll(x::AbstractDiagnosticsEngine, flavor::CXDiag_Flavor,
                           severity::CXDiag_Severity, loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_setSeverityForAll(x, flavor, severity, loc)
end

function hasErrorOccurred(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasErrorOccurred(x)
end

function hasUncompilableErrorOccurred(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasUncompilableErrorOccurred(x)
end

function hasFatalErrorOccurred(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasFatalErrorOccurred(x)
end

function hasUnrecoverableErrorOccurred(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasUnrecoverableErrorOccurred(x)
end

function getNumErrors(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getNumErrors(x)
end

function getNumWarnings(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_getNumWarnings(x)
end

function setNumWarnings(x::AbstractDiagnosticsEngine, num_warnings::Integer)
    @check_ptrs x
    return clang_DiagnosticsEngine_setNumWarnings(x, num_warnings)
end

"""
    getCustomDiagID(x::AbstractDiagnosticsEngine, level::CXDiagnosticsEngine_Level, format::AbstractString)
Return an ID for a custom diagnostic with the given level and format string; the diagnostic is
registered on the first request.
"""
function getCustomDiagID(x::AbstractDiagnosticsEngine, level::CXDiagnosticsEngine_Level,
                         format::AbstractString)
    @check_ptrs x
    return clang_DiagnosticsEngine_getCustomDiagID(x, level, format)
end

function Reset(x::AbstractDiagnosticsEngine, soft::Bool=false)
    @check_ptrs x
    return clang_DiagnosticsEngine_Reset(x, soft)
end

function isIgnored(x::AbstractDiagnosticsEngine, diag_id::Integer,
                   loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_isIgnored(x, diag_id, loc)
end

function getDiagnosticLevel(x::AbstractDiagnosticsEngine, diag_id::Integer,
                            loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return clang_DiagnosticsEngine_getDiagnosticLevel(x, diag_id, loc)
end

"""
    Report(x::AbstractDiagnosticsEngine, loc::SourceLocation, diag_id::Integer)
Issue the diagnostic `diag_id` at `loc` to the client. The diagnostic is emitted immediately and
carries no format arguments, so its format string must not contain `%N` placeholders.
"""
function Report(x::AbstractDiagnosticsEngine, loc::SourceLocation, diag_id::Integer)
    @check_ptrs x
    return clang_DiagnosticsEngine_Report(x, loc, diag_id)
end

function isDiagnosticInFlight(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_isDiagnosticInFlight(x)
end

function Clear(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_Clear(x)
end

function getFlagValue(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return unsafe_string(clang_DiagnosticsEngine_getFlagValue(x))
end


# DiagnosticsEngine (overload display, extension silencing & prior-diagnostic notes)
"""
    overloadCandidatesShown(x::AbstractDiagnosticsEngine, n::Integer)
Record that `n` overload candidates were just shown. Showing more than four permanently lowers
the number `getNumOverloadCandidatesToShow` reports for this engine.
"""
function overloadCandidatesShown(x::AbstractDiagnosticsEngine, n::Integer)
    @check_ptrs x
    clang_DiagnosticsEngine_overloadCandidatesShown(x, n)
    return nothing
end

"""
    IncrementAllExtensionsSilenced(x::AbstractDiagnosticsEngine)
Silence every extension diagnostic until the matching `DecrementAllExtensionsSilenced`, the way
entering an `__extension__` block does.
"""
function IncrementAllExtensionsSilenced(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    clang_DiagnosticsEngine_IncrementAllExtensionsSilenced(x)
    return nothing
end

"""
    DecrementAllExtensionsSilenced(x::AbstractDiagnosticsEngine)
Undo one `IncrementAllExtensionsSilenced`. Clang counts the nesting in an `unsigned char`, so a
decrement below zero wraps around and silences every extension diagnostic for good; the
assertion rejects that unpaired call.
"""
function DecrementAllExtensionsSilenced(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    @assert hasAllExtensionsSilenced(x) "no matching IncrementAllExtensionsSilenced to undo"
    clang_DiagnosticsEngine_DecrementAllExtensionsSilenced(x)
    return nothing
end

function hasAllExtensionsSilenced(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    return clang_DiagnosticsEngine_hasAllExtensionsSilenced(x)
end

"""
    notePriorDiagnosticFrom(x::AbstractDiagnosticsEngine, other::AbstractDiagnosticsEngine)
Copy `other`'s last-diagnostic level into `x`, so a note issued on `x` continues at the level of
the diagnostic `other` emitted.
"""
function notePriorDiagnosticFrom(x::AbstractDiagnosticsEngine, other::AbstractDiagnosticsEngine)
    @check_ptrs x other
    clang_DiagnosticsEngine_notePriorDiagnosticFrom(x, other)
    return nothing
end

# DiagnosticErrorTrap
"""
    DiagnosticErrorTrap(engine::AbstractDiagnosticsEngine) -> DiagnosticErrorTrap
Snapshot `engine`'s error counters so that errors emitted afterwards can be detected.

The trap holds a reference to `engine`, which must outlive it. This function allocates and one
should call `dispose` to release the resources after using this object.
"""
function DiagnosticErrorTrap(engine::AbstractDiagnosticsEngine)
    @check_ptrs engine
    trap = clang_DiagnosticErrorTrap_create(engine)
    @assert trap != C_NULL "Failed to create DiagnosticErrorTrap"
    return DiagnosticErrorTrap(trap)
end

function hasErrorOccurred(x::AbstractDiagnosticErrorTrap)
    @check_ptrs x
    return clang_DiagnosticErrorTrap_hasErrorOccurred(x)
end

function hasUnrecoverableErrorOccurred(x::AbstractDiagnosticErrorTrap)
    @check_ptrs x
    return clang_DiagnosticErrorTrap_hasUnrecoverableErrorOccurred(x)
end

"""
    reset(x::AbstractDiagnosticErrorTrap)
Re-snapshot the engine's counters, returning the trap to its "no errors occurred" state.
"""
function reset(x::AbstractDiagnosticErrorTrap)
    @check_ptrs x
    clang_DiagnosticErrorTrap_reset(x)
    return nothing
end

dispose(x::AbstractDiagnosticErrorTrap) = clang_DiagnosticErrorTrap_dispose(x)

# StoredDiagnostic
"""
    StoredDiagnostic(level::CXDiagnosticsEngine_Level, id::Integer, message::AbstractString)
Return a `clang::StoredDiagnostic` holding `message` for diagnostic `id` at `level`. The record
carries no location, ranges or fix-it hints; attach a location with `setLocation`.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function StoredDiagnostic(level::CXDiagnosticsEngine_Level, id::Integer, message::AbstractString)
    sd = clang_StoredDiagnostic_create(level, id, message)
    @assert sd != C_NULL "Failed to create StoredDiagnostic"
    return StoredDiagnostic(sd)
end

function getID(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return clang_StoredDiagnostic_getID(x)
end

function getLevel(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return clang_StoredDiagnostic_getLevel(x)
end

"""
    getLocation(x::AbstractStoredDiagnostic) -> SourceLocation
Return the `SourceLocation` half of the stored `FullSourceLoc`. Its `SourceManager` half comes
from `getLocationManager`.
"""
function getLocation(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return SourceLocation(clang_StoredDiagnostic_getLocation(x))
end

"""
    getLocationManager(x::AbstractStoredDiagnostic) -> SourceManager
Return the `SourceManager` half of the stored `FullSourceLoc`. The carrier holds `C_NULL` when
the diagnostic's location was never given a source manager.
"""
function getLocationManager(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return SourceManager(clang_StoredDiagnostic_getLocationManager(x))
end

function getMessage(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return unsafe_string(clang_StoredDiagnostic_getMessage(x))
end

"""
    setLocation(x::AbstractStoredDiagnostic, loc::SourceLocation, src_mgr::AbstractSourceManager)
Store `loc` together with `src_mgr` as the diagnostic's `FullSourceLoc`. Only the address of
`src_mgr` is kept, so it must outlive `x`.
"""
function setLocation(x::AbstractStoredDiagnostic, loc::SourceLocation, src_mgr::AbstractSourceManager)
    @check_ptrs x src_mgr
    clang_StoredDiagnostic_setLocation(x, loc, src_mgr)
    return nothing
end

function range_size(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return clang_StoredDiagnostic_range_size(x)
end

function fixit_size(x::AbstractStoredDiagnostic)
    @check_ptrs x
    return clang_StoredDiagnostic_fixit_size(x)
end

dispose(x::AbstractStoredDiagnostic) = clang_StoredDiagnostic_dispose(x)
