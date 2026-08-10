using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "PCHContainerOperations: raw by default, object-file once registered" begin
    ops = CC.PCHContainerOperations()

    # the registry clang builds for you already knows the flat `.pch` format ...
    raw = CC.getRawReader(ops)
    @test "raw" in CC.getFormats(raw)
    rawwriter = CC.getWriterOrNull(ops, "raw")
    @test rawwriter !== nothing
    @test CC.getFormat(rawwriter) == "raw"

    # ... and nothing else
    @test CC.getReaderOrNull(ops, "obj") === nothing
    @test CC.getWriterOrNull(ops, "obj") === nothing
    @test CC.getReaderOrNull(ops, "no-such-format") === nothing

    CC.registerObjectFilePCHContainerWriter(ops)
    CC.registerObjectFilePCHContainerReader(ops)

    objwriter = CC.getWriterOrNull(ops, "obj")
    @test objwriter !== nothing
    @test CC.getFormat(objwriter) == "obj"

    objreader = CC.getReaderOrNull(ops, "obj")
    @test objreader !== nothing
    formats = CC.getFormats(objreader)
    @test "obj" in formats
    @test length(formats) == CC.getNumFormats(objreader)
    @test_throws AssertionError CC.getFormat(objreader, CC.getNumFormats(objreader))

    # registering the object pair does not lose the flat format: a registry that can read
    # `-gmodules` output must still read an ordinary PCH
    @test "raw" in CC.getFormats(CC.getRawReader(ops))
    @test CC.getReaderOrNull(ops, "no-such-format") === nothing

    dispose(ops)
end
