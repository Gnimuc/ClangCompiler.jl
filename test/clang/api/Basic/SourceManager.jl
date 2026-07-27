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
    fd = CC.FunctionDecl(d.ptr)
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
    @test CC.isValid(loc) isa Bool
    @test CC.isInvalid(inv) isa Bool
    @test CC.getHashValue(loc) isa Integer
    b = CC.getBeginLoc(sr)
    e = CC.getEndLoc(sr)
    @test b isa CC.SourceLocation
    @test e isa CC.SourceLocation
    @test CC.isPairOfFileLocations(b, e) isa Bool
    @test CC.getLocWithOffset(loc, 3) isa CC.SourceLocation
    @test CC.printToString(loc, sm) isa String
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
    @test CC.GetDeclForMangledName(cg, "add_two") isa CC.Decl

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
    fd = CC.FunctionDecl(d.ptr)
    loc = CC.getLocation(fd)
    @test CC.isValid(loc)
    @test CC.isFileID(loc)

    # borrowed accessors
    @test CC.getDiagnostics(sm) isa CC.DiagnosticsEngine
    fm = CC.getFileManager(sm)
    @test fm isa CC.FileManager

    # FileID queries + decomposition round-trips
    fid, off = CC.getDecomposedLoc(sm, loc)
    @test fid isa CC.FileID
    fid2 = CC.getFileID(sm, loc)
    @test CC.getHashValue(fid2) == CC.getHashValue(fid)
    @test CC.getFileOffset(sm, loc) == off
    @test CC.getFileIDSize(sm, fid) > 0
    @test CC.getNumCreatedFIDsForFileID(sm, fid) isa Integer
    inside, rel = CC.isInFileID(sm, loc, fid)
    @test inside
    @test rel == off
    raw = CC.getRawEncoding(loc)
    @test raw isa Integer
    @test CC.getRawEncoding(CC.getFromRawEncoding(raw)) == raw
    loc2 = CC.getComposedLoc(sm, fid, off)
    @test CC.getRawEncoding(loc2) == raw
    @test CC.getIncludeLoc(sm, fid) isa CC.SourceLocation

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
    @test CC.isInMainFile(sm, loc) isa Bool
    @test CC.isWrittenInSameFile(sm, loc, loc)
    @test CC.isWrittenInMainFile(sm, loc) isa Bool
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
        @test CC.getMacroArgExpandedLocation(sm, spelling) isa CC.SourceLocation
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
    @test CC.printToString(sr, sm) isa String
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
    @test CC.isMainFile(sm, entry) isa Bool
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
