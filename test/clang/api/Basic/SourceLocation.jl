using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Coverage | BasicSourceLocation" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int presumed_probe(int a) { int r = a + 1; return r; }
             """)

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)

    f = DeclFinder(I)
    @test f(I, "presumed_probe") isa Bool
    fd = CC.FunctionDecl(get_decl(f))
    loc = CC.getLocation(fd)
    sr = CC.getSourceRange(fd)

    # ---- PresumedLoc: the boxed #line-aware view SourceManager computes ----
    ploc = CC.PresumedLoc(sm, loc)
    @test ploc isa CC.PresumedLoc
    @test CC.isValid(ploc)
    @test CC.isInvalid(ploc) == !CC.isValid(ploc)
    if CC.isValid(ploc)
        @test CC.getFilename(ploc) isa String
        # No target chooses these: the source is one line, so the presumed line is 1 and
        # the column is where the name is written. They differ, which is the only reason
        # the two accessors are separable at all -- `isa Integer` held for both.
        # PresumedLoc is the #line-aware view and no #line is in play, so it has to agree
        # with the source manager's own spelling numbers for the same location.
        @test CC.getLine(ploc) == 1
        @test CC.getColumn(ploc) > 1
        @test CC.getLine(ploc) == CC.getSpellingLineNumber(sm, loc)
        @test CC.getColumn(ploc) == CC.getSpellingColumnNumber(sm, loc)
        @test !CC.is_null_handle(CC.getIncludeLoc(ploc))
        pfid = CC.getFileID(ploc)
        @test pfid isa CC.FileID
        @test CC.isValid(pfid)
        CC.dispose(pfid)
    else
        # every accessor asserts isValid(), so the wrappers must reject this object
        @test_throws AssertionError CC.getFilename(ploc)
        @test_throws AssertionError CC.getFileID(ploc)
        @test_throws AssertionError CC.getLine(ploc)
        @test_throws AssertionError CC.getColumn(ploc)
        @test_throws AssertionError CC.getIncludeLoc(ploc)
    end
    CC.dispose(ploc)

    ploc2 = CC.PresumedLoc(sm, loc; use_line_directives=false)
    @test CC.isValid(ploc2)
    CC.dispose(ploc2)

    # an invalid location has no presumed location at all
    bad = CC.PresumedLoc(sm, CC.SourceLocation())
    @test CC.isInvalid(bad)
    @test !CC.isValid(bad)
    @test_throws AssertionError CC.getFilename(bad)
    @test_throws AssertionError CC.getFileID(bad)
    @test_throws AssertionError CC.getLine(bad)
    @test_throws AssertionError CC.getColumn(bad)
    @test_throws AssertionError CC.getIncludeLoc(bad)
    CC.dispose(bad)

    # ---- CharSourceRange: a SourceRange plus its token/character granularity ----
    tr = CC.getTokenRange(sr)
    @test tr isa CC.CharSourceRange
    @test CC.isTokenRange(tr)
    @test !CC.isCharRange(tr)
    @test CC.getAsRange(tr) isa CC.SourceRange
    @test CC.getRawEncoding(CC.getBegin(tr)) == CC.getRawEncoding(CC.getBeginLoc(sr))
    @test CC.getRawEncoding(CC.getEnd(tr)) == CC.getRawEncoding(CC.getEndLoc(sr))
    @test CC.isValid(tr)
    @test CC.isInvalid(tr) == !CC.isValid(tr)

    tr2 = CC.getTokenRange(CC.getBeginLoc(sr), CC.getEndLoc(sr))
    @test CC.isTokenRange(tr2)
    @test CC.getRawEncoding(CC.getEnd(tr2)) == CC.getRawEncoding(CC.getEndLoc(sr))

    cr = CC.getCharRange(sr)
    @test CC.isCharRange(cr)
    @test !CC.isTokenRange(cr)

    cr2 = CC.getCharRange(CC.getBeginLoc(sr), CC.getEndLoc(sr))
    @test CC.isCharRange(cr2)
    CC.setTokenRange(cr2, true)
    @test CC.isTokenRange(cr2)
    CC.setTokenRange(cr2, false)
    @test CC.isCharRange(cr2)

    # the setters mutate in place, exactly as clang::CharSourceRange does
    CC.setBegin(cr2, CC.SourceLocation())
    @test CC.isInvalid(cr2)
    CC.setBegin(cr2, CC.getBeginLoc(sr))
    CC.setEnd(cr2, CC.getEndLoc(sr))
    @test CC.getRawEncoding(CC.getBegin(cr2)) == CC.getRawEncoding(CC.getBeginLoc(sr))
    @test CC.getRawEncoding(CC.getEnd(cr2)) == CC.getRawEncoding(CC.getEndLoc(sr))
    @test CC.isValid(cr2) == CC.isValid(sr)

    CC.dispose(I)
end
