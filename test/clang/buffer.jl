using ClangCompiler
using ClangCompiler: MemoryBuffer
using Test

@testset "MemoryBuffer" begin
    code = """
    #define M(x) [x]
    M(foo)
    """
    buffer = MemoryBuffer(code)
    @test buffer.ptr != C_NULL

    # TODO: fix memory leak
end
