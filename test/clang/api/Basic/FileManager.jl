using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "file manager, entries, buffers" begin
    fm = CC.FileManager()

    dir = CC.getDirectory(fm, @__DIR__)
    @test dir isa CC.DirectoryEntry
    @test dir.ptr != C_NULL

    file = @__FILE__
    fe = CC.getFileEntry(fm, file)
    @test CC.getModificationTime(fe) > 0
    de = CC.getDir(fe)
    @test de isa CC.DirectoryEntry
    @test de.ptr != C_NULL

    fer = CC.getFileRef(fm, file)
    @test fer isa CC.FileEntryRef
    @test occursin("FileManager", CC.getName(CC.getFileEntry(fer)))
    buf = CC.getBufferForFile(fm, fer)
    @test buf isa CC.LLVM.MemoryBuffer
    @test length(buf) == filesize(file)
    CC.LLVM.dispose(buf)

    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)
    ov = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits("int overridden;")), "override", true)
    CC.overrideFileContents(sm, fer, ov)   # consumes ov: do not dispose the buffer

    dispose(fer)
    dispose(sm)    # the source manager stores references: dispose before fm/diag
    dispose(fm)
    dispose(diag)
end

@testset "VFS-backed PCH file manager" begin
    ci = CC.CompilerInstance()
    vpath = joinpath(@__DIR__, "virtual_prefix_header.pch")  # exists only in the overlay
    payload = "not a real PCH"
    pch = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(payload)), "pch", true)
    fm = CC.createFileManagerWithVOFS4PCH(ci, vpath, 42, pch)  # consumes pch
    @test fm isa CC.FileManager
    @test fm.ptr != C_NULL
    fer = CC.getFileRef(fm, vpath)
    @test fer isa CC.FileEntryRef
    buf = CC.getBufferForFile(fm, fer; requires_null_terminator=false)
    @test buf isa CC.LLVM.MemoryBuffer
    @test length(buf) == sizeof(payload)
    CC.LLVM.dispose(buf)
    dispose(fer)
    dispose(ci)    # the instance owns the file manager it created
end

@testset "FileManager | reference identity, virtual files and sizes" begin
    fm = CC.FileManager()
    dir = mktempdir()
    path = joinpath(dir, "fmref_probe.cpp")
    write(path, "int fmref = 1;\n")

    r1 = CC.getOptionalFileRef(fm, path)
    @test r1 isa CC.FileEntryRef
    # the name round-trips the path the lookup was given
    @test CC.getName(r1) == path
    # the file's size is the bytes actually written
    @test CC.getSize(CC.getFileEntry(r1)) == filesize(path)

    # the directory reached through the reference is the one holding it
    d = CC.getDir(r1)
    @test d isa CC.DirectoryEntryRef
    CC.dispose(d)

    # a second lookup of the same path is the same reference and the same entry
    r2 = CC.getOptionalFileRef(fm, path)
    @test CC.isSameRef(r1, r2)
    @test CC.getName(CC.getFileEntry(r1)) == CC.getName(CC.getFileEntry(r2))

    # an absent path is the documented nothing, not a NULL carrier
    @test CC.getOptionalFileRef(fm, joinpath(dir, "no_such_file.cpp")) === nothing

    # looking the same real file up twice does not open a second one
    n = CC.getNumUniqueRealFiles(fm)
    @test n >= 1
    @test CC.getNumUniqueRealFiles(fm) == n

    CC.dispose(r2)
    CC.dispose(r1)
    CC.dispose(fm)
end
