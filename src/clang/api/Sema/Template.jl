# MultiLevelTemplateArgumentList
"""
    MultiLevelTemplateArgumentList() -> MultiLevelTemplateArgumentList
Return a freshly created, empty multi-level template argument list. This function allocates
and one should call `dispose` to release the resources after using this object.

`clang::MultiLevelTemplateArgumentList` stores every level as a borrowed
`ArrayRef<TemplateArgument>` and never copies the elements, so the handle is a box that
owns a copy of every level handed to `addOuterTemplateArguments` or
`replaceInnermostTemplateArguments`. Arguments read back out of it are borrowed from that
storage: they must never be `dispose`d, and they dangle once the list is disposed.
"""
MultiLevelTemplateArgumentList() = MultiLevelTemplateArgumentList(clang_MultiLevelTemplateArgumentList_create())

dispose(x::MultiLevelTemplateArgumentList) = clang_MultiLevelTemplateArgumentList_dispose(x)

function setKind(x::AbstractMultiLevelTemplateArgumentList, kind::CXTemplateSubstitutionKind)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_setKind(x, kind)
end

function getKind(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_getKind(x)
end

function isRewrite(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_isRewrite(x)
end

function getNumLevels(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_getNumLevels(x)
end

function getNumSubstitutedLevels(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_getNumSubstitutedLevels(x)
end

"""
    getNumSubsitutedArgs(x::AbstractMultiLevelTemplateArgumentList, depth::Integer)
Return the number of arguments substituted at `depth`. The name carries Clang's own typo,
kept verbatim like every other wrapper name. The C++ accessor indexes the level vector
unchecked, so `depth` must name a substituted level - a retained outer level has no
argument list of its own.
"""
function getNumSubsitutedArgs(x::AbstractMultiLevelTemplateArgumentList, depth::Integer)
    @check_ptrs x
    @assert getNumRetainedOuterLevels(x) <= depth < getNumLevels(x) "depth must name a substituted level"
    return clang_MultiLevelTemplateArgumentList_getNumSubsitutedArgs(x, depth)
end

function getNumRetainedOuterLevels(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_getNumRetainedOuterLevels(x)
end

function getNewDepth(x::AbstractMultiLevelTemplateArgumentList, old_depth::Integer)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_getNewDepth(x, old_depth)
end

"""
    getArgument(x::AbstractMultiLevelTemplateArgumentList, depth::Integer, index::Integer)
Return a borrowed carrier for the argument at `depth`/`index` (Clang spells this
`operator()`). It points into the list's own argument storage, so it must never be
`dispose`d and it dangles once the list is disposed. The C++ accessor indexes both the
level vector and the argument array unchecked.
"""
function getArgument(x::AbstractMultiLevelTemplateArgumentList, depth::Integer, index::Integer)
    @check_ptrs x
    @assert getNumRetainedOuterLevels(x) <= depth < getNumLevels(x) "depth must name a substituted level"
    @assert index < getNumSubsitutedArgs(x, depth) "index must be within the level's argument list"
    return TemplateArgument(clang_MultiLevelTemplateArgumentList_getArgument(x, depth, index))
end

"""
    getAssociatedDecl(x::AbstractMultiLevelTemplateArgumentList, depth::Integer) -> Decl
Return the template-like entity owning the pattern substituted at `depth`, the first half
of the `std::pair<Decl *, bool>` Clang returns; `isAssociatedDeclFinal` is the second. The
decl is stored canonicalised. The C++ accessor indexes the level vector unchecked.
"""
function getAssociatedDecl(x::AbstractMultiLevelTemplateArgumentList, depth::Integer)
    @check_ptrs x
    @assert getNumRetainedOuterLevels(x) <= depth < getNumLevels(x) "depth must name a substituted level"
    return Decl(clang_MultiLevelTemplateArgumentList_getAssociatedDecl(x, depth))
end

"""
    isAssociatedDeclFinal(x::AbstractMultiLevelTemplateArgumentList, depth::Integer) -> Bool
Return the `Final` flag stored beside the associated decl of `depth` - the second half of
the pair `getAssociatedDecl` splits. The C++ accessor indexes the level vector unchecked.
"""
function isAssociatedDeclFinal(x::AbstractMultiLevelTemplateArgumentList, depth::Integer)
    @check_ptrs x
    @assert getNumRetainedOuterLevels(x) <= depth < getNumLevels(x) "depth must name a substituted level"
    return clang_MultiLevelTemplateArgumentList_isAssociatedDeclFinal(x, depth)
end

"""
    hasTemplateArgument(x::AbstractMultiLevelTemplateArgumentList, depth, index) -> Bool
Return whether a non-null argument exists at `depth`/`index`. An out-of-range `index` and a
retained outer level both answer `false`, but `depth` must still name a level of this list:
the C++ method asserts on that and indexes the level vector unchecked.
"""
function hasTemplateArgument(x::AbstractMultiLevelTemplateArgumentList, depth::Integer, index::Integer)
    @check_ptrs x
    @assert depth < getNumLevels(x) "depth must name a level of this list"
    return clang_MultiLevelTemplateArgumentList_hasTemplateArgument(x, depth, index)
end

function isAnyArgInstantiationDependent(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_isAnyArgInstantiationDependent(x)
end

"""
    setArgument(x::AbstractMultiLevelTemplateArgumentList, depth, index, arg::TemplateArgument)
Overwrite one argument of the level at `depth`. The write lands in the list's own copy of
the level and `arg` is copied, so the caller keeps ownership of its box. The C++ method
indexes both the level vector and the argument array unchecked.
"""
function setArgument(x::AbstractMultiLevelTemplateArgumentList, depth::Integer, index::Integer,
                     arg::TemplateArgument)
    @check_ptrs x arg
    @assert getNumRetainedOuterLevels(x) <= depth < getNumLevels(x) "depth must name a substituted level"
    @assert index < getNumSubsitutedArgs(x, depth) "index must be within the level's argument list"
    return clang_MultiLevelTemplateArgumentList_setArgument(x, depth, index, arg)
end

"""
    addOuterTemplateArguments(x::AbstractMultiLevelTemplateArgumentList, decl::AbstractDecl,
                              args::Vector{TemplateArgument}, final::Bool)
Add `args` as a new outermost level owned by `decl`. The elements are copied into the
list's own storage, so the caller keeps its own argument boxes. The C++ method asserts that
no retained outer level has been added yet and that the list is substituting rather than
rewriting.
"""
function addOuterTemplateArguments(x::AbstractMultiLevelTemplateArgumentList, decl::AbstractDecl,
                                   args::Vector{CXTemplateArgument}, final::Bool)
    @check_ptrs x decl
    @assert getNumRetainedOuterLevels(x) == 0 "substituted args cannot sit outside retained ones"
    @assert getKind(x) == CXTemplateSubstitutionKind_Specialization "list must be substituting"
    return clang_MultiLevelTemplateArgumentList_addOuterTemplateArguments(x, decl, args, length(args),
                                                                          final)
end

function addOuterTemplateArguments(x::AbstractMultiLevelTemplateArgumentList, decl::AbstractDecl,
                                   args::Vector{TemplateArgument}, final::Bool)
    return addOuterTemplateArguments(x, decl, CXTemplateArgument[arg.ptr for arg in args], final)
end

"""
    replaceInnermostTemplateArguments(x::AbstractMultiLevelTemplateArgumentList,
                                      decl::AbstractDecl, args::Vector{TemplateArgument})
Replace the innermost level's arguments with a copy of `args`. The superseded level stays
alive inside the list until it is disposed, so a carrier obtained from it earlier does not
dangle - it simply stops being the list's current argument. The C++ method asserts that
there is something to replace.
"""
function replaceInnermostTemplateArguments(x::AbstractMultiLevelTemplateArgumentList, decl::AbstractDecl,
                                           args::Vector{CXTemplateArgument})
    @check_ptrs x decl
    @assert getNumSubstitutedLevels(x) > 0 || getNumRetainedOuterLevels(x) > 0 "list must not be empty"
    return clang_MultiLevelTemplateArgumentList_replaceInnermostTemplateArguments(x, decl, args,
                                                                                  length(args))
end

function replaceInnermostTemplateArguments(x::AbstractMultiLevelTemplateArgumentList, decl::AbstractDecl,
                                           args::Vector{TemplateArgument})
    return replaceInnermostTemplateArguments(x, decl, CXTemplateArgument[arg.ptr for arg in args])
end

function addOuterRetainedLevel(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_addOuterRetainedLevel(x)
end

function addOuterRetainedLevels(x::AbstractMultiLevelTemplateArgumentList, num::Integer)
    @check_ptrs x
    return clang_MultiLevelTemplateArgumentList_addOuterRetainedLevels(x, num)
end

"""
    getNumInnermostArgs(x::AbstractMultiLevelTemplateArgumentList)
Return the size of the innermost argument level - the count half of `getInnermost`. The C++
accessor reads `front()` of the level vector, so the list must have a substituted level.
"""
function getNumInnermostArgs(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    @assert getNumSubstitutedLevels(x) > 0 "the list must have a substituted level"
    return clang_MultiLevelTemplateArgumentList_getNumInnermostArgs(x)
end

"""
    getInnermostArg(x::AbstractMultiLevelTemplateArgumentList, i::Integer) -> TemplateArgument
Return a borrowed carrier for element `i` of the innermost argument level. Like
`getArgument`, it points into the list's own storage and must never be `dispose`d.
"""
function getInnermostArg(x::AbstractMultiLevelTemplateArgumentList, i::Integer)
    @check_ptrs x
    @assert i < getNumInnermostArgs(x) "index must be within the innermost level"
    return TemplateArgument(clang_MultiLevelTemplateArgumentList_getInnermostArg(x, i))
end

"""
    getNumOutermostArgs(x::AbstractMultiLevelTemplateArgumentList)
Return the size of the outermost argument level - the count half of `getOutermost`. The C++
accessor reads `back()` of the level vector, so the list must have a substituted level.
"""
function getNumOutermostArgs(x::AbstractMultiLevelTemplateArgumentList)
    @check_ptrs x
    @assert getNumSubstitutedLevels(x) > 0 "the list must have a substituted level"
    return clang_MultiLevelTemplateArgumentList_getNumOutermostArgs(x)
end

"""
    getOutermostArg(x::AbstractMultiLevelTemplateArgumentList, i::Integer) -> TemplateArgument
Return a borrowed carrier for element `i` of the outermost argument level. Like
`getArgument`, it points into the list's own storage and must never be `dispose`d.
"""
function getOutermostArg(x::AbstractMultiLevelTemplateArgumentList, i::Integer)
    @check_ptrs x
    @assert i < getNumOutermostArgs(x) "index must be within the outermost level"
    return TemplateArgument(clang_MultiLevelTemplateArgumentList_getOutermostArg(x, i))
end


# LocalInstantiationScope
"""
    LocalInstantiationScope(x::AbstractSema, combine_with_outer_scope::Bool=false) -> LocalInstantiationScope
Open a local instantiation scope on `x` and return the RAII sentinel that owns it. This
function allocates and one should call `dispose` to release the resources after using this
object; disposing it is what restores the scope that was current before, so nested scopes
must be disposed in reverse construction order.

`clang::LocalInstantiationScope` records the pattern-to-instance mapping for parameters and
local declarations. Every `Sema` entry point that rebuilds a *declaration* rather than a
type - [`SubstDecl`](@ref), [`SubstParmVarDecl`](@ref), [`SubstTemplateParams`](@ref) and
the function-prototype path of [`SubstFunctionDeclType`](@ref) - writes through
`Sema::CurrentInstantiationScope` with no null check, so outside the parser this is what
makes those calls defined. [`hasCurrentInstantiationScope`](@ref) is the matching gate.

`combine_with_outer_scope` makes lookups fall through to the enclosing scope instead of
stopping at this one.
"""
function LocalInstantiationScope(x::AbstractSema, combine_with_outer_scope::Bool=false)
    @check_ptrs x
    return LocalInstantiationScope(clang_LocalInstantiationScope_create(x,
                                                                        combine_with_outer_scope))
end

dispose(x::LocalInstantiationScope) = clang_LocalInstantiationScope_dispose(x)


"""
    getSema(x::AbstractLocalInstantiationScope) -> Sema
Return the `Sema` this instantiation scope was created against.
"""
function getSema(x::AbstractLocalInstantiationScope)
    @check_ptrs x
    return Sema(clang_LocalInstantiationScope_getSema(x))
end

"""
    Exit(x::AbstractLocalInstantiationScope)
End the scope early: the scope that was current before it becomes current again, which is
exactly what `dispose` does through the destructor. clang guards on its own already-exited
flag, so calling this twice — and disposing an already-exited scope — are both defined.

Nothing may be substituted through this scope afterwards;
[`hasCurrentInstantiationScope`](@ref) reports whether anything took its place.
"""
function Exit(x::AbstractLocalInstantiationScope)
    @check_ptrs x
    clang_LocalInstantiationScope_Exit(x)
    return nothing
end

"""
    isLocalPackExpansion(x::AbstractLocalInstantiationScope, d::AbstractDecl) -> Bool
Return whether `d` is one of the declarations this scope expanded into an argument pack. A
scope created with `combine_with_outer_scope` answers for the enclosing scopes as well.
"""
function isLocalPackExpansion(x::AbstractLocalInstantiationScope, d::AbstractDecl)
    @check_ptrs x d
    return clang_LocalInstantiationScope_isLocalPackExpansion(x, d)
end
