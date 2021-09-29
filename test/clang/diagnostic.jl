using ClangCompiler
using Test

const CC = ClangCompiler

@testset "Diagnostic" begin
    @testset "Engine" begin
        id = CC.DiagnosticIDs()
        @test id.ptr != C_NULL

        opts = CC.DiagnosticOptions()
        @test opts.ptr != C_NULL

        diag = CC.DiagnosticsEngine(id, opts)
        @test diag.ptr != C_NULL
        dispose(diag)
    end

    @testset "Consumer" begin
        opts = CC.DiagnosticOptions()
        @test opts.ptr != C_NULL

        client = CC.IgnoringDiagConsumer()
        @test client.ptr != C_NULL

        diag = CC.DiagnosticsEngine(opts, client)
        @test diag.ptr != C_NULL
        dispose(diag)
    end

    diag = CC.DiagnosticsEngine()
    @test diag.ptr != C_NULL
    dispose(diag)
end
