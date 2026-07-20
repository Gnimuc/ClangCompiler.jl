using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Acceptance corpus: small but real static-analysis tools built entirely on the
# wrapped Clang AST surface, each proving an end-to-end capability (parse -> find
# -> traverse -> resolve -> payload). Generated with subagents that verified each
# tool against the live package.

@testset "pointer-dereference finder (null-safety linter core)" begin
    # Walk a function body and collect every pointer-dereference site, classified by form:
    #   :deref     — UnaryOperator with opcode UO_Deref   (`*p`)
    #   :arrow     — MemberExpr with isArrow == true       (`p->x`)
    #   :subscript — ArraySubscriptExpr                    (`p[i]`)
    # Address-of (`&x`, UO_AddrOf) and dot-member access (`v.y`, isArrow == false)
    # are pointer *non*-dereferences and must NOT be collected.
    function find_deref_sites(fd)
        body = CC.resolve(CC.getBody(fd))
        sites = Tuple{Symbol,CC.SourceLocation}[]
        for n in CC.subtree(body)
            if n isa CC.UnaryOperator
                if CC.getOpcode(n) == CC.LibClangEx.CXUnaryOperatorKind_UO_Deref
                    push!(sites, (:deref, CC.getBeginLoc(n)))
                end
            elseif n isa CC.MemberExpr
                if CC.isArrow(n)
                    push!(sites, (:arrow, CC.getBeginLoc(n)))
                end
            elseif n isa CC.ArraySubscriptExpr
                push!(sites, (:subscript, CC.getBeginLoc(n)))
            end
        end
        return sites
    end

    src = """
    struct S { int x; int y; };
    int deref_demo(int *p, struct S *sp, struct S sv, int *arr, int i) {
        int a  = *p;          // UO_Deref            -> :deref     (1)
        int m1 = sp->x;       // MemberExpr isArrow  -> :arrow     (1)
        int m2 = sv.y;        // MemberExpr dot      -> NOT counted
        int e0 = arr[0];      // ArraySubscriptExpr  -> :subscript (1)
        int e1 = arr[i];      // ArraySubscriptExpr  -> :subscript (2)
        int *q = &a;          // UO_AddrOf           -> NOT counted
        return a + m1 + m2 + e0 + e1 + (q != 0);
    }
    """

    I = create_interpreter(String[])
    try
        CC.parse(I, src)
        f = DeclFinder(I)
        @test f(I, "deref_demo")
        fd = CC.FunctionDecl(get_decl(f).ptr)

        sites = find_deref_sites(fd)
        kinds = first.(sites)

        # Exact per-form counts.
        @test count(==(:deref), kinds) == 1
        @test count(==(:arrow), kinds) == 1
        @test count(==(:subscript), kinds) == 2
        @test length(sites) == 4

        # Only the three dereference forms ever appear — address-of and dot-access
        # (both present in the source) were correctly excluded.
        @test Set(kinds) == Set([:deref, :arrow, :subscript])

        # Every site carries a real source location.
        @test all(s -> s[2] isa CC.SourceLocation, sites)

        dispose(f)
    finally
        dispose(I)
    end
end

@testset "unused-local-variable linter" begin
    # Collect local VarDecls declared in a FunctionDecl body (via DeclStmt),
    # gather every VarDecl referenced by a DeclRefExpr in the body, and report
    # the declared-but-never-referenced locals by name.
    function find_unused_locals(fd::CC.FunctionDecl)
        body = CC.resolve(CC.getBody(fd))
        nodes = CC.subtree(body)

        declared = Tuple{Ptr{Cvoid},String}[]   # (decl-pointer, name) for each local VarDecl
        for n in nodes
            if n isa CC.DeclStmt
                for d in CC.getDecls(n)
                    vd = CC.resolve(d)
                    # plain local variables only — not typedefs, not ParmVarDecls
                    if vd isa CC.VarDecl
                        push!(declared, (vd.ptr, CC.getName(vd)))
                    end
                end
            end
        end

        referenced = Set{Ptr{Cvoid}}()
        for n in nodes
            if n isa CC.DeclRefExpr
                push!(referenced, CC.getDecl(n).ptr)
            end
        end

        return String[name for (ptr, name) in declared if !(ptr in referenced)]
    end

    src = """
    int compute(int a, int b) {
        int used = a + b;
        int unused = 42;
        return used;
    }
    """

    I = create_interpreter(String[])
    try
        CC.parse(I, src)
        f = DeclFinder(I)
        @test f(I, "compute")
        fd = CC.FunctionDecl(get_decl(f).ptr)

        unused = find_unused_locals(fd)

        @test unused == ["unused"]          # exactly the unused local, by name
        @test "used" ∉ unused                # the referenced local is not flagged
        @test "a" ∉ unused                   # used parameters are not flagged
        @test "b" ∉ unused
        @test length(unused) == 1

        dispose(f)
    finally
        dispose(I)
    end
end

@testset "Direct-call edge lister" begin
    # Walk a FunctionDecl body and return the sorted, de-duplicated names of the
    # functions it *directly* calls (CallExpr -> getDirectCallee, null callees skipped).
    direct_call_edges = function (fd::CC.FunctionDecl)
        body = CC.getBody(fd)
        body.ptr == C_NULL && return String[]
        names = Set{String}()
        for node in CC.subtree(CC.resolve(body))
            node isa CC.CallExpr || continue
            callee = CC.getDirectCallee(node)
            callee.ptr == C_NULL && continue   # skip indirect / null callees
            push!(names, CC.getName(callee))
        end
        return sort!(collect(names))
    end

    I = create_interpreter(String[])
    CC.parse(I,
        """
        void foo();
        void bar(int x);
        typedef void (*fp)();
        void caller(fp p) {
            foo();       // direct
            foo();       // repeated -> must dedup
            bar(3);      // direct, with an argument
            p();         // indirect call through function pointer -> null callee, skip
        }
        """)

    f = DeclFinder(I)
    @test f(I, "caller")
    fd = CC.FunctionDecl(get_decl(f).ptr)

    edges = direct_call_edges(fd)
    @test edges == ["bar", "foo"]          # sorted, unique
    @test length(edges) == 2               # dedup: two foo() calls collapse to one
    @test !("p" in edges)                  # indirect callee skipped

    dispose(f)
    dispose(I)
end

@testset "struct layout dumper" begin
    # Return [(fieldName, concreteTypeCarrier)] for a record decl by resolving
    # each field's QualType -> Type_ -> concrete Type carrier.
    function dump_layout(rd::CC.CXXRecordDecl)
        out = Tuple{String,Any}[]
        for field in CC.getFields(rd)
            name = CC.getName(field)
            qt = CC.getType(field)
            typtr = CC.getTypePtr(qt)
            carrier = CC.resolve(typtr)
            push!(out, (name, carrier))
        end
        return out
    end

    I = create_interpreter(String[])
    try
        CC.parse(I, "struct S { int x; double y; int *p; };")
        f = DeclFinder(I)
        try
            @test f(I, "S")
            rd = CC.CXXRecordDecl(get_decl(f).ptr)
            layout = dump_layout(rd)

            @test length(layout) == 3
            @test [name for (name, _) in layout] == ["x", "y", "p"]

            carriers = [c for (_, c) in layout]
            @test carriers[1] isa CC.BuiltinType   # int
            @test carriers[2] isa CC.BuiltinType   # double
            @test carriers[3] isa CC.PointerType   # int*
        finally
            dispose(f)
        end
    finally
        dispose(I)
    end
end
