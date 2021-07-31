"""
    mutable struct HeaderSearchOptions <: Any
Holds a pointer to a `clang::HeaderSearchOptions` object.
"""
mutable struct HeaderSearchOptions
    ptr::CXHeaderSearchOptions
end

function get_resource_dir(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    n = clang_HeaderSearchOptions_GetResourceDirLength(x.ptr)
    dir = Vector{Cuchar}(undef, n)
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, n)
    return String(dir)
end

function set_resource_dir(x::HeaderSearchOptions, dir::String)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    clang_HeaderSearchOptions_GetResourceDir(x.ptr, dir, length(dir))
    return nothing
end

function status(x::HeaderSearchOptions)
    @assert x.ptr != C_NULL "HeaderSearchOptions has a NULL pointer."
    return clang_HeaderSearchOptions_PrintStats(x.ptr)
end

"""
    mutable struct PreprocessorOptions <: Any
Holds a pointer to a `clang::PreprocessorOptions` object.
"""
mutable struct PreprocessorOptions
    ptr::CXPreprocessorOptions
end

function status(x::PreprocessorOptions)
    @assert x.ptr != C_NULL "PreprocessorOptions has a NULL pointer."
    return clang_PreprocessorOptions_PrintStats(x.ptr)
end

"""
    mutable struct HeaderSearch <: Any
Holds a pointer to a `clang::HeaderSearch` object.
"""
mutable struct HeaderSearch
    ptr::CXHeaderSearch
end

function status(x::HeaderSearch)
    @assert x.ptr != C_NULL "HeaderSearch has a NULL pointer."
    return clang_HeaderSearch_PrintStats(x.ptr)
end

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

function enter_file(x::Preprocessor, id::FileID)
    @assert x.ptr != C_NULL "Preprocessor has a NULL pointer."
    @assert id.ptr != C_NULL "FileID has a NULL pointer."
    return clang_Preprocessor_EnterSourceFile(x.ptr, id.ptr)
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
