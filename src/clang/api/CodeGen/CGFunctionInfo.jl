# ABIArgInfo
"""
    getKind(x::AbstractABIArgInfo) -> CXABIArgInfo_Kind
How clang passes this argument (or returns this value): directly in registers, indirectly
through a hidden pointer, expanded into its fields, ignored, and so on.

`ABIArgInfo` is a tagged union and this is its tag. Every other accessor below reads a
field only some kinds have, so this is what decides which of them may be called.
"""
function getKind(x::AbstractABIArgInfo)
    @check_ptrs x
    return clang_ABIArgInfo_getKind(x)
end

"""
    getDirectOffset(x::AbstractABIArgInfo) -> Cuint
The byte offset into the memory representation at which the passed value starts.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Direct` or `CXABIArgInfo_Extend` — the field is
a union member that holds an alignment or an inalloca index for the other kinds, and clang
asserts on them.
"""
function getDirectOffset(x::AbstractABIArgInfo)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXABIArgInfo_Direct || k == CXABIArgInfo_Extend "getDirectOffset needs a Direct or Extend argument, got $k"
    return clang_ABIArgInfo_getDirectOffset(x)
end

"""
    getDirectAlign(x::AbstractABIArgInfo) -> Cuint
The alignment the direct value is passed with; 0 means the target default.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Direct` or `CXABIArgInfo_Extend`.
"""
function getDirectAlign(x::AbstractABIArgInfo)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXABIArgInfo_Direct || k == CXABIArgInfo_Extend "getDirectAlign needs a Direct or Extend argument, got $k"
    return clang_ABIArgInfo_getDirectAlign(x)
end

"""
    isSignExt(x::AbstractABIArgInfo) -> Bool
Whether the narrow integer argument is sign-extended (rather than zero-extended) to the
register width.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Extend`.
"""
function isSignExt(x::AbstractABIArgInfo)
    @check_ptrs x
    @assert getKind(x) == CXABIArgInfo_Extend "isSignExt needs an Extend argument, got $(getKind(x))"
    return clang_ABIArgInfo_isSignExt(x)
end

"""
    getPaddingType(x::AbstractABIArgInfo) -> LLVM.API.LLVMTypeRef
The type of the dummy argument emitted before the real one, or a null reference when there
is none. Total over every kind: the kinds that cannot carry padding answer null.

The raw reference is returned rather than an `LLVM.LLVMType`, matching
[`convertTypeForMemory`](@ref); wrap it with `LLVM.LLVMType` once it is known non-null.
"""
function getPaddingType(x::AbstractABIArgInfo)
    @check_ptrs x
    return clang_ABIArgInfo_getPaddingType(x)
end

"""
    getCoerceToType(x::AbstractABIArgInfo) -> LLVM.API.LLVMTypeRef
The LLVM type the argument is actually passed as, which need not be the argument's own
converted type — this is where a small struct becomes an integer pair. A null reference
means "no coercion", i.e. the converted type is used as is.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Direct`, `CXABIArgInfo_Extend` or
`CXABIArgInfo_CoerceAndExpand`; the other kinds store an unrelated pointer in that field.
"""
function getCoerceToType(x::AbstractABIArgInfo)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXABIArgInfo_Direct || k == CXABIArgInfo_Extend ||
            k == CXABIArgInfo_CoerceAndExpand "getCoerceToType needs a Direct, Extend or CoerceAndExpand argument, got $k"
    return clang_ABIArgInfo_getCoerceToType(x)
end

"""
    getIndirectAlign(x::AbstractABIArgInfo) -> Int64
The alignment of the hidden pointer, in chars; 0 means the target default.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Indirect` or `CXABIArgInfo_IndirectAliased`.
"""
function getIndirectAlign(x::AbstractABIArgInfo)
    @check_ptrs x
    k = getKind(x)
    @assert k == CXABIArgInfo_Indirect || k == CXABIArgInfo_IndirectAliased "getIndirectAlign needs an Indirect or IndirectAliased argument, got $k"
    return clang_ABIArgInfo_getIndirectAlign(x)
end

"""
    getIndirectByVal(x::AbstractABIArgInfo) -> Bool
Whether the hidden pointer carries the IR `byval` attribute — the callee gets its own copy
and may modify it.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Indirect`.
"""
function getIndirectByVal(x::AbstractABIArgInfo)
    @check_ptrs x
    @assert getKind(x) == CXABIArgInfo_Indirect "getIndirectByVal needs an Indirect argument, got $(getKind(x))"
    return clang_ABIArgInfo_getIndirectByVal(x)
end

"""
    isSRetAfterThis(x::AbstractABIArgInfo) -> Bool
Whether the hidden return pointer is passed after `this` instead of before it, as the
Microsoft C++ ABI requires.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Indirect`.
"""
function isSRetAfterThis(x::AbstractABIArgInfo)
    @check_ptrs x
    @assert getKind(x) == CXABIArgInfo_Indirect "isSRetAfterThis needs an Indirect argument, got $(getKind(x))"
    return clang_ABIArgInfo_isSRetAfterThis(x)
end

"""
    getInAllocaFieldIndex(x::AbstractABIArgInfo) -> Cuint
The argument's slot in the inalloca struct — see [`getArgStruct`](@ref).

PRECONDITION: `getKind(x)` is `CXABIArgInfo_InAlloca`.
"""
function getInAllocaFieldIndex(x::AbstractABIArgInfo)
    @check_ptrs x
    @assert getKind(x) == CXABIArgInfo_InAlloca "getInAllocaFieldIndex needs an InAlloca argument, got $(getKind(x))"
    return clang_ABIArgInfo_getInAllocaFieldIndex(x)
end

"""
    getCanBeFlattened(x::AbstractABIArgInfo) -> Bool
Whether the coerce-to type may be split into one LLVM argument per element, rather than
passed as a single aggregate.

PRECONDITION: `getKind(x)` is `CXABIArgInfo_Direct`.
"""
function getCanBeFlattened(x::AbstractABIArgInfo)
    @check_ptrs x
    @assert getKind(x) == CXABIArgInfo_Direct "getCanBeFlattened needs a Direct argument, got $(getKind(x))"
    return clang_ABIArgInfo_getCanBeFlattened(x)
end

# CGFunctionInfo
"""
    arg_size(x::AbstractCGFunctionInfo) -> Cuint
The number of explicit arguments in the lowered signature, not counting the return value.
"""
function arg_size(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_arg_size(x)
end

"""
    getArgType(x::AbstractCGFunctionInfo, i::Integer) -> QualType
The canonical source type of the `i`-th (0-based, `i < arg_size(x)`) argument.
"""
function getArgType(x::AbstractCGFunctionInfo, i::Integer)
    @check_ptrs x
    @assert 0 <= i < arg_size(x) "argument index $i out of range"
    return QualType(clang_CGFunctionInfo_getArgType(x, i))
end

"""
    getArgInfo(x::AbstractCGFunctionInfo, i::Integer) -> ABIArgInfo
How the `i`-th (0-based, `i < arg_size(x)`) argument is passed. The result points into
`x`'s own argument buffer, so it lives exactly as long as `x` does.
"""
function getArgInfo(x::AbstractCGFunctionInfo, i::Integer)
    @check_ptrs x
    @assert 0 <= i < arg_size(x) "argument index $i out of range"
    return ABIArgInfo(clang_CGFunctionInfo_getArgInfo(x, i))
end

"""
    isVariadic(x::AbstractCGFunctionInfo) -> Bool
Whether the signature accepts arguments beyond the required ones.
"""
function isVariadic(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_isVariadic(x)
end

"""
    getNumRequiredArgs(x::AbstractCGFunctionInfo) -> Cuint
The number of arguments before the variadic `...`; equal to [`arg_size`](@ref) when the
signature is not variadic.
"""
function getNumRequiredArgs(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_getNumRequiredArgs(x)
end

"""
    isInstanceMethod(x::AbstractCGFunctionInfo) -> Bool
Whether the signature carries an implicit `this` argument.
"""
function isInstanceMethod(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_isInstanceMethod(x)
end

"""
    isNoReturn(x::AbstractCGFunctionInfo) -> Bool
Whether the function was declared not to return.
"""
function isNoReturn(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_isNoReturn(x)
end

"""
    getASTCallingConvention(x::AbstractCGFunctionInfo) -> CXCallingConv_
The calling convention as written in the source, before lowering.
"""
function getASTCallingConvention(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_getASTCallingConvention(x)
end

"""
    getCallingConvention(x::AbstractCGFunctionInfo) -> Cuint
The user-specified convention translated into an `llvm::CallingConv::ID`.
"""
function getCallingConvention(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_getCallingConvention(x)
end

"""
    getEffectiveCallingConvention(x::AbstractCGFunctionInfo) -> Cuint
The `llvm::CallingConv::ID` actually used, which the target ABI may change away from
[`getCallingConvention`](@ref).
"""
function getEffectiveCallingConvention(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_getEffectiveCallingConvention(x)
end

"""
    getReturnType(x::AbstractCGFunctionInfo) -> QualType
The canonical source type of the return value.
"""
function getReturnType(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return QualType(clang_CGFunctionInfo_getReturnType(x))
end

"""
    getReturnInfo(x::AbstractCGFunctionInfo) -> ABIArgInfo
How the return value is passed back. An `CXABIArgInfo_Indirect` kind here is the sret
case: the caller allocates the result and passes a hidden pointer to it.
"""
function getReturnInfo(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return ABIArgInfo(clang_CGFunctionInfo_getReturnInfo(x))
end

"""
    usesInAlloca(x::AbstractCGFunctionInfo) -> Bool
Whether any argument is passed with the IR `inalloca` attribute — the condition under which
[`getArgStruct`](@ref) is non-null.
"""
function usesInAlloca(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_usesInAlloca(x)
end

"""
    getArgStruct(x::AbstractCGFunctionInfo) -> LLVM.API.LLVMTypeRef
The struct holding every memory-passed argument, or a null reference when the signature
uses no inalloca arguments (see [`usesInAlloca`](@ref)).
"""
function getArgStruct(x::AbstractCGFunctionInfo)
    @check_ptrs x
    return clang_CGFunctionInfo_getArgStruct(x)
end
