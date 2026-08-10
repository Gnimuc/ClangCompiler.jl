# FriendDecl
"""
    getFriendType(x::AbstractFriendDecl) -> TypeSourceInfo
Return the type this friend declaration names (`friend class S;`), or a carrier holding
`NULL` when it names a declaration instead — the two are exclusive, so a null here means
[`getFriendDecl`](@ref) is the one that answers.
"""
function getFriendType(x::AbstractFriendDecl)
    @check_ptrs x
    return TypeSourceInfo(clang_FriendDecl_getFriendType(x))
end

"""
    getFriendTypeNumTemplateParameterLists(x::AbstractFriendDecl) -> Int
Return how many template parameter lists precede a friend type declaration.
"""
function getFriendTypeNumTemplateParameterLists(x::AbstractFriendDecl)
    @check_ptrs x
    return Int(clang_FriendDecl_getFriendTypeNumTemplateParameterLists(x))
end

"""
    getFriendTypeTemplateParameterList(x::AbstractFriendDecl, n::Integer) -> TemplateParameterList
Return the `n`-th (0-based) template parameter list preceding a friend type declaration.
"""
function getFriendTypeTemplateParameterList(x::AbstractFriendDecl, n::Integer)
    @check_ptrs x
    @assert 0 ≤ n < getFriendTypeNumTemplateParameterLists(x) "template parameter list index out of range"
    return TemplateParameterList(clang_FriendDecl_getFriendTypeTemplateParameterList(x, n))
end

"""
    getFriendDecl(x::AbstractFriendDecl) -> NamedDecl
Return the declaration this friend declaration names (`friend void f();`), or a carrier
holding `NULL` when it names a type instead — see [`getFriendType`](@ref).
"""
function getFriendDecl(x::AbstractFriendDecl)
    @check_ptrs x
    return NamedDecl(clang_FriendDecl_getFriendDecl(x))
end

"""
    getFriendLoc(x::AbstractFriendDecl) -> SourceLocation
Return the location of the `friend` keyword.
"""
function getFriendLoc(x::AbstractFriendDecl)
    @check_ptrs x
    return SourceLocation(clang_FriendDecl_getFriendLoc(x))
end

function getSourceRange(x::AbstractFriendDecl)
    @check_ptrs x
    r = clang_FriendDecl_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end
