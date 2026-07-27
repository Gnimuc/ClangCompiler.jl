# CompilerInvocation
CompilerInvocation() = CompilerInvocation(create_compiler_invocation())

"""
    create_compiler_invocation() -> CXCompilerInvocation
Return a pointer to a `clang::CompilerInvocation` object.
"""
function create_compiler_invocation()
    invocation = clang_CompilerInvocation_create()
    @assert invocation != C_NULL "Failed to create CompilerInvocation"
    return invocation
end

"""
    createFromCommandLine(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine()) -> CompilerInvocation
Return a `CompilerInvocation` created from command line arguments (the source
file goes last). Parse problems are reported through `diag`. This function
allocates and one should call `dispose` to release the resources after using
this object.
"""
function createFromCommandLine(src::String, args::Vector{String}=String[],
                               diag::DiagnosticsEngine=DiagnosticsEngine())
    @check_ptrs diag
    args_with_src = copy(args)
    push!(args_with_src, src)
    invocation = clang_CompilerInvocation_createFromCommandLine(args_with_src,
                                                                length(args_with_src), diag)
    @assert invocation != C_NULL "Failed to create CompilerInvocation"
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

dispose(x::CompilerInvocation) = clang_CompilerInvocation_dispose(x)


"""
    getLangOpts(ci::CompilerInvocation) -> LangOptions
Return the `clang::LangOptions` owned by this invocation. The returned object is
a borrowed view: do not dispose it.
"""
function getLangOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return LangOptions(clang_CompilerInvocation_getLangOpts(ci))
end

"""
    getAnalyzerOpts(ci::CompilerInvocation) -> AnalyzerOptions
Return the `clang::AnalyzerOptions` owned by this invocation (borrowed view).
"""
function getAnalyzerOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return AnalyzerOptions(clang_CompilerInvocation_getAnalyzerOpts(ci))
end

"""
    getMigratorOpts(ci::CompilerInvocation) -> MigratorOptions
Return the `clang::MigratorOptions` owned by this invocation (borrowed view).
"""
function getMigratorOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return MigratorOptions(clang_CompilerInvocation_getMigratorOpts(ci))
end

"""
    getFileSystemOpts(ci::CompilerInvocation) -> FileSystemOptions
Return the `clang::FileSystemOptions` owned by this invocation (borrowed view).
"""
function getFileSystemOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return FileSystemOptions(clang_CompilerInvocation_getFileSystemOpts(ci))
end

"""
    getDependencyOutputOpts(ci::CompilerInvocation) -> DependencyOutputOptions
Return the `clang::DependencyOutputOptions` owned by this invocation (borrowed view).
"""
function getDependencyOutputOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return DependencyOutputOptions(clang_CompilerInvocation_getDependencyOutputOpts(ci))
end

"""
    getPreprocessorOutputOpts(ci::CompilerInvocation) -> PreprocessorOutputOptions
Return the `clang::PreprocessorOutputOptions` owned by this invocation (borrowed view).
"""
function getPreprocessorOutputOpts(ci::CompilerInvocation)
    @check_ptrs ci
    return PreprocessorOutputOptions(clang_CompilerInvocation_getPreprocessorOutputOpts(ci))
end

"""
    getModuleHash(ci::CompilerInvocation) -> String
Return a hash string that uniquely identifies the conditions under which a module
built with this invocation would be built.
"""
function getModuleHash(ci::CompilerInvocation)
    @check_ptrs ci
    return get_string(clang_CompilerInvocation_getModuleHash(ci))
end
