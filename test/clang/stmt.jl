using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, compile, DeclFinder, get_decl
using ClangCompiler: FunctionDecl, getBody, resolve, children, getChildren
using ClangCompiler: getStmtClass, getStmtClassName, getNumChildren
using ClangCompiler: getBeginLoc, getEndLoc, isExpr, isIfStmt, isValueStmt
using ClangCompiler: IfStmt, WhileStmt, ReturnStmt, CompoundStmt, DeclStmt, BinaryOperator, ImplicitCastExpr
using ClangCompiler: Expr_, getType, getValueKind, IgnoreParenImpCasts, get_name
using ClangCompiler: getCond, getThen, getElse, getBody, getRetValue, getLHS, getRHS
using ClangCompiler: getOpcode, getOpcodeStr, isComparisonOp, isSingleDecl, getSingleDecl
using ClangCompiler: getNumArgs, getDirectCallee, getMethodDecl, getCallOperator
using ClangCompiler: CXXMemberCallExpr, LambdaExpr, CallExpr, VarDecl, DeclRefExpr
using ClangCompiler: STMT_CLASS_TO_TYPE
using ClangCompiler.LibClangEx
using Test

using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
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

@testset "Stmt hierarchy table" begin
    # Re-parse the vendored StmtNodes.inc as an independent oracle and check the
    # generated + hand-written hierarchy against it: every class's abstract type
    # subtypes its parent's abstract, and every concrete class has a carrier
    # subtyping its abstract. Same source gen/stmt_nodes.jl reads, parsed here
    # separately so a generator mistake can't validate itself.
    stmt_carrier_name(name) = name === :Expr ? :Expr_ : Symbol(name)
    inc = joinpath(pkgdir(ClangCompiler), "deps", "ClangExtra", "include", "clang-ex", "AST", "StmtNodes.inc")
    abstract_re = r"^ABSTRACT_STMT\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    nodes = NamedTuple{(:name, :parent, :isabstract),Tuple{Symbol,Symbol,Bool}}[]
    for line in eachline(inc)
        line = strip(line)
        ma = match(abstract_re, line)
        mc = ma === nothing ? match(concrete_re, line) : nothing
        if ma !== nothing
            push!(nodes, (name=Symbol(ma.captures[1]), parent=Symbol(ma.captures[2]), isabstract=true))
        elseif mc !== nothing
            mc.captures[1] in ("STMT_RANGE", "LAST_STMT_RANGE", "ABSTRACT_STMT") && continue
            push!(nodes, (name=Symbol(mc.captures[2]), parent=Symbol(mc.captures[3]), isabstract=false))
        end
    end
    @test !isempty(nodes)

    # A name cannot be both a carrier and an abstract type, and `Abstract` + `X` collides with
    # the mirror of a clang class already named `AbstractX`. Such a class is not mirrored at
    # all: no carrier, no abstract, children hung off its parent. Every other class has
    # exactly one of each.
    unmirrored(name) = startswith(String(name), "Abstract")
    parent_of = Dict(n.name => n.parent for n in nodes)
    function abstract_of(name)
        while unmirrored(name)
            name = parent_of[name]
        end
        return name === :Stmt ? CC.AbstractStmt : getfield(ClangCompiler, Symbol("Abstract", name))
    end

    swept = 0
    for n in nodes
        if unmirrored(n.name)
            # its doubled mirror does not exist, which is the whole point
            @test !isdefined(ClangCompiler, Symbol("Abstract", n.name))
            # the plain name may well be defined -- freeing it is why the class was dropped,
            # and it now names the abstract over `ConditionalOperator` -- but never as a
            # carrier for *this* class
            sym = stmt_carrier_name(n.name)
            @test !isdefined(ClangCompiler, sym) || !isstructtype(getfield(ClangCompiler, sym))
            continue
        end
        # every other class -- abstract C++ bases included -- has a carrier subtyping its own
        # abstract, and that abstract subtypes its parent's
        @test getfield(ClangCompiler, stmt_carrier_name(n.name)) <: abstract_of(n.name)
        @test abstract_of(n.name) <: abstract_of(n.parent)
        swept += 1
    end
    @test swept > 200                     # the sweep really covered the hierarchy

    # The one unmirrored class, pinned by name so the sweep above cannot go vacuous on it.
    # `AbstractConditionalOperator` names the abstract type over clang's `ConditionalOperator`
    # -- the spelling freed by dropping the class clang gave that name to.
    @test !isdefined(ClangCompiler, :AbstractAbstractConditionalOperator)
    @test isabstracttype(CC.AbstractConditionalOperator)
    @test CC.ConditionalOperator <: CC.AbstractConditionalOperator
    # both spellings hang off Expr directly now, and are siblings, so a ConditionalOperator-only
    # method cannot reach the other
    @test CC.AbstractConditionalOperator <: CC.AbstractExpr
    @test CC.AbstractBinaryConditionalOperator <: CC.AbstractExpr
    @test !(CC.BinaryConditionalOperator <: CC.AbstractConditionalOperator)

    # every concrete class has an enum value and a carrier in the resolve map
    @test length(STMT_CLASS_TO_TYPE) == count(n -> !n.isabstract, nodes)
end

@testset "Stmt traversal & classification" begin
    I = create_interpreter()
    compile(I, """
               int fact(int n) {
                   if (n <= 1) { return 1; }
                   int r = 1;
                   while (n > 1) { r *= n; --n; }
                   return r;
               }
               """)
    lookup = DeclFinder(I)
    @test lookup(I, "fact")
    fd = FunctionDecl(get_decl(lookup))

    body = getBody(fd)
    @test getStmtClassName(body) == "CompoundStmt"
    @test getStmtClass(body) == LibClangEx.CXStmtClass_CompoundStmtClass
    @test resolve(body) isa CompoundStmt

    kids = children(body)
    @test length(kids) == 4
    @test typeof.(kids) == [IfStmt, DeclStmt, WhileStmt, ReturnStmt]

    # IfStmt without else/init exposes exactly cond + then — accessors, not just children length
    ifstmt = kids[1]
    if_kids = children(ifstmt)
    @test length(if_kids) == 2
    @test getCond(ifstmt) == if_kids[1]
    @test getThen(ifstmt) == if_kids[2]
    @test CC.is_null_handle(getElse(ifstmt))

    # stamped predicates and casts, including an abstract-base cast
    cond = if_kids[1]
    @test cond isa BinaryOperator
    @test isExpr(cond)
    @test isValueStmt(cond)
    @test !isIfStmt(cond)
    e = Expr_(cond)
    @test e == cond
    @test isIfStmt(ifstmt) && !isExpr(ifstmt)
    @test getOpcode(cond) == LibClangEx.CXBinaryOperatorKind_BO_LE
    @test getOpcodeStr(cond) == "<="
    @test isComparisonOp(cond)

    # Expr base API
    ty = getType(e)
    # the default printing policy spells C++ bool as C's _Bool
    @test get_name(ty) in ("bool", "_Bool")
    @test getValueKind(e) == LibClangEx.CXExprValueKind_VK_PRValue
    @test IgnoreParenImpCasts(e) == e

    # source locations: invalid is the zero encoding, so isValid is the real check, and a
    # multi-line body is what separates begin from end
    @test CC.isValid(getBeginLoc(body))
    @test CC.isValid(getEndLoc(body))
    @test getBeginLoc(body) != getEndLoc(body)

    ds = kids[2]
    @test isSingleDecl(ds)
    @test CC.getName(VarDecl(getSingleDecl(ds))) == "r"

    wh = kids[3]
    wcond = CC.resolve(getCond(wh))
    @test wcond isa BinaryOperator
    @test getOpcodeStr(wcond) == ">"
    @test isComparisonOp(wcond)

    ret = kids[4]
    @test getNumChildren(ret) == 1  # return r;
    rdref = CC.resolve(IgnoreParenImpCasts(getRetValue(ret)))
    @test rdref isa DeclRefExpr
    @test CC.getName(CC.getDecl(rdref)) == "r"

    dispose(lookup)
    dispose(I)
end

@testset "AST" begin
    I = create_interpreter([joinpath(pkgdir(ClangCompiler), "test", "cxx", "main.cpp")])

    decl_lookup = DeclFinder(I)
    @test decl_lookup(I, "Node")
    decl = get_decl(decl_lookup)
    # A C++ class's declaration context opens with the implicit injected-class-name --
    # the CXXRecord naming the class from inside itself -- and the fields follow it.
    kinds = [getDeclKindName(d) for d in DeclIterator(decl)]
    @test kinds[1] == "CXXRecord"
    @test CC.isImplicit(first(DeclIterator(decl)))
    for field in DeclIterator(decl)
        CC.isImplicit(field) && continue
        CC.dump(field)
        @test getDeclKindName(field) == "Field"
    end
    @test count(==("Field"), kinds) == 2

    @test decl_lookup(I, "Foo")
    decl = get_decl(decl_lookup)
    foo_kinds = [getDeclKindName(d) for d in DeclIterator(decl)]
    @test count(==("CXXConstructor"), foo_kinds) == 2
    @test count(==("Field"), foo_kinds) == 1

    dispose(decl_lookup)
    dispose(I)
end

@testset "bulk subtree traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fn(int a){ int s=0; for(int i=0;i<a;i++){ s+=i*2; if(s>10) break; } return s; }")
    f = DeclFinder(I)
    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))

    # bulk subtree must match a manual recursive children walk, node-for-node.
    function walk(x, acc)
        push!(acc, x)
        for c in CC.children(x)
            walk(c, acc)
        end
        acc
    end
    rec = walk(body, CC.AbstractStmt[])
    bulk = CC.subtree(body)
    @test length(bulk) == length(rec)
    @test bulk[1] isa CC.CompoundStmt                       # pre-order: root first
    @test !any(x -> isabstracttype(typeof(x)), bulk)        # every node fully resolved
    @test [s.ptr for s in bulk] == [s.ptr for s in rec]     # same nodes, same order

    dispose(f)
    dispose(I)
end
