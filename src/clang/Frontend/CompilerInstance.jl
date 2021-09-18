"""
    struct CompilerInstance <: Any
Hold a pointer to a `clang::CompilerInstance` object.
"""
struct CompilerInstance
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

dispose(x::CompilerInstance) = clang_CompilerInstance_dispose(x.ptr)

# Diagnostics
function has_diagnostics(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasDiagnostics(ci.ptr)
end

function get_diagnostics(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_diagnostics(ci) "CompilerInstance has no diagnostics engine."
    return DiagnosticsEngine(clang_CompilerInstance_getDiagnostics(ci.ptr))
end

function set_diagnostics(ci::CompilerInstance, diag::DiagnosticsEngine)
    @check_ptrs ci diag
    return clang_CompilerInstance_setDiagnostics(ci.ptr, diag.ptr)
end

function get_diagnostic_client(ci::CompilerInstance)
    @check_ptrs ci
    return DiagnosticConsumer(clang_CompilerInstance_getDiagnosticClient(ci.ptr))
end

function create_diagnostics(ci::CompilerInstance,
                            client::DiagnosticConsumer=DiagnosticConsumer(C_NULL),
                            should_own_client=true)
    @check_ptrs ci
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
    @check_ptrs ci
    return clang_CompilerInstance_hasFileManager(ci.ptr)
end

function get_file_manager(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_file_manager(ci) "CompilerInstance has no file manager."
    return FileManager(clang_CompilerInstance_getFileManager(ci.ptr))
end

function set_file_manager(ci::CompilerInstance, file_mgr::FileManager)
    @check_ptrs ci file_mgr
    return clang_CompilerInstance_setFileManager(ci.ptr, file_mgr.ptr)
end

function create_file_manager(ci::CompilerInstance)
    @check_ptrs ci
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

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function get_main_file_id(ci::CompilerInstance)
    src_mgr = get_source_manager(ci)
    return get_main_file_id(src_mgr)
end

# SourceManager
function has_source_manager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasSourceManager(ci.ptr)
end

function get_source_manager(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_source_manager(ci) "CompilerInstance has no source manager."
    return SourceManager(clang_CompilerInstance_getSourceManager(ci.ptr))
end

function set_source_manager(ci::CompilerInstance, src_mgr::SourceManager)
    @check_ptrs ci src_mgr
    return clang_CompilerInstance_setSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance, src_mgr::FileManager)
    @check_ptrs ci src_mgr
    @assert has_diagnostics(ci) "CompilerInstance has no diagnostics."
    return clang_CompilerInstance_createSourceManager(ci.ptr, src_mgr.ptr)
end

function create_source_manager(ci::CompilerInstance)
    file_mgr = get_file_manager(ci)
    return create_source_manager(ci, file_mgr)
end

# Invocation
function has_invocation(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasInvocation(ci.ptr)
end

function get_invocation(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_invocation(ci) "CompilerInstance has no invocation"
    return CompilerInvocation(clang_CompilerInstance_getInvocation(ci.ptr))
end

function set_invocation(ci::CompilerInstance, cinv::CompilerInvocation)
    @check_ptrs ci cinv
    return clang_CompilerInstance_setInvocation(ci.ptr, cinv.ptr)
end

# Target
function has_target(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasTarget(ci.ptr)
end

function get_target(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_target(ci) "CompilerInstance has no target"
    return TargetInfo(clang_CompilerInstance_getTarget(ci.ptr))
end

function set_target(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_setTargetAndLangOpts(ci.ptr)
end

function set_target(ci::CompilerInstance, tgti::TargetInfo)
    @check_ptrs ci tgti
    return clang_CompilerInstance_setTarget(ci.ptr, tgti.ptr)
end

# Preprocessor
function has_preprocessor(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasPreprocessor(ci.ptr)
end

function get_preprocessor(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_preprocessor(ci) "CompilerInstance has no preprocessor"
    return Preprocessor(clang_CompilerInstance_getPreprocessor(ci.ptr))
end

function set_preprocessor(ci::CompilerInstance, pp::Preprocessor)
    @check_ptrs ci pp
    return clang_CompilerInstance_setPreprocessor(ci.ptr, pp.ptr)
end

function create_preprocessor(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @check_ptrs ci
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
    @check_ptrs ci
    return clang_CompilerInstance_hasSema(ci.ptr)
end

function get_sema(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_sema(ci) "CompilerInstance has no sema."
    return Sema(clang_CompilerInstance_getSema(ci.ptr))
end

function set_sema(ci::CompilerInstance, sema::Sema)
    @check_ptrs ci sema
    return clang_CompilerInstance_setSema(ci.ptr, sema.ptr)
end

function create_sema(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @check_ptrs ci
    @assert has_ast_context(ci) "CompilerInstance has no ASTContext."
    @assert has_ast_consumer(ci) "CompilerInstance has no ASTConsumer."
    return clang_CompilerInstance_createSema(ci.ptr, kind)
end

# ASTContext
function has_ast_context(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasASTContext(ci.ptr)
end

function getASTContext(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_ast_context(ci) "CompilerInstance has no AST context."
    return ASTContext(clang_CompilerInstance_getASTContext(ci.ptr))
end

function set_ast_context(ci::CompilerInstance, ctx::ASTContext)
    @check_ptrs ci ctx
    return clang_CompilerInstance_setASTContext(ci.ptr, ctx.ptr)
end

function create_ast_context(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_preprocessor(ci) "CompilerInstance has no preprocessor."
    return clang_CompilerInstance_createASTContext(ci.ptr)
end

function get_builtin_clang_type(ci::CompilerInstance, ty)
    @check_ptrs ci
    return get_builtin_clang_type(getASTContext(ci), ty)
end

# ASTConsumer
function has_ast_consumer(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasASTConsumer(ci.ptr)
end

function get_ast_consumer(ci::CompilerInstance)
    @check_ptrs ci
    @assert has_ast_consumer(ci) "CompilerInstance has no AST consumer."
    return ASTConsumer(clang_CompilerInstance_getASTConsumer(ci.ptr))
end

function set_ast_consumer(ci::CompilerInstance, csr::AbstractASTConsumer)
    @check_ptrs ci csr
    return clang_CompilerInstance_setASTConsumer(ci.ptr, csr.ptr)
end

# CodeGenerator
function create_llvm_codegen(ci::CompilerInstance, ctx::Context, mod_name::String="JLCC")
    @check_ptrs ci
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
    @check_ptrs ci action
    return clang_CompilerInstance_ExecuteAction(ci.ptr, action.ptr)
end

# Options
function get_codegen_options(ci::CompilerInstance)
    @check_ptrs ci
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci.ptr))
end

function get_diagnostic_options(ci::CompilerInstance)
    @check_ptrs ci
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci.ptr))
end

function get_frontend_options(ci::CompilerInstance)
    @check_ptrs ci
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci.ptr))
end

function get_header_search_options(ci::CompilerInstance)
    @check_ptrs ci
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci.ptr))
end

function get_preprocessor_options(ci::CompilerInstance)
    @check_ptrs ci
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci.ptr))
end

function get_target_options(ci::CompilerInstance)
    @check_ptrs ci
    return TargetOptions(clang_CompilerInstance_getTargetOpts(ci.ptr))
end

function get_lang_options(ci::CompilerInstance)
    @check_ptrs ci
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

# PrintStats
function PrintStats(ci::CompilerInstance, ::Type{CodeGenOptions})
    opts = get_codegen_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{DiagnosticOptions})
    opts = get_diagnostic_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{FrontendOptions})
    opts = get_frontend_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{HeaderSearchOptions})
    opts = get_header_search_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{PreprocessorOptions})
    opts = get_preprocessor_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{TargetOptions})
    opts = get_target_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{LangOptions})
    opts = get_lang_options(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{FileManager})
    fm = get_file_manager(ci)
    return PrintStats(fm)
end

function PrintStats(ci::CompilerInstance, ::Type{SourceManager})
    sm = get_source_manager(ci)
    return PrintStats(sm)
end

function PrintStats(ci::CompilerInstance, ::Type{HeaderSearch})
    pp = get_preprocessor(ci)
    opts = get_header_search(pp)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{Preprocessor})
    pp = get_preprocessor(ci)
    return PrintStats(pp)
end

function PrintStats(ci::CompilerInstance, ::Type{Sema})
    s = get_sema(ci)
    return PrintStats(s)
end

function PrintStats(ci::CompilerInstance, ::Type{ASTContext})
    ctx = getASTContext(ci)
    return PrintStats(ctx)
end

function PrintStats(ci::CompilerInstance, ::Type{ASTConsumer})
    ctx = get_ast_consumer(ci)
    return PrintStats(ctx)
end

function PrintStats_options(ci::CompilerInstance)
    PrintStats(ci, CodeGenOptions)
    PrintStats(ci, DiagnosticOptions)
    PrintStats(ci, FrontendOptions)
    PrintStats(ci, HeaderSearchOptions)
    PrintStats(ci, PreprocessorOptions)
    return PrintStats(ci, TargetOptions)
end

function PrintStats_modules(ci::CompilerInstance)
    PrintStats(ci, FileManager)
    PrintStats(ci, SourceManager)
    PrintStats(ci, HeaderSearch)
    PrintStats(ci, Preprocessor)
    PrintStats(ci, Sema)
    PrintStats(ci, ASTContext)
    return PrintStats(ci, ASTConsumer)
end

function PrintStats_all(ci::CompilerInstance)
    PrintStats_options(ci)
    return PrintStats_modules(ci)
end
