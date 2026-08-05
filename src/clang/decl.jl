# Higher-level helpers over the Decl hierarchy.

# CXDeclKind value -> concrete Julia carrier type, so resolving a Decl is one
# ccall (getKind) + one lookup instead of a string-compare on getDeclKindName.
# Kinds whose carrier struct is not wrapped (many ObjC/OpenMP decls) are simply
# absent — resolve falls back to the base. The kinds derive from DeclNodes.inc,
# so the map is generated from it into lib/<major>/DeclKindMap.jl (defines
# `DECL_KIND_TO_TYPE`).
include("DeclKindMap.jl")

"""
    resolve(x::AbstractDecl)
Return `x` rewrapped as the concrete Decl type reported by `getKind`. Falls back
to returning `x` unchanged for kinds without a wrapped carrier (e.g. many
ObjC/OpenMP decls). Because `clang::Decl` is the primary base, the pointer is
identical across the narrowing — no offset pivot is needed (contrast the
Decl/DeclContext boundary, which must go through `castToDeclContext`).
"""
function resolve(x::AbstractDecl)
    T = get(DECL_KIND_TO_TYPE, getKind(x), nothing)
    return T === nothing ? x : unchecked_cast(T, x)
end

get_decl_kind(x::AbstractDecl) = getKind(x)
get_decl_kind_name(x::AbstractDecl) = getDeclKindName(x)

"""
    decls(x::DeclContext) -> Vector{AbstractDecl}
Every declaration in `x` and all nested decl-contexts (namespaces, records,
functions, …), pre-order, each resolved to its concrete Decl carrier. The whole
subtree is bulk-extracted in a single pair of ccalls (count + fill) that also
returns each node's `CXDeclKind`, so building the resolved carriers needs no
per-node round-trip — O(1) FFI calls for a whole-translation-unit walk instead
of the O(decls) that the `decl_iterator` protocol costs. Cross from a
`TranslationUnitDecl` (or any Decl that is a context) with `castToDeclContext`.
"""
function decls(x::DeclContext)
    @check_ptrs x
    n = Int(clang_DeclContext_getRecursiveDeclCount(x))
    nodes = Vector{CXDecl}(undef, n)
    kinds = Vector{CXDeclKind}(undef, n)
    clang_DeclContext_collectRecursiveDecls(x, nodes, kinds)
    # the kind travels with each node, so the narrowing is established before it happens;
    # a kind with no wrapped carrier stays at the base `Decl`
    return AbstractDecl[unchecked_cast(get(DECL_KIND_TO_TYPE, kinds[i], Decl), nodes[i]) for i = 1:n]
end
