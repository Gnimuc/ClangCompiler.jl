# OperatorPrecedence — how tightly a binary or ternary operator binds.

"""
    getBinOpPrecedence(kind::Integer, greater_than_is_operator::Bool,
                       cplusplus11::Bool) -> CXPrecLevel
Return the precedence of the binary or ternary operator token `kind`, or
`CXPrecLevel_Unknown` for a token that is neither.

`kind` is a raw `clang::tok::TokenKind`, the same currency
[`getTokenID`](@ref) and the `clang_tok_*` helpers use.

The two switches are the context the answer depends on: with `greater_than_is_operator`
false a `>` closes a template argument list instead of comparing, and `cplusplus11` is what
makes `>>` a shift rather than two closing angle brackets.
"""
function getBinOpPrecedence(kind::Integer, greater_than_is_operator::Bool,
                            cplusplus11::Bool)
    return clang_getBinOpPrecedence(kind, greater_than_is_operator, cplusplus11)
end
