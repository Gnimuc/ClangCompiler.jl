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
