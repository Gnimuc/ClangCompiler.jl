# Decl
function getLocation(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getLocation(x))
end

function getBeginLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getBeginLoc(x))
end

function getEndLoc(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getEndLoc(x))
end

function getDeclKindName(x::AbstractDecl)
    @check_ptrs x
    return unsafe_string(clang_Decl_getDeclKindName(x))
end

function getNextDeclInContext(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNextDeclInContext(x))
end

function getDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getDeclContext(x))
end

function getNonClosureContext(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getNonClosureContext(x))
end

function getTranslationUnitDecl(x::AbstractDecl)
    @check_ptrs x
    return TranslationUnitDecl(clang_Decl_getTranslationUnitDecl(x))
end

function isInAnonymousNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInAnonymousNamespace(x)
end

function isInStdNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInStdNamespace(x)
end

function getASTContext(x::AbstractDecl)
    @check_ptrs x
    return ASTContext(clang_Decl_getASTContext(x))
end

function getLangOpts(x::AbstractDecl)
    @check_ptrs x
    return LangOptions(clang_Decl_getLangOpts(x))
end

function getLexicalDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getLexicalDeclContext(x))
end

function isOutOfLine(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isOutOfLine(x)
end

function setDeclContext(x::AbstractDecl, ctx::DeclContext)
    @check_ptrs x ctx
    return clang_Decl_setDeclContext(x, ctx)
end

function setLexicalDeclContext(x::AbstractDecl, ctx::DeclContext)
    @check_ptrs x ctx
    return clang_Decl_setLexicalDeclContext(x, ctx)
end

function isTemplated(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplated(x)
end

function getTemplateDepth(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getTemplateDepth(x)
end

function isDefinedOutsideFunctionOrMethod(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isDefinedOutsideFunctionOrMethod(x)
end

function isInLocalScopeForInstantiation(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInLocalScopeForInstantiation(x)
end

function getParentFunctionOrMethod(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getParentFunctionOrMethod(x))
end

function getCanonicalDecl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getCanonicalDecl(x))
end

function isCanonicalDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCanonicalDecl(x)
end

function getPreviousDecl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getPreviousDecl(x))
end

function isFirstDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFirstDecl(x)
end

function getMostRecentDecl(x::AbstractDecl)
    @check_ptrs x
    return Decl(clang_Decl_getMostRecentDecl(x))
end

function isTemplateParameter(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateParameter(x)
end

function isTemplateParameterPack(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateParameterPack(x)
end

function isParameterPack(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isParameterPack(x)
end

function isTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateDecl(x)
end

function getDescribedTemplate(x::AbstractDecl)
    @check_ptrs x
    return TemplateDecl(clang_Decl_getDescribedTemplate(x))
end

function getDescribedTemplateParams(x::AbstractDecl)
    @check_ptrs x
    return TemplateParameterList(clang_Decl_getDescribedTemplateParams(x))
end

function getAsFunction(x::AbstractDecl)
    @check_ptrs x
    return FunctionDecl(clang_Decl_getAsFunction(x))
end

# function dump(x::AbstractDecl)
#     @check_ptrs x
#     return clang_Decl_dump(x)
# end

function dumpColor(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_dumpColor(x)
end

function getID(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getID(x)
end

function getFunctionType(x::AbstractDecl, BlocksToo=true)
    @check_ptrs x
    return FunctionType(clang_Decl_getFunctionType(x, BlocksToo))
end

function EnableStatistics(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_EnableStatistics(x)
end

function PrintStats(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_PrintStats(x)
end

# Decl Cast
function castToDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_castToDeclContext(x))
end

function castFromDeclContext(x::DeclContext)
    @check_ptrs x
    return Decl(clang_Decl_castFromDeclContext(x))
end

function ClassTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return ClassTemplateDecl(clang_Decl_castToClassTemplateDecl(x))
end

function ValueDecl(x::AbstractDecl)
    @check_ptrs x
    return ValueDecl(clang_Decl_castToValueDecl(x))
end

# DeclContext
function getParentASTContext(x::DeclContext)
    @check_ptrs x
    return ASTContext(clang_DeclContext_getParentASTContext(x))
end

function addDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDecl(x, decl)
end

function addDeclInternal(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDeclInternal(x, decl)
end

function addHiddenDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addHiddenDecl(x, decl)
end

function removeDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_removeDecl(x, decl)
end

function containsDecl(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDecl(x, decl)
end

function getDeclKindName(x::DeclContext)
    @check_ptrs x
    return unsafe_string(clang_DeclContext_getDeclKindName(x))
end

function getParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getParent(x)
end

function getLexicalParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLexicalParent(x)
end

function getLookupParent(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getLookupParent(x)
end

function isClosure(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isClosure(x)
end

function isFunctionOrMethod(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFunctionOrMethod(x)
end

function isLookupContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isLookupContext(x)
end

function isFileContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isFileContext(x)
end

function isTranslationUnit(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTranslationUnit(x)
end

function isRecord(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isRecord(x)
end

function isNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isNamespace(x)
end

function isStdNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isStdNamespace(x)
end

function isInlineNamespace(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isInlineNamespace(x)
end

function is_dependent_context(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isDependentContext(x)
end

function isTransparentContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isTransparentContext(x)
end

function isExternCContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCContext(x)
end

function isExternCXXContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCXXContext(x)
end

function Equals(x::DeclContext, y::DeclContext)
    @check_ptrs x y
    return clang_DeclContext_Equals(x, y)
end

function getPrimaryContext(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getPrimaryContext(x))
end

function dumpDeclContext(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpDeclContext(x)
end

function dumpLookups(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpLookups(x)
end

function decl_iterator_begin(x::DeclContext)
    @check_ptrs x
    return Decl(clang_DeclContext_decl_iterator_begin(x))
end

# DeclContext Cast
function TagDecl(x::DeclContext)
    @check_ptrs x
    return TagDecl(clang_DeclContext_castToTagDecl(x))
end

function RecordDecl(x::DeclContext)
    @check_ptrs x
    return RecordDecl(clang_DeclContext_castToRecordDecl(x))
end

function CXXRecordDecl(x::DeclContext)
    @check_ptrs x
    return CXXRecordDecl(clang_DeclContext_castToCXXRecordDecl(x))
end
