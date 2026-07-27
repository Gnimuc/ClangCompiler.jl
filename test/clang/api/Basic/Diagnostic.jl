using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Diagnostic | engine state, counts & severity mapping" begin
    opts = CC.DiagnosticOptions()
    client = CC.IgnoringDiagConsumer()
    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), opts, client, true)  # engine adopts all three

    # borrowed accessors
    @test CC.getDiagnosticIDs(engine) isa CC.DiagnosticIDs
    @test CC.getDiagnosticIDs(engine).ptr != C_NULL
    @test CC.getDiagnosticOptions(engine) isa CC.DiagnosticOptions
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
    @test !CC.setSeverityForGroup(engine, CC.CXDiag_Flavor_WarningOrError, "unused",
                                  CC.CXDiag_Severity_Warning)
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
    # custom errors are unrecoverable but not "uncompilable" (they have no default error mapping)
    @test CC.hasUnrecoverableErrorOccurred(engine)
    @test !CC.hasUncompilableErrorOccurred(engine)
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
    CC.Clear(engine)
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
    @test ci_engine isa CC.DiagnosticsEngine
    @test CC.hasSourceManager(ci_engine)
    src_mgr = CC.getSourceManager(ci_engine)
    @test src_mgr isa CC.SourceManager
    @test src_mgr.ptr != C_NULL

    CC.setSourceManager(engine, src_mgr)
    @test CC.hasSourceManager(engine)
    @test CC.getSourceManager(engine).ptr == src_mgr.ptr

    CC.dispose(engine)  # the adopted ids/opts/client are released with the engine
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
    @test ncand isa Integer
    @test CC.overloadCandidatesShown(engine, 2) === nothing
    @test CC.getNumOverloadCandidatesToShow(engine) == ncand
    CC.overloadCandidatesShown(engine, 5)
    @test CC.getNumOverloadCandidatesToShow(engine) == 4

    # notePriorDiagnosticFrom copies the other engine's last-diagnostic level
    other = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                 CC.IgnoringDiagConsumer(), true)
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
    @test f(I, "stored_diag_probe") isa Bool
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
