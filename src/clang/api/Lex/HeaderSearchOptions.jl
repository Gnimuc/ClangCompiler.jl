# HeaderSearchOptions
function GetResourceDir(x::HeaderSearchOptions)
    @check_ptrs x
    n = clang_HeaderSearchOptions_GetResourceDirLength(x)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x, dir, n)
    return String(dir)
end

function GetResourceDir(x::HeaderSearchOptions, dir::String)
    @check_ptrs x
    clang_HeaderSearchOptions_GetResourceDir(x, dir, length(dir))
    return nothing
end

function PrintStats(x::HeaderSearchOptions)
    @check_ptrs x
    return clang_HeaderSearchOptions_PrintStats(x)
end
