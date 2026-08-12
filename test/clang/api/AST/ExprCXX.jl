using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

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

@testset "LambdaExpr captures" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "auto get_lambda(int cap) { return [cap]() { return cap; }; }")
    @test f(I, "get_lambda")
    fn = CC.FunctionDecl(get_decl(f))
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
    fn = CC.FunctionDecl(get_decl(f))
    le = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn)))
    @test le isa CC.LambdaExpr
    @test CC.getCaptureDefault(le) == CC.LibClangEx.CXLambdaCaptureDefault_LCD_None
    @test CC.is_null_handle(CC.getCaptureDefaultLoc(le))
    let r = CC.getIntroducerRange(le)
        @test CC.isValid(r)
        @test r.begin_loc.ptr != C_NULL
        @test r.end_loc.ptr != C_NULL
    end
    @test CC.hasExplicitParameters(le)
    @test CC.hasExplicitResultType(le) == false
    @test !CC.is_null_handle(CC.getCompoundStmtBody(le))
    @test CC.is_null_handle(CC.getTemplateParameterList(le))
    @test CC.is_null_handle(CC.getDependentCallOperator(le))
    @test CC.is_null_handle(CC.getTrailingRequiresClause(le))
    @test CC.getNumCaptures(le) == 1
    @test !CC.is_null_handle(CC.getCaptureInit(le, 0))
    @test CC.isInitCapture(le, CC.getCapture(le, 0)) == false

    @test f(I, "use_default")
    fn_d = CC.FunctionDecl(get_decl(f))
    le_d = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn_d)))
    @test le_d isa CC.LambdaExpr
    @test CC.getCaptureDefault(le_d) == CC.LibClangEx.CXLambdaCaptureDefault_LCD_ByCopy

    @test f(I, "use_explicit")
    fn_e = CC.FunctionDecl(get_decl(f))
    le_e = find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn_e)))
    @test le_e isa CC.LambdaExpr
    @test CC.hasExplicitParameters(le_e) == true
    @test CC.hasExplicitResultType(le_e) == true
    @test CC.getNumCaptures(le_e) == 0

    @test f(I, "make_pt")
    fn2 = CC.FunctionDecl(get_decl(f))
    ce = find_node(CC.AbstractCXXConstructExpr, CC.resolve(CC.getBody(fn2)))
    @test ce isa CC.AbstractCXXConstructExpr
    let r = CC.getParenOrBraceRange(ce)
        @test CC.isValid(r)
        @test r.begin_loc.ptr != C_NULL
        @test r.end_loc.ptr != C_NULL
    end
    @test CC.getNumArgs(ce) == 1
    if ce isa CC.CXXTemporaryObjectExpr
        let tsi = CC.getTypeSourceInfo(ce)
            @test tsi isa CC.TypeSourceInfo
            @test tsi.ptr != C_NULL
            @test CC.getAsString(CC.getType(tsi)) == "struct Pt" || CC.getAsString(CC.getType(tsi)) == "Pt"
        end
    end

    @test f(I, "make_new")
    fn3 = CC.FunctionDecl(get_decl(f))
    ne = find_node(CC.CXXNewExpr, CC.resolve(CC.getBody(fn3)))
    @test ne isa CC.CXXNewExpr
    @test CC.getNumPlacementArgs(ne) == 0
    let r = CC.getDirectInitRange(ne)
        @test CC.isValid(r)
        @test r.begin_loc.ptr != C_NULL
        @test r.end_loc.ptr != C_NULL
    end
    let r = CC.getTypeIdParens(ne)
        @test !CC.isValid(r)
        @test CC.is_null_handle(r.begin_loc)
    end

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
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        # a function-template name can resolve to several decls (the template
        # plus any instantiation), so take the template explicitly
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # CXXNamedCastExpr: cast keyword spelling + angle-bracket range
    sc = find_node(CC.CXXStaticCastExpr, fn_body("cc_cast"))
    @test sc isa CC.CXXStaticCastExpr
    if sc !== nothing
        @test CC.getCastName(sc) == "static_cast"
        let ab = CC.getAngleBrackets(sc)
            @test CC.isValid(ab)
            @test ab.begin_loc.ptr != C_NULL
            @test ab.end_loc.ptr != C_NULL
        end
    end

    # CXXThrowExpr
    th = find_node(CC.CXXThrowExpr, fn_body("cc_throw"))
    @test th isa CC.CXXThrowExpr
    if th !== nothing
        @test !CC.is_null_handle(CC.getThrowLoc(th))
        sub = CC.getSubExpr(th)
        @test CC.getStmtClassName(sub) == "IntegerLiteral"
        @test sub.ptr != C_NULL          # `throw 42;` has an operand
    end

    # TypeTraitExpr
    tt = find_node(CC.TypeTraitExpr, fn_body("cc_trait"))
    @test tt isa CC.TypeTraitExpr
    if tt !== nothing
        @test CC.getNumArgs(tt) == 1
        @test CC.getValue(tt) == true
        arg = CC.getArg(tt, 0)
        @test arg isa CC.TypeSourceInfo
        @test arg.ptr != C_NULL
        @test CC.getAsString(CC.getType(arg)) == "int"
        @test_throws AssertionError CC.getArg(tt, 1)   # Invariant 3: bounds
    end

    # CXXDefaultArgExpr
    da = find_node(CC.CXXDefaultArgExpr, fn_body("cc_use_default"))
    @test da isa CC.CXXDefaultArgExpr
    if da !== nothing
        p = CC.getParam(da)
        @test p isa CC.ParmVarDecl
        @test p.ptr != C_NULL
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
        @test CC.getNumObjects(ewc) == 0
        @test CC.cleanupsHaveSideEffects(ewc)
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
        @test !(CC.isPartiallySubstituted(sp))
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
    fn = CC.FunctionDecl(CC.get_decl(f))
    udl = find_node(CC.UserDefinedLiteral, CC.resolve(CC.getBody(fn)))
    @test udl isa CC.UserDefinedLiteral
    @test CC.getLiteralOperatorKind(udl) == CC.LibClangEx.CXUserDefinedLiteral_LOK_Integer
    @test !CC.is_null_handle(CC.getCookedLiteral(udl))
    ii = CC.getUDSuffix(udl)
    @test ii isa CC.IdentifierInfo
    @test CC.isStr(ii, "_k")

    @test f(I, "use_svi")
    fn2 = CC.FunctionDecl(CC.get_decl(f))
    svi = find_node(CC.CXXScalarValueInitExpr, CC.resolve(CC.getBody(fn2)))
    @test svi isa CC.CXXScalarValueInitExpr
    @test !CC.is_null_handle(CC.getTypeSourceInfo(svi))
    @test !CC.is_null_handle(CC.getRParenLoc(svi))

    @test f(I, "use_null")
    fn3 = CC.FunctionDecl(CC.get_decl(f))
    np = find_node(CC.CXXNullPtrLiteralExpr, CC.resolve(CC.getBody(fn3)))
    @test np isa CC.CXXNullPtrLiteralExpr
    @test !CC.is_null_handle(CC.getLocation(np))
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
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # CXXNoexceptExpr - the noexcept(expr) operator
    ne = find_node(CC.CXXNoexceptExpr, fn_body("cc_noexcept"))
    @test ne isa CC.CXXNoexceptExpr
    @test CC.getValue(ne) == true
    @test CC.getOperand(ne).ptr != C_NULL

    # CXXPseudoDestructorExpr - p->~CCInt() on a scalar typedef
    pd = find_node(CC.CXXPseudoDestructorExpr, fn_body("cc_pdtor"))
    @test pd isa CC.CXXPseudoDestructorExpr
    @test CC.getBase(pd).ptr != C_NULL
    @test CC.isArrow(pd) == true
    @test !(CC.hasQualifier(pd))
    @test !CC.is_null_handle(CC.getOperatorLoc(pd))
    @test !CC.is_null_handle(CC.getTildeLoc(pd))
    @test !CC.is_null_handle(CC.getDestroyedType(pd))

    # CXXUnresolvedConstructExpr - dependent T(a) in an uninstantiated template
    uc = find_node(CC.CXXUnresolvedConstructExpr, tpl_body("cc_uctor"))
    @test uc isa CC.CXXUnresolvedConstructExpr
    @test CC.getNumArgs(uc) == 1
    @test CC.getArg(uc, 0).ptr != C_NULL
    @test_throws AssertionError CC.getArg(uc, 1)   # Invariant 3: index bounds
    @test CC.getAsString(CC.getTypeAsWritten(uc)) == "T"
    @test CC.isListInitialization(uc) == false
    @test !CC.is_null_handle(CC.getLParenLoc(uc))
    @test !CC.is_null_handle(CC.getRParenLoc(uc))

    # DependentScopeDeclRefExpr - T::value in an uninstantiated template
    ds = find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_dsdre"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test !CC.is_null_handle(CC.getLocation(ds))
    @test CC.hasTemplateKeyword(ds) == false
    @test CC.hasExplicitTemplateArgs(ds) == false
    @test CC.getNumTemplateArgs(ds) == 0

    # PackExpansionExpr - the ts... argument of a dependent call
    pe = find_node(CC.PackExpansionExpr, tpl_body("cc_pexp"))
    @test pe isa CC.PackExpansionExpr
    @test CC.getPattern(pe).ptr != C_NULL
    @test !CC.is_null_handle(CC.getEllipsisLoc(pe))

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
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- UnresolvedLookupExpr: overloaded free-function call with a dependent arg ----
    ule = find_node(CC.UnresolvedLookupExpr, tpl_body("cc_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    @test CC.isOverloaded(ule) == true
    @test CC.requiresADL(ule)
    # OverloadExpr base surface dispatches on the UnresolvedLookupExpr carrier
    @test CC.getNumDecls(ule) == 2
    @test CC.getAsString(CC.getName(ule)) == "cc_oo"
    @test !CC.is_null_handle(CC.getNameLoc(ule))
    @test CC.is_null_handle(CC.getQualifier(ule))
    @test CC.is_null_handle(CC.getTemplateKeywordLoc(ule))
    @test CC.is_null_handle(CC.getLAngleLoc(ule))
    @test CC.is_null_handle(CC.getRAngleLoc(ule))
    @test CC.hasTemplateKeyword(ule) == false
    @test CC.hasExplicitTemplateArgs(ule) == false
    @test CC.getNumTemplateArgs(ule) == 0
    @test CC.is_null_handle(CC.getNamingClass(ule))

    # ---- UnresolvedMemberExpr, explicit access: `s.m(u)` in cc_gg ----
    ume = find_node(CC.UnresolvedMemberExpr, tpl_body("cc_gg"))
    @test ume isa CC.UnresolvedMemberExpr
    @test CC.isImplicitAccess(ume) == false
    @test CC.isArrow(ume) == false          # accessed with `.`, not `->`
    @test !CC.is_null_handle(CC.getBaseType(ume))
    @test !(CC.hasUnresolvedUsing(ume))
    @test !CC.is_null_handle(CC.getOperatorLoc(ume))
    @test CC.getStmtClassName(CC.getBase(ume)) == "DeclRefExpr"
    @test CC.getBase(ume).ptr != C_NULL
    # OverloadExpr base surface still dispatches on the UnresolvedMemberExpr carrier
    @test CC.getNumDecls(ume) == 2
    @test CC.getAsString(CC.getName(ume)) == "m"
    @test !CC.is_null_handle(CC.getNamingClass(ume))

    # ---- UnresolvedMemberExpr, implicit access: bare `m(u)` in CCS::icall ----
    # getBase()'s precondition must fail (Invariant 3).
    @test f(I, "CCS")
    ct = CC.ClassTemplateDecl(CC.get_decl(f))
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
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        # a function-template name can resolve to several decls; take the template
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
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
        @test ot.ptr != C_NULL
        @test CC.getAsString(ot) == "const struct CCS3" || CC.getAsString(ot) == "struct CCS3"
    end

    # CXXThrowExpr: NRVO scope flag (host-decided; assert shape only)
    th = find_node(CC.CXXThrowExpr, fn_body("ccd_throw"))
    @test th isa CC.CXXThrowExpr
    if th !== nothing
        @test !(CC.isThrownVariableInScope(th))
    end

    # SizeOfPackExpr: source locations + the value-dependent precondition guard
    sp = find_node(CC.SizeOfPackExpr, tpl_body("ccd_pack"))
    @test sp isa CC.SizeOfPackExpr
    if sp !== nothing
        @test !CC.is_null_handle(CC.getOperatorLoc(sp))
        @test !CC.is_null_handle(CC.getPackLoc(sp))
        @test !CC.is_null_handle(CC.getRParenLoc(sp))
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
        @test CC.is_null_handle(CC.getCallee(fe))
        @test CC.getLHS(fe).ptr != C_NULL          # init operand `0`
        @test CC.getRHS(fe).ptr != C_NULL          # pattern operand `ts`
        @test CC.getInit(fe).ptr != C_NULL         # left fold => init is the LHS
        @test !CC.is_null_handle(CC.getLParenLoc(fe))
        @test !CC.is_null_handle(CC.getRParenLoc(fe))
        @test !CC.is_null_handle(CC.getEllipsisLoc(fe))
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
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f))))
    end

    # CXXDefaultArgExpr: rewritten-init flag + the context the default was used in
    da = find_node(CC.CXXDefaultArgExpr, fn_body("ex_use_default"))
    @test da isa CC.CXXDefaultArgExpr
    if da !== nothing
        @test !(CC.hasRewrittenInit(da))
        rw = CC.getRewrittenExpr(da)
        @test rw.ptr == C_NULL
        @test (rw.ptr != C_NULL) == CC.hasRewrittenInit(da)
        uc = CC.getUsedContext(da)
        @test uc.ptr != C_NULL
    end

    # CXXDefaultInitExpr: getRewrittenExpr is assert-guarded (Invariant 3)
    di = find_node(CC.CXXDefaultInitExpr, fn_body("ex_agg"))
    @test di isa CC.CXXDefaultInitExpr
    if di !== nothing
        @test CC.hasRewrittenInit(di)
        @test !CC.is_null_handle(CC.getUsedContext(di))
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
        @test tmp.ptr != C_NULL
        dtor = CC.getDestructor(tmp)
        @test dtor.ptr != C_NULL
        @test CC.getNameAsString(dtor) == "~EXTmp"
    end

    # CXXFunctionalCastExpr: `double(x)` is paren-written, not list-initialized
    fc = find_node(CC.CXXFunctionalCastExpr, fn_body("ex_functional"))
    @test fc isa CC.CXXFunctionalCastExpr
    if fc !== nothing
        @test CC.isListInitialization(fc) == false
        @test !CC.is_null_handle(CC.getLParenLoc(fc))
        @test !CC.is_null_handle(CC.getRParenLoc(fc))
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
        @test CC.getStorageDuration(mt) == CC.LibClangEx.CXStorageDuration_SD_FullExpression
    end

    # ArrayTypeTraitExpr: __array_rank has no dimension operand
    ar = find_node(CC.ArrayTypeTraitExpr, fn_body("ex_array_rank"))
    @test ar isa CC.ArrayTypeTraitExpr
    if ar !== nothing
        @test CC.getTrait(ar) == CC.LibClangEx.CXArrayTypeTrait_ATT_ArrayRank
        @test !CC.is_null_handle(CC.getQueriedType(ar))
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
        @test dim.ptr != C_NULL
        @test CC.getStmtClassName(dim) == "IntegerLiteral"
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
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end

    # CXXTypeidExpr - typeid(int): the type-operand arm of the operand union
    tt = find_node(CC.CXXTypeidExpr, fn_body("tid_type"))
    @test tt isa CC.CXXTypeidExpr
    @test CC.isTypeOperand(tt) == true
    @test !(CC.isPotentiallyEvaluated(tt))
    @test !CC.is_null_handle(CC.getTypeOperand(tt, ctx))
    @test CC.getTypeOperand(tt, ctx).ptr != C_NULL
    @test_throws AssertionError CC.isMostDerived(tt, ctx)   # Invariant 3

    # CXXTypeidExpr - typeid(b): the expression-operand arm
    te = find_node(CC.CXXTypeidExpr, fn_body("tid_expr"))
    @test te isa CC.CXXTypeidExpr
    @test CC.isTypeOperand(te) == false
    @test CC.isPotentiallyEvaluated(te)
    @test !(CC.isMostDerived(te, ctx))
    @test_throws AssertionError CC.getTypeOperand(te, ctx)  # Invariant 3

    # CXXPseudoDestructorExpr - unqualified p->~PdInt() on a scalar typedef
    pp = find_node(CC.CXXPseudoDestructorExpr, fn_body("pd_plain"))
    @test pp isa CC.CXXPseudoDestructorExpr
    @test CC.hasQualifier(pp) == false
    @test CC.getQualifier(pp).ptr == C_NULL
    @test CC.getScopeTypeInfo(pp).ptr == C_NULL
    @test CC.is_null_handle(CC.getColonColonLoc(pp))
    # the destroyed-type storage is a union: resolved -> TypeSourceInfo, dependent
    # and unresolved -> identifier. PdInt resolves, so the identifier arm is NULL.
    @test CC.getDestroyedTypeInfo(pp).ptr != C_NULL
    @test CC.getDestroyedTypeIdentifier(pp).ptr == C_NULL
    @test !CC.is_null_handle(CC.getDestroyedTypeLoc(pp))

    # CXXPseudoDestructorExpr - p->PdInt::~PdInt(): a scalar cannot be part of a
    # nested-name-specifier, so the qualification lands in the scope type instead.
    pq = find_node(CC.CXXPseudoDestructorExpr, fn_body("pd_qual"))
    @test pq isa CC.CXXPseudoDestructorExpr
    @test CC.hasQualifier(pq) == false
    @test !CC.is_null_handle(CC.getScopeTypeInfo(pq))
    @test !CC.is_null_handle(CC.getColonColonLoc(pq))
    @test CC.is_null_handle(CC.getQualifier(pq))

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
    @test CC.getConstructionKind(ice) == CC.LibClangEx.CXCXXConstructionKind_NonVirtualBase
    @test !(CC.inheritedFromVBase(ice))
    @test !CC.is_null_handle(CC.getLocation(ice))

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
        @test !CC.is_null_handle(CC.getNameLoc(s))
        @test CC.getStmtClassName(CC.getReplacement(s)) == "IntegerLiteral"
        @test CC.getReplacement(s).ptr != C_NULL
        @test !CC.is_null_handle(CC.getAssociatedDecl(s))
        @test CC.getAssociatedDecl(s).ptr != C_NULL
        @test CC.getIndex(s) == 0            # the sole template parameter
        @test !CC.is_null_handle(CC.getParameter(s))
        @test CC.getParameter(s).ptr != C_NULL
        @test CC.isReferenceParameter(s) == false
        @test !CC.is_null_handle(CC.getParameterType(s, ctx))
        @test CC.getParameterType(s, ctx).ptr != C_NULL
    end
    # `template <int N>` is not a pack, so its substitution carries no pack index
    @test CC.getPackIndex(seen["nttp_one"]) === nothing
    @test CC.getPackIndex(seen["nttp_pack"]) isa Unsigned

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
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
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
        @test !CC.is_null_handle(CC.getOperatorLoc(rb))
        @test CC.getOperatorLoc(rb).ptr != C_NULL
    end

    # CXXDefaultArgExpr: a plain default argument has no rewritten form, so the
    # adjusted accessor is assert-guarded (Invariant 3)
    dp = find_node(CC.CXXDefaultArgExpr, fn_body("g_use_plain"))
    @test dp isa CC.CXXDefaultArgExpr
    if dp !== nothing
        @test !CC.is_null_handle(CC.getUsedLocation(dp))
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
        @test CC.getStmtClassName(adj) == "ConstantExpr"
        @test adj.ptr != C_NULL
    end

    # CXXDefaultInitExpr: the location the in-class initializer was used at
    di = find_node(CC.CXXDefaultInitExpr, fn_body("g_agg"))
    @test di isa CC.CXXDefaultInitExpr
    if di !== nothing
        @test !CC.is_null_handle(CC.getUsedLocation(di))
        @test CC.getUsedLocation(di).ptr != C_NULL
    end

    # UserDefinedLiteral: the ud-suffix location
    udl = find_node(CC.UserDefinedLiteral, fn_body("g_udl"))
    @test udl isa CC.UserDefinedLiteral
    if udl !== nothing
        @test !CC.is_null_handle(CC.getUDSuffixLoc(udl))
        @test CC.getUDSuffixLoc(udl).ptr != C_NULL
    end

    # ArrayTypeTraitExpr: the queried type is reachable through its TypeSourceInfo
    at = find_node(CC.ArrayTypeTraitExpr, fn_body("g_rank"))
    @test at isa CC.ArrayTypeTraitExpr
    if at !== nothing
        tsi = CC.getQueriedTypeSourceInfo(at)
        @test tsi.ptr != C_NULL
        @test CC.getAsString(CC.getType(tsi)) == "int[3][4]"
    end

    # MaterializeTemporaryExpr: a namespace-scope const reference extends the
    # temporary's lifetime, so the state holds a LifetimeExtendedTemporaryDecl
    @test f(I, "g_ref")
    ginit = CC.resolve(CC.getInit(CC.VarDecl(get_decl(f))))
    mt = find_node(CC.MaterializeTemporaryExpr, ginit)
    @test mt isa CC.MaterializeTemporaryExpr
    if mt !== nothing
        letd = CC.getLifetimeExtendedTemporaryDecl(mt)
        @test letd.ptr != C_NULL
        @test CC.isUsableInConstantExpressions(mt, ctx)
        v = CC.getOrCreateValue(mt, true)
        @test v.ptr != C_NULL
    end

    # PackExpansionExpr / CXXFoldExpr: an uninstantiated template body knows no
    # expansion count, so the C++ optional comes back disengaged
    pe = find_node(CC.PackExpansionExpr, tpl_body("g_pexp"))
    @test pe isa CC.PackExpansionExpr
    if pe !== nothing
        @test CC.getNumExpansions(pe) === nothing
    end

    fe = find_node(CC.CXXFoldExpr, tpl_body("g_fold"))
    @test fe isa CC.CXXFoldExpr
    if fe !== nothing
        @test CC.getNumExpansions(fe) === nothing
    end

    # CXXUnresolvedConstructExpr: the dependent `T(a)` names its type through a
    # TypeSourceInfo
    uc = find_node(CC.CXXUnresolvedConstructExpr, tpl_body("g_uctor"))
    @test uc isa CC.CXXUnresolvedConstructExpr
    if uc !== nothing
        utsi = CC.getTypeSourceInfo(uc)
        @test utsi.ptr != C_NULL
        @test CC.getAsString(CC.getType(utsi)) == "T"
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
    croot = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(g))))
    ca = find_node(CC.CoawaitExpr, croot)
    @test ca isa CC.CoawaitExpr
    if ca !== nothing
        @test !(CC.isImplicit(ca))
        @test !CC.is_null_handle(CC.getOpaqueValue(ca))
    end

    # DependentCoawaitExpr: `co_await a` on a dependent operand keeps the operand
    # and the operator co_await lookup side by side
    @test g(J, "g_tcoro")
    tftd = CC.FunctionTemplateDecl(first(CC.get_decls(g)))
    tbody = CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(tftd))))
    dca = find_node(CC.DependentCoawaitExpr, tbody)
    @test dca isa CC.DependentCoawaitExpr
    if dca !== nothing
        @test !CC.is_null_handle(CC.getOperand(dca))
        @test CC.getOperand(dca).ptr != C_NULL
        lookup = CC.getOperatorCoawaitLookup(dca)
        @test lookup.ptr != C_NULL
        @test CC.getAsString(CC.getName(lookup)) == "operator co_await"
        @test !CC.is_null_handle(CC.getKeywordLoc(dca))
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
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- plain dependent member access: `t.value` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    @test CC.isImplicitAccess(dsme) == false
    @test CC.getStmtClassName(CC.getBase(dsme)) == "DeclRefExpr"
    @test CC.getBase(dsme).ptr != C_NULL
    @test !CC.is_null_handle(CC.getBaseType(dsme))
    @test CC.isArrow(dsme) == false          # accessed with `.`, not `->`
    @test !CC.is_null_handle(CC.getOperatorLoc(dsme))
    @test CC.getAsString(CC.getMember(dsme)) == "value"
    @test !CC.is_null_handle(CC.getMemberLoc(dsme))
    @test CC.is_null_handle(CC.getQualifier(dsme))
    @test CC.getQualifier(dsme).ptr == C_NULL   # `t.value` carries no `::`
    @test CC.is_null_handle(CC.getFirstQualifierFoundInScope(dsme))
    @test CC.hasTemplateKeyword(dsme) == false
    @test CC.hasExplicitTemplateArgs(dsme) == false
    @test CC.getNumTemplateArgs(dsme) == 0
    @test CC.is_null_handle(CC.getTemplateKeywordLoc(dsme))
    @test CC.is_null_handle(CC.getLAngleLoc(dsme))
    @test CC.is_null_handle(CC.getRAngleLoc(dsme))

    # ---- qualified dependent member access: `t.CCDQB::qm` ----
    dsme_q = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme_q"))
    @test dsme_q isa CC.CXXDependentScopeMemberExpr
    @test CC.getQualifier(dsme_q).ptr != C_NULL
    @test !CC.is_null_handle(CC.getFirstQualifierFoundInScope(dsme_q))

    # ---- `template`-keyword member access: `t.template get<int>()` ----
    dsme_t = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_dsme_tpl"))
    @test dsme_t isa CC.CXXDependentScopeMemberExpr
    @test CC.hasTemplateKeyword(dsme_t) == true
    @test CC.hasExplicitTemplateArgs(dsme_t) == true
    @test CC.getNumTemplateArgs(dsme_t) == 1

    # ---- DependentScopeDeclRefExpr tail: `T::value` ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_dsdref"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test !CC.is_null_handle(CC.getDeclName(ds))
    @test !CC.is_null_handle(CC.getQualifier(ds))
    @test CC.getQualifier(ds).ptr != C_NULL     # the `T::` is always written
    @test CC.is_null_handle(CC.getTemplateKeywordLoc(ds))
    @test CC.is_null_handle(CC.getLAngleLoc(ds))
    @test CC.is_null_handle(CC.getRAngleLoc(ds))

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX-i: construct/this/literal setters + overload & template-arg indexing" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    CC.parse(I, """
    struct CCIA { int v; CCIA(int x) : v(x) {} };
    CCIA cci_make(int v) { CCIA a(v); return a; }
    struct CCI2 { int p; double q; CCI2(int a, double b) : p(a), q(b) {} };
    CCI2 cci_make2() { CCI2 a(1, 2.5); return a; }
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
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.get_decl(f))))
    end

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- CXXConstructExpr setters, each round-tripped against its own getter ----
    ce = _find_node(CC.AbstractCXXConstructExpr, fn_body("cci_make"))
    @test ce isa CC.AbstractCXXConstructExpr

    for (setter, getter) in ((CC.setElidable, CC.isElidable), (CC.setHadMultipleCandidates, CC.hadMultipleCandidates),
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

    # Reading only index 0 cannot separate a working accessor from one that ignores its
    # index, so a two-argument construction is where the index has to do something. The
    # types differ too, which pins which argument is which rather than only that they are
    # two distinct nodes.
    ce2 = _find_node(CC.AbstractCXXConstructExpr, fn_body("cci_make2"))
    @test ce2 isa CC.AbstractCXXConstructExpr
    @test CC.getNumArgs(ce2) == 2
    @test CC.getArg(ce2, 0).ptr != CC.getArg(ce2, 1).ptr
    @test CC.getAsString(CC.getType(CC.getArg(ce2, 0))) == "int"
    @test CC.getAsString(CC.getType(CC.getArg(ce2, 1))) == "double"
    @test_throws AssertionError CC.getArg(ce2, 2)

    # ---- CXXThisExpr setters: `this->w` inside CCIB::get ----
    @test f(I, "CCIB")
    rd = CC.CXXRecordDecl(CC.get_decl(f))
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
    for i = 0:(ndecls - 1)
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
    @test !CC.is_null_handle(CC.getTemplateArg(ule_t, 0))
    @test CC.getTemplateArg(ule_t, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(ule_t, 1)

    # ---- CXXDependentScopeMemberExpr: `t.template get<int>()` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cci_dsme_tpl"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    @test CC.getNumTemplateArgs(dsme) == 1
    @test !CC.is_null_handle(CC.getTemplateArg(dsme, 0))
    @test CC.getTemplateArg(dsme, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(dsme, 1)

    # ---- DependentScopeDeclRefExpr: `T::template g<int>()` ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cci_dsdref_tpl"))
    @test ds isa CC.DependentScopeDeclRefExpr
    @test CC.hasTemplateKeyword(ds) == true
    @test CC.getNumTemplateArgs(ds) == 1
    @test !CC.is_null_handle(CC.getTemplateArg(ds, 0))
    @test CC.getTemplateArg(ds, 0).ptr != C_NULL
    @test_throws AssertionError CC.getTemplateArg(ds, 1)

    CC.dispose(f)
    CC.dispose(I)
end

@testset "ExprCXX-j: paren-list init / MS property / unresolved-ctor setters" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    # ---- C++20: parenthesized aggregate init, rewritten `!=`, dependent T(a) ----
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    CC.parse(I, """
    struct JAgg { int a; int b = 5; };
    JAgg j_paren() { JAgg p(1); return p; }
    union JUni { int a; double b; };
    JUni j_union() { JUni u(3); return u; }
    struct JEq { int v; bool operator==(const JEq &) const; };
    bool j_rewritten(JEq a, JEq b) { return a != b; }
    template <class T> auto j_uctor(T a) { return T(a); }
    """)

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- CXXParenListInitExpr: `JAgg p(1)` fills `b` from its default initializer --
    pl = find_node(CC.CXXParenListInitExpr, fn_body("j_paren"))
    @test pl isa CC.CXXParenListInitExpr
    if pl isa CC.CXXParenListInitExpr
        n = CC.getNumInitExprs(pl)
        @test n >= 1
        nu = CC.getNumUserSpecifiedInitExprs(pl)
        @test nu <= n
        @test !CC.is_null_handle(CC.getInitExpr(pl, 0))
        @test CC.getInitExpr(pl, 0).ptr != C_NULL
        @test !CC.is_null_handle(CC.getInitLoc(pl))
        if nu > 0
            @test CC.getUserSpecifiedInitExpr(pl, 0).ptr == CC.getInitExpr(pl, 0).ptr
        end
        # a struct initializer engages neither arm of ArrayFillerOrUnionFieldInit
        @test CC.getArrayFiller(pl) isa CC.Expr_
        @test CC.getArrayFiller(pl).ptr == C_NULL
        @test CC.is_null_handle(CC.getInitializedFieldInUnion(pl))
        @test CC.getInitializedFieldInUnion(pl).ptr == C_NULL
        # both index accessors restate Clang's bounds precondition
        @test_throws AssertionError CC.getInitExpr(pl, n)
        @test_throws AssertionError CC.getUserSpecifiedInitExpr(pl, -1)
    end

    # ---- the union arm of the same PointerUnion, when the host built one -----------
    ul = find_node(CC.CXXParenListInitExpr, fn_body("j_union"))
    if ul isa CC.CXXParenListInitExpr
        fd = CC.getInitializedFieldInUnion(ul)
        @test fd isa CC.FieldDecl
        if fd.ptr != C_NULL
            @test CC.get_name(fd) == "a"
            @test CC.getArrayFiller(ul).ptr == C_NULL
        end
    end

    # ---- CXXRewrittenBinaryOperator::getOpcodeStr spells the WRITTEN operator ------
    rb = find_node(CC.CXXRewrittenBinaryOperator, fn_body("j_rewritten"))
    @test rb isa CC.CXXRewrittenBinaryOperator
    if rb isa CC.CXXRewrittenBinaryOperator
        @test CC.getOpcodeStr(rb) == "!="
    end

    # ---- CXXUnresolvedConstructExpr setters, round-tripped against the getters -----
    uc = find_node(CC.CXXUnresolvedConstructExpr, tpl_body("j_uctor"))
    @test uc isa CC.CXXUnresolvedConstructExpr
    if uc isa CC.CXXUnresolvedConstructExpr
        lp = CC.getLParenLoc(uc)
        rp = CC.getRParenLoc(uc)
        CC.setLParenLoc(uc, rp)
        @test CC.getLParenLoc(uc).ptr == rp.ptr
        CC.setLParenLoc(uc, lp)
        @test CC.getLParenLoc(uc).ptr == lp.ptr
        CC.setRParenLoc(uc, rp)
        @test CC.getRParenLoc(uc).ptr == rp.ptr
        na = CC.getNumArgs(uc)
        @test na >= 1
        if na >= 1
            a0 = CC.getArg(uc, 0)
            CC.setArg(uc, 0, a0)
            @test CC.getArg(uc, 0).ptr == a0.ptr
            @test_throws AssertionError CC.setArg(uc, na, a0)
        end
    end
    dispose(f)
    dispose(I)

    # ---- MS extensions: __declspec(property) reference and its subscript form ------
    Ims = create_interpreter(["-fms-extensions"])
    fms = DeclFinder(Ims)
    CC.parse(Ims, """
    struct JMS {
      int get_x();
      void put_x(int);
      __declspec(property(get = get_x, put = put_x)) int x;
      int get_y(int);
      void put_y(int, int);
      __declspec(property(get = get_y, put = put_y)) int y[];
    };
    int jms_read(JMS *p) { return p->x; }
    int jms_sub(JMS *p) { return p->y[2]; }
    """)

    function ms_body(name)
        @test fms(Ims, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(fms))))
    end

    pr = find_node(CC.MSPropertyRefExpr, ms_body("jms_read"))
    @test pr isa CC.MSPropertyRefExpr
    if pr isa CC.MSPropertyRefExpr
        @test CC.isArrow(pr) == true          # written `p->x`, not `p.x`
        @test CC.isImplicitAccess(pr) == false
        @test !CC.is_null_handle(CC.getBaseExpr(pr))
        @test CC.getBaseExpr(pr).ptr != C_NULL
        pd = CC.getPropertyDecl(pr)
        @test pd isa CC.MSPropertyDecl
        @test CC.get_name(pd) == "x"
        @test !CC.is_null_handle(CC.getMemberLoc(pr))
    end

    ps = find_node(CC.MSPropertySubscriptExpr, ms_body("jms_sub"))
    @test ps isa CC.MSPropertySubscriptExpr
    if ps isa CC.MSPropertySubscriptExpr
        @test CC.getBase(ps) isa CC.Expr_
        @test CC.getBase(ps).ptr != C_NULL
        @test !CC.is_null_handle(CC.getIdx(ps))
        @test CC.getIdx(ps).ptr != C_NULL
        rbl = CC.getRBracketLoc(ps)
        @test rbl isa CC.SourceLocation
        CC.setRBracketLoc(ps, rbl)
        @test CC.getRBracketLoc(ps).ptr == rbl.ptr
    end
    dispose(fms)
    dispose(Ims)
end

@testset "CXXUuidofExpr and the ExprCXX mutator tail" begin
    function find_node(T, x)
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, CC.resolve(c))
            r === nothing || return r
        end
        return nothing
    end

    # ---- MS extensions: __uuidof, the __declspec(uuid) sibling of typeid ----------
    # Parsed first, before any synthetic node exists: a rejected parse renders
    # diagnostics over the AST, and doing that after hand-built nodes exist has
    # crashed DiagnosticRenderer before.
    Ims = create_interpreter(["-fms-extensions"])
    fms = DeclFinder(Ims)
    CC.parse(Ims, """
    typedef struct _GUID {
      unsigned long Data1;
      unsigned short Data2;
      unsigned short Data3;
      unsigned char Data4[8];
    } GUID;
    struct __declspec(uuid("00000000-0000-0000-c000-000000000046")) JKGuid {};
    const GUID *jk_uuid_type() { return &__uuidof(JKGuid); }
    const GUID *jk_uuid_expr(JKGuid *p) { return &__uuidof(*p); }
    """)
    ctx_ms = CC.getASTContext(CC.get_instance(Ims))

    function ms_body(name)
        @test fms(Ims, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(fms))))
    end

    ut = find_node(CC.CXXUuidofExpr, ms_body("jk_uuid_type"))
    @test ut isa CC.CXXUuidofExpr
    if ut isa CC.CXXUuidofExpr
        @test CC.isTypeOperand(ut) == true
        @test !CC.is_null_handle(CC.getTypeOperandSourceInfo(ut))
        @test CC.getTypeOperandSourceInfo(ut).ptr != C_NULL
        @test !CC.is_null_handle(CC.getTypeOperand(ut, ctx_ms))
        @test CC.getTypeOperand(ut, ctx_ms).ptr != C_NULL
        @test_throws AssertionError CC.getExprOperand(ut)          # Invariant 3
        gd = CC.getGuidDecl(ut)
        @test gd isa CC.MSGuidDecl
        @test gd.ptr != C_NULL
        r = CC.getSourceRange(ut)
        CC.setSourceRange(ut, r)
        @test CC.getSourceRange(ut).begin_loc.ptr == r.begin_loc.ptr
        @test CC.getSourceRange(ut).end_loc.ptr == r.end_loc.ptr
    end

    ue = find_node(CC.CXXUuidofExpr, ms_body("jk_uuid_expr"))
    @test ue isa CC.CXXUuidofExpr
    if ue isa CC.CXXUuidofExpr
        @test CC.isTypeOperand(ue) == false
        @test !CC.is_null_handle(CC.getExprOperand(ue))
        @test CC.getExprOperand(ue).ptr != C_NULL
        @test !CC.is_null_handle(CC.getGuidDecl(ue))
        @test_throws AssertionError CC.getTypeOperandSourceInfo(ue)  # Invariant 3
        @test_throws AssertionError CC.getTypeOperand(ue, ctx_ms)    # Invariant 3
    end
    dispose(fms)
    dispose(Ims)

    # ---- mutator round-trips on the nodes an ordinary translation unit builds -----
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
    struct JKT { JKT(); ~JKT(); };
    struct JKN { JKN(); };
    void jk_bind() { JKT(); }
    JKN *jk_new() { return new JKN(); }
    int jk_fcast(double d) { return int(d); }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end

    # CXXBindTemporaryExpr / CXXTemporary: both halves of `JKT();`
    bt = find_node(CC.CXXBindTemporaryExpr, fn_body("jk_bind"))
    @test bt isa CC.CXXBindTemporaryExpr
    if bt isa CC.CXXBindTemporaryExpr
        tmp = CC.getTemporary(bt)
        sub = CC.getSubExpr(bt)
        CC.setTemporary(bt, tmp)
        @test CC.getTemporary(bt).ptr == tmp.ptr
        CC.setSubExpr(bt, sub)
        @test CC.getSubExpr(bt).ptr == sub.ptr
        dtor = CC.getDestructor(tmp)
        @test dtor isa CC.CXXDestructorDecl
        if dtor.ptr != C_NULL
            t2 = CC.CXXTemporary(ctx, dtor)
            @test t2 isa CC.CXXTemporary
            @test t2.ptr != C_NULL
            @test CC.getDestructor(t2).ptr == dtor.ptr
            CC.setDestructor(t2, dtor)
            @test CC.getDestructor(t2).ptr == dtor.ptr
        end
    end

    # CXXNewExpr: the allocation/deallocation function slots
    ne = find_node(CC.CXXNewExpr, fn_body("jk_new"))
    @test ne isa CC.CXXNewExpr
    if ne isa CC.CXXNewExpr
        on = CC.getOperatorNew(ne)
        @test on isa CC.FunctionDecl
        if on.ptr != C_NULL
            CC.setOperatorNew(ne, on)
            @test CC.getOperatorNew(ne).ptr == on.ptr
        end
        od = CC.getOperatorDelete(ne)
        @test od isa CC.FunctionDecl
        if od.ptr != C_NULL
            CC.setOperatorDelete(ne, od)
            @test CC.getOperatorDelete(ne).ptr == od.ptr
        end

        # CXXThisExpr::Create - built from the `new` expression's own type and location
        loc = CC.getBeginLoc(ne)
        ty = CC.getType(ne)
        th = CC.CXXThisExpr(ctx, loc, ty, true)
        @test th isa CC.CXXThisExpr
        @test th.ptr != C_NULL
        @test CC.isImplicit(th) == true
        @test CC.getLocation(th).ptr == loc.ptr
        CC.setImplicit(th, false)
        @test CC.isImplicit(th) == false
        # CreateEmpty yields an uninitialized shell; only its identity is defined
        th2 = CC.CXXThisExpr(ctx)
        @test th2 isa CC.CXXThisExpr
        @test th2.ptr != C_NULL
    end

    # CXXFunctionalCastExpr: the paren locations, which also drive isListInitialization
    fc = find_node(CC.CXXFunctionalCastExpr, fn_body("jk_fcast"))
    @test fc isa CC.CXXFunctionalCastExpr
    if fc isa CC.CXXFunctionalCastExpr
        lp = CC.getLParenLoc(fc)
        rp = CC.getRParenLoc(fc)
        CC.setLParenLoc(fc, rp)
        @test CC.getLParenLoc(fc).ptr == rp.ptr
        CC.setLParenLoc(fc, lp)
        @test CC.getLParenLoc(fc).ptr == lp.ptr
        @test !(CC.isListInitialization(fc))
        CC.setRParenLoc(fc, rp)
        @test CC.getRParenLoc(fc).ptr == rp.ptr
    end
    dispose(f)
    dispose(I)

    # ---- C++20: writing either arm of the CXXParenListInitExpr PointerUnion -------
    I20 = create_interpreter(["-std=c++20"])
    f20 = DeclFinder(I20)
    CC.parse(I20, """
    struct KAgg { int a; int b = 5; };
    KAgg k_paren() { KAgg p(1); return p; }
    union KUni { int a; double b; };
    KUni k_union() { KUni u(3); return u; }
    """)

    function body20(name)
        @test f20(I20, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f20))))
    end

    ul = find_node(CC.CXXParenListInitExpr, body20("k_union"))
    @test ul isa CC.CXXParenListInitExpr
    if ul isa CC.CXXParenListInitExpr
        fd = CC.getInitializedFieldInUnion(ul)
        @test fd isa CC.FieldDecl
        if fd.ptr != C_NULL
            CC.setInitializedFieldInUnion(ul, fd)
            @test CC.getInitializedFieldInUnion(ul).ptr == fd.ptr
            @test CC.getArrayFiller(ul).ptr == C_NULL
        end
    end

    pl = find_node(CC.CXXParenListInitExpr, body20("k_paren"))
    @test pl isa CC.CXXParenListInitExpr
    if pl isa CC.CXXParenListInitExpr && CC.getNumInitExprs(pl) > 0
        # a struct initializer engages neither arm; writing one arm disengages the other
        @test CC.getArrayFiller(pl).ptr == C_NULL
        e0 = CC.getInitExpr(pl, 0)
        CC.setArrayFiller(pl, e0)
        @test CC.getArrayFiller(pl).ptr == e0.ptr
        @test CC.getInitializedFieldInUnion(pl).ptr == C_NULL
    end
    dispose(f20)
    dispose(I20)
end

@testset "ExprCXX-l: name info / qualifier extents / node synthesis" begin
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    CC.parse(I, """
    int ll_free(int a = 5);
    struct LLAgg { int a; int b = 7; };
    struct LLDtor { ~LLDtor(); };
    typedef int LLInt;
    void ll_pd(LLInt *p) { p->LLInt::~LLInt(); }
    struct LLEq { int v; bool operator==(const LLEq &) const; };
    bool ll_rewritten(LLEq a, LLEq b) { return a != b; }
    int ll_oo(int);
    int ll_oo(double);
    template <class T> int ll_ule(T t) { return ll_oo(t); }
    template <class T> int ll_dref() { return T::value; }
    template <class T> int ll_dmem(T t) { return t.LLEq::v; }
    auto ll_lambda() { return []<class T>(T x) { return x; }; }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- CXXRewrittenBinaryOperator: `a != b` rewrites to !(a == b) in C++20 ------
    rbo = _find_node(CC.CXXRewrittenBinaryOperator, fn_body("ll_rewritten"))
    @test rbo isa CC.CXXRewrittenBinaryOperator
    inner = CC.getInnerBinOp(rbo)
    @test CC.getStmtClassName(inner) == "CXXOperatorCallExpr"
    @test inner.ptr != C_NULL

    # ---- the pieces the synthesis factories need --------------------------------
    @test f(I, "ll_free")
    free_fd = CC.FunctionDecl(get_decl(f))
    param = CC.getParamDecl(free_fd, 0)
    @test param isa CC.ParmVarDecl
    @test CC.hasDefaultArg(param) == true
    defarg = CC.getDefaultArg(param)
    @test defarg isa CC.Expr_
    intty = CC.getType(defarg)
    loc = CC.getBeginLoc(defarg)

    @test f(I, "ll_rewritten")
    boolty = CC.getReturnType(CC.FunctionDecl(get_decl(f)))
    @test boolty isa CC.QualType

    @test f(I, "LLAgg")
    agg = CC.CXXRecordDecl(get_decl(f))
    aggdc = CC.castToDeclContext(agg)
    fld_a, fld_b = nothing, nothing
    for d in CC.decls(aggdc)
        d isa CC.FieldDecl && CC.get_name(d) == "a" && (fld_a = d)
        d isa CC.FieldDecl && CC.get_name(d) == "b" && (fld_b = d)
    end
    @test fld_a isa CC.FieldDecl
    @test fld_b isa CC.FieldDecl

    # ---- CXXBoolLiteralExpr::Create ---------------------------------------------
    blit = CC.CXXBoolLiteralExpr(ctx, true, boolty, loc)
    @test blit isa CC.CXXBoolLiteralExpr
    @test blit.ptr != C_NULL
    @test CC.getValue(blit) == true
    @test CC.getLocation(blit).ptr == loc.ptr

    # ---- CXXConstCastExpr::Create: a const_cast<int> of the `5` default arg ------
    tsi = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    @test tsi isa CC.TypeSourceInfo
    cce = CC.CXXConstCastExpr(ctx, intty, CC.CXExprValueKind_VK_PRValue, defarg, tsi, loc, loc,
                              CC.SourceRange(loc, loc))
    @test cce isa CC.CXXConstCastExpr
    @test cce.ptr != C_NULL
    @test CC.getCastName(cce) == "const_cast"
    @test CC.getSubExpr(cce).ptr == defarg.ptr
    @test CC.getRParenLoc(cce).ptr == loc.ptr
    let r = CC.getAngleBrackets(cce)
        @test CC.isValid(r)
        @test r.begin_loc.ptr != C_NULL
        @test r.end_loc.ptr != C_NULL
    end

    # ---- CXXDefaultArgExpr::Create, with and without a rewritten initializer -----
    dae = CC.CXXDefaultArgExpr(ctx, loc, param, nothing, aggdc)
    @test dae isa CC.CXXDefaultArgExpr
    @test dae.ptr != C_NULL
    @test CC.getParam(dae).ptr == param.ptr
    @test CC.getUsedContext(dae).ptr == aggdc.ptr
    @test CC.getUsedLocation(dae).ptr == loc.ptr
    @test CC.hasRewrittenInit(dae) == false
    dae2 = CC.CXXDefaultArgExpr(ctx, loc, param, blit, aggdc)
    @test CC.hasRewrittenInit(dae2) == true
    @test CC.getRewrittenExpr(dae2).ptr == blit.ptr

    # ---- CXXDefaultInitExpr::Create; the field must carry an in-class init -------
    die = CC.CXXDefaultInitExpr(ctx, loc, fld_b, aggdc, nothing)
    @test die isa CC.CXXDefaultInitExpr
    @test die.ptr != C_NULL
    @test CC.getField(die).ptr == fld_b.ptr
    @test CC.getUsedContext(die).ptr == aggdc.ptr
    @test CC.hasRewrittenInit(die) == false
    @test CC.hasInClassInitializer(fld_a) == false
    @test_throws AssertionError CC.CXXDefaultInitExpr(ctx, loc, fld_a, aggdc, nothing)

    # ---- CXXBindTemporaryExpr::Create -------------------------------------------
    @test f(I, "LLDtor")
    dtor = CC.getDestructor(CC.CXXRecordDecl(get_decl(f)))
    @test dtor isa CC.CXXDestructorDecl
    if dtor.ptr != C_NULL
        tmp = CC.CXXTemporary(ctx, dtor)
        bte = CC.CXXBindTemporaryExpr(ctx, tmp, blit)
        @test bte isa CC.CXXBindTemporaryExpr
        @test bte.ptr != C_NULL
        @test CC.getTemporary(bte).ptr == tmp.ptr
        @test CC.getSubExpr(bte).ptr == blit.ptr
    end

    # ---- LambdaExpr explicit template parameters: `[]<class T>(T x)` -------------
    le = _find_node(CC.LambdaExpr, fn_body("ll_lambda"))
    @test le isa CC.LambdaExpr
    @test CC.isGenericLambda(le) == true
    n = CC.getNumExplicitTemplateParameters(le)
    @test n == 1
    p0 = CC.getExplicitTemplateParameter(le, 0)
    @test p0 isa CC.NamedDecl
    @test CC.get_name(p0) == "T"
    @test_throws AssertionError CC.getExplicitTemplateParameter(le, n)

    # ---- CXXPseudoDestructorExpr: a scalar destroyed type keeps its written
    # qualification in the scope type, so the nested-name-specifier stays empty ----
    pd = _find_node(CC.CXXPseudoDestructorExpr, fn_body("ll_pd"))
    @test pd isa CC.CXXPseudoDestructorExpr
    @test CC.hasQualifier(pd) == false
    let r = CC.getQualifierRange(pd)
        @test !CC.isValid(r)
        @test CC.is_null_handle(r.begin_loc)
    end

    # ---- OverloadExpr name info / qualifier extent -------------------------------
    ule = _find_node(CC.UnresolvedLookupExpr, tpl_body("ll_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    ni = CC.getNameInfo(ule)
    @test ni isa CC.DeclarationNameInfo
    @test ni.ptr != C_NULL
    @test CC.getAsString(ni) == "ll_oo"
    @test CC.getLoc(ni).ptr == CC.getNameLoc(ule).ptr
    dispose(ni)
    # `ll_oo` is written without a `T::`, so the qualifier range is the invalid one clang
    # default-constructs -- a shim handing back the whole expression's range instead would
    # satisfy `isa SourceRange` and fail this
    @test !CC.isValid(CC.getQualifierRange(ule).begin_loc)

    # ---- DependentScopeDeclRefExpr: the `T::` is always written -------------------
    dre = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("ll_dref"))
    @test dre isa CC.DependentScopeDeclRefExpr
    ni2 = CC.getNameInfo(dre)
    @test ni2 isa CC.DeclarationNameInfo
    @test CC.getAsString(ni2) == "value"
    dispose(ni2)
    qr2 = CC.getQualifierRange(dre)
    @test qr2 isa CC.SourceRange
    @test qr2.begin_loc.ptr != C_NULL

    # ---- CXXDependentScopeMemberExpr: `t.LLEq::v` --------------------------------
    dme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("ll_dmem"))
    @test dme isa CC.CXXDependentScopeMemberExpr
    ni3 = CC.getMemberNameInfo(dme)
    @test ni3 isa CC.DeclarationNameInfo
    @test CC.getAsString(ni3) == "v"
    dispose(ni3)
    qr3 = CC.getQualifierRange(dme)
    @test qr3 isa CC.SourceRange
    @test qr3.begin_loc.ptr != C_NULL

    dispose(f)
    dispose(I)

    # ---- MSPropertyRefExpr qualifier extent needs -fms-extensions ----------------
    Ims = create_interpreter(["-fms-extensions"])
    fms = DeclFinder(Ims)
    CC.parse(Ims, """
    struct LMS {
      int get_x();
      void put_x(int);
      __declspec(property(get = get_x, put = put_x)) int x;
    };
    int lms_read(LMS *p) { return p->x; }
    """)
    @test fms(Ims, "lms_read")
    ms_body = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(fms))))
    mp = _find_node(CC.MSPropertyRefExpr, ms_body)
    @test mp isa CC.MSPropertyRefExpr
    # `p->x` names no `T::`, so the qualifier range is the invalid default
    @test !CC.isValid(CC.getQualifierRange(mp).begin_loc)

    dispose(fms)
    dispose(Ims)
end

@testset "ExprCXX-m: named-cast factories / functional cast / FunctionParmPackExpr" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "int mm_free(int a = 5);")
    ctx = CC.getASTContext(CC.get_instance(I))

    @test f(I, "mm_free")
    fd = CC.FunctionDecl(get_decl(f))
    param = CC.getParamDecl(fd, 0)
    @test param isa CC.ParmVarDecl
    @test CC.hasDefaultArg(param) == true
    op = CC.getDefaultArg(param)
    @test op isa CC.Expr_
    intty = CC.getType(op)
    loc = CC.getBeginLoc(op)
    tsi = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    @test tsi isa CC.TypeSourceInfo
    angles = CC.SourceRange(loc, loc)
    vk = CC.CXExprValueKind_VK_PRValue
    # CK_NoOp is the one kind that keeps these synthetic nodes clear of clang's base-path
    # and address-space cast-consistency assertions, since the factories pass no path.
    noop = CC.LibClangEx.CXCastKind_CK_NoOp

    # ---- the four named-cast factories -------------------------------------------
    sce = CC.CXXStaticCastExpr(ctx, intty, vk, noop, op, tsi, 0, loc, loc, angles)
    @test sce isa CC.CXXStaticCastExpr
    @test sce.ptr != C_NULL
    @test CC.getCastName(sce) == "static_cast"
    @test CC.getSubExpr(sce).ptr == op.ptr
    @test CC.getRParenLoc(sce).ptr == loc.ptr
    let r = CC.getAngleBrackets(sce)
        @test CC.isValid(r)
        @test r.begin_loc.ptr != C_NULL
        @test r.end_loc.ptr != C_NULL
    end

    dce = CC.CXXDynamicCastExpr(ctx, intty, vk, noop, op, tsi, loc, loc, angles)
    @test dce isa CC.CXXDynamicCastExpr
    @test dce.ptr != C_NULL
    @test CC.getCastName(dce) == "dynamic_cast"
    @test CC.getSubExpr(dce).ptr == op.ptr

    rce = CC.CXXReinterpretCastExpr(ctx, intty, vk, noop, op, tsi, loc, loc, angles)
    @test rce isa CC.CXXReinterpretCastExpr
    @test rce.ptr != C_NULL
    @test CC.getCastName(rce) == "reinterpret_cast"
    @test CC.getOperatorLoc(rce).ptr == loc.ptr

    ace = CC.CXXAddrspaceCastExpr(ctx, intty, vk, noop, op, tsi, loc, loc, angles)
    @test ace isa CC.CXXAddrspaceCastExpr
    @test ace.ptr != C_NULL
    @test CC.getCastName(ace) == "addrspace_cast"
    @test CC.getSubExpr(ace).ptr == op.ptr

    # ---- CXXFunctionalCastExpr::Create: a valid LParenLoc means `T(x)`, not `T{x}` --
    fce = CC.CXXFunctionalCastExpr(ctx, intty, vk, tsi, noop, op, 0, loc, loc)
    @test fce isa CC.CXXFunctionalCastExpr
    @test fce.ptr != C_NULL
    @test CC.getLParenLoc(fce).ptr == loc.ptr
    @test CC.getRParenLoc(fce).ptr == loc.ptr
    @test CC.isListInitialization(fce) == false
    @test CC.getSubExpr(fce).ptr == op.ptr

    # ---- the deserialization shells: only the statement class is initialized -------
    shells = [(CC.CXXStaticCastExpr(ctx, 0, false), "CXXStaticCastExpr"),
              (CC.CXXDynamicCastExpr(ctx, 0), "CXXDynamicCastExpr"),
              (CC.CXXReinterpretCastExpr(ctx, 0), "CXXReinterpretCastExpr"),
              (CC.CXXConstCastExpr(ctx), "CXXConstCastExpr"), (CC.CXXAddrspaceCastExpr(ctx), "CXXAddrspaceCastExpr"),
              (CC.CXXFunctionalCastExpr(ctx, 0, false), "CXXFunctionalCastExpr")]
    for (shell, name) in shells
        @test shell.ptr != C_NULL
        @test CC.getStmtClassName(shell) == name
    end

    # ---- FunctionParmPackExpr, covered by construction ----------------------------
    fppe = CC.FunctionParmPackExpr(ctx, intty, param, loc, [param])
    @test fppe isa CC.FunctionParmPackExpr
    @test fppe.ptr != C_NULL
    @test CC.getStmtClassName(fppe) == "FunctionParmPackExpr"
    @test CC.getParameterPack(fppe).ptr == param.ptr
    @test CC.getParameterPackLocation(fppe).ptr == loc.ptr
    @test CC.getNumExpansions(fppe) == 1
    @test CC.getExpansion(fppe, 0).ptr == param.ptr
    @test_throws AssertionError CC.getExpansion(fppe, 1)

    dispose(f)
    dispose(I)
end

@testset "ExprCXX-n: substituted NTTP packs / paren-list + unresolved-construct factories / shells" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "template <int... nn_pack> struct NNPack { }; int nn_free(int a = 11);")
    ctx = CC.getASTContext(CC.get_instance(I))

    @test f(I, "nn_free")
    fd = CC.FunctionDecl(get_decl(f))
    param = CC.getParamDecl(fd, 0)
    @test CC.hasDefaultArg(param) == true
    op = CC.getDefaultArg(param)
    @test op isa CC.Expr_
    intty = CC.getType(op)
    loc = CC.getBeginLoc(op)
    tsi = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    @test tsi isa CC.TypeSourceInfo
    vk = CC.CXExprValueKind_VK_PRValue

    # ---- SubstNonTypeTemplateParmPackExpr, covered by construction -----------------
    # Select the class template by kind: a bare lookup of "NNPack" is unique here, but the
    # kind filter keeps the testset safe if a later edit instantiates the template.
    @test f(I, "NNPack")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    tpl = CC.getTemplateParameters(ctd)
    nttp = CC.resolve(CC.getParam(tpl, 0))
    @test nttp isa CC.NonTypeTemplateParmDecl
    @test CC.getName(nttp) == "nn_pack"

    ta = CC.TemplateArgument(intty)
    snp = CC.SubstNonTypeTemplateParmPackExpr(ctx, intty, vk, loc, [ta], ctd, 0)
    @test snp isa CC.SubstNonTypeTemplateParmPackExpr
    @test snp.ptr != C_NULL
    @test CC.getStmtClassName(snp) == "SubstNonTypeTemplateParmPackExpr"
    @test CC.getAssociatedDecl(snp).ptr == ctd.ptr
    @test CC.getIndex(snp) == 0
    @test CC.getParameterPackLocation(snp).ptr == loc.ptr
    @test CC.getParameterPack(snp).ptr == nttp.ptr
    pack = CC.getArgumentPack(snp)
    @test pack isa CC.TemplateArgument
    @test CC.getKind(pack) == CC.LibClangEx.CXTemplateArgument_Pack
    dispose(pack)
    dispose(ta)

    # ---- CXXParenListInitExpr::Create / CreateEmpty --------------------------------
    ple = CC.CXXParenListInitExpr(ctx, [op], intty, 1, loc, loc, loc)
    @test ple isa CC.CXXParenListInitExpr
    @test CC.getStmtClassName(ple) == "CXXParenListInitExpr"
    @test CC.getNumInitExprs(ple) == 1
    @test CC.getInitExpr(ple, 0).ptr == op.ptr
    @test CC.getNumUserSpecifiedInitExprs(ple) == 1
    @test CC.getInitLoc(ple).ptr == loc.ptr
    @test_throws AssertionError CC.CXXParenListInitExpr(ctx, [op], intty, 2, loc, loc, loc)

    # ---- CXXUnresolvedConstructExpr::Create / CreateEmpty --------------------------
    uce = CC.CXXUnresolvedConstructExpr(ctx, intty, tsi, loc, [op], loc, false)
    @test uce isa CC.CXXUnresolvedConstructExpr
    @test CC.getStmtClassName(uce) == "CXXUnresolvedConstructExpr"
    @test CC.getNumArgs(uce) == 1
    @test CC.getArg(uce, 0).ptr == op.ptr
    @test CC.getLParenLoc(uce).ptr == loc.ptr
    @test CC.getRParenLoc(uce).ptr == loc.ptr
    @test CC.isListInitialization(uce) == false

    # ---- the deserialization shells: only the statement class is initialized -------
    shells = [(CC.CXXParenListInitExpr(ctx, 2), "CXXParenListInitExpr"),
              (CC.CXXUnresolvedConstructExpr(ctx, 2), "CXXUnresolvedConstructExpr"),
              (CC.CXXConstructExpr(ctx, 1), "CXXConstructExpr"),
              (CC.CXXTemporaryObjectExpr(ctx, 1), "CXXTemporaryObjectExpr"),
              (CC.CXXNewExpr(ctx, false, false, 0, false), "CXXNewExpr"),
              (CC.CXXDefaultArgExpr(ctx, false), "CXXDefaultArgExpr"),
              (CC.CXXDefaultInitExpr(ctx, false), "CXXDefaultInitExpr"),
              (CC.UserDefinedLiteral(ctx, 1, false), "UserDefinedLiteral"),
              (CC.CXXOperatorCallExpr(ctx, 2, false), "CXXOperatorCallExpr"),
              (CC.CXXMemberCallExpr(ctx, 1, false), "CXXMemberCallExpr"),
              (CC.UnresolvedLookupExpr(ctx, 1, false, 0), "UnresolvedLookupExpr"),
              (CC.FunctionParmPackExpr(ctx, 1), "FunctionParmPackExpr")]
    for (shell, name) in shells
        @test shell.ptr != C_NULL
        @test CC.getStmtClassName(shell) == name
    end

    dispose(f)
    dispose(I)
end

@testset "ExprCXX trait kind, cleanup objects, member name info and lifetime setters" begin
    I = create_interpreter(["-std=c++20"])
    f = DeclFinder(I)
    CC.parse(I, """
    struct OOTmp { OOTmp(); ~OOTmp(); int v; };
    struct OOBase { void m(int); void m(double); };
    typedef int OOInt;
    bool oo_trait() { return __is_trivial(int); }
    int oo_temp() { return OOTmp().v; }
    void oo_pd(OOInt *p) { p->OOInt::~OOInt(); }
    const int &oo_ref = 7;
    int oo_other = 3;
    template <class... Ts> int oo_pack() { return sizeof...(Ts); }
    template <class T> void oo_gg(T u) { OOBase s; s.m(u); }
    auto oo_lambda(int a) { return [a](int b) { return a + b; }; }
    auto oo_lambda2(int a) { return [=](int b) { return a + b; }; }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))

    function fn_body(name)
        @test f(I, name)
        return CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    end
    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- TypeTraitExpr::getTrait: which trait `__is_trivial(int)` spells -----------
    tt = _find_node(CC.TypeTraitExpr, fn_body("oo_trait"))
    @test tt isa CC.TypeTraitExpr
    if tt !== nothing
        @test CC.getTrait(tt) == CC.LibClangEx.CXTypeTrait_UTT_IsTrivial
        @test CC.getNumArgs(tt) == 1
    end

    # ---- LambdaExpr: `[a]` is one explicit capture, `[=]` captures implicitly ------
    le = _find_node(CC.LambdaExpr, fn_body("oo_lambda"))
    @test le isa CC.LambdaExpr
    if le !== nothing
        @test CC.getNumExplicitCaptures(le) == 1
        @test CC.getNumCaptures(le) >= CC.getNumExplicitCaptures(le)
    end
    le2 = _find_node(CC.LambdaExpr, fn_body("oo_lambda2"))
    @test le2 isa CC.LambdaExpr
    if le2 !== nothing
        @test CC.getNumExplicitCaptures(le2) == 0
        @test CC.getNumCaptures(le2) >= CC.getNumExplicitCaptures(le2)
    end

    # ---- UnresolvedMemberExpr: the member half of the OverloadExpr name -----------
    ume = _find_node(CC.UnresolvedMemberExpr, tpl_body("oo_gg"))
    @test ume isa CC.UnresolvedMemberExpr
    if ume !== nothing
        mn = CC.getMemberName(ume)
        @test CC.getAsString(mn) == "m"
        @test mn.ptr == CC.getName(ume).ptr          # forwards to OverloadExpr::getName
        @test CC.getMemberLoc(ume).ptr == CC.getNameLoc(ume).ptr
        mni = CC.getMemberNameInfo(ume)
        @test mni isa CC.DeclarationNameInfo
        @test mni.ptr != C_NULL
        @test CC.getAsString(mni) == "m"
        dispose(mni)
    end

    # ---- SizeOfPackExpr partial arguments: an unsubstituted pack has none, and
    # clang's accessor would read storage that was never allocated -----------------
    sp = _find_node(CC.SizeOfPackExpr, tpl_body("oo_pack"))
    @test sp isa CC.SizeOfPackExpr
    if sp !== nothing
        @test !(CC.isPartiallySubstituted(sp))
        if CC.isPartiallySubstituted(sp)
            n = CC.getNumPartialArguments(sp)
            @test n > 0
            ta = CC.getPartialArgument(sp, 0)
            @test ta isa CC.TemplateArgument
            @test ta.ptr != C_NULL
            dispose(ta)
            @test_throws AssertionError CC.getPartialArgument(sp, n)
        else
            @test_throws AssertionError CC.getNumPartialArguments(sp)
            @test_throws AssertionError CC.getPartialArgument(sp, 0)
        end
    end

    # ---- ExprWithCleanups objects: the union arm is picked by the discriminator ----
    ewc = _find_node(CC.ExprWithCleanups, fn_body("oo_temp"))
    @test ewc isa CC.ExprWithCleanups
    if ewc !== nothing
        n = CC.getNumObjects(ewc)
        @test n == 0
        for i = 0:(n - 1)
            isblk = CC.objectIsBlockDecl(ewc, i)
            @test isblk == false
            obj = CC.getObject(ewc, i)
            @test isblk ? obj isa CC.BlockDecl : obj isa CC.CompoundLiteralExpr
            @test obj.ptr != C_NULL
        end
        @test_throws AssertionError CC.objectIsBlockDecl(ewc, n)
        @test_throws AssertionError CC.getObject(ewc, n)
    end

    # the deserialization shell reserves its cleanup-object slots but fills none in
    shell = CC.ExprWithCleanups(ctx, 2)
    @test shell isa CC.ExprWithCleanups
    @test shell.ptr != C_NULL
    @test CC.getNumObjects(shell) == 2

    # ---- CXXPseudoDestructorExpr::setDestroyedType: naming the type by identifier
    # drops the written TypeSourceInfo, so the round-trip goes through the
    # identifier/location pair instead ---------------------------------------------
    pd = _find_node(CC.CXXPseudoDestructorExpr, fn_body("oo_pd"))
    @test pd isa CC.CXXPseudoDestructorExpr
    if pd !== nothing
        @test f(I, "OOInt")
        ii = CC.getIdentifier(get_decl(f))
        @test ii isa CC.IdentifierInfo
        @test CC.isStr(ii, "OOInt")
        loc = CC.getBeginLoc(pd)
        CC.setDestroyedType(pd, ii, loc)
        @test CC.getDestroyedTypeIdentifier(pd).ptr == ii.ptr
        @test CC.getDestroyedTypeLoc(pd).ptr == loc.ptr
        @test CC.getDestroyedTypeInfo(pd).ptr == C_NULL
    end

    # ---- MaterializeTemporaryExpr::setExtendingDecl -------------------------------
    @test f(I, "oo_ref")
    ref_init = CC.resolve(CC.getInit(CC.VarDecl(get_decl(f))))
    mt = _find_node(CC.MaterializeTemporaryExpr, ref_init)
    @test mt isa CC.MaterializeTemporaryExpr
    if mt !== nothing
        @test f(I, "oo_other")
        other = CC.VarDecl(get_decl(f))
        CC.setExtendingDecl(mt, other, 7)
        @test CC.getExtendingDecl(mt).ptr == other.ptr
        @test CC.getManglingNumber(mt) == 7
    end

    dispose(f)
    dispose(I)

    # ---- CoawaitExpr::setIsImplicit; coroutines need a promise type, so the
    # awaitable machinery is spelled out --------------------------------------------
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
    struct ootask {
        struct promise_type {
            ootask get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    ootask oo_coro() {
        co_await std::suspend_always{};
        co_return;
    }
    """)

    @test g(J, "oo_coro")
    croot = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(g))))
    ca = _find_node(CC.CoawaitExpr, croot)
    @test ca isa CC.CoawaitExpr
    if ca !== nothing
        before = CC.isImplicit(ca)
        @test before == false
        CC.setIsImplicit(ca, !before)
        @test CC.isImplicit(ca) == !before
        CC.setIsImplicit(ca, before)
        @test CC.isImplicit(ca) == before
    end

    dispose(g)
    dispose(J)
end

@testset "ExprCXX factories: call/construct/new/trait builders and deserialization shells" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    src = """
    struct FacPt { int x; FacPt(int v) : x(v) {} };
    FacPt fac_make(int v) { return FacPt(v); }
    int *fac_new() { return new int(3); }
    int fac_use(int a = 7);
    template <typename... FacTs> struct FacPack { };
    """
    CC.parse(I, src)
    ctx = CC.getASTContext(CC.get_instance(I))
    vk = CC.CXExprValueKind_VK_PRValue

    # A parsed, non-dependent int expression, reused below as a callee and as an argument.
    @test f(I, "fac_use")
    fu = CC.FunctionDecl(get_decl(f))
    param = CC.getParamDecl(fu, 0)
    @test CC.hasDefaultArg(param) == true
    op = CC.getDefaultArg(param)
    @test op isa CC.Expr_
    intty = CC.getType(op)
    loc = CC.getBeginLoc(op)
    tsi_int = CC.getTrivialTypeSourceInfo(ctx, intty, loc)
    @test tsi_int isa CC.TypeSourceInfo

    # ---- the CallExpr-shaped factories ---------------------------------------------
    oce = CC.CXXOperatorCallExpr(ctx, CC.CXOverloadedOperatorKind_OO_Plus, op, [op, op], intty, vk, loc, 0, false)
    @test CC.getStmtClassName(oce) == "CXXOperatorCallExpr"
    @test CC.getOperator(oce) == CC.CXOverloadedOperatorKind_OO_Plus
    @test CC.getOperatorLoc(oce).ptr == loc.ptr
    @test CC.getNumArgs(oce) == 2
    @test CC.getArg(oce, 0).ptr == op.ptr
    @test CC.getCallee(oce).ptr == op.ptr

    mce = CC.CXXMemberCallExpr(ctx, op, [op], intty, vk, loc, 0, 0)
    @test CC.getStmtClassName(mce) == "CXXMemberCallExpr"
    @test CC.getNumArgs(mce) == 1
    @test CC.getArg(mce, 0).ptr == op.ptr
    @test CC.getRParenLoc(mce).ptr == loc.ptr

    udl = CC.UserDefinedLiteral(ctx, op, [op], intty, vk, loc, loc, 0)
    @test CC.getStmtClassName(udl) == "UserDefinedLiteral"
    @test CC.getNumArgs(udl) == 1
    @test CC.getUDSuffixLoc(udl).ptr == loc.ptr

    # ---- CXXConstructExpr::Create / CXXTemporaryObjectExpr::Create ------------------
    @test f(I, "fac_make")
    fm = CC.FunctionDecl(get_decl(f))
    ce = _find_node(CC.AbstractCXXConstructExpr, CC.resolve(CC.getBody(fm)))
    @test ce isa CC.AbstractCXXConstructExpr
    ctor = CC.getConstructor(ce)
    pty = CC.getType(ce)
    arg0 = CC.getArg(ce, 0)
    brace = CC.getParenOrBraceRange(ce)

    nce = CC.CXXConstructExpr(ctx, pty, loc, ctor, false, [arg0], false, false, false, false,
                              CC.CXCXXConstructionKind_Complete, brace)
    @test CC.getStmtClassName(nce) == "CXXConstructExpr"
    @test CC.getConstructor(nce).ptr == ctor.ptr
    @test CC.getNumArgs(nce) == 1
    @test CC.getArg(nce, 0).ptr == arg0.ptr
    @test CC.getConstructionKind(nce) == CC.CXCXXConstructionKind_Complete
    @test CC.isElidable(nce) == false
    @test CC.requiresZeroInitialization(nce) == false

    tsi_pt = CC.getTrivialTypeSourceInfo(ctx, pty, loc)
    toe = CC.CXXTemporaryObjectExpr(ctx, ctor, pty, tsi_pt, [arg0], brace, false, true, false, false)
    @test CC.getStmtClassName(toe) == "CXXTemporaryObjectExpr"
    @test CC.getTypeSourceInfo(toe).ptr == tsi_pt.ptr
    @test CC.getNumArgs(toe) == 1
    @test CC.isListInitialization(toe) == true

    # ---- CXXNewExpr::Create, round-tripped through a parsed `new int(3)` ------------
    @test f(I, "fac_new")
    fnw = CC.FunctionDecl(get_decl(f))
    ne = _find_node(CC.CXXNewExpr, CC.resolve(CC.getBody(fnw)))
    @test ne isa CC.CXXNewExpr
    @test CC.isArray(ne) == false
    new_ne = CC.CXXNewExpr(ctx, CC.isGlobalNew(ne), CC.getOperatorNew(ne), CC.getOperatorDelete(ne),
                           CC.passAlignment(ne), CC.doesUsualArrayDeleteWantSize(ne), CC.Expr_[],
                           CC.getTypeIdParens(ne), nothing, CC.getInitializationStyle(ne), CC.getInitializer(ne),
                           CC.getType(ne), CC.getAllocatedTypeSourceInfo(ne), CC.getSourceRange(ne),
                           CC.getDirectInitRange(ne))
    @test CC.getStmtClassName(new_ne) == "CXXNewExpr"
    @test CC.getNumPlacementArgs(new_ne) == 0
    @test CC.isArray(new_ne) == false
    @test CC.isGlobalNew(new_ne) == CC.isGlobalNew(ne)
    @test CC.getInitializationStyle(new_ne) == CC.getInitializationStyle(ne)
    @test CC.getInitializer(new_ne).ptr == CC.getInitializer(ne).ptr
    @test CC.getAllocatedTypeSourceInfo(new_ne).ptr == CC.getAllocatedTypeSourceInfo(ne).ptr
    @test CC.getOperatorNew(new_ne).ptr == CC.getOperatorNew(ne).ptr

    # ---- TypeTraitExpr::Create ------------------------------------------------------
    tte = CC.TypeTraitExpr(ctx, intty, loc, CC.CXTypeTrait_UTT_IsConst, [tsi_int], loc, false)
    @test CC.getStmtClassName(tte) == "TypeTraitExpr"
    @test CC.getTrait(tte) == CC.CXTypeTrait_UTT_IsConst
    @test CC.getNumArgs(tte) == 1
    @test CC.getArg(tte, 0).ptr == tsi_int.ptr
    @test CC.getValue(tte) == false

    # ---- SizeOfPackExpr::Create, in both its known-length and partial forms ---------
    @test f(I, "FacPack")
    ctd = CC.ClassTemplateDecl(first(d for d in CC.get_decls(f) if CC.getDeclKindName(d) == "ClassTemplate"))
    pk = CC.getParam(CC.getTemplateParameters(ctd), 0)
    @test CC.getName(pk) == "FacTs"

    sop = CC.SizeOfPackExpr(ctx, loc, pk, loc, loc, 3)
    @test CC.getStmtClassName(sop) == "SizeOfPackExpr"
    @test CC.getPack(sop).ptr == pk.ptr
    @test CC.getPackLength(sop) == 3
    @test CC.isPartiallySubstituted(sop) == false
    @test CC.getOperatorLoc(sop).ptr == loc.ptr
    @test CC.getPackLoc(sop).ptr == loc.ptr

    ta = CC.TemplateArgument(intty)
    sop_partial = CC.SizeOfPackExpr(ctx, loc, pk, loc, loc, nothing, [ta])
    @test CC.isPartiallySubstituted(sop_partial) == true
    @test CC.getNumPartialArguments(sop_partial) == 1
    pa = CC.getPartialArgument(sop_partial, 0)
    @test pa isa CC.TemplateArgument
    dispose(pa)
    # A non-dependent sizeof... carries no partially-substituted arguments.
    @test_throws AssertionError CC.SizeOfPackExpr(ctx, loc, pk, loc, loc, 3, [ta])
    dispose(ta)

    # ---- the deserialization shells: only the statement class is initialized --------
    shells = [(CC.LambdaExpr(ctx, 1), "LambdaExpr"), (CC.TypeTraitExpr(ctx, 2), "TypeTraitExpr"),
              (CC.SizeOfPackExpr(ctx, 1), "SizeOfPackExpr"),
              (CC.CUDAKernelCallExpr(ctx, 1, false), "CUDAKernelCallExpr"),
              (CC.DependentScopeDeclRefExpr(ctx, false, 0), "DependentScopeDeclRefExpr"),
              (CC.CXXDependentScopeMemberExpr(ctx, false, 0, false), "CXXDependentScopeMemberExpr"),
              (CC.UnresolvedMemberExpr(ctx, 1, false, 0), "UnresolvedMemberExpr")]
    for (shell, name) in shells
        @test shell.ptr != C_NULL
        @test CC.getStmtClassName(shell) == name
    end

    dispose(f)
    dispose(I)
end

@testset "ExprCXX: lambda and kernel-launch builders, overload-set search, dependence refresh" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
    void oq_ovl(int);
    void oq_ovl(double);
    template <class T> void oq_call(T t) { oq_ovl(t); }
    auto oq_lambda(int cap) { return [cap](int b) { return cap + b; }; }
    int oq_use(int a = 5);
    int oq_callee();
    int oq_caller() { return oq_callee(); }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))
    vk = CC.CXExprValueKind_VK_PRValue

    # A parsed, non-dependent int expression, reused below as a callee and as an argument.
    @test f(I, "oq_use")
    fu = CC.FunctionDecl(get_decl(f))
    param = CC.getParamDecl(fu, 0)
    @test CC.hasDefaultArg(param) == true
    op = CC.getDefaultArg(param)
    @test op isa CC.Expr_
    intty = CC.getType(op)
    loc = CC.getBeginLoc(op)

    # ---- LambdaExpr::Create, round-tripped through a parsed lambda ------------------
    @test f(I, "oq_lambda")
    fl = CC.FunctionDecl(get_decl(f))
    le = _find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fl)))
    @test le isa CC.LambdaExpr
    cls = CC.getLambdaClass(le)
    inits = [CC.getCaptureInit(le, i) for i = 0:(CC.getNumCaptures(le) - 1)]
    le2 = CC.LambdaExpr(ctx, cls, CC.getIntroducerRange(le), CC.getCaptureDefault(le), CC.getCaptureDefaultLoc(le),
                        CC.hasExplicitParameters(le), CC.hasExplicitResultType(le), inits, CC.getEndLoc(le), false)
    @test CC.getStmtClassName(le2) == "LambdaExpr"
    @test CC.getLambdaClass(le2).ptr == cls.ptr
    @test CC.getNumCaptures(le2) == CC.getNumCaptures(le)
    @test CC.getCaptureInit(le2, 0).ptr == inits[1].ptr
    @test CC.getCaptureDefault(le2) == CC.getCaptureDefault(le)
    @test CC.getCaptureDefaultLoc(le2).ptr == CC.getCaptureDefaultLoc(le).ptr
    # the body is copied straight out of the closure's call operator
    @test CC.getBody(le2).ptr == CC.getBody(le).ptr
    # the initializer count is checked against the closure's own capture count
    @test_throws AssertionError CC.LambdaExpr(ctx, cls, CC.getIntroducerRange(le), CC.getCaptureDefault(le),
                                              CC.getCaptureDefaultLoc(le), false, false, CC.Expr_[], CC.getEndLoc(le),
                                              false)

    # ---- CUDAKernelCallExpr::Create and its configuration call ----------------------
    @test f(I, "oq_caller")
    fc = CC.FunctionDecl(get_decl(f))
    cfg = _find_node(CC.CallExpr, CC.resolve(CC.getBody(fc)))
    @test cfg isa CC.CallExpr
    kce = CC.CUDAKernelCallExpr(ctx, op, cfg, [op], intty, vk, loc, 0, 0)
    @test CC.getStmtClassName(kce) == "CUDAKernelCallExpr"
    @test CC.getConfig(kce).ptr == cfg.ptr
    @test CC.getNumArgs(kce) == 1
    @test CC.getArg(kce, 0).ptr == op.ptr
    @test CC.getCallee(kce).ptr == op.ptr
    @test CC.getRParenLoc(kce).ptr == loc.ptr

    # ---- OverloadExpr::find: the overload set behind an overload-typed expression ----
    @test f(I, "oq_call")
    ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
    body = CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    ule = _find_node(CC.UnresolvedLookupExpr, body)
    @test ule isa CC.UnresolvedLookupExpr
    found, address_of, member_pointer = CC.find(ule)
    @test found.ptr == ule.ptr
    @test CC.resolve(found) isa CC.UnresolvedLookupExpr
    @test address_of == false
    @test member_pointer == false
    # only an expression of the overload placeholder type may be searched
    @test_throws AssertionError CC.find(op)

    # ---- CXXParenListInitExpr::updateDependence -------------------------------------
    ple = CC.CXXParenListInitExpr(ctx, [op], intty, 1, loc, loc, loc)
    @test CC.getStmtClassName(ple) == "CXXParenListInitExpr"
    dependent = CC.isValueDependent(ple)
    @test CC.updateDependence(ple) === nothing
    @test CC.isValueDependent(ple) == dependent

    dispose(f)
    dispose(I)
end

@testset "Qualifier source locations: NestedNameSpecifierLoc on the qualified expressions" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
    namespace nq_ns { int nq_fn(int); int nq_fn(double); }
    struct NQBase { int qm; };
    template <class T> int nq_dsme(T t) { return t.NQBase::qm; }
    template <class T> int nq_dsdref() { return T::value; }
    template <class T> int nq_ule(T t) { return nq_ns::nq_fn(t); }
    typedef int NQInt;
    void nq_pdtor(NQInt *p) { p->NQInt::~NQInt(); }
    """)

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- a class-typed qualifier carries a TypeLoc: `t.NQBase::qm` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("nq_dsme"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    ql = CC.getQualifierLoc(dsme)
    @test ql isa CC.NestedNameSpecifierLoc
    @test ql.ptr != C_NULL
    @test CC.hasQualifier(ql) == true
    nns = CC.getNestedNameSpecifier(ql)
    @test nns isa CC.NestedNameSpecifier
    @test nns.ptr == CC.getQualifier(dsme).ptr   # the same specifier, now with locations
    let sr = CC.getSourceRange(ql)
        @test CC.isValid(sr)
        @test sr.begin_loc.ptr != C_NULL
        @test sr.end_loc.ptr != C_NULL
    end
    let lsr = CC.getLocalSourceRange(ql)
        @test CC.isValid(lsr)
        @test lsr.begin_loc.ptr != C_NULL
        @test lsr.end_loc.ptr != C_NULL
    end
    @test !CC.is_null_handle(CC.getBeginLoc(ql))
    @test CC.getBeginLoc(ql).ptr == CC.getSourceRange(ql).begin_loc.ptr
    @test !CC.is_null_handle(CC.getEndLoc(ql))
    @test CC.getEndLoc(ql).ptr == CC.getSourceRange(ql).end_loc.ptr
    @test !CC.is_null_handle(CC.getLocalBeginLoc(ql))
    @test CC.getLocalBeginLoc(ql).ptr == CC.getLocalSourceRange(ql).begin_loc.ptr
    @test !CC.is_null_handle(CC.getLocalEndLoc(ql))
    @test CC.getLocalEndLoc(ql).ptr == CC.getLocalSourceRange(ql).end_loc.ptr

    # `NQBase` is written at global scope, so this one component has an empty prefix
    pre = CC.getPrefix(ql)
    @test pre isa CC.NestedNameSpecifierLoc
    @test CC.hasQualifier(pre) == false
    @test CC.getNestedNameSpecifier(pre).ptr == C_NULL
    # an empty prefix carries no location either, so the box is the invalid one -- the
    # value that makes it a legal result rather than merely a well-typed one
    @test !CC.isValid(CC.getSourceRange(pre).begin_loc)
    CC.dispose(pre)

    # getTypeLoc is defined only for the two type-naming kinds, and which kind clang records
    # for a qualifier inside an uninstantiated template is its business — so branch on the
    # kind actually present and check that the wrapper's gate agrees with it either way.
    kq = CC.getKind(nns)
    @test kq isa CC.LibClangEx.CXNestedNameSpecifierKind
    if kq == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec ||
       kq == CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpecWithTemplate
        tl = CC.getTypeLoc(ql)
        @test tl isa CC.TypeLoc
        @test tl.ptr != C_NULL
        @test CC.isNull(tl) == false
        @test CC.getAsString(CC.getType(tl)) == "struct NQBase" || CC.getAsString(CC.getType(tl)) == "NQBase"
        CC.dispose(tl)
    else
        @test_throws AssertionError CC.getTypeLoc(ql)
    end
    CC.dispose(ql)

    # ---- a dependent `T::` qualifier is always written ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("nq_dsdref"))
    @test ds isa CC.DependentScopeDeclRefExpr
    if ds isa CC.DependentScopeDeclRefExpr
        dql = CC.getQualifierLoc(ds)
        @test dql isa CC.NestedNameSpecifierLoc
        @test CC.hasQualifier(dql) == true
        @test CC.getNestedNameSpecifier(dql).ptr == CC.getQualifier(ds).ptr
        let lsr = CC.getLocalSourceRange(dql)
            @test CC.isValid(lsr)
            @test lsr.begin_loc.ptr != C_NULL
        end
        CC.dispose(dql)
    end

    # ---- a namespace qualifier names no type, so getTypeLoc rejects it ----
    ule = _find_node(CC.UnresolvedLookupExpr, tpl_body("nq_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    if ule isa CC.UnresolvedLookupExpr
        # the OverloadExpr-declared accessor, reached from the subclass carrier
        uql = CC.getQualifierLoc(ule)
        @test uql isa CC.NestedNameSpecifierLoc
        @test CC.hasQualifier(uql) == true
        ku = CC.getKind(CC.getNestedNameSpecifier(uql))
        @test ku isa CC.LibClangEx.CXNestedNameSpecifierKind
        @test ku != CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpec
        @test ku != CC.LibClangEx.CXNestedNameSpecifierKind_TypeSpecWithTemplate
        @test_throws AssertionError CC.getTypeLoc(uql)
        CC.dispose(uql)
    end

    # ---- the pseudo-destructor's own hasQualifier and its location box agree ----
    @test f(I, "nq_pdtor")
    pbody = CC.resolve(CC.getBody(CC.FunctionDecl(first(CC.get_decls(f)))))
    pd = _find_node(CC.CXXPseudoDestructorExpr, pbody)
    @test pd isa CC.CXXPseudoDestructorExpr
    if pd isa CC.CXXPseudoDestructorExpr
        pql = CC.getQualifierLoc(pd)
        @test pql isa CC.NestedNameSpecifierLoc
        @test CC.hasQualifier(pql) == CC.hasQualifier(pd)
        let sr = CC.getSourceRange(pql)
            @test !CC.isValid(sr)
            @test CC.is_null_handle(sr.begin_loc)
        end
        if CC.hasQualifier(pql)
            let lsr = CC.getLocalSourceRange(pql)
                @test CC.isValid(lsr)
                @test lsr.begin_loc.ptr != C_NULL
            end
        else
            @test_throws AssertionError CC.getLocalSourceRange(pql)
        end
        CC.dispose(pql)
    end

    dispose(f)
    dispose(I)

    # ---- an unqualified MS property reference yields an empty location ----
    Ims = create_interpreter(["-fms-extensions"])
    fms = DeclFinder(Ims)
    CC.parse(Ims, """
    struct NQMS {
      int get_x();
      void put_x(int);
      __declspec(property(get = get_x, put = put_x)) int x;
    };
    int nq_ms(NQMS *p) { return p->x; }
    """)
    @test fms(Ims, "nq_ms")
    msb = CC.resolve(CC.getBody(CC.FunctionDecl(first(CC.get_decls(fms)))))
    mp = _find_node(CC.MSPropertyRefExpr, msb)
    @test mp isa CC.MSPropertyRefExpr
    if mp isa CC.MSPropertyRefExpr
        mql = CC.getQualifierLoc(mp)
        @test mql isa CC.NestedNameSpecifierLoc
        @test mql.ptr != C_NULL
        @test CC.hasQualifier(mql) == false          # `p->x` is written unqualified
        @test CC.is_null_handle(CC.getBeginLoc(mql))
        @test CC.is_null_handle(CC.getEndLoc(mql))
        @test_throws AssertionError CC.getLocalBeginLoc(mql)
        @test_throws AssertionError CC.getLocalEndLoc(mql)
        @test_throws AssertionError CC.getTypeLoc(mql)
        mpre = CC.getPrefix(mql)                     # an empty prefix walk terminates
        @test CC.hasQualifier(mpre) == false
        CC.dispose(mpre)
        CC.dispose(mql)
    end

    dispose(fms)
    dispose(Ims)
end

@testset "ExprCXX: dependent-name and overload-set builders" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
    struct CCSQ { void sm(int); void sm(double); };
    int cc_s_free(int);
    int cc_s_free(double);
    template <class U> int cc_s_tf(U);
    template <class T> int cc_s_dsdref() { return T::value; }
    template <class T> int cc_s_dsdref_t() { return T::template gg<int>(); }
    template <class T> int cc_s_dsme(T t) { return t.field; }
    template <class T> int cc_s_dsme_t(T t) { return t.template get<int>(); }
    template <class T> int cc_s_ule(T t) { return cc_s_free(t); }
    template <class T> int cc_s_ule_t(T t) { return cc_s_tf<int>(t); }
    template <class T> void cc_s_ume(T u) { CCSQ q; q.sm(u); }
    auto cc_s_lambda(int c) { return [c](int y) { return c + y; }; }
    """)
    ctx = CC.getASTContext(CC.get_instance(I))

    function tpl_body(name)
        @test f(I, name)
        ftd = CC.FunctionTemplateDecl(first(CC.get_decls(f)))
        return CC.resolve(CC.getBody(CC.FunctionDecl(CC.getTemplatedDecl(ftd))))
    end

    # ---- copyTemplateArgumentsInto on the three dependent-name carriers ----
    ds_t = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_s_dsdref_t"))
    @test ds_t isa CC.DependentScopeDeclRefExpr
    li = CC.TemplateArgumentListInfo(CC.getLAngleLoc(ds_t), CC.getRAngleLoc(ds_t))
    @test CC.size(li) == 0
    CC.copyTemplateArgumentsInto(ds_t, li)
    @test CC.size(li) == CC.getNumTemplateArgs(ds_t)
    @test CC.size(li) == 1                      # the `<int>` this test wrote
    CC.dispose(li)

    dsme_t = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_s_dsme_t"))
    @test dsme_t isa CC.CXXDependentScopeMemberExpr
    li2 = CC.TemplateArgumentListInfo(CC.getLAngleLoc(dsme_t), CC.getRAngleLoc(dsme_t))
    CC.copyTemplateArgumentsInto(dsme_t, li2)
    @test CC.size(li2) == CC.getNumTemplateArgs(dsme_t)
    CC.dispose(li2)

    ule_t = _find_node(CC.UnresolvedLookupExpr, tpl_body("cc_s_ule_t"))
    @test ule_t isa CC.UnresolvedLookupExpr
    li3 = CC.TemplateArgumentListInfo(CC.getLAngleLoc(ule_t), CC.getRAngleLoc(ule_t))
    CC.copyTemplateArgumentsInto(ule_t, li3)
    @test CC.size(li3) == CC.getNumTemplateArgs(ule_t)

    # a name written without an explicit `<...>` leaves the builder untouched
    ule = _find_node(CC.UnresolvedLookupExpr, tpl_body("cc_s_ule"))
    @test ule isa CC.UnresolvedLookupExpr
    li4 = CC.TemplateArgumentListInfo(CC.getLAngleLoc(ule), CC.getRAngleLoc(ule))
    CC.copyTemplateArgumentsInto(ule, li4)
    @test CC.size(li4) == 0
    CC.dispose(li4)

    # ---- DependentScopeDeclRefExpr::Create: rebuild `T::value` from its own parts ----
    ds = _find_node(CC.DependentScopeDeclRefExpr, tpl_body("cc_s_dsdref"))
    @test ds isa CC.DependentScopeDeclRefExpr
    q = CC.getQualifierLoc(ds)
    @test CC.hasQualifier(q)
    ni = CC.getNameInfo(ds)
    built = CC.DependentScopeDeclRefExpr(ctx, q, CC.getTemplateKeywordLoc(ds), ni)
    @test built isa CC.DependentScopeDeclRefExpr
    @test built.ptr != C_NULL
    @test CC.getDeclName(built).ptr == CC.getDeclName(ds).ptr
    @test CC.getQualifier(built).ptr == CC.getQualifier(ds).ptr
    @test CC.getNumTemplateArgs(built) == 0
    CC.dispose(ni)
    CC.dispose(q)

    # ---- CXXDependentScopeMemberExpr::Create: rebuild `t.field` ----
    dsme = _find_node(CC.CXXDependentScopeMemberExpr, tpl_body("cc_s_dsme"))
    @test dsme isa CC.CXXDependentScopeMemberExpr
    q2 = CC.getQualifierLoc(dsme)
    ni2 = CC.getMemberNameInfo(dsme)
    built2 = CC.CXXDependentScopeMemberExpr(ctx, CC.getBase(dsme), CC.getBaseType(dsme), false, CC.getOperatorLoc(dsme),
                                            q2, CC.getTemplateKeywordLoc(dsme), nothing, ni2)
    @test built2 isa CC.CXXDependentScopeMemberExpr
    @test built2.ptr != C_NULL
    @test CC.isArrow(built2) == false                    # the `false` this call passed
    @test CC.isImplicitAccess(built2) == false           # a non-null base was passed
    @test CC.getMember(built2).ptr == CC.getMember(dsme).ptr
    @test CC.getNumTemplateArgs(built2) == 0
    CC.dispose(ni2)
    CC.dispose(q2)

    # ---- UnresolvedLookupExpr::Create: rebuild the lookup of `cc_s_free` ----
    n = Int(CC.getNumDecls(ule))
    @test n >= 2                                          # cc_s_free(int) and cc_s_free(double)
    decls = [CC.getDecl(ule, i) for i = 0:(n - 1)]
    accs = [CC.getDeclAccess(ule, i) for i = 0:(n - 1)]
    q3 = CC.getQualifierLoc(ule)
    ni3 = CC.getNameInfo(ule)
    built3 = CC.UnresolvedLookupExpr(ctx, nothing, q3, ni3, true, true, decls, accs)
    @test built3 isa CC.UnresolvedLookupExpr
    @test built3.ptr != C_NULL
    @test Int(CC.getNumDecls(built3)) == n
    @test CC.requiresADL(built3) == true                  # the `true` this call passed
    @test CC.isOverloaded(built3)
    @test CC.getDecl(built3, 0).ptr == decls[1].ptr
    @test CC.getNumTemplateArgs(built3) == 0
    @test_throws AssertionError CC.UnresolvedLookupExpr(ctx, nothing, q3, ni3, true, true, CC.NamedDecl[],
                                                        CC.LibClangEx.CXAccessSpecifier[])
    @test_throws AssertionError CC.UnresolvedLookupExpr(ctx, nothing, q3, ni3, true, true, decls,
                                                        CC.LibClangEx.CXAccessSpecifier[])
    CC.dispose(ni3)
    CC.dispose(q3)

    # ---- the same builder with the written `<int>` copied out of `cc_s_tf<int>` ----
    nt = Int(CC.getNumDecls(ule_t))
    decls_t = [CC.getDecl(ule_t, i) for i = 0:(nt - 1)]
    accs_t = [CC.getDeclAccess(ule_t, i) for i = 0:(nt - 1)]
    q5 = CC.getQualifierLoc(ule_t)
    ni5 = CC.getNameInfo(ule_t)
    built5 = CC.UnresolvedLookupExpr(ctx, nothing, q5, CC.getTemplateKeywordLoc(ule_t), ni5, true, li3, decls_t, accs_t,
                                     true)
    @test built5 isa CC.UnresolvedLookupExpr
    @test built5.ptr != C_NULL
    @test Int(CC.getNumDecls(built5)) == nt
    @test CC.hasExplicitTemplateArgs(built5) == true
    @test Int(CC.getNumTemplateArgs(built5)) == Int(CC.size(li3))
    CC.dispose(ni5)
    CC.dispose(q5)
    CC.dispose(li3)

    # ---- UnresolvedMemberExpr::Create: rebuild the callee of `q.sm(u)` ----
    ume = _find_node(CC.UnresolvedMemberExpr, tpl_body("cc_s_ume"))
    @test ume isa CC.UnresolvedMemberExpr
    nm = Int(CC.getNumDecls(ume))
    @test nm >= 2                                         # sm(int) and sm(double)
    mdecls = [CC.getDecl(ume, i) for i = 0:(nm - 1)]
    maccs = [CC.getDeclAccess(ume, i) for i = 0:(nm - 1)]
    q4 = CC.getQualifierLoc(ume)
    ni4 = CC.getMemberNameInfo(ume)
    built4 = CC.UnresolvedMemberExpr(ctx, CC.hasUnresolvedUsing(ume), CC.getBase(ume), CC.getBaseType(ume),
                                     CC.isArrow(ume), CC.getOperatorLoc(ume), q4, CC.getTemplateKeywordLoc(ume), ni4,
                                     nothing, mdecls, maccs)
    @test built4 isa CC.UnresolvedMemberExpr
    @test built4.ptr != C_NULL
    @test Int(CC.getNumDecls(built4)) == nm
    @test CC.isArrow(built4) == CC.isArrow(ume)
    @test CC.isImplicitAccess(built4) == false            # a non-null base was passed
    @test CC.getDecl(built4, 0).ptr == mdecls[1].ptr
    CC.dispose(ni4)
    CC.dispose(q4)

    # ---- LambdaExpr capture ranges over the already-bound indexed accessors ----
    @test f(I, "cc_s_lambda")
    le = _find_node(CC.LambdaExpr, CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f)))))
    @test le isa CC.LambdaExpr
    ncap = Int(CC.getNumCaptures(le))
    nexp = Int(CC.getNumExplicitCaptures(le))
    @test Int(CC.capture_size(le)) == ncap
    @test length(CC.captures(le)) == ncap
    @test all(c -> c isa CC.LambdaCapture, CC.captures(le))
    @test length(CC.explicit_captures(le)) == nexp
    @test length(CC.implicit_captures(le)) == ncap - nexp
    @test [c.ptr for c in vcat(CC.explicit_captures(le), CC.implicit_captures(le))] == [c.ptr for c in CC.captures(le)]

    dispose(f)
    dispose(I)
end
