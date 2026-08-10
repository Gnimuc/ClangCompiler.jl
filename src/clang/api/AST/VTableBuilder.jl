# VTableBuilder
#
# The vtable layout clang computes for codegen. With [`getASTRecordLayout`](@ref) (where a
# field sits) and `mangleCXXVTable` (what the table's symbol is called) this closes the object
# model: which slot a virtual function dispatches through, and what every slot holds — so a
# virtual call can be made through the vtable rather than through a JIT-compiled thunk.

# VTableComponent

function getKind(x::AbstractVTableComponent)
    @check_ptrs x
    return clang_VTableComponent_getKind(x)
end

"""
    getVCallOffset(x::AbstractVTableComponent) -> Int64
The virtual-call offset this slot holds, in chars.

PARTIAL: the kind must be `CXVTableComponent_CK_VCallOffset` — clang asserts it and then
reads the value bits as an offset.
"""
function getVCallOffset(x::AbstractVTableComponent)
    @check_ptrs x
    @assert getKind(x) == CXVTableComponent_CK_VCallOffset "not a vcall-offset component"
    return clang_VTableComponent_getVCallOffset(x)
end

"""
    getVBaseOffset(x::AbstractVTableComponent) -> Int64
The virtual-base offset this slot holds, in chars.

PARTIAL: the kind must be `CXVTableComponent_CK_VBaseOffset`.
"""
function getVBaseOffset(x::AbstractVTableComponent)
    @check_ptrs x
    @assert getKind(x) == CXVTableComponent_CK_VBaseOffset "not a vbase-offset component"
    return clang_VTableComponent_getVBaseOffset(x)
end

"""
    getOffsetToTop(x::AbstractVTableComponent) -> Int64
The offset from this subobject to the most-derived object, in chars (never positive).

PARTIAL: the kind must be `CXVTableComponent_CK_OffsetToTop`.
"""
function getOffsetToTop(x::AbstractVTableComponent)
    @check_ptrs x
    @assert getKind(x) == CXVTableComponent_CK_OffsetToTop "not an offset-to-top component"
    return clang_VTableComponent_getOffsetToTop(x)
end

function isRTTIKind(x::AbstractVTableComponent)
    @check_ptrs x
    return clang_VTableComponent_isRTTIKind(x)
end

function isFunctionPointerKind(x::AbstractVTableComponent)
    @check_ptrs x
    return clang_VTableComponent_isFunctionPointerKind(x)
end

function isUsedFunctionPointerKind(x::AbstractVTableComponent)
    @check_ptrs x
    return clang_VTableComponent_isUsedFunctionPointerKind(x)
end

function isDestructorKind(x::AbstractVTableComponent)
    @check_ptrs x
    return clang_VTableComponent_isDestructorKind(x)
end

"""
    getRTTIDecl(x::AbstractVTableComponent) -> CXXRecordDecl
The class this RTTI slot points at.

PARTIAL: `isRTTIKind(x)` must hold.
"""
function getRTTIDecl(x::AbstractVTableComponent)
    @check_ptrs x
    @assert isRTTIKind(x) "not an RTTI component"
    return CXXRecordDecl(clang_VTableComponent_getRTTIDecl(x))
end

"""
    getFunctionDecl(x::AbstractVTableComponent) -> CXXMethodDecl
The method this function-pointer slot dispatches to; for a destructor slot, the destructor.

PARTIAL: `isFunctionPointerKind(x)` must hold.
"""
function getFunctionDecl(x::AbstractVTableComponent)
    @check_ptrs x
    @assert isFunctionPointerKind(x) "not a function-pointer component"
    return CXXMethodDecl(clang_VTableComponent_getFunctionDecl(x))
end

"""
    getDestructorDecl(x::AbstractVTableComponent) -> CXXDestructorDecl
The destructor this slot names.

PARTIAL: `isDestructorKind(x)` must hold — the complete-object and deleting variants are the
two kinds that satisfy it.
"""
function getDestructorDecl(x::AbstractVTableComponent)
    @check_ptrs x
    @assert isDestructorKind(x) "not a destructor component"
    return CXXDestructorDecl(clang_VTableComponent_getDestructorDecl(x))
end

"""
    getUnusedFunctionDecl(x::AbstractVTableComponent) -> CXXMethodDecl
The method whose slot clang proved is never called.

PARTIAL: the kind must be `CXVTableComponent_CK_UnusedFunctionPointer`.
"""
function getUnusedFunctionDecl(x::AbstractVTableComponent)
    @check_ptrs x
    @assert getKind(x) == CXVTableComponent_CK_UnusedFunctionPointer "not an unused-function component"
    return CXXMethodDecl(clang_VTableComponent_getUnusedFunctionDecl(x))
end

# VTableLayout

"""
    getNumVTableComponents(x::AbstractVTableLayout) -> Integer
How many entries the whole vtable *group* holds. Cut it into the individual tables with
[`getVTableOffset`](@ref) and [`getVTableSize`](@ref).
"""
function getNumVTableComponents(x::AbstractVTableLayout)
    @check_ptrs x
    return clang_VTableLayout_getNumVTableComponents(x)
end

"""
    getVTableComponent(x::AbstractVTableLayout, i::Integer) -> VTableComponent
The `i`-th entry of the group (0-based). The result is borrowed from `x` and has no
`dispose`.

`i` must be less than [`getNumVTableComponents`](@ref).
"""
function getVTableComponent(x::AbstractVTableLayout, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumVTableComponents(x) "vtable component index out of range"
    return VTableComponent(clang_VTableLayout_getVTableComponent(x, i))
end

"""
    getNumVTables(x::AbstractVTableLayout) -> Integer
How many vtables the group holds — one per vptr the most-derived class needs.
"""
function getNumVTables(x::AbstractVTableLayout)
    @check_ptrs x
    return clang_VTableLayout_getNumVTables(x)
end

"""
    getVTableOffset(x::AbstractVTableLayout, i::Integer) -> Integer
Where the `i`-th vtable starts inside the component array.

`i` must be less than [`getNumVTables`](@ref).
"""
function getVTableOffset(x::AbstractVTableLayout, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumVTables(x) "vtable index out of range"
    return clang_VTableLayout_getVTableOffset(x, i)
end

"""
    getVTableSize(x::AbstractVTableLayout, i::Integer) -> Integer
How many components the `i`-th vtable spans.

`i` must be less than [`getNumVTables`](@ref).
"""
function getVTableSize(x::AbstractVTableLayout, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumVTables(x) "vtable index out of range"
    return clang_VTableLayout_getVTableSize(x, i)
end

# VTableContextBase

"""
    isMicrosoft(x::AbstractVTableContextBase) -> Bool
Whether this is the Microsoft ABI's builder. Every accessor below the cast needs the Itanium
one, so this is the gate [`castToItaniumVTableContext`](@ref) takes.
"""
function isMicrosoft(x::AbstractVTableContextBase)
    @check_ptrs x
    return clang_VTableContextBase_isMicrosoft(x)
end

"""
    hasVtableSlot(md::AbstractCXXMethodDecl) -> Bool
Whether `md` is given a slot in its class's vtable at all.
"""
function hasVtableSlot(md::AbstractCXXMethodDecl)
    @check_ptrs md
    return clang_VTableContextBase_hasVtableSlot(md)
end

"""
    castToItaniumVTableContext(x::AbstractVTableContextBase) -> ItaniumVTableContext
The same context typed as the Itanium builder, or a NULL carrier under the Microsoft C++ ABI.

`MicrosoftVTableContext` is not wrapped: its model is vftables plus vbtables rather than one
component array, and the shim already restricts mangling to Itanium.
"""
function castToItaniumVTableContext(x::AbstractVTableContextBase)
    @check_ptrs x
    return ItaniumVTableContext(clang_VTableContextBase_castToItaniumVTableContext(x))
end

# ItaniumVTableContext

"""
    getVTableLayout(x::AbstractItaniumVTableContext, rd::AbstractCXXRecordDecl) -> VTableLayout
The layout of `rd`'s vtable group, computed on the first ask and cached on `x`.

PARTIAL: `rd` must have a definition and be a dynamic class — clang builds the layout
unconditionally and then asserts one was produced.
"""
function getVTableLayout(x::AbstractItaniumVTableContext, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    @assert hasDefinition(rd) "CXXRecordDecl has no definition."
    @assert isDynamicClass(rd) "a non-dynamic class has no vtable"
    return VTableLayout(clang_ItaniumVTableContext_getVTableLayout(x, rd))
end

"""
    getMethodVTableIndex(x::AbstractItaniumVTableContext, md::AbstractCXXMethodDecl) -> UInt64
The index of `md`'s function pointer relative to the vtable address point — the slot a
virtual call dispatches through.

PARTIAL: `md` must be virtual and must have a vtable slot ([`hasVtableSlot`](@ref)); clang
looks the index up and asserts it found one. A constructor or destructor names several
emitted bodies and so is rejected here — pass the variant explicitly with
[`getMethodVTableIndexForDtor`](@ref).
"""
function getMethodVTableIndex(x::AbstractItaniumVTableContext, md::AbstractCXXMethodDecl)
    @check_ptrs x md
    @assert !isCXXConstructorDecl(md) && !isCXXDestructorDecl(md) "a constructor or destructor has several vtable bodies; pass its CXCXXCtorType/CXCXXDtorType"
    @assert isVirtual(md) "a non-virtual method has no vtable slot"
    @assert hasVtableSlot(md) "the method has no vtable slot"
    return clang_ItaniumVTableContext_getMethodVTableIndex(x, md)
end

"""
    getMethodVTableIndexForDtor(x::AbstractItaniumVTableContext, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType) -> UInt64
The slot index of one variant of a virtual destructor. `CXCXXDtorType_Dtor_Complete` and
`CXCXXDtorType_Dtor_Deleting` are the two that appear in a vtable.

PARTIAL: `d` must be virtual and must have a vtable slot.
"""
function getMethodVTableIndexForDtor(x::AbstractItaniumVTableContext,
                                     d::AbstractCXXDestructorDecl, kind::CXCXXDtorType)
    @check_ptrs x d
    @assert isVirtual(d) "a non-virtual destructor has no vtable slot"
    @assert hasVtableSlot(d) "the destructor has no vtable slot"
    return clang_ItaniumVTableContext_getMethodVTableIndexForDtor(x, d, kind)
end

"""
    getMethodVTableIndexForCtor(x::AbstractItaniumVTableContext, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType) -> UInt64
The constructor form of [`getMethodVTableIndex`](@ref).

Constructors are never virtual in C++, so clang has no slot for one and this exists only to
make the `GlobalDecl` flattening total; the precondition it restates can never be met.
"""
function getMethodVTableIndexForCtor(x::AbstractItaniumVTableContext,
                                     d::AbstractCXXConstructorDecl, kind::CXCXXCtorType)
    @check_ptrs x d
    @assert hasVtableSlot(d) "a constructor has no vtable slot"
    return clang_ItaniumVTableContext_getMethodVTableIndexForCtor(x, d, kind)
end

"""
    getVirtualBaseOffsetOffset(x::AbstractItaniumVTableContext, rd::AbstractCXXRecordDecl, vbase::AbstractCXXRecordDecl) -> Int64
The offset in chars, relative to the vtable address point, of the slot holding `vbase`'s
offset within `rd`.

PARTIAL: `vbase` must be one of `rd`'s virtual bases, direct or indirect — clang builds the
vbase-offset map for `rd` and then asserts the pair is in it. `rd` must therefore also have a
definition.
"""
function getVirtualBaseOffsetOffset(x::AbstractItaniumVTableContext,
                                    rd::AbstractCXXRecordDecl,
                                    vbase::AbstractCXXRecordDecl)
    @check_ptrs x rd vbase
    @assert hasDefinition(rd) "CXXRecordDecl has no definition."
    @assert is_virtual_base_of(rd, vbase) "the class is not a virtual base of the record"
    return clang_ItaniumVTableContext_getVirtualBaseOffsetOffset(x, rd, vbase)
end

"""
    is_virtual_base_of(rd::AbstractCXXRecordDecl, vbase::AbstractCXXRecordDecl) -> Bool
Whether `vbase` is among `rd`'s virtual bases, direct or indirect — `clang::CXXRecordDecl`'s
`vbases()` lists both. Compared on canonical declarations, so a forward declaration and its
definition count as the same class.

`rd` must have a definition.
"""
function is_virtual_base_of(rd::AbstractCXXRecordDecl, vbase::AbstractCXXRecordDecl)
    @check_ptrs rd vbase
    @assert hasDefinition(rd) "CXXRecordDecl has no definition."
    target = getCanonicalDecl(vbase)
    for i = 0:(getNumVBases(rd) - 1)
        b = getVBase(rd, i)
        brd = getAsCXXRecordDecl(getTypePtr(getType(b)))
        is_null_handle(brd) && continue
        getCanonicalDecl(brd) == target && return true
    end
    return false
end

function getVTableComponentLayout(x::AbstractItaniumVTableContext)
    @check_ptrs x
    return clang_ItaniumVTableContext_getVTableComponentLayout(x)
end

function isPointerLayout(x::AbstractItaniumVTableContext)
    @check_ptrs x
    return clang_ItaniumVTableContext_isPointerLayout(x)
end

function isRelativeLayout(x::AbstractItaniumVTableContext)
    @check_ptrs x
    return clang_ItaniumVTableContext_isRelativeLayout(x)
end
