using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

@testset "template navigation" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "template<typename T, int N> struct S { T x; };")
    f = DeclFinder(I)
    @test f(I, "S")
    ctd = ClangCompiler.ClassTemplateDecl(get_decl(f).ptr)
    tpl = ClangCompiler.getTemplateParameters(ctd)
    @test ClangCompiler.getMinRequiredArguments(tpl) == 2
    ttp = ClangCompiler.TemplateTypeParmDecl(ClangCompiler.getParam(tpl, 0).ptr)
    @test ClangCompiler.getDepth(ttp) == 0
    @test ClangCompiler.getIndex(ttp) == 0
    @test !ClangCompiler.isParameterPack(ttp)
    @test ClangCompiler.getName(ClangCompiler.getTemplatedDecl(ctd)) == "S"
    dispose(f)
    dispose(I)
end
