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
