using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "LambdaExpr captures" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "auto get_lambda(int cap) { return [cap]() { return cap; }; }")
    @test f(I, "get_lambda")
    fn = CC.FunctionDecl(get_decl(f).ptr)
    le = _find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn)))
    @test le isa CC.LambdaExpr
    @test CC.isGenericLambda(le) == false
    @test CC.getNumCaptures(le) == 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.capturesVariable(cap)
    @test !CC.capturesThis(cap)
    @test CC.getCaptureKind(cap) == CC.LibClangEx.CXLambdaCaptureKind_LCK_ByCopy
    dispose(f)
    dispose(I)
end
