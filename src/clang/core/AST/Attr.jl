# The Attr hierarchy. The category base classes from clang/AST/Attr.h are the
# abstract types in AST/AbstractAttr.jl; each concrete attribute also gets its
# own Abstract<Name>Attr (AST/AttrAbstracts.jl, under its category). Those and
# the concrete carriers below (AttrCarriers.jl) are generated from the vendored
# AttrList.inc by gen/attr_nodes.jl — the abstracts front-loaded via abstract.jl,
# the carriers included here. Attribute classes are leaves in clang (no attribute
# derives from another).

"""
    struct Attr <: AbstractAttr
Hold a pointer to a `clang::Attr` object.
"""
struct Attr <: AbstractAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Attr) = x

include("AttrCarriers.jl")
