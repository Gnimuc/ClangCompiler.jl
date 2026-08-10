using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "ComputePreambleBounds finds where the include block ends" begin
    inv = CC.CompilerInvocation()
    lo = CC.getLangOpts(inv)

    # No directives at all: nothing belongs to the preamble.
    empty_bounds = CC.ComputePreambleBounds(lo, "int pb_x = 1;\n")
    @test empty_bounds.size == 0

    # The preamble is the leading directive run and stops at the first declaration, so its
    # size is where that declaration starts -- a number clang's lexer decides, and one this
    # test can name independently.
    head = "#include <stddef.h>\n#define PB_ONE 1\n"
    src = head * "int pb_y = PB_ONE;\n"
    bounds = CC.ComputePreambleBounds(lo, src)
    @test bounds.size == ncodeunits(head)
    @test bounds.ends_at_start_of_line == true
    # Same buffer, capped at one line: the cap really binds.
    @test CC.ComputePreambleBounds(lo, src, 1).size < bounds.size

    dispose(inv)
end

@testset "PrecompiledPreamble builds, reports and answers reuse" begin
    mktempdir() do dir
        hdr = joinpath(dir, "pcp_header.h")
        write(hdr, "#pragma once\nstruct PCPThing { int a; };\n")
        main = joinpath(dir, "pcp_main.cpp")
        head = "#include \"pcp_header.h\"\n"
        contents = head * "int pcp_value = 1;\n"
        write(main, contents)

        diag = CC.DiagnosticsEngine()
        inv = CC.createFromCommandLine(main, ["-std=c++17"], diag)
        lo = CC.getLangOpts(inv)
        bounds = CC.ComputePreambleBounds(lo, contents)
        @test bounds.size == ncodeunits(head)

        pre = CC.PrecompiledPreamble(inv, contents, main, bounds, diag;
                                     storage_path=dir)

        # What the preamble records about itself, checked against what went in.
        got = CC.getBounds(pre)
        @test got.size == bounds.size
        @test got.ends_at_start_of_line == bounds.ends_at_start_of_line
        @test CC.getContents(pre) == head
        # An on-disk PCH: clang reports 0 only when the filesystem query fails.
        @test CC.getSize(pre) > 0

        # Reuse is decided by the preamble bytes and the files they pulled in. Editing
        # below the preamble keeps it valid; editing the include line does not.
        below = head * "int pcp_value = 2;\nint pcp_other = 3;\n"
        @test CC.CanReuse(pre, inv, contents, main, bounds) == true
        @test CC.CanReuse(pre, inv, below, main, bounds) == true

        changed_head = "#include \"pcp_header.h\"\n#define PCP_EXTRA 1\n"
        changed = changed_head * "int pcp_value = 1;\n"
        changed_bounds = CC.ComputePreambleBounds(lo, changed)
        @test changed_bounds.size != bounds.size
        @test CC.CanReuse(pre, inv, changed, main, changed_bounds) == false

        # A header the preamble read, changed on disk, invalidates it even though the main
        # file is byte-for-byte the same.
        write(hdr, "#pragma once\nstruct PCPThing { int a; double b; };\n")
        @test CC.CanReuse(pre, inv, contents, main, bounds) == false

        # Rewiring an invocation to consume the preamble sets the implicit PCH include,
        # which is the field a later parse reads. Nothing else in this package sets it, so
        # an empty value before and a non-empty one after is the whole observable effect.
        target = CC.createFromCommandLine(main, ["-std=c++17"], diag)
        ppo = CC.getPreprocessorOpts(target)
        @test CC.getImplicitPCHInclude(ppo) == ""
        CC.OverridePreamble(pre, target, contents, main)
        # Read the value out BEFORE disposing the invocation that owns it: getPreprocessorOpts
        # hands back a borrowed interior pointer, so `ppo` dangles the moment `target` goes.
        # Comparing through it afterwards is a use-after-free -- it read back "" here, and
        # a freed read is exactly the sort of thing that trips LLVM's refcount assertion on
        # some runs and not others.
        overridden = CC.getImplicitPCHInclude(ppo)
        @test !isempty(overridden)
        dispose(target)

        implicit = CC.createFromCommandLine(main, ["-std=c++17"], diag)
        CC.AddImplicitPreamble(pre, implicit, contents, main)
        # both routes point the invocation at the same preamble PCH
        @test CC.getImplicitPCHInclude(CC.getPreprocessorOpts(implicit)) == overridden
        dispose(implicit)

        dispose(pre)
        dispose(inv)
        dispose(diag)
    end
end
