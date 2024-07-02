using ClangCompiler
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose, get_ast_context, get_codegen_module
using ClangCompiler: clty_to_jlty, jlty_to_clty, convertTypeForMemory
using Test
import ClangCompiler as CC

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
