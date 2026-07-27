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
