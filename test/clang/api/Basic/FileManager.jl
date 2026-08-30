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
    @test occursin("FileManager", CC.getName(fer))   # the name is the ref's, not the entry's

    # A virtual file is never touched on disk, so the manager hands back exactly what it was
    # told — which makes this a round trip through the two numbers whose width the shim and the
    # prebuilt clang-cpp have to agree on. A size past 2^32 is the one that would show a mingw
    # `off_t` narrowing, so it is the one asserted.
    vfer = CC.getVirtualFileRef(fm, joinpath(@__DIR__, "no_such_file.h"), 5_000_000_000, 987654321)
    @test occursin("no_such_file.h", CC.getName(vfer))
    vfe = CC.getFileEntry(vfer)
    @test CC.getSize(vfe) == 5_000_000_000
    @test CC.getModificationTime(vfe) == 987654321
    CC.dispose(vfer)
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
    @test CC.getName(r1) == CC.getName(r2)
    @test CC.getFileEntry(r1).ptr == CC.getFileEntry(r2).ptr   # and one entry behind both

    # an absent path is the documented nothing, not a NULL carrier
    @test CC.getOptionalFileRef(fm, joinpath(dir, "no_such_file.cpp")) === nothing

    # looking the same real file up twice does not open a second one
    n = CC.getNumUniqueRealFiles(fm)
    @test n >= 1
    @test CC.getNumUniqueRealFiles(fm) == n

    # Path rewriting. The results are host-decided strings, so what is asserted is the
    # PROPERTY clang promises, not the text: makeAbsolutePath yields an absolute path and
    # reports `changed` exactly when the input was not already one. Both hold on any host.
    abs_in = CC.makeAbsolutePath(fm, path)
    @test isabspath(abs_in.path)
    @test abs_in.changed == !isabspath(path)

    rel = CC.makeAbsolutePath(fm, "some/relative/file.cpp")
    @test isabspath(rel.path)
    @test rel.changed == true
    # clang prepends the working directory using the HOST's separator and leaves the relative
    # tail exactly as it was written, so on Windows the result mixes both:
    # `D:\...\test\some/relative/file.cpp`. The property is that the tail survives, which is
    # asserted by normalising separators rather than by building the expectation with
    # `joinpath` — that spells `\` on Windows and never matches what clang preserved.
    @test endswith(replace(rel.path, '\\' => '/'), "some/relative/file.cpp")

    # already absolute: idempotent, and clang says it did nothing
    again = CC.makeAbsolutePath(fm, abs_in.path)
    @test again.path == abs_in.path
    @test again.changed == false

    # a default-constructed FileManager has no working directory, so FixupRelativePath
    # leaves a relative path alone — which is the other polarity from makeAbsolutePath
    # above, where the same input becomes absolute
    fixed = CC.FixupRelativePath(fm, "some/relative/file.cpp")
    @test fixed.path == "some/relative/file.cpp"
    @test fixed.changed == false
    abs_fixed = CC.FixupRelativePath(fm, abs_in.path)
    @test abs_fixed.path == abs_in.path
    @test abs_fixed.changed == false

    # the canonical name is a copy, so it survives the reference it came from
    canon = CC.getCanonicalName(fm, r1)
    @test !isempty(canon)
    @test basename(canon) == basename(path)
    @test CC.getCanonicalName(fm, r2) == canon

    CC.dispose(r2)
    CC.dispose(r1)
    CC.dispose(fm)
end
