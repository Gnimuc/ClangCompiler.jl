# APValue
function getKind(x::APValue)
    @check_ptrs x
    return clang_APValue_getKind(x)
end

function isInt(x::APValue)
    @check_ptrs x
    return clang_APValue_isInt(x)
end

function isFloat(x::APValue)
    @check_ptrs x
    return clang_APValue_isFloat(x)
end

function isArray(x::APValue)
    @check_ptrs x
    return clang_APValue_isArray(x)
end

function isStruct(x::APValue)
    @check_ptrs x
    return clang_APValue_isStruct(x)
end

# Integer/float leaves come back as an LLVM GenericValue (the APInt is in its
# IntVal field; getFloat stores the exact float bits via APFloat::bitcastToAPInt).
# The GenericValue is caller-owned — release it via LLVM-C after use.
function getInt(x::APValue)
    @check_ptrs x
    return clang_APValue_getInt(x)
end

function getFloat(x::APValue)
    @check_ptrs x
    return clang_APValue_getFloat(x)
end

function getArraySize(x::APValue)
    @check_ptrs x
    return clang_APValue_getArraySize(x)
end

function getArrayInitializedElts(x::APValue)
    @check_ptrs x
    return clang_APValue_getArrayInitializedElts(x)
end

# The returned element is borrowed (interior to `x`); never `dispose` it.
function getArrayInitializedElt(x::APValue, i::Integer)
    @check_ptrs x
    return APValue(clang_APValue_getArrayInitializedElt(x, i))
end

function getStructNumFields(x::APValue)
    @check_ptrs x
    return clang_APValue_getStructNumFields(x)
end

# The returned field is borrowed (interior to `x`); never `dispose` it.
function getStructField(x::APValue, i::Integer)
    @check_ptrs x
    return APValue(clang_APValue_getStructField(x, i))
end

# Release an owned APValue (one produced by `EvaluateAsRValue`). Never call on a
# borrowed element or on the cached result of `evaluateValue`.
function dispose(x::APValue)
    @check_ptrs x
    return clang_APValue_dispose(x)
end


# Kind predicates — the same information `getKind` returns, one enumerator each.
function isAbsent(x::APValue)
    @check_ptrs x
    return clang_APValue_isAbsent(x)
end

function isIndeterminate(x::APValue)
    @check_ptrs x
    return clang_APValue_isIndeterminate(x)
end

# True unless the value is absent or indeterminate.
function hasValue(x::APValue)
    @check_ptrs x
    return clang_APValue_hasValue(x)
end

function isFixedPoint(x::APValue)
    @check_ptrs x
    return clang_APValue_isFixedPoint(x)
end

function isComplexInt(x::APValue)
    @check_ptrs x
    return clang_APValue_isComplexInt(x)
end

function isComplexFloat(x::APValue)
    @check_ptrs x
    return clang_APValue_isComplexFloat(x)
end

function isLValue(x::APValue)
    @check_ptrs x
    return clang_APValue_isLValue(x)
end

function isVector(x::APValue)
    @check_ptrs x
    return clang_APValue_isVector(x)
end

function isUnion(x::APValue)
    @check_ptrs x
    return clang_APValue_isUnion(x)
end

function isMemberPointer(x::APValue)
    @check_ptrs x
    return clang_APValue_isMemberPointer(x)
end

function isAddrLabelDiff(x::APValue)
    @check_ptrs x
    return clang_APValue_isAddrLabelDiff(x)
end

"""
    getAsString(x::APValue, ctx::ASTContext, ty::QualType) -> String
Render the value the way it would appear in source. `ty` must be the type the
value was evaluated at.
"""
function getAsString(x::APValue, ctx::ASTContext, ty::QualType)
    @check_ptrs x ctx ty
    return get_string(clang_APValue_getAsString(x, ctx, ty))
end

# `APValue::hasArrayFiller` reads `getArrayInitializedElts`, which asserts on a
# non-array value.
function hasArrayFiller(x::APValue)
    @check_ptrs x
    @assert isArray(x) "hasArrayFiller requires an array value"
    return clang_APValue_hasArrayFiller(x)
end

# The filler is borrowed (interior to `x`); never `dispose` it.
function getArrayFiller(x::APValue)
    @check_ptrs x
    @assert isArray(x) "getArrayFiller requires an array value"
    @assert hasArrayFiller(x) "array value has no filler element"
    return APValue(clang_APValue_getArrayFiller(x))
end

function getStructNumBases(x::APValue)
    @check_ptrs x
    @assert isStruct(x) "getStructNumBases requires a struct value"
    return clang_APValue_getStructNumBases(x)
end

# `i` is a 0-based base-class index. The result is borrowed; never `dispose` it.
function getStructBase(x::APValue, i::Integer)
    @check_ptrs x
    @assert isStruct(x) "getStructBase requires a struct value"
    @assert 0 <= i < getStructNumBases(x) "base class index out of range"
    return APValue(clang_APValue_getStructBase(x, i))
end

# The active member of a union value. Wraps `C_NULL` when the union value has no
# active member (check `.ptr`).
function getUnionField(x::APValue)
    @check_ptrs x
    @assert isUnion(x) "getUnionField requires a union value"
    return FieldDecl(clang_APValue_getUnionField(x))
end

# The value of the active member; borrowed (interior to `x`), never `dispose` it.
function getUnionValue(x::APValue)
    @check_ptrs x
    @assert isUnion(x) "getUnionValue requires a union value"
    return APValue(clang_APValue_getUnionValue(x))
end

function getVectorLength(x::APValue)
    @check_ptrs x
    @assert isVector(x) "getVectorLength requires a vector value"
    return clang_APValue_getVectorLength(x)
end

# `i` is a 0-based element index. The result is borrowed; never `dispose` it.
function getVectorElt(x::APValue, i::Integer)
    @check_ptrs x
    @assert isVector(x) "getVectorElt requires a vector value"
    @assert 0 <= i < getVectorLength(x) "vector element index out of range"
    return APValue(clang_APValue_getVectorElt(x, i))
end


# Total over every kind — aggregates own heap storage, small scalars do not.
function needsCleanup(x::APValue)
    @check_ptrs x
    return clang_APValue_needsCleanup(x)
end

# The halves of a complex value. Each comes back as an LLVM GenericValue like
# `getInt`/`getFloat` (the float halves carry the exact bits via
# `APFloat::bitcastToAPInt`); the GenericValue is caller-owned.
# `APValue::getComplexIntReal` and friends assert their kind.
function getComplexIntReal(x::APValue)
    @check_ptrs x
    @assert isComplexInt(x) "getComplexIntReal requires a complex integer value"
    return clang_APValue_getComplexIntReal(x)
end

function getComplexIntImag(x::APValue)
    @check_ptrs x
    @assert isComplexInt(x) "getComplexIntImag requires a complex integer value"
    return clang_APValue_getComplexIntImag(x)
end

function getComplexFloatReal(x::APValue)
    @check_ptrs x
    @assert isComplexFloat(x) "getComplexFloatReal requires a complex float value"
    return clang_APValue_getComplexFloatReal(x)
end

function getComplexFloatImag(x::APValue)
    @check_ptrs x
    @assert isComplexFloat(x) "getComplexFloatImag requires a complex float value"
    return clang_APValue_getComplexFloatImag(x)
end

# The lvalue payload. Every one of these asserts `isLValue()` in Clang.
# `APValue::getLValueOffset` is a `CharUnits`; it crosses in bytes.
function getLValueOffset(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueOffset requires an lvalue"
    return clang_APValue_getLValueOffset(x)
end

function isLValueOnePastTheEnd(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "isLValueOnePastTheEnd requires an lvalue"
    return clang_APValue_isLValueOnePastTheEnd(x)
end

function hasLValuePath(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "hasLValuePath requires an lvalue"
    return clang_APValue_hasLValuePath(x)
end

function getLValueCallIndex(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueCallIndex requires an lvalue"
    return clang_APValue_getLValueCallIndex(x)
end

function getLValueVersion(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueVersion requires an lvalue"
    return clang_APValue_getLValueVersion(x)
end

function isNullPointer(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "isNullPointer requires an lvalue"
    return clang_APValue_isNullPointer(x)
end

# The member-pointer payload. Wraps `C_NULL` for a null member pointer (check
# `.ptr`).
function getMemberPointerDecl(x::APValue)
    @check_ptrs x
    @assert isMemberPointer(x) "getMemberPointerDecl requires a member pointer value"
    return ValueDecl(clang_APValue_getMemberPointerDecl(x))
end

function isMemberPointerToDerivedMember(x::APValue)
    @check_ptrs x
    @assert isMemberPointer(x) "isMemberPointerToDerivedMember requires a member pointer value"
    return clang_APValue_isMemberPointerToDerivedMember(x)
end

# The two label operands of an address-of-label difference.
function getAddrLabelDiffLHS(x::APValue)
    @check_ptrs x
    @assert isAddrLabelDiff(x) "getAddrLabelDiffLHS requires an address-of-label difference"
    return AddrLabelExpr(clang_APValue_getAddrLabelDiffLHS(x))
end

function getAddrLabelDiffRHS(x::APValue)
    @check_ptrs x
    @assert isAddrLabelDiff(x) "getAddrLabelDiffRHS requires an address-of-label difference"
    return AddrLabelExpr(clang_APValue_getAddrLabelDiffRHS(x))
end


"""
    IndeterminateValue() -> APValue
Return a freshly heap-boxed indeterminate value. The result is owned: release it with
`dispose`.
"""
IndeterminateValue() = APValue(clang_APValue_IndeterminateValue())

"""
    swap(x::APValue, other::APValue)
Exchange the contents of the two values. Both carriers stay valid and keep whatever
ownership they already had.
"""
function swap(x::APValue, other::APValue)
    @check_ptrs x other
    return clang_APValue_swap(x, other)
end

"""
    toIntegralConstant(x::APValue, src_ty::QualType, ctx::ASTContext) -> LLVMGenericValueRef
Convert the value to an integral constant when it is an integer, a null pointer, or an
offset from a null pointer, and return it as a caller-owned `LLVMGenericValueRef`
(release via LLVM-C's `LLVMDisposeGenericValue`). The result is `C_NULL` when the value
is none of those. `src_ty` must be the type the value was evaluated at: the two lvalue
paths feed it to `getTargetNullPointerValue`/`MakeIntValue`, which need a complete
pointer or integral type, while the integer path ignores it entirely.
"""
function toIntegralConstant(x::APValue, src_ty::QualType, ctx::ASTContext)
    @check_ptrs x src_ty ctx
    tp = getTypePtr(src_ty)
    ok = isIntegerType(tp) || isPointerType(tp) || isNullPtrType(tp) || isMemberPointerType(tp)
    @assert !isLValue(x) || ok "src_ty must be a pointer or integral type when the value is an lvalue"
    return clang_APValue_toIntegralConstant(x, src_ty, ctx)
end

# The lvalue base designator, split into the arms of its `PointerUnion`: at most one of
# the two pointer accessors is non-NULL, and both wrap `C_NULL` for a null base and for
# the type-info / dynamic-allocation arms. `APValue::getLValueBase` asserts `isLValue()`.
function getLValueBaseAsValueDecl(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseAsValueDecl requires an lvalue"
    return ValueDecl(clang_APValue_getLValueBaseAsValueDecl(x))
end

function getLValueBaseAsExpr(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseAsExpr requires an lvalue"
    return Expr_(clang_APValue_getLValueBaseAsExpr(x))
end

function isLValueBaseNull(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "isLValueBaseNull requires an lvalue"
    return clang_APValue_isLValueBaseNull(x)
end

# A null `QualType` (check `.ptr`) when the base designator is null.
function getLValueBaseType(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseType requires an lvalue"
    return QualType(clang_APValue_getLValueBaseType(x))
end

"""
    getLValuePathLength(x::APValue) -> UInt32
Return the number of entries in the lvalue's designator path. `APValue::getLValuePath`
asserts both `isLValue()` and `hasLValuePath()`.
"""
function getLValuePathLength(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValuePathLength requires an lvalue"
    @assert hasLValuePath(x) "lvalue carries no designator path"
    return clang_APValue_getLValuePathLength(x)
end

"""
    getLValuePathAsArrayIndex(x::APValue, i::Integer) -> UInt64
Read the `i`-th (0-based) designator-path entry as an array index. A path entry is a
bare 64-bit word: this reading is the meaningful one only while the type reached so far
is an array, which the caller tracks itself.
"""
function getLValuePathAsArrayIndex(x::APValue, i::Integer)
    @check_ptrs x
    @assert isLValue(x) "getLValuePathAsArrayIndex requires an lvalue"
    @assert hasLValuePath(x) "lvalue carries no designator path"
    @assert 0 <= i < getLValuePathLength(x) "designator path index out of range"
    return clang_APValue_getLValuePathAsArrayIndex(x, i)
end

"""
    getMemberPointerPathSize(x::APValue) -> UInt32
Return the length of the class chain recorded for a pointer to a member of a derived
class; zero for a plain member pointer. `APValue::getMemberPointerPath` asserts
`isMemberPointer()`.
"""
function getMemberPointerPathSize(x::APValue)
    @check_ptrs x
    @assert isMemberPointer(x) "getMemberPointerPathSize requires a member pointer value"
    return clang_APValue_getMemberPointerPathSize(x)
end

# `i` is a 0-based index into that class chain.
function getMemberPointerPathEntry(x::APValue, i::Integer)
    @check_ptrs x
    @assert isMemberPointer(x) "getMemberPointerPathEntry requires a member pointer value"
    @assert 0 <= i < getMemberPointerPathSize(x) "member pointer path index out of range"
    return CXXRecordDecl(clang_APValue_getMemberPointerPathEntry(x, i))
end


"""
    isLValueBaseTypeInfo(x::APValue) -> Bool
Return whether the lvalue's base designator is a `typeid(T)` expression. Such a base only
exists while a constant expression is being folded, so a completed constant reads `false`.
`APValue::getLValueBase` asserts `isLValue()`.
"""
function isLValueBaseTypeInfo(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "isLValueBaseTypeInfo requires an lvalue"
    return clang_APValue_isLValueBaseTypeInfo(x)
end

"""
    getLValueBaseTypeInfoOperand(x::APValue) -> Type_
Return the operand type `T` of the `typeid(T)` the lvalue is based on. The C shim reads the
`TypeInfoLValue` arm of the base's union without checking it, so the base must be a `typeid`
designator. The result is the unresolved base carrier — `resolve` it to refine.
"""
function getLValueBaseTypeInfoOperand(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseTypeInfoOperand requires an lvalue"
    @assert isLValueBaseTypeInfo(x) "the lvalue base must be a typeid() designator"
    return Type_(clang_APValue_getLValueBaseTypeInfoOperand(x))
end

"""
    getLValueBaseTypeInfoType(x::APValue) -> QualType
Return the `std::type_info` type the lvalue itself has.
`APValue::LValueBase::getTypeInfoType` asserts that the base is a `typeid` designator.
"""
function getLValueBaseTypeInfoType(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseTypeInfoType requires an lvalue"
    @assert isLValueBaseTypeInfo(x) "the lvalue base must be a typeid() designator"
    return QualType(clang_APValue_getLValueBaseTypeInfoType(x))
end

"""
    isLValueBaseDynamicAlloc(x::APValue) -> Bool
Return whether the lvalue's base designator is a constant-evaluation heap allocation. Such
a base never survives into a completed constant, so a folded value reads `false`.
"""
function isLValueBaseDynamicAlloc(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "isLValueBaseDynamicAlloc requires an lvalue"
    return clang_APValue_isLValueBaseDynamicAlloc(x)
end

"""
    getLValueBaseDynamicAllocIndex(x::APValue) -> UInt32
Return the index of the constant-evaluation allocation the lvalue is based on. The C shim
reads the `DynamicAllocLValue` arm of the base's union without checking it, so the base must
be a dynamic allocation.
"""
function getLValueBaseDynamicAllocIndex(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseDynamicAllocIndex requires an lvalue"
    @assert isLValueBaseDynamicAlloc(x) "the lvalue base must be a dynamic allocation"
    return clang_APValue_getLValueBaseDynamicAllocIndex(x)
end

"""
    getLValueBaseDynamicAllocType(x::APValue) -> QualType
Return the type the constant-evaluation allocation was made at.
`APValue::LValueBase::getDynamicAllocType` asserts that the base is a dynamic allocation.
"""
function getLValueBaseDynamicAllocType(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseDynamicAllocType requires an lvalue"
    @assert isLValueBaseDynamicAlloc(x) "the lvalue base must be a dynamic allocation"
    return QualType(clang_APValue_getLValueBaseDynamicAllocType(x))
end

"""
    getMaxIndex() -> UInt32
Return the largest index `clang::DynamicAllocLValue` can encode. The class itself has no
carrier — every dynamic-allocation lvalue reachable from here lives inside an `APValue`'s
lvalue base and is read through `getLValueBaseDynamicAllocIndex`.
"""
getMaxIndex() = clang_DynamicAllocLValue_getMaxIndex()


"""
    getProfileHash(x::APValue) -> UInt32
Return the hash of the value's `llvm::FoldingSetNodeID` profile.

`llvm::FoldingSetNodeID` has no carrier of its own, so `APValue::Profile` is exposed as the
scalar it is useful for: two values with the same profile always hash equal, two different
ones only on a collision. Total over every kind.
"""
function getProfileHash(x::APValue)
    @check_ptrs x
    return clang_APValue_getProfileHash(x)
end

"""
    getLValueBaseProfileHash(x::APValue) -> UInt32
Return the hash of the base designator's own profile (`APValue::LValueBase::Profile`), which
covers the base together with its call index and version, but neither the byte offset nor
the designator path. `APValue::getLValueBase` requires an lvalue.
"""
function getLValueBaseProfileHash(x::APValue)
    @check_ptrs x
    @assert isLValue(x) "getLValueBaseProfileHash requires an lvalue"
    return clang_APValue_getLValueBaseProfileHash(x)
end

"""
    getLValuePathAsBaseOrMember(x::APValue, i::Integer) -> Decl
Read the `i`-th (0-based) designator-path entry as the base class or member it designates.

A path entry is a bare 64-bit word: this reading is the meaningful one only while the type
reached so far is a class type, which the caller tracks itself — on an array entry the
stored index is reinterpreted as a pointer. The result carries the entry's static type,
`Decl`; refine it with the `castTo*` family.
"""
function getLValuePathAsBaseOrMember(x::APValue, i::Integer)
    @check_ptrs x
    @assert isLValue(x) "getLValuePathAsBaseOrMember requires an lvalue"
    @assert hasLValuePath(x) "lvalue carries no designator path"
    @assert 0 <= i < getLValuePathLength(x) "designator path index out of range"
    return Decl(clang_APValue_getLValuePathAsBaseOrMember(x, i))
end

# Whether the record the `i`-th designator-path entry designates is a virtual base. Same
# reading caveat as `getLValuePathAsBaseOrMember`.
function isLValuePathBaseOrMemberVirtual(x::APValue, i::Integer)
    @check_ptrs x
    @assert isLValue(x) "isLValuePathBaseOrMemberVirtual requires an lvalue"
    @assert hasLValuePath(x) "lvalue carries no designator path"
    @assert 0 <= i < getLValuePathLength(x) "designator path index out of range"
    return clang_APValue_isLValuePathBaseOrMemberVirtual(x, i)
end

"""
    getLValuePathEntryProfileHash(x::APValue, i::Integer) -> UInt32
Return the hash of the `i`-th designator-path entry's profile
(`APValue::LValuePathEntry::Profile`), the same reduction `getProfileHash` applies to a whole
value. Two entries designating the same base, member or array index hash equal.
"""
function getLValuePathEntryProfileHash(x::APValue, i::Integer)
    @check_ptrs x
    @assert isLValue(x) "getLValuePathEntryProfileHash requires an lvalue"
    @assert hasLValuePath(x) "lvalue carries no designator path"
    @assert 0 <= i < getLValuePathLength(x) "designator path index out of range"
    return clang_APValue_getLValuePathEntryProfileHash(x, i)
end

"""
    setInt(x::APValue, v::LibClangEx.LLVMGenericValueRef, is_unsigned::Bool)
Overwrite the integer leaf of `x` with the bits of `v` — an `LLVMGenericValueRef` on the same
APSInt bridge `getInt` returns on — taking from `is_unsigned` the signedness the bridge
cannot carry.

The bit width crosses unchanged, so keep it the width of the type the value was evaluated
at. `APValue::setInt` asserts `isInt()` and never changes the kind; `v` stays caller-owned.
"""
function setInt(x::APValue, v::LibClangEx.LLVMGenericValueRef, is_unsigned::Bool)
    @check_ptrs x
    @assert isInt(x) "setInt requires an integer value"
    return clang_APValue_setInt(x, v, is_unsigned)
end

"""
    setFloat(x::APValue, v::LibClangEx.LLVMGenericValueRef)
Overwrite the floating-point leaf of `x` with the raw bits of `v`, the same bit pattern
`getFloat` hands back (`APFloat::bitcastToAPInt`).

The semantics are taken from the value's current float, which is the only description of
them the bridge carries, and the incoming bits are zero-extended or truncated to that width.
`APValue::setFloat` asserts `isFloat()` and never changes the kind; `v` stays caller-owned.
"""
function setFloat(x::APValue, v::LibClangEx.LLVMGenericValueRef)
    @check_ptrs x
    @assert isFloat(x) "setFloat requires a floating-point value"
    return clang_APValue_setFloat(x, v)
end

"""
    setComplexInt(x::APValue, real::LibClangEx.LLVMGenericValueRef,
                  imag::LibClangEx.LLVMGenericValueRef, is_unsigned::Bool)
Overwrite both halves of a complex integer value with the bits of `real` and `imag`.

`APValue::setComplexInt` asserts that the halves share a bit width, so both are normalized
to the width of the value's current real half. `real` and `imag` stay caller-owned.
"""
function setComplexInt(x::APValue, real::LibClangEx.LLVMGenericValueRef,
                       imag::LibClangEx.LLVMGenericValueRef, is_unsigned::Bool)
    @check_ptrs x
    @assert isComplexInt(x) "setComplexInt requires a complex integer value"
    return clang_APValue_setComplexInt(x, real, imag, is_unsigned)
end

"""
    setComplexFloat(x::APValue, real::LibClangEx.LLVMGenericValueRef,
                    imag::LibClangEx.LLVMGenericValueRef)
Overwrite both halves of a complex floating-point value with the raw bits of `real` and
`imag`, the same bit patterns `getComplexFloatReal`/`getComplexFloatImag` hand back.

Both halves take the semantics of the value's current real half, which is also what
`APValue::setComplexFloat`'s same-semantics assertion wants. `real` and `imag` stay
caller-owned.
"""
function setComplexFloat(x::APValue, real::LibClangEx.LLVMGenericValueRef,
                         imag::LibClangEx.LLVMGenericValueRef)
    @check_ptrs x
    @assert isComplexFloat(x) "setComplexFloat requires a complex floating-point value"
    return clang_APValue_setComplexFloat(x, real, imag)
end

"""
    setUnion(x::APValue, field::AbstractFieldDecl, value::APValue)
Make `field` the active member of the union value `x` and copy `value` into its payload.

`value` stays caller-owned and may be an element borrowed from another `APValue`; a `field`
wrapping `C_NULL` leaves the union with no active member. `APValue::setUnion` asserts
`isUnion()`.
"""
function setUnion(x::APValue, field::AbstractFieldDecl, value::APValue)
    @check_ptrs x value
    @assert isUnion(x) "setUnion requires a union value"
    return clang_APValue_setUnion(x, field, value)
end
