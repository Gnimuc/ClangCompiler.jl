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

function getKind(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getKind(x)
end

function hasAttrs(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_hasAttrs(x)
end

function getNumAttrs(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getNumAttrs(x)
end

# The borrowed `Attr` at position `i` (0-based); classify it with `getKind`.
function getAttr(x::AbstractDecl, i::Integer)
    @check_ptrs x
    return Attr(clang_Decl_getAttr(x, i))
end

# All attributes on `x`, each a borrowed `Attr`.
function getAttrs(x::AbstractDecl)
    @check_ptrs x
    return Attr[getAttr(x, i) for i in 0:(getNumAttrs(x) - 1)]
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

function dump(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_dump(x)
end

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

function CXXConstructorDecl(x::AbstractDecl)
    @check_ptrs x
    return CXXConstructorDecl(clang_Decl_castToCXXConstructorDecl(x))
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
    return DeclContext(clang_DeclContext_getParent(x))
end

function getLexicalParent(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getLexicalParent(x))
end

function getLookupParent(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getLookupParent(x))
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


# Decl (argument-taking and value-returning surface)
function getSourceRange(x::AbstractDecl)
    @check_ptrs x
    r = clang_Decl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function setLocation(x::AbstractDecl, loc::SourceLocation)
    @check_ptrs x
    return clang_Decl_setLocation(x, loc)
end

function getNonTransparentDeclContext(x::AbstractDecl)
    @check_ptrs x
    return DeclContext(clang_Decl_getNonTransparentDeclContext(x))
end

function isFileContextDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFileContextDecl(x)
end

"""
    getAccess(x::AbstractDecl) -> CXAccessSpecifier
The access specifier of `x`. Clang asserts the specifier has been set when `x` is
a class member; use [`getAccessUnsafe`](@ref) to read it unconditionally.
"""
function getAccess(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getAccess(x)
end

function getAccessUnsafe(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getAccessUnsafe(x)
end

function setAccess(x::AbstractDecl, as::CXAccessSpecifier)
    @check_ptrs x
    return clang_Decl_setAccess(x, as)
end

function addAttr(x::AbstractDecl, attr::AbstractAttr)
    @check_ptrs x attr
    return clang_Decl_addAttr(x, attr)
end

function dropAttrs(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_dropAttrs(x)
end

"""
    hasAttrOfKind(x::AbstractDecl, k::CXAttrKind) -> Bool
Whether `x` carries an attribute of kind `k`. This is the kind-indexed form of
clang's `hasAttr<T>()` template, which cannot cross the C boundary.
"""
function hasAttrOfKind(x::AbstractDecl, k::CXAttrKind)
    @check_ptrs x
    return clang_Decl_hasAttrOfKind(x, k)
end

"""
    getAttrOfKind(x::AbstractDecl, k::CXAttrKind) -> Attr
The first attribute of kind `k` on `x`, or a NULL-pointer `Attr` when there is
none. Refine it with the `Attr` downcasts.
"""
function getAttrOfKind(x::AbstractDecl, k::CXAttrKind)
    @check_ptrs x
    return Attr(clang_Decl_getAttrOfKind(x, k))
end

function getMaxAlignment(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getMaxAlignment(x)
end

function isInvalidDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInvalidDecl(x)
end

function setInvalidDecl(x::AbstractDecl, invalid::Bool=true)
    @check_ptrs x
    return clang_Decl_setInvalidDecl(x, invalid)
end

function isImplicit(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isImplicit(x)
end

function setImplicit(x::AbstractDecl, i::Bool=true)
    @check_ptrs x
    return clang_Decl_setImplicit(x, i)
end

function isUsed(x::AbstractDecl, check_used_attr::Bool=true)
    @check_ptrs x
    return clang_Decl_isUsed(x, check_used_attr)
end

function setIsUsed(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_setIsUsed(x)
end

function markUsed(x::AbstractDecl, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_Decl_markUsed(x, ctx)
end

function isReferenced(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isReferenced(x)
end

function isThisDeclarationReferenced(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isThisDeclarationReferenced(x)
end

function setReferenced(x::AbstractDecl, r::Bool=true)
    @check_ptrs x
    return clang_Decl_setReferenced(x, r)
end

function getExternalSourceSymbolAttr(x::AbstractDecl)
    @check_ptrs x
    return Attr(clang_Decl_getExternalSourceSymbolAttr(x))
end

function isModulePrivate(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isModulePrivate(x)
end

function isInExportDeclContext(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInExportDeclContext(x)
end

function isInvisibleOutsideTheOwningModule(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInvisibleOutsideTheOwningModule(x)
end

function isInAnotherModuleUnit(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isInAnotherModuleUnit(x)
end

function hasDefiningAttr(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_hasDefiningAttr(x)
end

function getDefiningAttr(x::AbstractDecl)
    @check_ptrs x
    return Attr(clang_Decl_getDefiningAttr(x))
end

function getAvailability(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getAvailability(x)
end

"""
    getAvailabilityMessage(x::AbstractDecl) -> String
The message explaining why `x` is deprecated, unavailable or not yet introduced.
Empty when `x` is available or the attribute carries no message.
"""
function getAvailabilityMessage(x::AbstractDecl)
    @check_ptrs x
    return get_string(clang_Decl_getAvailabilityMessage(x))
end

"""
    getVersionIntroduced(x::AbstractDecl) -> Union{Nothing,NTuple{3,UInt32}}
The `(major, minor, subminor)` target-platform version `x` was introduced in, or
`nothing` when it carries no `introduced` availability attribute. Absent minor /
subminor components are reported as `0`.
"""
function getVersionIntroduced(x::AbstractDecl)
    @check_ptrs x
    major, minor, subminor = Ref{Cuint}(0), Ref{Cuint}(0), Ref{Cuint}(0)
    clang_Decl_getVersionIntroduced(x, major, minor, subminor) || return nothing
    return (major[], minor[], subminor[])
end

function isDeprecated(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isDeprecated(x)
end

function isUnavailable(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnavailable(x)
end

function isWeakImported(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isWeakImported(x)
end

"""
    canBeWeakImported(x::AbstractDecl) -> Tuple{Bool,Bool}
`(can_be_weak_imported, is_definition)`; the second element says `x` cannot be
weak-imported because it has a definition.
"""
function canBeWeakImported(x::AbstractDecl)
    @check_ptrs x
    is_definition = Ref{Bool}(false)
    can = clang_Decl_canBeWeakImported(x, is_definition)
    return (can, is_definition[])
end

function isFromASTFile(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFromASTFile(x)
end

function getImportedOwningModule(x::AbstractDecl)
    @check_ptrs x
    return Module_(clang_Decl_getImportedOwningModule(x))
end

function getLocalOwningModule(x::AbstractDecl)
    @check_ptrs x
    return Module_(clang_Decl_getLocalOwningModule(x))
end

function hasOwningModule(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_hasOwningModule(x)
end

function getOwningModule(x::AbstractDecl)
    @check_ptrs x
    return Module_(clang_Decl_getOwningModule(x))
end

function getOwningModuleForLinkage(x::AbstractDecl, ignore_linkage::Bool=false)
    @check_ptrs x
    return Module_(clang_Decl_getOwningModuleForLinkage(x, ignore_linkage))
end

function isUnconditionallyVisible(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnconditionallyVisible(x)
end

function isReachable(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isReachable(x)
end

function setVisibleDespiteOwningModule(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_setVisibleDespiteOwningModule(x)
end

function getModuleOwnershipKind(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getModuleOwnershipKind(x)
end

"""
    getIdentifierNamespace(x::AbstractDecl) -> UInt32
The OR of the `CXDecl_IdentifierNamespace` bits `x`'s name lives in — a bitmask,
not a single enumerator.
"""
function getIdentifierNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getIdentifierNamespace(x)
end

function isInIdentifierNamespace(x::AbstractDecl, ns::Integer)
    @check_ptrs x
    return clang_Decl_isInIdentifierNamespace(x, ns)
end

function hasTagIdentifierNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_hasTagIdentifierNamespace(x)
end

function getNumRedecls(x::AbstractDecl)
    @check_ptrs x
    return Int(clang_Decl_getNumRedecls(x))
end

"""
    getRedecls(x::AbstractDecl) -> Vector{Decl}
Every declaration in `x`'s redeclaration chain, in clang's iteration order (there
is always at least one — `x` itself). Wrapped at the `Decl` base; `resolve` them
to refine.
"""
function getRedecls(x::AbstractDecl)
    @check_ptrs x
    n = clang_Decl_getNumRedecls(x)
    buf = Vector{CXDecl}(undef, n)
    n > 0 && clang_Decl_getRedecls(x, buf)
    return [Decl(p) for p in buf]
end

function getBody(x::AbstractDecl)
    @check_ptrs x
    return Stmt(clang_Decl_getBody(x))
end

function hasBody(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_hasBody(x)
end

function getBodyRBrace(x::AbstractDecl)
    @check_ptrs x
    return SourceLocation(clang_Decl_getBodyRBrace(x))
end

function isLocalExternDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isLocalExternDecl(x)
end

function getFriendObjectKind(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getFriendObjectKind(x)
end

"""
    printToString(x::AbstractDecl, indentation=0, print_instantiation=false) -> String
Pretty-print `x` the way `clang::Decl::print` would.
"""
function printToString(x::AbstractDecl, indentation::Integer=0,
                       print_instantiation::Bool=false)
    @check_ptrs x
    return get_string(clang_Decl_printToString(x, indentation, print_instantiation))
end

function isFunctionPointerType(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFunctionPointerType(x)
end

"""
    classof(x::AbstractDecl) -> Bool
Whether `x` also is a `DeclContext`, i.e. whether `castToDeclContext(x)` is legal.
"""
function classof(x::AbstractDecl)
    @check_ptrs x
    return clang_DeclContext_classof(x)
end

# DeclContext (argument-taking and value-returning surface)
function getDeclKind(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_getDeclKind(x)
end

function getInnermostBlockDecl(x::DeclContext)
    @check_ptrs x
    return BlockDecl(clang_DeclContext_getInnermostBlockDecl(x))
end

function getExternCContext(x::DeclContext)
    @check_ptrs x
    return LinkageSpecDecl(clang_DeclContext_getExternCContext(x))
end

function Encloses(x::DeclContext, y::DeclContext)
    @check_ptrs x y
    return clang_DeclContext_Encloses(x, y)
end

function getNonClosureAncestor(x::DeclContext)
    @check_ptrs x
    return Decl(clang_DeclContext_getNonClosureAncestor(x))
end

function getNonTransparentContext(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getNonTransparentContext(x))
end

function getRedeclContext(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getRedeclContext(x))
end

function getEnclosingNamespaceContext(x::DeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getEnclosingNamespaceContext(x))
end

function getOuterLexicalRecordContext(x::DeclContext)
    @check_ptrs x
    return RecordDecl(clang_DeclContext_getOuterLexicalRecordContext(x))
end

function InEnclosingNamespaceSetOf(x::DeclContext, ns::DeclContext)
    @check_ptrs x ns
    return clang_DeclContext_InEnclosingNamespaceSetOf(x, ns)
end

function getNumAllContexts(x::DeclContext)
    @check_ptrs x
    return Int(clang_DeclContext_getNumAllContexts(x))
end

"""
    collectAllContexts(x::DeclContext) -> Vector{DeclContext}
Every semantic context connected to `x` — the reopenings of a namespace, in
source order — or just `x` itself for a non-namespace context.
"""
function collectAllContexts(x::DeclContext)
    @check_ptrs x
    n = clang_DeclContext_getNumAllContexts(x)
    buf = Vector{CXDeclContext}(undef, n)
    n > 0 && clang_DeclContext_collectAllContexts(x, buf)
    return [DeclContext(p) for p in buf]
end

function decls_empty(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_decls_empty(x)
end

function containsDeclAndLoad(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDeclAndLoad(x, decl)
end

function getNumLookupResults(x::DeclContext, name::DeclarationName)
    @check_ptrs x
    return Int(clang_DeclContext_getNumLookupResults(x, name))
end

"""
    lookup(x::DeclContext, name::DeclarationName) -> Vector{NamedDecl}
The declarations named `name` in `x`. Only this context is searched — parent
contexts are not. Object, function, member and enumerator names precede any tag
name, matching `clang::DeclContext::lookup`.
"""
function lookup(x::DeclContext, name::DeclarationName)
    @check_ptrs x
    n = clang_DeclContext_getNumLookupResults(x, name)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_DeclContext_lookup(x, name, buf)
    return [NamedDecl(p) for p in buf]
end

function makeDeclVisibleInContext(x::DeclContext, decl::AbstractNamedDecl)
    @check_ptrs x decl
    return clang_DeclContext_makeDeclVisibleInContext(x, decl)
end

function getNumUsingDirectives(x::DeclContext)
    @check_ptrs x
    return Int(clang_DeclContext_getNumUsingDirectives(x))
end

"""
    getUsingDirectives(x::DeclContext) -> Vector{UsingDirectiveDecl}
The `using namespace` directives written directly in `x`.
"""
function getUsingDirectives(x::DeclContext)
    @check_ptrs x
    n = clang_DeclContext_getNumUsingDirectives(x)
    buf = Vector{CXUsingDirectiveDecl}(undef, n)
    n > 0 && clang_DeclContext_getUsingDirectives(x, buf)
    return [UsingDirectiveDecl(p) for p in buf]
end

function hasExternalLexicalStorage(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_hasExternalLexicalStorage(x)
end

function hasExternalVisibleStorage(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_hasExternalVisibleStorage(x)
end

function isDeclInLexicalTraversal(x::DeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_isDeclInLexicalTraversal(x, decl)
end

function setUseQualifiedLookup(x::DeclContext, use::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setUseQualifiedLookup(x, use)
end

function shouldUseQualifiedLookup(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_shouldUseQualifiedLookup(x)
end


# Decl (Objective-C container flag, deserialization IDs, identifier-namespace statics)
"""
    isTopLevelDeclInObjCContainer(x::AbstractDecl) -> Bool
Whether `x` is a top-level declaration lexically inside an Objective-C container
definition.
"""
function isTopLevelDeclInObjCContainer(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTopLevelDeclInObjCContainer(x)
end

function setTopLevelDeclInObjCContainer(x::AbstractDecl, v::Bool=true)
    @check_ptrs x
    return clang_Decl_setTopLevelDeclInObjCContainer(x, v)
end

"""
    isDiscardedInGlobalModuleFragment(x::AbstractDecl) -> Bool
Whether `x` is discarded as unreachable in a global module fragment. Clang does
not implement discarding, so this is always `false`.
"""
function isDiscardedInGlobalModuleFragment(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isDiscardedInGlobalModuleFragment(x)
end

"""
    shouldSkipCheckingODR(x::AbstractDecl) -> Bool
Whether the ODR hash check is skipped for `x`.
"""
function shouldSkipCheckingODR(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_shouldSkipCheckingODR(x)
end

"""
    getGlobalID(x::AbstractDecl) -> UInt32
The global declaration ID recording where `x` was loaded from, or `0` when `x`
was parsed rather than deserialized.
"""
function getGlobalID(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getGlobalID(x)
end

"""
    getOwningModuleID(x::AbstractDecl) -> UInt32
The global ID of the module owning `x`, or `0` when `x` was parsed rather than
deserialized.
"""
function getOwningModuleID(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_getOwningModuleID(x)
end

"""
    setModuleOwnershipKind(x::AbstractDecl, mok::CXDecl_ModuleOwnershipKind)
Set how `x` is hidden from name lookup. A currently unowned decl has storage for
an owning module only when it came from an AST file, so it otherwise accepts
`CXDecl_Unowned` alone.
"""
function setModuleOwnershipKind(x::AbstractDecl, mok::CXDecl_ModuleOwnershipKind)
    @check_ptrs x
    has_storage = getModuleOwnershipKind(x) != CXDecl_Unowned || isFromASTFile(x)
    @assert mok == CXDecl_Unowned || has_storage "decl has no owning-module storage"
    return clang_Decl_setModuleOwnershipKind(x, mok)
end

"""
    getIdentifierNamespaceForKind(k::CXDeclKind) -> UInt32
The `CXDecl_IdentifierNamespace` bitmask every declaration of kind `k` starts out
in. Reads the kind alone, not a declaration.
"""
function getIdentifierNamespaceForKind(k::CXDeclKind)
    return clang_Decl_getIdentifierNamespaceForKind(k)
end

"""
    isTagIdentifierNamespace(ns::Integer) -> Bool
Whether the `CXDecl_IdentifierNamespace` bitmask `ns` is the one a tag
declaration carries. Reads the bitmask alone, not a declaration.
"""
function isTagIdentifierNamespace(ns::Integer)
    return clang_Decl_isTagIdentifierNamespace(ns)
end

# DeclContext (kind validity, Objective-C containers, no-load lookup, external storage)
"""
    hasValidDeclKind(x::DeclContext) -> Bool
Whether `x` carries a valid declaration kind. True for any correctly constructed
context within its lifetime; it exists for debugging.
"""
function hasValidDeclKind(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_hasValidDeclKind(x)
end

"""
    isObjCContainer(x::DeclContext) -> Bool
Whether `x` is an Objective-C interface, protocol, category or implementation.
"""
function isObjCContainer(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_isObjCContainer(x)
end

"""
    dumpAsDecl(x::DeclContext)
Dump the declaration owning `x` to stderr.
"""
function dumpAsDecl(x::DeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpAsDecl(x)
end

"""
    getNumNoloadLookupResults(x::DeclContext, name::DeclarationName) -> Int
The number of declarations named `name` already present in `x`'s lookup table.
No external AST source is consulted, so the count is `0` while the table is
unbuilt. `x` must not be a transparent context.
"""
function getNumNoloadLookupResults(x::DeclContext, name::DeclarationName)
    @check_ptrs x
    k = getDeclKind(x)
    @assert k != CXDeclKind_LinkageSpec && k != CXDeclKind_Export "transparent context"
    return Int(clang_DeclContext_getNumNoloadLookupResults(x, name))
end

"""
    noload_lookup(x::DeclContext, name::DeclarationName) -> Vector{NamedDecl}
The declarations named `name` already present in `x`'s lookup table, without
consulting an external AST source. Only this context is searched — parent
contexts are not. `x` must not be a transparent context.
"""
function noload_lookup(x::DeclContext, name::DeclarationName)
    @check_ptrs x
    n = getNumNoloadLookupResults(x, name)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_DeclContext_noload_lookup(x, name, buf)
    return [NamedDecl(p) for p in buf]
end

"""
    setHasExternalLexicalStorage(x::DeclContext, es::Bool=true)
State whether `x`'s lexical declarations come from an external AST source.
Passing `true` commits the next traversal of `x` to loading from that source, so
the parent `ASTContext` must have one.
"""
function setHasExternalLexicalStorage(x::DeclContext, es::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setHasExternalLexicalStorage(x, es)
end

"""
    setHasExternalVisibleStorage(x::DeclContext, es::Bool=true)
State whether `x`'s visible declarations come from an external AST source.
Passing `true` commits the next lookup in `x` to loading from that source, so the
parent `ASTContext` must have one.
"""
function setHasExternalVisibleStorage(x::DeclContext, es::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setHasExternalVisibleStorage(x, es)
end
