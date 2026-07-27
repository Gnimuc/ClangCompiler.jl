using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "TemplateName surface" begin
    I = create_interpreter(String[])
    CC.parse(I, "template<typename T> struct CtnBox { T v; }; CtnBox<int> ctn_b;")
    f = DeclFinder(I)

    @test f(I, "ctn_b")
    qt = CC.getType(CC.VarDecl(get_decl(f).ptr))
    t0 = CC.resolve(CC.getTypePtr(qt))
    t0 isa CC.ElaboratedType && (t0 = CC.resolve(CC.getTypePtr(CC.desugar(t0))))
    @test t0 isa CC.TemplateSpecializationType

    tn = CC.getTemplateName(t0)
    @test tn isa CC.TemplateName
    @test CC.get_name(t0) == "CtnBox"
    @test CC.isNull(tn) == false
    @test CC.getKind(tn) isa CC.LibClangEx.CXTemplateName_NameKind
    @test CC.getUnderlying(tn) isa CC.TemplateName
    @test CC.getNameToSubstitute(tn) isa CC.TemplateName
    @test CC.isDependent(tn) == false
    @test CC.isInstantiationDependent(tn) isa Bool
    @test CC.containsUnexpandedParameterPack(tn) == false
    redirect_stdio(; stderr=devnull) do
        @test CC.dump(tn) === nothing
    end

    dispose(f)
    dispose(I)
end
