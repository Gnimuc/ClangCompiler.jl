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
using ClangCompiler: STMT_NODES, STMT_CLASS_TO_TYPE, stmt_carrier_name, stmt_abstract_name
using ClangCompiler.LibClangEx
using Test

@testset "Stmt hierarchy table" begin
    # every table entry produced a type with the table's parent as supertype
    for node in STMT_NODES
        A = getfield(ClangCompiler, stmt_abstract_name(node.name))
        P = node.parent === :Stmt ? ClangCompiler.AbstractStmt :
            getfield(ClangCompiler, stmt_abstract_name(node.parent))
        @test A <: P
        if !startswith(String(node.name), "Abstract")
            T = getfield(ClangCompiler, stmt_carrier_name(node.name))
            @test T <: A
        end
    end
    # every concrete class has an enum value and a carrier in the resolve map
    @test length(STMT_CLASS_TO_TYPE) == count(n -> !n.isabstract, STMT_NODES)
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

@testset "Stmt/Expr payload accessors" begin
    I = create_interpreter()
    compile(I,
            """
            struct Widget {
                int m(int v) { return v + 1; }
            };
            int machine(int n) {
                Widget w;
                int acc = 0;
                while (n > 0) { acc += w.m(n); --n; }
                if (acc > 10) { return acc; } else { return [](int v) { return v; }(acc); }
            }
            """)
    lookup = DeclFinder(I)
    @test lookup(I, "machine")
    fd = FunctionDecl(get_decl(lookup).ptr)
    body = getBody(fd)

    # collect every node in the function body, resolved to concrete types
    nodes = ClangCompiler.AbstractStmt[]
    stack = ClangCompiler.AbstractStmt[resolve(body)]
    while !isempty(stack)
        node = pop!(stack)
        push!(nodes, node)
        append!(stack, children(node))
    end
    byT = T -> filter(n -> n isa T, nodes)

    # WhileStmt: cond is a comparison BinaryOperator
    ws = only(byT(WhileStmt))
    cond = resolve(getCond(ws))
    @test cond isa BinaryOperator
    @test isComparisonOp(cond)
    @test getOpcodeStr(cond) == ">"
    @test getOpcode(cond) == LibClangEx.CXBinaryOperatorKind_BO_GT
    @test resolve(getLHS(cond)) isa ImplicitCastExpr

    # IfStmt with else: then/else are compound statements
    ifs = only(byT(IfStmt))
    @test resolve(getThen(ifs)) isa CompoundStmt
    @test resolve(getElse(ifs)) isa CompoundStmt

    # member call: w.m(n) — method decl and arg count
    mces = byT(CXXMemberCallExpr)
    @test !isempty(mces)
    mce = first(mces)
    @test getNumArgs(mce) == 1
    @test get_name(getMethodDecl(mce)) == "m"

    # lambda: call operator arity (its name `operator()` is not a simple
    # identifier, so getName would assert — use the parameter count)
    le = only(byT(LambdaExpr))
    callop = getCallOperator(le)
    @test ClangCompiler.getNumParams(FunctionDecl(callop.ptr)) == 1

    # DeclStmt: `Widget w;` and `int acc = 0;` are single decls
    dss = byT(DeclStmt)
    @test length(dss) >= 2
    @test all(isSingleDecl, dss)

    # ReturnStmt payload (two in machine(), one inside the lambda body)
    rs = byT(ReturnStmt)
    @test length(rs) == 3
    @test all(r -> getRetValue(r).ptr != C_NULL, rs)

    dispose(lookup)
    dispose(I)
end
