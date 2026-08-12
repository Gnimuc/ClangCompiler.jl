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
    for i = 0:(m - 1)
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

    @test CC.getUniqueFrameworkName(hs, "ClangCompilerFakeFramework") == "ClangCompilerFakeFramework"
    # Uniquing is idempotent.
    @test CC.getUniqueFrameworkName(hs, "ClangCompilerFakeFramework") == "ClangCompilerFakeFramework"

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
    @test CC.MapHeaderToIncludeAlias(hs, "<clangcompiler-alias.h>") == "clangcompiler-target.h"
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
        @test CC.getPrebuiltModuleFileName(hs, "ClangCompilerNoSuchModule"; file_map_only=true) == ""

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

@testset "HeaderSearch search-path partition and LookupFile" begin
    # A throwaway interpreter owns the search paths this mutates: AddSearchPath shifts every
    # index at or after the insertion point, which the search's private caches do not follow.
    I = CC.create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    fm = CC.getFileMgr(hs)

    dir = mktempdir()
    probe = joinpath(dir, "clangcompiler-lookup-probe.h")
    write(probe, "int lookup_probe;\n")

    try
        angled0 = Int(CC.getAngledDirIdx(hs))
        system0 = Int(CC.getSystemDirIdx(hs))
        n0 = Int(CC.search_dir_size(hs))
        # The partition clang maintains over its own list, whatever the host's default paths
        # turn out to be.
        @test 0 <= angled0 <= system0 <= n0

        # The probe is on no search path yet. cache_failures stays false so this miss is not
        # recorded in the search's private LookupFileCache, where a later lookup would reuse it.
        missing_ref, _, _ = CC.LookupFile(hs, "clangcompiler-lookup-probe.h")
        @test missing_ref.ptr == C_NULL

        # Insert the directory as a quoted-only (-iquote) entry. Clang inserts at AngledDirIdx
        # and bumps both boundaries, so it lands at index angled0, inside [0, angled).
        dref = CC.getOptionalDirectoryRef(fm, dir)
        @test dref !== nothing
        dl = CC.DirectoryLookup(dref, CC.CXCharacteristicKind_C_User)
        CC.AddSearchPath(hs, dl, false)
        dispose(dl)
        dispose(dref)

        @test Int(CC.getAngledDirIdx(hs)) == angled0 + 1
        @test Int(CC.getSystemDirIdx(hs)) == system0 + 1
        @test Int(CC.search_dir_size(hs)) == n0 + 1
        @test CC.getSearchDirName(hs, angled0) == dir

        # A quoted lookup starts at index 0 and finds it; an angled lookup starts at
        # getAngledDirIdx and therefore cannot see a quoted-only entry. That difference is the
        # entire observable content of AddSearchPath's is_angled flag.
        # ...but not under its old name. The miss above is cached: HeaderSearch's
        # LookupFileCache records where the next search for this filename resumes, and a search
        # that found nothing leaves that past the end of the list. So the name that already
        # missed keeps missing, and `skip_cache` is what gets past it.
        still_missing, _, _ = CC.LookupFile(hs, "clangcompiler-lookup-probe.h")
        @test still_missing.ptr == C_NULL
        found, is_mapped, is_framework = CC.LookupFile(hs, "clangcompiler-lookup-probe.h"; skip_cache=true)
        @test found.ptr != C_NULL
        @test is_mapped == false
        @test is_framework == false

        # the cache is keyed per filename, so a name that never missed needs no help
        fresh = joinpath(dir, "clangcompiler-lookup-fresh.h")
        write(fresh, "int lookup_fresh;\n")
        fresh_ref, _, _ = CC.LookupFile(hs, "clangcompiler-lookup-fresh.h")
        @test fresh_ref.ptr != C_NULL
        dispose(fresh_ref)

        angled_miss, _, _ = CC.LookupFile(hs, "clangcompiler-lookup-probe.h"; is_angled=true, skip_cache=true)
        @test angled_miss.ptr == C_NULL

        # The search resolved to the same file the file manager hands out for the absolute
        # path -- FileEntry identity, which clang uniques by inode rather than by spelling.
        direct = CC.getFileRef(fm, probe)
        @test CC.getFileEntry(found).ptr == CC.getFileEntry(direct).ptr
        @test basename(CC.getName(found)) == basename(probe)
        dispose(direct)
        dispose(found)

        # A name nothing on the path provides still misses, so the hit above is not vacuous.
        absent, _, _ = CC.LookupFile(hs, "clangcompiler-no-such-probe.h")
        @test absent.ptr == C_NULL
    finally
        # Dispose BEFORE removing the directory. The interpreter owns the FileManager, which
        # keeps these headers open; POSIX unlinks an open file happily but Windows refuses,
        # and `force=true` covers "not found", not "in use".
        CC.dispose(I)
        rm(dir; recursive=true, force=true)
    end
end

@testset "HeaderSearch module-header marks and the role bitmask" begin
    I = CC.create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    fm = CC.getFileMgr(hs)

    path, io = mktemp()
    write(io, "int module_header_probe;\n")
    close(io)
    fer = CC.getFileRef(fm, path)

    try
        # A role is a bitmask, and these are the four constants clang packs into it.
        @test CC.isModular(CC.CXModuleHeaderRole_NormalHeader)
        @test CC.isModular(CC.CXModuleHeaderRole_PrivateHeader)
        @test !CC.isModular(CC.CXModuleHeaderRole_TextualHeader)
        @test !CC.isModular(CC.CXModuleHeaderRole_ExcludedHeader)

        # A combined role is a legal runtime value matching no single enumerator, which is why
        # roles cross the boundary as a UInt32 rather than as an @enum.
        combined = UInt32(CC.CXModuleHeaderRole_PrivateHeader) | UInt32(CC.CXModuleHeaderRole_TextualHeader)
        @test CC.isPrivateHeaderRole(combined)
        @test CC.isTextualHeaderRole(combined)
        @test !CC.isExcludedHeaderRole(combined)
        @test !CC.isModular(combined)

        # A non-modular role with is_compiling_module_header false changes nothing, so clang
        # returns before creating a record -- unlike every other MarkFile* function.
        @test CC.getExistingFileInfo(hs, fer).ptr == C_NULL
        CC.MarkFileModuleHeader(hs, fer, CC.CXModuleHeaderRole_TextualHeader, false)
        @test CC.getExistingFileInfo(hs, fer).ptr == C_NULL

        # A modular role does create one, and sets exactly the module-header bit.
        CC.MarkFileModuleHeader(hs, fer, CC.CXModuleHeaderRole_NormalHeader, false)
        hfi = CC.getExistingFileInfo(hs, fer)
        @test hfi.ptr != C_NULL
        @test CC.getIsModuleHeader(hfi) == true
        @test CC.getIsCompilingModuleHeader(hfi) == false
        # External neighbours those two in the same bitfield, so reading it as false while
        # isModuleHeader reads true is what tells the three accessors apart.
        @test CC.getExternal(hfi) == false
        dispose(hfi)

        # The compiling bit is independent, and both are OR-ed in: a later textual mark cannot
        # clear the module-header bit an earlier modular one set.
        CC.MarkFileModuleHeader(hs, fer, CC.CXModuleHeaderRole_TextualHeader, true)
        marked = CC.getExistingFileInfo(hs, fer)
        @test marked.ptr != C_NULL
        @test CC.getIsCompilingModuleHeader(marked) == true
        @test CC.getIsModuleHeader(marked) == true
        @test CC.getExternal(marked) == false
        dispose(marked)

        # External is false, and that is precisely why want_external=false still reports the
        # record: clang filters on that bit and on no other.
        no_external = CC.getExistingFileInfo(hs, fer; want_external=false)
        @test no_external.ptr != C_NULL
        @test CC.getExternal(no_external) == false
        dispose(no_external)
    finally
        dispose(fer)
        rm(path; force=true)
        CC.dispose(I)
    end
end

@testset "HeaderSearch module map: load, lookup, collect, owner" begin
    # Loading a module map registers a FileID with the interpreter's SourceManager and mutates
    # its ModuleMap, so the interpreter is a throwaway.
    I = CC.create_interpreter()
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(CC.get_instance(I)))
    fm = CC.getFileMgr(hs)

    dir = mktempdir()
    hdr = joinpath(dir, "ccprobe.h")
    textual = joinpath(dir, "cctextual.h")
    unclaimed = joinpath(dir, "ccunclaimed.h")
    mapfile = joinpath(dir, "module.modulemap")
    write(hdr, "int ccprobe;\n")
    write(textual, "int cctextual;\n")
    write(unclaimed, "int ccunclaimed;\n")
    write(mapfile,
          "module CCProbe {\n  header \"ccprobe.h\"\n  export *\n}\n" *
          "module CCTextual {\n  private textual header \"cctextual.h\"\n}\n")

    mapref = CC.getFileRef(fm, mapfile)
    hdrref = CC.getFileRef(fm, hdr)
    textualref = CC.getFileRef(fm, textual)
    unclaimedref = CC.getFileRef(fm, unclaimed)

    try
        # Nothing knows these modules before the map is read.
        @test CC.lookupModule(hs, "CCProbe").ptr == C_NULL
        before = Int(CC.getNumAllModules(hs))

        # false means SUCCESS -- clang's polarity is inverted, and this is the whole reason
        # the rest of this testset can assert anything.
        @test CC.loadModuleMapFile(hs, mapref, false) == false

        # Borrowed from the search's module map: never disposed anywhere in this testset.
        mod = CC.lookupModule(hs, "CCProbe")
        @test mod.ptr != C_NULL
        @test CC.getName(mod) == "CCProbe"
        @test CC.getFullModuleName(mod) == "CCProbe"
        @test CC.getTopLevelModule(mod).ptr == mod.ptr

        # A name the map does not declare stays absent, so the hit above is not vacuous.
        @test CC.lookupModule(hs, "CCProbeNoSuchModule").ptr == C_NULL

        # The enumeration sees exactly the two modules the load added, and the count call and
        # the fill call agree.
        mods = CC.collectAllModules(hs)
        @test length(mods) == Int(CC.getNumAllModules(hs))
        @test length(mods) == before + 2
        @test !any(m -> m.ptr == C_NULL, mods)
        names = [CC.getName(m) for m in mods]
        @test "CCProbe" in names
        @test "CCTextual" in names

        # Parsing the map marked the claimed header's record through the very function wrapped
        # above, so the two halves agree.
        hfi = CC.getExistingFileInfo(hs, hdrref)
        @test hfi.ptr != C_NULL
        @test CC.getIsModuleHeader(hfi) == true
        @test CC.getIsCompilingModuleHeader(hfi) == false
        dispose(hfi)

        # The claimed header: the single best answer and the full resolved set agree, and the
        # role is the plain modular one a bare `header` line spells.
        @test Int(CC.getNumResolvedModulesForHeader(hs, hdrref)) == 1
        rmod, rrole = CC.getResolvedModuleForHeader(hs, hdrref, 0)
        @test rmod.ptr == mod.ptr
        @test rrole == UInt32(CC.CXModuleHeaderRole_NormalHeader)
        @test CC.isModular(rrole)
        @test !CC.isTextualHeaderRole(rrole)

        fmod, frole = CC.findModuleForHeader(hs, hdrref)
        @test fmod.ptr == mod.ptr
        @test frole == rrole

        # `private textual header` is clang itself producing a COMBINED role -- the value that
        # would print as an invalid enumerator had this crossed as an @enum instead of a mask.
        tmod = CC.lookupModule(hs, "CCTextual")
        @test tmod.ptr != C_NULL
        @test Int(CC.getNumResolvedModulesForHeader(hs, textualref)) == 1
        tresolved, trole = CC.getResolvedModuleForHeader(hs, textualref, 0)
        @test tresolved.ptr == tmod.ptr
        @test trole == (UInt32(CC.CXModuleHeaderRole_PrivateHeader) | UInt32(CC.CXModuleHeaderRole_TextualHeader))
        @test CC.isPrivateHeaderRole(trole)
        @test CC.isTextualHeaderRole(trole)
        @test !CC.isModular(trole)

        # allow_textual is what decides whether findModuleForHeader will own up to a textual
        # header at all; the resolved-set enumerator never filters.
        dmod, drole = CC.findModuleForHeader(hs, textualref)
        @test dmod.ptr == C_NULL
        @test drole == UInt32(0)
        amod, arole = CC.findModuleForHeader(hs, textualref; allow_textual=true)
        @test amod.ptr == tmod.ptr
        @test arole == trole

        # A header beside them that the map never mentions is owned by nothing, and the role is
        # then clang's default-constructed zero rather than a stale value.
        @test Int(CC.getNumResolvedModulesForHeader(hs, unclaimedref)) == 0
        umod, urole = CC.findModuleForHeader(hs, unclaimedref)
        @test umod.ptr == C_NULL
        @test urole == UInt32(0)
    finally
        dispose(mapref)
        dispose(hdrref)
        dispose(textualref)
        dispose(unclaimedref)
        # Dispose BEFORE removing the directory. The interpreter owns the FileManager, which
        # keeps these headers open; POSIX unlinks an open file happily but Windows refuses,
        # and `force=true` covers "not found", not "in use".
        CC.dispose(I)
        rm(dir; recursive=true, force=true)
    end
end
