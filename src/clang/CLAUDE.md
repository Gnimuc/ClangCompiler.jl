# CLAUDE.md — src/clang (the Julia thin wrapper)

Guidance for the hand-written Julia layer that wraps the `libclangex` C shim. The repo-root
CLAUDE.md covers the whole package and the end-to-end recipe for adding one wrapper;
`deps/ClangExtra/CLAUDE.md` covers the C side. This file covers the one job this layer
exists to do: **reproduce Clang's C++ type system in Julia and be the sole safety boundary
in front of a deliberately unsafe C API.** Format with JuliaFormatter (YAS, margin 120).

## The governing axiom

The `libclangex` C API has exactly one client — this layer — and it is intentionally
type-erased (every handle is `void *`) and check-free (`static_cast`, no null checks, no
error codes). All of that erased safety is re-established here. Two invariants make every
`static_cast` inside the C shim valid; preserving them is the whole responsibility of this
layer:

1. **Faithful carriers.** A carrier struct's Julia type always reflects its pointee's true
   dynamic C++ class. A carrier that lies makes the next `static_cast` in C undefined
   behaviour even though Julia dispatch "succeeded."
2. **Correctly-leveled receivers.** Each wrapper types its receiver at the abstract
   supertype of the C++ class that *declares* the method — never looser. This is what makes
   multiple dispatch mechanically reject a mistyped receiver before the ccall.

Everything below is how these two invariants are maintained.

## Layer split

- **`core/`** — the type mirror. Abstract types reproduce Clang's inheritance; carrier
  structs hold the `void *` handle. No behaviour, just the type system. Registered in
  `core/core.jl`.
- **`api/`** — one thin wrapper per C function: check preconditions, emit the ccall, wrap
  the return in a carrier. Registered in `api/api.jl`. File tree mirrors the Clang headers.
- **`src/clang/*.jl`** (`ast.jl`, `stmt.jl`, `type.jl`, `qualtype.jl`, `sema.jl`,
  `basic.jl`, …) — snake_case convenience helpers and the downcast machinery (`resolve`,
  `children`, `is_*` predicates) built on top of `api/`.

## Reproducing single inheritance

Clang's hierarchy is mirrored as an abstract-type tree in `core/abstract.jl` (and, for the
Stmt hierarchy, the OpenMP/ObjC tail is generated from `StmtNodes.inc` into
`lib/<major>/StmtAbstractGen.jl`, included via `core/AST/StmtAbstract.jl`):
`AbstractExpr <: AbstractValueStmt <: AbstractStmt`, and so on, class-for-class. Each
concrete class is a carrier:

```julia
struct IfStmt <: AbstractIfStmt
    ptr::CXStmt
end
Base.unsafe_convert(::Type{CXStmt}, x::IfStmt) = x.ptr
Base.cconvert(::Type{CXStmt}, x::IfStmt) = x
```

The field must be named `ptr` (`@check_ptrs` depends on it). Carrier-name collisions with
Base drop into underscore spellings (`Expr` → `Expr_`, `Type` → `Type_`, `CXToken_` →
`Token`); classes Clang itself names `Abstract*` get no carrier — their name is taken by the
abstract type. Carriers are written out as plain `struct` definitions (no runtime `@eval`):
the hand-curated families are hand-written here, and the large `.inc`-driven families (Attr,
Stmt) are emitted as explicit source into `lib/<major>/` by `gen/*_nodes.jl` — regenerate,
don't hand-edit those. Add a new hand-written carrier as its own `struct` + the two converts.

**Upcast is free and needs no cast.** A wrapper typed `f(x::AbstractStmt)` accepts every
statement carrier; the ccall marshals it through that carrier's single `unsafe_convert`.
Because every `CX*` handle is the same Julia type (`Ptr{Cvoid}`), one `unsafe_convert` per
carrier serves *every* API the carrier can legally reach — base-class methods and
own-class methods alike — with no per-call conversion. This is the Julia-side image of
C++'s implicit derived→base conversion.

## Reproducing multiple inheritance

Where a Clang class inherits two bases whose subobjects sit at different offsets — the
canonical case is a decl that is both a `Decl` and a `DeclContext` — the two base pointers
differ, so pointer identity is *not* enough to cross between them. This layer models the two
bases as **disjoint** Julia hierarchies (`AbstractDecl` and `AbstractDeclContext` share no
subtype relation) and crosses only through the pivot wrappers `castToDeclContext` /
`castFromDeclContext`, which call the C functions that perform Clang's offset-correct
`Decl::castToDeclContext`. Never construct `DeclContext(decl.ptr)` (or the reverse) by hand:
reusing the raw pointer skips the offset adjustment and corrupts. The type disjointness is
the enforcement — no method accepts an `AbstractDecl` where a `DeclContext` is wanted, so
the only way across is the pivot.

Value types cross the same way, by their own encoded pivot, never by pointer reuse:
`QualType` ↔ `Type_` through `getTypePtr` / `getCanonicalTypeInternal`; likewise
`DeclarationName`, `DeclGroupRef`, `TemplateName`.

## Invariant 1 — faithful carriers (construction discipline)

A concrete carrier may be constructed only from a pointer whose dynamic class is already
established, by exactly one of:

- **`resolve(x)`** — reads the runtime class (`getStmtClass` for statements, Clang RTTI
  predicates for types) and returns the matching concrete carrier. Stmt resolution is an
  O(1) table lookup (`STMT_CLASS_TO_TYPE`, `stmt.jl`); Type resolution is an order-sensitive
  predicate chain (`resolve(::AbstractType)`, `src/types.jl` — the ordering comment there is
  load-bearing); Decl has no generic resolve and refines through explicit `castTo*`. Unknown
  kinds fall back to the value unchanged (Type falls back to `UnexposedType`).
- **A downcast** — `castTo<Derived>` / the stamped `clang_Stmt_castTo*`, which use
  `dyn_cast_or_null` and yield a NULL-pointer carrier on the wrong kind.
- **A getter whose C++ return type is statically that class** — e.g. `getRetValue` returns
  an `Expr`, so wrapping its result directly as `Expr` is sound.

Never wrap a raw pointer into a concrete carrier whose class you have not established. When
a C method returns a *base* handle — `getChildren` yields `Stmt`, `getDeclContext` yields
`DeclContext` — wrap it at that base type and let the caller `resolve` to refine; do not
guess a concrete type.

## Invariant 2 — receivers, and dispatch as the type check

Type each wrapper's receiver at the abstract supertype of the class that *declares* the C++
method, and no looser:

```julia
getCond(x::AbstractIfStmt)   = ...   # IfStmt::getCond — declared on IfStmt
getBeginLoc(x::AbstractStmt) = ...   # Stmt::getBeginLoc — declared on the base
```

Dispatch is then the type check: a `WhileStmt` cannot reach `getCond`, so the C
`static_cast<clang::IfStmt *>` never runs on a non-`IfStmt`. Typing the receiver too loosely
(`AbstractStmt` for an `IfStmt`-only method) silently removes that guarantee and reopens the
UB the C layer assumes away. This is the single most important rule in this directory.

## Anatomy of a wrapper

```julia
function getRetValue(x::AbstractReturnStmt)
    @check_ptrs x                         # every pointer-carrying arg: assert non-NULL
    return Expr_(clang_ReturnStmt_getRetValue(x))   # wrap the return in its carrier
end
```

Return marshalling:

- Pointer returns → wrap in the carrier for their static type; **never return a raw `Ptr`**.
- `CXString` / `CXStringSet` → `get_string` (it disposes them; a plain `unsafe_string`
  leaks).
- `const char *` → `unsafe_string`.
- `CXSourceLocation_` / `CXSourceRange_` → wrap in `SourceLocation` / `SourceRange`.
- `Bool` / integer / enum → return bare.

`@check_ptrs` only asserts non-NULL — it is not a type check; Invariants 1 and 2 are what
keep the type honest.

## Registration

Adding a file touches three hand-maintained lists (none are auto-synced):

1. `core/core.jl` — include the new struct file.
2. `api/api.jl` — include the new wrapper file.
3. `src/ClangCompiler.jl` — a `public` line for any user-facing name.

## What this layer must never do

- Return a raw `Ptr` from a wrapper (breaks Invariant 1 downstream).
- Construct a concrete carrier from a pointer whose dynamic class is unestablished.
- Type a receiver looser than the declaring class (breaks Invariant 2).
- Cross the `Decl`/`DeclContext` or `QualType`/`Type_` boundary by reusing a raw pointer
  instead of the pivot.
- Push validation *down* into the C shim, or expect the C shim to check anything. The C
  layer is total and unsafe by contract; the checks live here.
