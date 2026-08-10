# ASTImporter
#
# Moving AST nodes between two `ASTContext`s. Every `Import` below maps a node of the "from"
# context onto an equivalent node of the "to" context, creating it there when it is absent and
# reusing it when it is already present — which is what lets declarations parsed in a side
# translation unit be used inside another context's AST.
#
# Failure is a NULL carrier (an invalid `SourceLocation`, a NULL `QualType`) and a line on
# stderr, never an exception: clang reports it as an `llvm::Expected` the shim has to consume.
# Which failure it was is recorded per declaration — ask [`getImportDeclErrorIfAny`](@ref).

"""
    ASTImporter(to_ctx::AbstractASTContext, to_fm::AbstractFileManager,
                from_ctx::AbstractASTContext, from_fm::AbstractFileManager,
                minimal_import::Bool=false) -> ASTImporter
Create an importer that copies nodes out of `from_ctx` into `to_ctx`.

`minimal_import` asks the importer to leave to-be-completed forward declarations wherever it
can instead of pulling in whole definitions.

This function allocates and one should call `dispose` to release the resources after using
this object. The importer must not outlive either context or either file manager.
"""
function ASTImporter(to_ctx::AbstractASTContext, to_fm::AbstractFileManager,
                     from_ctx::AbstractASTContext, from_fm::AbstractFileManager,
                     minimal_import::Bool=false)
    @check_ptrs to_ctx to_fm from_ctx from_fm
    return ASTImporter(clang_ASTImporter_create(to_ctx, to_fm, from_ctx, from_fm,
                                                minimal_import))
end

dispose(x::ASTImporter) = clang_ASTImporter_dispose(x)

function isMinimalImport(x::AbstractASTImporter)
    @check_ptrs x
    return clang_ASTImporter_isMinimalImport(x)
end

"""
    setODRHandling(x::AbstractASTImporter, t::CXASTImporter_ODRHandlingType)
Choose whether a structural mismatch between two definitions of the same entity is an error
(`CXASTImporter_Conservative`) or tolerated (`CXASTImporter_Liberal`).
"""
function setODRHandling(x::AbstractASTImporter, t::CXASTImporter_ODRHandlingType)
    @check_ptrs x
    return clang_ASTImporter_setODRHandling(x, t)
end

"""
    Import(x::AbstractASTImporter, node)
The copy of `node` in the importer's "to" context, creating it there if needed.

`node` may be a `Type_`, a `QualType`, a `TypeSourceInfo`, an `Attr`, a `Decl`, an `Expr`, a
`Stmt`, a `NestedNameSpecifier`, a `TemplateName`, a `SourceLocation`, a `SourceRange`, a
`DeclarationName`, an `IdentifierInfo`, a `CXXCtorInitializer`, a `CXXBaseSpecifier` or an
`APValue`. A NULL carrier (an invalid location) comes back when the import failed; the reason
is logged, and for a declaration it is also readable with [`getImportDeclErrorIfAny`](@ref).
"""
function Import(x::AbstractASTImporter, t::AbstractType)
    @check_ptrs x t
    return Type_(clang_ASTImporter_ImportType(x, t))
end

function Import(x::AbstractASTImporter, t::QualType)
    @check_ptrs x t
    return QualType(clang_ASTImporter_ImportQualType(x, t))
end

function Import(x::AbstractASTImporter, tsi::AbstractTypeSourceInfo)
    @check_ptrs x tsi
    return TypeSourceInfo(clang_ASTImporter_ImportTypeSourceInfo(x, tsi))
end

function Import(x::AbstractASTImporter, attr::AbstractAttr)
    @check_ptrs x attr
    return Attr(clang_ASTImporter_ImportAttr(x, attr))
end

function Import(x::AbstractASTImporter, d::AbstractDecl)
    @check_ptrs x d
    return Decl(clang_ASTImporter_ImportDecl(x, d))
end

function Import(x::AbstractASTImporter, e::AbstractExpr)
    @check_ptrs x e
    return Expr_(clang_ASTImporter_ImportExpr(x, e))
end

function Import(x::AbstractASTImporter, s::AbstractStmt)
    @check_ptrs x s
    return Stmt(clang_ASTImporter_ImportStmt(x, s))
end

function Import(x::AbstractASTImporter, nns::AbstractNestedNameSpecifier)
    @check_ptrs x nns
    return NestedNameSpecifier(clang_ASTImporter_ImportNestedNameSpecifier(x, nns))
end

function Import(x::AbstractASTImporter, tn::AbstractTemplateName)
    @check_ptrs x tn
    return TemplateName(clang_ASTImporter_ImportTemplateName(x, tn))
end

function Import(x::AbstractASTImporter, loc::SourceLocation)
    @check_ptrs x
    return SourceLocation(clang_ASTImporter_ImportSourceLocation(x, loc))
end

function Import(x::AbstractASTImporter, rng::SourceRange)
    @check_ptrs x
    r = clang_ASTImporter_ImportSourceRange(x, CXSourceRange_(rng.begin_loc.ptr,
                                                              rng.end_loc.ptr))
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function Import(x::AbstractASTImporter, name::DeclarationName)
    @check_ptrs x name
    return DeclarationName(clang_ASTImporter_ImportDeclarationName(x, name))
end

function Import(x::AbstractASTImporter, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return IdentifierInfo(clang_ASTImporter_ImportIdentifierInfo(x, ii))
end

function Import(x::AbstractASTImporter, init::AbstractCXXCtorInitializer)
    @check_ptrs x init
    return CXXCtorInitializer(clang_ASTImporter_ImportCXXCtorInitializer(x, init))
end

function Import(x::AbstractASTImporter, spec::AbstractCXXBaseSpecifier)
    @check_ptrs x spec
    return CXXBaseSpecifier(clang_ASTImporter_ImportCXXBaseSpecifier(x, spec))
end

"""
    Import(x::AbstractASTImporter, v::AbstractAPValue) -> APValue
The copy of `v` in the "to" context.

`clang::APValue` is a value class, so the result is a fresh box: this function allocates and
one should call `dispose` to release the resources after using this object.
"""
function Import(x::AbstractASTImporter, v::AbstractAPValue)
    @check_ptrs x v
    return APValue(clang_ASTImporter_ImportAPValue(x, v))
end

"""
    ImportContext(x::AbstractASTImporter, dc::DeclContext) -> DeclContext
The declaration context of the "to" AST matching `dc`.
"""
function ImportContext(x::AbstractASTImporter, dc::DeclContext)
    @check_ptrs x dc
    return DeclContext(clang_ASTImporter_ImportContext(x, dc))
end

"""
    GetAlreadyImportedOrNull(x::AbstractASTImporter, d::AbstractDecl) -> Decl
The copy of `d` already made in the "to" context, or a NULL carrier when `d` has not been
imported yet. Unlike [`Import`](@ref) this never imports anything.
"""
function GetAlreadyImportedOrNull(x::AbstractASTImporter, d::AbstractDecl)
    @check_ptrs x d
    return Decl(clang_ASTImporter_GetAlreadyImportedOrNull(x, d))
end

"""
    GetFromTU(x::AbstractASTImporter, d::AbstractDecl) -> TranslationUnitDecl
The translation unit `d` was imported from, or a NULL carrier when it was not imported.
"""
function GetFromTU(x::AbstractASTImporter, d::AbstractDecl)
    @check_ptrs x d
    return TranslationUnitDecl(clang_ASTImporter_GetFromTU(x, d))
end

"""
    ImportDefinition(x::AbstractASTImporter, d::AbstractDeclContextDecl) -> String
Import `d` and then fill the copy in with everything `d`'s definition contains — the
completion [`Import`](@ref) leaves out under a minimal importer. `d` is a declaration of the
SOURCE context, not the copy.

Returns the empty string on success and clang's message otherwise — the C++ result is a bare
`llvm::Error`, which has no node to answer with.

Dispatch carries the precondition: clang opens with `cast<DeclContext>(From)`, so only the
declarations that are also declaration contexts may be passed.
"""
function ImportDefinition(x::AbstractASTImporter, d::AbstractDeclContextDecl)
    @check_ptrs x d
    return get_string(clang_ASTImporter_ImportDefinition(x, d))
end

function getToContext(x::AbstractASTImporter)
    @check_ptrs x
    return ASTContext(clang_ASTImporter_getToContext(x))
end

function getFromContext(x::AbstractASTImporter)
    @check_ptrs x
    return ASTContext(clang_ASTImporter_getFromContext(x))
end

function getToFileManager(x::AbstractASTImporter)
    @check_ptrs x
    return FileManager(clang_ASTImporter_getToFileManager(x))
end

function getFromFileManager(x::AbstractASTImporter)
    @check_ptrs x
    return FileManager(clang_ASTImporter_getFromFileManager(x))
end

"""
    CompleteDecl(x::AbstractASTImporter, d::AbstractDecl)
Fill `d` in as much as possible; `d` lives in the destination context.

PARTIAL: `d` must be an Objective-C interface, an Objective-C protocol or a tag declaration —
clang's dispatch chain ends in an unconditional `assert(0)` for anything else.
"""
function CompleteDecl(x::AbstractASTImporter, d::AbstractDecl)
    @check_ptrs x d
    @assert isObjCInterfaceDecl(d) || isObjCProtocolDecl(d) || isTagDecl(d) "only an ObjC interface, an ObjC protocol or a tag declaration can be completed"
    return clang_ASTImporter_CompleteDecl(x, d)
end

"""
    RegisterImportedDecl(x::AbstractASTImporter, from::AbstractDecl, to::AbstractDecl)
Record `from` -> `to` in the importer's map and add `to` to its lookup table, without
importing anything.

PARTIAL: carries [`MapImported`](@ref)'s precondition.
"""
function RegisterImportedDecl(x::AbstractASTImporter, from::AbstractDecl, to::AbstractDecl)
    @check_ptrs x from to
    @assert _mappable(x, from, to) "`from` is already mapped to a different declaration"
    return clang_ASTImporter_RegisterImportedDecl(x, from, to)
end

"""
    MapImported(x::AbstractASTImporter, from::AbstractDecl, to::AbstractDecl) -> Decl
Record `from` -> `to` and return `to`. Several "from" declarations may map onto one "to".

PARTIAL: `from` must not already be mapped to a *different* declaration — clang asserts
"Try to import an already imported Decl", and [`GetAlreadyImportedOrNull`](@ref) reads
exactly what that assert reads.
"""
function MapImported(x::AbstractASTImporter, from::AbstractDecl, to::AbstractDecl)
    @check_ptrs x from to
    @assert _mappable(x, from, to) "`from` is already mapped to a different declaration"
    return Decl(clang_ASTImporter_MapImported(x, from, to))
end

# The gate MapImported and RegisterImportedDecl share, spelled once: an unmapped `from`, or
# one already mapped to this very `to`.
function _mappable(x::AbstractASTImporter, from::AbstractDecl, to::AbstractDecl)
    prev = GetAlreadyImportedOrNull(x, from)
    return is_null_handle(prev) || prev == to
end

"""
    getImportDeclErrorIfAny(x::AbstractASTImporter, d::AbstractDecl) -> CXASTImportError_ErrorKind or nothing
The first error the import of `d` hit, or `nothing` when its import has not failed.

`CXASTImportError_Unknown` is a real error kind, so the "no error" answer cannot be one of the
enumerators — clang reports it as an empty `std::optional` and this mirrors that.
"""
function getImportDeclErrorIfAny(x::AbstractASTImporter, d::AbstractDecl)
    @check_ptrs x d
    has_error = Ref{Bool}(false)
    kind = clang_ASTImporter_getImportDeclErrorIfAny(x, d, has_error)
    return has_error[] ? kind : nothing
end

"""
    setImportDeclError(x::AbstractASTImporter, from::AbstractDecl, err::CXASTImportError_ErrorKind)
Mark `from` as having failed to import with `err`.

PARTIAL: `from` must carry no error yet, or the same one — clang asserts that the insertion
either happened or found an equal kind.
"""
function setImportDeclError(x::AbstractASTImporter, from::AbstractDecl,
                            err::CXASTImportError_ErrorKind)
    @check_ptrs x from
    prev = getImportDeclErrorIfAny(x, from)
    @assert prev === nothing || prev == err "`from` already carries a different import error"
    return clang_ASTImporter_setImportDeclError(x, from, err)
end

"""
    IsStructurallyEquivalent(x::AbstractASTImporter, from::QualType, to::QualType, complain::Bool=true) -> Bool
Whether the two types are structurally equivalent, using the importer's own non-equivalence
cache. `complain` routes a mismatch through the "to" context's diagnostics.
"""
function IsStructurallyEquivalent(x::AbstractASTImporter, from::QualType, to::QualType,
                                  complain::Bool=true)
    @check_ptrs x from to
    return clang_ASTImporter_IsStructurallyEquivalent(x, from, to, complain)
end
