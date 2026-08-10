using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# `getCurrentLexer` already handed this out; here it is finally asked something. The
# preprocessor is a throwaway one built by hand, because the questions below are answered
# by whichever file the preprocessor is lexing right now and a live interpreter's stream
# must not be consumed.

@testset "PreprocessorLexer | what the current lexer knows" begin
    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)
    CC.createFileManager(ci)
    CC.createSourceManager(ci, CC.getFileManager(ci))
    topts = CC.TargetOptions()
    CC.setTriple(topts, "x86_64-unknown-linux-gnu")
    CC.setTarget(ci, CC.TargetInfo(topts, CC.getDiagnostics(ci)))  # absorbs topts
    CC.createPreprocessor(ci)

    pp = CC.getPreprocessor(ci)
    sm = CC.getSourceManager(ci)

    code = "<probe_header.h>\n"
    buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "pplexer-probe", true)
    fid = CC.FileID(sm, buf)      # the source manager takes ownership of the buffer
    CC.EnterSourceFile(pp, fid)

    lexer = CC.getCurrentFileLexer(pp)
    @test !CC.is_null_handle(lexer)
    # the lexer is driven by exactly the preprocessor we pushed it onto
    @test CC.getPP(lexer).ptr == pp.ptr
    @test CC.isLexingRawMode(lexer) == false

    # and it is lexing exactly the buffer we entered
    lfid = CC.getFileID(lexer)
    @test CC.getHashValue(lfid) == CC.getHashValue(fid)
    dispose(lfid)

    # a memory buffer has no file behind it, so there is no FileEntry to hand back
    @test CC.is_null_handle(CC.getFileEntry(lexer))

    # the source manager already held this buffer's entry when the lexer was built
    @test CC.getInitialNumSLocEntries(lexer) >= 1

    # nothing conditional has been lexed, so the stack is empty -- asserted as the empty
    # case rather than left to a loop that would not run
    @test CC.getNumConditionals(lexer) == 0
    @test isempty(CC.getConditionalStack(lexer))

    # header-name mode: `<probe_header.h>` is one token here and a run of punctuators
    # anywhere else, which is the whole reason this entry point exists
    tok = CC.Token()
    CC.LexIncludeFilename(lexer, tok)
    @test CC.getName(tok) == "header_name"
    @test CC.getSpelling(pp, tok) == "<probe_header.h>"
    dispose(tok)

    dispose(fid)
    dispose(ci)
end
