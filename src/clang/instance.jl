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
function has_diagnostics(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasDiagnostics(ci.ptr)
end

function get_diagnostics(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_diagnostics(ci) "compiler instance has no diagnostics engine."
    return DiagnosticsEngine(clang_CompilerInstance_getDiagnostics(ci.ptr))
end

function set_diagnostics(ci::CompilerInstance, diag::DiagnosticsEngine)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert diag.ptr != C_NULL "diagnostics engine has a NULL pointer."
    return clang_CompilerInstance_setDiagnostics(ci.ptr, diag.ptr)
end

function get_diagnostic_client(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return DiagnosticConsumer(clang_CompilerInstance_getDiagnosticClient(ci.ptr))
end

function create_diagnostics(ci::CompilerInstance,
                            client::DiagnosticConsumer=DiagnosticConsumer(),
                            should_own_client=true)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert client.ptr != C_NULL "diagnostic consumer has a NULL pointer."
    return clang_CompilerInstance_createDiagnostics(ci.ptr, client.ptr, should_own_client)
end

# FileManager
function has_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasFileManager(ci.ptr)
end

function get_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_file_manager(ci) "compiler instance has no file manager."
    return FileManager(clang_CompilerInstance_getFileManager(ci.ptr))
end

function set_file_manager(ci::CompilerInstance, file_mgr::FileManager)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert file_mgr.ptr != C_NULL "file manager has a NULL pointer."
    return clang_CompilerInstance_setFileManager(ci.ptr, file_mgr.ptr)
end

function create_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_createFileManager(ci.ptr)
end

# SourceManager
function has_source_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasSourceManager(ci.ptr)
end

function get_source_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_source_manager(ci) "compiler instance has no source manager."
    return SourceManager(clang_CompilerInstance_getSourceManager(ci.ptr))
end

function set_source_manager(ci::CompilerInstance, src_mgr::SourceManager)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert src_mgr.ptr != C_NULL "source manager has a NULL pointer."
    return clang_CompilerInstance_setSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance, src_mgr::FileManager)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert src_mgr.ptr != C_NULL "file manager has a NULL pointer."
    return clang_CompilerInstance_createSourceManager(ci.ptr, src_mgr.ptr)
end

# Invocation
function has_invocation(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasInvocation(ci.ptr)
end

function get_invocation(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_invocation(ci) "compiler instance has no invocation"
    return CompilerInvocation(clang_CompilerInstance_getInvocation(ci.ptr))
end

function set_invocation(ci::CompilerInstance, cinv::CompilerInvocation)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert cinv.ptr != C_NULL "compiler invocation has a NULL pointer."
    return clang_CompilerInstance_setInvocation(ci.ptr, cinv.ptr)
end

# Target
function set_target(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    clang_CompilerInstance_setTargetAndLangOpts(ci.ptr)
end

function set_target(ci::CompilerInstance, t::TargetInfo)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert t.ptr != C_NULL "target info has a NULL pointer."
    return clang_CompilerInstance_setTarget(ci.ptr, t.ptr)
end

# Preprocessor
function has_preprocessor(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    clang_CompilerInstance_hasPreprocessor(ci.ptr)
end

function get_preprocessor(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_preprocessor(ci) "compiler instance has no preprocessor"
    return Preprocessor(clang_CompilerInstance_getPreprocessor(ci.ptr))
end

function set_preprocessor(ci::CompilerInstance, pp::Preprocessor)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert pp.ptr != C_NULL "preprocessor has a NULL pointer."
    return clang_CompilerInstance_setPreprocessor(ci.ptr, pp.ptr)
end

function create_preprocessor(ci::CompilerInstance, kind=CXTU_Complete)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_createPreprocessor(ci.ptr, kind)
end

# Sema
function has_sema(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasSema(ci.ptr)
end

function get_sema(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_sema(ci) "compiler instance has no sema."
    return Sema(clang_CompilerInstance_getSema(ci.ptr))
end

function set_sema(ci::CompilerInstance, sema::Sema)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert sema.ptr != C_NULL "sema has a NULL pointer."
    return clang_CompilerInstance_setSema(ci.ptr, sema.ptr)
end

function create_sema(ci::CompilerInstance, kind=CXTU_Complete)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_createSema(ci.ptr, kind)
end

# ASTContext
function has_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_hasASTContext(ci.ptr)
end

function get_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert has_ast_context "compiler instance has no AST context."
    return ASTContext(clang_CompilerInstance_getASTContext(ci.ptr))
end

function set_ast_context(ci::CompilerInstance, ctx::ASTContext)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    @assert ctx.ptr != C_NULL "AST context has a NULL pointer."
    return clang_CompilerInstance_setASTContext(ci.ptr, ctx.ptr)
end

function create_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return clang_CompilerInstance_createASTContext(ci.ptr)
end

# Options
function get_codegen_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "compiler instance has a NULL pointer."
    return TargetOptions(clang_CompilerInstance_getTargetOpts(ci.ptr))
end

# status
function status(ci::CompilerInstance, ::Type{CodeGenOptions})
    opts = get_codegen_options(ci)
    return status(opts)
end

function status(ci::CompilerInstance, ::Type{DiagnosticOptions})
    opts = get_diagnostic_options(ci)
    return status(opts)
end

function status(ci::CompilerInstance, ::Type{FrontendOptions})
    opts = get_frontend_options(ci)
    return status(opts)
end

function status(ci::CompilerInstance, ::Type{HeaderSearchOptions})
    opts = get_header_search_options(ci)
    return status(opts)
end

function status(ci::CompilerInstance, ::Type{PreprocessorOptions})
    opts = get_preprocessor_options(ci)
    return status(opts)
end

function status(ci::CompilerInstance, ::Type{TargetOptions})
    opts = get_target_options(ci)
    return status(opts)
end
