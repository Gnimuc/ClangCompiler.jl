using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Rewriter" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCRwTag { int a; };")

    ci = CC.get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    rw = CC.Rewriter(sm, lo)
    # nothing has been edited yet, so there is no buffer to write back to disk
    @test !(CC.overwriteChangedFiles(rw))

    f = DeclFinder(I)
    @test f(I, "CCRwTag")
    d = get_decl(f)
    r = CC.getSourceRange(d)
    @test CC.isValid(r)
    @test CC.isRewritable(CC.getBeginLoc(r))
    @test CC.isRewritable(CC.getEndLoc(r))

    text = CC.getRewrittenText(rw, r)
    @test occursin("struct CCRwTag", text)
    @test occursin("int a;", text)
    # getRangeSize is the byte length of that rewritten span, not an independent count
    @test CC.getRangeSize(rw, r) == ncodeunits(text)

    # the Clang convention is inverted: `true` means the edit was rejected
    @test !CC.InsertTextBefore(rw, CC.getBeginLoc(r), "/*ccrw*/")
    @test occursin("/*ccrw*/", CC.getRewrittenText(rw, r))

    dispose(f)
    dispose(rw)
    dispose(I)
end

@testset "Rewriter | language options accessor" begin
    I = CC.create_interpreter(String[])
    ci = CC.get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    rw = CC.Rewriter(sm, lo)
    # the rewriter hands back the very options it was created with, not a copy
    @test CC.getLangOpts(rw).ptr == lo.ptr
    CC.dispose(rw)
    CC.dispose(I)
end

@testset "Rewriter | in-memory retrieval of a rewritten buffer" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct CCRwBufTag { int a; };")

    ci = CC.get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    rw = CC.Rewriter(sm, lo)

    f = DeclFinder(I)
    @test f(I, "CCRwBufTag")
    loc = CC.getBeginLoc(CC.getSourceRange(get_decl(f)))
    @test CC.isValid(loc)
    @test CC.isRewritable(loc)
    fid = CC.getFileID(sm, loc)

    # an untouched file has no rewrite buffer at all
    @test CC.getNumBuffers(rw) == 0
    @test !CC.hasChangesForFileID(rw, fid)
    @test CC.getRewriteBufferText(rw, fid) == ""

    # the Clang convention is inverted: `false` means the edit was accepted
    @test !CC.InsertTextBefore(rw, loc, "/*ccrwbuf*/")

    @test CC.hasChangesForFileID(rw, fid)
    @test CC.getNumBuffers(rw) == 1
    text = CC.getRewriteBufferText(rw, fid)
    # the whole file comes back, edit and all -- not just the edited range
    @test occursin("/*ccrwbuf*/", text)
    @test occursin("struct CCRwBufTag", text)

    # and the one buffer the rewriter enumerates is the file that was edited
    only_id = CC.getBufferFileID(rw, 0)
    @test CC.getHashValue(only_id) == CC.getHashValue(fid)
    dispose(only_id)

    dispose(fid)
    dispose(f)
    dispose(rw)
    dispose(I)
end

@testset "Rewriter | setSourceMgr rebinds the rewriter" begin
    I1 = create_interpreter(String[])
    I2 = create_interpreter(String[])
    sm1 = CC.getSourceManager(CC.get_instance(I1))
    lo1 = CC.getLangOpts(CC.get_instance(I1))
    sm2 = CC.getSourceManager(CC.get_instance(I2))
    lo2 = CC.getLangOpts(CC.get_instance(I2))
    # two interpreters really do have their own source managers, or the test below is empty
    @test sm1.ptr != sm2.ptr

    rw = CC.Rewriter(sm1, lo1)
    @test CC.getSourceMgr(rw).ptr == sm1.ptr
    CC.setSourceMgr(rw, sm2, lo2)
    @test CC.getSourceMgr(rw).ptr == sm2.ptr
    @test CC.getLangOpts(rw).ptr == lo2.ptr

    dispose(rw)
    dispose(I2)
    dispose(I1)
end
