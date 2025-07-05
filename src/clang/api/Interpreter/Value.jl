create_value() = Value(clang_value_create())

dispose(x::AbstractValue) = clang_value_dispose(x)

function getType(x::AbstractValue)
    @check_ptrs x
    return clang_value_getType(x)
end

function isManuallyAlloc(x::AbstractValue)
    @check_ptrs x
    return clang_value_isManuallyAlloc(x)
end

function getKind(x::AbstractValue)
    @check_ptrs x
    return clang_value_getKind(x)
end

function setKind(x::AbstractValue, kind::CXValueKind)
    @check_ptrs x
    clang_value_setKind(x, kind)
end

function getPtr(x::AbstractValue)
    @check_ptrs x
    return clang_value_getPtr(x)
end

function setPtr(x::AbstractValue, ptr::Ptr{Cvoid})
    @check_ptrs x
    clang_value_setPtr(x, ptr)
end

function isValid(x::AbstractValue)
    @check_ptrs x
    return clang_value_isValid(x)
end

function isVoid(x::AbstractValue)
    @check_ptrs x
    return clang_value_isVoid(x)
end

function hasValue(x::AbstractValue)
    @check_ptrs x
    return clang_value_hasValue(x)
end

function setBool(x::AbstractValue, b)
    @check_ptrs x
    clang_value_setBool(x, b)
end

function getBool(x::AbstractValue)
    @check_ptrs x
    return clang_value_getBool(x)
end

function setChar_S(x::AbstractValue, c)
    @check_ptrs x
    clang_value_setChar_S(x, c)
end

function getChar_S(x::AbstractValue)
    @check_ptrs x
    return clang_value_getChar_S(x)
end

function setSChar(x::AbstractValue, c)
    @check_ptrs x
    clang_value_setSChar(x, c)
end

function getSChar(x::AbstractValue)
    @check_ptrs x
    return clang_value_getSChar(x)
end

function setUChar(x::AbstractValue, c)
    @check_ptrs x
    clang_value_setUChar(x, c)
end

function getUChar(x::AbstractValue)
    @check_ptrs x
    return clang_value_getUChar(x)
end

function setShort(x::AbstractValue, s)
    @check_ptrs x
    clang_value_setShort(x, s)
end

function getShort(x::AbstractValue)
    @check_ptrs x
    return clang_value_getShort(x)
end

function setUShort(x::AbstractValue, s)
    @check_ptrs x
    clang_value_setUShort(x, s)
end

function getUShort(x::AbstractValue)
    @check_ptrs x
    return clang_value_getUShort(x)
end

function setInt(x::AbstractValue, i)
    @check_ptrs x
    clang_value_setInt(x, i)
end

function getInt(x::AbstractValue)
    @check_ptrs x
    return clang_value_getInt(x)
end

function setUInt(x::AbstractValue, i)
    @check_ptrs x
    clang_value_setUInt(x, i)
end

function getUInt(x::AbstractValue)
    @check_ptrs x
    return clang_value_getUInt(x)
end

function setLong(x::AbstractValue, l)
    @check_ptrs x
    clang_value_setLong(x, l)
end

function getLong(x::AbstractValue)
    @check_ptrs x
    return clang_value_getLong(x)
end

function setULong(x::AbstractValue, l)
    @check_ptrs x
    clang_value_setULong(x, l)
end

function getULong(x::AbstractValue)
    @check_ptrs x
    return clang_value_getULong(x)
end

function setLongLong(x::AbstractValue, ll)
    @check_ptrs x
    clang_value_setLongLong(x, ll)
end

function getLongLong(x::AbstractValue)
    @check_ptrs x
    return clang_value_getLongLong(x)
end

function setULongLong(x::AbstractValue, ll)
    @check_ptrs x
    clang_value_setULongLong(x, ll)
end

function getULongLong(x::AbstractValue)
    @check_ptrs x
    return clang_value_getULongLong(x)
end

function setFloat(x::AbstractValue, f)
    @check_ptrs x
    clang_value_setFloat(x, f)
end

function getFloat(x::AbstractValue)
    @check_ptrs x
    return clang_value_getFloat(x)
end

function setDouble(x::AbstractValue, d)
    @check_ptrs x
    clang_value_setDouble(x, d)
end

function getDouble(x::AbstractValue)
    @check_ptrs x
    return clang_value_getDouble(x)
end

function setLongDouble(x::AbstractValue, ld)
    @check_ptrs x
    clang_value_setLongDouble(x, ld)
end

function getLongDouble(x::AbstractValue)
    @check_ptrs x
    return clang_value_getLongDouble(x)
end
