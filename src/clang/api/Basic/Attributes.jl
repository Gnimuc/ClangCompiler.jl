# Attributes — the engine behind __has_attribute / __has_cpp_attribute.

"""
    hasAttribute(syntax::CXAttributeCommonInfoSyntax,
                 scope::Union{AbstractIdentifierInfo,Nothing},
                 attr::AbstractIdentifierInfo, target::AbstractTargetInfo,
                 lang_opts::AbstractLangOptions) -> Int
Return the version number clang implements the named attribute at, or 0 when it implements
no such attribute in that syntax for that target and language mode.

`scope` is the `[[scope::attr]]` qualifier and is `nothing` for an unscoped attribute;
`attr` names the attribute itself. Both come from the preprocessor's identifier table, so
they are spelled with [`getIdentifierInfo`](@ref).

This is what `__has_attribute` and `__has_cpp_attribute` answer with, so it is how a caller
can probe availability before synthesizing attributed code.
"""
function hasAttribute(syntax::CXAttributeCommonInfoSyntax, scope::Union{AbstractIdentifierInfo,Nothing}, attr::AbstractIdentifierInfo, target::AbstractTargetInfo, lang_opts::AbstractLangOptions)
    @check_ptrs attr target lang_opts
    scope === nothing || @check_ptrs scope
    s = scope === nothing ? IdentifierInfo(C_NULL) : scope
    return Int(clang_hasAttribute(syntax, s, attr, target, lang_opts))
end
