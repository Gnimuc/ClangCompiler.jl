using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using Test

const LX = CC.LibClangEx

@testset "EmitBackendOutput runs the backend over a module built incrementally" begin
    # The module comes off the increment that PARSED the function, which is the only one
    # that contains it: the interpreter starts a fresh module per increment, so by the time
    # parse returns, the code generator has already moved on and ReleaseModule would hand
    # back the next (empty) module -- verified, it holds no functions at all.
    #
    # EmitBackendOutput optimizes in place, so this rewrites the increment's own module.
    # That is why the interpreter is a throwaway, deliberately left undisposed for the same
    # ownership reason as in test/clang/api/Basic/SourceManager.jl.
    J = create_interpreter(String[])
    ci = CC.get_instance(J)
    ptu = CC.parse(J, "extern \"C\" int beu_add(int a, int b) { return a + b; }")
    mod = CC.getModule(ptu)
    @test mod !== nothing
    @test "beu_add" in [LLVM.name(fn) for fn in LLVM.functions(mod)]

    dir = mktempdir()

    ll = joinpath(dir, "beu.ll")
    @test CC.EmitBackendOutput(ci, mod, LX.CXBackendAction_Backend_EmitLL, ll)
    text = read(ll, String)
    @test occursin("beu_add", text)              # the function survived the pipeline
    @test occursin("define", text)               # ... as a definition, not a declaration

    bc = joinpath(dir, "beu.bc")
    @test CC.EmitBackendOutput(ci, mod, LX.CXBackendAction_Backend_EmitBC, bc)
    # Bitcode carries one of two magics, and which one is the host's business: the raw
    # container starts with 'BC' 0xC0DE, while Darwin wraps it in a bitcode wrapper whose
    # header starts with 0x0B17C0DE (little-endian: de c0 17 0b). Accepting either still
    # fails on a file that is not bitcode at all, which is what this is checking.
    magic = read(bc, 4)
    @test magic == UInt8['B', 'C', 0xc0, 0xde] || magic == UInt8[0xde, 0xc0, 0x17, 0x0b]

    obj = joinpath(dir, "beu.o")
    @test CC.EmitBackendOutput(ci, mod, LX.CXBackendAction_Backend_EmitObj, obj)
    @test filesize(obj) > 0

    # an unopenable path is reported rather than crashing partway through the pipeline
    @test !CC.EmitBackendOutput(ci, mod, LX.CXBackendAction_Backend_EmitLL,
                                joinpath(dir, "no", "such", "directory", "beu.ll"))
end

@testset "EmitBackendOutput needs a configured CompilerInstance" begin
    # A bare CompilerInstance has neither the file manager the backend's VFS comes from nor
    # the target its data layout comes from, and both are read unconditionally.
    ci = CC.CompilerInstance()
    lctx = LLVM.Context()
    mod = LLVM.Module("beu_empty")
    @test_throws AssertionError CC.EmitBackendOutput(ci, mod, LX.CXBackendAction_Backend_EmitLL,
                                                     joinpath(mktempdir(), "x.ll"))
    LLVM.dispose(mod)
    LLVM.dispose(lctx)
    dispose(ci)
end
