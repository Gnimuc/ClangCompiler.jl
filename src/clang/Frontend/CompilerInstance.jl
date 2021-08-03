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
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasDiagnostics(ci.ptr)
end

function get_diagnostics(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_diagnostics(ci) "CompilerInstance has no diagnostics engine."
    return DiagnosticsEngine(clang_CompilerInstance_getDiagnostics(ci.ptr))
end

function set_diagnostics(ci::CompilerInstance, diag::DiagnosticsEngine)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert diag.ptr != C_NULL "DiagnosticsEngine has a NULL pointer."
    return clang_CompilerInstance_setDiagnostics(ci.ptr, diag.ptr)
end

function get_diagnostic_client(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return DiagnosticConsumer(clang_CompilerInstance_getDiagnosticClient(ci.ptr))
end

function create_diagnostics(ci::CompilerInstance,
                            client::DiagnosticConsumer=DiagnosticConsumer(C_NULL),
                            should_own_client=true)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_createDiagnostics(ci.ptr, client.ptr, should_own_client)
end

function begin_diag(ci::CompilerInstance)
    diag_csr = get_diagnostic_client(ci)
    preprocessor = get_preprocessor(ci)
    return begin_source_file(diag_csr, get_lang_options(ci), preprocessor)
end

end_diag(ci::CompilerInstance) = end_source_file(get_diagnostic_client(ci))

# FileManager
function has_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasFileManager(ci.ptr)
end

function get_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_file_manager(ci) "CompilerInstance has no file manager."
    return FileManager(clang_CompilerInstance_getFileManager(ci.ptr))
end

function set_file_manager(ci::CompilerInstance, file_mgr::FileManager)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert file_mgr.ptr != C_NULL "FileManager has a NULL pointer."
    return clang_CompilerInstance_setFileManager(ci.ptr, file_mgr.ptr)
end

function create_file_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_createFileManager(ci.ptr)
end

function get_file(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_mgr = get_file_manager(ci)
    return get_file(file_mgr, filename; open_file)
end

function set_main_file(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_entry = get_file(ci, filename, open_file)
    src_mgr = get_source_manager(ci)
    return set_main_file(src_mgr, file_entry)
end

"""
    get_main_file_id(ci::CompilerInstance) -> FileID
Return the main file ID.

This function allocates and one should call `destroy` to release the resources after using this object.
"""
function get_main_file_id(ci::CompilerInstance)
    src_mgr = get_source_manager(ci)
    return get_main_file_id(src_mgr)
end

# SourceManager
function has_source_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasSourceManager(ci.ptr)
end

function get_source_manager(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_source_manager(ci) "CompilerInstance has no source manager."
    return SourceManager(clang_CompilerInstance_getSourceManager(ci.ptr))
end

function set_source_manager(ci::CompilerInstance, src_mgr::SourceManager)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert src_mgr.ptr != C_NULL "SourceManager has a NULL pointer."
    return clang_CompilerInstance_setSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance, src_mgr::FileManager)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert src_mgr.ptr != C_NULL "FileManager has a NULL pointer."
    @assert has_diagnostics(ci) "CompilerInstance has no diagnostics."
    return clang_CompilerInstance_createSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance)
    file_mgr = get_file_manager(ci)
    return create_source_manager(ci, file_mgr)
end

# Invocation
function has_invocation(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasInvocation(ci.ptr)
end

function get_invocation(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_invocation(ci) "CompilerInstance has no invocation"
    return CompilerInvocation(clang_CompilerInstance_getInvocation(ci.ptr))
end

function set_invocation(ci::CompilerInstance, cinv::CompilerInvocation)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert cinv.ptr != C_NULL "CompilerInvocation has a NULL pointer."
    return clang_CompilerInstance_setInvocation(ci.ptr, cinv.ptr)
end

# Target
function has_target(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasTarget(ci.ptr)
end

function get_target(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_target(ci) "CompilerInstance has no target"
    return TargetInfo(clang_CompilerInstance_getTarget(ci.ptr))
end

function set_target(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_setTargetAndLangOpts(ci.ptr)
end

function set_target(ci::CompilerInstance, t::TargetInfo)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert t.ptr != C_NULL "TargetInfo has a NULL pointer."
    return clang_CompilerInstance_setTarget(ci.ptr, t.ptr)
end

# Preprocessor
function has_preprocessor(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasPreprocessor(ci.ptr)
end

function get_preprocessor(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_preprocessor(ci) "CompilerInstance has no preprocessor"
    return Preprocessor(clang_CompilerInstance_getPreprocessor(ci.ptr))
end

function set_preprocessor(ci::CompilerInstance, pp::Preprocessor)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert pp.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_CompilerInstance_setPreprocessor(ci.ptr, pp.ptr)
end

function create_preprocessor(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_target(ci) "CompilerInstance has no target."
    return clang_CompilerInstance_createPreprocessor(ci.ptr, kind)
end

function enter_main_file(ci::CompilerInstance)
    return enter_main_file(get_preprocessor(ci))
end

function get_header_search(ci::CompilerInstance)
    return get_header_search(get_preprocessor(ci))
end

# Sema
function has_sema(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasSema(ci.ptr)
end

function get_sema(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_sema(ci) "CompilerInstance has no sema."
    return Sema(clang_CompilerInstance_getSema(ci.ptr))
end

function set_sema(ci::CompilerInstance, sema::Sema)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    return clang_CompilerInstance_setSema(ci.ptr, sema.ptr)
end

function create_sema(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_ast_context(ci) "CompilerInstance has no ASTContext."
    @assert has_ast_consumer(ci) "CompilerInstance has no ASTConsumer."
    return clang_CompilerInstance_createSema(ci.ptr, kind)
end

# ASTContext
function has_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasASTContext(ci.ptr)
end

function get_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_ast_context(ci) "CompilerInstance has no AST context."
    return ASTContext(clang_CompilerInstance_getASTContext(ci.ptr))
end

function set_ast_context(ci::CompilerInstance, ctx::ASTContext)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert ctx.ptr != C_NULL "ASTContext has a NULL pointer."
    return clang_CompilerInstance_setASTContext(ci.ptr, ctx.ptr)
end

function create_ast_context(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_preprocessor(ci) "CompilerInstance has no preprocessor."
    return clang_CompilerInstance_createASTContext(ci.ptr)
end

function get_builtin_clang_type(ci::CompilerInstance, ty)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return get_builtin_clang_type(get_ast_context(ci), ty)
end

# ASTConsumer
function has_ast_consumer(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return clang_CompilerInstance_hasASTConsumer(ci.ptr)
end

function get_ast_consumer(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert has_ast_consumer(ci) "CompilerInstance has no AST consumer."
    return ASTConsumer(clang_CompilerInstance_getASTConsumer(ci.ptr))
end

function set_ast_consumer(ci::CompilerInstance, csr::AbstractASTConsumer)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert csr.ptr != C_NULL "ASTConsumer has a NULL pointer."
    return clang_CompilerInstance_setASTConsumer(ci.ptr, csr.ptr)
end

# CodeGenerator
function create_llvm_codegen(ci::CompilerInstance, ctx::Context, mod_name::String="JLCC")
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert ctx.ref != C_NULL "Context has a NULL pointer."
    return CodeGenerator(clang_CreateLLVMCodeGen(ci.ptr, ctx.ref, mod_name))
end

function get_codegen(ci::CompilerInstance)
    return CodeGenerator(get_ast_consumer(ci).ptr)
end

function get_llvm_module(ci::CompilerInstance)
    return get_llvm_module(get_codegen(ci))
end

# Actions
function execute_action(ci::CompilerInstance, action::T) where {T<:AbstractFrontendAction}
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    @assert action.ptr != C_NULL "$T has a NULL pointer."
    return clang_CompilerInstance_ExecuteAction(ci.ptr, action.ptr)
end

# Options
function get_codegen_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return TargetOptions(clang_CompilerInstance_getTargetOpts(ci.ptr))
end

function get_lang_options(ci::CompilerInstance)
    @assert ci.ptr != C_NULL "CompilerInstance has a NULL pointer."
    return LangOptions(clang_CompilerInstance_getLangOpts(ci.ptr))
end

function set_opt_show_presumed_loc(ci::CompilerInstance, should_show::Bool=true)
    opt = get_diagnostic_options(ci)
    return set_show_presumed_loc(opt, should_show)
end

function set_opt_show_colors(ci::CompilerInstance, should_show::Bool=true)
    opt = get_diagnostic_options(ci)
    return set_show_colors(opt, should_show)
end

# print_stats
function print_stats(ci::CompilerInstance, ::Type{CodeGenOptions})
    opts = get_codegen_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{DiagnosticOptions})
    opts = get_diagnostic_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{FrontendOptions})
    opts = get_frontend_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{HeaderSearchOptions})
    opts = get_header_search_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{PreprocessorOptions})
    opts = get_preprocessor_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{TargetOptions})
    opts = get_target_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{LangOptions})
    opts = get_lang_options(ci)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{FileManager})
    fm = get_file_manager(ci)
    return print_stats(fm)
end

function print_stats(ci::CompilerInstance, ::Type{SourceManager})
    sm = get_source_manager(ci)
    return print_stats(sm)
end

function print_stats(ci::CompilerInstance, ::Type{HeaderSearch})
    pp = get_preprocessor(ci)
    opts = get_header_search(pp)
    return print_stats(opts)
end

function print_stats(ci::CompilerInstance, ::Type{Preprocessor})
    pp = get_preprocessor(ci)
    return print_stats(pp)
end

function print_stats(ci::CompilerInstance, ::Type{Sema})
    s = get_sema(ci)
    return print_stats(s)
end

function print_stats(ci::CompilerInstance, ::Type{ASTContext})
    ctx = get_ast_context(ci)
    return print_stats(ctx)
end

function print_stats(ci::CompilerInstance, ::Type{ASTConsumer})
    ctx = get_ast_consumer(ci)
    return print_stats(ctx)
end

function print_stats_options(ci::CompilerInstance)
    print_stats(ci, CodeGenOptions)
    print_stats(ci, DiagnosticOptions)
    print_stats(ci, FrontendOptions)
    print_stats(ci, HeaderSearchOptions)
    print_stats(ci, PreprocessorOptions)
    return print_stats(ci, TargetOptions)
end

function print_stats_modules(ci::CompilerInstance)
    print_stats(ci, FileManager)
    print_stats(ci, SourceManager)
    print_stats(ci, HeaderSearch)
    print_stats(ci, Preprocessor)
    print_stats(ci, Sema)
    print_stats(ci, ASTContext)
    return print_stats(ci, ASTConsumer)
end

function print_stats_all(ci::CompilerInstance)
    print_stats_options(ci)
    return print_stats_modules(ci)
end
