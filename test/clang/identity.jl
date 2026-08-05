using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

# Carrier equality is node identity: the base pointer clang itself compares. What makes this
# worth its own file is that the interesting case is a *cross-class* comparison, and that the
# failure mode it replaced was silent -- `==` on two raw handles compares addresses whatever
# their types, but `isequal` and `hash` do not, so a `Set` keyed on `.ptr` reported no overlap
# instead of refusing to compare. Every assertion below therefore reaches one node by two
# different classes and checks that all three of `==`, `hash` and `Set` agree.

const ID_SRC = """
struct IdRec { int f; double g; };
IdRec id_obj;
typedef int IdAlias;
IdAlias id_alias;
int id_fn(int a) { return a + 1; }
"""

@testset "carrier equality is node identity" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, ID_SRC)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.getTranslationUnitDecl(ctx)
    ds = collect(CC.decls(CC.castToDeclContext(tu)))
    # not merely the first function-like decl: the implicit constructors clang synthesises
    # for IdRec are `AbstractFunctionDecl`s too, and they have no body
    rec = first(d for d in ds if d isa CC.CXXRecordDecl && !isempty(collect(CC.getFields(d))))
    var = first(d for d in ds if d isa CC.VarDecl)
    fn = first(d for d in ds if d isa CC.FunctionDecl && !CC.is_null_handle(CC.getBody(d)))

    @testset "one declaration reached as two classes" begin
        # `CXXRecordDecl` and `NamedDecl` are different Julia types over the same `Decl *`
        named = CC.NamedDecl(Base.unsafe_convert(CC.LibClangEx.CXNamedDecl, rec))
        @test typeof(named) !== typeof(rec)
        @test named == rec
        @test hash(named) == hash(rec)
        @test named in Set([rec])
        @test length(Set([rec, named])) == 1
        @test length(Dict(rec => 1, named => 2)) == 1     # the second overwrites the first
        # and a different declaration is still different
        @test rec != var
        @test length(Set([rec, var])) == 2
    end

    @testset "statements compare as nodes across their classes" begin
        kids = collect(CC.children(CC.resolve(CC.getBody(fn))))
        @test !isempty(kids)
        # `children` resolves; the same node reached as the base `Stmt` must still match
        for k in kids
            base = CC.Stmt(Base.unsafe_convert(CC.LibClangEx.CXStmt, k))
            @test base == k
            @test hash(base) == hash(k)
            @test base in Set(kids)
        end
        # a walk's nodes are distinct from each other
        @test length(Set(kids)) == length(kids)
    end

    @testset "types compare as nodes, not as equivalent types" begin
        qt = CC.getType(var)
        t = CC.getTypePtr(qt)
        @test CC.resolve(t) == t          # the resolved subclass is the same node
        @test hash(CC.resolve(t)) == hash(t)
        # `IdAlias` is a typedef, so its type node is sugar over `int`: two different nodes
        # that denote one type. They compare unequal, because carrier equality is clang's
        # `Type *` comparison and deliberately not type equivalence -- ask
        # `getCanonicalType` when the question is whether two types denote the same thing.
        alias = first(d for d in ds if d isa CC.VarDecl && CC.getName(d) == "id_alias")
        sugared = CC.getTypePtr(CC.getType(alias))
        canon = CC.getTypePtr(CC.getCanonicalType(CC.getType(alias)))
        @test sugared != canon
        @test canon == CC.getTypePtr(CC.getCanonicalType(CC.getType(alias)))   # but stable
    end

    @testset "unrelated hierarchies never compare equal" begin
        # no method covers a Decl against a Stmt, so the fallback is `===`: different types,
        # never equal. The hierarchies stay apart at this level too.
        body = CC.resolve(CC.getBody(fn))
        @test rec != body
        @test length(Set(Any[rec, body])) == 2
    end

    @testset "QualType keeps value equality, qualifiers included" begin
        # A QualType is a PointerIntPair, not a pointer, so it is left with Julia's default
        # struct equality -- which compares type and fast qualifiers together. Overriding it
        # with pointer identity would make these two equal, and they are not the same type.
        qt = CC.getType(var)
        @test qt == CC.getType(var)
        @test CC.addConst(qt) != qt
        @test CC.getTypePtr(CC.addConst(qt)) == CC.getTypePtr(qt)   # same node, different type
    end

    @testset "TypeLoc is excluded, and this is why" begin
        # Every `castTo*TypeLoc` hands back a fresh heap box, so two boxes of one source
        # location have different addresses. Equality by pointer would report them unequal
        # for values that are equal, which is why the TypeLoc hierarchy has no such method.
        tsi = CC.getTypeSourceInfo(first(CC.getFields(rec)))
        CC.is_null_handle(tsi) && return
        a = CC.getTypeLoc(tsi)
        b = CC.getTypeLoc(tsi)
        # two boxes of one location, at different addresses: the fact that rules the
        # hierarchy out of pointer equality
        @test a.ptr != b.ptr
        CC.dispose(a)
        CC.dispose(b)
    end

    dispose(I)
end
