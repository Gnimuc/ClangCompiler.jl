# Higher-level helpers over the Attr hierarchy.

# CXAttrKind value -> concrete Julia carrier type, so downcasting an attribute
# is one ccall (getKind) + one lookup instead of a per-class predicate chain.
# The kinds and carriers both derive from AttrList.inc, so the map is generated
# from it into lib/<major>/AttrKindMap.jl (defines `ATTR_KIND_TO_TYPE`).
include("AttrKindMap.jl")

"""
    resolve(x::AbstractAttr)
Return `x` rewrapped as the concrete attribute type reported by `getKind`.
Falls back to returning `x` unchanged for unknown kinds.
"""
function resolve(x::AbstractAttr)
    T = get(ATTR_KIND_TO_TYPE, getKind(x), nothing)
    return T === nothing ? x : downcast(T, x)
end

get_attr_kind(x::AbstractAttr) = getKind(x)
get_attr_spelling(x::AbstractAttr) = getSpelling(x)
