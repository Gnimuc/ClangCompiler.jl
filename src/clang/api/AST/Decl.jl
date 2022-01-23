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
