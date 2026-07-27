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
    @test invok isa CC.CompilerInvocation

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
        @test CC.getDiagnosticOpts(inv0) isa CC.DiagnosticOptions
        @test CC.getHeaderSearchOpts(inv0) isa CC.HeaderSearchOptions
        @test CC.getPreprocessorOpts(inv0) isa CC.PreprocessorOptions
        @test CC.getTargetOpts(inv0) isa CC.TargetOptions
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
        @test fe isa CC.FileEntry
        @test CC.getUID(fe) isa Int
        @test CC.getUID(fe) >= 0

        # SourceManager: buffer-backed main file + start/end locations
        src_mgr = CC.getSourceManager(ci)
        CC.setMainFileID(src_mgr, CC.get_buffer("int cefp_buf = 1;\n"))
        fid = CC.getMainFileID(src_mgr)
        @test fid isa CC.FileID
        locb = CC.getLocForStartOfFile(src_mgr, fid)
        loce = CC.getLocForEndOfFile(src_mgr, fid)
        @test locb isa CC.SourceLocation
        @test loce isa CC.SourceLocation
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
        @test CC.getArgv0(cgo) isa String

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
        @test (CC.createSema(ci); CC.hasSema(ci))

        # Parser: first (and only) parser over this fresh preprocessor —
        # create, prime with the entered main-file buffer, dispose (which
        # detaches its pragma handlers from the preprocessor again)
        p2 = CC.Parser(pp, CC.getSema(ci), false)
        @test p2 isa CC.Parser
        @test (CC.Initialize(p2); true)
        @test CC.getCurToken(p2) isa CC.Token
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
        @test ok isa Bool
        @test ok
        dispose(ci)
        dispose(act)
        CC.LLVM.dispose(lctx)
    end
end
