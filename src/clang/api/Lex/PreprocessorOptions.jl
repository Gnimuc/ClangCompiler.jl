# PreprocessorOptions
function PrintStats(x::PreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_PrintStats(x)
end
