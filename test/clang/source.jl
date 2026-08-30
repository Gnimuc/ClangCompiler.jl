using ClangCompiler
using Test

const CC = ClangCompiler
using ClangCompiler: dispose

@testset "FileManager" begin
    fm = CC.FileManager()

    @testset "FileEntry" begin
        p = joinpath(@__DIR__, "..", "cxx", "main.cpp") |> normpath
        f = CC.getFileEntry(fm, p)
        @test CC.real_path_name(f) == p
        @test !CC.isNamedPipe(f)
        @test CC.getSize(f) > 0
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
    sm = CC.SourceManager(fm)

    code = """
    int x;
    int y;
    """
    buffer = CC.get_buffer(code)

    fid = CC.FileID(sm, buffer)
    @test CC.isValid(fid)

    CC.setMainFileID(sm, fid)

    fid2 = CC.getMainFileID(sm)
    @test CC.isValid(fid2)
    @test CC.getHashValue(fid) == CC.getHashValue(fid2)
    @test occursin("int x;", CC.getBufferData(sm, fid2))
    @test occursin("int y;", CC.getBufferData(sm, fid2))

    dispose(fid)
    dispose(fid2)
    dispose(sm)
    dispose(fm)
end
