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
