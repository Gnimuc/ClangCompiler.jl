# PreprocessorOptions
"""
    getIncludes(x::PreprocessorOptions) -> Vector{String}
Return the list of files forcibly included before any main source file.
"""
function getIncludes(x::PreprocessorOptions)
    @check_ptrs x
    n = clang_PreprocessorOptions_getIncludesNum(x)
    incs = Vector{Ptr{Cchar}}(undef, n)
    n > 0 && clang_PreprocessorOptions_getIncludes(x, incs, n)
    return unsafe_string.(incs)
end
"""
    getUsePredefines(x::AbstractPreprocessorOptions) -> Bool
Return whether the preprocessor is initialized with the compiler and target predefines.
"""
function getUsePredefines(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getUsePredefines(x)
end

function setUsePredefines(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setUsePredefines(x, value)
    return nothing
end

"""
    getDetailedRecord(x::AbstractPreprocessorOptions) -> Bool
Return whether a detailed record of macro definitions and expansions is kept. This is the
option `createPreprocessingRecord` needs to have been asked for.
"""
function getDetailedRecord(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getDetailedRecord(x)
end

function setDetailedRecord(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setDetailedRecord(x, value)
    return nothing
end

"""
    getPCHWithHdrStop(x::AbstractPreprocessorOptions) -> Bool
Return whether a `#pragma hdrstop` is expected to mark the PCH boundary.
"""
function getPCHWithHdrStop(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getPCHWithHdrStop(x)
end

function setPCHWithHdrStop(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setPCHWithHdrStop(x, value)
    return nothing
end

"""
    getPCHWithHdrStopCreate(x::AbstractPreprocessorOptions) -> Bool
Return whether a missing `#pragma hdrstop` is tolerated while creating the PCH.
"""
function getPCHWithHdrStopCreate(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getPCHWithHdrStopCreate(x)
end

function setPCHWithHdrStopCreate(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setPCHWithHdrStopCreate(x, value)
    return nothing
end

"""
    getPCHThroughHeader(x::AbstractPreprocessorOptions) -> String
Return the MSVC-style "through header", or `""` when there is none.
"""
function getPCHThroughHeader(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return get_string(clang_PreprocessorOptions_getPCHThroughHeader(x))
end

"""
    setPCHThroughHeader(x::AbstractPreprocessorOptions, header::AbstractString)
Set the filename whose `#include` bounds an MSVC-style precompiled header: PCH generation
stops after it, and PCH use skips tokens until it is seen.
"""
function setPCHThroughHeader(x::AbstractPreprocessorOptions, header::AbstractString)
    @check_ptrs x
    clang_PreprocessorOptions_setPCHThroughHeader(x, header)
    return nothing
end

"""
    getImplicitPCHInclude(x::AbstractPreprocessorOptions) -> String
Return the precompiled header implicitly included at the start of the translation unit, or
`""` when there is none.
"""
function getImplicitPCHInclude(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return get_string(clang_PreprocessorOptions_getImplicitPCHInclude(x))
end

"""
    setImplicitPCHInclude(x::AbstractPreprocessorOptions, path::AbstractString)
Make the compiler instance consume the precompiled header at `path`. This is the option a
PCH-reading instance is configured through; pair it with
[`setDisablePCHOrModuleValidation`](@ref) and [`setAllowPCHWithCompilerErrors`](@ref) when
the PCH was not produced by an identical invocation.
"""
function setImplicitPCHInclude(x::AbstractPreprocessorOptions, path::AbstractString)
    @check_ptrs x
    clang_PreprocessorOptions_setImplicitPCHInclude(x, path)
    return nothing
end

"""
    getDisablePCHOrModuleValidation(x::AbstractPreprocessorOptions) -> CXDisableValidationForModuleKind
Return which of the normal precompiled-header and module-file validations are disabled.
"""
function getDisablePCHOrModuleValidation(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getDisablePCHOrModuleValidation(x)
end

function setDisablePCHOrModuleValidation(x::AbstractPreprocessorOptions,
                                         kind::CXDisableValidationForModuleKind)
    @check_ptrs x
    clang_PreprocessorOptions_setDisablePCHOrModuleValidation(x, kind)
    return nothing
end

"""
    getAllowPCHWithCompilerErrors(x::AbstractPreprocessorOptions) -> Bool
Return whether a precompiled header that was written despite compiler errors is accepted.
"""
function getAllowPCHWithCompilerErrors(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getAllowPCHWithCompilerErrors(x)
end

function setAllowPCHWithCompilerErrors(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setAllowPCHWithCompilerErrors(x, value)
    return nothing
end

"""
    getAllowPCHWithDifferentModulesCachePath(x::AbstractPreprocessorOptions) -> Bool
Return whether a precompiled header built against another module cache is accepted.
"""
function getAllowPCHWithDifferentModulesCachePath(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getAllowPCHWithDifferentModulesCachePath(x)
end

function setAllowPCHWithDifferentModulesCachePath(x::AbstractPreprocessorOptions,
                                                  value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setAllowPCHWithDifferentModulesCachePath(x, value)
    return nothing
end

"""
    getPrecompiledPreambleBytes(x::AbstractPreprocessorOptions) -> Tuple{Cuint,Bool}
Return how many bytes of the main file the precompiled preamble covers, and whether the
preamble ends at the start of a new line. The count is zero when the implicit PCH is a
whole precompiled header rather than a preamble.
"""
function getPrecompiledPreambleBytes(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return (clang_PreprocessorOptions_getPrecompiledPreambleSize(x),
            clang_PreprocessorOptions_getPrecompiledPreambleEndsAtStartOfLine(x))
end

"""
    setPrecompiledPreambleBytes(x::AbstractPreprocessorOptions, size::Integer, ends_at_start_of_line::Bool)
Declare that the implicit PCH is a preamble covering the first `size` bytes of the main
file.
"""
function setPrecompiledPreambleBytes(x::AbstractPreprocessorOptions, size::Integer,
                                     ends_at_start_of_line::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setPrecompiledPreambleBytes(x, size, ends_at_start_of_line)
    return nothing
end

"""
    getGeneratePreamble(x::AbstractPreprocessorOptions) -> Bool
Return whether a preamble is being generated, which is what makes the lexer preserve the
open `#if` stack for the writer.
"""
function getGeneratePreamble(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getGeneratePreamble(x)
end

function setGeneratePreamble(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setGeneratePreamble(x, value)
    return nothing
end

"""
    getSingleFileParseMode(x::AbstractPreprocessorOptions) -> Bool
Return whether the preprocessor parses a single file only, with `#include`s disabled and
every conditional block parsed.
"""
function getSingleFileParseMode(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getSingleFileParseMode(x)
end

function setSingleFileParseMode(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setSingleFileParseMode(x, value)
    return nothing
end

"""
    addRemappedFile(x::AbstractPreprocessorOptions, from::AbstractString, to::AbstractString)
Give the file `from` the contents of the file `to`.
"""
function addRemappedFile(x::AbstractPreprocessorOptions, from::AbstractString,
                         to::AbstractString)
    @check_ptrs x
    clang_PreprocessorOptions_addRemappedFile(x, from, to)
    return nothing
end

"""
    addRemappedFile(x::AbstractPreprocessorOptions, from::AbstractString, to::LLVM.MemoryBuffer)
Give the file `from` the contents of `to`.

The buffer is borrowed and must outlive the compiler instance that reads it;
[`getRetainRemappedFileBuffers`](@ref) decides whether that instance frees it.
"""
function addRemappedFile(x::AbstractPreprocessorOptions, from::AbstractString,
                         to::LLVM.MemoryBuffer)
    @check_ptrs x
    clang_PreprocessorOptions_addRemappedFileBuffer(x, from, to)
    return nothing
end

"""
    getRemappedFiles(x::AbstractPreprocessorOptions) -> Vector{Pair{String,String}}
Return the path-to-path remappings, in the order they were added.
"""
function getRemappedFiles(x::AbstractPreprocessorOptions)
    @check_ptrs x
    n = clang_PreprocessorOptions_getNumRemappedFiles(x)
    return [get_string(clang_PreprocessorOptions_getRemappedFileFrom(x, i)) =>
                get_string(clang_PreprocessorOptions_getRemappedFileTo(x, i))
            for i = 0:(Int(n) - 1)]
end

"""
    getRemappedFileBuffers(x::AbstractPreprocessorOptions) -> Vector{String}
Return the paths that were remapped to a memory buffer, in the order they were added. The
buffers themselves stay on the C++ side.
"""
function getRemappedFileBuffers(x::AbstractPreprocessorOptions)
    @check_ptrs x
    n = clang_PreprocessorOptions_getNumRemappedFileBuffers(x)
    return [get_string(clang_PreprocessorOptions_getRemappedFileBufferFrom(x, i))
            for i = 0:(Int(n) - 1)]
end

"""
    clearRemappedFiles(x::AbstractPreprocessorOptions)
Drop every remapping, of both kinds.
"""
function clearRemappedFiles(x::AbstractPreprocessorOptions)
    @check_ptrs x
    clang_PreprocessorOptions_clearRemappedFiles(x)
    return nothing
end

"""
    getRetainRemappedFileBuffers(x::AbstractPreprocessorOptions) -> Bool
Return whether the compiler instance leaves the remapped buffers alive rather than freeing
them, which is what lets an invocation and its buffers be reused.
"""
function getRetainRemappedFileBuffers(x::AbstractPreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_getRetainRemappedFileBuffers(x)
end

function setRetainRemappedFileBuffers(x::AbstractPreprocessorOptions, value::Bool)
    @check_ptrs x
    clang_PreprocessorOptions_setRetainRemappedFileBuffers(x, value)
    return nothing
end

function PrintStats(x::PreprocessorOptions)
    @check_ptrs x
    return clang_PreprocessorOptions_PrintStats(x)
end
