# ASTRecordLayout
# CharUnits quantities are returned in bytes; `getFieldOffset` alone is in bits,
# matching the C++ API.
function getAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getAlignment(x)
end

function getPreferredAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getPreferredAlignment(x)
end

function getUnadjustedAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getUnadjustedAlignment(x)
end

function getRequiredAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getRequiredAlignment(x)
end

function getSize(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getSize(x)
end

function getFieldCount(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getFieldCount(x)
end

"""
    getFieldOffset(x::AbstractASTRecordLayout, i::Integer) -> UInt64
Return the offset of the `i`-th field (0-based declaration order) in **bits**.
"""
function getFieldOffset(x::AbstractASTRecordLayout, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getFieldCount(x) "field index $i out of range"
    return clang_ASTRecordLayout_getFieldOffset(x, i)
end

function getDataSize(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getDataSize(x)
end

function getBaseClassOffset(x::AbstractASTRecordLayout, base::AbstractCXXRecordDecl)
    @check_ptrs x base
    return clang_ASTRecordLayout_getBaseClassOffset(x, base)
end

function getVBaseClassOffset(x::AbstractASTRecordLayout, vbase::AbstractCXXRecordDecl)
    @check_ptrs x vbase
    return clang_ASTRecordLayout_getVBaseClassOffset(x, vbase)
end

# The queries below read the layout's C++ side table — call them only on a
# layout obtained from a CXXRecordDecl (the C side asserts CXXInfo).
function getNonVirtualSize(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getNonVirtualSize(x)
end

function getNonVirtualAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getNonVirtualAlignment(x)
end

function getPreferredNVAlignment(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getPreferredNVAlignment(x)
end

function getSizeOfLargestEmptySubobject(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getSizeOfLargestEmptySubobject(x)
end

function getVBPtrOffset(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_getVBPtrOffset(x)
end

function hasOwnVFPtr(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_hasOwnVFPtr(x)
end

function hasExtendableVFPtr(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_hasExtendableVFPtr(x)
end

function hasOwnVBPtr(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_hasOwnVBPtr(x)
end

function hasVBPtr(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_hasVBPtr(x)
end
