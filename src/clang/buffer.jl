"""
    mutable struct MemoryBuffer
Holds a pointer to a `llvm::MemoryBuffer` object.
"""
mutable struct MemoryBuffer
    ptr::CXMemoryBuffer
end
function MemoryBuffer(input::AbstractString, should_copy::Bool=true)
    return MemoryBuffer(should_copy ? create_memory_buffer_and_copy(input) :
                        create_memory_buffer(input))
end

"""
    create_memory_buffer(input::String, buffer_name::String="", is_null_terminated::Bool=false) -> CXMemoryBuffer
Return a pointer to a `llvm::MemoryBuffer` object.

Note that string inputs must be null terminated if `is_null_terminated` is true. The lifetime
of all string input arguments should extend past that of its users.
"""
function create_memory_buffer(input::String, buffer_name::String="",
                              is_null_terminated::Bool=false)
    return clang_MemoryBuffer_getMemBuffer(input, length(input), buffer_name,
                                           length(buffer_name), is_null_terminated)
end

"""
    create_memory_buffer_and_copy(input::String, buffer_name::String="") -> CXMemoryBuffer
Return a pointer to a `llvm::MemoryBuffer` object. The string inputs do not have to be `NUL`-terminated.
"""
function create_memory_buffer_and_copy(input::String, buffer_name::String="")
    return clang_MemoryBuffer_getMemBufferCopy(input, length(input), buffer_name,
                                               length(buffer_name))
end
