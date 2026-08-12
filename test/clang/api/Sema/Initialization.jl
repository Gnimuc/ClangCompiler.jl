using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# clang's initialization engine. Each testset builds the entity/kind/sequence triple and
# disposes it in reverse-dependency order; the entity must outlive every sequence built
# from it.

@testset "InitializationSequence | a legal conversion succeeds and an illegal one fails" begin
    I = create_interpreter(String[])
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    CC.parse(I, """
        struct InitFromInt { InitFromInt(int); };
        struct InitUnrelated { };
    """)
    f = DeclFinder(I)

    # int -> InitFromInt goes through the converting constructor
    @test f(I, "InitFromInt")
    target = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    src = CC.OpaqueValueExpr(ctx, CC.SourceLocation(), CC.get_qual_type(CC.IntTy(ctx)),
                             CC.LibClangEx.CXExprValueKind_VK_PRValue)
    entity = CC.InitializeTemporary(target)
    kind = CC.CreateCopy(CC.SourceLocation(), CC.SourceLocation())
    seq = CC.InitializationSequence(sema, entity, kind, [src])
    @test !CC.Failed(seq)

    # int -> InitUnrelated has no conversion at all, so the same three steps fail
    @test f(I, "InitUnrelated")
    bad_target = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    bad_entity = CC.InitializeTemporary(bad_target)
    bad_seq = CC.InitializationSequence(sema, bad_entity, kind, [src])
    @test CC.Failed(bad_seq)
    # the failure kind is a real classification, not a placeholder: a failed and a
    # successful sequence disagree about getKind
    @test CC.getKind(bad_seq) != CC.getKind(seq)

    dispose(bad_seq)
    dispose(bad_entity)
    dispose(seq)
    dispose(kind)
    dispose(entity)
    dispose(f)
    dispose(I)
end

@testset "CanPerformCopyInitialization agrees with the sequence it summarises" begin
    I = create_interpreter(String[])
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    CC.parse(I, "struct CopyInitTarget { CopyInitTarget(double); };")
    f = DeclFinder(I)
    @test f(I, "CopyInitTarget")
    target = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))

    ok_src = CC.OpaqueValueExpr(ctx, CC.SourceLocation(), CC.get_qual_type(CC.IntTy(ctx)),
                                CC.LibClangEx.CXExprValueKind_VK_PRValue)
    entity = CC.InitializeTemporary(target)
    # int converts to double converts to CopyInitTarget, so the one-shot says yes ...
    @test CC.CanPerformCopyInitialization(sema, entity, ok_src)
    # ... and so does the sequence it is a summary of
    kind = CC.CreateCopy(CC.SourceLocation(), CC.SourceLocation())
    seq = CC.InitializationSequence(sema, entity, kind, [ok_src])
    @test !CC.Failed(seq)

    dispose(seq)
    dispose(kind)
    dispose(entity)
    dispose(f)
    dispose(I)
end

@testset "InitializedEntity | the entity remembers the type it was built from" begin
    I = create_interpreter(String[])
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    ty = CC.get_qual_type(CC.IntTy(ctx))
    for entity in
        (CC.InitializeTemporary(ty), CC.InitializeResult(CC.SourceLocation(), ty), CC.InitializeParameter(ctx, ty))
        # whichever role the entity plays, the type crosses back unchanged
        @test CC.getAsString(CC.getType(entity)) == CC.getAsString(ty)
        dispose(entity)
    end
    dispose(I)
end
