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
    # FIXME: memory leak here
    # NOTE: The `destroy` method for `MemoryBuffer` is intentionally not implemented.
end
