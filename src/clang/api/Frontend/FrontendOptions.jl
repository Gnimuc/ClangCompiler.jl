# FrontendOptions
"""
    getDisableFree(x::AbstractFrontendOptions) -> Bool
Whether the frontend skips tearing down its own allocations, as `-disable-free` asks.
"""
function getDisableFree(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getDisableFree(x)
end

"""
    setDisableFree(x::AbstractFrontendOptions, value::Bool)
Set whether the frontend skips tearing down its own allocations.
"""
function setDisableFree(x::AbstractFrontendOptions, value::Bool)
    @check_ptrs x
    return clang_FrontendOptions_setDisableFree(x, value)
end

"""
    getSkipFunctionBodies(x::AbstractFrontendOptions) -> Bool
Whether function bodies are skipped: declarations, types and lookup still work, the bodies
are not built.
"""
function getSkipFunctionBodies(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getSkipFunctionBodies(x)
end

"""
    setSkipFunctionBodies(x::AbstractFrontendOptions, value::Bool)
Ask the parser to skip function bodies — the fast-parse knob for a declaration-lookup pass.
"""
function setSkipFunctionBodies(x::AbstractFrontendOptions, value::Bool)
    @check_ptrs x
    return clang_FrontendOptions_setSkipFunctionBodies(x, value)
end

# DashX
"""
    getDashXLanguage(x::AbstractFrontendOptions) -> CXLanguage
The language of the `-x` input kind: what the frontend assumes about an input whose name
does not say.
"""
function getDashXLanguage(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getDashXLanguage(x)
end

"""
    getDashXFormat(x::AbstractFrontendOptions) -> CXInputKind_Format
Whether the `-x` input kind names source, a module map, or a precompiled file.
"""
function getDashXFormat(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getDashXFormat(x)
end

"""
    getDashXHeaderUnitKind(x::AbstractFrontendOptions) -> CXInputKind_HeaderUnitKind
Which kind of C++20 header unit the `-x` input kind names, if any.
"""
function getDashXHeaderUnitKind(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getDashXHeaderUnitKind(x)
end

"""
    isDashXPreprocessed(x::AbstractFrontendOptions) -> Bool
Whether the `-x` input kind says the input has already been preprocessed.
"""
function isDashXPreprocessed(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_isDashXPreprocessed(x)
end

"""
    isDashXHeader(x::AbstractFrontendOptions) -> Bool
Whether the `-x` input kind says the input is a header.
"""
function isDashXHeader(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_isDashXHeader(x)
end

"""
    setDashX(x::AbstractFrontendOptions, lang::CXLanguage; fmt, preprocessed, header_unit, header)
Replace the `-x` input kind. `clang::InputKind` has no setters, so it is rebuilt from its
five components and assigned.
"""
function setDashX(x::AbstractFrontendOptions, lang::CXLanguage;
                  fmt::CXInputKind_Format=CXInputKind_Source,
                  preprocessed::Bool=false,
                  header_unit::CXInputKind_HeaderUnitKind=CXInputKind_HeaderUnit_None,
                  header::Bool=false)
    @check_ptrs x
    return clang_FrontendOptions_setDashX(x, lang, fmt, preprocessed, header_unit, header)
end

# Inputs
"""
    getInputsNum(x::AbstractFrontendOptions) -> UInt32
How many inputs the frontend is configured to read.
"""
function getInputsNum(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getInputsNum(x)
end

"""
    isInputFile(x::AbstractFrontendOptions, i::Integer) -> Bool
Whether input `i` (0-origin) names a file rather than a memory buffer.
"""
function isInputFile(x::AbstractFrontendOptions, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getInputsNum(x) "input index $i out of range"
    return clang_FrontendOptions_isInputFile(x, i)
end

"""
    isInputSystem(x::AbstractFrontendOptions, i::Integer) -> Bool
Whether input `i` (0-origin) is a system input rather than a user one.
"""
function isInputSystem(x::AbstractFrontendOptions, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getInputsNum(x) "input index $i out of range"
    return clang_FrontendOptions_isInputSystem(x, i)
end

"""
    getInputLanguage(x::AbstractFrontendOptions, i::Integer) -> CXLanguage
The language of input `i` (0-origin).
"""
function getInputLanguage(x::AbstractFrontendOptions, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getInputsNum(x) "input index $i out of range"
    return clang_FrontendOptions_getInputLanguage(x, i)
end

"""
    getInputFile(x::AbstractFrontendOptions, i::Integer) -> String
The path of input `i` (0-origin), which must be a file-backed input —
`clang::FrontendInputFile::getFile` asserts on that.
"""
function getInputFile(x::AbstractFrontendOptions, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getInputsNum(x) "input index $i out of range"
    @assert isInputFile(x, i) "input $i is a buffer, not a file"
    return get_string(clang_FrontendOptions_getInputFile(x, i))
end

"""
    addInputFile(x::AbstractFrontendOptions, file::AbstractString, lang::CXLanguage; fmt, preprocessed, system)
Append one file-backed input. `clang::FrontendOptions` exposes `Inputs` as a plain vector
with no member function to grow it, and every `cc1` action needs at least one entry.

Buffer-backed inputs are deliberately absent: the `MemoryBufferRef` such an entry holds is
non-owning, and nothing on this side could keep the bytes alive for the parse.
"""
function addInputFile(x::AbstractFrontendOptions, file::AbstractString, lang::CXLanguage;
                      fmt::CXInputKind_Format=CXInputKind_Source,
                      preprocessed::Bool=false, system::Bool=false)
    @check_ptrs x
    return clang_FrontendOptions_addInputFile(x, file, lang, fmt, preprocessed, system)
end

"""
    clearInputs(x::AbstractFrontendOptions)
Empty the input list, so a reused invocation does not accumulate inputs.
"""
function clearInputs(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_clearInputs(x)
end

# OutputFile
"""
    getOutputFile(x::AbstractFrontendOptions) -> String
Where the action writes; empty when nothing was set.
"""
function getOutputFile(x::AbstractFrontendOptions)
    @check_ptrs x
    return get_string(clang_FrontendOptions_getOutputFile(x))
end

"""
    setOutputFile(x::AbstractFrontendOptions, path::AbstractString)
Set the action's output path. [`GeneratePCHAction`](@ref) needs one, and so does every
`-emit-*` action reached through [`ExecuteCompilerInvocation`](@ref).
"""
function setOutputFile(x::AbstractFrontendOptions, path::AbstractString)
    @check_ptrs x
    return clang_FrontendOptions_setOutputFile(x, path)
end

# ProgramAction
"""
    getProgramAction(x::AbstractFrontendOptions) -> CXActionKind
Which frontend action this configuration asks for. The default is
`CXActionKind_ParseSyntaxOnly`.
"""
function getProgramAction(x::AbstractFrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getProgramAction(x)
end

"""
    setProgramAction(x::AbstractFrontendOptions, kind::CXActionKind)
Choose the frontend action. This is the field [`CreateFrontendAction`](@ref) and
[`ExecuteCompilerInvocation`](@ref) switch on.
"""
function setProgramAction(x::AbstractFrontendOptions, kind::CXActionKind)
    @check_ptrs x
    return clang_FrontendOptions_setProgramAction(x, kind)
end

function getModulesEmbedFilesNum(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_getModulesEmbedFilesNum(x)
end

function getModulesEmbedFiles(x::FrontendOptions)
    @check_ptrs x
    n = getModulesEmbedFilesNum(x)
    files = Vector{Ptr{Cchar}}(undef, n)
    clang_FrontendOptions_getModulesEmbedFiles(x, files, n)
    return [unsafe_string(p) for p in files]
end

function PrintStats(x::FrontendOptions)
    @check_ptrs x
    return clang_FrontendOptions_PrintStats(x)
end
