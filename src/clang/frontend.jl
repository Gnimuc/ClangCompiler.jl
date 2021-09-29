# CompilerInstance
function begin_diag(ci::CompilerInstance)
    diag_csr = getDiagnosticClient(ci)
    preprocessor = getPreprocessor(ci)
    return BeginSourceFile(diag_csr, getLangOpts(ci), preprocessor)
end

end_diag(ci::CompilerInstance) = EndSourceFile(getDiagnosticClient(ci))

get_codegen(ci::CompilerInstance) = CodeGenerator(getASTConsumer(ci).ptr)

get_llvm_module(ci::CompilerInstance) = get_llvm_module(get_codegen(ci))

get_builtin_clang_type(ci::CompilerInstance, ty) = getBuiltinClangType(getASTContext(ci), ty)

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
