# Builtin::Context — what a builtin ID means.
#
# Every accessor here indexes clang's builtin table without a bounds check, and the ID 0
# entry (`Builtin::NotBuiltin`) carries null Type and Attributes strings that the predicates
# walk with `strchr`. So the shared precondition is `id > 0`, restated at every call site
# below, and the ID has to be one clang produced: `getBuiltinID` on an `IdentifierInfo` or a
# `FunctionDecl`. [`getFirstTSBuiltinID`](@ref) bounds the target-independent half of the
# table; above it only clang knows how many entries the target added.

"""
    getFirstTSBuiltinID() -> Int
Return `clang::Builtin::FirstTSBuiltin`, the first ID that belongs to a target-specific
builtin table. Every ID strictly between 0 and this one is in range on any target.
"""
getFirstTSBuiltinID() = Int(clang_Builtin_getFirstTSBuiltinID())

"""
    getName(x::AbstractBuiltinContext, id::Integer) -> String
Return the identifier of the builtin, e.g. `"__builtin_abs"`.
"""
function getName(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return get_string(clang_BuiltinContext_getName(x, id))
end

"""
    getTypeString(x::AbstractBuiltinContext, id::Integer) -> String
Return clang's encoding of the builtin's signature, e.g. `"v."` for a variadic `void`.
"""
function getTypeString(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return get_string(clang_BuiltinContext_getTypeString(x, id))
end

"""
    getHeaderName(x::AbstractBuiltinContext, id::Integer) -> String
Return the header a library builtin is documented to come from, e.g. `"stdio.h"`, or the
empty string for a builtin that belongs to no header.
"""
function getHeaderName(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return get_string(clang_BuiltinContext_getHeaderName(x, id))
end

"""
    isTSBuiltin(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the ID belongs to a target-specific builtin table.
"""
function isTSBuiltin(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isTSBuiltin(x, id)
end

"""
    isConst(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the builtin has no side effects and reads no memory.
"""
function isConst(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isConst(x, id)
end

"""
    isNoThrow(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the builtin is known never to throw.
"""
function isNoThrow(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isNoThrow(x, id)
end

"""
    isNoReturn(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the builtin is known never to return.
"""
function isNoReturn(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isNoReturn(x, id)
end

"""
    isPure(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the builtin has no side effects. Weaker than [`isConst`](@ref), which also
rules out reading memory.
"""
function isPure(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isPure(x, id)
end

"""
    isLibFunction(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether this is a libc/libm function spelled with the `__builtin_` prefix.
"""
function isLibFunction(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isLibFunction(x, id)
end

"""
    isPredefinedLibFunction(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether this is a libc/libm function whose signature clang knows a priori, such as
`malloc`, and which therefore behaves as if predeclared in C.
"""
function isPredefinedLibFunction(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isPredefinedLibFunction(x, id)
end

"""
    isConstWithoutErrnoAndExceptions(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether the builtin would be const if `errno` and floating-point exceptions did not
count — the condition under which `-fno-math-errno` lets clang treat it as const.
"""
function isConstWithoutErrnoAndExceptions(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_isConstWithoutErrnoAndExceptions(x, id)
end

"""
    hasPtrArgsOrResult(x::AbstractBuiltinContext, id::Integer) -> Bool
Return whether a pointer appears anywhere in the builtin's signature.
"""
function hasPtrArgsOrResult(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    return clang_BuiltinContext_hasPtrArgsOrResult(x, id)
end

"""
    isPrintfLike(x::AbstractBuiltinContext, id::Integer) -> Union{Tuple{Int,Bool},Nothing}
Return `(format_index, has_va_list_arg)` when the builtin follows printf's format rules, or
`nothing` when it does not. The index is 0-based, as clang counts arguments.
"""
function isPrintfLike(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    idx = Ref{Cuint}(0)
    valist = Ref{Bool}(false)
    clang_BuiltinContext_isPrintfLike(x, id, idx, valist) || return nothing
    return (Int(idx[]), valist[])
end

"""
    isScanfLike(x::AbstractBuiltinContext, id::Integer) -> Union{Tuple{Int,Bool},Nothing}
Return `(format_index, has_va_list_arg)` when the builtin follows scanf's format rules, or
`nothing` when it does not. The index is 0-based, as clang counts arguments.
"""
function isScanfLike(x::AbstractBuiltinContext, id::Integer)
    @check_ptrs x
    @assert id > 0 "0 is Builtin::NotBuiltin, which has no record to read"
    idx = Ref{Cuint}(0)
    valist = Ref{Bool}(false)
    clang_BuiltinContext_isScanfLike(x, id, idx, valist) || return nothing
    return (Int(idx[]), valist[])
end
