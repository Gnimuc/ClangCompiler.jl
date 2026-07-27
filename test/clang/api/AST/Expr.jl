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
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    nodes = CC.subtree(CC.getBody(fd))

    il = first(filter(n -> n isa CC.IntegerLiteral, nodes))
    cs = first(filter(n -> n isa CC.CStyleCastExpr, nodes))

    # ---- Factories (read-only on the parsed nodes) ---------------------------
    ity = CC.getType(il)

    # CStyleCastExpr::CreateEmpty(ctx, PathSize, HasFPFeatures)
    empty_cast = CC.CStyleCastExpr(ctx, 0, false)
    @test empty_cast isa CC.CStyleCastExpr

    # CStyleCastExpr::Create (no-type-info): int -> int NoOp cast over `il`
    noop = CC.CStyleCastExpr(ctx, ity, CC.LibClangEx.CXExprValueKind_VK_PRValue,
                             CC.LibClangEx.CXCastKind_CK_NoOp, il)
    @test noop isa CC.CStyleCastExpr
    @test CC.getCastKind(noop) == CC.LibClangEx.CXCastKind_CK_NoOp
    @test CC.getSubExpr(noop).ptr == il.ptr

    # IntegerLiteral::Create(ctx, APInt-as-GenericValue, type, loc)
    gv = CC.getValue(il)
    newil = CC.IntegerLiteral(ctx, gv, ity, CC.getLocation(il))
    @test newil isa CC.IntegerLiteral

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
    vd = CC.VarDecl(get_decl(f).ptr)
    sl = _find_node(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    @test CC.getString(sl) == "abc"
    @test CC.getLength(sl) == 3
    @test CC.isOrdinary(sl)
    @test CC.getKind(sl) == CC.LibClangEx.CXStringLiteralKind_Ordinary

    CC.parse(I, "unsigned long g_sz = sizeof(int);")
    @test f(I, "g_sz")
    vd2 = CC.VarDecl(get_decl(f).ptr)
    uett = _find_node(CC.UnaryExprOrTypeTraitExpr, CC.resolve(CC.getInit(vd2)))
    @test uett !== nothing
    @test CC.getKind(uett) == CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf

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
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    body = CC.getBody(fd)
    nodes = CC.subtree(body)
    byT(T) = filter(n -> n isa T, nodes)
    first_of(T) = (v = byT(T); isempty(v) ? nothing : first(v))

    # ---- Expr base predicates (any expression node) --------------------------
    anyexpr = first(filter(n -> n isa CC.AbstractExpr, nodes))
    @test CC.getType(anyexpr) isa CC.QualType
    @test CC.getValueKind(anyexpr) isa CC.LibClangEx.CXExprValueKind
    @test CC.isLValue(anyexpr) isa Bool
    @test CC.isPRValue(anyexpr) isa Bool
    @test CC.isXValue(anyexpr) isa Bool
    @test CC.isGLValue(anyexpr) isa Bool
    @test CC.IgnoreImpCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreParens(anyexpr) isa CC.Expr_
    @test CC.IgnoreParenCasts(anyexpr) isa CC.Expr_
    @test CC.IgnoreParenImpCasts(anyexpr) isa CC.Expr_
    @test CC.containsErrors(anyexpr) isa Bool
    @test CC.containsUnexpandedParameterPack(anyexpr) isa Bool
    @test CC.hasPlaceholderType(anyexpr) isa Bool
    @test CC.isDefaultArgument(anyexpr) isa Bool
    @test CC.isImplicitCXXThis(anyexpr) isa Bool
    @test CC.isInstantiationDependent(anyexpr) isa Bool
    @test CC.isObjCSelfExpr(anyexpr) isa Bool
    @test CC.isOrdinaryOrBitFieldObject(anyexpr) isa Bool
    @test CC.isTypeDependent(anyexpr) isa Bool
    @test CC.isValueDependent(anyexpr) isa Bool
    @test CC.refersToBitField(anyexpr) isa Bool
    @test CC.refersToGlobalRegisterVar(anyexpr) isa Bool
    @test CC.refersToMatrixElement(anyexpr) isa Bool
    @test CC.refersToVectorElement(anyexpr) isa Bool
    @test CC.getExprLoc(anyexpr) isa CC.SourceLocation

    # ---- Expr constant folding (needs an ASTContext) -------------------------
    il = first_of(CC.IntegerLiteral)
    @test il !== nothing
    apr = CC.EvaluateAsRValue(il, ctx)
    @test apr isa CC.APValue
    apr.ptr != C_NULL && dispose(apr)
    @test CC.isEvaluatable(il, ctx) isa Bool
    @test CC.isIntegerConstantExpr(il, ctx) isa Bool
    @test CC.isCXX11ConstantExpr(il, ctx) isa Bool
    @test CC.EvaluateAsBooleanCondition(il, ctx) isa Integer
    api_ = CC.EvaluateAsInt(il, ctx)
    @test api_ isa CC.APValue
    api_.ptr != C_NULL && dispose(api_)

    # ---- IntegerLiteral ------------------------------------------------------
    @test CC.getValue(il) !== nothing
    @test CC.getBeginLoc(il) isa CC.SourceLocation
    @test CC.getEndLoc(il) isa CC.SourceLocation
    @test CC.getLocation(il) isa CC.SourceLocation

    # ---- FloatingLiteral -----------------------------------------------------
    fl = first_of(CC.FloatingLiteral)
    @test fl !== nothing
    @test CC.getValueAsApproximateDouble(fl) isa AbstractFloat
    @test CC.EvaluateAsFloat(fl, ctx) !== nothing

    # ---- CharacterLiteral ----------------------------------------------------
    chl = first_of(CC.CharacterLiteral)
    @test chl !== nothing
    @test CC.getValue(chl) isa Integer
    @test CC.getKind(chl) isa CC.LibClangEx.CXCharacterLiteralKind
    @test CC.getLocation(chl) isa CC.SourceLocation

    # ---- StringLiteral -------------------------------------------------------
    sl = first_of(CC.StringLiteral)
    @test sl !== nothing
    @test CC.getBytes(sl) isa String
    @test CC.getString(sl) isa String
    @test CC.getByteLength(sl) isa Integer
    @test CC.getLength(sl) isa Integer
    @test CC.getCharByteWidth(sl) isa Integer
    @test CC.getKind(sl) isa CC.LibClangEx.CXStringLiteralKind
    @test CC.isOrdinary(sl) isa Bool
    @test CC.isWide(sl) isa Bool
    @test CC.isUTF8(sl) isa Bool
    @test CC.isUTF16(sl) isa Bool
    @test CC.isUTF32(sl) isa Bool
    @test CC.isUnevaluated(sl) isa Bool
    @test CC.isPascal(sl) isa Bool
    @test CC.containsNonAscii(sl) isa Bool
    @test CC.containsNonAsciiOrNull(sl) isa Bool
    @test CC.getNumConcatenated(sl) isa Integer
    @test CC.getBeginLoc(sl) isa CC.SourceLocation
    @test CC.getEndLoc(sl) isa CC.SourceLocation

    # ---- ParenExpr -----------------------------------------------------------
    pe = first_of(CC.ParenExpr)
    @test pe !== nothing
    @test CC.getSubExpr(pe) isa CC.Expr_
    @test CC.getLParen(pe) isa CC.SourceLocation
    @test CC.getRParen(pe) isa CC.SourceLocation

    # ---- UnaryOperator -------------------------------------------------------
    uo = first_of(CC.UnaryOperator)
    @test uo !== nothing
    @test CC.getOpcode(uo) isa CC.LibClangEx.CXUnaryOperatorKind
    @test CC.getSubExpr(uo) isa CC.Expr_
    @test CC.getOperatorLoc(uo) isa CC.SourceLocation
    @test CC.isPrefix(uo) isa Bool
    @test CC.isPostfix(uo) isa Bool
    @test CC.isIncrementOp(uo) isa Bool
    @test CC.isDecrementOp(uo) isa Bool
    @test CC.canOverflow(uo) isa Bool
    @test CC.isIncrementDecrementOp(uo) isa Bool
    @test CC.isArithmeticOp(uo) isa Bool
    @test CC.hasStoredFPFeatures(uo) isa Bool

    # ---- ArraySubscriptExpr --------------------------------------------------
    ase = first_of(CC.ArraySubscriptExpr)
    @test ase !== nothing
    @test CC.getLHS(ase) isa CC.Expr_
    @test CC.getRHS(ase) isa CC.Expr_
    @test CC.getBase(ase) isa CC.Expr_
    @test CC.getIdx(ase) isa CC.Expr_
    @test CC.getRBracketLoc(ase) isa CC.SourceLocation

    # ---- CallExpr ------------------------------------------------------------
    ce = first_of(CC.CallExpr)
    @test ce !== nothing
    @test CC.getCallee(ce) isa CC.Expr_
    @test CC.getCalleeDecl(ce) isa CC.Decl
    @test CC.getDirectCallee(ce) isa CC.FunctionDecl
    nargs = CC.getNumArgs(ce)
    @test nargs isa Integer
    @test CC.getArg(ce, 0) isa CC.Expr_
    @test CC.getRParenLoc(ce) isa CC.SourceLocation
    @test CC.usesADL(ce) isa Bool
    @test CC.hasStoredFPFeatures(ce) isa Bool
    @test CC.getBuiltinCallee(ce) isa Integer
    @test CC.isCallToStdMove(ce) isa Bool

    # ---- MemberExpr ----------------------------------------------------------
    me = first_of(CC.MemberExpr)
    @test me !== nothing
    @test CC.getBase(me) isa CC.Expr_
    @test CC.getMemberDecl(me) isa CC.ValueDecl
    @test CC.isArrow(me) isa Bool
    @test CC.getMemberLoc(me) isa CC.SourceLocation
    @test CC.isImplicitAccess(me) isa Bool
    @test CC.getMemberNameInfo(me) isa CC.DeclarationNameInfo
    @test CC.hasQualifier(me) isa Bool
    @test CC.getTemplateKeywordLoc(me) isa CC.SourceLocation
    @test CC.getLAngleLoc(me) isa CC.SourceLocation
    @test CC.getRAngleLoc(me) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(me) isa Bool
    @test CC.hasExplicitTemplateArgs(me) isa Bool
    @test CC.getNumTemplateArgs(me) isa Integer
    @test CC.getOperatorLoc(me) isa CC.SourceLocation
    @test CC.hadMultipleCandidates(me) isa Bool
    @test CC.getQualifier(me) isa CC.NestedNameSpecifier

    # ---- CastExpr / ImplicitCastExpr / ExplicitCastExpr ----------------------
    ice = first_of(CC.ImplicitCastExpr)
    @test ice !== nothing
    @test CC.getCastKind(ice) isa CC.LibClangEx.CXCastKind
    @test CC.getCastKindName(ice) isa String
    @test CC.getSubExpr(ice) isa CC.Expr_
    @test CC.getSubExprAsWritten(ice) isa CC.Expr_
    @test CC.isPartOfExplicitCast(ice) isa Bool

    # CStyleCastExpr is an ExplicitCastExpr — covers getTypeAsWritten + own locs
    csc = first_of(CC.CStyleCastExpr)
    @test csc !== nothing
    @test CC.getTypeAsWritten(csc) isa CC.QualType
    @test CC.getLParenLoc(csc) isa CC.SourceLocation
    @test CC.getRParenLoc(csc) isa CC.SourceLocation

    # getPathElement needs a cast whose inheritance path is non-empty
    dtb = first(filter(n -> n isa CC.AbstractCastExpr &&
                            CC.getCastKindName(n) == "DerivedToBase", nodes))
    @test CC.getPathElement(dtb, 0) isa CC.CXXBaseSpecifier

    # ---- BinaryOperator ------------------------------------------------------
    bo = first_of(CC.BinaryOperator)
    @test bo !== nothing
    @test CC.getOpcode(bo) isa CC.LibClangEx.CXBinaryOperatorKind
    @test CC.getLHS(bo) isa CC.Expr_
    @test CC.getRHS(bo) isa CC.Expr_
    @test CC.getOperatorLoc(bo) isa CC.SourceLocation
    @test CC.getOpcodeStr(bo) isa String
    @test CC.isAssignmentOp(bo) isa Bool
    @test CC.isCompoundAssignmentOp(bo) isa Bool
    @test CC.isComparisonOp(bo) isa Bool

    # ---- CompoundAssignOperator ----------------------------------------------
    cao = first_of(CC.CompoundAssignOperator)
    @test cao !== nothing
    @test CC.getComputationLHSType(cao) isa CC.QualType
    @test CC.getComputationResultType(cao) isa CC.QualType

    # ---- ConditionalOperator -------------------------------------------------
    co = first_of(CC.ConditionalOperator)
    @test co !== nothing
    @test CC.getCond(co) isa CC.Expr_
    @test CC.getTrueExpr(co) isa CC.Expr_
    @test CC.getFalseExpr(co) isa CC.Expr_

    # ---- InitListExpr --------------------------------------------------------
    ile = first_of(CC.InitListExpr)
    @test ile !== nothing
    @test CC.getNumInits(ile) isa Integer
    @test CC.getInit(ile, 0) isa CC.Expr_
    @test CC.isSemanticForm(ile) isa Bool
    @test CC.getSyntacticForm(ile) isa CC.InitListExpr
    @test CC.getSemanticForm(ile) isa CC.InitListExpr
    @test CC.hasArrayFiller(ile) isa Bool
    @test CC.hasDesignatedInit(ile) isa Bool
    @test CC.isExplicit(ile) isa Bool
    @test CC.isStringLiteralInit(ile) isa Bool
    @test CC.isTransparent(ile) isa Bool
    @test CC.getLBraceLoc(ile) isa CC.SourceLocation
    @test CC.getRBraceLoc(ile) isa CC.SourceLocation
    @test CC.isSyntacticForm(ile) isa Bool
    @test CC.hadArrayRangeDesignator(ile) isa Bool
    @test CC.getArrayFiller(ile) isa CC.Expr_
    @test CC.getInitializedFieldInUnion(ile) isa CC.FieldDecl

    # ---- DeclRefExpr ---------------------------------------------------------
    dre = first_of(CC.DeclRefExpr)
    @test dre !== nothing
    @test CC.getDecl(dre) isa CC.ValueDecl
    @test CC.getFoundDecl(dre) isa CC.NamedDecl
    @test CC.hasQualifier(dre) isa Bool
    @test CC.getLocation(dre) isa CC.SourceLocation
    @test CC.getNameInfo(dre) isa CC.DeclarationNameInfo
    @test CC.hasTemplateKWAndArgsInfo(dre) isa Bool
    @test CC.getTemplateKeywordLoc(dre) isa CC.SourceLocation
    @test CC.getLAngleLoc(dre) isa CC.SourceLocation
    @test CC.getRAngleLoc(dre) isa CC.SourceLocation
    @test CC.hasTemplateKeyword(dre) isa Bool
    @test CC.hasExplicitTemplateArgs(dre) isa Bool
    @test CC.getNumTemplateArgs(dre) isa Integer
    @test CC.hadMultipleCandidates(dre) isa Bool
    @test CC.refersToEnclosingVariableOrCapture(dre) isa Bool
    @test CC.isImmediateEscalating(dre) isa Bool
    @test CC.isCapturedByCopyInLambdaWithExplicitObjectParameter(dre) isa Bool
    @test CC.getQualifier(dre) isa CC.NestedNameSpecifier

    # ---- UnaryExprOrTypeTraitExpr (sizeof) -----------------------------------
    uetts = byT(CC.UnaryExprOrTypeTraitExpr)
    @test !isempty(uetts)
    for u in uetts
        @test CC.isArgumentType(u) isa Bool
        @test CC.getTypeOfArgument(u) isa CC.QualType
        @test CC.getKind(u) isa CC.LibClangEx.CXUnaryExprOrTypeTrait
        @test CC.getOperatorLoc(u) isa CC.SourceLocation
        @test CC.getRParenLoc(u) isa CC.SourceLocation
        if CC.isArgumentType(u)
            @test CC.getArgumentType(u) isa CC.QualType
            @test CC.getArgumentTypeInfo(u) isa CC.TypeSourceInfo
        else
            @test CC.getArgumentExpr(u) isa CC.Expr_
        end
    end

    # ---- PredefinedExpr (__func__) -------------------------------------------
    pde = first_of(CC.PredefinedExpr)
    @test pde !== nothing
    @test CC.getIdentKind(pde) isa CC.LibClangEx.CXPredefinedIdentKind
    @test CC.getFunctionName(pde) isa CC.StringLiteral
    @test CC.getIdentKindName(pde) isa String

    # ---- StmtExpr ({ ...; }) -------------------------------------------------
    se = first_of(CC.StmtExpr)
    @test se !== nothing
    @test CC.getLParenLoc(se) isa CC.SourceLocation
    @test CC.getRParenLoc(se) isa CC.SourceLocation
    @test CC.getTemplateDepth(se) isa Integer
    @test CC.getSubStmt(se) isa CC.CompoundStmt

    # ---- CompoundLiteralExpr ((PointT){1,2}) ---------------------------------
    cle = first_of(CC.CompoundLiteralExpr)
    @test cle !== nothing
    @test CC.isFileScope(cle) isa Bool
    @test CC.getLParenLoc(cle) isa CC.SourceLocation
    @test CC.getInitializer(cle) isa CC.Expr_
    @test CC.getTypeSourceInfo(cle) isa CC.TypeSourceInfo

    # ---- ConstantExpr (immediate consteval invocation) -----------------------
    cst = first_of(CC.ConstantExpr)
    @test cst !== nothing
    @test CC.isImmediateInvocation(cst) isa Bool
    @test CC.hasAPValueResult(cst) isa Bool

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
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
    nodes = CC.subtree(CC.getBody(fd))

    # ---- Expr: ASTContext-taking classification -----------------------------
    ils = filter(n -> n isa CC.IntegerLiteral, nodes)
    @test !isempty(ils)
    il = first(ils)

    @test CC.getObjectKind(il) isa LX.CXExprObjectKind
    @test CC.isKnownToHaveBooleanValue(il, true) isa Bool
    @test CC.isCXX98IntegralConstantExpr(il, ctx) isa Bool
    @test CC.isConstantInitializer(il, ctx, false) isa Bool
    @test CC.HasSideEffects(il, ctx, true) == false
    @test CC.hasNonTrivialCall(il, ctx) == false
    @test CC.isBoundMemberFunction(il, ctx) == false
    @test CC.isSameComparisonOperand(il, il) isa Bool
    @test CC.findBoundMemberType(il) isa CC.QualType
    @test CC.getValueKindForType(CC.getType(il)) isa LX.CXExprValueKind
    @test CC.getSourceBitField(il) isa CC.FieldDecl
    @test CC.getReferencedDeclOfCallee(il) isa CC.Decl
    # only meaningful for class / pointer-to-class expressions; the wrapper's
    # precondition rejects an int literal instead of letting clang's unchecked
    # castAs<RecordType> run (crashed on Windows CI)
    @test_throws AssertionError CC.getBestDynamicClassType(il)
    @test CC.getAsBuiltinConstantDeclRef(il, ctx) isa CC.ValueDecl

    for f in (CC.IgnoreImplicit, CC.IgnoreImplicitAsWritten, CC.IgnoreParenBaseCasts,
              CC.IgnoreParenLValueCasts, CC.IgnoreUnlessSpelledInSource)
        @test f(il) isa CC.Expr_
    end
    @test CC.IgnoreParenNoopCasts(il, ctx) isa CC.Expr_

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
    @test CC.getCallReturnType(ce, ctx) isa CC.QualType
    @test CC.hasUnusedResultAttr(ce, ctx) isa Bool
    @test CC.isUnevaluatedBuiltinCall(ce, ctx) == false
    @test CC.isBuiltinAssumeFalse(ce, ctx) == false
    @test CC.getUnusedResultAttr(ce, ctx) isa CC.Attr
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
    @test CC.performsVirtualDispatch(me, lang_opts) isa Bool
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
    @test CC.getTypeInfoAsWritten(first(css)) isa CC.TypeSourceInfo
    # only valid for union destination types; the wrapper's precondition
    # rejects anything else instead of letting clang dereference a null record
    @test_throws AssertionError CC.getTargetFieldForToUnionCast(CC.getType(first(css)),
                                                                CC.getType(il))

    # ---- ConditionalOperator ------------------------------------------------
    cos = filter(n -> n isa CC.ConditionalOperator, nodes)
    @test !isempty(cos)
    @test CC.getQuestionLoc(first(cos)) isa CC.SourceLocation
    @test CC.getColonLoc(first(cos)) isa CC.SourceLocation

    # ---- FloatingLiteral ----------------------------------------------------
    fls = filter(n -> n isa CC.FloatingLiteral, nodes)
    @test !isempty(fls)
    fl = first(fls)
    @test CC.getValue(fl) != C_NULL
    @test CC.isExact(fl) isa Bool
    flloc = CC.getLocation(fl)
    CC.setLocation(fl, flloc)
    @test CC.getLocation(fl).ptr == flloc.ptr

    # ---- StringLiteral ------------------------------------------------------
    sls = filter(n -> n isa CC.StringLiteral, nodes)
    @test !isempty(sls)
    sl = first(sls)
    @test CC.getNumConcatenated(sl) >= 1
    @test CC.getStrTokenLoc(sl, 0) isa CC.SourceLocation
    @test CC.getCodeUnit(sl, 0) == UInt32('a')

    # ---- InitListExpr -------------------------------------------------------
    iles = filter(n -> n isa CC.InitListExpr, nodes)
    @test !isempty(iles)
    ile = first(iles)
    @test CC.isIdiomaticZeroInitializer(ile, lang_opts) isa Bool
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
        @test CC.getSubExpr(die, 0) isa CC.Expr_
        @test CC.isDirectInit(die) isa Bool
        @test CC.usesGNUSyntax(die) isa Bool
        @test CC.getEqualOrColonLoc(die) isa CC.SourceLocation
        @test CC.getDesignatorsSourceRange(die) isa CC.SourceRange

        d = CC.getDesignator(die, 0)
        @test d isa CC.Designator
        @test CC.isFieldDesignator(d) isa Bool
        @test CC.isArrayDesignator(d) isa Bool
        @test CC.isArrayRangeDesignator(d) isa Bool
        @test CC.getBeginLoc(d) isa CC.SourceLocation
        @test CC.getEndLoc(d) isa CC.SourceLocation
        if CC.isFieldDesignator(d)
            @test CC.getFieldName(d) isa CC.IdentifierInfo
            @test CC.getFieldDecl(d) isa CC.FieldDecl
            @test CC.getDotLoc(d) isa CC.SourceLocation
            @test CC.getFieldLoc(d) isa CC.SourceLocation
        elseif CC.isArrayDesignator(d) || CC.isArrayRangeDesignator(d)
            @test CC.getArrayIndex(d) isa Unsigned
            @test CC.getLBracketLoc(d) isa CC.SourceLocation
            @test CC.getRBracketLoc(d) isa CC.SourceLocation
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
    fd = CC.FunctionDecl(CC.get_decl(f).ptr)
    nodes = CC.subtree(CC.getBody(fd))
    function pick(T)
        i = findfirst(n -> n isa T, nodes)
        return i === nothing ? nothing : nodes[i]
    end

    # AtomicExpr — __atomic_load_n(p, seq_cst)
    ae = pick(CC.AtomicExpr)
    @test ae isa CC.AtomicExpr
    @test CC.getOp(ae) isa Integer
    @test occursin("atomic_load", CC.getOpAsString(ae))
    @test CC.getNumSubExprs(ae) >= 2
    @test CC.getSubExpr(ae, 0) isa CC.Expr_
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
    @test CC.getControllingExpr(gse) isa CC.Expr_
    @test CC.getControllingExpr(gse).ptr != C_NULL
    @test CC.getAssocExpr(gse, 0).ptr != C_NULL
    @test CC.getAssocExpr(gse, CC.getNumAssocs(gse) - 1).ptr != C_NULL

    # ChooseExpr — __builtin_choose_expr(1, 10, 20)
    ce = pick(CC.ChooseExpr)
    @test ce isa CC.ChooseExpr
    @test CC.isConditionDependent(ce) == false
    @test CC.isConditionTrue(ce) == true
    @test CC.getCond(ce) isa CC.Expr_
    @test CC.getCond(ce).ptr != C_NULL
    @test CC.getLHS(ce).ptr != C_NULL
    @test CC.getRHS(ce).ptr != C_NULL

    # ShuffleVectorExpr — two vector operands plus the constant mask
    sve = pick(CC.ShuffleVectorExpr)
    @test sve isa CC.ShuffleVectorExpr
    @test CC.getNumSubExprs(sve) >= 2
    @test CC.getExpr(sve, 0) isa CC.Expr_
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
    cond_fd = CC.FunctionDecl(get_decl(lookup).ptr)
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
    @test CC.isUnique(ove) isa Bool
    @test CC.getLocation(ove) isa CC.SourceLocation

    # GNUNullExpr
    gn = first(filter(n -> n isa CC.GNUNullExpr, cnodes))
    @test CC.getTokenLocation(gn) isa CC.SourceLocation

    # AddrLabelExpr
    al = first(filter(n -> n isa CC.AddrLabelExpr, cnodes))
    @test CC.getLabel(al) isa CC.LabelDecl
    @test CC.getAmpAmpLoc(al) isa CC.SourceLocation
    @test CC.getLabelLoc(al) isa CC.SourceLocation

    # VAArgExpr
    @test lookup(I, "va_fn")
    va_fd = CC.FunctionDecl(get_decl(lookup).ptr)
    vnodes = CC.subtree(CC.getBody(va_fd))
    va = first(filter(n -> n isa CC.VAArgExpr, vnodes))
    @test CC.getSubExpr(va) isa CC.AbstractExpr
    @test CC.isMicrosoftABI(va) isa Bool
    @test CC.getWrittenTypeInfo(va) isa CC.TypeSourceInfo
    @test CC.getBuiltinLoc(va) isa CC.SourceLocation
    @test CC.getRParenLoc(va) isa CC.SourceLocation

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
    mfd = CC.FunctionDecl(get_decl(lm).ptr)
    mse = first(filter(n -> n isa CC.MatrixSubscriptExpr, CC.subtree(CC.getBody(mfd))))
    @test CC.isIncomplete(mse) isa Bool
    @test CC.getBase(mse) isa CC.Expr_
    @test CC.getBase(mse).ptr != C_NULL
    @test CC.getRowIdx(mse) isa CC.Expr_
    @test CC.getRowIdx(mse).ptr != C_NULL
    @test CC.getColumnIdx(mse) isa CC.Expr_
    @test CC.getRBracketLoc(mse) isa CC.SourceLocation
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
    cvfd = CC.FunctionDecl(get_decl(lookup).ptr)
    cve = first(filter(n -> n isa CC.ConvertVectorExpr, CC.subtree(CC.getBody(cvfd))))
    @test CC.getSrcExpr(cve) isa CC.Expr_
    @test CC.getSrcExpr(cve).ptr != C_NULL
    @test CC.getTypeSourceInfo(cve) isa CC.TypeSourceInfo
    @test CC.getBuiltinLoc(cve) isa CC.SourceLocation
    @test CC.getRParenLoc(cve) isa CC.SourceLocation

    @test lookup(I, "cc_imag")
    imfd = CC.FunctionDecl(get_decl(lookup).ptr)
    il = first(filter(n -> n isa CC.ImaginaryLiteral, CC.subtree(CC.getBody(imfd))))
    @test CC.getSubExpr(il) isa CC.Expr_
    @test CC.getSubExpr(il).ptr != C_NULL

    @test lookup(I, "cc_file")
    slfd = CC.FunctionDecl(get_decl(lookup).ptr)
    sle = first(filter(n -> n isa CC.SourceLocExpr, CC.subtree(CC.getBody(slfd))))
    @test CC.getBuiltinStr(sle) isa AbstractString
    @test occursin("FILE", CC.getBuiltinStr(sle))
    @test CC.isIntType(sle) isa Bool
    @test CC.getParentContext(sle) isa CC.DeclContext
    @test CC.getLocation(sle) isa CC.SourceLocation

    @test lookup(I, "cc_choose")
    chfd = CC.FunctionDecl(get_decl(lookup).ptr)
    ce = first(filter(n -> n isa CC.ChooseExpr, CC.subtree(CC.getBody(chfd))))
    @test CC.isConditionDependent(ce) == false
    @test CC.getChosenSubExpr(ce) isa CC.Expr_
    @test CC.getChosenSubExpr(ce).ptr == CC.getLHS(ce).ptr
    @test CC.getBuiltinLoc(ce) isa CC.SourceLocation
    @test CC.getRParenLoc(ce) isa CC.SourceLocation

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
    bfd = CC.FunctionDecl(get_decl(lb).ptr)
    be = first(filter(n -> n isa CC.BlockExpr, CC.subtree(CC.getBody(bfd))))
    @test CC.getBlockDecl(be) isa CC.BlockDecl
    @test CC.getBlockDecl(be).ptr != C_NULL
    @test CC.getCaretLocation(be) isa CC.SourceLocation
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
    fd = CC.FunctionDecl(get_decl(f).ptr)
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
    @test CC.getOrder(ae) isa CC.Expr_
    @test CC.getOrder(ae).ptr != C_NULL
    @test CC.getValueType(ae) isa CC.QualType
    @test CC.isVolatile(ae) == false           # pointee `int` is not volatile-qualified
    @test CC.isOpenCL(ae) == false             # not an __opencl_atomic_* builtin
    @test CC.getBuiltinLoc(ae) isa CC.SourceLocation
    @test CC.getRParenLoc(ae) isa CC.SourceLocation

    # GenericSelectionExpr — _Generic(n, ...): expression-predicated, concrete result
    gse = pick(CC.GenericSelectionExpr)
    @test gse isa CC.GenericSelectionExpr
    @test CC.isTypePredicate(gse) == false
    @test CC.getResultExpr(gse) isa CC.Expr_
    @test CC.getResultExpr(gse).ptr != C_NULL
    @test CC.getGenericLoc(gse) isa CC.SourceLocation
    @test CC.getDefaultLoc(gse) isa CC.SourceLocation
    @test CC.getRParenLoc(gse) isa CC.SourceLocation

    # ArrayInitLoopExpr — array-by-value lambda capture copies element-wise
    ail = pick(CC.ArrayInitLoopExpr)
    @test ail isa CC.ArrayInitLoopExpr
    @test CC.getCommonExpr(ail) isa CC.OpaqueValueExpr
    @test CC.getCommonExpr(ail).ptr != C_NULL
    @test CC.getSubExpr(ail) isa CC.Expr_
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
    fd2 = CC.FunctionDecl(get_decl(f2).ptr)
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
    @test CC.getNumSemanticExprs(poe) isa Integer
    @test CC.getNumSemanticExprs(poe) >= 1
    @test CC.getResultExprIndex(poe) isa Integer
    @test CC.getResultExpr(poe) isa CC.Expr_        # property read has a result
    @test CC.getResultExpr(poe).ptr != C_NULL
    @test CC.getSemanticExpr(poe, 0) isa CC.Expr_
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
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
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
            @test CC.getBeginLoc(comp) isa CC.SourceLocation
            @test CC.getEndLoc(comp) isa CC.SourceLocation
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
    @test CC.IgnoreConversionOperatorSingleStep(il) isa CC.Expr_
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
    fd = CC.FunctionDecl(get_decl(f).ptr)
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
    @test CC.isReadIfDiscardedInCPlusPlus11(il) isa Bool
    @test CC.getBestDynamicClassTypeExpr(il) isa CC.Expr_
    @test CC.getBestDynamicClassTypeExpr(il).ptr != C_NULL
    @test CC.skipRValueSubobjectAdjustments(il) isa CC.Expr_
    @test CC.skipRValueSubobjectAdjustments(il).ptr != C_NULL

    # ---- FullExpr / ConstantExpr (immediate consteval invocation) ----
    cst = pick(CC.ConstantExpr)
    @test cst isa CC.ConstantExpr
    @test CC.getSubExpr(cst) isa CC.Expr_            # FullExpr::getSubExpr
    @test CC.getSubExpr(cst).ptr != C_NULL
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
    @test CC.getVal1(ae) isa CC.Expr_
    @test CC.getVal1(ae).ptr != C_NULL
    @test CC.getOrderFail(ae) isa CC.Expr_
    @test CC.getOrderFail(ae).ptr != C_NULL
    @test CC.getVal2(ae) isa CC.Expr_
    @test CC.getVal2(ae).ptr != C_NULL
    @test CC.getWeak(ae) isa CC.Expr_
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
    bfd = CC.FunctionDecl(get_decl(lb).ptr)
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
    fd = CC.FunctionDecl(get_decl(f).ptr)
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
    @test CC.isUnusedResultAWarning(il, ctx) isa Bool

    # ---- Expr::isPotentialConstantExpr (static, over a definition) -----------
    @test f(I, "cc_g_pce")
    pce = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.isPotentialConstantExpr(pce) isa Bool

    # ---- Expr::hasAnyTypeDependentArguments (static, over an array) ----------
    @test CC.hasAnyTypeDependentArguments(CC.AbstractExpr[il, ci_ref]) == false
    @test CC.hasAnyTypeDependentArguments(CC.Expr_[]) == false

    # ---- StringLiteral: source spelling + byte location ----------------------
    sl = first(filter(n -> n isa CC.StringLiteral && CC.getString(n) == "abc", nodes))
    @test CC.outputString(sl) == "\"abc\""
    sm = CC.getSourceManager(ctx)
    lopts = CC.getLangOpts(ctx)
    ti = CC.getTargetInfo(ctx)
    @test CC.getLocationOfByte(sl, 0, sm, lopts, ti) isa CC.SourceLocation
    @test_throws AssertionError CC.getLocationOfByte(sl, 99, sm, lopts, ti)

    # ---- PredefinedExpr: __func__ -------------------------------------------
    pe = pick(CC.PredefinedExpr)
    @test pe isa CC.PredefinedExpr
    @test CC.isTransparent(pe) isa Bool
    @test CC.getLocation(pe) isa CC.SourceLocation
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
    @test CC.getAssocTypeSourceInfo(gse, 0) isa CC.TypeSourceInfo
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
    fd = CC.FunctionDecl(get_decl(lookup).ptr)
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
    @test CC.hasScopeModel(ae) isa Bool
    if CC.hasScopeModel(ae)
        @test CC.getScope(ae) isa CC.Expr_
    end

    # ---- GenericSelectionExpr: the controlling type of a type predicate ------
    # `_Generic` with a type operand is a clang extension; skip where unavailable.
    CC.parse(I, "int cc_wl16_tg() { return _Generic(int, int: 1, default: 2); }")
    if lookup(I, "cc_wl16_tg")
        tfd = CC.FunctionDecl(get_decl(lookup).ptr)
        tnodes = CC.subtree(CC.getBody(tfd))
        ti = findfirst(n -> n isa CC.GenericSelectionExpr && CC.isTypePredicate(n), tnodes)
        if ti !== nothing
            @test CC.getControllingType(tnodes[ti]) isa CC.TypeSourceInfo
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
    fd = CC.FunctionDecl(get_decl(f).ptr)
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
