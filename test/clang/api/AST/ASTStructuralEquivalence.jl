using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl
using Test

@testset "StructuralEquivalenceContext" begin
    From = create_interpreter(String[])
    To = create_interpreter(String[])
    from_ctx = CC.get_ast_context(From)
    to_ctx = CC.get_ast_context(To)

    # the same struct written into two separate translation units, plus one that differs in
    # a single field's type
    CC.parse(From, """
    struct SeqShape { int x; double y; };
    struct SeqOther { int x; float y; };
    """)
    CC.parse(To, "struct SeqShape { int x; double y; };")

    from_shape = find_decl(From, "SeqShape")
    from_other = find_decl(From, "SeqOther")
    to_shape = find_decl(To, "SeqShape")
    @test all(x -> x !== nothing, (from_shape, from_other, to_shape))

    # the box the shim builds owns the non-equivalence cache and holds the two contexts by
    # reference; reading them back is what proves it wired them the way it was told
    sec = CC.StructuralEquivalenceContext(from_ctx, to_ctx)
    @test CC.getFromCtx(sec).ptr == from_ctx.ptr
    @test CC.getToCtx(sec).ptr == to_ctx.ptr

    # two declarations of the same shape in two different ASTs are equivalent
    @test CC.IsEquivalent(sec, from_shape, to_shape)

    # a differing field type is not -- asked on a fresh context, because a comparison caches
    other = CC.StructuralEquivalenceContext(from_ctx, to_ctx)
    @test !CC.IsEquivalent(other, from_other, to_shape)

    # the same partition over types
    types = CC.StructuralEquivalenceContext(from_ctx, to_ctx)
    from_int = CC.get_qual_type(CC.IntTy(from_ctx))
    to_int = CC.get_qual_type(CC.IntTy(to_ctx))
    to_double = CC.get_qual_type(CC.DoubleTy(to_ctx))
    @test from_int != to_int              # different contexts, so different QualType values
    @test CC.IsEquivalent(types, from_int, to_int)
    @test !CC.IsEquivalent(types, from_int, to_double)

    # one context twice is legal, and is how a header parsed twice is deduplicated
    self = CC.StructuralEquivalenceContext(from_ctx, from_ctx; kind=CC.CXStructuralEquivalenceKind_Minimal)
    @test CC.IsEquivalent(self, from_shape, from_shape)
    @test !CC.IsEquivalent(self, from_shape, from_other)

    dispose(self)
    dispose(types)
    dispose(other)
    dispose(sec)
    dispose(To)
    dispose(From)
end

@testset "findUntaggedStructOrUnionIndex" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    struct SeqOwner { union { int a; float f; }; int b; };
    struct { int q; } seq_loose;
    """)

    owner = find_decl(I, "SeqOwner")
    @test owner !== nothing
    anon = [d for d in CC.members(owner) if d isa CC.CXXRecordDecl && isempty(CC.getNameAsString(d))]
    @test length(anon) == 1
    # the anonymous union is the owner's first (and only) untagged member record
    @test CC.findUntaggedStructOrUnionIndex(anon[1]) == 0

    # at namespace scope there is no record to index into, so clang answers with nothing
    loose = find_decl(I, "seq_loose")
    @test loose !== nothing
    loose_rd = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(loose)))
    @test !CC.is_null_handle(loose_rd)
    @test CC.findUntaggedStructOrUnionIndex(loose_rd) === nothing

    dispose(I)
end
