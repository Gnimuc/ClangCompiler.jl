# QualType
"""
    get_qual_type(x::AbstractType) -> QualType
Return a `QualType`.
"""
get_qual_type(x::AbstractType) = getCanonicalTypeInternal(x)

"""
    get_type_ptr(x::QualType) -> CXType_
Return a `Type_`.
"""
get_type_ptr(x::QualType) = getTypePtr(x)

get_name(x::QualType) = getAsString(x)

is_const(x::QualType) = isConstQualified(x)
is_restrict(x::QualType) = isRestrictQualified(x)
is_volatile(x::QualType) = isVolatileQualified(x)

has_qualifiers(x::QualType) = hasQualifiers(x)

is_local_const(x::QualType) = isLocalConstQualified(x)
is_local_restrict(x::QualType) = isLocalRestrictQualified(x)
is_local_volatile(x::QualType) = isLocalVolatileQualified(x)

has_local_qualifiers(x::QualType) = hasLocalQualifiers(x)

add_const(x::QualType) = addConst(x)
add_restrict(x::QualType) = addRestrict(x)
add_volatile(x::QualType) = addVolatile(x)

get_canonical_type(x::QualType) = getCanonicalType(x)
