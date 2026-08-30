using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

@testset "DirectoryLookup | search-path entries and the search-path mutators" begin
    I = create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    fm = CC.getFileMgr(hs)

    dir = mktempdir()
    dref = CC.getOptionalDirectoryRef(fm, dir)
    @test dref isa CC.DirectoryEntryRef
    # a path that does not exist is the documented nullptr sentinel, not a NULL carrier
    @test CC.getOptionalDirectoryRef(fm, joinpath(dir, "nope")) === nothing

    dl = CC.DirectoryLookup(dref, CC.CXCharacteristicKind_C_User, false)
    # the name round-trips the exact string the test chose
    @test CC.getName(dl) == dir

    # AddSystemSearchPath appends, so the new entry lands at exactly the old size
    n = Int(CC.search_dir_size(hs))
    CC.AddSystemSearchPath(hs, dl)
    @test CC.search_dir_size(hs) == n + 1
    @test CC.getSearchDirName(hs, n) == dir

    CC.dispose(dl)
    CC.dispose(dref)
    dispose(I)
end

@testset "DirectoryLookup | AddSearchPath inserts before the system paths" begin
    # a separate interpreter: AddSearchPath shifts existing indices, so it must not run on
    # a search another testset has already asserted positions against
    I = create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    fm = CC.getFileMgr(hs)

    dir = mktempdir()
    dref = CC.getOptionalDirectoryRef(fm, dir)
    dl = CC.DirectoryLookup(dref, CC.CXCharacteristicKind_C_User, false)

    n = Int(CC.search_dir_size(hs))
    CC.AddSearchPath(hs, dl, true)
    @test CC.search_dir_size(hs) == n + 1
    # the insertion point is the old SystemDirIdx, which nothing exposes, so membership is
    # the assertable fact rather than a slot
    @test dir in [CC.getSearchDirName(hs, i) for i = 0:n]

    CC.dispose(dl)
    CC.dispose(dref)
    dispose(I)
end

@testset "HeaderSearch | header maps, module cache names and include-once" begin
    hmap_dir = mktempdir()
    hmap = joinpath(hmap_dir, "dl-probe.hmap")
    open(hmap, "w") do io
        write(io, UInt32(0x686d6170))              # magic
        write(io, UInt16(1))                       # version
        write(io, UInt16(0))                       # reserved, must be zero
        write(io, UInt32(36))                      # string pool offset: header + 1 bucket
        write(io, UInt32(0))                       # entry count
        write(io, UInt32(1))                       # bucket count, a power of two
        write(io, UInt32(0))                       # longest value length
        write(io, UInt32(0), UInt32(0), UInt32(0)) # the one bucket, key zero = empty
        write(io, UInt8(0))                        # string pool
    end
    txt = joinpath(hmap_dir, "not-a-map.txt")
    write(txt, "plain text, not a header map\n")

    # the interpreter is NOT given the map via -I, so it starts with none registered
    I = create_interpreter()
    ci = CC.get_instance(I)
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    fm = CC.getFileMgr(hs)

    m0 = CC.getNumHeaderMapFileNames(hs)
    fer = CC.getFileRef(fm, hmap)
    @test fer !== nothing
    hm = CC.CreateHeaderMap(hs, fer)
    @test !CC.is_null_handle(hm)
    @test CC.getNumHeaderMapFileNames(hs) == m0 + 1
    # the search uniques by file: a second call is the same map, not a second one
    hm2 = CC.CreateHeaderMap(hs, fer)
    @test hm2.ptr == hm.ptr
    @test CC.getNumHeaderMapFileNames(hs) == m0 + 1
    # a file that is not in hmap format is rejected
    txt_fer = CC.getFileRef(fm, txt)
    @test txt_fer !== nothing
    @test CC.is_null_handle(CC.CreateHeaderMap(hs, txt_fer))

    # the module cache name: empty without a cache path, under the cache path with one
    mmdir = mktempdir()
    mmp = joinpath(mmdir, "a.modulemap")   # the parent must exist; the file need not
    old = CC.getModuleCachePath(hs)
    CC.setModuleCachePath(hs, "")
    @test CC.getCachedModuleFileName(hs, "Foo", mmp) == ""
    cache = mktempdir()
    CC.setModuleCachePath(hs, cache)
    a = CC.getCachedModuleFileName(hs, "Foo", mmp)
    @test !isempty(a)
    @test startswith(a, cache)
    @test a == CC.getCachedModuleFileName(hs, "Foo", mmp)
    # same directory, so only the module name varies the answer
    @test a != CC.getCachedModuleFileName(hs, "Bar", mmp)
    CC.setModuleCachePath(hs, old)

    # ShouldEnterIncludeFile: a header the search has never seen is entered, and is first
    hdr = joinpath(mmdir, "once_probe.h")
    write(hdr, "int once_probe = 1;\n")
    hfer = CC.getFileRef(fm, hdr)
    @test hfer !== nothing
    enter1, first1 = CC.ShouldEnterIncludeFile(hs, pp, hfer)
    @test enter1
    @test first1
    # marking it include-once flips the decision
    CC.MarkFileIncludeOnce(hs, hfer)
    enter2, first2 = CC.ShouldEnterIncludeFile(hs, pp, hfer)
    @test !enter2
    @test !first2

    # the gates
    @test_throws AssertionError CC.ShouldEnterIncludeFile(hs, pp, hfer; modules_enabled=true)
    J = create_interpreter()
    hs2 = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(J)))
    @test_throws AssertionError CC.ShouldEnterIncludeFile(hs2, pp, hfer)
    dispose(J)

    dispose(I)
end
