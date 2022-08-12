# TranslationUnitDecl
function getASTContext(x::TranslationUnitDecl)
    @check_ptrs x
    return ASTContext(clang_TranslationUnitDecl_getASTContext(x))
end

function getAnonymousNamespace(x::TranslationUnitDecl)
    @check_ptrs x
    return NamespaceDecl(clang_TranslationUnitDecl_getAnonymousNamespace(x))
end

function getAnonymousNamespace(x::TranslationUnitDecl, namespace::NamespaceDecl)
    @check_ptrs x namespace
    return clang_TranslationUnitDecl_setAnonymousNamespace(x, namespace)
end

# PragmaCommentDecl
function getCommentKind(x::PragmaCommentDecl)
    @check_ptrs x
    return clang_PragmaCommentDecl_getCommentKind(x)
end

function getArg(x::PragmaCommentDecl)
    @check_ptrs x
    return unsafe_string(clang_PragmaCommentDecl_getArg(x))
end

# PragmaDetectMismatchDecl
function getName(x::PragmaCommentDecl)
    @check_ptrs x
    return unsafe_string(clang_PragmaDetectMismatchDecl_getName(x))
end

function getValue(x::PragmaCommentDecl)
    @check_ptrs x
    return unsafe_string(clang_PragmaDetectMismatchDecl_getValue(x))
end

# NamedDecl
function getIdentifier(x::AbstractNamedDecl)
    @check_ptrs x
    return IdentifierInfo(clang_NamedDecl_getIdentifier(x))
end

function getName(x::AbstractNamedDecl)
    @check_ptrs x
    return unsafe_string(clang_NamedDecl_getName(x))
end

function getDeclName(x::AbstractNamedDecl)
    @check_ptrs x
    return DeclarationName(clang_NamedDecl_getDeclName(x))
end

function setDeclName(x::AbstractNamedDecl, name::DeclarationName)
    @check_ptrs x
    return clang_NamedDecl_setDeclName(x, name)
end

function declarationReplaces(x::AbstractNamedDecl, old_decl::AbstractNamedDecl, is_known_newer::Bool=true)
    @check_ptrs x
    return clang_NamedDecl_declarationReplaces(x, old_decl, is_known_newer)
end

function hasLinkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasLinkage(x)
end

function isCXXClassMember(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXClassMember(x)
end

function isCXXInstanceMember(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isCXXInstanceMember(x)
end

function getLinkageInternal(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getLinkageInternal(x)
end

function hasExternalFormalLinkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasExternalFormalLinkage(x)
end

function isExternallyVisible(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyVisible(x)
end

function isExternallyDeclarable(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isExternallyDeclarable(x)
end

function getVisibility(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getVisibility(x)
end

# TODO: getLinkageAndVisibility
# TODO: getExplicitVisibility

function isLinkageValid(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_isLinkageValid(x)
end

function hasLinkageBeenComputed(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_hasLinkageBeenComputed(x)
end

function getUnderlyingDecl(x::AbstractNamedDecl)
    @check_ptrs x
    return NamedDecl(clang_NamedDecl_getUnderlyingDecl(x))
end

function getMostRecentDecl(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getMostRecentDecl(x)
end

# TODO: getObjCFStringFormattingFamily

# NamedDecl Cast
function TypeDecl(x::NamedDecl)
    @check_ptrs x
    return TypeDecl(clang_NamedDecl_castToTypeDecl(x))
end

# LabelDecl
function getStmt(x::LabelDecl)
    @check_ptrs x
    return LabelStmt(clang_LabelDecl_getStmt(x))
end

function setStmt(x::LabelDecl, stmt::LabelStmt)
    @check_ptrs x stmt
    return LabelStmt(clang_LabelDecl_setStmt(x, stmt))
end

function isGnuLocal(x::LabelDecl)
    @check_ptrs x
    return clang_LabelDecl_isGnuLocal(x)
end

function setStmt(x::LabelDecl, loc::SourceLocation)
    @check_ptrs x stmt
    return clang_LabelDecl_setLocStart(x, loc)
end

# TODO: getSourceRange

function isMSAsmLabel(x::LabelDecl)
    @check_ptrs x
    return clang_LabelDecl_isMSAsmLabel(x)
end

function isResolvedMSAsmLabel(x::LabelDecl)
    @check_ptrs x
    return clang_LabelDecl_isResolvedMSAsmLabel(x)
end

# TODO: setMSAsmLabel

function getMSAsmLabel(x::LabelDecl)
    @check_ptrs x
    return unsafe_string(clang_LabelDecl_getMSAsmLabel(x))
end

function setMSAsmLabelResolved(x::LabelDecl)
    @check_ptrs x
    return clang_LabelDecl_setMSAsmLabelResolved(x)
end

# NamespaceDecl
function isAnonymousNamespace(x::NamespaceDecl)
    @check_ptrs x
    return clang_NamespaceDecl_isAnonymousNamespace(x)
end

function isInline(x::NamespaceDecl)
    @check_ptrs x
    return clang_NamespaceDecl_isInline(x)
end

function setInline(x::NamespaceDecl, inline::Bool=true)
    @check_ptrs x
    return clang_NamespaceDecl_setInline(x, inline)
end

function getOriginalNamespace(x::NamespaceDecl)
    @check_ptrs x
    return NamespaceDecl(clang_NamespaceDecl_getOriginalNamespace(x))
end

function isOriginalNamespace(x::NamespaceDecl)
    @check_ptrs x
    return clang_NamespaceDecl_isOriginalNamespace(x)
end

function getAnonymousNamespace(x::NamespaceDecl)
    @check_ptrs x
    return NamespaceDecl(clang_NamespaceDecl_getAnonymousNamespace(x))
end

function setAnonymousNamespace(x::NamespaceDecl, decl::NamespaceDecl)
    @check_ptrs x decl
    return clang_NamespaceDecl_setAnonymousNamespace(x, decl)
end

function getCanonicalDecl(x::NamespaceDecl)
    @check_ptrs x
    return NamespaceDecl(clang_NamespaceDecl_getCanonicalDecl(x))
end

# TODO: getSourceRange

function getBeginLoc(x::NamespaceDecl)
    @check_ptrs x
    return SourceLocation(clang_NamespaceDecl_getBeginLoc(x))
end

function getRBraceLoc(x::NamespaceDecl)
    @check_ptrs x
    return SourceLocation(clang_NamespaceDecl_getRBraceLoc(x))
end

function setLocStart(x::NamespaceDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_NamespaceDecl_setLocStart(x, loc)
end

function setRBraceLoc(x::NamespaceDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_NamespaceDecl_setRBraceLoc(x, loc)
end

# ValueDecl
function getType(x::AbstractValueDecl)
    @check_ptrs x
    return QualType(clang_ValueDecl_getType(x))
end

function setType(x::AbstractValueDecl, ty::AbstractQualType)
    @check_ptrs x
    return clang_ValueDecl_setType(x, ty)
end

function isWeak(x::AbstractValueDecl)
    @check_ptrs x
    return clang_ValueDecl_isWeak(x)
end

# DeclaratorDecl
function getTypeSourceInfo(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_DeclaratorDecl_getTypeSourceInfo(x))
end

function setTypeSourceInfo(x::AbstractDeclaratorDecl, info::TypeSourceInfo)
    @check_ptrs x
    return clang_DeclaratorDecl_setTypeSourceInfo(x, info)
end

function getInnerLocStart(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return SourceLocation(clang_DeclaratorDecl_getInnerLocStart(x))
end

function setInnerLocStart(x::AbstractDeclaratorDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_DeclaratorDecl_setInnerLocStart(x, loc)
end

function getOuterLocStart(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return SourceLocation(clang_DeclaratorDecl_getOuterLocStart(x))
end

function getBeginLoc(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return SourceLocation(clang_DeclaratorDecl_getBeginLoc(x))
end

function getQualifier(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_DeclaratorDecl_getQualifier(x))
end

# TODO: getQualifierLoc
# TODO: setQualifierInfo

function getTrailingRequiresClause(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return Expr_(clang_DeclaratorDecl_getTrailingRequiresClause(x))
end

function setTrailingRequiresClause(x::AbstractDeclaratorDecl, clause::AbstractExpr)
    @check_ptrs x
    return clang_DeclaratorDecl_setTrailingRequiresClause(x, clause)
end

function getNumTemplateParameterLists(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return clang_DeclaratorDecl_getNumTemplateParameterLists(x)
end

function getTemplateParameterList(x::AbstractDeclaratorDecl, i::Integer)
    @check_ptrs x
    return clang_DeclaratorDecl_getTemplateParameterList(x, i)
end

# TODO: setTemplateParameterListsInfo

function getTypeSpecStartLoc(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return SourceLocation(clang_DeclaratorDecl_getTypeSpecStartLoc(x))
end

function getTypeSpecEndLoc(x::AbstractDeclaratorDecl)
    @check_ptrs x
    return SourceLocation(clang_DeclaratorDecl_getTypeSpecEndLoc(x))
end

# VarDecl

# TODO: getSourceRange

function getStorageClass(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getStorageClass(x)
end

function setStorageClass(x::AbstractVarDecl, sc::CXStorageClass)
    @check_ptrs x
    return clang_VarDecl_setStorageClass(x, sc)
end

function setTSCSpec(x::AbstractVarDecl, tsc::CXThreadStorageClassSpecifier)
    @check_ptrs x
    return clang_VarDecl_setTSCSpec(x, tsc)
end

function getTSCSpec(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getTSCSpec(x)
end

# TODO: getTLSKind

function hasLocalStorage(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_hasLocalStorage(x)
end

function isStaticLocal(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isStaticLocal(x)
end

function hasExternalStorage(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_hasExternalStorage(x)
end

function hasGlobalStorage(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_hasGlobalStorage(x)
end

function getStorageDuration(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getStorageDuration(x)
end

function getLanguageLinkage(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getLanguageLinkage(x)
end

function isExternC(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isExternC(x)
end

function isInExternCContext(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isInExternCContext(x)
end

function isInExternCXXContext(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isInExternCXXContext(x)
end

function isLocalVarDecl(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isLocalVarDecl(x)
end

function isLocalVarDeclOrParm(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isLocalVarDeclOrParm(x)
end

function isFunctionOrMethodVarDecl(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isFunctionOrMethodVarDecl(x)
end

function isStaticDataMember(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isStaticDataMember(x)
end

function getCanonicalDecl(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getCanonicalDecl(x))
end

# TODO: isThisDeclarationADefinition
# TODO: hasDefinition

function getActingDefinition(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getActingDefinition(x))
end

function getDefinition(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getDefinition(x))
end

function isOutOfLine(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isOutOfLine(x)
end

function isFileVarDecl(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isFileVarDecl(x)
end

function getAnyInitializer(x::AbstractVarDecl)
    @check_ptrs x
    return Expr_(clang_VarDecl_getAnyInitializer(x))
end

function hasInit(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_hasInit(x)
end

function getInit(x::AbstractVarDecl)
    @check_ptrs x
    return Expr_(clang_VarDecl_getInit(x))
end

# TODO: getInitAddress

function getInit(x::AbstractVarDecl, expr::Expr_)
    @check_ptrs x expr
    return clang_VarDecl_setInit(x, expr)
end

function getInitializingDeclaration(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getInitializingDeclaration(x)
end

function mightBeUsableInConstantExpressions(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_mightBeUsableInConstantExpressions(x, ctx)
end

function isUsableInConstantExpressions(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_isUsableInConstantExpressions(x, ctx)
end

# TODO: clang_VarDecl_ensureEvaluatedStmt
# TODO: clang_VarDecl_getEvaluatedStmt

# TODO: evaluateValue
# TODO: getEvaluatedValue
# TODO: evaluateDestruction

function hasConstantInitialization(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_hasConstantInitialization(x)
end

function hasICEInitializer(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_hasICEInitializer(x, ctx)
end

# TODO: checkForConstantInitialization
# TODO: setInitStyle
# TODO: getInitStyle

function isDirectInit(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isDirectInit(x)
end

function isThisDeclarationADemotedDefinition(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isThisDeclarationADemotedDefinition(x)
end

function demoteThisDefinitionToDeclaration(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_demoteThisDefinitionToDeclaration(x)
end

function isExceptionVariable(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isExceptionVariable(x)
end

function setExceptionVariable(x::AbstractVarDecl, ev::Bool)
    @check_ptrs x
    return clang_VarDecl_setExceptionVariable(x, ev)
end

function isNRVOVariable(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isNRVOVariable(x)
end

function setNRVOVariable(x::AbstractVarDecl, nrvo::Bool)
    @check_ptrs x
    return clang_VarDecl_setNRVOVariable(x, nrvo)
end

function isCXXForRangeDecl(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isCXXForRangeDecl(x)
end

function setCXXForRangeDecl(x::AbstractVarDecl, frd::Bool)
    @check_ptrs x
    return clang_VarDecl_setCXXForRangeDecl(x, frd)
end

function isObjCForDecl(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isObjCForDecl(x)
end

function setObjCForDecl(x::AbstractVarDecl, frd::Bool)
    @check_ptrs x
    return clang_VarDecl_setObjCForDecl(x, frd)
end

function isARCPseudoStrong(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isARCPseudoStrong(x)
end

function setARCPseudoStrong(x::AbstractVarDecl, ps::Bool)
    @check_ptrs x
    return clang_VarDecl_setARCPseudoStrong(x, ps)
end

function isInline(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isInline(x)
end

function isInlineSpecified(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isInlineSpecified(x)
end

function setInlineSpecified(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_setInlineSpecified(x)
end

function setImplicitlyInline(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_setImplicitlyInline(x)
end

function isConstexpr(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isConstexpr(x)
end

function setConstexpr(x::AbstractVarDecl, ic::Bool)
    @check_ptrs x
    return clang_VarDecl_setConstexpr(x, ic)
end

function isInitCapture(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isInitCapture(x)
end

function setInitCapture(x::AbstractVarDecl, ic::Bool)
    @check_ptrs x
    return clang_VarDecl_setInitCapture(x, ic)
end

function isParameterPack(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isParameterPack(x)
end

function isPreviousDeclInSameBlockScope(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isPreviousDeclInSameBlockScope(x)
end

function setPreviousDeclInSameBlockScope(x::AbstractVarDecl, same::Bool)
    @check_ptrs x
    return clang_VarDecl_setPreviousDeclInSameBlockScope(x, same)
end

function isEscapingByref(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isEscapingByref(x)
end

function isNonEscapingByref(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isNonEscapingByref(x)
end

function setEscapingByref(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_setEscapingByref(x)
end

function getTemplateInstantiationPattern(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getTemplateInstantiationPattern(x))
end

function getInstantiatedFromStaticDataMember(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getInstantiatedFromStaticDataMember(x))
end

function getTemplateSpecializationKind(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getTemplateSpecializationKind(x)
end

function getTemplateSpecializationKindForInstantiation(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_getTemplateSpecializationKindForInstantiation(x)
end

function getPointOfInstantiation(x::AbstractVarDecl)
    @check_ptrs x
    return SourceLocation(clang_VarDecl_getPointOfInstantiation(x))
end

# TODO: getMemberSpecializationInfo

function setTemplateSpecializationKind(x::AbstractVarDecl, tsk::CXTemplateSpecializationKind, poi::SourceLocation)
    @check_ptrs x
    return clang_VarDecl_setTemplateSpecializationKind(x, tsk, poi)
end

function setInstantiationOfStaticDataMember(x::AbstractVarDecl, decl::AbstractVarDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x decl
    return clang_VarDecl_setInstantiationOfStaticDataMember(x, decl, tsk)
end

function getDescribedVarTemplate(x::AbstractVarDecl)
    @check_ptrs x
    return VarTemplateDecl(clang_VarDecl_getDescribedVarTemplate(x))
end

function setInstantiationOfStaticDataMember(x::AbstractVarDecl, decl::VarTemplateDecl)
    @check_ptrs x decl
    return clang_VarDecl_setDescribedVarTemplate(x, decl)
end

function isKnownToBeDefined(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isKnownToBeDefined(x)
end

function isNoDestroy(x::AbstractVarDecl)
    @check_ptrs x
    return clang_VarDecl_isNoDestroy(x)
end

# TODO: needsDestruction

# ImplicitParamDecl
function getParameterKind(x::ImplicitParamDecl)
    @check_ptrs x
    return clang_ImplicitParamDecl_getParameterKind(x)
end

# ParmVarDecl
function setObjCMethodScopeInfo(x::ParmVarDecl, i::Integer)
    @check_ptrs x
    return clang_ParmVarDecl_setObjCMethodScopeInfo(x, i)
end

function setScopeInfo(x::ParmVarDecl, depth::Integer, i::Integer)
    @check_ptrs x
    return clang_ParmVarDecl_setScopeInfo(x, depth, i)
end

function isObjCMethodParameter(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_isObjCMethodParameter(x)
end

function isDestroyedInCallee(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_isDestroyedInCallee(x)
end

function getFunctionScopeDepth(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_getFunctionScopeDepth(x)
end

function getFunctionScopeIndex(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_getFunctionScopeIndex(x)
end

# TODO: getObjCDeclQualifier
# TODO: setObjCDeclQualifier

function isKNRPromoted(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_isKNRPromoted(x)
end

function setKNRPromoted(x::ParmVarDecl, promoted::Bool)
    @check_ptrs x
    return clang_ParmVarDecl_setKNRPromoted(x, promoted)
end

function getDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return Expr_(clang_ParmVarDecl_getDefaultArg(x))
end

function setDefaultArg(x::ParmVarDecl, defarg::Expr_)
    @check_ptrs x defarg
    return clang_ParmVarDecl_setDefaultArg(x, defarg)
end

# TODO: getDefaultArgRange

function getDefaultArg(x::ParmVarDecl, arg::Expr_)
    @check_ptrs x arg
    return clang_ParmVarDecl_setUninstantiatedDefaultArg(x, arg)
end

function getUninstantiatedDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return Expr_(clang_ParmVarDecl_getUninstantiatedDefaultArg(x))
end

function hasDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_hasDefaultArg(x)
end

function hasUnparsedDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_hasUnparsedDefaultArg(x)
end

function hasUninstantiatedDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_hasUninstantiatedDefaultArg(x)
end

function setUnparsedDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_setUnparsedDefaultArg(x)
end

function hasInheritedDefaultArg(x::ParmVarDecl)
    @check_ptrs x
    return clang_ParmVarDecl_hasInheritedDefaultArg(x)
end

function setOwningFunction(x::ParmVarDecl, i::Bool=true)
    @check_ptrs x fd
    return clang_ParmVarDecl_setHasInheritedDefaultArg(x, i)
end

function getOriginalType(x::ParmVarDecl)
    @check_ptrs x
    return QualType(clang_ParmVarDecl_getOriginalType(x))
end

function setOwningFunction(x::ParmVarDecl, fd::DeclContext)
    @check_ptrs x fd
    return clang_ParmVarDecl_setOwningFunction(x, fd)
end

# FunctionDecl
# TODO: getNameInfo
# TODO: getNameForDiagnostic
function setRangeEnd(x::FunctionDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_FunctionDecl_setRangeEnd(x, loc)
end

function getEllipsisLoc(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getEllipsisLoc(x)
end

# TODO: getSourceRange

function hasBody(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasBody(x)
end

function hasTrivialBody(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasTrivialBody(x)
end

function isDefined(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDefined(x)
end

function getDefinition(x::FunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getDefinition(x))
end

function getBody(x::FunctionDecl)
    @check_ptrs x
    return Stmt(clang_FunctionDecl_getBody(x))
end

function isThisDeclarationADefinition(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isThisDeclarationADefinition(x)
end

function isThisDeclarationInstantiatedFromAFriendDefinition(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(x)
end

function doesThisDeclarationHaveABody(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_doesThisDeclarationHaveABody(x)
end

function setBody(x::FunctionDecl, stmt::Stmt)
    @check_ptrs x stmt
    return clang_FunctionDecl_setBody(x, stmt)
end

function setLazyBody(x::FunctionDecl, offset::Integer)
    @check_ptrs x
    return clang_FunctionDecl_setLazyBody(x, offset)
end

function setDefaultedFunctionInfo(x::FunctionDecl, info::CXFunctionDecl_DefaultedFunctionInfo)
    @check_ptrs x
    return clang_FunctionDecl_setDefaultedFunctionInfo(x, info)
end

function isVariadic(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isVariadic(x)
end

function isVirtualAsWritten(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isVirtualAsWritten(x)
end

function setVirtualAsWritten(x::FunctionDecl, v::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setVirtualAsWritten(x, v)
end

function isPure(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isPure(x)
end

function setPure(x::FunctionDecl, pure::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setPure(x, pure)
end

function isLateTemplateParsed(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isLateTemplateParsed(x)
end

function setLateTemplateParsed(x::FunctionDecl, ilt::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setLateTemplateParsed(x, ilt)
end

function isTrivial(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTrivial(x)
end

function setTrivial(x::FunctionDecl, it::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setTrivial(x, it)
end

function isTrivialForCall(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTrivialForCall(x)
end

function setTrivialForCall(x::FunctionDecl, it::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setTrivialForCall(x, it)
end

function isDefaulted(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDefaulted(x)
end

function setDefaulted(x::FunctionDecl, d::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setDefaulted(x, d)
end

function isExplicitlyDefaulted(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isExplicitlyDefaulted(x)
end

function setExplicitlyDefaulted(x::FunctionDecl, ed::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setExplicitlyDefaulted(x, ed)
end

function isUserProvided(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isUserProvided(x)
end

function hasImplicitReturnZero(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasImplicitReturnZero(x)
end

function setHasImplicitReturnZero(x::FunctionDecl, irz::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setHasImplicitReturnZero(x, irz)
end

function hasPrototype(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasPrototype(x)
end

function hasWrittenPrototype(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasWrittenPrototype(x)
end

function setHasWrittenPrototype(x::FunctionDecl, p::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasWrittenPrototype(x, p)
end

function hasInheritedPrototype(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasInheritedPrototype(x)
end

function setHasInheritedPrototype(x::FunctionDecl, p::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasInheritedPrototype(x, p)
end

function isConstexpr(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConstexpr(x)
end

function setConstexprKind(x::FunctionDecl, kind::CXConstexprSpecKind)
    @check_ptrs x
    return clang_FunctionDecl_setConstexprKind(x, kind)
end

function getConstexprKind(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getConstexprKind(x)
end

function isConstexprSpecified(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConstexprSpecified(x)
end

function isConsteval(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConsteval(x)
end

function instantiationIsPending(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_instantiationIsPending(x)
end

function setInstantiationIsPending(x::FunctionDecl, ic::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setInstantiationIsPending(x, ic)
end

function usesSEHTry(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_usesSEHTry(x)
end

function setUsesSEHTry(x::FunctionDecl, ust::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setUsesSEHTry(x, ust)
end

function isDeleted(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDeleted(x)
end

function isDeletedAsWritten(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDeletedAsWritten(x)
end

function setDeletedAsWritten(x::FunctionDecl, d::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setDeletedAsWritten(x, d)
end

function isMain(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMain(x)
end

function isMSVCRTEntryPoint(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMSVCRTEntryPoint(x)
end

function isReservedGlobalPlacementOperator(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isReservedGlobalPlacementOperator(x)
end

function isReplaceableGlobalAllocationFunction(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isReplaceableGlobalAllocationFunction(x)
end

function isInlineBuiltinDeclaration(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineBuiltinDeclaration(x)
end

function isDestroyingOperatorDelete(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDestroyingOperatorDelete(x)
end

function getLanguageLinkage(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getLanguageLinkage(x)
end

function isExternC(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isExternC(x)
end

function isInExternCContext(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInExternCContext(x)
end

function isInExternCXXContext(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInExternCXXContext(x)
end

function isGlobal(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isGlobal(x)
end

function isNoReturn(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isNoReturn(x)
end

function hasSkippedBody(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasSkippedBody(x)
end

function setHasSkippedBody(x::FunctionDecl, skipped::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasSkippedBody(x, skipped)
end

function willHaveBody(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_willHaveBody(x)
end

function setWillHaveBody(x::FunctionDecl, v::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setWillHaveBody(x, v)
end

function isMultiVersion(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMultiVersion(x)
end

function setIsMultiVersion(x::FunctionDecl, v::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setIsMultiVersion(x, v)
end

function getMultiVersionKind(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMultiVersionKind(x)
end

function isCPUDispatchMultiVersion(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isCPUDispatchMultiVersion(x)
end

function isCPUSpecificMultiVersion(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isCPUSpecificMultiVersion(x)
end

function isTargetMultiVersion(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTargetMultiVersion(x)
end

# TODO: getAssociatedConstraints

function setPreviousDeclaration(x::FunctionDecl, prev_decl::FunctionDecl)
    @check_ptrs x prev_decl
    return clang_FunctionDecl_setPreviousDeclaration(x, prev_decl)
end

function getCanonicalDecl(x::FunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getCanonicalDecl(x))
end

function getBuiltinID(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getBuiltinID(x)
end

# TODO: parameters

function getNumParams(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getNumParams(x)
end

function getParamDecl(x::FunctionDecl, i::Integer)
    @check_ptrs x
    return clang_FunctionDecl_getParamDecl(x, i)
end

# TODO: setParams

function getMinRequiredArguments(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMinRequiredArguments(x)
end

function hasOneParamOrDefaultArgs(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasOneParamOrDefaultArgs(x)
end

# TODO: getFunctionTypeLoc

function getReturnType(x::FunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getReturnType(x))
end

# TODO: getReturnTypeSourceRange
# TODO: getParametersSourceRange

function getDeclaredReturnType(x::FunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getDeclaredReturnType(x))
end

function getExceptionSpecType(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getExceptionSpecType(x)
end

# TODO: getExceptionSpecSourceRange

function getCallResultType(x::FunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getCallResultType(x))
end

function getStorageClass(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getStorageClass(x)
end

function setStorageClass(x::FunctionDecl, storage::CXStorageClass)
    @check_ptrs x
    return clang_FunctionDecl_setStorageClass(x, storage)
end

function isInlineSpecified(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineSpecified(x)
end

function setInlineSpecified(x::FunctionDecl, i::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setInlineSpecified(x, i)
end

function setImplicitlyInline(x::FunctionDecl, i::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setImplicitlyInline(x, i)
end

function isInlined(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlined(x)
end

function isInlineDefinitionExternallyVisible(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineDefinitionExternallyVisible(x)
end

function isMSExternInline(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMSExternInline(x)
end

function doesDeclarationForceExternallyVisibleDefinition(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(x)
end

function isStatic(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isStatic(x)
end

function isOverloadedOperator(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isOverloadedOperator(x)
end

# TODO: getOverloadedOperator

function getLiteralIdentifier(x::FunctionDecl)
    @check_ptrs x
    return IdentifierInfo(clang_FunctionDecl_getLiteralIdentifier(x))
end

function getTemplatedKind(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplatedKind(x)
end

function getMemberSpecializationInfo(x::FunctionDecl)
    @check_ptrs x
    return MemberSpecializationInfo(clang_FunctionDecl_getMemberSpecializationInfo(x))
end

function setInstantiationOfMemberFunction(x::FunctionDecl, decl::FunctionDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x decl
    return clang_FunctionDecl_setInstantiationOfMemberFunction(x, decl, tsk)
end

function getDescribedFunctionTemplate(x::FunctionDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionDecl_getDescribedFunctionTemplate(x))
end

function setDescribedFunctionTemplate(x::FunctionDecl, decl::FunctionTemplateDecl)
    @check_ptrs x decl
    return clang_FunctionDecl_setDescribedFunctionTemplate(x, decl)
end

function getInstantiatedFromMemberFunction(x::FunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getInstantiatedFromMemberFunction(x))
end

function isFunctionTemplateSpecialization(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isFunctionTemplateSpecialization(x)
end

function getTemplateSpecializationInfo(x::FunctionDecl)
    @check_ptrs x
    return FunctionTemplateSpecializationInfo(clang_FunctionDecl_getTemplateSpecializationInfo(x))
end

function isImplicitlyInstantiable(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isImplicitlyInstantiable(x)
end

function isTemplateInstantiation(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTemplateInstantiation(x)
end

function getTemplateInstantiationPattern(x::FunctionDecl, for_def::Bool=true)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getTemplateInstantiationPattern(x))
end

function getPrimaryTemplate(x::FunctionDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionDecl_getPrimaryTemplate(x))
end

function getTemplateSpecializationArgs(x::FunctionDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_FunctionDecl_getTemplateSpecializationArgs(x))
end

function getTemplateSpecializationArgsAsWritten(x::FunctionDecl)
    @check_ptrs x
    return ASTTemplateArgumentListInfo(clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(x))
end

# TODO: setFunctionTemplateSpecialization
# TODO: setDependentTemplateSpecialization

function getDependentSpecializationInfo(x::FunctionDecl)
    @check_ptrs x
    return DependentFunctionTemplateSpecializationInfo(clang_FunctionDecl_getDependentSpecializationInfo(x))
end

function getTemplateSpecializationKind(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplateSpecializationKind(x)
end

function getTemplateSpecializationKindForInstantiation(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(x)
end

function setTemplateSpecializationKind(x::FunctionDecl, tsk::CXTemplateSpecializationKind, loc::SourceLocation)
    @check_ptrs x
    return clang_FunctionDecl_setTemplateSpecializationKind(x, tsk, loc)
end

function getPointOfInstantiation(x::FunctionDecl)
    @check_ptrs x
    return SourceLocation(clang_FunctionDecl_getPointOfInstantiation(x))
end

function isOutOfLine(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isOutOfLine(x)
end

function getMemoryFunctionKind(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMemoryFunctionKind(x)
end

function getODRHash(x::FunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getODRHash(x)
end

# TypeDecl
function getTypeForDecl(x::AbstractTypeDecl)::CXType_
    @check_ptrs x
    return clang_TypeDecl_getTypeForDecl(x)
end
getTypeForDecl(x::NamedDecl) = getTypeForDecl(TypeDecl(x))

function setTypeForDecl(x::AbstractTypeDecl, ty_ptr::CXType_)
    @check_ptrs x
    return clang_TypeDecl_setTypeForDecl(x, ty_ptr)
end
setTypeForDecl(x::AbstractTypeDecl, ty::AbstractQualType) = setTypeForDecl(x, get_type_ptr(ty))

function getBeginLoc(x::AbstractTypeDecl)
    @check_ptrs x
    return SourceLocation(clang_TypeDecl_getBeginLoc(x))
end

function setLocStart(x::AbstractTypeDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_TypeDecl_setLocStart(x, loc)
end

# TypedefNameDecl
function getUnderlyingType(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return QualType(clang_TypedefNameDecl_getUnderlyingType(x))
end

function getCanonicalDecl(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TypedefNameDecl_getCanonicalDecl(x))
end

function getAnonDeclWithTypedefName(x::AbstractTypedefNameDecl, any_redecl::Bool=false)
    @check_ptrs x
    return TagDecl(clang_TypedefNameDecl_getAnonDeclWithTypedefName(x, any_redecl))
end

function isTransparentTag(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return clang_TypedefNameDecl_isTransparentTag(x)
end

# TagDecl
function DeclContext(x::AbstractTagDecl)
    @check_ptrs x
    return DeclContext(clang_TagDecl_castToDeclContext(x))
end

function getCanonicalDecl(x::AbstractTagDecl)
    @check_ptrs x
    return TagDecl(clang_TagDecl_getCanonicalDecl(x))
end

function isThisDeclarationADefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isThisDeclarationADefinition(x)
end

function isCompleteDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isCompleteDefinition(x)
end

function setCompleteDefinition(x::AbstractTagDecl, v::Bool)
    @check_ptrs x
    return clang_TagDecl_setCompleteDefinition(x, v)
end

function isBeingDefined(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isBeingDefined(x)
end

function isFreeStanding(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isFreeStanding(x)
end

function startDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_startDefinition(x)
end

function getDefinition(x::AbstractTagDecl)
    @check_ptrs x
    return TagDecl(clang_TagDecl_getDefinition(x))
end

function getKindName(x::AbstractTagDecl)
    @check_ptrs x
    return unsafe_string(clang_TagDecl_getKindName(x))
end

function getTagKind(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_getTagKind(x)
end

function isStruct(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isStruct(x)
end

function isInterface(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isInterface(x)
end

function isClass(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isClass(x)
end

function isUnion(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isUnion(x)
end

function isEnum(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isEnum(x)
end

function hasNameForLinkage(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_hasNameForLinkage(x)
end

function getTypedefNameForAnonDecl(x::AbstractTagDecl)
    @check_ptrs x
    return TypedefNameDecl(clang_TagDecl_getTypedefNameForAnonDecl(x))
end

function getQualifier(x::AbstractTagDecl)
    @check_ptrs x
    return NestedNameSpecifier(clang_TagDecl_getQualifier(x))
end

# EnumDecl
function getCanonicalDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getCanonicalDecl(x))
end

function getPreviousDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getMostRecentDecl(x))
end

function getDefinition(x::EnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getDefinition(x))
end

function getIntegerType(x::EnumDecl)
    @check_ptrs x
    return QualType(clang_EnumDecl_getIntegerType(x))
end

# RecordDecl
function getPreviousDecl(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getPreviousDecl(x))
end

function getMostRecentDecl(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getMostRecentDecl(x))
end

function hasFlexibleArrayMember(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasFlexibleArrayMember(x)
end

function isAnonymousStructOrUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isAnonymousStructOrUnion(x)
end

function isInjectedClassName(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isInjectedClassName(x)
end

function isLambda(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isLambda(x)
end

function isCapturedRecord(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isCapturedRecord(x)
end

function getDefinition(x::AbstractRecordDecl)
    @check_ptrs x
    return RecordDecl(clang_RecordDecl_getDefinition(x))
end

function isOrContainsUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isOrContainsUnion(x)
end
