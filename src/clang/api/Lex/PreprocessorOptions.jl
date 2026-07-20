# PreprocessorOptions
"""
    getIncludes(x::PreprocessorOptions) -> Vector{String}
Return the list of files forcibly included before any main source file.
"""
function getIncludes(x::PreprocessorOptions)
    @check_ptrs x
    n = clang_PreprocessorOptions_getIncludesNum(x)
    incs = Vector{Ptr{Cchar}}(undef, n)
    n > 0 && clang_PreprocessorOptions_getIncludes(x, incs, n)
    return unsafe_string.(incs)
end
function PrintStats(x::PreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_PrintStats(x)
end
