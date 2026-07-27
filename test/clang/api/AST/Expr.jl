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
