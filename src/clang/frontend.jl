# CompilerInstance
function begin_diag(ci::CompilerInstance)
    diag_csr = getDiagnosticClient(ci)
    preprocessor = getPreprocessor(ci)
    return BeginSourceFile(diag_csr, getLangOpts(ci), preprocessor)
end

end_diag(ci::CompilerInstance) = EndSourceFile(getDiagnosticClient(ci))

# NOTE: there is deliberately no get_codegen(::CompilerInstance): the only
# reachable instance is the interpreter's, whose consumer's dynamic class is
# clang::IncrementalASTConsumer — wrapping it in a CodeGenerator carrier would
# violate the faithful-carrier invariant (src/clang/CLAUDE.md). Use
# getASTConsumer(ci) for the consumer, or getCodeGen(x::Interpreter) for the
# interpreter's real CodeGenerator.
get_ast_context(ci::CompilerInstance) = getASTContext(ci)

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
function create_compiler_invocation_from_cmd(src::String, args::Vector{String}=String[], diag::DiagnosticsEngine=DiagnosticsEngine())
    return createFromCommandLine(src, args, diag)
end
