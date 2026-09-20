using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# The commands BuildCompilation produced. Everything below builds throwaway drivers on
# throwaway DiagnosticsEngines, pinned to one triple so the plan does not depend on the host,
# and disposes them in reverse-dependency order. Diagnostics are swallowed: the input files
# are phony and only argument processing is exercised.

const JOB_TRIPLE = "x86_64-unknown-linux-gnu"

function job_driver()
    diags = CC.DiagnosticsEngine(CC.DiagnosticIDs(), CC.DiagnosticOptions(), CC.IgnoringDiagConsumer(), true)
    drv = CC.Driver(joinpath("usr", "bin", "clang"), JOB_TRIPLE, diags)
    CC.setCheckInputsExist(drv, false)
    return drv, diags
end

@testset "JobList | the -cc1 command a syntax-only line derives" begin
    drv, diags = job_driver()
    src = "clangcompiler-job-test.cpp"
    comp = CC.BuildCompilation(drv, ["clang", "-fsyntax-only", src])

    jobs = CC.getJobs(comp)
    @test !isempty(jobs)
    @test size(jobs) >= 1
    # the list is indexed without a bounds check, so the wrapper supplies one
    @test_throws AssertionError CC.getJob(jobs, size(jobs))
    @test_throws AssertionError CC.getJob(jobs, -1)

    cmd = CC.getJob(jobs, 0)
    @test occursin("clang", CC.getExecutable(cmd))

    # This is the whole point of the wrapper: the exact argument vector the driver derived,
    # which is what CompilerInvocation.CreateFromArgs consumes.
    args = CC.getArguments(cmd)
    @test length(args) == CC.getNumArguments(cmd)
    @test args[1] == CC.getArgument(cmd, 0)
    @test args[2] == CC.getArgument(cmd, 1)
    @test "-cc1" in args
    @test "-fsyntax-only" in args
    @test src in args
    @test "-triple" in args
    @test JOB_TRIPLE in args
    @test_throws AssertionError CC.getArgument(cmd, CC.getNumArguments(cmd))

    # Command's constructor keeps only the inputs that are filenames, so every input reports
    # that tag and neither of the other two -- and the debugging rendering agrees with it.
    n = CC.getNumInputInfos(cmd)
    @test n >= 1
    for i = 0:(n - 1)
        @test CC.isInputInfoFilename(cmd, i)
        @test !CC.isInputInfoNothing(cmd, i)
        @test !CC.isInputInfoInputArg(cmd, i)
        @test CC.getInputInfoAsString(cmd, i) == "\"" * CC.getInputInfoFilename(cmd, i) * "\""
    end
    @test CC.getInputInfoFilename(cmd, 0) == src
    @test CC.getInputInfoBaseInput(cmd, 0) == src
    # a .cpp input is typed as C++, which is what the driver's own type table says
    @test CC.isCXX(CC.getInputInfoType(cmd, 0))
    @test_throws AssertionError CC.getInputInfoType(cmd, n)

    # -fsyntax-only writes nothing, so the output list is where the two shapes differ (the
    # -c line below has one).
    @test CC.getNumOutputFilenames(cmd) == 0
    @test CC.getOutputFilenames(cmd) == String[]
    @test_throws AssertionError CC.getOutputFilename(cmd, 0)

    # The rendered command is the `-###` line: the executable plus the arguments.
    printed = CC.Print(cmd)
    # clang quotes the executable in the rendered line and escapes backslashes inside those
    # quotes, so on Windows the rendering carries doubled separators the raw path does not.
    exe = CC.getExecutable(cmd)
    @test occursin(Sys.iswindows() ? replace(exe, "\\" => "\\\\") : exe, printed)
    @test occursin("-fsyntax-only", printed)
    # and the list's rendering contains each of its commands'
    whole = CC.Print(jobs)
    @test occursin("-cc1", whole)
    @test length(whole) >= length(printed)

    # The tool that built it, folded in through getCreator.
    tool = CC.getCreator(cmd)
    @test CC.getName(tool) == "clang"
    # the diagnostic name is not the internal name, so a shim returning either
    # field for both still fails one of these
    @test CC.getShortName(tool) == "clang frontend"
    @test !CC.isLinkJob(tool)
    # the toolchain reached through the tool is the one the compilation was built for
    @test CC.getTripleString(CC.getToolChain(tool)) == CC.getTripleString(CC.getDefaultToolChain(comp))

    dispose(comp)
    dispose(drv)
    dispose(diags)
end

@testset "JobList | outputs, the link job, and clearing the plan" begin
    drv, diags = job_driver()
    src = "clangcompiler-job-test.cpp"
    obj = joinpath(tempdir(), "clangcompiler-job-test.o")
    comp = CC.BuildCompilation(drv, ["clang", "-c", src, "-o", obj])
    jobs = CC.getJobs(comp)
    @test size(jobs) >= 1
    cmd = CC.getJob(jobs, 0)
    # -c -o names the object the command writes, unlike the syntax-only line above
    @test CC.getOutputFilenames(cmd) == [obj]
    @test CC.getOutputFilename(cmd, 0) == obj
    dispose(comp)
    dispose(drv)
    dispose(diags)

    # A compile-and-link line plans a second command, and only that one is a link job -- the
    # predicate that finds the libraries and -L paths the driver settled on.
    drv2, diags2 = job_driver()
    exe = joinpath(tempdir(), "clangcompiler-job-test.out")
    link = CC.BuildCompilation(drv2, ["clang", src, "-o", exe])
    ljobs = CC.getJobs(link)
    tools = [CC.getCreator(CC.getJob(ljobs, i)) for i = 0:(size(ljobs) - 1)]
    @test !isempty(tools)
    @test any(CC.isLinkJob, tools)
    @test !all(CC.isLinkJob, tools)

    # clear drops the plan; the compilation keeps its temporary files.
    temps = CC.getTempFiles(link)
    CC.clear(ljobs)
    @test isempty(ljobs)
    @test size(ljobs) == 0
    @test CC.getTempFiles(link) == temps

    dispose(link)
    dispose(drv2)
    dispose(diags2)
end

@testset "Driver | executing a compilation without running it" begin
    drv, diags = job_driver()
    src = "clangcompiler-exec-test.cpp"

    # `-###` is the documented early return of Driver::ExecuteCompilation: the plan is
    # printed and nothing is spawned, so the result is a clean run on every host.
    comp = CC.BuildCompilation(drv, ["clang", "-###", "-fsyntax-only", src])
    code, failures = CC.ExecuteCompilation(drv, comp)
    @test code == 0
    @test isempty(failures)
    dispose(comp)
    dispose(drv)
    dispose(diags)

    # Compilation::ExecuteJobs with LogOnly does the same at the lower level: every command
    # is logged and none is run, so nothing fails.
    drv2, diags2 = job_driver()
    comp2 = CC.BuildCompilation(drv2, ["clang", "-fsyntax-only", src])
    jobs = CC.getJobs(comp2)
    @test !isempty(jobs)
    @test isempty(CC.ExecuteJobs(comp2, jobs; log_only=true))

    # Redirect stores the three paths in the compilation's own allocator, so the Julia
    # strings it was handed do not have to outlive the call. The plan is untouched by it.
    before = CC.Print(jobs)
    CC.Redirect(comp2; out_path=joinpath(tempdir(), "clangcompiler-redirect-out.txt"),
                err_path=joinpath(tempdir(), "clangcompiler-redirect-err.txt"))
    GC.gc()
    @test CC.Print(jobs) == before
    @test isempty(CC.ExecuteJobs(comp2, jobs; log_only=true))

    dispose(comp2)
    dispose(drv2)
    dispose(diags2)
end
