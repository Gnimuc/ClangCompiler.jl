using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

# Depth-first search for the first resolved child node whose carrier is `T`.
if !@isdefined(_find_node)
    function _find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = _find_node(T, CC.resolve(c))
            r !== nothing && return r
        end
        return nothing
    end
end

@testset "OMP directive payload" begin
    I = create_interpreter(["-fopenmp"])
    CC.parse(I, "void ompf(int n){\n#pragma omp parallel num_threads(4)\n{ int x = n; }\n}")
    f = DeclFinder(I)
    @test f(I, "ompf")
    fd = CC.downcast(CC.FunctionDecl, get_decl(f).ptr)
    dir = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(fd)))
        n isa CC.AbstractOMPExecutableDirective && (dir=n; break)
    end
    @test dir isa CC.OMPParallelDirective
    @test CC.getNumClauses(dir) == 1                        # num_threads(4)
    @test !CC.isStandaloneDirective(dir)
    @test CC.hasAssociatedStmt(dir)
    @test CC.getAssociatedStmt(dir) isa CC.CapturedStmt     # resolved base Stmt*
    dispose(f)
    dispose(I)
end
