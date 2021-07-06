# Other options like `DiagnosticOptions` are living in the corresponding source files

"""
    mutable struct CodeGenOptions <: Any
Holds a pointer to a `clang::CodeGenOptions` object.
"""
mutable struct CodeGenOptions
    ptr::CXCodeGenOptions
end

function get_Argv0(x::CodeGenOptions)
    @assert x.ptr != C_NULL "codegen options has a NULL pointer."
    return unsafe_string(clang_CodeGenOptions_getArgv0(x.ptr))
end

function get_command_line_args(x::CodeGenOptions)
    @assert x.ptr != C_NULL "codegen options has a NULL pointer."
    n = clang_CodeGenOptions_getCommandLineArgsNum(x.ptr)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_CodeGenOptions_getCommandLineArgs(x.ptr, files, n)
    return unsafe_string.(files)
end

function status(x::CodeGenOptions)
    @assert x.ptr != C_NULL "codegen options has a NULL pointer."
    return clang_CodeGenOptions_PrintStats(x.ptr)
end

"""
    mutable struct FrontendOptions <: Any
Holds a pointer to a `clang::FrontendOptions` object.
"""
mutable struct FrontendOptions
    ptr::CXFrontendOptions
end

function get_modules_embed_files(x::FrontendOptions)
    @assert x.ptr != C_NULL "frontend options has a NULL pointer."
    n = clang_FrontendOptions_getModulesEmbedFilesNum(x.ptr)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x.ptr, files, n)
    return unsafe_string.(files)
end

function status(x::FrontendOptions)
    @assert x.ptr != C_NULL "frontend options has a NULL pointer."
    return clang_FrontendOptions_PrintStats(x.ptr)
end
