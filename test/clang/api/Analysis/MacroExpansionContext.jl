using ClangCompiler
import ClangCompiler as CC
using Test

@testset "Analysis | MacroExpansionContext" begin
    I = CC.create_interpreter(String[])
    ci = CC.get_instance(I)
    # the context must be registered before the code of interest is preprocessed, and it
    # has to outlive the Preprocessor it hooks — hence the disposal order at the bottom
    mec = CC.MacroExpansionContext(CC.getLangOpts(ci))
    f = CC.DeclFinder(I)
    try
        # nothing recorded yet, and an invalid location is not a macro expansion: the
        # disengaged optional reads back as `nothing`, not as the empty string
        @test CC.getExpandedText(mec, CC.SourceLocation()) === nothing
        @test CC.getOriginalText(mec, CC.SourceLocation()) === nothing
        # the two bulk renderings start out as their headers and nothing else
        empty_texts = CC.dumpExpandedTextsToString(mec)
        empty_ranges = CC.dumpExpansionRangesToString(mec)

        CC.registerForPreprocessor(mec, CC.getPreprocessor(ci))
        CC.parse(I, """
            #define MEC_ONE 1
            #define MEC_ADD(a, b) ((a) + (b))
            int mec_v = MEC_ADD(MEC_ONE, 2);
            int mec_plain = 7;
            """)

        sm = CC.getSourceManager(ci)
        @assert f(I, "mec_v")
        vd = CC.resolve(CC.get_decl(f))
        @test vd isa CC.VarDecl
        init = CC.getInit(vd)
        # the initializer's own begin location sits inside the expansion; the expansion
        # location is where `MEC_ADD` was written, which is the key the context records
        spelled = CC.getBeginLoc(init)
        loc = CC.getExpansionLoc(sm, spelled)

        expanded = CC.getExpandedText(mec, loc)
        @test expanded !== nothing
        # the transitive expansion substitutes MEC_ONE too, so both operands and the
        # operator survive into the expanded text
        @test occursin("1", expanded)
        @test occursin("2", expanded)
        @test occursin("+", expanded)

        original = CC.getOriginalText(mec, loc)
        @test original !== nothing
        @test occursin("MEC_ADD", original)
        # the original spelling is what the macro replaced, so it must not be the
        # expansion — that is the whole distinction between the two accessors
        @test original != expanded

        # a location with no macro expansion behind it stays disengaged
        CC.reset(f)
        @assert f(I, "mec_plain")
        plain = CC.resolve(CC.get_decl(f))
        plain_loc = CC.getExpansionLoc(sm, CC.getBeginLoc(CC.getInit(plain)))
        @test CC.getExpandedText(mec, plain_loc) === nothing
        @test CC.getOriginalText(mec, plain_loc) === nothing

        # the bulk renderings now have something to show that they did not before
        @test length(CC.dumpExpandedTextsToString(mec)) > length(empty_texts)
        @test length(CC.dumpExpansionRangesToString(mec)) > length(empty_ranges)
    finally
        CC.dispose(f)
        # the Preprocessor holds callbacks into `mec`, so it goes first
        CC.dispose(I)
        CC.dispose(mec)
    end
end
