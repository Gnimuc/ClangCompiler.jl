using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Diagnostic | engine state, counts & severity mapping" begin
    opts = CC.DiagnosticOptions()
    client = CC.IgnoringDiagConsumer()
    ids = CC.DiagnosticIDs()
    # The engine takes its own reference to the ids and the options, so ours outlive it and
    # are disposed below. `client` is the one thing it really owns, via should_own_client.
    engine = CC.DiagnosticsEngine(ids, opts, client, true)

    # borrowed accessors
    @test !CC.is_null_handle(CC.getDiagnosticIDs(engine))
    @test CC.getDiagnosticIDs(engine).ptr != C_NULL
    @test !CC.is_null_handle(CC.getDiagnosticOptions(engine))
    @test CC.getDiagnosticOptions(engine).ptr != C_NULL
    consumer = CC.getClient(engine)
    @test consumer isa CC.DiagnosticConsumer
    @test consumer.ptr == client.ptr
    @test CC.ownsClient(engine)
    @test !CC.hasSourceManager(engine)

    # DiagnosticConsumer counts & lifecycle (IgnoringDiagConsumer never updates its own counts)
    @test CC.getNumErrors(consumer) == 0
    @test CC.getNumWarnings(consumer) == 0
    @test CC.IncludeInDiagnosticCounts(consumer)
    CC.clear(consumer)
    CC.finish(consumer)

    # boolean state round-trips
    CC.setIgnoreAllWarnings(engine, true)
    @test CC.getIgnoreAllWarnings(engine)
    CC.setIgnoreAllWarnings(engine, false)
    @test !CC.getIgnoreAllWarnings(engine)
    CC.setEnableAllWarnings(engine, true)
    @test CC.getEnableAllWarnings(engine)
    CC.setEnableAllWarnings(engine, false)
    CC.setWarningsAsErrors(engine, true)
    @test CC.getWarningsAsErrors(engine)
    CC.setWarningsAsErrors(engine, false)
    CC.setErrorsAsFatal(engine, true)
    @test CC.getErrorsAsFatal(engine)
    CC.setErrorsAsFatal(engine, false)
    CC.setFatalsAsError(engine, true)
    @test CC.getFatalsAsError(engine)
    CC.setFatalsAsError(engine, false)
    CC.setSuppressSystemWarnings(engine, true)
    @test CC.getSuppressSystemWarnings(engine)
    CC.setSuppressAllDiagnostics(engine, false)
    @test !CC.getSuppressAllDiagnostics(engine)
    CC.setElideType(engine, false)
    @test !CC.getElideType(engine)
    CC.setPrintTemplateTree(engine, true)
    @test CC.getPrintTemplateTree(engine)
    CC.setShowColors(engine, false)
    @test !CC.getShowColors(engine)

    # limits & overload display
    CC.setErrorLimit(engine, 100)
    CC.setTemplateBacktraceLimit(engine, 7)
    @test CC.getTemplateBacktraceLimit(engine) == 7
    CC.setConstexprBacktraceLimit(engine, 9)
    @test CC.getConstexprBacktraceLimit(engine) == 9
    CC.setShowOverloads(engine, CC.CXOverloadsShown_Ovl_Best)
    @test CC.getShowOverloads(engine) == CC.CXOverloadsShown_Ovl_Best
    @test CC.getNumOverloadCandidatesToShow(engine) > 0
    CC.setExtensionHandlingBehavior(engine, CC.CXDiag_Severity_Warning)
    @test CC.getExtensionHandlingBehavior(engine) == CC.CXDiag_Severity_Warning

    # mapping-state stack (nothing changes state between push and pop, so pop is a plain unwind)
    CC.pushMappings(engine)
    @test CC.popMappings(engine)
    @test !CC.popMappings(engine)

    # group severity control (returning true means the group is unknown)
    @test !CC.setDiagnosticGroupWarningAsError(engine, "unused", true)
    @test CC.setDiagnosticGroupWarningAsError(engine, "no-such-group-xyz", true)
    @test !CC.setDiagnosticGroupErrorAsFatal(engine, "unused", false)
    @test !CC.setSeverityForGroup(engine, CC.CXDiag_Flavor_WarningOrError, "unused", CC.CXDiag_Severity_Warning)
    CC.setSeverity(engine, 1, CC.CXDiag_Severity_Error)
    CC.setSeverityForAll(engine, CC.CXDiag_Flavor_Remark, CC.CXDiag_Severity_Ignored)

    # custom diagnostics: level mapping, reporting, sticky flags & counts
    warn_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Warning, "custom warning")
    err_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Error, "custom error")
    @test warn_id != err_id
    @test CC.getDiagnosticLevel(engine, warn_id) == CC.CXDiagnosticsEngine_Warning
    @test CC.getDiagnosticLevel(engine, err_id) == CC.CXDiagnosticsEngine_Error
    @test !CC.isDiagnosticInFlight(engine)
    @test CC.getFlagValue(engine) == ""

    @test CC.getNumWarnings(engine) == 0
    CC.Report(engine, CC.SourceLocation(), warn_id)
    @test CC.getNumWarnings(engine) == 1
    @test !CC.hasErrorOccurred(engine)
    CC.Report(engine, CC.SourceLocation(), err_id)
    @test CC.hasErrorOccurred(engine)
    @test CC.getNumErrors(engine) == 1
    # a custom Error is a real error, not a -Werror upgrade, so it is uncompilable
    @test CC.hasUnrecoverableErrorOccurred(engine)
    @test CC.hasUncompilableErrorOccurred(engine)
    @test !CC.hasFatalErrorOccurred(engine)

    # suppression blocks both emission and counting
    CC.setSuppressAllDiagnostics(engine, true)
    CC.Report(engine, CC.SourceLocation(), warn_id)
    @test CC.getNumWarnings(engine) == 1
    CC.setSuppressAllDiagnostics(engine, false)

    CC.setNumWarnings(engine, 42)
    @test CC.getNumWarnings(engine) == 42

    # last-diagnostic ignore state
    CC.setLastDiagnosticIgnored(engine, true)
    @test CC.isLastDiagnosticIgnored(engine)
    CC.setLastDiagnosticIgnored(engine, false)
    @test !CC.isLastDiagnosticIgnored(engine)

    # unmapped custom IDs consult the default (fatal) mapping, so they are never ignored
    @test !CC.isIgnored(engine, err_id)

    # a hard Reset clears the sticky flags and counts
    CC.Reset(engine)
    @test !CC.hasErrorOccurred(engine)
    @test CC.getNumErrors(engine) == 0
    @test CC.getNumWarnings(engine) == 0
    # in-flight tracks the builder, not the engine: true only while one is live, and `Clear`
    # is a no-op that cannot cancel it -- emitting is what ends it
    @test !CC.isDiagnosticInFlight(engine)
    inflight = CC.DiagnosticBuilder(engine, CC.SourceLocation(), warn_id)
    @test CC.isDiagnosticInFlight(engine)
    CC.Clear(engine)
    @test CC.isDiagnosticInFlight(engine)
    CC.dispose(inflight)
    @test !CC.isDiagnosticInFlight(engine)

    # replacing the owned client: the engine deletes the old one and adopts the new one
    client2 = CC.IgnoringDiagConsumer()
    CC.setClient(engine, client2, true)
    @test CC.getClient(engine).ptr == client2.ptr
    @test CC.ownsClient(engine)

    # a live interpreter's engine has a SourceManager; borrow it to round-trip setSourceManager
    I = CC.create_interpreter(String[])
    CC.parse(I, "int diag_probe = 1;")
    ci_engine = CC.getDiagnostics(CC.get_instance(I))
    @test CC.hasSourceManager(ci_engine)
    src_mgr = CC.getSourceManager(ci_engine)
    @test src_mgr.ptr != C_NULL

    CC.setSourceManager(engine, src_mgr)
    @test CC.hasSourceManager(engine)
    @test CC.getSourceManager(engine).ptr == src_mgr.ptr

    CC.dispose(engine)  # releases its references and deletes the client it owns
    CC.dispose(ids)      # ours to free: the engine only ever held a second reference
    CC.dispose(opts)
    CC.dispose(I)
end

@testset "Diagnostic | error traps, extension silencing & stored diagnostics" begin
    # every mutation below lands on this throwaway engine, never on an interpreter's own
    opts = CC.DiagnosticOptions()
    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), opts, CC.IgnoringDiagConsumer(), true)
    warn_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Warning, "trap warning")
    err_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Error, "trap error")

    # DiagnosticErrorTrap snapshots the engine's error counters at construction
    trap = CC.DiagnosticErrorTrap(engine)
    @test trap isa CC.DiagnosticErrorTrap
    @test trap.ptr != C_NULL
    @test !CC.hasErrorOccurred(trap)
    @test !CC.hasUnrecoverableErrorOccurred(trap)
    CC.Report(engine, CC.SourceLocation(), warn_id)
    @test !CC.hasErrorOccurred(trap)                # warnings never trip the trap
    CC.Report(engine, CC.SourceLocation(), err_id)
    @test CC.hasErrorOccurred(trap)
    @test CC.hasUnrecoverableErrorOccurred(trap)    # custom errors are unrecoverable
    @test CC.reset(trap) === nothing                # re-snapshot: the past error is forgotten
    @test !CC.hasErrorOccurred(trap)
    @test !CC.hasUnrecoverableErrorOccurred(trap)

    # a trap layered on the same engine sees only what follows its own snapshot
    inner = CC.DiagnosticErrorTrap(engine)
    @test !CC.hasErrorOccurred(inner)
    CC.Report(engine, CC.SourceLocation(), err_id)
    @test CC.hasErrorOccurred(inner)
    @test CC.hasErrorOccurred(trap)
    CC.dispose(inner)
    CC.dispose(trap)

    # the extension-silencing counter is an unsigned char, so Increment/Decrement must pair
    @test !CC.hasAllExtensionsSilenced(engine)
    CC.IncrementAllExtensionsSilenced(engine)
    @test CC.hasAllExtensionsSilenced(engine)
    CC.IncrementAllExtensionsSilenced(engine)
    CC.DecrementAllExtensionsSilenced(engine)
    @test CC.hasAllExtensionsSilenced(engine)       # still one level deep
    CC.DecrementAllExtensionsSilenced(engine)
    @test !CC.hasAllExtensionsSilenced(engine)
    @test_throws AssertionError CC.DecrementAllExtensionsSilenced(engine)

    # showing a large overload set permanently lowers the cap; a small one leaves it alone
    CC.setShowOverloads(engine, CC.CXOverloadsShown_Ovl_Best)
    ncand = CC.getNumOverloadCandidatesToShow(engine)
    # clang's default cap for "show the best" is 32; showing fewer than that leaves it
    # alone, and showing more than four permanently lowers it to 4
    @test ncand == 32
    @test CC.overloadCandidatesShown(engine, 2) === nothing
    @test CC.getNumOverloadCandidatesToShow(engine) == ncand
    CC.overloadCandidatesShown(engine, 5)
    @test CC.getNumOverloadCandidatesToShow(engine) == 4

    # notePriorDiagnosticFrom copies the other engine's last-diagnostic level
    other = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), CC.IgnoringDiagConsumer(), true)
    CC.setLastDiagnosticIgnored(other, false)
    CC.setLastDiagnosticIgnored(engine, true)
    @test CC.isLastDiagnosticIgnored(engine)
    @test CC.notePriorDiagnosticFrom(engine, other) === nothing
    @test !CC.isLastDiagnosticIgnored(engine)
    CC.dispose(other)

    # StoredDiagnostic: a self-contained (level, id, message) record
    sd = CC.StoredDiagnostic(CC.CXDiagnosticsEngine_Warning, warn_id, "stored message")
    @test sd isa CC.StoredDiagnostic
    @test sd.ptr != C_NULL
    @test CC.getID(sd) == warn_id
    @test CC.getLevel(sd) == CC.CXDiagnosticsEngine_Warning
    @test CC.getMessage(sd) == "stored message"
    @test CC.range_size(sd) == 0
    @test CC.fixit_size(sd) == 0
    # this constructor leaves a default FullSourceLoc: invalid location, no SourceManager
    @test !CC.isValid(CC.getLocation(sd))
    @test CC.getLocationManager(sd).ptr == C_NULL

    # the FullSourceLoc round-trips as its two halves
    I = create_interpreter(String[])
    CC.parse(I, "int stored_diag_probe = 1;")
    sm = CC.getSourceManager(get_instance(I))
    f = DeclFinder(I)
    @test f(I, "stored_diag_probe")
    loc = CC.getLocation(get_decl(f))
    @test CC.isValid(loc)
    @test CC.setLocation(sd, loc, sm) === nothing
    @test CC.getLocation(sd).ptr == loc.ptr
    @test CC.getLocationManager(sd).ptr == sm.ptr
    @test CC.getMessage(sd) == "stored message"

    CC.dispose(sd)
    CC.dispose(engine)   # the adopted ids/opts/client go with it
    CC.dispose(I)
end

@testset "Diagnostic | fix-it hints, stored diagnostic ranges & client ownership" begin
    # A default-constructed hint records nothing at all.
    empty_hint = CC.FixItHint()
    @test empty_hint isa CC.FixItHint
    @test empty_hint.ptr != C_NULL
    @test CC.isNull(empty_hint)
    @test CC.getCodeToInsert(empty_hint) == ""
    @test !CC.getBeforePreviousInsertions(empty_hint)
    @test CC.isInvalid(CC.getRemoveRange(empty_hint))
    CC.dispose(empty_hint)

    # The factories need real source locations to produce a non-null hint.
    I = create_interpreter(String[])
    CC.parse(I, "int fixit_probe = 1;")
    sm = CC.getSourceManager(get_instance(I))
    f = DeclFinder(I)
    @test f(I, "fixit_probe")
    loc = CC.getLocation(get_decl(f))
    @test CC.isValid(loc)
    span = CC.SourceRange(loc, loc)

    insertion = CC.CreateInsertion(loc, "const ", true)
    @test insertion isa CC.FixItHint
    @test !CC.isNull(insertion)
    @test CC.getCodeToInsert(insertion) == "const "
    @test CC.getBeforePreviousInsertions(insertion)
    @test CC.getRemoveRange(insertion).begin_loc.ptr == loc.ptr
    @test CC.getRemoveRange(insertion).end_loc.ptr == loc.ptr
    @test !CC.isRemoveRangeTokenRange(insertion)   # an insertion anchors on a character range
    @test CC.isInvalid(CC.getInsertFromRange(insertion))

    from_range = CC.CreateInsertionFromRange(loc, span, true, false)
    @test !CC.isNull(from_range)
    @test CC.getCodeToInsert(from_range) == ""
    @test !CC.getBeforePreviousInsertions(from_range)
    @test CC.getInsertFromRange(from_range).begin_loc.ptr == loc.ptr
    @test CC.isInsertFromRangeTokenRange(from_range)

    removal = CC.CreateRemoval(span, true)
    @test !CC.isNull(removal)
    @test CC.getCodeToInsert(removal) == ""
    @test CC.isRemoveRangeTokenRange(removal)
    @test CC.isInvalid(CC.getInsertFromRange(removal))

    replacement = CC.CreateReplacement(span, false, "long")
    @test !CC.isNull(replacement)
    @test CC.getCodeToInsert(replacement) == "long"
    @test !CC.isRemoveRangeTokenRange(replacement)
    @test CC.getRemoveRange(replacement).end_loc.ptr == loc.ptr

    # A forwarding consumer relays through the consumer it borrows.
    target = CC.IgnoringDiagConsumer()
    fwd = CC.ForwardingDiagnosticConsumer(target)
    @test fwd isa CC.ForwardingDiagnosticConsumer
    @test fwd.ptr != C_NULL
    @test CC.IncludeInDiagnosticCounts(fwd)
    @test CC.clear(fwd) === nothing

    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), fwd, true)
    @test CC.getClient(engine).ptr == fwd.ptr
    @test CC.ownsClient(engine)
    warn_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Warning, "fix-it probe")

    # A full record: location, two ranges differing only in token-ness, and two hints.
    sd = CC.StoredDiagnostic(CC.CXDiagnosticsEngine_Warning, warn_id, "needs a fix", loc, sm, [span, span],
                             [true, false], [removal, replacement])
    @test sd isa CC.StoredDiagnostic
    @test sd.ptr != C_NULL
    @test CC.getID(sd) == warn_id
    @test CC.getMessage(sd) == "needs a fix"
    @test CC.getLocation(sd).ptr == loc.ptr
    @test CC.getLocationManager(sd).ptr == sm.ptr
    @test CC.range_size(sd) == 2
    @test CC.fixit_size(sd) == 2
    @test CC.getRange(sd, 0).begin_loc.ptr == loc.ptr
    @test CC.getRange(sd, 1).end_loc.ptr == loc.ptr
    @test CC.isRangeTokenRange(sd, 0)
    @test !CC.isRangeTokenRange(sd, 1)
    @test_throws AssertionError CC.getRange(sd, 2)
    @test_throws AssertionError CC.isRangeTokenRange(sd, 2)

    # the hints come back borrowed, in the order they were handed in
    stored = CC.getFixIt(sd, 1)
    @test stored isa CC.FixItHint
    @test CC.getCodeToInsert(stored) == "long"
    @test !CC.isRemoveRangeTokenRange(stored)
    @test CC.isRemoveRangeTokenRange(CC.getFixIt(sd, 0))
    @test CC.getCodeToInsert(CC.getFixIt(sd, 0)) == ""
    @test_throws AssertionError CC.getFixIt(sd, 2)

    # takeClient hands the consumer back; the engine keeps using the same object
    taken = CC.takeClient(engine)
    @test taken isa CC.DiagnosticConsumer
    @test taken.ptr == fwd.ptr
    @test !CC.ownsClient(engine)
    @test CC.getClient(engine).ptr == fwd.ptr
    @test_throws AssertionError CC.takeClient(engine)

    CC.dispose(sd)                  # the borrowed hints die with it
    CC.dispose(insertion)
    CC.dispose(from_range)
    CC.dispose(removal)
    CC.dispose(replacement)
    CC.dispose(engine)              # the adopted ids/opts go with it, the client no longer does
    CC.dispose(taken)               # frees the forwarding consumer this test now owns
    CC.dispose(target)
    CC.dispose(I)
end

@testset "Diagnostic | in-flight arguments, ranges & fix-it hints" begin
    # Every diagnostic below is opened on a throwaway engine, so nothing here reaches the
    # interpreter's own DiagnosticsEngine.
    I = create_interpreter(String[])
    CC.parse(I, "int diag_probe = 1;")
    sm = CC.getSourceManager(get_instance(I))
    f = DeclFinder(I)
    @test f(I, "diag_probe")
    probe = get_decl(f)
    loc = CC.getLocation(probe)
    @test CC.isValid(loc)
    span = CC.SourceRange(loc, loc)
    ident = CC.getIdentifier(probe)
    @test CC.getNameStart(ident) == "diag_probe"

    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), CC.IgnoringDiagConsumer(), true)  # engine adopts all three
    CC.setSourceManager(engine, sm)
    warn_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Warning, "probe %0 saw %1 and %2")

    # With nothing in flight the storage reads back empty and the id is the sentinel, so
    # every indexed accessor is out of bounds and the formatter has no description to find.
    idle = CC.Diagnostic(engine)
    @test idle isa CC.Diagnostic
    @test idle.ptr != C_NULL
    @test CC.getID(idle) == typemax(UInt32)
    @test CC.getNumArgs(idle) == 0
    @test CC.getNumRanges(idle) == 0
    @test CC.getNumFixItHints(idle) == 0
    @test CC.hasSourceManager(idle)
    @test CC.getSourceManager(idle).ptr == sm.ptr
    @test_throws AssertionError CC.getArgKind(idle, 0)
    @test_throws AssertionError CC.getRange(idle, 0)
    @test_throws AssertionError CC.isRangeTokenRange(idle, 0)
    @test_throws AssertionError CC.getFixItHint(idle, 0)
    @test_throws AssertionError CC.FormatDiagnostic(idle)
    CC.dispose(idle)

    # Open one and fill it: a string, a signed and an unsigned number, an identifier, two
    # ranges differing only in token-ness, and one hint.
    @test !CC.isDiagnosticInFlight(engine)
    b = CC.DiagnosticBuilder(engine, loc, warn_id)
    @test b isa CC.DiagnosticBuilder
    @test b.ptr != C_NULL
    @test CC.isDiagnosticInFlight(engine)
    CC.AddString(b, "spelled")
    CC.AddTaggedVal(b, -7, CC.CXDiagnosticsEngine_ak_sint)
    CC.AddTaggedVal(b, 42, CC.CXDiagnosticsEngine_ak_uint)
    CC.AddTaggedVal(b, UInt64(UInt(ident.ptr)), CC.CXDiagnosticsEngine_ak_identifierinfo)
    @test_throws AssertionError CC.AddTaggedVal(b, 1, CC.CXDiagnosticsEngine_ak_std_string)
    CC.AddSourceRange(b, span, true)
    CC.AddSourceRange(b, span, false)
    hint = CC.CreateReplacement(span, false, "long")
    CC.AddFixItHint(b, hint)

    d = CC.Diagnostic(engine)
    @test CC.getID(d) == warn_id
    @test CC.getLocation(d).ptr == loc.ptr

    # arguments come back in the order they were added, each readable only by its own kind
    @test CC.getNumArgs(d) == 4
    @test CC.getArgKind(d, 0) == CC.CXDiagnosticsEngine_ak_std_string
    @test CC.getArgStdStr(d, 0) == "spelled"
    @test CC.getArgKind(d, 1) == CC.CXDiagnosticsEngine_ak_sint
    @test CC.getArgSInt(d, 1) == -7
    @test CC.getArgKind(d, 2) == CC.CXDiagnosticsEngine_ak_uint
    @test CC.getArgUInt(d, 2) == 42
    @test CC.getRawArg(d, 2) == 42
    @test CC.getArgKind(d, 3) == CC.CXDiagnosticsEngine_ak_identifierinfo
    @test !CC.is_null_handle(CC.getArgIdentifier(d, 3))
    @test CC.getNameStart(CC.getArgIdentifier(d, 3)) == "diag_probe"
    @test CC.getRawArg(d, 3) == UInt64(UInt(ident.ptr))
    @test_throws AssertionError CC.getArgStdStr(d, 1)
    @test_throws AssertionError CC.getArgSInt(d, 0)
    @test_throws AssertionError CC.getArgUInt(d, 0)
    @test_throws AssertionError CC.getArgIdentifier(d, 0)
    @test_throws AssertionError CC.getRawArg(d, 0)   # a std::string has no raw payload
    @test_throws AssertionError CC.getArgKind(d, 4)

    @test CC.getNumRanges(d) == 2
    @test CC.getRange(d, 0).begin_loc.ptr == loc.ptr
    @test CC.getRange(d, 1).end_loc.ptr == loc.ptr
    @test CC.isRangeTokenRange(d, 0)
    @test !CC.isRangeTokenRange(d, 1)
    @test_throws AssertionError CC.getRange(d, 2)
    @test_throws AssertionError CC.isRangeTokenRange(d, 2)

    @test CC.getNumFixItHints(d) == 1
    borrowed = CC.getFixItHint(d, 0)
    @test borrowed isa CC.FixItHint
    @test CC.getCodeToInsert(borrowed) == "long"
    @test !CC.isRemoveRangeTokenRange(borrowed)
    @test_throws AssertionError CC.getFixItHint(d, 1)

    # %0/%1/%2 take the first three arguments; the fourth has no slot in this format string
    msg = CC.FormatDiagnostic(d)
    @test msg isa String
    @test occursin("spelled", msg)
    @test occursin("-7", msg)
    @test occursin("42", msg)

    CC.dispose(d)
    CC.dispose(b)                       # emits the diagnostic to the engine's client
    @test !CC.isDiagnosticInFlight(engine)
    @test CC.getNumWarnings(engine) == 1

    CC.dispose(hint)
    CC.dispose(engine)                  # the adopted ids/opts/client go with it
    CC.dispose(I)
end

@testset "Diagnostic | refcounted handles survive being lent out" begin
    # Every one of these objects is reference counted, and each is handed back already
    # holding our reference (MARSHALLING.md §12). That is what makes them reusable across
    # consumers: before the conversion a consumer's release took a count-zero object to zero
    # and deleted it, so the *second* use of any of these read freed memory.

    # One diagnostic table backing two engines in turn. getOrCreateDiagID uniques on
    # (level, message), so a table that survived the first engine must return the same id.
    ids = CC.DiagnosticIDs()
    o1 = CC.DiagnosticOptions()
    e1 = CC.DiagnosticsEngine(ids, o1, CC.IgnoringDiagConsumer(), true)
    w1 = CC.getCustomDiagID(e1, CC.CXDiagnosticsEngine_Warning, "reuse probe")
    CC.dispose(e1)
    CC.dispose(o1)

    o2 = CC.DiagnosticOptions()
    e2 = CC.DiagnosticsEngine(ids, o2, CC.IgnoringDiagConsumer(), true)
    @test CC.getCustomDiagID(e2, CC.CXDiagnosticsEngine_Warning, "reuse probe") == w1

    # One engine backing two compiler instances in turn. setDiagnostics takes a reference
    # and disposing the instance gives it back, which used to be the last one.
    ci1 = CC.CompilerInstance()
    CC.setDiagnostics(ci1, e2)
    CC.dispose(ci1)
    ci2 = CC.CompilerInstance()
    CC.setDiagnostics(ci2, e2)
    @test CC.hasDiagnostics(ci2)
    # Registering through the still-live engine touches the table both of them share.
    @test CC.getCustomDiagID(e2, CC.CXDiagnosticsEngine_Warning, "reuse probe") == w1
    CC.dispose(ci2)

    CC.dispose(e2)
    CC.dispose(o2)
    CC.dispose(ids)
end
