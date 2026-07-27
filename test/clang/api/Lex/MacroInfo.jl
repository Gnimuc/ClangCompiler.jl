using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Lex batch: token/macro/preprocessor/lexer surface" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)

    # Preprocessor accessors
    @test CC.getDiagnostics(pp) isa CC.DiagnosticsEngine
    @test CC.getLangOpts(pp) isa CC.LangOptions
    @test CC.getTargetInfo(pp) isa CC.TargetInfo
    @test CC.getFileManager(pp) isa CC.FileManager
    @test CC.getSourceManager(pp) isa CC.SourceManager
    @test CC.getIdentifierTable(pp) isa CC.IdentifierTable
    @test CC.getCommentRetentionState(pp) isa Bool
    CC.SetCommentRetentionState(pp, false, false)
    @test !CC.getCommentRetentionState(pp)
    @test CC.getPragmasEnabled(pp)
    CC.setPragmasEnabled(pp, true)
    @test CC.getTokenCount(pp) isa Unsigned
    @test CC.getMaxTokens(pp) isa Unsigned
    @test !isempty(CC.getPredefines(pp))
    predefines_fid = CC.getPredefinesFileID(pp)
    @test predefines_fid isa CC.FileID
    dispose(predefines_fid)

    CC.parse(I,
             """
             #define CC_LEX_OBJ 42
             #define CC_LEX_FN(a, b) a + b
             int cc_lex_dummy = CC_LEX_OBJ;
             """)
    f = DeclFinder(I)
    @test f(I, "cc_lex_dummy")
    dispose(f)

    # macro lookup
    @test CC.isMacroDefined(pp, "CC_LEX_OBJ")
    @test CC.isMacroDefined(pp, "CC_LEX_FN")
    @test !CC.isMacroDefined(pp, "CC_LEX_NOT_DEFINED")
    ii_obj = CC.getIdentifierInfo(pp, "CC_LEX_OBJ")
    @test ii_obj isa CC.IdentifierInfo
    mi_obj = CC.getMacroInfo(pp, ii_obj)
    @test mi_obj isa CC.MacroInfo
    @test mi_obj.ptr != C_NULL

    # MacroInfo read surface (object-like)
    @test CC.isObjectLike(mi_obj)
    @test !CC.isFunctionLike(mi_obj)
    @test !CC.isVariadic(mi_obj)
    @test !CC.isC99Varargs(mi_obj) && !CC.isGNUVarargs(mi_obj)
    @test !CC.isBuiltinMacro(mi_obj)
    @test !CC.hasCommaPasting(mi_obj)
    @test CC.isEnabled(mi_obj)
    @test CC.isUsed(mi_obj) isa Bool
    @test CC.isAllowRedefinitionsWithoutWarning(mi_obj) isa Bool
    @test CC.isWarnIfUnused(mi_obj) isa Bool
    @test CC.isUsedForHeaderGuard(mi_obj) isa Bool
    @test CC.param_empty(mi_obj)
    @test CC.getNumParams(mi_obj) == 0
    @test CC.getNumTokens(mi_obj) == 1

    # Token read surface on a borrowed replacement token
    tok42 = CC.getReplacementToken(mi_obj, 0)
    @test tok42 isa CC.Token
    @test CC.isLiteral(tok42)
    @test CC.is_numeric_constant(tok42)
    @test !CC.isAnnotation(tok42)
    @test !CC.isAnyIdentifier(tok42)
    @test !CC.isRegularKeywordAttribute(tok42)
    @test CC.getLength(tok42) == 2
    @test CC.getSpelling(pp, tok42) == "42"
    k = CC.getKind(tok42)
    @test CC.is(tok42, k)
    @test !CC.isNot(tok42, k)
    # whether the definition records a leading space on the replacement token
    # is a lexer detail — assert flag/predicate consistency, not the value
    @test CC.hasLeadingSpace(tok42) isa Bool
    @test !CC.isAtStartOfLine(tok42)
    @test CC.getFlag(tok42, CC.LibClangEx.CXTokenFlags_LeadingSpace) ==
          CC.hasLeadingSpace(tok42)
    @test !CC.getFlag(tok42, CC.LibClangEx.CXTokenFlags_NeedsCleaning)
    @test CC.getFlags(tok42) isa Unsigned
    @test !CC.isExpandDisabled(tok42) && !CC.needsCleaning(tok42)
    @test !CC.hasLeadingEmptyMacro(tok42) && !CC.hasUDSuffix(tok42) && !CC.hasUCN(tok42)
    @test !CC.stringifiedInMacro(tok42) && !CC.commaAfterElided(tok42)
    @test !CC.isEditorPlaceholder(tok42)
    @test CC.hasPtrData(tok42) isa Bool
    @test CC.isValid(CC.getLocation(tok42))
    @test CC.getEndLoc(tok42) isa CC.SourceLocation
    @test CC.getLastLoc(tok42) isa CC.SourceLocation

    # MacroInfo read surface (function-like) + params count+index
    ii_fn = CC.getIdentifierInfo(pp, "CC_LEX_FN")
    mi_fn = CC.getMacroInfo(pp, ii_fn)
    @test mi_fn.ptr != C_NULL
    @test CC.isFunctionLike(mi_fn)
    @test !CC.isObjectLike(mi_fn)
    @test !CC.param_empty(mi_fn)
    @test CC.getNumParams(mi_fn) == 2
    pa = CC.getParam(mi_fn, 0)
    pb = CC.getParam(mi_fn, 1)
    @test CC.getName(pa) == "a"
    @test CC.getName(pb) == "b"
    @test CC.getParameterNum(mi_fn, pa) == 0
    @test CC.getParameterNum(mi_fn, pb) == 1
    @test CC.getParameterNum(mi_fn, ii_fn) == -1
    @test CC.getNumTokens(mi_fn) == 3
    @test CC.isIdenticalTo(mi_fn, mi_fn, pp, true)
    @test !CC.isIdenticalTo(mi_fn, mi_obj, pp, true)

    sm = CC.getSourceManager(pp)
    lo = CC.getLangOpts(pp)
    defloc = CC.getDefinitionLoc(mi_fn)
    @test CC.isValid(defloc)
    @test CC.isValid(CC.getDefinitionEndLoc(mi_fn))
    @test CC.getDefinitionLength(mi_fn, sm) isa Unsigned

    # Lexer static utilities
    @test CC.MeasureTokenLength(defloc, sm, lo) == length("CC_LEX_FN")
    @test CC.GetBeginningOfToken(defloc, sm, lo).ptr == defloc.ptr
    @test CC.isValid(CC.getLocForEndOfToken(defloc, 0, sm, lo))
    @test CC.getSpelling(tok42, sm, lo) == "42"
    r = CC.SourceRange(defloc, defloc)
    @test CC.getSourceText(r, true, sm, lo) == "CC_LEX_FN"

    tknext = CC.Token()
    @test CC.findNextToken(defloc, sm, lo, tknext)
    @test CC.getSpelling(pp, tknext) == "("
    CC.startToken(tknext)
    @test !CC.getRawToken(defloc, tknext, sm, lo)  # false means success
    @test CC.is_raw_identifier(tknext)
    @test CC.isAnyIdentifier(tknext)
    @test CC.getRawIdentifier(tknext) == "CC_LEX_FN"
    dispose(tknext)

    dispose(I)

    # raw-lexer instance surface on throwaway state
    ci2 = CC.CompilerInstance()
    lang_opts = CC.getLangOpts(ci2)
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    sm2 = CC.SourceManager(fm, diag)
    code = "int cc_lex_probe = 42;"
    fid_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbatch", true)
    fid = CC.FileID(sm2, fid_buf)  # the source manager takes ownership of this buffer
    lex_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbatch", true)
    lex = CC.Lexer(fid, lex_buf, sm2, lang_opts)
    @test !CC.isPragmaLexer(lex)
    @test !CC.isKeepWhitespaceMode(lex)
    @test CC.inKeepCommentMode(lex) isa Bool
    @test CC.isFirstTimeLexingFile(lex) isa Bool
    @test CC.getFileLoc(lex) isa CC.SourceLocation
    CC.SetCommentRetentionState(lex, true)
    @test CC.inKeepCommentMode(lex)
    CC.SetCommentRetentionState(lex, false)
    CC.SetKeepWhitespaceMode(lex, true)
    @test CC.isKeepWhitespaceMode(lex)
    CC.SetKeepWhitespaceMode(lex, false)
    @test CC.getCurrentBufferOffset(lex) == 0
    tk = CC.Token()
    CC.LexFromRawLexer(lex, tk)
    @test CC.is_raw_identifier(tk)
    @test CC.getRawIdentifier(tk) == "int"
    @test CC.getLength(tk) == 3
    @test CC.isAtStartOfLine(tk)
    @test !CC.hasLeadingSpace(tk)
    @test CC.getCurrentBufferOffset(lex) >= 3
    CC.startToken(tk)
    CC.LexFromRawLexer(lex, tk)
    @test CC.getRawIdentifier(tk) == "cc_lex_probe"
    dispose(tk)
    dispose(lex)
    CC.LLVM.dispose(lex_buf)  # the lexer only borrowed it
    dispose(fid)
    dispose(sm2)
    dispose(fm)
    dispose(diag)
    dispose(ci2)
end
