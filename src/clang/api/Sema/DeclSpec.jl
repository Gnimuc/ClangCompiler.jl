# CXXScopeSpec
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

dispose(x::CXXScopeSpec) = clang_CXXScopeSpec_dispose(x)

function clear(x::CXXScopeSpec)
    @check_ptrs x
    return clang_CXXScopeSpec_clear(x)
end

function getScopeRep(x::CXXScopeSpec)
    @check_ptrs x
    return NestedNameSpecifier(clang_CXXScopeSpec_getScopeRep(x))
end

function getBeginLoc(x::CXXScopeSpec)
    @check_ptrs x
    return SourceLocation(clang_CXXScopeSpec_getBeginLoc(x))
end

function getEndLoc(x::CXXScopeSpec)
    @check_ptrs x
    return SourceLocation(clang_CXXScopeSpec_getEndLoc(x))
end

function setBeginLoc(x::CXXScopeSpec, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXScopeSpec_setBeginLoc(x, loc)
end

function setEndLoc(x::CXXScopeSpec, loc::SourceLocation)
    @check_ptrs x
    return clang_CXXScopeSpec_setEndLoc(x, loc)
end

function isEmpty(x::CXXScopeSpec)
    @check_ptrs x
    return clang_CXXScopeSpec_isEmpty(x)
end

function isNotEmpty(x::CXXScopeSpec)
    @check_ptrs x
    return clang_CXXScopeSpec_isNotEmpty(x)
end

function isInvalid(x::CXXScopeSpec)
    @check_ptrs x
    return clang_CXXScopeSpec_isInvalid(x)
end

function isValid(x::CXXScopeSpec)
    @check_ptrs x
    return clang_CXXScopeSpec_isValid(x)
end

function setRange(x::CXXScopeSpec, r::SourceRange)
    setBeginLoc(x, getBeginLoc(r))
    setEndLoc(x, getEndLoc(r))
    return nothing
end

getRange(x::CXXScopeSpec, r::SourceRange) = SourceRange(getBeginLoc(x), getEndLoc(x))
