# Job — the commands a Compilation was built out of.
#
# This is the `-###` view. Every handle here is borrowed from the compilation that built it,
# so there is nothing to dispose and nothing outlives that compilation.

# Number of `Command`s in the list. Spelled `Base.size` the way `CFGBlock`'s is, so the
# module's own `size` keeps meaning Base's everywhere else.
function Base.size(x::AbstractJobList)
    @check_ptrs x
    return Int(clang_JobList_size(x))
end

# Whether the list holds no commands at all.
function Base.isempty(x::AbstractJobList)
    @check_ptrs x
    return clang_JobList_empty(x)
end

"""
    getJob(x::AbstractJobList, i::Integer) -> Command
Return the `i`-th (0-based) command. The list is indexed without a bounds check, so the
wrapper supplies one.
"""
function getJob(x::AbstractJobList, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < size(x) "job index out of range"
    return Command(clang_JobList_getJob(x, i))
end

"""
    clear(x::AbstractJobList)
Drop every command from the list. The compilation keeps its temporary files; only the plan
goes.
"""
function clear(x::AbstractJobList)
    @check_ptrs x
    clang_JobList_clear(x)
    return nothing
end

"""
    Print(x::AbstractJobList; terminator::AbstractString="\\n", quote_args::Bool=true) -> String
Return the whole plan rendered the way `clang -###` prints it.
"""
function Print(x::AbstractJobList; terminator::AbstractString="\n", quote_args::Bool=true)
    @check_ptrs x
    return get_string(clang_JobList_Print(x, terminator, quote_args))
end

"""
    getExecutable(x::AbstractCommand) -> String
Return the program this command runs.
"""
function getExecutable(x::AbstractCommand)
    @check_ptrs x
    return unsafe_string(clang_Command_getExecutable(x))
end

"""
    getNumArguments(x::AbstractCommand) -> Int
Return how many arguments the command passes, not counting the executable itself.
"""
function getNumArguments(x::AbstractCommand)
    @check_ptrs x
    return Int(clang_Command_getNumArguments(x))
end

"""
    getArgument(x::AbstractCommand, i::Integer) -> String
Return the `i`-th (0-based) argument.
"""
function getArgument(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumArguments(x) "argument index out of range"
    return unsafe_string(clang_Command_getArgument(x, i))
end

"""
    getArguments(x::AbstractCommand) -> Vector{String}
Return the command's whole argument vector. For a `-cc1` command this is exactly what
[`CreateFromArgs`](@ref) consumes.
"""
function getArguments(x::AbstractCommand)
    @check_ptrs x
    n = getNumArguments(x)
    return String[unsafe_string(clang_Command_getArgument(x, i)) for i = 0:(n - 1)]
end

"""
    getNumOutputFilenames(x::AbstractCommand) -> Int
Return how many files this command writes.
"""
function getNumOutputFilenames(x::AbstractCommand)
    @check_ptrs x
    return Int(clang_Command_getNumOutputFilenames(x))
end

"""
    getOutputFilename(x::AbstractCommand, i::Integer) -> String
Return the `i`-th (0-based) file this command writes.
"""
function getOutputFilename(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOutputFilenames(x) "output filename index out of range"
    return get_string(clang_Command_getOutputFilename(x, i))
end

"""
    getOutputFilenames(x::AbstractCommand) -> Vector{String}
Return every file this command writes.
"""
function getOutputFilenames(x::AbstractCommand)
    @check_ptrs x
    n = getNumOutputFilenames(x)
    return String[get_string(clang_Command_getOutputFilename(x, i)) for i = 0:(n - 1)]
end

"""
    getNumInputInfos(x::AbstractCommand) -> Int
Return how many inputs this command consumes.
"""
function getNumInputInfos(x::AbstractCommand)
    @check_ptrs x
    return Int(clang_Command_getNumInputInfos(x))
end

"""
    isInputInfoNothing(x::AbstractCommand, i::Integer) -> Bool
Return whether the `i`-th (0-based) input carries no payload at all.
"""
function isInputInfoNothing(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return clang_Command_isInputInfoNothing(x, i)
end

"""
    isInputInfoFilename(x::AbstractCommand, i::Integer) -> Bool
Return whether the `i`-th (0-based) input is a filename — the tag
[`getInputInfoFilename`](@ref) requires.
"""
function isInputInfoFilename(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return clang_Command_isInputInfoFilename(x, i)
end

"""
    isInputInfoInputArg(x::AbstractCommand, i::Integer) -> Bool
Return whether the `i`-th (0-based) input is a parsed command-line argument rather than a
file.
"""
function isInputInfoInputArg(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return clang_Command_isInputInfoInputArg(x, i)
end

"""
    getInputInfoFilename(x::AbstractCommand, i::Integer) -> String
Return the file the `i`-th (0-based) input names.

The input must carry a filename — clang asserts on the other two tags — so ask
[`isInputInfoFilename`](@ref) first.
"""
function getInputInfoFilename(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    @assert clang_Command_isInputInfoFilename(x, i) "input $i is not a filename"
    return unsafe_string(clang_Command_getInputInfoFilename(x, i))
end

"""
    getInputInfoType(x::AbstractCommand, i::Integer) -> Int
Return the driver type ID of the `i`-th (0-based) input — the currency
[`getTypeName`](@ref) and the `types` predicates read.
"""
function getInputInfoType(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return Int(clang_Command_getInputInfoType(x, i))
end

"""
    getInputInfoBaseInput(x::AbstractCommand, i::Integer) -> String
Return the original file the `i`-th (0-based) input derives from, empty for an input the
driver synthesized.
"""
function getInputInfoBaseInput(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return get_string(clang_Command_getInputInfoBaseInput(x, i))
end

"""
    getInputInfoAsString(x::AbstractCommand, i::Integer) -> String
Return clang's own rendering of the `i`-th (0-based) input: the quoted filename,
`"(input arg)"` or `"(nothing)"`. Defined whatever the tag is.
"""
function getInputInfoAsString(x::AbstractCommand, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumInputInfos(x) "input index out of range"
    return get_string(clang_Command_getInputInfoAsString(x, i))
end

"""
    Print(x::AbstractCommand; terminator::AbstractString="\\n", quote_args::Bool=true) -> String
Return this one command rendered the way `clang -###` prints it.
"""
function Print(x::AbstractCommand; terminator::AbstractString="\n", quote_args::Bool=true)
    @check_ptrs x
    return get_string(clang_Command_Print(x, terminator, quote_args))
end

"""
    getCreator(x::AbstractCommand) -> Tool
Return the tool that built this command. Borrowed: tools are cached by their toolchain.
"""
function getCreator(x::AbstractCommand)
    @check_ptrs x
    return Tool(clang_Command_getCreator(x))
end

"""
    getName(x::AbstractTool) -> String
Return the tool's internal name, e.g. `"clang"` or `"darwin::Linker"`.
"""
function getName(x::AbstractTool)
    @check_ptrs x
    return unsafe_string(clang_Tool_getName(x))
end

"""
    getShortName(x::AbstractTool) -> String
Return the tool's diagnostic name, e.g. `"clang frontend"`.
"""
function getShortName(x::AbstractTool)
    @check_ptrs x
    return unsafe_string(clang_Tool_getShortName(x))
end

"""
    getToolChain(x::AbstractTool) -> ToolChain
Return the toolchain this tool belongs to. Borrowed, and it lives as long as the driver.
"""
function getToolChain(x::AbstractTool)
    @check_ptrs x
    return ToolChain(clang_Tool_getToolChain(x))
end

"""
    isLinkJob(x::AbstractTool) -> Bool
Return whether the tool links. This is what picks the link job out of a plan, and with it
the libraries and `-L` paths the driver decided on.
"""
function isLinkJob(x::AbstractTool)
    @check_ptrs x
    return clang_Tool_isLinkJob(x)
end
