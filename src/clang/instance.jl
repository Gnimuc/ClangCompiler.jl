"""
    mutable struct CompilerInstance <: Any
Holds a pointer to a `clang::CompilerInstance` object.
"""
mutable struct CompilerInstance
    ptr::CXCompilerInstance
end
CompilerInstance() = CompilerInstance(create_compiler_instance())

"""
    create_compiler_instance() -> CXCompilerInstance
Return a pointer to a `clang::CompilerInstance` object.
"""
function create_compiler_instance()
    status = Ref{CXInit_Error}(CXInit_NoError)
    instance = clang_CompilerInstance_create(status)
    @assert status[] == CXInit_NoError
    return instance
end

function destroy(x::CompilerInstance)
    if x.ptr != C_NULL
        clang_CompilerInstance_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

# Diagnostics
has_diagnostics(ci::CompilerInstance) = clang_CompilerInstance_hasDiagnostics(ci.ptr)

function get_diagnostics(ci::CompilerInstance)
    return DiagnosticsEngine(clang_CompilerInstance_getDiagnostics(ci.ptr))
end

function set_diagnostics(ci::CompilerInstance, diag::DiagnosticsEngine)
    return clang_CompilerInstance_setDiagnostics(ci.ptr, diag.ptr)
end

function get_diagnostic_client(ci::CompilerInstance)
    return DiagnosticConsumer(clang_CompilerInstance_getDiagnosticClient(ci.ptr))
end

function create_diagnostics(ci::CompilerInstance,
                            client::DiagnosticConsumer=DiagnosticConsumer(),
                            should_own_client=true)
    return clang_CompilerInstance_createDiagnostics(ci.ptr, client.ptr, should_own_client)
end

# FileManager
has_file_manager(ci::CompilerInstance) = clang_CompilerInstance_hasFileManager(ci.ptr)

function get_file_manager(ci::CompilerInstance)
    return FileManager(clang_CompilerInstance_getFileManager(ci.ptr))
end

function set_file_manager(ci::CompilerInstance, file_mgr::FileManager)
    return clang_CompilerInstance_setFileManager(ci.ptr, file_mgr.ptr)
end

function create_file_manager(ci::CompilerInstance)
    return clang_CompilerInstance_createFileManager(ci.ptr)
end

# SourceManager
has_source_manager(ci::CompilerInstance) = clang_CompilerInstance_hasSourceManager(ci.ptr)

function get_source_manager(ci::CompilerInstance)
    return SourceManager(clang_CompilerInstance_getSourceManager(ci.ptr))
end

function set_source_manager(ci::CompilerInstance, src_mgr::SourceManager)
    return clang_CompilerInstance_setSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance, file_mgr::FileManager)
    return clang_CompilerInstance_createSourceManager(ci.ptr, file_mgr.ptr)
end

# Invocation
has_invocation(ci::CompilerInstance) = clang_CompilerInstance_hasInvocation(ci.ptr)

function get_invocation(ci::CompilerInstance)
    return CompilerInvocation(clang_CompilerInstance_getInvocation(ci.ptr))
end

function set_invocation(ci::CompilerInstance, cinv::CompilerInvocation)
    return clang_CompilerInstance_setInvocation(ci.ptr, cinv.ptr)
end

# Target
set_target(ci::CompilerInstance) = clang_CompilerInstance_setTargetAndLangOpts()

function set_target(ci::CompilerInstance, t::TargetInfo)
    return clang_CompilerInstance_setTarget(ci.ptr, t.ptr)
end

# Preprocessor
has_preprocessor(ci::CompilerInstance) = clang_CompilerInstance_hasPreprocessor(ci.ptr)

function get_preprocessor(ci::CompilerInstance)
    return Preprocessor(clang_CompilerInstance_getPreprocessor(ci.ptr))
end

function set_preprocessor(ci::CompilerInstance, pp::Preprocessor)
    return clang_CompilerInstance_setPreprocessor(ci.ptr, pp.ptr)
end

function create_preprocessor(ci::CompilerInstance)
    return clang_CompilerInstance_createPreprocessor(ci.ptr)
end

# Sema
has_sema(ci::CompilerInstance) = clang_CompilerInstance_hasSema(ci.ptr)

function get_sema(ci::CompilerInstance)
    return Sema(clang_CompilerInstance_getSema(ci.ptr))
end

function set_sema(ci::CompilerInstance, sema::Sema)
    return clang_CompilerInstance_setSema(ci.ptr, sema.ptr)
end

function create_sema(ci::CompilerInstance)
    return clang_CompilerInstance_createSema(ci.ptr)
end

# ASTContext
has_ast_context(ci::CompilerInstance) = clang_CompilerInstance_hasASTContext(ci.ptr)

function get_ast_context(ci::CompilerInstance)
    return ASTContext(clang_CompilerInstance_getASTContext(ci.ptr))
end

function set_ast_context(ci::CompilerInstance, ctx::ASTContext)
    return clang_CompilerInstance_setASTContext(ci.ptr, ctx.ptr)
end

function create_ast_context(ci::CompilerInstance)
    return clang_CompilerInstance_createASTContext(ci.ptr)
end

# Options
function get_codegen_options(ci::CompilerInstance)
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInstance)
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInstance)
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInstance)
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInstance)
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInstance)
    return TargetOptions(clang_CompilerInstance_getTargetOpts(ci.ptr))
end
