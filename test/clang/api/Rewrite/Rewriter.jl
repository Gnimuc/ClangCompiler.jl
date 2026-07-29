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
    @test rw isa CC.Rewriter
    @test rw.ptr != C_NULL
    @test !CC.is_null_handle(CC.getSourceMgr(rw))
    # nothing has been edited yet, so there is no buffer to write back to disk
    @test !(CC.overwriteChangedFiles(rw))

    f = DeclFinder(I)
    @test f(I, "CCRwTag")
    d = get_decl(f)
    r = CC.getSourceRange(d)
    @test r isa CC.SourceRange

    if CC.isValid(r) && CC.isRewritable(CC.getBeginLoc(r)) && CC.isRewritable(CC.getEndLoc(r))
        n = CC.getRangeSize(rw, r)
        @test n isa Integer
        @test !isempty(CC.getRewrittenText(rw, r))

        # the Clang convention is inverted: `true` means the edit was rejected
        failed = CC.InsertTextBefore(rw, CC.getBeginLoc(r), "/*ccrw*/")
        @test failed isa Bool
        if failed == false
            @test occursin("/*ccrw*/", CC.getRewrittenText(rw, r))
        end
    end

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
