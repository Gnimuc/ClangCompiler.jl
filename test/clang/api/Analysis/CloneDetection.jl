using ClangCompiler
import ClangCompiler as CC
using Test

@testset "Analysis | CloneDetection" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        # clone_a and clone_b are type-II clones: the same statement tree with every
        # identifier renamed. clone_c shares nothing with them.
        CC.parse(I, """
            int clone_a(int x, int y) {
                int r = 0;
                for (int i = 0; i < x; ++i) {
                    r += i * y;
                    if (r > 100) { r -= 7; } else { r += 3; }
                }
                return r;
            }
            int clone_b(int u, int v) {
                int s = 0;
                for (int j = 0; j < u; ++j) {
                    s += j * v;
                    if (s > 100) { s -= 7; } else { s += 3; }
                }
                return s;
            }
            int clone_c(int k) { return k; }
            """)
        function fn(name)
            CC.reset(f)
            @assert f(I, name)
            return CC.getAsFunction(CC.get_decl(f))
        end
        fa, fb, fc = fn("clone_a"), fn("clone_b"), fn("clone_c")

        cd = CC.CloneDetector()
        try
            # nothing has been searched yet, so there is nothing to report
            @test CC.getNumCloneGroups(cd) == 0
            @test isempty(CC.getCloneGroups(cd))

            CC.analyzeCodeBody(cd, fa)
            CC.analyzeCodeBody(cd, fb)
            CC.analyzeCodeBody(cd, fc)
            CC.findClones(cd; min_complexity=10, min_group_size=2)

            ngroups = Int(CC.getNumCloneGroups(cd))
            @test ngroups >= 1
            groups = CC.getCloneGroups(cd)
            @test length(groups) == ngroups

            saw_pair = false
            for g = 0:(ngroups - 1)
                sz = Int(CC.getCloneGroupSize(cd, g))
                # min_group_size is the constraint the pipeline was given
                @test sz >= 2
                grp = groups[g + 1]
                @test length(grp) == sz

                decls = Set{UInt}()
                for i = 0:(sz - 1)
                    rec = grp[i + 1]
                    # the record and the indexed accessors describe the same clone
                    @test rec.decl.ptr == CC.getCloneContainingDecl(cd, g, i).ptr
                    @test length(rec.stmts) == Int(CC.getCloneNumStmts(cd, g, i))
                    @test rec.holds_sequence == CC.cloneHoldsSequence(cd, g, i)
                    # every clone the detector reports is non-empty and carries a real
                    # containing declaration
                    @test !isempty(rec.stmts)
                    @test !CC.is_null_handle(rec.decl)
                    @test all(s -> !CC.is_null_handle(s), rec.stmts)
                    @test !CC.is_null_handle(rec.range.begin_loc)
                    # a clone always contains itself
                    @test CC.cloneContains(cd, g, i, g, i)
                    push!(decls, UInt(rec.decl.ptr))
                end
                # clone_c shares no code with the other two, so it can never appear in a
                # group beside them
                @test !(UInt(fc.ptr) in decls) || length(decls) == 1
                if UInt(fa.ptr) in decls && UInt(fb.ptr) in decls
                    saw_pair = true
                end
            end
            # the two renamed copies are what the type-II pipeline exists to find
            @test saw_pair

            # raising the group-size floor above what the source can supply empties the
            # result: the knob is really reaching the constraint
            CC.findClones(cd; min_complexity=10, min_group_size=99)
            @test CC.getNumCloneGroups(cd) == 0
            # ... and re-running restores it, so findClones replaces rather than appends
            CC.findClones(cd; min_complexity=10, min_group_size=2)
            @test Int(CC.getNumCloneGroups(cd)) == ngroups

            # a complexity floor no statement in this source can reach does the same
            CC.findClones(cd; min_complexity=100000, min_group_size=2)
            @test CC.getNumCloneGroups(cd) == 0
        finally
            CC.dispose(cd)
        end

        # a declaration with no body cannot be analysed: clang asserts on it
        CC.reset(f)
        CC.parse(I, "int clone_no_body(int k);")
        @assert f(I, "clone_no_body")
        nfd = CC.getAsFunction(CC.get_decl(f))
        cd2 = CC.CloneDetector()
        try
            @test !CC.hasBody(nfd)
            @test_throws AssertionError CC.analyzeCodeBody(cd2, nfd)
        finally
            CC.dispose(cd2)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
