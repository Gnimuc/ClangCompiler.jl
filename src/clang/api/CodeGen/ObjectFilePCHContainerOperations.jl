# PCHContainerOperations
"""
    PCHContainerOperations() -> PCHContainerOperations
A registry of PCH container writers and readers, pre-populated with the raw pass-through
pair clang uses for an ordinary `.pch`.

Register the object-file pair on top of it with
[`registerObjectFilePCHContainerReader`](@ref) to read a PCH written in the `-gmodules`
container format (the one Xcode emits), which is a COFF/ELF/Mach-O object wrapping the
serialized AST.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function PCHContainerOperations()
    ops = clang_PCHContainerOperations_create()
    @assert ops != C_NULL "Failed to create PCHContainerOperations"
    return PCHContainerOperations(ops)
end

dispose(x::AbstractPCHContainerOperations) = clang_PCHContainerOperations_dispose(x)

"""
    registerObjectFilePCHContainerWriter(x::AbstractPCHContainerOperations)
Register the object-file container writer under the `"obj"` format. `x` takes ownership of
it, which is why there is no separate constructor for the writer.
"""
function registerObjectFilePCHContainerWriter(x::AbstractPCHContainerOperations)
    @check_ptrs x
    return clang_PCHContainerOperations_registerObjectFilePCHContainerWriter(x)
end

"""
    registerObjectFilePCHContainerReader(x::AbstractPCHContainerOperations)
Register the object-file container reader under the `"obj"` format. `x` takes ownership of
it, as above.
"""
function registerObjectFilePCHContainerReader(x::AbstractPCHContainerOperations)
    @check_ptrs x
    return clang_PCHContainerOperations_registerObjectFilePCHContainerReader(x)
end

"""
    getWriterOrNull(x::AbstractPCHContainerOperations, format::AbstractString) -> Union{Nothing,PCHContainerWriter}
The writer registered for `format`, or `nothing` when none is. Borrowed from `x`; never
`dispose` it.
"""
function getWriterOrNull(x::AbstractPCHContainerOperations, format::AbstractString)
    @check_ptrs x
    w = clang_PCHContainerOperations_getWriterOrNull(x, format)
    return w == C_NULL ? nothing : PCHContainerWriter(w)
end

"""
    getReaderOrNull(x::AbstractPCHContainerOperations, format::AbstractString) -> Union{Nothing,PCHContainerReader}
The reader registered for `format`, or `nothing` when none is. Borrowed from `x`; never
`dispose` it.
"""
function getReaderOrNull(x::AbstractPCHContainerOperations, format::AbstractString)
    @check_ptrs x
    r = clang_PCHContainerOperations_getReaderOrNull(x, format)
    return r == C_NULL ? nothing : PCHContainerReader(r)
end

"""
    getRawReader(x::AbstractPCHContainerOperations) -> PCHContainerReader
The `"raw"` reader every registry is created with. Borrowed from `x`.
"""
function getRawReader(x::AbstractPCHContainerOperations)
    @check_ptrs x
    return PCHContainerReader(clang_PCHContainerOperations_getRawReader(x))
end

# PCHContainerWriter
"""
    getFormat(x::AbstractPCHContainerWriter) -> String
The `-fmodule-format=` spelling this writer produces.
"""
function getFormat(x::AbstractPCHContainerWriter)
    @check_ptrs x
    return get_string(clang_PCHContainerWriter_getFormat(x))
end

# PCHContainerReader
"""
    getNumFormats(x::AbstractPCHContainerReader) -> Cuint
How many `-fmodule-format=` spellings this reader accepts.
"""
function getNumFormats(x::AbstractPCHContainerReader)
    @check_ptrs x
    return clang_PCHContainerReader_getNumFormats(x)
end

"""
    getFormat(x::AbstractPCHContainerReader, i::Integer) -> String
The `i`-th (0-based, `i < getNumFormats(x)`) format this reader accepts.
"""
function getFormat(x::AbstractPCHContainerReader, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumFormats(x) "format index $i out of range"
    return get_string(clang_PCHContainerReader_getFormat(x, i))
end

"""
    getFormats(x::AbstractPCHContainerReader) -> Vector{String}
Every `-fmodule-format=` spelling this reader accepts.
"""
function getFormats(x::AbstractPCHContainerReader)
    @check_ptrs x
    return [getFormat(x, i) for i = 0:(getNumFormats(x) - 1)]
end
