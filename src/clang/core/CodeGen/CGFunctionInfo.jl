abstract type AbstractCGFunctionInfo end

"""
    struct CGFunctionInfo <: AbstractCGFunctionInfo
Hold a pointer to a `clang::CodeGen::CGFunctionInfo` object.
"""
struct CGFunctionInfo <: AbstractCGFunctionInfo
    ptr::CXCGFunctionInfo
end

abstract type AbstractABIArgInfo end

"""
    struct ABIArgInfo <: AbstractABIArgInfo
Hold a pointer to a `clang::CodeGen::ABIArgInfo` object.
"""
struct ABIArgInfo <: AbstractABIArgInfo
    ptr::CXABIArgInfo
end
