"""
    mutable struct Parser <: Any
Holds a pointer to a `clang::Parser` object.
"""
mutable struct Parser
    ptr::CXParser
end

function Parser(pp::Preprocessor, sema::Sema, skip_func_body::Bool=false)
    @assert pp.ptr != C_NULL "Preprocessor has a NULL pointer."
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    status = Ref{CXInit_Error}(CXInit_NoError)
    p = clang_Parser_create(pp.ptr, sema.ptr, skip_func_body, status)
    @assert status[] == CXInit_NoError
    return Parser(p)
end

function destroy(x::Parser)
    if x.ptr != C_NULL
        clang_Parser_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

function initialize(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return clang_Parser_Initialize(x.ptr)
end
