# Higher-level helpers over the Decl hierarchy.

# CXDeclKind value -> concrete Julia carrier type, built from the vendored
# DeclNodes.inc table (the same table the C CXDeclKind enum is stamped from), so
# downcasting a Decl is one ccall (getKind) + one lookup instead of a
# string-compare on getDeclKindName. Kinds whose carrier struct is not wrapped
# (many ObjC/OpenMP decls) are simply absent — resolve falls back to the base.
const DECL_KIND_TO_TYPE = Dict{CXDeclKind,Any}()
for node in DECL_NODES
    node.isabstract && continue
    carrier = Symbol(node.name, "Decl")
    isdefined(@__MODULE__, carrier) || continue
    kind = getproperty(LibClangEx, Symbol("CXDeclKind_", node.name))
    DECL_KIND_TO_TYPE[kind] = getfield(@__MODULE__, carrier)
end

"""
    resolve(x::AbstractDecl)
Return `x` rewrapped as the concrete Decl type reported by `getKind`. Falls back
to returning `x` unchanged for kinds without a wrapped carrier (e.g. many
ObjC/OpenMP decls). Because `clang::Decl` is the primary base, the pointer is
identical across the downcast — no offset pivot is needed (contrast the
Decl/DeclContext boundary, which must go through `castToDeclContext`).
"""
function resolve(x::AbstractDecl)
    T = get(DECL_KIND_TO_TYPE, getKind(x), nothing)
    return T === nothing ? x : T(x.ptr)
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
    return AbstractDecl[get(DECL_KIND_TO_TYPE, kinds[i], Decl)(nodes[i]) for i in 1:n]
end
