using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "OMP directive payload" begin
    I = create_interpreter(["-fopenmp"])
    CC.parse(I, """
    void ompf(int n) {
    #pragma omp parallel num_threads(4)
    { int x = n; }
    #pragma omp barrier
    }
    """)
    f = DeclFinder(I)
    @test f(I, "ompf")
    fd = CC.FunctionDecl(get_decl(f))
    dirs = CC.AbstractOMPExecutableDirective[]
    for n in CC.subtree(CC.resolve(CC.getBody(fd)))
        n isa CC.AbstractOMPExecutableDirective && push!(dirs, n)
    end
    @test length(dirs) == 2

    par = only(d for d in dirs if d isa CC.OMPParallelDirective)
    @test CC.getNumClauses(par) == 1                        # num_threads(4)
    @test !CC.isStandaloneDirective(par)
    @test CC.hasAssociatedStmt(par)
    @test CC.getAssociatedStmt(par) isa CC.CapturedStmt     # resolve() of the base Stmt*

    bar = only(d for d in dirs if d isa CC.OMPBarrierDirective)
    @test CC.getNumClauses(bar) == 0
    @test CC.isStandaloneDirective(bar)
    @test !CC.hasAssociatedStmt(bar)

    dispose(f)
    dispose(I)
end
