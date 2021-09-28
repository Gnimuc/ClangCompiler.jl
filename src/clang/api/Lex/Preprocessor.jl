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
