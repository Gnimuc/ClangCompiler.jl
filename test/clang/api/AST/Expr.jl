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

@testset "Expr/Stmt setters and factories" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             int compute(int n) {
                 int arr[3] = {1, 2, 3};
                 double d = 1.5;
                 double dd = (double)n;
                 return (int)d + arr[0];
             }
             """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "compute")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    cs = first(filter(n -> n isa CC.CStyleCastExpr, nodes))

    # ---- Factories (read-only on the parsed nodes) ---------------------------
    ity = CC.getType(il)

    # CStyleCastExpr::CreateEmpty(ctx, PathSize, HasFPFeatures)
    empty_cast = CC.CStyleCastExpr(ctx, 0, false)
    @test empty_cast.ptr != C_NULL
    @test CC.getNumChildren(empty_cast) == 1

    # CStyleCastExpr::Create (no-type-info): int -> int NoOp cast over `il`
    noop = CC.CStyleCastExpr(ctx, ity, CC.LibClangEx.CXExprValueKind_VK_PRValue,
                             CC.LibClangEx.CXCastKind_CK_NoOp, il)
    @test noop.ptr != C_NULL
    @test CC.getType(noop).ptr == ity.ptr
    @test CC.getValueKind(noop) == CC.LibClangEx.CXExprValueKind_VK_PRValue
    @test CC.getCastKind(noop) == CC.LibClangEx.CXCastKind_CK_NoOp
    @test CC.getCastKindName(noop) == "NoOp"
    @test CC.getSubExpr(noop).ptr == il.ptr

    # IntegerLiteral::Create(ctx, APInt-as-GenericValue, type, loc)
    gv = CC.getValue(il)
    newil = CC.IntegerLiteral(ctx, gv, ity, CC.getLocation(il))
    @test newil.ptr != C_NULL
    @test CC.getLocation(newil).ptr == CC.getLocation(il).ptr
    @test CC.getType(newil).ptr == ity.ptr

    # ---- Setters: round-trip through the paired getters ----------------------
    loc_a = CC.getLocation(il)      # a valid SourceLocation
    loc_b = CC.getRParenLoc(cs)     # a different valid SourceLocation
    @test loc_a.ptr != loc_b.ptr

    # CStyleCastExpr::setLParenLoc / setRParenLoc (mutate the freshly-parsed cast)
    CC.setLParenLoc(cs, loc_a)
    @test CC.getLParenLoc(cs).ptr == loc_a.ptr
    CC.setRParenLoc(cs, loc_b)
    @test CC.getRParenLoc(cs).ptr == loc_b.ptr

    # IntegerLiteral::setLocation on both a parsed and a freshly-created literal
    CC.setLocation(il, loc_b)
    @test CC.getLocation(il).ptr == loc_b.ptr
    CC.setLocation(newil, loc_a)
    @test CC.getLocation(newil).ptr == loc_a.ptr

    dispose(lookup)
    dispose(I)
end

@testset "Expr payload (StringLiteral / UETT)" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)

    CC.parse(I, "const char *g_str = \"abc\";")
    @test f(I, "g_str")
    vd = CC.VarDecl(get_decl(f))
    sl = _find_node(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    @test sl.ptr != C_NULL
    @test CC.getString(sl) == "abc"
    @test CC.getBytes(sl) == "abc"
    @test CC.getLength(sl) == 3
    @test CC.getByteLength(sl) == 3
    @test CC.getCharByteWidth(sl) == 1
    @test CC.isOrdinary(sl)
    @test !CC.isWide(sl)
    @test CC.getKind(sl) == CC.LibClangEx.CXStringLiteralKind_Ordinary

    # A UTF-16 literal: two bytes per character, so every character carries an interior NUL
    # and `getString` is the accessor clang asserts against. `u"..."` rather than `L"..."`
    # because wchar_t is 2 bytes on Windows and 4 elsewhere, while char16_t is 2 everywhere.
    CC.parse(I, "const char16_t *g_u16 = u\"wide\";")
    @test f(I, "g_u16")
    vdw = CC.VarDecl(get_decl(f))
    slw = _find_node(CC.StringLiteral, CC.resolve(CC.getInit(vdw)))
    @test slw !== nothing
    @test CC.isUTF16(slw)
    @test CC.getCharByteWidth(slw) == 2
    @test CC.getLength(slw) == 4
    @test CC.getByteLength(slw) == 8
    # The interior NULs are the point: a NUL-terminated crossing reports one byte, not eight.
    @test CC.getBytes(slw) == "w\0i\0d\0e\0"
    @test ncodeunits(CC.getBytes(slw)) == 8
    @test_throws AssertionError CC.getString(slw)

    CC.parse(I, "unsigned long g_sz = sizeof(int);")
    @test f(I, "g_sz")
    vd2 = CC.VarDecl(get_decl(f))
    uett = _find_node(CC.UnaryExprOrTypeTraitExpr, CC.resolve(CC.getInit(vd2)))
    @test uett !== nothing
    @test uett.ptr != C_NULL
    @test CC.getKind(uett) == CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf
    @test CC.isArgumentType(uett)

    dispose(f)
    dispose(I)
end

@testset "Coverage | Expr" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
        """
        struct Base { int b; };
        struct Derived : Base { int d; };
        struct PointT { int x; int y; };

        int helper(int a, int b) { return a + b; }
        consteval int sq(int x) { return x * x; }

        int compute(int n) {
            int arr[3] = {1, 2, 3};
            double d = 1.5;
            char c = 'a';
            const char* s = "hello";
            const char* fn = __func__;
            int a = (n + 1);
            a += 2;
            ++a;
            a--;
            int b = arr[a % 3];
            int e = a > b ? a : b;
            unsigned long szt = sizeof(PointT);
            unsigned long sze = sizeof a;
            PointT p;
            p.x = 5;
            double dd = (double)n;
            int f = helper(a, b);
            int cc = sq(3);
            int g = ({ int t = a; t + 1; });
            PointT q = (PointT){1, 2};
            Derived dv;
            Base& br = dv;
            Base* bp = &dv;
            return e + f + cc + g + (int)d + c + p.x + q.x + br.b + bp->b + s[0] + fn[0];
        }
        """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "compute")
    fd = CC.FunctionDecl(get_decl(lookup))
    body = CC.getBody(fd)
    nodes = CC.subtree(body)
    byT(T) = filter(n -> n isa T, nodes)
    first_of(T) = (v = byT(T); isempty(v) ? nothing : first(v))

    # ---- Expr base predicates (any expression node) --------------------------
    anyexpr = first(filter(n -> n isa CC.AbstractExpr, nodes))
    @test CC.getType(anyexpr) isa CC.QualType
    @test CC.getValueKind(anyexpr) isa CC.LibClangEx.CXExprValueKind
    @test !(CC.isLValue(anyexpr))
    @test CC.isPRValue(anyexpr)
    @test !(CC.isXValue(anyexpr))
    @test !(CC.isGLValue(anyexpr))
    @test !CC.is_null_handle(CC.IgnoreImpCasts(anyexpr))
    @test !CC.is_null_handle(CC.IgnoreCasts(anyexpr))
    @test CC.IgnoreParens(anyexpr) isa CC.Expr_
    @test !CC.is_null_handle(CC.IgnoreParenCasts(anyexpr))
    @test !CC.is_null_handle(CC.IgnoreParenImpCasts(anyexpr))
    @test !(CC.containsErrors(anyexpr))
    @test !(CC.containsUnexpandedParameterPack(anyexpr))
    @test !(CC.hasPlaceholderType(anyexpr))
    @test !(CC.isDefaultArgument(anyexpr))
    @test !(CC.isImplicitCXXThis(anyexpr))
    @test !(CC.isInstantiationDependent(anyexpr))
    @test !(CC.isObjCSelfExpr(anyexpr))
    @test CC.isOrdinaryOrBitFieldObject(anyexpr)
    @test !(CC.isTypeDependent(anyexpr))
    @test !(CC.isValueDependent(anyexpr))
    @test !(CC.refersToBitField(anyexpr))
    @test !(CC.refersToGlobalRegisterVar(anyexpr))
    @test !(CC.refersToMatrixElement(anyexpr))
    @test !(CC.refersToVectorElement(anyexpr))
    @test !CC.is_null_handle(CC.getExprLoc(anyexpr))

    # ---- Expr constant folding (needs an ASTContext) -------------------------
    il = first_of(CC.IntegerLiteral)
    @test il !== nothing
    apr = CC.EvaluateAsRValue(il, ctx)
    @test apr isa CC.APValue
    apr.ptr != C_NULL && dispose(apr)
    @test CC.isEvaluatable(il, ctx)
    @test CC.isIntegerConstantExpr(il, ctx)
    @test CC.isCXX11ConstantExpr(il, ctx)
    @test CC.EvaluateAsBooleanCondition(il, ctx) == 1
    api_ = CC.EvaluateAsInt(il, ctx)
    @test api_ isa CC.APValue
    api_.ptr != C_NULL && dispose(api_)

    # ---- IntegerLiteral ------------------------------------------------------
    @test CC.getValue(il) !== nothing
    @test !CC.is_null_handle(CC.getBeginLoc(il))
    @test !CC.is_null_handle(CC.getEndLoc(il))
    @test !CC.is_null_handle(CC.getLocation(il))

    # ---- FloatingLiteral -----------------------------------------------------
    fl = first_of(CC.FloatingLiteral)
    @test fl !== nothing
    @test CC.getValueAsApproximateDouble(fl) == 1.5
    @test CC.EvaluateAsFloat(fl, ctx) !== nothing

    # ---- CharacterLiteral ----------------------------------------------------
    chl = first_of(CC.CharacterLiteral)
    @test chl !== nothing
    @test CC.getValue(chl) isa Integer
    @test CC.getKind(chl) isa CC.LibClangEx.CXCharacterLiteralKind
    @test !CC.is_null_handle(CC.getLocation(chl))

    # ---- StringLiteral -------------------------------------------------------
    sl = first_of(CC.StringLiteral)
    @test sl !== nothing
    @test !isempty(CC.getBytes(sl))
    @test !isempty(CC.getString(sl))
    @test CC.getByteLength(sl) == 5
    @test CC.getLength(sl) == 5
    @test CC.getCharByteWidth(sl) == 1
    @test CC.getKind(sl) isa CC.LibClangEx.CXStringLiteralKind
    @test CC.isOrdinary(sl)
    @test !(CC.isWide(sl))
    @test !(CC.isUTF8(sl))
    @test !(CC.isUTF16(sl))
    @test !(CC.isUTF32(sl))
    @test !(CC.isUnevaluated(sl))
    @test !(CC.isPascal(sl))
    @test !(CC.containsNonAscii(sl))
    @test !(CC.containsNonAsciiOrNull(sl))
    @test CC.getNumConcatenated(sl) == 1
    @test !CC.is_null_handle(CC.getBeginLoc(sl))
    @test !CC.is_null_handle(CC.getEndLoc(sl))

    # ---- ParenExpr -----------------------------------------------------------
    pe = first_of(CC.ParenExpr)
    @test pe !== nothing
    @test !CC.is_null_handle(CC.getSubExpr(pe))
    @test !CC.is_null_handle(CC.getLParen(pe))
    @test !CC.is_null_handle(CC.getRParen(pe))

    # ---- UnaryOperator -------------------------------------------------------
    uo = first_of(CC.UnaryOperator)
    @test uo !== nothing
    @test CC.getOpcode(uo) isa CC.LibClangEx.CXUnaryOperatorKind
    @test !CC.is_null_handle(CC.getSubExpr(uo))
    @test !CC.is_null_handle(CC.getOperatorLoc(uo))
    @test CC.isPrefix(uo)
    @test !(CC.isPostfix(uo))
    @test CC.isIncrementOp(uo)
    @test !(CC.isDecrementOp(uo))
    @test CC.canOverflow(uo)
    @test CC.isIncrementDecrementOp(uo)
    @test !(CC.isArithmeticOp(uo))
    @test CC.hasStoredFPFeatures(uo) == false

    # ---- ArraySubscriptExpr --------------------------------------------------
    ase = first_of(CC.ArraySubscriptExpr)
    @test ase !== nothing
    @test !CC.is_null_handle(CC.getLHS(ase))
    @test !CC.is_null_handle(CC.getRHS(ase))
    @test CC.getBase(ase) isa CC.Expr_
    @test !CC.is_null_handle(CC.getIdx(ase))
    @test !CC.is_null_handle(CC.getRBracketLoc(ase))

    # ---- CallExpr ------------------------------------------------------------
    ce = first_of(CC.CallExpr)
    @test ce !== nothing
    @test CC.getCallee(ce) isa CC.Expr_
    @test !CC.is_null_handle(CC.getCalleeDecl(ce))
    @test !CC.is_null_handle(CC.getDirectCallee(ce))
    nargs = CC.getNumArgs(ce)
    @test nargs isa Integer
    @test CC.getArg(ce, 0) isa CC.Expr_
    # Upstream's bound assertion is compiled into the release library, so one past the end
    # aborts the process. The gate turning that into a Julia error is the only reason a caller
    # can be wrong here without taking the session down.
    @test_throws AssertionError CC.getArg(ce, nargs)
    @test !CC.is_null_handle(CC.getRParenLoc(ce))
    @test !(CC.usesADL(ce))
    @test CC.hasStoredFPFeatures(ce) == false
    @test CC.getBuiltinCallee(ce) == 0
    @test !(CC.isCallToStdMove(ce))

    # ---- MemberExpr ----------------------------------------------------------
    me = first_of(CC.MemberExpr)
    @test me !== nothing
    @test CC.getBase(me) isa CC.Expr_
    @test !CC.is_null_handle(CC.getMemberDecl(me))
    @test !(CC.isArrow(me))
    @test !CC.is_null_handle(CC.getMemberLoc(me))
    @test !(CC.isImplicitAccess(me))
    @test !CC.is_null_handle(CC.getMemberNameInfo(me))
    @test !(CC.hasQualifier(me))
    @test CC.is_null_handle(CC.getTemplateKeywordLoc(me))
    @test CC.is_null_handle(CC.getLAngleLoc(me))
    @test CC.is_null_handle(CC.getRAngleLoc(me))
    @test !(CC.hasTemplateKeyword(me))
    @test !(CC.hasExplicitTemplateArgs(me))
    @test CC.getNumTemplateArgs(me) == 0
    @test !CC.is_null_handle(CC.getOperatorLoc(me))
    @test !(CC.hadMultipleCandidates(me))
    @test CC.is_null_handle(CC.getQualifier(me))

    # ---- CastExpr / ImplicitCastExpr / ExplicitCastExpr ----------------------
    ice = first_of(CC.ImplicitCastExpr)
    @test ice !== nothing
    @test CC.getCastKind(ice) isa CC.LibClangEx.CXCastKind
    @test !isempty(CC.getCastKindName(ice))
    @test !CC.is_null_handle(CC.getSubExpr(ice))
    @test !CC.is_null_handle(CC.getSubExprAsWritten(ice))
    @test !(CC.isPartOfExplicitCast(ice))

    # CStyleCastExpr is an ExplicitCastExpr — covers getTypeAsWritten + own locs
    csc = first_of(CC.CStyleCastExpr)
    @test csc !== nothing
    @test CC.getTypeAsWritten(csc) isa CC.QualType
    @test !CC.is_null_handle(CC.getLParenLoc(csc))
    @test !CC.is_null_handle(CC.getRParenLoc(csc))

    # getPathElement needs a cast whose inheritance path is non-empty
    dtb = first(filter(n -> n isa CC.AbstractCastExpr &&
                            CC.getCastKindName(n) == "DerivedToBase", nodes))
    @test CC.getPathElement(dtb, 0).ptr != C_NULL

    # ---- BinaryOperator ------------------------------------------------------
    bo = first_of(CC.BinaryOperator)
    @test bo !== nothing
    @test CC.getOpcode(bo) isa CC.LibClangEx.CXBinaryOperatorKind
    @test !CC.is_null_handle(CC.getLHS(bo))
    @test !CC.is_null_handle(CC.getRHS(bo))
    @test !CC.is_null_handle(CC.getOperatorLoc(bo))
    @test !isempty(CC.getOpcodeStr(bo))
    @test !(CC.isAssignmentOp(bo))
    @test !(CC.isCompoundAssignmentOp(bo))
    @test !(CC.isComparisonOp(bo))

    # ---- CompoundAssignOperator ----------------------------------------------
    cao = first_of(CC.CompoundAssignOperator)
    @test cao !== nothing
    @test !CC.is_null_handle(CC.getComputationLHSType(cao))
    @test !CC.is_null_handle(CC.getComputationResultType(cao))

    # ---- ConditionalOperator -------------------------------------------------
    co = first_of(CC.ConditionalOperator)
    @test co !== nothing
    @test !CC.is_null_handle(CC.getCond(co))
    @test !CC.is_null_handle(CC.getTrueExpr(co))
    @test !CC.is_null_handle(CC.getFalseExpr(co))

    # ---- InitListExpr --------------------------------------------------------
    ile = first_of(CC.InitListExpr)
    @test ile !== nothing
    @test CC.getNumInits(ile) == 3
    @test CC.getInit(ile, 0) isa CC.Expr_
    @test_throws AssertionError CC.getInit(ile, CC.getNumInits(ile))  # the restated clang assert (Invariant 3)
    @test CC.isSemanticForm(ile)
    @test CC.getSyntacticForm(ile) isa CC.InitListExpr
    @test CC.getSemanticForm(ile) isa CC.InitListExpr
    @test !(CC.hasArrayFiller(ile))
    @test !(CC.hasDesignatedInit(ile))
    @test CC.isExplicit(ile)
    @test !(CC.isStringLiteralInit(ile))
    @test !(CC.isTransparent(ile))
    @test !CC.is_null_handle(CC.getLBraceLoc(ile))
    @test !CC.is_null_handle(CC.getRBraceLoc(ile))
    @test !(CC.isSyntacticForm(ile))
    @test !(CC.hadArrayRangeDesignator(ile))
    @test CC.getArrayFiller(ile) isa CC.Expr_
    @test CC.is_null_handle(CC.getInitializedFieldInUnion(ile))

    # ---- DeclRefExpr ---------------------------------------------------------
    dre = first_of(CC.DeclRefExpr)
    @test dre !== nothing
    @test CC.getDecl(dre) isa CC.ValueDecl
    @test CC.getFoundDecl(dre) isa CC.NamedDecl
    @test !(CC.hasQualifier(dre))
    @test !CC.is_null_handle(CC.getLocation(dre))
    @test !CC.is_null_handle(CC.getNameInfo(dre))
    @test !(CC.hasTemplateKWAndArgsInfo(dre))
    @test CC.is_null_handle(CC.getTemplateKeywordLoc(dre))
    @test CC.is_null_handle(CC.getLAngleLoc(dre))
    @test CC.is_null_handle(CC.getRAngleLoc(dre))
    @test !(CC.hasTemplateKeyword(dre))
    @test !(CC.hasExplicitTemplateArgs(dre))
    @test CC.getNumTemplateArgs(dre) == 0
    @test !(CC.hadMultipleCandidates(dre))
    @test !(CC.refersToEnclosingVariableOrCapture(dre))
    @test !(CC.isImmediateEscalating(dre))
    @test !(CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre))
    @test CC.is_null_handle(CC.getQualifier(dre))

    # ---- UnaryExprOrTypeTraitExpr (sizeof) -----------------------------------
    uetts = byT(CC.UnaryExprOrTypeTraitExpr)
    @test !isempty(uetts)
    for u in uetts
        @test CC.isArgumentType(u) == (u == first(uetts))
        @test !CC.is_null_handle(CC.getTypeOfArgument(u))
        @test CC.getKind(u) isa CC.LibClangEx.CXUnaryExprOrTypeTrait
        @test !CC.is_null_handle(CC.getOperatorLoc(u))
        @test !CC.is_null_handle(CC.getRParenLoc(u))
        if CC.isArgumentType(u)
            @test !CC.is_null_handle(CC.getArgumentType(u))
            @test !CC.is_null_handle(CC.getArgumentTypeInfo(u))
        else
            @test !CC.is_null_handle(CC.getArgumentExpr(u))
        end
    end

    # ---- PredefinedExpr (__func__) -------------------------------------------
    pde = first_of(CC.PredefinedExpr)
    @test pde !== nothing
    @test CC.getIdentKind(pde) isa CC.LibClangEx.CXPredefinedIdentKind
    @test !CC.is_null_handle(CC.getFunctionName(pde))
    @test !isempty(CC.getIdentKindName(pde))

    # ---- StmtExpr ({ ...; }) -------------------------------------------------
    se = first_of(CC.StmtExpr)
    @test se !== nothing
    @test !CC.is_null_handle(CC.getLParenLoc(se))
    @test !CC.is_null_handle(CC.getRParenLoc(se))
    @test CC.getTemplateDepth(se) isa Integer
    @test CC.getSubStmt(se) isa CC.CompoundStmt

    # ---- CompoundLiteralExpr ((PointT){1,2}) ---------------------------------
    cle = first_of(CC.CompoundLiteralExpr)
    @test cle !== nothing
    @test !(CC.isFileScope(cle))
    @test !CC.is_null_handle(CC.getLParenLoc(cle))
    @test !CC.is_null_handle(CC.getInitializer(cle))
    @test !CC.is_null_handle(CC.getTypeSourceInfo(cle))

    # ---- ConstantExpr (immediate consteval invocation) -----------------------
    cst = first_of(CC.ConstantExpr)
    @test cst !== nothing
    @test CC.isImmediateInvocation(cst)
    @test CC.hasAPValueResult(cst)

    dispose(lookup)
    dispose(I)
end

@testset "Expr with-args tail (expr-core)" begin
    LX = CC.LibClangEx

    # ---- static opcode queries (no AST needed) ------------------------------
    @test CC.isAdditiveOp(LX.CXBinaryOperatorKind_BO_Add)
    @test CC.isMultiplicativeOp(LX.CXBinaryOperatorKind_BO_Mul)
    @test CC.isShiftOp(LX.CXBinaryOperatorKind_BO_Shl)
    @test CC.isBitwiseOp(LX.CXBinaryOperatorKind_BO_And)
    @test CC.isRelationalOp(LX.CXBinaryOperatorKind_BO_LT)
    @test CC.isEqualityOp(LX.CXBinaryOperatorKind_BO_EQ)
    @test CC.isCommaOp(LX.CXBinaryOperatorKind_BO_Comma)
    @test CC.isLogicalOp(LX.CXBinaryOperatorKind_BO_LAnd)
    @test CC.isShiftAssignOp(LX.CXBinaryOperatorKind_BO_ShlAssign)
    @test CC.isPtrMemOp(LX.CXBinaryOperatorKind_BO_PtrMemD)
    @test CC.isAdditiveOp(LX.CXBinaryOperatorKind_BO_Mul) == false
    @test CC.negateComparisonOp(LX.CXBinaryOperatorKind_BO_EQ) ==
          LX.CXBinaryOperatorKind_BO_NE
    @test CC.reverseComparisonOp(LX.CXBinaryOperatorKind_BO_LT) ==
          LX.CXBinaryOperatorKind_BO_GT
    @test CC.getOpForCompoundAssignment(LX.CXBinaryOperatorKind_BO_AddAssign) ==
          LX.CXBinaryOperatorKind_BO_Add
    @test CC.getOverloadedOperator(LX.CXBinaryOperatorKind_BO_Add) isa
          LX.CXOverloadedOperatorKind
    @test CC.getOverloadedOpcode(LX.CXOverloadedOperatorKind_OO_Plus) isa
          LX.CXBinaryOperatorKind
    @test CC.getOpcodeStr(LX.CXUnaryOperatorKind_UO_Minus) == "-"
    @test CC.getOverloadedOperator(LX.CXUnaryOperatorKind_UO_Minus) isa
          LX.CXOverloadedOperatorKind
    @test CC.getOverloadedOpcode(LX.CXOverloadedOperatorKind_OO_PlusPlus, true) isa
          LX.CXUnaryOperatorKind

    # ---- live AST -----------------------------------------------------------
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             struct ExprCoreRec { int a; int b; };
             int exprcore_callee(int x) { return x; }
             int exprcore_use(int n) {
                 int arr[3] = {1, 2, 3};
                 double d = 1.5;
                 const char *s = "abc";
                 int *p = nullptr;
                 ExprCoreRec r{.a = 1, .b = 2};
                 int q = exprcore_callee(n) + arr[1] + r.a;
                 return q + (n ? 1 : 0) + (int)d + (p == nullptr);
             }
             """)
    ctx = CC.get_ast_context(I)
    lang_opts = CC.getLangOpts(ctx)
    @test lang_opts isa CC.LangOptions

    lookup = DeclFinder(I)
    @test lookup(I, "exprcore_use")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    # ---- Expr: ASTContext-taking classification -----------------------------
    ils = filter(n -> n isa CC.IntegerLiteral, nodes)
    @test !isempty(ils)
    il = first(ils)

    @test CC.getObjectKind(il) isa LX.CXExprObjectKind
    @test !(CC.isKnownToHaveBooleanValue(il, true))
    @test CC.isCXX98IntegralConstantExpr(il, ctx)
    @test CC.isConstantInitializer(il, ctx, false)
    @test CC.HasSideEffects(il, ctx, true) == false
    @test CC.hasNonTrivialCall(il, ctx) == false
    @test CC.isBoundMemberFunction(il, ctx) == false
    @test !(CC.isSameComparisonOperand(il, il))
    @test CC.is_null_handle(CC.findBoundMemberType(il))
    @test CC.getValueKindForType(CC.getType(il)) isa LX.CXExprValueKind
    @test CC.is_null_handle(CC.getSourceBitField(il))
    @test CC.is_null_handle(CC.getReferencedDeclOfCallee(il))
    # only meaningful for class / pointer-to-class expressions; the wrapper's
    # precondition rejects an int literal instead of letting clang's unchecked
    # castAs<RecordType> run (crashed on Windows CI)
    @test_throws AssertionError CC.getBestDynamicClassType(il)
    @test CC.is_null_handle(CC.getAsBuiltinConstantDeclRef(il, ctx))

    for f in (CC.IgnoreImplicit, CC.IgnoreImplicitAsWritten, CC.IgnoreParenBaseCasts,
              CC.IgnoreParenLValueCasts, CC.IgnoreUnlessSpelledInSource)
        @test f(il) isa CC.Expr_
    end
    @test !CC.is_null_handle(CC.IgnoreParenNoopCasts(il, ctx))

    # integer folding: the three APSInt bridges all hand back an owned GenericValue
    @test CC.isIntegerConstantExpr(il, ctx)
    @test CC.getIntegerConstantExpr(il, ctx) != C_NULL
    @test CC.EvaluateKnownConstInt(il, ctx) != C_NULL
    @test CC.EvaluateKnownConstIntCheckOverflow(il, ctx) != C_NULL

    apv = CC.EvaluateAsConstantExpr(il, ctx, LX.CXExpr_ConstantExprKind_Normal)
    @test apv isa CC.APValue
    apv.ptr == C_NULL || dispose(apv)

    lv = CC.EvaluateAsLValue(il, ctx, false)
    @test lv isa CC.APValue
    lv.ptr == C_NULL || dispose(lv)

    ok_sz, sz = CC.tryEvaluateObjectSize(il, ctx, 0)
    @test ok_sz isa Bool && sz isa UInt64
    ok_len, slen = CC.tryEvaluateStrLen(il, ctx)
    @test ok_len isa Bool && slen isa UInt64

    # nullptr classification
    nps = filter(n -> n isa CC.CXXNullPtrLiteralExpr, nodes)
    if !isempty(nps)
        @test CC.isNullPointerConstant(first(nps), ctx,
                                       LX.CXExpr_NPC_NeverValueDependent) isa
              LX.CXExpr_NullPointerConstantKind
    end

    # ---- CallExpr -----------------------------------------------------------
    ces = filter(n -> n isa CC.CallExpr, nodes)
    @test !isempty(ces)
    ce = first(ces)
    @test !CC.is_null_handle(CC.getCallReturnType(ce, ctx))
    @test !(CC.hasUnusedResultAttr(ce, ctx))
    @test CC.isUnevaluatedBuiltinCall(ce, ctx) == false
    @test CC.isBuiltinAssumeFalse(ce, ctx) == false
    @test CC.is_null_handle(CC.getUnusedResultAttr(ce, ctx))
    rp = CC.getRParenLoc(ce)
    CC.setRParenLoc(ce, rp)
    @test CC.getRParenLoc(ce).ptr == rp.ptr

    # ---- MemberExpr ---------------------------------------------------------
    mes = filter(n -> n isa CC.MemberExpr, nodes)
    @test !isempty(mes)
    me = first(mes)
    @test CC.getFoundDecl(me) isa CC.NamedDecl
    @test CC.getFoundDeclAccess(me) isa LX.CXAccessSpecifier
    @test CC.isNonOdrUse(me) isa LX.CXNonOdrUseReason
    @test CC.performsVirtualDispatch(me, lang_opts)
    @test CC.getNumTemplateArgs(me) == 0
    ml = CC.getMemberLoc(me)
    CC.setMemberLoc(me, ml)
    @test CC.getMemberLoc(me).ptr == ml.ptr

    # ---- DeclRefExpr --------------------------------------------------------
    dres = filter(n -> n isa CC.DeclRefExpr, nodes)
    @test !isempty(dres)
    dre = first(dres)
    @test CC.isNonOdrUse(dre) isa LX.CXNonOdrUseReason
    @test CC.getNumTemplateArgs(dre) == 0
    dl = CC.getLocation(dre)
    CC.setLocation(dre, dl)
    @test CC.getLocation(dre).ptr == dl.ptr

    # ---- ExplicitCastExpr / CastExpr ---------------------------------------
    css = filter(n -> n isa CC.CStyleCastExpr, nodes)
    @test !isempty(css)
    @test !CC.is_null_handle(CC.getTypeInfoAsWritten(first(css)))
    # only valid for union destination types; the wrapper's precondition
    # rejects anything else instead of letting clang dereference a null record
    @test_throws AssertionError CC.getTargetFieldForToUnionCast(CC.getType(first(css)),
                                                                CC.getType(il))
    # a null QualType is rejected before the gate reads it -- `getTypePtr` asserts, so the
    # gate would otherwise abort the process instead of raising
    @test_throws AssertionError CC.getTargetFieldForToUnionCast(CC.QualType(C_NULL),
                                                                CC.getType(il))

    # ---- ConditionalOperator ------------------------------------------------
    cos = filter(n -> n isa CC.ConditionalOperator, nodes)
    @test !isempty(cos)
    @test !CC.is_null_handle(CC.getQuestionLoc(first(cos)))
    @test !CC.is_null_handle(CC.getColonLoc(first(cos)))

    # ---- FloatingLiteral ----------------------------------------------------
    fls = filter(n -> n isa CC.FloatingLiteral, nodes)
    @test !isempty(fls)
    fl = first(fls)
    @test CC.getValue(fl) != C_NULL
    @test CC.isExact(fl)
    flloc = CC.getLocation(fl)
    CC.setLocation(fl, flloc)
    @test CC.getLocation(fl).ptr == flloc.ptr

    # ---- StringLiteral ------------------------------------------------------
    sls = filter(n -> n isa CC.StringLiteral, nodes)
    @test !isempty(sls)
    sl = first(sls)
    @test CC.getNumConcatenated(sl) >= 1
    @test !CC.is_null_handle(CC.getStrTokenLoc(sl, 0))
    @test CC.getCodeUnit(sl, 0) == UInt32('a')

    # ---- InitListExpr -------------------------------------------------------
    iles = filter(n -> n isa CC.InitListExpr, nodes)
    @test !isempty(iles)
    ile = first(iles)
    @test !(CC.isIdiomaticZeroInitializer(ile, lang_opts))
    lb = CC.getLBraceLoc(ile)
    CC.setLBraceLoc(ile, lb)
    @test CC.getLBraceLoc(ile).ptr == lb.ptr
    rb = CC.getRBraceLoc(ile)
    CC.setRBraceLoc(ile, rb)
    @test CC.getRBraceLoc(ile).ptr == rb.ptr

    # ---- DesignatedInitExpr / Designator ------------------------------------
    # the designators live on the syntactic form, which `subtree` does not walk
    dies = CC.DesignatedInitExpr[]
    for n in iles
        syn = CC.getSyntacticForm(n)
        syn.ptr == C_NULL && continue
        append!(dies, filter(m -> m isa CC.DesignatedInitExpr, CC.subtree(syn)))
    end
    if !isempty(dies)
        die = first(dies)
        @test CC.size(die) >= 1
        @test CC.getNumSubExprs(die) >= 1
        @test CC.getInit(die) isa CC.Expr_
        @test !CC.is_null_handle(CC.getSubExpr(die, 0))
        @test !(CC.isDirectInit(die))
        @test !(CC.usesGNUSyntax(die))
        @test !CC.is_null_handle(CC.getEqualOrColonLoc(die))
        @test !CC.is_null_handle(CC.getBeginLoc(CC.getDesignatorsSourceRange(die)))

        d = CC.getDesignator(die, 0)
        @test d isa CC.Designator
        @test CC.isFieldDesignator(d)
        @test !(CC.isArrayDesignator(d))
        @test !(CC.isArrayRangeDesignator(d))
        @test !CC.is_null_handle(CC.getBeginLoc(d))
        @test !CC.is_null_handle(CC.getEndLoc(d))
        if CC.isFieldDesignator(d)
            @test !CC.is_null_handle(CC.getFieldName(d))
            @test !CC.is_null_handle(CC.getFieldDecl(d))
            @test !CC.is_null_handle(CC.getDotLoc(d))
            @test !CC.is_null_handle(CC.getFieldLoc(d))
        elseif CC.isArrayDesignator(d) || CC.isArrayRangeDesignator(d)
            @test CC.getArrayIndex(d) isa Unsigned
            @test !CC.is_null_handle(CC.getLBracketLoc(d))
            @test !CC.is_null_handle(CC.getRBracketLoc(d))
            @test CC.getArrayIndex(die, d) isa CC.Expr_
        end
    end

    dispose(lookup)
    dispose(I)
end

@testset "expr tail: atomic/generic-selection/choose/shuffle/ext-vector" begin
    I = CC.create_interpreter(String[])
    CC.parse(I, """
    typedef int cc_v4i __attribute__((ext_vector_type(4)));
    int cc_expr_tail(int *p, int n, cc_v4i v) {
        int a = __atomic_load_n(p, __ATOMIC_SEQ_CST);
        int g = _Generic(n, int: 1, default: 2);
        int c = __builtin_choose_expr(1, 10, 20);
        cc_v4i s = __builtin_shufflevector(v, v, 0, 1, 2, 3);
        int e = v.x;
        return a + g + c + e + s.y;
    }
    """)
    f = CC.DeclFinder(I)
    @test f(I, "cc_expr_tail")
    fd = CC.FunctionDecl(CC.get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # AtomicExpr — __atomic_load_n(p, seq_cst)
    ae = pick(CC.AtomicExpr)
    @test ae isa CC.AtomicExpr
    @test CC.getOp(ae) >= 0
    @test occursin("atomic_load", CC.getOpAsString(ae))
    @test CC.getNumSubExprs(ae) >= 2
    @test !CC.is_null_handle(CC.getSubExpr(ae, 0))
    @test CC.getSubExpr(ae, 0).ptr != C_NULL
    @test CC.getSubExpr(ae, CC.getNumSubExprs(ae) - 1).ptr != C_NULL
    @test CC.isCmpXChg(ae) == false

    # GenericSelectionExpr — expression-predicated, not result-dependent
    gse = pick(CC.GenericSelectionExpr)
    @test gse isa CC.GenericSelectionExpr
    @test CC.getNumAssocs(gse) == 2
    @test CC.isExprPredicate(gse) == true
    @test CC.isResultDependent(gse) == false
    @test 0 <= CC.getResultIndex(gse) < CC.getNumAssocs(gse)
    @test !CC.is_null_handle(CC.getControllingExpr(gse))
    @test CC.getControllingExpr(gse).ptr != C_NULL
    @test CC.getAssocExpr(gse, 0).ptr != C_NULL
    @test CC.getAssocExpr(gse, CC.getNumAssocs(gse) - 1).ptr != C_NULL

    # ChooseExpr — __builtin_choose_expr(1, 10, 20)
    ce = pick(CC.ChooseExpr)
    @test ce isa CC.ChooseExpr
    @test CC.isConditionDependent(ce) == false
    @test CC.isConditionTrue(ce) == true
    @test !CC.is_null_handle(CC.getCond(ce))
    @test CC.getCond(ce).ptr != C_NULL
    @test CC.getLHS(ce).ptr != C_NULL
    @test CC.getRHS(ce).ptr != C_NULL

    # ShuffleVectorExpr — two vector operands plus the constant mask
    sve = pick(CC.ShuffleVectorExpr)
    @test sve isa CC.ShuffleVectorExpr
    @test CC.getNumSubExprs(sve) >= 2
    @test !CC.is_null_handle(CC.getExpr(sve, 0))
    @test CC.getExpr(sve, 0).ptr != C_NULL
    @test CC.getExpr(sve, CC.getNumSubExprs(sve) - 1).ptr != C_NULL

    # ExtVectorElementExpr — v.x selects one component
    eve = pick(CC.ExtVectorElementExpr)
    @test eve isa CC.ExtVectorElementExpr
    @test CC.getBase(eve) isa CC.Expr_
    @test CC.getBase(eve).ptr != C_NULL
    @test CC.getNumElements(eve) == 1

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Expr subclasses: conditional/opaque/addrlabel/gnunull/vaarg accessors" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             int cond_fn(int n) {
                 int a = n ? 10 : 20;      // ConditionalOperator
                 int b = n ?: 30;          // BinaryConditionalOperator + OpaqueValueExpr
                 void *p = __null;          // GNUNullExpr
                 void *q = &&lbl;           // AddrLabelExpr (GNU label address)
             lbl:
                 return a + b + (p != __null) + (int)(long)q;
             }
             int va_fn(int count, ...) {
                 __builtin_va_list ap;
                 __builtin_va_start(ap, count);
                 int x = __builtin_va_arg(ap, int);   // VAArgExpr
                 __builtin_va_end(ap);
                 return x;
             }
             """)

    lookup = DeclFinder(I)

    @test lookup(I, "cond_fn")
    cond_fd = CC.FunctionDecl(get_decl(lookup))
    cnodes = CC.subtree(CC.getBody(cond_fd))

    # ConditionalOperator: getLHS/getRHS coincide with getTrueExpr/getFalseExpr.
    co = first(filter(n -> n isa CC.ConditionalOperator, cnodes))
    @test CC.getLHS(co) isa CC.AbstractExpr
    @test CC.getRHS(co) isa CC.AbstractExpr
    @test CC.getLHS(co).ptr == CC.getTrueExpr(co).ptr
    @test CC.getRHS(co).ptr == CC.getFalseExpr(co).ptr

    # BinaryConditionalOperator + OpaqueValueExpr: the opaque value's source
    # expression is exactly the common expression (Clang's constructor asserts it).
    bco = first(filter(n -> n isa CC.BinaryConditionalOperator, cnodes))
    common = CC.getCommon(bco)
    @test common isa CC.AbstractExpr
    ove = CC.getOpaqueValue(bco)
    @test ove isa CC.OpaqueValueExpr
    @test CC.getSourceExpr(ove).ptr == common.ptr
    @test !(CC.isUnique(ove))
    @test !CC.is_null_handle(CC.getLocation(ove))

    # `clang::AbstractConditionalOperator` is the base both spellings share, and it is not
    # mirrored -- no carrier, no abstract type. The predicate survives, because "is this
    # expression any kind of conditional?" is a real question, and it must agree with the
    # concrete classifications rather than drifting from them.
    @test CC.isAbstractConditionalOperator(co)
    @test CC.isAbstractConditionalOperator(bco)

    # What the base declares is exposed on both spellings instead. Each accessor is written
    # out per class, so what is worth checking is that the five agree with the node they were
    # called on -- the operands are children of it, and the two locations are distinct members.
    for cond in (co, bco)
        kids = collect(CC.children(cond))
        @test CC.getCond(cond) in kids
        @test CC.getTrueExpr(cond) in kids
        @test CC.getFalseExpr(cond) in kids
        # two distinct members, so a shim reading the sibling one shows up right here
        @test CC.getQuestionLoc(cond) != CC.getColonLoc(cond)
    end

    # the two spellings are siblings, so a ConditionalOperator-only accessor cannot reach the
    # other -- which is what stops `getLHS` reading a BinaryConditionalOperator's storage
    @test CC.getLHS(co) in collect(CC.children(co))
    @test_throws MethodError CC.getLHS(bco)

    # a node that is neither spelling answers the predicate honestly
    non_cond = CC.getCond(co)
    @test !CC.isAbstractConditionalOperator(non_cond)

    # GNUNullExpr
    gn = first(filter(n -> n isa CC.GNUNullExpr, cnodes))
    @test !CC.is_null_handle(CC.getTokenLocation(gn))

    # AddrLabelExpr
    al = first(filter(n -> n isa CC.AddrLabelExpr, cnodes))
    @test CC.getLabel(al) isa CC.LabelDecl
    @test !CC.is_null_handle(CC.getAmpAmpLoc(al))
    @test !CC.is_null_handle(CC.getLabelLoc(al))

    # VAArgExpr
    @test lookup(I, "va_fn")
    va_fd = CC.FunctionDecl(get_decl(lookup))
    vnodes = CC.subtree(CC.getBody(va_fd))
    va = first(filter(n -> n isa CC.VAArgExpr, vnodes))
    @test CC.isMicrosoftABI(va) isa Bool  # shape-only: the target ABI decides this (MSVC vs MinGW)
    @test !CC.is_null_handle(CC.getWrittenTypeInfo(va))
    @test !CC.is_null_handle(CC.getBuiltinLoc(va))
    @test !CC.is_null_handle(CC.getRParenLoc(va))

    dispose(I)
end

@testset "Expr subclasses: matrix/convertvector/imaginary/block/sourceloc/choose" begin
    # MatrixSubscriptExpr (needs -fenable-matrix)
    Im = create_interpreter(["-std=gnu++20", "-fenable-matrix"])
    CC.parse(Im,
             """
             typedef float cc_mat4 __attribute__((matrix_type(4, 4)));
             float cc_mat_elem(cc_mat4 m) { return m[1][2]; }
             """)
    lm = DeclFinder(Im)
    @test lm(Im, "cc_mat_elem")
    mfd = CC.FunctionDecl(get_decl(lm))
    mse = first(filter(n -> n isa CC.MatrixSubscriptExpr, CC.subtree(CC.getBody(mfd))))
    @test !(CC.isIncomplete(mse))
    @test CC.getBase(mse) isa CC.Expr_
    @test CC.getBase(mse).ptr != C_NULL
    @test !CC.is_null_handle(CC.getRowIdx(mse))
    @test CC.getRowIdx(mse).ptr != C_NULL
    @test !CC.is_null_handle(CC.getColumnIdx(mse))
    @test !CC.is_null_handle(CC.getRBracketLoc(mse))
    dispose(lm)
    dispose(Im)

    # ConvertVectorExpr / ImaginaryLiteral / SourceLocExpr / ChooseExpr
    I = create_interpreter(["-std=gnu++20"])
    CC.parse(I,
             """
             typedef float cc_f4 __attribute__((ext_vector_type(4)));
             typedef int cc_i4 __attribute__((ext_vector_type(4)));
             cc_i4 cc_cv(cc_f4 v) { return __builtin_convertvector(v, cc_i4); }
             _Complex double cc_imag(void) { return 2.0i; }
             const char *cc_file(void) { return __builtin_FILE(); }
             int cc_choose(void) { return __builtin_choose_expr(1, 10, 20); }
             """)
    lookup = DeclFinder(I)

    @test lookup(I, "cc_cv")
    cvfd = CC.FunctionDecl(get_decl(lookup))
    cve = first(filter(n -> n isa CC.ConvertVectorExpr, CC.subtree(CC.getBody(cvfd))))
    @test !CC.is_null_handle(CC.getSrcExpr(cve))
    @test CC.getSrcExpr(cve).ptr != C_NULL
    @test !CC.is_null_handle(CC.getTypeSourceInfo(cve))
    @test !CC.is_null_handle(CC.getBuiltinLoc(cve))
    @test !CC.is_null_handle(CC.getRParenLoc(cve))

    @test lookup(I, "cc_imag")
    imfd = CC.FunctionDecl(get_decl(lookup))
    il = first(filter(n -> n isa CC.ImaginaryLiteral, CC.subtree(CC.getBody(imfd))))
    @test !CC.is_null_handle(CC.getSubExpr(il))
    @test CC.getSubExpr(il).ptr != C_NULL

    @test lookup(I, "cc_file")
    slfd = CC.FunctionDecl(get_decl(lookup))
    sle = first(filter(n -> n isa CC.SourceLocExpr, CC.subtree(CC.getBody(slfd))))
    @test !isempty(CC.getBuiltinStr(sle))
    @test occursin("FILE", CC.getBuiltinStr(sle))
    @test !(CC.isIntType(sle))
    @test !CC.is_null_handle(CC.getParentContext(sle))
    @test !CC.is_null_handle(CC.getLocation(sle))

    @test lookup(I, "cc_choose")
    chfd = CC.FunctionDecl(get_decl(lookup))
    ce = first(filter(n -> n isa CC.ChooseExpr, CC.subtree(CC.getBody(chfd))))
    @test CC.isConditionDependent(ce) == false
    @test !CC.is_null_handle(CC.getChosenSubExpr(ce))
    @test CC.getChosenSubExpr(ce).ptr == CC.getLHS(ce).ptr
    @test !CC.is_null_handle(CC.getBuiltinLoc(ce))
    @test !CC.is_null_handle(CC.getRParenLoc(ce))

    dispose(lookup)
    dispose(I)

    # BlockExpr (needs -fblocks)
    Ib = create_interpreter(["-std=gnu++20", "-fblocks"])
    CC.parse(Ib,
             """
             void cc_block(void) { int (^blk)(void) = ^int(void) { return 7; }; (void)blk; }
             """)
    lb = DeclFinder(Ib)
    @test lb(Ib, "cc_block")
    bfd = CC.FunctionDecl(get_decl(lb))
    be = first(filter(n -> n isa CC.BlockExpr, CC.subtree(CC.getBody(bfd))))
    @test !CC.is_null_handle(CC.getBlockDecl(be))
    @test CC.getBlockDecl(be).ptr != C_NULL
    @test !CC.is_null_handle(CC.getCaretLocation(be))
    @test CC.getBody(be) isa CC.AbstractStmt
    dispose(lb)
    dispose(Ib)
end

@testset "expr-d: atomic/generic-selection/array-init-loop/pseudo-object accessors" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    int cc_exprd(int *p, int n) {
        int a = __atomic_load_n(p, __ATOMIC_SEQ_CST);   // AtomicExpr
        int g = _Generic(n, int: 1, default: 2);        // GenericSelectionExpr
        int arr[3] = {1, 2, 3};
        auto lam = [arr]() { return arr[0]; };           // ArrayInitLoopExpr capture-init
        return a + g + lam();
    }
    """)
    f = DeclFinder(I)
    @test f(I, "cc_exprd")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # AtomicExpr — __atomic_load_n(p, seq_cst): ptr/order slots are always present
    ae = pick(CC.AtomicExpr)
    @test ae isa CC.AtomicExpr
    @test CC.getPtr(ae) isa CC.Expr_
    @test CC.getPtr(ae).ptr != C_NULL
    @test !CC.is_null_handle(CC.getOrder(ae))
    @test CC.getOrder(ae).ptr != C_NULL
    @test !CC.is_null_handle(CC.getValueType(ae))
    @test CC.isVolatile(ae) == false           # pointee `int` is not volatile-qualified
    @test CC.isOpenCL(ae) == false             # not an __opencl_atomic_* builtin
    @test !CC.is_null_handle(CC.getBuiltinLoc(ae))
    @test !CC.is_null_handle(CC.getRParenLoc(ae))

    # GenericSelectionExpr — _Generic(n, ...): expression-predicated, concrete result
    gse = pick(CC.GenericSelectionExpr)
    @test gse isa CC.GenericSelectionExpr
    @test CC.isTypePredicate(gse) == false
    @test !CC.is_null_handle(CC.getResultExpr(gse))
    @test CC.getResultExpr(gse).ptr != C_NULL
    @test !CC.is_null_handle(CC.getGenericLoc(gse))
    @test !CC.is_null_handle(CC.getDefaultLoc(gse))
    @test !CC.is_null_handle(CC.getRParenLoc(gse))

    # ArrayInitLoopExpr — array-by-value lambda capture copies element-wise
    ail = pick(CC.ArrayInitLoopExpr)
    @test ail isa CC.ArrayInitLoopExpr
    @test CC.getCommonExpr(ail) isa CC.OpaqueValueExpr
    @test CC.getCommonExpr(ail).ptr != C_NULL
    @test !CC.is_null_handle(CC.getSubExpr(ail))
    @test CC.getSubExpr(ail).ptr != C_NULL

    dispose(f)
    dispose(I)

    # PseudoObjectExpr — MS property read lowers to a getter call under a
    # syntactic MSPropertyRefExpr (needs -fms-extensions to parse __declspec).
    I2 = create_interpreter(["-std=c++20", "-fms-extensions"])
    CC.parse(I2, """
    struct cc_prop {
        int get_v();
        void set_v(int);
        __declspec(property(get = get_v, put = set_v)) int v;
    };
    int cc_use_prop(cc_prop &s) { return s.v; }
    """)
    f2 = DeclFinder(I2)
    @test f2(I2, "cc_use_prop")
    fd2 = CC.FunctionDecl(get_decl(f2))
    poe = nothing
    for n in CC.subtree(CC.getBody(fd2))
        if n isa CC.PseudoObjectExpr
            poe = n
            break
        end
    end
    @test poe isa CC.PseudoObjectExpr
    @test CC.getSyntacticForm(poe) isa CC.Expr_
    @test CC.getSyntacticForm(poe).ptr != C_NULL
    @test CC.getNumSemanticExprs(poe) >= 1
    @test 0 <= CC.getResultExprIndex(poe) < CC.getNumSemanticExprs(poe)
    @test CC.getResultExpr(poe).ptr != C_NULL
    # the result is the semantic expression the result index names. That relationship is
    # what ties the two accessors together; `isa Expr_` holds even if one of them reads
    # the syntactic form or an adjacent slot.
    @test CC.getResultExpr(poe).ptr ==
          CC.getSemanticExpr(poe, CC.getResultExprIndex(poe)).ptr
    @test !CC.is_null_handle(CC.getSemanticExpr(poe, 0))
    @test CC.getSemanticExpr(poe, 0).ptr != C_NULL

    dispose(f2)
    dispose(I2)
end

@testset "expr-e: offsetof components / ext-vector accessor / conversion step" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             typedef float cc_e_v4f __attribute__((ext_vector_type(4)));
             struct cc_e_base { int bx; };
             struct cc_e_mid : cc_e_base {};
             struct cc_e_inner { float f; double d; };
             struct cc_e_outer { int i; cc_e_inner s[4]; };
             struct cc_e_conv { operator int() const { return 7; } };
             unsigned long cc_e_fn(cc_e_v4f v, cc_e_v4f *pv, cc_e_conv c) {
                 unsigned long a = __builtin_offsetof(cc_e_inner, d);
                 unsigned long b = __builtin_offsetof(cc_e_outer, s[2].d);
                 unsigned long e = __builtin_offsetof(cc_e_mid, bx);
                 float p = v.x;
                 cc_e_v4f q = v.xxyy;
                 float r = pv->y;
                 int t = c;
                 return a + b + e + (unsigned long)(p + q.x + r + t);
             }
             """)
    lookup = DeclFinder(I)
    @test lookup(I, "cc_e_fn")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    # OffsetOfExpr / OffsetOfNode
    offs = filter(n -> n isa CC.OffsetOfExpr, nodes)
    @test length(offs) >= 3
    saw_field = false
    saw_array = false
    saw_base = false
    for oe in offs
        nc = CC.getNumComponents(oe)
        ne = CC.getNumExpressions(oe)
        @test nc >= 1
        @test ne isa Integer
        @test CC.isValid(CC.getOperatorLoc(oe))
        @test CC.isValid(CC.getRParenLoc(oe))
        tsi = CC.getTypeSourceInfo(oe)
        @test tsi isa CC.TypeSourceInfo
        @test tsi.ptr != C_NULL
        for i in 0:(nc - 1)
            comp = CC.getComponent(oe, i)
            @test comp isa CC.OffsetOfNode
            @test comp.ptr != C_NULL
            k = CC.getKind(comp)
            @test k isa CC.LibClangEx.CXOffsetOfNode_Kind
            @test CC.getRawEncoding(CC.getBeginLoc(comp)) == CC.getRawEncoding(CC.getBeginLoc(CC.getSourceRange(comp)))
            @test CC.getRawEncoding(CC.getEndLoc(comp)) == CC.getRawEncoding(CC.getEndLoc(CC.getSourceRange(comp)))
            rng = CC.getSourceRange(comp)
            @test rng isa CC.SourceRange
            @test CC.getRawEncoding(CC.getBeginLoc(rng)) ==
                  CC.getRawEncoding(CC.getBeginLoc(comp))
            @test CC.getRawEncoding(CC.getEndLoc(rng)) ==
                  CC.getRawEncoding(CC.getEndLoc(comp))
            if k == CC.LibClangEx.CXOffsetOfNode_Kind_Field
                saw_field = true
                f = CC.getField(comp)
                @test f isa CC.FieldDecl
                @test f.ptr != C_NULL
                @test CC.getName(CC.getFieldName(comp)) == CC.getNameAsString(f)
            elseif k == CC.LibClangEx.CXOffsetOfNode_Kind_Array
                saw_array = true
                j = CC.getArrayExprIndex(comp)
                @test j < ne
                ix = CC.getIndexExpr(oe, j)
                @test ix isa CC.Expr_
                @test ix.ptr != C_NULL
            elseif k == CC.LibClangEx.CXOffsetOfNode_Kind_Base
                saw_base = true
                bs = CC.getBase(comp)
                @test bs isa CC.CXXBaseSpecifier
                @test bs.ptr != C_NULL
            end
        end
    end
    @test saw_field
    @test saw_array
    @test saw_base

    # ExtVectorElementExpr — v.x, v.xxyy (duplicates), pv->y (arrow), q.x
    eves = filter(n -> n isa CC.ExtVectorElementExpr, nodes)
    @test length(eves) >= 3
    @test all(e -> CC.getAccessor(e) isa CC.IdentifierInfo, eves)
    @test all(e -> CC.getAccessor(e).ptr != C_NULL, eves)
    @test all(e -> CC.isValid(CC.getAccessorLoc(e)), eves)
    @test "x" in map(e -> CC.getName(CC.getAccessor(e)), eves)
    @test any(e -> CC.containsDuplicateElements(e), eves)
    @test any(e -> !CC.containsDuplicateElements(e), eves)
    @test any(e -> CC.isArrow(e), eves)
    @test any(e -> !CC.isArrow(e), eves)

    # Expr::IgnoreConversionOperatorSingleStep — identity off a conversion-operator call
    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    @test !CC.is_null_handle(CC.IgnoreConversionOperatorSingleStep(il))
    @test CC.IgnoreConversionOperatorSingleStep(il).ptr == il.ptr
    mces = filter(n -> n isa CC.CXXMemberCallExpr, nodes)
    if !isempty(mces)
        inner = CC.IgnoreConversionOperatorSingleStep(first(mces))
        @test inner isa CC.Expr_
        @test inner.ptr != C_NULL
    end

    CC.dispose(lookup)
    CC.dispose(I)
end

@testset "expr-f: Expr setters / FullExpr / ConstantExpr result / shuffle locs / atomic operands" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    typedef int cc_f_v4i __attribute__((ext_vector_type(4)));
    consteval int cc_f_sq(int x) { return x * x; }
    int cc_exprf(int *p, cc_f_v4i v) {
        int e = 1;
        bool ok = __atomic_compare_exchange_n(p, &e, 2, false,
                                              __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
        cc_f_v4i s = __builtin_shufflevector(v, v, 0, 1, 2, 3);
        const char *fl = __builtin_FILE();
        int c = cc_f_sq(3);
        return ok + s.x + c + (fl != nullptr);
    }
    """)
    f = DeclFinder(I)
    @test f(I, "cc_exprf")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # ---- Expr: type / value-kind / object-kind setters (round-trip, restored) ----
    il = pick(CC.IntegerLiteral)
    @test il isa CC.IntegerLiteral
    ity = CC.getType(il)
    CC.setType(il, ity)
    @test CC.getType(il).ptr == ity.ptr

    vk = CC.getValueKind(il)
    CC.setValueKind(il, CC.LibClangEx.CXExprValueKind_VK_LValue)
    @test CC.getValueKind(il) == CC.LibClangEx.CXExprValueKind_VK_LValue
    CC.setValueKind(il, vk)
    @test CC.getValueKind(il) == vk

    okind = CC.getObjectKind(il)
    CC.setObjectKind(il, CC.LibClangEx.CXExprObjectKind_OK_BitField)
    @test CC.getObjectKind(il) == CC.LibClangEx.CXExprObjectKind_OK_BitField
    CC.setObjectKind(il, okind)
    @test CC.getObjectKind(il) == okind

    # ---- Expr: the total walkers ----
    @test !(CC.isReadIfDiscardedInCPlusPlus11(il))
    @test !CC.is_null_handle(CC.getBestDynamicClassTypeExpr(il))
    @test CC.getBestDynamicClassTypeExpr(il).ptr != C_NULL
    @test !CC.is_null_handle(CC.skipRValueSubobjectAdjustments(il))
    @test CC.skipRValueSubobjectAdjustments(il).ptr != C_NULL

    # ---- FullExpr / ConstantExpr (immediate consteval invocation) ----
    cst = pick(CC.ConstantExpr)
    @test cst isa CC.ConstantExpr
    @test CC.getSubExpr(cst).ptr != C_NULL
    # a FullExpr wraps exactly one sub-expression, so `FullExpr::getSubExpr` and the child
    # walk are two readings of the same edge and must agree
    cst_kids = collect(CC.children(cst))
    @test length(cst_kids) == 1
    @test CC.getSubExpr(cst).ptr == cst_kids[1].ptr
    @test CC.getResultStorageKind(cst) isa CC.LibClangEx.CXConstantResultStorageKind
    @test CC.getResultAPValueKind(cst) isa CC.LibClangEx.CXAPValueKind
    # hasAPValueResult is defined upstream as "APValueKind != None"
    @test (CC.getResultAPValueKind(cst) != CC.LibClangEx.CXAPValueKind_None) ==
          CC.hasAPValueResult(cst)

    # ---- ShuffleVectorExpr: location getters + setter round-trip ----
    sve = pick(CC.ShuffleVectorExpr)
    @test sve isa CC.ShuffleVectorExpr
    bloc = CC.getBuiltinLoc(sve)
    rloc = CC.getRParenLoc(sve)
    @test bloc isa CC.SourceLocation
    @test rloc isa CC.SourceLocation
    CC.setBuiltinLoc(sve, rloc)
    @test CC.getBuiltinLoc(sve).ptr == rloc.ptr
    CC.setBuiltinLoc(sve, bloc)
    @test CC.getBuiltinLoc(sve).ptr == bloc.ptr
    CC.setRParenLoc(sve, bloc)
    @test CC.getRParenLoc(sve).ptr == bloc.ptr
    CC.setRParenLoc(sve, rloc)
    @test CC.getRParenLoc(sve).ptr == rloc.ptr

    # ---- SourceLocExpr: __builtin_FILE() ----
    sle = pick(CC.SourceLocExpr)
    @test sle isa CC.SourceLocExpr
    @test CC.getIdentKind(sle) == CC.LibClangEx.CXSourceLocIdentKind_File
    @test CC.MayBeDependent(CC.getIdentKind(sle)) == false
    @test CC.MayBeDependent(CC.LibClangEx.CXSourceLocIdentKind_Function) == true

    # ---- AtomicExpr: the arity-gated operands of a compare-exchange ----
    ae = pick(CC.AtomicExpr)
    @test ae isa CC.AtomicExpr
    @test CC.isCmpXChg(ae)
    @test CC.getNumSubExprs(ae) >= 6   # ptr, order, val1, order_fail, val2, weak
    @test !CC.is_null_handle(CC.getVal1(ae))
    @test CC.getVal1(ae).ptr != C_NULL
    @test !CC.is_null_handle(CC.getOrderFail(ae))
    @test CC.getOrderFail(ae).ptr != C_NULL
    @test !CC.is_null_handle(CC.getVal2(ae))
    @test CC.getVal2(ae).ptr != C_NULL
    @test !CC.is_null_handle(CC.getWeak(ae))
    @test CC.getWeak(ae).ptr != C_NULL
    @test CC.getVal1(ae).ptr == CC.getSubExpr(ae, 2).ptr
    @test CC.getWeak(ae).ptr == CC.getSubExpr(ae, 5).ptr

    dispose(f)
    dispose(I)

    # ---- BlockExpr::getFunctionType (needs -fblocks) ----
    Ib = create_interpreter(["-std=c++20", "-fblocks"])
    CC.parse(Ib,
             """
             void cc_exprf_blk(void) { int (^b)(void) = ^int(void) { return 7; }; (void)b; }
             """)
    lb = DeclFinder(Ib)
    @test lb(Ib, "cc_exprf_blk")
    bfd = CC.FunctionDecl(get_decl(lb))
    be = first(filter(n -> n isa CC.BlockExpr, CC.subtree(CC.getBody(bfd))))
    fpt = CC.getFunctionType(be)
    @test fpt isa CC.FunctionProtoType
    @test fpt.ptr != C_NULL
    dispose(lb)
    dispose(Ib)
end

@testset "expr-g: lvalue classification / literal spelling / static Expr queries" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    typedef int cc_g_v4i __attribute__((ext_vector_type(4)));
    struct cc_g_rec { int a; int b; };
    int cc_g_pce(int x) { return x * 2; }
    int cc_g_expr(cc_g_v4i v, int n) {
        int arr[3] = {1, 2, 3};
        const int ci = 7;
        const char *fn = __func__;
        const char *s = "abc";
        cc_g_rec r{.a = 1, .b = 2};
        cc_g_v4i sh = __builtin_shufflevector(v, v, 3, 2, 1, 0);
        int el = v.x;
        int g = _Generic(n, int: 1, default: 2);
        auto lam = [arr]() { return arr[0]; };
        return arr[0] + ci + (fn != nullptr) + (s != nullptr) + r.a + sh.y + el + g + lam();
    }
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    @test f(I, "cc_g_expr")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # ---- Expr::isModifiableLvalue: const-qualified vs plain integer lvalue ----
    # selecting by type keeps the operator() DeclRefExpr (a non-identifier name) out
    ints = filter(n -> n isa CC.DeclRefExpr && CC.isIntegerType(CC.getTypePtr(CC.getType(n))),
                  nodes)
    @test !isempty(ints)
    ci_ref = first(filter(d -> CC.isConstQualified(CC.getType(d)), ints))
    mut_ref = first(filter(d -> !CC.isConstQualified(CC.getType(d)), ints))
    @test CC.isModifiableLvalue(ci_ref, ctx) ==
          CC.LibClangEx.CXExpr_MLV_ConstQualified
    @test CC.isModifiableLvalue(mut_ref, ctx) == CC.LibClangEx.CXExpr_MLV_Valid

    # ---- Expr: the diagnostic-only folds -------------------------------------
    il = pick(CC.IntegerLiteral)
    @test il isa CC.IntegerLiteral
    @test CC.EvaluateForOverflow(il, ctx) === nothing
    @test CC.isUnusedResultAWarning(il, ctx)

    # ---- Expr::isPotentialConstantExpr (static, over a definition) -----------
    @test f(I, "cc_g_pce")
    pce = CC.FunctionDecl(get_decl(f))
    @test CC.isPotentialConstantExpr(pce)

    # ---- Expr::hasAnyTypeDependentArguments (static, over an array) ----------
    @test CC.hasAnyTypeDependentArguments(CC.AbstractExpr[il, ci_ref]) == false
    @test CC.hasAnyTypeDependentArguments(CC.Expr_[]) == false

    # ---- StringLiteral: source spelling + byte location ----------------------
    sl = first(filter(n -> n isa CC.StringLiteral && CC.getString(n) == "abc", nodes))
    @test CC.outputString(sl) == "\"abc\""
    sm = CC.getSourceManager(ctx)
    lopts = CC.getLangOpts(ctx)
    ti = CC.getTargetInfo(ctx)
    @test !CC.is_null_handle(CC.getLocationOfByte(sl, 0, sm, lopts, ti))
    @test_throws AssertionError CC.getLocationOfByte(sl, 99, sm, lopts, ti)

    # ---- PredefinedExpr: __func__ -------------------------------------------
    pe = pick(CC.PredefinedExpr)
    @test pe isa CC.PredefinedExpr
    @test !(CC.isTransparent(pe))
    @test !CC.is_null_handle(CC.getLocation(pe))
    @test CC.getIdentKind(pe) == CC.LibClangEx.CXPredefinedIdentKind_Func
    @test CC.ComputeName(CC.getIdentKind(pe), fd) == "cc_g_expr"

    # ---- ConstantExpr: both static storage-kind overloads --------------------
    av = CC.EvaluateAsRValue(il, ctx)
    @test av isa CC.APValue
    @test av.ptr != C_NULL
    @test CC.getStorageKind(av) == CC.LibClangEx.CXConstantResultStorageKind_Int64
    dispose(av)
    ity = CC.getTypePtr(CC.getType(il))
    @test CC.getStorageKindForType(ity, ctx) ==
          CC.LibClangEx.CXConstantResultStorageKind_Int64

    # ---- ShuffleVectorExpr: mask entries (__builtin_shufflevector(v, v, 3, 2, 1, 0))
    sve = pick(CC.ShuffleVectorExpr)
    @test sve isa CC.ShuffleVectorExpr
    @test CC.getNumSubExprs(sve) == 6
    mask0 = CC.getShuffleMaskIdx(sve, ctx, 0)
    @test mask0 != C_NULL
    @test CC.LLVM.API.LLVMGenericValueToInt(mask0, false) == 3
    CC.LLVM.API.LLVMDisposeGenericValue(mask0)
    @test_throws AssertionError CC.getShuffleMaskIdx(sve, ctx, 4)

    # ---- ExtVectorElementExpr: the encoded accessor --------------------------
    eve = pick(CC.ExtVectorElementExpr)
    @test eve isa CC.ExtVectorElementExpr
    enc = CC.getEncodedElementAccess(eve)
    @test enc isa Vector{UInt32}
    @test length(enc) == CC.getNumElements(eve)
    @test all(i -> i < 4, enc)

    # ---- GenericSelectionExpr: per-association written types -----------------
    gse = pick(CC.GenericSelectionExpr)
    @test gse isa CC.GenericSelectionExpr
    @test CC.getNumAssocs(gse) == 2
    @test !CC.is_null_handle(CC.getAssocTypeSourceInfo(gse, 0))
    @test CC.getAssocTypeSourceInfo(gse, 0).ptr != C_NULL
    @test CC.getAssocTypeSourceInfo(gse, 1).ptr == C_NULL   # `default:` has no written type
    @test_throws AssertionError CC.getAssocTypeSourceInfo(gse, 2)

    # ---- ArrayInitLoopExpr: the extent of the copied array -------------------
    ail = pick(CC.ArrayInitLoopExpr)
    @test ail isa CC.ArrayInitLoopExpr
    sz = CC.getArraySize(ail)
    @test sz != C_NULL
    @test CC.LLVM.API.LLVMGenericValueToInt(sz, false) == 3
    CC.LLVM.API.LLVMDisposeGenericValue(sz)

    # ---- Designator::getSourceRange -----------------------------------------
    # the designators live on the syntactic form, which `subtree` does not walk
    dies = CC.DesignatedInitExpr[]
    for n in filter(x -> x isa CC.InitListExpr, nodes)
        syn = CC.getSyntacticForm(n)
        syn.ptr == C_NULL && continue
        append!(dies, filter(m -> m isa CC.DesignatedInitExpr, CC.subtree(syn)))
    end
    @test !isempty(dies)
    d0 = CC.getDesignator(first(dies), 0)
    rng = CC.getSourceRange(d0)
    @test rng isa CC.SourceRange
    @test rng.begin_loc.ptr == CC.getBeginLoc(d0).ptr
    @test rng.end_loc.ptr == CC.getEndLoc(d0).ptr

    dispose(f)
    dispose(I)
end

@testset "expr tail: paren/unary/subscript/binary setters, char-literal print, atomic scope" begin
    I = create_interpreter(String[])
    CC.parse(I,
             """
             #ifndef __MEMORY_SCOPE_SYSTEM
             #define __MEMORY_SCOPE_SYSTEM 0
             #endif
             int cc_wl16_expr(int *p, int n) {
                 int arr[3] = {1, 2, 3};
                 char c = 'a';
                 int s = (n) + arr[0];
                 int u = -n;
                 int a = __scoped_atomic_load_n(p, __ATOMIC_SEQ_CST, __MEMORY_SCOPE_SYSTEM);
                 return s + u + a + c;
             }
             """)
    lookup = DeclFinder(I)
    @test lookup(I, "cc_wl16_expr")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # ---- ParenExpr: setSubExpr / setLParen / setRParen -----------------------
    pe = pick(CC.ParenExpr)
    @test pe isa CC.ParenExpr
    psub = CC.getSubExpr(pe)
    CC.setSubExpr(pe, psub)
    @test CC.getSubExpr(pe).ptr == psub.ptr
    plp = CC.getLParen(pe)
    CC.setLParen(pe, plp)
    @test CC.getLParen(pe).ptr == plp.ptr
    prp = CC.getRParen(pe)
    CC.setRParen(pe, prp)
    @test CC.getRParen(pe).ptr == prp.ptr

    # ---- UnaryOperator: setOpcode / setSubExpr / setCanOverflow --------------
    uo = pick(CC.UnaryOperator)
    @test uo isa CC.UnaryOperator
    uopc = CC.getOpcode(uo)
    CC.setOpcode(uo, uopc)
    @test CC.getOpcode(uo) == uopc
    usub = CC.getSubExpr(uo)
    CC.setSubExpr(uo, usub)
    @test CC.getSubExpr(uo).ptr == usub.ptr
    ucan = CC.canOverflow(uo)
    CC.setCanOverflow(uo, ucan)
    @test CC.canOverflow(uo) == ucan

    # ---- ArraySubscriptExpr: setLHS / setRHS / setRBracketLoc ----------------
    ase = pick(CC.ArraySubscriptExpr)
    @test ase isa CC.ArraySubscriptExpr
    alhs = CC.getLHS(ase)
    CC.setLHS(ase, alhs)
    @test CC.getLHS(ase).ptr == alhs.ptr
    arhs = CC.getRHS(ase)
    CC.setRHS(ase, arhs)
    @test CC.getRHS(ase).ptr == arhs.ptr
    arb = CC.getRBracketLoc(ase)
    CC.setRBracketLoc(ase, arb)
    @test CC.getRBracketLoc(ase).ptr == arb.ptr

    # ---- BinaryOperator: setOpcode / setLHS / setRHS / setOperatorLoc --------
    bo = pick(CC.BinaryOperator)
    @test bo isa CC.BinaryOperator
    bopc = CC.getOpcode(bo)
    CC.setOpcode(bo, bopc)
    @test CC.getOpcode(bo) == bopc
    blhs = CC.getLHS(bo)
    CC.setLHS(bo, blhs)
    @test CC.getLHS(bo).ptr == blhs.ptr
    brhs = CC.getRHS(bo)
    CC.setRHS(bo, brhs)
    @test CC.getRHS(bo).ptr == brhs.ptr
    bloc = CC.getOperatorLoc(bo)
    CC.setOperatorLoc(bo, bloc)
    @test CC.getOperatorLoc(bo).ptr == bloc.ptr

    # ---- CharacterLiteral: setValue / setKind / setLocation + static print ---
    cl = pick(CC.CharacterLiteral)
    @test cl isa CC.CharacterLiteral
    cval = CC.getValue(cl)
    CC.setValue(cl, cval)
    @test CC.getValue(cl) == cval
    ckind = CC.getKind(cl)
    CC.setKind(cl, ckind)
    @test CC.getKind(cl) == ckind
    cloc = CC.getLocation(cl)
    CC.setLocation(cl, cloc)
    @test CC.getLocation(cl).ptr == cloc.ptr
    @test CC.print(UInt32('a'), CC.LibClangEx.CXCharacterLiteralKind_Ascii) == "'a'"
    @test CC.print(UInt32('a'), CC.LibClangEx.CXCharacterLiteralKind_Wide) == "L'a'"

    # ---- AtomicExpr: the scope operand and the gate that guards it -----------
    ae = pick(CC.AtomicExpr)
    @test ae isa CC.AtomicExpr
    @test CC.hasScopeModel(ae)
    if CC.hasScopeModel(ae)
        @test !CC.is_null_handle(CC.getScope(ae))
    end

    # ---- GenericSelectionExpr: the controlling type of a type predicate ------
    # `_Generic` with a type operand is a clang extension; skip where unavailable.
    CC.parse(I, "int cc_wl16_tg() { return _Generic(int, int: 1, default: 2); }")
    if lookup(I, "cc_wl16_tg")
        tfd = CC.FunctionDecl(get_decl(lookup))
        tnodes = CC.subtree(CC.getBody(tfd))
        ti = findfirst(n -> n isa CC.GenericSelectionExpr && CC.isTypePredicate(n), tnodes)
        if ti !== nothing
            @test !CC.is_null_handle(CC.getControllingType(tnodes[ti]))
        end
    end

    dispose(lookup)
    dispose(I)
end

@testset "expr-i: Expr mutator tail (call/member/decl-ref/cast/init-list/UETT)" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    struct CCIPoint { int x; int y; };
    union CCIUnion { int i; float f; };
    int cc_i_helper(int a, int b) { return a + b; }
    consteval int cc_i_sq(int x) { return x * x; }
    int cc_expri(int n) {
        CCIPoint p;
        p.x = n;
        int arr[3] = {1, 2, 3};
        int brr[3] = {4, 5, 6};
        CCIUnion u = {7};
        int c = cc_i_helper(n, 2);
        int k = cc_i_sq(3);
        double d = (double)n;
        unsigned long s = sizeof n;
        return p.x + arr[0] + brr[0] + u.i + c + k + (int)d + (int)s;
    }
    """)
    f = DeclFinder(I)
    @test f(I, "cc_expri")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))

    # ---- CallExpr: callee / argument slots (round-tripped, values restored) ----
    call = first(filter(n -> n isa CC.CallExpr, nodes))
    @test CC.getNumArgs(call) == 2
    callee = CC.getCallee(call)
    CC.setCallee(call, callee)
    @test CC.getCallee(call).ptr == callee.ptr
    a0 = CC.getArg(call, 0)
    CC.setArg(call, 0, a0)
    @test CC.getArg(call, 0).ptr == a0.ptr
    # the index precondition restated from CallExpr::setArg's assert
    @test_throws AssertionError CC.setArg(call, CC.getNumArgs(call), a0)

    # ---- MemberExpr: base / member decl / arrow / candidate flag ----
    me = first(filter(n -> n isa CC.MemberExpr, nodes))
    mbase = CC.getBase(me)
    CC.setBase(me, mbase)
    @test CC.getBase(me).ptr == mbase.ptr
    md = CC.getMemberDecl(me)
    CC.setMemberDecl(me, md)
    @test CC.getMemberDecl(me).ptr == md.ptr
    arrow = CC.isArrow(me)
    CC.setArrow(me, !arrow)
    @test CC.isArrow(me) == !arrow
    CC.setArrow(me, arrow)
    @test CC.isArrow(me) == arrow
    mhad = CC.hadMultipleCandidates(me)
    CC.setHadMultipleCandidates(me, !mhad)
    @test CC.hadMultipleCandidates(me) == !mhad
    CC.setHadMultipleCandidates(me, mhad)
    @test CC.hadMultipleCandidates(me) == mhad

    # ---- DeclRefExpr: referenced decl / candidate flag ----
    dre = first(filter(n -> n isa CC.DeclRefExpr, nodes))
    dref = CC.getDecl(dre)
    CC.setDecl(dre, dref)
    @test CC.getDecl(dre).ptr == dref.ptr
    dhad = CC.hadMultipleCandidates(dre)
    CC.setHadMultipleCandidates(dre, !dhad)
    @test CC.hadMultipleCandidates(dre) == !dhad
    CC.setHadMultipleCandidates(dre, dhad)
    @test CC.hadMultipleCandidates(dre) == dhad

    # ---- CastExpr / ExplicitCastExpr / ImplicitCastExpr ----
    cs = first(filter(n -> n isa CC.CStyleCastExpr, nodes))
    ck = CC.getCastKind(cs)
    CC.setCastKind(cs, ck)
    @test CC.getCastKind(cs) == ck
    csub = CC.getSubExpr(cs)
    CC.setSubExpr(cs, csub)
    @test CC.getSubExpr(cs).ptr == csub.ptr
    tsi = CC.getTypeInfoAsWritten(cs)
    @test tsi.ptr != C_NULL
    CC.setTypeInfoAsWritten(cs, tsi)
    @test CC.getTypeInfoAsWritten(cs).ptr == tsi.ptr

    ice = first(filter(n -> n isa CC.ImplicitCastExpr, nodes))
    part = CC.isPartOfExplicitCast(ice)
    CC.setIsPartOfExplicitCast(ice, !part)
    @test CC.isPartOfExplicitCast(ice) == !part
    CC.setIsPartOfExplicitCast(ice, part)
    @test CC.isPartOfExplicitCast(ice) == part

    # ---- FullExpr (the consteval invocation's ConstantExpr) ----
    cst = first(filter(n -> n isa CC.ConstantExpr, nodes))
    fsub = CC.getSubExpr(cst)
    CC.setSubExpr(cst, fsub)
    @test CC.getSubExpr(cst).ptr == fsub.ptr

    # ---- UnaryExprOrTypeTraitExpr (`sizeof n`, an expression operand) ----
    uett = first(filter(n -> n isa CC.UnaryExprOrTypeTraitExpr && !CC.isArgumentType(n),
                        nodes))
    ukind = CC.getKind(uett)
    CC.setKind(uett, ukind)
    @test CC.getKind(uett) == ukind
    uarg = CC.getArgumentExpr(uett)
    CC.setArgumentExpr(uett, uarg)
    @test CC.isArgumentType(uett) == false
    @test CC.getArgumentExpr(uett).ptr == uarg.ptr

    # ---- InitListExpr: union field, then the array-list mutators ----
    uile = first(filter(n -> n isa CC.InitListExpr &&
                            CC.getInitializedFieldInUnion(n).ptr != C_NULL, nodes))
    ufield = CC.getInitializedFieldInUnion(uile)
    CC.setInitializedFieldInUnion(uile, ufield)
    @test CC.getInitializedFieldInUnion(uile).ptr == ufield.ptr

    iles = filter(n -> n isa CC.InitListExpr && CC.getNumInits(n) == 3 &&
                      !CC.hasArrayFiller(n), nodes)
    @test length(iles) >= 2
    aile, bile = iles[1], iles[2]
    @test aile.ptr != bile.ptr

    i0 = CC.getInit(aile, 0)
    @test i0.ptr != C_NULL
    CC.setInit(aile, 0, i0)
    @test CC.getInit(aile, 0).ptr == i0.ptr
    @test_throws AssertionError CC.setInit(aile, CC.getNumInits(aile), i0)

    CC.setArrayFiller(aile, i0)
    @test CC.hasArrayFiller(aile)
    @test CC.getArrayFiller(aile).ptr == i0.ptr
    # the "filler already set" precondition restated from InitListExpr::setArrayFiller
    @test_throws AssertionError CC.setArrayFiller(aile, i0)

    ard = CC.hadArrayRangeDesignator(bile)
    CC.sawArrayRangeDesignator(bile, !ard)
    @test CC.hadArrayRangeDesignator(bile) == !ard
    CC.sawArrayRangeDesignator(bile, ard)
    @test CC.hadArrayRangeDesignator(bile) == ard

    # setSyntacticForm rewires both lists: bile becomes aile's syntactic form and aile
    # becomes bile's semantic form.
    CC.setSyntacticForm(aile, bile)
    @test CC.isSemanticForm(aile)
    @test CC.getSyntacticForm(aile).ptr == bile.ptr
    @test CC.getSemanticForm(bile).ptr == aile.ptr

    dispose(f)
    dispose(I)
end

@testset "Expr FP-environment queries and StmtExpr/ChooseExpr/VAArgExpr setters" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             double jfp_mix(double a, double b) {
                 double s = a + b;                          // BinaryOperator (double)
                 double n = -s;                             // UnaryOperator (double)
                 int c = __builtin_choose_expr(1, 10, 20);  // ChooseExpr
                 int g = ({ int t = c; t + 1; });           // StmtExpr
                 unsigned long z = sizeof(int);             // UnaryExprOrTypeTraitExpr
                 return s + n + c + g + z;
             }
             int jfp_va(int count, ...) {
                 __builtin_va_list ap;
                 __builtin_va_start(ap, count);
                 int x = __builtin_va_arg(ap, int);         // VAArgExpr
                 __builtin_va_end(ap);
                 return x;
             }
             """)
    ctx = CC.get_ast_context(I)
    lo = CC.getLangOpts(ctx)

    lookup = DeclFinder(I)
    @test lookup(I, "jfp_mix")
    mixfd = CC.FunctionDecl(get_decl(lookup))
    mixnodes = CC.subtree(CC.getBody(mixfd))

    bo = first(filter(n -> n isa CC.BinaryOperator, mixnodes))
    uo = first(filter(n -> n isa CC.UnaryOperator, mixnodes))
    uett = first(filter(n -> n isa CC.UnaryExprOrTypeTraitExpr, mixnodes))
    che = first(filter(n -> n isa CC.ChooseExpr, mixnodes))
    se = first(filter(n -> n isa CC.StmtExpr, mixnodes))

    # ---- FP-environment queries ---------------------------------------------
    # The driver decides the default -ffp-contract / FENV_ACCESS state and it differs
    # across the CI hosts, so only the shape is asserted.
    @test CC.isFPContractableWithinStatement(bo, lo)
    @test !(CC.isFEnvAccessOn(bo, lo))
    @test CC.isFPContractableWithinStatement(uo, lo)
    @test !(CC.isFEnvAccessOn(uo, lo))

    # ---- Setters: round-trip through the paired getters ----------------------
    loc_a = CC.getBuiltinLoc(che)   # location of the __builtin_choose_expr token
    loc_b = CC.getRParenLoc(che)    # its closing paren — a different valid location
    @test loc_a.ptr != loc_b.ptr

    # UnaryExprOrTypeTraitExpr::setOperatorLoc / setRParenLoc
    CC.setOperatorLoc(uett, loc_b)
    @test CC.getOperatorLoc(uett).ptr == loc_b.ptr
    CC.setRParenLoc(uett, loc_a)
    @test CC.getRParenLoc(uett).ptr == loc_a.ptr

    # StmtExpr::setSubStmt / setLParenLoc / setRParenLoc
    sub = CC.getSubStmt(se)
    @test sub isa CC.CompoundStmt
    CC.setSubStmt(se, sub)
    @test CC.getSubStmt(se).ptr == sub.ptr
    CC.setLParenLoc(se, loc_a)
    @test CC.getLParenLoc(se).ptr == loc_a.ptr
    CC.setRParenLoc(se, loc_b)
    @test CC.getRParenLoc(se).ptr == loc_b.ptr

    # ChooseExpr::setCond / setLHS / setRHS — swap the two arms, then restore
    cond = CC.getCond(che)
    lhs = CC.getLHS(che)
    rhs = CC.getRHS(che)
    CC.setLHS(che, rhs)
    CC.setRHS(che, lhs)
    @test CC.getLHS(che).ptr == rhs.ptr
    @test CC.getRHS(che).ptr == lhs.ptr
    CC.setLHS(che, lhs)
    CC.setRHS(che, rhs)
    CC.setCond(che, cond)
    @test CC.getCond(che).ptr == cond.ptr
    @test CC.getLHS(che).ptr == lhs.ptr

    # ChooseExpr::setIsConditionTrue — the condition is the literal `1`, not dependent
    @test !CC.isConditionDependent(che)
    was = CC.isConditionTrue(che)
    CC.setIsConditionTrue(che, !was)
    @test CC.isConditionTrue(che) == !was
    CC.setIsConditionTrue(che, was)
    @test CC.isConditionTrue(che) == was

    CC.setBuiltinLoc(che, loc_b)
    @test CC.getBuiltinLoc(che).ptr == loc_b.ptr
    CC.setRParenLoc(che, loc_a)
    @test CC.getRParenLoc(che).ptr == loc_a.ptr

    # ---- VAArgExpr setters ---------------------------------------------------
    @test lookup(I, "jfp_va")
    vafd = CC.FunctionDecl(get_decl(lookup))
    va = first(filter(n -> n isa CC.VAArgExpr, CC.subtree(CC.getBody(vafd))))

    vsub = CC.getSubExpr(va)
    CC.setSubExpr(va, vsub)
    @test CC.getSubExpr(va).ptr == vsub.ptr

    ms = CC.isMicrosoftABI(va)
    CC.setIsMicrosoftABI(va, !ms)
    @test CC.isMicrosoftABI(va) == !ms
    CC.setIsMicrosoftABI(va, ms)
    @test CC.isMicrosoftABI(va) == ms

    vti = CC.getWrittenTypeInfo(va)
    CC.setWrittenTypeInfo(va, vti)
    @test CC.getWrittenTypeInfo(va).ptr == vti.ptr
    # the flag sharing the packed word survives the pointer write
    @test CC.isMicrosoftABI(va) == ms

    CC.setBuiltinLoc(va, loc_a)
    @test CC.getBuiltinLoc(va).ptr == loc_a.ptr
    CC.setRParenLoc(va, loc_b)
    @test CC.getRParenLoc(va).ptr == loc_b.ptr

    dispose(lookup)
    dispose(I)
end

@testset "Expr subclasses: designated-update/compound-literal/ext-vector setters" begin
    I = create_interpreter(["-std=gnu++20"])
    CC.parse(I,
             """
             typedef float cc_k_f4 __attribute__((ext_vector_type(4)));
             typedef int cc_k_i4 __attribute__((ext_vector_type(4)));
             struct CCKQ { int a, b, c; };
             struct CCKA { CCKQ q; };
             struct CCKP { int x, y; };
             CCKQ *cc_k_getQ();
             int cc_k_all(int n, cc_k_f4 v) {
                 CCKA a = { *cc_k_getQ(), .q.b = 3 };   // DesignatedInitUpdateExpr
                 CCKP p = (CCKP){1, 2};                 // CompoundLiteralExpr
                 int s = 0;
                 s += a.q.b;                            // CompoundAssignOperator
                 void *z = __null;                      // GNUNullExpr
                 void *q = &&cc_k_lbl;                  // AddrLabelExpr
                 const char *fn = __func__;             // PredefinedExpr
                 float e = v.x;                         // ExtVectorElementExpr
                 cc_k_i4 iv = __builtin_convertvector(v, cc_k_i4);  // ConvertVectorExpr
                 int b = n ?: 30;                       // BinaryConditionalOperator + OVE
             cc_k_lbl:
                 return s + p.x + (int)e + iv.x + b + (int)(long)q + (int)(long)z + fn[0];
             }
             """)

    lookup = DeclFinder(I)
    @test lookup(I, "cc_k_all")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    # ---- DesignatedInitUpdateExpr -------------------------------------------
    # The DIUE lives in the semantic form of the initializer list; sweep the syntactic
    # forms too so the search does not depend on which form the walk reached.
    diues = CC.DesignatedInitUpdateExpr[]
    append!(diues, filter(n -> n isa CC.DesignatedInitUpdateExpr, nodes))
    for ile in filter(n -> n isa CC.InitListExpr, nodes)
        syn = CC.getSyntacticForm(ile)
        syn.ptr == C_NULL && continue
        append!(diues, filter(n -> n isa CC.DesignatedInitUpdateExpr, CC.subtree(syn)))
    end
    @test !isempty(diues)
    diue = first(diues)
    diue_base = CC.getBase(diue)
    @test diue_base isa CC.Expr_
    @test diue_base.ptr != C_NULL
    diue_upd = CC.getUpdater(diue)
    @test diue_upd isa CC.InitListExpr
    @test diue_upd.ptr != C_NULL
    CC.setBase(diue, diue_base)
    @test CC.getBase(diue).ptr == diue_base.ptr
    CC.setUpdater(diue, diue_upd)
    @test CC.getUpdater(diue).ptr == diue_upd.ptr

    # ---- CompoundLiteralExpr -------------------------------------------------
    cle = first(filter(n -> n isa CC.CompoundLiteralExpr, nodes))
    cle_init = CC.getInitializer(cle)
    cle_tsi = CC.getTypeSourceInfo(cle)
    cle_lp = CC.getLParenLoc(cle)
    cle_fs = CC.isFileScope(cle)
    CC.setInitializer(cle, cle_init)
    @test CC.getInitializer(cle).ptr == cle_init.ptr
    CC.setTypeSourceInfo(cle, cle_tsi)
    @test CC.getTypeSourceInfo(cle).ptr == cle_tsi.ptr
    CC.setLParenLoc(cle, cle_lp)
    @test CC.getLParenLoc(cle).ptr == cle_lp.ptr
    CC.setFileScope(cle, !cle_fs)
    @test CC.isFileScope(cle) == !cle_fs
    CC.setFileScope(cle, cle_fs)
    @test CC.isFileScope(cle) == cle_fs

    # ---- CompoundAssignOperator ----------------------------------------------
    cao = first(filter(n -> n isa CC.CompoundAssignOperator, nodes))
    cao_lhs = CC.getComputationLHSType(cao)
    cao_res = CC.getComputationResultType(cao)
    CC.setComputationLHSType(cao, cao_lhs)
    @test CC.getComputationLHSType(cao).ptr == cao_lhs.ptr
    CC.setComputationResultType(cao, cao_res)
    @test CC.getComputationResultType(cao).ptr == cao_res.ptr

    # ---- AddrLabelExpr -------------------------------------------------------
    al = first(filter(n -> n isa CC.AddrLabelExpr, nodes))
    al_amp = CC.getAmpAmpLoc(al)
    al_loc = CC.getLabelLoc(al)
    al_lbl = CC.getLabel(al)
    @test al_lbl.ptr != C_NULL
    CC.setAmpAmpLoc(al, al_amp)
    @test CC.getAmpAmpLoc(al).ptr == al_amp.ptr
    CC.setLabelLoc(al, al_loc)
    @test CC.getLabelLoc(al).ptr == al_loc.ptr
    CC.setLabel(al, al_lbl)
    @test CC.getLabel(al).ptr == al_lbl.ptr

    # ---- ConvertVectorExpr ---------------------------------------------------
    cve = first(filter(n -> n isa CC.ConvertVectorExpr, nodes))
    cve_tsi = CC.getTypeSourceInfo(cve)
    @test cve_tsi isa CC.TypeSourceInfo
    CC.setTypeSourceInfo(cve, cve_tsi)
    @test CC.getTypeSourceInfo(cve).ptr == cve_tsi.ptr

    # ---- GNUNullExpr ---------------------------------------------------------
    gn = first(filter(n -> n isa CC.GNUNullExpr, nodes))
    gn_loc = CC.getTokenLocation(gn)
    CC.setTokenLocation(gn, gn_loc)
    @test CC.getTokenLocation(gn).ptr == gn_loc.ptr

    # ---- PredefinedExpr ------------------------------------------------------
    pde = first(filter(n -> n isa CC.PredefinedExpr, nodes))
    pde_loc = CC.getLocation(pde)
    CC.setLocation(pde, pde_loc)
    @test CC.getLocation(pde).ptr == pde_loc.ptr

    # ---- ExtVectorElementExpr ------------------------------------------------
    eve = first(filter(n -> n isa CC.ExtVectorElementExpr, nodes))
    eve_base = CC.getBase(eve)
    eve_acc = CC.getAccessor(eve)
    eve_loc = CC.getAccessorLoc(eve)
    @test eve_base.ptr != C_NULL
    @test eve_acc.ptr != C_NULL
    CC.setBase(eve, eve_base)
    @test CC.getBase(eve).ptr == eve_base.ptr
    CC.setAccessor(eve, eve_acc)
    @test CC.getAccessor(eve).ptr == eve_acc.ptr
    CC.setAccessorLoc(eve, eve_loc)
    @test CC.getAccessorLoc(eve).ptr == eve_loc.ptr

    # ---- OpaqueValueExpr -----------------------------------------------------
    # setIsUnique asserts a source expression exists; the `?:` opaque value has one.
    bco = first(filter(n -> n isa CC.BinaryConditionalOperator, nodes))
    ove = CC.getOpaqueValue(bco)
    @test ove isa CC.OpaqueValueExpr
    @test CC.getSourceExpr(ove).ptr != C_NULL
    ove_uniq = CC.isUnique(ove)
    CC.setIsUnique(ove, true)
    @test CC.isUnique(ove) == true
    CC.setIsUnique(ove, false)
    @test CC.isUnique(ove) == false
    CC.setIsUnique(ove, ove_uniq)
    @test CC.isUnique(ove) == ove_uniq

    dispose(lookup)
    dispose(I)
end

@testset "Expr::Classification and the FP-feature accessors" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             double cls_callee(double a);
             double cls_probe(double a, double b) {
                 double local = a + b;
                 local = -local;
                 return cls_callee(local);
             }
             """)
    ctx = CC.get_ast_context(I)

    lookup = DeclFinder(I)
    @test lookup(I, "cls_probe")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    bo = first(filter(n -> n isa CC.BinaryOperator, nodes))
    uo = first(filter(n -> n isa CC.UnaryOperator, nodes))
    ce = first(filter(n -> n isa CC.CallExpr, nodes))
    dre = first(filter(n -> n isa CC.DeclRefExpr, nodes))

    # ---- Expr::Classify — no modifiability verdict --------------------------
    cl = CC.Classify(dre, ctx)
    @test cl isa CC.Classification
    @test CC.getKind(cl) isa CC.LibClangEx.CXClassification_Kinds
    # The predicates partition on Kind: glvalue == lvalue|xvalue, prvalue is exactly the
    # complement of glvalue, rvalue == xvalue|prvalue. Host-independent by construction.
    @test CC.isGLValue(cl) == (CC.isLValue(cl) || CC.isXValue(cl))
    @test CC.isPRValue(cl) == !CC.isGLValue(cl)
    @test CC.isRValue(cl) == (CC.isXValue(cl) || CC.isPRValue(cl))
    @test !CC.isModifiableTested(cl)
    @test_throws AssertionError CC.getModifiable(cl)
    @test_throws AssertionError CC.isModifiable(cl)
    CC.dispose(cl)

    # ---- Expr::ClassifyModifiable — verdict plus the blame location ---------
    clm, badloc = CC.ClassifyModifiable(dre, ctx)
    @test clm isa CC.Classification
    @test badloc isa CC.SourceLocation
    @test CC.isModifiableTested(clm)
    @test CC.getModifiable(clm) isa CC.LibClangEx.CXClassification_ModifiableType
    @test CC.isModifiable(clm) ==
          (CC.getModifiable(clm) == CC.LibClangEx.CXClassification_CM_Modifiable)
    @test CC.isGLValue(clm) == (CC.isLValue(clm) || CC.isXValue(clm))
    CC.dispose(clm)

    # ---- Classification::makeSimpleLValue — a fixed pair of enumerators -----
    simple = CC.makeSimpleLValue()
    @test simple isa CC.Classification
    @test CC.getKind(simple) == CC.LibClangEx.CXClassification_CL_LValue
    @test CC.isLValue(simple)
    @test CC.isGLValue(simple)
    @test !CC.isXValue(simple)
    @test !CC.isPRValue(simple)
    @test !CC.isRValue(simple)
    @test CC.isModifiableTested(simple)
    @test CC.getModifiable(simple) == CC.LibClangEx.CXClassification_CM_Modifiable
    @test CC.isModifiable(simple)
    CC.dispose(simple)

    @test !(CC.isOBJCGCCandidate(dre, ctx))

    # ---- FPOptionsOverride opaque encodings --------------------------------
    # Whether a node carries the trailing slot depends on the host's default FP
    # settings, so both branches are covered and only the zero-encoding invariant is
    # asserted for the slotless case.
    @test CC.getFPFeatures(bo) == (CC.hasStoredFPFeatures(bo) ? CC.getStoredFPFeatures(bo) : 0)
    if CC.hasStoredFPFeatures(bo)
        @test CC.getStoredFPFeatures(bo) == CC.getFPFeatures(bo)
    else
        @test CC.getFPFeatures(bo) == 0
        @test_throws AssertionError CC.getStoredFPFeatures(bo)
    end

    @test CC.getFPFeatures(ce) == (CC.hasStoredFPFeatures(ce) ? CC.getStoredFPFeatures(ce) : 0)
    if CC.hasStoredFPFeatures(ce)
        @test CC.getStoredFPFeatures(ce) == CC.getFPFeatures(ce)
    else
        @test CC.getFPFeatures(ce) == 0
        @test_throws AssertionError CC.getStoredFPFeatures(ce)
    end

    @test CC.getFPOptionsOverride(uo) == (CC.hasStoredFPFeatures(uo) ? CC.getStoredFPFeatures(uo) : 0)
    if CC.hasStoredFPFeatures(uo)
        @test CC.getStoredFPFeatures(uo) == CC.getFPOptionsOverride(uo)
    else
        @test CC.getFPOptionsOverride(uo) == 0
        @test_throws AssertionError CC.getStoredFPFeatures(uo)
    end

    dispose(lookup)
    dispose(I)
end

@testset "expr-m: FP-in-effect / substituted evaluation / offsetof, init-list, designator setters" begin
    LX = CC.LibClangEx
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             struct cc_m_pt { int x; int y; };
             struct cc_m_inner { float f; double d; };
             struct cc_m_outer { int i; cc_m_inner s[4]; };
             constexpr int cc_m_double(int v) { return v * 2; }
             constexpr int cc_m_seed = 21;
             double cc_m_fn(double a, double b) {
                 double local = a + b;
                 double cast = (double)(int)local;
                 int arr[3] = {1, 2, 3};
                 cc_m_pt p = {.x = 4, .y = 5};
                 unsigned long off = __builtin_offsetof(cc_m_outer, s[2].d);
                 return local + cast + arr[0] + p.x + (double)off;
             }
             const char *cc_m_file(void) { return __builtin_FILE(); }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)

    @test lookup(I, "cc_m_fn")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))
    lang_opts = CC.getLangOpts(fd)

    bo = first(filter(n -> n isa CC.BinaryOperator, nodes))
    cse = first(filter(n -> n isa CC.CStyleCastExpr, nodes))
    dre = first(filter(n -> n isa CC.DeclRefExpr, nodes))
    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    ase = first(filter(n -> n isa CC.ArraySubscriptExpr, nodes))

    # ---- Expr::getFPFeaturesInEffect — total for every expression -----------
    @test CC.getFPFeaturesInEffect(bo, lang_opts) == CC.getFPFeaturesInEffect(il, lang_opts)
    @test CC.getFPFeaturesInEffect(cse, lang_opts) == CC.getFPFeaturesInEffect(il, lang_opts)
    # Nodes with no trailing override slot all read the same LangOptions defaults, so any
    # two of them agree whatever the host's default FP settings are.
    @test CC.getFPFeaturesInEffect(il, lang_opts) == CC.getFPFeaturesInEffect(dre, lang_opts)

    # ---- CastExpr FPOptionsOverride ----------------------------------------
    # Whether a cast carries the trailing slot depends on the host's default FP settings,
    # so both branches are covered and only the zero-encoding invariant is asserted.
    @test CC.getFPFeatures(cse) == (CC.hasStoredFPFeatures(cse) ? CC.getStoredFPFeatures(cse) : 0)
    if CC.hasStoredFPFeatures(cse)
        @test CC.getStoredFPFeatures(cse) == CC.getFPFeatures(cse)
    else
        @test CC.getFPFeatures(cse) == 0
        @test_throws AssertionError CC.getStoredFPFeatures(cse)
    end

    # ---- Expr::ClassifyLValue ----------------------------------------------
    @test CC.ClassifyLValue(dre, ctx) isa LX.CXExpr_LValueClassification
    # `arr[0]` is an l-value of scalar type; an integer literal is a prvalue and always
    # gets a reason instead.
    @test CC.ClassifyLValue(ase, ctx) == LX.CXExpr_LV_Valid
    for lit in filter(n -> n isa CC.IntegerLiteral, nodes)
        @test CC.ClassifyLValue(lit, ctx) != LX.CXExpr_LV_Valid
    end

    # ---- Expr::EvaluateAsInitializer ---------------------------------------
    @test lookup(I, "cc_m_seed")
    seed = CC.VarDecl(get_decl(lookup))
    seed_init = CC.getInit(seed)
    @test seed_init.ptr != C_NULL
    apv = CC.EvaluateAsInitializer(seed_init, ctx, seed, true)
    @test apv isa CC.APValue
    @test apv.ptr != C_NULL
    @test CC.getKind(apv) == LX.CXAPValueKind_Int
    gv = CC.LLVM.GenericValue(CC.getInt(apv))
    @test convert(Int, gv) == 21
    CC.LLVM.dispose(gv)
    CC.dispose(apv)

    # ---- Expr::EvaluateWithSubstitution / isPotentialConstantExprUnevaluated -
    @test lookup(I, "cc_m_double")
    callee = CC.FunctionDecl(get_decl(lookup))
    mul = first(filter(n -> n isa CC.BinaryOperator, CC.subtree(CC.getBody(callee))))
    seed_lit = first(filter(n -> n isa CC.IntegerLiteral, CC.subtree(seed_init)))
    @test CC.getNumParams(callee) == 1
    subst = CC.EvaluateWithSubstitution(mul, ctx, callee, [seed_lit])
    @test subst isa CC.APValue
    @test subst.ptr != C_NULL
    @test CC.getKind(subst) == LX.CXAPValueKind_Int
    gv2 = CC.LLVM.GenericValue(CC.getInt(subst))
    @test convert(Int, gv2) == 42
    CC.LLVM.dispose(gv2)
    CC.dispose(subst)
    @test_throws AssertionError CC.EvaluateWithSubstitution(mul, ctx, callee,
                                                            [seed_lit, seed_lit])
    @test CC.isPotentialConstantExprUnevaluated(mul, callee)

    # ---- CallExpr::setADLCallKind ------------------------------------------
    calls = filter(n -> n isa CC.CallExpr, nodes)
    if !isempty(calls)
        call = first(calls)
        adl = CC.usesADL(call)
        CC.setADLCallKind(call, !adl)
        @test CC.usesADL(call) == !adl
        CC.setADLCallKind(call, adl)
        @test CC.usesADL(call) == adl
    end

    # ---- OffsetOfExpr setters ----------------------------------------------
    oe = first(filter(n -> n isa CC.OffsetOfExpr, nodes))
    opl = CC.getOperatorLoc(oe)
    CC.setOperatorLoc(oe, opl)
    @test CC.getOperatorLoc(oe).ptr == opl.ptr
    rpl = CC.getRParenLoc(oe)
    CC.setRParenLoc(oe, rpl)
    @test CC.getRParenLoc(oe).ptr == rpl.ptr
    tsi = CC.getTypeSourceInfo(oe)
    CC.setTypeSourceInfo(oe, tsi)
    @test CC.getTypeSourceInfo(oe).ptr == tsi.ptr
    @test CC.getNumExpressions(oe) >= 1
    ix = CC.getIndexExpr(oe, 0)
    CC.setIndexExpr(oe, 0, ix)
    @test CC.getIndexExpr(oe, 0).ptr == ix.ptr
    @test_throws AssertionError CC.setIndexExpr(oe, CC.getNumExpressions(oe), ix)

    # ---- InitListExpr mutators ---------------------------------------------
    ile = first(filter(n -> n isa CC.InitListExpr && CC.getNumInits(n) >= 2, nodes))
    n0 = CC.getNumInits(ile)
    CC.reserveInits(ile, ctx, n0 + 4)
    @test CC.getNumInits(ile) == n0
    init0 = CC.getInit(ile, 0)
    init1 = CC.getInit(ile, 1)
    displaced = CC.updateInit(ile, ctx, 0, init1)
    @test displaced isa CC.Expr_
    @test displaced.ptr == init0.ptr
    @test CC.getInit(ile, 0).ptr == init1.ptr
    CC.updateInit(ile, ctx, 0, init0)
    @test CC.getInit(ile, 0).ptr == init0.ptr
    # markError is asserted on the semantic form only; both branches are covered because
    # which form `subtree` reaches is a Sema detail.
    if CC.isSemanticForm(ile)
        CC.markError(ile)
        @test CC.containsErrors(ile)
    else
        @test_throws AssertionError CC.markError(ile)
    end

    # ---- DesignatedInitExpr setters ----------------------------------------
    # the designators live on the syntactic form, which `subtree` does not walk
    dies = CC.DesignatedInitExpr[]
    for n in filter(x -> x isa CC.InitListExpr, nodes)
        syn = CC.getSyntacticForm(n)
        syn.ptr == C_NULL && continue
        append!(dies, filter(m -> m isa CC.DesignatedInitExpr, CC.subtree(syn)))
    end
    if !isempty(dies)
        die = first(dies)
        eloc = CC.getEqualOrColonLoc(die)
        CC.setEqualOrColonLoc(die, eloc)
        @test CC.getEqualOrColonLoc(die).ptr == eloc.ptr
        gnu = CC.usesGNUSyntax(die)
        CC.setGNUSyntax(die, !gnu)
        @test CC.usesGNUSyntax(die) == !gnu
        CC.setGNUSyntax(die, gnu)
        @test CC.usesGNUSyntax(die) == gnu
        dinit = CC.getInit(die)
        CC.setInit(die, dinit)
        @test CC.getInit(die).ptr == dinit.ptr
        sub0 = CC.getSubExpr(die, 0)
        CC.setSubExpr(die, 0, sub0)
        @test CC.getSubExpr(die, 0).ptr == sub0.ptr
        @test_throws AssertionError CC.setSubExpr(die, CC.getNumSubExprs(die), sub0)
    end

    # ---- SourceLocExpr::EvaluateInContext ----------------------------------
    @test lookup(I, "cc_m_file")
    slfd = CC.FunctionDecl(get_decl(lookup))
    sle = first(filter(n -> n isa CC.SourceLocExpr, CC.subtree(CC.getBody(slfd))))
    slv = CC.EvaluateInContext(sle, ctx)
    @test slv isa CC.APValue
    @test slv.ptr != C_NULL
    # __builtin_FILE folds to the address of a string literal, never to an integer.
    @test !CC.isInt(slv)
    CC.dispose(slv)

    dispose(lookup)
    dispose(I)
end

@testset "Expr builders, dependence and setter tail (wl22 expr-n)" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             struct WL22S { int x; double y; };
             int wl22_add(int a, int b) { return a + b; }
             int wl22_caller(int n) {
                 int arr[3] = {1, 2, 3};
                 double d = 1.5;
                 d += 0.5;
                 WL22S s;
                 s.x = 4;
                 const char *fn = __func__;
                 (void)fn;
                 (void)d;
                 return wl22_add(n, arr[0]) + s.x;
             }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)
    @test lookup(I, "wl22_caller")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))
    pick(T) = first(filter(n -> n isa T, nodes))

    il = pick(CC.IntegerLiteral)
    ity = CC.getType(il)
    loc = CC.getBeginLoc(il)
    VKP = LX.CXExprValueKind_VK_PRValue
    VKL = LX.CXExprValueKind_VK_LValue
    OKO = LX.CXExprObjectKind_OK_Ordinary

    # ---- CallExpr: dependence maintenance and shrinkNumArgs ------------------
    ce = pick(CC.CallExpr)
    nargs = CC.getNumArgs(ce)
    @test nargs == 2
    @test !CC.isTypeDependent(ce)
    CC.markDependentForPostponedNameLookup(ce)
    @test CC.isTypeDependent(ce)
    CC.computeDependence(ce)
    @test !CC.isTypeDependent(ce)
    # shrinking to the current count is the identity; growing is what upstream forbids
    CC.shrinkNumArgs(ce, nargs)
    @test CC.getNumArgs(ce) == nargs
    @test_throws AssertionError CC.shrinkNumArgs(ce, nargs + 1)

    # ---- InitListExpr::resizeInits ------------------------------------------
    ile = first(filter(n -> n isa CC.InitListExpr && CC.getNumInits(n) == 3, nodes))
    n0 = CC.getNumInits(ile)
    first_init = CC.getInit(ile, 0)
    CC.resizeInits(ile, ctx, n0 + 2)
    @test CC.getNumInits(ile) == n0 + 2
    CC.resizeInits(ile, ctx, n0)
    @test CC.getNumInits(ile) == n0
    @test CC.getInit(ile, 0).ptr == first_init.ptr

    # ---- DeclRefExpr::setIsImmediateEscalating ------------------------------
    dre = pick(CC.DeclRefExpr)
    esc = CC.isImmediateEscalating(dre)
    CC.setIsImmediateEscalating(dre, !esc)
    @test CC.isImmediateEscalating(dre) == !esc
    CC.setIsImmediateEscalating(dre, esc)
    @test CC.isImmediateEscalating(dre) == esc

    # ---- FloatingLiteral::setExact ------------------------------------------
    fl = pick(CC.FloatingLiteral)
    ex = CC.isExact(fl)
    CC.setExact(fl, !ex)
    @test CC.isExact(fl) == !ex
    CC.setExact(fl, ex)
    @test CC.isExact(fl) == ex

    # ---- BinaryOperator: the static gate, Create and CreateEmpty ------------
    @test !CC.isCompoundAssignmentOp(LX.CXBinaryOperatorKind_BO_Add)
    @test CC.isCompoundAssignmentOp(LX.CXBinaryOperatorKind_BO_AddAssign)
    bo = CC.BinaryOperator(ctx, il, il, LX.CXBinaryOperatorKind_BO_Add, ity, VKP, OKO, loc,
                           0)
    @test bo isa CC.BinaryOperator
    @test CC.getOpcode(bo) == LX.CXBinaryOperatorKind_BO_Add
    @test CC.getLHS(bo).ptr == il.ptr
    @test CC.getRHS(bo).ptr == il.ptr
    @test CC.getFPFeatures(bo) == 0
    @test_throws AssertionError CC.BinaryOperator(ctx, il, il,
                                                  LX.CXBinaryOperatorKind_BO_AddAssign, ity,
                                                  VKP, OKO, loc, 0)

    boe = CC.BinaryOperator(ctx, false)
    @test boe isa CC.BinaryOperator
    # the shell's operand slots are uninitialized: write them before any reader runs
    CC.setOpcode(boe, LX.CXBinaryOperatorKind_BO_Sub)
    CC.setLHS(boe, il)
    CC.setRHS(boe, il)
    CC.setOperatorLoc(boe, loc)
    @test CC.getOpcode(boe) == LX.CXBinaryOperatorKind_BO_Sub
    @test CC.getLHS(boe).ptr == il.ptr
    @test CC.getRHS(boe).ptr == il.ptr

    # ---- CompoundAssignOperator::Create -------------------------------------
    cao = CC.CompoundAssignOperator(ctx, il, il, LX.CXBinaryOperatorKind_BO_AddAssign, ity,
                                    VKL, OKO, loc, 0, ity, ity)
    @test cao isa CC.CompoundAssignOperator
    @test CC.getOpcode(cao) == LX.CXBinaryOperatorKind_BO_AddAssign
    @test CC.getComputationLHSType(cao).ptr == ity.ptr
    @test CC.getComputationResultType(cao).ptr == ity.ptr
    @test_throws AssertionError CC.CompoundAssignOperator(ctx, il, il,
                                                          LX.CXBinaryOperatorKind_BO_Add,
                                                          ity, VKL, OKO, loc, 0, ity, ity)

    # ---- UnaryOperator::Create ----------------------------------------------
    uo = CC.UnaryOperator(ctx, il, LX.CXUnaryOperatorKind_UO_Minus, ity, VKP, OKO, loc,
                          false, 0)
    @test uo isa CC.UnaryOperator
    @test CC.getOpcode(uo) == LX.CXUnaryOperatorKind_UO_Minus
    @test CC.getSubExpr(uo).ptr == il.ptr
    @test CC.getOperatorLoc(uo).ptr == loc.ptr

    # ---- ImplicitCastExpr::Create / CreateEmpty -----------------------------
    ice = CC.ImplicitCastExpr(ctx, ity, LX.CXCastKind_CK_NoOp, il, VKP, 0)
    @test ice isa CC.ImplicitCastExpr
    @test CC.getCastKind(ice) == LX.CXCastKind_CK_NoOp
    @test CC.getSubExpr(ice).ptr == il.ptr

    icee = CC.ImplicitCastExpr(ctx, 0, false)
    @test icee isa CC.ImplicitCastExpr
    # the shell's operand slot and cast kind are uninitialized: write them first
    CC.setSubExpr(icee, il)
    CC.setCastKind(icee, LX.CXCastKind_CK_NoOp)
    @test CC.getSubExpr(icee).ptr == il.ptr
    @test CC.getCastKind(icee) == LX.CXCastKind_CK_NoOp

    # ---- MemberExpr::CreateImplicit -----------------------------------------
    me = pick(CC.MemberExpr)
    mbase = CC.getBase(me)
    mdecl = CC.getMemberDecl(me)
    mimp = CC.MemberExpr(ctx, mbase, CC.isArrow(me), mdecl, CC.getType(me),
                         CC.getValueKind(me), CC.getObjectKind(me))
    @test mimp isa CC.MemberExpr
    @test CC.getMemberDecl(mimp).ptr == mdecl.ptr
    @test CC.getBase(mimp).ptr == mbase.ptr
    @test CC.isArrow(mimp) == CC.isArrow(me)

    # ---- PredefinedExpr::Create ---------------------------------------------
    pe = pick(CC.PredefinedExpr)
    sl = CC.getFunctionName(pe)
    @test sl.ptr != C_NULL
    pe2 = CC.PredefinedExpr(ctx, CC.getBeginLoc(pe), CC.getType(pe), CC.getIdentKind(pe),
                            false, sl)
    @test pe2 isa CC.PredefinedExpr
    @test CC.getIdentKind(pe2) == CC.getIdentKind(pe)
    @test CC.getFunctionName(pe2).ptr == sl.ptr
    pe3 = CC.PredefinedExpr(ctx, CC.getBeginLoc(pe), CC.getType(pe), CC.getIdentKind(pe),
                            false)
    @test CC.getFunctionName(pe3).ptr == C_NULL

    # ---- ParenListExpr::Create ----------------------------------------------
    ple = CC.ParenListExpr(ctx, loc, [il, il], loc)
    @test ple isa CC.ParenListExpr
    @test CC.getNumExprs(ple) == 2
    @test CC.getExpr(ple, 0).ptr == il.ptr
    @test CC.getExpr(ple, 1).ptr == il.ptr
    @test CC.getNumExprs(CC.ParenListExpr(ctx, loc, CC.IntegerLiteral[], loc)) == 0

    # ---- ConstantExpr::Create / CreateEmpty ---------------------------------
    apv = CC.EvaluateAsInt(il, ctx)
    @test apv.ptr != C_NULL
    ce2 = CC.ConstantExpr(ctx, il, apv)
    @test ce2 isa CC.ConstantExpr
    # a small integer folds into the Int64 storage, never the full APValue one
    @test CC.getResultStorageKind(ce2) != LX.CXConstantResultStorageKind_None
    @test CC.getSubExpr(ce2).ptr == il.ptr
    CC.dispose(apv)

    cee = CC.ConstantExpr(ctx, LX.CXConstantResultStorageKind_None)
    @test cee isa CC.ConstantExpr
    # the shell's wrapped subexpression is uninitialized until it is written
    CC.setSubExpr(cee, il)
    @test CC.getSubExpr(cee).ptr == il.ptr
    @test CC.getResultStorageKind(cee) == LX.CXConstantResultStorageKind_None

    # ---- RecoveryExpr::Create + subExpressions ------------------------------
    rec = CC.RecoveryExpr(ctx, ity, loc, loc, [il])
    @test rec isa CC.RecoveryExpr
    @test CC.getNumSubExpressions(rec) == 1
    @test CC.getSubExpression(rec, 0).ptr == il.ptr
    @test_throws AssertionError CC.getSubExpression(rec, 1)
    @test CC.getNumSubExpressions(CC.RecoveryExpr(ctx, ity, loc, loc,
                                                  CC.IntegerLiteral[])) == 0
    @test_throws AssertionError CC.RecoveryExpr(ctx, CC.QualType(C_NULL), loc, loc, [il])

    dispose(lookup)
    dispose(I)
end

@testset "Expr float semantics, imaginary/matrix/block/shuffle setters, raw call operands" begin
    I = create_interpreter(["-std=gnu++20"])
    CC.parse(I, """
    typedef float cc_o_v4f __attribute__((ext_vector_type(4)));
    struct cc_o_rec { int x; int y; };
    consteval int cc_o_sq(int n) { return n * n; }
    int cc_o_id(int n) { return n; }
    int cc_o_expr(cc_o_v4f v) {
        double d = 1.25;
        float g = 2.5f;
        _Complex double c = 2.0i;
        cc_o_rec r{.x = 4, .y = 3};
        cc_o_v4f sh = __builtin_shufflevector(v, v, 3, 2, 1, 0);
        float p = g * 3.0f;
        int k = cc_o_sq(3);
        int m = cc_o_id(7);
        (void)c;
        return (int)d + (int)p + r.x + (int)sh.y + k + m;
    }
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    @test f(I, "cc_o_expr")
    fd = CC.FunctionDecl(get_decl(f))
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # ---- FloatingLiteral: the raw APFloatBase::Semantics enumerator ----------
    fls = filter(n -> n isa CC.FloatingLiteral, nodes)
    @test !isempty(fls)
    sems = [CC.getRawSemantics(fl) for fl in fls]
    @test all(s -> s isa Integer, sems)
    # 2.5f/3.0f are IEEE single and 1.25/2.0 IEEE double on every target, so the body
    # always carries at least two distinct raw semantics
    @test length(unique(sems)) >= 2

    fl = first(fls)
    raw = CC.getRawSemantics(fl)
    CC.setRawSemantics(fl, raw)
    @test CC.getRawSemantics(fl) == raw

    approx = CC.getValueAsApproximateDouble(fl)
    bits = CC.getValue(fl)
    @test bits != C_NULL
    CC.setValue(fl, ctx, bits)
    @test CC.getValueAsApproximateDouble(fl) == approx
    CC.LLVM.API.LLVMDisposeGenericValue(bits)

    # ---- Expr::EvaluateAsFixedPoint -----------------------------------------
    il = pick(CC.IntegerLiteral)
    @test il isa CC.IntegerLiteral
    fp = CC.EvaluateAsFixedPoint(il, ctx)
    @test fp isa CC.APValue
    if fp.ptr != C_NULL
        @test CC.isFixedPoint(fp)
        dispose(fp)
    end

    # ---- ImaginaryLiteral: operand round-trip -------------------------------
    imag = pick(CC.ImaginaryLiteral)
    @test imag isa CC.ImaginaryLiteral
    isub = CC.getSubExpr(imag)
    @test isub.ptr != C_NULL
    CC.setSubExpr(imag, isub)
    @test CC.getSubExpr(imag).ptr == isub.ptr

    # ---- CallExpr: the flat raw-operand view --------------------------------
    call = pick(CC.CallExpr)
    @test call isa CC.CallExpr
    nraw = CC.getNumRawSubExprs(call)
    @test nraw isa Integer
    @test nraw >= CC.getNumArgs(call) + 1
    @test !CC.is_null_handle(CC.getRawSubExpr(call, 0))
    @test CC.getRawSubExpr(call, 0).ptr == CC.getCallee(call).ptr
    @test_throws AssertionError CC.getRawSubExpr(call, nraw)

    # ---- setStoredFPFeatures: whether a node carries the trailing slot is a
    # host FP-default decision, so both branches are covered
    bo = pick(CC.BinaryOperator)
    @test bo isa CC.BinaryOperator
    if CC.hasStoredFPFeatures(bo)
        bof = CC.getStoredFPFeatures(bo)
        CC.setStoredFPFeatures(bo, bof)
        @test CC.getStoredFPFeatures(bo) == bof
    else
        @test_throws AssertionError CC.setStoredFPFeatures(bo, 0)
    end
    if CC.hasStoredFPFeatures(call)
        cef = CC.getStoredFPFeatures(call)
        CC.setStoredFPFeatures(call, cef)
        @test CC.getStoredFPFeatures(call) == cef
    else
        @test_throws AssertionError CC.setStoredFPFeatures(call, 0)
    end

    # ---- ShuffleVectorExpr: reinstall the operand array ---------------------
    sve = pick(CC.ShuffleVectorExpr)
    @test sve isa CC.ShuffleVectorExpr
    nsub = CC.getNumSubExprs(sve)
    @test nsub >= 2
    ops = CC.Expr_[CC.getExpr(sve, i) for i in 0:(nsub - 1)]
    CC.setExprs(sve, ctx, ops)
    @test CC.getNumSubExprs(sve) == nsub
    @test CC.getExpr(sve, 0).ptr == ops[1].ptr
    @test CC.getExpr(sve, nsub - 1).ptr == ops[end].ptr
    @test_throws AssertionError CC.setExprs(sve, ctx, CC.Expr_[first(ops)])

    # ---- ConstantExpr: re-cache the folded result ---------------------------
    cst = pick(CC.ConstantExpr)
    @test cst isa CC.ConstantExpr
    if CC.hasAPValueResult(cst)
        v = CC.getAPValueResult(cst)
        @test v isa CC.APValue
        @test v.ptr != C_NULL
        vkind = CC.getResultAPValueKind(cst)
        CC.SetResult(cst, v, ctx)
        @test CC.getResultAPValueKind(cst) == vkind
        dispose(v)
    end

    # ---- Designator::setFieldDecl -------------------------------------------
    # the designators live on the syntactic form, which `subtree` does not walk
    dies = CC.DesignatedInitExpr[]
    for n in filter(x -> x isa CC.InitListExpr, nodes)
        syn = CC.getSyntacticForm(n)
        syn.ptr == C_NULL && continue
        append!(dies, filter(m -> m isa CC.DesignatedInitExpr, CC.subtree(syn)))
    end
    @test !isempty(dies)
    d0 = CC.getDesignator(first(dies), 0)
    @test CC.isFieldDesignator(d0)
    dfd = CC.getFieldDecl(d0)
    if dfd.ptr != C_NULL
        CC.setFieldDecl(d0, dfd)
        @test CC.getFieldDecl(d0).ptr == dfd.ptr
    end

    dispose(f)
    dispose(I)

    # ---- MatrixSubscriptExpr setters (needs -fenable-matrix) ----------------
    Im = create_interpreter(["-std=gnu++20", "-fenable-matrix"])
    CC.parse(Im,
             """
             typedef float cc_o_mat4 __attribute__((matrix_type(4, 4)));
             float cc_o_mat_elem(cc_o_mat4 m) { return m[1][2]; }
             """)
    lm = DeclFinder(Im)
    @test lm(Im, "cc_o_mat_elem")
    mfd = CC.FunctionDecl(get_decl(lm))
    mse = first(filter(n -> n isa CC.MatrixSubscriptExpr, CC.subtree(CC.getBody(mfd))))
    mbase = CC.getBase(mse)
    mrow = CC.getRowIdx(mse)
    mcol = CC.getColumnIdx(mse)
    mrb = CC.getRBracketLoc(mse)
    @test mbase.ptr != C_NULL
    @test mrow.ptr != C_NULL
    @test mcol.ptr != C_NULL
    CC.setBase(mse, mbase)
    CC.setRowIdx(mse, mrow)
    CC.setColumnIdx(mse, mcol)
    CC.setRBracketLoc(mse, mrb)
    @test CC.getBase(mse).ptr == mbase.ptr
    @test CC.getRowIdx(mse).ptr == mrow.ptr
    @test CC.getColumnIdx(mse).ptr == mcol.ptr
    @test CC.getRBracketLoc(mse).ptr == mrb.ptr
    dispose(lm)
    dispose(Im)

    # ---- BlockExpr::setBlockDecl (needs -fblocks) ---------------------------
    Ib = create_interpreter(["-std=gnu++20", "-fblocks"])
    CC.parse(Ib,
             """
             void cc_o_block(void) { int (^blk)(void) = ^int(void) { return 7; }; (void)blk; }
             """)
    lb = DeclFinder(Ib)
    @test lb(Ib, "cc_o_block")
    bfd = CC.FunctionDecl(get_decl(lb))
    be = first(filter(n -> n isa CC.BlockExpr, CC.subtree(CC.getBody(bfd))))
    bd = CC.getBlockDecl(be)
    @test bd.ptr != C_NULL
    CC.setBlockDecl(be, bd)
    @test CC.getBlockDecl(be).ptr == bd.ptr
    dispose(lb)
    dispose(Ib)
end

@testset "Expr dependence, flexible-array query and the deserialization shells" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             struct WLPFam { int n; char data[]; };
             struct WLPPt { int x; int y; };
             int wlp_add(int a, int b) { return a + b; }
             int wlp_fn(int a, WLPFam *f) {
                 WLPPt p = {.x = 1, .y = 2};
                 int arr[3] = {1, 2, 3};
                 const char *s = "wlp";
                 const char *fam = f->data;
                 return wlp_add(a, p.x) + arr[0] + (int)s[0] + (int)fam[0] + f->n;
             }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)
    @test lookup(I, "wlp_fn")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))
    pick(T) = first(filter(n -> n isa T, nodes))

    il = pick(CC.IntegerLiteral)
    loc = CC.getBeginLoc(il)
    ce = pick(CC.CallExpr)
    sl = pick(CC.StringLiteral)
    mes = filter(n -> n isa CC.MemberExpr, nodes)

    # ---- Expr::getDependence -------------------------------------------------
    # bits: 1 unexpanded pack, 2 instantiation, 4 type, 8 value, 16 error
    @test CC.getDependence(il) == 0
    CC.markDependentForPostponedNameLookup(ce)
    @test CC.getDependence(ce) & 4 != 0
    CC.computeDependence(ce)
    @test CC.getDependence(ce) == 0

    # ---- Expr::isFlexibleArrayMemberLike ------------------------------------
    @test !isempty(mes)
    fam_like = [CC.isFlexibleArrayMemberLike(m, ctx, LX.CXStrictFlexArraysLevelKind_IncompleteOnly)
                for m in mes]
    @test all(v -> v isa Bool, fam_like)
    # `f->data` has incomplete array type, so it is flexible-array-like at every level
    @test any(fam_like)
    @test all(m -> CC.isFlexibleArrayMemberLike(m, ctx,
                                                LX.CXStrictFlexArraysLevelKind_ZeroOrIncomplete,
                                                true) isa Bool, mes)
    # an expression whose type is not an array is never one, whatever the level
    @test !CC.isFlexibleArrayMemberLike(il, ctx, LX.CXStrictFlexArraysLevelKind_Default)

    # ---- StringLiteral::Create / CreateEmpty --------------------------------
    sty = CC.getType(sl)
    made = CC.StringLiteral(ctx, "wlp", LX.CXStringLiteralKind_Ordinary, false, sty, [loc])
    @test made isa CC.StringLiteral
    @test CC.getString(made) == "wlp"
    @test CC.getLength(made) == 3
    @test CC.getCharByteWidth(made) == 1
    @test CC.getNumConcatenated(made) == 1
    @test CC.getKind(made) == LX.CXStringLiteralKind_Ordinary
    @test_throws AssertionError CC.StringLiteral(ctx, "wlp", LX.CXStringLiteralKind_Ordinary, false,
                                                 sty, CC.SourceLocation[])
    # an evaluated string literal's type has to be a constant array type
    @test_throws AssertionError CC.StringLiteral(ctx, "wlp", LX.CXStringLiteralKind_Ordinary, false,
                                                 CC.getType(il), [loc])

    sle = CC.StringLiteral(ctx, 1, 4, 1)
    @test sle isa CC.StringLiteral
    @test CC.getNumConcatenated(sle) == 1
    @test CC.getLength(sle) == 4
    @test CC.getCharByteWidth(sle) == 1

    # ---- the remaining deserialization shells -------------------------------
    # Only what the shell factory itself stores may be read; everything else is uninitialized.
    cee = CC.CallExpr(ctx, 2, false)
    @test cee isa CC.CallExpr
    @test cee.ptr != C_NULL
    @test CC.getNumArgs(cee) == 2
    @test CC.getStmtClassName(cee) == "CallExpr"

    mee = CC.MemberExpr(ctx, false, false, false, 0)
    @test mee isa CC.MemberExpr
    @test CC.getStmtClassName(mee) == "MemberExpr"

    pee = CC.PredefinedExpr(ctx, false)
    @test pee isa CC.PredefinedExpr
    @test CC.getStmtClassName(pee) == "PredefinedExpr"

    uoe = CC.UnaryOperator(ctx, false)
    @test uoe isa CC.UnaryOperator
    @test CC.getStmtClassName(uoe) == "UnaryOperator"

    caoe = CC.CompoundAssignOperator(ctx, false)
    @test caoe isa CC.CompoundAssignOperator
    @test CC.getStmtClassName(caoe) == "CompoundAssignOperator"

    ooe = CC.OffsetOfExpr(ctx, 1, 0)
    @test ooe isa CC.OffsetOfExpr
    @test CC.getStmtClassName(ooe) == "OffsetOfExpr"

    ple = CC.ParenListExpr(ctx, 3)
    @test ple isa CC.ParenListExpr
    @test CC.getNumExprs(ple) == 3
    @test CC.getStmtClassName(ple) == "ParenListExpr"

    gse = CC.GenericSelectionExpr(ctx, 2)
    @test gse isa CC.GenericSelectionExpr
    @test CC.getStmtClassName(gse) == "GenericSelectionExpr"

    rce = CC.RecoveryExpr(ctx, 0)
    @test rce isa CC.RecoveryExpr
    @test CC.getStmtClassName(rce) == "RecoveryExpr"

    # ---- Designator factories and DesignatedInitExpr::setDesignators --------
    ii = CC.getIdentifier(fd)
    @test ii.ptr != C_NULL
    dfield = CC.CreateFieldDesignator(ii, loc, loc)
    @test dfield isa CC.Designator
    @test CC.isFieldDesignator(dfield)
    @test !CC.isArrayDesignator(dfield)
    @test CC.getFieldName(dfield).ptr == ii.ptr
    @test CC.getDotLoc(dfield).ptr == loc.ptr
    @test CC.getFieldLoc(dfield).ptr == loc.ptr

    darr = CC.CreateArrayDesignator(2, loc, loc)
    @test CC.isArrayDesignator(darr)
    @test !CC.isArrayRangeDesignator(darr)
    # the index is the slot in the owning node's subexpression array, and round-trips
    @test CC.getArrayIndex(darr) == 2
    @test CC.getLBracketLoc(darr).ptr == loc.ptr
    @test CC.getRBracketLoc(darr).ptr == loc.ptr
    CC.dispose(darr)

    drange = CC.CreateArrayRangeDesignator(0, loc, loc, loc)
    @test CC.isArrayRangeDesignator(drange)
    @test CC.getArrayIndex(drange) == 0
    @test CC.getEllipsisLoc(drange).ptr == loc.ptr
    CC.dispose(drange)

    # the empty shell starts with no designators; setDesignators is what fills the list
    die = CC.DesignatedInitExpr(ctx, 1)
    @test die isa CC.DesignatedInitExpr
    @test CC.getStmtClassName(die) == "DesignatedInitExpr"
    @test CC.size(die) == 0
    CC.setDesignators(die, ctx, [dfield])
    @test CC.size(die) == 1
    d0 = CC.getDesignator(die, 0)
    @test CC.isFieldDesignator(d0)
    @test CC.getFieldName(d0).ptr == ii.ptr
    # the copy is independent of the source, which is still the caller's to dispose
    CC.dispose(dfield)
    @test CC.getFieldName(CC.getDesignator(die, 0)).ptr == ii.ptr

    dispose(lookup)
    dispose(I)
end

@testset "Expr node factories: call, fixed-point and SYCL stable-name" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             int exprq_callee(int x) { return x; }
             int exprq_use(int n) {
                 int q = exprq_callee(n);
                 return q;
             }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)
    @test lookup(I, "exprq_use")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    ce = first(n for n in nodes if n isa CC.CallExpr)
    dre = first(n for n in nodes if n isa CC.DeclRefExpr)
    loc = CC.getRParenLoc(ce)

    # ---- CallExpr::Create ---------------------------------------------------
    callee = CC.getCallee(ce)
    arg0 = CC.getArg(ce, 0)
    new_ce = CC.CallExpr(ctx, callee, [arg0], CC.getType(ce),
                         LX.CXExprValueKind_VK_PRValue, loc, 0, 0, false)
    @test new_ce isa CC.CallExpr
    @test CC.getStmtClassName(new_ce) == "CallExpr"
    @test CC.getNumArgs(new_ce) == 1
    @test CC.getCallee(new_ce).ptr == callee.ptr
    @test CC.getArg(new_ce, 0).ptr == arg0.ptr
    @test CC.getRParenLoc(new_ce).ptr == loc.ptr
    @test CC.usesADL(new_ce) == false
    # 0 is the only FPOptionsOverride encoding that leaves the trailing slot off
    @test CC.hasStoredFPFeatures(new_ce) == false

    # an empty argument list is legal, and the ADL flag round-trips through usesADL
    adl_ce = CC.CallExpr(ctx, callee, CC.Expr_[], CC.getType(ce),
                         LX.CXExprValueKind_VK_PRValue, loc, 0, 0, true)
    @test CC.getNumArgs(adl_ce) == 0
    @test CC.usesADL(adl_ce)

    # ---- DeclRefExpr: the explicit-object-parameter capture bit --------------
    @test !(CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre))
    CC.setCapturedByCopyInLambdaWithExplicitObjectParameter(dre, true, ctx)
    @test CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre)
    CC.setCapturedByCopyInLambdaWithExplicitObjectParameter(dre, false, ctx)
    @test !CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre)

    # ---- FixedPointLiteral (deserialization shell + its written slots) ------
    fpl = CC.FixedPointLiteral(ctx)
    @test fpl isa CC.FixedPointLiteral
    @test CC.getStmtClassName(fpl) == "FixedPointLiteral"
    # the shell leaves the scale and the location uninitialized: write before reading
    CC.setScale(fpl, 7)
    @test CC.getScale(fpl) == 7
    CC.setLocation(fpl, loc)
    @test CC.getLocation(fpl).ptr == loc.ptr

    # ---- SYCLUniqueStableNameExpr -------------------------------------------
    tsi = CC.getTrivialTypeSourceInfo(ctx, CC.getType(dre), loc)
    @test tsi isa CC.TypeSourceInfo
    sycl = CC.SYCLUniqueStableNameExpr(ctx, loc, loc, loc, tsi)
    @test sycl isa CC.SYCLUniqueStableNameExpr
    @test CC.getStmtClassName(sycl) == "SYCLUniqueStableNameExpr"
    @test CC.getTypeSourceInfo(sycl).ptr == tsi.ptr
    @test CC.getLocation(sycl).ptr == loc.ptr
    @test CC.getLParenLocation(sycl).ptr == loc.ptr
    @test CC.getRParenLocation(sycl).ptr == loc.ptr
    # the name is a mangling of the stored type, so only its shape is asserted
    stable_name = CC.ComputeName(sycl, ctx)
    @test stable_name isa String
    @test !isempty(stable_name)

    dispose(lookup)
    dispose(I)
end

@testset "Generic-selection associations, qualifier extents, designator expansion, astype" begin
    I = create_interpreter(["-std=gnu++20"])
    CC.parse(I,
             """
             namespace cc_r_ns {
             struct Point { int x; int y; };
             int gval = 5;
             }
             struct cc_r_base { int a; };
             struct cc_r_holder : cc_r_base {
                 int b;
                 template <class T> int tget() const { return (int)sizeof(T); }
             };
             template <class T> int cc_r_tfn() { return (int)sizeof(T); }
             int cc_r_fn(cc_r_holder h) {
                 int n = 1;
                 int g = _Generic(n, int: 1, default: 2);
                 cc_r_ns::Point p = { .x = 3, .y = 4 };
                 int qa = h.cc_r_base::a;
                 int ub = h.b;
                 int m = h.tget<int>();
                 int t = cc_r_tfn<double>();
                 int v = cc_r_ns::gval;
                 float fa = 1.5f, fb = 2.5f;
                 float fp = fa * fb;
                 unsigned long o = __builtin_offsetof(cc_r_ns::Point, y);
                 return g + p.x + qa + ub + m + t + v + (int)fp + (int)o;
             }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)
    @test lookup(I, "cc_r_fn")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))

    # ---- GenericSelectionExpr: the remaining Association fields --------------
    gse = first(n for n in nodes if n isa CC.GenericSelectionExpr)
    na = CC.getNumAssocs(gse)
    @test na == 2
    @test !CC.is_null_handle(CC.getAssocType(gse, 0))
    @test CC.getAssocType(gse, 0).ptr != C_NULL
    @test CC.getAssocType(gse, 1).ptr == C_NULL     # `default:` has no written type
    @test_throws AssertionError CC.getAssocType(gse, na)
    sel = [CC.isAssocSelected(gse, i) for i = 0:(na - 1)]
    @test all(s -> s isa Bool, sel)
    @test count(identity, sel) == 1
    @test sel[CC.getResultIndex(gse) + 1]
    @test_throws AssertionError CC.isAssocSelected(gse, na)

    # ---- the extent of a written nested-name-specifier -----------------------
    dres = filter(n -> n isa CC.DeclRefExpr, nodes)
    qdre = first(d for d in dres if CC.hasQualifier(d))
    qr = CC.getQualifierRange(qdre)
    @test qr isa CC.SourceRange
    @test CC.isValid(qr.begin_loc)
    @test CC.isValid(qr.end_loc)
    udre = first(d for d in dres if !CC.hasQualifier(d))
    @test !CC.isValid(CC.getQualifierRange(udre).begin_loc)

    mes = filter(n -> n isa CC.MemberExpr, nodes)
    qme = first(m for m in mes if CC.hasQualifier(m))
    @test CC.isValid(CC.getQualifierRange(qme).begin_loc)
    ume = first(m for m in mes if !CC.hasQualifier(m) && !CC.hasExplicitTemplateArgs(m))
    @test !CC.isValid(CC.getQualifierRange(ume).begin_loc)

    # ---- copyTemplateArgumentsInto ------------------------------------------
    loc0 = CC.getBeginLoc(CC.getBody(fd))
    tme = first(m for m in mes if CC.hasExplicitTemplateArgs(m))
    li = CC.TemplateArgumentListInfo(loc0, loc0)
    CC.copyTemplateArgumentsInto(tme, li)
    @test size(li) == Int(CC.getNumTemplateArgs(tme))
    @test size(li) >= 1
    dispose(li)

    tdre = first(d for d in dres if CC.hasExplicitTemplateArgs(d))
    li2 = CC.TemplateArgumentListInfo(loc0, loc0)
    CC.copyTemplateArgumentsInto(tdre, li2)
    @test size(li2) == Int(CC.getNumTemplateArgs(tdre))
    @test size(li2) >= 1
    dispose(li2)

    # a reference with no written argument list leaves the list untouched
    li3 = CC.TemplateArgumentListInfo(loc0, loc0)
    CC.copyTemplateArgumentsInto(ume, li3)
    @test size(li3) == 0
    dispose(li3)

    # ---- BinaryOperator: the stored-FP-features bit -------------------------
    # only the value the node was allocated with may be written back
    bo = first(n for n in nodes if n isa CC.BinaryOperator)
    hs = CC.hasStoredFPFeatures(bo)
    @test hs isa Bool
    CC.setHasStoredFPFeatures(bo, hs)
    @test CC.hasStoredFPFeatures(bo) == hs

    # ---- OffsetOfExpr::setComponent -----------------------------------------
    oe = first(n for n in nodes if n isa CC.OffsetOfExpr)
    nc = CC.getNumComponents(oe)
    @test nc >= 1
    comp = CC.getComponent(oe, 0)
    kind = CC.getKind(comp)
    CC.setComponent(oe, 0, comp)
    @test CC.getKind(CC.getComponent(oe, 0)) == kind
    @test_throws AssertionError CC.setComponent(oe, nc, comp)

    # ---- DesignatedInitExpr::ExpandDesignator -------------------------------
    # the designators live on the syntactic form, which `subtree` does not walk
    dies = CC.DesignatedInitExpr[]
    for ile in filter(n -> n isa CC.InitListExpr, nodes)
        syn = CC.getSyntacticForm(ile)
        syn.ptr == C_NULL && continue
        append!(dies, filter(m -> m isa CC.DesignatedInitExpr, CC.subtree(syn)))
    end
    @test !isempty(dies)
    die = first(dies)
    nd = size(die)
    @test nd >= 1
    d0 = CC.getDesignator(die, 0)
    @test CC.isFieldDesignator(d0)
    fname = CC.getFieldName(d0)
    # a one-for-one replacement rewrites the slot in place, so no Designator dangles
    CC.ExpandDesignator(die, ctx, 0, [d0])
    @test size(die) == nd
    @test CC.getFieldName(CC.getDesignator(die, 0)).ptr == fname.ptr
    @test_throws AssertionError CC.ExpandDesignator(die, ctx, nd, [d0])

    # ---- AsTypeExpr: built by hand, __builtin_astype being OpenCL-only ------
    il = first(n for n in nodes if n isa CC.IntegerLiteral)
    ity = CC.getType(il)
    loc = CC.getBeginLoc(il)
    ate = CC.AsTypeExpr(ctx, il, ity, CC.getValueKind(il), CC.getObjectKind(il), loc, loc)
    @test ate isa CC.AsTypeExpr
    @test CC.getSrcExpr(ate).ptr == il.ptr
    @test CC.getBuiltinLoc(ate).ptr == loc.ptr
    @test CC.getRParenLoc(ate).ptr == loc.ptr
    @test CC.getType(ate).ptr == ity.ptr
    @test_throws AssertionError CC.AsTypeExpr(ctx, il, CC.QualType(C_NULL),
                                              CC.getValueKind(il), CC.getObjectKind(il),
                                              loc, loc)

    # ---- FixedPointLiteral::CreateFromRawInt + getValueAsString -------------
    fpl = CC.FixedPointLiteral(ctx, 5, 32, ity, loc, 1)
    @test fpl isa CC.FixedPointLiteral
    @test CC.getScale(fpl) == 1
    @test CC.getLocation(fpl).ptr == loc.ptr
    s = CC.getValueAsString(fpl, 10)
    @test s isa String
    @test !isempty(s)
    @test_throws AssertionError CC.FixedPointLiteral(ctx, 5, 0, ity, loc, 1)
    @test_throws AssertionError CC.FixedPointLiteral(ctx, 5, 32, CC.QualType(C_NULL), loc, 1)

    dispose(lookup)
    dispose(I)
end

@testset "Expr constant-evaluation results, block-var copy init and deserialization shells" begin
    I = create_interpreter(["-std=c++20"])
    CC.parse(I,
             """
             int exprs_global = 7;
             constexpr char exprs_buf[] = "hello";
             constexpr const char *exprs_ptr = exprs_buf;
             constexpr int exprs_len = 5;
             int exprs_use(int n) { return exprs_global + n; }
             """)
    ctx = CC.get_ast_context(I)
    lookup = DeclFinder(I)

    @test lookup(I, "exprs_use")
    fd = CC.FunctionDecl(get_decl(lookup))
    nodes = CC.subtree(CC.getBody(fd))
    # select by referent, not by walk order: the body holds two DeclRefExprs
    dre = first(n for n in nodes
                if n isa CC.DeclRefExpr && CC.getNameAsString(CC.getDecl(n)) == "exprs_global")

    @test lookup(I, "exprs_len")
    size_e = CC.getInit(CC.VarDecl(get_decl(lookup)))
    @test lookup(I, "exprs_ptr")
    ptr_e = CC.getInit(CC.VarDecl(get_decl(lookup)))

    # ---- Expr::EvalResult: the status a value-only fold discards -------------
    rres = CC.EvalResult()
    @test rres isa CC.EvalResult
    @test !CC.is_null_handle(CC.getVal(rres))
    # the initializer of a constexpr int is a constant expression by language rule
    @test CC.EvaluateAsRValue(size_e, ctx, rres, true)
    @test CC.getKind(CC.getVal(rres)) == LX.CXAPValueKind_Int
    @test !(CC.hasSideEffects(rres))
    @test !(CC.hasUndefinedBehavior(rres))

    # ---- Expr::EvalResult::isGlobalLValue ------------------------------------
    lres = CC.EvalResult()
    ok_l = CC.EvaluateAsLValue(dre, ctx, lres, false)
    @test ok_l isa Bool
    if ok_l
        # isGlobalLValue asserts on this, so it is checked before the call
        @test CC.isLValue(CC.getVal(lres))
        @test CC.isGlobalLValue(lres)
    end

    # ---- Expr::EvaluateCharRangeAsString -------------------------------------
    sres = CC.EvalResult()
    ok_s, text = CC.EvaluateCharRangeAsString(ptr_e, size_e, ptr_e, ctx, sres)
    @test ok_s isa Bool
    @test text isa String
    # exprs_len code units read out of exprs_buf spell its contents
    @test !ok_s || text == "hello"
    @test !(CC.hasSideEffects(sres))

    dispose(rres)
    dispose(lres)
    dispose(sres)

    # ---- deserialization shells ----------------------------------------------
    fl = CC.FloatingLiteral(ctx)
    @test fl isa CC.FloatingLiteral
    @test CC.getStmtClassName(fl) == "FloatingLiteral"
    # the shell writes no payload: only values this test sets are read back
    CC.setExact(fl, true)
    @test CC.isExact(fl)
    CC.setExact(fl, false)
    @test !CC.isExact(fl)

    dre_shell = CC.DeclRefExpr(ctx, false, false, false, 0)
    @test dre_shell isa CC.DeclRefExpr
    @test CC.getStmtClassName(dre_shell) == "DeclRefExpr"

    sycl_shell = CC.SYCLUniqueStableNameExpr(ctx)
    @test sycl_shell isa CC.SYCLUniqueStableNameExpr
    @test CC.getStmtClassName(sycl_shell) == "SYCLUniqueStableNameExpr"

    poe = CC.PseudoObjectExpr(ctx, 2)
    @test poe isa CC.PseudoObjectExpr
    @test CC.getStmtClassName(poe) == "PseudoObjectExpr"
    # the count is the one slot the shell's constructor writes
    @test CC.getNumSemanticExprs(poe) == 2

    # ---- CallExpr::setNumArgsUnsafe ------------------------------------------
    ce_shell = CC.CallExpr(ctx, 3, false)
    @test CC.getNumArgs(ce_shell) == 3
    CC.shrinkNumArgs(ce_shell, 1)
    @test CC.getNumArgs(ce_shell) == 1
    # back up to the count the shell allocated trailing storage for
    CC.setNumArgsUnsafe(ce_shell, 3)
    @test CC.getNumArgs(ce_shell) == 3

    # ---- BlockVarCopyInit -----------------------------------------------------
    bvci = CC.BlockVarCopyInit(dre, true)
    @test bvci isa CC.BlockVarCopyInit
    @test CC.getCopyExpr(bvci).ptr == dre.ptr
    @test CC.canThrow(bvci)
    CC.setExprAndFlag(bvci, size_e, false)
    @test CC.getCopyExpr(bvci).ptr == size_e.ptr
    @test !CC.canThrow(bvci)
    dispose(bvci)

    dispose(lookup)
    dispose(I)
end
