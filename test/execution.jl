using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: compile, get_execution_engine, get_function_pointer
using ClangCompiler.LLVM: lookup
using Test

const CODE_TEST_EXEC = """
    float sum(std::vector<float> &data) {
        float acc = 0;
        for (float v : data)
            acc += v;
        return acc;
    }

    extern "C" float c_sum(float* data) {
        std::vector<float> vec(data, data + 5); // Assuming data has at least 5 elements
        return sum(vec);
    }
"""

@testset "Execution" begin
    I = create_interpreter(["-include", "vector"])
    compile(I, CODE_TEST_EXEC)
    p = get_function_pointer(I, "c_sum")
    v = randn(Cfloat, 5)
    @test ccall(p, Cfloat, (Ptr{Cfloat},), v) == sum(v)
    dispose(I)
end

@testset "Execution | under -ftime-report" begin
    # The flag has code generation time itself against the instance's timer group, which
    # exists only if something created it. The report goes to stderr on release.
    answer = redirect_stderr(devnull) do
        I = create_interpreter(["-ftime-report"])
        compile(I, """extern "C" int timed_answer() { return 41 + 1; }""")
        r = ccall(get_function_pointer(I, "timed_answer"), Cint, ())
        dispose(I)
        return r
    end
    @test answer == 42
end

@testset "Execution | LLJIT" begin
    I = create_interpreter(["-include", "vector"])
    compile(I, CODE_TEST_EXEC)
    jit = get_execution_engine(I)
    addr = lookup(jit, "c_sum")
    v = randn(Cfloat, 5)
    @test ccall(pointer(addr), Cfloat, (Ptr{Cfloat},), v) == sum(v)

    dispose(I)
end
