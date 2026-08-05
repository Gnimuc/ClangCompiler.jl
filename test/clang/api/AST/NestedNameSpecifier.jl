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

@testset "NestedNameSpecifier navigation" begin
    I = create_interpreter(String[])
    CC.parse(I, "namespace N { struct S {}; } N::S obj;")
    f = DeclFinder(I)
    @test f(I, "obj")
    vd = CC.VarDecl(get_decl(f))
    ety = CC.resolve(CC.getTypePtr(CC.getType(vd)))
    @test ety isa CC.ElaboratedType
    nns = CC.getQualifier(ety)
    @test nns.ptr != C_NULL
    @test CC.getKind(nns) == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
    @test CC.getName(CC.getAsNamespace(nns)) == "N"
    @test CC.isDependent(nns) == false
    dispose(f)
    dispose(I)
end
