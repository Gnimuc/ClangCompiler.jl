using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "value from type" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ft_value_probe = 0; double ft_value_probe2 = 0.0;")
    f = DeclFinder(I)
    @test f(I, "ft_value_probe")
    qt_int = CC.getType(CC.VarDecl(get_decl(f).ptr))
    @test f(I, "ft_value_probe2")
    qt_double = CC.getType(CC.VarDecl(get_decl(f).ptr))

    v = CC.createValueFromType(I.interp, qt_int)
    @test v isa CC.Value
    @test CC.isValid(v)
    @test CC.getKind(v) == CC.LibClangEx.CXValue_Int
    @test CC.getType(v) == qt_int.ptr   # opaque encoding round-trip
    CC.setOpaqueType(v, qt_double)
    @test CC.getType(v) == qt_double.ptr
    dispose(v)
    dispose(f)
    dispose(I)
end
