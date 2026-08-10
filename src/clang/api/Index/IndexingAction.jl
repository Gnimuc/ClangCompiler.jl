# index (clang/Index/IndexingAction.h) — walking a translation unit and reporting every
# symbol occurrence.
#
# `clang::index::IndexDataConsumer` is an abstract class with five virtuals and there is no
# way to route a virtual call back into Julia, so the C shim compiles in one concrete
# subclass that appends every occurrence to a buffer. That makes this a batch interface:
# run a driver, then read the buffer by index.
#
# The keyword arguments of both drivers are `clang::index::IndexingOptions`, whose
# `ShouldTraverseDecl` filter is a `std::function` this boundary cannot carry and is left
# unset. The defaults below are upstream's.

"""
    IndexDataCollector() -> IndexDataCollector
Build the occurrence collector the two indexing drivers report into.

This function allocates and one should call `dispose` to release the resources after using
this object. Neither driver adopts it: both take the consumer by reference, and a collector
is reusable across runs (cumulatively, unless [`clear`](@ref) is called between them).
"""
function IndexDataCollector()
    c = clang_IndexDataCollector_create()
    @assert c != C_NULL "Failed to create IndexDataCollector"
    return IndexDataCollector(c)
end

dispose(x::IndexDataCollector) = clang_IndexDataCollector_dispose(x)

"""
    clear(x::AbstractIndexDataCollector) -> Nothing
Drop every occurrence collected so far so the collector can be reused. Without this a
second driver call appends to the first one's results.
"""
function clear(x::AbstractIndexDataCollector)
    @check_ptrs x
    return clang_IndexDataCollector_clear(x)
end

"""
    getNumOccurrences(x::AbstractIndexDataCollector) -> UInt32
Return how many symbol occurrences the collector holds.
"""
function getNumOccurrences(x::AbstractIndexDataCollector)
    @check_ptrs x
    return clang_IndexDataCollector_getNumOccurrences(x)
end

"""
    isMacroOccurrence(x::AbstractIndexDataCollector, i::Integer) -> Bool
Return whether occurrence `i` (zero-based) is a macro occurrence rather than a declaration
occurrence. The two carry disjoint payloads: a macro occurrence has a name and no decl, a
decl occurrence a decl and no name.
"""
function isMacroOccurrence(x::AbstractIndexDataCollector, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOccurrences(x) "occurrence index $i is out of range."
    return clang_IndexDataCollector_isMacroOccurrence(x, i)
end

"""
    getOccurrenceDecl(x::AbstractIndexDataCollector, i::Integer) -> Union{Decl,Nothing}
Return the declaration occurrence `i` (zero-based) refers to, or `nothing` when the
occurrence is a macro one.

The decl is borrowed from the AST that was walked and is valid only as long as that AST is.
It is returned at its static type `Decl`; [`resolve`](@ref) narrows it to the class clang
reports.
"""
function getOccurrenceDecl(x::AbstractIndexDataCollector, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOccurrences(x) "occurrence index $i is out of range."
    d = clang_IndexDataCollector_getOccurrenceDecl(x, i)
    return d == C_NULL ? nothing : Decl(d)
end

"""
    getOccurrenceMacroName(x::AbstractIndexDataCollector, i::Integer) -> String
Return the macro's spelling for a macro occurrence, and `""` for a declaration one.
"""
function getOccurrenceMacroName(x::AbstractIndexDataCollector, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOccurrences(x) "occurrence index $i is out of range."
    return get_string(clang_IndexDataCollector_getOccurrenceMacroName(x, i))
end

"""
    getOccurrenceRoles(x::AbstractIndexDataCollector, i::Integer) -> UInt32
Return the `SymbolRoleSet` of occurrence `i` (zero-based): a bitset of `CXSymbolRole_`
values saying whether this occurrence declares, defines, reads, writes or calls the symbol.
[`printSymbolRoles`](@ref) renders it.
"""
function getOccurrenceRoles(x::AbstractIndexDataCollector, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOccurrences(x) "occurrence index $i is out of range."
    return clang_IndexDataCollector_getOccurrenceRoles(x, i)
end

"""
    getOccurrenceLocation(x::AbstractIndexDataCollector, i::Integer) -> SourceLocation
Return where occurrence `i` (zero-based) was written. May be an invalid location for an
implicit occurrence.
"""
function getOccurrenceLocation(x::AbstractIndexDataCollector, i::Integer)
    @check_ptrs x
    @assert 0 ≤ i < getNumOccurrences(x) "occurrence index $i is out of range."
    return SourceLocation(clang_IndexDataCollector_getOccurrenceLocation(x, i))
end

"""
    indexASTUnit(unit::AbstractASTUnit, c::AbstractIndexDataCollector; kwargs...) -> Nothing
Walk every declaration of an already-parsed `ASTUnit`, reporting each symbol occurrence
into `c`.

Keyword arguments mirror `clang::index::IndexingOptions`, with its defaults:
`system_symbol_filter` (how much of the system headers to index), `index_function_locals`,
`index_implicit_instantiation`, `index_macros`, `index_macros_in_preprocessor`,
`index_parameters_in_declarations` (no effect unless `index_function_locals` is set) and
`index_template_parameters`.
"""
function indexASTUnit(unit::AbstractASTUnit, c::AbstractIndexDataCollector;
                      system_symbol_filter::CXSystemSymbolFilterKind=CXSystemSymbolFilterKind_DeclarationsOnly,
                      index_function_locals::Bool=false,
                      index_implicit_instantiation::Bool=false,
                      index_macros::Bool=true,
                      index_macros_in_preprocessor::Bool=false,
                      index_parameters_in_declarations::Bool=false,
                      index_template_parameters::Bool=false)
    @check_ptrs unit c
    return clang_index_indexASTUnit(unit, c, system_symbol_filter, index_function_locals,
                                    index_implicit_instantiation, index_macros,
                                    index_macros_in_preprocessor,
                                    index_parameters_in_declarations,
                                    index_template_parameters)
end

"""
    indexTopLevelDecls(ctx::AbstractASTContext, pp::AbstractPreprocessor, decls, c::AbstractIndexDataCollector; kwargs...) -> Nothing
Walk `decls` — and, recursively, everything under them — in an `ASTContext` the caller
already has, reporting each symbol occurrence into `c`. This is the interpreter-shaped
route, where there is no `ASTUnit` to hand to [`indexASTUnit`](@ref).

An empty `decls` walks nothing. Keyword arguments are the same as `indexASTUnit`'s.
"""
function indexTopLevelDecls(ctx::AbstractASTContext, pp::AbstractPreprocessor,
                            decls::AbstractVector{<:AbstractDecl},
                            c::AbstractIndexDataCollector;
                            system_symbol_filter::CXSystemSymbolFilterKind=CXSystemSymbolFilterKind_DeclarationsOnly,
                            index_function_locals::Bool=false,
                            index_implicit_instantiation::Bool=false,
                            index_macros::Bool=true,
                            index_macros_in_preprocessor::Bool=false,
                            index_parameters_in_declarations::Bool=false,
                            index_template_parameters::Bool=false)
    @check_ptrs ctx pp c
    for d in decls
        @check_ptrs d
    end
    # One handle per decl, each produced by the same checked conversion a ccall argument
    # would go through; the array is what the C side reads as `CXDecl *`.
    handles = CXDecl[Base.unsafe_convert(CXDecl, d) for d in decls]
    return clang_index_indexTopLevelDecls(ctx, pp, handles, length(handles), c,
                                          system_symbol_filter, index_function_locals,
                                          index_implicit_instantiation, index_macros,
                                          index_macros_in_preprocessor,
                                          index_parameters_in_declarations,
                                          index_template_parameters)
end
