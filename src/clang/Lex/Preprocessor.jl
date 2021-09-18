"""
    struct Preprocessor <: Any
Hold a pointer to a `clang::Preprocessor` object.
"""
struct Preprocessor
    ptr::CXPreprocessor
end

function enter_main_file(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_EnterMainSourceFile(x.ptr)
end

function enter_file(x::Preprocessor, id::FileID, loc::SourceLocation=SourceLocation())
    @check_ptrs x id
    return clang_Preprocessor_EnterSourceFile(x.ptr, id.ptr, loc.ptr)
end

function end_file(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_EndSourceFile(x.ptr)
end

function get_header_search(x::Preprocessor)
    @check_ptrs x
    return HeaderSearch(clang_Preprocessor_getHeaderSearchInfo(x.ptr))
end

function PrintStats(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_PrintStats(x.ptr)
end

function initialize_builtins(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_InitializeBuiltins(x.ptr)
end

function is_incremental(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_isIncrementalProcessingEnabled(x.ptr)
end

function enable_incremental(x::Preprocessor)
    @check_ptrs x
    return clang_Preprocessor_enableIncrementalProcessing(x.ptr)
end

function begin_source_file(consumer::T, lang::LangOptions,
                           pp::Preprocessor) where {T<:AbstractDiagnosticConsumer}
    @check_ptrs pp
    return begin_source_file(consumer, lang, pp.ptr)
end

function dump(x::Preprocessor, tok::Token, flag=false)
    @check_ptrs x
    return clang_Preprocessor_DumpToken(x.ptr, tok.ptr, flag)
end

function dump(x::Preprocessor, loc::SourceLocation)
    @check_ptrs x
    return clang_Preprocessor_DumpLocation(x.ptr, loc.ptr)
end
