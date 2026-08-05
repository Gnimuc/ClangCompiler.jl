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
    fd = FunctionDecl(get_decl(lookup))
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
    @test ClangCompiler.getNumParams(FunctionDecl(callop)) == 1

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
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.Stmt(CC.getBody(fd))

    # `getBody` hands out a base-typed carrier, so `body`'s Julia type says nothing about the
    # node's class; `resolve` is what asks clang which class it is.
    r = CC.resolve(body)
    @test r isa CC.CompoundStmt

    npred = ncast = nmatch = 0
    for nm in names(CC; all=true)
        isdefined(CC, nm) || continue
        v = getproperty(CC, nm)
        if v isa Function && !(v isa Type) && startswith(String(nm), "is") &&
           hasmethod(v, Tuple{CC.Stmt})
            @test v(body) isa Bool
            npred += 1
        elseif v isa Type && v != CC.Stmt && hasmethod(v, Tuple{CC.Stmt}) &&
               which(v, Tuple{CC.Stmt}).sig <: Tuple{Type,CC.AbstractStmt}
            # The predicate and the cast are one question asked twice, `isa<T>` and `cast<T>`
            # off the same `classof` — and the Julia abstract mirroring that class is a third
            # spelling of it. Holding all three against each other for every statement class
            # is what says the generated hierarchy matches the one clang actually has.
            # `Expr_` carries clang's `Expr`; the predicate and the abstract keep the
            # undecorated spelling, so drop the Base-clash underscore before forming them
            cls = rstrip(String(nm), '_')
            absT = isdefined(CC, Symbol("Abstract", cls)) ? getproperty(CC, Symbol("Abstract", cls)) :
                   nothing
            if getproperty(CC, Symbol("is", cls))(body)
                absT === nothing || @test r isa absT
                @test v(body) == body            # narrows to the same clang::Stmt
                nmatch += 1
            else
                absT === nothing || @test !(r isa absT)
                @test_throws CC.CastError v(body)  # refused by name, not by a null carrier
            end
            ncast += 1
        end
    end
    @test npred >= 200
    @test ncast >= 200
    # StmtNodes.inc names the abstract bases too, so a compound statement matches its own class
    # and every base above it — here `Stmt` itself is excluded above, leaving exactly one
    @test nmatch == count(T -> r isa T, (CC.AbstractCompoundStmt,))

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
    cf = CC.FunctionDecl(get_decl(finder))
    gather!(cf)

    @test finder(I, "make_vecs")
    mv = CC.FunctionDecl(get_decl(finder))
    gather!(mv)

    @test finder(I, "Vec")
    vec = CC.CXXRecordDecl(get_decl(finder))
    for m in CC.getMethods(vec)
        fm = CC.FunctionDecl(m)
        CC.hasBody(fm) && gather!(fm)
    end

    pick(T) = filter(n -> n isa T, nodes)
    @test !isempty(nodes)

    # ================= Stmt.jl base + CompoundStmt =================
    body = CC.resolve(CC.getBody(cf))
    @test body isa CC.CompoundStmt

    # Stmt base wrappers (declared on Stmt)
    @test CC.getStmtClass(body) == LibClangEx.CXStmtClass_CompoundStmtClass
    @test CC.getStmtClassName(body) == "CompoundStmt"
    @test !CC.is_null_handle(CC.getBeginLoc(body))
    @test !CC.is_null_handle(CC.getEndLoc(body))
    sr = CC.getSourceRange(body)
    @test sr.begin_loc.ptr == CC.getBeginLoc(body).ptr
    @test sr.end_loc.ptr == CC.getEndLoc(body).ptr
    @test !CC.is_null_handle(sr.begin_loc)
    @test !CC.is_null_handle(sr.end_loc)
    @test CC.getNumChildren(body) == 11
    @test length(CC.getChildren(body)) == 11

    # generated predicates + casts (src/clang/api/AST/StmtWrappers.jl)
    @test CC.isCompoundStmt(body)
    @test !(CC.isIfStmt(body))
    @test !(CC.isExpr(body))
    @test CC.CompoundStmt(body) == body                    # cast<CompoundStmt>, same node
    @test_throws CC.CastError CC.IfStmt(body)              # and it names both classes

    # CompoundStmt accessors
    @test length(body) isa Integer
    @test !CC.is_null_handle(CC.body_front(body))
    @test !CC.is_null_handle(CC.body_back(body))
    @test !CC.is_null_handle(CC.getLBracLoc(body))
    @test !CC.is_null_handle(CC.getRBracLoc(body))
    @test !(CC.body_empty(body))
    @test CC.hasStoredFPFeatures(body) == false

    # ================= DeclStmt =================
    dss = pick(CC.DeclStmt)
    @test !isempty(dss)
    single = first(filter(d -> CC.isSingleDecl(d), dss))
    @test CC.isSingleDecl(single)
    @test !CC.is_null_handle(CC.getSingleDecl(single))
    @test CC.getNumDecls(single) == 1
    @test length(CC.getDecls(single)) == 1
    multi = first(filter(d -> CC.getNumDecls(d) > 1, dss))   # `int a = 1, b = 2;`
    @test CC.getNumDecls(multi) == 2

    # ================= IfStmt =================
    ifs = pick(CC.IfStmt)
    @test !isempty(ifs)
    ifi = first(ifs)
    @test !CC.is_null_handle(CC.getCond(ifi))
    @test !CC.is_null_handle(CC.getThen(ifi))
    @test CC.is_null_handle(CC.getElse(ifi))
    @test CC.is_null_handle(CC.getInit(ifi))
    @test CC.is_null_handle(CC.getConditionVariable(ifi))
    @test !(CC.hasElseStorage(ifi))
    @test !(CC.hasInitStorage(ifi))
    @test !(CC.hasVarStorage(ifi))
    @test !CC.is_null_handle(CC.getIfLoc(ifi))
    @test CC.is_null_handle(CC.getElseLoc(ifi))
    @test !(CC.isConsteval(ifi))
    @test !(CC.isNonNegatedConsteval(ifi))
    @test !(CC.isNegatedConsteval(ifi))
    @test !(CC.isConstexpr(ifi))
    @test !(CC.isObjCAvailabilityCheck(ifi))
    @test !CC.is_null_handle(CC.getLParenLoc(ifi))
    @test !CC.is_null_handle(CC.getRParenLoc(ifi))

    # ================= SwitchStmt / SwitchCase / CaseStmt / DefaultStmt =================
    sw = first(pick(CC.SwitchStmt))
    @test !CC.is_null_handle(CC.getCond(sw))
    @test CC.resolve(CC.getBody(sw)) isa CC.CompoundStmt
    scl = CC.getSwitchCaseList(sw)
    @test scl isa CC.SwitchCase
    @test CC.resolve(scl) isa CC.DefaultStmt
    @test !(CC.isAllEnumCasesCovered(sw))
    @test CC.hasInitStorage(sw)
    @test !(CC.hasVarStorage(sw))
    @test !CC.is_null_handle(CC.getSwitchLoc(sw))
    @test !CC.is_null_handle(CC.getLParenLoc(sw))
    @test !CC.is_null_handle(CC.getRParenLoc(sw))
    # SwitchCase base accessors
    @test !CC.is_null_handle(CC.getNextSwitchCase(scl))
    @test CC.getSubStmt(scl) isa CC.Stmt
    @test !CC.is_null_handle(CC.getKeywordLoc(scl))
    @test !CC.is_null_handle(CC.getColonLoc(scl))
    # CaseStmt
    cs = first(pick(CC.CaseStmt))
    @test !CC.is_null_handle(CC.getLHS(cs))
    @test CC.is_null_handle(CC.getRHS(cs))
    @test !(CC.caseStmtIsGNURange(cs))
    @test !CC.is_null_handle(CC.getCaseLoc(cs))
    @test CC.is_null_handle(CC.getEllipsisLoc(cs))
    # DefaultStmt
    ds = first(pick(CC.DefaultStmt))
    @test !CC.is_null_handle(CC.getDefaultLoc(ds))

    # ================= WhileStmt =================
    ws = first(pick(CC.WhileStmt))
    @test !CC.is_null_handle(CC.getCond(ws))
    @test CC.getBody(ws) isa CC.Stmt
    @test CC.is_null_handle(CC.getConditionVariable(ws))
    @test !CC.is_null_handle(CC.getWhileLoc(ws))
    @test !(CC.hasVarStorage(ws))
    @test !CC.is_null_handle(CC.getLParenLoc(ws))
    @test !CC.is_null_handle(CC.getRParenLoc(ws))

    # ================= DoStmt =================
    do_ = first(pick(CC.DoStmt))
    @test !CC.is_null_handle(CC.getCond(do_))
    @test CC.getBody(do_) isa CC.Stmt
    @test !CC.is_null_handle(CC.getDoLoc(do_))
    @test !CC.is_null_handle(CC.getWhileLoc(do_))
    @test !CC.is_null_handle(CC.getRParenLoc(do_))

    # ================= ForStmt =================
    fs = first(pick(CC.ForStmt))
    @test CC.getInit(fs) isa CC.Stmt
    @test !CC.is_null_handle(CC.getCond(fs))
    @test !CC.is_null_handle(CC.getInc(fs))
    @test CC.getBody(fs) isa CC.Stmt
    @test CC.is_null_handle(CC.getConditionVariable(fs))
    @test !CC.is_null_handle(CC.getForLoc(fs))
    @test !CC.is_null_handle(CC.getLParenLoc(fs))
    @test !CC.is_null_handle(CC.getRParenLoc(fs))

    # ================= GotoStmt / LabelStmt =================
    gs = first(pick(CC.GotoStmt))
    @test CC.getLabel(gs) isa CC.LabelDecl
    @test !CC.is_null_handle(CC.getGotoLoc(gs))
    @test !CC.is_null_handle(CC.getLabelLoc(gs))
    ls = first(pick(CC.LabelStmt))
    @test CC.getName(ls) == "lbl"
    @test CC.getDecl(ls) isa CC.LabelDecl
    @test CC.getSubStmt(ls) isa CC.Stmt
    @test !CC.is_null_handle(CC.getIdentLoc(ls))
    @test !(CC.isSideEntry(ls))

    # ================= ContinueStmt / BreakStmt =================
    cont = first(pick(CC.ContinueStmt))
    @test !CC.is_null_handle(CC.getContinueLoc(cont))
    brk = first(pick(CC.BreakStmt))
    @test !CC.is_null_handle(CC.getBreakLoc(brk))

    # ================= ReturnStmt =================
    rs = first(pick(CC.ReturnStmt))
    @test !CC.is_null_handle(CC.getRetValue(rs))
    @test !CC.is_null_handle(CC.getReturnLoc(rs))

    # ================= NullStmt =================
    ns = first(pick(CC.NullStmt))
    @test !CC.is_null_handle(CC.getSemiLoc(ns))
    @test !(CC.hasLeadingEmptyMacro(ns))

    # ================= ExprCXX.jl =================

    # CXXConstructExpr (covers CXXTemporaryObjectExpr too)
    ces = pick(CC.AbstractCXXConstructExpr)
    @test !isempty(ces)
    ce = first(ces)
    @test !CC.is_null_handle(CC.getConstructor(ce))
    @test CC.getNumArgs(ce) == 1
    CC.getNumArgs(ce) > 0 && (@test CC.getArg(ce, 0) isa CC.Expr_)
    @test !(CC.isElidable(ce))
    @test !CC.is_null_handle(CC.getLocation(ce))
    @test CC.hadMultipleCandidates(ce)
    @test !(CC.isListInitialization(ce))
    @test !(CC.isStdInitListInitialization(ce))
    @test !(CC.requiresZeroInitialization(ce))
    @test !(CC.isImmediateEscalating(ce))
    @test CC.getConstructionKind(ce) == LibClangEx.CXCXXConstructionKind_Complete
    # CXXTemporaryObjectExpr specifically present (from zero-arg `Vec()`)
    @test !isempty(pick(CC.CXXTemporaryObjectExpr))

    # CXXMemberCallExpr — c.get()
    mce = first(pick(CC.CXXMemberCallExpr))
    @test !CC.is_null_handle(CC.getImplicitObjectArgument(mce))
    @test !CC.is_null_handle(CC.getMethodDecl(mce))
    @test !CC.is_null_handle(CC.getRecordDecl(mce))

    # CXXOperatorCallExpr — a + b
    oce = first(pick(CC.CXXOperatorCallExpr))
    @test CC.getOperator(oce) == LibClangEx.CXOverloadedOperatorKind_OO_Plus
    @test !CC.is_null_handle(CC.getOperatorLoc(oce))

    # CXXBoolLiteralExpr — true
    ble = first(pick(CC.CXXBoolLiteralExpr))
    @test CC.getValue(ble) isa Bool
    @test !CC.is_null_handle(CC.getLocation(ble))

    # LambdaExpr — [g](int z){...}
    le = first(pick(CC.LambdaExpr))
    @test !CC.is_null_handle(CC.getCallOperator(le))
    @test !CC.is_null_handle(CC.getLambdaClass(le))
    @test CC.getBody(le) isa CC.Stmt
    @test !(CC.isMutable(le))
    @test CC.getNumCaptures(le) == 1
    @test !(CC.isGenericLambda(le))
    @test CC.getNumCaptures(le) >= 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.getCaptureKind(cap) == LibClangEx.CXLambdaCaptureKind_LCK_ByCopy
    @test !(CC.capturesThis(cap))
    @test CC.capturesVariable(cap)
    @test !(CC.capturesVLAType(cap))
    CC.capturesVariable(cap) && (@test CC.getCapturedVar(cap) isa CC.ValueDecl && get_name(CC.getCapturedVar(cap)) == "g")

    # CXXNewExpr — new Vec(4) and new int[n]
    news = pick(CC.CXXNewExpr)
    @test length(news) >= 2
    for ne in news
        @test !CC.is_null_handle(CC.getAllocatedType(ne))
        @test CC.isArray(ne) == (CC.getArraySize(ne).ptr != C_NULL)
        @test CC.getArraySize(ne) isa CC.Expr_
        @test CC.hasInitializer(ne) == (CC.getInitializer(ne).ptr != C_NULL)
        @test (CC.getInitializer(ne).ptr != C_NULL) == CC.hasInitializer(ne)
        @test !(CC.shouldNullCheckAllocation(ne))
        @test CC.getNumPlacementArgs(ne) == 0
        @test !(CC.isParenTypeId(ne))
        @test !(CC.isGlobalNew(ne))
        @test CC.passAlignment(ne) == false
        @test CC.doesUsualArrayDeleteWantSize(ne) == false
        @test CC.getInitializationStyle(ne) in (LibClangEx.CXCXXNewInitializationStyle_Parens, LibClangEx.CXCXXNewInitializationStyle_None)
        @test !CC.is_null_handle(CC.getOperatorDelete(ne))
        @test !CC.is_null_handle(CC.getOperatorNew(ne))
        @test !CC.is_null_handle(CC.getAllocatedTypeSourceInfo(ne))
        @test (CC.getConstructExpr(ne).ptr != C_NULL) == (!CC.isArray(ne) && CC.hasInitializer(ne))
    end

    # CXXDeleteExpr — delete p; delete[] arr;
    dels = pick(CC.CXXDeleteExpr)
    @test length(dels) >= 2
    for de in dels
        @test !CC.is_null_handle(CC.getArgument(de))
        @test CC.isArrayForm(de) == CC.isArrayFormAsWritten(de)
        @test !(CC.isGlobalDelete(de))
        @test CC.isArrayFormAsWritten(de) in (true, false)
        @test CC.doesUsualArrayDeleteWantSize(de) == false
        @test !CC.is_null_handle(CC.getDestroyedType(de))
        @test !CC.is_null_handle(CC.getOperatorDelete(de))
    end

    # CastExpr — pick any (implicit or explicit) cast node
    caste = first(pick(CC.AbstractCastExpr))
    @test CC.path_empty(caste)
    @test CC.path_size(caste) == 0
    @test CC.hasStoredFPFeatures(caste) == false
    @test !(CC.changesVolatileQualification(caste))
    @test CC.is_null_handle(CC.getConversionFunction(caste))
    # getTargetUnionField is intentionally not called: clang asserts
    # (getCastKind() == CK_ToUnion) inside it, and a CK_ToUnion cast is a C-only
    # (GNU cast-to-union) construct unreachable from this C++ sample.

    # CXXNamedCastExpr — static_cast<int>(...)
    nce = first(pick(CC.AbstractCXXNamedCastExpr))
    @test !CC.is_null_handle(CC.getOperatorLoc(nce))
    @test !CC.is_null_handle(CC.getRParenLoc(nce))

    # CXXThisExpr — Vec::self() returns this
    tes = pick(CC.CXXThisExpr)
    @test !isempty(tes)
    te = first(tes)
    @test !CC.is_null_handle(CC.getLocation(te))
    @test CC.isImplicit(te)

    # MaterializeTemporaryExpr — const Vec& r = Vec(3)
    mtes = pick(CC.MaterializeTemporaryExpr)
    @test !isempty(mtes)
    mte = first(mtes)
    @test CC.getManglingNumber(mte) == 1
    @test CC.isBoundToLvalueReference(mte)
    @test !CC.is_null_handle(CC.getExtendingDecl(mte))
    @test !CC.is_null_handle(CC.getSubExpr(mte))

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
        fd = CC.FunctionDecl(get_decl(f))
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

@testset "GCCAsmStmt tail: operands, labels and asm-goto" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)

    # GCCAsmStmt. Inline-asm acceptance is target-dependent, so both blocks below
    # only assert once the statement actually parsed and was found on this host.
    findasm = function (name)
        f(I, name) || return nothing
        body = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        body.ptr == C_NULL && return nothing
        for c in CC.children(body)
            r = CC.resolve(c)
            r isa CC.GCCAsmStmt && return r
        end
        return nothing
    end

    CC.parse(I, "void asmHost(int a, int b) { asm(\"\" : \"=r\"(b) : [in] \"r\"(a)); }")
    asm = findasm("asmHost")
    if asm !== nothing
        @test !CC.is_null_handle(CC.getRParenLoc(asm))
        @test CC.getNumLabels(asm) == 0
        @test CC.getNamedOperand(asm, "nosuchoperand") == -1
        @test CC.getNamedOperand(asm, "in") >= 0
        if CC.getNumInputs(asm) > 0
            e = CC.getInputExpr(asm, 0)
            CC.setInputExpr(asm, 0, e)  # identity write-back round-trip
            @test CC.getInputExpr(asm, 0).ptr == e.ptr
        end
    end

    CC.parse(I, "void asmGotoHost() { asm goto (\"\" : : : : Done); Done: ; }")
    gasm = findasm("asmGotoHost")
    if gasm !== nothing && CC.isAsmGoto(gasm)
        @test CC.getNumLabels(gasm) == 1
        @test !CC.is_null_handle(CC.getLabelExpr(gasm, 0))
        @test CC.getLabelExpr(gasm, 0).ptr != C_NULL
        @test CC.getLabelName(gasm, 0) == "Done"
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Stmt subclass tail: getExprStmt / getStmtExprResult / NRVO / indirect goto" begin
    I = CC.create_interpreter()
    CC.compile(I,
               """
               int stmt_tail_probe(int n) {
                   int local = n + 1;
                   local += 2;
                   return local;
               }
               """)
    f = CC.DeclFinder(I)
    @test f(I, "stmt_tail_probe")
    fd = CC.FunctionDecl(CC.get_decl(f))
    bodyc = CC.resolve(CC.getBody(fd))
    @test bodyc isa CC.CompoundStmt

    # collect every node in the body, resolved to concrete carriers
    nodes = CC.AbstractStmt[]
    stack = CC.AbstractStmt[bodyc]
    while !isempty(stack)
        node = pop!(stack)
        push!(nodes, node)
        append!(stack, CC.children(node))
    end

    # CompoundStmt::getStmtExprResult -- last non-null child of the body
    res = CC.getStmtExprResult(bodyc)
    @test res isa CC.AbstractStmt
    @test res.ptr == CC.body_back(bodyc).ptr

    # ReturnStmt::getNRVOCandidate -- shape only (host decides whether NRVO storage exists)
    rs = only(filter(n -> n isa CC.ReturnStmt, nodes))
    @test CC.is_null_handle(CC.getNRVOCandidate(rs))

    # ValueStmt::getExprStmt -- a bare expression statement returns itself
    e = first(filter(n -> n isa CC.AbstractExpr, nodes))
    es = CC.getExprStmt(e)
    @test es isa CC.Expr_
    @test es.ptr == e.ptr

    # IndirectGotoStmt -- computed goto / labels-as-values are GNU extensions, so
    # only assert once the host dialect accepted the statement and it was found.
    CC.parse(I,
             """
             int stmt_tail_goto(int n) {
                 int local = n;
                 goto *&&done;
             done:
                 return local;
             }
             """)
    igs = nothing
    if f(I, "stmt_tail_goto")
        gbody = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        if gbody.ptr != C_NULL
            gstack = CC.AbstractStmt[CC.resolve(gbody)]
            while !isempty(gstack)
                nd = pop!(gstack)
                if nd isa CC.IndirectGotoStmt
                    igs = nd
                    break
                end
                append!(gstack, CC.children(nd))
            end
        end
    end
    if igs !== nothing
        @test CC.getTarget(igs) isa CC.Expr_
        @test CC.getTarget(igs).ptr != C_NULL
        tgt_lbl = CC.getConstantTarget(igs)
        @test tgt_lbl isa CC.LabelDecl
        @test !CC.is_null_handle(tgt_lbl)
        @test get_name(tgt_lbl) == "done"
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Stmt SEH/Captured/condition-variable payload accessors" begin
    # --- condition-variable DeclStmts (plain C++) ---
    Icv = create_interpreter()
    CC.parse(Icv, "void cv_fn(int n){ while (int w = n) { --n; } for (int i = 0; int c = n - i; ++i) {} }")
    fcv = DeclFinder(Icv)
    @test fcv(Icv, "cv_fn")
    cfd = CC.FunctionDecl(get_decl(fcv))
    cnodes = CC.subtree(CC.resolve(CC.getBody(cfd)))
    ws = cnodes[findfirst(n -> n isa CC.WhileStmt, cnodes)]
    fs = cnodes[findfirst(n -> n isa CC.ForStmt, cnodes)]
    @test !CC.is_null_handle(CC.getConditionVariableDeclStmt(ws))
    @test CC.getConditionVariableDeclStmt(ws).ptr != C_NULL         # while (int w = n)
    @test !CC.is_null_handle(CC.getConditionVariableDeclStmt(fs))
    @test CC.getConditionVariableDeclStmt(fs).ptr != C_NULL         # for (...; int c = ...; ...)
    dispose(fcv)
    dispose(Icv)

    # --- SEH statements (Microsoft extensions; parse-only, no codegen) ---
    Iseh = create_interpreter(["-fms-extensions"])
    CC.parse(Iseh, "void seh_fn(){ __try { __leave; } __except(1) { } __try { } __finally { } }")
    fseh = DeclFinder(Iseh)
    @test fseh(Iseh, "seh_fn")
    sfd = CC.FunctionDecl(get_decl(fseh))
    snodes = CC.subtree(CC.resolve(CC.getBody(sfd)))
    tries = filter(n -> n isa CC.SEHTryStmt, snodes)
    excepts = filter(n -> n isa CC.SEHExceptStmt, snodes)
    finallys = filter(n -> n isa CC.SEHFinallyStmt, snodes)
    leaves = filter(n -> n isa CC.SEHLeaveStmt, snodes)
    @test length(tries) == 2
    @test length(excepts) == 1
    @test length(finallys) == 1
    @test length(leaves) == 1

    tryX = first(filter(t -> CC.getExceptHandler(t).ptr != C_NULL, tries))   # __except form
    tryF = first(filter(t -> CC.getFinallyHandler(t).ptr != C_NULL, tries))  # __finally form
    @test !(CC.getIsCXXTry(tryX))
    @test !CC.getIsCXXTry(tryX)                                     # __try, not C++ try
    @test !CC.is_null_handle(CC.getTryLoc(tryX))
    @test CC.getTryBlock(tryX) isa CC.CompoundStmt
    @test CC.getHandler(tryX) isa CC.Stmt
    @test !CC.is_null_handle(CC.getExceptHandler(tryX))
    @test CC.getExceptHandler(tryX).ptr != C_NULL
    @test CC.getFinallyHandler(tryX).ptr == C_NULL
    @test !CC.is_null_handle(CC.getFinallyHandler(tryF))
    @test CC.getFinallyHandler(tryF).ptr != C_NULL

    ex = excepts[1]
    @test !CC.is_null_handle(CC.getExceptLoc(ex))
    @test !CC.is_null_handle(CC.getFilterExpr(ex))
    @test CC.getFilterExpr(ex).ptr != C_NULL
    @test CC.getBlock(ex) isa CC.CompoundStmt

    fin = finallys[1]
    @test !CC.is_null_handle(CC.getFinallyLoc(fin))
    @test CC.getBlock(fin) isa CC.CompoundStmt

    @test !CC.is_null_handle(CC.getLeaveLoc(leaves[1]))
    dispose(fseh)
    dispose(Iseh)

    # --- CapturedStmt (OpenMP region; parse-only) ---
    Iomp = create_interpreter(["-fopenmp"])
    CC.parse(Iomp, "void omp_fn(int n){\n#pragma omp parallel\n{ int x = n; }\n}")
    fomp = DeclFinder(Iomp)
    @test fomp(Iomp, "omp_fn")
    ofd = CC.FunctionDecl(get_decl(fomp))
    cs = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(ofd)))
        n isa CC.CapturedStmt && (cs = n; break)
    end
    @test cs isa CC.CapturedStmt
    @test !CC.is_null_handle(CC.getCapturedStmt(cs))
    @test CC.getCapturedStmt(cs).ptr != C_NULL
    @test !CC.is_null_handle(CC.getCapturedDecl(cs))
    @test CC.getCapturedDecl(cs).ptr != C_NULL
    @test !CC.is_null_handle(CC.getCapturedRecordDecl(cs))
    @test CC.getCapturedRecordDecl(cs).ptr != C_NULL
    @test CC.capture_size(cs) == 1
    @test CC.capture_size(cs) >= 1                                  # captures n
    paramN = CC.getParamDecl(ofd, 0)                               # the `int n` ParmVarDecl
    @test CC.capturesVariable(cs, paramN)
    @test CC.capturesVariable(cs, paramN)                          # n is captured
    dispose(fomp)
    dispose(Iomp)
end

@testset "AsmStmt/GCCAsmStmt operand literals + AttributedStmt attrs" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)

    # Inline-asm acceptance is target-dependent, so assert only once the statement
    # actually parsed and was located on this host.
    findasm = function (name)
        f(I, name) || return nothing
        body = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        body.ptr == C_NULL && return nothing
        for c in CC.children(body)
            r = CC.resolve(c)
            r isa CC.GCCAsmStmt && return r
        end
        return nothing
    end

    # A "+" (read/write) output, a named input and a clobber exercise every new
    # operand accessor.
    CC.parse(I, "void asmRW(int a, int b) { asm(\"\" : \"+r\"(b) : [in] \"r\"(a) : \"memory\"); }")
    a = findasm("asmRW")
    if a !== nothing
        @test CC.isOutputPlusConstraint(a, 0)
        @test CC.isOutputPlusConstraint(a, 0)
        @test CC.getNumPlusOperands(a) == 1
        @test !CC.is_null_handle(CC.getOutputConstraintLiteral(a, 0))
        @test CC.getOutputConstraintLiteral(a, 0).ptr != C_NULL
        @test CC.is_null_handle(CC.getOutputIdentifier(a, 0))
        @test CC.getOutputIdentifier(a, 0).ptr == C_NULL              # output has no [name]
        if CC.getNumInputs(a) > 0
            @test !CC.is_null_handle(CC.getInputIdentifier(a, 0))
            @test CC.getInputIdentifier(a, 0).ptr != C_NULL           # named [in]
            @test !CC.is_null_handle(CC.getInputConstraintLiteral(a, 0))
            @test CC.getInputConstraintLiteral(a, 0).ptr != C_NULL
        end
        if CC.getNumClobbers(a) > 0
            @test !CC.is_null_handle(CC.getClobberStringLiteral(a, 0))
            @test CC.getClobberStringLiteral(a, 0).ptr != C_NULL
        end
    end

    CC.parse(I, "void asmGotoLbl() { asm goto (\"\" : : : : Done); Done: ; }")
    g = findasm("asmGotoLbl")
    if g !== nothing && CC.isAsmGoto(g)
        @test CC.getNumLabels(g) == 1
        @test !CC.is_null_handle(CC.getLabelIdentifier(g, 0))
        @test CC.getLabelIdentifier(g, 0).ptr != C_NULL              # label `Done`
    end

    # AttributedStmt: a statement-level attribute wraps its substatement.
    CC.parse(I, "void attrG(); void attrProbe() { [[clang::nomerge]] attrG(); }")
    astmt = nothing
    if f(I, "attrProbe")
        abody = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        if abody.ptr != C_NULL
            for n in CC.subtree(CC.resolve(abody))
                if n isa CC.AttributedStmt
                    astmt = n
                    break
                end
            end
        end
    end
    if astmt !== nothing
        @test !CC.is_null_handle(CC.getAttrLoc(astmt))
        na = CC.getNumAttrs(astmt)
        @test na == 1
        attrs = CC.getAttrs(astmt)
        @test length(attrs) == na == 1
        @test all(x -> x isa CC.Attr, attrs)
        @test all(x -> x.ptr != C_NULL, attrs)
    end

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Stmt printing/likelihood tail + statement setters" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             int stmtTailProbe(int n) {
                 int acc = 0;
                 while (n > 0) {
                     switch (n) {
                     case 1:
                         break;
                     default:
                         ;
                     }
                     --n;
                     continue;
                 }
             lbl:
                 ;
                 return acc;
             }
             """)
    f = DeclFinder(I)
    @test f(I, "stmtTailProbe")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    nodes = CC.subtree(body)
    pick(T) = filter(n -> n isa T, nodes)

    # Stmt: pretty printing goes through the context's own PrintingPolicy
    pp = CC.printPretty(body, ctx)
    @test pp isa String
    @test occursin("switch", pp)
    @test occursin("return", pp)
    @test !isempty(CC.printPretty(body, ctx, 2))

    # printJson is the pretty-printed text, escaped (and optionally quoted)
    js = CC.printJson(body, ctx)
    @test js isa String
    @test occursin("return", js)
    @test !isempty(CC.printJson(body, ctx, false))

    # Stmt: the node identifier is stable per node and distinct between nodes
    id = CC.getID(body, ctx)
    @test CC.getID(body, ctx) == id && id != 0
    ret = only(pick(CC.ReturnStmt))
    @test CC.getID(ret, ctx) != id

    ok = redirect_stderr(devnull) do
        CC.dumpPretty(body, ctx) === nothing
    end
    @test ok

    # Stmt: the body holds four statements, so it is not a no-op container and
    # IgnoreContainers hands it back unchanged.
    kept = CC.IgnoreContainers(body)
    @test kept isa CC.Stmt
    @test kept.ptr == body.ptr
    @test CC.IgnoreContainers(body, true).ptr == body.ptr

    ls = only(pick(CC.LabelStmt))
    stripped = CC.stripLabelLikeStatements(ls)
    @test stripped isa CC.Stmt
    @test stripped.ptr == CC.getSubStmt(ls).ptr
    @test CC.resolve(stripped) isa CC.NullStmt

    # Stmt: nothing in this function carries [[likely]]/[[unlikely]]
    @test CC.getLikelihood(body) == LibClangEx.CXLikelihood_LH_None
    @test CC.getLikelihood(body) == CC.LibClangEx.CXLikelihood_LH_None
    @test CC.is_null_handle(CC.getLikelihoodAttr(body))
    @test CC.getLikelihoodAttr(body).ptr == C_NULL

    # DeclStmt: the group behind `int acc = 0;`
    ds = only(pick(CC.DeclStmt))
    dg = CC.getDeclGroup(ds)
    @test dg isa CC.DeclGroupRef
    @test !CC.isNull(dg)
    @test CC.isSingleDecl(dg) == CC.isSingleDecl(ds)

    # Setters: write back the value the test itself read, then read it again.
    cs = only(pick(CC.CaseStmt))
    kw = CC.getKeywordLoc(cs)
    CC.setKeywordLoc(cs, kw)
    @test CC.getKeywordLoc(cs).ptr == kw.ptr
    cl = CC.getColonLoc(cs)
    CC.setColonLoc(cs, cl)
    @test CC.getColonLoc(cs).ptr == cl.ptr
    lhs = CC.getLHS(cs)
    @test lhs.ptr != C_NULL
    CC.setLHS(cs, lhs)
    @test CC.getLHS(cs).ptr == lhs.ptr
    csub = CC.getSubStmt(cs)
    CC.setSubStmt(cs, csub)
    @test CC.getSubStmt(cs).ptr == csub.ptr

    # setRHS is partial: only a GNU `case LHS ... RHS:` has the range-end slot.
    @test !CC.caseStmtIsGNURange(cs)
    @test_throws AssertionError CC.setRHS(cs, lhs)

    dflt = only(pick(CC.DefaultStmt))
    dsub = CC.getSubStmt(dflt)
    CC.setSubStmt(dflt, dsub)
    @test CC.getSubStmt(dflt).ptr == dsub.ptr

    lsub = CC.getSubStmt(ls)
    CC.setSubStmt(ls, lsub)
    @test CC.getSubStmt(ls).ptr == lsub.ptr

    ns = first(pick(CC.NullStmt))
    sl = CC.getSemiLoc(ns)
    CC.setSemiLoc(ns, sl)
    @test CC.getSemiLoc(ns).ptr == sl.ptr

    bs = only(pick(CC.BreakStmt))
    bl = CC.getBreakLoc(bs)
    CC.setBreakLoc(bs, bl)
    @test CC.getBreakLoc(bs).ptr == bl.ptr

    cont = only(pick(CC.ContinueStmt))
    cll = CC.getContinueLoc(cont)
    CC.setContinueLoc(cont, cll)
    @test CC.getContinueLoc(cont).ptr == cll.ptr

    rv = CC.getRetValue(ret)
    @test rv.ptr != C_NULL
    CC.setRetValue(ret, rv)
    @test CC.getRetValue(ret).ptr == rv.ptr

    # A GNU `case LHS ... RHS:` is the one shape setRHS accepts. Acceptance of the
    # extension is a host/driver decision, so assert only once it actually parsed.
    CC.parse(I, "int stmtRangeProbe(int n) { switch (n) { case 2 ... 4: return 1; } return 0; }")
    if f(I, "stmtRangeProbe")
        rbody = CC.getBody(CC.FunctionDecl(get_decl(f)))
        if rbody.ptr != C_NULL
            rng = nothing
            for node in CC.subtree(CC.resolve(rbody))
                if node isa CC.CaseStmt && CC.caseStmtIsGNURange(node)
                    rng = node
                    break
                end
            end
            if rng !== nothing
                rrhs = CC.getRHS(rng)
                @test rrhs.ptr != C_NULL
                CC.setRHS(rng, rrhs)
                @test CC.getRHS(rng).ptr == rrhs.ptr
            end
        end
    end

    dispose(f)
    dispose(I)
end

@testset "Stmt location setters + CompoundStmt stored FP features" begin
    I = create_interpreter()
    CC.parse(I, """
             int stmtLocSetterProbe(int n) {
                 int acc = 0;
                 if (n > 0) {
                     acc = 1;
                 } else {
                     acc = 2;
                 }
                 if (n == 7)
                     acc = 3;
                 switch (n) {
                 case 1:
                     acc = 4;
                     break;
                 }
                 while (n > 0)
                     --n;
                 do {
                     ++n;
                 } while (n < 2);
                 for (int i = 0; i < 2; ++i)
                     acc += i;
                 return acc;
             }
             """)
    f = DeclFinder(I)
    @test f(I, "stmtLocSetterProbe")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    nodes = CC.subtree(body)
    pick(T) = filter(n -> n isa T, nodes)

    # Every location setter below writes back the location the test itself read, so
    # the AST is left unchanged and the assertion is a pure round-trip.
    ifs = pick(CC.IfStmt)
    @test length(ifs) == 2
    with_else = only(filter(CC.hasElseStorage, ifs))
    no_else = only(filter(!CC.hasElseStorage, ifs))

    ifloc = CC.getIfLoc(with_else)
    CC.setIfLoc(with_else, ifloc)
    @test CC.getIfLoc(with_else).ptr == ifloc.ptr
    iflp = CC.getLParenLoc(with_else)
    CC.setLParenLoc(with_else, iflp)
    @test CC.getLParenLoc(with_else).ptr == iflp.ptr
    ifrp = CC.getRParenLoc(with_else)
    CC.setRParenLoc(with_else, ifrp)
    @test CC.getRParenLoc(with_else).ptr == ifrp.ptr

    # setElseLoc is partial: the trailing slot exists only with else storage.
    elseloc = CC.getElseLoc(with_else)
    @test elseloc.ptr != C_NULL
    CC.setElseLoc(with_else, elseloc)
    @test CC.getElseLoc(with_else).ptr == elseloc.ptr
    @test !CC.hasElseStorage(no_else)
    @test_throws AssertionError CC.setElseLoc(no_else, elseloc)

    sw = only(pick(CC.SwitchStmt))
    swloc = CC.getSwitchLoc(sw)
    CC.setSwitchLoc(sw, swloc)
    @test CC.getSwitchLoc(sw).ptr == swloc.ptr
    swlp = CC.getLParenLoc(sw)
    CC.setLParenLoc(sw, swlp)
    @test CC.getLParenLoc(sw).ptr == swlp.ptr
    swrp = CC.getRParenLoc(sw)
    CC.setRParenLoc(sw, swrp)
    @test CC.getRParenLoc(sw).ptr == swrp.ptr

    # The all-enum-cases-covered flag is one-way — clang has no setter for the false
    # state — so only the value this test writes is asserted.
    @test !(CC.isAllEnumCasesCovered(sw))
    CC.setAllEnumCasesCovered(sw)
    @test CC.isAllEnumCasesCovered(sw)

    wh = only(pick(CC.WhileStmt))
    whloc = CC.getWhileLoc(wh)
    CC.setWhileLoc(wh, whloc)
    @test CC.getWhileLoc(wh).ptr == whloc.ptr
    whlp = CC.getLParenLoc(wh)
    CC.setLParenLoc(wh, whlp)
    @test CC.getLParenLoc(wh).ptr == whlp.ptr
    whrp = CC.getRParenLoc(wh)
    CC.setRParenLoc(wh, whrp)
    @test CC.getRParenLoc(wh).ptr == whrp.ptr

    dw = only(pick(CC.DoStmt))
    doloc = CC.getDoLoc(dw)
    CC.setDoLoc(dw, doloc)
    @test CC.getDoLoc(dw).ptr == doloc.ptr
    dwwh = CC.getWhileLoc(dw)
    CC.setWhileLoc(dw, dwwh)
    @test CC.getWhileLoc(dw).ptr == dwwh.ptr
    dwrp = CC.getRParenLoc(dw)
    CC.setRParenLoc(dw, dwrp)
    @test CC.getRParenLoc(dw).ptr == dwrp.ptr

    fo = only(pick(CC.ForStmt))
    forloc = CC.getForLoc(fo)
    CC.setForLoc(fo, forloc)
    @test CC.getForLoc(fo).ptr == forloc.ptr
    folp = CC.getLParenLoc(fo)
    CC.setLParenLoc(fo, folp)
    @test CC.getLParenLoc(fo).ptr == folp.ptr
    forp = CC.getRParenLoc(fo)
    CC.setRParenLoc(fo, forp)
    @test CC.getRParenLoc(fo).ptr == forp.ptr

    # DeclStmt keeps its own start/end pair; Stmt::getBeginLoc reads StartLoc back.
    ds = first(pick(CC.DeclStmt))
    dstart = CC.getBeginLoc(ds)
    CC.setStartLoc(ds, dstart)
    @test CC.getBeginLoc(ds).ptr == dstart.ptr
    dend = CC.getEndLoc(ds)
    CC.setEndLoc(ds, dend)
    @test CC.getEndLoc(ds).ptr == dend.ptr

    # CompoundStmt: the trailing FPOptionsOverride slot exists only when the body
    # changed the floating-point options, and getStoredFPFeatures asserts on it.
    @test CC.hasStoredFPFeatures(body) == false
    if CC.hasStoredFPFeatures(body)
        @test CC.getStoredFPFeatures(body) != 0
    else
        @test_throws AssertionError CC.getStoredFPFeatures(body)
    end

    # A `#pragma clang fp` inside a body is what allocates that slot. Acceptance of
    # the pragma is a host/driver decision, so assert only once it actually parsed.
    CC.parse(I, """
             double stmtFPProbe(double a, double b, double c) {
                 #pragma clang fp contract(fast)
                 return a * b + c;
             }
             """)
    if f(I, "stmtFPProbe")
        fpbody = CC.getBody(CC.FunctionDecl(get_decl(f)))
        if fpbody.ptr != C_NULL
            fpcs = CC.resolve(fpbody)
            if fpcs isa CC.CompoundStmt && CC.hasStoredFPFeatures(fpcs)
                fpv = CC.getStoredFPFeatures(fpcs)
                @test fpv != 0
                # The slot exists exactly when the override mask is nonzero, and that
                # mask is the low half of the encoding.
                @test fpv != 0
                @test CC.getStoredFPFeatures(fpcs) == fpv
            end
        end
    end

    dispose(f)
    dispose(I)
end

@testset "CapturedStmt captures + goto/label setters" begin
    # --- CapturedStmt::Capture (OpenMP region; parse-only) ---
    Iomp = create_interpreter(["-fopenmp"])
    CC.parse(Iomp, "void capProbe(int n){ int m = n + 1;\n#pragma omp parallel\n{ int x = n + m; }\n}")
    fomp = DeclFinder(Iomp)
    @test fomp(Iomp, "capProbe")
    ofd = CC.FunctionDecl(get_decl(fomp))
    cs = nothing
    for nd in CC.subtree(CC.resolve(CC.getBody(ofd)))
        nd isa CC.CapturedStmt && (cs = nd; break)
    end
    @test cs isa CC.CapturedStmt

    # region kind, written back with the value the test itself read
    @test CC.getCapturedRegionKind(cs) == LibClangEx.CXCapturedRegionKind_CR_OpenMP
    @test CC.getCapturedRegionKind(cs) == LibClangEx.CXCapturedRegionKind_CR_OpenMP
    CC.setCapturedRegionKind(cs, CC.getCapturedRegionKind(cs))
    @test CC.getCapturedRegionKind(cs) == LibClangEx.CXCapturedRegionKind_CR_OpenMP

    ncaps = CC.capture_size(cs)
    @test ncaps >= 2                                            # n and m are captured
    caps = [CC.getCapture(cs, i) for i in 0:(ncaps - 1)]
    @test all(c -> c isa CC.CapturedStmtCapture, caps)
    @test all(c -> c.ptr != C_NULL, caps)
    @test_throws AssertionError CC.getCapture(cs, ncaps)

    for c in caps
        @test CC.getCaptureKind(c) isa LibClangEx.CXVariableCaptureKind
        @test !CC.is_null_handle(CC.getLocation(c))
        # the four forms partition the capture kinds: exactly one of them holds
        forms = [CC.capturesThis(c), CC.capturesVariable(c),
                 CC.capturesVariableByCopy(c), CC.capturesVariableArrayType(c)]
        @test count(forms) == 1
        @test count(forms) == 1
    end

    varcaps = filter(c -> CC.capturesVariable(c) || CC.capturesVariableByCopy(c), caps)
    @test length(varcaps) >= 2
    @test all(c -> CC.getCapturedVar(c) isa CC.VarDecl, varcaps)
    @test all(c -> CC.getCapturedVar(c).ptr != C_NULL, varcaps)
    @test issubset(Set(["n", "m"]), Set(get_name(CC.getCapturedVar(c)) for c in varcaps))

    inits = [CC.getCaptureInit(cs, i) for i in 0:(ncaps - 1)]
    @test all(e -> e isa CC.Expr_, inits)
    @test any(e -> e.ptr != C_NULL, inits)
    @test_throws AssertionError CC.getCaptureInit(cs, ncaps)
    dispose(fomp)
    dispose(Iomp)

    # --- goto / label setters (every write puts back the value just read) ---
    I = create_interpreter()
    CC.parse(I, """
             void gotoLabelProbe(int n) {
             loop:
                 --n;
                 if (n > 0) goto loop;
                 void *tgt = &&loop;
                 if (n < -1) goto *tgt;
             done:
                 ;
             }
             """)
    f = DeclFinder(I)
    @test f(I, "gotoLabelProbe")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.resolve(CC.getBody(fd)))

    labels = filter(x -> x isa CC.LabelStmt, nodes)
    @test length(labels) == 2
    ls = first(labels)
    il = CC.getIdentLoc(ls)
    CC.setIdentLoc(ls, il)
    @test CC.getIdentLoc(ls).ptr == il.ptr
    ld = CC.getDecl(ls)
    @test ld isa CC.LabelDecl
    CC.setDecl(ls, ld)
    @test CC.getDecl(ls).ptr == ld.ptr
    se = CC.isSideEntry(ls)
    @test se == false
    CC.setSideEntry(ls, true)
    @test CC.isSideEntry(ls)
    CC.setSideEntry(ls, se)                                     # restore
    @test CC.isSideEntry(ls) == se

    gs = only(filter(x -> x isa CC.GotoStmt, nodes))
    lab = CC.getLabel(gs)
    @test lab isa CC.LabelDecl
    CC.setLabel(gs, lab)
    @test CC.getLabel(gs).ptr == lab.ptr
    gl = CC.getGotoLoc(gs)
    CC.setGotoLoc(gs, gl)
    @test CC.getGotoLoc(gs).ptr == gl.ptr
    ll = CC.getLabelLoc(gs)
    CC.setLabelLoc(gs, ll)
    @test CC.getLabelLoc(gs).ptr == ll.ptr

    igs = only(filter(x -> x isa CC.IndirectGotoStmt, nodes))
    igl = CC.getGotoLoc(igs)
    CC.setGotoLoc(igs, igl)
    @test CC.getGotoLoc(igs).ptr == igl.ptr
    sl = CC.getStarLoc(igs)
    CC.setStarLoc(igs, sl)
    @test CC.getStarLoc(igs).ptr == sl.ptr
    tgt = CC.getTarget(igs)
    @test tgt isa CC.Expr_
    CC.setTarget(igs, tgt)
    @test CC.getTarget(igs).ptr == tgt.ptr
    dispose(f)
    dispose(I)
end

@testset "Stmt condition-variable / statement-kind / asm / SEH / captured setters" begin
    I = create_interpreter()
    CC.parse(I, """
             int stmtMutatorProbe(int n) {
                 int acc = 0;
                 if (int v = n) { acc += v; }
                 if constexpr (sizeof(int) > 0) { acc += 1; }
                 if (n > 0) { acc += 2; }
                 switch (int s = n) {
                 case 1:
                     acc = 4;
                     break;
                 case 2 ... 4:
                     acc = 5;
                     break;
                 default:
                     acc = 6;
                     break;
                 }
                 while (int w = n) { --n; }
                 for (int i = 0; int c = n - i; ++i) { acc += c; }
                 return acc;
             }
             """)
    f = DeclFinder(I)
    @test f(I, "stmtMutatorProbe")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.resolve(CC.getBody(fd)))
    pick(T) = filter(n -> n isa T, nodes)

    # Every setter below writes back the value the test itself read, so the AST is left
    # unchanged and each assertion is a pure round-trip.

    # --- IfStmt: statement kind + condition-variable DeclStmt ---
    ifs = pick(CC.IfStmt)
    @test length(ifs) == 3
    @test map(CC.getStatementKind, ifs) == [CC.LibClangEx.CXIfStatementKind_Ordinary, CC.LibClangEx.CXIfStatementKind_Constexpr, CC.LibClangEx.CXIfStatementKind_Ordinary]
    @test length(filter(i -> CC.getStatementKind(i) ==
                             CC.LibClangEx.CXIfStatementKind_Constexpr, ifs)) == 1
    @test length(filter(i -> CC.getStatementKind(i) ==
                             CC.LibClangEx.CXIfStatementKind_Constexpr, ifs)) == 1
    withvar = only(filter(CC.hasVarStorage, ifs))
    kind = CC.getStatementKind(withvar)
    @test kind == CC.LibClangEx.CXIfStatementKind_Ordinary
    CC.setStatementKind(withvar, kind)
    @test CC.getStatementKind(withvar) == kind

    ifcv = CC.getConditionVariableDeclStmt(withvar)
    @test ifcv isa CC.DeclStmt
    @test ifcv.ptr != C_NULL
    CC.setConditionVariableDeclStmt(withvar, ifcv)
    @test CC.getConditionVariableDeclStmt(withvar).ptr == ifcv.ptr
    novar = filter(!CC.hasVarStorage, ifs)
    @test !isempty(novar)
    @test_throws AssertionError CC.setConditionVariableDeclStmt(novar[1], ifcv)

    # --- DeclStmt: the decl group of the condition variable ---
    dg = CC.getDeclGroup(ifcv)
    @test dg isa CC.DeclGroupRef
    @test dg.ptr != C_NULL
    CC.setDeclGroup(ifcv, dg)
    @test CC.getDeclGroup(ifcv).ptr == dg.ptr

    # --- SwitchStmt: condition variable + case list ---
    sw = only(pick(CC.SwitchStmt))
    @test CC.hasVarStorage(sw)
    swcv = CC.getConditionVariableDeclStmt(sw)
    @test swcv isa CC.DeclStmt
    @test swcv.ptr != C_NULL
    CC.setConditionVariableDeclStmt(sw, swcv)
    @test CC.getConditionVariableDeclStmt(sw).ptr == swcv.ptr

    firstcase = CC.getSwitchCaseList(sw)
    @test firstcase isa CC.SwitchCase
    @test firstcase.ptr != C_NULL
    CC.setSwitchCaseList(sw, firstcase)
    @test CC.getSwitchCaseList(sw).ptr == firstcase.ptr
    nxt = CC.getNextSwitchCase(firstcase)
    @test nxt isa CC.SwitchCase
    @test nxt.ptr != C_NULL
    CC.setNextSwitchCase(firstcase, nxt)
    @test CC.getNextSwitchCase(firstcase).ptr == nxt.ptr

    # --- CaseStmt / DefaultStmt keyword locations ---
    cases = pick(CC.CaseStmt)
    @test !isempty(cases)
    caseloc = CC.getCaseLoc(cases[1])
    CC.setCaseLoc(cases[1], caseloc)
    @test CC.getCaseLoc(cases[1]).ptr == caseloc.ptr
    plain = filter(c -> !CC.caseStmtIsGNURange(c), cases)
    @test !isempty(plain)
    @test_throws AssertionError CC.setEllipsisLoc(plain[1], caseloc)
    gnu = filter(CC.caseStmtIsGNURange, cases)   # `case 2 ... 4` is a GNU extension
    if !isempty(gnu)
        ell = CC.getEllipsisLoc(gnu[1])
        CC.setEllipsisLoc(gnu[1], ell)
        @test CC.getEllipsisLoc(gnu[1]).ptr == ell.ptr
    end

    df = only(pick(CC.DefaultStmt))
    defloc = CC.getDefaultLoc(df)
    CC.setDefaultLoc(df, defloc)
    @test CC.getDefaultLoc(df).ptr == defloc.ptr

    # --- WhileStmt / ForStmt condition variables ---
    wh = only(pick(CC.WhileStmt))
    @test CC.hasVarStorage(wh)
    whcv = CC.getConditionVariableDeclStmt(wh)
    @test whcv.ptr != C_NULL
    CC.setConditionVariableDeclStmt(wh, whcv)
    @test CC.getConditionVariableDeclStmt(wh).ptr == whcv.ptr

    fo = only(pick(CC.ForStmt))
    focv = CC.getConditionVariableDeclStmt(fo)
    @test focv isa CC.DeclStmt
    @test focv.ptr != C_NULL
    CC.setConditionVariableDeclStmt(fo, focv)
    @test CC.getConditionVariableDeclStmt(fo).ptr == focv.ptr

    # --- ReturnStmt ---
    rs = only(pick(CC.ReturnStmt))
    retloc = CC.getReturnLoc(rs)
    CC.setReturnLoc(rs, retloc)
    @test CC.getReturnLoc(rs).ptr == retloc.ptr
    dispose(f)
    dispose(I)

    # --- AsmStmt / GCCAsmStmt (inline-asm acceptance is target-dependent, so the
    # assertions run only once the statement actually materialised) ---
    Iasm = create_interpreter()
    CC.parse(Iasm, "void asmMutator(int a) { asm volatile(\"\" : : \"r\"(a)); }")
    fasm = DeclFinder(Iasm)
    asmstmt = nothing
    if fasm(Iasm, "asmMutator")
        afd = CC.FunctionDecl(get_decl(fasm))
        for n in CC.subtree(CC.resolve(CC.getBody(afd)))
            n isa CC.GCCAsmStmt && (asmstmt = n; break)
        end
    end
    if asmstmt !== nothing
        asmloc = CC.getAsmLoc(asmstmt)
        CC.setAsmLoc(asmstmt, asmloc)
        @test CC.getAsmLoc(asmstmt).ptr == asmloc.ptr
        simple = CC.isSimple(asmstmt)
        @test simple isa Bool
        CC.setSimple(asmstmt, simple)
        @test CC.isSimple(asmstmt) == simple
        vol = CC.isVolatile(asmstmt)
        @test vol isa Bool
        CC.setVolatile(asmstmt, vol)
        @test CC.isVolatile(asmstmt) == vol
        rparen = CC.getRParenLoc(asmstmt)
        CC.setRParenLoc(asmstmt, rparen)
        @test CC.getRParenLoc(asmstmt).ptr == rparen.ptr
    end
    dispose(fasm)
    dispose(Iasm)

    # --- SEHLeaveStmt (Microsoft extensions; parse-only, no codegen) ---
    Iseh = create_interpreter(["-fms-extensions"])
    CC.parse(Iseh, "void sehMutator(){ __try { __leave; } __except(1) { } }")
    fseh = DeclFinder(Iseh)
    @test fseh(Iseh, "sehMutator")
    sfd = CC.FunctionDecl(get_decl(fseh))
    lv = only(filter(n -> n isa CC.SEHLeaveStmt, CC.subtree(CC.resolve(CC.getBody(sfd)))))
    leaveloc = CC.getLeaveLoc(lv)
    CC.setLeaveLoc(lv, leaveloc)
    @test CC.getLeaveLoc(lv).ptr == leaveloc.ptr
    dispose(fseh)
    dispose(Iseh)

    # --- CapturedStmt (OpenMP region; parse-only) ---
    Iomp = create_interpreter(["-fopenmp"])
    CC.parse(Iomp, "void ompMutator(int n){\n#pragma omp parallel\n{ int x = n; }\n}")
    fomp = DeclFinder(Iomp)
    @test fomp(Iomp, "ompMutator")
    ofd = CC.FunctionDecl(get_decl(fomp))
    cs = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(ofd)))
        n isa CC.CapturedStmt && (cs = n; break)
    end
    @test cs isa CC.CapturedStmt
    cd = CC.getCapturedDecl(cs)
    @test cd.ptr != C_NULL
    CC.setCapturedDecl(cs, cd)
    @test CC.getCapturedDecl(cs).ptr == cd.ptr
    crd = CC.getCapturedRecordDecl(cs)
    @test crd.ptr != C_NULL
    CC.setCapturedRecordDecl(cs, crd)
    @test CC.getCapturedRecordDecl(cs).ptr == crd.ptr
    dispose(fomp)
    dispose(Iomp)
end

@testset "Stmt factories (Create/CreateEmpty) + condition-variable setters" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             int stmtFactoryProbe(int n) {
                 int acc = 0;
                 while (int w = n) { acc += w; --n; }
                 switch (n) {
                 case 1:
                     ++acc;
                     break;
                 default:
                     break;
                 }
                 for (int i = 0; i < 3; ++i) { acc += i; }
                 if (acc > 0) { return acc; }
                 return 0;
             }
             """)
    f = DeclFinder(I)
    @test f(I, "stmtFactoryProbe")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    nodes = CC.subtree(body)
    pick(T) = filter(n -> n isa T, nodes)

    ws = only(pick(CC.WhileStmt))
    ss = only(pick(CC.SwitchStmt))
    ifs = only(pick(CC.IfStmt))
    forst = only(pick(CC.ForStmt))
    cst = only(pick(CC.CaseStmt))
    ret = first(pick(CC.ReturnStmt))

    wvar = CC.getConditionVariable(ws)
    @test wvar.ptr != C_NULL
    wcond, wbody = CC.getCond(ws), CC.getBody(ws)
    wloc, wlpl, wrpl = CC.getWhileLoc(ws), CC.getLParenLoc(ws), CC.getRParenLoc(ws)
    scond, slpl, srpl = CC.getCond(ss), CC.getLParenLoc(ss), CC.getRParenLoc(ss)
    icond, ithen = CC.getCond(ifs), CC.getThen(ifs)
    ifloc, ilpl, irpl = CC.getIfLoc(ifs), CC.getLParenLoc(ifs), CC.getRParenLoc(ifs)
    clhs, caseloc, colon = CC.getLHS(cst), CC.getCaseLoc(cst), CC.getColonLoc(cst)
    rloc, rval = CC.getReturnLoc(ret), CC.getRetValue(ret)
    nullstmt, nullvar, nullexpr = CC.Stmt(C_NULL), CC.VarDecl(C_NULL), CC.Expr_(C_NULL)
    # the probe's locations must be pairwise distinct, or the round-trips below
    # could not tell a mis-routed argument from a correct one
    @test length(unique(map(l -> l.ptr, [ifloc, ilpl, irpl, caseloc, colon, rloc]))) == 6

    # CompoundStmt::CreateEmpty — zero body slots is the only always-readable shape
    cs = CC.CompoundStmt(ctx, 0, false)
    @test cs isa CC.CompoundStmt
    @test cs.ptr != C_NULL
    @test CC.body_empty(cs)
    @test length(cs) == 0
    @test CC.hasStoredFPFeatures(cs) == false

    # CaseStmt::Create — a null RHS makes the ordinary form, a non-null one the GNU range
    plain = CC.CaseStmt(ctx, clhs, nullexpr, caseloc, ifloc, colon)
    @test plain isa CC.CaseStmt
    @test !CC.caseStmtIsGNURange(plain)
    @test CC.getLHS(plain).ptr == clhs.ptr
    @test CC.getRHS(plain).ptr == C_NULL
    @test CC.getCaseLoc(plain).ptr == caseloc.ptr
    @test CC.getColonLoc(plain).ptr == colon.ptr
    rng = CC.CaseStmt(ctx, clhs, clhs, caseloc, ifloc, colon)
    @test CC.caseStmtIsGNURange(rng)
    @test CC.getRHS(rng).ptr == clhs.ptr
    @test CC.getEllipsisLoc(rng).ptr == ifloc.ptr

    # CaseStmt::CreateEmpty — the shell's slots are uninitialized until set
    caseshell = CC.CaseStmt(ctx, true)
    @test CC.caseStmtIsGNURange(caseshell)
    CC.setLHS(caseshell, clhs)
    CC.setRHS(caseshell, clhs)
    CC.setSubStmt(caseshell, ithen)
    CC.setCaseLoc(caseshell, caseloc)
    @test CC.getLHS(caseshell).ptr == clhs.ptr
    @test CC.getRHS(caseshell).ptr == clhs.ptr
    @test CC.getSubStmt(caseshell).ptr == ithen.ptr
    @test CC.getCaseLoc(caseshell).ptr == caseloc.ptr

    # IfStmt::Create — storage flags mirror exactly which optional arguments were non-null
    ordinary = CC.LibClangEx.CXIfStatementKind_Ordinary
    made_if = CC.IfStmt(ctx, ifloc, ordinary, nullstmt, nullvar, icond, ilpl, irpl, ithen,
                        CC.SourceLocation(C_NULL), nullstmt)
    @test made_if isa CC.IfStmt
    @test CC.getIfLoc(made_if).ptr == ifloc.ptr
    @test CC.getLParenLoc(made_if).ptr == ilpl.ptr
    @test CC.getRParenLoc(made_if).ptr == irpl.ptr
    @test CC.getCond(made_if).ptr == icond.ptr
    @test CC.getThen(made_if).ptr == ithen.ptr
    @test CC.getElse(made_if).ptr == C_NULL
    @test !CC.hasElseStorage(made_if)
    @test !CC.hasVarStorage(made_if)
    @test !CC.hasInitStorage(made_if)
    @test CC.getStatementKind(made_if) == ordinary
    with_else = CC.IfStmt(ctx, ifloc, ordinary, ithen, wvar, icond, ilpl, irpl, ithen, colon,
                          ithen)
    @test CC.hasElseStorage(with_else)
    @test CC.hasVarStorage(with_else)
    @test CC.hasInitStorage(with_else)
    @test CC.getElse(with_else).ptr == ithen.ptr
    @test CC.getElseLoc(with_else).ptr == colon.ptr
    @test CC.getInit(with_else).ptr == ithen.ptr
    @test CC.getConditionVariable(with_else).ptr == wvar.ptr

    # IfStmt::CreateEmpty + setConditionVariable
    ifshell = CC.IfStmt(ctx, true, true, true)
    @test CC.hasElseStorage(ifshell)
    @test CC.hasVarStorage(ifshell)
    @test CC.hasInitStorage(ifshell)
    CC.setInit(ifshell, ithen)
    CC.setCond(ifshell, icond)
    CC.setThen(ifshell, ithen)
    CC.setElse(ifshell, ithen)
    CC.setConditionVariable(ifshell, ctx, wvar)
    @test CC.getCond(ifshell).ptr == icond.ptr
    @test CC.getThen(ifshell).ptr == ithen.ptr
    @test CC.getConditionVariable(ifshell).ptr == wvar.ptr
    @test_throws AssertionError CC.setConditionVariable(made_if, ctx, wvar)

    # SwitchStmt::Create / CreateEmpty / setConditionVariable / addSwitchCase
    made_sw = CC.SwitchStmt(ctx, nullstmt, nullvar, scond, slpl, srpl)
    @test made_sw isa CC.SwitchStmt
    @test CC.getCond(made_sw).ptr == scond.ptr
    @test CC.getLParenLoc(made_sw).ptr == slpl.ptr
    @test CC.getRParenLoc(made_sw).ptr == srpl.ptr
    @test !CC.hasInitStorage(made_sw)
    @test !CC.hasVarStorage(made_sw)
    CC.setBody(made_sw, ithen)
    @test CC.getBody(made_sw).ptr == ithen.ptr
    @test CC.getSwitchCaseList(made_sw).ptr == C_NULL
    CC.addSwitchCase(made_sw, plain)
    @test CC.getSwitchCaseList(made_sw).ptr == plain.ptr
    @test_throws AssertionError CC.addSwitchCase(made_sw, plain)
    swshell = CC.SwitchStmt(ctx, true, true)
    @test CC.hasInitStorage(swshell)
    @test CC.hasVarStorage(swshell)
    CC.setInit(swshell, ithen)
    CC.setCond(swshell, scond)
    CC.setBody(swshell, ithen)
    CC.setConditionVariable(swshell, ctx, wvar)
    @test CC.getCond(swshell).ptr == scond.ptr
    @test CC.getConditionVariable(swshell).ptr == wvar.ptr
    @test_throws AssertionError CC.setConditionVariable(made_sw, ctx, wvar)

    # WhileStmt::Create / CreateEmpty / setConditionVariable
    made_wh = CC.WhileStmt(ctx, nullvar, wcond, wbody, wloc, wlpl, wrpl)
    @test made_wh isa CC.WhileStmt
    @test CC.getCond(made_wh).ptr == wcond.ptr
    @test CC.getBody(made_wh).ptr == wbody.ptr
    @test CC.getWhileLoc(made_wh).ptr == wloc.ptr
    @test CC.getLParenLoc(made_wh).ptr == wlpl.ptr
    @test CC.getRParenLoc(made_wh).ptr == wrpl.ptr
    @test !CC.hasVarStorage(made_wh)
    whshell = CC.WhileStmt(ctx, true)
    @test CC.hasVarStorage(whshell)
    CC.setCond(whshell, wcond)
    CC.setBody(whshell, wbody)
    CC.setConditionVariable(whshell, ctx, wvar)
    @test CC.getBody(whshell).ptr == wbody.ptr
    @test CC.getConditionVariable(whshell).ptr == wvar.ptr
    @test_throws AssertionError CC.setConditionVariable(made_wh, ctx, wvar)

    # ReturnStmt::Create / CreateEmpty — only a non-null candidate allocates NRVO storage
    made_ret = CC.ReturnStmt(ctx, rloc, rval, nullvar)
    @test made_ret isa CC.ReturnStmt
    @test CC.getReturnLoc(made_ret).ptr == rloc.ptr
    @test CC.getRetValue(made_ret).ptr == rval.ptr
    @test CC.getNRVOCandidate(made_ret).ptr == C_NULL
    nrvo_ret = CC.ReturnStmt(ctx, rloc, rval, wvar)
    @test CC.getNRVOCandidate(nrvo_ret).ptr == wvar.ptr
    retshell = CC.ReturnStmt(ctx, false)
    CC.setRetValue(retshell, rval)
    CC.setReturnLoc(retshell, rloc)
    @test CC.getRetValue(retshell).ptr == rval.ptr
    @test CC.getReturnLoc(retshell).ptr == rloc.ptr
    @test CC.getNRVOCandidate(retshell).ptr == C_NULL

    # SEH statement factories — the blocks must be compound statements, hence `cs`
    fin = CC.SEHFinallyStmt(ctx, ifloc, cs)
    @test fin isa CC.SEHFinallyStmt
    @test CC.getFinallyLoc(fin).ptr == ifloc.ptr
    @test CC.getBlock(fin).ptr == cs.ptr
    exc = CC.SEHExceptStmt(ctx, caseloc, icond, cs)
    @test exc isa CC.SEHExceptStmt
    @test CC.getExceptLoc(exc).ptr == caseloc.ptr
    @test CC.getFilterExpr(exc).ptr == icond.ptr
    @test CC.getBlock(exc).ptr == cs.ptr
    try_fin = CC.SEHTryStmt(ctx, false, colon, cs, fin)
    @test try_fin isa CC.SEHTryStmt
    @test CC.getIsCXXTry(try_fin) == false
    @test CC.getTryLoc(try_fin).ptr == colon.ptr
    @test CC.getTryBlock(try_fin).ptr == cs.ptr
    @test CC.getHandler(try_fin).ptr == fin.ptr
    @test CC.getFinallyHandler(try_fin).ptr == fin.ptr
    @test CC.getExceptHandler(try_fin).ptr == C_NULL
    try_exc = CC.SEHTryStmt(ctx, true, rloc, cs, exc)
    @test CC.getIsCXXTry(try_exc) == true
    @test CC.getTryLoc(try_exc).ptr == rloc.ptr
    @test CC.getExceptHandler(try_exc).ptr == exc.ptr
    @test CC.getFinallyHandler(try_exc).ptr == C_NULL

    # ForStmt::setConditionVariable — total, the slot always exists. This one mutates a
    # parsed node (clang ships no ForStmt factory), so it runs last.
    @test CC.getConditionVariable(forst).ptr == C_NULL
    CC.setConditionVariable(forst, ctx, wvar)
    @test CC.getConditionVariable(forst).ptr == wvar.ptr

    dispose(f)
    dispose(I)
end

@testset "Stmt tail: colour dump, controlled printing, profile hash, array factories" begin
    # -fms-extensions/-fasm-blocks make the `__asm { ... }` block below parse into an
    # MSAsmStmt; they change nothing about the rest of the probe.
    I = create_interpreter(["-fms-extensions", "-fasm-blocks"])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    CC.parse(I, """
             void stmtJCallee();
             int stmtJProbe(int n) {
                 int acc = n;
                 while (int w = acc) { --acc; }
                 [[clang::nomerge]] stmtJCallee();
                 if (acc > 0)
                     acc = acc + 1;
                 else
                     acc = acc + 1;
                 return acc;
             }
             """)
    @test f(I, "stmtJProbe")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    nodes = CC.subtree(body)
    ifs = only(filter(n -> n isa CC.IfStmt, nodes))
    ws = only(filter(n -> n isa CC.WhileStmt, nodes))
    ret = first(filter(n -> n isa CC.ReturnStmt, nodes))
    astmt = only(filter(n -> n isa CC.AttributedStmt, nodes))
    wvar = CC.getConditionVariable(ws)
    @test wvar.ptr != C_NULL

    # Stmt::dumpColor — writes the subtree to stderr, so only the call itself is asserted.
    @test (CC.dumpColor(body); true)

    # Stmt::printPrettyControlled — the brace-wrapping variant of printPretty.
    ctrl = CC.printPrettyControlled(CC.getThen(ifs), ctx)
    @test ctrl isa String
    @test !isempty(ctrl)
    @test occursin("acc", ctrl)
    @test !isempty(CC.printPrettyControlled(CC.getThen(ifs), ctx, 2))

    # Stmt::Profile — the two `if` branches are written identically, so their structural
    # profiles (hence their hashes) must agree, and a node hashes stably against itself.
    h_then = CC.getProfileHash(CC.getThen(ifs), ctx)
    h_else = CC.getProfileHash(CC.getElse(ifs), ctx)
    @test h_then isa Integer
    @test h_then == h_else
    @test CC.getProfileHash(body, ctx) == CC.getProfileHash(body, ctx)
    h_canon = CC.getProfileHash(body, ctx, true)
    @test h_canon == CC.getProfileHash(body, ctx, true)
    @test h_canon != 0

    # ReturnStmt::setNRVOCandidate — only a statement built with a candidate owns the
    # trailing slot; the wrapper's assert restates that against getNRVOCandidate.
    rloc, rval = CC.getReturnLoc(ret), CC.getRetValue(ret)
    plain_ret = CC.ReturnStmt(ctx, rloc, rval, CC.VarDecl(C_NULL))
    @test CC.getNRVOCandidate(plain_ret).ptr == C_NULL
    @test_throws AssertionError CC.setNRVOCandidate(plain_ret, wvar)
    nrvo_ret = CC.ReturnStmt(ctx, rloc, rval, wvar)
    @test CC.getNRVOCandidate(nrvo_ret).ptr == wvar.ptr
    CC.setNRVOCandidate(nrvo_ret, wvar)                       # identity write-back
    @test CC.getNRVOCandidate(nrvo_ret).ptr == wvar.ptr

    # CompoundStmt::Create — the body statements are copied into trailing storage.
    kids = CC.children(body)
    @test !isempty(kids)
    lb, rb = CC.getLBracLoc(body), CC.getRBracLoc(body)
    made = CC.CompoundStmt(ctx, kids, 0, lb, rb)
    @test made isa CC.CompoundStmt
    @test made.ptr != C_NULL
    @test length(made) == length(kids)
    @test CC.getLBracLoc(made).ptr == lb.ptr
    @test CC.getRBracLoc(made).ptr == rb.ptr
    @test !CC.hasStoredFPFeatures(made)
    @test CC.body_front(made).ptr == first(kids).ptr
    @test CC.body_back(made).ptr == last(kids).ptr
    empty_body = CC.CompoundStmt(ctx, CC.Stmt[], 0, lb, rb)
    @test CC.body_empty(empty_body)
    @test length(empty_body) == 0
    @test_throws AssertionError CC.CompoundStmt(ctx, [CC.Stmt(C_NULL)], 0, lb, rb)

    # AttributedStmt::Create — clang needs a non-empty attribute list, restated by the
    # wrapper; the attributes are copied, so the rebuilt node reports the same handles.
    attrs = CC.getAttrs(astmt)
    @test !isempty(attrs)
    aloc = CC.getAttrLoc(astmt)
    sub = CC.getSubStmt(astmt)
    made_attr = CC.AttributedStmt(ctx, aloc, attrs, sub)
    @test made_attr isa CC.AttributedStmt
    @test made_attr.ptr != C_NULL
    @test CC.getAttrLoc(made_attr).ptr == aloc.ptr
    @test CC.getNumAttrs(made_attr) == length(attrs)
    @test CC.getSubStmt(made_attr).ptr == sub.ptr
    @test map(a -> a.ptr, CC.getAttrs(made_attr)) == map(a -> a.ptr, attrs)
    @test_throws AssertionError CC.AttributedStmt(ctx, aloc, CC.Attr[], sub)

    # GCCAsmStmt::setAsmString — inline-asm acceptance is target-dependent, so this only
    # asserts once the statement actually parsed and was located on this host.
    findasm = function (name, T)
        f(I, name) || return nothing
        b = CC.getBody(CC.FunctionDecl(get_decl(f)))
        b.ptr == C_NULL && return nothing
        for c in CC.children(b)
            r = CC.resolve(c)
            r isa T && return r
        end
        return nothing
    end

    CC.parse(I, "void stmtJAsm(int a) { asm(\"\" : : \"r\"(a)); }")
    gasm = findasm("stmtJAsm", CC.GCCAsmStmt)
    if gasm !== nothing
        lit = CC.getAsmString(gasm)
        @test lit isa CC.StringLiteral
        CC.setAsmString(gasm, lit)                            # identity write-back
        @test CC.getAsmString(gasm).ptr == lit.ptr
    end

    # MSAsmStmt is deliberately NOT exercised. Parsing `__asm { ... }` through the
    # interpreter fails on this toolchain (no MC asm parser for the host), so the node is
    # never built and every read below would be skipped anyway -- and after the synthetic
    # CompoundStmt/AttributedStmt/ReturnStmt work above, the failed parse segfaults inside
    # clang's own DiagnosticRenderer while it reports the error. In isolation the same
    # parse only reports "Parsing failed", so the crash needs that preceding state. The
    # MSAsmStmt wrappers stay bound and are covered by test/lint.jl's binding check.

    dispose(f)
    dispose(I)
end

@testset "GCCAsmStmt asm-string pieces + AttributedStmt empty shell" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # Inline-asm acceptance is target-dependent, so the piece assertions below only run
    # once the statement actually parsed and was found on this host. The asm text is never
    # assembled here -- CC.parse stops at IR generation -- so `nop %0` only has to survive
    # Sema's own AnalyzeAsmString check (one operand, one reference to it). The parse also
    # comes FIRST, before any synthetic node is built, so a host that rejects it cannot
    # reproduce the DiagnosticRenderer crash a failed parse causes after synthetic AST work.
    findasm = function (name)
        f(I, name) || return nothing
        body = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        body.ptr == C_NULL && return nothing
        for c in CC.children(body)
            r = CC.resolve(c)
            r isa CC.GCCAsmStmt && return r
        end
        return nothing
    end

    CC.parse(I, "void asmPieces(int a) { asm(\"nop %0\" : : \"r\"(a)); }")
    gasm = findasm("asmPieces")
    if gasm !== nothing
        n, diag_id, diag_offs = CC.getNumAsmStringPieces(gasm, ctx)
        @test n >= 1
        @test diag_id == 0                      # clang accepted the string at parse time
        @test diag_offs >= 0
        pieces = CC.getAsmStringPieces(gasm, ctx)
        @test length(pieces) == n
        @test all(p -> p.ptr != C_NULL, pieces)
        @test all(p -> CC.isString(p) != CC.isOperand(p), pieces)
        @test all(p -> CC.getString(p) isa String, pieces)
        ops = filter(CC.isOperand, pieces)
        @test length(ops) == 1                  # the single `%0` reference
        @test CC.getOperandNo(ops[1]) == 0
        op_r = CC.getRange(ops[1])
        @test op_r isa CC.SourceRange
        @test !CC.is_null_handle(op_r.begin_loc)
        @test !CC.is_null_handle(op_r.end_loc)
        @test CC.getModifier(ops[1]) isa Char    # '\0' when the reference carries none
        for p in pieces
            dispose(p)
        end
    end

    # AttributedStmt::CreateEmpty. clang null-fills the attribute slots and leaves AttrLoc
    # default-constructed, but keeps SubStmt private with no setter, so the sub-statement
    # slot stays uninitialized: getSubStmt/getEndLoc are deliberately never called here.
    shell = CC.AttributedStmt(ctx, 2)
    @test shell isa CC.AttributedStmt
    @test shell.ptr != C_NULL
    @test CC.getNumAttrs(shell) == 2
    @test CC.is_null_handle(CC.getAttrLoc(shell))
    @test all(a -> a.ptr == C_NULL, CC.getAttrs(shell))

    dispose(f)
    dispose(I)
end

@testset "Stmt tail: compound/decl indexing, ODR hash, class statistics" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, """
             int stmtLIndexed(int n) {
                 int a = 1, b = 2;
                 int c = a + b;
                 if (n > 0) { return c; }
                 if (n > 0) { return c; }
                 return n;
             }
             """)
    @test f(I, "stmtLIndexed")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt

    # CompoundStmt::body_begin — count+index over the trailing `Stmt *` array. A compound
    # statement never carries null child slots, so the indexed walk and the generic
    # children fill must agree element for element.
    kids = CC.children(body)
    n = length(body)
    @test n == length(kids)
    @test [CC.getBodyStmt(body, i).ptr for i in 0:(n - 1)] == [k.ptr for k in kids]
    @test CC.getBodyStmt(body, 0).ptr == CC.body_front(body).ptr
    @test CC.getBodyStmt(body, n - 1).ptr == CC.body_back(body).ptr
    @test !CC.is_null_handle(CC.getBodyStmt(body, 0))
    @test_throws AssertionError CC.getBodyStmt(body, n)
    @test_throws AssertionError CC.getBodyStmt(body, -1)

    # DeclStmt::decl_begin — `int a = 1, b = 2;` is one DeclStmt holding two declarations;
    # the index accessor agrees with the count+fill getDecls.
    ds = CC.resolve(CC.getBodyStmt(body, 0))
    @test ds isa CC.DeclStmt
    decls = CC.getDecls(ds)
    @test CC.getNumDecls(ds) == length(decls) == 2
    @test [CC.getDecl(ds, i).ptr for i in 0:(length(decls) - 1)] == [d.ptr for d in decls]
    @test CC.getDecl(ds, 0) isa CC.Decl
    @test_throws AssertionError CC.getDecl(ds, CC.getNumDecls(ds))
    @test_throws AssertionError CC.getDecl(ds, -1)

    # a single-declaration group stores its Decl inline; index 0 still reaches it
    ds1 = CC.resolve(CC.getBodyStmt(body, 1))
    @test ds1 isa CC.DeclStmt
    @test CC.isSingleDecl(ds1)
    @test CC.getDecl(ds1, 0).ptr == CC.getSingleDecl(ds1).ptr

    # Stmt::ProcessODRHash — the two `if` statements are written identically and the
    # profile uses no pointer identity, so their ODR hashes agree; a node hashes stably
    # against itself.
    ifs = filter(s -> s isa CC.IfStmt, kids)
    @test length(ifs) == 2
    h1, h2 = CC.getODRHash(ifs[1]), CC.getODRHash(ifs[2])
    @test h1 isa Integer
    @test h1 == h2
    @test CC.getODRHash(body) == CC.getODRHash(body)

    # Stmt::addStmtClass — the per-class counter behind PrintStats. clang exposes no
    # reader for one class, so this only asserts the call is total on a real class value.
    @test CC.addStmtClass(CC.getStmtClass(body)) === nothing
    @test CC.addStmtClass(LibClangEx.CXStmtClass_NullStmtClass) === nothing

    dispose(f)
    dispose(I)
end

@testset "CapturedStmt factories: Capture boxes, Create and the deserialized shell" begin
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    tu = CC.getTranslationUnitDecl(ctx)
    dc = CC.castToDeclContext(tu)
    CC.parse(I, """
             int capBuildVar = 3;
             void capBuildProbe(int p) { int q = p; }
             """)
    f = DeclFinder(I)
    # every lookup happens before anything is synthesized, so no factory below can
    # make a name ambiguous for get_decl
    @test f(I, "capBuildVar")
    vd = CC.VarDecl(get_decl(f))
    @test f(I, "capBuildProbe")
    fd = CC.FunctionDecl(get_decl(f))
    body = CC.resolve(CC.getBody(fd))
    @test body isa CC.CompoundStmt
    loc = CC.getLocation(vd)
    id = CC.getIdentifier(vd)
    init = CC.getInit(vd)
    @test init isa CC.Expr_
    @test init.ptr != C_NULL

    # --- CapturedStmt::Capture boxes (owned; the statement copies them) ---
    byref = CC.CapturedStmtCapture(loc, LibClangEx.CXVariableCaptureKind_VCK_ByRef, vd)
    @test byref isa CC.CapturedStmtCapture
    @test byref.ptr != C_NULL
    @test CC.getCaptureKind(byref) == LibClangEx.CXVariableCaptureKind_VCK_ByRef
    @test CC.capturesVariable(byref)
    @test CC.getCapturedVar(byref).ptr == vd.ptr
    @test CC.getLocation(byref).ptr == loc.ptr

    thiscap = CC.CapturedStmtCapture(loc, LibClangEx.CXVariableCaptureKind_VCK_This)
    @test CC.capturesThis(thiscap)
    @test CC.getCaptureKind(thiscap) == LibClangEx.CXVariableCaptureKind_VCK_This

    # the kind and the variable must agree, in both directions
    @test_throws AssertionError CC.CapturedStmtCapture(loc, LibClangEx.CXVariableCaptureKind_VCK_This, vd)
    @test_throws AssertionError CC.CapturedStmtCapture(loc, LibClangEx.CXVariableCaptureKind_VCK_ByCopy)

    # --- CapturedStmt::Create ---
    kind = LibClangEx.CXCapturedRegionKind_CR_Default
    cd = CC.CapturedDecl(ctx, dc, 1)
    rd = CC.RecordDecl(ctx, LibClangEx.CXTagTypeKind_Struct, dc, loc, loc, id)
    caps = CC.CapturedStmtCapture[byref, thiscap]
    inits = CC.Expr_[init, init]
    cs = CC.CapturedStmt(ctx, body, kind, caps, inits, cd, rd)
    @test cs isa CC.CapturedStmt
    @test cs.ptr != C_NULL
    @test CC.getStmtClassName(cs) == "CapturedStmt"
    @test CC.capture_size(cs) == 2
    @test CC.getCapturedStmt(cs).ptr == body.ptr
    @test CC.getCapturedDecl(cs).ptr == cd.ptr
    @test CC.getCapturedRecordDecl(cs).ptr == rd.ptr
    @test CC.getCapturedRegionKind(cs) == kind

    # the captures are copied into the statement's own trailing storage
    c0 = CC.getCapture(cs, 0)
    @test c0.ptr != byref.ptr
    @test CC.getCaptureKind(c0) == LibClangEx.CXVariableCaptureKind_VCK_ByRef
    @test CC.getCapturedVar(c0).ptr == vd.ptr
    @test CC.capturesThis(CC.getCapture(cs, 1))
    @test CC.getCaptureInit(cs, 0).ptr == init.ptr
    @test CC.getCaptureInit(cs, 1).ptr == init.ptr
    @test CC.capturesVariable(cs, vd)

    # one initializer per capture is clang's own precondition
    @test_throws AssertionError CC.CapturedStmt(ctx, body, kind, caps, CC.Expr_[init], cd, rd)
    @test_throws AssertionError CC.CapturedStmt(ctx, body, kind,
                                                 CC.CapturedStmtCapture[CC.CapturedStmtCapture(C_NULL)],
                                                 CC.Expr_[init], cd, rd)

    # the boxes are ours; the statement kept copies, so it stays readable afterwards
    dispose(byref)
    dispose(thiscap)
    @test CC.capture_size(cs) == 2
    @test CC.getCapturedVar(CC.getCapture(cs, 0)).ptr == vd.ptr

    # --- CapturedStmt::CreateDeserialized (shell: only the count is meaningful) ---
    shell = CC.CapturedStmt(ctx, 2)
    @test shell isa CC.CapturedStmt
    @test shell.ptr != C_NULL
    @test CC.getStmtClassName(shell) == "CapturedStmt"
    @test CC.capture_size(shell) == 2
    @test CC.getCapturedStmt(shell).ptr == C_NULL

    dispose(f)
    dispose(I)
end

@testset "Stmt likelihood overloads (attribute list, branch pair, conflict)" begin
    I = create_interpreter()
    f = DeclFinder(I)
    LH = CC.LibClangEx

    # [[likely]]/[[unlikely]] are C++20 spellings clang also accepts in earlier modes, so
    # whether the attributes survive the parse is a host decision -- every assertion that
    # depends on one being recognised is guarded below.
    CC.parse(I, """
             int likelihoodProbe(int n) {
                 if (n > 0) [[likely]] { return 1; }
                 else [[unlikely]] { return 2; }
             }
             int plainBranchProbe(int n) {
                 if (n > 0) { return 1; }
                 else { return 2; }
             }
             """)

    findif = function (name)
        f(I, name) || return nothing
        body = CC.getBody(CC.FunctionDecl(CC.get_decl(f)))
        body.ptr == C_NULL && return nothing
        for n in CC.subtree(CC.resolve(body))
            n isa CC.IfStmt && return n
        end
        return nothing
    end

    # The attribute-list overload of Stmt::getLikelihood: an empty list carries nothing.
    @test CC.getLikelihood(CC.Attr[]) isa LH.CXLikelihood
    @test CC.getLikelihood(CC.Attr[]) == LH.CXLikelihood_LH_None

    plain = findif("plainBranchProbe")
    @test plain isa CC.IfStmt
    pthen, pelse = CC.getThen(plain), CC.getElse(plain)
    # Neither branch is attributed: no likelihood, and nothing to conflict.
    @test CC.getLikelihood(pthen, pelse) == LH.CXLikelihood_LH_None
    pc, pta, pea = CC.determineLikelihoodConflict(pthen, pelse)
    @test pc == false
    @test pta isa CC.Attr
    @test pta.ptr == C_NULL
    @test pea isa CC.Attr
    @test pea.ptr == C_NULL

    lif = findif("likelihoodProbe")
    @test lif isa CC.IfStmt
    lthen, lelse = CC.getThen(lif), CC.getElse(lif)
    @test CC.getLikelihood(lthen, lelse) in (LH.CXLikelihood_LH_None, LH.CXLikelihood_LH_Likely)
    c, ta, ea = CC.determineLikelihoodConflict(lthen, lelse)
    @test c isa Bool
    @test ta isa CC.Attr
    @test ea isa CC.Attr
    if c
        # A reported conflict comes with both conflicting attributes.
        @test ta.ptr != C_NULL
        @test ea.ptr != C_NULL
    end
    if CC.getLikelihood(lthen) == LH.CXLikelihood_LH_Likely
        athen = CC.resolve(lthen)
        @test athen isa CC.AttributedStmt
        # The list overload and the statement overload agree on the same attributes.
        @test CC.getLikelihood(CC.getAttrs(athen)) == CC.getLikelihood(athen)
        @test CC.getLikelihood(CC.getAttrs(athen)) == LH.CXLikelihood_LH_Likely
    end

    dispose(f)
    dispose(I)
end

@testset "GCCAsmStmt / MSAsmStmt built from their operand arrays" begin
    # clang gives both asm statements a public constructor and no Create, so building them
    # here is the only way to reach their accessors deterministically: GCC-style inline asm
    # is only accepted on some targets, and the MS-style block cannot be parsed at all once
    # synthetic AST nodes exist (a rejected parse then crashes clang's DiagnosticRenderer).
    I = create_interpreter()
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
             const char asmBuildText[] = "nop";
             int asmBuildVar = 7;
             """)
    f = DeclFinder(I)
    # every lookup runs before anything is synthesized, so no name can turn ambiguous
    @test f(I, "asmBuildText")
    textvar = CC.VarDecl(get_decl(f))
    lit = CC.resolve(CC.IgnoreParenImpCasts(CC.getInit(textvar)))
    @test lit isa CC.StringLiteral
    strty = CC.getType(lit)
    loc = CC.getLocation(textvar)
    @test f(I, "asmBuildVar")
    operand = CC.getInit(CC.VarDecl(get_decl(f)))
    @test operand.ptr != C_NULL

    mkstr = s -> CC.StringLiteral(ctx, s, LibClangEx.CXStringLiteralKind_Ordinary, false, strty,
                                  [loc])
    asmstr, outc, inc, clob = mkstr("nop"), mkstr("=r"), mkstr("r"), mkstr("memory")
    noname = CC.IdentifierInfo(C_NULL)

    # --- GCCAsmStmt: one output, one input, one clobber, no labels ---
    g = CC.GCCAsmStmt(ctx, loc, true, false, 1, 1, CC.IdentifierInfo[noname, noname],
                      CC.StringLiteral[outc, inc], CC.Expr_[operand, operand], asmstr,
                      CC.StringLiteral[clob], loc)
    @test g isa CC.GCCAsmStmt
    @test g.ptr != C_NULL
    @test CC.getStmtClassName(g) == "GCCAsmStmt"
    @test CC.isSimple(g)
    @test !CC.isVolatile(g)
    @test CC.getNumOutputs(g) == 1
    @test CC.getNumInputs(g) == 1
    @test CC.getNumClobbers(g) == 1
    @test CC.getNumLabels(g) == 0
    @test !CC.isAsmGoto(g)
    @test CC.getAsmString(g).ptr == asmstr.ptr
    @test CC.getOutputConstraint(g, 0) == "=r"
    @test CC.getInputConstraint(g, 0) == "r"
    @test CC.getClobber(g, 0) == "memory"
    @test CC.getOutputExpr(g, 0).ptr == operand.ptr
    @test CC.getInputExpr(g, 0).ptr == operand.ptr
    @test CC.getOutputConstraintLiteral(g, 0).ptr == outc.ptr
    @test CC.getInputConstraintLiteral(g, 0).ptr == inc.ptr
    @test CC.getClobberStringLiteral(g, 0).ptr == clob.ptr
    # the name slots we passed are null, so no operand carries a symbolic [name]
    @test CC.getOutputIdentifier(g, 0).ptr == C_NULL
    @test CC.getInputIdentifier(g, 0).ptr == C_NULL
    @test CC.getOutputName(g, 0) == ""
    @test CC.getInputName(g, 0) == ""
    @test CC.getNamedOperand(g, "in") == -1
    @test !CC.isOutputPlusConstraint(g, 0)          # "=r" is write-only
    @test CC.getNumPlusOperands(g) == 0
    @test CC.generateAsmString(g, ctx) == "nop"     # no operand reference to expand
    @test CC.getAsmLoc(g).ptr == loc.ptr
    @test CC.getRParenLoc(g).ptr == loc.ptr
    @test CC.getBeginLoc(g).ptr == loc.ptr
    @test CC.getEndLoc(g).ptr == loc.ptr

    # names and exprs are read in lockstep, one slot per output, input and label
    @test_throws AssertionError CC.GCCAsmStmt(ctx, loc, true, false, 1, 1,
                                              CC.IdentifierInfo[noname],
                                              CC.StringLiteral[outc, inc],
                                              CC.Expr_[operand, operand], asmstr,
                                              CC.StringLiteral[clob], loc)
    # one constraint literal per output and input
    @test_throws AssertionError CC.GCCAsmStmt(ctx, loc, true, false, 1, 1,
                                              CC.IdentifierInfo[noname, noname],
                                              CC.StringLiteral[outc],
                                              CC.Expr_[operand, operand], asmstr,
                                              CC.StringLiteral[clob], loc)

    # --- MSAsmStmt: the same shape, with string operands instead of literal nodes ---
    tok = CC.Token()
    ms = CC.MSAsmStmt(ctx, loc, loc, true, true, CC.Token[tok], 1, 1, ["=r", "r"],
                      CC.Expr_[operand, operand], "nop", ["memory"], loc)
    @test ms isa CC.MSAsmStmt
    @test ms.ptr != C_NULL
    @test CC.getStmtClassName(ms) == "MSAsmStmt"
    @test CC.isSimple(ms)
    @test CC.isVolatile(ms)
    @test CC.getAsmString(ms) == "nop"
    @test CC.hasBraces(ms)                          # lbrace_loc is a valid location
    @test CC.getLBraceLoc(ms).ptr == loc.ptr
    @test CC.getNumAsmToks(ms) == 1
    @test !CC.is_null_handle(CC.getAsmTok(ms, 0))
    @test CC.getAsmTok(ms, 0).ptr != tok.ptr        # the token value was copied
    @test CC.getNumOutputs(ms) == 1
    @test CC.getNumInputs(ms) == 1
    @test CC.getNumClobbers(ms) == 1
    @test CC.getOutputConstraint(ms, 0) == "=r"
    @test CC.getInputConstraint(ms, 0) == "r"
    @test CC.getClobber(ms, 0) == "memory"
    @test CC.getAllConstraints(ms) == ["=r", "r"]
    @test CC.getClobbers(ms) == ["memory"]
    @test [e.ptr for e in CC.getAllExprs(ms)] == [operand.ptr, operand.ptr]
    CC.setInputExpr(ms, 0, operand)
    @test CC.getInputExpr(ms, 0).ptr == operand.ptr
    CC.setLBraceLoc(ms, loc)
    CC.setEndLoc(ms, loc)
    @test CC.getLBraceLoc(ms).ptr == loc.ptr
    @test CC.getEndLoc(ms).ptr == loc.ptr

    # one constraint and one expression per operand, and no null token box
    @test_throws AssertionError CC.MSAsmStmt(ctx, loc, loc, true, true, CC.Token[tok], 1, 1,
                                             ["=r"], CC.Expr_[operand, operand], "nop",
                                             ["memory"], loc)
    @test_throws AssertionError CC.MSAsmStmt(ctx, loc, loc, true, true,
                                             CC.Token[CC.Token(C_NULL)], 1, 1, ["=r", "r"],
                                             CC.Expr_[operand, operand], "nop", String[], loc)

    # the token box is ours; the statement kept a copy, so it stays readable afterwards
    dispose(tok)
    @test CC.getNumAsmToks(ms) == 1
    @test CC.getAllConstraints(ms) == ["=r", "r"]

    # `Stmt::EnableStatistics` / `Stmt::PrintStats` are static and now carry the class as a
    # `::Type` tag. Untagged they were reachable but ambiguous -- `PrintStats()` answered for
    # whichever hierarchy was defined last, which is not a question anyone meant to ask.
    @test (CC.EnableStatistics(CC.Stmt); true)
    @test (CC.PrintStats(CC.Stmt); true)
    @test !applicable(CC.PrintStats)             # no untagged spelling survives

    dispose(f)
    dispose(I)
end
