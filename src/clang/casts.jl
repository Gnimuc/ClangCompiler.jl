# Crossing the hierarchy, and why almost none of it is written at the call site.
#
# ## Widening has no spelling
#
# `core/converts.jl` keys every marshalling method on an *abstract* type, so a carrier reaches
# any ccall declared on one of its bases with nothing written at the call site — exactly the
# implicit derived-to-base conversion C++ performs. `getLocation(rd)` on a `CXXRecordDecl`
# calls `clang_Decl_getLocation` because `getLocation` is typed at `AbstractDecl` and the
# `CXDecl` entry serves every declaration below it. There is no upcast to write, and so none
# to forget or to get wrong.
#
# ## Narrowing is a constructor, and it is checked
#
# `FunctionDecl(d)` is C++'s `cast<FunctionDecl>(d)`: the shim runs clang's own `classof`
# through `dyn_cast_or_null`, and a declaration of another class raises [`CastError`] here
# rather than becoming a carrier that lies about its pointee. `isFunctionDecl(d)` beside it is
# `isa<FunctionDecl>(d)` and asks the same question without raising.
#
# These are exact-class casts, like `dyn_cast` and unlike `Type::getAs`: a `TypedefType` that
# sugars a struct is not a `RecordType`, and `RecordType(t)` on one raises. Reach for
# `getCanonicalType` or one of the `getAs*` accessors when the question is what a type
# *denotes* rather than which node it is.
#
# ## Usually neither is what you want
#
# `resolve` reads the class clang recorded and hands back the carrier for it, so a node that
# arrived typed at a base becomes its true class in one ccall. From there Julia's own subtype
# relation *is* the cast, with no ccall and no API:
#
#     d = resolve(some_decl)
#     d isa AbstractFunctionDecl        # isa<FunctionDecl>(d)
#     fd = d::AbstractFunctionDecl      # cast<FunctionDecl>(d) — raises on a mismatch
#     handle(d::AbstractFunctionDecl)   # better still: let dispatch do it
#
# Note the `Abstract` prefix on all three. Carriers are leaves — `CXXMethodDecl` is not a
# subtype of `FunctionDecl` — so `d::FunctionDecl` rejects every method, and
# `FunctionDecl(a_method)` yields a carrier one level wider than the node. Clang's hierarchy
# lives in the abstract types, and `AbstractFunctionDecl` admits exactly what
# `dyn_cast<FunctionDecl>` accepts.

"""
    CastError(want, got)

Thrown by a checked downcast — `FunctionDecl(d)`, `IfStmt(s)`, `RecordType(t)`, … — when the
node is of some other class. `want` is the carrier asked for and `got` is clang's own name for
the class the node actually is.

Test first with the `is…` predicate beside the cast, or call [`resolve`](@ref) to get the node
back as whatever class it is.
"""
struct CastError <: Exception
    want::Type
    got::String
end

# `Expr_`/`Type_` carry names Base already uses; the C++ class is the undecorated spelling.
_cxx_name(::Type{T}) where {T} = rstrip(String(nameof(T)), '_')

# `Base.print` in full: this module defines its own `print` (clang's `TemplateArgument::print`),
# which shadows Base's for everything inside the module.
function Base.showerror(io::IO, e::CastError)
    Base.print(io, "CastError: this node is a clang::", e.got, ", not a clang::", _cxx_name(e.want), ". Test with the matching `is…` predicate, or call `resolve` for the class it is.")
    return nothing
end

# Clang's name for the class of `x`, for the error message only — each hierarchy stores its
# class in its own way, and every one of these is exact where `resolve` may fall back to a base
# for a class this package has no carrier for.
_class_name(x::AbstractDecl) = getDeclKindName(x) * "Decl"
_class_name(x::AbstractStmt) = getStmtClassName(x)
_class_name(x::AbstractType) = getTypeClassName(x) * "Type"
_class_name(x::AbstractAttr) = _enum_class(getKind(x), "CXAttrKind_") * "Attr"
_class_name(x::AnyTypeLoc) = _enum_class(getTypeLocClass(x), "CXTypeLocClass_") * "TypeLoc"

_enum_class(kind, prefix) = replace(string(kind), prefix => "")

@noinline _cast_failed(::Type{T}, x) where {T} = throw(CastError(T, _class_name(x)))

# The root of each hierarchy completes the cast family, and is the one member that cannot fail:
# there is no `classof` to run because every node in the hierarchy passes it, which is why the
# shim stamps no `castToDecl`/`castToStmt` to call. Widening to the base is what C++ does with
# no cast written at all, and it is sound here for the reason every entry in `converts.jl` is —
# these hierarchies are singly inherited, so the base subobject shares its address.
#
# Worth having even so: a caller who deliberately wants a base-typed carrier — to reach a
# `Decl`-level accessor over a node whose class is beside the point, or to exercise the
# base-level method — writes the same constructor spelling as every other crossing.
Decl(x::AbstractDecl) = (@check_ptrs x; Decl(Base.unsafe_convert(CXDecl, x)))
Stmt(x::AbstractStmt) = (@check_ptrs x; Stmt(Base.unsafe_convert(CXStmt, x)))
Type_(x::AbstractType) = (@check_ptrs x; Type_(Base.unsafe_convert(CXType_, x)))
Attr(x::AbstractAttr) = (@check_ptrs x; Attr(Base.unsafe_convert(CXAttr, x)))

"""
    unchecked_cast(::Type{T}, x) -> T

Wrap `x` — a carrier or a bare handle — as `T` without asking clang anything. The one crossing
in the package that is not checked, and the only construction where a carrier's type and its
handle's type are allowed to differ.

Its callers establish the class first, from the very field `classof` would read: `resolve`
picks `T` out of a table keyed on the class clang reported, and the bulk walks behind `decls`
and `children` carry each node's kind back beside the node. Re-checking here would be a second
ccall per node in a whole-translation-unit traversal, to re-derive an answer the caller was
just handed.

It serves both directions — the class is already known, so widening a handle to a base carrier
(`Type_` over a `CXFunctionType`) and narrowing one to a leaf are the same reinterpretation.

What it will not do is leave a hierarchy. Reinterpreting one class as another is sound because
these hierarchies are singly inherited, so a base subobject shares its object's address; between
two of them nothing of the sort holds. A carrier argument must therefore be of `T`'s own
hierarchy, and a pair that is not raises `MethodError` before anything is reinterpreted:

```julia
unchecked_cast(DeclContext, a_namespace_decl)   # MethodError — 48 bytes out, and `isNamespace`
                                                # would have quietly answered about another class
unchecked_cast(Type_, a_qualtype)               # MethodError — a QualType handle is a
                                                # PointerIntPair, its low bits are qualifiers
unchecked_cast(IfStmt, a_source_location)       # MethodError — that handle is a file offset
```

Everything else narrows through the checked constructors above, which is what keeps this the
single site to audit. It is deliberately not `public`: reaching it from outside means writing
`ClangCompiler.unchecked_cast`, and a wrong class *within* one hierarchy is still undefined
behaviour inside clang rather than a `CastError`.
"""
unchecked_cast(::Type{T}, handle::Ptr) where {T} = T(fieldtype(T, :ptr)(handle))

# `fieldtype` names the handle `T` itself declares, which is not always the handle of `T`'s own
# class: every carrier in the `BuiltinType` family holds a `CXType_`. Naming it is also what
# gets past `handles.jl` — `Ptr{X}(::Ptr)` is Julia's own bitcast constructor, where a bare
# `T(handle)` would go through `convert` and raise on the class change.
#
# One method per hierarchy, rather than one taking any carrier. The `where` clauses say the
# soundness condition outright — source and target in the same singly-inherited hierarchy — so
# dispatch is what enforces it, the way Invariant 2 has receivers enforce the rest of the layer.
# A single `unchecked_cast(::Type{T}, carrier)` would instead admit all 1013 carriers, 196 of
# which are outside these four hierarchies entirely, plus the value types (`QualType`,
# `SourceLocation`) that also happen to hold a field named `ptr`.
#
# The `::Ptr` method above stays open by necessity and is the half of this that is still on
# trust: `decls` fills a `Vector{CXDecl}` in one ccall and casts each element, and three wrapper
# bodies pass a handle more derived than the carrier they build. Narrowing that would need the
# generated phantoms to carry their hierarchy at the type level.
unchecked_cast(::Type{T}, x::AbstractDecl) where {T<:AbstractDecl} = unchecked_cast(T, x.ptr)
unchecked_cast(::Type{T}, x::AbstractStmt) where {T<:AbstractStmt} = unchecked_cast(T, x.ptr)
unchecked_cast(::Type{T}, x::AbstractType) where {T<:AbstractType} = unchecked_cast(T, x.ptr)
unchecked_cast(::Type{T}, x::AbstractAttr) where {T<:AbstractAttr} = unchecked_cast(T, x.ptr)
