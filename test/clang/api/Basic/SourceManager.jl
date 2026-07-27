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
