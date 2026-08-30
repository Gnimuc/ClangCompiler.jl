using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Lex batch: token/macro/preprocessor/lexer surface" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)

    # Preprocessor accessors: each interior handle is the instance's own, not a copy
    @test CC.getDiagnostics(pp).ptr == CC.getDiagnostics(ci).ptr
    @test CC.getLangOpts(pp).ptr == CC.getLangOpts(ci).ptr
    @test CC.getTargetInfo(pp).ptr == CC.getTarget(ci).ptr
    @test CC.getFileManager(pp).ptr == CC.getFileManager(ci).ptr
    @test CC.getSourceManager(pp).ptr == CC.getSourceManager(ci).ptr
    @test !CC.is_null_handle(CC.getIdentifierTable(pp))
    @test !(CC.getCommentRetentionState(pp))
    CC.SetCommentRetentionState(pp, false, false)
    @test !CC.getCommentRetentionState(pp)
    @test CC.getPragmasEnabled(pp)
    CC.setPragmasEnabled(pp, true)
    @test !isempty(CC.getPredefines(pp))

    CC.parse(I, """
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
    mi_obj = CC.getMacroInfo(pp, ii_obj)

    # MacroInfo read surface (object-like)
    @test CC.isObjectLike(mi_obj)
    @test !CC.isFunctionLike(mi_obj)
    @test !CC.isVariadic(mi_obj)
    @test !CC.isC99Varargs(mi_obj) && !CC.isGNUVarargs(mi_obj)
    @test !CC.isBuiltinMacro(mi_obj)
    @test !CC.hasCommaPasting(mi_obj)
    @test CC.isEnabled(mi_obj)
    @test CC.isUsed(mi_obj)
    @test !(CC.isAllowRedefinitionsWithoutWarning(mi_obj))
    @test !(CC.isWarnIfUnused(mi_obj))
    @test !(CC.isUsedForHeaderGuard(mi_obj))
    @test CC.param_empty(mi_obj)
    @test CC.getNumParams(mi_obj) == 0
    @test CC.getNumTokens(mi_obj) == 1

    # Token read surface on a borrowed replacement token
    tok42 = CC.getReplacementToken(mi_obj, 0)
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
    @test !(CC.hasLeadingSpace(tok42))
    @test !CC.isAtStartOfLine(tok42)
    @test CC.getFlag(tok42, CC.LibClangEx.CXTokenFlags_LeadingSpace) == CC.hasLeadingSpace(tok42)
    @test !CC.getFlag(tok42, CC.LibClangEx.CXTokenFlags_NeedsCleaning)
    @test !CC.isExpandDisabled(tok42) && !CC.needsCleaning(tok42)
    @test !CC.hasLeadingEmptyMacro(tok42) && !CC.hasUDSuffix(tok42) && !CC.hasUCN(tok42)
    @test !CC.stringifiedInMacro(tok42) && !CC.commaAfterElided(tok42)
    @test !CC.isEditorPlaceholder(tok42)
    @test CC.hasPtrData(tok42)
    @test CC.isValid(CC.getLocation(tok42))
    @test CC.isValid(CC.getEndLoc(tok42))
    @test CC.isValid(CC.getLastLoc(tok42))

    # MacroInfo read surface (function-like) + params count+index
    ii_fn = CC.getIdentifierInfo(pp, "CC_LEX_FN")
    mi_fn = CC.getMacroInfo(pp, ii_fn)
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
    @test CC.getDefinitionLength(mi_fn, sm) > 0

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
    @test !(CC.inKeepCommentMode(lex))
    @test CC.isFirstTimeLexingFile(lex)
    @test CC.isValid(CC.getFileLoc(lex))
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

@testset "Macro directive history and macro/token mutators" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)

    CC.parse(I, """
                #define CC_MDIR_OBJ 7
                #define CC_MDIR_H 1
                #undef CC_MDIR_H
                #define CC_MDIR_H 2
                int cc_mdir_probe = CC_MDIR_OBJ + CC_MDIR_H;
                """)

    # MacroDirective on a plain single #define
    ii = CC.getIdentifierInfo(pp, "CC_MDIR_OBJ")
    md = CC.getLocalMacroDirective(pp, ii)
    @test CC.getKind(md) == CC.LibClangEx.CXMacroDirectiveKind_MD_Define
    @test CC.isDefined(md)
    @test !(CC.isFromPCH(md))
    @test CC.isValid(CC.getLocation(md))
    @test CC.getPrevious(md).ptr == C_NULL
    mi = CC.getMacroInfo(md)
    @test mi.ptr == CC.getMacroInfo(pp, ii).ptr

    # walking a #define / #undef / #define history backwards
    ii_h = CC.getIdentifierInfo(pp, "CC_MDIR_H")
    md_h = CC.getLocalMacroDirective(pp, ii_h)
    @test md_h.ptr != C_NULL
    @test CC.getKind(md_h) == CC.LibClangEx.CXMacroDirectiveKind_MD_Define
    @test CC.isDefined(md_h)
    undef_md = CC.getPrevious(md_h)
    @test undef_md.ptr != C_NULL
    @test CC.getKind(undef_md) == CC.LibClangEx.CXMacroDirectiveKind_MD_Undefine
    @test !CC.isDefined(undef_md)
    first_def = CC.getPrevious(undef_md)
    @test first_def.ptr != C_NULL
    @test CC.getKind(first_def) == CC.LibClangEx.CXMacroDirectiveKind_MD_Define
    @test CC.isDefined(first_def)
    # an #undef still resolves to the definition it cancelled
    @test CC.getMacroInfo(undef_md).ptr == CC.getMacroInfo(first_def).ptr
    @test CC.getMacroInfo(md_h).ptr != CC.getMacroInfo(first_def).ptr
    @test CC.getPrevious(first_def).ptr == C_NULL

    # MacroInfo mutators, on a preprocessor-owned macro attached to no identifier
    loc = CC.getDefinitionLoc(mi)
    fresh = CC.AllocateMacroInfo(pp, loc)
    @test CC.tokens_empty(fresh)
    @test !CC.tokens_empty(mi)
    CC.setDefinitionEndLoc(fresh, loc)
    @test CC.getDefinitionEndLoc(fresh).ptr == loc.ptr
    CC.setIsBuiltinMacro(fresh, true)
    @test CC.isBuiltinMacro(fresh)
    CC.setIsBuiltinMacro(fresh, false)
    @test !CC.isBuiltinMacro(fresh)
    CC.setIsUsed(fresh, true)
    @test CC.isUsed(fresh)
    CC.setIsUsed(fresh, false)
    @test !CC.isUsed(fresh)
    CC.setIsAllowRedefinitionsWithoutWarning(fresh, true)
    @test CC.isAllowRedefinitionsWithoutWarning(fresh)
    CC.setIsAllowRedefinitionsWithoutWarning(fresh, false)
    @test !CC.isAllowRedefinitionsWithoutWarning(fresh)
    CC.setIsWarnIfUnused(fresh, true)
    @test CC.isWarnIfUnused(fresh)
    CC.setIsWarnIfUnused(fresh, false)
    @test !CC.isWarnIfUnused(fresh)
    CC.setUsedForHeaderGuard(fresh, true)
    @test CC.isUsedForHeaderGuard(fresh)
    CC.setUsedForHeaderGuard(fresh, false)
    @test !CC.isUsedForHeaderGuard(fresh)
    @test CC.isEnabled(fresh)
    CC.DisableMacro(fresh)
    @test !CC.isEnabled(fresh)
    CC.EnableMacro(fresh)
    @test CC.isEnabled(fresh)

    # Token mutators, on a caller-owned token
    tk = CC.Token()
    CC.setIdentifierInfo(tk, ii)
    @test CC.getIdentifierInfo(tk).ptr == ii.ptr
    CC.setLocation(tk, loc)
    @test CC.getLocation(tk).ptr == loc.ptr
    CC.setLength(tk, 11)
    @test CC.getLength(tk) == 11
    CC.setFlag(tk, CC.LibClangEx.CXTokenFlags_LeadingSpace)
    @test CC.hasLeadingSpace(tk)
    CC.clearFlag(tk, CC.LibClangEx.CXTokenFlags_LeadingSpace)
    @test !CC.hasLeadingSpace(tk)

    # the kind round-trips as the raw tok::TokenKind value carried by another token
    lit = CC.getReplacementToken(mi, 0)
    @test CC.isLiteral(lit)
    ld = CC.getLiteralData(lit)
    @test ld == "7"
    k = CC.getKind(lit)
    CC.setKind(tk, k)
    @test CC.getKind(tk) == k
    @test CC.isLiteral(tk)

    dispose(tk)
    dispose(I)
end

@testset "Macro definition history and macro build-time flags" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    sm = CC.getSourceManager(pp)

    CC.parse(I, """
                #define CC_DEFINFO_A 1
                #undef CC_DEFINFO_A
                #define CC_DEFINFO_A 2
                int cc_definfo_probe = CC_DEFINFO_A;
                """)
    f = DeclFinder(I)
    @test f(I, "cc_definfo_probe")
    dispose(f)

    ii = CC.getIdentifierInfo(pp, "CC_DEFINFO_A")
    md = CC.getLocalMacroDirective(pp, ii)
    @test md.ptr != C_NULL

    # the boxed definition the newest directive resolves to
    def = CC.getDefinition(md)
    @test CC.isValid(def)
    @test !CC.isInvalid(def)
    @test !CC.isUndefined(def)
    @test !CC.isValid(CC.getUndefLocation(def))
    @test CC.isValid(CC.getLocation(def))
    @test CC.isPublic(def)
    dmd = CC.getDirective(def)
    @test dmd.ptr == md.ptr  # the newest directive is itself the active #define
    @test CC.getKind(dmd) == CC.LibClangEx.CXMacroDirectiveKind_MD_Define
    mi = CC.getMacroInfo(def)
    @test CC.getInfo(dmd).ptr == mi.ptr
    @test CC.getMacroInfo(md).ptr == mi.ptr

    # stepping back reaches the definition the #undef cancelled
    prev = CC.getPreviousDefinition(def)
    @test CC.isValid(prev)
    @test CC.isUndefined(prev)
    @test CC.isValid(CC.getUndefLocation(prev))
    @test CC.getMacroInfo(prev).ptr != mi.ptr
    @test CC.getDirective(prev).ptr != C_NULL

    # and once more runs the history out
    oldest = CC.getPreviousDefinition(prev)
    @test CC.isInvalid(oldest)
    @test !CC.isValid(oldest)
    @test CC.getDirective(oldest).ptr == C_NULL
    @test CC.getMacroInfo(oldest).ptr == C_NULL
    @test !CC.isValid(CC.getLocation(oldest))
    dispose(oldest)
    dispose(prev)

    # a location query returns a box either way; which definition it lands on depends on
    # how the host laid the snippet out in the source manager, so assert the shape
    at = CC.findDirectiveAtLoc(md, CC.getDefinitionLoc(mi), sm)
    @test !(CC.isValid(at))
    dispose(at)
    @test_throws AssertionError CC.findDirectiveAtLoc(md, CC.SourceLocation(), sm)

    dispose(def)

    @test CC.dump(md) === nothing  # writes the directive history to stderr

    # history mutators: setPrevious restores the link the chain already holds
    undef_md = CC.getPrevious(md)
    @test undef_md.ptr != C_NULL
    CC.setPrevious(md, undef_md)
    @test CC.getPrevious(md).ptr == undef_md.ptr

    # setIsFromPCH is one-way, so only the post-state is assertable
    first_def = CC.getPrevious(undef_md)
    @test first_def.ptr != C_NULL
    @test !(CC.isFromPCH(first_def))
    CC.setIsFromPCH(first_def)
    @test CC.isFromPCH(first_def)

    # MacroInfo build-time flags, on a fresh macro attached to no identifier
    fresh = CC.AllocateMacroInfo(pp, CC.getDefinitionLoc(mi))
    @test CC.isObjectLike(fresh)
    CC.setIsFunctionLike(fresh)
    @test CC.isFunctionLike(fresh)
    @test !CC.isObjectLike(fresh)
    @test !CC.isVariadic(fresh)
    CC.setIsC99Varargs(fresh)
    @test CC.isC99Varargs(fresh)
    @test CC.isVariadic(fresh)
    @test !CC.isGNUVarargs(fresh)
    CC.setIsGNUVarargs(fresh)
    @test CC.isGNUVarargs(fresh)
    @test !CC.hasCommaPasting(fresh)
    CC.setHasCommaPasting(fresh)
    @test CC.hasCommaPasting(fresh)

    dispose(I)
end
