using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# A compile_commands.json with one entry in each of the two shapes clang accepts: a `command`
# string that gets unescaped, and an `arguments` array that does not.
# JSONCompilationDatabase indexes each entry by an absolute native path, taking the entry's
# name directly when llvm::sys::path::is_absolute accepts it and joining it onto "directory"
# otherwise. On Windows a bare "/ccproj/a.cc" fails that test -- absolute there needs a root
# name, not just a root directory -- so the key it stores and the key a lookup builds come
# out different and every query returns nothing. Anchor on this file's volume. Forward
# slashes throughout: they are native enough for LLVM and need no JSON escaping.
const CCDB_ROOT = Sys.iswindows() ? string(first(splitdrive(@__DIR__)), "/ccproj") : "/ccproj"

const CCDB_JSON = """
[
  {"directory": "$CCDB_ROOT",
   "file": "$CCDB_ROOT/a.cc",
   "command": "clang++ -std=c++17 -DFROM_COMMAND=1 -c $CCDB_ROOT/a.cc -o a.o"},
  {"directory": "$CCDB_ROOT",
   "file": "$CCDB_ROOT/b.cc",
   "arguments": ["clang++", "-DFROM_ARGUMENTS=1", "-c", "$CCDB_ROOT/b.cc"]}
]
"""

ccdb_args(cc) = String[CC.getCommandLineArg(cc, i)
                       for i in 0:(CC.getNumCommandLineArgs(cc) - 1)]

@testset "JSONCompilationDatabase | a database parsed out of memory enumerates" begin
    db, err = CC.loadFromBuffer(CC.JSONCompilationDatabase, CCDB_JSON)
    @test db !== nothing
    @test isempty(err)

    # Unlike the fixed database, this one knows its files -- both of them, and only them.
    files = CC.getAllFiles(db)
    @test length(files) == 2
    @test sort([basename(f) for f in files]) == ["a.cc", "b.cc"]

    all_cmds = CC.getAllCompileCommands(db)
    @test CC.getNumCommands(all_cmds) == 2

    # Query by the path the database itself reports, so the test does not depend on how the
    # host spells a native path.
    for f in files
        cmds = CC.getCompileCommands(db, f)
        @test CC.getNumCommands(cmds) == 1
        cc = CC.getCommand(cmds, 0)
        @test basename(CC.getFilename(cc)) == basename(f)
        @test basename(CC.getDirectory(cc)) == "ccproj"
        args = ccdb_args(cc)
        @test args[1] == "clang++"
        # each entry's own define survives, whichever of the two shapes it was written in
        want = basename(f) == "a.cc" ? "-DFROM_COMMAND=1" : "-DFROM_ARGUMENTS=1"
        @test want in args
        # an authoritative command carries no heuristic; only an inferred one does
        @test CC.getHeuristic(cc) == ""
        dispose(cmds)
    end

    # a file the database has never heard of gets no command at all
    unknown = CC.getCompileCommands(db, "/nowhere/zz.cc")
    @test CC.getNumCommands(unknown) == 0

    dispose(unknown)
    dispose(all_cmds)
    dispose(db)
end

@testset "JSONCompilationDatabase | a malformed database is a load failure" begin
    # an array entry with none of the required keys
    bad, msg = CC.loadFromBuffer(CC.JSONCompilationDatabase, "[{}]")
    @test bad === nothing
    @test !isempty(msg)

    mktempdir() do dir
        gone, ferr = CC.loadFromFile(CC.JSONCompilationDatabase,
                                     joinpath(dir, "compile_commands.json"))
        @test gone === nothing
        @test !isempty(ferr)
    end
end

@testset "JSONCompilationDatabase | loading the same database off disk" begin
    mktempdir() do dir
        write(joinpath(dir, "compile_commands.json"), CCDB_JSON)

        db, err = CC.loadFromFile(CC.JSONCompilationDatabase,
                                  joinpath(dir, "compile_commands.json"))
        @test db !== nothing
        @test isempty(err)
        @test length(CC.getAllFiles(db)) == 2
        dispose(db)

        # the generic loader finds the same file by name in that directory
        found, _ = CC.loadFromDirectory(dir)
        @test found !== nothing
        @test length(CC.getAllFiles(found)) == 2
        dispose(found)

        # and auto-detection walks up to it from a source file one level below
        detected, _ = CC.autoDetectFromSource(joinpath(dir, "sub", "deep.cc"))
        @test detected !== nothing
        @test length(CC.getAllFiles(detected)) == 2
        dispose(detected)

        from_dir, _ = CC.autoDetectFromDirectory(joinpath(dir, "sub"))
        @test from_dir !== nothing
        @test length(CC.getAllFiles(from_dir)) == 2
        dispose(from_dir)
    end
end

@testset "CompilationDatabase | the wrapping databases infer, retarget and expand" begin
    # inferMissingCompileCommands answers for a header the database never lists, by
    # transplanting the command of the file it looks most like -- and says so.
    base, _ = CC.loadFromBuffer(CC.JSONCompilationDatabase, CCDB_JSON)
    @test base !== nothing
    listed = CC.getAllFiles(base)
    probe = replace(listed[1], r"\.cc$" => ".h")
    # the unwrapped database has nothing to say about the header
    none = CC.getCompileCommands(base, probe)
    @test CC.getNumCommands(none) == 0
    dispose(none)

    inferred = CC.inferMissingCompileCommands(base)   # consumes `base`
    cmds = CC.getCompileCommands(inferred, probe)
    @test CC.getNumCommands(cmds) == 1
    guess = CC.getCommand(cmds, 0)
    @test basename(CC.getFilename(guess)) == basename(probe)
    # a guessed command explains itself, which is exactly what tells it apart from a read one
    @test !isempty(CC.getHeuristic(guess))
    # the wrapper still reports the underlying database's own contents
    @test length(CC.getAllFiles(inferred)) == 2
    dispose(cmds)
    dispose(inferred)

    # The other two wrappers defer to their base for everything they do not rewrite, so a
    # file the base knows still comes back with exactly one command through both of them.
    for wrap in (CC.inferTargetAndDriverMode, CC.expandResponseFiles)
        db, _ = CC.loadFromBuffer(CC.JSONCompilationDatabase, CCDB_JSON)
        @test db !== nothing
        f = CC.getAllFiles(db)[1]
        wrapped = wrap(db)                            # consumes `db`
        wcmds = CC.getCompileCommands(wrapped, f)
        @test CC.getNumCommands(wcmds) == 1
        @test basename(CC.getFilename(CC.getCommand(wcmds, 0))) == basename(f)
        dispose(wcmds)
        dispose(wrapped)
    end
end
