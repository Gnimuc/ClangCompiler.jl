using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "interpreter dtor call and dynamic library" begin
    I = create_interpreter(String[])
    @test CC.LoadDynamicLibrary(I.interp, Libdl.dlpath(CC.libclangex)) === nothing
    CC.compile(I, """
        struct FtTrivial { int x; };
        struct FtNontrivial { int y; ~FtNontrivial(); };
        FtNontrivial::~FtNontrivial() {}
        FtTrivial ft_trivial_probe;
    """)
    f = DeclFinder(I)
    @test f(I, "FtTrivial")
    triv = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.CompileDtorCall(I.interp, triv) == 0  # irrelevant destructor -> null address
    @test f(I, "FtNontrivial")
    nontriv = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.CompileDtorCall(I.interp, nontriv) isa UInt64
    dispose(f)
    dispose(I)
end
