"""
    mutable struct CXXScopeSpec <: Any
Holds a pointer to a `clang::CXXScopeSpec` object.
"""
mutable struct CXXScopeSpec
    ptr::CXCXXScopeSpec
end
CXXScopeSpec() = CXXScopeSpec(create_cxx_scope_spec())

"""
    create_cxx_scope_spec() -> CXCXXScopeSpec
Return a pointer to a `clang::CXXScopeSpec` object.
"""
function create_cxx_scope_spec()
    status = Ref{CXInit_Error}(CXInit_NoError)
    ss = clang_CXXScopeSpec_create(status)
    @assert status[] == CXInit_NoError
    return ss
end

function destroy(x::CXXScopeSpec)
    if x.ptr != C_NULL
        clang_CXXScopeSpec_dispose(x.ptr)
        x.ptr = C_NULL
    end
    return x
end

function get_scope_representation(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return NestedNameSpecifier(clang_CXXScopeSpec_getScopeRep(x.ptr))
end

dump(x::CXXScopeSpec) = dump(get_scope_representation(x))

function get_begin_loc(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return SourceLocation(clang_CXXScopeSpec_getBeginLoc(x.ptr))
end

function get_end_loc(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return SourceLocation(clang_CXXScopeSpec_getEndLoc(x.ptr))
end

function set_begin_loc(x::CXXScopeSpec, loc::SourceLocation)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_setBeginLoc(x.ptr, loc.ptr)
end

function set_end_loc(x::CXXScopeSpec, loc::SourceLocation)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_setEndLoc(x.ptr, loc.ptr)
end

function is_empty(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_isEmpty(x.ptr)
end

function is_not_empty(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_isNotEmpty(x.ptr)
end

function is_invalid(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_isInvalid(x.ptr)
end

function is_valid(x::CXXScopeSpec)
    @assert x.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_CXXScopeSpec_isValid(x.ptr)
end

function set_range(x::CXXScopeSpec, r::SourceRange)
    set_begin_loc(x, get_begin_loc(r))
    set_end_loc(x, get_end_loc(r))
end

get_range(x::CXXScopeSpec, r::SourceRange) = SourceRange(get_begin_loc(x), get_end_loc(x))
