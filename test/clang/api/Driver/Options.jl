using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# clang::driver::getDriverOptTable is a singleton generated from Options.td, so none of this
# needs a driver, a toolchain or an interpreter.

@testset "OptTable | the driver's own option table" begin
    table = CC.getDriverOptTable()
    n = CC.getNumOptions(table)
    @test n > 100

    # Option IDs run 1..n; 0 is OPT_INVALID and clang indexes the table with a bare assert.
    @test_throws AssertionError CC.getOptionName(table, 0)
    @test_throws AssertionError CC.getOptionName(table, n + 1)
    @test_throws AssertionError CC.getOption(table, 0)

    # Read every name once. Almost all of them are non-empty -- the exception is the bare
    # "--" option, whose whole spelling is its prefix -- so a shim answering "" everywhere
    # fails here while the legitimate blanks do not.
    names = [CC.getOptionName(table, i) for i = 1:n]
    @test count(!isempty, names) > 100
    id = findfirst(==("fsyntax-only"), names)
    @test id !== nothing

    # -fsyntax-only is a flag with help text, and the boxed Option agrees with the table it
    # came from about all three.
    @test !isempty(CC.getOptionHelpText(table, id))
    opt = CC.getOption(table, id)
    @test CC.isValid(opt)
    @test CC.getID(opt) == id
    @test CC.getName(opt) == CC.getOptionName(table, id)
    @test CC.getPrefixedName(opt) == "-fsyntax-only"
    @test CC.getKind(opt) == CC.CXOptionClass_FlagClass
    dispose(opt)

    # A joined option is a different kind, which is what makes the kind worth reading.
    std_id = findfirst(==("std="), names)
    @test std_id !== nothing
    std_opt = CC.getOption(table, std_id)
    @test CC.getPrefixedName(std_opt) == "-std="
    @test CC.getKind(std_opt) != CC.CXOptionClass_FlagClass
    dispose(std_opt)
end

@testset "OptTable | did-you-mean and the rendered help" begin
    table = CC.getDriverOptTable()

    # An exact spelling is distance 0 and comes back unchanged.
    nearest, distance = CC.findNearest(table, "-fsyntax-only")
    @test distance == 0
    @test nearest == "-fsyntax-only"

    # A one-character typo is found at a positive distance, which is the suggestion clang
    # itself prints.
    nearest2, distance2 = CC.findNearest(table, "-fsyntax-onlyy")
    @test distance2 > 0
    @test nearest2 == "-fsyntax-only"

    # Nothing within the allowed distance is reported as no suggestion at all.
    nearest3, distance3 = CC.findNearest(table, "-clangcompiler-nowhere-near-any-option";
                                         maximum_distance=1)
    @test isempty(nearest3)
    @test distance3 > 1

    # The help screen carries the usage line, the title and the options themselves.
    help = CC.printHelp(table, "clangcompiler [options]", "ClangCompiler test overview")
    @test occursin("clangcompiler [options]", help)
    @test occursin("ClangCompiler test overview", help)
    @test occursin("-fsyntax-only", help)

    # Narrowing the visibility mask can only remove options, never add them: the CC1-only
    # view is a subset of the whole table's.
    cc1 = CC.printHelp(table, "usage", "title";
                       visibility=Int(CC.CXClangVisibility_CC1Option))
    @test length(cc1) < length(help)
end
