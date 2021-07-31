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

"""
    mutable struct DeclGroupRef <: Any
Holds a `clang::DeclGroupRef` opaque pointer.
"""
mutable struct DeclGroupRef
    ptr::CXDeclGroupRef
end

function DeclGroupRef(x::Decl)
    @assert x.ptr != C_NULL "Decl has a NULL pointer."
    return DeclGroupRef(clang_DeclGroupRef_fromeDecl(x.ptr))
end

function parse_decl(x::Parser, is_first_decl::Bool=false)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return DeclGroupRef(clang_Parser_parseOneTopLevelDecl(x.ptr, is_first_decl))
end

function is_null(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isNull(x.ptr)
end

function is_single_decl(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isSingleDecl(x.ptr)
end

function get_single_decl(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return Decl(clang_DeclGroupRef_getSingleDecl(x.ptr))
end

function is_decl_group(x::DeclGroupRef)
    @assert x.ptr != C_NULL "DeclGroupRef has a NULL pointer."
    return clang_DeclGroupRef_isDeclGroup(x.ptr)
end
