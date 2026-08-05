using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Every field here is asserted through a printer that reads the policy, never by reading back
# what the setter just wrote: a get/set round trip would hold even if the field were inert.
@testset "PrintingPolicy | fields observed through printAsString" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SPP { int x; };
             namespace NSPP { struct S { int y; }; }
             bool bpp_probe = false;
             """)
    ctx = CC.get_ast_context(I)
    opts = CC.getLangOpts(CC.get_instance(I))

    f = DeclFinder(I)
    @test f(I, "SPP")
    spp = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    # the nested record is reached through its namespace: "S" is not a unique top-level name
    @test f(I, "NSPP")
    ns = CC.NamespaceDecl(get_decl(f))
    inner = only(filter(d -> d isa CC.CXXRecordDecl, collect(CC.decls_in(CC.castToDeclContext(ns)))))
    nested = CC.getTypeDeclType(ctx, CC.TypeDecl(inner))
    @test f(I, "bpp_probe")
    boolty = CC.getType(CC.VarDecl(get_decl(f)))

    # the context's own policy is borrowed, and an owned copy of it starts out equal
    ctx_policy = CC.getPrintingPolicy(ctx)
    @test ctx_policy isa CC.PrintingPolicy
    owned = CC.PrintingPolicy(ctx_policy)
    @test CC.getSuppressTagKeyword(owned) == CC.getSuppressTagKeyword(ctx_policy)
    @test CC.getSuppressScope(owned) == CC.getSuppressScope(ctx_policy)
    @test CC.getBool(owned) == CC.getBool(ctx_policy)

    # each field is exercised from a policy that differs from the context's in that field
    # alone, so the printed difference cannot come from another setting left over
    @test CC.getSuppressTagKeyword(ctx_policy)
    @test CC.printAsString(spp, ctx) == "SPP"
    @test CC.printAsString(nested, ctx) == "NSPP::S"
    @test CC.printAsString(boolty, ctx) == "bool"

    probe = CC.PrintingPolicy(ctx_policy)

    # the tag keyword
    CC.setSuppressTagKeyword(probe, false)
    CC.setPrintingPolicy(ctx, probe)
    @test CC.printAsString(spp, ctx) == "struct SPP"
    CC.setSuppressTagKeyword(probe, true)

    # the scope qualification
    CC.setSuppressScope(probe, true)
    CC.setPrintingPolicy(ctx, probe)
    @test CC.printAsString(nested, ctx) == "S"
    CC.setSuppressScope(probe, false)

    # the boolean spelling
    CC.setBool(probe, false)
    CC.setPrintingPolicy(ctx, probe)
    @test CC.printAsString(boolty, ctx) == "_Bool"
    CC.setBool(probe, true)

    # restoring the saved copy puts every printer back where it started
    CC.setPrintingPolicy(ctx, owned)
    @test CC.printAsString(spp, ctx) == "SPP"
    @test CC.printAsString(nested, ctx) == "NSPP::S"
    @test CC.printAsString(boolty, ctx) == "bool"

    CC.dispose(probe)
    CC.dispose(owned)
    dispose(f)
    dispose(I)
end
