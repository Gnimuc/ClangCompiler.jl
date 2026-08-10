# cross_tu — pulling a definition out of another translation unit's on-disk AST file and
# merging it into the current `ASTContext` through the `ASTImporter`.
#
# It pairs with `ASTUnit_Save` (which produces those AST files) and
# [`generateUSRForDecl`](@ref) (which produces the index keys). Every lookup returns an
# `llvm::Expected` upstream; the shim consumes the error, logs it to stderr and returns a
# null, so `nothing` here means "no definition found, or the import failed", never
# "invalid argument".

"""
    CrossTUIndex() -> CrossTUIndex
Build an empty cross-TU index: the USR-to-AST-file mapping a cross-TU index file records.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CrossTUIndex()
    idx = clang_CrossTUIndex_create()
    @assert idx != C_NULL "Failed to create CrossTUIndex"
    return CrossTUIndex(idx)
end

dispose(x::CrossTUIndex) = clang_CrossTUIndex_dispose(x)

"""
    setindex!(x::AbstractCrossTUIndex, file_path, usr) -> Nothing
Record `file_path` as the AST file defining `usr`, replacing any previous entry.
"""
function Base.setindex!(x::AbstractCrossTUIndex, file_path::AbstractString,
                        usr::AbstractString)
    @check_ptrs x
    return clang_CrossTUIndex_set(x, usr, file_path)
end

"""
    lookup(x::AbstractCrossTUIndex, usr) -> String
Return the AST file path recorded for `usr`, or `""` when the index has no such key.
"""
function lookup(x::AbstractCrossTUIndex, usr::AbstractString)
    @check_ptrs x
    return get_string(clang_CrossTUIndex_lookup(x, usr))
end

"""
    getNumEntries(x::AbstractCrossTUIndex) -> UInt32
Return how many USR-to-path entries the index holds.
"""
function getNumEntries(x::AbstractCrossTUIndex)
    @check_ptrs x
    return clang_CrossTUIndex_getNumEntries(x)
end

"""
    getUSR(x::AbstractCrossTUIndex, i::Integer) -> String
Return the USR of entry `i` (zero-based).

The order is the underlying `StringMap`'s bucket order — unspecified, but stable between
two calls that do not mutate the index, so `getUSR(x, i)` and `getFilePath(x, i)` always
name the same entry.
"""
function getUSR(x::AbstractCrossTUIndex, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumEntries(x) "index entry $i is out of range."
    return get_string(clang_CrossTUIndex_getUSR(x, i))
end

"""
    getFilePath(x::AbstractCrossTUIndex, i::Integer) -> String
Return the AST file path of entry `i` (zero-based); see [`getUSR`](@ref) for the ordering.
"""
function getFilePath(x::AbstractCrossTUIndex, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumEntries(x) "index entry $i is out of range."
    return get_string(clang_CrossTUIndex_getFilePath(x, i))
end

"""
    parseCrossTUIndex(index_path) -> Union{CrossTUIndex,Nothing}
Read a cross-TU index file — one `"USR filepath"` line per entry — and return it, or
`nothing` when the file is missing or malformed (the reason is logged to stderr).

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function parseCrossTUIndex(index_path::AbstractString)
    idx = clang_cross_tu_parseCrossTUIndex(index_path)
    return idx == C_NULL ? nothing : CrossTUIndex(idx)
end

"""
    createCrossTUIndexString(x::AbstractCrossTUIndex) -> String
Render an index back to the `"USR filepath"` line format [`parseCrossTUIndex`](@ref) reads.
"""
function createCrossTUIndexString(x::AbstractCrossTUIndex)
    @check_ptrs x
    return get_string(clang_cross_tu_createCrossTUIndexString(x))
end

"""
    shouldImport(x::AbstractVarDecl, ctx::AbstractASTContext) -> Bool
Return whether importing this variable's definition is worth it. clang refuses variables
whose type has a non-trivial constructor, because running it would have side effects.
"""
function shouldImport(x::AbstractVarDecl, ctx::AbstractASTContext)
    @check_ptrs x ctx
    return clang_cross_tu_shouldImport(x, ctx)
end

"""
    CrossTranslationUnitContext(ci::CompilerInstance) -> CrossTranslationUnitContext
Build the cross-TU machinery over `ci`'s `ASTContext`.

This function allocates and one should call `dispose` to release the resources after using
this object. The context owns every `ASTUnit` it loads and every `ASTImporter` it builds,
so all the borrowed pointers below die with it.
"""
function CrossTranslationUnitContext(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasASTContext(ci) "CompilerInstance has no AST context."
    ctu = clang_CrossTranslationUnitContext_create(ci)
    @assert ctu != C_NULL "Failed to create CrossTranslationUnitContext"
    return CrossTranslationUnitContext(ctu)
end

dispose(x::CrossTranslationUnitContext) = clang_CrossTranslationUnitContext_dispose(x)

"""
    getCrossTUDefinition(ctu::AbstractCrossTranslationUnitContext, fd::AbstractFunctionDecl, cross_tu_dir, index_name; display_progress=false) -> Union{FunctionDecl,Nothing}
Look `fd`'s USR up in the index file `index_name` inside `cross_tu_dir`, load the AST file
it names, and merge the definition into the current AST.

Return the merged declaration — owned by the current `ASTContext` — or `nothing` when the
index has no such definition or the import failed.

`fd` must have **no** body in the current translation unit: the lookup opens with
`assert(!D->hasBody())`, since importing a second definition of a function that already has
one is what it exists to avoid.
"""
function getCrossTUDefinition(ctu::AbstractCrossTranslationUnitContext,
                              fd::AbstractFunctionDecl, cross_tu_dir::AbstractString,
                              index_name::AbstractString; display_progress::Bool=false)
    @check_ptrs ctu fd
    @assert !hasBody(fd) "the function already has a body in this translation unit."
    d = clang_CrossTranslationUnitContext_getCrossTUDefinitionForFunction(ctu, fd,
                                                                          cross_tu_dir,
                                                                          index_name,
                                                                          display_progress)
    return d == C_NULL ? nothing : FunctionDecl(d)
end

"""
    getCrossTUDefinition(ctu::AbstractCrossTranslationUnitContext, vd::AbstractVarDecl, cross_tu_dir, index_name; display_progress=false) -> Union{VarDecl,Nothing}
The variable form of the lookup above. `vd` must have **no** initializer here, for the same
reason and behind the same assertion.
"""
function getCrossTUDefinition(ctu::AbstractCrossTranslationUnitContext,
                              vd::AbstractVarDecl, cross_tu_dir::AbstractString,
                              index_name::AbstractString; display_progress::Bool=false)
    @check_ptrs ctu vd
    @assert !hasInit(vd) "the variable already has an initializer in this translation unit."
    d = clang_CrossTranslationUnitContext_getCrossTUDefinitionForVar(ctu, vd, cross_tu_dir,
                                                                     index_name,
                                                                     display_progress)
    return d == C_NULL ? nothing : VarDecl(d)
end

"""
    loadExternalAST(ctu::AbstractCrossTranslationUnitContext, lookup_name, cross_tu_dir, index_name; display_progress=false) -> Union{ASTUnit,Nothing}
Load — or return from the context's cache — the AST file that defines `lookup_name`.

The unit is **borrowed**: the context owns it, so it must not be disposed. `nothing` on
failure, which includes the context having hit its own AST load threshold.
"""
function loadExternalAST(ctu::AbstractCrossTranslationUnitContext,
                         lookup_name::AbstractString, cross_tu_dir::AbstractString,
                         index_name::AbstractString; display_progress::Bool=false)
    @check_ptrs ctu
    u = clang_CrossTranslationUnitContext_loadExternalAST(ctu, lookup_name, cross_tu_dir,
                                                          index_name, display_progress)
    return u == C_NULL ? nothing : ASTUnit(u)
end

"""
    importDefinition(ctu::AbstractCrossTranslationUnitContext, fd::AbstractFunctionDecl, unit::AbstractASTUnit) -> Union{FunctionDecl,Nothing}
Merge `fd`'s definition out of an `ASTUnit` the caller already has — the second half of
[`getCrossTUDefinition`](@ref), usable on its own when the AST file was located some other
way. `nothing` when the import failed.

`fd` is the *foreign* declaration being imported, so unlike the lookup it must **have** a
body: the importer opens with `assert(hasBodyOrInit(D))`.
"""
function importDefinition(ctu::AbstractCrossTranslationUnitContext,
                          fd::AbstractFunctionDecl, unit::AbstractASTUnit)
    @check_ptrs ctu fd unit
    @assert hasBody(fd) "only a function that has a body can be imported."
    d = clang_CrossTranslationUnitContext_importDefinitionForFunction(ctu, fd, unit)
    return d == C_NULL ? nothing : FunctionDecl(d)
end

"""
    importDefinition(ctu::AbstractCrossTranslationUnitContext, vd::AbstractVarDecl, unit::AbstractASTUnit) -> Union{VarDecl,Nothing}
The variable form of the merge above; `vd` must carry an initializer, behind the same
assertion.
"""
function importDefinition(ctu::AbstractCrossTranslationUnitContext, vd::AbstractVarDecl,
                          unit::AbstractASTUnit)
    @check_ptrs ctu vd unit
    @assert hasInit(vd) "only a variable that has an initializer can be imported."
    d = clang_CrossTranslationUnitContext_importDefinitionForVar(ctu, vd, unit)
    return d == C_NULL ? nothing : VarDecl(d)
end

"""
    getLookupName(x::AbstractNamedDecl) -> String
Return the cross-TU index key for `x`, or `""` when the decl has no stable cross-TU name.
This is the string a cross-TU index file uses as its first column.
"""
function getLookupName(x::AbstractNamedDecl)
    @check_ptrs x
    return get_string(clang_CrossTranslationUnitContext_getLookupName(x))
end

"""
    isImportedAsNew(ctu::AbstractCrossTranslationUnitContext, x::AbstractDecl) -> Bool
Return whether `x` was newly created by one of this context's imports, rather than matched
to a declaration the current AST already had.
"""
function isImportedAsNew(ctu::AbstractCrossTranslationUnitContext, x::AbstractDecl)
    @check_ptrs ctu x
    return clang_CrossTranslationUnitContext_isImportedAsNew(ctu, x)
end

"""
    hasError(ctu::AbstractCrossTranslationUnitContext, x::AbstractDecl) -> Bool
Return whether an import left `x` marked with an unrecoverable error. Such a node cannot be
erased from the AST, so this is how a partially imported declaration is recognised.
"""
function hasError(ctu::AbstractCrossTranslationUnitContext, x::AbstractDecl)
    @check_ptrs ctu x
    return clang_CrossTranslationUnitContext_hasError(ctu, x)
end
