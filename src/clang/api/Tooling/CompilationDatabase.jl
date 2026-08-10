# CompileCommand

"""
    CompileCommand(directory::AbstractString, filename::AbstractString,
                   command_line::AbstractVector{<:String}, output::AbstractString="")
    -> CompileCommand
Build a `clang::tooling::CompileCommand` describing one compilation: `filename` compiled from
working directory `directory` with `command_line` (whose first entry is the compiler itself),
producing `output`.

`Heuristic` is not a constructor field in clang and starts empty; only the interpolating
database `inferMissingCompileCommands` builds ever sets it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CompileCommand(directory::AbstractString, filename::AbstractString,
                        command_line::AbstractVector{<:String},
                        output::AbstractString="")
    ptr = clang_CompileCommand_create(directory, filename, command_line,
                                      length(command_line), output)
    @assert ptr != C_NULL "Failed to create CompileCommand"
    return CompileCommand(ptr)
end

dispose(x::CompileCommand) = clang_CompileCommand_dispose(x)

"""
    getDirectory(x::AbstractCompileCommand) -> String
Return the working directory the command was executed from.
"""
function getDirectory(x::AbstractCompileCommand)
    @check_ptrs x
    return unsafe_string(clang_CompileCommand_getDirectory(x))
end

"""
    getFilename(x::AbstractCompileCommand) -> String
Return the source file the command compiles.
"""
function getFilename(x::AbstractCompileCommand)
    @check_ptrs x
    return unsafe_string(clang_CompileCommand_getFilename(x))
end

"""
    getOutput(x::AbstractCompileCommand) -> String
Return the output file the command produces, empty when the database recorded none.
"""
function getOutput(x::AbstractCompileCommand)
    @check_ptrs x
    return unsafe_string(clang_CompileCommand_getOutput(x))
end

"""
    getHeuristic(x::AbstractCompileCommand) -> String
Return the short explanation an *inferred* command carries ("inferred from foo/bar.h"), and
the empty string for a command that came from an authoritative source.
"""
function getHeuristic(x::AbstractCompileCommand)
    @check_ptrs x
    return unsafe_string(clang_CompileCommand_getHeuristic(x))
end

"""
    getNumCommandLineArgs(x::AbstractCompileCommand) -> Int
Return how many arguments the recorded command line has, `argv[0]` included.
"""
function getNumCommandLineArgs(x::AbstractCompileCommand)
    @check_ptrs x
    return Int(clang_CompileCommand_getNumCommandLineArgs(x))
end

"""
    getCommandLineArg(x::AbstractCompileCommand, i::Integer) -> String
Return the `i`-th argument of the recorded command line, counting from zero.
"""
function getCommandLineArg(x::AbstractCompileCommand, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCommandLineArgs(x) "command line argument index out of range"
    return unsafe_string(clang_CompileCommand_getCommandLineArg(x, i))
end

"""
    equals(a::AbstractCompileCommand, b::AbstractCompileCommand) -> Bool
Return whether the two commands agree on all five fields, which is `CompileCommand`'s own
`operator==`.

This is a *value* comparison. `==` on the carriers keeps the package-wide meaning and
compares handles, so two separately built descriptions of one compilation are `equals` but
not `==`.
"""
function equals(a::AbstractCompileCommand, b::AbstractCompileCommand)
    @check_ptrs a b
    return clang_CompileCommand_equals(a, b)
end

# CompileCommandList

"""
    getNumCommands(x::AbstractCompileCommandList) -> Int
Return how many commands the query returned.
"""
function getNumCommands(x::AbstractCompileCommandList)
    @check_ptrs x
    return Int(clang_CompileCommandList_getNumCommands(x))
end

"""
    getCommand(x::AbstractCompileCommandList, i::Integer) -> CompileCommand
Return the `i`-th command of the list, counting from zero.

The result is *borrowed*: it points into `x` and must not be disposed, and reading it after
`dispose(x)` is a use-after-free.
"""
function getCommand(x::AbstractCompileCommandList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCommands(x) "compile command index out of range"
    return CompileCommand(clang_CompileCommandList_getCommand(x, i))
end

dispose(x::CompileCommandList) = clang_CompileCommandList_dispose(x)

# CompilationDatabase

"""
    loadFromDirectory(build_directory::AbstractString) -> (Union{CompilationDatabase,Nothing}, String)
Load the compilation database of `build_directory` — today that means the
`compile_commands.json` sitting in it — returning `nothing` and clang's explanation when
there is none.

The database is caller-owned: one should call `dispose` to release the resources after using
this object.
"""
function loadFromDirectory(build_directory::AbstractString)
    err = Ref{CXString}()
    ptr = clang_CompilationDatabase_loadFromDirectory(build_directory, err)
    return (ptr == C_NULL ? nothing : CompilationDatabase(ptr)), get_string(err[])
end

"""
    autoDetectFromSource(source_file::AbstractString) -> (Union{CompilationDatabase,Nothing}, String)
Look for a compilation database in every parent directory of `source_file` and load the
first one found, returning `nothing` and clang's explanation when there is none.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function autoDetectFromSource(source_file::AbstractString)
    err = Ref{CXString}()
    ptr = clang_CompilationDatabase_autoDetectFromSource(source_file, err)
    return (ptr == C_NULL ? nothing : CompilationDatabase(ptr)), get_string(err[])
end

"""
    autoDetectFromDirectory(source_dir::AbstractString) -> (Union{CompilationDatabase,Nothing}, String)
Look for a compilation database in `source_dir` and every parent directory of it, returning
`nothing` and clang's explanation when there is none.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function autoDetectFromDirectory(source_dir::AbstractString)
    err = Ref{CXString}()
    ptr = clang_CompilationDatabase_autoDetectFromDirectory(source_dir, err)
    return (ptr == C_NULL ? nothing : CompilationDatabase(ptr)), get_string(err[])
end

# One release for the whole hierarchy: `~CompilationDatabase` is virtual, so the subclasses
# need no dispose of their own and adding one would only invite disposing twice.
dispose(x::AbstractCompilationDatabase) = clang_CompilationDatabase_dispose(x)

"""
    getCompileCommands(x::AbstractCompilationDatabase, file_path::AbstractString) -> CompileCommandList
Return every command in which `file_path` was compiled — more than one when the project
compiles it into several targets, and none when the database does not know the file.

`file_path` is matched the way the database implementation matches it: a JSON database wants
the absolute, unresolved path its `file` entries carry.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getCompileCommands(x::AbstractCompilationDatabase, file_path::AbstractString)
    @check_ptrs x
    return CompileCommandList(clang_CompilationDatabase_getCompileCommands(x, file_path))
end

"""
    getAllCompileCommands(x::AbstractCompilationDatabase) -> CompileCommandList
Return every command in the database.

Only an *enumerable* database can answer this: the base class builds the answer out of
`getAllFiles`, which defaults to empty, so a [`FixedCompilationDatabase`](@ref) reports an
empty list however many queries it can serve.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getAllCompileCommands(x::AbstractCompilationDatabase)
    @check_ptrs x
    return CompileCommandList(clang_CompilationDatabase_getAllCompileCommands(x))
end

"""
    getAllFiles(x::AbstractCompilationDatabase) -> Vector{String}
Return the files the database can enumerate, and an empty vector for a database that cannot
— the base class's default.
"""
function getAllFiles(x::AbstractCompilationDatabase)
    @check_ptrs x
    return get_string(clang_CompilationDatabase_getAllFiles(x))
end

# FixedCompilationDatabase

"""
    FixedCompilationDatabase(directory::AbstractString, command_line::AbstractVector{<:String})
    -> FixedCompilationDatabase
Build a database that answers every query with one command line: `command_line` run from
`directory`, with `"clang-tool"` supplied as `argv[0]` and the queried file appended as the
positional argument. `command_line` therefore carries flags only.

Not enumerable: `getAllFiles` and `getAllCompileCommands` are empty for it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function FixedCompilationDatabase(directory::AbstractString,
                                  command_line::AbstractVector{<:String})
    ptr = clang_FixedCompilationDatabase_create(directory, command_line,
                                                length(command_line))
    @assert ptr != C_NULL "Failed to create FixedCompilationDatabase"
    return FixedCompilationDatabase(ptr)
end

"""
    loadFromCommandLine(argv::AbstractVector{<:String}, directory::AbstractString=".")
    -> (Union{FixedCompilationDatabase,Nothing}, Int, String)
Split `argv` at the first `"--"` and build a database from the flags after it, the shape a
clang tool's own `main` uses. Returns `nothing` when there is no `"--"`, together with the
number of arguments *before* the separator (all of `argv` in that case) and clang's message.

Note that clang leaves the message empty for the ordinary "no `--` here" outcome, so the
database, not the message, is what says whether this worked.

A `"--"` in last position is refused: clang reads `argv[0]` of the arguments *after* the
separator to build the driver it strips positional arguments with, so an empty tail
dereferences an empty vector.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function loadFromCommandLine(argv::AbstractVector{<:String}, directory::AbstractString=".")
    sep = findfirst(==("--"), argv)
    @assert sep === nothing || sep < length(argv) "the flags after \"--\" must not be empty"
    argc = Ref{Cint}(length(argv))
    err = Ref{CXString}()
    ptr = clang_FixedCompilationDatabase_loadFromCommandLine(argc, argv, err, directory)
    db = ptr == C_NULL ? nothing : FixedCompilationDatabase(ptr)
    return db, Int(argc[]), get_string(err[])
end

"""
    loadFromFile(::Type{FixedCompilationDatabase}, path::AbstractString)
    -> (Union{FixedCompilationDatabase,Nothing}, String)
Read flags one per line from `path` — a `compile_flags.txt` — returning `nothing` and the
reason when the file cannot be read.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function loadFromFile(::Type{FixedCompilationDatabase}, path::AbstractString)
    err = Ref{CXString}()
    ptr = clang_FixedCompilationDatabase_loadFromFile(path, err)
    return (ptr == C_NULL ? nothing : FixedCompilationDatabase(ptr)), get_string(err[])
end

"""
    loadFromBuffer(::Type{FixedCompilationDatabase}, directory::AbstractString,
                   data::AbstractString) -> (Union{FixedCompilationDatabase,Nothing}, String)
Read flags one per line from `data`, as if it were the `compile_flags.txt` of `directory`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function loadFromBuffer(::Type{FixedCompilationDatabase}, directory::AbstractString,
                        data::AbstractString)
    err = Ref{CXString}()
    ptr = clang_FixedCompilationDatabase_loadFromBuffer(directory, data, err)
    return (ptr == C_NULL ? nothing : FixedCompilationDatabase(ptr)), get_string(err[])
end

# Free functions of namespace clang::tooling

"""
    inferMissingCompileCommands(x::AbstractCompilationDatabase) -> CompilationDatabase
Wrap `x` in a database that *guesses* a command for files it does not know, by
transplanting the command of a similarly-named file it does. That is what gets a header
which never appears in `compile_commands.json` a usable command line, and a guessed command
carries the explanation [`getHeuristic`](@ref) reports.

`getAllFiles` and `getAllCompileCommands` still report `x`'s own contents.

!!! warning
    This **consumes** `x`: the wrapper takes ownership, so `dispose(x)` afterwards is a
    double free. Dispose the returned database instead — it takes `x` with it.
"""
function inferMissingCompileCommands(x::AbstractCompilationDatabase)
    @check_ptrs x
    return CompilationDatabase(clang_tooling_inferMissingCompileCommands(x))
end

"""
    inferTargetAndDriverMode(x::AbstractCompilationDatabase) -> CompilationDatabase
Wrap `x` in a database that adds the `-target` and `--driver-mode` flags implied by `argv[0]`
of the command line `x` returned — so a command recorded as `i686-linux-android-g++ ...`
compiles for the target its driver name names.

!!! warning
    This **consumes** `x`, exactly as [`inferMissingCompileCommands`](@ref) does.
"""
function inferTargetAndDriverMode(x::AbstractCompilationDatabase)
    @check_ptrs x
    return CompilationDatabase(clang_tooling_inferTargetAndDriverMode(x))
end

"""
    expandResponseFiles(x::AbstractCompilationDatabase) -> CompilationDatabase
Wrap `x` in a database that expands the `@response-file` arguments of the command lines it
returns, reading them through the real file system.

!!! warning
    This **consumes** `x`, exactly as [`inferMissingCompileCommands`](@ref) does.
"""
function expandResponseFiles(x::AbstractCompilationDatabase)
    @check_ptrs x
    return CompilationDatabase(clang_tooling_expandResponseFiles(x))
end

"""
    transferCompileCommand(x::AbstractCompileCommand, filename::AbstractString) -> CompileCommand
Re-point `x` at `filename`: most arguments survive untouched, the ones that name a language
or a standard are tweaked to suit the new file, and the result always ends in
`["--", filename]`.

This is the other half of getting flags for a header — take the command of a translation
unit that includes it and transfer it. `x` is only read.

`x`'s command line must not be empty: clang reads its `argv[0]` before parsing the rest.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function transferCompileCommand(x::AbstractCompileCommand, filename::AbstractString)
    @check_ptrs x
    @assert getNumCommandLineArgs(x) >= 1 "a command line to transfer needs its argv[0]"
    return CompileCommand(clang_tooling_transferCompileCommand(x, filename))
end
