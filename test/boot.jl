using ClangCompiler
using Test

@testset "boot" begin
    @test_nowarn ClangCompiler.print_julia_version()
end
