using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Sema | lookup, completeness and scope-spec helpers" begin
    CC = ClangCompiler

    I = CC.create_interpreter()
    sema = CC.get_sema(I)

    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    @test ctx isa CC.ASTContext
    @test sm isa CC.SourceManager
    @test pp isa CC.Preprocessor
    @test CC.getDiagnostics(sema) isa CC.DiagnosticsEngine
    @test CC.getLangOpts(sema) isa CC.LangOptions
    @test CC.getCurScope(sema) isa CC.Scope
    @test ctx.ptr != C_NULL
    @test sm.ptr != C_NULL
    @test pp.ptr != C_NULL

    CC.parse(I, "struct SemaCompleteS { int a; }; struct SemaIncompleteS;")

    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    @test tu isa CC.DeclContext
    loc = CC.get_main_file_begin_loc(sm)

    # qualified lookup into the translation unit, then decl -> QualType
    function lookup_tag_type(name)
        r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, name)), loc,
                            CC.CXLookupNameKind_LookupTagName)
        found = CC.LookupQualifiedName(sema, r, tu)
        ty = found ? CC.getTypeDeclType(ctx, CC.TypeDecl(CC.getResult(r))) : nothing
        CC.dispose(r)
        return ty
    end

    complete = lookup_tag_type("SemaCompleteS")
    incomplete = lookup_tag_type("SemaIncompleteS")
    @test complete isa CC.QualType
    @test incomplete isa CC.QualType
    @test complete.ptr != C_NULL
    @test incomplete.ptr != C_NULL

    # isCompleteType never diagnoses, so both polarities are safe to assert.
    @test CC.isCompleteType(sema, loc, complete)
    @test !CC.isCompleteType(sema, loc, incomplete)
    @test CC.isCompleteType(sema, loc, complete, CC.CXCompleteTypeKind_Normal)

    # A complete/literal type short-circuits before the diagnoser is consulted,
    # so no diagnostic is emitted for these two.
    @test CC.RequireCompleteType(sema, loc, complete, 1) == false
    @test CC.RequireLiteralType(sema, loc, complete, 1) isa Bool

    # a zero diag id is rejected by the wrapper, not by clang
    @test_throws AssertionError CC.RequireCompleteType(sema, loc, complete, 0)

    dc = CC.computeDeclContext(sema, complete)
    @test dc isa CC.DeclContext
    @test dc.ptr != C_NULL
    @test CC.RequireCompleteDeclContext(sema, CC.CXXScopeSpec(), dc) == false

    ss = CC.CXXScopeSpec()
    @test CC.computeDeclContext(sema, ss) isa CC.DeclContext
    @test CC.isDependentScopeSpecifier(sema, ss) == false
    CC.dispose(ss)

    scope = CC.getCurScope(CC.get_parser(I))
    single = CC.LookupSingleName(sema, scope,
                                 CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaCompleteS")),
                                 loc, CC.CXLookupNameKind_LookupTagName)
    @test single isa CC.NamedDecl

    dispose(I)
end

@testset "sema-template" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <class T> struct Box { T value; T get() { return value; } };
    struct Plain { int x; };
    """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    llctx = CC.LLVM.Context()
    f = DeclFinder(I)

    # --- LookupResult tail ---
    @test f(I, "Plain")
    lr = f.result
    @test CC.getResultKind(lr) isa CC.CXLookupResultKind
    @test CC.getResultKind(lr) == CC.CXLookupResultKind_Found
    @test CC.getLookupKind(lr) == CC.CXLookupNameKind_LookupOrdinaryName
    found = CC.getFoundDecl(lr)
    @test found isa CC.NamedDecl
    @test found.ptr == get_decl(f).ptr
    @test CC.getNamingClass(lr) isa CC.CXXRecordDecl
    @test CC.getNameLoc(lr) isa CC.SourceLocation
    @test CC.getIdentifierNamespace(lr) isa Integer
    @test CC.getIdentifierNamespace(lr) > 0
    @test CC.suppressDiagnostics(lr) === nothing
    # getAmbiguityKind asserts isAmbiguous(); this lookup is unique
    @test !CC.isAmbiguous(lr)
    @test_throws AssertionError CC.getAmbiguityKind(lr)

    # --- Scope accessors ---
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test CC.getFlags(sc) isa Integer
    @test CC.getFnParent(sc) isa CC.Scope
    @test CC.getEntity(sc) isa CC.DeclContext
    @test CC.isTemplateParamScope(sc) isa Bool
    @test CC.isDeclScope(sc, found) isa Bool

    # --- forced template instantiation, then inspect the result ---
    @test f(I, "Box")
    box_ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    loc = CC.getLocation(box_ctd)
    spec = CC.specialize(llctx, ctx, box_ctd, CC.jlty_to_clty(Float64, ctx))
    @test spec isa CC.ClassTemplateSpecializationDecl
    @test spec.ptr != C_NULL
    @test CC.usesPartialOrExplicitSpecialization(sema, loc, spec) isa Bool
    # returns true only when instantiation errored
    @test CC.InstantiateClassTemplateSpecialization(sema, loc, spec,
                                                    CC.CXTemplateSpecializationKind_TSK_ImplicitInstantiation,
                                                    false) isa Bool
    @test CC.isCompleteDefinition(spec)
    qt = CC.getTypeDeclType(ctx, spec)
    @test CC.isCompleteType(sema, loc, qt)
    @test CC.InstantiateClassTemplateSpecializationMembers(sema, loc, spec,
                                                           CC.CXTemplateSpecializationKind_TSK_ImplicitInstantiation) === nothing
    @test CC.PerformPendingInstantiations(sema) === nothing

    dispose(f)
    CC.LLVM.dispose(llctx)
    dispose(I)
end
