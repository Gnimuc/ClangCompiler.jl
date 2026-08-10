using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "CodeGenOptions | the JIT-relevant option subset" begin
    opts = CC.CodeGenOptions()

    # CodeGenOptions.def's defaults: -O0, neither -Os nor -Oz, no debug info.
    @test CC.getOptimizationLevel(opts) == 0
    @test CC.getOptimizeSize(opts) == 0
    @test CC.getDebugInfo(opts) == CC.CXDebugInfoKind_NoDebugInfo
    @test isempty(CC.getCodeModel(opts))
    @test isempty(CC.getMainFileName(opts))

    # Each setter round-trips through its own member and disturbs no other: the two
    # optimization fields share a bitfield word, and reading back both after setting one is
    # what would catch a wrapper writing the neighbour.
    CC.setOptimizationLevel(opts, 2)
    @test CC.getOptimizationLevel(opts) == 2
    @test CC.getOptimizeSize(opts) == 0
    CC.setOptimizeSize(opts, 2)
    @test CC.getOptimizeSize(opts) == 2
    @test CC.getOptimizationLevel(opts) == 2
    CC.setOptimizationLevel(opts, 0)
    @test CC.getOptimizationLevel(opts) == 0
    @test CC.getOptimizeSize(opts) == 2

    # Both are two bits wide, so a wider value would be truncated rather than stored.
    @test_throws AssertionError CC.setOptimizationLevel(opts, 4)
    @test_throws AssertionError CC.setOptimizationLevel(opts, -1)
    @test_throws AssertionError CC.setOptimizeSize(opts, 4)

    # DebugInfo is the one option here clang generates a getter/setter pair for, so the
    # round trip goes through clang's own accessors rather than through a named member.
    CC.setDebugInfo(opts, CC.CXDebugInfoKind_FullDebugInfo)
    @test CC.getDebugInfo(opts) == CC.CXDebugInfoKind_FullDebugInfo
    CC.setDebugInfo(opts, CC.CXDebugInfoKind_DebugLineTablesOnly)
    @test CC.getDebugInfo(opts) == CC.CXDebugInfoKind_DebugLineTablesOnly

    # RelocationModel is a plain member, and its default is whatever the CodeGenOptions
    # constructor left there, so only the round trip is asserted.
    CC.setRelocationModel(opts, CC.CXRelocModel_PIC_)
    @test CC.getRelocationModel(opts) == CC.CXRelocModel_PIC_
    CC.setRelocationModel(opts, CC.CXRelocModel_Static)
    @test CC.getRelocationModel(opts) == CC.CXRelocModel_Static

    # Two std::string members that must not be each other.
    CC.setCodeModel(opts, "large")
    CC.setMainFileName(opts, "session.cpp")
    @test CC.getCodeModel(opts) == "large"
    @test CC.getMainFileName(opts) == "session.cpp"
    CC.setCodeModel(opts, "")
    @test isempty(CC.getCodeModel(opts))
    @test CC.getMainFileName(opts) == "session.cpp"

    dispose(opts)
end
