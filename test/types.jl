using ClangCompiler
using ClangCompiler.LLVM
using Test

@testset "Types" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    haskey(ENV, "CI") && push!(args, "-v")
    irgen = IncrementalIRGenerator(src, args)
    ctx = ClangCompiler.getASTContext(get_instance(irgen))

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

    dispose(irgen)
end

@testset "convertTypeForMemory" begin
    src = joinpath(@__DIR__, "code", "main.cpp")
    args = get_compiler_args()
    haskey(ENV, "CI") && push!(args, "-v")
    irgen = IncrementalIRGenerator(src, args)
    ctx = ClangCompiler.getASTContext(get_instance(irgen))
    cgm = ClangCompiler.get_codegen_module(irgen)
    i8 = LLVM.LLVMType(CC.convertTypeForMemory(cgm, CC.BoolTy(ctx)))
    @test width(i8) == 8
end
