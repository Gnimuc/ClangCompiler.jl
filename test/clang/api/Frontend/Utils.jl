using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Test

const LXB_FU = CC.LibClangEx

@testset "DependencyCollector filters what it records" begin
    dc = CC.DependencyCollector()
    @test CC.getDependenciesNum(dc) == 0
    @test CC.getDependencies(dc) == String[]
    @test_throws AssertionError CC.getDependency(dc, 0)

    # The base class keeps user files and drops system ones -- that filter is the class's
    # own `sawDependency`, and offering it one of each is what shows the filter running.
    CC.maybeAddDependency(dc, "/proj/user_a.h")
    @test CC.getDependencies(dc) == ["/proj/user_a.h"]
    CC.maybeAddDependency(dc, "/usr/include/sys_b.h"; is_system=true)
    @test CC.getDependencies(dc) == ["/proj/user_a.h"]
    @test CC.needSystemDependencies(dc) == false

    # A file already seen is not recorded twice, and order is first-seen order.
    CC.maybeAddDependency(dc, "/proj/user_a.h")
    CC.maybeAddDependency(dc, "/proj/user_c.h")
    @test CC.getDependencies(dc) == ["/proj/user_a.h", "/proj/user_c.h"]
    @test CC.getDependency(dc, 1) == "/proj/user_c.h"
    @test_throws AssertionError CC.getDependency(dc, 2)

    dispose(dc)
end

@testset "DependencyFileGenerator writes what its options say" begin
    mktempdir() do dir
        dfile = joinpath(dir, "deps.d")
        opts = CC.DependencyOutputOptions()

        # Defaults straight from clang's constructor.
        @test CC.getIncludeSystemHeaders(opts) == false
        @test CC.getUsePhonyTargets(opts) == false
        @test CC.getAddMissingHeaderDeps(opts) == false
        @test CC.getIncludeModuleFiles(opts) == false
        @test CC.getOutputFormat(opts) == LXB_FU.CXDependencyOutputFormat_Make
        @test CC.getOutputFile(opts) == ""
        @test CC.getTargetsNum(opts) == 0
        @test_throws AssertionError CC.getTarget(opts, 0)

        CC.setOutputFile(opts, dfile)
        CC.setIncludeSystemHeaders(opts, true)
        CC.addTarget(opts, "dfg_target.o")
        @test CC.getOutputFile(opts) == dfile
        @test CC.getTargetsNum(opts) == 1
        @test CC.getTarget(opts, 0) == "dfg_target.o"
        CC.setOutputFormat(opts, LXB_FU.CXDependencyOutputFormat_NMake)
        @test CC.getOutputFormat(opts) == LXB_FU.CXDependencyOutputFormat_NMake
        CC.setOutputFormat(opts, LXB_FU.CXDependencyOutputFormat_Make)

        gen = CC.DependencyFileGenerator(opts)
        # The generator answers from the options it copied, where the base class always
        # answers false -- so this distinguishes the subclass from its base.
        @test CC.needSystemDependencies(gen) == true
        # And the filter that follows from it: a system header the base class would have
        # dropped is kept here.
        CC.maybeAddDependency(gen, "/usr/include/dfg_sys.h"; is_system=true)
        CC.maybeAddDependency(gen, joinpath(dir, "dfg_user.h"))
        @test CC.getDependenciesNum(gen) == 2

        # Everything was copied at construction, so releasing the options first must not
        # change what gets written.
        dispose(opts)

        diag = CC.DiagnosticsEngine()
        CC.finishedMainFile(gen, diag)
        @test isfile(dfile)
        written = read(dfile, String)
        @test occursin("dfg_target.o", written)
        @test occursin("dfg_sys.h", written)
        @test occursin("dfg_user.h", written)

        dispose(diag)
        dispose(gen)
    end
end

@testset "DependencyCollector records what a real parse reads" begin
    mktempdir() do dir
        hdr = joinpath(dir, "dcp_header.h")
        write(hdr, "#pragma once\nstruct DCPThing { int a; };\n")

        I = create_interpreter(["-std=c++17", "-I$dir"])
        dc = CC.DependencyCollector()
        CC.attachToPreprocessor(dc, CC.getPreprocessor(CC.get_instance(I)))

        @test CC.getDependenciesNum(dc) == 0
        @test !CC.is_null_handle(CC.parse(I, "#include \"dcp_header.h\"\n"))
        # The header is in the list because the preprocessor opened it, not because this
        # test put it there.
        @test any(d -> endswith(d, "dcp_header.h"), CC.getDependencies(dc))

        # The collector outlives the preprocessor whose callbacks point at it.
        dispose(I)
        dispose(dc)
    end
end

@testset "createInvocation carries the driver options the older entry point cannot" begin
    mktempdir() do dir
        src = joinpath(dir, "civ_main.cpp")
        write(src, "int civ_value = 1;\n")

        diag = CC.DiagnosticsEngine()

        inv = CC.createInvocation(src, ["-std=c++17"]; diag=diag)
        @test inv !== nothing
        feo = CC.getFrontendOpts(inv)
        @test CC.getInputsNum(feo) == 1
        @test endswith(CC.getInputFile(feo, 0), "civ_main.cpp")
        dispose(inv)

        # The captured list is the -cc1 line the driver produced, not the flags handed in.
        inv2, cc1 = CC.createInvocation(src, ["-std=c++17"]; diag=diag,
                                        capture_cc1_args=true)
        @test inv2 !== nothing
        @test "-cc1" in cc1
        @test "-std=c++17" in cc1
        @test any(a -> endswith(a, "civ_main.cpp"), cc1)
        # The driver expands the command line, so it says strictly more than was passed in.
        @test length(cc1) > 3
        dispose(inv2)

        # ProbePrecompiled is what turns `-include X.h` into `-include-pch X.h.pch` when the
        # sibling exists. The driver decides that purely from the filesystem, so the same
        # inputs give two different -cc1 lines depending only on the flag.
        hdr = joinpath(dir, "civ_pre.h")
        write(hdr, "struct CivPre { int a; };\n")
        write(hdr * ".pch", "not a real pch, only a sibling the driver can stat\n")

        args = ["-std=c++17", "-include", hdr]
        inv3, plain = CC.createInvocation(src, args; diag=diag, capture_cc1_args=true)
        inv4, probed = CC.createInvocation(src, args; diag=diag, probe_precompiled=true,
                                           capture_cc1_args=true)
        @test "-include" in plain
        @test !("-include-pch" in plain)
        @test "-include-pch" in probed
        @test hdr * ".pch" in probed
        inv3 === nothing || dispose(inv3)
        inv4 === nothing || dispose(inv4)

        dispose(diag)
    end
end
