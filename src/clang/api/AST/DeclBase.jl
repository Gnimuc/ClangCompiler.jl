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
    @assert 0 <= i < getNumAttrs(x) "attribute index $i out of range"
    return Attr(clang_Decl_getAttr(x, i))
end

# All attributes on `x`, each a borrowed `Attr`.
function getAttrs(x::AbstractDecl)
    @check_ptrs x
    return Attr[getAttr(x, i) for i = 0:(getNumAttrs(x) - 1)]
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

function setDeclContext(x::AbstractDecl, ctx::AnyDeclContext)
    @check_ptrs x ctx
    return clang_Decl_setDeclContext(x, ctx)
end

function setLexicalDeclContext(x::AbstractDecl, ctx::AnyDeclContext)
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

# `Decl::isTemplateDecl` is spelled `isa<TemplateDecl>(this)` in clang, so it is the same
# question the stamped predicate answers and shares its symbol; `isTemplateDecl` comes from
# api/AST/DeclWrappers.jl with the rest of the family.

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

"""
    dumpToString(x::AbstractDecl; deserialize::Bool=false, format::CXASTDumpOutputFormat=LibClangEx.CXASTDumpOutputFormat_ADOF_Default) -> String
Return the AST dump `dump` writes to stderr, as a string.

`deserialize` pulls in declarations still held by an external AST source rather than
skipping them. `format` selects `ADOF_JSON` for a machine-readable rendering of the same
nodes.
"""
function dumpToString(x::AbstractDecl; deserialize::Bool=false, format::CXASTDumpOutputFormat=LibClangEx.CXASTDumpOutputFormat_ADOF_Default)
    @check_ptrs x
    return get_string(clang_Decl_dumpToString(x, deserialize, format))
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

# `Decl::EnableStatistics` and `Decl::PrintStats` are static: they report on every declaration
# the process has allocated, not on one. So the class is named by a `::Type` tag rather than
# carried by a receiver — `PrintStats(Decl)` is what C++ spells `Decl::PrintStats()`, and the
# tag is what keeps this pair apart from `Stmt`'s two of the same name.
function EnableStatistics(::Type{Decl})
    return clang_Decl_EnableStatistics()
end

function PrintStats(::Type{Decl})
    return clang_Decl_PrintStats()
end

# Decl Cast
"""
    castToDeclContext(x::AbstractDecl) -> DeclContext
Cross from a declaration to the `DeclContext` base it also inherits.

`x` must be a declaration that *is* a context. `Decl::castToDeclContext` switches on the
declaration's kind and ends in `llvm_unreachable` for every other kind, so on a build
without assertions it falls through and hands back a pointer that is neither null nor
meaningful -- a `VarDecl` crossed and crossed back yields a different address. The kind is
checked here with [`classof`](@ref), which is `DeclContext::classof`.
"""
function castToDeclContext(x::AbstractDecl)
    @check_ptrs x
    @assert classof(x) "this declaration is not also a DeclContext"
    return DeclContext(clang_Decl_castToDeclContext(x))
end

function castFromDeclContext(x::DeclContext)
    @check_ptrs x
    return Decl(clang_Decl_castFromDeclContext(x))
end

# The rest of the family -- one checked cast and one predicate per class, abstract bases
# included -- is generated from DeclNodes.inc, so narrowing a declaration is `cast<T>`/`isa<T>`
# and never a reinterpretation.
include("DeclWrappers.jl")

# DeclContext
function getParentASTContext(x::AnyDeclContext)
    @check_ptrs x
    return ASTContext(clang_DeclContext_getParentASTContext(x))
end

function addDecl(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDecl(x, decl)
end

function addDeclInternal(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addDeclInternal(x, decl)
end

function addHiddenDecl(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_addHiddenDecl(x, decl)
end

function removeDecl(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_removeDecl(x, decl)
end

function containsDecl(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDecl(x, decl)
end

function getDeclKindName(x::DeclContext)
    @check_ptrs x
    return unsafe_string(clang_DeclContext_getDeclKindName(x))
end

function getParent(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getParent(x))
end

function getLexicalParent(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getLexicalParent(x))
end

function getLookupParent(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getLookupParent(x))
end

function isClosure(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isClosure(x)
end

function isFunctionOrMethod(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isFunctionOrMethod(x)
end

function isLookupContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isLookupContext(x)
end

function isFileContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isFileContext(x)
end

function isTranslationUnit(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isTranslationUnit(x)
end

function isRecord(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isRecord(x)
end

function isNamespace(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isNamespace(x)
end

function isStdNamespace(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isStdNamespace(x)
end

function isInlineNamespace(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isInlineNamespace(x)
end

function is_dependent_context(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isDependentContext(x)
end

function isTransparentContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isTransparentContext(x)
end

function isExternCContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCContext(x)
end

function isExternCXXContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isExternCXXContext(x)
end

function Equals(x::AnyDeclContext, y::AnyDeclContext)
    @check_ptrs x y
    return clang_DeclContext_Equals(x, y)
end

function getPrimaryContext(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getPrimaryContext(x))
end

function dumpDeclContext(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpDeclContext(x)
end

function dumpLookups(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpLookups(x)
end

function decl_iterator_begin(x::AnyDeclContext)
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
none. Refine it with the `Attr` casts.
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
function printToString(x::AbstractDecl, indentation::Integer=0, print_instantiation::Bool=false)
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
function getDeclKind(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_getDeclKind(x)
end

function getInnermostBlockDecl(x::AnyDeclContext)
    @check_ptrs x
    return BlockDecl(clang_DeclContext_getInnermostBlockDecl(x))
end

function getExternCContext(x::AnyDeclContext)
    @check_ptrs x
    return LinkageSpecDecl(clang_DeclContext_getExternCContext(x))
end

function Encloses(x::AnyDeclContext, y::AnyDeclContext)
    @check_ptrs x y
    return clang_DeclContext_Encloses(x, y)
end

function getNonClosureAncestor(x::AnyDeclContext)
    @check_ptrs x
    return Decl(clang_DeclContext_getNonClosureAncestor(x))
end

function getNonTransparentContext(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getNonTransparentContext(x))
end

function getRedeclContext(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getRedeclContext(x))
end

function getEnclosingNamespaceContext(x::AnyDeclContext)
    @check_ptrs x
    return DeclContext(clang_DeclContext_getEnclosingNamespaceContext(x))
end

function getOuterLexicalRecordContext(x::AnyDeclContext)
    @check_ptrs x
    return RecordDecl(clang_DeclContext_getOuterLexicalRecordContext(x))
end

function InEnclosingNamespaceSetOf(x::AnyDeclContext, ns::AnyDeclContext)
    @check_ptrs x ns
    return clang_DeclContext_InEnclosingNamespaceSetOf(x, ns)
end

function getNumAllContexts(x::AnyDeclContext)
    @check_ptrs x
    return Int(clang_DeclContext_getNumAllContexts(x))
end

"""
    collectAllContexts(x::DeclContext) -> Vector{DeclContext}
Every semantic context connected to `x` — the reopenings of a namespace, in
source order — or just `x` itself for a non-namespace context.
"""
function collectAllContexts(x::AnyDeclContext)
    @check_ptrs x
    n = clang_DeclContext_getNumAllContexts(x)
    buf = Vector{CXDeclContext}(undef, n)
    n > 0 && clang_DeclContext_collectAllContexts(x, buf)
    return [DeclContext(p) for p in buf]
end

function decls_empty(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_decls_empty(x)
end

function containsDeclAndLoad(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_containsDeclAndLoad(x, decl)
end

function getNumLookupResults(x::AnyDeclContext, name::DeclarationName)
    @check_ptrs x
    return Int(clang_DeclContext_getNumLookupResults(x, name))
end

"""
    lookup(x::DeclContext, name::DeclarationName) -> Vector{NamedDecl}
The declarations named `name` in `x`. Only this context is searched — parent
contexts are not. Object, function, member and enumerator names precede any tag
name, matching `clang::DeclContext::lookup`.
"""
function lookup(x::AnyDeclContext, name::DeclarationName)
    @check_ptrs x
    n = clang_DeclContext_getNumLookupResults(x, name)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_DeclContext_lookup(x, name, buf)
    return [NamedDecl(p) for p in buf]
end

function makeDeclVisibleInContext(x::AnyDeclContext, decl::AbstractNamedDecl)
    @check_ptrs x decl
    return clang_DeclContext_makeDeclVisibleInContext(x, decl)
end

function getNumUsingDirectives(x::AnyDeclContext)
    @check_ptrs x
    return Int(clang_DeclContext_getNumUsingDirectives(x))
end

"""
    getUsingDirectives(x::DeclContext) -> Vector{UsingDirectiveDecl}
The `using namespace` directives written directly in `x`.
"""
function getUsingDirectives(x::AnyDeclContext)
    @check_ptrs x
    n = clang_DeclContext_getNumUsingDirectives(x)
    buf = Vector{CXUsingDirectiveDecl}(undef, n)
    n > 0 && clang_DeclContext_getUsingDirectives(x, buf)
    return [UsingDirectiveDecl(p) for p in buf]
end

function hasExternalLexicalStorage(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_hasExternalLexicalStorage(x)
end

function hasExternalVisibleStorage(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_hasExternalVisibleStorage(x)
end

function isDeclInLexicalTraversal(x::AnyDeclContext, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_DeclContext_isDeclInLexicalTraversal(x, decl)
end

function setUseQualifiedLookup(x::AnyDeclContext, use::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setUseQualifiedLookup(x, use)
end

function shouldUseQualifiedLookup(x::AnyDeclContext)
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
function hasValidDeclKind(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_hasValidDeclKind(x)
end

"""
    isObjCContainer(x::DeclContext) -> Bool
Whether `x` is an Objective-C interface, protocol, category or implementation.
"""
function isObjCContainer(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_isObjCContainer(x)
end

"""
    dumpAsDecl(x::DeclContext)
Dump the declaration owning `x` to stderr.
"""
function dumpAsDecl(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_dumpAsDecl(x)
end

"""
    getNumNoloadLookupResults(x::DeclContext, name::DeclarationName) -> Int
The number of declarations named `name` already present in `x`'s lookup table.
No external AST source is consulted, so the count is `0` while the table is
unbuilt. `x` must not be a transparent context.
"""
function getNumNoloadLookupResults(x::AnyDeclContext, name::DeclarationName)
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
function noload_lookup(x::AnyDeclContext, name::DeclarationName)
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
function setHasExternalLexicalStorage(x::AnyDeclContext, es::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setHasExternalLexicalStorage(x, es)
end

"""
    setHasExternalVisibleStorage(x::DeclContext, es::Bool=true)
State whether `x`'s visible declarations come from an external AST source.
Passing `true` commits the next lookup in `x` to loading from that source, so the
parent `ASTContext` must have one.
"""
function setHasExternalVisibleStorage(x::AnyDeclContext, es::Bool=true)
    @check_ptrs x
    return clang_DeclContext_setHasExternalVisibleStorage(x, es)
end

# The static entry points and identifier-namespace mutators of clang::Decl
"""
    isFlexibleArrayMemberLike(ctx::ASTContext, d::AbstractDecl, ty::QualType,
                              level::CXStrictFlexArraysLevelKind,
                              ignore_template_or_macro_substitution::Bool=false) -> Bool
Return whether a member declared by `d` with type `ty` behaves as a flexible array member under the
`-fstrict-flex-arrays` rule `level`.

`d` may be a NULL-pointer carrier, which restricts the answer to the checks that depend only on `ty`
and `level`. `level` selects the rule to apply instead of being read out of `ctx`, so the answer does
not depend on how the interpreter was configured.
"""
function isFlexibleArrayMemberLike(ctx::ASTContext, d::AbstractDecl, ty::QualType, level::CXStrictFlexArraysLevelKind, ignore_template_or_macro_substitution::Bool=false)
    @check_ptrs ctx ty
    return clang_Decl_isFlexibleArrayMemberLike(ctx, d, ty, level, ignore_template_or_macro_substitution)
end

"""
    setLocalExternDecl(x::AbstractDecl)
Move `x` into the identifier namespace of a function-local `extern` declaration.

Clang clears `IDNS_Ordinary` and then asserts that nothing but `IDNS_OrdinaryFriend` and `IDNS_Tag`
is left, so `x` must currently live in no namespace outside those three.
"""
function setLocalExternDecl(x::AbstractDecl)
    @check_ptrs x
    allowed = UInt32(CXDecl_IDNS_Ordinary) | UInt32(CXDecl_IDNS_OrdinaryFriend) | UInt32(CXDecl_IDNS_Tag)
    ns = getIdentifierNamespace(x)
    @assert ns & ~allowed == 0 "the declaration must live only in the ordinary, friend or tag namespace"
    return clang_Decl_setLocalExternDecl(x)
end

"""
    clearIdentifierNamespace(x::AbstractDecl)
Empty `x`'s identifier namespace, hiding it from every ordinary name lookup while leaving it
findable for redeclaration lookup.
"""
function clearIdentifierNamespace(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_clearIdentifierNamespace(x)
end

"""
    setNonMemberOperator(x::AbstractDecl)
Mark `x` as a C++ overloaded non-member operator.

Clang asserts that `x` is a `FunctionDecl` or a `FunctionTemplateDecl` and that it already lives in
the ordinary identifier namespace.
"""
function setNonMemberOperator(x::AbstractDecl)
    @check_ptrs x
    k = getKind(x)
    is_fn = k == CXDeclKind_Function || k == CXDeclKind_FunctionTemplate
    @assert is_fn "only a function or a function template can be a non-member operator"
    ns = getIdentifierNamespace(x)
    @assert ns & UInt32(CXDecl_IDNS_Ordinary) != 0 "the declaration must be visible to ordinary lookup"
    return clang_Decl_setNonMemberOperator(x)
end

"""
    printGroupToString(decls::AbstractVector{<:AbstractDecl}, indentation::Integer=0) -> String
Pretty-print `decls` as one declaration group the way `clang::Decl::printGroup` would.

`decls` must be non-empty and hold no NULL-pointer carrier; the printing policy comes from the
`ASTContext` of its first element.
"""
function printGroupToString(decls::AbstractVector{<:AbstractDecl}, indentation::Integer=0)
    @assert !isempty(decls) "a declaration group holds at least one declaration"
    buf = CXDecl[Base.unsafe_convert(CXDecl, d) for d in decls]
    @assert all(!=(C_NULL), buf) "every declaration in the group must be non-NULL"
    return get_string(clang_Decl_printGroupToString(buf, length(buf), indentation))
end

# The no-load and uncached corners of clang::DeclContext
"""
    noload_decls_begin(x::DeclContext) -> Decl
The first declaration lexically stored in `x`, obtained without asking an external AST source for
anything. A NULL-pointer `Decl` when `x` stores none; walk the rest with `getNextDeclInContext`.
"""
function noload_decls_begin(x::AnyDeclContext)
    @check_ptrs x
    return Decl(clang_DeclContext_noload_decls_begin(x))
end

"""
    localUncachedLookup(x::DeclContext, name::DeclarationName) -> Vector{NamedDecl}
The declarations named `name` in `x` alone, found without relying on a cached lookup table.

Clang reserves this for AST-importer-style callers; `lookup` is the normal entry point.
"""
function localUncachedLookup(x::AnyDeclContext, name::DeclarationName)
    @check_ptrs x
    n = clang_DeclContext_getNumLocalUncachedLookupResults(x, name)
    buf = Vector{CXNamedDecl}(undef, n)
    n > 0 && clang_DeclContext_localUncachedLookup(x, name, buf)
    return [NamedDecl(p) for p in buf]
end

"""
    setMustBuildLookupTable(x::DeclContext)
Mark `x` as having external lexical declarations that its next lookup must fold in.

`x` must be its own primary context (`getPrimaryContext`); clang asserts on any other.
"""
function setMustBuildLookupTable(x::AnyDeclContext)
    @check_ptrs x
    @assert x.ptr == getPrimaryContext(x).ptr "only a primary declaration context can be marked"
    return clang_DeclContext_setMustBuildLookupTable(x)
end

# The attribute-list assignment on clang::Decl, and the lookup-table surface of
# clang::DeclContext.

"""
    setAttrs(x::AbstractDecl, attrs::AbstractVector{<:AbstractAttr})
Install `attrs` as the attribute list of `x`.

`x` must carry no attributes yet (`hasAttrs` is false); clang asserts on a declaration whose
list is already populated. The `Attr`s are borrowed, not copied — they stay owned by whatever
AST allocated them, so the same attribute may end up on two declarations.
"""
function setAttrs(x::AbstractDecl, attrs::AbstractVector{<:AbstractAttr})
    @check_ptrs x
    @assert !hasAttrs(x) "the declaration already carries an attribute list"
    buf = CXAttr[Base.unsafe_convert(CXAttr, a) for a in attrs]
    @assert all(!=(C_NULL), buf) "every attribute in the list must be non-NULL"
    return clang_Decl_setAttrs(x, buf, length(buf))
end

"""
    getNumLookupNames(x::DeclContext) -> Int
The number of distinct names `x` can look up, building its lookup table first.
"""
function getNumLookupNames(x::AnyDeclContext)
    @check_ptrs x
    return Int(clang_DeclContext_getNumLookupNames(x))
end

"""
    getLookupNames(x::DeclContext) -> Vector{DeclarationName}
Every name `x` can look up, one entry per name — the declarations behind a name come from
`lookup`. The lookup table is built on demand and an external AST source is consulted. clang
filters its internal using-directive name only while advancing the iterator, so that name can
still appear as the first entry.
"""
function getLookupNames(x::AnyDeclContext)
    @check_ptrs x
    n = clang_DeclContext_getNumLookupNames(x)
    buf = Vector{CXDeclarationName}(undef, n)
    n > 0 && clang_DeclContext_getLookupNames(x, buf)
    return [DeclarationName(p) for p in buf]
end

"""
    getNumNoloadLookupNames(x::DeclContext, preserve::Bool) -> Int
The number of names already present in `x`'s lookup table, without consulting an external AST
source. `preserve` additionally suppresses loading lazily-stored lexical lookups.
"""
function getNumNoloadLookupNames(x::AnyDeclContext, preserve::Bool)
    @check_ptrs x
    return Int(clang_DeclContext_getNumNoloadLookupNames(x, preserve))
end

"""
    getNoloadLookupNames(x::DeclContext, preserve::Bool) -> Vector{DeclarationName}
The names already present in `x`'s lookup table, without consulting an external AST source —
empty when no lookup has built that table. `preserve` additionally suppresses loading
lazily-stored lexical lookups, leaving `x` untouched.
"""
function getNoloadLookupNames(x::AnyDeclContext, preserve::Bool)
    @check_ptrs x
    n = clang_DeclContext_getNumNoloadLookupNames(x, preserve)
    buf = Vector{CXDeclarationName}(undef, n)
    n > 0 && clang_DeclContext_getNoloadLookupNames(x, preserve, buf)
    return [DeclarationName(p) for p in buf]
end

"""
    lookupSingleResult(x::DeclContext, name::DeclarationName) -> NamedDecl
The one declaration named `name` in `x`, or a NULL-pointer `NamedDecl` when the lookup found
nothing or an overload set. Only this context is searched — parent contexts are not. `x` must
not be a transparent context.
"""
function lookupSingleResult(x::AnyDeclContext, name::DeclarationName)
    @check_ptrs x
    k = getDeclKind(x)
    @assert k != CXDeclKind_LinkageSpec && k != CXDeclKind_Export "transparent context"
    return NamedDecl(clang_DeclContext_lookupSingleResult(x, name))
end

"""
    hasLookupTable(x::DeclContext) -> Bool
Whether a lookup table has been built for `x` yet. Name lookup builds the table on the primary
context, so ask `getPrimaryContext(x)` to learn whether the no-load enumerations see anything.
"""
function hasLookupTable(x::AnyDeclContext)
    @check_ptrs x
    return clang_DeclContext_hasLookupTable(x)
end

"""
    buildLookup(x::DeclContext) -> Bool
Build `x`'s lookup table and report whether one exists afterwards — a context that declares
nothing still has none.

`x` must be its own primary context (`getPrimaryContext`); clang asserts on any other.
"""
function buildLookup(x::AnyDeclContext)
    @check_ptrs x
    @assert x.ptr == getPrimaryContext(x).ptr "only a primary context has a lookup table"
    return clang_DeclContext_buildLookup(x)
end

"""
    setObjectOfFriendDecl(x::AbstractDecl; perform_friend_injection::Bool=false)
Mark `x` as the object of a friend declaration, moving its identifier namespace into the
`*Friend` variants. With `perform_friend_injection` the ordinary namespace bits are kept as
well, which is what leaves the declaration findable by ordinary lookup;
[`getFriendObjectKind`](@ref) reports `FOK_Declared` rather than `FOK_Undeclared`.

`x`'s identifier namespace must include `Ordinary` or `Tag` and nothing outside
`{Tag, Ordinary, Type, TagFriend, OrdinaryFriend, LocalExtern, NonMemberOperator}` — clang
asserts both, and both are read here through [`getIdentifierNamespace`](@ref).

This is irreversible: clang exposes no `setIdentifierNamespace`, so it belongs on declarations
the caller constructed rather than on one the live interpreter's lookup still depends on.
"""
function setObjectOfFriendDecl(x::AbstractDecl; perform_friend_injection::Bool=false)
    @check_ptrs x
    ns = UInt32(getIdentifierNamespace(x))
    required = UInt32(CXDecl_IDNS_Tag) | UInt32(CXDecl_IDNS_Ordinary) | UInt32(CXDecl_IDNS_TagFriend) | UInt32(CXDecl_IDNS_OrdinaryFriend) | UInt32(CXDecl_IDNS_LocalExtern) | UInt32(CXDecl_IDNS_NonMemberOperator)
    permitted = required | UInt32(CXDecl_IDNS_Type)
    @assert (ns & required) != 0 "declaration must be in the ordinary or tag namespace"
    @assert (ns & ~permitted) == 0 "declaration is in a namespace that cannot become a friend"
    return clang_Decl_setObjectOfFriendDecl(x, perform_friend_injection)
end
