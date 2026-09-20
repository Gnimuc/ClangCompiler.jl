using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Index | USRGeneration" begin
    # Pure string fragments — no AST needed, identical on every platform.
    @test CC.getUSRSpacePrefix() == "c:"

    ivar = CC.generateUSRForObjCIvar("myIvar")
    @test occursin("myIvar", ivar)

    @test occursin("kFoo", CC.generateUSRForEnumConstant("kFoo"))
    @test occursin("MyEnum", CC.generateUSRForGlobalEnum("MyEnum"))
    @test occursin("NSObject", CC.generateUSRForObjCClass("NSObject"))
    @test occursin("NSCopying", CC.generateUSRForObjCProtocol("NSCopying"))

    cat = CC.generateUSRForObjCCategory("NSObject", "Extras")
    @test occursin("NSObject", cat)
    @test occursin("Extras", cat)

    # the bool discriminators really discriminate
    @test CC.generateUSRForObjCMethod("foo:", true) != CC.generateUSRForObjCMethod("foo:", false)
    @test CC.generateUSRForObjCProperty("prop", true) != CC.generateUSRForObjCProperty("prop", false)

    # module USRs: the by-handle and the by-name spellings agree for a top-level module
    modusr = CC.generateFullUSRForTopLevelModuleName("UsrProbeMod")
    @test startswith(modusr, "c:")
    @test occursin("UsrProbeMod", modusr)

    m = CC.Module_("UsrProbeMod")
    @test CC.generateFullUSRForModule(m) == modusr
    @test CC.generateUSRFragmentForModule(m) == CC.generateUSRFragmentForModuleName("UsrProbeMod")
    @test occursin("UsrProbeMod", CC.generateUSRFragmentForModule(m))
    CC.dispose(m)

    # decl and type USRs against a live AST
    I = CC.create_interpreter()
    CC.parse(I, "int usr_probe_fn(int);")

    f = CC.DeclFinder(I)
    @test f(I, "usr_probe_fn")
    d = CC.get_decl(f)
    usr = CC.generateUSRForDecl(d)
    @test startswith(usr, "c:")
    @test occursin("usr_probe_fn", usr)
    @test CC.generateUSRForDecl(d) == usr    # deterministic

    ctx = CC.get_ast_context(I)
    qt = CC.getCanonicalTypeInternal(CC.jlty_to_clty(Cint, ctx))
    tusr = CC.generateUSRForType(qt, ctx)
    @test startswith(tusr, "c:")
    @test CC.generateUSRForType(qt, ctx) == tusr    # deterministic

    CC.dispose(f)
    CC.dispose(I)
end
