# CompilerInstance
CompilerInstance() = CompilerInstance(create_compiler_instance())

"""
    create_compiler_instance() -> CXCompilerInstance
Return a pointer to a `clang::CompilerInstance` object.
"""
function create_compiler_instance()
    instance = clang_CompilerInstance_create()
    @assert instance != C_NULL "Failed to create a CompilerInstance object."
    return instance
end

dispose(x::CompilerInstance) = clang_CompilerInstance_dispose(x)

# Diagnostics
function hasDiagnostics(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasDiagnostics(ci)
end

function getDiagnostics(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine."
    return DiagnosticsEngine(clang_CompilerInstance_getDiagnostics(ci))
end

function setDiagnostics(ci::CompilerInstance, diag::DiagnosticsEngine)
    @check_ptrs ci diag
    return clang_CompilerInstance_setDiagnostics(ci, diag)
end

function getDiagnosticClient(ci::CompilerInstance)
    @check_ptrs ci
    return DiagnosticConsumer(clang_CompilerInstance_getDiagnosticClient(ci))
end

function createDiagnostics(ci::CompilerInstance,
                           client::DiagnosticConsumer=DiagnosticConsumer(C_NULL),
                           should_own_client=true)
    @check_ptrs ci
    return clang_CompilerInstance_createDiagnostics(ci, client, should_own_client)
end

function setShowPresumedLoc(ci::CompilerInstance, should_show::Bool=true)
    opt = getDiagnosticOpts(ci)
    return setShowPresumedLoc(opt, should_show)
end

function setShowColors(ci::CompilerInstance, should_show::Bool=true)
    opt = getDiagnosticOpts(ci)
    return setShowColors(opt, should_show)
end

# FileManager
function hasFileManager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasFileManager(ci)
end

function getFileManager(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasFileManager(ci) "CompilerInstance has no file manager."
    return FileManager(clang_CompilerInstance_getFileManager(ci))
end

function setFileManager(ci::CompilerInstance, file_mgr::FileManager)
    @check_ptrs ci file_mgr
    return clang_CompilerInstance_setFileManager(ci, file_mgr)
end

function createFileManager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_createFileManager(ci)
end

function getFileEntry(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_mgr = getFileManager(ci)
    return getFileEntry(file_mgr, filename; open_file)
end

# SourceManager
function hasSourceManager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasSourceManager(ci)
end

function getSourceManager(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasSourceManager(ci) "CompilerInstance has no source manager."
    return SourceManager(clang_CompilerInstance_getSourceManager(ci))
end

function setSourceManager(ci::CompilerInstance, src_mgr::SourceManager)
    @check_ptrs ci src_mgr
    return clang_CompilerInstance_setSourceManager(ci, src_mgr)
end

function createSourceManager(ci::CompilerInstance, src_mgr::FileManager)
    @check_ptrs ci src_mgr
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics."
    return clang_CompilerInstance_createSourceManager(ci, src_mgr)
end

function createSourceManager(ci::CompilerInstance)
    file_mgr = getFileManager(ci)
    return createSourceManager(ci, file_mgr)
end

function setMainFileID(ci::CompilerInstance, filename::AbstractString, open_file::Bool=true)
    file_entry = getFileEntry(ci, filename, open_file)
    src_mgr = getSourceManager(ci)
    return setMainFileID(src_mgr, file_entry)
end

"""
    get_main_file_id(ci::CompilerInstance) -> FileID
Return the main file ID.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
getMainFileID(ci::CompilerInstance) = getMainFileID(getSourceManager(ci))

# Invocation
function hasInvocation(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasInvocation(ci)
end

function getInvocation(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "CompilerInstance has no invocation"
    return CompilerInvocation(clang_CompilerInstance_getInvocation(ci))
end

function setInvocation(ci::CompilerInstance, cinv::CompilerInvocation)
    @check_ptrs ci cinv
    return clang_CompilerInstance_setInvocation(ci, cinv)
end

# Target
function hasTarget(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasTarget(ci)
end

function getTarget(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasTarget(ci) "CompilerInstance has no target"
    return TargetInfo(clang_CompilerInstance_getTarget(ci))
end

function setTargetAndLangOpts(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_setTargetAndLangOpts(ci)
end

function setTarget(ci::CompilerInstance, tgti::TargetInfo)
    @check_ptrs ci tgti
    return clang_CompilerInstance_setTarget(ci, tgti)
end

# Preprocessor
function hasPreprocessor(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasPreprocessor(ci)
end

function getPreprocessor(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasPreprocessor(ci) "CompilerInstance has no preprocessor"
    return Preprocessor(clang_CompilerInstance_getPreprocessor(ci))
end

function setPreprocessor(ci::CompilerInstance, pp::Preprocessor)
    @check_ptrs ci pp
    return clang_CompilerInstance_setPreprocessor(ci, pp)
end

function createPreprocessor(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @check_ptrs ci
    @assert hasTarget(ci) "CompilerInstance has no target."
    return clang_CompilerInstance_createPreprocessor(ci, kind)
end

# Sema
function hasSema(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasSema(ci)
end

function getSema(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasSema(ci) "CompilerInstance has no sema."
    return Sema(clang_CompilerInstance_getSema(ci))
end

function setSema(ci::CompilerInstance, sema::Sema)
    @check_ptrs ci sema
    return clang_CompilerInstance_setSema(ci, sema)
end

function createSema(ci::CompilerInstance, kind=CXTranslationUnitKind_TU_Complete)
    @check_ptrs ci
    @assert hasASTContext(ci) "CompilerInstance has no ASTContext."
    @assert hasASTConsumer(ci) "CompilerInstance has no ASTConsumer."
    return clang_CompilerInstance_createSema(ci, kind)
end

# ASTContext
function hasASTContext(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasASTContext(ci)
end

function getASTContext(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasASTContext(ci) "CompilerInstance has no AST context."
    return ASTContext(clang_CompilerInstance_getASTContext(ci))
end

function setASTContext(ci::CompilerInstance, ctx::ASTContext)
    @check_ptrs ci ctx
    return clang_CompilerInstance_setASTContext(ci, ctx)
end

function createASTContext(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasPreprocessor(ci) "CompilerInstance has no preprocessor."
    return clang_CompilerInstance_createASTContext(ci)
end

# ASTConsumer
function hasASTConsumer(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasASTConsumer(ci)
end

function getASTConsumer(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasASTConsumer(ci) "CompilerInstance has no AST consumer."
    return ASTConsumer(clang_CompilerInstance_getASTConsumer(ci))
end

function setASTConsumer(ci::CompilerInstance, csr::AbstractASTConsumer)
    @check_ptrs ci csr
    return clang_CompilerInstance_setASTConsumer(ci, csr)
end

# CodeGenerator
function CreateLLVMCodeGen(ci::CompilerInstance, ctx::Context, mod_name::String="JLCC")
    @check_ptrs ci
    @assert ctx.ref != C_NULL "Context has a NULL pointer."
    return CodeGenerator(clang_CreateLLVMCodeGen(ci, ctx, mod_name))
end

# Actions
function ExecuteAction(ci::CompilerInstance, action::T) where {T<:AbstractFrontendAction}
    @check_ptrs ci action
    return clang_CompilerInstance_ExecuteAction(ci, action)
end

# Options
function getCodeGenOpts(ci::CompilerInstance)
    @check_ptrs ci
    return CodeGenOptions(clang_CompilerInstance_getCodeGenOpts(ci))
end

function getDiagnosticOpts(ci::CompilerInstance)
    @check_ptrs ci
    return DiagnosticOptions(clang_CompilerInstance_getDiagnosticOpts(ci))
end

function getFrontendOpts(ci::CompilerInstance)
    @check_ptrs ci
    return FrontendOptions(clang_CompilerInstance_getFrontendOpts(ci))
end

function getHeaderSearchOpts(ci::CompilerInstance)
    @check_ptrs ci
    return HeaderSearchOptions(clang_CompilerInstance_getHeaderSearchOpts(ci))
end

function getPreprocessorOpts(ci::CompilerInstance)
    @check_ptrs ci
    return PreprocessorOptions(clang_CompilerInstance_getPreprocessorOpts(ci))
end

function getTargetOpts(ci::CompilerInstance)
    @check_ptrs ci
    return TargetOptions(clang_CompilerInstance_getTargetOpts(ci))
end

function getLangOpts(ci::CompilerInstance)
    @check_ptrs ci
    return LangOptions(clang_CompilerInstance_getLangOpts(ci))
end

# PrintStats
function PrintStats(ci::CompilerInstance, ::Type{CodeGenOptions})
    opts = getCodeGenOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{DiagnosticOptions})
    opts = getDiagnosticOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{FrontendOptions})
    opts = getFrontendOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{HeaderSearchOptions})
    opts = getHeaderSearchOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{PreprocessorOptions})
    opts = getPreprocessorOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{TargetOptions})
    opts = getTargetOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{LangOptions})
    opts = getLangOpts(ci)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{FileManager})
    fm = getFileManager(ci)
    return PrintStats(fm)
end

function PrintStats(ci::CompilerInstance, ::Type{SourceManager})
    sm = getSourceManager(ci)
    return PrintStats(sm)
end

function PrintStats(ci::CompilerInstance, ::Type{HeaderSearch})
    pp = getPreprocessor(ci)
    opts = getHeaderSearchInfo(pp)
    return PrintStats(opts)
end

function PrintStats(ci::CompilerInstance, ::Type{Preprocessor})
    pp = getPreprocessor(ci)
    return PrintStats(pp)
end

function PrintStats(ci::CompilerInstance, ::Type{Sema})
    s = getSema(ci)
    return PrintStats(s)
end

function PrintStats(ci::CompilerInstance, ::Type{ASTContext})
    ctx = getASTContext(ci)
    return PrintStats(ctx)
end

function PrintStats(ci::CompilerInstance, ::Type{ASTConsumer})
    ctx = getASTConsumer(ci)
    return PrintStats(ctx)
end
