module LibClangEx

using ..ClangCompiler: libclangex
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef

const time_t = Clong


@enum CXInit_Error::UInt32 begin
    CXInit_NoError = 0
    CXInit_CanNotCreate = 1
end

const CXCompilerInstance = Ptr{Cvoid}

const CXTargetOptions = Ptr{Cvoid}

const CXTargetInfo_ = Ptr{Cvoid}

const CXCodeGenOptions = Ptr{Cvoid}

const CXHeaderSearchOptions = Ptr{Cvoid}

const CXPreprocessorOptions = Ptr{Cvoid}

const CXFrontendOptions = Ptr{Cvoid}

const CXLangOptions = Ptr{Cvoid}

const CXDiagnosticIDs = Ptr{Cvoid}

const CXDiagnosticOptions = Ptr{Cvoid}

const CXDiagnosticConsumer = Ptr{Cvoid}

const CXDiagnosticsEngine = Ptr{Cvoid}

const CXCompilerInvocation = Ptr{Cvoid}

const CXDirectoryEntry = Ptr{Cvoid}

const CXFileID = Ptr{Cvoid}

const CXFileEntry = Ptr{Cvoid}

const CXFileEntryRef = Ptr{Cvoid}

const CXFileManager = Ptr{Cvoid}

const CXSourceManager = Ptr{Cvoid}

const CXSourceLocation_ = Ptr{Cvoid}

const CXPreprocessor = Ptr{Cvoid}

const CXHeaderSearch = Ptr{Cvoid}

const CXLexer = Ptr{Cvoid}

const CXToken_ = Ptr{Cvoid}

@enum CXTranslationUnitKind::UInt32 begin
    CXTU_Complete = 0
    CXTU_Prefix = 1
    CXTU_Module = 2
end

const CXASTContext = Ptr{Cvoid}

const CXASTConsumer = Ptr{Cvoid}

const CXType_ = Ptr{Cvoid}

const CXQualType = Ptr{Cvoid}

const CXTranslationUnitDecl = Ptr{Cvoid}

const CXDeclGroupRef = Ptr{Cvoid}

const CXDecl = Ptr{Cvoid}

const CXCodeGenerator = Ptr{Cvoid}

const CXCodeGenModule = Ptr{Cvoid}

const CXSema = Ptr{Cvoid}

const CXParser = Ptr{Cvoid}

const CXFrontendAction = Ptr{Cvoid}

const CXCodeGenAction = Ptr{Cvoid}

const CXXScopeSpec = Ptr{Cvoid}

const CXNestedNameSpecifier = Ptr{Cvoid}

function clang_Parser_create(PP, Actions, SkipFunctionBodies, ErrorCode)
    ccall((:clang_Parser_create, libclangex), CXParser, (CXPreprocessor, CXSema, Bool, Ptr{CXInit_Error}), PP, Actions, SkipFunctionBodies, ErrorCode)
end

function clang_Parser_dispose(P)
    ccall((:clang_Parser_dispose, libclangex), Cvoid, (CXParser,), P)
end

function clang_Parser_Initialize(P)
    ccall((:clang_Parser_Initialize, libclangex), Cvoid, (CXParser,), P)
end

function clang_Parser_tryParseAndSkipInvalidOrParsedDecl(Parser, CodeGen)
    ccall((:clang_Parser_tryParseAndSkipInvalidOrParsedDecl, libclangex), Bool, (CXParser, CXCodeGenerator), Parser, CodeGen)
end

function clang_Parser_parseOneTopLevelDecl(Parser, IsFirstDecl)
    ccall((:clang_Parser_parseOneTopLevelDecl, libclangex), CXDeclGroupRef, (CXParser, Bool), Parser, IsFirstDecl)
end

function clang_ASTConsumer_Initialize(Csr, Ctx)
    ccall((:clang_ASTConsumer_Initialize, libclangex), Cvoid, (CXASTConsumer, CXASTContext), Csr, Ctx)
end

function clang_ASTConsumer_HandleTranslationUnit(Csr, Ctx)
    ccall((:clang_ASTConsumer_HandleTranslationUnit, libclangex), Cvoid, (CXASTConsumer, CXASTContext), Csr, Ctx)
end

function clang_ASTConsumer_PrintStats(Csr)
    ccall((:clang_ASTConsumer_PrintStats, libclangex), Cvoid, (CXASTConsumer,), Csr)
end

function clang_QualType_getTypePtr(OpaquePtr)
    ccall((:clang_QualType_getTypePtr, libclangex), CXType_, (CXQualType,), OpaquePtr)
end

function clang_QualType_getTypePtrOrNull(OpaquePtr)
    ccall((:clang_QualType_getTypePtrOrNull, libclangex), CXType_, (CXQualType,), OpaquePtr)
end

function clang_QualType_isCanonical(OpaquePtr)
    ccall((:clang_QualType_isCanonical, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isNull(OpaquePtr)
    ccall((:clang_QualType_isNull, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isConstQualified(OpaquePtr)
    ccall((:clang_QualType_isConstQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isRestrictQualified(OpaquePtr)
    ccall((:clang_QualType_isRestrictQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isVolatileQualified(OpaquePtr)
    ccall((:clang_QualType_isVolatileQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_addConst(OpaquePtr)
    ccall((:clang_QualType_addConst, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_addVolatile(OpaquePtr)
    ccall((:clang_QualType_addVolatile, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_addRestrict(OpaquePtr)
    ccall((:clang_QualType_addRestrict, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_getAsString(OpaquePtr)
    ccall((:clang_QualType_getAsString, libclangex), Ptr{Cchar}, (CXQualType,), OpaquePtr)
end

function clang_QualType_disposeString(Str)
    ccall((:clang_QualType_disposeString, libclangex), Cvoid, (Ptr{Cchar},), Str)
end

function clang_ASTContext_PrintStats(Ctx)
    ccall((:clang_ASTContext_PrintStats, libclangex), Cvoid, (CXASTContext,), Ctx)
end

function clang_ASTContext_getPointerType(Ctx, OpaquePtr)
    ccall((:clang_ASTContext_getPointerType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, OpaquePtr)
end

function clang_ASTContext_getTranslationUnitDecl(Ctx)
    ccall((:clang_ASTContext_getTranslationUnitDecl, libclangex), CXTranslationUnitDecl, (CXASTContext,), Ctx)
end

function clang_DeclGroupRef_fromeDecl(D)
    ccall((:clang_DeclGroupRef_fromeDecl, libclangex), CXDeclGroupRef, (CXDecl,), D)
end

function clang_DeclGroupRef_isNull(DG)
    ccall((:clang_DeclGroupRef_isNull, libclangex), Bool, (CXDeclGroupRef,), DG)
end

function clang_DeclGroupRef_isSingleDecl(DG)
    ccall((:clang_DeclGroupRef_isSingleDecl, libclangex), Bool, (CXDeclGroupRef,), DG)
end

function clang_DeclGroupRef_isDeclGroup(DG)
    ccall((:clang_DeclGroupRef_isDeclGroup, libclangex), Bool, (CXDeclGroupRef,), DG)
end

function clang_DeclGroupRef_getSingleDecl(DG)
    ccall((:clang_DeclGroupRef_getSingleDecl, libclangex), CXDecl, (CXDeclGroupRef,), DG)
end

function clang_ASTContext_VoidTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_VoidTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_BoolTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_BoolTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_CharTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_CharTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_WCharTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_WCharTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_WideCharTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_WideCharTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_WIntTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_WIntTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char8Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Char8Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char16Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Char16Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char32Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Char32Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_SignedCharTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_SignedCharTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_ShortTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_ShortTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_IntTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_IntTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_LongTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongLongTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_LongLongTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Int128Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Int128Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedCharTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedCharTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedShortTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedShortTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedIntTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedIntTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedLongTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedLongTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedLongLongTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedLongLongTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedInt128Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_UnsignedInt128Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_FloatTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_FloatTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_DoubleTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_DoubleTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongDoubleTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_LongDoubleTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float128Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Float128Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_HalfTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_HalfTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_BFloat16Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_BFloat16Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float16Ty_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Float16Ty_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_FloatComplexTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_FloatComplexTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_DoubleComplexTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_DoubleComplexTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongDoubleComplexTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_LongDoubleComplexTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float128ComplexTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_Float128ComplexTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_VoidPtrTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_VoidPtrTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_ASTContext_NullPtrTy_getTypePtrOrNull(Ctx)
    ccall((:clang_ASTContext_NullPtrTy_getTypePtrOrNull, libclangex), CXType_, (CXASTContext,), Ctx)
end

function clang_CreateLLVMCodeGen(CI, LLVMCtx, ModuleName)
    ccall((:clang_CreateLLVMCodeGen, libclangex), CXCodeGenerator, (CXCompilerInstance, LLVMContextRef, Ptr{Cchar}), CI, LLVMCtx, ModuleName)
end

function clang_CodeGenerator_CGM(CG)
    ccall((:clang_CodeGenerator_CGM, libclangex), CXCodeGenModule, (CXCodeGenerator,), CG)
end

function clang_CodeGenerator_GetModule(CG)
    ccall((:clang_CodeGenerator_GetModule, libclangex), LLVMModuleRef, (CXCodeGenerator,), CG)
end

function clang_CodeGenerator_ReleaseModule(CG)
    ccall((:clang_CodeGenerator_ReleaseModule, libclangex), LLVMModuleRef, (CXCodeGenerator,), CG)
end

function clang_CodeGenerator_GetDeclForMangledName(CG, MangledName)
    ccall((:clang_CodeGenerator_GetDeclForMangledName, libclangex), CXDecl, (CXCodeGenerator, Ptr{Cchar}), CG, MangledName)
end

function clang_CodeGenerator_StartModule(CG, LLVMCtx, ModuleName)
    ccall((:clang_CodeGenerator_StartModule, libclangex), LLVMModuleRef, (CXCodeGenerator, LLVMContextRef, Ptr{Cchar}), CG, LLVMCtx, ModuleName)
end

function clang_EmitAssemblyAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitAssemblyAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_EmitBCAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitBCAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_EmitLLVMAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitLLVMAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_EmitLLVMOnlyAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitLLVMOnlyAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_EmitCodeGenOnlyAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitCodeGenOnlyAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_EmitObjAction_create(ErrorCode, LLVMCtx)
    ccall((:clang_EmitObjAction_create, libclangex), CXCodeGenAction, (Ptr{CXInit_Error}, LLVMContextRef), ErrorCode, LLVMCtx)
end

function clang_CodeGenAction_dispose(CA)
    ccall((:clang_CodeGenAction_dispose, libclangex), Cvoid, (CXCodeGenAction,), CA)
end

function clang_CodeGenAction_takeModule(CA)
    ccall((:clang_CodeGenAction_takeModule, libclangex), LLVMModuleRef, (CXCodeGenAction,), CA)
end

function clang_CompilerInstance_create(ErrorCode)
    ccall((:clang_CompilerInstance_create, libclangex), CXCompilerInstance, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_CompilerInstance_dispose(CI)
    ccall((:clang_CompilerInstance_dispose, libclangex), Cvoid, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_hasDiagnostics(CI)
    ccall((:clang_CompilerInstance_hasDiagnostics, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getDiagnostics(CI)
    ccall((:clang_CompilerInstance_getDiagnostics, libclangex), CXDiagnosticsEngine, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setDiagnostics(CI, Value)
    ccall((:clang_CompilerInstance_setDiagnostics, libclangex), Cvoid, (CXCompilerInstance, CXDiagnosticsEngine), CI, Value)
end

function clang_CompilerInstance_getDiagnosticClient(CI)
    ccall((:clang_CompilerInstance_getDiagnosticClient, libclangex), CXDiagnosticConsumer, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_createDiagnostics(CI, DC, ShouldOwnClient)
    ccall((:clang_CompilerInstance_createDiagnostics, libclangex), Cvoid, (CXCompilerInstance, CXDiagnosticConsumer, Bool), CI, DC, ShouldOwnClient)
end

function clang_CompilerInstance_hasFileManager(CI)
    ccall((:clang_CompilerInstance_hasFileManager, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getFileManager(CI)
    ccall((:clang_CompilerInstance_getFileManager, libclangex), CXFileManager, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setFileManager(CI, FM)
    ccall((:clang_CompilerInstance_setFileManager, libclangex), Cvoid, (CXCompilerInstance, CXFileManager), CI, FM)
end

function clang_CompilerInstance_createFileManager(CI)
    ccall((:clang_CompilerInstance_createFileManager, libclangex), CXFileManager, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_createFileManagerWithVOFS4PCH(CI, Path, ModificationTime, PCHBuffer)
    ccall((:clang_CompilerInstance_createFileManagerWithVOFS4PCH, libclangex), CXFileManager, (CXCompilerInstance, Ptr{Cchar}, time_t, LLVMMemoryBufferRef), CI, Path, ModificationTime, PCHBuffer)
end

function clang_CompilerInstance_hasSourceManager(CI)
    ccall((:clang_CompilerInstance_hasSourceManager, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getSourceManager(CI)
    ccall((:clang_CompilerInstance_getSourceManager, libclangex), CXSourceManager, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setSourceManager(CI, SM)
    ccall((:clang_CompilerInstance_setSourceManager, libclangex), Cvoid, (CXCompilerInstance, CXSourceManager), CI, SM)
end

function clang_CompilerInstance_createSourceManager(CI, FileMgr)
    ccall((:clang_CompilerInstance_createSourceManager, libclangex), Cvoid, (CXCompilerInstance, CXFileManager), CI, FileMgr)
end

function clang_CompilerInstance_hasInvocation(CI)
    ccall((:clang_CompilerInstance_hasInvocation, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getInvocation(CI)
    ccall((:clang_CompilerInstance_getInvocation, libclangex), CXCompilerInvocation, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setInvocation(CI, CInv)
    ccall((:clang_CompilerInstance_setInvocation, libclangex), Cvoid, (CXCompilerInstance, CXCompilerInvocation), CI, CInv)
end

function clang_CompilerInstance_hasTarget(CI)
    ccall((:clang_CompilerInstance_hasTarget, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getTarget(CI)
    ccall((:clang_CompilerInstance_getTarget, libclangex), CXTargetInfo_, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setTarget(CI, Info)
    ccall((:clang_CompilerInstance_setTarget, libclangex), Cvoid, (CXCompilerInstance, CXTargetInfo_), CI, Info)
end

function clang_CompilerInstance_setTargetAndLangOpts(CI)
    ccall((:clang_CompilerInstance_setTargetAndLangOpts, libclangex), Cvoid, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_hasPreprocessor(CI)
    ccall((:clang_CompilerInstance_hasPreprocessor, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getPreprocessor(CI)
    ccall((:clang_CompilerInstance_getPreprocessor, libclangex), CXPreprocessor, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setPreprocessor(CI, PP)
    ccall((:clang_CompilerInstance_setPreprocessor, libclangex), Cvoid, (CXCompilerInstance, CXPreprocessor), CI, PP)
end

function clang_CompilerInstance_createPreprocessor(CI, TUKind)
    ccall((:clang_CompilerInstance_createPreprocessor, libclangex), Cvoid, (CXCompilerInstance, CXTranslationUnitKind), CI, TUKind)
end

function clang_CompilerInstance_hasSema(CI)
    ccall((:clang_CompilerInstance_hasSema, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getSema(CI)
    ccall((:clang_CompilerInstance_getSema, libclangex), CXSema, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setSema(CI, S)
    ccall((:clang_CompilerInstance_setSema, libclangex), Cvoid, (CXCompilerInstance, CXSema), CI, S)
end

function clang_CompilerInstance_createSema(CI, TUKind)
    ccall((:clang_CompilerInstance_createSema, libclangex), Cvoid, (CXCompilerInstance, CXTranslationUnitKind), CI, TUKind)
end

function clang_CompilerInstance_hasASTContext(CI)
    ccall((:clang_CompilerInstance_hasASTContext, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getASTContext(CI)
    ccall((:clang_CompilerInstance_getASTContext, libclangex), CXASTContext, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setASTContext(CI, Ctx)
    ccall((:clang_CompilerInstance_setASTContext, libclangex), Cvoid, (CXCompilerInstance, CXASTContext), CI, Ctx)
end

function clang_CompilerInstance_createASTContext(CI)
    ccall((:clang_CompilerInstance_createASTContext, libclangex), Cvoid, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_hasASTConsumer(CI)
    ccall((:clang_CompilerInstance_hasASTConsumer, libclangex), Bool, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getASTConsumer(CI)
    ccall((:clang_CompilerInstance_getASTConsumer, libclangex), CXASTConsumer, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_setASTConsumer(CI, CG)
    ccall((:clang_CompilerInstance_setASTConsumer, libclangex), Cvoid, (CXCompilerInstance, CXASTConsumer), CI, CG)
end

function clang_CompilerInstance_getCodeGenOpts(CI)
    ccall((:clang_CompilerInstance_getCodeGenOpts, libclangex), CXCodeGenOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getDiagnosticOpts(CI)
    ccall((:clang_CompilerInstance_getDiagnosticOpts, libclangex), CXDiagnosticOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getFrontendOpts(CI)
    ccall((:clang_CompilerInstance_getFrontendOpts, libclangex), CXFrontendOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getHeaderSearchOpts(CI)
    ccall((:clang_CompilerInstance_getHeaderSearchOpts, libclangex), CXHeaderSearchOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getPreprocessorOpts(CI)
    ccall((:clang_CompilerInstance_getPreprocessorOpts, libclangex), CXPreprocessorOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getTargetOpts(CI)
    ccall((:clang_CompilerInstance_getTargetOpts, libclangex), CXTargetOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_getLangOpts(CI)
    ccall((:clang_CompilerInstance_getLangOpts, libclangex), CXLangOptions, (CXCompilerInstance,), CI)
end

function clang_CompilerInstance_ExecuteAction(CI, Act)
    ccall((:clang_CompilerInstance_ExecuteAction, libclangex), Bool, (CXCompilerInstance, CXFrontendAction), CI, Act)
end

function clang_CompilerInvocation_create(ErrorCode)
    ccall((:clang_CompilerInvocation_create, libclangex), CXCompilerInvocation, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_CompilerInvocation_dispose(CI)
    ccall((:clang_CompilerInvocation_dispose, libclangex), Cvoid, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_createFromCommandLine(command_line_args_with_src, num_command_line_args, Diags, ErrorCode)
    ccall((:clang_CompilerInvocation_createFromCommandLine, libclangex), CXCompilerInvocation, (Ptr{Ptr{Cchar}}, Cint, CXDiagnosticsEngine, Ptr{CXInit_Error}), command_line_args_with_src, num_command_line_args, Diags, ErrorCode)
end

function clang_CompilerInvocation_getCodeGenOpts(CI)
    ccall((:clang_CompilerInvocation_getCodeGenOpts, libclangex), CXCodeGenOptions, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_getDiagnosticOpts(CI)
    ccall((:clang_CompilerInvocation_getDiagnosticOpts, libclangex), CXDiagnosticOptions, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_getFrontendOpts(CI)
    ccall((:clang_CompilerInvocation_getFrontendOpts, libclangex), CXFrontendOptions, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_getHeaderSearchOpts(CI)
    ccall((:clang_CompilerInvocation_getHeaderSearchOpts, libclangex), CXHeaderSearchOptions, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_getPreprocessorOpts(CI)
    ccall((:clang_CompilerInvocation_getPreprocessorOpts, libclangex), CXPreprocessorOptions, (CXCompilerInvocation,), CI)
end

function clang_CompilerInvocation_getTargetOpts(CI)
    ccall((:clang_CompilerInvocation_getTargetOpts, libclangex), CXTargetOptions, (CXCompilerInvocation,), CI)
end

function clang_DiagnosticIDs_create(ErrorCode)
    ccall((:clang_DiagnosticIDs_create, libclangex), CXDiagnosticIDs, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_DiagnosticIDs_dispose(ID)
    ccall((:clang_DiagnosticIDs_dispose, libclangex), Cvoid, (CXDiagnosticIDs,), ID)
end

function clang_DiagnosticOptions_create(ErrorCode)
    ccall((:clang_DiagnosticOptions_create, libclangex), CXDiagnosticOptions, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_DiagnosticOptions_dispose(DO)
    ccall((:clang_DiagnosticOptions_dispose, libclangex), Cvoid, (CXDiagnosticOptions,), DO)
end

function clang_DiagnosticOptions_PrintStats(DO)
    ccall((:clang_DiagnosticOptions_PrintStats, libclangex), Cvoid, (CXDiagnosticOptions,), DO)
end

function clang_DiagnosticOptions_setShowColors(DO, ShowColors)
    ccall((:clang_DiagnosticOptions_setShowColors, libclangex), Cvoid, (CXDiagnosticOptions, Bool), DO, ShowColors)
end

function clang_DiagnosticOptions_setShowPresumedLoc(DO, ShowPresumedLoc)
    ccall((:clang_DiagnosticOptions_setShowPresumedLoc, libclangex), Cvoid, (CXDiagnosticOptions, Bool), DO, ShowPresumedLoc)
end

function clang_IgnoringDiagConsumer_create(ErrorCode)
    ccall((:clang_IgnoringDiagConsumer_create, libclangex), CXDiagnosticConsumer, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_TextDiagnosticPrinter_create(Opts, ErrorCode)
    ccall((:clang_TextDiagnosticPrinter_create, libclangex), CXDiagnosticConsumer, (CXDiagnosticOptions, Ptr{CXInit_Error}), Opts, ErrorCode)
end

function clang_DiagnosticConsumer_dispose(DC)
    ccall((:clang_DiagnosticConsumer_dispose, libclangex), Cvoid, (CXDiagnosticConsumer,), DC)
end

function clang_DiagnosticConsumer_BeginSourceFile(DC, LangOpts, PP)
    ccall((:clang_DiagnosticConsumer_BeginSourceFile, libclangex), Cvoid, (CXDiagnosticConsumer, CXLangOptions, CXPreprocessor), DC, LangOpts, PP)
end

function clang_DiagnosticConsumer_EndSourceFile(DC)
    ccall((:clang_DiagnosticConsumer_EndSourceFile, libclangex), Cvoid, (CXDiagnosticConsumer,), DC)
end

function clang_DiagnosticsEngine_create(ID, DO, DC, ShouldOwnClient, ErrorCode)
    ccall((:clang_DiagnosticsEngine_create, libclangex), CXDiagnosticsEngine, (CXDiagnosticIDs, CXDiagnosticOptions, CXDiagnosticConsumer, Bool, Ptr{CXInit_Error}), ID, DO, DC, ShouldOwnClient, ErrorCode)
end

function clang_DiagnosticsEngine_dispose(DE)
    ccall((:clang_DiagnosticsEngine_dispose, libclangex), Cvoid, (CXDiagnosticsEngine,), DE)
end

function clang_DiagnosticsEngine_setShowColors(DE, ShowColors)
    ccall((:clang_DiagnosticsEngine_setShowColors, libclangex), Cvoid, (CXDiagnosticsEngine, Bool), DE, ShowColors)
end

function clang_Driver_GetResourcesPathLength(BinaryPath)
    ccall((:clang_Driver_GetResourcesPathLength, libclangex), Csize_t, (Ptr{Cchar},), BinaryPath)
end

function clang_Driver_GetResourcesPath(BinaryPath, ResourcesPath, N)
    ccall((:clang_Driver_GetResourcesPath, libclangex), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Csize_t), BinaryPath, ResourcesPath, N)
end

function clang_FileManager_create(ErrorCode)
    ccall((:clang_FileManager_create, libclangex), CXFileManager, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_FileManager_dispose(FM)
    ccall((:clang_FileManager_dispose, libclangex), Cvoid, (CXFileManager,), FM)
end

function clang_FileManager_getBufferForFile(FM, FE, isVolatile, RequiresNullTerminator)
    ccall((:clang_FileManager_getBufferForFile, libclangex), LLVMMemoryBufferRef, (CXFileManager, CXFileEntry, Bool, Bool), FM, FE, isVolatile, RequiresNullTerminator)
end

function clang_FileManager_PrintStats(FM)
    ccall((:clang_FileManager_PrintStats, libclangex), Cvoid, (CXFileManager,), FM)
end

function clang_FileManager_getDirectory(FM, DirName, CacheFailure)
    ccall((:clang_FileManager_getDirectory, libclangex), CXDirectoryEntry, (CXFileManager, Ptr{Cchar}, Bool), FM, DirName, CacheFailure)
end

function clang_DirectoryEntry_getName(DE)
    ccall((:clang_DirectoryEntry_getName, libclangex), Ptr{Cchar}, (CXDirectoryEntry,), DE)
end

function clang_FileManager_getFileRef(FM, Filename, OpenFile, CacheFailure)
    ccall((:clang_FileManager_getFileRef, libclangex), CXFileEntryRef, (CXFileManager, Ptr{Cchar}, Bool, Bool), FM, Filename, OpenFile, CacheFailure)
end

function clang_FileEntryRef_dispose(FER)
    ccall((:clang_FileEntryRef_dispose, libclangex), Cvoid, (CXFileEntryRef,), FER)
end

function clang_FileEntryRef_getFileEntry(FER)
    ccall((:clang_FileEntryRef_getFileEntry, libclangex), CXFileEntry, (CXFileEntryRef,), FER)
end

function clang_FileEntry_getName(FE)
    ccall((:clang_FileEntry_getName, libclangex), Ptr{Cchar}, (CXFileEntry,), FE)
end

function clang_FileEntry_tryGetRealPathName(FE)
    ccall((:clang_FileEntry_tryGetRealPathName, libclangex), Ptr{Cchar}, (CXFileEntry,), FE)
end

function clang_FileEntry_isValid(FE)
    ccall((:clang_FileEntry_isValid, libclangex), Bool, (CXFileEntry,), FE)
end

function clang_FileEntry_getUID(FE)
    ccall((:clang_FileEntry_getUID, libclangex), Cuint, (CXFileEntry,), FE)
end

function clang_FileEntry_getModificationTime(FE)
    ccall((:clang_FileEntry_getModificationTime, libclangex), time_t, (CXFileEntry,), FE)
end

function clang_FileEntry_getDir(FE)
    ccall((:clang_FileEntry_getDir, libclangex), CXDirectoryEntry, (CXFileEntry,), FE)
end

function clang_FileEntry_isNamedPipe(FE)
    ccall((:clang_FileEntry_isNamedPipe, libclangex), Bool, (CXFileEntry,), FE)
end

function clang_TargetOptions_create(ErrorCode)
    ccall((:clang_TargetOptions_create, libclangex), CXTargetOptions, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_TargetOptions_dispose(TO)
    ccall((:clang_TargetOptions_dispose, libclangex), Cvoid, (CXTargetOptions,), TO)
end

function clang_TargetOptions_setTriple(TO, TripleStr, Num)
    ccall((:clang_TargetOptions_setTriple, libclangex), Cvoid, (CXTargetOptions, Ptr{Cchar}, Csize_t), TO, TripleStr, Num)
end

function clang_TargetOptions_PrintStats(TO)
    ccall((:clang_TargetOptions_PrintStats, libclangex), Cvoid, (CXTargetOptions,), TO)
end

function clang_TargetInfo_CreateTargetInfo(DE, Opts)
    ccall((:clang_TargetInfo_CreateTargetInfo, libclangex), CXTargetInfo_, (CXDiagnosticsEngine, CXTargetOptions), DE, Opts)
end

function clang_CodeGenOptions_create(ErrorCode)
    ccall((:clang_CodeGenOptions_create, libclangex), CXCodeGenOptions, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_CodeGenOptions_dispose(DO)
    ccall((:clang_CodeGenOptions_dispose, libclangex), Cvoid, (CXCodeGenOptions,), DO)
end

function clang_CodeGenOptions_getArgv0(CGO)
    ccall((:clang_CodeGenOptions_getArgv0, libclangex), Ptr{Cchar}, (CXCodeGenOptions,), CGO)
end

function clang_CodeGenOptions_getCommandLineArgsNum(CGO)
    ccall((:clang_CodeGenOptions_getCommandLineArgsNum, libclangex), Csize_t, (CXCodeGenOptions,), CGO)
end

function clang_CodeGenOptions_getCommandLineArgs(CGO, ArgsOut, Num)
    ccall((:clang_CodeGenOptions_getCommandLineArgs, libclangex), Cvoid, (CXCodeGenOptions, Ptr{Ptr{Cchar}}, Csize_t), CGO, ArgsOut, Num)
end

function clang_CodeGenOptions_PrintStats(CGO)
    ccall((:clang_CodeGenOptions_PrintStats, libclangex), Cvoid, (CXCodeGenOptions,), CGO)
end

function clang_HeaderSearchOptions_GetResourceDirLength(HSO)
    ccall((:clang_HeaderSearchOptions_GetResourceDirLength, libclangex), Csize_t, (CXHeaderSearchOptions,), HSO)
end

function clang_HeaderSearchOptions_GetResourceDir(HSO, ResourcesDir, N)
    ccall((:clang_HeaderSearchOptions_GetResourceDir, libclangex), Cvoid, (CXHeaderSearchOptions, Ptr{Cchar}, Csize_t), HSO, ResourcesDir, N)
end

function clang_HeaderSearchOptions_SetResourceDir(HSO, ResourcesDir, N)
    ccall((:clang_HeaderSearchOptions_SetResourceDir, libclangex), Cvoid, (CXHeaderSearchOptions, Ptr{Cchar}, Csize_t), HSO, ResourcesDir, N)
end

function clang_HeaderSearchOptions_PrintStats(HSO)
    ccall((:clang_HeaderSearchOptions_PrintStats, libclangex), Cvoid, (CXHeaderSearchOptions,), HSO)
end

function clang_PreprocessorOptions_getIncludesNum(PPO)
    ccall((:clang_PreprocessorOptions_getIncludesNum, libclangex), Csize_t, (CXPreprocessorOptions,), PPO)
end

function clang_PreprocessorOptions_getIncludes(PPO, IncsOut, Num)
    ccall((:clang_PreprocessorOptions_getIncludes, libclangex), Cvoid, (CXPreprocessorOptions, Ptr{Ptr{Cchar}}, Csize_t), PPO, IncsOut, Num)
end

function clang_PreprocessorOptions_PrintStats(PPO)
    ccall((:clang_PreprocessorOptions_PrintStats, libclangex), Cvoid, (CXPreprocessorOptions,), PPO)
end

function clang_FrontendOptions_PrintStats(FEO)
    ccall((:clang_FrontendOptions_PrintStats, libclangex), Cvoid, (CXFrontendOptions,), FEO)
end

function clang_LangOptions_PrintStats(LO)
    ccall((:clang_LangOptions_PrintStats, libclangex), Cvoid, (CXLangOptions,), LO)
end

function clang_Lexer_create(FID, FromFile, SM, langOpts, ErrorCode)
    ccall((:clang_Lexer_create, libclangex), CXLexer, (CXFileID, LLVMMemoryBufferRef, CXSourceManager, CXLangOptions, Ptr{CXInit_Error}), FID, FromFile, SM, langOpts, ErrorCode)
end

function clang_Lexer_dispose(Lex)
    ccall((:clang_Lexer_dispose, libclangex), Cvoid, (CXLexer,), Lex)
end

function clang_Preprocessor_getHeaderSearchInfo(PP)
    ccall((:clang_Preprocessor_getHeaderSearchInfo, libclangex), CXHeaderSearch, (CXPreprocessor,), PP)
end

function clang_HeaderSearch_PrintStats(HS)
    ccall((:clang_HeaderSearch_PrintStats, libclangex), Cvoid, (CXHeaderSearch,), HS)
end

function clang_Preprocessor_EnterMainSourceFile(PP)
    ccall((:clang_Preprocessor_EnterMainSourceFile, libclangex), Cvoid, (CXPreprocessor,), PP)
end

function clang_Preprocessor_EnterSourceFile(PP, FID, Loc)
    ccall((:clang_Preprocessor_EnterSourceFile, libclangex), Bool, (CXPreprocessor, CXFileID, CXSourceLocation_), PP, FID, Loc)
end

function clang_Preprocessor_EndSourceFile(PP)
    ccall((:clang_Preprocessor_EndSourceFile, libclangex), Cvoid, (CXPreprocessor,), PP)
end

function clang_Preprocessor_PrintStats(PP)
    ccall((:clang_Preprocessor_PrintStats, libclangex), Cvoid, (CXPreprocessor,), PP)
end

function clang_Preprocessor_InitializeBuiltins(PP)
    ccall((:clang_Preprocessor_InitializeBuiltins, libclangex), Cvoid, (CXPreprocessor,), PP)
end

function clang_Sema_setCollectStats(S, ShouldCollect)
    ccall((:clang_Sema_setCollectStats, libclangex), Cvoid, (CXSema, Bool), S, ShouldCollect)
end

function clang_Sema_processWeakTopLevelDecls(Sema, CodeGen)
    ccall((:clang_Sema_processWeakTopLevelDecls, libclangex), Cvoid, (CXSema, CXCodeGenerator), Sema, CodeGen)
end

function clang_Sema_PrintStats(S)
    ccall((:clang_Sema_PrintStats, libclangex), Cvoid, (CXSema,), S)
end

function clang_SourceManager_create(Diag, FileMgr, UserFilesAreVolatile, ErrorCode)
    ccall((:clang_SourceManager_create, libclangex), CXSourceManager, (CXDiagnosticsEngine, CXFileManager, Bool, Ptr{CXInit_Error}), Diag, FileMgr, UserFilesAreVolatile, ErrorCode)
end

function clang_SourceManager_dispose(SM)
    ccall((:clang_SourceManager_dispose, libclangex), Cvoid, (CXSourceManager,), SM)
end

function clang_SourceManager_PrintStats(SM)
    ccall((:clang_SourceManager_PrintStats, libclangex), Cvoid, (CXSourceManager,), SM)
end

function clang_FileID_getHashValue(FID)
    ccall((:clang_FileID_getHashValue, libclangex), Cuint, (CXFileID,), FID)
end

function clang_FileID_dispose(FID)
    ccall((:clang_FileID_dispose, libclangex), Cvoid, (CXFileID,), FID)
end

function clang_SourceManager_createFileIDFromMemoryBuffer(SM, MB)
    ccall((:clang_SourceManager_createFileIDFromMemoryBuffer, libclangex), CXFileID, (CXSourceManager, LLVMMemoryBufferRef), SM, MB)
end

function clang_SourceManager_createFileIDFromFileEntry(SM, FE, Loc)
    ccall((:clang_SourceManager_createFileIDFromFileEntry, libclangex), CXFileID, (CXSourceManager, CXFileEntry, CXSourceLocation_), SM, FE, Loc)
end

function clang_SourceManager_getMainFileID(SM)
    ccall((:clang_SourceManager_getMainFileID, libclangex), CXFileID, (CXSourceManager,), SM)
end

function clang_SourceManager_setMainFileID(SM, ID)
    ccall((:clang_SourceManager_setMainFileID, libclangex), Cvoid, (CXSourceManager, CXFileID), SM, ID)
end

function clang_SourceManager_overrideFileContents(SM, FE, MB)
    ccall((:clang_SourceManager_overrideFileContents, libclangex), Cvoid, (CXSourceManager, CXFileEntry, LLVMMemoryBufferRef), SM, FE, MB)
end

function clang_SourceLocation_createInvalid()
    ccall((:clang_SourceLocation_createInvalid, libclangex), CXSourceLocation_, ())
end

function clang_SourceLocation_isFileID(Loc)
    ccall((:clang_SourceLocation_isFileID, libclangex), Bool, (CXSourceLocation_,), Loc)
end

function clang_SourceLocation_isMacroID(Loc)
    ccall((:clang_SourceLocation_isMacroID, libclangex), Bool, (CXSourceLocation_,), Loc)
end

function clang_SourceLocation_isValid(Loc)
    ccall((:clang_SourceLocation_isValid, libclangex), Bool, (CXSourceLocation_,), Loc)
end

function clang_SourceLocation_isInvalid(Loc)
    ccall((:clang_SourceLocation_isInvalid, libclangex), Bool, (CXSourceLocation_,), Loc)
end

function clang_SourceLocation_isPairOfFileLocations(Start, End)
    ccall((:clang_SourceLocation_isPairOfFileLocations, libclangex), Bool, (CXSourceLocation_, CXSourceLocation_), Start, End)
end

function clang_SourceLocation_getHashValue(Loc)
    ccall((:clang_SourceLocation_getHashValue, libclangex), Cuint, (CXSourceLocation_,), Loc)
end

function clang_SourceLocation_dump(Loc, SM)
    ccall((:clang_SourceLocation_dump, libclangex), Cvoid, (CXSourceLocation_, CXSourceManager), Loc, SM)
end

function clang_SourceLocation_printToString(Loc, SM)
    ccall((:clang_SourceLocation_printToString, libclangex), Ptr{Cchar}, (CXSourceLocation_, CXSourceManager), Loc, SM)
end

function clang_SourceLocation_disposeString(Str)
    ccall((:clang_SourceLocation_disposeString, libclangex), Cvoid, (Ptr{Cchar},), Str)
end

function clang_ParseAST(Sema, PrintStats, SkipFunctionBodies)
    ccall((:clang_ParseAST, libclangex), Cvoid, (CXSema, Bool, Bool), Sema, PrintStats, SkipFunctionBodies)
end

function clang_Decl_EnableStatistics()
    ccall((:clang_Decl_EnableStatistics, libclangex), Cvoid, ())
end

function clang_Stmt_EnableStatistics()
    ccall((:clang_Stmt_EnableStatistics, libclangex), Cvoid, ())
end

function clang_Decl_PrintStats()
    ccall((:clang_Decl_PrintStats, libclangex), Cvoid, ())
end

function clang_Stmt_PrintStats()
    ccall((:clang_Stmt_PrintStats, libclangex), Cvoid, ())
end

function clang_Decl_dumpColor(DC)
    ccall((:clang_Decl_dumpColor, libclangex), Cvoid, (CXDecl,), DC)
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
