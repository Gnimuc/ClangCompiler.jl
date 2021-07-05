using ClangCompiler
using ClangCompiler: FileManager, SourceManager, MemoryBuffer, FileID
using ClangCompiler: create_file_manager, status, destroy
using ClangCompiler: get_file, get_UID, name, real_path_name, is_valid, is_named_pipe
using ClangCompiler: value, set_main_file_id, get_main_file_id
using Test

@testset "FileManager" begin
    fm = FileManager()
    @test fm.ptr != C_NULL

    status(fm)
    @testset "FileEntry" begin
        p = joinpath(@__DIR__, "..", "code", "main.cpp") |> normpath
        f = get_file(fm, p)
        @test f.ptr != C_NULL
        @test name(f) == p == real_path_name(f)
        @test is_valid(f)
        @test !is_named_pipe(f)
    end
    status(fm)

    destroy(fm)
end

@testset "SourceManager" begin
    fm = FileManager()
    @test fm.ptr != C_NULL
    status(fm)

    sm = SourceManager(fm)
    @test sm.ptr != C_NULL

    code = """
    int x;
    int y;
    """
    buffer = MemoryBuffer(code)

    fid = FileID(sm, buffer)
    @test fid.ptr != C_NULL

    set_main_file_id(sm, fid)

    status(fm)

    fid2 = get_main_file_id(sm)
    @test fid2.ptr != C_NULL

    @test value(fid) == value(fid2)

    destroy(fid)
    destroy(fid2)
    destroy(sm)
    destroy(fm)
end
