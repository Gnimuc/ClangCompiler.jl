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
