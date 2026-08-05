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

@testset "Types" begin
    I = create_interpreter()
    ctx = get_ast_context(I)

    @test clty_to_jlty(jlty_to_clty(Cvoid, ctx)) == Cvoid
    @test clty_to_jlty(jlty_to_clty(Bool, ctx)) == Bool
    @test clty_to_jlty(jlty_to_clty(Int8, ctx)) == Int8
    @test clty_to_jlty(jlty_to_clty(Int16, ctx)) == Int16
    @test clty_to_jlty(jlty_to_clty(Int32, ctx)) == Int32
    @test clty_to_jlty(jlty_to_clty(Int64, ctx)) == Int64
    @test clty_to_jlty(jlty_to_clty(Int128, ctx)) == Int128
    @test clty_to_jlty(jlty_to_clty(UInt8, ctx)) == UInt8
    @test clty_to_jlty(jlty_to_clty(UInt16, ctx)) == UInt16
    @test clty_to_jlty(jlty_to_clty(UInt32, ctx)) == UInt32
    @test clty_to_jlty(jlty_to_clty(UInt64, ctx)) == UInt64
    @test clty_to_jlty(jlty_to_clty(UInt128, ctx)) == UInt128
    @test clty_to_jlty(jlty_to_clty(Float16, ctx)) == Float16
    @test clty_to_jlty(jlty_to_clty(Float32, ctx)) == Float32
    @test clty_to_jlty(jlty_to_clty(Float64, ctx)) == Float64
    @test clty_to_jlty(jlty_to_clty(Ptr{Cvoid}, ctx)) == Ptr{Cvoid}

    dispose(I)
end

using ClangCompiler: DeclFinder, get_decl, get_tag
@testset "coverage tail: types-mapping" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int tmv_int = 0;
    int *tmv_ptr = &tmv_int;
    int &tmv_lref = tmv_int;
    int &&tmv_rref = 5;
    int tmv_arr[3] = {1, 2, 3};
    extern int tmv_iarr[];
    typedef int TmvInt;
    TmvInt tmv_td = 0;
    namespace TmvNS { typedef int TmvTn; }
    using TmvNS::TmvTn;
    TmvTn tmv_using = 0;
    struct TmvRec { int m; };
    TmvRec tmv_rec;
    enum TmvE { TMV_A, TMV_B };
    TmvE tmv_ev = TMV_A;
    int tmv_fn(double, char);
    void tmv_vla(int n) { int vla[n]; (void)vla; }
    template <class T> struct TmvTempl { T x; };
    TmvTempl<int> tmv_si;
    template <int N> struct TmvS2 { int a[N]; };
    template <class T> struct TmvS3 { typename T::type v; };
    template <class T> struct TmvS4 { typename T::template TNest<int> w; };
    template <class...> struct TmvList {};
    template <class... Ts> struct TmvHold {
        template <class... Us> void tmv_mf(TmvList<Ts, Us>... zs);
    };
    TmvHold<int, double> tmv_hold;
    """)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)
    rvar(name) = (f(I, name); CC.resolve(get_decl(f)))
    qtof(name) = CC.getType(rvar(name))
    tpof(name) = CC.getTypePtr(qtof(name))
    rty(name) = CC.resolve(tpof(name))
    unwrap(t) = t isa CC.ElaboratedType ? CC.resolve(CC.getTypePtr(CC.getNamedType(t))) : t

    # -- clty_to_jlty: AbstractType fallback + BuiltinType (via resolve(AbstractBuiltinType)) --
    # The default builtin mapping returns the carrier itself, but test/types.jl
    # (earlier in the suite) demonstrates the user-mapping pattern by adding
    # concrete methods that return Julia types — accept both.
    r_int = CC.clty_to_jlty(tpof("tmv_int"))                       # @35 -> @41 -> resolve@103
    @test r_int isa CC.IntTy || r_int === Cint
    bt = rty("tmv_int")
    @test bt isa CC.BuiltinType
    r_bt = CC.clty_to_jlty(bt)                                     # @41
    @test r_bt isa CC.IntTy || r_bt === Cint
    @test CC.resolve(bt) isa CC.IntTy                              # resolve@103

    # -- sugar/identity carriers --
    elab = rty("tmv_rec")
    @test elab isa CC.ElaboratedType
    @test CC.clty_to_jlty(elab) isa CC.ElaboratedType              # @42
    tdty = unwrap(rty("tmv_td"))
    @test tdty isa CC.TypedefType
    @test CC.clty_to_jlty(tdty) isa CC.TypedefType                 # @43
    usty = unwrap(rty("tmv_using"))
    @test usty isa CC.UsingType
    @test CC.clty_to_jlty(usty) isa CC.UsingType                   # @44
    pty = rty("tmv_ptr")
    @test pty isa CC.PointerType
    @test CC.clty_to_jlty(pty) isa CC.PointerType                  # @45

    # -- TagType family --
    rrt = unwrap(rty("tmv_rec"))
    @test rrt isa CC.RecordType
    @test CC.clty_to_jlty(CC.TagType(rrt)) isa CC.RecordType   # @48 -> resolve@135 -> @49
    @test CC.clty_to_jlty(rrt) isa CC.RecordType                   # @49
    ety = unwrap(rty("tmv_ev"))
    @test ety isa CC.EnumType
    @test CC.clty_to_jlty(ety) isa CC.EnumType                     # @50
    @test CC.resolve(CC.TagType(ety)) isa CC.EnumType          # resolve@135 (enum branch)

    # -- FunctionType family --
    f(I, "tmv_fn")
    fd = CC.FunctionDecl(get_decl(f))
    fpt = CC.resolve(CC.getTypePtr(CC.getType(fd)))
    @test fpt isa CC.FunctionProtoType
    @test CC.clty_to_jlty(CC.FunctionType(fpt)) isa CC.FunctionProtoType  # @53
    @test CC.clty_to_jlty(fpt) isa CC.FunctionProtoType            # @54
    fnp_qt = CC.getFunctionNoProtoType(ctx, CC.get_qual_type(CC.IntTy(ctx)))
    fnpty = CC.resolve(CC.getTypePtr(fnp_qt))
    @test fnpty isa CC.FunctionNoProtoType
    @test CC.clty_to_jlty(fnpty) isa CC.FunctionNoProtoType        # @55
    @test CC.clty_to_jlty(CC.FunctionType(fnpty)) isa CC.FunctionNoProtoType

    # -- ReferenceType family --
    lref = rty("tmv_lref")
    @test lref isa CC.LValueReferenceType
    @test CC.clty_to_jlty(CC.ReferenceType(lref)) isa CC.LValueReferenceType  # @58 -> resolve@147 -> @59
    @test CC.clty_to_jlty(lref) isa CC.LValueReferenceType         # @59
    rref = rty("tmv_rref")
    @test rref isa CC.RValueReferenceType
    @test CC.clty_to_jlty(rref) isa CC.RValueReferenceType         # @60
    @test CC.resolve(CC.ReferenceType(rref)) isa CC.RValueReferenceType

    # -- ArrayType family --
    aty = rty("tmv_arr")
    @test aty isa CC.ConstantArrayType
    @test CC.clty_to_jlty(CC.ArrayType(aty)) isa CC.ConstantArrayType  # @63 -> resolve@153 -> @64
    @test CC.clty_to_jlty(aty) isa CC.ConstantArrayType            # @64
    ity = rty("tmv_iarr")
    @test ity isa CC.IncompleteArrayType
    @test CC.clty_to_jlty(ity) isa CC.IncompleteArrayType          # @65

    # VariableArrayType (VLA in a function body)
    f(I, "tmv_vla")
    vlabody = CC.resolve(CC.getBody(CC.FunctionDecl(get_decl(f))))
    local vaty = nothing
    for n in CC.subtree(vlabody)
        if n isa CC.DeclStmt
            for d in CC.getDecls(n)
                rd = CC.resolve(d)
                if rd isa CC.VarDecl
                    t = CC.resolve(CC.getTypePtr(CC.getType(rd)))
                    t isa CC.VariableArrayType && (vaty = t)
                end
            end
        end
    end
    @test vaty isa CC.VariableArrayType
    @test CC.clty_to_jlty(vaty) isa CC.VariableArrayType           # @66

    # DependentSizedArrayType (template pattern TmvS2 field a)
    f(I, "TmvS2")
    p2 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dsaty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p2)))))
    @test dsaty isa CC.DependentSizedArrayType
    @test CC.clty_to_jlty(dsaty) isa CC.DependentSizedArrayType    # @67

    # -- template-related carriers --
    # TemplateTypeParmType (pattern field of TmvTempl)
    f(I, "TmvTempl")
    patt = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    local ttpt = nothing
    for fld in CC.getFields(patt)
        ft = CC.resolve(CC.getTypePtr(CC.getType(fld)))
        ft isa CC.TemplateTypeParmType && (ttpt = ft)
    end
    @test ttpt isa CC.TemplateTypeParmType
    @test CC.clty_to_jlty(ttpt) isa CC.TemplateTypeParmType        # @70

    # TemplateSpecializationType + SubstTemplateTypeParmType (instantiated field of TmvTempl<int>)
    tst = unwrap(rty("tmv_si"))
    @test tst isa CC.TemplateSpecializationType
    @test CC.clty_to_jlty(tst) isa CC.TemplateSpecializationType   # @73
    srt = CC.resolve(CC.getTypePtr(CC.desugar(tst)))
    @test srt isa CC.RecordType
    sfld = first(CC.getFields(CC.getDecl(srt)))
    sttp = CC.resolve(CC.getTypePtr(CC.getType(sfld)))
    @test sttp isa CC.SubstTemplateTypeParmType
    @test CC.clty_to_jlty(sttp) isa CC.SubstTemplateTypeParmType   # @71

    # DependentNameType (template pattern TmvS3 field v)
    f(I, "TmvS3")
    p3 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dnty = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p3)))))
    @test dnty isa CC.DependentNameType
    @test CC.clty_to_jlty(dnty) isa CC.DependentNameType           # @74

    # DependentTemplateSpecializationType (template pattern TmvS4 field w)
    f(I, "TmvS4")
    p4 = CC.getTemplatedDecl(CC.resolve(get_decl(f)))
    dtst = CC.resolve(CC.getTypePtr(CC.getType(first(CC.getFields(p4)))))
    @test dtst isa CC.DependentTemplateSpecializationType
    @test CC.clty_to_jlty(dtst) isa CC.DependentTemplateSpecializationType  # @75

    # SubstTemplateTypeParmPackType: instantiating TmvHold<int,double> substitutes Ts
    # into the pack expansion TmvList<Ts, Us>... of the member template tmv_mf while
    # Us stays open; the pattern's first template argument is the substituted pack.
    tsth = unwrap(rty("tmv_hold"))
    @test tsth isa CC.TemplateSpecializationType
    hrt = CC.resolve(CC.getTypePtr(CC.desugar(tsth)))
    @test hrt isa CC.RecordType
    hdc = CC.castToDeclContext(CC.getDecl(hrt))
    local ftd = nothing
    for d in CC.decls(hdc)
        d isa CC.FunctionTemplateDecl && (ftd = d)
    end
    @test ftd isa CC.FunctionTemplateDecl
    parm = CC.getParamDecl(CC.FunctionDecl(CC.getTemplatedDecl(ftd)), 0)
    @test parm isa CC.ParmVarDecl
    tsi = CC.getTypeSourceInfo(parm)
    tl = CC.getTypeLoc(tsi)          # PackExpansionTypeLoc
    ptl = CC.getNextTypeLoc(tl)      # the expansion pattern: TmvList<Ts, Us>
    pat_t = unwrap(CC.resolve(CC.getTypePtr(CC.getType(ptl))))
    @test pat_t isa CC.TemplateSpecializationType
    spp = CC.resolve(CC.getTypePtr(CC.getAsType(CC.getArg(pat_t, 0))))
    @test spp isa CC.SubstTemplateTypeParmPackType
    @test CC.clty_to_jlty(spp) isa CC.SubstTemplateTypeParmPackType  # @72
    dispose(ptl)
    dispose(tl)

    # -- resolve fallback carriers --
    @test CC.resolve(CC.UnexposedType(tpof("tmv_int"))) isa CC.UnexposedType  # resolve@101

    # -- jlty_to_llvmty --
    # `decoy` is created after `llctx` and therefore sits on top of the task-bound
    # context stack, so these also verify that the explicit `ctx` argument wins
    # over the innermost active context.
    llctx = CC.LLVM.Context()
    decoy = CC.LLVM.Context()
    for T in (Bool, Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64,
              UInt128, Float16, Float32, Float64, Nothing, Ptr{Cvoid})
        llty = CC.jlty_to_llvmty(T, llctx)                         # @172-@193
        @test llty isa CC.LLVM.LLVMType
        @test CC.LLVM.context(llty) == llctx
    end
    @test CC.LLVM.width(CC.jlty_to_llvmty(Bool, llctx)) == 8
    @test CC.LLVM.width(CC.jlty_to_llvmty(UInt128, llctx)) == 128
    @test CC.jlty_to_llvmty(Float16, llctx) isa CC.LLVM.FloatingPointType
    @test CC.jlty_to_llvmty(Nothing, llctx) isa CC.LLVM.VoidType
    @test CC.jlty_to_llvmty(Ptr{Cvoid}, llctx) isa CC.LLVM.PointerType
    @test_throws ErrorException CC.jlty_to_llvmty(String, llctx)   # fallback @168
    CC.LLVM.dispose(decoy)
    CC.LLVM.dispose(llctx)

    # -- clty_to_llvmty_mem --
    cgm = CC.get_codegen_module(I)
    memty = CC.clty_to_llvmty_mem(qtof("tmv_int"), cgm)            # @199
    @test memty isa CC.LLVM.IntegerType
    @test CC.LLVM.width(memty) == 32
    # the AbstractType path routes through get_qual_type
    @test CC.clty_to_llvmty_mem(tpof("tmv_int"), cgm) isa CC.LLVM.IntegerType

    dispose(f)
    dispose(I)
end
