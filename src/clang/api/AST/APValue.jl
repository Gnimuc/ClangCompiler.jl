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
