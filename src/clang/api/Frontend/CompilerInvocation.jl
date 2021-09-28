# CompilerInvocation
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
    createFromCommandLine(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments.
"""
function createFromCommandLine(src::String, args::Vector{String}=String[],
                               diag::DiagnosticsEngine=DiagnosticsEngine())
    status = Ref{CXInit_Error}(CXInit_NoError)
    args_with_src = copy(args)
    push!(args_with_src, src)
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                length(args_with_src), diag,
                                                                status)
    @assert status[] == CXInit_NoError
    return CompilerInvocation(invocation)
end

# Options
function getCodeGenOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return CodeGenOptions(clang_CompilerInvocation_getCodeGenOpts(ci))
end

function getDiagnosticOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return DiagnosticOptions(clang_CompilerInvocation_getDiagnosticOpts(ci))
end

function getFrontendOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return FrontendOptions(clang_CompilerInvocation_getFrontendOpts(ci))
end

function getHeaderSearchOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return HeaderSearchOptions(clang_CompilerInvocation_getHeaderSearchOpts(ci))
end

function getPreprocessorOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return PreprocessorOptions(clang_CompilerInvocation_getPreprocessorOpts(ci))
end

function getTargetOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return TargetOptions(clang_CompilerInvocation_getTargetOpts(ci))
end
