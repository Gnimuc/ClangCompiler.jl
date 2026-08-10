using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl, get_instance
using Test

# ASTImporter moves nodes between two ASTContexts, so every testset here runs TWO
# interpreters at once: `From` is parsed into and `To` receives the copies. What is asserted
# is that the copy landed in the destination context and denotes the same thing the original
# did — not merely that a non-null pointer came back.

@testset "ASTImporter" begin
    From = create_interpreter(String[])
    To = create_interpreter(String[])
    from_ctx = CC.get_ast_context(From)
    to_ctx = CC.get_ast_context(To)
    from_fm = CC.getFileManager(get_instance(From))
    to_fm = CC.getFileManager(get_instance(To))

    CC.parse(From, """
    struct AimWidget { int a; double b; };
    int aim_twice(int v) { return 2 * v; }
    void aim_helper();
    int aim_var;
    """)
    CC.parse(To, "void aim_stub();")

    imp = CC.ASTImporter(to_ctx, to_fm, from_ctx, from_fm)
    minimal = CC.ASTImporter(to_ctx, to_fm, from_ctx, from_fm, true)

    # the flag is stored on the importer, so the two disagree
    @test !CC.isMinimalImport(imp)
    @test CC.isMinimalImport(minimal)

    # the four handles the constructor took come back, and they are the ones we passed
    @test CC.getToContext(imp).ptr == to_ctx.ptr
    @test CC.getFromContext(imp).ptr == from_ctx.ptr
    @test CC.getToFileManager(imp).ptr == to_fm.ptr
    @test CC.getFromFileManager(imp).ptr == from_fm.ptr

    twice = find_decl(From, "aim_twice")
    @test twice !== nothing

    # nothing has been imported yet, so the map is empty for this decl
    @test CC.is_null_handle(CC.GetAlreadyImportedOrNull(imp, twice))
    @test CC.getImportDeclErrorIfAny(imp, twice) === nothing

    imported = CC.Import(imp, twice)
    @test !CC.is_null_handle(imported)
    # the copy is a different declaration, living in the OTHER context, under the same name
    @test imported != twice
    @test CC.get_ast_context(imported).ptr == to_ctx.ptr
    @test CC.getNameAsString(CC.resolve(imported)) == "aim_twice"
    # and the importer now remembers it, in both directions
    @test CC.GetAlreadyImportedOrNull(imp, twice) == imported
    @test CC.GetFromTU(imp, imported) == CC.getTranslationUnitDecl(from_ctx)
    # importing the same declaration twice reuses the copy rather than making a second one
    @test CC.Import(imp, twice) == imported

    # a record: ImportDefinition takes the SOURCE declaration, and the empty string is
    # success. Afterwards the copy in the destination context is complete.
    widget = find_decl(From, "AimWidget")
    @test widget !== nothing
    @test CC.ImportDefinition(imp, widget) == ""
    imported_widget = CC.GetAlreadyImportedOrNull(imp, widget)
    @test !CC.is_null_handle(imported_widget)
    @test CC.hasDefinition(CC.resolve(imported_widget))
    # a declaration that is not a DeclContext has no definition to import, and dispatch is
    # what says so rather than clang's cast<DeclContext> assert
    aim_var = find_decl(From, "aim_var")
    @test aim_var !== nothing
    @test_throws MethodError CC.ImportDefinition(imp, aim_var)

    # a type: `int` of the from-context imports to `int` of the to-context, which is a
    # DIFFERENT QualType value -- that is the whole point of the exercise
    from_int = CC.get_qual_type(CC.IntTy(from_ctx))
    to_int = CC.get_qual_type(CC.IntTy(to_ctx))
    to_double = CC.get_qual_type(CC.DoubleTy(to_ctx))
    @test from_int != to_int
    @test CC.Import(imp, from_int) == to_int

    # structural equivalence runs across the two contexts and partitions
    @test CC.IsStructurallyEquivalent(imp, from_int, to_int, false)
    @test !CC.IsStructurallyEquivalent(imp, from_int, to_double, false)

    # an identifier is looked up in the destination's table, so the two spellings agree but
    # the objects do not
    from_id = CC.getIdentifierInfo(CC.getPreprocessor(get_instance(From)), "aim_twice")
    imported_id = CC.Import(imp, from_id)
    @test CC.getName(imported_id) == "aim_twice"
    @test imported_id.ptr != from_id.ptr

    # a hand-written mapping is what GetAlreadyImportedOrNull reports afterwards
    helper = find_decl(From, "aim_helper")
    stub = find_decl(To, "aim_stub")
    @test helper !== nothing && stub !== nothing
    @test CC.is_null_handle(CC.GetAlreadyImportedOrNull(imp, helper))
    @test CC.MapImported(imp, helper, stub) == stub
    @test CC.GetAlreadyImportedOrNull(imp, helper) == stub

    # an error recorded against a declaration reads back as the kind it was set to; the
    # "no error" answer cannot be an enumerator, because Unknown is a real kind
    CC.setODRHandling(imp, CC.CXASTImporter_Liberal)
    @test CC.getImportDeclErrorIfAny(imp, widget) === nothing
    CC.setImportDeclError(imp, widget, CC.CXASTImportError_NameConflict)
    @test CC.getImportDeclErrorIfAny(imp, widget) == CC.CXASTImportError_NameConflict

    dispose(minimal)
    dispose(imp)
    dispose(To)
    dispose(From)
end
