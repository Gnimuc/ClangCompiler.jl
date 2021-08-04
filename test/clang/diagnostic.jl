using ClangCompiler
using ClangCompiler: DiagnosticIDs, DiagnosticOptions
using ClangCompiler: IgnoringDiagConsumer, DiagnosticsEngine
using ClangCompiler: dispose
using Test

@testset "Diagnostic" begin
    @testset "Engine" begin
        id = DiagnosticIDs()
        @test id.ptr != C_NULL

        opts = DiagnosticOptions()
        @test opts.ptr != C_NULL

        diag = DiagnosticsEngine(id, opts)
        @test diag.ptr != C_NULL
        dispose(diag)
    end

    @testset "Consumer" begin
        opts = DiagnosticOptions()
        @test opts.ptr != C_NULL

        client = IgnoringDiagConsumer()
        @test client.ptr != C_NULL

        diag = DiagnosticsEngine(opts, client)
        @test diag.ptr != C_NULL
        dispose(diag)
    end

    diag = DiagnosticsEngine()
    @test diag.ptr != C_NULL
    dispose(diag)
end
