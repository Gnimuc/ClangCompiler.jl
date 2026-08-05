using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

import ClangCompiler as CC
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

@testset "member iteration" begin
    I = create_interpreter([joinpath(pkgdir(ClangCompiler), "test", "cxx", "main.cpp")])
    f = DeclFinder(I)

    @test f(I, "Node")
    node = ClangCompiler.CXXRecordDecl(get_decl(f))
    @test ClangCompiler.getNumFields(node) == 2
    @test [ClangCompiler.getName(x) for x in ClangCompiler.getFields(node)] == ["x", "y"]

    ClangCompiler.parse(I, "struct BaseA { int a; }; struct BaseB { int b; }; struct Der : BaseA, BaseB { int c; };")
    @test f(I, "Der")
    der = ClangCompiler.CXXRecordDecl(get_decl(f))
    @test ClangCompiler.getNumFields(der) == 1
    @test ClangCompiler.getNumBases(der) == 2
    @test ClangCompiler.getNumVBases(der) == 0
    bases = ClangCompiler.getBases(der)
    basenames = [ClangCompiler.getName(ClangCompiler.getAsCXXRecordDecl(ClangCompiler.getTypePtr(ClangCompiler.getType(b))))
                 for b in bases]
    @test basenames == ["BaseA", "BaseB"]

    @test f(I, "Foo")
    foo = ClangCompiler.CXXRecordDecl(get_decl(f))
    @test ClangCompiler.getNumCtors(foo) == 2                     # Foo() and Foo(int)
    @test length(ClangCompiler.getMethods(foo)) == ClangCompiler.getNumMethods(foo)
    @test all(c -> c isa ClangCompiler.CXXConstructorDecl, ClangCompiler.getCtors(foo))

    dispose(f)
    dispose(I)
end

@testset "Decl predicate exercise" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, """
    int gv = 5; static int sv; constexpr int cev = 7;
    int variadic_fn(int, ...); inline int inl_fn(){ return 1; }
    struct Abstract { virtual void pure() = 0; };
    struct Base { virtual void v(); virtual ~Base(); int m; };
    struct Der : Base { void v() override; };
    """)
    f = DeclFinder(I)
    # the lookup hands back a NamedDecl; each probe names the class it expects
    D(name, T) = (f(I, name); T(get_decl(f)))

    gv = D("gv", ClangCompiler.VarDecl)
    @test ClangCompiler.hasGlobalStorage(gv)
    @test ClangCompiler.hasInit(gv)
    @test !ClangCompiler.isStaticLocal(D("sv", ClangCompiler.VarDecl))
    @test ClangCompiler.hasGlobalStorage(D("sv", ClangCompiler.VarDecl))
    @test ClangCompiler.hasInit(D("cev", ClangCompiler.VarDecl))

    vfn = D("variadic_fn", ClangCompiler.FunctionDecl)
    @test ClangCompiler.isVariadic(vfn)
    @test ClangCompiler.getNumParams(vfn) == 1
    @test ClangCompiler.isInlined(D("inl_fn", ClangCompiler.FunctionDecl))

    @test ClangCompiler.isAbstract(D("Abstract", ClangCompiler.CXXRecordDecl))
    base = D("Base", ClangCompiler.CXXRecordDecl)
    @test ClangCompiler.isPolymorphic(base)
    @test ClangCompiler.hasUserDeclaredDestructor(base)
    @test !ClangCompiler.isAbstract(base)
    der = D("Der", ClangCompiler.CXXRecordDecl)
    @test ClangCompiler.isPolymorphic(der)
    @test ClangCompiler.getNumBases(der) == 1

    dispose(f)
    dispose(I)
end

@testset "whole-TU decls traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "namespace N { struct S { int x; void m(); }; int g; }")
    f = DeclFinder(I)
    @test f(I, "N")
    nsdc = CC.castToDeclContext(get_decl(f))    # NamespaceDecl -> DeclContext pivot
    ds = CC.decls(nsdc)
    @test all(d -> d isa CC.AbstractDecl, ds)
    @test !any(d -> isabstracttype(typeof(d)), ds)          # every node resolved
    names = [CC.getDeclKindName(d) for d in ds]
    # recurses into the nested record: S, then S's members (x, m), plus g.
    @test "CXXRecord" in names
    @test "Field" in names
    @test "CXXMethod" in names
    @test "Var" in names
    @test any(d -> d isa CC.CXXRecordDecl, ds)
    @test any(d -> d isa CC.FieldDecl && CC.getName(d) == "x", ds)
    dispose(f)
    dispose(I)
end

@testset "Decl classification (getKind / resolve)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int gv = 3; int fn(int a){return a;} struct S { int m; }; namespace N {}")
    f = DeclFinder(I)
    cases = [("gv", CC.VarDecl, CC.LibClangEx.CXDeclKind_Var, "Var"),
             ("fn", CC.FunctionDecl, CC.LibClangEx.CXDeclKind_Function, "Function"),
             ("S", CC.CXXRecordDecl, CC.LibClangEx.CXDeclKind_CXXRecord, "CXXRecord"),
             ("N", CC.NamespaceDecl, CC.LibClangEx.CXDeclKind_Namespace, "Namespace")]
    for (name, carrier, kind, kindname) in cases
        @test f(I, name)
        d = get_decl(f)                       # base Decl carrier
        @test CC.getKind(d) == kind
        @test CC.getDeclKindName(d) == kindname
        r = CC.resolve(d)                     # O(1) narrowing via getKind
        @test r isa carrier
        @test r.ptr == d.ptr                  # Decl is the primary base: identity
    end
    dispose(f)
    dispose(I)
end

@testset "linked-chain iterators" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             namespace chainNS { struct ChainRec; struct ChainRec { int f; }; }
             int chainFn(int n);
             int chainFn(int n) { return n + 1; }
             """)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.getTranslationUnitDecl(ctx)
    tu_dc = CC.castToDeclContext(tu)
    name(d) = CC.getDeclKindName(d)

    # --- DeclIterator must yield the declaration decls_begin names ---
    # Walking the chain by hand is the reference: the iterator that advanced before
    # yielding silently dropped this first element from every context.
    first_decl = CC.decl_iterator_begin(tu_dc)
    @test !CC.is_null_handle(first_decl)

    by_hand = CC.AbstractDecl[]
    s = first_decl
    while !CC.is_null_handle(s)
        push!(by_hand, s)
        s = CC.getNextDeclInContext(s)
    end
    @test length(by_hand) >= 2

    via_iter = collect(DeclIterator(tu))
    @test length(via_iter) == length(by_hand)
    @test first(via_iter).ptr == first_decl.ptr
    @test [d.ptr for d in via_iter] == [d.ptr for d in by_hand]

    # decls_in is the same walk expressed as a ChainIterator
    @test [d.ptr for d in CC.decls_in(tu_dc)] == [d.ptr for d in by_hand]

    # every top-level declaration the bulk extractor sees is in the chain; `decls`
    # recurses into nested contexts, so it is a superset rather than an equal
    # `decls` resolves each node to its own class while the iterator hands back base carriers;
    # carrier equality is the `Decl *` clang compares, so the two sides meet without unwrapping
    bulk = Set(CC.decls(tu_dc))
    @test all(in(bulk), via_iter)

    # --- collect/comprehension work, which needs IteratorSize ---
    @test eltype(DeclIterator(tu)) == CC.AbstractDecl
    @test Base.IteratorSize(DeclIterator(tu)) == Base.SizeUnknown()
    @test length([name(d) for d in DeclIterator(tu)]) == length(by_hand)

    # --- redecls walks the redeclaration chain most-recent-first ---
    f = DeclFinder(I)
    @assert f(I, "chainFn") "lookup failed: chainFn"
    fd = CC.FunctionDecl(get_decl(f))
    chain = collect(CC.redecls(fd))
    @test length(chain) >= 2                       # a declaration and a definition
    @test first(chain).ptr == CC.getMostRecentDecl(fd).ptr
    @test CC.is_null_handle(CC.getPreviousDecl(last(chain)))   # ends at the first decl
    @test allunique(d.ptr for d in chain)

    # --- parents climbs out of a nested context to the translation unit ---
    # Elements are resolved to their concrete carriers, so an `isa` test against a
    # concrete class means something. Yielding base Decl carriers instead made every such
    # test silently vacuous, which is the failure this asserts against.
    @test any(d -> d isa CC.NamespaceDecl, via_iter)
    @test any(d -> d isa CC.FunctionDecl, via_iter)
    @test !all(d -> typeof(d) === CC.Decl, via_iter)
    ns = nothing
    for d in DeclIterator(tu)
        d isa CC.NamespaceDecl && (ns = d; break)
    end
    @test ns !== nothing
    if ns !== nothing
        up = collect(CC.parents(CC.castToDeclContext(ns)))
        @test !isempty(up)
        @test last(up).ptr == tu_dc.ptr            # the walk terminates at the TU
        @test allunique(dc.ptr for dc in up)
        # the translation unit has no parent, so the chain from it is empty
        @test isempty(collect(CC.parents(tu_dc)))
        @test isempty(collect(CC.lexical_parents(tu_dc)))
    end

    dispose(I)
end

@testset "chain iterators over scopes, macros and qualifiers" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             #define CHAIN_M 1
             #undef CHAIN_M
             #define CHAIN_M 2
             namespace chainQ { struct R { static int m; }; }
             int chainQ::R::m = 0;
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    pp = CC.getPreprocessor(CC.get_instance(I))

    # --- enclosing walks a hand-built scope chain outward and terminates ---
    diag = CC.getDiagnostics(sema)
    outer = CC.Scope(nothing, UInt32(CC.CXScopeFlags_DeclScope), diag)
    inner = CC.Scope(outer, UInt32(CC.CXScopeFlags_DeclScope), diag)
    chain = collect(CC.enclosing(inner))
    @test length(chain) == 2
    @test chain[1].ptr == inner.ptr
    @test chain[2].ptr == outer.ptr
    @test isempty(collect(CC.enclosing(CC.Scope(CC.CXScope(C_NULL)))))
    dispose(inner)
    dispose(outer)

    # --- macro_history walks the #define/#undef chain, most recent first ---
    ii = CC.getIdentifierInfo(pp, "CHAIN_M")
    md = CC.getLocalMacroDirective(pp, ii)
    if !CC.is_null_handle(md)
        hist = collect(CC.macro_history(md))
        @test length(hist) >= 2          # the redefinition, then the #undef, then the first
        @test hist[1].ptr == md.ptr
        @test allunique(d.ptr for d in hist)
        @test CC.is_null_handle(CC.getPrevious(last(hist)))
    end

    # --- qualifiers walks a nested-name-specifier outward ---
    # The out-of-line definition `int chainQ::R::m` is a top-level Var whose declarator
    # carries the qualifier. Its kind establishes the class, so the carrier is sound.
    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    vd = nothing
    for d in CC.decls_in(tu_dc)
        CC.getDeclKindName(d) == "Var" && (vd = CC.VarDecl(d); break)
    end
    @test vd !== nothing
    if vd !== nothing
        nns = CC.getQualifier(vd)
        if !CC.is_null_handle(nns)
            quals = collect(CC.qualifiers(nns))
            @test !isempty(quals)
            @test quals[1].ptr == nns.ptr
            @test allunique(q.ptr for q in quals)
            @test CC.is_null_handle(CC.getPrefix(last(quals)))
        end
    end

    dispose(I)
end

@testset "a decl marshals to its DeclContext base through the pivot" begin
    # `DeclContext` is the one base in this package that does not sit at offset zero, so its
    # entry in the marshalling table calls `Decl::castToDeclContext` rather than
    # reinterpreting. What is asserted is that the adjustment happens *at the boundary*: the
    # pointer a `CXDeclContext` parameter receives is the pivot's, not the decl's own, and the
    # gap between them is the base-subobject offset for that class.
    #
    # The offsets themselves are not pinned -- they are whatever the host ABI lays out, and
    # they differ per class because the base preceding `DeclContext` differs (`NamedDecl` in a
    # NamespaceDecl, `TypeDecl` in a TagDecl). What is pinned is that they are non-zero and
    # agree with the pivot, which is what reusing the raw pointer would violate.
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace pivot_ns { int inside; }
    struct PivotRec { int f; };
    """)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.getTranslationUnitDecl(ctx)

    duals = Any[tu]
    for d in CC.decls(CC.castToDeclContext(tu))
        d isa CC.AbstractDeclContextDecl && push!(duals, d)
    end
    @test length(duals) >= 3          # the TU plus the namespace and the record

    shifted = 0
    for d in duals
        asdecl = Base.unsafe_convert(CC.LibClangEx.CXDecl, d)
        asctx = Base.unsafe_convert(CC.LibClangEx.CXDeclContext, d)
        @test asctx === Base.unsafe_convert(CC.LibClangEx.CXDeclContext, CC.castToDeclContext(d))
        # and crossing back lands on the declaration it started from
        @test Base.unsafe_convert(CC.LibClangEx.CXDecl, CC.castFromDeclContext(CC.DeclContext(asctx))) ===
              asdecl
        UInt(asctx) == UInt(asdecl) || (shifted += 1)
    end
    # every class here puts `DeclContext` after some other base, so none of them coincide --
    # if they did, passing the raw pointer would work and this whole pivot would be dead code
    @test shifted == length(duals)

    # A decl that is not a context has no route at all: the union admits exactly the classes
    # clang marks DECL_CONTEXT, so the misuse is a dispatch failure and never reaches clang.
    vd = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        d isa CC.VarDecl && (vd = d)
    end
    @test vd !== nothing
    if vd !== nothing
        @test !(vd isa CC.AbstractDeclContextDecl)
        @test !applicable(Base.unsafe_convert, CC.LibClangEx.CXDeclContext, vd)
    end

    dispose(I)
end

@testset "a DeclContext parameter accepts the decl itself" begin
    # The C++ spelling is `EmptyDecl::Create(Ctx, TU, Loc)` -- a `TranslationUnitDecl *`
    # converts to `DeclContext *` with no cast written. Here the same call marshals through
    # the pivot, so the context clang records is the adjusted pointer rather than the decl's.
    I = create_interpreter(String[])
    CC.parse(I, "int any_dc_probe = 0;")
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.getTranslationUnitDecl(ctx)
    loc = CC.getLocation(tu)

    ed = CC.EmptyDecl(ctx, tu, loc)
    @test !CC.is_null_handle(ed)
    @test Base.unsafe_convert(CC.LibClangEx.CXDeclContext, CC.getDeclContext(ed)) ===
          Base.unsafe_convert(CC.LibClangEx.CXDeclContext, CC.castToDeclContext(tu))
    # the decl's own pointer is a different address, so the builder cannot have passed it
    @test Base.unsafe_convert(CC.LibClangEx.CXDeclContext, CC.getDeclContext(ed)) !==
          CC.LibClangEx.CXDeclContext(Base.unsafe_convert(CC.LibClangEx.CXDecl, tu))

    dispose(I)
end

@testset "a decl reaches the DeclContext API with no forwarding" begin
    # The 65 forwarding methods are gone: a `DeclContext` parameter is typed `AnyDeclContext`,
    # so dispatch admits the decl itself and the pivot runs inside the marshalling. What is
    # asserted here is that the union admits exactly clang's DECL_CONTEXT classes -- the same
    # property the forwarding file had -- and that the answers are the context's, not bits
    # read out of Decl storage, which is what reusing the raw pointer would produce.
    I = create_interpreter(String[])
    CC.parse(I, """
    namespace fwd_ns { int inside; }
    struct FwdRec { int f; };
    int fwd_var;
    """)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.getTranslationUnitDecl(ctx)
    ds = collect(CC.decls(CC.castToDeclContext(tu)))
    ns = first(d for d in ds if d isa CC.NamespaceDecl)
    rec = first(d for d in ds if d isa CC.CXXRecordDecl)
    vd = first(d for d in ds if d isa CC.VarDecl)

    # each classifier agrees with the class the decl actually is, so the DeclContext being
    # read is the one belonging to this decl
    @test CC.isNamespace(ns)
    @test !CC.isRecord(ns)
    @test CC.isRecord(rec)
    @test !CC.isNamespace(rec)
    @test CC.isTranslationUnit(tu)
    @test !CC.isTranslationUnit(ns)

    # `Encloses` and `Equals` are DeclContext methods clang spells with a capital, which the
    # forwarding generator's "uppercase means a cast" rule skipped -- so these two were
    # unreachable from a decl until the receivers widened.
    @test CC.Encloses(tu, ns)
    @test !CC.Encloses(ns, tu)
    @test CC.Equals(ns, ns)
    @test !CC.Equals(ns, CC.castToDeclContext(tu))

    # mixing the two spellings is the same call: a decl and its own pivot are one context
    @test CC.Equals(ns, CC.castToDeclContext(ns))

    # a decl clang does not mark DECL_CONTEXT has no method at all, so the misuse cannot
    # reach `castToDeclContext`'s assert
    @test !(vd isa CC.AbstractDeclContextDecl)
    @test_throws MethodError CC.isNamespace(vd)

    # `getDeclKindName` stays typed at `DeclContext` alone: clang declares it on both bases,
    # so widening it would make the call ambiguous for every dual-role decl -- as it is in
    # C++. A decl therefore still reaches the `Decl` method.
    @test CC.getDeclKindName(ns) == "Namespace"
    @test CC.getDeclKindName(CC.castToDeclContext(ns)) == "Namespace"

    dispose(I)
end
