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

@testset "convertTypeForMemory" begin
    I = create_interpreter()
    ctx = get_ast_context(I)
    cgm = get_codegen_module(I)

    i8 = LLVM.LLVMType(convertTypeForMemory(cgm, CC.BoolTy(ctx)))
    @test LLVM.width(i8) == 8

    dispose(I)
end

@testset "Types | qualifier and predicate exercise" begin
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
