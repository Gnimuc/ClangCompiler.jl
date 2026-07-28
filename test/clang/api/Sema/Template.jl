using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "MultiLevelTemplateArgumentList | levels, kinds and argument access" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)

    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    ta_type = CC.TemplateArgument(int_qt)
    ta_null = CC.TemplateArgument(int_qt, true)
    @test CC.getKind(ta_type) == CC.CXTemplateArgument_Type
    @test CC.getKind(ta_null) == CC.CXTemplateArgument_NullPtr

    ml = CC.MultiLevelTemplateArgumentList()
    @test ml isa CC.MultiLevelTemplateArgumentList
    @test ml.ptr != C_NULL

    # a fresh list substitutes nothing and defaults to the specialization kind
    @test CC.getNumLevels(ml) == 0
    @test CC.getNumSubstitutedLevels(ml) == 0
    @test CC.getNumRetainedOuterLevels(ml) == 0
    @test CC.getKind(ml) == CC.CXTemplateSubstitutionKind_Specialization
    @test CC.isRewrite(ml) == false
    @test CC.isAnyArgInstantiationDependent(ml) == false

    # the list copies the arguments, so the caller keeps ownership of its own boxes
    CC.addOuterTemplateArguments(ml, tu, [ta_type, ta_null], true)
    @test CC.getNumLevels(ml) == 1
    @test CC.getNumSubstitutedLevels(ml) == 1
    @test CC.getNumSubsitutedArgs(ml, 0) == 2
    @test CC.hasTemplateArgument(ml, 0, 0)
    @test CC.hasTemplateArgument(ml, 0, 1)
    @test CC.hasTemplateArgument(ml, 0, 7) == false
    @test CC.getKind(CC.getArgument(ml, 0, 0)) == CC.CXTemplateArgument_Type
    @test CC.getKind(CC.getArgument(ml, 0, 1)) == CC.CXTemplateArgument_NullPtr
    @test !(CC.isAnyArgInstantiationDependent(ml))

    # the associated decl is stored canonicalised, and the Final bit round-trips
    assoc = CC.getAssociatedDecl(ml, 0)
    @test assoc isa CC.Decl
    @test assoc.ptr != C_NULL
    @test CC.getDeclKindName(assoc) == "TranslationUnit"
    @test CC.isAssociatedDeclFinal(ml, 0) == true

    # innermost and outermost name the same level while there is only one
    @test CC.getNumInnermostArgs(ml) == 2
    @test CC.getNumOutermostArgs(ml) == 2
    @test CC.getInnermostArg(ml, 0).ptr == CC.getArgument(ml, 0, 0).ptr
    @test CC.getOutermostArg(ml, 1).ptr == CC.getArgument(ml, 0, 1).ptr

    # setArgument writes into the list's own copy of the level
    CC.setArgument(ml, 0, 0, ta_null)
    @test CC.getKind(CC.getArgument(ml, 0, 0)) == CC.CXTemplateArgument_NullPtr

    # the unchecked C++ indexing is rejected in Julia, before the ccall
    @test_throws AssertionError CC.getArgument(ml, 1, 0)
    @test_throws AssertionError CC.getArgument(ml, 0, 2)
    @test_throws AssertionError CC.getNumSubsitutedArgs(ml, 1)
    @test_throws AssertionError CC.getInnermostArg(ml, 2)
    @test_throws AssertionError CC.getOutermostArg(ml, 2)

    # replacing the innermost level swaps the whole argument list
    CC.replaceInnermostTemplateArguments(ml, tu, [ta_type])
    @test CC.getNumSubstitutedLevels(ml) == 1
    @test CC.getNumSubsitutedArgs(ml, 0) == 1
    @test CC.getKind(CC.getArgument(ml, 0, 0)) == CC.CXTemplateArgument_Type

    # a retained outer level raises the substituted level's depth without adding arguments
    CC.addOuterRetainedLevel(ml)
    @test CC.getNumRetainedOuterLevels(ml) == 1
    @test CC.getNumLevels(ml) == 2
    @test CC.getNumSubstitutedLevels(ml) == 1
    @test CC.hasTemplateArgument(ml, 0, 0) == false
    @test CC.getNumSubsitutedArgs(ml, 1) == 1
    CC.addOuterRetainedLevels(ml, 2)
    @test CC.getNumRetainedOuterLevels(ml) == 3
    @test CC.getNumLevels(ml) == 4

    # getNewDepth keeps retained depths, collapses substituted ones, shifts the rest down
    @test CC.getNewDepth(ml, 0) == 0
    @test CC.getNewDepth(ml, 3) == 3
    @test CC.getNewDepth(ml, 9) == 8

    # a rewriting list reports it both ways
    CC.setKind(ml, CC.CXTemplateSubstitutionKind_Rewrite)
    @test CC.getKind(ml) == CC.CXTemplateSubstitutionKind_Rewrite
    @test CC.isRewrite(ml) == true
    CC.setKind(ml, CC.CXTemplateSubstitutionKind_Specialization)
    @test CC.isRewrite(ml) == false

    # substituted arguments may not be stacked on top of retained levels
    @test_throws AssertionError CC.addOuterTemplateArguments(ml, tu, [ta_type], false)

    dispose(ml)
    dispose(ta_type)
    dispose(ta_null)
    dispose(I)
end
