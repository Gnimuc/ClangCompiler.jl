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
    I = CC.create_interpreter()
    ci = CC.get_instance(I)
    pp = CC.getPreprocessor(ci)
    hs = CC.getHeaderSearchInfo(pp)
    @test hs isa CC.HeaderSearch

    @test CC.getHeaderSearchOpts(hs) isa CC.HeaderSearchOptions
    @test CC.getFileMgr(hs) isa CC.FileManager
    @test CC.HasIncludeAliasMap(hs) isa Bool
    @test CC.getModuleHash(hs) isa String
    @test CC.getModuleCachePath(hs) isa String

    n = Int(CC.search_dir_size(hs))
    @test n >= 0
    if n > 0
        @test CC.getSearchDirName(hs, 0) isa String
        @test CC.getSearchDirName(hs, n - 1) isa String
    end

    m = Int(CC.getNumHeaderMapFileNames(hs))
    @test m >= 0
    for i in 0:(m - 1)
        @test CC.getHeaderMapFileName(hs, i) isa String
    end

    CC.dispose(I)
end

@testset "HeaderSearch aliases, hashes and sizes" begin
    # HeaderSearch half: a throwaway interpreter owns the state being mutated.
    I = CC.create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    @test hs isa CC.HeaderSearch

    @test CC.getDiags(hs) isa CC.DiagnosticsEngine
    @test CC.header_file_size(hs) isa Integer
    @test CC.header_file_size(hs) >= 0
    @test CC.getTotalMemory(hs) isa Integer
    @test CC.getTotalMemory(hs) >= 0

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
    @test fer isa CC.FileEntryRef
    fe = CC.getFileEntry(fer)
    @test fe isa CC.FileEntry

    try
        # Nothing is recorded until something asks for a record.
        @test CC.getExistingFileInfo(hs, fer).ptr == C_NULL
        @test CC.hasFileBeenImported(hs, fer) == false
        @test CC.isFileMultipleIncludeGuarded(hs, fer) == false

        # getFileDirFlavor goes through getFileInfo, which creates the record.
        @test CC.getFileDirFlavor(hs, fer) isa CC.CXCharacteristicKind
        hfi = CC.getExistingFileInfo(hs, fer)
        @test hfi isa CC.HeaderFileInfo
        @test hfi.ptr != C_NULL

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
        @test CC.getIsValid(hfi)
        @test CC.getIsImport(hfi) isa Bool
        @test CC.getIsPragmaOnce(hfi) isa Bool
        @test CC.getIsModuleHeader(hfi) isa Bool
        @test CC.getDirInfo(hfi) isa CC.CXCharacteristicKind
        @test CC.getFramework(hfi) isa String
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

        # Module-map bookkeeping. Implicit module maps are off by default, so hasModuleMap
        # only has to answer in shape.
        dir = CC.getDir(fe)
        @test dir isa CC.DirectoryEntry
        @test CC.setDirectoryHasModuleMap(hs, dir) === nothing
        @test CC.hasModuleMap(hs, path, dir, false) isa Bool

        # No prebuilt module paths are configured, so both forms come back empty.
        @test CC.getPrebuiltModuleFileName(hs, "ClangCompilerNoSuchModule") == ""
        @test CC.getPrebuiltModuleFileName(hs, "ClangCompilerNoSuchModule";
                                           file_map_only=true) == ""

        # Include-name / diagnostic-path suggestions.
        @test CC.getIncludeNameForHeader(hs, fe) isa String
        suggested, angled = CC.suggestPathToFileForDiagnostics(hs, fer, path)
        @test suggested isa String
        @test angled isa Bool

        # External lookup round-trips the value the testset itself put back.
        eps = CC.getExternalLookup(hs)
        @test eps isa CC.ExternalPreprocessorSource
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
