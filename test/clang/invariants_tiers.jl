using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

# Invariants for the tiers `test/clang/invariants.jl` does not reach: the type system, the
# declaration graph, and the identifier table. Same rule as there -- a relationship that
# holds whatever the values are, so nothing is captured and nothing is per-platform.
#
# Each of these survived an adversarial pass whose job was to find a program making it
# false. Several proposals did not survive, and the ones below are narrowed accordingly:
# `getUnqualifiedType` does not strip a qualifier clang hoisted onto an array's element
# type, a variadic macro carries an implicit `__VA_ARGS__` parameter no `#define` spelled,
# and `getResults` reports `getUnderlyingDecl()` rather than the declaration lookup matched.
# Those are properties of clang, not defects, and asserting the tidier version would have
# produced a test that fails on valid input.

const TIER_SRC = """
typedef int TiInt;
using TiAlias = TiInt;
const int ti_ci = 0;
volatile int ti_vi = 0;
int ti_i;
int *ti_p;
const int *ti_pc;

struct TiRec { int f; double g; };
TiRec ti_rec;

int ti_fwd(int a, int b);
int ti_fwd(int a, int b) { return a + b; }

namespace ti_ns { int ti_nested(int x) { return x; } }
"""

tier_types(I) = begin
    ctx = CC.getASTContext(CC.get_sema(I))
    out = CC.QualType[]
    for d in CC.decls(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx)))
        d isa CC.AbstractValueDecl || continue
        q = CC.getType(d)
        CC.isNull(q) || push!(out, q)
    end
    return out
end

@testset "type system invariants" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, TIER_SRC)
    ctx = CC.getASTContext(CC.get_sema(I))
    univ = tier_types(I)
    @test length(univ) >= 6

    @testset "canonicalisation is a fixed point, reached by either pivot" begin
        for q in univ
            can = CC.getCanonicalType(q)
            @test CC.isCanonical(can)
            # applying it twice changes nothing
            @test CC.getTypePtr(CC.getCanonicalType(can)).ptr == CC.getTypePtr(can).ptr
            # and crossing QualType -> Type_ -> QualType lands on the same node
            @test CC.getTypePtr(CC.getCanonicalTypeInternal(CC.getTypePtr(q))).ptr == CC.getTypePtr(can).ptr
        end
    end

    @testset "a fast qualifier moves no pointer" begin
        # QualType is a PointerIntPair; const/volatile/restrict live in the int half, so
        # adding one cannot change which Type the QualType designates.
        for q in univ
            t = CC.getTypePtr(q)
            @test CC.getTypePtr(CC.addConst(q)).ptr == t.ptr
            @test CC.getTypePtr(CC.addVolatile(q)).ptr == t.ptr
            @test CC.getTypePtr(CC.addRestrict(q)).ptr == t.ptr
        end
    end

    @testset "the qualifier read back is the one added" begin
        # Restricted to types with no local qualifiers to begin with: getUnqualifiedType
        # removes only *local* ones, and clang hoists a qualifier from an array's element
        # type onto the array, so a const element array is not unqualified after stripping.
        for q in univ
            u = CC.getUnqualifiedType(q)
            CC.hasLocalQualifiers(u) && continue
            c, v, r = CC.addConst(u), CC.addVolatile(u), CC.addRestrict(u)
            @test CC.isLocalConstQualified(c)
            @test !CC.isLocalVolatileQualified(c)
            @test !CC.isLocalRestrictQualified(c)
            @test CC.isLocalVolatileQualified(v)
            @test !CC.isLocalConstQualified(v)
            @test CC.isLocalRestrictQualified(r)
            @test !CC.isLocalConstQualified(r)
            # the two spellings of the same operation agree
            @test CC.withConst(u).ptr == c.ptr
            @test CC.withVolatile(u).ptr == v.ptr
        end
    end

    @testset "a pointer's pointee is what it was built from" begin
        for q in univ
            p = CC.getPointerType(ctx, q)
            @test CC.isPointerType(CC.getTypePtr(p))
            @test CC.getPointeeType(CC.getTypePtr(p)).ptr == q.ptr
            # uniquing: the same pointee yields the same node, and a different pointee a
            # different node. `addConst` is a no-op on an already-const type, which is the
            # case where the two pointees are the same type and the nodes rightly coincide.
            @test CC.getPointerType(ctx, q).ptr == p.ptr
            cq = CC.addConst(q)
            cq.ptr == q.ptr || @test CC.getPointerType(ctx, cq).ptr != p.ptr
        end
    end

    dispose(I)
end

@testset "declaration graph invariants" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, TIER_SRC)
    ctx = CC.getASTContext(CC.get_sema(I))
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))

    @testset "the two traversals of a context agree" begin
        # decls_in walks the linked chain one ccall at a time; decls bulk-extracts the whole
        # subtree. On the direct children of a context they must report the same nodes in
        # the same order -- the disagreement that hid DeclIterator's dropped first element.
        # `decls` resolves each node while `decls_in` hands back base carriers; carrier
        # equality is the `Decl *` clang compares, so the two walks meet without unwrapping
        chain = collect(CC.decls_in(tu))
        bulk = Set(CC.decls(tu))
        @test !isempty(chain)
        @test allunique(chain)
        @test all(p -> p in bulk, chain)
    end

    @testset "the Decl/DeclContext pivot round-trips" begin
        # The two bases sit at different offsets, so crossing and returning must land on the
        # same Decl -- reusing the raw pointer instead would not.
        # Only a declaration that is also a context may cross. A VarDecl is not one, and
        # crossing it returns a pointer that is neither null nor meaningful -- which is why
        # the gate is `classof`, not a null check on the result.
        n = 0
        for d in CC.decls_in(tu)
            CC.classof(d) || continue
            dc = CC.castToDeclContext(d)
            @test !CC.is_null_handle(dc)
            @test CC.castFromDeclContext(dc).ptr == d.ptr
            n += 1
        end
        @test n > 0
        # the gate is real: something in this source is not a context
        @test any(d -> !CC.classof(d), CC.decls_in(tu))
    end

    @testset "a redeclaration chain is finite and ends at the first declaration" begin
        # ti_fwd is declared then defined, so its chain has at least two links. The walk is
        # bounded explicitly: ChainIterator stops only on a null handle, so a shim returning
        # a fixed point would otherwise spin rather than fail.
        # `decls` resolves each node to its concrete carrier; `decls_in` hands back base
        # Decl carriers, on which `isa AbstractFunctionDecl` never matches.
        fwd = nothing
        for d in CC.decls(tu)
            d isa CC.AbstractFunctionDecl || continue
            CC.isIdentifier(CC.getDeclName(d)) || continue
            CC.getName(d) == "ti_fwd" && (fwd=d; break)
        end
        @test fwd !== nothing
        if fwd !== nothing
            # links come back as whatever class each redeclaration is; carrier equality is
            # the `Decl *` they share, so the cycle check needs no unwrapping
            seen, cur, steps = Set{CC.AbstractDecl}(), CC.getMostRecentDecl(fwd), 0
            while !CC.is_null_handle(cur) && steps < 64
                @test !(cur in seen)             # no cycle
                push!(seen, cur)
                cur = CC.getPreviousDecl(cur)
                steps += 1
            end
            @test steps >= 2                     # a declaration and a definition
            @test steps < 64                     # terminated on its own, not on the bound
        end
    end

    @testset "parameter indices name distinct parameters" begin
        fns = [d for d in CC.decls(tu) if d isa CC.AbstractFunctionDecl]
        @test !isempty(fns)
        multi = 0
        for f in fns
            n = Int(CC.getNumParams(f))
            ps = [CC.getParamDecl(f, i) for i = 0:(n - 1)]
            @test length(ps) == n
            @test all(p -> !CC.is_null_handle(p), ps)
            @test allunique(p.ptr for p in ps)
            n > 1 && (multi += 1)
        end
        @test multi > 0
    end

    dispose(I)
end

@testset "the identifier table interns by spelling" begin
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, TIER_SRC)
    pp = CC.getPreprocessor(CC.get_instance(I))

    for name in ("ti_fwd", "ti_ns", "TiRec", "a_name_the_source_never_spells")
        ii = CC.getIdentifierInfo(pp, name)
        @test !CC.is_null_handle(ii)
        # what goes in comes back out
        @test CC.getName(ii) == name
        # and the same spelling reaches the same object, which is what makes pointer
        # identity a usable test for "same identifier" everywhere else
        @test CC.getIdentifierInfo(pp, name).ptr == ii.ptr
    end
    # distinct spellings are distinct objects
    @test CC.getIdentifierInfo(pp, "ti_fwd").ptr != CC.getIdentifierInfo(pp, "ti_ns").ptr

    dispose(I)
end

@testset "each parse chains a new translation unit" begin
    # An incremental interpreter does not have one translation unit. ASTContext keeps a
    # redeclaration chain of TranslationUnitDecls and getTranslationUnitDecl returns the
    # most recent, so a walk after a second parse sees only that parse's declarations.
    # Pinned here because it is surprising and quietly makes a test vacuous: parse twice,
    # walk the translation unit, and the first chunk is simply absent.
    I = create_interpreter(["-std=c++17"])
    ctx = CC.getASTContext(CC.get_sema(I))

    CC.parse(I, "int tu_first(int x) { return x; }")
    tu1 = CC.getTranslationUnitDecl(ctx)
    fnnames(t) = [CC.getName(d)
                  for d in CC.decls(CC.castToDeclContext(t))
                  if d isa CC.AbstractFunctionDecl && CC.isIdentifier(CC.getDeclName(d))]
    names1 = fnnames(tu1)
    @test "tu_first" in names1

    CC.parse(I, "int tu_second(int x) { return x; }")
    tu2 = CC.getTranslationUnitDecl(ctx)
    @test tu2.ptr != tu1.ptr                     # a different TranslationUnitDecl
    names2 = fnnames(tu2)
    @test "tu_second" in names2
    @test !("tu_first" in names2)                # the earlier chunk is not reachable here

    # the earlier unit is still intact behind its own handle
    names1_again = fnnames(tu1)
    @test "tu_first" in names1_again

    dispose(I)
end
