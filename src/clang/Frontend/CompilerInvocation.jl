"""
    struct CompilerInvocation <: Any
Holds a pointer to a `clang::CompilerInvocation` object.
"""
struct CompilerInvocation
    ptr::CXCompilerInvocation
end
CompilerInvocation() = CompilerInvocation(create_compiler_invocation())

"""
    create_compiler_invocation() -> CXCompilerInvocation
Return a pointer to a `clang::CompilerInvocation` object.
"""
function create_compiler_invocation()
    status = Ref{CXInit_Error}(CXInit_NoError)
    invocation = clang_CompilerInvocation_create(status)
    @assert status[] == CXInit_NoError
    return invocation
end

"""
    create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments.
"""
function create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[],
                                             diag::DiagnosticsEngine=DiagnosticsEngine())
    status = Ref{CXInit_Error}(CXInit_NoError)
    args_with_src = copy(args)
    push!(args_with_src, src)
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                length(args_with_src),
                                                                diag.ptr, status)
    @assert status[] == CXInit_NoError
    return CompilerInvocation(invocation)
end

# Options
function get_codegen_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return CodeGenOptions(clang_CompilerInvocation_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return DiagnosticOptions(clang_CompilerInvocation_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return FrontendOptions(clang_CompilerInvocation_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return HeaderSearchOptions(clang_CompilerInvocation_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return PreprocessorOptions(clang_CompilerInvocation_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return TargetOptions(clang_CompilerInvocation_getTargetOpts(ci.ptr))
end
