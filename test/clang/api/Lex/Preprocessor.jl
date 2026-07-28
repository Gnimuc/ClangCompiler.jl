using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "preprocessor includes round-trip" begin
    I = create_interpreter(["-include", "cstddef"])
    ppo = CC.getPreprocessorOpts(get_instance(I))
    incs = CC.getIncludes(ppo)
    @test incs isa Vector{String}
    @test "cstddef" in incs
    dispose(I)
end

@testset "preprocessor state, counters and backtracking" begin
    I = create_interpreter(["-include", "cstddef"])
    pp = CC.getPreprocessor(get_instance(I))

    @test !CC.is_null_handle(CC.getPreprocessorOpts(pp))
    @test CC.getNumDirectives(pp) isa Integer  # shape-only: the target chooses this value
    @test CC.isParsingIfOrElifDirective(pp) == false
    @test !(CC.isPreprocessedOutput(pp))
    @test CC.isInPrimaryFile(pp)
    @test !(CC.SawDateOrTime(pp))
    @test CC.getTotalMemory(pp) isa Integer  # shape-only: the target chooses this value
    @test CC.getTotalMemory(pp) > 0
    @test CC.isInNamedModule(pp) == false

    # preprocessed-output flag round-trip
    old_ppo = CC.isPreprocessedOutput(pp)
    CC.setPreprocessedOutput(pp, !old_ppo)
    @test CC.isPreprocessedOutput(pp) == !old_ppo
    CC.setPreprocessedOutput(pp, old_ppo)
    @test CC.isPreprocessedOutput(pp) == old_ppo

    # __COUNTER__ round-trip
    old_counter = CC.getCounterValue(pp)
    CC.setCounterValue(pp, 42)
    @test CC.getCounterValue(pp) == 42
    CC.setCounterValue(pp, old_counter)
    @test CC.getCounterValue(pp) == old_counter

    # -Wmax-tokens override round-trip
    old_max = CC.getMaxTokens(pp)
    old_loc = CC.getMaxTokensOverrideLoc(pp)
    @test old_loc isa CC.SourceLocation
    CC.overrideMaxTokens(pp, 4096, CC.SourceLocation())
    @test CC.getMaxTokens(pp) == 4096
    CC.overrideMaxTokens(pp, old_max, old_loc)
    @test CC.getMaxTokens(pp) == old_max

    # macro lookup at a location; the invalid-location precondition is guarded in Julia
    ii = CC.getIdentifierInfo(pp, "__cplusplus")
    @test ii isa CC.IdentifierInfo
    @test_throws AssertionError CC.getMacroInfoAtLoc(pp, ii, CC.SourceLocation())
    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)
    if CC.isValid(loc)
        @test CC.is_null_handle(CC.getMacroInfoAtLoc(pp, ii, loc))
    end
    CC.dispose(fid)

    # the named-module name is only reachable from inside a named module
    @test_throws AssertionError CC.getNamedModuleName(pp)

    # backtracking: an unbalanced commit/backtrack is rejected before the ccall
    @test CC.isBacktrackEnabled(pp) == false
    @test_throws AssertionError CC.CommitBacktrackedTokens(pp)
    @test_throws AssertionError CC.Backtrack(pp)
    CC.EnableBacktrackAtThisPos(pp)
    @test CC.isBacktrackEnabled(pp) == true
    CC.CommitBacktrackedTokens(pp)
    @test CC.isBacktrackEnabled(pp) == false

    # one-way switch: keep it last, the interpreter is disposed right after
    CC.SetMacroExpansionOnlyInDirectives(pp)
    dispose(I)
end

@testset "preprocessor lexing, code completion and module state" begin
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # module-loader and PCH-mode state: shape only, the driver configuration decides these
    @test !(CC.hadModuleLoaderFatalFailure(pp))
    @test !(CC.creatingPCHWithThroughHeader(pp))
    @test !(CC.usingPCHWithThroughHeader(pp))
    @test !(CC.creatingPCHWithPragmaHdrStop(pp))
    @test !(CC.usingPCHWithPragmaHdrStop(pp))

    # missing-#include suppression round-trip
    old_suppress = CC.GetSuppressIncludeNotFoundError(pp)
    @test old_suppress isa Bool
    CC.SetSuppressIncludeNotFoundError(pp, !old_suppress)
    @test CC.GetSuppressIncludeNotFoundError(pp) == !old_suppress
    CC.SetSuppressIncludeNotFoundError(pp, old_suppress)
    @test CC.GetSuppressIncludeNotFoundError(pp) == old_suppress

    # no code-completion point was requested, so the whole family stays unset
    @test CC.isCodeCompletionEnabled(pp) == false
    @test CC.isCodeCompletionReached(pp) == false
    @test CC.is_null_handle(CC.getCodeCompletionLoc(pp))
    @test CC.isValid(CC.getCodeCompletionLoc(pp)) == false
    @test CC.is_null_handle(CC.getCodeCompletionFileLoc(pp))
    @test CC.isValid(CC.getCodeCompletionFileLoc(pp)) == false

    # the interpreter compiles a plain translation unit, not a C++20 module
    @test CC.is_null_handle(CC.getCurrentModule(pp))
    @test CC.is_null_handle(CC.getCurrentModuleImplementation(pp))
    @test CC.isInNamedInterfaceUnit(pp) == false
    @test CC.isInImplementationUnit(pp) == false

    # relex off the preprocessor's own source manager and language options
    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)
    if CC.isValid(loc)
        tok = CC.Token()
        @test !(CC.getRawToken(pp, loc, tok))
        @test !CC.is_null_handle(CC.getLocForEndOfToken(pp, loc))
        @test !CC.is_null_handle(CC.getLocForEndOfToken(pp, loc, 1))
        dispose(tok)
    end
    CC.dispose(fid)
    dispose(I)

    # manual lexing consumes the live token stream: run it on a throwaway interpreter,
    # inside a backtracking scope that rewinds, and dispose immediately afterwards
    J = create_interpreter()
    ppj = CC.getPreprocessor(get_instance(J))
    tok = CC.Token()
    CC.EnableBacktrackAtThisPos(ppj)
    CC.LexNonComment(ppj, tok)
    @test CC.getKind(tok) isa Integer
    CC.LexUnexpandedToken(ppj, tok)
    @test CC.getKind(tok) isa Integer
    CC.LexUnexpandedNonComment(ppj, tok)
    @test CC.getKind(tok) isa Integer
    CC.Backtrack(ppj)
    dispose(tok)
    dispose(J)
end

@testset "preprocessor pragma/preamble/module query tails" begin
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # pure preamble / safe-buffer / module state — shape only, the driver decides these
    @test !(CC.isRecordingPreamble(pp))
    @test !(CC.hasRecordedPreamble(pp))
    @test !(CC.isPPInSafeBufferOptOutRegion(pp))
    @test CC.isInImportingCXXNamedModules(pp) == false
    @test CC.mightHavePendingAnnotationTokens(pp)

    # pragma-location accessors are invalid outside their pragma regions
    @test CC.is_null_handle(CC.getPragmaAssumeNonNullLoc(pp))
    @test CC.isValid(CC.getPragmaAssumeNonNullLoc(pp)) == false
    @test CC.is_null_handle(CC.getPreambleRecordedPragmaAssumeNonNullLoc(pp))
    @test CC.is_null_handle(CC.getLastFPEvalPragmaLocation(pp))

    # aux target and current-lexer submodule are borrowed and NULL for a single-target,
    # non-modular translation unit
    @test CC.getAuxTargetInfo(pp) isa CC.TargetInfo  # shape-only: the host decides this
    @test CC.is_null_handle(CC.getCurrentLexerSubmodule(pp))

    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)

    # pragma-assume-nonnull location round-trips through the setter
    old_nonnull = CC.getPragmaAssumeNonNullLoc(pp)
    @test CC.isValid(old_nonnull) == false
    if CC.isValid(loc)
        CC.setPragmaAssumeNonNullLoc(pp, loc)
        @test CC.isValid(CC.getPragmaAssumeNonNullLoc(pp)) == true
        CC.setPragmaAssumeNonNullLoc(pp, old_nonnull)
        @test CC.isValid(CC.getPragmaAssumeNonNullLoc(pp)) == false

        # code-completion token range round-trips through the setter
        CC.setCodeCompletionTokenRange(pp, loc, loc)
        rng = CC.getCodeCompletionTokenRange(pp)
        @test rng isa CC.SourceRange
        @test CC.isValid(rng.begin_loc) == true

        # advancing to the first character of the predefines token stays a valid location
        @test !CC.is_null_handle(CC.AdvanceToTokenCharacter(pp, loc, 0))
        # clang walks the token with `isObviouslySimpleCharacter`, which is true of a NUL,
        # so an index past the token reads off the end of the buffer rather than stopping.
        # The length is measured and the index refused.
        tok_len = CC.MeasureTokenLength(loc, CC.getSourceManager(pp), CC.getLangOpts(pp))
        @test tok_len isa Integer
        @test !CC.is_null_handle(CC.AdvanceToTokenCharacter(pp, loc, tok_len))
        @test_throws AssertionError CC.AdvanceToTokenCharacter(pp, loc, tok_len + 1)
        @test_throws AssertionError CC.AdvanceToTokenCharacter(pp, loc, -1)
        @test_throws AssertionError CC.AdvanceToTokenCharacter(pp, CC.SourceLocation(), 0)

        # a location in the predefines buffer is outside any module → borrowed NULL carrier
        @test CC.is_null_handle(CC.getModuleForLocation(pp, loc, false))
        @test CC.is_null_handle(CC.getModuleForLocation(pp, loc, true))
    end

    # macro-loc forwarders reject a non-macro location before the ccall
    @test_throws AssertionError CC.getImmediateMacroName(pp, CC.SourceLocation())
    @test_throws AssertionError CC.isAtStartOfMacroExpansion(pp, CC.SourceLocation())
    @test_throws AssertionError CC.isAtEndOfMacroExpansion(pp, CC.SourceLocation())

    CC.dispose(fid)
    dispose(I)
end

@testset "preprocessor macro-arena, paste/preamble and safe-buffer regions" begin
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # arena-allocated MacroInfo: borrowed (never disposed), marked used with no read-back getter
    mi = CC.AllocateMacroInfo(pp)
    @test mi isa CC.MacroInfo
    @test CC.markMacroAsUsed(pp, mi) === nothing
    mi2 = CC.AllocateMacroInfo(pp, CC.SourceLocation())
    @test mi2 isa CC.MacroInfo

    # plain flag/counter/state setters: they return nothing and must not throw
    @test CC.setPreprocessToken(pp, true) === nothing
    @test CC.setPreprocessToken(pp, false) === nothing
    @test CC.IncrementPasteCounter(pp, true) === nothing
    @test CC.IncrementPasteCounter(pp, false) === nothing
    # PoisonSEHIdentifiers is Borland-only: the SEH IdentifierInfo members are
    # uninitialized without -fborland-extensions and it dereferences them all, so
    # this interpreter must be rejected by the wrapper's precondition.
    @test CC.getBorland(CC.getLangOpts(pp)) == false
    @test_throws AssertionError CC.PoisonSEHIdentifiers(pp, true)
    @test CC.setSkipMainFilePreamble(pp, 0, true) === nothing
    @test CC.recomputeCurLexerKind(pp) === nothing

    # safe-buffer opt-out regions round-trip against a preprocessed location
    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)
    if CC.isValid(loc)
        @test !(CC.isSafeBufferOptOut(pp, sm, loc))
        # a stray exit while not inside any region is reported as invalid, leaving no state
        @test CC.enterOrExitSafeBufferOptOutRegion(pp, false, loc) == true
        end_loc = CC.getLocForEndOfToken(pp, loc)
        if CC.isValid(end_loc)
            @test CC.enterOrExitSafeBufferOptOutRegion(pp, true, loc) == false
            @test CC.isPPInSafeBufferOptOutRegion(pp) == true
            @test CC.enterOrExitSafeBufferOptOutRegion(pp, false, end_loc) == false
            @test CC.isPPInSafeBufferOptOutRegion(pp) == false
        end
    end
    CC.dispose(fid)

    # IgnorePragmas rewires the pragma handlers; keep it last, the interpreter is a throwaway
    CC.IgnorePragmas(pp)
    dispose(I)
end

@testset "PoisonSEHIdentifiers under -fborland-extensions" begin
    # The one configuration where the SEH identifiers are actually populated.
    I = create_interpreter(["-fborland-extensions"])
    pp = CC.getPreprocessor(CC.get_instance(I))
    @test CC.getBorland(CC.getLangOpts(pp)) == true
    @test CC.PoisonSEHIdentifiers(pp, true) === nothing
    @test CC.PoisonSEHIdentifiers(pp, false) === nothing
    @test CC.PoisonSEHIdentifiers(pp) === nothing
    dispose(I)
end

@testset "preprocessor include tracking, FP eval and token utilities" begin
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))
    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)

    # included-file set: a fresh temp file is unknown until it is marked
    path, io = mktemp()
    write(io, "int pp_batch_dummy;\n")
    close(io)
    fm = CC.getFileManager(pp)
    ref = CC.getFileRef(fm, path)
    @test ref isa CC.FileEntryRef
    @test CC.alreadyIncluded(pp, ref) == false
    @test CC.markIncluded(pp, ref) == true
    @test CC.alreadyIncluded(pp, ref) == true
    @test CC.markIncluded(pp, ref) == false
    dispose(ref)

    # code-completion filter round-trips through its identifier
    @test CC.getCodeCompletionFilter(pp) == ""
    ii = CC.getIdentifierInfo(pp, "pp_batch_filter")
    @test CC.setCodeCompletionIdentifierInfo(pp, ii) === nothing
    @test CC.getCodeCompletionFilter(pp) == "pp_batch_filter"

    # no code-completion point was requested, so the reached flag is not settable
    @test CC.isCodeCompletionEnabled(pp) == false
    @test_throws AssertionError CC.setCodeCompletionReached(pp)

    # #pragma clang arc_cf_code_audited: inactive, then active, then ended by an invalid loc
    @test CC.is_null_handle(CC.getPragmaARCCFCodeAuditedIdent(pp))
    @test CC.isValid(CC.getPragmaARCCFCodeAuditedLoc(pp)) == false
    if CC.isValid(loc)
        CC.setPragmaARCCFCodeAuditedInfo(pp, ii, loc)
        @test CC.getPragmaARCCFCodeAuditedIdent(pp).ptr == ii.ptr
        @test CC.isValid(CC.getPragmaARCCFCodeAuditedLoc(pp)) == true
        CC.setPragmaARCCFCodeAuditedInfo(pp, ii, CC.SourceLocation())
        @test CC.isValid(CC.getPragmaARCCFCodeAuditedLoc(pp)) == false

        # the preamble-recorded assume_nonnull location round-trips through its setter
        @test CC.isValid(CC.getPreambleRecordedPragmaAssumeNonNullLoc(pp)) == false
        CC.setPreambleRecordedPragmaAssumeNonNullLoc(pp, loc)
        @test CC.isValid(CC.getPreambleRecordedPragmaAssumeNonNullLoc(pp)) == true
        CC.setPreambleRecordedPragmaAssumeNonNullLoc(pp, CC.SourceLocation())
        @test CC.isValid(CC.getPreambleRecordedPragmaAssumeNonNullLoc(pp)) == false

        # splitting the first character off a real token yields a location carrier
        @test !CC.is_null_handle(CC.SplitToken(pp, loc, 1))
    end
    @test_throws AssertionError CC.SplitToken(pp, CC.SourceLocation(), 1)

    # scratch-buffer token: CreateString sets the token's location and length
    scratch = CC.Token()
    @test CC.CreateString(pp, "hello", scratch) === nothing
    @test CC.getLength(scratch) == 5
    @test CC.isValid(CC.getLocation(scratch)) == true
    @test CC.getSpelling(pp, scratch) == "hello"
    # no tokens are cached outside a backtracking scope
    @test CC.IsPreviousCachedToken(pp, scratch) == false
    if CC.isValid(loc)
        @test_throws AssertionError CC.CreateString(pp, "hello", scratch, loc)
    end
    dispose(scratch)

    # relex the predefines buffer for a raw identifier and a one-digit numeric constant
    tok = CC.Token()
    saw_ident = false
    saw_digit = false
    if CC.isValid(loc)
        cur = loc
        for _ in 1:400
            (CC.isValid(cur) && !(saw_ident && saw_digit)) || break
            CC.getRawToken(pp, cur, tok, true) && break
            CC.getLength(tok) == 0 && break
            if !saw_ident && CC.is_raw_identifier(tok)
                found = CC.LookUpIdentifierInfo(pp, tok)
                @test found isa CC.IdentifierInfo
                @test found.ptr == CC.getIdentifierInfo(tok).ptr
                @test CC.TypoCorrectToken(pp, tok) === nothing
                saw_ident = true
            elseif !saw_digit && CC.is_numeric_constant(tok) && CC.getLength(tok) == 1
                @test CC.getSpellingOfSingleCharacterNumericConstant(pp, tok) isa Char
                saw_digit = true
            end
            cur = CC.getLocForEndOfToken(pp, CC.getLocation(tok))
        end
    end
    dispose(tok)

    # a blank token satisfies none of the three token preconditions
    blank = CC.Token()
    @test_throws AssertionError CC.LookUpIdentifierInfo(pp, blank)
    @test_throws AssertionError CC.getSpellingOfSingleCharacterNumericConstant(pp, blank)
    @test_throws AssertionError CC.TypoCorrectToken(pp, blank)
    dispose(blank)

    # floating-point evaluation method: Preprocessor::Initialize sets it from the target,
    # and the TU-wide method is the observable gate for the asserting current-method getter
    unset = CC.LibClangEx.CXFPEvalMethodKind_FEM_UnsetOnCommandLine
    tu_fem = CC.getTUFPEvalMethod(pp)
    @test tu_fem isa CC.LibClangEx.CXFPEvalMethodKind
    if tu_fem != unset
        cur_fem = CC.getCurrentFPEvalMethod(pp)
        @test cur_fem isa CC.LibClangEx.CXFPEvalMethodKind
        CC.setTUFPEvalMethod(pp, tu_fem)
        @test CC.getTUFPEvalMethod(pp) == tu_fem
        CC.setCurrentFPEvalMethod(pp, CC.SourceLocation(), cur_fem)
        @test CC.getCurrentFPEvalMethod(pp) == cur_fem
    else
        @test_throws AssertionError CC.getCurrentFPEvalMethod(pp)
    end
    @test_throws AssertionError CC.setTUFPEvalMethod(pp, unset)
    @test_throws AssertionError CC.setCurrentFPEvalMethod(pp, CC.SourceLocation(), unset)

    # #include filename spellings lose their delimiters; the angled flag comes back too
    name, angled = CC.GetIncludeFilenameSpelling(pp, CC.SourceLocation(), "<stddef.h>")
    @test name == "stddef.h"
    @test angled == true
    name, angled = CC.GetIncludeFilenameSpelling(pp, CC.SourceLocation(), "\"local.h\"")
    @test name == "local.h"
    @test angled == false
    @test_throws AssertionError CC.GetIncludeFilenameSpelling(pp, CC.SourceLocation(), "")

    CC.dispose(fid)
    dispose(I)
    rm(path; force=true)
end

@testset "preprocessor lexer handles, lookahead and macro annotations" begin
    # Everything here peeks at or mutates the live token stream, the poison/annotation
    # tables or the one-shot code-completion point, so every interpreter is a throwaway
    # and each stream-touching block rewinds inside a backtracking scope before disposal.
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # the diagnostics engine is borrowed: reinstalling the one already in use is a no-op
    diags = CC.getDiagnostics(pp)
    @test diags isa CC.DiagnosticsEngine
    @test CC.setDiagnostics(pp, diags) === nothing
    @test CC.getDiagnostics(pp).ptr == diags.ptr

    # lexer handles: which one is current is host/driver decided, so only shape is asserted
    lexer = CC.getCurrentLexer(pp)
    @test lexer isa CC.PreprocessorLexer
    file_lexer = CC.getCurrentFileLexer(pp)
    @test file_lexer isa CC.PreprocessorLexer
    if lexer.ptr != C_NULL
        @test CC.isCurrentLexer(pp, lexer) == true
    end
    if file_lexer.ptr != C_NULL
        @test CC.isCurrentLexer(pp, file_lexer)
    end

    # macro annotation tables are write-only through the C API: assert they do not throw
    ii = CC.getIdentifierInfo(pp, "pp_batch_annotated")
    @test ii isa CC.IdentifierInfo
    @test CC.addMacroDeprecationMsg(pp, ii, "deprecated by the batch test",
                                    CC.SourceLocation()) === nothing
    @test CC.addRestrictExpansionMsg(pp, ii, "restricted by the batch test",
                                     CC.SourceLocation()) === nothing
    @test CC.addFinalLoc(pp, ii, CC.SourceLocation()) === nothing

    # poison bookkeeping: the identifier is never poisoned, so nothing is diagnosed
    @test CC.SetPoisonReason(pp, ii, 0) === nothing
    blank = CC.Token()
    @test CC.MaybeHandlePoisonedIdentifier(pp, blank) === nothing
    @test_throws AssertionError CC.HandlePoisonedIdentifier(pp, blank)

    # a blank token is not an annotation token, so both annotation replacers reject it
    @test_throws AssertionError CC.AnnotateCachedTokens(pp, blank)
    @test_throws AssertionError CC.ReplaceLastTokenWithAnnotation(pp, blank)
    dispose(blank)

    # __FILE__ path processing is static and its separators are host-decided: shape only
    processed = CC.processPathForFileMacro(joinpath("pp", "batch", "file.h"),
                                           CC.getLangOpts(pp), CC.getTargetInfo(pp))
    @test processed isa String
    @test !isempty(processed)

    # backtracking is not enabled here, so the rewind is rejected before the ccall
    @test CC.isBacktrackEnabled(pp) == false
    @test_throws AssertionError CC.RevertCachedTokens(pp, 1)
    dispose(I)

    # peeking, re-injecting and rewinding all touch the live token stream
    J = create_interpreter()
    ppj = CC.getPreprocessor(get_instance(J))
    tok = CC.Token()
    CC.EnableBacktrackAtThisPos(ppj)
    @test CC.LookAhead(ppj, 0, tok) === nothing
    first_kind = CC.getKind(tok)
    @test first_kind isa Integer
    @test CC.LookAhead(ppj, 1, tok) === nothing
    @test CC.getKind(tok) isa Integer

    # LookAhead consumes nothing: the next Lex hands back the token peeked at index 0
    CC.Lex(ppj, tok)
    @test CC.getKind(tok) == first_kind
    @test !CC.is_null_handle(CC.getLastCachedTokenLocation(ppj))

    # re-inject the token just consumed, lex it again, then rewind the whole scope
    @test CC.EnterToken(ppj, tok, true) === nothing
    CC.Lex(ppj, tok)
    @test CC.getKind(tok) == first_kind
    @test CC.RevertCachedTokens(ppj, 1) === nothing
    CC.Backtrack(ppj)
    dispose(tok)
    dispose(J)

    # the code-completion point truncates a real file and is one-shot: another throwaway
    K = create_interpreter()
    ppk = CC.getPreprocessor(get_instance(K))
    path, io = mktemp()
    write(io, "int pp_batch_cc_a;\nint pp_batch_cc_b;\n")
    close(io)
    ref = CC.getFileRef(CC.getFileManager(ppk), path)
    @test ref isa CC.FileEntryRef
    @test CC.isCodeCompletionEnabled(ppk) == false
    @test_throws AssertionError CC.SetCodeCompletionPoint(ppk, ref, 0, 1)
    @test_throws AssertionError CC.SetCodeCompletionPoint(ppk, ref, 1, 0)
    failed = CC.SetCodeCompletionPoint(ppk, ref, 2, 1)
    @test failed isa Bool
    if !failed
        @test CC.isCodeCompletionEnabled(ppk) == true
        # the point is one-shot; Clang asserts on a second one and the wrapper restates it
        @test_throws AssertionError CC.SetCodeCompletionPoint(ppk, ref, 1, 1)
    end
    dispose(ref)
    dispose(K)
    rm(path; force=true)
end

@testset "preprocessor macro table, module visibility and preprocessing record" begin
    I = create_interpreter(["-include", "cstddef"])
    pp = CC.getPreprocessor(get_instance(I))

    # the selector table is an interior reference the preprocessor always owns
    @test !CC.is_null_handle(CC.getSelectorTable(pp))

    # the macro history table always holds the builtin macros Clang registers itself
    n = CC.getNumMacros(pp)
    @test n isa Integer
    @test n > 0
    macro_names = CC.getMacros(pp)
    @test macro_names isa Vector{CC.IdentifierInfo}
    @test length(macro_names) == n
    spellings = [CC.getNameStart(ii) for ii in macro_names]
    @test all(!isempty, spellings)
    @test "__FILE__" in spellings
    # there is no external source here, so dropping its macros cannot grow the table
    @test CC.getNumMacros(pp, false) <= CC.getNumMacros(pp)

    # __FILE__ is #define'd, so it has both a live directive and a directive history
    file_ii = CC.getIdentifierInfo(pp, "__FILE__")
    @test CC.hasMacroDefinition(file_ii) == true
    md = CC.getLocalMacroDirective(pp, file_ii)
    @test md isa CC.MacroDirective
    @test md.ptr != C_NULL
    @test CC.getLocalMacroDirectiveHistory(pp, file_ii).ptr != C_NULL
    # a name that never was a macro has neither
    unknown_ii = CC.getIdentifierInfo(pp, "pp_batch_g_never_a_macro")
    @test CC.getLocalMacroDirective(pp, unknown_ii).ptr == C_NULL

    # both dumps only write to stderr
    mi = CC.getMacroInfo(pp, file_ii)
    @test mi.ptr != C_NULL
    dumped = redirect_stderr(devnull) do
        CC.DumpMacro(pp, mi)
        CC.dumpMacroInfo(pp, file_ii)
        CC.dumpMacroInfo(pp, unknown_ii)
        return true
    end
    @test dumped

    # which headers the driver actually pulled in is host-decided: assert the shape only
    nfiles = CC.getNumIncludedFiles(pp)
    @test nfiles isa Integer
    included = CC.getIncludedFiles(pp)
    @test included isa Vector{CC.FileEntry}
    @test length(included) == nfiles

    # module queries run against a throwaway module this testset owns; the visibility id is
    # far past any this translation unit uses, so its visibility slot starts out unset
    m = CC.Module_("pp_batch_g"; visibility_id=4096)
    @test CC.isModuleMapModule(m) == true
    @test CC.isMacroDefinedInLocalModule(pp, file_ii, m) == false
    @test CC.getModuleImportLoc(pp, m) isa CC.SourceLocation
    @test CC.isValid(CC.getModuleImportLoc(pp, m)) == false
    @test (CC.markClangModuleAsAffecting(pp, m); true)

    # makeModuleVisible needs a valid import location unless the module is a global fragment
    sm = CC.getSourceManager(pp)
    fid = CC.getMainFileID(sm)
    main_loc = CC.getLocForStartOfFile(sm, fid)
    @test CC.isValid(main_loc) == true
    @test CC.isGlobalModule(m) == false
    @test_throws AssertionError CC.makeModuleVisible(pp, m, CC.SourceLocation())
    @test (CC.makeModuleVisible(pp, m, main_loc); true)
    # the module now records the location the test just made it visible at
    @test CC.isValid(CC.getModuleImportLoc(pp, m)) == true
    dispose(fid)

    # the preprocessor holds borrowed pointers to the module: it must die first
    dispose(I)
    dispose(m)

    # createPreprocessingRecord installs a callback for good: another throwaway interpreter
    J = create_interpreter()
    ppj = CC.getPreprocessor(get_instance(J))
    @test CC.getPreprocessingRecord(ppj).ptr == C_NULL
    @test (CC.createPreprocessingRecord(ppj); true)
    rec = CC.getPreprocessingRecord(ppj)
    @test rec isa CC.PreprocessingRecord
    @test rec.ptr != C_NULL
    dispose(J)
end

@testset "preprocessor interior handles, macro authoring and expansion warnings" begin
    # Everything here mutates preprocessor-wide state — the handler slots, the callback
    # chain, the macro table, the source manager's file list — so the interpreter is a
    # throwaway this testset owns. Nothing below consumes the live token stream: the only
    # token is relexed out of a buffer with getRawToken, which never advances the lexer.
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # interior references the preprocessor always owns
    @test !CC.is_null_handle(CC.getBuiltinInfo(pp))
    @test CC.getBuiltinInfo(pp).ptr != C_NULL
    @test !CC.is_null_handle(CC.getModuleLoader(pp))
    @test CC.getModuleLoader(pp).ptr != C_NULL

    # the external macro source is borrowed, so reinstalling whatever is already attached
    # (a NULL carrier when no AST file was loaded) is a no-op round-trip
    src = CC.getExternalSource(pp)
    @test src isa CC.ExternalPreprocessorSource
    @test CC.setExternalSource(pp, src) === nothing
    @test CC.getExternalSource(pp).ptr == src.ptr

    # same shape for the empty-line handler slot
    handler = CC.getEmptylineHandler(pp)
    @test handler isa CC.EmptylineHandler
    @test CC.setEmptylineHandler(pp, handler) === nothing
    @test CC.getEmptylineHandler(pp).ptr == handler.ptr

    # no code completion is running here, so clearing the slot leaves it empty
    @test !CC.is_null_handle(CC.getCodeCompletionHandler(pp))
    @test CC.clearCodeCompletionHandler(pp) === nothing
    @test CC.getCodeCompletionHandler(pp).ptr == C_NULL

    # macro authoring: allocate a MacroInfo, push it as this name's live definition, then
    # read the definition back through the macro table
    sm = CC.getSourceManager(pp)
    fid = CC.getMainFileID(sm)
    loc = CC.getLocForStartOfFile(sm, fid)
    @test CC.isValid(loc) == true
    ii = CC.getIdentifierInfo(pp, "PP_BATCH_AUTHORED")
    @test CC.hasMacroDefinition(ii) == false
    @test CC.isMacroDefinitionAmbiguous(pp, ii) == false
    mi = CC.AllocateMacroInfo(pp, loc)
    @test mi isa CC.MacroInfo
    md = CC.appendDefMacroDirective(pp, ii, mi, loc)
    @test md isa CC.MacroDirective
    @test md.ptr != C_NULL
    @test CC.hasMacroDefinition(ii) == true
    @test CC.isMacroDefined(pp, "PP_BATCH_AUTHORED") == true
    @test CC.getMacroInfo(pp, ii).ptr == mi.ptr
    # one local definition and no module macros, so there is nothing to be ambiguous about
    @test CC.isMacroDefinitionAmbiguous(pp, ii) == false

    # the location defaults to the one the MacroInfo was allocated at
    ii2 = CC.getIdentifierInfo(pp, "PP_BATCH_AUTHORED_2")
    mi2 = CC.AllocateMacroInfo(pp, loc)
    @test !CC.is_null_handle(CC.appendDefMacroDirective(pp, ii2, mi2))
    @test CC.isMacroDefined(pp, "PP_BATCH_AUTHORED_2") == true
    dispose(fid)

    # the expansion warnings dereference the token's identifier info, so a blank token is
    # rejected before the ccall
    blank = CC.Token()
    @test_throws AssertionError CC.emitMacroExpansionWarnings(pp, blank)
    dispose(blank)

    # a token that does carry one: relex the first token of a scratch file and look its
    # identifier up. Nothing annotates this name, so no warning is actually reported.
    path, io = mktemp()
    write(io, "pp_batch_probe_ident\n")
    close(io)
    ref = CC.getFileRef(CC.getFileManager(pp), path)
    @test ref isa CC.FileEntryRef
    probe_fid = CC.FileID(sm, ref)
    probe_loc = CC.getLocForStartOfFile(sm, probe_fid)
    tok = CC.Token()
    # getRawToken reports failure, not success
    @test CC.getRawToken(pp, probe_loc, tok, false) == false
    @test CC.is_raw_identifier(tok) == true
    probe_ii = CC.LookUpIdentifierInfo(pp, tok)
    @test probe_ii isa CC.IdentifierInfo
    @test CC.getIdentifierInfo(tok).ptr == probe_ii.ptr
    @test CC.emitMacroExpansionWarnings(pp, tok) === nothing
    @test CC.emitMacroExpansionWarnings(pp, tok, true) === nothing
    dispose(tok)
    dispose(probe_fid)
    dispose(ref)
    rm(path; force=true)

    # a preprocessing record registers itself on the callback chain, so the chain is
    # non-empty afterwards; the installation cannot be undone, so it runs last
    @test !CC.is_null_handle(CC.getPPCallbacks(pp))
    @test (CC.createPreprocessingRecord(pp); true)
    @test CC.getPPCallbacks(pp).ptr != C_NULL

    dispose(I)
end

@testset "preprocessor module tracking and preamble conditional state" begin
    # Everything here is a whole-preprocessor query, and recording an affecting module
    # leaves a borrowed pointer behind, so the interpreter is a throwaway this testset owns
    # and it dies before the module it was handed.
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))

    # the submodule build stack is empty outside a `#pragma clang module build`
    n_subs = CC.getNumBuildingSubmodules(pp)
    @test n_subs isa Integer
    subs = CC.getBuildingSubmodules(pp)
    @test subs isa Vector
    @test length(subs) == n_subs

    # affecting modules read back exactly what markClangModuleAsAffecting recorded
    n_aff = CC.getNumAffectingClangModules(pp)
    @test n_aff isa Integer
    @test CC.getAffectingClangModules(pp) isa Vector{CC.Module_}
    m = CC.Module_("pp_affecting_module"; visibility_id=4098)
    @test CC.isModuleMapModule(m) == true
    CC.markClangModuleAsAffecting(pp, m)
    @test CC.getNumAffectingClangModules(pp) == n_aff + 1
    affecting = CC.getAffectingClangModules(pp)
    @test length(affecting) == n_aff + 1
    @test any(mod -> mod.ptr == m.ptr, affecting)

    # the preamble conditional stack is empty outside a preamble build, and writing one
    # back is deliberately inert while the store is neither recording nor replaying
    @test CC.isRecordingPreamble(pp) == false
    n_cond = CC.getNumPreambleConditionals(pp)
    @test n_cond isa Integer
    stack = CC.getPreambleConditionalStack(pp)
    @test stack isa Vector
    @test length(stack) == n_cond
    @test CC.hasRecordedPreamble(pp) == (n_cond > 0)
    CC.setRecordedPreambleConditionalStack(pp, stack)
    @test CC.getNumPreambleConditionals(pp) == n_cond

    # nothing was left skipping at end of file, so there is no skip record
    @test CC.getPreambleSkipInfo(pp) === nothing

    # isPCHThroughHeader answers only once a through-header is configured; assert the gate
    # its wrapper checks rather than tripping it
    @test CC.creatingPCHWithThroughHeader(pp) == false
    @test CC.usingPCHWithThroughHeader(pp) == false

    # creating Sema installs it as the preprocessor's code-completion handler, and only the
    # detach half of that pairing is wrapped, so this is a one-way transition
    @test !CC.is_null_handle(CC.getCodeCompletionHandler(pp))
    @test CC.getCodeCompletionHandler(pp).ptr != C_NULL
    CC.clearCodeCompletionHandler(pp)
    @test CC.getCodeCompletionHandler(pp).ptr == C_NULL

    # the preprocessor holds a borrowed pointer to the module: it must die first
    dispose(I)
    dispose(m)
end

@testset "preprocessor module macros, macro annotations and header suggestions" begin
    I = create_interpreter()
    pp = CC.getPreprocessor(get_instance(I))
    sm = CC.getSourceManager(pp)
    fid = CC.getMainFileID(sm)
    main_loc = CC.getLocForStartOfFile(sm, fid)
    @test CC.isValid(main_loc) == true

    # a name nothing exports yet has neither a module macro nor a leaf list; the module is a
    # throwaway this testset owns, with a visibility id far past any this TU uses
    m = CC.Module_("pp_module_macro_probe"; visibility_id=4097)
    mii = CC.getIdentifierInfo(pp, "PP_MODULE_MACRO_PROBE")
    @test CC.getNumLeafModuleMacros(pp, mii) == 0
    @test isempty(CC.getLeafModuleMacros(pp, mii))
    @test CC.getModuleMacro(pp, m, mii).ptr == C_NULL

    # registering one makes it retrievable and puts it in the leaf list for that name
    mi = CC.AllocateMacroInfo(pp, main_loc)
    mm, is_new = CC.addModuleMacro(pp, m, mii, mi)
    @test mm isa CC.ModuleMacro
    @test mm.ptr != C_NULL
    @test is_new == true
    # an identical registration folds onto the node that already exists
    mm2, is_new2 = CC.addModuleMacro(pp, m, mii, mi)
    @test mm2.ptr == mm.ptr
    @test is_new2 == false
    @test CC.getModuleMacro(pp, m, mii).ptr == mm.ptr
    leaves = CC.getLeafModuleMacros(pp, mii)
    @test leaves isa Vector{CC.ModuleMacro}
    @test length(leaves) == CC.getNumLeafModuleMacros(pp, mii)
    @test mm.ptr in [l.ptr for l in leaves]

    # a second registration overriding the first: clang uniques ModuleMacros on the whole
    # (module, name, macro, overrides) tuple and decides for itself whether this is a new
    # node, so assert what is invariant — whatever comes back is a leaf for this name.
    mi2 = CC.AllocateMacroInfo(pp, main_loc)
    mm3, is_new3 = CC.addModuleMacro(pp, m, mii, mi2, [mm])
    @test is_new3 isa Bool
    @test mm3 isa CC.ModuleMacro
    @test mm3.ptr != C_NULL
    @test mm3.ptr in [l.ptr for l in CC.getLeafModuleMacros(pp, mii)]

    # macro annotations: each reader stays disengaged until its own recorder has run. The
    # identifier flag and the annotation entry are set together, as Clang's pragma handlers
    # do, because the flag is what gates the entry lookup
    aii = CC.getIdentifierInfo(pp, "PP_ANNOTATED_MACRO_PROBE")
    CC.setIsDeprecatedMacro(aii, true)
    CC.addMacroDeprecationMsg(pp, aii, "use PP_OTHER instead", main_loc)
    dep_loc = CC.getMacroDeprecationLoc(pp, aii)
    @test dep_loc isa CC.SourceLocation
    @test CC.isValid(dep_loc) == true
    @test CC.getMacroDeprecationMsg(pp, aii) == "use PP_OTHER instead"
    # the entry exists now, but carries no restrict-expansion and no final annotation yet
    @test CC.getMacroRestrictExpansionLoc(pp, aii) === nothing
    @test CC.getMacroRestrictExpansionMsg(pp, aii) == ""
    @test CC.getMacroFinalAnnotationLoc(pp, aii) === nothing
    CC.addRestrictExpansionMsg(pp, aii, "not outside this header", main_loc)
    CC.addFinalLoc(pp, aii, main_loc)
    @test !CC.is_null_handle(CC.getMacroRestrictExpansionLoc(pp, aii))
    @test CC.getMacroRestrictExpansionMsg(pp, aii) == "not outside this header"
    @test !CC.is_null_handle(CC.getMacroFinalAnnotationLoc(pp, aii))
    # an identifier that was never annotated is rejected before the unguarded lookup runs
    plain = CC.getIdentifierInfo(pp, "PP_UNANNOTATED_MACRO_PROBE")
    @test_throws AssertionError CC.getMacroDeprecationLoc(pp, plain)
    @test_throws AssertionError CC.getMacroDeprecationMsg(pp, plain)
    @test_throws AssertionError CC.getMacroRestrictExpansionLoc(pp, plain)
    @test_throws AssertionError CC.getMacroRestrictExpansionMsg(pp, plain)
    @test_throws AssertionError CC.getMacroFinalAnnotationLoc(pp, plain)

    # the spelling search takes token values as a parallel kind/identifier list. Kind 0 is
    # tok::unknown, which the token value constructor accepts because it is neither an
    # identifier nor a literal nor an annotation — assert that rather than assuming it
    @test CC.isAnyIdentifier(0) == false
    @test CC.isLiteral(0) == false
    @test CC.isAnnotation(0) == false
    file_ii = CC.getIdentifierInfo(pp, "__FILE__")
    @test isempty(CC.getLastMacroWithSpelling(pp, main_loc, [file_ii]))
    @test !isempty(CC.getLastMacroWithSpelling(pp, main_loc, Any[]))
    @test isempty(CC.getLastMacroWithSpelling(pp, main_loc, [0]))
    @test_throws AssertionError CC.getLastMacroWithSpelling(pp, CC.SourceLocation(), [0])
    @test_throws AssertionError CC.getLastMacroWithSpelling(pp, main_loc, [file_ii.ptr])

    # nothing at a main-file location sits in an unimported module, but which module maps
    # the host loaded decides the answer: assert the shape only
    hdr = CC.getHeaderToIncludeForDiagnostics(pp, main_loc, main_loc)
    @test hdr === nothing || hdr isa CC.FileEntryRef
    hdr === nothing || dispose(hdr)

    # a hand-built module has no module map behind it, so its availability is host-decided;
    # the failing branch reports through the diagnostics engine, hence the stderr redirect
    avail = redirect_stderr(devnull) do
        return CC.checkModuleIsAvailable(CC.getLangOpts(pp), CC.getTargetInfo(pp), m,
                                         CC.getDiagnostics(pp))
    end
    @test avail isa Bool

    dispose(fid)
    # the preprocessor holds borrowed pointers to the module: it must die first
    dispose(I)
    dispose(m)
end
