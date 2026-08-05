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

"""
    endsWithZeroSizedObject(x::AbstractASTRecordLayout) -> Bool

Whether the record ends with a zero-sized subobject.

Total over any layout, unlike the C++-side queries below: clang spells this one
`CXXInfo && CXXInfo->EndsWithZeroSizedObject`, so a layout with no C++ information
answers `false` rather than aborting.
"""
function endsWithZeroSizedObject(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_endsWithZeroSizedObject(x)
end

# The queries below read the layout's C++ side table — call them only on a
# layout obtained from a CXXRecordDecl (the C side asserts CXXInfo).
"""
    leadsWithZeroSizedBase(x::AbstractASTRecordLayout) -> Bool

Whether the record begins with a zero-sized base class.

PRECONDITION: `x` was obtained for a `CXXRecordDecl`. clang asserts `CXXInfo` here, where
[`endsWithZeroSizedObject`](@ref) checks it — the two are adjacent in clang's header and
differ in exactly that. `CXXInfo` is private with no predicate over it, so the condition is
not observable from the layout and is restated rather than asserted.
"""
function leadsWithZeroSizedBase(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_leadsWithZeroSizedBase(x)
end

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

"""
    getPrimaryBase(x::AbstractASTRecordLayout) -> CXXRecordDecl
Return the primary base class — the one whose vtable this class shares — or a carrier holding
`NULL` when there is none.

The layout must have been obtained for a `CXXRecordDecl`; clang asserts that internally and the
layout handle exposes no proxy for it, so it is stated here rather than checked, exactly as for
[`getNonVirtualSize`](@ref) and [`hasOwnVFPtr`](@ref).
"""
function getPrimaryBase(x::AbstractASTRecordLayout)
    @check_ptrs x
    return CXXRecordDecl(clang_ASTRecordLayout_getPrimaryBase(x))
end

"""
    isPrimaryBaseVirtual(x::AbstractASTRecordLayout) -> Bool
Return whether the primary base is virtually inherited. Same documented C++-layout precondition
as [`getPrimaryBase`](@ref).
"""
function isPrimaryBaseVirtual(x::AbstractASTRecordLayout)
    @check_ptrs x
    return clang_ASTRecordLayout_isPrimaryBaseVirtual(x)
end
