using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "option object lifecycles" begin
    cgo = CC.CodeGenOptions()
    @test cgo.ptr != C_NULL
    dispose(cgo)

    tgo = CC.TargetOptions()
    CC.setTriple(tgo, "x86_64-unknown-linux-gnu")
    dispose(tgo)

    dgo = CC.DiagnosticOptions()
    CC.setShowColors(dgo, false)
    dispose(dgo)

    ids = CC.DiagnosticIDs()
    @test ids.ptr != C_NULL
    dispose(ids)

    inv = CC.CompilerInvocation(CC.LibClangEx.clang_CompilerInvocation_create())
    @test inv.ptr != C_NULL
    dispose(inv)
end

@testset "createFromCommandLine" begin
    src = normpath(joinpath(@__DIR__, "..", "..", "..", "cxx", "main.cpp"))
    diag = CC.DiagnosticsEngine()
    invok = CC.createFromCommandLine(src, ["-std=c++17", "-O2"], diag)
    @test invok.ptr != C_NULL
    @test CC.hasLangStandard(CC.getLangOpts(invok))

    # CodeGenOptions::CommandLineArgs holds the cc1 line the driver produced
    cgo = CC.getCodeGenOpts(invok)
    args = CC.getCommandLineArgs(cgo)
    @test "-cc1" in args
    @test "-O2" in args
    @test any(endswith("main.cpp"), args)
    @test length(args) == CC.LibClangEx.clang_CodeGenOptions_getCommandLineArgsNum(cgo)

    # FrontendOptions::ModulesEmbedFiles: exact count + fill
    feo = CC.getFrontendOpts(invok)
    @test CC.getModulesEmbedFilesNum(feo) == 0
    @test CC.getModulesEmbedFiles(feo) == String[]

    dispose(invok)
    dispose(diag)
end

@testset "coverage tail: CompilerInstance pipeline" begin
    # A donor interpreter lends its ASTConsumer to the standalone pipeline
    # instance below (there is no consumer factory in the C API). The
    # donation double-owns the consumer, so exactly one owner may be
    # destroyed: the interpreter is disposed normally at the end, and `ci`
    # — which also hosts the adopting setSema/setPreprocessor round-trips,
    # each of which frees the previous owner's object — is intentionally
    # leaked, so nothing it aliases is ever freed a second time.
    SI = create_interpreter(String[])
    CC.parse(SI, "int cefp_donor = 7;")
    sci = CC.get_instance(SI)

    mktempdir() do dir
        src = joinpath(dir, "cefp_main.cpp")
        write(src, "int cefp_global = 42;\n")

        # CompilerInvocation: default create + option getters
        inv0 = CC.CompilerInvocation()
        @test inv0.ptr != C_NULL
        @test CC.getDiagnosticOpts(inv0).ptr != C_NULL
        @test CC.getHeaderSearchOpts(inv0).ptr != C_NULL
        @test CC.getPreprocessorOpts(inv0).ptr != C_NULL
        @test CC.getTargetOpts(inv0).ptr != C_NULL
        dispose(inv0)

        ci = CC.CompilerInstance()
        @test (CC.setShowPresumedLoc(ci, true); true)
        CC.setShowColors(ci, false)
        CC.createDiagnostics(ci)
        @test CC.hasDiagnostics(ci)
        diag = CC.getDiagnostics(ci)

        invok = CC.createFromCommandLine(src, ["-nostdinc", "-nostdlib"], diag)
        CC.setInvocation(ci, invok)  # adopted by the instance — no dispose
        CC.setTargetAndLangOpts(ci)
        @test CC.hasTarget(ci)

        CC.createFileManager(ci)
        CC.createSourceManager(ci)

        # ref-counted setter round-trips: hand the instance back its own
        # engine/managers (retain-then-release, net refcount unchanged)
        @test (CC.setDiagnostics(ci, CC.getDiagnostics(ci)); CC.hasDiagnostics(ci))
        @test (CC.setFileManager(ci, CC.getFileManager(ci)); CC.hasFileManager(ci))
        @test (CC.setSourceManager(ci, CC.getSourceManager(ci)); CC.hasSourceManager(ci))

        # FileEntry: UID of a real on-disk file (no open handle — Windows
        # must be able to delete the temp dir afterwards)
        fe = CC.getFileEntry(CC.getFileManager(ci), src)
        @test fe.ptr != C_NULL
        @test CC.getUID(fe) >= 0

        # SourceManager: buffer-backed main file + start/end locations
        src_mgr = CC.getSourceManager(ci)
        CC.setMainFileID(src_mgr, CC.get_buffer("int cefp_buf = 1;\n"))
        fid = CC.getMainFileID(src_mgr)
        @test fid.ptr != C_NULL
        locb = CC.getLocForStartOfFile(src_mgr, fid)
        loce = CC.getLocForEndOfFile(src_mgr, fid)
        @test CC.isValid(locb)
        @test CC.isValid(loce)
        dispose(fid)

        # HeaderSearchOptions: resource-dir round-trip through the byte API
        hso = CC.getHeaderSearchOpts(ci)
        CC.SetResourceDir(hso, "/cefp-resource")
        buf = String(fill(UInt8('x'), ncodeunits("/cefp-resource")))
        CC.GetResourceDir(hso, buf)
        @test buf == "/cefp-resource"

        # CodeGenOptions: Argv0 recorded by the command-line invocation
        cgo = CC.getCodeGenOpts(ci)
        @test cgo.ptr != C_NULL
        @test CC.getArgv0(cgo) isa String  # shape-only: host-decided executable path

        # Preprocessor: builtin identifiers + entering the main file
        CC.createPreprocessor(ci)
        pp = CC.getPreprocessor(ci)
        @test (CC.InitializeBuiltins(pp); true)
        @test (CC.EnterMainSourceFile(pp); true)

        CC.createASTContext(ci)
        @test (CC.setASTContext(ci, CC.getASTContext(ci)); CC.hasASTContext(ci))

        # ASTConsumer donation from the donor interpreter unblocks
        # createSema on this instance
        @test (CC.setASTConsumer(ci, CC.getASTConsumer(sci)); CC.hasASTConsumer(ci))

        # takeASTConsumer undoes that adoption: the same object comes back and the instance
        # is left with none, which is what lets `ci` be dropped without freeing a consumer
        # the donor interpreter still owns. Re-install it so createSema below still works.
        donated = CC.getASTConsumer(sci)
        taken = CC.takeASTConsumer(ci)
        @test taken.ptr == donated.ptr
        @test !CC.hasASTConsumer(ci)
        @test_throws AssertionError CC.takeASTConsumer(ci)
        @test (CC.setASTConsumer(ci, taken); CC.hasASTConsumer(ci))

        @test (CC.createSema(ci); CC.hasSema(ci))

        # Parser: first (and only) parser over this fresh preprocessor —
        # create, prime with the entered main-file buffer, dispose (which
        # detaches its pragma handlers from the preprocessor again)
        p2 = CC.Parser(pp, CC.getSema(ci), false)
        @test p2.ptr != C_NULL
        @test (CC.Initialize(p2); true)
        @test CC.getCurToken(p2).ptr != C_NULL
        dispose(p2)

        # adopting-setter round-trips, canonical teardown order: each one
        # frees the instance's previous component and leaves a dangling
        # adoption behind — `ci` must never be disposed after this
        @test (CC.setSema(ci, CC.getSema(ci)); true)
        @test (CC.setPreprocessor(ci, CC.getPreprocessor(ci)); true)
        # ci is intentionally leaked (see the note above)
    end

    dispose(SI)
end

@testset "coverage tail: ExecuteAction" begin
    CC.LLVM.InitializeNativeTarget()
    CC.LLVM.InitializeAllTargetInfos()
    CC.LLVM.InitializeAllTargetMCs()
    CC.LLVM.InitializeNativeAsmPrinter()
    mktempdir() do dir
        src = joinpath(dir, "cefp_act.cpp")
        write(src, "int cefp_act_fn(int x) { return x + 1; }\n")
        ci = CC.CompilerInstance()
        CC.setShowColors(ci, false)
        CC.createDiagnostics(ci)
        diag = CC.getDiagnostics(ci)
        invok = CC.createFromCommandLine(src, ["-nostdinc", "-nostdlib"], diag)
        CC.setInvocation(ci, invok)  # adopted
        lctx = CC.LLVM.Context()
        act = CC.LLVMOnlyAction(lctx)
        ok = CC.ExecuteAction(ci, act)
        @test ok === true
        dispose(ci)
        dispose(act)
        CC.LLVM.dispose(lctx)
    end
end

@testset "frontend tail: option views, module and output-file queries" begin
    # CompilerInvocation option accessors return borrowed interior views; only the
    # invocation itself is disposed.
    inv = CC.CompilerInvocation()
    @test inv.ptr != C_NULL
    @test CC.getLangOpts(inv).ptr != C_NULL
    @test CC.getAnalyzerOpts(inv).ptr != C_NULL
    @test CC.getMigratorOpts(inv).ptr != C_NULL
    @test CC.getFileSystemOpts(inv).ptr != C_NULL
    @test CC.getDependencyOutputOpts(inv).ptr != C_NULL
    @test CC.getPreprocessorOutputOpts(inv).ptr != C_NULL

    mod_hash = CC.getModuleHash(inv)
    @test !isempty(mod_hash)
    CC.dispose(inv)

    # A default-constructed CompilerInstance already owns an invocation, so the
    # forwarding accessors' precondition holds.
    ci = CC.CompilerInstance()
    @test CC.hasInvocation(ci)
    @test CC.getAnalyzerOpts(ci).ptr != C_NULL
    @test CC.getDependencyOutputOpts(ci).ptr != C_NULL
    @test CC.getFileSystemOpts(ci).ptr != C_NULL
    @test CC.getPreprocessorOutputOpts(ci).ptr != C_NULL

    @test CC.shouldBuildGlobalModuleIndex(ci) == false
    CC.setBuildGlobalModuleIndex(ci, true)
    @test CC.shouldBuildGlobalModuleIndex(ci) == true
    CC.setBuildGlobalModuleIndex(ci, false)
    @test CC.shouldBuildGlobalModuleIndex(ci) == false
    @test CC.hadModuleLoaderFatalFailure(ci) == false

    # no module cache path is configured on a fresh instance
    @test CC.getSpecificModuleCachePath(ci) == ""

    @test CC.hasCodeCompletionConsumer(ci) == false
    @test CC.getAuxTarget(ci).ptr == C_NULL
    @test CC.clearOutputFiles(ci, false) === nothing
    CC.dispose(ci)
end

@testset "cc1 command lines, the resources path and the copy-on-write invocation" begin
    # A default-constructed invocation already owns every option object, so the option
    # views are safe on it — but it has selected no language standard, and generating a
    # cc1 line reaches getLangStandardForKind, which report_fatal_errors on that.
    inv = CC.CompilerInvocation()
    @test CC.getAPINotesOpts(inv).ptr != C_NULL
    @test CC.hasLangStandard(CC.getLangOpts(inv)) == false
    @test_throws AssertionError CC.getCC1CommandLine(inv)

    # Filling one from an argument list does select a standard, and the line it then
    # generates parses back and survives the round-trip check. Both results are
    # host-decided (the default triple differs per runner), so only shape is asserted.
    args = ["-x", "c++", "-std=c++17", "cc1_probe.cpp"]
    diag = CC.DiagnosticsEngine()
    inv2 = CC.CompilerInvocation()
    @test CC.CreateFromArgs(inv2, args, diag) === true
    @test CC.hasLangStandard(CC.getLangOpts(inv2))
    line = CC.getCC1CommandLine(inv2)
    @test !isempty(line)
    @test "-std=c++17" in line
    @test "-cc1" in line
    @test CC.checkCC1RoundTrip(args, diag) == false

    # Pure path arithmetic over the located executable — nothing on disk is touched,
    # and the path itself is the runner's julia binary.
    @test !isempty(CC.GetResourcesPath("clang", C_NULL))
    @test occursin("clang", CC.GetResourcesPath("clang", C_NULL))

    # The instance forwards to the invocation it already owns.
    ci = CC.CompilerInstance()
    @test CC.hasInvocation(ci)
    @test CC.getAPINotesOpts(ci).ptr != C_NULL
    dispose(ci)

    # CowCompilerInvocation: create, every mutable option view, dispose.
    cow = CC.CowCompilerInvocation()
    @test cow.ptr != C_NULL
    @test CC.getMutLangOpts(cow).ptr != C_NULL
    @test CC.getMutTargetOpts(cow).ptr != C_NULL
    @test CC.getMutDiagnosticOpts(cow).ptr != C_NULL
    @test CC.getMutHeaderSearchOpts(cow).ptr != C_NULL
    @test CC.getMutPreprocessorOpts(cow).ptr != C_NULL
    @test CC.getMutAnalyzerOpts(cow).ptr != C_NULL
    @test CC.getMutMigratorOpts(cow).ptr != C_NULL
    @test CC.getMutAPINotesOpts(cow).ptr != C_NULL
    @test CC.getMutCodeGenOpts(cow).ptr != C_NULL
    @test CC.getMutFileSystemOpts(cow).ptr != C_NULL
    @test CC.getMutFrontendOpts(cow).ptr != C_NULL
    @test CC.getMutDependencyOutputOpts(cow).ptr != C_NULL
    @test CC.getMutPreprocessorOutputOpts(cow).ptr != C_NULL
    # a fresh Cow invocation has selected no standard either, so the same gate applies
    @test CC.hasLangStandard(CC.getLangOpts(cow)) == false
    @test_throws AssertionError CC.getCC1CommandLine(cow)
    dispose(cow)

    # The deep copy regenerates exactly the source invocation's cc1 line (a round-trip
    # of a triple this testset set itself), and the source is not adopted, so both
    # invocations still need their own dispose. inv2 is the source here because it is the
    # one that has a language standard.
    CC.setTriple(CC.getTargetOpts(inv2), "x86_64-unknown-linux-gnu")
    cow2 = CC.CowCompilerInvocation(inv2)
    @test CC.hasLangStandard(CC.getLangOpts(cow2))
    @test CC.getCC1CommandLine(cow2) == CC.getCC1CommandLine(inv2)
    dispose(cow2)

    dispose(inv2)
    dispose(inv)
    dispose(diag)
end
