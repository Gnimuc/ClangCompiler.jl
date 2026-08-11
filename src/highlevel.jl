# Interpreter-level conveniences: the handful of chants every caller writes before it can ask
# clang anything. Each one here is a composition of public pieces, kept in one place so that a
# program about C++ reads as a program about C++ rather than about this package's plumbing.
#
# The line these hold is that they compose and never widen. Every one returns a *resolved*
# carrier -- the concrete class clang reported, not a base -- because a base-typed carrier makes
# `d isa FunctionDecl` silently false, and a caller who has to remember to `resolve` will
# eventually not.

"""
    translation_unit(x::CxxInterpreter) -> TranslationUnitDecl

Return the translation unit of the **most recent** increment.

Not everything parsed into `x`. Clang's incremental interpreter starts a fresh
`TranslationUnitDecl` for every [`parse`](@ref) and chains them by previous-decl, and
`getTranslationUnitDecl` answers with the most recent one — so after two parses the first
increment's declarations are not under the node this returns, and walking it sees only the
second. The declarations are all still there and still findable by name with
[`find_decl`](@ref); it is the *container* that is per-increment.

Use [`IncrementalParser`](@ref) when one translation unit spanning every increment is what is
wanted: it drives the same clang `Parser` over a unit it never replaces. It parses and does not
execute.
"""
translation_unit(x::CxxInterpreter) = getTranslationUnitDecl(get_ast_context(x))

"""
    top_level_decls(x::CxxInterpreter) -> Vector

Return the declarations written directly at file scope in the **most recent** increment, each
resolved to its concrete class.

Direct children only: a namespace comes back as one `NamespaceDecl`, not as itself plus
everything inside it. Use [`decls`](@ref) on a context for the flattened walk, or
[`decls_in`](@ref) to descend one level at a time.

Per-increment for the reason [`translation_unit`](@ref) gives — this walks the unit that
returns — so a second [`parse`](@ref) does not add to what an earlier call reported. Collect
per increment, or use [`IncrementalParser`](@ref), which returns each increment's declarations
from `parse` itself.
"""
top_level_decls(x::CxxInterpreter) = collect(decls_in(castToDeclContext(translation_unit(x))))

"""
    find_decl(x::CxxInterpreter, name::AbstractString) -> resolved decl, or `nothing`

Look `name` up the way C++ would at file scope and return the single declaration it names,
resolved to its concrete class. `name` may be qualified (`"app::widget::size"`).

Returns `nothing` when nothing is found, and throws when the name is ambiguous — an overload
set is several declarations, so ask [`find_decls`](@ref) for those.

```julia
I = create_interpreter(String[])
parse(I, "namespace app { int twice(int v) { return 2*v; } }")
fd = find_decl(I, "app::twice")     # a FunctionDecl, not a NamedDecl
```
"""
function find_decl(x::CxxInterpreter, name::AbstractString)
    finder = DeclFinder(x)
    try
        finder(x, String(name)) || return nothing
        return resolve(get_decl(finder))
    finally
        dispose(finder)
    end
end

"""
    find_decls(x::CxxInterpreter, name::AbstractString) -> Vector

Every declaration `name` resolves to, each resolved to its concrete class — an overload set
comes back whole. Empty when the name is not found.
"""
function find_decls(x::CxxInterpreter, name::AbstractString)
    finder = DeclFinder(x)
    try
        finder(x, String(name)) || return []
        return [resolve(d) for d in get_decls(finder)]
    finally
        dispose(finder)
    end
end

"""
    source_location(x::CxxInterpreter, node) -> (; file, line, column)

Where `node` was written. `node` is a declaration, a statement, or a `SourceLocation`.

Code handed to [`parse`](@ref) has no file behind it, so `file` is the name clang gave the
in-memory buffer (`"input_line_1"` and so on) rather than a path.
"""
function source_location(x::CxxInterpreter, loc::SourceLocation)
    sm = getSourceManager(get_instance(x))
    presumed = getPresumedLoc(sm, loc)
    # The presumed location is the one `#line` directives can move, which is what a diagnostic
    # would print. It is unavailable for an invalid location, and then the spelling -- where the
    # text physically sits -- is the only answer there is.
    presumed === nothing && return (; file="", line=Int(getSpellingLineNumber(sm, loc)), column=Int(getSpellingColumnNumber(sm, loc)))
    file, line, column, _ = presumed
    return (; file=file, line=Int(line), column=Int(column))
end

source_location(x::CxxInterpreter, node::AbstractDecl) = source_location(x, getBeginLoc(node))
source_location(x::CxxInterpreter, node::AbstractStmt) = source_location(x, getBeginLoc(node))

"""
    definition(x) -> resolved decl, or `nothing`

The declaration that *completes* `x`, when `x` is a class, struct, union or enum. Returns `x`
itself when it is already the definition, and `nothing` when the translation unit only ever
forward-declared it.

A lookup finds whichever declaration comes first, and for a type declared before it is defined
that is the forward declaration — which has no members, no bases and no layout. Walking one
yields an empty list rather than an error, so the mistake reads as "this class has no methods".
Every accessor that needs a complete type goes through here.

```julia
parse(I, "struct Fwd; struct Fwd { int x; };")
definition(find_decl(I, "Fwd"))      # the one with the member
```
"""
function definition(x::AbstractTagDecl)
    @check_ptrs x
    d = getDefinition(x)
    return is_null_handle(d) ? nothing : resolve(d)
end

"""
    members(x) -> Vector

Everything declared directly inside `x`, each resolved to its concrete class. `x` is a record,
an enum, a namespace, or any declaration that is also a `DeclContext`.

For a class this is the completing definition's members — see [`definition`](@ref) — so a
forward declaration does not silently come back empty. Direct members only: a nested class is
one entry, not itself plus its own members.

```julia
[m for m in members(find_decl(I, "Widget")) if m isa CXXMethodDecl]
```
"""
# One method over the decls that are also contexts, rather than one per family. A record is
# both an `AbstractTagDecl` and a member of the `AbstractDeclContextDecl` union, so two methods
# would have the union win by specificity -- and the union arm is the one that does NOT consult
# `definition`, so `members(a_forward_declaration)` would quietly come back empty. That is the
# very failure this function exists to remove, so the tag check lives inside.
function members(x::AbstractDeclContextDecl)
    @check_ptrs x
    d = x isa AbstractTagDecl ? definition(x) : x
    d === nothing && return []
    return [resolve(m) for m in decls_in(castToDeclContext(d))]
end

members(x::AbstractDeclContext) = (@check_ptrs x; [resolve(m) for m in decls_in(x)])

"""
    signature(x::AbstractFunctionDecl) -> NamedTuple

What `x` looks like to a caller: `(; name, return_type, parameters, is_const, is_static,
is_virtual, is_deleted, is_variadic)`, with the types rendered as the source spells them.

The pieces are each one accessor away, but collecting them is a walk — the return type lives on
the function's `FunctionProtoType` rather than on the declaration, and the parameters come one
`getParamDecl` at a time — so a caller asking "what is this function" writes the same six lines
every time.

`is_const` and `is_virtual` are false for a free function, which has neither. `is_static` is
true for both a `static` member and a file-scope `static` function, which are different
language features that share a keyword: the first is "no implicit object argument", the second
is internal linkage.

The rendered types follow the translation unit's own language options, so C++ spellings come
back as C++ — `bool` rather than `_Bool`, `A<A<int>>` rather than `A<A<int> >`. Rendering is
for reading and reporting; it is clang's printer talking, and both the policy and the target
influence it, so compare declarations by their parts rather than by these strings.
"""
function signature(x::AbstractFunctionDecl)
    @check_ptrs x
    ft = resolve(getTypePtr(getType(x)))
    # `QualType::getAsString()` with no policy uses a default-constructed `LangOptions`, i.e.
    # C89 -- which is why a C++ `bool` came back as `_Bool` and nested template arguments got
    # the pre-C++11 `> >` separator. The declaration's own context knows better.
    policy = PrintingPolicy(getLangOpts(getASTContext(x)))
    try
        ret = ft isa AbstractFunctionProtoType ? getAsString(getReturnType(ft), policy) : ""
        params = [getAsString(getType(getParamDecl(x, i)), policy) for i = 0:(getNumParams(x) - 1)]
        method = x isa AbstractCXXMethodDecl
        return (; name=getNameAsString(x), return_type=ret, parameters=params, is_const=method ? isConst(x) : false,
                # A file-scope `static` is not an `AbstractCXXMethodDecl`, so asking only the
                # method accessor reported `false` for the one declaration whose `static` is
                # written in the source.
                is_static=method ? isStatic(x) : getStorageClass(x) == CXStorageClass_SC_Static, is_virtual=method ? isVirtual(x) : false, is_deleted=isDeleted(x), is_variadic=ft isa AbstractFunctionProtoType ? isVariadic(ft) : false)
    finally
        dispose(policy)
    end
end

"""
    mangled_name(x::CxxInterpreter, d) -> String

The linker symbol `d` would be emitted under, for the target `x` was configured with.

Answers "would a shim calling this actually link" when held against the symbol table of the
library being linked — the question that otherwise waits for a build. Note a method defined
inline in its header has no out-of-line symbol at all, so a caller compiling its own copy links
without one; a mangled name absent from the exports is not by itself a verdict.

`d` is a function, variable or field — the declarations clang's mangler has an entry for. A
class, enum, typedef or namespace has no mangled name and is a `MethodError` here rather than
the segfault that reaching clang with one produces; a *type*'s name comes from
`mangleTypeName`. The accepted set is [`MANGLEABLE_DECL`](@ref).

`d` must also not be a constructor or destructor: those have several mangled names and clang's
entry point wants to be told which, so ask [`getAllManglings`](@ref) instead.

Builds and disposes a `MangleContext` per call. To mangle many declarations, make one with
[`createMangleContext`](@ref) and call [`mangleName`](@ref) directly.
"""
function mangled_name(x::CxxInterpreter, d::MANGLEABLE_DECL)
    @check_ptrs d
    ctx = get_ast_context(x)
    mc = createMangleContext(ctx, getTargetInfo(ctx))
    try
        return mangleName(mc, d)
    finally
        dispose(mc)
    end
end

"""
    decl_name(d::AbstractNamedDecl) -> String
The name `d` was declared with, unqualified: `"m"` for `app::Widget::m`.

Empty for a declaration that has no name of its own — an anonymous struct, an unnamed
parameter — which is a state clang represents rather than an error.
"""
decl_name(d::AbstractNamedDecl) = getNameAsString(d)

"""
    qualified_name(d::AbstractNamedDecl) -> String
The name `d` was declared with, qualified by the namespaces and classes enclosing it:
`"app::Widget::m"`.

This is the spelling [`find_decl`](@ref) takes, so it is the round trip between a declaration
and the name that finds it again.
"""
qualified_name(d::AbstractNamedDecl) = getQualifiedNameAsString(d)
