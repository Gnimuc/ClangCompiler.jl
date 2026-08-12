# TokenConcatenation
"""
    TokenConcatenation(pp::AbstractPreprocessor) -> TokenConcatenation
Build the per-token-kind table that answers whether two adjacent tokens may be printed with
nothing between them.

This is what printing a token stream back to text needs: a macro body walked through
`getReplacementToken`, or the output of [`Lex`](@ref), is wrong in both directions
otherwise — joining `foo` and `bar` yields the single token `foobar`, while a space between
every pair is unreadable.

`pp` is borrowed and must outlive the result. This function allocates and one should call
`dispose` to release the resources after using this object.
"""
function TokenConcatenation(pp::AbstractPreprocessor)
    @check_ptrs pp
    tc = clang_TokenConcatenation_create(pp)
    @assert tc != C_NULL "Failed to create TokenConcatenation"
    return TokenConcatenation(tc)
end

dispose(x::TokenConcatenation) = clang_TokenConcatenation_dispose(x)

"""
    AvoidConcat(x::AbstractTokenConcatenation, prev_prev_tok::AbstractToken,
                prev_tok::AbstractToken, tok::AbstractToken) -> Bool
Return whether a space has to be printed between `prev_tok` and `tok`.

`prev_prev_tok` is the token before `prev_tok`, which a few kinds need in order to decide
(a `.` after a numeric constant, a `+` or `-` after an exponent); pass a freshly created
`Token` when there is none.
"""
function AvoidConcat(x::AbstractTokenConcatenation, prev_prev_tok::AbstractToken, prev_tok::AbstractToken, tok::AbstractToken)
    @check_ptrs x prev_prev_tok prev_tok tok
    return clang_TokenConcatenation_AvoidConcat(x, prev_prev_tok, prev_tok, tok)
end
