using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# The adjusters are pure functions over a command line: no AST, no interpreter, and a result
# clang's own source fixes exactly. That is what makes them assertable by value rather than
# by shape, so every testset here pins the command line that comes back.

@testset "ArgumentsAdjuster | the prebuilt factories rewrite a command line" begin
    syntax_only = CC.getClangSyntaxOnlyAdjuster()
    @test syntax_only.ptr != C_NULL

    out = CC.adjust(syntax_only, ["clang++", "-Wall", "a.cc"], "a.cc")
    @test out == ["clang++", "-Wall", "a.cc", "-fsyntax-only"]
    # the flag is added once per command line, not once per application
    @test count(==("-fsyntax-only"), CC.adjust(syntax_only, out, "a.cc")) == 1
    # and the options that would have produced output on the side are dropped
    @test !("-save-temps" in CC.adjust(syntax_only, ["clang++", "-save-temps", "a.cc"], "a.cc"))

    strip_output = CC.getClangStripOutputAdjuster()
    # `-o foo` is two arguments and both go; nothing else does
    @test CC.adjust(strip_output, ["clang++", "-o", "a.o", "a.cc"], "a.cc") == ["clang++", "a.cc"]
    # a command line with no output flag comes back unchanged
    @test CC.adjust(strip_output, ["clang++", "a.cc"], "a.cc") == ["clang++", "a.cc"]

    strip_deps = CC.getClangStripDependencyFileAdjuster()
    # -MD stands alone, -MF takes the file name after it, and both forms go
    @test CC.adjust(strip_deps, ["clang++", "-MD", "-MF", "a.d", "a.cc"], "a.cc") == ["clang++", "a.cc"]

    strip_plugins = CC.getStripPluginsAdjuster()
    plugged = CC.adjust(strip_plugins, ["clang++", "-Xclang", "-add-plugin", "-Xclang", "aplugin", "a.cc"], "a.cc")
    @test !("-add-plugin" in plugged)
    @test !("aplugin" in plugged)
    @test "clang++" in plugged
    @test "a.cc" in plugged
    # -Wall is not plugin-related, so this one has nothing to do to it
    @test CC.adjust(strip_plugins, ["clang++", "-Wall", "a.cc"], "a.cc") == ["clang++", "-Wall", "a.cc"]

    dispose(strip_plugins)
    dispose(strip_deps)
    dispose(strip_output)
    dispose(syntax_only)
end

@testset "ArgumentsAdjuster | insertion position and combination" begin
    at_end = CC.getInsertArgumentAdjuster("-DEND=1")
    at_begin = CC.getInsertArgumentAdjuster("-DBEGIN=1", CC.CXArgumentInsertPosition_BEGIN)

    # BEGIN means "right after argv[0]", not "at index 0" -- clang steps over the program
    # name before inserting, which is the whole difference between the two positions.
    @test CC.adjust(at_begin, ["clang++", "a.cc"], "a.cc") == ["clang++", "-DBEGIN=1", "a.cc"]
    @test CC.adjust(at_end, ["clang++", "a.cc"], "a.cc") == ["clang++", "a.cc", "-DEND=1"]

    # the list overload inserts all of its arguments, in order
    many = CC.getInsertArgumentAdjuster(["-DA=1", "-DB=2"], CC.CXArgumentInsertPosition_BEGIN)
    @test CC.adjust(many, ["clang++", "a.cc"], "a.cc") == ["clang++", "-DA=1", "-DB=2", "a.cc"]

    # Combination is ordered: the second adjuster runs on the first one's output. Two BEGIN
    # adjusters show it -- whichever runs last ends up nearest the program name.
    second_wins = CC.combineAdjusters(at_begin, many)
    @test CC.adjust(second_wins, ["clang++", "a.cc"], "a.cc") == ["clang++", "-DA=1", "-DB=2", "-DBEGIN=1", "a.cc"]
    other_order = CC.combineAdjusters(many, at_begin)
    @test CC.adjust(other_order, ["clang++", "a.cc"], "a.cc") == ["clang++", "-DBEGIN=1", "-DA=1", "-DB=2", "a.cc"]

    # combining copies the two closures, so both are still the caller's to dispose and both
    # still work on their own after the combination is gone
    dispose(other_order)
    dispose(second_wins)
    @test CC.adjust(at_end, ["clang++"], "a.cc") == ["clang++", "-DEND=1"]

    # A BEGIN adjuster steps past the program name unconditionally, so an empty command line
    # would have it insert past the end of the vector. The handle does not carry the position
    # it was built with, so the gate refuses an empty command line for every adjuster.
    @test_throws AssertionError CC.adjust(at_end, String[], "a.cc")

    dispose(many)
    dispose(at_begin)
    dispose(at_end)
end
