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
