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

Return the translation unit everything parsed into `x` lives under.
"""
translation_unit(x::CxxInterpreter) = getTranslationUnitDecl(get_ast_context(x))

"""
    top_level_decls(x::CxxInterpreter) -> Vector

Return the declarations written directly at file scope, each resolved to its concrete class.

Direct children only: a namespace comes back as one `NamespaceDecl`, not as itself plus
everything inside it. Use [`decls`](@ref) on a context for the flattened walk, or
[`decls_in`](@ref) to descend one level at a time.
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
    presumed === nothing && return (; file="", line=Int(getSpellingLineNumber(sm, loc)),
                                    column=Int(getSpellingColumnNumber(sm, loc)))
    file, line, column, _ = presumed
    return (; file=file, line=Int(line), column=Int(column))
end

source_location(x::CxxInterpreter, node::AbstractDecl) = source_location(x, getBeginLoc(node))
source_location(x::CxxInterpreter, node::AbstractStmt) = source_location(x, getBeginLoc(node))
