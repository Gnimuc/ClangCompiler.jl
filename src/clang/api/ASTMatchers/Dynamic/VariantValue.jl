# VariantValue and NamedValueMap (clang::ast_matchers::dynamic)
#
# The tagged union the matcher grammar's literals and named values evaluate to, and the
# dictionary a matcher expression's bare identifiers resolve against. Together they are
# clang-query's `let name = matcher`: parse a matcher once, name it, and spell the name
# inside later query strings.

"""
    VariantValue()
Create the empty value — the one alternative with no payload, for which
[`hasValue`](@ref) is `false` and every getter below is out of bounds.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue()
    ptr = clang_VariantValue_create()
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

"""
    VariantValue(x::Bool)
Create the boolean alternative.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue(x::Bool)
    ptr = clang_VariantValue_createBoolean(x)
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

"""
    VariantValue(x::Integer)
Create the unsigned alternative. `x` must be a non-negative value that fits in a `UInt32`;
`Bool` is dispatched to the boolean alternative instead, matching Clang's own
disambiguation.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue(x::Integer)
    @assert 0 <= x <= typemax(UInt32) "VariantValue holds an unsigned 32-bit integer"
    ptr = clang_VariantValue_createUnsigned(x % UInt32)
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

"""
    VariantValue(x::AbstractFloat)
Create the double alternative.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue(x::AbstractFloat)
    ptr = clang_VariantValue_createDouble(x)
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

"""
    VariantValue(x::AbstractString)
Create the string alternative.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue(x::AbstractString)
    ptr = clang_VariantValue_createString(x)
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

"""
    VariantValue(x::AbstractDynTypedMatcher)
Create the matcher alternative, wrapping `x` as the unambiguous single-matcher case — which
is what a parsed matcher always is. The matcher is copied into the value, so `x` may be
disposed afterwards.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function VariantValue(x::AbstractDynTypedMatcher)
    @check_ptrs x
    ptr = clang_VariantValue_createMatcher(x)
    @assert ptr != C_NULL "Failed to create VariantValue"
    return VariantValue(ptr)
end

dispose(x::VariantValue) = clang_VariantValue_dispose(x)

"""
    hasValue(x::AbstractVariantValue) -> Bool
Return whether `x` holds any alternative at all. `false` only for the value built by
`VariantValue()`.
"""
function hasValue(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_hasValue(x)
end

"""
    isBoolean(x::AbstractVariantValue) -> Bool
Return whether `x` holds the boolean alternative.
"""
function isBoolean(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_isBoolean(x)
end

"""
    getBoolean(x::AbstractVariantValue) -> Bool
Return the boolean `x` holds.

Clang asserts the tag and reads the union member unchecked, so the tag test is restated here
as a precondition rather than left to produce a wrong value.
"""
function getBoolean(x::AbstractVariantValue)
    @check_ptrs x
    @assert isBoolean(x) "VariantValue does not hold a boolean"
    return clang_VariantValue_getBoolean(x)
end

"""
    isDouble(x::AbstractVariantValue) -> Bool
Return whether `x` holds the double alternative.
"""
function isDouble(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_isDouble(x)
end

"""
    getDouble(x::AbstractVariantValue) -> Float64
Return the double `x` holds. `x` must hold the double alternative.
"""
function getDouble(x::AbstractVariantValue)
    @check_ptrs x
    @assert isDouble(x) "VariantValue does not hold a double"
    return clang_VariantValue_getDouble(x)
end

"""
    isUnsigned(x::AbstractVariantValue) -> Bool
Return whether `x` holds the unsigned alternative.
"""
function isUnsigned(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_isUnsigned(x)
end

"""
    getUnsigned(x::AbstractVariantValue) -> Integer
Return the unsigned integer `x` holds. `x` must hold the unsigned alternative.
"""
function getUnsigned(x::AbstractVariantValue)
    @check_ptrs x
    @assert isUnsigned(x) "VariantValue does not hold an unsigned integer"
    return clang_VariantValue_getUnsigned(x)
end

"""
    isString(x::AbstractVariantValue) -> Bool
Return whether `x` holds the string alternative.
"""
function isString(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_isString(x)
end

"""
    getString(x::AbstractVariantValue) -> String
Return the string `x` holds. `x` must hold the string alternative.
"""
function getString(x::AbstractVariantValue)
    @check_ptrs x
    @assert isString(x) "VariantValue does not hold a string"
    return get_string(clang_VariantValue_getString(x))
end

"""
    isMatcher(x::AbstractVariantValue) -> Bool
Return whether `x` holds the matcher alternative.
"""
function isMatcher(x::AbstractVariantValue)
    @check_ptrs x
    return clang_VariantValue_isMatcher(x)
end

"""
    getSingleMatcher(x::AbstractVariantValue) -> DynTypedMatcher
Return a copy of the single matcher `x` holds, or a null handle when `x` is not a matcher at
all *or* holds a polymorphic matcher with no unambiguous single representation.

Unlike the getters above this one is total: the null return already carries the tag mismatch,
so no precondition is imposed.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getSingleMatcher(x::AbstractVariantValue)
    @check_ptrs x
    return DynTypedMatcher(clang_VariantValue_getSingleMatcher(x))
end

"""
    getTypeAsString(x::AbstractVariantValue) -> String
Return the name of the alternative held — `"String"`, `"Matcher<Decl>"`, `"Nothing"` — for
diagnostics. Total: defined for every value including the empty one.
"""
function getTypeAsString(x::AbstractVariantValue)
    @check_ptrs x
    return get_string(clang_VariantValue_getTypeAsString(x))
end

"""
    NamedValueMap()
Create the dictionary a matcher expression's bare identifiers resolve against, for
[`parseMatcherExpression`](@ref) and [`completeExpression`](@ref).

This function allocates and one should call `dispose` to release the resources after using
this object. The values it holds are its own copies and die with it.
"""
function NamedValueMap()
    ptr = clang_NamedValueMap_create()
    @assert ptr != C_NULL "Failed to create NamedValueMap"
    return NamedValueMap(ptr)
end

dispose(x::NamedValueMap) = clang_NamedValueMap_dispose(x)

"""
    set(x::AbstractNamedValueMap, name::AbstractString, value::AbstractVariantValue)
Bind `name` to `value`, replacing any previous binding. `value` is copied into the map and may
be disposed afterwards.
"""
function set(x::AbstractNamedValueMap, name::AbstractString, value::AbstractVariantValue)
    @check_ptrs x value
    return clang_NamedValueMap_set(x, name, value)
end

"""
    size(x::AbstractNamedValueMap) -> Integer
Return how many names are bound.
"""
function Base.size(x::AbstractNamedValueMap)
    @check_ptrs x
    return clang_NamedValueMap_size(x)
end

"""
    contains(x::AbstractNamedValueMap, name::AbstractString) -> Bool
Return whether `name` is bound, i.e. whether a query string may spell it.
"""
function Base.contains(x::AbstractNamedValueMap, name::AbstractString)
    @check_ptrs x
    return clang_NamedValueMap_contains(x, name)
end
