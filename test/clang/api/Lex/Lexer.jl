using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "raw lexer lifecycle" begin
    ci = CC.CompilerInstance()  # only used as the provider of default language options
    lang_opts = CC.getLangOpts(ci)
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)
    code = "int lexer_probe = 1;"
    fid_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    fid = CC.FileID(sm, fid_buf)  # the source manager takes ownership of this buffer
    lex_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    lex = CC.Lexer(fid, lex_buf, sm, lang_opts)
    @test lex isa CC.Lexer
    @test lex.ptr != C_NULL
    dispose(lex)
    CC.LLVM.dispose(lex_buf)  # the lexer only borrowed it
    dispose(fid)
    dispose(sm)
    dispose(fm)
    dispose(diag)
    dispose(ci)
end
