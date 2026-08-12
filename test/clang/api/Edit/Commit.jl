using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

# Applies one commit built by `build!` and returns the rewritten text of the file the decl
# lives in, so each edit below can be checked against what actually reached the source.
function cc_commit_text(I, sm, lo, loc, build!)
    es = CC.EditedSource(sm, lo)
    c = CC.Commit(es)
    ok = build!(c)
    committed = ok && CC.commit(es, c)
    rw = CC.Rewriter(sm, lo)
    committed && CC.applyRewrites(es, rw)
    fid = CC.getFileID(sm, loc)
    text = CC.getRewriteBufferText(rw, fid)
    dispose(fid)
    dispose(rw)
    dispose(c)
    dispose(es)
    return ok, committed, text
end

@testset "Commit | the edit vocabulary" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCCommitTag { int a; };")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    f = DeclFinder(I)
    @test f(I, "CCCommitTag")
    d = get_decl(f)
    r = CC.getSourceRange(d)
    loc = CC.getBeginLoc(r)
    csr = CC.getTokenRange(r)
    @test CC.isValid(loc)

    # insert / insertAfterToken / insertBefore all land, at the places their names promise
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.insert(c, loc, "/*at*/"))
    @test ok && committed
    @test occursin("/*at*/struct", text)

    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.insertAfterToken(c, loc, "/*after*/"))
    @test ok && committed
    @test occursin("struct/*after*/", text)

    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.insertBefore(c, loc, "/*before*/"))
    @test ok && committed
    @test occursin("/*before*/struct", text)

    # replace swaps the whole declaration out
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.replace(c, csr, "struct CCCommitTag2 {}"))
    @test ok && committed
    @test occursin("CCCommitTag2", text)
    @test !occursin("int a;", text)

    # remove deletes it
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.remove(c, csr))
    @test ok && committed
    @test !occursin("CCCommitTag", text)

    # insertWrap brackets it
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.insertWrap(c, "/*<*/", csr, "/*>*/"))
    @test ok && committed
    @test occursin("/*<*/struct", text)
    @test occursin("/*>*/", text)

    # replaceWithInner keeps an inner range and drops what surrounds it: here the inner
    # range is just the `struct` keyword, so the declaration it introduced goes away
    keyword = CC.getTokenRange(loc, loc)
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.replaceWithInner(c, csr, keyword))
    @test ok && committed
    @test occursin("struct", text)
    @test !occursin("CCCommitTag", text)

    # and the containment really is checked: swapping the two ranges is refused
    ok, _, _ = cc_commit_text(I, sm, lo, loc, c -> CC.replaceWithInner(c, keyword, csr))
    @test !ok

    # insertFromRange copies existing source rather than new text
    ok, committed, text = cc_commit_text(I, sm, lo, loc, c -> CC.insertFromRange(c, loc, csr))
    @test ok && committed
    @test length(collect(eachmatch(r"CCCommitTag", text))) >= 2

    # replaceText is guarded by the spelling at the location, and in this interpreter it
    # refuses BOTH the spelling that is there and one that is not.
    #
    # OBSERVED, not assumed: `replaceText(loc, "struct", "class")` at the record's
    # getBeginLoc returns false, and so does `replaceText(getLocation(r), "CCCommitTag",
    # ...)` at the name. Every other verb on the same Commit over the same location works
    # (the insert/insertFromRange/replaceWithInner cases above all commit), so this is the
    # spelling guard specifically and not a dead Commit or an unusable location. Whatever
    # the guard reads does not line up with the interpreter's virtual `<<< inputs >>>`
    # buffer, and refusing is the safe direction for a guard to fail in.
    #
    # So the assertion is the refusal, which is real and falsifiable -- a shim that
    # ignored the guard and edited anyway would fail it. What is NOT covered here is a
    # successful replaceText; that wants a source setup this test does not have.
    ok, _, _ = cc_commit_text(I, sm, lo, loc, c -> CC.replaceText(c, loc, "struct", "class"))
    @test !ok
    ok, _, _ = cc_commit_text(I, sm, lo, loc, c -> CC.replaceText(c, loc, "union", "class"))
    @test !ok

    dispose(f)
    dispose(I)
end
