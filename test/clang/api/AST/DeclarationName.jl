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

@testset "DeclarationNameInfo" begin
    I = create_interpreter(String[])
    CC.parse(I, "int declnameinfo_probe(int a) { return a; }")
    f = DeclFinder(I)
    @test f(I, "declnameinfo_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    ni = CC.getNameInfo(fd)                       # owned box
    @test ni isa CC.DeclarationNameInfo
    @test CC.getAsString(ni) == "declnameinfo_probe"
    @test CC.getName(ni) isa CC.DeclarationName
    @test CC.getLoc(ni) isa CC.SourceLocation
    @test CC.getBeginLoc(ni) isa CC.SourceLocation
    @test CC.getEndLoc(ni) isa CC.SourceLocation
    dispose(ni)                                   # release the box
    dispose(f)
    dispose(I)
end
