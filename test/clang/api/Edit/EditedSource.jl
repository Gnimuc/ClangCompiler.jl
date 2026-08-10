using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "EditedSource | commit, replay and clear" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCEditTag { int a; };")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    es = CC.EditedSource(sm, lo)
    # the accessors hand back the very objects the editor was built over, not copies
    @test CC.getSourceManager(es).ptr == sm.ptr
    @test CC.getLangOpts(es).ptr == lo.ptr

    f = DeclFinder(I)
    @test f(I, "CCEditTag")
    d = get_decl(f)
    loc = CC.getBeginLoc(CC.getSourceRange(d))
    @test CC.isValid(loc)
    fid, off = CC.getDecomposedLoc(sm, loc)

    # nothing recorded yet, so any offset is still insertable
    @test CC.canInsertInOffset(es, loc, fid, off)

    c = CC.Commit(es)
    @test CC.insertBefore(c, loc, "/*ccedit*/")
    @test CC.isCommitable(c)
    @test CC.commit(es, c)

    # the edits reach a Rewriter through the shim's fixed EditsReceiver, and come back out
    # of its buffer
    rw = CC.Rewriter(sm, lo)
    @test CC.getNumBuffers(rw) == 0
    CC.applyRewrites(es, rw)
    @test CC.hasChangesForFileID(rw, fid)
    text = CC.getRewriteBufferText(rw, fid)
    @test occursin("/*ccedit*/", text)
    @test occursin("struct CCEditTag", text)

    # clearRewrites really empties the accumulator: a fresh rewriter picks up nothing
    CC.clearRewrites(es)
    rw2 = CC.Rewriter(sm, lo)
    CC.applyRewrites(es, rw2)
    @test CC.getNumBuffers(rw2) == 0

    dispose(rw2)
    dispose(rw)
    dispose(c)
    dispose(fid)
    dispose(f)
    dispose(es)
    dispose(I)
end

@testset "EditedSource | a refused edit rejects the whole commit" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCEditAtomic { int a; };")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    es = CC.EditedSource(sm, lo)

    f = DeclFinder(I)
    @test f(I, "CCEditAtomic")
    loc = CC.getBeginLoc(CC.getSourceRange(get_decl(f)))

    c = CC.Commit(es)
    # a good edit first, so the batch is not rejected merely for being empty
    @test CC.insertBefore(c, loc, "/*ok*/")
    @test CC.isCommitable(c)
    # then one clang cannot express: an invalid location is not insertable
    @test !CC.insert(c, CC.SourceLocation(), "/*bad*/")
    @test !CC.isCommitable(c)

    # so nothing at all is recorded, not even the edit that was accepted
    @test !CC.commit(es, c)
    rw = CC.Rewriter(sm, lo)
    CC.applyRewrites(es, rw)
    @test CC.getNumBuffers(rw) == 0

    dispose(rw)
    dispose(c)
    dispose(f)
    dispose(es)
    dispose(I)
end
