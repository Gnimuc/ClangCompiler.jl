"""
    struct CodeGenOptions <: Any
Hold a pointer to a `clang::CodeGenOptions` object.
"""
struct CodeGenOptions
    ptr::CXCodeGenOptions
end

function get_Argv0(x::CodeGenOptions)
    @check_ptrs x
    return unsafe_string(clang_CodeGenOptions_getArgv0(x.ptr))
end

function get_command_line_args(x::CodeGenOptions)
    @check_ptrs x
    n = clang_CodeGenOptions_getCommandLineArgsNum(x.ptr)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_CodeGenOptions_getCommandLineArgs(x.ptr, files, n)
    return unsafe_string.(files)
end

function PrintStats(x::CodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_PrintStats(x.ptr)
end
