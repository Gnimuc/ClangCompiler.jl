# FrontendOptions
function getModulesEmbedFilesNum(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getModulesEmbedFilesNum(x)
end

function getModulesEmbedFiles(x::FrontendOptions)
    @check_ptrs x
    n = getModulesEmbedFilesNum(x)
    files = Vector{Ptr{Cchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x, files, n)
    return [unsafe_string(p) for p in files]
end

function PrintStats(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_PrintStats(x)
end
