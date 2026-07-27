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
function getName(x::AbstractPragmaDetectMismatchDecl)
    @check_ptrs x
    return unsafe_string(clang_PragmaDetectMismatchDecl_getName(x))
end

function getValue(x::AbstractPragmaDetectMismatchDecl)
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

function getFormalLinkage(x::AbstractNamedDecl)
    @check_ptrs x
    return clang_NamedDecl_getFormalLinkage(x)
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
    return NamedDecl(clang_NamedDecl_getMostRecentDecl(x))
end

# TODO: getObjCFStringFormattingFamily

# NamedDecl Cast
function TypeDecl(x::NamedDecl)
    @check_ptrs x
    return TypeDecl(clang_NamedDecl_castToTypeDecl(x))
end

function EnumConstantDecl(x::NamedDecl)
    @check_ptrs x
    return EnumConstantDecl(clang_NamedDecl_castToEnumConstantDecl(x))
end

# LabelDecl
function getStmt(x::LabelDecl)
    @check_ptrs x
    return LabelStmt(clang_LabelDecl_getStmt(x))
end

function setStmt(x::LabelDecl, stmt::LabelStmt)
    @check_ptrs x stmt
    return clang_LabelDecl_setStmt(x, stmt)
end

function isGnuLocal(x::LabelDecl)
    @check_ptrs x
    return clang_LabelDecl_isGnuLocal(x)
end

function setLocStart(x::LabelDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_LabelDecl_setLocStart(x, loc)
end

function getSourceRange(x::AbstractLabelDecl)
    @check_ptrs x
    r = clang_LabelDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
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

function getSourceRange(x::AbstractNamespaceDecl)
    @check_ptrs x
    r = clang_NamespaceDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
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

function setType(x::AbstractValueDecl, ty::QualType)
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
    return TemplateParameterList(clang_DeclaratorDecl_getTemplateParameterList(x, i))
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

function getSourceRange(x::AbstractVarDecl)
    @check_ptrs x
    r = clang_VarDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

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

function setInit(x::AbstractVarDecl, expr::Expr_)
    @check_ptrs x expr
    return clang_VarDecl_setInit(x, expr)
end

function getInitializingDeclaration(x::AbstractVarDecl)
    @check_ptrs x
    return VarDecl(clang_VarDecl_getInitializingDeclaration(x))
end

function mightBeUsableInConstantExpressions(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_mightBeUsableInConstantExpressions(x, ctx)
end

# Evaluate the initializer to a constant. The returned `APValue` wraps `C_NULL`
# when the initializer is absent or not constant-foldable (check `.ptr`); a
# non-null result is borrowed (cached in the VarDecl) — never `dispose` it.
function evaluateValue(x::AbstractVarDecl)
    @check_ptrs x
    return APValue(clang_VarDecl_evaluateValue(x))
end

function isUsableInConstantExpressions(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_isUsableInConstantExpressions(x, ctx)
end

function ensureEvaluatedStmt(x::AbstractVarDecl)
    @check_ptrs x
    return EvaluatedStmt(clang_VarDecl_ensureEvaluatedStmt(x))
end

# The returned `EvaluatedStmt` wraps C_NULL when the initializer has not been
# evaluated yet (see `ensureEvaluatedStmt`).
function getEvaluatedStmt(x::AbstractVarDecl)
    @check_ptrs x
    return EvaluatedStmt(clang_VarDecl_getEvaluatedStmt(x))
end

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

function setInstantiationOfStaticDataMember(x::AbstractVarDecl, decl::AbstractVarDecl,
                                            tsk::CXTemplateSpecializationKind)
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

function isNoDestroy(x::AbstractVarDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_VarDecl_isNoDestroy(x, ctx)
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

function getDefaultArgRange(x::AbstractParmVarDecl)
    @check_ptrs x
    r = clang_ParmVarDecl_getDefaultArgRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
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

function setHasInheritedDefaultArg(x::ParmVarDecl, i::Bool=true)
    @check_ptrs x
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

function getExceptionSpecSourceRange(x::AbstractFunctionDecl)
    @check_ptrs x
    r = clang_FunctionDecl_getExceptionSpecSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getParametersSourceRange(x::AbstractFunctionDecl)
    @check_ptrs x
    r = clang_FunctionDecl_getParametersSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getReturnTypeSourceRange(x::AbstractFunctionDecl)
    @check_ptrs x
    r = clang_FunctionDecl_getReturnTypeSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getSourceRange(x::AbstractFunctionDecl)
    @check_ptrs x
    r = clang_FunctionDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isPureVirtual(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isPureVirtual(x)
end

function getNameInfo(x::AbstractFunctionDecl)
    @check_ptrs x
    return DeclarationNameInfo(clang_FunctionDecl_getNameInfo(x))
end

# TODO: getNameInfo
# TODO: getNameForDiagnostic
function setRangeEnd(x::AbstractFunctionDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_FunctionDecl_setRangeEnd(x, loc)
end

function getEllipsisLoc(x::AbstractFunctionDecl)
    @check_ptrs x
    return SourceLocation(clang_FunctionDecl_getEllipsisLoc(x))
end

# TODO: getSourceRange

function hasBody(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasBody(x)
end

function hasTrivialBody(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasTrivialBody(x)
end

function isDefined(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDefined(x)
end

function getDefinition(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getDefinition(x))
end

function getBody(x::AbstractFunctionDecl)
    @check_ptrs x
    return Stmt(clang_FunctionDecl_getBody(x))
end

function isThisDeclarationADefinition(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isThisDeclarationADefinition(x)
end

function isThisDeclarationInstantiatedFromAFriendDefinition(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isThisDeclarationInstantiatedFromAFriendDefinition(x)
end

function doesThisDeclarationHaveABody(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_doesThisDeclarationHaveABody(x)
end

function setBody(x::AbstractFunctionDecl, stmt::Stmt)
    @check_ptrs x stmt
    return clang_FunctionDecl_setBody(x, stmt)
end

function setLazyBody(x::AbstractFunctionDecl, offset::Integer)
    @check_ptrs x
    return clang_FunctionDecl_setLazyBody(x, offset)
end

function setDefaultedFunctionInfo(x::AbstractFunctionDecl, info::CXFunctionDecl_DefaultedFunctionInfo)
    @check_ptrs x
    return clang_FunctionDecl_setDefaultedFunctionInfo(x, info)
end

function isVariadic(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isVariadic(x)
end

function isVirtualAsWritten(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isVirtualAsWritten(x)
end

function setVirtualAsWritten(x::AbstractFunctionDecl, v::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setVirtualAsWritten(x, v)
end

# NOTE: FunctionDecl::isPure()/setPure() were renamed isPureVirtual()/
# setIsPureVirtual() upstream; the working wrappers are
# isPureVirtual(::AbstractFunctionDecl) above and
# setIsPureVirtual(::AbstractFunctionDecl) below. The old-name wrappers called
# bindings that no longer exist and have been removed.

function isLateTemplateParsed(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isLateTemplateParsed(x)
end

function setLateTemplateParsed(x::AbstractFunctionDecl, ilt::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setLateTemplateParsed(x, ilt)
end

function isTrivial(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTrivial(x)
end

function setTrivial(x::AbstractFunctionDecl, it::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setTrivial(x, it)
end

function isTrivialForCall(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTrivialForCall(x)
end

function setTrivialForCall(x::AbstractFunctionDecl, it::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setTrivialForCall(x, it)
end

function isDefaulted(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDefaulted(x)
end

function setDefaulted(x::AbstractFunctionDecl, d::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setDefaulted(x, d)
end

function isExplicitlyDefaulted(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isExplicitlyDefaulted(x)
end

function setExplicitlyDefaulted(x::AbstractFunctionDecl, ed::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setExplicitlyDefaulted(x, ed)
end

function isUserProvided(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isUserProvided(x)
end

function hasImplicitReturnZero(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasImplicitReturnZero(x)
end

function setHasImplicitReturnZero(x::AbstractFunctionDecl, irz::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setHasImplicitReturnZero(x, irz)
end

function hasPrototype(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasPrototype(x)
end

function hasWrittenPrototype(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasWrittenPrototype(x)
end

function setHasWrittenPrototype(x::AbstractFunctionDecl, p::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasWrittenPrototype(x, p)
end

function hasInheritedPrototype(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasInheritedPrototype(x)
end

function setHasInheritedPrototype(x::AbstractFunctionDecl, p::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasInheritedPrototype(x, p)
end

function isConstexpr(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConstexpr(x)
end

function setConstexprKind(x::AbstractFunctionDecl, kind::CXConstexprSpecKind)
    @check_ptrs x
    return clang_FunctionDecl_setConstexprKind(x, kind)
end

function getConstexprKind(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getConstexprKind(x)
end

function isConstexprSpecified(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConstexprSpecified(x)
end

function isConsteval(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isConsteval(x)
end

function instantiationIsPending(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_instantiationIsPending(x)
end

function setInstantiationIsPending(x::AbstractFunctionDecl, ic::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setInstantiationIsPending(x, ic)
end

function usesSEHTry(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_usesSEHTry(x)
end

function setUsesSEHTry(x::AbstractFunctionDecl, ust::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setUsesSEHTry(x, ust)
end

function isDeleted(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDeleted(x)
end

function isDeletedAsWritten(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDeletedAsWritten(x)
end

function setDeletedAsWritten(x::AbstractFunctionDecl, d::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setDeletedAsWritten(x, d)
end

function isMain(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMain(x)
end

function isMSVCRTEntryPoint(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMSVCRTEntryPoint(x)
end

function isReservedGlobalPlacementOperator(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isReservedGlobalPlacementOperator(x)
end

function isReplaceableGlobalAllocationFunction(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isReplaceableGlobalAllocationFunction(x)
end

function isInlineBuiltinDeclaration(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineBuiltinDeclaration(x)
end

function isDestroyingOperatorDelete(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isDestroyingOperatorDelete(x)
end

function getLanguageLinkage(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getLanguageLinkage(x)
end

function isExternC(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isExternC(x)
end

function isInExternCContext(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInExternCContext(x)
end

function isInExternCXXContext(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInExternCXXContext(x)
end

function isGlobal(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isGlobal(x)
end

function isNoReturn(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isNoReturn(x)
end

function hasSkippedBody(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasSkippedBody(x)
end

function setHasSkippedBody(x::AbstractFunctionDecl, skipped::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setHasSkippedBody(x, skipped)
end

function willHaveBody(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_willHaveBody(x)
end

function setWillHaveBody(x::AbstractFunctionDecl, v::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setWillHaveBody(x, v)
end

function isMultiVersion(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMultiVersion(x)
end

function setIsMultiVersion(x::AbstractFunctionDecl, v::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setIsMultiVersion(x, v)
end

function getMultiVersionKind(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMultiVersionKind(x)
end

function isCPUDispatchMultiVersion(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isCPUDispatchMultiVersion(x)
end

function isCPUSpecificMultiVersion(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isCPUSpecificMultiVersion(x)
end

function isTargetMultiVersion(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTargetMultiVersion(x)
end

# TODO: getAssociatedConstraints

function setPreviousDeclaration(x::AbstractFunctionDecl, prev_decl::FunctionDecl)
    @check_ptrs x prev_decl
    return clang_FunctionDecl_setPreviousDeclaration(x, prev_decl)
end

function getCanonicalDecl(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getCanonicalDecl(x))
end

function getBuiltinID(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getBuiltinID(x)
end

# TODO: parameters

function getNumParams(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getNumParams(x)
end

function getParamDecl(x::AbstractFunctionDecl, i::Integer)
    @check_ptrs x
    return ParmVarDecl(clang_FunctionDecl_getParamDecl(x, i))
end

# TODO: setParams

function getMinRequiredArguments(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMinRequiredArguments(x)
end

function hasOneParamOrDefaultArgs(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_hasOneParamOrDefaultArgs(x)
end

# TODO: getFunctionTypeLoc

function getReturnType(x::AbstractFunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getReturnType(x))
end

# TODO: getReturnTypeSourceRange
# TODO: getParametersSourceRange

function getDeclaredReturnType(x::AbstractFunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getDeclaredReturnType(x))
end

function getExceptionSpecType(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getExceptionSpecType(x)
end

# TODO: getExceptionSpecSourceRange

function getCallResultType(x::AbstractFunctionDecl)
    @check_ptrs x
    return QualType(clang_FunctionDecl_getCallResultType(x))
end

function getStorageClass(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getStorageClass(x)
end

function setStorageClass(x::AbstractFunctionDecl, storage::CXStorageClass)
    @check_ptrs x
    return clang_FunctionDecl_setStorageClass(x, storage)
end

function isInlineSpecified(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineSpecified(x)
end

function setInlineSpecified(x::AbstractFunctionDecl, i::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setInlineSpecified(x, i)
end

function setImplicitlyInline(x::AbstractFunctionDecl, i::Bool)
    @check_ptrs x
    return clang_FunctionDecl_setImplicitlyInline(x, i)
end

function isInlined(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlined(x)
end

function isInlineDefinitionExternallyVisible(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isInlineDefinitionExternallyVisible(x)
end

function isMSExternInline(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isMSExternInline(x)
end

function doesDeclarationForceExternallyVisibleDefinition(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_doesDeclarationForceExternallyVisibleDefinition(x)
end

function isStatic(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isStatic(x)
end

function isOverloadedOperator(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isOverloadedOperator(x)
end

# TODO: getOverloadedOperator

function getLiteralIdentifier(x::AbstractFunctionDecl)
    @check_ptrs x
    return IdentifierInfo(clang_FunctionDecl_getLiteralIdentifier(x))
end

function getTemplatedKind(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplatedKind(x)
end

function getMemberSpecializationInfo(x::AbstractFunctionDecl)
    @check_ptrs x
    return MemberSpecializationInfo(clang_FunctionDecl_getMemberSpecializationInfo(x))
end

function setInstantiationOfMemberFunction(x::AbstractFunctionDecl, decl::FunctionDecl,
                                          tsk::CXTemplateSpecializationKind)
    @check_ptrs x decl
    return clang_FunctionDecl_setInstantiationOfMemberFunction(x, decl, tsk)
end

function getDescribedFunctionTemplate(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionDecl_getDescribedFunctionTemplate(x))
end

function setDescribedFunctionTemplate(x::AbstractFunctionDecl, decl::FunctionTemplateDecl)
    @check_ptrs x decl
    return clang_FunctionDecl_setDescribedFunctionTemplate(x, decl)
end

function getInstantiatedFromMemberFunction(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getInstantiatedFromMemberFunction(x))
end

function isFunctionTemplateSpecialization(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isFunctionTemplateSpecialization(x)
end

function getTemplateSpecializationInfo(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionTemplateSpecializationInfo(clang_FunctionDecl_getTemplateSpecializationInfo(x))
end

function isImplicitlyInstantiable(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isImplicitlyInstantiable(x)
end

function isTemplateInstantiation(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isTemplateInstantiation(x)
end

function getTemplateInstantiationPattern(x::AbstractFunctionDecl, for_def::Bool=true)
    @check_ptrs x
    return FunctionDecl(clang_FunctionDecl_getTemplateInstantiationPattern(x, for_def))
end

function getPrimaryTemplate(x::AbstractFunctionDecl)
    @check_ptrs x
    return FunctionTemplateDecl(clang_FunctionDecl_getPrimaryTemplate(x))
end

function getTemplateSpecializationArgs(x::AbstractFunctionDecl)
    @check_ptrs x
    return TemplateArgumentList(clang_FunctionDecl_getTemplateSpecializationArgs(x))
end

function getTemplateSpecializationArgsAsWritten(x::AbstractFunctionDecl)
    @check_ptrs x
    return ASTTemplateArgumentListInfo(clang_FunctionDecl_getTemplateSpecializationArgsAsWritten(x))
end

# TODO: setFunctionTemplateSpecialization
# TODO: setDependentTemplateSpecialization

function getDependentSpecializationInfo(x::AbstractFunctionDecl)
    @check_ptrs x
    return DependentFunctionTemplateSpecializationInfo(clang_FunctionDecl_getDependentSpecializationInfo(x))
end

function getTemplateSpecializationKind(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplateSpecializationKind(x)
end

function getTemplateSpecializationKindForInstantiation(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getTemplateSpecializationKindForInstantiation(x)
end

function setTemplateSpecializationKind(x::AbstractFunctionDecl, tsk::CXTemplateSpecializationKind, loc::SourceLocation)
    @check_ptrs x
    return clang_FunctionDecl_setTemplateSpecializationKind(x, tsk, loc)
end

function getPointOfInstantiation(x::AbstractFunctionDecl)
    @check_ptrs x
    return SourceLocation(clang_FunctionDecl_getPointOfInstantiation(x))
end

function isOutOfLine(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_isOutOfLine(x)
end

function getMemoryFunctionKind(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getMemoryFunctionKind(x)
end

function getODRHash(x::AbstractFunctionDecl)
    @check_ptrs x
    return clang_FunctionDecl_getODRHash(x)
end

# EnumConstantDecl
function getEnumConstantDeclValue(x::EnumConstantDecl)
    @check_ptrs x
    return clang_EnumConstantDecl_getEnumConstantDeclValue(x)
end

function getCanonicalDecl(x::AbstractEnumConstantDecl)
    @check_ptrs x
    return EnumConstantDecl(clang_EnumConstantDecl_getCanonicalDecl(x))
end

function getInitExpr(x::AbstractEnumConstantDecl)
    @check_ptrs x
    return Expr_(clang_EnumConstantDecl_getInitExpr(x))
end

function getSourceRange(x::AbstractEnumConstantDecl)
    @check_ptrs x
    r = clang_EnumConstantDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
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
setTypeForDecl(x::AbstractTypeDecl, ty::QualType) = setTypeForDecl(x, get_type_ptr(ty))

function getBeginLoc(x::AbstractTypeDecl)
    @check_ptrs x
    return SourceLocation(clang_TypeDecl_getBeginLoc(x))
end

function setLocStart(x::AbstractTypeDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_TypeDecl_setLocStart(x, loc)
end

function getSourceRange(x::AbstractTypeDecl)
    @check_ptrs x
    r = clang_TypeDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
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

function getTypeSourceInfo(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_TypedefNameDecl_getTypeSourceInfo(x))
end

function isModed(x::AbstractTypedefNameDecl)
    @check_ptrs x
    return clang_TypedefNameDecl_isModed(x)
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

function getBraceRange(x::AbstractTagDecl)
    @check_ptrs x
    r = clang_TagDecl_getBraceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getInnerLocStart(x::AbstractTagDecl)
    @check_ptrs x
    return SourceLocation(clang_TagDecl_getInnerLocStart(x))
end

function getOuterLocStart(x::AbstractTagDecl)
    @check_ptrs x
    return SourceLocation(clang_TagDecl_getOuterLocStart(x))
end

function getSourceRange(x::AbstractTagDecl)
    @check_ptrs x
    r = clang_TagDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function isCompleteDefinitionRequired(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isCompleteDefinitionRequired(x)
end

function isDependentType(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isDependentType(x)
end

function isEmbeddedInDeclarator(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_isEmbeddedInDeclarator(x)
end

function mayHaveOutOfDateDef(x::AbstractTagDecl)
    @check_ptrs x
    return clang_TagDecl_mayHaveOutOfDateDef(x)
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

function getInstantiatedFromMemberEnum(x::AbstractEnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getInstantiatedFromMemberEnum(x))
end

function getIntegerTypeRange(x::AbstractEnumDecl)
    @check_ptrs x
    r = clang_EnumDecl_getIntegerTypeRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getIntegerTypeSourceInfo(x::AbstractEnumDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_EnumDecl_getIntegerTypeSourceInfo(x))
end

function getMemberSpecializationInfo(x::AbstractEnumDecl)
    @check_ptrs x
    return MemberSpecializationInfo(clang_EnumDecl_getMemberSpecializationInfo(x))
end

function getNumNegativeBits(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_getNumNegativeBits(x)
end

function getNumPositiveBits(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_getNumPositiveBits(x)
end

function getODRHash(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_getODRHash(x)
end

function getPromotionType(x::AbstractEnumDecl)
    @check_ptrs x
    return QualType(clang_EnumDecl_getPromotionType(x))
end

function getTemplateInstantiationPattern(x::AbstractEnumDecl)
    @check_ptrs x
    return EnumDecl(clang_EnumDecl_getTemplateInstantiationPattern(x))
end

function getTemplateSpecializationKind(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_getTemplateSpecializationKind(x)
end

function isClosed(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isClosed(x)
end

function isClosedFlag(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isClosedFlag(x)
end

function isClosedNonFlag(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isClosedNonFlag(x)
end

function isComplete(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isComplete(x)
end

function isFixed(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isFixed(x)
end

function isScoped(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isScoped(x)
end

function isScopedUsingClassTag(x::AbstractEnumDecl)
    @check_ptrs x
    return clang_EnumDecl_isScopedUsingClassTag(x)
end

function getNumEnumerators(x::AbstractEnumDecl)
    @check_ptrs x
    return Int(clang_EnumDecl_getNumEnumerators(x))
end

"""
    getEnumerators(x::AbstractEnumDecl) -> Vector{EnumConstantDecl}
Return the enumerators declared in the enum, in source order.
"""

function getEnumerators(x::AbstractEnumDecl)
    @check_ptrs x
    n = clang_EnumDecl_getNumEnumerators(x)
    buf = Vector{CXEnumConstantDecl}(undef, n)
    n > 0 && clang_EnumDecl_getEnumerators(x, buf)
    return [EnumConstantDecl(p) for p in buf]
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

function canPassInRegisters(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_canPassInRegisters(x)
end

function findFirstNamedDataMember(x::AbstractRecordDecl)
    @check_ptrs x
    return FieldDecl(clang_RecordDecl_findFirstNamedDataMember(x))
end

function getArgPassingRestrictions(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_getArgPassingRestrictions(x)
end

function hasLoadedFieldsFromExternalStorage(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasLoadedFieldsFromExternalStorage(x)
end

function hasNonTrivialToPrimitiveCopyCUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasNonTrivialToPrimitiveCopyCUnion(x)
end

function hasNonTrivialToPrimitiveDefaultInitializeCUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasNonTrivialToPrimitiveDefaultInitializeCUnion(x)
end

function hasNonTrivialToPrimitiveDestructCUnion(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasNonTrivialToPrimitiveDestructCUnion(x)
end

function hasObjectMember(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasObjectMember(x)
end

function hasVolatileMember(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_hasVolatileMember(x)
end

function isNonTrivialToPrimitiveCopy(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isNonTrivialToPrimitiveCopy(x)
end

function isNonTrivialToPrimitiveDefaultInitialize(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isNonTrivialToPrimitiveDefaultInitialize(x)
end

function isNonTrivialToPrimitiveDestroy(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isNonTrivialToPrimitiveDestroy(x)
end

function isParamDestroyedInCallee(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_isParamDestroyedInCallee(x)
end

function getNumFields(x::AbstractRecordDecl)
    @check_ptrs x
    return Int(clang_RecordDecl_getNumFields(x))
end

"""
    getFields(x::AbstractRecordDecl) -> Vector{FieldDecl}
Return the fields (non-static data members) of the record, in layout order.
"""

function getFields(x::AbstractRecordDecl)
    @check_ptrs x
    n = clang_RecordDecl_getNumFields(x)
    buf = Vector{CXFieldDecl}(undef, n)
    n > 0 && clang_RecordDecl_getFields(x, buf)
    return [FieldDecl(p) for p in buf]
end

# RecordDecl Cast
function ClassTemplateSpecializationDecl(x::RecordDecl)
    @check_ptrs x
    return ClassTemplateSpecializationDecl(clang_RecordDecl_castToClassTemplateSpecializationDecl(x))
end

# BlockDecl
function blockMissingReturnType(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_blockMissingReturnType(x)
end

function canAvoidCopyToHeap(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_canAvoidCopyToHeap(x)
end

function capturesCXXThis(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_capturesCXXThis(x)
end

function doesNotEscape(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_doesNotEscape(x)
end

function getBlockManglingContextDecl(x::AbstractBlockDecl)
    @check_ptrs x
    return Decl(clang_BlockDecl_getBlockManglingContextDecl(x))
end

function getBlockManglingNumber(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_getBlockManglingNumber(x)
end

function getCaretLocation(x::AbstractBlockDecl)
    @check_ptrs x
    return SourceLocation(clang_BlockDecl_getCaretLocation(x))
end

function getNumCaptures(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_getNumCaptures(x)
end

function getNumParams(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_getNumParams(x)
end

function getSignatureAsWritten(x::AbstractBlockDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_BlockDecl_getSignatureAsWritten(x))
end

function getSourceRange(x::AbstractBlockDecl)
    @check_ptrs x
    r = clang_BlockDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function hasCaptures(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_hasCaptures(x)
end

function isConversionFromLambda(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_isConversionFromLambda(x)
end

function isVariadic(x::AbstractBlockDecl)
    @check_ptrs x
    return clang_BlockDecl_isVariadic(x)
end

# CapturedDecl
function getBody(x::AbstractCapturedDecl)
    @check_ptrs x
    return Stmt(clang_CapturedDecl_getBody(x))
end

function getContextParam(x::AbstractCapturedDecl)
    @check_ptrs x
    return ImplicitParamDecl(clang_CapturedDecl_getContextParam(x))
end

function getContextParamPosition(x::AbstractCapturedDecl)
    @check_ptrs x
    return clang_CapturedDecl_getContextParamPosition(x)
end

function getNumParams(x::AbstractCapturedDecl)
    @check_ptrs x
    return clang_CapturedDecl_getNumParams(x)
end

function isNothrow(x::AbstractCapturedDecl)
    @check_ptrs x
    return clang_CapturedDecl_isNothrow(x)
end

# ExportDecl
function getEndLoc(x::AbstractExportDecl)
    @check_ptrs x
    return SourceLocation(clang_ExportDecl_getEndLoc(x))
end

function getExportLoc(x::AbstractExportDecl)
    @check_ptrs x
    return SourceLocation(clang_ExportDecl_getExportLoc(x))
end

function getRBraceLoc(x::AbstractExportDecl)
    @check_ptrs x
    return SourceLocation(clang_ExportDecl_getRBraceLoc(x))
end

function getSourceRange(x::AbstractExportDecl)
    @check_ptrs x
    r = clang_ExportDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function hasBraces(x::AbstractExportDecl)
    @check_ptrs x
    return clang_ExportDecl_hasBraces(x)
end

# FieldDecl
function getBitWidth(x::AbstractFieldDecl)
    @check_ptrs x
    return Expr_(clang_FieldDecl_getBitWidth(x))
end

function getCanonicalDecl(x::AbstractFieldDecl)
    @check_ptrs x
    return FieldDecl(clang_FieldDecl_getCanonicalDecl(x))
end

function getCapturedVLAType(x::AbstractFieldDecl)
    @check_ptrs x
    return VariableArrayType(clang_FieldDecl_getCapturedVLAType(x))
end

function getFieldIndex(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_getFieldIndex(x)
end

function getInClassInitStyle(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_getInClassInitStyle(x)
end

function getInClassInitializer(x::AbstractFieldDecl)
    @check_ptrs x
    return Expr_(clang_FieldDecl_getInClassInitializer(x))
end

function getParent(x::AbstractFieldDecl)
    @check_ptrs x
    return RecordDecl(clang_FieldDecl_getParent(x))
end

function getSourceRange(x::AbstractFieldDecl)
    @check_ptrs x
    r = clang_FieldDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function hasCapturedVLAType(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_hasCapturedVLAType(x)
end

function hasInClassInitializer(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_hasInClassInitializer(x)
end

function isAnonymousStructOrUnion(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_isAnonymousStructOrUnion(x)
end

function isBitField(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_isBitField(x)
end

function isMutable(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_isMutable(x)
end

function isUnnamedBitfield(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_isUnnamedBitfield(x)
end

function removeBitWidth(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_removeBitWidth(x)
end

function removeInClassInitializer(x::AbstractFieldDecl)
    @check_ptrs x
    return clang_FieldDecl_removeInClassInitializer(x)
end

# FileScopeAsmDecl
function getAsmLoc(x::AbstractFileScopeAsmDecl)
    @check_ptrs x
    return SourceLocation(clang_FileScopeAsmDecl_getAsmLoc(x))
end

function getAsmString(x::AbstractFileScopeAsmDecl)
    @check_ptrs x
    return StringLiteral(clang_FileScopeAsmDecl_getAsmString(x))
end

function getRParenLoc(x::AbstractFileScopeAsmDecl)
    @check_ptrs x
    return SourceLocation(clang_FileScopeAsmDecl_getRParenLoc(x))
end

function getSourceRange(x::AbstractFileScopeAsmDecl)
    @check_ptrs x
    r = clang_FileScopeAsmDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# ImportDecl
function getImportedModule(x::AbstractImportDecl)
    @check_ptrs x
    return Module(clang_ImportDecl_getImportedModule(x))
end

function getNumIdentifierLocs(x::AbstractImportDecl)
    @check_ptrs x
    return clang_ImportDecl_getNumIdentifierLocs(x)
end

function getIdentifierLoc(x::AbstractImportDecl, i::Integer)
    @check_ptrs x
    return SourceLocation(clang_ImportDecl_getIdentifierLoc(x, i))
end

function getSourceRange(x::AbstractImportDecl)
    @check_ptrs x
    r = clang_ImportDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# IndirectFieldDecl
function getAnonField(x::AbstractIndirectFieldDecl)
    @check_ptrs x
    return FieldDecl(clang_IndirectFieldDecl_getAnonField(x))
end

function getCanonicalDecl(x::AbstractIndirectFieldDecl)
    @check_ptrs x
    return IndirectFieldDecl(clang_IndirectFieldDecl_getCanonicalDecl(x))
end

function getChainingSize(x::AbstractIndirectFieldDecl)
    @check_ptrs x
    return clang_IndirectFieldDecl_getChainingSize(x)
end

function getChainElement(x::AbstractIndirectFieldDecl, i::Integer)
    @check_ptrs x
    return NamedDecl(clang_IndirectFieldDecl_getChainElement(x, i))
end

function getVarDecl(x::AbstractIndirectFieldDecl)
    @check_ptrs x
    return VarDecl(clang_IndirectFieldDecl_getVarDecl(x))
end

# TypeAliasDecl
function getDescribedAliasTemplate(x::AbstractTypeAliasDecl)
    @check_ptrs x
    return TypeAliasTemplateDecl(clang_TypeAliasDecl_getDescribedAliasTemplate(x))
end

function getSourceRange(x::AbstractTypeAliasDecl)
    @check_ptrs x
    r = clang_TypeAliasDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# TypedefDecl
function getSourceRange(x::AbstractTypedefDecl)
    @check_ptrs x
    r = clang_TypedefDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# --- Decl introspection accessors ---

function isFunctionOrFunctionTemplate(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFunctionOrFunctionTemplate(x)
end

function getBitWidthValue(x::AbstractFieldDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_FieldDecl_getBitWidthValue(x, ctx)
end

function isZeroLengthBitField(x::AbstractFieldDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_FieldDecl_isZeroLengthBitField(x, ctx)
end

function isZeroSize(x::AbstractFieldDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_FieldDecl_isZeroSize(x, ctx)
end

function isMsStruct(x::AbstractRecordDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_RecordDecl_isMsStruct(x, ctx)
end

function mayInsertExtraPadding(x::AbstractRecordDecl, emit_remark::Bool=false)
    @check_ptrs x
    return clang_RecordDecl_mayInsertExtraPadding(x, emit_remark)
end

function capturesVariable(x::AbstractBlockDecl, var::AbstractVarDecl)
    @check_ptrs x var
    return clang_BlockDecl_capturesVariable(x, var)
end

function getParamDecl(x::AbstractBlockDecl, i::Integer)
    @check_ptrs x
    return ParmVarDecl(clang_BlockDecl_getParamDecl(x, i))
end

# All formal parameters of a block, in order.
function getParams(x::AbstractBlockDecl)
    @check_ptrs x
    return ParmVarDecl[getParamDecl(x, i) for i = 0:(clang_BlockDecl_getNumParams(x) - 1)]
end

function getParam(x::AbstractCapturedDecl, i::Integer)
    @check_ptrs x
    return ImplicitParamDecl(clang_CapturedDecl_getParam(x, i))
end

# --- SetFactory sweep: skiplisted set*/Create*/CreateDeserialized ---

# TranslationUnitDecl
function TranslationUnitDecl(ctx::ASTContext)
    @check_ptrs ctx
    return TranslationUnitDecl(clang_TranslationUnitDecl_Create(ctx))
end

# LabelDecl
function LabelDecl(ctx::ASTContext, dc::DeclContext, ident_loc::SourceLocation, id::IdentifierInfo)
    @check_ptrs ctx dc id
    return LabelDecl(clang_LabelDecl_Create(ctx, dc, ident_loc, id))
end

function LabelDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return LabelDecl(clang_LabelDecl_CreateDeserialized(ctx, id))
end

# NamespaceDecl
function NamespaceDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return NamespaceDecl(clang_NamespaceDecl_CreateDeserialized(ctx, id))
end

# VarDecl
function VarDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                 id::IdentifierInfo, ty::QualType, tsi::TypeSourceInfo, sc::CXStorageClass)
    @check_ptrs ctx dc id tsi
    return VarDecl(clang_VarDecl_Create(ctx, dc, start_loc, id_loc, id, ty, tsi, sc))
end

function VarDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return VarDecl(clang_VarDecl_CreateDeserialized(ctx, id))
end

# ImplicitParamDecl
function ImplicitParamDecl(ctx::ASTContext, dc::DeclContext, id_loc::SourceLocation,
                           id::IdentifierInfo, ty::QualType, param_kind::CXImplicitParamKind)
    @check_ptrs ctx dc
    return ImplicitParamDecl(clang_ImplicitParamDecl_Create(ctx, dc, id_loc, id, ty, param_kind))
end

function ImplicitParamDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return ImplicitParamDecl(clang_ImplicitParamDecl_CreateDeserialized(ctx, id))
end

# ParmVarDecl
function ParmVarDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                     id::IdentifierInfo, ty::QualType, tsi::TypeSourceInfo, sc::CXStorageClass,
                     def_arg::Expr_=Expr_(C_NULL))
    @check_ptrs ctx dc id tsi
    return ParmVarDecl(clang_ParmVarDecl_Create(ctx, dc, start_loc, id_loc, id, ty, tsi, sc, def_arg))
end

function ParmVarDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return ParmVarDecl(clang_ParmVarDecl_CreateDeserialized(ctx, id))
end

# FunctionDecl
function FunctionDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, name_loc::SourceLocation,
                      name::DeclarationName, ty::QualType, tsi::TypeSourceInfo, sc::CXStorageClass,
                      is_inline_specified::Bool, has_written_prototype::Bool)
    @check_ptrs ctx dc tsi
    return FunctionDecl(clang_FunctionDecl_Create(ctx, dc, start_loc, name_loc, name, ty, tsi, sc,
                                                  is_inline_specified, has_written_prototype))
end

function FunctionDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return FunctionDecl(clang_FunctionDecl_CreateDeserialized(ctx, id))
end

function setIsPureVirtual(x::AbstractFunctionDecl, p::Bool=true)
    @check_ptrs x
    return clang_FunctionDecl_setIsPureVirtual(x, p)
end

# FieldDecl
function FieldDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                   id::IdentifierInfo, ty::QualType, tsi::TypeSourceInfo, bw::Expr_,
                   mutable::Bool, init_style::CXInClassInitStyle)
    @check_ptrs ctx dc tsi
    return FieldDecl(clang_FieldDecl_Create(ctx, dc, start_loc, id_loc, id, ty, tsi, bw, mutable, init_style))
end

function FieldDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return FieldDecl(clang_FieldDecl_CreateDeserialized(ctx, id))
end

function setBitWidth(x::AbstractFieldDecl, width::Expr_)
    @check_ptrs x width
    return clang_FieldDecl_setBitWidth(x, width)
end

function setInClassInitializer(x::AbstractFieldDecl, init::Expr_)
    @check_ptrs x init
    return clang_FieldDecl_setInClassInitializer(x, init)
end

function setCapturedVLAType(x::AbstractFieldDecl, vla::VariableArrayType)
    @check_ptrs x vla
    return clang_FieldDecl_setCapturedVLAType(x, vla)
end

# EnumConstantDecl
function EnumConstantDecl(ctx::ASTContext, dc::AbstractEnumDecl, loc::SourceLocation,
                          id::IdentifierInfo, ty::QualType, init::Expr_,
                          val::LibClangEx.LLVMGenericValueRef)
    @check_ptrs ctx dc
    return EnumConstantDecl(clang_EnumConstantDecl_Create(ctx, dc, loc, id, ty, init, val))
end

function EnumConstantDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return EnumConstantDecl(clang_EnumConstantDecl_CreateDeserialized(ctx, id))
end

function setInitExpr(x::AbstractEnumConstantDecl, e::Expr_)
    @check_ptrs x e
    return clang_EnumConstantDecl_setInitExpr(x, e)
end

# IndirectFieldDecl
function IndirectFieldDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return IndirectFieldDecl(clang_IndirectFieldDecl_CreateDeserialized(ctx, id))
end

# TypedefDecl
function TypedefDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                     id::IdentifierInfo, tsi::TypeSourceInfo)
    @check_ptrs ctx dc id tsi
    return TypedefDecl(clang_TypedefDecl_Create(ctx, dc, start_loc, id_loc, id, tsi))
end

function TypedefDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return TypedefDecl(clang_TypedefDecl_CreateDeserialized(ctx, id))
end

# TypeAliasDecl
function TypeAliasDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                       id::IdentifierInfo, tsi::TypeSourceInfo)
    @check_ptrs ctx dc id tsi
    return TypeAliasDecl(clang_TypeAliasDecl_Create(ctx, dc, start_loc, id_loc, id, tsi))
end

function TypeAliasDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return TypeAliasDecl(clang_TypeAliasDecl_CreateDeserialized(ctx, id))
end

function setDescribedAliasTemplate(x::AbstractTypeAliasDecl, tat::TypeAliasTemplateDecl)
    @check_ptrs x tat
    return clang_TypeAliasDecl_setDescribedAliasTemplate(x, tat)
end

# TypedefNameDecl
function setTypeSourceInfo(x::AbstractTypedefNameDecl, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_TypedefNameDecl_setTypeSourceInfo(x, tsi)
end

function setModedTypeSourceInfo(x::AbstractTypedefNameDecl, unmoded_tsi::TypeSourceInfo, moded_ty::QualType)
    @check_ptrs x unmoded_tsi
    return clang_TypedefNameDecl_setModedTypeSourceInfo(x, unmoded_tsi, moded_ty)
end

# TagDecl
function setBraceRange(x::AbstractTagDecl, r::SourceRange)
    @check_ptrs x
    return clang_TagDecl_setBraceRange(x, CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr))
end

function setCompleteDefinitionRequired(x::AbstractTagDecl, v::Bool=true)
    @check_ptrs x
    return clang_TagDecl_setCompleteDefinitionRequired(x, v)
end

function setEmbeddedInDeclarator(x::AbstractTagDecl, v::Bool=true)
    @check_ptrs x
    return clang_TagDecl_setEmbeddedInDeclarator(x, v)
end

function setFreeStanding(x::AbstractTagDecl, v::Bool=true)
    @check_ptrs x
    return clang_TagDecl_setFreeStanding(x, v)
end

function setTagKind(x::AbstractTagDecl, tk::CXTagTypeKind)
    @check_ptrs x
    return clang_TagDecl_setTagKind(x, tk)
end

function setTypedefNameForAnonDecl(x::AbstractTagDecl, tnd::AbstractTypedefNameDecl)
    @check_ptrs x tnd
    return clang_TagDecl_setTypedefNameForAnonDecl(x, tnd)
end

# EnumDecl
function EnumDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation, id_loc::SourceLocation,
                  id::IdentifierInfo, prev_decl::EnumDecl=EnumDecl(C_NULL), is_scoped::Bool=false,
                  is_scoped_using_class_tag::Bool=false, is_fixed::Bool=false)
    @check_ptrs ctx dc id
    return EnumDecl(clang_EnumDecl_Create(ctx, dc, start_loc, id_loc, id, prev_decl, is_scoped,
                                          is_scoped_using_class_tag, is_fixed))
end

function EnumDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return EnumDecl(clang_EnumDecl_CreateDeserialized(ctx, id))
end

function setScoped(x::AbstractEnumDecl, scoped::Bool=true)
    @check_ptrs x
    return clang_EnumDecl_setScoped(x, scoped)
end

function setScopedUsingClassTag(x::AbstractEnumDecl, v::Bool=true)
    @check_ptrs x
    return clang_EnumDecl_setScopedUsingClassTag(x, v)
end

function setFixed(x::AbstractEnumDecl, fixed::Bool=true)
    @check_ptrs x
    return clang_EnumDecl_setFixed(x, fixed)
end

function setIntegerType(x::AbstractEnumDecl, ty::QualType)
    @check_ptrs x
    return clang_EnumDecl_setIntegerType(x, ty)
end

function setIntegerTypeSourceInfo(x::AbstractEnumDecl, tsi::TypeSourceInfo)
    @check_ptrs x tsi
    return clang_EnumDecl_setIntegerTypeSourceInfo(x, tsi)
end

function setPromotionType(x::AbstractEnumDecl, ty::QualType)
    @check_ptrs x
    return clang_EnumDecl_setPromotionType(x, ty)
end

function completeDefinition(x::AbstractEnumDecl, new_type::QualType, promotion_type::QualType,
                            num_positive_bits::Integer, num_negative_bits::Integer)
    @check_ptrs x
    return clang_EnumDecl_completeDefinition(x, new_type, promotion_type, num_positive_bits,
                                             num_negative_bits)
end
function setTemplateSpecializationKind(x::AbstractEnumDecl, tsk::CXTemplateSpecializationKind, poi::SourceLocation)
    @check_ptrs x
    return clang_EnumDecl_setTemplateSpecializationKind(x, tsk, poi)
end

function setInstantiationOfMemberEnum(x::AbstractEnumDecl, ed::AbstractEnumDecl, tsk::CXTemplateSpecializationKind)
    @check_ptrs x ed
    return clang_EnumDecl_setInstantiationOfMemberEnum(x, ed, tsk)
end

# RecordDecl
function RecordDecl(ctx::ASTContext, tk::CXTagTypeKind, dc::DeclContext, start_loc::SourceLocation,
                    id_loc::SourceLocation, id::IdentifierInfo, prev_decl::RecordDecl=RecordDecl(C_NULL))
    @check_ptrs ctx dc
    return RecordDecl(clang_RecordDecl_Create(ctx, tk, dc, start_loc, id_loc, id, prev_decl))
end

function RecordDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return RecordDecl(clang_RecordDecl_CreateDeserialized(ctx, id))
end

function setArgPassingRestrictions(x::AbstractRecordDecl, kind::CXRecordArgPassingKind)
    @check_ptrs x
    return clang_RecordDecl_setArgPassingRestrictions(x, kind)
end

function setAnonymousStructOrUnion(x::AbstractRecordDecl, anon::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setAnonymousStructOrUnion(x, anon)
end

function setCapturedRecord(x::AbstractRecordDecl)
    @check_ptrs x
    return clang_RecordDecl_setCapturedRecord(x)
end

function setHasFlexibleArrayMember(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasFlexibleArrayMember(x, v)
end

function setHasLoadedFieldsFromExternalStorage(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasLoadedFieldsFromExternalStorage(x, v)
end

function setHasNonTrivialToPrimitiveCopyCUnion(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasNonTrivialToPrimitiveCopyCUnion(x, v)
end

function setHasNonTrivialToPrimitiveDefaultInitializeCUnion(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasNonTrivialToPrimitiveDefaultInitializeCUnion(x, v)
end

function setHasNonTrivialToPrimitiveDestructCUnion(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasNonTrivialToPrimitiveDestructCUnion(x, v)
end

function setHasObjectMember(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasObjectMember(x, v)
end

function setHasVolatileMember(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setHasVolatileMember(x, v)
end

function setNonTrivialToPrimitiveCopy(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setNonTrivialToPrimitiveCopy(x, v)
end

function setNonTrivialToPrimitiveDefaultInitialize(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setNonTrivialToPrimitiveDefaultInitialize(x, v)
end

function setNonTrivialToPrimitiveDestroy(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setNonTrivialToPrimitiveDestroy(x, v)
end

function setParamDestroyedInCallee(x::AbstractRecordDecl, v::Bool=true)
    @check_ptrs x
    return clang_RecordDecl_setParamDestroyedInCallee(x, v)
end

# FileScopeAsmDecl
function FileScopeAsmDecl(ctx::ASTContext, dc::DeclContext, str::StringLiteral,
                          asm_loc::SourceLocation, rparen_loc::SourceLocation)
    @check_ptrs ctx dc str
    return FileScopeAsmDecl(clang_FileScopeAsmDecl_Create(ctx, dc, str, asm_loc, rparen_loc))
end

function FileScopeAsmDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return FileScopeAsmDecl(clang_FileScopeAsmDecl_CreateDeserialized(ctx, id))
end

function setAsmString(x::AbstractFileScopeAsmDecl, asm::StringLiteral)
    @check_ptrs x asm
    return clang_FileScopeAsmDecl_setAsmString(x, asm)
end

function setRParenLoc(x::AbstractFileScopeAsmDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_FileScopeAsmDecl_setRParenLoc(x, loc)
end

# BlockDecl
function BlockDecl(ctx::ASTContext, dc::DeclContext, loc::SourceLocation)
    @check_ptrs ctx dc
    return BlockDecl(clang_BlockDecl_Create(ctx, dc, loc))
end

function BlockDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return BlockDecl(clang_BlockDecl_CreateDeserialized(ctx, id))
end

function setBody(x::AbstractBlockDecl, body::CompoundStmt)
    @check_ptrs x body
    return clang_BlockDecl_setBody(x, body)
end

function setSignatureAsWritten(x::AbstractBlockDecl, sig::TypeSourceInfo)
    @check_ptrs x sig
    return clang_BlockDecl_setSignatureAsWritten(x, sig)
end

function setCapturesCXXThis(x::AbstractBlockDecl, b::Bool=true)
    @check_ptrs x
    return clang_BlockDecl_setCapturesCXXThis(x, b)
end

function setBlockMissingReturnType(x::AbstractBlockDecl, v::Bool=true)
    @check_ptrs x
    return clang_BlockDecl_setBlockMissingReturnType(x, v)
end

function setIsConversionFromLambda(x::AbstractBlockDecl, v::Bool=true)
    @check_ptrs x
    return clang_BlockDecl_setIsConversionFromLambda(x, v)
end

function setDoesNotEscape(x::AbstractBlockDecl, b::Bool=true)
    @check_ptrs x
    return clang_BlockDecl_setDoesNotEscape(x, b)
end

function setCanAvoidCopyToHeap(x::AbstractBlockDecl, b::Bool=true)
    @check_ptrs x
    return clang_BlockDecl_setCanAvoidCopyToHeap(x, b)
end

function setBlockMangling(x::AbstractBlockDecl, number::Integer, ctx_decl::AbstractDecl)
    @check_ptrs x ctx_decl
    return clang_BlockDecl_setBlockMangling(x, number, ctx_decl)
end

# CapturedDecl
function CapturedDecl(ctx::ASTContext, dc::DeclContext, num_params::Integer)
    @check_ptrs ctx dc
    return CapturedDecl(clang_CapturedDecl_Create(ctx, dc, num_params))
end

function CapturedDecl(ctx::ASTContext, id::Integer, num_params::Integer)
    @check_ptrs ctx
    return CapturedDecl(clang_CapturedDecl_CreateDeserialized(ctx, id, num_params))
end

function setBody(x::AbstractCapturedDecl, body::AbstractStmt)
    @check_ptrs x body
    return clang_CapturedDecl_setBody(x, body)
end

function setNothrow(x::AbstractCapturedDecl, nothrow::Bool=true)
    @check_ptrs x
    return clang_CapturedDecl_setNothrow(x, nothrow)
end

function setParam(x::AbstractCapturedDecl, i::Integer, p::ImplicitParamDecl)
    @check_ptrs x p
    return clang_CapturedDecl_setParam(x, i, p)
end

function setContextParam(x::AbstractCapturedDecl, i::Integer, p::ImplicitParamDecl)
    @check_ptrs x p
    return clang_CapturedDecl_setContextParam(x, i, p)
end

# ImportDecl
function ImportDecl(ctx::ASTContext, dc::DeclContext, start_loc::SourceLocation,
                    imported::CXModule, end_loc::SourceLocation)
    @check_ptrs ctx dc
    return ImportDecl(clang_ImportDecl_CreateImplicit(ctx, dc, start_loc, imported, end_loc))
end

function ImportDecl(ctx::ASTContext, id::Integer, num_locations::Integer)
    @check_ptrs ctx
    return ImportDecl(clang_ImportDecl_CreateDeserialized(ctx, id, num_locations))
end

# ExportDecl
function ExportDecl(ctx::ASTContext, dc::DeclContext, export_loc::SourceLocation)
    @check_ptrs ctx dc
    return ExportDecl(clang_ExportDecl_Create(ctx, dc, export_loc))
end

function ExportDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return ExportDecl(clang_ExportDecl_CreateDeserialized(ctx, id))
end

function setRBraceLoc(x::AbstractExportDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_ExportDecl_setRBraceLoc(x, loc)
end

# EmptyDecl
function EmptyDecl(ctx::ASTContext, dc::DeclContext, loc::SourceLocation)
    @check_ptrs ctx dc
    return EmptyDecl(clang_EmptyDecl_Create(ctx, dc, loc))
end

function EmptyDecl(ctx::ASTContext, id::Integer)
    @check_ptrs ctx
    return EmptyDecl(clang_EmptyDecl_CreateDeserialized(ctx, id))
end

# PragmaCommentDecl factories
function PragmaCommentDecl(ctx::ASTContext, tu::TranslationUnitDecl, comment_loc::SourceLocation,
                           kind::CXPragmaMSCommentKind, arg::AbstractString)
    @check_ptrs ctx tu
    return PragmaCommentDecl(clang_PragmaCommentDecl_Create(ctx, tu, comment_loc, kind, arg))
end

function PragmaCommentDecl(ctx::ASTContext, id::Integer, arg_size::Integer)
    @check_ptrs ctx
    return PragmaCommentDecl(clang_PragmaCommentDecl_CreateDeserialized(ctx, id, arg_size))
end

# PragmaDetectMismatchDecl factories
function PragmaDetectMismatchDecl(ctx::ASTContext, tu::TranslationUnitDecl, loc::SourceLocation,
                                  name::AbstractString, value::AbstractString)
    @check_ptrs ctx tu
    return PragmaDetectMismatchDecl(clang_PragmaDetectMismatchDecl_Create(ctx, tu, loc, name, value))
end

function PragmaDetectMismatchDecl(ctx::ASTContext, id::Integer, name_value_size::Integer)
    @check_ptrs ctx
    return PragmaDetectMismatchDecl(clang_PragmaDetectMismatchDecl_CreateDeserialized(ctx, id,
                                                                                      name_value_size))
end

# ExternCContextDecl factory
function ExternCContextDecl(ctx::ASTContext, tu::TranslationUnitDecl)
    @check_ptrs ctx tu
    return ExternCContextDecl(clang_ExternCContextDecl_Create(ctx, tu))
end
