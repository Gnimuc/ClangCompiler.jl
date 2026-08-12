# Lexer
"""
    Lexer(fid::FileID, buffer::LLVM.MemoryBuffer, src_mgr::SourceManager, opts::LangOptions) -> Lexer
Create a raw lexer that relexes `buffer` as the file `fid` of `src_mgr`.

The lexer borrows the buffer, the source manager, and the language options, so all of them
must outlive it. This function allocates and one should call `dispose` to release the
resources after using this object.
"""
function Lexer(fid::FileID, buffer::LLVM.MemoryBuffer, src_mgr::SourceManager, opts::LangOptions)
    @check_ptrs fid src_mgr opts
    lex = clang_Lexer_create(fid, buffer, src_mgr, opts)
    @assert lex != C_NULL "Failed to create Lexer"
    return Lexer(lex)
end

dispose(x::Lexer) = clang_Lexer_dispose(x)

function getFileLoc(x::AbstractLexer)
    @check_ptrs x
    return SourceLocation(clang_Lexer_getFileLoc(x))
end

function Lex(x::AbstractLexer, result::AbstractToken)
    @check_ptrs x result
    return clang_Lexer_Lex(x, result)
end

function isPragmaLexer(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_isPragmaLexer(x)
end

function LexFromRawLexer(x::AbstractLexer, result::AbstractToken)
    @check_ptrs x result
    return clang_Lexer_LexFromRawLexer(x, result)
end

function isKeepWhitespaceMode(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_isKeepWhitespaceMode(x)
end

function SetKeepWhitespaceMode(x::AbstractLexer, val::Bool)
    @check_ptrs x
    return clang_Lexer_SetKeepWhitespaceMode(x, val)
end

function inKeepCommentMode(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_inKeepCommentMode(x)
end

function SetCommentRetentionState(x::AbstractLexer, mode::Bool)
    @check_ptrs x
    return clang_Lexer_SetCommentRetentionState(x, mode)
end

function getCurrentBufferOffset(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_getCurrentBufferOffset(x)
end

function isFirstTimeLexingFile(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_isFirstTimeLexingFile(x)
end

# static utilities
function getSpelling(tok::AbstractToken, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs tok src_mgr opts
    return get_string(clang_Lexer_getSpelling(tok, src_mgr, opts))
end

function MeasureTokenLength(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return clang_Lexer_MeasureTokenLength(loc, src_mgr, opts)
end

"""
    getRawToken(loc, result, src_mgr, opts, ignore_whitespace=false) -> Bool
Relex the token at `loc` into `result`. Return `true` if there was a failure, `false` on
success (mirroring `clang::Lexer::getRawToken`).
"""
function getRawToken(loc::SourceLocation, result::AbstractToken, src_mgr::AbstractSourceManager, opts::AbstractLangOptions, ignore_whitespace::Bool=false)
    @check_ptrs result src_mgr opts
    return clang_Lexer_getRawToken(loc, result, src_mgr, opts, ignore_whitespace)
end

function GetBeginningOfToken(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return SourceLocation(clang_Lexer_GetBeginningOfToken(loc, src_mgr, opts))
end

"""
    AdvanceToTokenCharacter(tok_start::SourceLocation, characters::Integer, src_mgr, opts)

Return the location of the `characters`-th character of the token starting at `tok_start`,
counted in the token's **spelling** — so it steps over escaped newlines and trigraphs rather
than counting raw bytes, and `characters == 0` gives `tok_start` back.
"""
function AdvanceToTokenCharacter(tok_start::SourceLocation, characters::Integer, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return SourceLocation(clang_Lexer_AdvanceToTokenCharacter(tok_start, characters, src_mgr, opts))
end

"""
    getAsCharRange(range::SourceRange, src_mgr, opts) -> CharSourceRange

Widen a token range — one whose end names the *start* of its last token — into the character
range that covers that last token in full.

The result is always a character range, which is the point of the call, so the returned
`CharSourceRange` carries `is_token_range = false` and only the two locations cross the
boundary.
"""
function getAsCharRange(range::SourceRange, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    r = clang_Lexer_getAsCharRange(CXSourceRange_(range.begin_loc.ptr, range.end_loc.ptr), src_mgr, opts)
    return CharSourceRange(SourceRange(SourceLocation(r.B), SourceLocation(r.E)), false)
end

function getLocForEndOfToken(loc::SourceLocation, offset::Integer, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return SourceLocation(clang_Lexer_getLocForEndOfToken(loc, offset, src_mgr, opts))
end

"""
    isAtStartOfMacroExpansion(loc, src_mgr, opts) -> Union{SourceLocation,Nothing}
Return the begin location of the macro when the macro location `loc` points at the first
token of its expansion, `nothing` otherwise.
"""
function isAtStartOfMacroExpansion(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Lexer_isAtStartOfMacroExpansion(loc, src_mgr, opts, out) ? SourceLocation(out[]) : nothing
end

"""
    isAtEndOfMacroExpansion(loc, src_mgr, opts) -> Union{SourceLocation,Nothing}
Return the end location of the macro when the macro location `loc` points at the last
token of its expansion, `nothing` otherwise.
"""
function isAtEndOfMacroExpansion(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Lexer_isAtEndOfMacroExpansion(loc, src_mgr, opts, out) ? SourceLocation(out[]) : nothing
end

function getSourceText(r::SourceRange, is_token_range::Bool, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    range = CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr)
    return get_string(clang_Lexer_getSourceText(range, is_token_range, src_mgr, opts))
end

function getImmediateMacroName(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    return get_string(clang_Lexer_getImmediateMacroName(loc, src_mgr, opts))
end

"""
    findNextToken(loc, src_mgr, opts, result) -> Bool
Fill `result` with the token that comes right after `loc` and return `true`; return
`false` (leaving `result` untouched) when the location is inside a macro.
"""
function findNextToken(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions, result::AbstractToken)
    @check_ptrs src_mgr opts result
    return clang_Lexer_findNextToken(loc, src_mgr, opts, result)
end

"""
    getBufferLength(x::AbstractLexer) -> Csize_t
Return the byte count of the source buffer `x` lexes. The bytes are not NUL-terminated at
that count and may themselves contain NUL, which is why they do not cross as a string.
"""
function getBufferLength(x::AbstractLexer)
    @check_ptrs x
    return clang_Lexer_getBufferLength(x)
end

"""
    getBuffer(x::AbstractLexer) -> String
Return the whole source buffer `x` lexes — exactly [`getBufferLength`](@ref) bytes of it.
"""
function getBuffer(x::AbstractLexer)
    @check_ptrs x
    n = clang_Lexer_getBufferLength(x)
    buf = Vector{Cuchar}(undef, n)
    n > 0 && clang_Lexer_getBuffer(x, buf, n)
    return String(buf)
end

"""
    getSourceLocation(x::AbstractLexer) -> SourceLocation
Return the location of the next character `x` will lex. It tracks the buffer pointer, so
[`seek`](@ref) and each `Lex` move it.
"""
function getSourceLocation(x::AbstractLexer)
    @check_ptrs x
    return SourceLocation(clang_Lexer_getSourceLocation(x))
end

"""
    seek(x::AbstractLexer, offset::Integer, is_at_start_of_line::Bool)
Move `x`'s buffer pointer `offset` bytes into its buffer and set its start-of-line flag.

`offset` may not run past the end of the buffer. clang's body is a bare
`BufferPtr = BufferStart + Offset` with no comparison against `BufferEnd`, so an
out-of-range offset makes the next [`LexFromRawLexer`](@ref) read out of bounds; the bound is
read here with [`getBufferLength`](@ref). `offset == getBufferLength(x)` is legal and lexes
as end-of-file, because the buffer clang lexes is always NUL-terminated.
"""
function seek(x::AbstractLexer, offset::Integer, is_at_start_of_line::Bool)
    @check_ptrs x
    @assert 0 <= offset <= getBufferLength(x) "offset must lie within the lexer's buffer"
    return clang_Lexer_seek(x, offset, is_at_start_of_line)
end

"""
    Stringify(str::AbstractString, charify::Bool=false) -> String
Return `str` escaped the way the `#` preprocessor operator escapes it: `\\` and `"` are
backslash-escaped and newlines become `\\n`. With `charify=true` the single quote is escaped
instead of the double quote.
"""
function Stringify(str::AbstractString, charify::Bool=false)
    return get_string(clang_Lexer_Stringify(str, ncodeunits(str), charify))
end

"""
    cleaned_token_length(loc::SourceLocation, src_mgr::AbstractSourceManager,
                         opts::AbstractLangOptions) -> Int
Return the number of characters in the *cleaned* spelling of the token starting at `loc`, or
`0` when nothing relexes there.

This is the bound on a character index into a token, and it is not
[`MeasureTokenLength`](@ref): that measures the token's *physical* extent, which counts the
trigraphs and escaped newlines that the cleaned spelling collapses. For a token spliced by an
escaped newline the two are 11 and 9, and indices 10 and 11 walk past the token's characters.
"""
function cleaned_token_length(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    tok = Token()
    n = getRawToken(loc, tok, src_mgr, opts) ? 0 : ncodeunits(getSpelling(tok, src_mgr, opts))
    dispose(tok)
    return n
end

"""
    getTokenPrefixLength(tok_start::SourceLocation, char_no::Integer,
                         src_mgr::AbstractSourceManager, opts::AbstractLangOptions) -> Cuint
Return the physical length — trigraphs and escaped newlines included — of the first
`char_no` characters of the token that starts at `tok_start`.

`char_no` counts characters of the token's *cleaned* spelling and may not run past it: the
walk is `while (CharNo && isObviouslySimpleCharacter(*TokPtr)) ++TokPtr, --CharNo`, and
`isObviouslySimpleCharacter` is only `C != '?' && C != '\\\\'`, so a NUL counts as simple and
the walk does not stop at the end of the token. The bound is the length of the relexed
spelling, not [`MeasureTokenLength`](@ref): for a token spliced by an escaped newline those
are 9 and 11.
"""
function getTokenPrefixLength(tok_start::SourceLocation, char_no::Integer, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(tok_start) "tok_start must be a valid location"
    @assert 0 <= char_no <= cleaned_token_length(tok_start, src_mgr, opts) "char_no must lie within the token that starts at tok_start"
    return clang_Lexer_getTokenPrefixLength(tok_start, char_no, src_mgr, opts)
end

"""
    makeFileCharRange(r::CharSourceRange, src_mgr::AbstractSourceManager,
                      opts::AbstractLangOptions) -> CharSourceRange
Return `r` mapped onto a character range of file locations, resolving macro expansions to the
file text that produced them.

The result is always a character range — clang produces no token range here. Two invalid
locations are the failure signal: a range that overlaps only part of a macro expansion, or
whose ends lie in different files, cannot be mapped.
"""
function makeFileCharRange(r::CharSourceRange, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(getBegin(r)) && isValid(getEnd(r)) "expected a valid range"
    range = CXSourceRange_(r.range.begin_loc.ptr, r.range.end_loc.ptr)
    out = clang_Lexer_makeFileCharRange(range, r.is_token_range, src_mgr, opts)
    return getCharRange(SourceRange(SourceLocation(out.B), SourceLocation(out.E)))
end

"""
    getImmediateMacroNameForDiagnostics(loc::SourceLocation, src_mgr::AbstractSourceManager,
                                        opts::AbstractLangOptions) -> String
Return the name of the macro responsible for expanding `loc`, resolving a macro-argument
location to the outermost function macro that accepted it.

This is where it differs from [`getImmediateMacroName`](@ref), which names the innermost one:
for `MACOUTER(MACINNER(x))` this returns `"MACOUTER"` and that one returns `"MACINNER"`.
`loc` must be a valid macro location — clang asserts it.
"""
function getImmediateMacroNameForDiagnostics(loc::SourceLocation, src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    return get_string(clang_Lexer_getImmediateMacroNameForDiagnostics(loc, src_mgr, opts))
end

"""
    getIndentationForLine(loc::SourceLocation, src_mgr::AbstractSourceManager) -> String
Return the leading whitespace of the line `loc` is on, or `""` for a line that starts in
column 0. A macro location also answers `""`, so an empty result does not by itself mean
"no indentation"; `loc` is asserted valid so that at least that confusion cannot arise.
"""
function getIndentationForLine(loc::SourceLocation, src_mgr::AbstractSourceManager)
    @check_ptrs src_mgr
    @assert isValid(loc) "loc must be a valid location"
    return get_string(clang_Lexer_getIndentationForLine(loc, src_mgr))
end

"""
    ComputePreamble(buffer::AbstractString, opts::AbstractLangOptions,
                    max_lines::Integer=0) -> Tuple{Cuint,Bool}
Return where `buffer`'s preamble ends — the leading comments and preprocessor directives that
precede the first real code — as a byte offset, together with whether that offset sits at the
start of a line. `max_lines` caps the preamble at that many lines; 0 means no cap.

`buffer` must be NUL-terminated: clang lexes it in place up to `Buffer.end()`.
"""
function ComputePreamble(buffer::AbstractString, opts::AbstractLangOptions, max_lines::Integer=0)
    @check_ptrs opts
    at_sol = Ref{Bool}(false)
    size = clang_Lexer_ComputePreamble(buffer, opts, max_lines, at_sol)
    return size, at_sol[]
end

"""
    findLocationAfterToken(loc::SourceLocation, kind::Integer,
                           src_mgr::AbstractSourceManager, opts::AbstractLangOptions,
                           skip_trailing_whitespace_and_newline::Bool=false) -> SourceLocation
Return the location immediately after the first token that follows `loc`, provided that token
has kind `kind`; an invalid location otherwise. Comments and whitespace are skipped when
looking for it, and `skip_trailing_whitespace_and_newline` also skips what follows it.

`kind` is a raw `clang::tok::TokenKind`, as [`getKind`](@ref) returns for a `Token`; the kind
enum is not mirrored, so read it off a token rather than spelling a number.
"""
function findLocationAfterToken(loc::SourceLocation, kind::Integer, src_mgr::AbstractSourceManager, opts::AbstractLangOptions, skip_trailing_whitespace_and_newline::Bool=false)
    @check_ptrs src_mgr opts
    @assert isValid(loc) "loc must be a valid location"
    return SourceLocation(clang_Lexer_findLocationAfterToken(loc, kind, src_mgr, opts, skip_trailing_whitespace_and_newline))
end

"""
    isAsciiIdentifierContinueChar(c::Char, opts::AbstractLangOptions) -> Bool
Return whether `c` may appear after the first character of an identifier under `opts`.

`c` must be ASCII: the parameter is a plain `char`, whose signedness is
implementation-defined, and the classification covers only ASCII.
"""
function isAsciiIdentifierContinueChar(c::Char, opts::AbstractLangOptions)
    @check_ptrs opts
    @assert isascii(c) "c must be an ASCII character"
    return clang_Lexer_isAsciiIdentifierContinueChar(c, opts)
end
