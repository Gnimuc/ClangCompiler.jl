# CodeGenOptions
CodeGenOptions() = CodeGenOptions(create_codegen_options())

"""
    create_codegen_options() -> CXCodeGenOptions
Return a pointer to a `clang::CodeGenOptions` object.
"""
function create_codegen_options()
    opts = clang_CodeGenOptions_create()
    @assert opts != C_NULL "Failed to create CodeGenOptions"
    return opts
end

dispose(x::CodeGenOptions) = clang_CodeGenOptions_dispose(x)
function getArgv0(x::CodeGenOptions)
    @check_ptrs x
    return unsafe_string(clang_CodeGenOptions_getArgv0(x))
end

function getCommandLineArgs(x::CodeGenOptions)
    @check_ptrs x
    n = clang_CodeGenOptions_getCommandLineArgsNum(x)
    files = Vector{Ptr{Cuchar}}(undef, n)
    clang_CodeGenOptions_getCommandLineArgs(x, files, n)
    return unsafe_string.(files)
end

function PrintStats(x::CodeGenOptions)
    @check_ptrs x
    return clang_CodeGenOptions_PrintStats(x)
end
