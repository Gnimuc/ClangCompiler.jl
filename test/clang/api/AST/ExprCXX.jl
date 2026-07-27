using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "LambdaExpr captures" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "auto get_lambda(int cap) { return [cap]() { return cap; }; }")
    @test f(I, "get_lambda")
    fn = CC.FunctionDecl(get_decl(f).ptr)
    le = _find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn)))
    @test le isa CC.LambdaExpr
    @test CC.isGenericLambda(le) == false
    @test CC.getNumCaptures(le) == 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.capturesVariable(cap)
    @test !CC.capturesThis(cap)
    @test CC.getCaptureKind(cap) == CC.LibClangEx.CXLambdaCaptureKind_LCK_ByCopy
    dispose(f)
    dispose(I)
end

@testset "LambdaExpr/CXXConstructExpr/CXXNewExpr details" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = create_interpreter(String[])
    f = DeclFinder(I)
    src = """
    struct Pt { int x; Pt(int v) : x(v) {} };
    int use_capture(int cap) { auto l = [cap]() { return cap; }; return l(); }
    int use_default(int cap) { auto l = [=]() { return cap; }; return l(); }
    int use_explicit() { auto l = [](int a) -> int { return a; }; return l(1); }
    Pt make_pt(int v) { return Pt(v); }
    int *make_new() { return new int(3); }
    """
    CC.parse(I, src)

    @test f(I, "use_capture")
    fn = CC.FunctionDecl(get_decl(f).ptr)
    le = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn)))
    @test le isa CC.LambdaExpr
    @test CC.getCaptureDefault(le) == CC.LibClangEx.CXLambdaCaptureDefault_LCD_None
    @test CC.getCaptureDefaultLoc(le) isa CC.SourceLocation
    @test CC.getIntroducerRange(le) isa CC.SourceRange
    @test CC.hasExplicitParameters(le) isa Bool
    @test CC.hasExplicitResultType(le) == false
    @test CC.getCompoundStmtBody(le) isa CC.CompoundStmt
    @test CC.getTemplateParameterList(le) isa CC.TemplateParameterList
    @test CC.getDependentCallOperator(le) isa CC.FunctionTemplateDecl
    @test CC.getTrailingRequiresClause(le) isa CC.Expr_
    @test CC.getNumCaptures(le) == 1
    @test CC.getCaptureInit(le, 0) isa CC.Expr_
    @test CC.isInitCapture(le, CC.getCapture(le, 0)) == false

    @test f(I, "use_default")
    fn_d = CC.FunctionDecl(get_decl(f).ptr)
    le_d = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn_d)))
    @test le_d isa CC.LambdaExpr
    @test CC.getCaptureDefault(le_d) == CC.LibClangEx.CXLambdaCaptureDefault_LCD_ByCopy

    @test f(I, "use_explicit")
    fn_e = CC.FunctionDecl(get_decl(f).ptr)
    le_e = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn_e)))
    @test le_e isa CC.LambdaExpr
    @test CC.hasExplicitParameters(le_e) == true
    @test CC.hasExplicitResultType(le_e) == true
    @test CC.getNumCaptures(le_e) == 0

    @test f(I, "make_pt")
    fn2 = CC.FunctionDecl(get_decl(f).ptr)
    ce = find_node(CC.AbstractCXXConstructExpr, CC.resolve(CC.getBody(fn2)))
    @test ce isa CC.AbstractCXXConstructExpr
    @test CC.getParenOrBraceRange(ce) isa CC.SourceRange
    @test CC.getNumArgs(ce) >= 1
    if ce isa CC.CXXTemporaryObjectExpr
        @test CC.getTypeSourceInfo(ce) isa CC.TypeSourceInfo
    end

    @test f(I, "make_new")
    fn3 = CC.FunctionDecl(get_decl(f).ptr)
    ne = find_node(CC.CXXNewExpr, CC.resolve(CC.getBody(fn3)))
    @test ne isa CC.CXXNewExpr
    @test CC.getNumPlacementArgs(ne) == 0
    @test CC.getDirectInitRange(ne) isa CC.SourceRange
    @test CC.getTypeIdParens(ne) isa CC.SourceRange

    dispose(f)
    dispose(I)
end

@testset "ExprCXX payloads" begin
    I = CC.create_interpreter(String[])
    CC.parse(I, """
    struct CCTmp { CCTmp(); ~CCTmp(); int v; };
    struct CCAgg { int a; int b = 9; };
    int cc_def_arg(int a = 3);
    double cc_cast(int x) { return static_cast<double>(x); }
    void cc_throw() { throw 42; }
    bool cc_trait() { return __is_trivial(int); }
    int cc_use_default() { return cc_def_arg(); }
    int cc_temp() { return CCTmp().v; }
    int cc_agg() { return CCAgg{1}.b; }
    template <class... Ts> int cc_pack() { return sizeof...(Ts); }
    template <class... Ts> int cc_fold(Ts... ts) { return (0 + ... + ts); }
    """)
    f = CC.DeclFinder(I)

    # depth-first search for the first resolved node whose carrier is `T`
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end
    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f).ptr)))
    end
    function tpl_body(name)
        @test f(I, name)
        # a function-template name can resolve to several decls (the template
        # plus any instantiation), so take the template explicitly
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # CXXNamedCastExpr: cast keyword spelling + angle-bracket range
    sc = find_node(CC.CXXStaticCastExpr, fn_body("cc_cast"))
    @test sc isa CC.CXXStaticCastExpr
    if sc !== nothing
        @test CC.getCastName(sc) == "static_cast"
        ab = CC.getAngleBrackets(sc)
        @test ab isa CC.SourceRange
        @test ab.begin_loc.ptr != C_NULL
    end

    # CXXThrowExpr
    th = find_node(CC.CXXThrowExpr, fn_body("cc_throw"))
    @test th isa CC.CXXThrowExpr
    if th !== nothing
        @test CC.getThrowLoc(th) isa CC.SourceLocation
        sub = CC.getSubExpr(th)
        @test sub isa CC.Expr_
        @test sub.ptr != C_NULL          # `throw 42;` has an operand
    end

    # TypeTraitExpr
    tt = find_node(CC.TypeTraitExpr, fn_body("cc_trait"))
    @test tt isa CC.TypeTraitExpr
    if tt !== nothing
        @test CC.getNumArgs(tt) == 1
        @test CC.getValue(tt) isa Bool
        arg = CC.getArg(tt, 0)
        @test arg isa CC.TypeSourceInfo
        @test arg.ptr != C_NULL
        @test_throws AssertionError CC.getArg(tt, 1)   # Invariant 3: bounds
    end

    # CXXDefaultArgExpr
    da = find_node(CC.CXXDefaultArgExpr, fn_body("cc_use_default"))
    @test da isa CC.CXXDefaultArgExpr
    if da !== nothing
        p = CC.getParam(da)
        @test p isa CC.ParmVarDecl
        @test CC.get_name(p) == "a"
        @test CC.getExpr(da).ptr != C_NULL
    end

    # CXXBindTemporaryExpr / ExprWithCleanups
    tmpb = fn_body("cc_temp")
    bt = find_node(CC.CXXBindTemporaryExpr, tmpb)
    @test bt isa CC.CXXBindTemporaryExpr
    if bt !== nothing
        @test CC.getSubExpr(bt).ptr != C_NULL
    end
    ewc = find_node(CC.ExprWithCleanups, tmpb)
    if ewc !== nothing
        @test CC.getNumObjects(ewc) isa Integer
        @test CC.cleanupsHaveSideEffects(ewc) isa Bool
    end

    # CXXDefaultInitExpr (aggregate init filling in the default member initializer)
    di = find_node(CC.CXXDefaultInitExpr, fn_body("cc_agg"))
    if di !== nothing
        fd = CC.getField(di)
        @test fd isa CC.FieldDecl
        @test CC.get_name(fd) == "b"
        @test CC.getExpr(di).ptr != C_NULL
    end

    # SizeOfPackExpr / CXXFoldExpr live in uninstantiated template bodies
    sp = find_node(CC.SizeOfPackExpr, tpl_body("cc_pack"))
    @test sp isa CC.SizeOfPackExpr
    if sp !== nothing
        @test CC.getPack(sp).ptr != C_NULL
        @test CC.isPartiallySubstituted(sp) isa Bool
    end

    fe = find_node(CC.CXXFoldExpr, tpl_body("cc_fold"))
    @test fe isa CC.CXXFoldExpr
    if fe !== nothing
        @test CC.getPattern(fe).ptr != C_NULL
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX tail: UDL / scalar value-init / nullptr" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    src = """
    int operator"" _k(unsigned long long v) { return (int)v; }
    int use_udl() { return 3_k; }
    int use_svi() { return int(); }
    void *use_null() { return nullptr; }
    """
    CC.parse(I, src)

    @test f(I, "use_udl")
    fn = CC.FunctionDecl(CC.get_decl(f).ptr)
    udl = find_node(CC.UserDefinedLiteral, CC.resolve(CC.getBody(fn)))
    @test udl isa CC.UserDefinedLiteral
    @test CC.getLiteralOperatorKind(udl) == CC.LibClangEx.CXUserDefinedLiteral_LOK_Integer
    @test CC.getCookedLiteral(udl) isa CC.Expr_
    ii = CC.getUDSuffix(udl)
    @test ii isa CC.IdentifierInfo
    @test CC.isStr(ii, "_k")

    @test f(I, "use_svi")
    fn2 = CC.FunctionDecl(CC.get_decl(f).ptr)
    svi = find_node(CC.CXXScalarValueInitExpr, CC.resolve(CC.getBody(fn2)))
    @test svi isa CC.CXXScalarValueInitExpr
    @test CC.getTypeSourceInfo(svi) isa CC.TypeSourceInfo
    @test CC.getRParenLoc(svi) isa CC.SourceLocation

    @test f(I, "use_null")
    fn3 = CC.FunctionDecl(CC.get_decl(f).ptr)
    np = find_node(CC.CXXNullPtrLiteralExpr, CC.resolve(CC.getBody(fn3)))
    @test np isa CC.CXXNullPtrLiteralExpr
    @test CC.getLocation(np) isa CC.SourceLocation
    @test CC.isValid(CC.getLocation(np))

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX subclasses: noexcept/pseudo-dtor/unresolved-ctor/pack/dependent" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    CC.parse(I, """
    typedef int CCInt;
    bool cc_noexcept(int x) { return noexcept(x + 1); }
    void cc_pdtor(CCInt *p) { p->~CCInt(); }
    template <class T> T cc_uctor(int a) { return T(a); }
    template <class T> int cc_dsdre() { return T::value; }
    template <class F, class... Ts> void cc_pexp(F fn, Ts... ts) { fn(ts...); }
    """)

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f).ptr)))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # CXXNoexceptExpr - the noexcept(expr) operator
    ne = find_node(CC.CXXNoexceptExpr, fn_body("cc_noexcept"))
    @test ne isa CC.CXXNoexceptExpr
    @test CC.getValue(ne) isa Bool
    @test CC.getOperand(ne).ptr != C_NULL

    # CXXPseudoDestructorExpr - p->~CCInt() on a scalar typedef
    pd = find_node(CC.CXXPseudoDestructorExpr, fn_body("cc_pdtor"))
    @test pd isa CC.CXXPseudoDestructorExpr
    @test CC.getBase(pd).ptr != C_NULL
    @test CC.isArrow(pd) == true
    @test CC.hasQualifier(pd) isa Bool
    @test CC.getOperatorLoc(pd) isa CC.SourceLocation
    @test CC.getTildeLoc(pd) isa CC.SourceLocation
    @test CC.getDestroyedType(pd) isa CC.QualType

    # CXXUnresolvedConstructExpr - dependent T(a) in an uninstantiated template
    uc = find_node(CC.CXXUnresolvedConstructExpr, tpl_body("cc_uctor"))
    @test uc isa CC.CXXUnresolvedConstructExpr
    @test CC.getNumArgs(uc) == 1
    @test CC.getArg(uc, 0).ptr != C_NULL
    @test_throws AssertionError CC.getArg(uc, 1)   # Invariant 3: index bounds
    @test CC.getTypeAsWritten(uc) isa CC.QualType
    @test CC.isListInitialization(uc) == false
    @test CC.getLParenLoc(uc) isa CC.SourceLocation
    @test CC.getRParenLoc(uc) isa CC.SourceLocation

    # DependentScopeDeclRefExpr - T::value in an uninstantiated template
    ds = find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_dsdre"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test CC.getLocation(ds) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(ds) == false
    @test CC.hasExplicitTemplateArgs(ds) == false
    @test CC.getNumTemplateArgs(ds) == 0

    # PackExpansionExpr - the ts... argument of a dependent call
    pe = find_node(CC.PackExpansionExpr, tpl_body("cc_pexp"))
    @test pe isa CC.PackExpansionExpr
    @test CC.getPattern(pe).ptr != C_NULL
    @test CC.getEllipsisLoc(pe) isa CC.SourceLocation

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX: OverloadExpr / UnresolvedLookupExpr / UnresolvedMemberExpr" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    CC.parse(I, """
    int cc_oo(int);
    int cc_oo(double);
    template <class T> int cc_ule(T t) { return cc_oo(t); }
    struct CCBase { void m(int); void m(double); };
    // Explicit-access UnresolvedMemberExpr needs a NON-dependent base object with a
    // dependent call argument: `s.m(u)` where s is CCBase and u is dependent. (A
    // `this->m(u)` on a dependent `this` builds a CXXDependentScopeMemberExpr instead.)
    template <class T> void cc_gg(T u) { CCBase s; s.m(u); }
    template <class T> struct CCS {
        void m(int);
        void m(double);
        void icall(T u) { m(u); }
    };
    """)

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # ---- UnresolvedLookupExpr: overloaded free-function call with a dependent arg ----
    ule = find_node(CC.UnresolvedLookupExpr, tpl_body("cc_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    @test CC.isOverloaded(ule) == true
    @test CC.requiresADL(ule) isa Bool
    # OverloadExpr base surface dispatches on the UnresolvedLookupExpr carrier
    @test CC.getNumDecls(ule) >= 1
    @test CC.getName(ule) isa CC.DeclarationName
    @test CC.getNameLoc(ule) isa CC.SourceLocation
    @test CC.getQualifier(ule) isa CC.NestedNameSpecifier
    @test CC.getTemplateKeywordLoc(ule) isa CC.SourceLocation
    @test CC.getLAngleLoc(ule) isa CC.SourceLocation
    @test CC.getRAngleLoc(ule) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(ule) == false
    @test CC.hasExplicitTemplateArgs(ule) == false
    @test CC.getNumTemplateArgs(ule) == 0
    @test CC.getNamingClass(ule) isa CC.CXXRecordDecl

    # ---- UnresolvedMemberExpr, explicit access: `s.m(u)` in cc_gg ----
    ume = find_node(CC.UnresolvedMemberExpr, tpl_body("cc_gg"))
    @test ume isa CC.UnresolvedMemberExpr
    @test CC.isImplicitAccess(ume) == false
    @test CC.isArrow(ume) == false          # accessed with `.`, not `->`
    @test CC.getBaseType(ume) isa CC.QualType
    @test CC.hasUnresolvedUsing(ume) isa Bool
    @test CC.getOperatorLoc(ume) isa CC.SourceLocation
    @test CC.getBase(ume) isa CC.Expr_
    @test CC.getBase(ume).ptr != C_NULL
    # OverloadExpr base surface still dispatches on the UnresolvedMemberExpr carrier
    @test CC.getNumDecls(ume) >= 1
    @test CC.getName(ume) isa CC.DeclarationName
    @test CC.getNamingClass(ume) isa CC.CXXRecordDecl

    # ---- UnresolvedMemberExpr, implicit access: bare `m(u)` in CCS::icall ----
    # getBase()'s precondition must fail (Invariant 3).
    @test f(I, "CCS")
    ct = CC.ClassTemplateDecl(CC.get_decl(f).ptr)
    rec = CC.getTemplatedDecl(ct)
    icall = nothing
    for d in CC.decls(CC.castToDeclContext(rec))
        d isa CC.CXXMethodDecl && CC.get_name(d) == "icall" && (icall = d)
    end
    @test icall isa CC.CXXMethodDecl
    ume_i = find_node(CC.UnresolvedMemberExpr, CC.resolve(CC.getBody(icall)))
    @test ume_i isa CC.UnresolvedMemberExpr
    @test CC.isImplicitAccess(ume_i) == true
    @test_throws AssertionError CC.getBase(ume_i)

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX-d: fold / sizeof-pack / throw / operator-call / member-call" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
    struct CCS2 { CCS2 &operator=(const CCS2 &); bool operator<(const CCS2 &) const; };
    struct CCS3 { int m() const; };
    void ccd_assign(CCS2 a, CCS2 b) { a = b; }
    bool ccd_cmp(CCS2 a, CCS2 b) { return a < b; }
    int ccd_mcall(CCS3 t) { return t.m(); }
    void ccd_throw() { throw 42; }
    template <class... Ts> int ccd_pack() { return sizeof...(Ts); }
    template <class... Ts> int ccd_fold(Ts... ts) { return (0 + ... + ts); }
    """)

    # depth-first search for the first resolved node whose carrier is `T`
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end
    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f).ptr)))
    end
    function tpl_body(name)
        @test f(I, name)
        # a function-template name can resolve to several decls; take the template
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # CXXOperatorCallExpr: assignment vs comparison classification
    oa = find_node(CC.CXXOperatorCallExpr, fn_body("ccd_assign"))
    @test oa isa CC.CXXOperatorCallExpr
    if oa !== nothing
        @test CC.isAssignmentOp(oa) == true
        @test CC.isComparisonOp(oa) == false
    end
    oc = find_node(CC.CXXOperatorCallExpr, fn_body("ccd_cmp"))
    @test oc isa CC.CXXOperatorCallExpr
    if oc !== nothing
        @test CC.isComparisonOp(oc) == true
        @test CC.isAssignmentOp(oc) == false
    end

    # CXXMemberCallExpr: the type of the object the member function is called on
    mc = find_node(CC.CXXMemberCallExpr, fn_body("ccd_mcall"))
    @test mc isa CC.CXXMemberCallExpr
    if mc !== nothing
        ot = CC.getObjectType(mc)
        @test ot isa CC.QualType
        @test ot.ptr != C_NULL
    end

    # CXXThrowExpr: NRVO scope flag (host-decided; assert shape only)
    th = find_node(CC.CXXThrowExpr, fn_body("ccd_throw"))
    @test th isa CC.CXXThrowExpr
    if th !== nothing
        @test CC.isThrownVariableInScope(th) isa Bool
    end

    # SizeOfPackExpr: source locations + the value-dependent precondition guard
    sp = find_node(CC.SizeOfPackExpr, tpl_body("ccd_pack"))
    @test sp isa CC.SizeOfPackExpr
    if sp !== nothing
        @test CC.getOperatorLoc(sp) isa CC.SourceLocation
        @test CC.getPackLoc(sp) isa CC.SourceLocation
        @test CC.getRParenLoc(sp) isa CC.SourceLocation
        # uninstantiated => value-dependent => getPackLength precondition fires
        @test CC.isValueDependent(sp) == true
        @test_throws AssertionError CC.getPackLength(sp)
    end

    # CXXFoldExpr: `(0 + ... + ts)` is a binary left fold (init `0` op ... op pack `ts`)
    fe = find_node(CC.CXXFoldExpr, tpl_body("ccd_fold"))
    @test fe isa CC.CXXFoldExpr
    if fe !== nothing
        @test CC.isLeftFold(fe) == true
        @test CC.isRightFold(fe) == false
        @test CC.getOperator(fe) == CC.LibClangEx.CXBinaryOperatorKind_BO_Add
        @test CC.getCallee(fe) isa CC.UnresolvedLookupExpr
        @test CC.getLHS(fe).ptr != C_NULL          # init operand `0`
        @test CC.getRHS(fe).ptr != C_NULL          # pattern operand `ts`
        @test CC.getInit(fe).ptr != C_NULL         # left fold => init is the LHS
        @test CC.getLParenLoc(fe) isa CC.SourceLocation
        @test CC.getRParenLoc(fe) isa CC.SourceLocation
        @test CC.getEllipsisLoc(fe) isa CC.SourceLocation
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX default-init/temporary/trait payloads" begin
    I = CC.create_interpreter(String[])
    CC.parse(I, """
    struct EXTmp { EXTmp(); ~EXTmp(); int v; };
    struct EXAgg { int a; int b = 7; };
    struct EXBase { virtual ~EXBase(); };
    struct EXDerived : EXBase { int d; };
    int ex_def_arg(int a = 5);
    int ex_take_ref(const int &q);
    int ex_use_default() { return ex_def_arg(); }
    int ex_agg() { return EXAgg{1}.b; }
    int ex_bind_temp() { return EXTmp().v; }
    double ex_functional(int x) { return double(x); }
    EXDerived *ex_dyn(EXBase *b) { return dynamic_cast<EXDerived *>(b); }
    int ex_materialize() { return ex_take_ref(41); }
    unsigned ex_array_rank() { return __array_rank(int[3][4]); }
    unsigned ex_array_extent() { return __array_extent(int[3][4], 1); }
    bool ex_lvalue_expr(int x) { return __is_lvalue_expr(x); }
    """)
    f = CC.DeclFinder(I)

    # depth-first search for the first resolved node whose carrier is `T`
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end
    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f).ptr)))
    end

    # CXXDefaultArgExpr: rewritten-init flag + the context the default was used in
    da = find_node(CC.CXXDefaultArgExpr, fn_body("ex_use_default"))
    @test da isa CC.CXXDefaultArgExpr
    if da !== nothing
        @test CC.hasRewrittenInit(da) isa Bool
        rw = CC.getRewrittenExpr(da)
        @test rw isa CC.Expr_
        @test (rw.ptr != C_NULL) == CC.hasRewrittenInit(da)
        uc = CC.getUsedContext(da)
        @test uc isa CC.DeclContext
        @test uc.ptr != C_NULL
    end

    # CXXDefaultInitExpr: getRewrittenExpr is assert-guarded (Invariant 3)
    di = find_node(CC.CXXDefaultInitExpr, fn_body("ex_agg"))
    @test di isa CC.CXXDefaultInitExpr
    if di !== nothing
        @test CC.hasRewrittenInit(di) isa Bool
        @test CC.getUsedContext(di) isa CC.DeclContext
        @test CC.getUsedContext(di).ptr != C_NULL
        if CC.hasRewrittenInit(di)
            @test CC.getRewrittenExpr(di).ptr != C_NULL
        else
            @test_throws AssertionError CC.getRewrittenExpr(di)
        end
    end

    # CXXBindTemporaryExpr -> CXXTemporary -> the destructor it will run
    bt = find_node(CC.CXXBindTemporaryExpr, fn_body("ex_bind_temp"))
    @test bt isa CC.CXXBindTemporaryExpr
    if bt !== nothing
        tmp = CC.getTemporary(bt)
        @test tmp isa CC.CXXTemporary
        @test tmp.ptr != C_NULL
        dtor = CC.getDestructor(tmp)
        @test dtor isa CC.CXXDestructorDecl
        @test dtor.ptr != C_NULL
    end

    # CXXFunctionalCastExpr: `double(x)` is paren-written, not list-initialized
    fc = find_node(CC.CXXFunctionalCastExpr, fn_body("ex_functional"))
    @test fc isa CC.CXXFunctionalCastExpr
    if fc !== nothing
        @test CC.isListInitialization(fc) == false
        @test CC.getLParenLoc(fc) isa CC.SourceLocation
        @test CC.getRParenLoc(fc) isa CC.SourceLocation
        @test CC.getLParenLoc(fc).ptr != C_NULL
    end

    # CXXDynamicCastExpr: a downcast to a reachable derived class is not always null
    dc = find_node(CC.CXXDynamicCastExpr, fn_body("ex_dyn"))
    @test dc isa CC.CXXDynamicCastExpr
    if dc !== nothing
        @test CC.isAlwaysNull(dc) == false
    end

    # MaterializeTemporaryExpr: a temporary bound to a const-ref parameter
    mt = find_node(CC.MaterializeTemporaryExpr, fn_body("ex_materialize"))
    @test mt isa CC.MaterializeTemporaryExpr
    if mt !== nothing
        @test CC.getStorageDuration(mt) isa CC.LibClangEx.CXStorageDuration
    end

    # ArrayTypeTraitExpr: __array_rank has no dimension operand
    ar = find_node(CC.ArrayTypeTraitExpr, fn_body("ex_array_rank"))
    @test ar isa CC.ArrayTypeTraitExpr
    if ar !== nothing
        @test CC.getTrait(ar) == CC.LibClangEx.CXArrayTypeTrait_ATT_ArrayRank
        @test CC.getQueriedType(ar) isa CC.QualType
        @test CC.getValue(ar) == 2
        @test CC.getDimensionExpression(ar).ptr == C_NULL
    end

    # ArrayTypeTraitExpr: __array_extent carries one
    ae = find_node(CC.ArrayTypeTraitExpr, fn_body("ex_array_extent"))
    @test ae isa CC.ArrayTypeTraitExpr
    if ae !== nothing
        @test CC.getTrait(ae) == CC.LibClangEx.CXArrayTypeTrait_ATT_ArrayExtent
        @test CC.getValue(ae) == 4
        dim = CC.getDimensionExpression(ae)
        @test dim isa CC.Expr_
        @test dim.ptr != C_NULL
    end

    # ExpressionTraitExpr: a named parameter is an lvalue
    et = find_node(CC.ExpressionTraitExpr, fn_body("ex_lvalue_expr"))
    @test et isa CC.ExpressionTraitExpr
    if et !== nothing
        @test CC.getTrait(et) == CC.LibClangEx.CXExpressionTrait_ET_IsLValueExpr
        @test CC.getValue(et) == true
        @test CC.getQueriedExpression(et).ptr != C_NULL
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "CXXTypeidExpr/CXXPseudoDestructorExpr/CXXInheritedCtorInitExpr/NTTP subst" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    function collect_calls(x, acc)
        x isa CC.CallExpr && push!(acc, x)
        for c in CC.children(x)
            collect_calls(CC.resolve(c), acc)
        end
        return acc
    end

    I = create_interpreter(String[])
    f = DeclFinder(I)
    src = """
    namespace std { class type_info { public: virtual ~type_info(); }; }
    struct TidB { virtual ~TidB(); };
    const std::type_info &tid_type() { return typeid(int); }
    const std::type_info &tid_expr(TidB &b) { return typeid(b); }
    typedef int PdInt;
    void pd_plain(PdInt *p) { p->~PdInt(); }
    void pd_qual(PdInt *p) { p->PdInt::~PdInt(); }
    struct IcBase { IcBase(int); };
    struct IcDer : IcBase { using IcBase::IcBase; };
    void ic_use() { IcDer d(1); }
    template <int N> int nttp_one() { return N + 1; }
    template <int... Ns> int nttp_pack() { return (0 + ... + Ns); }
    int nttp_call() { return nttp_one<7>() + nttp_pack<3, 4>(); }
    """
    CC.parse(I, src)
    ctx = CC.getASTContext(CC.get_instance(I))

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f).ptr)))
    end

    # CXXTypeidExpr - typeid(int): the type-operand arm of the operand union
    tt = find_node(CC.CXXTypeidExpr, fn_body("tid_type"))
    @test tt isa CC.CXXTypeidExpr
    @test CC.isTypeOperand(tt) == true
    @test CC.isPotentiallyEvaluated(tt) isa Bool
    @test CC.getTypeOperand(tt, ctx) isa CC.QualType
    @test CC.getTypeOperand(tt, ctx).ptr != C_NULL
    @test_throws AssertionError CC.isMostDerived(tt, ctx)   # Invariant 3

    # CXXTypeidExpr - typeid(b): the expression-operand arm
    te = find_node(CC.CXXTypeidExpr, fn_body("tid_expr"))
    @test te isa CC.CXXTypeidExpr
    @test CC.isTypeOperand(te) == false
    @test CC.isPotentiallyEvaluated(te) isa Bool
    @test CC.isMostDerived(te, ctx) isa Bool
    @test_throws AssertionError CC.getTypeOperand(te, ctx)  # Invariant 3

    # CXXPseudoDestructorExpr - unqualified p->~PdInt() on a scalar typedef
    pp = find_node(CC.CXXPseudoDestructorExpr, fn_body("pd_plain"))
    @test pp isa CC.CXXPseudoDestructorExpr
    @test CC.hasQualifier(pp) == false
    @test CC.getQualifier(pp).ptr == C_NULL
    @test CC.getScopeTypeInfo(pp).ptr == C_NULL
    @test CC.getColonColonLoc(pp) isa CC.SourceLocation
    # the destroyed-type storage is a union: resolved -> TypeSourceInfo, dependent
    # and unresolved -> identifier. PdInt resolves, so the identifier arm is NULL.
    @test CC.getDestroyedTypeInfo(pp).ptr != C_NULL
    @test CC.getDestroyedTypeIdentifier(pp).ptr == C_NULL
    @test CC.getDestroyedTypeLoc(pp) isa CC.SourceLocation

    # CXXPseudoDestructorExpr - p->PdInt::~PdInt(): a scalar cannot be part of a
    # nested-name-specifier, so the qualification lands in the scope type instead.
    pq = find_node(CC.CXXPseudoDestructorExpr, fn_body("pd_qual"))
    @test pq isa CC.CXXPseudoDestructorExpr
    @test CC.hasQualifier(pq) == false
    @test CC.getScopeTypeInfo(pq) isa CC.TypeSourceInfo
    @test CC.getColonColonLoc(pq) isa CC.SourceLocation
    @test CC.getQualifier(pq) isa CC.NestedNameSpecifier

    # CXXInheritedCtorInitExpr - reached through the inheriting constructor's
    # sole ctor-initializer
    ce = find_node(CC.CXXConstructExpr, fn_body("ic_use"))
    @test ce isa CC.CXXConstructExpr
    ctor = CC.getConstructor(ce)
    @test CC.isInheritingConstructor(ctor) == true
    @test CC.getNumCtorInitializers(ctor) == 1
    ice = CC.resolve(CC.getInit(CC.getCtorInitializer(ctor, 0)))
    @test ice isa CC.CXXInheritedCtorInitExpr
    @test CC.constructsVBase(ice) == false
    @test CC.getConstructionKind(ice) ==
          CC.LibClangEx.CXCXXConstructionKind_NonVirtualBase
    @test CC.inheritedFromVBase(ice) isa Bool
    @test CC.getLocation(ice) isa CC.SourceLocation

    # SubstNonTypeTemplateParmExpr - only the *instantiated* callee body holds one,
    # so cross from the call site through getDirectCallee.
    calls = collect_calls(fn_body("nttp_call"), Any[])
    @test length(calls) == 2
    seen = Dict{String,Any}()
    for c in calls
        callee = CC.getDirectCallee(c)
        @test CC.hasBody(callee) == true
        s = find_node(CC.SubstNonTypeTemplateParmExpr, CC.resolve(CC.getBody(callee)))
        @test s isa CC.SubstNonTypeTemplateParmExpr
        seen[CC.getNameAsString(callee)] = s
    end
    @test sort(collect(keys(seen))) == ["nttp_one", "nttp_pack"]
    for (_, s) in seen
        @test CC.getNameLoc(s) isa CC.SourceLocation
        @test CC.getReplacement(s) isa CC.Expr_
        @test CC.getReplacement(s).ptr != C_NULL
        @test CC.getAssociatedDecl(s) isa CC.Decl
        @test CC.getAssociatedDecl(s).ptr != C_NULL
        @test CC.getIndex(s) == 0            # the sole template parameter
        @test CC.getParameter(s) isa CC.NonTypeTemplateParmDecl
        @test CC.getParameter(s).ptr != C_NULL
        @test CC.isReferenceParameter(s) == false
        @test CC.getParameterType(s, ctx) isa CC.QualType
        @test CC.getParameterType(s, ctx).ptr != C_NULL
        pi = CC.getPackIndex(s)
        @test pi === nothing || pi isa Unsigned
    end
    # `template <int N>` is not a pack, so its substitution carries no pack index
    @test CC.getPackIndex(seen["nttp_one"]) === nothing

    dispose(f)
    dispose(I)
end

@testset "ExprCXX tail: rewritten ops / used locations / pack counts / coroutines" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    CC.parse(I, """
    struct GEq { int v; bool operator==(const GEq &) const; };
    bool g_rewritten(GEq a, GEq b) { return a != b; }
    struct GOp { int v; };
    bool operator==(const GOp &a, const GOp &b);
    bool g_infix(GOp a, GOp b) { return a == b; }
    consteval int g_imm() { return 7; }
    int g_def_imm(int a = g_imm());
    int g_use_imm() { return g_def_imm(); }
    int g_def_plain(int a = 5);
    int g_use_plain() { return g_def_plain(); }
    struct GAgg { int a; int b = 7; };
    int g_agg() { return GAgg{1}.b; }
    unsigned long long operator""_gx(unsigned long long v);
    unsigned long long g_udl() { return 12_gx; }
    unsigned g_rank() { return __array_rank(int[3][4]); }
    struct GLife { int a; };
    const GLife &g_ref = GLife{2};
    template <class... Ts> int g_sink(Ts...);
    template <class... Ts> int g_pexp(Ts... ts) { return g_sink(ts...); }
    template <class... Ts> int g_fold(Ts... ts) { return (0 + ... + ts); }
    template <class T> auto g_uctor(T a) { return T(a); }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f).ptr)))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # CXXOperatorCallExpr: `a == b` on a non-member operator== is written infix
    oc = find_node(CC.CXXOperatorCallExpr, fn_body("g_infix"))
    @test oc isa CC.CXXOperatorCallExpr
    if oc !== nothing
        @test CC.isInfixBinaryOp(oc) == true
    end

    # CXXRewrittenBinaryOperator: C++20 rewrites `a != b` into `!(a == b)`, so the
    # rewritten node is a comparison and never an assignment
    rb = find_node(CC.CXXRewrittenBinaryOperator, fn_body("g_rewritten"))
    @test rb isa CC.CXXRewrittenBinaryOperator
    if rb !== nothing
        @test CC.getOpcode(rb) == CC.LibClangEx.CXBinaryOperatorKind_BO_NE
        @test CC.isComparisonOp(rb) == true
        @test CC.isAssignmentOp(rb) == false
        @test CC.getOperatorLoc(rb) isa CC.SourceLocation
        @test CC.getOperatorLoc(rb).ptr != C_NULL
    end

    # CXXDefaultArgExpr: a plain default argument has no rewritten form, so the
    # adjusted accessor is assert-guarded (Invariant 3)
    dp = find_node(CC.CXXDefaultArgExpr, fn_body("g_use_plain"))
    @test dp isa CC.CXXDefaultArgExpr
    if dp !== nothing
        @test CC.getUsedLocation(dp) isa CC.SourceLocation
        @test CC.getUsedLocation(dp).ptr != C_NULL
        if CC.hasRewrittenInit(dp)
            @test CC.getAdjustedRewrittenExpr(dp).ptr != C_NULL
        else
            @test_throws AssertionError CC.getAdjustedRewrittenExpr(dp)
        end
    end

    # CXXDefaultArgExpr: a default argument holding an immediate call does
    da = find_node(CC.CXXDefaultArgExpr, fn_body("g_use_imm"))
    @test da isa CC.CXXDefaultArgExpr
    if da !== nothing && CC.hasRewrittenInit(da)
        adj = CC.getAdjustedRewrittenExpr(da)
        @test adj isa CC.Expr_
        @test adj.ptr != C_NULL
    end

    # CXXDefaultInitExpr: the location the in-class initializer was used at
    di = find_node(CC.CXXDefaultInitExpr, fn_body("g_agg"))
    @test di isa CC.CXXDefaultInitExpr
    if di !== nothing
        @test CC.getUsedLocation(di) isa CC.SourceLocation
        @test CC.getUsedLocation(di).ptr != C_NULL
    end

    # UserDefinedLiteral: the ud-suffix location
    udl = find_node(CC.UserDefinedLiteral, fn_body("g_udl"))
    @test udl isa CC.UserDefinedLiteral
    if udl !== nothing
        @test CC.getUDSuffixLoc(udl) isa CC.SourceLocation
        @test CC.getUDSuffixLoc(udl).ptr != C_NULL
    end

    # ArrayTypeTraitExpr: the queried type is reachable through its TypeSourceInfo
    at = find_node(CC.ArrayTypeTraitExpr, fn_body("g_rank"))
    @test at isa CC.ArrayTypeTraitExpr
    if at !== nothing
        tsi = CC.getQueriedTypeSourceInfo(at)
        @test tsi isa CC.TypeSourceInfo
        @test tsi.ptr != C_NULL
        @test CC.getType(tsi) isa CC.QualType
    end

    # MaterializeTemporaryExpr: a namespace-scope const reference extends the
    # temporary's lifetime, so the state holds a LifetimeExtendedTemporaryDecl
    @test f(I, "g_ref")
    ginit = CC.resolve(CC.getInit(CC.VarDecl(get_decl(f).ptr)))
    mt = find_node(CC.MaterializeTemporaryExpr, ginit)
    @test mt isa CC.MaterializeTemporaryExpr
    if mt !== nothing
        letd = CC.getLifetimeExtendedTemporaryDecl(mt)
        @test letd isa CC.LifetimeExtendedTemporaryDecl
        @test letd.ptr != C_NULL
        @test CC.isUsableInConstantExpressions(mt, ctx) isa Bool
        v = CC.getOrCreateValue(mt, true)
        @test v isa CC.APValue
        @test v.ptr != C_NULL
    end

    # PackExpansionExpr / CXXFoldExpr: an uninstantiated template body knows no
    # expansion count, so the C++ optional comes back disengaged
    pe = find_node(CC.PackExpansionExpr, tpl_body("g_pexp"))
    @test pe isa CC.PackExpansionExpr
    if pe !== nothing
        npe = CC.getNumExpansions(pe)
        @test npe === nothing || npe isa Unsigned
    end

    fe = find_node(CC.CXXFoldExpr, tpl_body("g_fold"))
    @test fe isa CC.CXXFoldExpr
    if fe !== nothing
        nfe = CC.getNumExpansions(fe)
        @test nfe === nothing || nfe isa Unsigned
    end

    # CXXUnresolvedConstructExpr: the dependent `T(a)` names its type through a
    # TypeSourceInfo
    uc = find_node(CC.CXXUnresolvedConstructExpr, tpl_body("g_uctor"))
    @test uc isa CC.CXXUnresolvedConstructExpr
    if uc !== nothing
        utsi = CC.getTypeSourceInfo(uc)
        @test utsi isa CC.TypeSourceInfo
        @test utsi.ptr != C_NULL
    end

    dispose(f)
    dispose(I)

    # Coroutines need a promise type, so the awaitable machinery is spelled out
    J = create_interpreter(["-std=c++20"])
    g = DeclFinder(J)
    CC.parse(J, """
    namespace std {
    template <class Ret, class... Args> struct coroutine_traits {
        using promise_type = typename Ret::promise_type;
    };
    template <class Promise = void> struct coroutine_handle;
    template <> struct coroutine_handle<void> {
        static coroutine_handle from_address(void *) noexcept { return {}; }
    };
    template <class Promise> struct coroutine_handle {
        operator coroutine_handle<>() const noexcept { return {}; }
        static coroutine_handle from_address(void *) noexcept { return {}; }
        static coroutine_handle from_promise(Promise &) noexcept { return {}; }
    };
    struct suspend_always {
        bool await_ready() const noexcept { return false; }
        void await_suspend(coroutine_handle<>) const noexcept {}
        void await_resume() const noexcept {}
    };
    }
    struct gtask {
        struct promise_type {
            gtask get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    gtask g_coro() {
        co_await std::suspend_always{};
        co_return;
    }
    template <class A> gtask g_tcoro(A a) {
        co_await a;
        co_return;
    }
    """)

    # CoawaitExpr / CoroutineSuspendExpr in a resolved coroutine
    @test g(J, "g_coro")
    croot = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(g).ptr)))
    ca = find_node(CC.CoawaitExpr, croot)
    @test ca isa CC.CoawaitExpr
    if ca !== nothing
        @test CC.isImplicit(ca) isa Bool
        @test CC.getOpaqueValue(ca) isa CC.OpaqueValueExpr
    end

    # DependentCoawaitExpr: `co_await a` on a dependent operand keeps the operand
    # and the operator co_await lookup side by side
    @test g(J, "g_tcoro")
    tftd = CC.FunctionTemplateDecl(first(CC.get_decls(g)).ptr)
    tbody = CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(tftd).ptr)))
    dca = find_node(CC.DependentCoawaitExpr, tbody)
    @test dca isa CC.DependentCoawaitExpr
    if dca !== nothing
        @test CC.getOperand(dca) isa CC.Expr_
        @test CC.getOperand(dca).ptr != C_NULL
        lookup = CC.getOperatorCoawaitLookup(dca)
        @test lookup isa CC.UnresolvedLookupExpr
        @test lookup.ptr != C_NULL
        @test CC.getKeywordLoc(dca) isa CC.SourceLocation
        @test CC.getKeywordLoc(dca).ptr != C_NULL
    end

    dispose(g)
    dispose(J)
end

@testset "ExprCXX: CXXDependentScopeMemberExpr / DependentScopeDeclRefExpr qualifiers" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    CC.parse(I, """
    struct CCDQB { int qm; };
    template <class T> int cc_dsme(T t) { return t.value; }
    template <class T> int cc_dsme_q(T t) { return t.CCDQB::qm; }
    template <class T> int cc_dsme_tpl(T t) { return t.template get<int>(); }
    template <class T> int cc_dsdref() { return T::value; }
    """)

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # ---- plain dependent member access: `t.value` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    @test CC.isImplicitAccess(dsme) == false
    @test CC.getBase(dsme) isa CC.Expr_
    @test CC.getBase(dsme).ptr != C_NULL
    @test CC.getBaseType(dsme) isa CC.QualType
    @test CC.isArrow(dsme) == false          # accessed with `.`, not `->`
    @test CC.getOperatorLoc(dsme) isa CC.SourceLocation
    @test CC.getMember(dsme) isa CC.DeclarationName
    @test CC.getMemberLoc(dsme) isa CC.SourceLocation
    @test CC.getQualifier(dsme) isa CC.NestedNameSpecifier
    @test CC.getQualifier(dsme).ptr == C_NULL   # `t.value` carries no `::`
    @test CC.getFirstQualifierFoundInScope(dsme) isa CC.NamedDecl
    @test CC.hasTemplateKeyword(dsme) == false
    @test CC.hasExplicitTemplateArgs(dsme) == false
    @test CC.getNumTemplateArgs(dsme) == 0
    @test CC.getTemplateKeywordLoc(dsme) isa CC.SourceLocation
    @test CC.getLAngleLoc(dsme) isa CC.SourceLocation
    @test CC.getRAngleLoc(dsme) isa CC.SourceLocation

    # ---- qualified dependent member access: `t.CCDQB::qm` ----
    dsme_q = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme_q"))
    @test dsme_q isa CC.CXXDependentScopeMemberExpr
    @test CC.getQualifier(dsme_q).ptr != C_NULL
    @test CC.getFirstQualifierFoundInScope(dsme_q) isa CC.NamedDecl

    # ---- `template`-keyword member access: `t.template get<int>()` ----
    dsme_t = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme_tpl"))
    @test dsme_t isa CC.CXXDependentScopeMemberExpr
    @test CC.hasTemplateKeyword(dsme_t) == true
    @test CC.hasExplicitTemplateArgs(dsme_t) == true
    @test CC.getNumTemplateArgs(dsme_t) == 1

    # ---- DependentScopeDeclRefExpr tail: `T::value` ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_dsdref"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test CC.getDeclName(ds) isa CC.DeclarationName
    @test CC.getQualifier(ds) isa CC.NestedNameSpecifier
    @test CC.getQualifier(ds).ptr != C_NULL     # the `T::` is always written
    @test CC.getTemplateKeywordLoc(ds) isa CC.SourceLocation
    @test CC.getLAngleLoc(ds) isa CC.SourceLocation
    @test CC.getRAngleLoc(ds) isa CC.SourceLocation

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX-i: construct/this/literal setters + overload & template-arg indexing" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    CC.parse(I, """
    struct CCIA { int v; CCIA(int x) : v(x) {} };
    CCIA cci_make(int v) { CCIA a(v); return a; }
    struct CCIB { int w; int get() { return this->w; } };
    bool cci_flag() { return true; }
    int *cci_null() { return nullptr; }
    int cci_oo(int);
    int cci_oo(double);
    template <class U> int cci_tf(U);
    template <class U> int cci_tf(U, U);
    template <class T> int cci_ule(T t) { return cci_oo(t); }
    template <class T> int cci_ule_targ(T t) { return cci_tf<int>(t); }
    template <class T> int cci_dsme_tpl(T t) { return t.template get<int>(); }
    template <class T> int cci_dsdref_tpl() { return T::template g<int>(); }
    """)

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f).ptr)))
    end

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)).ptr)
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd).ptr)))
    end

    # ---- CXXConstructExpr setters, each round-tripped against its own getter ----
    ce = _find_node(CC.AbstractCXXConstructExpr, fn_body("cci_make"))
    @test ce isa CC.AbstractCXXConstructExpr

    for (setter, getter) in ((CC.setElidable, CC.isElidable),
                             (CC.setHadMultipleCandidates, CC.hadMultipleCandidates),
                             (CC.setListInitialization, CC.isListInitialization),
                             (CC.setStdInitListInitialization, CC.isStdInitListInitialization),
                             (CC.setRequiresZeroInitialization, CC.requiresZeroInitialization),
                             (CC.setIsImmediateEscalating, CC.isImmediateEscalating))
        saved = getter(ce)
        setter(ce, true)
        @test getter(ce) == true
        setter(ce, false)
        @test getter(ce) == false
        setter(ce, saved)          # leave the node exactly as parsed
        @test getter(ce) == saved
    end

    saved_kind = CC.getConstructionKind(ce)
    CC.setConstructionKind(ce, CC.LibClangEx.CXCXXConstructionKind_VirtualBase)
    @test CC.getConstructionKind(ce) == CC.LibClangEx.CXCXXConstructionKind_VirtualBase
    CC.setConstructionKind(ce, saved_kind)
    @test CC.getConstructionKind(ce) == saved_kind

    ce_loc = CC.getLocation(ce)
    CC.setLocation(ce, ce_loc)
    @test CC.getLocation(ce).ptr == ce_loc.ptr

    ce_range = CC.getParenOrBraceRange(ce)
    CC.setParenOrBraceRange(ce, ce_range)
    @test CC.getParenOrBraceRange(ce).begin_loc.ptr == ce_range.begin_loc.ptr
    @test CC.getParenOrBraceRange(ce).end_loc.ptr == ce_range.end_loc.ptr

    nargs = CC.getNumArgs(ce)
    @test nargs >= 1                       # CCIA(int)
    a0 = CC.getArg(ce, 0)
    CC.setArg(ce, 0, a0)
    @test CC.getArg(ce, 0).ptr == a0.ptr
    @test_throws AssertionError CC.setArg(ce, nargs, a0)

    # ---- CXXThisExpr setters: `this->w` inside CCIB::get ----
    @test f(I, "CCIB")
    rd = CC.CXXRecordDecl(CC.get_decl(f).ptr)
    getter_method = nothing
    for d in CC.decls(CC.castToDeclContext(rd))
        d isa CC.CXXMethodDecl && CC.get_name(d) == "get" && (getter_method = d)
    end
    @test getter_method isa CC.CXXMethodDecl
    te = _find_node(CC.CXXThisExpr, CC.resolve(CC.getBody(getter_method)))
    @test te isa CC.CXXThisExpr
    @test CC.isImplicit(te) == false        # written out as `this->w`
    CC.setImplicit(te, true)
    @test CC.isImplicit(te) == true
    CC.setImplicit(te, false)
    @test CC.isImplicit(te) == false
    te_loc = CC.getLocation(te)
    CC.setLocation(te, te_loc)
    @test CC.getLocation(te).ptr == te_loc.ptr

    # ---- CXXBoolLiteralExpr setters ----
    ble = _find_node(CC.CXXBoolLiteralExpr, fn_body("cci_flag"))
    @test ble isa CC.CXXBoolLiteralExpr
    @test CC.getValue(ble) == true
    CC.setValue(ble, false)
    @test CC.getValue(ble) == false
    CC.setValue(ble, true)
    @test CC.getValue(ble) == true
    ble_loc = CC.getLocation(ble)
    CC.setLocation(ble, ble_loc)
    @test CC.getLocation(ble).ptr == ble_loc.ptr

    # ---- CXXNullPtrLiteralExpr setter ----
    npe = _find_node(CC.CXXNullPtrLiteralExpr, fn_body("cci_null"))
    @test npe isa CC.CXXNullPtrLiteralExpr
    npe_loc = CC.getLocation(npe)
    CC.setLocation(npe, npe_loc)
    @test CC.getLocation(npe).ptr == npe_loc.ptr

    # ---- OverloadExpr: indexed access to the unresolved lookup set ----
    ule = _find_node(CC.UnresolvedLookupExpr, tpl_body("cci_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    ndecls = CC.getNumDecls(ule)
    @test ndecls >= 2                       # cci_oo(int) and cci_oo(double)
    for i in 0:(ndecls - 1)
        @test CC.getDecl(ule, i) isa CC.NamedDecl
        @test CC.getDecl(ule, i).ptr != C_NULL
        @test CC.getDeclAccess(ule, i) isa CC.LibClangEx.CXAccessSpecifier
    end
    @test_throws AssertionError CC.getDecl(ule, ndecls)
    @test_throws AssertionError CC.getDeclAccess(ule, ndecls)
    # no explicit template argument list -> getTemplateArgs() is NULL upstream, so
    # the bounds assert must reject every index
    @test CC.getNumTemplateArgs(ule) == 0
    @test_throws AssertionError CC.getTemplateArg(ule, 0)

    ule_t = _find_node(CC.UnresolvedLookupExpr, tpl_body("cci_ule_targ"))
    @test ule_t isa CC.UnresolvedLookupExpr
    @test CC.hasExplicitTemplateArgs(ule_t) == true
    @test CC.getNumTemplateArgs(ule_t) == 1
    @test CC.getTemplateArg(ule_t, 0) isa CC.TemplateArgumentLoc
    @test CC.getTemplateArg(ule_t, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(ule_t, 1)

    # ---- CXXDependentScopeMemberExpr: `t.template get<int>()` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cci_dsme_tpl"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    @test CC.getNumTemplateArgs(dsme) == 1
    @test CC.getTemplateArg(dsme, 0) isa CC.TemplateArgumentLoc
    @test CC.getTemplateArg(dsme, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(dsme, 1)

    # ---- DependentScopeDeclRefExpr: `T::template g<int>()` ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cci_dsdref_tpl"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test CC.hasTemplateKeyword(ds) == true
    @test CC.getNumTemplateArgs(ds) == 1
    @test CC.getTemplateArg(ds, 0) isa CC.TemplateArgumentLoc
    @test CC.getTemplateArg(ds, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(ds, 1)

    CC.dispose(f)
    CC.dispose(I)
end
