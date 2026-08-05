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


# ForwardingDiagnosticConsumer
"""
    ForwardingDiagnosticConsumer(target::AbstractDiagnosticConsumer) -> ForwardingDiagnosticConsumer
Return a consumer that relays every diagnostic to `target`. Only a reference to `target` is
kept, so it must outlive the returned consumer.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function ForwardingDiagnosticConsumer(target::AbstractDiagnosticConsumer)
    @check_ptrs target
    consumer = clang_ForwardingDiagnosticConsumer_create(target)
    @assert consumer != C_NULL "Failed to create ForwardingDiagnosticConsumer"
    return ForwardingDiagnosticConsumer(consumer)
end

"""
    takeClient(x::AbstractDiagnosticsEngine) -> DiagnosticConsumer
Hand ownership of the engine's client back to the caller. The engine goes on using the same
consumer, so keep it alive until `x` is disposed and only then `dispose` it.

`clang::DiagnosticsEngine` hands back an empty owner when it never owned its client, so
`ownsClient` is restated here.
"""
function takeClient(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    @assert ownsClient(x) "engine does not own its diagnostic client"
    return DiagnosticConsumer(clang_DiagnosticsEngine_takeClient(x))
end

"""
    StoredDiagnostic(level::CXDiagnosticsEngine_Level, id::Integer, message::AbstractString,
                     loc::SourceLocation, src_mgr::AbstractSourceManager,
                     ranges::AbstractVector{SourceRange}, range_is_token::AbstractVector{Bool},
                     fixits::AbstractVector{<:AbstractFixItHint}) -> StoredDiagnostic
Return a `clang::StoredDiagnostic` carrying a location, source ranges and fix-it hints. Each
range is paired elementwise with `range_is_token` (`true` marks a range that ends at the start
of its last token, `false` a character range), and both the ranges and the hints are copied
into the record. Only the address of `src_mgr` is kept, so it must outlive the result.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function StoredDiagnostic(level::CXDiagnosticsEngine_Level, id::Integer, message::AbstractString,
                          loc::SourceLocation, src_mgr::AbstractSourceManager,
                          ranges::AbstractVector{SourceRange},
                          range_is_token::AbstractVector{Bool},
                          fixits::AbstractVector{<:AbstractFixItHint})
    @check_ptrs src_mgr
    @assert length(ranges) == length(range_is_token) "each range needs a token-range flag"
    raw_ranges = CXSourceRange_[CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr) for r in ranges]
    raw_flags = collect(Bool, range_is_token)
    raw_fixits = CXFixItHint[Base.unsafe_convert(CXFixItHint, h) for h in fixits]
    sd = clang_StoredDiagnostic_createWithRangesAndFixIts(level, id, message, loc, src_mgr,
                                                          raw_ranges, raw_flags,
                                                          length(raw_ranges), raw_fixits,
                                                          length(raw_fixits))
    @assert sd != C_NULL "Failed to create StoredDiagnostic"
    return StoredDiagnostic(sd)
end

"""
    getRange(x::AbstractStoredDiagnostic, index::Integer) -> SourceRange
Return the 0-based `index`-th source range attached to the diagnostic. Pair it with
`isRangeTokenRange` to recover whether the range ends at the start of its last token.

`clang::StoredDiagnostic` indexes its range vector unchecked, so the bound is restated here.
"""
function getRange(x::AbstractStoredDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < range_size(x) "range index out of bounds"
    r = clang_StoredDiagnostic_getRange(x, index)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    isRangeTokenRange(x::AbstractStoredDiagnostic, index::Integer) -> Bool
Return whether the 0-based `index`-th range ends at the start of its last token rather than at
its last character.

`clang::StoredDiagnostic` indexes its range vector unchecked, so the bound is restated here.
"""
function isRangeTokenRange(x::AbstractStoredDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < range_size(x) "range index out of bounds"
    return clang_StoredDiagnostic_isRangeTokenRange(x, index)
end

"""
    getFixIt(x::AbstractStoredDiagnostic, index::Integer) -> FixItHint
Return a borrowed carrier for the 0-based `index`-th fix-it hint. It points into the
diagnostic's own storage and dies with it — never `dispose` it.

`clang::StoredDiagnostic` indexes its hint vector unchecked, so the bound is restated here.
"""
function getFixIt(x::AbstractStoredDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < fixit_size(x) "fix-it index out of bounds"
    return FixItHint(clang_StoredDiagnostic_getFixIt(x, index))
end

# FixItHint
"""
    FixItHint() -> FixItHint
Return an empty code-modification hint: `isNull` is true and it carries neither a range nor
replacement text.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function FixItHint()
    hint = clang_FixItHint_create()
    @assert hint != C_NULL "Failed to create FixItHint"
    return FixItHint(hint)
end

function isNull(x::AbstractFixItHint)
    @check_ptrs x
    return clang_FixItHint_isNull(x)
end

"""
    CreateInsertion(loc::SourceLocation, code::AbstractString, before::Bool=false) -> FixItHint
Return a hint that inserts `code` at `loc`. Its remove range is the empty *character* range at
`loc`, so `isRemoveRangeTokenRange` is false. Set `before` to place this text ahead of
insertions already recorded at the same location.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateInsertion(loc::SourceLocation, code::AbstractString, before::Bool=false)
    hint = clang_FixItHint_CreateInsertion(loc, code, before)
    @assert hint != C_NULL "Failed to create FixItHint"
    return FixItHint(hint)
end

"""
    CreateInsertionFromRange(loc::SourceLocation, from_range::SourceRange, is_token_range::Bool,
                             before::Bool=false) -> FixItHint
Return a hint that inserts, at `loc`, the text already spelled at `from_range`.
`is_token_range` says whether `from_range` ends at the start of its last token.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateInsertionFromRange(loc::SourceLocation, from_range::SourceRange,
                                  is_token_range::Bool, before::Bool=false)
    r = CXSourceRange_(from_range.begin_loc.ptr, from_range.end_loc.ptr)
    hint = clang_FixItHint_CreateInsertionFromRange(loc, r, is_token_range, before)
    @assert hint != C_NULL "Failed to create FixItHint"
    return FixItHint(hint)
end

"""
    CreateRemoval(range::SourceRange, is_token_range::Bool=true) -> FixItHint
Return a hint that deletes the text covered by `range`. `is_token_range` says whether `range`
ends at the start of its last token.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateRemoval(range::SourceRange, is_token_range::Bool=true)
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    hint = clang_FixItHint_CreateRemoval(r, is_token_range)
    @assert hint != C_NULL "Failed to create FixItHint"
    return FixItHint(hint)
end

"""
    CreateReplacement(range::SourceRange, is_token_range::Bool, code::AbstractString) -> FixItHint
Return a hint that replaces the text covered by `range` with `code`. `is_token_range` says
whether `range` ends at the start of its last token.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function CreateReplacement(range::SourceRange, is_token_range::Bool, code::AbstractString)
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    hint = clang_FixItHint_CreateReplacement(r, is_token_range, code)
    @assert hint != C_NULL "Failed to create FixItHint"
    return FixItHint(hint)
end

"""
    getRemoveRange(x::AbstractFixItHint) -> SourceRange
Return the range the hint rewrites — the empty range at the insertion point for an insertion
hint, and an invalid range for a null hint.
"""
function getRemoveRange(x::AbstractFixItHint)
    @check_ptrs x
    r = clang_FixItHint_getRemoveRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isRemoveRangeTokenRange(x::AbstractFixItHint)
    @check_ptrs x
    return clang_FixItHint_isRemoveRangeTokenRange(x)
end

"""
    getInsertFromRange(x::AbstractFixItHint) -> SourceRange
Return the range whose spelling is copied to the insertion point. It is invalid unless the hint
came from `CreateInsertionFromRange`.
"""
function getInsertFromRange(x::AbstractFixItHint)
    @check_ptrs x
    r = clang_FixItHint_getInsertFromRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isInsertFromRangeTokenRange(x::AbstractFixItHint)
    @check_ptrs x
    return clang_FixItHint_isInsertFromRangeTokenRange(x)
end

function getCodeToInsert(x::AbstractFixItHint)
    @check_ptrs x
    return unsafe_string(clang_FixItHint_getCodeToInsert(x))
end

function getBeforePreviousInsertions(x::AbstractFixItHint)
    @check_ptrs x
    return clang_FixItHint_getBeforePreviousInsertions(x)
end

dispose(x::AbstractFixItHint) = clang_FixItHint_dispose(x)


# DiagnosticBuilder
"""
    DiagnosticBuilder(x::AbstractDiagnosticsEngine, loc::SourceLocation, diag_id::Integer) -> DiagnosticBuilder
Open the diagnostic `diag_id` at `loc` on `x` and leave it in flight. The arguments, ranges and
fix-it hints added to the builder land in the engine's own storage, where a `Diagnostic` reads
them back.

`clang::DiagnosticsEngine::Report` asserts that no other diagnostic is already in flight, so
that is restated here.

This function allocates and one should call `dispose` to release the resources after using this
object — disposal also emits the diagnostic to the engine's client.
"""
function DiagnosticBuilder(x::AbstractDiagnosticsEngine, loc::SourceLocation, diag_id::Integer)
    @check_ptrs x
    @assert !isDiagnosticInFlight(x) "the engine already has a diagnostic in flight"
    builder = clang_DiagnosticBuilder_create(x, loc, diag_id)
    @assert builder != C_NULL "Failed to create DiagnosticBuilder"
    return DiagnosticBuilder(builder)
end

"""
    dispose(x::AbstractDiagnosticBuilder)
Emit the diagnostic to the engine's client and release the builder. The engine has no
diagnostic in flight afterwards.
"""
dispose(x::AbstractDiagnosticBuilder) = clang_DiagnosticBuilder_dispose(x)

# StreamingDiagnostic
"""
    AddTaggedVal(x::AbstractStreamingDiagnostic, val::Integer, kind::CXDiagnosticsEngine_ArgumentKind)
Append one non-string format argument, `val` carrying the payload `kind` describes — a number
for `ak_sint`/`ak_uint`, a `clang::TokenKind` for `ak_tokenkind`, and the address of the object
for the pointer kinds. Negative values are stored in two's complement, which is how
`getArgSInt` reads them back.

At most ten arguments fit in one diagnostic; `clang::StreamingDiagnostic` asserts on the
eleventh and a builder exposes no count to check against, so that bound stays a documented
precondition.
"""
function AddTaggedVal(x::AbstractStreamingDiagnostic, val::Integer,
                      kind::CXDiagnosticsEngine_ArgumentKind)
    @check_ptrs x
    @assert kind != CXDiagnosticsEngine_ak_std_string "use AddString for a string argument"
    return clang_StreamingDiagnostic_AddTaggedVal(x, val % UInt64, kind)
end

"""
    AddString(x::AbstractStreamingDiagnostic, val::AbstractString)
Append one `CXDiagnosticsEngine_ak_std_string` format argument, copying `val` into the
diagnostic's own storage.

At most ten arguments fit in one diagnostic; `clang::StreamingDiagnostic` asserts on the
eleventh and a builder exposes no count to check against, so that bound stays a documented
precondition.
"""
function AddString(x::AbstractStreamingDiagnostic, val::AbstractString)
    @check_ptrs x
    return clang_StreamingDiagnostic_AddString(x, val)
end

"""
    AddSourceRange(x::AbstractStreamingDiagnostic, range::SourceRange, is_token_range::Bool)
Attach `range` to the diagnostic. `is_token_range` says whether it ends at the start of its
last token rather than at its last character.
"""
function AddSourceRange(x::AbstractStreamingDiagnostic, range::SourceRange,
                        is_token_range::Bool)
    @check_ptrs x
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    return clang_StreamingDiagnostic_AddSourceRange(x, r, is_token_range)
end

"""
    AddFixItHint(x::AbstractStreamingDiagnostic, hint::AbstractFixItHint)
Copy `hint` into the diagnostic; a null hint is dropped. The caller keeps ownership of `hint`.
"""
function AddFixItHint(x::AbstractStreamingDiagnostic, hint::AbstractFixItHint)
    @check_ptrs x hint
    return clang_StreamingDiagnostic_AddFixItHint(x, hint)
end

# Diagnostic
"""
    Diagnostic(x::AbstractDiagnosticsEngine) -> Diagnostic
Return a view onto the diagnostic `x` currently has in flight. It reads straight through to the
engine, so it must not outlive it and its accessors describe whichever diagnostic is open when
they are called.

This function allocates and one should call `dispose` to release the resources after using this
object.
"""
function Diagnostic(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    diag = clang_Diagnostic_create(x)
    @assert diag != C_NULL "Failed to create Diagnostic"
    return Diagnostic(diag)
end

"""
    getID(x::AbstractDiagnostic) -> UInt32
Return the id of the diagnostic in flight, or `typemax(UInt32)` when the engine has none.
"""
function getID(x::AbstractDiagnostic)
    @check_ptrs x
    return clang_Diagnostic_getID(x)
end

"""
    getLocation(x::AbstractDiagnostic) -> SourceLocation
Return the location the diagnostic in flight was reported at; invalid when it was reported
without one.
"""
function getLocation(x::AbstractDiagnostic)
    @check_ptrs x
    return SourceLocation(clang_Diagnostic_getLocation(x))
end

function hasSourceManager(x::AbstractDiagnostic)
    @check_ptrs x
    return clang_Diagnostic_hasSourceManager(x)
end

"""
    getSourceManager(x::AbstractDiagnostic) -> SourceManager
Return the source manager the engine resolves diagnostic locations against.

`clang::DiagnosticsEngine::getSourceManager` asserts that one was set, so that is restated
here.
"""
function getSourceManager(x::AbstractDiagnostic)
    @check_ptrs x
    @assert hasSourceManager(x) "the diagnostics engine has no source manager"
    return SourceManager(clang_Diagnostic_getSourceManager(x))
end

"""
    getNumArgs(x::AbstractDiagnostic) -> UInt32
Return how many format arguments the diagnostic in flight carries. With nothing in flight this
is whatever the last diagnostic left behind.
"""
function getNumArgs(x::AbstractDiagnostic)
    @check_ptrs x
    return clang_Diagnostic_getNumArgs(x)
end

"""
    getArgKind(x::AbstractDiagnostic, index::Integer) -> CXDiagnosticsEngine_ArgumentKind
Return the kind of the 0-based `index`-th format argument, which selects the accessor that can
read it.

`clang::Diagnostic` asserts the bound, so it is restated here.
"""
function getArgKind(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < getNumArgs(x) "argument index out of bounds"
    return clang_Diagnostic_getArgKind(x, index)
end

"""
    getArgStdStr(x::AbstractDiagnostic, index::Integer) -> String
Return the 0-based `index`-th argument as the string it was added with. Only an
`ak_std_string` argument has one, so the kind is checked here.
"""
function getArgStdStr(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) == CXDiagnosticsEngine_ak_std_string "argument is not a std::string"
    return unsafe_string(clang_Diagnostic_getArgStdStr(x, index))
end

"""
    getArgSInt(x::AbstractDiagnostic, index::Integer) -> Int64
Return the 0-based `index`-th argument as a signed number. Only an `ak_sint` argument is one,
so the kind is checked here.
"""
function getArgSInt(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) == CXDiagnosticsEngine_ak_sint "argument is not a signed integer"
    return clang_Diagnostic_getArgSInt(x, index)
end

"""
    getArgUInt(x::AbstractDiagnostic, index::Integer) -> UInt64
Return the 0-based `index`-th argument as an unsigned number. Only an `ak_uint` argument is
one, so the kind is checked here.
"""
function getArgUInt(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) == CXDiagnosticsEngine_ak_uint "argument is not an unsigned integer"
    return clang_Diagnostic_getArgUInt(x, index)
end

"""
    getArgIdentifier(x::AbstractDiagnostic, index::Integer) -> IdentifierInfo
Return the 0-based `index`-th argument as the identifier it names. Only an `ak_identifierinfo`
argument is one, so the kind is checked here. The carrier borrows the interned identifier and
is never disposed.
"""
function getArgIdentifier(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) == CXDiagnosticsEngine_ak_identifierinfo "argument is not an identifier"
    return IdentifierInfo(clang_Diagnostic_getArgIdentifier(x, index))
end

"""
    getRawArg(x::AbstractDiagnostic, index::Integer) -> UInt64
Return the opaque payload of the 0-based `index`-th argument — the number itself for the
integer kinds, and the object's address for the pointer kinds. An `ak_std_string` argument
lives in separate storage and has no payload, so that kind is rejected here.
"""
function getRawArg(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) != CXDiagnosticsEngine_ak_std_string "a std::string argument has no raw payload"
    return clang_Diagnostic_getRawArg(x, index)
end

function getNumRanges(x::AbstractDiagnostic)
    @check_ptrs x
    return clang_Diagnostic_getNumRanges(x)
end

"""
    getRange(x::AbstractDiagnostic, index::Integer) -> SourceRange
Return the 0-based `index`-th source range attached to the diagnostic. Pair it with
`isRangeTokenRange` to learn whether it ends at the start of its last token.

`clang::Diagnostic` asserts the bound, so it is restated here.
"""
function getRange(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < getNumRanges(x) "range index out of bounds"
    r = clang_Diagnostic_getRange(x, index)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

"""
    isRangeTokenRange(x::AbstractDiagnostic, index::Integer) -> Bool
Return whether the 0-based `index`-th range ends at the start of its last token rather than at
its last character.
"""
function isRangeTokenRange(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < getNumRanges(x) "range index out of bounds"
    return clang_Diagnostic_isRangeTokenRange(x, index)
end

function getNumFixItHints(x::AbstractDiagnostic)
    @check_ptrs x
    return clang_Diagnostic_getNumFixItHints(x)
end

"""
    getFixItHint(x::AbstractDiagnostic, index::Integer) -> FixItHint
Return a borrowed carrier for the 0-based `index`-th fix-it hint. It points into the engine's
own storage and dies with the next diagnostic — never `dispose` it.

`clang::Diagnostic` asserts the bound, so it is restated here.
"""
function getFixItHint(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert 0 <= index < getNumFixItHints(x) "fix-it index out of bounds"
    return FixItHint(clang_Diagnostic_getFixItHint(x, index))
end

"""
    FormatDiagnostic(x::AbstractDiagnostic) -> String
Render the diagnostic's description with its arguments substituted into the `%0` slots.

The description is looked up by id in the engine's `DiagnosticIDs`, so this only makes sense
while a diagnostic is in flight; `getID` reporting the not-in-flight sentinel is the gate, and
it is asserted here.
"""
function FormatDiagnostic(x::AbstractDiagnostic)
    @check_ptrs x
    @assert getID(x) != typemax(UInt32) "the diagnostics engine has no diagnostic in flight"
    return get_string(clang_Diagnostic_FormatDiagnostic(x))
end

dispose(x::AbstractDiagnostic) = clang_Diagnostic_dispose(x)


# DiagnosticsEngine (state dump & delayed diagnostics)
"""
    dump(x::AbstractDiagnosticsEngine)
Write the engine's diagnostic-state map — every `#pragma diagnostic` state point together
with the location that introduced it — to stderr.

`clang::DiagnosticsEngine::dump` renders those locations through the engine's own
`SourceManager` and dereferences it unconditionally, so `hasSourceManager` is its
precondition and it is restated here.
"""
function dump(x::AbstractDiagnosticsEngine)
    @check_ptrs x
    @assert hasSourceManager(x) "the diagnostics engine has no source manager"
    clang_DiagnosticsEngine_dump(x)
    return nothing
end

"""
    SetDelayedDiagnostic(x::AbstractDiagnosticsEngine, diag_id::Integer, arg1::AbstractString="",
                         arg2::AbstractString="", arg3::AbstractString="")
Queue `diag_id` to be reported as soon as the next diagnostic on `x` finishes emitting, with
`arg1`/`arg2`/`arg3` copied into the engine as its `%0`/`%1`/`%2` arguments.

Only one delayed diagnostic fits at a time: a second call before the queued one has been
reported is silently dropped, and a diagnostic emitted through `setForceEmit` does not flush
the queue.
"""
function SetDelayedDiagnostic(x::AbstractDiagnosticsEngine, diag_id::Integer,
                              arg1::AbstractString="", arg2::AbstractString="",
                              arg3::AbstractString="")
    @check_ptrs x
    clang_DiagnosticsEngine_SetDelayedDiagnostic(x, diag_id, arg1, arg2, arg3)
    return nothing
end

# DiagnosticBuilder (forced emission & flag value)
"""
    setForceEmit(x::AbstractDiagnosticBuilder) -> AbstractDiagnosticBuilder
Mark the diagnostic for unconditional emission, bypassing the severity mapping that would
otherwise suppress it, and return `x` so the call chains the way the C++ method does.

Forcing emission also skips the delayed-diagnostic flush, so anything queued with
`SetDelayedDiagnostic` stays queued.
"""
function setForceEmit(x::AbstractDiagnosticBuilder)
    @check_ptrs x
    clang_DiagnosticBuilder_setForceEmit(x)
    return x
end

"""
    addFlagValue(x::AbstractDiagnosticBuilder, val::AbstractString)
Set the flag value a renderer prints next to the message, which `getFlagValue` reads back.

The value is stored on the engine rather than on the builder, and opening the next
diagnostic on that engine clears it.
"""
function addFlagValue(x::AbstractDiagnosticBuilder, val::AbstractString)
    @check_ptrs x
    clang_DiagnosticBuilder_addFlagValue(x, val)
    return nothing
end

# Diagnostic (engine back-reference & C-string arguments)
"""
    getDiags(x::AbstractDiagnostic) -> DiagnosticsEngine
Return the engine the view reads through. The carrier is borrowed — the engine outlives the
view, never the other way round — so it is never disposed through this handle.
"""
function getDiags(x::AbstractDiagnostic)
    @check_ptrs x
    return DiagnosticsEngine(clang_Diagnostic_getDiags(x))
end

"""
    getArgCStr(x::AbstractDiagnostic, index::Integer) -> String
Return the 0-based `index`-th argument as the NUL-terminated string it was added with. Only
an `ak_c_string` argument is one, so the kind is checked here.

The diagnostic stores the pointer it was handed rather than a copy, so the string read back
is only as alive as the storage the caller passed to `AddTaggedVal`.
"""
function getArgCStr(x::AbstractDiagnostic, index::Integer)
    @check_ptrs x
    @assert getArgKind(x, index) == CXDiagnosticsEngine_ak_c_string "argument is not a C string"
    return unsafe_string(clang_Diagnostic_getArgCStr(x, index))
end
