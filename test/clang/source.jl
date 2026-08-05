using ClangCompiler
using Test

const CC = ClangCompiler
using ClangCompiler: dispose

@testset "FileManager" begin
    fm = CC.FileManager()
    @test fm.ptr != C_NULL

    @testset "FileEntry" begin
        p = joinpath(@__DIR__, "..", "cxx", "main.cpp") |> normpath
        f = CC.getFileEntry(fm, p)
        @test f.ptr != C_NULL
        @test CC.real_path_name(f) == p
        @test !CC.isNamedPipe(f)
        # the name is asked of the ref, not the entry: `FileEntry::getName` forwards to
        # whichever ref touched the file last, so it answers about lookup history
        ref = CC.getFileRef(fm, p)
        @test CC.getName(ref) == p
        @test CC.getFileEntry(ref).ptr == f.ptr      # and it is the same entry
        CC.dispose(ref)
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
    buffer = CC.get_buffer(code)

    fid = CC.FileID(sm, buffer)
    @test fid.ptr != C_NULL

    CC.setMainFileID(sm, fid)

    fid2 = CC.getMainFileID(sm)
    @test fid2.ptr != C_NULL

    @test CC.getHashValue(fid) == CC.getHashValue(fid2)

    dispose(fid)
    dispose(fid2)
    dispose(sm)
    dispose(fm)
end
