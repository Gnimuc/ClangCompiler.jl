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

    @test CC.getPreprocessorOpts(pp) isa CC.PreprocessorOptions
    @test CC.getNumDirectives(pp) isa Integer
    @test CC.isParsingIfOrElifDirective(pp) == false
    @test CC.isPreprocessedOutput(pp) isa Bool
    @test CC.isInPrimaryFile(pp) isa Bool
    @test CC.SawDateOrTime(pp) isa Bool
    @test CC.getTotalMemory(pp) isa Integer
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
        @test CC.getMacroInfoAtLoc(pp, ii, loc) isa CC.MacroInfo
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
    @test CC.hadModuleLoaderFatalFailure(pp) isa Bool
    @test CC.creatingPCHWithThroughHeader(pp) isa Bool
    @test CC.usingPCHWithThroughHeader(pp) isa Bool
    @test CC.creatingPCHWithPragmaHdrStop(pp) isa Bool
    @test CC.usingPCHWithPragmaHdrStop(pp) isa Bool

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
    @test CC.getCodeCompletionLoc(pp) isa CC.SourceLocation
    @test CC.isValid(CC.getCodeCompletionLoc(pp)) == false
    @test CC.getCodeCompletionFileLoc(pp) isa CC.SourceLocation
    @test CC.isValid(CC.getCodeCompletionFileLoc(pp)) == false

    # the interpreter compiles a plain translation unit, not a C++20 module
    @test CC.getCurrentModule(pp) isa CC.Module_
    @test CC.getCurrentModuleImplementation(pp) isa CC.Module_
    @test CC.isInNamedInterfaceUnit(pp) == false
    @test CC.isInImplementationUnit(pp) == false

    # relex off the preprocessor's own source manager and language options
    sm = CC.getSourceManager(pp)
    fid = CC.getPredefinesFileID(pp)
    loc = CC.getLocForStartOfFile(sm, fid)
    if CC.isValid(loc)
        tok = CC.Token()
        @test CC.getRawToken(pp, loc, tok) isa Bool
        @test CC.getLocForEndOfToken(pp, loc) isa CC.SourceLocation
        @test CC.getLocForEndOfToken(pp, loc, 1) isa CC.SourceLocation
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
    @test CC.isRecordingPreamble(pp) isa Bool
    @test CC.hasRecordedPreamble(pp) isa Bool
    @test CC.isPPInSafeBufferOptOutRegion(pp) isa Bool
    @test CC.isInImportingCXXNamedModules(pp) == false
    @test CC.mightHavePendingAnnotationTokens(pp) isa Bool

    # pragma-location accessors are invalid outside their pragma regions
    @test CC.getPragmaAssumeNonNullLoc(pp) isa CC.SourceLocation
    @test CC.isValid(CC.getPragmaAssumeNonNullLoc(pp)) == false
    @test CC.getPreambleRecordedPragmaAssumeNonNullLoc(pp) isa CC.SourceLocation
    @test CC.getLastFPEvalPragmaLocation(pp) isa CC.SourceLocation

    # aux target and current-lexer submodule are borrowed and NULL for a single-target,
    # non-modular translation unit
    @test CC.getAuxTargetInfo(pp) isa CC.TargetInfo
    @test CC.getCurrentLexerSubmodule(pp) isa CC.Module_

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
        @test CC.AdvanceToTokenCharacter(pp, loc, 0) isa CC.SourceLocation

        # a location in the predefines buffer is outside any module → borrowed NULL carrier
        @test CC.getModuleForLocation(pp, loc, false) isa CC.Module_
        @test CC.getModuleForLocation(pp, loc, true) isa CC.Module_
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
        @test CC.isSafeBufferOptOut(pp, sm, loc) isa Bool
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
    @test CC.getPragmaARCCFCodeAuditedIdent(pp) isa CC.IdentifierInfo
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
        @test CC.SplitToken(pp, loc, 1) isa CC.SourceLocation
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
