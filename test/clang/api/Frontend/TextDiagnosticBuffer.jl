using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

const LXB = CC.LibClangEx

@testset "TextDiagnosticBuffer records what the counters cannot" begin
    I = create_interpreter(["-std=c++17"])
    ci = CC.get_instance(I)
    de = CC.getDiagnostics(ci)

    buf = CC.TextDiagnosticBuffer()
    @test buf.ptr != C_NULL
    # Not owned by the engine: the test disposes it, and the printer goes back at the end.
    CC.setClient(de, buf, false)

    for level in (LXB.CXTextDiagnosticBuffer_Note, LXB.CXTextDiagnosticBuffer_Remark,
                  LXB.CXTextDiagnosticBuffer_Warning, LXB.CXTextDiagnosticBuffer_Error)
        @test Base.size(buf, level) == 0
    end
    # Nothing buffered yet, so index 0 is out of range at every level.
    @test_throws AssertionError CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 0)
    @test_throws AssertionError CC.getLocation(buf, LXB.CXTextDiagnosticBuffer_Error, 0)

    ok = CC.parse(I, "int tdb_ok(int x) { return x + 1; }\n")
    @test !CC.is_null_handle(ok)
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Error) == 0

    # A warning and an error are buffered under their own levels, not lumped together.
    warned = CC.parse(I, "int tdb_warn() { }\n")   # -Wreturn-type, on by default
    @test !CC.is_null_handle(warned)
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Warning) == 1
    @test occursin("return", CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Warning, 0))
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Error) == 0

    bad = CC.parse(I, "int tdb_bad(int x) { return tdb_nosuch(x); }\n")
    # This is ISSUE 40's whole point: the parse plainly failed, and every counter says the
    # engine is clean, because clang's incremental parser soft-resets it and clears the
    # consumer's counts before reporting the failure. The null unit is the signal; the
    # buffer is what still knows why, since `clear()` zeroes counts without emptying it.
    @test CC.is_null_handle(bad)
    @test CC.getNumErrors(de) == 0
    @test CC.hasErrorOccurred(de) == false
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Error) == 1
    @test occursin("tdb_nosuch", CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 0))
    @test !CC.is_null_handle(CC.getLocation(buf, LXB.CXTextDiagnosticBuffer_Error, 0))
    @test_throws AssertionError CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 1)

    # And a null unit does not mean nothing changed: the function the failed increment
    # declared is still findable, still carries a body, and still reports itself valid. So
    # per-declaration validity is no substitute for the unit either -- what the unit says is
    # that clang refused this increment, not that it left no trace.
    lookup = CC.DeclFinder(I)
    @test lookup(I, "tdb_ok") == true
    @test lookup(I, "tdb_bad") == true
    survivor = CC.resolve(CC.get_decl(lookup))
    @test survivor isa CC.AbstractFunctionDecl
    @test CC.isInvalidDecl(survivor) == false
    @test CC.hasBody(survivor) == true
    CC.dispose(lookup)

    ok2 = CC.parse(I, "int tdb_ok2() { return 2; }\n")
    @test !CC.is_null_handle(ok2)
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Error) == 1  # still there afterwards

    # A second error at the same level: with only one buffered, an accessor that ignores
    # its index reads the same as a working one.
    bad2 = CC.parse(I, "int tdb_bad2(int x) { return tdb_other_nosuch(x); }\n")
    @test CC.is_null_handle(bad2)
    @test Base.size(buf, LXB.CXTextDiagnosticBuffer_Error) == 2
    @test occursin("tdb_nosuch", CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 0))
    @test occursin("tdb_other_nosuch", CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 1))
    @test CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 0) !=
          CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 1)
    @test CC.getLocation(buf, LXB.CXTextDiagnosticBuffer_Error, 0).ptr !=
          CC.getLocation(buf, LXB.CXTextDiagnosticBuffer_Error, 1).ptr

    # Replaying carries the messages into another engine's consumer. Flushing into the
    # engine this buffer is installed on would append to the list clang is walking, so the
    # wrapper refuses it rather than letting the iteration run off a reallocated vector.
    @test_throws AssertionError CC.FlushDiagnostics(buf, de)

    sink = CC.TextDiagnosticBuffer()
    other = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), sink, false)
    CC.FlushDiagnostics(buf, other)
    @test Base.size(sink, LXB.CXTextDiagnosticBuffer_Error) ==
          Base.size(buf, LXB.CXTextDiagnosticBuffer_Error)
    @test Base.size(sink, LXB.CXTextDiagnosticBuffer_Warning) ==
          Base.size(buf, LXB.CXTextDiagnosticBuffer_Warning)
    @test CC.getMessage(sink, LXB.CXTextDiagnosticBuffer_Error, 0) ==
          CC.getMessage(buf, LXB.CXTextDiagnosticBuffer_Error, 0)
    dispose(other)
    dispose(sink)

    CC.setClient(de, CC.TextDiagnosticPrinter(CC.getDiagnosticOptions(de)), true)
    dispose(buf)
    dispose(I)
end
