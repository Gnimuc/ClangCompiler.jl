using ClangCompiler
using ClangCompiler: create_interpreter, dispose, compile, DeclFinder, get_decl
using ClangCompiler: FunctionDecl, getBody, resolve, children, getChildren
using ClangCompiler: getStmtClass, getStmtClassName, getNumChildren
using ClangCompiler: getBeginLoc, getEndLoc, isExpr, isIfStmt, isValueStmt
using ClangCompiler: IfStmt, WhileStmt, ReturnStmt, CompoundStmt, DeclStmt, BinaryOperator
using ClangCompiler: Expr_, getType, getValueKind, IgnoreParenImpCasts, get_name
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
