using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: clty_to_jlty, jlty_to_clty
using ClangCompiler: get_ast_context, get_codegen_module, convertTypeForMemory
using Test
import ClangCompiler as CC

CC.clty_to_jlty(x::CC.VoidTy) = Cvoid
CC.clty_to_jlty(x::CC.BoolTy) = Bool
CC.clty_to_jlty(x::CC.CharTy) = Cuchar
CC.clty_to_jlty(x::CC.WCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.WideCharTy) = Cwchar_t
CC.clty_to_jlty(x::CC.SignedCharTy) = Cchar
CC.clty_to_jlty(x::CC.ShortTy) = Cshort
CC.clty_to_jlty(x::CC.IntTy) = Cint
CC.clty_to_jlty(x::CC.LongTy) = Clong
CC.clty_to_jlty(x::CC.LongLongTy) = Clonglong
CC.clty_to_jlty(x::CC.Int128Ty) = Int128
CC.clty_to_jlty(x::CC.UnsignedCharTy) = Cuchar
CC.clty_to_jlty(x::CC.UnsignedShortTy) = Cushort
CC.clty_to_jlty(x::CC.UnsignedIntTy) = Cuint
CC.clty_to_jlty(x::CC.UnsignedLongTy) = Culong
CC.clty_to_jlty(x::CC.UnsignedLongLongTy) = Culonglong
CC.clty_to_jlty(x::CC.UnsignedInt128Ty) = UInt128
CC.clty_to_jlty(x::CC.FloatTy) = Cfloat
CC.clty_to_jlty(x::CC.DoubleTy) = Cdouble
CC.clty_to_jlty(x::CC.Float16Ty) = Float16
CC.clty_to_jlty(x::CC.HalfTy) = Float16
CC.clty_to_jlty(x::CC.BFloat16Ty) = Float16
CC.clty_to_jlty(x::CC.NullPtrTy) = Ptr{Cvoid}
CC.clty_to_jlty(x::CC.VoidPtrTy) = Ptr{Cvoid}
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
# Skiplist-drain tail (AST half): dyn_cast probes, ArrayRef views, decl
# factories, DeclContext pivots, and the process-global stats toggles.
# Assertions are host-portable: isa/Bool checks and round-trips of values
# set inside this file only.
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

@testset "qualifier and predicate exercise" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    const int ci = 0; volatile int vi = 0; int gx = 0; int *p; int &r = gx;
    int arr[3]; int fn5(double, char); typedef int myint; myint mi;
    enum E { A }; E ev; struct Rec { int m; }; Rec rc;
    """)
    f = CC.DeclFinder(I)
    tp(name) = (f(I, name); CC.getTypePtr(CC.getType(CC.VarDecl(CC.get_decl(f).ptr))))
    qt(name) = (f(I, name); CC.getType(CC.VarDecl(CC.get_decl(f).ptr)))

    # QualType qualifiers
    @test CC.isConstQualified(qt("ci"))
    @test !CC.isVolatileQualified(qt("ci"))
    @test CC.isVolatileQualified(qt("vi"))
    @test CC.hasQualifiers(qt("ci"))
    @test !CC.hasQualifiers(qt("gx"))
    @test !CC.isNull(qt("gx"))

    # pointer / reference / array accessors
    pty = CC.resolve(tp("p"))
    @test pty isa CC.PointerType
    @test CC.is_pointer_type(tp("p"))
    @test CC.resolve(CC.getTypePtr(CC.getPointeeType(pty))) isa CC.BuiltinType
    @test CC.resolve(tp("r")) isa CC.LValueReferenceType
    @test CC.is_reference_type(tp("r"))
    aty = CC.resolve(tp("arr"))
    @test aty isa CC.ConstantArrayType
    @test CC.is_array_type(tp("arr"))
    @test CC.resolve(CC.getTypePtr(CC.getElementType(aty))) isa CC.BuiltinType

    # function type return
    f(I, "fn5")
    fty = CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(CC.FunctionDecl(CC.get_decl(f).ptr)))))
    @test fty isa CC.FunctionProtoType
    @test CC.resolve(CC.getTypePtr(CC.getReturnType(fty))) isa CC.BuiltinType

    # typedef sugar desugars; elaborated record/enum sugar unwraps to a concrete leaf
    @test CC.desugar(CC.resolve(tp("mi"))) isa CC.QualType
    @test CC.resolve(tp("rc")) isa CC.ElaboratedType
    @test CC.is_record_type(tp("rc"))
    @test CC.resolve(CC.getTypePtr(CC.getNamedType(CC.resolve(tp("ev"))))) isa CC.EnumType

    CC.dispose(f)
    CC.dispose(I)
end

@testset "Type queries" begin
    I = create_interpreter(String[])
    CC.parse(I, """
        int gint = 1;
        int *pint = &gint;
        int &lref = gint;
        int &&rref = 2;
        __complex__ double cxv;
        struct Point { int x; int y; };
        Point gpt;
        int Point::*mptr = &Point::x;
        int arr7[7];
        extern int iarr[];
        int fn2(int a, double b);
        auto undeduced_fn();
        int cval = (int)3.5;
        template <int N> struct S2 { int a[N]; };
        template <class T> struct S4 { typename T::template TT<int> w; };
        template <class T> struct S5 { decltype(T::val) u; };
        template <class T> struct S6 { T t; };
        template <class T> struct TP { };
        template <> struct TP<int> { int q; };
        TP<int> tpv;
        template <int N> struct NT { };
        NT<3> ntv;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    rvar(name) = (@assert f(I, name) "lookup failed: $name"; CC.resolve(get_decl(f)))
    qtof(name) = CC.getType(rvar(name))
    tpof(name) = CC.getTypePtr(qtof(name))
    rty(name) = CC.resolve(tpof(name))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t
    canon(name) = CC.getTypePtr(CC.getCanonicalTypeInternal(tpof(name)))
    function patfield(name)
        @assert f(I, name) "lookup failed: $name"
        pat = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
        return CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(pat)))))
    end

    ib = tpof("gint")

    # every dyn_cast probe is false on a plain builtin int
    preds = (CC.isa_ComplexType, CC.isa_PointerType, CC.isa_ReferenceType,
             CC.isa_LValueReferenceType, CC.isa_RValueReferenceType,
             CC.isa_MemberPointerType, CC.isa_ArrayType, CC.isa_ConstantArrayType,
             CC.isa_IncompleteArrayType, CC.isa_VariableArrayType,
             CC.isa_DependentSizedArrayType, CC.isa_FunctionType,
             CC.isa_FunctionNoProtoType, CC.isa_FunctionProtoType,
             CC.isa_DependentDecltypeType, CC.isa_RecordType,
             CC.isa_TemplateTypeParmType, CC.isa_AutoType)
    for p in preds
        @test p(ib) == false
    end

    # ...and true on a matching probe type
    @test CC.isa_ComplexType(tpof("cxv"))
    @test CC.isa_PointerType(tpof("pint"))
    @test CC.isa_ReferenceType(tpof("lref"))
    @test CC.isa_LValueReferenceType(tpof("lref"))
    @test CC.isa_RValueReferenceType(tpof("rref"))
    @test CC.isa_MemberPointerType(tpof("mptr"))
    a7 = tpof("arr7")
    @test CC.isa_ArrayType(a7)
    @test CC.isa_ConstantArrayType(a7)
    @test CC.isa_VariableArrayType(a7) == false
    @test CC.isa_IncompleteArrayType(tpof("iarr"))
    dsa = patfield("S2")
    @test dsa isa CC.DependentSizedArrayType
    @test CC.isa_DependentSizedArrayType(dsa)
    fpt = rty("fn2")
    @test fpt isa CC.FunctionProtoType
    @test CC.isa_FunctionType(fpt)
    @test CC.isa_FunctionProtoType(fpt)
    @test CC.isa_FunctionNoProtoType(fpt) == false
    @test CC.isa_DependentDecltypeType(patfield("S5"))
    @test CC.isa_TemplateTypeParmType(patfield("S6"))
    @test CC.isa_RecordType(canon("gpt"))

    # undeduced auto return type: AutoType probe + contained DeducedType
    fpt_u = rty("undeduced_fn")
    @test fpt_u isa CC.FunctionProtoType
    @test CC.isa_AutoType(CC.getTypePtr(CC.getReturnType(fpt_u)))
    dt = CC.getContainedDeducedType(tpof("undeduced_fn"))
    @test dt isa CC.DeducedType
    @test dt.ptr != C_NULL
    @test CC.getContainedDeducedType(ib).ptr == C_NULL

    # FunctionProtoType parameter/exception ArrayRef views
    pts = CC.getParamTypes(fpt)
    @test Int(pts.Length) == 2
    @test Int(pts.Length) == CC.getNumParams(fpt)
    pts2 = CC.param_types(fpt)
    @test Int(pts2.Length) == 2
    @test pts2.Data == pts.Data
    @test Int(CC.exceptions(fpt).Length) == 0

    # ConstantArrayType: int[7] occupies 28 bytes -> 5 addressing bits
    caty = CC.resolve(a7)
    @test caty isa CC.ConstantArrayType
    @test CC.getNumAddressingBits(caty, ctx) == 5

    # DependentTemplateSpecializationType: T::template TT<int> carries one argument
    dtst = unwrap(patfield("S4"))
    @test dtst isa CC.DependentTemplateSpecializationType
    @test Int(CC.getTemplateArguments(dtst).Length) == 1

    # TemplateArgument: non-type argument carries a type for NT<3>, none for TP<int>
    ntt = unwrap(rty("ntv"))
    @test ntt isa CC.TemplateSpecializationType
    @test CC.getNonTypeTemplateArgumentType(CC.getArg(ntt, 0)).ptr != C_NULL
    tst = unwrap(rty("tpv"))
    @test CC.getNonTypeTemplateArgumentType(CC.getArg(tst, 0)).ptr == C_NULL

    # TagDecl template parameter lists: one `template<>` header on the explicit
    # specialization, none on a plain struct
    spec_rd = CC.getDecl(CC.resolve(canon("tpv")))
    @test CC.getNumTemplateParameterLists(spec_rd) == 1
    tpl = CC.getTemplateParameterList(spec_rd, 0)
    @test tpl isa CC.TemplateParameterList
    @test size(tpl) == 0
    prd = CC.getDecl(CC.resolve(canon("gpt")))
    @test CC.getNumTemplateParameterLists(prd) == 0
    @test CC.mayInsertExtraPadding(prd) == false
    @test CC.mayInsertExtraPadding(prd, false) == false

    # CStyleCastExpr declares its own begin/end locs (begin == its LParen)
    cse = CC.resolve(CC.getInit(rvar("cval")))
    @test cse isa CC.CStyleCastExpr
    bl = CC.getBeginLoc(cse)
    el = CC.getEndLoc(cse)
    @test bl isa CC.SourceLocation
    @test el isa CC.SourceLocation
    @test bl.ptr == CC.getLParenLoc(cse).ptr

    # free-function operator spelling
    @test CC.getOperatorSpelling(LX.CXOverloadedOperatorKind_OO_Plus) == "+"
    @test CC.getOperatorSpelling(LX.CXOverloadedOperatorKind_OO_Subscript) == "[]"

    CC.dispose(f)
    CC.dispose(I)
end

@testset "TemplateSpecializationType arguments" begin
    I = create_interpreter(String[])
    CC.parse(I, "template<typename T, int N> struct STempl { T x; }; STempl<int,3> stempl_obj;")
    f = DeclFinder(I)
    @test f(I, "stempl_obj")
    vd = CC.VarDecl(get_decl(f).ptr)
    ety = CC.resolve(CC.getTypePtr(CC.getType(vd)))
    tst = CC.resolve(CC.getTypePtr(CC.getNamedType(ety)))
    @test tst isa CC.TemplateSpecializationType
    @test CC.getNumArgs(tst) == 2
    @test CC.getArg(tst, 0) isa CC.TemplateArgument
    dispose(f)
    dispose(I)
end

@testset "FunctionProtoType accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fpt_probe(double a, char b) noexcept;")
    f = DeclFinder(I)
    @test f(I, "fpt_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    ty = CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(fd))))   # Type_ -> FunctionType -> FunctionProtoType
    @test ty isa CC.FunctionProtoType
    @test CC.getNumParams(ty) == 2
    @test CC.isVariadic(ty) == false
    @test CC.getNumExceptions(ty) == 0
    @test CC.isIntegerType(CC.getTypePtr(CC.getReturnType(ty)))
    @test CC.isRealFloatingType(CC.getTypePtr(CC.getParamType(ty, 0)))
    @test Integer(CC.getCallConv(ty)) == Integer(CC.LibClangEx.CXCallingConv_CC_C)
    @test CC.getExceptionSpecType(ty) == CC.LibClangEx.CXExceptionSpecificationType_EST_BasicNoexcept
    dispose(f)
    dispose(I)
end
