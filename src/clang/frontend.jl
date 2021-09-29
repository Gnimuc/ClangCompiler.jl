# CompilerInstance
function begin_diag(ci::CompilerInstance)
    diag_csr = get_diagnostic_client(ci)
    preprocessor = get_preprocessor(ci)
    return begin_source_file(diag_csr, getLangOpts(ci), preprocessor)
end

end_diag(ci::CompilerInstance) = end_source_file(get_diagnostic_client(ci))

function get_file(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_mgr = getFileManager(ci)
    return get_file(file_mgr, filename; open_file)
end

function set_main_file(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_entry = get_file(ci, filename, open_file)
    src_mgr = getSourceManager(ci)
    return set_main_file(src_mgr, file_entry)
end

function get_codegen(ci::CompilerInstance)
    return CodeGenerator(getASTConsumer(ci))
end

function get_llvm_module(ci::CompilerInstance)
    return get_llvm_module(get_codegen(ci))
end

function get_builtin_clang_type(ci::CompilerInstance, ty)
    @check_ptrs ci
    return getBuiltinClangType(getASTContext(ci), ty)
end

function set_opt_show_presumed_loc(ci::CompilerInstance, should_show::Bool=true)
    opt = getDiagnosticOpts(ci)
    return setShowPresumedLoc(opt, should_show)
end

function set_opt_show_colors(ci::CompilerInstance, should_show::Bool=true)
    opt = getDiagnosticOpts(ci)
    return setShowColors(opt, should_show)
end

function create_source_manager(ci::CompilerInstance)
    file_mgr = getFileManager(ci)
    return createSourceManager(ci, file_mgr)
end

function EnterMainSourceFile(ci::CompilerInstance)
    return EnterMainSourceFile(get_preprocessor(ci))
end

function getHeaderSearchInfo(ci::CompilerInstance)
    return getHeaderSearchInfo(get_preprocessor(ci))
end

"""
    get_main_file_id(ci::CompilerInstance) -> FileID
Return the main file ID.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
get_main_file_id(ci::CompilerInstance) = getMainFileID(getSourceManager(ci))

# status
function print_stats_options(ci::CompilerInstance)
    PrintStats(ci, CodeGenOptions)
    PrintStats(ci, DiagnosticOptions)
    PrintStats(ci, FrontendOptions)
    PrintStats(ci, HeaderSearchOptions)
    PrintStats(ci, PreprocessorOptions)
    PrintStats(ci, TargetOptions)
    return nothing
end

function print_stats_modules(ci::CompilerInstance)
    PrintStats(ci, FileManager)
    PrintStats(ci, SourceManager)
    PrintStats(ci, HeaderSearch)
    PrintStats(ci, Preprocessor)
    PrintStats(ci, Sema)
    PrintStats(ci, ASTContext)
    PrintStats(ci, ASTConsumer)
    return nothing
end

function print_stats_all(ci::CompilerInstance)
    print_stats_options(ci)
    print_stats_modules(ci)
    return nothing
end

# CompilerInvocation
function create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[],
    diag::DiagnosticsEngine=DiagnosticsEngine())
return createFromCommandLine(src, args, diag)
end
