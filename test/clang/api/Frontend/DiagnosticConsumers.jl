using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

const LXB_DC = CC.LibClangEx

@testset "ChainedDiagnosticConsumer feeds both clients" begin
    I = create_interpreter(["-std=c++17"])
    de = CC.getDiagnostics(CC.get_instance(I))

    # Two buffers so the fan-out is observable: the chain must leave the same messages in
    # each, which no single-client engine could do.
    seen = CC.TextDiagnosticBuffer()   # primary -- borrowed, this test disposes it
    kept = CC.TextDiagnosticBuffer()   # secondary -- adopted by the chain
    @test_throws AssertionError CC.ChainedDiagnosticConsumer(seen, seen)

    chain = CC.ChainedDiagnosticConsumer(seen, kept)
    CC.setClient(de, chain, false)

    @test !CC.is_null_handle(CC.parse(I, "int cdc_warn() { }\n"))  # -Wreturn-type
    @test CC.is_null_handle(CC.parse(I, "int cdc_bad(int x) { return cdc_nosuch(x); }\n"))

    for level in (LXB_DC.CXTextDiagnosticBuffer_Warning, LXB_DC.CXTextDiagnosticBuffer_Error)
        @test Base.size(seen, level) == Base.size(kept, level)
        @test Base.size(seen, level) > 0
        for i in 0:(Int(Base.size(seen, level)) - 1)
            @test CC.getMessage(seen, level, i) == CC.getMessage(kept, level, i)
        end
    end
    @test occursin("cdc_nosuch", CC.getMessage(kept, LXB_DC.CXTextDiagnosticBuffer_Error, 0))

    # Hand the engine a client it owns outright before the chain goes. Building a
    # TextDiagnosticPrinter here instead would pull in getDiagnosticOptions, whose
    # IntrusiveRefCntPtr<DiagnosticOptions> is borrowed from the engine: the printer takes
    # a reference to it and the teardown order then destroys the options while that
    # reference is still live, which aborts on LLVM's
    # "Destruction occurred when there are still references to this" assertion.
    CC.setClient(de, CC.TextDiagnosticBuffer(), true)
    dispose(chain)   # takes `kept` with it -- adopted at construction
    dispose(seen)
    dispose(I)
end

@testset "VerifyDiagnosticConsumer checks the markers in the source" begin
    # A matching file and a mismatching one, run through the same pipeline: the verifier
    # reports nothing for the first and something for the second, and its reports land in
    # the client it took over at construction.
    mktempdir() do dir
        matching = joinpath(dir, "vdc_match.cpp")
        write(matching,
              "int vdc_match(int x) { return vdc_y; } // expected-error {{undeclared identifier}}\n")
        mismatching = joinpath(dir, "vdc_mismatch.cpp")
        write(mismatching,
              "int vdc_mismatch(int x) { return vdc_z; } // expected-warning {{undeclared identifier}}\n")

        for (src, should_be_clean) in ((matching, true), (mismatching, false))
            ci = CC.CompilerInstance()
            CC.createDiagnostics(ci)
            de = CC.getDiagnostics(ci)

            # Without a prefix nothing is a directive: clang fills VerifyPrefixes from
            # `-verify` alone, and this consumer was installed by hand.
            dopts = CC.getDiagnosticOptions(de)
            @test CC.getVerifyPrefixes(dopts) == String[]
            CC.addVerifyPrefix(dopts, "expected")
            @test CC.getVerifyPrefixes(dopts) == ["expected"]

            # The verifier hands its mismatch reports to whatever client the engine had when
            # it was built, so install the sink first.
            sink = CC.TextDiagnosticBuffer()
            CC.setClient(de, sink, false)
            verifier = CC.VerifyDiagnosticConsumer(de)
            CC.setClient(de, verifier, false)
            @test CC.getClient(de).ptr == verifier.ptr

            invok = CC.createFromCommandLine(src, ["-std=c++17"], de)
            CC.setInvocation(ci, invok)
            act = CC.SyntaxOnlyAction()
            CC.ExecuteAction(ci, act)
            dispose(act)

            # The parse error itself never reaches the sink -- the verifier swallows every
            # diagnostic and reports only the mismatches, so a clean run leaves it empty.
            @test (Base.size(sink, LXB_DC.CXTextDiagnosticBuffer_Error) == 0) == should_be_clean

            # Order matters: ~VerifyDiagnosticConsumer runs one last check through the
            # engine it holds by reference and through the client it captured, so both have
            # to outlive it -- and it must be off the engine first, since the engine would
            # otherwise be left pointing at freed memory.
            CC.setClient(de, sink, false)
            dispose(verifier)
            dispose(ci)
            dispose(sink)
        end
    end
end

@testset "serialized_diags writes a .dia the caller can point a tool at" begin
    mktempdir() do dir
        dia = joinpath(dir, "sdp_out.dia")
        opts = CC.DiagnosticOptions()

        @test_throws AssertionError CC.SerializedDiagnosticPrinter("", opts)

        dc = CC.SerializedDiagnosticPrinter(dia, opts)
        @test dc.ptr != C_NULL
        # The bytes are buffered until finish(); nothing exists on disk before it.
        @test !isfile(dia)
        CC.finish(dc)
        @test isfile(dia)
        # A serialized diagnostics file is an LLVM bitstream with clang's own four-byte
        # magic, so this says a .dia was written rather than an empty file created.
        @test read(dia, 4) == b"DIAG"

        dispose(dc)
        # `opts` stays ours. The writer keeps them in its shared state through an
        # IntrusiveRefCntPtr for exactly as long as it lives, and they were handed back
        # already holding our reference, so that borrow ran 1 -> 2 -> 1 and this is the
        # dispose that frees. Before the refcount conversion the writer's release took
        # count-zero options straight to deletion and this call was a double free.
        dispose(opts)
    end
end
