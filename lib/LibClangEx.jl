module LibClangEx

using ..ClangCompiler: libclangex
using LLVM.API: LLVMModuleRef, LLVMOpaqueModule
using LLVM.API: LLVMOpaqueContext, LLVMContextRef
using LLVM.API: LLVMMemoryBufferRef, LLVMGenericValueRef

const time_t = Clong


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

const CXAnnotationValue = Ptr{Cvoid}

@enum CXTranslationUnitKind::UInt32 begin
    CXTranslationUnitKind_TU_Complete = 0
    CXTranslationUnitKind_TU_Prefix = 1
    CXTranslationUnitKind_TU_Module = 2
end

const CXASTContext = Ptr{Cvoid}

const CXASTConsumer = Ptr{Cvoid}

const CXTranslationUnitDecl = Ptr{Cvoid}

const CXDeclGroupRef = Ptr{Cvoid}

const CXDecl = Ptr{Cvoid}

const CXDeclContext = Ptr{Cvoid}

const CXNamedDecl = Ptr{Cvoid}

const CXValueDecl = Ptr{Cvoid}

const CXTypeDecl = Ptr{Cvoid}

const CXTypedefNameDecl = Ptr{Cvoid}

const CXTagDecl = Ptr{Cvoid}

const CXEnumDecl = Ptr{Cvoid}

const CXTemplateDecl = Ptr{Cvoid}

const CXRedeclarableTemplateDecl = Ptr{Cvoid}

const CXClassTemplateDecl = Ptr{Cvoid}

const CXTemplateParameterList = Ptr{Cvoid}

const CXTemplateArgumentList = Ptr{Cvoid}

const CXRecordDecl = Ptr{Cvoid}

const CXCXXRecordDecl = Ptr{Cvoid}

const CXClassTemplateSpecializationDecl = Ptr{Cvoid}

const CXNestedNameSpecifier = Ptr{Cvoid}

const CXCXXScopeSpec = Ptr{Cvoid}

const CXIdentifierTable = Ptr{Cvoid}

const CXIdentifierInfo = Ptr{Cvoid}

const CXDeclarationName = Ptr{Cvoid}

const CXTemplateName = Ptr{Cvoid}

const CXTemplateArgument = Ptr{Cvoid}

@enum CXTagTypeKind::UInt32 begin
    CXTagTypeKind_TTK_Struct = 0
    CXTagTypeKind_TTK_Interface = 1
    CXTagTypeKind_TTK_Union = 2
    CXTagTypeKind_TTK_Class = 3
    CXTagTypeKind_TTK_Enum = 4
end

@enum CXTemplateName_NameKind::UInt32 begin
    CXTemplateName_NameKind_Template = 0
    CXTemplateName_NameKind_OverloadedTemplate = 1
    CXTemplateName_NameKind_AssumedTemplate = 2
    CXTemplateName_NameKind_QualifiedTemplate = 3
    CXTemplateName_NameKind_DependentTemplate = 4
    CXTemplateName_NameKind_SubstTemplateTemplateParm = 5
    CXTemplateName_NameKind_SubstTemplateTemplateParmPack = 6
end

@enum CXTemplateArgument_ArgKind::UInt32 begin
    CXTemplateArgument_ArgKind_Null = 0
    CXTemplateArgument_ArgKind_Type = 1
    CXTemplateArgument_ArgKind_Declaration = 2
    CXTemplateArgument_ArgKind_NullPtr = 3
    CXTemplateArgument_ArgKind_Integral = 4
    CXTemplateArgument_ArgKind_Template = 5
    CXTemplateArgument_ArgKind_TemplateExpansion = 6
    CXTemplateArgument_ArgKind_Expression = 7
    CXTemplateArgument_ArgKind_Pack = 8
end

const CXType_ = Ptr{Cvoid}

const CXQualType = Ptr{Cvoid}

const CXComplexType = Ptr{Cvoid}

const CXPointerType = Ptr{Cvoid}

const CXReferenceType = Ptr{Cvoid}

const CXLValueReferenceType = Ptr{Cvoid}

const CXRValueReferenceType = Ptr{Cvoid}

const CXMemberPointerType = Ptr{Cvoid}

const CXArrayType = Ptr{Cvoid}

const CXConstantArrayType = Ptr{Cvoid}

const CXIncompleteArrayType = Ptr{Cvoid}

const CXVariableArrayType = Ptr{Cvoid}

const CXDependentSizedArrayType = Ptr{Cvoid}

const CXFunctionType = Ptr{Cvoid}

const CXFunctionNoProtoType = Ptr{Cvoid}

const CXFunctionProtoType = Ptr{Cvoid}

const CXTypedefType = Ptr{Cvoid}

const CXTagType = Ptr{Cvoid}

const CXRecordType = Ptr{Cvoid}

const CXEnumType = Ptr{Cvoid}

const CXTemplateTypeParmType = Ptr{Cvoid}

const CXSubstTemplateTypeParmType = Ptr{Cvoid}

const CXSubstTemplateTypeParmPackType = Ptr{Cvoid}

const CXTemplateSpecializationType = Ptr{Cvoid}

const CXTypeWithKeyword = Ptr{Cvoid}

const CXElaboratedType = Ptr{Cvoid}

const CXDependentNameType = Ptr{Cvoid}

const CXDependentTemplateSpecializationType = Ptr{Cvoid}

const CXDeducedType = Ptr{Cvoid}

const CXCodeGenerator = Ptr{Cvoid}

const CXCodeGenModule = Ptr{Cvoid}

const CXSema = Ptr{Cvoid}

const CXScope = Ptr{Cvoid}

const CXLookupResult = Ptr{Cvoid}

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

const CXParser = Ptr{Cvoid}

const CXFrontendAction = Ptr{Cvoid}

const CXCodeGenAction = Ptr{Cvoid}

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

function clang_ASTConsumer_Initialize(Csr, Ctx)
    ccall((:clang_ASTConsumer_Initialize, libclangex), Cvoid, (CXASTConsumer, CXASTContext), Csr, Ctx)
end

function clang_ASTConsumer_HandleTranslationUnit(Csr, Ctx)
    ccall((:clang_ASTConsumer_HandleTranslationUnit, libclangex), Cvoid, (CXASTConsumer, CXASTContext), Csr, Ctx)
end

function clang_ASTConsumer_PrintStats(Csr)
    ccall((:clang_ASTConsumer_PrintStats, libclangex), Cvoid, (CXASTConsumer,), Csr)
end

function clang_ASTContext_PrintStats(Ctx)
    ccall((:clang_ASTContext_PrintStats, libclangex), Cvoid, (CXASTContext,), Ctx)
end

function clang_ASTContext_getPointerType(Ctx, OpaquePtr)
    ccall((:clang_ASTContext_getPointerType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, OpaquePtr)
end

function clang_ASTContext_getLValueReferenceType(Ctx, OpaquePtr)
    ccall((:clang_ASTContext_getLValueReferenceType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, OpaquePtr)
end

function clang_ASTContext_getRValueReferenceType(Ctx, OpaquePtr)
    ccall((:clang_ASTContext_getRValueReferenceType, libclangex), CXQualType, (CXASTContext, CXQualType), Ctx, OpaquePtr)
end

function clang_ASTContext_getMemberPointerType(Ctx, OpaquePtr, Cls)
    ccall((:clang_ASTContext_getMemberPointerType, libclangex), CXQualType, (CXASTContext, CXQualType, CXType_), Ctx, OpaquePtr, Cls)
end

function clang_ASTContext_getIdents(Ctx)
    ccall((:clang_ASTContext_getIdents, libclangex), CXIdentifierTable, (CXASTContext,), Ctx)
end

function clang_ASTContext_getTypeSize(Ctx, T)
    ccall((:clang_ASTContext_getTypeSize, libclangex), UInt64, (CXASTContext, CXType_), Ctx, T)
end

function clang_ASTContext_getTypeDeclType(Ctx, Decl, PrevDecl)
    ccall((:clang_ASTContext_getTypeDeclType, libclangex), CXQualType, (CXASTContext, CXTypeDecl, CXTypeDecl), Ctx, Decl, PrevDecl)
end

function clang_ASTContext_getRecordType(Ctx, Decl)
    ccall((:clang_ASTContext_getRecordType, libclangex), CXQualType, (CXASTContext, CXRecordDecl), Ctx, Decl)
end

function clang_IdentifierTable_PrintStats(IT)
    ccall((:clang_IdentifierTable_PrintStats, libclangex), Cvoid, (CXIdentifierTable,), IT)
end

function clang_IdentifierTable_get(Idents, Name)
    ccall((:clang_IdentifierTable_get, libclangex), CXIdentifierInfo, (CXIdentifierTable, Ptr{Cchar}), Idents, Name)
end

function clang_DeclarationName_create()
    ccall((:clang_DeclarationName_create, libclangex), CXDeclarationName, ())
end

function clang_DeclarationName_createFromIdentifierInfo(IDInfo)
    ccall((:clang_DeclarationName_createFromIdentifierInfo, libclangex), CXDeclarationName, (CXIdentifierInfo,), IDInfo)
end

function clang_LookupResult_setLookupName(LR, DN)
    ccall((:clang_LookupResult_setLookupName, libclangex), Cvoid, (CXLookupResult, CXDeclarationName), LR, DN)
end

function clang_LookupResult_getLookupName(LR)
    ccall((:clang_LookupResult_getLookupName, libclangex), CXDeclarationName, (CXLookupResult,), LR)
end

function clang_DeclarationName_dump(DN)
    ccall((:clang_DeclarationName_dump, libclangex), Cvoid, (CXDeclarationName,), DN)
end

function clang_DeclarationName_isEmpty(DN)
    ccall((:clang_DeclarationName_isEmpty, libclangex), Bool, (CXDeclarationName,), DN)
end

function clang_DeclarationName_getAsString(DN)
    ccall((:clang_DeclarationName_getAsString, libclangex), Ptr{Cchar}, (CXDeclarationName,), DN)
end

function clang_DeclarationName_disposeString(Str)
    ccall((:clang_DeclarationName_disposeString, libclangex), Cvoid, (Ptr{Cchar},), Str)
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

function clang_Decl_isTemplateDecl(DC)
    ccall((:clang_Decl_isTemplateDecl, libclangex), Bool, (CXDecl,), DC)
end

function clang_Decl_getDescribedTemplate(DC)
    ccall((:clang_Decl_getDescribedTemplate, libclangex), CXTemplateDecl, (CXDecl,), DC)
end

function clang_Decl_getDescribedTemplateParams(DC)
    ccall((:clang_Decl_getDescribedTemplateParams, libclangex), CXTemplateParameterList, (CXDecl,), DC)
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

function clang_Decl_castToClassTemplateDecl(DC)
    ccall((:clang_Decl_castToClassTemplateDecl, libclangex), CXClassTemplateDecl, (CXDecl,), DC)
end

function clang_Decl_castToValueDecl(DC)
    ccall((:clang_Decl_castToValueDecl, libclangex), CXValueDecl, (CXDecl,), DC)
end

function clang_NamedDecl_getIdentifier(ND)
    ccall((:clang_NamedDecl_getIdentifier, libclangex), CXIdentifierInfo, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getName(ND)
    ccall((:clang_NamedDecl_getName, libclangex), Ptr{Cchar}, (CXNamedDecl,), ND)
end

function clang_NamedDecl_setDeclName(ND, DN)
    ccall((:clang_NamedDecl_setDeclName, libclangex), Cvoid, (CXNamedDecl, CXDeclarationName), ND, DN)
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

function clang_NamedDecl_hasExternalFormalLinkage(ND)
    ccall((:clang_NamedDecl_hasExternalFormalLinkage, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isExternallyVisible(ND)
    ccall((:clang_NamedDecl_isExternallyVisible, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isExternallyDeclarable(ND)
    ccall((:clang_NamedDecl_isExternallyDeclarable, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getUnderlyingDecl(ND)
    ccall((:clang_NamedDecl_getUnderlyingDecl, libclangex), CXNamedDecl, (CXNamedDecl,), ND)
end

function clang_NamedDecl_getMostRecentDecl(ND)
    ccall((:clang_NamedDecl_getMostRecentDecl, libclangex), CXNamedDecl, (CXNamedDecl,), ND)
end

function clang_NamedDecl_isOutOfLine(ND)
    ccall((:clang_NamedDecl_isOutOfLine, libclangex), Bool, (CXNamedDecl,), ND)
end

function clang_NamedDecl_castToTypeDecl(ND)
    ccall((:clang_NamedDecl_castToTypeDecl, libclangex), CXTypeDecl, (CXNamedDecl,), ND)
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

function clang_TypedefNameDecl_getUnderlyingType(TND)
    ccall((:clang_TypedefNameDecl_getUnderlyingType, libclangex), CXQualType, (CXTypedefNameDecl,), TND)
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

function clang_TagDecl_castToDeclContext(TD)
    ccall((:clang_TagDecl_castToDeclContext, libclangex), CXDeclContext, (CXTagDecl,), TD)
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

function clang_TagDecl_isBeingDefined(TD)
    ccall((:clang_TagDecl_isBeingDefined, libclangex), Bool, (CXTagDecl,), TD)
end

function clang_TagDecl_isFreeStanding(TD)
    ccall((:clang_TagDecl_isFreeStanding, libclangex), Bool, (CXTagDecl,), TD)
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

function clang_TagDecl_getQualifier(TD)
    ccall((:clang_TagDecl_getQualifier, libclangex), CXNestedNameSpecifier, (CXTagDecl,), TD)
end

function clang_TagDecl_getNumTemplateParameterLists(TD)
    ccall((:clang_TagDecl_getNumTemplateParameterLists, libclangex), Cuint, (CXTagDecl,), TD)
end

function clang_TagDecl_getTemplateParameterList(TD, i)
    ccall((:clang_TagDecl_getTemplateParameterList, libclangex), CXTemplateParameterList, (CXTagDecl, Cuint), TD, i)
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

function clang_EnumDecl_getIntegerType(ED)
    ccall((:clang_EnumDecl_getIntegerType, libclangex), CXQualType, (CXEnumDecl,), ED)
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

function clang_RecordDecl_getPreviousDecl(RD)
    ccall((:clang_RecordDecl_getPreviousDecl, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_getMostRecentDecl(RD)
    ccall((:clang_RecordDecl_getMostRecentDecl, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_hasFlexibleArrayMember(RD)
    ccall((:clang_RecordDecl_hasFlexibleArrayMember, libclangex), Bool, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isAnonymousStructOrUnion(RD)
    ccall((:clang_RecordDecl_isAnonymousStructOrUnion, libclangex), Bool, (CXRecordDecl,), RD)
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

function clang_RecordDecl_getDefinition(RD)
    ccall((:clang_RecordDecl_getDefinition, libclangex), CXRecordDecl, (CXRecordDecl,), RD)
end

function clang_RecordDecl_isOrContainsUnion(RD)
    ccall((:clang_RecordDecl_isOrContainsUnion, libclangex), Bool, (CXRecordDecl,), RD)
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

function clang_ClassTemplateSpecializationDecl_Create(Context, TK, DC, StartLoc, IdLoc, SpecializedTemplate, Args, PrevDecl)
    ccall((:clang_ClassTemplateSpecializationDecl_Create, libclangex), CXClassTemplateSpecializationDecl, (CXASTContext, CXTagTypeKind, CXDeclContext, CXSourceLocation_, CXSourceLocation_, CXClassTemplateDecl, CXTemplateArgumentList, CXClassTemplateSpecializationDecl), Context, TK, DC, StartLoc, IdLoc, SpecializedTemplate, Args, PrevDecl)
end

function clang_ClassTemplateSpecializationDecl_getTemplateArgs(CTSD)
    ccall((:clang_ClassTemplateSpecializationDecl_getTemplateArgs, libclangex), CXTemplateArgumentList, (CXClassTemplateSpecializationDecl,), CTSD)
end

function clang_ClassTemplateSpecializationDecl_setTemplateArgs(CTSD, TAL)
    ccall((:clang_ClassTemplateSpecializationDecl_setTemplateArgs, libclangex), Cvoid, (CXClassTemplateSpecializationDecl, CXTemplateArgumentList), CTSD, TAL)
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

@enum CXInit_Error::UInt32 begin
    CXInit_NoError = 0
    CXInit_CanNotCreate = 1
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

function clang_Scope_dump(S)
    ccall((:clang_Scope_dump, libclangex), Cvoid, (CXScope,), S)
end

function clang_Scope_getParent(S)
    ccall((:clang_Scope_getParent, libclangex), CXScope, (CXScope,), S)
end

function clang_Scope_getDepth(S)
    ccall((:clang_Scope_getDepth, libclangex), Cuint, (CXScope,), S)
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

function clang_LookupResult_dump(LR)
    ccall((:clang_LookupResult_dump, libclangex), Cvoid, (CXLookupResult,), LR)
end

function clang_LookupResult_empty(LR)
    ccall((:clang_LookupResult_empty, libclangex), Bool, (CXLookupResult,), LR)
end

function clang_LookupResult_getRepresentativeDecl(LR)
    ccall((:clang_LookupResult_getRepresentativeDecl, libclangex), CXNamedDecl, (CXLookupResult,), LR)
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

function clang_SourceLocation_getLocWithOffset(Loc, Offset)
    ccall((:clang_SourceLocation_getLocWithOffset, libclangex), CXSourceLocation_, (CXSourceLocation_, Cint), Loc, Offset)
end

function clang_Parser_tryParseAndSkipInvalidOrParsedDecl(Parser, CodeGen)
    ccall((:clang_Parser_tryParseAndSkipInvalidOrParsedDecl, libclangex), Bool, (CXParser, CXCodeGenerator), Parser, CodeGen)
end

function clang_Sema_processWeakTopLevelDecls(Sema, CodeGen)
    ccall((:clang_Sema_processWeakTopLevelDecls, libclangex), Cvoid, (CXSema, CXCodeGenerator), Sema, CodeGen)
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
    ccall((:clang_QualType_addConst, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_addVolatile(OpaquePtr)
    ccall((:clang_QualType_addVolatile, libclangex), Cvoid, (CXQualType,), OpaquePtr)
end

function clang_QualType_addRestrict(OpaquePtr)
    ccall((:clang_QualType_addRestrict, libclangex), Cvoid, (CXQualType,), OpaquePtr)
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
    ccall((:clang_QualType_getAsString, libclangex), Ptr{Cchar}, (CXQualType,), OpaquePtr)
end

function clang_QualType_disposeString(Str)
    ccall((:clang_QualType_disposeString, libclangex), Cvoid, (Ptr{Cchar},), Str)
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

function clang_PointerType_getPointeeType(T)
    ccall((:clang_PointerType_getPointeeType, libclangex), CXQualType, (CXPointerType,), T)
end

function clang_MemberPointerType_getPointeeType(T)
    ccall((:clang_MemberPointerType_getPointeeType, libclangex), CXQualType, (CXMemberPointerType,), T)
end

function clang_MemberPointerType_getClass(T)
    ccall((:clang_MemberPointerType_getClass, libclangex), CXType_, (CXMemberPointerType,), T)
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

function clang_ParseAST(Sema, PrintStats, SkipFunctionBodies)
    ccall((:clang_ParseAST, libclangex), Cvoid, (CXSema, Bool, Bool), Sema, PrintStats, SkipFunctionBodies)
end

# exports
const PREFIXES = ["clang", "CX"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
