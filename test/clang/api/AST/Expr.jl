using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "Expr/Stmt setters and factories" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             int compute(int n) {
                 int arr[3] = {1, 2, 3};
                 double d = 1.5;
                 double dd = (double)n;
                 return (int)d + arr[0];
             }
             """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "compute")
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    nodes = CC.subtree(CC.getBody(fd))

    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    cs = first(filter(n -> n isa CC.CStyleCastExpr, nodes))

    # ---- Factories (read-only on the parsed nodes) ---------------------------
    ity = CC.getType(il)

    # CStyleCastExpr::CreateEmpty(ctx, PathSize, HasFPFeatures)
    empty_cast = CC.CStyleCastExpr(ctx, 0, false)
    @test empty_cast isa CC.CStyleCastExpr

    # CStyleCastExpr::Create (no-type-info): int -> int NoOp cast over `il`
    noop = CC.CStyleCastExpr(ctx, ity, CC.LibClangEx.CXExprValueKind_VK_PRValue,
                             CC.LibClangEx.CXCastKind_CK_NoOp, il)
    @test noop isa CC.CStyleCastExpr
    @test CC.getCastKind(noop) == CC.LibClangEx.CXCastKind_CK_NoOp
    @test CC.getSubExpr(noop).ptr == il.ptr

    # IntegerLiteral::Create(ctx, APInt-as-GenericValue, type, loc)
    gv = CC.getValue(il)
    newil = CC.IntegerLiteral(ctx, gv, ity, CC.getLocation(il))
    @test newil isa CC.IntegerLiteral

    # ---- Setters: round-trip through the paired getters ----------------------
    loc_a = CC.getLocation(il)      # a valid SourceLocation
    loc_b = CC.getRParenLoc(cs)     # a different valid SourceLocation
    @test loc_a.ptr != loc_b.ptr

    # CStyleCastExpr::setLParenLoc / setRParenLoc (mutate the freshly-parsed cast)
    CC.setLParenLoc(cs, loc_a)
    @test CC.getLParenLoc(cs).ptr == loc_a.ptr
    CC.setRParenLoc(cs, loc_b)
    @test CC.getRParenLoc(cs).ptr == loc_b.ptr

    # IntegerLiteral::setLocation on both a parsed and a freshly-created literal
    CC.setLocation(il, loc_b)
    @test CC.getLocation(il).ptr == loc_b.ptr
    CC.setLocation(newil, loc_a)
    @test CC.getLocation(newil).ptr == loc_a.ptr

    dispose(lookup)
    dispose(I)
end

@testset "Expr payload (StringLiteral / UETT)" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)

    CC.parse(I, "const char *g_str = \"abc\";")
    @test f(I, "g_str")
    vd = CC.VarDecl(get_decl(f).ptr)
    sl = _find_node(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    @test CC.getString(sl) == "abc"
    @test CC.getLength(sl) == 3
    @test CC.isOrdinary(sl)
    @test CC.getKind(sl) == CC.LibClangEx.CXStringLiteralKind_Ordinary

    CC.parse(I, "unsigned long g_sz = sizeof(int);")
    @test f(I, "g_sz")
    vd2 = CC.VarDecl(get_decl(f).ptr)
    uett = _find_node(CC.UnaryExprOrTypeTraitExpr, CC.resolve(CC.getInit(vd2)))
    @test uett !== nothing
    @test CC.getKind(uett) == CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf

    dispose(f)
    dispose(I)
end
