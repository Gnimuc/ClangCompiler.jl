module LibClangEx

using ..ClangCompiler: libclangex
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef, LLVMGenericValueRef
using LLVM.API: LLVMTypeRef

const time_t = Clong


struct CXString
    data::Ptr{Cvoid}
    private_flags::Cuint
end

struct CXStringSet
    Strings::Ptr{CXString}
    Count::Cuint
end

@enum CXInit_Error::UInt32 begin
    CXInit_NoError = 0
    CXInit_CanNotCreate = 1
end

const CXASTConsumer = Ptr{Cvoid}

const CXASTContext = Ptr{Cvoid}

const CXTranslationUnitDecl = Ptr{Cvoid}

const CXPragmaCommentDecl = Ptr{Cvoid}

const CXPragmaDetectMismatchDecl = Ptr{Cvoid}

const CXExternCContextDecl = Ptr{Cvoid}

const CXNamedDecl = Ptr{Cvoid}

const CXLabelDecl = Ptr{Cvoid}

const CXNamespaceDecl = Ptr{Cvoid}

const CXValueDecl = Ptr{Cvoid}

const CXDeclaratorDecl = Ptr{Cvoid}

const CXEvaluatedStmt = Ptr{Cvoid}

const CXVarDecl = Ptr{Cvoid}

const CXImplicitParamDecl = Ptr{Cvoid}

const CXParmVarDecl = Ptr{Cvoid}

const CXFunctionDecl = Ptr{Cvoid}

const CXFieldDecl = Ptr{Cvoid}

const CXEnumConstantDecl = Ptr{Cvoid}

const CXIndirectFieldDecl = Ptr{Cvoid}

const CXTypeDecl = Ptr{Cvoid}

const CXTypedefNameDecl = Ptr{Cvoid}

const CXTypedefDecl = Ptr{Cvoid}

const CXTypeAliasDecl = Ptr{Cvoid}

const CXTagDecl = Ptr{Cvoid}

const CXEnumDecl = Ptr{Cvoid}

const CXRecordDecl = Ptr{Cvoid}

const CXFileScopeAsmDecl = Ptr{Cvoid}

const CXBlockDecl = Ptr{Cvoid}

const CXCapturedDecl = Ptr{Cvoid}

const CXImportDecl = Ptr{Cvoid}

const CXExportDecl = Ptr{Cvoid}

const CXEmptyDecl = Ptr{Cvoid}

const CXDeclarationName = Ptr{Cvoid}

const CXDeclarationNameInfo = Ptr{Cvoid}

const CXDecl = Ptr{Cvoid}

const CXDeclContext = Ptr{Cvoid}

const CXAccessSpecDecl = Ptr{Cvoid}

const CXCXXBaseSpecifier = Ptr{Cvoid}

const CXCXXRecordDecl = Ptr{Cvoid}

const CXExplicitSpecifier = Ptr{Cvoid}

const CXCXXDeductionGuideDecl = Ptr{Cvoid}

const CXRequiresExprBodyDecl = Ptr{Cvoid}

const CXCXXMethodDecl = Ptr{Cvoid}

const CXCXXCtorInitializer = Ptr{Cvoid}

const CXCXXConstructorDecl = Ptr{Cvoid}

const CXCXXDestructorDecl = Ptr{Cvoid}

const CXCXXConversionDecl = Ptr{Cvoid}

const CXLinkageSpecDecl = Ptr{Cvoid}

const CXUsingDirectiveDecl = Ptr{Cvoid}

const CXNamespaceAliasDecl = Ptr{Cvoid}

const CXLifetimeExtendedTemporaryDecl = Ptr{Cvoid}

const CXUsingShadowDecl = Ptr{Cvoid}

const CXConstructorUsingShadowDecl = Ptr{Cvoid}

const CXUsingDecl = Ptr{Cvoid}

const CXUsingPackDecl = Ptr{Cvoid}

const CXUnresolvedUsingValueDecl = Ptr{Cvoid}

const CXUnresolvedUsingTypenameDecl = Ptr{Cvoid}

const CXStaticAssertDecl = Ptr{Cvoid}

const CXBindingDecl = Ptr{Cvoid}

const CXDecompositionDecl = Ptr{Cvoid}

const CXMSPropertyDecl = Ptr{Cvoid}

const CXMSGuidDecl = Ptr{Cvoid}

const CXDeclGroupRef = Ptr{Cvoid}

const CXTemplateParameterList = Ptr{Cvoid}

const CXTemplateArgumentList = Ptr{Cvoid}

const CXTemplateDecl = Ptr{Cvoid}

const CXFunctionTemplateSpecializationInfo = Ptr{Cvoid}

const CXMemberSpecializationInfo = Ptr{Cvoid}

const CXDependentFunctionTemplateSpecializationInfo = Ptr{Cvoid}

const CXRedeclarableTemplateDecl = Ptr{Cvoid}

const CXFunctionTemplateDecl = Ptr{Cvoid}

const CXTemplateTypeParmDecl = Ptr{Cvoid}

const CXNonTypeTemplateParmDecl = Ptr{Cvoid}

const CXTemplateTemplateParmDecl = Ptr{Cvoid}

const CXBuiltinTemplateDecl = Ptr{Cvoid}

const CXClassTemplateSpecializationDecl = Ptr{Cvoid}

const CXClassTemplatePartialSpecializationDecl = Ptr{Cvoid}

const CXClassTemplateDecl = Ptr{Cvoid}

const CXFriendTemplateDecl = Ptr{Cvoid}

const CXTypeAliasTemplateDecl = Ptr{Cvoid}

const CXClassScopeFunctionSpecializationDecl = Ptr{Cvoid}

const CXVarTemplateSpecializationDecl = Ptr{Cvoid}

const CXVarTemplatePartialSpecializationDecl = Ptr{Cvoid}

const CXVarTemplateDecl = Ptr{Cvoid}

const CXConceptDecl = Ptr{Cvoid}

const CXTemplateParamObjectDecl = Ptr{Cvoid}

const CXExpr = Ptr{Cvoid}

const CXFullExpr = Ptr{Cvoid}

const CXConstantExpr = Ptr{Cvoid}

const CXOpaqueValueExpr = Ptr{Cvoid}

const CXDeclRefExpr = Ptr{Cvoid}

const CXAPNumericStorage = Ptr{Cvoid}

const CXAPIntStorage = Ptr{Cvoid}

const CXAPFloatStorage = Ptr{Cvoid}

const CXIntegerLiteral = Ptr{Cvoid}

const CXFixedPointLiteral = Ptr{Cvoid}

const CXCharacterLiteral = Ptr{Cvoid}

const CXFloatingLiteral = Ptr{Cvoid}

const CXImaginaryLiteral = Ptr{Cvoid}

const CXStringLiteral = Ptr{Cvoid}

const CXPredefinedExpr = Ptr{Cvoid}

const CXParenExpr = Ptr{Cvoid}

const CXUnaryOperator = Ptr{Cvoid}

const CXOffsetOfNode = Ptr{Cvoid}

const CXOffsetOfExpr = Ptr{Cvoid}

const CXUnaryExprOrTypeTraitExpr = Ptr{Cvoid}

const CXArraySubscriptExpr = Ptr{Cvoid}

const CXMatrixSubscriptExpr = Ptr{Cvoid}

const CXCallExpr = Ptr{Cvoid}

const CXMemberExpr = Ptr{Cvoid}

const CXCompoundLiteralExpr = Ptr{Cvoid}

const CXCastExpr = Ptr{Cvoid}

const CXImplicitCastExpr = Ptr{Cvoid}

const CXExplicitCastExpr = Ptr{Cvoid}

const CXCStyleCastExpr = Ptr{Cvoid}

const CXBinaryOperator = Ptr{Cvoid}

const CXCompoundAssignOperator = Ptr{Cvoid}

const CXAbstractConditionalOperator = Ptr{Cvoid}

const CXConditionalOperator = Ptr{Cvoid}

const CXBinaryConditionalOperator = Ptr{Cvoid}

const CXAddrLabelExpr = Ptr{Cvoid}

const CXStmtExpr = Ptr{Cvoid}

const CXShuffleVectorExpr = Ptr{Cvoid}

const CXConvertVectorExpr = Ptr{Cvoid}

const CXChooseExpr = Ptr{Cvoid}

const CXGNUNullExpr = Ptr{Cvoid}

const CXVAArgExpr = Ptr{Cvoid}

const CXSourceLocExpr = Ptr{Cvoid}

const CXInitListExpr = Ptr{Cvoid}

const CXDesignatedInitExpr = Ptr{Cvoid}

const CXNoInitExpr = Ptr{Cvoid}

const CXDesignatedInitUpdateExpr = Ptr{Cvoid}

const CXArrayInitLoopExpr = Ptr{Cvoid}

const CXArrayInitIndexExpr = Ptr{Cvoid}

const CXImplicitValueInitExpr = Ptr{Cvoid}

const CXParenListExpr = Ptr{Cvoid}

const CXGenericSelectionExpr = Ptr{Cvoid}

const CXExtVectorElementExpr = Ptr{Cvoid}

const CXBlockExpr = Ptr{Cvoid}

const CXBlockVarCopyInit = Ptr{Cvoid}

const CXAsTypeExpr = Ptr{Cvoid}

const CXPseudoObjectExpr = Ptr{Cvoid}

const CXAtomicExpr = Ptr{Cvoid}

const CXTypoExpr = Ptr{Cvoid}

const CXRecoveryExpr = Ptr{Cvoid}

const CXCXXOperatorCallExpr = Ptr{Cvoid}

const CXCXXMemberCallExpr = Ptr{Cvoid}

const CXCUDAKernelCallExpr = Ptr{Cvoid}

const CXCXXRewrittenBinaryOperator = Ptr{Cvoid}

const CXCXXNamedCastExpr = Ptr{Cvoid}

const CXCXXStaticCastExpr = Ptr{Cvoid}

const CXCXXDynamicCastExpr = Ptr{Cvoid}

const CXCXXReinterpretCastExpr = Ptr{Cvoid}

const CXCXXConstCastExpr = Ptr{Cvoid}

const CXCXXAddrspaceCastExpr = Ptr{Cvoid}

const CXUserDefinedLiteral = Ptr{Cvoid}

const CXCXXBoolLiteralExpr = Ptr{Cvoid}

const CXCXXNullPtrLiteralExpr = Ptr{Cvoid}

const CXCXXStdInitializerListExpr = Ptr{Cvoid}

const CXCXXTypeidExpr = Ptr{Cvoid}

const CXMSPropertyRefExpr = Ptr{Cvoid}

const CXMSPropertySubscriptExpr = Ptr{Cvoid}

const CXCXXUuidofExpr = Ptr{Cvoid}

const CXCXXThisExpr = Ptr{Cvoid}

const CXCXXThrowExpr = Ptr{Cvoid}

const CXCXXDefaultArgExpr = Ptr{Cvoid}

const CXCXXDefaultInitExpr = Ptr{Cvoid}

const CXCXXBindTemporaryExpr = Ptr{Cvoid}

const CXCXXConstructExpr = Ptr{Cvoid}

const CXCXXInheritedCtorInitExpr = Ptr{Cvoid}

const CXCXXFunctionalCastExpr = Ptr{Cvoid}

const CXCXXTemporaryObjectExpr = Ptr{Cvoid}

const CXLambdaExpr = Ptr{Cvoid}

const CXCXXScalarValueInitExpr = Ptr{Cvoid}

const CXCXXNewExpr = Ptr{Cvoid}

const CXCXXDeleteExpr = Ptr{Cvoid}

const CXCXXPseudoDestructorExpr = Ptr{Cvoid}

const CXTypeTraitExpr = Ptr{Cvoid}

const CXArrayTypeTraitExpr = Ptr{Cvoid}

const CXExpressionTraitExpr = Ptr{Cvoid}

const CXOverloadExpr = Ptr{Cvoid}

const CXUnresolvedLookupExpr = Ptr{Cvoid}

const CXDependentScopeDeclRefExpr = Ptr{Cvoid}

const CXCXXUnresolvedConstructExpr = Ptr{Cvoid}

const CXCXXDependentScopeMemberExpr = Ptr{Cvoid}

const CXUnresolvedMemberExpr = Ptr{Cvoid}

const CXCXXNoexceptExpr = Ptr{Cvoid}

const CXPackExpansionExpr = Ptr{Cvoid}

const CXSizeOfPackExpr = Ptr{Cvoid}

const CXSubstNonTypeTemplateParmExpr = Ptr{Cvoid}

const CXSubstNonTypeTemplateParmPackExpr = Ptr{Cvoid}

const CXFunctionParmPackExpr = Ptr{Cvoid}

const CXMaterializeTemporaryExpr = Ptr{Cvoid}

const CXCXXFoldExpr = Ptr{Cvoid}

const CXCoroutineSuspendExpr = Ptr{Cvoid}

const CXCoawaitExpr = Ptr{Cvoid}

const CXDependentCoawaitExpr = Ptr{Cvoid}

const CXCoyieldExpr = Ptr{Cvoid}

const CXBuiltinBitCastExpr = Ptr{Cvoid}

const CXMangleContext = Ptr{Cvoid}

const CXItaniumMangleContext = Ptr{Cvoid}

const CXMicrosoftMangleContext = Ptr{Cvoid}

const CXASTNameGenerator = Ptr{Cvoid}

const CXNestedNameSpecifier = Ptr{Cvoid}

const CXStmt = Ptr{Cvoid}

const CXDeclStmt = Ptr{Cvoid}

const CXNullStmt = Ptr{Cvoid}

const CXCompoundStmt = Ptr{Cvoid}

const CXSwitchCase = Ptr{Cvoid}

const CXCaseStmt = Ptr{Cvoid}

const CXDefaultStmt = Ptr{Cvoid}

const CXValueStmt = Ptr{Cvoid}

const CXLabelStmt = Ptr{Cvoid}

const CXAttributedStmt = Ptr{Cvoid}

const CXIfStmt = Ptr{Cvoid}

const CXSwitchStmt = Ptr{Cvoid}

const CXWhileStmt = Ptr{Cvoid}

const CXDoStmt = Ptr{Cvoid}

const CXForStmt = Ptr{Cvoid}

const CXGotoStmt = Ptr{Cvoid}

const CXIndirectGotoStmt = Ptr{Cvoid}

const CXContinueStmt = Ptr{Cvoid}

const CXBreakStmt = Ptr{Cvoid}

const CXReturnStmt = Ptr{Cvoid}

const CXAsmStmt = Ptr{Cvoid}

const CXGCCAsmStmt = Ptr{Cvoid}

const CXMSAsmStmt = Ptr{Cvoid}

const CXSEHExceptStmt = Ptr{Cvoid}

const CXSEHFinallyStmt = Ptr{Cvoid}

const CXSEHTryStmt = Ptr{Cvoid}

const CXSEHLeaveStmt = Ptr{Cvoid}

const CXCapturedStmt = Ptr{Cvoid}

const CXCXXCatchStmt = Ptr{Cvoid}

const CXCXXTryStmt = Ptr{Cvoid}

const CXCXXForRangeStmt = Ptr{Cvoid}

const CXMSDependentExistsStmt = Ptr{Cvoid}

const CXCoroutineBodyStmt = Ptr{Cvoid}

const CXCoreturnStmt = Ptr{Cvoid}

const CXQualType = Ptr{Cvoid}

const CXType_ = Ptr{Cvoid}

const CXBuiltinType = Ptr{Cvoid}

const CXComplexType = Ptr{Cvoid}

const CXParenType = Ptr{Cvoid}

const CXPointerType = Ptr{Cvoid}

const CXAdjustedType = Ptr{Cvoid}

const CXDecayedType = Ptr{Cvoid}

const CXBlockPointerType = Ptr{Cvoid}

const CXReferenceType = Ptr{Cvoid}

const CXLValueReferenceType = Ptr{Cvoid}

const CXRValueReferenceType = Ptr{Cvoid}

const CXMemberPointerType = Ptr{Cvoid}

const CXArrayType = Ptr{Cvoid}

const CXConstantArrayType = Ptr{Cvoid}

const CXIncompleteArrayType = Ptr{Cvoid}

const CXVariableArrayType = Ptr{Cvoid}

const CXDependentSizedArrayType = Ptr{Cvoid}

const CXDependentAddressSpaceType = Ptr{Cvoid}

const CXDependentSizedExtVectorType = Ptr{Cvoid}

const CXVectorType = Ptr{Cvoid}

const CXDependentVectorType = Ptr{Cvoid}

const CXExtVectorType = Ptr{Cvoid}

const CXMatrixType = Ptr{Cvoid}

const CXConstantMatrixType = Ptr{Cvoid}

const CXDependentSizedMatrixType = Ptr{Cvoid}

const CXFunctionType = Ptr{Cvoid}

const CXFunctionNoProtoType = Ptr{Cvoid}

const CXFunctionProtoType = Ptr{Cvoid}

const CXUnresolvedUsingType = Ptr{Cvoid}

const CXTypedefType = Ptr{Cvoid}

const CXMacroQualifiedType = Ptr{Cvoid}

const CXTypeOfExprType = Ptr{Cvoid}

const CXDependentTypeOfExprType = Ptr{Cvoid}

const CXTypeOfType = Ptr{Cvoid}

const CXDecltypeType = Ptr{Cvoid}

const CXDependentDecltypeType = Ptr{Cvoid}

const CXUnaryTransformType = Ptr{Cvoid}

const CXDependentUnaryTransformType = Ptr{Cvoid}

const CXTagType = Ptr{Cvoid}

const CXRecordType = Ptr{Cvoid}

const CXEnumType = Ptr{Cvoid}

const CXAttributedType = Ptr{Cvoid}

const CXTemplateTypeParmType = Ptr{Cvoid}

const CXSubstTemplateTypeParmType = Ptr{Cvoid}

const CXSubstTemplateTypeParmPackType = Ptr{Cvoid}

const CXTemplateSpecializationType = Ptr{Cvoid}

const CXDeducedType = Ptr{Cvoid}

const CXAutoType = Ptr{Cvoid}

const CXDeducedTemplateSpecializationType = Ptr{Cvoid}

const CXInjectedClassNameType = Ptr{Cvoid}

const CXTypeWithKeyword = Ptr{Cvoid}

const CXElaboratedType = Ptr{Cvoid}

const CXDependentNameType = Ptr{Cvoid}

const CXDependentTemplateSpecializationType = Ptr{Cvoid}

const CXPackExpansionType = Ptr{Cvoid}

const CXObjCTypeParamType = Ptr{Cvoid}

const CXObjCObjectType = Ptr{Cvoid}

const CXObjCInterfaceType = Ptr{Cvoid}

const CXObjCObjectPointerType = Ptr{Cvoid}

const CXAtomicType = Ptr{Cvoid}

const CXPipeType = Ptr{Cvoid}

const CXExtIntType = Ptr{Cvoid}

const CXDependentExtIntType = Ptr{Cvoid}

const CXQualifierCollector = Ptr{Cvoid}

const CXTypeSourceInfo = Ptr{Cvoid}

const CXTemplateName = Ptr{Cvoid}

const CXTemplateArgumentLocInfo = Ptr{Cvoid}

const CXTemplateArgumentLoc = Ptr{Cvoid}

const CXTemplateArgumentListInfo = Ptr{Cvoid}

const CXASTTemplateArgumentListInfo = Ptr{Cvoid}

const CXTemplateArgument = Ptr{Cvoid}

const CXCodeGenOptions = Ptr{Cvoid}

const CXDiagnosticConsumer = Ptr{Cvoid}

const CXDiagnosticsEngine = Ptr{Cvoid}

const CXDiagnosticIDs = Ptr{Cvoid}

const CXDiagnosticOptions = Ptr{Cvoid}

const CXFileEntry = Ptr{Cvoid}

const CXDirectoryEntry = Ptr{Cvoid}

const CXFileEntryRef = Ptr{Cvoid}

const CXFileManager = Ptr{Cvoid}

const CXIdentifierInfo = Ptr{Cvoid}

const CXIdentifierTable = Ptr{Cvoid}

const CXLangOptions = Ptr{Cvoid}

const CXModule = Ptr{Cvoid}

const CXSourceLocation_ = Ptr{Cvoid}

struct CXSourceRange_
    B::CXSourceLocation_
    E::CXSourceLocation_
end

const CXFileID = Ptr{Cvoid}

const CXSourceManager = Ptr{Cvoid}

const CXTargetInfo_ = Ptr{Cvoid}

const CXTargetOptions = Ptr{Cvoid}

const CXCodeGenAction = Ptr{Cvoid}

const CXCodeGenerator = Ptr{Cvoid}

const CXCodeGenModule = Ptr{Cvoid}

const CXCompilerInstance = Ptr{Cvoid}

const CXCompilerInvocation = Ptr{Cvoid}

const CXFrontendOptions = Ptr{Cvoid}

const CXHeaderSearch = Ptr{Cvoid}

const CXHeaderSearchOptions = Ptr{Cvoid}

const CXLexer = Ptr{Cvoid}

const CXPreprocessor = Ptr{Cvoid}

const CXPreprocessorOptions = Ptr{Cvoid}

const CXToken_ = Ptr{Cvoid}

const CXAnnotationValue = Ptr{Cvoid}

const CXParser = Ptr{Cvoid}

const CXSema = Ptr{Cvoid}

const CXCXXScopeSpec = Ptr{Cvoid}

const CXLookupResult = Ptr{Cvoid}

const CXScope = Ptr{Cvoid}

@enum CXTranslationUnitKind::UInt32 begin
    CXTranslationUnitKind_TU_Complete = 0
    CXTranslationUnitKind_TU_Prefix = 1
    CXTranslationUnitKind_TU_Module = 2
    CXTranslationUnitKind_TU_Incremental = 3
end

const CXFrontendAction = Ptr{Cvoid}

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

function clang_TextDiagnosticPrinter_create(Opts, ErrorCode)
    ccall((:clang_TextDiagnosticPrinter_create, libclangex), CXDiagnosticConsumer, (CXDiagnosticOptions, Ptr{CXInit_Error}), Opts, ErrorCode)
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
    ccall((:clang_SourceLocation_printToString, libclangex), CXString, (CXSourceLocation_, CXSourceManager), Loc, SM)
end

function clang_SourceLocation_getLocWithOffset(Loc, Offset)
    ccall((:clang_SourceLocation_getLocWithOffset, libclangex), CXSourceLocation_, (CXSourceLocation_, Cint), Loc, Offset)
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

@enum CXLookupNameKind::UInt32 begin
    CXLookupNameKind_LookupOrdinaryName = 0
    CXLookupNameKind_LookupTagName = 1
    CXLookupNameKind_LookupLabel = 2
    CXLookupNameKind_LookupMemberName = 3
    CXLookupNameKind_LookupOperatorName = 4
    CXLookupNameKind_LookupDestructorName = 5
    CXLookupNameKind_LookupNestedNameSpecifierName = 6
    CXLookupNameKind_LookupNamespaceName = 7
    CXLookupNameKind_LookupUsingDeclName = 8
    CXLookupNameKind_LookupRedeclarationWithLinkage = 9
    CXLookupNameKind_LookupLocalFriendName = 10
    CXLookupNameKind_LookupObjCProtocolName = 11
    CXLookupNameKind_LookupObjCImplicitSelfParam = 12
    CXLookupNameKind_LookupOMPReductionName = 13
    CXLookupNameKind_LookupOMPMapperName = 14
    CXLookupNameKind_LookupAnyName = 15
end

function clang_LookupResult_create(S, Name, NameLoc, LookupKind, ErrorCode)
    ccall((:clang_LookupResult_create, libclangex), CXLookupResult, (CXSema, CXDeclarationName, CXSourceLocation_, CXLookupNameKind, Ptr{CXInit_Error}), S, Name, NameLoc, LookupKind, ErrorCode)
end

function clang_LookupResult_dispose(LR)
    ccall((:clang_LookupResult_dispose, libclangex), Cvoid, (CXLookupResult,), LR)
end

function clang_LookupResult_clear(LR, LookupKind)
    ccall((:clang_LookupResult_clear, libclangex), Cvoid, (CXLookupResult, CXLookupNameKind), LR, LookupKind)
end

function clang_LookupResult_setLookupName(LR, DN)
    ccall((:clang_LookupResult_setLookupName, libclangex), Cvoid, (CXLookupResult, CXDeclarationName), LR, DN)
end

function clang_LookupResult_getLookupName(LR)
    ccall((:clang_LookupResult_getLookupName, libclangex), CXDeclarationName, (CXLookupResult,), LR)
end

function clang_LookupResult_dump(LR)
    ccall((:clang_LookupResult_dump, libclangex), Cvoid, (CXLookupResult,), LR)
end

function clang_LookupResult_empty(LR)
    ccall((:clang_LookupResult_empty, libclangex), Bool, (CXLookupResult,), LR)
end

function clang_LookupResult_getRepresentativeDecl(LR)
    ccall((:clang_LookupResult_getRepresentativeDecl, libclangex), CXNamedDecl, (CXLookupResult,), LR)
end

function clang_Sema_setCollectStats(S, ShouldCollect)
    ccall((:clang_Sema_setCollectStats, libclangex), Cvoid, (CXSema, Bool), S, ShouldCollect)
end

function clang_Sema_PrintStats(S)
    ccall((:clang_Sema_PrintStats, libclangex), Cvoid, (CXSema,), S)
end

function clang_Sema_RestoreNestedNameSpecifierAnnotation(S, Annotation, AnnotationRange_begin, AnnotationRange_end, SS)
    ccall((:clang_Sema_RestoreNestedNameSpecifierAnnotation, libclangex), Cvoid, (CXSema, Ptr{Cvoid}, CXSourceLocation_, CXSourceLocation_, CXCXXScopeSpec), S, Annotation, AnnotationRange_begin, AnnotationRange_end, SS)
end

function clang_Sema_LookupParsedName(S, R, Sp, SS, AllowBuiltinCreation, EnteringContext)
    ccall((:clang_Sema_LookupParsedName, libclangex), Bool, (CXSema, CXLookupResult, CXScope, CXCXXScopeSpec, Bool, Bool), S, R, Sp, SS, AllowBuiltinCreation, EnteringContext)
end

function clang_Sema_LookupName(S, R, Sp, AllowBuiltinCreation)
    ccall((:clang_Sema_LookupName, libclangex), Bool, (CXSema, CXLookupResult, CXScope, Bool), S, R, Sp, AllowBuiltinCreation)
end

function clang_Sema_processWeakTopLevelDecls(Sema, CodeGen)
    ccall((:clang_Sema_processWeakTopLevelDecls, libclangex), Cvoid, (CXSema, CXCodeGenerator), Sema, CodeGen)
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

function clang_Driver_GetResourcesPathLength(BinaryPath)
    ccall((:clang_Driver_GetResourcesPathLength, libclangex), Csize_t, (Ptr{Cchar},), BinaryPath)
end

function clang_Driver_GetResourcesPath(BinaryPath, ResourcesPath, N)
    ccall((:clang_Driver_GetResourcesPath, libclangex), Cvoid, (Ptr{Cchar}, Ptr{Cchar}, Csize_t), BinaryPath, ResourcesPath, N)
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

function clang_HeaderSearch_PrintStats(HS)
    ccall((:clang_HeaderSearch_PrintStats, libclangex), Cvoid, (CXHeaderSearch,), HS)
end

function clang_NestedNameSpecifier_getPrefix(NNS)
    ccall((:clang_NestedNameSpecifier_getPrefix, libclangex), CXNestedNameSpecifier, (CXNestedNameSpecifier,), NNS)
end

function clang_NestedNameSpecifier_containsErrors(NNS)
    ccall((:clang_NestedNameSpecifier_containsErrors, libclangex), Bool, (CXNestedNameSpecifier,), NNS)
end

function clang_NestedNameSpecifier_dump(NNS)
    ccall((:clang_NestedNameSpecifier_dump, libclangex), Cvoid, (CXNestedNameSpecifier,), NNS)
end

function clang_Decl_getLocation(DC)
    ccall((:clang_Decl_getLocation, libclangex), CXSourceLocation_, (CXDecl,), DC)
end

function clang_Decl_getBeginLoc(DC)
    ccall((:clang_Decl_getBeginLoc, libclangex), CXSourceLocation_, (CXDecl,), DC)
end

function clang_Decl_getEndLoc(DC)
    ccall((:clang_Decl_getEndLoc, libclangex), CXSourceLocation_, (CXDecl,), DC)
end

function clang_Decl_getDeclKindName(DC)
    ccall((:clang_Decl_getDeclKindName, libclangex), Ptr{Cchar}, (CXDecl,), DC)
end

function clang_Decl_getNextDeclInContext(DC)
    ccall((:clang_Decl_getNextDeclInContext, libclangex), CXDecl, (CXDecl,), DC)
end

function clang_Decl_getDeclContext(DC)
    ccall((:clang_Decl_getDeclContext, libclangex), CXDeclContext, (CXDecl,), DC)
end

function clang_Decl_getNonClosureContext(DC)
    ccall((:clang_Decl_getNonClosureContext, libclangex), CXDecl, (CXDecl,), DC)
end

function clang_Decl_getTranslationUnitDecl(DC)
    ccall((:clang_Decl_getTranslationUnitDecl, libclangex), CXTranslationUnitDecl, (CXDecl,), DC)
end

function clang_Decl_isInAnonymousNamespace(DC)
    ccall((:clang_Decl_isInAnonymousNamespace, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_isInStdNamespace(DC)
    ccall((:clang_Decl_isInStdNamespace, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getASTContext(DC)
    ccall((:clang_Decl_getASTContext, libclangex), CXASTContext, (CXDecl,), DC)
end

function clang_Decl_getLangOpts(DC)
    ccall((:clang_Decl_getLangOpts, libclangex), CXLangOptions, (CXDecl,), DC)
end

function clang_Decl_getLexicalDeclContext(DC)
    ccall((:clang_Decl_getLexicalDeclContext, libclangex), CXDeclContext, (CXDecl,), DC)
end

function clang_Decl_isOutOfLine(DC)
    ccall((:clang_Decl_isOutOfLine, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_setDeclContext(DC, Ctx)
    ccall((:clang_Decl_setDeclContext, libclangex), Cvoid, (CXDecl, CXDeclContext), DC, Ctx)
end

function clang_Decl_setLexicalDeclContext(DC, Ctx)
    ccall((:clang_Decl_setLexicalDeclContext, libclangex), Cvoid, (CXDecl, CXDeclContext), DC, Ctx)
end

function clang_Decl_isTemplated(DC)
    ccall((:clang_Decl_isTemplated, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getTemplateDepth(DC)
    ccall((:clang_Decl_getTemplateDepth, libclangex), Cuint, (CXDecl,), DC)
end

function clang_Decl_isDefinedOutsideFunctionOrMethod(DC)
    ccall((:clang_Decl_isDefinedOutsideFunctionOrMethod, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_isInLocalScopeForInstantiation(DC)
    ccall((:clang_Decl_isInLocalScopeForInstantiation, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getParentFunctionOrMethod(DC)
    ccall((:clang_Decl_getParentFunctionOrMethod, libclangex), CXDeclContext, (CXDecl,), DC)
end

function clang_Decl_getCanonicalDecl(DC)
    ccall((:clang_Decl_getCanonicalDecl, libclangex), CXDecl, (CXDecl,), DC)
end

function clang_Decl_isCanonicalDecl(DC)
    ccall((:clang_Decl_isCanonicalDecl, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getPreviousDecl(DC)
    ccall((:clang_Decl_getPreviousDecl, libclangex), CXDecl, (CXDecl,), DC)
end

function clang_Decl_isFirstDecl(DC)
    ccall((:clang_Decl_isFirstDecl, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getMostRecentDecl(DC)
    ccall((:clang_Decl_getMostRecentDecl, libclangex), CXDecl, (CXDecl,), DC)
end

function clang_Decl_isTemplateParameter(DC)
    ccall((:clang_Decl_isTemplateParameter, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_isTemplateParameterPack(DC)
    ccall((:clang_Decl_isTemplateParameterPack, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_isParameterPack(DC)
    ccall((:clang_Decl_isParameterPack, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_isTemplateDecl(DC)
    ccall((:clang_Decl_isTemplateDecl, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getDescribedTemplate(DC)
    ccall((:clang_Decl_getDescribedTemplate, libclangex), CXTemplateDecl, (CXDecl,), DC)
end

function clang_Decl_getDescribedTemplateParams(DC)
    ccall((:clang_Decl_getDescribedTemplateParams, libclangex), CXTemplateParameterList, (CXDecl,), DC)
end

function clang_Decl_getAsFunction(DC)
    ccall((:clang_Decl_getAsFunction, libclangex), CXFunctionDecl, (CXDecl,), DC)
end

function clang_Decl_dump(DC)
    ccall((:clang_Decl_dump, libclangex), Cvoid, (CXDecl,), DC)
end

function clang_Decl_dumpColor(DC)
    ccall((:clang_Decl_dumpColor, libclangex), Cvoid, (CXDecl,), DC)
end

function clang_Decl_getID(DC)
    ccall((:clang_Decl_getID, libclangex), Int64, (CXDecl,), DC)
end

function clang_Decl_getFunctionType(DC, BlocksToo)
    ccall((:clang_Decl_getFunctionType, libclangex), CXFunctionType, (CXDecl, Bool), DC, BlocksToo)
end

function clang_Decl_EnableStatistics()
    ccall((:clang_Decl_EnableStatistics, libclangex), Cvoid, ())
end

function clang_Decl_PrintStats()
    ccall((:clang_Decl_PrintStats, libclangex), Cvoid, ())
end

function clang_Decl_castToClassTemplateDecl(DC)
    ccall((:clang_Decl_castToClassTemplateDecl, libclangex), CXClassTemplateDecl, (CXDecl,), DC)
end

function clang_Decl_castToValueDecl(DC)
    ccall((:clang_Decl_castToValueDecl, libclangex), CXValueDecl, (CXDecl,), DC)
end

function clang_DeclContext_castToTagDecl(DC)
    ccall((:clang_DeclContext_castToTagDecl, libclangex), CXTagDecl, (CXDeclContext,), DC)
end

function clang_DeclContext_castToRecordDecl(DC)
    ccall((:clang_DeclContext_castToRecordDecl, libclangex), CXRecordDecl, (CXDeclContext,), DC)
end

function clang_DeclContext_castToCXXRecordDecl(DC)
    ccall((:clang_DeclContext_castToCXXRecordDecl, libclangex), CXCXXRecordDecl, (CXDeclContext,), DC)
end

function clang_DeclContext_getDeclKindName(DC)
    ccall((:clang_DeclContext_getDeclKindName, libclangex), Ptr{Cchar}, (CXDeclContext,), DC)
end

function clang_DeclContext_getParent(DC)
    ccall((:clang_DeclContext_getParent, libclangex), CXDeclContext, (CXDeclContext,), DC)
end

function clang_DeclContext_getLexicalParent(DC)
    ccall((:clang_DeclContext_getLexicalParent, libclangex), CXDeclContext, (CXDeclContext,), DC)
end

function clang_DeclContext_getLookupParent(DC)
    ccall((:clang_DeclContext_getLookupParent, libclangex), CXDeclContext, (CXDeclContext,), DC)
end

function clang_DeclContext_getParentASTContext(DC)
    ccall((:clang_DeclContext_getParentASTContext, libclangex), CXASTContext, (CXDeclContext,), DC)
end

function clang_DeclContext_isClosure(DC)
    ccall((:clang_DeclContext_isClosure, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isFunctionOrMethod(DC)
    ccall((:clang_DeclContext_isFunctionOrMethod, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isLookupContext(DC)
    ccall((:clang_DeclContext_isLookupContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isFileContext(DC)
    ccall((:clang_DeclContext_isFileContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isTranslationUnit(DC)
    ccall((:clang_DeclContext_isTranslationUnit, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isRecord(DC)
    ccall((:clang_DeclContext_isRecord, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isNamespace(DC)
    ccall((:clang_DeclContext_isNamespace, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isStdNamespace(DC)
    ccall((:clang_DeclContext_isStdNamespace, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isInlineNamespace(DC)
    ccall((:clang_DeclContext_isInlineNamespace, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isDependentContext(DC)
    ccall((:clang_DeclContext_isDependentContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isTransparentContext(DC)
    ccall((:clang_DeclContext_isTransparentContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isExternCContext(DC)
    ccall((:clang_DeclContext_isExternCContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_isExternCXXContext(DC)
    ccall((:clang_DeclContext_isExternCXXContext, libclangex), Bool, (CXDeclContext,), DC)
end

function clang_DeclContext_Equals(DC, DC2)
    ccall((:clang_DeclContext_Equals, libclangex), Bool, (CXDeclContext, CXDeclContext), DC, DC2)
end

function clang_DeclContext_getPrimaryContext(DC)
    ccall((:clang_DeclContext_getPrimaryContext, libclangex), CXDeclContext, (CXDeclContext,), DC)
end

function clang_DeclContext_addDecl(DC, D)
    ccall((:clang_DeclContext_addDecl, libclangex), Cvoid, (CXDeclContext, CXDecl), DC, D)
end

function clang_DeclContext_addDeclInternal(DC, D)
    ccall((:clang_DeclContext_addDeclInternal, libclangex), Cvoid, (CXDeclContext, CXDecl), DC, D)
end

function clang_DeclContext_addHiddenDecl(DC, D)
    ccall((:clang_DeclContext_addHiddenDecl, libclangex), Cvoid, (CXDeclContext, CXDecl), DC, D)
end

function clang_DeclContext_removeDecl(DC, D)
    ccall((:clang_DeclContext_removeDecl, libclangex), Cvoid, (CXDeclContext, CXDecl), DC, D)
end

function clang_DeclContext_containsDecl(DC, D)
    ccall((:clang_DeclContext_containsDecl, libclangex), Cvoid, (CXDeclContext, CXDecl), DC, D)
end

function clang_DeclContext_dumpDeclContext(DC)
    ccall((:clang_DeclContext_dumpDeclContext, libclangex), Cvoid, (CXDeclContext,), DC)
end

function clang_DeclContext_dumpLookups(DC)
    ccall((:clang_DeclContext_dumpLookups, libclangex), Cvoid, (CXDeclContext,), DC)
end

function clang_CodeGen_convertTypeForMemory(CGM, T)
    ccall((:clang_CodeGen_convertTypeForMemory, libclangex), LLVMTypeRef, (CXCodeGenModule, CXQualType), CGM, T)
end

function clang_ParseAST(Sema, PrintStats, SkipFunctionBodies)
    ccall((:clang_ParseAST, libclangex), Cvoid, (CXSema, Bool, Bool), Sema, PrintStats, SkipFunctionBodies)
end

function clang_Parser_tryParseAndSkipInvalidOrParsedDecl(Parser, CodeGen)
    ccall((:clang_Parser_tryParseAndSkipInvalidOrParsedDecl, libclangex), Bool, (CXParser, CXCodeGenerator), Parser, CodeGen)
end

@enum CXDeclSpecContext::UInt32 begin
    CXDeclSpecContext_DSC_normal = 0
    CXDeclSpecContext_DSC_class = 1
    CXDeclSpecContext_DSC_type_specifier = 2
    CXDeclSpecContext_DSC_trailing = 3
    CXDeclSpecContext_DSC_alias_declaration = 4
    CXDeclSpecContext_DSC_top_level = 5
    CXDeclSpecContext_DSC_template_param = 6
    CXDeclSpecContext_DSC_template_type_arg = 7
    CXDeclSpecContext_DSC_objc_method_result = 8
    CXDeclSpecContext_DSC_condition = 9
end

function clang_Parser_create(PP, Actions, SkipFunctionBodies, ErrorCode)
    ccall((:clang_Parser_create, libclangex), CXParser, (CXPreprocessor, CXSema, Bool, Ptr{CXInit_Error}), PP, Actions, SkipFunctionBodies, ErrorCode)
end

function clang_Parser_dispose(P)
    ccall((:clang_Parser_dispose, libclangex), Cvoid, (CXParser,), P)
end

function clang_Parser_Initialize(P)
    ccall((:clang_Parser_Initialize, libclangex), Cvoid, (CXParser,), P)
end

function clang_Parser_getLangOpts(P)
    ccall((:clang_Parser_getLangOpts, libclangex), CXLangOptions, (CXParser,), P)
end

function clang_Parser_getTargetInfo(P)
    ccall((:clang_Parser_getTargetInfo, libclangex), CXTargetInfo_, (CXParser,), P)
end

function clang_Parser_getPreprocessor(P)
    ccall((:clang_Parser_getPreprocessor, libclangex), CXPreprocessor, (CXParser,), P)
end

function clang_Parser_getActions(P)
    ccall((:clang_Parser_getActions, libclangex), CXSema, (CXParser,), P)
end

function clang_Parser_getCurToken(P)
    ccall((:clang_Parser_getCurToken, libclangex), CXToken_, (CXParser,), P)
end

function clang_Parser_NextToken(P)
    ccall((:clang_Parser_NextToken, libclangex), CXToken_, (CXParser,), P)
end

function clang_Parser_getCurScope(P)
    ccall((:clang_Parser_getCurScope, libclangex), CXScope, (CXParser,), P)
end

function clang_Parser_ConsumeToken(P)
    ccall((:clang_Parser_ConsumeToken, libclangex), CXSourceLocation_, (CXParser,), P)
end

function clang_Parser_ConsumeAnyToken(P)
    ccall((:clang_Parser_ConsumeAnyToken, libclangex), CXSourceLocation_, (CXParser,), P)
end

function clang_Parser_TryAnnotateCXXScopeToken(P, EnteringContext)
    ccall((:clang_Parser_TryAnnotateCXXScopeToken, libclangex), Bool, (CXParser, Bool), P, EnteringContext)
end

function clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(P, SS, IsNewScope)
    ccall((:clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec, libclangex), Bool, (CXParser, CXCXXScopeSpec, Bool), P, SS, IsNewScope)
end

function clang_Parser_parseOneTopLevelDecl(Parser, IsFirstDecl)
    ccall((:clang_Parser_parseOneTopLevelDecl, libclangex), CXDeclGroupRef, (CXParser, Bool), Parser, IsFirstDecl)
end

@enum CXTemplateArgument_ArgKind::UInt32 begin
    CXTemplateArgument_Null = 0
    CXTemplateArgument_Type = 1
    CXTemplateArgument_Declaration = 2
    CXTemplateArgument_NullPtr = 3
    CXTemplateArgument_Integral = 4
    CXTemplateArgument_Template = 5
    CXTemplateArgument_TemplateExpansion = 6
    CXTemplateArgument_Expression = 7
    CXTemplateArgument_Pack = 8
end

function clang_TemplateArgument_constructFromQualType(OpaquePtr, isNullPtr)
    ccall((:clang_TemplateArgument_constructFromQualType, libclangex), CXTemplateArgument, (CXQualType, Bool), OpaquePtr, isNullPtr)
end

function clang_TemplateArgument_constructFromValueDecl(VD, OpaquePtr)
    ccall((:clang_TemplateArgument_constructFromValueDecl, libclangex), CXTemplateArgument, (CXValueDecl, CXQualType), VD, OpaquePtr)
end

function clang_TemplateArgument_constructFromIntegral(Ctx, Val, OpaquePtr)
    ccall((:clang_TemplateArgument_constructFromIntegral, libclangex), CXTemplateArgument, (CXASTContext, LLVMGenericValueRef, CXQualType), Ctx, Val, OpaquePtr)
end

function clang_TemplateArgument_dispose(TA)
    ccall((:clang_TemplateArgument_dispose, libclangex), Cvoid, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getKind(TA)
    ccall((:clang_TemplateArgument_getKind, libclangex), CXTemplateArgument_ArgKind, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_isNull(TA)
    ccall((:clang_TemplateArgument_isNull, libclangex), Bool, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_isDependent(TA)
    ccall((:clang_TemplateArgument_isDependent, libclangex), Bool, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_isInstantiationDependent(TA)
    ccall((:clang_TemplateArgument_isInstantiationDependent, libclangex), Bool, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getAsType(TA)
    ccall((:clang_TemplateArgument_getAsType, libclangex), CXQualType, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getAsDecl(TA)
    ccall((:clang_TemplateArgument_getAsDecl, libclangex), CXValueDecl, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getParamTypeForDecl(TA)
    ccall((:clang_TemplateArgument_getParamTypeForDecl, libclangex), CXQualType, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getNullPtrType(TA)
    ccall((:clang_TemplateArgument_getNullPtrType, libclangex), CXQualType, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getAsTemplate(TA)
    ccall((:clang_TemplateArgument_getAsTemplate, libclangex), CXTemplateName, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getAsTemplateOrTemplatePattern(TA)
    ccall((:clang_TemplateArgument_getAsTemplateOrTemplatePattern, libclangex), CXTemplateName, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getNumTemplateExpansions(TA)
    ccall((:clang_TemplateArgument_getNumTemplateExpansions, libclangex), Cuint, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getAsIntegral(TA)
    ccall((:clang_TemplateArgument_getAsIntegral, libclangex), LLVMGenericValueRef, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_getIntegralType(TA)
    ccall((:clang_TemplateArgument_getIntegralType, libclangex), CXQualType, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_setIntegralType(TA, OpaquePtr)
    ccall((:clang_TemplateArgument_setIntegralType, libclangex), Cvoid, (CXTemplateArgument, CXQualType), TA, OpaquePtr)
end

function clang_TemplateArgument_getNonTypeTemplateArgumentType(TA)
    ccall((:clang_TemplateArgument_getNonTypeTemplateArgumentType, libclangex), CXQualType, (CXTemplateArgument,), TA)
end

function clang_TemplateArgument_dump(TA)
    ccall((:clang_TemplateArgument_dump, libclangex), Cvoid, (CXTemplateArgument,), TA)
end

@enum CXTemplateName_NameKind::UInt32 begin
    CXTemplateName_Template = 0
    CXTemplateName_OverloadedTemplate = 1
    CXTemplateName_AssumedTemplate = 2
    CXTemplateName_QualifiedTemplate = 3
    CXTemplateName_DependentTemplate = 4
    CXTemplateName_SubstTemplateTemplateParm = 5
    CXTemplateName_SubstTemplateTemplateParmPack = 6
end

function clang_TemplateName_isNull(TN)
    ccall((:clang_TemplateName_isNull, libclangex), Bool, (CXTemplateName,), TN)
end

function clang_TemplateName_getKind(TN)
    ccall((:clang_TemplateName_getKind, libclangex), CXTemplateName_NameKind, (CXTemplateName,), TN)
end

function clang_TemplateName_getAsTemplateDecl(TN)
    ccall((:clang_TemplateName_getAsTemplateDecl, libclangex), CXTemplateDecl, (CXTemplateName,), TN)
end

function clang_TemplateName_getUnderlying(TN)
    ccall((:clang_TemplateName_getUnderlying, libclangex), CXTemplateName, (CXTemplateName,), TN)
end

function clang_TemplateName_getNameToSubstitute(TN)
    ccall((:clang_TemplateName_getNameToSubstitute, libclangex), CXTemplateName, (CXTemplateName,), TN)
end

function clang_TemplateName_isDependent(TN)
    ccall((:clang_TemplateName_isDependent, libclangex), Bool, (CXTemplateName,), TN)
end

function clang_TemplateName_isInstantiationDependent(TN)
    ccall((:clang_TemplateName_isInstantiationDependent, libclangex), Bool, (CXTemplateName,), TN)
end

function clang_TemplateName_containsUnexpandedParameterPack(TN)
    ccall((:clang_TemplateName_containsUnexpandedParameterPack, libclangex), Bool, (CXTemplateName,), TN)
end

function clang_TemplateName_dump(TN)
    ccall((:clang_TemplateName_dump, libclangex), Cvoid, (CXTemplateName,), TN)
end

@enum CXCastKind::UInt32 begin
    CK_Dependent = 0
    CK_BitCast = 1
    CK_LValueBitCast = 2
    CK_LValueToRValueBitCast = 3
    CK_LValueToRValue = 4
    CK_NoOp = 5
    CK_BaseToDerived = 6
    CK_DerivedToBase = 7
    CK_UncheckedDerivedToBase = 8
    CK_Dynamic = 9
    CK_ToUnion = 10
    CK_ArrayToPointerDecay = 11
    CK_FunctionToPointerDecay = 12
    CK_NullToPointer = 13
    CK_NullToMemberPointer = 14
    CK_BaseToDerivedMemberPointer = 15
    CK_DerivedToBaseMemberPointer = 16
    CK_MemberPointerToBoolean = 17
    CK_ReinterpretMemberPointer = 18
    CK_UserDefinedConversion = 19
    CK_ConstructorConversion = 20
    CK_IntegralToPointer = 21
    CK_PointerToIntegral = 22
    CK_PointerToBoolean = 23
    CK_ToVoid = 24
    CK_VectorSplat = 25
    CK_IntegralCast = 26
    CK_IntegralToBoolean = 27
    CK_IntegralToFloating = 28
    CK_FloatingToFixedPoint = 29
    CK_FixedPointToFloating = 30
    CK_FixedPointCast = 31
    CK_FixedPointToIntegral = 32
    CK_IntegralToFixedPoint = 33
    CK_FixedPointToBoolean = 34
    CK_FloatingToIntegral = 35
    CK_FloatingToBoolean = 36
    CK_BooleanToSignedIntegral = 37
    CK_FloatingCast = 38
    CK_CPointerToObjCPointerCast = 39
    CK_BlockPointerToObjCPointerCast = 40
    CK_AnyPointerToBlockPointerCast = 41
    CK_ObjCObjectLValueCast = 42
    CK_FloatingRealToComplex = 43
    CK_FloatingComplexToReal = 44
    CK_FloatingComplexToBoolean = 45
    CK_FloatingComplexCast = 46
    CK_FloatingComplexToIntegralComplex = 47
    CK_IntegralRealToComplex = 48
    CK_IntegralComplexToReal = 49
    CK_IntegralComplexToBoolean = 50
    CK_IntegralComplexCast = 51
    CK_IntegralComplexToFloatingComplex = 52
    CK_ARCProduceObject = 53
    CK_ARCConsumeObject = 54
    CK_ARCReclaimReturnedObject = 55
    CK_ARCExtendBlockObject = 56
    CK_AtomicToNonAtomic = 57
    CK_NonAtomicToAtomic = 58
    CK_CopyAndAutoreleaseBlockObject = 59
    CK_BuiltinFnToFnPtr = 60
    CK_ZeroToOCLOpaqueType = 61
    CK_AddressSpaceConversion = 62
    CK_IntToOCLSampler = 63
end

@enum CXExplicitSpecKind::UInt32 begin
    CXExplicitSpecKind_ResolvedFalse = 0x0000000000000000
    CXExplicitSpecKind_ResolvedTrue = 0x0000000000000001
    CXExplicitSpecKind_Unresolved = 0x0000000000000002
end

@enum CXAccessSpecifier::UInt32 begin
    CXAccessSpecifier_AS_public = 0
    CXAccessSpecifier_AS_protected = 1
    CXAccessSpecifier_AS_private = 2
    CXAccessSpecifier_AS_none = 3
end

@enum CXExprValueKind::UInt32 begin
    CXExprValueKind_VK_RValue = 0
    CXExprValueKind_VK_LValue = 1
    CXExprValueKind_VK_XValue = 2
end

@enum CXConstexprSpecKind::UInt32 begin
    CXConstexprSpecKind_Unspecified = 0
    CXConstexprSpecKind_Constexpr = 1
    CXConstexprSpecKind_Consteval = 2
    CXConstexprSpecKind_Constinit = 3
end

@enum CXTemplateSpecializationKind::UInt32 begin
    CXTemplateSpecializationKind_TSK_Undeclared = 0
    CXTemplateSpecializationKind_TSK_ImplicitInstantiation = 1
    CXTemplateSpecializationKind_TSK_ExplicitSpecialization = 2
    CXTemplateSpecializationKind_TSK_ExplicitInstantiationDeclaration = 3
    CXTemplateSpecializationKind_TSK_ExplicitInstantiationDefinition = 4
end

@enum CXThreadStorageClassSpecifier::UInt32 begin
    CXThreadStorageClassSpecifier_TSCS_unspecified = 0
    CXThreadStorageClassSpecifier_TSCS___thread = 1
    CXThreadStorageClassSpecifier_TSCS_thread_local = 2
    CXThreadStorageClassSpecifier_TSCS__Thread_local = 3
end

@enum CXStorageClass::UInt32 begin
    CXStorageClass_SC_None = 0
    CXStorageClass_SC_Extern = 1
    CXStorageClass_SC_Static = 2
    CXStorageClass_SC_PrivateExtern = 3
    CXStorageClass_SC_Auto = 4
    CXStorageClass_SC_Register = 5
end

@enum CXInClassInitStyle::UInt32 begin
    CXInClassInitStyle_ICIS_NoInit = 0
    CXInClassInitStyle_ICIS_CopyInit = 1
    CXInClassInitStyle_ICIS_ListInit = 2
end

@enum CXStorageDuration::UInt32 begin
    CXStorageDuration_SD_FullExpression = 0
    CXStorageDuration_SD_Automatic = 1
    CXStorageDuration_SD_Thread = 2
    CXStorageDuration_SD_Static = 3
    CXStorageDuration_SD_Dynamic = 4
end

function clang_IntegerLiteral_Create(C, Val, T, L)
    ccall((:clang_IntegerLiteral_Create, libclangex), CXIntegerLiteral, (CXASTContext, LLVMGenericValueRef, CXQualType, CXSourceLocation_), C, Val, T, L)
end

function clang_IntegerLiteral_getBeginLoc(IL)
    ccall((:clang_IntegerLiteral_getBeginLoc, libclangex), CXSourceLocation_, (CXIntegerLiteral,), IL)
end

function clang_IntegerLiteral_getEndLoc(IL)
    ccall((:clang_IntegerLiteral_getEndLoc, libclangex), CXSourceLocation_, (CXIntegerLiteral,), IL)
end

function clang_IntegerLiteral_getLocation(IL)
    ccall((:clang_IntegerLiteral_getLocation, libclangex), CXSourceLocation_, (CXIntegerLiteral,), IL)
end

function clang_IntegerLiteral_setLocation(IL, L)
    ccall((:clang_IntegerLiteral_setLocation, libclangex), Cvoid, (CXIntegerLiteral, CXSourceLocation_), IL, L)
end

function clang_CStyleCastExpr_CreateWithNoTypeInfo(C, T, VK, K, Op)
    ccall((:clang_CStyleCastExpr_CreateWithNoTypeInfo, libclangex), CXCStyleCastExpr, (CXASTContext, CXQualType, CXExprValueKind, CXCastKind, CXExpr), C, T, VK, K, Op)
end

function clang_CStyleCastExpr_CreateEmpty(C, PathSize, HasFPFeatures)
    ccall((:clang_CStyleCastExpr_CreateEmpty, libclangex), CXCStyleCastExpr, (CXASTContext, Cuint, Bool), C, PathSize, HasFPFeatures)
end

function clang_CStyleCastExpr_getLParenLoc(CSCE)
    ccall((:clang_CStyleCastExpr_getLParenLoc, libclangex), CXSourceLocation_, (CXCStyleCastExpr,), CSCE)
end

function clang_CStyleCastExpr_setLParenLoc(CSCE, L)
    ccall((:clang_CStyleCastExpr_setLParenLoc, libclangex), Cvoid, (CXCStyleCastExpr, CXSourceLocation_), CSCE, L)
end

function clang_CStyleCastExpr_getRParenLoc(CSCE)
    ccall((:clang_CStyleCastExpr_getRParenLoc, libclangex), CXSourceLocation_, (CXCStyleCastExpr,), CSCE)
end

function clang_CStyleCastExpr_setRParenLoc(CSCE, L)
    ccall((:clang_CStyleCastExpr_setRParenLoc, libclangex), Cvoid, (CXCStyleCastExpr, CXSourceLocation_), CSCE, L)
end

function clang_CStyleCastExpr_getBeginLoc(CSCE)
    ccall((:clang_CStyleCastExpr_getBeginLoc, libclangex), CXSourceLocation_, (CXCStyleCastExpr,), CSCE)
end

function clang_CStyleCastExpr_getEndLoc(CSCE)
    ccall((:clang_CStyleCastExpr_getEndLoc, libclangex), CXSourceLocation_, (CXCStyleCastExpr,), CSCE)
end

function clang_QualType_constructFromTypePtr(Ptr, Quals)
    ccall((:clang_QualType_constructFromTypePtr, libclangex), CXQualType, (CXType_, Cuint), Ptr, Quals)
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

function clang_QualType_hasQualifiers(OpaquePtr)
    ccall((:clang_QualType_hasQualifiers, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_withConst(OpaquePtr)
    ccall((:clang_QualType_withConst, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_withVolatile(OpaquePtr)
    ccall((:clang_QualType_withVolatile, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_withRestrict(OpaquePtr)
    ccall((:clang_QualType_withRestrict, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_addConst(OpaquePtr)
    ccall((:clang_QualType_addConst, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_addVolatile(OpaquePtr)
    ccall((:clang_QualType_addVolatile, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_addRestrict(OpaquePtr)
    ccall((:clang_QualType_addRestrict, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_isLocalConstQualified(OpaquePtr)
    ccall((:clang_QualType_isLocalConstQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isLocalRestrictQualified(OpaquePtr)
    ccall((:clang_QualType_isLocalRestrictQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_isLocalVolatileQualified(OpaquePtr)
    ccall((:clang_QualType_isLocalVolatileQualified, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_hasLocalQualifiers(OpaquePtr)
    ccall((:clang_QualType_hasLocalQualifiers, libclangex), Bool, (CXQualType,), OpaquePtr)
end

function clang_QualType_getCVRQualifiers(OpaquePtr)
    ccall((:clang_QualType_getCVRQualifiers, libclangex), Cuint, (CXQualType,), OpaquePtr)
end

function clang_QualType_getAsString(OpaquePtr)
    ccall((:clang_QualType_getAsString, libclangex), CXString, (CXQualType,), OpaquePtr)
end

function clang_QualType_dump(OpaquePtr)
    ccall((:clang_QualType_dump, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_getCanonicalType(OpaquePtr)
    ccall((:clang_QualType_getCanonicalType, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_getLocalUnqualifiedType(OpaquePtr)
    ccall((:clang_QualType_getLocalUnqualifiedType, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_QualType_getUnqualifiedType(OpaquePtr)
    ccall((:clang_QualType_getUnqualifiedType, libclangex), CXQualType, (CXQualType,), OpaquePtr)
end

function clang_Type_isFromAST(T)
    ccall((:clang_Type_isFromAST, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isCanonicalUnqualified(T)
    ccall((:clang_Type_isCanonicalUnqualified, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSizelessType(T)
    ccall((:clang_Type_isSizelessType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSizelessBuiltinType(T)
    ccall((:clang_Type_isSizelessBuiltinType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isBuiltinType(T)
    ccall((:clang_Type_isBuiltinType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isIntegerType(T)
    ccall((:clang_Type_isIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isEnumeralType(T)
    ccall((:clang_Type_isEnumeralType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isScopedEnumeralType(T)
    ccall((:clang_Type_isScopedEnumeralType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isBooleanType(T)
    ccall((:clang_Type_isBooleanType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isCharType(T)
    ccall((:clang_Type_isCharType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isWideCharType(T)
    ccall((:clang_Type_isWideCharType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isChar8Type(T)
    ccall((:clang_Type_isChar8Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isChar16Type(T)
    ccall((:clang_Type_isChar16Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isChar32Type(T)
    ccall((:clang_Type_isChar32Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAnyCharacterType(T)
    ccall((:clang_Type_isAnyCharacterType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isIntegralOrEnumerationType(T)
    ccall((:clang_Type_isIntegralOrEnumerationType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isIntegralOrUnscopedEnumerationType(T)
    ccall((:clang_Type_isIntegralOrUnscopedEnumerationType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnscopedEnumerationType(T)
    ccall((:clang_Type_isUnscopedEnumerationType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isRealFloatingType(T)
    ccall((:clang_Type_isRealFloatingType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isComplexType(T)
    ccall((:clang_Type_isComplexType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAnyComplexType(T)
    ccall((:clang_Type_isAnyComplexType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFloatingType(T)
    ccall((:clang_Type_isFloatingType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isHalfType(T)
    ccall((:clang_Type_isHalfType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFloat16Type(T)
    ccall((:clang_Type_isFloat16Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isBFloat16Type(T)
    ccall((:clang_Type_isBFloat16Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFloat128Type(T)
    ccall((:clang_Type_isFloat128Type, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isRealType(T)
    ccall((:clang_Type_isRealType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isArithmeticType(T)
    ccall((:clang_Type_isArithmeticType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVoidType(T)
    ccall((:clang_Type_isVoidType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isScalarType(T)
    ccall((:clang_Type_isScalarType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAggregateType(T)
    ccall((:clang_Type_isAggregateType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFundamentalType(T)
    ccall((:clang_Type_isFundamentalType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isCompoundType(T)
    ccall((:clang_Type_isCompoundType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFunctionType(T)
    ccall((:clang_Type_isFunctionType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFunctionNoProtoType(T)
    ccall((:clang_Type_isFunctionNoProtoType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFunctionProtoType(T)
    ccall((:clang_Type_isFunctionProtoType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isPointerType(T)
    ccall((:clang_Type_isPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAnyPointerType(T)
    ccall((:clang_Type_isAnyPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isBlockPointerType(T)
    ccall((:clang_Type_isBlockPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVoidPointerType(T)
    ccall((:clang_Type_isVoidPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isReferenceType(T)
    ccall((:clang_Type_isReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isLValueReferenceType(T)
    ccall((:clang_Type_isLValueReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isRValueReferenceType(T)
    ccall((:clang_Type_isRValueReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isObjectPointerType(T)
    ccall((:clang_Type_isObjectPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFunctionPointerType(T)
    ccall((:clang_Type_isFunctionPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFunctionReferenceType(T)
    ccall((:clang_Type_isFunctionReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isMemberPointerType(T)
    ccall((:clang_Type_isMemberPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isMemberFunctionPointerType(T)
    ccall((:clang_Type_isMemberFunctionPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isMemberDataPointerType(T)
    ccall((:clang_Type_isMemberDataPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isArrayType(T)
    ccall((:clang_Type_isArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isConstantArrayType(T)
    ccall((:clang_Type_isConstantArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isIncompleteArrayType(T)
    ccall((:clang_Type_isIncompleteArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVariableArrayType(T)
    ccall((:clang_Type_isVariableArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isDependentSizedArrayType(T)
    ccall((:clang_Type_isDependentSizedArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isRecordType(T)
    ccall((:clang_Type_isRecordType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isClassType(T)
    ccall((:clang_Type_isClassType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isStructureType(T)
    ccall((:clang_Type_isStructureType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isObjCBoxableRecordType(T)
    ccall((:clang_Type_isObjCBoxableRecordType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isInterfaceType(T)
    ccall((:clang_Type_isInterfaceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isStructureOrClassType(T)
    ccall((:clang_Type_isStructureOrClassType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnionType(T)
    ccall((:clang_Type_isUnionType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isComplexIntegerType(T)
    ccall((:clang_Type_isComplexIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVectorType(T)
    ccall((:clang_Type_isVectorType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isExtVectorType(T)
    ccall((:clang_Type_isExtVectorType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isMatrixType(T)
    ccall((:clang_Type_isMatrixType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isConstantMatrixType(T)
    ccall((:clang_Type_isConstantMatrixType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isDependentAddressSpaceType(T)
    ccall((:clang_Type_isDependentAddressSpaceType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isDecltypeType(T)
    ccall((:clang_Type_isDecltypeType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isTemplateTypeParmType(T)
    ccall((:clang_Type_isTemplateTypeParmType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isNullPtrType(T)
    ccall((:clang_Type_isNullPtrType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isNothrowT(T)
    ccall((:clang_Type_isNothrowT, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAlignValT(T)
    ccall((:clang_Type_isAlignValT, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isStdByteType(T)
    ccall((:clang_Type_isStdByteType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isAtomicType(T)
    ccall((:clang_Type_isAtomicType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUndeducedAutoType(T)
    ccall((:clang_Type_isUndeducedAutoType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isTypedefNameType(T)
    ccall((:clang_Type_isTypedefNameType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isDependentType(T)
    ccall((:clang_Type_isDependentType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isInstantiationDependentType(T)
    ccall((:clang_Type_isInstantiationDependentType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUndeducedType(T)
    ccall((:clang_Type_isUndeducedType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVariablyModifiedType(T)
    ccall((:clang_Type_isVariablyModifiedType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasSizedVLAType(T)
    ccall((:clang_Type_hasSizedVLAType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasUnnamedOrLocalType(T)
    ccall((:clang_Type_hasUnnamedOrLocalType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isOverloadableType(T)
    ccall((:clang_Type_isOverloadableType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isElaboratedTypeSpecifier(T)
    ccall((:clang_Type_isElaboratedTypeSpecifier, libclangex), Bool, (CXType_,), T)
end

function clang_Type_canDecayToPointerType(T)
    ccall((:clang_Type_canDecayToPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasPointerRepresentation(T)
    ccall((:clang_Type_hasPointerRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasObjCPointerRepresentation(T)
    ccall((:clang_Type_hasObjCPointerRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasIntegerRepresentation(T)
    ccall((:clang_Type_hasIntegerRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasSignedIntegerRepresentation(T)
    ccall((:clang_Type_hasSignedIntegerRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_IncrementalCompilerBuilder_create(Args, N)
    ccall((:clang_IncrementalCompilerBuilder_create, libclangex), CXCompilerInstance, (Ptr{Ptr{Cchar}}, Cint), Args, N)
end

function clang_Interpreter_create(CI)
    ccall((:clang_Interpreter_create, libclangex), CXInterpreter, (CXCompilerInstance,), CI)
end

function clang_Type_hasUnsignedIntegerRepresentation(T)
    ccall((:clang_Type_hasUnsignedIntegerRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_Type_hasFloatingRepresentation(T)
    ccall((:clang_Type_hasFloatingRepresentation, libclangex), Bool, (CXType_,), T)
end

function clang_Type_getAsStructureType(T)
    ccall((:clang_Type_getAsStructureType, libclangex), CXRecordType, (CXType_,), T)
end

function clang_Type_getAsUnionType(T)
    ccall((:clang_Type_getAsUnionType, libclangex), CXRecordType, (CXType_,), T)
end

function clang_Type_getAsComplexIntegerType(T)
    ccall((:clang_Type_getAsComplexIntegerType, libclangex), CXComplexType, (CXType_,), T)
end

function clang_Type_getAsCXXRecordDecl(T)
    ccall((:clang_Type_getAsCXXRecordDecl, libclangex), CXCXXRecordDecl, (CXType_,), T)
end

function clang_Type_getAsRecordDecl(T)
    ccall((:clang_Type_getAsRecordDecl, libclangex), CXRecordDecl, (CXType_,), T)
end

function clang_Type_getAsTagDecl(T)
    ccall((:clang_Type_getAsTagDecl, libclangex), CXTagDecl, (CXType_,), T)
end

function clang_Type_getPointeeCXXRecordDecl(T)
    ccall((:clang_Type_getPointeeCXXRecordDecl, libclangex), CXCXXRecordDecl, (CXType_,), T)
end

function clang_Type_getContainedDeducedType(T)
    ccall((:clang_Type_getContainedDeducedType, libclangex), CXDeducedType, (CXType_,), T)
end

function clang_Type_hasAutoForTrailingReturnType(T)
    ccall((:clang_Type_hasAutoForTrailingReturnType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_getArrayElementTypeNoTypeQual(T)
    ccall((:clang_Type_getArrayElementTypeNoTypeQual, libclangex), CXType_, (CXType_,), T)
end

function clang_Type_getPointeeOrArrayElementType(T)
    ccall((:clang_Type_getPointeeOrArrayElementType, libclangex), CXType_, (CXType_,), T)
end

function clang_Type_getPointeeType(T)
    ccall((:clang_Type_getPointeeType, libclangex), CXQualType, (CXType_,), T)
end

function clang_Type_getUnqualifiedDesugaredType(T)
    ccall((:clang_Type_getUnqualifiedDesugaredType, libclangex), CXType_, (CXType_,), T)
end

function clang_Type_isPromotableIntegerType(T)
    ccall((:clang_Type_isPromotableIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSignedIntegerType(T)
    ccall((:clang_Type_isSignedIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnsignedIntegerType(T)
    ccall((:clang_Type_isUnsignedIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSignedIntegerOrEnumerationType(T)
    ccall((:clang_Type_isSignedIntegerOrEnumerationType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnsignedIntegerOrEnumerationType(T)
    ccall((:clang_Type_isUnsignedIntegerOrEnumerationType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFixedPointType(T)
    ccall((:clang_Type_isFixedPointType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isFixedPointOrIntegerType(T)
    ccall((:clang_Type_isFixedPointOrIntegerType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSaturatedFixedPointType(T)
    ccall((:clang_Type_isSaturatedFixedPointType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnsaturatedFixedPointType(T)
    ccall((:clang_Type_isUnsaturatedFixedPointType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSignedFixedPointType(T)
    ccall((:clang_Type_isSignedFixedPointType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isUnsignedFixedPointType(T)
    ccall((:clang_Type_isUnsignedFixedPointType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isConstantSizeType(T)
    ccall((:clang_Type_isConstantSizeType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isSpecifierType(T)
    ccall((:clang_Type_isSpecifierType, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isVisibilityExplicit(T)
    ccall((:clang_Type_isVisibilityExplicit, libclangex), Bool, (CXType_,), T)
end

function clang_Type_isLinkageValid(T)
    ccall((:clang_Type_isLinkageValid, libclangex), Bool, (CXType_,), T)
end

function clang_Type_getCanonicalTypeInternal(T)
    ccall((:clang_Type_getCanonicalTypeInternal, libclangex), CXQualType, (CXType_,), T)
end

function clang_Type_dump(T)
    ccall((:clang_Type_dump, libclangex), Cvoid, (CXType_,), T)
end

function clang_isa_BuiltinType(T)
    ccall((:clang_isa_BuiltinType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_ComplexType(T)
    ccall((:clang_isa_ComplexType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_PointerType(T)
    ccall((:clang_isa_PointerType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_ReferenceType(T)
    ccall((:clang_isa_ReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_LValueReferenceType(T)
    ccall((:clang_isa_LValueReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_RValueReferenceType(T)
    ccall((:clang_isa_RValueReferenceType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_MemberPointerType(T)
    ccall((:clang_isa_MemberPointerType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_ArrayType(T)
    ccall((:clang_isa_ArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_ConstantArrayType(T)
    ccall((:clang_isa_ConstantArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_IncompleteArrayType(T)
    ccall((:clang_isa_IncompleteArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_VariableArrayType(T)
    ccall((:clang_isa_VariableArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DependentSizedArrayType(T)
    ccall((:clang_isa_DependentSizedArrayType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_FunctionType(T)
    ccall((:clang_isa_FunctionType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_FunctionNoProtoType(T)
    ccall((:clang_isa_FunctionNoProtoType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_FunctionProtoType(T)
    ccall((:clang_isa_FunctionProtoType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_UnresolvedUsingType(T)
    ccall((:clang_isa_UnresolvedUsingType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_TypedefType(T)
    ccall((:clang_isa_TypedefType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DecltypeType(T)
    ccall((:clang_isa_DecltypeType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DependentDecltypeType(T)
    ccall((:clang_isa_DependentDecltypeType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_TagType(T)
    ccall((:clang_isa_TagType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_RecordType(T)
    ccall((:clang_isa_RecordType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_EnumType(T)
    ccall((:clang_isa_EnumType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_TemplateTypeParmType(T)
    ccall((:clang_isa_TemplateTypeParmType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_SubstTemplateTypeParmType(T)
    ccall((:clang_isa_SubstTemplateTypeParmType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_SubstTemplateTypeParmPackType(T)
    ccall((:clang_isa_SubstTemplateTypeParmPackType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DeducedType(T)
    ccall((:clang_isa_DeducedType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_AutoType(T)
    ccall((:clang_isa_AutoType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DeducedTemplateSpecializationType(T)
    ccall((:clang_isa_DeducedTemplateSpecializationType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_TemplateSpecializationType(T)
    ccall((:clang_isa_TemplateSpecializationType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_ElaboratedType(T)
    ccall((:clang_isa_ElaboratedType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DependentNameType(T)
    ccall((:clang_isa_DependentNameType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_DependentTemplateSpecializationType(T)
    ccall((:clang_isa_DependentTemplateSpecializationType, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Void(T)
    ccall((:clang_isa_BuiltinType_Void, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Bool(T)
    ccall((:clang_isa_BuiltinType_Bool, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Char_U(T)
    ccall((:clang_isa_BuiltinType_Char_U, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_UChar(T)
    ccall((:clang_isa_BuiltinType_UChar, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_WChar_U(T)
    ccall((:clang_isa_BuiltinType_WChar_U, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Char8(T)
    ccall((:clang_isa_BuiltinType_Char8, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Char16(T)
    ccall((:clang_isa_BuiltinType_Char16, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Char32(T)
    ccall((:clang_isa_BuiltinType_Char32, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_UShort(T)
    ccall((:clang_isa_BuiltinType_UShort, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_UInt(T)
    ccall((:clang_isa_BuiltinType_UInt, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_ULong(T)
    ccall((:clang_isa_BuiltinType_ULong, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_ULongLong(T)
    ccall((:clang_isa_BuiltinType_ULongLong, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_UInt128(T)
    ccall((:clang_isa_BuiltinType_UInt128, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Char_S(T)
    ccall((:clang_isa_BuiltinType_Char_S, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_SChar(T)
    ccall((:clang_isa_BuiltinType_SChar, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_WChar_S(T)
    ccall((:clang_isa_BuiltinType_WChar_S, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Short(T)
    ccall((:clang_isa_BuiltinType_Short, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Int(T)
    ccall((:clang_isa_BuiltinType_Int, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Long(T)
    ccall((:clang_isa_BuiltinType_Long, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_LongLong(T)
    ccall((:clang_isa_BuiltinType_LongLong, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Int128(T)
    ccall((:clang_isa_BuiltinType_Int128, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Half(T)
    ccall((:clang_isa_BuiltinType_Half, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Float(T)
    ccall((:clang_isa_BuiltinType_Float, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Double(T)
    ccall((:clang_isa_BuiltinType_Double, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_LongDouble(T)
    ccall((:clang_isa_BuiltinType_LongDouble, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Float16(T)
    ccall((:clang_isa_BuiltinType_Float16, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_BFloat16(T)
    ccall((:clang_isa_BuiltinType_BFloat16, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_Float128(T)
    ccall((:clang_isa_BuiltinType_Float128, libclangex), Bool, (CXType_,), T)
end

function clang_isa_BuiltinType_NullPtr(T)
    ccall((:clang_isa_BuiltinType_NullPtr, libclangex), Bool, (CXType_,), T)
end

function clang_PointerType_getPointeeType(T)
    ccall((:clang_PointerType_getPointeeType, libclangex), CXQualType, (CXPointerType,), T)
end

function clang_MemberPointerType_getPointeeType(T)
    ccall((:clang_MemberPointerType_getPointeeType, libclangex), CXQualType, (CXMemberPointerType,), T)
end

function clang_MemberPointerType_getClass(T)
    ccall((:clang_MemberPointerType_getClass, libclangex), CXType_, (CXMemberPointerType,), T)
end

function clang_TypedefType_desugar(T)
    ccall((:clang_TypedefType_desugar, libclangex), CXQualType, (CXTypedefType,), T)
end

function clang_EnumType_getDecl(T)
    ccall((:clang_EnumType_getDecl, libclangex), CXEnumDecl, (CXEnumType,), T)
end

function clang_FunctionType_getReturnType(T)
    ccall((:clang_FunctionType_getReturnType, libclangex), CXQualType, (CXFunctionType,), T)
end

function clang_FunctionProtoType_getNumParams(T)
    ccall((:clang_FunctionProtoType_getNumParams, libclangex), Cuint, (CXFunctionProtoType,), T)
end

function clang_FunctionProtoType_getParamType(T, i)
    ccall((:clang_FunctionProtoType_getParamType, libclangex), CXQualType, (CXFunctionProtoType, Cuint), T, i)
end

function clang_ReferenceType_getPointeeType(T)
    ccall((:clang_ReferenceType_getPointeeType, libclangex), CXQualType, (CXReferenceType,), T)
end

function clang_ElaboratedType_desugar(T)
    ccall((:clang_ElaboratedType_desugar, libclangex), CXQualType, (CXElaboratedType,), T)
end

function clang_TemplateSpecializationType_isCurrentInstantiation(T)
    ccall((:clang_TemplateSpecializationType_isCurrentInstantiation, libclangex), Bool, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_isTypeAlias(T)
    ccall((:clang_TemplateSpecializationType_isTypeAlias, libclangex), Bool, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_getAliasedType(T)
    ccall((:clang_TemplateSpecializationType_getAliasedType, libclangex), CXQualType, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_getTemplateName(T)
    ccall((:clang_TemplateSpecializationType_getTemplateName, libclangex), CXTemplateName, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_getNumArgs(T)
    ccall((:clang_TemplateSpecializationType_getNumArgs, libclangex), Cuint, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_getArg(T, Idx)
    ccall((:clang_TemplateSpecializationType_getArg, libclangex), CXTemplateArgument, (CXTemplateSpecializationType, Cuint), T, Idx)
end

function clang_TemplateSpecializationType_isSugared(T)
    ccall((:clang_TemplateSpecializationType_isSugared, libclangex), Bool, (CXTemplateSpecializationType,), T)
end

function clang_TemplateSpecializationType_desugar(T)
    ccall((:clang_TemplateSpecializationType_desugar, libclangex), CXQualType, (CXTemplateSpecializationType,), T)
end

@enum CXTagTypeKind::UInt32 begin
    CXTagTypeKind_TTK_Struct = 0
    CXTagTypeKind_TTK_Interface = 1
    CXTagTypeKind_TTK_Union = 2
    CXTagTypeKind_TTK_Class = 3
    CXTagTypeKind_TTK_Enum = 4
end

@enum CXElaboratedTypeKeyword::UInt32 begin
    CXElaboratedTypeKeyword_ETK_Struct = 0
    CXElaboratedTypeKeyword_ETK_Interface = 1
    CXElaboratedTypeKeyword_ETK_Union = 2
    CXElaboratedTypeKeyword_ETK_Class = 3
    CXElaboratedTypeKeyword_ETK_Enum = 4
    CXElaboratedTypeKeyword_ETK_Typename = 5
    CXElaboratedTypeKeyword_ETK_None = 6
end

@enum CXExceptionSpecificationType::UInt32 begin
    CXExceptionSpecificationType_EST_None = 0
    CXExceptionSpecificationType_EST_DynamicNone = 1
    CXExceptionSpecificationType_EST_Dynamic = 2
    CXExceptionSpecificationType_EST_MSAny = 3
    CXExceptionSpecificationType_EST_NoThrow = 4
    CXExceptionSpecificationType_EST_BasicNoexcept = 5
    CXExceptionSpecificationType_EST_DependentNoexcept = 6
    CXExceptionSpecificationType_EST_NoexceptFalse = 7
    CXExceptionSpecificationType_EST_NoexceptTrue = 8
    CXExceptionSpecificationType_EST_Unevaluated = 9
    CXExceptionSpecificationType_EST_Uninstantiated = 10
    CXExceptionSpecificationType_EST_Unparsed = 11
end

@enum CXLinkage::UInt8 begin
    CXLinkage_NoLinkage = 0x0000000000000000
    CXLinkage_InternalLinkage = 0x0000000000000001
    CXLinkage_UniqueExternalLinkage = 0x0000000000000002
    CXLinkage_VisibleNoLinkage = 0x0000000000000003
    CXLinkage_ModuleInternalLinkage = 0x0000000000000004
    CXLinkage_ModuleLinkage = 0x0000000000000005
    CXLinkage_ExternalLinkage = 0x0000000000000006
end

@enum CXLanguageLinkage::UInt32 begin
    CXLanguageLinkage_CLanguageLinkage = 0
    CXLanguageLinkage_CXXLanguageLinkage = 1
    CXLanguageLinkage_NoLanguageLinkage = 2
end

@enum CXPragmaMSCommentKind::UInt32 begin
    CXPragmaMSCommentKind_PCK_Unknown = 0
    CXPragmaMSCommentKind_PCK_Linker = 1
    CXPragmaMSCommentKind_PCK_Lib = 2
    CXPragmaMSCommentKind_PCK_Compiler = 3
    CXPragmaMSCommentKind_PCK_ExeStr = 4
    CXPragmaMSCommentKind_PCK_User = 5
end

@enum CXPragmaMSStructKind::UInt32 begin
    CXPragmaMSStructKind_PMSST_OFF = 0
    CXPragmaMSStructKind_PMSST_ON = 1
end

@enum CXPragmaFloatControlKind::UInt32 begin
    CXPragmaFloatControlKind_PFC_Unknown = 0
    CXPragmaFloatControlKind_PFC_Precise = 1
    CXPragmaFloatControlKind_PFC_NoPrecise = 2
    CXPragmaFloatControlKind_PFC_Except = 3
    CXPragmaFloatControlKind_PFC_NoExcept = 4
    CXPragmaFloatControlKind_PFC_Push = 5
    CXPragmaFloatControlKind_PFC_Pop = 6
end

@enum CXVisibility::UInt32 begin
    CXVisibility_HiddenVisibility = 0
    CXVisibility_ProtectedVisibility = 1
    CXVisibility_DefaultVisibility = 2
end

function clang_TranslationUnitDecl_getASTContext(TUD)
    ccall((:clang_TranslationUnitDecl_getASTContext, libclangex), CXASTContext, (CXTranslationUnitDecl,), TUD)
end

function clang_TranslationUnitDecl_getAnonymousNamespace(TUD)
    ccall((:clang_TranslationUnitDecl_getAnonymousNamespace, libclangex), CXNamespaceDecl, (CXTranslationUnitDecl,), TUD)
end

function clang_TranslationUnitDecl_setAnonymousNamespace(TUD, ND)
    ccall((:clang_TranslationUnitDecl_setAnonymousNamespace, libclangex), Cvoid, (CXTranslationUnitDecl, CXNamespaceDecl), TUD, ND)
end

function clang_TranslationUnitDecl_Create(TUD, C)
    ccall((:clang_TranslationUnitDecl_Create, libclangex), CXTranslationUnitDecl, (CXTranslationUnitDecl, CXASTContext), TUD, C)
end

function clang_PragmaCommentDecl_Create(C, DC, CommentLoc, CommentKind, Arg)
    ccall((:clang_PragmaCommentDecl_Create, libclangex), CXPragmaCommentDecl, (CXASTContext, CXTranslationUnitDecl, CXSourceLocation_, CXPragmaMSCommentKind, Ptr{Cchar}), C, DC, CommentLoc, CommentKind, Arg)
end

function clang_PragmaCommentDecl_CreateDeserialized(C, ID, ArgSize)
    ccall((:clang_PragmaCommentDecl_CreateDeserialized, libclangex), CXPragmaCommentDecl, (CXASTContext, Cuint, Cuint), C, ID, ArgSize)
end

function clang_PragmaCommentDecl_getCommentKind(PCD)
    ccall((:clang_PragmaCommentDecl_getCommentKind, libclangex), CXPragmaMSCommentKind, (CXPragmaCommentDecl,), PCD)
end

function clang_PragmaCommentDecl_getArg(PCD)
    ccall((:clang_PragmaCommentDecl_getArg, libclangex), Ptr{Cchar}, (CXPragmaCommentDecl,), PCD)
end

function clang_PragmaDetectMismatchDecl_Create(C, DC, Loc, Name, Value)
    ccall((:clang_PragmaDetectMismatchDecl_Create, libclangex), CXPragmaDetectMismatchDecl, (CXASTContext, CXTranslationUnitDecl, CXSourceLocation_, Ptr{Cchar}, Ptr{Cchar}), C, DC, Loc, Name, Value)
end

function clang_PragmaDetectMismatchDecl_CreateDeserialized(C, ID, NameValueSize)
    ccall((:clang_PragmaDetectMismatchDecl_CreateDeserialized, libclangex), CXPragmaDetectMismatchDecl, (CXASTContext, Cuint, Cuint), C, ID, NameValueSize)
end

function clang_PragmaDetectMismatchDecl_getName(PDMD)
    ccall((:clang_PragmaDetectMismatchDecl_getName, libclangex), Ptr{Cchar}, (CXPragmaDetectMismatchDecl,), PDMD)
end

function clang_PragmaDetectMismatchDecl_getValue(PDMD)
    ccall((:clang_PragmaDetectMismatchDecl_getValue, libclangex), Ptr{Cchar}, (CXPragmaDetectMismatchDecl,), PDMD)
end

function clang_ExternCContextDecl_Create(C, TU)
    ccall((:clang_ExternCContextDecl_Create, libclangex), CXExternCContextDecl, (CXASTContext, CXTranslationUnitDecl), C, TU)
end

function clang_NamedDecl_getIdentifier(ND)
    ccall((:clang_NamedDecl_getIdentifier, libclangex), CXIdentifierInfo, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getName(ND)
    ccall((:clang_NamedDecl_getName, libclangex), Ptr{Cchar}, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getDeclName(ND)
    ccall((:clang_NamedDecl_getDeclName, libclangex), CXDeclarationName, (CXNamedDecl,), ND)
end

function clang_NamedDecl_setDeclName(ND, DN)
    ccall((:clang_NamedDecl_setDeclName, libclangex), Cvoid, (CXNamedDecl, CXDeclarationName), ND, DN)
end

function clang_NamedDecl_declarationReplaces(ND, OldD, IsKnownNewer)
    ccall((:clang_NamedDecl_declarationReplaces, libclangex), Bool, (CXNamedDecl, CXNamedDecl, Bool), ND, OldD, IsKnownNewer)
end

function clang_NamedDecl_hasLinkage(ND)
    ccall((:clang_NamedDecl_hasLinkage, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isCXXClassMember(ND)
    ccall((:clang_NamedDecl_isCXXClassMember, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isCXXInstanceMember(ND)
    ccall((:clang_NamedDecl_isCXXInstanceMember, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getLinkageInternal(ND)
    ccall((:clang_NamedDecl_getLinkageInternal, libclangex), CXLinkage, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getFormalLinkage(ND)
    ccall((:clang_NamedDecl_getFormalLinkage, libclangex), CXLinkage, (CXNamedDecl,), ND)
end

function clang_NamedDecl_hasExternalFormalLinkage(ND)
    ccall((:clang_NamedDecl_hasExternalFormalLinkage, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isExternallyVisible(ND)
    ccall((:clang_NamedDecl_isExternallyVisible, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isExternallyDeclarable(ND)
    ccall((:clang_NamedDecl_isExternallyDeclarable, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getVisibility(ND)
    ccall((:clang_NamedDecl_getVisibility, libclangex), CXVisibility, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isLinkageValid(ND)
    ccall((:clang_NamedDecl_isLinkageValid, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_hasLinkageBeenComputed(ND)
    ccall((:clang_NamedDecl_hasLinkageBeenComputed, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getUnderlyingDecl(ND)
    ccall((:clang_NamedDecl_getUnderlyingDecl, libclangex), CXNamedDecl, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getMostRecentDecl(ND)
    ccall((:clang_NamedDecl_getMostRecentDecl, libclangex), CXNamedDecl, (CXNamedDecl,), ND)
end

function clang_NamedDecl_castToTypeDecl(ND)
    ccall((:clang_NamedDecl_castToTypeDecl, libclangex), CXTypeDecl, (CXNamedDecl,), ND)
end

function clang_LabelDecl_Create(C, DC, IdentL, II)
    ccall((:clang_LabelDecl_Create, libclangex), CXLabelDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXIdentifierInfo), C, DC, IdentL, II)
end

function clang_LabelDecl_CreateDeserialized(C, ID)
    ccall((:clang_LabelDecl_CreateDeserialized, libclangex), CXLabelDecl, (CXASTContext, Cuint), C, ID)
end

function clang_LabelDecl_getStmt(LD)
    ccall((:clang_LabelDecl_getStmt, libclangex), CXLabelStmt, (CXLabelDecl,), LD)
end

function clang_LabelDecl_setStmt(LD, T)
    ccall((:clang_LabelDecl_setStmt, libclangex), Cvoid, (CXLabelDecl, CXLabelStmt), LD, T)
end

function clang_LabelDecl_isGnuLocal(LD)
    ccall((:clang_LabelDecl_isGnuLocal, libclangex), Bool, (CXLabelDecl,), LD)
end

function clang_LabelDecl_setLocStart(LD, Loc)
    ccall((:clang_LabelDecl_setLocStart, libclangex), Cvoid, (CXLabelDecl, CXSourceLocation_), LD, Loc)
end

function clang_LabelDecl_getSourceRange(LD)
    ccall((:clang_LabelDecl_getSourceRange, libclangex), CXSourceRange_, (CXLabelDecl,), LD)
end

function clang_LabelDecl_isMSAsmLabel(LD)
    ccall((:clang_LabelDecl_isMSAsmLabel, libclangex), Bool, (CXLabelDecl,), LD)
end

function clang_LabelDecl_isResolvedMSAsmLabel(LD)
    ccall((:clang_LabelDecl_isResolvedMSAsmLabel, libclangex), Bool, (CXLabelDecl,), LD)
end

function clang_LabelDecl_getMSAsmLabel(LD)
    ccall((:clang_LabelDecl_getMSAsmLabel, libclangex), Ptr{Cchar}, (CXLabelDecl,), LD)
end

function clang_LabelDecl_setMSAsmLabelResolved(LD)
    ccall((:clang_LabelDecl_setMSAsmLabelResolved, libclangex), Cvoid, (CXLabelDecl,), LD)
end

function clang_NamespaceDecl_Create(C, DC, Inline, StartLoc, IdLoc, Id, PrevDecl)
    ccall((:clang_NamespaceDecl_Create, libclangex), CXNamespaceDecl, (CXASTContext, CXDeclContext, Bool, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXNamespaceDecl), C, DC, Inline, StartLoc, IdLoc, Id, PrevDecl)
end

function clang_NamespaceDecl_CreateDeserialized(C, ID)
    ccall((:clang_NamespaceDecl_CreateDeserialized, libclangex), CXNamespaceDecl, (CXASTContext, Cuint), C, ID)
end

function clang_NamespaceDecl_isAnonymousNamespace(ND)
    ccall((:clang_NamespaceDecl_isAnonymousNamespace, libclangex), Bool, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_isInline(ND)
    ccall((:clang_NamespaceDecl_isInline, libclangex), Bool, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_setInline(ND, Inline)
    ccall((:clang_NamespaceDecl_setInline, libclangex), Cvoid, (CXNamespaceDecl, Bool), ND, Inline)
end

function clang_NamespaceDecl_getOriginalNamespace(ND)
    ccall((:clang_NamespaceDecl_getOriginalNamespace, libclangex), CXNamespaceDecl, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_isOriginalNamespace(ND)
    ccall((:clang_NamespaceDecl_isOriginalNamespace, libclangex), Bool, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_getAnonymousNamespace(ND)
    ccall((:clang_NamespaceDecl_getAnonymousNamespace, libclangex), CXNamespaceDecl, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_setAnonymousNamespace(ND, D)
    ccall((:clang_NamespaceDecl_setAnonymousNamespace, libclangex), Cvoid, (CXNamespaceDecl, CXNamespaceDecl), ND, D)
end

function clang_NamespaceDecl_getCanonicalDecl(ND)
    ccall((:clang_NamespaceDecl_getCanonicalDecl, libclangex), CXNamespaceDecl, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_getSourceRange(ND)
    ccall((:clang_NamespaceDecl_getSourceRange, libclangex), CXSourceRange_, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_getBeginLoc(ND)
    ccall((:clang_NamespaceDecl_getBeginLoc, libclangex), CXSourceLocation_, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_getRBraceLoc(ND)
    ccall((:clang_NamespaceDecl_getRBraceLoc, libclangex), CXSourceLocation_, (CXNamespaceDecl,), ND)
end

function clang_NamespaceDecl_setLocStart(ND, Loc)
    ccall((:clang_NamespaceDecl_setLocStart, libclangex), Cvoid, (CXNamespaceDecl, CXSourceLocation_), ND, Loc)
end

function clang_NamespaceDecl_setRBraceLoc(ND, Loc)
    ccall((:clang_NamespaceDecl_setRBraceLoc, libclangex), Cvoid, (CXNamespaceDecl, CXSourceLocation_), ND, Loc)
end

function clang_ValueDecl_getType(VD)
    ccall((:clang_ValueDecl_getType, libclangex), CXQualType, (CXValueDecl,), VD)
end

function clang_ValueDecl_setType(VD, OpaquePtr)
    ccall((:clang_ValueDecl_setType, libclangex), Cvoid, (CXValueDecl, CXQualType), VD, OpaquePtr)
end

function clang_ValueDecl_isWeak(VD)
    ccall((:clang_ValueDecl_isWeak, libclangex), Bool, (CXValueDecl,), VD)
end

function clang_DeclaratorDecl_getTypeSourceInfo(DD)
    ccall((:clang_DeclaratorDecl_getTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_setTypeSourceInfo(DD, TI)
    ccall((:clang_DeclaratorDecl_setTypeSourceInfo, libclangex), Cvoid, (CXDeclaratorDecl, CXTypeSourceInfo), DD, TI)
end

function clang_DeclaratorDecl_getInnerLocStart(DD)
    ccall((:clang_DeclaratorDecl_getInnerLocStart, libclangex), CXSourceLocation_, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_setInnerLocStart(DD, Loc)
    ccall((:clang_DeclaratorDecl_setInnerLocStart, libclangex), Cvoid, (CXDeclaratorDecl, CXSourceLocation_), DD, Loc)
end

function clang_DeclaratorDecl_getOuterLocStart(DD)
    ccall((:clang_DeclaratorDecl_getOuterLocStart, libclangex), CXSourceLocation_, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_getBeginLoc(DD)
    ccall((:clang_DeclaratorDecl_getBeginLoc, libclangex), CXSourceLocation_, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_getQualifier(DD)
    ccall((:clang_DeclaratorDecl_getQualifier, libclangex), CXNestedNameSpecifier, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_getTrailingRequiresClause(DD)
    ccall((:clang_DeclaratorDecl_getTrailingRequiresClause, libclangex), CXExpr, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_setTrailingRequiresClause(DD, TrailingRequiresClause)
    ccall((:clang_DeclaratorDecl_setTrailingRequiresClause, libclangex), Cvoid, (CXDeclaratorDecl, CXExpr), DD, TrailingRequiresClause)
end

function clang_DeclaratorDecl_getNumTemplateParameterLists(DD)
    ccall((:clang_DeclaratorDecl_getNumTemplateParameterLists, libclangex), Cuint, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_getTemplateParameterList(DD, index)
    ccall((:clang_DeclaratorDecl_getTemplateParameterList, libclangex), CXTemplateParameterList, (CXDeclaratorDecl, Cuint), DD, index)
end

function clang_DeclaratorDecl_getTypeSpecStartLoc(DD)
    ccall((:clang_DeclaratorDecl_getTypeSpecStartLoc, libclangex), CXSourceLocation_, (CXDeclaratorDecl,), DD)
end

function clang_DeclaratorDecl_getTypeSpecEndLoc(DD)
    ccall((:clang_DeclaratorDecl_getTypeSpecEndLoc, libclangex), CXSourceLocation_, (CXDeclaratorDecl,), DD)
end

function clang_VarDecl_Create(C, DC, StartLoc, IdLoc, Id, T, TInfo, S)
    ccall((:clang_VarDecl_Create, libclangex), CXVarDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXQualType, CXTypeSourceInfo, CXStorageClass), C, DC, StartLoc, IdLoc, Id, T, TInfo, S)
end

function clang_VarDecl_CreateDeserialized(C, ID)
    ccall((:clang_VarDecl_CreateDeserialized, libclangex), CXVarDecl, (CXASTContext, Cuint), C, ID)
end

function clang_VarDecl_getSourceRange(VD)
    ccall((:clang_VarDecl_getSourceRange, libclangex), CXSourceRange_, (CXVarDecl,), VD)
end

function clang_VarDecl_getStorageClass(VD)
    ccall((:clang_VarDecl_getStorageClass, libclangex), CXStorageClass, (CXVarDecl,), VD)
end

function clang_VarDecl_setStorageClass(VD, SC)
    ccall((:clang_VarDecl_setStorageClass, libclangex), Cvoid, (CXVarDecl, CXStorageClass), VD, SC)
end

function clang_VarDecl_setTSCSpec(VD, TSC)
    ccall((:clang_VarDecl_setTSCSpec, libclangex), Cvoid, (CXVarDecl, CXThreadStorageClassSpecifier), VD, TSC)
end

function clang_VarDecl_getTSCSpec(VD)
    ccall((:clang_VarDecl_getTSCSpec, libclangex), CXThreadStorageClassSpecifier, (CXVarDecl,), VD)
end

function clang_VarDecl_hasLocalStorage(VD)
    ccall((:clang_VarDecl_hasLocalStorage, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isStaticLocal(VD)
    ccall((:clang_VarDecl_isStaticLocal, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_hasExternalStorage(VD)
    ccall((:clang_VarDecl_hasExternalStorage, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_hasGlobalStorage(VD)
    ccall((:clang_VarDecl_hasGlobalStorage, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_getStorageDuration(VD)
    ccall((:clang_VarDecl_getStorageDuration, libclangex), CXStorageDuration, (CXVarDecl,), VD)
end

function clang_VarDecl_getLanguageLinkage(VD)
    ccall((:clang_VarDecl_getLanguageLinkage, libclangex), CXLanguageLinkage, (CXVarDecl,), VD)
end

function clang_VarDecl_isExternC(VD)
    ccall((:clang_VarDecl_isExternC, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isInExternCContext(VD)
    ccall((:clang_VarDecl_isInExternCContext, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isInExternCXXContext(VD)
    ccall((:clang_VarDecl_isInExternCXXContext, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isLocalVarDecl(VD)
    ccall((:clang_VarDecl_isLocalVarDecl, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isLocalVarDeclOrParm(VD)
    ccall((:clang_VarDecl_isLocalVarDeclOrParm, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isFunctionOrMethodVarDecl(VD)
    ccall((:clang_VarDecl_isFunctionOrMethodVarDecl, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isStaticDataMember(VD)
    ccall((:clang_VarDecl_isStaticDataMember, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_getCanonicalDecl(VD)
    ccall((:clang_VarDecl_getCanonicalDecl, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_getActingDefinition(VD)
    ccall((:clang_VarDecl_getActingDefinition, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_getDefinition(VD)
    ccall((:clang_VarDecl_getDefinition, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_isOutOfLine(VD)
    ccall((:clang_VarDecl_isOutOfLine, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isFileVarDecl(VD)
    ccall((:clang_VarDecl_isFileVarDecl, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_getAnyInitializer(VD)
    ccall((:clang_VarDecl_getAnyInitializer, libclangex), CXExpr, (CXVarDecl,), VD)
end

function clang_VarDecl_hasInit(VD)
    ccall((:clang_VarDecl_hasInit, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_getInit(VD)
    ccall((:clang_VarDecl_getInit, libclangex), CXExpr, (CXVarDecl,), VD)
end

function clang_VarDecl_setInit(VD, I)
    ccall((:clang_VarDecl_setInit, libclangex), Cvoid, (CXVarDecl, CXExpr), VD, I)
end

function clang_VarDecl_getInitializingDeclaration(VD)
    ccall((:clang_VarDecl_getInitializingDeclaration, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_mightBeUsableInConstantExpressions(VD, C)
    ccall((:clang_VarDecl_mightBeUsableInConstantExpressions, libclangex), Bool, (CXVarDecl, CXASTContext), VD, C)
end

function clang_VarDecl_isUsableInConstantExpressions(VD, C)
    ccall((:clang_VarDecl_isUsableInConstantExpressions, libclangex), Bool, (CXVarDecl, CXASTContext), VD, C)
end

function clang_VarDecl_ensureEvaluatedStmt(VD)
    ccall((:clang_VarDecl_ensureEvaluatedStmt, libclangex), CXEvaluatedStmt, (CXVarDecl,), VD)
end

function clang_VarDecl_getEvaluatedStmt(VD)
    ccall((:clang_VarDecl_getEvaluatedStmt, libclangex), CXEvaluatedStmt, (CXVarDecl,), VD)
end

function clang_VarDecl_hasConstantInitialization(VD)
    ccall((:clang_VarDecl_hasConstantInitialization, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_hasICEInitializer(VD, Context)
    ccall((:clang_VarDecl_hasICEInitializer, libclangex), Bool, (CXVarDecl, CXASTContext), VD, Context)
end

function clang_VarDecl_isDirectInit(VD)
    ccall((:clang_VarDecl_isDirectInit, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isThisDeclarationADemotedDefinition(VD)
    ccall((:clang_VarDecl_isThisDeclarationADemotedDefinition, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_demoteThisDefinitionToDeclaration(VD)
    ccall((:clang_VarDecl_demoteThisDefinitionToDeclaration, libclangex), Cvoid, (CXVarDecl,), VD)
end

function clang_VarDecl_isExceptionVariable(VD)
    ccall((:clang_VarDecl_isExceptionVariable, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setExceptionVariable(VD, EV)
    ccall((:clang_VarDecl_setExceptionVariable, libclangex), Cvoid, (CXVarDecl, Bool), VD, EV)
end

function clang_VarDecl_isNRVOVariable(VD)
    ccall((:clang_VarDecl_isNRVOVariable, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setNRVOVariable(VD, NRVO)
    ccall((:clang_VarDecl_setNRVOVariable, libclangex), Cvoid, (CXVarDecl, Bool), VD, NRVO)
end

function clang_VarDecl_isCXXForRangeDecl(VD)
    ccall((:clang_VarDecl_isCXXForRangeDecl, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setCXXForRangeDecl(VD, FRD)
    ccall((:clang_VarDecl_setCXXForRangeDecl, libclangex), Cvoid, (CXVarDecl, Bool), VD, FRD)
end

function clang_VarDecl_isObjCForDecl(VD)
    ccall((:clang_VarDecl_isObjCForDecl, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setObjCForDecl(VD, FRD)
    ccall((:clang_VarDecl_setObjCForDecl, libclangex), Cvoid, (CXVarDecl, Bool), VD, FRD)
end

function clang_VarDecl_isARCPseudoStrong(VD)
    ccall((:clang_VarDecl_isARCPseudoStrong, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setARCPseudoStrong(VD, PS)
    ccall((:clang_VarDecl_setARCPseudoStrong, libclangex), Cvoid, (CXVarDecl, Bool), VD, PS)
end

function clang_VarDecl_isInline(VD)
    ccall((:clang_VarDecl_isInline, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isInlineSpecified(VD)
    ccall((:clang_VarDecl_isInlineSpecified, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setInlineSpecified(VD)
    ccall((:clang_VarDecl_setInlineSpecified, libclangex), Cvoid, (CXVarDecl,), VD)
end

function clang_VarDecl_setImplicitlyInline(VD)
    ccall((:clang_VarDecl_setImplicitlyInline, libclangex), Cvoid, (CXVarDecl,), VD)
end

function clang_VarDecl_isConstexpr(VD)
    ccall((:clang_VarDecl_isConstexpr, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setConstexpr(VD, IC)
    ccall((:clang_VarDecl_setConstexpr, libclangex), Cvoid, (CXVarDecl, Bool), VD, IC)
end

function clang_VarDecl_isInitCapture(VD)
    ccall((:clang_VarDecl_isInitCapture, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setInitCapture(VD, IC)
    ccall((:clang_VarDecl_setInitCapture, libclangex), Cvoid, (CXVarDecl, Bool), VD, IC)
end

function clang_VarDecl_isParameterPack(VD)
    ccall((:clang_VarDecl_isParameterPack, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isPreviousDeclInSameBlockScope(VD)
    ccall((:clang_VarDecl_isPreviousDeclInSameBlockScope, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setPreviousDeclInSameBlockScope(VD, Same)
    ccall((:clang_VarDecl_setPreviousDeclInSameBlockScope, libclangex), Cvoid, (CXVarDecl, Bool), VD, Same)
end

function clang_VarDecl_isEscapingByref(VD)
    ccall((:clang_VarDecl_isEscapingByref, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isNonEscapingByref(VD)
    ccall((:clang_VarDecl_isNonEscapingByref, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_setEscapingByref(VD)
    ccall((:clang_VarDecl_setEscapingByref, libclangex), Cvoid, (CXVarDecl,), VD)
end

function clang_VarDecl_getTemplateInstantiationPattern(VD)
    ccall((:clang_VarDecl_getTemplateInstantiationPattern, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_getInstantiatedFromStaticDataMember(VD)
    ccall((:clang_VarDecl_getInstantiatedFromStaticDataMember, libclangex), CXVarDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_getTemplateSpecializationKind(VD)
    ccall((:clang_VarDecl_getTemplateSpecializationKind, libclangex), CXTemplateSpecializationKind, (CXVarDecl,), VD)
end

function clang_VarDecl_getTemplateSpecializationKindForInstantiation(VD)
    ccall((:clang_VarDecl_getTemplateSpecializationKindForInstantiation, libclangex), CXTemplateSpecializationKind, (CXVarDecl,), VD)
end

function clang_VarDecl_getPointOfInstantiation(VD)
    ccall((:clang_VarDecl_getPointOfInstantiation, libclangex), CXSourceLocation_, (CXVarDecl,), VD)
end

function clang_VarDecl_setTemplateSpecializationKind(VD, TSK, PointOfInstantiation)
    ccall((:clang_VarDecl_setTemplateSpecializationKind, libclangex), Cvoid, (CXVarDecl, CXTemplateSpecializationKind, CXSourceLocation_), VD, TSK, PointOfInstantiation)
end

function clang_VarDecl_setInstantiationOfStaticDataMember(VD, VD2, TSK)
    ccall((:clang_VarDecl_setInstantiationOfStaticDataMember, libclangex), Cvoid, (CXVarDecl, CXVarDecl, CXTemplateSpecializationKind), VD, VD2, TSK)
end

function clang_VarDecl_getDescribedVarTemplate(VD)
    ccall((:clang_VarDecl_getDescribedVarTemplate, libclangex), CXVarTemplateDecl, (CXVarDecl,), VD)
end

function clang_VarDecl_setDescribedVarTemplate(VD, Template)
    ccall((:clang_VarDecl_setDescribedVarTemplate, libclangex), Cvoid, (CXVarDecl, CXVarTemplateDecl), VD, Template)
end

function clang_VarDecl_isKnownToBeDefined(VD)
    ccall((:clang_VarDecl_isKnownToBeDefined, libclangex), Bool, (CXVarDecl,), VD)
end

function clang_VarDecl_isNoDestroy(VD, AST)
    ccall((:clang_VarDecl_isNoDestroy, libclangex), Bool, (CXVarDecl, CXASTContext), VD, AST)
end

@enum CXImplicitParamDecl_ImplicitParamKind::UInt32 begin
    CXImplicitParamDecl_ObjCSelf = 0x0000000000000000
    CXImplicitParamDecl_ObjCCmd = 0x0000000000000001
    CXImplicitParamDecl_CXXThis = 0x0000000000000002
    CXImplicitParamDecl_CXXVTT = 0x0000000000000003
    CXImplicitParamDecl_CapturedContext = 0x0000000000000004
    CXImplicitParamDecl_Other = 0x0000000000000005
end

function clang_ImplicitParamDecl_Create(C, DC, IdLoc, Id, T, ParamKind)
    ccall((:clang_ImplicitParamDecl_Create, libclangex), CXImplicitParamDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXIdentifierInfo, CXQualType, CXImplicitParamDecl_ImplicitParamKind), C, DC, IdLoc, Id, T, ParamKind)
end

function clang_ImplicitParamDecl_CreateDeserialized(C, ID)
    ccall((:clang_ImplicitParamDecl_CreateDeserialized, libclangex), CXImplicitParamDecl, (CXASTContext, Cuint), C, ID)
end

function clang_ImplicitParamDecl_getParameterKind(IPD)
    ccall((:clang_ImplicitParamDecl_getParameterKind, libclangex), CXImplicitParamDecl_ImplicitParamKind, (CXImplicitParamDecl,), IPD)
end

function clang_ParmVarDecl_Create(C, DC, StartLoc, IdLoc, Id, T, TInfo, S, DefArg)
    ccall((:clang_ParmVarDecl_Create, libclangex), CXParmVarDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXQualType, CXTypeSourceInfo, CXStorageClass, CXExpr), C, DC, StartLoc, IdLoc, Id, T, TInfo, S, DefArg)
end

function clang_ParmVarDecl_CreateDeserialized(C, ID)
    ccall((:clang_ParmVarDecl_CreateDeserialized, libclangex), CXParmVarDecl, (CXASTContext, Cuint), C, ID)
end

function clang_ParmVarDecl_setObjCMethodScopeInfo(PVD, parameterIndex)
    ccall((:clang_ParmVarDecl_setObjCMethodScopeInfo, libclangex), Cvoid, (CXParmVarDecl, Cuint), PVD, parameterIndex)
end

function clang_ParmVarDecl_setScopeInfo(PVD, scopeDepth, parameterIndex)
    ccall((:clang_ParmVarDecl_setScopeInfo, libclangex), Cvoid, (CXParmVarDecl, Cuint, Cuint), PVD, scopeDepth, parameterIndex)
end

function clang_ParmVarDecl_isObjCMethodParameter(PVD)
    ccall((:clang_ParmVarDecl_isObjCMethodParameter, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_isDestroyedInCallee(PVD)
    ccall((:clang_ParmVarDecl_isDestroyedInCallee, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_getFunctionScopeDepth(PVD)
    ccall((:clang_ParmVarDecl_getFunctionScopeDepth, libclangex), Cuint, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_getFunctionScopeIndex(PVD)
    ccall((:clang_ParmVarDecl_getFunctionScopeIndex, libclangex), Cuint, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_isKNRPromoted(PVD)
    ccall((:clang_ParmVarDecl_isKNRPromoted, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setKNRPromoted(PVD, promoted)
    ccall((:clang_ParmVarDecl_setKNRPromoted, libclangex), Cvoid, (CXParmVarDecl, Bool), PVD, promoted)
end

function clang_ParmVarDecl_getDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_getDefaultArg, libclangex), CXExpr, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setDefaultArg(PVD, defarg)
    ccall((:clang_ParmVarDecl_setDefaultArg, libclangex), Cvoid, (CXParmVarDecl, CXExpr), PVD, defarg)
end

function clang_ParmVarDecl_getDefaultArgRange(PVD)
    ccall((:clang_ParmVarDecl_getDefaultArgRange, libclangex), CXSourceRange_, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setUninstantiatedDefaultArg(PVD, arg)
    ccall((:clang_ParmVarDecl_setUninstantiatedDefaultArg, libclangex), Cvoid, (CXParmVarDecl, CXExpr), PVD, arg)
end

function clang_ParmVarDecl_getUninstantiatedDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_getUninstantiatedDefaultArg, libclangex), CXExpr, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_hasDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_hasDefaultArg, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_hasUnparsedDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_hasUnparsedDefaultArg, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_hasUninstantiatedDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_hasUninstantiatedDefaultArg, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setUnparsedDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_setUnparsedDefaultArg, libclangex), Cvoid, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_hasInheritedDefaultArg(PVD)
    ccall((:clang_ParmVarDecl_hasInheritedDefaultArg, libclangex), Bool, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setHasInheritedDefaultArg(PVD, I)
    ccall((:clang_ParmVarDecl_setHasInheritedDefaultArg, libclangex), Cvoid, (CXParmVarDecl, Bool), PVD, I)
end

function clang_ParmVarDecl_getOriginalType(PVD)
    ccall((:clang_ParmVarDecl_getOriginalType, libclangex), CXQualType, (CXParmVarDecl,), PVD)
end

function clang_ParmVarDecl_setOwningFunction(PVD, FD)
    ccall((:clang_ParmVarDecl_setOwningFunction, libclangex), Cvoid, (CXParmVarDecl, CXDeclContext), PVD, FD)
end

@enum CXMultiVersionKind::UInt32 begin
    CXMultiVersionKind_None = 0
    CXMultiVersionKind_Target = 1
    CXMultiVersionKind_CPUSpecific = 2
    CXMultiVersionKind_CPUDispatch = 3
end

@enum CXFunctionDecl_TemplatedKind::UInt32 begin
    CXFunctionDecl_TK_NonTemplate = 0
    CXFunctionDecl_TK_FunctionTemplate = 1
    CXFunctionDecl_TK_MemberSpecialization = 2
    CXFunctionDecl_TK_FunctionTemplateSpecialization = 3
    CXFunctionDecl_TK_DependentFunctionTemplateSpecialization = 4
end

const CXFunctionDecl_DefaultedFunctionInfo = Ptr{Cvoid}

function clang_FunctionDecl_Create(C, DC, StartLoc, NLoc, N, T, TInfo, SC, isInlineSpecified, hasWrittenPrototype)
    ccall((:clang_FunctionDecl_Create, libclangex), CXFunctionDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXDeclarationName, CXQualType, CXTypeSourceInfo, CXStorageClass, Bool, Bool), C, DC, StartLoc, NLoc, N, T, TInfo, SC, isInlineSpecified, hasWrittenPrototype)
end

function clang_FunctionDecl_CreateDeserialized(C, ID)
    ccall((:clang_FunctionDecl_CreateDeserialized, libclangex), CXFunctionDecl, (CXASTContext, Cuint), C, ID)
end

function clang_FunctionDecl_setRangeEnd(FD, Loc)
    ccall((:clang_FunctionDecl_setRangeEnd, libclangex), Cvoid, (CXFunctionDecl, CXSourceLocation_), FD, Loc)
end

function clang_FunctionDecl_getEllipsisLoc(FD)
    ccall((:clang_FunctionDecl_getEllipsisLoc, libclangex), CXSourceLocation_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getSourceRange(FD)
    ccall((:clang_FunctionDecl_getSourceRange, libclangex), CXSourceRange_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasBody(FD)
    ccall((:clang_FunctionDecl_hasBody, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasTrivialBody(FD)
    ccall((:clang_FunctionDecl_hasTrivialBody, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isDefined(FD)
    ccall((:clang_FunctionDecl_isDefined, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getDefinition(FD)
    ccall((:clang_FunctionDecl_getDefinition, libclangex), CXFunctionDecl, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getBody(FD)
    ccall((:clang_FunctionDecl_getBody, libclangex), CXStmt, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isThisDeclarationADefinition(FD)
    ccall((:clang_FunctionDecl_isThisDeclarationADefinition, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(FD)
    ccall((:clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_doesThisDeclarationHaveABody(FD)
    ccall((:clang_FunctionDecl_doesThisDeclarationHaveABody, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setBody(FD, B)
    ccall((:clang_FunctionDecl_setBody, libclangex), Cvoid, (CXFunctionDecl, CXStmt), FD, B)
end

function clang_FunctionDecl_setLazyBody(FD, Offset)
    ccall((:clang_FunctionDecl_setLazyBody, libclangex), Cvoid, (CXFunctionDecl, UInt64), FD, Offset)
end

function clang_FunctionDecl_setDefaultedFunctionInfo(FD, Info)
    ccall((:clang_FunctionDecl_setDefaultedFunctionInfo, libclangex), Cvoid, (CXFunctionDecl, CXFunctionDecl_DefaultedFunctionInfo), FD, Info)
end

function clang_FunctionDecl_isVariadic(FD)
    ccall((:clang_FunctionDecl_isVariadic, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isVirtualAsWritten(FD)
    ccall((:clang_FunctionDecl_isVirtualAsWritten, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setVirtualAsWritten(FD, V)
    ccall((:clang_FunctionDecl_setVirtualAsWritten, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, V)
end

function clang_FunctionDecl_isPure(FD)
    ccall((:clang_FunctionDecl_isPure, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setPure(FD, P)
    ccall((:clang_FunctionDecl_setPure, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, P)
end

function clang_FunctionDecl_isLateTemplateParsed(FD)
    ccall((:clang_FunctionDecl_isLateTemplateParsed, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setLateTemplateParsed(FD, ILT)
    ccall((:clang_FunctionDecl_setLateTemplateParsed, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, ILT)
end

function clang_FunctionDecl_isTrivial(FD)
    ccall((:clang_FunctionDecl_isTrivial, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setTrivial(FD, IT)
    ccall((:clang_FunctionDecl_setTrivial, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, IT)
end

function clang_FunctionDecl_isTrivialForCall(FD)
    ccall((:clang_FunctionDecl_isTrivialForCall, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setTrivialForCall(FD, IT)
    ccall((:clang_FunctionDecl_setTrivialForCall, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, IT)
end

function clang_FunctionDecl_isDefaulted(FD)
    ccall((:clang_FunctionDecl_isDefaulted, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setDefaulted(FD, D)
    ccall((:clang_FunctionDecl_setDefaulted, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, D)
end

function clang_FunctionDecl_isExplicitlyDefaulted(FD)
    ccall((:clang_FunctionDecl_isExplicitlyDefaulted, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setExplicitlyDefaulted(FD, ED)
    ccall((:clang_FunctionDecl_setExplicitlyDefaulted, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, ED)
end

function clang_FunctionDecl_isUserProvided(FD)
    ccall((:clang_FunctionDecl_isUserProvided, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasImplicitReturnZero(FD)
    ccall((:clang_FunctionDecl_hasImplicitReturnZero, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setHasImplicitReturnZero(FD, IRZ)
    ccall((:clang_FunctionDecl_setHasImplicitReturnZero, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, IRZ)
end

function clang_FunctionDecl_hasPrototype(FD)
    ccall((:clang_FunctionDecl_hasPrototype, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasWrittenPrototype(FD)
    ccall((:clang_FunctionDecl_hasWrittenPrototype, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setHasWrittenPrototype(FD, P)
    ccall((:clang_FunctionDecl_setHasWrittenPrototype, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, P)
end

function clang_FunctionDecl_hasInheritedPrototype(FD)
    ccall((:clang_FunctionDecl_hasInheritedPrototype, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setHasInheritedPrototype(FD, P)
    ccall((:clang_FunctionDecl_setHasInheritedPrototype, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, P)
end

function clang_FunctionDecl_isConstexpr(FD)
    ccall((:clang_FunctionDecl_isConstexpr, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setConstexprKind(FD, CSK)
    ccall((:clang_FunctionDecl_setConstexprKind, libclangex), Cvoid, (CXFunctionDecl, CXConstexprSpecKind), FD, CSK)
end

function clang_FunctionDecl_getConstexprKind(FD)
    ccall((:clang_FunctionDecl_getConstexprKind, libclangex), CXConstexprSpecKind, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isConstexprSpecified(FD)
    ccall((:clang_FunctionDecl_isConstexprSpecified, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isConsteval(FD)
    ccall((:clang_FunctionDecl_isConsteval, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_instantiationIsPending(FD)
    ccall((:clang_FunctionDecl_instantiationIsPending, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setInstantiationIsPending(FD, IC)
    ccall((:clang_FunctionDecl_setInstantiationIsPending, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, IC)
end

function clang_FunctionDecl_usesSEHTry(FD)
    ccall((:clang_FunctionDecl_usesSEHTry, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setUsesSEHTry(FD, UST)
    ccall((:clang_FunctionDecl_setUsesSEHTry, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, UST)
end

function clang_FunctionDecl_isDeleted(FD)
    ccall((:clang_FunctionDecl_isDeleted, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isDeletedAsWritten(FD)
    ccall((:clang_FunctionDecl_isDeletedAsWritten, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setDeletedAsWritten(FD, D)
    ccall((:clang_FunctionDecl_setDeletedAsWritten, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, D)
end

function clang_FunctionDecl_isMain(FD)
    ccall((:clang_FunctionDecl_isMain, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isMSVCRTEntryPoint(FD)
    ccall((:clang_FunctionDecl_isMSVCRTEntryPoint, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isReservedGlobalPlacementOperator(FD)
    ccall((:clang_FunctionDecl_isReservedGlobalPlacementOperator, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isReplaceableGlobalAllocationFunction(FD)
    ccall((:clang_FunctionDecl_isReplaceableGlobalAllocationFunction, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isInlineBuiltinDeclaration(FD)
    ccall((:clang_FunctionDecl_isInlineBuiltinDeclaration, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isDestroyingOperatorDelete(FD)
    ccall((:clang_FunctionDecl_isDestroyingOperatorDelete, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getLanguageLinkage(FD)
    ccall((:clang_FunctionDecl_getLanguageLinkage, libclangex), CXLanguageLinkage, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isExternC(FD)
    ccall((:clang_FunctionDecl_isExternC, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isInExternCContext(FD)
    ccall((:clang_FunctionDecl_isInExternCContext, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isInExternCXXContext(FD)
    ccall((:clang_FunctionDecl_isInExternCXXContext, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isGlobal(FD)
    ccall((:clang_FunctionDecl_isGlobal, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isNoReturn(FD)
    ccall((:clang_FunctionDecl_isNoReturn, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasSkippedBody(FD)
    ccall((:clang_FunctionDecl_hasSkippedBody, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setHasSkippedBody(FD, Skipped)
    ccall((:clang_FunctionDecl_setHasSkippedBody, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, Skipped)
end

function clang_FunctionDecl_willHaveBody(FD)
    ccall((:clang_FunctionDecl_willHaveBody, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setWillHaveBody(FD, V)
    ccall((:clang_FunctionDecl_setWillHaveBody, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, V)
end

function clang_FunctionDecl_isMultiVersion(FD)
    ccall((:clang_FunctionDecl_isMultiVersion, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setIsMultiVersion(FD, V)
    ccall((:clang_FunctionDecl_setIsMultiVersion, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, V)
end

function clang_FunctionDecl_getMultiVersionKind(FD)
    ccall((:clang_FunctionDecl_getMultiVersionKind, libclangex), CXMultiVersionKind, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isCPUDispatchMultiVersion(FD)
    ccall((:clang_FunctionDecl_isCPUDispatchMultiVersion, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isCPUSpecificMultiVersion(FD)
    ccall((:clang_FunctionDecl_isCPUSpecificMultiVersion, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isTargetMultiVersion(FD)
    ccall((:clang_FunctionDecl_isTargetMultiVersion, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setPreviousDeclaration(FD, PrevDecl)
    ccall((:clang_FunctionDecl_setPreviousDeclaration, libclangex), Cvoid, (CXFunctionDecl, CXFunctionDecl), FD, PrevDecl)
end

function clang_FunctionDecl_getCanonicalDecl(FD)
    ccall((:clang_FunctionDecl_getCanonicalDecl, libclangex), CXFunctionDecl, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getBuiltinID(FD)
    ccall((:clang_FunctionDecl_getBuiltinID, libclangex), Cuint, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getNumParams(FD)
    ccall((:clang_FunctionDecl_getNumParams, libclangex), Cuint, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getParamDecl(FD, i)
    ccall((:clang_FunctionDecl_getParamDecl, libclangex), CXParmVarDecl, (CXFunctionDecl, Cuint), FD, i)
end

function clang_FunctionDecl_getMinRequiredArguments(FD)
    ccall((:clang_FunctionDecl_getMinRequiredArguments, libclangex), Cuint, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_hasOneParamOrDefaultArgs(FD)
    ccall((:clang_FunctionDecl_hasOneParamOrDefaultArgs, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getReturnType(FD)
    ccall((:clang_FunctionDecl_getReturnType, libclangex), CXQualType, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getReturnTypeSourceRange(FD)
    ccall((:clang_FunctionDecl_getReturnTypeSourceRange, libclangex), CXSourceRange_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getParametersSourceRange(FD)
    ccall((:clang_FunctionDecl_getParametersSourceRange, libclangex), CXSourceRange_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getDeclaredReturnType(FD)
    ccall((:clang_FunctionDecl_getDeclaredReturnType, libclangex), CXQualType, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getExceptionSpecType(FD)
    ccall((:clang_FunctionDecl_getExceptionSpecType, libclangex), CXExceptionSpecificationType, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getExceptionSpecSourceRange(FD)
    ccall((:clang_FunctionDecl_getExceptionSpecSourceRange, libclangex), CXSourceRange_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getCallResultType(FD)
    ccall((:clang_FunctionDecl_getCallResultType, libclangex), CXQualType, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getStorageClass(FD)
    ccall((:clang_FunctionDecl_getStorageClass, libclangex), CXStorageClass, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setStorageClass(FD, SClass)
    ccall((:clang_FunctionDecl_setStorageClass, libclangex), Cvoid, (CXFunctionDecl, CXStorageClass), FD, SClass)
end

function clang_FunctionDecl_isInlineSpecified(FD)
    ccall((:clang_FunctionDecl_isInlineSpecified, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setInlineSpecified(FD, I)
    ccall((:clang_FunctionDecl_setInlineSpecified, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, I)
end

function clang_FunctionDecl_setImplicitlyInline(FD, I)
    ccall((:clang_FunctionDecl_setImplicitlyInline, libclangex), Cvoid, (CXFunctionDecl, Bool), FD, I)
end

function clang_FunctionDecl_isInlined(FD)
    ccall((:clang_FunctionDecl_isInlined, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isInlineDefinitionExternallyVisible(FD)
    ccall((:clang_FunctionDecl_isInlineDefinitionExternallyVisible, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isMSExternInline(FD)
    ccall((:clang_FunctionDecl_isMSExternInline, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(FD)
    ccall((:clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isStatic(FD)
    ccall((:clang_FunctionDecl_isStatic, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isOverloadedOperator(FD)
    ccall((:clang_FunctionDecl_isOverloadedOperator, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getLiteralIdentifier(FD)
    ccall((:clang_FunctionDecl_getLiteralIdentifier, libclangex), CXIdentifierInfo, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplatedKind(FD)
    ccall((:clang_FunctionDecl_getTemplatedKind, libclangex), CXFunctionDecl_TemplatedKind, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getMemberSpecializationInfo(FD)
    ccall((:clang_FunctionDecl_getMemberSpecializationInfo, libclangex), CXMemberSpecializationInfo, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setInstantiationOfMemberFunction(FD, FD2, TSK)
    ccall((:clang_FunctionDecl_setInstantiationOfMemberFunction, libclangex), Cvoid, (CXFunctionDecl, CXFunctionDecl, CXTemplateSpecializationKind), FD, FD2, TSK)
end

function clang_FunctionDecl_getDescribedFunctionTemplate(FD)
    ccall((:clang_FunctionDecl_getDescribedFunctionTemplate, libclangex), CXFunctionTemplateDecl, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setDescribedFunctionTemplate(FD, Template)
    ccall((:clang_FunctionDecl_setDescribedFunctionTemplate, libclangex), Cvoid, (CXFunctionDecl, CXFunctionTemplateDecl), FD, Template)
end

function clang_FunctionDecl_getInstantiatedFromMemberFunction(FD)
    ccall((:clang_FunctionDecl_getInstantiatedFromMemberFunction, libclangex), CXFunctionDecl, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isFunctionTemplateSpecialization(FD)
    ccall((:clang_FunctionDecl_isFunctionTemplateSpecialization, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateSpecializationInfo(FD)
    ccall((:clang_FunctionDecl_getTemplateSpecializationInfo, libclangex), CXFunctionTemplateSpecializationInfo, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isImplicitlyInstantiable(FD)
    ccall((:clang_FunctionDecl_isImplicitlyInstantiable, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isTemplateInstantiation(FD)
    ccall((:clang_FunctionDecl_isTemplateInstantiation, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateInstantiationPattern(FD, ForDefinition)
    ccall((:clang_FunctionDecl_getTemplateInstantiationPattern, libclangex), CXFunctionDecl, (CXFunctionDecl, Bool), FD, ForDefinition)
end

function clang_FunctionDecl_getPrimaryTemplate(FD)
    ccall((:clang_FunctionDecl_getPrimaryTemplate, libclangex), CXFunctionTemplateDecl, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateSpecializationArgs(FD)
    ccall((:clang_FunctionDecl_getTemplateSpecializationArgs, libclangex), CXTemplateArgumentList, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(FD)
    ccall((:clang_FunctionDecl_getTemplateSpecializationArgsAsWritten, libclangex), CXASTTemplateArgumentListInfo, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getDependentSpecializationInfo(FD)
    ccall((:clang_FunctionDecl_getDependentSpecializationInfo, libclangex), CXDependentFunctionTemplateSpecializationInfo, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateSpecializationKind(FD)
    ccall((:clang_FunctionDecl_getTemplateSpecializationKind, libclangex), CXTemplateSpecializationKind, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(FD)
    ccall((:clang_FunctionDecl_getTemplateSpecializationKindForInstantiation, libclangex), CXTemplateSpecializationKind, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_setTemplateSpecializationKind(FD, TSK, PointOfInstantiation)
    ccall((:clang_FunctionDecl_setTemplateSpecializationKind, libclangex), Cvoid, (CXFunctionDecl, CXTemplateSpecializationKind, CXSourceLocation_), FD, TSK, PointOfInstantiation)
end

function clang_FunctionDecl_getPointOfInstantiation(FD)
    ccall((:clang_FunctionDecl_getPointOfInstantiation, libclangex), CXSourceLocation_, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_isOutOfLine(FD)
    ccall((:clang_FunctionDecl_isOutOfLine, libclangex), Bool, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getMemoryFunctionKind(FD)
    ccall((:clang_FunctionDecl_getMemoryFunctionKind, libclangex), Cuint, (CXFunctionDecl,), FD)
end

function clang_FunctionDecl_getODRHash(FD)
    ccall((:clang_FunctionDecl_getODRHash, libclangex), Cuint, (CXFunctionDecl,), FD)
end

function clang_FieldDecl_Create(C, DC, StartLoc, IdLoc, I, T, TInfo, BW, Mutable, InitStyle)
    ccall((:clang_FieldDecl_Create, libclangex), CXFieldDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXQualType, CXTypeSourceInfo, CXExpr, Bool, CXInClassInitStyle), C, DC, StartLoc, IdLoc, I, T, TInfo, BW, Mutable, InitStyle)
end

function clang_FieldDecl_CreateDeserialized(C, ID)
    ccall((:clang_FieldDecl_CreateDeserialized, libclangex), CXFieldDecl, (CXASTContext, Cuint), C, ID)
end

function clang_FieldDecl_getFieldIndex(FD)
    ccall((:clang_FieldDecl_getFieldIndex, libclangex), Cuint, (CXFieldDecl,), FD)
end

function clang_FieldDecl_isMutable(FD)
    ccall((:clang_FieldDecl_isMutable, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_isBitField(FD)
    ccall((:clang_FieldDecl_isBitField, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_isUnnamedBitfield(FD)
    ccall((:clang_FieldDecl_isUnnamedBitfield, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_isAnonymousStructOrUnion(FD)
    ccall((:clang_FieldDecl_isAnonymousStructOrUnion, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getBitWidth(FD)
    ccall((:clang_FieldDecl_getBitWidth, libclangex), CXExpr, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getBitWidthValue(FD, Ctx)
    ccall((:clang_FieldDecl_getBitWidthValue, libclangex), Cuint, (CXFieldDecl, CXASTContext), FD, Ctx)
end

function clang_FieldDecl_setBitWidth(FD, Width)
    ccall((:clang_FieldDecl_setBitWidth, libclangex), Cvoid, (CXFieldDecl, CXExpr), FD, Width)
end

function clang_FieldDecl_removeBitWidth(FD)
    ccall((:clang_FieldDecl_removeBitWidth, libclangex), Cvoid, (CXFieldDecl,), FD)
end

function clang_FieldDecl_isZeroLengthBitField(FD, Ctx)
    ccall((:clang_FieldDecl_isZeroLengthBitField, libclangex), Bool, (CXFieldDecl, CXASTContext), FD, Ctx)
end

function clang_FieldDecl_isZeroSize(FD, Ctx)
    ccall((:clang_FieldDecl_isZeroSize, libclangex), Bool, (CXFieldDecl, CXASTContext), FD, Ctx)
end

function clang_FieldDecl_getInClassInitStyle(FD)
    ccall((:clang_FieldDecl_getInClassInitStyle, libclangex), CXInClassInitStyle, (CXFieldDecl,), FD)
end

function clang_FieldDecl_hasInClassInitializer(FD)
    ccall((:clang_FieldDecl_hasInClassInitializer, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getInClassInitializer(FD)
    ccall((:clang_FieldDecl_getInClassInitializer, libclangex), CXExpr, (CXFieldDecl,), FD)
end

function clang_FieldDecl_setInClassInitializer(FD, Init)
    ccall((:clang_FieldDecl_setInClassInitializer, libclangex), Cvoid, (CXFieldDecl, CXExpr), FD, Init)
end

function clang_FieldDecl_removeInClassInitializer(FD)
    ccall((:clang_FieldDecl_removeInClassInitializer, libclangex), Cvoid, (CXFieldDecl,), FD)
end

function clang_FieldDecl_hasCapturedVLAType(FD)
    ccall((:clang_FieldDecl_hasCapturedVLAType, libclangex), Bool, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getCapturedVLAType(FD)
    ccall((:clang_FieldDecl_getCapturedVLAType, libclangex), CXVariableArrayType, (CXFieldDecl,), FD)
end

function clang_FieldDecl_setCapturedVLAType(FD, VLAType)
    ccall((:clang_FieldDecl_setCapturedVLAType, libclangex), Cvoid, (CXFieldDecl, CXVariableArrayType), FD, VLAType)
end

function clang_FieldDecl_getParent(FD)
    ccall((:clang_FieldDecl_getParent, libclangex), CXRecordDecl, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getSourceRange(FD)
    ccall((:clang_FieldDecl_getSourceRange, libclangex), CXSourceRange_, (CXFieldDecl,), FD)
end

function clang_FieldDecl_getCanonicalDecl(FD)
    ccall((:clang_FieldDecl_getCanonicalDecl, libclangex), CXFieldDecl, (CXFieldDecl,), FD)
end

function clang_EnumConstantDecl_Create(C, DC, L, Id, T, E, V)
    ccall((:clang_EnumConstantDecl_Create, libclangex), CXEnumConstantDecl, (CXASTContext, CXEnumDecl, CXSourceLocation_, CXIdentifierInfo, CXQualType, CXExpr, LLVMGenericValueRef), C, DC, L, Id, T, E, V)
end

function clang_EnumConstantDecl_CreateDeserialized(C, ID)
    ccall((:clang_EnumConstantDecl_CreateDeserialized, libclangex), CXEnumConstantDecl, (CXASTContext, Cuint), C, ID)
end

function clang_EnumConstantDecl_getInitExpr(ECD)
    ccall((:clang_EnumConstantDecl_getInitExpr, libclangex), CXExpr, (CXEnumConstantDecl,), ECD)
end

function clang_EnumConstantDecl_setInitExpr(ECD, E)
    ccall((:clang_EnumConstantDecl_setInitExpr, libclangex), Cvoid, (CXEnumConstantDecl, CXExpr), ECD, E)
end

function clang_EnumConstantDecl_getSourceRange(ECD)
    ccall((:clang_EnumConstantDecl_getSourceRange, libclangex), CXSourceRange_, (CXEnumConstantDecl,), ECD)
end

function clang_EnumConstantDecl_getCanonicalDecl(ECD)
    ccall((:clang_EnumConstantDecl_getCanonicalDecl, libclangex), CXEnumConstantDecl, (CXEnumConstantDecl,), ECD)
end

function clang_IndirectFieldDecl_CreateDeserialized(C, ID)
    ccall((:clang_IndirectFieldDecl_CreateDeserialized, libclangex), CXIndirectFieldDecl, (CXASTContext, Cuint), C, ID)
end

function clang_IndirectFieldDecl_getChainingSize(IFD)
    ccall((:clang_IndirectFieldDecl_getChainingSize, libclangex), Cuint, (CXIndirectFieldDecl,), IFD)
end

function clang_IndirectFieldDecl_getAnonField(IFD)
    ccall((:clang_IndirectFieldDecl_getAnonField, libclangex), CXFieldDecl, (CXIndirectFieldDecl,), IFD)
end

function clang_IndirectFieldDecl_getVarDecl(IFD)
    ccall((:clang_IndirectFieldDecl_getVarDecl, libclangex), CXVarDecl, (CXIndirectFieldDecl,), IFD)
end

function clang_IndirectFieldDecl_getCanonicalDecl(IFD)
    ccall((:clang_IndirectFieldDecl_getCanonicalDecl, libclangex), CXIndirectFieldDecl, (CXIndirectFieldDecl,), IFD)
end

function clang_TypeDecl_getTypeForDecl(TD)
    ccall((:clang_TypeDecl_getTypeForDecl, libclangex), CXType_, (CXTypeDecl,), TD)
end

function clang_TypeDecl_setTypeForDecl(TD, Ty)
    ccall((:clang_TypeDecl_setTypeForDecl, libclangex), Cvoid, (CXTypeDecl, CXType_), TD, Ty)
end

function clang_TypeDecl_getBeginLoc(TD)
    ccall((:clang_TypeDecl_getBeginLoc, libclangex), CXSourceLocation_, (CXTypeDecl,), TD)
end

function clang_TypeDecl_setLocStart(TD, Loc)
    ccall((:clang_TypeDecl_setLocStart, libclangex), Cvoid, (CXTypeDecl, CXSourceLocation_), TD, Loc)
end

function clang_TypedefNameDecl_isModed(TND)
    ccall((:clang_TypedefNameDecl_isModed, libclangex), Bool, (CXTypedefNameDecl,), TND)
end

function clang_TypedefNameDecl_getTypeSourceInfo(TND)
    ccall((:clang_TypedefNameDecl_getTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXTypedefNameDecl,), TND)
end

function clang_TypedefNameDecl_getUnderlyingType(TND)
    ccall((:clang_TypedefNameDecl_getUnderlyingType, libclangex), CXQualType, (CXTypedefNameDecl,), TND)
end

function clang_TypedefNameDecl_setTypeSourceInfo(TND, newType)
    ccall((:clang_TypedefNameDecl_setTypeSourceInfo, libclangex), Cvoid, (CXTypedefNameDecl, CXTypeSourceInfo), TND, newType)
end

function clang_TypedefNameDecl_setModedTypeSourceInfo(TND, unmodedTSI, modedTy)
    ccall((:clang_TypedefNameDecl_setModedTypeSourceInfo, libclangex), Cvoid, (CXTypedefNameDecl, CXTypeSourceInfo, CXQualType), TND, unmodedTSI, modedTy)
end

function clang_TypedefNameDecl_getCanonicalDecl(TND)
    ccall((:clang_TypedefNameDecl_getCanonicalDecl, libclangex), CXTypedefNameDecl, (CXTypedefNameDecl,), TND)
end

function clang_TypedefNameDecl_getAnonDeclWithTypedefName(TND, AnyRedecl)
    ccall((:clang_TypedefNameDecl_getAnonDeclWithTypedefName, libclangex), CXTagDecl, (CXTypedefNameDecl, Bool), TND, AnyRedecl)
end

function clang_TypedefNameDecl_isTransparentTag(TND)
    ccall((:clang_TypedefNameDecl_isTransparentTag, libclangex), Bool, (CXTypedefNameDecl,), TND)
end

function clang_TypedefDecl_Create(C, DC, StartLoc, IdLoc, Id, TInfo)
    ccall((:clang_TypedefDecl_Create, libclangex), CXTypedefDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXTypeSourceInfo), C, DC, StartLoc, IdLoc, Id, TInfo)
end

function clang_TypedefDecl_CreateDeserialized(C, ID)
    ccall((:clang_TypedefDecl_CreateDeserialized, libclangex), CXTypedefDecl, (CXASTContext, Cuint), C, ID)
end

function clang_TypedefDecl_getSourceRange(TD)
    ccall((:clang_TypedefDecl_getSourceRange, libclangex), CXSourceRange_, (CXTypedefDecl,), TD)
end

function clang_TypeAliasDecl_Create(C, DC, StartLoc, IdLoc, Id, TInfo)
    ccall((:clang_TypeAliasDecl_Create, libclangex), CXTypeAliasDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXTypeSourceInfo), C, DC, StartLoc, IdLoc, Id, TInfo)
end

function clang_TypeAliasDecl_CreateDeserialized(C, ID)
    ccall((:clang_TypeAliasDecl_CreateDeserialized, libclangex), CXTypeAliasDecl, (CXASTContext, Cuint), C, ID)
end

function clang_TypeAliasDecl_getSourceRange(TAD)
    ccall((:clang_TypeAliasDecl_getSourceRange, libclangex), CXSourceRange_, (CXTypeAliasDecl,), TAD)
end

function clang_TypeAliasDecl_getDescribedAliasTemplate(TAD)
    ccall((:clang_TypeAliasDecl_getDescribedAliasTemplate, libclangex), CXTypeAliasTemplateDecl, (CXTypeAliasDecl,), TAD)
end

function clang_TypeAliasDecl_setDescribedAliasTemplate(TAD, TAT)
    ccall((:clang_TypeAliasDecl_setDescribedAliasTemplate, libclangex), Cvoid, (CXTypeAliasDecl, CXTypeAliasTemplateDecl), TAD, TAT)
end

function clang_TagDecl_getBraceRange(TD)
    ccall((:clang_TagDecl_getBraceRange, libclangex), CXSourceRange_, (CXTagDecl,), TD)
end

function clang_TagDecl_setBraceRange(TD, R)
    ccall((:clang_TagDecl_setBraceRange, libclangex), Cvoid, (CXTagDecl, CXSourceRange_), TD, R)
end

function clang_TagDecl_getInnerLocStart(TD)
    ccall((:clang_TagDecl_getInnerLocStart, libclangex), CXSourceLocation_, (CXTagDecl,), TD)
end

function clang_TagDecl_getOuterLocStart(TD)
    ccall((:clang_TagDecl_getOuterLocStart, libclangex), CXSourceLocation_, (CXTagDecl,), TD)
end

function clang_TagDecl_getSourceRange(TD)
    ccall((:clang_TagDecl_getSourceRange, libclangex), CXSourceRange_, (CXTagDecl,), TD)
end

function clang_TagDecl_getCanonicalDecl(TD)
    ccall((:clang_TagDecl_getCanonicalDecl, libclangex), CXTagDecl, (CXTagDecl,), TD)
end

function clang_TagDecl_isThisDeclarationADefinition(TD)
    ccall((:clang_TagDecl_isThisDeclarationADefinition, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isCompleteDefinition(TD)
    ccall((:clang_TagDecl_isCompleteDefinition, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_setCompleteDefinition(TD, V)
    ccall((:clang_TagDecl_setCompleteDefinition, libclangex), Cvoid, (CXTagDecl, Bool), TD, V)
end

function clang_TagDecl_isCompleteDefinitionRequired(TD)
    ccall((:clang_TagDecl_isCompleteDefinitionRequired, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_setCompleteDefinitionRequired(TD, V)
    ccall((:clang_TagDecl_setCompleteDefinitionRequired, libclangex), Cvoid, (CXTagDecl, Bool), TD, V)
end

function clang_TagDecl_isBeingDefined(TD)
    ccall((:clang_TagDecl_isBeingDefined, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isEmbeddedInDeclarator(TD)
    ccall((:clang_TagDecl_isEmbeddedInDeclarator, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_setEmbeddedInDeclarator(TD, isInDeclarator)
    ccall((:clang_TagDecl_setEmbeddedInDeclarator, libclangex), Cvoid, (CXTagDecl, Bool), TD, isInDeclarator)
end

function clang_TagDecl_isFreeStanding(TD)
    ccall((:clang_TagDecl_isFreeStanding, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_setFreeStanding(TD, isFreeStanding)
    ccall((:clang_TagDecl_setFreeStanding, libclangex), Cvoid, (CXTagDecl, Bool), TD, isFreeStanding)
end

function clang_TagDecl_mayHaveOutOfDateDef(TD)
    ccall((:clang_TagDecl_mayHaveOutOfDateDef, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isDependentType(TD)
    ccall((:clang_TagDecl_isDependentType, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_startDefinition(TD)
    ccall((:clang_TagDecl_startDefinition, libclangex), Cvoid, (CXTagDecl,), TD)
end

function clang_TagDecl_getDefinition(TD)
    ccall((:clang_TagDecl_getDefinition, libclangex), CXTagDecl, (CXTagDecl,), TD)
end

function clang_TagDecl_getKindName(TD)
    ccall((:clang_TagDecl_getKindName, libclangex), Ptr{Cchar}, (CXTagDecl,), TD)
end

function clang_TagDecl_getTagKind(TD)
    ccall((:clang_TagDecl_getTagKind, libclangex), CXTagTypeKind, (CXTagDecl,), TD)
end

function clang_TagDecl_setTagKind(TD, TK)
    ccall((:clang_TagDecl_setTagKind, libclangex), Cvoid, (CXTagDecl, CXTagTypeKind), TD, TK)
end

function clang_TagDecl_isStruct(TD)
    ccall((:clang_TagDecl_isStruct, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isInterface(TD)
    ccall((:clang_TagDecl_isInterface, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isClass(TD)
    ccall((:clang_TagDecl_isClass, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isUnion(TD)
    ccall((:clang_TagDecl_isUnion, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isEnum(TD)
    ccall((:clang_TagDecl_isEnum, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_hasNameForLinkage(TD)
    ccall((:clang_TagDecl_hasNameForLinkage, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_getTypedefNameForAnonDecl(TD)
    ccall((:clang_TagDecl_getTypedefNameForAnonDecl, libclangex), CXTypedefNameDecl, (CXTagDecl,), TD)
end

function clang_TagDecl_setTypedefNameForAnonDecl(TD, TDD)
    ccall((:clang_TagDecl_setTypedefNameForAnonDecl, libclangex), Cvoid, (CXTagDecl, CXTypedefNameDecl), TD, TDD)
end

function clang_TagDecl_getQualifier(TD)
    ccall((:clang_TagDecl_getQualifier, libclangex), CXNestedNameSpecifier, (CXTagDecl,), TD)
end

function clang_TagDecl_getNumTemplateParameterLists(TD)
    ccall((:clang_TagDecl_getNumTemplateParameterLists, libclangex), Cuint, (CXTagDecl,), TD)
end

function clang_TagDecl_getTemplateParameterList(TD, i)
    ccall((:clang_TagDecl_getTemplateParameterList, libclangex), CXTemplateParameterList, (CXTagDecl, Cuint), TD, i)
end

function clang_TagDecl_castToDeclContext(TD)
    ccall((:clang_TagDecl_castToDeclContext, libclangex), CXDeclContext, (CXTagDecl,), TD)
end

function clang_EnumDecl_Create(C, DC, StartLoc, IdLoc, Id, PrevDecl, IsScoped, IsScopedUsingClassTag, IsFixed)
    ccall((:clang_EnumDecl_Create, libclangex), CXEnumDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXEnumDecl, Bool, Bool, Bool), C, DC, StartLoc, IdLoc, Id, PrevDecl, IsScoped, IsScopedUsingClassTag, IsFixed)
end

function clang_EnumDecl_CreateDeserialized(C, ID)
    ccall((:clang_EnumDecl_CreateDeserialized, libclangex), CXEnumDecl, (CXASTContext, Cuint), C, ID)
end

function clang_EnumDecl_setScoped(ED, Scoped)
    ccall((:clang_EnumDecl_setScoped, libclangex), Cvoid, (CXEnumDecl, Bool), ED, Scoped)
end

function clang_EnumDecl_setScopedUsingClassTag(ED, ScopedUCT)
    ccall((:clang_EnumDecl_setScopedUsingClassTag, libclangex), Cvoid, (CXEnumDecl, Bool), ED, ScopedUCT)
end

function clang_EnumDecl_setFixed(ED, Fixed)
    ccall((:clang_EnumDecl_setFixed, libclangex), Cvoid, (CXEnumDecl, Bool), ED, Fixed)
end

function clang_EnumDecl_getCanonicalDecl(ED)
    ccall((:clang_EnumDecl_getCanonicalDecl, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getPreviousDecl(ED)
    ccall((:clang_EnumDecl_getPreviousDecl, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getMostRecentDecl(ED)
    ccall((:clang_EnumDecl_getMostRecentDecl, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getDefinition(ED)
    ccall((:clang_EnumDecl_getDefinition, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_completeDefinition(ED, NewType, PromotionType, NumPositiveBits, NumNegativeBits)
    ccall((:clang_EnumDecl_completeDefinition, libclangex), Cvoid, (CXEnumDecl, CXQualType, CXQualType, Cuint, Cuint), ED, NewType, PromotionType, NumPositiveBits, NumNegativeBits)
end

function clang_EnumDecl_getPromotionType(ED)
    ccall((:clang_EnumDecl_getPromotionType, libclangex), CXQualType, (CXEnumDecl,), ED)
end

function clang_EnumDecl_setPromotionType(ED, T)
    ccall((:clang_EnumDecl_setPromotionType, libclangex), Cvoid, (CXEnumDecl, CXQualType), ED, T)
end

function clang_EnumDecl_getIntegerType(ED)
    ccall((:clang_EnumDecl_getIntegerType, libclangex), CXQualType, (CXEnumDecl,), ED)
end

function clang_EnumDecl_setIntegerType(ED, T)
    ccall((:clang_EnumDecl_setIntegerType, libclangex), Cvoid, (CXEnumDecl, CXQualType), ED, T)
end

function clang_EnumDecl_setIntegerTypeSourceInfo(ED, TInfo)
    ccall((:clang_EnumDecl_setIntegerTypeSourceInfo, libclangex), Cvoid, (CXEnumDecl, CXTypeSourceInfo), ED, TInfo)
end

function clang_EnumDecl_getIntegerTypeSourceInfo(ED)
    ccall((:clang_EnumDecl_getIntegerTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getIntegerTypeRange(ED)
    ccall((:clang_EnumDecl_getIntegerTypeRange, libclangex), CXSourceRange_, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getNumPositiveBits(ED)
    ccall((:clang_EnumDecl_getNumPositiveBits, libclangex), Cuint, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getNumNegativeBits(ED)
    ccall((:clang_EnumDecl_getNumNegativeBits, libclangex), Cuint, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isScoped(ED)
    ccall((:clang_EnumDecl_isScoped, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isScopedUsingClassTag(ED)
    ccall((:clang_EnumDecl_isScopedUsingClassTag, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isFixed(ED)
    ccall((:clang_EnumDecl_isFixed, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getODRHash(ED)
    ccall((:clang_EnumDecl_getODRHash, libclangex), Cuint, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isComplete(ED)
    ccall((:clang_EnumDecl_isComplete, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isClosed(ED)
    ccall((:clang_EnumDecl_isClosed, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isClosedFlag(ED)
    ccall((:clang_EnumDecl_isClosedFlag, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_isClosedNonFlag(ED)
    ccall((:clang_EnumDecl_isClosedNonFlag, libclangex), Bool, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getTemplateInstantiationPattern(ED)
    ccall((:clang_EnumDecl_getTemplateInstantiationPattern, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getInstantiatedFromMemberEnum(ED)
    ccall((:clang_EnumDecl_getInstantiatedFromMemberEnum, libclangex), CXEnumDecl, (CXEnumDecl,), ED)
end

function clang_EnumDecl_getTemplateSpecializationKind(ED)
    ccall((:clang_EnumDecl_getTemplateSpecializationKind, libclangex), CXTemplateSpecializationKind, (CXEnumDecl,), ED)
end

function clang_EnumDecl_setTemplateSpecializationKind(ED, TSK, PointOfInstantiation)
    ccall((:clang_EnumDecl_setTemplateSpecializationKind, libclangex), Cvoid, (CXEnumDecl, CXTemplateSpecializationKind, CXSourceLocation_), ED, TSK, PointOfInstantiation)
end

function clang_EnumDecl_getMemberSpecializationInfo(ED)
    ccall((:clang_EnumDecl_getMemberSpecializationInfo, libclangex), CXMemberSpecializationInfo, (CXEnumDecl,), ED)
end

function clang_EnumDecl_setInstantiationOfMemberEnum(ED, ED2, TSK)
    ccall((:clang_EnumDecl_setInstantiationOfMemberEnum, libclangex), Cvoid, (CXEnumDecl, CXEnumDecl, CXTemplateSpecializationKind), ED, ED2, TSK)
end

@enum CXRecordDecl_ArgPassingKind::UInt32 begin
    CXRecordDecl_APK_CanPassInRegs = 0x0000000000000000
    CXRecordDecl_APK_CannotPassInRegs = 0x0000000000000001
    CXRecordDecl_APK_CanNeverPassInRegs = 0x0000000000000002
end

function clang_RecordDecl_Create(C, TK, DC, StartLoc, IdLoc, Id, PrevDecl)
    ccall((:clang_RecordDecl_Create, libclangex), CXRecordDecl, (CXASTContext, CXTagTypeKind, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXRecordDecl), C, TK, DC, StartLoc, IdLoc, Id, PrevDecl)
end

function clang_RecordDecl_CreateDeserialized(C, ID)
    ccall((:clang_RecordDecl_CreateDeserialized, libclangex), CXRecordDecl, (CXASTContext, Cuint), C, ID)
end

function clang_RecordDecl_getPreviousDecl(RD)
    ccall((:clang_RecordDecl_getPreviousDecl, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_getMostRecentDecl(RD)
    ccall((:clang_RecordDecl_getMostRecentDecl, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_hasFlexibleArrayMember(RD)
    ccall((:clang_RecordDecl_hasFlexibleArrayMember, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasFlexibleArrayMember(RD, V)
    ccall((:clang_RecordDecl_setHasFlexibleArrayMember, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_isAnonymousStructOrUnion(RD)
    ccall((:clang_RecordDecl_isAnonymousStructOrUnion, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setAnonymousStructOrUnion(RD, Anon)
    ccall((:clang_RecordDecl_setAnonymousStructOrUnion, libclangex), Cvoid, (CXRecordDecl, Bool), RD, Anon)
end

function clang_RecordDecl_hasObjectMember(RD)
    ccall((:clang_RecordDecl_hasObjectMember, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasObjectMember(RD, val)
    ccall((:clang_RecordDecl_setHasObjectMember, libclangex), Cvoid, (CXRecordDecl, Bool), RD, val)
end

function clang_RecordDecl_hasVolatileMember(RD)
    ccall((:clang_RecordDecl_hasVolatileMember, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasVolatileMember(RD, val)
    ccall((:clang_RecordDecl_setHasVolatileMember, libclangex), Cvoid, (CXRecordDecl, Bool), RD, val)
end

function clang_RecordDecl_hasLoadedFieldsFromExternalStorage(RD)
    ccall((:clang_RecordDecl_hasLoadedFieldsFromExternalStorage, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(RD, val)
    ccall((:clang_RecordDecl_setHasLoadedFieldsFromExternalStorage, libclangex), Cvoid, (CXRecordDecl, Bool), RD, val)
end

function clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(RD)
    ccall((:clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(RD, V)
    ccall((:clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_isNonTrivialToPrimitiveCopy(RD)
    ccall((:clang_RecordDecl_isNonTrivialToPrimitiveCopy, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setNonTrivialToPrimitiveCopy(RD, V)
    ccall((:clang_RecordDecl_setNonTrivialToPrimitiveCopy, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_isNonTrivialToPrimitiveDestroy(RD)
    ccall((:clang_RecordDecl_isNonTrivialToPrimitiveDestroy, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setNonTrivialToPrimitiveDestroy(RD, V)
    ccall((:clang_RecordDecl_setNonTrivialToPrimitiveDestroy, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(RD)
    ccall((:clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(RD, V)
    ccall((:clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(RD)
    ccall((:clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(RD, V)
    ccall((:clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(RD)
    ccall((:clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(RD, V)
    ccall((:clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_canPassInRegisters(RD)
    ccall((:clang_RecordDecl_canPassInRegisters, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_getArgPassingRestrictions(RD)
    ccall((:clang_RecordDecl_getArgPassingRestrictions, libclangex), CXRecordDecl_ArgPassingKind, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setArgPassingRestrictions(RD, Kind)
    ccall((:clang_RecordDecl_setArgPassingRestrictions, libclangex), Cvoid, (CXRecordDecl, CXRecordDecl_ArgPassingKind), RD, Kind)
end

function clang_RecordDecl_isParamDestroyedInCallee(RD)
    ccall((:clang_RecordDecl_isParamDestroyedInCallee, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setParamDestroyedInCallee(RD, V)
    ccall((:clang_RecordDecl_setParamDestroyedInCallee, libclangex), Cvoid, (CXRecordDecl, Bool), RD, V)
end

function clang_RecordDecl_isInjectedClassName(RD)
    ccall((:clang_RecordDecl_isInjectedClassName, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isLambda(RD)
    ccall((:clang_RecordDecl_isLambda, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isCapturedRecord(RD)
    ccall((:clang_RecordDecl_isCapturedRecord, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_setCapturedRecord(RD)
    ccall((:clang_RecordDecl_setCapturedRecord, libclangex), Cvoid, (CXRecordDecl,), RD)
end

function clang_RecordDecl_getDefinition(RD)
    ccall((:clang_RecordDecl_getDefinition, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isOrContainsUnion(RD)
    ccall((:clang_RecordDecl_isOrContainsUnion, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isMsStruct(RD, C)
    ccall((:clang_RecordDecl_isMsStruct, libclangex), Bool, (CXRecordDecl, CXASTContext), RD, C)
end

function clang_RecordDecl_mayInsertExtraPadding(RD, EmitRemark)
    ccall((:clang_RecordDecl_mayInsertExtraPadding, libclangex), Bool, (CXRecordDecl, Bool), RD, EmitRemark)
end

function clang_RecordDecl_findFirstNamedDataMember(RD)
    ccall((:clang_RecordDecl_findFirstNamedDataMember, libclangex), CXFieldDecl, (CXRecordDecl,), RD)
end

function clang_FileScopeAsmDecl_Create(C, DC, Str, AsmLoc, RParenLoc)
    ccall((:clang_FileScopeAsmDecl_Create, libclangex), CXFileScopeAsmDecl, (CXASTContext, CXDeclContext, CXStringLiteral, CXSourceLocation_, CXSourceLocation_), C, DC, Str, AsmLoc, RParenLoc)
end

function clang_FileScopeAsmDecl_CreateDeserialized(C, ID)
    ccall((:clang_FileScopeAsmDecl_CreateDeserialized, libclangex), CXFileScopeAsmDecl, (CXASTContext, Cuint), C, ID)
end

function clang_FileScopeAsmDecl_getAsmLoc(FSAD)
    ccall((:clang_FileScopeAsmDecl_getAsmLoc, libclangex), CXSourceLocation_, (CXFileScopeAsmDecl,), FSAD)
end

function clang_FileScopeAsmDecl_getRParenLoc(FSAD)
    ccall((:clang_FileScopeAsmDecl_getRParenLoc, libclangex), CXSourceLocation_, (CXFileScopeAsmDecl,), FSAD)
end

function clang_FileScopeAsmDecl_setRParenLoc(FSAD, L)
    ccall((:clang_FileScopeAsmDecl_setRParenLoc, libclangex), Cvoid, (CXFileScopeAsmDecl, CXSourceLocation_), FSAD, L)
end

function clang_FileScopeAsmDecl_getSourceRange(FSAD)
    ccall((:clang_FileScopeAsmDecl_getSourceRange, libclangex), CXSourceRange_, (CXFileScopeAsmDecl,), FSAD)
end

function clang_FileScopeAsmDecl_getAsmString(FSAD)
    ccall((:clang_FileScopeAsmDecl_getAsmString, libclangex), CXStringLiteral, (CXFileScopeAsmDecl,), FSAD)
end

function clang_FileScopeAsmDecl_setAsmString(FSAD, Asm)
    ccall((:clang_FileScopeAsmDecl_setAsmString, libclangex), Cvoid, (CXFileScopeAsmDecl, CXStringLiteral), FSAD, Asm)
end

function clang_BlockDecl_Create(C, DC, L)
    ccall((:clang_BlockDecl_Create, libclangex), CXBlockDecl, (CXASTContext, CXDeclContext, CXSourceLocation_), C, DC, L)
end

function clang_BlockDecl_CreateDeserialized(C, ID)
    ccall((:clang_BlockDecl_CreateDeserialized, libclangex), CXBlockDecl, (CXASTContext, Cuint), C, ID)
end

function clang_BlockDecl_getCaretLocation(BD)
    ccall((:clang_BlockDecl_getCaretLocation, libclangex), CXSourceLocation_, (CXBlockDecl,), BD)
end

function clang_BlockDecl_isVariadic(BD)
    ccall((:clang_BlockDecl_isVariadic, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setBody(BD, B)
    ccall((:clang_BlockDecl_setBody, libclangex), Cvoid, (CXBlockDecl, CXCompoundStmt), BD, B)
end

function clang_BlockDecl_setSignatureAsWritten(BD, Sig)
    ccall((:clang_BlockDecl_setSignatureAsWritten, libclangex), Cvoid, (CXBlockDecl, CXTypeSourceInfo), BD, Sig)
end

function clang_BlockDecl_getSignatureAsWritten(BD)
    ccall((:clang_BlockDecl_getSignatureAsWritten, libclangex), CXTypeSourceInfo, (CXBlockDecl,), BD)
end

function clang_BlockDecl_getNumParams(BD)
    ccall((:clang_BlockDecl_getNumParams, libclangex), Cuint, (CXBlockDecl,), BD)
end

function clang_BlockDecl_getParamDecl(BD, i)
    ccall((:clang_BlockDecl_getParamDecl, libclangex), CXParmVarDecl, (CXBlockDecl, Cuint), BD, i)
end

function clang_BlockDecl_hasCaptures(BD)
    ccall((:clang_BlockDecl_hasCaptures, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_getNumCaptures(BD)
    ccall((:clang_BlockDecl_getNumCaptures, libclangex), Cuint, (CXBlockDecl,), BD)
end

function clang_BlockDecl_capturesCXXThis(BD)
    ccall((:clang_BlockDecl_capturesCXXThis, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setCapturesCXXThis(BD, B)
    ccall((:clang_BlockDecl_setCapturesCXXThis, libclangex), Cvoid, (CXBlockDecl, Bool), BD, B)
end

function clang_BlockDecl_blockMissingReturnType(BD)
    ccall((:clang_BlockDecl_blockMissingReturnType, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setBlockMissingReturnType(BD, val)
    ccall((:clang_BlockDecl_setBlockMissingReturnType, libclangex), Cvoid, (CXBlockDecl, Bool), BD, val)
end

function clang_BlockDecl_isConversionFromLambda(BD)
    ccall((:clang_BlockDecl_isConversionFromLambda, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setIsConversionFromLambda(BD, val)
    ccall((:clang_BlockDecl_setIsConversionFromLambda, libclangex), Cvoid, (CXBlockDecl, Bool), BD, val)
end

function clang_BlockDecl_doesNotEscape(BD)
    ccall((:clang_BlockDecl_doesNotEscape, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setDoesNotEscape(BD, B)
    ccall((:clang_BlockDecl_setDoesNotEscape, libclangex), Cvoid, (CXBlockDecl, Bool), BD, B)
end

function clang_BlockDecl_canAvoidCopyToHeap(BD)
    ccall((:clang_BlockDecl_canAvoidCopyToHeap, libclangex), Bool, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setCanAvoidCopyToHeap(BD, B)
    ccall((:clang_BlockDecl_setCanAvoidCopyToHeap, libclangex), Cvoid, (CXBlockDecl, Bool), BD, B)
end

function clang_BlockDecl_capturesVariable(BD, var)
    ccall((:clang_BlockDecl_capturesVariable, libclangex), Bool, (CXBlockDecl, CXVarDecl), BD, var)
end

function clang_BlockDecl_getBlockManglingNumber(BD)
    ccall((:clang_BlockDecl_getBlockManglingNumber, libclangex), Cuint, (CXBlockDecl,), BD)
end

function clang_BlockDecl_getBlockManglingContextDecl(BD)
    ccall((:clang_BlockDecl_getBlockManglingContextDecl, libclangex), CXDecl, (CXBlockDecl,), BD)
end

function clang_BlockDecl_setBlockMangling(BD, Number, Ctx)
    ccall((:clang_BlockDecl_setBlockMangling, libclangex), Cvoid, (CXBlockDecl, Cuint, CXDecl), BD, Number, Ctx)
end

function clang_BlockDecl_getSourceRange(BD)
    ccall((:clang_BlockDecl_getSourceRange, libclangex), CXSourceRange_, (CXBlockDecl,), BD)
end

function clang_CapturedDecl_Create(C, DC, NumParams)
    ccall((:clang_CapturedDecl_Create, libclangex), CXCapturedDecl, (CXASTContext, CXDeclContext, Cuint), C, DC, NumParams)
end

function clang_CapturedDecl_CreateDeserialized(C, ID, NumParams)
    ccall((:clang_CapturedDecl_CreateDeserialized, libclangex), CXCapturedDecl, (CXASTContext, Cuint, Cuint), C, ID, NumParams)
end

function clang_CapturedDecl_getBody(CD)
    ccall((:clang_CapturedDecl_getBody, libclangex), CXStmt, (CXCapturedDecl,), CD)
end

function clang_CapturedDecl_setBody(CD, B)
    ccall((:clang_CapturedDecl_setBody, libclangex), Cvoid, (CXCapturedDecl, CXStmt), CD, B)
end

function clang_CapturedDecl_isNothrow(CD)
    ccall((:clang_CapturedDecl_isNothrow, libclangex), Bool, (CXCapturedDecl,), CD)
end

function clang_CapturedDecl_setNothrow(CD, Nothrow)
    ccall((:clang_CapturedDecl_setNothrow, libclangex), Cvoid, (CXCapturedDecl, Bool), CD, Nothrow)
end

function clang_CapturedDecl_getNumParams(CD)
    ccall((:clang_CapturedDecl_getNumParams, libclangex), Cuint, (CXCapturedDecl,), CD)
end

function clang_CapturedDecl_getParam(CD, i)
    ccall((:clang_CapturedDecl_getParam, libclangex), CXImplicitParamDecl, (CXCapturedDecl, Cuint), CD, i)
end

function clang_CapturedDecl_setParam(CD, i, P)
    ccall((:clang_CapturedDecl_setParam, libclangex), Cvoid, (CXCapturedDecl, Cuint, CXImplicitParamDecl), CD, i, P)
end

function clang_CapturedDecl_getContextParam(CD)
    ccall((:clang_CapturedDecl_getContextParam, libclangex), CXImplicitParamDecl, (CXCapturedDecl,), CD)
end

function clang_CapturedDecl_setContextParam(CD, i, P)
    ccall((:clang_CapturedDecl_setContextParam, libclangex), Cvoid, (CXCapturedDecl, Cuint, CXImplicitParamDecl), CD, i, P)
end

function clang_CapturedDecl_getContextParamPosition(CD)
    ccall((:clang_CapturedDecl_getContextParamPosition, libclangex), Cuint, (CXCapturedDecl,), CD)
end

function clang_ImportDecl_CreateImplicit(C, DC, StartLoc, Imported, EndLoc)
    ccall((:clang_ImportDecl_CreateImplicit, libclangex), CXImportDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXModule, CXSourceLocation_), C, DC, StartLoc, Imported, EndLoc)
end

function clang_ImportDecl_CreateDeserialized(C, ID, NumLocations)
    ccall((:clang_ImportDecl_CreateDeserialized, libclangex), CXImportDecl, (CXASTContext, Cuint, Cuint), C, ID, NumLocations)
end

function clang_ImportDecl_getImportedModule(ID)
    ccall((:clang_ImportDecl_getImportedModule, libclangex), CXModule, (CXImportDecl,), ID)
end

function clang_ImportDecl_getSourceRange(ID)
    ccall((:clang_ImportDecl_getSourceRange, libclangex), CXSourceRange_, (CXImportDecl,), ID)
end

function clang_ExportDecl_Create(C, DC, ExportLoc)
    ccall((:clang_ExportDecl_Create, libclangex), CXExportDecl, (CXASTContext, CXDeclContext, CXSourceLocation_), C, DC, ExportLoc)
end

function clang_ExportDecl_CreateDeserialized(C, ID)
    ccall((:clang_ExportDecl_CreateDeserialized, libclangex), CXExportDecl, (CXASTContext, Cuint), C, ID)
end

function clang_ExportDecl_getExportLoc(ED)
    ccall((:clang_ExportDecl_getExportLoc, libclangex), CXSourceLocation_, (CXExportDecl,), ED)
end

function clang_ExportDecl_getRBraceLoc(ED)
    ccall((:clang_ExportDecl_getRBraceLoc, libclangex), CXSourceLocation_, (CXExportDecl,), ED)
end

function clang_ExportDecl_setRBraceLoc(ED, L)
    ccall((:clang_ExportDecl_setRBraceLoc, libclangex), Cvoid, (CXExportDecl, CXSourceLocation_), ED, L)
end

function clang_ExportDecl_hasBraces(ED)
    ccall((:clang_ExportDecl_hasBraces, libclangex), Bool, (CXExportDecl,), ED)
end

function clang_ExportDecl_getEndLoc(ED)
    ccall((:clang_ExportDecl_getEndLoc, libclangex), CXSourceLocation_, (CXExportDecl,), ED)
end

function clang_ExportDecl_getSourceRange(ED)
    ccall((:clang_ExportDecl_getSourceRange, libclangex), CXSourceRange_, (CXExportDecl,), ED)
end

function clang_EmptyDecl_Create(C, DC, L)
    ccall((:clang_EmptyDecl_Create, libclangex), CXEmptyDecl, (CXASTContext, CXDeclContext, CXSourceLocation_), C, DC, L)
end

function clang_EmptyDecl_CreateDeserialized(C, ID)
    ccall((:clang_EmptyDecl_CreateDeserialized, libclangex), CXEmptyDecl, (CXASTContext, Cuint), C, ID)
end

function clang_TemplateParameterList_getParam(TPL, Idx)
    ccall((:clang_TemplateParameterList_getParam, libclangex), CXNamedDecl, (CXTemplateParameterList, Cuint), TPL, Idx)
end

function clang_TemplateParameterList_size(TPL)
    ccall((:clang_TemplateParameterList_size, libclangex), Cuint, (CXTemplateParameterList,), TPL)
end

function clang_TemplateArgumentList_CreateCopy(Context, Args, ArgNum)
    ccall((:clang_TemplateArgumentList_CreateCopy, libclangex), CXTemplateArgumentList, (CXASTContext, CXTemplateArgument, Csize_t), Context, Args, ArgNum)
end

function clang_TemplateArgumentList_size(TAL)
    ccall((:clang_TemplateArgumentList_size, libclangex), Cuint, (CXTemplateArgumentList,), TAL)
end

function clang_TemplateArgumentList_data(TAL)
    ccall((:clang_TemplateArgumentList_data, libclangex), CXTemplateArgument, (CXTemplateArgumentList,), TAL)
end

function clang_TemplateArgumentList_get(TAL, Idx)
    ccall((:clang_TemplateArgumentList_get, libclangex), CXTemplateArgument, (CXTemplateArgumentList, Cuint), TAL, Idx)
end

function clang_TemplateDecl_init(TD, ND, TP)
    ccall((:clang_TemplateDecl_init, libclangex), Cvoid, (CXTemplateDecl, CXNamedDecl, CXTemplateParameterList), TD, ND, TP)
end

function clang_RedeclarableTemplateDecl_getCanonicalDecl(RTD)
    ccall((:clang_RedeclarableTemplateDecl_getCanonicalDecl, libclangex), CXRedeclarableTemplateDecl, (CXRedeclarableTemplateDecl,), RTD)
end

function clang_RedeclarableTemplateDecl_isMemberSpecialization(RTD)
    ccall((:clang_RedeclarableTemplateDecl_isMemberSpecialization, libclangex), Bool, (CXRedeclarableTemplateDecl,), RTD)
end

function clang_RedeclarableTemplateDecl_setMemberSpecialization(RTD)
    ccall((:clang_RedeclarableTemplateDecl_setMemberSpecialization, libclangex), Cvoid, (CXRedeclarableTemplateDecl,), RTD)
end

function clang_ClassTemplateDecl_getTemplatedDecl(CTD)
    ccall((:clang_ClassTemplateDecl_getTemplatedDecl, libclangex), CXCXXRecordDecl, (CXClassTemplateDecl,), CTD)
end

function clang_ClassTemplateDecl_isThisDeclarationADefinition(CTD)
    ccall((:clang_ClassTemplateDecl_isThisDeclarationADefinition, libclangex), Bool, (CXClassTemplateDecl,), CTD)
end

function clang_ClassTemplateDecl_findSpecialization(CTD, TAL, InsertPos)
    ccall((:clang_ClassTemplateDecl_findSpecialization, libclangex), CXClassTemplateSpecializationDecl, (CXClassTemplateDecl, CXTemplateArgumentList, Ptr{Cvoid}), CTD, TAL, InsertPos)
end

function clang_ClassTemplateDecl_AddSpecialization(CTD, CTSD, InsertPos)
    ccall((:clang_ClassTemplateDecl_AddSpecialization, libclangex), Cvoid, (CXClassTemplateDecl, CXClassTemplateSpecializationDecl, Ptr{Cvoid}), CTD, CTSD, InsertPos)
end

function clang_ClassTemplateDecl_getCanonicalDecl(CTD)
    ccall((:clang_ClassTemplateDecl_getCanonicalDecl, libclangex), CXClassTemplateDecl, (CXClassTemplateDecl,), CTD)
end

function clang_ClassTemplateDecl_getPreviousDecl(CTD)
    ccall((:clang_ClassTemplateDecl_getPreviousDecl, libclangex), CXClassTemplateDecl, (CXClassTemplateDecl,), CTD)
end

function clang_ClassTemplateDecl_getMostRecentDecl(CTD)
    ccall((:clang_ClassTemplateDecl_getMostRecentDecl, libclangex), CXClassTemplateDecl, (CXClassTemplateDecl,), CTD)
end

function clang_ClassTemplateSpecializationDecl_Create(Context, TK, DC, StartLoc, IdLoc, SpecializedTemplate, Args, PrevDecl)
    ccall((:clang_ClassTemplateSpecializationDecl_Create, libclangex), CXClassTemplateSpecializationDecl, (CXASTContext, CXTagTypeKind, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXClassTemplateDecl, CXTemplateArgumentList, CXClassTemplateSpecializationDecl), Context, TK, DC, StartLoc, IdLoc, SpecializedTemplate, Args, PrevDecl)
end

function clang_ClassTemplateSpecializationDecl_getTemplateArgs(CTSD)
    ccall((:clang_ClassTemplateSpecializationDecl_getTemplateArgs, libclangex), CXTemplateArgumentList, (CXClassTemplateSpecializationDecl,), CTSD)
end

function clang_ClassTemplateSpecializationDecl_setTemplateArgs(CTSD, TAL)
    ccall((:clang_ClassTemplateSpecializationDecl_setTemplateArgs, libclangex), Cvoid, (CXClassTemplateSpecializationDecl, CXTemplateArgumentList), CTSD, TAL)
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

function clang_IgnoringDiagConsumer_create(ErrorCode)
    ccall((:clang_IgnoringDiagConsumer_create, libclangex), CXDiagnosticConsumer, (Ptr{CXInit_Error},), ErrorCode)
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

function clang_Scope_dump(S)
    ccall((:clang_Scope_dump, libclangex), Cvoid, (CXScope,), S)
end

function clang_Scope_getParent(S)
    ccall((:clang_Scope_getParent, libclangex), CXScope, (CXScope,), S)
end

function clang_Scope_getDepth(S)
    ccall((:clang_Scope_getDepth, libclangex), Cuint, (CXScope,), S)
end

function clang_FrontendOptions_PrintStats(FEO)
    ccall((:clang_FrontendOptions_PrintStats, libclangex), Cvoid, (CXFrontendOptions,), FEO)
end

function clang_DeclarationName_create()
    ccall((:clang_DeclarationName_create, libclangex), CXDeclarationName, ())
end

function clang_DeclarationName_createFromIdentifierInfo(IDInfo)
    ccall((:clang_DeclarationName_createFromIdentifierInfo, libclangex), CXDeclarationName, (CXIdentifierInfo,), IDInfo)
end

function clang_DeclarationName_dump(DN)
    ccall((:clang_DeclarationName_dump, libclangex), Cvoid, (CXDeclarationName,), DN)
end

function clang_DeclarationName_isEmpty(DN)
    ccall((:clang_DeclarationName_isEmpty, libclangex), Bool, (CXDeclarationName,), DN)
end

function clang_DeclarationName_getAsString(DN)
    ccall((:clang_DeclarationName_getAsString, libclangex), CXString, (CXDeclarationName,), DN)
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

function clang_SourceManager_getLocForStartOfFile(SM, FID)
    ccall((:clang_SourceManager_getLocForStartOfFile, libclangex), CXSourceLocation_, (CXSourceManager, CXFileID), SM, FID)
end

function clang_SourceManager_getLocForEndOfFile(SM, FID)
    ccall((:clang_SourceManager_getLocForEndOfFile, libclangex), CXSourceLocation_, (CXSourceManager, CXFileID), SM, FID)
end

@enum CXMangleContext_ManglerKind::UInt32 begin
    CXMangleContext_MK_Itanium = 0
    CXMangleContext_MK_Microsoft = 1
end

function clang_MangleContext_getKind(MC)
    ccall((:clang_MangleContext_getKind, libclangex), CXMangleContext_ManglerKind, (CXMangleContext,), MC)
end

function clang_MangleContext_getASTContext(MC)
    ccall((:clang_MangleContext_getASTContext, libclangex), CXASTContext, (CXMangleContext,), MC)
end

function clang_MangleContext_getDiags(MC)
    ccall((:clang_MangleContext_getDiags, libclangex), CXDiagnosticsEngine, (CXMangleContext,), MC)
end

function clang_MangleContext_getAnonymousStructId(MC, D)
    ccall((:clang_MangleContext_getAnonymousStructId, libclangex), UInt64, (CXMangleContext, CXNamedDecl), MC, D)
end

function clang_MangleContext_shouldMangleDeclName(MC, D)
    ccall((:clang_MangleContext_shouldMangleDeclName, libclangex), Bool, (CXMangleContext, CXNamedDecl), MC, D)
end

function clang_MangleContext_shouldMangleCXXName(MC, D)
    ccall((:clang_MangleContext_shouldMangleCXXName, libclangex), Bool, (CXMangleContext, CXNamedDecl), MC, D)
end

function clang_MangleContext_shouldMangleStringLiteral(MC, SL)
    ccall((:clang_MangleContext_shouldMangleStringLiteral, libclangex), Bool, (CXMangleContext, CXStringLiteral), MC, SL)
end

function clang_ASTNameGenerator_getName(G, D)
    ccall((:clang_ASTNameGenerator_getName, libclangex), CXString, (CXASTNameGenerator, CXDecl), G, D)
end

function clang_ASTNameGenerator_getAllManglings(G, D)
    ccall((:clang_ASTNameGenerator_getAllManglings, libclangex), Ptr{CXStringSet}, (CXASTNameGenerator, CXDecl), G, D)
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

function clang_DiagnosticIDs_create(ErrorCode)
    ccall((:clang_DiagnosticIDs_create, libclangex), CXDiagnosticIDs, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_DiagnosticIDs_dispose(ID)
    ccall((:clang_DiagnosticIDs_dispose, libclangex), Cvoid, (CXDiagnosticIDs,), ID)
end

function clang_Lexer_create(FID, FromFile, SM, langOpts, ErrorCode)
    ccall((:clang_Lexer_create, libclangex), CXLexer, (CXFileID, LLVMMemoryBufferRef, CXSourceManager, CXLangOptions, Ptr{CXInit_Error}), FID, FromFile, SM, langOpts, ErrorCode)
end

function clang_Lexer_dispose(Lex)
    ccall((:clang_Lexer_dispose, libclangex), Cvoid, (CXLexer,), Lex)
end

function clang_Stmt_EnableStatistics()
    ccall((:clang_Stmt_EnableStatistics, libclangex), Cvoid, ())
end

function clang_Stmt_PrintStats()
    ccall((:clang_Stmt_PrintStats, libclangex), Cvoid, ())
end

@enum CXLambdaCaptureDefault::UInt32 begin
    CXLambdaCaptureDefault_LCD_None = 0
    CXLambdaCaptureDefault_LCD_ByCopy = 1
    CXLambdaCaptureDefault_LCD_ByRef = 2
end

@enum CXLambdaCaptureKind::UInt32 begin
    CXLambdaCaptureKind_LCK_This = 0
    CXLambdaCaptureKind_LCK_StarThis = 1
    CXLambdaCaptureKind_LCK_ByCopy = 2
    CXLambdaCaptureKind_LCK_ByRef = 3
    CXLambdaCaptureKind_LCK_VLAType = 4
end

function clang_AccessSpecDecl_getAccessSpecifierLoc(AS)
    ccall((:clang_AccessSpecDecl_getAccessSpecifierLoc, libclangex), CXSourceLocation_, (CXAccessSpecDecl,), AS)
end

function clang_AccessSpecDecl_setAccessSpecifierLoc(AS, ASLoc)
    ccall((:clang_AccessSpecDecl_setAccessSpecifierLoc, libclangex), Cvoid, (CXAccessSpecDecl, CXSourceLocation_), AS, ASLoc)
end

function clang_AccessSpecDecl_getColonLoc(AS)
    ccall((:clang_AccessSpecDecl_getColonLoc, libclangex), CXSourceLocation_, (CXAccessSpecDecl,), AS)
end

function clang_AccessSpecDecl_setColonLoc(AS, CLoc)
    ccall((:clang_AccessSpecDecl_setColonLoc, libclangex), Cvoid, (CXAccessSpecDecl, CXSourceLocation_), AS, CLoc)
end

function clang_AccessSpecDecl_getSourceRange(AS)
    ccall((:clang_AccessSpecDecl_getSourceRange, libclangex), CXSourceRange_, (CXAccessSpecDecl,), AS)
end

function clang_AccessSpecDecl_Create(C, AS, DC, ASLoc, ColonLoc)
    ccall((:clang_AccessSpecDecl_Create, libclangex), CXAccessSpecDecl, (CXASTContext, CXAccessSpecifier, CXDeclContext, CXSourceLocation_, CXSourceLocation_), C, AS, DC, ASLoc, ColonLoc)
end

function clang_AccessSpecDecl_CreateDeserialized(C, ID)
    ccall((:clang_AccessSpecDecl_CreateDeserialized, libclangex), CXAccessSpecDecl, (CXASTContext, Cuint), C, ID)
end

function clang_CXXBaseSpecifier_getSourceRange(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getSourceRange, libclangex), CXSourceRange_, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getColonLoc(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getColonLoc, libclangex), CXSourceLocation_, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getEndLoc(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getEndLoc, libclangex), CXSourceLocation_, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getBaseTypeLoc(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getBaseTypeLoc, libclangex), CXSourceLocation_, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_isVirtual(CXXBS)
    ccall((:clang_CXXBaseSpecifier_isVirtual, libclangex), Bool, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_isBaseOfClass(CXXBS)
    ccall((:clang_CXXBaseSpecifier_isBaseOfClass, libclangex), Bool, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_isPackExpansion(CXXBS)
    ccall((:clang_CXXBaseSpecifier_isPackExpansion, libclangex), Bool, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getInheritConstructors(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getInheritConstructors, libclangex), Bool, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_setInheritConstructors(CXXBS, Inherit)
    ccall((:clang_CXXBaseSpecifier_setInheritConstructors, libclangex), Cvoid, (CXCXXBaseSpecifier, Bool), CXXBS, Inherit)
end

function clang_CXXBaseSpecifier_getEllipsisLoc(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getEllipsisLoc, libclangex), CXSourceLocation_, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getAccessSpecifier(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getAccessSpecifier, libclangex), CXAccessSpecifier, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getAccessSpecifierAsWritten, libclangex), CXAccessSpecifier, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getType(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getType, libclangex), CXQualType, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXBaseSpecifier_getTypeSourceInfo(CXXBS)
    ccall((:clang_CXXBaseSpecifier_getTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXCXXBaseSpecifier,), CXXBS)
end

function clang_CXXRecordDecl_getCanonicalDecl(CXXRD)
    ccall((:clang_CXXRecordDecl_getCanonicalDecl, libclangex), CXCXXRecordDecl, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_getPreviousDecl(CXXRD)
    ccall((:clang_CXXRecordDecl_getPreviousDecl, libclangex), CXCXXRecordDecl, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_getMostRecentDecl(CXXRD)
    ccall((:clang_CXXRecordDecl_getMostRecentDecl, libclangex), CXCXXRecordDecl, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXXRD)
    ccall((:clang_CXXRecordDecl_getMostRecentNonInjectedDecl, libclangex), CXCXXRecordDecl, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_getDefinition(CXXRD)
    ccall((:clang_CXXRecordDecl_getDefinition, libclangex), CXCXXRecordDecl, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_hasDefinition(CXXRD)
    ccall((:clang_CXXRecordDecl_hasDefinition, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_Create(C, TK, DC, StartLoc, IdLoc, Id, PrevDecl, DelayTypeCreation)
    ccall((:clang_CXXRecordDecl_Create, libclangex), CXCXXRecordDecl, (CXASTContext, CXTagTypeKind, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXIdentifierInfo, CXCXXRecordDecl, Bool), C, TK, DC, StartLoc, IdLoc, Id, PrevDecl, DelayTypeCreation)
end

function clang_CXXRecordDecl_CreateLambda(C, DC, Info, Loc, DependentLambda, IsGeneric, CaptureDefault)
    ccall((:clang_CXXRecordDecl_CreateLambda, libclangex), CXCXXRecordDecl, (CXASTContext, CXDeclContext, CXTypeSourceInfo, CXSourceLocation_, Bool, Bool, CXLambdaCaptureDefault), C, DC, Info, Loc, DependentLambda, IsGeneric, CaptureDefault)
end

function clang_CXXRecordDecl_isLambda(CXXRD)
    ccall((:clang_CXXRecordDecl_isLambda, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_isGenericLambda(CXXRD)
    ccall((:clang_CXXRecordDecl_isGenericLambda, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXXRD)
    ccall((:clang_CXXRecordDecl_getGenericLambdaTemplateParameterList, libclangex), CXTemplateParameterList, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_isAggregate(CXXRD)
    ccall((:clang_CXXRecordDecl_isAggregate, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_isPOD(CXXRD)
    ccall((:clang_CXXRecordDecl_isPOD, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_isCLike(CXXRD)
    ccall((:clang_CXXRecordDecl_isCLike, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_CXXRecordDecl_isEmpty(CXXRD)
    ccall((:clang_CXXRecordDecl_isEmpty, libclangex), Bool, (CXCXXRecordDecl,), CXXRD)
end

function clang_ExplicitSpecifier_getKind(ES)
    ccall((:clang_ExplicitSpecifier_getKind, libclangex), CXExplicitSpecKind, (CXExplicitSpecifier,), ES)
end

function clang_ExplicitSpecifier_getExpr(ES)
    ccall((:clang_ExplicitSpecifier_getExpr, libclangex), CXExpr, (CXExplicitSpecifier,), ES)
end

function clang_ExplicitSpecifier_isSpecified(ES)
    ccall((:clang_ExplicitSpecifier_isSpecified, libclangex), Bool, (CXExplicitSpecifier,), ES)
end

function clang_ExplicitSpecifier_isExplicit(ES)
    ccall((:clang_ExplicitSpecifier_isExplicit, libclangex), Bool, (CXExplicitSpecifier,), ES)
end

function clang_ExplicitSpecifier_isInvalid(ES)
    ccall((:clang_ExplicitSpecifier_isInvalid, libclangex), Bool, (CXExplicitSpecifier,), ES)
end

function clang_ExplicitSpecifier_setKind(ES, Kind)
    ccall((:clang_ExplicitSpecifier_setKind, libclangex), Cvoid, (CXExplicitSpecifier, CXExplicitSpecKind), ES, Kind)
end

function clang_ExplicitSpecifier_setExpr(ES, E)
    ccall((:clang_ExplicitSpecifier_setExpr, libclangex), Cvoid, (CXExplicitSpecifier, CXExpr), ES, E)
end

function clang_RequiresExprBodyDecl_Create(C, DC, StartLoc)
    ccall((:clang_RequiresExprBodyDecl_Create, libclangex), CXRequiresExprBodyDecl, (CXASTContext, CXDeclContext, CXSourceLocation_), C, DC, StartLoc)
end

function clang_RequiresExprBodyDecl_CreateDeserialized(C, ID)
    ccall((:clang_RequiresExprBodyDecl_CreateDeserialized, libclangex), CXRequiresExprBodyDecl, (CXASTContext, Cuint), C, ID)
end

function clang_CXXMethodDecl_Create(C, RD, StartLoc, NameInfo, T, TInfo, SC, isInline, ConstexprKind, EndLocation, TrailingRequiresClause)
    ccall((:clang_CXXMethodDecl_Create, libclangex), CXCXXMethodDecl, (CXASTContext, CXCXXRecordDecl, CXSourceLocation_, CXDeclarationNameInfo, CXQualType, CXTypeSourceInfo, CXStorageClass, Bool, CXConstexprSpecKind, CXSourceLocation_, CXExpr), C, RD, StartLoc, NameInfo, T, TInfo, SC, isInline, ConstexprKind, EndLocation, TrailingRequiresClause)
end

function clang_CXXMethodDecl_CreateDeserialized(C, ID)
    ccall((:clang_CXXMethodDecl_CreateDeserialized, libclangex), CXCXXMethodDecl, (CXASTContext, Cuint), C, ID)
end

function clang_CXXMethodDecl_isStatic(CXXMD)
    ccall((:clang_CXXMethodDecl_isStatic, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isInstance(CXXMD)
    ccall((:clang_CXXMethodDecl_isInstance, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isConst(CXXMD)
    ccall((:clang_CXXMethodDecl_isConst, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isVolatile(CXXMD)
    ccall((:clang_CXXMethodDecl_isVolatile, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isVirtual(CXXMD)
    ccall((:clang_CXXMethodDecl_isVirtual, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getDevirtualizedMethod(CXXMD, Base, IsAppleKext)
    ccall((:clang_CXXMethodDecl_getDevirtualizedMethod, libclangex), CXCXXMethodDecl, (CXCXXMethodDecl, CXExpr, Bool), CXXMD, Base, IsAppleKext)
end

function clang_CXXMethodDecl_isCopyAssignmentOperator(CXXMD)
    ccall((:clang_CXXMethodDecl_isCopyAssignmentOperator, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isMoveAssignmentOperator(CXXMD)
    ccall((:clang_CXXMethodDecl_isMoveAssignmentOperator, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getCanonicalDecl(CXXMD)
    ccall((:clang_CXXMethodDecl_getCanonicalDecl, libclangex), CXCXXMethodDecl, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getMostRecentDecl(CXXMD)
    ccall((:clang_CXXMethodDecl_getMostRecentDecl, libclangex), CXCXXMethodDecl, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_addOverriddenMethod(CXXMD, MD)
    ccall((:clang_CXXMethodDecl_addOverriddenMethod, libclangex), Cvoid, (CXCXXMethodDecl, CXCXXMethodDecl), CXXMD, MD)
end

function clang_CXXMethodDecl_getParent(CXXMD)
    ccall((:clang_CXXMethodDecl_getParent, libclangex), CXCXXRecordDecl, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getThisType(CXXMD)
    ccall((:clang_CXXMethodDecl_getThisType, libclangex), CXQualType, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getThisObjectType(CXXMD)
    ccall((:clang_CXXMethodDecl_getThisObjectType, libclangex), CXQualType, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_hasInlineBody(CXXMD)
    ccall((:clang_CXXMethodDecl_hasInlineBody, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_isLambdaStaticInvoker(CXXMD)
    ccall((:clang_CXXMethodDecl_isLambdaStaticInvoker, libclangex), Bool, (CXCXXMethodDecl,), CXXMD)
end

function clang_CXXMethodDecl_getCorrespondingMethodInClass(CXXMD, RD, MayBeBase)
    ccall((:clang_CXXMethodDecl_getCorrespondingMethodInClass, libclangex), CXCXXRecordDecl, (CXCXXMethodDecl, CXCXXRecordDecl, Bool), CXXMD, RD, MayBeBase)
end

function clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(CXXMD, RD, MayBeBase)
    ccall((:clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass, libclangex), CXCXXRecordDecl, (CXCXXMethodDecl, CXCXXRecordDecl, Bool), CXXMD, RD, MayBeBase)
end

@enum CXLinkageSpecDecl_LanguageIDs::UInt32 begin
    CXLinkageSpecDecl_lang_c = 1
    CXLinkageSpecDecl_lang_cxx = 2
end

function clang_LinkageSpecDecl_Create(C, DC, ExternLoc, LangLoc, Lang, HasBraces)
    ccall((:clang_LinkageSpecDecl_Create, libclangex), CXLinkageSpecDecl, (CXASTContext, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXLinkageSpecDecl_LanguageIDs, Bool), C, DC, ExternLoc, LangLoc, Lang, HasBraces)
end

function clang_LinkageSpecDecl_CreateDeserialized(C, ID)
    ccall((:clang_LinkageSpecDecl_CreateDeserialized, libclangex), CXLinkageSpecDecl, (CXASTContext, Cuint), C, ID)
end

function clang_LinkageSpecDecl_getLanguage(LSD)
    ccall((:clang_LinkageSpecDecl_getLanguage, libclangex), CXLinkageSpecDecl_LanguageIDs, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_setLanguage(LSD, Lang)
    ccall((:clang_LinkageSpecDecl_setLanguage, libclangex), Cvoid, (CXLinkageSpecDecl, CXLinkageSpecDecl_LanguageIDs), LSD, Lang)
end

function clang_LinkageSpecDecl_hasBraces(LSD)
    ccall((:clang_LinkageSpecDecl_hasBraces, libclangex), Bool, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_getExternLoc(LSD)
    ccall((:clang_LinkageSpecDecl_getExternLoc, libclangex), CXSourceLocation_, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_getRBraceLoc(LSD)
    ccall((:clang_LinkageSpecDecl_getRBraceLoc, libclangex), CXSourceLocation_, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_setExternLoc(LSD, Loc)
    ccall((:clang_LinkageSpecDecl_setExternLoc, libclangex), Cvoid, (CXLinkageSpecDecl, CXSourceLocation_), LSD, Loc)
end

function clang_LinkageSpecDecl_setRBraceLoc(LSD, Loc)
    ccall((:clang_LinkageSpecDecl_setRBraceLoc, libclangex), Cvoid, (CXLinkageSpecDecl, CXSourceLocation_), LSD, Loc)
end

function clang_LinkageSpecDecl_getEndLoc(LSD)
    ccall((:clang_LinkageSpecDecl_getEndLoc, libclangex), CXSourceLocation_, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_getSourceRange(LSD)
    ccall((:clang_LinkageSpecDecl_getSourceRange, libclangex), CXSourceRange_, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_castToDeclContext(LSD)
    ccall((:clang_LinkageSpecDecl_castToDeclContext, libclangex), CXDeclContext, (CXLinkageSpecDecl,), LSD)
end

function clang_LinkageSpecDecl_castFromDeclContext(DC)
    ccall((:clang_LinkageSpecDecl_castFromDeclContext, libclangex), CXLinkageSpecDecl, (CXDeclContext,), DC)
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

function clang_LangOptions_PrintStats(LO)
    ccall((:clang_LangOptions_PrintStats, libclangex), Cvoid, (CXLangOptions,), LO)
end

function clang_ASTContext_getSourceManager(Ctx)
    ccall((:clang_ASTContext_getSourceManager, libclangex), CXSourceManager, (CXASTContext,), Ctx)
end

function clang_ASTContext_getASTAllocatedMemory(Ctx)
    ccall((:clang_ASTContext_getASTAllocatedMemory, libclangex), Csize_t, (CXASTContext,), Ctx)
end

function clang_ASTContext_getSideTableAllocatedMemory(Ctx)
    ccall((:clang_ASTContext_getSideTableAllocatedMemory, libclangex), Csize_t, (CXASTContext,), Ctx)
end

function clang_ASTContext_getTargetInfo(Ctx)
    ccall((:clang_ASTContext_getTargetInfo, libclangex), CXTargetInfo_, (CXASTContext,), Ctx)
end

function clang_ASTContext_getAuxTargetInfo(Ctx)
    ccall((:clang_ASTContext_getAuxTargetInfo, libclangex), CXTargetInfo_, (CXASTContext,), Ctx)
end

function clang_ASTContext_getIntTypeForBitwidth(Ctx, DestWidth, Signed)
    ccall((:clang_ASTContext_getIntTypeForBitwidth, libclangex), CXQualType, (CXASTContext, Cuint, Cuint), Ctx, DestWidth, Signed)
end

function clang_ASTContext_getRealTypeForBitwidth(Ctx, DestWidth, ExplicitIEEE)
    ccall((:clang_ASTContext_getRealTypeForBitwidth, libclangex), CXQualType, (CXASTContext, Cuint, Bool), Ctx, DestWidth, ExplicitIEEE)
end

function clang_ASTContext_AtomicUsesUnsupportedLibcall(Ctx, E)
    ccall((:clang_ASTContext_AtomicUsesUnsupportedLibcall, libclangex), Bool, (CXASTContext, CXAtomicExpr), Ctx, E)
end

function clang_ASTContext_getLangOpts(Ctx)
    ccall((:clang_ASTContext_getLangOpts, libclangex), CXLangOptions, (CXASTContext,), Ctx)
end

function clang_ASTContext_isDependceAllowed(Ctx)
    ccall((:clang_ASTContext_isDependceAllowed, libclangex), Bool, (CXASTContext,), Ctx)
end

function clang_ASTContext_getDiagnostics(Ctx)
    ccall((:clang_ASTContext_getDiagnostics, libclangex), CXDiagnosticsEngine, (CXASTContext,), Ctx)
end

function clang_ASTContext_eraseDeclAttrs(Ctx, D)
    ccall((:clang_ASTContext_eraseDeclAttrs, libclangex), Cvoid, (CXASTContext, CXDecl), Ctx, D)
end

function clang_ASTContext_getInstantiatedFromUsingDecl(Ctx, Inst)
    ccall((:clang_ASTContext_getInstantiatedFromUsingDecl, libclangex), CXNamedDecl, (CXASTContext, CXNamedDecl), Ctx, Inst)
end

function clang_ASTContext_setInstantiatedFromUsingDecl(Ctx, Inst, Pattern)
    ccall((:clang_ASTContext_setInstantiatedFromUsingDecl, libclangex), Cvoid, (CXASTContext, CXNamedDecl, CXNamedDecl), Ctx, Inst, Pattern)
end

function clang_ASTContext_setInstantiatedFromUsingShadowDecl(Ctx, Inst, Pattern)
    ccall((:clang_ASTContext_setInstantiatedFromUsingShadowDecl, libclangex), Cvoid, (CXASTContext, CXUsingShadowDecl, CXUsingShadowDecl), Ctx, Inst, Pattern)
end

function clang_ASTContext_getInstantiatedFromUsingShadowDecl(Ctx, Inst)
    ccall((:clang_ASTContext_getInstantiatedFromUsingShadowDecl, libclangex), CXUsingShadowDecl, (CXASTContext, CXUsingShadowDecl), Ctx, Inst)
end

function clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(Ctx, Field)
    ccall((:clang_ASTContext_getInstantiatedFromUnnamedFieldDecl, libclangex), CXFieldDecl, (CXASTContext, CXFieldDecl), Ctx, Field)
end

function clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(Ctx, Inst, Tmpl)
    ccall((:clang_ASTContext_setInstantiatedFromUnnamedFieldDecl, libclangex), Cvoid, (CXASTContext, CXFieldDecl, CXFieldDecl), Ctx, Inst, Tmpl)
end

function clang_ASTContext_addOverriddenMethod(Ctx, Method, Overridden)
    ccall((:clang_ASTContext_addOverriddenMethod, libclangex), Cvoid, (CXASTContext, CXCXXMethodDecl, CXCXXMethodDecl), Ctx, Method, Overridden)
end

function clang_ASTContext_addedLocalImportDecl(Ctx, Import)
    ccall((:clang_ASTContext_addedLocalImportDecl, libclangex), Cvoid, (CXASTContext, CXImportDecl), Ctx, Import)
end

function clang_ASTContext_getPrimaryMergedDecl(Ctx, D)
    ccall((:clang_ASTContext_getPrimaryMergedDecl, libclangex), CXDecl, (CXASTContext, CXDecl), Ctx, D)
end

function clang_ASTContext_setPrimaryMergedDecl(Ctx, D, Primary)
    ccall((:clang_ASTContext_setPrimaryMergedDecl, libclangex), Cvoid, (CXASTContext, CXDecl, CXDecl), Ctx, D, Primary)
end

function clang_ASTContext_mergeDefinitionIntoModule(Ctx, ND, Module, NotifyListeners)
    ccall((:clang_ASTContext_mergeDefinitionIntoModule, libclangex), Cvoid, (CXASTContext, CXNamedDecl, CXModule, Bool), Ctx, ND, Module, NotifyListeners)
end

function clang_ASTContext_deduplicateMergedDefinitonsFor(Ctx, ND)
    ccall((:clang_ASTContext_deduplicateMergedDefinitonsFor, libclangex), Cvoid, (CXASTContext, CXNamedDecl), Ctx, ND)
end

function clang_ASTContext_getTranslationUnitDecl(Ctx)
    ccall((:clang_ASTContext_getTranslationUnitDecl, libclangex), CXTranslationUnitDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getExternCContextDecl(Ctx)
    ccall((:clang_ASTContext_getExternCContextDecl, libclangex), CXExternCContextDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getMakeIntegerSeqDecl(Ctx)
    ccall((:clang_ASTContext_getMakeIntegerSeqDecl, libclangex), CXBuiltinTemplateDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getTypePackElementDecl(Ctx)
    ccall((:clang_ASTContext_getTypePackElementDecl, libclangex), CXBuiltinTemplateDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_PrintStats(Ctx)
    ccall((:clang_ASTContext_PrintStats, libclangex), Cvoid, (CXASTContext,), Ctx)
end

function clang_ASTContext_buildImplicitRecord(Ctx, Name, TK)
    ccall((:clang_ASTContext_buildImplicitRecord, libclangex), CXRecordDecl, (CXASTContext, Ptr{Cchar}, CXTagTypeKind), Ctx, Name, TK)
end

function clang_ASTContext_buildImplicitTypedef(Ctx, T, Name)
    ccall((:clang_ASTContext_buildImplicitTypedef, libclangex), CXTypedefDecl, (CXASTContext, CXQualType, Ptr{Cchar}), Ctx, T, Name)
end

function clang_ASTContext_getInt128Decl(Ctx)
    ccall((:clang_ASTContext_getInt128Decl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getUInt128Decl(Ctx)
    ccall((:clang_ASTContext_getUInt128Decl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_removeAddrSpaceQualType(Ctx, T)
    ccall((:clang_ASTContext_removeAddrSpaceQualType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_removePtrSizeAddrSpace(Ctx, T)
    ccall((:clang_ASTContext_removePtrSizeAddrSpace, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getRestrictType(Ctx, T)
    ccall((:clang_ASTContext_getRestrictType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getVolatileType(Ctx, T)
    ccall((:clang_ASTContext_getVolatileType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getConstType(Ctx, T)
    ccall((:clang_ASTContext_getConstType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_adjustDeducedFunctionResultType(Ctx, FD, ResultType)
    ccall((:clang_ASTContext_adjustDeducedFunctionResultType, libclangex), Cvoid, (CXASTContext, CXFunctionDecl, CXQualType), Ctx, FD, ResultType)
end

function clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(Ctx, T, U)
    ccall((:clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T, U)
end

function clang_ASTContext_getFunctionTypeWithoutPtrSizes(Ctx, T)
    ccall((:clang_ASTContext_getFunctionTypeWithoutPtrSizes, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(Ctx, T, U)
    ccall((:clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T, U)
end

function clang_ASTContext_getComplexType(Ctx, T)
    ccall((:clang_ASTContext_getComplexType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getPointerType(Ctx, T)
    ccall((:clang_ASTContext_getPointerType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAdjustedType(Ctx, Orig, New)
    ccall((:clang_ASTContext_getAdjustedType, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType), Ctx, Orig, New)
end

function clang_ASTContext_getDecayedType(Ctx, T)
    ccall((:clang_ASTContext_getDecayedType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAtomicType(Ctx, T)
    ccall((:clang_ASTContext_getAtomicType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getBlockPointerType(Ctx, T)
    ccall((:clang_ASTContext_getBlockPointerType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getBlockDescriptorType(Ctx)
    ccall((:clang_ASTContext_getBlockDescriptorType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getReadPipeType(Ctx, T)
    ccall((:clang_ASTContext_getReadPipeType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getWritePipeType(Ctx, T)
    ccall((:clang_ASTContext_getWritePipeType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getExtIntType(Ctx, Unsigned, NumBits)
    ccall((:clang_ASTContext_getExtIntType, libclangex), CXQualType, (CXASTContext, Bool, Cuint), Ctx, Unsigned, NumBits)
end

function clang_ASTContext_getDependentExtIntType(Ctx, Unsigned, BitsExpr)
    ccall((:clang_ASTContext_getDependentExtIntType, libclangex), CXQualType, (CXASTContext, Bool, CXExpr), Ctx, Unsigned, BitsExpr)
end

function clang_ASTContext_getBlockDescriptorExtendedType(Ctx)
    ccall((:clang_ASTContext_getBlockDescriptorExtendedType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_setcudaConfigureCallDecl(Ctx, FD)
    ccall((:clang_ASTContext_setcudaConfigureCallDecl, libclangex), Cvoid, (CXASTContext, CXFunctionDecl), Ctx, FD)
end

function clang_ASTContext_getcudaConfigureCallDecl(Ctx)
    ccall((:clang_ASTContext_getcudaConfigureCallDecl, libclangex), CXFunctionDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_BlockRequiresCopying(Ctx, T, D)
    ccall((:clang_ASTContext_BlockRequiresCopying, libclangex), Bool, (CXASTContext, CXQualType, CXVarDecl), Ctx, T, D)
end

function clang_ASTContext_getLValueReferenceType(Ctx, T, SpelledAsLValue)
    ccall((:clang_ASTContext_getLValueReferenceType, libclangex), CXQualType, (CXASTContext, CXQualType, Bool), Ctx, T, SpelledAsLValue)
end

function clang_ASTContext_getRValueReferenceType(Ctx, T)
    ccall((:clang_ASTContext_getRValueReferenceType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getMemberPointerType(Ctx, T, Cls)
    ccall((:clang_ASTContext_getMemberPointerType, libclangex), CXQualType, (CXASTContext, CXQualType, CXType_), Ctx, T, Cls)
end

function clang_ASTContext_getStringLiteralArrayType(Ctx, EltTy, Length)
    ccall((:clang_ASTContext_getStringLiteralArrayType, libclangex), CXQualType, (CXASTContext, CXQualType, Cuint), Ctx, EltTy, Length)
end

function clang_ASTContext_getVariableArrayDecayedType(Ctx, T)
    ccall((:clang_ASTContext_getVariableArrayDecayedType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getScalableVectorType(Ctx, EltTy, NumElts)
    ccall((:clang_ASTContext_getScalableVectorType, libclangex), CXQualType, (CXASTContext, CXQualType, Cuint), Ctx, EltTy, NumElts)
end

function clang_ASTContext_getExtVectorType(Ctx, VectorType, NumElts)
    ccall((:clang_ASTContext_getExtVectorType, libclangex), CXQualType, (CXASTContext, CXQualType, Cuint), Ctx, VectorType, NumElts)
end

function clang_ASTContext_getDependentSizedExtVectorType(Ctx, VectorType, SizeExpr, AttrLoc)
    ccall((:clang_ASTContext_getDependentSizedExtVectorType, libclangex), CXQualType, (CXASTContext, CXQualType, CXExpr, CXSourceLocation_), Ctx, VectorType, SizeExpr, AttrLoc)
end

function clang_ASTContext_getConstantMatrixType(Ctx, ElementType, NumRows, NumCols)
    ccall((:clang_ASTContext_getConstantMatrixType, libclangex), CXQualType, (CXASTContext, CXQualType, Cuint, Cuint), Ctx, ElementType, NumRows, NumCols)
end

function clang_ASTContext_getDependentSizedMatrixType(Ctx, ElementType, RowsExpr, ColsExpr, AttrLoc)
    ccall((:clang_ASTContext_getDependentSizedMatrixType, libclangex), CXQualType, (CXASTContext, CXQualType, CXExpr, CXExpr, CXSourceLocation_), Ctx, ElementType, RowsExpr, ColsExpr, AttrLoc)
end

function clang_ASTContext_getDependentAddressSpaceType(Ctx, PointeeType, AddrSpaceExpr, AddrSpace)
    ccall((:clang_ASTContext_getDependentAddressSpaceType, libclangex), CXQualType, (CXASTContext, CXQualType, CXExpr, CXSourceLocation_), Ctx, PointeeType, AddrSpaceExpr, AddrSpace)
end

function clang_ASTContext_getFunctionNoProtoType(Ctx, ResultTy)
    ccall((:clang_ASTContext_getFunctionNoProtoType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, ResultTy)
end

function clang_ASTContext_adjustStringLiteralBaseType(Ctx, StrLTy)
    ccall((:clang_ASTContext_adjustStringLiteralBaseType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, StrLTy)
end

function clang_ASTContext_getTypeDeclType(Ctx, Decl, PrevDecl)
    ccall((:clang_ASTContext_getTypeDeclType, libclangex), CXQualType, (CXASTContext, CXTypeDecl, CXTypeDecl), Ctx, Decl, PrevDecl)
end

function clang_ASTContext_getTypedefType(Ctx, Decl, Underlying)
    ccall((:clang_ASTContext_getTypedefType, libclangex), CXQualType, (CXASTContext, CXTypedefNameDecl, CXQualType), Ctx, Decl, Underlying)
end

function clang_ASTContext_getRecordType(Ctx, Decl)
    ccall((:clang_ASTContext_getRecordType, libclangex), CXQualType, (CXASTContext, CXRecordDecl), Ctx, Decl)
end

function clang_ASTContext_getEnumType(Ctx, Decl)
    ccall((:clang_ASTContext_getEnumType, libclangex), CXQualType, (CXASTContext, CXEnumDecl), Ctx, Decl)
end

function clang_ASTContext_getInjectedClassNameType(Ctx, Decl, TST)
    ccall((:clang_ASTContext_getInjectedClassNameType, libclangex), CXQualType, (CXASTContext, CXCXXRecordDecl, CXQualType), Ctx, Decl, TST)
end

function clang_ASTContext_getSubstTemplateTypeParmType(Ctx, Replaced, Replacement)
    ccall((:clang_ASTContext_getSubstTemplateTypeParmType, libclangex), CXQualType, (CXASTContext, CXTemplateTypeParmType, CXQualType), Ctx, Replaced, Replacement)
end

function clang_ASTContext_getTemplateTypeParmType(Ctx, Depth, Index, ParameterPack, ParmDecl)
    ccall((:clang_ASTContext_getTemplateTypeParmType, libclangex), CXQualType, (CXASTContext, Cuint, Cuint, Bool, CXTemplateTypeParmType), Ctx, Depth, Index, ParameterPack, ParmDecl)
end

function clang_ASTContext_getParenType(Ctx, NamedType)
    ccall((:clang_ASTContext_getParenType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, NamedType)
end

function clang_ASTContext_getMacroQualifiedType(Ctx, UnderlyingTy, MacroII)
    ccall((:clang_ASTContext_getMacroQualifiedType, libclangex), CXQualType, (CXASTContext, CXQualType, CXIdentifierInfo), Ctx, UnderlyingTy, MacroII)
end

function clang_ASTContext_getTypeOfExprType(Ctx, Expr)
    ccall((:clang_ASTContext_getTypeOfExprType, libclangex), CXQualType, (CXASTContext, CXExpr), Ctx, Expr)
end

function clang_ASTContext_getTypeOfType(Ctx, T)
    ccall((:clang_ASTContext_getTypeOfType, libclangex), CXQualType, (CXASTContext, CXType_), Ctx, T)
end

function clang_ASTContext_getDecltypeType(Ctx, Expr, UnderlyingType)
    ccall((:clang_ASTContext_getDecltypeType, libclangex), CXQualType, (CXASTContext, CXExpr, CXQualType), Ctx, Expr, UnderlyingType)
end

function clang_ASTContext_getAutoDeductType(Ctx)
    ccall((:clang_ASTContext_getAutoDeductType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getAutoRRefDeductType(Ctx)
    ccall((:clang_ASTContext_getAutoRRefDeductType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getDeducedTemplateSpecializationType(Ctx, Template, DeducedType, IsDependent)
    ccall((:clang_ASTContext_getDeducedTemplateSpecializationType, libclangex), CXQualType, (CXASTContext, CXTemplateName, CXQualType, Bool), Ctx, Template, DeducedType, IsDependent)
end

function clang_ASTContext_getTagDeclType(Ctx, Decl)
    ccall((:clang_ASTContext_getTagDeclType, libclangex), CXQualType, (CXASTContext, CXTagDecl), Ctx, Decl)
end

function clang_ASTContext_getWCharType(Ctx)
    ccall((:clang_ASTContext_getWCharType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getWideCharType(Ctx)
    ccall((:clang_ASTContext_getWideCharType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getSignedWCharType(Ctx)
    ccall((:clang_ASTContext_getSignedWCharType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getUnsignedWCharType(Ctx)
    ccall((:clang_ASTContext_getUnsignedWCharType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getWIntType(Ctx)
    ccall((:clang_ASTContext_getWIntType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getIntPtrType(Ctx)
    ccall((:clang_ASTContext_getIntPtrType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getUIntPtrType(Ctx)
    ccall((:clang_ASTContext_getUIntPtrType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getPointerDiffType(Ctx)
    ccall((:clang_ASTContext_getPointerDiffType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getUnsignedPointerDiffType(Ctx)
    ccall((:clang_ASTContext_getUnsignedPointerDiffType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getProcessIDType(Ctx)
    ccall((:clang_ASTContext_getProcessIDType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getCFConstantStringType(Ctx)
    ccall((:clang_ASTContext_getCFConstantStringType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getObjCSuperType(Ctx)
    ccall((:clang_ASTContext_getObjCSuperType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getRawCFConstantStringType(Ctx)
    ccall((:clang_ASTContext_getRawCFConstantStringType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_setCFConstantStringType(Ctx, T)
    ccall((:clang_ASTContext_setCFConstantStringType, libclangex), Cvoid, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getCFContantStringDecl(Ctx)
    ccall((:clang_ASTContext_getCFContantStringDecl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getCFConstantStringTagDecl(Ctx)
    ccall((:clang_ASTContext_getCFConstantStringTagDecl, libclangex), CXRecordDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getObjCIdRedefinitionType(Ctx)
    ccall((:clang_ASTContext_getObjCIdRedefinitionType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_setObjCIdRedefinitionType(Ctx, T)
    ccall((:clang_ASTContext_setObjCIdRedefinitionType, libclangex), Cvoid, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getObjCClassRedefinitionType(Ctx)
    ccall((:clang_ASTContext_getObjCClassRedefinitionType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_setObjCClassRedefinitionType(Ctx, T)
    ccall((:clang_ASTContext_setObjCClassRedefinitionType, libclangex), Cvoid, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getNSCopyingName(Ctx)
    ccall((:clang_ASTContext_getNSCopyingName, libclangex), CXIdentifierInfo, (CXASTContext,), Ctx)
end

function clang_ASTContext_getBoolName(Ctx)
    ccall((:clang_ASTContext_getBoolName, libclangex), CXIdentifierInfo, (CXASTContext,), Ctx)
end

function clang_ASTContext_getMakeIntegerSeqName(Ctx)
    ccall((:clang_ASTContext_getMakeIntegerSeqName, libclangex), CXIdentifierInfo, (CXASTContext,), Ctx)
end

function clang_ASTContext_getTypePackElementName(Ctx)
    ccall((:clang_ASTContext_getTypePackElementName, libclangex), CXIdentifierInfo, (CXASTContext,), Ctx)
end

function clang_ASTContext_getObjCInstanceType(Ctx)
    ccall((:clang_ASTContext_getObjCInstanceType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getObjCInstanceTypeDecl(Ctx)
    ccall((:clang_ASTContext_getObjCInstanceTypeDecl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_setFILEDecl(Ctx, FILEDecl)
    ccall((:clang_ASTContext_setFILEDecl, libclangex), Cvoid, (CXASTContext, CXTypeDecl), Ctx, FILEDecl)
end

function clang_ASTContext_getFILEType(Ctx)
    ccall((:clang_ASTContext_getFILEType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getLogicalOperationType(Ctx)
    ccall((:clang_ASTContext_getLogicalOperationType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getBOOLDecl(Ctx)
    ccall((:clang_ASTContext_getBOOLDecl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_setBOOLDecl(Ctx, TD)
    ccall((:clang_ASTContext_setBOOLDecl, libclangex), Cvoid, (CXASTContext, CXTypedefDecl), Ctx, TD)
end

function clang_ASTContext_getBOOLType(Ctx)
    ccall((:clang_ASTContext_getBOOLType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getObjCProtoType(Ctx)
    ccall((:clang_ASTContext_getObjCProtoType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getBuiltinVaListDecl(Ctx)
    ccall((:clang_ASTContext_getBuiltinVaListDecl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getVaListTagDecl(Ctx)
    ccall((:clang_ASTContext_getVaListTagDecl, libclangex), CXDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getBuiltinMSVaListDecl(Ctx)
    ccall((:clang_ASTContext_getBuiltinMSVaListDecl, libclangex), CXTypedefDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getBuiltinMSVaListType(Ctx)
    ccall((:clang_ASTContext_getBuiltinMSVaListType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_getMSGuidTagDecl(Ctx)
    ccall((:clang_ASTContext_getMSGuidTagDecl, libclangex), CXTagDecl, (CXASTContext,), Ctx)
end

function clang_ASTContext_getMSGuidType(Ctx)
    ccall((:clang_ASTContext_getMSGuidType, libclangex), CXTagType, (CXASTContext,), Ctx)
end

function clang_ASTContext_canBuiltinBeRedeclared(Ctx, D)
    ccall((:clang_ASTContext_canBuiltinBeRedeclared, libclangex), Bool, (CXASTContext, CXFunctionDecl), Ctx, D)
end

function clang_ASTContext_getCVRQualifiedType(Ctx, T, CVR)
    ccall((:clang_ASTContext_getCVRQualifiedType, libclangex), CXQualType, (CXASTContext, CXQualType, Cuint), Ctx, T, CVR)
end

function clang_ASTContext_getFixedPointScale(Ctx, Ty)
    ccall((:clang_ASTContext_getFixedPointScale, libclangex), Cuchar, (CXASTContext, CXQualType), Ctx, Ty)
end

function clang_ASTContext_getFixedPointIBits(Ctx, Ty)
    ccall((:clang_ASTContext_getFixedPointIBits, libclangex), Cuchar, (CXASTContext, CXQualType), Ctx, Ty)
end

function clang_ASTContext_getAssumedTemplateName(Ctx, Name)
    ccall((:clang_ASTContext_getAssumedTemplateName, libclangex), CXTemplateName, (CXASTContext, CXDeclarationName), Ctx, Name)
end

function clang_ASTContext_getQualifiedTemplateName(Ctx, NNS, TemplateKeyword, Template)
    ccall((:clang_ASTContext_getQualifiedTemplateName, libclangex), CXTemplateName, (CXASTContext, CXNestedNameSpecifier, Bool, CXTemplateDecl), Ctx, NNS, TemplateKeyword, Template)
end

function clang_ASTContext_getDependentTemplateName(Ctx, NNS, Name)
    ccall((:clang_ASTContext_getDependentTemplateName, libclangex), CXTemplateName, (CXASTContext, CXNestedNameSpecifier, CXIdentifierInfo), Ctx, NNS, Name)
end

function clang_ASTContext_getSubstTemplateTemplateParm(Ctx, param, replacement)
    ccall((:clang_ASTContext_getSubstTemplateTemplateParm, libclangex), CXTemplateName, (CXASTContext, CXTemplateTemplateParmDecl, CXTemplateName), Ctx, param, replacement)
end

function clang_ASTContext_areCompatibleVectorTypes(Ctx, FirstVec, SecondVec)
    ccall((:clang_ASTContext_areCompatibleVectorTypes, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, FirstVec, SecondVec)
end

function clang_ASTContext_areCompatibleSveTypes(Ctx, FirstVec, SecondVec)
    ccall((:clang_ASTContext_areCompatibleSveTypes, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, FirstVec, SecondVec)
end

function clang_ASTContext_areLaxCompatibleSveTypes(Ctx, FirstVec, SecondVec)
    ccall((:clang_ASTContext_areLaxCompatibleSveTypes, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, FirstVec, SecondVec)
end

function clang_ASTContext_hasDirectOwnershipQualifier(Ctx, Ty)
    ccall((:clang_ASTContext_hasDirectOwnershipQualifier, libclangex), Bool, (CXASTContext, CXQualType), Ctx, Ty)
end

function clang_ASTContext_getOpenMPDefaultSimdAlign(Ctx, T)
    ccall((:clang_ASTContext_getOpenMPDefaultSimdAlign, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getTypeSize(Ctx, T)
    ccall((:clang_ASTContext_getTypeSize, libclangex), UInt64, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getCharWidth(Ctx)
    ccall((:clang_ASTContext_getCharWidth, libclangex), UInt64, (CXASTContext,), Ctx)
end

function clang_ASTContext_getTypeAlign(Ctx, T)
    ccall((:clang_ASTContext_getTypeAlign, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getTypeUnadjustedAlign(Ctx, T)
    ccall((:clang_ASTContext_getTypeUnadjustedAlign, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getTypeAlignIfKnown(Ctx, T, NeedsPreferredAlignment)
    ccall((:clang_ASTContext_getTypeAlignIfKnown, libclangex), Cuint, (CXASTContext, CXQualType, Bool), Ctx, T, NeedsPreferredAlignment)
end

function clang_ASTContext_isAlignmentRequired(Ctx, T)
    ccall((:clang_ASTContext_isAlignmentRequired, libclangex), Bool, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getPreferredTypeAlign(Ctx, T)
    ccall((:clang_ASTContext_getPreferredTypeAlign, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getTargetDefaultAlignForAttributeAligned(Ctx)
    ccall((:clang_ASTContext_getTargetDefaultAlignForAttributeAligned, libclangex), Cuint, (CXASTContext,), Ctx)
end

function clang_ASTContext_getAlignOfGlobalVar(Ctx, T)
    ccall((:clang_ASTContext_getAlignOfGlobalVar, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getFieldOffset(Ctx, FD)
    ccall((:clang_ASTContext_getFieldOffset, libclangex), UInt64, (CXASTContext, CXValueDecl), Ctx, FD)
end

function clang_ASTContext_isNearlyEmpty(Ctx, RD)
    ccall((:clang_ASTContext_isNearlyEmpty, libclangex), Bool, (CXASTContext, CXCXXRecordDecl), Ctx, RD)
end

function clang_ASTContext_createMangleContext(Ctx, T)
    ccall((:clang_ASTContext_createMangleContext, libclangex), CXMangleContext, (CXASTContext, CXTargetInfo_), Ctx, T)
end

function clang_ASTContext_hasUniqueObjectRepresentations(Ctx, Ty)
    ccall((:clang_ASTContext_hasUniqueObjectRepresentations, libclangex), Bool, (CXASTContext, CXQualType), Ctx, Ty)
end

function clang_ASTContext_hasSameType(Ctx, T1, T2)
    ccall((:clang_ASTContext_hasSameType, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_hasSameUnqualifiedType(Ctx, T1, T2)
    ccall((:clang_ASTContext_hasSameUnqualifiedType, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_hasSameNullabilityTypeQualifier(Ctx, SubT, SuperT, IsParam)
    ccall((:clang_ASTContext_hasSameNullabilityTypeQualifier, libclangex), Bool, (CXASTContext, CXQualType, CXQualType, Bool), Ctx, SubT, SuperT, IsParam)
end

function clang_ASTContext_hasSimilarType(Ctx, T1, T2)
    ccall((:clang_ASTContext_hasSimilarType, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_hasCvrSimilarType(Ctx, T1, T2)
    ccall((:clang_ASTContext_hasCvrSimilarType, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_getCanonicalNestedNameSpecifier(Ctx, NNS)
    ccall((:clang_ASTContext_getCanonicalNestedNameSpecifier, libclangex), CXNestedNameSpecifier, (CXASTContext, CXNestedNameSpecifier), Ctx, NNS)
end

function clang_ASTContext_getCanonicalTemplateName(Ctx, TemplateName)
    ccall((:clang_ASTContext_getCanonicalTemplateName, libclangex), CXTemplateName, (CXASTContext, CXTemplateName), Ctx, TemplateName)
end

function clang_ASTContext_hasSameTempalteName(Ctx, T1, T2)
    ccall((:clang_ASTContext_hasSameTempalteName, libclangex), Bool, (CXASTContext, CXTemplateName, CXTemplateName), Ctx, T1, T2)
end

function clang_ASTContext_getAsArrayType(Ctx, T)
    ccall((:clang_ASTContext_getAsArrayType, libclangex), CXArrayType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAsConstantArrayType(Ctx, T)
    ccall((:clang_ASTContext_getAsConstantArrayType, libclangex), CXConstantArrayType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAsVariableArrayType(Ctx, T)
    ccall((:clang_ASTContext_getAsVariableArrayType, libclangex), CXVariableArrayType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAsIncompleteArrayType(Ctx, T)
    ccall((:clang_ASTContext_getAsIncompleteArrayType, libclangex), CXIncompleteArrayType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getAsDependentSizedArrayType(Ctx, T)
    ccall((:clang_ASTContext_getAsDependentSizedArrayType, libclangex), CXDependentSizedArrayType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getBaseElementType(Ctx, QT)
    ccall((:clang_ASTContext_getBaseElementType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, QT)
end

function clang_ASTContext_getConstantArrayElementCount(Ctx, CAT)
    ccall((:clang_ASTContext_getConstantArrayElementCount, libclangex), UInt64, (CXASTContext, CXConstantArrayType), Ctx, CAT)
end

function clang_ASTContext_getAdjustedParameterType(Ctx, T)
    ccall((:clang_ASTContext_getAdjustedParameterType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getSignatureParameterType(Ctx, T)
    ccall((:clang_ASTContext_getSignatureParameterType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getExceptionObjectType(Ctx, T)
    ccall((:clang_ASTContext_getExceptionObjectType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getArrayDecayedType(Ctx, T)
    ccall((:clang_ASTContext_getArrayDecayedType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getPromotedIntegerType(Ctx, T)
    ccall((:clang_ASTContext_getPromotedIntegerType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_isPromotableBitField(Ctx, E)
    ccall((:clang_ASTContext_isPromotableBitField, libclangex), CXQualType, (CXASTContext, CXExpr), Ctx, E)
end

function clang_ASTContext_getIntegerTypeOrder(Ctx, LHS, RHS)
    ccall((:clang_ASTContext_getIntegerTypeOrder, libclangex), Cint, (CXASTContext, CXQualType, CXQualType), Ctx, LHS, RHS)
end

function clang_ASTContext_getFloatingTypeOrder(Ctx, LHS, RHS)
    ccall((:clang_ASTContext_getFloatingTypeOrder, libclangex), Cint, (CXASTContext, CXQualType, CXQualType), Ctx, LHS, RHS)
end

function clang_ASTContext_getFloatingTypeSemanticOrder(Ctx, LHS, RHS)
    ccall((:clang_ASTContext_getFloatingTypeSemanticOrder, libclangex), Cint, (CXASTContext, CXQualType, CXQualType), Ctx, LHS, RHS)
end

function clang_ASTContext_getFloatingTypeOfSizeWithinDomain(Ctx, typeSize, typeDomain)
    ccall((:clang_ASTContext_getFloatingTypeOfSizeWithinDomain, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType), Ctx, typeSize, typeDomain)
end

function clang_ASTContext_getTargetAddressSpace(Ctx, T)
    ccall((:clang_ASTContext_getTargetAddressSpace, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getTargetNullPointerValue(Ctx, T)
    ccall((:clang_ASTContext_getTargetNullPointerValue, libclangex), UInt64, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_typesAreCompatible(Ctx, T1, T2, CompareUnqualified)
    ccall((:clang_ASTContext_typesAreCompatible, libclangex), Bool, (CXASTContext, CXQualType, CXQualType, Bool), Ctx, T1, T2, CompareUnqualified)
end

function clang_ASTContext_propertyTypesAreCompatible(Ctx, T1, T2)
    ccall((:clang_ASTContext_propertyTypesAreCompatible, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_typesAreBlockPointerCompatible(Ctx, T1, T2)
    ccall((:clang_ASTContext_typesAreBlockPointerCompatible, libclangex), Bool, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_mergeTypes(Ctx, T1, T2, OfBlockPointer, Unqualified, BlockReturnType)
    ccall((:clang_ASTContext_mergeTypes, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType, Bool, Bool, Bool), Ctx, T1, T2, OfBlockPointer, Unqualified, BlockReturnType)
end

function clang_ASTContext_mergeFunctionTypes(Ctx, T1, T2, OfBlockPointer, Unqualified, AllowCXX)
    ccall((:clang_ASTContext_mergeFunctionTypes, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType, Bool, Bool, Bool), Ctx, T1, T2, OfBlockPointer, Unqualified, AllowCXX)
end

function clang_ASTContext_mergeFunctionParameterTypes(Ctx, T1, T2, OfBlockPointer, Unqualified)
    ccall((:clang_ASTContext_mergeFunctionParameterTypes, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType, Bool, Bool), Ctx, T1, T2, OfBlockPointer, Unqualified)
end

function clang_ASTContext_mergeTransparentUnionType(Ctx, T1, T2, OfBlockPointer, Unqualified)
    ccall((:clang_ASTContext_mergeTransparentUnionType, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType, Bool, Bool), Ctx, T1, T2, OfBlockPointer, Unqualified)
end

function clang_ASTContext_mergeObjCGCQualifiers(Ctx, T1, T2)
    ccall((:clang_ASTContext_mergeObjCGCQualifiers, libclangex), CXQualType, (CXASTContext, CXQualType, CXQualType), Ctx, T1, T2)
end

function clang_ASTContext_getIntWidth(Ctx, T)
    ccall((:clang_ASTContext_getIntWidth, libclangex), Cuint, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getCorrespondingUnsignedType(Ctx, T)
    ccall((:clang_ASTContext_getCorrespondingUnsignedType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getCorrespondingSaturatedType(Ctx, T)
    ccall((:clang_ASTContext_getCorrespondingSaturatedType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getCorrespondingSignedFixedPointType(Ctx, T)
    ccall((:clang_ASTContext_getCorrespondingSignedFixedPointType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, T)
end

function clang_ASTContext_getIdents(Ctx)
    ccall((:clang_ASTContext_getIdents, libclangex), CXIdentifierTable, (CXASTContext,), Ctx)
end

function clang_ASTContext_isSentinelNullExpr(Ctx, E)
    ccall((:clang_ASTContext_isSentinelNullExpr, libclangex), Bool, (CXASTContext, CXExpr), Ctx, E)
end

function clang_ASTContext_CreateTypeSourceInfo(Ctx, T, Size)
    ccall((:clang_ASTContext_CreateTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXASTContext, CXQualType, Cuint), Ctx, T, Size)
end

function clang_ASTContext_getTrivialTypeSourceInfo(Ctx, T, Loc)
    ccall((:clang_ASTContext_getTrivialTypeSourceInfo, libclangex), CXTypeSourceInfo, (CXASTContext, CXQualType, CXSourceLocation_), Ctx, T, Loc)
end

function clang_ASTContext_getCopyConstructorForExceptionObject(Ctx, RD)
    ccall((:clang_ASTContext_getCopyConstructorForExceptionObject, libclangex), CXCXXConstructorDecl, (CXASTContext, CXCXXRecordDecl), Ctx, RD)
end

function clang_ASTContext_addCopyConstructorForExceptionObject(Ctx, RD, CD)
    ccall((:clang_ASTContext_addCopyConstructorForExceptionObject, libclangex), Cvoid, (CXASTContext, CXCXXRecordDecl, CXCXXConstructorDecl), Ctx, RD, CD)
end

function clang_ASTContext_addTypedefNameForUnnamedTagDecl(Ctx, TD, TND)
    ccall((:clang_ASTContext_addTypedefNameForUnnamedTagDecl, libclangex), Cvoid, (CXASTContext, CXTagDecl, CXTypedefNameDecl), Ctx, TD, TND)
end

function clang_ASTContext_getTypedefNameForUnnamedTagDecl(Ctx, TD)
    ccall((:clang_ASTContext_getTypedefNameForUnnamedTagDecl, libclangex), CXTypedefNameDecl, (CXASTContext, CXTagDecl), Ctx, TD)
end

function clang_ASTContext_addDeclaratorForUnnamedTagDecl(Ctx, TD, D)
    ccall((:clang_ASTContext_addDeclaratorForUnnamedTagDecl, libclangex), Cvoid, (CXASTContext, CXTagDecl, CXDeclaratorDecl), Ctx, TD, D)
end

function clang_ASTContext_getDeclaratorForUnnamedTagDecl(Ctx, TD)
    ccall((:clang_ASTContext_getDeclaratorForUnnamedTagDecl, libclangex), CXDeclaratorDecl, (CXASTContext, CXTagDecl), Ctx, TD)
end

function clang_ASTContext_setManglingNumber(Ctx, ND, Number)
    ccall((:clang_ASTContext_setManglingNumber, libclangex), Cvoid, (CXASTContext, CXNamedDecl, Cuint), Ctx, ND, Number)
end

function clang_ASTContext_getManglingNumber(Ctx, ND)
    ccall((:clang_ASTContext_getManglingNumber, libclangex), Cuint, (CXASTContext, CXNamedDecl), Ctx, ND)
end

function clang_ASTContext_setStaticLocalNumber(Ctx, ND, Number)
    ccall((:clang_ASTContext_setStaticLocalNumber, libclangex), Cvoid, (CXASTContext, CXVarDecl, Cuint), Ctx, ND, Number)
end

function clang_ASTContext_getStaticLocalNumber(Ctx, ND)
    ccall((:clang_ASTContext_getStaticLocalNumber, libclangex), Cuint, (CXASTContext, CXVarDecl), Ctx, ND)
end

function clang_ASTContext_setParameterIndex(Ctx, D, index)
    ccall((:clang_ASTContext_setParameterIndex, libclangex), Cvoid, (CXASTContext, CXParmVarDecl, Cuint), Ctx, D, index)
end

function clang_ASTContext_getParameterIndex(Ctx, D)
    ccall((:clang_ASTContext_getParameterIndex, libclangex), Cuint, (CXASTContext, CXParmVarDecl), Ctx, D)
end

function clang_ASTContext_getPredefinedStringLiteralFromCache(Ctx, Key)
    ccall((:clang_ASTContext_getPredefinedStringLiteralFromCache, libclangex), CXStringLiteral, (CXASTContext, Ptr{Cchar}), Ctx, Key)
end

function clang_ASTContext_InitBuiltinTypes(Ctx, Target, AuxTarget)
    ccall((:clang_ASTContext_InitBuiltinTypes, libclangex), Cvoid, (CXASTContext, CXTargetInfo_, CXTargetInfo_), Ctx, Target, AuxTarget)
end

function clang_ASTContext_isMSStaticDataMemberInlineDefinition(Ctx, VD)
    ccall((:clang_ASTContext_isMSStaticDataMemberInlineDefinition, libclangex), Bool, (CXASTContext, CXVarDecl), Ctx, VD)
end

function clang_ASTContext_mayExternalizeStaticVar(Ctx, D)
    ccall((:clang_ASTContext_mayExternalizeStaticVar, libclangex), Bool, (CXASTContext, CXDecl), Ctx, D)
end

function clang_ASTContext_shouldExternalizeStaticVar(Ctx, D)
    ccall((:clang_ASTContext_shouldExternalizeStaticVar, libclangex), Bool, (CXASTContext, CXDecl), Ctx, D)
end

function clang_ASTContext_VoidTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_VoidTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_BoolTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_BoolTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_CharTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_CharTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_WCharTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_WCharTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_WideCharTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_WideCharTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_WIntTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_WIntTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char8Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Char8Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char16Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Char16Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Char32Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Char32Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_SignedCharTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_SignedCharTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_ShortTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_ShortTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_IntTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_IntTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_LongTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongLongTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_LongLongTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Int128Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Int128Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedCharTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedCharTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedShortTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedShortTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedIntTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedIntTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedLongTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedLongTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedLongLongTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedLongLongTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_UnsignedInt128Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_UnsignedInt128Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_FloatTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_FloatTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_DoubleTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_DoubleTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongDoubleTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_LongDoubleTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float128Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Float128Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_HalfTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_HalfTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_BFloat16Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_BFloat16Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float16Ty_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Float16Ty_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_FloatComplexTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_FloatComplexTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_DoubleComplexTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_DoubleComplexTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_LongDoubleComplexTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_LongDoubleComplexTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_Float128ComplexTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_Float128ComplexTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_VoidPtrTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_VoidPtrTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_ASTContext_NullPtrTy_getAsQualType(Ctx)
    ccall((:clang_ASTContext_NullPtrTy_getAsQualType, libclangex), CXQualType, (CXASTContext,), Ctx)
end

function clang_IdentifierTable_PrintStats(IT)
    ccall((:clang_IdentifierTable_PrintStats, libclangex), Cvoid, (CXIdentifierTable,), IT)
end

function clang_IdentifierTable_get(Idents, Name)
    ccall((:clang_IdentifierTable_get, libclangex), CXIdentifierInfo, (CXIdentifierTable, Ptr{Cchar}), Idents, Name)
end

function clang_Preprocessor_getHeaderSearchInfo(PP)
    ccall((:clang_Preprocessor_getHeaderSearchInfo, libclangex), CXHeaderSearch, (CXPreprocessor,), PP)
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

function clang_Preprocessor_enableIncrementalProcessing(PP)
    ccall((:clang_Preprocessor_enableIncrementalProcessing, libclangex), Cvoid, (CXPreprocessor,), PP)
end

function clang_Preprocessor_isIncrementalProcessingEnabled(PP)
    ccall((:clang_Preprocessor_isIncrementalProcessingEnabled, libclangex), Bool, (CXPreprocessor,), PP)
end

function clang_Preprocessor_DumpToken(PP, Tok, DumpFlags)
    ccall((:clang_Preprocessor_DumpToken, libclangex), Cvoid, (CXPreprocessor, CXToken_, Bool), PP, Tok, DumpFlags)
end

function clang_Preprocessor_DumpLocation(PP, Loc)
    ccall((:clang_Preprocessor_DumpLocation, libclangex), Cvoid, (CXPreprocessor, CXSourceLocation_), PP, Loc)
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

function clang_CodeGenOptions_PrintStats(CGO)
    ccall((:clang_CodeGenOptions_PrintStats, libclangex), Cvoid, (CXCodeGenOptions,), CGO)
end

function clang_TargetInfo_CreateTargetInfo(DE, Opts)
    ccall((:clang_TargetInfo_CreateTargetInfo, libclangex), CXTargetInfo_, (CXDiagnosticsEngine, CXTargetOptions), DE, Opts)
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

function clang_Token_getAnnotationValue(Tok)
    ccall((:clang_Token_getAnnotationValue, libclangex), CXAnnotationValue, (CXToken_,), Tok)
end

function clang_Token_getLocation(Tok)
    ccall((:clang_Token_getLocation, libclangex), CXSourceLocation_, (CXToken_,), Tok)
end

function clang_Token_getAnnotationEndLoc(Tok)
    ccall((:clang_Token_getAnnotationEndLoc, libclangex), CXSourceLocation_, (CXToken_,), Tok)
end

function clang_Token_isKind_eof(Tok)
    ccall((:clang_Token_isKind_eof, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_identifier(Tok)
    ccall((:clang_Token_isKind_identifier, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_coloncolon(Tok)
    ccall((:clang_Token_isKind_coloncolon, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_annot_cxxscope(Tok)
    ccall((:clang_Token_isKind_annot_cxxscope, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_annot_typename(Tok)
    ccall((:clang_Token_isKind_annot_typename, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_annot_template_id(Tok)
    ccall((:clang_Token_isKind_annot_template_id, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_kw_enum(Tok)
    ccall((:clang_Token_isKind_kw_enum, libclangex), Bool, (CXToken_,), Tok)
end

function clang_Token_isKind_kw_typename(Tok)
    ccall((:clang_Token_isKind_kw_typename, libclangex), Bool, (CXToken_,), Tok)
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

@enum CXDeclaratorContext::UInt32 begin
    CXDeclaratorContext_File = 0
    CXDeclaratorContext_Prototype = 1
    CXDeclaratorContext_ObjCResult = 2
    CXDeclaratorContext_ObjCParameter = 3
    CXDeclaratorContext_KNRTypeList = 4
    CXDeclaratorContext_TypeName = 5
    CXDeclaratorContext_FunctionalCast = 6
    CXDeclaratorContext_Member = 7
    CXDeclaratorContext_Block = 8
    CXDeclaratorContext_ForInit = 9
    CXDeclaratorContext_SelectionInit = 10
    CXDeclaratorContext_Condition = 11
    CXDeclaratorContext_TemplateParam = 12
    CXDeclaratorContext_CXXNew = 13
    CXDeclaratorContext_CXXCatch = 14
    CXDeclaratorContext_ObjCCatch = 15
    CXDeclaratorContext_BlockLiteral = 16
    CXDeclaratorContext_LambdaExpr = 17
    CXDeclaratorContext_LambdaExprParameter = 18
    CXDeclaratorContext_ConversionId = 19
    CXDeclaratorContext_TrailingReturn = 20
    CXDeclaratorContext_TrailingReturnVar = 21
    CXDeclaratorContext_TemplateArg = 22
    CXDeclaratorContext_TemplateTypeArg = 23
    CXDeclaratorContext_AliasDecl = 24
    CXDeclaratorContext_AliasTemplate = 25
    CXDeclaratorContext_RequiresExpr = 26
end

function clang_CXXScopeSpec_create(ErrorCode)
    ccall((:clang_CXXScopeSpec_create, libclangex), CXCXXScopeSpec, (Ptr{CXInit_Error},), ErrorCode)
end

function clang_CXXScopeSpec_dispose(SS)
    ccall((:clang_CXXScopeSpec_dispose, libclangex), Cvoid, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_clear(SS)
    ccall((:clang_CXXScopeSpec_clear, libclangex), Cvoid, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_getScopeRep(SS)
    ccall((:clang_CXXScopeSpec_getScopeRep, libclangex), CXNestedNameSpecifier, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_getBeginLoc(SS)
    ccall((:clang_CXXScopeSpec_getBeginLoc, libclangex), CXSourceLocation_, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_getEndLoc(SS)
    ccall((:clang_CXXScopeSpec_getEndLoc, libclangex), CXSourceLocation_, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_setBeginLoc(SS, Loc)
    ccall((:clang_CXXScopeSpec_setBeginLoc, libclangex), Cvoid, (CXCXXScopeSpec, CXSourceLocation_), SS, Loc)
end

function clang_CXXScopeSpec_setEndLoc(SS, Loc)
    ccall((:clang_CXXScopeSpec_setEndLoc, libclangex), Cvoid, (CXCXXScopeSpec, CXSourceLocation_), SS, Loc)
end

function clang_CXXScopeSpec_isEmpty(SS)
    ccall((:clang_CXXScopeSpec_isEmpty, libclangex), Bool, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_isNotEmpty(SS)
    ccall((:clang_CXXScopeSpec_isNotEmpty, libclangex), Bool, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_isInvalid(SS)
    ccall((:clang_CXXScopeSpec_isInvalid, libclangex), Bool, (CXCXXScopeSpec,), SS)
end

function clang_CXXScopeSpec_isValid(SS)
    ccall((:clang_CXXScopeSpec_isValid, libclangex), Bool, (CXCXXScopeSpec,), SS)
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

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
