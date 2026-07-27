using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

# Setter/factory coverage: round-trip setters and construct-from-live-context
# factories for the AST surface (built + self-verified by subagents).
const LX = CC.LibClangEx
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
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
    aa = CC.VarDecl(get_decl(f).ptr)
    @test f(I, "bb")
    bb = CC.VarDecl(get_decl(f).ptr)
    loc_a = CC.getLocation(aa)
    loc_b = CC.getLocation(bb)
    id_a = CC.getIdentifier(aa)
    @test loc_a.ptr != loc_b.ptr

    # ---- AccessSpecDecl: factories + loc setters ----
    asd = CC.AccessSpecDecl(ctx, LCE.CXAccessSpecifier_AS_public, dc, loc_a, loc_a)
    @test asd isa CC.AccessSpecDecl
    asd2 = CC.AccessSpecDecl(ctx, UInt(1))
    @test asd2 isa CC.AccessSpecDecl
    CC.setAccessSpecifierLoc(asd, loc_b)
    @test CC.getAccessSpecifierLoc(asd).ptr == loc_b.ptr
    CC.setColonLoc(asd, loc_a)
    @test CC.getColonLoc(asd).ptr == loc_a.ptr

    # ---- LinkageSpecDecl: factories + setters ----
    lsd = CC.LinkageSpecDecl(ctx, dc, loc_a, loc_a, LCE.CXLinkageSpecDecl_lang_c, true)
    @test lsd isa CC.LinkageSpecDecl
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_c
    lsd2 = CC.LinkageSpecDecl(ctx, UInt(1))
    @test lsd2 isa CC.LinkageSpecDecl
    CC.setLanguage(lsd, LCE.CXLinkageSpecDecl_lang_cxx)
    @test CC.getLanguage(lsd) == LCE.CXLinkageSpecDecl_lang_cxx
    CC.setExternLoc(lsd, loc_b)
    @test CC.getExternLoc(lsd).ptr == loc_b.ptr
    CC.setRBraceLoc(lsd, loc_a)
    @test CC.getRBraceLoc(lsd).ptr == loc_a.ptr

    # ---- CXXRecordDecl: Create + CreateLambda ----
    rd = CC.CXXRecordDecl(ctx, LCE.CXTagTypeKind_Struct, dc, loc_a, loc_a, id_a)
    @test rd isa CC.CXXRecordDecl
    tsi = CC.getTypeSourceInfo(aa)                    # a real TypeSourceInfo (int)
    lam = CC.CXXRecordDecl(ctx, dc, tsi, loc_a, LCE.CXLambdaDependencyKind_Unknown, false,
                           LCE.CXLambdaCaptureDefault_LCD_None)
    @test lam isa CC.CXXRecordDecl
    @test CC.isLambda(lam)

    # ---- CXXBaseSpecifier: setInheritConstructors round-trip ----
    CC.parse(I, "struct BB0 { BB0(int); }; struct DD0 : BB0 { using BB0::BB0; };")
    @test f(I, "DD0")
    dd0 = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.getNumBases(dd0) == 1
    base = CC.getBase(dd0, 0)
    CC.setInheritConstructors(base, true)
    @test CC.getInheritConstructors(base) == true
    CC.setInheritConstructors(base, false)
    @test CC.getInheritConstructors(base) == false

    # ---- CXXMethodDecl: Create (from a parsed method) + CreateDeserialized ----
    CC.parse(I, "struct Foo0 { void bar0(int); };")
    @test f(I, "Foo0")
    foo0 = CC.CXXRecordDecl(get_decl(f).ptr)
    bar0 = first(m for m in CC.getMethods(foo0) if CC.getName(m) == "bar0")
    ni = CC.getNameInfo(bar0)
    mty = CC.getType(bar0)
    mtsi = CC.getTypeSourceInfo(bar0)
    sloc = CC.getBeginLoc(bar0)
    eloc = CC.getLocation(bar0)
    md = CC.CXXMethodDecl(ctx, foo0, sloc, ni, mty, mtsi,
                          LCE.CXStorageClass_SC_None, false, false,
                          LCE.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    md2 = CC.CXXMethodDecl(ctx, UInt(1))
    @test md2 isa CC.CXXMethodDecl

    # ---- Template factories/setters (already wrapped) reachable safely ----
    CC.parse(I, "template<class TT> struct S1 { TT x; };")
    @test f(I, "S1")
    s1 = CC.ClassTemplateDecl(get_decl(f).ptr)
    targ = CC.TemplateArgument(CC.getType(aa))        # an `int` template argument
    tal = CC.TemplateArgumentList(ctx, [targ])
    @test size(tal) == 1
    @test Base.get(tal, 0) isa CC.TemplateArgument
    ctsd = CC.ClassTemplateSpecializationDecl(ctx, s1, tal)
    @test ctsd isa CC.ClassTemplateSpecializationDecl
    @test CC.getTemplateArgs(ctsd) isa CC.TemplateArgumentList
    tal2 = CC.TemplateArgumentList(ctx, [targ])
    CC.setTemplateArgs(ctsd, tal2)
    @test size(CC.getTemplateArgs(ctsd)) == 1

    dispose(f)
    dispose(I)
end

@testset "CXXMethodDecl_Create bool round-trip" begin
    # Regression: clang_CXXMethodDecl_Create forwarded (isInline, UsesFPIntrin) in
    # reversed order, so a method created inline read back non-inline. isInlineSpecified
    # is inherited from FunctionDecl; reach it through the free primary-base upcast.
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    dc = CC.castToDeclContext(CC.getTranslationUnitDecl(ctx))
    CC.parse(I, "struct MFoo { void mbar(int); };")
    f = DeclFinder(I)
    @test f(I, "MFoo")
    mfoo = CC.CXXRecordDecl(get_decl(f).ptr)
    mbar = first(m for m in CC.getMethods(mfoo) if CC.getName(m) == "mbar")
    ni = CC.getNameInfo(mbar)
    mty = CC.getType(mbar)
    mtsi = CC.getTypeSourceInfo(mbar)
    sloc = CC.getBeginLoc(mbar)
    eloc = CC.getLocation(mbar)

    # uses_fp_intrin=false, is_inline=true
    md = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                          false, true, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test md isa CC.CXXMethodDecl
    @test CC.isInlineSpecified(CC.FunctionDecl(md.ptr)) == true    # was false before the fix

    # complementary: uses_fp_intrin=false, is_inline=false
    md2 = CC.CXXMethodDecl(ctx, mfoo, sloc, ni, mty, mtsi, LX.CXStorageClass_SC_None,
                           false, false, LX.CXConstexprSpecKind_Unspecified, eloc)
    @test CC.isInlineSpecified(CC.FunctionDecl(md2.ptr)) == false

    dispose(f)
    dispose(I)
end

@testset "DeclCXX ctor initializers" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "struct Base { int b; }; struct Wid : Base { int m; Wid(int x) : Base(), m(x) {} };")
    @test f(I, "Wid")
    wid = CC.CXXRecordDecl(get_decl(f).ptr)
    ctor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) == 2)
    inits = CC.getCtorInitializers(ctor)
    @test length(inits) == 2
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    @test CC.isBaseInitializer(inits[1])
    @test !CC.isMemberInitializer(inits[1])
    @test CC.getBaseClass(inits[1]) isa CC.Type_
    @test CC.isMemberInitializer(inits[2])
    @test CC.getName(CC.getMember(inits[2])) == "m"
    @test CC.getInit(inits[2]) isa CC.Expr_
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
    b1 = CC.CXXRecordDecl(CC.get_tag(f).ptr)
    @test f(I, "IdfB2")
    b2 = CC.CXXRecordDecl(CC.get_tag(f).ptr)
    @test f(I, "IdfD")
    d = CC.CXXRecordDecl(CC.get_tag(f).ptr)
    @test f(I, "IdfV")
    v = CC.CXXRecordDecl(CC.get_tag(f).ptr)

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
    baseRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "Derived")
    derivedRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "Diamond")
    diamondRD = CC.CXXRecordDecl(get_decl(f).ptr)

    # ---- CXXRecordDecl: decl-chain accessors ----
    @test CC.getCanonicalDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getPreviousDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getMostRecentDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getMostRecentNonInjectedDecl(baseRD) isa CC.CXXRecordDecl
    @test CC.getDefinition(baseRD) isa CC.CXXRecordDecl

    # ---- CXXRecordDecl: Bool-returning trait predicates (~90) ----
    boolpreds = [CC.hasDefinition, CC.isLambda, CC.isGenericLambda, CC.isAggregate,
        CC.isPOD, CC.isCLike, CC.isEmpty, CC.isDynamicClass, CC.allowConstDefaultInit,
        CC.hasAnyDependentBases,
        CC.hasConstexprDefaultConstructor, CC.hasConstexprDestructor,
        CC.hasConstexprNonCopyMoveConstructor, CC.hasCopyAssignmentWithConstParam,
        CC.hasCopyConstructorWithConstParam, CC.hasDefaultConstructor, CC.hasDirectFields,
        CC.hasFriends, CC.hasInClassInitializer, CC.hasInheritedAssignment,
        CC.hasInheritedConstructor, CC.hasInitMethod, CC.hasIrrelevantDestructor,
        CC.hasMoveAssignment, CC.hasMoveConstructor,
        CC.hasMutableFields, CC.hasNonLiteralTypeFieldsOrBases, CC.hasNonTrivialCopyAssignment,
        CC.hasNonTrivialCopyConstructor, CC.hasNonTrivialCopyConstructorForCall,
        CC.hasNonTrivialDefaultConstructor, CC.hasNonTrivialDestructor,
        CC.hasNonTrivialDestructorForCall, CC.hasNonTrivialMoveAssignment,
        CC.hasNonTrivialMoveConstructor, CC.hasNonTrivialMoveConstructorForCall,
        CC.hasPrivateFields, CC.hasProtectedFields, CC.hasSimpleCopyAssignment,
        CC.hasSimpleCopyConstructor, CC.hasSimpleDestructor, CC.hasSimpleMoveAssignment,
        CC.hasSimpleMoveConstructor, CC.hasTrivialCopyAssignment, CC.hasTrivialCopyConstructor,
        CC.hasTrivialCopyConstructorForCall, CC.hasTrivialDefaultConstructor,
        CC.hasTrivialDestructor, CC.hasTrivialDestructorForCall, CC.hasTrivialMoveAssignment,
        CC.hasTrivialMoveConstructor, CC.hasTrivialMoveConstructorForCall,
        CC.hasUninitializedReferenceMember, CC.hasUserDeclaredConstructor,
        CC.hasUserDeclaredCopyAssignment, CC.hasUserDeclaredCopyConstructor,
        CC.hasUserDeclaredDestructor, CC.hasUserDeclaredMoveAssignment,
        CC.hasUserDeclaredMoveConstructor, CC.hasUserDeclaredMoveOperation,
        CC.hasUserProvidedDefaultConstructor, CC.hasVariantMembers, CC.isAbstract,
        CC.isAnyDestructorNoReturn, CC.isCXX11StandardLayout, CC.isCapturelessLambda,
        CC.isDependentLambda, CC.isEffectivelyFinal, CC.isInterfaceLike, CC.isLiteral,
        CC.isNeverDependentLambda, CC.isParsingBaseSpecifiers, CC.isPolymorphic,
        CC.isStandardLayout, CC.isStructural, CC.isTrivial, CC.isTriviallyCopyConstructible,
        CC.isTriviallyCopyable, CC.mayBeAbstract, CC.mayBeDynamicClass, CC.mayBeNonDynamicClass,
        CC.needsImplicitCopyAssignment, CC.needsImplicitCopyConstructor,
        CC.needsImplicitDefaultConstructor, CC.needsImplicitDestructor,
        CC.needsImplicitMoveAssignment, CC.needsImplicitMoveConstructor,
        CC.needsOverloadResolutionForCopyAssignment,
        CC.needsOverloadResolutionForCopyConstructor,
        CC.needsOverloadResolutionForDestructor,
        CC.needsOverloadResolutionForMoveAssignment,
        CC.needsOverloadResolutionForMoveConstructor]
    for p in boolpreds
        @test p(baseRD) isa Bool
        @test p(derivedRD) isa Bool
    end
    # a few meaningful values
    @test CC.isPolymorphic(baseRD)
    @test CC.isAbstract(baseRD)
    @test CC.isDynamicClass(baseRD)
    @test CC.hasUserDeclaredConstructor(baseRD)
    @test CC.hasUserDeclaredDestructor(baseRD)

    # defaulted-special-member predicates: only well-defined on a class whose
    # special members do not need overload resolution (Clang asserts otherwise),
    # so exercise them on a trivial struct.
    @test f(I, "Plain")
    plainRD = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.defaultedCopyConstructorIsDeleted(plainRD) isa Bool
    @test CC.defaultedDefaultConstructorIsConstexpr(plainRD) isa Bool
    @test CC.defaultedDestructorIsConstexpr(plainRD) isa Bool
    @test CC.defaultedDestructorIsDeleted(plainRD) isa Bool
    @test CC.defaultedMoveConstructorIsDeleted(plainRD) isa Bool

    # generic-lambda template parameter list (nullptr-safe on a non-lambda)
    @test CC.getGenericLambdaTemplateParameterList(baseRD) isa CC.TemplateParameterList
    glamClass = nothing
    for d in alldecls
        if d isa CC.CXXRecordDecl && CC.isGenericLambda(d)
            glamClass = d
            break
        end
    end
    if glamClass !== nothing
        @test CC.getGenericLambdaTemplateParameterList(glamClass) isa CC.TemplateParameterList
        @test CC.hasKnownLambdaInternalLinkage(glamClass) isa Bool
    end

    # ---- CXXRecordDecl: bases / methods / ctors counts + collections ----
    @test CC.getNumBases(derivedRD) isa Integer
    @test CC.getNumVBases(diamondRD) isa Integer
    @test CC.getNumMethods(baseRD) isa Integer
    @test CC.getNumCtors(baseRD) isa Integer

    bases = CC.getBases(derivedRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, bases)
    @test CC.getBase(derivedRD, 0) isa CC.CXXBaseSpecifier

    vbases = CC.getVBases(diamondRD)
    @test all(x -> x isa CC.CXXBaseSpecifier, vbases)
    if CC.getNumVBases(diamondRD) > 0
        @test CC.getVBase(diamondRD, 0) isa CC.CXXBaseSpecifier
    end

    methods = CC.getMethods(baseRD)
    @test all(m -> m isa CC.CXXMethodDecl, methods)
    ctors = CC.getCtors(baseRD)
    @test all(c -> c isa CC.CXXConstructorDecl, ctors)

    # ---- CXXBaseSpecifier accessors ----
    b0 = bases[1]
    @test CC.getAccessSpecifier(b0) isa Integer || CC.getAccessSpecifier(b0) isa Enum
    @test CC.getAccessSpecifierAsWritten(b0) isa Integer || CC.getAccessSpecifierAsWritten(b0) isa Enum
    @test CC.getBaseTypeLoc(b0) isa CC.SourceLocation
    @test CC.getEllipsisLoc(b0) isa CC.SourceLocation
    @test CC.getEndLoc(b0) isa CC.SourceLocation
    @test CC.getInheritConstructors(b0) isa Bool
    @test CC.getSourceRange(b0) isa CC.SourceRange
    @test CC.getType(b0) isa CC.QualType
    @test CC.getTypeSourceInfo(b0) isa CC.TypeSourceInfo
    @test CC.isBaseOfClass(b0) isa Bool
    @test CC.isPackExpansion(b0) isa Bool
    @test CC.isVirtual(b0) isa Bool
    # a virtual base specifier
    if !isempty(vbases)
        @test CC.isVirtual(vbases[1])
    end

    # ---- CXXMethodDecl accessors on every method ----
    for m in methods
        @test CC.getCanonicalDecl(m) isa CC.CXXMethodDecl
        @test CC.getMostRecentDecl(m) isa CC.CXXMethodDecl
        @test CC.getParent(m) isa CC.CXXRecordDecl
        @test CC.hasInlineBody(m) isa Bool
        @test CC.isConst(m) isa Bool
        @test CC.isCopyAssignmentOperator(m) isa Bool
        @test CC.isInstance(m) isa Bool
        @test CC.isLambdaStaticInvoker(m) isa Bool
        @test CC.isMoveAssignmentOperator(m) isa Bool
        @test CC.isStatic(m) isa Bool
        @test CC.isVirtual(m) isa Bool
        @test CC.isVolatile(m) isa Bool
        if CC.isInstance(m)
            @test CC.getThisType(m) isa CC.QualType
        end
    end

    # ---- CXXConstructorDecl / CXXDestructorDecl / CXXConversionDecl via resolve ----
    resolved = [CC.resolve(m) for m in methods]

    ctorPreds = [CC.isExplicit, CC.isDefaultConstructor, CC.isCopyConstructor,
        CC.isMoveConstructor, CC.isCopyOrMoveConstructor, CC.isDelegatingConstructor,
        CC.isInheritingConstructor, CC.isSpecializationCopyingObject]
    for c in ctors
        for p in ctorPreds
            @test p(c) isa Bool
        end
        @test CC.getNumCtorInitializers(c) isa Integer
    end
    @test any(CC.isDefaultConstructor, ctors)
    @test any(CC.isCopyConstructor, ctors)
    @test any(CC.isMoveConstructor, ctors)
    @test any(c -> CC.isCopyOrMoveConstructor(c), ctors)
    @test any(CC.isExplicit, ctors)

    dtor = first(m for m in resolved if m isa CC.CXXDestructorDecl)
    @test CC.getOperatorDelete(dtor) isa CC.FunctionDecl

    conv = first(m for m in resolved if m isa CC.CXXConversionDecl)
    @test CC.getConversionType(conv) isa CC.QualType
    @test CC.isExplicit(conv) isa Bool
    @test CC.isLambdaToBlockPointerConversion(conv) isa Bool

    # ---- CXXCtorInitializer via Derived's ctors ----
    dctors = CC.getCtors(derivedRD)
    initCtor = first(c for c in dctors if CC.getNumCtorInitializers(c) >= 2)
    inits = CC.getCtorInitializers(initCtor)
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    baseInit = first(i for i in inits if CC.isBaseInitializer(i))
    memInit = first(i for i in inits if CC.isMemberInitializer(i))
    @test CC.isBaseInitializer(baseInit)
    @test CC.isAnyMemberInitializer(baseInit) isa Bool
    @test CC.isDelegatingInitializer(baseInit) isa Bool
    @test CC.getBaseClass(baseInit) isa CC.Type_
    @test CC.getInit(baseInit) isa CC.Expr_
    @test CC.getSourceLocation(baseInit) isa CC.SourceLocation
    @test CC.isMemberInitializer(memInit)
    @test CC.isAnyMemberInitializer(memInit)
    @test CC.getMember(memInit) isa CC.FieldDecl
    @test CC.getName(CC.getMember(memInit)) == "d"

    # delegating constructor + its target + delegating initializer
    delegCtor = first(c for c in dctors if CC.isDelegatingConstructor(c))
    @test CC.getTargetConstructor(delegCtor) isa CC.CXXConstructorDecl
    dinits = CC.getCtorInitializers(delegCtor)
    @test any(CC.isDelegatingInitializer, dinits)

    # ---- AccessSpecDecl ----
    asd = first(d for d in alldecls if d isa CC.AccessSpecDecl)
    @test CC.getAccessSpecifierLoc(asd) isa CC.SourceLocation
    @test CC.getColonLoc(asd) isa CC.SourceLocation
    @test CC.getSourceRange(asd) isa CC.SourceRange

    # ---- LinkageSpecDecl (extern "C" { ... }) ----
    lsd = first(d for d in alldecls if d isa CC.LinkageSpecDecl)
    @test CC.getEndLoc(lsd) isa CC.SourceLocation
    @test CC.getExternLoc(lsd) isa CC.SourceLocation
    @test CC.getLanguage(lsd) isa Integer || CC.getLanguage(lsd) isa Enum
    @test CC.getRBraceLoc(lsd) isa CC.SourceLocation
    @test CC.getSourceRange(lsd) isa CC.SourceRange
    @test CC.hasBraces(lsd) isa Bool

    # ---- UsingDirectiveDecl (using namespace NS2;) ----
    udir = first(d for d in alldecls if d isa CC.UsingDirectiveDecl)
    @test CC.getNominatedNamespace(udir) isa CC.NamespaceDecl

    # ---- UsingDecl / BaseUsingDecl / UsingShadowDecl (using Base::bar;) ----
    usingD = first(d for d in alldecls if d isa CC.UsingDecl)
    @test CC.shadow_size(usingD) isa Integer
    shadows = CC.getShadows(usingD)
    @test all(s -> s isa CC.UsingShadowDecl, shadows)
    if !isempty(shadows)
        @test CC.getTargetDecl(shadows[1]) isa CC.NamedDecl
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
        @test CC.isExplicit(dg) isa Bool
        @test CC.getCorrespondingConstructor(dg) isa CC.CXXConstructorDecl
        @test CC.getDeducedTemplate(dg) isa CC.TemplateDecl
        @test CC.getDeductionCandidateKind(dg) isa Integer ||
              CC.getDeductionCandidateKind(dg) isa Enum
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

        gv = CC.VarDecl(look("dtl_gv").ptr)
        sv = CC.VarDecl(look("dtl_sv").ptr)
        fd = CC.FunctionDecl(look("dtl_fn").ptr)
        rd = CC.getDefinition(CC.RecordDecl(look("DtlRec").ptr))
        ed = CC.getDefinition(CC.EnumDecl(look("DtlEnum").ptr))
        nsvar = CC.VarDecl(look("NSA::INL::nsvar").ptr)

        # --- NamedDecl printing surface ---
        @test CC.getNameAsString(gv) == "dtl_gv"
        @test CC.getQualifiedNameAsString(gv) == "dtl_gv"
        @test CC.printName(gv) isa String
        @test CC.printNestedNameSpecifier(gv) isa String
        @test CC.getNameForDiagnostic(gv, true) isa String
        @test CC.getNameForDiagnostic(gv, false) isa String
        @test occursin("nsvar", CC.getQualifiedNameAsString(nsvar))
        @test occursin("NSA", CC.printNestedNameSpecifier(nsvar))

        # --- VarDecl: enum-returning and ASTContext-taking queries ---
        @test CC.getTLSKind(gv) isa CC.LibClangEx.CXVarDecl_TLSKind
        @test CC.getTLSKind(gv) == CC.LibClangEx.CXVarDecl_TLS_None
        @test CC.isThisDeclarationADefinition(gv, ctx) ==
              CC.LibClangEx.CXVarDecl_Definition
        @test CC.hasDefinition(gv, ctx) == CC.LibClangEx.CXVarDecl_Definition
        @test CC.getInitStyle(gv) == CC.LibClangEx.CXVarDecl_CInit
        CC.setInitStyle(sv, CC.LibClangEx.CXVarDecl_ListInit)
        @test CC.getInitStyle(sv) == CC.LibClangEx.CXVarDecl_ListInit
        CC.setInitStyle(sv, CC.LibClangEx.CXVarDecl_CInit)
        @test CC.getInitStyle(sv) == CC.LibClangEx.CXVarDecl_CInit
        @test CC.hasDependentAlignment(gv) isa Bool
        @test CC.checkForConstantInitialization(gv) isa Bool
        @test CC.evaluateDestruction(gv) isa Bool
        @test CC.hasFlexibleArrayInit(gv, ctx) isa Bool
        @test CC.getFlexibleArrayInitChars(gv, ctx) isa Integer
        @test CC.getMemberSpecializationInfo(gv) isa CC.MemberSpecializationInfo
        @test CC.getStorageClassSpecifierString(CC.LibClangEx.CXStorageClass_SC_Static) ==
              "static"
        # evaluateValue populates the cache that getEvaluatedValue reads back.
        CC.evaluateValue(gv)
        @test CC.getEvaluatedValue(gv) isa CC.APValue

        # --- ValueDecl / DeclaratorDecl levels reached through their carriers ---
        @test CC.isInitCapture(CC.ValueDecl(gv.ptr)) isa Bool
        @test CC.getPotentiallyDecomposedVarDecl(CC.ValueDecl(gv.ptr)) isa CC.VarDecl
        @test CC.getSourceRange(CC.DeclaratorDecl(gv.ptr)) isa CC.SourceRange

        # --- ParmVarDecl ---
        p0 = CC.getParamDecl(fd, 0)
        @test CC.getSourceRange(p0) isa CC.SourceRange
        @test CC.getMaxFunctionScopeDepth() isa Integer
        @test CC.isExplicitObjectParameter(p0) == false
        @test CC.getExplicitObjectParamThisLoc(p0) isa CC.SourceLocation

        # --- FunctionDecl bit-flag round-trips (restore what we flip) ---
        @test CC.getDefaultLoc(fd) isa CC.SourceLocation
        for (getter, setter) in ((CC.isIneligibleOrNotSelected,
                                  CC.setIneligibleOrNotSelected),
                                 (CC.BodyContainsImmediateEscalatingExpressions,
                                  CC.setBodyContainsImmediateEscalatingExpressions),
                                 (CC.FriendConstraintRefersToEnclosingTemplate,
                                  CC.setFriendConstraintRefersToEnclosingTemplate),
                                 (CC.UsesFPIntrin, CC.setUsesFPIntrin))
            old = getter(fd)
            @test old isa Bool
            setter(fd, !old)
            @test getter(fd) == !old
            setter(fd, old)
            @test getter(fd) == old
        end
        @test CC.isImmediateEscalating(fd) isa Bool
        @test CC.isImmediateFunction(fd) isa Bool
        @test CC.isMemberLikeConstrainedFriend(fd) isa Bool
        @test CC.isTargetClonesMultiVersion(fd) isa Bool

        # --- FunctionDecl parameter arithmetic ---
        @test CC.getNumParams(fd) == 2
        @test CC.hasCXXExplicitFunctionObjectParameter(fd) == false
        @test CC.getNumNonObjectParams(fd) == 2
        @test CC.getNonObjectParameter(fd, 0) isa CC.ParmVarDecl
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
        @test CC.getOverloadedOperator(fd) ==
              CC.LibClangEx.CXOverloadedOperatorKind_OO_None
        @test CC.getInstantiatedFromDecl(fd) isa CC.FunctionDecl

        # --- FieldDecl ---
        flds = CC.getFields(rd)
        @test length(flds) == 3
        @test CC.isPotentiallyOverlapping(flds[1]) isa Bool
        @test CC.hasNonNullInClassInitializer(flds[1]) == false
        @test CC.hasNonNullInClassInitializer(flds[3]) == true

        # --- TagDecl / EnumDecl / RecordDecl ---
        @test CC.isThisDeclarationADemotedDefinition(rd) == false
        @test CC.getSourceRange(ed) isa CC.SourceRange
        @test CC.getODRHash(rd) isa Integer
        @test CC.isRandomized(rd) isa Bool
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
            d isa CC.StaticAssertDecl && (sad = d; break)
        end
        @test sad !== nothing
        if sad !== nothing
            @test CC.isFailed(sad) == false
            @test CC.getAssertExpr(sad) isa CC.Expr_
            @test CC.getMessage(sad) isa CC.Expr_
            @test CC.getRParenLoc(sad) isa CC.SourceLocation
            @test CC.getSourceRange(sad) isa CC.SourceRange
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
        @test CC.getSourceRange(tls) isa CC.SourceRange
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
    rd = CC.CXXRecordDecl(CC.get_decl(f).ptr)
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
    vd = CC.VarDecl(CC.get_decl(f).ptr)
    lam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
    @test lam isa CC.CXXRecordDecl
    if lam.ptr != C_NULL && CC.isLambda(lam)
        @test CC.getLambdaCallOperator(lam) isa CC.CXXMethodDecl
        @test CC.getLambdaCallOperator(lam).ptr != C_NULL
        @test CC.getLambdaStaticInvoker(lam) isa CC.CXXMethodDecl
        # a non-generic lambda has no templated call operator
        @test CC.getDependentLambdaCallOperator(lam).ptr == C_NULL
        @test Int(CC.getLambdaCaptureDefault(lam)) == 0  # LCD_None
        @test CC.getLambdaManglingNumber(lam) isa Integer
        @test CC.getLambdaIndexInContext(lam) isa Integer
        @test CC.getLambdaContextDecl(lam) isa CC.Decl
        @test CC.getLambdaTypeInfo(lam) isa CC.TypeSourceInfo
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
    host = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "MemDerived")
    derived = CC.CXXRecordDecl(get_decl(f).ptr)
    @test f(I, "MemUnrelated")
    unrelated = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.hasDefinition(host)
    @test CC.hasDefinition(derived)

    # CXXRecordDecl's own getODRHash (it hides RecordDecl's); cached, so stable.
    h = CC.getODRHash(host)
    @test h isa Integer
    @test CC.getODRHash(host) == h

    @test CC.implicitCopyConstructorHasConstParam(host) isa Bool
    @test CC.implicitCopyAssignmentHasConstParam(host) isa Bool

    # base walk: MemDerived IS derived from MemHost, provably not from MemUnrelated
    @test !CC.isProvablyNotDerivedFrom(derived, host)
    @test CC.isProvablyNotDerivedFrom(derived, unrelated)

    # hasMemberName, directly and through a base; DeclarationNames are uniqued per
    # ASTContext, so the global `probe`'s name is the member's name too.
    @test f(I, "probe")
    nprobe = CC.getDeclName(CC.VarDecl(get_decl(f).ptr))
    @test f(I, "stranger")
    nstranger = CC.getDeclName(CC.VarDecl(get_decl(f).ptr))
    @test CC.hasMemberName(host, nprobe)
    @test CC.hasMemberName(derived, nprobe)
    @test !CC.hasMemberName(host, nstranger)

    # MergeAccess: static, mirrors clang's path/decl access lattice
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_public,
                         LCE.CXAccessSpecifier_AS_private) == LCE.CXAccessSpecifier_AS_none
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_public,
                         LCE.CXAccessSpecifier_AS_protected) ==
          LCE.CXAccessSpecifier_AS_protected
    @test CC.MergeAccess(LCE.CXAccessSpecifier_AS_protected,
                         LCE.CXAccessSpecifier_AS_public) ==
          LCE.CXAccessSpecifier_AS_protected

    # described class template, member specialization info, current instantiation
    @test f(I, "TmplHost")
    ctd = CC.ClassTemplateDecl(get_decl(f).ptr)
    pattern = CC.getTemplatedDecl(ctd)
    @test pattern isa CC.CXXRecordDecl
    dct = CC.getDescribedClassTemplate(pattern)
    @test dct isa CC.ClassTemplateDecl
    @test dct.ptr != C_NULL
    @test CC.getDescribedClassTemplate(host).ptr == C_NULL
    @test CC.getMemberSpecializationInfo(host) isa CC.MemberSpecializationInfo
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
        vd = CC.VarDecl(get_decl(f).ptr)
        lam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(vd)))
        @test lam isa CC.CXXRecordDecl
        (lam.ptr == C_NULL || !CC.isLambda(lam)) && continue
        @test CC.capture_size(lam) == ncap
        @test CC.getDeviceLambdaManglingNumber(lam) isa Integer
        @test CC.lambdaIsDefaultConstructibleAndAssignable(lam) isa Bool
        @test Int(CC.getLambdaDependencyKind(lam)) in (0, 1, 2)
        for i in 0:(CC.capture_size(lam) - 1)
            cap = CC.getCapture(lam, i)
            @test cap isa CC.LambdaCapture
            @test cap.ptr != C_NULL
            @test CC.capturesVariable(cap) isa Bool
        end
    end

    # a generic lambda has an invented template parameter list; before C++20 none
    # of its parameters are explicitly written
    @test f(I, "LamGeneric")
    gvd = CC.VarDecl(get_decl(f).ptr)
    glam = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(gvd)))
    if glam.ptr != C_NULL && CC.isGenericLambda(glam)
        n = CC.getNumLambdaExplicitTemplateParameters(glam)
        @test n isa Integer
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
    wid = CC.CXXRecordDecl(get_decl(f).ptr)
    widCtor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) >= 3)
    inits = CC.getCtorInitializers(widCtor)
    @test all(x -> x isa CC.CXXCtorInitializer, inits)

    baseInit = first(i for i in inits if CC.isBaseInitializer(i))
    @test CC.isBaseVirtual(baseInit) isa Bool
    @test CC.isBaseVirtual(baseInit) == false
    @test CC.getTypeSourceInfo(baseInit) isa CC.TypeSourceInfo
    @test CC.getSourceRange(baseInit) isa CC.SourceRange
    @test CC.getMemberLocation(baseInit) isa CC.SourceLocation
    @test CC.getEllipsisLoc(baseInit) isa CC.SourceLocation
    @test CC.getLParenLoc(baseInit) isa CC.SourceLocation
    @test CC.getRParenLoc(baseInit) isa CC.SourceLocation
    @test CC.isPackExpansion(baseInit) isa Bool
    @test CC.isInClassMemberInitializer(baseInit) isa Bool
    @test CC.isWritten(baseInit) isa Bool
    @test CC.getSourceOrder(baseInit) isa Integer

    memInit = first(i for i in inits if CC.isMemberInitializer(i))
    @test CC.isIndirectMemberInitializer(memInit) == false
    @test CC.getAnyMember(memInit) isa CC.FieldDecl
    @test CC.getName(CC.getAnyMember(memInit)) == "m"

    indInit = first(i for i in inits if CC.isIndirectMemberInitializer(i))
    @test CC.getIndirectMember(indInit) isa CC.IndirectFieldDecl
    @test CC.getAnyMember(indInit) isa CC.FieldDecl
    @test CC.getName(CC.getAnyMember(indInit)) == "aa"

    # ---- isBaseVirtual true for a virtual-base initializer ----
    @test f(I, "Der")
    der = CC.CXXRecordDecl(get_decl(f).ptr)
    derCtor = first(c for c in CC.getCtors(der) if CC.getNumCtorInitializers(c) >= 1)
    derBaseInit = first(i for i in CC.getCtorInitializers(derCtor) if CC.isBaseInitializer(i))
    @test CC.isBaseVirtual(derBaseInit) == true

    # ---- NamespaceAliasDecl (namespace alias = ns;) ----
    nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
    @test CC.getCanonicalDecl(nad) isa CC.NamespaceAliasDecl
    @test CC.getNamespace(nad) isa CC.NamespaceDecl
    @test CC.getAliasedNamespace(nad) isa CC.NamedDecl
    @test CC.getAliasLoc(nad) isa CC.SourceLocation
    @test CC.getNamespaceLoc(nad) isa CC.SourceLocation
    @test CC.getTargetNameLoc(nad) isa CC.SourceLocation
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
        mmd_rec = CC.CXXRecordDecl(get_decl(f).ptr)
        mmd = first(m for m in CC.getMethods(mmd_rec) if CC.getNameAsString(m) == "mmd")
        @test CC.isImplicitObjectMemberFunction(mmd) isa Bool
        @test CC.isImplicitObjectMemberFunction(mmd) == true
        @test CC.isExplicitObjectMemberFunction(mmd) isa Bool
        @test CC.isExplicitObjectMemberFunction(mmd) == false
        @test CC.size_overridden_methods(mmd) isa Integer
        @test CC.size_overridden_methods(mmd) == 0
        @test CC.getNumExplicitParams(mmd) isa Integer
        @test CC.getNumExplicitParams(mmd) == 1

        # ---- UsingDecl (from `using MBd::MBd;`) ----
        usingD = first(d for d in alldecls if d isa CC.UsingDecl)
        @test CC.getUsingLoc(usingD) isa CC.SourceLocation
        @test CC.getQualifier(usingD) isa CC.NestedNameSpecifier
        @test CC.isAccessDeclaration(usingD) isa Bool
        @test CC.isAccessDeclaration(usingD) == false
        @test CC.hasTypename(usingD) isa Bool
        @test CC.hasTypename(usingD) == false
        @test CC.getSourceRange(usingD) isa CC.SourceRange
        @test CC.getCanonicalDecl(usingD).ptr == usingD.ptr

        # ---- ConstructorUsingShadowDecl (the shadow of that using) ----
        cusd = first(d for d in alldecls if d isa CC.ConstructorUsingShadowDecl)
        intro = CC.getIntroducer(cusd)
        @test intro isa CC.UsingDecl
        @test intro.ptr == usingD.ptr
        @test CC.getParent(cusd) isa CC.CXXRecordDecl
        @test CC.getNominatedBaseClass(cusd) isa CC.CXXRecordDecl
        @test CC.getConstructedBaseClass(cusd) isa CC.CXXRecordDecl
        @test CC.constructsVirtualBase(cusd) isa Bool
        @test CC.constructsVirtualBase(cusd) == false
        # Direct-base inheritance: both shadow links are null, so assert only the carrier type.
        @test CC.getNominatedBaseClassShadowDecl(cusd) isa CC.ConstructorUsingShadowDecl
        @test CC.getConstructedBaseClassShadowDecl(cusd) isa CC.ConstructorUsingShadowDecl
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
        @test CC.getQualifier(udir) isa CC.NestedNameSpecifier
        @test CC.getNominatedNamespaceAsWritten(udir) isa CC.NamedDecl
        @test CC.getCommonAncestor(udir) isa CC.DeclContext
        @test CC.getUsingLoc(udir) isa CC.SourceLocation
        @test CC.getNamespaceKeyLocation(udir) isa CC.SourceLocation
        @test CC.getIdentLocation(udir) isa CC.SourceLocation
        @test CC.getSourceRange(udir) isa CC.SourceRange

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
        @test CC.getNextUsingShadowDecl(shadow) isa CC.UsingShadowDecl

        # ---- UnresolvedUsing{Value,Typename}Decl (using-decls over a dependent base) ----
        ctd = first(d for d in alldecls
                    if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUE")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test CC.getUsingLoc(uuv) isa CC.SourceLocation
        @test CC.isAccessDeclaration(uuv) isa Bool
        @test CC.isAccessDeclaration(uuv) == false
        @test CC.getQualifier(uuv) isa CC.NestedNameSpecifier
        @test CC.isPackExpansion(uuv) isa Bool
        @test CC.isPackExpansion(uuv) == false
        @test CC.getEllipsisLoc(uuv) isa CC.SourceLocation

        uut = first(d for d in members if d isa CC.UnresolvedUsingTypenameDecl)
        @test CC.getUsingLoc(uut) isa CC.SourceLocation
        @test CC.getTypenameLoc(uut) isa CC.SourceLocation
        @test CC.getQualifier(uut) isa CC.NestedNameSpecifier
        @test CC.isPackExpansion(uut) isa Bool
        @test CC.isPackExpansion(uut) == false
        @test CC.getEllipsisLoc(uut) isa CC.SourceLocation
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
        der = first(d for d in alldecls
                    if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "FDerF")
        members = CC.decls(CC.castToDeclContext(der))
        vf = first(d for d in members
                   if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "vf")
        cref = first(d for d in members
                     if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "cref")
        rref = first(d for d in members
                     if d isa CC.CXXMethodDecl && CC.getNameAsString(d) == "rref")

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
        @test CC.getMethodQualifiers(cref) isa Integer
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
        ector = first(d for d in members
                      if d isa CC.CXXConstructorDecl && CC.isExplicit(d))
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
        @test CC.getOperatorDeleteThisArg(dtor) isa CC.Expr_

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
            b = bindings[1]
            @test CC.getNameAsString(b) == "fbaF"
            vd = CC.getDecomposedDecl(b)
            @test vd isa CC.ValueDecl
            CC.setDecomposedDecl(b, vd)
            @test CC.getDecomposedDecl(b).ptr == vd.ptr
            @test CC.getHoldingVar(b) isa CC.VarDecl
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
        record_of(name) = CC.getAsCXXRecordDecl(CC.getTypePtr(CC.getType(first(d for d in alldecls
                                                                               if d isa CC.VarDecl &&
                                                                                  CC.getNameAsString(d) == name))))

        # ---- UsingEnumDecl (`using enum UEGColor;`) ----
        ued = first(d for d in alldecls if d isa CC.UsingEnumDecl)
        @test CC.getUsingLoc(ued) isa CC.SourceLocation
        @test CC.getEnumLoc(ued) isa CC.SourceLocation
        # 'using' and 'enum' are distinct tokens, so their encodings differ.
        @test CC.getUsingLoc(ued).ptr != CC.getEnumLoc(ued).ptr
        # The enumeration is named unqualified here: NULL-pointer carrier.
        @test CC.getQualifier(ued) isa CC.NestedNameSpecifier
        @test CC.getEnumType(ued) isa CC.TypeSourceInfo
        @test CC.getEnumType(ued).ptr != C_NULL
        @test CC.getEnumDecl(ued) isa CC.EnumDecl
        @test CC.getNameAsString(CC.getEnumDecl(ued)) == "UEGColor"
        @test CC.getSourceRange(ued) isa CC.SourceRange
        @test CC.getCanonicalDecl(ued) isa CC.UsingEnumDecl
        @test CC.getCanonicalDecl(ued).ptr == ued.ptr

        # ---- UsingPackDecl (the instantiated `using Ts::pfg...;`) ----
        upd = first(d for d in CC.decls(CC.castToDeclContext(record_of("pxg_inst")))
                    if d isa CC.UsingPackDecl)
        @test CC.getInstantiatedFromUsingDecl(upd) isa CC.NamedDecl
        @test CC.getInstantiatedFromUsingDecl(upd).ptr != C_NULL
        @test CC.getNumExpansions(upd) == 2
        @test CC.getExpansion(upd, 0) isa CC.NamedDecl
        exps = CC.getExpansions(upd)
        @test length(exps) == 2
        @test all(e -> e isa CC.NamedDecl && e.ptr != C_NULL, exps)
        @test CC.getSourceRange(upd) isa CC.SourceRange
        @test CC.getCanonicalDecl(upd) isa CC.UsingPackDecl
        @test CC.getCanonicalDecl(upd).ptr == upd.ptr

        # ---- MSPropertyDecl (`__declspec(property(...))`) ----
        msp = first(d for d in alldecls if d isa CC.MSPropertyDecl)
        @test CC.hasGetter(msp) isa Bool
        @test CC.hasGetter(msp)
        @test CC.hasSetter(msp) isa Bool
        @test CC.hasSetter(msp)
        @test CC.getGetterId(msp) isa CC.IdentifierInfo
        @test CC.getName(CC.getGetterId(msp)) == "GetXG"
        @test CC.getSetterId(msp) isa CC.IdentifierInfo
        @test CC.getName(CC.getSetterId(msp)) == "PutXG"

        # ---- CXXBaseSpecifier::getBeginLoc ----
        derg = record_of("derg_inst")
        @test CC.getNumBases(derg) == 1
        b0 = CC.getBase(derg, 0)
        @test CC.getBeginLoc(b0) isa CC.SourceLocation
        @test CC.getBeginLoc(b0).ptr == CC.getSourceRange(b0).begin_loc.ptr

        # ---- CXXCtorInitializer::getID (reproducible, per-object) ----
        dctor = first(c for c in CC.getCtors(derg) if CC.getNumCtorInitializers(c) >= 2)
        inits = CC.getCtorInitializers(dctor)
        @test CC.getID(inits[1], ctx) isa Integer
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
        @test all(c -> CC.isConvertingConstructor(c, true) isa Bool, cctors)
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
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_New) isa Bool
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_New) == true
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_Array_Delete) == true
        @test CC.isStaticOverloadedOperator(LXG.CXOverloadedOperatorKind_OO_Plus) == false

        # ---- CXXMethodDecl::isUsualDeallocationFunction (composite, PreventedBy dropped) ----
        dealloc = first(d for d in alldecls
                        if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "DeallocG")
        methods = CC.getMethods(dealloc)
        opdel = first(m for m in methods if CC.getNameAsString(m) == "operator delete")
        @test CC.isUsualDeallocationFunction(opdel) isa Bool
        plain = first(m for m in methods if CC.getNameAsString(m) == "plain")
        @test CC.isUsualDeallocationFunction(plain) == false

        # ---- CXXConstructorDecl: the two InheritedConstructor halves ----
        derived = first(d for d in alldecls
                        if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == "DerivedG")
        for c in CC.getCtors(derived)
            sh = CC.getInheritedConstructorShadowDecl(c)
            bc = CC.getInheritedConstructorBaseCtor(c)
            @test sh isa CC.ConstructorUsingShadowDecl
            @test bc isa CC.CXXConstructorDecl
            if CC.isInheritingConstructor(c)
                @test sh.ptr != C_NULL
                @test bc.ptr != C_NULL
                @test CC.getTargetDecl(sh) isa CC.NamedDecl
            else
                @test sh.ptr == C_NULL
                @test bc.ptr == C_NULL
            end
        end

        # ---- NamespaceAliasDecl: qualifier + own source range ----
        nad = first(d for d in alldecls if d isa CC.NamespaceAliasDecl)
        @test CC.getQualifier(nad) isa CC.NestedNameSpecifier
        # `namespace nsg_alias = NSGOuter::NSGInner;` names the target with a qualifier.
        @test CC.getQualifier(nad).ptr != C_NULL
        @test CC.getSourceRange(nad) isa CC.SourceRange

        # ---- LifetimeExtendedTemporaryDecl (namespace-scope const reference) ----
        f = DeclFinder(I)
        @test f(I, "g_refg")
        gref = CC.VarDecl(get_decl(f).ptr)
        mt = findg(CC.MaterializeTemporaryExpr, CC.resolve(CC.getInit(gref)))
        @test mt isa CC.MaterializeTemporaryExpr
        if mt !== nothing
            letd = CC.getLifetimeExtendedTemporaryDecl(mt)
            @test letd isa CC.LifetimeExtendedTemporaryDecl
            @test letd.ptr != C_NULL
            @test CC.getExtendingDecl(letd) isa CC.ValueDecl
            @test CC.getExtendingDecl(letd).ptr != C_NULL
            @test CC.getStorageDuration(letd) == LXG.CXStorageDuration_SD_Static
            @test CC.hasTemporaryExpr(letd) == true
            @test CC.getTemporaryExpr(letd) isa CC.Expr_
            @test CC.getTemporaryExpr(letd).ptr != C_NULL
            @test CC.getManglingNumber(letd) isa Integer
            cached = CC.getOrCreateValue(letd, true)
            @test cached isa CC.APValue
            @test cached.ptr != C_NULL
            @test CC.getValue(letd) isa CC.APValue
            @test CC.getValue(letd).ptr == cached.ptr
        end

        # ---- UnresolvedUsing{Value,Typename}Decl tails ----
        ctd = first(d for d in alldecls
                    if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUG")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test CC.getSourceRange(uuv) isa CC.SourceRange
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
        rec(name) = first(d for d in alldecls
                          if d isa CC.CXXRecordDecl && CC.getNameAsString(d) == name)

        # ---- CXXRecordDecl::getIndirectPrimaryBases (count + fill) ----
        # Whether MostI actually has one is an ABI decision (Itanium vs MS), so only the
        # shape is asserted; the empty case below is guaranteed on every ABI.
        most = rec("MostI")
        n = CC.getNumIndirectPrimaryBases(most)
        @test n isa Integer
        ipb = CC.getIndirectPrimaryBases(most)
        @test length(ipb) == n
        @test all(b -> b isa CC.CXXRecordDecl && b.ptr != C_NULL, ipb)
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
        @test CC.RequiresExprBodyDecl(rdc) isa CC.RequiresExprBodyDecl
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
        conv = first(d for d in CC.decls(CC.castToDeclContext(rec("ConvI")))
                     if d isa CC.CXXConversionDecl)
        @test CC.getCanonicalDecl(conv) isa CC.CXXConversionDecl
        @test CC.getCanonicalDecl(conv).ptr == conv.ptr

        # ---- UsingDirectiveDecl::getQualifierRange (qualified and unqualified) ----
        udirs = [d for d in alldecls if d isa CC.UsingDirectiveDecl]
        qual_udir = first(d for d in udirs if CC.getQualifier(d).ptr != C_NULL)
        plain_udir = first(d for d in udirs if CC.getQualifier(d).ptr == C_NULL)
        @test CC.getQualifierRange(qual_udir) isa CC.SourceRange
        @test CC.getQualifierRange(qual_udir).begin_loc.ptr != C_NULL
        # `using namespace NSITop;` writes no nested-name-specifier: an invalid range.
        @test CC.getQualifierRange(plain_udir) isa CC.SourceRange
        @test CC.getQualifierRange(plain_udir).begin_loc.ptr == C_NULL

        # ---- NamespaceAliasDecl::getQualifierRange ----
        @test CC.getQualifierRange(nad) isa CC.SourceRange
        @test CC.getQualifierRange(nad).begin_loc.ptr != C_NULL

        # ---- UsingDecl: qualifier range + name info ----
        ud = first(d for d in alldecls if d isa CC.UsingDecl)
        @test CC.getQualifierRange(ud) isa CC.SourceRange
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
        ctd = first(d for d in alldecls
                    if d isa CC.ClassTemplateDecl && CC.getNameAsString(d) == "UUI")
        members = CC.decls(CC.castToDeclContext(CC.getTemplatedDecl(ctd)))

        uuv = first(d for d in members if d isa CC.UnresolvedUsingValueDecl)
        @test CC.getQualifierRange(uuv) isa CC.SourceRange
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
        @test CC.getQualifierRange(uut) isa CC.SourceRange
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
