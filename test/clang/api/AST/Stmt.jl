using ClangCompiler
using ClangCompiler: create_interpreter, dispose, compile, DeclFinder, get_decl
using ClangCompiler: FunctionDecl, getBody, resolve, children, getChildren
using ClangCompiler: getStmtClass, getStmtClassName, getNumChildren
using ClangCompiler: getBeginLoc, getEndLoc, isExpr, isIfStmt, isValueStmt
using ClangCompiler: IfStmt, WhileStmt, ReturnStmt, CompoundStmt, DeclStmt, BinaryOperator, ImplicitCastExpr
using ClangCompiler: Expr_, getType, getValueKind, IgnoreParenImpCasts, get_name
using ClangCompiler: getCond, getThen, getElse, getBody, getRetValue, getLHS, getRHS
using ClangCompiler: getOpcode, getOpcodeStr, isComparisonOp, isSingleDecl, getSingleDecl
using ClangCompiler: getNumArgs, getDirectCallee, getMethodDecl, getCallOperator
using ClangCompiler: CXXMemberCallExpr, LambdaExpr, CallExpr, VarDecl, DeclRefExpr
using ClangCompiler: STMT_CLASS_TO_TYPE
using ClangCompiler.LibClangEx
using Test

@testset "Stmt/Expr payload accessors" begin
    I = create_interpreter()
    compile(I,
            """
            struct Widget {
                int m(int v) { return v + 1; }
            };
            int machine(int n) {
                Widget w;
                int acc = 0;
                while (n > 0) { acc += w.m(n); --n; }
                if (acc > 10) { return acc; } else { return [](int v) { return v; }(acc); }
            }
            """)
    lookup = DeclFinder(I)
    @test lookup(I, "machine")
    fd = FunctionDecl(get_decl(lookup).ptr)
    body = getBody(fd)

    # collect every node in the function body, resolved to concrete types
    nodes = ClangCompiler.AbstractStmt[]
    stack = ClangCompiler.AbstractStmt[resolve(body)]
    while !isempty(stack)
        node = pop!(stack)
        push!(nodes, node)
        append!(stack, children(node))
    end
    byT = T -> filter(n -> n isa T, nodes)

    # WhileStmt: cond is a comparison BinaryOperator
    ws = only(byT(WhileStmt))
    cond = resolve(getCond(ws))
    @test cond isa BinaryOperator
    @test isComparisonOp(cond)
    @test getOpcodeStr(cond) == ">"
    @test getOpcode(cond) == LibClangEx.CXBinaryOperatorKind_BO_GT
    @test resolve(getLHS(cond)) isa ImplicitCastExpr

    # IfStmt with else: then/else are compound statements
    ifs = only(byT(IfStmt))
    @test resolve(getThen(ifs)) isa CompoundStmt
    @test resolve(getElse(ifs)) isa CompoundStmt

    # member call: w.m(n) — method decl and arg count
    mces = byT(CXXMemberCallExpr)
    @test !isempty(mces)
    mce = first(mces)
    @test getNumArgs(mce) == 1
    @test get_name(getMethodDecl(mce)) == "m"

    # lambda: call operator arity (its name `operator()` is not a simple
    # identifier, so getName would assert — use the parameter count)
    le = only(byT(LambdaExpr))
    callop = getCallOperator(le)
    @test ClangCompiler.getNumParams(FunctionDecl(callop.ptr)) == 1

    # DeclStmt: `Widget w;` and `int acc = 0;` are single decls
    dss = byT(DeclStmt)
    @test length(dss) >= 2
    @test all(isSingleDecl, dss)

    # ReturnStmt payload (two in machine(), one inside the lambda body)
    rs = byT(ReturnStmt)
    @test length(rs) == 3
    @test all(r -> getRetValue(r).ptr != C_NULL, rs)

    dispose(lookup)
    dispose(I)
end

import ClangCompiler as CC
@testset "stamped Stmt predicate/cast surface" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ce2_g(int x) { if (x > 0) { return x + 1; } return 0; }")
    f = DeclFinder(I)
    @test f(I, "ce2_g")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    body = CC.Stmt(CC.getBody(fd).ptr)

    npred = ncast = 0
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        v = getproperty(CC, nm)
        if v isa Function && !(v isa Type) && startswith(String(nm), "is") &&
           hasmethod(v, Tuple{CC.Stmt})
            @test v(body) isa Bool
            npred += 1
        elseif v isa Type && v != CC.Stmt && hasmethod(v, Tuple{CC.Stmt}) &&
               which(v, Tuple{CC.Stmt}).sig <: Tuple{Type,CC.AbstractStmt}
            c = v(body)
            @test c isa v
            c.ptr == C_NULL || @test c isa CC.CompoundStmt
            ncast += 1
        end
    end
    @test npred >= 200
    @test ncast >= 200

    dispose(f)
    dispose(I)
end

@testset "Coverage | StmtExprCXX" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    struct Vec {
        int x;
        Vec() : x(0) {}
        Vec(int v) : x(v) {}
        Vec operator+(const Vec& o) const { return Vec(x + o.x); }
        int get() const { return x; }
        Vec* self() { return this; }
    };

    int control_flow(int n) {
        int total = 0;;
        int a = 1, b = 2;
        for (int i = 0; i < n; ++i) {
            if (i == 2) { continue; }
            if (i > 5) { break; }
            total += i;
        }
        int k = n;
        while (k > 0) { total += k; --k; }
        do { total += 1; } while (total < 3);
        switch (int sc = n; sc) {
            case 0: total += 100; break;
            case 1: total += 200; break;
            default: total += 300; break;
        }
        total += a + b;
        if (int iv = n; iv > 0) { return total; } else { return -total; }
    lbl:
        goto lbl;
    }

    Vec make_vecs(int n) {
        Vec a(1);
        Vec b = Vec(2);
        const Vec& r = Vec(3);
        Vec c = a + b;
        int g = c.get();
        int gg = Vec().get();
        Vec* p = new Vec(4);
        int* arr = new int[n];
        delete p;
        delete[] arr;
        bool flag = true;
        int s = static_cast<int>(c.x);
        auto lam = [g](int z) { return z + g; };
        int lr = lam(5);
        return Vec(g + s + lr + (flag ? 1 : 0));
    }
    """)

    finder = DeclFinder(I)

    # --- gather every resolved node across the two free functions and Vec's methods ---
    nodes = CC.AbstractStmt[]
    function gather!(fd)
        body = CC.getBody(fd)
        body.ptr == C_NULL && return
        append!(nodes, CC.subtree(body))
    end

    @test finder(I, "control_flow")
    cf = CC.FunctionDecl(get_decl(finder).ptr)
    gather!(cf)

    @test finder(I, "make_vecs")
    mv = CC.FunctionDecl(get_decl(finder).ptr)
    gather!(mv)

    @test finder(I, "Vec")
    vec = CC.CXXRecordDecl(get_decl(finder).ptr)
    for m in CC.getMethods(vec)
        fm = CC.FunctionDecl(m.ptr)
        CC.hasBody(fm) && gather!(fm)
    end

    pick(T) = filter(n -> n isa T, nodes)
    @test !isempty(nodes)

    # ================= Stmt.jl base + CompoundStmt =================
    body = CC.resolve(CC.getBody(cf))
    @test body isa CC.CompoundStmt

    # Stmt base wrappers (declared on Stmt)
    @test CC.getStmtClass(body) isa Any
    @test CC.getStmtClassName(body) == "CompoundStmt"
    @test CC.getBeginLoc(body) isa CC.SourceLocation
    @test CC.getEndLoc(body) isa CC.SourceLocation
    @test CC.getSourceRange(body) isa CC.SourceRange
    @test CC.getNumChildren(body) isa Integer
    @test CC.getChildren(body) isa Vector

    # generated predicates + casts (src/clang/api/AST/StmtWrappers.jl)
    @test CC.isCompoundStmt(body) isa Bool
    @test CC.isIfStmt(body) isa Bool
    @test CC.isExpr(body) isa Bool
    @test CC.CompoundStmt(body) isa CC.CompoundStmt         # castToCompoundStmt
    @test CC.IfStmt(body) isa CC.IfStmt                     # dyn_cast_or_null -> NULL carrier

    # CompoundStmt accessors
    @test length(body) isa Integer
    @test CC.body_front(body) isa CC.Stmt
    @test CC.body_back(body) isa CC.Stmt
    @test CC.getLBracLoc(body) isa CC.SourceLocation
    @test CC.getRBracLoc(body) isa CC.SourceLocation
    @test CC.body_empty(body) isa Bool
    @test CC.hasStoredFPFeatures(body) isa Bool

    # ================= DeclStmt =================
    dss = pick(CC.DeclStmt)
    @test !isempty(dss)
    single = first(filter(d -> CC.isSingleDecl(d), dss))
    @test CC.isSingleDecl(single) isa Bool
    @test CC.getSingleDecl(single) isa CC.Decl
    @test CC.getNumDecls(single) isa Integer
    @test CC.getDecls(single) isa Vector
    multi = first(filter(d -> CC.getNumDecls(d) > 1, dss))   # `int a = 1, b = 2;`
    @test CC.getNumDecls(multi) == 2

    # ================= IfStmt =================
    ifs = pick(CC.IfStmt)
    @test !isempty(ifs)
    ifi = first(ifs)
    @test CC.getCond(ifi) isa CC.Expr_
    @test CC.getThen(ifi) isa CC.Stmt
    @test CC.getElse(ifi) isa CC.Stmt
    @test CC.getInit(ifi) isa CC.Stmt
    @test CC.getConditionVariable(ifi) isa CC.VarDecl
    @test CC.hasElseStorage(ifi) isa Bool
    @test CC.hasInitStorage(ifi) isa Bool
    @test CC.hasVarStorage(ifi) isa Bool
    @test CC.getIfLoc(ifi) isa CC.SourceLocation
    @test CC.getElseLoc(ifi) isa CC.SourceLocation
    @test CC.isConsteval(ifi) isa Bool
    @test CC.isNonNegatedConsteval(ifi) isa Bool
    @test CC.isNegatedConsteval(ifi) isa Bool
    @test CC.isConstexpr(ifi) isa Bool
    @test CC.isObjCAvailabilityCheck(ifi) isa Bool
    @test CC.getLParenLoc(ifi) isa CC.SourceLocation
    @test CC.getRParenLoc(ifi) isa CC.SourceLocation

    # ================= SwitchStmt / SwitchCase / CaseStmt / DefaultStmt =================
    sw = first(pick(CC.SwitchStmt))
    @test CC.getCond(sw) isa CC.Expr_
    @test CC.getBody(sw) isa CC.Stmt
    scl = CC.getSwitchCaseList(sw)
    @test scl isa CC.SwitchCase
    @test CC.isAllEnumCasesCovered(sw) isa Bool
    @test CC.hasInitStorage(sw) isa Bool
    @test CC.hasVarStorage(sw) isa Bool
    @test CC.getSwitchLoc(sw) isa CC.SourceLocation
    @test CC.getLParenLoc(sw) isa CC.SourceLocation
    @test CC.getRParenLoc(sw) isa CC.SourceLocation
    # SwitchCase base accessors
    @test CC.getNextSwitchCase(scl) isa CC.SwitchCase
    @test CC.getSubStmt(scl) isa CC.Stmt
    @test CC.getKeywordLoc(scl) isa CC.SourceLocation
    @test CC.getColonLoc(scl) isa CC.SourceLocation
    # CaseStmt
    cs = first(pick(CC.CaseStmt))
    @test CC.getLHS(cs) isa CC.Expr_
    @test CC.getRHS(cs) isa CC.Expr_
    @test CC.caseStmtIsGNURange(cs) isa Bool
    @test CC.getCaseLoc(cs) isa CC.SourceLocation
    @test CC.getEllipsisLoc(cs) isa CC.SourceLocation
    # DefaultStmt
    ds = first(pick(CC.DefaultStmt))
    @test CC.getDefaultLoc(ds) isa CC.SourceLocation

    # ================= WhileStmt =================
    ws = first(pick(CC.WhileStmt))
    @test CC.getCond(ws) isa CC.Expr_
    @test CC.getBody(ws) isa CC.Stmt
    @test CC.getConditionVariable(ws) isa CC.VarDecl
    @test CC.getWhileLoc(ws) isa CC.SourceLocation
    @test CC.hasVarStorage(ws) isa Bool
    @test CC.getLParenLoc(ws) isa CC.SourceLocation
    @test CC.getRParenLoc(ws) isa CC.SourceLocation

    # ================= DoStmt =================
    do_ = first(pick(CC.DoStmt))
    @test CC.getCond(do_) isa CC.Expr_
    @test CC.getBody(do_) isa CC.Stmt
    @test CC.getDoLoc(do_) isa CC.SourceLocation
    @test CC.getWhileLoc(do_) isa CC.SourceLocation
    @test CC.getRParenLoc(do_) isa CC.SourceLocation

    # ================= ForStmt =================
    fs = first(pick(CC.ForStmt))
    @test CC.getInit(fs) isa CC.Stmt
    @test CC.getCond(fs) isa CC.Expr_
    @test CC.getInc(fs) isa CC.Expr_
    @test CC.getBody(fs) isa CC.Stmt
    @test CC.getConditionVariable(fs) isa CC.VarDecl
    @test CC.getForLoc(fs) isa CC.SourceLocation
    @test CC.getLParenLoc(fs) isa CC.SourceLocation
    @test CC.getRParenLoc(fs) isa CC.SourceLocation

    # ================= GotoStmt / LabelStmt =================
    gs = first(pick(CC.GotoStmt))
    @test CC.getLabel(gs) isa CC.LabelDecl
    @test CC.getGotoLoc(gs) isa CC.SourceLocation
    @test CC.getLabelLoc(gs) isa CC.SourceLocation
    ls = first(pick(CC.LabelStmt))
    @test CC.getName(ls) == "lbl"
    @test CC.getDecl(ls) isa CC.LabelDecl
    @test CC.getSubStmt(ls) isa CC.Stmt
    @test CC.getIdentLoc(ls) isa CC.SourceLocation
    @test CC.isSideEntry(ls) isa Bool

    # ================= ContinueStmt / BreakStmt =================
    cont = first(pick(CC.ContinueStmt))
    @test CC.getContinueLoc(cont) isa CC.SourceLocation
    brk = first(pick(CC.BreakStmt))
    @test CC.getBreakLoc(brk) isa CC.SourceLocation

    # ================= ReturnStmt =================
    rs = first(pick(CC.ReturnStmt))
    @test CC.getRetValue(rs) isa CC.Expr_
    @test CC.getReturnLoc(rs) isa CC.SourceLocation

    # ================= NullStmt =================
    ns = first(pick(CC.NullStmt))
    @test CC.getSemiLoc(ns) isa CC.SourceLocation
    @test CC.hasLeadingEmptyMacro(ns) isa Bool

    # ================= ExprCXX.jl =================

    # CXXConstructExpr (covers CXXTemporaryObjectExpr too)
    ces = pick(CC.AbstractCXXConstructExpr)
    @test !isempty(ces)
    ce = first(ces)
    @test CC.getConstructor(ce) isa CC.CXXConstructorDecl
    @test CC.getNumArgs(ce) isa Integer
    CC.getNumArgs(ce) > 0 && (@test CC.getArg(ce, 0) isa CC.Expr_)
    @test CC.isElidable(ce) isa Bool
    @test CC.getLocation(ce) isa CC.SourceLocation
    @test CC.hadMultipleCandidates(ce) isa Bool
    @test CC.isListInitialization(ce) isa Bool
    @test CC.isStdInitListInitialization(ce) isa Bool
    @test CC.requiresZeroInitialization(ce) isa Bool
    @test CC.isImmediateEscalating(ce) isa Bool
    @test CC.getConstructionKind(ce) !== nothing
    # CXXTemporaryObjectExpr specifically present (from zero-arg `Vec()`)
    @test !isempty(pick(CC.CXXTemporaryObjectExpr))

    # CXXMemberCallExpr — c.get()
    mce = first(pick(CC.CXXMemberCallExpr))
    @test CC.getImplicitObjectArgument(mce) isa CC.Expr_
    @test CC.getMethodDecl(mce) isa CC.CXXMethodDecl
    @test CC.getRecordDecl(mce) isa CC.CXXRecordDecl

    # CXXOperatorCallExpr — a + b
    oce = first(pick(CC.CXXOperatorCallExpr))
    @test CC.getOperator(oce) !== nothing
    @test CC.getOperatorLoc(oce) isa CC.SourceLocation

    # CXXBoolLiteralExpr — true
    ble = first(pick(CC.CXXBoolLiteralExpr))
    @test CC.getValue(ble) isa Bool
    @test CC.getLocation(ble) isa CC.SourceLocation

    # LambdaExpr — [g](int z){...}
    le = first(pick(CC.LambdaExpr))
    @test CC.getCallOperator(le) isa CC.CXXMethodDecl
    @test CC.getLambdaClass(le) isa CC.CXXRecordDecl
    @test CC.getBody(le) isa CC.Stmt
    @test CC.isMutable(le) isa Bool
    @test CC.getNumCaptures(le) isa Integer
    @test CC.isGenericLambda(le) isa Bool
    @test CC.getNumCaptures(le) >= 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.getCaptureKind(cap) !== nothing
    @test CC.capturesThis(cap) isa Bool
    @test CC.capturesVariable(cap) isa Bool
    @test CC.capturesVLAType(cap) isa Bool
    CC.capturesVariable(cap) && (@test CC.getCapturedVar(cap) isa CC.ValueDecl)

    # CXXNewExpr — new Vec(4) and new int[n]
    news = pick(CC.CXXNewExpr)
    @test length(news) >= 2
    for ne in news
        @test CC.getAllocatedType(ne) isa CC.QualType
        @test CC.isArray(ne) isa Bool
        @test CC.getArraySize(ne) isa CC.Expr_
        @test CC.hasInitializer(ne) isa Bool
        @test CC.getInitializer(ne) isa CC.Expr_
        @test CC.shouldNullCheckAllocation(ne) isa Bool
        @test CC.getNumPlacementArgs(ne) isa Integer
        @test CC.isParenTypeId(ne) isa Bool
        @test CC.isGlobalNew(ne) isa Bool
        @test CC.passAlignment(ne) isa Bool
        @test CC.doesUsualArrayDeleteWantSize(ne) isa Bool
        @test CC.getInitializationStyle(ne) !== nothing
        @test CC.getOperatorDelete(ne) isa CC.FunctionDecl
        @test CC.getOperatorNew(ne) isa CC.FunctionDecl
        @test CC.getAllocatedTypeSourceInfo(ne) isa CC.TypeSourceInfo
        @test CC.getConstructExpr(ne) isa CC.CXXConstructExpr
    end

    # CXXDeleteExpr — delete p; delete[] arr;
    dels = pick(CC.CXXDeleteExpr)
    @test length(dels) >= 2
    for de in dels
        @test CC.getArgument(de) isa CC.Expr_
        @test CC.isArrayForm(de) isa Bool
        @test CC.isGlobalDelete(de) isa Bool
        @test CC.isArrayFormAsWritten(de) isa Bool
        @test CC.doesUsualArrayDeleteWantSize(de) isa Bool
        @test CC.getDestroyedType(de) isa CC.QualType
        @test CC.getOperatorDelete(de) isa CC.FunctionDecl
    end

    # CastExpr — pick any (implicit or explicit) cast node
    caste = first(pick(CC.AbstractCastExpr))
    @test CC.path_empty(caste) isa Bool
    @test CC.path_size(caste) isa Integer
    @test CC.hasStoredFPFeatures(caste) isa Bool
    @test CC.changesVolatileQualification(caste) isa Bool
    @test CC.getConversionFunction(caste) isa CC.NamedDecl
    # getTargetUnionField is intentionally not called: clang asserts
    # (getCastKind() == CK_ToUnion) inside it, and a CK_ToUnion cast is a C-only
    # (GNU cast-to-union) construct unreachable from this C++ sample.

    # CXXNamedCastExpr — static_cast<int>(...)
    nce = first(pick(CC.AbstractCXXNamedCastExpr))
    @test CC.getOperatorLoc(nce) isa CC.SourceLocation
    @test CC.getRParenLoc(nce) isa CC.SourceLocation

    # CXXThisExpr — Vec::self() returns this
    tes = pick(CC.CXXThisExpr)
    @test !isempty(tes)
    te = first(tes)
    @test CC.getLocation(te) isa CC.SourceLocation
    @test CC.isImplicit(te) isa Bool

    # MaterializeTemporaryExpr — const Vec& r = Vec(3)
    mtes = pick(CC.MaterializeTemporaryExpr)
    @test !isempty(mtes)
    mte = first(mtes)
    @test CC.getManglingNumber(mte) isa Integer
    @test CC.isBoundToLvalueReference(mte) isa Bool
    @test CC.getExtendingDecl(mte) isa CC.ValueDecl
    @test CC.getSubExpr(mte) isa CC.Expr_

    dispose(finder)
    dispose(I)
end

@testset "IfStmt getNondiscardedCase (optional -> nullptr sentinel)" begin
    I = create_interpreter(["-std=c++20"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    int indc_f(int n) {
        if constexpr (sizeof(int) == 4) { return 1; } else { return 2; }
    }
    int indc_g(int n) {
        if (n > 0) { return 1; }
        return 0;
    }
    """)
    f = DeclFinder(I)
    findif(name) = begin
        @assert f(I, name)
        fd = CC.FunctionDecl(get_decl(f).ptr)
        node = CC.resolve(CC.getBody(fd))
        for c in CC.children(node)
            r = CC.resolve(c)
            r isa CC.IfStmt && return r
        end
        return nothing
    end

    # constexpr-if with a known condition: the kept branch comes back
    cif = findif("indc_f")
    @test cif isa CC.IfStmt
    kept = CC.getNondiscardedCase(cif, ctx)
    @test kept isa CC.Stmt
    @test kept.ptr != C_NULL
    @test CC.resolve(kept) isa CC.CompoundStmt

    # plain if: disengaged optional -> null carrier
    pif = findif("indc_g")
    @test pif isa CC.IfStmt
    @test CC.getNondiscardedCase(pif, ctx).ptr == C_NULL

    dispose(f)
    dispose(I)
end
