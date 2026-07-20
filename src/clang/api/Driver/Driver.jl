# Driver
"""
    GetResourcesPath(binary_path::AbstractString) -> String
Compute the path to the Clang resource directory for the given compiler binary path. The
underlying two-call protocol copies exactly N bytes with no NUL terminator.
"""
function GetResourcesPath(binary_path::AbstractString)
    n = clang_Driver_GetResourcesPathLength(binary_path)
    path = Vector{Cuchar}(undef, n)
    n > 0 && clang_Driver_GetResourcesPath(binary_path, path, n)
    return String(path)
end
