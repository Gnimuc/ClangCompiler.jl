# Higher-level helpers over the Attr hierarchy.

# CXAttrKind value -> concrete Julia carrier type, built from the same table
# the C enum is stamped from, so downcasting an attribute is one ccall
# (getKind) + one lookup instead of a per-class predicate chain.
const ATTR_KIND_TO_TYPE = Dict{CXAttrKind,Any}()
for node in ATTR_NODES
    kind = getproperty(LibClangEx, Symbol("CXAttrKind_", node.name))
    ATTR_KIND_TO_TYPE[kind] = getfield(@__MODULE__, attr_carrier_name(node.name))
end

"""
    resolve(x::AbstractAttr)
Return `x` rewrapped as the concrete attribute type reported by `getKind`.
Falls back to returning `x` unchanged for unknown kinds.
"""
function resolve(x::AbstractAttr)
    T = get(ATTR_KIND_TO_TYPE, getKind(x), nothing)
    return T === nothing ? x : T(x.ptr)
end

get_attr_kind(x::AbstractAttr) = getKind(x)
get_attr_spelling(x::AbstractAttr) = getSpelling(x)
