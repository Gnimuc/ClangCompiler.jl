using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

const IACT = CC.LibClangEx

@testset "Index | occurrence collector" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             int iact_callee(int a) { return a + 1; }
             int iact_caller(int b) { return iact_callee(b) + iact_callee(b); }
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(ci)

    f = DeclFinder(I)
    @test f(I, "iact_callee")
    callee = CC.FunctionDecl(get_decl(f))
    @test f(I, "iact_caller")
    caller = CC.FunctionDecl(get_decl(f))

    c = CC.IndexDataCollector()
    @test CC.getNumOccurrences(c) == 0
    # An empty buffer has no index 0, and nothing may pretend otherwise.
    @test_throws AssertionError CC.isMacroOccurrence(c, 0)
    @test_throws AssertionError CC.getOccurrenceDecl(c, 0)
    @test_throws AssertionError CC.getOccurrenceRoles(c, 0)
    @test_throws AssertionError CC.getOccurrenceLocation(c, 0)
    @test_throws AssertionError CC.getOccurrenceMacroName(c, 0)

    # Walking nothing reports nothing -- stated outright, because every assertion below
    # lives inside a loop that an empty buffer would simply skip.
    CC.indexTopLevelDecls(ctx, pp, CC.FunctionDecl[], c)
    @test CC.getNumOccurrences(c) == 0

    CC.indexTopLevelDecls(ctx, pp, [callee], c)
    n_callee = CC.getNumOccurrences(c)
    @test n_callee > 0

    # The definition of iact_callee has to be among what the walk reported.
    def_role = UInt32(IACT.CXSymbolRole_Definition)
    defs = [i
            for i = 0:(n_callee - 1)
            if CC.getOccurrenceRoles(c, i) & def_role != 0 &&
                   CC.getOccurrenceDecl(c, i) !== nothing &&
                   CC.getOccurrenceDecl(c, i).ptr == callee.ptr]
    @test !isempty(defs)
    # A decl occurrence carries a decl and no macro name; the two payloads are disjoint.
    for i in defs
        @test CC.isMacroOccurrence(c, i) == false
        @test CC.getOccurrenceMacroName(c, i) == ""
        @test CC.isValid(CC.getOccurrenceLocation(c, i))
    end
    @test !isempty(CC.printSymbolRoles(CC.getOccurrenceRoles(c, first(defs))))

    # The collector accumulates: a second walk appends rather than replacing.
    CC.indexTopLevelDecls(ctx, pp, [caller], c)
    @test CC.getNumOccurrences(c) > n_callee

    # iact_caller's body calls iact_callee twice, so the second walk must have produced at
    # least two reference occurrences of the callee that the first walk did not.
    call_role = UInt32(IACT.CXSymbolRole_Call)
    calls = count(i -> CC.getOccurrenceRoles(c, i) & call_role != 0 &&
                       CC.getOccurrenceDecl(c, i) !== nothing &&
                       CC.getOccurrenceDecl(c, i).ptr == callee.ptr, n_callee:(CC.getNumOccurrences(c) - 1))
    @test calls == 2

    CC.clear(c)
    @test CC.getNumOccurrences(c) == 0

    # The ASTUnit driver reaches the same collector through the unit's top-level list.
    # ASTUnit::create adopts the invocation, so `inv` must never be disposed on its own;
    # the diagnostics engine is only borrowed.
    inv = CC.CompilerInvocation()
    au = CC.ASTUnit(inv, CC.getDiagnostics(ci))
    CC.setASTContext(au, ctx)
    CC.addTopLevelDecl(au, callee)
    @test CC.top_level_size(au) == 1

    CC.indexASTUnit(au, c)
    @test CC.getNumOccurrences(c) > 0
    @test any(i -> CC.getOccurrenceDecl(c, i) !== nothing && CC.getOccurrenceDecl(c, i).ptr == callee.ptr,
              0:(CC.getNumOccurrences(c) - 1))

    CC.dispose(au)
    CC.dispose(c)
    dispose(f)
    dispose(I)
end
