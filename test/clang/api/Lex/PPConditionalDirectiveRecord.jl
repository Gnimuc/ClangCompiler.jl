using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

# The record is a concrete PPCallbacks the preprocessor adopts, so it has to be installed
# before the directives it should see are lexed. A throwaway interpreter is what lexes
# them here.

@testset "PPConditionalDirectiveRecord | which region a location is in" begin
    I = create_interpreter(["-std=c++17"])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)

    rec = CC.PPConditionalDirectiveRecord(pp)
    # it records into the preprocessor's own source manager, not a copy
    @test CC.getSourceManager(rec).ptr == CC.getSourceManager(ci).ptr

    before = CC.getTotalMemory(rec)
    CC.parse(I, """
             #define PPCDR_ON 1
             #if PPCDR_ON
             int ppcdr_inside = 1;
             int ppcdr_inside2 = 2;
             #endif
             int ppcdr_outside = 3;
             """)
    # the callbacks fired: a record that was never called back holds nothing
    @test CC.getTotalMemory(rec) > before

    f = DeclFinder(I)
    @test f(I, "ppcdr_inside")
    loc_in = CC.getLocation(get_decl(f))
    @test f(I, "ppcdr_inside2")
    loc_in2 = CC.getLocation(get_decl(f))
    @test f(I, "ppcdr_outside")
    loc_out = CC.getLocation(get_decl(f))

    # two declarations inside the same `#if` body share a region; one inside and one past
    # the `#endif` do not. That partition is the question a refactoring asks before moving
    # text between two points.
    @test CC.areInDifferentConditionalDirectiveRegion(rec, loc_in, loc_in2) == false
    @test CC.areInDifferentConditionalDirectiveRegion(rec, loc_in, loc_out) == true

    # and the region locations agree with that partition
    @test CC.findConditionalDirectiveRegionLoc(rec, loc_in) ==
          CC.findConditionalDirectiveRegionLoc(rec, loc_in2)
    @test CC.findConditionalDirectiveRegionLoc(rec, loc_in) !=
          CC.findConditionalDirectiveRegionLoc(rec, loc_out)

    # a range that stays inside the body crosses no directive; one that reaches past the
    # `#endif` does
    @test CC.rangeIntersectsConditionalDirective(rec, CC.SourceRange(loc_in, loc_in2)) ==
          false
    @test CC.rangeIntersectsConditionalDirective(rec, CC.SourceRange(loc_in, loc_out)) ==
          true
    # an invalid range is answered rather than asserted on
    @test CC.rangeIntersectsConditionalDirective(rec,
                                                 CC.SourceRange(CC.SourceLocation(),
                                                                CC.SourceLocation())) ==
          false

    dispose(f)
    dispose(I)
end
