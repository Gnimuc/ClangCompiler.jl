abstract type AbstractPCHContainerOperations end

"""
    struct PCHContainerOperations <: AbstractPCHContainerOperations
Hold a pointer to a `clang::PCHContainerOperations` object.
"""
struct PCHContainerOperations <: AbstractPCHContainerOperations
    ptr::CXPCHContainerOperations
end

abstract type AbstractPCHContainerWriter end

"""
    struct PCHContainerWriter <: AbstractPCHContainerWriter
Hold a pointer to a `clang::PCHContainerWriter` object.
"""
struct PCHContainerWriter <: AbstractPCHContainerWriter
    ptr::CXPCHContainerWriter
end

abstract type AbstractPCHContainerReader end

"""
    struct PCHContainerReader <: AbstractPCHContainerReader
Hold a pointer to a `clang::PCHContainerReader` object.
"""
struct PCHContainerReader <: AbstractPCHContainerReader
    ptr::CXPCHContainerReader
end
