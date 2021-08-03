"""
    mutable struct Preprocessor <: Any
Holds a pointer to a `clang::Preprocessor` object.
"""
mutable struct Preprocessor
    ptr::CXPreprocessor
end

function enter_main_file(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_EnterMainSourceFile(x.ptr)
end

function enter_file(x::Preprocessor, id::FileID, loc::SourceLocation=SourceLocation())
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    @assert id.ptr != C_NULL "FileID has a NULL pointer."
    return clang_Preprocessor_EnterSourceFile(x.ptr, id.ptr, loc.ptr)
end

function end_file(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_EndSourceFile(x.ptr)
end

function get_header_search(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return HeaderSearch(clang_Preprocessor_getHeaderSearchInfo(x.ptr))
end

function status(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_PrintStats(x.ptr)
end

function initialize_builtins(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_InitializeBuiltins(x.ptr)
end

function is_incremental(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_isIncrementalProcessingEnabled(x.ptr)
end

function enable_incremental(x::Preprocessor)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_enableIncrementalProcessing(x.ptr)
end

function begin_source_file(consumer::T, lang::LangOptions,
                           pp::Preprocessor) where {T<:AbstractDiagnosticConsumer}
    @assert pp.ptr != C_NULL "Preprocessor has a NULL pointer."
    return begin_source_file(consumer, lang, pp.ptr)
end

function dump(x::Preprocessor, tok::Token, flag=false)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_DumpToken(x.ptr, tok.ptr, flag)
end

function dump(x::Preprocessor, loc::SourceLocation)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    return clang_Preprocessor_DumpLocation(x.ptr, loc.ptr)
end
