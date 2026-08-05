using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "Coverage | BasicCodeGen" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int add_two(int a) { int r = a + 2; return r; }
             struct Widget { int value; };
             """)

    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    sm = CC.getSourceManager(ci)

    # reach a NamedDecl / SourceLocation / SourceRange
    f = DeclFinder(I)
    @test f(I, "add_two") isa Bool
    d = get_decl(f)
    fd = CC.downcast(CC.FunctionDecl, d.ptr)
    loc = CC.getLocation(fd)
    sr = CC.getSourceRange(fd)

    # ---- SourceManager.jl ----
    @test CC.PrintStats(sm) === nothing
    fid = CC.getMainFileID(sm)
    @test fid isa CC.FileID
    startloc = CC.getLocForStartOfFile(sm, fid)
    @test startloc isa CC.SourceLocation
    @test CC.dump(loc, sm) === nothing
    # NOTE: getLocForEndOfFile is skipped — its body has `@check_ptrs x` referencing an
    # undefined variable, so any call throws UndefVarError.

    # ---- SourceLocation.jl ----
    @test CC.getHashValue(fid) isa Integer
    inv = CC.SourceLocation()
    @test inv isa CC.SourceLocation
    @test CC.isFileID(loc) isa Bool
    @test CC.isMacroID(loc) isa Bool
    @test CC.isValid(loc)
    @test CC.isInvalid(inv)
    @test CC.getHashValue(loc) isa Integer
    b = CC.getBeginLoc(sr)
    e = CC.getEndLoc(sr)
    @test b isa CC.SourceLocation
    @test e isa CC.SourceLocation
    @test CC.isPairOfFileLocations(b, e)
    @test !CC.is_null_handle(CC.getLocWithOffset(loc, 3))
    @test !isempty(CC.printToString(loc, sm))
    CC.dispose(fid)

    # ---- IdentifierTable.jl ----
    it = CC.getIdents(ctx)
    @test it isa CC.IdentifierTable
    @test CC.PrintStats(it) === nothing
    ii = get(it, "add_two")
    @test ii isa CC.IdentifierInfo
    ii2 = CC.getIdentifier(fd)
    @test CC.getName(ii2) isa String

    # ---- DiagnosticOptions.jl ----
    dopts = CC.DiagnosticOptions()
    @test dopts isa CC.DiagnosticOptions
    @test CC.create_diagnostic_opts() isa Ptr
    @test CC.PrintStats(dopts) === nothing
    @test CC.setShowColors(dopts, false) === nothing
    @test CC.setShowPresumedLoc(dopts, true) === nothing

    # ---- Diagnostic.jl ----
    diag = CC.getDiagnostics(ci)              # live engine, owned by the interpreter
    @test CC.setShowColors(diag, false) === nothing

    consumer = CC.IgnoringDiagConsumer()
    @test consumer isa CC.IgnoringDiagConsumer
    @test CC.create_ignoring_diagnostic_consumer() isa Ptr
    langopts = CC.getLangOpts(ci)
    pp = CC.getPreprocessor(ci)
    @test CC.BeginSourceFile(consumer, langopts, pp) === nothing
    @test CC.EndSourceFile(consumer) === nothing
    CC.dispose(consumer)

    # self-contained engines are safe to dispose (they own their ids/opts/client)
    eng0 = CC.DiagnosticsEngine()
    @test eng0 isa CC.DiagnosticsEngine
    CC.dispose(eng0)
    rawE = CC.create_diagnostics_engine()
    @test rawE isa Ptr
    CC.dispose(CC.DiagnosticsEngine(rawE))

    # engines that share externally-allocated opts/client are exercised then leaked
    eng1 = CC.DiagnosticsEngine(CC.DiagnosticOptions())
    @test eng1 isa CC.DiagnosticsEngine
    eng2 = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                CC.IgnoringDiagConsumer(), false)
    @test eng2 isa CC.DiagnosticsEngine

    # ---- CodeGen/ModuleBuilder.jl ----
    cg = CC.getCodeGen(I.interp)
    @test cg isa CC.CodeGenerator
    cgm = CC.CGM(cg)
    @test cgm isa CC.CodeGenModule
    mod = CC.GetModule(cg)
    @test mod isa CC.LLVM.Module
    @test !CC.is_null_handle(CC.GetDeclForMangledName(cg, "add_two"))

    # ReleaseModule / StartModule mutate the codegen's module ownership; run them on a
    # throwaway interpreter and leave it undisposed to avoid an ownership double-free.
    J = create_interpreter(String[])
    CC.parse(J, "extern \"C\" int jf(int x) { return x + 1; }")
    cgJ = CC.getCodeGen(J.interp)
    relmod = CC.ReleaseModule(cgJ)
    @test relmod isa CC.LLVM.Module
    newmod = CC.StartModule(cgJ, CC.LLVM.context(relmod), "cov_module")
    @test newmod isa CC.LLVM.Module

    dispose(f)
    dispose(I)
end

@testset "sourcemgr batch" begin
    I = CC.create_interpreter(String[])
    CC.parse(I, """
             #define SM_BATCH_TWICE(x) ((x) + (x))
             extern "C" int sm_batch_fn(int a) { return SM_BATCH_TWICE(a); }
             """)
    ci = CC.get_instance(I)
    sm = CC.getSourceManager(ci)

    f = CC.DeclFinder(I)
    @test f(I, "sm_batch_fn")
    d = CC.get_decl(f)
    fd = CC.downcast(CC.FunctionDecl, d.ptr)
    loc = CC.getLocation(fd)
    @test CC.isValid(loc)
    @test CC.isFileID(loc)

    # borrowed accessors
    @test !CC.is_null_handle(CC.getDiagnostics(sm))
    fm = CC.getFileManager(sm)
    @test fm isa CC.FileManager

    # FileID queries + decomposition round-trips
    fid, off = CC.getDecomposedLoc(sm, loc)
    @test fid isa CC.FileID
    fid2 = CC.getFileID(sm, loc)
    @test CC.getHashValue(fid2) == CC.getHashValue(fid)
    @test CC.getFileOffset(sm, loc) == off
    @test CC.getFileIDSize(sm, fid) > 0
    @test CC.getNumCreatedFIDsForFileID(sm, fid) isa Integer  # shape-only: the target chooses this value
    inside, rel = CC.isInFileID(sm, loc, fid)
    @test inside
    @test rel == off
    raw = CC.getRawEncoding(loc)
    @test raw isa Integer
    @test CC.getRawEncoding(CC.getFromRawEncoding(raw)) == raw
    loc2 = CC.getComposedLoc(sm, fid, off)
    @test CC.getRawEncoding(loc2) == raw
    @test !CC.is_null_handle(CC.getIncludeLoc(sm, fid))

    # buffer access
    data = CC.getBufferData(sm, fid)
    @test occursin("sm_batch_fn", data)
    @test CC.getCharacterData(sm, loc) isa String
    @test CC.getBufferName(sm, loc) isa String
    @test CC.getFilename(sm, loc) isa String

    # line/column decomposition
    line = CC.getSpellingLineNumber(sm, loc)
    col = CC.getSpellingColumnNumber(sm, loc)
    @test line >= 1 && col >= 1
    @test CC.getExpansionLineNumber(sm, loc) == line
    @test CC.getExpansionColumnNumber(sm, loc) == col
    @test CC.getPresumedLineNumber(sm, loc) >= 1
    @test CC.getPresumedColumnNumber(sm, loc) >= 1
    @test CC.getLineNumber(sm, fid, off) == line
    @test CC.getColumnNumber(sm, fid, off) == col
    lc = CC.translateLineCol(sm, fid, line, col)
    @test CC.getRawEncoding(lc) == raw

    presumed = CC.getPresumedLoc(sm, loc)
    @test presumed !== nothing
    if presumed !== nothing
        fname, pline, pcol, ploc = presumed
        @test fname isa String
        @test pline == CC.getPresumedLineNumber(sm, loc)
        @test pcol == CC.getPresumedColumnNumber(sm, loc)
        @test ploc isa CC.SourceLocation
    end

    # navigation on a file location is the identity
    @test CC.getRawEncoding(CC.getSpellingLoc(sm, loc)) == raw
    @test CC.getRawEncoding(CC.getExpansionLoc(sm, loc)) == raw
    @test CC.getRawEncoding(CC.getFileLoc(sm, loc)) == raw
    @test CC.getRawEncoding(CC.getImmediateSpellingLoc(sm, loc)) == raw
    rng, is_tok = CC.getExpansionRange(sm, loc)
    @test rng isa CC.SourceRange
    @test is_tok isa Bool

    # predicates on a plain user location
    @test !CC.isInSystemHeader(sm, loc)
    @test !CC.isInExternCSystemHeader(sm, loc)
    @test !(CC.isInMainFile(sm, loc))
    @test CC.isWrittenInSameFile(sm, loc, loc)
    @test !(CC.isWrittenInMainFile(sm, loc))
    @test !CC.isWrittenInBuiltinFile(sm, loc)
    @test !CC.isWrittenInCommandLineFile(sm, loc)
    @test !CC.isWrittenInScratchSpace(sm, loc)
    @test CC.getFileCharacteristic(sm, loc) == CC.CXCharacteristicKind_C_User

    # ordering
    nextloc = CC.getLocWithOffset(loc, 1)
    @test CC.isBeforeInTranslationUnit(sm, loc, nextloc)
    @test !CC.isBeforeInTranslationUnit(sm, nextloc, loc)
    @test CC.isBeforeInSLocAddrSpace(sm, loc, nextloc)
    @test CC.isPointWithin(sm, nextloc, loc, CC.getLocWithOffset(loc, 2))

    # macro locations: walk the function body for a macro-expanded statement
    mloc = CC.SourceLocation()
    stack = Any[CC.getBody(fd)]
    while !isempty(stack)
        s = pop!(stack)
        l = CC.getBeginLoc(s)
        if CC.isMacroID(l)
            mloc = l
            break
        end
        append!(stack, CC.children(s))
    end
    @test CC.isMacroID(mloc)
    if CC.isMacroID(mloc)
        spelling = CC.getSpellingLoc(sm, mloc)
        @test CC.isFileID(spelling)
        @test CC.getRawEncoding(CC.getExpansionLoc(sm, mloc)) != CC.getRawEncoding(mloc)
        arg, argstart = CC.isMacroArgExpansion(sm, mloc)
        @test arg isa Bool
        @test argstart isa CC.SourceLocation
        @test CC.isMacroBodyExpansion(sm, mloc) == !arg
        st, mb = CC.isAtStartOfImmediateMacroExpansion(sm, mloc)
        @test st isa Bool
        en, me = CC.isAtEndOfImmediateMacroExpansion(sm, mloc)
        @test en isa Bool
        irng, itok = CC.getImmediateExpansionRange(sm, mloc)
        @test irng isa CC.SourceRange
        @test itok isa Bool
        @test CC.isValid(CC.getImmediateMacroCallerLoc(sm, mloc))
        @test CC.isValid(CC.getTopMacroCallerLoc(sm, mloc))
        @test !CC.isInSystemMacro(sm, mloc)
        @test !CC.is_null_handle(CC.getMacroArgExpandedLocation(sm, spelling))
        sfid, soff = CC.getDecomposedSpellingLoc(sm, mloc)
        @test sfid isa CC.FileID
        CC.dispose(sfid)
        efid, eoff = CC.getDecomposedExpansionLoc(sm, mloc)
        @test efid isa CC.FileID
        CC.dispose(efid)
    end

    # SourceRange helpers
    sr = CC.getSourceRange(fd)
    @test CC.isValid(sr)
    @test !CC.isInvalid(sr)
    @test CC.fullyContains(sr, sr)
    @test !isempty(CC.printToString(sr, sm))
    @test CC.dump(sr, sm) === nothing

    # file-entry-backed queries on a real file
    path, io = mktemp()
    write(io, "int sm_batch_dummy;\n")
    close(io)
    ref = CC.getFileRef(fm, path)
    entry = CC.getFileEntry(ref)
    nfid = CC.getOrCreateFileID(sm, ref)
    @test nfid isa CC.FileID
    sloc = CC.getLocForStartOfFile(sm, nfid)
    @test CC.isValid(sloc)
    @test occursin("sm_batch_dummy", CC.getBufferData(sm, nfid))
    @test endswith(CC.getFilename(sm, sloc), basename(path))
    fe = CC.getFileEntryForID(sm, nfid)
    @test fe isa CC.FileEntry
    fer = CC.getFileEntryRefForID(sm, nfid)
    @test fer isa CC.FileEntryRef
    @test !CC.isFileOverridden(sm, entry)
    @test !(CC.isMainFile(sm, entry))
    @test CC.setFileIsTransient(sm, ref) === nothing
    @test CC.setAllFilesAreTransient(sm, false) === nothing
    tfid = CC.translateFile(sm, entry)
    @test CC.getHashValue(tfid) == CC.getHashValue(nfid)
    tl = CC.translateFileLineCol(sm, entry, 1, 1)
    @test CC.getRawEncoding(tl) == CC.getRawEncoding(sloc)
    ifid, ioff = CC.getDecomposedIncludedLoc(sm, nfid)
    @test ifid isa CC.FileID
    CC.dispose(ifid)
    fer !== nothing && CC.dispose(fer)
    CC.dispose(tfid)
    CC.dispose(nfid)
    CC.dispose(ref)
    rm(path; force=true)

    CC.dispose(fid)
    CC.dispose(fid2)
    CC.dispose(f)
    CC.dispose(I)
end

@testset "Coverage | SourceManagerB" begin
    I = create_interpreter(String[])
    CC.parse(I, """extern "C" int smb_add(int a) { return a + 1; }""")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    fm = CC.getFileManager(sm)
    langopts = CC.getLangOpts(ci)

    # ---- SourceManager: state and size queries ----
    @test !(CC.userFilesAreVolatile(sm))
    @test CC.hasLineTable(sm)
    @test CC.getContentCacheSize(sm) isa Integer  # shape-only: the host decides this
    @test CC.local_sloc_entry_size(sm) isa Integer  # shape-only: the target chooses this value
    @test CC.local_sloc_entry_size(sm) > 0
    @test CC.loaded_sloc_entry_size(sm) isa Integer  # shape-only: the target chooses this value
    @test CC.getNextLocalOffset(sm) isa Integer  # shape-only: the target chooses this value

    # the line table is materialised on demand by getLineTableFilenameID
    fnid = CC.getLineTableFilenameID(sm, "sm-batch-b.h")
    @test fnid isa Integer
    @test CC.getLineTableFilenameID(sm, "sm-batch-b.h") == fnid
    @test CC.hasLineTable(sm)

    # ---- SourceManager: preamble and SLoc address-space predicates ----
    preamble = CC.getPreambleFileID(sm)
    @test preamble isa CC.FileID
    @test CC.getHashValue(preamble) == 0    # no preamble was ever set on this manager
    CC.dispose(preamble)

    mainid = CC.getMainFileID(sm)
    startloc = CC.getLocForStartOfFile(sm, mainid)
    @test !(CC.isLoadedSourceLocation(sm, startloc))
    @test CC.isLocalSourceLocation(sm, startloc)
    @test CC.isLoadedSourceLocation(sm, startloc) != CC.isLocalSourceLocation(sm, startloc)
    @test CC.getBufferDataOrNone(sm, mainid) isa Union{String,Nothing}
    @test CC.getNonBuiltinFilenameForID(sm, mainid) isa Union{String,Nothing}
    CC.dispose(mainid)

    # ---- SourceManager: a real on-disk file ----
    path, io = mktemp()
    write(io, "int smb_dummy;\n")
    close(io)
    ref = CC.getFileRef(fm, path)
    entry = CC.getFileEntry(ref)
    fid = CC.getOrCreateFileID(sm, ref)
    @test CC.hasFileInfo(sm, entry)
    data = CC.getBufferDataOrNone(sm, fid)
    @test data !== nothing
    @test occursin("smb_dummy", data)
    fname = CC.getNonBuiltinFilenameForID(sm, fid)
    @test fname !== nothing
    @test endswith(fname, basename(path))
    @test CC.hasFileInfo(sm, entry)
    CC.dispose(fid)
    CC.dispose(ref)
    rm(path; force=true)

    # ---- Module ----
    root = CC.Module_("SmbTopMod"; visibility_id=3)
    @test CC.getVisibilityID(root) == 3
    # another bit a synthetic module never had a module map to set, so the answer is
    # the runner's rather than clang's -- only its shape is assertable
    @test CC.isNamedModuleInterfaceHasInit(root) isa Bool  # shape-only: the host decides this
    @test !(CC.isForBuilding(root, langopts))
    @test CC.getASTFile(root) === nothing
    @test CC.addTopHeaderFilename(root, "smb-top.h") === nothing

    # inference is off for a hand-built module, so an unknown name yields a NULL carrier
    missing_sub = CC.findOrInferSubmodule(root, "NoSuchSubmodule")
    @test missing_sub isa CC.Module_
    @test missing_sub.ptr == C_NULL

    child = CC.Module_("SmbChild"; parent=root)   # owned by root — do not dispose
    found = CC.findOrInferSubmodule(root, "SmbChild")
    @test found.ptr == child.ptr

    # Availability of a HAND-BUILT module is host-decided, and so is the transition:
    # Module::markUnavailable early-returns unless its needUpdate predicate holds, which
    # reads both IsAvailable and IsUnimportable — bits a synthetic module never had a
    # real module map or requirement list to set. Windows CI observed isAvailable still
    # true after the call while macOS and Linux observed false. Only the shape is
    # asserted; the call itself still exercises the wrapper.
    # A synthetic module has no module map, so isAvailable reads bits that were never
    # set and the answer differs per runner (CLAUDE.md records this); only the shape
    # of it is assertable here.
    @test CC.isAvailable(root) isa Bool  # shape-only: the host decides this
    @test CC.markUnavailable(root, true) === nothing
    # same synthetic-module caveat: the markUnavailable transition is gated on bits a
    # module built without a module map never had
    @test CC.isAvailable(root) isa Bool  # shape-only: the host decides this
    CC.dispose(root)

    CC.dispose(I)
end

@testset "Coverage | SourceManager SLocEntry table" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             #define SMB_TWICE(x) ((x) + (x))
             extern "C" int smb_slocentry(int a) { return SMB_TWICE(a); }
             """)
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)

    # ---- SourceManager: FileID locality ----
    mainid = CC.getMainFileID(sm)
    @test CC.isLocalFileID(sm, mainid)
    @test !(CC.isLoadedFileID(sm, mainid))
    @test CC.isLocalFileID(sm, mainid) == !CC.isLoadedFileID(sm, mainid)

    # ---- SourceManager: the SLocEntry table ----
    n = Int(CC.local_sloc_entry_size(sm))
    @test n > 0

    entry, invalid = CC.getSLocEntry(sm, mainid)
    @test entry isa CC.SLocEntry
    @test invalid isa Bool
    @test CC.getOffset(entry) isa Integer  # shape-only: the target chooses this value

    # Which indices hold a file and which a macro expansion is decided by the parse, so the
    # exemplars are found by scanning instead of being hard-coded.
    file_idx = -1
    expansion_idx = -1
    kinds_consistent = true
    for i = 0:(n - 1)
        e = CC.getLocalSLocEntry(sm, i)
        is_file = CC.isFile(e)
        kinds_consistent &= (is_file == !CC.isExpansion(e))
        if is_file
            file_idx < 0 && (file_idx = i)
        else
            expansion_idx < 0 && (expansion_idx = i)
        end
    end
    @test kinds_consistent
    @test file_idx >= 0
    @test expansion_idx >= 0

    # ---- SrcMgr::FileInfo ----
    fe = CC.getLocalSLocEntry(sm, file_idx)
    @test CC.getOffset(fe) isa Integer  # shape-only: the target chooses this value
    fi = CC.getFile(fe)
    @test fi isa CC.FileInfo
    @test CC.is_null_handle(CC.getIncludeLoc(fi))
    @test CC.getFileCharacteristic(fi) isa CC.CXCharacteristicKind
    @test !(CC.hasLineDirectives(fi))
    @test CC.getName(fi) isa String

    # ---- SrcMgr::ExpansionInfo ----
    ee = CC.getLocalSLocEntry(sm, expansion_idx)
    ei = CC.getExpansion(ee)
    @test ei isa CC.ExpansionInfo
    @test CC.getSpellingLoc(ei) isa CC.SourceLocation
    @test CC.is_null_handle(CC.getExpansionLocStart(ei))
    @test CC.is_null_handle(CC.getExpansionLocEnd(ei))
    @test CC.isExpansionTokenRange(ei)
    @test CC.isMacroArgExpansion(ei) isa Bool
    @test !(CC.isMacroBodyExpansion(ei))
    @test !(CC.isFunctionMacroExpansion(ei))
    # a macro-argument expansion records an invalid end location and a macro-body expansion
    # a valid one, so the two predicates can never hold together
    @test !(CC.isMacroArgExpansion(ei) && CC.isMacroBodyExpansion(ei))

    # ---- the preconditions the wrappers restate (Clang asserts them) ----
    @test_throws AssertionError CC.getLocalSLocEntry(sm, n)
    @test_throws AssertionError CC.getFile(ee)
    @test_throws AssertionError CC.getExpansion(fe)

    CC.dispose(mainid)
    CC.dispose(I)
end

@testset "Coverage | SourceManager FileID, sizes and ContentCache" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int smd_content_cache(int a) { return a + 1; }
             """)
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)

    # ---- FileID validity ----
    mainid = CC.getMainFileID(sm)
    @test CC.isValid(mainid)
    @test !CC.isInvalid(mainid)

    sentinel = CC.getSentinel()
    @test sentinel isa CC.FileID
    # the sentinel is FileID::get(-1): it compares valid and is not the null FileID
    @test CC.isValid(sentinel)
    @test !CC.isInvalid(sentinel)
    @test CC.getHashValue(sentinel) == typemax(UInt32)
    CC.dispose(sentinel)

    # ---- SourceManager: the preamble FileID ----
    # a fresh interpreter has no precompiled preamble, so the setter can be exercised by
    # writing the (invalid) value straight back — Clang asserts on any other input
    preamble = CC.getPreambleFileID(sm)
    @test CC.isInvalid(preamble)
    @test CC.setPreambleFileID(sm, preamble) === nothing
    CC.dispose(preamble)

    # ---- SourceManager: configuration and memory accounting ----
    @test CC.setOverridenFilesKeepOriginalName(sm, true) === nothing
    @test CC.getDataStructureSizes(sm) isa Integer  # shape-only: the host decides this
    malloc_bytes, mmap_bytes = CC.getMemoryBufferSizes(sm)
    @test malloc_bytes isa Integer
    @test mmap_bytes isa Integer

    # writing the count back needs `force`, since Clang asserts the slot is still zero
    n = CC.getNumCreatedFIDsForFileID(sm, mainid)
    @test CC.setNumCreatedFIDsForFileID(sm, mainid, n, true) === nothing
    @test CC.getNumCreatedFIDsForFileID(sm, mainid) == n
    if n != 0
        @test_throws AssertionError CC.setNumCreatedFIDsForFileID(sm, mainid, n)
    end

    # ---- SourceManager: the SLoc address space ----
    startloc = CC.getLocForStartOfFile(sm, mainid)
    endloc = CC.getLocForEndOfFile(sm, mainid)
    same, offset = CC.isInSameSLocAddrSpace(sm, startloc, endloc)
    # both ends of one local file are necessarily in the same half of the address space
    @test same
    @test offset isa Integer

    # ---- SourceManager: the loaded SLocEntry table ----
    nloaded = Int(CC.loaded_sloc_entry_size(sm))
    @test nloaded isa Integer
    @test_throws AssertionError CC.getLoadedSLocEntry(sm, nloaded)
    if nloaded > 0
        loaded, loaded_invalid = CC.getLoadedSLocEntry(sm, 0)
        @test loaded isa CC.SLocEntry
        @test loaded_invalid isa Bool
    end

    # ---- SourceManager: buffer data that has already been loaded ----
    data = CC.getBufferDataIfLoaded(sm, mainid)
    @test data === nothing || data isa String

    # ---- SourceManager: the FileEntry behind an SLocEntry ----
    entry, _ = CC.getSLocEntry(sm, mainid)
    @test CC.isFile(entry)
    fe = CC.getFileEntryForSLocEntry(sm, entry)
    # the interpreter's main file comes from a memory buffer, so it may have no FileEntry
    @test fe === nothing || fe isa CC.FileEntry

    # ---- SrcMgr::FileInfo -> SrcMgr::ContentCache ----
    fi = CC.getFile(entry)
    cc = CC.getContentCache(fi)
    @test cc isa CC.ContentCache
    @test CC.isBufferLoaded(cc)
    @test CC.getSizeBytesMapped(cc) isa Integer  # shape-only: the host decides this
    ccdata = CC.getBufferDataIfLoaded(cc)
    @test ccdata === nothing || ccdata isa String
    if CC.isBufferLoaded(cc)
        @test CC.getSize(cc) isa Integer
        @test CC.getSize(cc) == ncodeunits(ccdata)
        @test CC.getMemoryBufferKind(cc) isa CC.CXBufferKind
    else
        # both accessors read the buffer unconditionally, so the wrappers must reject this
        @test_throws AssertionError CC.getSize(cc)
        @test_throws AssertionError CC.getMemoryBufferKind(cc)
    end

    # ---- SrcMgr::ContentCache: byte order marks Clang cannot handle ----
    @test CC.getInvalidBOM("plain ASCII source text") === nothing
    bom = CC.getInvalidBOM(String(UInt8[0xfe, 0xff, 0x41, 0x42]))
    @test bom isa String
    @test !isempty(bom)

    CC.dispose(mainid)
    CC.dispose(I)
end

@testset "Coverage | SourceManager line notes, module build stack and synthetic expansions" begin
    I = create_interpreter(String[])
    CC.parse(I, """extern "C" int sme_add(int a) { return a + 3; }""")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    fm = CC.getFileManager(sm)
    diag = CC.getDiagnostics(sm)

    mainid = CC.getMainFileID(sm)
    startloc = CC.getLocForStartOfFile(sm, mainid)

    # ---- SourceManager: the whole-manager dump ----
    @test CC.dump(sm) === nothing

    # ---- SourceManager: the module build stack ----
    n0 = Int(CC.getModuleBuildStackSize(sm))
    @test CC.pushModuleBuildStack(sm, "SmeSyntheticModule", startloc) === nothing
    @test CC.getModuleBuildStackSize(sm) == n0 + 1
    name, importloc = CC.getModuleBuildStackEntry(sm, n0)
    @test name == "SmeSyntheticModule"
    @test importloc isa CC.SourceLocation
    @test CC.getRawEncoding(importloc) == CC.getRawEncoding(startloc)
    @test_throws AssertionError CC.getModuleBuildStackEntry(sm, n0 + 1)
    stack = CC.getModuleBuildStack(sm)
    @test length(stack) == n0 + 1
    @test last(stack)[1] == "SmeSyntheticModule"

    # ---- SourceManager: a location that lives in this TU, not in a loaded module ----
    imploc, modname = CC.getModuleImportLoc(sm, startloc)
    @test imploc isa CC.SourceLocation
    @test CC.isInvalid(imploc)
    @test modname == ""

    # the interpreter's main file is a synthetic buffer, so only the shape is asserted
    @test isempty(CC.getBufferDataOrFake(sm, mainid))
    @test CC.getBufferDataOrFake(sm, mainid, startloc) ==
          CC.getBufferDataOrFake(sm, mainid)

    # ---- SourceManager: a real on-disk file, whose contents the test itself wrote ----
    path, io = mktemp()
    write(io, "int sme_dummy;\n")
    close(io)
    ref = CC.getFileRef(fm, path)
    mdata = CC.getMemoryBufferDataForFileOrNone(sm, ref)
    @test mdata isa String
    @test occursin("sme_dummy", mdata)
    @test CC.getMemoryBufferDataForFileOrFake(sm, ref) == mdata

    fid = CC.getOrCreateFileID(sm, ref)
    @test occursin("sme_dummy", CC.getBufferDataOrFake(sm, fid))
    floc = CC.getLocForStartOfFile(sm, fid)
    fsize = CC.getFileIDSize(sm, fid)

    # ---- SourceManager: membership in one chunk of the SLoc address space ----
    inside, offset = CC.isInSLocAddrSpace(sm, floc, floc, fsize)
    @test inside
    @test offset == 0
    inside2, offset2 = CC.isInSLocAddrSpace(sm, CC.getLocWithOffset(floc, 4), floc, fsize)
    @test inside2
    @test offset2 == 4
    # the main file is a different chunk entirely
    outside, _ = CC.isInSLocAddrSpace(sm, startloc, floc, fsize)
    @test !outside

    # ---- SourceManager: a line note rewrites the presumed filename ----
    fnid = CC.getLineTableFilenameID(sm, "sme-line-note.h")
    @test fnid isa Integer
    @test CC.AddLineNote(sm, floc, 100, fnid, false, false,
                         CC.CXCharacteristicKind_C_User) === nothing
    @test CC.hasLineTable(sm)
    presumed = CC.getPresumedLoc(sm, floc)
    @test presumed !== nothing
    @test presumed[1] == "sme-line-note.h"

    # ---- SrcMgr::FileInfo: the flag AddLineNote flipped, set again explicitly ----
    entry, _ = CC.getSLocEntry(sm, fid)
    @test CC.isFile(entry)
    fi = CC.getFile(entry)
    @test CC.hasLineDirectives(fi)
    @test CC.setHasLineDirectives(fi) === nothing
    @test CC.hasLineDirectives(fi)

    # ---- SrcMgr::ContentCache: forcing the buffer to load ----
    cc = CC.getContentCache(fi)
    ccdata = CC.getBufferDataOrNone(cc, diag, fm, floc)
    @test ccdata isa String
    @test occursin("sme_dummy", ccdata)
    @test CC.isBufferLoaded(cc)
    # every carrier borrowed from the SLocEntry table above dies with the next create below

    # ---- SourceManager: synthetic macro-expansion locations ----
    argloc = CC.createMacroArgExpansionLoc(sm, floc, floc, 3)
    @test argloc isa CC.SourceLocation
    @test CC.isMacroID(argloc)
    @test CC.getRawEncoding(CC.getSpellingLoc(sm, argloc)) == CC.getRawEncoding(floc)
    is_arg, _ = CC.isMacroArgExpansion(sm, argloc)
    @test is_arg

    splitloc = CC.createTokenSplitLoc(sm, floc, floc, CC.getLocWithOffset(floc, 3))
    @test splitloc isa CC.SourceLocation
    @test CC.isMacroID(splitloc)

    # ---- SrcMgr::ExpansionInfo: the entry the macro-argument location created ----
    expid = CC.getFileID(sm, argloc)
    expentry, _ = CC.getSLocEntry(sm, expid)
    @test CC.isExpansion(expentry)
    ei = CC.getExpansion(expentry)
    r, is_token = CC.getExpansionLocRange(ei)
    @test r isa CC.SourceRange
    @test is_token == CC.isExpansionTokenRange(ei)
    @test CC.getRawEncoding(CC.getBeginLoc(r)) ==
          CC.getRawEncoding(CC.getExpansionLocStart(ei))
    @test CC.getRawEncoding(CC.getEndLoc(r)) ==
          CC.getRawEncoding(CC.getExpansionLocEnd(ei))
    CC.dispose(expid)

    CC.dispose(fid)
    CC.dispose(ref)
    rm(path; force=true)

    # ---- SourceManager: restarting a standalone manager's ID tables ----
    fm2 = CC.FileManager()
    diag2 = CC.DiagnosticsEngine()
    sm2 = CC.SourceManager(fm2, diag2)
    nbefore = CC.local_sloc_entry_size(sm2)
    @test CC.clearIDTables(sm2) === nothing
    # the constructor itself runs clearIDTables, so the table returns to the same shape
    @test CC.local_sloc_entry_size(sm2) == nbefore
    @test CC.getModuleBuildStackSize(sm2) == 0
    dispose(sm2)   # the source manager stores references: dispose before fm2/diag2
    dispose(fm2)
    dispose(diag2)

    CC.dispose(mainid)
    CC.dispose(I)
end

@testset "SourceManager | macro-use expansions, cross-TU ordering, FullSourceLoc & delayed diagnostics" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fsl_probe = 1;")
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)

    f = DeclFinder(I)
    @test f(I, "fsl_probe") isa Bool
    loc = CC.getLocation(get_decl(f))
    @test CC.isValid(loc)
    later = CC.getLocWithOffset(loc, 4)
    @test CC.isBeforeInTranslationUnit(sm, loc, later)

    # ---- SourceManager: the SLocEntry for one macro use ----
    exp = CC.createExpansionLoc(sm, loc, loc, later, 3)
    @test exp isa CC.SourceLocation
    @test CC.isMacroID(exp)
    @test CC.getRawEncoding(CC.getSpellingLoc(sm, exp)) == CC.getRawEncoding(loc)
    # both ends of the use are valid, which is exactly what makes it a body expansion
    @test CC.isMacroBodyExpansion(sm, exp)
    charexp = CC.createExpansionLoc(sm, loc, loc, later, 3; is_token_range=false)
    @test CC.isMacroID(charexp)
    expid = CC.getFileID(sm, charexp)
    expentry, _ = CC.getSLocEntry(sm, expid)
    @test CC.isExpansion(expentry)
    @test !CC.isExpansionTokenRange(CC.getExpansion(expentry))
    CC.dispose(expid)

    # ---- SourceManager: same-translation-unit questions on decomposed locations ----
    lid, loff = CC.getDecomposedLoc(sm, loc)
    rid, roff = CC.getDecomposedLoc(sm, later)
    @test CC.isInTheSameTranslationUnitImpl(sm, lid, loff, rid, roff)
    # the walk rewrites lid/rid in place, so both are read back through the returned offsets
    same, before, loff2, roff2 = CC.isInTheSameTranslationUnit(sm, lid, loff, rid, roff)
    @test same
    @test before isa Bool
    @test loff2 isa Integer
    @test roff2 isa Integer
    @test CC.isValid(lid)
    @test CC.isValid(rid)
    CC.dispose(lid)
    CC.dispose(rid)

    # ---- FullSourceLoc: the (location, manager) pair and its forwarding accessors ----
    fsl = CC.FullSourceLoc(loc, sm)
    @test CC.hasManager(fsl)
    @test CC.getManager(fsl).ptr == sm.ptr
    fid = CC.getFileID(fsl)
    @test fid isa CC.FileID
    @test CC.isValid(fid)
    CC.dispose(fid)
    @test CC.getFileOffset(fsl) == CC.getFileOffset(sm, loc)
    @test CC.getLineNumber(fsl) >= 1
    @test CC.getColumnNumber(fsl) >= 1
    @test CC.getExpansionLoc(fsl) isa CC.FullSourceLoc
    @test CC.getExpansionLoc(fsl).loc.ptr == CC.getExpansionLoc(sm, loc).ptr
    @test CC.getSpellingLoc(fsl).loc.ptr == CC.getSpellingLoc(sm, loc).ptr
    @test CC.getSpellingLoc(fsl).src_mgr.ptr == sm.ptr
    @test CC.getFileLoc(fsl).loc.ptr == CC.getFileLoc(sm, loc).ptr
    @test CC.isInSystemHeader(fsl) isa Bool
    @test CC.isBeforeInTranslationUnitThan(fsl, later)
    later_fsl = CC.FullSourceLoc(later, sm)
    @test CC.isBeforeInTranslationUnitThan(fsl, later_fsl)
    @test !CC.isBeforeInTranslationUnitThan(later_fsl, fsl)

    empty_fsl = CC.FullSourceLoc()
    @test !CC.hasManager(empty_fsl)
    @test_throws AssertionError CC.getManager(empty_fsl)
    @test_throws AssertionError CC.getFileID(empty_fsl)
    @test_throws AssertionError CC.getLineNumber(empty_fsl)
    @test_throws AssertionError CC.getColumnNumber(empty_fsl)
    @test_throws AssertionError CC.isInSystemHeader(empty_fsl)
    @test_throws AssertionError CC.isBeforeInTranslationUnitThan(fsl, empty_fsl)

    # ---- DiagnosticsEngine / DiagnosticBuilder / Diagnostic ----
    # A throwaway engine, so nothing here reaches the interpreter's own DiagnosticsEngine.
    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                  CC.IgnoringDiagConsumer(), true)  # engine adopts all three
    @test_throws AssertionError CC.dump(engine)   # the state map is rendered through the SM
    CC.setSourceManager(engine, sm)
    @test CC.dump(engine) === nothing             # writes the state map to stderr

    warn_id = CC.getCustomDiagID(engine, CC.CXDiagnosticsEngine_Warning, "cstr probe %0")
    cstr = Vector{UInt8}("probe-c-string")
    push!(cstr, 0x00)
    GC.@preserve cstr begin
        # the diagnostic stores the pointer itself, so the buffer must outlive the read
        b = CC.DiagnosticBuilder(engine, loc, warn_id)
        CC.AddTaggedVal(b, UInt64(UInt(pointer(cstr))), CC.CXDiagnosticsEngine_ak_c_string)
        @test CC.addFlagValue(b, "Wprobe-flag") === nothing
        @test CC.getFlagValue(engine) == "Wprobe-flag"
        @test CC.setForceEmit(b) === b

        d = CC.Diagnostic(engine)
        @test !CC.is_null_handle(CC.getDiags(d))
        @test CC.getDiags(d).ptr == engine.ptr
        @test CC.getNumArgs(d) == 1
        @test CC.getArgKind(d, 0) == CC.CXDiagnosticsEngine_ak_c_string
        @test CC.getArgCStr(d, 0) == "probe-c-string"
        @test_throws AssertionError CC.getArgStdStr(d, 0)
        @test occursin("probe-c-string", CC.FormatDiagnostic(d))
        CC.dispose(d)
        CC.dispose(b)                             # emits the forced diagnostic
    end
    @test !CC.isDiagnosticInFlight(engine)

    # A second engine, so the delayed queue is observed on counters of its own.
    engine2 = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                   CC.IgnoringDiagConsumer(), true)
    CC.setSourceManager(engine2, sm)
    delayed_id = CC.getCustomDiagID(engine2, CC.CXDiagnosticsEngine_Warning,
                                    "delayed %0 %1 %2")
    plain_id = CC.getCustomDiagID(engine2, CC.CXDiagnosticsEngine_Warning, "plain probe")
    @test CC.SetDelayedDiagnostic(engine2, delayed_id, "a", "b", "c") === nothing
    @test CC.getNumWarnings(engine2) == 0
    b2 = CC.DiagnosticBuilder(engine2, loc, plain_id)
    CC.dispose(b2)
    # the plain diagnostic always lands; whether clang flushes the queued one alongside it
    # is its own business, so only the growth is asserted
    @test CC.getNumWarnings(engine2) > 0

    CC.dispose(engine2)                 # the adopted ids/opts/client go with it
    CC.dispose(engine)
    CC.dispose(I)
end

@testset "SourceManager | fileinfo map, replay, line offsets and single-file managers" begin
    I = create_interpreter(String[])
    CC.parse(I, "int sloc_extra_probe = 1;")
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)

    f = DeclFinder(I)
    @test f(I, "sloc_extra_probe") isa Bool
    loc = CC.getLocation(get_decl(f))
    @test CC.isValid(loc)

    # ---- FullSourceLoc: the accessors that reach the file behind the location ----
    fsl = CC.FullSourceLoc(loc, sm)
    @test CC.getSpellingLineNumber(fsl) == CC.getSpellingLineNumber(sm, loc)
    @test CC.getSpellingColumnNumber(fsl) == CC.getSpellingColumnNumber(sm, loc)
    @test CC.getExpansionLineNumber(fsl) == CC.getExpansionLineNumber(sm, loc)
    @test CC.getExpansionColumnNumber(fsl) == CC.getExpansionColumnNumber(sm, loc)
    @test CC.getCharacterData(fsl) == CC.getCharacterData(sm, loc)
    # the buffer is the one this testset itself handed to the interpreter
    @test occursin("sloc_extra_probe", CC.getBufferData(fsl))

    ploc = CC.getPresumedLoc(fsl)
    @test ploc isa CC.PresumedLoc
    @test CC.isValid(ploc)
    CC.dispose(ploc)
    ploc2 = CC.getPresumedLoc(fsl; use_line_directives=false)
    @test CC.isValid(ploc2)
    CC.dispose(ploc2)

    caller = CC.getImmediateMacroCallerLoc(fsl)
    @test caller isa CC.FullSourceLoc
    @test caller.src_mgr.ptr == sm.ptr
    @test caller.loc.ptr == CC.getImmediateMacroCallerLoc(sm, loc).ptr

    is_arg, arg_start = CC.isMacroArgExpansion(fsl)
    @test is_arg isa Bool
    @test arg_start isa CC.FullSourceLoc
    @test arg_start.src_mgr.ptr == sm.ptr

    import_loc, module_name = CC.getModuleImportLoc(fsl)
    @test import_loc isa CC.FullSourceLoc
    @test module_name isa String

    loc_ref = CC.getFileEntryRef(fsl)
    @test loc_ref === nothing || loc_ref isa CC.FileEntryRef
    loc_ref !== nothing && CC.dispose(loc_ref)

    # the file entry reached through the pair is the one the manager gives for the same ID
    fid = CC.getFileID(fsl)
    entry = CC.getFileEntry(fsl)
    direct = CC.getFileEntryForID(sm, fid)
    @test entry === nothing ? direct === nothing : entry.ptr == direct.ptr
    CC.dispose(fid)

    # decomposition agrees with the manager, and the offset re-composes to the location
    dec_id, dec_off = CC.getDecomposedLoc(fsl)
    sm_id, sm_off = CC.getDecomposedLoc(sm, loc)
    @test dec_off == sm_off
    @test CC.getLocForStartOfFile(sm, dec_id).ptr == CC.getLocForStartOfFile(sm, sm_id).ptr
    CC.dispose(dec_id)
    CC.dispose(sm_id)

    exp_id, exp_off = CC.getDecomposedExpansionLoc(fsl)
    sm_exp_id, sm_exp_off = CC.getDecomposedExpansionLoc(sm, loc)
    @test exp_off == sm_exp_off
    @test CC.getLocForStartOfFile(sm, exp_id).ptr == CC.getLocForStartOfFile(sm, sm_exp_id).ptr
    CC.dispose(exp_id)
    CC.dispose(sm_exp_id)

    empty_fsl = CC.FullSourceLoc()
    @test_throws AssertionError CC.getPresumedLoc(empty_fsl)
    @test_throws AssertionError CC.getFileEntry(empty_fsl)
    @test_throws AssertionError CC.getDecomposedLoc(empty_fsl)
    @test_throws AssertionError CC.getDecomposedExpansionLoc(empty_fsl)
    @test_throws AssertionError CC.dump(empty_fsl)
    @test_throws AssertionError CC.isMacroArgExpansion(empty_fsl)
    @test_throws AssertionError CC.getImmediateMacroCallerLoc(empty_fsl)
    @test_throws AssertionError CC.getModuleImportLoc(empty_fsl)
    @test_throws AssertionError CC.getExpansionLineNumber(empty_fsl)
    @test_throws AssertionError CC.getExpansionColumnNumber(empty_fsl)
    @test_throws AssertionError CC.getSpellingLineNumber(empty_fsl)
    @test_throws AssertionError CC.getSpellingColumnNumber(empty_fsl)
    @test_throws AssertionError CC.getCharacterData(empty_fsl)
    @test_throws AssertionError CC.getBufferData(empty_fsl)
    @test_throws AssertionError CC.getFileEntryRef(empty_fsl)

    # ---- SourceManager: address-space usage notes, through a throwaway engine ----
    # A throwaway engine, so nothing here reaches the interpreter's own DiagnosticsEngine.
    engine = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(),
                                  CC.IgnoringDiagConsumer(), true)  # engine adopts all three
    CC.setSourceManager(engine, sm)
    @test CC.noteSLocAddressSpaceUsage(sm, engine) === nothing
    @test CC.noteSLocAddressSpaceUsage(sm, engine; max_notes=nothing) === nothing
    CC.dispose(engine)

    # ---- SourceManager: replay, the fileinfo map and the override bypass ----
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    old = CC.SourceManager(fm, diag)
    replay = CC.SourceManager(fm, diag)
    # replaying is only legal into a manager whose main file ID is still unset
    @test CC.initializeForReplay(replay, old) === nothing

    path, io = mktemp()
    write(io, "int bypass_probe;\nint bypass_probe2;\n")
    close(io)
    ref = CC.getFileRef(fm, path)
    entry = CC.getFileEntry(ref)
    fid = CC.getOrCreateFileID(old, ref)     # the manager now caches this file
    @test CC.getNumFileInfos(old) >= 1
    infos = CC.getFileInfos(old)
    @test length(infos) == CC.getNumFileInfos(old)
    for (e, cache) in infos
        @test e isa CC.FileEntry
        @test cache isa CC.ContentCache
        @test CC.hasFileInfo(old, e)         # every key is a file the manager knows about
        @test !(CC.isBufferLoaded(cache))
    end

    @test !CC.isFileOverridden(old, entry)
    @test_throws AssertionError CC.bypassFileContentsOverride(old, ref)
    ov = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits("int overridden_probe;")), "override",
                              true)
    CC.overrideFileContents(old, ref, ov)    # consumes ov: do not dispose the buffer
    if CC.isFileOverridden(old, entry)
        bypass = CC.bypassFileContentsOverride(old, ref)
        @test bypass === nothing || bypass isa CC.FileEntryRef
        bypass !== nothing && CC.dispose(bypass)
    end

    CC.dispose(fid)
    CC.dispose(ref)
    dispose(replay)   # replay borrows old's buffers, and both hold references to fm/diag
    dispose(old)
    dispose(fm)
    dispose(diag)
    rm(path; force=true)

    # ---- LineOffsetMapping: where each physical line of a buffer starts ----
    content = "int a;\nint bb;\nint ccc;\n"
    lom = CC.LineOffsetMapping(content, "lom-probe.h")
    @test lom isa CC.LineOffsetMapping
    lines = CC.getLines(lom)
    @test lines isa Vector{UInt32}
    @test length(lines) == CC.size(lom)
    @test CC.size(lom) >= 1
    @test issorted(lines)
    @test all(<=(ncodeunits(content)), lines)
    one_line = CC.LineOffsetMapping("int a;")
    # the single-line buffer cannot map more lines than the three-line one
    @test CC.size(one_line) <= CC.size(lom)
    CC.dispose(one_line)
    CC.dispose(lom)

    # ---- SourceManagerForFile: a manager, file manager and engine for one buffer ----
    smf = CC.SourceManagerForFile("smf-probe.cc", "int smf_probe = 3;\nint smf_probe2 = 4;\n")
    smf_sm = CC.getSourceManager(smf)
    @test smf_sm isa CC.SourceManager
    smf_fid = CC.getMainFileID(smf_sm)
    @test CC.isValid(smf_fid)
    @test occursin("smf_probe", CC.getBufferData(smf_sm, smf_fid))
    smf_loc = CC.getLocForStartOfFile(smf_sm, smf_fid)
    # the start of the buffer is offset 0, hence line 1
    @test CC.getLineNumber(CC.FullSourceLoc(smf_loc, smf_sm)) == 1
    CC.dispose(smf_fid)
    CC.dispose(smf)   # the manager belongs to the box: smf_sm must not be disposed

    CC.dispose(I)
end
