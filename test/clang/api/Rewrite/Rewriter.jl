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
    @test CC.getSourceMgr(rw) isa CC.SourceManager
    # nothing has been edited yet, so there is no buffer to write back to disk
    @test CC.overwriteChangedFiles(rw) isa Bool

    f = DeclFinder(I)
    @test f(I, "CCRwTag")
    d = get_decl(f)
    r = CC.getSourceRange(d)
    @test r isa CC.SourceRange

    if CC.isValid(r) && CC.isRewritable(CC.getBeginLoc(r)) && CC.isRewritable(CC.getEndLoc(r))
        n = CC.getRangeSize(rw, r)
        @test n isa Integer
        @test CC.getRewrittenText(rw, r) isa String

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
