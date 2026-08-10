using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

@testset "Replacement | a text edit with no SourceManager behind it" begin
    r = CC.Replacement("/tmp/ccrepl.cpp", 4, 1, "yy")
    # every field is stored verbatim, so this is a round trip through clang's own storage
    @test CC.isApplicable(r)
    @test CC.getFilePath(r) == "/tmp/ccrepl.cpp"
    @test CC.getOffset(r) == 4
    @test CC.getLength(r) == 1
    @test CC.getReplacementText(r) == "yy"

    s = CC.toString(r)
    @test occursin("/tmp/ccrepl.cpp", s)
    @test occursin("yy", s)

    # the partition isApplicable exists to draw: a default-constructed replacement names no
    # file and can never be applied
    inv = CC.Replacement()
    @test !CC.isApplicable(inv)
    @test CC.getFilePath(inv) == ""
    @test CC.getLength(inv) == 0

    dispose(inv)
    dispose(r)
end

@testset "Replacements | conflicts, shifting and string application" begin
    rs = CC.Replacements()
    @test CC.empty(rs)
    @test CC.size(rs) == 0

    a = CC.Replacement("f.cpp", 4, 1, "yy")
    ok, msg = CC.add(rs, a)
    @test ok
    @test isempty(msg)
    @test CC.size(rs) == 1
    @test !CC.empty(rs)

    got = CC.getReplacement(rs, 0)
    @test CC.getOffset(got) == 4
    @test CC.getReplacementText(got) == "yy"

    # Two edits of the same range with different text are order-dependent, which is the one
    # thing the set exists to refuse. Clang reports it as an llvm::Error, and the shim hands
    # the message back rather than dropping it.
    b = CC.Replacement("f.cpp", 4, 1, "zz")
    ok2, msg2 = CC.add(rs, b)
    @test !ok2
    @test !isempty(msg2)
    @test CC.size(rs) == 1

    # a replacement for a different file is refused for a different reason, also with a message
    c = CC.Replacement("g.cpp", 0, 0, "// generated\n")
    ok3, msg3 = CC.add(rs, c)
    @test !ok3
    @test !isempty(msg3)
    @test CC.size(rs) == 1

    # the string-level application: no SourceManager, no Rewriter, and the stored file path
    # is ignored entirely
    okc, code = CC.applyAllReplacements("int x = 1;", rs)
    @test okc
    @test code == "int yy = 1;"

    # positions before the edit are untouched; positions after it move by the length delta
    @test CC.getShiftedCodePosition(rs, 0) == 0
    @test CC.getShiftedCodePosition(rs, 6) == 7

    ranges = CC.getAffectedRanges(rs)
    @test length(ranges) == 1
    # the affected range must cover the two characters the edit wrote at offset 4
    @test ranges[1][1] <= 4
    @test ranges[1][1] + ranges[1][2] >= 6

    CC.clear(rs)
    @test CC.empty(rs)
    @test CC.size(rs) == 0

    dispose(c)
    dispose(b)
    dispose(a)
    dispose(rs)
end

@testset "Replacements | merge sequences what add refuses" begin
    # A(4,1,"yy") then B(4,2,"zzz") is order-dependent, so add() rejects B; merge() is the
    # way to say "B applies to the code A already produced".
    first_set = CC.Replacements()
    a = CC.Replacement("f.cpp", 4, 1, "yy")
    @test first(CC.add(first_set, a))

    second_set = CC.Replacements()
    b = CC.Replacement("f.cpp", 4, 2, "zzz")
    @test first(CC.add(second_set, b))

    merged = CC.merge(first_set, second_set)
    ok, code = CC.applyAllReplacements("int x = 1;", merged)
    @test ok
    @test code == "int zzz = 1;"
    # neither operand was modified
    @test CC.size(first_set) == 1
    @test CC.size(second_set) == 1

    dispose(merged)
    dispose(b)
    dispose(second_set)
    dispose(a)
    dispose(first_set)
end

@testset "Replacement | applying through a Rewriter" begin
    dir = mktempdir()
    path = joinpath(dir, "ccrepl_apply.cpp")
    write(path, "int x = 1;\n")

    I = create_interpreter(String[])
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)

    rw = CC.Rewriter(sm, lo)
    r = CC.Replacement(path, 4, 1, "yy")
    # apply() resolves the path through the rewriter's FileManager, so a real file on disk is
    # all it needs -- and it returns true on success, the opposite of Rewriter::ReplaceText
    @test CC.apply(r, rw)

    # a replacement naming a file the FileManager cannot resolve is the failing half
    bad = CC.Replacement(joinpath(dir, "no_such_file.cpp"), 0, 0, "x")
    @test !CC.apply(bad, rw)

    rw2 = CC.Rewriter(sm, lo)
    rs = CC.Replacements(r)
    @test CC.size(rs) == 1
    @test CC.applyAllReplacements(rs, rw2)

    rw3 = CC.Rewriter(sm, lo)
    # the same edits, plus clang-format over the ranges that changed
    @test CC.formatAndApplyAllReplacements(path, rs, rw3, "LLVM")

    dispose(rw3)
    dispose(rs)
    dispose(rw2)
    dispose(bad)
    dispose(r)
    dispose(rw)
    dispose(I)
end
