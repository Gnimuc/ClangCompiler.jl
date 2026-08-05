using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "header search resource dir round-trip" begin
    ci = CC.CompilerInstance()
    hso = CC.getHeaderSearchOpts(ci)
    CC.SetResourceDir(hso, "/tmp/clangcompiler-fake-resource-dir")
    @test CC.GetResourceDir(hso) == "/tmp/clangcompiler-fake-resource-dir"
    dispose(ci)
end

@testset "HeaderSearch: reached through the interpreter's preprocessor" begin
    # A header map is registered only for an include argument naming a *file* in Apple's
    # hmap format, and every default argument names a directory, so the testset writes one
    # and hands it to the interpreter. The map is valid and empty: magic 'hmap' in the
    # host's byte order, version 1, a single empty bucket, and a one-byte string pool,
    # because offset zero into the pool is the reserved empty-bucket key.
    hmap_dir = mktempdir()
    hmap = joinpath(hmap_dir, "clangcompiler-probe.hmap")
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

    I = CC.create_interpreter(["-I" * hmap])
    ci = CC.get_instance(I)
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    @test hs isa CC.HeaderSearch && hs.ptr != C_NULL

    @test CC.getHeaderSearchOpts(hs).ptr == CC.getHeaderSearchOpts(ci).ptr != C_NULL
    @test CC.getFileMgr(hs).ptr == CC.getFileManager(ci).ptr != C_NULL
    @test CC.HasIncludeAliasMap(hs) == false
    @test CC.getModuleHash(hs) == ""
    @test CC.getModuleCachePath(hs) == ""

    n = Int(CC.search_dir_size(hs))
    @test n > 0
    @test CC.getSearchDirName(hs, 0) == hmap
    @test !isempty(CC.getSearchDirName(hs, n - 1)) && ispath(CC.getSearchDirName(hs, n - 1))

    # The enumeration names the file the testset handed the interpreter, spelled as the
    # include argument spelled it -- only the basename is compared, so a host free to
    # normalize the directory part cannot turn this into a false failure.
    m = Int(CC.getNumHeaderMapFileNames(hs))
    @test m >= 1
    hmap_names = String[]
    for i in 0:(m - 1)
        name = CC.getHeaderMapFileName(hs, i)
        @test !isempty(name) && isfile(name)
        push!(hmap_names, name)
    end
    @test basename(hmap) in basename.(hmap_names)

    CC.dispose(I)
    rm(hmap_dir; recursive=true, force=true)
end

@testset "HeaderSearch aliases, hashes and sizes" begin
    # HeaderSearch half: a throwaway interpreter owns the state being mutated.
    I = CC.create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    @test hs isa CC.HeaderSearch && hs.ptr != C_NULL

    ci = CC.get_instance(I)
    @test CC.getDiags(hs).ptr == CC.getDiagnostics(ci).ptr != C_NULL
    @test CC.header_file_size(hs) >= 0
    @test CC.getTotalMemory(hs) > 0

    @test CC.getUniqueFrameworkName(hs, "ClangCompilerFakeFramework") ==
          "ClangCompilerFakeFramework"
    # Uniquing is idempotent.
    @test CC.getUniqueFrameworkName(hs, "ClangCompilerFakeFramework") ==
          "ClangCompilerFakeFramework"

    old_hash = CC.getModuleHash(hs)
    CC.setModuleHash(hs, "clangcompiler-test-hash")
    @test CC.getModuleHash(hs) == "clangcompiler-test-hash"
    CC.setModuleHash(hs, old_hash)
    @test CC.getModuleHash(hs) == old_hash

    old_cache = CC.getModuleCachePath(hs)
    CC.setModuleCachePath(hs, "/tmp/clangcompiler-test-module-cache")
    @test CC.getModuleCachePath(hs) == "/tmp/clangcompiler-test-module-cache"
    CC.setModuleCachePath(hs, old_cache)
    @test CC.getModuleCachePath(hs) == old_cache

    CC.AddIncludeAlias(hs, "<clangcompiler-alias.h>", "clangcompiler-target.h")
    @test CC.HasIncludeAliasMap(hs)
    @test CC.MapHeaderToIncludeAlias(hs, "<clangcompiler-alias.h>") ==
          "clangcompiler-target.h"
    @test CC.MapHeaderToIncludeAlias(hs, "<clangcompiler-no-such-alias.h>") == ""

    CC.dispose(I)
end

@testset "HeaderSearch per-file info, module-map and diagnostic-path tails" begin
    # A throwaway interpreter owns every piece of state mutated here: the testset marks
    # headers, installs a controlling macro and finally wipes the whole file-info table.
    I = CC.create_interpreter()
    ci = CC.get_instance(I)
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    fm = CC.getFileMgr(hs)

    # A real on-disk header the search has never seen, so every HeaderFileInfo transition
    # below starts from a known state.
    path, io = mktemp()
    write(io, "int header_search_probe;\n")
    close(io)
    fer = CC.getFileRef(fm, path)
    @test fer isa CC.FileEntryRef && fer.ptr != C_NULL
    fe = CC.getFileEntry(fer)
    @test fe isa CC.FileEntry && fe.ptr != C_NULL

    try
        # Nothing is recorded until something asks for a record.
        @test CC.getExistingFileInfo(hs, fer).ptr == C_NULL
        @test CC.hasFileBeenImported(hs, fer) == false
        @test CC.isFileMultipleIncludeGuarded(hs, fer) == false

        # getFileDirFlavor goes through getFileInfo, which creates the record.
        @test CC.getFileDirFlavor(hs, fer) == CC.CXCharacteristicKind_C_User
        hfi = CC.getExistingFileInfo(hs, fer)
        @test hfi isa CC.HeaderFileInfo && hfi.ptr != C_NULL

        # Each call copies the record out, so two calls are distinct allocations holding
        # equal contents -- not the same pointer. That is the point: a view would dangle
        # the moment the search reallocated its record vector.
        hfi2 = CC.getFileInfo(hs, fer)
        hfi3 = CC.getExistingFileInfo(hs, fer; want_external=false)
        @test hfi2.ptr != hfi.ptr
        @test hfi3.ptr != hfi.ptr
        for other in (hfi2, hfi3)
            @test CC.getIsValid(other) == CC.getIsValid(hfi)
            @test CC.getDirInfo(other) == CC.getDirInfo(hfi)
            @test CC.getFramework(other) == CC.getFramework(hfi)
        end
        dispose(hfi2)
        dispose(hfi3)

        # The exposed fields of the aggregate. IsValid is set by the getFileInfo above.
        @test CC.getIsValid(hfi) == true
        @test CC.getIsImport(hfi) == false
        @test CC.getIsPragmaOnce(hfi) == false
        @test CC.getIsModuleHeader(hfi) == false
        @test CC.getDirInfo(hfi) == CC.CXCharacteristicKind_C_User
        @test CC.getFramework(hfi) == ""
        @test CC.getControllingMacroRaw(hfi).ptr == C_NULL

        # A snapshot does not track later edits: the record taken before the mark still
        # reads the old flavor, while a freshly taken one sees the new one.
        CC.MarkFileSystemHeader(hs, fer)
        @test CC.getFileDirFlavor(hs, fer) == CC.CXCharacteristicKind_C_System
        after = CC.getExistingFileInfo(hs, fer)
        @test CC.getDirInfo(after) == CC.CXCharacteristicKind_C_System
        dispose(after)
        dispose(hfi)

        CC.MarkFileIncludeOnce(hs, fer)
        once = CC.getExistingFileInfo(hs, fer)
        @test CC.getIsPragmaOnce(once)
        dispose(once)
        @test CC.isFileMultipleIncludeGuarded(hs, fer)

        guard = CC.getIdentifierInfo(pp, "CLANGCOMPILER_HEADER_SEARCH_PROBE_H")
        CC.SetFileControllingMacro(hs, fer, guard)
        guarded = CC.getExistingFileInfo(hs, fer)
        @test CC.getControllingMacroRaw(guarded).ptr == guard.ptr
        dispose(guarded)
        @test CC.isFileMultipleIncludeGuarded(hs, fer)

        # User-entry usage: one flag per HeaderSearchOptions user entry.
        usage = CC.computeUserEntryUsage(hs)
        @test usage isa Vector{Bool}
        @test length(usage) == Int(CC.getNumUserEntryUsage(hs))

        # Module-map bookkeeping. Implicit module maps are off by default.
        dir = CC.getDir(fe)
        @test dir isa CC.DirectoryEntry && dir.ptr != C_NULL
        @test CC.setDirectoryHasModuleMap(hs, dir) === nothing
        @test CC.hasModuleMap(hs, path, dir, false) == false

        # No prebuilt module paths are configured, so both forms come back empty.
        @test CC.getPrebuiltModuleFileName(hs, "ClangCompilerNoSuchModule") == ""
        @test CC.getPrebuiltModuleFileName(hs, "ClangCompilerNoSuchModule";
                                           file_map_only=true) == ""

        # Include-name / diagnostic-path suggestions.
        @test CC.getIncludeNameForHeader(hs, fe) == ""
        suggested, angled = CC.suggestPathToFileForDiagnostics(hs, fer, path)
        @test suggested == basename(path)
        @test angled == false

        # External lookup round-trips the value the testset itself put back.
        eps = CC.getExternalLookup(hs)
        @test eps isa CC.ExternalPreprocessorSource && eps.ptr == C_NULL
        CC.SetExternalLookup(hs, eps)
        @test CC.getExternalLookup(hs).ptr == eps.ptr

        # ModuleMap::setTarget only accepts the target already installed, which is the one
        # this interpreter's CompilerInstance holds.
        @test CC.setTarget(hs, CC.getTarget(ci)) === nothing

        # ClearFileInfo drops every record, so it runs last: the interpreter's
        # multiple-include state does not survive it.
        @test CC.header_file_size(hs) > 0
        CC.ClearFileInfo(hs)
        @test CC.header_file_size(hs) == 0
        @test CC.getExistingFileInfo(hs, fer).ptr == C_NULL
    finally
        dispose(fer)
        rm(path; force=true)
        CC.dispose(I)
    end
end
