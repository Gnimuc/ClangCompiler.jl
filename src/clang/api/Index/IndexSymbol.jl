# index (clang::index — the namespace-level free functions of clang/Index/IndexSymbol.h)
#
# clang's own canonical taxonomy for a declaration: one call turns any `Decl` into the
# (kind, sub-kind, language, properties) quadruple the indexer uses, which is what an
# isa-chain over `Decl` classes is trying to reconstruct by hand.
#
# Upstream returns a four-field POD; the C shim splits it into out-parameters and the two
# wrappers below reassemble it as a `NamedTuple`. `properties` is the `SymbolPropertySet`
# bitset, i.e. an or of `CXSymbolProperty` values; role sets elsewhere are ors of
# `CXSymbolRole_` values.

"""
    getSymbolInfo(x::AbstractDecl) -> NamedTuple
Classify `x` the way clang's indexer does, as
`(kind::CXSymbolKind, subkind::CXSymbolSubKind, lang::CXSymbolLanguage, properties::UInt32)`.

A declaration class the taxonomy does not name yields `CXSymbolKind_Unknown` rather than an
error, so this is total over any decl. `properties` is a bitset of `CXSymbolProperty`
values, rendered by [`printSymbolProperties`](@ref).
"""
function getSymbolInfo(x::AbstractDecl)
    @check_ptrs x
    kind = Ref{CXSymbolKind}(CXSymbolKind_Unknown)
    subkind = Ref{CXSymbolSubKind}(CXSymbolSubKind_None)
    lang = Ref{CXSymbolLanguage}(CXSymbolLanguage_C)
    props = Ref{Cuint}(0)
    clang_index_getSymbolInfo(x, kind, subkind, lang, props)
    return (kind=kind[], subkind=subkind[], lang=lang[], properties=props[])
end

"""
    getSymbolInfoForMacro(x::AbstractMacroInfo) -> NamedTuple
Classify a macro definition, with the same shape as [`getSymbolInfo`](@ref).
"""
function getSymbolInfoForMacro(x::AbstractMacroInfo)
    @check_ptrs x
    kind = Ref{CXSymbolKind}(CXSymbolKind_Unknown)
    subkind = Ref{CXSymbolSubKind}(CXSymbolSubKind_None)
    lang = Ref{CXSymbolLanguage}(CXSymbolLanguage_C)
    props = Ref{Cuint}(0)
    clang_index_getSymbolInfoForMacro(x, kind, subkind, lang, props)
    return (kind=kind[], subkind=subkind[], lang=lang[], properties=props[])
end

"""
    isFunctionLocalSymbol(x::AbstractDecl) -> Bool
Return whether `x` is local to a function body — a parameter, or anything declared inside
one. Such symbols get the `CXSymbolProperty_Local` property.
"""
function isFunctionLocalSymbol(x::AbstractDecl)
    @check_ptrs x
    return clang_index_isFunctionLocalSymbol(x)
end

"""
    getSymbolKindString(k::CXSymbolKind) -> String
Return clang's own spelling of a symbol kind (`"function"`, `"c++-class"`, …).

`k` must be one of the enumerators: the wrapped `switch` has no default and ends in
`llvm_unreachable`, so an out-of-range value is undefined behaviour rather than an error.
"""
function getSymbolKindString(k::CXSymbolKind)
    @assert CXSymbolKind_Unknown ≤ k ≤ CXSymbolKind_Concept "unknown CXSymbolKind $k."
    return get_string(clang_index_getSymbolKindString(k))
end

"""
    getSymbolSubKindString(k::CXSymbolSubKind) -> String
Return clang's own spelling of a symbol sub-kind. Same range precondition as
[`getSymbolKindString`](@ref).
"""
function getSymbolSubKindString(k::CXSymbolSubKind)
    @assert CXSymbolSubKind_None ≤ k ≤ CXSymbolSubKind_UsingEnum "unknown CXSymbolSubKind $k."
    return get_string(clang_index_getSymbolSubKindString(k))
end

"""
    getSymbolLanguageString(k::CXSymbolLanguage) -> String
Return clang's own spelling of a symbol language (`"C"`, `"ObjC"`, `"C++"`, `"Swift"`).
Same range precondition as [`getSymbolKindString`](@ref).
"""
function getSymbolLanguageString(k::CXSymbolLanguage)
    @assert CXSymbolLanguage_C ≤ k ≤ CXSymbolLanguage_Swift "unknown CXSymbolLanguage $k."
    return get_string(clang_index_getSymbolLanguageString(k))
end

"""
    printSymbolName(x::AbstractDecl, lo::AbstractLangOptions) -> String
Return the decl's name as the indexer spells it, or `""` when there is no name to print
(upstream reports that through a `bool`, which is folded into the empty string here).
"""
function printSymbolName(x::AbstractDecl, lo::AbstractLangOptions)
    @check_ptrs x lo
    return get_string(clang_index_printSymbolName(x, lo))
end

"""
    printSymbolRoles(roles::Integer) -> String
Render a `SymbolRoleSet` as comma-separated role names. Any bit pattern is accepted:
unknown bits are skipped and an empty set gives `""`.
"""
printSymbolRoles(roles::Integer) = get_string(clang_index_printSymbolRoles(roles))

"""
    printSymbolProperties(props::Integer) -> String
Render a `SymbolPropertySet` as comma-separated property names, on the same terms as
[`printSymbolRoles`](@ref).
"""
printSymbolProperties(props::Integer) = get_string(clang_index_printSymbolProperties(props))
