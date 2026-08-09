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
    @test !CC.is_null_handle(CC.getDiagnostics(sema))
    @test !CC.is_null_handle(CC.getLangOpts(sema))
    @test !CC.is_null_handle(CC.getCurScope(sema))
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
    @test !(CC.RequireLiteralType(sema, loc, complete, 1))

    # a zero diag id is rejected by the wrapper, not by clang
    @test_throws AssertionError CC.RequireCompleteType(sema, loc, complete, 0)

    dc = CC.computeDeclContext(sema, complete)
    @test dc isa CC.DeclContext
    @test dc.ptr != C_NULL
    @test CC.RequireCompleteDeclContext(sema, CC.CXXScopeSpec(), dc) == false

    ss = CC.CXXScopeSpec()
    @test CC.is_null_handle(CC.computeDeclContext(sema, ss))
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
    @test CC.is_null_handle(CC.getNamingClass(lr))
    @test !CC.is_null_handle(CC.getNameLoc(lr))
    @test CC.getIdentifierNamespace(lr) == 58
    @test CC.suppressDiagnostics(lr) === nothing
    # getAmbiguityKind asserts isAmbiguous(); this lookup is unique
    @test !CC.isAmbiguous(lr)
    @test_throws AssertionError CC.getAmbiguityKind(lr)

    # --- Scope accessors ---
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test CC.getFlags(sc) == 8
    @test CC.is_null_handle(CC.getFnParent(sc))
    @test !CC.is_null_handle(CC.getEntity(sc))
    @test !(CC.isTemplateParamScope(sc))
    @test CC.isDeclScope(sc, found)

    # --- forced template instantiation, then inspect the result ---
    @test f(I, "Box")
    box_ctd = CC.ClassTemplateDecl(get_decl(f))
    loc = CC.getLocation(box_ctd)
    spec = CC.specialize(llctx, ctx, box_ctd, CC.jlty_to_clty(Float64, ctx))
    @test spec isa CC.ClassTemplateSpecializationDecl
    @test spec.ptr != C_NULL
    @test !(CC.usesPartialOrExplicitSpecialization(sema, loc, spec))
    # returns true only when instantiation errored
    @test CC.InstantiateClassTemplateSpecialization(sema, loc, spec,
                                                    CC.CXTemplateSpecializationKind_TSK_ImplicitInstantiation,
                                                    false) isa Bool
    @test CC.isCompleteDefinition(spec)
    qt = CC.getTypeDeclType(ctx, spec)
    @test CC.isCompleteType(sema, loc, qt)
    @test CC.InstantiateClassTemplateSpecializationMembers(sema, loc, spec,
                                                           CC.CXTemplateSpecializationKind_TSK_ImplicitInstantiation) ===
          nothing
    @test CC.PerformPendingInstantiations(sema) === nothing

    dispose(f)
    CC.LLVM.dispose(llctx)
    dispose(I)
end

@testset "Sema | special-member lookup, visible decls and type requirements" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    srcmgr = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(srcmgr)

    CC.parse(I, """
    struct SemaSpecial { int a; SemaSpecial() {} SemaSpecial(int) {} void m() {} };
    struct SemaOpaque;
    """)

    f = DeclFinder(I)
    @test f(I, "SemaSpecial")
    rd = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasDefinition(rd)

    # The lookup declares the implicit constructors before reporting, so the two written
    # ones are a lower bound on the result rather than the exact count.
    ctors = CC.LookupConstructors(sema, rd)
    @test ctors isa Vector{CC.NamedDecl}
    @test length(ctors) >= 2
    @test all(d -> d.ptr != C_NULL, ctors)

    # quals/this_quals are Qualifiers bitmasks limited to Const (0x1) and Volatile (0x4);
    # Restrict (0x2) and anything above them are rejected by the wrapper, not by clang.
    copy_ctor = CC.LookupCopyingConstructor(sema, rd, 0x1)
    @test copy_ctor isa CC.CXXConstructorDecl
    @test copy_ctor.ptr != C_NULL
    @test !CC.is_null_handle(CC.LookupMovingConstructor(sema, rd))
    @test !CC.is_null_handle(CC.LookupCopyingAssignment(sema, rd, 0x1))
    @test !CC.is_null_handle(CC.LookupMovingAssignment(sema, rd))
    @test_throws AssertionError CC.LookupCopyingConstructor(sema, rd, 0x2)
    @test_throws AssertionError CC.LookupCopyingAssignment(sema, rd, 0, false, 0x2)
    @test_throws AssertionError CC.LookupMovingConstructor(sema, rd, 0x8)
    @test_throws AssertionError CC.LookupMovingAssignment(sema, rd, 0, false, 0x8)

    # LookupSpecialMember is what the convenience lookups above are built on, so the two
    # must agree decl-for-decl and not merely both return something.
    default_md, default_kind = CC.LookupSpecialMember(sema, rd,
                                                      CC.CXCXXSpecialMember_CXXDefaultConstructor)
    @test default_md isa CC.CXXMethodDecl
    @test default_kind isa CC.CXSpecialMemberOverloadResultKind
    @test default_md.ptr == CC.LookupDefaultConstructor(sema, rd).ptr
    dtor_md, _ = CC.LookupSpecialMember(sema, rd, CC.CXCXXSpecialMember_CXXDestructor)
    @test dtor_md.ptr == CC.LookupDestructor(sema, rd).ptr
    copy_md, copy_kind = CC.LookupSpecialMember(sema, rd,
                                                CC.CXCXXSpecialMember_CXXCopyConstructor, true)
    @test copy_md.ptr == copy_ctor.ptr
    @test copy_kind isa CC.CXSpecialMemberOverloadResultKind

    # A class with no definition cannot take a special-member lookup: the wrapper rejects
    # it instead of letting Sema's own assert fire.
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaOpaque")), loc,
                        CC.CXLookupNameKind_LookupTagName)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    @test CC.LookupQualifiedName(sema, r, tu)
    opaque = CC.CXXRecordDecl(CC.getResult(r))
    CC.dispose(r)
    @test !CC.hasDefinition(opaque)
    @test_throws AssertionError CC.LookupConstructors(sema, opaque)
    @test_throws AssertionError CC.LookupSpecialMember(sema, opaque,
                                                       CC.CXCXXSpecialMember_CXXDestructor)

    # A user-declared name is not a builtin, so nothing is created and the lookup fails.
    rb = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaSpecial")),
                         loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupBuiltin(sema, rb) === false
    CC.dispose(rb)

    # Visible-decl enumeration over the record itself; include_global_scope=false keeps the
    # walk from reaching into the translation unit.
    rd_dc = CC.castToDeclContext(rd)
    visible = CC.LookupVisibleDecls(sema, rd_dc, CC.CXLookupNameKind_LookupOrdinaryName, false)
    @test visible isa Vector{CC.NamedDecl}
    @test !isempty(visible)
    @test all(d -> !CC.is_null_handle(d), visible)
    # `decls` resolves each member to its own class while the lookup hands back `NamedDecl`s;
    # carrier equality is the `Decl *` they share, so the two sides compare directly
    members = Set(CC.decls(rd_dc))
    @test any(in(members), visible)

    # A non-abstract type returns before the diagnoser is consulted, so neither call below
    # emits anything; a zero diag id is rejected by the wrapper, not by clang.
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    @test CC.RequireNonAbstractType(sema, loc, int_ty, 1) == false
    @test CC.RequireNonAbstractType(sema, loc, CC.getTypeDeclType(ctx, rd), 1) == false
    @test_throws AssertionError CC.RequireNonAbstractType(sema, loc, int_ty, 0)
    # int is a scalar type and therefore structural, so nothing is diagnosed for it either
    @test CC.RequireStructuralType(sema, int_ty, loc) == false

    dispose(f)
    dispose(I)
end

@testset "Sema | visibility, current-context and conversion queries" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaQBase { int b; };
             struct SemaQDerived : SemaQBase {
               int d;
               void mem();
               void operator delete(void *p);
             };
             struct SemaQUnrelated { int u; };
             void sema_q_fn(int a) { int b = a; (void)b; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    # error state and the token-end helper
    @test !(CC.hasUncompilableErrorOccurred(sema))
    @test !CC.is_null_handle(CC.getLocForEndOfToken(sema, loc))
    @test !CC.is_null_handle(CC.getLocForEndOfToken(sema, loc, 1))

    # `int` is scalar, so both fix-it spellings accept it
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    @test !isempty(CC.getFixItZeroInitializerForType(sema, int_ty, loc))
    @test !isempty(CC.getFixItZeroLiteralForType(sema, int_ty, loc))

    # current-context queries; at the top level Sema sits in the translation unit
    @test !CC.is_null_handle(CC.getCurLexicalContext(sema))
    @test CC.getCurLexicalContext(sema).ptr != C_NULL
    @test !CC.is_null_handle(CC.getFunctionLevelDeclContext(sema))
    @test !CC.is_null_handle(CC.getFunctionLevelDeclContext(sema, true))
    @test CC.is_null_handle(CC.getCurFunctionDecl(sema))
    @test CC.is_null_handle(CC.getCurFunctionDecl(sema, true))
    @test CC.is_null_handle(CC.getCurFunctionOrMethodDecl(sema))

    # the std entities Sema caches, NULL until the corresponding header is seen
    @test !CC.is_null_handle(CC.getStdNamespace(sema))
    @test CC.is_null_handle(CC.getStdBadAlloc(sema))

    @test f(I, "SemaQBase")
    base_nd = get_decl(f)
    @test CC.isVisible(sema, base_nd)
    @test CC.isReachable(sema, base_nd)
    @test !(CC.hasVisibleMergedDefinition(sema, base_nd))
    @test !(CC.isEquivalentInternalLinkageDeclaration(sema, base_nd, base_nd))
    base_ty = CC.getTypeDeclType(ctx, CC.TypeDecl(base_nd))

    @test f(I, "SemaQDerived")
    derived_ty = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    @test f(I, "SemaQUnrelated")
    unrelated_ty = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))

    # derivation is a language fact, so both polarities are asserted
    @test CC.IsDerivedFrom(sema, loc, derived_ty, base_ty)
    @test !CC.IsDerivedFrom(sema, loc, base_ty, derived_ty)
    @test !CC.IsDerivedFrom(sema, loc, unrelated_ty, base_ty)

    # float -> double is the textbook floating-point promotion
    @test CC.IsFloatingPointPromotion(sema, CC.get_qual_type(CC.jlty_to_clty(Float32, ctx)),
                                      CC.get_qual_type(CC.jlty_to_clty(Float64, ctx)))
    @test CC.IsFloatingPointPromotion(sema, int_ty, int_ty) == false

    # member queries reached through the record's own method list
    rd = CC.getAsCXXRecordDecl(CC.getTypePtr(derived_ty))
    @test rd isa CC.CXXRecordDecl
    methods = CC.getMethods(rd)
    @test !isempty(methods)
    mem_m = first(m for m in methods if CC.getNameAsString(m) == "mem")
    del_m = first(m for m in methods if CC.getNameAsString(m) == "operator delete")
    @test !CC.isUsualDeallocationFunction(sema, mem_m)
    @test CC.isUsualDeallocationFunction(sema, del_m)

    @test f(I, "sema_q_fn")
    fd = CC.FunctionDecl(get_decl(f))
    @test !(CC.isInitListConstructor(sema, fd))
    @test !(CC.isImplicitlyDeleted(sema, fd))
    body = CC.getBody(fd)
    @test body.ptr != C_NULL
    @test CC.canThrow(sema, body) isa CC.CXCanThrowResult
    @test CC.canThrow(sema, body) in (CC.CXCanThrowResult_CT_Cannot,
                                      CC.CXCanThrowResult_CT_Dependent,
                                      CC.CXCanThrowResult_CT_Can)

    # the literal spelling asserts scalar-ness, which a class type fails
    @test_throws AssertionError CC.getFixItZeroLiteralForType(sema, base_ty, loc)

    dispose(f)
    dispose(I)
end

@testset "Sema | ODR-use marking, auto substitution and function-template deduction" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    template <class T> auto sema_subst_add(T a, int b = sizeof(T)) { return a + b; }
    struct SemaSubstPoly { virtual int f() { return 1; } virtual ~SemaSubstPoly() {} };
    struct SemaSubstAgg { SemaSubstPoly p; int n; };
    int sema_subst_global = 7;
    int sema_subst_fn(int x) { return x; }
    """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    loc = CC.get_main_file_begin_loc(CC.getSourceManager(sema))
    f = DeclFinder(I)

    # Select by kind rather than by uniqueness: instantiating a function template adds a
    # specialization to the enclosing lookup, so the template's own name stops resolving to
    # a single decl, and get_decl throws on any name that is already non-unique.
    function by_kind(name, kind)
        @test f(I, name)
        return first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == kind)
    end
    ftd = CC.FunctionTemplateDecl(by_kind("sema_subst_add", "FunctionTemplate"))
    plain_fn = CC.FunctionDecl(by_kind("sema_subst_fn", "Function"))
    global_var = CC.VarDecl(by_kind("sema_subst_global", "Var"))
    poly = CC.CXXRecordDecl(by_kind("SemaSubstPoly", "CXXRecord"))
    agg = CC.CXXRecordDecl(by_kind("SemaSubstAgg", "CXXRecord"))

    # --- ODR-use marking ---
    @test CC.MarkUnusedFileScopedDecl(sema, plain_fn) === nothing
    @test CC.MarkAnyDeclReferenced(sema, loc, plain_fn) === nothing
    @test CC.MarkFunctionReferenced(sema, loc, plain_fn) === nothing
    @test CC.MarkVariableReferenced(sema, loc, global_var) === nothing
    @test CC.MarkDeclarationsReferencedInType(sema, loc, CC.getType(global_var)) === nothing
    @test CC.MarkBaseAndMemberDestructorsReferenced(sema, loc, agg) === nothing
    @test CC.MarkVTableUsed(sema, loc, poly) === nothing
    @test CC.MarkVirtualMemberExceptionSpecsNeeded(sema, loc, poly) === nothing
    @test CC.MarkVirtualMembersReferenced(sema, loc, poly) === nothing

    # --- `auto` substitution: a plain tree transform, no instantiation context needed ---
    int_qt = CC.getType(global_var)
    auto_qt = CC.getAutoDeductType(ctx)
    @test CC.isUndeducedType(CC.getTypePtr(auto_qt))
    subst = CC.SubstAutoType(sema, auto_qt, int_qt)
    @test subst isa CC.QualType
    @test subst.ptr != C_NULL
    dep = CC.SubstAutoTypeDependent(sema, auto_qt)
    @test dep isa CC.QualType
    @test dep.ptr != C_NULL
    @test CC.isDependentType(CC.getTypePtr(dep))

    auto_tsi = CC.getTrivialTypeSourceInfo(ctx, auto_qt, loc)
    subst_tsi = CC.SubstAutoTypeSourceInfo(sema, auto_tsi, int_qt)
    @test subst_tsi isa CC.TypeSourceInfo
    @test subst_tsi.ptr != C_NULL
    @test CC.getType(subst_tsi) isa CC.QualType
    dep_tsi = CC.SubstAutoTypeSourceInfoDependent(sema, auto_tsi)
    @test dep_tsi isa CC.TypeSourceInfo
    @test dep_tsi.ptr != C_NULL

    # --- a template type argument is checked against the language rules ---
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_qt, loc)
    @test !(CC.CheckTemplateArgument(sema, int_tsi))

    # --- which template parameters are deducible from the function parameters ---
    deduced = CC.MarkDeducedTemplateParameters(sema, ftd)
    @test deduced isa Vector{Bool}
    @test length(deduced) == 1  # sema_subst_add has exactly one template parameter

    # --- instantiate the function template declaration, then work on the result ---
    targ = CC.TemplateArgument(int_qt)
    targs = CC.TemplateArgumentList(ctx, [targ])
    fd = CC.InstantiateFunctionDeclaration(sema, ftd, targs, loc)
    @test fd isa CC.FunctionDecl
    @test fd.ptr != C_NULL
    @test CC.getNumParams(fd) == 2

    # the wrapper asserts rather than letting clang deduce an already-deduced return type,
    # so both polarities are covered without reading a value this test did not set.
    undeduced = CC.isUndeducedType(CC.getTypePtr(CC.getReturnType(fd)))
    @test undeduced isa Bool
    if undeduced
        @test !(CC.DeduceReturnType(sema, fd, loc, false))
    else
        @test_throws AssertionError CC.DeduceReturnType(sema, fd, loc, false)
    end

    @test CC.InstantiateExceptionSpec(sema, loc, fd) === nothing

    param = CC.getParamDecl(fd, 1)  # 0-based: the `int b = sizeof(T)` parameter
    @test param isa CC.ParmVarDecl
    if CC.hasUninstantiatedDefaultArg(param)
        @test !(CC.InstantiateDefaultArgument(sema, loc, fd, param))
    else
        @test_throws AssertionError CC.InstantiateDefaultArgument(sema, loc, fd, param)
    end

    dispose(f)
    dispose(I)
end

@testset "Sema type and expression builders" begin
    # A throwaway interpreter: these builders add types and expression nodes to the
    # ASTContext, so nothing here may leak into the interpreter the other files share.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaBuildRec { int m; };
             const int semaBuildEight = 8;
             const int semaBuildTwo = 2;
             int semaBuildFn(int n) { int a[3] = {1, 2, 3}; return a[0] + n; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    rng = CC.SourceRange(loc, loc)
    f = DeclFinder(I)

    # Operands taken from the parse: two integer-literal initializers, a record type, a
    # function type, and a subscript expression whose base has already decayed.
    @test f(I, "semaBuildEight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaBuildTwo")
    two = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "SemaBuildRec")
    recty = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    @test f(I, "semaBuildFn")
    fd = CC.FunctionDecl(get_decl(f))
    fnty = CC.getType(fd)
    ase = first(filter(n -> n isa CC.ArraySubscriptExpr, CC.subtree(CC.getBody(fd))))

    intty = CC.getType(eight)
    @test CC.isIntegerType(CC.getTypePtr(intty))

    # --- Type builders ---
    ptrty = CC.BuildPointerType(sema, intty, loc)
    @test ptrty isa CC.QualType
    @test ptrty.ptr != C_NULL
    @test CC.isPointerType(CC.getTypePtr(ptrty))

    lref = CC.BuildReferenceType(sema, intty, true, loc)
    @test lref.ptr != C_NULL
    @test CC.isLValueReferenceType(CC.getTypePtr(lref))
    rref = CC.BuildReferenceType(sema, intty, false, loc)
    @test CC.isRValueReferenceType(CC.getTypePtr(rref))

    # fromCVRMask(1) is the `const` bit; the qualifier round-trips through the built type.
    constty = CC.BuildQualifiedType(sema, intty, loc, CC.fromCVRMask(1))
    @test constty isa CC.QualType
    @test constty.ptr != C_NULL
    @test CC.getCVRQualifiers(constty) == 1

    # a NULL array size builds an incomplete array type
    incomplete = CC.BuildArrayType(sema, intty, CC.LibClangEx.CXArraySizeModifier_Normal,
                                   CC.Expr_(C_NULL), 0, rng)
    @test incomplete isa CC.QualType
    @test incomplete.ptr != C_NULL
    @test CC.isa_IncompleteArrayType(CC.getTypePtr(incomplete))

    sized = CC.BuildArrayType(sema, intty, CC.LibClangEx.CXArraySizeModifier_Normal, two, 0,
                              rng)
    @test sized.ptr != C_NULL
    @test CC.isa_ArrayType(CC.getTypePtr(sized))

    # BuildVectorType counts bytes, BuildExtVectorType counts elements
    vecty = CC.BuildVectorType(sema, intty, eight, loc)
    @test vecty.ptr != C_NULL
    @test CC.isVectorType(CC.getTypePtr(vecty))
    extvecty = CC.BuildExtVectorType(sema, intty, eight, loc)
    @test extvecty.ptr != C_NULL
    @test CC.isExtVectorType(CC.getTypePtr(extvecty))

    memptr = CC.BuildMemberPointerType(sema, intty, recty, loc)
    @test memptr.ptr != C_NULL
    @test CC.isMemberPointerType(CC.getTypePtr(memptr))

    blockptr = CC.BuildBlockPointerType(sema, fnty, loc)
    @test blockptr.ptr != C_NULL
    @test CC.isBlockPointerType(CC.getTypePtr(blockptr))

    paren = CC.BuildParenType(sema, intty)
    @test paren.ptr != C_NULL
    @test CC.isa_ParenType(CC.getTypePtr(paren))

    atomic = CC.BuildAtomicType(sema, intty, loc)
    @test atomic.ptr != C_NULL
    @test CC.isa_AtomicType(CC.getTypePtr(atomic))

    # _BitInt support is target-gated, so only the shape is asserted
    bitint = CC.BuildBitIntType(sema, false, eight, loc)
    @test bitint isa CC.QualType
    @test bitint.ptr == C_NULL || CC.isBitIntType(CC.getTypePtr(bitint))

    typeofty = CC.BuildTypeofExprType(sema, eight)
    @test typeofty.ptr != C_NULL
    @test CC.isIntegerType(CC.getTypePtr(typeofty))

    decltypety = CC.BuildDecltypeType(sema, eight)
    @test decltypety.ptr != C_NULL
    @test CC.isa_DecltypeType(CC.getTypePtr(decltypety))

    addptr = CC.BuildUnaryTransformType(sema, intty, CC.LibClangEx.CXUTTKind_AddPointer,
                                        loc)
    @test addptr.ptr != C_NULL
    @test CC.isa_UnaryTransformType(CC.getTypePtr(addptr))
    @test CC.isPointerType(CC.getTypePtr(addptr))

    # --- Expression builders: a valid ExprResult surfaces as an Expr_, invalid as nothing
    neg = CC.CreateBuiltinUnaryOp(sema, loc, CC.LibClangEx.CXUnaryOperatorKind_UO_Minus,
                                  eight)
    @test neg isa CC.Expr_
    @test neg.ptr != C_NULL
    @test CC.resolve(neg) isa CC.UnaryOperator
    @test CC.getOpcode(CC.resolve(neg)) == CC.LibClangEx.CXUnaryOperatorKind_UO_Minus

    add = CC.CreateBuiltinBinOp(sema, loc, CC.LibClangEx.CXBinaryOperatorKind_BO_Add, eight,
                                two)
    @test add isa CC.Expr_
    @test CC.resolve(add) isa CC.BinaryOperator
    @test CC.getOpcode(CC.resolve(add)) == CC.LibClangEx.CXBinaryOperatorKind_BO_Add

    sub = CC.CreateBuiltinArraySubscriptExpr(sema, CC.getBase(ase), loc, CC.getIdx(ase), loc)
    @test sub isa CC.Expr_
    @test CC.resolve(sub) isa CC.ArraySubscriptExpr

    tsi = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    szof = CC.CreateUnaryExprOrTypeTraitExpr(sema, tsi, loc,
                                             CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf,
                                             rng)
    @test szof isa CC.Expr_
    @test CC.resolve(szof) isa CC.UnaryExprOrTypeTraitExpr

    initlist = CC.BuildInitList(sema, loc, CC.Expr_[eight, two], loc)
    @test initlist isa CC.Expr_
    @test CC.resolve(initlist) isa CC.InitListExpr
    @test CC.getNumInits(CC.resolve(initlist)) == 2

    noexc = CC.BuildCXXNoexceptExpr(sema, loc, eight, loc)
    @test noexc isa CC.Expr_
    @test CC.resolve(noexc) isa CC.CXXNoexceptExpr

    dispose(f)
    dispose(I)
end

@testset "Sema | semantic checks, implicit special members and deallocation lookup" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)

    CC.parse(I, """
    namespace SemaChkNS { int inside; }
    struct SemaChkBase { virtual void vf(); };
    struct SemaChkDerived : SemaChkBase { void vf(); };
    struct SemaChkPlain { int a; };
    void SemaChkFn();
    int SemaChkVar = 42;
    """)

    f = DeclFinder(I)

    # type-level checks whose well-formed input short-circuits before any diagnostic
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    @test CC.CheckFunctionReturnType(sema, int_ty, loc) == false
    @test !(CC.CheckDistantExceptionSpec(sema, int_ty))
    @test CC.CheckTypeTraitArity(sema, 2, loc, 2)

    # an already-parsed exception specification resolves to a FunctionProtoType
    @test f(I, "SemaChkFn")
    fn_ty = CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(get_decl(f)))))
    @test fn_ty isa CC.FunctionProtoType
    @test CC.getExceptionSpecType(fn_ty) != CC.CXExceptionSpecificationType_EST_Unparsed
    resolved = CC.ResolveExceptionSpec(sema, loc, fn_ty)
    @test resolved isa CC.FunctionProtoType
    @test resolved.ptr != C_NULL

    # the `case` label check runs over a real integer initializer
    @test f(I, "SemaChkVar")
    init = CC.getInit(CC.VarDecl(get_decl(f)))
    @test init isa CC.Expr_
    @test CC.CheckCaseExpression(sema, init)

    # A freshly parsed aggregate has declared none of its special members, so each
    # Declare* below is the first call — and, since the gate closes behind it, the only
    # call that may run.
    @test f(I, "SemaChkPlain")
    plain = CC.CXXRecordDecl(get_decl(f))
    @test CC.needsImplicitDefaultConstructor(plain)
    @test CC.needsImplicitCopyConstructor(plain)
    @test CC.needsImplicitMoveConstructor(plain)
    @test CC.needsImplicitCopyAssignment(plain)
    @test CC.needsImplicitMoveAssignment(plain)
    @test CC.needsImplicitDestructor(plain)

    if CC.needsImplicitDefaultConstructor(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitDefaultConstructor(sema, plain))
    end
    if CC.needsImplicitCopyConstructor(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitCopyConstructor(sema, plain))
    end
    if CC.needsImplicitMoveConstructor(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitMoveConstructor(sema, plain))
    end
    if CC.needsImplicitCopyAssignment(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitCopyAssignment(sema, plain))
    end
    if CC.needsImplicitMoveAssignment(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitMoveAssignment(sema, plain))
    end
    if CC.needsImplicitDestructor(plain)
        @test !CC.is_null_handle(CC.DeclareImplicitDestructor(sema, plain))
    end

    # the gate is closed now, so the wrapper rejects the second call clang would assert on
    @test !CC.needsImplicitDefaultConstructor(plain)
    @test_throws AssertionError CC.DeclareImplicitDefaultConstructor(sema, plain)

    # the global operator new/delete set, then the two deallocation lookups
    @test CC.DeclareGlobalNewDelete(sema) === nothing
    del_name = CC.getCXXOperatorName(CC.getDeclarationNames(ctx),
                                     CC.CXOverloadedOperatorKind_OO_Delete)
    usual_del = CC.FindUsualDeallocationFunction(sema, loc, false, false, del_name)
    @test usual_del isa CC.FunctionDecl
    @test !CC.is_null_handle(CC.FindDeallocationFunctionForDestructor(sema, loc, plain))

    # the leading identifier of a nested-name-specifier, looked up in the current scope
    scope = CC.getCurScope(CC.get_parser(I))
    nns = CC.NestedNameSpecifier(ctx, CC.NestedNameSpecifier(C_NULL),
                                 CC.getIdentifierInfo(pp, "SemaChkNS"))
    @test nns isa CC.NestedNameSpecifier
    @test !CC.is_null_handle(CC.FindFirstQualifierInScope(sema, scope, nns))

    # derived-to-base conversion over an unambiguous public base
    @test f(I, "SemaChkBase")
    base = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaChkDerived")
    derived = CC.CXXRecordDecl(get_decl(f))
    base_ty = CC.getTypeDeclType(ctx, base)
    derived_ty = CC.getTypeDeclType(ctx, derived)
    rng = CC.getSourceRange(derived)
    @test CC.CheckDerivedToBaseConversion(sema, derived_ty, base_ty, loc, rng, true) == false

    # an unrelated pair is rejected by the wrapper, not by clang's own assertion
    plain_ty = CC.getTypeDeclType(ctx, plain)
    @test_throws AssertionError CC.CheckDerivedToBaseConversion(sema, plain_ty, base_ty, loc,
                                                                rng)

    # neither of the two `vf` declarations is marked `final`, so nothing is diagnosed
    base_vf = first(d for d in CC.decls(CC.castToDeclContext(base)) if d isa CC.CXXMethodDecl)
    derived_vf = first(d for d in CC.decls(CC.castToDeclContext(derived)) if d isa CC.CXXMethodDecl)
    @test CC.CheckIfOverriddenFunctionIsMarkedFinal(sema, derived_vf, base_vf) == false

    dispose(f)
    dispose(I)
end

@testset "Sema | evaluation-context state, module and type queries" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)

    CC.parse(I, """
    namespace SemaQ2NS { int inner; }
    struct SemaQ2Rec { int a; };
    int SemaQ2KnownVar = 0;
    void SemaQ2Ovl(int);
    void SemaQ2Ovl(double);
    struct SemaQ2Special {
        SemaQ2Special();
        SemaQ2Special(const SemaQ2Special &);
        SemaQ2Special &operator=(const SemaQ2Special &);
        ~SemaQ2Special();
        void semaQ2Ordinary();
    };
    struct SemaQ2Base { virtual void semaQ2Vf(); };
    struct SemaQ2Derived : SemaQ2Base { void semaQ2Vf(); };
    """)

    f = DeclFinder(I)

    # At translation-unit level nothing is being instantiated and the evaluation
    # context is the potentially-evaluated one Sema's constructor pushed.
    @test CC.inTemplateInstantiation(sema) == false
    @test CC.isUnevaluatedContext(sema) == false
    @test !(CC.isConstantEvaluatedContext(sema))
    @test !(CC.isAlwaysConstantEvaluatedContext(sema))
    @test !(CC.isImmediateFunctionContext(sema))
    @test !(CC.isCheckingDefaultArgumentOrInitializer(sema))
    @test !(CC.isUnexpandedParameterPackPermitted(sema))
    @test CC.isPreciseFPEnabled(sema)

    # no module scope is open in a translation unit that declares no module
    @test CC.is_null_handle(CC.getCurrentModule(sema))

    # `this` has no type outside a member function, but the walk up to the
    # function-level declaration context still runs
    @test CC.is_null_handle(CC.getCurrentThisType(sema))

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    float_ty = CC.get_qual_type(CC.jlty_to_clty(Float32, ctx))
    double_ty = CC.get_qual_type(CC.jlty_to_clty(Float64, ctx))
    ptr_ty = CC.getPointerType(ctx, int_ty)

    @test CC.isValidPointerAttrType(sema, ptr_ty)
    @test CC.isValidPointerAttrType(sema, int_ty) == false
    @test CC.isValidPointerAttrType(sema, int_ty, true) == false

    # a plain builtin type carries no attribute node at all
    @test CC.hasExplicitCallingConv(sema, int_ty) == false
    cc_attr = CC.getCallingConvAttributedType(sema, int_ty)
    @test cc_attr isa CC.AttributedType
    @test cc_attr.ptr == C_NULL

    # _Complex float -> _Complex double is the textbook complex promotion
    @test CC.IsComplexPromotion(sema, CC.getComplexType(ctx, float_ty),
                                CC.getComplexType(ctx, double_ty))
    @test CC.IsComplexPromotion(sema, float_ty, double_ty) == false

    # a name this testset itself declared, and one nothing declares
    @test CC.isKnownName(sema, "SemaQ2KnownVar")
    @test CC.isKnownName(sema, "SemaQ2NoSuchNameAnywhere") == false

    @test f(I, "SemaQ2NS")
    ns_ok, ns_correct = CC.isAcceptableNestedNameSpecifier(sema, get_decl(f))
    @test ns_ok
    @test ns_correct isa Bool
    @test f(I, "SemaQ2Rec")
    rec_nd = get_decl(f)
    @test first(CC.isAcceptableNestedNameSpecifier(sema, rec_nd))
    @test f(I, "SemaQ2KnownVar")
    @test first(CC.isAcceptableNestedNameSpecifier(sema, get_decl(f))) == false

    # comparing a declaration with itself keeps the equivalence walk from
    # reporting a mismatch through Sema's diagnostics
    rec = CC.CXXRecordDecl(rec_nd)
    @test CC.hasStructuralCompatLayout(sema, rec, rec)

    # the name is deliberately non-unique, so select the two functions by kind
    @test f(I, "SemaQ2Ovl")
    ovls = [CC.FunctionDecl(d)
            for d in CC.get_decls(f) if CC.getDeclKindName(d) == "Function"]
    @test length(ovls) >= 2
    @test CC.IsOverload(sema, ovls[1], ovls[2])
    @test !(CC.IsOverload(sema, ovls[1], ovls[1]))

    @test f(I, "SemaQ2Base")
    base = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaQ2Derived")
    derived = CC.CXXRecordDecl(get_decl(f))
    base_vf = first(d for d in CC.decls(CC.castToDeclContext(base)) if d isa CC.CXXMethodDecl)
    derived_vf = first(d for d in CC.decls(CC.castToDeclContext(derived))
                       if d isa CC.CXXMethodDecl)
    @test !(CC.IsOverride(sema, derived_vf, base_vf))
    @test !(CC.IsOverride(sema, derived_vf, base_vf, true))
    @test !(CC.IsOverload(sema, derived_vf, base_vf))

    # the four declared special members plus one ordinary method
    @test f(I, "SemaQ2Special")
    special = CC.CXXRecordDecl(get_decl(f))
    kinds = [CC.getSpecialMember(sema, m) for m in CC.getMethods(special)]
    @test !isempty(kinds)
    @test all(k isa CC.CXCXXSpecialMember for k in kinds)
    @test any(k != CC.CXCXXSpecialMember_CXXInvalid for k in kinds)

    dispose(f)
    dispose(I)
end

@testset "Sema | declaration, expression and trait node builders" begin
    # A throwaway interpreter: every builder below adds nodes to the ASTContext and
    # BuildStaticAssertDeclaration adds a declaration to the translation unit, so none of
    # this may leak into the interpreter the rest of the suite shares.
    I = create_interpreter(String[])
    CC.parse(I, """
             const int semaNodeEight = 8;
             const int semaNodeTwo = 2;
             int semaNodeArr[3];
             int semaNodeFn(int n) { return n; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    @test f(I, "semaNodeEight")
    eight_vd = CC.VarDecl(get_decl(f))
    eight = CC.getInit(eight_vd)
    @test f(I, "semaNodeTwo")
    two = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaNodeArr")
    arrty = CC.getType(CC.VarDecl(get_decl(f)))
    @test f(I, "semaNodeFn")
    fd = CC.FunctionDecl(get_decl(f))

    intty = CC.getType(eight)
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    arr_tsi = CC.getTrivialTypeSourceInfo(ctx, arrty, loc)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    no_scope = CC.Scope(C_NULL)

    # --- pipe types are OpenCL sugar, so only the shape is asserted ---
    read_pipe = CC.BuildReadPipeType(sema, intty, loc)
    write_pipe = CC.BuildWritePipeType(sema, intty, loc)
    @test read_pipe isa CC.QualType
    @test write_pipe isa CC.QualType
    @test read_pipe.ptr == C_NULL || CC.isPipeType(CC.getTypePtr(read_pipe))
    @test write_pipe.ptr == C_NULL || CC.isPipeType(CC.getTypePtr(write_pipe))

    # --- an implicit unnamed parameter carrying exactly the type it was handed ---
    pv = CC.BuildParmVarDeclForTypedef(sema, tu, loc, intty)
    @test pv isa CC.ParmVarDecl
    @test pv.ptr != C_NULL
    @test CC.getType(pv).ptr == intty.ptr

    # --- a reference to the parsed variable, round-tripped back to its declaration ---
    dre = CC.BuildDeclRefExpr(sema, eight_vd, intty, CC.LibClangEx.CXExprValueKind_VK_LValue, loc)
    @test dre isa CC.DeclRefExpr
    @test dre.ptr != C_NULL
    @test CC.getDecl(dre).ptr == eight_vd.ptr

    # --- operators through the overload-aware entry points, with no scope to look in ---
    neg = CC.BuildUnaryOp(sema, no_scope, loc, CC.LibClangEx.CXUnaryOperatorKind_UO_Minus, eight)
    @test neg isa CC.Expr_
    @test neg === nothing || CC.resolve(neg) isa CC.UnaryOperator

    add = CC.BuildBinOp(sema, no_scope, loc, CC.LibClangEx.CXBinaryOperatorKind_BO_Add, eight, two)
    @test add isa CC.Expr_
    @test add === nothing || CC.resolve(add) isa CC.BinaryOperator

    # --- a call of the parsed function, built from a reference to it ---
    callee = CC.BuildDeclRefExpr(sema, fd, CC.getType(fd),
                                 CC.LibClangEx.CXExprValueKind_VK_LValue, loc)
    call = CC.BuildCallExpr(sema, no_scope, callee, loc, CC.Expr_[eight], loc)
    @test call isa CC.Expr_
    @test call === nothing || CC.resolve(call) isa CC.CallExpr

    # --- the cast family: same source and destination type, so nothing is diagnosed ---
    cstyle = CC.BuildCStyleCastExpr(sema, loc, int_tsi, loc, two)
    @test cstyle isa CC.Expr_
    @test cstyle === nothing || CC.resolve(cstyle) isa CC.CStyleCastExpr

    functional = CC.BuildCXXFunctionalCastExpr(sema, int_tsi, intty, loc, two, loc)
    @test functional isa CC.Expr_

    constructed = CC.BuildCXXTypeConstructExpr(sema, int_tsi, loc, CC.Expr_[eight], loc)
    @test constructed isa CC.Expr_

    astype = CC.BuildAsTypeExpr(sema, eight, intty, loc, loc)
    @test astype isa CC.Expr_
    @test astype === nothing || CC.resolve(astype) isa CC.AsTypeExpr

    bitcast = CC.BuildBuiltinBitCastExpr(sema, loc, int_tsi, eight, loc)
    @test bitcast isa CC.Expr_

    # --- the trait families ---
    tt = CC.BuildTypeTrait(sema, CC.LibClangEx.CXTypeTrait_UTT_IsPOD, loc,
                           CC.TypeSourceInfo[int_tsi], loc)
    @test tt isa CC.Expr_
    @test tt === nothing || CC.resolve(tt) isa CC.TypeTraitExpr
    # the wrapper rejects the empty argument list clang would index into
    @test_throws AssertionError CC.BuildTypeTrait(sema, CC.LibClangEx.CXTypeTrait_UTT_IsPOD, loc,
                                                  CC.TypeSourceInfo[], loc)

    rank = CC.BuildArrayTypeTrait(sema, CC.LibClangEx.CXArrayTypeTrait_ATT_ArrayRank, loc, arr_tsi,
                                  CC.Expr_(C_NULL), loc)
    @test rank isa CC.Expr_
    @test rank === nothing || CC.resolve(rank) isa CC.ArrayTypeTraitExpr
    # __array_extent evaluates its dimension expression, so a null one is rejected here
    @test_throws AssertionError CC.BuildArrayTypeTrait(sema,
                                                       CC.LibClangEx.CXArrayTypeTrait_ATT_ArrayExtent,
                                                       loc, arr_tsi, CC.Expr_(C_NULL), loc)

    et = CC.BuildExpressionTrait(sema, CC.LibClangEx.CXExpressionTrait_ET_IsRValueExpr, loc, eight,
                                 loc)
    @test et isa CC.Expr_
    @test et === nothing || CC.resolve(et) isa CC.ExpressionTraitExpr

    # --- the remaining node factories ---
    fold = CC.BuildEmptyCXXFoldExpr(sema, loc, CC.LibClangEx.CXBinaryOperatorKind_BO_LAnd)
    @test fold isa CC.Expr_
    @test fold === nothing || CC.getType(fold) isa CC.QualType

    mte = CC.CreateMaterializeTemporaryExpr(sema, intty, eight, false)
    @test mte isa CC.MaterializeTemporaryExpr
    @test mte.ptr != C_NULL
    @test CC.getSubExpr(mte).ptr == eight.ptr

    # RecoveryExpr construction is gated on LangOptions::RecoveryAST, so both outcomes are
    # legal and only the discriminated shape is asserted.
    rec = CC.CreateRecoveryExpr(sema, loc, loc, CC.Expr_[eight])
    @test rec === nothing || CC.resolve(rec) isa CC.RecoveryExpr

    # --- a static_assert over an already-constant condition, no message (C++17 form) ---
    sad = CC.BuildStaticAssertDeclaration(sema, loc, eight, CC.Expr_(C_NULL), loc)
    @test sad isa CC.Decl
    @test sad.ptr == C_NULL || CC.getDeclKindName(sad) == "StaticAssert"

    # --- an integral template argument re-expressed as an expression ---
    gv = CC.LLVM.GenericValue(CC.MakeIntValue(ctx, 7, intty))
    targ = CC.TemplateArgument(ctx, gv, intty)
    CC.LLVM.dispose(gv)
    @test CC.getKind(targ) == CC.LibClangEx.CXTemplateArgument_Integral
    nttp = CC.BuildExpressionFromNonTypeTemplateArgument(sema, targ, loc)
    @test nttp isa CC.Expr_
    @test nttp === nothing || CC.getType(nttp) isa CC.QualType
    # a type argument would reach clang's llvm_unreachable, so the wrapper stops it here
    @test_throws AssertionError CC.BuildExpressionFromNonTypeTemplateArgument(sema,
                                                                              CC.TemplateArgument(intty),
                                                                              loc)

    dispose(f)
    dispose(I)
end

@testset "Sema | Check/Verify entry points over types, declarations and expressions" begin
    # Every check below diagnoses what it rejects, and CheckEquivalentExceptionSpec can
    # complete a missing exception specification, so this runs on a throwaway interpreter
    # instead of the one the rest of the suite shares.
    I = create_interpreter(String[])
    CC.parse(I, """
             namespace SemaChk2NS {
             struct Vec2 { int x; };
             Vec2 operator+(const Vec2 &a, const Vec2 &b);
             long double operator""_semachk2(long double v);
             }
             struct SemaChk2Base { virtual void vf(); };
             struct SemaChk2Derived : SemaChk2Base { void vf(); };
             constexpr int SemaChk2Cx(int n) { return n + 1; }
             void SemaChk2Fn();
             const int semaChk2Eight = 8;
             """)
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    rng = CC.SourceRange(loc, loc)
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_ty, loc)

    # `int` is well-formed for each of these, so none of them reaches its diagnostic
    @test CC.CheckQualifiedFunctionForTypeId(sema, int_ty, loc) == false
    @test CC.CheckAllocatedType(sema, int_ty, loc, rng) == false
    @test CC.CheckEnumUnderlyingType(sema, int_tsi) == false

    ntt = CC.CheckNonTypeTemplateParameterType(sema, int_ty, loc)
    @test ntt isa CC.QualType
    @test ntt.ptr != C_NULL

    # the in/out type is adjusted only for array and function types, so it round-trips
    bad, adjusted = CC.CheckSpecifiedExceptionType(sema, int_ty, rng)
    @test bad == false
    @test adjusted isa CC.QualType
    @test adjusted.ptr == int_ty.ptr

    # assignment constraints are a pure query over a pair of types
    ptr_ty = CC.BuildPointerType(sema, int_ty, loc)
    @test CC.CheckAssignmentConstraints(sema, loc, int_ty, int_ty) ==
          CC.CXAssignConvertType_Compatible
    @test CC.CheckAssignmentConstraints(sema, loc, int_ty, ptr_ty) !=
          CC.CXAssignConvertType_Compatible

    # clang itself ran all three override checks while parsing and accepted the override
    @test f(I, "SemaChk2Base")
    base = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaChk2Derived")
    derived = CC.CXXRecordDecl(get_decl(f))
    base_vf = first(d for d in CC.decls(CC.castToDeclContext(base)) if d isa CC.CXXMethodDecl)
    derived_vf = first(d for d in CC.decls(CC.castToDeclContext(derived)) if d isa CC.CXXMethodDecl)
    @test CC.CheckOverridingFunctionReturnType(sema, derived_vf, base_vf) == false
    @test CC.CheckOverridingFunctionExceptionSpec(sema, derived_vf, base_vf) == false
    @test CC.CheckOverridingFunctionAttributes(sema, derived_vf, base_vf) == false

    # nothing is attached to a named module, and a declaration matches its own spec
    @test f(I, "SemaChk2Fn")
    fn = CC.FunctionDecl(get_decl(f))
    @test CC.CheckRedeclarationModuleOwnership(sema, fn, fn) == false
    @test CC.CheckRedeclarationExported(sema, fn, fn) == false
    @test CC.CheckRedeclarationInModule(sema, fn, fn) == false
    @test CC.CheckEquivalentExceptionSpec(sema, fn, fn) == false

    # CheckValid is the non-diagnosing mode; the wrapper rejects the bodyless declaration
    # clang would assert on
    @test f(I, "SemaChk2Cx")
    cx = CC.FunctionDecl(get_decl(f))
    @test CC.hasBody(cx)
    @test CC.CheckConstexprFunctionDefinition(sema, cx)
    @test CC.CheckConstexprFunctionDefinition(sema, cx, CC.CXCheckConstexprKind_CheckValid)
    @test_throws AssertionError CC.CheckConstexprFunctionDefinition(sema, fn)

    # the two operator declarations, reached through the namespace's own decl context
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    is_chk_ns(d) = d isa CC.NamespaceDecl && CC.getNameAsString(d) == "SemaChk2NS"
    ns = first(d for d in CC.decls(tu) if is_chk_ns(d))
    ns_decls = CC.decls(CC.castToDeclContext(ns))
    is_lit_op(d) = d isa CC.FunctionDecl &&
                   CC.getNameKind(CC.getDeclName(d)) == CC.CXDeclarationName_CXXLiteralOperatorName
    plus = first(d for d in ns_decls if d isa CC.FunctionDecl && CC.isOverloadedOperator(d))
    lit = first(d for d in ns_decls if is_lit_op(d))
    @test CC.CheckOverloadedOperatorDeclaration(sema, plus) == false
    @test CC.CheckLiteralOperatorDeclaration(sema, lit) == false

    # an ordinary function satisfies neither precondition, so the wrappers reject it
    @test_throws AssertionError CC.CheckOverloadedOperatorDeclaration(sema, fn)
    @test_throws AssertionError CC.CheckLiteralOperatorDeclaration(sema, fn)

    # expression-level checks over a real integer-literal initializer
    @test f(I, "semaChk2Eight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))
    @test eight isa CC.Expr_
    @test CC.CheckPlaceholderExpr(sema, eight) isa CC.Expr_
    @test CC.CheckForConstantInitializer(sema, eight, int_ty) == false
    @test CC.CheckBooleanCondition(sema, loc, eight) isa CC.Expr_
    @test CC.VerifyIntegerConstantExpression(sema, eight) isa CC.Expr_
    folded = CC.VerifyIntegerConstantExpression(sema, eight, CC.CXAllowFoldKind_AllowFold)
    @test folded isa CC.Expr_

    dispose(f)
    dispose(I)
end

@testset "Sema | expression conversions and the remaining ODR-use marking" begin
    # A throwaway interpreter: the conversions add cast nodes to the ASTContext and the
    # Mark* calls record ODR uses, so none of it may leak into the shared interpreter.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaConvBase { int b; };
             struct SemaConvRec : SemaConvBase { int m; int get() const { return m; } };
             struct SemaConvVirt : virtual SemaConvBase { int v; };
             int semaConvGlobal = 3;
             int semaConvFn(SemaConvRec r) { return r.m + r.get() + semaConvGlobal; }
             const int semaConvEight = 8;
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    loc = CC.get_main_file_begin_loc(CC.getSourceManager(sema))
    f = DeclFinder(I)

    @test f(I, "semaConvFn")
    fd = CC.FunctionDecl(get_decl(f))
    @test f(I, "SemaConvRec")
    rec = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaConvVirt")
    virt = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "semaConvEight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))

    # Operands taken straight out of the parsed body: a field access, a member-function
    # access, the object expression they share, and a reference to a namespace-scope
    # variable. The DeclRefExpr naming the *parameter* is deliberately not marked — marking
    # a local asks Sema to capture it, which walks a function-scope stack that is empty
    # once parsing has finished.
    nodes = CC.subtree(CC.getBody(fd))
    members = filter(n -> n isa CC.MemberExpr, nodes)
    field_ref = first(m for m in members if CC.getDeclKindName(CC.getMemberDecl(m)) == "Field")
    method_ref = first(m for m in members
                       if CC.getDeclKindName(CC.getMemberDecl(m)) == "CXXMethod")
    obj = CC.getBase(field_ref)
    field = CC.getMemberDecl(field_ref)
    # a container accessor types its carrier at the container's element class, so the
    # method has to be re-carried before a CXXMethodDecl-level wrapper accepts it
    method = CC.CXXMethodDecl(CC.getMemberDecl(method_ref))
    global_ref = first(n for n in nodes
                       if n isa CC.DeclRefExpr && CC.getDeclKindName(CC.getDecl(n)) == "Var")

    # --- ODR-use marking over expressions ---
    @test CC.MarkDeclRefReferenced(sema, global_ref) === nothing
    @test CC.MarkDeclRefReferenced(sema, global_ref, obj) === nothing
    @test CC.MarkMemberReferenced(sema, field_ref) === nothing
    @test CC.MarkMemberReferenced(sema, method_ref) === nothing
    @test CC.MarkDeclarationsReferencedInExpr(sema, global_ref) === nothing
    @test CC.MarkDeclarationsReferencedInExpr(sema, field_ref, true) === nothing
    @test CC.MarkDeclarationsReferencedInExpr(sema, field_ref, true, [obj]) === nothing
    @test CC.MarkTypoCorrectedFunctionDefinition(sema, fd) === nothing

    # SemaConvRec walks an empty virtual-base range; SemaConvVirt exercises the loop body
    @test CC.MarkVirtualBaseDestructorsReferenced(sema, loc, rec) === nothing
    @test CC.MarkVirtualBaseDestructorsReferenced(sema, loc, virt) === nothing

    # --- which template parameters an expression names ---
    used = CC.MarkUsedTemplateParameters(sema, eight, 1)
    @test used isa Vector{Bool}
    @test length(used) == 1
    @test CC.MarkUsedTemplateParameters(sema, eight, 1, true) isa Vector{Bool}
    @test length(CC.MarkUsedTemplateParameters(sema, eight, 0)) == 0
    @test_throws AssertionError CC.MarkUsedTemplateParameters(sema, eight, 1, false, -1)

    # --- conversions; a valid ExprResult surfaces as an Expr_, an invalid one as nothing ---
    tobool = CC.PerformContextuallyConvertToBool(sema, eight)
    @test tobool isa Union{Nothing,CC.Expr_}

    double_ty = CC.get_qual_type(CC.jlty_to_clty(Float64, ctx))
    conv = CC.PerformImplicitConversion(sema, eight, double_ty,
                                        CC.LibClangEx.CXAssignmentAction_AA_Converting)
    @test conv isa Union{Nothing,CC.Expr_}

    base_conv = CC.PerformMemberExprBaseConversion(sema, obj, false)
    @test base_conv isa Union{Nothing,CC.Expr_}

    # `obj` already designates the class that declares `field`, so this is the identity
    # case of the object-member conversion rather than a derived-to-base one
    obj_conv = CC.PerformObjectMemberConversion(sema, obj, nothing, field, field)
    @test obj_conv isa Union{Nothing,CC.Expr_}

    @test CC.isImplicitObjectMemberFunction(method)
    this_arg = CC.PerformImplicitObjectArgumentInitialization(sema, obj, nothing, method,
                                                              method)
    @test this_arg isa Union{Nothing,CC.Expr_}

    qual = CC.PerformQualificationConversion(sema, eight, CC.getType(eight))
    @test qual isa Union{Nothing,CC.Expr_}
    qual_cast = CC.PerformQualificationConversion(sema, eight, CC.getType(eight),
                                                  CC.LibClangEx.CXExprValueKind_VK_PRValue,
                                                  CC.LibClangEx.CXCheckedConversionKind_CCK_CStyleCast)
    @test qual_cast isa Union{Nothing,CC.Expr_}

    dispose(f)
    dispose(I)
end

@testset "Sema | declaration helpers, implicit members and pragma-driven attributes" begin
    # Every call below mutates the AST or Sema's bookkeeping, so this testset owns its own
    # interpreter and disposes it again rather than touching a shared one.
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    CC.parse(I, """
    struct SemaDclBase { virtual void vm(); virtual void bm(); };
    struct SemaDclDerived : SemaDclBase { void vm(); void plain(int); };
    struct SemaDclAgg { int a; };
    struct SemaDclDtor { ~SemaDclDtor(); };
    struct SemaDclDefault { SemaDclDefault(); };
    struct SemaDclDelete { void gone(); };
    template <typename T> struct SemaDclGuide { SemaDclGuide(T); };
    void SemaDclFn(int p);
    int SemaDclInit = 7;
    """)

    f = DeclFinder(I)

    # every lookup runs before the first mutation: declaring implicit members and deduction
    # guides below adds names this same finder would otherwise have to disambiguate
    @test f(I, "SemaDclDerived")
    derived = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaDclAgg")
    agg = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaDclDtor")
    dtor_rec = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaDclDefault")
    default_rec = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaDclDelete")
    delete_rec = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaDclGuide")
    guide_named = first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate")
    guide_tmpl = CC.ClassTemplateDecl(guide_named)
    @test f(I, "SemaDclFn")
    fn = CC.FunctionDecl(get_decl(f))
    @test f(I, "SemaDclInit")
    init = CC.getInit(CC.VarDecl(get_decl(f)))
    @test init isa CC.Expr_

    # `plain` names nothing in the base, so no overridden method is wired up. Its override
    # list must still be empty going in — clang appends without de-duplicating.
    plain_m = first(d
                    for d in CC.decls(CC.castToDeclContext(derived))
                    if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "plain")
    @test CC.size_overridden_methods(plain_m) == 0
    @test CC.AddOverriddenMethods(sema, derived, plain_m) == false

    # an already-typed initializer becomes the parameter's default argument
    param = CC.getParamDecl(fn, 0)
    @test param isa CC.ParmVarDecl
    @test !CC.hasDefaultArg(param)
    @test CC.SetParamDefaultArgument(sema, param, init, loc) === nothing
    @test CC.hasDefaultArg(param)

    # `= delete` and `= default` applied after the fact, each read back through its predicate
    gone = first(d
                 for d in CC.decls(CC.castToDeclContext(delete_rec))
                 if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "gone")
    @test !CC.isDeleted(gone)
    @test CC.SetDeclDeleted(sema, gone, loc) === nothing
    @test CC.isDeleted(gone)

    ctor = first(d
                 for d in CC.decls(CC.castToDeclContext(default_rec))
                 if d isa CC.CXXConstructorDecl && !CC.isImplicit(d))
    @test !CC.isDefaulted(ctor)
    @test CC.SetDeclDefaulted(sema, ctor, loc) === nothing
    @test CC.isDefaulted(ctor)

    # `SemaDclFn` is neither a builtin nor a name in clang's libc knowledge base, so this
    # adds nothing; the call is exercised for its totality
    @test CC.AddKnownFunctionAttributes(sema, fn) === nothing

    # a user-declared destructor with no exception specification gets the implicit one
    dtor = CC.getDestructor(dtor_rec)
    @test dtor isa CC.CXXDestructorDecl
    @test CC.AdjustDestructorExceptionSpec(sema, dtor) === nothing
    dtor_ty = CC.resolve(CC.getTypePtr(CC.getType(dtor)))
    @test dtor_ty isa CC.FunctionProtoType
    @test CC.getExceptionSpecType(dtor_ty) != CC.CXExceptionSpecificationType_EST_None

    # the parser's end-of-class hook declares only what overload resolution already needs;
    # forcing the rest closes all six gates
    @test CC.AddImplicitlyDeclaredMembersToClass(sema, agg) === nothing
    @test CC.ForceDeclarationOfImplicitMembers(sema, agg) === nothing
    @test !CC.needsImplicitDefaultConstructor(agg)
    @test !CC.needsImplicitCopyConstructor(agg)
    @test !CC.needsImplicitMoveConstructor(agg)
    @test !CC.needsImplicitCopyAssignment(agg)
    @test !CC.needsImplicitMoveAssignment(agg)
    @test !CC.needsImplicitDestructor(agg)

    @test !(CC.DefineUsedVTables(sema))

    # with no previous declaration the lexical specifier wins outright
    fld = first(d for d in CC.decls(CC.castToDeclContext(agg)) if d isa CC.FieldDecl)
    @test CC.SetMemberAccessSpecifier(sema, fld, nothing,
                                      CC.CXAccessSpecifier_AS_protected) == false
    @test CC.getAccess(fld) == CC.CXAccessSpecifier_AS_protected

    # a class template unwraps to its templated CXXRecordDecl; a plain function does not move
    td, inner = CC.AdjustDeclIfTemplate(sema, guide_tmpl)
    @test td isa CC.TemplateDecl
    @test td.ptr != C_NULL
    @test CC.getDeclKindName(inner) == "CXXRecord"
    td2, inner2 = CC.AdjustDeclIfTemplate(sema, fn)
    @test td2.ptr == C_NULL
    @test inner2.ptr == fn.ptr

    # nothing in this translation unit uses CTAD, so the guides only exist after this call
    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    @test CC.DeclareImplicitDeductionGuides(sema, guide_tmpl, loc) === nothing
    guides = [CC.resolve(CC.getTemplatedDecl(d))
              for d in CC.decls(tu_dc) if d isa CC.FunctionTemplateDecl]
    @test any(g -> g isa CC.CXXDeductionGuideDecl, guides)

    # no pragma is in scope here, so each of these is a defined no-op
    @test CC.AddAlignmentAttributesForRecord(sema, agg) === nothing
    @test CC.AddMsStructLayoutForRecord(sema, agg) === nothing
    @test CC.AddPushedVisibilityAttribute(sema, fn) === nothing
    @test CC.AddRangeBasedOptnone(sema, fn) === nothing
    @test CC.AddSectionMSAllocText(sema, fn) === nothing
    @test CC.AddImplicitMSFunctionNoBuiltinAttr(sema, fn) === nothing

    # `optnone` is added unconditionally: nothing on `SemaDclFn` conflicts with it
    @test CC.AddOptnoneAttributeIfNoConflicts(sema, fn, loc) === nothing
    @test CC.hasAttrs(fn)

    dispose(f)
    dispose(I)
end

@testset "Sema | module scope, macro spelling and type-relationship queries" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaMiscBase { int b; };
             struct SemaMiscDerived : SemaMiscBase { int d; };
             struct SemaMiscRec { int fld; };
             void sema_misc_one(int a);
             void sema_misc_two(int a);
             void sema_misc_three(double a);
             const char *sema_misc_fmt = "%s";
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # the interpreter parses no module declaration, so no module scope is ever open
    @test CC.currentModuleIsImplementation(sema) == false
    @test CC.currentModuleIsHeaderUnit(sema) == false
    @test CC.forRedeclarationInCurContext(sema) isa CC.CXRedeclarationKind

    # a file location is not a macro location, so the spelling probe declines it
    @test CC.findMacroSpelling(sema, loc, "SEMA_MISC_NO_SUCH_MACRO") === nothing

    # this translation unit declares nothing at block scope with C language linkage,
    # so the side table is empty and the carrier comes back holding NULL
    extc_name = CC.DeclarationName(CC.getIdentifierInfo(pp, "sema_misc_one"))
    @test CC.is_null_handle(CC.findLocallyScopedExternCDecl(sema, extc_name))

    # a handler always matches an exception object of its own type
    @test CC.handlerCanCatch(sema, int_ty, int_ty)

    # prototypes with identical parameter lists compare equal; a differing one does not
    @test f(I, "sema_misc_one")
    one_fd = CC.FunctionDecl(get_decl(f))
    one_ty = CC.resolve(CC.getTypePtr(CC.getType(one_fd)))
    @test f(I, "sema_misc_two")
    two_fd = CC.FunctionDecl(get_decl(f))
    two_ty = CC.resolve(CC.getTypePtr(CC.getType(two_fd)))
    @test f(I, "sema_misc_three")
    three_fd = CC.FunctionDecl(get_decl(f))
    three_ty = CC.resolve(CC.getTypePtr(CC.getType(three_fd)))
    @test one_ty isa CC.FunctionProtoType
    @test three_ty isa CC.FunctionProtoType

    eq12, pos12 = CC.FunctionParamTypesAreEqual(sema, one_ty, two_ty)
    @test eq12
    @test pos12 isa Integer
    eq13, pos13 = CC.FunctionParamTypesAreEqual(sema, one_ty, three_ty)
    @test eq13 == false
    @test pos13 isa Integer
    @test CC.FunctionParamTypesAreEqual(sema, one_ty, two_ty, true)[1] isa Bool

    eqn12, posn12 = CC.FunctionNonObjectParamTypesAreEqual(sema, one_fd, two_fd)
    @test eqn12
    @test posn12 isa Integer
    @test CC.FunctionNonObjectParamTypesAreEqual(sema, one_fd, three_fd)[1] == false

    # a plain function declaration, queried without letting clang diagnose
    @test CC.checkAddressOfFunctionIsAvailable(sema, one_fd)
    @test CC.shouldLinkDependentDeclWithPrevious(sema, one_fd, two_fd)

    # an already-unqualified non-function type is returned unchanged
    @test CC.ExtractUnqualifiedFunctionType(sema, int_ty).ptr == int_ty.ptr
    fn_qt = CC.getType(one_fd)
    extracted = CC.ExtractUnqualifiedFunctionType(sema, fn_qt)
    @test extracted isa CC.QualType
    @test CC.isFunctionProtoType(CC.getTypePtr(extracted))

    # the unique field of a record, reached by identifier
    @test f(I, "SemaMiscRec")
    rec = CC.CXXRecordDecl(get_decl(f))
    fld = CC.tryLookupUnambiguousFieldDecl(sema, rec, CC.getIdentifierInfo(pp, "fld"))
    @test fld isa CC.ValueDecl
    missing_fld = CC.tryLookupUnambiguousFieldDecl(sema, rec,
                                                   CC.getIdentifierInfo(pp, "sema_misc_no_fld"))
    @test missing_fld.ptr == C_NULL

    # adjusting a prototype against itself still yields a prototype
    adjusted = CC.adjustCCAndNoReturn(sema, fn_qt, fn_qt)
    @test adjusted isa CC.QualType
    @test CC.isFunctionProtoType(CC.getTypePtr(adjusted))
    # a non-prototype operand is rejected by the wrapper, not by clang's castAs<>
    @test_throws AssertionError CC.adjustCCAndNoReturn(sema, int_ty, fn_qt)
    @test_throws AssertionError CC.adjustCCAndNoReturn(sema, fn_qt, int_ty)

    # int -> bool is the integral-to-boolean conversion
    @test CC.ScalarTypeToBooleanCastKind(int_ty) == CC.CXCastKind_CK_IntegralToBoolean
    @test f(I, "SemaMiscBase")
    base = CC.CXXRecordDecl(get_decl(f))
    base_ty = CC.getTypeDeclType(ctx, base)
    # a class type is not scalar, and the wrapper rejects it before clang's assert
    @test_throws AssertionError CC.ScalarTypeToBooleanCastKind(base_ty)

    # the signed companion of a generic 4 x int vector is itself a vector type
    vec_ty = CC.getVectorType(ctx, int_ty, 4, CC.CXVectorKind_Generic)
    signed_vec = CC.GetSignedVectorType(sema, vec_ty)
    @test signed_vec isa CC.QualType
    @test CC.isVectorType(CC.getTypePtr(signed_vec))
    @test_throws AssertionError CC.GetSignedVectorType(sema, int_ty)

    # a type is reference-compatible with itself
    same_res, same_conv = CC.CompareReferenceRelationship(sema, loc, int_ty, int_ty)
    @test same_res == CC.CXReferenceCompareResult_Ref_Compatible
    @test same_conv isa Integer
    @test f(I, "SemaMiscDerived")
    derived_ty = CC.getTypeDeclType(ctx, CC.CXXRecordDecl(get_decl(f)))
    bd_res, bd_conv = CC.CompareReferenceRelationship(sema, loc, base_ty, derived_ty)
    @test bd_res in (CC.CXReferenceCompareResult_Ref_Incompatible,
                     CC.CXReferenceCompareResult_Ref_Related,
                     CC.CXReferenceCompareResult_Ref_Compatible)
    @test bd_conv isa Integer
    # neither operand may itself be a reference type
    ref_ty = CC.getLValueReferenceType(ctx, int_ty)
    @test_throws AssertionError CC.CompareReferenceRelationship(sema, loc, ref_ty, int_ty)
    @test_throws AssertionError CC.CompareReferenceRelationship(sema, loc, int_ty, ref_ty)

    # a narrow format-string literal, reached through the initializer's implicit cast
    @test f(I, "sema_misc_fmt")
    fmt = CC.resolve(CC.IgnoreParenImpCasts(CC.getInit(CC.VarDecl(get_decl(f)))))
    @test fmt isa CC.StringLiteral
    @test CC.getCharByteWidth(fmt) == 1
    @test CC.FormatStringHasSArg(sema, fmt)

    # the arity check is the pure arithmetic spelled out in Sema.h's in-class body
    @test CC.TooManyArguments(1, 2)
    @test CC.TooManyArguments(2, 1) == false
    @test CC.TooManyArguments(2, 2) == false
    @test CC.TooManyArguments(2, 0, true) == false
    @test CC.TooManyArguments(2, 2, true)
    @test CC.TooManyArguments(3, 2, true) == false

    dispose(f)
    dispose(I)
end

@testset "Sema | type relationships, module visibility and literal locations" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaQ3Rec { int fld; };
             template <typename T> struct SemaQ3Tmpl { T v; };
             void sema_q3_one(int a);
             void sema_q3_two(int a);
             void sema_q3_three(double a);
             int sema_q3_var = 7;
             const char *sema_q3_str = "abc";
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    short_ty = CC.get_qual_type(CC.jlty_to_clty(Int16, ctx))

    # the interpreter always compiles C++, which is what Sema's std:: lookups assert on
    @test CC.getCPlusPlus(CC.getLangOpts(sema))

    # a plain int variable and a plain function both have types that carry linkage
    @test f(I, "sema_q3_var")
    var_nd = get_decl(f)
    var_d = CC.VarDecl(var_nd)
    @test CC.isExternalWithNoLinkageType(sema, var_d) == false
    @test f(I, "sema_q3_one")
    one_fd = CC.FunctionDecl(get_decl(f))
    @test CC.isExternalWithNoLinkageType(sema, one_fd) == false

    # visibility and reachability of a declaration, and of its definition; the
    # answers depend on the module state of the host build, so assert the shape
    @test CC.hasVisibleDeclaration(sema, var_nd)
    @test CC.hasReachableDeclaration(sema, var_nd)
    vis, vis_sugg = CC.hasVisibleDefinition(sema, var_nd)
    @test vis isa Bool
    @test vis_sugg isa CC.NamedDecl
    vis2, _ = CC.hasVisibleDefinition(sema, var_nd, true)
    @test vis2 isa Bool
    rch, rch_sugg = CC.hasReachableDefinition(sema, var_nd)
    @test rch isa Bool
    @test rch_sugg isa CC.NamedDecl

    # short -> int is the textbook integral promotion; the expression argument is
    # optional and is only consulted for bit-fields
    @test CC.IsIntegralPromotion(sema, nothing, short_ty, int_ty)
    init = CC.getInit(var_d)
    @test init isa CC.Expr_
    @test !(CC.IsIntegralPromotion(sema, init, int_ty, int_ty))

    # int is not a block pointer, so no block-pointer conversion exists
    okb, convb = CC.IsBlockPointerConversion(sema, int_ty, int_ty)
    @test okb == false
    @test convb isa CC.QualType

    okq, lifetime = CC.IsQualificationConversion(sema, CC.getPointerType(ctx, int_ty),
                                                 CC.getPointerType(ctx, int_ty))
    @test okq isa Bool
    @test lifetime isa Bool

    okf, resf = CC.IsFunctionConversion(sema, int_ty, int_ty)
    @test okf isa Bool
    @test resf isa CC.QualType

    # two prototypes spelled the same have the same canonical function type
    @test f(I, "sema_q3_two")
    two_fd = CC.FunctionDecl(get_decl(f))
    @test f(I, "sema_q3_three")
    three_fd = CC.FunctionDecl(get_decl(f))
    @test CC.isSameOrCompatibleFunctionType(sema, CC.getType(one_fd), CC.getType(two_fd))
    @test CC.isSameOrCompatibleFunctionType(sema, CC.getType(one_fd),
                                            CC.getType(three_fd)) == false

    rng = CC.getExprRange(sema, init)
    @test rng isa CC.SourceRange
    @test !CC.is_null_handle(rng.begin_loc)
    @test !CC.is_null_handle(rng.end_loc)

    # no <initializer_list> is reachable here, so int is certainly not one
    is_ilist, ilist_elt = CC.isStdInitializerList(sema, int_ty)
    @test is_ilist == false
    @test ilist_elt isa CC.QualType

    # a class template names a template; an ordinary variable does not
    @test f(I, "SemaQ3Tmpl")
    tmpl = first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate")
    @test CC.getAsTemplateNameDecl(tmpl).ptr != C_NULL
    @test CC.getAsTemplateNameDecl(var_nd).ptr == C_NULL

    # nothing in this translation unit turns optimization off
    @test CC.is_null_handle(CC.getOptimizeOffPragmaLocation(sema))

    # int is a POD, hence always valid through an ellipsis
    @test CC.isValidVarArgType(sema, int_ty) == CC.CXVarArgKind_VAK_Valid

    # an integer literal has no c_str member
    @test CC.hasCStrMethod(sema, init) == false

    # generic vectors of int: identical ones match, a shorter one does not
    v4 = CC.getVectorType(ctx, int_ty, 4, CC.CXVectorKind_Generic)
    v2 = CC.getVectorType(ctx, int_ty, 2, CC.CXVectorKind_Generic)
    @test CC.areVectorTypesSameSize(sema, v4, v4)
    @test CC.areVectorTypesSameSize(sema, v4, v2) == false
    @test CC.areLaxCompatibleVectorTypes(sema, v4, v4)
    @test !(CC.isLaxVectorConversion(sema, v4, v2))
    # the three vector predicates all restate clang's "one operand is a vector" assert
    @test_throws AssertionError CC.areVectorTypesSameSize(sema, int_ty, int_ty)
    @test_throws AssertionError CC.areLaxCompatibleVectorTypes(sema, int_ty, int_ty)
    @test_throws AssertionError CC.isLaxVectorConversion(sema, int_ty, int_ty)

    # the initializer's string literal, reached through its implicit cast
    @test f(I, "sema_q3_str")
    str = CC.resolve(CC.IgnoreParenImpCasts(CC.getInit(CC.VarDecl(get_decl(f)))))
    @test str isa CC.StringLiteral
    @test CC.getCharByteWidth(str) == 1
    @test !CC.is_null_handle(CC.getLocationOfStringLiteralByte(sema, str, 0))
    @test_throws AssertionError CC.getLocationOfStringLiteralByte(sema, str,
                                                                  CC.getByteLength(str))

    dispose(f)
    dispose(I)
end

@testset "Sema | name, offsetof and instantiation-rebuild node builders" begin
    # A throwaway interpreter: every builder below adds nodes to the ASTContext and
    # RebuildTemplateParamsInCurrentInstantiation rewrites a template parameter's type in
    # place, so none of this may leak into the interpreter the rest of the suite shares.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaB3Rec { int a; double b; };
             const int semaB3Eight = 8;
             int semaB3Fn(int n) { return n; }
             template <typename T> T semaB3Tmpl(T t) { return t; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_ty, loc)

    @test f(I, "semaB3Eight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))

    # --- a Sema-checked prototype, whose parameter list comes back adjusted ---
    fn_ty, adjusted = CC.BuildFunctionType(sema, int_ty, CC.QualType[int_ty], loc)
    @test fn_ty isa CC.QualType
    @test CC.resolve(CC.getTypePtr(fn_ty)) isa CC.FunctionProtoType
    @test length(adjusted) == 1
    @test adjusted[1] isa CC.QualType
    var_ty, var_params = CC.BuildFunctionType(sema, int_ty, CC.QualType[int_ty], loc,
                                              CC.DeclarationName(C_NULL), true)
    @test CC.resolve(CC.getTypePtr(var_ty)) isa CC.FunctionProtoType
    @test length(var_params) == 1
    # an empty parameter list is a prototype too, not an unprototyped function type
    nullary, no_params = CC.BuildFunctionType(sema, int_ty, CC.QualType[], loc)
    @test CC.resolve(CC.getTypePtr(nullary)) isa CC.FunctionProtoType
    @test isempty(no_params)

    # --- a converted constant expression in a template-argument context ---
    cce = CC.BuildConvertedConstantExpression(sema, eight, int_ty,
                                              CC.CXCCEKind_CCEK_TemplateArg)
    @test cce isa CC.Expr_
    @test CC.getType(cce) isa CC.QualType

    # --- __builtin_offsetof(SemaB3Rec, b) ---
    @test f(I, "SemaB3Rec")
    rec_ty = CC.getTypeDeclType(ctx, CC.CXXRecordDecl(get_decl(f)))
    rec_tsi = CC.getTrivialTypeSourceInfo(ctx, rec_ty, loc)
    b_ii = CC.getIdentifierInfo(pp, "b")
    no_index = CC.Expr_(C_NULL)
    off = CC.BuildBuiltinOffsetOf(sema, loc, rec_tsi, [loc], [loc], [false], [b_ii],
                                  [no_index], loc)
    @test off isa CC.Expr_
    @test CC.resolve(off) isa CC.OffsetOfExpr
    # the wrapper rejects the three component shapes clang assumes away
    @test_throws AssertionError CC.BuildBuiltinOffsetOf(sema, loc, rec_tsi,
                                                        CC.SourceLocation[],
                                                        CC.SourceLocation[], Bool[],
                                                        CC.IdentifierInfo[], CC.Expr_[], loc)
    @test_throws AssertionError CC.BuildBuiltinOffsetOf(sema, loc, rec_tsi, [loc], [loc],
                                                        [true], [b_ii], [no_index], loc)
    @test_throws AssertionError CC.BuildBuiltinOffsetOf(sema, loc, int_tsi, [loc], [loc],
                                                        [false], [b_ii], [no_index], loc)

    # --- __builtin_LINE(), whose result type the caller supplies ---
    sl = CC.BuildSourceLocExpr(sema, CC.CXSourceLocIdentKind_Line, int_ty, loc, loc, tu)
    @test sl isa CC.Expr_
    @test CC.resolve(sl) isa CC.SourceLocExpr

    # --- name expressions built from a lookup result ---
    ss = CC.CXXScopeSpec()
    fn_name = CC.DeclarationName(CC.getIdentifierInfo(pp, "semaB3Fn"))
    r = CC.LookupResult(sema, fn_name, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, r, tu)
    @test CC.isAmbiguous(r) == false
    dne = CC.BuildDeclarationNameExpr(sema, ss, r, false)
    @test dne isa CC.Expr_
    @test CC.resolve(dne) isa CC.DeclRefExpr
    CC.dispose(r)

    tmpl_name = CC.DeclarationName(CC.getIdentifierInfo(pp, "semaB3Tmpl"))
    tr = CC.LookupResult(sema, tmpl_name, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, tr, tu)
    tali = CC.TemplateArgumentListInfo(loc, loc)
    tid = CC.BuildTemplateIdExpr(sema, ss, loc, tr, false, tali)
    @test tid isa CC.Expr_
    @test CC.resolve(tid) isa CC.UnresolvedLookupExpr
    CC.dispose(tr)
    CC.dispose(tali)

    # --- the current-instantiation rebuilders, run outside any instantiation ---
    rebuilt_tsi = CC.RebuildTypeInCurrentInstantiation(sema, int_tsi, loc)
    @test rebuilt_tsi isa CC.TypeSourceInfo
    @test rebuilt_tsi.ptr != C_NULL
    # an unset scope specifier carries no qualifier to rebuild
    @test CC.RebuildNestedNameSpecifierInCurrentInstantiation(sema, ss)

    rebuilt_expr = CC.RebuildExprInCurrentInstantiation(sema, eight)
    @test rebuilt_expr isa CC.Expr_

    # the function template's own parameter list — selected by kind, since the name also
    # resolves to the templated function
    @test f(I, "semaB3Tmpl")
    ftd = CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate"))
    tpl = CC.getTemplateParameters(ftd)
    @test tpl isa CC.TemplateParameterList
    @test !(CC.RebuildTemplateParamsInCurrentInstantiation(sema, tpl))

    # --- last, the two builders that let Sema diagnose: `throw` reports disabled C++
    #     exceptions and __func__ reports being outside a function body ---
    thrown = CC.BuildCXXThrow(sema, loc, eight)
    @test thrown isa CC.Expr_
    @test CC.resolve(thrown) isa CC.CXXThrowExpr

    # __func__ resolves against Sema's current function, and at the top level there is
    # none — clang would emit an extension diagnostic whose rendering segfaults, so the
    # wrapper's gate must reject the call before it reaches Sema.
    @test CC.getCurFunctionDecl(sema).ptr == C_NULL
    @test_throws AssertionError CC.BuildPredefinedExpr(sema, loc,
                                                       CC.CXPredefinedIdentKind_Func)

    CC.dispose(ss)
    dispose(f)
    dispose(I)
end

@testset "Sema | implicit conversion sequences and the operand checks" begin
    # A throwaway interpreter: the conversion checks add implicit-cast nodes to the
    # ASTContext, so none of this may leak into the shared interpreter.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaChk3Base { int b; };
             struct SemaChk3Rec : SemaChk3Base { int m; };
             const int semaChk3Eight = 8;
             SemaChk3Rec *semaChk3Ptr = nullptr;
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    rng = CC.SourceRange(loc, loc)
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    double_ty = CC.get_qual_type(CC.jlty_to_clty(Float64, ctx))

    @test f(I, "semaChk3Eight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))
    @test eight isa CC.Expr_

    # --- the implicit conversion sequence int -> double, into a caller-owned box ---
    ics = CC.ImplicitConversionSequence()
    @test CC.TryImplicitConversion(sema, eight, double_ty, ics) === ics
    @test CC.isInitialized(ics)
    @test CC.getKind(ics) isa CC.LibClangEx.CXImplicitConversionSequence_Kind
    # every explicit-conversion policy is accepted and still leaves a usable sequence
    again = CC.TryImplicitConversion(sema, eight, double_ty, ics, false,
                                     CC.LibClangEx.CXAllowedExplicit_All, true, true, false)
    @test CC.isInitialized(again)
    dispose(ics)

    # --- pointer conversion, over a pointer initializer taken from the parsed AST ---
    @test f(I, "semaChk3Ptr")
    pvd = CC.VarDecl(get_decl(f))
    pinit = CC.getInit(pvd)
    @test pinit isa CC.Expr_
    failed, ckind = CC.CheckPointerConversion(sema, pinit, CC.getType(pvd), false, false)
    @test failed isa Bool
    @test ckind isa CC.LibClangEx.CXCastKind

    # --- assignment constraints; ConvertRHS=false is the pure-query form ---
    conv, converted = CC.CheckSingleAssignmentConstraints(sema, double_ty, eight, false,
                                                          false, false)
    @test conv isa CC.LibClangEx.CXAssignConvertType
    @test converted isa Union{Nothing,CC.Expr_}
    # clang documents diagnostics as requiring the conversion; the wrapper restates it
    @test_throws AssertionError CC.CheckSingleAssignmentConstraints(sema, double_ty, eight,
                                                                    true, false, false)

    uconv, uconverted = CC.CheckTransparentUnionArgumentConstraints(sema, int_ty, eight)
    @test uconv isa CC.LibClangEx.CXAssignConvertType
    @test uconverted isa Union{Nothing,CC.Expr_}

    # --- a target type that is not a function carries no exception specification ---
    @test !(CC.CheckExceptionSpecCompatibility(sema, eight, int_ty))

    # --- the ARC weak rule is a plain comparison of two canonicalized types ---
    @test CC.CheckObjCARCUnavailableWeakConversion(sema, int_ty, int_ty)

    # --- literal classification is total: an integer literal is no ObjC literal form ---
    @test CC.CheckLiteralKind(sema, eight) isa CC.LibClangEx.CXObjCLiteralKind

    # --- operand checks over that same literal ---
    @test CC.CheckUnevaluatedOperand(sema, eight) isa Union{Nothing,CC.Expr_}
    @test CC.CheckLValueToRValueConversionOperand(sema, eight) isa Union{Nothing,CC.Expr_}
    uett = CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf
    @test CC.CheckUnaryExprOrTypeTraitOperand(sema, eight, uett) == false
    @test !(CC.CheckLoopHintExpr(sema, eight, loc))
    @test CC.CheckSwitchCondition(sema, loc, eight) isa Union{Nothing,CC.Expr_}
    @test CC.CheckCXXBooleanCondition(sema, eight) isa Union{Nothing,CC.Expr_}
    @test CC.CheckCXXBooleanCondition(sema, eight, true) isa Union{Nothing,CC.Expr_}

    # --- vector cast, over a vector type built directly in the ASTContext ---
    vec_ty = CC.getVectorType(ctx, int_ty, 4, CC.LibClangEx.CXVectorKind_Generic)
    @test vec_ty isa CC.QualType
    vfailed, vkind = CC.CheckVectorCast(sema, rng, vec_ty, vec_ty)
    @test vfailed isa Bool
    @test vkind isa CC.LibClangEx.CXCastKind
    # a scalar destination does not satisfy the method's own assertion
    @test_throws AssertionError CC.CheckVectorCast(sema, rng, int_ty, int_ty)

    # --- bit-field width verification, named and unnamed ---
    bits = CC.getIdentifierInfo(pp, "semaChk3Bits")
    @test CC.VerifyBitField(sema, loc, bits, int_ty, false, eight) isa
          Union{Nothing,CC.Expr_}
    @test CC.VerifyBitField(sema, loc, nothing, int_ty, false, eight) isa
          Union{Nothing,CC.Expr_}

    dispose(f)
    dispose(I)
end

@testset "Sema | defining implicit special members, lookup filters and pragma helpers" begin
    # Every call in this testset mutates AST or Sema state — special-member bodies are
    # synthesized, lookup results are filtered, type tags are registered — so it runs
    # against an interpreter of its own that is disposed before the file continues.
    I = create_interpreter(String[])
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    srcmgr = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(srcmgr)

    CC.parse(I, """
             struct SemaDefImpl { int a; double b; };
             template <typename T> struct SemaDefTmpl { T v; };
             typedef int SemaDefAlias;
             int semaDefPlain = 0;
             """)

    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    # Between incremental parses the parser rests at translation-unit scope.
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    @test sc.ptr != C_NULL

    f = DeclFinder(I)
    # Select by kind rather than by uniqueness: this testset declares implicit members and
    # would make a bare get_decl fragile if a name ever stopped resolving to one decl.
    function by_kind(name, kind)
        @test f(I, name)
        return first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == kind)
    end
    rd = CC.CXXRecordDecl(by_kind("SemaDefImpl", "CXXRecord"))
    alias = CC.TypedefDecl(by_kind("SemaDefAlias", "Typedef"))
    @test CC.hasDefinition(rd)

    # Declare all six special members first, so that defining one cannot change which of
    # the others the lookups would still declare.
    ctor = CC.LookupDefaultConstructor(sema, rd)
    dtor = CC.LookupDestructor(sema, rd)
    cctor = CC.LookupCopyingConstructor(sema, rd, 0x1)
    mctor = CC.LookupMovingConstructor(sema, rd)
    cassign = CC.LookupCopyingAssignment(sema, rd, 0x1)
    massign = CC.LookupMovingAssignment(sema, rd)
    for m in (ctor, dtor, cctor, mctor, cassign, massign)
        @test m.ptr != C_NULL
        @test CC.isDefaulted(m)
        @test !CC.isDeleted(m)
        @test !CC.doesThisDeclarationHaveABody(m)
    end

    # Each Define* call turns the declaration into a definition, which is exactly what
    # doesThisDeclarationHaveABody reports.
    @test CC.DefineImplicitDefaultConstructor(sema, loc, ctor) === nothing
    @test CC.doesThisDeclarationHaveABody(ctor)
    @test CC.DefineImplicitCopyConstructor(sema, loc, cctor) === nothing
    @test CC.doesThisDeclarationHaveABody(cctor)
    @test CC.DefineImplicitMoveConstructor(sema, loc, mctor) === nothing
    @test CC.doesThisDeclarationHaveABody(mctor)
    @test CC.DefineImplicitCopyAssignment(sema, loc, cassign) === nothing
    @test CC.doesThisDeclarationHaveABody(cassign)
    @test CC.DefineImplicitMoveAssignment(sema, loc, massign) === nothing
    @test CC.doesThisDeclarationHaveABody(massign)
    @test CC.DefineImplicitDestructor(sema, loc, dtor) === nothing
    @test CC.doesThisDeclarationHaveABody(dtor)

    # A second call would trip clang's own assert, so the wrapper rejects it first; the
    # same guard rejects passing a member to the wrong Define* overload.
    @test_throws AssertionError CC.DefineImplicitDefaultConstructor(sema, loc, ctor)
    @test_throws AssertionError CC.DefineImplicitDestructor(sema, loc, dtor)
    @test_throws AssertionError CC.DefineImplicitCopyAssignment(sema, loc, massign)
    @test_throws AssertionError CC.DefineImplicitMoveAssignment(sema, loc, cassign)

    # --- Lookup-result filters ---
    # A class template survives the template-name filter unchanged.
    tmpl_r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaDefTmpl")),
                             loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, tmpl_r, tu)
    @test CC.getNum(tmpl_r) == 1
    @test CC.FilterAcceptableTemplateNames(sema, tmpl_r) === nothing
    @test CC.getNum(tmpl_r) == 1
    CC.dispose(tmpl_r)

    # A plain variable names no template at all, so the filter empties the result.
    plain_r = CC.LookupResult(sema,
                              CC.DeclarationName(CC.getIdentifierInfo(pp, "semaDefPlain")),
                              loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, plain_r, tu)
    @test CC.getNum(plain_r) == 1
    CC.FilterAcceptableTemplateNames(sema, plain_r)
    @test CC.getNum(plain_r) == 0
    @test CC.empty(plain_r)
    CC.dispose(plain_r)

    # semaDefPlain is declared in the translation unit, so filtering against the
    # translation-unit context keeps it — that is a language fact, not a host decision.
    scope_r = CC.LookupResult(sema,
                              CC.DeclarationName(CC.getIdentifierInfo(pp, "semaDefPlain")),
                              loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, scope_r, tu)
    before = CC.getNum(scope_r)
    @test CC.FilterLookupForScope(sema, scope_r, tu, sc, false, false) === nothing
    @test CC.getNum(scope_r) == before
    CC.dispose(scope_r)

    # FilterUsingLookup keeps only what a using-declaration would newly introduce; which
    # context Sema currently rests in decides how much that removes, so only the direction
    # of the change is asserted.
    using_r = CC.LookupResult(sema,
                              CC.DeclarationName(CC.getIdentifierInfo(pp, "semaDefPlain")),
                              loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, using_r, tu)
    using_before = CC.getNum(using_r)
    @test CC.FilterUsingLookup(sema, sc, using_r) === nothing
    @test CC.getNum(using_r) <= using_before
    CC.dispose(using_r)

    # --- Declaration-level helpers ---
    # A tag that already has a name for linkage keeps the one it has: the call is a
    # defined no-op rather than a rename.
    @test CC.hasNameForLinkage(rd)
    @test CC.getTypedefNameForAnonDecl(rd).ptr == C_NULL
    @test CC.setTagNameForLinkagePurposes(sema, rd, alias) === nothing
    @test CC.getTypedefNameForAnonDecl(rd).ptr == C_NULL

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    kind_ii = CC.getIdentifierInfo(pp, "sema_def_tag_kind")
    @test CC.RegisterTypeTagForDatatype(sema, kind_ii, 42, int_ty, true, false) === nothing

    # No arc_cf_code_audited region and no clang attribute region is open, so both helpers
    # leave the declaration's attribute list exactly as it was.
    attrs_before = CC.getNumAttrs(rd)
    @test CC.AddCFAuditedAttribute(sema, rd) === nothing
    @test CC.getNumAttrs(rd) == attrs_before
    @test CC.AddPragmaAttributes(sema, sc, rd) === nothing
    @test CC.getNumAttrs(rd) == attrs_before

    dispose(f)
    dispose(I)
end

@testset "Sema | unary type transforms, standard conversions and format-string queries" begin
    # A throwaway interpreter: the transforms below add types to the ASTContext and the
    # conversions add implicit-cast nodes, so none of it may leak into the interpreter the
    # other test files share.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             enum class SemaXfEnum : unsigned char { A, B };
             int semaXfInt = 0;
             int *semaXfPtr = nullptr;
             const int semaXfConst = 3;
             int semaXfFn(int n) { int a[3] = {1, 2, 3}; int b = a[0] + n; return b; }
             __attribute__((format(printf, 1, 2))) void semaXfLog(const char *fmt, ...);
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    function vartype(name)
        @assert f(I, name) "lookup failed: $name"
        return CC.getType(CC.VarDecl(get_decl(f)))
    end

    int_qt = vartype("semaXfInt")
    ptr_qt = vartype("semaXfPtr")
    const_qt = vartype("semaXfConst")

    @assert f(I, "SemaXfEnum") "lookup failed: SemaXfEnum"
    enum_qt = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    @test CC.isEnumeralType(CC.getTypePtr(enum_qt))

    # The array and integer operands come out of the parsed function body: `a` is a
    # DeclRefExpr of array type, `n`/`b` are integer-typed lvalues.
    @assert f(I, "semaXfFn") "lookup failed: semaXfFn"
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    arr_ref = first(n for n in nodes
                    if n isa CC.DeclRefExpr && CC.isa_ArrayType(CC.getTypePtr(CC.getType(n))))
    int_ref = first(n for n in nodes
                    if n isa CC.DeclRefExpr && CC.isIntegerType(CC.getTypePtr(CC.getType(n))))
    arr_qt = CC.getType(arr_ref)

    # The interpreter is always a C++ compiler, which is what gates BuiltinAddReference.
    @test CC.getCPlusPlus(CC.getLangOpts(sema))

    # --- Unary type transforms ---
    add_ptr = CC.BuiltinAddPointer(sema, int_qt, loc)
    @test add_ptr isa CC.QualType
    @test add_ptr.ptr != C_NULL
    @test CC.isPointerType(CC.getTypePtr(add_ptr))

    rem_ptr = CC.BuiltinRemovePointer(sema, ptr_qt, loc)
    @test rem_ptr.ptr != C_NULL
    @test !CC.isPointerType(CC.getTypePtr(rem_ptr))
    @test CC.isIntegerType(CC.getTypePtr(rem_ptr))
    @test !CC.is_null_handle(CC.BuiltinRemovePointer(sema, int_qt, loc))

    decayed = CC.BuiltinDecay(sema, arr_qt, loc)
    @test decayed.ptr != C_NULL
    @test CC.isPointerType(CC.getTypePtr(decayed))

    no_extent = CC.BuiltinRemoveExtent(sema, arr_qt, CC.CXUTTKind_RemoveExtent, loc)
    @test no_extent.ptr != C_NULL
    @test !CC.isa_ArrayType(CC.getTypePtr(no_extent))
    @test CC.BuiltinRemoveExtent(sema, arr_qt, CC.CXUTTKind_RemoveAllExtents, loc) isa
          CC.QualType

    lref = CC.BuiltinAddReference(sema, int_qt, CC.CXUTTKind_AddLvalueReference, loc)
    @test lref.ptr != C_NULL
    @test CC.isLValueReferenceType(CC.getTypePtr(lref))
    rref = CC.BuiltinAddReference(sema, int_qt, CC.CXUTTKind_AddRvalueReference, loc)
    @test CC.isRValueReferenceType(CC.getTypePtr(rref))

    unref = CC.BuiltinRemoveReference(sema, lref, CC.CXUTTKind_RemoveReference, loc)
    @test unref.ptr != C_NULL
    @test !CC.isReferenceType(CC.getTypePtr(unref))

    @test CC.getCVRQualifiers(const_qt) == 1
    unconst = CC.BuiltinChangeCVRQualifiers(sema, const_qt, CC.CXUTTKind_RemoveConst, loc)
    @test unconst.ptr != C_NULL
    @test CC.getCVRQualifiers(unconst) == 0

    made_unsigned = CC.BuiltinChangeSignedness(sema, int_qt, CC.CXUTTKind_MakeUnsigned, loc)
    @test made_unsigned.ptr != C_NULL
    @test CC.isUnsignedIntegerType(CC.getTypePtr(made_unsigned))
    made_signed = CC.BuiltinChangeSignedness(sema, made_unsigned, CC.CXUTTKind_MakeSigned,
                                             loc)
    @test CC.isSignedIntegerType(CC.getTypePtr(made_signed))

    underlying = CC.BuiltinEnumUnderlyingType(sema, enum_qt, loc)
    @test underlying.ptr != C_NULL
    @test CC.isIntegerType(CC.getTypePtr(underlying))
    @test !CC.isEnumeralType(CC.getTypePtr(underlying))

    # --- `auto` replacement, the sugar-dropping sibling of SubstAutoType ---
    auto_qt = CC.getAutoDeductType(ctx)
    replaced = CC.ReplaceAutoType(sema, auto_qt, int_qt)
    @test replaced isa CC.QualType
    @test replaced.ptr != C_NULL
    @test !CC.isUndeducedType(CC.getTypePtr(replaced))

    auto_tsi = CC.getTrivialTypeSourceInfo(ctx, auto_qt, loc)
    replaced_tsi = CC.ReplaceAutoTypeSourceInfo(sema, auto_tsi, int_qt)
    @test replaced_tsi isa CC.TypeSourceInfo
    @test replaced_tsi.ptr != C_NULL

    # --- Standard expression conversions ---
    decayed_arg = CC.DefaultFunctionArrayConversion(sema, arr_ref)
    @test decayed_arg isa CC.Expr_
    @test CC.isPointerType(CC.getTypePtr(CC.getType(decayed_arg)))

    decayed_lv = CC.DefaultFunctionArrayLvalueConversion(sema, arr_ref, false)
    @test decayed_lv isa CC.Expr_
    @test CC.isPointerType(CC.getTypePtr(CC.getType(decayed_lv)))

    lv = CC.DefaultLvalueConversion(sema, int_ref)
    @test lv isa CC.Expr_
    @test CC.getType(lv).ptr != C_NULL

    unary = CC.UsualUnaryConversions(sema, int_ref)
    @test unary isa CC.Expr_
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(unary)))

    promoted = CC.DefaultArgumentPromotion(sema, int_ref)
    @test promoted isa CC.Expr_
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(promoted)))

    ignored = CC.IgnoredValueConversions(sema, int_ref)
    @test ignored isa CC.Expr_

    # --- Condition types ---
    bool_qt = CC.PreferredConditionType(sema, CC.CXConditionKind_Boolean)
    switch_qt = CC.PreferredConditionType(sema, CC.CXConditionKind_Switch)
    @test bool_qt isa CC.QualType
    @test bool_qt.ptr != C_NULL
    @test CC.isBooleanType(CC.getTypePtr(bool_qt))
    @test switch_qt.ptr != C_NULL
    @test CC.isIntegerType(CC.getTypePtr(switch_qt))
    @test bool_qt.ptr != switch_qt.ptr
    @test CC.PreferredConditionType(sema, CC.CXConditionKind_ConstexprIf).ptr == bool_qt.ptr

    # --- Format-attribute queries (static members, no Sema receiver) ---
    @assert f(I, "semaXfLog") "lookup failed: semaXfLog"
    fmt = first(a for a in (CC.resolve(a) for a in CC.getAttrs(get_decl(f)))
                if a isa CC.FormatAttr)
    @test CC.GetFormatStringType(fmt) == CC.CXFormatStringType_FST_Printf
    ns_idx = CC.GetFormatNSStringIdx(fmt)
    @test ns_idx === nothing || ns_idx isa Integer

    dispose(f)
    dispose(I)
end

@testset "Sema | current-context, module and type-classification queries" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    pp = CC.getPreprocessor(sema)

    CC.parse(I, """
             const char sema_q4_carr[6] = "hello";
             char *sema_q4_cptr = 0;
             int sema_q4_gi = 7;
             int sema_q4_fn(int p) { return p; }
             struct SemaQ4S { int m; };
             """)

    f = DeclFinder(I)
    function q4_vardecl(name)
        @assert f(I, name) "lookup failed: $name"
        return CC.VarDecl(get_decl(f))
    end

    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # --- Sema's own state: the consumer, the scope map and the language defaults ---
    consumer = CC.getASTConsumer(sema)
    @test consumer isa CC.ASTConsumer
    @test consumer.ptr != C_NULL

    @test !CC.is_null_handle(CC.getScopeForContext(sema, tu))

    lex = CC.getCurObjCLexicalContext(sema)
    @test lex isa CC.DeclContext
    @test lex.ptr != C_NULL

    @test !(CC.IsInsideALocalClassWithinATemplateFunction(sema))
    @test CC.getDefaultCXXMethodAddrSpace(sema) == CC.CXLangAS_Default
    std_align = CC.getStdAlignValT(sema)
    @test std_align isa CC.EnumDecl
    @test !CC.is_null_handle(std_align)
    @test CC.getName(std_align) == "align_val_t"

    # The error-trap query dereferences Sema's current function scope, which is null
    # whenever the scope stack is empty, so the wrapper gates on the stack instead.
    @test !(CC.hasCurFunction(sema))
    if CC.hasCurFunction(sema)
        @test CC.hasAnyUnrecoverableErrorsInThisFunction(sema) == false
    else
        @test_throws AssertionError CC.hasAnyUnrecoverableErrorsInThisFunction(sema)
    end

    # --- Module visibility: a hand-built module is not one of this TU's imports ---
    mod = CC.Module_("SemaQ4Mod"; visibility_id=4100)
    @test !(CC.isModuleVisible(sema, mod))
    CC.dispose(mod)

    gi = q4_vardecl("sema_q4_gi")
    @test !(CC.hasMergedDefinitionInCurrentModule(sema, gi))

    # --- Declaration scoping ---
    # a decl is by construction in its own declaration context
    @test CC.isDeclInScope(sema, gi, CC.getDeclContext(gi))
    @test CC.isDeclInScope(sema, gi, tu)
    @test CC.isDeclInScope(sema, gi, tu, nothing, true)

    @assert f(I, "sema_q4_fn") "lookup failed: sema_q4_fn"
    fd = CC.FunctionDecl(get_decl(f))
    # a function context needs a Scope; without one clang would walk a null parent chain
    @test_throws AssertionError CC.isDeclInScope(sema, gi, CC.castToDeclContext(fd))

    # --- Function-level queries ---
    @test CC.getEmissionStatus(sema, fd) isa CC.CXFunctionEmissionStatus
    @test CC.getEmissionStatus(sema, fd, true) isa CC.CXFunctionEmissionStatus
    @test CC.isUnavailableAlignedAllocationFunction(sema, fd) == false
    # the coroutine heuristic matches on the name `get_return_object`
    @test CC.CanBeGetReturnObject(fd) == false

    # --- Token classification: `int` is a simple type specifier, `if` is not ---
    int_kw = CC.getTokenID(CC.getIdentifierInfo(pp, "int"))
    if_kw = CC.getTokenID(CC.getIdentifierInfo(pp, "if"))
    @test int_kw != if_kw
    @test CC.isSimpleTypeSpecifier(sema, int_kw)
    @test CC.isSimpleTypeSpecifier(sema, if_kw) == false

    # --- String initialisation and the string-literal pointer conversion ---
    carr = q4_vardecl("sema_q4_carr")
    arr_ty = CC.resolve(CC.getTypePtr(CC.getType(carr)))
    @test arr_ty isa CC.AbstractArrayType
    str = CC.resolve(CC.IgnoreParenImpCasts(CC.getInit(carr)))
    @test str isa CC.StringLiteral
    @test CC.IsStringInit(sema, str, arr_ty)

    gi_init = CC.getInit(gi)
    # an integer literal is not a string literal, whatever the array's element type
    @test CC.IsStringInit(sema, gi_init, arr_ty) == false

    cptr_ty = CC.getType(q4_vardecl("sema_q4_cptr"))
    @test CC.IsStringLiteralToNonConstPointerConversion(sema, str, cptr_ty)
    @test CC.IsStringLiteralToNonConstPointerConversion(sema, gi_init, cptr_ty) == false

    # --- decltype without the sugar: a prvalue keeps its own type ---
    dt = CC.getDecltypeForExpr(sema, gi_init)
    @test dt isa CC.QualType
    @test dt.ptr != C_NULL
    @test CC.isIntegerType(CC.getTypePtr(dt))

    # --- `this` outside a member function body ---
    @assert f(I, "SemaQ4S") "lookup failed: SemaQ4S"
    rec_ty = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    @test !(CC.isThisOutsideMemberFunctionBody(sema, rec_ty))

    # --- Scalable-vector bitcasts, and the "one operand is a vector" assert they share
    # with areVectorTypesSameSize ---
    v4 = CC.getVectorType(ctx, int_ty, 4, CC.CXVectorKind_Generic)
    @test !(CC.isValidSveBitcast(sema, v4, int_ty))
    @test !(CC.isValidRVVBitcast(sema, v4, int_ty))
    @test_throws AssertionError CC.isValidSveBitcast(sema, int_ty, int_ty)
    @test_throws AssertionError CC.isValidRVVBitcast(sema, int_ty, int_ty)

    dispose(f)
    dispose(I)
end

@testset "Sema | declarator groups, member references and the remaining cast builders" begin
    # A throwaway interpreter: every builder below allocates into the ASTContext, and
    # MakeFullExpr resets Sema's full-expression cleanup bookkeeping, so none of this may
    # leak into the interpreter the rest of the suite shares.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaB4S { int a; };
             SemaB4S semaB4Obj;
             const int semaB4Eight = 8;
             __builtin_va_list semaB4Args;
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    scope = CC.getCurScope(CC.get_parser(I))
    f = DeclFinder(I)

    @test f(I, "semaB4Eight")
    eight_vd = CC.VarDecl(get_decl(f))
    eight = CC.getInit(eight_vd)
    @test f(I, "semaB4Obj")
    obj_vd = CC.VarDecl(get_decl(f))
    @test f(I, "semaB4Args")
    args_vd = CC.VarDecl(get_decl(f))

    int_ty = CC.getType(eight)
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_ty, loc)

    # --- a declarator list packaged back into its DeclGroupRef ---
    one = CC.BuildDeclaratorGroup(sema, [eight_vd])
    @test one isa CC.DeclGroupRef
    @test CC.isSingleDecl(one)
    @test CC.getSingleDecl(one).ptr == eight_vd.ptr

    two = CC.BuildDeclaratorGroup(sema, [eight_vd, obj_vd])
    @test CC.isDeclGroup(two)
    # an empty group is the NULL DeclGroupRef, so the carrier must be inspected directly:
    # isNull goes through @check_ptrs, which rejects a NULL-carrying handle
    @test CC.BuildDeclaratorGroup(sema, CC.VarDecl[]).ptr == C_NULL

    # --- the end-of-full-expression entry points ---
    full = CC.MakeFullExpr(sema, eight)
    @test full isa CC.Expr_
    discarded = CC.MakeFullDiscardedValueExpr(sema, eight)
    @test discarded isa CC.Expr_

    # --- the variable a `catch (int semaB4Caught)` clause would declare ---
    caught = CC.BuildExceptionDeclaration(sema, scope, int_tsi, loc, loc,
                                          CC.getIdentifierInfo(pp, "semaB4Caught"))
    @test caught isa CC.VarDecl
    @test caught.ptr == C_NULL || CC.getName(caught) == "semaB4Caught"
    @test caught.ptr == C_NULL || CC.isExceptionVariable(caught)

    # --- __builtin_sycl_unique_stable_name(int) ---
    usn = CC.BuildSYCLUniqueStableNameExpr(sema, loc, loc, loc, int_tsi)
    @test usn === nothing || CC.resolve(usn) isa CC.SYCLUniqueStableNameExpr

    # --- semaB4Obj.a, built from the resolved field and the access it was found with ---
    rec = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(obj_vd)))
    @test rec isa CC.CXXRecordDecl
    fields = CC.getFields(rec)
    @test length(fields) == 1
    field = first(fields)
    base = CC.BuildDeclRefExpr(sema, obj_vd, CC.getType(obj_vd),
                               CC.LibClangEx.CXExprValueKind_VK_LValue, loc)
    ss = CC.CXXScopeSpec()
    dni = CC.DeclarationNameInfo(CC.DeclarationName(CC.getIdentifierInfo(pp, "a")), loc)
    member = CC.BuildFieldReferenceExpr(sema, base, false, loc, ss, field, field,
                                        CC.LibClangEx.CXAccessSpecifier_AS_public, dni)
    @test member === nothing || CC.resolve(member) isa CC.MemberExpr

    # --- (int){8}, whose initializer list is built through the wrapped entry point ---
    init_list = CC.BuildInitList(sema, loc, CC.Expr_[eight], loc)
    if init_list !== nothing
        literal = CC.BuildCompoundLiteralExpr(sema, loc, int_tsi, loc, init_list)
        @test literal === nothing || CC.resolve(literal) isa CC.CompoundLiteralExpr
    end

    # --- __builtin_va_arg over a real va_list object; its spelling is target-dependent ---
    va_base = CC.BuildDeclRefExpr(sema, args_vd, CC.getType(args_vd),
                                  CC.LibClangEx.CXExprValueKind_VK_LValue, loc)
    va = CC.BuildVAArgExpr(sema, loc, va_base, int_tsi, loc)
    @test va === nothing || CC.resolve(va) isa CC.VAArgExpr

    # --- static_cast<int>(8); the cast keyword crosses as its raw tok::TokenKind ---
    static_kind = CC.getTokenID(CC.getIdentifierInfo(pp, "static_cast"))
    # TokenKinds.def stringifies a KEYWORD(X, Y) entry as #X, so tok::kw_static_cast is
    # named "static_cast", not "kw_static_cast"
    @test CC.getTokenName(static_kind) == "static_cast"
    angles = CC.SourceRange(loc, loc)
    parens = CC.SourceRange(loc, loc)
    named = CC.BuildCXXNamedCast(sema, loc, static_kind, int_tsi, eight, angles, parens)
    @test named === nothing || CC.resolve(named) isa CC.CXXStaticCastExpr
    # any other keyword reaches clang's llvm_unreachable, so the wrapper rejects it first
    sizeof_kind = CC.getTokenID(CC.getIdentifierInfo(pp, "sizeof"))
    @test_throws AssertionError CC.BuildCXXNamedCast(sema, loc, sizeof_kind, int_tsi, eight,
                                                     angles, parens)

    # --- typeid(int), whose result type the caller supplies ---
    tid = CC.BuildCXXTypeId(sema, int_ty, loc, int_tsi, loc)
    @test tid === nothing || CC.resolve(tid) isa CC.CXXTypeidExpr

    # --- a declaration template argument re-expressed as `&semaB4Eight` ---
    const_int = CC.getType(eight_vd)
    decl_arg = CC.TemplateArgument(CC.ValueDecl(eight_vd), const_int)
    @test CC.getKind(decl_arg) == CC.CXTemplateArgument_Declaration
    from_decl = CC.BuildExpressionFromDeclTemplateArgument(sema, decl_arg,
                                                           CC.getPointerType(ctx, const_int),
                                                           loc)
    @test from_decl === nothing || from_decl isa CC.Expr_
    # clang asserts on any other argument kind, so the wrapper rejects it first
    type_arg = CC.TemplateArgument(int_ty)
    @test_throws AssertionError CC.BuildExpressionFromDeclTemplateArgument(sema, type_arg,
                                                                           const_int, loc)
    CC.dispose(type_arg)
    CC.dispose(decl_arg)

    CC.dispose(dni)
    CC.dispose(ss)
    dispose(f)
    dispose(I)
end

@testset "Sema | Check* semantic checks" begin
    I = CC.create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    CC.parse(I, """
    struct SemaCk4Rec { int fld; };
    struct alignas(8) SemaCk4AlRec { int a; };
    enum class SemaCk4Enum : int { A };
    int semaCk4Fn(int a, int b = 2);
    struct SemaCk4Ctor { SemaCk4Ctor(int) {} };
    alignas(8) int semaCk4Aligned = 0;
    int semaCk4Var = 8;
    double semaCk4Dbl = 1.0;
    constexpr bool semaCk4Flag = true;
    """)

    f = CC.DeclFinder(I)
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # No delegating constructor was written, so the sweep has nothing to invalidate.
    @test CC.CheckDelegatingCtorCycles(sema) === nothing

    # --- a field of trivial type is legal in a union, so nothing is diagnosed ---
    @test f(I, "SemaCk4Rec")
    rec = CC.CXXRecordDecl(CC.get_decl(f))
    fld = first(CC.getFields(rec))
    @test fld isa CC.FieldDecl
    @test CC.CheckNontrivialField(sema, fld) == false

    # --- an enum redeclared exactly as it stands contradicts nothing ---
    @test f(I, "SemaCk4Enum")
    ed = CC.EnumDecl(CC.get_decl(f))
    @test CC.isScoped(ed)
    @test CC.isFixed(ed)
    @test CC.CheckEnumRedeclaration(sema, loc, CC.isScoped(ed), CC.getIntegerType(ed),
                                    CC.isFixed(ed), ed) == false

    # --- `int` is complete, so the diagnoser that would name the call is never built ---
    @test CC.CheckCallReturnType(sema, int_ty, loc) == false

    # --- the one default argument is trailing, and no override control is written ---
    @test f(I, "semaCk4Fn")
    fn = CC.FunctionDecl(CC.get_decl(f))
    @test CC.CheckCXXDefaultArguments(sema, fn) === nothing
    @test CC.CheckOverrideControl(sema, fn) === nothing

    # --- alignas(8) is stricter than either declaration's type requires ---
    @test f(I, "semaCk4Aligned")
    aligned_var = CC.VarDecl(CC.get_decl(f))
    @test CC.hasAttrs(aligned_var)
    @test CC.CheckAlignasUnderalignment(sema, aligned_var) === nothing
    @test f(I, "SemaCk4AlRec")
    aligned_rec = CC.CXXRecordDecl(CC.get_decl(f))
    @test CC.hasAttrs(aligned_rec)
    @test CC.CheckAlignasUnderalignment(sema, aligned_rec) === nothing

    # --- a constructor taking `int` is not the by-value copy [class.copy]p3 bans ---
    @test f(I, "SemaCk4Ctor")
    ctors = CC.getCtors(CC.CXXRecordDecl(CC.get_decl(f)))
    @test !isempty(ctors)
    @test CC.CheckConstructor(sema, first(ctors)) === nothing

    # --- expression checks whose warnings are all off by default ---
    @test f(I, "semaCk4Var")
    int_init = CC.getInit(CC.VarDecl(CC.get_decl(f)))
    int_range = CC.getSourceRange(int_init)
    @test CC.CheckVecStepExpr(sema, int_init) == false
    @test CC.CheckUnusedVolatileAssignment(sema, int_init) === nothing
    @test CC.CheckCastAlign(sema, int_init, int_ty, int_range) === nothing
    # a non-reference destination returns before the diagnostic is ever formatted
    @test CC.CheckCompatibleReinterpretCast(sema, int_ty, int_ty, false, int_range) ===
          nothing

    # --- C++ has no `int a[static 4]` parameters, so this returns at once ---
    @test CC.CheckStaticArrayArgument(sema, loc, CC.getParamDecl(fn, 0), int_init) ===
          nothing

    # --- two references to the same declaration short-circuit the float-equality warning ---
    @test f(I, "semaCk4Dbl")
    dbl_vd = CC.VarDecl(CC.get_decl(f))
    dbl_ref = CC.BuildDeclRefExpr(sema, dbl_vd, CC.getType(dbl_vd),
                                  CC.LibClangEx.CXExprValueKind_VK_LValue, loc)
    @test dbl_ref isa CC.DeclRefExpr
    @test CC.CheckFloatComparison(sema, loc, dbl_ref, dbl_ref,
                                  CC.LibClangEx.CXBinaryOperatorKind_BO_EQ) === nothing

    # --- a bool atomic constraint is valid; an int one is rejected by the wrapper ---
    @test f(I, "semaCk4Flag")
    flag_init = CC.getInit(CC.VarDecl(CC.get_decl(f)))
    ok, non_primary = CC.CheckConstraintExpression(sema, flag_init)
    @test ok
    @test !non_primary
    @test_throws AssertionError CC.CheckConstraintExpression(sema, int_init)

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Sema | substituting template arguments into a pattern" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    pp = CC.getPreprocessor(sema)

    CC.parse(I, """
    namespace SemaSubstNS { void substTarget(); }
    using SemaSubstNS::substTarget;

    template <typename SemaSubstT>
    struct SemaSubstPattern {
        SemaSubstT value;
        static const unsigned width = sizeof(SemaSubstT);
        void empty_body() { ; }
    };
    """)

    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    # Select by kind rather than by uniqueness: a template's own name stops resolving to a
    # single decl as soon as anything specialises it, and get_decl throws on that.
    @test f(I, "SemaSubstPattern")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    rd = CC.getTemplatedDecl(ctd)
    rd_dc = CC.castToDeclContext(rd)
    loc = CC.getLocation(ctd)

    field = first(CC.getFields(rd))
    param_qt = CC.getType(field)
    param_tsi = CC.getTypeSourceInfo(field)
    dependent_expr = CC.getInit(first(d for d in CC.decls(rd_dc) if d isa CC.VarDecl))
    body = CC.getBody(first(d for d in CC.decls(rd_dc) if d isa CC.CXXMethodDecl))

    # one substituted level, SemaSubstT -> int, owned by the class template itself
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    arg = CC.TemplateArgument(int_qt)
    ml = CC.MultiLevelTemplateArgumentList()
    CC.addOuterTemplateArguments(ml, ctd, [arg], true)

    # The sentinel is the only way to open a code-synthesis context outside the parser; the
    # depth is asserted as a round trip rather than against an absolute value.
    base = CC.getNumCodeSynthesisContexts(sema)
    @test base isa Integer

    inst = CC.InstantiatingTemplate(sema, loc, ctd)
    @test inst isa CC.InstantiatingTemplate
    @test inst.ptr != C_NULL
    @test CC.isInvalid(inst) == false
    @test !(CC.isAlreadyInstantiating(inst))
    @test CC.getNumCodeSynthesisContexts(sema) == base + 1
    @test CC.inTemplateInstantiation(sema)

    # --- types ---
    subst_qt = CC.SubstType(sema, param_qt, ml, loc)
    @test subst_qt isa CC.QualType
    @test subst_qt.ptr != C_NULL
    # the parameter was dependent; substituting the argument in makes it the integer type
    @test CC.isIntegerType(CC.getTypePtr(subst_qt))

    subst_tsi = CC.SubstTypeSourceInfo(sema, param_tsi, ml, loc)
    @test subst_tsi isa CC.TypeSourceInfo
    @test subst_tsi.ptr != C_NULL

    # --- expressions ---
    for substitute in (CC.SubstExpr, CC.SubstConstraintExpr,
                       CC.SubstConstraintExprWithoutSatisfaction)
        e = substitute(sema, dependent_expr, ml)
        @test e isa CC.Expr_
        @test e.ptr != C_NULL
        @test !(CC.isValueDependent(e))
    end

    init = CC.SubstInitializer(sema, dependent_expr, ml, false)
    @test init isa CC.Expr_
    @test init.ptr != C_NULL

    # --- statements ---
    # Transforming a CompoundStmt calls Sema::PushCompoundScope, which dereferences
    # getCurFunction() with no null check; between parses that stack is empty, so the
    # wrapper's gate must reject the call rather than let it segfault.
    @test CC.hasCurFunction(sema) == false
    @test_throws AssertionError CC.SubstStmt(sema, body, ml)

    # --- names and written qualifiers, both by-value classes that come back as owned boxes ---
    ni = CC.DeclarationNameInfo(CC.DeclarationName(CC.getIdentifierInfo(pp, "substTarget")),
                                loc)
    subst_ni = CC.SubstDeclarationNameInfo(sema, ni, ml)
    @test subst_ni isa CC.DeclarationNameInfo
    @test CC.getAsString(subst_ni) == CC.getAsString(ni)
    dispose(subst_ni)
    dispose(ni)

    # a using-declaration never appears in a name lookup — the lookup resolves through its
    # shadow — so the UsingDecl is reached by walking the translation unit
    using_decl = CC.UsingDecl(first(d for d in CC.decls(tu_dc) if CC.getDeclKindName(d) == "Using"))
    qloc = CC.getQualifierLoc(using_decl)
    @test CC.hasQualifier(qloc)
    subst_qloc = CC.SubstNestedNameSpecifierLoc(sema, qloc, ml)
    @test subst_qloc isa CC.NestedNameSpecifierLoc
    @test subst_qloc.ptr != C_NULL
    @test CC.hasQualifier(subst_qloc)
    dispose(subst_qloc)
    dispose(qloc)

    # disposing the sentinel pops exactly the record it pushed
    dispose(inst)
    @test CC.getNumCodeSynthesisContexts(sema) == base

    # with the stack back at its original depth the wrappers reject the call themselves,
    # instead of tripping clang's own assert
    if base == 0
        @test_throws AssertionError CC.SubstType(sema, param_qt, ml, loc)
        @test_throws AssertionError CC.SubstExpr(sema, dependent_expr, ml)
    end

    dispose(ml)
    dispose(arg)
    dispose(f)
    dispose(I)
end

@testset "Sema | overload candidates, hidden virtuals and global allocation functions" begin
    # Every call below either mutates Sema (a lookup that declares implicit members, a
    # deduced specialization) or the translation unit (a fresh global operator new), so the
    # whole set runs against an interpreter it builds and disposes itself.
    I = create_interpreter(String[])
    CC.parse(I, """
             struct SemaD4Base {
                 virtual void hidden(int);
                 virtual ~SemaD4Base() {}
             };
             struct SemaD4Derived : SemaD4Base {
                 void hidden(double);
                 int member(int) const;
                 int operator+(int) const;
             };
             struct SemaD4Rec {
                 void operator delete(void *);
             };
             namespace semad4ns {
             struct Tagged {};
             int adlPick(Tagged);
             }
             int semaD4Fn(int);
             int semaD4Fn(double);
             template <typename T> T semaD4Tmpl(T);
             int *semaD4New() { return new int; }
             void semaD4Body(int n, SemaD4Derived &d, semad4ns::Tagged t) {
                 int a = n;
                 (void)a;
                 (void)d;
                 (void)t;
             }
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    # Every lookup happens before the first mutating call: a name that is unique now can
    # stop being unique once a candidate collector deduces a specialization.
    @assert f(I, "SemaD4Derived") "lookup failed: SemaD4Derived"
    derived = CC.CXXRecordDecl(get_decl(f))
    dmethods = CC.getMethods(derived)
    hidden_md = first(m for m in dmethods if CC.getNameAsString(m) == "hidden")
    member_md = first(m for m in dmethods if CC.getNameAsString(m) == "member")

    @assert f(I, "SemaD4Rec") "lookup failed: SemaD4Rec"
    rec = CC.CXXRecordDecl(get_decl(f))
    del_md = first(m for m in CC.getMethods(rec)
                   if CC.getNameAsString(m) == "operator delete")
    del_name = CC.getDeclName(del_md)

    @assert f(I, "semaD4Fn") "lookup failed: semaD4Fn"
    fns = [CC.FunctionDecl(d) for d in CC.get_decls(f)
           if CC.getDeclKindName(d) == "Function"]
    @test length(fns) == 2

    @assert f(I, "semaD4Tmpl") "lookup failed: semaD4Tmpl"
    tmpl = CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate"))

    # The argument expressions come out of a parsed body: `n` is an int lvalue, `d` a class
    # lvalue usable as an implicit object argument, `t` the ADL-associating argument.
    @assert f(I, "semaD4Body") "lookup failed: semaD4Body"
    refs = [n for n in CC.subtree(CC.getBody(CC.FunctionDecl(get_decl(f))))
            if n isa CC.DeclRefExpr]
    int_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "n")
    obj_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "d")
    tag_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "t")
    int_qt = CC.getType(int_arg)

    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    is_op_new(d) = d isa CC.FunctionDecl && CC.getNameAsString(d) == "operator new"
    # Build the name from the DeclarationNameTable rather than hunting for a declaration:
    # whether the new-expression above leaves a global operator new in the translation
    # unit's own decl list depends on how the interpreter's -nostdinc TU was set up.
    op_new_name = CC.getCXXOperatorName(CC.getDeclarationNames(ctx),
                                        CC.CXOverloadedOperatorKind_OO_New)
    adl_fn = first(d for d in CC.decls(tu_dc)
                   if d isa CC.FunctionDecl && CC.getNameAsString(d) == "adlPick")
    adl_name = CC.getDeclName(adl_fn)

    # --- Hidden virtual methods: the -Woverloaded-virtual walk without the warning ---
    hidden_bases = CC.FindHiddenVirtualMethods(sema, hidden_md)
    @test hidden_bases isa Vector{CC.CXXMethodDecl}
    @test !isempty(hidden_bases)
    @test all(m -> CC.getNameAsString(m) == "hidden", hidden_bases)
    @test all(m -> CC.getParent(m).ptr != derived.ptr, hidden_bases)
    # A name no base declares can hide nothing, whatever the base walk finds.
    @test isempty(CC.FindHiddenVirtualMethods(sema, member_md))

    # --- Candidate collection: each collector only grows the set handed to it ---
    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    @test CC.empty(cs)
    CC.AddOverloadCandidate(sema, fns[1], fns[1], CC.CXAccessSpecifier_AS_none, [int_arg],
                            cs)
    @test size(cs) == 1
    CC.AddOverloadCandidate(sema, fns[2], fns[2], CC.CXAccessSpecifier_AS_none, [int_arg],
                            cs)
    @test size(cs) == 2
    @test !CC.empty(cs)
    CC.dispose(cs)

    fn_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddFunctionCandidates(sema, fns, fill(CC.CXAccessSpecifier_AS_none, length(fns)),
                             [int_arg], fn_set)
    @test size(fn_set) == length(fns)
    @test_throws AssertionError CC.AddFunctionCandidates(sema, fns,
                                                         CC.CXAccessSpecifier[], [int_arg],
                                                         fn_set)
    CC.dispose(fn_set)

    tmpl_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddTemplateOverloadCandidate(sema, tmpl, tmpl, CC.CXAccessSpecifier_AS_none,
                                    [int_arg], tmpl_set)
    @test size(tmpl_set) == 1
    CC.dispose(tmpl_set)

    method_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddMethodCandidate(sema, member_md, member_md, CC.CXAccessSpecifier_AS_public,
                          derived, obj_arg, [int_arg], method_set)
    @test size(method_set) == 1
    CC.dispose(method_set)

    member_ops = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator)
    CC.AddMemberOperatorCandidates(sema, CC.CXOverloadedOperatorKind_OO_Plus, loc,
                                   [obj_arg, int_arg], member_ops)
    @test size(member_ops) >= 1
    @test_throws AssertionError CC.AddMemberOperatorCandidates(sema,
                                                               CC.CXOverloadedOperatorKind_OO_Plus,
                                                               loc, CC.DeclRefExpr[],
                                                               member_ops)
    CC.dispose(member_ops)

    builtins = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator)
    CC.AddBuiltinOperatorCandidates(sema, CC.CXOverloadedOperatorKind_OO_Plus, loc,
                                    [int_arg, int_arg], builtins)
    @test size(builtins) > 0
    # The operators with no built-in forms abort clang outright, so the wrapper rejects
    # them before the ccall.
    @test_throws AssertionError CC.AddBuiltinOperatorCandidates(sema,
                                                                CC.CXOverloadedOperatorKind_OO_New,
                                                                loc, [int_arg], builtins)
    CC.dispose(builtins)

    one_builtin = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator)
    CC.AddBuiltinCandidate(sema, [int_qt, int_qt], [int_arg, int_arg], one_builtin)
    @test size(one_builtin) == 1
    @test_throws AssertionError CC.AddBuiltinCandidate(sema, [int_qt], [int_arg, int_arg],
                                                       one_builtin)
    CC.dispose(one_builtin)

    adl = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddArgumentDependentLookupCandidates(sema, adl_name, loc, [tag_arg], adl)
    @test size(adl) >= 1
    CC.dispose(adl)

    # --- Global allocation functions ---
    @test CC.getCPlusPlus11(CC.getLangOpts(sema))
    @test CC.getCXXOverloadedOperator(op_new_name) == CC.CXOverloadedOperatorKind_OO_New
    void_ptr = CC.get_qual_type(CC.VoidPtrTy(ctx))
    before = count(is_op_new, CC.decls(tu_dc))
    # A parameter list clang has not declared yet, so this really declares something —
    # and it gives the rest of this block a global operator new to work from, which the
    # interpreter's -nostdinc translation unit does not otherwise expose.
    CC.DeclareGlobalAllocationFunction(sema, op_new_name, void_ptr,
                                       [CC.getSizeType(ctx), CC.getIntPtrType(ctx)])
    @test count(is_op_new, CC.decls(tu_dc)) > before

    op_new = first(d for d in CC.decls(tu_dc) if is_op_new(d))
    @test !(CC.isReplaceableGlobalAllocationFunction(op_new))
    @test_throws AssertionError CC.AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(sema,
                                                                                                    fns[1])
    @test_throws AssertionError CC.DeclareGlobalAllocationFunction(sema,
                                                                   CC.getDeclName(fns[1]),
                                                                   void_ptr)

    failed, del_fn = CC.FindDeallocationFunction(sema, loc, rec, del_name)
    @test failed isa Bool
    @test !failed
    @test del_fn isa CC.FunctionDecl
    @test del_fn.ptr != C_NULL
    @test CC.getNameAsString(del_fn) == "operator delete"

    dispose(f)
    dispose(I)
end

@testset "Sema | weak declarations, capture and ADL queries, and the remaining conversions" begin
    # A throwaway interpreter: the conversions below add implicit-cast nodes to the AST, the
    # special-member lookup declares implicit members and the invented parameter names are
    # interned in the identifier table, so none of it may leak into the interpreter the other
    # test files share.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             struct SemaMiscS { int a; };
             struct SemaMiscTrivial { int a; };
             SemaMiscS operator+(SemaMiscS, SemaMiscS);
             typedef float SemaMiscVec4 __attribute__((ext_vector_type(4)));
             int semaMiscGlobal = 0;
             int semaMiscCallee(int n);
             void semaMiscVarArgs(const char *fmt, ...);
             int semaMiscFn(int n) { double d = 1.0; int b = semaMiscCallee(n); return b + (int)d; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    sc = CC.getCurScope(CC.get_parser(I))
    @test sc isa CC.Scope
    f = DeclFinder(I)

    # All name lookups happen up front: the special-member work below declares implicit
    # members, and get_decl throws once a name resolves to more than one declaration.
    @assert f(I, "semaMiscGlobal") "lookup failed: semaMiscGlobal"
    global_var = CC.VarDecl(get_decl(f))
    int_qt = CC.getType(global_var)

    @assert f(I, "SemaMiscVec4") "lookup failed: SemaMiscVec4"
    vec_qt = CC.getTypeDeclType(ctx, CC.TypeDecl(get_decl(f)))
    @test CC.isVectorType(CC.getTypePtr(vec_qt))

    @assert f(I, "semaMiscVarArgs") "lookup failed: semaMiscVarArgs"
    varargs_fn = CC.FunctionDecl(get_decl(f))

    @assert f(I, "SemaMiscTrivial") "lookup failed: SemaMiscTrivial"
    trivial_cls = CC.CXXRecordDecl(get_decl(f))

    @assert f(I, "semaMiscFn") "lookup failed: semaMiscFn"
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    fn_ref = first(n for n in nodes
                   if n isa CC.DeclRefExpr &&
        CC.isFunctionType(CC.getTypePtr(CC.getType(n))))
    int_ref = first(n for n in nodes
                    if n isa CC.DeclRefExpr && CC.isIntegerType(CC.getTypePtr(CC.getType(n))))
    dbl_ref = first(n for n in nodes
                    if n isa CC.DeclRefExpr &&
        CC.isFloatingType(CC.getTypePtr(CC.getType(n))))

    # --- Weak top-level declarations (count + index) ---
    nweak = CC.getNumWeakTopLevelDecls(sema)
    @test nweak == 0
    for i = 0:(Int(nweak) - 1)
        d = CC.getWeakTopLevelDecl(sema, i)
        @test d isa CC.Decl
        @test !CC.is_null_handle(d)
    end
    @test_throws AssertionError CC.getWeakTopLevelDecl(sema, nweak)

    # --- Invented abbreviated-template parameter names ---
    named_ii = CC.getIdentifierInfo(pp, "SemaMiscT")
    invented = CC.InventAbbreviatedTemplateParameterTypeName(sema, named_ii, 0)
    @test invented isa CC.IdentifierInfo
    @test invented.ptr != C_NULL
    anonymous = CC.InventAbbreviatedTemplateParameterTypeName(sema, nothing, 0)
    @test anonymous isa CC.IdentifierInfo
    @test anonymous.ptr != C_NULL
    @test CC.getName(invented) isa AbstractString
    @test CC.getName(anonymous) isa AbstractString
    @test CC.getName(invented) != CC.getName(anonymous)

    # --- Template-name plausibility ---
    might, dependent = CC.mightBeIntendedToBeTemplateName(sema, int_ref)
    @test might isa Bool
    @test dependent isa Bool

    # --- Local-extern context adjustment (a static member, so no Sema receiver) ---
    tu_adjusted = CC.adjustContextForLocalExternDecl(tu)
    @test tu_adjusted === nothing || tu_adjusted isa CC.DeclContext
    fn_adjusted = CC.adjustContextForLocalExternDecl(CC.castToDeclContext(fd))
    @test fn_adjusted === nothing || fn_adjusted isa CC.DeclContext

    # --- Capture and ADL queries ---
    @test !(CC.NeedToCaptureVariable(sema, global_var, loc))

    ss = CC.CXXScopeSpec()
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "semaMiscCallee")),
                        loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, r, tu)
    @test CC.UseArgumentDependentLookup(sema, ss, r, true)
    @test !(CC.UseArgumentDependentLookup(sema, ss, r, false))
    CC.dispose(r)
    CC.dispose(ss)

    ops = CC.LookupBinOp(sema, sc, loc, CC.CXBinaryOperatorKind_BO_Add)
    @test ops isa Vector{CC.NamedDecl}
    @test all(d -> d isa CC.NamedDecl && d.ptr != C_NULL, ops)

    # --- Pragma-driven floating-point state ---
    @test CC.CurFPFeatureOverrides(sema) == 0

    # --- The vector predicate family's remaining member ---
    @test !(CC.anyAltivecTypes(sema, vec_qt, int_qt))
    @test_throws AssertionError CC.anyAltivecTypes(sema, int_qt, int_qt)

    # --- Standard conversions ---
    callee_conv = CC.CallExprUnaryConversions(sema, fn_ref)
    @test callee_conv isa CC.Expr_
    @test CC.isPointerType(CC.getTypePtr(CC.getType(callee_conv)))

    int_prvalue = CC.DefaultLvalueConversion(sema, int_ref)
    @test int_prvalue isa CC.Expr_
    @test CC.isPRValue(int_prvalue)

    materialized = CC.TemporaryMaterializationConversion(sema, int_prvalue)
    @test materialized isa CC.Expr_
    @test CC.getType(materialized).ptr != C_NULL

    va_promoted = CC.DefaultVariadicArgumentPromotion(sema, int_ref,
                                                      CC.CXVariadicCallType_VariadicFunction,
                                                      varargs_fn)
    @test va_promoted isa CC.Expr_
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(va_promoted)))
    @test CC.DefaultVariadicArgumentPromotion(sema, int_ref,
                                              CC.CXVariadicCallType_VariadicDoesNotApply) isa
          CC.Expr_

    uac = CC.UsualArithmeticConversions(sema, int_ref, dbl_ref, loc,
                                        CC.CXArithConvKind_ACK_Arithmetic)
    @test uac !== nothing
    common_qt, uac_lhs, uac_rhs = uac
    @test common_qt isa CC.QualType
    @test common_qt.ptr != C_NULL
    @test uac_lhs isa CC.Expr_
    @test uac_rhs isa CC.Expr_
    @test CC.UsualArithmeticConversions(sema, int_ref, dbl_ref, loc,
                                        CC.CXArithConvKind_ACK_Comparison) !== nothing

    splat = CC.prepareVectorSplat(sema, vec_qt, int_prvalue)
    @test splat isa CC.Expr_
    @test CC.getType(splat).ptr != C_NULL
    @test_throws AssertionError CC.prepareVectorSplat(sema, int_qt, int_prvalue)
    @test_throws AssertionError CC.prepareVectorSplat(sema, vec_qt, int_ref)

    # --- Special-member triviality (declares the implicit default constructor) ---
    ctor = CC.LookupDefaultConstructor(sema, trivial_cls)
    @test ctor isa CC.CXXConstructorDecl
    @test ctor.ptr != C_NULL
    @test CC.SpecialMemberIsTrivial(sema, ctor,
                                    CC.CXCXXSpecialMember_CXXDefaultConstructor) isa Bool
    @test CC.SpecialMemberIsTrivial(sema, ctor,
                                    CC.CXCXXSpecialMember_CXXDefaultConstructor,
                                    CC.CXTrivialABIHandling_TAH_ConsiderTrivialABI) isa Bool
    @test_throws AssertionError CC.SpecialMemberIsTrivial(sema, ctor,
                                                          CC.CXCXXSpecialMember_CXXInvalid)

    dispose(f)
    dispose(I)
end

@testset "Sema | module, access, coroutine, OpenMP and dialect state queries" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)

    CC.parse(I, """
    struct SemaQ5Rec {
        int q5PublicField;
    };
    SemaQ5Rec semaQ5RecVar;
    int semaQ5Init = 7;
    int semaQ5Varargs(int, ...);
    int semaQ5Plain(int);
    """)

    f = DeclFinder(I)

    # --- The record, its type and its one public field ---
    @test f(I, "semaQ5RecVar")
    rec_var = CC.VarDecl(get_decl(f))
    rec_ty = CC.getType(rec_var)
    @test rec_ty isa CC.QualType
    @test rec_ty.ptr != C_NULL
    rec = CC.getAsCXXRecordDecl(CC.getTypePtr(rec_ty))
    @test rec isa CC.CXXRecordDecl
    @test rec.ptr != C_NULL
    field = first(CC.getFields(rec))
    @test field isa CC.FieldDecl
    @test CC.getName(field) == "q5PublicField"

    # --- Module ownership and access from Sema's current context ---
    @test CC.IsRedefinitionInModule(sema, field, field)
    @test CC.IsSimplyAccessible(sema, field, rec, rec_ty)

    # --- Decl-shaped predicates ---
    @test f(I, "semaQ5Plain")
    plain_fd = CC.FunctionDecl(get_decl(f))
    # the clang method is `D && isa<ObjCMethodDecl>(D)`, so a C++ function is never one
    @test CC.isObjCMethodDecl(sema, plain_fd) == false
    @test CC.canSkipFunctionBody(sema, plain_fd)
    @test !(CC.ShouldWarnIfUnusedFileScopedDecl(sema, rec_var))
    @test CC.getNonOdrUseReasonInCurrentContext(sema, rec_var) isa CC.CXNonOdrUseReason
    @test !CC.is_null_handle(CC.getTopMostPointOfInstantiation(sema, plain_fd))
    @test !(CC.CanBeGetReturnTypeOnAllocFailure(plain_fd))
    @test CC.isCUDAImplicitHostDeviceFunction(plain_fd) == false

    # --- Expression-shaped predicates ---
    @test f(I, "semaQ5Init")
    init = CC.getInit(CC.VarDecl(get_decl(f)))
    @test init isa CC.Expr_
    @test !(CC.isQualifiedMemberAccess(sema, init))

    # --- Function prototypes: variadic classification and the lambda invoker type ---
    @test f(I, "semaQ5Varargs")
    va_fd = CC.FunctionDecl(get_decl(f))
    va_proto = CC.resolve(CC.getTypePtr(CC.getType(va_fd)))
    @test va_proto isa CC.FunctionProtoType
    @test CC.getVariadicCallType(sema, va_proto) isa CC.CXVariadicCallType
    @test CC.getVariadicCallType(sema, va_proto, va_fd) isa CC.CXVariadicCallType
    @test CC.getVariadicCallType(sema, va_proto, va_fd, init) isa CC.CXVariadicCallType
    plain_proto = CC.resolve(CC.getTypePtr(CC.getType(plain_fd)))
    @test plain_proto isa CC.FunctionProtoType
    @test CC.getVariadicCallType(sema, plain_proto, plain_fd) isa CC.CXVariadicCallType

    # a free function's prototype carries no ref-qualifier, so the invoker assert holds
    @test CC.getRefQualifier(plain_proto) == CC.CXRefQualifierKind_RQ_None
    conv_ty = CC.getLambdaConversionFunctionResultType(sema, plain_proto,
                                                       CC.CXCallingConv_CC_C)
    @test conv_ty isa CC.QualType
    @test conv_ty.ptr != C_NULL

    # --- Sema state that is defined between parses ---
    @test CC.isSFINAEContext(sema) isa Union{Nothing,CC.TemplateDeductionInfo}
    # no OpenMP pragma has been parsed, so both assume stacks are empty
    @test CC.isInOpenMPAssumeScope(sema) == false
    @test CC.hasGlobalOpenMPAssumes(sema) == false

    # isCast is a pure function of the enumerator: the three cast kinds and nothing else
    @test CC.isCast(CC.CXCheckedConversionKind_CCK_CStyleCast)
    @test CC.isCast(CC.CXCheckedConversionKind_CCK_FunctionalCast)
    @test CC.isCast(CC.CXCheckedConversionKind_CCK_OtherCast)
    @test CC.isCast(CC.CXCheckedConversionKind_CCK_ImplicitConversion) == false
    @test CC.isCast(CC.CXCheckedConversionKind_CCK_ForBuiltinOverloadedOp) == false

    # --- Target- and dialect-decided answers (never a specific value: CI is three hosts) ---
    # Only Mach-O imposes a grammar on a section name -- it wants `segment,section`, and
    # clang returns success unconditionally for every other object format. So there is no
    # spelling that is invalid on all three runners, but the answer is not unassertable
    # either: which runner this is decides it, and `Sys.isapple()` is that. Asserting only
    # the shape here left a validator that accepts everything indistinguishable from a
    # working one.
    @test CC.isValidSectionSpecifier(sema, "__TEXT,__text") == true
    @test CC.isValidSectionSpecifier(sema, "not a section specifier") == !Sys.isapple()
    cuda_name = CC.getCudaConfigureFuncName(sema)
    @test cuda_name isa String
    @test !isempty(cuda_name)

    nserror = CC.getNSErrorIdent(sema)
    @test nserror isa CC.IdentifierInfo
    @test nserror.ptr != C_NULL
    @test CC.getName(nserror) == "NSError"
    super = CC.getSuperIdentifier(sema)
    @test super isa CC.IdentifierInfo
    @test super.ptr != C_NULL
    @test CC.getName(super) isa String

    dispose(f)
    dispose(I)
end

@testset "Sema | overloaded-operator calls, default initializers and member initializers" begin
    # A throwaway interpreter: every builder below allocates AST nodes into the context and
    # marks the operators it resolves as referenced, so none of it may leak into the
    # interpreter the other test files share.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             struct SemaB5Inner { int v; };
             struct SemaB5Ops {
                 SemaB5Inner *p;
                 int operator[](int i) const { return i; }
                 int operator()(int i) const { return i + 1; }
                 SemaB5Inner *operator->() const { return p; }
                 operator int() const { return 3; }
             };
             struct SemaB5Field { int a = 42; int b; };
             int semaB5Callee(int a, int b = 7) { return a + b; }
             void semaB5Sink();
             int semaB5Probe(SemaB5Ops &o, int n) {
                 [[clang::nomerge]] semaB5Sink();
                 return o[n] + semaB5Callee(n);
             }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    sc = CC.getCurScope(CC.get_parser(I))
    f = DeclFinder(I)

    # Every lookup happens up front: the builders below declare implicit special members,
    # and get_decl throws once a name resolves to more than one declaration.
    @assert f(I, "SemaB5Ops") "lookup failed: SemaB5Ops"
    ops_rd = CC.CXXRecordDecl(get_decl(f))
    @assert f(I, "SemaB5Field") "lookup failed: SemaB5Field"
    field_rd = CC.CXXRecordDecl(get_decl(f))
    @assert f(I, "semaB5Callee") "lookup failed: semaB5Callee"
    callee = CC.FunctionDecl(get_decl(f))
    @assert f(I, "semaB5Probe") "lookup failed: semaB5Probe"
    probe = CC.FunctionDecl(get_decl(f))

    nodes = CC.subtree(CC.getBody(probe))
    drefs = filter(n -> n isa CC.DeclRefExpr, nodes)
    obj_ref = first(d for d in drefs if CC.isRecordType(CC.getTypePtr(CC.getType(d))))
    int_ref = first(d for d in drefs if CC.isIntegerType(CC.getTypePtr(CC.getType(d))))
    fn_ref = first(d for d in drefs if CC.getNameAsString(CC.getDecl(d)) == "semaB5Callee")

    # --- Overloaded subscript: `o[n]` resolves to the member operator[], which returns int
    sub_expr = CC.CreateOverloadedArraySubscriptExpr(sema, loc, loc, obj_ref, [int_ref])
    @test sub_expr isa CC.Expr_
    @test sub_expr.ptr != C_NULL
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(sub_expr)))
    @test_throws AssertionError CC.CreateOverloadedArraySubscriptExpr(sema, loc, loc,
                                                                      int_ref, [int_ref])

    # --- Overloaded call: `o(n)` resolves to the member operator(), which returns int
    call_obj = CC.BuildCallToObjectOfClassType(sema, sc, obj_ref, loc, [int_ref], loc)
    @test call_obj isa CC.Expr_
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(call_obj)))
    @test_throws AssertionError CC.BuildCallToObjectOfClassType(sema, sc, int_ref, loc,
                                                                [int_ref], loc)

    # --- Overloaded arrow: one step, so the result is the SemaB5Inner* operator-> returns
    arrow, no_arrow = CC.BuildOverloadedArrowExpr(sema, sc, obj_ref, loc)
    @test no_arrow isa Bool
    @test arrow isa CC.Expr_
    @test CC.isPointerType(CC.getTypePtr(CC.getType(arrow)))
    @test_throws AssertionError CC.BuildOverloadedArrowExpr(sema, sc, int_ref, loc)

    # --- Conversion-function call: `o` converted through operator int() const
    conv = first(m for m in CC.getMethods(ops_rd) if CC.getDeclKindName(m) == "CXXConversion")
    conv_decl = CC.CXXConversionDecl(conv)
    mcall = CC.BuildCXXMemberCallExpr(sema, obj_ref, conv_decl, conv_decl)
    @test mcall isa CC.Expr_
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(mcall)))
    @test CC.BuildCXXMemberCallExpr(sema, obj_ref, conv_decl, conv_decl, true) isa CC.Expr_
    @test_throws AssertionError CC.BuildCXXMemberCallExpr(sema, int_ref, conv_decl,
                                                          conv_decl)

    # --- Statement attributes: the parsed AttributedStmt's own attributes rebuild it
    astmt = only(filter(n -> n isa CC.AttributedStmt, nodes))
    attrs = CC.getAttrs(astmt)
    @test !isempty(attrs)
    aloc = CC.getAttrLoc(astmt)
    sub = CC.getSubStmt(astmt)
    rebuilt = CC.BuildAttributedStmt(sema, aloc, attrs, sub)
    @test rebuilt isa CC.Stmt
    @test CC.resolve(rebuilt) isa CC.AttributedStmt
    @test CC.getNumAttrs(CC.resolve(rebuilt)) == length(attrs)
    @test_throws AssertionError CC.BuildAttributedStmt(sema, aloc, CC.Attr[], sub)

    # --- _Generic over the controlling expression, with `default` spelled as a null slot
    int_qt = CC.getType(int_ref)
    int_tsi = CC.getTrivialTypeSourceInfo(ctx, int_qt, loc)
    generic = CC.CreateGenericSelectionExpr(sema, loc, loc, loc, int_ref,
                                            [int_tsi, nothing], [int_ref, int_ref])
    @test generic isa CC.Expr_
    @test CC.resolve(generic) isa CC.GenericSelectionExpr
    @test_throws AssertionError CC.CreateGenericSelectionExpr(sema, loc, loc, loc, int_ref,
                                                              [int_tsi], [int_ref, int_ref])

    # --- A resolved call, with the ADL flag round-tripping through the node
    resolved = CC.BuildResolvedCallExpr(sema, fn_ref, callee, loc, [int_ref, int_ref], loc)
    @test resolved isa CC.Expr_
    resolved_node = CC.resolve(resolved)
    @test resolved_node isa CC.AbstractCallExpr
    @test CC.usesADL(resolved_node) == false
    adl_call = CC.BuildResolvedCallExpr(sema, fn_ref, callee, loc, [int_ref, int_ref], loc,
                                        CC.Expr_(C_NULL), false, true)
    @test adl_call isa CC.Expr_
    @test CC.usesADL(CC.resolve(adl_call)) == true

    # --- Default arguments and in-class initializers
    param_b = CC.getParamDecl(callee, 1)
    @test CC.hasDefaultArg(param_b)
    darg = CC.BuildCXXDefaultArgExpr(sema, loc, callee, param_b)
    @test darg isa CC.Expr_
    @test CC.resolve(darg) isa CC.CXXDefaultArgExpr
    @test_throws AssertionError CC.BuildCXXDefaultArgExpr(sema, loc, callee,
                                                          CC.getParamDecl(callee, 0))

    fields = CC.getFields(field_rd)
    @test length(fields) == 2
    with_init, without_init = fields[1], fields[2]
    @test CC.hasInClassInitializer(with_init)
    dinit = CC.BuildCXXDefaultInitExpr(sema, loc, with_init)
    @test dinit isa CC.Expr_
    @test CC.resolve(dinit) isa CC.CXXDefaultInitExpr
    @test_throws AssertionError CC.BuildCXXDefaultInitExpr(sema, loc, without_init)

    # --- A member initializer built from a literal the test itself makes.
    # IntegerLiteral::Create takes the APInt through the LLVMGenericValueRef bridge
    # (MARSHALLING.md §1), not a Julia integer, so the value is built as one first.
    gv = CC.LLVM.API.LLVMCreateGenericValueOfInt(CC.LLVM.API.LLVMInt32Type(), 5, 0)
    literal = CC.IntegerLiteral(ctx, gv, CC.getType(without_init), loc)
    meminit = CC.BuildMemberInitializer(sema, without_init, literal, loc)
    @test meminit isa CC.CXXCtorInitializer
    @test meminit.ptr != C_NULL
    @test CC.isMemberInitializer(meminit)
    @test CC.getMember(meminit).ptr == without_init.ptr
    CC.LLVM.API.LLVMDisposeGenericValue(gv)

    dispose(f)
    dispose(I)
end

@testset "Sema operator-operand checks, ext-vector casts and deferred member checks" begin
    # A throwaway interpreter: every check below inserts implicit conversions into the
    # ASTContext, so nothing here may leak into the interpreter the other files share.
    I = create_interpreter(String[])
    CC.parse(I, """
             const int semaChkEight = 8;
             const int semaChkTwo = 2;
             int semaChkGlobal = 3;
             int *semaChkAddr = &semaChkGlobal;
             struct SemaChkPBase { int semaChkPm; };
             struct SemaChkPDer : SemaChkPBase {};
             int SemaChkPDer::*semaChkPmDer = &SemaChkPBase::semaChkPm;
             int semaChkPtmFn(SemaChkPBase &r, int SemaChkPBase::*p) { return r.*p; }
             struct SemaChkVBase { virtual void semaChkVirt(); };
             struct SemaChkVDer : SemaChkVBase { void semaChkVirt() override; };
             int semaChkPlain(int n) { return n; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    rng = CC.SourceRange(loc, loc)
    f = DeclFinder(I)

    # Two integer-literal prvalues taken from the parse, so every operand below is a node
    # clang built and accepted itself.
    @test f(I, "semaChkEight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaChkTwo")
    two = CC.getInit(CC.VarDecl(get_decl(f)))
    int_qt = CC.getType(eight)
    @test CC.isIntegerType(CC.getTypePtr(int_qt))

    # --- Arithmetic, shift and comparison operands ------------------------------------
    mul = CC.CheckMultiplyDivideOperands(sema, eight, two, loc)
    @test mul !== nothing
    mul_ty, mul_l, mul_r = mul
    @test mul_ty isa CC.QualType
    @test CC.isIntegerType(CC.getTypePtr(mul_ty))
    @test mul_l isa CC.Expr_
    @test mul_r isa CC.Expr_
    @test CC.CheckMultiplyDivideOperands(sema, eight, two, loc, false, true) !== nothing

    rem = CC.CheckRemainderOperands(sema, eight, two, loc)
    @test rem !== nothing
    @test CC.isIntegerType(CC.getTypePtr(rem[1]))

    add = CC.CheckAdditionOperands(sema, eight, two, loc,
                                   CC.LibClangEx.CXBinaryOperatorKind_BO_Add)
    @test add !== nothing
    add_ty, add_l, add_r, add_comp = add
    @test CC.isIntegerType(CC.getTypePtr(add_ty))
    @test add_l isa CC.Expr_
    @test add_r isa CC.Expr_
    # the compound-assignment slot is only filled when the caller asks for it
    @test add_comp === nothing
    add_ca = CC.CheckAdditionOperands(sema, eight, two, loc,
                                      CC.LibClangEx.CXBinaryOperatorKind_BO_AddAssign, true)
    @test add_ca !== nothing
    @test add_ca[4] isa CC.QualType

    sub = CC.CheckSubtractionOperands(sema, eight, two, loc)
    @test sub !== nothing
    @test CC.isIntegerType(CC.getTypePtr(sub[1]))
    @test sub[4] === nothing
    sub_ca = CC.CheckSubtractionOperands(sema, eight, two, loc, true)
    @test sub_ca !== nothing
    @test sub_ca[4] isa CC.QualType

    shl = CC.CheckShiftOperands(sema, eight, two, loc,
                                CC.LibClangEx.CXBinaryOperatorKind_BO_Shl)
    @test shl !== nothing
    @test CC.isIntegerType(CC.getTypePtr(shl[1]))

    cmp = CC.CheckCompareOperands(sema, eight, two, loc,
                                  CC.LibClangEx.CXBinaryOperatorKind_BO_LT)
    @test cmp !== nothing
    @test cmp[1] isa CC.QualType
    @test cmp[1].ptr != C_NULL

    # Neither operand is a pointer, so the '\0'-comparison warning returns before firing.
    null_cmp = CC.CheckPtrComparisonWithNullChar(sema, eight, two)
    @test null_cmp !== nothing
    @test null_cmp[1] isa CC.Expr_
    @test null_cmp[2] isa CC.Expr_

    # --- Assignment and address-of, over a modifiable global lvalue --------------------
    @test f(I, "semaChkAddr")
    addr_init = CC.getInit(CC.VarDecl(get_decl(f)))
    addr_of = first(n for n in CC.subtree(addr_init) if n isa CC.UnaryOperator)
    g_ref = CC.getSubExpr(addr_of)
    @test g_ref isa CC.Expr_
    @test CC.isLValue(g_ref)
    @test CC.isModifiableLvalue(g_ref, ctx) == CC.LibClangEx.CXExpr_MLV_Valid

    asn = CC.CheckAssignmentOperands(sema, g_ref, eight, loc)
    @test asn !== nothing
    asn_ty, asn_rhs = asn
    @test CC.isIntegerType(CC.getTypePtr(asn_ty))
    @test asn_rhs isa CC.Expr_
    # an integer literal is a prvalue, so it is not assignable
    @test_throws AssertionError CC.CheckAssignmentOperands(sema, eight, two, loc)

    aof = CC.CheckAddressOfOperand(sema, g_ref, loc)
    @test aof !== nothing
    aof_ty, aof_op = aof
    @test CC.isPointerType(CC.getTypePtr(aof_ty))
    @test aof_op isa CC.Expr_
    @test_throws AssertionError CC.CheckAddressOfOperand(sema, eight, loc)

    # --- .* operands, taken from the `r.*p` clang itself built -------------------------
    @test f(I, "semaChkPtmFn")
    ptm_fd = CC.FunctionDecl(get_decl(f))
    ptm = first(n
                for n in CC.subtree(CC.getBody(ptm_fd))
                if n isa CC.BinaryOperator &&
        CC.getOpcode(n) == CC.LibClangEx.CXBinaryOperatorKind_BO_PtrMemD)
    ptm_res = CC.CheckPointerToMemberOperands(sema, CC.getLHS(ptm), CC.getRHS(ptm), loc)
    @test ptm_res !== nothing
    ptm_ty, ptm_l, ptm_r, ptm_vk = ptm_res
    @test CC.isIntegerType(CC.getTypePtr(ptm_ty))
    @test ptm_l isa CC.Expr_
    @test ptm_r isa CC.Expr_
    @test ptm_vk isa CC.LibClangEx.CXExprValueKind
    @test_throws AssertionError CC.CheckPointerToMemberOperands(sema, eight, two, loc)

    # --- Ext-vector cast: a scalar prvalue splatted across the destination -------------
    extvec_qt = CC.BuildExtVectorType(sema, int_qt, two, loc)
    @test extvec_qt.ptr != C_NULL
    @test CC.isExtVectorType(CC.getTypePtr(extvec_qt))
    evc = CC.CheckExtVectorCast(sema, rng, extvec_qt, eight)
    @test evc !== nothing
    evc_expr, evc_kind = evc
    @test evc_expr isa CC.Expr_
    @test evc_kind isa CC.LibClangEx.CXCastKind
    @test_throws AssertionError CC.CheckExtVectorCast(sema, rng, int_qt, eight)

    # --- Member-pointer conversion: the base -> derived step clang already performed ---
    @test f(I, "semaChkPmDer")
    pm_vd = CC.VarDecl(get_decl(f))
    pm_to = CC.getType(pm_vd)
    pm_from = first(n for n in CC.subtree(CC.getInit(pm_vd)) if n isa CC.UnaryOperator)
    @test CC.isMemberPointerType(CC.getTypePtr(CC.getType(pm_from)))
    pm_failed, pm_kind = CC.CheckMemberPointerConversion(sema, pm_from, pm_to)
    @test pm_failed isa Bool
    @test pm_kind isa CC.LibClangEx.CXCastKind
    @test_throws AssertionError CC.CheckMemberPointerConversion(sema, pm_from, int_qt)

    # --- Declaration-level checks -----------------------------------------------------
    @test f(I, "SemaChkVBase")
    vbase = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "SemaChkVDer")
    vder = CC.CXXRecordDecl(get_decl(f))
    base_m = first(m for m in CC.getMethods(vbase)
                   if CC.getNameAsString(m) == "semaChkVirt")
    der_m = first(m for m in CC.getMethods(vder) if CC.getNameAsString(m) == "semaChkVirt")
    # neither overrider has an explicit object parameter, so nothing is diagnosed
    @test CC.CheckExplicitObjectOverride(sema, der_m, base_m)

    @test f(I, "semaChkPlain")
    plain_fd = CC.FunctionDecl(get_decl(f))
    # `int` is not a coroutine-return record type, so this returns before any diagnostic
    @test CC.CheckCoroutineWrapper(sema, plain_fd) === nothing

    # both deferred exception-spec lists are empty between parses
    @test CC.CheckDelayedMemberExceptionSpecs(sema) === nothing

    dispose(f)
    dispose(I)
end

@testset "Sema | substituting declarations, parameters and template names" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)

    CC.parse(I, """
    template <typename SemaTmplH>
    struct SemaTmplHolder { SemaTmplH held; };

    template <typename SemaTmplT>
    struct SemaTmplPattern {
        SemaTmplT value;
        SemaTmplHolder<SemaTmplT> boxed;
        typedef SemaTmplT SemaTmplAlias;
        static const unsigned width = sizeof(SemaTmplT);
        void method(SemaTmplT p, int q);
    };
    """)

    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    # Select by kind rather than by uniqueness: a template's own name stops resolving to a
    # single decl as soon as anything specialises it, and get_decl throws on that.
    @test f(I, "SemaTmplPattern")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    rd = CC.getTemplatedDecl(ctd)
    rd_dc = CC.castToDeclContext(rd)
    loc = CC.getLocation(ctd)

    # one substituted level, SemaTmplT -> int, owned by the class template itself
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    arg = CC.TemplateArgument(int_qt)
    ml = CC.MultiLevelTemplateArgumentList()
    CC.addOuterTemplateArguments(ml, ctd, [arg], true)

    base_contexts = CC.getNumCodeSynthesisContexts(sema)
    inst = CC.InstantiatingTemplate(sema, loc, ctd)
    @test CC.isInvalid(inst) == false

    method = CC.CXXMethodDecl(first(d for d in CC.decls(rd_dc) if CC.getDeclKindName(d) == "CXXMethod"))

    # Rebuilding a declaration, unlike rebuilding a type, also writes the pattern-to-instance
    # mapping through Sema::CurrentInstantiationScope with no null check. Outside the parser
    # nothing has opened one, so the wrapper must reject the call rather than segfault.
    base_scope = CC.hasCurrentInstantiationScope(sema)
    @test base_scope isa Bool
    if !base_scope
        @test_throws AssertionError CC.SubstDecl(sema, method, tu_dc, ml)
    end

    scope = CC.LocalInstantiationScope(sema)
    @test scope isa CC.LocalInstantiationScope
    @test scope.ptr != C_NULL
    @test CC.hasCurrentInstantiationScope(sema)

    # --- function types, parameters and exception specifications ---
    subst_fn_tsi = CC.SubstFunctionDeclType(sema, CC.getTypeSourceInfo(method), ml, loc)
    @test subst_fn_tsi isa CC.TypeSourceInfo
    @test subst_fn_tsi.ptr != C_NULL

    parm = CC.getParamDecl(method, 0)
    new_parm = CC.SubstParmVarDecl(sema, parm, ml)
    @test new_parm isa CC.ParmVarDecl
    @test new_parm.ptr != C_NULL
    # the pattern declared `SemaTmplT p`; substituting the argument in makes it an int
    @test CC.isIntegerType(CC.getTypePtr(CC.getType(new_parm)))

    proto = CC.resolve(CC.getTypePtr(CC.getType(method)))
    @test proto isa CC.FunctionProtoType
    # the pattern writes no exception specification, so this is the no-op path: clang
    # reinstalls the same absent specification on the function and its redeclarations
    @test CC.SubstExceptionSpec(sema, method, proto, ml) === nothing

    # --- expression lists ---
    width = first(d for d in CC.decls(rd_dc) if d isa CC.VarDecl)
    substituted = CC.SubstExprs(sema, [CC.getInit(width)], false, ml)
    @test substituted isa Vector{CC.Expr_}
    # nothing in the input is a pack expansion, so the result is one node per input
    @test length(substituted) == 1
    @test substituted[1].ptr != C_NULL

    # --- template parameter lists, declarations and template names ---
    params = CC.getTemplateParameters(ctd)
    new_params = CC.SubstTemplateParams(sema, params, tu_dc, ml)
    @test new_params isa CC.TemplateParameterList
    @test new_params.ptr != C_NULL
    @test size(new_params) == size(params)

    typedef_pattern = CC.TypedefDecl(first(d for d in CC.decls(rd_dc) if CC.getDeclKindName(d) == "Typedef"))
    substituted_decl = CC.SubstDecl(sema, typedef_pattern, tu_dc, ml)
    @test substituted_decl isa CC.Decl
    @test substituted_decl.ptr != C_NULL
    # the result carries the pattern's own class, so it comes back at the Decl floor
    @test CC.getDeclKindName(substituted_decl) == "Typedef"

    boxed = first(fd for fd in CC.getFields(rd) if CC.getName(fd) == "boxed")
    # A template-id written in source carries an ElaboratedType wrapper, so peel the sugar
    # off before asking for the specialization underneath.
    boxed_ty = CC.resolve(CC.getTypePtr(CC.getType(boxed)))
    if boxed_ty isa CC.ElaboratedType
        boxed_ty = CC.resolve(CC.getTypePtr(CC.getNamedType(boxed_ty)))
    end
    tst = boxed_ty
    @test tst isa CC.TemplateSpecializationType
    subst_name = CC.SubstTemplateName(sema, CC.getTemplateName(tst), loc, ml)
    @test subst_name isa CC.TemplateName
    @test CC.isNull(subst_name) == false

    # --- attributes and the two remaining instantiation hooks ---
    # neither declaration carries an attribute, so both calls are total no-ops; they are the
    # hooks clang uses to copy a pattern's attributes onto what it is building
    @test CC.InstantiateAttrsForDecl(sema, ml, typedef_pattern, substituted_decl) === nothing
    @test CC.InstantiateAttrs(sema, ml, typedef_pattern, substituted_decl, scope) === nothing

    value = first(fd for fd in CC.getFields(rd) if CC.getName(fd) == "value")
    # the field has no default member initializer, so clang returns false before it reads
    # anything else out of either argument
    @test CC.hasInClassInitializer(value) == false
    @test CC.InstantiateInClassInitializer(sema, loc, value, value, ml) == false

    @test CC.is_dependent_context(rd_dc)
    # the pattern recorded no deferred access check, so replaying them changes nothing
    @test CC.PerformDependentDiagnostics(sema, rd_dc, ml) === nothing

    # disposing each sentinel restores exactly the state it replaced
    dispose(scope)
    @test CC.hasCurrentInstantiationScope(sema) == base_scope
    dispose(inst)
    @test CC.getNumCodeSynthesisContexts(sema) == base_contexts

    dispose(ml)
    dispose(arg)
    dispose(f)
    dispose(I)
end

@testset "Sema | allocation lookup, composite pointers, instantiation mapping and merging" begin
    # Every call below writes state that outlives it — it declares the implicit global
    # operator new, deletes a function, moves the floating-point exception mode and fills
    # Sema's extern-"C" side table — so the whole testset runs against an interpreter of
    # its own and disposes it at the end.
    I = create_interpreter(String[])
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)

    CC.parse(I, """
             int sd5_gi = 7;
             int *sd5_p1 = 0;
             int *sd5_p2 = 0;
             void (*sd5_fp1)() = 0;
             void (*sd5_fp2)() = 0;
             int sd5_todelete(int);
             template <class U> int sd5_tf(U);
             template <class T> int sd5_pick(T t) { return sd5_tf<int>(t); }
             """)

    f = DeclFinder(I)
    function sd5_var(name)
        @assert f(I, name) "lookup failed: $name"
        return CC.VarDecl(get_decl(f))
    end

    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    gi = sd5_var("sd5_gi")
    loc = CC.getLocation(gi)
    rng = CC.SourceRange(loc, loc)

    # --- operator new / operator delete for `new int` and `new int[]` ---
    failed, pass_align, opnew, opdel = CC.FindAllocationFunctions(sema, loc, rng,
                                                                  CC.CXAllocationFunctionScope_AFS_Global,
                                                                  CC.CXAllocationFunctionScope_AFS_Global, int_ty)
    @test failed isa Bool
    @test pass_align isa Bool
    @test opnew isa CC.FunctionDecl
    @test opdel isa CC.FunctionDecl
    # either the global lookup failed or it named an operator new
    @test failed || opnew.ptr != C_NULL

    failed2, _, opnew2, _ = CC.FindAllocationFunctions(sema, loc, rng, CC.CXAllocationFunctionScope_AFS_Global,
                                                       CC.CXAllocationFunctionScope_AFS_Global, int_ty;
                                                       is_array=true)
    @test failed2 isa Bool
    @test failed2 || opnew2.ptr != C_NULL

    # --- composite pointer type of two `int *` lvalues ---
    p1 = sd5_var("sd5_p1")
    p2 = sd5_var("sd5_p2")
    p1_ref = CC.BuildDeclRefExpr(sema, p1, CC.getType(p1), CC.CXExprValueKind_VK_LValue, loc)
    p2_ref = CC.BuildDeclRefExpr(sema, p2, CC.getType(p2), CC.CXExprValueKind_VK_LValue, loc)
    comp = CC.FindCompositePointerType(sema, loc, p1_ref, p2_ref)
    @test comp === nothing || comp[1] isa CC.QualType
    if comp !== nothing
        @test comp[1].ptr != C_NULL
        @test comp[2] isa CC.Expr_
        @test comp[3] isa CC.Expr_
    end
    gi_ref = CC.BuildDeclRefExpr(sema, gi, CC.getType(gi), CC.CXExprValueKind_VK_LValue, loc)
    ic = CC.FindCompositePointerType(sema, loc, gi_ref, gi_ref)
    @test ic === nothing || ic[1] isa CC.QualType

    # --- mapping a declaration and a context through an empty substitution ---
    ml = CC.MultiLevelTemplateArgumentList()
    inst = CC.FindInstantiatedDecl(sema, loc, gi, ml)
    @test inst isa CC.NamedDecl
    @test inst.ptr != C_NULL
    ictx = CC.FindInstantiatedContext(sema, loc, tu, ml)
    @test ictx isa CC.DeclContext
    @test ictx.ptr != C_NULL

    @assert f(I, "sd5_pick") "lookup failed: sd5_pick"
    ftd = CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "FunctionTemplate"))
    tfd = CC.getTemplatedDecl(ftd)
    # a function parameter would be looked up in a local instantiation scope this call
    # cannot have, so the wrapper rejects it rather than tripping clang's assert
    @test_throws AssertionError CC.FindInstantiatedDecl(sema, loc, CC.getParamDecl(tfd, 0),
                                                        ml)
    @test_throws AssertionError CC.FindInstantiatedContext(sema, loc,
                                                           CC.castToDeclContext(tfd), ml)
    dispose(ml)

    # --- resolving the overload set the template body leaves unresolved ---
    ovls = filter(n -> n isa CC.AbstractOverloadExpr, CC.subtree(CC.getBody(tfd)))
    @test !isempty(ovls)
    if !isempty(ovls)
        r = CC.ResolveSingleFunctionTemplateSpecialization(sema, first(ovls))
        @test r === nothing || r[1] isa CC.FunctionDecl
        if r !== nothing
            @test r[2] isa CC.NamedDecl
            @test r[3] isa CC.CXAccessSpecifier
        end
    end

    # --- the ARC parameter-type adjustment, which is the identity outside ARC ---
    tsi = CC.getTrivialTypeSourceInfo(ctx, int_ty, loc)
    adj = CC.AdjustParameterTypeForObjCAutoRefCount(sema, int_ty, loc, tsi)
    @test adj isa CC.QualType
    @test adj.ptr != C_NULL

    # --- installing a `= delete;` body on a bodyless first declaration ---
    @assert f(I, "sd5_todelete") "lookup failed: sd5_todelete"
    del_fd = CC.FunctionDecl(get_decl(f))
    @test CC.isDeleted(del_fd) == false
    @test CC.SetFunctionBodyKind(sema, del_fd, loc, CC.CXFnBodyKind_Delete) === nothing
    @test CC.isDeleted(del_fd)                     # the body kind this call set
    # Other is the parser's ordinary-compound-statement state, not a body kind
    @test_throws AssertionError CC.SetFunctionBodyKind(sema, del_fd, loc,
                                                       CC.CXFnBodyKind_Other)

    # --- moving the floating-point exception mode off the language default ---
    before = CC.CurFPFeatureOverrides(sema)
    @test before isa Integer
    default_mode = CC.getDefaultExceptionMode(CC.getLangOpts(sema))
    other_mode = default_mode == CC.CXFPExceptionModeKind_FPE_Strict ?
                 CC.CXFPExceptionModeKind_FPE_Ignore : CC.CXFPExceptionModeKind_FPE_Strict
    @test CC.setExceptionMode(sema, loc, other_mode) === nothing
    @test CC.CurFPFeatureOverrides(sema) != before      # the mode this call set
    @test CC.setExceptionMode(sema, loc, default_mode) === nothing
    @test CC.CurFPFeatureOverrides(sema) == 192

    # --- the extern-"C" side table round-trips through its own reader ---
    gi_name = CC.getDeclName(gi)
    @test CC.findLocallyScopedExternCDecl(sema, gi_name).ptr == C_NULL
    sc = CC.getScopeForContext(sema, tu)
    @test CC.RegisterLocallyScopedExternCDecl(sema, gi,
                                              sc.ptr == C_NULL ? nothing : sc) === nothing
    registered = CC.findLocallyScopedExternCDecl(sema, gi_name)
    @test registered isa CC.NamedDecl
    @test registered.ptr == gi.ptr                     # the declaration this call recorded

    # --- merging two declarations that already agree ---
    fp1 = sd5_var("sd5_fp1")
    fp2 = sd5_var("sd5_fp2")
    @test CC.MergeVarDeclTypes(sema, fp1, fp2) === nothing
    @test CC.isInvalidDecl(fp1) == false
    @test CC.MergeVarDeclExceptionSpecs(sema, fp1, fp2) === nothing
    @test CC.isInvalidDecl(fp1) == false
    # a variable that is not a pointer to a prototyped function is left alone
    @test CC.MergeVarDeclExceptionSpecs(sema, gi, gi) === nothing
    @test CC.isInvalidDecl(gi) == false

    dispose(f)
    dispose(I)
end

@testset "Sema | evaluation contexts, operator lookup and CUDA target queries" begin
    # A throwaway interpreter: scoring operator candidates runs argument-dependent lookup
    # against the whole translation unit, so none of it may leak into the shared one.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             struct SemaCtxS { int a; };
             SemaCtxS operator+(SemaCtxS, SemaCtxS);
             int semaCtxFn(int n) { SemaCtxS s{n}; SemaCtxS t = s + s; return t.a + n; }
             """)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    sc = CC.getCurScope(CC.get_parser(I))
    f = DeclFinder(I)

    @assert f(I, "semaCtxFn") "lookup failed: semaCtxFn"
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    obj_ref = first(n for n in nodes
                    if n isa CC.DeclRefExpr && CC.isRecordType(CC.getTypePtr(CC.getType(n))))

    # --- Unqualified lookup of an operator name (capacity-bounded fill) ---
    plus_fns = CC.LookupOverloadedOperatorName(sema, CC.CXOverloadedOperatorKind_OO_Plus, sc)
    @test plus_fns isa Vector{CC.NamedDecl}
    @test all(d -> d isa CC.NamedDecl && d.ptr != C_NULL, plus_fns)
    @test_throws AssertionError CC.LookupOverloadedOperatorName(sema,
                                                                CC.CXOverloadedOperatorKind_OO_None,
                                                                sc)

    # --- Scoring the candidates for a binary operator ---
    accesses = fill(CC.CXAccessSpecifier_AS_none, length(plus_fns))
    binop_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator)
    CC.LookupOverloadedBinOp(sema, binop_set, CC.CXOverloadedOperatorKind_OO_Plus, plus_fns,
                             accesses, [obj_ref, obj_ref])
    # The operand type is declared next to `operator+` in this file, so ADL alone finds it.
    @test size(binop_set) isa Integer
    @test size(binop_set) >= 1
    @test_throws AssertionError CC.LookupOverloadedBinOp(sema, binop_set,
                                                         CC.CXOverloadedOperatorKind_OO_Plus,
                                                         plus_fns, accesses, [obj_ref])
    @test_throws AssertionError CC.LookupOverloadedBinOp(sema, binop_set,
                                                         CC.CXOverloadedOperatorKind_OO_Plus,
                                                         plus_fns, CC.CXAccessSpecifier[],
                                                         [obj_ref, obj_ref])
    CC.dispose(binop_set)

    # --- The innermost expression-evaluation context ---
    rec = CC.currentEvaluationContext(sema)
    @test rec isa CC.ExpressionEvaluationContextRecord
    @test rec.ptr != C_NULL
    ctx_kind = CC.getContext(rec)
    @test ctx_kind isa CC.CXExpressionEvaluationContext
    @test CC.getExprContext(rec) isa CC.CXExpressionKind
    @test CC.getNumCleanupObjects(rec) == 0
    @test CC.getNumTypos(rec) == 0
    @test CC.is_null_handle(CC.getManglingContextDecl(rec))
    @test !(CC.isDiscardedStatementContext(rec))
    # The Sema-level predicate reads this very record, so the two must agree whatever the
    # host left on the stack.
    @test CC.isUnevaluatedContext(sema) ==
          (ctx_kind in (CC.CXExpressionEvaluationContext_Unevaluated,
                        CC.CXExpressionEvaluationContext_UnevaluatedList,
                        CC.CXExpressionEvaluationContext_UnevaluatedAbstract))

    # --- The optional InitializationContext triple, per record and across the stack ---
    delayed = CC.getDelayedDefaultInitializationContext(rec)
    @test delayed === nothing ||
          delayed isa Tuple{CC.SourceLocation,CC.ValueDecl,CC.DeclContext}
    innermost = CC.InnermostDeclarationWithDelayedImmediateInvocations(sema)
    @test innermost === nothing ||
          innermost isa Tuple{CC.SourceLocation,CC.ValueDecl,CC.DeclContext}
    outermost = CC.OutermostDeclarationWithDelayedImmediateInvocations(sema)
    @test outermost === nothing ||
          outermost isa Tuple{CC.SourceLocation,CC.ValueDecl,CC.DeclContext}

    # --- CUDA host/device classification (defined for a non-CUDA translation unit too) ---
    @test CC.IdentifyCUDATarget(sema, fd) isa CC.CXCUDAFunctionTarget
    @test CC.IdentifyCUDATarget(sema, fd, true) isa CC.CXCUDAFunctionTarget
    @test CC.CurrentCUDATarget(sema) isa CC.CXCUDAFunctionTarget
    @test CC.IdentifyCUDAPreference(sema, nothing, fd) isa CC.CXCUDAFunctionPreference
    @test CC.IdentifyCUDAPreference(sema, fd, fd) isa CC.CXCUDAFunctionPreference

    dispose(f)
    dispose(I)
end

@testset "Sema | undefined-but-used, template names and use legality" begin
    # A throwaway interpreter: the partial-ordering queries run template argument deduction
    # over this whole translation unit, so none of it may leak into the shared one.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             template <class T> struct SemaQ6Tpl { };
             template <class T> struct SemaQ6Tpl<T *> { };
             template <class T> struct SemaQ6Tpl<const T *> { };
             typedef int SemaQ6Typedef;
             struct SemaQ6Rec { int a; };
             SemaQ6Tpl<int> semaQ6Var;
             void semaQ6Plain(int a);
             void semaQ6NoThrow() noexcept;
             void semaQ6Deleted() = delete;
             static void semaQ6Undefined();
             void semaQ6Uses() { semaQ6Undefined(); }
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    pp = CC.getPreprocessor(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    # --- the odr-used-but-never-defined list (count, then parallel component arrays) ---
    # Empty here, and deliberately left so: an entry only appears once something is marked
    # odr-used without a definition, and clang's only consumer of that state is the
    # end-of-parse diagnostic renderer -- leaving one pending takes the process down rather
    # than failing a test. The shape of the empty result is what this pins.
    undefined = CC.getUndefinedButUsed(sema)
    @test undefined isa Vector{Tuple{CC.NamedDecl,CC.SourceLocation}}
    @test isempty(undefined)

    # --- whether the callee of a call can throw ---
    @test f(I, "semaQ6NoThrow")
    nothrow_fd = CC.FunctionDecl(get_decl(f))
    @test CC.canCalleeThrow(sema, nothing, nothrow_fd, loc) == CC.CXCanThrowResult_CT_Cannot
    @test CC.canCalleeThrow(sema, nothing, nothing, loc) isa CC.CXCanThrowResult

    # --- classifying the template name a written template-id carries ---
    @test f(I, "semaQ6Var")
    var_decl = CC.VarDecl(get_decl(f))
    written = CC.resolve(CC.getTypePtr(CC.getType(var_decl)))
    # a type written in source carries an ElaboratedType wrapper, so peel it first
    written isa CC.ElaboratedType && (written = CC.resolve(CC.getTypePtr(CC.getNamedType(written))))
    @test written isa CC.TemplateSpecializationType
    @test CC.getTemplateNameKindForDiagnostics(sema, CC.getTemplateName(written)) ==
          CC.CXTemplateNameKindForDiagnostics_ClassTemplate

    # --- how a non-tag declaration introduces its type name ---
    @test f(I, "SemaQ6Typedef")
    typedef_decl = get_decl(f)
    @test CC.getNonTagTypeDeclKind(sema, typedef_decl, CC.CXTagTypeKind_Struct) ==
          CC.CXNonTagKind_NTK_Typedef
    @test CC.getNonTagTypeDeclKind(sema, typedef_decl, CC.CXTagTypeKind_Enum) isa CC.CXNonTagKind

    # --- the field the self-assignment warning would point at ---
    candidate = CC.getSelfAssignmentClassMemberCandidate(sema, var_decl)
    @test candidate isa CC.FieldDecl
    @test candidate.ptr == C_NULL          # Sema's current context is not a C++ method

    # --- whether a declaration may be referenced at all ---
    @test f(I, "semaQ6Plain")
    plain_fd = CC.FunctionDecl(get_decl(f))
    @test CC.CanUseDecl(sema, plain_fd)
    @test f(I, "semaQ6Deleted")
    @test CC.CanUseDecl(sema, get_decl(f)) == false

    # --- splatting a scalar across a vector on initialization ---
    int_qt = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    altivec = CC.resolve(CC.getTypePtr(CC.getVectorType(sema |> CC.getASTContext, int_qt, 4,
                                                        CC.CXVectorKind_AltiVecVector)))
    @test altivec isa CC.VectorType
    @test CC.ShouldSplatAltivecScalarInCast(sema, altivec)   # true for every AltiVecVector
    generic = CC.resolve(CC.getTypePtr(CC.getVectorType(ctx, int_qt, 4, CC.CXVectorKind_Generic)))
    @test !(CC.ShouldSplatAltivecScalarInCast(sema, generic))

    # --- SME call-conversion validity, which only a function prototype can answer ---
    fn_qt = CC.getType(plain_fd)
    @test !(CC.IsInvalidSMECallConversion(sema, fn_qt, fn_qt))
    @test_throws AssertionError CC.IsInvalidSMECallConversion(sema, int_qt, fn_qt)

    # --- a lookup result that holds a template name ---
    r = CC.LookupResult(sema, CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaQ6Tpl")), loc,
                        CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, r, tu)
    @test CC.hasAnyAcceptableTemplateNames(sema, r)
    @test CC.hasAnyAcceptableTemplateNames(sema, r; allow_dependent=false)
    CC.dispose(r)

    # --- the written return type's TypeLoc ---
    ret_loc = CC.getReturnTypeLoc(sema, plain_fd)
    @test ret_loc isa CC.TypeLoc
    @test CC.getType(ret_loc) isa CC.QualType
    CC.dispose(ret_loc)

    # --- partial ordering of the two partial specializations ---
    @test f(I, "SemaQ6Tpl")
    ctd = first(CC.ClassTemplateDecl(d)
                for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate")
    specs = CC.getPartialSpecializations(ctd)
    @test length(specs) == 2
    # deduction runs under a trap so a substitution failure is counted, not rendered
    trap = CC.SFINAETrap(sema)
    info = CC.TemplateDeductionInfo(loc)
    @test CC.isMoreSpecializedThanPrimary(sema, specs[1], info)
    winner = CC.getMoreSpecializedPartialSpecialization(sema, specs[1], specs[2], loc)
    @test winner isa CC.ClassTemplatePartialSpecializationDecl
    CC.dispose(info)
    CC.dispose(trap)

    # --- the OpenMP scope flags, both closed in a unit with no directives ---
    @test CC.isInOpenMPDeclareVariantScope(sema) == false
    @test CC.isInOpenMPDeclareTargetContext(sema) == false

    # --- the nullability keywords and the CFError record ---
    keyword = CC.getNullabilityKeyword(sema, CC.CXNullabilityKind_NonNull)
    @test keyword isa CC.IdentifierInfo
    @test !isempty(CC.getName(keyword))
    @test !CC.is_null_handle(CC.getNullabilityKeyword(sema, CC.CXNullabilityKind_Nullable))
    @test f(I, "SemaQ6Rec")
    @test CC.isCFError(sema, CC.CXXRecordDecl(get_decl(f))) == false

    dispose(f)
    dispose(I)
end

@testset "Sema declaration and node builders" begin
    # A throwaway interpreter: these builders add declarations to the translation unit and
    # instantiate a class template, so nothing here may leak into the interpreter the other
    # test files share.
    I = create_interpreter(String[])
    CC.parse(I, """
             namespace semaB6NS { void semaB6Target(); }
             using semaB6NS::semaB6Target;
             const int semaB6One = 1;
             int semaB6Fn(int n) { return n + 1; }
             namespace std {
             template <class _E>
             class initializer_list {
                 const _E *__b;
                 unsigned long __s;
             };
             }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.getTranslationUnitDecl(ctx)
    alldecls = CC.decls(CC.castToDeclContext(tu))
    f = DeclFinder(I)

    @test f(I, "semaB6One")
    one = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaB6Fn")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))

    # The parser leaves a current declaration context behind; the builders that add
    # declarations to it walk up from it without a null check.
    @test CC.getCurLexicalContext(sema).ptr != C_NULL

    # --- CreateBuiltin: an implicit extern "C" declaration in the translation unit ---
    ii = get(CC.getIdents(ctx), "semaB6Builtin")
    fnty = CC.getFunctionType(ctx, int_ty, CC.QualType[int_ty])
    bfd = CC.CreateBuiltin(sema, ii, fnty, 0, loc)
    @test bfd isa CC.FunctionDecl
    @test bfd.ptr != C_NULL
    @test CC.getNameAsString(bfd) == "semaB6Builtin"
    @test CC.getNumParams(bfd) == 1
    @test CC.isImplicit(bfd)
    # 0 is Builtin::NotBuiltin, the ID this call passed in
    @test CC.getBuiltinID(bfd) == 0
    # a non-function type is rejected before the ccall
    @test_throws AssertionError CC.CreateBuiltin(sema, ii, int_ty, 0, loc)

    # --- CreateCapturedStmtRecordDecl: the closure record plus its CapturedDecl ---
    crd, cd = CC.CreateCapturedStmtRecordDecl(sema, loc, 2)
    @test crd isa CC.RecordDecl
    @test crd.ptr != C_NULL
    @test CC.isCapturedRecord(crd)
    @test CC.isImplicit(crd)
    @test cd isa CC.CapturedDecl
    @test cd.ptr != C_NULL
    # the parameter count is the one this call asked for
    @test CC.getNumParams(cd) == 2

    # --- BuildUsingPackDecl: the pack a pack-expanded using-declaration expands to ---
    upd = CC.BuildUsingPackDecl(sema, fd, [fd])
    @test upd isa CC.NamedDecl
    @test upd.ptr != C_NULL
    @test CC.getDeclKindName(upd) == "UsingPack"
    pack = CC.UsingPackDecl(upd)
    @test CC.getNumExpansions(pack) == 1
    @test CC.getExpansion(pack, 0).ptr == fd.ptr
    @test CC.getInstantiatedFromUsingDecl(pack).ptr == fd.ptr

    # --- BuildStdInitializerList: instantiated on the element type, recognised again ---
    il = CC.BuildStdInitializerList(sema, int_ty, loc)
    @test il isa CC.QualType
    if il.ptr != C_NULL
        found, element = CC.isStdInitializerList(sema, il)
        @test found
        @test CC.isIntegerType(CC.getTypePtr(element))
    end

    # --- BuildMSDependentExistsStmt: __if_exists over a written qualified name ---
    ud = first(d for d in alldecls if d isa CC.UsingDecl)
    qloc = CC.getQualifierLoc(ud)
    nameinfo = CC.getNameInfo(ud)
    try
        ms = CC.BuildMSDependentExistsStmt(sema, loc, true, qloc, nameinfo, body)
        @test ms isa CC.Stmt
        @test ms.ptr != C_NULL
        @test CC.resolve(ms) isa CC.MSDependentExistsStmt
    finally
        dispose(nameinfo)
        dispose(qloc)
    end

    # --- BuildCXXFoldExpr: a unary fold, with the opposite operand left absent ---
    no_callee = CC.UnresolvedLookupExpr(C_NULL)
    fold = CC.BuildCXXFoldExpr(sema, no_callee, loc, one,
                               CC.LibClangEx.CXBinaryOperatorKind_BO_Add, loc,
                               CC.Expr_(C_NULL), loc)
    @test fold isa CC.Expr_
    folded = CC.resolve(fold)
    @test folded isa CC.CXXFoldExpr
    @test CC.getOperator(folded) == CC.LibClangEx.CXBinaryOperatorKind_BO_Add
    @test CC.getLHS(folded).ptr == one.ptr
    @test CC.getRHS(folded).ptr == C_NULL
    # the same builder with the pack length supplied and the operands the other way round
    fold2 = CC.BuildCXXFoldExpr(sema, no_callee, loc, CC.Expr_(C_NULL),
                                CC.LibClangEx.CXBinaryOperatorKind_BO_Add, loc, one, loc, 3)
    @test fold2 isa CC.Expr_
    @test CC.resolve(fold2) isa CC.CXXFoldExpr
    @test CC.getRHS(CC.resolve(fold2)).ptr == one.ptr

    # --- The two builders needing a scope the parser only has mid-parse ---
    # Both stacks are empty between parses, so each wrapper rejects the call itself; the
    # other polarity is covered without reading a value this test did not set.
    @test !(CC.hasCurFunction(sema))
    if CC.hasCurFunction(sema)
        @test CC.BuildStmtExpr(sema, loc, body, loc) isa Union{Nothing,CC.Expr_}
    else
        @test_throws AssertionError CC.BuildStmtExpr(sema, loc, body, loc)
    end

    this_ty = CC.getCurrentThisType(sema)
    @test this_ty isa CC.QualType
    if this_ty.ptr == C_NULL
        ptr_ty = CC.BuildPointerType(sema, int_ty, loc)
        @test_throws AssertionError CC.BuildCXXThisExpr(sema, loc, ptr_ty, true)
    else
        this_expr = CC.BuildCXXThisExpr(sema, loc, this_ty, true)
        @test this_expr isa CC.Expr_
        @test CC.resolve(this_expr) isa CC.CXXThisExpr
    end

    dispose(f)
    dispose(I)
end

@testset "Sema | argument, alignment, access-control and the remaining operand checks" begin
    # A throwaway interpreter: every check below inserts implicit conversions into the
    # ASTContext, so nothing here may leak into the interpreter the other files share.
    I = create_interpreter(String[])
    CC.parse(I, """
             const int semaChk6Eight = 8;
             const int semaChk6Two = 2;
             const int semaChk6One = 1;
             struct SemaChk6Rec { int semaChk6Field; };
             int semaChk6Plain(int n) { return n; }
             """)
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    rng = CC.SourceRange(loc, loc)
    f = DeclFinder(I)

    # Three integer-literal prvalues taken from the parse, so every operand below is a
    # node clang built and accepted itself.
    @test f(I, "semaChk6Eight")
    eight = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaChk6Two")
    two = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaChk6One")
    one = CC.getInit(CC.VarDecl(get_decl(f)))
    int_qt = CC.getType(eight)
    @test CC.isIntegerType(CC.getTypePtr(int_qt))

    # --- Argument list, alignment operand, throw operand and enable_if ----------------
    ph_failed, ph_args = CC.CheckArgsForPlaceholders(sema, [eight, two])
    @test ph_failed isa Bool
    @test length(ph_args) == 2
    @test all(a -> a isa CC.Expr_, ph_args)

    tsi = CC.getTrivialTypeSourceInfo(ctx, int_qt, loc)
    @test CC.CheckAlignasTypeArgument(sema, "alignas", tsi, loc, rng) == false

    @test !(CC.CheckCXXThrowOperand(sema, loc, int_qt, eight))

    # semaChk6Plain carries no enable_if attribute, so the loop over them is empty and
    # every condition succeeds vacuously.
    @test f(I, "semaChk6Plain")
    plain_fd = CC.FunctionDecl(get_decl(f))
    @test CC.CheckEnableIf(sema, plain_fd, loc, [eight]) === nothing

    # --- C++ access control over a public data member ---------------------------------
    @test f(I, "SemaChk6Rec")
    rec = CC.CXXRecordDecl(get_decl(f))
    fld = first(CC.getFields(rec))
    fld_access = CC.getAccess(fld)
    @test fld_access isa CC.LibClangEx.CXAccessSpecifier
    @test CC.CheckMemberAccess(sema, loc, rec, fld, fld_access) isa
          CC.LibClangEx.CXAccessResult
    @test CC.CheckStructuredBindingMemberAccess(sema, loc, rec, fld, fld_access) isa
          CC.LibClangEx.CXAccessResult

    # --- Conditional operands ------------------------------------------------------------
    # CheckBitwiseOperands and CheckLogicalOperands are not wrapped: clang-cpp compiles both
    # as file-local symbols, so a wrapper links nowhere. See CXSema.h.
    cnd = CC.CheckConditionalOperands(sema, one, eight, two, loc)
    @test cnd !== nothing
    cnd_ty, cnd_c, cnd_l, cnd_r, cnd_vk, cnd_ok = cnd
    @test cnd_ty isa CC.QualType
    @test cnd_ty.ptr != C_NULL
    @test cnd_c isa CC.Expr_
    @test cnd_l isa CC.Expr_
    @test cnd_r isa CC.Expr_
    @test cnd_vk isa CC.LibClangEx.CXExprValueKind
    @test cnd_ok isa CC.LibClangEx.CXExprObjectKind

    cxx_cnd = CC.CXXCheckConditionalOperands(sema, one, eight, two, loc)
    @test cxx_cnd !== nothing
    @test cxx_cnd[1] isa CC.QualType
    @test cxx_cnd[1].ptr != C_NULL
    @test cxx_cnd[5] isa CC.LibClangEx.CXExprValueKind
    @test cxx_cnd[6] isa CC.LibClangEx.CXExprObjectKind

    # --- Vector operands, over the ext_vector prvalues clang builds by splatting -------
    extvec_qt = CC.BuildExtVectorType(sema, int_qt, two, loc)
    @test CC.isExtVectorType(CC.getTypePtr(extvec_qt))
    vcast1 = CC.CheckExtVectorCast(sema, rng, extvec_qt, eight)
    vcast2 = CC.CheckExtVectorCast(sema, rng, extvec_qt, two)
    vcast3 = CC.CheckExtVectorCast(sema, rng, extvec_qt, one)
    @test vcast1 !== nothing
    @test vcast2 !== nothing
    @test vcast3 !== nothing
    v1, v2, v3 = vcast1[1], vcast2[1], vcast3[1]
    # CheckExtVectorCast hands back the CONVERTED SCALAR ready to be splatted, not a
    # vector-typed expression, so only the carrier shape is asserted here.
    @test v1 isa CC.Expr_
    @test v2 isa CC.Expr_
    @test v3 isa CC.Expr_

    # CheckVectorOperands needs at least one genuinely vector-typed operand, which is the
    # gate the wrapper asserts; a pair of scalars never reaches the ccall.
    @test_throws AssertionError CC.CheckVectorOperands(sema, eight, two, loc)
    @test_throws AssertionError CC.CheckVectorOperands(sema, v1, v2, loc)

    # Whether the comparison and logical forms accept an ext_vector operand pair is a
    # language-mode decision, and a rejection comes back as `nothing` rather than as a
    # crash — so assert the shape of either outcome.
    # The comparison and logical forms share CheckVectorOperands' precondition, so the
    # scalar operands this testset has to hand exercise the gate rather than the check.
    @test_throws AssertionError CC.CheckVectorCompareOperands(sema, v1, v2, loc,
                                                              CC.LibClangEx.CXBinaryOperatorKind_BO_LT)
    @test_throws AssertionError CC.CheckVectorCompareOperands(sema, eight, two, loc,
                                                              CC.LibClangEx.CXBinaryOperatorKind_BO_LT)
    @test_throws AssertionError CC.CheckVectorLogicalOperands(sema, v1, v2, loc)
    @test_throws AssertionError CC.CheckVectorLogicalOperands(sema, eight, two, loc)

    # Same story for the conditional form: its condition must genuinely have vector type.
    @test_throws AssertionError CC.CheckVectorConditionalTypes(sema, v3, v1, v2, loc)
    @test_throws AssertionError CC.CheckVectorConditionalTypes(sema, eight, v1, v2, loc)

    dispose(f)
    dispose(I)
end

@testset "Sema | substituting a pattern's parameters, bases and written arguments" begin
    # Every call below rebuilds declarations into the translation unit or writes a default
    # argument onto a parameter, so the whole testset runs against an interpreter of its own
    # and disposes it at the end.
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    sema = CC.get_sema(I)

    CC.parse(I, """
    template <typename SemaSP6T>
    struct SemaSP6Box {};

    template <typename SemaSP6T>
    struct SemaSP6Box<SemaSP6T *> {};

    template <typename SemaSP6T>
    struct SemaSP6Pattern {
        SemaSP6T value;
        void method(SemaSP6T p, int q);
    };

    struct SemaSP6Plain {};

    int semaSP6Seed = 7;
    int semaSP6Fn(int a);
    """)

    f = DeclFinder(I)

    # Every lookup runs before the first mutating call: the substitutions below add
    # declarations to the translation unit, and get_decl throws once a name is not unique.
    # Select the templates by kind, since a template's own name resolves to more than one
    # declaration as soon as anything specialises it.
    @test f(I, "SemaSP6Pattern")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    @test f(I, "SemaSP6Box")
    box_ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    @test f(I, "SemaSP6Plain")
    plain = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "semaSP6Seed")
    seed_init = CC.getInit(CC.VarDecl(get_decl(f)))
    @test f(I, "semaSP6Fn")
    fn = CC.FunctionDecl(get_decl(f))

    rd = CC.getTemplatedDecl(ctd)
    rd_dc = CC.castToDeclContext(rd)
    loc = CC.getLocation(ctd)
    method = CC.CXXMethodDecl(first(d for d in CC.decls(rd_dc) if CC.getDeclKindName(d) == "CXXMethod"))

    # one substituted level, SemaSP6T -> int, owned by the class template itself
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    arg = CC.TemplateArgument(int_qt)
    ml = CC.MultiLevelTemplateArgumentList()
    CC.addOuterTemplateArguments(ml, ctd, [arg], true)

    base_contexts = CC.getNumCodeSynthesisContexts(sema)
    inst = CC.InstantiatingTemplate(sema, loc, ctd)
    @test CC.isInvalid(inst) == false

    # --- the parameter list ---
    params = [CC.getParamDecl(method, 0), CC.getParamDecl(method, 1)]
    base_scope = CC.hasCurrentInstantiationScope(sema)
    @test base_scope isa Bool
    # Rebuilding parameters records the pattern-to-instance mapping through
    # Sema::CurrentInstantiationScope with no null check, so the wrapper rejects the call
    # rather than let it segfault while nothing has opened a scope.
    if !base_scope
        @test_throws AssertionError CC.SubstParmTypes(sema, loc, params, ml)
    end

    scope = CC.LocalInstantiationScope(sema)
    @test CC.hasCurrentInstantiationScope(sema)

    substituted = CC.SubstParmTypes(sema, loc, params, ml)
    @test substituted !== nothing
    types, new_params = substituted
    # neither parameter is a pack expansion, so the result is one entry per input
    @test length(types) == 2
    @test length(new_params) == 2
    # the pattern declared `method(SemaSP6T p, int q)`; the argument makes both int
    @test CC.isIntegerType(CC.getTypePtr(types[1]))
    @test CC.isIntegerType(CC.getTypePtr(types[2]))
    @test new_params[1] isa CC.ParmVarDecl
    @test new_params[1].ptr != C_NULL
    @test new_params[2].ptr != C_NULL

    # --- base specifiers ---
    @test CC.hasDefinition(rd)
    # the pattern declares no base at all, so clang attaches nothing and reports success
    @test CC.SubstBaseSpecifiers(sema, plain, rd, ml) == false
    @test CC.getNumBases(plain) == 0

    # --- written template arguments ---
    partials = CC.getPartialSpecializations(box_ctd)
    @test length(partials) == 1
    li = CC.getTemplateArgsAsWritten(partials[1])
    @test CC.getNumTemplateArgs(li) == 1
    written = CC.getTemplateArg(li, 0)
    @test written isa CC.TemplateArgumentLoc

    outputs = CC.TemplateArgumentListInfo(loc, loc)
    @test size(outputs) == 0
    @test CC.SubstTemplateArguments(sema, [written], ml, outputs) == false
    # one input and no pack expansion, so exactly one argument is appended
    @test size(outputs) == 1
    subst_arg = CC.getArgument(CC.getArgument(outputs, 0))
    @test CC.getKind(subst_arg) == CC.LibClangEx.CXTemplateArgument_Type
    # the partial specialization was written `SemaSP6Box<SemaSP6T *>`, so substituting the
    # argument into it leaves a pointer type behind
    @test CC.isPointerType(CC.getTypePtr(CC.getAsType(subst_arg)))
    dispose(outputs)

    # --- a parameter's uninstantiated default argument ---
    param = CC.getParamDecl(fn, 0)
    @test CC.hasUninstantiatedDefaultArg(param) == false
    # clang reads the pattern through an accessor that asserts, so the wrapper rejects a
    # parameter that carries none
    @test_throws AssertionError CC.SubstDefaultArgument(sema, loc, param, ml)

    # the wrapper for clang_ParmVarDecl_setUninstantiatedDefaultArg is spelled getDefaultArg
    CC.getDefaultArg(param, seed_init)
    @test CC.hasUninstantiatedDefaultArg(param)
    # the pattern is a plain integer literal, so nothing in it depends on the argument list
    # and the conversion to the parameter's own int type succeeds
    @test CC.SubstDefaultArgument(sema, loc, param, ml) == false
    @test CC.hasUninstantiatedDefaultArg(param) == false
    @test CC.hasDefaultArg(param)

    # disposing each sentinel restores exactly the state it replaced
    dispose(scope)
    @test CC.hasCurrentInstantiationScope(sema) == base_scope
    dispose(inst)
    @test CC.getNumCodeSynthesisContexts(sema) == base_contexts

    dispose(ml)
    dispose(arg)
    dispose(f)
    dispose(I)
end

@testset "Sema | conversion, surrogate and call candidates, ADL association, argument conversion" begin
    # Every collector below deduces specializations, and the argument converters build
    # conversion nodes into the ASTContext, so the whole set runs against an interpreter it
    # builds and disposes itself.
    I = create_interpreter(String[])
    CC.parse(I, """
             namespace semad6ns {
             struct Tagged {};
             }
             using SemaD6FnPtr = int (*)(int);
             struct SemaD6Conv {
                 operator int() const;
                 operator SemaD6FnPtr() const;
                 template <typename T> operator T *() const;
                 template <typename T> int tmethod(T) const;
             };
             struct SemaD6Ctor {
                 SemaD6Ctor(int, int);
             };
             struct SemaD6Arg {};
             int operator+(SemaD6Arg, int);
             int operator+(SemaD6Arg, double);
             int semaD6Fn(int);
             int semaD6Fn(double);
             int semaD6Call(int, double);
             template <typename T> T semaD6Tmpl(T);
             void semaD6Body(int n, double d, SemaD6Conv c, SemaD6Arg a,
                             semad6ns::Tagged t) {
                 int x = n;
                 (void)x;
                 (void)d;
                 (void)c;
                 (void)a;
                 (void)t;
             }
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    pp = CC.getPreprocessor(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    # Every lookup happens before the first collector runs: deducing a specialization makes
    # a name that is unique now stop being unique.
    @assert f(I, "SemaD6Conv") "lookup failed: SemaD6Conv"
    conv_rec = CC.CXXRecordDecl(get_decl(f))
    # A template's pattern is excluded explicitly: `operator T *` would answer the pointer
    # predicate below just as `operator SemaD6FnPtr` does.
    convs = [CC.CXXConversionDecl(m)
             for m in CC.getMethods(conv_rec)
             if CC.getDeclKindName(m) == "CXXConversion" &&
        CC.getDescribedFunctionTemplate(m).ptr == C_NULL]
    int_conv = first(c for c in convs
                     if CC.isIntegerType(CC.getTypePtr(CC.getConversionType(c))))
    fnptr_conv = first(c for c in convs
                       if CC.isPointerType(CC.getTypePtr(CC.getConversionType(c))))
    # The conversion target is written through an alias, so canonicalise before peeling the
    # pointer off to reach the prototype the surrogate is called through.
    fnptr_target = CC.getCanonicalType(ctx, CC.getConversionType(fnptr_conv))
    surrogate_proto = CC.resolve(CC.getTypePtr(CC.getPointeeType(CC.getTypePtr(fnptr_target))))
    @test surrogate_proto isa CC.FunctionProtoType

    conv_tmpls = [CC.FunctionTemplateDecl(d)
                  for d in CC.decls(CC.castToDeclContext(conv_rec))
                  if CC.getDeclKindName(d) == "FunctionTemplate"]
    tmpl_conv = first(t for t in conv_tmpls
                      if CC.getDeclKindName(CC.getTemplatedDecl(t)) == "CXXConversion")
    tmpl_method = first(t for t in conv_tmpls
                        if CC.getDeclKindName(CC.getTemplatedDecl(t)) == "CXXMethod")

    @assert f(I, "semaD6Tmpl") "lookup failed: semaD6Tmpl"
    free_tmpl = CC.FunctionTemplateDecl(first(d for d in CC.get_decls(f)
                                              if CC.getDeclKindName(d) == "FunctionTemplate"))

    @assert f(I, "SemaD6Ctor") "lookup failed: SemaD6Ctor"
    ctor_rec = CC.CXXRecordDecl(get_decl(f))
    ctor = CC.CXXConstructorDecl(first(m for m in CC.getMethods(ctor_rec)
                                       if CC.getDeclKindName(m) == "CXXConstructor" &&
                                          CC.getNumParams(m) == 2))
    ctor_ty = CC.getTypeDeclType(ctx, ctor_rec)

    @assert f(I, "semaD6Fn") "lookup failed: semaD6Fn"
    fns = [CC.FunctionDecl(d) for d in CC.get_decls(f)
           if CC.getDeclKindName(d) == "Function"]
    @test length(fns) == 2

    @assert f(I, "semaD6Call") "lookup failed: semaD6Call"
    callee = CC.FunctionDecl(get_decl(f))
    callee_proto = CC.resolve(CC.getTypePtr(CC.getType(callee)))
    @test callee_proto isa CC.FunctionProtoType

    plus_fns = [CC.FunctionDecl(d)
                for d in CC.decls(tu)
                if d isa CC.FunctionDecl && CC.getNameAsString(d) == "operator+"]
    @test length(plus_fns) == 2

    @assert f(I, "semaD6Body") "lookup failed: semaD6Body"
    refs = [n for n in CC.subtree(CC.getBody(CC.FunctionDecl(get_decl(f))))
            if n isa CC.DeclRefExpr]
    int_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "n")
    dbl_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "d")
    obj_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "c")
    plus_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "a")
    adl_arg = first(r for r in refs if CC.getNameAsString(CC.getDecl(r)) == "t")
    int_qt = CC.getType(int_arg)
    int_ptr_qt = CC.getPointerType(ctx, int_qt)

    # --- Conversion functions, written out and deduced ---
    conv_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddConversionCandidate(sema, int_conv, int_conv, CC.CXAccessSpecifier_AS_public,
                              conv_rec, obj_arg, int_qt, conv_set)
    @test size(conv_set) == 1
    # A deduction failure would still be recorded, so the set grows either way.
    CC.AddTemplateConversionCandidate(sema, tmpl_conv, tmpl_conv,
                                      CC.CXAccessSpecifier_AS_public, conv_rec, obj_arg,
                                      int_ptr_qt, conv_set)
    @test size(conv_set) == 2
    # The wrappers reject the two inputs clang assumes away: a non-class source expression
    # and a template asked for through the non-template entry point.
    @test_throws AssertionError CC.AddConversionCandidate(sema, int_conv, int_conv,
                                                          CC.CXAccessSpecifier_AS_public,
                                                          conv_rec, int_arg, int_qt,
                                                          conv_set)
    @test_throws AssertionError CC.AddTemplateConversionCandidate(sema, tmpl_method,
                                                                  tmpl_method,
                                                                  CC.CXAccessSpecifier_AS_public,
                                                                  conv_rec, obj_arg,
                                                                  int_ptr_qt, conv_set)
    CC.dispose(conv_set)

    # --- The surrogate for calling an object through a conversion to a function pointer ---
    surrogate_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddSurrogateCandidate(sema, fnptr_conv, fnptr_conv, CC.CXAccessSpecifier_AS_public,
                             conv_rec, surrogate_proto, obj_arg, [int_arg], surrogate_set)
    @test size(surrogate_set) == 1
    @test_throws AssertionError CC.AddSurrogateCandidate(sema, fnptr_conv, fnptr_conv,
                                                         CC.CXAccessSpecifier_AS_public,
                                                         conv_rec, surrogate_proto,
                                                         int_arg, [int_arg],
                                                         surrogate_set)
    CC.dispose(surrogate_set)

    # --- A member function template deduced against the call arguments ---
    mt_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddMethodTemplateCandidate(sema, tmpl_method, tmpl_method,
                                  CC.CXAccessSpecifier_AS_public, conv_rec, obj_arg,
                                  [int_arg], mt_set)
    @test size(mt_set) == 1
    # a namespace-scope template describes no member function
    @test_throws AssertionError CC.AddMethodTemplateCandidate(sema, free_tmpl, free_tmpl,
                                                              CC.CXAccessSpecifier_AS_none,
                                                              conv_rec, obj_arg, [int_arg],
                                                              mt_set)
    CC.dispose(mt_set)

    # --- The non-member operator candidates of an overload set ---
    op_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator)
    CC.AddNonMemberOperatorCandidates(sema, plus_fns,
                                      fill(CC.CXAccessSpecifier_AS_none, length(plus_fns)),
                                      [plus_arg, int_arg], op_set)
    @test size(op_set) == length(plus_fns)
    @test_throws AssertionError CC.AddNonMemberOperatorCandidates(sema, plus_fns,
                                                                  CC.CXAccessSpecifier[],
                                                                  [plus_arg, int_arg],
                                                                  op_set)
    CC.dispose(op_set)

    # --- A call through an unresolved lookup, collected from the expression and from the
    #     lookup result that produced it ---
    ss = CC.CXXScopeSpec()
    fn_name = CC.DeclarationName(CC.getIdentifierInfo(pp, "semaD6Fn"))
    lr = CC.LookupResult(sema, fn_name, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, lr, tu)
    ule = CC.resolve(CC.BuildDeclarationNameExpr(sema, ss, lr, false))
    @test ule isa CC.UnresolvedLookupExpr

    call_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddOverloadedCallCandidates(sema, ule, [int_arg], call_set)
    @test size(call_set) == 2
    CC.dispose(call_set)

    lr2 = CC.LookupResult(sema, fn_name, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, lr2, tu)
    lr_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.AddOverloadedCallCandidates(sema, lr2, [int_arg], lr_set)
    @test size(lr_set) == 2
    # a result that names a class is not something clang can turn into a candidate
    rec_name = CC.DeclarationName(CC.getIdentifierInfo(pp, "SemaD6Arg"))
    lr3 = CC.LookupResult(sema, rec_name, loc, CC.CXLookupNameKind_LookupOrdinaryName)
    @test CC.LookupQualifiedName(sema, lr3, tu)
    @test_throws AssertionError CC.AddOverloadedCallCandidates(sema, lr3, [int_arg], lr_set)
    CC.dispose(lr_set)
    CC.dispose(lr3)
    CC.dispose(lr2)

    # --- Picking one function out of the overload set by its type ---
    target = CC.getPointerType(ctx, CC.getType(fns[1]))
    resolved = CC.ResolveAddressOfOverloadedFunction(sema, ule, target)
    @test resolved !== nothing
    @test resolved[1] isa CC.FunctionDecl
    @test CC.getNameAsString(resolved[1]) == "semaD6Fn"
    @test resolved[2] isa CC.NamedDecl
    @test resolved[3] isa CC.CXAccessSpecifier
    @test resolved[4] isa Bool
    # an expression that is not an overload set is rejected before the ccall
    @test_throws AssertionError CC.ResolveAddressOfOverloadedFunction(sema, int_arg,
                                                                      target)
    CC.dispose(lr)
    CC.dispose(ss)

    # --- Argument-dependent lookup's association sets ---
    adl_ns, adl_cls = CC.FindAssociatedClassesAndNamespaces(sema, loc, [adl_arg])
    @test adl_ns isa Vector{CC.DeclContext}
    @test adl_cls isa Vector{CC.CXXRecordDecl}
    @test !isempty(adl_ns)
    @test any(c -> CC.getNameAsString(c) == "Tagged", adl_cls)
    # a fundamental type associates nothing at all
    plain_ns, plain_cls = CC.FindAssociatedClassesAndNamespaces(sema, loc, [int_arg])
    @test isempty(plain_ns)
    @test isempty(plain_cls)

    # --- Converting the arguments of a constructor call and of an ordinary call ---
    ctor_invalid, ctor_args = CC.CompleteConstructorCall(sema, ctor, ctor_ty,
                                                         [int_arg, int_arg], loc)
    @test !ctor_invalid
    @test length(ctor_args) == 2
    @test all(a -> a isa CC.Expr_, ctor_args)

    call_invalid, call_args = CC.GatherArgumentsForCall(sema, loc, callee, callee_proto, 0,
                                                        [int_arg, dbl_arg])
    @test !call_invalid
    @test length(call_args) == 2
    @test all(a -> a isa CC.Expr_, call_args)

    dispose(f)
    dispose(I)
end

@testset "Sema | external-source loads, cleanup wrapping and scalar conversions" begin
    # A throwaway interpreter: wrapping cleanups and preparing typeof operands touch Sema's
    # cleanup and expression-evaluation bookkeeping, so none of it may leak into the shared
    # interpreter the rest of the suite shares.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             int semaMisc6Fn(int n) { return n + 1; }
             static_assert(sizeof(int) >= 2, "int is at least two bytes");
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    int_ty = CC.get_qual_type(CC.jlty_to_clty(Int32, ctx))
    double_ty = CC.get_qual_type(CC.jlty_to_clty(Float64, ctx))

    @assert f(I, "semaMisc6Fn") "lookup failed: semaMisc6Fn"
    fd = CC.FunctionDecl(get_decl(f))
    fn_ty = CC.getType(fd)

    # IntegerLiteral::Create takes the APInt through the LLVMGenericValueRef bridge
    # (MARSHALLING.md §1), so the value is built as an LLVM generic value first.
    gv = CC.LLVM.API.LLVMCreateGenericValueOfInt(CC.LLVM.API.LLVMInt32Type(), 42, 0)
    lit = CC.IntegerLiteral(ctx, gv, int_ty, loc)
    gv7 = CC.LLVM.API.LLVMCreateGenericValueOfInt(CC.LLVM.API.LLVMInt32Type(), 7, 0)
    lit7 = CC.IntegerLiteral(ctx, gv7, int_ty, loc)
    @test lit isa CC.IntegerLiteral
    @test lit7 isa CC.IntegerLiteral

    # --- Loading from an external AST source: no source is attached, so both are no-ops ---
    @test CC.LoadExternalWeakUndeclaredIdentifiers(sema) === nothing
    @test CC.LoadExternalVTableUses(sema) === nothing

    # --- Host/device discarding, which is defined for a non-CUDA translation unit too ---
    @test CC.shouldIgnoreInHostDeviceCheck(sema, fd) == false

    # --- The member-function calling convention, asked for a plain function type ---
    adjusted = CC.adjustMemberFunctionCC(sema, fn_ty, false, false, loc)
    @test adjusted isa CC.QualType
    @test adjusted.ptr != C_NULL
    @test CC.isFunctionType(CC.getTypePtr(adjusted))
    @test_throws AssertionError CC.adjustMemberFunctionCC(sema, int_ty, false, false, loc)

    # --- Preparing a typeof operand: a literal is neither a placeholder nor variably
    # modified, so it comes back as an ordinary expression ---
    typeof_operand = CC.HandleExprEvaluationContextForTypeof(sema, lit)
    @test typeof_operand isa CC.Expr_
    @test typeof_operand.ptr != C_NULL

    # --- Copy-initializing a temporary of another type from the literal ---
    conv = CC.tryConvertExprToType(sema, lit, double_ty)
    @test conv isa CC.Expr_
    @test CC.getTypePtr(CC.getType(conv)).ptr == CC.getTypePtr(double_ty).ptr

    # --- The cast kind between two scalars, plus the operand clang ended up with ---
    (ck, src) = CC.PrepareScalarCast(sema, lit, double_ty)
    @test ck isa CC.CXCastKind
    @test ck == CC.CXCastKind_CK_IntegralToFloating
    @test src isa CC.Expr_
    # a function type is not scalar, and the assertion is the wrapper's, not clang's
    @test_throws AssertionError CC.PrepareScalarCast(sema, lit, fn_ty)

    # --- Cleanup wrapping: nothing is pending here, so both hand the node straight back ---
    @test !CC.is_null_handle(CC.MaybeCreateExprWithCleanups(sema, lit))
    body = CC.getBody(fd)
    @test body isa CC.AbstractStmt
    @test !CC.is_null_handle(CC.MaybeCreateStmtWithCleanups(sema, body))

    # --- The static_assert message, round-tripped against the text the test wrote ---
    tu = CC.getTranslationUnitDecl(ctx)
    sad = nothing
    for d in CC.decls(CC.castToDeclContext(tu))
        d isa CC.StaticAssertDecl && (sad=d; break)
    end
    @test sad !== nothing
    if sad !== nothing
        msg = CC.getMessage(sad)
        @test CC.resolve(msg) isa CC.StringLiteral
        # The parser builds the message as an *unevaluated* string, and an unevaluated
        # string literal carries no type at all — so the precondition may only reach for
        # the type after the string-literal case has been ruled out.
        @test CC.getKind(CC.resolve(msg)) == CC.CXStringLiteralKind_Unevaluated
        @test CC.isNull(CC.getType(msg))
        # Any wrapper that reads an arbitrary operand's type must reject this
        # literal through its own precondition rather than trip clang's
        # "Cannot retrieve a NULL type pointer" assertion and abort the process.
        @test_throws AssertionError CC.expr_type_ptr(msg)
        @test_throws AssertionError CC.getBestDynamicClassType(msg)
        @test_throws AssertionError CC.CheckVecStepExpr(sema, msg)
        @test CC.EvaluateStaticAssertMessageAsString(sema, msg, ctx) ==
              "int is at least two bytes"
        # an integer literal is neither a string literal nor a class object
        @test_throws AssertionError CC.EvaluateStaticAssertMessageAsString(sema, lit, ctx)
    end

    # --- Constraint-expression equality, which profiles the two expressions ---
    @test CC.AreConstraintExpressionsEqual(sema, nothing, lit, nothing, lit)
    @test CC.AreConstraintExpressionsEqual(sema, nothing, lit, nothing, lit7) == false
    @test CC.AreConstraintExpressionsEqual(sema, fd, lit, fd, lit)

    # --- The implicit cast builder, and the two value-category preconditions ---
    icast = CC.ImpCastExprToType(sema, lit, double_ty, CC.CXCastKind_CK_IntegralToFloating)
    @test icast isa CC.Expr_
    @test CC.resolve(icast) isa CC.ImplicitCastExpr
    @test CC.isPRValue(lit)
    @test_throws AssertionError CC.ImpCastExprToType(sema, lit, double_ty,
                                                     CC.CXCastKind_CK_IntegralToFloating,
                                                     CC.CXExprValueKind_VK_LValue)

    # --- Blaming a conjunct of a boolean condition, and describing it ---
    (failed, desc) = CC.findFailedBooleanCondition(sema, lit)
    @test failed isa CC.Expr_
    @test failed.ptr != C_NULL
    @test desc isa String
    @test occursin("42", desc)

    CC.LLVM.API.LLVMDisposeGenericValue(gv)
    CC.LLVM.API.LLVMDisposeGenericValue(gv7)
    dispose(f)
    dispose(I)
end

@testset "Sema | scope, declaration-context and evaluation-context stacks" begin
    # Every push here mutates Sema's own stacks, so this runs against a throwaway
    # interpreter and pairs each push with its pop before the testset ends.
    I = create_interpreter(["-std=c++17"])
    CC.parse(I, """
             namespace semaStk7NS { int semaStk7Var = 1; }
             using namespace semaStk7NS;
             int semaStk7Fn(int n) { return n + 1; }
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    tu = CC.getTranslationUnitDecl(ctx)
    tu_dc = CC.castToDeclContext(tu)
    diag = CC.getDiagnostics(sema)

    # --- The declaration-context stack round-trips. The pop moves to the *containing*
    # context, so the pushed context has to be a nested one for the round trip to land
    # back where it started; pushing the translation unit itself would pop to nothing. ---
    ns = nothing
    for d in CC.decls(tu_dc)
        d isa CC.NamespaceDecl && (ns=d; break)
    end
    @test ns !== nothing
    before = CC.getCurLexicalContext(sema)
    @test before.ptr != C_NULL
    @test before.ptr == tu_dc.ptr
    # A scope that can hold declarations: getNonFieldDeclScope climbs until it finds one,
    # so a scope built with no flags and no parent would send it off the end of the chain.
    scope = CC.Scope(nothing, UInt32(CC.CXScopeFlags_DeclScope), diag)
    CC.PushDeclContext(sema, scope, CC.castToDeclContext(ns))
    @test CC.getCurLexicalContext(sema).ptr == CC.castToDeclContext(ns).ptr
    @test CC.PopDeclContext(sema) === nothing
    @test CC.getCurLexicalContext(sema).ptr == before.ptr
    # and the translation unit is the floor, not a context that can be popped
    @test_throws AssertionError CC.PopDeclContext(sema)

    # --- The expression-evaluation stack round-trips, and an unevaluated context is
    # what makes `sizeof`'s operand unevaluated ---
    @test !CC.isUnevaluatedContext(sema)
    CC.PushExpressionEvaluationContext(sema, CC.CXExpressionEvaluationContext_Unevaluated)
    @test CC.isUnevaluatedContext(sema)
    @test CC.PopExpressionEvaluationContext(sema) === nothing
    @test !CC.isUnevaluatedContext(sema)
    # the lambda-context decl and the expression kind are both accepted
    CC.PushExpressionEvaluationContext(sema,
                                       CC.CXExpressionEvaluationContext_PotentiallyEvaluated,
                                       tu, CC.CXExpressionKind_EK_Decltype)
    @test CC.PopExpressionEvaluationContext(sema) === nothing

    # --- The CUDA host/device stack reports an unbalanced pop instead of underflowing ---
    @test CC.PopForceCUDAHostDevice(sema) == false
    @test CC.PushForceCUDAHostDevice(sema) === nothing
    @test CC.PopForceCUDAHostDevice(sema)

    # --- A compound scope needs a function scope under it, and says so ---
    # Nothing has pushed a function scope yet, so both halves of the pair refuse. The
    # accepting case is exercised below, after PushFunctionScope supplies one.
    @test !CC.hasCurFunction(sema)
    @test_throws AssertionError CC.PushCompoundScope(sema, false)
    @test_throws AssertionError CC.PopCompoundScope(sema)
    # pushing a function scope gives the compound scope somewhere to sit
    CC.PushFunctionScope(sema)
    @test CC.hasCurFunction(sema)
    CC.PushCompoundScope(sema, true)
    @test CC.PopCompoundScope(sema) === nothing

    # --- Block and captured-region scopes, over decls built for the purpose ---
    blk = CC.BlockDecl(ctx, tu_dc, loc)
    @test CC.PushBlockScope(sema, scope, blk) === nothing
    cap = CC.CapturedDecl(ctx, tu_dc, 1)
    rec = CC.CXXRecordDecl(ctx, CC.CXTagTypeKind_Struct, tu_dc, loc, loc,
                           CC.get_name(ctx, "semaStk7Rec"))
    @test CC.PushCapturedRegionScope(sema, scope, cap, rec,
                                     CC.CXCapturedRegionKind_CR_Default) === nothing

    # --- Visibility: the namespace attribute pushes, PopPragmaVisibility pops ---
    @test CC.PopPragmaVisibility(sema, false, loc) === nothing

    # --- Scope chains ---
    @test CC.PushOnScopeChains(sema, rec, scope, false) === nothing
    @test !CC.is_null_handle(CC.getNonFieldDeclScope(sema, scope))
    # a chain with no declaration scope in it is refused rather than walked off the end
    bare = CC.Scope(nothing, 0, diag)
    @test_throws AssertionError CC.getNonFieldDeclScope(sema, bare)
    dispose(bare)
    @test CC.is_null_handle(CC.getScopeForDeclContext(scope, tu_dc))
    @test CC.getTemplateDepth(sema, scope) isa Integer

    ud = nothing
    for d in CC.decls(tu_dc)
        d isa CC.UsingDirectiveDecl && (ud=d; break)
    end
    @test ud !== nothing
    ud !== nothing && @test CC.PushUsingDirective(sema, scope, ud) === nothing

    dispose(scope)
    dispose(I)
end

@testset "Sema | module, namespace and defaulted-comparison accessors" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
             int semaAcc7Fn(int n) { return n; }
             """)
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    f = DeclFinder(I)

    @assert f(I, "semaAcc7Fn") "lookup failed: semaAcc7Fn"
    fd = CC.FunctionDecl(get_decl(f))

    # A plain function defaults no comparison; the enum still answers.
    k = CC.getDefaultedComparisonKind(sema, fd)
    @test k isa CC.CXDefaultedComparisonKind
    @test k == CC.CXDefaultedComparisonKind_None

    # `std` is created on demand, so it exists after asking even though nothing declared it.
    std_ns = CC.getOrCreateStdNamespace(sema)
    @test std_ns isa CC.NamespaceDecl
    @test std_ns.ptr != C_NULL
    @test CC.getName(std_ns) == "std"

    # Nothing here is owned by a module, but the accessor must answer with a carrier.
    @test CC.is_null_handle(CC.getOwningModule(sema, fd))
    @test !CC.is_null_handle(CC.getModuleLoader(sema))

    # The implicit code-seg/section attribute: absent on a plain function.
    a = CC.getImplicitCodeSegOrSectionAttrForFunction(sema, fd, true)
    @test a isa CC.Attr

    # Nothing at the top of the file can capture the parameter, so the captured-reference
    # type is the null QualType that answers "not capturable here".
    @test CC.getNumParams(fd) == 1
    qt = CC.getCapturedDeclRefType(sema, CC.getParamDecl(fd, 0), loc)
    @test qt isa CC.QualType
    @test CC.isNull(qt)

    # A declaration parsed into this TU is both visible and reachable, and its definition is
    # acceptable — so there is nothing to suggest in its place.
    @test CC.isAcceptable(sema, fd, CC.CXAcceptableKind_Visible)
    @test CC.isAcceptable(sema, fd, CC.CXAcceptableKind_Reachable)
    ok, suggested = CC.hasAcceptableDefinition(sema, fd, CC.CXAcceptableKind_Visible)
    @test ok
    @test suggested === nothing

    dispose(I)
end

@testset "Sema | matrix dimensions" begin
    I = create_interpreter(["-fenable-matrix"])
    CC.parse(I, """
             typedef int m2x3_t __attribute__((matrix_type(2, 3)));
             typedef int n2x3_t __attribute__((matrix_type(2, 3)));
             typedef int m3x2_t __attribute__((matrix_type(3, 2)));
             extern "C" void mat_probe(m2x3_t a, n2x3_t b, m3x2_t c, int d) {}
             """)
    sema = CC.get_sema(I)

    f = DeclFinder(I)
    @test f(I, "mat_probe")
    mfd = CC.FunctionDecl(get_decl(f))
    a = CC.getType(CC.getParamDecl(mfd, 0))
    b = CC.getType(CC.getParamDecl(mfd, 1))
    c = CC.getType(CC.getParamDecl(mfd, 2))
    @test CC.isConstantMatrixType(CC.getTypePtr(a))

    # 2x3 matches another 2x3 reached through a distinct typedef, and does not match 3x2 —
    # the comparison is on dimensions, not on type identity.
    @test CC.areMatrixTypesOfTheSameDimension(sema, a, b)
    @test !CC.areMatrixTypesOfTheSameDimension(sema, a, c)
    @test CC.areMatrixTypesOfTheSameDimension(sema, a, a)

    # a non-matrix operand is the restated precondition, not an answer
    int_ty = CC.getType(CC.getParamDecl(mfd, 3))
    @test !CC.isConstantMatrixType(CC.getTypePtr(int_ty))
    @test_throws AssertionError CC.areMatrixTypesOfTheSameDimension(sema, a, int_ty)
    @test_throws AssertionError CC.areMatrixTypesOfTheSameDimension(sema, int_ty, a)

    dispose(f)
    dispose(I)
end

@testset "Sema | template argument bindings text and pack size" begin
    I = create_interpreter(String[])
    CC.parse(I, "template <class T> struct SemaBox { T value; };")
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    llctx = CC.LLVM.Context()

    f = DeclFinder(I)
    @test f(I, "SemaBox")
    ctd = CC.ClassTemplateDecl(get_decl(f))
    spec = CC.specialize(llctx, ctx, ctd, CC.jlty_to_clty(Int32, ctx))
    @test spec isa CC.ClassTemplateSpecializationDecl

    params = CC.getTemplateParameters(ctd)
    args = CC.getTemplateArgs(spec)
    text = CC.getTemplateArgumentBindingsText(sema, params, args)
    # the text names the parameter and the argument it was bound to
    @test occursin("T", text)
    @test occursin("int", text)

    # a non-pack argument has no fully-expanded size
    @test CC.getFullyPackExpandedSize(sema, CC.get(args, 0)) === nothing

    dispose(f)
    dispose(I)
end

@testset "Sema | identity template arguments and FP state" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             template <typename IdT, int IdN> struct IdS {};
             template <typename... IdPack> struct IdPk {};
             """)
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(CC.get_instance(I))
    loc = CC.getLocForStartOfFile(sm, CC.getMainFileID(sm))

    f = DeclFinder(I)
    @test f(I, "IdS")
    td = CC.ClassTemplateDecl(get_decl(f))
    params = CC.getTemplateParameters(td)

    # the two parameters of the SAME template produce DIFFERENT argument kinds, so neither
    # answer is fixed by the wrapper's return type
    p0 = CC.getParam(params, 0)
    p1 = CC.getParam(params, 1)
    tal0 = CC.getIdentityTemplateArgumentLoc(sema, p0, loc)
    tal1 = CC.getIdentityTemplateArgumentLoc(sema, p1, loc)
    k0 = CC.getKind(CC.getArgument(tal0))
    k1 = CC.getKind(CC.getArgument(tal1))
    @test k0 == CC.CXTemplateArgument_Type
    @test k1 == CC.CXTemplateArgument_Expression
    @test k0 != k1
    # and the type argument spells the parameter's own name, a value clang decided
    @test CC.printAsString(CC.getAsType(CC.getArgument(tal0)), ctx) == "IdT"
    CC.dispose(tal0)
    CC.dispose(tal1)

    # the gate rejects a declaration that is not a template parameter
    @test_throws AssertionError CC.getIdentityTemplateArgumentLoc(sema,
                                                                  CC.NamedDecl(td), loc)

    # the FP state is a word the decoders read, and it agrees with the context's default
    w = CC.getCurFPFeatures(sema)
    @test !(CC.allowFPContractWithinStatement(w) && CC.allowFPContractAcrossStatement(w))
    @test CC.isFPConstrained(w) ==
          (CC.getExceptionMode(w) != CC.CXFPExceptionModeKind_FPE_Ignore ||
           CC.getRoundingMode(w) != CC.CXRoundingMode_NearestTiesToEven)

    dispose(f)
    dispose(I)
end

@testset "Sema | partial ordering, format attributes and overload resolution" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             template <typename A> void po_fn(A);
             template <typename A> void po_fn(A *);
             __attribute__((format(printf, 2, 3))) void fmt_fn(int x, const char *f, ...);
             void ovl_one(int);
             """)
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(CC.get_instance(I))
    loc = CC.getLocForStartOfFile(sm, CC.getMainFileID(sm))

    f = DeclFinder(I)

    # partial ordering: `po_fn(A*)` is more specialized than `po_fn(A)`, and asking the
    # question the other way round gives the SAME winner -- so the answer is a property of
    # the pair, not of argument order
    @test f(I, "po_fn")
    fts = [CC.FunctionTemplateDecl(d)
           for d in CC.decls_in(CC.castToDeclContext(CC.getTranslationUnitDecl(CC.get_ast_context(I))))
           if d isa CC.FunctionTemplateDecl]
    @test length(fts) >= 2
    a, b = fts[1], fts[2]
    w1 = CC.getMoreSpecializedTemplate(sema, a, b, loc, CC.CXTPOC_TPOC_Call, 1, 1)
    w2 = CC.getMoreSpecializedTemplate(sema, b, a, loc, CC.CXTPOC_TPOC_Call, 1, 1)
    @test w1 !== nothing
    @test w2 !== nothing
    @test w1.ptr == w2.ptr
    # the reversed form is only defined for call-context ordering
    @test_throws AssertionError CC.getMoreSpecializedTemplate(sema, a, b, loc,
                                                              CC.CXTPOC_TPOC_Other, 1, 1;
                                                              reversed=true)

    # the format attribute decodes to the indices actually written in the source
    @test f(I, "fmt_fn")
    fd = CC.FunctionDecl(get_decl(f))
    fattrs = [x for x in CC.getAttrs(fd) if CC.get_attr_kind(x) == CC.CXAttrKind_Format]
    @test length(fattrs) == 1
    info = CC.getFormatStringInfo(CC.FormatAttr(only(fattrs)), false, true)
    @test info !== nothing
    # `format(printf, 2, 3)` is 1-based over the written parameters; the decoded indices name
    # the format string and the first vararg
    @test info.format_idx == 1
    @test info.first_data_arg == 2
    @test info.arg_passing_kind == CC.CXFormatArgumentPassingKind_FAPK_Variadic

    dispose(f)
    dispose(I)
end

@testset "Sema | abstract types, named-return info and __uuidof" begin
    I = create_interpreter(["-std=c++20", "-fms-extensions"])
    CC.parse(I, """
              struct SemaAbsFwd;
              struct SemaAbsA { virtual void f() = 0; };
              struct SemaAbsB : SemaAbsA { void f() override {} };
              struct SemaNRBig { double a, b, c; };
              SemaNRBig sema_nr_returned()     { SemaNRBig v; return v; }
              SemaNRBig sema_nr_not_returned() { SemaNRBig v; return SemaNRBig(); }
              SemaNRBig sema_nr_overaligned()  { alignas(64) SemaNRBig v; return v; }
              SemaNRBig sema_nr_param(SemaNRBig p) { return p; }
              struct __declspec(uuid("12345678-1234-1234-1234-1234567890ab")) SemaUid {};
              struct SemaNoUid {};
              """)
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    loc = CC.SourceLocation()

    @testset "isAbstractType sees through arrays, and needs no definition" begin
        A = CC.getTypeDeclType(ctx, CC.find_decl(I, "SemaAbsA"))
        B = CC.getTypeDeclType(ctx, CC.find_decl(I, "SemaAbsB"))
        fwd = CC.getTypeDeclType(ctx, CC.find_decl(I, "SemaAbsFwd"))
        @test CC.isAbstractType(sema, loc, A)
        @test !CC.isAbstractType(sema, loc, B)
        # An array of an abstract class is itself abstract. This is the discriminating case:
        # an implementation reaching for getAsCXXRecordDecl instead of peeling the element type
        # answers false here. Source-level `SemaAbsA[4]` is rejected by clang, so build it.
        @test CC.isAbstractType(sema, loc, CC.getConstantArrayType(ctx, A, 4))
        # and a record with no definition answers rather than reading definition data
        @test !CC.isAbstractType(sema, loc, fwd)
    end

    @testset "getNamedReturnInfo answers where isNRVOVariable cannot" begin
        function first_local(fn)
            body = CC.resolve(CC.getBody(CC.find_decl(I, fn)))
            vs = [CC.resolve(d) for n in CC.subtree(body) if n isa CC.DeclStmt
                  for d in CC.getDecls(n)]
            return first(v for v in vs if v isa CC.VarDecl)
        end
        E = CC.LibClangEx
        returned = first_local("sema_nr_returned")
        @test CC.getNamedReturnInfo(sema, returned) ==
              E.CXNamedReturnInfo_MoveEligibleAndCopyElidable
        @test CC.isNRVOVariable(returned)

        # The three rows where the two disagree, which is the whole reason this exists.
        # A local that is never the return operand is still elidable as a candidate...
        not_returned = first_local("sema_nr_not_returned")
        @test CC.getNamedReturnInfo(sema, not_returned) ==
              E.CXNamedReturnInfo_MoveEligibleAndCopyElidable
        @test !CC.isNRVOVariable(not_returned)
        # ...an over-aligned local is move-eligible but NOT copy-elidable, a rule nothing else
        # in the wrapped surface exposes...
        overaligned = first_local("sema_nr_overaligned")
        @test CC.getNamedReturnInfo(sema, overaligned) == E.CXNamedReturnInfo_MoveEligible
        @test !CC.isNRVOVariable(overaligned)
        # ...and so is a parameter, for a different reason.
        param = CC.getParamDecl(CC.find_decl(I, "sema_nr_param"), 0)
        @test CC.getNamedReturnInfo(sema, param) == E.CXNamedReturnInfo_MoveEligible
        @test !CC.isNRVOVariable(param)
    end

    @testset "BuildCXXUuidof accepts a type with a GUID and rejects one without" begin
        @test CC.getMicrosoftExt(CC.getLangOpts(sema))
        guid = CC.get_qual_type(CC.getMSGuidType(ctx))
        @test !CC.is_null_handle(guid)
        function uuidof(name)
            ty = CC.getTypeDeclType(ctx, CC.find_decl(I, name))
            return CC.BuildCXXUuidof(sema, guid, loc,
                                     CC.getTrivialTypeSourceInfo(ctx, ty, loc), loc)
        end
        @test uuidof("SemaUid") isa CC.Expr_
        # clang diagnoses "no GUID" and the wrapper reports the rejection rather than a node
        @test uuidof("SemaNoUid") === nothing
    end

    dispose(I)
end

@testset "Sema | flag-enum membership and the printing policy" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             enum __attribute__((flag_enum)) SemaFlags { SFA = 1, SFB = 2, SFD = 4 };
             """)
    sema = CC.get_sema(I)
    ctx = CC.get_ast_context(I)
    intty = CC.get_qual_type(CC.IntTy(ctx))

    f = DeclFinder(I)
    @test f(I, "SemaFlags")
    ed = CC.EnumDecl(get_tag(f))

    inflag(n, mask=false) = begin
        gv = CC.LLVM.GenericValue(CC.MakeIntValue(ctx, n, intty))
        r = CC.IsValueInFlagEnum(sema, ed, gv, mask)
        CC.LLVM.dispose(gv)
        r
    end

    # any OR of the enumerators is in the enum; zero is; a bit the enum does not declare is not
    @test inflag(1)
    @test inflag(3)          # SFA | SFB
    @test inflag(5)          # SFA | SFD
    @test inflag(7)          # all three
    @test inflag(0)
    @test inflag(8) == false # no enumerator has that bit

    # allow_mask is what the flag decides, and this pair is the only thing that proves the
    # wrapper passes it: ~7 is not itself a value in the enum, but it is the complement of one,
    # so it is accepted as a mask and rejected otherwise.
    @test inflag(0xFFFFFFF8, true) == true
    @test inflag(0xFFFFFFF8, false) == false

    # Sema's printing policy is a fresh object the caller owns, unlike the ASTContext's, which
    # is a borrowed member -- so this one is disposed and that one must not be.
    pp = CC.getPrintingPolicy(sema)
    @test pp isa CC.PrintingPolicy
    @test pp.ptr != C_NULL
    @test pp.ptr != CC.getPrintingPolicy(ctx).ptr    # distinct objects, not the same box
    CC.dispose(pp)

    dispose(f)
    dispose(I)
end
