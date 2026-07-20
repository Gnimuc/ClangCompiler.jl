"""
    struct TypeLoc <: AbstractTypeLoc
Hold a pointer to a heap-boxed `clang::TypeLoc` object.
"""
struct TypeLoc <: AbstractTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::TypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::TypeLoc) = x
# The payload carriers below hold the SAME kind of handle as `TypeLoc` — a
# heap-boxed `clang::TypeLoc` — because clang's TypeLoc subclasses are value
# views over one two-word object, not distinct pointees. A carrier's Julia type
# records its established TypeLoc class (faithful-carrier invariant): construct
# one only through the class-checked castTo wrappers (NULL carrier on a class
# mismatch) or `resolve`. Every non-NULL carrier is an owned box and `dispose`
# works uniformly across the family. `TypeLoc` itself predates the hierarchy
# and stays outside the abstract tree; `AnyTypeLoc` is the receiver type for
# methods `clang::TypeLoc` declares.
const AnyTypeLoc = Union{TypeLoc,AbstractTypeLoc}

"""
    struct QualifiedTypeLoc <: AbstractQualifiedTypeLoc
Hold a pointer to a `clang::QualifiedTypeLoc` object.
"""
struct QualifiedTypeLoc <: AbstractQualifiedTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::QualifiedTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::QualifiedTypeLoc) = x

"""
    struct TypeSpecTypeLoc <: AbstractTypeSpecTypeLoc
Hold a pointer to a `clang::TypeSpecTypeLoc` object.
"""
struct TypeSpecTypeLoc <: AbstractTypeSpecTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::TypeSpecTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::TypeSpecTypeLoc) = x

"""
    struct BuiltinTypeLoc <: AbstractBuiltinTypeLoc
Hold a pointer to a `clang::BuiltinTypeLoc` object.
"""
struct BuiltinTypeLoc <: AbstractBuiltinTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::BuiltinTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::BuiltinTypeLoc) = x

"""
    struct AttributedTypeLoc <: AbstractAttributedTypeLoc
Hold a pointer to a `clang::AttributedTypeLoc` object.
"""
struct AttributedTypeLoc <: AbstractAttributedTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::AttributedTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::AttributedTypeLoc) = x

"""
    struct ParenTypeLoc <: AbstractParenTypeLoc
Hold a pointer to a `clang::ParenTypeLoc` object.
"""
struct ParenTypeLoc <: AbstractParenTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::ParenTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::ParenTypeLoc) = x

"""
    struct AdjustedTypeLoc <: AbstractAdjustedTypeLoc
Hold a pointer to a `clang::AdjustedTypeLoc` object.
"""
struct AdjustedTypeLoc <: AbstractAdjustedTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::AdjustedTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::AdjustedTypeLoc) = x

"""
    struct PointerTypeLoc <: AbstractPointerTypeLoc
Hold a pointer to a `clang::PointerTypeLoc` object.
"""
struct PointerTypeLoc <: AbstractPointerTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::PointerTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::PointerTypeLoc) = x

"""
    struct MemberPointerTypeLoc <: AbstractMemberPointerTypeLoc
Hold a pointer to a `clang::MemberPointerTypeLoc` object.
"""
struct MemberPointerTypeLoc <: AbstractMemberPointerTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::MemberPointerTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::MemberPointerTypeLoc) = x

"""
    struct LValueReferenceTypeLoc <: AbstractLValueReferenceTypeLoc
Hold a pointer to a `clang::LValueReferenceTypeLoc` object.
"""
struct LValueReferenceTypeLoc <: AbstractLValueReferenceTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::LValueReferenceTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::LValueReferenceTypeLoc) = x

"""
    struct RValueReferenceTypeLoc <: AbstractRValueReferenceTypeLoc
Hold a pointer to a `clang::RValueReferenceTypeLoc` object.
"""
struct RValueReferenceTypeLoc <: AbstractRValueReferenceTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::RValueReferenceTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::RValueReferenceTypeLoc) = x

"""
    struct FunctionTypeLoc <: AbstractFunctionTypeLoc
Hold a pointer to a `clang::FunctionTypeLoc` object.
"""
struct FunctionTypeLoc <: AbstractFunctionTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::FunctionTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::FunctionTypeLoc) = x

"""
    struct ArrayTypeLoc <: AbstractArrayTypeLoc
Hold a pointer to a `clang::ArrayTypeLoc` object.
"""
struct ArrayTypeLoc <: AbstractArrayTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::ArrayTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::ArrayTypeLoc) = x

"""
    struct TemplateSpecializationTypeLoc <: AbstractTemplateSpecializationTypeLoc
Hold a pointer to a `clang::TemplateSpecializationTypeLoc` object.
"""
struct TemplateSpecializationTypeLoc <: AbstractTemplateSpecializationTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::TemplateSpecializationTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::TemplateSpecializationTypeLoc) = x

"""
    struct ElaboratedTypeLoc <: AbstractElaboratedTypeLoc
Hold a pointer to a `clang::ElaboratedTypeLoc` object.
"""
struct ElaboratedTypeLoc <: AbstractElaboratedTypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::ElaboratedTypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::ElaboratedTypeLoc) = x
