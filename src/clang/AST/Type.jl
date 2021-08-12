"""
    abstract type AbstractClangType <: Any
Supertype for `clang::Type`s.
"""
abstract type AbstractClangType end

"""
    abstract type AbstractBuiltinType <: AbstractClangType
Supertype for `clang::BuiltinType`s.
"""
abstract type AbstractBuiltinType <: AbstractClangType end

"""
    QualType <: AbstractClangType
Represent a qualified type.
"""
struct QualType <: AbstractClangType
    ptr::CXQualType
end
QualType(x::T) where {T<:AbstractBuiltinType} = QualType(x.ptr)

get_type_ptr(x::QualType)::CXType_ = clang_QualType_getTypePtr(x.ptr)
get_type_ptr_or_null(x::QualType)::CXType_ = clang_QualType_getTypePtrOrNull(x.ptr)

is_canonical(x::QualType) = clang_QualType_isCanonical(x.ptr)

is_null(x::QualType) = clang_QualType_isNull(x.ptr)

is_const_qualified(x::QualType) = clang_QualType_isConstQualified(x.ptr)
is_restrict_qualified(x::QualType) = clang_QualType_isRestrictQualified(x.ptr)
is_volatile_qualified(x::QualType) = clang_QualType_isVolatileQualified(x.ptr)

is_const(x::QualType) = is_const_qualified(x)
is_restrict(x::QualType) = is_restrict_qualified(x)
is_volatile(x::QualType) = is_volatile_qualified(x)

has_qualifiers(x::QualType) = clang_QualType_hasQualifiers(x.ptr)

is_local_const_qualified(x::QualType) = clang_QualType_isLocalConstQualified(x.ptr)
is_local_restrict_qualified(x::QualType) = clang_QualType_isLocalRestrictQualified(x.ptr)
is_local_volatile_qualified(x::QualType) = clang_QualType_isLocalVolatileQualified(x.ptr)

is_local_const(x::QualType) = is_local_const_qualified(x)
is_local_restrict(x::QualType) = is_local_restrict_qualified(x)
is_local_volatile(x::QualType) = is_local_volatile_qualified(x)

has_local_qualifiers(x::QualType) = clang_QualType_hasLocalQualifiers(x.ptr)

with_const(x::QualType) = QualType(clang_QualType_withConst(x.ptr))
with_restrict(x::QualType) = QualType(clang_QualType_withRestrict(x.ptr))
with_volatile(x::QualType) = QualType(clang_QualType_withVolatile(x.ptr))

add_const(x::QualType) = clang_QualType_addConst(x.ptr)
add_restrict(x::QualType) = clang_QualType_addRestrict(x.ptr)
add_volatile(x::QualType) = clang_QualType_addVolatile(x.ptr)

get_canonical_type(x::QualType) = QualType(clang_QualType_getCanonicalType(x.ptr))
get_canonical_unqualified_type(x::QualType) = QualType(clang_QualType_getLocalUnqualifiedType(x.ptr))
get_unqualified_type(x::QualType) = QualType(clang_QualType_getUnqualifiedType(x.ptr))

function get_string(x::QualType)
    str = clang_QualType_getAsString(x.ptr)
    s = unsafe_string(str)
    clang_QualType_disposeString(str)
    return s
end

dump(x::QualType) = clang_QualType_dump(x.ptr)

"""
    CanQualType <: AbstractClangType
Represent a canonical, qualified type.
"""
struct CanQualType <: AbstractClangType
    ty::QualType
end
CanQualType(x::CXQualType) = CanQualType(QualType(x))

struct VoidTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct BoolTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct CharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WideCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct WIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char8Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Char32Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct SignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct ShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct IntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Int128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedCharTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedShortTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedIntTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedLongLongTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct UnsignedInt128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct FloatTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct DoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongDoubleTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float128Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct HalfTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct BFloat16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float16Ty <: AbstractBuiltinType
    ptr::CXQualType
end

struct FloatComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct DoubleComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct LongDoubleComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct Float128ComplexTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct VoidPtrTy <: AbstractBuiltinType
    ptr::CXQualType
end

struct NullPtrTy <: AbstractBuiltinType
    ptr::CXQualType
end
