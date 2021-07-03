using ClangCompiler
using ClangCompiler: DiagnosticIDs, DiagnosticOptions
using ClangCompiler: DiagnosticConsumer, IgnoringDiagConsumer, DiagnosticsEngine
using ClangCompiler: destroy
using Test

@testset "Diagnostic" begin
    @testset "Engine" begin
        id = DiagnosticIDs()
        @test id.ptr != C_NULL

        opts = DiagnosticOptions()
        @test opts.ptr != C_NULL

        diag = DiagnosticsEngine(id, opts)
        @test diag.ptr != C_NULL
        destroy(diag)
    end

    @testset "Consumer" begin
        opts = DiagnosticOptions()
        @test opts.ptr != C_NULL

        client = DiagnosticConsumer()
        @test client.ptr != C_NULL

        diag = DiagnosticsEngine(opts, client)
        @test diag.ptr != C_NULL
        destroy(diag)
    end

    @testset "Ignoring Consumer" begin
        opts = DiagnosticOptions()
        @test opts.ptr != C_NULL

        client = IgnoringDiagConsumer()
        @test client.ptr != C_NULL

        diag = DiagnosticsEngine(opts, client)
        @test diag.ptr != C_NULL
        destroy(diag)
    end

    diag = DiagnosticsEngine()
    @test diag.ptr != C_NULL
    destroy(diag)
end
