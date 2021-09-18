using ClangCompiler
using ClangCompiler: FileManager, SourceManager, MemoryBuffer, FileID
using ClangCompiler: create_file_manager, PrintStats, dispose
using ClangCompiler: get_file, get_UID, name, real_path_name, is_valid, is_named_pipe
using ClangCompiler: value, set_main_file_id, get_main_file_id
using Test

@testset "FileManager" begin
    fm = FileManager()
    @test fm.ptr != C_NULL

    @testset "FileEntry" begin
        p = joinpath(@__DIR__, "..", "code", "main.cpp") |> normpath
        f = get_file(fm, p)
        @test f.ptr != C_NULL
        @test name(f) == p == real_path_name(f)
        @test is_valid(f)
        @test !is_named_pipe(f)
    end

    dispose(fm)
end

@testset "SourceManager" begin
    fm = FileManager()
    @test fm.ptr != C_NULL

    sm = SourceManager(fm)
    @test sm.ptr != C_NULL

    code = """
    int x;
    int y;
    """
    buffer = get_buffer(code)

    fid = FileID(sm, buffer)
    @test fid.ptr != C_NULL

    set_main_file_id(sm, fid)

    fid2 = get_main_file_id(sm)
    @test fid2.ptr != C_NULL

    @test value(fid) == value(fid2)

    dispose(fid)
    dispose(fid2)
    dispose(sm)
    dispose(fm)
end
