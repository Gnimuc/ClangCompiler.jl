using ClangCompiler
using ClangCompiler: FileManager
using ClangCompiler: create_file_manager, status, destroy
using ClangCompiler: get_file, get_UID, name, real_path_name, is_valid, is_named_pipe
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
