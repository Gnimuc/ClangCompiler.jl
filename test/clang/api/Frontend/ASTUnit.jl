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

    # ASTUnit::create leaves this at its default; only the LoadFrom* entry points set it
    @test CC.getOnlyLocalDecls(au) == false

    owns = CC.getOwnsRemappedFileBuffers(au)
    @test owns isa Bool
    @test CC.setOwnsRemappedFileBuffers(au, !owns) === nothing
    @test CC.getOwnsRemappedFileBuffers(au) == !owns
    CC.setOwnsRemappedFileBuffers(au, owns)

    # No frontend input and no main file registered, so both names come back empty.
    @test isempty(CC.getMainFileName(au))
    @test isempty(CC.getOriginalSourceFileName(au))

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
    fd = CC.FunctionDecl(get_decl(f))
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
    # short-circuit to false. That agreement is why they cannot be told apart here --
    # the parsed unit in the load testset is where one is true and the other is not.
    @test CC.isInMainFileID(au, loc) == false
    @test CC.isInPreambleFileID(au, loc) == false
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

    # The unsafe-to-free bit is a bit-field with no in-class initializer, so reading it
    # before anything writes it reads uninitialized memory. Only the values the test
    # itself wrote are asserted; the initial read is not one, and asserting its shape
    # would only make an unanswerable question look answered.
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
    # the initial read is the same uninitialized bit-field case as above, so the round
    # trip starts at the write
    @test CC.setCurrentTopLevelHashValue(au, 0x1234) === nothing
    @test CC.getCurrentTopLevelHashValue(au) == 0x1234

    # Nothing has built a preamble and nothing has cached completion results.
    @test Int(CC.getPreambleCounterForTests(au)) == 0
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
    # clang names it, not the host, and creating a timer does not start it
    @test CC.getFrontendTimerName(ci) == "frontend"
    @test CC.isFrontendTimerRunning(ci) == false

    dispose(I)
end

@testset "Coverage | ASTUnit parse entry point and AST serialization" begin
    mktempdir() do dir
        src = joinpath(dir, "astunit_load.cpp")
        write(src, """
              int astunit_loaded_fn(int a) { return a + 2; }
              struct astunit_loaded_type { int m; };
              """)

        # LoadFromCompilerInvocation adopts the invocation on the success path *and* on the
        # failure path, so no invocation built here is ever disposed. `diag` and `fm` are
        # only pinned with a Retain, so both stay ours -- and both must outlive every unit
        # built from them, which is why they are disposed last.
        diag = CC.DiagnosticsEngine()
        fm = CC.FileManager()
        inv = CC.createFromCommandLine(src, CC.get_default_args(), diag)

        au = CC.LoadFromCompilerInvocation(inv, diag, fm)
        @test au !== nothing

        # Everything a unit from ASTUnit::create leaves empty is filled in here, which is
        # the whole point of this entry point: this unit has actually parsed. The three
        # objects are one parse's and not three unrelated ones -- the Sema sits over the
        # unit's own context and preprocessor, and that preprocessor reads the unit's own
        # source manager.
        @test CC.hasSema(au)
        @test CC.hasPreprocessor(au)
        sema = CC.getSema(au)
        @test CC.getASTContext(sema).ptr == CC.getASTContext(au).ptr
        @test CC.getPreprocessor(sema).ptr == CC.getPreprocessor(au).ptr
        @test CC.getSourceManager(CC.getPreprocessor(au)).ptr == CC.getSourceManager(au).ptr
        @test CC.isMainFileAST(au) == false
        @test basename(CC.getMainFileName(au)) == "astunit_load.cpp"
        @test basename(CC.getOriginalSourceFileName(au)) == "astunit_load.cpp"

        # A unit that parsed has a main file ID, which is what separates the two region
        # predicates: on the never-parsed unit both short-circuit to false and a shim
        # answering either question with the other's result passes. Here they differ --
        # no preamble was built, so a location in the main file is in one and not the other.
        main_start = CC.getStartOfMainFileID(au)
        @test CC.isValid(main_start)
        @test CC.isInMainFileID(au, main_start) == true
        @test CC.isInPreambleFileID(au, main_start) == false

        # The top-level list is this file's and not another unit's: both declarations the
        # source writes are in it, under the kind names clang gave them.
        n = Int(CC.top_level_size(au))
        @test n >= 2
        kinds = [CC.getDeclKindName(CC.getTopLevelDecl(au, i)) for i = 0:(n - 1)]
        @test "Function" in kinds
        @test "CXXRecord" in kinds

        # The kind clang reported establishes each carrier's class, so the same handles
        # read back as NamedDecls: the list holds this source's declarations, under the
        # names it wrote them with, and not the same slot twice.
        top_names = String[]
        for i = 0:(n - 1)
            d = CC.getTopLevelDecl(au, i)
            CC.getDeclKindName(d) in ("Function", "CXXRecord") || continue
            push!(top_names, CC.getNameAsString(CC.NamedDecl(d)))
        end
        @test "astunit_loaded_fn" in top_names
        @test "astunit_loaded_type" in top_names

        # ... and the unit's own AST context holds them under the source's own names.
        tu = CC.getTranslationUnitDecl(CC.getASTContext(au))
        names = [CC.getNameAsString(d)
                 for d in CC.decls(CC.castToDeclContext(tu)) if d isa CC.AbstractNamedDecl]
        @test "astunit_loaded_fn" in names
        @test "astunit_loaded_type" in names

        # A parsed unit serializes. `false` is the SUCCESS return -- clang's polarity, and
        # the trap this wrapper exists to document.
        out = joinpath(dir, "astunit_loaded.ast")
        @test CC.Save(au, out) == false
        @test isfile(out)
        # a clang AST file opens with the four-byte 'CPCH' magic
        @test open(io -> read(io, 4), out) == b"CPCH"
        # a serialized translation unit carries far more than the source it came from, so
        # a truncated or magic-only write is caught rather than passing on the magic alone
        @test filesize(out) > filesize(src)
        # llvm::writeToOutput renames its temporary into place; nothing is left beside it
        @test !any(startswith("astunit_loaded.ast.temp-stream-"), readdir(dir))

        # The inverted polarity is observable rather than merely documented: a destination
        # whose parent directory does not exist comes back as `true`, not as an exception.
        @test CC.Save(au, joinpath(dir, "no_such_dir", "out.ast")) == true

        # Serialization asserts inside ASTUnit::getSema, so a unit that never parsed is
        # refused by the wrapper before it gets there -- and nothing is written.
        never = joinpath(dir, "never_written.ast")
        empty_unit = CC.ASTUnit(CC.CompilerInvocation(), diag)  # adopts the invocation
        @test CC.hasSema(empty_unit) == false
        @test_throws AssertionError CC.Save(empty_unit, never)
        @test !ispath(never)
        CC.dispose(empty_unit)

        # The nullptr return: the invocation still names the file, but it is gone by the
        # time the parse opens it, so the unit is destroyed inside the shim (taking the
        # adopted invocation with it) and `nothing` comes back.
        gone = joinpath(dir, "astunit_gone.cpp")
        write(gone, "int astunit_gone_v = 1;\n")
        inv_gone = CC.createFromCommandLine(gone, CC.get_default_args(), diag)
        rm(gone)
        failed = redirect_stdio(; stderr=devnull) do
            CC.LoadFromCompilerInvocation(inv_gone, diag, fm)
        end
        @test failed === nothing

        CC.dispose(au)
        CC.dispose(fm)
        CC.dispose(diag)
    end
end
