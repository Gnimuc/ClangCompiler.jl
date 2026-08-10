# driver::types and driver::phases — how the driver classifies an input and what it would
# do with it.
#
# A driver type ID is a plain `Int` here: the enumeration is generated from
# clang/Driver/Types.def and runs to some eighty entries no caller spells by name. What a
# caller does is obtain one — from [`LookupTypeForExtension`](@ref),
# [`getInputInfoType`](@ref), or [`lookupTypeForExtension`](@ref) below — and ask these
# predicates about it.
#
# clang indexes its type table with no bounds check and no zero check, so every function
# taking an `id` restates the bound: `0 < id < getLastTypeID()`. `TY_INVALID` is 0, which is
# what the two lookups answer when they recognise nothing, and it is not a legal input here.

"""
    getLastTypeID() -> Int
Return `clang::driver::types::TY_LAST`, the one-past-the-end sentinel that closes the type
enumeration. Every valid driver type ID is strictly between 0 and this value.
"""
getLastTypeID() = Int(clang_types_getLastTypeID())

"""
    getMaxNumberOfPhases() -> Int
Return how many compilation phases there are, which is the largest number
[`getCompilationPhases`](@ref) can return.
"""
getMaxNumberOfPhases() = Int(clang_phases_getMaxNumberOfPhases())

"""
    getTypeName(id::Integer) -> String
Return the driver's name for a type, e.g. `"c++"` or `"objective-c-header"`.
"""
function getTypeName(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return unsafe_string(clang_types_getTypeName(id))
end

"""
    getPreprocessedType(id::Integer) -> Int
Return the type this input becomes once preprocessed, or 0 (`TY_INVALID`) when it is not
preprocessed at all.
"""
function getPreprocessedType(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return Int(clang_types_getPreprocessedType(id))
end

"""
    getTypeTempSuffix(id::Integer, cl_style::Bool=false) -> Union{String,Nothing}
Return the extension a temporary of this type gets, without its dot, or `nothing` when the
type has none. `cl_style` asks for the clang-cl spelling.
"""
function getTypeTempSuffix(id::Integer, cl_style::Bool=false)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    p = clang_types_getTypeTempSuffix(id, cl_style)
    return p == C_NULL ? nothing : unsafe_string(p)
end

"""
    isCXX(id::Integer) -> Bool
Return whether the type is a C++ or Objective-C++ source or header.
"""
function isCXX(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return clang_types_isCXX(id)
end

"""
    isSrcFile(id::Integer) -> Bool
Return whether the type is a source file, i.e. something that still has to be preprocessed.
"""
function isSrcFile(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return clang_types_isSrcFile(id)
end

"""
    isLLVMIR(id::Integer) -> Bool
Return whether the type is LLVM IR, in either its textual or its bitcode form.
"""
function isLLVMIR(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return clang_types_isLLVMIR(id)
end

"""
    isAcceptedByClang(id::Integer) -> Bool
Return whether clang itself can handle this input type.
"""
function isAcceptedByClang(id::Integer)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    return clang_types_isAcceptedByClang(id)
end

"""
    lookupTypeForExtension(ext::AbstractString) -> Int
Return the type the driver uses for files with extension `ext` (given without its dot), or
0 (`TY_INVALID`) for an extension it does not recognise.
"""
lookupTypeForExtension(ext::AbstractString) = Int(clang_types_lookupTypeForExtension(ext))

"""
    lookupTypeForTypeSpecifier(name::AbstractString) -> Int
Return the type `-x name` selects, or 0 (`TY_INVALID`) for a name the driver does not
recognise.
"""
function lookupTypeForTypeSpecifier(name::AbstractString)
    return Int(clang_types_lookupTypeForTypeSpecifier(name))
end

"""
    getCompilationPhases(id::Integer, last_phase::CXPhaseID=CXPhaseID_IfsMerge) -> Vector{CXPhaseID}
Return the phases the driver would run for this type, up to and including `last_phase`.
"""
function getCompilationPhases(id::Integer, last_phase::CXPhaseID=CXPhaseID_IfsMerge)
    @assert 0 < id < getLastTypeID() "$id is not a driver type ID"
    n = getMaxNumberOfPhases()
    buf = Vector{CXPhaseID}(undef, n)
    count = Int(clang_types_getCompilationPhases(id, last_phase, buf, n))
    return buf[1:min(count, n)]
end

"""
    getPhaseName(id::CXPhaseID) -> String
Return the driver's name for a compilation phase, e.g. `"preprocessor"`.
"""
getPhaseName(id::CXPhaseID) = unsafe_string(clang_phases_getPhaseName(id))
