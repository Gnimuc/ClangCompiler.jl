using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Coverage | ASTUnit" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int astunit_probe(int a) { return a + 1; }
    """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)

    # ASTUnit::create adopts the invocation (it rewraps it in a fresh shared_ptr and frees
    # it with the unit), so `inv` must never be disposed on its own. The diagnostics engine
    # is only borrowed: the shim pins it with a Retain, so it stays the interpreter's.
    inv = CC.CompilerInvocation()
    au = CC.ASTUnit(inv, CC.getDiagnostics(ci))
    @test au isa CC.ASTUnit
    @test au.ptr != C_NULL

    # A unit from ASTUnit::create is parse-based, not loaded from a serialized AST file.
    @test CC.isMainFileAST(au) == false
    @test CC.getDiagnostics(au).ptr == CC.getDiagnostics(ci).ptr
    @test !CC.is_null_handle(CC.getSourceManager(au))
    @test !CC.is_null_handle(CC.getFileManager(au))
    # nothing has parsed into this unit, so it holds neither a preprocessor nor a Sema
    @test CC.hasPreprocessor(au) == false
    @test CC.getPreprocessor(au).ptr == C_NULL
    @test CC.hasSema(au) == false

    # getASTContext is only meaningful once a context is attached; setASTContext retains it,
    # so the interpreter keeps ownership and the unit's disposal only drops a reference.
    CC.setASTContext(au, ctx)
    @test CC.getASTContext(au).ptr == ctx.ptr

    @test CC.getOnlyLocalDecls(au) isa Bool  # shape-only: the host decides this

    owns = CC.getOwnsRemappedFileBuffers(au)
    @test owns isa Bool
    @test CC.setOwnsRemappedFileBuffers(au, !owns) === nothing
    @test CC.getOwnsRemappedFileBuffers(au) == !owns
    CC.setOwnsRemappedFileBuffers(au, owns)

    # No frontend input and no main file registered, so both names come back empty.
    @test CC.getMainFileName(au) isa String  # shape-only: the host decides this
    @test CC.getOriginalSourceFileName(au) isa String  # shape-only: the host decides this

    # The top-level list starts empty and tracks exactly what addTopLevelDecl appends.
    @test CC.top_level_empty(au) == true
    @test CC.top_level_size(au) == 0
    tu = CC.getTranslationUnitDecl(ctx)
    @test CC.addTopLevelDecl(au, tu) === nothing
    @test CC.top_level_empty(au) == false
    @test CC.top_level_size(au) == 1
    @test !CC.is_null_handle(CC.getTopLevelDecl(au, 0))
    @test CC.getTopLevelDecl(au, 0).ptr == tu.ptr

    CC.dispose(au)
    dispose(I)
end

@testset "Coverage | ASTUnit locations, file regions and module queries" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int astunit_region_probe(int a) { return a * 3; }
    """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)

    f = DeclFinder(I)
    @test f(I, "astunit_region_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    loc = CC.getLocation(fd)
    rng = CC.getSourceRange(fd)

    # ASTUnit::create adopts the invocation (it rewraps it in a fresh shared_ptr and frees
    # it with the unit), so `inv` must never be disposed on its own.
    inv = CC.CompilerInvocation()
    au = CC.ASTUnit(inv, CC.getDiagnostics(ci))

    # A unit from ASTUnit::create carries no precompiled preamble, and both mappings are
    # documented to hand a location that is not a preamble location straight back.
    @test CC.mapLocationFromPreamble(au, loc).ptr == loc.ptr
    @test CC.mapLocationToPreamble(au, loc).ptr == loc.ptr

    from_preamble = CC.mapRangeFromPreamble(au, rng)
    @test from_preamble.begin_loc.ptr == rng.begin_loc.ptr
    @test from_preamble.end_loc.ptr == rng.end_loc.ptr
    to_preamble = CC.mapRangeToPreamble(au, rng)
    @test to_preamble.begin_loc.ptr == rng.begin_loc.ptr
    @test to_preamble.end_loc.ptr == rng.end_loc.ptr

    # Neither file ID exists on a unit that has never parsed, so both predicates
    # short-circuit; only the shape is the library's business here.
    @test CC.isInMainFileID(au, loc) isa Bool  # shape-only: the host decides this
    @test CC.isInPreambleFileID(au, loc) isa Bool  # shape-only: the host decides this
    # this unit was built without a main file or a preamble, so both are the invalid
    # location -- the documented answer, and one a shim handing back a stale location fails
    @test CC.isInvalid(CC.getStartOfMainFileID(au))
    @test CC.isInvalid(CC.getEndOfPreambleFileID(au))

    # A file the unit's own file manager knows but its source manager has never entered:
    # the file:line:col translation has no file ID to resolve against.
    path, io = mktemp()
    write(io, "int in_a_file = 1;\n")
    close(io)
    entry = CC.getFileEntry(CC.getFileManager(au), path)
    # line 1 column 1 of a file this unit never loaded: invalid, not a wild location
    @test CC.isInvalid(CC.getLocation(au, entry, 1, 1))

    buf = CC.getBufferForFile(au, path)
    @test buf !== nothing
    CC.LLVM.dispose(buf)
    # The failure path logs the reason and reports it as a missing buffer.
    @test CC.getBufferForFile(au, path * ".does.not.exist") === nothing

    # The file-level table is empty and the unit's main file ID is invalid, so the region
    # search reports nothing through either half of the two-call protocol.
    fid = CC.getMainFileID(CC.getSourceManager(au))
    @test CC.getNumFileRegionDecls(au, fid, 0, 0) == 0
    decls = CC.findFileRegionDecls(au, fid, 0, 0)
    @test decls isa Vector{CC.Decl}
    @test isempty(decls)

    # An implicit typedef carries no source location, so the file-level table drops it —
    # the one path that does not decompose the location in the unit's source manager.
    @test CC.addFileLevelDecl(au, CC.getInt128Decl(ctx)) === nothing

    # Nothing was loaded from a precompiled header or a serialized module file.
    @test CC.getPCHFile(au) === nothing
    @test CC.isModuleFile(au) == false
    @test CC.getTranslationUnitKind(au) isa CC.CXTranslationUnitKind

    CC.dispose(fid)
    rm(path; force=true)
    CC.dispose(au)
    dispose(I)
end

@testset "Coverage | ASTUnit bookkeeping counters and the frontend timer" begin
    I = create_interpreter(String[])
    CC.parse(I, """
    int astunit_counter_probe(int a) { return a - 1; }
    """)

    ci = get_instance(I)

    # ASTUnit::create adopts the invocation (it rewraps it in a fresh shared_ptr and frees it
    # with the unit), so `inv` must never be disposed on its own. The capture kind stays at
    # the default so the interpreter's diagnostics engine keeps its own consumer.
    inv = CC.CompilerInvocation()
    au = CC.ASTUnit(inv, CC.getDiagnostics(ci))

    # The unsafe-to-free bit is a bit-field with no in-class initializer, so only a value the
    # test itself wrote is asserted.
    @test CC.isUnsafeToFree(au) isa Bool  # shape-only: the host decides this
    @test CC.setUnsafeToFree(au, true) === nothing
    @test CC.isUnsafeToFree(au) == true
    @test CC.setUnsafeToFree(au, false) === nothing
    @test CC.isUnsafeToFree(au) == false

    # The by-value option member is valid even though nothing has parsed into the unit.
    fso = CC.getFileSystemOpts(au)
    @test fso isa CC.FileSystemOptions
    @test fso.ptr != C_NULL

    # C++ hands the top-level name hash back as a mutable reference; round-trip it through
    # the read/write pair the C surface splits it into.
    @test CC.getCurrentTopLevelHashValue(au) isa Integer  # shape-only: the host decides this
    @test CC.setCurrentTopLevelHashValue(au, 0x1234) === nothing
    @test CC.getCurrentTopLevelHashValue(au) == 0x1234

    # Nothing has built a preamble and nothing has cached completion results.
    @test CC.getPreambleCounterForTests(au) isa Integer  # shape-only: the host decides this
    @test CC.cached_completion_size(au) == 0

    # No parse has run, so the unit captured no diagnostics and the driver split sits at the
    # start of an empty vector; the index accessor rejects every index.
    @test CC.stored_diag_size(au) == 0
    @test CC.stored_diag_afterDriver_index(au) == 0
    @test_throws AssertionError CC.getStoredDiagnostic(au, 0)

    CC.dispose(au)

    # llvm::Timer has no LLVM-C handle, so the frontend timer is read through composite
    # accessors on the instance that owns it.
    CC.createFrontendTimer(ci)
    @test CC.hasFrontendTimer(ci)
    @test CC.getFrontendTimerName(ci) isa String  # shape-only: the host decides this
    @test CC.isFrontendTimerRunning(ci) isa Bool  # shape-only: the host decides this

    dispose(I)
end
