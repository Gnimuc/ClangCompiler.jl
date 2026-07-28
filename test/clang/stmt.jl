using ClangCompiler
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
import ClangCompiler as CC
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

@testset "Stmt hierarchy table" begin
    # Re-parse the vendored StmtNodes.inc as an independent oracle and check the
    # generated + hand-written hierarchy against it: every class's abstract type
    # subtypes its parent's abstract, and every concrete class has a carrier
    # subtyping its abstract. Same source gen/stmt_nodes.jl reads, parsed here
    # separately so a generator mistake can't validate itself.
    stmt_abstract_name(name) = startswith(String(name), "Abstract") ? Symbol(name) : Symbol("Abstract", name)
    stmt_carrier_name(name) = name === :Expr ? :Expr_ : Symbol(name)
    inc = joinpath(pkgdir(ClangCompiler), "deps", "ClangExtra", "include", "clang-ex", "AST", "StmtNodes.inc")
    abstract_re = r"^ABSTRACT_STMT\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    nconcrete = 0
    for line in eachline(inc)
        line = strip(line)
        ma = match(abstract_re, line)
        mc = ma === nothing ? match(concrete_re, line) : nothing
        if ma !== nothing
            name, parent, isabstract = Symbol(ma.captures[1]), Symbol(ma.captures[2]), true
        elseif mc !== nothing
            mc.captures[1] in ("STMT_RANGE", "LAST_STMT_RANGE", "ABSTRACT_STMT") && continue
            name, parent, isabstract = Symbol(mc.captures[2]), Symbol(mc.captures[3]), false
        else
            continue
        end
        A = getfield(ClangCompiler, stmt_abstract_name(name))
        P = parent === :Stmt ? ClangCompiler.AbstractStmt : getfield(ClangCompiler, stmt_abstract_name(parent))
        @test A <: P
        if !startswith(String(name), "Abstract")
            @test getfield(ClangCompiler, stmt_carrier_name(name)) <: A
        end
        isabstract || (nconcrete += 1)
    end
    # every concrete class has an enum value and a carrier in the resolve map
    @test length(STMT_CLASS_TO_TYPE) == nconcrete
end

@testset "Stmt traversal & classification" begin
    I = create_interpreter()
    compile(I,
            """
            int fact(int n) {
                if (n <= 1) { return 1; }
                int r = 1;
                while (n > 1) { r *= n; --n; }
                return r;
            }
            """)
    lookup = DeclFinder(I)
    @test lookup(I, "fact")
    fd = FunctionDecl(get_decl(lookup).ptr)

    body = getBody(fd)
    @test getStmtClassName(body) == "CompoundStmt"
    @test getStmtClass(body) == LibClangEx.CXStmtClass_CompoundStmtClass
    @test resolve(body) isa CompoundStmt

    kids = children(body)
    @test length(kids) == 4
    @test typeof.(kids) == [IfStmt, DeclStmt, WhileStmt, ReturnStmt]

    # IfStmt without else/init exposes exactly cond + then
    ifstmt = kids[1]
    @test length(children(ifstmt)) == 2

    # stamped predicates and casts, including an abstract-base cast
    cond = children(ifstmt)[1]
    @test cond isa BinaryOperator
    @test isExpr(cond)
    @test isValueStmt(cond)
    @test !isIfStmt(cond)
    e = Expr_(cond)
    @test e.ptr != C_NULL
    @test isIfStmt(kids[1]) && !isExpr(kids[1])

    # Expr base API
    ty = getType(e)
    # the default printing policy spells C++ bool as C's _Bool
    @test get_name(ty) in ("bool", "_Bool")
    @test getValueKind(e) == LibClangEx.CXExprValueKind_VK_PRValue
    stripped = IgnoreParenImpCasts(e)
    @test stripped.ptr != C_NULL

    # source locations round-trip
    @test getBeginLoc(body).ptr != C_NULL
    @test getEndLoc(body).ptr != C_NULL

    @test getNumChildren(kids[4]) == 1  # return r;

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
    @test ClangCompiler.isImplicit(first(DeclIterator(decl)))
    for field in DeclIterator(decl)
        ClangCompiler.isImplicit(field) && continue
        ClangCompiler.dump(field)
        @test getDeclKindName(field) == "Field"
    end
    @test count(==("Field"), kinds) == 2

    @test decl_lookup(I, "Foo")
    decl = get_decl(decl_lookup)
    for x in DeclIterator(decl)
        ClangCompiler.dump(x)
    end

    dispose(decl_lookup)
    dispose(I)
end

@testset "bulk subtree traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fn(int a){ int s=0; for(int i=0;i<a;i++){ s+=i*2; if(s>10) break; } return s; }")
    f = DeclFinder(I)
    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
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
    @test all(x -> x isa CC.AbstractStmt, bulk)
    @test !any(x -> isabstracttype(typeof(x)), bulk)        # every node fully resolved
    @test [s.ptr for s in bulk] == [s.ptr for s in rec]     # same nodes, same order

    dispose(f)
    dispose(I)
end
