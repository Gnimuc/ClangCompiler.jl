using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# The in-memory / overlay cluster and the FileManager hook that installs it. Everything here
# is reference-counted, so the disposes drop references rather than destroying file systems
# something else is still reading through.

@testset "vfs | an in-memory file system overlaid on the real one" begin
    real = CC.getRealFileSystem()
    # the physical file system answers for this very file and not for a name nothing wrote
    @test CC.exists(real, @__FILE__)
    @test !CC.exists(real, joinpath(@__DIR__, "clangcompiler-no-such-file.h"))

    mem = CC.InMemoryFileSystem()
    # LLVM resolves virtual paths as native absolute paths, and a leading "/" is not
    # absolute on Windows, so anchor the probe on the same volume as this file.
    root = Sys.iswindows() ? string(first(splitdrive(@__DIR__)), "/clangcompiler-vfs-probe") :
                             "/clangcompiler-vfs-probe"
    path = "$root/probe.h"
    memfs = CC.castToFileSystem(mem)
    @test !CC.exists(memfs, path)
    # the buffer is handed over: the in-memory file system owns it from here
    buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits("int probe = 1;\n")), "probe", true)
    @test CC.addFile(mem, path, 0, buf)
    @test CC.exists(memfs, path)
    @test occursin("probe.h", CC.toString(mem))
    # and the in-memory file system knows nothing about the disk
    @test !CC.exists(memfs, @__FILE__)

    overlay = CC.OverlayFileSystem(real)
    ovfs = CC.castToFileSystem(overlay)
    # before the push the overlay is just its base
    @test CC.exists(ovfs, @__FILE__)
    @test !CC.exists(ovfs, path)
    CC.pushOverlay(overlay, memfs)
    # after it, both layers answer
    @test CC.exists(ovfs, path)
    @test CC.exists(ovfs, @__FILE__)

    # Installing it on a FileManager is what makes a header the compiler can open out of a
    # buffer that was never written to disk.
    fm = CC.FileManager()
    # a freshly created manager reads the real file system, which knows nothing of the probe
    before = CC.getVirtualFileSystem(fm)
    @test !CC.exists(before, path)
    @test CC.exists(before, @__FILE__)
    dispose(before)

    CC.setVirtualFileSystem(fm, ovfs)
    after = CC.getVirtualFileSystem(fm)
    @test CC.exists(after, path)
    dispose(after)

    fer = CC.getFileRef(fm, path)
    @test CC.getName(fer) == path
    @test CC.getSize(CC.getFileEntry(fer)) == ncodeunits("int probe = 1;\n")
    dispose(fer)

    dispose(fm)
    dispose(overlay)
    dispose(mem)
    dispose(real)
end
