using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

"The whole command line of `cc`, read back one argument at a time."
command_line(cc) = String[CC.getCommandLineArg(cc, i) for i = 0:(CC.getNumCommandLineArgs(cc) - 1)]

@testset "CompileCommand | the five fields round-trip" begin
    cc = CC.CompileCommand("/proj", "a.cc", ["clang++", "-Wall", "a.cc"], "a.o")
    @test CC.getDirectory(cc) == "/proj"
    @test CC.getFilename(cc) == "a.cc"
    @test CC.getOutput(cc) == "a.o"
    @test command_line(cc) == ["clang++", "-Wall", "a.cc"]
    @test CC.getNumCommandLineArgs(cc) == 3
    # Heuristic is not a constructor field: only an inferred command ever carries one.
    @test CC.getHeuristic(cc) == ""
    @test_throws AssertionError CC.getCommandLineArg(cc, 3)
    @test_throws AssertionError CC.getCommandLineArg(cc, -1)

    # `equals` is clang's operator==, i.e. all five fields, and is a different question from
    # `==` on the carriers, which is handle identity as it is everywhere else in the package.
    same = CC.CompileCommand("/proj", "a.cc", ["clang++", "-Wall", "a.cc"], "a.o")
    other = CC.CompileCommand("/proj", "b.cc", ["clang++", "-Wall", "b.cc"], "b.o")
    @test CC.equals(cc, same)
    @test !CC.equals(cc, other)
    @test cc != same

    dispose(other)
    dispose(same)
    dispose(cc)
end

@testset "FixedCompilationDatabase | one command line, every file" begin
    db = CC.FixedCompilationDatabase("/proj", ["-Wall", "-std=c++17"])

    cmds = CC.getCompileCommands(db, "sub/a.cc")
    @test CC.getNumCommands(cmds) == 1
    cc = CC.getCommand(cmds, 0)
    # The database supplies argv[0] itself and appends the queried file as the positional
    # argument, so the flags it was built with sit between the two.
    #
    # argv[0] is NOT the bare "clang-tool" the name suggests: FixedCompilationDatabase
    # resolves it against the running executable's own directory, so under the test runner
    # it comes back as an absolute path inside Julia's `bin`. The directory is the host's
    # business; that the tool name is what was asked for is not.
    argv = command_line(cc)
    @test basename(argv[1]) == "clang-tool"
    @test argv[2:end] == ["-Wall", "-std=c++17", "sub/a.cc"]
    @test CC.getFilename(cc) == "sub/a.cc"
    @test CC.getDirectory(cc) == "/proj"
    @test CC.getOutput(cc) == ""
    @test_throws AssertionError CC.getCommand(cmds, 1)

    # It answers for a file it has never heard of, which is the point of it -- and the same
    # flags come back with the new file appended.
    other = CC.getCompileCommands(db, "elsewhere/z.cpp")
    @test CC.getNumCommands(other) == 1
    @test CC.getFilename(CC.getCommand(other, 0)) == "elsewhere/z.cpp"

    # ... but it cannot enumerate: getAllFiles is the base class's empty default, and
    # getAllCompileCommands is built out of it.
    @test isempty(CC.getAllFiles(db))
    all_cmds = CC.getAllCompileCommands(db)
    @test CC.getNumCommands(all_cmds) == 0

    dispose(all_cmds)
    dispose(other)
    dispose(cmds)
    dispose(db)
end

@testset "FixedCompilationDatabase | loading flags from a buffer and a file" begin
    db, msg = CC.loadFromBuffer(CC.FixedCompilationDatabase, "/proj", "-Wall\n-DFOO=1")
    @test db !== nothing
    @test isempty(msg)
    cmds = CC.getCompileCommands(db, "a.cc")
    args = command_line(CC.getCommand(cmds, 0))
    @test basename(args[1]) == "clang-tool"   # absolute under the runner; see above
    @test args[end] == "a.cc"
    @test "-Wall" in args
    @test "-DFOO=1" in args
    dispose(cmds)
    dispose(db)

    # the same text through the on-disk loader gives the same flags
    mktempdir() do dir
        path = joinpath(dir, "compile_flags.txt")
        write(path, "-Wall\n-DFOO=1\n")
        fdb, ferr = CC.loadFromFile(CC.FixedCompilationDatabase, path)
        @test fdb !== nothing
        @test isempty(ferr)
        fcmds = CC.getCompileCommands(fdb, "a.cc")
        fargs = command_line(CC.getCommand(fcmds, 0))
        @test "-Wall" in fargs
        @test "-DFOO=1" in fargs
        dispose(fcmds)
        dispose(fdb)

        # a path that is not there is a load failure, and the reason comes back with it
        missing_db, missing_err = CC.loadFromFile(CC.FixedCompilationDatabase, joinpath(dir, "no_such_flags.txt"))
        @test missing_db === nothing
        @test !isempty(missing_err)
    end
end

@testset "FixedCompilationDatabase | the -- separator decides everything" begin
    # No separator: no database, and the argument count is left exactly as it was.
    none, argc, _ = CC.loadFromCommandLine(["clang-tool", "-v", "a.cc"])
    @test none === nothing
    @test argc == 3

    # An empty command line is refused before anything is parsed.
    empty_db, empty_argc, _ = CC.loadFromCommandLine(String[])
    @test empty_db === nothing
    @test empty_argc == 0

    # With a separator, the count is cut back to the arguments before it whether or not the
    # flags after it turn out to describe a compilation clang can strip positionals from.
    _, cut, _ = CC.loadFromCommandLine(["clang-tool", "-v", "--", "-Wall", "a.cc"])
    @test cut == 2
end

@testset "CompilationDatabase | no database to auto-detect" begin
    # A directory with nothing in it has no compilation database, at any of the three entry
    # points, and each says so rather than handing back an empty one.
    mktempdir() do dir
        db, msg = CC.loadFromDirectory(dir)
        @test db === nothing
        @test !isempty(msg)

        sdb, smsg = CC.autoDetectFromSource(joinpath(dir, "a.cc"))
        @test sdb === nothing
        @test !isempty(smsg)

        ddb, dmsg = CC.autoDetectFromDirectory(dir)
        @test ddb === nothing
        @test !isempty(dmsg)
    end
end

@testset "transferCompileCommand | re-pointing a command at another file" begin
    cc = CC.CompileCommand("/proj", "a.cc", ["clang++", "-std=c++17", "-c", "a.cc"], "a.o")
    moved = CC.transferCompileCommand(cc, "/proj/a.h")

    @test CC.getFilename(moved) == "/proj/a.h"
    # clang documents the shape of the result: it always ends in {"--", Filename}
    args = command_line(moved)
    @test args[end] == "/proj/a.h"
    @test args[end - 1] == "--"
    # the source command is only read
    @test CC.getFilename(cc) == "a.cc"
    @test command_line(cc) == ["clang++", "-std=c++17", "-c", "a.cc"]

    dispose(moved)
    dispose(cc)
end
