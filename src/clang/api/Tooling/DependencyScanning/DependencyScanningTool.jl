# DependencyScanningTool

"""
    DependencyScanningTool(service::AbstractDependencyScanningService)
Create one scanning worker over `service`, running against the physical file system (Clang's
own default).

The tool holds a reference to the service's shared cache, so dispose it *before* the
service.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function DependencyScanningTool(service::AbstractDependencyScanningService)
    @check_ptrs service
    ptr = clang_DependencyScanningTool_create(service)
    @assert ptr != C_NULL "Failed to create DependencyScanningTool"
    return DependencyScanningTool(ptr)
end

dispose(x::DependencyScanningTool) = clang_DependencyScanningTool_dispose(x)

"""
    getDependencyFile(x::AbstractDependencyScanningTool, command_line::AbstractVector{<:AbstractString},
                      cwd::AbstractString) -> (Bool, String)
Scan the translation unit named by `command_line` and return its header dependencies.

`command_line` is a full clang *driver* command line, driver name included, exactly as a
compilation database records it; `cwd` is the directory its relative paths resolve against.
The answer is in the format the service was configured for — Make format, i.e. what `-MD`
writes, by default.

The point of going through the scanner rather than a parse is speed: in
`CXScanningMode_DependencyDirectivesScan` only the directives that decide includes are
lexed.

Clang returns an `llvm::Expected<std::string>`, so the first half of the tuple says whether
the scan succeeded and the second is either the dependency file or the diagnostics Clang
emitted.
"""
function getDependencyFile(x::AbstractDependencyScanningTool,
                           command_line::AbstractVector{<:AbstractString},
                           cwd::AbstractString)
    @check_ptrs x
    @assert !isempty(command_line) "the command line must at least name the driver"
    args = String[String(a) for a in command_line]
    ok = Ref{Bool}(false)
    out = get_string(clang_DependencyScanningTool_getDependencyFile(x, args, length(args),
                                                                    cwd, ok))
    return ok[], out
end
