# Standalone entry points of namespace clang::tooling
#
# Each of these defaults the `PCHContainerOperations` clang leaves defaultable: the shim
# builds a fresh one per call, exactly as clang's own default argument does.

"""
    buildASTFromCode(code::AbstractString, filename::AbstractString="input.cc")
    -> Union{ASTUnit,Nothing}
Parse `code` as C++ in one call and return the resulting AST unit, or `nothing` when it could
not be built. `filename` is the name the snippet is mapped in as, and decides the language
clang infers from the extension.

Diagnostics go to stderr; [`buildASTFromCodeWithArgs`](@ref) is the overload that takes a
`DiagnosticConsumer` and flags.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function buildASTFromCode(code::AbstractString, filename::AbstractString="input.cc")
    ptr = clang_tooling_buildASTFromCode(code, filename)
    return ptr == C_NULL ? nothing : ASTUnit(ptr)
end

"""
    buildASTFromCodeWithArgs(code::AbstractString, args::AbstractVector{<:String};
                             filename="input.cc", tool_name="clang-tool", adjuster=nothing,
                             virtual_files=Pair{String,String}[], diag_consumer=nothing)
    -> Union{ASTUnit,Nothing}
Parse `code` with `args` on the command line and return the resulting AST unit, or `nothing`
when it could not be built.

`tool_name` is the binary name the standard library search paths are resolved relative to.
Each `name => content` pair in `virtual_files` is mapped in as an extra in-memory file, so
the snippet can `#include` it. `diag_consumer`, when given, receives the diagnostics instead
of stderr; it is borrowed and must outlive the call.

`adjuster` is applied to `args` alone — not to the whole command line, which clang builds
around the result by prepending `tool_name` and `-fsyntax-only` and appending `filename`.
Leaving it `nothing` does **not** mean "no adjustment": clang's own default then applies,
which is [`getClangStripDependencyFileAdjuster`](@ref). A supplied adjuster is copied, so it
still has to be disposed by whoever created it.

Supplying an adjuster therefore also requires a non-empty `args`, for the reason
[`adjust`](@ref) states: a `CXArgumentInsertPosition_BEGIN` adjuster steps over an `argv[0]`
that an empty vector does not have.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function buildASTFromCodeWithArgs(code::AbstractString, args::AbstractVector{<:String};
                                  filename::AbstractString="input.cc",
                                  tool_name::AbstractString="clang-tool",
                                  adjuster::Union{Nothing,AbstractArgumentsAdjuster}=nothing,
                                  virtual_files::AbstractVector{<:Pair{<:AbstractString,<:AbstractString}}=Pair{String,String}[],
                                  diag_consumer::Union{Nothing,AbstractDiagnosticConsumer}=nothing)
    adjuster === nothing || @check_ptrs adjuster
    diag_consumer === nothing || @check_ptrs diag_consumer
    @assert adjuster === nothing || !isempty(args) "an adjuster runs on `args`, whose first \
                                                    entry it treats as argv[0]"
    adj = adjuster === nothing ? CXArgumentsAdjuster(C_NULL) :
          Base.unsafe_convert(CXArgumentsAdjuster, adjuster)
    dc = diag_consumer === nothing ? CXDiagnosticConsumer(C_NULL) :
         Base.unsafe_convert(CXDiagnosticConsumer, diag_consumer)
    vnames = String[String(p.first) for p in virtual_files]
    vcontents = String[String(p.second) for p in virtual_files]
    ptr = clang_tooling_buildASTFromCodeWithArgs(code, args, length(args), filename,
                                                 tool_name, adj, vnames, vcontents,
                                                 length(vnames), dc)
    return ptr == C_NULL ? nothing : ASTUnit(ptr)
end

"""
    runToolOnCodeWithArgs(action::AbstractFrontendAction, code::AbstractString,
                          args::AbstractVector{<:String}; filename="input.cc",
                          tool_name="clang-tool", virtual_files=Pair{String,String}[]) -> Bool
Run `action` over `code` compiled with `-fsyntax-only` plus `args`, and return whether it ran
successfully.

!!! warning
    This **consumes** `action`: clang destroys it before returning, so the carrier is dangling
    afterwards — do not run it again and do not dispose it. Build a fresh action per call.

The overload taking an explicit virtual file system is not wrapped; there is no
`llvm::vfs::FileSystem` carrier yet.
"""
function runToolOnCodeWithArgs(action::AbstractFrontendAction, code::AbstractString,
                               args::AbstractVector{<:String};
                               filename::AbstractString="input.cc",
                               tool_name::AbstractString="clang-tool",
                               virtual_files::AbstractVector{<:Pair{<:AbstractString,<:AbstractString}}=Pair{String,String}[])
    @check_ptrs action
    vnames = String[String(p.first) for p in virtual_files]
    vcontents = String[String(p.second) for p in virtual_files]
    return clang_tooling_runToolOnCodeWithArgs(action, code, args, length(args), filename,
                                               tool_name, vnames, vcontents, length(vnames))
end

# ToolInvocation

"""
    ToolInvocation(command_line::AbstractVector{<:String}, action::AbstractFrontendAction,
                   files::AbstractFileManager) -> ToolInvocation
Build an invocation that runs `action` over the single synthetic `command_line`.

`command_line[1]` is the *binary name* clang locates its builtin headers relative to, not a
flag — `"clang-tool"` is the conventional filler — and the file to compile is an ordinary
positional argument of the rest.

!!! warning
    The invocation **adopts** `action` and deletes it in its own destructor, so the carrier
    must not be disposed afterwards and must not be handed to a second invocation.

`files` is borrowed: the invocation stores the raw pointer, so the file manager has to
outlive it.

`command_line` must not be empty — [`run`](@ref) reads its first entry as the binary name
before it looks at anything else.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ToolInvocation(command_line::AbstractVector{<:String},
                        action::AbstractFrontendAction, files::AbstractFileManager)
    @check_ptrs action files
    @assert !isempty(command_line) "a tool invocation needs at least its binary name"
    ptr = clang_ToolInvocation_create(command_line, length(command_line), action, files)
    @assert ptr != C_NULL "Failed to create ToolInvocation"
    return ToolInvocation(ptr)
end

dispose(x::ToolInvocation) = clang_ToolInvocation_dispose(x)

"""
    setDiagnosticConsumer(x::AbstractToolInvocation, dc::AbstractDiagnosticConsumer)
Install `dc` for both the driver's command-line parsing and the action itself. It is
borrowed and must outlive the invocation.
"""
function setDiagnosticConsumer(x::AbstractToolInvocation, dc::AbstractDiagnosticConsumer)
    @check_ptrs x dc
    return clang_ToolInvocation_setDiagnosticConsumer(x, dc)
end

"""
    setDiagnosticOptions(x::AbstractToolInvocation, opts::AbstractDiagnosticOptions)
Install `opts` for the driver's command-line parsing.

The invocation stores the options as a bare pointer, so they have to outlive it. They stay
the caller's: [`run`](@ref) lends them to a `TextDiagnosticPrinter` and a `DiagnosticsEngine`
built on the stack, each holding an `IntrusiveRefCntPtr` for the length of that run, and
because [`DiagnosticOptions`](@ref) hands back an object that already holds the caller's own
reference (MARSHALLING.md §12) those borrows run 1 → 2 → 1. Dispose them when you are done,
in either order relative to the invocation.
"""
function setDiagnosticOptions(x::AbstractToolInvocation, opts::AbstractDiagnosticOptions)
    @check_ptrs x opts
    return clang_ToolInvocation_setDiagnosticOptions(x, opts)
end

"""
    run(x::AbstractToolInvocation) -> Bool
Run the invocation and return whether it finished without errors.
"""
function run(x::AbstractToolInvocation)
    @check_ptrs x
    return clang_ToolInvocation_run(x)
end

# ClangTool

"""
    ClangTool(db::AbstractCompilationDatabase, source_paths::AbstractVector{<:String})
    -> ClangTool
Build a tool that runs over the translation units of `source_paths`, taking their flags from
`db`. A source path `db` knows nothing about is skipped.

`db` is **borrowed and stored by reference**, so it must outlive the tool — keep the carrier
alive for as long as the tool is used, and dispose the tool first.

The constructor installs the syntax-only and strip-output adjusters;
[`clearArgumentsAdjusters`](@ref) drops them.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function ClangTool(db::AbstractCompilationDatabase, source_paths::AbstractVector{<:String})
    @check_ptrs db
    ptr = clang_ClangTool_create(db, source_paths, length(source_paths))
    @assert ptr != C_NULL "Failed to create ClangTool"
    return ClangTool(ptr)
end

dispose(x::ClangTool) = clang_ClangTool_dispose(x)

"""
    mapVirtualFile(x::AbstractClangTool, file_path::AbstractString, content::AbstractString)
Map `content` in at `file_path` in the tool's in-memory file system, so a translation unit it
builds can read a file that is not on disk. Both strings are copied.
"""
function mapVirtualFile(x::AbstractClangTool, file_path::AbstractString,
                        content::AbstractString)
    @check_ptrs x
    return clang_ClangTool_mapVirtualFile(x, file_path, content)
end

"""
    appendArgumentsAdjuster(x::AbstractClangTool, adjuster::AbstractArgumentsAdjuster)
Append `adjuster` to the tool's chain; it runs on the output of the adjusters already there.

The closure is copied into the tool, so `adjuster` stays the caller's to dispose.
"""
function appendArgumentsAdjuster(x::AbstractClangTool, adjuster::AbstractArgumentsAdjuster)
    @check_ptrs x adjuster
    return clang_ClangTool_appendArgumentsAdjuster(x, adjuster)
end

"""
    clearArgumentsAdjusters(x::AbstractClangTool)
Drop the whole adjuster chain, the two the constructor installed included — after this the
command lines of the compilation database are used exactly as recorded.
"""
function clearArgumentsAdjusters(x::AbstractClangTool)
    @check_ptrs x
    return clang_ClangTool_clearArgumentsAdjusters(x)
end

"""
    setDiagnosticConsumer(x::AbstractClangTool, dc::AbstractDiagnosticConsumer)
Install `dc` for the parses the tool runs. It is borrowed and must outlive the tool.
"""
function setDiagnosticConsumer(x::AbstractClangTool, dc::AbstractDiagnosticConsumer)
    @check_ptrs x dc
    return clang_ClangTool_setDiagnosticConsumer(x, dc)
end

"""
    setPrintErrorMessage(x::AbstractClangTool, print_error_message::Bool)
Choose whether a failing action also prints a message to stderr. Clang's default is `true`.
"""
function setPrintErrorMessage(x::AbstractClangTool, print_error_message::Bool)
    @check_ptrs x
    return clang_ClangTool_setPrintErrorMessage(x, print_error_message)
end

"""
    getFiles(x::AbstractClangTool) -> FileManager
Return the file manager shared by every translation unit the tool builds. Borrowed: it is
owned by the tool.
"""
function getFiles(x::AbstractClangTool)
    @check_ptrs x
    return FileManager(clang_ClangTool_getFiles(x))
end

"""
    getNumSourcePaths(x::AbstractClangTool) -> Int
Return how many source paths the tool was constructed with.
"""
function getNumSourcePaths(x::AbstractClangTool)
    @check_ptrs x
    return Int(clang_ClangTool_getNumSourcePaths(x))
end

"""
    getSourcePath(x::AbstractClangTool, i::Integer) -> String
Return the `i`-th source path, counting from zero.
"""
function getSourcePath(x::AbstractClangTool, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumSourcePaths(x) "source path index out of range"
    return unsafe_string(clang_ClangTool_getSourcePath(x, i))
end

"""
    buildASTs(x::AbstractClangTool; capacity=max(getNumSourcePaths(x), 1))
    -> (Vector{ASTUnit}, Int)
Parse every translation unit the tool covers and return the units together with clang's
status code: `0` on success, `1` if any error occurred, `2` if nothing failed but some source
paths were skipped for want of a compile command.

Each returned unit is caller-owned — `dispose` every one of them, and do so before the tool.

One compile command yields one unit, which is not necessarily one unit per source path: a
file compiled into two targets has two commands. `capacity` sizes the buffer clang fills;
units beyond it are destroyed rather than leaked, and that loss is an error here rather than
a silent truncation, so a project whose database records more commands than source paths
needs a larger `capacity` passed in.
"""
function buildASTs(x::AbstractClangTool; capacity::Integer=max(getNumSourcePaths(x), 1))
    @check_ptrs x
    @assert capacity >= 0 "capacity must not be negative"
    buf = Vector{CXASTUnit}(undef, capacity)
    built = Ref{Cuint}(0)
    status = clang_ClangTool_buildASTs(x, buf, capacity, built)
    n = Int(built[])
    @assert n <= capacity "buildASTs produced $n units but only $capacity fitted; \
                           re-run with capacity=$n"
    return ASTUnit[ASTUnit(buf[i]) for i in 1:n], Int(status)
end
