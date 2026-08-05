using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Overload | conversion sequences and the candidate set" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)

    int_ptr = CC.getIntPtrType(ctx)
    ptr_ty = CC.getPointerType(ctx, int_ptr)
    @test int_ptr isa CC.QualType
    @test int_ptr.ptr != C_NULL
    @test ptr_ty.ptr != C_NULL
    @test ptr_ty.ptr != int_ptr.ptr

    # An ImplicitConversionSequence is a heap-boxed value type; a fresh one carries the
    # private Uninitialized sentinel, so no kind query is legal on it yet.
    ics = CC.ImplicitConversionSequence()
    @test ics isa CC.ImplicitConversionSequence
    @test ics.ptr != C_NULL
    @test CC.isInitialized(ics) == false
    @test CC.hasInitializerListContainerType(ics) == false
    @test CC.isInitializerListOfIncompleteArray(ics) == false

    # The standard-conversion arm, reached through setAsIdentityConversion.
    CC.setAsIdentityConversion(ics, int_ptr)
    @test CC.isInitialized(ics)
    @test CC.getKind(ics) == CC.CXImplicitConversionSequence_StandardConversion
    @test CC.getKindRank(ics) == 0
    @test CC.isStandard(ics)
    @test !CC.isStaticObjectArgument(ics)
    @test !CC.isUserDefined(ics)
    @test !CC.isAmbiguous(ics)
    @test !CC.isEllipsis(ics)
    @test !CC.isBad(ics)
    @test !CC.isFailure(ics)

    scs = CC.getStandard(ics)
    @test scs isa CC.StandardConversionSequence
    @test scs.ptr != C_NULL
    @test CC.isIdentityConversion(scs)
    @test CC.getFromType(scs).ptr == int_ptr.ptr
    for i = 0:2
        @test CC.getToType(scs, i).ptr == int_ptr.ptr
    end
    @test_throws AssertionError CC.getToType(scs, 3)

    # The ellipsis arm carries no payload.
    CC.setEllipsis(ics)
    @test CC.getKind(ics) == CC.CXImplicitConversionSequence_EllipsisConversion
    @test CC.isEllipsis(ics)
    @test !CC.isStandard(ics)
    @test CC.getKindRank(ics) == 2
    @test_throws AssertionError CC.getStandard(ics)

    # The bad arm, whose payload round-trips the two types the failure was built from.
    CC.setBad(ics, CC.CXBadConversionSequence_no_conversion, int_ptr, ptr_ty)
    @test CC.getKind(ics) == CC.CXImplicitConversionSequence_BadConversion
    @test CC.isBad(ics)
    @test CC.isFailure(ics)
    @test CC.getKindRank(ics) == 3
    bad = CC.getBad(ics)
    @test bad isa CC.BadConversionSequence
    @test bad.ptr != C_NULL
    @test CC.getFromType(bad).ptr == int_ptr.ptr
    @test CC.getToType(bad).ptr == ptr_ty.ptr

    # The initializer-list container type lives beside the union, not inside it.
    @test_throws AssertionError CC.getInitializerListContainerType(ics)
    CC.setInitializerListContainerType(ics, ptr_ty, true)
    @test CC.hasInitializerListContainerType(ics)
    @test CC.getInitializerListContainerType(ics).ptr == ptr_ty.ptr
    @test CC.isInitializerListOfIncompleteArray(ics)
    @test CC.isBad(ics)

    CC.dispose(ics)

    # An OverloadCandidateSet is created empty and owns whatever is later added to it.
    loc = CC.get_main_file_begin_loc(sm)
    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    @test cs isa CC.OverloadCandidateSet
    @test cs.ptr != C_NULL
    @test CC.getKind(cs) == CC.CXOverloadCandidateSet_CSK_Normal
    @test !CC.is_null_handle(CC.getLocation(cs))
    @test CC.getLocation(cs).ptr == loc.ptr
    @test CC.empty(cs)
    @test size(cs) == 0

    CC.clear(cs, CC.CXOverloadCandidateSet_CSK_Operator)
    @test CC.empty(cs)
    @test size(cs) == 0
    @test CC.getKind(cs) isa CC.CXOverloadCandidateSet_CandidateSetKind
    @test CC.getLocation(cs).ptr == loc.ptr

    CC.dispose(cs)
    dispose(I)
end

@testset "Overload | conversion-sequence payloads, the nullptr-to-bool factory and candidate keys" begin
    I = create_interpreter()
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    int_ptr = CC.getIntPtrType(ctx)
    ptr_ty = CC.getPointerType(ctx, int_ptr)
    bool_ty = CC.get_qual_type(CC.BoolTy(ctx))

    # The standard arm is reachable only while the sequence's kind says so, and the
    # sequence-level setAsIdentityConversion is what first fills in the arm's types.
    ics = CC.ImplicitConversionSequence()
    CC.setAsIdentityConversion(ics, int_ptr)
    scs = CC.getStandard(ics)

    CC.setFromType(scs, ptr_ty)
    @test CC.getFromType(scs).ptr == ptr_ty.ptr
    CC.setToType(scs, 1, ptr_ty)
    @test CC.getToType(scs, 1).ptr == ptr_ty.ptr
    @test CC.getToType(scs, 0).ptr == int_ptr.ptr
    @test_throws AssertionError CC.setToType(scs, 3, ptr_ty)
    CC.setAllToTypes(scs, bool_ty)
    for i = 0:2
        @test CC.getToType(scs, i).ptr == bool_ty.ptr
    end

    # setAsIdentityConversion on the arm resets the three conversion kinds only. The types
    # set above survive it, which is what keeps the two pointer predicates defined.
    CC.setAsIdentityConversion(scs)
    @test CC.isIdentityConversion(scs)
    @test CC.getRank(scs) in instances(CC.CXImplicitConversionRank)
    @test CC.isPointerConversionToBool(scs)
    @test !(CC.isPointerConversionToVoidPointer(scs, ctx))

    # The kind setters that carry no payload of their own.
    CC.setStaticObjectArgument(ics)
    @test CC.isStaticObjectArgument(ics)
    @test CC.getKindRank(ics) == 0
    CC.setStandard(ics)
    @test CC.isStandard(ics)
    CC.setAmbiguous(ics)
    @test CC.isAmbiguous(ics)
    @test CC.getKind(ics) == CC.CXImplicitConversionSequence_AmbiguousConversion
    @test CC.getKindRank(ics) == 1

    # The bad arm's failure kind and source expression. setBad switches away from the
    # ambiguous kind, which destroys the conversion set constructed just above.
    e = CC.CXXBoolLiteralExpr(ctx, true, bool_ty, loc)
    CC.setBad(ics, CC.CXBadConversionSequence_bad_qualifiers, int_ptr, ptr_ty)
    bad = CC.getBad(ics)
    @test CC.getFailureKind(bad) == CC.CXBadConversionSequence_bad_qualifiers
    @test CC.is_null_handle(CC.getFromExpr(bad))
    @test CC.getFromExpr(bad).ptr == C_NULL
    CC.setFromExpr(bad, e)
    @test CC.getFromExpr(bad).ptr == e.ptr
    @test CC.getFromType(bad).ptr == CC.getType(e).ptr
    CC.setFromType(bad, int_ptr)
    @test CC.getFromType(bad).ptr == int_ptr.ptr
    CC.setToType(bad, bool_ty)
    @test CC.getToType(bad).ptr == bool_ty.ptr
    CC.dispose(ics)

    # getNullptrToBool is a static factory: the sequence it returns is a fresh owned box
    # whose standard arm holds exactly the types handed in.
    n2b = CC.getNullptrToBool(int_ptr, bool_ty, true)
    @test n2b isa CC.ImplicitConversionSequence
    @test n2b.ptr != C_NULL
    @test CC.isStandard(n2b)
    n2b_scs = CC.getStandard(n2b)
    @test CC.getFromType(n2b_scs).ptr == int_ptr.ptr
    @test CC.getToType(n2b_scs, 0).ptr == int_ptr.ptr
    @test CC.getToType(n2b_scs, 1).ptr == bool_ty.ptr
    @test CC.getToType(n2b_scs, 2).ptr == bool_ty.ptr
    @test CC.getRank(n2b_scs) in instances(CC.CXImplicitConversionRank)
    CC.dispose(n2b)

    # Candidate keys: a declaration is new to a set exactly once per parameter order. The
    # translation unit decl is its own canonical declaration, so it needs no lookup.
    tu = CC.getTranslationUnitDecl(ctx)
    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    @test CC.isNewCandidate(cs, tu)
    @test !CC.isNewCandidate(cs, tu)
    @test CC.isNewCandidate(cs, tu, true)
    @test !CC.isNewCandidate(cs, tu, true)
    @test CC.getDestAS(cs) == CC.CXLangAS_Default
    @test_throws AssertionError CC.setDestAS(cs, CC.CXLangAS_opencl_global)
    CC.dispose(cs)

    excluded = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    CC.exclude(excluded, tu)
    @test !CC.isNewCandidate(excluded, tu)
    @test !CC.isNewCandidate(excluded, tu, true)
    CC.dispose(excluded)

    # A destination address space may only be set while the set is constructing an object.
    ctor_set = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_InitByConstructor)
    CC.setDestAS(ctor_set, CC.CXLangAS_opencl_global)
    @test CC.getDestAS(ctor_set) == CC.CXLangAS_opencl_global
    CC.dispose(ctor_set)

    dispose(I)
end

@testset "Overload | the ambiguous arm, candidate storage and operator rewrite info" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ovl_amb_fn(int a) { return a; }")
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    int_ptr = CC.getIntPtrType(ctx)
    bool_ty = CC.get_qual_type(CC.BoolTy(ctx))

    f = DeclFinder(I)
    @test f(I, "ovl_amb_fn")
    fn = CC.downcast(CC.FunctionDecl, get_decl(f).ptr)
    found = get_decl(f)

    # The ambiguous arm is reachable only while the sequence's kind says so.
    ics = CC.ImplicitConversionSequence()
    @test_throws AssertionError CC.getAmbiguous(ics)
    CC.setAmbiguous(ics)
    @test CC.isAmbiguous(ics)
    amb = CC.getAmbiguous(ics)
    @test amb isa CC.AmbiguousConversionSequence
    @test amb.ptr != C_NULL

    # setAmbiguous constructs an empty conversion set and leaves the from- and to-types
    # indeterminate, so both are written before either is read back.
    @test CC.getNumConversions(amb) == 0
    CC.setFromType(amb, int_ptr)
    CC.setToType(amb, bool_ty)
    @test CC.getFromType(amb).ptr == int_ptr.ptr
    @test CC.getToType(amb).ptr == bool_ty.ptr

    CC.addConversion(amb, found, fn)
    @test CC.getNumConversions(amb) == 1
    @test !CC.is_null_handle(CC.getConversionFound(amb, 0))
    @test CC.getConversionFound(amb, 0).ptr == found.ptr
    @test CC.getConversionFunction(amb, 0) isa CC.FunctionDecl
    @test CC.getConversionFunction(amb, 0).ptr == fn.ptr
    @test_throws AssertionError CC.getConversionFound(amb, 1)
    @test_throws AssertionError CC.getConversionFunction(amb, 1)

    # Changing the kind destroys the conversion set and closes the arm again.
    CC.setUserDefined(ics)
    @test CC.isUserDefined(ics)
    @test CC.getKind(ics) == CC.CXImplicitConversionSequence_UserDefinedConversion
    @test CC.getKindRank(ics) == 1
    @test_throws AssertionError CC.getAmbiguous(ics)
    CC.dispose(ics)

    # BadConversionSequence::init, the overload that takes the source expression and reads
    # the from-type off it.
    ics2 = CC.ImplicitConversionSequence()
    CC.setBad(ics2, CC.CXBadConversionSequence_no_conversion, int_ptr, bool_ty)
    bad = CC.getBad(ics2)
    e = CC.CXXBoolLiteralExpr(ctx, true, bool_ty, loc)
    CC.init(bad, CC.CXBadConversionSequence_too_few_initializers, e, int_ptr)
    @test CC.getFailureKind(bad) == CC.CXBadConversionSequence_too_few_initializers
    @test CC.getFromExpr(bad).ptr == e.ptr
    @test CC.getFromType(bad).ptr == CC.getType(e).ptr
    @test CC.getToType(bad).ptr == int_ptr.ptr
    CC.dispose(ics2)

    # The plain create leaves the operator rewrite info at clang's default.
    plain = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    @test CC.getRewriteInfoOriginalOperator(plain) == CC.CXOverloadedOperatorKind_OO_None
    @test CC.getRewriteInfoAllowRewrittenCandidates(plain) == false
    @test CC.is_null_handle(CC.getRewriteInfoOpLoc(plain))
    CC.dispose(plain)

    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator,
                                 CC.CXOverloadedOperatorKind_OO_Less, loc, true)
    @test cs isa CC.OverloadCandidateSet
    @test cs.ptr != C_NULL
    @test CC.getKind(cs) == CC.CXOverloadCandidateSet_CSK_Operator
    @test CC.getRewriteInfoOriginalOperator(cs) == CC.CXOverloadedOperatorKind_OO_Less
    @test CC.getRewriteInfoOpLoc(cs).ptr == loc.ptr
    @test CC.getRewriteInfoAllowRewrittenCandidates(cs)

    # Candidate storage: the set owns its candidates and the conversion slots it hands out.
    @test CC.empty(cs)
    cand = CC.addCandidate(cs, 2)
    @test cand isa CC.OverloadCandidate
    @test cand.ptr != C_NULL
    @test size(cs) == 1
    @test !CC.empty(cs)
    @test CC.getCandidate(cs, 0).ptr == cand.ptr
    @test_throws AssertionError CC.getCandidate(cs, 1)

    @test CC.getNumConversions(cand) == 2
    # No function and no surrogate, so the parameter count is the recorded argument count,
    # which the add call above set.
    @test CC.getNumParams(cand) == 2
    @test CC.getRewriteKind(cand) == CC.CXOverloadCandidateRewriteKind_CRK_None
    @test !CC.isReversed(cand)
    @test !CC.NotValidBecauseConstraintExprHasError(cand)

    # The conversion slots are default-constructed, so the ambiguity scan stops at the first
    # of them until that one is given a kind.
    slot = CC.getConversion(cand, 0)
    @test slot isa CC.ImplicitConversionSequence
    @test !CC.isInitialized(slot)
    @test !CC.hasAmbiguousConversion(cand)
    CC.setAmbiguous(slot)
    @test CC.hasAmbiguousConversion(cand)
    @test_throws AssertionError CC.getConversion(cand, 2)

    CC.dispose(cs)
    dispose(I)
end

@testset "Overload | the user-defined arm, narrowing kinds and the candidate-set tail" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ovl4_target_fn(int a) { return a; }")
    sema = CC.get_sema(I)
    ctx = CC.getASTContext(sema)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    int_ptr = CC.getIntPtrType(ctx)
    bool_ty = CC.get_qual_type(CC.BoolTy(ctx))
    e = CC.CXXBoolLiteralExpr(ctx, true, bool_ty, loc)

    f = DeclFinder(I)
    @test f(I, "ovl4_target_fn")
    fn = CC.downcast(CC.FunctionDecl, get_decl(f).ptr)
    found = get_decl(f)

    # The standard arm dumps only its three conversion kinds, which the owning sequence's
    # constructor already set to the identity conversion.
    ics = CC.ImplicitConversionSequence()
    CC.setAsIdentityConversion(ics, int_ptr)
    scs = CC.getStandard(ics)
    @test CC.dump(scs) === nothing
    @test CC.dump(ics) === nothing

    # Narrowing. The destination type only comes back on the constant-narrowing outcome, so
    # both halves are asserted by shape.
    av = CC.IndeterminateValue()
    kind, narrowed = CC.getNarrowingKind(scs, ctx, e, av)
    @test kind isa CC.CXNarrowingKind
    @test kind in instances(CC.CXNarrowingKind)
    @test narrowed isa CC.QualType
    kind2, narrowed2 = CC.getNarrowingKind(scs, ctx, e, av, true)
    @test kind2 in instances(CC.CXNarrowingKind)
    @test narrowed2 isa CC.QualType
    CC.dispose(av)

    # The user-defined arm. Switching the kind does not initialise it, so every member is
    # written before anything reads it.
    @test_throws AssertionError CC.getUserDefined(ics)
    CC.setUserDefined(ics)
    ud = CC.getUserDefined(ics)
    @test ud isa CC.UserDefinedConversionSequence
    @test ud.ptr != C_NULL

    before = CC.getBefore(ud)
    after = CC.getAfter(ud)
    @test before isa CC.StandardConversionSequence
    @test after isa CC.StandardConversionSequence
    @test before.ptr != after.ptr
    CC.setAsIdentityConversion(before)
    CC.setAsIdentityConversion(after)
    @test CC.isIdentityConversion(before)
    @test CC.isIdentityConversion(after)
    @test CC.dump(after) === nothing

    CC.setEllipsisConversion(ud, false)
    @test CC.getEllipsisConversion(ud) == false
    CC.setEllipsisConversion(ud, true)
    @test CC.getEllipsisConversion(ud)
    CC.setHadMultipleCandidates(ud, true)
    @test CC.getHadMultipleCandidates(ud)
    CC.setHadMultipleCandidates(ud, false)
    @test CC.getHadMultipleCandidates(ud) == false
    CC.setConversionFunction(ud, fn)
    @test CC.getConversionFunction(ud) isa CC.FunctionDecl
    @test CC.getConversionFunction(ud).ptr == fn.ptr

    @test CC.dump(ud) === nothing
    @test CC.dump(ics) === nothing
    CC.dispose(ics)

    # The ambiguous arm's raw lifecycle: destruct tears the conversion set down, copyFrom
    # builds it again as a copy of another arm's, and construct builds an empty one. Both
    # sequences end with a live set, which is what their dispose destroys.
    a = CC.ImplicitConversionSequence()
    CC.setAmbiguous(a)
    amb_a = CC.getAmbiguous(a)
    CC.setFromType(amb_a, int_ptr)
    CC.setToType(amb_a, bool_ty)
    CC.addConversion(amb_a, found, fn)
    @test CC.getNumConversions(amb_a) == 1

    b = CC.ImplicitConversionSequence()
    CC.setAmbiguous(b)
    amb_b = CC.getAmbiguous(b)
    @test CC.getNumConversions(amb_b) == 0
    CC.destruct(amb_b)
    CC.copyFrom(amb_b, amb_a)
    @test CC.getNumConversions(amb_b) == 1
    @test CC.getConversionFound(amb_b, 0).ptr == found.ptr
    @test CC.getConversionFunction(amb_b, 0).ptr == fn.ptr
    @test CC.getFromType(amb_b).ptr == int_ptr.ptr
    @test CC.getToType(amb_b).ptr == bool_ty.ptr

    CC.destruct(amb_b)
    CC.construct(amb_b)
    @test CC.getNumConversions(amb_b) == 0
    CC.dispose(a)
    CC.dispose(b)

    # Conversion slots can be slab-allocated out of a set without a candidate to hold them.
    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    slots = CC.allocateConversionSequences(cs, 3)
    @test length(slots) == 3
    @test all(s -> s isa CC.ImplicitConversionSequence && s.ptr != C_NULL, slots)
    @test allunique(s.ptr for s in slots)
    @test !CC.isInitialized(slots[1])
    @test !CC.isInitialized(slots[3])

    # Deferred diagnostics are a CUDA/HIP notion, so the answer here is host-decided.
    @test !(CC.shouldDeferDiags(cs, sema, CC.Expr_[], loc))
    @test !(CC.shouldDeferDiags(cs, sema, [e], loc))

    # The fix-it repair path reads the conversion's bad arm directly, so an unresolved slot
    # is rejected before the ccall.
    cand = CC.addCandidate(cs, 1)
    slot = CC.getConversion(cand, 0)
    @test_throws AssertionError CC.TryToFixBadConversion(cand, 0, sema)
    CC.setBad(slot, CC.CXBadConversionSequence_no_conversion, bool_ty, bool_ty)
    CC.setFromExpr(CC.getBad(slot), e)
    @test !(CC.TryToFixBadConversion(cand, 0, sema))

    CC.dispose(cs)
    dispose(I)
end

@testset "Overload | operator rewrite info and best-viable-function selection" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ovl5_plain_fn(int a) { return a; }")
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)

    f = DeclFinder(I)
    @test f(I, "ovl5_plain_fn")
    fn = CC.downcast(CC.FunctionDecl, get_decl(f).ptr)

    # The two-argument create leaves clang's default rewrite info: no original operator, so no
    # candidate is a rewrite and every candidate is acceptable, whatever its name.
    plain = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)
    @test CC.rewriteInfoIsRewrittenOperator(plain, fn) == false
    @test CC.rewriteInfoIsAcceptableCandidate(plain, fn) == true
    @test CC.rewriteInfoGetRewriteKind(plain, fn) == CC.CXOverloadCandidateRewriteKind_CRK_None
    @test CC.rewriteInfoGetRewriteKind(plain, fn, true) ==
          CC.CXOverloadCandidateRewriteKind_CRK_Reversed
    # isReversible's first conjunct is AllowRewrittenCandidates, which this set leaves false.
    @test CC.rewriteInfoIsReversible(plain) == false
    @test !(CC.rewriteInfoAllowsReversed(plain, CC.CXOverloadedOperatorKind_OO_EqualEqual))

    # An empty set has nothing viable to pick, and the one-past-the-end iterator clang parks on
    # that outcome is reported as no candidate at all.
    res0, best0 = CC.BestViableFunction(plain, sema, loc)
    @test res0 == CC.CXOverloadingResult_OR_No_Viable_Function
    @test best0 === nothing
    CC.dispose(plain)

    # A set built for `operator==`, judged against a plain function: its name is not an
    # overloaded-operator name, so it is a rewrite to a different operator and not acceptable.
    op = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Operator,
                                 CC.CXOverloadedOperatorKind_OO_EqualEqual, loc, true)
    @test CC.rewriteInfoIsRewrittenOperator(op, fn) == true
    @test CC.rewriteInfoIsAcceptableCandidate(op, fn) == false
    @test CC.rewriteInfoGetRewriteKind(op, fn) ==
          CC.CXOverloadCandidateRewriteKind_CRK_DifferentOperator
    # Both rewrite bits together are not an enumerator, so the value is compared numerically.
    @test Int(CC.rewriteInfoGetRewriteKind(op, fn, true)) ==
          (Int(CC.CXOverloadCandidateRewriteKind_CRK_DifferentOperator) |
           Int(CC.CXOverloadCandidateRewriteKind_CRK_Reversed))
    @test CC.rewriteInfoIsReversible(op)
    @test CC.rewriteInfoAllowsReversed(op, CC.CXOverloadedOperatorKind_OO_EqualEqual)

    # One candidate: nothing to compare it against, so resolution never reaches the conversion
    # slots addCandidate leaves uninitialized.
    cand = CC.addCandidate(op, 1)
    res1, best1 = CC.BestViableFunction(op, sema, loc)
    @test res1 isa CC.CXOverloadingResult
    @test best1 === nothing || best1 isa CC.OverloadCandidate
    if res1 == CC.CXOverloadingResult_OR_Success
        @test best1.ptr == cand.ptr
    end

    # A second candidate makes the two comparable, and comparing them reads conversion
    # sequences that have never been given a kind.
    CC.addCandidate(op, 1)
    @test size(op) == 2
    @test_throws AssertionError CC.BestViableFunction(op, sema, loc)

    CC.dispose(op)
    dispose(I)
end

@testset "Overload | candidate members and the display-candidate selection" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ovl6_plain_fn(int a) { return a; }")
    sema = CC.get_sema(I)
    sm = CC.getSourceManager(sema)
    loc = CC.get_main_file_begin_loc(sm)
    no_args = CC.Expr_[]
    all_kind = CC.CXOverloadCandidateDisplayKind_OCD_AllCandidates
    viable_kind = CC.CXOverloadCandidateDisplayKind_OCD_ViableCandidates
    ambiguous_kind = CC.CXOverloadCandidateDisplayKind_OCD_AmbiguousCandidates

    cs = CC.OverloadCandidateSet(loc, CC.CXOverloadCandidateSet_CSK_Normal)

    # An empty set selects nothing, whichever display kind is asked for.
    for k in instances(CC.CXOverloadCandidateDisplayKind)
        sel = CC.CompleteCandidates(cs, sema, k, no_args, loc)
        @test sel isa Vector{CC.OverloadCandidate}
        @test isempty(sel)
    end

    # addCandidate finishes the object clang's own constructor leaves half-built, so each
    # member below reads storage the shim wrote rather than indeterminate bits; the values
    # asserted are exactly the ones that call writes.
    cand = CC.addCandidate(cs, 1)
    @test CC.is_null_handle(CC.getFunction(cand))
    @test CC.getFunction(cand).ptr == C_NULL
    @test CC.is_null_handle(CC.getSurrogate(cand))
    @test CC.getSurrogate(cand).ptr == C_NULL
    @test CC.getViable(cand) == true
    @test CC.getBest(cand) == false
    @test CC.getIgnoreObjectArgument(cand) == false
    @test CC.getExplicitCallArguments(cand) == 1
    # IsSurrogate is the one member clang's constructor sets itself, and it sets it false.
    @test CC.isSurrogate(cand) == false

    # A lone viable candidate is selected by the all- and viable- kinds. The ambiguous kind
    # keeps only candidates flagged best-so-far, which addCandidate clears and no resolution
    # pass has run to set. Sorting a one-element selection performs no comparison, so the
    # conversion slot that has never been given a kind is not read.
    all1 = CC.CompleteCandidates(cs, sema, all_kind, no_args, loc)
    @test length(all1) == 1
    @test all1[1].ptr == cand.ptr
    @test length(CC.CompleteCandidates(cs, sema, viable_kind, no_args, loc)) == 1
    @test isempty(CC.CompleteCandidates(cs, sema, ambiguous_kind, no_args, loc))

    # A second candidate makes the display comparator reachable, and ordering the two would
    # read conversion sequences that have never been given a kind. Growing the candidate
    # vector dangles every handle taken above, so none of them is touched again.
    CC.addCandidate(cs, 1)
    @test size(cs) == 2
    @test_throws AssertionError CC.CompleteCandidates(cs, sema, all_kind, no_args, loc)

    CC.dispose(cs)
    dispose(I)
end
