using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
if !@isdefined(_find_node)
    function _find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = _find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end
end

@testset "DeclCXX/DeclTemplate setters and factories" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)

    # Two real, distinct source locations + an identifier to feed factories/setters.
    CC.parse(I, "int aa = 1; int bb = 2;")
    f = DeclFinder(I)
    @test f(I, "aa")
    aa = CC.VarDecl(get_decl(f))
    @test f(I, "bb")
    bb = CC.VarDecl(get_decl(f))
    loc_a = CC.getLocation(aa)
    loc_b = CC.getLocation(bb)
    id_a = CC.getIdentifier(aa)
    @test loc_a.ptr != loc_b.ptr

    # ---- AccessSpecDecl: factories + loc setters ----
    asd = CC.AccessSpecDecl(ctx, LCE.CXAccessSpecifier_AS_public, dc, loc_a, loc_a)
    @test asd.ptr != C_NULL
    @test CC.getAccessSpecifierLoc(asd).ptr == loc_a.ptr
    @test CC.getColonLoc(asd).ptr == loc_a.ptr
    asd2 = CC.AccessSpecDecl(ctx, UInt(1))
    @test asd2.ptr != C_NULL
    CC.setAccessSpecifierLoc(asd, loc_b)
    @test CC.getAccessSpecifierLoc(asd).ptr == loc_b.ptr
    CC.setColonLoc(asd, loc_a)
    @test CC.getColonLoc(asd).ptr == loc_a.ptr

    # ---- LinkageSpecDecl: factories + setters ----
    lsd = CC.LinkageSpecDecl(ctx, dc, loc_a, loc_a, LCE.CXLinkageSpecDecl_lang_c, true)
    @test lsd.ptr != C_NULL
    @test CC.hasBraces(lsd) == true
    @test CC.getExternLoc(lsd).ptr == loc_a.ptr
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_c
    lsd2 = CC.LinkageSpecDecl(ctx, UInt(1))
    @test lsd2.ptr != C_NULL
    CC.setLanguage(lsd, LCE.CXLinkageSpecDecl_lang_cxx)
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_cxx
    CC.setExternLoc(lsd, loc_b)
    @test CC.getExternLoc(lsd).ptr == loc_b.ptr
    CC.setRBraceLoc(lsd, loc_a)
    @test CC.getRBraceLoc(lsd).ptr == loc_a.ptr

    # ---- CXXRecordDecl: Create + CreateLambda ----
    rd = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc_a, loc_a, id_a)
    @test rd.ptr != C_NULL
    @test CC.getName(rd) == "aa"
    @test CC.getTagKind(rd) == LCE.CXTagTypeKind_Struct
    @test !CC.isLambda(rd)
    tsi = CC.getTypeSourceInfo(aa)                    # a real TypeSourceInfo (int)
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc_a, LCE.CXLambdaDependencyKind_Unknown, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test lam.ptr != C_NULL
    @test CC.isLambda(lam)

    # ---- CXXBaseSpecifier: setInheritConstructors round-trip ----
    CC.parse(I, "struct BB0 { BB0(int); }; struct DD0 : BB0 { using BB0::BB0; };")
    @test f(I, "DD0")
    dd0 = CC.CXXRecordDecl(get_decl(f))
    @test CC.getNumBases(dd0) == 1
    base = CC.getBase(dd0, 0)
    @test base.ptr != C_NULL
    @test CC.getAccessSpecifier(base) == LCE.CXAccessSpecifier_AS_public
    @test !CC.isVirtual(base)
    CC.setInheritConstructors(base, true)
    @test CC.getInheritConstructors(base) == true
    CC.setInheritConstructors(base, false)
    @test CC.getInheritConstructors(base) == false

    # ---- CXXMethodDecl: Create (from a parsed method) + CreateDeserialized ----
    CC.parse(I, "struct Foo0 { void bar0(int); };")
    @test f(I, "Foo0")
    foo0 = CC.CXXRecordDecl(get_decl(f))
    bar0 = first(m for m in CC.getMethods(foo0) if CC.getName(m) == "bar0")
    ni = CC.getNameInfo(bar0)
    mty = CC.getType(bar0)
    mtsi = CC.getTypeSourceInfo(bar0)
    sloc = CC.getBeginLoc(bar0)
    eloc = CC.getLocation(bar0)
    md = CC.CXXMethodDecl(ctx, foo0, sloc, ni, mty, mtsi, LCE.CXStorageClass_SC_None, false, false,
                          LCE.CXConstexprSpecKind_Unspecified, eloc)
    @test md.ptr != C_NULL
    @test CC.getName(md) == "bar0"
    @test CC.getParent(md).ptr == foo0.ptr
    md2 = CC.CXXMethodDecl(ctx, UInt(1))
    @test md2.ptr != C_NULL

    # ---- Template factories/setters (already wrapped) reachable safely ----
    CC.parse(I, "template<class TT> struct S1 { TT x; };")
    @test f(I, "S1")
    s1 = CC.ClassTemplateDecl(get_decl(f))
    targ = CC.TemplateArgument(CC.getType(aa))        # an `int` template argument
    tal = CC.TemplateArgumentList(ctx, [targ])
    @test size(tal) == 1
    targ0 = Base.get(tal, 0)
    @test targ0.ptr != C_NULL
    @test CC.getKind(targ0) == LX.CXTemplateArgument_Type
    @test CC.getAsString(CC.getAsType(targ0)) == "int"
    ctsd = CC.ClassTemplateSpecializationDecl(ctx, s1, tal)
    @test ctsd.ptr != C_NULL
    @test CC.getSpecializedTemplate(ctsd).ptr == s1.ptr
    @test CC.getName(ctsd) == "S1"
    args_list = CC.getTemplateArgs(ctsd)
    @test size(args_list) == 1
    @test Base.get(args_list, 0).ptr != C_NULL
    tal2 = CC.TemplateArgumentList(ctx, [targ])
    CC.setTemplateArgs(ctsd, tal2)
    @test size(CC.getTemplateArgs(ctsd)) == 1

    dispose(f)
    dispose(I)
end

@testset "CXXMethodDecl_Create bool round-trip" begin
    # Regression: clang_CXXMethodDecl_Create forwarded (isInline, UsesFPIntrin) in
    # reversed order, so a method created inline read back non-inline. isInlineSpecified
    # is inherited from FunctionDecl; the base-level method applies with no widening written.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "struct MFoo { void mbar(int); };")
    f = DeclFinder(I)
    @test f(I, "MFoo")
    mfoo = CC.CXXRecordDecl(get_decl(f))
    mbar = first(m for m in CC.getMethods(mfoo) if CC.getName(m) == "mbar")
    ni = CC.getNameInfo(mbar)
    mty = CC.getType(mbar)
    mtsi = CC.getTypeSourceInfo(mbar)
    sloc = CC.getBeginLoc(mbar)
    eloc = CC.getLocation(mbar)

    # uses_fp_intrin=false, is_inline=true
    md = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None, false, true,
                          LX.CXConstexprSpecKind_Unspecified, eloc)
    @test md.ptr != C_NULL
    @test CC.isInlineSpecified(CC.FunctionDecl(md)) == true    # was false before the fix

    # complementary: uses_fp_intrin=false, is_inline=false
    md2 = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None, false, false,
                           LX.CXConstexprSpecKind_Unspecified, eloc)
    @test CC.isInlineSpecified(CC.FunctionDecl(md2)) == false

    dispose(f)
    dispose(I)
end

@testset "DeclCXX ctor initializers" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "struct Base { int b; }; struct Wid : Base { int m; Wid(int x) : Base(), m(x) {} };")
    @test f(I, "Wid")
    wid = CC.CXXRecordDecl(get_decl(f))
    ctor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) == 2)
    inits = CC.getCtorInitializers(ctor)
    @test length(inits) == 2
    @test all(x -> x.ptr != C_NULL, inits)
    @test CC.isBaseInitializer(inits[1])
    @test !CC.isMemberInitializer(inits[1])
    btype = CC.getBaseClass(inits[1])
    @test btype.ptr != C_NULL
    @test CC.getAsString(CC.getCanonicalTypeInternal(btype)) == "struct Base"
    @test CC.isMemberInitializer(inits[2])
    @test CC.getName(CC.getMember(inits[2])) == "m"
    init_expr = CC.getInit(inits[2])
    @test init_expr.ptr != C_NULL
    @test !CC.isValueDependent(init_expr)
    dispose(f)
    dispose(I)
end

@testset "isDerivedFrom" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    struct IdfB1 { int a; };
    struct IdfB2 : IdfB1 { int b; };
    struct IdfD : IdfB2 { int c; };
    struct IdfV : virtual IdfB1 { int d; };
    """)
    f = DeclFinder(I)
    @test f(I, "IdfB1")
    b1 = CC.CXXRecordDecl(CC.get_tag(f))
    @test f(I, "IdfB2")
    b2 = CC.CXXRecordDecl(CC.get_tag(f))
    @test f(I, "IdfD")
    d = CC.CXXRecordDecl(CC.get_tag(f))
    @test f(I, "IdfV")
    v = CC.CXXRecordDecl(CC.get_tag(f))

    @test CC.isDerivedFrom(d, b2)
    @test CC.isDerivedFrom(d, b1)      # transitive
    @test !CC.isDerivedFrom(b1, d)     # not the reverse
    @test !CC.isDerivedFrom(b1, b1)    # a class is not derived from itself
    @test CC.is_derived_from(d, b1)

    @test CC.isVirtuallyDerivedFrom(v, b1)
    @test !CC.isVirtuallyDerivedFrom(d, b1)

    dispose(f)
    dispose(I)
end

@testset "Coverage | DeclCXX" begin
    src = """
    extern "C" { int c_linked_var; }

    namespace NS2 {}
    using namespace NS2;

    struct VBase { int vb; virtual void vf() {} };
    struct Lft : virtual VBase {};
    struct Rgt : virtual VBase {};
    struct Diamond : Lft, Rgt {};

    struct Mixin { int mm; void mfn() {} };

    struct Plain { int p; double q; };

    struct Base {
    public:
        int b;
        Base() : b(0) {}
        Base(const Base& o) : b(o.b) {}
        Base(Base&& o) : b(o.b) {}
        explicit Base(int x) : b(x) {}
        virtual ~Base() {}
        virtual void foo() = 0;
        virtual int bar() const { return b; }
        void nonvirt() {}
        operator int() const { return b; }
    protected:
        int prot;
    private:
        int priv;
    };

    struct Derived : public Base, public Mixin {
        int d;
        Derived() : Derived(0) {}
        explicit Derived(int x) : Base(x), Mixin(), d(x) {}
        Derived(const Derived&) = default;
        ~Derived() override {}
        void foo() override {}
        using Base::bar;
    };

    template<typename T> struct Wrapper { T val; Wrapper(T x) : val(x) {} };
    template<typename T> Wrapper(T) -> Wrapper<T>;
    Wrapper wobj{5};

    auto glam = [](auto x){ return x; };
    """
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, src)

    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    alldecls = CC.decls(CC.castToDeclContext(tu))

    f = DeclFinder(I)
    @test f(I, "Base")
    baseRD = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "Derived")
    derivedRD = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "Diamond")
    diamondRD = CC.CXXRecordDecl(get_decl(f))

    # ---- CXXRecordDecl: decl-chain accessors ----
    @test CC.getCanonicalDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getPreviousDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getMostRecentDecl(baseRD) isa CC.CXXRecordDecl
    @test !CC.is_null_handle(CC.getMostRecentNonInjectedDecl(baseRD))
    @test CC.getDefinition(baseRD) isa CC.CXXRecordDecl

    # ---- CXXRecordDecl: Bool-returning trait predicates (~90) ----
    boolpreds = [CC.hasDefinition, CC.isLambda, CC.isGenericLambda, CC.isAggregate, CC.isPOD, CC.isCLike, CC.isEmpty,
                 CC.isDynamicClass, CC.allowConstDefaultInit, CC.hasAnyDependentBases,
                 CC.hasConstexprDefaultConstructor, CC.hasConstexprDestructor, CC.hasConstexprNonCopyMoveConstructor,
                 CC.hasCopyAssignmentWithConstParam, CC.hasCopyConstructorWithConstParam, CC.hasDefaultConstructor,
                 CC.hasDirectFields, CC.hasFriends, CC.hasInClassInitializer, CC.hasInheritedAssignment,
                 CC.hasInheritedConstructor, CC.hasInitMethod, CC.hasIrrelevantDestructor, CC.hasMoveAssignment,
                 CC.hasMoveConstructor, CC.hasMutableFields, CC.hasNonLiteralTypeFieldsOrBases,
                 CC.hasNonTrivialCopyAssignment, CC.hasNonTrivialCopyConstructor,
                 CC.hasNonTrivialCopyConstructorForCall, CC.hasNonTrivialDefaultConstructor, CC.hasNonTrivialDestructor,
                 CC.hasNonTrivialDestructorForCall, CC.hasNonTrivialMoveAssignment, CC.hasNonTrivialMoveConstructor,
                 CC.hasNonTrivialMoveConstructorForCall, CC.hasPrivateFields, CC.hasProtectedFields,
                 CC.hasSimpleCopyAssignment, CC.hasSimpleCopyConstructor, CC.hasSimpleDestructor,
                 CC.hasSimpleMoveAssignment, CC.hasSimpleMoveConstructor, CC.hasTrivialCopyAssignment,
                 CC.hasTrivialCopyConstructor, CC.hasTrivialCopyConstructorForCall, CC.hasTrivialDefaultConstructor,
                 CC.hasTrivialDestructor, CC.hasTrivialDestructorForCall, CC.hasTrivialMoveAssignment,
                 CC.hasTrivialMoveConstructor, CC.hasTrivialMoveConstructorForCall, CC.hasUninitializedReferenceMember,
                 CC.hasUserDeclaredConstructor, CC.hasUserDeclaredCopyAssignment, CC.hasUserDeclaredCopyConstructor,
                 CC.hasUserDeclaredDestructor, CC.hasUserDeclaredMoveAssignment, CC.hasUserDeclaredMoveConstructor,
                 CC.hasUserDeclaredMoveOperation, CC.hasUserProvidedDefaultConstructor, CC.hasVariantMembers,
                 CC.isAbstract, CC.isAnyDestructorNoReturn, CC.isCXX11StandardLayout, CC.isCapturelessLambda,
                 CC.isDependentLambda, CC.isEffectivelyFinal, CC.isInterfaceLike, CC.isLiteral,
                 CC.isNeverDependentLambda, CC.isParsingBaseSpecifiers, CC.isPolymorphic, CC.isStandardLayout,
                 CC.isStructural, CC.isTrivial, CC.isTriviallyCopyConstructible, CC.isTriviallyCopyable,
                 CC.mayBeAbstract, CC.mayBeDynamicClass, CC.mayBeNonDynamicClass, CC.needsImplicitCopyAssignment,
                 CC.needsImplicitCopyConstructor, CC.needsImplicitDefaultConstructor, CC.needsImplicitDestructor,
                 CC.needsImplicitMoveAssignment, CC.needsImplicitMoveConstructor,
                 CC.needsOverloadResolutionForCopyAssignment, CC.needsOverloadResolutionForCopyConstructor,
                 CC.needsOverloadResolutionForDestructor, CC.needsOverloadResolutionForMoveAssignment,
                 CC.needsOverloadResolutionForMoveConstructor]
    for p in boolpreds
        @test p(baseRD) in (true, false)
        @test p(derivedRD) in (true, false)
    end
    # a few meaningful values. `Plain` is the negative side: a predicate read only on a
    # class that satisfies it cannot tell a working one from one stuck at `true`.
    @test f(I, "Plain")
    plainRD = CC.CXXRecordDecl(get_decl(f))
    @test CC.isPolymorphic(plainRD) == false
    @test CC.isDynamicClass(plainRD) == false
    @test CC.isAbstract(plainRD) == false
    @test CC.isPolymorphic(baseRD)
    @test CC.isAbstract(baseRD)
    @test CC.isDynamicClass(baseRD)
    @test CC.hasUserDeclaredConstructor(baseRD)
    @test CC.hasUserDeclaredDestructor(baseRD)

    # defaulted-special-member predicates: only well-defined on a class whose
    # special members do not need overload resolution (Clang asserts otherwise),
    # so exercise them on a trivial struct.
    @test f(I, "Plain")
    plainRD = CC.CXXRecordDecl(get_decl(f))
    @test !(CC.defaultedCopyConstructorIsDeleted(plainRD))
    @test CC.defaultedDefaultConstructorIsConstexpr(plainRD)
    @test CC.defaultedDestructorIsConstexpr(plainRD)
    @test !(CC.defaultedDestructorIsDeleted(plainRD))
    @test !(CC.defaultedMoveConstructorIsDeleted(plainRD))

    # generic-lambda template parameter list (nullptr-safe on a non-lambda)
    @test CC.is_null_handle(CC.getGenericLambdaTemplateParameterList(baseRD))
    glamClass = nothing
    for d in alldecls
        if d isa CC.CXXRecordDecl && CC.isGenericLambda(d)
            glamClass = d
            break
        end
    end
    if glamClass !== nothing
        @test !CC.is_null_handle(CC.getGenericLambdaTemplateParameterList(glamClass))
        @test !(CC.hasKnownLambdaInternalLinkage(glamClass))
    end

    # ---- CXXRecordDecl: bases / methods / ctors counts + collections ----
    @test CC.getNumBases(derivedRD) == 2
    @test CC.getNumVBases(diamondRD) == 1
    @test CC.getNumMethods(baseRD) >= 7  # shape-only: MSVC ABI may add extra destructor variants
    @test CC.getNumCtors(baseRD) == 4

    bases = CC.getBases(derivedRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, bases)
    @test CC.getBase(derivedRD, 0) isa CC.CXXBaseSpecifier

    vbases = CC.getVBases(diamondRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, vbases)
    if CC.getNumVBases(diamondRD) > 0
        @test !CC.is_null_handle(CC.getVBase(diamondRD, 0))
    end

    methods = CC.getMethods(baseRD)
    @test all(m -> m isa CC.CXXMethodDecl, methods)
    ctors = CC.getCtors(baseRD)
    @test all(c -> c isa CC.CXXConstructorDecl, ctors)

    # ---- CXXBaseSpecifier accessors ----
    b0 = bases[1]
    @test Int(CC.getAccessSpecifier(b0)) == 0
    @test Int(CC.getAccessSpecifierAsWritten(b0)) == 0
    @test !CC.is_null_handle(CC.getBaseTypeLoc(b0))
    @test CC.is_null_handle(CC.getEllipsisLoc(b0))
    @test !CC.is_null_handle(CC.getEndLoc(b0))
    @test !(CC.getInheritConstructors(b0))
    @test !CC.is_null_handle(CC.getSourceRange(b0).begin_loc)
    @test CC.getType(b0) isa CC.QualType
    @test !CC.is_null_handle(CC.getTypeSourceInfo(b0))
    @test !(CC.isBaseOfClass(b0))
    @test !(CC.isPackExpansion(b0))
    @test !(CC.isVirtual(b0))
    # a virtual base specifier
    if !isempty(vbases)
        @test CC.isVirtual(vbases[1])
    end

    # ---- CXXMethodDecl accessors on every method ----
    for m in methods
        @test CC.getCanonicalDecl(m) isa CC.CXXMethodDecl
        @test CC.getMostRecentDecl(m) isa CC.CXXMethodDecl
        @test CC.getParent(m) isa CC.CXXRecordDecl
        @test CC.hasInlineBody(m) == (CC.getNameAsString(m) != "foo" && CC.getNameAsString(m) != "operator=")
        @test CC.isConst(m) == (CC.getNameAsString(m) in ("bar", "operator int"))
        @test CC.isCopyAssignmentOperator(m) == (CC.getNameAsString(m) == "operator=")
        @test CC.isInstance(m)
        @test !(CC.isLambdaStaticInvoker(m))
        @test !(CC.isMoveAssignmentOperator(m))
        @test !(CC.isStatic(m))
        @test CC.isVirtual(m) == (CC.getNameAsString(m) in ("~Base", "foo", "bar"))
        @test !(CC.isVolatile(m))
        if CC.isInstance(m)
            @test !CC.is_null_handle(CC.getThisType(m))
        end
    end

    # ---- CXXConstructorDecl / CXXDestructorDecl / CXXConversionDecl via resolve ----
    resolved = [CC.resolve(m) for m in methods]

    ctorPreds = [CC.isExplicit, CC.isDefaultConstructor, CC.isCopyConstructor, CC.isMoveConstructor,
                 CC.isCopyOrMoveConstructor, CC.isDelegatingConstructor, CC.isInheritingConstructor,
                 CC.isSpecializationCopyingObject]
    for c in ctors
        for p in ctorPreds
            @test p(c) in (true, false)
        end
        @test CC.getNumCtorInitializers(c) >= 1  # shape-only: implicit base sub-object initializers may vary
    end
    @test any(CC.isDefaultConstructor, ctors)
    @test any(CC.isCopyConstructor, ctors)
    @test any(CC.isMoveConstructor, ctors)
    @test any(c -> CC.isCopyOrMoveConstructor(c), ctors)
    @test any(CC.isExplicit, ctors)

    dtor = first(m for m in resolved if m isa CC.CXXDestructorDecl)
    @test !CC.is_null_handle(CC.getOperatorDelete(dtor))

    conv = first(m for m in resolved if m isa CC.CXXConversionDecl)
    @test !CC.is_null_handle(CC.getConversionType(conv))
    @test !(CC.isExplicit(conv))
    @test !(CC.isLambdaToBlockPointerConversion(conv))

    # ---- CXXCtorInitializer via Derived's ctors ----
    dctors = CC.getCtors(derivedRD)
    initCtor = first(c for c in dctors if CC.getNumCtorInitializers(c) >= 2)
    inits = CC.getCtorInitializers(initCtor)
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    baseInit = first(i for i in inits if CC.isBaseInitializer(i))
    memInit = first(i for i in inits if CC.isMemberInitializer(i))
    @test CC.isBaseInitializer(baseInit)
    @test !(CC.isAnyMemberInitializer(baseInit))
    @test !(CC.isDelegatingInitializer(baseInit))
    @test !CC.is_null_handle(CC.getBaseClass(baseInit))
    @test CC.getInit(baseInit) isa CC.Expr_
    @test !CC.is_null_handle(CC.getSourceLocation(baseInit))
    @test CC.isMemberInitializer(memInit)
    @test CC.isAnyMemberInitializer(memInit)
    @test CC.getMember(memInit) isa CC.FieldDecl
    @test CC.getName(CC.getMember(memInit)) == "d"

    # delegating constructor + its target + delegating initializer
    delegCtor = first(c for c in dctors if CC.isDelegatingConstructor(c))
    @test !CC.is_null_handle(CC.getTargetConstructor(delegCtor))
    # and the shape that has no target: clang's own assert is compiled out of the release
    # build, so an ordinary constructor would dereference a null initializer array
    plainCtor = first(c for c in dctors if !CC.isDelegatingConstructor(c))
    @test_throws AssertionError CC.getTargetConstructor(plainCtor)
    dinits = CC.getCtorInitializers(delegCtor)
    @test any(CC.isDelegatingInitializer, dinits)

    # ---- AccessSpecDecl ----
    asd = first(d for d in alldecls if d isa CC.AccessSpecDecl)
    @test !CC.is_null_handle(CC.getAccessSpecifierLoc(asd))
    @test !CC.is_null_handle(CC.getColonLoc(asd))
    @test !CC.is_null_handle(CC.getSourceRange(asd).begin_loc)

    # ---- LinkageSpecDecl (extern "C" { ... }) ----
    lsd = first(d for d in alldecls if d isa CC.LinkageSpecDecl)
    @test !CC.is_null_handle(CC.getEndLoc(lsd))
    @test !CC.is_null_handle(CC.getExternLoc(lsd))
    @test Int(CC.getLanguage(lsd)) == 1
    @test !CC.is_null_handle(CC.getRBraceLoc(lsd))
    @test !CC.is_null_handle(CC.getSourceRange(lsd).begin_loc)
    @test CC.hasBraces(lsd)

    # ---- UsingDirectiveDecl (using namespace NS2;) ----
    udir = first(d for d in alldecls if d isa CC.UsingDirectiveDecl)
    @test !CC.is_null_handle(CC.getNominatedNamespace(udir))

    # ---- UsingDecl / BaseUsingDecl / UsingShadowDecl (using Base::bar;) ----
    usingD = first(d for d in alldecls if d isa CC.UsingDecl)
    @test CC.shadow_size(usingD) == 1
    shadows = CC.getShadows(usingD)
    @test all(s -> s isa CC.UsingShadowDecl, shadows)
    if !isempty(shadows)
        @test !CC.is_null_handle(CC.getTargetDecl(shadows[1]))
    end

    # ---- CXXDeductionGuideDecl (templated decl of a FunctionTemplateDecl) ----
    dgs = CC.CXXDeductionGuideDecl[]
    for d in alldecls
        d isa CC.FunctionTemplateDecl || continue
        td = CC.resolve(CC.getTemplatedDecl(d))
        td isa CC.CXXDeductionGuideDecl && push!(dgs, td)
    end
    @test !isempty(dgs)
    for dg in dgs
        @test !(CC.isExplicit(dg))
        @test (!CC.is_null_handle(CC.getCorrespondingConstructor(dg))) == (dg.ptr == dgs[1].ptr)
        @test !CC.is_null_handle(CC.getDeducedTemplate(dg))
        @test Int(CC.getDeductionCandidateKind(dg)) >= 0
    end

    dispose(f)
    dispose(I)
end

@testset "Decl tail | with-argument accessors and setters" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)

        CC.parse(I, """
            namespace NSA { inline namespace INL { int nsvar = 1; } }
            int dtl_gv = 41;
            static int dtl_sv = 2;
            struct DtlRec { int a; int b : 3; int c = 4; };
            enum DtlEnum { DTL_A = 1, DTL_B = 7 };
            void dtl_fn(int p, int q = 3) { }
            struct DtlOp { int operator+(int) const; };
            static_assert(sizeof(int) >= 2, "int too small");
        """)

        look(name) = (@assert f(I, name) "lookup failed: $name"; get_decl(f))

        gv = CC.VarDecl(look("dtl_gv"))
        sv = CC.VarDecl(look("dtl_sv"))
        fd = CC.FunctionDecl(look("dtl_fn"))
        rd = CC.getDefinition(CC.RecordDecl(look("DtlRec")))
        ed = CC.getDefinition(CC.EnumDecl(look("DtlEnum")))
        nsvar = CC.VarDecl(look("NSA::INL::nsvar"))

        # --- NamedDecl printing surface ---
        @test CC.getNameAsString(gv) == "dtl_gv"
        @test CC.getQualifiedNameAsString(gv) == "dtl_gv"
        @test !isempty(CC.printName(gv))
        @test isempty(CC.printNestedNameSpecifier(gv))
        @test !isempty(CC.getNameForDiagnostic(gv, true))
        @test !isempty(CC.getNameForDiagnostic(gv, false))
        @test occursin("nsvar", CC.getQualifiedNameAsString(nsvar))
        @test occursin("NSA", CC.printNestedNameSpecifier(nsvar))

        # --- VarDecl: enum-returning and ASTContext-taking queries ---
        @test CC.getTLSKind(gv) isa CC.LibClangEx.CXVarDecl_TLSKind
        @test CC.getTLSKind(gv) == CC.LibClangEx.CXVarDecl_TLS_None
        @test CC.isThisDeclarationADefinition(gv, ctx) == CC.LibClangEx.CXVarDecl_Definition
        @test CC.hasDefinition(gv, ctx) == CC.LibClangEx.CXVarDecl_Definition
        @test CC.getInitStyle(gv) == CC.LibClangEx.CXVarDecl_CInit
        CC.setInitStyle(sv, CC.LibClangEx.CXVarDecl_ListInit)
        @test CC.getInitStyle(sv) == CC.LibClangEx.CXVarDecl_ListInit
        CC.setInitStyle(sv, CC.LibClangEx.CXVarDecl_CInit)
        @test CC.getInitStyle(sv) == CC.LibClangEx.CXVarDecl_CInit
        @test CC.hasDependentAlignment(gv) == false
        @test CC.checkForConstantInitialization(gv)
        @test CC.evaluateDestruction(gv)
        @test !(CC.hasFlexibleArrayInit(gv, ctx))
        @test CC.getFlexibleArrayInitChars(gv, ctx) == 0
        @test CC.is_null_handle(CC.getMemberSpecializationInfo(gv))
        @test CC.getStorageClassSpecifierString(CC.LibClangEx.CXStorageClass_SC_Static) == "static"
        # evaluateValue populates the cache that getEvaluatedValue reads back.
        CC.evaluateValue(gv)
        @test !CC.is_null_handle(CC.getEvaluatedValue(gv))

        # --- ValueDecl / DeclaratorDecl levels reached through their carriers ---
        @test !(CC.isInitCapture(CC.ValueDecl(gv)))
        @test !CC.is_null_handle(CC.getPotentiallyDecomposedVarDecl(CC.ValueDecl(gv)))
        @test !CC.is_null_handle(CC.getSourceRange(CC.DeclaratorDecl(gv)).begin_loc)

        # --- ParmVarDecl ---
        p0 = CC.getParamDecl(fd, 0)
        @test !CC.is_null_handle(CC.getSourceRange(p0).begin_loc)
        @test CC.getMaxFunctionScopeDepth() >= 0
        @test CC.isExplicitObjectParameter(p0) == false
        @test CC.is_null_handle(CC.getExplicitObjectParamThisLoc(p0))

        # --- FunctionDecl bit-flag round-trips (restore what we flip) ---
        @test CC.is_null_handle(CC.getDefaultLoc(fd))
        for (getter, setter) in ((CC.isIneligibleOrNotSelected, CC.setIneligibleOrNotSelected),
                                 (CC.BodyContainsImmediateEscalatingExpressions, CC.setBodyContainsImmediateEscalatingExpressions),
                                 (CC.FriendConstraintRefersToEnclosingTemplate, CC.setFriendConstraintRefersToEnclosingTemplate),
                                 (CC.UsesFPIntrin, CC.setUsesFPIntrin))
            old = getter(fd)
            @test old in (true, false)
            setter(fd, !old)
            @test getter(fd) == !old
            setter(fd, old)
            @test getter(fd) == old
        end
        @test !(CC.isImmediateEscalating(fd))
        @test !(CC.isImmediateFunction(fd))
        @test !(CC.isMemberLikeConstrainedFriend(fd))
        @test CC.isTargetClonesMultiVersion(fd) == false

        # --- FunctionDecl parameter arithmetic ---
        @test CC.getNumParams(fd) == 2
        @test CC.hasCXXExplicitFunctionObjectParameter(fd) == false
        @test CC.getNumNonObjectParams(fd) == 2
        @test !CC.is_null_handle(CC.getNonObjectParameter(fd, 0))
        @test_throws AssertionError CC.getNonObjectParameter(fd, CC.getNumNonObjectParams(fd))
        @test CC.getMinRequiredExplicitArguments(fd) == 1
        # FunctionDecl::setParams is private in clang 18, so the parameter list
        # is read-only here — check indexed access agrees with the count.
        params = [CC.getParamDecl(fd, i) for i = 0:(CC.getNumParams(fd) - 1)]
        @test length(params) == 2
        @test CC.getName(CC.getParamDecl(fd, 0)) == CC.getName(params[1])

        # --- FunctionDecl: constraints, TypeLoc, overloaded operator ---
        @test CC.getAssociatedConstraints(fd) isa Vector
        @test isempty(CC.getAssociatedConstraints(fd))
        tl = CC.getFunctionTypeLoc(fd)
        @test tl isa CC.TypeLoc
        CC.dispose(tl)
        @test CC.getOverloadedOperator(fd) == CC.LibClangEx.CXOverloadedOperatorKind_OO_None
        @test CC.is_null_handle(CC.getInstantiatedFromDecl(fd))

        # --- FieldDecl ---
        flds = CC.getFields(rd)
        @test length(flds) == 3
        @test !(CC.isPotentiallyOverlapping(flds[1]))
        @test CC.hasNonNullInClassInitializer(flds[1]) == false
        @test CC.hasNonNullInClassInitializer(flds[3]) == true

        # --- TagDecl / EnumDecl / RecordDecl ---
        @test CC.isThisDeclarationADemotedDefinition(rd) == false
        @test !CC.is_null_handle(CC.getSourceRange(ed).begin_loc)
        @test CC.getODRHash(rd) != 0  # shape-only: ODR hash depends on record layout (Itanium vs MSVC ABI)
        @test !(CC.isRandomized(rd))
        old_rnd = CC.isRandomized(rd)
        CC.setIsRandomized(rd, !old_rnd)
        @test CC.isRandomized(rd) == !old_rnd
        CC.setIsRandomized(rd, old_rnd)
        @test CC.isRandomized(rd) == old_rnd

        # --- EnumConstantDecl / EnumDecl value bridges (LLVM-C owned) ---
        ecs = CC.getEnumerators(ed)
        @test length(ecs) == 2
        v = CC.getInitVal(ecs[1])
        @test v != C_NULL
        CC.LLVM.API.LLVMDisposeGenericValue(v)
        (vmax, vmin) = CC.getValueRange(ed)
        @test vmax != C_NULL
        @test vmin != C_NULL
        CC.LLVM.API.LLVMDisposeGenericValue(vmax)
        CC.LLVM.API.LLVMDisposeGenericValue(vmin)

        # --- StaticAssertDecl (DeclCXX) reached by walking the TU ---
        tu = CC.getTranslationUnitDecl(ctx)
        sad = nothing
        for d in CC.decls(CC.castToDeclContext(tu))
            d isa CC.StaticAssertDecl && (sad=d; break)
        end
        @test sad !== nothing
        if sad !== nothing
            @test CC.isFailed(sad) == false
            @test !CC.is_null_handle(CC.getAssertExpr(sad))
            @test CC.getMessage(sad) isa CC.Expr_
            @test !CC.is_null_handle(CC.getRParenLoc(sad))
            @test !CC.is_null_handle(CC.getSourceRange(sad).begin_loc)
        end

        # --- TopLevelStmtDecl factory + accessors ---
        tls = CC.TopLevelStmtDecl(ctx, CC.getBody(fd))
        @test tls isa CC.TopLevelStmtDecl
        @test CC.getStmt(tls) isa CC.AbstractStmt
        @test CC.isSemiMissing(tls) == false
        CC.setSemiMissing(tls, true)
        @test CC.isSemiMissing(tls) == true
        CC.setStmt(tls, CC.getBody(fd))
        @test CC.getStmt(tls) isa CC.AbstractStmt
        CC.setSemiMissing(tls, false)
        @test CC.isSemiMissing(tls) == false
        @test !CC.is_null_handle(CC.getSourceRange(tls).begin_loc)
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "DeclCXX tail: destructor / conversions / closure-type accessors" begin
    I = CC.create_interpreter(String[])
    CC.parse(I, """
    struct DtorHost { ~DtorHost() {} operator int() const { return 0; } };
    auto LamV = [](int q) { return q + 1; };
    """)
    f = CC.DeclFinder(I)

    # CXXRecordDecl: destructor / conversion / instantiation tail
    @test f(I, "DtorHost")
    rd = CC.CXXRecordDecl(CC.get_decl(f))
    @test CC.hasDefinition(rd)
    @test !CC.isLambda(rd)
    dtor = CC.getDestructor(rd)
    @test dtor isa CC.CXXDestructorDecl
    @test dtor.ptr != C_NULL
    nconv = CC.getNumVisibleConversionFunctions(rd)
    @test nconv >= 1
    convs = CC.getVisibleConversionFunctions(rd)
    @test convs isa Vector{CC.NamedDecl}
    @test length(convs) == nconv
    @test all(c -> c.ptr != C_NULL, convs)
    # a plain, non-template, namespace-scope class: TSK_Undeclared and no pattern
    @test Int(CC.getTemplateSpecializationKind(rd)) == 0
    @test CC.getTemplateInstantiationPattern(rd).ptr == C_NULL
    @test CC.getInstantiatedFromMemberClass(rd).ptr == C_NULL
    @test CC.isLocalClass(rd).ptr == C_NULL

    # CXXRecordDecl: closure-type accessors, reached through the variable's type
    @test f(I, "LamV")
    vd = CC.VarDecl(CC.get_decl(f))
    lam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test lam isa CC.CXXRecordDecl
    if lam.ptr != C_NULL && CC.isLambda(lam)
        @test !CC.is_null_handle(CC.getLambdaCallOperator(lam))
        @test CC.getLambdaCallOperator(lam).ptr != C_NULL
        @test !CC.is_null_handle(CC.getLambdaStaticInvoker(lam))
        # a non-generic lambda has no templated call operator
        @test CC.getDependentLambdaCallOperator(lam).ptr == C_NULL
        @test Int(CC.getLambdaCaptureDefault(lam)) == 0  # LCD_None
        @test CC.getLambdaManglingNumber(lam) == 0
        @test CC.getLambdaIndexInContext(lam) == 0
        @test CC.is_null_handle(CC.getLambdaContextDecl(lam))
        @test !CC.is_null_handle(CC.getLambdaTypeInfo(lam))
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "CXXRecordDecl: ODR hash, closure captures, described template" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    CC.parse(I, """
    struct MemHost { int probe; };
    struct MemDerived : MemHost { };
    struct MemUnrelated { };
    template <typename T> struct TmplHost { T tv; };
    int probe = 0;
    int stranger = 0;
    auto LamPlain = [](int q) { return q + 1; };
    auto LamInit = [n = 5]() { return n; };
    auto LamGeneric = [](auto v) { return v; };
    """)
    f = DeclFinder(I)

    @test f(I, "MemHost")
    host = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "MemDerived")
    derived = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "MemUnrelated")
    unrelated = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasDefinition(host)
    @test CC.hasDefinition(derived)

    # CXXRecordDecl's own getODRHash (it hides RecordDecl's); cached, so stable.
    h = CC.getODRHash(host)
    @test h != 0
    @test CC.getODRHash(host) == h

    @test CC.implicitCopyConstructorHasConstParam(host)
    @test CC.implicitCopyAssignmentHasConstParam(host)

    # base walk: MemDerived IS derived from MemHost, provably not from MemUnrelated
    @test !CC.isProvablyNotDerivedFrom(derived, host)
    @test CC.isProvablyNotDerivedFrom(derived, unrelated)

    # hasMemberName, directly and through a base; DeclarationNames are uniqued per
    # ASTContext, so the global `probe`'s name is the member's name too.
    @test f(I, "probe")
    nprobe = CC.getDeclName(CC.VarDecl(get_decl(f)))
    @test f(I, "stranger")
    nstranger = CC.getDeclName(CC.VarDecl(get_decl(f)))
    @test CC.hasMemberName(host, nprobe)
    @test CC.hasMemberName(derived, nprobe)
    @test !CC.hasMemberName(host, nstranger)

    # MergeAccess: static, mirrors clang's path/decl access lattice
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_public, LCE.CXAccessSpecifier_AS_private) ==
          LCE.CXAccessSpecifier_AS_none
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_public, LCE.CXAccessSpecifier_AS_protected) ==
          LCE.CXAccessSpecifier_AS_protected
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_protected, LCE.CXAccessSpecifier_AS_public) ==
          LCE.CXAccessSpecifier_AS_protected

    # described class template, member specialization info, current instantiation
    @test f(I, "TmplHost")
    ctd = CC.ClassTemplateDecl(get_decl(f))
    pattern = CC.getTemplatedDecl(ctd)
    @test pattern isa CC.CXXRecordDecl
    dct = CC.getDescribedClassTemplate(pattern)
    @test dct isa CC.ClassTemplateDecl
    @test dct.ptr != C_NULL
    @test CC.getDescribedClassTemplate(host).ptr == C_NULL
    @test CC.is_null_handle(CC.getMemberSpecializationInfo(host))
    @test CC.getMemberSpecializationInfo(host).ptr == C_NULL
    pdc = CC.castToDeclContext(pattern)
    @test CC.is_dependent_context(pdc)
    @test CC.isCurrentInstantiation(pattern, pdc)
    tu = CC.getTranslationUnitDecl(CC.get_ast_context(I))
    @test !CC.isCurrentInstantiation(pattern, CC.castToDeclContext(tu))

    # non-lambda classes: LDK_Unknown and no explicit lambda template parameters
    @test CC.getLambdaDependencyKind(host) == LCE.CXLambdaDependencyKind_Unknown
    @test CC.getNumLambdaExplicitTemplateParameters(host) == 0
    @test isempty(CC.getLambdaExplicitTemplateParameters(host))

    # closure types, reached through each variable's deduced type
    for (nm, ncap) in (("LamPlain", 0), ("LamInit", 1))
        @test f(I, nm)
        vd = CC.VarDecl(get_decl(f))
        lam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
        @test lam isa CC.CXXRecordDecl
        (lam.ptr == C_NULL || !CC.isLambda(lam)) && continue
        @test CC.capture_size(lam) == ncap
        @test CC.getDeviceLambdaManglingNumber(lam) == 0
        @test !(CC.lambdaIsDefaultConstructibleAndAssignable(lam))
        @test Int(CC.getLambdaDependencyKind(lam)) in (0, 1, 2)
        for i = 0:(CC.capture_size(lam) - 1)
            cap = CC.getCapture(lam, i)
            @test cap isa CC.LambdaCapture
            @test cap.ptr != C_NULL
            @test CC.capturesVariable(cap)
        end
    end

    # a generic lambda has an invented template parameter list; before C++20 none
    # of its parameters are explicitly written
    @test f(I, "LamGeneric")
    gvd = CC.VarDecl(get_decl(f))
    glam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(gvd)))
    if glam.ptr != C_NULL && CC.isGenericLambda(glam)
        n = CC.getNumLambdaExplicitTemplateParameters(glam)
        @test n == 0
        @test n >= 0
        @test length(CC.getLambdaExplicitTemplateParameters(glam)) == n
    end

    dispose(f)
    dispose(I)
end

@testset "DeclCXX-c | CXXCtorInitializer read-surface + NamespaceAliasDecl" begin
    src = """
    namespace ns { int nsx; }
    namespace alias = ns;

    struct Base { int b; Base() : b(0) {} };
    struct Wid : Base {
        int m;
        union { int aa; float bb; };
        Wid(int x) : Base(), m(x), aa(x) {}
    };

    struct VB { int v; VB() {} };
    struct Der : virtual VB { Der() : VB() {} };
    """
    I = create_interpreter(String["-std=c++17"])
    CC.parse(I, src)
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    alldecls = CC.decls(CC.castToDeclContext(tu))
    f = DeclFinder(I)

    # ---- CXXCtorInitializer: Wid's ctor has base + member + indirect-member inits ----
    @test f(I, "Wid")
    wid = CC.CXXRecordDecl(get_decl(f))
    widCtor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) >= 3)
    inits = CC.getCtorInitializers(widCtor)
    @test all(x -> x isa CC.CXXCtorInitializer, inits)

    baseInit = first(i for i in inits if CC.isBaseInitializer(i))
    @test !(CC.isBaseVirtual(baseInit))
    @test CC.isBaseVirtual(baseInit) == false
    @test !CC.is_null_handle(CC.getTypeSourceInfo(baseInit))
    @test !CC.is_null_handle(CC.getSourceRange(baseInit).begin_loc)
    @test CC.is_null_handle(CC.getMemberLocation(baseInit))
    @test CC.is_null_handle(CC.getEllipsisLoc(baseInit))
    @test !CC.is_null_handle(CC.getLParenLoc(baseInit))
    @test !CC.is_null_handle(CC.getRParenLoc(baseInit))
    @test !(CC.isPackExpansion(baseInit))
    @test !(CC.isInClassMemberInitializer(baseInit))
    @test CC.isWritten(baseInit)
    @test CC.getSourceOrder(baseInit) == 0

    memInit = first(i for i in inits if CC.isMemberInitializer(i))
    @test CC.isIndirectMemberInitializer(memInit) == false
    @test !CC.is_null_handle(CC.getAnyMember(memInit))
    @test CC.getName(CC.getAnyMember(memInit)) == "m"

    indInit = first(i for i in inits if CC.isIndirectMemberInitializer(i))
    @test !CC.is_null_handle(CC.getIndirectMember(indInit))
    @test !CC.is_null_handle(CC.getAnyMember(indInit))
    @test CC.getName(CC.getAnyMember(indInit)) == "aa"

    # ---- isBaseVirtual true for a virtual-base initializer ----
    @test f(I, "Der")
    der = CC.CXXRecordDecl(get_decl(f))
    derCtor = first(c for c in CC.getCtors(der) if CC.getNumCtorInitializers(c) >= 1)
    derBaseInit = first(i for i in CC.getCtorInitializers(derCtor) if CC.isBaseInitializer(i))
    @test CC.isBaseVirtual(derBaseInit) == true

    # ---- NamespaceAliasDecl (namespace alias = ns;) ----
    nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
    @test CC.getCanonicalDecl(nad) isa CC.NamespaceAliasDecl
    @test !CC.is_null_handle(CC.getNamespace(nad))
    @test !CC.is_null_handle(CC.getAliasedNamespace(nad))
    @test !CC.is_null_handle(CC.getAliasLoc(nad))
    @test !CC.is_null_handle(CC.getNamespaceLoc(nad))
    @test !CC.is_null_handle(CC.getTargetNameLoc(nad))
    @test CC.getName(nad) == "alias"
    @test CC.getName(CC.getNamespace(nad)) == "ns"

    dispose(f)
    dispose(I)
end

@testset "DeclCXX-d | UsingDecl / ConstructorUsingShadowDecl / CXXMethodDecl object params" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            struct MMd { void mmd(int); };
            struct MBd { MBd(int); };
            struct MDd : MBd { using MBd::MBd; };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))

        # ---- CXXMethodDecl: explicit/implicit object-parameter surface ----
        @test f(I, "MMd")
        mmd_rec = CC.CXXRecordDecl(get_decl(f))
        mmd = first(m for m in CC.getMethods(mmd_rec) if CC.getNameAsString(m) == "mmd")
        @test CC.isImplicitObjectMemberFunction(mmd)
        @test CC.isImplicitObjectMemberFunction(mmd) == true
        @test !(CC.isExplicitObjectMemberFunction(mmd))
        @test CC.isExplicitObjectMemberFunction(mmd) == false
        @test CC.size_overridden_methods(mmd) == 0
        @test CC.getNumExplicitParams(mmd) == 1

        # ---- UsingDecl (from `using MBd::MBd;`) ----
        usingD = first(d for d in alldecls if d isa CC.UsingDecl)
        @test !CC.is_null_handle(CC.getUsingLoc(usingD))
        @test !CC.is_null_handle(CC.getQualifier(usingD))
        @test !(CC.isAccessDeclaration(usingD))
        @test CC.isAccessDeclaration(usingD) == false
        @test !(CC.hasTypename(usingD))
        @test CC.hasTypename(usingD) == false
        @test !CC.is_null_handle(CC.getSourceRange(usingD).begin_loc)
        @test CC.getCanonicalDecl(usingD).ptr == usingD.ptr

        # ---- ConstructorUsingShadowDecl (the shadow of that using) ----
        cusd = first(d for d in alldecls if d isa CC.ConstructorUsingShadowDecl)
        intro = CC.getIntroducer(cusd)
        @test intro isa CC.UsingDecl
        @test intro.ptr == usingD.ptr
        @test CC.getParent(cusd) isa CC.CXXRecordDecl
        @test !CC.is_null_handle(CC.getNominatedBaseClass(cusd))
        @test !CC.is_null_handle(CC.getConstructedBaseClass(cusd))
        @test !(CC.constructsVirtualBase(cusd))
        @test CC.constructsVirtualBase(cusd) == false
        # Direct-base inheritance: both shadow links are null, so assert only the carrier type.
        @test CC.is_null_handle(CC.getNominatedBaseClassShadowDecl(cusd))
        @test CC.is_null_handle(CC.getConstructedBaseClassShadowDecl(cusd))
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "DeclCXX-e | UsingDirectiveDecl / UsingShadowDecl / UnresolvedUsing*" begin
    I = create_interpreter(String[])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            namespace NSEOuter { namespace NSEInner { void nse_fn(); } }
            using namespace NSEOuter::NSEInner;
            struct BaseE { void be(); };
            struct DerivedE : BaseE { using BaseE::be; };
            template <class T> struct UUE : T {
                using T::uuv;
                using typename T::uut;
            };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))

        # ---- UsingDirectiveDecl (using namespace NSEOuter::NSEInner;) ----
        udir = first(d for d in alldecls if d isa CC.UsingDirectiveDecl)
        @test !CC.is_null_handle(CC.getQualifier(udir))
        @test !CC.is_null_handle(CC.getNominatedNamespaceAsWritten(udir))
        @test !CC.is_null_handle(CC.getCommonAncestor(udir))
        @test !CC.is_null_handle(CC.getUsingLoc(udir))
        @test !CC.is_null_handle(CC.getNamespaceKeyLocation(udir))
        @test !CC.is_null_handle(CC.getIdentLocation(udir))
        @test !CC.is_null_handle(CC.getSourceRange(udir).begin_loc)

        # ---- UsingShadowDecl (the shadow of `using BaseE::be;`) ----
        usingD = first(d for d in alldecls if d isa CC.UsingDecl)
        shadows = CC.getShadows(usingD)
        @test !isempty(shadows)
        shadow = shadows[1]
        @test CC.getCanonicalDecl(shadow) isa CC.UsingShadowDecl
        @test CC.getCanonicalDecl(shadow).ptr == shadow.ptr
        @test CC.getIntroducer(shadow) isa CC.BaseUsingDecl
        @test CC.getIntroducer(shadow).ptr == usingD.ptr
        # Only one shadow in the chain, so the link is null: assert the carrier type only.
        @test CC.is_null_handle(CC.getNextUsingShadowDecl(shadow))

        # ---- UnresolvedUsing{Value,Typename}Decl (using-decls over a dependent base) ----
        ctd = first(d for d in alldecls if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUE")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test !CC.is_null_handle(CC.getUsingLoc(uuv))
        @test !(CC.isAccessDeclaration(uuv))
        @test CC.isAccessDeclaration(uuv) == false
        @test !CC.is_null_handle(CC.getQualifier(uuv))
        @test !(CC.isPackExpansion(uuv))
        @test CC.isPackExpansion(uuv) == false
        @test CC.is_null_handle(CC.getEllipsisLoc(uuv))

        uut = first(d for d in members if d isa CC.UnresolvedUsingTypenameDecl)
        @test !CC.is_null_handle(CC.getUsingLoc(uut))
        @test !CC.is_null_handle(CC.getTypenameLoc(uut))
        @test !CC.is_null_handle(CC.getQualifier(uut))
        @test !(CC.isPackExpansion(uut))
        @test CC.isPackExpansion(uut) == false
        @test CC.is_null_handle(CC.getEllipsisLoc(uut))
    finally
        dispose(I)
    end
end

@testset "DeclCXX-f | explicit specifiers, object parameters, structured bindings" begin
    I = create_interpreter(["-std=c++20"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            struct FBaseF { virtual void vf(); };
            struct FDerF : FBaseF {
                FDerF();
                explicit FDerF(int);
                ~FDerF();
                void vf() override;
                explicit operator bool() const;
                void cref() const &;
                void rref() &&;
            };
            template <class T> struct FGuideF { FGuideF(T); };
            FGuideF(int) -> FGuideF<int>;
            int farrF[2] = {1, 2};
            auto [fbaF, fbbF] = farrF;
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))
        der = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "FDerF")
        members = CC.decls(CC.castToDeclContext(der))
        vf = first(d for d in members if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "vf")
        cref = first(d for d in members if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "cref")
        rref = first(d for d in members if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "rref")

        # ---- CXXMethodDecl: overridden methods (count + fill) ----
        @test CC.size_overridden_methods(vf) == 1
        overridden = CC.getOverriddenMethods(vf)
        @test length(overridden) == 1
        @test overridden[1] isa CC.CXXMethodDecl
        @test CC.getNameAsString(overridden[1]) == "vf"
        @test CC.getNameAsString(CC.getParent(overridden[1])) == "FBaseF"
        @test isempty(CC.getOverriddenMethods(cref))

        # ---- CXXMethodDecl: ref-qualifier / method qualifiers / object parameter ----
        @test CC.getRefQualifier(cref) == CC.LibClangEx.CXRefQualifierKind_RQ_LValue
        @test CC.getRefQualifier(rref) == CC.LibClangEx.CXRefQualifierKind_RQ_RValue
        @test CC.getRefQualifier(vf) == CC.LibClangEx.CXRefQualifierKind_RQ_None
        @test CC.getMethodQualifiers(cref) == 1
        @test CC.hasConst(CC.getMethodQualifiers(cref))
        @test !CC.hasConst(CC.getMethodQualifiers(rref))
        objref = CC.getFunctionObjectParameterReferenceType(cref)
        @test objref isa CC.QualType
        @test CC.isReferenceType(CC.getTypePtr(objref))
        objval = CC.getFunctionObjectParameterType(cref)
        @test objval isa CC.QualType
        @test !CC.isReferenceType(CC.getTypePtr(objval))
        @test CC.isRecordType(CC.getTypePtr(objval))

        # ---- ExplicitSpecifier producers (owned copies of a by-value specifier) ----
        ector = first(d for d in members if d isa CC.CXXConstructorDecl && CC.isExplicit(d))
        es = CC.getExplicitSpecifier(ector)
        try
            @test CC.getKind(es) == CC.LibClangEx.CXExplicitSpecKind_ResolvedTrue
            @test CC.isExplicit(es)
            @test CC.isSpecified(es)
            @test !CC.isInvalid(es)
            @test CC.isEquivalent(es, es)
        finally
            dispose(es)
        end

        conv = first(d for d in members if d isa CC.CXXConversionDecl)
        esc = CC.getExplicitSpecifier(conv)
        try
            @test CC.getKind(esc) == CC.LibClangEx.CXExplicitSpecKind_ResolvedTrue
            @test CC.isExplicit(esc)
        finally
            dispose(esc)
        end

        # getFromDecl agrees with the class-specific accessor; Invalid() does not.
        esd = CC.ExplicitSpecifier(ector)
        inv = CC.ExplicitSpecifier()
        try
            @test CC.getKind(esd) == CC.LibClangEx.CXExplicitSpecKind_ResolvedTrue
            @test CC.isInvalid(inv)
            @test CC.isEquivalent(esd, esd)
            @test !CC.isEquivalent(esd, inv)
        finally
            dispose(esd)
            dispose(inv)
        end

        # ---- CXXDestructorDecl ----
        dtor = first(d for d in members if d isa CC.CXXDestructorDecl)
        @test CC.is_null_handle(CC.getOperatorDeleteThisArg(dtor))

        # ---- CXXDeductionGuideDecl ----
        guide = nothing
        for d in alldecls
            d isa CC.CXXDeductionGuideDecl && (guide = d)
        end
        @test guide !== nothing
        if guide !== nothing
            esg = CC.getExplicitSpecifier(guide)
            try
                @test CC.getKind(esg) == CC.LibClangEx.CXExplicitSpecKind_ResolvedFalse
                @test !CC.isExplicit(esg)
            finally
                dispose(esg)
            end
        end

        # ---- DecompositionDecl / BindingDecl ----
        dd = nothing
        for d in alldecls
            d isa CC.DecompositionDecl && (dd = d)
        end
        @test dd !== nothing
        if dd !== nothing
            @test CC.getNumBindings(dd) == 2
            bindings = CC.getBindings(dd)
            @test length(bindings) == 2
            @test all(b -> b isa CC.BindingDecl, bindings)
            @test CC.getBinding(dd, 0).ptr == bindings[1].ptr
            @test_throws AssertionError CC.getBinding(dd, CC.getNumBindings(dd))  # the restated clang assert (Invariant 3)
            b = bindings[1]
            @test CC.getNameAsString(b) == "fbaF"
            vd = CC.getDecomposedDecl(b)
            @test vd isa CC.ValueDecl
            CC.setDecomposedDecl(b, vd)
            @test CC.getDecomposedDecl(b).ptr == vd.ptr
            @test CC.is_null_handle(CC.getHoldingVar(b))
            bind = CC.getBinding(b)
            @test bind isa CC.Expr_
            if bind.ptr != C_NULL
                CC.setBinding(b, CC.getType(b), bind)
                @test CC.getBinding(b).ptr == bind.ptr
            end
        end
    finally
        dispose(I)
    end
end

@testset "DeclCXX-g | UsingEnumDecl / UsingPackDecl / MSPropertyDecl + ctor tails" begin
    I = create_interpreter(["-std=c++20", "-fms-extensions"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            enum class UEGColor { ueg_red, ueg_green };
            using enum UEGColor;
            struct PBG1 { void pfg() {} };
            struct PBG2 { void pfg(int) {} };
            template <class... Ts> struct PackXG : Ts... { using Ts::pfg...; };
            PackXG<PBG1, PBG2> pxg_inst;
            struct MSPropG {
                int GetXG();
                void PutXG(int);
                __declspec(property(get = GetXG, put = PutXG)) int xg;
            };
            struct BaseG { int bg; BaseG(int v) : bg(v) {} };
            struct DerG : BaseG { int dg; DerG(int v) : BaseG(v), dg(v) {} ~DerG() {} };
            struct ConvG { ConvG(int) {} explicit ConvG(double) {} };
            DerG derg_inst(1);
            ConvG convg_inst(1);
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))
        # The record a namespace-scope variable was declared with — always the outer
        # definition, never the injected class name.
        record_of(name) = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(first(d
                                                                               for d in alldecls
                                                                               if d isa CC.VarDecl &&
                                                                             CC.getNameAsString(d) == name))))

        # ---- UsingEnumDecl (`using enum UEGColor;`) ----
        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        @test !CC.is_null_handle(CC.getUsingLoc(ued))
        @test !CC.is_null_handle(CC.getEnumLoc(ued))
        # 'using' and 'enum' are distinct tokens, so their encodings differ.
        @test CC.getUsingLoc(ued).ptr != CC.getEnumLoc(ued).ptr
        # The enumeration is named unqualified here: NULL-pointer carrier.
        @test CC.is_null_handle(CC.getQualifier(ued))
        @test CC.getEnumType(ued) isa CC.TypeSourceInfo
        @test CC.getEnumType(ued).ptr != C_NULL
        @test !CC.is_null_handle(CC.getEnumDecl(ued))
        @test CC.getNameAsString(CC.getEnumDecl(ued)) == "UEGColor"
        @test !CC.is_null_handle(CC.getSourceRange(ued).begin_loc)
        @test CC.getCanonicalDecl(ued) isa CC.UsingEnumDecl
        @test CC.getCanonicalDecl(ued).ptr == ued.ptr

        # ---- UsingPackDecl (the instantiated `using Ts::pfg...;`) ----
        upd = first(d for d in CC.decls(CC.castToDeclContext(record_of("pxg_inst"))) if d isa CC.UsingPackDecl)
        @test !CC.is_null_handle(CC.getInstantiatedFromUsingDecl(upd))
        @test CC.getInstantiatedFromUsingDecl(upd).ptr != C_NULL
        @test CC.getNumExpansions(upd) == 2
        @test CC.getExpansion(upd, 0) isa CC.NamedDecl
        @test_throws AssertionError CC.getExpansion(upd, CC.getNumExpansions(upd))  # the restated clang assert (Invariant 3)
        exps = CC.getExpansions(upd)
        @test length(exps) == 2
        @test all(e -> e isa CC.NamedDecl && e.ptr != C_NULL, exps)
        @test !CC.is_null_handle(CC.getSourceRange(upd).begin_loc)
        @test CC.getCanonicalDecl(upd) isa CC.UsingPackDecl
        @test CC.getCanonicalDecl(upd).ptr == upd.ptr

        # ---- MSPropertyDecl (`__declspec(property(...))`) ----
        msp = first(d for d in alldecls if d isa CC.MSPropertyDecl)
        @test CC.hasGetter(msp)
        @test CC.hasGetter(msp)
        @test CC.hasSetter(msp)
        @test CC.hasSetter(msp)
        @test !CC.is_null_handle(CC.getGetterId(msp))
        @test CC.getName(CC.getGetterId(msp)) == "GetXG"
        @test !CC.is_null_handle(CC.getSetterId(msp))
        @test CC.getName(CC.getSetterId(msp)) == "PutXG"

        # ---- CXXBaseSpecifier::getBeginLoc ----
        derg = record_of("derg_inst")
        @test CC.getNumBases(derg) == 1
        b0 = CC.getBase(derg, 0)
        @test !CC.is_null_handle(CC.getBeginLoc(b0))
        @test CC.getBeginLoc(b0).ptr == CC.getSourceRange(b0).begin_loc.ptr

        # ---- CXXCtorInitializer::getID (reproducible, per-object) ----
        dctor = first(c for c in CC.getCtors(derg) if CC.getNumCtorInitializers(c) >= 2)
        inits = CC.getCtorInitializers(dctor)
        @test CC.getID(inits[1], ctx) >= 0
        @test CC.getID(inits[1], ctx) == CC.getID(inits[1], ctx)
        @test CC.getID(inits[1], ctx) != CC.getID(inits[2], ctx)

        # ---- CXXConstructorDecl / CXXDestructorDecl canonical decls ----
        @test CC.getCanonicalDecl(dctor) isa CC.CXXConstructorDecl
        @test CC.getCanonicalDecl(dctor).ptr == dctor.ptr
        ddtor = CC.getDestructor(derg)
        @test CC.getCanonicalDecl(ddtor) isa CC.CXXDestructorDecl
        @test CC.getCanonicalDecl(ddtor).ptr == ddtor.ptr

        # ---- CXXConstructorDecl::isConvertingConstructor ----
        cctors = collect(CC.getCtors(record_of("convg_inst")))
        @test all(c -> CC.isConvertingConstructor(c, true) in (true, false), cctors)
        @test any(c -> CC.isConvertingConstructor(c, false), cctors)
        # `explicit ConvG(double)` converts only when explicit constructors are allowed.
        @test count(c -> CC.isConvertingConstructor(c, true), cctors) >
              count(c -> CC.isConvertingConstructor(c, false), cctors)
    finally
        dispose(I)
    end
end

@testset "DeclCXX-g | LifetimeExtendedTemporaryDecl + inherited-ctor / alias / using tails" begin
    LXG = CC.LibClangEx
    I = create_interpreter(String[])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            namespace NSGOuter { namespace NSGInner { void nsg_fn(); } }
            namespace nsg_alias = NSGOuter::NSGInner;
            struct BaseG { BaseG(int) {} void bg(); };
            struct DerivedG : BaseG { using BaseG::BaseG; };
            DerivedG dg_use(1);
            const int &g_refg = 42;
            struct DeallocG {
                void *operator new(__SIZE_TYPE__);
                void operator delete(void *);
                int plain();
            };
            template <class T> struct UUG : T {
                using T::uugv;
                using typename T::uugt;
            };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))

        # Depth-first search for the first resolved descendant carried as `T`.
        function findg(::Type{T}, x) where {T}
            x isa T && return x
            for c in CC.children(x)
                r = findg(T, CC.resolve(c))
                r === nothing || return r
            end
            return nothing
        end

        # ---- CXXMethodDecl::isStaticOverloadedOperator (static, enum in) ----
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_New)
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_New) == true
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_Array_Delete) == true
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_Plus) == false

        # ---- CXXMethodDecl::isUsualDeallocationFunction (composite, PreventedBy dropped) ----
        dealloc = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "DeallocG")
        methods = CC.getMethods(dealloc)
        opdel = first(m for m in methods if CC.getNameAsString(m) == "operator delete")
        @test CC.isUsualDeallocationFunction(opdel)
        plain = first(m for m in methods if CC.getNameAsString(m) == "plain")
        @test CC.isUsualDeallocationFunction(plain) == false

        # ---- CXXConstructorDecl: the two InheritedConstructor halves ----
        derived = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "DerivedG")
        for c in CC.getCtors(derived)
            sh = CC.getInheritedConstructorShadowDecl(c)
            bc = CC.getInheritedConstructorBaseCtor(c)
            @test sh isa CC.ConstructorUsingShadowDecl
            @test bc isa CC.CXXConstructorDecl
            if CC.isInheritingConstructor(c)
                @test sh.ptr != C_NULL
                @test bc.ptr != C_NULL
                @test !CC.is_null_handle(CC.getTargetDecl(sh))
            else
                @test sh.ptr == C_NULL
                @test bc.ptr == C_NULL
            end
        end

        # ---- NamespaceAliasDecl: qualifier + own source range ----
        nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
        @test !CC.is_null_handle(CC.getQualifier(nad))
        # `namespace nsg_alias = NSGOuter::NSGInner;` names the target with a qualifier.
        @test CC.getQualifier(nad).ptr != C_NULL
        @test !CC.is_null_handle(CC.getSourceRange(nad).begin_loc)

        # ---- LifetimeExtendedTemporaryDecl (namespace-scope const reference) ----
        f = DeclFinder(I)
        @test f(I, "g_refg")
        gref = CC.VarDecl(get_decl(f))
        mt = findg(CC.MaterializeTemporaryExpr, CC.resolve(CC.getInit(gref)))
        @test mt isa CC.MaterializeTemporaryExpr
        if mt !== nothing
            letd = CC.getLifetimeExtendedTemporaryDecl(mt)
            @test letd isa CC.LifetimeExtendedTemporaryDecl
            @test letd.ptr != C_NULL
            @test !CC.is_null_handle(CC.getExtendingDecl(letd))
            @test CC.getExtendingDecl(letd).ptr != C_NULL
            @test CC.getStorageDuration(letd) == LXG.CXStorageDuration_SD_Static
            @test CC.hasTemporaryExpr(letd) == true
            @test !CC.is_null_handle(CC.getTemporaryExpr(letd))
            @test CC.getTemporaryExpr(letd).ptr != C_NULL
            @test CC.getManglingNumber(letd) == 1
            cached = CC.getOrCreateValue(letd, true)
            @test cached isa CC.APValue
            @test cached.ptr != C_NULL
            @test CC.getValue(letd) isa CC.APValue
            @test CC.getValue(letd).ptr == cached.ptr
        end

        # ---- UnresolvedUsing{Value,Typename}Decl tails ----
        ctd = first(d for d in alldecls if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUG")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test !CC.is_null_handle(CC.getSourceRange(uuv).begin_loc)
        @test CC.getCanonicalDecl(uuv) isa CC.UnresolvedUsingValueDecl
        @test CC.getCanonicalDecl(uuv).ptr == uuv.ptr

        uut = first(d for d in members if d isa CC.UnresolvedUsingTypenameDecl)
        @test CC.getCanonicalDecl(uut) isa CC.UnresolvedUsingTypenameDecl
        @test CC.getCanonicalDecl(uut).ptr == uut.ptr
    finally
        dispose(I)
    end
end

@testset "DeclCXX-i | qualifier ranges, name infos, TypeLocs, indirect primary bases" begin
    I = create_interpreter(["-std=c++20"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            namespace NSIOuter { namespace NSIInner {
                int nsi_v;
                enum class NSIColor { nsi_red, nsi_green };
            } }
            namespace NSITop { int nsi_t; }
            using namespace NSIOuter::NSIInner;
            using namespace NSITop;
            namespace nsi_alias = NSIOuter::NSIInner;
            using NSIOuter::NSIInner::nsi_v;
            using enum NSIOuter::NSIInner::NSIColor;
            struct VBaseI { virtual void vfi(); int vb; };
            struct MidI1 : virtual VBaseI { int m1; };
            struct MidI2 : virtual VBaseI { int m2; };
            struct MostI : MidI1, MidI2 { int md; };
            struct NEBaseI { virtual void nvfi(); };
            struct NEMidI1 : virtual NEBaseI { int nm1; };
            struct NEMidI2 : virtual NEBaseI { int nm2; };
            struct NEMostI : NEMidI1, NEMidI2 { int nmd; };
            struct BaseCI { int bc; BaseCI(int v) : bc(v) {} };
            struct DerCI : BaseCI { int dc; DerCI(int v) : BaseCI(v), dc(v) {} };
            struct ConvI { operator int() const { return 0; } };
            template <class T> struct UUI : T {
                using T::uuiv;
                using typename T::uuit;
            };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        alldecls = CC.decls(dc)
        rec(name) = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == name)

        # ---- CXXRecordDecl::getIndirectPrimaryBases (count + fill) ----
        # NEBaseI is nearly empty, so NEMidI1 and NEMidI2 each take it as their primary
        # base and NEMostI carries it as an indirect primary one. Every triple in JLLEnvs'
        # target table is Itanium, so this set is non-empty on all three CI hosts and the
        # element check below runs rather than passing vacuously.
        nemost = rec("NEMostI")
        n = CC.getNumIndirectPrimaryBases(nemost)
        @test n == 1
        ipb = CC.getIndirectPrimaryBases(nemost)
        @test length(ipb) == n
        @test !isempty(ipb)
        @test all(b -> b isa CC.CXXRecordDecl && b.ptr != C_NULL, ipb)
        @test rec("NEBaseI").ptr in [b.ptr for b in ipb]
        # VBaseI carries a data member, so it is nobody's primary base and the same walk
        # over MostI comes back empty.
        @test CC.getNumIndirectPrimaryBases(rec("MostI")) == 0
        @test isempty(CC.getIndirectPrimaryBases(rec("MostI")))
        # VBaseI has no virtual bases at all, so clang takes its early exit.
        @test CC.getNumIndirectPrimaryBases(rec("VBaseI")) == 0
        @test isempty(CC.getIndirectPrimaryBases(rec("VBaseI")))

        # ---- RequiresExprBodyDecl <-> DeclContext pivot ----
        nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
        loc = CC.getLocation(nad)
        rebd = CC.RequiresExprBodyDecl(ctx, dc, loc)
        @test rebd isa CC.RequiresExprBodyDecl
        rdc = CC.DeclContext(rebd)
        @test rdc isa CC.DeclContext
        @test rdc.ptr != C_NULL
        @test !CC.is_null_handle(CC.RequiresExprBodyDecl(rdc))
        @test CC.RequiresExprBodyDecl(rdc).ptr == rebd.ptr

        # ---- CXXCtorInitializer::getBaseClassLoc ----
        derci = rec("DerCI")
        ctor = first(c for c in CC.getCtors(derci) if CC.getNumCtorInitializers(c) >= 2)
        inits = CC.getCtorInitializers(ctor)
        binit = first(i for i in inits if CC.isBaseInitializer(i))
        minit = first(i for i in inits if CC.isMemberInitializer(i))
        btl = CC.getBaseClassLoc(binit)
        mtl = CC.getBaseClassLoc(minit)
        try
            @test btl isa CC.TypeLoc
            @test !CC.isNull(btl)
            @test CC.getTypePtr(CC.getType(btl)).ptr == CC.getBaseClass(binit).ptr
            # A member initializer writes no base class: a NULL TypeLoc inside a live box.
            @test mtl.ptr != C_NULL
            @test CC.isNull(mtl)
        finally
            dispose(btl)
            dispose(mtl)
        end

        # ---- CXXConversionDecl::getCanonicalDecl (derived-class carrier) ----
        conv = first(d for d in CC.decls(CC.castToDeclContext(rec("ConvI"))) if d isa CC.CXXConversionDecl)
        @test CC.getCanonicalDecl(conv) isa CC.CXXConversionDecl
        @test CC.getCanonicalDecl(conv).ptr == conv.ptr

        # ---- UsingDirectiveDecl::getQualifierRange (qualified and unqualified) ----
        udirs = [d for d in alldecls if d isa CC.UsingDirectiveDecl]
        qual_udir = first(d for d in udirs if CC.getQualifier(d).ptr != C_NULL)
        plain_udir = first(d for d in udirs if CC.getQualifier(d).ptr == C_NULL)
        @test !CC.is_null_handle(CC.getQualifierRange(qual_udir).begin_loc)
        @test CC.getQualifierRange(qual_udir).begin_loc.ptr != C_NULL
        # `using namespace NSITop;` writes no nested-name-specifier: an invalid range.
        @test CC.is_null_handle(CC.getQualifierRange(plain_udir).begin_loc)
        @test CC.getQualifierRange(plain_udir).begin_loc.ptr == C_NULL

        # ---- NamespaceAliasDecl::getQualifierRange ----
        @test !CC.is_null_handle(CC.getQualifierRange(nad).begin_loc)
        @test CC.getQualifierRange(nad).begin_loc.ptr != C_NULL

        # ---- UsingDecl: qualifier range + name info ----
        ud = first(d for d in alldecls if d isa CC.UsingDecl)
        @test !CC.is_null_handle(CC.getQualifierRange(ud).begin_loc)
        @test CC.getQualifierRange(ud).begin_loc.ptr != C_NULL
        ni = CC.getNameInfo(ud)
        try
            @test ni isa CC.DeclarationNameInfo
            @test CC.getAsString(ni) == "nsi_v"
            @test CC.getLoc(ni).ptr == CC.getLocation(ud).ptr
        finally
            dispose(ni)
        end

        # ---- UsingEnumDecl::getEnumTypeLoc ----
        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        tl = CC.getEnumTypeLoc(ued)
        tl2 = CC.getTypeLoc(CC.getEnumType(ued))
        try
            @test tl isa CC.TypeLoc
            @test !CC.isNull(tl)
            @test CC.getType(tl).ptr == CC.getType(tl2).ptr
        finally
            dispose(tl)
            dispose(tl2)
        end

        # ---- UnresolvedUsing{Value,Typename}Decl: qualifier range + name info ----
        ctd = first(d for d in alldecls if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUI")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test !CC.is_null_handle(CC.getQualifierRange(uuv).begin_loc)
        @test CC.getQualifierRange(uuv).begin_loc.ptr != C_NULL
        niv = CC.getNameInfo(uuv)
        try
            @test niv isa CC.DeclarationNameInfo
            @test CC.getAsString(niv) == "uuiv"
            @test CC.getLoc(niv).ptr == CC.getLocation(uuv).ptr
        finally
            dispose(niv)
        end

        uut = first(d for d in members if d isa CC.UnresolvedUsingTypenameDecl)
        @test !CC.is_null_handle(CC.getQualifierRange(uut).begin_loc)
        @test CC.getQualifierRange(uut).begin_loc.ptr != C_NULL
        nit = CC.getNameInfo(uut)
        try
            @test nit isa CC.DeclarationNameInfo
            @test CC.getAsString(nit) == "uuit"
            @test CC.getLoc(nit).ptr == CC.getLocation(uut).ptr
        finally
            dispose(nit)
        end
    finally
        dispose(I)
    end
end

@testset "DeclCXX-j | declared conversions + the DeclCXX factory tail" begin
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            struct CVJ { operator int() const; operator double() const; };
            struct BJ { BJ(int); void mj(); };
            struct DJ : BJ { using BJ::BJ; using BJ::mj; };
            enum class EJColor { ej_red, ej_green };
            using enum EJColor;
            struct PJ1 { void pj() {} };
            struct PJ2 { void pj(int) {} };
            template <class... Ts> struct PackJ : Ts... { using Ts::pj...; };
            PackJ<PJ1, PJ2> pj_inst;
            int vj_a = 1;
            int vj_b = 2;
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        alldecls = CC.decls(dc)

        # Two real, distinct locations plus a name/identifier to feed the factories.
        @test f(I, "vj_a")
        vj_a = CC.VarDecl(get_decl(f))
        @test f(I, "vj_b")
        vj_b = CC.VarDecl(get_decl(f))
        loc_a = CC.getLocation(vj_a)
        loc_b = CC.getLocation(vj_b)
        id_a = CC.getIdentifier(vj_a)
        name_a = CC.getDeclName(vj_a)
        @test loc_a.ptr != loc_b.ptr

        # ---- CXXRecordDecl: the conversions declared directly in the class ----
        @test f(I, "CVJ")
        cvj = CC.CXXRecordDecl(get_decl(f))
        @test CC.getNumConversions(cvj) == 2
        @test CC.getConversion(cvj, 0) isa CC.NamedDecl
        convs = CC.getConversions(cvj)
        @test length(convs) == 2
        @test all(c -> c.ptr != C_NULL, convs)
        @test all(c -> startswith(CC.getNameAsString(c), "operator "), convs)
        # The declared set is a subset of the visible one, which also carries the
        # conversions inherited from bases.
        @test CC.getNumConversions(cvj) <= CC.getNumVisibleConversionFunctions(cvj)
        # A class with no conversion operator has an empty declared set.
        @test f(I, "BJ")
        bj = CC.CXXRecordDecl(get_decl(f))
        @test CC.getNumConversions(bj) == 0
        @test isempty(CC.getConversions(bj))

        # ---- UsingShadowDecl / ConstructorUsingShadowDecl factories ----
        @test f(I, "DJ")
        dj = CC.CXXRecordDecl(get_decl(f))
        djdecls = CC.decls(CC.castToDeclContext(dj))
        cusd = first(d for d in djdecls if d isa CC.ConstructorUsingShadowDecl)
        ctor_using = CC.getIntroducer(cusd)
        @test ctor_using isa CC.UsingDecl
        usd = first(d for d in djdecls if d isa CC.UsingShadowDecl)
        method_using = CC.getIntroducer(usd)
        @test method_using isa CC.BaseUsingDecl

        usd2 = CC.UsingShadowDecl(ctx, dc, loc_a, name_a, method_using, vj_a)
        @test usd2 isa CC.UsingShadowDecl
        @test CC.getTargetDecl(usd2).ptr == vj_a.ptr
        @test CC.getIntroducer(usd2).ptr == method_using.ptr
        @test !CC.is_null_handle(CC.UsingShadowDecl(ctx, UInt(1)))

        cusd2 = CC.ConstructorUsingShadowDecl(ctx, dc, loc_b, ctor_using, CC.getTargetDecl(cusd), false)
        @test cusd2 isa CC.ConstructorUsingShadowDecl
        @test CC.getIntroducer(cusd2).ptr == ctor_using.ptr
        @test CC.constructsVirtualBase(cusd2) == false
        @test !CC.is_null_handle(CC.ConstructorUsingShadowDecl(ctx, UInt(1)))

        # ---- UsingDecl / UsingEnumDecl factories ----
        @test !CC.is_null_handle(CC.UsingDecl(ctx, UInt(1)))

        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        ued2 = CC.UsingEnumDecl(ctx, dc, loc_a, loc_b, loc_a, CC.getEnumType(ued))
        @test ued2 isa CC.UsingEnumDecl
        @test CC.getUsingLoc(ued2).ptr == loc_a.ptr
        @test CC.getEnumLoc(ued2).ptr == loc_b.ptr
        @test CC.getNameAsString(CC.getEnumDecl(ued2)) == "EJColor"
        @test !CC.is_null_handle(CC.UsingEnumDecl(ctx, UInt(1)))

        # ---- UsingPackDecl factory (the (buffer, count) array input) ----
        pj_var = first(d for d in alldecls if d isa CC.VarDecl && CC.getNameAsString(d) == "pj_inst")
        pack = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(pj_var)))
        upd = first(d for d in CC.decls(CC.castToDeclContext(pack)) if d isa CC.UsingPackDecl)
        exps = CC.getExpansions(upd)
        @test length(exps) == 2
        upd2 = CC.UsingPackDecl(ctx, dc, CC.getInstantiatedFromUsingDecl(upd), exps)
        @test upd2 isa CC.UsingPackDecl
        @test CC.getNumExpansions(upd2) == length(exps)
        @test CC.getExpansion(upd2, 0).ptr == exps[1].ptr
        @test !CC.is_null_handle(CC.UsingPackDecl(ctx, UInt(1), UInt(0)))

        # ---- BindingDecl / MSPropertyDecl factories ----
        bd = CC.BindingDecl(ctx, dc, loc_a, id_a)
        @test bd isa CC.BindingDecl
        @test CC.getNameAsString(bd) == "vj_a"
        @test !CC.is_null_handle(CC.BindingDecl(ctx, UInt(1)))

        msp = CC.MSPropertyDecl(ctx, dc, loc_a, name_a, CC.getType(vj_a), CC.getTypeSourceInfo(vj_a), loc_b, id_a, id_a)
        @test msp isa CC.MSPropertyDecl
        @test CC.hasGetter(msp)
        @test CC.hasSetter(msp)
        @test CC.getName(CC.getGetterId(msp)) == "vj_a"
        @test CC.getName(CC.getSetterId(msp)) == "vj_a"
        @test !CC.is_null_handle(CC.MSPropertyDecl(ctx, UInt(1)))

        # ---- The remaining CreateDeserialized placeholders ----
        @test !CC.is_null_handle(CC.CXXRecordDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.CXXDeductionGuideDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.CXXConstructorDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.CXXConstructorDecl(ctx, UInt(1), 0))
        @test !CC.is_null_handle(CC.CXXDestructorDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.CXXConversionDecl(ctx, UInt(1)))
    finally
        dispose(f)
        dispose(I)
    end
end

@testset "DeclCXX-k | using-decl setters, qualifier range, CreateDeserialized tails" begin
    LXK = CC.LibClangEx
    I = create_interpreter(["-std=c++20"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            namespace NSKOuter { namespace NSKInner { enum class KColor { k_red, k_green }; } }
            using enum NSKOuter::NSKInner::KColor;
            struct BaseK { void bk(); };
            struct DerivedK : BaseK { using BaseK::bk; };
            struct ExpK {
                ExpK();
                explicit ExpK(int);
                explicit operator bool() const;
            };
            template <class T> struct GuideK { GuideK(T); };
            GuideK(int) -> GuideK<int>;
            template <class T> struct UUK : T { using T::uukv; };
            struct BaseCK { int bck = 7; };
            struct DerCK : BaseCK { int dck = 9; DerCK() {} };
            int vk_a = 1;
            int vk_b = 2;
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        alldecls = CC.decls(dc)

        var_of(name) = first(d for d in alldecls if d isa CC.VarDecl && CC.getNameAsString(d) == name)
        record_of(name) = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == name)
        loc_a = CC.getLocation(var_of("vk_a"))
        loc_b = CC.getLocation(var_of("vk_b"))
        @test loc_a.ptr != loc_b.ptr

        # ---- CXXRecordDecl::setInitMethod (definition-data flag, restored below) ----
        derk = record_of("DerivedK")
        @test CC.hasDefinition(derk)
        init0 = CC.hasInitMethod(derk)
        @test init0 in (true, false)
        CC.setInitMethod(derk, !init0)
        @test CC.hasInitMethod(derk) == !init0
        CC.setInitMethod(derk, init0)
        @test CC.hasInitMethod(derk) == init0

        # ---- UsingDecl / UsingShadowDecl setters ----
        usingD = first(d for d in CC.decls(CC.castToDeclContext(derk)) if d isa CC.UsingDecl)
        ul0 = CC.getUsingLoc(usingD)
        CC.setUsingLoc(usingD, loc_a)
        @test CC.getUsingLoc(usingD).ptr == loc_a.ptr
        CC.setUsingLoc(usingD, ul0)
        @test CC.getUsingLoc(usingD).ptr == ul0.ptr

        tn0 = CC.hasTypename(usingD)
        @test tn0 in (true, false)
        CC.setTypename(usingD, !tn0)
        @test CC.hasTypename(usingD) == !tn0
        CC.setTypename(usingD, tn0)
        @test CC.hasTypename(usingD) == tn0

        shadows = CC.getShadows(usingD)
        @test !isempty(shadows)
        shadow = shadows[1]
        target = CC.getTargetDecl(shadow)
        @test target.ptr != C_NULL
        CC.setTargetDecl(shadow, target)
        @test CC.getTargetDecl(shadow).ptr == target.ptr

        # ---- UsingEnumDecl: location/type setters + the qualifier range ----
        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        uel0 = CC.getUsingLoc(ued)
        enl0 = CC.getEnumLoc(ued)
        CC.setUsingLoc(ued, loc_a)
        @test CC.getUsingLoc(ued).ptr == loc_a.ptr
        CC.setUsingLoc(ued, uel0)
        @test CC.getUsingLoc(ued).ptr == uel0.ptr
        CC.setEnumLoc(ued, loc_b)
        @test CC.getEnumLoc(ued).ptr == loc_b.ptr
        CC.setEnumLoc(ued, enl0)
        @test CC.getEnumLoc(ued).ptr == enl0.ptr

        tsi = CC.getEnumType(ued)
        @test tsi.ptr != C_NULL
        CC.setEnumType(ued, tsi)
        @test CC.getEnumType(ued).ptr == tsi.ptr

        qr = CC.getQualifierRange(ued)
        @test qr isa CC.SourceRange
        @test qr.begin_loc isa CC.SourceLocation
        @test qr.end_loc isa CC.SourceLocation
        # Both halves come out of the same NestedNameSpecifierLoc, so they agree on
        # whether a nested-name-specifier was written at all.
        @test (CC.getQualifier(ued).ptr == C_NULL) == (qr.begin_loc.ptr == C_NULL)

        # ---- UnresolvedUsingValueDecl::setUsingLoc ----
        uuk = first(d for d in alldecls if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUK")
        uuv = first(d
                    for d in CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(uuk)))
                    if d isa CC.UnresolvedUsingValueDecl)
        uuvl0 = CC.getUsingLoc(uuv)
        CC.setUsingLoc(uuv, loc_a)
        @test CC.getUsingLoc(uuv).ptr == loc_a.ptr
        CC.setUsingLoc(uuv, uuvl0)
        @test CC.getUsingLoc(uuv).ptr == uuvl0.ptr

        # ---- explicit specifiers: write the declaration's own value back ----
        expk = record_of("ExpK")
        expk_members = CC.decls(CC.castToDeclContext(expk))
        ector = first(d for d in expk_members if d isa CC.CXXConstructorDecl && CC.isExplicit(d))
        es = CC.getExplicitSpecifier(ector)
        try
            # `explicit` without a condition: no trailing expression, so the setter's
            # precondition holds.
            @test CC.getExpr(es).ptr == C_NULL
            CC.setExplicitSpecifier(ector, es)
            @test CC.isExplicit(ector)
        finally
            dispose(es)
        end

        conv = first(d for d in expk_members if d isa CC.CXXConversionDecl)
        esc = CC.getExplicitSpecifier(conv)
        try
            CC.setExplicitSpecifier(conv, esc)
            @test CC.isExplicit(conv)
        finally
            dispose(esc)
        end

        # Only the clearing direction is safe on a constructor built without the
        # inherited-constructor trailing object.
        @test CC.isInheritingConstructor(ector) == false
        CC.setInheritingConstructor(ector, false)
        @test CC.isInheritingConstructor(ector) == false

        # ---- CXXDeductionGuideDecl::setDeductionCandidateKind ----
        guide = nothing
        for d in alldecls
            d isa CC.CXXDeductionGuideDecl && (guide = d)
        end
        @test guide !== nothing
        if guide !== nothing
            dk0 = CC.getDeductionCandidateKind(guide)
            CC.setDeductionCandidateKind(guide, LXK.CXDeductionCandidate_Aggregate)
            @test CC.getDeductionCandidateKind(guide) == LXK.CXDeductionCandidate_Aggregate
            CC.setDeductionCandidateKind(guide, dk0)
            @test CC.getDeductionCandidateKind(guide) == dk0
        end

        # ---- CXXCtorInitializer::setSourceOrder (one-way: implicit -> written) ----
        derck = record_of("DerCK")
        implicit_init = nothing
        for c in CC.getCtors(derck), init in CC.getCtorInitializers(c)
            if !CC.isWritten(init)
                implicit_init = init
                break
            end
        end
        @test implicit_init !== nothing
        if implicit_init !== nothing
            @test CC.getSourceOrder(implicit_init) == -1
            CC.setSourceOrder(implicit_init, 0)
            @test CC.isWritten(implicit_init)
            @test CC.getSourceOrder(implicit_init) == 0
        end

        # ---- The CreateDeserialized placeholders ----
        @test !CC.is_null_handle(CC.UsingDirectiveDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.NamespaceAliasDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.LifetimeExtendedTemporaryDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.UnresolvedUsingValueDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.UnresolvedUsingTypenameDecl(ctx, UInt(1)))
        @test !CC.is_null_handle(CC.DecompositionDecl(ctx, UInt(1), UInt(0)))
    finally
        dispose(I)
    end
end

@testset "DeclCXX-l: MSGuidDecl parts, record setters, CXXMethodDecl-family factories" begin
    # The -fms-extensions source is parsed first, before any synthetic node exists: a
    # rejected parse renders diagnostics over the AST, and doing that after hand-built
    # nodes exist has crashed DiagnosticRenderer before.
    Ims = create_interpreter(["-fms-extensions"])
    fms = DeclFinder(Ims)
    CC.parse(Ims, """
    typedef struct _GUID {
      unsigned long Data1;
      unsigned short Data2;
      unsigned short Data3;
      unsigned char Data4[8];
    } GUID;
    struct __declspec(uuid("12345678-9abc-def0-0123-456789abcdef")) LGuid {};
    const GUID *lg_uuid() { return &__uuidof(LGuid); }
    """)
    @test fms(Ims, "lg_uuid")
    lgbody = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(fms))))
    ue = _find_node(CC.CXXUuidofExpr, lgbody)
    @test ue isa CC.CXXUuidofExpr
    if ue isa CC.CXXUuidofExpr
        gd = CC.getGuidDecl(ue)
        @test gd isa CC.MSGuidDecl
        @test gd.ptr != C_NULL
        @test CC.getPart1(gd) == 0x12345678
        @test CC.getPart2(gd) == 0x9abc
        @test CC.getPart3(gd) == 0xdef0
        # A memcpy of the last eight UUID bytes, so the integer is byte-order dependent:
        # only its shape and its non-emptiness are host-independent.
        # byte-order / struct-layout dependent — only non-emptiness is host-independent
        @test CC.getPart4And5AsUint64(gd) != 0
        apv = CC.getAsAPValue(gd)
        @test apv isa CC.APValue
        @test apv.ptr != C_NULL
    end
    dispose(fms)
    dispose(Ims)

    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    f = DeclFinder(I)

    CC.parse(I, "int la = 5;")
    @test f(I, "la")
    la = CC.VarDecl(get_decl(f))
    loc = CC.getLocation(la)
    id = CC.getIdentifier(la)
    ity = CC.getType(la)
    itsi = CC.getTypeSourceInfo(la)

    # ---- CXXRecordDecl::setDescribedClassTemplate: round-trip on a synthetic record ----
    rd = CC.CXXRecordDecl(ctx, LX.CXTagTypeKind_Struct, dc, loc, loc, id)
    CC.setDescribedClassTemplate(rd, CC.ClassTemplateDecl(C_NULL))
    @test CC.getDescribedClassTemplate(rd).ptr == C_NULL

    # ---- LifetimeExtendedTemporaryDecl::Create ----
    @test CC.hasInit(la)
    letd = CC.LifetimeExtendedTemporaryDecl(CC.getInit(la), la, 7)
    @test letd isa CC.LifetimeExtendedTemporaryDecl
    @test CC.getExtendingDecl(letd).ptr == la.ptr
    @test CC.getManglingNumber(letd) == 7
    @test CC.hasTemporaryExpr(letd) == true
    @test CC.getTemporaryExpr(letd).ptr == CC.getInit(la).ptr
    @test_throws AssertionError CC.LifetimeExtendedTemporaryDecl(CC.Expr_(C_NULL), la, 1)

    # ---- DecompositionDecl::Create: (buffer, count) of BindingDecl handles ----
    b0 = CC.BindingDecl(ctx, dc, loc, id)
    b1 = CC.BindingDecl(ctx, dc, loc, id)
    dcmp = CC.DecompositionDecl(ctx, dc, loc, loc, ity, itsi, LX.CXStorageClass_SC_None, [b0, b1])
    @test dcmp isa CC.DecompositionDecl
    @test CC.getNumBindings(dcmp) == 2
    @test CC.getBinding(dcmp, 0).ptr == b0.ptr
    @test CC.getBinding(dcmp, 1).ptr == b1.ptr

    # ---- ctor / dtor / conversion / deduction-guide factories ----
    CC.parse(I, "struct LKA { LKA(); ~LKA(); operator int() const; };")
    @test f(I, "LKA")
    lka = CC.CXXRecordDecl(get_decl(f))

    c0 = first(CC.getCtors(lka))
    ces = CC.ExplicitSpecifier(c0)
    cni = CC.getNameInfo(c0)
    @test CC.getNameKind(CC.getName(cni)) == LX.CXDeclarationName_CXXConstructorName
    cd = CC.CXXConstructorDecl(ctx, lka, CC.getBeginLoc(c0), cni, CC.getType(c0), CC.getTypeSourceInfo(c0), ces, false,
                               false, false, LX.CXConstexprSpecKind_Unspecified)
    @test cd isa CC.CXXConstructorDecl
    @test cd.ptr != C_NULL
    @test CC.isInheritingConstructor(cd) == false

    dtor = CC.getDestructor(lka)
    @test dtor.ptr != C_NULL
    dni = CC.getNameInfo(dtor)
    dd = CC.CXXDestructorDecl(ctx, lka, CC.getBeginLoc(dtor), dni, CC.getType(dtor), CC.getTypeSourceInfo(dtor), false,
                              false, false, LX.CXConstexprSpecKind_Unspecified)
    @test dd isa CC.CXXDestructorDecl
    @test dd.ptr != C_NULL

    # Invariant 3: clang asserts the declaration-name kind of each factory.
    @test_throws AssertionError CC.CXXConstructorDecl(ctx, lka, CC.getBeginLoc(c0), dni, CC.getType(c0),
                                                      CC.getTypeSourceInfo(c0), ces, false, false, false,
                                                      LX.CXConstexprSpecKind_Unspecified)
    @test_throws AssertionError CC.CXXDestructorDecl(ctx, lka, CC.getBeginLoc(c0), cni, CC.getType(c0),
                                                     CC.getTypeSourceInfo(c0), false, false, false,
                                                     LX.CXConstexprSpecKind_Unspecified)

    cvs = [m
           for m in CC.getMethods(lka)
           if CC.getNameKind(CC.getName(CC.getNameInfo(m))) == LX.CXDeclarationName_CXXConversionFunctionName]
    @test !isempty(cvs)
    # getMethods hands back CXXMethodDecl carriers; the conversion-only accessors need
    # the precise class.
    cv0 = CC.CXXConversionDecl(first(cvs))
    ves = CC.ExplicitSpecifier(cv0)
    cvd = CC.CXXConversionDecl(ctx, lka, CC.getBeginLoc(cv0), CC.getNameInfo(cv0), CC.getType(cv0),
                               CC.getTypeSourceInfo(cv0), false, false, ves, LX.CXConstexprSpecKind_Unspecified,
                               CC.getLocation(cv0))
    @test cvd isa CC.CXXConversionDecl
    @test cvd.ptr != C_NULL
    @test CC.getConversionType(cvd).ptr == CC.getConversionType(cv0).ptr
    @test_throws AssertionError CC.CXXConversionDecl(ctx, lka, CC.getBeginLoc(cv0), cni, CC.getType(cv0),
                                                     CC.getTypeSourceInfo(cv0), false, false, ves,
                                                     LX.CXConstexprSpecKind_Unspecified, CC.getLocation(cv0))

    dgd = CC.CXXDeductionGuideDecl(ctx, dc, CC.getBeginLoc(c0), ces, cni, CC.getType(c0), CC.getTypeSourceInfo(c0),
                                   CC.getLocation(c0), c0, LX.CXDeductionCandidate_Copy)
    @test dgd isa CC.CXXDeductionGuideDecl
    @test dgd.ptr != C_NULL
    @test CC.getDeductionCandidateKind(dgd) == LX.CXDeductionCandidate_Copy
    @test CC.getCorrespondingConstructor(dgd).ptr == c0.ptr

    dispose(ces)
    dispose(ves)

    # ---- CXXRecordDecl::setIsParsingBaseSpecifiers: needs a definition (Invariant 3) ----
    CC.parse(I, "struct LKFwd;")
    @test f(I, "LKFwd")
    fwd = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasDefinition(fwd) == false
    @test_throws AssertionError CC.setIsParsingBaseSpecifiers(fwd)
    # Applied last: the flag only ever goes false -> true, so it is set on a class no later
    # parse in this interpreter touches.
    CC.setIsParsingBaseSpecifiers(lka)
    @test CC.isParsingBaseSpecifiers(lka) == true

    dispose(f)
    dispose(I)
end

@testset "DeclCXX definition-data, lambda-numbering and shadow mutators" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)
    f = DeclFinder(I)

    # ---- CXXRecordDecl: flags that live in the definition data ----
    CC.parse(I, "struct MDM0 { int x; };")
    @test f(I, "MDM0")
    mdm0 = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasDefinition(mdm0)
    CC.markEmpty(mdm0)
    @test CC.isEmpty(mdm0)
    CC.markAbstract(mdm0)
    @test CC.isAbstract(mdm0)
    CC.setHasTrivialSpecialMemberForCall(mdm0)
    @test CC.hasTrivialCopyConstructorForCall(mdm0)
    @test CC.hasTrivialMoveConstructorForCall(mdm0)
    @test CC.hasTrivialDestructorForCall(mdm0)

    # a forward declaration carries no definition data: the setters reject it (Invariant 3)
    CC.parse(I, "struct MDMFwd;")
    @test f(I, "MDMFwd")
    mdmfwd = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasDefinition(mdmfwd) == false
    @test_throws AssertionError CC.markEmpty(mdmfwd)
    @test_throws AssertionError CC.markAbstract(mdmfwd)
    @test_throws AssertionError CC.setHasTrivialSpecialMemberForCall(mdmfwd)

    # ---- CXXRecordDecl: the implicit-special-member deletion flags ----
    # user-declaring a move operation is what makes clang need overload resolution for both
    # copy operations; the deleted-ness of a *defaulted* member is only readable once Sema
    # has declared it, so the round-trip stops at the setter here.
    CC.parse(I, "struct MDM1 { MDM1(MDM1&&); MDM1& operator=(MDM1&&); };")
    @test f(I, "MDM1")
    mdm1 = CC.CXXRecordDecl(get_decl(f))
    @test CC.needsOverloadResolutionForCopyConstructor(mdm1)
    @test CC.needsOverloadResolutionForCopyAssignment(mdm1)
    @test CC.setImplicitCopyConstructorIsDeleted(mdm1) === nothing
    @test CC.setImplicitCopyAssignmentIsDeleted(mdm1) === nothing

    # a member whose own special members are user-provided is what sets the class's
    # NeedOverloadResolutionForMove*/Destructor bits
    CC.parse(I, "struct MDM2 { MDM2(MDM2&&); MDM2& operator=(MDM2&&); ~MDM2(); }; struct MDM3 { MDM2 m; };")
    @test f(I, "MDM3")
    mdm3 = CC.CXXRecordDecl(get_decl(f))
    @test CC.needsOverloadResolutionForMoveConstructor(mdm3)
    @test CC.needsOverloadResolutionForMoveAssignment(mdm3)
    @test CC.needsOverloadResolutionForDestructor(mdm3)
    if CC.needsOverloadResolutionForMoveConstructor(mdm3)
        @test CC.setImplicitMoveConstructorIsDeleted(mdm3) === nothing
    end
    if CC.needsOverloadResolutionForMoveAssignment(mdm3)
        @test CC.setImplicitMoveAssignmentIsDeleted(mdm3) === nothing
    end
    if CC.needsOverloadResolutionForDestructor(mdm3)
        @test CC.setImplicitDestructorIsDeleted(mdm3) === nothing
    end

    # ---- CXXRecordDecl: removeConversion ----
    CC.parse(I, "struct MDM4 { operator int(); };")
    @test f(I, "MDM4")
    mdm4 = CC.CXXRecordDecl(get_decl(f))
    @test CC.getNumConversions(mdm4) == 1
    conv = CC.getConversion(mdm4, 0)
    CC.removeConversion(mdm4, conv)
    @test CC.getNumConversions(mdm4) == 0
    # the set no longer holds it, and clang would llvm_unreachable() on a second removal
    @test_throws AssertionError CC.removeConversion(mdm4, conv)

    # ---- CXXRecordDecl: the two CXXMethodDecl-taking definition-data updates ----
    CC.parse(I, "struct MDM5 { MDM5() = default; MDM5(const MDM5&) = default; };")
    @test f(I, "MDM5")
    mdm5 = CC.CXXRecordDecl(get_decl(f))
    ctors = CC.getCtors(mdm5)
    @test !isempty(ctors)
    for c in ctors
        @test CC.setTrivialForCallFlags(mdm5, c) === nothing
    end
    @test CC.hasTrivialCopyConstructorForCall(mdm5)
    for c in ctors
        if !CC.isImplicit(c) && !CC.isUserProvided(c)
            @test CC.finishedDefaultedOrDeletedMember(mdm5, c) === nothing
        end
    end

    # ---- CXXRecordDecl: lambda numbering and the generic-lambda flag ----
    CC.parse(I, "int mdmv = 1;")
    @test f(I, "mdmv")
    mdmv = CC.VarDecl(get_decl(f))
    loc = CC.getLocation(mdmv)
    tsi = CC.getTypeSourceInfo(mdmv)
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc, LCE.CXLambdaDependencyKind_Unknown, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test CC.isLambda(lam)
    CC.setLambdaNumbering(lam, mdmv, 3, 7, 5, true)
    @test CC.getLambdaIndexInContext(lam) == 3
    @test CC.getLambdaManglingNumber(lam) == 7
    @test CC.getLambdaContextDecl(lam).ptr == mdmv.ptr
    @test CC.hasKnownLambdaInternalLinkage(lam)
    @test CC.getDeviceLambdaManglingNumber(lam) == 5
    CC.setLambdaIsGeneric(lam, true)
    @test CC.isGenericLambda(lam)
    CC.setLambdaIsGeneric(lam, false)
    @test CC.isGenericLambda(lam) == false
    # both lambda setters reject a class that is not a closure type
    @test_throws AssertionError CC.setLambdaIsGeneric(mdm0, true)
    @test_throws AssertionError CC.setLambdaNumbering(mdm0, mdmv, 0, 0, 0, false)

    # ---- CXXDestructorDecl: setOperatorDelete ----
    CC.parse(I, "struct MDM6 { ~MDM6(); void operator delete(void*); };")
    @test f(I, "MDM6")
    mdm6 = CC.CXXRecordDecl(get_decl(f))
    dtor = CC.getDestructor(mdm6)
    @test dtor.ptr != C_NULL
    opdel = nothing
    for m in CC.getMethods(mdm6)
        CC.isStatic(m) && (opdel = m)          # a class operator delete is implicitly static
    end
    @test opdel !== nothing
    if opdel !== nothing
        before = CC.getOperatorDelete(dtor)
        CC.setOperatorDelete(dtor, opdel)
        # clang keeps a previously recorded operator delete, so accept either outcome
        @test CC.getOperatorDelete(dtor).ptr == (before.ptr == C_NULL ? opdel.ptr : before.ptr)
        @test CC.is_null_handle(CC.getOperatorDeleteThisArg(dtor))
    end

    # ---- BaseUsingDecl: the shadow list round-trips through remove/add ----
    CC.parse(I, "namespace mdmns { void mdmfn(); } using mdmns::mdmfn;")
    # Name lookup for "mdmfn" resolves THROUGH the shadow to the Function, so the
    # UsingDecl itself never appears in the result -- walk the TU for it instead.
    tu_dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    ud = CC.UsingDecl(first(d for d in CC.decls(tu_dc) if CC.getDeclKindName(d) == "Using"))
    sh = CC.getShadows(ud)
    @test length(sh) == 1
    CC.removeShadowDecl(ud, sh[1])
    @test CC.shadow_size(ud) == 0
    @test_throws AssertionError CC.removeShadowDecl(ud, sh[1])
    CC.addShadowDecl(ud, sh[1])
    @test CC.shadow_size(ud) == 1
    @test CC.getShadows(ud)[1].ptr == sh[1].ptr
    @test_throws AssertionError CC.addShadowDecl(ud, sh[1])

    dispose(f)
    dispose(I)
end

@testset "DeclCXX: friends, MS inheritance model, member instantiation, using_if_exists" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)
    f = DeclFinder(I)

    # ---- CXXRecordDecl: the friend declarations of a class ----
    CC.parse(I, "struct UIFA; struct UIFB { friend void uiffn(); friend struct UIFA; };")
    @test f(I, "UIFB")
    uifb = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasFriends(uifb)
    @test CC.getNumFriends(uifb) == 2
    fr = CC.getFriends(uifb)
    @test length(fr) == 2
    @test all(d -> d isa CC.Decl, fr)
    @test all(d -> CC.getDeclKindName(d) == "Friend", fr)

    CC.parse(I, "struct UIFC { int uifcx; };")
    @test f(I, "UIFC")
    uifc = CC.CXXRecordDecl(get_decl(f))
    @test CC.hasFriends(uifc) == false
    @test CC.getNumFriends(uifc) == 0
    @test isempty(CC.getFriends(uifc))

    # ---- CXXRecordDecl: the Microsoft C++ ABI member-pointer model ----
    # The model is a property of the class shape, but which of the four a given class
    # lands on is clang's business, so only membership is asserted.
    models = (LCE.CXMSInheritanceModel_Single, LCE.CXMSInheritanceModel_Multiple, LCE.CXMSInheritanceModel_Virtual,
              LCE.CXMSInheritanceModel_Unspecified)
    @test CC.calculateInheritanceModel(uifc) in models
    CC.parse(I, "struct UIFD { virtual void uifdm() {} }; struct UIFE : virtual UIFD {};")
    @test f(I, "UIFE")
    uife = CC.CXXRecordDecl(get_decl(f))
    @test CC.calculateInheritanceModel(uife) in models

    # nullFieldOffsetIsZero is Microsoft-ABI only: the inheritance model it reads lives
    # behind MSInheritanceAttr, which no other ABI populates, so it segfaults rather than
    # answering on an Itanium target. CI runs no Microsoft-ABI host, so what is asserted
    # here is that the wrapper's ABI guard rejects the call.
    @test CC.getCXXABIKind(ctx) != CC.CXTargetCXXABI_Microsoft
    @test_throws AssertionError CC.nullFieldOffsetIsZero(uifc)
    @test_throws AssertionError CC.nullFieldOffsetIsZero(uife)

    # ---- every definition-data reader rejects a class with no definition ----
    CC.parse(I, "int uifv = 1;")
    @test f(I, "uifv")
    uifv = CC.VarDecl(get_decl(f))
    loc = CC.getLocation(uifv)
    id = CC.getIdentifier(uifv)
    tsi = CC.getTypeSourceInfo(uifv)
    fresh = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc, loc, id)
    @test CC.hasDefinition(fresh) == false
    @test_throws AssertionError CC.getNumFriends(fresh)
    @test_throws AssertionError CC.getFriends(fresh)
    @test_throws AssertionError CC.calculateInheritanceModel(fresh)
    @test_throws AssertionError CC.nullFieldOffsetIsZero(fresh)

    # ---- CXXRecordDecl: setLambdaTypeInfo round-trips on a closure type ----
    CC.parse(I, "double uifw = 2;")
    @test f(I, "uifw")
    uifw = CC.VarDecl(get_decl(f))
    tsi2 = CC.getTypeSourceInfo(uifw)
    @test tsi2.ptr != tsi.ptr
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc, LCE.CXLambdaDependencyKind_Unknown, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test CC.isLambda(lam)
    CC.setLambdaTypeInfo(lam, tsi2)
    @test CC.getLambdaTypeInfo(lam).ptr == tsi2.ptr
    @test_throws AssertionError CC.setLambdaTypeInfo(uifc, tsi2)

    # ---- CXXRecordDecl: the member-instantiation slot and its specialization kind ----
    @test CC.getMemberSpecializationInfo(fresh).ptr == C_NULL
    @test CC.getInstantiatedFromMemberClass(fresh).ptr == C_NULL
    # neither a specialization nor an instantiated member yet
    @test_throws AssertionError CC.setTemplateSpecializationKind(fresh,
                                                                 LCE.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
    CC.setInstantiationOfMemberClass(fresh, uifc, LCE.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
    @test CC.getInstantiatedFromMemberClass(fresh).ptr == uifc.ptr
    @test CC.getMemberSpecializationInfo(fresh).ptr != C_NULL
    @test CC.getTemplateSpecializationKind(fresh) == LCE.CXTemplateSpecializationKind_TSK_ImplicitInstantiation
    # the slot is one-way: a second call is rejected
    @test_throws AssertionError CC.setInstantiationOfMemberClass(fresh, uifc,
                                                                 LCE.CXTemplateSpecializationKind_TSK_ImplicitInstantiation)
    # the kind is now settable through the info object clang just built
    CC.setTemplateSpecializationKind(fresh, LCE.CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition)
    @test CC.getTemplateSpecializationKind(fresh) ==
          LCE.CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition
    @test_throws AssertionError CC.setTemplateSpecializationKind(fresh, LCE.CXTemplateSpecializationKind_TSK_Undeclared)
    other = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc, loc, id)
    @test_throws AssertionError CC.setInstantiationOfMemberClass(other, uifc,
                                                                 LCE.CXTemplateSpecializationKind_TSK_Undeclared)

    # ---- UnresolvedUsingIfExistsDecl: the whole class ----
    name = CC.getDeclName(uifv)
    uue = CC.UnresolvedUsingIfExistsDecl(ctx, dc, loc, name)
    @test uue isa CC.UnresolvedUsingIfExistsDecl
    @test uue.ptr != C_NULL
    @test CC.getDeclKindName(uue) == "UnresolvedUsingIfExists"
    @test CC.getName(uue) == "uifv"
    @test CC.getDeclName(uue).ptr == name.ptr
    @test !CC.is_null_handle(CC.UnresolvedUsingIfExistsDecl(ctx, UInt(1)))

    dispose(f)
    dispose(I)
end

@testset "CXXRecordDecl: closure capture fields, imprecise base lookup, Microsoft ABI queries" begin
    LCE = CC.LibClangEx
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)
    f = DeclFinder(I)

    CC.parse(I, """
    struct CapHost {
        int capm = 0;
        auto capmk() { int capa = 1; return [this, capa] { return capm + capa; }; }
    };
    CapHost caphostobj;
    auto CapVar = caphostobj.capmk();
    auto CapNone = [] { return 7; };
    struct LdnBase { int ldnprobe; };
    struct LdnDerived : LdnBase { };
    int ldnprobe = 0;
    int ldnstranger = 0;
    """)

    # ---- CXXRecordDecl: which closure field holds which capture ----
    # A lambda written at namespace scope can capture nothing (variables there have static
    # storage duration), so the capturing closure is reached through a member function's
    # deduced return type.
    @test f(I, "CapVar")
    capvar = CC.VarDecl(get_decl(f))
    lam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(capvar)))
    @test lam isa CC.CXXRecordDecl
    if lam.ptr != C_NULL && CC.isLambda(lam)
        @test CC.capture_size(lam) == 2                # `this` and `capa`
        @test CC.getNumCaptureFields(lam) == 1         # `this` is reported on its own
        vars, fields, this_field = CC.getCaptureFields(lam)
        @test length(vars) == 1
        @test length(fields) == 1
        @test vars[1] isa CC.ValueDecl
        @test CC.getName(vars[1]) == "capa"
        @test fields[1] isa CC.FieldDecl
        @test fields[1].ptr != C_NULL
        @test this_field isa CC.FieldDecl
        @test this_field.ptr != C_NULL
    end

    @test f(I, "CapNone")
    capnone = CC.VarDecl(get_decl(f))
    nolam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(capnone)))
    if nolam.ptr != C_NULL && CC.isLambda(nolam)
        @test CC.getNumCaptureFields(nolam) == 0
        nvars, nfields, nthis = CC.getCaptureFields(nolam)
        @test isempty(nvars)
        @test isempty(nfields)
        @test nthis.ptr == C_NULL
    end

    # a class that is not a closure type has no lambda definition data to reach
    @test f(I, "CapHost")
    caphost = CC.CXXRecordDecl(get_decl(f))
    @test CC.isLambda(caphost) == false
    @test_throws AssertionError CC.getNumCaptureFields(caphost)
    @test_throws AssertionError CC.getCaptureFields(caphost)

    # ---- CXXRecordDecl: the imprecise lookup, in the class and through a base ----
    # DeclarationNames are uniqued per ASTContext, so the global `ldnprobe`'s name is the
    # member's name too.
    @test f(I, "ldnprobe")
    probe = CC.VarDecl(get_decl(f))
    nprobe = CC.getDeclName(probe)
    @test f(I, "ldnstranger")
    nstranger = CC.getDeclName(CC.VarDecl(get_decl(f)))
    @test f(I, "LdnBase")
    ldnbase = CC.CXXRecordDecl(get_decl(f))
    @test f(I, "LdnDerived")
    ldnderived = CC.CXXRecordDecl(get_decl(f))

    @test CC.getNumDependentNameLookupResults(ldnbase, nprobe) == 1
    direct = CC.lookupDependentName(ldnbase, nprobe)
    @test length(direct) == 1
    @test direct[1] isa CC.NamedDecl
    @test CC.getName(direct[1]) == "ldnprobe"
    # the derived class declares no member of that name, so the base classes are searched
    @test CC.getNumDependentNameLookupResults(ldnderived, nprobe) == 1
    inherited = CC.lookupDependentName(ldnderived, nprobe)
    @test length(inherited) == 1
    @test CC.getName(inherited[1]) == "ldnprobe"
    @test CC.getNumDependentNameLookupResults(ldnderived, nstranger) == 0
    @test isempty(CC.lookupDependentName(ldnderived, nstranger))

    # both halves reach the definition data the base walk reads
    loc = CC.getLocation(probe)
    fresh = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc, loc, CC.getIdentifier(probe))
    @test CC.hasDefinition(fresh) == false
    @test_throws AssertionError CC.getNumDependentNameLookupResults(fresh, nprobe)
    @test_throws AssertionError CC.lookupDependentName(fresh, nprobe)

    # ---- CXXRecordDecl: the two Microsoft C++ ABI record queries ----
    # getMSInheritanceModel dereferences an MSInheritanceAttr only the Microsoft C++ ABI
    # attaches, and a vtordisp is an MS-ABI construct. CI runs no Microsoft-ABI host, so
    # what is asserted here is that the ABI guard rejects the call.
    @test CC.getCXXABIKind(ctx) != CC.CXTargetCXXABI_Microsoft
    @test CC.hasAttrOfKind(ldnbase, LCE.CXAttrKind_MSInheritance) == false
    @test_throws AssertionError CC.getMSInheritanceModel(ldnbase)
    @test_throws AssertionError CC.getMSVtorDispMode(ldnbase)

    dispose(f)
    dispose(I)
end

@testset "DeclCXX | qualifier locations, qualifier-taking factories, final overriders" begin
    I = create_interpreter(["-std=c++20"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            namespace NSQOuter { namespace NSQInner {
                int nsq_v;
                enum class NSQColor { nsq_red, nsq_green };
            } }
            namespace NSQTop { int nsq_t; }
            using namespace NSQOuter::NSQInner;
            using namespace NSQTop;
            namespace nsq_alias = NSQOuter::NSQInner;
            using NSQOuter::NSQInner::nsq_v;
            using enum NSQOuter::NSQInner::NSQColor;
            template <class T> struct UUQ : T {
                using T::uuqv;
                using typename T::uuqt;
            };
            struct FOBase { virtual void fo_f(); virtual void fo_g(); };
            struct FOMid : FOBase { void fo_f() override; };
            struct FOMost : FOMid { void fo_g() override; };
            struct FOPlain { int fp; };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        dc = CC.castToDeclContext(tu)
        alldecls = CC.decls(dc)
        rec(name) = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == name)

        # clang defines `getQualifier` as this box's specifier, so the two must always agree
        # and `hasQualifier` must track whether the specifier is there at all.
        function check_qualifier_loc(d)
            q = CC.getQualifierLoc(d)
            try
                @test q isa CC.NestedNameSpecifierLoc
                @test q.ptr != C_NULL
                @test CC.getNestedNameSpecifier(q).ptr == CC.getQualifier(d).ptr
                @test CC.hasQualifier(q) == (CC.getQualifier(d).ptr != C_NULL)
            finally
                dispose(q)
            end
        end

        # ---- UsingDirectiveDecl: qualified and unqualified ----
        udirs = [d for d in alldecls if d isa CC.UsingDirectiveDecl]
        qual_udir = first(d for d in udirs if CC.getQualifier(d).ptr != C_NULL)
        plain_udir = first(d for d in udirs if CC.getQualifier(d).ptr == C_NULL)
        check_qualifier_loc(qual_udir)
        check_qualifier_loc(plain_udir)
        @test !CC.is_null_handle(CC.getCommonAncestor(qual_udir))

        qual_q = CC.getQualifierLoc(qual_udir)
        plain_q = CC.getQualifierLoc(plain_udir)
        try
            @test CC.hasQualifier(qual_q)
            # `using namespace NSQTop;` writes no nested-name-specifier: an empty box.
            @test !CC.hasQualifier(plain_q)
            @test CC.getSourceRange(plain_q).begin_loc.ptr == C_NULL
            # `using namespace NSQOuter::NSQInner;` writes `NSQOuter::` as the qualifier —
            # NSQInner is the namespace being nominated, not part of the qualifier — so the
            # one component present has an empty prefix.
            prefix = CC.getPrefix(qual_q)
            try
                @test prefix isa CC.NestedNameSpecifierLoc
                @test !CC.hasQualifier(prefix)
            finally
                dispose(prefix)
            end

            # ---- UsingDirectiveDecl::Create, fed the qualifier it just handed back ----
            udd2 = CC.UsingDirectiveDecl(ctx, dc, CC.getUsingLoc(qual_udir), CC.getNamespaceKeyLocation(qual_udir),
                                         qual_q, CC.getIdentLocation(qual_udir),
                                         CC.getNominatedNamespaceAsWritten(qual_udir), dc)
            @test udd2 isa CC.UsingDirectiveDecl
            @test udd2.ptr != C_NULL && udd2.ptr != qual_udir.ptr
            @test CC.getIdentLocation(udd2).ptr == CC.getIdentLocation(qual_udir).ptr
            q2 = CC.getQualifierLoc(udd2)
            try
                @test CC.getNestedNameSpecifier(q2).ptr == CC.getNestedNameSpecifier(qual_q).ptr
            finally
                dispose(q2)
            end
        finally
            dispose(qual_q)
            dispose(plain_q)
        end

        # ---- NamespaceAliasDecl: qualifier location + Create round-trip ----
        nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
        check_qualifier_loc(nad)
        nq = CC.getQualifierLoc(nad)
        try
            nad2 = CC.NamespaceAliasDecl(ctx, dc, CC.getNamespaceLoc(nad), CC.getAliasLoc(nad), CC.getIdentifier(nad),
                                         nq, CC.getTargetNameLoc(nad), CC.getAliasedNamespace(nad))
            @test nad2 isa CC.NamespaceAliasDecl
            @test nad2.ptr != C_NULL && nad2.ptr != nad.ptr
            @test CC.getNameAsString(nad2) == CC.getNameAsString(nad)
            @test CC.getAliasedNamespace(nad2).ptr == CC.getAliasedNamespace(nad).ptr
        finally
            dispose(nq)
        end

        # ---- UsingDecl: qualifier location + Create round-trip ----
        ud = first(d for d in alldecls if d isa CC.UsingDecl)
        check_qualifier_loc(ud)
        uq = CC.getQualifierLoc(ud)
        uni = CC.getNameInfo(ud)
        try
            ud2 = CC.UsingDecl(ctx, dc, CC.getUsingLoc(ud), uq, uni, false)
            @test ud2 isa CC.UsingDecl
            @test ud2.ptr != C_NULL && ud2.ptr != ud.ptr
            @test CC.getNameAsString(ud2) == CC.getNameAsString(ud)
            # `has_typename` is a value this test set, so it round-trips exactly.
            @test CC.hasTypename(ud2) == false
        finally
            dispose(uni)
            dispose(uq)
        end

        # ---- UsingEnumDecl: qualifier location behind the written enumeration type ----
        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        @test CC.getEnumType(ued).ptr != C_NULL
        check_qualifier_loc(ued)

        # ---- UnresolvedUsing{Value,Typename}Decl: locations + Create round-trips ----
        ctd = first(d for d in alldecls if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUQ")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        check_qualifier_loc(uuv)
        vq = CC.getQualifierLoc(uuv)
        vni = CC.getNameInfo(uuv)
        try
            # A valid ellipsis location is what marks a pack expansion, so passing one is a
            # round-trip of a value this test set.
            ell = CC.getUsingLoc(uuv)
            uuv2 = CC.UnresolvedUsingValueDecl(ctx, dc, CC.getUsingLoc(uuv), vq, vni, ell)
            @test uuv2 isa CC.UnresolvedUsingValueDecl
            @test uuv2.ptr != C_NULL && uuv2.ptr != uuv.ptr
            @test CC.getNameAsString(uuv2) == CC.getNameAsString(uuv)
            @test CC.isPackExpansion(uuv2)
            @test CC.getEllipsisLoc(uuv2).ptr == ell.ptr
        finally
            dispose(vni)
            dispose(vq)
        end

        uut = first(d for d in members if d isa CC.UnresolvedUsingTypenameDecl)
        check_qualifier_loc(uut)
        tq = CC.getQualifierLoc(uut)
        tni = CC.getNameInfo(uut)
        try
            name = CC.getName(tni)
            @test CC.getAsIdentifierInfo(name).ptr != C_NULL
            uut2 = CC.UnresolvedUsingTypenameDecl(ctx, dc, CC.getUsingLoc(uut), CC.getTypenameLoc(uut), tq,
                                                  CC.getLocation(uut), name, CC.getTypenameLoc(uut))
            @test uut2 isa CC.UnresolvedUsingTypenameDecl
            @test uut2.ptr != C_NULL && uut2.ptr != uut.ptr
            @test CC.getNameAsString(uut2) == CC.getNameAsString(uut)
            @test CC.isPackExpansion(uut2)
        finally
            dispose(tni)
            dispose(tq)
        end

        # ---- CXXRecordDecl::getFinalOverriders (count + five lockstep buffers) ----
        # FOPlain declares and inherits no virtual member function, so clang's collector
        # never records a row for it.
        @test CC.getNumFinalOverriders(rec("FOPlain")) == 0
        plain_rows = CC.getFinalOverriders(rec("FOPlain"))
        @test all(isempty, plain_rows)

        most = rec("FOMost")
        n = CC.getNumFinalOverriders(most)
        @test n >= 2  # shape-only: vtable layout differs between Itanium and MSVC ABI
        # FOBase declares two virtual functions and each has at least one final overrider.
        overridden, osub, overrider, rsub, invb = CC.getFinalOverriders(most)
        @test length(overridden) == n
        @test length(osub) == n && length(overrider) == n
        @test length(rsub) == n && length(invb) == n
        @test all(m -> m isa CC.CXXMethodDecl && m.ptr != C_NULL, overridden)
        @test all(m -> m isa CC.CXXMethodDecl && m.ptr != C_NULL, overrider)
        @test all(s -> s >= 0, osub)
        @test all(s -> s >= 0, rsub)
        @test all(r -> r isa CC.CXXRecordDecl, invb)
        @test all(CC.isVirtual, overridden)
        @test all(CC.isVirtual, overrider)
        # FOMost does not redeclare fo_f, so FOBase::fo_f is finally overridden by FOMid.
        i = findfirst(m -> CC.getNameAsString(m) == "fo_f" && CC.getNameAsString(CC.getParent(m)) == "FOBase",
                      overridden)
        @test i !== nothing
        if i !== nothing
            @test CC.getNameAsString(overrider[i]) == "fo_f"
            @test CC.getNameAsString(CC.getParent(overrider[i])) == "FOMid"
        end
    finally
        dispose(I)
    end
end

@testset "CXXRecordDecl | base paths and the selected destructor" begin
    I = create_interpreter(["-std=c++20"])
    try
        ctx = CC.get_ast_context(I)
        CC.parse(I, """
            struct BPBase { int bp; };
            struct BPPriv : private BPBase {};
            struct BPProt : protected BPBase {};
            struct BPMid : private BPBase {};
            struct BPLeaf : BPMid {};
            struct BPLeft : BPBase {};
            struct BPRight : BPBase {};
            struct BPAmbig : BPLeft, BPRight {};
            struct BPVLeft : virtual BPBase {};
            struct BPVRight : virtual BPBase {};
            struct BPVirt : BPVLeft, BPVRight {};
            struct BPUnrelated { int u; };
            struct BPVDtor { virtual ~BPVDtor(); };
        """)
        tu = CC.getTranslationUnitDecl(ctx)
        alldecls = CC.decls(CC.castToDeclContext(tu))
        rec(name) = first(d for d in alldecls if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == name)
        base = rec("BPBase")

        # Rows exist exactly when the derivation does, which is the question `isDerivedFrom`
        # already answers — including the two clang answers `false` for outright (a class is
        # not derived from itself, and derivation does not run backwards).
        for (d, b) in ((rec("BPPriv"), base), (rec("BPLeaf"), base), (rec("BPAmbig"), base), (rec("BPVirt"), base),
                       (base, rec("BPPriv")), (base, base), (rec("BPUnrelated"), base))
            @test (CC.getNumBasePathElements(d, b) > 0) == CC.isDerivedFrom(d, b)
        end
        @test CC.getNumBasePathElements(base, base) == 0
        @test all(isempty, CC.getBasePathElements(base, rec("BPUnrelated")))

        # A one-step path merges to the specifier's own access, and its single row names the
        # class the specifier is written on plus the specifier itself.
        function one_step_access(x)
            p, a, s, c, sub = CC.getBasePathElements(x, base)
            @test p == [0]
            @test [e.ptr for e in s] == [b.ptr for b in CC.getBases(x)]
            @test [e.ptr for e in c] == [x.ptr]
            @test sub == [1]   # the first non-virtual BPBase subobject; clang counts from 1
            return only(a)
        end
        @test one_step_access(rec("BPLeft")) == LX.CXAccessSpecifier_AS_public
        @test one_step_access(rec("BPPriv")) == LX.CXAccessSpecifier_AS_private
        @test one_step_access(rec("BPProt")) == LX.CXAccessSpecifier_AS_protected

        # `private` past the first step is what produces AS_none: BPLeaf is derived from
        # BPBase, and no path permits the conversion.
        leaf, mid = rec("BPLeaf"), rec("BPMid")
        @test CC.getNumBasePathElements(leaf, base) == 2
        p, a, s, c, sub = CC.getBasePathElements(leaf, base)
        @test p == [0, 0]
        @test a == fill(LX.CXAccessSpecifier_AS_none, 2)
        @test [e.ptr for e in c] == [leaf.ptr, mid.ptr]
        @test [e.ptr for e in s] == [only(CC.getBases(leaf)).ptr, only(CC.getBases(mid)).ptr]
        @test CC.MergeAccess(LX.CXAccessSpecifier_AS_public, LX.CXAccessSpecifier_AS_private) ==
              LX.CXAccessSpecifier_AS_none

        # Two paths to two distinct subobjects of one base type: what tells them apart is the
        # subobject number on the terminal step, not the path number.
        ambig = rec("BPAmbig")
        @test CC.getNumBasePathElements(ambig, base) == 4
        p, a, s, c, sub = CC.getBasePathElements(ambig, base)
        @test p == [0, 0, 1, 1]
        @test all(==(LX.CXAccessSpecifier_AS_public), a)
        terminal = [findlast(==(i), p) for i in unique(p)]
        @test [c[i].ptr for i in terminal] == [rec("BPLeft").ptr, rec("BPRight").ptr]
        @test length(unique(sub[terminal])) == 2
        @test !any(i -> CC.isVirtual(s[i]), terminal)
        # Every step follows a specifier written on that step's own class, and every path
        # terminates at the base the search asked for.
        target(e) = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(e)))
        for i in eachindex(s)
            @test s[i].ptr in [b.ptr for b in CC.getBases(c[i])]
            @test (i in terminal) == (target(s[i]).ptr == base.ptr)
        end

        # The virtual diamond reaches one shared subobject, which is why clang numbers a
        # virtual edge 0 instead of counting it.
        virt = rec("BPVirt")
        @test CC.isVirtuallyDerivedFrom(virt, base)
        @test CC.getNumBasePathElements(virt, base) == 4
        p, a, s, c, sub = CC.getBasePathElements(virt, base)
        @test p == [0, 0, 1, 1]
        vrows = [i for i in eachindex(s) if CC.isVirtual(s[i])]
        @test vrows == [2, 4]
        @test all(==(0), sub[vrows])
        @test all(!=(0), sub[setdiff(eachindex(s), vrows)])

        # addedSelectedDestructor is observable twice over: it clears the destructor's own
        # ineligible-or-not-selected bit, and, the destructor being virtual, it clears the
        # class's trivial-for-call bit that the setter above had just turned on.
        vd = rec("BPVDtor")
        dtor = CC.getDestructor(vd)
        @test CC.isVirtual(dtor)
        CC.setIneligibleOrNotSelected(dtor, true)
        CC.setHasTrivialSpecialMemberForCall(vd)
        @test CC.isIneligibleOrNotSelected(dtor)
        @test CC.hasTrivialDestructorForCall(vd)
        @test CC.addedSelectedDestructor(vd, dtor) === nothing
        @test !CC.isIneligibleOrNotSelected(dtor)
        @test !CC.hasTrivialDestructorForCall(vd)
    finally
        dispose(I)
    end
end
