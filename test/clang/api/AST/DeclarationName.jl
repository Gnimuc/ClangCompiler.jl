using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "DeclarationNameInfo" begin
    I = create_interpreter(String[])
    CC.parse(I, "int declnameinfo_probe(int a) { return a; }")
    f = DeclFinder(I)
    @test f(I, "declnameinfo_probe")
    fd = CC.FunctionDecl(get_decl(f))
    ni = CC.getNameInfo(fd)                       # owned box
    @test CC.getAsString(ni) == "declnameinfo_probe"
    @test CC.getAsString(CC.getName(ni)) == "declnameinfo_probe"
    @test CC.isValid(CC.getLoc(ni))
    @test CC.isValid(CC.getBeginLoc(ni))
    @test CC.isValid(CC.getEndLoc(ni))

    dn_empty = CC.DeclarationName()
    @test CC.isEmpty(dn_empty)
    @test isempty(CC.getAsString(dn_empty))

    dn = CC.getDeclName(fd)
    @test !CC.isEmpty(dn)
    @test CC.getAsString(dn) == "declnameinfo_probe"
    @test CC.getNameKind(dn) == CC.LibClangEx.CXDeclarationName_Identifier
    @test CC.isIdentifier(dn)
    @test CC.isDependentName(dn) == false

    dn_ii = CC.DeclarationName(CC.getIdentifier(fd))
    @test CC.getAsString(dn_ii) == "declnameinfo_probe"

    dispose(ni)
    dispose(f)
    dispose(I)
end
