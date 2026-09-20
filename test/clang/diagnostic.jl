using ClangCompiler
using Test

const CC = ClangCompiler
using ClangCompiler: dispose

@testset "Diagnostic" begin
    @testset "Engine" begin
        id = CC.DiagnosticIDs()
        opts = CC.DiagnosticOptions()
        @test CC.getVerifyPrefixes(opts) == String[]
        CC.addVerifyPrefix(opts, "expected")
        @test CC.getVerifyPrefixes(opts) == ["expected"]

        diag = CC.DiagnosticsEngine(id, opts)
        @test !CC.hasErrorOccurred(diag)
        @test CC.getNumErrors(diag) == 0
        @test CC.getNumWarnings(diag) == 0
        dispose(diag)
        dispose(opts)
        dispose(id)
    end

    @testset "Consumer" begin
        opts = CC.DiagnosticOptions()
        client = CC.IgnoringDiagConsumer()
        diag = CC.DiagnosticsEngine(opts, client)
        @test CC.getClient(diag).ptr == client.ptr
        @test CC.ownsClient(diag)
        @test CC.getNumErrors(CC.getClient(diag)) == 0
        @test CC.IncludeInDiagnosticCounts(client)
        dispose(diag)
        dispose(opts)
    end

    diag = CC.DiagnosticsEngine()
    @test !CC.hasErrorOccurred(diag)
    @test CC.getNumErrors(diag) == 0
    dispose(diag)
end
