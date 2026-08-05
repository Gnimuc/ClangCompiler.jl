create_value() = Value(clang_Value_create())
"""
    createValueFromType(interp::AbstractInterpreter, ty::QualType) -> Value
Create a value whose kind is derived from the qualified type, which must belong to the
interpreter's AST context. This function allocates and one should call `dispose` to release
the resources after using this object.
"""
function createValueFromType(interp::AbstractInterpreter, ty::QualType)
    @check_ptrs interp ty
    # `Value` stores the type as clang's own opaque `void *`, so the shim's parameter is
    # `void *` and the QualType handle is unwrapped here rather than marshalled.
    return Value(clang_createValueFromType(interp, Ptr{Cvoid}(ty.ptr)))
end

dispose(x::AbstractValue) = clang_Value_dispose(x)

function getType(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getType(x)
end

function isManuallyAlloc(x::AbstractValue)
    @check_ptrs x
    return clang_Value_isManuallyAlloc(x)
end

function getKind(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getKind(x)
end

function setKind(x::AbstractValue, kind::CXValueKind)
    @check_ptrs x
    clang_Value_setKind(x, kind)
end

function setOpaqueType(x::AbstractValue, ty::QualType)
    @check_ptrs x ty
    # see `createValueFromType`: the opaque type is a `void *` on both sides of the shim
    return clang_Value_setOpaqueType(x, Ptr{Cvoid}(ty.ptr))
end
function getPtr(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getPtr(x)
end

function setPtr(x::AbstractValue, ptr::Ptr{Cvoid})
    @check_ptrs x
    clang_Value_setPtr(x, ptr)
end

function isValid(x::AbstractValue)
    @check_ptrs x
    return clang_Value_isValid(x)
end

function isVoid(x::AbstractValue)
    @check_ptrs x
    return clang_Value_isVoid(x)
end

function hasValue(x::AbstractValue)
    @check_ptrs x
    return clang_Value_hasValue(x)
end

function setBool(x::AbstractValue, b)
    @check_ptrs x
    clang_Value_setBool(x, b)
end

function getBool(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getBool(x)
end

function setChar_S(x::AbstractValue, c)
    @check_ptrs x
    clang_Value_setChar_S(x, c)
end

function getChar_S(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getChar_S(x)
end

function setSChar(x::AbstractValue, c)
    @check_ptrs x
    clang_Value_setSChar(x, c)
end

function getSChar(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getSChar(x)
end

function setUChar(x::AbstractValue, c)
    @check_ptrs x
    clang_Value_setUChar(x, c)
end

function getUChar(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getUChar(x)
end

function setShort(x::AbstractValue, s)
    @check_ptrs x
    clang_Value_setShort(x, s)
end

function getShort(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getShort(x)
end

function setUShort(x::AbstractValue, s)
    @check_ptrs x
    clang_Value_setUShort(x, s)
end

function getUShort(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getUShort(x)
end

function setInt(x::AbstractValue, i)
    @check_ptrs x
    clang_Value_setInt(x, i)
end

function getInt(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getInt(x)
end

function setUInt(x::AbstractValue, i)
    @check_ptrs x
    clang_Value_setUInt(x, i)
end

function getUInt(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getUInt(x)
end

function setLong(x::AbstractValue, l)
    @check_ptrs x
    clang_Value_setLong(x, l)
end

function getLong(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getLong(x)
end

function setULong(x::AbstractValue, l)
    @check_ptrs x
    clang_Value_setULong(x, l)
end

function getULong(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getULong(x)
end

function setLongLong(x::AbstractValue, ll)
    @check_ptrs x
    clang_Value_setLongLong(x, ll)
end

function getLongLong(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getLongLong(x)
end

function setULongLong(x::AbstractValue, ll)
    @check_ptrs x
    clang_Value_setULongLong(x, ll)
end

function getULongLong(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getULongLong(x)
end

function setFloat(x::AbstractValue, f)
    @check_ptrs x
    clang_Value_setFloat(x, f)
end

function getFloat(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getFloat(x)
end

function setDouble(x::AbstractValue, d)
    @check_ptrs x
    clang_Value_setDouble(x, d)
end

function getDouble(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getDouble(x)
end

function setLongDouble(x::AbstractValue, ld)
    @check_ptrs x
    clang_Value_setLongDouble(x, ld)
end

function getLongDouble(x::AbstractValue)
    @check_ptrs x
    return clang_Value_getLongDouble(x)
end

"""
    printType(x::AbstractValue) -> String
Render the value's type the way `clang::Value` prints it.

clang 18 ships a placeholder body for this accessor: the text is a fixed "not
implemented" line rather than the type's spelling, and it reads nothing out of the
value. Only the presence of text is stable across LLVM versions.
"""
function printType(x::AbstractValue)
    @check_ptrs x
    return get_string(clang_Value_printType(x))
end

"""
    printData(x::AbstractValue) -> String
Render the value's payload the way `clang::Value` prints it.

As with [`printType`](@ref), clang 18 ships a placeholder body here — assert on the
shape of the result, never on its content.
"""
function printData(x::AbstractValue)
    @check_ptrs x
    return get_string(clang_Value_printData(x))
end

"""
    print(x::AbstractValue) -> String
Render the value — type and payload — the way `clang::Value` prints it.

As with [`printType`](@ref), clang 18 ships a placeholder body here — assert on the
shape of the result, never on its content.
"""
function print(x::AbstractValue)
    @check_ptrs x
    return get_string(clang_Value_print(x))
end

"""
    dump(x::AbstractValue)
Print the value to `llvm::outs()`.
"""
function dump(x::AbstractValue)
    @check_ptrs x
    return clang_Value_dump(x)
end

"""
    clear(x::AbstractValue)
Reset the value to the unspecified kind. It drops the opaque type, the owning
interpreter and — when the storage was manually allocated — the storage itself, so
afterwards `isValid(x)` is `false` and `getInterpreter(x)` holds NULL.
"""
function clear(x::AbstractValue)
    @check_ptrs x
    return clang_Value_clear(x)
end

"""
    getInterpreter(x::AbstractValue) -> Interpreter
Return the interpreter that produced the value. The returned carrier holds NULL for a
default-constructed value (`create_value()`) and for one that has been [`clear`](@ref)ed.
"""
function getInterpreter(x::AbstractValue)
    @check_ptrs x
    return Interpreter(clang_Value_getInterpreter(x))
end

"""
    getASTContext(x::AbstractValue) -> ASTContext
Return the AST context of the interpreter that produced the value.

`clang::Value::getASTContext` dereferences the value's `Interpreter *` member without
checking it, and that member is null in a default-constructed value and after
[`clear`](@ref), so `x` must still carry an interpreter.
"""
function getASTContext(x::AbstractValue)
    @check_ptrs x
    @assert getInterpreter(x).ptr != C_NULL "value must carry an interpreter"
    return ASTContext(clang_Value_getASTContext(x))
end
