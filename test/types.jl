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
