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

"""
    createFileManagerWithVOFS4PCH(ci::CompilerInstance, path::AbstractString, mtime::Integer, pch_buffer::LLVM.MemoryBuffer) -> FileManager
Create a file manager backed by an overlay VFS that exposes `pch_buffer` as an in-memory
file at `path` (so a PCH can be loaded without touching the disk). The compiler instance
keeps ownership of the returned file manager.

This function takes ownership of the memory buffer.
"""
function createFileManagerWithVOFS4PCH(ci::CompilerInstance, path::AbstractString,
                                       mtime::Integer, pch_buffer::LLVM.MemoryBuffer)
    @check_ptrs ci
    return FileManager(clang_CompilerInstance_createFileManagerWithVOFS4PCH(ci, path, mtime,
                                                                            pch_buffer))
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
    ref = getFileRef(getFileManager(ci), filename; open_file)
    src_mgr = getSourceManager(ci)
    setMainFileID(src_mgr, ref)
    dispose(ref)
    return nothing
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


# Forwarding options
# Every accessor here forwards through `CompilerInstance::Invocation` with an
# unchecked dereference, hence the `hasInvocation` assertion.
"""
    getAnalyzerOpts(ci::CompilerInstance) -> AnalyzerOptions
Return the `clang::AnalyzerOptions` of this instance's invocation (borrowed view).
"""
function getAnalyzerOpts(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return AnalyzerOptions(clang_CompilerInstance_getAnalyzerOpts(ci))
end

"""
    getDependencyOutputOpts(ci::CompilerInstance) -> DependencyOutputOptions
Return the `clang::DependencyOutputOptions` of this instance's invocation (borrowed view).
"""
function getDependencyOutputOpts(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return DependencyOutputOptions(clang_CompilerInstance_getDependencyOutputOpts(ci))
end

"""
    getFileSystemOpts(ci::CompilerInstance) -> FileSystemOptions
Return the `clang::FileSystemOptions` of this instance's invocation (borrowed view).
"""
function getFileSystemOpts(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return FileSystemOptions(clang_CompilerInstance_getFileSystemOpts(ci))
end

"""
    getPreprocessorOutputOpts(ci::CompilerInstance) -> PreprocessorOutputOptions
Return the `clang::PreprocessorOutputOptions` of this instance's invocation (borrowed view).
"""
function getPreprocessorOutputOpts(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return PreprocessorOutputOptions(clang_CompilerInstance_getPreprocessorOutputOpts(ci))
end

# Module loading
"""
    shouldBuildGlobalModuleIndex(ci::CompilerInstance) -> Bool
Return whether the global module index should be (re)built.
"""
function shouldBuildGlobalModuleIndex(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return clang_CompilerInstance_shouldBuildGlobalModuleIndex(ci)
end

"""
    setBuildGlobalModuleIndex(ci::CompilerInstance, build::Bool)
Set the flag indicating whether the global module index should be (re)built.
"""
function setBuildGlobalModuleIndex(ci::CompilerInstance, build::Bool)
    @check_ptrs ci
    return clang_CompilerInstance_setBuildGlobalModuleIndex(ci, build)
end

"""
    hadModuleLoaderFatalFailure(ci::CompilerInstance) -> Bool
Return whether the module loader hit a fatal failure.
"""
function hadModuleLoaderFatalFailure(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hadModuleLoaderFatalFailure(ci)
end

"""
    getSpecificModuleCachePath(ci::CompilerInstance) -> String
Return the module cache path specialized with the invocation's module hash, or an
empty string when no module cache path is configured.
"""
function getSpecificModuleCachePath(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return get_string(clang_CompilerInstance_getSpecificModuleCachePath(ci))
end

# AuxTarget
"""
    createTarget(ci::CompilerInstance) -> Bool
Create the target and auxiliary target from the current options, reporting problems
through the instance's diagnostics engine.
"""
function createTarget(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    @assert hasDiagnostics(ci) "the compiler instance must have a diagnostics engine"
    return clang_CompilerInstance_createTarget(ci)
end

"""
    getAuxTarget(ci::CompilerInstance) -> TargetInfo
Return the auxiliary target. The carrier holds a NULL pointer when none is set.
"""
function getAuxTarget(ci::CompilerInstance)
    @check_ptrs ci
    return TargetInfo(clang_CompilerInstance_getAuxTarget(ci))
end

"""
    setAuxTarget(ci::CompilerInstance, tgti::TargetInfo)
Replace the current auxiliary target.
"""
function setAuxTarget(ci::CompilerInstance, tgti::TargetInfo)
    @check_ptrs ci tgti
    return clang_CompilerInstance_setAuxTarget(ci, tgti)
end

# Code completion
"""
    hasCodeCompletionConsumer(ci::CompilerInstance) -> Bool
Return whether a code completion consumer has been set.
"""
function hasCodeCompletionConsumer(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasCodeCompletionConsumer(ci)
end

# Output files
"""
    clearOutputFiles(ci::CompilerInstance, erase_files::Bool=false)
Clear the output file list; when `erase_files` is true the files are also erased from
disk. The underlying output streams must have been closed beforehand.
"""
function clearOutputFiles(ci::CompilerInstance, erase_files::Bool=false)
    @check_ptrs ci
    return clang_CompilerInstance_clearOutputFiles(ci, erase_files)
end


# Plugins
"""
    LoadRequestedPlugins(ci::CompilerInstance)
Load the frontend plugins named by the invocation's frontend options. `ci` must
have an invocation.
"""
function LoadRequestedPlugins(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return clang_CompilerInstance_LoadRequestedPlugins(ci)
end

# Frontend timer
"""
    hasFrontendTimer(ci::CompilerInstance) -> Bool
Return whether a frontend timer has been created.
"""
function hasFrontendTimer(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_hasFrontendTimer(ci)
end

"""
    createFrontendTimer(ci::CompilerInstance)
Create the frontend timer, replacing any existing one.
"""
function createFrontendTimer(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_createFrontendTimer(ci)
end


# Ownership transfer
"""
    resetAndLeakFileManager(ci::CompilerInstance)
Drop the instance's ownership of its file manager without destroying it: the object goes
to `llvm::BuryPointer` and lives until the process exits, and `hasFileManager` is false
afterwards. This is the escape hatch for a component another owner has already adopted —
neither owner then frees it twice.
"""
function resetAndLeakFileManager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_resetAndLeakFileManager(ci)
end

"""
    resetAndLeakSourceManager(ci::CompilerInstance)
Drop the instance's ownership of its source manager without destroying it: the object
goes to `llvm::BuryPointer` and lives until the process exits, and `hasSourceManager` is
false afterwards.
"""
function resetAndLeakSourceManager(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_resetAndLeakSourceManager(ci)
end

"""
    resetAndLeakPreprocessor(ci::CompilerInstance)
Pin the instance's preprocessor alive for the rest of the process: a copy of the owning
`shared_ptr` goes to `llvm::BuryPointer`. Unlike the other `resetAndLeak*` this leaves
the instance's own pointer in place, so `hasPreprocessor` still holds afterwards.
"""
function resetAndLeakPreprocessor(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_resetAndLeakPreprocessor(ci)
end

"""
    resetAndLeakASTContext(ci::CompilerInstance)
Drop the instance's ownership of its AST context without destroying it: the object goes
to `llvm::BuryPointer` and lives until the process exits, and `hasASTContext` is false
afterwards.
"""
function resetAndLeakASTContext(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_resetAndLeakASTContext(ci)
end

"""
    resetAndLeakSema(ci::CompilerInstance)
Drop the instance's ownership of its `Sema` without destroying it: the object goes to
`llvm::BuryPointer` and lives until the process exits, and `hasSema` is false afterwards.
"""
function resetAndLeakSema(ci::CompilerInstance)
    @check_ptrs ci
    return clang_CompilerInstance_resetAndLeakSema(ci)
end


"""
    getAPINotesOpts(ci::CompilerInstance) -> APINotesOptions
Return the `clang::APINotesOptions` of this instance's invocation (borrowed view — the
object belongs to the invocation, never `dispose` it). The instance must have an
invocation: `CompilerInstance` forwards through an unchecked `Invocation->` dereference,
hence the `hasInvocation` assertion.

The view's lifetime is whoever ends up owning the invocation, not the caller:
`setInvocation` rewraps the raw handle in a fresh `shared_ptr`, and
`clang_Interpreter_create` consumes the whole `CompilerInstance` even when it fails.
"""
function getAPINotesOpts(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasInvocation(ci) "the compiler instance must have an invocation"
    return APINotesOptions(clang_CompilerInstance_getAPINotesOpts(ci))
end


"""
    getFrontendTimerName(ci::CompilerInstance) -> String
Return the name of the instance's frontend timer. `llvm::Timer` has no LLVM-C handle, so the
timer is published through this accessor and [`isFrontendTimerRunning`](@ref) rather than as
a carrier of its own. The instance must have a frontend timer.
"""
function getFrontendTimerName(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasFrontendTimer(ci) "the compiler instance has no frontend timer"
    return get_string(clang_CompilerInstance_getFrontendTimerName(ci))
end

"""
    isFrontendTimerRunning(ci::CompilerInstance) -> Bool
Return whether the instance's frontend timer is currently between a `startTimer` and a
`stopTimer`. The instance must have a frontend timer.
"""
function isFrontendTimerRunning(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasFrontendTimer(ci) "the compiler instance has no frontend timer"
    return clang_CompilerInstance_isFrontendTimerRunning(ci)
end
