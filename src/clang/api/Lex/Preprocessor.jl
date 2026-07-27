# Preprocessor
function EnterMainSourceFile(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_EnterMainSourceFile(x)
end

function EnterSourceFile(x::Preprocessor, id::FileID, loc::SourceLocation=SourceLocation())
    @check_ptrs x id
    return clang_Preprocessor_EnterSourceFile(x, id, loc)
end

function EndSourceFile(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_EndSourceFile(x)
end

function getHeaderSearchInfo(x::Preprocessor)
    @check_ptrs x
    return HeaderSearch(clang_Preprocessor_getHeaderSearchInfo(x))
end

function PrintStats(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_PrintStats(x)
end

function InitializeBuiltins(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_InitializeBuiltins(x)
end

function isIncrementalProcessingEnabled(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_isIncrementalProcessingEnabled(x)
end

function enableIncrementalProcessing(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_enableIncrementalProcessing(x)
end

function DumpToken(x::Preprocessor, tok::Token, flag=false)
    @check_ptrs x
    return clang_Preprocessor_DumpToken(x, tok, flag)
end

function DumpLocation(x::Preprocessor, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_DumpLocation(x, loc)
end


function getDiagnostics(x::AbstractPreprocessor)
    @check_ptrs x
    return DiagnosticsEngine(clang_Preprocessor_getDiagnostics(x))
end

function getLangOpts(x::AbstractPreprocessor)
    @check_ptrs x
    return LangOptions(clang_Preprocessor_getLangOpts(x))
end

function getTargetInfo(x::AbstractPreprocessor)
    @check_ptrs x
    return TargetInfo(clang_Preprocessor_getTargetInfo(x))
end

function getFileManager(x::AbstractPreprocessor)
    @check_ptrs x
    return FileManager(clang_Preprocessor_getFileManager(x))
end

function getSourceManager(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceManager(clang_Preprocessor_getSourceManager(x))
end

function getIdentifierTable(x::AbstractPreprocessor)
    @check_ptrs x
    return IdentifierTable(clang_Preprocessor_getIdentifierTable(x))
end

function SetCommentRetentionState(x::AbstractPreprocessor, keep_comments::Bool,
                                  keep_macro_comments::Bool)
    @check_ptrs x
    return clang_Preprocessor_SetCommentRetentionState(x, keep_comments,
                                                       keep_macro_comments)
end

function getCommentRetentionState(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getCommentRetentionState(x)
end

function setPragmasEnabled(x::AbstractPreprocessor, enabled::Bool)
    @check_ptrs x
    return clang_Preprocessor_setPragmasEnabled(x, enabled)
end

function getPragmasEnabled(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getPragmasEnabled(x)
end

"""
    getPredefinesFileID(x::AbstractPreprocessor) -> FileID
Return the `FileID` of the preprocessor predefines.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getPredefinesFileID(x::AbstractPreprocessor)
    @check_ptrs x
    return FileID(clang_Preprocessor_getPredefinesFileID(x))
end

function getTokenCount(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getTokenCount(x)
end

function getMaxTokens(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getMaxTokens(x)
end

function isMacroDefined(x::AbstractPreprocessor, name::AbstractString)
    @check_ptrs x
    return clang_Preprocessor_isMacroDefined(x, name)
end

"""
    getMacroInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> MacroInfo
Return the macro information for `ii`. The result is borrowed and holds a NULL pointer
when `ii` has no active macro definition.
"""
function getMacroInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return MacroInfo(clang_Preprocessor_getMacroInfo(x, ii))
end

function getPredefines(x::AbstractPreprocessor)
    @check_ptrs x
    return get_string(clang_Preprocessor_getPredefines(x))
end

function setPredefines(x::AbstractPreprocessor, predefines::AbstractString)
    @check_ptrs x
    return clang_Preprocessor_setPredefines(x, predefines)
end

function getIdentifierInfo(x::AbstractPreprocessor, name::AbstractString)
    @check_ptrs x
    return IdentifierInfo(clang_Preprocessor_getIdentifierInfo(x, name))
end

function Lex(x::AbstractPreprocessor, result::AbstractToken)
    @check_ptrs x result
    return clang_Preprocessor_Lex(x, result)
end

function getSpelling(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    return get_string(clang_Preprocessor_getSpelling(x, tok))
end


function getPreprocessorOpts(x::AbstractPreprocessor)
    @check_ptrs x
    return PreprocessorOptions(clang_Preprocessor_getPreprocessorOpts(x))
end

function getNumDirectives(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getNumDirectives(x)
end

function isParsingIfOrElifDirective(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isParsingIfOrElifDirective(x)
end

function setPreprocessedOutput(x::AbstractPreprocessor, is_preprocessed_output::Bool)
    @check_ptrs x
    return clang_Preprocessor_setPreprocessedOutput(x, is_preprocessed_output)
end

function isPreprocessedOutput(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isPreprocessedOutput(x)
end

"""
    isInPrimaryFile(x::AbstractPreprocessor) -> Bool
Return `true` when the preprocessor is lexing the top-level file rather than an `#include`.
"""
function isInPrimaryFile(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isInPrimaryFile(x)
end

function overrideMaxTokens(x::AbstractPreprocessor, value::Integer, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_overrideMaxTokens(x, value, loc)
end

function getMaxTokensOverrideLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getMaxTokensOverrideLoc(x))
end

function getCounterValue(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getCounterValue(x)
end

function setCounterValue(x::AbstractPreprocessor, v::Integer)
    @check_ptrs x
    return clang_Preprocessor_setCounterValue(x, v)
end

function SawDateOrTime(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_SawDateOrTime(x)
end

function getTotalMemory(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getTotalMemory(x)
end

"""
    EnableBacktrackAtThisPos(x::AbstractPreprocessor)
Remember the current lexer position so the tokens lexed from now on can be re-lexed. Every
call must be matched by exactly one `CommitBacktrackedTokens` or `Backtrack`.
"""
function EnableBacktrackAtThisPos(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_EnableBacktrackAtThisPos(x)
end

"""
    CommitBacktrackedTokens(x::AbstractPreprocessor)
Drop the last `EnableBacktrackAtThisPos` mark, keeping the tokens lexed since. A pending
mark is required (`isBacktrackEnabled`).
"""
function CommitBacktrackedTokens(x::AbstractPreprocessor)
    @check_ptrs x
    @assert isBacktrackEnabled(x) "EnableBacktrackAtThisPos must be called first"
    return clang_Preprocessor_CommitBacktrackedTokens(x)
end

"""
    Backtrack(x::AbstractPreprocessor)
Re-lex the tokens lexed since the last `EnableBacktrackAtThisPos`. A pending mark is
required (`isBacktrackEnabled`).
"""
function Backtrack(x::AbstractPreprocessor)
    @check_ptrs x
    @assert isBacktrackEnabled(x) "EnableBacktrackAtThisPos must be called first"
    return clang_Preprocessor_Backtrack(x)
end

function isBacktrackEnabled(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isBacktrackEnabled(x)
end

function SetMacroExpansionOnlyInDirectives(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_SetMacroExpansionOnlyInDirectives(x)
end

function isInNamedModule(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isInNamedModule(x)
end

"""
    getNamedModuleName(x::AbstractPreprocessor) -> String
Return the name of the C++20 named module currently being preprocessed. `isInNamedModule`
must hold — the accessor reads module state that is only populated inside a named module.
"""
function getNamedModuleName(x::AbstractPreprocessor)
    @check_ptrs x
    @assert isInNamedModule(x) "preprocessor must be preprocessing a named module"
    return get_string(clang_Preprocessor_getNamedModuleName(x))
end

"""
    getMacroInfoAtLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                      loc::SourceLocation) -> MacroInfo
Return the macro definition `ii` had at `loc`, or a NULL-pointer `MacroInfo` when it had
none. `loc` must be a valid source location: the directive-history lookup asserts on an
invalid one.
"""
function getMacroInfoAtLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                           loc::SourceLocation)
    @check_ptrs x ii
    @assert isValid(loc) "macro lookup location must be valid"
    return MacroInfo(clang_Preprocessor_getMacroInfoAtLoc(x, ii, loc))
end


function hadModuleLoaderFatalFailure(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_hadModuleLoaderFatalFailure(x)
end

"""
    SetSuppressIncludeNotFoundError(x::AbstractPreprocessor, suppress::Bool)
Control whether a missing `#include` file is diagnosed. Suppression is what lets a caller
lex a file whose headers are not on the search path.
"""
function SetSuppressIncludeNotFoundError(x::AbstractPreprocessor, suppress::Bool)
    @check_ptrs x
    return clang_Preprocessor_SetSuppressIncludeNotFoundError(x, suppress)
end

function GetSuppressIncludeNotFoundError(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_GetSuppressIncludeNotFoundError(x)
end

function creatingPCHWithThroughHeader(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_creatingPCHWithThroughHeader(x)
end

function usingPCHWithThroughHeader(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_usingPCHWithThroughHeader(x)
end

function creatingPCHWithPragmaHdrStop(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_creatingPCHWithPragmaHdrStop(x)
end

function usingPCHWithPragmaHdrStop(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_usingPCHWithPragmaHdrStop(x)
end

"""
    LexNonComment(x::AbstractPreprocessor, result::AbstractToken)
Lex into `result` until a token that is not a comment is produced.
"""
function LexNonComment(x::AbstractPreprocessor, result::AbstractToken)
    @check_ptrs x result
    return clang_Preprocessor_LexNonComment(x, result)
end

"""
    LexUnexpandedToken(x::AbstractPreprocessor, result::AbstractToken)
Lex one token into `result` with macro expansion of identifier tokens disabled.
"""
function LexUnexpandedToken(x::AbstractPreprocessor, result::AbstractToken)
    @check_ptrs x result
    return clang_Preprocessor_LexUnexpandedToken(x, result)
end

"""
    LexUnexpandedNonComment(x::AbstractPreprocessor, result::AbstractToken)
Lex into `result` until a non-comment token is produced, with macro expansion of identifier
tokens disabled.
"""
function LexUnexpandedNonComment(x::AbstractPreprocessor, result::AbstractToken)
    @check_ptrs x result
    return clang_Preprocessor_LexUnexpandedNonComment(x, result)
end

function isCodeCompletionEnabled(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isCodeCompletionEnabled(x)
end

"""
    getCodeCompletionLoc(x::AbstractPreprocessor) -> SourceLocation
Return the location of the code-completion point. The location is invalid when
code completion is disabled or its file has not been lexed yet.
"""
function getCodeCompletionLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getCodeCompletionLoc(x))
end

"""
    getCodeCompletionFileLoc(x::AbstractPreprocessor) -> SourceLocation
Return the start location of the file holding the code-completion point. The location is
invalid when code completion is disabled or its file has not been lexed yet.
"""
function getCodeCompletionFileLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getCodeCompletionFileLoc(x))
end

function isCodeCompletionReached(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isCodeCompletionReached(x)
end

"""
    getRawToken(x::AbstractPreprocessor, loc::SourceLocation, result::AbstractToken,
                ignore_whitespace::Bool=false) -> Bool
Relex the token at `loc` into `result`, using the preprocessor's own source manager and
language options. Return `true` if there was a failure, `false` on success (mirroring
`clang::Preprocessor::getRawToken`).
"""
function getRawToken(x::AbstractPreprocessor, loc::SourceLocation, result::AbstractToken,
                     ignore_whitespace::Bool=false)
    @check_ptrs x result
    return clang_Preprocessor_getRawToken(x, loc, result, ignore_whitespace)
end

"""
    getLocForEndOfToken(x::AbstractPreprocessor, loc::SourceLocation,
                        offset::Integer=0) -> SourceLocation
Return the location just past the end of the token starting at `loc`, shifted back by
`offset` characters. The result is invalid when `loc` points into a macro.
"""
function getLocForEndOfToken(x::AbstractPreprocessor, loc::SourceLocation,
                             offset::Integer=0)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getLocForEndOfToken(x, loc, offset))
end

"""
    getCurrentModule(x::AbstractPreprocessor) -> Module_
Return the module currently being built. The result is borrowed and holds a NULL pointer
unless a module build is in progress.
"""
function getCurrentModule(x::AbstractPreprocessor)
    @check_ptrs x
    return Module_(clang_Preprocessor_getCurrentModule(x))
end

"""
    getCurrentModuleImplementation(x::AbstractPreprocessor) -> Module_
Return the module whose implementation is currently being compiled. The result is borrowed
and holds a NULL pointer unless such a compilation is in progress.
"""
function getCurrentModuleImplementation(x::AbstractPreprocessor)
    @check_ptrs x
    return Module_(clang_Preprocessor_getCurrentModuleImplementation(x))
end

function isInNamedInterfaceUnit(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isInNamedInterfaceUnit(x)
end

function isInImplementationUnit(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isInImplementationUnit(x)
end


"""
    getAuxTargetInfo(x::AbstractPreprocessor) -> TargetInfo
Return the auxiliary target of the preprocessor. The result is borrowed and holds a NULL
pointer when there is no auxiliary target (the common single-target case).
"""
function getAuxTargetInfo(x::AbstractPreprocessor)
    @check_ptrs x
    return TargetInfo(clang_Preprocessor_getAuxTargetInfo(x))
end

"""
    getCurrentLexerSubmodule(x::AbstractPreprocessor) -> Module_
Return the submodule the current lexer belongs to. The result is borrowed and holds a NULL
pointer when the current lexer is not in a submodule.
"""
function getCurrentLexerSubmodule(x::AbstractPreprocessor)
    @check_ptrs x
    return Module_(clang_Preprocessor_getCurrentLexerSubmodule(x))
end

function setCodeCompletionTokenRange(x::AbstractPreprocessor, start::SourceLocation,
                                     stop::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_setCodeCompletionTokenRange(x, start, stop)
end

function getCodeCompletionTokenRange(x::AbstractPreprocessor)
    @check_ptrs x
    r = clang_Preprocessor_getCodeCompletionTokenRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function mightHavePendingAnnotationTokens(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_mightHavePendingAnnotationTokens(x)
end

"""
    getPragmaAssumeNonNullLoc(x::AbstractPreprocessor) -> SourceLocation
Return the location of the currently-active `#pragma clang assume_nonnull begin`, or an
invalid location when no such pragma is active.
"""
function getPragmaAssumeNonNullLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getPragmaAssumeNonNullLoc(x))
end

"""
    setPragmaAssumeNonNullLoc(x::AbstractPreprocessor, loc::SourceLocation)
Set the location of the currently-active `#pragma clang assume_nonnull begin`. An invalid
location ends the pragma.
"""
function setPragmaAssumeNonNullLoc(x::AbstractPreprocessor, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_setPragmaAssumeNonNullLoc(x, loc)
end

"""
    getPreambleRecordedPragmaAssumeNonNullLoc(x::AbstractPreprocessor) -> SourceLocation
Return the location of the unterminated `#pragma clang assume_nonnull begin` recorded in
the preamble, or an invalid location when the preamble recorded none.
"""
function getPreambleRecordedPragmaAssumeNonNullLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getPreambleRecordedPragmaAssumeNonNullLoc(x))
end

"""
    getImmediateMacroName(x::AbstractPreprocessor, loc::SourceLocation) -> String
Return the name of the macro whose expansion the macro location `loc` immediately belongs
to. `loc` must be a valid macro location: the underlying lexer routine asserts `isMacroID`.
"""
function getImmediateMacroName(x::AbstractPreprocessor, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    return get_string(clang_Preprocessor_getImmediateMacroName(x, loc))
end

"""
    isAtStartOfMacroExpansion(x::AbstractPreprocessor, loc::SourceLocation) ->
        Union{SourceLocation,Nothing}
Return the begin location of the macro when the macro location `loc` points at the first
token of its expansion, `nothing` otherwise. `loc` must be a valid macro location.
"""
function isAtStartOfMacroExpansion(x::AbstractPreprocessor, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Preprocessor_isAtStartOfMacroExpansion(x, loc, out) ?
           SourceLocation(out[]) : nothing
end

"""
    isAtEndOfMacroExpansion(x::AbstractPreprocessor, loc::SourceLocation) ->
        Union{SourceLocation,Nothing}
Return the end location of the macro when the macro location `loc` points at the last token
of its expansion, `nothing` otherwise. `loc` must be a valid macro location.
"""
function isAtEndOfMacroExpansion(x::AbstractPreprocessor, loc::SourceLocation)
    @check_ptrs x
    @assert isValid(loc) && isMacroID(loc) "expected a valid macro location"
    out = Ref{CXSourceLocation_}(C_NULL)
    return clang_Preprocessor_isAtEndOfMacroExpansion(x, loc, out) ?
           SourceLocation(out[]) : nothing
end

"""
    AdvanceToTokenCharacter(x::AbstractPreprocessor, tok_start::SourceLocation,
                            char_no::Integer) -> SourceLocation
Return the location of the `char_no`-th character within the token that starts at
`tok_start`.
"""
function AdvanceToTokenCharacter(x::AbstractPreprocessor, tok_start::SourceLocation,
                                 char_no::Integer)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_AdvanceToTokenCharacter(x, tok_start, char_no))
end

function getLastFPEvalPragmaLocation(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getLastFPEvalPragmaLocation(x))
end

function isInImportingCXXNamedModules(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isInImportingCXXNamedModules(x)
end

"""
    getModuleForLocation(x::AbstractPreprocessor, loc::SourceLocation,
                         allow_textual::Bool) -> Module_
Return the module that owns the code at `loc`. The result is borrowed and holds a NULL
pointer when the location is outside any module.
"""
function getModuleForLocation(x::AbstractPreprocessor, loc::SourceLocation,
                              allow_textual::Bool)
    @check_ptrs x
    return Module_(clang_Preprocessor_getModuleForLocation(x, loc, allow_textual))
end

function isRecordingPreamble(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isRecordingPreamble(x)
end

function hasRecordedPreamble(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_hasRecordedPreamble(x)
end

function isPPInSafeBufferOptOutRegion(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_isPPInSafeBufferOptOutRegion(x)
end


function setPreprocessToken(x::AbstractPreprocessor, preprocess::Bool)
    @check_ptrs x
    return clang_Preprocessor_setPreprocessToken(x, preprocess)
end

function IgnorePragmas(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_IgnorePragmas(x)
end

function recomputeCurLexerKind(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_recomputeCurLexerKind(x)
end

"""
    setSkipMainFilePreamble(x::AbstractPreprocessor, bytes::Integer, start_of_line::Bool)
Record that the first `bytes` bytes of the main file form a preamble that lexing skips;
`start_of_line` marks whether the token following the preamble begins a line.
"""
function setSkipMainFilePreamble(x::AbstractPreprocessor, bytes::Integer, start_of_line::Bool)
    @check_ptrs x
    return clang_Preprocessor_setSkipMainFilePreamble(x, bytes, start_of_line)
end

function IncrementPasteCounter(x::AbstractPreprocessor, is_fast::Bool)
    @check_ptrs x
    return clang_Preprocessor_IncrementPasteCounter(x, is_fast)
end

"""
    PoisonSEHIdentifiers(x::AbstractPreprocessor, poison::Bool=true)
Poison (or un-poison) the Borland SEH identifiers — `__exception_code`,
`__exception_info`, `__abnormal_termination` and their variants.

!!! warning
    Only valid when the preprocessor was created with Borland extensions
    (`-fborland-extensions`). Those nine `IdentifierInfo *` members carry no
    default initializer and are filled in only on the Borland path, while
    `Preprocessor::PoisonSEHIdentifiers` dereferences all of them unconditionally
    — calling it otherwise segfaults. The `@assert` below restates that.
"""
function PoisonSEHIdentifiers(x::AbstractPreprocessor, poison::Bool=true)
    @check_ptrs x
    @assert getBorland(getLangOpts(x)) "PoisonSEHIdentifiers requires -fborland-extensions"
    return clang_Preprocessor_PoisonSEHIdentifiers(x, poison)
end

"""
    AllocateMacroInfo(x::AbstractPreprocessor, loc::SourceLocation=SourceLocation()) -> MacroInfo
Allocate a fresh `MacroInfo` whose definition location is `loc`. The result is owned by the
preprocessor's arena and must not be disposed.
"""
function AllocateMacroInfo(x::AbstractPreprocessor, loc::SourceLocation=SourceLocation())
    @check_ptrs x
    return MacroInfo(clang_Preprocessor_AllocateMacroInfo(x, loc))
end

function markMacroAsUsed(x::AbstractPreprocessor, mi::AbstractMacroInfo)
    @check_ptrs x mi
    return clang_Preprocessor_markMacroAsUsed(x, mi)
end

"""
    isSafeBufferOptOut(x::AbstractPreprocessor, sm::AbstractSourceManager, loc::SourceLocation) -> Bool
Return whether `loc` lies inside a `-Wunsafe-buffer-usage` opt-out region. `loc` must be a
source location that has already been preprocessed.
"""
function isSafeBufferOptOut(x::AbstractPreprocessor, sm::AbstractSourceManager, loc::SourceLocation)
    @check_ptrs x sm
    return clang_Preprocessor_isSafeBufferOptOut(x, sm, loc)
end

"""
    enterOrExitSafeBufferOptOutRegion(x::AbstractPreprocessor, is_enter::Bool, loc::SourceLocation) -> Bool
Enter (`is_enter=true`) or exit (`is_enter=false`) a `-Wunsafe-buffer-usage` opt-out region
at `loc`. Returns `true` when the transition is invalid — entering before the previous
region is closed, or exiting while not inside a region.
"""
function enterOrExitSafeBufferOptOutRegion(x::AbstractPreprocessor, is_enter::Bool, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_enterOrExitSafeBufferOptOutRegion(x, is_enter, loc)
end


"""
    markIncluded(x::AbstractPreprocessor, file::FileEntryRef) -> Bool
Mark `file` as included by this translation unit and return `true` when this is the first
time it has been marked.
"""
function markIncluded(x::AbstractPreprocessor, file::FileEntryRef)
    @check_ptrs x file
    return clang_Preprocessor_markIncluded(x, file)
end

"""
    alreadyIncluded(x::AbstractPreprocessor, file::FileEntryRef) -> Bool
Return whether `file` has already been marked as included by this translation unit.
"""
function alreadyIncluded(x::AbstractPreprocessor, file::FileEntryRef)
    @check_ptrs x file
    return clang_Preprocessor_alreadyIncluded(x, file)
end

"""
    setCodeCompletionIdentifierInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
Install `ii` as the identifier that code-completion results are filtered against.
"""
function setCodeCompletionIdentifierInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_Preprocessor_setCodeCompletionIdentifierInfo(x, ii)
end

"""
    getCodeCompletionFilter(x::AbstractPreprocessor) -> String
Return the spelling of the code-completion filter identifier, or `""` when none is set.
"""
function getCodeCompletionFilter(x::AbstractPreprocessor)
    @check_ptrs x
    return get_string(clang_Preprocessor_getCodeCompletionFilter(x))
end

"""
    IsPreviousCachedToken(x::AbstractPreprocessor, tok::AbstractToken) -> Bool
Return whether `tok` is the most recently cached token. Always `false` when no tokens are
cached, i.e. outside a backtracking scope.
"""
function IsPreviousCachedToken(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    return clang_Preprocessor_IsPreviousCachedToken(x, tok)
end

"""
    TypoCorrectToken(x::AbstractPreprocessor, tok::AbstractToken)
Replace the most recently cached token with `tok`, caching the result of a typo correction.
A no-op unless backtracking is enabled and at least one token has been cached.

`tok` must carry an identifier, and must not be a raw identifier — `Token::getIdentifierInfo`
asserts the latter and `Preprocessor::TypoCorrectToken` the former. The `@assert` below
restates both, in that order, so the raw-identifier check runs first.
"""
function TypoCorrectToken(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    @assert !is_raw_identifier(tok) &&
            clang_Token_getIdentifierInfo(tok) != C_NULL "token must carry an identifier"
    return clang_Preprocessor_TypoCorrectToken(x, tok)
end

"""
    setCodeCompletionReached(x::AbstractPreprocessor)
Record that the code-completion point has been reached. Only valid once a code-completion
point has been requested (`isCodeCompletionEnabled`), which the `@assert` restates.
"""
function setCodeCompletionReached(x::AbstractPreprocessor)
    @check_ptrs x
    @assert isCodeCompletionEnabled(x) "code completion is not enabled"
    return clang_Preprocessor_setCodeCompletionReached(x)
end

"""
    getPragmaARCCFCodeAuditedIdent(x::AbstractPreprocessor) -> IdentifierInfo
Return the identifier of the currently-active `#pragma clang arc_cf_code_audited begin`.
The carrier holds NULL when no such pragma is active.
"""
function getPragmaARCCFCodeAuditedIdent(x::AbstractPreprocessor)
    @check_ptrs x
    return IdentifierInfo(clang_Preprocessor_getPragmaARCCFCodeAuditedIdent(x))
end

"""
    getPragmaARCCFCodeAuditedLoc(x::AbstractPreprocessor) -> SourceLocation
Return the location of the currently-active `#pragma clang arc_cf_code_audited begin`, or
an invalid location when no such pragma is active.
"""
function getPragmaARCCFCodeAuditedLoc(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getPragmaARCCFCodeAuditedLoc(x))
end

"""
    setPragmaARCCFCodeAuditedInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                  loc::SourceLocation)
Record `#pragma clang arc_cf_code_audited begin` for `ii` at `loc`. An invalid `loc` ends
the pragma.
"""
function setPragmaARCCFCodeAuditedInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                       loc::SourceLocation)
    @check_ptrs x ii
    return clang_Preprocessor_setPragmaARCCFCodeAuditedInfo(x, ii, loc)
end

"""
    setPreambleRecordedPragmaAssumeNonNullLoc(x::AbstractPreprocessor, loc::SourceLocation)
Record the location of the unterminated `#pragma clang assume_nonnull begin` left open by
the preamble. An invalid `loc` clears it.
"""
function setPreambleRecordedPragmaAssumeNonNullLoc(x::AbstractPreprocessor, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_setPreambleRecordedPragmaAssumeNonNullLoc(x, loc)
end

"""
    getSpellingOfSingleCharacterNumericConstant(x::AbstractPreprocessor,
                                                tok::AbstractToken) -> Union{Char,Nothing}
Return the single character `tok` is spelled with, or `nothing` when its character data
could not be read.

`tok` must be a `numeric_constant` of length 1 that needs no cleaning — Clang asserts all
three, which the `@assert` below restates.
"""
function getSpellingOfSingleCharacterNumericConstant(x::AbstractPreprocessor,
                                                     tok::AbstractToken)
    @check_ptrs x tok
    @assert is_numeric_constant(tok) && getLength(tok) == 1 &&
            !needsCleaning(tok) "expected a single-character numeric constant"
    invalid = Ref{Bool}(false)
    ch = clang_Preprocessor_getSpellingOfSingleCharacterNumericConstant(x, tok, invalid)
    return invalid[] ? nothing : Char(ch % UInt8)
end

"""
    CreateString(x::AbstractPreprocessor, str::AbstractString, tok::AbstractToken,
                 expansion_start::SourceLocation=SourceLocation(),
                 expansion_end::SourceLocation=SourceLocation())
Copy `str` into the preprocessor's scratch buffer and point `tok` at it, setting the
token's location and length. Leave both expansion locations unset for a plain scratch
token, or pass a valid pair to give the token a macro-expansion location.
"""
function CreateString(x::AbstractPreprocessor, str::AbstractString, tok::AbstractToken,
                      expansion_start::SourceLocation=SourceLocation(),
                      expansion_end::SourceLocation=SourceLocation())
    @check_ptrs x tok
    @assert isValid(expansion_start) == isValid(expansion_end) "expansion locations must both be set or both unset"
    return clang_Preprocessor_CreateString(x, str, tok, expansion_start, expansion_end)
end

"""
    SplitToken(x::AbstractPreprocessor, loc::SourceLocation, len::Integer) -> SourceLocation
Split the first `len` characters off the token starting at `loc` and return a location
naming the split token; re-lexing from it yields the split token rather than the original.
`loc` must be valid.
"""
function SplitToken(x::AbstractPreprocessor, loc::SourceLocation, len::Integer)
    @check_ptrs x
    @assert isValid(loc) "expected a valid token location"
    return SourceLocation(clang_Preprocessor_SplitToken(x, loc, len))
end

"""
    LookUpIdentifierInfo(x::AbstractPreprocessor, tok::AbstractToken) -> IdentifierInfo
Look up the identifier spelled by the raw-identifier token `tok`, install it — together
with the matching token kind — on `tok`, and return it.

`tok` must be a non-empty `tok::raw_identifier`; Clang asserts, which the `@assert` below
restates.
"""
function LookUpIdentifierInfo(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    @assert is_raw_identifier(tok) && getLength(tok) > 0 "expected a raw identifier token"
    return IdentifierInfo(clang_Preprocessor_LookUpIdentifierInfo(x, tok))
end

"""
    getCurrentFPEvalMethod(x::AbstractPreprocessor) -> CXFPEvalMethodKind
Return the floating-point evaluation method in effect at the current source location.

Only valid once the method has been set — `Preprocessor::Initialize` does that from the
target or the command line, and Clang asserts it is no longer `FEM_UnsetOnCommandLine`.
`setCurrentFPEvalMethod` always writes the translation-unit-wide method too, so an unset
`getTUFPEvalMethod` proves the current one is unset as well; the `@assert` uses it as the
observable gate.
"""
function getCurrentFPEvalMethod(x::AbstractPreprocessor)
    @check_ptrs x
    @assert getTUFPEvalMethod(x) !=
            CXFPEvalMethodKind_FEM_UnsetOnCommandLine "FP evaluation method is unset"
    return clang_Preprocessor_getCurrentFPEvalMethod(x)
end

"""
    getTUFPEvalMethod(x::AbstractPreprocessor) -> CXFPEvalMethodKind
Return the translation-unit-wide floating-point evaluation method.
"""
function getTUFPEvalMethod(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getTUFPEvalMethod(x)
end

"""
    setCurrentFPEvalMethod(x::AbstractPreprocessor, pragma_loc::SourceLocation,
                           val::CXFPEvalMethodKind)
Set the floating-point evaluation method from a `#pragma float_control` at `pragma_loc`;
this also updates the translation-unit-wide method. `val` must not be
`FEM_UnsetOnCommandLine` — Clang asserts, which the `@assert` restates.
"""
function setCurrentFPEvalMethod(x::AbstractPreprocessor, pragma_loc::SourceLocation,
                                val::CXFPEvalMethodKind)
    @check_ptrs x
    @assert val != CXFPEvalMethodKind_FEM_UnsetOnCommandLine "FEM_UnsetOnCommandLine is not settable"
    return clang_Preprocessor_setCurrentFPEvalMethod(x, pragma_loc, val)
end

"""
    setTUFPEvalMethod(x::AbstractPreprocessor, val::CXFPEvalMethodKind)
Set the translation-unit-wide floating-point evaluation method. `val` must not be
`FEM_UnsetOnCommandLine` — Clang asserts, which the `@assert` restates.
"""
function setTUFPEvalMethod(x::AbstractPreprocessor, val::CXFPEvalMethodKind)
    @check_ptrs x
    @assert val != CXFPEvalMethodKind_FEM_UnsetOnCommandLine "FEM_UnsetOnCommandLine is not settable"
    return clang_Preprocessor_setTUFPEvalMethod(x, val)
end

"""
    GetIncludeFilenameSpelling(x::AbstractPreprocessor, loc::SourceLocation,
                               spelling::AbstractString) -> (String, Bool)
Strip the `<>` or `""` delimiters off the `#include` filename `spelling` and return the
bare filename together with whether it was angled. A malformed spelling reports a
diagnostic at `loc` and comes back as `("", true)`.

`spelling` must be non-empty — Clang asserts, which the `@assert` restates.
"""
function GetIncludeFilenameSpelling(x::AbstractPreprocessor, loc::SourceLocation,
                                    spelling::AbstractString)
    @check_ptrs x
    @assert !isempty(spelling) "the include spelling must be non-empty"
    is_angled = Ref{Bool}(false)
    s = get_string(clang_Preprocessor_GetIncludeFilenameSpelling(x, loc, spelling, is_angled))
    return s, is_angled[]
end


"""
    setDiagnostics(x::AbstractPreprocessor, diags::AbstractDiagnosticsEngine)
Point the preprocessor at `diags`.

The engine is borrowed, not adopted: the preprocessor only stores the pointer, so `diags`
must outlive it and must not be disposed while it is installed.
"""
function setDiagnostics(x::AbstractPreprocessor, diags::AbstractDiagnosticsEngine)
    @check_ptrs x diags
    return clang_Preprocessor_setDiagnostics(x, diags)
end

"""
    isCurrentLexer(x::AbstractPreprocessor, lexer::AbstractPreprocessorLexer) -> Bool
Return whether `lexer` is the lexer the preprocessor is currently reading tokens from.
"""
function isCurrentLexer(x::AbstractPreprocessor, lexer::AbstractPreprocessorLexer)
    @check_ptrs x lexer
    return clang_Preprocessor_isCurrentLexer(x, lexer)
end

"""
    getCurrentLexer(x::AbstractPreprocessor) -> PreprocessorLexer
Return the lexer the preprocessor is currently reading tokens from. The returned carrier
wraps `C_NULL` while tokens are being served from a macro expansion or from the token
cache. The lexer is borrowed and must never be disposed.
"""
function getCurrentLexer(x::AbstractPreprocessor)
    @check_ptrs x
    return PreprocessorLexer(clang_Preprocessor_getCurrentLexer(x))
end

"""
    getCurrentFileLexer(x::AbstractPreprocessor) -> PreprocessorLexer
Return the innermost *file* lexer on the include stack, skipping macro and token-stream
lexers. The returned carrier wraps `C_NULL` when there is no file lexer, and is borrowed.
"""
function getCurrentFileLexer(x::AbstractPreprocessor)
    @check_ptrs x
    return PreprocessorLexer(clang_Preprocessor_getCurrentFileLexer(x))
end

"""
    LookAhead(x::AbstractPreprocessor, n::Integer, result::AbstractToken)
Copy the token `n` positions ahead of the next one to be lexed into `result` without
consuming anything; `n == 0` is the token `Lex` would return next.

Peeking pulls tokens into the preprocessor's cache, so this must not run from inside a
nested lexing action — Clang asserts `LexLevel == 0`, a state no accessor exposes, so the
precondition is documented rather than asserted.
"""
function LookAhead(x::AbstractPreprocessor, n::Integer, result::AbstractToken)
    @check_ptrs x result
    return clang_Preprocessor_LookAhead(x, n, result)
end

"""
    RevertCachedTokens(x::AbstractPreprocessor, n::Integer)
Rewind the cached token stream by `n` tokens.

Backtracking must be enabled and `n` must not reach past the last backtrack position —
Clang asserts both; only the first is observable and the `@assert` restates it.
"""
function RevertCachedTokens(x::AbstractPreprocessor, n::Integer)
    @check_ptrs x
    @assert isBacktrackEnabled(x) "EnableBacktrackAtThisPos must be called first"
    return clang_Preprocessor_RevertCachedTokens(x, n)
end

"""
    EnterToken(x::AbstractPreprocessor, tok::AbstractToken, is_reinject::Bool=true)
Push a copy of `tok` to be lexed next; a following `Backtrack` leaves it at the insertion
point. Outside a nested lexing action Clang asserts `is_reinject`, which is why it
defaults to `true`.
"""
function EnterToken(x::AbstractPreprocessor, tok::AbstractToken, is_reinject::Bool=true)
    @check_ptrs x tok
    return clang_Preprocessor_EnterToken(x, tok, is_reinject)
end

"""
    AnnotateCachedTokens(x::AbstractPreprocessor, tok::AbstractToken)
Replace the cached tokens back to the last backtrack position with the annotation token
`tok`; a no-op when backtracking is not enabled.

`tok` must be an annotation token — Clang asserts, which the `@assert` restates.
"""
function AnnotateCachedTokens(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    @assert isAnnotation(tok) "an annotation token is required"
    return clang_Preprocessor_AnnotateCachedTokens(x, tok)
end

"""
    getLastCachedTokenLocation(x::AbstractPreprocessor) -> SourceLocation
Return the location of the last cached token, suitable as the end location of an
annotation token.

At least one token must already have been cached: Clang asserts `CachedLexPos != 0`, and
the preprocessor exposes no accessor for that position, so this wrapper documents the
precondition instead of asserting it (see `MARSHALLING.md` section 13).
"""
function getLastCachedTokenLocation(x::AbstractPreprocessor)
    @check_ptrs x
    return SourceLocation(clang_Preprocessor_getLastCachedTokenLocation(x))
end

"""
    ReplaceLastTokenWithAnnotation(x::AbstractPreprocessor, tok::AbstractToken)
Replace only the most recent cached token with the annotation token `tok`; a no-op when
backtracking is not enabled.

`tok` must be an annotation token — Clang asserts, which the `@assert` restates.
"""
function ReplaceLastTokenWithAnnotation(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    @assert isAnnotation(tok) "an annotation token is required"
    return clang_Preprocessor_ReplaceLastTokenWithAnnotation(x, tok)
end

"""
    SetCodeCompletionPoint(x::AbstractPreprocessor, file::AbstractFileEntryRef,
                           line::Integer, column::Integer) -> Bool
Truncate `file` at `line`:`column` (both 1-based) and make that the code-completion point.
Returns `true` on error.

`line` and `column` must be non-zero and no code-completion point may have been set yet —
Clang asserts both, and the `@assert`s restate them (`isCodeCompletionEnabled` is the
observable gate for the second).
"""
function SetCodeCompletionPoint(x::AbstractPreprocessor, file::AbstractFileEntryRef,
                                line::Integer, column::Integer)
    @check_ptrs x file
    @assert line > 0 && column > 0 "line and column are 1-based"
    @assert !isCodeCompletionEnabled(x) "a code-completion point is already set"
    return clang_Preprocessor_SetCodeCompletionPoint(x, file, line, column)
end

"""
    SetPoisonReason(x::AbstractPreprocessor, ii::AbstractIdentifierInfo, diag_id::Integer)
Record the diagnostic reported in place of the default "poisoned identifier" one when the
poisoned identifier `ii` is used.
"""
function SetPoisonReason(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                         diag_id::Integer)
    @check_ptrs x ii
    return clang_Preprocessor_SetPoisonReason(x, ii, diag_id)
end

"""
    HandlePoisonedIdentifier(x::AbstractPreprocessor, tok::AbstractToken)
Report why `tok`'s identifier is poisoned. Nothing is reported when that identifier is not
poisoned.

`tok` must carry an identifier info — Clang asserts, which the `@assert` restates.
"""
function HandlePoisonedIdentifier(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    @assert getIdentifierInfo(tok).ptr != C_NULL "the token must carry an identifier info"
    return clang_Preprocessor_HandlePoisonedIdentifier(x, tok)
end

"""
    MaybeHandlePoisonedIdentifier(x::AbstractPreprocessor, tok::AbstractToken)
Report the poison reason for `tok`'s identifier when it has one and it is poisoned. Unlike
`HandlePoisonedIdentifier` this is a no-op for a token carrying no identifier info.
"""
function MaybeHandlePoisonedIdentifier(x::AbstractPreprocessor, tok::AbstractToken)
    @check_ptrs x tok
    return clang_Preprocessor_MaybeHandlePoisonedIdentifier(x, tok)
end

"""
    addMacroDeprecationMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                           msg::AbstractString, annotation_loc::SourceLocation)
Record the `#pragma clang deprecated` message reported when the macro named by `ii` is
expanded.
"""
function addMacroDeprecationMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                msg::AbstractString, annotation_loc::SourceLocation)
    @check_ptrs x ii
    return clang_Preprocessor_addMacroDeprecationMsg(x, ii, msg, annotation_loc)
end

"""
    addRestrictExpansionMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                            msg::AbstractString, annotation_loc::SourceLocation)
Record the `#pragma clang restrict_expansion` message reported when the macro named by
`ii` is expanded outside the main file.
"""
function addRestrictExpansionMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                 msg::AbstractString, annotation_loc::SourceLocation)
    @check_ptrs x ii
    return clang_Preprocessor_addRestrictExpansionMsg(x, ii, msg, annotation_loc)
end

"""
    addFinalLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                annotation_loc::SourceLocation)
Record the `#pragma clang final` location for the macro named by `ii`.
"""
function addFinalLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                     annotation_loc::SourceLocation)
    @check_ptrs x ii
    return clang_Preprocessor_addFinalLoc(x, ii, annotation_loc)
end

"""
    processPathForFileMacro(path::AbstractString, lang_opts::AbstractLangOptions,
                            target::AbstractTargetInfo) -> String
Apply the `__FILE__` path transformations — the `-ffile-prefix-map` remappings and, under
`-ffile-reproducible`, the target's preferred path separators — to `path`.

Static on `clang::Preprocessor`, so it takes no preprocessor receiver.
"""
function processPathForFileMacro(path::AbstractString, lang_opts::AbstractLangOptions,
                                 target::AbstractTargetInfo)
    @check_ptrs lang_opts target
    return get_string(clang_Preprocessor_processPathForFileMacro(path, lang_opts, target))
end


"""
    getSelectorTable(x::AbstractPreprocessor) -> SelectorTable
Return the Objective-C selector table this preprocessor owns. The result is borrowed.
"""
function getSelectorTable(x::AbstractPreprocessor)
    @check_ptrs x
    return SelectorTable(clang_Preprocessor_getSelectorTable(x))
end

"""
    DumpMacro(x::AbstractPreprocessor, mi::AbstractMacroInfo)
Write `mi`'s replacement tokens to stderr. A builtin macro has no replacement tokens and
dumps as an empty body.
"""
function DumpMacro(x::AbstractPreprocessor, mi::AbstractMacroInfo)
    @check_ptrs x mi
    return clang_Preprocessor_DumpMacro(x, mi)
end

"""
    dumpMacroInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
Write `ii`'s macro-definition history to stderr. Total — an identifier that never named a
macro dumps an empty state.
"""
function dumpMacroInfo(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_Preprocessor_dumpMacroInfo(x, ii)
end

"""
    isMacroDefinedInLocalModule(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                m::AbstractModule) -> Bool
Return whether `ii` is `#define`d inside the already-preprocessed module `m`. Macros merely
imported into `m` do not count, and a module this preprocessor never preprocessed answers
false.
"""
function isMacroDefinedInLocalModule(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                     m::AbstractModule)
    @check_ptrs x ii m
    return clang_Preprocessor_isMacroDefinedInLocalModule(x, ii, m)
end

"""
    getLocalMacroDirective(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> MacroDirective
Return `ii`'s latest non-imported macro directive. The result is borrowed and holds a NULL
pointer when `ii` is not currently `#define`d.
"""
function getLocalMacroDirective(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return MacroDirective(clang_Preprocessor_getLocalMacroDirective(x, ii))
end

"""
    getLocalMacroDirectiveHistory(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> MacroDirective
Return the head of `ii`'s local `#define`/`#undef` history. The result is borrowed and holds
a NULL pointer when `ii` has no history; a non-NULL head may itself be an `#undef`, so it
does not imply a live definition.
"""
function getLocalMacroDirectiveHistory(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return MacroDirective(clang_Preprocessor_getLocalMacroDirectiveHistory(x, ii))
end

"""
    getNumMacros(x::AbstractPreprocessor, include_external::Bool=true) -> Integer
Return the number of entries in the macro history table. Reading the table folds the
visible module macros into it, so the count can grow across calls even without lexing.
"""
function getNumMacros(x::AbstractPreprocessor, include_external::Bool=true)
    @check_ptrs x
    return clang_Preprocessor_getNumMacros(x, include_external)
end

"""
    getMacros(x::AbstractPreprocessor, include_external::Bool=true) -> Vector{IdentifierInfo}
Return the identifiers in the macro history table. An entry only records that the name once
named a macro — it may since have been `#undef`'d, so pair this with `getMacroInfo` or
`getLocalMacroDirective` to find the live definitions.
"""
function getMacros(x::AbstractPreprocessor, include_external::Bool=true)
    @check_ptrs x
    n = clang_Preprocessor_getNumMacros(x, include_external)
    buf = Vector{CXIdentifierInfo}(undef, n)
    n > 0 && clang_Preprocessor_getMacros(x, include_external, buf)
    return [IdentifierInfo(p) for p in buf]
end

"""
    markClangModuleAsAffecting(x::AbstractPreprocessor, m::AbstractModule)
Record `m` as affecting the module or translation unit currently being built. `m` must be a
module-map module — Clang asserts. The preprocessor keeps a borrowed pointer to `m`, so `m`
must outlive it.
"""
function markClangModuleAsAffecting(x::AbstractPreprocessor, m::AbstractModule)
    @check_ptrs x m
    @assert isModuleMapModule(m) "module must be a module-map module"
    return clang_Preprocessor_markClangModuleAsAffecting(x, m)
end

"""
    getNumIncludedFiles(x::AbstractPreprocessor) -> Integer
Return the number of files already `#include`d.
"""
function getNumIncludedFiles(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getNumIncludedFiles(x)
end

"""
    getIncludedFiles(x::AbstractPreprocessor) -> Vector{FileEntry}
Return the files already `#include`d. The entries are borrowed and their order is the
underlying hash set's — it carries no meaning.
"""
function getIncludedFiles(x::AbstractPreprocessor)
    @check_ptrs x
    n = clang_Preprocessor_getNumIncludedFiles(x)
    buf = Vector{CXFileEntry}(undef, n)
    n > 0 && clang_Preprocessor_getIncludedFiles(x, buf)
    return [FileEntry(p) for p in buf]
end

"""
    getPreprocessingRecord(x::AbstractPreprocessor) -> PreprocessingRecord
Return the record of macro expansions and definitions. The result is borrowed and holds a
NULL pointer until `createPreprocessingRecord` has run.
"""
function getPreprocessingRecord(x::AbstractPreprocessor)
    @check_ptrs x
    return PreprocessingRecord(clang_Preprocessor_getPreprocessingRecord(x))
end

"""
    createPreprocessingRecord(x::AbstractPreprocessor)
Install a preprocessing record that tracks every later macro expansion and definition. The
record is adopted by the preprocessor's callback chain — it is never disposed by the caller,
and the installation cannot be undone.
"""
function createPreprocessingRecord(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_createPreprocessingRecord(x)
end

"""
    makeModuleVisible(x::AbstractPreprocessor, m::AbstractModule, loc::SourceLocation)
Make `m` and everything it exports visible as of `loc`. `loc` must be valid unless `m` is a
global module fragment — Clang asserts. The preprocessor keeps a borrowed pointer to `m`, so
`m` must outlive it.
"""
function makeModuleVisible(x::AbstractPreprocessor, m::AbstractModule, loc::SourceLocation)
    @check_ptrs x m
    @assert isGlobalModule(m) || isValid(loc) "import location must be valid for a non-global module"
    return clang_Preprocessor_makeModuleVisible(x, m, loc)
end

"""
    getModuleImportLoc(x::AbstractPreprocessor, m::AbstractModule) -> SourceLocation
Return the location `m` was made visible at. The location is invalid when `m` never was.
"""
function getModuleImportLoc(x::AbstractPreprocessor, m::AbstractModule)
    @check_ptrs x m
    return SourceLocation(clang_Preprocessor_getModuleImportLoc(x, m))
end


"""
    getBuiltinInfo(x::AbstractPreprocessor) -> BuiltinContext
Return the builtin-function table this preprocessor owns. The result is borrowed and is
never NULL.
"""
function getBuiltinInfo(x::AbstractPreprocessor)
    @check_ptrs x
    return BuiltinContext(clang_Preprocessor_getBuiltinInfo(x))
end

"""
    setExternalSource(x::AbstractPreprocessor, src::AbstractExternalPreprocessorSource)
Attach `src` as the source of macros loaded from an AST file. The preprocessor only borrows
the pointer, so `src` must outlive it; a NULL carrier detaches the current source.
"""
function setExternalSource(x::AbstractPreprocessor, src::AbstractExternalPreprocessorSource)
    @check_ptrs x
    return clang_Preprocessor_setExternalSource(x, src)
end

"""
    getExternalSource(x::AbstractPreprocessor) -> ExternalPreprocessorSource
Return the source of macros loaded from an AST file. The result is borrowed and holds a NULL
pointer when no source is attached.
"""
function getExternalSource(x::AbstractPreprocessor)
    @check_ptrs x
    return ExternalPreprocessorSource(clang_Preprocessor_getExternalSource(x))
end

"""
    getModuleLoader(x::AbstractPreprocessor) -> ModuleLoader
Return the module loader this preprocessor was constructed with. The result is borrowed and
is never NULL.
"""
function getModuleLoader(x::AbstractPreprocessor)
    @check_ptrs x
    return ModuleLoader(clang_Preprocessor_getModuleLoader(x))
end

"""
    getPPCallbacks(x::AbstractPreprocessor) -> PPCallbacks
Return the head of the preprocessor's callback chain. The chain is owned by the preprocessor,
so the result is borrowed; it holds a NULL pointer when no callback is installed.
"""
function getPPCallbacks(x::AbstractPreprocessor)
    @check_ptrs x
    return PPCallbacks(clang_Preprocessor_getPPCallbacks(x))
end

"""
    isMacroDefinitionAmbiguous(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> Bool
Return whether `ii`'s macro definition is ambiguous — several visible module macros define it
and none overrides the others. `false` when `ii` names no macro.
"""
function isMacroDefinitionAmbiguous(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_Preprocessor_isMacroDefinitionAmbiguous(x, ii)
end

"""
    appendDefMacroDirective(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                            mi::AbstractMacroInfo,
                            loc::SourceLocation=getDefinitionLoc(mi)) -> MacroDirective
Define `ii` as the macro `mi` at `loc` by pushing a fresh `DefMacroDirective` onto `ii`'s
macro-definition history. The directive lives in the preprocessor's arena, so the result is
borrowed and typed at the `MacroDirective` base.
"""
function appendDefMacroDirective(x::AbstractPreprocessor, ii::AbstractIdentifierInfo,
                                 mi::AbstractMacroInfo,
                                 loc::SourceLocation=getDefinitionLoc(mi))
    @check_ptrs x ii mi
    return MacroDirective(clang_Preprocessor_appendDefMacroDirective(x, ii, mi, loc))
end

"""
    setEmptylineHandler(x::AbstractPreprocessor, h::AbstractEmptylineHandler)
Install `h` as the handler invoked for empty lines. The preprocessor only borrows the
pointer, so `h` must outlive it; a NULL carrier detaches the current handler.
"""
function setEmptylineHandler(x::AbstractPreprocessor, h::AbstractEmptylineHandler)
    @check_ptrs x
    return clang_Preprocessor_setEmptylineHandler(x, h)
end

"""
    getEmptylineHandler(x::AbstractPreprocessor) -> EmptylineHandler
Return the handler invoked for empty lines. The result is borrowed and holds a NULL pointer
when no handler is installed.
"""
function getEmptylineHandler(x::AbstractPreprocessor)
    @check_ptrs x
    return EmptylineHandler(clang_Preprocessor_getEmptylineHandler(x))
end

"""
    getCodeCompletionHandler(x::AbstractPreprocessor) -> CodeCompletionHandler
Return the handler invoked at the code-completion point. The result is borrowed and holds a
NULL pointer when no handler is installed.
"""
function getCodeCompletionHandler(x::AbstractPreprocessor)
    @check_ptrs x
    return CodeCompletionHandler(clang_Preprocessor_getCodeCompletionHandler(x))
end

"""
    clearCodeCompletionHandler(x::AbstractPreprocessor)
Detach the code-completion handler. The handler is not owned by the preprocessor and is left
untouched.
"""
function clearCodeCompletionHandler(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_clearCodeCompletionHandler(x)
end

"""
    emitMacroExpansionWarnings(x::AbstractPreprocessor, tok::AbstractToken,
                               is_ifndef::Bool=false)
Emit the deprecation, restricted-expansion and `INFINITY`/`NAN` warnings registered for the
macro `tok` names. `tok` must carry an identifier info — the method dereferences it without a
null check. Pass `is_ifndef=true` from an `#ifndef` context to suppress the `INFINITY`/`NAN`
warnings, which do not apply there.
"""
function emitMacroExpansionWarnings(x::AbstractPreprocessor, tok::AbstractToken,
                                    is_ifndef::Bool=false)
    @check_ptrs x tok
    @assert getIdentifierInfo(tok).ptr != C_NULL "the token must carry an identifier info"
    return clang_Preprocessor_emitMacroExpansionWarnings(x, tok, is_ifndef)
end


"""
    getNumBuildingSubmodules(x::AbstractPreprocessor) -> Integer
Return the number of submodules currently being built.
"""
function getNumBuildingSubmodules(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getNumBuildingSubmodules(x)
end

"""
    getBuildingSubmodules(x::AbstractPreprocessor) ->
        Vector{Tuple{Module_,SourceLocation,Bool}}
Return the stack of submodules currently being built, outermost first. Each entry holds the
submodule, the location it was entered at, and whether it was entered through a
`#pragma clang module` rather than an import. The modules are borrowed.
"""
function getBuildingSubmodules(x::AbstractPreprocessor)
    @check_ptrs x
    n = clang_Preprocessor_getNumBuildingSubmodules(x)
    mods = Vector{CXModule}(undef, n)
    locs = Vector{CXSourceLocation_}(undef, n)
    pragmas = Vector{Bool}(undef, n)
    n > 0 && clang_Preprocessor_getBuildingSubmodules(x, mods, locs, pragmas)
    return [(Module_(mods[i]), SourceLocation(locs[i]), pragmas[i]) for i in 1:n]
end

"""
    getNumAffectingClangModules(x::AbstractPreprocessor) -> Integer
Return the number of top-level clang modules that affected preprocessing without being
imported.
"""
function getNumAffectingClangModules(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getNumAffectingClangModules(x)
end

"""
    getAffectingClangModules(x::AbstractPreprocessor) -> Vector{Module_}
Return the top-level clang modules that affected preprocessing without being imported, as
recorded by `markClangModuleAsAffecting`. The modules are borrowed and their order is the
underlying set's — it carries no meaning.
"""
function getAffectingClangModules(x::AbstractPreprocessor)
    @check_ptrs x
    n = clang_Preprocessor_getNumAffectingClangModules(x)
    buf = Vector{CXModule}(undef, n)
    n > 0 && clang_Preprocessor_getAffectingClangModules(x, buf)
    return [Module_(p) for p in buf]
end

"""
    isPCHThroughHeader(x::AbstractPreprocessor, fe::AbstractFileEntry) -> Bool
Return whether `fe` is the PCH through-header. A through-header must be configured —
`creatingPCHWithThroughHeader` or `usingPCHWithThroughHeader` — because the setting is read
unconditionally and the answer is meaningless without one.
"""
function isPCHThroughHeader(x::AbstractPreprocessor, fe::AbstractFileEntry)
    @check_ptrs x fe
    @assert creatingPCHWithThroughHeader(x) || usingPCHWithThroughHeader(x) "a PCH through-header must be configured"
    return clang_Preprocessor_isPCHThroughHeader(x, fe)
end

"""
    getNumPreambleConditionals(x::AbstractPreprocessor) -> Integer
Return the number of `#if` conditionals recorded as still open at the end of the preamble.
"""
function getNumPreambleConditionals(x::AbstractPreprocessor)
    @check_ptrs x
    return clang_Preprocessor_getNumPreambleConditionals(x)
end

"""
    getPreambleConditionalStack(x::AbstractPreprocessor) ->
        Vector{Tuple{SourceLocation,Bool,Bool,Bool}}
Return the recorded preamble conditional stack, outermost first. Each entry holds where the
conditional started, whether it sat inside a skipped block, whether tokens were already
emitted for it, and whether its `#else` has been seen.
"""
function getPreambleConditionalStack(x::AbstractPreprocessor)
    @check_ptrs x
    n = clang_Preprocessor_getNumPreambleConditionals(x)
    locs = Vector{CXSourceLocation_}(undef, n)
    was_skipping = Vector{Bool}(undef, n)
    found_non_skip = Vector{Bool}(undef, n)
    found_else = Vector{Bool}(undef, n)
    n > 0 && clang_Preprocessor_getPreambleConditionalStack(x, locs, was_skipping,
                                                            found_non_skip, found_else)
    return [(SourceLocation(locs[i]), was_skipping[i], found_non_skip[i], found_else[i])
            for i in 1:n]
end

"""
    setRecordedPreambleConditionalStack(x::AbstractPreprocessor, stack::AbstractVector)
Replace the recorded preamble conditional stack with `stack`, a vector of
`(SourceLocation, was_skipping, found_non_skip, found_else)` tuples shaped like what
`getPreambleConditionalStack` returns. Clang keeps the new stack only while the store is
recording or replaying a preamble (`isRecordingPreamble`); the call is inert otherwise.
"""
function setRecordedPreambleConditionalStack(x::AbstractPreprocessor, stack::AbstractVector)
    @check_ptrs x
    n = length(stack)
    locs = Vector{CXSourceLocation_}(undef, n)
    was_skipping = Vector{Bool}(undef, n)
    found_non_skip = Vector{Bool}(undef, n)
    found_else = Vector{Bool}(undef, n)
    for (i, entry) in enumerate(stack)
        loc, skipping, non_skip, saw_else = entry
        locs[i] = loc.ptr
        was_skipping[i] = skipping
        found_non_skip[i] = non_skip
        found_else[i] = saw_else
    end
    return clang_Preprocessor_setRecordedPreambleConditionalStack(x, locs, was_skipping,
                                                                  found_non_skip,
                                                                  found_else, n)
end

"""
    getPreambleSkipInfo(x::AbstractPreprocessor) ->
        Union{Tuple{SourceLocation,SourceLocation,Bool,Bool,SourceLocation},Nothing}
Return the record of the preamble conditional that was still being skipped at end of file —
the `#` token location, the `#if` token location, whether a non-skipped portion was found,
whether an `#else` was seen, and the `#else` location — or `nothing` when no such
conditional was recorded.
"""
function getPreambleSkipInfo(x::AbstractPreprocessor)
    @check_ptrs x
    hash_loc = Ref{CXSourceLocation_}(C_NULL)
    if_loc = Ref{CXSourceLocation_}(C_NULL)
    found_non_skip = Ref{Bool}(false)
    found_else = Ref{Bool}(false)
    else_loc = Ref{CXSourceLocation_}(C_NULL)
    clang_Preprocessor_getPreambleSkipInfo(x, hash_loc, if_loc, found_non_skip, found_else,
                                           else_loc) || return nothing
    return (SourceLocation(hash_loc[]), SourceLocation(if_loc[]), found_non_skip[],
            found_else[], SourceLocation(else_loc[]))
end

"""
    setCodeCompletionHandler(x::AbstractPreprocessor, h::AbstractCodeCompletionHandler)
Install `h` as the handler invoked at the code-completion point. The preprocessor only
borrows the pointer, so `h` must outlive it; `clearCodeCompletionHandler` detaches it again.
`h` must be non-NULL — Clang takes the handler by reference.
"""
function setCodeCompletionHandler(x::AbstractPreprocessor, h::AbstractCodeCompletionHandler)
    @check_ptrs x h
    return clang_Preprocessor_setCodeCompletionHandler(x, h)
end


"""
    addModuleMacro(x::AbstractPreprocessor, m::AbstractModule, ii::AbstractIdentifierInfo,
                   mi::AbstractMacroInfo, overrides::AbstractVector=ModuleMacro[]) ->
        Tuple{ModuleMacro,Bool}
Register `mi` as the macro module `m` exports under the name `ii`, overriding the module
macros in `overrides`. Return the registration together with whether it is new: an
identical `(module, name, macro, overrides)` tuple folds onto the node that already exists
and reports `false`. The result is preprocessor-arena memory — borrowed, never disposed.
"""
function addModuleMacro(x::AbstractPreprocessor, m::AbstractModule,
                        ii::AbstractIdentifierInfo, mi::AbstractMacroInfo,
                        overrides::AbstractVector=ModuleMacro[])
    @check_ptrs x m ii mi
    n = length(overrides)
    buf = Vector{CXModuleMacro}(undef, n)
    for (i, o) in enumerate(overrides)
        @check_ptrs o
        buf[i] = o.ptr
    end
    is_new = Ref{Bool}(false)
    mm = clang_Preprocessor_addModuleMacro(x, m, ii, mi, buf, n, is_new)
    return ModuleMacro(mm), is_new[]
end

"""
    getModuleMacro(x::AbstractPreprocessor, m::AbstractModule,
                   ii::AbstractIdentifierInfo) -> ModuleMacro
Return the macro module `m` exports under the name `ii`, or a NULL carrier when it exports
none. The result is preprocessor-arena memory — borrowed, never disposed.
"""
function getModuleMacro(x::AbstractPreprocessor, m::AbstractModule,
                        ii::AbstractIdentifierInfo)
    @check_ptrs x m ii
    return ModuleMacro(clang_Preprocessor_getModuleMacro(x, m, ii))
end

"""
    getNumLeafModuleMacros(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> UInt32
Return how many leaf (non-overridden) module macros are visible for the name `ii`.
"""
function getNumLeafModuleMacros(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    return clang_Preprocessor_getNumLeafModuleMacros(x, ii)
end

"""
    getLeafModuleMacros(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) ->
        Vector{ModuleMacro}
Return the leaf (non-overridden) module macros visible for the name `ii`. Every entry is
preprocessor-arena memory — borrowed, never disposed.
"""
function getLeafModuleMacros(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    n = clang_Preprocessor_getNumLeafModuleMacros(x, ii)
    buf = Vector{CXModuleMacro}(undef, n)
    n > 0 && clang_Preprocessor_getLeafModuleMacros(x, ii, buf)
    return [ModuleMacro(p) for p in buf]
end

"""
    getLastMacroWithSpelling(x::AbstractPreprocessor, loc::SourceLocation,
                             tokens::AbstractVector) -> String
Return the name of the last object-like macro defined before `loc` whose replacement tokens
equal `tokens`, or the empty string when none does. Each element of `tokens` is either an
`AbstractIdentifierInfo` (an identifier token) or an integer `clang::tok::TokenKind` value.
`loc` must be valid — the macro directive history lookup asserts on an invalid location —
and a kind must be neither an identifier nor a literal nor an annotation, all three of
which Clang asserts while building the token value.
"""
function getLastMacroWithSpelling(x::AbstractPreprocessor, loc::SourceLocation,
                                  tokens::AbstractVector)
    @check_ptrs x
    @assert isValid(loc) "location must be valid: the macro directive history asserts on it"
    n = length(tokens)
    kinds = zeros(Cuint, n)
    iis = Vector{CXIdentifierInfo}(undef, n)
    fill!(iis, C_NULL)
    for (i, t) in enumerate(tokens)
        if t isa AbstractIdentifierInfo
            @check_ptrs t
            iis[i] = t.ptr
        else
            @assert t isa Integer "a token is either an IdentifierInfo or a tok::TokenKind value"
            k = Cuint(t)
            @assert !isAnyIdentifier(k) "an identifier must be given as an IdentifierInfo"
            @assert !isLiteral(k) "literal token kinds are not supported"
            @assert !isAnnotation(k) "annotation token kinds are not supported"
            kinds[i] = k
        end
    end
    return get_string(clang_Preprocessor_getLastMacroWithSpelling(x, loc, kinds, iis, n))
end

"""
    checkModuleIsAvailable(lang_opts::AbstractLangOptions, target::AbstractTargetInfo,
                           m::AbstractModule, diags::AbstractDiagnosticsEngine) -> Bool
Return `true` when the check FAILED — `m` is not usable — and report a diagnostic naming
the unmet requirement, the missing header or the shadowing module through `diags`. A module
built by hand has no module map behind it, so whether it counts as available is
host-decided.
"""
function checkModuleIsAvailable(lang_opts::AbstractLangOptions, target::AbstractTargetInfo,
                                m::AbstractModule, diags::AbstractDiagnosticsEngine)
    @check_ptrs lang_opts target m diags
    return clang_Preprocessor_checkModuleIsAvailable(lang_opts, target, m, diags)
end

"""
    getHeaderToIncludeForDiagnostics(x::AbstractPreprocessor, inc_loc::SourceLocation,
                                     m_loc::SourceLocation) -> Union{FileEntryRef,Nothing}
Return the header to `#include` at `inc_loc` so that the entity at `m_loc` becomes
reachable, or `nothing` when no such header exists or when importing a module is the right
answer instead. This is not fast and may load module maps that were not otherwise needed,
so it belongs on a path that is already about to report an error. This function allocates
and one should call `dispose` to release the resources after using this object.
"""
function getHeaderToIncludeForDiagnostics(x::AbstractPreprocessor, inc_loc::SourceLocation,
                                          m_loc::SourceLocation)
    @check_ptrs x
    ref = clang_Preprocessor_getHeaderToIncludeForDiagnostics(x, inc_loc, m_loc)
    return ref == C_NULL ? nothing : FileEntryRef(ref)
end

"""
    getMacroDeprecationLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) ->
        Union{SourceLocation,Nothing}
Return where the `#pragma clang deprecated` annotation for the macro named by `ii` was
written, or `nothing` when no deprecation was recorded for it. `ii` must already carry a
macro annotation: Clang looks the annotation entry up without checking that it exists, and
its own gate is the identifier's annotation flags, which its pragma handlers set alongside
the matching `addMacroDeprecationMsg`/`addRestrictExpansionMsg`/`addFinalLoc` call.
"""
function getMacroDeprecationLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    @assert isDeprecatedMacro(ii) || isRestrictExpansion(ii) || isFinal(ii) "no annotation"
    loc = Ref{CXSourceLocation_}(C_NULL)
    clang_Preprocessor_getMacroDeprecationLoc(x, ii, loc) || return nothing
    return SourceLocation(loc[])
end

"""
    getMacroDeprecationMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) -> String
Return the `#pragma clang deprecated` message recorded for the macro named by `ii`, or the
empty string when no deprecation was recorded for it. `ii` must already carry a macro
annotation — see `getMacroDeprecationLoc` for why.
"""
function getMacroDeprecationMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    @assert isDeprecatedMacro(ii) || isRestrictExpansion(ii) || isFinal(ii) "no annotation"
    return get_string(clang_Preprocessor_getMacroDeprecationMsg(x, ii))
end

"""
    getMacroRestrictExpansionLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) ->
        Union{SourceLocation,Nothing}
Return where the `#pragma clang restrict_expansion` annotation for the macro named by `ii`
was written, or `nothing` when no restriction was recorded for it. `ii` must already carry
a macro annotation — see `getMacroDeprecationLoc` for why.
"""
function getMacroRestrictExpansionLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    @assert isDeprecatedMacro(ii) || isRestrictExpansion(ii) || isFinal(ii) "no annotation"
    loc = Ref{CXSourceLocation_}(C_NULL)
    clang_Preprocessor_getMacroRestrictExpansionLoc(x, ii, loc) || return nothing
    return SourceLocation(loc[])
end

"""
    getMacroRestrictExpansionMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) ->
        String
Return the `#pragma clang restrict_expansion` message recorded for the macro named by `ii`,
or the empty string when no restriction was recorded for it. `ii` must already carry a
macro annotation — see `getMacroDeprecationLoc` for why.
"""
function getMacroRestrictExpansionMsg(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    @assert isDeprecatedMacro(ii) || isRestrictExpansion(ii) || isFinal(ii) "no annotation"
    return get_string(clang_Preprocessor_getMacroRestrictExpansionMsg(x, ii))
end

"""
    getMacroFinalAnnotationLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo) ->
        Union{SourceLocation,Nothing}
Return where the `#pragma clang final` annotation for the macro named by `ii` was written,
or `nothing` when no final annotation was recorded for it. `ii` must already carry a macro
annotation — see `getMacroDeprecationLoc` for why.
"""
function getMacroFinalAnnotationLoc(x::AbstractPreprocessor, ii::AbstractIdentifierInfo)
    @check_ptrs x ii
    @assert isDeprecatedMacro(ii) || isRestrictExpansion(ii) || isFinal(ii) "no annotation"
    loc = Ref{CXSourceLocation_}(C_NULL)
    clang_Preprocessor_getMacroFinalAnnotationLoc(x, ii, loc) || return nothing
    return SourceLocation(loc[])
end
