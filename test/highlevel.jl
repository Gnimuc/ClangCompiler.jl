using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using ClangCompiler: translation_unit, top_level_decls, find_decl, find_decls, source_location
using Test

# The interpreter-level conveniences. Each is a composition of public pieces, so what is worth
# asserting is not that they return something -- it is the two properties a caller relies on and
# a refactor could silently drop: that every result is *resolved* to the class clang reported,
# and that `top_level_decls` means direct children rather than the flattened walk.

const HL_SRC = """
namespace app {
    struct Point {
        int x;
        int y;
        int sum() const { return x + y; }
    };
    int twice(int v) { return 2 * v; }
    double twice(double v) { return 2 * v; }
    int counter;
}
"""

@testset "high-level interpreter helpers" begin
    I = create_interpreter(String[])
    CC.parse(I, HL_SRC)

    @testset "find_decl resolves to the class clang reported" begin
        # The DeclFinder hands back a `NamedDecl`; the concrete type below is clang's answer to
        # "what kind of declaration is this", not something the wrapper's return expression
        # fixed. That is what makes these assertions about clang rather than about our source.
        @test find_decl(I, "app::Point") isa CC.CXXRecordDecl
        @test find_decl(I, "app::counter") isa CC.VarDecl
        @test find_decl(I, "app") isa CC.NamespaceDecl

        # `get_decl` resolves too, so driving the finder by hand is no longer the trap it
        # was: both spellings answer with the class clang reported. What the abstract adds is
        # the portable test -- carriers are leaves, so `isa CXXRecordDecl` is exact where
        # `isa AbstractRecordDecl` is C++'s `isa<RecordDecl>` and keeps working for a subclass.
        finder = DeclFinder(I)
        @test finder(I, "app::Point")
        @test get_decl(finder) isa CC.CXXRecordDecl
        @test get_decl(finder) isa CC.AbstractRecordDecl
        dispose(finder)

        # same node reached both ways: the helper is a shortcut, not a different question
        long_way = DeclFinder(I)
        @test long_way(I, "app::Point")
        @test CC.decl_id(find_decl(I, "app::Point")) == CC.decl_id(get_decl(long_way))
        dispose(long_way)
    end

    @testset "a name that is not there is `nothing`, not an error" begin
        @test find_decl(I, "app::nope") === nothing
        @test isempty(find_decls(I, "app::nope"))
        # and the finder it allocated was still disposed -- repeating the miss many times must
        # not exhaust anything, which is the observable form of "the `finally` really runs"
        for _ = 1:50
            @test find_decl(I, "app::nope") === nothing
        end
    end

    @testset "find_decls returns the whole overload set" begin
        overloads = find_decls(I, "app::twice")
        @test length(overloads) == 2
        @test all(d -> d isa CC.FunctionDecl, overloads)
        # two declarations, not one node reported twice
        @test length(unique(CC.decl_id.(overloads))) == 2
        # what makes these an overload set rather than a redeclaration is that clang gave
        # their parameters distinct type nodes
        ptypes = [CC.getTypePtr(CC.getType(CC.getParamDecl(d, 0))) for d in overloads]
        @test CC.type_id(ptypes[1]) != CC.type_id(ptypes[2])
        @test all(t -> CC.resolve(t) isa CC.BuiltinType, ptypes)
    end

    @testset "top_level_decls is direct children, not the flattened walk" begin
        top = top_level_decls(I)
        names = [CC.getName(d) for d in top]
        @test "app" in names
        # `Point`, `twice` and `counter` live *inside* the namespace. `decls` would flatten them
        # to the same level; `decls_in` -- which is what this helper uses -- must not.
        @test !("Point" in names)
        @test !("counter" in names)

        # No cast: these take `AnyDeclContext`, so a decl that IS a context goes straight in
        # and marshalling crosses through `Decl::castToDeclContext`. Asserting the two
        # spellings agree is what says the pivot still happened rather than a raw pointer
        # being reused -- the crossing that `src/clang/CLAUDE.md` says corrupts.
        flat = [CC.getName(d) for d in CC.decls(translation_unit(I))]
        @test "Point" in flat          # the flattened walk really does reach it
        @test length(flat) > length(top)
        @test flat == [CC.getName(d) for d in CC.decls(CC.castToDeclContext(translation_unit(I)))]

        # descending one level gets there, and the resolved types survive the descent
        ns = only(d for d in top if d isa CC.NamespaceDecl)
        inner = collect(CC.decls_in(ns))
        @test length(inner) == length(collect(CC.decls_in(CC.castToDeclContext(ns))))
        @test length(collect(CC.parents(ns))) == length(collect(CC.parents(CC.castToDeclContext(ns))))
        @test length(collect(CC.lexical_parents(ns))) == length(collect(CC.lexical_parents(CC.castToDeclContext(ns))))
        @test any(d -> d isa CC.CXXRecordDecl && CC.getName(d) == "Point", inner)
        @test any(d -> d isa CC.FunctionDecl && CC.getName(d) == "twice", inner)
    end

    @testset "translation_unit is the most recent increment, not the union of them" begin
        # The docstring used to claim this held everything parsed into `x`. Clang's incremental
        # interpreter starts a fresh TranslationUnitDecl per increment and `getTranslationUnitDecl`
        # answers with the most recent, so a second parse does not extend the first's unit. The
        # suite could not see it because every other testset here parses exactly once.
        J = create_interpreter(String[])
        CC.parse(J, "int hl_first;")
        CC.parse(J, "int hl_second;")
        seen = [CC.decl_name(d) for d in CC.decls_in(translation_unit(J)) if d isa CC.AbstractNamedDecl]
        @test "hl_second" in seen
        @test !("hl_first" in seen)          # the truncation, asserted rather than documented
        # both are still *findable*: it is the container that is per-increment, not the AST
        @test find_decl(J, "hl_first") isa CC.AbstractVarDecl
        @test find_decl(J, "hl_second") isa CC.AbstractVarDecl
        dispose(J)
    end

    @testset "translation_unit is what the top-level decls hang off" begin
        tu = translation_unit(I)
        ns = only(d for d in top_level_decls(I) if d isa CC.NamespaceDecl)
        # the relationship, not the Julia type: clang says the namespace's semantic parent is
        # this translation unit
        @test CC.decl_id(CC.castFromDeclContext(CC.getDeclContext(ns))) == CC.decl_id(tu)
    end

    @testset "the public abstracts are what a portable caller dispatches on" begin
        # Carriers are leaves, so `isa` against a concrete carrier is not C++'s `isa<T>`: a
        # constructor is not a `CXXMethodDecl` even though clang's CXXConstructorDecl derives
        # from CXXMethodDecl. The abstract is the correct spelling, and these six are public
        # precisely so a caller can write it.
        rec = find_decl(I, "app::Point")
        @test rec isa CC.AbstractRecordDecl && rec isa CC.AbstractTagDecl
        @test rec isa CC.AbstractNamedDecl && rec isa CC.AbstractDecl
        # `app::twice` is overloaded, so it is `find_decls`' job; a member function is the
        # single-result case, and is also a CXXMethodDecl -- which is exactly why the abstract
        # matters, since `isa CC.FunctionDecl` on it is false.
        fn = only(m for m in CC.members(CC.definition(rec)) if CC.decl_name(m) == "sum")
        @test fn isa CC.AbstractFunctionDecl
        @test !(fn isa CC.FunctionDecl)
        @test all(d -> d isa CC.AbstractFunctionDecl, find_decls(I, "app::twice"))
        @test find_decl(I, "app::counter") isa CC.AbstractVarDecl

        # the name accessors, which are the reason the AST half is usable from public names
        @test CC.decl_name(rec) == "Point"
        @test CC.qualified_name(rec) == "app::Point"
        # and the round trip the docstring promises
        @test CC.decl_id(find_decl(I, CC.qualified_name(rec))) == CC.decl_id(rec)
    end

    @testset "source_location reports where the text was written" begin
        # HL_SRC is a known string, so these are real values and not shape assertions: the
        # namespace opens on line 1 and `struct Point` is on line 2 of the buffer.
        ns = find_decl(I, "app")
        rec = find_decl(I, "app::Point")
        @test source_location(I, ns).line == 1
        @test source_location(I, rec).line == 2
        @test source_location(I, rec).column > source_location(I, ns).column   # it is indented
        # parsed code has no file behind it, so clang names the in-memory buffer
        @test startswith(source_location(I, ns).file, "input_line")

        # a statement locates too, and the body of `sum` sits after the struct opens
        m = only(d for d in CC.decls_in(CC.castToDeclContext(rec)) if d isa CC.CXXMethodDecl && CC.getName(d) == "sum")
        body = CC.resolve(CC.getBody(m))
        @test source_location(I, body).line == 5
    end

    dispose(I)
end

@testset "definition, members, signature, mangled_name" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             struct Fwd;
             namespace hl {
             struct Widget {
                 int w;
                 double area() const;
                 static int count();
                 virtual ~Widget();
                 Widget();
             };
             int twice(int v, double s);
             }
             struct Fwd { int f; };
             """)

    @testset "definition completes a forward declaration" begin
        # Which redeclaration a lookup lands on depends on the translation unit, so take the
        # forward one outright rather than assuming: it is the definition's previous decl.
        found = CC.find_decl(I, "Fwd")
        d = CC.definition(found)
        @test d !== nothing
        @test CC.isCompleteDefinition(d)
        @test CC.definition(d) == d                     # already the definition

        fwd = CC.resolve(CC.getPreviousDecl(d))
        @test fwd isa CC.CXXRecordDecl
        @test !CC.isCompleteDefinition(fwd)             # the one with no members
        # two redeclarations of one type are two nodes, so `==` (which is node identity) is
        # false between them -- what ties them together is that both reach one definition
        @test fwd != d
        @test CC.definition(fwd) == d

        # a type only ever declared has no definition to reach
        CC.parse(I, "struct NeverDefined;")
        @test CC.definition(CC.find_decl(I, "NeverDefined")) === nothing
    end

    @testset "members goes through the definition, whichever decl it is handed" begin
        # This is a dispatch question and it got the wrong answer once: a record is both an
        # AbstractTagDecl and one of the decls that is also a DeclContext, so a second method on
        # the union won by specificity and walked the forward declaration.
        fwd = CC.resolve(CC.getPreviousDecl(CC.definition(CC.find_decl(I, "Fwd"))))
        @test !CC.isCompleteDefinition(fwd)
        ms = CC.members(fwd)                            # NOT empty — the definition's members
        @test "f" in Set(CC.getNameAsString(m) for m in ms if m isa CC.AbstractNamedDecl)
        # and `members` reports what clang has, implicit declarations included: every class
        # gets an injected-class-name, so a one-field struct has two members
        @test any(m -> m isa CC.CXXRecordDecl && CC.isImplicit(m), ms)

        w = CC.find_decl(I, "hl::Widget")
        names = Set(CC.getNameAsString(m) for m in CC.members(w))
        @test "area" in names && "count" in names && "w" in names
        # direct members only, and each resolved to its concrete class
        @test any(m -> m isa CC.CXXMethodDecl, CC.members(w))
        @test any(m -> m isa CC.FieldDecl, CC.members(w))

        # a namespace is a context too, and reaches the same function
        ns = CC.find_decl(I, "hl")
        @test "twice" in Set(CC.getNameAsString(m) for m in CC.members(ns) if m isa CC.AbstractNamedDecl)
    end

    @testset "signature reports what clang parsed" begin
        fd = CC.find_decl(I, "hl::twice")
        s = CC.signature(fd)
        @test s.name == "twice"
        @test s.return_type == "int"
        @test s.parameters == ["int", "double"]
        @test !s.is_const && !s.is_static && !s.is_virtual && !s.is_deleted && !s.is_variadic

        w = CC.find_decl(I, "hl::Widget")
        area = only(m for m in CC.members(w) if m isa CC.CXXMethodDecl && CC.getNameAsString(m) == "area")
        @test CC.signature(area).is_const
        cnt = only(m for m in CC.members(w) if m isa CC.CXXMethodDecl && CC.getNameAsString(m) == "count")
        @test CC.signature(cnt).is_static
        @test CC.signature(cnt).return_type == "int"
    end

    @testset "mangled_name, and the two declarations it refuses" begin
        fd = CC.find_decl(I, "hl::twice")
        sym = CC.mangled_name(I, fd)
        # Itanium encodes the namespace, the name and the parameter types
        @test occursin("twice", sym) && occursin("hl", sym)
        @test sym == CC.mangleName(CC.createMangleContext(ctx, CC.getTargetInfo(ctx)), fd)

        # a constructor and a destructor have several symbols each, so clang's entry point
        # wants to be told which — a bare decl trips an assert compiled into the release build
        w = CC.find_decl(I, "hl::Widget")
        ctor = only(m for m in CC.members(w) if m isa CC.CXXConstructorDecl)
        dtor = only(m for m in CC.members(w) if m isa CC.CXXDestructorDecl)
        @test_throws AssertionError CC.mangled_name(I, ctor)
        @test_throws AssertionError CC.mangled_name(I, dtor)

        # A class, enum, typedef or namespace has no mangled name, and reaching clang with one
        # is not a refusal but a SIGSEGV -- `llvm_unreachable` compiled to
        # `__builtin_unreachable()`. Dispatch is what keeps them out, so these are MethodErrors
        # rather than assertions, and the partition below says the narrowing did not simply
        # refuse everything.
        CC.parse(I, "enum HLE { HLEC }; typedef int HLTd; namespace hlns {}")
        for bad in (w, CC.find_decl(I, "HLE"), CC.find_decl(I, "HLTd"), CC.find_decl(I, "hlns"))
            @test_throws MethodError CC.mangled_name(I, bad)
        end
        # ... while a field, which is neither a function nor a variable, still mangles
        fld = only(m for m in CC.members(w) if m isa CC.FieldDecl)
        @test !isempty(CC.mangled_name(I, fld))

        # getAllManglings is the one that answers for those, and it needs a generator that
        # nothing could construct until now
        ng = CC.ASTNameGenerator(ctx)
        @test length(CC.getAllManglings(ng, ctor)) >= 2      # base-object and complete-object
        @test all(s -> occursin("Widget", s), CC.getAllManglings(ng, ctor))
        @test length(CC.getAllManglings(ng, dtor)) >= 2
        CC.dispose(ng)
    end

    dispose(I)
end
