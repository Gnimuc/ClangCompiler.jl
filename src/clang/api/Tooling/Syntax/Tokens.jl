# syntax::Token

"""
    getKind(x::AbstractSyntaxToken) -> UInt32
Return the raw `clang::tok::TokenKind` value of this token.

Same encoding `getKind(::AbstractToken)` uses — the kind enum is not mirrored, and
`getTokenName` names it.
"""
function getKind(x::AbstractSyntaxToken)
    @check_ptrs x
    return clang_syntax_Token_kind(x)
end

"""
    getLocation(x::AbstractSyntaxToken) -> SourceLocation
Return the location of the token's first character.
"""
function getLocation(x::AbstractSyntaxToken)
    @check_ptrs x
    return SourceLocation(clang_syntax_Token_location(x))
end

"""
    getEndLocation(x::AbstractSyntaxToken) -> SourceLocation
Return the location just past the token's last character.
"""
function getEndLocation(x::AbstractSyntaxToken)
    @check_ptrs x
    return SourceLocation(clang_syntax_Token_endLocation(x))
end

"""
    getLength(x::AbstractSyntaxToken) -> UInt32
Return the token's length in characters of source text.
"""
function getLength(x::AbstractSyntaxToken)
    @check_ptrs x
    return clang_syntax_Token_length(x)
end

"""
    text(x::AbstractSyntaxToken, src_mgr::AbstractSourceManager) -> String
Return the source text the token covers, digraphs and line continuations included.

That is why this is not the same as the kind's spelling: `int` and `in\\<newline>t` are both
`tok::kw_int` and have different text.

`src_mgr` must be the source manager the token's location came from.
"""
function text(x::AbstractSyntaxToken, src_mgr::AbstractSourceManager)
    @check_ptrs x src_mgr
    return get_string(clang_syntax_Token_text(x, src_mgr))
end

"""
    str(x::AbstractSyntaxToken) -> String
Return Clang's debugging form of the token: its kind and length, no source text.
"""
function str(x::AbstractSyntaxToken)
    @check_ptrs x
    return get_string(clang_syntax_Token_str(x))
end

# SyntaxTokenList

"""
    Base.length(x::AbstractSyntaxTokenList) -> UInt32
Return how many tokens the list holds.
"""
function Base.length(x::AbstractSyntaxTokenList)
    @check_ptrs x
    return clang_syntax_TokenList_getNumTokens(x)
end

"""
    getToken(x::AbstractSyntaxTokenList, i::Integer) -> SyntaxToken
Return the `i`-th token of the list, counting from 0.

The token is *borrowed* from the list: it stays valid until the list is disposed.
"""
function getToken(x::AbstractSyntaxTokenList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_syntax_TokenList_getNumTokens(x) "token index $i out of range"
    return SyntaxToken(clang_syntax_TokenList_getToken(x, i))
end

dispose(x::SyntaxTokenList) = clang_syntax_TokenList_dispose(x)

"""
    tokenize(fid::AbstractFileID, src_mgr::AbstractSourceManager, lang_opts::AbstractLangOptions) -> SyntaxTokenList
Lex the whole buffer behind `fid` in *raw* mode and return its spelled tokens.

Raw means no preprocessing at all: directives come back as ordinary tokens, disabled `#if`
branches are lexed like everything else, and no macro is expanded. Raw identifiers are
post-processed into their real keyword kinds, which a bare `Lexer` in raw mode does not do.
There is no trailing `eof` token.

`fid` must be valid and known to `src_mgr`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function tokenize(fid::AbstractFileID, src_mgr::AbstractSourceManager,
                  lang_opts::AbstractLangOptions)
    @check_ptrs fid src_mgr lang_opts
    @assert isValid(fid) "the file ID must be valid"
    ptr = clang_syntax_tokenize(fid, src_mgr, lang_opts)
    @assert ptr != C_NULL "Failed to tokenize"
    return SyntaxTokenList(ptr)
end

"""
    tokenize(fid::AbstractFileID, begin_offset::Integer, end_offset::Integer,
             src_mgr::AbstractSourceManager, lang_opts::AbstractLangOptions) -> SyntaxTokenList
Lex only the `[begin_offset, end_offset)` slice of the buffer behind `fid`.

Offsets need not sit on token boundaries: the first token may be incomplete and the last one
may run past `end_offset`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function tokenize(fid::AbstractFileID, begin_offset::Integer, end_offset::Integer,
                  src_mgr::AbstractSourceManager, lang_opts::AbstractLangOptions)
    @check_ptrs fid src_mgr lang_opts
    @assert isValid(fid) "the file ID must be valid"
    @assert 0 <= begin_offset <= end_offset "the file range must be a half-open [begin, end)"
    ptr = clang_syntax_tokenizeFileRange(fid, begin_offset, end_offset, src_mgr, lang_opts)
    @assert ptr != C_NULL "Failed to tokenize"
    return SyntaxTokenList(ptr)
end

# syntax::TokenBuffer

"""
    expandedTokens(x::AbstractTokenBuffer) -> SyntaxTokenList
Return the tokens the preprocessor produced, in translation-unit order and ending in `eof`.

These are the ones AST source locations point at.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function expandedTokens(x::AbstractTokenBuffer)
    @check_ptrs x
    ptr = clang_syntax_TokenBuffer_expandedTokens(x)
    @assert ptr != C_NULL "Failed to read the expanded tokens"
    return SyntaxTokenList(ptr)
end

"""
    expandedTokens(x::AbstractTokenBuffer, range::SourceRange) -> SyntaxTokenList
Return the expanded tokens covered by the closed token range `range`, which is what an AST
node's `getSourceRange` gives.

An invalid range answers an empty list. Call [`indexExpandedTokens`](@ref) first when this
is going to be asked many times.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function expandedTokens(x::AbstractTokenBuffer, range::SourceRange)
    @check_ptrs x
    r = CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr)
    ptr = clang_syntax_TokenBuffer_expandedTokensInRange(x, r)
    @assert ptr != C_NULL "Failed to read the expanded tokens"
    return SyntaxTokenList(ptr)
end

"""
    indexExpandedTokens(x::AbstractTokenBuffer)
Build the index that makes `expandedTokens(x, range)` a lookup rather than a scan. Building
it twice is a no-op.
"""
function indexExpandedTokens(x::AbstractTokenBuffer)
    @check_ptrs x
    return clang_syntax_TokenBuffer_indexExpandedTokens(x)
end

"""
    spelledTokens(x::AbstractTokenBuffer, fid::AbstractFileID) -> SyntaxTokenList
Return the tokens of `fid` as written, before any macro replacement and including the tokens
of every preprocessor directive.

`fid` must be a file this buffer tracks — one the collected preprocessing actually read.
Clang asserts otherwise, and there is no way to ask it in advance, so this is a precondition
on the caller.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function spelledTokens(x::AbstractTokenBuffer, fid::AbstractFileID)
    @check_ptrs x fid
    @assert isValid(fid) "the file ID must be valid"
    ptr = clang_syntax_TokenBuffer_spelledTokens(x, fid)
    @assert ptr != C_NULL "Failed to read the spelled tokens"
    return SyntaxTokenList(ptr)
end

"""
    spelledTokenAt(x::AbstractTokenBuffer, loc::SourceLocation) -> Union{SyntaxToken,Nothing}
Return the spelled token that starts exactly at `loc`, or `nothing` when none does.

`loc` must be a valid file location — not one inside a macro expansion — in a file the
buffer tracks. The token is borrowed from the buffer.
"""
function spelledTokenAt(x::AbstractTokenBuffer, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) "the location must be valid"
    ptr = clang_syntax_TokenBuffer_spelledTokenAt(x, loc)
    return ptr == C_NULL ? nothing : SyntaxToken(ptr)
end

"""
    spelledForExpanded(x::AbstractTokenBuffer, first_index::Integer, count::Integer) -> Union{SyntaxTokenList,Nothing}
Return the tokens *as written* that produced expanded tokens `[first_index, first_index+count)`.

This is the mapping the `Lexer` alone cannot do: for `#define FIRST f1 f2 f3` and `a FIRST`,
the expanded run `a f1 f2 f3` answers the two spelled tokens `a FIRST` — the text a
refactoring would actually have to replace. It answers `nothing` when the expanded range is
empty, out of bounds, or cuts a macro expansion in half (`a f1` alone cannot be mapped).

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function spelledForExpanded(x::AbstractTokenBuffer, first_index::Integer, count::Integer)
    @check_ptrs x
    @assert first_index >= 0 && count >= 0 "the expanded-token range must be non-negative"
    ptr = clang_syntax_TokenBuffer_spelledForExpanded(x, first_index, count)
    return ptr == C_NULL ? nothing : SyntaxTokenList(ptr)
end

"""
    sourceManager(x::AbstractTokenBuffer) -> SourceManager
Return the source manager the buffer was collected against, borrowed.
"""
function sourceManager(x::AbstractTokenBuffer)
    @check_ptrs x
    return SourceManager(clang_syntax_TokenBuffer_sourceManager(x))
end

"""
    dumpForTests(x::AbstractTokenBuffer) -> String
Return Clang's own debugging dump of both token streams and the mappings between them.
"""
function dumpForTests(x::AbstractTokenBuffer)
    @check_ptrs x
    return get_string(clang_syntax_TokenBuffer_dumpForTests(x))
end

dispose(x::TokenBuffer) = clang_syntax_TokenBuffer_dispose(x)

# syntax::TokenCollector

"""
    TokenCollector(pp::AbstractPreprocessor)
Install the hooks that record both token streams while the frontend runs.

Lifecycle, and it is not optional: the collector installs its callbacks on `pp` *inside this
call*, so it has to be created before preprocessing starts — Clang's own users build one in
`FrontendAction::BeginSourceFile` — and it must not outlive `pp`. Then
[`consume`](@ref) it exactly once, after the action has finished, and `dispose` it.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function TokenCollector(pp::AbstractPreprocessor)
    @check_ptrs pp
    ptr = clang_syntax_TokenCollector_create(pp)
    @assert ptr != C_NULL "Failed to create TokenCollector"
    return TokenCollector(ptr)
end

"""
    consume(x::AbstractTokenCollector) -> TokenBuffer
Finalise collection and return the buffer.

Clang qualifies `consume()` with `&&`, which is its way of saying the collector is spent
afterwards: call this exactly once, and only after the frontend action has run. The returned
buffer outlives the collector.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function consume(x::AbstractTokenCollector)
    @check_ptrs x
    ptr = clang_syntax_TokenCollector_consume(x)
    @assert ptr != C_NULL "Failed to consume the TokenCollector"
    return TokenBuffer(ptr)
end

dispose(x::TokenCollector) = clang_syntax_TokenCollector_dispose(x)
