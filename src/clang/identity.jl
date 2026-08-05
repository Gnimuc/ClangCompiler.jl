# Pointer identity for the AST hierarchies clang uniques or owns.
#
# Two carriers of *different* classes routinely designate one node: `decls` resolves a member
# to `CXXMethodDecl` while a lookup hands the same declaration back as `NamedDecl`. Without
# these methods the two compare unequal, and worse, they do so *quietly* -- `==` on the raw
# handles compares addresses whatever their types, but `isequal` and `hash` do not, so a `Set`
# or `Dict` keyed on `.ptr` reports no overlap rather than failing to compare. Every caller
# that wanted identity had to convert both sides to a base handle first and remember why.
#
# Identity is the base pointer, which is what clang itself compares: `Decl *`, `Stmt *`,
# `Type *`, `Attr *`. These are owned by the `ASTContext` (or, for an attribute, by its decl)
# and live as long as it does, so the address is stable for the life of the AST.
#
# Two hierarchies are deliberately absent. `TypeLoc` cannot join: the shim hands out a fresh
# heap box per cast (`new clang::TypeLoc`), so two boxes of one source location are different
# pointers and equality by address would be false for values that are equal. `QualType` needs
# nothing: it is a value type, and the default struct equality already compares its whole
# `PointerIntPair` -- type and fast qualifiers together -- which is exactly its identity.
#
# Node identity is not type *equivalence*. Two `Type *`s that differ only in sugar are
# different nodes and compare unequal here, the same way they do in clang; compare
# `getCanonicalType` when the question is whether two types denote the same thing.
Base.:(==)(a::AbstractDecl, b::AbstractDecl) = decl_id(a) == decl_id(b)
Base.hash(x::AbstractDecl, h::UInt) = hash(decl_id(x), h)

Base.:(==)(a::AbstractStmt, b::AbstractStmt) = stmt_id(a) == stmt_id(b)
Base.hash(x::AbstractStmt, h::UInt) = hash(stmt_id(x), h)

Base.:(==)(a::AbstractType, b::AbstractType) = type_id(a) == type_id(b)
Base.hash(x::AbstractType, h::UInt) = hash(type_id(x), h)

Base.:(==)(a::AbstractAttr, b::AbstractAttr) = attr_id(a) == attr_id(b)
Base.hash(x::AbstractAttr, h::UInt) = hash(attr_id(x), h)

"""
    decl_id(x) -> UInt

The address of `x`'s `clang::Decl` base — the value clang compares to decide whether two
declarations are the same one. [`stmt_id`](@ref), [`type_id`](@ref) and [`attr_id`](@ref)
are the same for their hierarchies.

Prefer `==`, `in` and `Set`, which are defined in terms of these. Reach for the raw number
only to key a container by something other than a carrier.
"""
decl_id(x::AbstractDecl) = UInt(Base.unsafe_convert(CXDecl, x))
stmt_id(x::AbstractStmt) = UInt(Base.unsafe_convert(CXStmt, x))
type_id(x::AbstractType) = UInt(Base.unsafe_convert(CXType_, x))
attr_id(x::AbstractAttr) = UInt(Base.unsafe_convert(CXAttr, x))
