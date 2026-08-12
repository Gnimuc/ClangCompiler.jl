using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl
using Test

"The single node of type `T` in `e`'s subtree."
function only_node(T, e)
    found = filter(s -> s isa T, CC.subtree(e))
    @assert length(found) == 1 "expected exactly one $T, found $(length(found))"
    return found[1]
end

@testset "ConceptSpecializationExpr" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    template <typename T> concept CcSmall = sizeof(T) <= 4;
    constexpr bool cc_small_int = CcSmall<int>;
    constexpr bool cc_small_double = CcSmall<double>;
    """)

    small = find_decl(I, "CcSmall")
    vi = find_decl(I, "cc_small_int")
    vd = find_decl(I, "cc_small_double")
    @test all(x -> x !== nothing, (small, vi, vd))

    csi = only_node(CC.ConceptSpecializationExpr, CC.getInit(vi))
    csd = only_node(CC.ConceptSpecializationExpr, CC.getInit(vd))

    # satisfaction is what the node records, and it partitions on the argument
    @test CC.isSatisfied(csi)
    @test !CC.isSatisfied(csd)

    # the concept named is the one declared, reachable both directly and through the
    # reference the expression wraps
    @test CC.getNamedConcept(csi) == small
    cr = CC.getConceptReference(csi)
    @test CC.getNamedConcept(cr) == small
    @test CC.getFoundDecl(cr) == small

    # one substituted argument, and it is the type the concept-id was written with
    @test CC.getNumTemplateArguments(csi) == 1
    ta = CC.getTemplateArgument(csi, 0)
    @test CC.getKind(ta) == CC.CXTemplateArgument_Type
    @test CC.getAsType(ta) == CC.get_qual_type(CC.IntTy(ctx))
    @test CC.getAsType(CC.getTemplateArgument(csd, 0)) == CC.get_qual_type(CC.DoubleTy(ctx))
    @test length(CC.getTemplateArguments(csi)) == 1
    @test_throws AssertionError CC.getTemplateArgument(csi, 1)

    # `CcSmall<int>` writes its argument out, so the reference carries a written list too
    @test CC.hasExplicitTemplateArgs(csi)
    @test CC.hasExplicitTemplateArgs(cr)
    @test !CC.is_null_handle(CC.getTemplateArgsAsWritten(cr))

    # the name was written unqualified, so the qualifier box is empty; the concept-name
    # location is inside the range the reference spans
    nnsl = CC.getNestedNameSpecifierLoc(cr)
    @test !CC.hasQualifier(nnsl)
    dispose(nnsl)
    name_loc = CC.getConceptNameLoc(cr)
    @test CC.isValid(name_loc)
    @test CC.getLocation(cr) == name_loc
    rng = CC.getSourceRange(cr)
    @test CC.isValid(rng.begin_loc) && CC.isValid(rng.end_loc)
    @test CC.getBeginLoc(cr) == rng.begin_loc
    @test CC.getEndLoc(cr) == rng.end_loc

    # the invented declaration is where the substituted arguments actually live
    spec = CC.getSpecializationDecl(csi)
    @test !CC.is_null_handle(spec)

    dispose(I)
end

@testset "RequiresExpr" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    struct CcHolder { using type = int; };
    constexpr bool cc_req = requires(int a, int b) {
      a + b;
      typename CcHolder::type;
      requires sizeof(int) == 4;
    };
    template <typename T> concept CcAddable = requires(T a, T b) { a + b; };
    """)

    vr = find_decl(I, "cc_req")
    @test vr !== nothing
    re = only_node(CC.RequiresExpr, CC.getInit(vr))

    # written with concrete types, so it is decided and the whole body held
    @test !CC.isValueDependent(re)
    @test CC.isSatisfied(re)

    @test CC.getNumLocalParameters(re) == 2
    @test CC.getNameAsString(CC.getLocalParameter(re, 0)) == "a"
    @test CC.getNameAsString(CC.getLocalParameter(re, 1)) == "b"
    @test length(CC.getLocalParameters(re)) == 2
    @test_throws AssertionError CC.getLocalParameter(re, 2)

    @test !CC.is_null_handle(CC.getBody(re))
    @test CC.getNumRequirements(re) == 3
    reqs = CC.getRequirements(re)
    # source order is storage order, and each entry is the kind it was written as
    @test [CC.getKind(r) for r in reqs] ==
          [CC.CXRequirement_RK_Simple, CC.CXRequirement_RK_Type, CC.CXRequirement_RK_Nested]
    @test all(r -> !CC.isDependent(r), reqs)
    @test all(CC.isSatisfied, reqs)
    @test_throws AssertionError CC.getRequirement(re, 3)

    # the kind is the discriminator: exactly one narrowing answers for each entry
    simple, typereq, nested = reqs
    @test CC.is_null_handle(CC.castToTypeRequirement(simple))
    @test CC.is_null_handle(CC.castToNestedRequirement(simple))
    er = CC.castToExprRequirement(simple)
    @test !CC.is_null_handle(er)
    @test CC.isSimple(er)
    @test !CC.isCompound(er)
    @test !CC.hasNoexceptRequirement(er)
    @test !CC.isValid(CC.getNoexceptLoc(er))
    @test !CC.isExprSubstitutionFailure(er)
    @test CC.getSatisfactionStatus(er) == CC.CXExprRequirement_SS_Satisfied
    @test CC.getStmtClassName(CC.getExpr(er)) == "BinaryOperator"

    @test CC.is_null_handle(CC.castToExprRequirement(typereq))
    tr = CC.castToTypeRequirement(typereq)
    @test !CC.is_null_handle(tr)
    @test CC.getSatisfactionStatus(tr) == CC.CXTypeRequirement_SS_Satisfied
    @test !CC.isSubstitutionFailure(tr)
    @test !CC.is_null_handle(CC.getType(tr))

    nr = CC.castToNestedRequirement(nested)
    @test !CC.is_null_handle(nr)
    @test !CC.hasInvalidConstraint(nr)
    @test !CC.is_null_handle(CC.getConstraintExpr(nr))
    @test_throws AssertionError CC.getInvalidConstraintEntity(nr)

    @test CC.isValid(CC.getRequiresKWLoc(re))
    @test CC.isValid(CC.getLParenLoc(re))
    @test CC.isValid(CC.getRParenLoc(re))
    @test CC.isValid(CC.getRBraceLoc(re))

    # the same syntax inside a concept definition is still a template pattern: nothing has
    # been substituted, so there is no satisfaction to report and asking is a mistake
    addable = find_decl(I, "CcAddable")
    @test addable !== nothing
    dep = only_node(CC.RequiresExpr, CC.getConstraintExpr(addable))
    @test CC.isValueDependent(dep)
    @test_throws AssertionError CC.isSatisfied(dep)
    dep_req = CC.getRequirement(dep, 0)
    @test CC.isDependent(dep_req)
    @test_throws AssertionError CC.isSatisfied(dep_req)

    dispose(I)
end
