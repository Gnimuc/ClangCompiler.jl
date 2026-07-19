module LibClangEx

using ..ClangCompiler: libclangex
using ..ClangCompiler: CXString, CXStringSet
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef, LLVMGenericValueRef
using LLVM.API: LLVMTypeRef, LLVMOrcLLJITRef
using LLVM.API: LLVMOrcExecutorAddress

const time_t = Clong


struct CXArrayRef
    Data::Ptr{Cvoid}
    Length::Csize_t
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

const CXUsingType = Ptr{Cvoid}

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

const CXDeducedType = Ptr{Cvoid}

const CXAutoType = Ptr{Cvoid}

const CXDeducedTemplateSpecializationType = Ptr{Cvoid}

const CXTemplateSpecializationType = Ptr{Cvoid}

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

const CXIncrementalCompilerBuilder = Ptr{Cvoid}

const CXInterpreter = Ptr{Cvoid}

const CXPartialTranslationUnit = Ptr{Cvoid}

const CXValue = Ptr{Cvoid}

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

function clang_ASTConsumer_Initialize(Csr, Ctx)
    @ccall libclangex.clang_ASTConsumer_Initialize(Csr::CXASTConsumer, Ctx::CXASTContext)::Cvoid
end

function clang_ASTConsumer_HandleTranslationUnit(Csr, Ctx)
    @ccall libclangex.clang_ASTConsumer_HandleTranslationUnit(Csr::CXASTConsumer, Ctx::CXASTContext)::Cvoid
end

function clang_ASTConsumer_PrintStats(Csr)
    @ccall libclangex.clang_ASTConsumer_PrintStats(Csr::CXASTConsumer)::Cvoid
end

function clang_QualType_constructFromTypePtr(Ptr, Quals)
    @ccall libclangex.clang_QualType_constructFromTypePtr(Ptr::CXType_, Quals::Cuint)::CXQualType
end

function clang_QualType_getTypePtr(OpaquePtr)
    @ccall libclangex.clang_QualType_getTypePtr(OpaquePtr::CXQualType)::CXType_
end

function clang_QualType_getTypePtrOrNull(OpaquePtr)
    @ccall libclangex.clang_QualType_getTypePtrOrNull(OpaquePtr::CXQualType)::CXType_
end

function clang_QualType_isCanonical(OpaquePtr)
    @ccall libclangex.clang_QualType_isCanonical(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isNull(OpaquePtr)
    @ccall libclangex.clang_QualType_isNull(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isConstQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isConstQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isRestrictQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isRestrictQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isVolatileQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isVolatileQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_hasQualifiers(OpaquePtr)
    @ccall libclangex.clang_QualType_hasQualifiers(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_withConst(OpaquePtr)
    @ccall libclangex.clang_QualType_withConst(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_withVolatile(OpaquePtr)
    @ccall libclangex.clang_QualType_withVolatile(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_withRestrict(OpaquePtr)
    @ccall libclangex.clang_QualType_withRestrict(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_addConst(OpaquePtr)
    @ccall libclangex.clang_QualType_addConst(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_addVolatile(OpaquePtr)
    @ccall libclangex.clang_QualType_addVolatile(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_addRestrict(OpaquePtr)
    @ccall libclangex.clang_QualType_addRestrict(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_isLocalConstQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isLocalConstQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isLocalRestrictQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isLocalRestrictQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_isLocalVolatileQualified(OpaquePtr)
    @ccall libclangex.clang_QualType_isLocalVolatileQualified(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_hasLocalQualifiers(OpaquePtr)
    @ccall libclangex.clang_QualType_hasLocalQualifiers(OpaquePtr::CXQualType)::Bool
end

function clang_QualType_getCVRQualifiers(OpaquePtr)
    @ccall libclangex.clang_QualType_getCVRQualifiers(OpaquePtr::CXQualType)::Cuint
end

function clang_QualType_getAsString(OpaquePtr)
    @ccall libclangex.clang_QualType_getAsString(OpaquePtr::CXQualType)::CXString
end

function clang_QualType_dump(OpaquePtr)
    @ccall libclangex.clang_QualType_dump(OpaquePtr::CXQualType)::Cvoid
end

function clang_QualType_getCanonicalType(OpaquePtr)
    @ccall libclangex.clang_QualType_getCanonicalType(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_getLocalUnqualifiedType(OpaquePtr)
    @ccall libclangex.clang_QualType_getLocalUnqualifiedType(OpaquePtr::CXQualType)::CXQualType
end

function clang_QualType_getUnqualifiedType(OpaquePtr)
    @ccall libclangex.clang_QualType_getUnqualifiedType(OpaquePtr::CXQualType)::CXQualType
end

function clang_Type_isFromAST(T)
    @ccall libclangex.clang_Type_isFromAST(T::CXType_)::Bool
end

function clang_Type_isCanonicalUnqualified(T)
    @ccall libclangex.clang_Type_isCanonicalUnqualified(T::CXType_)::Bool
end

function clang_Type_isSizelessType(T)
    @ccall libclangex.clang_Type_isSizelessType(T::CXType_)::Bool
end

function clang_Type_isSizelessBuiltinType(T)
    @ccall libclangex.clang_Type_isSizelessBuiltinType(T::CXType_)::Bool
end

function clang_Type_isBuiltinType(T)
    @ccall libclangex.clang_Type_isBuiltinType(T::CXType_)::Bool
end

function clang_Type_isIntegerType(T)
    @ccall libclangex.clang_Type_isIntegerType(T::CXType_)::Bool
end

function clang_Type_isEnumeralType(T)
    @ccall libclangex.clang_Type_isEnumeralType(T::CXType_)::Bool
end

function clang_Type_isScopedEnumeralType(T)
    @ccall libclangex.clang_Type_isScopedEnumeralType(T::CXType_)::Bool
end

function clang_Type_isBooleanType(T)
    @ccall libclangex.clang_Type_isBooleanType(T::CXType_)::Bool
end

function clang_Type_isCharType(T)
    @ccall libclangex.clang_Type_isCharType(T::CXType_)::Bool
end

function clang_Type_isWideCharType(T)
    @ccall libclangex.clang_Type_isWideCharType(T::CXType_)::Bool
end

function clang_Type_isChar8Type(T)
    @ccall libclangex.clang_Type_isChar8Type(T::CXType_)::Bool
end

function clang_Type_isChar16Type(T)
    @ccall libclangex.clang_Type_isChar16Type(T::CXType_)::Bool
end

function clang_Type_isChar32Type(T)
    @ccall libclangex.clang_Type_isChar32Type(T::CXType_)::Bool
end

function clang_Type_isAnyCharacterType(T)
    @ccall libclangex.clang_Type_isAnyCharacterType(T::CXType_)::Bool
end

function clang_Type_isIntegralOrEnumerationType(T)
    @ccall libclangex.clang_Type_isIntegralOrEnumerationType(T::CXType_)::Bool
end

function clang_Type_isIntegralOrUnscopedEnumerationType(T)
    @ccall libclangex.clang_Type_isIntegralOrUnscopedEnumerationType(T::CXType_)::Bool
end

function clang_Type_isUnscopedEnumerationType(T)
    @ccall libclangex.clang_Type_isUnscopedEnumerationType(T::CXType_)::Bool
end

function clang_Type_isRealFloatingType(T)
    @ccall libclangex.clang_Type_isRealFloatingType(T::CXType_)::Bool
end

function clang_Type_isComplexType(T)
    @ccall libclangex.clang_Type_isComplexType(T::CXType_)::Bool
end

function clang_Type_isAnyComplexType(T)
    @ccall libclangex.clang_Type_isAnyComplexType(T::CXType_)::Bool
end

function clang_Type_isFloatingType(T)
    @ccall libclangex.clang_Type_isFloatingType(T::CXType_)::Bool
end

function clang_Type_isHalfType(T)
    @ccall libclangex.clang_Type_isHalfType(T::CXType_)::Bool
end

function clang_Type_isFloat16Type(T)
    @ccall libclangex.clang_Type_isFloat16Type(T::CXType_)::Bool
end

function clang_Type_isBFloat16Type(T)
    @ccall libclangex.clang_Type_isBFloat16Type(T::CXType_)::Bool
end

function clang_Type_isFloat128Type(T)
    @ccall libclangex.clang_Type_isFloat128Type(T::CXType_)::Bool
end

function clang_Type_isRealType(T)
    @ccall libclangex.clang_Type_isRealType(T::CXType_)::Bool
end

function clang_Type_isArithmeticType(T)
    @ccall libclangex.clang_Type_isArithmeticType(T::CXType_)::Bool
end

function clang_Type_isVoidType(T)
    @ccall libclangex.clang_Type_isVoidType(T::CXType_)::Bool
end

function clang_Type_isScalarType(T)
    @ccall libclangex.clang_Type_isScalarType(T::CXType_)::Bool
end

function clang_Type_isAggregateType(T)
    @ccall libclangex.clang_Type_isAggregateType(T::CXType_)::Bool
end

function clang_Type_isFundamentalType(T)
    @ccall libclangex.clang_Type_isFundamentalType(T::CXType_)::Bool
end

function clang_Type_isCompoundType(T)
    @ccall libclangex.clang_Type_isCompoundType(T::CXType_)::Bool
end

function clang_Type_isFunctionType(T)
    @ccall libclangex.clang_Type_isFunctionType(T::CXType_)::Bool
end

function clang_Type_isFunctionNoProtoType(T)
    @ccall libclangex.clang_Type_isFunctionNoProtoType(T::CXType_)::Bool
end

function clang_Type_isFunctionProtoType(T)
    @ccall libclangex.clang_Type_isFunctionProtoType(T::CXType_)::Bool
end

function clang_Type_isPointerType(T)
    @ccall libclangex.clang_Type_isPointerType(T::CXType_)::Bool
end

function clang_Type_isAnyPointerType(T)
    @ccall libclangex.clang_Type_isAnyPointerType(T::CXType_)::Bool
end

function clang_Type_isBlockPointerType(T)
    @ccall libclangex.clang_Type_isBlockPointerType(T::CXType_)::Bool
end

function clang_Type_isVoidPointerType(T)
    @ccall libclangex.clang_Type_isVoidPointerType(T::CXType_)::Bool
end

function clang_Type_isReferenceType(T)
    @ccall libclangex.clang_Type_isReferenceType(T::CXType_)::Bool
end

function clang_Type_isLValueReferenceType(T)
    @ccall libclangex.clang_Type_isLValueReferenceType(T::CXType_)::Bool
end

function clang_Type_isRValueReferenceType(T)
    @ccall libclangex.clang_Type_isRValueReferenceType(T::CXType_)::Bool
end

function clang_Type_isObjectPointerType(T)
    @ccall libclangex.clang_Type_isObjectPointerType(T::CXType_)::Bool
end

function clang_Type_isFunctionPointerType(T)
    @ccall libclangex.clang_Type_isFunctionPointerType(T::CXType_)::Bool
end

function clang_Type_isFunctionReferenceType(T)
    @ccall libclangex.clang_Type_isFunctionReferenceType(T::CXType_)::Bool
end

function clang_Type_isMemberPointerType(T)
    @ccall libclangex.clang_Type_isMemberPointerType(T::CXType_)::Bool
end

function clang_Type_isMemberFunctionPointerType(T)
    @ccall libclangex.clang_Type_isMemberFunctionPointerType(T::CXType_)::Bool
end

function clang_Type_isMemberDataPointerType(T)
    @ccall libclangex.clang_Type_isMemberDataPointerType(T::CXType_)::Bool
end

function clang_Type_isArrayType(T)
    @ccall libclangex.clang_Type_isArrayType(T::CXType_)::Bool
end

function clang_Type_isConstantArrayType(T)
    @ccall libclangex.clang_Type_isConstantArrayType(T::CXType_)::Bool
end

function clang_Type_isIncompleteArrayType(T)
    @ccall libclangex.clang_Type_isIncompleteArrayType(T::CXType_)::Bool
end

function clang_Type_isVariableArrayType(T)
    @ccall libclangex.clang_Type_isVariableArrayType(T::CXType_)::Bool
end

function clang_Type_isDependentSizedArrayType(T)
    @ccall libclangex.clang_Type_isDependentSizedArrayType(T::CXType_)::Bool
end

function clang_Type_isRecordType(T)
    @ccall libclangex.clang_Type_isRecordType(T::CXType_)::Bool
end

function clang_Type_isClassType(T)
    @ccall libclangex.clang_Type_isClassType(T::CXType_)::Bool
end

function clang_Type_isStructureType(T)
    @ccall libclangex.clang_Type_isStructureType(T::CXType_)::Bool
end

function clang_Type_isObjCBoxableRecordType(T)
    @ccall libclangex.clang_Type_isObjCBoxableRecordType(T::CXType_)::Bool
end

function clang_Type_isInterfaceType(T)
    @ccall libclangex.clang_Type_isInterfaceType(T::CXType_)::Bool
end

function clang_Type_isStructureOrClassType(T)
    @ccall libclangex.clang_Type_isStructureOrClassType(T::CXType_)::Bool
end

function clang_Type_isUnionType(T)
    @ccall libclangex.clang_Type_isUnionType(T::CXType_)::Bool
end

function clang_Type_isComplexIntegerType(T)
    @ccall libclangex.clang_Type_isComplexIntegerType(T::CXType_)::Bool
end

function clang_Type_isVectorType(T)
    @ccall libclangex.clang_Type_isVectorType(T::CXType_)::Bool
end

function clang_Type_isExtVectorType(T)
    @ccall libclangex.clang_Type_isExtVectorType(T::CXType_)::Bool
end

function clang_Type_isMatrixType(T)
    @ccall libclangex.clang_Type_isMatrixType(T::CXType_)::Bool
end

function clang_Type_isConstantMatrixType(T)
    @ccall libclangex.clang_Type_isConstantMatrixType(T::CXType_)::Bool
end

function clang_Type_isDependentAddressSpaceType(T)
    @ccall libclangex.clang_Type_isDependentAddressSpaceType(T::CXType_)::Bool
end

function clang_Type_isDecltypeType(T)
    @ccall libclangex.clang_Type_isDecltypeType(T::CXType_)::Bool
end

function clang_Type_isTemplateTypeParmType(T)
    @ccall libclangex.clang_Type_isTemplateTypeParmType(T::CXType_)::Bool
end

function clang_Type_isNullPtrType(T)
    @ccall libclangex.clang_Type_isNullPtrType(T::CXType_)::Bool
end

function clang_Type_isNothrowT(T)
    @ccall libclangex.clang_Type_isNothrowT(T::CXType_)::Bool
end

function clang_Type_isAlignValT(T)
    @ccall libclangex.clang_Type_isAlignValT(T::CXType_)::Bool
end

function clang_Type_isStdByteType(T)
    @ccall libclangex.clang_Type_isStdByteType(T::CXType_)::Bool
end

function clang_Type_isAtomicType(T)
    @ccall libclangex.clang_Type_isAtomicType(T::CXType_)::Bool
end

function clang_Type_isUndeducedAutoType(T)
    @ccall libclangex.clang_Type_isUndeducedAutoType(T::CXType_)::Bool
end

function clang_Type_isTypedefNameType(T)
    @ccall libclangex.clang_Type_isTypedefNameType(T::CXType_)::Bool
end

function clang_Type_isDependentType(T)
    @ccall libclangex.clang_Type_isDependentType(T::CXType_)::Bool
end

function clang_Type_isInstantiationDependentType(T)
    @ccall libclangex.clang_Type_isInstantiationDependentType(T::CXType_)::Bool
end

function clang_Type_isUndeducedType(T)
    @ccall libclangex.clang_Type_isUndeducedType(T::CXType_)::Bool
end

function clang_Type_isVariablyModifiedType(T)
    @ccall libclangex.clang_Type_isVariablyModifiedType(T::CXType_)::Bool
end

function clang_Type_hasSizedVLAType(T)
    @ccall libclangex.clang_Type_hasSizedVLAType(T::CXType_)::Bool
end

function clang_Type_hasUnnamedOrLocalType(T)
    @ccall libclangex.clang_Type_hasUnnamedOrLocalType(T::CXType_)::Bool
end

function clang_Type_isOverloadableType(T)
    @ccall libclangex.clang_Type_isOverloadableType(T::CXType_)::Bool
end

function clang_Type_isElaboratedTypeSpecifier(T)
    @ccall libclangex.clang_Type_isElaboratedTypeSpecifier(T::CXType_)::Bool
end

function clang_Type_canDecayToPointerType(T)
    @ccall libclangex.clang_Type_canDecayToPointerType(T::CXType_)::Bool
end

function clang_Type_hasPointerRepresentation(T)
    @ccall libclangex.clang_Type_hasPointerRepresentation(T::CXType_)::Bool
end

function clang_Type_hasObjCPointerRepresentation(T)
    @ccall libclangex.clang_Type_hasObjCPointerRepresentation(T::CXType_)::Bool
end

function clang_Type_hasIntegerRepresentation(T)
    @ccall libclangex.clang_Type_hasIntegerRepresentation(T::CXType_)::Bool
end

function clang_Type_hasSignedIntegerRepresentation(T)
    @ccall libclangex.clang_Type_hasSignedIntegerRepresentation(T::CXType_)::Bool
end

function clang_Type_hasUnsignedIntegerRepresentation(T)
    @ccall libclangex.clang_Type_hasUnsignedIntegerRepresentation(T::CXType_)::Bool
end

function clang_Type_hasFloatingRepresentation(T)
    @ccall libclangex.clang_Type_hasFloatingRepresentation(T::CXType_)::Bool
end

function clang_Type_getAsStructureType(T)
    @ccall libclangex.clang_Type_getAsStructureType(T::CXType_)::CXRecordType
end

function clang_Type_getAsUnionType(T)
    @ccall libclangex.clang_Type_getAsUnionType(T::CXType_)::CXRecordType
end

function clang_Type_getAsComplexIntegerType(T)
    @ccall libclangex.clang_Type_getAsComplexIntegerType(T::CXType_)::CXComplexType
end

function clang_Type_getAsCXXRecordDecl(T)
    @ccall libclangex.clang_Type_getAsCXXRecordDecl(T::CXType_)::CXCXXRecordDecl
end

function clang_Type_getAsRecordDecl(T)
    @ccall libclangex.clang_Type_getAsRecordDecl(T::CXType_)::CXRecordDecl
end

function clang_Type_getAsTagDecl(T)
    @ccall libclangex.clang_Type_getAsTagDecl(T::CXType_)::CXTagDecl
end

function clang_Type_getPointeeCXXRecordDecl(T)
    @ccall libclangex.clang_Type_getPointeeCXXRecordDecl(T::CXType_)::CXCXXRecordDecl
end

function clang_Type_getContainedDeducedType(T)
    @ccall libclangex.clang_Type_getContainedDeducedType(T::CXType_)::CXDeducedType
end

function clang_Type_hasAutoForTrailingReturnType(T)
    @ccall libclangex.clang_Type_hasAutoForTrailingReturnType(T::CXType_)::Bool
end

function clang_Type_getArrayElementTypeNoTypeQual(T)
    @ccall libclangex.clang_Type_getArrayElementTypeNoTypeQual(T::CXType_)::CXType_
end

function clang_Type_getPointeeOrArrayElementType(T)
    @ccall libclangex.clang_Type_getPointeeOrArrayElementType(T::CXType_)::CXType_
end

function clang_Type_getPointeeType(T)
    @ccall libclangex.clang_Type_getPointeeType(T::CXType_)::CXQualType
end

function clang_Type_getUnqualifiedDesugaredType(T)
    @ccall libclangex.clang_Type_getUnqualifiedDesugaredType(T::CXType_)::CXType_
end

function clang_Type_isSignedIntegerType(T)
    @ccall libclangex.clang_Type_isSignedIntegerType(T::CXType_)::Bool
end

function clang_Type_isUnsignedIntegerType(T)
    @ccall libclangex.clang_Type_isUnsignedIntegerType(T::CXType_)::Bool
end

function clang_Type_isSignedIntegerOrEnumerationType(T)
    @ccall libclangex.clang_Type_isSignedIntegerOrEnumerationType(T::CXType_)::Bool
end

function clang_Type_isUnsignedIntegerOrEnumerationType(T)
    @ccall libclangex.clang_Type_isUnsignedIntegerOrEnumerationType(T::CXType_)::Bool
end

function clang_Type_isFixedPointType(T)
    @ccall libclangex.clang_Type_isFixedPointType(T::CXType_)::Bool
end

function clang_Type_isFixedPointOrIntegerType(T)
    @ccall libclangex.clang_Type_isFixedPointOrIntegerType(T::CXType_)::Bool
end

function clang_Type_isSaturatedFixedPointType(T)
    @ccall libclangex.clang_Type_isSaturatedFixedPointType(T::CXType_)::Bool
end

function clang_Type_isUnsaturatedFixedPointType(T)
    @ccall libclangex.clang_Type_isUnsaturatedFixedPointType(T::CXType_)::Bool
end

function clang_Type_isSignedFixedPointType(T)
    @ccall libclangex.clang_Type_isSignedFixedPointType(T::CXType_)::Bool
end

function clang_Type_isUnsignedFixedPointType(T)
    @ccall libclangex.clang_Type_isUnsignedFixedPointType(T::CXType_)::Bool
end

function clang_Type_isConstantSizeType(T)
    @ccall libclangex.clang_Type_isConstantSizeType(T::CXType_)::Bool
end

function clang_Type_isSpecifierType(T)
    @ccall libclangex.clang_Type_isSpecifierType(T::CXType_)::Bool
end

function clang_Type_isVisibilityExplicit(T)
    @ccall libclangex.clang_Type_isVisibilityExplicit(T::CXType_)::Bool
end

function clang_Type_isLinkageValid(T)
    @ccall libclangex.clang_Type_isLinkageValid(T::CXType_)::Bool
end

function clang_Type_getCanonicalTypeInternal(T)
    @ccall libclangex.clang_Type_getCanonicalTypeInternal(T::CXType_)::CXQualType
end

function clang_Type_dump(T)
    @ccall libclangex.clang_Type_dump(T::CXType_)::Cvoid
end

function clang_isa_ComplexType(T)
    @ccall libclangex.clang_isa_ComplexType(T::CXType_)::Bool
end

function clang_isa_PointerType(T)
    @ccall libclangex.clang_isa_PointerType(T::CXType_)::Bool
end

function clang_isa_ReferenceType(T)
    @ccall libclangex.clang_isa_ReferenceType(T::CXType_)::Bool
end

function clang_isa_LValueReferenceType(T)
    @ccall libclangex.clang_isa_LValueReferenceType(T::CXType_)::Bool
end

function clang_isa_RValueReferenceType(T)
    @ccall libclangex.clang_isa_RValueReferenceType(T::CXType_)::Bool
end

function clang_isa_MemberPointerType(T)
    @ccall libclangex.clang_isa_MemberPointerType(T::CXType_)::Bool
end

function clang_isa_ArrayType(T)
    @ccall libclangex.clang_isa_ArrayType(T::CXType_)::Bool
end

function clang_isa_ConstantArrayType(T)
    @ccall libclangex.clang_isa_ConstantArrayType(T::CXType_)::Bool
end

function clang_isa_IncompleteArrayType(T)
    @ccall libclangex.clang_isa_IncompleteArrayType(T::CXType_)::Bool
end

function clang_isa_VariableArrayType(T)
    @ccall libclangex.clang_isa_VariableArrayType(T::CXType_)::Bool
end

function clang_isa_DependentSizedArrayType(T)
    @ccall libclangex.clang_isa_DependentSizedArrayType(T::CXType_)::Bool
end

function clang_isa_FunctionType(T)
    @ccall libclangex.clang_isa_FunctionType(T::CXType_)::Bool
end

function clang_isa_FunctionNoProtoType(T)
    @ccall libclangex.clang_isa_FunctionNoProtoType(T::CXType_)::Bool
end

function clang_isa_FunctionProtoType(T)
    @ccall libclangex.clang_isa_FunctionProtoType(T::CXType_)::Bool
end

function clang_isa_UnresolvedUsingType(T)
    @ccall libclangex.clang_isa_UnresolvedUsingType(T::CXType_)::Bool
end

function clang_isa_UsingType(T)
    @ccall libclangex.clang_isa_UsingType(T::CXType_)::Bool
end

function clang_isa_TypedefType(T)
    @ccall libclangex.clang_isa_TypedefType(T::CXType_)::Bool
end

function clang_isa_DecltypeType(T)
    @ccall libclangex.clang_isa_DecltypeType(T::CXType_)::Bool
end

function clang_isa_DependentDecltypeType(T)
    @ccall libclangex.clang_isa_DependentDecltypeType(T::CXType_)::Bool
end

function clang_isa_TagType(T)
    @ccall libclangex.clang_isa_TagType(T::CXType_)::Bool
end

function clang_isa_RecordType(T)
    @ccall libclangex.clang_isa_RecordType(T::CXType_)::Bool
end

function clang_isa_EnumType(T)
    @ccall libclangex.clang_isa_EnumType(T::CXType_)::Bool
end

function clang_isa_TemplateTypeParmType(T)
    @ccall libclangex.clang_isa_TemplateTypeParmType(T::CXType_)::Bool
end

function clang_isa_SubstTemplateTypeParmType(T)
    @ccall libclangex.clang_isa_SubstTemplateTypeParmType(T::CXType_)::Bool
end

function clang_isa_SubstTemplateTypeParmPackType(T)
    @ccall libclangex.clang_isa_SubstTemplateTypeParmPackType(T::CXType_)::Bool
end

function clang_isa_DeducedType(T)
    @ccall libclangex.clang_isa_DeducedType(T::CXType_)::Bool
end

function clang_isa_AutoType(T)
    @ccall libclangex.clang_isa_AutoType(T::CXType_)::Bool
end

function clang_isa_DeducedTemplateSpecializationType(T)
    @ccall libclangex.clang_isa_DeducedTemplateSpecializationType(T::CXType_)::Bool
end

function clang_isa_TemplateSpecializationType(T)
    @ccall libclangex.clang_isa_TemplateSpecializationType(T::CXType_)::Bool
end

function clang_isa_ElaboratedType(T)
    @ccall libclangex.clang_isa_ElaboratedType(T::CXType_)::Bool
end

function clang_isa_DependentNameType(T)
    @ccall libclangex.clang_isa_DependentNameType(T::CXType_)::Bool
end

function clang_isa_DependentTemplateSpecializationType(T)
    @ccall libclangex.clang_isa_DependentTemplateSpecializationType(T::CXType_)::Bool
end

function clang_isa_AtomicType(T)
    @ccall libclangex.clang_isa_AtomicType(T::CXType_)::Bool
end

function clang_isa_DecayedType(T)
    @ccall libclangex.clang_isa_DecayedType(T::CXType_)::Bool
end

function clang_isa_AdjustedType(T)
    @ccall libclangex.clang_isa_AdjustedType(T::CXType_)::Bool
end

function clang_isa_InjectedClassNameType(T)
    @ccall libclangex.clang_isa_InjectedClassNameType(T::CXType_)::Bool
end

function clang_isa_MacroQualifiedType(T)
    @ccall libclangex.clang_isa_MacroQualifiedType(T::CXType_)::Bool
end

function clang_isa_UnaryTransformType(T)
    @ccall libclangex.clang_isa_UnaryTransformType(T::CXType_)::Bool
end

function clang_isa_ParenType(T)
    @ccall libclangex.clang_isa_ParenType(T::CXType_)::Bool
end

function clang_isa_DependentAddressSpaceType(T)
    @ccall libclangex.clang_isa_DependentAddressSpaceType(T::CXType_)::Bool
end

function clang_isa_DependentSizedExtVectorType(T)
    @ccall libclangex.clang_isa_DependentSizedExtVectorType(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Void(T)
    @ccall libclangex.clang_isa_BuiltinType_Void(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Bool(T)
    @ccall libclangex.clang_isa_BuiltinType_Bool(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Char_U(T)
    @ccall libclangex.clang_isa_BuiltinType_Char_U(T::CXType_)::Bool
end

function clang_isa_BuiltinType_UChar(T)
    @ccall libclangex.clang_isa_BuiltinType_UChar(T::CXType_)::Bool
end

function clang_isa_BuiltinType_WChar_U(T)
    @ccall libclangex.clang_isa_BuiltinType_WChar_U(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Char8(T)
    @ccall libclangex.clang_isa_BuiltinType_Char8(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Char16(T)
    @ccall libclangex.clang_isa_BuiltinType_Char16(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Char32(T)
    @ccall libclangex.clang_isa_BuiltinType_Char32(T::CXType_)::Bool
end

function clang_isa_BuiltinType_UShort(T)
    @ccall libclangex.clang_isa_BuiltinType_UShort(T::CXType_)::Bool
end

function clang_isa_BuiltinType_UInt(T)
    @ccall libclangex.clang_isa_BuiltinType_UInt(T::CXType_)::Bool
end

function clang_isa_BuiltinType_ULong(T)
    @ccall libclangex.clang_isa_BuiltinType_ULong(T::CXType_)::Bool
end

function clang_isa_BuiltinType_ULongLong(T)
    @ccall libclangex.clang_isa_BuiltinType_ULongLong(T::CXType_)::Bool
end

function clang_isa_BuiltinType_UInt128(T)
    @ccall libclangex.clang_isa_BuiltinType_UInt128(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Char_S(T)
    @ccall libclangex.clang_isa_BuiltinType_Char_S(T::CXType_)::Bool
end

function clang_isa_BuiltinType_SChar(T)
    @ccall libclangex.clang_isa_BuiltinType_SChar(T::CXType_)::Bool
end

function clang_isa_BuiltinType_WChar_S(T)
    @ccall libclangex.clang_isa_BuiltinType_WChar_S(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Short(T)
    @ccall libclangex.clang_isa_BuiltinType_Short(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Int(T)
    @ccall libclangex.clang_isa_BuiltinType_Int(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Long(T)
    @ccall libclangex.clang_isa_BuiltinType_Long(T::CXType_)::Bool
end

function clang_isa_BuiltinType_LongLong(T)
    @ccall libclangex.clang_isa_BuiltinType_LongLong(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Int128(T)
    @ccall libclangex.clang_isa_BuiltinType_Int128(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Half(T)
    @ccall libclangex.clang_isa_BuiltinType_Half(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Float(T)
    @ccall libclangex.clang_isa_BuiltinType_Float(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Double(T)
    @ccall libclangex.clang_isa_BuiltinType_Double(T::CXType_)::Bool
end

function clang_isa_BuiltinType_LongDouble(T)
    @ccall libclangex.clang_isa_BuiltinType_LongDouble(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Float16(T)
    @ccall libclangex.clang_isa_BuiltinType_Float16(T::CXType_)::Bool
end

function clang_isa_BuiltinType_BFloat16(T)
    @ccall libclangex.clang_isa_BuiltinType_BFloat16(T::CXType_)::Bool
end

function clang_isa_BuiltinType_Float128(T)
    @ccall libclangex.clang_isa_BuiltinType_Float128(T::CXType_)::Bool
end

function clang_isa_BuiltinType_NullPtr(T)
    @ccall libclangex.clang_isa_BuiltinType_NullPtr(T::CXType_)::Bool
end

function clang_ComplexType_getElementType(T)
    @ccall libclangex.clang_ComplexType_getElementType(T::CXComplexType)::CXQualType
end

function clang_ComplexType_isSugared(T)
    @ccall libclangex.clang_ComplexType_isSugared(T::CXComplexType)::Bool
end

function clang_ComplexType_desugar(T)
    @ccall libclangex.clang_ComplexType_desugar(T::CXComplexType)::CXQualType
end

function clang_ParenType_getInnerType(T)
    @ccall libclangex.clang_ParenType_getInnerType(T::CXParenType)::CXQualType
end

function clang_ParenType_isSugared(T)
    @ccall libclangex.clang_ParenType_isSugared(T::CXParenType)::Bool
end

function clang_ParenType_desugar(T)
    @ccall libclangex.clang_ParenType_desugar(T::CXParenType)::CXQualType
end

function clang_PointerType_getPointeeType(T)
    @ccall libclangex.clang_PointerType_getPointeeType(T::CXPointerType)::CXQualType
end

function clang_PointerType_isSugared(T)
    @ccall libclangex.clang_PointerType_isSugared(T::CXPointerType)::Bool
end

function clang_PointerType_desugar(T)
    @ccall libclangex.clang_PointerType_desugar(T::CXPointerType)::CXQualType
end

function clang_AdjustedType_getOriginalType(T)
    @ccall libclangex.clang_AdjustedType_getOriginalType(T::CXAdjustedType)::CXQualType
end

function clang_AdjustedType_getAdjustedType(T)
    @ccall libclangex.clang_AdjustedType_getAdjustedType(T::CXAdjustedType)::CXQualType
end

function clang_AdjustedType_isSugared(T)
    @ccall libclangex.clang_AdjustedType_isSugared(T::CXAdjustedType)::Bool
end

function clang_AdjustedType_desugar(T)
    @ccall libclangex.clang_AdjustedType_desugar(T::CXAdjustedType)::CXQualType
end

function clang_DecayedType_getDecayedType(T)
    @ccall libclangex.clang_DecayedType_getDecayedType(T::CXDecayedType)::CXQualType
end

function clang_DecayedType_getPointeeType(T)
    @ccall libclangex.clang_DecayedType_getPointeeType(T::CXDecayedType)::CXQualType
end

function clang_ReferenceType_isSpelledAsLValue(T)
    @ccall libclangex.clang_ReferenceType_isSpelledAsLValue(T::CXReferenceType)::Bool
end

function clang_ReferenceType_isInnerRef(T)
    @ccall libclangex.clang_ReferenceType_isInnerRef(T::CXReferenceType)::Bool
end

function clang_ReferenceType_getPointeeTypeAsWritten(T)
    @ccall libclangex.clang_ReferenceType_getPointeeTypeAsWritten(T::CXReferenceType)::CXQualType
end

function clang_ReferenceType_getPointeeType(T)
    @ccall libclangex.clang_ReferenceType_getPointeeType(T::CXReferenceType)::CXQualType
end

function clang_LValueReferenceType_isSugared(T)
    @ccall libclangex.clang_LValueReferenceType_isSugared(T::CXLValueReferenceType)::Bool
end

function clang_LValueReferenceType_desugar(T)
    @ccall libclangex.clang_LValueReferenceType_desugar(T::CXLValueReferenceType)::CXQualType
end

function clang_RValueReferenceType_isSugared(T)
    @ccall libclangex.clang_RValueReferenceType_isSugared(T::CXRValueReferenceType)::Bool
end

function clang_RValueReferenceType_desugar(T)
    @ccall libclangex.clang_RValueReferenceType_desugar(T::CXRValueReferenceType)::CXQualType
end

function clang_MemberPointerType_getPointeeType(T)
    @ccall libclangex.clang_MemberPointerType_getPointeeType(T::CXMemberPointerType)::CXQualType
end

function clang_MemberPointerType_isMemberFunctionPointer(T)
    @ccall libclangex.clang_MemberPointerType_isMemberFunctionPointer(T::CXMemberPointerType)::Bool
end

function clang_MemberPointerType_isMemberDataPointer(T)
    @ccall libclangex.clang_MemberPointerType_isMemberDataPointer(T::CXMemberPointerType)::Bool
end

function clang_MemberPointerType_getClass(T)
    @ccall libclangex.clang_MemberPointerType_getClass(T::CXMemberPointerType)::CXType_
end

function clang_MemberPointerType_getMostRecentCXXRecordDecl(T)
    @ccall libclangex.clang_MemberPointerType_getMostRecentCXXRecordDecl(T::CXMemberPointerType)::CXCXXRecordDecl
end

function clang_MemberPointerType_isSugared(T)
    @ccall libclangex.clang_MemberPointerType_isSugared(T::CXMemberPointerType)::Bool
end

function clang_MemberPointerType_desugar(T)
    @ccall libclangex.clang_MemberPointerType_desugar(T::CXMemberPointerType)::CXQualType
end

@enum CXArraySizeModifier::UInt32 begin
    CXArraySizeModifier_Normal = 0
    CXArraySizeModifier_Static = 1
    CXArraySizeModifier_Star = 2
end

function clang_ArrayType_getElementType(T)
    @ccall libclangex.clang_ArrayType_getElementType(T::CXArrayType)::CXQualType
end

function clang_ArrayType_getSizeModifier(T)
    @ccall libclangex.clang_ArrayType_getSizeModifier(T::CXArrayType)::CXArraySizeModifier
end

function clang_ArrayType_getIndexTypeCVRQualifiers(T)
    @ccall libclangex.clang_ArrayType_getIndexTypeCVRQualifiers(T::CXArrayType)::Cuint
end

function clang_ConstantArrayType_getSizeExpr(T)
    @ccall libclangex.clang_ConstantArrayType_getSizeExpr(T::CXConstantArrayType)::CXExpr
end

function clang_ConstantArrayType_isSugared(T)
    @ccall libclangex.clang_ConstantArrayType_isSugared(T::CXConstantArrayType)::Bool
end

function clang_ConstantArrayType_desugar(T)
    @ccall libclangex.clang_ConstantArrayType_desugar(T::CXConstantArrayType)::CXQualType
end

function clang_ConstantArrayType_getNumAddressingBits(T, C)
    @ccall libclangex.clang_ConstantArrayType_getNumAddressingBits(T::CXConstantArrayType, C::CXASTContext)::Cuint
end

function clang_IncompleteArrayType_isSugared(T)
    @ccall libclangex.clang_IncompleteArrayType_isSugared(T::CXIncompleteArrayType)::Bool
end

function clang_IncompleteArrayType_desugar(T)
    @ccall libclangex.clang_IncompleteArrayType_desugar(T::CXIncompleteArrayType)::CXQualType
end

function clang_VariableArrayType_getSizeExpr(T)
    @ccall libclangex.clang_VariableArrayType_getSizeExpr(T::CXVariableArrayType)::CXExpr
end

function clang_VariableArrayType_isSugared(T)
    @ccall libclangex.clang_VariableArrayType_isSugared(T::CXVariableArrayType)::Bool
end

function clang_VariableArrayType_desugar(T)
    @ccall libclangex.clang_VariableArrayType_desugar(T::CXVariableArrayType)::CXQualType
end

function clang_DependentSizedArrayType_getSizeExpr(T)
    @ccall libclangex.clang_DependentSizedArrayType_getSizeExpr(T::CXDependentSizedArrayType)::CXExpr
end

function clang_DependentSizedArrayType_isSugared(T)
    @ccall libclangex.clang_DependentSizedArrayType_isSugared(T::CXDependentSizedArrayType)::Bool
end

function clang_DependentSizedArrayType_desugar(T)
    @ccall libclangex.clang_DependentSizedArrayType_desugar(T::CXDependentSizedArrayType)::CXQualType
end

function clang_DependentAddressSpaceType_getAddrSpaceExpr(T)
    @ccall libclangex.clang_DependentAddressSpaceType_getAddrSpaceExpr(T::CXDependentAddressSpaceType)::CXExpr
end

function clang_DependentAddressSpaceType_getPointeeType(T)
    @ccall libclangex.clang_DependentAddressSpaceType_getPointeeType(T::CXDependentAddressSpaceType)::CXQualType
end

function clang_DependentAddressSpaceType_isSugared(T)
    @ccall libclangex.clang_DependentAddressSpaceType_isSugared(T::CXDependentAddressSpaceType)::Bool
end

function clang_DependentAddressSpaceType_desugar(T)
    @ccall libclangex.clang_DependentAddressSpaceType_desugar(T::CXDependentAddressSpaceType)::CXQualType
end

function clang_DependentSizedExtVectorType_getSizeExpr(T)
    @ccall libclangex.clang_DependentSizedExtVectorType_getSizeExpr(T::CXDependentSizedExtVectorType)::CXExpr
end

function clang_DependentSizedExtVectorType_getElementType(T)
    @ccall libclangex.clang_DependentSizedExtVectorType_getElementType(T::CXDependentSizedExtVectorType)::CXQualType
end

function clang_DependentSizedExtVectorType_isSugared(T)
    @ccall libclangex.clang_DependentSizedExtVectorType_isSugared(T::CXDependentSizedExtVectorType)::Bool
end

function clang_DependentSizedExtVectorType_desugar(T)
    @ccall libclangex.clang_DependentSizedExtVectorType_desugar(T::CXDependentSizedExtVectorType)::CXQualType
end

function clang_FunctionType_getReturnType(T)
    @ccall libclangex.clang_FunctionType_getReturnType(T::CXFunctionType)::CXQualType
end

function clang_FunctionType_getHasRegParm(T)
    @ccall libclangex.clang_FunctionType_getHasRegParm(T::CXFunctionType)::Bool
end

function clang_FunctionType_getRegParmType(T)
    @ccall libclangex.clang_FunctionType_getRegParmType(T::CXFunctionType)::Cuint
end

function clang_FunctionType_getNoReturnAttr(T)
    @ccall libclangex.clang_FunctionType_getNoReturnAttr(T::CXFunctionType)::Bool
end

function clang_FunctionType_getCmseNSCallAttr(T)
    @ccall libclangex.clang_FunctionType_getCmseNSCallAttr(T::CXFunctionType)::Bool
end

function clang_FunctionType_isConst(T)
    @ccall libclangex.clang_FunctionType_isConst(T::CXFunctionType)::Bool
end

function clang_FunctionType_isRestrict(T)
    @ccall libclangex.clang_FunctionType_isRestrict(T::CXFunctionType)::Bool
end

function clang_FunctionType_isVolatile(T)
    @ccall libclangex.clang_FunctionType_isVolatile(T::CXFunctionType)::Bool
end

function clang_FunctionNoProtoType_isSugared(T)
    @ccall libclangex.clang_FunctionNoProtoType_isSugared(T::CXFunctionNoProtoType)::Bool
end

function clang_FunctionNoProtoType_desugar(T)
    @ccall libclangex.clang_FunctionNoProtoType_desugar(T::CXFunctionNoProtoType)::CXQualType
end

function clang_FunctionProtoType_getNumParams(T)
    @ccall libclangex.clang_FunctionProtoType_getNumParams(T::CXFunctionProtoType)::Cuint
end

function clang_FunctionProtoType_getParamType(T, i)
    @ccall libclangex.clang_FunctionProtoType_getParamType(T::CXFunctionProtoType, i::Cuint)::CXQualType
end

function clang_FunctionProtoType_getParamTypes(T)
    @ccall libclangex.clang_FunctionProtoType_getParamTypes(T::CXFunctionProtoType)::CXArrayRef
end

function clang_FunctionProtoType_hasExceptionSpec(T)
    @ccall libclangex.clang_FunctionProtoType_hasExceptionSpec(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_hasDynamicExceptionSpec(T)
    @ccall libclangex.clang_FunctionProtoType_hasDynamicExceptionSpec(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_hasNoexceptExceptionSpec(T)
    @ccall libclangex.clang_FunctionProtoType_hasNoexceptExceptionSpec(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_hasDependentExceptionSpec(T)
    @ccall libclangex.clang_FunctionProtoType_hasDependentExceptionSpec(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(T)
    @ccall libclangex.clang_FunctionProtoType_hasInstantiationDependentExceptionSpec(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_getNumExceptions(T)
    @ccall libclangex.clang_FunctionProtoType_getNumExceptions(T::CXFunctionProtoType)::Cuint
end

function clang_FunctionProtoType_getExceptionType(T, i)
    @ccall libclangex.clang_FunctionProtoType_getExceptionType(T::CXFunctionProtoType, i::Cuint)::CXQualType
end

function clang_FunctionProtoType_getNoexceptExpr(T)
    @ccall libclangex.clang_FunctionProtoType_getNoexceptExpr(T::CXFunctionProtoType)::CXExpr
end

function clang_FunctionProtoType_getExceptionSpecDecl(T)
    @ccall libclangex.clang_FunctionProtoType_getExceptionSpecDecl(T::CXFunctionProtoType)::CXFunctionDecl
end

function clang_FunctionProtoType_getExceptionSpecTemplate(T)
    @ccall libclangex.clang_FunctionProtoType_getExceptionSpecTemplate(T::CXFunctionProtoType)::CXFunctionDecl
end

function clang_FunctionProtoType_isNothrow(T)
    @ccall libclangex.clang_FunctionProtoType_isNothrow(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_isVariadic(T)
    @ccall libclangex.clang_FunctionProtoType_isVariadic(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_isTemplateVariadic(T)
    @ccall libclangex.clang_FunctionProtoType_isTemplateVariadic(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_hasTrailingReturn(T)
    @ccall libclangex.clang_FunctionProtoType_hasTrailingReturn(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_param_types(T)
    @ccall libclangex.clang_FunctionProtoType_param_types(T::CXFunctionProtoType)::CXArrayRef
end

function clang_FunctionProtoType_exceptions(T)
    @ccall libclangex.clang_FunctionProtoType_exceptions(T::CXFunctionProtoType)::CXArrayRef
end

function clang_FunctionProtoType_isSugared(T)
    @ccall libclangex.clang_FunctionProtoType_isSugared(T::CXFunctionProtoType)::Bool
end

function clang_FunctionProtoType_desugar(T)
    @ccall libclangex.clang_FunctionProtoType_desugar(T::CXFunctionProtoType)::CXQualType
end

function clang_UnresolvedUsingType_getDecl(T)
    @ccall libclangex.clang_UnresolvedUsingType_getDecl(T::CXUnresolvedUsingType)::CXUnresolvedUsingTypenameDecl
end

function clang_UnresolvedUsingType_isSugared(T)
    @ccall libclangex.clang_UnresolvedUsingType_isSugared(T::CXUnresolvedUsingType)::Bool
end

function clang_UnresolvedUsingType_desugar(T)
    @ccall libclangex.clang_UnresolvedUsingType_desugar(T::CXUnresolvedUsingType)::CXQualType
end

function clang_UsingType_getFoundDecl(T)
    @ccall libclangex.clang_UsingType_getFoundDecl(T::CXUsingType)::CXUsingShadowDecl
end

function clang_UsingType_getUnderlyingType(T)
    @ccall libclangex.clang_UsingType_getUnderlyingType(T::CXUsingType)::CXQualType
end

function clang_UsingType_isSugared(T)
    @ccall libclangex.clang_UsingType_isSugared(T::CXUsingType)::Bool
end

function clang_UsingType_desugar(T)
    @ccall libclangex.clang_UsingType_desugar(T::CXUsingType)::CXQualType
end

function clang_TypedefType_getDecl(T)
    @ccall libclangex.clang_TypedefType_getDecl(T::CXTypedefType)::CXTypedefNameDecl
end

function clang_TypedefType_isSugared(T)
    @ccall libclangex.clang_TypedefType_isSugared(T::CXTypedefType)::Bool
end

function clang_TypedefType_desugar(T)
    @ccall libclangex.clang_TypedefType_desugar(T::CXTypedefType)::CXQualType
end

function clang_MacroQualifiedType_getMacroIdentifier(T)
    @ccall libclangex.clang_MacroQualifiedType_getMacroIdentifier(T::CXMacroQualifiedType)::CXIdentifierInfo
end

function clang_MacroQualifiedType_getUnderlyingType(T)
    @ccall libclangex.clang_MacroQualifiedType_getUnderlyingType(T::CXMacroQualifiedType)::CXQualType
end

function clang_MacroQualifiedType_getModifiedType(T)
    @ccall libclangex.clang_MacroQualifiedType_getModifiedType(T::CXMacroQualifiedType)::CXQualType
end

function clang_MacroQualifiedType_isSugared(T)
    @ccall libclangex.clang_MacroQualifiedType_isSugared(T::CXMacroQualifiedType)::Bool
end

function clang_MacroQualifiedType_desugar(T)
    @ccall libclangex.clang_MacroQualifiedType_desugar(T::CXMacroQualifiedType)::CXQualType
end

function clang_DecltypeType_getUnderlyingExpr(T)
    @ccall libclangex.clang_DecltypeType_getUnderlyingExpr(T::CXDecltypeType)::CXExpr
end

function clang_DecltypeType_getUnderlyingType(T)
    @ccall libclangex.clang_DecltypeType_getUnderlyingType(T::CXDecltypeType)::CXQualType
end

function clang_DecltypeType_isSugared(T)
    @ccall libclangex.clang_DecltypeType_isSugared(T::CXDecltypeType)::Bool
end

function clang_DecltypeType_desugar(T)
    @ccall libclangex.clang_DecltypeType_desugar(T::CXDecltypeType)::CXQualType
end

function clang_UnaryTransformType_isSugared(T)
    @ccall libclangex.clang_UnaryTransformType_isSugared(T::CXUnaryTransformType)::Bool
end

function clang_UnaryTransformType_desugar(T)
    @ccall libclangex.clang_UnaryTransformType_desugar(T::CXUnaryTransformType)::CXQualType
end

function clang_UnaryTransformType_getUnderlyingType(T)
    @ccall libclangex.clang_UnaryTransformType_getUnderlyingType(T::CXUnaryTransformType)::CXQualType
end

function clang_UnaryTransformType_getBaseType(T)
    @ccall libclangex.clang_UnaryTransformType_getBaseType(T::CXUnaryTransformType)::CXQualType
end

function clang_TagType_getDecl(T)
    @ccall libclangex.clang_TagType_getDecl(T::CXTagType)::CXTagDecl
end

function clang_RecordType_getDecl(T)
    @ccall libclangex.clang_RecordType_getDecl(T::CXRecordType)::CXRecordDecl
end

function clang_RecordType_hasConstFields(T)
    @ccall libclangex.clang_RecordType_hasConstFields(T::CXRecordType)::Bool
end

function clang_RecordType_isSugared(T)
    @ccall libclangex.clang_RecordType_isSugared(T::CXRecordType)::Bool
end

function clang_RecordType_desugar(T)
    @ccall libclangex.clang_RecordType_desugar(T::CXRecordType)::CXQualType
end

function clang_EnumType_getDecl(T)
    @ccall libclangex.clang_EnumType_getDecl(T::CXEnumType)::CXEnumDecl
end

function clang_EnumType_isSugared(T)
    @ccall libclangex.clang_EnumType_isSugared(T::CXEnumType)::Bool
end

function clang_EnumType_desugar(T)
    @ccall libclangex.clang_EnumType_desugar(T::CXEnumType)::CXQualType
end

function clang_TemplateTypeParmType_getDepth(T)
    @ccall libclangex.clang_TemplateTypeParmType_getDepth(T::CXTemplateTypeParmType)::Cuint
end

function clang_TemplateTypeParmType_getIndex(T)
    @ccall libclangex.clang_TemplateTypeParmType_getIndex(T::CXTemplateTypeParmType)::Cuint
end

function clang_TemplateTypeParmType_isParameterPack(T)
    @ccall libclangex.clang_TemplateTypeParmType_isParameterPack(T::CXTemplateTypeParmType)::Bool
end

function clang_TemplateTypeParmType_getDecl(T)
    @ccall libclangex.clang_TemplateTypeParmType_getDecl(T::CXTemplateTypeParmType)::CXTemplateTypeParmDecl
end

function clang_TemplateTypeParmType_isSugared(T)
    @ccall libclangex.clang_TemplateTypeParmType_isSugared(T::CXTemplateTypeParmType)::Bool
end

function clang_TemplateTypeParmType_desugar(T)
    @ccall libclangex.clang_TemplateTypeParmType_desugar(T::CXTemplateTypeParmType)::CXQualType
end

function clang_SubstTemplateTypeParmType_getReplacementType(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_getReplacementType(T::CXSubstTemplateTypeParmType)::CXQualType
end

function clang_SubstTemplateTypeParmType_getAssociatedDecl(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_getAssociatedDecl(T::CXSubstTemplateTypeParmType)::CXDecl
end

function clang_SubstTemplateTypeParmType_getReplacedParameter(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_getReplacedParameter(T::CXSubstTemplateTypeParmType)::CXTemplateTypeParmDecl
end

function clang_SubstTemplateTypeParmType_getIndex(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_getIndex(T::CXSubstTemplateTypeParmType)::Cuint
end

function clang_SubstTemplateTypeParmType_isSugared(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_isSugared(T::CXSubstTemplateTypeParmType)::Bool
end

function clang_SubstTemplateTypeParmType_desugar(T)
    @ccall libclangex.clang_SubstTemplateTypeParmType_desugar(T::CXSubstTemplateTypeParmType)::CXQualType
end

function clang_SubstTemplateTypeParmPackType_getAssociatedDecl(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getAssociatedDecl(T::CXSubstTemplateTypeParmPackType)::CXDecl
end

function clang_SubstTemplateTypeParmPackType_getReplacedParameter(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getReplacedParameter(T::CXSubstTemplateTypeParmPackType)::CXTemplateTypeParmDecl
end

function clang_SubstTemplateTypeParmPackType_getIndex(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getIndex(T::CXSubstTemplateTypeParmPackType)::Cuint
end

function clang_SubstTemplateTypeParmPackType_getFinal(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getFinal(T::CXSubstTemplateTypeParmPackType)::Bool
end

function clang_SubstTemplateTypeParmPackType_getNumArgs(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getNumArgs(T::CXSubstTemplateTypeParmPackType)::Cuint
end

function clang_SubstTemplateTypeParmPackType_isSugared(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_isSugared(T::CXSubstTemplateTypeParmPackType)::Bool
end

function clang_SubstTemplateTypeParmPackType_desugar(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_desugar(T::CXSubstTemplateTypeParmPackType)::CXQualType
end

function clang_SubstTemplateTypeParmPackType_getArgumentPack(T)
    @ccall libclangex.clang_SubstTemplateTypeParmPackType_getArgumentPack(T::CXSubstTemplateTypeParmPackType)::CXArrayRef
end

function clang_DeducedType_isSugared(T)
    @ccall libclangex.clang_DeducedType_isSugared(T::CXDeducedType)::Bool
end

function clang_DeducedType_desugar(T)
    @ccall libclangex.clang_DeducedType_desugar(T::CXDeducedType)::CXQualType
end

function clang_DeducedType_getDeducedType(T)
    @ccall libclangex.clang_DeducedType_getDeducedType(T::CXDeducedType)::CXQualType
end

function clang_DeducedType_isDeduced(T)
    @ccall libclangex.clang_DeducedType_isDeduced(T::CXDeducedType)::Bool
end

function clang_DeducedTemplateSpecializationType_getTemplateName(T)
    @ccall libclangex.clang_DeducedTemplateSpecializationType_getTemplateName(T::CXDeducedTemplateSpecializationType)::CXTemplateName
end

function clang_TemplateSpecializationType_isCurrentInstantiation(T)
    @ccall libclangex.clang_TemplateSpecializationType_isCurrentInstantiation(T::CXTemplateSpecializationType)::Bool
end

function clang_TemplateSpecializationType_isTypeAlias(T)
    @ccall libclangex.clang_TemplateSpecializationType_isTypeAlias(T::CXTemplateSpecializationType)::Bool
end

function clang_TemplateSpecializationType_getAliasedType(T)
    @ccall libclangex.clang_TemplateSpecializationType_getAliasedType(T::CXTemplateSpecializationType)::CXQualType
end

function clang_TemplateSpecializationType_getTemplateName(T)
    @ccall libclangex.clang_TemplateSpecializationType_getTemplateName(T::CXTemplateSpecializationType)::CXTemplateName
end

function clang_TemplateSpecializationType_template_arguments(T)
    @ccall libclangex.clang_TemplateSpecializationType_template_arguments(T::CXTemplateSpecializationType)::CXArrayRef
end

function clang_TemplateSpecializationType_isSugared(T)
    @ccall libclangex.clang_TemplateSpecializationType_isSugared(T::CXTemplateSpecializationType)::Bool
end

function clang_TemplateSpecializationType_desugar(T)
    @ccall libclangex.clang_TemplateSpecializationType_desugar(T::CXTemplateSpecializationType)::CXQualType
end

function clang_InjectedClassNameType_getInjectedSpecializationType(T)
    @ccall libclangex.clang_InjectedClassNameType_getInjectedSpecializationType(T::CXInjectedClassNameType)::CXQualType
end

function clang_InjectedClassNameType_getInjectedTST(T)
    @ccall libclangex.clang_InjectedClassNameType_getInjectedTST(T::CXInjectedClassNameType)::CXTemplateSpecializationType
end

function clang_InjectedClassNameType_getTemplateName(T)
    @ccall libclangex.clang_InjectedClassNameType_getTemplateName(T::CXInjectedClassNameType)::CXTemplateName
end

function clang_InjectedClassNameType_getDecl(T)
    @ccall libclangex.clang_InjectedClassNameType_getDecl(T::CXInjectedClassNameType)::CXCXXRecordDecl
end

function clang_InjectedClassNameType_isSugared(T)
    @ccall libclangex.clang_InjectedClassNameType_isSugared(T::CXInjectedClassNameType)::Bool
end

function clang_InjectedClassNameType_desugar(T)
    @ccall libclangex.clang_InjectedClassNameType_desugar(T::CXInjectedClassNameType)::CXQualType
end

function clang_ElaboratedType_getQualifier(T)
    @ccall libclangex.clang_ElaboratedType_getQualifier(T::CXElaboratedType)::CXNestedNameSpecifier
end

function clang_ElaboratedType_getNamedType(T)
    @ccall libclangex.clang_ElaboratedType_getNamedType(T::CXElaboratedType)::CXQualType
end

function clang_ElaboratedType_desugar(T)
    @ccall libclangex.clang_ElaboratedType_desugar(T::CXElaboratedType)::CXQualType
end

function clang_ElaboratedType_isSugared(T)
    @ccall libclangex.clang_ElaboratedType_isSugared(T::CXElaboratedType)::Bool
end

function clang_ElaboratedType_getOwnedTagDecl(T)
    @ccall libclangex.clang_ElaboratedType_getOwnedTagDecl(T::CXElaboratedType)::CXTagDecl
end

function clang_DependentNameType_getQualifier(T)
    @ccall libclangex.clang_DependentNameType_getQualifier(T::CXDependentNameType)::CXNestedNameSpecifier
end

function clang_DependentNameType_getIdentifier(T)
    @ccall libclangex.clang_DependentNameType_getIdentifier(T::CXDependentNameType)::CXIdentifierInfo
end

function clang_DependentNameType_isSugared(T)
    @ccall libclangex.clang_DependentNameType_isSugared(T::CXDependentNameType)::Bool
end

function clang_DependentNameType_desugar(T)
    @ccall libclangex.clang_DependentNameType_desugar(T::CXDependentNameType)::CXQualType
end

function clang_DependentTemplateSpecializationType_getQualifier(T)
    @ccall libclangex.clang_DependentTemplateSpecializationType_getQualifier(T::CXDependentTemplateSpecializationType)::CXNestedNameSpecifier
end

function clang_DependentTemplateSpecializationType_getIdentifier(T)
    @ccall libclangex.clang_DependentTemplateSpecializationType_getIdentifier(T::CXDependentTemplateSpecializationType)::CXIdentifierInfo
end

function clang_DependentTemplateSpecializationType_template_arguments(T)
    @ccall libclangex.clang_DependentTemplateSpecializationType_template_arguments(T::CXDependentTemplateSpecializationType)::CXArrayRef
end

function clang_DependentTemplateSpecializationType_isSugared(T)
    @ccall libclangex.clang_DependentTemplateSpecializationType_isSugared(T::CXDependentTemplateSpecializationType)::Bool
end

function clang_DependentTemplateSpecializationType_desugar(T)
    @ccall libclangex.clang_DependentTemplateSpecializationType_desugar(T::CXDependentTemplateSpecializationType)::CXQualType
end

function clang_AtomicType_getValueType(T)
    @ccall libclangex.clang_AtomicType_getValueType(T::CXAtomicType)::CXQualType
end

function clang_AtomicType_isSugared(T)
    @ccall libclangex.clang_AtomicType_isSugared(T::CXAtomicType)::Bool
end

function clang_AtomicType_desugar(T)
    @ccall libclangex.clang_AtomicType_desugar(T::CXAtomicType)::CXQualType
end

@enum CXTagTypeKind::UInt32 begin
    CXTagTypeKind_Struct = 0
    CXTagTypeKind_Interface = 1
    CXTagTypeKind_Union = 2
    CXTagTypeKind_Class = 3
    CXTagTypeKind_Enum = 4
end

@enum CXElaboratedTypeKeyword::UInt32 begin
    CXElaboratedTypeKeyword_Struct = 0
    CXElaboratedTypeKeyword_Interface = 1
    CXElaboratedTypeKeyword_Union = 2
    CXElaboratedTypeKeyword_Class = 3
    CXElaboratedTypeKeyword_Enum = 4
    CXElaboratedTypeKeyword_Typename = 5
    CXElaboratedTypeKeyword_None = 6
end

function clang_ASTContext_getSourceManager(Ctx)
    @ccall libclangex.clang_ASTContext_getSourceManager(Ctx::CXASTContext)::CXSourceManager
end

function clang_ASTContext_getASTAllocatedMemory(Ctx)
    @ccall libclangex.clang_ASTContext_getASTAllocatedMemory(Ctx::CXASTContext)::Csize_t
end

function clang_ASTContext_getSideTableAllocatedMemory(Ctx)
    @ccall libclangex.clang_ASTContext_getSideTableAllocatedMemory(Ctx::CXASTContext)::Csize_t
end

function clang_ASTContext_getTargetInfo(Ctx)
    @ccall libclangex.clang_ASTContext_getTargetInfo(Ctx::CXASTContext)::CXTargetInfo_
end

function clang_ASTContext_getAuxTargetInfo(Ctx)
    @ccall libclangex.clang_ASTContext_getAuxTargetInfo(Ctx::CXASTContext)::CXTargetInfo_
end

function clang_ASTContext_getIntTypeForBitwidth(Ctx, DestWidth, Signed)
    @ccall libclangex.clang_ASTContext_getIntTypeForBitwidth(Ctx::CXASTContext, DestWidth::Cuint, Signed::Cuint)::CXQualType
end

function clang_ASTContext_AtomicUsesUnsupportedLibcall(Ctx, E)
    @ccall libclangex.clang_ASTContext_AtomicUsesUnsupportedLibcall(Ctx::CXASTContext, E::CXAtomicExpr)::Bool
end

function clang_ASTContext_getLangOpts(Ctx)
    @ccall libclangex.clang_ASTContext_getLangOpts(Ctx::CXASTContext)::CXLangOptions
end

function clang_ASTContext_isDependceAllowed(Ctx)
    @ccall libclangex.clang_ASTContext_isDependceAllowed(Ctx::CXASTContext)::Bool
end

function clang_ASTContext_getDiagnostics(Ctx)
    @ccall libclangex.clang_ASTContext_getDiagnostics(Ctx::CXASTContext)::CXDiagnosticsEngine
end

function clang_ASTContext_eraseDeclAttrs(Ctx, D)
    @ccall libclangex.clang_ASTContext_eraseDeclAttrs(Ctx::CXASTContext, D::CXDecl)::Cvoid
end

function clang_ASTContext_getInstantiatedFromUsingDecl(Ctx, Inst)
    @ccall libclangex.clang_ASTContext_getInstantiatedFromUsingDecl(Ctx::CXASTContext, Inst::CXNamedDecl)::CXNamedDecl
end

function clang_ASTContext_setInstantiatedFromUsingDecl(Ctx, Inst, Pattern)
    @ccall libclangex.clang_ASTContext_setInstantiatedFromUsingDecl(Ctx::CXASTContext, Inst::CXNamedDecl, Pattern::CXNamedDecl)::Cvoid
end

function clang_ASTContext_setInstantiatedFromUsingShadowDecl(Ctx, Inst, Pattern)
    @ccall libclangex.clang_ASTContext_setInstantiatedFromUsingShadowDecl(Ctx::CXASTContext, Inst::CXUsingShadowDecl, Pattern::CXUsingShadowDecl)::Cvoid
end

function clang_ASTContext_getInstantiatedFromUsingShadowDecl(Ctx, Inst)
    @ccall libclangex.clang_ASTContext_getInstantiatedFromUsingShadowDecl(Ctx::CXASTContext, Inst::CXUsingShadowDecl)::CXUsingShadowDecl
end

function clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(Ctx, Field)
    @ccall libclangex.clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(Ctx::CXASTContext, Field::CXFieldDecl)::CXFieldDecl
end

function clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(Ctx, Inst, Tmpl)
    @ccall libclangex.clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(Ctx::CXASTContext, Inst::CXFieldDecl, Tmpl::CXFieldDecl)::Cvoid
end

function clang_ASTContext_addOverriddenMethod(Ctx, Method, Overridden)
    @ccall libclangex.clang_ASTContext_addOverriddenMethod(Ctx::CXASTContext, Method::CXCXXMethodDecl, Overridden::CXCXXMethodDecl)::Cvoid
end

function clang_ASTContext_addedLocalImportDecl(Ctx, Import)
    @ccall libclangex.clang_ASTContext_addedLocalImportDecl(Ctx::CXASTContext, Import::CXImportDecl)::Cvoid
end

function clang_ASTContext_getPrimaryMergedDecl(Ctx, D)
    @ccall libclangex.clang_ASTContext_getPrimaryMergedDecl(Ctx::CXASTContext, D::CXDecl)::CXDecl
end

function clang_ASTContext_setPrimaryMergedDecl(Ctx, D, Primary)
    @ccall libclangex.clang_ASTContext_setPrimaryMergedDecl(Ctx::CXASTContext, D::CXDecl, Primary::CXDecl)::Cvoid
end

function clang_ASTContext_mergeDefinitionIntoModule(Ctx, ND, Module, NotifyListeners)
    @ccall libclangex.clang_ASTContext_mergeDefinitionIntoModule(Ctx::CXASTContext, ND::CXNamedDecl, Module::CXModule, NotifyListeners::Bool)::Cvoid
end

function clang_ASTContext_deduplicateMergedDefinitonsFor(Ctx, ND)
    @ccall libclangex.clang_ASTContext_deduplicateMergedDefinitonsFor(Ctx::CXASTContext, ND::CXNamedDecl)::Cvoid
end

function clang_ASTContext_getTranslationUnitDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getTranslationUnitDecl(Ctx::CXASTContext)::CXTranslationUnitDecl
end

function clang_ASTContext_getExternCContextDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getExternCContextDecl(Ctx::CXASTContext)::CXExternCContextDecl
end

function clang_ASTContext_getMakeIntegerSeqDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getMakeIntegerSeqDecl(Ctx::CXASTContext)::CXBuiltinTemplateDecl
end

function clang_ASTContext_getTypePackElementDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getTypePackElementDecl(Ctx::CXASTContext)::CXBuiltinTemplateDecl
end

function clang_ASTContext_PrintStats(Ctx)
    @ccall libclangex.clang_ASTContext_PrintStats(Ctx::CXASTContext)::Cvoid
end

function clang_ASTContext_buildImplicitRecord(Ctx, Name, TK)
    @ccall libclangex.clang_ASTContext_buildImplicitRecord(Ctx::CXASTContext, Name::Ptr{Cchar}, TK::CXTagTypeKind)::CXRecordDecl
end

function clang_ASTContext_buildImplicitTypedef(Ctx, T, Name)
    @ccall libclangex.clang_ASTContext_buildImplicitTypedef(Ctx::CXASTContext, T::CXQualType, Name::Ptr{Cchar})::CXTypedefDecl
end

function clang_ASTContext_getInt128Decl(Ctx)
    @ccall libclangex.clang_ASTContext_getInt128Decl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_getUInt128Decl(Ctx)
    @ccall libclangex.clang_ASTContext_getUInt128Decl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_removeAddrSpaceQualType(Ctx, T)
    @ccall libclangex.clang_ASTContext_removeAddrSpaceQualType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_removePtrSizeAddrSpace(Ctx, T)
    @ccall libclangex.clang_ASTContext_removePtrSizeAddrSpace(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getRestrictType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getRestrictType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getVolatileType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getVolatileType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getConstType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getConstType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_adjustDeducedFunctionResultType(Ctx, FD, ResultType)
    @ccall libclangex.clang_ASTContext_adjustDeducedFunctionResultType(Ctx::CXASTContext, FD::CXFunctionDecl, ResultType::CXQualType)::Cvoid
end

function clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(Ctx, T, U)
    @ccall libclangex.clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(Ctx::CXASTContext, T::CXQualType, U::CXQualType)::Bool
end

function clang_ASTContext_getFunctionTypeWithoutPtrSizes(Ctx, T)
    @ccall libclangex.clang_ASTContext_getFunctionTypeWithoutPtrSizes(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(Ctx, T, U)
    @ccall libclangex.clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(Ctx::CXASTContext, T::CXQualType, U::CXQualType)::Bool
end

function clang_ASTContext_getComplexType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getComplexType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getPointerType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getPointerType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getAdjustedType(Ctx, Orig, New)
    @ccall libclangex.clang_ASTContext_getAdjustedType(Ctx::CXASTContext, Orig::CXQualType, New::CXQualType)::CXQualType
end

function clang_ASTContext_getDecayedType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getDecayedType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getAtomicType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAtomicType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getBlockPointerType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getBlockPointerType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getBlockDescriptorType(Ctx)
    @ccall libclangex.clang_ASTContext_getBlockDescriptorType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getReadPipeType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getReadPipeType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getWritePipeType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getWritePipeType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getBitIntType(Ctx, Unsigned, NumBits)
    @ccall libclangex.clang_ASTContext_getBitIntType(Ctx::CXASTContext, Unsigned::Bool, NumBits::Cuint)::CXQualType
end

function clang_ASTContext_getDependentBitIntType(Ctx, Unsigned, BitsExpr)
    @ccall libclangex.clang_ASTContext_getDependentBitIntType(Ctx::CXASTContext, Unsigned::Bool, BitsExpr::CXExpr)::CXQualType
end

function clang_ASTContext_getBlockDescriptorExtendedType(Ctx)
    @ccall libclangex.clang_ASTContext_getBlockDescriptorExtendedType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_setcudaConfigureCallDecl(Ctx, FD)
    @ccall libclangex.clang_ASTContext_setcudaConfigureCallDecl(Ctx::CXASTContext, FD::CXFunctionDecl)::Cvoid
end

function clang_ASTContext_getcudaConfigureCallDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getcudaConfigureCallDecl(Ctx::CXASTContext)::CXFunctionDecl
end

function clang_ASTContext_BlockRequiresCopying(Ctx, T, D)
    @ccall libclangex.clang_ASTContext_BlockRequiresCopying(Ctx::CXASTContext, T::CXQualType, D::CXVarDecl)::Bool
end

function clang_ASTContext_getLValueReferenceType(Ctx, T, SpelledAsLValue)
    @ccall libclangex.clang_ASTContext_getLValueReferenceType(Ctx::CXASTContext, T::CXQualType, SpelledAsLValue::Bool)::CXQualType
end

function clang_ASTContext_getRValueReferenceType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getRValueReferenceType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getMemberPointerType(Ctx, T, Cls)
    @ccall libclangex.clang_ASTContext_getMemberPointerType(Ctx::CXASTContext, T::CXQualType, Cls::CXType_)::CXQualType
end

function clang_ASTContext_getStringLiteralArrayType(Ctx, EltTy, Length)
    @ccall libclangex.clang_ASTContext_getStringLiteralArrayType(Ctx::CXASTContext, EltTy::CXQualType, Length::Cuint)::CXQualType
end

function clang_ASTContext_getVariableArrayDecayedType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getVariableArrayDecayedType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getScalableVectorType(Ctx, EltTy, NumElts)
    @ccall libclangex.clang_ASTContext_getScalableVectorType(Ctx::CXASTContext, EltTy::CXQualType, NumElts::Cuint)::CXQualType
end

function clang_ASTContext_getExtVectorType(Ctx, VectorType, NumElts)
    @ccall libclangex.clang_ASTContext_getExtVectorType(Ctx::CXASTContext, VectorType::CXQualType, NumElts::Cuint)::CXQualType
end

function clang_ASTContext_getDependentSizedExtVectorType(Ctx, VectorType, SizeExpr, AttrLoc)
    @ccall libclangex.clang_ASTContext_getDependentSizedExtVectorType(Ctx::CXASTContext, VectorType::CXQualType, SizeExpr::CXExpr, AttrLoc::CXSourceLocation_)::CXQualType
end

function clang_ASTContext_getConstantMatrixType(Ctx, ElementType, NumRows, NumCols)
    @ccall libclangex.clang_ASTContext_getConstantMatrixType(Ctx::CXASTContext, ElementType::CXQualType, NumRows::Cuint, NumCols::Cuint)::CXQualType
end

function clang_ASTContext_getDependentSizedMatrixType(Ctx, ElementType, RowsExpr, ColsExpr, AttrLoc)
    @ccall libclangex.clang_ASTContext_getDependentSizedMatrixType(Ctx::CXASTContext, ElementType::CXQualType, RowsExpr::CXExpr, ColsExpr::CXExpr, AttrLoc::CXSourceLocation_)::CXQualType
end

function clang_ASTContext_getDependentAddressSpaceType(Ctx, PointeeType, AddrSpaceExpr, AddrSpace)
    @ccall libclangex.clang_ASTContext_getDependentAddressSpaceType(Ctx::CXASTContext, PointeeType::CXQualType, AddrSpaceExpr::CXExpr, AddrSpace::CXSourceLocation_)::CXQualType
end

function clang_ASTContext_getFunctionNoProtoType(Ctx, ResultTy)
    @ccall libclangex.clang_ASTContext_getFunctionNoProtoType(Ctx::CXASTContext, ResultTy::CXQualType)::CXQualType
end

function clang_ASTContext_adjustStringLiteralBaseType(Ctx, StrLTy)
    @ccall libclangex.clang_ASTContext_adjustStringLiteralBaseType(Ctx::CXASTContext, StrLTy::CXQualType)::CXQualType
end

function clang_ASTContext_getTypeDeclType(Ctx, Decl, PrevDecl)
    @ccall libclangex.clang_ASTContext_getTypeDeclType(Ctx::CXASTContext, Decl::CXTypeDecl, PrevDecl::CXTypeDecl)::CXQualType
end

function clang_ASTContext_getTypedefType(Ctx, Decl, Underlying)
    @ccall libclangex.clang_ASTContext_getTypedefType(Ctx::CXASTContext, Decl::CXTypedefNameDecl, Underlying::CXQualType)::CXQualType
end

function clang_ASTContext_getRecordType(Ctx, Decl)
    @ccall libclangex.clang_ASTContext_getRecordType(Ctx::CXASTContext, Decl::CXRecordDecl)::CXQualType
end

function clang_ASTContext_getEnumType(Ctx, Decl)
    @ccall libclangex.clang_ASTContext_getEnumType(Ctx::CXASTContext, Decl::CXEnumDecl)::CXQualType
end

function clang_ASTContext_getInjectedClassNameType(Ctx, Decl, TST)
    @ccall libclangex.clang_ASTContext_getInjectedClassNameType(Ctx::CXASTContext, Decl::CXCXXRecordDecl, TST::CXQualType)::CXQualType
end

function clang_ASTContext_getTemplateTypeParmType(Ctx, Depth, Index, ParameterPack, ParmDecl)
    @ccall libclangex.clang_ASTContext_getTemplateTypeParmType(Ctx::CXASTContext, Depth::Cuint, Index::Cuint, ParameterPack::Bool, ParmDecl::CXTemplateTypeParmType)::CXQualType
end

function clang_ASTContext_getParenType(Ctx, NamedType)
    @ccall libclangex.clang_ASTContext_getParenType(Ctx::CXASTContext, NamedType::CXQualType)::CXQualType
end

function clang_ASTContext_getMacroQualifiedType(Ctx, UnderlyingTy, MacroII)
    @ccall libclangex.clang_ASTContext_getMacroQualifiedType(Ctx::CXASTContext, UnderlyingTy::CXQualType, MacroII::CXIdentifierInfo)::CXQualType
end

function clang_ASTContext_getDecltypeType(Ctx, Expr, UnderlyingType)
    @ccall libclangex.clang_ASTContext_getDecltypeType(Ctx::CXASTContext, Expr::CXExpr, UnderlyingType::CXQualType)::CXQualType
end

function clang_ASTContext_getAutoDeductType(Ctx)
    @ccall libclangex.clang_ASTContext_getAutoDeductType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getAutoRRefDeductType(Ctx)
    @ccall libclangex.clang_ASTContext_getAutoRRefDeductType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getDeducedTemplateSpecializationType(Ctx, Template, DeducedType, IsDependent)
    @ccall libclangex.clang_ASTContext_getDeducedTemplateSpecializationType(Ctx::CXASTContext, Template::CXTemplateName, DeducedType::CXQualType, IsDependent::Bool)::CXQualType
end

function clang_ASTContext_getTagDeclType(Ctx, Decl)
    @ccall libclangex.clang_ASTContext_getTagDeclType(Ctx::CXASTContext, Decl::CXTagDecl)::CXQualType
end

function clang_ASTContext_getWCharType(Ctx)
    @ccall libclangex.clang_ASTContext_getWCharType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getWideCharType(Ctx)
    @ccall libclangex.clang_ASTContext_getWideCharType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getSignedWCharType(Ctx)
    @ccall libclangex.clang_ASTContext_getSignedWCharType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getUnsignedWCharType(Ctx)
    @ccall libclangex.clang_ASTContext_getUnsignedWCharType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getWIntType(Ctx)
    @ccall libclangex.clang_ASTContext_getWIntType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getIntPtrType(Ctx)
    @ccall libclangex.clang_ASTContext_getIntPtrType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getUIntPtrType(Ctx)
    @ccall libclangex.clang_ASTContext_getUIntPtrType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getPointerDiffType(Ctx)
    @ccall libclangex.clang_ASTContext_getPointerDiffType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getUnsignedPointerDiffType(Ctx)
    @ccall libclangex.clang_ASTContext_getUnsignedPointerDiffType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getProcessIDType(Ctx)
    @ccall libclangex.clang_ASTContext_getProcessIDType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getCFConstantStringType(Ctx)
    @ccall libclangex.clang_ASTContext_getCFConstantStringType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getObjCSuperType(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCSuperType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getRawCFConstantStringType(Ctx)
    @ccall libclangex.clang_ASTContext_getRawCFConstantStringType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_setCFConstantStringType(Ctx, T)
    @ccall libclangex.clang_ASTContext_setCFConstantStringType(Ctx::CXASTContext, T::CXQualType)::Cvoid
end

function clang_ASTContext_getCFContantStringDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getCFContantStringDecl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_getCFConstantStringTagDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getCFConstantStringTagDecl(Ctx::CXASTContext)::CXRecordDecl
end

function clang_ASTContext_getObjCIdRedefinitionType(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCIdRedefinitionType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_setObjCIdRedefinitionType(Ctx, T)
    @ccall libclangex.clang_ASTContext_setObjCIdRedefinitionType(Ctx::CXASTContext, T::CXQualType)::Cvoid
end

function clang_ASTContext_getObjCClassRedefinitionType(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCClassRedefinitionType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_setObjCClassRedefinitionType(Ctx, T)
    @ccall libclangex.clang_ASTContext_setObjCClassRedefinitionType(Ctx::CXASTContext, T::CXQualType)::Cvoid
end

function clang_ASTContext_getNSCopyingName(Ctx)
    @ccall libclangex.clang_ASTContext_getNSCopyingName(Ctx::CXASTContext)::CXIdentifierInfo
end

function clang_ASTContext_getBoolName(Ctx)
    @ccall libclangex.clang_ASTContext_getBoolName(Ctx::CXASTContext)::CXIdentifierInfo
end

function clang_ASTContext_getMakeIntegerSeqName(Ctx)
    @ccall libclangex.clang_ASTContext_getMakeIntegerSeqName(Ctx::CXASTContext)::CXIdentifierInfo
end

function clang_ASTContext_getTypePackElementName(Ctx)
    @ccall libclangex.clang_ASTContext_getTypePackElementName(Ctx::CXASTContext)::CXIdentifierInfo
end

function clang_ASTContext_getObjCInstanceType(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCInstanceType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getObjCInstanceTypeDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCInstanceTypeDecl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_setFILEDecl(Ctx, FILEDecl)
    @ccall libclangex.clang_ASTContext_setFILEDecl(Ctx::CXASTContext, FILEDecl::CXTypeDecl)::Cvoid
end

function clang_ASTContext_getFILEType(Ctx)
    @ccall libclangex.clang_ASTContext_getFILEType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getLogicalOperationType(Ctx)
    @ccall libclangex.clang_ASTContext_getLogicalOperationType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getBOOLDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getBOOLDecl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_setBOOLDecl(Ctx, TD)
    @ccall libclangex.clang_ASTContext_setBOOLDecl(Ctx::CXASTContext, TD::CXTypedefDecl)::Cvoid
end

function clang_ASTContext_getBOOLType(Ctx)
    @ccall libclangex.clang_ASTContext_getBOOLType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getObjCProtoType(Ctx)
    @ccall libclangex.clang_ASTContext_getObjCProtoType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getBuiltinVaListDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getBuiltinVaListDecl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_getVaListTagDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getVaListTagDecl(Ctx::CXASTContext)::CXDecl
end

function clang_ASTContext_getBuiltinMSVaListDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getBuiltinMSVaListDecl(Ctx::CXASTContext)::CXTypedefDecl
end

function clang_ASTContext_getBuiltinMSVaListType(Ctx)
    @ccall libclangex.clang_ASTContext_getBuiltinMSVaListType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_getMSGuidTagDecl(Ctx)
    @ccall libclangex.clang_ASTContext_getMSGuidTagDecl(Ctx::CXASTContext)::CXTagDecl
end

function clang_ASTContext_getMSGuidType(Ctx)
    @ccall libclangex.clang_ASTContext_getMSGuidType(Ctx::CXASTContext)::CXTagType
end

function clang_ASTContext_canBuiltinBeRedeclared(Ctx, D)
    @ccall libclangex.clang_ASTContext_canBuiltinBeRedeclared(Ctx::CXASTContext, D::CXFunctionDecl)::Bool
end

function clang_ASTContext_getCVRQualifiedType(Ctx, T, CVR)
    @ccall libclangex.clang_ASTContext_getCVRQualifiedType(Ctx::CXASTContext, T::CXQualType, CVR::Cuint)::CXQualType
end

function clang_ASTContext_getFixedPointScale(Ctx, Ty)
    @ccall libclangex.clang_ASTContext_getFixedPointScale(Ctx::CXASTContext, Ty::CXQualType)::Cuchar
end

function clang_ASTContext_getFixedPointIBits(Ctx, Ty)
    @ccall libclangex.clang_ASTContext_getFixedPointIBits(Ctx::CXASTContext, Ty::CXQualType)::Cuchar
end

function clang_ASTContext_getAssumedTemplateName(Ctx, Name)
    @ccall libclangex.clang_ASTContext_getAssumedTemplateName(Ctx::CXASTContext, Name::CXDeclarationName)::CXTemplateName
end

function clang_ASTContext_getDependentTemplateName(Ctx, NNS, Name)
    @ccall libclangex.clang_ASTContext_getDependentTemplateName(Ctx::CXASTContext, NNS::CXNestedNameSpecifier, Name::CXIdentifierInfo)::CXTemplateName
end

function clang_ASTContext_areCompatibleVectorTypes(Ctx, FirstVec, SecondVec)
    @ccall libclangex.clang_ASTContext_areCompatibleVectorTypes(Ctx::CXASTContext, FirstVec::CXQualType, SecondVec::CXQualType)::Bool
end

function clang_ASTContext_areCompatibleSveTypes(Ctx, FirstVec, SecondVec)
    @ccall libclangex.clang_ASTContext_areCompatibleSveTypes(Ctx::CXASTContext, FirstVec::CXQualType, SecondVec::CXQualType)::Bool
end

function clang_ASTContext_areLaxCompatibleSveTypes(Ctx, FirstVec, SecondVec)
    @ccall libclangex.clang_ASTContext_areLaxCompatibleSveTypes(Ctx::CXASTContext, FirstVec::CXQualType, SecondVec::CXQualType)::Bool
end

function clang_ASTContext_hasDirectOwnershipQualifier(Ctx, Ty)
    @ccall libclangex.clang_ASTContext_hasDirectOwnershipQualifier(Ctx::CXASTContext, Ty::CXQualType)::Bool
end

function clang_ASTContext_getOpenMPDefaultSimdAlign(Ctx, T)
    @ccall libclangex.clang_ASTContext_getOpenMPDefaultSimdAlign(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getTypeSize(Ctx, T)
    @ccall libclangex.clang_ASTContext_getTypeSize(Ctx::CXASTContext, T::CXQualType)::UInt64
end

function clang_ASTContext_getCharWidth(Ctx)
    @ccall libclangex.clang_ASTContext_getCharWidth(Ctx::CXASTContext)::UInt64
end

function clang_ASTContext_getSizeOf(Ctx, T)
    @ccall libclangex.clang_ASTContext_getSizeOf(Ctx::CXASTContext, T::CXQualType)::UInt64
end

function clang_ASTContext_getTypeAlign(Ctx, T)
    @ccall libclangex.clang_ASTContext_getTypeAlign(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getTypeUnadjustedAlign(Ctx, T)
    @ccall libclangex.clang_ASTContext_getTypeUnadjustedAlign(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getTypeAlignIfKnown(Ctx, T, NeedsPreferredAlignment)
    @ccall libclangex.clang_ASTContext_getTypeAlignIfKnown(Ctx::CXASTContext, T::CXQualType, NeedsPreferredAlignment::Bool)::Cuint
end

function clang_ASTContext_isAlignmentRequired(Ctx, T)
    @ccall libclangex.clang_ASTContext_isAlignmentRequired(Ctx::CXASTContext, T::CXQualType)::Bool
end

function clang_ASTContext_getPreferredTypeAlign(Ctx, T)
    @ccall libclangex.clang_ASTContext_getPreferredTypeAlign(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getTargetDefaultAlignForAttributeAligned(Ctx)
    @ccall libclangex.clang_ASTContext_getTargetDefaultAlignForAttributeAligned(Ctx::CXASTContext)::Cuint
end

function clang_ASTContext_getAlignOfGlobalVar(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAlignOfGlobalVar(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getFieldOffset(Ctx, FD)
    @ccall libclangex.clang_ASTContext_getFieldOffset(Ctx::CXASTContext, FD::CXValueDecl)::UInt64
end

function clang_ASTContext_isNearlyEmpty(Ctx, RD)
    @ccall libclangex.clang_ASTContext_isNearlyEmpty(Ctx::CXASTContext, RD::CXCXXRecordDecl)::Bool
end

function clang_ASTContext_createMangleContext(Ctx, T)
    @ccall libclangex.clang_ASTContext_createMangleContext(Ctx::CXASTContext, T::CXTargetInfo_)::CXMangleContext
end

function clang_ASTContext_hasUniqueObjectRepresentations(Ctx, Ty)
    @ccall libclangex.clang_ASTContext_hasUniqueObjectRepresentations(Ctx::CXASTContext, Ty::CXQualType)::Bool
end

function clang_ASTContext_hasSameType(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_hasSameType(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_hasSameUnqualifiedType(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_hasSameUnqualifiedType(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_hasSameNullabilityTypeQualifier(Ctx, SubT, SuperT, IsParam)
    @ccall libclangex.clang_ASTContext_hasSameNullabilityTypeQualifier(Ctx::CXASTContext, SubT::CXQualType, SuperT::CXQualType, IsParam::Bool)::Bool
end

function clang_ASTContext_hasSimilarType(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_hasSimilarType(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_hasCvrSimilarType(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_hasCvrSimilarType(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_getCanonicalNestedNameSpecifier(Ctx, NNS)
    @ccall libclangex.clang_ASTContext_getCanonicalNestedNameSpecifier(Ctx::CXASTContext, NNS::CXNestedNameSpecifier)::CXNestedNameSpecifier
end

function clang_ASTContext_getCanonicalTemplateName(Ctx, TemplateName)
    @ccall libclangex.clang_ASTContext_getCanonicalTemplateName(Ctx::CXASTContext, TemplateName::CXTemplateName)::CXTemplateName
end

function clang_ASTContext_hasSameTempalteName(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_hasSameTempalteName(Ctx::CXASTContext, T1::CXTemplateName, T2::CXTemplateName)::Bool
end

function clang_ASTContext_getAsArrayType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAsArrayType(Ctx::CXASTContext, T::CXQualType)::CXArrayType
end

function clang_ASTContext_getAsConstantArrayType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAsConstantArrayType(Ctx::CXASTContext, T::CXQualType)::CXConstantArrayType
end

function clang_ASTContext_getAsVariableArrayType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAsVariableArrayType(Ctx::CXASTContext, T::CXQualType)::CXVariableArrayType
end

function clang_ASTContext_getAsIncompleteArrayType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAsIncompleteArrayType(Ctx::CXASTContext, T::CXQualType)::CXIncompleteArrayType
end

function clang_ASTContext_getAsDependentSizedArrayType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAsDependentSizedArrayType(Ctx::CXASTContext, T::CXQualType)::CXDependentSizedArrayType
end

function clang_ASTContext_getBaseElementType(Ctx, QT)
    @ccall libclangex.clang_ASTContext_getBaseElementType(Ctx::CXASTContext, QT::CXQualType)::CXQualType
end

function clang_ASTContext_getConstantArrayElementCount(Ctx, CAT)
    @ccall libclangex.clang_ASTContext_getConstantArrayElementCount(Ctx::CXASTContext, CAT::CXConstantArrayType)::UInt64
end

function clang_ASTContext_getAdjustedParameterType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getAdjustedParameterType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getSignatureParameterType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getSignatureParameterType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getExceptionObjectType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getExceptionObjectType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getArrayDecayedType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getArrayDecayedType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getPromotedIntegerType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getPromotedIntegerType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_isPromotableBitField(Ctx, E)
    @ccall libclangex.clang_ASTContext_isPromotableBitField(Ctx::CXASTContext, E::CXExpr)::CXQualType
end

function clang_ASTContext_getIntegerTypeOrder(Ctx, LHS, RHS)
    @ccall libclangex.clang_ASTContext_getIntegerTypeOrder(Ctx::CXASTContext, LHS::CXQualType, RHS::CXQualType)::Cint
end

function clang_ASTContext_getFloatingTypeOrder(Ctx, LHS, RHS)
    @ccall libclangex.clang_ASTContext_getFloatingTypeOrder(Ctx::CXASTContext, LHS::CXQualType, RHS::CXQualType)::Cint
end

function clang_ASTContext_getFloatingTypeSemanticOrder(Ctx, LHS, RHS)
    @ccall libclangex.clang_ASTContext_getFloatingTypeSemanticOrder(Ctx::CXASTContext, LHS::CXQualType, RHS::CXQualType)::Cint
end

function clang_ASTContext_getTargetNullPointerValue(Ctx, T)
    @ccall libclangex.clang_ASTContext_getTargetNullPointerValue(Ctx::CXASTContext, T::CXQualType)::UInt64
end

function clang_ASTContext_typesAreCompatible(Ctx, T1, T2, CompareUnqualified)
    @ccall libclangex.clang_ASTContext_typesAreCompatible(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType, CompareUnqualified::Bool)::Bool
end

function clang_ASTContext_propertyTypesAreCompatible(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_propertyTypesAreCompatible(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_typesAreBlockPointerCompatible(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_typesAreBlockPointerCompatible(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::Bool
end

function clang_ASTContext_mergeTypes(Ctx, T1, T2, OfBlockPointer, Unqualified, BlockReturnType)
    @ccall libclangex.clang_ASTContext_mergeTypes(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType, OfBlockPointer::Bool, Unqualified::Bool, BlockReturnType::Bool)::CXQualType
end

function clang_ASTContext_mergeFunctionTypes(Ctx, T1, T2, OfBlockPointer, Unqualified, AllowCXX)
    @ccall libclangex.clang_ASTContext_mergeFunctionTypes(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType, OfBlockPointer::Bool, Unqualified::Bool, AllowCXX::Bool)::CXQualType
end

function clang_ASTContext_mergeFunctionParameterTypes(Ctx, T1, T2, OfBlockPointer, Unqualified)
    @ccall libclangex.clang_ASTContext_mergeFunctionParameterTypes(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType, OfBlockPointer::Bool, Unqualified::Bool)::CXQualType
end

function clang_ASTContext_mergeTransparentUnionType(Ctx, T1, T2, OfBlockPointer, Unqualified)
    @ccall libclangex.clang_ASTContext_mergeTransparentUnionType(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType, OfBlockPointer::Bool, Unqualified::Bool)::CXQualType
end

function clang_ASTContext_mergeObjCGCQualifiers(Ctx, T1, T2)
    @ccall libclangex.clang_ASTContext_mergeObjCGCQualifiers(Ctx::CXASTContext, T1::CXQualType, T2::CXQualType)::CXQualType
end

function clang_ASTContext_getIntWidth(Ctx, T)
    @ccall libclangex.clang_ASTContext_getIntWidth(Ctx::CXASTContext, T::CXQualType)::Cuint
end

function clang_ASTContext_getCorrespondingUnsignedType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getCorrespondingUnsignedType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getCorrespondingSaturatedType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getCorrespondingSaturatedType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getCorrespondingSignedFixedPointType(Ctx, T)
    @ccall libclangex.clang_ASTContext_getCorrespondingSignedFixedPointType(Ctx::CXASTContext, T::CXQualType)::CXQualType
end

function clang_ASTContext_getIdents(Ctx)
    @ccall libclangex.clang_ASTContext_getIdents(Ctx::CXASTContext)::CXIdentifierTable
end

function clang_ASTContext_isSentinelNullExpr(Ctx, E)
    @ccall libclangex.clang_ASTContext_isSentinelNullExpr(Ctx::CXASTContext, E::CXExpr)::Bool
end

function clang_ASTContext_CreateTypeSourceInfo(Ctx, T, Size)
    @ccall libclangex.clang_ASTContext_CreateTypeSourceInfo(Ctx::CXASTContext, T::CXQualType, Size::Cuint)::CXTypeSourceInfo
end

function clang_ASTContext_getTrivialTypeSourceInfo(Ctx, T, Loc)
    @ccall libclangex.clang_ASTContext_getTrivialTypeSourceInfo(Ctx::CXASTContext, T::CXQualType, Loc::CXSourceLocation_)::CXTypeSourceInfo
end

function clang_ASTContext_getCopyConstructorForExceptionObject(Ctx, RD)
    @ccall libclangex.clang_ASTContext_getCopyConstructorForExceptionObject(Ctx::CXASTContext, RD::CXCXXRecordDecl)::CXCXXConstructorDecl
end

function clang_ASTContext_addCopyConstructorForExceptionObject(Ctx, RD, CD)
    @ccall libclangex.clang_ASTContext_addCopyConstructorForExceptionObject(Ctx::CXASTContext, RD::CXCXXRecordDecl, CD::CXCXXConstructorDecl)::Cvoid
end

function clang_ASTContext_addTypedefNameForUnnamedTagDecl(Ctx, TD, TND)
    @ccall libclangex.clang_ASTContext_addTypedefNameForUnnamedTagDecl(Ctx::CXASTContext, TD::CXTagDecl, TND::CXTypedefNameDecl)::Cvoid
end

function clang_ASTContext_getTypedefNameForUnnamedTagDecl(Ctx, TD)
    @ccall libclangex.clang_ASTContext_getTypedefNameForUnnamedTagDecl(Ctx::CXASTContext, TD::CXTagDecl)::CXTypedefNameDecl
end

function clang_ASTContext_addDeclaratorForUnnamedTagDecl(Ctx, TD, D)
    @ccall libclangex.clang_ASTContext_addDeclaratorForUnnamedTagDecl(Ctx::CXASTContext, TD::CXTagDecl, D::CXDeclaratorDecl)::Cvoid
end

function clang_ASTContext_getDeclaratorForUnnamedTagDecl(Ctx, TD)
    @ccall libclangex.clang_ASTContext_getDeclaratorForUnnamedTagDecl(Ctx::CXASTContext, TD::CXTagDecl)::CXDeclaratorDecl
end

function clang_ASTContext_setManglingNumber(Ctx, ND, Number)
    @ccall libclangex.clang_ASTContext_setManglingNumber(Ctx::CXASTContext, ND::CXNamedDecl, Number::Cuint)::Cvoid
end

function clang_ASTContext_getManglingNumber(Ctx, ND)
    @ccall libclangex.clang_ASTContext_getManglingNumber(Ctx::CXASTContext, ND::CXNamedDecl)::Cuint
end

function clang_ASTContext_setStaticLocalNumber(Ctx, ND, Number)
    @ccall libclangex.clang_ASTContext_setStaticLocalNumber(Ctx::CXASTContext, ND::CXVarDecl, Number::Cuint)::Cvoid
end

function clang_ASTContext_getStaticLocalNumber(Ctx, ND)
    @ccall libclangex.clang_ASTContext_getStaticLocalNumber(Ctx::CXASTContext, ND::CXVarDecl)::Cuint
end

function clang_ASTContext_setParameterIndex(Ctx, D, index)
    @ccall libclangex.clang_ASTContext_setParameterIndex(Ctx::CXASTContext, D::CXParmVarDecl, index::Cuint)::Cvoid
end

function clang_ASTContext_getParameterIndex(Ctx, D)
    @ccall libclangex.clang_ASTContext_getParameterIndex(Ctx::CXASTContext, D::CXParmVarDecl)::Cuint
end

function clang_ASTContext_getPredefinedStringLiteralFromCache(Ctx, Key)
    @ccall libclangex.clang_ASTContext_getPredefinedStringLiteralFromCache(Ctx::CXASTContext, Key::Ptr{Cchar})::CXStringLiteral
end

function clang_ASTContext_InitBuiltinTypes(Ctx, Target, AuxTarget)
    @ccall libclangex.clang_ASTContext_InitBuiltinTypes(Ctx::CXASTContext, Target::CXTargetInfo_, AuxTarget::CXTargetInfo_)::Cvoid
end

function clang_ASTContext_isMSStaticDataMemberInlineDefinition(Ctx, VD)
    @ccall libclangex.clang_ASTContext_isMSStaticDataMemberInlineDefinition(Ctx::CXASTContext, VD::CXVarDecl)::Bool
end

function clang_ASTContext_VoidTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_VoidTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_BoolTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_BoolTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_CharTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_CharTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_WCharTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_WCharTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_WideCharTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_WideCharTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_WIntTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_WIntTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Char8Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Char8Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Char16Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Char16Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Char32Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Char32Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_SignedCharTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_SignedCharTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_ShortTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_ShortTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_IntTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_IntTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_LongTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_LongTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_LongLongTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_LongLongTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Int128Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Int128Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedCharTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedCharTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedShortTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedShortTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedIntTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedIntTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedLongTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedLongTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedLongLongTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedLongLongTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_UnsignedInt128Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_UnsignedInt128Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_FloatTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_FloatTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_DoubleTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_DoubleTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_LongDoubleTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_LongDoubleTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Float128Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Float128Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_HalfTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_HalfTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_BFloat16Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_BFloat16Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_Float16Ty_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_Float16Ty_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_VoidPtrTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_VoidPtrTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_ASTContext_NullPtrTy_getAsQualType(Ctx)
    @ccall libclangex.clang_ASTContext_NullPtrTy_getAsQualType(Ctx::CXASTContext)::CXQualType
end

function clang_Decl_getLocation(DC)
    @ccall libclangex.clang_Decl_getLocation(DC::CXDecl)::CXSourceLocation_
end

function clang_Decl_getBeginLoc(DC)
    @ccall libclangex.clang_Decl_getBeginLoc(DC::CXDecl)::CXSourceLocation_
end

function clang_Decl_getEndLoc(DC)
    @ccall libclangex.clang_Decl_getEndLoc(DC::CXDecl)::CXSourceLocation_
end

function clang_Decl_getDeclKindName(DC)
    @ccall libclangex.clang_Decl_getDeclKindName(DC::CXDecl)::Ptr{Cchar}
end

function clang_Decl_getNextDeclInContext(DC)
    @ccall libclangex.clang_Decl_getNextDeclInContext(DC::CXDecl)::CXDecl
end

function clang_Decl_getDeclContext(DC)
    @ccall libclangex.clang_Decl_getDeclContext(DC::CXDecl)::CXDeclContext
end

function clang_Decl_getNonClosureContext(DC)
    @ccall libclangex.clang_Decl_getNonClosureContext(DC::CXDecl)::CXDecl
end

function clang_Decl_getTranslationUnitDecl(DC)
    @ccall libclangex.clang_Decl_getTranslationUnitDecl(DC::CXDecl)::CXTranslationUnitDecl
end

function clang_Decl_isInAnonymousNamespace(DC)
    @ccall libclangex.clang_Decl_isInAnonymousNamespace(DC::CXDecl)::Bool
end

function clang_Decl_isInStdNamespace(DC)
    @ccall libclangex.clang_Decl_isInStdNamespace(DC::CXDecl)::Bool
end

function clang_Decl_getASTContext(DC)
    @ccall libclangex.clang_Decl_getASTContext(DC::CXDecl)::CXASTContext
end

function clang_Decl_getLangOpts(DC)
    @ccall libclangex.clang_Decl_getLangOpts(DC::CXDecl)::CXLangOptions
end

function clang_Decl_getLexicalDeclContext(DC)
    @ccall libclangex.clang_Decl_getLexicalDeclContext(DC::CXDecl)::CXDeclContext
end

function clang_Decl_isOutOfLine(DC)
    @ccall libclangex.clang_Decl_isOutOfLine(DC::CXDecl)::Bool
end

function clang_Decl_setDeclContext(DC, Ctx)
    @ccall libclangex.clang_Decl_setDeclContext(DC::CXDecl, Ctx::CXDeclContext)::Cvoid
end

function clang_Decl_setLexicalDeclContext(DC, Ctx)
    @ccall libclangex.clang_Decl_setLexicalDeclContext(DC::CXDecl, Ctx::CXDeclContext)::Cvoid
end

function clang_Decl_isTemplated(DC)
    @ccall libclangex.clang_Decl_isTemplated(DC::CXDecl)::Bool
end

function clang_Decl_getTemplateDepth(DC)
    @ccall libclangex.clang_Decl_getTemplateDepth(DC::CXDecl)::Cuint
end

function clang_Decl_isDefinedOutsideFunctionOrMethod(DC)
    @ccall libclangex.clang_Decl_isDefinedOutsideFunctionOrMethod(DC::CXDecl)::Bool
end

function clang_Decl_isInLocalScopeForInstantiation(DC)
    @ccall libclangex.clang_Decl_isInLocalScopeForInstantiation(DC::CXDecl)::Bool
end

function clang_Decl_getParentFunctionOrMethod(DC)
    @ccall libclangex.clang_Decl_getParentFunctionOrMethod(DC::CXDecl)::CXDeclContext
end

function clang_Decl_getCanonicalDecl(DC)
    @ccall libclangex.clang_Decl_getCanonicalDecl(DC::CXDecl)::CXDecl
end

function clang_Decl_isCanonicalDecl(DC)
    @ccall libclangex.clang_Decl_isCanonicalDecl(DC::CXDecl)::Bool
end

function clang_Decl_getPreviousDecl(DC)
    @ccall libclangex.clang_Decl_getPreviousDecl(DC::CXDecl)::CXDecl
end

function clang_Decl_isFirstDecl(DC)
    @ccall libclangex.clang_Decl_isFirstDecl(DC::CXDecl)::Bool
end

function clang_Decl_getMostRecentDecl(DC)
    @ccall libclangex.clang_Decl_getMostRecentDecl(DC::CXDecl)::CXDecl
end

function clang_Decl_isTemplateParameter(DC)
    @ccall libclangex.clang_Decl_isTemplateParameter(DC::CXDecl)::Bool
end

function clang_Decl_isTemplateParameterPack(DC)
    @ccall libclangex.clang_Decl_isTemplateParameterPack(DC::CXDecl)::Bool
end

function clang_Decl_isParameterPack(DC)
    @ccall libclangex.clang_Decl_isParameterPack(DC::CXDecl)::Bool
end

function clang_Decl_isTemplateDecl(DC)
    @ccall libclangex.clang_Decl_isTemplateDecl(DC::CXDecl)::Bool
end

function clang_Decl_isFunctionOrFunctionTemplate(DC)
    @ccall libclangex.clang_Decl_isFunctionOrFunctionTemplate(DC::CXDecl)::Bool
end

function clang_Decl_getDescribedTemplate(DC)
    @ccall libclangex.clang_Decl_getDescribedTemplate(DC::CXDecl)::CXTemplateDecl
end

function clang_Decl_getDescribedTemplateParams(DC)
    @ccall libclangex.clang_Decl_getDescribedTemplateParams(DC::CXDecl)::CXTemplateParameterList
end

function clang_Decl_getAsFunction(DC)
    @ccall libclangex.clang_Decl_getAsFunction(DC::CXDecl)::CXFunctionDecl
end

function clang_Decl_dump(DC)
    @ccall libclangex.clang_Decl_dump(DC::CXDecl)::Cvoid
end

function clang_Decl_dumpColor(DC)
    @ccall libclangex.clang_Decl_dumpColor(DC::CXDecl)::Cvoid
end

function clang_Decl_getID(DC)
    @ccall libclangex.clang_Decl_getID(DC::CXDecl)::Int64
end

function clang_Decl_getFunctionType(DC, BlocksToo)
    @ccall libclangex.clang_Decl_getFunctionType(DC::CXDecl, BlocksToo::Bool)::CXFunctionType
end

function clang_Decl_EnableStatistics()
    @ccall libclangex.clang_Decl_EnableStatistics()::Cvoid
end

function clang_Decl_PrintStats()
    @ccall libclangex.clang_Decl_PrintStats()::Cvoid
end

function clang_Decl_castToDeclContext(D)
    @ccall libclangex.clang_Decl_castToDeclContext(D::CXDecl)::CXDeclContext
end

function clang_Decl_castFromDeclContext(DC)
    @ccall libclangex.clang_Decl_castFromDeclContext(DC::CXDeclContext)::CXDecl
end

function clang_Decl_castToClassTemplateDecl(DC)
    @ccall libclangex.clang_Decl_castToClassTemplateDecl(DC::CXDecl)::CXClassTemplateDecl
end

function clang_Decl_castToValueDecl(DC)
    @ccall libclangex.clang_Decl_castToValueDecl(DC::CXDecl)::CXValueDecl
end

function clang_Decl_castToCXXConstructorDecl(D)
    @ccall libclangex.clang_Decl_castToCXXConstructorDecl(D::CXDecl)::CXCXXConstructorDecl
end

function clang_DeclContext_castToTagDecl(DC)
    @ccall libclangex.clang_DeclContext_castToTagDecl(DC::CXDeclContext)::CXTagDecl
end

function clang_DeclContext_castToRecordDecl(DC)
    @ccall libclangex.clang_DeclContext_castToRecordDecl(DC::CXDeclContext)::CXRecordDecl
end

function clang_DeclContext_castToCXXRecordDecl(DC)
    @ccall libclangex.clang_DeclContext_castToCXXRecordDecl(DC::CXDeclContext)::CXCXXRecordDecl
end

function clang_DeclContext_getDeclKindName(DC)
    @ccall libclangex.clang_DeclContext_getDeclKindName(DC::CXDeclContext)::Ptr{Cchar}
end

function clang_DeclContext_getParent(DC)
    @ccall libclangex.clang_DeclContext_getParent(DC::CXDeclContext)::CXDeclContext
end

function clang_DeclContext_getLexicalParent(DC)
    @ccall libclangex.clang_DeclContext_getLexicalParent(DC::CXDeclContext)::CXDeclContext
end

function clang_DeclContext_getLookupParent(DC)
    @ccall libclangex.clang_DeclContext_getLookupParent(DC::CXDeclContext)::CXDeclContext
end

function clang_DeclContext_getParentASTContext(DC)
    @ccall libclangex.clang_DeclContext_getParentASTContext(DC::CXDeclContext)::CXASTContext
end

function clang_DeclContext_isClosure(DC)
    @ccall libclangex.clang_DeclContext_isClosure(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isFunctionOrMethod(DC)
    @ccall libclangex.clang_DeclContext_isFunctionOrMethod(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isLookupContext(DC)
    @ccall libclangex.clang_DeclContext_isLookupContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isFileContext(DC)
    @ccall libclangex.clang_DeclContext_isFileContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isTranslationUnit(DC)
    @ccall libclangex.clang_DeclContext_isTranslationUnit(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isRecord(DC)
    @ccall libclangex.clang_DeclContext_isRecord(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isNamespace(DC)
    @ccall libclangex.clang_DeclContext_isNamespace(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isStdNamespace(DC)
    @ccall libclangex.clang_DeclContext_isStdNamespace(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isInlineNamespace(DC)
    @ccall libclangex.clang_DeclContext_isInlineNamespace(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isDependentContext(DC)
    @ccall libclangex.clang_DeclContext_isDependentContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isTransparentContext(DC)
    @ccall libclangex.clang_DeclContext_isTransparentContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isExternCContext(DC)
    @ccall libclangex.clang_DeclContext_isExternCContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_isExternCXXContext(DC)
    @ccall libclangex.clang_DeclContext_isExternCXXContext(DC::CXDeclContext)::Bool
end

function clang_DeclContext_Equals(DC, DC2)
    @ccall libclangex.clang_DeclContext_Equals(DC::CXDeclContext, DC2::CXDeclContext)::Bool
end

function clang_DeclContext_getPrimaryContext(DC)
    @ccall libclangex.clang_DeclContext_getPrimaryContext(DC::CXDeclContext)::CXDeclContext
end

function clang_DeclContext_decl_iterator_begin(DC)
    @ccall libclangex.clang_DeclContext_decl_iterator_begin(DC::CXDeclContext)::CXDecl
end

function clang_DeclContext_addDecl(DC, D)
    @ccall libclangex.clang_DeclContext_addDecl(DC::CXDeclContext, D::CXDecl)::Cvoid
end

function clang_DeclContext_addDeclInternal(DC, D)
    @ccall libclangex.clang_DeclContext_addDeclInternal(DC::CXDeclContext, D::CXDecl)::Cvoid
end

function clang_DeclContext_addHiddenDecl(DC, D)
    @ccall libclangex.clang_DeclContext_addHiddenDecl(DC::CXDeclContext, D::CXDecl)::Cvoid
end

function clang_DeclContext_removeDecl(DC, D)
    @ccall libclangex.clang_DeclContext_removeDecl(DC::CXDeclContext, D::CXDecl)::Cvoid
end

function clang_DeclContext_containsDecl(DC, D)
    @ccall libclangex.clang_DeclContext_containsDecl(DC::CXDeclContext, D::CXDecl)::Cvoid
end

function clang_DeclContext_dumpDeclContext(DC)
    @ccall libclangex.clang_DeclContext_dumpDeclContext(DC::CXDeclContext)::Cvoid
end

function clang_DeclContext_dumpLookups(DC)
    @ccall libclangex.clang_DeclContext_dumpLookups(DC::CXDeclContext)::Cvoid
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
    CXExprValueKind_VK_PRValue = 0
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

function clang_AccessSpecDecl_getAccessSpecifierLoc(AS)
    @ccall libclangex.clang_AccessSpecDecl_getAccessSpecifierLoc(AS::CXAccessSpecDecl)::CXSourceLocation_
end

function clang_AccessSpecDecl_setAccessSpecifierLoc(AS, ASLoc)
    @ccall libclangex.clang_AccessSpecDecl_setAccessSpecifierLoc(AS::CXAccessSpecDecl, ASLoc::CXSourceLocation_)::Cvoid
end

function clang_AccessSpecDecl_getColonLoc(AS)
    @ccall libclangex.clang_AccessSpecDecl_getColonLoc(AS::CXAccessSpecDecl)::CXSourceLocation_
end

function clang_AccessSpecDecl_setColonLoc(AS, CLoc)
    @ccall libclangex.clang_AccessSpecDecl_setColonLoc(AS::CXAccessSpecDecl, CLoc::CXSourceLocation_)::Cvoid
end

function clang_AccessSpecDecl_getSourceRange(AS)
    @ccall libclangex.clang_AccessSpecDecl_getSourceRange(AS::CXAccessSpecDecl)::CXSourceRange_
end

function clang_AccessSpecDecl_Create(C, AS, DC, ASLoc, ColonLoc)
    @ccall libclangex.clang_AccessSpecDecl_Create(C::CXASTContext, AS::CXAccessSpecifier, DC::CXDeclContext, ASLoc::CXSourceLocation_, ColonLoc::CXSourceLocation_)::CXAccessSpecDecl
end

function clang_AccessSpecDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_AccessSpecDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXAccessSpecDecl
end

function clang_CXXBaseSpecifier_getSourceRange(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getSourceRange(CXXBS::CXCXXBaseSpecifier)::CXSourceRange_
end

function clang_CXXBaseSpecifier_getColonLoc(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getColonLoc(CXXBS::CXCXXBaseSpecifier)::CXSourceLocation_
end

function clang_CXXBaseSpecifier_getEndLoc(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getEndLoc(CXXBS::CXCXXBaseSpecifier)::CXSourceLocation_
end

function clang_CXXBaseSpecifier_getBaseTypeLoc(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getBaseTypeLoc(CXXBS::CXCXXBaseSpecifier)::CXSourceLocation_
end

function clang_CXXBaseSpecifier_isVirtual(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_isVirtual(CXXBS::CXCXXBaseSpecifier)::Bool
end

function clang_CXXBaseSpecifier_isBaseOfClass(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_isBaseOfClass(CXXBS::CXCXXBaseSpecifier)::Bool
end

function clang_CXXBaseSpecifier_isPackExpansion(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_isPackExpansion(CXXBS::CXCXXBaseSpecifier)::Bool
end

function clang_CXXBaseSpecifier_getInheritConstructors(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getInheritConstructors(CXXBS::CXCXXBaseSpecifier)::Bool
end

function clang_CXXBaseSpecifier_setInheritConstructors(CXXBS, Inherit)
    @ccall libclangex.clang_CXXBaseSpecifier_setInheritConstructors(CXXBS::CXCXXBaseSpecifier, Inherit::Bool)::Cvoid
end

function clang_CXXBaseSpecifier_getEllipsisLoc(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getEllipsisLoc(CXXBS::CXCXXBaseSpecifier)::CXSourceLocation_
end

function clang_CXXBaseSpecifier_getAccessSpecifier(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getAccessSpecifier(CXXBS::CXCXXBaseSpecifier)::CXAccessSpecifier
end

function clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getAccessSpecifierAsWritten(CXXBS::CXCXXBaseSpecifier)::CXAccessSpecifier
end

function clang_CXXBaseSpecifier_getType(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getType(CXXBS::CXCXXBaseSpecifier)::CXQualType
end

function clang_CXXBaseSpecifier_getTypeSourceInfo(CXXBS)
    @ccall libclangex.clang_CXXBaseSpecifier_getTypeSourceInfo(CXXBS::CXCXXBaseSpecifier)::CXTypeSourceInfo
end

function clang_CXXRecordDecl_getCanonicalDecl(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getCanonicalDecl(CXXRD::CXCXXRecordDecl)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_getPreviousDecl(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getPreviousDecl(CXXRD::CXCXXRecordDecl)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_getMostRecentDecl(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getMostRecentDecl(CXXRD::CXCXXRecordDecl)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getMostRecentNonInjectedDecl(CXXRD::CXCXXRecordDecl)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_getDefinition(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getDefinition(CXXRD::CXCXXRecordDecl)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_hasDefinition(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasDefinition(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_Create(C, TK, DC, StartLoc, IdLoc, Id, PrevDecl, DelayTypeCreation)
    @ccall libclangex.clang_CXXRecordDecl_Create(C::CXASTContext, TK::CXTagTypeKind, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, PrevDecl::CXCXXRecordDecl, DelayTypeCreation::Bool)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_CreateLambda(C, DC, Info, Loc, DependentLambda, IsGeneric, CaptureDefault)
    @ccall libclangex.clang_CXXRecordDecl_CreateLambda(C::CXASTContext, DC::CXDeclContext, Info::CXTypeSourceInfo, Loc::CXSourceLocation_, DependentLambda::Bool, IsGeneric::Bool, CaptureDefault::CXLambdaCaptureDefault)::CXCXXRecordDecl
end

function clang_CXXRecordDecl_isDynamicClass(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isDynamicClass(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isLambda(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isLambda(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isGenericLambda(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isGenericLambda(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getGenericLambdaTemplateParameterList(CXXRD::CXCXXRecordDecl)::CXTemplateParameterList
end

function clang_CXXRecordDecl_isAggregate(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isAggregate(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isPOD(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isPOD(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isCLike(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isCLike(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isEmpty(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isEmpty(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_allowConstDefaultInit(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_allowConstDefaultInit(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_defaultedCopyConstructorIsDeleted(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_defaultedCopyConstructorIsDeleted(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_defaultedDefaultConstructorIsConstexpr(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_defaultedDefaultConstructorIsConstexpr(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_defaultedDestructorIsConstexpr(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_defaultedDestructorIsConstexpr(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_defaultedDestructorIsDeleted(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_defaultedDestructorIsDeleted(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_defaultedMoveConstructorIsDeleted(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_defaultedMoveConstructorIsDeleted(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasAnyDependentBases(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasAnyDependentBases(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasConstexprDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasConstexprDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasConstexprDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasConstexprDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasConstexprNonCopyMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasConstexprNonCopyMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasCopyAssignmentWithConstParam(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasCopyAssignmentWithConstParam(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasCopyConstructorWithConstParam(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasCopyConstructorWithConstParam(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasDirectFields(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasDirectFields(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasFriends(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasFriends(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasInClassInitializer(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasInClassInitializer(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasInheritedAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasInheritedAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasInheritedConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasInheritedConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasInitMethod(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasInitMethod(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasIrrelevantDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasIrrelevantDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasKnownLambdaInternalLinkage(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasKnownLambdaInternalLinkage(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasMutableFields(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasMutableFields(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonLiteralTypeFieldsOrBases(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonLiteralTypeFieldsOrBases(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialCopyConstructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialCopyConstructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialDestructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialDestructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasNonTrivialMoveConstructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasNonTrivialMoveConstructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasPrivateFields(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasPrivateFields(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasProtectedFields(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasProtectedFields(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasSimpleCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasSimpleCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasSimpleCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasSimpleCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasSimpleDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasSimpleDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasSimpleMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasSimpleMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasSimpleMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasSimpleMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialCopyConstructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialCopyConstructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialDestructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialDestructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasTrivialMoveConstructorForCall(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasTrivialMoveConstructorForCall(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUninitializedReferenceMember(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUninitializedReferenceMember(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserDeclaredMoveOperation(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserDeclaredMoveOperation(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasUserProvidedDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasUserProvidedDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_hasVariantMembers(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_hasVariantMembers(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isAbstract(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isAbstract(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isAnyDestructorNoReturn(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isAnyDestructorNoReturn(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isCXX11StandardLayout(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isCXX11StandardLayout(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isCapturelessLambda(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isCapturelessLambda(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isDependentLambda(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isDependentLambda(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isEffectivelyFinal(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isEffectivelyFinal(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isInterfaceLike(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isInterfaceLike(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isLiteral(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isLiteral(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isNeverDependentLambda(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isNeverDependentLambda(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isParsingBaseSpecifiers(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isParsingBaseSpecifiers(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isPolymorphic(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isPolymorphic(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isStandardLayout(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isStandardLayout(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isStructural(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isStructural(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isTrivial(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isTrivial(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isTriviallyCopyConstructible(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isTriviallyCopyConstructible(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_isTriviallyCopyable(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_isTriviallyCopyable(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_mayBeAbstract(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_mayBeAbstract(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_mayBeDynamicClass(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_mayBeDynamicClass(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_mayBeNonDynamicClass(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_mayBeNonDynamicClass(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitDefaultConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitDefaultConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsImplicitMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsImplicitMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsOverloadResolutionForCopyAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsOverloadResolutionForCopyAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsOverloadResolutionForCopyConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsOverloadResolutionForCopyConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsOverloadResolutionForDestructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsOverloadResolutionForDestructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsOverloadResolutionForMoveAssignment(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsOverloadResolutionForMoveAssignment(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_needsOverloadResolutionForMoveConstructor(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_needsOverloadResolutionForMoveConstructor(CXXRD::CXCXXRecordDecl)::Bool
end

function clang_CXXRecordDecl_getNumBases(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getNumBases(CXXRD::CXCXXRecordDecl)::Cuint
end

function clang_CXXRecordDecl_getBase(CXXRD, i)
    @ccall libclangex.clang_CXXRecordDecl_getBase(CXXRD::CXCXXRecordDecl, i::Cuint)::CXCXXBaseSpecifier
end

function clang_CXXRecordDecl_getNumVBases(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getNumVBases(CXXRD::CXCXXRecordDecl)::Cuint
end

function clang_CXXRecordDecl_getVBase(CXXRD, i)
    @ccall libclangex.clang_CXXRecordDecl_getVBase(CXXRD::CXCXXRecordDecl, i::Cuint)::CXCXXBaseSpecifier
end

function clang_CXXRecordDecl_getNumMethods(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getNumMethods(CXXRD::CXCXXRecordDecl)::Cuint
end

function clang_CXXRecordDecl_getMethods(CXXRD, Buf)
    @ccall libclangex.clang_CXXRecordDecl_getMethods(CXXRD::CXCXXRecordDecl, Buf::Ptr{CXCXXMethodDecl})::Cvoid
end

function clang_CXXRecordDecl_getNumCtors(CXXRD)
    @ccall libclangex.clang_CXXRecordDecl_getNumCtors(CXXRD::CXCXXRecordDecl)::Cuint
end

function clang_CXXRecordDecl_getCtors(CXXRD, Buf)
    @ccall libclangex.clang_CXXRecordDecl_getCtors(CXXRD::CXCXXRecordDecl, Buf::Ptr{CXCXXConstructorDecl})::Cvoid
end

function clang_ExplicitSpecifier_getKind(ES)
    @ccall libclangex.clang_ExplicitSpecifier_getKind(ES::CXExplicitSpecifier)::CXExplicitSpecKind
end

function clang_ExplicitSpecifier_getExpr(ES)
    @ccall libclangex.clang_ExplicitSpecifier_getExpr(ES::CXExplicitSpecifier)::CXExpr
end

function clang_ExplicitSpecifier_isSpecified(ES)
    @ccall libclangex.clang_ExplicitSpecifier_isSpecified(ES::CXExplicitSpecifier)::Bool
end

function clang_ExplicitSpecifier_isExplicit(ES)
    @ccall libclangex.clang_ExplicitSpecifier_isExplicit(ES::CXExplicitSpecifier)::Bool
end

function clang_ExplicitSpecifier_isInvalid(ES)
    @ccall libclangex.clang_ExplicitSpecifier_isInvalid(ES::CXExplicitSpecifier)::Bool
end

function clang_ExplicitSpecifier_setKind(ES, Kind)
    @ccall libclangex.clang_ExplicitSpecifier_setKind(ES::CXExplicitSpecifier, Kind::CXExplicitSpecKind)::Cvoid
end

function clang_ExplicitSpecifier_setExpr(ES, E)
    @ccall libclangex.clang_ExplicitSpecifier_setExpr(ES::CXExplicitSpecifier, E::CXExpr)::Cvoid
end

function clang_RequiresExprBodyDecl_Create(C, DC, StartLoc)
    @ccall libclangex.clang_RequiresExprBodyDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_)::CXRequiresExprBodyDecl
end

function clang_RequiresExprBodyDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_RequiresExprBodyDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXRequiresExprBodyDecl
end

function clang_CXXMethodDecl_Create(C, RD, StartLoc, NameInfo, T, TInfo, SC, UsesFPIntrin, isInline, ConstexprKind, EndLocation, TrailingRequiresClause)
    @ccall libclangex.clang_CXXMethodDecl_Create(C::CXASTContext, RD::CXCXXRecordDecl, StartLoc::CXSourceLocation_, NameInfo::CXDeclarationNameInfo, T::CXQualType, TInfo::CXTypeSourceInfo, SC::CXStorageClass, UsesFPIntrin::Bool, isInline::Bool, ConstexprKind::CXConstexprSpecKind, EndLocation::CXSourceLocation_, TrailingRequiresClause::CXExpr)::CXCXXMethodDecl
end

function clang_CXXMethodDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_CXXMethodDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXCXXMethodDecl
end

function clang_CXXMethodDecl_isStatic(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isStatic(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isInstance(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isInstance(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isConst(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isConst(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isVolatile(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isVolatile(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isVirtual(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isVirtual(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_getDevirtualizedMethod(CXXMD, Base, IsAppleKext)
    @ccall libclangex.clang_CXXMethodDecl_getDevirtualizedMethod(CXXMD::CXCXXMethodDecl, Base::CXExpr, IsAppleKext::Bool)::CXCXXMethodDecl
end

function clang_CXXMethodDecl_isCopyAssignmentOperator(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isCopyAssignmentOperator(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isMoveAssignmentOperator(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isMoveAssignmentOperator(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_getCanonicalDecl(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_getCanonicalDecl(CXXMD::CXCXXMethodDecl)::CXCXXMethodDecl
end

function clang_CXXMethodDecl_getMostRecentDecl(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_getMostRecentDecl(CXXMD::CXCXXMethodDecl)::CXCXXMethodDecl
end

function clang_CXXMethodDecl_addOverriddenMethod(CXXMD, MD)
    @ccall libclangex.clang_CXXMethodDecl_addOverriddenMethod(CXXMD::CXCXXMethodDecl, MD::CXCXXMethodDecl)::Cvoid
end

function clang_CXXMethodDecl_getParent(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_getParent(CXXMD::CXCXXMethodDecl)::CXCXXRecordDecl
end

function clang_CXXMethodDecl_getThisType(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_getThisType(CXXMD::CXCXXMethodDecl)::CXQualType
end

function clang_CXXMethodDecl_hasInlineBody(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_hasInlineBody(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_isLambdaStaticInvoker(CXXMD)
    @ccall libclangex.clang_CXXMethodDecl_isLambdaStaticInvoker(CXXMD::CXCXXMethodDecl)::Bool
end

function clang_CXXMethodDecl_getCorrespondingMethodInClass(CXXMD, RD, MayBeBase)
    @ccall libclangex.clang_CXXMethodDecl_getCorrespondingMethodInClass(CXXMD::CXCXXMethodDecl, RD::CXCXXRecordDecl, MayBeBase::Bool)::CXCXXRecordDecl
end

function clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(CXXMD, RD, MayBeBase)
    @ccall libclangex.clang_CXXMethodDecl_getCorrespondingMethodDeclaredInClass(CXXMD::CXCXXMethodDecl, RD::CXCXXRecordDecl, MayBeBase::Bool)::CXCXXRecordDecl
end

function clang_CXXConstructorDecl_isExplicit(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isExplicit(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isDefaultConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isDefaultConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isCopyConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isCopyConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isMoveConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isMoveConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isCopyOrMoveConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isCopyOrMoveConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isDelegatingConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isDelegatingConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isInheritingConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isInheritingConstructor(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_isSpecializationCopyingObject(CD)
    @ccall libclangex.clang_CXXConstructorDecl_isSpecializationCopyingObject(CD::CXCXXConstructorDecl)::Bool
end

function clang_CXXConstructorDecl_getNumCtorInitializers(CD)
    @ccall libclangex.clang_CXXConstructorDecl_getNumCtorInitializers(CD::CXCXXConstructorDecl)::Cuint
end

function clang_CXXConstructorDecl_getTargetConstructor(CD)
    @ccall libclangex.clang_CXXConstructorDecl_getTargetConstructor(CD::CXCXXConstructorDecl)::CXCXXConstructorDecl
end

function clang_CXXDestructorDecl_getOperatorDelete(DD)
    @ccall libclangex.clang_CXXDestructorDecl_getOperatorDelete(DD::CXCXXDestructorDecl)::CXFunctionDecl
end

function clang_CXXConversionDecl_getConversionType(CD)
    @ccall libclangex.clang_CXXConversionDecl_getConversionType(CD::CXCXXConversionDecl)::CXQualType
end

function clang_CXXConversionDecl_isExplicit(CD)
    @ccall libclangex.clang_CXXConversionDecl_isExplicit(CD::CXCXXConversionDecl)::Bool
end

function clang_CXXConversionDecl_isLambdaToBlockPointerConversion(CD)
    @ccall libclangex.clang_CXXConversionDecl_isLambdaToBlockPointerConversion(CD::CXCXXConversionDecl)::Bool
end

@enum CXLinkageSpecLanguageIDs::UInt32 begin
    CXLinkageSpecDecl_lang_c = 1
    CXLinkageSpecDecl_lang_cxx = 2
end

function clang_LinkageSpecDecl_Create(C, DC, ExternLoc, LangLoc, Lang, HasBraces)
    @ccall libclangex.clang_LinkageSpecDecl_Create(C::CXASTContext, DC::CXDeclContext, ExternLoc::CXSourceLocation_, LangLoc::CXSourceLocation_, Lang::CXLinkageSpecLanguageIDs, HasBraces::Bool)::CXLinkageSpecDecl
end

function clang_LinkageSpecDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_LinkageSpecDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXLinkageSpecDecl
end

function clang_LinkageSpecDecl_getLanguage(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_getLanguage(LSD::CXLinkageSpecDecl)::CXLinkageSpecLanguageIDs
end

function clang_LinkageSpecDecl_setLanguage(LSD, Lang)
    @ccall libclangex.clang_LinkageSpecDecl_setLanguage(LSD::CXLinkageSpecDecl, Lang::CXLinkageSpecLanguageIDs)::Cvoid
end

function clang_LinkageSpecDecl_hasBraces(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_hasBraces(LSD::CXLinkageSpecDecl)::Bool
end

function clang_LinkageSpecDecl_getExternLoc(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_getExternLoc(LSD::CXLinkageSpecDecl)::CXSourceLocation_
end

function clang_LinkageSpecDecl_getRBraceLoc(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_getRBraceLoc(LSD::CXLinkageSpecDecl)::CXSourceLocation_
end

function clang_LinkageSpecDecl_setExternLoc(LSD, Loc)
    @ccall libclangex.clang_LinkageSpecDecl_setExternLoc(LSD::CXLinkageSpecDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_LinkageSpecDecl_setRBraceLoc(LSD, Loc)
    @ccall libclangex.clang_LinkageSpecDecl_setRBraceLoc(LSD::CXLinkageSpecDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_LinkageSpecDecl_getEndLoc(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_getEndLoc(LSD::CXLinkageSpecDecl)::CXSourceLocation_
end

function clang_LinkageSpecDecl_getSourceRange(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_getSourceRange(LSD::CXLinkageSpecDecl)::CXSourceRange_
end

function clang_LinkageSpecDecl_castToDeclContext(LSD)
    @ccall libclangex.clang_LinkageSpecDecl_castToDeclContext(LSD::CXLinkageSpecDecl)::CXDeclContext
end

function clang_LinkageSpecDecl_castFromDeclContext(DC)
    @ccall libclangex.clang_LinkageSpecDecl_castFromDeclContext(DC::CXDeclContext)::CXLinkageSpecDecl
end

function clang_DeclGroupRef_fromeDecl(D)
    @ccall libclangex.clang_DeclGroupRef_fromeDecl(D::CXDecl)::CXDeclGroupRef
end

function clang_DeclGroupRef_isNull(DG)
    @ccall libclangex.clang_DeclGroupRef_isNull(DG::CXDeclGroupRef)::Bool
end

function clang_DeclGroupRef_isSingleDecl(DG)
    @ccall libclangex.clang_DeclGroupRef_isSingleDecl(DG::CXDeclGroupRef)::Bool
end

function clang_DeclGroupRef_isDeclGroup(DG)
    @ccall libclangex.clang_DeclGroupRef_isDeclGroup(DG::CXDeclGroupRef)::Bool
end

function clang_DeclGroupRef_getSingleDecl(DG)
    @ccall libclangex.clang_DeclGroupRef_getSingleDecl(DG::CXDeclGroupRef)::CXDecl
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
    CXLinkage_Invalid = 0x0000000000000000
    CXLinkage_None = 0x0000000000000001
    CXLinkage_Internal = 0x0000000000000002
    CXLinkage_UniqueExternal = 0x0000000000000003
    CXLinkage_VisibleNone = 0x0000000000000004
    CXLinkage_Module = 0x0000000000000005
    CXLinkage_External = 0x0000000000000006
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
    @ccall libclangex.clang_TranslationUnitDecl_getASTContext(TUD::CXTranslationUnitDecl)::CXASTContext
end

function clang_TranslationUnitDecl_getAnonymousNamespace(TUD)
    @ccall libclangex.clang_TranslationUnitDecl_getAnonymousNamespace(TUD::CXTranslationUnitDecl)::CXNamespaceDecl
end

function clang_TranslationUnitDecl_setAnonymousNamespace(TUD, ND)
    @ccall libclangex.clang_TranslationUnitDecl_setAnonymousNamespace(TUD::CXTranslationUnitDecl, ND::CXNamespaceDecl)::Cvoid
end

function clang_TranslationUnitDecl_Create(C)
    @ccall libclangex.clang_TranslationUnitDecl_Create(C::CXASTContext)::CXTranslationUnitDecl
end

function clang_PragmaCommentDecl_Create(C, DC, CommentLoc, CommentKind, Arg)
    @ccall libclangex.clang_PragmaCommentDecl_Create(C::CXASTContext, DC::CXTranslationUnitDecl, CommentLoc::CXSourceLocation_, CommentKind::CXPragmaMSCommentKind, Arg::Ptr{Cchar})::CXPragmaCommentDecl
end

function clang_PragmaCommentDecl_CreateDeserialized(C, ID, ArgSize)
    @ccall libclangex.clang_PragmaCommentDecl_CreateDeserialized(C::CXASTContext, ID::Cuint, ArgSize::Cuint)::CXPragmaCommentDecl
end

function clang_PragmaCommentDecl_getCommentKind(PCD)
    @ccall libclangex.clang_PragmaCommentDecl_getCommentKind(PCD::CXPragmaCommentDecl)::CXPragmaMSCommentKind
end

function clang_PragmaCommentDecl_getArg(PCD)
    @ccall libclangex.clang_PragmaCommentDecl_getArg(PCD::CXPragmaCommentDecl)::Ptr{Cchar}
end

function clang_PragmaDetectMismatchDecl_Create(C, DC, Loc, Name, Value)
    @ccall libclangex.clang_PragmaDetectMismatchDecl_Create(C::CXASTContext, DC::CXTranslationUnitDecl, Loc::CXSourceLocation_, Name::Ptr{Cchar}, Value::Ptr{Cchar})::CXPragmaDetectMismatchDecl
end

function clang_PragmaDetectMismatchDecl_CreateDeserialized(C, ID, NameValueSize)
    @ccall libclangex.clang_PragmaDetectMismatchDecl_CreateDeserialized(C::CXASTContext, ID::Cuint, NameValueSize::Cuint)::CXPragmaDetectMismatchDecl
end

function clang_PragmaDetectMismatchDecl_getName(PDMD)
    @ccall libclangex.clang_PragmaDetectMismatchDecl_getName(PDMD::CXPragmaDetectMismatchDecl)::Ptr{Cchar}
end

function clang_PragmaDetectMismatchDecl_getValue(PDMD)
    @ccall libclangex.clang_PragmaDetectMismatchDecl_getValue(PDMD::CXPragmaDetectMismatchDecl)::Ptr{Cchar}
end

function clang_ExternCContextDecl_Create(C, TU)
    @ccall libclangex.clang_ExternCContextDecl_Create(C::CXASTContext, TU::CXTranslationUnitDecl)::CXExternCContextDecl
end

function clang_NamedDecl_getIdentifier(ND)
    @ccall libclangex.clang_NamedDecl_getIdentifier(ND::CXNamedDecl)::CXIdentifierInfo
end

function clang_NamedDecl_getName(ND)
    @ccall libclangex.clang_NamedDecl_getName(ND::CXNamedDecl)::Ptr{Cchar}
end

function clang_NamedDecl_getDeclName(ND)
    @ccall libclangex.clang_NamedDecl_getDeclName(ND::CXNamedDecl)::CXDeclarationName
end

function clang_NamedDecl_setDeclName(ND, DN)
    @ccall libclangex.clang_NamedDecl_setDeclName(ND::CXNamedDecl, DN::CXDeclarationName)::Cvoid
end

function clang_NamedDecl_declarationReplaces(ND, OldD, IsKnownNewer)
    @ccall libclangex.clang_NamedDecl_declarationReplaces(ND::CXNamedDecl, OldD::CXNamedDecl, IsKnownNewer::Bool)::Bool
end

function clang_NamedDecl_hasLinkage(ND)
    @ccall libclangex.clang_NamedDecl_hasLinkage(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_isCXXClassMember(ND)
    @ccall libclangex.clang_NamedDecl_isCXXClassMember(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_isCXXInstanceMember(ND)
    @ccall libclangex.clang_NamedDecl_isCXXInstanceMember(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_getLinkageInternal(ND)
    @ccall libclangex.clang_NamedDecl_getLinkageInternal(ND::CXNamedDecl)::CXLinkage
end

function clang_NamedDecl_getFormalLinkage(ND)
    @ccall libclangex.clang_NamedDecl_getFormalLinkage(ND::CXNamedDecl)::CXLinkage
end

function clang_NamedDecl_hasExternalFormalLinkage(ND)
    @ccall libclangex.clang_NamedDecl_hasExternalFormalLinkage(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_isExternallyVisible(ND)
    @ccall libclangex.clang_NamedDecl_isExternallyVisible(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_isExternallyDeclarable(ND)
    @ccall libclangex.clang_NamedDecl_isExternallyDeclarable(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_getVisibility(ND)
    @ccall libclangex.clang_NamedDecl_getVisibility(ND::CXNamedDecl)::CXVisibility
end

function clang_NamedDecl_isLinkageValid(ND)
    @ccall libclangex.clang_NamedDecl_isLinkageValid(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_hasLinkageBeenComputed(ND)
    @ccall libclangex.clang_NamedDecl_hasLinkageBeenComputed(ND::CXNamedDecl)::Bool
end

function clang_NamedDecl_getUnderlyingDecl(ND)
    @ccall libclangex.clang_NamedDecl_getUnderlyingDecl(ND::CXNamedDecl)::CXNamedDecl
end

function clang_NamedDecl_getMostRecentDecl(ND)
    @ccall libclangex.clang_NamedDecl_getMostRecentDecl(ND::CXNamedDecl)::CXNamedDecl
end

function clang_NamedDecl_castToTypeDecl(ND)
    @ccall libclangex.clang_NamedDecl_castToTypeDecl(ND::CXNamedDecl)::CXTypeDecl
end

function clang_NamedDecl_castToEnumConstantDecl(ND)
    @ccall libclangex.clang_NamedDecl_castToEnumConstantDecl(ND::CXNamedDecl)::CXEnumConstantDecl
end

function clang_LabelDecl_Create(C, DC, IdentL, II)
    @ccall libclangex.clang_LabelDecl_Create(C::CXASTContext, DC::CXDeclContext, IdentL::CXSourceLocation_, II::CXIdentifierInfo)::CXLabelDecl
end

function clang_LabelDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_LabelDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXLabelDecl
end

function clang_LabelDecl_getStmt(LD)
    @ccall libclangex.clang_LabelDecl_getStmt(LD::CXLabelDecl)::CXLabelStmt
end

function clang_LabelDecl_setStmt(LD, T)
    @ccall libclangex.clang_LabelDecl_setStmt(LD::CXLabelDecl, T::CXLabelStmt)::Cvoid
end

function clang_LabelDecl_isGnuLocal(LD)
    @ccall libclangex.clang_LabelDecl_isGnuLocal(LD::CXLabelDecl)::Bool
end

function clang_LabelDecl_setLocStart(LD, Loc)
    @ccall libclangex.clang_LabelDecl_setLocStart(LD::CXLabelDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_LabelDecl_getSourceRange(LD)
    @ccall libclangex.clang_LabelDecl_getSourceRange(LD::CXLabelDecl)::CXSourceRange_
end

function clang_LabelDecl_isMSAsmLabel(LD)
    @ccall libclangex.clang_LabelDecl_isMSAsmLabel(LD::CXLabelDecl)::Bool
end

function clang_LabelDecl_isResolvedMSAsmLabel(LD)
    @ccall libclangex.clang_LabelDecl_isResolvedMSAsmLabel(LD::CXLabelDecl)::Bool
end

function clang_LabelDecl_getMSAsmLabel(LD)
    @ccall libclangex.clang_LabelDecl_getMSAsmLabel(LD::CXLabelDecl)::Ptr{Cchar}
end

function clang_LabelDecl_setMSAsmLabelResolved(LD)
    @ccall libclangex.clang_LabelDecl_setMSAsmLabelResolved(LD::CXLabelDecl)::Cvoid
end

function clang_NamespaceDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_NamespaceDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXNamespaceDecl
end

function clang_NamespaceDecl_isAnonymousNamespace(ND)
    @ccall libclangex.clang_NamespaceDecl_isAnonymousNamespace(ND::CXNamespaceDecl)::Bool
end

function clang_NamespaceDecl_isInline(ND)
    @ccall libclangex.clang_NamespaceDecl_isInline(ND::CXNamespaceDecl)::Bool
end

function clang_NamespaceDecl_setInline(ND, Inline)
    @ccall libclangex.clang_NamespaceDecl_setInline(ND::CXNamespaceDecl, Inline::Bool)::Cvoid
end

function clang_NamespaceDecl_getOriginalNamespace(ND)
    @ccall libclangex.clang_NamespaceDecl_getOriginalNamespace(ND::CXNamespaceDecl)::CXNamespaceDecl
end

function clang_NamespaceDecl_isOriginalNamespace(ND)
    @ccall libclangex.clang_NamespaceDecl_isOriginalNamespace(ND::CXNamespaceDecl)::Bool
end

function clang_NamespaceDecl_getAnonymousNamespace(ND)
    @ccall libclangex.clang_NamespaceDecl_getAnonymousNamespace(ND::CXNamespaceDecl)::CXNamespaceDecl
end

function clang_NamespaceDecl_setAnonymousNamespace(ND, D)
    @ccall libclangex.clang_NamespaceDecl_setAnonymousNamespace(ND::CXNamespaceDecl, D::CXNamespaceDecl)::Cvoid
end

function clang_NamespaceDecl_getCanonicalDecl(ND)
    @ccall libclangex.clang_NamespaceDecl_getCanonicalDecl(ND::CXNamespaceDecl)::CXNamespaceDecl
end

function clang_NamespaceDecl_getSourceRange(ND)
    @ccall libclangex.clang_NamespaceDecl_getSourceRange(ND::CXNamespaceDecl)::CXSourceRange_
end

function clang_NamespaceDecl_getBeginLoc(ND)
    @ccall libclangex.clang_NamespaceDecl_getBeginLoc(ND::CXNamespaceDecl)::CXSourceLocation_
end

function clang_NamespaceDecl_getRBraceLoc(ND)
    @ccall libclangex.clang_NamespaceDecl_getRBraceLoc(ND::CXNamespaceDecl)::CXSourceLocation_
end

function clang_NamespaceDecl_setLocStart(ND, Loc)
    @ccall libclangex.clang_NamespaceDecl_setLocStart(ND::CXNamespaceDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_NamespaceDecl_setRBraceLoc(ND, Loc)
    @ccall libclangex.clang_NamespaceDecl_setRBraceLoc(ND::CXNamespaceDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_ValueDecl_getType(VD)
    @ccall libclangex.clang_ValueDecl_getType(VD::CXValueDecl)::CXQualType
end

function clang_ValueDecl_setType(VD, OpaquePtr)
    @ccall libclangex.clang_ValueDecl_setType(VD::CXValueDecl, OpaquePtr::CXQualType)::Cvoid
end

function clang_ValueDecl_isWeak(VD)
    @ccall libclangex.clang_ValueDecl_isWeak(VD::CXValueDecl)::Bool
end

function clang_DeclaratorDecl_getTypeSourceInfo(DD)
    @ccall libclangex.clang_DeclaratorDecl_getTypeSourceInfo(DD::CXDeclaratorDecl)::CXTypeSourceInfo
end

function clang_DeclaratorDecl_setTypeSourceInfo(DD, TI)
    @ccall libclangex.clang_DeclaratorDecl_setTypeSourceInfo(DD::CXDeclaratorDecl, TI::CXTypeSourceInfo)::Cvoid
end

function clang_DeclaratorDecl_getInnerLocStart(DD)
    @ccall libclangex.clang_DeclaratorDecl_getInnerLocStart(DD::CXDeclaratorDecl)::CXSourceLocation_
end

function clang_DeclaratorDecl_setInnerLocStart(DD, Loc)
    @ccall libclangex.clang_DeclaratorDecl_setInnerLocStart(DD::CXDeclaratorDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_DeclaratorDecl_getOuterLocStart(DD)
    @ccall libclangex.clang_DeclaratorDecl_getOuterLocStart(DD::CXDeclaratorDecl)::CXSourceLocation_
end

function clang_DeclaratorDecl_getBeginLoc(DD)
    @ccall libclangex.clang_DeclaratorDecl_getBeginLoc(DD::CXDeclaratorDecl)::CXSourceLocation_
end

function clang_DeclaratorDecl_getQualifier(DD)
    @ccall libclangex.clang_DeclaratorDecl_getQualifier(DD::CXDeclaratorDecl)::CXNestedNameSpecifier
end

function clang_DeclaratorDecl_getTrailingRequiresClause(DD)
    @ccall libclangex.clang_DeclaratorDecl_getTrailingRequiresClause(DD::CXDeclaratorDecl)::CXExpr
end

function clang_DeclaratorDecl_setTrailingRequiresClause(DD, TrailingRequiresClause)
    @ccall libclangex.clang_DeclaratorDecl_setTrailingRequiresClause(DD::CXDeclaratorDecl, TrailingRequiresClause::CXExpr)::Cvoid
end

function clang_DeclaratorDecl_getNumTemplateParameterLists(DD)
    @ccall libclangex.clang_DeclaratorDecl_getNumTemplateParameterLists(DD::CXDeclaratorDecl)::Cuint
end

function clang_DeclaratorDecl_getTemplateParameterList(DD, index)
    @ccall libclangex.clang_DeclaratorDecl_getTemplateParameterList(DD::CXDeclaratorDecl, index::Cuint)::CXTemplateParameterList
end

function clang_DeclaratorDecl_getTypeSpecStartLoc(DD)
    @ccall libclangex.clang_DeclaratorDecl_getTypeSpecStartLoc(DD::CXDeclaratorDecl)::CXSourceLocation_
end

function clang_DeclaratorDecl_getTypeSpecEndLoc(DD)
    @ccall libclangex.clang_DeclaratorDecl_getTypeSpecEndLoc(DD::CXDeclaratorDecl)::CXSourceLocation_
end

function clang_VarDecl_Create(C, DC, StartLoc, IdLoc, Id, T, TInfo, S)
    @ccall libclangex.clang_VarDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, T::CXQualType, TInfo::CXTypeSourceInfo, S::CXStorageClass)::CXVarDecl
end

function clang_VarDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_VarDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXVarDecl
end

function clang_VarDecl_getSourceRange(VD)
    @ccall libclangex.clang_VarDecl_getSourceRange(VD::CXVarDecl)::CXSourceRange_
end

function clang_VarDecl_getStorageClass(VD)
    @ccall libclangex.clang_VarDecl_getStorageClass(VD::CXVarDecl)::CXStorageClass
end

function clang_VarDecl_setStorageClass(VD, SC)
    @ccall libclangex.clang_VarDecl_setStorageClass(VD::CXVarDecl, SC::CXStorageClass)::Cvoid
end

function clang_VarDecl_setTSCSpec(VD, TSC)
    @ccall libclangex.clang_VarDecl_setTSCSpec(VD::CXVarDecl, TSC::CXThreadStorageClassSpecifier)::Cvoid
end

function clang_VarDecl_getTSCSpec(VD)
    @ccall libclangex.clang_VarDecl_getTSCSpec(VD::CXVarDecl)::CXThreadStorageClassSpecifier
end

function clang_VarDecl_hasLocalStorage(VD)
    @ccall libclangex.clang_VarDecl_hasLocalStorage(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isStaticLocal(VD)
    @ccall libclangex.clang_VarDecl_isStaticLocal(VD::CXVarDecl)::Bool
end

function clang_VarDecl_hasExternalStorage(VD)
    @ccall libclangex.clang_VarDecl_hasExternalStorage(VD::CXVarDecl)::Bool
end

function clang_VarDecl_hasGlobalStorage(VD)
    @ccall libclangex.clang_VarDecl_hasGlobalStorage(VD::CXVarDecl)::Bool
end

function clang_VarDecl_getStorageDuration(VD)
    @ccall libclangex.clang_VarDecl_getStorageDuration(VD::CXVarDecl)::CXStorageDuration
end

function clang_VarDecl_getLanguageLinkage(VD)
    @ccall libclangex.clang_VarDecl_getLanguageLinkage(VD::CXVarDecl)::CXLanguageLinkage
end

function clang_VarDecl_isExternC(VD)
    @ccall libclangex.clang_VarDecl_isExternC(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isInExternCContext(VD)
    @ccall libclangex.clang_VarDecl_isInExternCContext(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isInExternCXXContext(VD)
    @ccall libclangex.clang_VarDecl_isInExternCXXContext(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isLocalVarDecl(VD)
    @ccall libclangex.clang_VarDecl_isLocalVarDecl(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isLocalVarDeclOrParm(VD)
    @ccall libclangex.clang_VarDecl_isLocalVarDeclOrParm(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isFunctionOrMethodVarDecl(VD)
    @ccall libclangex.clang_VarDecl_isFunctionOrMethodVarDecl(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isStaticDataMember(VD)
    @ccall libclangex.clang_VarDecl_isStaticDataMember(VD::CXVarDecl)::Bool
end

function clang_VarDecl_getCanonicalDecl(VD)
    @ccall libclangex.clang_VarDecl_getCanonicalDecl(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_getActingDefinition(VD)
    @ccall libclangex.clang_VarDecl_getActingDefinition(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_getDefinition(VD)
    @ccall libclangex.clang_VarDecl_getDefinition(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_isOutOfLine(VD)
    @ccall libclangex.clang_VarDecl_isOutOfLine(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isFileVarDecl(VD)
    @ccall libclangex.clang_VarDecl_isFileVarDecl(VD::CXVarDecl)::Bool
end

function clang_VarDecl_getAnyInitializer(VD)
    @ccall libclangex.clang_VarDecl_getAnyInitializer(VD::CXVarDecl)::CXExpr
end

function clang_VarDecl_hasInit(VD)
    @ccall libclangex.clang_VarDecl_hasInit(VD::CXVarDecl)::Bool
end

function clang_VarDecl_getInit(VD)
    @ccall libclangex.clang_VarDecl_getInit(VD::CXVarDecl)::CXExpr
end

function clang_VarDecl_setInit(VD, I)
    @ccall libclangex.clang_VarDecl_setInit(VD::CXVarDecl, I::CXExpr)::Cvoid
end

function clang_VarDecl_getInitializingDeclaration(VD)
    @ccall libclangex.clang_VarDecl_getInitializingDeclaration(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_mightBeUsableInConstantExpressions(VD, C)
    @ccall libclangex.clang_VarDecl_mightBeUsableInConstantExpressions(VD::CXVarDecl, C::CXASTContext)::Bool
end

function clang_VarDecl_isUsableInConstantExpressions(VD, C)
    @ccall libclangex.clang_VarDecl_isUsableInConstantExpressions(VD::CXVarDecl, C::CXASTContext)::Bool
end

function clang_VarDecl_ensureEvaluatedStmt(VD)
    @ccall libclangex.clang_VarDecl_ensureEvaluatedStmt(VD::CXVarDecl)::CXEvaluatedStmt
end

function clang_VarDecl_getEvaluatedStmt(VD)
    @ccall libclangex.clang_VarDecl_getEvaluatedStmt(VD::CXVarDecl)::CXEvaluatedStmt
end

function clang_VarDecl_hasConstantInitialization(VD)
    @ccall libclangex.clang_VarDecl_hasConstantInitialization(VD::CXVarDecl)::Bool
end

function clang_VarDecl_hasICEInitializer(VD, Context)
    @ccall libclangex.clang_VarDecl_hasICEInitializer(VD::CXVarDecl, Context::CXASTContext)::Bool
end

function clang_VarDecl_isDirectInit(VD)
    @ccall libclangex.clang_VarDecl_isDirectInit(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isThisDeclarationADemotedDefinition(VD)
    @ccall libclangex.clang_VarDecl_isThisDeclarationADemotedDefinition(VD::CXVarDecl)::Bool
end

function clang_VarDecl_demoteThisDefinitionToDeclaration(VD)
    @ccall libclangex.clang_VarDecl_demoteThisDefinitionToDeclaration(VD::CXVarDecl)::Cvoid
end

function clang_VarDecl_isExceptionVariable(VD)
    @ccall libclangex.clang_VarDecl_isExceptionVariable(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setExceptionVariable(VD, EV)
    @ccall libclangex.clang_VarDecl_setExceptionVariable(VD::CXVarDecl, EV::Bool)::Cvoid
end

function clang_VarDecl_isNRVOVariable(VD)
    @ccall libclangex.clang_VarDecl_isNRVOVariable(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setNRVOVariable(VD, NRVO)
    @ccall libclangex.clang_VarDecl_setNRVOVariable(VD::CXVarDecl, NRVO::Bool)::Cvoid
end

function clang_VarDecl_isCXXForRangeDecl(VD)
    @ccall libclangex.clang_VarDecl_isCXXForRangeDecl(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setCXXForRangeDecl(VD, FRD)
    @ccall libclangex.clang_VarDecl_setCXXForRangeDecl(VD::CXVarDecl, FRD::Bool)::Cvoid
end

function clang_VarDecl_isObjCForDecl(VD)
    @ccall libclangex.clang_VarDecl_isObjCForDecl(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setObjCForDecl(VD, FRD)
    @ccall libclangex.clang_VarDecl_setObjCForDecl(VD::CXVarDecl, FRD::Bool)::Cvoid
end

function clang_VarDecl_isARCPseudoStrong(VD)
    @ccall libclangex.clang_VarDecl_isARCPseudoStrong(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setARCPseudoStrong(VD, PS)
    @ccall libclangex.clang_VarDecl_setARCPseudoStrong(VD::CXVarDecl, PS::Bool)::Cvoid
end

function clang_VarDecl_isInline(VD)
    @ccall libclangex.clang_VarDecl_isInline(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isInlineSpecified(VD)
    @ccall libclangex.clang_VarDecl_isInlineSpecified(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setInlineSpecified(VD)
    @ccall libclangex.clang_VarDecl_setInlineSpecified(VD::CXVarDecl)::Cvoid
end

function clang_VarDecl_setImplicitlyInline(VD)
    @ccall libclangex.clang_VarDecl_setImplicitlyInline(VD::CXVarDecl)::Cvoid
end

function clang_VarDecl_isConstexpr(VD)
    @ccall libclangex.clang_VarDecl_isConstexpr(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setConstexpr(VD, IC)
    @ccall libclangex.clang_VarDecl_setConstexpr(VD::CXVarDecl, IC::Bool)::Cvoid
end

function clang_VarDecl_isInitCapture(VD)
    @ccall libclangex.clang_VarDecl_isInitCapture(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setInitCapture(VD, IC)
    @ccall libclangex.clang_VarDecl_setInitCapture(VD::CXVarDecl, IC::Bool)::Cvoid
end

function clang_VarDecl_isParameterPack(VD)
    @ccall libclangex.clang_VarDecl_isParameterPack(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isPreviousDeclInSameBlockScope(VD)
    @ccall libclangex.clang_VarDecl_isPreviousDeclInSameBlockScope(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setPreviousDeclInSameBlockScope(VD, Same)
    @ccall libclangex.clang_VarDecl_setPreviousDeclInSameBlockScope(VD::CXVarDecl, Same::Bool)::Cvoid
end

function clang_VarDecl_isEscapingByref(VD)
    @ccall libclangex.clang_VarDecl_isEscapingByref(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isNonEscapingByref(VD)
    @ccall libclangex.clang_VarDecl_isNonEscapingByref(VD::CXVarDecl)::Bool
end

function clang_VarDecl_setEscapingByref(VD)
    @ccall libclangex.clang_VarDecl_setEscapingByref(VD::CXVarDecl)::Cvoid
end

function clang_VarDecl_getTemplateInstantiationPattern(VD)
    @ccall libclangex.clang_VarDecl_getTemplateInstantiationPattern(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_getInstantiatedFromStaticDataMember(VD)
    @ccall libclangex.clang_VarDecl_getInstantiatedFromStaticDataMember(VD::CXVarDecl)::CXVarDecl
end

function clang_VarDecl_getTemplateSpecializationKind(VD)
    @ccall libclangex.clang_VarDecl_getTemplateSpecializationKind(VD::CXVarDecl)::CXTemplateSpecializationKind
end

function clang_VarDecl_getTemplateSpecializationKindForInstantiation(VD)
    @ccall libclangex.clang_VarDecl_getTemplateSpecializationKindForInstantiation(VD::CXVarDecl)::CXTemplateSpecializationKind
end

function clang_VarDecl_getPointOfInstantiation(VD)
    @ccall libclangex.clang_VarDecl_getPointOfInstantiation(VD::CXVarDecl)::CXSourceLocation_
end

function clang_VarDecl_setTemplateSpecializationKind(VD, TSK, PointOfInstantiation)
    @ccall libclangex.clang_VarDecl_setTemplateSpecializationKind(VD::CXVarDecl, TSK::CXTemplateSpecializationKind, PointOfInstantiation::CXSourceLocation_)::Cvoid
end

function clang_VarDecl_setInstantiationOfStaticDataMember(VD, VD2, TSK)
    @ccall libclangex.clang_VarDecl_setInstantiationOfStaticDataMember(VD::CXVarDecl, VD2::CXVarDecl, TSK::CXTemplateSpecializationKind)::Cvoid
end

function clang_VarDecl_getDescribedVarTemplate(VD)
    @ccall libclangex.clang_VarDecl_getDescribedVarTemplate(VD::CXVarDecl)::CXVarTemplateDecl
end

function clang_VarDecl_setDescribedVarTemplate(VD, Template)
    @ccall libclangex.clang_VarDecl_setDescribedVarTemplate(VD::CXVarDecl, Template::CXVarTemplateDecl)::Cvoid
end

function clang_VarDecl_isKnownToBeDefined(VD)
    @ccall libclangex.clang_VarDecl_isKnownToBeDefined(VD::CXVarDecl)::Bool
end

function clang_VarDecl_isNoDestroy(VD, AST)
    @ccall libclangex.clang_VarDecl_isNoDestroy(VD::CXVarDecl, AST::CXASTContext)::Bool
end

@enum CXImplicitParamKind::UInt32 begin
    CXImplicitParamKind_ObjCSelf = 0x0000000000000000
    CXImplicitParamKind_ObjCCmd = 0x0000000000000001
    CXImplicitParamKind_CXXThis = 0x0000000000000002
    CXImplicitParamKind_CXXVTT = 0x0000000000000003
    CXImplicitParamKind_CapturedContext = 0x0000000000000004
    CXImplicitParamKind_ThreadPrivateVar = 0x0000000000000005
    CXImplicitParamKind_Other = 0x0000000000000006
end

function clang_ImplicitParamDecl_Create(C, DC, IdLoc, Id, T, ParamKind)
    @ccall libclangex.clang_ImplicitParamDecl_Create(C::CXASTContext, DC::CXDeclContext, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, T::CXQualType, ParamKind::CXImplicitParamKind)::CXImplicitParamDecl
end

function clang_ImplicitParamDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_ImplicitParamDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXImplicitParamDecl
end

function clang_ImplicitParamDecl_getParameterKind(IPD)
    @ccall libclangex.clang_ImplicitParamDecl_getParameterKind(IPD::CXImplicitParamDecl)::CXImplicitParamKind
end

function clang_ParmVarDecl_Create(C, DC, StartLoc, IdLoc, Id, T, TInfo, S, DefArg)
    @ccall libclangex.clang_ParmVarDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, T::CXQualType, TInfo::CXTypeSourceInfo, S::CXStorageClass, DefArg::CXExpr)::CXParmVarDecl
end

function clang_ParmVarDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_ParmVarDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXParmVarDecl
end

function clang_ParmVarDecl_setObjCMethodScopeInfo(PVD, parameterIndex)
    @ccall libclangex.clang_ParmVarDecl_setObjCMethodScopeInfo(PVD::CXParmVarDecl, parameterIndex::Cuint)::Cvoid
end

function clang_ParmVarDecl_setScopeInfo(PVD, scopeDepth, parameterIndex)
    @ccall libclangex.clang_ParmVarDecl_setScopeInfo(PVD::CXParmVarDecl, scopeDepth::Cuint, parameterIndex::Cuint)::Cvoid
end

function clang_ParmVarDecl_isObjCMethodParameter(PVD)
    @ccall libclangex.clang_ParmVarDecl_isObjCMethodParameter(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_isDestroyedInCallee(PVD)
    @ccall libclangex.clang_ParmVarDecl_isDestroyedInCallee(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_getFunctionScopeDepth(PVD)
    @ccall libclangex.clang_ParmVarDecl_getFunctionScopeDepth(PVD::CXParmVarDecl)::Cuint
end

function clang_ParmVarDecl_getFunctionScopeIndex(PVD)
    @ccall libclangex.clang_ParmVarDecl_getFunctionScopeIndex(PVD::CXParmVarDecl)::Cuint
end

function clang_ParmVarDecl_isKNRPromoted(PVD)
    @ccall libclangex.clang_ParmVarDecl_isKNRPromoted(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_setKNRPromoted(PVD, promoted)
    @ccall libclangex.clang_ParmVarDecl_setKNRPromoted(PVD::CXParmVarDecl, promoted::Bool)::Cvoid
end

function clang_ParmVarDecl_getDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_getDefaultArg(PVD::CXParmVarDecl)::CXExpr
end

function clang_ParmVarDecl_setDefaultArg(PVD, defarg)
    @ccall libclangex.clang_ParmVarDecl_setDefaultArg(PVD::CXParmVarDecl, defarg::CXExpr)::Cvoid
end

function clang_ParmVarDecl_getDefaultArgRange(PVD)
    @ccall libclangex.clang_ParmVarDecl_getDefaultArgRange(PVD::CXParmVarDecl)::CXSourceRange_
end

function clang_ParmVarDecl_setUninstantiatedDefaultArg(PVD, arg)
    @ccall libclangex.clang_ParmVarDecl_setUninstantiatedDefaultArg(PVD::CXParmVarDecl, arg::CXExpr)::Cvoid
end

function clang_ParmVarDecl_getUninstantiatedDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_getUninstantiatedDefaultArg(PVD::CXParmVarDecl)::CXExpr
end

function clang_ParmVarDecl_hasDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_hasDefaultArg(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_hasUnparsedDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_hasUnparsedDefaultArg(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_hasUninstantiatedDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_hasUninstantiatedDefaultArg(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_setUnparsedDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_setUnparsedDefaultArg(PVD::CXParmVarDecl)::Cvoid
end

function clang_ParmVarDecl_hasInheritedDefaultArg(PVD)
    @ccall libclangex.clang_ParmVarDecl_hasInheritedDefaultArg(PVD::CXParmVarDecl)::Bool
end

function clang_ParmVarDecl_setHasInheritedDefaultArg(PVD, I)
    @ccall libclangex.clang_ParmVarDecl_setHasInheritedDefaultArg(PVD::CXParmVarDecl, I::Bool)::Cvoid
end

function clang_ParmVarDecl_getOriginalType(PVD)
    @ccall libclangex.clang_ParmVarDecl_getOriginalType(PVD::CXParmVarDecl)::CXQualType
end

function clang_ParmVarDecl_setOwningFunction(PVD, FD)
    @ccall libclangex.clang_ParmVarDecl_setOwningFunction(PVD::CXParmVarDecl, FD::CXDeclContext)::Cvoid
end

@enum CXMultiVersionKind::UInt32 begin
    CXMultiVersionKind_None = 0
    CXMultiVersionKind_Target = 1
    CXMultiVersionKind_CPUSpecific = 2
    CXMultiVersionKind_CPUDispatch = 3
    CXMultiVersionKind_TargetClones = 4
    CXMultiVersionKind_TargetVersion = 5
end

@enum CXFunctionDecl_TemplatedKind::UInt32 begin
    CXFunctionDecl_TK_NonTemplate = 0
    CXFunctionDecl_TK_FunctionTemplate = 1
    CXFunctionDecl_TK_MemberSpecialization = 2
    CXFunctionDecl_TK_FunctionTemplateSpecialization = 3
    CXFunctionDecl_TK_DependentFunctionTemplateSpecialization = 4
    CXFunctionDecl_TK_DependentNonTemplate = 5
end

const CXFunctionDecl_DefaultedFunctionInfo = Ptr{Cvoid}

function clang_FunctionDecl_Create(C, DC, StartLoc, NLoc, N, T, TInfo, SC, isInlineSpecified, hasWrittenPrototype)
    @ccall libclangex.clang_FunctionDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, NLoc::CXSourceLocation_, N::CXDeclarationName, T::CXQualType, TInfo::CXTypeSourceInfo, SC::CXStorageClass, isInlineSpecified::Bool, hasWrittenPrototype::Bool)::CXFunctionDecl
end

function clang_FunctionDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_FunctionDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXFunctionDecl
end

function clang_FunctionDecl_setRangeEnd(FD, Loc)
    @ccall libclangex.clang_FunctionDecl_setRangeEnd(FD::CXFunctionDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_FunctionDecl_getEllipsisLoc(FD)
    @ccall libclangex.clang_FunctionDecl_getEllipsisLoc(FD::CXFunctionDecl)::CXSourceLocation_
end

function clang_FunctionDecl_getSourceRange(FD)
    @ccall libclangex.clang_FunctionDecl_getSourceRange(FD::CXFunctionDecl)::CXSourceRange_
end

function clang_FunctionDecl_hasBody(FD)
    @ccall libclangex.clang_FunctionDecl_hasBody(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_hasTrivialBody(FD)
    @ccall libclangex.clang_FunctionDecl_hasTrivialBody(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isDefined(FD)
    @ccall libclangex.clang_FunctionDecl_isDefined(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getDefinition(FD)
    @ccall libclangex.clang_FunctionDecl_getDefinition(FD::CXFunctionDecl)::CXFunctionDecl
end

function clang_FunctionDecl_getBody(FD)
    @ccall libclangex.clang_FunctionDecl_getBody(FD::CXFunctionDecl)::CXStmt
end

function clang_FunctionDecl_isThisDeclarationADefinition(FD)
    @ccall libclangex.clang_FunctionDecl_isThisDeclarationADefinition(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(FD)
    @ccall libclangex.clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_doesThisDeclarationHaveABody(FD)
    @ccall libclangex.clang_FunctionDecl_doesThisDeclarationHaveABody(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setBody(FD, B)
    @ccall libclangex.clang_FunctionDecl_setBody(FD::CXFunctionDecl, B::CXStmt)::Cvoid
end

function clang_FunctionDecl_setLazyBody(FD, Offset)
    @ccall libclangex.clang_FunctionDecl_setLazyBody(FD::CXFunctionDecl, Offset::UInt64)::Cvoid
end

function clang_FunctionDecl_setDefaultedFunctionInfo(FD, Info)
    @ccall libclangex.clang_FunctionDecl_setDefaultedFunctionInfo(FD::CXFunctionDecl, Info::CXFunctionDecl_DefaultedFunctionInfo)::Cvoid
end

function clang_FunctionDecl_isVariadic(FD)
    @ccall libclangex.clang_FunctionDecl_isVariadic(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isVirtualAsWritten(FD)
    @ccall libclangex.clang_FunctionDecl_isVirtualAsWritten(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setVirtualAsWritten(FD, V)
    @ccall libclangex.clang_FunctionDecl_setVirtualAsWritten(FD::CXFunctionDecl, V::Bool)::Cvoid
end

function clang_FunctionDecl_isPureVirtual(FD)
    @ccall libclangex.clang_FunctionDecl_isPureVirtual(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setIsPureVirtual(FD, P)
    @ccall libclangex.clang_FunctionDecl_setIsPureVirtual(FD::CXFunctionDecl, P::Bool)::Cvoid
end

function clang_FunctionDecl_isLateTemplateParsed(FD)
    @ccall libclangex.clang_FunctionDecl_isLateTemplateParsed(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setLateTemplateParsed(FD, ILT)
    @ccall libclangex.clang_FunctionDecl_setLateTemplateParsed(FD::CXFunctionDecl, ILT::Bool)::Cvoid
end

function clang_FunctionDecl_isTrivial(FD)
    @ccall libclangex.clang_FunctionDecl_isTrivial(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setTrivial(FD, IT)
    @ccall libclangex.clang_FunctionDecl_setTrivial(FD::CXFunctionDecl, IT::Bool)::Cvoid
end

function clang_FunctionDecl_isTrivialForCall(FD)
    @ccall libclangex.clang_FunctionDecl_isTrivialForCall(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setTrivialForCall(FD, IT)
    @ccall libclangex.clang_FunctionDecl_setTrivialForCall(FD::CXFunctionDecl, IT::Bool)::Cvoid
end

function clang_FunctionDecl_isDefaulted(FD)
    @ccall libclangex.clang_FunctionDecl_isDefaulted(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setDefaulted(FD, D)
    @ccall libclangex.clang_FunctionDecl_setDefaulted(FD::CXFunctionDecl, D::Bool)::Cvoid
end

function clang_FunctionDecl_isExplicitlyDefaulted(FD)
    @ccall libclangex.clang_FunctionDecl_isExplicitlyDefaulted(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setExplicitlyDefaulted(FD, ED)
    @ccall libclangex.clang_FunctionDecl_setExplicitlyDefaulted(FD::CXFunctionDecl, ED::Bool)::Cvoid
end

function clang_FunctionDecl_isUserProvided(FD)
    @ccall libclangex.clang_FunctionDecl_isUserProvided(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_hasImplicitReturnZero(FD)
    @ccall libclangex.clang_FunctionDecl_hasImplicitReturnZero(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setHasImplicitReturnZero(FD, IRZ)
    @ccall libclangex.clang_FunctionDecl_setHasImplicitReturnZero(FD::CXFunctionDecl, IRZ::Bool)::Cvoid
end

function clang_FunctionDecl_hasPrototype(FD)
    @ccall libclangex.clang_FunctionDecl_hasPrototype(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_hasWrittenPrototype(FD)
    @ccall libclangex.clang_FunctionDecl_hasWrittenPrototype(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setHasWrittenPrototype(FD, P)
    @ccall libclangex.clang_FunctionDecl_setHasWrittenPrototype(FD::CXFunctionDecl, P::Bool)::Cvoid
end

function clang_FunctionDecl_hasInheritedPrototype(FD)
    @ccall libclangex.clang_FunctionDecl_hasInheritedPrototype(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setHasInheritedPrototype(FD, P)
    @ccall libclangex.clang_FunctionDecl_setHasInheritedPrototype(FD::CXFunctionDecl, P::Bool)::Cvoid
end

function clang_FunctionDecl_isConstexpr(FD)
    @ccall libclangex.clang_FunctionDecl_isConstexpr(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setConstexprKind(FD, CSK)
    @ccall libclangex.clang_FunctionDecl_setConstexprKind(FD::CXFunctionDecl, CSK::CXConstexprSpecKind)::Cvoid
end

function clang_FunctionDecl_getConstexprKind(FD)
    @ccall libclangex.clang_FunctionDecl_getConstexprKind(FD::CXFunctionDecl)::CXConstexprSpecKind
end

function clang_FunctionDecl_isConstexprSpecified(FD)
    @ccall libclangex.clang_FunctionDecl_isConstexprSpecified(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isConsteval(FD)
    @ccall libclangex.clang_FunctionDecl_isConsteval(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_instantiationIsPending(FD)
    @ccall libclangex.clang_FunctionDecl_instantiationIsPending(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setInstantiationIsPending(FD, IC)
    @ccall libclangex.clang_FunctionDecl_setInstantiationIsPending(FD::CXFunctionDecl, IC::Bool)::Cvoid
end

function clang_FunctionDecl_usesSEHTry(FD)
    @ccall libclangex.clang_FunctionDecl_usesSEHTry(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setUsesSEHTry(FD, UST)
    @ccall libclangex.clang_FunctionDecl_setUsesSEHTry(FD::CXFunctionDecl, UST::Bool)::Cvoid
end

function clang_FunctionDecl_isDeleted(FD)
    @ccall libclangex.clang_FunctionDecl_isDeleted(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isDeletedAsWritten(FD)
    @ccall libclangex.clang_FunctionDecl_isDeletedAsWritten(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setDeletedAsWritten(FD, D)
    @ccall libclangex.clang_FunctionDecl_setDeletedAsWritten(FD::CXFunctionDecl, D::Bool)::Cvoid
end

function clang_FunctionDecl_isMain(FD)
    @ccall libclangex.clang_FunctionDecl_isMain(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isMSVCRTEntryPoint(FD)
    @ccall libclangex.clang_FunctionDecl_isMSVCRTEntryPoint(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isReservedGlobalPlacementOperator(FD)
    @ccall libclangex.clang_FunctionDecl_isReservedGlobalPlacementOperator(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isReplaceableGlobalAllocationFunction(FD)
    @ccall libclangex.clang_FunctionDecl_isReplaceableGlobalAllocationFunction(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isInlineBuiltinDeclaration(FD)
    @ccall libclangex.clang_FunctionDecl_isInlineBuiltinDeclaration(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isDestroyingOperatorDelete(FD)
    @ccall libclangex.clang_FunctionDecl_isDestroyingOperatorDelete(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getLanguageLinkage(FD)
    @ccall libclangex.clang_FunctionDecl_getLanguageLinkage(FD::CXFunctionDecl)::CXLanguageLinkage
end

function clang_FunctionDecl_isExternC(FD)
    @ccall libclangex.clang_FunctionDecl_isExternC(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isInExternCContext(FD)
    @ccall libclangex.clang_FunctionDecl_isInExternCContext(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isInExternCXXContext(FD)
    @ccall libclangex.clang_FunctionDecl_isInExternCXXContext(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isGlobal(FD)
    @ccall libclangex.clang_FunctionDecl_isGlobal(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isNoReturn(FD)
    @ccall libclangex.clang_FunctionDecl_isNoReturn(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_hasSkippedBody(FD)
    @ccall libclangex.clang_FunctionDecl_hasSkippedBody(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setHasSkippedBody(FD, Skipped)
    @ccall libclangex.clang_FunctionDecl_setHasSkippedBody(FD::CXFunctionDecl, Skipped::Bool)::Cvoid
end

function clang_FunctionDecl_willHaveBody(FD)
    @ccall libclangex.clang_FunctionDecl_willHaveBody(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setWillHaveBody(FD, V)
    @ccall libclangex.clang_FunctionDecl_setWillHaveBody(FD::CXFunctionDecl, V::Bool)::Cvoid
end

function clang_FunctionDecl_isMultiVersion(FD)
    @ccall libclangex.clang_FunctionDecl_isMultiVersion(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setIsMultiVersion(FD, V)
    @ccall libclangex.clang_FunctionDecl_setIsMultiVersion(FD::CXFunctionDecl, V::Bool)::Cvoid
end

function clang_FunctionDecl_getMultiVersionKind(FD)
    @ccall libclangex.clang_FunctionDecl_getMultiVersionKind(FD::CXFunctionDecl)::CXMultiVersionKind
end

function clang_FunctionDecl_isCPUDispatchMultiVersion(FD)
    @ccall libclangex.clang_FunctionDecl_isCPUDispatchMultiVersion(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isCPUSpecificMultiVersion(FD)
    @ccall libclangex.clang_FunctionDecl_isCPUSpecificMultiVersion(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isTargetMultiVersion(FD)
    @ccall libclangex.clang_FunctionDecl_isTargetMultiVersion(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setPreviousDeclaration(FD, PrevDecl)
    @ccall libclangex.clang_FunctionDecl_setPreviousDeclaration(FD::CXFunctionDecl, PrevDecl::CXFunctionDecl)::Cvoid
end

function clang_FunctionDecl_getCanonicalDecl(FD)
    @ccall libclangex.clang_FunctionDecl_getCanonicalDecl(FD::CXFunctionDecl)::CXFunctionDecl
end

function clang_FunctionDecl_getBuiltinID(FD)
    @ccall libclangex.clang_FunctionDecl_getBuiltinID(FD::CXFunctionDecl)::Cuint
end

function clang_FunctionDecl_getNumParams(FD)
    @ccall libclangex.clang_FunctionDecl_getNumParams(FD::CXFunctionDecl)::Cuint
end

function clang_FunctionDecl_getParamDecl(FD, i)
    @ccall libclangex.clang_FunctionDecl_getParamDecl(FD::CXFunctionDecl, i::Cuint)::CXParmVarDecl
end

function clang_FunctionDecl_getMinRequiredArguments(FD)
    @ccall libclangex.clang_FunctionDecl_getMinRequiredArguments(FD::CXFunctionDecl)::Cuint
end

function clang_FunctionDecl_hasOneParamOrDefaultArgs(FD)
    @ccall libclangex.clang_FunctionDecl_hasOneParamOrDefaultArgs(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getReturnType(FD)
    @ccall libclangex.clang_FunctionDecl_getReturnType(FD::CXFunctionDecl)::CXQualType
end

function clang_FunctionDecl_getReturnTypeSourceRange(FD)
    @ccall libclangex.clang_FunctionDecl_getReturnTypeSourceRange(FD::CXFunctionDecl)::CXSourceRange_
end

function clang_FunctionDecl_getParametersSourceRange(FD)
    @ccall libclangex.clang_FunctionDecl_getParametersSourceRange(FD::CXFunctionDecl)::CXSourceRange_
end

function clang_FunctionDecl_getDeclaredReturnType(FD)
    @ccall libclangex.clang_FunctionDecl_getDeclaredReturnType(FD::CXFunctionDecl)::CXQualType
end

function clang_FunctionDecl_getExceptionSpecType(FD)
    @ccall libclangex.clang_FunctionDecl_getExceptionSpecType(FD::CXFunctionDecl)::CXExceptionSpecificationType
end

function clang_FunctionDecl_getExceptionSpecSourceRange(FD)
    @ccall libclangex.clang_FunctionDecl_getExceptionSpecSourceRange(FD::CXFunctionDecl)::CXSourceRange_
end

function clang_FunctionDecl_getCallResultType(FD)
    @ccall libclangex.clang_FunctionDecl_getCallResultType(FD::CXFunctionDecl)::CXQualType
end

function clang_FunctionDecl_getStorageClass(FD)
    @ccall libclangex.clang_FunctionDecl_getStorageClass(FD::CXFunctionDecl)::CXStorageClass
end

function clang_FunctionDecl_setStorageClass(FD, SClass)
    @ccall libclangex.clang_FunctionDecl_setStorageClass(FD::CXFunctionDecl, SClass::CXStorageClass)::Cvoid
end

function clang_FunctionDecl_isInlineSpecified(FD)
    @ccall libclangex.clang_FunctionDecl_isInlineSpecified(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_setInlineSpecified(FD, I)
    @ccall libclangex.clang_FunctionDecl_setInlineSpecified(FD::CXFunctionDecl, I::Bool)::Cvoid
end

function clang_FunctionDecl_setImplicitlyInline(FD, I)
    @ccall libclangex.clang_FunctionDecl_setImplicitlyInline(FD::CXFunctionDecl, I::Bool)::Cvoid
end

function clang_FunctionDecl_isInlined(FD)
    @ccall libclangex.clang_FunctionDecl_isInlined(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isInlineDefinitionExternallyVisible(FD)
    @ccall libclangex.clang_FunctionDecl_isInlineDefinitionExternallyVisible(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isMSExternInline(FD)
    @ccall libclangex.clang_FunctionDecl_isMSExternInline(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(FD)
    @ccall libclangex.clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isStatic(FD)
    @ccall libclangex.clang_FunctionDecl_isStatic(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isOverloadedOperator(FD)
    @ccall libclangex.clang_FunctionDecl_isOverloadedOperator(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getLiteralIdentifier(FD)
    @ccall libclangex.clang_FunctionDecl_getLiteralIdentifier(FD::CXFunctionDecl)::CXIdentifierInfo
end

function clang_FunctionDecl_getTemplatedKind(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplatedKind(FD::CXFunctionDecl)::CXFunctionDecl_TemplatedKind
end

function clang_FunctionDecl_getMemberSpecializationInfo(FD)
    @ccall libclangex.clang_FunctionDecl_getMemberSpecializationInfo(FD::CXFunctionDecl)::CXMemberSpecializationInfo
end

function clang_FunctionDecl_setInstantiationOfMemberFunction(FD, FD2, TSK)
    @ccall libclangex.clang_FunctionDecl_setInstantiationOfMemberFunction(FD::CXFunctionDecl, FD2::CXFunctionDecl, TSK::CXTemplateSpecializationKind)::Cvoid
end

function clang_FunctionDecl_getDescribedFunctionTemplate(FD)
    @ccall libclangex.clang_FunctionDecl_getDescribedFunctionTemplate(FD::CXFunctionDecl)::CXFunctionTemplateDecl
end

function clang_FunctionDecl_setDescribedFunctionTemplate(FD, Template)
    @ccall libclangex.clang_FunctionDecl_setDescribedFunctionTemplate(FD::CXFunctionDecl, Template::CXFunctionTemplateDecl)::Cvoid
end

function clang_FunctionDecl_getInstantiatedFromMemberFunction(FD)
    @ccall libclangex.clang_FunctionDecl_getInstantiatedFromMemberFunction(FD::CXFunctionDecl)::CXFunctionDecl
end

function clang_FunctionDecl_isFunctionTemplateSpecialization(FD)
    @ccall libclangex.clang_FunctionDecl_isFunctionTemplateSpecialization(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getTemplateSpecializationInfo(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplateSpecializationInfo(FD::CXFunctionDecl)::CXFunctionTemplateSpecializationInfo
end

function clang_FunctionDecl_isImplicitlyInstantiable(FD)
    @ccall libclangex.clang_FunctionDecl_isImplicitlyInstantiable(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_isTemplateInstantiation(FD)
    @ccall libclangex.clang_FunctionDecl_isTemplateInstantiation(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getTemplateInstantiationPattern(FD, ForDefinition)
    @ccall libclangex.clang_FunctionDecl_getTemplateInstantiationPattern(FD::CXFunctionDecl, ForDefinition::Bool)::CXFunctionDecl
end

function clang_FunctionDecl_getPrimaryTemplate(FD)
    @ccall libclangex.clang_FunctionDecl_getPrimaryTemplate(FD::CXFunctionDecl)::CXFunctionTemplateDecl
end

function clang_FunctionDecl_getTemplateSpecializationArgs(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplateSpecializationArgs(FD::CXFunctionDecl)::CXTemplateArgumentList
end

function clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(FD::CXFunctionDecl)::CXASTTemplateArgumentListInfo
end

function clang_FunctionDecl_getDependentSpecializationInfo(FD)
    @ccall libclangex.clang_FunctionDecl_getDependentSpecializationInfo(FD::CXFunctionDecl)::CXDependentFunctionTemplateSpecializationInfo
end

function clang_FunctionDecl_getTemplateSpecializationKind(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplateSpecializationKind(FD::CXFunctionDecl)::CXTemplateSpecializationKind
end

function clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(FD)
    @ccall libclangex.clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(FD::CXFunctionDecl)::CXTemplateSpecializationKind
end

function clang_FunctionDecl_setTemplateSpecializationKind(FD, TSK, PointOfInstantiation)
    @ccall libclangex.clang_FunctionDecl_setTemplateSpecializationKind(FD::CXFunctionDecl, TSK::CXTemplateSpecializationKind, PointOfInstantiation::CXSourceLocation_)::Cvoid
end

function clang_FunctionDecl_getPointOfInstantiation(FD)
    @ccall libclangex.clang_FunctionDecl_getPointOfInstantiation(FD::CXFunctionDecl)::CXSourceLocation_
end

function clang_FunctionDecl_isOutOfLine(FD)
    @ccall libclangex.clang_FunctionDecl_isOutOfLine(FD::CXFunctionDecl)::Bool
end

function clang_FunctionDecl_getMemoryFunctionKind(FD)
    @ccall libclangex.clang_FunctionDecl_getMemoryFunctionKind(FD::CXFunctionDecl)::Cuint
end

function clang_FunctionDecl_getODRHash(FD)
    @ccall libclangex.clang_FunctionDecl_getODRHash(FD::CXFunctionDecl)::Cuint
end

function clang_FieldDecl_Create(C, DC, StartLoc, IdLoc, I, T, TInfo, BW, Mutable, InitStyle)
    @ccall libclangex.clang_FieldDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, I::CXIdentifierInfo, T::CXQualType, TInfo::CXTypeSourceInfo, BW::CXExpr, Mutable::Bool, InitStyle::CXInClassInitStyle)::CXFieldDecl
end

function clang_FieldDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_FieldDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXFieldDecl
end

function clang_FieldDecl_getFieldIndex(FD)
    @ccall libclangex.clang_FieldDecl_getFieldIndex(FD::CXFieldDecl)::Cuint
end

function clang_FieldDecl_isMutable(FD)
    @ccall libclangex.clang_FieldDecl_isMutable(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_isBitField(FD)
    @ccall libclangex.clang_FieldDecl_isBitField(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_isUnnamedBitfield(FD)
    @ccall libclangex.clang_FieldDecl_isUnnamedBitfield(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_isAnonymousStructOrUnion(FD)
    @ccall libclangex.clang_FieldDecl_isAnonymousStructOrUnion(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_getBitWidth(FD)
    @ccall libclangex.clang_FieldDecl_getBitWidth(FD::CXFieldDecl)::CXExpr
end

function clang_FieldDecl_getBitWidthValue(FD, Ctx)
    @ccall libclangex.clang_FieldDecl_getBitWidthValue(FD::CXFieldDecl, Ctx::CXASTContext)::Cuint
end

function clang_FieldDecl_setBitWidth(FD, Width)
    @ccall libclangex.clang_FieldDecl_setBitWidth(FD::CXFieldDecl, Width::CXExpr)::Cvoid
end

function clang_FieldDecl_removeBitWidth(FD)
    @ccall libclangex.clang_FieldDecl_removeBitWidth(FD::CXFieldDecl)::Cvoid
end

function clang_FieldDecl_isZeroLengthBitField(FD, Ctx)
    @ccall libclangex.clang_FieldDecl_isZeroLengthBitField(FD::CXFieldDecl, Ctx::CXASTContext)::Bool
end

function clang_FieldDecl_isZeroSize(FD, Ctx)
    @ccall libclangex.clang_FieldDecl_isZeroSize(FD::CXFieldDecl, Ctx::CXASTContext)::Bool
end

function clang_FieldDecl_getInClassInitStyle(FD)
    @ccall libclangex.clang_FieldDecl_getInClassInitStyle(FD::CXFieldDecl)::CXInClassInitStyle
end

function clang_FieldDecl_hasInClassInitializer(FD)
    @ccall libclangex.clang_FieldDecl_hasInClassInitializer(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_getInClassInitializer(FD)
    @ccall libclangex.clang_FieldDecl_getInClassInitializer(FD::CXFieldDecl)::CXExpr
end

function clang_FieldDecl_setInClassInitializer(FD, Init)
    @ccall libclangex.clang_FieldDecl_setInClassInitializer(FD::CXFieldDecl, Init::CXExpr)::Cvoid
end

function clang_FieldDecl_removeInClassInitializer(FD)
    @ccall libclangex.clang_FieldDecl_removeInClassInitializer(FD::CXFieldDecl)::Cvoid
end

function clang_FieldDecl_hasCapturedVLAType(FD)
    @ccall libclangex.clang_FieldDecl_hasCapturedVLAType(FD::CXFieldDecl)::Bool
end

function clang_FieldDecl_getCapturedVLAType(FD)
    @ccall libclangex.clang_FieldDecl_getCapturedVLAType(FD::CXFieldDecl)::CXVariableArrayType
end

function clang_FieldDecl_setCapturedVLAType(FD, VLAType)
    @ccall libclangex.clang_FieldDecl_setCapturedVLAType(FD::CXFieldDecl, VLAType::CXVariableArrayType)::Cvoid
end

function clang_FieldDecl_getParent(FD)
    @ccall libclangex.clang_FieldDecl_getParent(FD::CXFieldDecl)::CXRecordDecl
end

function clang_FieldDecl_getSourceRange(FD)
    @ccall libclangex.clang_FieldDecl_getSourceRange(FD::CXFieldDecl)::CXSourceRange_
end

function clang_FieldDecl_getCanonicalDecl(FD)
    @ccall libclangex.clang_FieldDecl_getCanonicalDecl(FD::CXFieldDecl)::CXFieldDecl
end

function clang_EnumConstantDecl_Create(C, DC, L, Id, T, E, V)
    @ccall libclangex.clang_EnumConstantDecl_Create(C::CXASTContext, DC::CXEnumDecl, L::CXSourceLocation_, Id::CXIdentifierInfo, T::CXQualType, E::CXExpr, V::LLVMGenericValueRef)::CXEnumConstantDecl
end

function clang_EnumConstantDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_EnumConstantDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXEnumConstantDecl
end

function clang_EnumConstantDecl_getInitExpr(ECD)
    @ccall libclangex.clang_EnumConstantDecl_getInitExpr(ECD::CXEnumConstantDecl)::CXExpr
end

function clang_EnumConstantDecl_setInitExpr(ECD, E)
    @ccall libclangex.clang_EnumConstantDecl_setInitExpr(ECD::CXEnumConstantDecl, E::CXExpr)::Cvoid
end

function clang_EnumConstantDecl_getSourceRange(ECD)
    @ccall libclangex.clang_EnumConstantDecl_getSourceRange(ECD::CXEnumConstantDecl)::CXSourceRange_
end

function clang_EnumConstantDecl_getCanonicalDecl(ECD)
    @ccall libclangex.clang_EnumConstantDecl_getCanonicalDecl(ECD::CXEnumConstantDecl)::CXEnumConstantDecl
end

function clang_EnumConstantDecl_getEnumConstantDeclValue(ECD)
    @ccall libclangex.clang_EnumConstantDecl_getEnumConstantDeclValue(ECD::CXEnumConstantDecl)::Clonglong
end

function clang_IndirectFieldDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_IndirectFieldDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXIndirectFieldDecl
end

function clang_IndirectFieldDecl_getChainingSize(IFD)
    @ccall libclangex.clang_IndirectFieldDecl_getChainingSize(IFD::CXIndirectFieldDecl)::Cuint
end

function clang_IndirectFieldDecl_getAnonField(IFD)
    @ccall libclangex.clang_IndirectFieldDecl_getAnonField(IFD::CXIndirectFieldDecl)::CXFieldDecl
end

function clang_IndirectFieldDecl_getVarDecl(IFD)
    @ccall libclangex.clang_IndirectFieldDecl_getVarDecl(IFD::CXIndirectFieldDecl)::CXVarDecl
end

function clang_IndirectFieldDecl_getCanonicalDecl(IFD)
    @ccall libclangex.clang_IndirectFieldDecl_getCanonicalDecl(IFD::CXIndirectFieldDecl)::CXIndirectFieldDecl
end

function clang_TypeDecl_getTypeForDecl(TD)
    @ccall libclangex.clang_TypeDecl_getTypeForDecl(TD::CXTypeDecl)::CXType_
end

function clang_TypeDecl_setTypeForDecl(TD, Ty)
    @ccall libclangex.clang_TypeDecl_setTypeForDecl(TD::CXTypeDecl, Ty::CXType_)::Cvoid
end

function clang_TypeDecl_getBeginLoc(TD)
    @ccall libclangex.clang_TypeDecl_getBeginLoc(TD::CXTypeDecl)::CXSourceLocation_
end

function clang_TypeDecl_setLocStart(TD, Loc)
    @ccall libclangex.clang_TypeDecl_setLocStart(TD::CXTypeDecl, Loc::CXSourceLocation_)::Cvoid
end

function clang_TypeDecl_getSourceRange(TD)
    @ccall libclangex.clang_TypeDecl_getSourceRange(TD::CXTypeDecl)::CXSourceRange_
end

function clang_TypedefNameDecl_isModed(TND)
    @ccall libclangex.clang_TypedefNameDecl_isModed(TND::CXTypedefNameDecl)::Bool
end

function clang_TypedefNameDecl_getTypeSourceInfo(TND)
    @ccall libclangex.clang_TypedefNameDecl_getTypeSourceInfo(TND::CXTypedefNameDecl)::CXTypeSourceInfo
end

function clang_TypedefNameDecl_getUnderlyingType(TND)
    @ccall libclangex.clang_TypedefNameDecl_getUnderlyingType(TND::CXTypedefNameDecl)::CXQualType
end

function clang_TypedefNameDecl_setTypeSourceInfo(TND, newType)
    @ccall libclangex.clang_TypedefNameDecl_setTypeSourceInfo(TND::CXTypedefNameDecl, newType::CXTypeSourceInfo)::Cvoid
end

function clang_TypedefNameDecl_setModedTypeSourceInfo(TND, unmodedTSI, modedTy)
    @ccall libclangex.clang_TypedefNameDecl_setModedTypeSourceInfo(TND::CXTypedefNameDecl, unmodedTSI::CXTypeSourceInfo, modedTy::CXQualType)::Cvoid
end

function clang_TypedefNameDecl_getCanonicalDecl(TND)
    @ccall libclangex.clang_TypedefNameDecl_getCanonicalDecl(TND::CXTypedefNameDecl)::CXTypedefNameDecl
end

function clang_TypedefNameDecl_getAnonDeclWithTypedefName(TND, AnyRedecl)
    @ccall libclangex.clang_TypedefNameDecl_getAnonDeclWithTypedefName(TND::CXTypedefNameDecl, AnyRedecl::Bool)::CXTagDecl
end

function clang_TypedefNameDecl_isTransparentTag(TND)
    @ccall libclangex.clang_TypedefNameDecl_isTransparentTag(TND::CXTypedefNameDecl)::Bool
end

function clang_TypedefDecl_Create(C, DC, StartLoc, IdLoc, Id, TInfo)
    @ccall libclangex.clang_TypedefDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, TInfo::CXTypeSourceInfo)::CXTypedefDecl
end

function clang_TypedefDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_TypedefDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXTypedefDecl
end

function clang_TypedefDecl_getSourceRange(TD)
    @ccall libclangex.clang_TypedefDecl_getSourceRange(TD::CXTypedefDecl)::CXSourceRange_
end

function clang_TypeAliasDecl_Create(C, DC, StartLoc, IdLoc, Id, TInfo)
    @ccall libclangex.clang_TypeAliasDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, TInfo::CXTypeSourceInfo)::CXTypeAliasDecl
end

function clang_TypeAliasDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_TypeAliasDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXTypeAliasDecl
end

function clang_TypeAliasDecl_getSourceRange(TAD)
    @ccall libclangex.clang_TypeAliasDecl_getSourceRange(TAD::CXTypeAliasDecl)::CXSourceRange_
end

function clang_TypeAliasDecl_getDescribedAliasTemplate(TAD)
    @ccall libclangex.clang_TypeAliasDecl_getDescribedAliasTemplate(TAD::CXTypeAliasDecl)::CXTypeAliasTemplateDecl
end

function clang_TypeAliasDecl_setDescribedAliasTemplate(TAD, TAT)
    @ccall libclangex.clang_TypeAliasDecl_setDescribedAliasTemplate(TAD::CXTypeAliasDecl, TAT::CXTypeAliasTemplateDecl)::Cvoid
end

function clang_TagDecl_getBraceRange(TD)
    @ccall libclangex.clang_TagDecl_getBraceRange(TD::CXTagDecl)::CXSourceRange_
end

function clang_TagDecl_setBraceRange(TD, R)
    @ccall libclangex.clang_TagDecl_setBraceRange(TD::CXTagDecl, R::CXSourceRange_)::Cvoid
end

function clang_TagDecl_getInnerLocStart(TD)
    @ccall libclangex.clang_TagDecl_getInnerLocStart(TD::CXTagDecl)::CXSourceLocation_
end

function clang_TagDecl_getOuterLocStart(TD)
    @ccall libclangex.clang_TagDecl_getOuterLocStart(TD::CXTagDecl)::CXSourceLocation_
end

function clang_TagDecl_getSourceRange(TD)
    @ccall libclangex.clang_TagDecl_getSourceRange(TD::CXTagDecl)::CXSourceRange_
end

function clang_TagDecl_getCanonicalDecl(TD)
    @ccall libclangex.clang_TagDecl_getCanonicalDecl(TD::CXTagDecl)::CXTagDecl
end

function clang_TagDecl_isThisDeclarationADefinition(TD)
    @ccall libclangex.clang_TagDecl_isThisDeclarationADefinition(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isCompleteDefinition(TD)
    @ccall libclangex.clang_TagDecl_isCompleteDefinition(TD::CXTagDecl)::Bool
end

function clang_TagDecl_setCompleteDefinition(TD, V)
    @ccall libclangex.clang_TagDecl_setCompleteDefinition(TD::CXTagDecl, V::Bool)::Cvoid
end

function clang_TagDecl_isCompleteDefinitionRequired(TD)
    @ccall libclangex.clang_TagDecl_isCompleteDefinitionRequired(TD::CXTagDecl)::Bool
end

function clang_TagDecl_setCompleteDefinitionRequired(TD, V)
    @ccall libclangex.clang_TagDecl_setCompleteDefinitionRequired(TD::CXTagDecl, V::Bool)::Cvoid
end

function clang_TagDecl_isBeingDefined(TD)
    @ccall libclangex.clang_TagDecl_isBeingDefined(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isEmbeddedInDeclarator(TD)
    @ccall libclangex.clang_TagDecl_isEmbeddedInDeclarator(TD::CXTagDecl)::Bool
end

function clang_TagDecl_setEmbeddedInDeclarator(TD, isInDeclarator)
    @ccall libclangex.clang_TagDecl_setEmbeddedInDeclarator(TD::CXTagDecl, isInDeclarator::Bool)::Cvoid
end

function clang_TagDecl_isFreeStanding(TD)
    @ccall libclangex.clang_TagDecl_isFreeStanding(TD::CXTagDecl)::Bool
end

function clang_TagDecl_setFreeStanding(TD, isFreeStanding)
    @ccall libclangex.clang_TagDecl_setFreeStanding(TD::CXTagDecl, isFreeStanding::Bool)::Cvoid
end

function clang_TagDecl_mayHaveOutOfDateDef(TD)
    @ccall libclangex.clang_TagDecl_mayHaveOutOfDateDef(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isDependentType(TD)
    @ccall libclangex.clang_TagDecl_isDependentType(TD::CXTagDecl)::Bool
end

function clang_TagDecl_startDefinition(TD)
    @ccall libclangex.clang_TagDecl_startDefinition(TD::CXTagDecl)::Cvoid
end

function clang_TagDecl_getDefinition(TD)
    @ccall libclangex.clang_TagDecl_getDefinition(TD::CXTagDecl)::CXTagDecl
end

function clang_TagDecl_getKindName(TD)
    @ccall libclangex.clang_TagDecl_getKindName(TD::CXTagDecl)::Ptr{Cchar}
end

function clang_TagDecl_getTagKind(TD)
    @ccall libclangex.clang_TagDecl_getTagKind(TD::CXTagDecl)::CXTagTypeKind
end

function clang_TagDecl_setTagKind(TD, TK)
    @ccall libclangex.clang_TagDecl_setTagKind(TD::CXTagDecl, TK::CXTagTypeKind)::Cvoid
end

function clang_TagDecl_isStruct(TD)
    @ccall libclangex.clang_TagDecl_isStruct(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isInterface(TD)
    @ccall libclangex.clang_TagDecl_isInterface(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isClass(TD)
    @ccall libclangex.clang_TagDecl_isClass(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isUnion(TD)
    @ccall libclangex.clang_TagDecl_isUnion(TD::CXTagDecl)::Bool
end

function clang_TagDecl_isEnum(TD)
    @ccall libclangex.clang_TagDecl_isEnum(TD::CXTagDecl)::Bool
end

function clang_TagDecl_hasNameForLinkage(TD)
    @ccall libclangex.clang_TagDecl_hasNameForLinkage(TD::CXTagDecl)::Bool
end

function clang_TagDecl_getTypedefNameForAnonDecl(TD)
    @ccall libclangex.clang_TagDecl_getTypedefNameForAnonDecl(TD::CXTagDecl)::CXTypedefNameDecl
end

function clang_TagDecl_setTypedefNameForAnonDecl(TD, TDD)
    @ccall libclangex.clang_TagDecl_setTypedefNameForAnonDecl(TD::CXTagDecl, TDD::CXTypedefNameDecl)::Cvoid
end

function clang_TagDecl_getQualifier(TD)
    @ccall libclangex.clang_TagDecl_getQualifier(TD::CXTagDecl)::CXNestedNameSpecifier
end

function clang_TagDecl_getNumTemplateParameterLists(TD)
    @ccall libclangex.clang_TagDecl_getNumTemplateParameterLists(TD::CXTagDecl)::Cuint
end

function clang_TagDecl_getTemplateParameterList(TD, i)
    @ccall libclangex.clang_TagDecl_getTemplateParameterList(TD::CXTagDecl, i::Cuint)::CXTemplateParameterList
end

function clang_TagDecl_castToDeclContext(TD)
    @ccall libclangex.clang_TagDecl_castToDeclContext(TD::CXTagDecl)::CXDeclContext
end

function clang_EnumDecl_Create(C, DC, StartLoc, IdLoc, Id, PrevDecl, IsScoped, IsScopedUsingClassTag, IsFixed)
    @ccall libclangex.clang_EnumDecl_Create(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, PrevDecl::CXEnumDecl, IsScoped::Bool, IsScopedUsingClassTag::Bool, IsFixed::Bool)::CXEnumDecl
end

function clang_EnumDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_EnumDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXEnumDecl
end

function clang_EnumDecl_setScoped(ED, Scoped)
    @ccall libclangex.clang_EnumDecl_setScoped(ED::CXEnumDecl, Scoped::Bool)::Cvoid
end

function clang_EnumDecl_setScopedUsingClassTag(ED, ScopedUCT)
    @ccall libclangex.clang_EnumDecl_setScopedUsingClassTag(ED::CXEnumDecl, ScopedUCT::Bool)::Cvoid
end

function clang_EnumDecl_setFixed(ED, Fixed)
    @ccall libclangex.clang_EnumDecl_setFixed(ED::CXEnumDecl, Fixed::Bool)::Cvoid
end

function clang_EnumDecl_getCanonicalDecl(ED)
    @ccall libclangex.clang_EnumDecl_getCanonicalDecl(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_getPreviousDecl(ED)
    @ccall libclangex.clang_EnumDecl_getPreviousDecl(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_getMostRecentDecl(ED)
    @ccall libclangex.clang_EnumDecl_getMostRecentDecl(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_getDefinition(ED)
    @ccall libclangex.clang_EnumDecl_getDefinition(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_completeDefinition(ED, NewType, PromotionType, NumPositiveBits, NumNegativeBits)
    @ccall libclangex.clang_EnumDecl_completeDefinition(ED::CXEnumDecl, NewType::CXQualType, PromotionType::CXQualType, NumPositiveBits::Cuint, NumNegativeBits::Cuint)::Cvoid
end

function clang_EnumDecl_getPromotionType(ED)
    @ccall libclangex.clang_EnumDecl_getPromotionType(ED::CXEnumDecl)::CXQualType
end

function clang_EnumDecl_setPromotionType(ED, T)
    @ccall libclangex.clang_EnumDecl_setPromotionType(ED::CXEnumDecl, T::CXQualType)::Cvoid
end

function clang_EnumDecl_getIntegerType(ED)
    @ccall libclangex.clang_EnumDecl_getIntegerType(ED::CXEnumDecl)::CXQualType
end

function clang_EnumDecl_setIntegerType(ED, T)
    @ccall libclangex.clang_EnumDecl_setIntegerType(ED::CXEnumDecl, T::CXQualType)::Cvoid
end

function clang_EnumDecl_setIntegerTypeSourceInfo(ED, TInfo)
    @ccall libclangex.clang_EnumDecl_setIntegerTypeSourceInfo(ED::CXEnumDecl, TInfo::CXTypeSourceInfo)::Cvoid
end

function clang_EnumDecl_getIntegerTypeSourceInfo(ED)
    @ccall libclangex.clang_EnumDecl_getIntegerTypeSourceInfo(ED::CXEnumDecl)::CXTypeSourceInfo
end

function clang_EnumDecl_getIntegerTypeRange(ED)
    @ccall libclangex.clang_EnumDecl_getIntegerTypeRange(ED::CXEnumDecl)::CXSourceRange_
end

function clang_EnumDecl_getNumPositiveBits(ED)
    @ccall libclangex.clang_EnumDecl_getNumPositiveBits(ED::CXEnumDecl)::Cuint
end

function clang_EnumDecl_getNumNegativeBits(ED)
    @ccall libclangex.clang_EnumDecl_getNumNegativeBits(ED::CXEnumDecl)::Cuint
end

function clang_EnumDecl_isScoped(ED)
    @ccall libclangex.clang_EnumDecl_isScoped(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_isScopedUsingClassTag(ED)
    @ccall libclangex.clang_EnumDecl_isScopedUsingClassTag(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_isFixed(ED)
    @ccall libclangex.clang_EnumDecl_isFixed(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_getODRHash(ED)
    @ccall libclangex.clang_EnumDecl_getODRHash(ED::CXEnumDecl)::Cuint
end

function clang_EnumDecl_isComplete(ED)
    @ccall libclangex.clang_EnumDecl_isComplete(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_isClosed(ED)
    @ccall libclangex.clang_EnumDecl_isClosed(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_isClosedFlag(ED)
    @ccall libclangex.clang_EnumDecl_isClosedFlag(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_isClosedNonFlag(ED)
    @ccall libclangex.clang_EnumDecl_isClosedNonFlag(ED::CXEnumDecl)::Bool
end

function clang_EnumDecl_getTemplateInstantiationPattern(ED)
    @ccall libclangex.clang_EnumDecl_getTemplateInstantiationPattern(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_getInstantiatedFromMemberEnum(ED)
    @ccall libclangex.clang_EnumDecl_getInstantiatedFromMemberEnum(ED::CXEnumDecl)::CXEnumDecl
end

function clang_EnumDecl_getTemplateSpecializationKind(ED)
    @ccall libclangex.clang_EnumDecl_getTemplateSpecializationKind(ED::CXEnumDecl)::CXTemplateSpecializationKind
end

function clang_EnumDecl_setTemplateSpecializationKind(ED, TSK, PointOfInstantiation)
    @ccall libclangex.clang_EnumDecl_setTemplateSpecializationKind(ED::CXEnumDecl, TSK::CXTemplateSpecializationKind, PointOfInstantiation::CXSourceLocation_)::Cvoid
end

function clang_EnumDecl_getMemberSpecializationInfo(ED)
    @ccall libclangex.clang_EnumDecl_getMemberSpecializationInfo(ED::CXEnumDecl)::CXMemberSpecializationInfo
end

function clang_EnumDecl_setInstantiationOfMemberEnum(ED, ED2, TSK)
    @ccall libclangex.clang_EnumDecl_setInstantiationOfMemberEnum(ED::CXEnumDecl, ED2::CXEnumDecl, TSK::CXTemplateSpecializationKind)::Cvoid
end

function clang_EnumDecl_getNumEnumerators(ED)
    @ccall libclangex.clang_EnumDecl_getNumEnumerators(ED::CXEnumDecl)::Cuint
end

function clang_EnumDecl_getEnumerators(ED, Buf)
    @ccall libclangex.clang_EnumDecl_getEnumerators(ED::CXEnumDecl, Buf::Ptr{CXEnumConstantDecl})::Cvoid
end

@enum CXRecordArgPassingKind::UInt32 begin
    CXRecordDecl_APK_CanPassInRegs = 0x0000000000000000
    CXRecordDecl_APK_CannotPassInRegs = 0x0000000000000001
    CXRecordDecl_APK_CanNeverPassInRegs = 0x0000000000000002
end

function clang_RecordDecl_Create(C, TK, DC, StartLoc, IdLoc, Id, PrevDecl)
    @ccall libclangex.clang_RecordDecl_Create(C::CXASTContext, TK::CXTagTypeKind, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, Id::CXIdentifierInfo, PrevDecl::CXRecordDecl)::CXRecordDecl
end

function clang_RecordDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_RecordDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXRecordDecl
end

function clang_RecordDecl_getPreviousDecl(RD)
    @ccall libclangex.clang_RecordDecl_getPreviousDecl(RD::CXRecordDecl)::CXRecordDecl
end

function clang_RecordDecl_getMostRecentDecl(RD)
    @ccall libclangex.clang_RecordDecl_getMostRecentDecl(RD::CXRecordDecl)::CXRecordDecl
end

function clang_RecordDecl_hasFlexibleArrayMember(RD)
    @ccall libclangex.clang_RecordDecl_hasFlexibleArrayMember(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasFlexibleArrayMember(RD, V)
    @ccall libclangex.clang_RecordDecl_setHasFlexibleArrayMember(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_isAnonymousStructOrUnion(RD)
    @ccall libclangex.clang_RecordDecl_isAnonymousStructOrUnion(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setAnonymousStructOrUnion(RD, Anon)
    @ccall libclangex.clang_RecordDecl_setAnonymousStructOrUnion(RD::CXRecordDecl, Anon::Bool)::Cvoid
end

function clang_RecordDecl_hasObjectMember(RD)
    @ccall libclangex.clang_RecordDecl_hasObjectMember(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasObjectMember(RD, val)
    @ccall libclangex.clang_RecordDecl_setHasObjectMember(RD::CXRecordDecl, val::Bool)::Cvoid
end

function clang_RecordDecl_hasVolatileMember(RD)
    @ccall libclangex.clang_RecordDecl_hasVolatileMember(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasVolatileMember(RD, val)
    @ccall libclangex.clang_RecordDecl_setHasVolatileMember(RD::CXRecordDecl, val::Bool)::Cvoid
end

function clang_RecordDecl_hasLoadedFieldsFromExternalStorage(RD)
    @ccall libclangex.clang_RecordDecl_hasLoadedFieldsFromExternalStorage(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(RD, val)
    @ccall libclangex.clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(RD::CXRecordDecl, val::Bool)::Cvoid
end

function clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(RD)
    @ccall libclangex.clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(RD, V)
    @ccall libclangex.clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_isNonTrivialToPrimitiveCopy(RD)
    @ccall libclangex.clang_RecordDecl_isNonTrivialToPrimitiveCopy(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setNonTrivialToPrimitiveCopy(RD, V)
    @ccall libclangex.clang_RecordDecl_setNonTrivialToPrimitiveCopy(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_isNonTrivialToPrimitiveDestroy(RD)
    @ccall libclangex.clang_RecordDecl_isNonTrivialToPrimitiveDestroy(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setNonTrivialToPrimitiveDestroy(RD, V)
    @ccall libclangex.clang_RecordDecl_setNonTrivialToPrimitiveDestroy(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(RD)
    @ccall libclangex.clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(RD, V)
    @ccall libclangex.clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(RD)
    @ccall libclangex.clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(RD, V)
    @ccall libclangex.clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(RD)
    @ccall libclangex.clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(RD, V)
    @ccall libclangex.clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_canPassInRegisters(RD)
    @ccall libclangex.clang_RecordDecl_canPassInRegisters(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_getArgPassingRestrictions(RD)
    @ccall libclangex.clang_RecordDecl_getArgPassingRestrictions(RD::CXRecordDecl)::CXRecordArgPassingKind
end

function clang_RecordDecl_setArgPassingRestrictions(RD, Kind)
    @ccall libclangex.clang_RecordDecl_setArgPassingRestrictions(RD::CXRecordDecl, Kind::CXRecordArgPassingKind)::Cvoid
end

function clang_RecordDecl_isParamDestroyedInCallee(RD)
    @ccall libclangex.clang_RecordDecl_isParamDestroyedInCallee(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setParamDestroyedInCallee(RD, V)
    @ccall libclangex.clang_RecordDecl_setParamDestroyedInCallee(RD::CXRecordDecl, V::Bool)::Cvoid
end

function clang_RecordDecl_isInjectedClassName(RD)
    @ccall libclangex.clang_RecordDecl_isInjectedClassName(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_isLambda(RD)
    @ccall libclangex.clang_RecordDecl_isLambda(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_isCapturedRecord(RD)
    @ccall libclangex.clang_RecordDecl_isCapturedRecord(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_setCapturedRecord(RD)
    @ccall libclangex.clang_RecordDecl_setCapturedRecord(RD::CXRecordDecl)::Cvoid
end

function clang_RecordDecl_getDefinition(RD)
    @ccall libclangex.clang_RecordDecl_getDefinition(RD::CXRecordDecl)::CXRecordDecl
end

function clang_RecordDecl_isOrContainsUnion(RD)
    @ccall libclangex.clang_RecordDecl_isOrContainsUnion(RD::CXRecordDecl)::Bool
end

function clang_RecordDecl_isMsStruct(RD, C)
    @ccall libclangex.clang_RecordDecl_isMsStruct(RD::CXRecordDecl, C::CXASTContext)::Bool
end

function clang_RecordDecl_mayInsertExtraPadding(RD, EmitRemark)
    @ccall libclangex.clang_RecordDecl_mayInsertExtraPadding(RD::CXRecordDecl, EmitRemark::Bool)::Bool
end

function clang_RecordDecl_findFirstNamedDataMember(RD)
    @ccall libclangex.clang_RecordDecl_findFirstNamedDataMember(RD::CXRecordDecl)::CXFieldDecl
end

function clang_RecordDecl_getNumFields(RD)
    @ccall libclangex.clang_RecordDecl_getNumFields(RD::CXRecordDecl)::Cuint
end

function clang_RecordDecl_getFields(RD, Buf)
    @ccall libclangex.clang_RecordDecl_getFields(RD::CXRecordDecl, Buf::Ptr{CXFieldDecl})::Cvoid
end

function clang_RecordDecl_castToClassTemplateSpecializationDecl(RD)
    @ccall libclangex.clang_RecordDecl_castToClassTemplateSpecializationDecl(RD::CXRecordDecl)::CXClassTemplateSpecializationDecl
end

function clang_FileScopeAsmDecl_Create(C, DC, Str, AsmLoc, RParenLoc)
    @ccall libclangex.clang_FileScopeAsmDecl_Create(C::CXASTContext, DC::CXDeclContext, Str::CXStringLiteral, AsmLoc::CXSourceLocation_, RParenLoc::CXSourceLocation_)::CXFileScopeAsmDecl
end

function clang_FileScopeAsmDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_FileScopeAsmDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXFileScopeAsmDecl
end

function clang_FileScopeAsmDecl_getAsmLoc(FSAD)
    @ccall libclangex.clang_FileScopeAsmDecl_getAsmLoc(FSAD::CXFileScopeAsmDecl)::CXSourceLocation_
end

function clang_FileScopeAsmDecl_getRParenLoc(FSAD)
    @ccall libclangex.clang_FileScopeAsmDecl_getRParenLoc(FSAD::CXFileScopeAsmDecl)::CXSourceLocation_
end

function clang_FileScopeAsmDecl_setRParenLoc(FSAD, L)
    @ccall libclangex.clang_FileScopeAsmDecl_setRParenLoc(FSAD::CXFileScopeAsmDecl, L::CXSourceLocation_)::Cvoid
end

function clang_FileScopeAsmDecl_getSourceRange(FSAD)
    @ccall libclangex.clang_FileScopeAsmDecl_getSourceRange(FSAD::CXFileScopeAsmDecl)::CXSourceRange_
end

function clang_FileScopeAsmDecl_getAsmString(FSAD)
    @ccall libclangex.clang_FileScopeAsmDecl_getAsmString(FSAD::CXFileScopeAsmDecl)::CXStringLiteral
end

function clang_FileScopeAsmDecl_setAsmString(FSAD, Asm)
    @ccall libclangex.clang_FileScopeAsmDecl_setAsmString(FSAD::CXFileScopeAsmDecl, Asm::CXStringLiteral)::Cvoid
end

function clang_BlockDecl_Create(C, DC, L)
    @ccall libclangex.clang_BlockDecl_Create(C::CXASTContext, DC::CXDeclContext, L::CXSourceLocation_)::CXBlockDecl
end

function clang_BlockDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_BlockDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXBlockDecl
end

function clang_BlockDecl_getCaretLocation(BD)
    @ccall libclangex.clang_BlockDecl_getCaretLocation(BD::CXBlockDecl)::CXSourceLocation_
end

function clang_BlockDecl_isVariadic(BD)
    @ccall libclangex.clang_BlockDecl_isVariadic(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setBody(BD, B)
    @ccall libclangex.clang_BlockDecl_setBody(BD::CXBlockDecl, B::CXCompoundStmt)::Cvoid
end

function clang_BlockDecl_setSignatureAsWritten(BD, Sig)
    @ccall libclangex.clang_BlockDecl_setSignatureAsWritten(BD::CXBlockDecl, Sig::CXTypeSourceInfo)::Cvoid
end

function clang_BlockDecl_getSignatureAsWritten(BD)
    @ccall libclangex.clang_BlockDecl_getSignatureAsWritten(BD::CXBlockDecl)::CXTypeSourceInfo
end

function clang_BlockDecl_getNumParams(BD)
    @ccall libclangex.clang_BlockDecl_getNumParams(BD::CXBlockDecl)::Cuint
end

function clang_BlockDecl_getParamDecl(BD, i)
    @ccall libclangex.clang_BlockDecl_getParamDecl(BD::CXBlockDecl, i::Cuint)::CXParmVarDecl
end

function clang_BlockDecl_hasCaptures(BD)
    @ccall libclangex.clang_BlockDecl_hasCaptures(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_getNumCaptures(BD)
    @ccall libclangex.clang_BlockDecl_getNumCaptures(BD::CXBlockDecl)::Cuint
end

function clang_BlockDecl_capturesCXXThis(BD)
    @ccall libclangex.clang_BlockDecl_capturesCXXThis(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setCapturesCXXThis(BD, B)
    @ccall libclangex.clang_BlockDecl_setCapturesCXXThis(BD::CXBlockDecl, B::Bool)::Cvoid
end

function clang_BlockDecl_blockMissingReturnType(BD)
    @ccall libclangex.clang_BlockDecl_blockMissingReturnType(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setBlockMissingReturnType(BD, val)
    @ccall libclangex.clang_BlockDecl_setBlockMissingReturnType(BD::CXBlockDecl, val::Bool)::Cvoid
end

function clang_BlockDecl_isConversionFromLambda(BD)
    @ccall libclangex.clang_BlockDecl_isConversionFromLambda(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setIsConversionFromLambda(BD, val)
    @ccall libclangex.clang_BlockDecl_setIsConversionFromLambda(BD::CXBlockDecl, val::Bool)::Cvoid
end

function clang_BlockDecl_doesNotEscape(BD)
    @ccall libclangex.clang_BlockDecl_doesNotEscape(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setDoesNotEscape(BD, B)
    @ccall libclangex.clang_BlockDecl_setDoesNotEscape(BD::CXBlockDecl, B::Bool)::Cvoid
end

function clang_BlockDecl_canAvoidCopyToHeap(BD)
    @ccall libclangex.clang_BlockDecl_canAvoidCopyToHeap(BD::CXBlockDecl)::Bool
end

function clang_BlockDecl_setCanAvoidCopyToHeap(BD, B)
    @ccall libclangex.clang_BlockDecl_setCanAvoidCopyToHeap(BD::CXBlockDecl, B::Bool)::Cvoid
end

function clang_BlockDecl_capturesVariable(BD, var)
    @ccall libclangex.clang_BlockDecl_capturesVariable(BD::CXBlockDecl, var::CXVarDecl)::Bool
end

function clang_BlockDecl_getBlockManglingNumber(BD)
    @ccall libclangex.clang_BlockDecl_getBlockManglingNumber(BD::CXBlockDecl)::Cuint
end

function clang_BlockDecl_getBlockManglingContextDecl(BD)
    @ccall libclangex.clang_BlockDecl_getBlockManglingContextDecl(BD::CXBlockDecl)::CXDecl
end

function clang_BlockDecl_setBlockMangling(BD, Number, Ctx)
    @ccall libclangex.clang_BlockDecl_setBlockMangling(BD::CXBlockDecl, Number::Cuint, Ctx::CXDecl)::Cvoid
end

function clang_BlockDecl_getSourceRange(BD)
    @ccall libclangex.clang_BlockDecl_getSourceRange(BD::CXBlockDecl)::CXSourceRange_
end

function clang_CapturedDecl_Create(C, DC, NumParams)
    @ccall libclangex.clang_CapturedDecl_Create(C::CXASTContext, DC::CXDeclContext, NumParams::Cuint)::CXCapturedDecl
end

function clang_CapturedDecl_CreateDeserialized(C, ID, NumParams)
    @ccall libclangex.clang_CapturedDecl_CreateDeserialized(C::CXASTContext, ID::Cuint, NumParams::Cuint)::CXCapturedDecl
end

function clang_CapturedDecl_getBody(CD)
    @ccall libclangex.clang_CapturedDecl_getBody(CD::CXCapturedDecl)::CXStmt
end

function clang_CapturedDecl_setBody(CD, B)
    @ccall libclangex.clang_CapturedDecl_setBody(CD::CXCapturedDecl, B::CXStmt)::Cvoid
end

function clang_CapturedDecl_isNothrow(CD)
    @ccall libclangex.clang_CapturedDecl_isNothrow(CD::CXCapturedDecl)::Bool
end

function clang_CapturedDecl_setNothrow(CD, Nothrow)
    @ccall libclangex.clang_CapturedDecl_setNothrow(CD::CXCapturedDecl, Nothrow::Bool)::Cvoid
end

function clang_CapturedDecl_getNumParams(CD)
    @ccall libclangex.clang_CapturedDecl_getNumParams(CD::CXCapturedDecl)::Cuint
end

function clang_CapturedDecl_getParam(CD, i)
    @ccall libclangex.clang_CapturedDecl_getParam(CD::CXCapturedDecl, i::Cuint)::CXImplicitParamDecl
end

function clang_CapturedDecl_setParam(CD, i, P)
    @ccall libclangex.clang_CapturedDecl_setParam(CD::CXCapturedDecl, i::Cuint, P::CXImplicitParamDecl)::Cvoid
end

function clang_CapturedDecl_getContextParam(CD)
    @ccall libclangex.clang_CapturedDecl_getContextParam(CD::CXCapturedDecl)::CXImplicitParamDecl
end

function clang_CapturedDecl_setContextParam(CD, i, P)
    @ccall libclangex.clang_CapturedDecl_setContextParam(CD::CXCapturedDecl, i::Cuint, P::CXImplicitParamDecl)::Cvoid
end

function clang_CapturedDecl_getContextParamPosition(CD)
    @ccall libclangex.clang_CapturedDecl_getContextParamPosition(CD::CXCapturedDecl)::Cuint
end

function clang_ImportDecl_CreateImplicit(C, DC, StartLoc, Imported, EndLoc)
    @ccall libclangex.clang_ImportDecl_CreateImplicit(C::CXASTContext, DC::CXDeclContext, StartLoc::CXSourceLocation_, Imported::CXModule, EndLoc::CXSourceLocation_)::CXImportDecl
end

function clang_ImportDecl_CreateDeserialized(C, ID, NumLocations)
    @ccall libclangex.clang_ImportDecl_CreateDeserialized(C::CXASTContext, ID::Cuint, NumLocations::Cuint)::CXImportDecl
end

function clang_ImportDecl_getImportedModule(ID)
    @ccall libclangex.clang_ImportDecl_getImportedModule(ID::CXImportDecl)::CXModule
end

function clang_ImportDecl_getSourceRange(ID)
    @ccall libclangex.clang_ImportDecl_getSourceRange(ID::CXImportDecl)::CXSourceRange_
end

function clang_ExportDecl_Create(C, DC, ExportLoc)
    @ccall libclangex.clang_ExportDecl_Create(C::CXASTContext, DC::CXDeclContext, ExportLoc::CXSourceLocation_)::CXExportDecl
end

function clang_ExportDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_ExportDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXExportDecl
end

function clang_ExportDecl_getExportLoc(ED)
    @ccall libclangex.clang_ExportDecl_getExportLoc(ED::CXExportDecl)::CXSourceLocation_
end

function clang_ExportDecl_getRBraceLoc(ED)
    @ccall libclangex.clang_ExportDecl_getRBraceLoc(ED::CXExportDecl)::CXSourceLocation_
end

function clang_ExportDecl_setRBraceLoc(ED, L)
    @ccall libclangex.clang_ExportDecl_setRBraceLoc(ED::CXExportDecl, L::CXSourceLocation_)::Cvoid
end

function clang_ExportDecl_hasBraces(ED)
    @ccall libclangex.clang_ExportDecl_hasBraces(ED::CXExportDecl)::Bool
end

function clang_ExportDecl_getEndLoc(ED)
    @ccall libclangex.clang_ExportDecl_getEndLoc(ED::CXExportDecl)::CXSourceLocation_
end

function clang_ExportDecl_getSourceRange(ED)
    @ccall libclangex.clang_ExportDecl_getSourceRange(ED::CXExportDecl)::CXSourceRange_
end

function clang_EmptyDecl_Create(C, DC, L)
    @ccall libclangex.clang_EmptyDecl_Create(C::CXASTContext, DC::CXDeclContext, L::CXSourceLocation_)::CXEmptyDecl
end

function clang_EmptyDecl_CreateDeserialized(C, ID)
    @ccall libclangex.clang_EmptyDecl_CreateDeserialized(C::CXASTContext, ID::Cuint)::CXEmptyDecl
end

function clang_TemplateParameterList_getParam(TPL, Idx)
    @ccall libclangex.clang_TemplateParameterList_getParam(TPL::CXTemplateParameterList, Idx::Cuint)::CXNamedDecl
end

function clang_TemplateParameterList_size(TPL)
    @ccall libclangex.clang_TemplateParameterList_size(TPL::CXTemplateParameterList)::Cuint
end

function clang_TemplateArgumentList_CreateCopy(Context, Args, ArgNum)
    @ccall libclangex.clang_TemplateArgumentList_CreateCopy(Context::CXASTContext, Args::CXTemplateArgument, ArgNum::Csize_t)::CXTemplateArgumentList
end

function clang_TemplateArgumentList_size(TAL)
    @ccall libclangex.clang_TemplateArgumentList_size(TAL::CXTemplateArgumentList)::Cuint
end

function clang_TemplateArgumentList_data(TAL)
    @ccall libclangex.clang_TemplateArgumentList_data(TAL::CXTemplateArgumentList)::CXTemplateArgument
end

function clang_TemplateArgumentList_get(TAL, Idx)
    @ccall libclangex.clang_TemplateArgumentList_get(TAL::CXTemplateArgumentList, Idx::Cuint)::CXTemplateArgument
end

function clang_RedeclarableTemplateDecl_getCanonicalDecl(RTD)
    @ccall libclangex.clang_RedeclarableTemplateDecl_getCanonicalDecl(RTD::CXRedeclarableTemplateDecl)::CXRedeclarableTemplateDecl
end

function clang_RedeclarableTemplateDecl_isMemberSpecialization(RTD)
    @ccall libclangex.clang_RedeclarableTemplateDecl_isMemberSpecialization(RTD::CXRedeclarableTemplateDecl)::Bool
end

function clang_RedeclarableTemplateDecl_setMemberSpecialization(RTD)
    @ccall libclangex.clang_RedeclarableTemplateDecl_setMemberSpecialization(RTD::CXRedeclarableTemplateDecl)::Cvoid
end

function clang_ClassTemplateDecl_getTemplatedDecl(CTD)
    @ccall libclangex.clang_ClassTemplateDecl_getTemplatedDecl(CTD::CXClassTemplateDecl)::CXCXXRecordDecl
end

function clang_ClassTemplateDecl_isThisDeclarationADefinition(CTD)
    @ccall libclangex.clang_ClassTemplateDecl_isThisDeclarationADefinition(CTD::CXClassTemplateDecl)::Bool
end

function clang_ClassTemplateDecl_findSpecialization(CTD, TAL, InsertPos)
    @ccall libclangex.clang_ClassTemplateDecl_findSpecialization(CTD::CXClassTemplateDecl, TAL::CXTemplateArgumentList, InsertPos::Ptr{Cvoid})::CXClassTemplateSpecializationDecl
end

function clang_ClassTemplateDecl_AddSpecialization(CTD, CTSD, InsertPos)
    @ccall libclangex.clang_ClassTemplateDecl_AddSpecialization(CTD::CXClassTemplateDecl, CTSD::CXClassTemplateSpecializationDecl, InsertPos::Ptr{Cvoid})::Cvoid
end

function clang_ClassTemplateDecl_getCanonicalDecl(CTD)
    @ccall libclangex.clang_ClassTemplateDecl_getCanonicalDecl(CTD::CXClassTemplateDecl)::CXClassTemplateDecl
end

function clang_ClassTemplateDecl_getPreviousDecl(CTD)
    @ccall libclangex.clang_ClassTemplateDecl_getPreviousDecl(CTD::CXClassTemplateDecl)::CXClassTemplateDecl
end

function clang_ClassTemplateDecl_getMostRecentDecl(CTD)
    @ccall libclangex.clang_ClassTemplateDecl_getMostRecentDecl(CTD::CXClassTemplateDecl)::CXClassTemplateDecl
end

function clang_ClassTemplateSpecializationDecl_Create(Context, TK, DC, StartLoc, IdLoc, SpecializedTemplate, Args, PrevDecl)
    @ccall libclangex.clang_ClassTemplateSpecializationDecl_Create(Context::CXASTContext, TK::CXTagTypeKind, DC::CXDeclContext, StartLoc::CXSourceLocation_, IdLoc::CXSourceLocation_, SpecializedTemplate::CXClassTemplateDecl, Args::CXTemplateArgumentList, PrevDecl::CXClassTemplateSpecializationDecl)::CXClassTemplateSpecializationDecl
end

function clang_ClassTemplateSpecializationDecl_getTemplateArgs(CTSD)
    @ccall libclangex.clang_ClassTemplateSpecializationDecl_getTemplateArgs(CTSD::CXClassTemplateSpecializationDecl)::CXTemplateArgumentList
end

function clang_ClassTemplateSpecializationDecl_setTemplateArgs(CTSD, TAL)
    @ccall libclangex.clang_ClassTemplateSpecializationDecl_setTemplateArgs(CTSD::CXClassTemplateSpecializationDecl, TAL::CXTemplateArgumentList)::Cvoid
end

function clang_TemplateDecl_getTemplatedDecl(TD)
    @ccall libclangex.clang_TemplateDecl_getTemplatedDecl(TD::CXTemplateDecl)::CXNamedDecl
end

function clang_TemplateDecl_getTemplateParameters(TD)
    @ccall libclangex.clang_TemplateDecl_getTemplateParameters(TD::CXTemplateDecl)::CXTemplateParameterList
end

function clang_TemplateParameterList_getDepth(L)
    @ccall libclangex.clang_TemplateParameterList_getDepth(L::CXTemplateParameterList)::Cuint
end

function clang_TemplateParameterList_getMinRequiredArguments(L)
    @ccall libclangex.clang_TemplateParameterList_getMinRequiredArguments(L::CXTemplateParameterList)::Cuint
end

function clang_TemplateParameterList_hasParameterPack(L)
    @ccall libclangex.clang_TemplateParameterList_hasParameterPack(L::CXTemplateParameterList)::Bool
end

function clang_TemplateTypeParmDecl_getDepth(D)
    @ccall libclangex.clang_TemplateTypeParmDecl_getDepth(D::CXTemplateTypeParmDecl)::Cuint
end

function clang_TemplateTypeParmDecl_getIndex(D)
    @ccall libclangex.clang_TemplateTypeParmDecl_getIndex(D::CXTemplateTypeParmDecl)::Cuint
end

function clang_TemplateTypeParmDecl_isParameterPack(D)
    @ccall libclangex.clang_TemplateTypeParmDecl_isParameterPack(D::CXTemplateTypeParmDecl)::Bool
end

function clang_NonTypeTemplateParmDecl_getDepth(D)
    @ccall libclangex.clang_NonTypeTemplateParmDecl_getDepth(D::CXNonTypeTemplateParmDecl)::Cuint
end

function clang_NonTypeTemplateParmDecl_getIndex(D)
    @ccall libclangex.clang_NonTypeTemplateParmDecl_getIndex(D::CXNonTypeTemplateParmDecl)::Cuint
end

function clang_NonTypeTemplateParmDecl_isParameterPack(D)
    @ccall libclangex.clang_NonTypeTemplateParmDecl_isParameterPack(D::CXNonTypeTemplateParmDecl)::Bool
end

function clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(D)
    @ccall libclangex.clang_ClassTemplateSpecializationDecl_getSpecializedTemplate(D::CXClassTemplateSpecializationDecl)::CXClassTemplateDecl
end

function clang_ClassTemplateSpecializationDecl_getSpecializationKind(D)
    @ccall libclangex.clang_ClassTemplateSpecializationDecl_getSpecializationKind(D::CXClassTemplateSpecializationDecl)::CXTemplateSpecializationKind
end

function clang_DeclarationName_create()
    @ccall libclangex.clang_DeclarationName_create()::CXDeclarationName
end

function clang_DeclarationName_createFromIdentifierInfo(IDInfo)
    @ccall libclangex.clang_DeclarationName_createFromIdentifierInfo(IDInfo::CXIdentifierInfo)::CXDeclarationName
end

function clang_DeclarationName_dump(DN)
    @ccall libclangex.clang_DeclarationName_dump(DN::CXDeclarationName)::Cvoid
end

function clang_DeclarationName_isEmpty(DN)
    @ccall libclangex.clang_DeclarationName_isEmpty(DN::CXDeclarationName)::Bool
end

function clang_DeclarationName_getAsString(DN)
    @ccall libclangex.clang_DeclarationName_getAsString(DN::CXDeclarationName)::CXString
end

@enum CXCastKind::UInt32 begin
    CXCastKind_CK_Dependent = 0
    CXCastKind_CK_BitCast = 1
    CXCastKind_CK_LValueBitCast = 2
    CXCastKind_CK_LValueToRValueBitCast = 3
    CXCastKind_CK_LValueToRValue = 4
    CXCastKind_CK_NoOp = 5
    CXCastKind_CK_BaseToDerived = 6
    CXCastKind_CK_DerivedToBase = 7
    CXCastKind_CK_UncheckedDerivedToBase = 8
    CXCastKind_CK_Dynamic = 9
    CXCastKind_CK_ToUnion = 10
    CXCastKind_CK_ArrayToPointerDecay = 11
    CXCastKind_CK_FunctionToPointerDecay = 12
    CXCastKind_CK_NullToPointer = 13
    CXCastKind_CK_NullToMemberPointer = 14
    CXCastKind_CK_BaseToDerivedMemberPointer = 15
    CXCastKind_CK_DerivedToBaseMemberPointer = 16
    CXCastKind_CK_MemberPointerToBoolean = 17
    CXCastKind_CK_ReinterpretMemberPointer = 18
    CXCastKind_CK_UserDefinedConversion = 19
    CXCastKind_CK_ConstructorConversion = 20
    CXCastKind_CK_IntegralToPointer = 21
    CXCastKind_CK_PointerToIntegral = 22
    CXCastKind_CK_PointerToBoolean = 23
    CXCastKind_CK_ToVoid = 24
    CXCastKind_CK_MatrixCast = 25
    CXCastKind_CK_VectorSplat = 26
    CXCastKind_CK_IntegralCast = 27
    CXCastKind_CK_IntegralToBoolean = 28
    CXCastKind_CK_IntegralToFloating = 29
    CXCastKind_CK_FloatingToFixedPoint = 30
    CXCastKind_CK_FixedPointToFloating = 31
    CXCastKind_CK_FixedPointCast = 32
    CXCastKind_CK_FixedPointToIntegral = 33
    CXCastKind_CK_IntegralToFixedPoint = 34
    CXCastKind_CK_FixedPointToBoolean = 35
    CXCastKind_CK_FloatingToIntegral = 36
    CXCastKind_CK_FloatingToBoolean = 37
    CXCastKind_CK_BooleanToSignedIntegral = 38
    CXCastKind_CK_FloatingCast = 39
    CXCastKind_CK_CPointerToObjCPointerCast = 40
    CXCastKind_CK_BlockPointerToObjCPointerCast = 41
    CXCastKind_CK_AnyPointerToBlockPointerCast = 42
    CXCastKind_CK_ObjCObjectLValueCast = 43
    CXCastKind_CK_FloatingRealToComplex = 44
    CXCastKind_CK_FloatingComplexToReal = 45
    CXCastKind_CK_FloatingComplexToBoolean = 46
    CXCastKind_CK_FloatingComplexCast = 47
    CXCastKind_CK_FloatingComplexToIntegralComplex = 48
    CXCastKind_CK_IntegralRealToComplex = 49
    CXCastKind_CK_IntegralComplexToReal = 50
    CXCastKind_CK_IntegralComplexToBoolean = 51
    CXCastKind_CK_IntegralComplexCast = 52
    CXCastKind_CK_IntegralComplexToFloatingComplex = 53
    CXCastKind_CK_ARCProduceObject = 54
    CXCastKind_CK_ARCConsumeObject = 55
    CXCastKind_CK_ARCReclaimReturnedObject = 56
    CXCastKind_CK_ARCExtendBlockObject = 57
    CXCastKind_CK_AtomicToNonAtomic = 58
    CXCastKind_CK_NonAtomicToAtomic = 59
    CXCastKind_CK_CopyAndAutoreleaseBlockObject = 60
    CXCastKind_CK_BuiltinFnToFnPtr = 61
    CXCastKind_CK_ZeroToOCLOpaqueType = 62
    CXCastKind_CK_AddressSpaceConversion = 63
    CXCastKind_CK_IntToOCLSampler = 64
end

@enum CXBinaryOperatorKind::UInt32 begin
    CXBinaryOperatorKind_BO_PtrMemD = 0
    CXBinaryOperatorKind_BO_PtrMemI = 1
    CXBinaryOperatorKind_BO_Mul = 2
    CXBinaryOperatorKind_BO_Div = 3
    CXBinaryOperatorKind_BO_Rem = 4
    CXBinaryOperatorKind_BO_Add = 5
    CXBinaryOperatorKind_BO_Sub = 6
    CXBinaryOperatorKind_BO_Shl = 7
    CXBinaryOperatorKind_BO_Shr = 8
    CXBinaryOperatorKind_BO_Cmp = 9
    CXBinaryOperatorKind_BO_LT = 10
    CXBinaryOperatorKind_BO_GT = 11
    CXBinaryOperatorKind_BO_LE = 12
    CXBinaryOperatorKind_BO_GE = 13
    CXBinaryOperatorKind_BO_EQ = 14
    CXBinaryOperatorKind_BO_NE = 15
    CXBinaryOperatorKind_BO_And = 16
    CXBinaryOperatorKind_BO_Xor = 17
    CXBinaryOperatorKind_BO_Or = 18
    CXBinaryOperatorKind_BO_LAnd = 19
    CXBinaryOperatorKind_BO_LOr = 20
    CXBinaryOperatorKind_BO_Assign = 21
    CXBinaryOperatorKind_BO_MulAssign = 22
    CXBinaryOperatorKind_BO_DivAssign = 23
    CXBinaryOperatorKind_BO_RemAssign = 24
    CXBinaryOperatorKind_BO_AddAssign = 25
    CXBinaryOperatorKind_BO_SubAssign = 26
    CXBinaryOperatorKind_BO_ShlAssign = 27
    CXBinaryOperatorKind_BO_ShrAssign = 28
    CXBinaryOperatorKind_BO_AndAssign = 29
    CXBinaryOperatorKind_BO_XorAssign = 30
    CXBinaryOperatorKind_BO_OrAssign = 31
    CXBinaryOperatorKind_BO_Comma = 32
end

@enum CXUnaryOperatorKind::UInt32 begin
    CXUnaryOperatorKind_UO_PostInc = 0
    CXUnaryOperatorKind_UO_PostDec = 1
    CXUnaryOperatorKind_UO_PreInc = 2
    CXUnaryOperatorKind_UO_PreDec = 3
    CXUnaryOperatorKind_UO_AddrOf = 4
    CXUnaryOperatorKind_UO_Deref = 5
    CXUnaryOperatorKind_UO_Plus = 6
    CXUnaryOperatorKind_UO_Minus = 7
    CXUnaryOperatorKind_UO_Not = 8
    CXUnaryOperatorKind_UO_LNot = 9
    CXUnaryOperatorKind_UO_Real = 10
    CXUnaryOperatorKind_UO_Imag = 11
    CXUnaryOperatorKind_UO_Extension = 12
    CXUnaryOperatorKind_UO_Coawait = 13
end

function clang_Expr_getType(E)
    @ccall libclangex.clang_Expr_getType(E::CXExpr)::CXQualType
end

function clang_Expr_getValueKind(E)
    @ccall libclangex.clang_Expr_getValueKind(E::CXExpr)::CXExprValueKind
end

function clang_Expr_isLValue(E)
    @ccall libclangex.clang_Expr_isLValue(E::CXExpr)::Bool
end

function clang_Expr_isPRValue(E)
    @ccall libclangex.clang_Expr_isPRValue(E::CXExpr)::Bool
end

function clang_Expr_isXValue(E)
    @ccall libclangex.clang_Expr_isXValue(E::CXExpr)::Bool
end

function clang_Expr_isGLValue(E)
    @ccall libclangex.clang_Expr_isGLValue(E::CXExpr)::Bool
end

function clang_Expr_IgnoreImpCasts(E)
    @ccall libclangex.clang_Expr_IgnoreImpCasts(E::CXExpr)::CXExpr
end

function clang_Expr_IgnoreCasts(E)
    @ccall libclangex.clang_Expr_IgnoreCasts(E::CXExpr)::CXExpr
end

function clang_Expr_IgnoreParens(E)
    @ccall libclangex.clang_Expr_IgnoreParens(E::CXExpr)::CXExpr
end

function clang_Expr_IgnoreParenCasts(E)
    @ccall libclangex.clang_Expr_IgnoreParenCasts(E::CXExpr)::CXExpr
end

function clang_Expr_IgnoreParenImpCasts(E)
    @ccall libclangex.clang_Expr_IgnoreParenImpCasts(E::CXExpr)::CXExpr
end

function clang_Expr_containsErrors(E)
    @ccall libclangex.clang_Expr_containsErrors(E::CXExpr)::Bool
end

function clang_Expr_containsUnexpandedParameterPack(E)
    @ccall libclangex.clang_Expr_containsUnexpandedParameterPack(E::CXExpr)::Bool
end

function clang_Expr_hasPlaceholderType(E)
    @ccall libclangex.clang_Expr_hasPlaceholderType(E::CXExpr)::Bool
end

function clang_Expr_isDefaultArgument(E)
    @ccall libclangex.clang_Expr_isDefaultArgument(E::CXExpr)::Bool
end

function clang_Expr_isImplicitCXXThis(E)
    @ccall libclangex.clang_Expr_isImplicitCXXThis(E::CXExpr)::Bool
end

function clang_Expr_isInstantiationDependent(E)
    @ccall libclangex.clang_Expr_isInstantiationDependent(E::CXExpr)::Bool
end

function clang_Expr_isObjCSelfExpr(E)
    @ccall libclangex.clang_Expr_isObjCSelfExpr(E::CXExpr)::Bool
end

function clang_Expr_isOrdinaryOrBitFieldObject(E)
    @ccall libclangex.clang_Expr_isOrdinaryOrBitFieldObject(E::CXExpr)::Bool
end

function clang_Expr_isTypeDependent(E)
    @ccall libclangex.clang_Expr_isTypeDependent(E::CXExpr)::Bool
end

function clang_Expr_isValueDependent(E)
    @ccall libclangex.clang_Expr_isValueDependent(E::CXExpr)::Bool
end

function clang_Expr_refersToBitField(E)
    @ccall libclangex.clang_Expr_refersToBitField(E::CXExpr)::Bool
end

function clang_Expr_refersToGlobalRegisterVar(E)
    @ccall libclangex.clang_Expr_refersToGlobalRegisterVar(E::CXExpr)::Bool
end

function clang_Expr_refersToMatrixElement(E)
    @ccall libclangex.clang_Expr_refersToMatrixElement(E::CXExpr)::Bool
end

function clang_Expr_refersToVectorElement(E)
    @ccall libclangex.clang_Expr_refersToVectorElement(E::CXExpr)::Bool
end

function clang_Expr_getExprLoc(E)
    @ccall libclangex.clang_Expr_getExprLoc(E::CXExpr)::CXSourceLocation_
end

function clang_DeclRefExpr_getDecl(DRE)
    @ccall libclangex.clang_DeclRefExpr_getDecl(DRE::CXDeclRefExpr)::CXValueDecl
end

function clang_DeclRefExpr_getFoundDecl(DRE)
    @ccall libclangex.clang_DeclRefExpr_getFoundDecl(DRE::CXDeclRefExpr)::CXNamedDecl
end

function clang_DeclRefExpr_hasQualifier(DRE)
    @ccall libclangex.clang_DeclRefExpr_hasQualifier(DRE::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_getLocation(DRE)
    @ccall libclangex.clang_DeclRefExpr_getLocation(DRE::CXDeclRefExpr)::CXSourceLocation_
end

function clang_IntegerLiteral_Create(C, Val, T, L)
    @ccall libclangex.clang_IntegerLiteral_Create(C::CXASTContext, Val::LLVMGenericValueRef, T::CXQualType, L::CXSourceLocation_)::CXIntegerLiteral
end

function clang_IntegerLiteral_getBeginLoc(IL)
    @ccall libclangex.clang_IntegerLiteral_getBeginLoc(IL::CXIntegerLiteral)::CXSourceLocation_
end

function clang_IntegerLiteral_getEndLoc(IL)
    @ccall libclangex.clang_IntegerLiteral_getEndLoc(IL::CXIntegerLiteral)::CXSourceLocation_
end

function clang_IntegerLiteral_getLocation(IL)
    @ccall libclangex.clang_IntegerLiteral_getLocation(IL::CXIntegerLiteral)::CXSourceLocation_
end

function clang_IntegerLiteral_setLocation(IL, L)
    @ccall libclangex.clang_IntegerLiteral_setLocation(IL::CXIntegerLiteral, L::CXSourceLocation_)::Cvoid
end

function clang_IntegerLiteral_getValue(IL)
    @ccall libclangex.clang_IntegerLiteral_getValue(IL::CXIntegerLiteral)::LLVMGenericValueRef
end

@enum CXCharacterLiteralKind::UInt32 begin
    CXCharacterLiteralKind_Ascii = 0
    CXCharacterLiteralKind_Wide = 1
    CXCharacterLiteralKind_UTF8 = 2
    CXCharacterLiteralKind_UTF16 = 3
    CXCharacterLiteralKind_UTF32 = 4
end

function clang_CharacterLiteral_getValue(CL)
    @ccall libclangex.clang_CharacterLiteral_getValue(CL::CXCharacterLiteral)::Cuint
end

function clang_CharacterLiteral_getKind(CL)
    @ccall libclangex.clang_CharacterLiteral_getKind(CL::CXCharacterLiteral)::CXCharacterLiteralKind
end

function clang_FloatingLiteral_getValueAsApproximateDouble(FL)
    @ccall libclangex.clang_FloatingLiteral_getValueAsApproximateDouble(FL::CXFloatingLiteral)::Cdouble
end

function clang_StringLiteral_getBytes(SL)
    @ccall libclangex.clang_StringLiteral_getBytes(SL::CXStringLiteral)::CXString
end

function clang_StringLiteral_getByteLength(SL)
    @ccall libclangex.clang_StringLiteral_getByteLength(SL::CXStringLiteral)::Cuint
end

function clang_StringLiteral_getLength(SL)
    @ccall libclangex.clang_StringLiteral_getLength(SL::CXStringLiteral)::Cuint
end

function clang_StringLiteral_getCharByteWidth(SL)
    @ccall libclangex.clang_StringLiteral_getCharByteWidth(SL::CXStringLiteral)::Cuint
end

function clang_ParenExpr_getSubExpr(PE)
    @ccall libclangex.clang_ParenExpr_getSubExpr(PE::CXParenExpr)::CXExpr
end

function clang_UnaryOperator_getOpcode(UO)
    @ccall libclangex.clang_UnaryOperator_getOpcode(UO::CXUnaryOperator)::CXUnaryOperatorKind
end

function clang_UnaryOperator_getSubExpr(UO)
    @ccall libclangex.clang_UnaryOperator_getSubExpr(UO::CXUnaryOperator)::CXExpr
end

function clang_UnaryOperator_getOperatorLoc(UO)
    @ccall libclangex.clang_UnaryOperator_getOperatorLoc(UO::CXUnaryOperator)::CXSourceLocation_
end

function clang_UnaryOperator_isPrefix(UO)
    @ccall libclangex.clang_UnaryOperator_isPrefix(UO::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_isPostfix(UO)
    @ccall libclangex.clang_UnaryOperator_isPostfix(UO::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_isIncrementOp(UO)
    @ccall libclangex.clang_UnaryOperator_isIncrementOp(UO::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_isDecrementOp(UO)
    @ccall libclangex.clang_UnaryOperator_isDecrementOp(UO::CXUnaryOperator)::Bool
end

function clang_ArraySubscriptExpr_getLHS(ASE)
    @ccall libclangex.clang_ArraySubscriptExpr_getLHS(ASE::CXArraySubscriptExpr)::CXExpr
end

function clang_ArraySubscriptExpr_getRHS(ASE)
    @ccall libclangex.clang_ArraySubscriptExpr_getRHS(ASE::CXArraySubscriptExpr)::CXExpr
end

function clang_ArraySubscriptExpr_getBase(ASE)
    @ccall libclangex.clang_ArraySubscriptExpr_getBase(ASE::CXArraySubscriptExpr)::CXExpr
end

function clang_ArraySubscriptExpr_getIdx(ASE)
    @ccall libclangex.clang_ArraySubscriptExpr_getIdx(ASE::CXArraySubscriptExpr)::CXExpr
end

function clang_CallExpr_getCallee(CE)
    @ccall libclangex.clang_CallExpr_getCallee(CE::CXCallExpr)::CXExpr
end

function clang_CallExpr_getCalleeDecl(CE)
    @ccall libclangex.clang_CallExpr_getCalleeDecl(CE::CXCallExpr)::CXDecl
end

function clang_CallExpr_getDirectCallee(CE)
    @ccall libclangex.clang_CallExpr_getDirectCallee(CE::CXCallExpr)::CXFunctionDecl
end

function clang_CallExpr_getNumArgs(CE)
    @ccall libclangex.clang_CallExpr_getNumArgs(CE::CXCallExpr)::Cuint
end

function clang_CallExpr_getArg(CE, Arg)
    @ccall libclangex.clang_CallExpr_getArg(CE::CXCallExpr, Arg::Cuint)::CXExpr
end

function clang_CallExpr_getRParenLoc(CE)
    @ccall libclangex.clang_CallExpr_getRParenLoc(CE::CXCallExpr)::CXSourceLocation_
end

function clang_MemberExpr_getBase(ME)
    @ccall libclangex.clang_MemberExpr_getBase(ME::CXMemberExpr)::CXExpr
end

function clang_MemberExpr_getMemberDecl(ME)
    @ccall libclangex.clang_MemberExpr_getMemberDecl(ME::CXMemberExpr)::CXValueDecl
end

function clang_MemberExpr_isArrow(ME)
    @ccall libclangex.clang_MemberExpr_isArrow(ME::CXMemberExpr)::Bool
end

function clang_MemberExpr_getMemberLoc(ME)
    @ccall libclangex.clang_MemberExpr_getMemberLoc(ME::CXMemberExpr)::CXSourceLocation_
end

function clang_MemberExpr_isImplicitAccess(ME)
    @ccall libclangex.clang_MemberExpr_isImplicitAccess(ME::CXMemberExpr)::Bool
end

function clang_CastExpr_getCastKind(CE)
    @ccall libclangex.clang_CastExpr_getCastKind(CE::CXCastExpr)::CXCastKind
end

function clang_CastExpr_getCastKindName(CE)
    @ccall libclangex.clang_CastExpr_getCastKindName(CE::CXCastExpr)::Ptr{Cchar}
end

function clang_CastExpr_getSubExpr(CE)
    @ccall libclangex.clang_CastExpr_getSubExpr(CE::CXCastExpr)::CXExpr
end

function clang_CastExpr_getSubExprAsWritten(CE)
    @ccall libclangex.clang_CastExpr_getSubExprAsWritten(CE::CXCastExpr)::CXExpr
end

function clang_ImplicitCastExpr_isPartOfExplicitCast(ICE)
    @ccall libclangex.clang_ImplicitCastExpr_isPartOfExplicitCast(ICE::CXImplicitCastExpr)::Bool
end

function clang_ExplicitCastExpr_getTypeAsWritten(ECE)
    @ccall libclangex.clang_ExplicitCastExpr_getTypeAsWritten(ECE::CXExplicitCastExpr)::CXQualType
end

function clang_CStyleCastExpr_CreateWithNoTypeInfo(C, T, VK, K, Op)
    @ccall libclangex.clang_CStyleCastExpr_CreateWithNoTypeInfo(C::CXASTContext, T::CXQualType, VK::CXExprValueKind, K::CXCastKind, Op::CXExpr)::CXCStyleCastExpr
end

function clang_CStyleCastExpr_CreateEmpty(C, PathSize, HasFPFeatures)
    @ccall libclangex.clang_CStyleCastExpr_CreateEmpty(C::CXASTContext, PathSize::Cuint, HasFPFeatures::Bool)::CXCStyleCastExpr
end

function clang_CStyleCastExpr_getLParenLoc(CSCE)
    @ccall libclangex.clang_CStyleCastExpr_getLParenLoc(CSCE::CXCStyleCastExpr)::CXSourceLocation_
end

function clang_CStyleCastExpr_setLParenLoc(CSCE, L)
    @ccall libclangex.clang_CStyleCastExpr_setLParenLoc(CSCE::CXCStyleCastExpr, L::CXSourceLocation_)::Cvoid
end

function clang_CStyleCastExpr_getRParenLoc(CSCE)
    @ccall libclangex.clang_CStyleCastExpr_getRParenLoc(CSCE::CXCStyleCastExpr)::CXSourceLocation_
end

function clang_CStyleCastExpr_setRParenLoc(CSCE, L)
    @ccall libclangex.clang_CStyleCastExpr_setRParenLoc(CSCE::CXCStyleCastExpr, L::CXSourceLocation_)::Cvoid
end

function clang_CStyleCastExpr_getBeginLoc(CSCE)
    @ccall libclangex.clang_CStyleCastExpr_getBeginLoc(CSCE::CXCStyleCastExpr)::CXSourceLocation_
end

function clang_CStyleCastExpr_getEndLoc(CSCE)
    @ccall libclangex.clang_CStyleCastExpr_getEndLoc(CSCE::CXCStyleCastExpr)::CXSourceLocation_
end

function clang_BinaryOperator_getOpcode(BO)
    @ccall libclangex.clang_BinaryOperator_getOpcode(BO::CXBinaryOperator)::CXBinaryOperatorKind
end

function clang_BinaryOperator_getLHS(BO)
    @ccall libclangex.clang_BinaryOperator_getLHS(BO::CXBinaryOperator)::CXExpr
end

function clang_BinaryOperator_getRHS(BO)
    @ccall libclangex.clang_BinaryOperator_getRHS(BO::CXBinaryOperator)::CXExpr
end

function clang_BinaryOperator_getOperatorLoc(BO)
    @ccall libclangex.clang_BinaryOperator_getOperatorLoc(BO::CXBinaryOperator)::CXSourceLocation_
end

function clang_BinaryOperator_getOpcodeStr(BO)
    @ccall libclangex.clang_BinaryOperator_getOpcodeStr(BO::CXBinaryOperator)::Ptr{Cchar}
end

function clang_BinaryOperator_isAssignmentOp(BO)
    @ccall libclangex.clang_BinaryOperator_isAssignmentOp(BO::CXBinaryOperator)::Bool
end

function clang_BinaryOperator_isCompoundAssignmentOp(BO)
    @ccall libclangex.clang_BinaryOperator_isCompoundAssignmentOp(BO::CXBinaryOperator)::Bool
end

function clang_BinaryOperator_isComparisonOp(BO)
    @ccall libclangex.clang_BinaryOperator_isComparisonOp(BO::CXBinaryOperator)::Bool
end

function clang_CompoundAssignOperator_getComputationLHSType(CAO)
    @ccall libclangex.clang_CompoundAssignOperator_getComputationLHSType(CAO::CXCompoundAssignOperator)::CXQualType
end

function clang_CompoundAssignOperator_getComputationResultType(CAO)
    @ccall libclangex.clang_CompoundAssignOperator_getComputationResultType(CAO::CXCompoundAssignOperator)::CXQualType
end

function clang_AbstractConditionalOperator_getCond(ACO)
    @ccall libclangex.clang_AbstractConditionalOperator_getCond(ACO::CXAbstractConditionalOperator)::CXExpr
end

function clang_AbstractConditionalOperator_getTrueExpr(ACO)
    @ccall libclangex.clang_AbstractConditionalOperator_getTrueExpr(ACO::CXAbstractConditionalOperator)::CXExpr
end

function clang_AbstractConditionalOperator_getFalseExpr(ACO)
    @ccall libclangex.clang_AbstractConditionalOperator_getFalseExpr(ACO::CXAbstractConditionalOperator)::CXExpr
end

function clang_InitListExpr_getNumInits(ILE)
    @ccall libclangex.clang_InitListExpr_getNumInits(ILE::CXInitListExpr)::Cuint
end

function clang_InitListExpr_getInit(ILE, Init)
    @ccall libclangex.clang_InitListExpr_getInit(ILE::CXInitListExpr, Init::Cuint)::CXExpr
end

function clang_InitListExpr_isSemanticForm(ILE)
    @ccall libclangex.clang_InitListExpr_isSemanticForm(ILE::CXInitListExpr)::Bool
end

function clang_InitListExpr_getSyntacticForm(ILE)
    @ccall libclangex.clang_InitListExpr_getSyntacticForm(ILE::CXInitListExpr)::CXInitListExpr
end

function clang_UnaryExprOrTypeTraitExpr_isArgumentType(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_isArgumentType(E::CXUnaryExprOrTypeTraitExpr)::Bool
end

function clang_UnaryExprOrTypeTraitExpr_getArgumentType(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getArgumentType(E::CXUnaryExprOrTypeTraitExpr)::CXQualType
end

function clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(E::CXUnaryExprOrTypeTraitExpr)::CXQualType
end

function clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(E::CXUnaryExprOrTypeTraitExpr)::CXSourceLocation_
end

function clang_UnaryExprOrTypeTraitExpr_getRParenLoc(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getRParenLoc(E::CXUnaryExprOrTypeTraitExpr)::CXSourceLocation_
end

function clang_StringLiteral_isOrdinary(E)
    @ccall libclangex.clang_StringLiteral_isOrdinary(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isWide(E)
    @ccall libclangex.clang_StringLiteral_isWide(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isUTF8(E)
    @ccall libclangex.clang_StringLiteral_isUTF8(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isUTF16(E)
    @ccall libclangex.clang_StringLiteral_isUTF16(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isUTF32(E)
    @ccall libclangex.clang_StringLiteral_isUTF32(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isUnevaluated(E)
    @ccall libclangex.clang_StringLiteral_isUnevaluated(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_isPascal(E)
    @ccall libclangex.clang_StringLiteral_isPascal(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_containsNonAscii(E)
    @ccall libclangex.clang_StringLiteral_containsNonAscii(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_containsNonAsciiOrNull(E)
    @ccall libclangex.clang_StringLiteral_containsNonAsciiOrNull(E::CXStringLiteral)::Bool
end

function clang_StringLiteral_getNumConcatenated(E)
    @ccall libclangex.clang_StringLiteral_getNumConcatenated(E::CXStringLiteral)::Cuint
end

function clang_CharacterLiteral_getLocation(E)
    @ccall libclangex.clang_CharacterLiteral_getLocation(E::CXCharacterLiteral)::CXSourceLocation_
end

function clang_UnaryOperator_canOverflow(E)
    @ccall libclangex.clang_UnaryOperator_canOverflow(E::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_isIncrementDecrementOp(E)
    @ccall libclangex.clang_UnaryOperator_isIncrementDecrementOp(E::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_isArithmeticOp(E)
    @ccall libclangex.clang_UnaryOperator_isArithmeticOp(E::CXUnaryOperator)::Bool
end

function clang_UnaryOperator_hasStoredFPFeatures(E)
    @ccall libclangex.clang_UnaryOperator_hasStoredFPFeatures(E::CXUnaryOperator)::Bool
end

function clang_CallExpr_usesADL(E)
    @ccall libclangex.clang_CallExpr_usesADL(E::CXCallExpr)::Bool
end

function clang_CallExpr_hasStoredFPFeatures(E)
    @ccall libclangex.clang_CallExpr_hasStoredFPFeatures(E::CXCallExpr)::Bool
end

function clang_CallExpr_getBuiltinCallee(E)
    @ccall libclangex.clang_CallExpr_getBuiltinCallee(E::CXCallExpr)::Cuint
end

function clang_CallExpr_isCallToStdMove(E)
    @ccall libclangex.clang_CallExpr_isCallToStdMove(E::CXCallExpr)::Bool
end

function clang_MemberExpr_hasQualifier(E)
    @ccall libclangex.clang_MemberExpr_hasQualifier(E::CXMemberExpr)::Bool
end

function clang_MemberExpr_getTemplateKeywordLoc(E)
    @ccall libclangex.clang_MemberExpr_getTemplateKeywordLoc(E::CXMemberExpr)::CXSourceLocation_
end

function clang_MemberExpr_getLAngleLoc(E)
    @ccall libclangex.clang_MemberExpr_getLAngleLoc(E::CXMemberExpr)::CXSourceLocation_
end

function clang_MemberExpr_getRAngleLoc(E)
    @ccall libclangex.clang_MemberExpr_getRAngleLoc(E::CXMemberExpr)::CXSourceLocation_
end

function clang_MemberExpr_hasTemplateKeyword(E)
    @ccall libclangex.clang_MemberExpr_hasTemplateKeyword(E::CXMemberExpr)::Bool
end

function clang_MemberExpr_hasExplicitTemplateArgs(E)
    @ccall libclangex.clang_MemberExpr_hasExplicitTemplateArgs(E::CXMemberExpr)::Bool
end

function clang_MemberExpr_getNumTemplateArgs(E)
    @ccall libclangex.clang_MemberExpr_getNumTemplateArgs(E::CXMemberExpr)::Cuint
end

function clang_MemberExpr_getOperatorLoc(E)
    @ccall libclangex.clang_MemberExpr_getOperatorLoc(E::CXMemberExpr)::CXSourceLocation_
end

function clang_MemberExpr_hadMultipleCandidates(E)
    @ccall libclangex.clang_MemberExpr_hadMultipleCandidates(E::CXMemberExpr)::Bool
end

function clang_InitListExpr_hasArrayFiller(E)
    @ccall libclangex.clang_InitListExpr_hasArrayFiller(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_hasDesignatedInit(E)
    @ccall libclangex.clang_InitListExpr_hasDesignatedInit(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_isExplicit(E)
    @ccall libclangex.clang_InitListExpr_isExplicit(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_isStringLiteralInit(E)
    @ccall libclangex.clang_InitListExpr_isStringLiteralInit(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_isTransparent(E)
    @ccall libclangex.clang_InitListExpr_isTransparent(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_getLBraceLoc(E)
    @ccall libclangex.clang_InitListExpr_getLBraceLoc(E::CXInitListExpr)::CXSourceLocation_
end

function clang_InitListExpr_getRBraceLoc(E)
    @ccall libclangex.clang_InitListExpr_getRBraceLoc(E::CXInitListExpr)::CXSourceLocation_
end

function clang_InitListExpr_isSyntacticForm(E)
    @ccall libclangex.clang_InitListExpr_isSyntacticForm(E::CXInitListExpr)::Bool
end

function clang_InitListExpr_hadArrayRangeDesignator(E)
    @ccall libclangex.clang_InitListExpr_hadArrayRangeDesignator(E::CXInitListExpr)::Bool
end

function clang_ParenExpr_getLParen(E)
    @ccall libclangex.clang_ParenExpr_getLParen(E::CXParenExpr)::CXSourceLocation_
end

function clang_ParenExpr_getRParen(E)
    @ccall libclangex.clang_ParenExpr_getRParen(E::CXParenExpr)::CXSourceLocation_
end

function clang_ArraySubscriptExpr_getRBracketLoc(E)
    @ccall libclangex.clang_ArraySubscriptExpr_getRBracketLoc(E::CXArraySubscriptExpr)::CXSourceLocation_
end

function clang_DeclRefExpr_hasTemplateKWAndArgsInfo(E)
    @ccall libclangex.clang_DeclRefExpr_hasTemplateKWAndArgsInfo(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_getTemplateKeywordLoc(E)
    @ccall libclangex.clang_DeclRefExpr_getTemplateKeywordLoc(E::CXDeclRefExpr)::CXSourceLocation_
end

function clang_DeclRefExpr_getLAngleLoc(E)
    @ccall libclangex.clang_DeclRefExpr_getLAngleLoc(E::CXDeclRefExpr)::CXSourceLocation_
end

function clang_DeclRefExpr_getRAngleLoc(E)
    @ccall libclangex.clang_DeclRefExpr_getRAngleLoc(E::CXDeclRefExpr)::CXSourceLocation_
end

function clang_DeclRefExpr_hasTemplateKeyword(E)
    @ccall libclangex.clang_DeclRefExpr_hasTemplateKeyword(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_hasExplicitTemplateArgs(E)
    @ccall libclangex.clang_DeclRefExpr_hasExplicitTemplateArgs(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_getNumTemplateArgs(E)
    @ccall libclangex.clang_DeclRefExpr_getNumTemplateArgs(E::CXDeclRefExpr)::Cuint
end

function clang_DeclRefExpr_hadMultipleCandidates(E)
    @ccall libclangex.clang_DeclRefExpr_hadMultipleCandidates(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_refersToEnclosingVariableOrCapture(E)
    @ccall libclangex.clang_DeclRefExpr_refersToEnclosingVariableOrCapture(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_isImmediateEscalating(E)
    @ccall libclangex.clang_DeclRefExpr_isImmediateEscalating(E::CXDeclRefExpr)::Bool
end

function clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(E)
    @ccall libclangex.clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(E::CXDeclRefExpr)::Bool
end

function clang_CastExpr_path_empty(E)
    @ccall libclangex.clang_CastExpr_path_empty(E::CXCastExpr)::Bool
end

function clang_CastExpr_path_size(E)
    @ccall libclangex.clang_CastExpr_path_size(E::CXCastExpr)::Cuint
end

function clang_CastExpr_hasStoredFPFeatures(E)
    @ccall libclangex.clang_CastExpr_hasStoredFPFeatures(E::CXCastExpr)::Bool
end

function clang_CastExpr_changesVolatileQualification(E)
    @ccall libclangex.clang_CastExpr_changesVolatileQualification(E::CXCastExpr)::Bool
end

function clang_ConstantExpr_isImmediateInvocation(E)
    @ccall libclangex.clang_ConstantExpr_isImmediateInvocation(E::CXConstantExpr)::Bool
end

function clang_ConstantExpr_hasAPValueResult(E)
    @ccall libclangex.clang_ConstantExpr_hasAPValueResult(E::CXConstantExpr)::Bool
end

function clang_StmtExpr_getLParenLoc(E)
    @ccall libclangex.clang_StmtExpr_getLParenLoc(E::CXStmtExpr)::CXSourceLocation_
end

function clang_StmtExpr_getRParenLoc(E)
    @ccall libclangex.clang_StmtExpr_getRParenLoc(E::CXStmtExpr)::CXSourceLocation_
end

function clang_StmtExpr_getTemplateDepth(E)
    @ccall libclangex.clang_StmtExpr_getTemplateDepth(E::CXStmtExpr)::Cuint
end

function clang_CompoundLiteralExpr_isFileScope(E)
    @ccall libclangex.clang_CompoundLiteralExpr_isFileScope(E::CXCompoundLiteralExpr)::Bool
end

function clang_CompoundLiteralExpr_getLParenLoc(E)
    @ccall libclangex.clang_CompoundLiteralExpr_getLParenLoc(E::CXCompoundLiteralExpr)::CXSourceLocation_
end

function clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(E::CXUnaryExprOrTypeTraitExpr)::CXTypeSourceInfo
end

function clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(E)
    @ccall libclangex.clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(E::CXUnaryExprOrTypeTraitExpr)::CXExpr
end

function clang_MemberExpr_getQualifier(E)
    @ccall libclangex.clang_MemberExpr_getQualifier(E::CXMemberExpr)::CXNestedNameSpecifier
end

function clang_InitListExpr_getArrayFiller(E)
    @ccall libclangex.clang_InitListExpr_getArrayFiller(E::CXInitListExpr)::CXExpr
end

function clang_InitListExpr_getInitializedFieldInUnion(E)
    @ccall libclangex.clang_InitListExpr_getInitializedFieldInUnion(E::CXInitListExpr)::CXFieldDecl
end

function clang_InitListExpr_getSemanticForm(E)
    @ccall libclangex.clang_InitListExpr_getSemanticForm(E::CXInitListExpr)::CXInitListExpr
end

function clang_DeclRefExpr_getQualifier(E)
    @ccall libclangex.clang_DeclRefExpr_getQualifier(E::CXDeclRefExpr)::CXNestedNameSpecifier
end

function clang_CastExpr_getConversionFunction(E)
    @ccall libclangex.clang_CastExpr_getConversionFunction(E::CXCastExpr)::CXNamedDecl
end

function clang_CastExpr_getTargetUnionField(E)
    @ccall libclangex.clang_CastExpr_getTargetUnionField(E::CXCastExpr)::CXFieldDecl
end

function clang_StmtExpr_getSubStmt(E)
    @ccall libclangex.clang_StmtExpr_getSubStmt(E::CXStmtExpr)::CXCompoundStmt
end

function clang_CompoundLiteralExpr_getInitializer(E)
    @ccall libclangex.clang_CompoundLiteralExpr_getInitializer(E::CXCompoundLiteralExpr)::CXExpr
end

function clang_CompoundLiteralExpr_getTypeSourceInfo(E)
    @ccall libclangex.clang_CompoundLiteralExpr_getTypeSourceInfo(E::CXCompoundLiteralExpr)::CXTypeSourceInfo
end

@enum CXOverloadedOperatorKind::Int32 begin
    CXOverloadedOperatorKind_OO_None = 0
    CXOverloadedOperatorKind_OO_New = 1
    CXOverloadedOperatorKind_OO_Delete = 2
    CXOverloadedOperatorKind_OO_Array_New = 3
    CXOverloadedOperatorKind_OO_Array_Delete = 4
    CXOverloadedOperatorKind_OO_Plus = 5
    CXOverloadedOperatorKind_OO_Minus = 6
    CXOverloadedOperatorKind_OO_Star = 7
    CXOverloadedOperatorKind_OO_Slash = 8
    CXOverloadedOperatorKind_OO_Percent = 9
    CXOverloadedOperatorKind_OO_Caret = 10
    CXOverloadedOperatorKind_OO_Amp = 11
    CXOverloadedOperatorKind_OO_Pipe = 12
    CXOverloadedOperatorKind_OO_Tilde = 13
    CXOverloadedOperatorKind_OO_Exclaim = 14
    CXOverloadedOperatorKind_OO_Equal = 15
    CXOverloadedOperatorKind_OO_Less = 16
    CXOverloadedOperatorKind_OO_Greater = 17
    CXOverloadedOperatorKind_OO_PlusEqual = 18
    CXOverloadedOperatorKind_OO_MinusEqual = 19
    CXOverloadedOperatorKind_OO_StarEqual = 20
    CXOverloadedOperatorKind_OO_SlashEqual = 21
    CXOverloadedOperatorKind_OO_PercentEqual = 22
    CXOverloadedOperatorKind_OO_CaretEqual = 23
    CXOverloadedOperatorKind_OO_AmpEqual = 24
    CXOverloadedOperatorKind_OO_PipeEqual = 25
    CXOverloadedOperatorKind_OO_LessLess = 26
    CXOverloadedOperatorKind_OO_GreaterGreater = 27
    CXOverloadedOperatorKind_OO_LessLessEqual = 28
    CXOverloadedOperatorKind_OO_GreaterGreaterEqual = 29
    CXOverloadedOperatorKind_OO_EqualEqual = 30
    CXOverloadedOperatorKind_OO_ExclaimEqual = 31
    CXOverloadedOperatorKind_OO_LessEqual = 32
    CXOverloadedOperatorKind_OO_GreaterEqual = 33
    CXOverloadedOperatorKind_OO_Spaceship = 34
    CXOverloadedOperatorKind_OO_AmpAmp = 35
    CXOverloadedOperatorKind_OO_PipePipe = 36
    CXOverloadedOperatorKind_OO_PlusPlus = 37
    CXOverloadedOperatorKind_OO_MinusMinus = 38
    CXOverloadedOperatorKind_OO_Comma = 39
    CXOverloadedOperatorKind_OO_ArrowStar = 40
    CXOverloadedOperatorKind_OO_Arrow = 41
    CXOverloadedOperatorKind_OO_Call = 42
    CXOverloadedOperatorKind_OO_Subscript = 43
    CXOverloadedOperatorKind_OO_Conditional = 44
    CXOverloadedOperatorKind_OO_Coawait = 45
end

function clang_getOperatorSpelling(Operator)
    @ccall libclangex.clang_getOperatorSpelling(Operator::CXOverloadedOperatorKind)::Ptr{Cchar}
end

function clang_CXXOperatorCallExpr_getOperator(OCE)
    @ccall libclangex.clang_CXXOperatorCallExpr_getOperator(OCE::CXCXXOperatorCallExpr)::CXOverloadedOperatorKind
end

function clang_CXXOperatorCallExpr_getOperatorLoc(OCE)
    @ccall libclangex.clang_CXXOperatorCallExpr_getOperatorLoc(OCE::CXCXXOperatorCallExpr)::CXSourceLocation_
end

function clang_CXXMemberCallExpr_getImplicitObjectArgument(MCE)
    @ccall libclangex.clang_CXXMemberCallExpr_getImplicitObjectArgument(MCE::CXCXXMemberCallExpr)::CXExpr
end

function clang_CXXMemberCallExpr_getMethodDecl(MCE)
    @ccall libclangex.clang_CXXMemberCallExpr_getMethodDecl(MCE::CXCXXMemberCallExpr)::CXCXXMethodDecl
end

function clang_CXXMemberCallExpr_getRecordDecl(MCE)
    @ccall libclangex.clang_CXXMemberCallExpr_getRecordDecl(MCE::CXCXXMemberCallExpr)::CXCXXRecordDecl
end

function clang_CXXBoolLiteralExpr_getValue(BLE)
    @ccall libclangex.clang_CXXBoolLiteralExpr_getValue(BLE::CXCXXBoolLiteralExpr)::Bool
end

@enum CXCXXConstructionKind::UInt32 begin
    CXCXXConstructionKind_Complete = 0
    CXCXXConstructionKind_NonVirtualBase = 1
    CXCXXConstructionKind_VirtualBase = 2
    CXCXXConstructionKind_Delegating = 3
end

function clang_CXXConstructExpr_getConstructor(CE)
    @ccall libclangex.clang_CXXConstructExpr_getConstructor(CE::CXCXXConstructExpr)::CXCXXConstructorDecl
end

function clang_CXXConstructExpr_getNumArgs(CE)
    @ccall libclangex.clang_CXXConstructExpr_getNumArgs(CE::CXCXXConstructExpr)::Cuint
end

function clang_CXXConstructExpr_getArg(CE, Arg)
    @ccall libclangex.clang_CXXConstructExpr_getArg(CE::CXCXXConstructExpr, Arg::Cuint)::CXExpr
end

function clang_CXXConstructExpr_isElidable(CE)
    @ccall libclangex.clang_CXXConstructExpr_isElidable(CE::CXCXXConstructExpr)::Bool
end

function clang_CXXConstructExpr_getConstructionKind(CE)
    @ccall libclangex.clang_CXXConstructExpr_getConstructionKind(CE::CXCXXConstructExpr)::CXCXXConstructionKind
end

function clang_LambdaExpr_getCallOperator(LE)
    @ccall libclangex.clang_LambdaExpr_getCallOperator(LE::CXLambdaExpr)::CXCXXMethodDecl
end

function clang_LambdaExpr_getLambdaClass(LE)
    @ccall libclangex.clang_LambdaExpr_getLambdaClass(LE::CXLambdaExpr)::CXCXXRecordDecl
end

function clang_LambdaExpr_getBody(LE)
    @ccall libclangex.clang_LambdaExpr_getBody(LE::CXLambdaExpr)::CXStmt
end

function clang_LambdaExpr_isMutable(LE)
    @ccall libclangex.clang_LambdaExpr_isMutable(LE::CXLambdaExpr)::Bool
end

@enum CXCXXNewInitializationStyle::UInt32 begin
    CXCXXNewInitializationStyle_None = 0
    CXCXXNewInitializationStyle_Parens = 1
    CXCXXNewInitializationStyle_Braces = 2
end

function clang_CXXNewExpr_getInitializationStyle(NE)
    @ccall libclangex.clang_CXXNewExpr_getInitializationStyle(NE::CXCXXNewExpr)::CXCXXNewInitializationStyle
end

function clang_CXXNewExpr_getOperatorNew(NE)
    @ccall libclangex.clang_CXXNewExpr_getOperatorNew(NE::CXCXXNewExpr)::CXFunctionDecl
end

function clang_CXXNewExpr_getOperatorDelete(NE)
    @ccall libclangex.clang_CXXNewExpr_getOperatorDelete(NE::CXCXXNewExpr)::CXFunctionDecl
end

function clang_CXXNewExpr_getAllocatedType(NE)
    @ccall libclangex.clang_CXXNewExpr_getAllocatedType(NE::CXCXXNewExpr)::CXQualType
end

function clang_CXXNewExpr_isArray(NE)
    @ccall libclangex.clang_CXXNewExpr_isArray(NE::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_getArraySize(NE)
    @ccall libclangex.clang_CXXNewExpr_getArraySize(NE::CXCXXNewExpr)::CXExpr
end

function clang_CXXNewExpr_hasInitializer(NE)
    @ccall libclangex.clang_CXXNewExpr_hasInitializer(NE::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_getInitializer(NE)
    @ccall libclangex.clang_CXXNewExpr_getInitializer(NE::CXCXXNewExpr)::CXExpr
end

function clang_CXXDeleteExpr_getArgument(DE)
    @ccall libclangex.clang_CXXDeleteExpr_getArgument(DE::CXCXXDeleteExpr)::CXExpr
end

function clang_CXXDeleteExpr_isArrayForm(DE)
    @ccall libclangex.clang_CXXDeleteExpr_isArrayForm(DE::CXCXXDeleteExpr)::Bool
end

function clang_CXXDeleteExpr_getOperatorDelete(DE)
    @ccall libclangex.clang_CXXDeleteExpr_getOperatorDelete(DE::CXCXXDeleteExpr)::CXFunctionDecl
end

function clang_CXXBoolLiteralExpr_getLocation(E)
    @ccall libclangex.clang_CXXBoolLiteralExpr_getLocation(E::CXCXXBoolLiteralExpr)::CXSourceLocation_
end

function clang_CXXThisExpr_getLocation(E)
    @ccall libclangex.clang_CXXThisExpr_getLocation(E::CXCXXThisExpr)::CXSourceLocation_
end

function clang_CXXThisExpr_isImplicit(E)
    @ccall libclangex.clang_CXXThisExpr_isImplicit(E::CXCXXThisExpr)::Bool
end

function clang_CXXNewExpr_shouldNullCheckAllocation(E)
    @ccall libclangex.clang_CXXNewExpr_shouldNullCheckAllocation(E::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_getNumPlacementArgs(E)
    @ccall libclangex.clang_CXXNewExpr_getNumPlacementArgs(E::CXCXXNewExpr)::Cuint
end

function clang_CXXNewExpr_isParenTypeId(E)
    @ccall libclangex.clang_CXXNewExpr_isParenTypeId(E::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_isGlobalNew(E)
    @ccall libclangex.clang_CXXNewExpr_isGlobalNew(E::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_passAlignment(E)
    @ccall libclangex.clang_CXXNewExpr_passAlignment(E::CXCXXNewExpr)::Bool
end

function clang_CXXNewExpr_doesUsualArrayDeleteWantSize(E)
    @ccall libclangex.clang_CXXNewExpr_doesUsualArrayDeleteWantSize(E::CXCXXNewExpr)::Bool
end

function clang_CXXDeleteExpr_isGlobalDelete(E)
    @ccall libclangex.clang_CXXDeleteExpr_isGlobalDelete(E::CXCXXDeleteExpr)::Bool
end

function clang_CXXDeleteExpr_isArrayFormAsWritten(E)
    @ccall libclangex.clang_CXXDeleteExpr_isArrayFormAsWritten(E::CXCXXDeleteExpr)::Bool
end

function clang_CXXDeleteExpr_doesUsualArrayDeleteWantSize(E)
    @ccall libclangex.clang_CXXDeleteExpr_doesUsualArrayDeleteWantSize(E::CXCXXDeleteExpr)::Bool
end

function clang_CXXDeleteExpr_getDestroyedType(E)
    @ccall libclangex.clang_CXXDeleteExpr_getDestroyedType(E::CXCXXDeleteExpr)::CXQualType
end

function clang_CXXConstructExpr_getLocation(E)
    @ccall libclangex.clang_CXXConstructExpr_getLocation(E::CXCXXConstructExpr)::CXSourceLocation_
end

function clang_CXXConstructExpr_hadMultipleCandidates(E)
    @ccall libclangex.clang_CXXConstructExpr_hadMultipleCandidates(E::CXCXXConstructExpr)::Bool
end

function clang_CXXConstructExpr_isListInitialization(E)
    @ccall libclangex.clang_CXXConstructExpr_isListInitialization(E::CXCXXConstructExpr)::Bool
end

function clang_CXXConstructExpr_isStdInitListInitialization(E)
    @ccall libclangex.clang_CXXConstructExpr_isStdInitListInitialization(E::CXCXXConstructExpr)::Bool
end

function clang_CXXConstructExpr_requiresZeroInitialization(E)
    @ccall libclangex.clang_CXXConstructExpr_requiresZeroInitialization(E::CXCXXConstructExpr)::Bool
end

function clang_CXXConstructExpr_isImmediateEscalating(E)
    @ccall libclangex.clang_CXXConstructExpr_isImmediateEscalating(E::CXCXXConstructExpr)::Bool
end

function clang_MaterializeTemporaryExpr_getManglingNumber(E)
    @ccall libclangex.clang_MaterializeTemporaryExpr_getManglingNumber(E::CXMaterializeTemporaryExpr)::Cuint
end

function clang_MaterializeTemporaryExpr_isBoundToLvalueReference(E)
    @ccall libclangex.clang_MaterializeTemporaryExpr_isBoundToLvalueReference(E::CXMaterializeTemporaryExpr)::Bool
end

function clang_CXXNamedCastExpr_getOperatorLoc(E)
    @ccall libclangex.clang_CXXNamedCastExpr_getOperatorLoc(E::CXCXXNamedCastExpr)::CXSourceLocation_
end

function clang_CXXNamedCastExpr_getRParenLoc(E)
    @ccall libclangex.clang_CXXNamedCastExpr_getRParenLoc(E::CXCXXNamedCastExpr)::CXSourceLocation_
end

function clang_CXXNewExpr_getAllocatedTypeSourceInfo(E)
    @ccall libclangex.clang_CXXNewExpr_getAllocatedTypeSourceInfo(E::CXCXXNewExpr)::CXTypeSourceInfo
end

function clang_CXXNewExpr_getConstructExpr(E)
    @ccall libclangex.clang_CXXNewExpr_getConstructExpr(E::CXCXXNewExpr)::CXCXXConstructExpr
end

function clang_MaterializeTemporaryExpr_getSubExpr(E)
    @ccall libclangex.clang_MaterializeTemporaryExpr_getSubExpr(E::CXMaterializeTemporaryExpr)::CXExpr
end

function clang_MaterializeTemporaryExpr_getExtendingDecl(E)
    @ccall libclangex.clang_MaterializeTemporaryExpr_getExtendingDecl(E::CXMaterializeTemporaryExpr)::CXValueDecl
end

@enum CXMangleContext_ManglerKind::UInt32 begin
    CXMangleContext_MK_Itanium = 0
    CXMangleContext_MK_Microsoft = 1
end

function clang_MangleContext_getKind(MC)
    @ccall libclangex.clang_MangleContext_getKind(MC::CXMangleContext)::CXMangleContext_ManglerKind
end

function clang_MangleContext_getASTContext(MC)
    @ccall libclangex.clang_MangleContext_getASTContext(MC::CXMangleContext)::CXASTContext
end

function clang_MangleContext_getDiags(MC)
    @ccall libclangex.clang_MangleContext_getDiags(MC::CXMangleContext)::CXDiagnosticsEngine
end

function clang_MangleContext_getAnonymousStructId(MC, D)
    @ccall libclangex.clang_MangleContext_getAnonymousStructId(MC::CXMangleContext, D::CXNamedDecl)::UInt64
end

function clang_MangleContext_shouldMangleDeclName(MC, D)
    @ccall libclangex.clang_MangleContext_shouldMangleDeclName(MC::CXMangleContext, D::CXNamedDecl)::Bool
end

function clang_MangleContext_shouldMangleCXXName(MC, D)
    @ccall libclangex.clang_MangleContext_shouldMangleCXXName(MC::CXMangleContext, D::CXNamedDecl)::Bool
end

function clang_MangleContext_shouldMangleStringLiteral(MC, SL)
    @ccall libclangex.clang_MangleContext_shouldMangleStringLiteral(MC::CXMangleContext, SL::CXStringLiteral)::Bool
end

function clang_MangleContext_mangleName(MC, D)
    @ccall libclangex.clang_MangleContext_mangleName(MC::CXMangleContext, D::CXNamedDecl)::CXString
end

function clang_ASTNameGenerator_getName(G, D)
    @ccall libclangex.clang_ASTNameGenerator_getName(G::CXASTNameGenerator, D::CXDecl)::CXString
end

function clang_ASTNameGenerator_getAllManglings(G, D)
    @ccall libclangex.clang_ASTNameGenerator_getAllManglings(G::CXASTNameGenerator, D::CXDecl)::Ptr{CXStringSet}
end

function clang_NestedNameSpecifier_getPrefix(NNS)
    @ccall libclangex.clang_NestedNameSpecifier_getPrefix(NNS::CXNestedNameSpecifier)::CXNestedNameSpecifier
end

function clang_NestedNameSpecifier_containsErrors(NNS)
    @ccall libclangex.clang_NestedNameSpecifier_containsErrors(NNS::CXNestedNameSpecifier)::Bool
end

function clang_NestedNameSpecifier_dump(NNS)
    @ccall libclangex.clang_NestedNameSpecifier_dump(NNS::CXNestedNameSpecifier)::Cvoid
end

function clang_NestedNameSpecifier_getName(NNS)
    @ccall libclangex.clang_NestedNameSpecifier_getName(NNS::CXNestedNameSpecifier)::CXString
end

@enum CXStmtClass::UInt32 begin
    CXStmtClass_NoStmtClass = 0
    CXStmtClass_WhileStmtClass = 1
    CXStmtClass_LabelStmtClass = 2
    CXStmtClass_VAArgExprClass = 3
    CXStmtClass_UnaryOperatorClass = 4
    CXStmtClass_UnaryExprOrTypeTraitExprClass = 5
    CXStmtClass_TypoExprClass = 6
    CXStmtClass_TypeTraitExprClass = 7
    CXStmtClass_SubstNonTypeTemplateParmPackExprClass = 8
    CXStmtClass_SubstNonTypeTemplateParmExprClass = 9
    CXStmtClass_StringLiteralClass = 10
    CXStmtClass_StmtExprClass = 11
    CXStmtClass_SourceLocExprClass = 12
    CXStmtClass_SizeOfPackExprClass = 13
    CXStmtClass_ShuffleVectorExprClass = 14
    CXStmtClass_SYCLUniqueStableNameExprClass = 15
    CXStmtClass_RequiresExprClass = 16
    CXStmtClass_RecoveryExprClass = 17
    CXStmtClass_PseudoObjectExprClass = 18
    CXStmtClass_PredefinedExprClass = 19
    CXStmtClass_ParenListExprClass = 20
    CXStmtClass_ParenExprClass = 21
    CXStmtClass_PackExpansionExprClass = 22
    CXStmtClass_UnresolvedMemberExprClass = 23
    CXStmtClass_UnresolvedLookupExprClass = 24
    CXStmtClass_OpaqueValueExprClass = 25
    CXStmtClass_OffsetOfExprClass = 26
    CXStmtClass_ObjCSubscriptRefExprClass = 27
    CXStmtClass_ObjCStringLiteralClass = 28
    CXStmtClass_ObjCSelectorExprClass = 29
    CXStmtClass_ObjCProtocolExprClass = 30
    CXStmtClass_ObjCPropertyRefExprClass = 31
    CXStmtClass_ObjCMessageExprClass = 32
    CXStmtClass_ObjCIvarRefExprClass = 33
    CXStmtClass_ObjCIsaExprClass = 34
    CXStmtClass_ObjCIndirectCopyRestoreExprClass = 35
    CXStmtClass_ObjCEncodeExprClass = 36
    CXStmtClass_ObjCDictionaryLiteralClass = 37
    CXStmtClass_ObjCBoxedExprClass = 38
    CXStmtClass_ObjCBoolLiteralExprClass = 39
    CXStmtClass_ObjCAvailabilityCheckExprClass = 40
    CXStmtClass_ObjCArrayLiteralClass = 41
    CXStmtClass_OMPIteratorExprClass = 42
    CXStmtClass_OMPArrayShapingExprClass = 43
    CXStmtClass_OMPArraySectionExprClass = 44
    CXStmtClass_NoInitExprClass = 45
    CXStmtClass_MemberExprClass = 46
    CXStmtClass_MatrixSubscriptExprClass = 47
    CXStmtClass_MaterializeTemporaryExprClass = 48
    CXStmtClass_MSPropertySubscriptExprClass = 49
    CXStmtClass_MSPropertyRefExprClass = 50
    CXStmtClass_LambdaExprClass = 51
    CXStmtClass_IntegerLiteralClass = 52
    CXStmtClass_InitListExprClass = 53
    CXStmtClass_ImplicitValueInitExprClass = 54
    CXStmtClass_ImaginaryLiteralClass = 55
    CXStmtClass_GenericSelectionExprClass = 56
    CXStmtClass_GNUNullExprClass = 57
    CXStmtClass_FunctionParmPackExprClass = 58
    CXStmtClass_ExprWithCleanupsClass = 59
    CXStmtClass_ConstantExprClass = 60
    CXStmtClass_FloatingLiteralClass = 61
    CXStmtClass_FixedPointLiteralClass = 62
    CXStmtClass_ExtVectorElementExprClass = 63
    CXStmtClass_ExpressionTraitExprClass = 64
    CXStmtClass_DesignatedInitUpdateExprClass = 65
    CXStmtClass_DesignatedInitExprClass = 66
    CXStmtClass_DependentScopeDeclRefExprClass = 67
    CXStmtClass_DependentCoawaitExprClass = 68
    CXStmtClass_DeclRefExprClass = 69
    CXStmtClass_CoyieldExprClass = 70
    CXStmtClass_CoawaitExprClass = 71
    CXStmtClass_ConvertVectorExprClass = 72
    CXStmtClass_ConceptSpecializationExprClass = 73
    CXStmtClass_CompoundLiteralExprClass = 74
    CXStmtClass_ChooseExprClass = 75
    CXStmtClass_CharacterLiteralClass = 76
    CXStmtClass_ImplicitCastExprClass = 77
    CXStmtClass_ObjCBridgedCastExprClass = 78
    CXStmtClass_CXXStaticCastExprClass = 79
    CXStmtClass_CXXReinterpretCastExprClass = 80
    CXStmtClass_CXXDynamicCastExprClass = 81
    CXStmtClass_CXXConstCastExprClass = 82
    CXStmtClass_CXXAddrspaceCastExprClass = 83
    CXStmtClass_CXXFunctionalCastExprClass = 84
    CXStmtClass_CStyleCastExprClass = 85
    CXStmtClass_BuiltinBitCastExprClass = 86
    CXStmtClass_CallExprClass = 87
    CXStmtClass_UserDefinedLiteralClass = 88
    CXStmtClass_CXXOperatorCallExprClass = 89
    CXStmtClass_CXXMemberCallExprClass = 90
    CXStmtClass_CUDAKernelCallExprClass = 91
    CXStmtClass_CXXUuidofExprClass = 92
    CXStmtClass_CXXUnresolvedConstructExprClass = 93
    CXStmtClass_CXXTypeidExprClass = 94
    CXStmtClass_CXXThrowExprClass = 95
    CXStmtClass_CXXThisExprClass = 96
    CXStmtClass_CXXStdInitializerListExprClass = 97
    CXStmtClass_CXXScalarValueInitExprClass = 98
    CXStmtClass_CXXRewrittenBinaryOperatorClass = 99
    CXStmtClass_CXXPseudoDestructorExprClass = 100
    CXStmtClass_CXXParenListInitExprClass = 101
    CXStmtClass_CXXNullPtrLiteralExprClass = 102
    CXStmtClass_CXXNoexceptExprClass = 103
    CXStmtClass_CXXNewExprClass = 104
    CXStmtClass_CXXInheritedCtorInitExprClass = 105
    CXStmtClass_CXXFoldExprClass = 106
    CXStmtClass_CXXDependentScopeMemberExprClass = 107
    CXStmtClass_CXXDeleteExprClass = 108
    CXStmtClass_CXXDefaultInitExprClass = 109
    CXStmtClass_CXXDefaultArgExprClass = 110
    CXStmtClass_CXXConstructExprClass = 111
    CXStmtClass_CXXTemporaryObjectExprClass = 112
    CXStmtClass_CXXBoolLiteralExprClass = 113
    CXStmtClass_CXXBindTemporaryExprClass = 114
    CXStmtClass_BlockExprClass = 115
    CXStmtClass_BinaryOperatorClass = 116
    CXStmtClass_CompoundAssignOperatorClass = 117
    CXStmtClass_AtomicExprClass = 118
    CXStmtClass_AsTypeExprClass = 119
    CXStmtClass_ArrayTypeTraitExprClass = 120
    CXStmtClass_ArraySubscriptExprClass = 121
    CXStmtClass_ArrayInitLoopExprClass = 122
    CXStmtClass_ArrayInitIndexExprClass = 123
    CXStmtClass_AddrLabelExprClass = 124
    CXStmtClass_ConditionalOperatorClass = 125
    CXStmtClass_BinaryConditionalOperatorClass = 126
    CXStmtClass_AttributedStmtClass = 127
    CXStmtClass_SwitchStmtClass = 128
    CXStmtClass_DefaultStmtClass = 129
    CXStmtClass_CaseStmtClass = 130
    CXStmtClass_SEHTryStmtClass = 131
    CXStmtClass_SEHLeaveStmtClass = 132
    CXStmtClass_SEHFinallyStmtClass = 133
    CXStmtClass_SEHExceptStmtClass = 134
    CXStmtClass_ReturnStmtClass = 135
    CXStmtClass_ObjCForCollectionStmtClass = 136
    CXStmtClass_ObjCAutoreleasePoolStmtClass = 137
    CXStmtClass_ObjCAtTryStmtClass = 138
    CXStmtClass_ObjCAtThrowStmtClass = 139
    CXStmtClass_ObjCAtSynchronizedStmtClass = 140
    CXStmtClass_ObjCAtFinallyStmtClass = 141
    CXStmtClass_ObjCAtCatchStmtClass = 142
    CXStmtClass_OMPTeamsDirectiveClass = 143
    CXStmtClass_OMPTaskyieldDirectiveClass = 144
    CXStmtClass_OMPTaskwaitDirectiveClass = 145
    CXStmtClass_OMPTaskgroupDirectiveClass = 146
    CXStmtClass_OMPTaskDirectiveClass = 147
    CXStmtClass_OMPTargetUpdateDirectiveClass = 148
    CXStmtClass_OMPTargetTeamsDirectiveClass = 149
    CXStmtClass_OMPTargetParallelForDirectiveClass = 150
    CXStmtClass_OMPTargetParallelDirectiveClass = 151
    CXStmtClass_OMPTargetExitDataDirectiveClass = 152
    CXStmtClass_OMPTargetEnterDataDirectiveClass = 153
    CXStmtClass_OMPTargetDirectiveClass = 154
    CXStmtClass_OMPTargetDataDirectiveClass = 155
    CXStmtClass_OMPSingleDirectiveClass = 156
    CXStmtClass_OMPSectionsDirectiveClass = 157
    CXStmtClass_OMPSectionDirectiveClass = 158
    CXStmtClass_OMPScopeDirectiveClass = 159
    CXStmtClass_OMPScanDirectiveClass = 160
    CXStmtClass_OMPParallelSectionsDirectiveClass = 161
    CXStmtClass_OMPParallelMasterDirectiveClass = 162
    CXStmtClass_OMPParallelMaskedDirectiveClass = 163
    CXStmtClass_OMPParallelDirectiveClass = 164
    CXStmtClass_OMPOrderedDirectiveClass = 165
    CXStmtClass_OMPMetaDirectiveClass = 166
    CXStmtClass_OMPMasterDirectiveClass = 167
    CXStmtClass_OMPMaskedDirectiveClass = 168
    CXStmtClass_OMPUnrollDirectiveClass = 169
    CXStmtClass_OMPTileDirectiveClass = 170
    CXStmtClass_OMPTeamsGenericLoopDirectiveClass = 171
    CXStmtClass_OMPTeamsDistributeSimdDirectiveClass = 172
    CXStmtClass_OMPTeamsDistributeParallelForSimdDirectiveClass = 173
    CXStmtClass_OMPTeamsDistributeParallelForDirectiveClass = 174
    CXStmtClass_OMPTeamsDistributeDirectiveClass = 175
    CXStmtClass_OMPTaskLoopSimdDirectiveClass = 176
    CXStmtClass_OMPTaskLoopDirectiveClass = 177
    CXStmtClass_OMPTargetTeamsGenericLoopDirectiveClass = 178
    CXStmtClass_OMPTargetTeamsDistributeSimdDirectiveClass = 179
    CXStmtClass_OMPTargetTeamsDistributeParallelForSimdDirectiveClass = 180
    CXStmtClass_OMPTargetTeamsDistributeParallelForDirectiveClass = 181
    CXStmtClass_OMPTargetTeamsDistributeDirectiveClass = 182
    CXStmtClass_OMPTargetSimdDirectiveClass = 183
    CXStmtClass_OMPTargetParallelGenericLoopDirectiveClass = 184
    CXStmtClass_OMPTargetParallelForSimdDirectiveClass = 185
    CXStmtClass_OMPSimdDirectiveClass = 186
    CXStmtClass_OMPParallelMasterTaskLoopSimdDirectiveClass = 187
    CXStmtClass_OMPParallelMasterTaskLoopDirectiveClass = 188
    CXStmtClass_OMPParallelMaskedTaskLoopSimdDirectiveClass = 189
    CXStmtClass_OMPParallelMaskedTaskLoopDirectiveClass = 190
    CXStmtClass_OMPParallelGenericLoopDirectiveClass = 191
    CXStmtClass_OMPParallelForSimdDirectiveClass = 192
    CXStmtClass_OMPParallelForDirectiveClass = 193
    CXStmtClass_OMPMasterTaskLoopSimdDirectiveClass = 194
    CXStmtClass_OMPMasterTaskLoopDirectiveClass = 195
    CXStmtClass_OMPMaskedTaskLoopSimdDirectiveClass = 196
    CXStmtClass_OMPMaskedTaskLoopDirectiveClass = 197
    CXStmtClass_OMPGenericLoopDirectiveClass = 198
    CXStmtClass_OMPForSimdDirectiveClass = 199
    CXStmtClass_OMPForDirectiveClass = 200
    CXStmtClass_OMPDistributeSimdDirectiveClass = 201
    CXStmtClass_OMPDistributeParallelForSimdDirectiveClass = 202
    CXStmtClass_OMPDistributeParallelForDirectiveClass = 203
    CXStmtClass_OMPDistributeDirectiveClass = 204
    CXStmtClass_OMPInteropDirectiveClass = 205
    CXStmtClass_OMPFlushDirectiveClass = 206
    CXStmtClass_OMPErrorDirectiveClass = 207
    CXStmtClass_OMPDispatchDirectiveClass = 208
    CXStmtClass_OMPDepobjDirectiveClass = 209
    CXStmtClass_OMPCriticalDirectiveClass = 210
    CXStmtClass_OMPCancellationPointDirectiveClass = 211
    CXStmtClass_OMPCancelDirectiveClass = 212
    CXStmtClass_OMPBarrierDirectiveClass = 213
    CXStmtClass_OMPAtomicDirectiveClass = 214
    CXStmtClass_OMPCanonicalLoopClass = 215
    CXStmtClass_NullStmtClass = 216
    CXStmtClass_MSDependentExistsStmtClass = 217
    CXStmtClass_IndirectGotoStmtClass = 218
    CXStmtClass_IfStmtClass = 219
    CXStmtClass_GotoStmtClass = 220
    CXStmtClass_ForStmtClass = 221
    CXStmtClass_DoStmtClass = 222
    CXStmtClass_DeclStmtClass = 223
    CXStmtClass_CoroutineBodyStmtClass = 224
    CXStmtClass_CoreturnStmtClass = 225
    CXStmtClass_ContinueStmtClass = 226
    CXStmtClass_CompoundStmtClass = 227
    CXStmtClass_CapturedStmtClass = 228
    CXStmtClass_CXXTryStmtClass = 229
    CXStmtClass_CXXForRangeStmtClass = 230
    CXStmtClass_CXXCatchStmtClass = 231
    CXStmtClass_BreakStmtClass = 232
    CXStmtClass_MSAsmStmtClass = 233
    CXStmtClass_GCCAsmStmtClass = 234
end

function clang_Stmt_castToWhileStmt(S)
    @ccall libclangex.clang_Stmt_castToWhileStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isWhileStmt(S)
    @ccall libclangex.clang_Stmt_isWhileStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToValueStmt(S)
    @ccall libclangex.clang_Stmt_castToValueStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isValueStmt(S)
    @ccall libclangex.clang_Stmt_isValueStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToLabelStmt(S)
    @ccall libclangex.clang_Stmt_castToLabelStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isLabelStmt(S)
    @ccall libclangex.clang_Stmt_isLabelStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToExpr(S)
    @ccall libclangex.clang_Stmt_castToExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isExpr(S)
    @ccall libclangex.clang_Stmt_isExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToVAArgExpr(S)
    @ccall libclangex.clang_Stmt_castToVAArgExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isVAArgExpr(S)
    @ccall libclangex.clang_Stmt_isVAArgExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToUnaryOperator(S)
    @ccall libclangex.clang_Stmt_castToUnaryOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isUnaryOperator(S)
    @ccall libclangex.clang_Stmt_isUnaryOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToUnaryExprOrTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_castToUnaryExprOrTypeTraitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isUnaryExprOrTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_isUnaryExprOrTypeTraitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToTypoExpr(S)
    @ccall libclangex.clang_Stmt_castToTypoExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isTypoExpr(S)
    @ccall libclangex.clang_Stmt_isTypoExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_castToTypeTraitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_isTypeTraitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToSubstNonTypeTemplateParmPackExpr(S)
    @ccall libclangex.clang_Stmt_castToSubstNonTypeTemplateParmPackExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isSubstNonTypeTemplateParmPackExpr(S)
    @ccall libclangex.clang_Stmt_isSubstNonTypeTemplateParmPackExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToSubstNonTypeTemplateParmExpr(S)
    @ccall libclangex.clang_Stmt_castToSubstNonTypeTemplateParmExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isSubstNonTypeTemplateParmExpr(S)
    @ccall libclangex.clang_Stmt_isSubstNonTypeTemplateParmExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToStringLiteral(S)
    @ccall libclangex.clang_Stmt_castToStringLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isStringLiteral(S)
    @ccall libclangex.clang_Stmt_isStringLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToStmtExpr(S)
    @ccall libclangex.clang_Stmt_castToStmtExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isStmtExpr(S)
    @ccall libclangex.clang_Stmt_isStmtExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToSourceLocExpr(S)
    @ccall libclangex.clang_Stmt_castToSourceLocExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isSourceLocExpr(S)
    @ccall libclangex.clang_Stmt_isSourceLocExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToSizeOfPackExpr(S)
    @ccall libclangex.clang_Stmt_castToSizeOfPackExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isSizeOfPackExpr(S)
    @ccall libclangex.clang_Stmt_isSizeOfPackExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToShuffleVectorExpr(S)
    @ccall libclangex.clang_Stmt_castToShuffleVectorExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isShuffleVectorExpr(S)
    @ccall libclangex.clang_Stmt_isShuffleVectorExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToSYCLUniqueStableNameExpr(S)
    @ccall libclangex.clang_Stmt_castToSYCLUniqueStableNameExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isSYCLUniqueStableNameExpr(S)
    @ccall libclangex.clang_Stmt_isSYCLUniqueStableNameExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToRequiresExpr(S)
    @ccall libclangex.clang_Stmt_castToRequiresExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isRequiresExpr(S)
    @ccall libclangex.clang_Stmt_isRequiresExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToRecoveryExpr(S)
    @ccall libclangex.clang_Stmt_castToRecoveryExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isRecoveryExpr(S)
    @ccall libclangex.clang_Stmt_isRecoveryExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToPseudoObjectExpr(S)
    @ccall libclangex.clang_Stmt_castToPseudoObjectExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isPseudoObjectExpr(S)
    @ccall libclangex.clang_Stmt_isPseudoObjectExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToPredefinedExpr(S)
    @ccall libclangex.clang_Stmt_castToPredefinedExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isPredefinedExpr(S)
    @ccall libclangex.clang_Stmt_isPredefinedExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToParenListExpr(S)
    @ccall libclangex.clang_Stmt_castToParenListExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isParenListExpr(S)
    @ccall libclangex.clang_Stmt_isParenListExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToParenExpr(S)
    @ccall libclangex.clang_Stmt_castToParenExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isParenExpr(S)
    @ccall libclangex.clang_Stmt_isParenExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToPackExpansionExpr(S)
    @ccall libclangex.clang_Stmt_castToPackExpansionExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isPackExpansionExpr(S)
    @ccall libclangex.clang_Stmt_isPackExpansionExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToOverloadExpr(S)
    @ccall libclangex.clang_Stmt_castToOverloadExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOverloadExpr(S)
    @ccall libclangex.clang_Stmt_isOverloadExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToUnresolvedMemberExpr(S)
    @ccall libclangex.clang_Stmt_castToUnresolvedMemberExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isUnresolvedMemberExpr(S)
    @ccall libclangex.clang_Stmt_isUnresolvedMemberExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToUnresolvedLookupExpr(S)
    @ccall libclangex.clang_Stmt_castToUnresolvedLookupExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isUnresolvedLookupExpr(S)
    @ccall libclangex.clang_Stmt_isUnresolvedLookupExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToOpaqueValueExpr(S)
    @ccall libclangex.clang_Stmt_castToOpaqueValueExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOpaqueValueExpr(S)
    @ccall libclangex.clang_Stmt_isOpaqueValueExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToOffsetOfExpr(S)
    @ccall libclangex.clang_Stmt_castToOffsetOfExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOffsetOfExpr(S)
    @ccall libclangex.clang_Stmt_isOffsetOfExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCSubscriptRefExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCSubscriptRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCSubscriptRefExpr(S)
    @ccall libclangex.clang_Stmt_isObjCSubscriptRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCStringLiteral(S)
    @ccall libclangex.clang_Stmt_castToObjCStringLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCStringLiteral(S)
    @ccall libclangex.clang_Stmt_isObjCStringLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCSelectorExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCSelectorExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCSelectorExpr(S)
    @ccall libclangex.clang_Stmt_isObjCSelectorExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCProtocolExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCProtocolExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCProtocolExpr(S)
    @ccall libclangex.clang_Stmt_isObjCProtocolExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCPropertyRefExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCPropertyRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCPropertyRefExpr(S)
    @ccall libclangex.clang_Stmt_isObjCPropertyRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCMessageExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCMessageExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCMessageExpr(S)
    @ccall libclangex.clang_Stmt_isObjCMessageExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCIvarRefExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCIvarRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCIvarRefExpr(S)
    @ccall libclangex.clang_Stmt_isObjCIvarRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCIsaExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCIsaExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCIsaExpr(S)
    @ccall libclangex.clang_Stmt_isObjCIsaExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCIndirectCopyRestoreExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCIndirectCopyRestoreExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCIndirectCopyRestoreExpr(S)
    @ccall libclangex.clang_Stmt_isObjCIndirectCopyRestoreExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCEncodeExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCEncodeExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCEncodeExpr(S)
    @ccall libclangex.clang_Stmt_isObjCEncodeExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCDictionaryLiteral(S)
    @ccall libclangex.clang_Stmt_castToObjCDictionaryLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCDictionaryLiteral(S)
    @ccall libclangex.clang_Stmt_isObjCDictionaryLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCBoxedExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCBoxedExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCBoxedExpr(S)
    @ccall libclangex.clang_Stmt_isObjCBoxedExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCBoolLiteralExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCBoolLiteralExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCBoolLiteralExpr(S)
    @ccall libclangex.clang_Stmt_isObjCBoolLiteralExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAvailabilityCheckExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCAvailabilityCheckExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAvailabilityCheckExpr(S)
    @ccall libclangex.clang_Stmt_isObjCAvailabilityCheckExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCArrayLiteral(S)
    @ccall libclangex.clang_Stmt_castToObjCArrayLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCArrayLiteral(S)
    @ccall libclangex.clang_Stmt_isObjCArrayLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPIteratorExpr(S)
    @ccall libclangex.clang_Stmt_castToOMPIteratorExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPIteratorExpr(S)
    @ccall libclangex.clang_Stmt_isOMPIteratorExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPArrayShapingExpr(S)
    @ccall libclangex.clang_Stmt_castToOMPArrayShapingExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPArrayShapingExpr(S)
    @ccall libclangex.clang_Stmt_isOMPArrayShapingExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPArraySectionExpr(S)
    @ccall libclangex.clang_Stmt_castToOMPArraySectionExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPArraySectionExpr(S)
    @ccall libclangex.clang_Stmt_isOMPArraySectionExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToNoInitExpr(S)
    @ccall libclangex.clang_Stmt_castToNoInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isNoInitExpr(S)
    @ccall libclangex.clang_Stmt_isNoInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToMemberExpr(S)
    @ccall libclangex.clang_Stmt_castToMemberExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isMemberExpr(S)
    @ccall libclangex.clang_Stmt_isMemberExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToMatrixSubscriptExpr(S)
    @ccall libclangex.clang_Stmt_castToMatrixSubscriptExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isMatrixSubscriptExpr(S)
    @ccall libclangex.clang_Stmt_isMatrixSubscriptExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToMaterializeTemporaryExpr(S)
    @ccall libclangex.clang_Stmt_castToMaterializeTemporaryExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isMaterializeTemporaryExpr(S)
    @ccall libclangex.clang_Stmt_isMaterializeTemporaryExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToMSPropertySubscriptExpr(S)
    @ccall libclangex.clang_Stmt_castToMSPropertySubscriptExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isMSPropertySubscriptExpr(S)
    @ccall libclangex.clang_Stmt_isMSPropertySubscriptExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToMSPropertyRefExpr(S)
    @ccall libclangex.clang_Stmt_castToMSPropertyRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isMSPropertyRefExpr(S)
    @ccall libclangex.clang_Stmt_isMSPropertyRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToLambdaExpr(S)
    @ccall libclangex.clang_Stmt_castToLambdaExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isLambdaExpr(S)
    @ccall libclangex.clang_Stmt_isLambdaExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToIntegerLiteral(S)
    @ccall libclangex.clang_Stmt_castToIntegerLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isIntegerLiteral(S)
    @ccall libclangex.clang_Stmt_isIntegerLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToInitListExpr(S)
    @ccall libclangex.clang_Stmt_castToInitListExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isInitListExpr(S)
    @ccall libclangex.clang_Stmt_isInitListExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToImplicitValueInitExpr(S)
    @ccall libclangex.clang_Stmt_castToImplicitValueInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isImplicitValueInitExpr(S)
    @ccall libclangex.clang_Stmt_isImplicitValueInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToImaginaryLiteral(S)
    @ccall libclangex.clang_Stmt_castToImaginaryLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isImaginaryLiteral(S)
    @ccall libclangex.clang_Stmt_isImaginaryLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToGenericSelectionExpr(S)
    @ccall libclangex.clang_Stmt_castToGenericSelectionExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isGenericSelectionExpr(S)
    @ccall libclangex.clang_Stmt_isGenericSelectionExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToGNUNullExpr(S)
    @ccall libclangex.clang_Stmt_castToGNUNullExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isGNUNullExpr(S)
    @ccall libclangex.clang_Stmt_isGNUNullExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToFunctionParmPackExpr(S)
    @ccall libclangex.clang_Stmt_castToFunctionParmPackExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isFunctionParmPackExpr(S)
    @ccall libclangex.clang_Stmt_isFunctionParmPackExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToFullExpr(S)
    @ccall libclangex.clang_Stmt_castToFullExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isFullExpr(S)
    @ccall libclangex.clang_Stmt_isFullExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToExprWithCleanups(S)
    @ccall libclangex.clang_Stmt_castToExprWithCleanups(S::CXStmt)::CXStmt
end

function clang_Stmt_isExprWithCleanups(S)
    @ccall libclangex.clang_Stmt_isExprWithCleanups(S::CXStmt)::Bool
end

function clang_Stmt_castToConstantExpr(S)
    @ccall libclangex.clang_Stmt_castToConstantExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isConstantExpr(S)
    @ccall libclangex.clang_Stmt_isConstantExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToFloatingLiteral(S)
    @ccall libclangex.clang_Stmt_castToFloatingLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isFloatingLiteral(S)
    @ccall libclangex.clang_Stmt_isFloatingLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToFixedPointLiteral(S)
    @ccall libclangex.clang_Stmt_castToFixedPointLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isFixedPointLiteral(S)
    @ccall libclangex.clang_Stmt_isFixedPointLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToExtVectorElementExpr(S)
    @ccall libclangex.clang_Stmt_castToExtVectorElementExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isExtVectorElementExpr(S)
    @ccall libclangex.clang_Stmt_isExtVectorElementExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToExpressionTraitExpr(S)
    @ccall libclangex.clang_Stmt_castToExpressionTraitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isExpressionTraitExpr(S)
    @ccall libclangex.clang_Stmt_isExpressionTraitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToDesignatedInitUpdateExpr(S)
    @ccall libclangex.clang_Stmt_castToDesignatedInitUpdateExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isDesignatedInitUpdateExpr(S)
    @ccall libclangex.clang_Stmt_isDesignatedInitUpdateExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToDesignatedInitExpr(S)
    @ccall libclangex.clang_Stmt_castToDesignatedInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isDesignatedInitExpr(S)
    @ccall libclangex.clang_Stmt_isDesignatedInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToDependentScopeDeclRefExpr(S)
    @ccall libclangex.clang_Stmt_castToDependentScopeDeclRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isDependentScopeDeclRefExpr(S)
    @ccall libclangex.clang_Stmt_isDependentScopeDeclRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToDependentCoawaitExpr(S)
    @ccall libclangex.clang_Stmt_castToDependentCoawaitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isDependentCoawaitExpr(S)
    @ccall libclangex.clang_Stmt_isDependentCoawaitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToDeclRefExpr(S)
    @ccall libclangex.clang_Stmt_castToDeclRefExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isDeclRefExpr(S)
    @ccall libclangex.clang_Stmt_isDeclRefExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCoroutineSuspendExpr(S)
    @ccall libclangex.clang_Stmt_castToCoroutineSuspendExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCoroutineSuspendExpr(S)
    @ccall libclangex.clang_Stmt_isCoroutineSuspendExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCoyieldExpr(S)
    @ccall libclangex.clang_Stmt_castToCoyieldExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCoyieldExpr(S)
    @ccall libclangex.clang_Stmt_isCoyieldExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCoawaitExpr(S)
    @ccall libclangex.clang_Stmt_castToCoawaitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCoawaitExpr(S)
    @ccall libclangex.clang_Stmt_isCoawaitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToConvertVectorExpr(S)
    @ccall libclangex.clang_Stmt_castToConvertVectorExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isConvertVectorExpr(S)
    @ccall libclangex.clang_Stmt_isConvertVectorExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToConceptSpecializationExpr(S)
    @ccall libclangex.clang_Stmt_castToConceptSpecializationExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isConceptSpecializationExpr(S)
    @ccall libclangex.clang_Stmt_isConceptSpecializationExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCompoundLiteralExpr(S)
    @ccall libclangex.clang_Stmt_castToCompoundLiteralExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCompoundLiteralExpr(S)
    @ccall libclangex.clang_Stmt_isCompoundLiteralExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToChooseExpr(S)
    @ccall libclangex.clang_Stmt_castToChooseExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isChooseExpr(S)
    @ccall libclangex.clang_Stmt_isChooseExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCharacterLiteral(S)
    @ccall libclangex.clang_Stmt_castToCharacterLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isCharacterLiteral(S)
    @ccall libclangex.clang_Stmt_isCharacterLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCastExpr(S)
    @ccall libclangex.clang_Stmt_isCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToImplicitCastExpr(S)
    @ccall libclangex.clang_Stmt_castToImplicitCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isImplicitCastExpr(S)
    @ccall libclangex.clang_Stmt_isImplicitCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToExplicitCastExpr(S)
    @ccall libclangex.clang_Stmt_castToExplicitCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isExplicitCastExpr(S)
    @ccall libclangex.clang_Stmt_isExplicitCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCBridgedCastExpr(S)
    @ccall libclangex.clang_Stmt_castToObjCBridgedCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCBridgedCastExpr(S)
    @ccall libclangex.clang_Stmt_isObjCBridgedCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXNamedCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXNamedCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXNamedCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXNamedCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXStaticCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXStaticCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXStaticCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXStaticCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXReinterpretCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXReinterpretCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXReinterpretCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXReinterpretCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXDynamicCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXDynamicCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXDynamicCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXDynamicCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXConstCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXConstCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXConstCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXConstCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXAddrspaceCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXAddrspaceCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXAddrspaceCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXAddrspaceCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXFunctionalCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXFunctionalCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXFunctionalCastExpr(S)
    @ccall libclangex.clang_Stmt_isCXXFunctionalCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCStyleCastExpr(S)
    @ccall libclangex.clang_Stmt_castToCStyleCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCStyleCastExpr(S)
    @ccall libclangex.clang_Stmt_isCStyleCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToBuiltinBitCastExpr(S)
    @ccall libclangex.clang_Stmt_castToBuiltinBitCastExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isBuiltinBitCastExpr(S)
    @ccall libclangex.clang_Stmt_isBuiltinBitCastExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCallExpr(S)
    @ccall libclangex.clang_Stmt_castToCallExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCallExpr(S)
    @ccall libclangex.clang_Stmt_isCallExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToUserDefinedLiteral(S)
    @ccall libclangex.clang_Stmt_castToUserDefinedLiteral(S::CXStmt)::CXStmt
end

function clang_Stmt_isUserDefinedLiteral(S)
    @ccall libclangex.clang_Stmt_isUserDefinedLiteral(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXOperatorCallExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXOperatorCallExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXOperatorCallExpr(S)
    @ccall libclangex.clang_Stmt_isCXXOperatorCallExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXMemberCallExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXMemberCallExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXMemberCallExpr(S)
    @ccall libclangex.clang_Stmt_isCXXMemberCallExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCUDAKernelCallExpr(S)
    @ccall libclangex.clang_Stmt_castToCUDAKernelCallExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCUDAKernelCallExpr(S)
    @ccall libclangex.clang_Stmt_isCUDAKernelCallExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXUuidofExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXUuidofExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXUuidofExpr(S)
    @ccall libclangex.clang_Stmt_isCXXUuidofExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXUnresolvedConstructExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXUnresolvedConstructExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXUnresolvedConstructExpr(S)
    @ccall libclangex.clang_Stmt_isCXXUnresolvedConstructExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXTypeidExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXTypeidExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXTypeidExpr(S)
    @ccall libclangex.clang_Stmt_isCXXTypeidExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXThrowExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXThrowExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXThrowExpr(S)
    @ccall libclangex.clang_Stmt_isCXXThrowExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXThisExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXThisExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXThisExpr(S)
    @ccall libclangex.clang_Stmt_isCXXThisExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXStdInitializerListExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXStdInitializerListExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXStdInitializerListExpr(S)
    @ccall libclangex.clang_Stmt_isCXXStdInitializerListExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXScalarValueInitExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXScalarValueInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXScalarValueInitExpr(S)
    @ccall libclangex.clang_Stmt_isCXXScalarValueInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXRewrittenBinaryOperator(S)
    @ccall libclangex.clang_Stmt_castToCXXRewrittenBinaryOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXRewrittenBinaryOperator(S)
    @ccall libclangex.clang_Stmt_isCXXRewrittenBinaryOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXPseudoDestructorExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXPseudoDestructorExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXPseudoDestructorExpr(S)
    @ccall libclangex.clang_Stmt_isCXXPseudoDestructorExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXParenListInitExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXParenListInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXParenListInitExpr(S)
    @ccall libclangex.clang_Stmt_isCXXParenListInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXNullPtrLiteralExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXNullPtrLiteralExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXNullPtrLiteralExpr(S)
    @ccall libclangex.clang_Stmt_isCXXNullPtrLiteralExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXNoexceptExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXNoexceptExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXNoexceptExpr(S)
    @ccall libclangex.clang_Stmt_isCXXNoexceptExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXNewExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXNewExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXNewExpr(S)
    @ccall libclangex.clang_Stmt_isCXXNewExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXInheritedCtorInitExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXInheritedCtorInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXInheritedCtorInitExpr(S)
    @ccall libclangex.clang_Stmt_isCXXInheritedCtorInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXFoldExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXFoldExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXFoldExpr(S)
    @ccall libclangex.clang_Stmt_isCXXFoldExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXDependentScopeMemberExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXDependentScopeMemberExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXDependentScopeMemberExpr(S)
    @ccall libclangex.clang_Stmt_isCXXDependentScopeMemberExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXDeleteExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXDeleteExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXDeleteExpr(S)
    @ccall libclangex.clang_Stmt_isCXXDeleteExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXDefaultInitExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXDefaultInitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXDefaultInitExpr(S)
    @ccall libclangex.clang_Stmt_isCXXDefaultInitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXDefaultArgExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXDefaultArgExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXDefaultArgExpr(S)
    @ccall libclangex.clang_Stmt_isCXXDefaultArgExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXConstructExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXConstructExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXConstructExpr(S)
    @ccall libclangex.clang_Stmt_isCXXConstructExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXTemporaryObjectExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXTemporaryObjectExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXTemporaryObjectExpr(S)
    @ccall libclangex.clang_Stmt_isCXXTemporaryObjectExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXBoolLiteralExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXBoolLiteralExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXBoolLiteralExpr(S)
    @ccall libclangex.clang_Stmt_isCXXBoolLiteralExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXBindTemporaryExpr(S)
    @ccall libclangex.clang_Stmt_castToCXXBindTemporaryExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXBindTemporaryExpr(S)
    @ccall libclangex.clang_Stmt_isCXXBindTemporaryExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToBlockExpr(S)
    @ccall libclangex.clang_Stmt_castToBlockExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isBlockExpr(S)
    @ccall libclangex.clang_Stmt_isBlockExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToBinaryOperator(S)
    @ccall libclangex.clang_Stmt_castToBinaryOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isBinaryOperator(S)
    @ccall libclangex.clang_Stmt_isBinaryOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToCompoundAssignOperator(S)
    @ccall libclangex.clang_Stmt_castToCompoundAssignOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isCompoundAssignOperator(S)
    @ccall libclangex.clang_Stmt_isCompoundAssignOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToAtomicExpr(S)
    @ccall libclangex.clang_Stmt_castToAtomicExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isAtomicExpr(S)
    @ccall libclangex.clang_Stmt_isAtomicExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToAsTypeExpr(S)
    @ccall libclangex.clang_Stmt_castToAsTypeExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isAsTypeExpr(S)
    @ccall libclangex.clang_Stmt_isAsTypeExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToArrayTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_castToArrayTypeTraitExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isArrayTypeTraitExpr(S)
    @ccall libclangex.clang_Stmt_isArrayTypeTraitExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToArraySubscriptExpr(S)
    @ccall libclangex.clang_Stmt_castToArraySubscriptExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isArraySubscriptExpr(S)
    @ccall libclangex.clang_Stmt_isArraySubscriptExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToArrayInitLoopExpr(S)
    @ccall libclangex.clang_Stmt_castToArrayInitLoopExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isArrayInitLoopExpr(S)
    @ccall libclangex.clang_Stmt_isArrayInitLoopExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToArrayInitIndexExpr(S)
    @ccall libclangex.clang_Stmt_castToArrayInitIndexExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isArrayInitIndexExpr(S)
    @ccall libclangex.clang_Stmt_isArrayInitIndexExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToAddrLabelExpr(S)
    @ccall libclangex.clang_Stmt_castToAddrLabelExpr(S::CXStmt)::CXStmt
end

function clang_Stmt_isAddrLabelExpr(S)
    @ccall libclangex.clang_Stmt_isAddrLabelExpr(S::CXStmt)::Bool
end

function clang_Stmt_castToAbstractConditionalOperator(S)
    @ccall libclangex.clang_Stmt_castToAbstractConditionalOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isAbstractConditionalOperator(S)
    @ccall libclangex.clang_Stmt_isAbstractConditionalOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToConditionalOperator(S)
    @ccall libclangex.clang_Stmt_castToConditionalOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isConditionalOperator(S)
    @ccall libclangex.clang_Stmt_isConditionalOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToBinaryConditionalOperator(S)
    @ccall libclangex.clang_Stmt_castToBinaryConditionalOperator(S::CXStmt)::CXStmt
end

function clang_Stmt_isBinaryConditionalOperator(S)
    @ccall libclangex.clang_Stmt_isBinaryConditionalOperator(S::CXStmt)::Bool
end

function clang_Stmt_castToAttributedStmt(S)
    @ccall libclangex.clang_Stmt_castToAttributedStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isAttributedStmt(S)
    @ccall libclangex.clang_Stmt_isAttributedStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSwitchStmt(S)
    @ccall libclangex.clang_Stmt_castToSwitchStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isSwitchStmt(S)
    @ccall libclangex.clang_Stmt_isSwitchStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSwitchCase(S)
    @ccall libclangex.clang_Stmt_castToSwitchCase(S::CXStmt)::CXStmt
end

function clang_Stmt_isSwitchCase(S)
    @ccall libclangex.clang_Stmt_isSwitchCase(S::CXStmt)::Bool
end

function clang_Stmt_castToDefaultStmt(S)
    @ccall libclangex.clang_Stmt_castToDefaultStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isDefaultStmt(S)
    @ccall libclangex.clang_Stmt_isDefaultStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCaseStmt(S)
    @ccall libclangex.clang_Stmt_castToCaseStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCaseStmt(S)
    @ccall libclangex.clang_Stmt_isCaseStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSEHTryStmt(S)
    @ccall libclangex.clang_Stmt_castToSEHTryStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isSEHTryStmt(S)
    @ccall libclangex.clang_Stmt_isSEHTryStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSEHLeaveStmt(S)
    @ccall libclangex.clang_Stmt_castToSEHLeaveStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isSEHLeaveStmt(S)
    @ccall libclangex.clang_Stmt_isSEHLeaveStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSEHFinallyStmt(S)
    @ccall libclangex.clang_Stmt_castToSEHFinallyStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isSEHFinallyStmt(S)
    @ccall libclangex.clang_Stmt_isSEHFinallyStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToSEHExceptStmt(S)
    @ccall libclangex.clang_Stmt_castToSEHExceptStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isSEHExceptStmt(S)
    @ccall libclangex.clang_Stmt_isSEHExceptStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToReturnStmt(S)
    @ccall libclangex.clang_Stmt_castToReturnStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isReturnStmt(S)
    @ccall libclangex.clang_Stmt_isReturnStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCForCollectionStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCForCollectionStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCForCollectionStmt(S)
    @ccall libclangex.clang_Stmt_isObjCForCollectionStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAutoreleasePoolStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAutoreleasePoolStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAutoreleasePoolStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAutoreleasePoolStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAtTryStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAtTryStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAtTryStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAtTryStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAtThrowStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAtThrowStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAtThrowStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAtThrowStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAtSynchronizedStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAtSynchronizedStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAtSynchronizedStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAtSynchronizedStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAtFinallyStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAtFinallyStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAtFinallyStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAtFinallyStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToObjCAtCatchStmt(S)
    @ccall libclangex.clang_Stmt_castToObjCAtCatchStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isObjCAtCatchStmt(S)
    @ccall libclangex.clang_Stmt_isObjCAtCatchStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPExecutableDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPExecutableDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPExecutableDirective(S)
    @ccall libclangex.clang_Stmt_isOMPExecutableDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskyieldDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskyieldDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskyieldDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskyieldDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskwaitDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskwaitDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskwaitDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskwaitDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskgroupDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskgroupDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskgroupDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskgroupDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetUpdateDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetUpdateDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetUpdateDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetUpdateDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetParallelForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetParallelForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetParallelForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetParallelForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetParallelDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetParallelDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetParallelDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetParallelDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetExitDataDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetExitDataDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetExitDataDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetExitDataDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetEnterDataDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetEnterDataDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetEnterDataDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetEnterDataDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetDataDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetDataDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetDataDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetDataDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPSingleDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPSingleDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPSingleDirective(S)
    @ccall libclangex.clang_Stmt_isOMPSingleDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPSectionsDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPSectionsDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPSectionsDirective(S)
    @ccall libclangex.clang_Stmt_isOMPSectionsDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPSectionDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPSectionDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPSectionDirective(S)
    @ccall libclangex.clang_Stmt_isOMPSectionDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPScopeDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPScopeDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPScopeDirective(S)
    @ccall libclangex.clang_Stmt_isOMPScopeDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPScanDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPScanDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPScanDirective(S)
    @ccall libclangex.clang_Stmt_isOMPScanDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelSectionsDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelSectionsDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelSectionsDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelSectionsDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMasterDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMasterDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMasterDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMasterDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMaskedDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMaskedDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMaskedDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMaskedDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPOrderedDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPOrderedDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPOrderedDirective(S)
    @ccall libclangex.clang_Stmt_isOMPOrderedDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMetaDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMetaDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMetaDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMetaDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMasterDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMasterDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMasterDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMasterDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMaskedDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMaskedDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMaskedDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMaskedDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPLoopBasedDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPLoopBasedDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPLoopBasedDirective(S)
    @ccall libclangex.clang_Stmt_isOMPLoopBasedDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPLoopTransformationDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPLoopTransformationDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPLoopTransformationDirective(S)
    @ccall libclangex.clang_Stmt_isOMPLoopTransformationDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPUnrollDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPUnrollDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPUnrollDirective(S)
    @ccall libclangex.clang_Stmt_isOMPUnrollDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTileDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTileDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTileDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTileDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsGenericLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsGenericLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsDistributeSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsDistributeSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsDistributeParallelForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsDistributeParallelForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsDistributeParallelForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsDistributeParallelForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTeamsDistributeDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTeamsDistributeDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTeamsDistributeDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTeamsDistributeDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskLoopSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskLoopSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTaskLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTaskLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsGenericLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsGenericLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsDistributeSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsDistributeSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsDistributeParallelForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsDistributeParallelForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsDistributeParallelForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsDistributeParallelForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetTeamsDistributeDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetTeamsDistributeDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetTeamsDistributeDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetTeamsDistributeDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetParallelGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetParallelGenericLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetParallelGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetParallelGenericLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPTargetParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPTargetParallelForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPTargetParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPTargetParallelForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMasterTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMasterTaskLoopSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMasterTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMasterTaskLoopSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMasterTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMasterTaskLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMasterTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMasterTaskLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMaskedTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMaskedTaskLoopSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMaskedTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMaskedTaskLoopSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelMaskedTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelMaskedTaskLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelMaskedTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelMaskedTaskLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelGenericLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelGenericLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPParallelForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPParallelForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPParallelForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPParallelForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMasterTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMasterTaskLoopSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMasterTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMasterTaskLoopSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMasterTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMasterTaskLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMasterTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMasterTaskLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMaskedTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMaskedTaskLoopSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMaskedTaskLoopSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMaskedTaskLoopSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPMaskedTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPMaskedTaskLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPMaskedTaskLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPMaskedTaskLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPGenericLoopDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPGenericLoopDirective(S)
    @ccall libclangex.clang_Stmt_isOMPGenericLoopDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDistributeSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDistributeSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDistributeSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDistributeParallelForSimdDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDistributeParallelForSimdDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDistributeParallelForSimdDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDistributeParallelForDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDistributeParallelForDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDistributeParallelForDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDistributeDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDistributeDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDistributeDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDistributeDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPInteropDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPInteropDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPInteropDirective(S)
    @ccall libclangex.clang_Stmt_isOMPInteropDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPFlushDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPFlushDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPFlushDirective(S)
    @ccall libclangex.clang_Stmt_isOMPFlushDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPErrorDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPErrorDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPErrorDirective(S)
    @ccall libclangex.clang_Stmt_isOMPErrorDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDispatchDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDispatchDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDispatchDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDispatchDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPDepobjDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPDepobjDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPDepobjDirective(S)
    @ccall libclangex.clang_Stmt_isOMPDepobjDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPCriticalDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPCriticalDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPCriticalDirective(S)
    @ccall libclangex.clang_Stmt_isOMPCriticalDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPCancellationPointDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPCancellationPointDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPCancellationPointDirective(S)
    @ccall libclangex.clang_Stmt_isOMPCancellationPointDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPCancelDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPCancelDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPCancelDirective(S)
    @ccall libclangex.clang_Stmt_isOMPCancelDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPBarrierDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPBarrierDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPBarrierDirective(S)
    @ccall libclangex.clang_Stmt_isOMPBarrierDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPAtomicDirective(S)
    @ccall libclangex.clang_Stmt_castToOMPAtomicDirective(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPAtomicDirective(S)
    @ccall libclangex.clang_Stmt_isOMPAtomicDirective(S::CXStmt)::Bool
end

function clang_Stmt_castToOMPCanonicalLoop(S)
    @ccall libclangex.clang_Stmt_castToOMPCanonicalLoop(S::CXStmt)::CXStmt
end

function clang_Stmt_isOMPCanonicalLoop(S)
    @ccall libclangex.clang_Stmt_isOMPCanonicalLoop(S::CXStmt)::Bool
end

function clang_Stmt_castToNullStmt(S)
    @ccall libclangex.clang_Stmt_castToNullStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isNullStmt(S)
    @ccall libclangex.clang_Stmt_isNullStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToMSDependentExistsStmt(S)
    @ccall libclangex.clang_Stmt_castToMSDependentExistsStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isMSDependentExistsStmt(S)
    @ccall libclangex.clang_Stmt_isMSDependentExistsStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToIndirectGotoStmt(S)
    @ccall libclangex.clang_Stmt_castToIndirectGotoStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isIndirectGotoStmt(S)
    @ccall libclangex.clang_Stmt_isIndirectGotoStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToIfStmt(S)
    @ccall libclangex.clang_Stmt_castToIfStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isIfStmt(S)
    @ccall libclangex.clang_Stmt_isIfStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToGotoStmt(S)
    @ccall libclangex.clang_Stmt_castToGotoStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isGotoStmt(S)
    @ccall libclangex.clang_Stmt_isGotoStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToForStmt(S)
    @ccall libclangex.clang_Stmt_castToForStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isForStmt(S)
    @ccall libclangex.clang_Stmt_isForStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToDoStmt(S)
    @ccall libclangex.clang_Stmt_castToDoStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isDoStmt(S)
    @ccall libclangex.clang_Stmt_isDoStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToDeclStmt(S)
    @ccall libclangex.clang_Stmt_castToDeclStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isDeclStmt(S)
    @ccall libclangex.clang_Stmt_isDeclStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCoroutineBodyStmt(S)
    @ccall libclangex.clang_Stmt_castToCoroutineBodyStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCoroutineBodyStmt(S)
    @ccall libclangex.clang_Stmt_isCoroutineBodyStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCoreturnStmt(S)
    @ccall libclangex.clang_Stmt_castToCoreturnStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCoreturnStmt(S)
    @ccall libclangex.clang_Stmt_isCoreturnStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToContinueStmt(S)
    @ccall libclangex.clang_Stmt_castToContinueStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isContinueStmt(S)
    @ccall libclangex.clang_Stmt_isContinueStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCompoundStmt(S)
    @ccall libclangex.clang_Stmt_castToCompoundStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCompoundStmt(S)
    @ccall libclangex.clang_Stmt_isCompoundStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCapturedStmt(S)
    @ccall libclangex.clang_Stmt_castToCapturedStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCapturedStmt(S)
    @ccall libclangex.clang_Stmt_isCapturedStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXTryStmt(S)
    @ccall libclangex.clang_Stmt_castToCXXTryStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXTryStmt(S)
    @ccall libclangex.clang_Stmt_isCXXTryStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXForRangeStmt(S)
    @ccall libclangex.clang_Stmt_castToCXXForRangeStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXForRangeStmt(S)
    @ccall libclangex.clang_Stmt_isCXXForRangeStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToCXXCatchStmt(S)
    @ccall libclangex.clang_Stmt_castToCXXCatchStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isCXXCatchStmt(S)
    @ccall libclangex.clang_Stmt_isCXXCatchStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToBreakStmt(S)
    @ccall libclangex.clang_Stmt_castToBreakStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isBreakStmt(S)
    @ccall libclangex.clang_Stmt_isBreakStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToAsmStmt(S)
    @ccall libclangex.clang_Stmt_castToAsmStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isAsmStmt(S)
    @ccall libclangex.clang_Stmt_isAsmStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToMSAsmStmt(S)
    @ccall libclangex.clang_Stmt_castToMSAsmStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isMSAsmStmt(S)
    @ccall libclangex.clang_Stmt_isMSAsmStmt(S::CXStmt)::Bool
end

function clang_Stmt_castToGCCAsmStmt(S)
    @ccall libclangex.clang_Stmt_castToGCCAsmStmt(S::CXStmt)::CXStmt
end

function clang_Stmt_isGCCAsmStmt(S)
    @ccall libclangex.clang_Stmt_isGCCAsmStmt(S::CXStmt)::Bool
end

function clang_Stmt_getStmtClass(S)
    @ccall libclangex.clang_Stmt_getStmtClass(S::CXStmt)::CXStmtClass
end

function clang_Stmt_getStmtClassName(S)
    @ccall libclangex.clang_Stmt_getStmtClassName(S::CXStmt)::Ptr{Cchar}
end

function clang_Stmt_getBeginLoc(S)
    @ccall libclangex.clang_Stmt_getBeginLoc(S::CXStmt)::CXSourceLocation_
end

function clang_Stmt_getEndLoc(S)
    @ccall libclangex.clang_Stmt_getEndLoc(S::CXStmt)::CXSourceLocation_
end

function clang_Stmt_getSourceRange(S)
    @ccall libclangex.clang_Stmt_getSourceRange(S::CXStmt)::CXSourceRange_
end

function clang_Stmt_dump(S)
    @ccall libclangex.clang_Stmt_dump(S::CXStmt)::Cvoid
end

function clang_Stmt_getNumChildren(S)
    @ccall libclangex.clang_Stmt_getNumChildren(S::CXStmt)::Csize_t
end

function clang_Stmt_getChildren(S, Buf)
    @ccall libclangex.clang_Stmt_getChildren(S::CXStmt, Buf::Ptr{CXStmt})::Cvoid
end

function clang_DeclStmt_isSingleDecl(DS)
    @ccall libclangex.clang_DeclStmt_isSingleDecl(DS::CXDeclStmt)::Bool
end

function clang_DeclStmt_getSingleDecl(DS)
    @ccall libclangex.clang_DeclStmt_getSingleDecl(DS::CXDeclStmt)::CXDecl
end

function clang_DeclStmt_getNumDecls(DS)
    @ccall libclangex.clang_DeclStmt_getNumDecls(DS::CXDeclStmt)::Csize_t
end

function clang_DeclStmt_getDecls(DS, Buf)
    @ccall libclangex.clang_DeclStmt_getDecls(DS::CXDeclStmt, Buf::Ptr{CXDecl})::Cvoid
end

function clang_CompoundStmt_size(CS)
    @ccall libclangex.clang_CompoundStmt_size(CS::CXCompoundStmt)::Cuint
end

function clang_CompoundStmt_body_front(CS)
    @ccall libclangex.clang_CompoundStmt_body_front(CS::CXCompoundStmt)::CXStmt
end

function clang_CompoundStmt_body_back(CS)
    @ccall libclangex.clang_CompoundStmt_body_back(CS::CXCompoundStmt)::CXStmt
end

function clang_CompoundStmt_getLBracLoc(CS)
    @ccall libclangex.clang_CompoundStmt_getLBracLoc(CS::CXCompoundStmt)::CXSourceLocation_
end

function clang_CompoundStmt_getRBracLoc(CS)
    @ccall libclangex.clang_CompoundStmt_getRBracLoc(CS::CXCompoundStmt)::CXSourceLocation_
end

function clang_SwitchCase_getNextSwitchCase(SC)
    @ccall libclangex.clang_SwitchCase_getNextSwitchCase(SC::CXSwitchCase)::CXSwitchCase
end

function clang_SwitchCase_getSubStmt(SC)
    @ccall libclangex.clang_SwitchCase_getSubStmt(SC::CXSwitchCase)::CXStmt
end

function clang_CaseStmt_getLHS(CS)
    @ccall libclangex.clang_CaseStmt_getLHS(CS::CXCaseStmt)::CXExpr
end

function clang_CaseStmt_getRHS(CS)
    @ccall libclangex.clang_CaseStmt_getRHS(CS::CXCaseStmt)::CXExpr
end

function clang_LabelStmt_getName(LS)
    @ccall libclangex.clang_LabelStmt_getName(LS::CXLabelStmt)::Ptr{Cchar}
end

function clang_LabelStmt_getDecl(LS)
    @ccall libclangex.clang_LabelStmt_getDecl(LS::CXLabelStmt)::CXLabelDecl
end

function clang_LabelStmt_getSubStmt(LS)
    @ccall libclangex.clang_LabelStmt_getSubStmt(LS::CXLabelStmt)::CXStmt
end

function clang_IfStmt_getCond(IS)
    @ccall libclangex.clang_IfStmt_getCond(IS::CXIfStmt)::CXExpr
end

function clang_IfStmt_getThen(IS)
    @ccall libclangex.clang_IfStmt_getThen(IS::CXIfStmt)::CXStmt
end

function clang_IfStmt_getElse(IS)
    @ccall libclangex.clang_IfStmt_getElse(IS::CXIfStmt)::CXStmt
end

function clang_IfStmt_hasElseStorage(IS)
    @ccall libclangex.clang_IfStmt_hasElseStorage(IS::CXIfStmt)::Bool
end

function clang_IfStmt_hasInitStorage(IS)
    @ccall libclangex.clang_IfStmt_hasInitStorage(IS::CXIfStmt)::Bool
end

function clang_IfStmt_hasVarStorage(IS)
    @ccall libclangex.clang_IfStmt_hasVarStorage(IS::CXIfStmt)::Bool
end

function clang_IfStmt_getInit(IS)
    @ccall libclangex.clang_IfStmt_getInit(IS::CXIfStmt)::CXStmt
end

function clang_IfStmt_getConditionVariable(IS)
    @ccall libclangex.clang_IfStmt_getConditionVariable(IS::CXIfStmt)::CXVarDecl
end

function clang_IfStmt_getIfLoc(IS)
    @ccall libclangex.clang_IfStmt_getIfLoc(IS::CXIfStmt)::CXSourceLocation_
end

function clang_SwitchStmt_getCond(SS)
    @ccall libclangex.clang_SwitchStmt_getCond(SS::CXSwitchStmt)::CXExpr
end

function clang_SwitchStmt_getBody(SS)
    @ccall libclangex.clang_SwitchStmt_getBody(SS::CXSwitchStmt)::CXStmt
end

function clang_SwitchStmt_getSwitchCaseList(SS)
    @ccall libclangex.clang_SwitchStmt_getSwitchCaseList(SS::CXSwitchStmt)::CXSwitchCase
end

function clang_SwitchStmt_isAllEnumCasesCovered(SS)
    @ccall libclangex.clang_SwitchStmt_isAllEnumCasesCovered(SS::CXSwitchStmt)::Bool
end

function clang_WhileStmt_getCond(WS)
    @ccall libclangex.clang_WhileStmt_getCond(WS::CXWhileStmt)::CXExpr
end

function clang_WhileStmt_getBody(WS)
    @ccall libclangex.clang_WhileStmt_getBody(WS::CXWhileStmt)::CXStmt
end

function clang_WhileStmt_getConditionVariable(WS)
    @ccall libclangex.clang_WhileStmt_getConditionVariable(WS::CXWhileStmt)::CXVarDecl
end

function clang_WhileStmt_getWhileLoc(WS)
    @ccall libclangex.clang_WhileStmt_getWhileLoc(WS::CXWhileStmt)::CXSourceLocation_
end

function clang_DoStmt_getCond(DS)
    @ccall libclangex.clang_DoStmt_getCond(DS::CXDoStmt)::CXExpr
end

function clang_DoStmt_getBody(DS)
    @ccall libclangex.clang_DoStmt_getBody(DS::CXDoStmt)::CXStmt
end

function clang_DoStmt_getDoLoc(DS)
    @ccall libclangex.clang_DoStmt_getDoLoc(DS::CXDoStmt)::CXSourceLocation_
end

function clang_DoStmt_getWhileLoc(DS)
    @ccall libclangex.clang_DoStmt_getWhileLoc(DS::CXDoStmt)::CXSourceLocation_
end

function clang_ForStmt_getInit(FS)
    @ccall libclangex.clang_ForStmt_getInit(FS::CXForStmt)::CXStmt
end

function clang_ForStmt_getCond(FS)
    @ccall libclangex.clang_ForStmt_getCond(FS::CXForStmt)::CXExpr
end

function clang_ForStmt_getInc(FS)
    @ccall libclangex.clang_ForStmt_getInc(FS::CXForStmt)::CXExpr
end

function clang_ForStmt_getBody(FS)
    @ccall libclangex.clang_ForStmt_getBody(FS::CXForStmt)::CXStmt
end

function clang_ForStmt_getConditionVariable(FS)
    @ccall libclangex.clang_ForStmt_getConditionVariable(FS::CXForStmt)::CXVarDecl
end

function clang_ForStmt_getForLoc(FS)
    @ccall libclangex.clang_ForStmt_getForLoc(FS::CXForStmt)::CXSourceLocation_
end

function clang_GotoStmt_getLabel(GS)
    @ccall libclangex.clang_GotoStmt_getLabel(GS::CXGotoStmt)::CXLabelDecl
end

function clang_GotoStmt_getGotoLoc(GS)
    @ccall libclangex.clang_GotoStmt_getGotoLoc(GS::CXGotoStmt)::CXSourceLocation_
end

function clang_ReturnStmt_getRetValue(RS)
    @ccall libclangex.clang_ReturnStmt_getRetValue(RS::CXReturnStmt)::CXExpr
end

function clang_IfStmt_getElseLoc(S)
    @ccall libclangex.clang_IfStmt_getElseLoc(S::CXIfStmt)::CXSourceLocation_
end

function clang_IfStmt_isConsteval(S)
    @ccall libclangex.clang_IfStmt_isConsteval(S::CXIfStmt)::Bool
end

function clang_IfStmt_isNonNegatedConsteval(S)
    @ccall libclangex.clang_IfStmt_isNonNegatedConsteval(S::CXIfStmt)::Bool
end

function clang_IfStmt_isNegatedConsteval(S)
    @ccall libclangex.clang_IfStmt_isNegatedConsteval(S::CXIfStmt)::Bool
end

function clang_IfStmt_isConstexpr(S)
    @ccall libclangex.clang_IfStmt_isConstexpr(S::CXIfStmt)::Bool
end

function clang_IfStmt_isObjCAvailabilityCheck(S)
    @ccall libclangex.clang_IfStmt_isObjCAvailabilityCheck(S::CXIfStmt)::Bool
end

function clang_IfStmt_getLParenLoc(S)
    @ccall libclangex.clang_IfStmt_getLParenLoc(S::CXIfStmt)::CXSourceLocation_
end

function clang_IfStmt_getRParenLoc(S)
    @ccall libclangex.clang_IfStmt_getRParenLoc(S::CXIfStmt)::CXSourceLocation_
end

function clang_SwitchStmt_hasInitStorage(S)
    @ccall libclangex.clang_SwitchStmt_hasInitStorage(S::CXSwitchStmt)::Bool
end

function clang_SwitchStmt_hasVarStorage(S)
    @ccall libclangex.clang_SwitchStmt_hasVarStorage(S::CXSwitchStmt)::Bool
end

function clang_SwitchStmt_getSwitchLoc(S)
    @ccall libclangex.clang_SwitchStmt_getSwitchLoc(S::CXSwitchStmt)::CXSourceLocation_
end

function clang_SwitchStmt_getLParenLoc(S)
    @ccall libclangex.clang_SwitchStmt_getLParenLoc(S::CXSwitchStmt)::CXSourceLocation_
end

function clang_SwitchStmt_getRParenLoc(S)
    @ccall libclangex.clang_SwitchStmt_getRParenLoc(S::CXSwitchStmt)::CXSourceLocation_
end

function clang_WhileStmt_hasVarStorage(S)
    @ccall libclangex.clang_WhileStmt_hasVarStorage(S::CXWhileStmt)::Bool
end

function clang_WhileStmt_getLParenLoc(S)
    @ccall libclangex.clang_WhileStmt_getLParenLoc(S::CXWhileStmt)::CXSourceLocation_
end

function clang_WhileStmt_getRParenLoc(S)
    @ccall libclangex.clang_WhileStmt_getRParenLoc(S::CXWhileStmt)::CXSourceLocation_
end

function clang_DoStmt_getRParenLoc(S)
    @ccall libclangex.clang_DoStmt_getRParenLoc(S::CXDoStmt)::CXSourceLocation_
end

function clang_ForStmt_getLParenLoc(S)
    @ccall libclangex.clang_ForStmt_getLParenLoc(S::CXForStmt)::CXSourceLocation_
end

function clang_ForStmt_getRParenLoc(S)
    @ccall libclangex.clang_ForStmt_getRParenLoc(S::CXForStmt)::CXSourceLocation_
end

function clang_GotoStmt_getLabelLoc(S)
    @ccall libclangex.clang_GotoStmt_getLabelLoc(S::CXGotoStmt)::CXSourceLocation_
end

function clang_IndirectGotoStmt_getGotoLoc(S)
    @ccall libclangex.clang_IndirectGotoStmt_getGotoLoc(S::CXIndirectGotoStmt)::CXSourceLocation_
end

function clang_IndirectGotoStmt_getStarLoc(S)
    @ccall libclangex.clang_IndirectGotoStmt_getStarLoc(S::CXIndirectGotoStmt)::CXSourceLocation_
end

function clang_ContinueStmt_getContinueLoc(S)
    @ccall libclangex.clang_ContinueStmt_getContinueLoc(S::CXContinueStmt)::CXSourceLocation_
end

function clang_BreakStmt_getBreakLoc(S)
    @ccall libclangex.clang_BreakStmt_getBreakLoc(S::CXBreakStmt)::CXSourceLocation_
end

function clang_ReturnStmt_getReturnLoc(S)
    @ccall libclangex.clang_ReturnStmt_getReturnLoc(S::CXReturnStmt)::CXSourceLocation_
end

function clang_SwitchCase_getKeywordLoc(S)
    @ccall libclangex.clang_SwitchCase_getKeywordLoc(S::CXSwitchCase)::CXSourceLocation_
end

function clang_SwitchCase_getColonLoc(S)
    @ccall libclangex.clang_SwitchCase_getColonLoc(S::CXSwitchCase)::CXSourceLocation_
end

function clang_CaseStmt_caseStmtIsGNURange(S)
    @ccall libclangex.clang_CaseStmt_caseStmtIsGNURange(S::CXCaseStmt)::Bool
end

function clang_CaseStmt_getCaseLoc(S)
    @ccall libclangex.clang_CaseStmt_getCaseLoc(S::CXCaseStmt)::CXSourceLocation_
end

function clang_CaseStmt_getEllipsisLoc(S)
    @ccall libclangex.clang_CaseStmt_getEllipsisLoc(S::CXCaseStmt)::CXSourceLocation_
end

function clang_DefaultStmt_getDefaultLoc(S)
    @ccall libclangex.clang_DefaultStmt_getDefaultLoc(S::CXDefaultStmt)::CXSourceLocation_
end

function clang_LabelStmt_getIdentLoc(S)
    @ccall libclangex.clang_LabelStmt_getIdentLoc(S::CXLabelStmt)::CXSourceLocation_
end

function clang_LabelStmt_isSideEntry(S)
    @ccall libclangex.clang_LabelStmt_isSideEntry(S::CXLabelStmt)::Bool
end

function clang_NullStmt_getSemiLoc(S)
    @ccall libclangex.clang_NullStmt_getSemiLoc(S::CXNullStmt)::CXSourceLocation_
end

function clang_NullStmt_hasLeadingEmptyMacro(S)
    @ccall libclangex.clang_NullStmt_hasLeadingEmptyMacro(S::CXNullStmt)::Bool
end

function clang_CompoundStmt_body_empty(S)
    @ccall libclangex.clang_CompoundStmt_body_empty(S::CXCompoundStmt)::Bool
end

function clang_CompoundStmt_hasStoredFPFeatures(S)
    @ccall libclangex.clang_CompoundStmt_hasStoredFPFeatures(S::CXCompoundStmt)::Bool
end

function clang_CXXCatchStmt_getExceptionDecl(CS)
    @ccall libclangex.clang_CXXCatchStmt_getExceptionDecl(CS::CXCXXCatchStmt)::CXVarDecl
end

function clang_CXXCatchStmt_getCaughtType(CS)
    @ccall libclangex.clang_CXXCatchStmt_getCaughtType(CS::CXCXXCatchStmt)::CXQualType
end

function clang_CXXCatchStmt_getHandlerBlock(CS)
    @ccall libclangex.clang_CXXCatchStmt_getHandlerBlock(CS::CXCXXCatchStmt)::CXStmt
end

function clang_CXXTryStmt_getTryBlock(TS)
    @ccall libclangex.clang_CXXTryStmt_getTryBlock(TS::CXCXXTryStmt)::CXCompoundStmt
end

function clang_CXXTryStmt_getNumHandlers(TS)
    @ccall libclangex.clang_CXXTryStmt_getNumHandlers(TS::CXCXXTryStmt)::Cuint
end

function clang_CXXTryStmt_getHandler(TS, i)
    @ccall libclangex.clang_CXXTryStmt_getHandler(TS::CXCXXTryStmt, i::Cuint)::CXCXXCatchStmt
end

function clang_CXXForRangeStmt_getLoopVariable(FRS)
    @ccall libclangex.clang_CXXForRangeStmt_getLoopVariable(FRS::CXCXXForRangeStmt)::CXVarDecl
end

function clang_CXXForRangeStmt_getRangeInit(FRS)
    @ccall libclangex.clang_CXXForRangeStmt_getRangeInit(FRS::CXCXXForRangeStmt)::CXExpr
end

function clang_CXXForRangeStmt_getBody(FRS)
    @ccall libclangex.clang_CXXForRangeStmt_getBody(FRS::CXCXXForRangeStmt)::CXStmt
end

function clang_CXXForRangeStmt_getBeginStmt(FRS)
    @ccall libclangex.clang_CXXForRangeStmt_getBeginStmt(FRS::CXCXXForRangeStmt)::CXDeclStmt
end

function clang_CXXForRangeStmt_getEndStmt(FRS)
    @ccall libclangex.clang_CXXForRangeStmt_getEndStmt(FRS::CXCXXForRangeStmt)::CXDeclStmt
end

function clang_CXXCatchStmt_getCatchLoc(S)
    @ccall libclangex.clang_CXXCatchStmt_getCatchLoc(S::CXCXXCatchStmt)::CXSourceLocation_
end

function clang_CXXTryStmt_getTryLoc(S)
    @ccall libclangex.clang_CXXTryStmt_getTryLoc(S::CXCXXTryStmt)::CXSourceLocation_
end

function clang_CXXForRangeStmt_getForLoc(S)
    @ccall libclangex.clang_CXXForRangeStmt_getForLoc(S::CXCXXForRangeStmt)::CXSourceLocation_
end

function clang_CXXForRangeStmt_getCoawaitLoc(S)
    @ccall libclangex.clang_CXXForRangeStmt_getCoawaitLoc(S::CXCXXForRangeStmt)::CXSourceLocation_
end

function clang_CXXForRangeStmt_getColonLoc(S)
    @ccall libclangex.clang_CXXForRangeStmt_getColonLoc(S::CXCXXForRangeStmt)::CXSourceLocation_
end

function clang_CXXForRangeStmt_getRParenLoc(S)
    @ccall libclangex.clang_CXXForRangeStmt_getRParenLoc(S::CXCXXForRangeStmt)::CXSourceLocation_
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
    @ccall libclangex.clang_TemplateArgument_constructFromQualType(OpaquePtr::CXQualType, isNullPtr::Bool)::CXTemplateArgument
end

function clang_TemplateArgument_constructFromValueDecl(VD, OpaquePtr)
    @ccall libclangex.clang_TemplateArgument_constructFromValueDecl(VD::CXValueDecl, OpaquePtr::CXQualType)::CXTemplateArgument
end

function clang_TemplateArgument_constructFromIntegral(Ctx, Val, OpaquePtr)
    @ccall libclangex.clang_TemplateArgument_constructFromIntegral(Ctx::CXASTContext, Val::LLVMGenericValueRef, OpaquePtr::CXQualType)::CXTemplateArgument
end

function clang_TemplateArgument_dispose(TA)
    @ccall libclangex.clang_TemplateArgument_dispose(TA::CXTemplateArgument)::Cvoid
end

function clang_TemplateArgument_getKind(TA)
    @ccall libclangex.clang_TemplateArgument_getKind(TA::CXTemplateArgument)::CXTemplateArgument_ArgKind
end

function clang_TemplateArgument_isNull(TA)
    @ccall libclangex.clang_TemplateArgument_isNull(TA::CXTemplateArgument)::Bool
end

function clang_TemplateArgument_isDependent(TA)
    @ccall libclangex.clang_TemplateArgument_isDependent(TA::CXTemplateArgument)::Bool
end

function clang_TemplateArgument_isInstantiationDependent(TA)
    @ccall libclangex.clang_TemplateArgument_isInstantiationDependent(TA::CXTemplateArgument)::Bool
end

function clang_TemplateArgument_getAsType(TA)
    @ccall libclangex.clang_TemplateArgument_getAsType(TA::CXTemplateArgument)::CXQualType
end

function clang_TemplateArgument_getAsDecl(TA)
    @ccall libclangex.clang_TemplateArgument_getAsDecl(TA::CXTemplateArgument)::CXValueDecl
end

function clang_TemplateArgument_getParamTypeForDecl(TA)
    @ccall libclangex.clang_TemplateArgument_getParamTypeForDecl(TA::CXTemplateArgument)::CXQualType
end

function clang_TemplateArgument_getNullPtrType(TA)
    @ccall libclangex.clang_TemplateArgument_getNullPtrType(TA::CXTemplateArgument)::CXQualType
end

function clang_TemplateArgument_getAsTemplate(TA)
    @ccall libclangex.clang_TemplateArgument_getAsTemplate(TA::CXTemplateArgument)::CXTemplateName
end

function clang_TemplateArgument_getAsTemplateOrTemplatePattern(TA)
    @ccall libclangex.clang_TemplateArgument_getAsTemplateOrTemplatePattern(TA::CXTemplateArgument)::CXTemplateName
end

function clang_TemplateArgument_getNumTemplateExpansions(TA)
    @ccall libclangex.clang_TemplateArgument_getNumTemplateExpansions(TA::CXTemplateArgument)::Cuint
end

function clang_TemplateArgument_getAsIntegral(TA)
    @ccall libclangex.clang_TemplateArgument_getAsIntegral(TA::CXTemplateArgument)::LLVMGenericValueRef
end

function clang_TemplateArgument_getIntegralType(TA)
    @ccall libclangex.clang_TemplateArgument_getIntegralType(TA::CXTemplateArgument)::CXQualType
end

function clang_TemplateArgument_setIntegralType(TA, OpaquePtr)
    @ccall libclangex.clang_TemplateArgument_setIntegralType(TA::CXTemplateArgument, OpaquePtr::CXQualType)::Cvoid
end

function clang_TemplateArgument_getNonTypeTemplateArgumentType(TA)
    @ccall libclangex.clang_TemplateArgument_getNonTypeTemplateArgumentType(TA::CXTemplateArgument)::CXQualType
end

function clang_TemplateArgument_dump(TA)
    @ccall libclangex.clang_TemplateArgument_dump(TA::CXTemplateArgument)::Cvoid
end

@enum CXTemplateName_NameKind::UInt32 begin
    CXTemplateName_Template = 0
    CXTemplateName_OverloadedTemplate = 1
    CXTemplateName_AssumedTemplate = 2
    CXTemplateName_QualifiedTemplate = 3
    CXTemplateName_DependentTemplate = 4
    CXTemplateName_SubstTemplateTemplateParm = 5
    CXTemplateName_SubstTemplateTemplateParmPack = 6
    UsingTemplate = 7
end

function clang_TemplateName_isNull(TN)
    @ccall libclangex.clang_TemplateName_isNull(TN::CXTemplateName)::Bool
end

function clang_TemplateName_getKind(TN)
    @ccall libclangex.clang_TemplateName_getKind(TN::CXTemplateName)::CXTemplateName_NameKind
end

function clang_TemplateName_getAsTemplateDecl(TN)
    @ccall libclangex.clang_TemplateName_getAsTemplateDecl(TN::CXTemplateName)::CXTemplateDecl
end

function clang_TemplateName_getUnderlying(TN)
    @ccall libclangex.clang_TemplateName_getUnderlying(TN::CXTemplateName)::CXTemplateName
end

function clang_TemplateName_getNameToSubstitute(TN)
    @ccall libclangex.clang_TemplateName_getNameToSubstitute(TN::CXTemplateName)::CXTemplateName
end

function clang_TemplateName_isDependent(TN)
    @ccall libclangex.clang_TemplateName_isDependent(TN::CXTemplateName)::Bool
end

function clang_TemplateName_isInstantiationDependent(TN)
    @ccall libclangex.clang_TemplateName_isInstantiationDependent(TN::CXTemplateName)::Bool
end

function clang_TemplateName_containsUnexpandedParameterPack(TN)
    @ccall libclangex.clang_TemplateName_containsUnexpandedParameterPack(TN::CXTemplateName)::Bool
end

function clang_TemplateName_dump(TN)
    @ccall libclangex.clang_TemplateName_dump(TN::CXTemplateName)::Cvoid
end

function clang_CodeGenOptions_create()
    @ccall libclangex.clang_CodeGenOptions_create()::CXCodeGenOptions
end

function clang_CodeGenOptions_dispose(DO)
    @ccall libclangex.clang_CodeGenOptions_dispose(DO::CXCodeGenOptions)::Cvoid
end

function clang_CodeGenOptions_getArgv0(CGO)
    @ccall libclangex.clang_CodeGenOptions_getArgv0(CGO::CXCodeGenOptions)::Ptr{Cchar}
end

function clang_CodeGenOptions_PrintStats(CGO)
    @ccall libclangex.clang_CodeGenOptions_PrintStats(CGO::CXCodeGenOptions)::Cvoid
end

function clang_IgnoringDiagConsumer_create()
    @ccall libclangex.clang_IgnoringDiagConsumer_create()::CXDiagnosticConsumer
end

function clang_DiagnosticConsumer_dispose(DC)
    @ccall libclangex.clang_DiagnosticConsumer_dispose(DC::CXDiagnosticConsumer)::Cvoid
end

function clang_DiagnosticConsumer_BeginSourceFile(DC, LangOpts, PP)
    @ccall libclangex.clang_DiagnosticConsumer_BeginSourceFile(DC::CXDiagnosticConsumer, LangOpts::CXLangOptions, PP::CXPreprocessor)::Cvoid
end

function clang_DiagnosticConsumer_EndSourceFile(DC)
    @ccall libclangex.clang_DiagnosticConsumer_EndSourceFile(DC::CXDiagnosticConsumer)::Cvoid
end

function clang_DiagnosticsEngine_create(ID, DO, DC, ShouldOwnClient)
    @ccall libclangex.clang_DiagnosticsEngine_create(ID::CXDiagnosticIDs, DO::CXDiagnosticOptions, DC::CXDiagnosticConsumer, ShouldOwnClient::Bool)::CXDiagnosticsEngine
end

function clang_DiagnosticsEngine_dispose(DE)
    @ccall libclangex.clang_DiagnosticsEngine_dispose(DE::CXDiagnosticsEngine)::Cvoid
end

function clang_DiagnosticsEngine_setShowColors(DE, ShowColors)
    @ccall libclangex.clang_DiagnosticsEngine_setShowColors(DE::CXDiagnosticsEngine, ShowColors::Bool)::Cvoid
end

function clang_DiagnosticIDs_create()
    @ccall libclangex.clang_DiagnosticIDs_create()::CXDiagnosticIDs
end

function clang_DiagnosticIDs_dispose(ID)
    @ccall libclangex.clang_DiagnosticIDs_dispose(ID::CXDiagnosticIDs)::Cvoid
end

function clang_DiagnosticOptions_create()
    @ccall libclangex.clang_DiagnosticOptions_create()::CXDiagnosticOptions
end

function clang_DiagnosticOptions_dispose(DO)
    @ccall libclangex.clang_DiagnosticOptions_dispose(DO::CXDiagnosticOptions)::Cvoid
end

function clang_DiagnosticOptions_PrintStats(DO)
    @ccall libclangex.clang_DiagnosticOptions_PrintStats(DO::CXDiagnosticOptions)::Cvoid
end

function clang_DiagnosticOptions_setShowColors(DO, ShowColors)
    @ccall libclangex.clang_DiagnosticOptions_setShowColors(DO::CXDiagnosticOptions, ShowColors::Bool)::Cvoid
end

function clang_DiagnosticOptions_setShowPresumedLoc(DO, ShowPresumedLoc)
    @ccall libclangex.clang_DiagnosticOptions_setShowPresumedLoc(DO::CXDiagnosticOptions, ShowPresumedLoc::Bool)::Cvoid
end

function clang_FileEntry_getName(FE)
    @ccall libclangex.clang_FileEntry_getName(FE::CXFileEntry)::Ptr{Cchar}
end

function clang_FileEntry_tryGetRealPathName(FE)
    @ccall libclangex.clang_FileEntry_tryGetRealPathName(FE::CXFileEntry)::Ptr{Cchar}
end

function clang_FileEntry_getUID(FE)
    @ccall libclangex.clang_FileEntry_getUID(FE::CXFileEntry)::Cuint
end

function clang_FileEntry_getModificationTime(FE)
    @ccall libclangex.clang_FileEntry_getModificationTime(FE::CXFileEntry)::time_t
end

function clang_FileEntry_getDir(FE)
    @ccall libclangex.clang_FileEntry_getDir(FE::CXFileEntry)::CXDirectoryEntry
end

function clang_FileEntry_isNamedPipe(FE)
    @ccall libclangex.clang_FileEntry_isNamedPipe(FE::CXFileEntry)::Bool
end

function clang_FileManager_create()
    @ccall libclangex.clang_FileManager_create()::CXFileManager
end

function clang_FileManager_dispose(FM)
    @ccall libclangex.clang_FileManager_dispose(FM::CXFileManager)::Cvoid
end

function clang_FileManager_getBufferForFile(FM, FER, isVolatile, RequiresNullTerminator)
    @ccall libclangex.clang_FileManager_getBufferForFile(FM::CXFileManager, FER::CXFileEntryRef, isVolatile::Bool, RequiresNullTerminator::Bool)::LLVMMemoryBufferRef
end

function clang_FileManager_PrintStats(FM)
    @ccall libclangex.clang_FileManager_PrintStats(FM::CXFileManager)::Cvoid
end

function clang_FileManager_getDirectory(FM, DirName, CacheFailure)
    @ccall libclangex.clang_FileManager_getDirectory(FM::CXFileManager, DirName::Ptr{Cchar}, CacheFailure::Bool)::CXDirectoryEntry
end

function clang_FileManager_getFileRef(FM, Filename, OpenFile, CacheFailure)
    @ccall libclangex.clang_FileManager_getFileRef(FM::CXFileManager, Filename::Ptr{Cchar}, OpenFile::Bool, CacheFailure::Bool)::CXFileEntryRef
end

function clang_FileEntryRef_dispose(FER)
    @ccall libclangex.clang_FileEntryRef_dispose(FER::CXFileEntryRef)::Cvoid
end

function clang_FileEntryRef_getFileEntry(FER)
    @ccall libclangex.clang_FileEntryRef_getFileEntry(FER::CXFileEntryRef)::CXFileEntry
end

function clang_IdentifierTable_PrintStats(IT)
    @ccall libclangex.clang_IdentifierTable_PrintStats(IT::CXIdentifierTable)::Cvoid
end

function clang_IdentifierTable_get(Idents, Name)
    @ccall libclangex.clang_IdentifierTable_get(Idents::CXIdentifierTable, Name::Ptr{Cchar})::CXIdentifierInfo
end

function clang_IdentifierInfo_getName(II)
    @ccall libclangex.clang_IdentifierInfo_getName(II::CXIdentifierInfo)::Ptr{Cchar}
end

function clang_LangOptions_PrintStats(LO)
    @ccall libclangex.clang_LangOptions_PrintStats(LO::CXLangOptions)::Cvoid
end

function clang_SourceLocation_createInvalid()
    @ccall libclangex.clang_SourceLocation_createInvalid()::CXSourceLocation_
end

function clang_SourceLocation_isFileID(Loc)
    @ccall libclangex.clang_SourceLocation_isFileID(Loc::CXSourceLocation_)::Bool
end

function clang_SourceLocation_isMacroID(Loc)
    @ccall libclangex.clang_SourceLocation_isMacroID(Loc::CXSourceLocation_)::Bool
end

function clang_SourceLocation_isValid(Loc)
    @ccall libclangex.clang_SourceLocation_isValid(Loc::CXSourceLocation_)::Bool
end

function clang_SourceLocation_isInvalid(Loc)
    @ccall libclangex.clang_SourceLocation_isInvalid(Loc::CXSourceLocation_)::Bool
end

function clang_SourceLocation_isPairOfFileLocations(Start, End)
    @ccall libclangex.clang_SourceLocation_isPairOfFileLocations(Start::CXSourceLocation_, End::CXSourceLocation_)::Bool
end

function clang_SourceLocation_getHashValue(Loc)
    @ccall libclangex.clang_SourceLocation_getHashValue(Loc::CXSourceLocation_)::Cuint
end

function clang_SourceLocation_dump(Loc, SM)
    @ccall libclangex.clang_SourceLocation_dump(Loc::CXSourceLocation_, SM::CXSourceManager)::Cvoid
end

function clang_SourceLocation_printToString(Loc, SM)
    @ccall libclangex.clang_SourceLocation_printToString(Loc::CXSourceLocation_, SM::CXSourceManager)::CXString
end

function clang_SourceLocation_getLocWithOffset(Loc, Offset)
    @ccall libclangex.clang_SourceLocation_getLocWithOffset(Loc::CXSourceLocation_, Offset::Cint)::CXSourceLocation_
end

function clang_SourceManager_create(Diag, FileMgr, UserFilesAreVolatile)
    @ccall libclangex.clang_SourceManager_create(Diag::CXDiagnosticsEngine, FileMgr::CXFileManager, UserFilesAreVolatile::Bool)::CXSourceManager
end

function clang_SourceManager_dispose(SM)
    @ccall libclangex.clang_SourceManager_dispose(SM::CXSourceManager)::Cvoid
end

function clang_SourceManager_PrintStats(SM)
    @ccall libclangex.clang_SourceManager_PrintStats(SM::CXSourceManager)::Cvoid
end

function clang_FileID_getHashValue(FID)
    @ccall libclangex.clang_FileID_getHashValue(FID::CXFileID)::Cuint
end

function clang_FileID_dispose(FID)
    @ccall libclangex.clang_FileID_dispose(FID::CXFileID)::Cvoid
end

function clang_SourceManager_createFileIDFromMemoryBuffer(SM, MB)
    @ccall libclangex.clang_SourceManager_createFileIDFromMemoryBuffer(SM::CXSourceManager, MB::LLVMMemoryBufferRef)::CXFileID
end

function clang_SourceManager_createFileIDFromFileEntry(SM, FER, Loc)
    @ccall libclangex.clang_SourceManager_createFileIDFromFileEntry(SM::CXSourceManager, FER::CXFileEntryRef, Loc::CXSourceLocation_)::CXFileID
end

function clang_SourceManager_getMainFileID(SM)
    @ccall libclangex.clang_SourceManager_getMainFileID(SM::CXSourceManager)::CXFileID
end

function clang_SourceManager_setMainFileID(SM, ID)
    @ccall libclangex.clang_SourceManager_setMainFileID(SM::CXSourceManager, ID::CXFileID)::Cvoid
end

function clang_SourceManager_overrideFileContents(SM, FER, MB)
    @ccall libclangex.clang_SourceManager_overrideFileContents(SM::CXSourceManager, FER::CXFileEntryRef, MB::LLVMMemoryBufferRef)::Cvoid
end

function clang_SourceManager_getLocForStartOfFile(SM, FID)
    @ccall libclangex.clang_SourceManager_getLocForStartOfFile(SM::CXSourceManager, FID::CXFileID)::CXSourceLocation_
end

function clang_SourceManager_getLocForEndOfFile(SM, FID)
    @ccall libclangex.clang_SourceManager_getLocForEndOfFile(SM::CXSourceManager, FID::CXFileID)::CXSourceLocation_
end

function clang_TargetInfo_CreateTargetInfo(DE, Opts)
    @ccall libclangex.clang_TargetInfo_CreateTargetInfo(DE::CXDiagnosticsEngine, Opts::CXTargetOptions)::CXTargetInfo_
end

function clang_TargetOptions_create()
    @ccall libclangex.clang_TargetOptions_create()::CXTargetOptions
end

function clang_TargetOptions_dispose(TO)
    @ccall libclangex.clang_TargetOptions_dispose(TO::CXTargetOptions)::Cvoid
end

function clang_TargetOptions_setTriple(TO, TripleStr, Num)
    @ccall libclangex.clang_TargetOptions_setTriple(TO::CXTargetOptions, TripleStr::Ptr{Cchar}, Num::Csize_t)::Cvoid
end

function clang_TargetOptions_PrintStats(TO)
    @ccall libclangex.clang_TargetOptions_PrintStats(TO::CXTargetOptions)::Cvoid
end

function clang_CodeGen_convertTypeForMemory(CGM, T)
    @ccall libclangex.clang_CodeGen_convertTypeForMemory(CGM::CXCodeGenModule, T::CXQualType)::LLVMTypeRef
end

function clang_EmitAssemblyAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitAssemblyAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_EmitBCAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitBCAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_EmitLLVMAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitLLVMAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_EmitLLVMOnlyAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitLLVMOnlyAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_EmitCodeGenOnlyAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitCodeGenOnlyAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_EmitObjAction_create(LLVMCtx)
    @ccall libclangex.clang_EmitObjAction_create(LLVMCtx::LLVMContextRef)::CXCodeGenAction
end

function clang_CodeGenAction_dispose(CA)
    @ccall libclangex.clang_CodeGenAction_dispose(CA::CXCodeGenAction)::Cvoid
end

function clang_CodeGenAction_takeModule(CA)
    @ccall libclangex.clang_CodeGenAction_takeModule(CA::CXCodeGenAction)::LLVMModuleRef
end

function clang_CodeGenerator_CGM(CG)
    @ccall libclangex.clang_CodeGenerator_CGM(CG::CXCodeGenerator)::CXCodeGenModule
end

function clang_CodeGenerator_GetModule(CG)
    @ccall libclangex.clang_CodeGenerator_GetModule(CG::CXCodeGenerator)::LLVMModuleRef
end

function clang_CodeGenerator_ReleaseModule(CG)
    @ccall libclangex.clang_CodeGenerator_ReleaseModule(CG::CXCodeGenerator)::LLVMModuleRef
end

function clang_CodeGenerator_GetDeclForMangledName(CG, MangledName)
    @ccall libclangex.clang_CodeGenerator_GetDeclForMangledName(CG::CXCodeGenerator, MangledName::Ptr{Cchar})::CXDecl
end

function clang_CodeGenerator_StartModule(CG, LLVMCtx, ModuleName)
    @ccall libclangex.clang_CodeGenerator_StartModule(CG::CXCodeGenerator, LLVMCtx::LLVMContextRef, ModuleName::Ptr{Cchar})::LLVMModuleRef
end

function clang_Driver_GetResourcesPathLength(BinaryPath)
    @ccall libclangex.clang_Driver_GetResourcesPathLength(BinaryPath::Ptr{Cchar})::Csize_t
end

function clang_Driver_GetResourcesPath(BinaryPath, ResourcesPath, N)
    @ccall libclangex.clang_Driver_GetResourcesPath(BinaryPath::Ptr{Cchar}, ResourcesPath::Ptr{Cchar}, N::Csize_t)::Cvoid
end

function clang_CompilerInstance_create()
    @ccall libclangex.clang_CompilerInstance_create()::CXCompilerInstance
end

function clang_CompilerInstance_dispose(CI)
    @ccall libclangex.clang_CompilerInstance_dispose(CI::CXCompilerInstance)::Cvoid
end

function clang_CompilerInstance_hasDiagnostics(CI)
    @ccall libclangex.clang_CompilerInstance_hasDiagnostics(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getDiagnostics(CI)
    @ccall libclangex.clang_CompilerInstance_getDiagnostics(CI::CXCompilerInstance)::CXDiagnosticsEngine
end

function clang_CompilerInstance_setDiagnostics(CI, Value)
    @ccall libclangex.clang_CompilerInstance_setDiagnostics(CI::CXCompilerInstance, Value::CXDiagnosticsEngine)::Cvoid
end

function clang_CompilerInstance_getDiagnosticClient(CI)
    @ccall libclangex.clang_CompilerInstance_getDiagnosticClient(CI::CXCompilerInstance)::CXDiagnosticConsumer
end

function clang_CompilerInstance_createDiagnostics(CI, DC, ShouldOwnClient)
    @ccall libclangex.clang_CompilerInstance_createDiagnostics(CI::CXCompilerInstance, DC::CXDiagnosticConsumer, ShouldOwnClient::Bool)::Cvoid
end

function clang_CompilerInstance_hasFileManager(CI)
    @ccall libclangex.clang_CompilerInstance_hasFileManager(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getFileManager(CI)
    @ccall libclangex.clang_CompilerInstance_getFileManager(CI::CXCompilerInstance)::CXFileManager
end

function clang_CompilerInstance_setFileManager(CI, FM)
    @ccall libclangex.clang_CompilerInstance_setFileManager(CI::CXCompilerInstance, FM::CXFileManager)::Cvoid
end

function clang_CompilerInstance_createFileManager(CI)
    @ccall libclangex.clang_CompilerInstance_createFileManager(CI::CXCompilerInstance)::CXFileManager
end

function clang_CompilerInstance_createFileManagerWithVOFS4PCH(CI, Path, ModificationTime, PCHBuffer)
    @ccall libclangex.clang_CompilerInstance_createFileManagerWithVOFS4PCH(CI::CXCompilerInstance, Path::Ptr{Cchar}, ModificationTime::time_t, PCHBuffer::LLVMMemoryBufferRef)::CXFileManager
end

function clang_CompilerInstance_hasSourceManager(CI)
    @ccall libclangex.clang_CompilerInstance_hasSourceManager(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getSourceManager(CI)
    @ccall libclangex.clang_CompilerInstance_getSourceManager(CI::CXCompilerInstance)::CXSourceManager
end

function clang_CompilerInstance_setSourceManager(CI, SM)
    @ccall libclangex.clang_CompilerInstance_setSourceManager(CI::CXCompilerInstance, SM::CXSourceManager)::Cvoid
end

function clang_CompilerInstance_createSourceManager(CI, FileMgr)
    @ccall libclangex.clang_CompilerInstance_createSourceManager(CI::CXCompilerInstance, FileMgr::CXFileManager)::Cvoid
end

function clang_CompilerInstance_hasInvocation(CI)
    @ccall libclangex.clang_CompilerInstance_hasInvocation(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getInvocation(CI)
    @ccall libclangex.clang_CompilerInstance_getInvocation(CI::CXCompilerInstance)::CXCompilerInvocation
end

function clang_CompilerInstance_setInvocation(CI, CInv)
    @ccall libclangex.clang_CompilerInstance_setInvocation(CI::CXCompilerInstance, CInv::CXCompilerInvocation)::Cvoid
end

function clang_CompilerInstance_hasTarget(CI)
    @ccall libclangex.clang_CompilerInstance_hasTarget(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getTarget(CI)
    @ccall libclangex.clang_CompilerInstance_getTarget(CI::CXCompilerInstance)::CXTargetInfo_
end

function clang_CompilerInstance_setTarget(CI, Info)
    @ccall libclangex.clang_CompilerInstance_setTarget(CI::CXCompilerInstance, Info::CXTargetInfo_)::Cvoid
end

function clang_CompilerInstance_setTargetAndLangOpts(CI)
    @ccall libclangex.clang_CompilerInstance_setTargetAndLangOpts(CI::CXCompilerInstance)::Cvoid
end

function clang_CompilerInstance_hasPreprocessor(CI)
    @ccall libclangex.clang_CompilerInstance_hasPreprocessor(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getPreprocessor(CI)
    @ccall libclangex.clang_CompilerInstance_getPreprocessor(CI::CXCompilerInstance)::CXPreprocessor
end

function clang_CompilerInstance_setPreprocessor(CI, PP)
    @ccall libclangex.clang_CompilerInstance_setPreprocessor(CI::CXCompilerInstance, PP::CXPreprocessor)::Cvoid
end

function clang_CompilerInstance_createPreprocessor(CI, TUKind)
    @ccall libclangex.clang_CompilerInstance_createPreprocessor(CI::CXCompilerInstance, TUKind::CXTranslationUnitKind)::Cvoid
end

function clang_CompilerInstance_hasSema(CI)
    @ccall libclangex.clang_CompilerInstance_hasSema(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getSema(CI)
    @ccall libclangex.clang_CompilerInstance_getSema(CI::CXCompilerInstance)::CXSema
end

function clang_CompilerInstance_setSema(CI, S)
    @ccall libclangex.clang_CompilerInstance_setSema(CI::CXCompilerInstance, S::CXSema)::Cvoid
end

function clang_CompilerInstance_createSema(CI, TUKind)
    @ccall libclangex.clang_CompilerInstance_createSema(CI::CXCompilerInstance, TUKind::CXTranslationUnitKind)::Cvoid
end

function clang_CompilerInstance_hasASTContext(CI)
    @ccall libclangex.clang_CompilerInstance_hasASTContext(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getASTContext(CI)
    @ccall libclangex.clang_CompilerInstance_getASTContext(CI::CXCompilerInstance)::CXASTContext
end

function clang_CompilerInstance_setASTContext(CI, Ctx)
    @ccall libclangex.clang_CompilerInstance_setASTContext(CI::CXCompilerInstance, Ctx::CXASTContext)::Cvoid
end

function clang_CompilerInstance_createASTContext(CI)
    @ccall libclangex.clang_CompilerInstance_createASTContext(CI::CXCompilerInstance)::Cvoid
end

function clang_CompilerInstance_hasASTConsumer(CI)
    @ccall libclangex.clang_CompilerInstance_hasASTConsumer(CI::CXCompilerInstance)::Bool
end

function clang_CompilerInstance_getASTConsumer(CI)
    @ccall libclangex.clang_CompilerInstance_getASTConsumer(CI::CXCompilerInstance)::CXASTConsumer
end

function clang_CompilerInstance_setASTConsumer(CI, CG)
    @ccall libclangex.clang_CompilerInstance_setASTConsumer(CI::CXCompilerInstance, CG::CXASTConsumer)::Cvoid
end

function clang_CompilerInstance_getCodeGenOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getCodeGenOpts(CI::CXCompilerInstance)::CXCodeGenOptions
end

function clang_CompilerInstance_getDiagnosticOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getDiagnosticOpts(CI::CXCompilerInstance)::CXDiagnosticOptions
end

function clang_CompilerInstance_getFrontendOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getFrontendOpts(CI::CXCompilerInstance)::CXFrontendOptions
end

function clang_CompilerInstance_getHeaderSearchOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getHeaderSearchOpts(CI::CXCompilerInstance)::CXHeaderSearchOptions
end

function clang_CompilerInstance_getPreprocessorOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getPreprocessorOpts(CI::CXCompilerInstance)::CXPreprocessorOptions
end

function clang_CompilerInstance_getTargetOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getTargetOpts(CI::CXCompilerInstance)::CXTargetOptions
end

function clang_CompilerInstance_getLangOpts(CI)
    @ccall libclangex.clang_CompilerInstance_getLangOpts(CI::CXCompilerInstance)::CXLangOptions
end

function clang_CompilerInstance_ExecuteAction(CI, Act)
    @ccall libclangex.clang_CompilerInstance_ExecuteAction(CI::CXCompilerInstance, Act::CXFrontendAction)::Bool
end

function clang_CompilerInvocation_create()
    @ccall libclangex.clang_CompilerInvocation_create()::CXCompilerInvocation
end

function clang_CompilerInvocation_dispose(CI)
    @ccall libclangex.clang_CompilerInvocation_dispose(CI::CXCompilerInvocation)::Cvoid
end

function clang_CompilerInvocation_getCodeGenOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getCodeGenOpts(CI::CXCompilerInvocation)::CXCodeGenOptions
end

function clang_CompilerInvocation_getDiagnosticOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getDiagnosticOpts(CI::CXCompilerInvocation)::CXDiagnosticOptions
end

function clang_CompilerInvocation_getFrontendOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getFrontendOpts(CI::CXCompilerInvocation)::CXFrontendOptions
end

function clang_CompilerInvocation_getHeaderSearchOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getHeaderSearchOpts(CI::CXCompilerInvocation)::CXHeaderSearchOptions
end

function clang_CompilerInvocation_getPreprocessorOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getPreprocessorOpts(CI::CXCompilerInvocation)::CXPreprocessorOptions
end

function clang_CompilerInvocation_getTargetOpts(CI)
    @ccall libclangex.clang_CompilerInvocation_getTargetOpts(CI::CXCompilerInvocation)::CXTargetOptions
end

function clang_FrontendOptions_PrintStats(FEO)
    @ccall libclangex.clang_FrontendOptions_PrintStats(FEO::CXFrontendOptions)::Cvoid
end

function clang_TextDiagnosticPrinter_create(Opts)
    @ccall libclangex.clang_TextDiagnosticPrinter_create(Opts::CXDiagnosticOptions)::CXDiagnosticConsumer
end

function clang_IncrementalCompilerBuilder_create()
    @ccall libclangex.clang_IncrementalCompilerBuilder_create()::CXIncrementalCompilerBuilder
end

function clang_IncrementalCompilerBuilder_dispose(CB)
    @ccall libclangex.clang_IncrementalCompilerBuilder_dispose(CB::CXIncrementalCompilerBuilder)::Cvoid
end

function clang_IncrementalCompilerBuilder_SetCompilerArgs(CB, Args, N)
    @ccall libclangex.clang_IncrementalCompilerBuilder_SetCompilerArgs(CB::CXIncrementalCompilerBuilder, Args::Ptr{Ptr{Cchar}}, N::Cint)::Cvoid
end

function clang_IncrementalCompilerBuilder_CreateCpp(CB)
    @ccall libclangex.clang_IncrementalCompilerBuilder_CreateCpp(CB::CXIncrementalCompilerBuilder)::CXCompilerInstance
end

function clang_IncrementalCompilerBuilder_SetOffloadArch(CB, Arch)
    @ccall libclangex.clang_IncrementalCompilerBuilder_SetOffloadArch(CB::CXIncrementalCompilerBuilder, Arch::Ptr{Cchar})::Cvoid
end

function clang_IncrementalCompilerBuilder_SetCudaSDK(CB, path)
    @ccall libclangex.clang_IncrementalCompilerBuilder_SetCudaSDK(CB::CXIncrementalCompilerBuilder, path::Ptr{Cchar})::Cvoid
end

function clang_IncrementalCompilerBuilder_CreateCudaHost(CB)
    @ccall libclangex.clang_IncrementalCompilerBuilder_CreateCudaHost(CB::CXIncrementalCompilerBuilder)::CXCompilerInstance
end

function clang_IncrementalCompilerBuilder_CreateCudaDevice(CB)
    @ccall libclangex.clang_IncrementalCompilerBuilder_CreateCudaDevice(CB::CXIncrementalCompilerBuilder)::CXCompilerInstance
end

function clang_Interpreter_create(CI)
    @ccall libclangex.clang_Interpreter_create(CI::CXCompilerInstance)::CXInterpreter
end

function clang_Interpreter_createWithCUDA(CI, DCI)
    @ccall libclangex.clang_Interpreter_createWithCUDA(CI::CXCompilerInstance, DCI::CXCompilerInstance)::CXInterpreter
end

function clang_Interpreter_dispose(Interp)
    @ccall libclangex.clang_Interpreter_dispose(Interp::CXInterpreter)::Cvoid
end

function clang_Interpreter_getCompilerInstance(Interp)
    @ccall libclangex.clang_Interpreter_getCompilerInstance(Interp::CXInterpreter)::CXCompilerInstance
end

function clang_Interpreter_getExecutionEngine(Interp)
    @ccall libclangex.clang_Interpreter_getExecutionEngine(Interp::CXInterpreter)::LLVMOrcLLJITRef
end

function clang_Interpreter_Parse(Interp, Code)
    @ccall libclangex.clang_Interpreter_Parse(Interp::CXInterpreter, Code::Ptr{Cchar})::CXPartialTranslationUnit
end

function clang_Interpreter_Execute(Interp, PTU)
    @ccall libclangex.clang_Interpreter_Execute(Interp::CXInterpreter, PTU::CXPartialTranslationUnit)::Cvoid
end

function clang_Interpreter_ParseAndExecute(Interp, Code, Result)
    @ccall libclangex.clang_Interpreter_ParseAndExecute(Interp::CXInterpreter, Code::Ptr{Cchar}, Result::CXValue)::Cvoid
end

function clang_Interpreter_CompileDtorCall(Interp, CXXRD)
    @ccall libclangex.clang_Interpreter_CompileDtorCall(Interp::CXInterpreter, CXXRD::CXCXXRecordDecl)::LLVMOrcExecutorAddress
end

function clang_Interpreter_Undo(Interp, N)
    @ccall libclangex.clang_Interpreter_Undo(Interp::CXInterpreter, N::Cuint)::Cvoid
end

function clang_Interpreter_LoadDynamicLibrary(Interp, name)
    @ccall libclangex.clang_Interpreter_LoadDynamicLibrary(Interp::CXInterpreter, name::Ptr{Cchar})::Cvoid
end

function clang_Interpreter_getSymbolAddress(Interp, IRName)
    @ccall libclangex.clang_Interpreter_getSymbolAddress(Interp::CXInterpreter, IRName::Ptr{Cchar})::LLVMOrcExecutorAddress
end

function clang_Interpreter_getSymbolAddressFromLinkerName(Interp, LinkerName)
    @ccall libclangex.clang_Interpreter_getSymbolAddressFromLinkerName(Interp::CXInterpreter, LinkerName::Ptr{Cchar})::LLVMOrcExecutorAddress
end

function clang_Interpreter_getCodeGen(Interp)
    @ccall libclangex.clang_Interpreter_getCodeGen(Interp::CXInterpreter)::CXCodeGenerator
end

function clang_Interpreter_getParser(Interp)
    @ccall libclangex.clang_Interpreter_getParser(Interp::CXInterpreter)::CXParser
end

function clang_value_create()
    @ccall libclangex.clang_value_create()::CXValue
end

function clang_value_dispose(V)
    @ccall libclangex.clang_value_dispose(V::CXValue)::Cvoid
end

function clang_createValueFromType(I, Ty)
    @ccall libclangex.clang_createValueFromType(I::CXInterpreter, Ty::Ptr{Cvoid})::CXValue
end

function clang_value_getType(V)
    @ccall libclangex.clang_value_getType(V::CXValue)::Ptr{Cvoid}
end

function clang_value_isValid(V)
    @ccall libclangex.clang_value_isValid(V::CXValue)::Bool
end

function clang_value_isVoid(V)
    @ccall libclangex.clang_value_isVoid(V::CXValue)::Bool
end

function clang_value_hasValue(V)
    @ccall libclangex.clang_value_hasValue(V::CXValue)::Bool
end

function clang_value_isManuallyAlloc(V)
    @ccall libclangex.clang_value_isManuallyAlloc(V::CXValue)::Bool
end

@enum CXValueKind::UInt32 begin
    CXValue_Bool = 0
    CXValue_Char_S = 1
    CXValue_SChar = 2
    CXValue_UChar = 3
    CXValue_Short = 4
    CXValue_UShort = 5
    CXValue_Int = 6
    CXValue_UInt = 7
    CXValue_Long = 8
    CXValue_ULong = 9
    CXValue_LongLong = 10
    CXValue_ULongLong = 11
    CXValue_Float = 12
    CXValue_Double = 13
    CXValue_LongDouble = 14
    CXValue_Void = 15
    CXValue_PtrOrObj = 16
    CXValue_Unspecified = 17
end

function clang_value_getKind(V)
    @ccall libclangex.clang_value_getKind(V::CXValue)::CXValueKind
end

function clang_value_setKind(V, K)
    @ccall libclangex.clang_value_setKind(V::CXValue, K::CXValueKind)::Cvoid
end

function clang_value_setOpaqueType(V, Ty)
    @ccall libclangex.clang_value_setOpaqueType(V::CXValue, Ty::Ptr{Cvoid})::Cvoid
end

function clang_value_getPtr(V)
    @ccall libclangex.clang_value_getPtr(V::CXValue)::Ptr{Cvoid}
end

function clang_value_setPtr(V, P)
    @ccall libclangex.clang_value_setPtr(V::CXValue, P::Ptr{Cvoid})::Cvoid
end

function clang_value_setBool(V, Val)
    @ccall libclangex.clang_value_setBool(V::CXValue, Val::Bool)::Cvoid
end

function clang_value_getBool(V)
    @ccall libclangex.clang_value_getBool(V::CXValue)::Bool
end

function clang_value_setChar_S(V, Val)
    @ccall libclangex.clang_value_setChar_S(V::CXValue, Val::Cchar)::Cvoid
end

function clang_value_getChar_S(V)
    @ccall libclangex.clang_value_getChar_S(V::CXValue)::Cchar
end

function clang_value_setSChar(V, Val)
    @ccall libclangex.clang_value_setSChar(V::CXValue, Val::Int8)::Cvoid
end

function clang_value_getSChar(V)
    @ccall libclangex.clang_value_getSChar(V::CXValue)::Int8
end

function clang_value_setUChar(V, Val)
    @ccall libclangex.clang_value_setUChar(V::CXValue, Val::Cuchar)::Cvoid
end

function clang_value_getUChar(V)
    @ccall libclangex.clang_value_getUChar(V::CXValue)::Cuchar
end

function clang_value_setShort(V, Val)
    @ccall libclangex.clang_value_setShort(V::CXValue, Val::Cshort)::Cvoid
end

function clang_value_getShort(V)
    @ccall libclangex.clang_value_getShort(V::CXValue)::Cshort
end

function clang_value_setUShort(V, Val)
    @ccall libclangex.clang_value_setUShort(V::CXValue, Val::Cushort)::Cvoid
end

function clang_value_getUShort(V)
    @ccall libclangex.clang_value_getUShort(V::CXValue)::Cushort
end

function clang_value_setInt(V, Val)
    @ccall libclangex.clang_value_setInt(V::CXValue, Val::Cint)::Cvoid
end

function clang_value_getInt(V)
    @ccall libclangex.clang_value_getInt(V::CXValue)::Cint
end

function clang_value_setUInt(V, Val)
    @ccall libclangex.clang_value_setUInt(V::CXValue, Val::Cuint)::Cvoid
end

function clang_value_getUInt(V)
    @ccall libclangex.clang_value_getUInt(V::CXValue)::Cuint
end

function clang_value_setLong(V, Val)
    @ccall libclangex.clang_value_setLong(V::CXValue, Val::Clong)::Cvoid
end

function clang_value_getLong(V)
    @ccall libclangex.clang_value_getLong(V::CXValue)::Clong
end

function clang_value_setULong(V, Val)
    @ccall libclangex.clang_value_setULong(V::CXValue, Val::Culong)::Cvoid
end

function clang_value_getULong(V)
    @ccall libclangex.clang_value_getULong(V::CXValue)::Culong
end

function clang_value_setLongLong(V, Val)
    @ccall libclangex.clang_value_setLongLong(V::CXValue, Val::Clonglong)::Cvoid
end

function clang_value_getLongLong(V)
    @ccall libclangex.clang_value_getLongLong(V::CXValue)::Clonglong
end

function clang_value_setULongLong(V, Val)
    @ccall libclangex.clang_value_setULongLong(V::CXValue, Val::Culonglong)::Cvoid
end

function clang_value_getULongLong(V)
    @ccall libclangex.clang_value_getULongLong(V::CXValue)::Culonglong
end

function clang_value_setFloat(V, Val)
    @ccall libclangex.clang_value_setFloat(V::CXValue, Val::Cfloat)::Cvoid
end

function clang_value_getFloat(V)
    @ccall libclangex.clang_value_getFloat(V::CXValue)::Cfloat
end

function clang_value_setDouble(V, Val)
    @ccall libclangex.clang_value_setDouble(V::CXValue, Val::Cdouble)::Cvoid
end

function clang_value_getDouble(V)
    @ccall libclangex.clang_value_getDouble(V::CXValue)::Cdouble
end

function clang_value_setLongDouble(V, Val)
    @ccall libclangex.clang_value_setLongDouble(V::CXValue, Val::Float64)::Cvoid
end

function clang_value_getLongDouble(V)
    @ccall libclangex.clang_value_getLongDouble(V::CXValue)::Float64
end

function clang_HeaderSearch_PrintStats(HS)
    @ccall libclangex.clang_HeaderSearch_PrintStats(HS::CXHeaderSearch)::Cvoid
end

function clang_HeaderSearchOptions_GetResourceDirLength(HSO)
    @ccall libclangex.clang_HeaderSearchOptions_GetResourceDirLength(HSO::CXHeaderSearchOptions)::Csize_t
end

function clang_HeaderSearchOptions_GetResourceDir(HSO, ResourcesDir, N)
    @ccall libclangex.clang_HeaderSearchOptions_GetResourceDir(HSO::CXHeaderSearchOptions, ResourcesDir::Ptr{Cchar}, N::Csize_t)::Cvoid
end

function clang_HeaderSearchOptions_SetResourceDir(HSO, ResourcesDir, N)
    @ccall libclangex.clang_HeaderSearchOptions_SetResourceDir(HSO::CXHeaderSearchOptions, ResourcesDir::Ptr{Cchar}, N::Csize_t)::Cvoid
end

function clang_HeaderSearchOptions_PrintStats(HSO)
    @ccall libclangex.clang_HeaderSearchOptions_PrintStats(HSO::CXHeaderSearchOptions)::Cvoid
end

function clang_Lexer_create(FID, FromFile, SM, langOpts)
    @ccall libclangex.clang_Lexer_create(FID::CXFileID, FromFile::LLVMMemoryBufferRef, SM::CXSourceManager, langOpts::CXLangOptions)::CXLexer
end

function clang_Lexer_dispose(Lex)
    @ccall libclangex.clang_Lexer_dispose(Lex::CXLexer)::Cvoid
end

function clang_Preprocessor_getHeaderSearchInfo(PP)
    @ccall libclangex.clang_Preprocessor_getHeaderSearchInfo(PP::CXPreprocessor)::CXHeaderSearch
end

function clang_Preprocessor_EnterMainSourceFile(PP)
    @ccall libclangex.clang_Preprocessor_EnterMainSourceFile(PP::CXPreprocessor)::Cvoid
end

function clang_Preprocessor_EnterSourceFile(PP, FID, Loc)
    @ccall libclangex.clang_Preprocessor_EnterSourceFile(PP::CXPreprocessor, FID::CXFileID, Loc::CXSourceLocation_)::Bool
end

function clang_Preprocessor_EndSourceFile(PP)
    @ccall libclangex.clang_Preprocessor_EndSourceFile(PP::CXPreprocessor)::Cvoid
end

function clang_Preprocessor_PrintStats(PP)
    @ccall libclangex.clang_Preprocessor_PrintStats(PP::CXPreprocessor)::Cvoid
end

function clang_Preprocessor_InitializeBuiltins(PP)
    @ccall libclangex.clang_Preprocessor_InitializeBuiltins(PP::CXPreprocessor)::Cvoid
end

function clang_Preprocessor_enableIncrementalProcessing(PP)
    @ccall libclangex.clang_Preprocessor_enableIncrementalProcessing(PP::CXPreprocessor)::Cvoid
end

function clang_Preprocessor_isIncrementalProcessingEnabled(PP)
    @ccall libclangex.clang_Preprocessor_isIncrementalProcessingEnabled(PP::CXPreprocessor)::Bool
end

function clang_Preprocessor_DumpToken(PP, Tok, DumpFlags)
    @ccall libclangex.clang_Preprocessor_DumpToken(PP::CXPreprocessor, Tok::CXToken_, DumpFlags::Bool)::Cvoid
end

function clang_Preprocessor_DumpLocation(PP, Loc)
    @ccall libclangex.clang_Preprocessor_DumpLocation(PP::CXPreprocessor, Loc::CXSourceLocation_)::Cvoid
end

function clang_PreprocessorOptions_getIncludesNum(PPO)
    @ccall libclangex.clang_PreprocessorOptions_getIncludesNum(PPO::CXPreprocessorOptions)::Csize_t
end

function clang_PreprocessorOptions_getIncludes(PPO, IncsOut, Num)
    @ccall libclangex.clang_PreprocessorOptions_getIncludes(PPO::CXPreprocessorOptions, IncsOut::Ptr{Ptr{Cchar}}, Num::Csize_t)::Cvoid
end

function clang_PreprocessorOptions_PrintStats(PPO)
    @ccall libclangex.clang_PreprocessorOptions_PrintStats(PPO::CXPreprocessorOptions)::Cvoid
end

function clang_Token_getAnnotationValue(Tok)
    @ccall libclangex.clang_Token_getAnnotationValue(Tok::CXToken_)::CXAnnotationValue
end

function clang_Token_getLocation(Tok)
    @ccall libclangex.clang_Token_getLocation(Tok::CXToken_)::CXSourceLocation_
end

function clang_Token_getAnnotationEndLoc(Tok)
    @ccall libclangex.clang_Token_getAnnotationEndLoc(Tok::CXToken_)::CXSourceLocation_
end

function clang_Token_getName(Tok)
    @ccall libclangex.clang_Token_getName(Tok::CXToken_)::Ptr{Cchar}
end

function clang_Token_getIdentifierInfo(Tok)
    @ccall libclangex.clang_Token_getIdentifierInfo(Tok::CXToken_)::CXIdentifierInfo
end

function clang_Token_isKind_eof(Tok)
    @ccall libclangex.clang_Token_isKind_eof(Tok::CXToken_)::Bool
end

function clang_Token_isKind_annot_repl_input_end(Tok)
    @ccall libclangex.clang_Token_isKind_annot_repl_input_end(Tok::CXToken_)::Bool
end

function clang_Token_isKind_identifier(Tok)
    @ccall libclangex.clang_Token_isKind_identifier(Tok::CXToken_)::Bool
end

function clang_Token_isKind_coloncolon(Tok)
    @ccall libclangex.clang_Token_isKind_coloncolon(Tok::CXToken_)::Bool
end

function clang_Token_isKind_annot_cxxscope(Tok)
    @ccall libclangex.clang_Token_isKind_annot_cxxscope(Tok::CXToken_)::Bool
end

function clang_Token_isKind_annot_typename(Tok)
    @ccall libclangex.clang_Token_isKind_annot_typename(Tok::CXToken_)::Bool
end

function clang_Token_isKind_annot_template_id(Tok)
    @ccall libclangex.clang_Token_isKind_annot_template_id(Tok::CXToken_)::Bool
end

function clang_Token_isKind_kw_enum(Tok)
    @ccall libclangex.clang_Token_isKind_kw_enum(Tok::CXToken_)::Bool
end

function clang_Token_isKind_kw_typename(Tok)
    @ccall libclangex.clang_Token_isKind_kw_typename(Tok::CXToken_)::Bool
end

function clang_ParseAST(Sema, PrintStats, SkipFunctionBodies)
    @ccall libclangex.clang_ParseAST(Sema::CXSema, PrintStats::Bool, SkipFunctionBodies::Bool)::Cvoid
end

@enum CXDeclSpecContext::UInt32 begin
    CXDeclSpecContext_DSC_normal = 0
    CXDeclSpecContext_DSC_class = 1
    CXDeclSpecContext_DSC_type_specifier = 2
    CXDeclSpecContext_DSC_trailing = 3
    CXDeclSpecContext_DSC_alias_declaration = 4
    CXDeclSpecContext_DSC_conv_operator = 5
    CXDeclSpecContext_DSC_top_level = 6
    CXDeclSpecContext_DSC_template_param = 7
    CXDeclSpecContext_DSC_template_arg = 8
    CXDeclSpecContext_DSC_template_type_arg = 9
    CXDeclSpecContext_DSC_objc_method_result = 10
    CXDeclSpecContext_DSC_condition = 11
    CXDeclSpecContext_DSC_association = 12
    CXDeclSpecContext_DSC_new = 13
end

function clang_Parser_create(PP, Actions, SkipFunctionBodies)
    @ccall libclangex.clang_Parser_create(PP::CXPreprocessor, Actions::CXSema, SkipFunctionBodies::Bool)::CXParser
end

function clang_Parser_dispose(P)
    @ccall libclangex.clang_Parser_dispose(P::CXParser)::Cvoid
end

function clang_Parser_Initialize(P)
    @ccall libclangex.clang_Parser_Initialize(P::CXParser)::Cvoid
end

function clang_Parser_getLangOpts(P)
    @ccall libclangex.clang_Parser_getLangOpts(P::CXParser)::CXLangOptions
end

function clang_Parser_getTargetInfo(P)
    @ccall libclangex.clang_Parser_getTargetInfo(P::CXParser)::CXTargetInfo_
end

function clang_Parser_getPreprocessor(P)
    @ccall libclangex.clang_Parser_getPreprocessor(P::CXParser)::CXPreprocessor
end

function clang_Parser_getActions(P)
    @ccall libclangex.clang_Parser_getActions(P::CXParser)::CXSema
end

function clang_Parser_getCurToken(P)
    @ccall libclangex.clang_Parser_getCurToken(P::CXParser)::CXToken_
end

function clang_Parser_NextToken(P)
    @ccall libclangex.clang_Parser_NextToken(P::CXParser)::CXToken_
end

function clang_Parser_getCurScope(P)
    @ccall libclangex.clang_Parser_getCurScope(P::CXParser)::CXScope
end

function clang_Parser_ConsumeToken(P)
    @ccall libclangex.clang_Parser_ConsumeToken(P::CXParser)::CXSourceLocation_
end

function clang_Parser_ConsumeAnyToken(P)
    @ccall libclangex.clang_Parser_ConsumeAnyToken(P::CXParser)::CXSourceLocation_
end

function clang_Parser_TryAnnotateTypeOrScopeToken(P, AllowImplicitTypename)
    @ccall libclangex.clang_Parser_TryAnnotateTypeOrScopeToken(P::CXParser, AllowImplicitTypename::Bool)::Bool
end

function clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(P, SS, IsNewScope, AllowImplicitTypename)
    @ccall libclangex.clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(P::CXParser, SS::CXCXXScopeSpec, IsNewScope::Bool, AllowImplicitTypename::Bool)::Bool
end

function clang_Parser_TryAnnotateCXXScopeToken(P, EnteringContext)
    @ccall libclangex.clang_Parser_TryAnnotateCXXScopeToken(P::CXParser, EnteringContext::Bool)::Bool
end

function clang_Parser_TryAnnotateOptionalCXXScopeToken(P, EnteringContext)
    @ccall libclangex.clang_Parser_TryAnnotateOptionalCXXScopeToken(P::CXParser, EnteringContext::Bool)::Bool
end

function clang_Parser_getTypeAnnotation(Tok)
    @ccall libclangex.clang_Parser_getTypeAnnotation(Tok::CXToken_)::CXQualType
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
    CXDeclaratorContext_Association = 27
end

function clang_CXXScopeSpec_create()
    @ccall libclangex.clang_CXXScopeSpec_create()::CXCXXScopeSpec
end

function clang_CXXScopeSpec_dispose(SS)
    @ccall libclangex.clang_CXXScopeSpec_dispose(SS::CXCXXScopeSpec)::Cvoid
end

function clang_CXXScopeSpec_clear(SS)
    @ccall libclangex.clang_CXXScopeSpec_clear(SS::CXCXXScopeSpec)::Cvoid
end

function clang_CXXScopeSpec_setBeginLoc(SS, Loc)
    @ccall libclangex.clang_CXXScopeSpec_setBeginLoc(SS::CXCXXScopeSpec, Loc::CXSourceLocation_)::Cvoid
end

function clang_CXXScopeSpec_setEndLoc(SS, Loc)
    @ccall libclangex.clang_CXXScopeSpec_setEndLoc(SS::CXCXXScopeSpec, Loc::CXSourceLocation_)::Cvoid
end

function clang_CXXScopeSpec_getBeginLoc(SS)
    @ccall libclangex.clang_CXXScopeSpec_getBeginLoc(SS::CXCXXScopeSpec)::CXSourceLocation_
end

function clang_CXXScopeSpec_getEndLoc(SS)
    @ccall libclangex.clang_CXXScopeSpec_getEndLoc(SS::CXCXXScopeSpec)::CXSourceLocation_
end

function clang_CXXScopeSpec_getScopeRep(SS)
    @ccall libclangex.clang_CXXScopeSpec_getScopeRep(SS::CXCXXScopeSpec)::CXNestedNameSpecifier
end

function clang_CXXScopeSpec_isEmpty(SS)
    @ccall libclangex.clang_CXXScopeSpec_isEmpty(SS::CXCXXScopeSpec)::Bool
end

function clang_CXXScopeSpec_isNotEmpty(SS)
    @ccall libclangex.clang_CXXScopeSpec_isNotEmpty(SS::CXCXXScopeSpec)::Bool
end

function clang_CXXScopeSpec_isInvalid(SS)
    @ccall libclangex.clang_CXXScopeSpec_isInvalid(SS::CXCXXScopeSpec)::Bool
end

function clang_CXXScopeSpec_isValid(SS)
    @ccall libclangex.clang_CXXScopeSpec_isValid(SS::CXCXXScopeSpec)::Bool
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

function clang_LookupResult_create(S, Name, NameLoc, LookupKind)
    @ccall libclangex.clang_LookupResult_create(S::CXSema, Name::CXDeclarationName, NameLoc::CXSourceLocation_, LookupKind::CXLookupNameKind)::CXLookupResult
end

function clang_LookupResult_dispose(LR)
    @ccall libclangex.clang_LookupResult_dispose(LR::CXLookupResult)::Cvoid
end

function clang_LookupResult_isForRedeclaration(LR)
    @ccall libclangex.clang_LookupResult_isForRedeclaration(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isTemplateNameLookup(LR)
    @ccall libclangex.clang_LookupResult_isTemplateNameLookup(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isAmbiguous(LR)
    @ccall libclangex.clang_LookupResult_isAmbiguous(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isSingleResult(LR)
    @ccall libclangex.clang_LookupResult_isSingleResult(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isOverloadedResult(LR)
    @ccall libclangex.clang_LookupResult_isOverloadedResult(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isUnresolvableResult(LR)
    @ccall libclangex.clang_LookupResult_isUnresolvableResult(LR::CXLookupResult)::Bool
end

function clang_LookupResult_isClassLookup(LR)
    @ccall libclangex.clang_LookupResult_isClassLookup(LR::CXLookupResult)::Bool
end

function clang_LookupResult_resolveKind(LR)
    @ccall libclangex.clang_LookupResult_resolveKind(LR::CXLookupResult)::Cvoid
end

function clang_LookupResult_isSingleTagDecl(LR)
    @ccall libclangex.clang_LookupResult_isSingleTagDecl(LR::CXLookupResult)::Bool
end

function clang_LookupResult_clear(LR, LookupKind)
    @ccall libclangex.clang_LookupResult_clear(LR::CXLookupResult, LookupKind::CXLookupNameKind)::Cvoid
end

function clang_LookupResult_setLookupName(LR, DN)
    @ccall libclangex.clang_LookupResult_setLookupName(LR::CXLookupResult, DN::CXDeclarationName)::Cvoid
end

function clang_LookupResult_getLookupName(LR)
    @ccall libclangex.clang_LookupResult_getLookupName(LR::CXLookupResult)::CXDeclarationName
end

function clang_LookupResult_dump(LR)
    @ccall libclangex.clang_LookupResult_dump(LR::CXLookupResult)::Cvoid
end

function clang_LookupResult_empty(LR)
    @ccall libclangex.clang_LookupResult_empty(LR::CXLookupResult)::Bool
end

function clang_LookupResult_getRepresentativeDecl(LR)
    @ccall libclangex.clang_LookupResult_getRepresentativeDecl(LR::CXLookupResult)::CXNamedDecl
end

function clang_LookupResult_getNum(LR)
    @ccall libclangex.clang_LookupResult_getNum(LR::CXLookupResult)::Csize_t
end

function clang_LookupResult_getResults(LR, Decls, N)
    @ccall libclangex.clang_LookupResult_getResults(LR::CXLookupResult, Decls::Ptr{CXNamedDecl}, N::Csize_t)::Cvoid
end

function clang_LookupResult_getResult(LR)
    @ccall libclangex.clang_LookupResult_getResult(LR::CXLookupResult)::CXNamedDecl
end

function clang_Scope_dump(S)
    @ccall libclangex.clang_Scope_dump(S::CXScope)::Cvoid
end

function clang_Scope_getParent(S)
    @ccall libclangex.clang_Scope_getParent(S::CXScope)::CXScope
end

function clang_Scope_getDepth(S)
    @ccall libclangex.clang_Scope_getDepth(S::CXScope)::Cuint
end

function clang_Sema_setCollectStats(S, ShouldCollect)
    @ccall libclangex.clang_Sema_setCollectStats(S::CXSema, ShouldCollect::Bool)::Cvoid
end

function clang_Sema_PrintStats(S)
    @ccall libclangex.clang_Sema_PrintStats(S::CXSema)::Cvoid
end

function clang_Sema_RestoreNestedNameSpecifierAnnotation(S, Annotation, AnnotationRange_begin, AnnotationRange_end, SS)
    @ccall libclangex.clang_Sema_RestoreNestedNameSpecifierAnnotation(S::CXSema, Annotation::Ptr{Cvoid}, AnnotationRange_begin::CXSourceLocation_, AnnotationRange_end::CXSourceLocation_, SS::CXCXXScopeSpec)::Cvoid
end

function clang_sema_getTypeName(S, II, NameLoc, Scp, SS, isClassName, HasTrailingDot, ObjectTypePtr, IsCtorOrDtorName, WantNontrivialTypeSourceInfo, IsClassTemplateDeductionContext, AllowImplicitTypename)
    @ccall libclangex.clang_sema_getTypeName(S::CXSema, II::CXIdentifierInfo, NameLoc::CXSourceLocation_, Scp::CXScope, SS::CXCXXScopeSpec, isClassName::Bool, HasTrailingDot::Bool, ObjectTypePtr::CXQualType, IsCtorOrDtorName::Bool, WantNontrivialTypeSourceInfo::Bool, IsClassTemplateDeductionContext::Bool, AllowImplicitTypename::Bool)::CXQualType
end

function clang_Sema_LookupParsedName(S, R, Sp, SS, AllowBuiltinCreation, EnteringContext)
    @ccall libclangex.clang_Sema_LookupParsedName(S::CXSema, R::CXLookupResult, Sp::CXScope, SS::CXCXXScopeSpec, AllowBuiltinCreation::Bool, EnteringContext::Bool)::Bool
end

function clang_Sema_LookupName(S, R, Sp, AllowBuiltinCreation, ForceNoCPlusPlus)
    @ccall libclangex.clang_Sema_LookupName(S::CXSema, R::CXLookupResult, Sp::CXScope, AllowBuiltinCreation::Bool, ForceNoCPlusPlus::Bool)::Bool
end

function clang_Sema_processWeakTopLevelDecls(Sema, CodeGen)
    @ccall libclangex.clang_Sema_processWeakTopLevelDecls(Sema::CXSema, CodeGen::CXCodeGenerator)::Cvoid
end

function clang_Sema_LookupDefaultConstructor(S, Class)
    @ccall libclangex.clang_Sema_LookupDefaultConstructor(S::CXSema, Class::CXCXXRecordDecl)::CXCXXConstructorDecl
end

function clang_Sema_LookupDestructor(S, Class)
    @ccall libclangex.clang_Sema_LookupDestructor(S::CXSema, Class::CXCXXRecordDecl)::CXCXXDestructorDecl
end

function clang_Stmt_EnableStatistics()
    @ccall libclangex.clang_Stmt_EnableStatistics()::Cvoid
end

function clang_Stmt_PrintStats()
    @ccall libclangex.clang_Stmt_PrintStats()::Cvoid
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
