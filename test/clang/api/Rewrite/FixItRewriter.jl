using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "FixItRewriter | it displaces and restores the diagnostic client" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    de = CC.getDiagnostics(ci)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    before = CC.getClient(de)
    @test before.ptr != C_NULL

    fr = CC.FixItRewriter(de, sm, lo; fix_what_you_can=true)
    # constructing one installs it as the engine's client, ahead of whatever was there
    @test CC.getClient(de).ptr != before.ptr

    # and it forwards this query to the client it displaced
    @test CC.IncludeInDiagnosticCounts(fr)

    dispose(fr)
    # destroying it puts the previous client back, ownership flag and all
    @test CC.getClient(de).ptr == before.ptr

    dispose(I)
end

@testset "FixItRewriter | fixes stay unmaterialised until WriteFixedFiles" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCFixTag { int aa; };")

    ci = get_instance(I)
    de = CC.getDiagnostics(ci)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    f = DeclFinder(I)
    @test f(I, "CCFixTag")
    loc = CC.getBeginLoc(CC.getSourceRange(get_decl(f)))
    fid = CC.getFileID(sm, loc)

    fr = CC.FixItRewriter(de, sm, lo; fix_what_you_can=true)

    # a declaration missing its semicolon is one of clang's fix-it diagnostics, so hints do
    # arrive -- but they are batched into the rewriter's private EditedSource, and nothing
    # reaches its buffers until WriteFixedFiles replays them. That sequencing is the whole
    # reason this API is awkward, so it is what the test pins.
    CC.parse(I, "int ccfixmissing = 1")
    @test CC.getNumBuffers(fr) == 0
    @test !CC.IsModified(fr, fid)
    @test CC.WriteFixedFile(fr, fid) == ""

    # WriteFixedFiles is deliberately NOT called here: it derives an output path from each
    # changed file's FileEntry, and the interpreter parses from memory buffers, which have
    # none.

    dispose(fr)
    dispose(fid)
    dispose(f)
    dispose(I)
end
