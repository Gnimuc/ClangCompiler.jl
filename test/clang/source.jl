using ClangCompiler
using Test

const CC = ClangCompiler

@testset "FileManager" begin
    fm = CC.FileManager()
    @test fm.ptr != C_NULL

    @testset "FileEntry" begin
        p = joinpath(@__DIR__, "..", "code", "main.cpp") |> normpath
        f = CC.getFileEntry(fm, p)
        @test f.ptr != C_NULL
        @test CC.get_name(f) == p == CC.real_path_name(f)
        @test CC.isValid(f)
        @test !CC.isNamedPipe(f)
    end

    dispose(fm)
end

@testset "SourceManager" begin
    fm = CC.FileManager()
    @test fm.ptr != C_NULL

    sm = CC.SourceManager(fm)
    @test sm.ptr != C_NULL

    code = """
    int x;
    int y;
    """
    buffer = get_buffer(code)

    fid = CC.FileID(sm, buffer)
    @test fid.ptr != C_NULL

    CC.setMainFileID(sm, fid)

    fid2 = CC.getMainFileID(sm)
    @test fid2.ptr != C_NULL

    @test CC.value(fid) == CC.value(fid2)

    dispose(fid)
    dispose(fid2)
    dispose(sm)
    dispose(fm)
end
