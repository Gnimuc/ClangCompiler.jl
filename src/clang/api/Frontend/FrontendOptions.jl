# FrontendOptions
function getModulesEmbedFilesNum(x::FrontendOptions)
    @check_ptrs x
    n = clang_FrontendOptions_getModulesEmbedFilesNum(x)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x, files, n)
    return unsafe_string.(files)
end

function PrintStats(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_PrintStats(x)
end
