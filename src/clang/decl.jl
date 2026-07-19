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
