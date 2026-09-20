using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# Everything here runs a real frontend, so the native target has to be registered exactly as
# `create_interpreter` registers it. Doing it here rather than relying on an earlier testset
# keeps this file runnable on its own.
CC.LLVM.InitializeNativeTarget()
CC.LLVM.InitializeAllTargetInfos()
CC.LLVM.InitializeAllTargetMCs()
CC.LLVM.InitializeNativeAsmPrinter()

const TOOLING_ERR = CC.CXTextDiagnosticBuffer_Error

@testset "buildASTFromCode | one call from a string to an ASTUnit" begin
    au = CC.buildASTFromCode("int bac_probe(int a) { return a + 1; }")
    @test au !== nothing
    # A parsed unit, not one read back from a serialized AST file.
    @test CC.isMainFileAST(au) == false
    @test CC.getMainFileName(au) == "input.cc"
    @test CC.top_level_size(au) >= 1
    @test !CC.is_null_handle(CC.getASTContext(au))
    dispose(au)

    # the file name reaches the unit, and with it the language clang infers
    named = CC.buildASTFromCode("int bac_named() { return 0; }", "probe.cpp")
    @test named !== nothing
    @test CC.getMainFileName(named) == "probe.cpp"
    dispose(named)
end

@testset "buildASTFromCodeWithArgs | flags, mapped files and the adjuster" begin
    # HeaderSearch only skips its search-path walk when llvm::sys::path::is_absolute accepts
    # the name, and on Windows that needs a root *name* as well as a root directory -- a bare
    # "/" has only the latter. Anchor on this file's volume, and use one string for both the
    # mapping key and the include so the in-memory file system is keyed and queried alike.
    bac_hdr = Sys.iswindows() ? string(first(splitdrive(@__DIR__)), "/bac_probe.h") : "/bac_probe.h"
    code = "#include <$bac_hdr>\nint bac_uses_vf() { return BAC_VALUE; }\n"

    # With the header mapped in, the include resolves and nothing is reported.
    with_map = CC.TextDiagnosticBuffer()
    au = CC.buildASTFromCodeWithArgs(code, ["-std=c++17"]; filename="main.cc",
                                     virtual_files=[bac_hdr => "#define BAC_VALUE 41\n"], diag_consumer=with_map)
    @test au !== nothing
    @test CC.getMainFileName(au) == "main.cc"
    @test Base.size(with_map, TOOLING_ERR) == 0
    dispose(au)
    dispose(with_map)

    # Without it the very same snippet cannot find the header. That partition is what proves
    # the mapping was used rather than the include silently succeeding some other way.
    without_map = CC.TextDiagnosticBuffer()
    unmapped = CC.buildASTFromCodeWithArgs(code, ["-std=c++17"]; filename="main.cc", diag_consumer=without_map)
    @test unmapped !== nothing
    @test Base.size(without_map, TOOLING_ERR) >= 1
    dispose(unmapped)
    dispose(without_map)

    # Same shape for the adjuster: the macro the snippet insists on comes from a flag the
    # adjuster inserts, so the parse is clean with it and fails without it.
    guarded = "#ifndef BAC_ADJ\n#error BAC_ADJ was not defined\n#endif\nint bac_adj() { return 0; }\n"

    plain = CC.TextDiagnosticBuffer()
    no_adj = CC.buildASTFromCodeWithArgs(guarded, ["-std=c++17"]; diag_consumer=plain)
    @test no_adj !== nothing
    @test Base.size(plain, TOOLING_ERR) >= 1
    dispose(no_adj)
    dispose(plain)

    adjusted = CC.TextDiagnosticBuffer()
    adj = CC.getInsertArgumentAdjuster("-DBAC_ADJ=1")
    with_adj = CC.buildASTFromCodeWithArgs(guarded, ["-std=c++17"]; adjuster=adj, diag_consumer=adjusted)
    @test with_adj !== nothing
    @test Base.size(adjusted, TOOLING_ERR) == 0
    dispose(with_adj)
    # the adjuster was copied into the invocation, so it is still ours and still works
    @test CC.adjust(adj, ["clang++"], "x.cc") == ["clang++", "-DBAC_ADJ=1"]
    dispose(adj)
    dispose(adjusted)

    # an adjuster needs an argv[0] to step over, so it cannot be paired with no flags at all
    adj2 = CC.getInsertArgumentAdjuster("-DX=1")
    @test_throws AssertionError CC.buildASTFromCodeWithArgs(guarded, String[]; adjuster=adj2)
    dispose(adj2)
end

@testset "runToolOnCodeWithArgs | a frontend action over a snippet" begin
    lctx = CC.LLVM.Context()

    # A snippet that compiles: the action runs and reports success.
    ok = CC.LLVMOnlyAction(lctx)
    @test CC.runToolOnCodeWithArgs(ok, "int rtc_probe(int a) { return a + 1; }", ["-std=c++17"]) == true

    # A snippet that does not: `CompilerInstance::ExecuteAction` reports the error count, so
    # the same call comes back false. Each action is consumed by its run, hence a second one.
    broken = CC.LLVMOnlyAction(lctx)
    @test CC.runToolOnCodeWithArgs(broken, "int rtc_broken(int a) { return nosuch(a); }", ["-std=c++17"]) == false

    # The mapped-file pairs reach the snippet here too. Same volume anchoring as above.
    rtc_hdr = Sys.iswindows() ? string(first(splitdrive(@__DIR__)), "/rtc_probe.h") : "/rtc_probe.h"
    with_header = CC.LLVMOnlyAction(lctx)
    @test CC.runToolOnCodeWithArgs(with_header, "#include <$rtc_hdr>\nint rtc_uses() { return RTC_V; }\n",
                                   ["-std=c++17"]; virtual_files=[rtc_hdr => "#define RTC_V 7\n"]) == true

    # None of the three may be disposed: clang destroyed each one before returning.
    CC.LLVM.dispose(lctx)
end

@testset "ToolInvocation | one action over one synthetic command line" begin
    mktempdir() do dir
        src = joinpath(dir, "ti_probe.cc")
        write(src, "int ti_probe(int a) { return a + 2; }\n")

        fm = CC.FileManager()
        lctx = CC.LLVM.Context()

        act = CC.LLVMOnlyAction(lctx)
        ti = CC.ToolInvocation(["clang-tool", "-std=c++17", src], act, fm)
        buf = CC.TextDiagnosticBuffer()
        CC.setDiagnosticConsumer(ti, buf)
        opts = CC.DiagnosticOptions()
        CC.setDiagnosticOptions(ti, opts)
        @test CC.run(ti) == true
        @test Base.size(buf, TOOLING_ERR) == 0
        # disposing the invocation deletes the action it adopted, so `act` must not be
        dispose(ti)
        # `opts`, by contrast, stays ours: it is handed back already holding our reference,
        # so run()'s stack printer and engine borrow it 1 -> 2 -> 1 and this dispose is the
        # one that frees. Disposing it here aborted before the refcount conversion.
        dispose(buf)
        dispose(opts)

        # A second invocation over the *same* `fm` is the point of this half: a run parks the
        # file manager in a CompilerInstance that outlives nothing, so a manager that did not
        # come out of the constructor pre-retained would already be freed here. Keep the two
        # invocations sharing one manager.
        #
        # A command line naming a file that is not there cannot run, and says so.
        act2 = CC.LLVMOnlyAction(lctx)
        ti2 = CC.ToolInvocation(["clang-tool", "-std=c++17", joinpath(dir, "no_such.cc")], act2, fm)
        buf2 = CC.TextDiagnosticBuffer()
        CC.setDiagnosticConsumer(ti2, buf2)
        @test CC.run(ti2) == false
        dispose(ti2)
        dispose(buf2)

        CC.LLVM.dispose(lctx)
        dispose(fm)
    end
end

@testset "ClangTool | a whole project's translation units in one call" begin
    # ClangTool::run chdirs into the database's directory and pushes every source path
    # through llvm::sys::path::native() before the driver looks it up, while a mapped file is
    # only inserted when is_absolute accepts its key. On Windows "/" is neither a valid
    # working directory nor an absolute path, so anchor both on a real directory; joinpath
    # gives native separators, so the mapping key and the looked-up path stay identical.
    # Upstream clang guards the same construction with #ifndef _WIN32.
    ct_dir = @__DIR__
    ct_a, ct_b = joinpath(ct_dir, "cta.cc"), joinpath(ct_dir, "ctb.cc")
    db = CC.FixedCompilationDatabase(ct_dir, String[])
    tool = CC.ClangTool(db, [ct_a, ct_b])

    # the source paths are copied into the tool and read back in order
    @test CC.getNumSourcePaths(tool) == 2
    @test CC.getSourcePath(tool, 0) == ct_a
    @test CC.getSourcePath(tool, 1) == ct_b
    @test_throws AssertionError CC.getSourcePath(tool, 2)
    @test !CC.is_null_handle(CC.getFiles(tool))
    CC.setPrintErrorMessage(tool, false)

    # the adjuster chain accepts an append and a clear; both are copies, so the handle stays
    adj = CC.getInsertArgumentAdjuster("-DCT_UNUSED=1")
    CC.appendArgumentsAdjuster(tool, adj)
    CC.clearArgumentsAdjusters(tool)
    @test CC.adjust(adj, ["clang++"], "x.cc") == ["clang++", "-DCT_UNUSED=1"]
    dispose(adj)

    # neither file exists on disk; both are mapped into the tool's in-memory file system
    CC.mapVirtualFile(tool, ct_a, "void cta() {}")
    CC.mapVirtualFile(tool, ct_b, "void ctb() {}")

    asts, status = CC.buildASTs(tool)
    @test status == 0
    @test length(asts) == 2
    @test sort([basename(CC.getMainFileName(a)) for a in asts]) == ["cta.cc", "ctb.cc"]
    for a in asts
        @test CC.isMainFileAST(a) == false
        @test CC.top_level_size(a) >= 1
        dispose(a)
    end

    dispose(tool)
    dispose(db)
end
