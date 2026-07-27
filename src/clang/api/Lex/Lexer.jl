# Lexer
"""
    Lexer(fid::FileID, buffer::LLVM.MemoryBuffer, src_mgr::SourceManager, opts::LangOptions) -> Lexer
Create a raw lexer that relexes `buffer` as the file `fid` of `src_mgr`.

The lexer borrows the buffer, the source manager, and the language options, so all of them
must outlive it. This function allocates and one should call `dispose` to release the
resources after using this object.
"""
function Lexer(fid::FileID, buffer::LLVM.MemoryBuffer, src_mgr::SourceManager,
               opts::LangOptions)
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
function getSpelling(tok::AbstractToken, src_mgr::AbstractSourceManager,
                     opts::AbstractLangOptions)
    @check_ptrs tok src_mgr opts
    return get_string(clang_Lexer_getSpelling(tok, src_mgr, opts))
end

function MeasureTokenLength(loc::SourceLocation, src_mgr::AbstractSourceManager,
                            opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return clang_Lexer_MeasureTokenLength(loc, src_mgr, opts)
end

"""
    getRawToken(loc, result, src_mgr, opts, ignore_whitespace=false) -> Bool
Relex the token at `loc` into `result`. Return `true` if there was a failure, `false` on
success (mirroring `clang::Lexer::getRawToken`).
"""
function getRawToken(loc::SourceLocation, result::AbstractToken,
                     src_mgr::AbstractSourceManager, opts::AbstractLangOptions,
                     ignore_whitespace::Bool=false)
    @check_ptrs result src_mgr opts
    return clang_Lexer_getRawToken(loc, result, src_mgr, opts, ignore_whitespace)
end

function GetBeginningOfToken(loc::SourceLocation, src_mgr::AbstractSourceManager,
                             opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return SourceLocation(clang_Lexer_GetBeginningOfToken(loc, src_mgr, opts))
end

function getLocForEndOfToken(loc::SourceLocation, offset::Integer,
                             src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    return SourceLocation(clang_Lexer_getLocForEndOfToken(loc, offset, src_mgr, opts))
end

"""
    isAtStartOfMacroExpansion(loc, src_mgr, opts) -> Union{SourceLocation,Nothing}
Return the begin location of the macro when the macro location `loc` points at the first
token of its expansion, `nothing` otherwise.
"""
function isAtStartOfMacroExpansion(loc::SourceLocation, src_mgr::AbstractSourceManager,
                                   opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Lexer_isAtStartOfMacroExpansion(loc, src_mgr, opts, out) ?
           SourceLocation(out[]) : nothing
end

"""
    isAtEndOfMacroExpansion(loc, src_mgr, opts) -> Union{SourceLocation,Nothing}
Return the end location of the macro when the macro location `loc` points at the last
token of its expansion, `nothing` otherwise.
"""
function isAtEndOfMacroExpansion(loc::SourceLocation, src_mgr::AbstractSourceManager,
                                 opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Lexer_isAtEndOfMacroExpansion(loc, src_mgr, opts, out) ?
           SourceLocation(out[]) : nothing
end

function getSourceText(r::SourceRange, is_token_range::Bool,
                       src_mgr::AbstractSourceManager, opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    range = CXSourceRange_(r.begin_loc.ptr, r.end_loc.ptr)
    return get_string(clang_Lexer_getSourceText(range, is_token_range, src_mgr, opts))
end

function getImmediateMacroName(loc::SourceLocation, src_mgr::AbstractSourceManager,
                               opts::AbstractLangOptions)
    @check_ptrs src_mgr opts
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    return get_string(clang_Lexer_getImmediateMacroName(loc, src_mgr, opts))
end

"""
    findNextToken(loc, src_mgr, opts, result) -> Bool
Fill `result` with the token that comes right after `loc` and return `true`; return
`false` (leaving `result` untouched) when the location is inside a macro.
"""
function findNextToken(loc::SourceLocation, src_mgr::AbstractSourceManager,
                       opts::AbstractLangOptions, result::AbstractToken)
    @check_ptrs src_mgr opts result
    return clang_Lexer_findNextToken(loc, src_mgr, opts, result)
end
